analytics_settings(False)
allow_k8s_contexts("pod")

load("ext://uibutton", "cmd_button", "location")
load("ext://restart_process", "custom_build_with_restart")

for vc in ["vc1", "vc2", "vc3", "vc4"]:
    local_resource(vc, serve_cmd="cd ~/app/ondemand && exec ./{vc}".format(vc=vc))
    cmd_button(
        name=vc,
        text=vc,
        resource=vc,
        icon_name="login",
        argv=[
            "bash",
            "-c",
            """
                app delete -y {vc};
                while app get {vc} 2>/dev/null; do echo "waiting for {vc} deletion... $(date)"; sleep 5; done
                rm -fv ~/app/ondemand/.doing.{vc};
                echo "deleted {vc}";
                app delete -y k3d-control-{vc};
                app list;
                echo; echo; echo;
            """.format(
            vc=vc,
            ),
        ],
        location=location.RESOURCE,
    )