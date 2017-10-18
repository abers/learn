import warnings
warnings.simplefilter('ignore', FutureWarning)

from pandas import *
glasgow = read_csv('GlasgowHistory.csv', skipinitialspace=True)

print (glasgow)

glasgow = glasgow.rename(columns={'WindDirDegrees<br />' : 'WindDirDegrees'})
glasgow['WindDirDegrees'] = glasgow['WindDirDegrees'].str.rstrip('<br />')
glasgow['WindDirDegrees'] = glasgow['WindDirDegrees'].astype('float64')
glasgow['GMT'] = to_datetime(glasgow['GMT'])

glasgow.index = glasgow['GMT']

summer = glasgow.ix[datetime(2015,6,1) : datetime(2015,8,31)]

print (summer[summer['Mean TemperatureC'] >= 20])

summer['Mean TemperatureC'].plot(grid=True, figsize=(10,5))
test = summer['Mean TemperatureC'].plot(grid=True, figsize=(10,5))
test.savefig('/test.png')

summer[['Mean TemperatureC', 'Mean Humidity', 'Mean Wind SpeedKm/h']].plot(grid=True, figsize=(10,5))
print (summer)
