from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 10, 20),
    'retries': 1,
    # 'retry_delay': timedelta(minutes=5),
}

dag = DAG('dbt_dag', default_args=default_args, schedule_interval=timedelta(days=1))

dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command='cd ../dbt && dbt test',
    dag=dag,
)

dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command='cd ../dbt && dbt run',
    dag=dag
)

dbt_test >> dbt_run