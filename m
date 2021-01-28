Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E874307C35
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhA1RWO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhA1RQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:16:33 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B84C061793;
        Thu, 28 Jan 2021 09:15:52 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 190so4932543wmz.0;
        Thu, 28 Jan 2021 09:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=h1oksi9/2xcJmosjjAA/Oew8p+u1UPHnoTdbdUI6zR0=;
        b=bQZB26CwdztGhOLjCqU9KjSKE/1MyXRI7bVBgFxyuMkC4875MyrLgwuQeLBQCsRrki
         I4MHTwCncL7Et+c/4+qEl6P2dmwpZfU+yDXo7KrEysnLK+JVDKT21n1HZSLafFQOLKPD
         b+RSV3a3WVb6iDtHYJv5GjHC1yzOfFXHmbS5tuaWCK5AwN7KO1PoVVY7sZWEJvWtoKX7
         k9Z8g2dl8S7pz8FAr3z9ykHljBot8JxIB3ljWutCMlt9CZWbUS3yvHdgAgQmqGQQp5wl
         PXVNoSmkgLhvoLyhhAghWtYA60MubetMNlbikaj9+t1fnQ7JeoDph1bbAl+c5kM5wgs/
         j7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=h1oksi9/2xcJmosjjAA/Oew8p+u1UPHnoTdbdUI6zR0=;
        b=WNMtVwRcU6QmcizOELSVkLPJqlGkQq1fOpXHgf9AEmx/PoPQHoy23hWsiORjvJHGXH
         zrsAkv/3FnKJyEaTa6PlO/gs9QbBGDCpK59fD6yBz7PfPNMsjdX97Mz/PoSb2WC7jmpX
         iqLTcsC/umOd/nA/NNo2EpXvoy06Hf0O+Drf2pouXkusAWOZqnadsDqL8iplwNfGLV9s
         RPCVzlVpGTNPFtDGtqGy3ds7LJMZkzawYXF77YvmwbperBdpXxh+q0l255mYuSUHNjZM
         N+8y/p+j817xZyKUCqOve9dhOlvwaeuTLKgfx1FAjKxjrfea62hkCKQsWUu8Y8OxceGh
         BenQ==
X-Gm-Message-State: AOAM5338pnQMT8Acyxv0il+b1wYX9ci0lCvyONR72Dot1Q3w9o0RQ0gM
        TXqMHkn+BRkvZ8Ui6s6IgsGEvSk8x18=
X-Google-Smtp-Source: ABdhPJwIR5O1IPi2+B0vWRK63og1eosVrNC3u9/J8i6C7wytfj9fAoMVT9XObXKHcWTLNKL3tEmXzw==
X-Received: by 2002:a1c:f706:: with SMTP id v6mr238859wmh.85.1611854151252;
        Thu, 28 Jan 2021 09:15:51 -0800 (PST)
Received: from [192.168.8.160] ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id h15sm7651834wrt.10.2021.01.28.09.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:15:50 -0800 (PST)
Subject: Re: BUG: corrupted list in io_file_get
To:     syzbot <syzbot+6879187cf57845801267@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000ab74fb05b9f8cb0a@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <944c4b9b-9c83-3167-fd43-d5118fdc2e0e@gmail.com>
Date:   Thu, 28 Jan 2021 17:12:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000ab74fb05b9f8cb0a@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VCGAA2ImuWEbQnOIbAaLE384QhK7nZ6Pj"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VCGAA2ImuWEbQnOIbAaLE384QhK7nZ6Pj
Content-Type: multipart/mixed; boundary="G7B3YOQnMBWm4SfSNwZtGTO2AoN7PGyGg";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: syzbot <syzbot+6879187cf57845801267@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 viro@zeniv.linux.org.uk
Message-ID: <944c4b9b-9c83-3167-fd43-d5118fdc2e0e@gmail.com>
Subject: Re: BUG: corrupted list in io_file_get
References: <000000000000ab74fb05b9f8cb0a@google.com>
In-Reply-To: <000000000000ab74fb05b9f8cb0a@google.com>

