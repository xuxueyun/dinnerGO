
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <title>登陆</title>
    <!--必要样式-->
    <link href="/static/meal/css/login.css" rel="stylesheet" type="text/css" />
    <link href="/static/meal/css/loaders.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div class='login'>
    <div class='login_title'>
        <span>员工登陆</span>
    </div>
    <div class='login_fields'>
        <div class='login_fields__user'>
            <div class='icon'>
                <img alt="" src='/static/meal/img/user_icon_copy.png'>
            </div>
            <input name="username" placeholder='用户名' maxlength="16" type='text' autocomplete="off"/>
            <div class='validation'>
                <img alt="" src='/static/meal/img/tick.png'>
            </div>
        </div>
        <div class='login_fields__password'>
            <div class='icon'>
                <img alt="" src='/static/meal/img/lock_icon_copy.png'>
            </div>
            <input name="password" placeholder='密码' maxlength="16" type='password' autocomplete="off">
            <div class='validation'>
                <img alt="" src='/static/meal/img/tick.png'>
            </div>
        </div>
        <div class='login_fields__password' style="display: none;">
            <div class='icon'>
                <img alt="" src='/static/meal/img/key.png'>
            </div>
            <input name="code" placeholder='验证码' maxlength="4" type='text' name="ValidateNum" autocomplete="off" value="1111">
            <div class='validation' style="opacity: 1; right: -5px;top: -3px;">
                <canvas class="J_codeimg" id="myCanvas" onclick="Code();">对不起，您的浏览器不支持canvas，请下载最新版浏览器!</canvas>
            </div>
        </div>
        <div class='login_fields__submit'>
            <input type='button' value='登录'>
        </div>
    </div>
    <div class='success'>
    </div>
    <div class='disclaimer'>
        <p>&copy; 2018 zsuntech.com</p>
    </div>
</div>
<div class='authent'>
    <div class="loader" style="height: 44px;width: 44px;margin-left: 28px;">
        <div class="loader-inner ball-clip-rotate-multiple">
            <div></div>
            <div></div>
            <div></div>
        </div>
    </div>
    <p>认证中...</p>
</div>
<div class="OverWindows"></div>

<link href="/static/libs/layui/css/layui.css" rel="stylesheet" type="text/css" />
<script src="/static/js/jquery.min.js"></script>

<script type="text/javascript" src="/static/libs/jquery-ui/jquery-ui.min.12.js"></script>
<script type="text/javascript" src='/static/meal/js/stopExecutionOnTimeout.js'></script>
<script type="text/javascript" src='/static/meal/js/common.js'></script>
<script type="text/javascript" src="/static/libs/layui/layui.js"></script>
<script type="text/javascript" src="/static/libs/Particleground/Particleground.js"></script>


<script type="text/javascript">

    $(document).keypress(function (e) {
        // 回车键事件
        if (e.which == 13) {
            $('input[type="button"]').click();
        }
    });
    //粒子背景特效
    $('body').particleground({
        dotColor: '#E8DFE8',
        lineColor: '#133b88'
    });
    $('input[name="pwd"]').focus(function () {
        $(this).attr('type', 'password');
    });
    $('input[type="text"]').focus(function () {
        $(this).prev().animate({ 'opacity': '1' }, 200);
    });
    $('input[type="text"],input[type="password"]').blur(function () {
        $(this).prev().animate({ 'opacity': '.5' }, 200);
    });
    $('input[name="login"],input[name="pwd"]').keyup(function () {
        var Len = $(this).val().length;
        if (!$(this).val() == '' && Len >= 5) {
            $(this).next().animate({
                'opacity': '1',
                'right': '30'
            }, 200);
        } else {
            $(this).next().animate({
                'opacity': '0',
                'right': '20'
            }, 200);
        }
    });
    layui.use('layer', function () {
        //非空验证
        $('input[type="button"]').click(function () {
            var username = $('input[name="username"]').val();
            var password = $('input[name="password"]').val();
            var code = $('input[name="code"]').val();
            if (username == '') {
                ErroAlert('请输入您的账号');
            } else if (password == '') {
                ErroAlert('请输入密码');
            } else if (code == '' || code.length != 4) {
                ErroAlert('输入验证码');
            } else {

                $('.login').addClass('test'); //倾斜特效
                setTimeout(function(){
                    $('.login').addClass('testtwo'); //平移特效
                }, 300);
                setTimeout(function () {
                    $('.authent').show().animate({ right: -320 }, {
                        easing: 'easeOutQuint',
                        duration: 600,
                        queue: false
                    });
                    $('.authent').animate({ opacity: 1 }, {
                        duration: 200,
                        queue: false
                    }).addClass('visible');
                }, 500);
                //登录
                var JsonData = { username: username, password: password, code: code };
                //此处做为ajax内部判断
                var url = '{{urlfor "LoginController.Runlogin"}}';

                AjaxPost(url, JsonData,
                    function (data) {
                        //ajax返回
                        //认证完成
                        setTimeout(function () {
                            $('.authent').show().animate({ right: 90 }, {
                                easing: 'easeOutQuint',
                                duration: 600,
                                queue: false
                            });
                            $('.authent').animate({ opacity: 0 }, {
                                duration: 200,
                                queue: false
                            }).addClass('visible');
                            $('.login').removeClass('testtwo'); //平移特效
                        }, 2000);
                        setTimeout(function () {
                            $('.authent').hide();
                            $('.login').removeClass('test');
                            if (data.code > 0) {
                                //登录成功
                               window.location.href = "/";
                            } else {
                                AjaxErro({ Status: "Error", Error: data.msg });
                            }
                        }, 2400);
                    })
            }
        })
    })

</script>

</body>
</html>
