import pandas as pd
import numpy as np
import pickle
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV

path = 'C:/Users/Ray/Desktop/Football Data/Opta Data/Football/'


def tune_parameters(training_set, training_labels):
    # Performs grid search cv to find best combination of hyperparameters for random forest.

    param_grid = {
        'bootstrap': [True],
        'max_depth': [70, 80, 90, 100],
        'max_features': ['auto'],
        'min_samples_leaf': [1, 2],
        'min_samples_split': [4, 5, 6],
        'n_estimators': [400, 600, 800]
    }

    rf = RandomForestClassifier()
    grid_search = GridSearchCV(estimator=rf, param_grid=param_grid, cv=3, n_jobs=-1, verbose=2)
    grid_search.fit(training_set, training_labels.values.ravel())
    return grid_search.best_params


def train_xg_model(shot_df):
    # Trains (and saves) a random forest expected goals model, given a shots dataframe with the below features.

    features = ['distance', 'angle', 'big_chance', 'header', 'from_corner', 'from_fk', 'free_kick', 'fast_break',
                'from_cross', 'from_through_ball']
    data = shot_df.loc[:, features]
    labels = shot_df.loc[:, ['goal']]

    training_set, test_set, training_labels, test_labels = train_test_split(data, labels, test_size=0.3)
    params = tune_parameters(training_set, training_labels)
    rf_classifier = RandomForestClassifier(bootstrap=True, max_depth=params['max_depth'],
                                           max_features=params['max_features'],
                                           min_samples_leaf=params['min_samples_leaf'],
                                           min_samples_split=params['min_samples_split'],
                                           n_estimators=params['n_estimators'], oob_score=True)
    rf_classifier.fit(training_set, training_labels.values.ravel())

    preds = pd.DataFrame(rf_classifier.predict_proba(test_set)).iloc[:, 1]
    rmse = np.sqrt(((preds - test_labels['goal'].reset_index(drop=True)) ** 2).mean())
    print('RMSE: '+str(round(rmse, 3)))

    feature_importance = rf_classifier.feature_importances_
    print('\nFeature Importance:')
    for i in range(0, len(features)):
        print(features[i]+': '+str(round(feature_importance[i], 3)))

    # saves model as pickle file.
    with open("expected_goals.pkl", 'wb') as file:
        pickle.dump(rf_classifier, file)


if __name__ == '__main__':

    df = pd.read_csv(path+'data/shots_df.csv')
    train_xg_model(df)

