import json
import os
from pathlib import Path
import time
from datetime import datetime, timedelta
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

last_modified_file = None

def generate_python_file(json_file):
    with open(json_file, 'r', encoding='utf-8') as file:
        try:
            json_data = json.load(file)
        except json.JSONDecodeError:
            print(f'Error: {json_file} is not a valid JSON file')
            return

    file_name = json_file.stem
    output_file_name = f"{file_name}_json.dart"
    output_file_path = json_file.parent / output_file_name

    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write(f"String {file_name}PageJson = r'''\n{json.dumps(json_data, ensure_ascii=False)}\n''';\n")

    print(f'Generated {output_file_path}')

def handle_file_change(json_file):
    global last_modified_file
    last_modified_file = json_file
    generate_python_file(json_file)

class JsonFileHandler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        self.last_event_time = datetime.now()

    def on_modified(self, event):
        if event.is_directory or not event.src_path.endswith('.json'):
            return
        now = datetime.now()
        time_since_last_event = now - self.last_event_time
        if time_since_last_event < timedelta(seconds=2):
            return
        print(f'File {event.src_path} has been modified')
        self.last_event_time = now
        handle_file_change(Path(event.src_path))

def generate_all_python_files():
    json_files = list(Path('lib').rglob('*.json'))
    for json_file in json_files:
        generate_python_file(json_file)

def monitor_changes():
    event_handler = JsonFileHandler()
    observer = Observer()
    observer.schedule(event_handler, path='lib', recursive=True)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == "__main__":
    generate_all_python_files()
    monitor_changes()
