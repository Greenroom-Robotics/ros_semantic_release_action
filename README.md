# ROS Semantic Release action

## Notes

### Paths
When adding this to a repo, the action will mount into `GITHUB_ACTION_PATH`. This should be: `/__w/_actions/Greenroom-Robotics/ros_semantic_release_action/main`. The PWD should be the repo name you are running this action in. eg) `/__w/<repo_name>/<repo_name>`. We can't add `GITHUB_ACTION_PATH` to the `@semantic-release/exec` (without forking it) so we hardcode this action reference.
