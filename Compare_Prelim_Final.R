

old <- read_csv('views/DAC_Combined_Interactive.csv')
new <- read_csv('views/DAC_Combined_Interactive_jan2draft.csv')

combined <- old %>%
  bind_rows(new) %>% 
  filter(Time_Period >= 2015) %>% 
  spread(as_of_date,Value) %>% 
  mutate(Difference = `2018-01-02`-`2017-05-16`,
         Percent_Diff = Difference/`2017-05-16`) %>% 
  arrange(desc(abs(Percent_Diff)))


old.tableau <- read_csv('views/DAC_Combined_Tableau_Draft.csv')
new.tableau <- read_csv('views/DAC_Combined_Tableau_Draft_Jan2.csv')

old.tableau$Release <- 'Preliminary'
new.tableau$Release <- 'Final'

combined.tableau <- old.tableau %>% 
  bind_rows(new.tableau) %>% 
  write_csv('views/DAC_Combined_Tableau_ReleaseCompare_Jan2.csv')