--G7B3YOQnMBWm4SfSNwZtGTO2AoN7PGyGg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2021 16:58, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    76c057c8 Merge branch 'parisc-5.11-2' of git://git.kern=
el...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11959454d00=
000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D96b123631a6=
700e9
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D6879187cf5784=
5801267
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12a3872cd=
00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16ab17a4d00=
000
>=20
> The issue was bisected to:
>=20
> commit 02a13674fa0e8dd326de8b9f4514b41b03d99003
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sat Jan 23 22:49:31 2021 +0000
>=20
>     io_uring: account io_uring internal files as REQ_F_INFLIGHT
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D14d1bf44=
d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D16d1bf44=
d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12d1bf44d00=
000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
> Fixes: 02a13674fa0e ("io_uring: account io_uring internal files as REQ_=
F_INFLIGHT")
>=20
> list_add double add: new=3Dffff888017eaa080, prev=3Dffff88801a9cb520, n=
ext=3Dffff888017eaa080.
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:29!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8481 Comm: syz-executor556 Not tainted 5.11.0-rc5-syzkaller=
 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 01/01/2011
> RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
> Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48=
 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 8=
9 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
> RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
> RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
> RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
> RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
> R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
> R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
> FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:00000000000=
00000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0
> Call Trace:
>  __list_add include/linux/list.h:67 [inline]
>  list_add include/linux/list.h:86 [inline]
>  io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
>  __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
>  io_splice_prep fs/io_uring.c:3920 [inline]
>  io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
>  io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
>  io_submit_sqe fs/io_uring.c:6705 [inline]
>  io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
>  __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440569
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe38c5c5a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 0000000000401e00 RCX: 0000000000440569
> RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000004
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000401d70
> R13: 0000000000401e00 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 3c68392a0f24e7a0 ]---
> RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
> Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48=
 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 8=
9 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
> RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
> RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
> RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
> RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
> R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
> R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
> FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:00000000000=
00000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0

This one is simple

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae388cc52843..39ae1f821cef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6460,7 +6460,8 @@ static struct file *io_file_get(struct io_submit_st=
ate *state,
 		file =3D __io_file_get(state, fd);
 	}
=20
-	if (file && file->f_op =3D=3D &io_uring_fops) {
+	if (file && file->f_op =3D=3D &io_uring_fops &&
+	    !(req->flags & REQ_F_INFLIGHT)) {
 		io_req_init_async(req);
 		req->flags |=3D REQ_F_INFLIGHT;
=20


--=20
Pavel Begunkov


--G7B3YOQnMBWm4SfSNwZtGTO2AoN7PGyGg--

--VCGAA2ImuWEbQnOIbAaLE384QhK7nZ6Pj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAmAS8GkACgkQWt5b1Glr
+6W2ow/9EbZJOPHHwSkaQteZjdSUKeKQPQZvMwftbbKI5X0F/wIqKBvfzGHVAOib
k+o83qyhR7F3yRXND/Wjcdmmns8PTlLimwNIZ7NtCJ9nr/DeAxa4mBH/RuPT2EjN
P33q+9posHwsEJv45a/9B/uD3JM9SIbeE7IY8CazWUDE/AOnGx8Sf9d2qG15GNQB
7hYgDNjxei6LAwzI++0iouj7ccOKJOTbQGCOKPaIQ61t03QlC3TGH8ppEonniTgK
EK851GhimgfTNJujd/KFzH5a8xDpuO86Li3NpdCqPhcZAsUu4aF4SwcqeU3pc/Km
/72eThodyu80e5iTg5uzWL021NhHhOvxcQwh0pBN8AKUonhxRgI7QpJb/ZcO5XaE
JWpVlnRc/fMPwqyZ1tVQZOi6GG/1cezqJZJA75edVJuku1WCWZTMEHIbxiuysePM
Z7F2ddYcevad4nNqR5VFDjOhT5XKeVu73qDFUQrVUVJ4rlBE3zdYRvQM1Plx4qBk
z6KcA1O11RBtva+t8fyvG/OhsZgxyvLOBKIbt4OchXkJas/gNzUQUmyLdLj8wKvq
4VrkFEAob4WGOnImAXmzGbBkjMThIHuyzD2YsPb5ZNf35eY2y2Vg5iOh1NKz1DcR
+bizxVSDlrw0aP9+v1gbU61+Jysl6OxSwSVQDLWUq1X61hvpFOw=
=p1vS
-----END PGP SIGNATURE-----

--VCGAA2ImuWEbQnOIbAaLE384QhK7nZ6Pj--
