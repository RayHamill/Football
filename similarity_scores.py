import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.decomposition import PCA

all_comps = [2, 4, 6, 9, 10, 1, 3, 7, 11, 12]
big5_comps = [2, 4, 6, 9, 10]
other_comps = [1, 3, 7, 11, 12]

similarity_stats = ['shots', 'xG', 'goals', 'key_passes', 'set_piece_key_passes', 'op_xA', 'passes',
                    'pass_completion_pc', 'crosses', 'cross_completion_pc', 'progressive_passes',
                    'deep_progression_passes', 'progressive_carries', 'deep_progression_carries', 'touches', 'carries',
                    'op_pass_box_progressions', 'box_progression_carries',  'Successful Tackles', 'Tackle Percentage',
                    'Interceptions', 'Ball Recoveries', 'Successful Aerials', 'Aerial Percentage',
                    'Successful Take Ons', 'Take On Percentage', 'turnovers', 'touches_in_box', 'touch_width',
                    'touch_depth', 'average_carry_distance', 'average_pass_distance', 'average_progression_distance',
                    'average_cross_depth', 'headed_shot_percentage']


# Standardizes data and applies PCA to deal with collinearity.
# Returns new df with principle components accounting for 95% of variance, as well as index containing player info.
def apply_pca(df, year, comps):

    df = df[(df['mins'] > 800) & (df['year'] >= year) & (df['tournament_id'].isin(comps))].set_index(
        ['player', 'team', 'year', 'age', 'tournament_id']).drop('mins', axis=1).fillna(0)
    # standardizes performance metrics
    x = StandardScaler().fit_transform(df)
    df = pd.DataFrame(x, columns=df.columns, index=df.index)

    # applies PCA
    pca = PCA(0.95)
    principal_components = pca.fit_transform(x)
    pca_df = pd.DataFrame(principal_components, index=df.index)
    index = pca_df.index
    # creates new index with string containing player name and year
    pca_df.index = pca_df.index.map('{0[0]} {0[2]}'.format)

    return pca_df, index


# Calls apply_pca, calculates distance of all players from given player, then scales between 0 (furthest point) and 1
# Filters based on input parameters, saves csv file and
def calculate_similarity(player, df, comps=all_comps, year=19, max_age=45):

    pca_df, index = apply_pca(df, year, comps)
    # p1 contains metrics from target player
    p1 = np.array(pca_df.loc[player])
    # finds distance from each player to target player
    dist_df = pd.DataFrame(pca_df.apply(lambda x: np.linalg.norm(p1 - np.array(x)), axis=1), columns=['distance'])
    dist_df.index = index
    dist_df = dist_df.reset_index()
    # adds paths to crest images for plotting later
    team_crests = pd.read_csv('data/team_crests.csv', index_col=0)
    dist_df = pd.merge(dist_df, team_crests, how='left', left_on='team', right_on='team').set_index(['player', 'team'])

    # scales distances between 0 and 1
    scaler = MinMaxScaler()
    dist_df['similarity'] = 1 - scaler.fit_transform(np.array(dist_df['distance']).reshape(-1, 1))
    dist_df = dist_df.drop('distance', axis=1)
    dist_df = dist_df[
        (dist_df['age'] <= max_age) & (dist_df['year'] >= year) &
        (dist_df['tournament_id'].isin(comps))].sort_values('similarity', ascending=False).head(20)
    dist_df.to_csv('data/player_similarity.csv')

    return dist_df['similarity']


if __name__ == '__main__':

    player_stats = pd.read_csv('data/player_stats.csv')
    player_string = 'Lionel Messi 19'
    comps = all_comps
    df = player_stats[similarity_stats+['mins', 'year', 'player', 'team', 'age','tournament_id']].reset_index(drop=True)
    similarity = calculate_similarity(player_string, df, comps)
    print(similarity.head(20))

# TODO: Add docstrings & uniqueness code.
