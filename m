Return-Path: <io-uring+bounces-357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2F881D33E
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 10:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23C881F23079
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 09:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBC7BA4E;
	Sat, 23 Dec 2023 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htlILD94"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A3BA3E;
	Sat, 23 Dec 2023 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7b7fdde8b26so106565339f.1;
        Sat, 23 Dec 2023 01:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703322490; x=1703927290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2rGIJcw4PF7MkN1Z8kIClIMdfFg/22eHK3cOPBZMTA=;
        b=htlILD94Oh7Laq0fAjDt39C3Ujfv5ut4OeAjk/E2SIkh4xuLn7bhGtMxMWDJeSFZQz
         EX5mTF7WLin1JvQX1wD7JWjx2Vk2a5aZAq3nZAI6i4L+TqNBzsJS3XEDBZp6gM4FHO/w
         zHYmVcVc08qFYVa+/5w6Ii4x0IQkpA2hl7TwinXZVxFAx00nOYQXJP+gpdyAXOiLTRkm
         4ISN0LijTEaAxLwpmauheFObWnbddiiZUFC722vSiXgA7vi5w1lj5rZfRT+ni6nGLejJ
         JCpDYauMNUE8yQKMIH1InSrYzbdEMN04Mch/BUeZVePxPMpmb+0fXMuFxibzIAITiIct
         8b7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703322490; x=1703927290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2rGIJcw4PF7MkN1Z8kIClIMdfFg/22eHK3cOPBZMTA=;
        b=gNM9cCrAa0mO1OAL4ZJjeIKBx3+7ZazefEsRJvCkIR2oFniDXjANmv3nYHphep6MRG
         l7zi9f/wR2N8slbWelmFGf8FsUV5rvi70auYt6X2GaDGptFkT5083nGe4UXlfMPJ6bXQ
         CNP2BRKQS1IxhXrr+9girth9ysx1q5P3xXajcBShHbJ7j+FtkJnED6vgJbKmu3IG9TFv
         f4GG256RMZ9u1xr89dbOKQru5ejuhjlJtJaY3eWvSrmBzPKb3crILWljdd6RFTH18kKo
         el4s/AXGIwUHfmCC/uybM0Y+ONyhzABDBK5p8GKUkSJJTmpQg0NqMZySbXLJQlN7DqKj
         If2Q==
X-Gm-Message-State: AOJu0YyAPHr8C2bHo6o6IHSFB0wM/hlZ3XiA9jJFmlp9u/lTGak3al6u
	f42SVRBLZfwMVGiE5PbuPEIl1rFOhG2tGwkD+MA=
X-Google-Smtp-Source: AGHT+IHpRmPFChwsPc6QX82NtiFCUU7q5dwuETJKnTw+g1O49wLu23Y6eixzXgXQ+USwmGMXbX8kuaw4oFgZcGpfOxE=
X-Received: by 2002:a05:6602:3158:b0:7ba:ab98:77de with SMTP id
 m24-20020a056602315800b007baab9877demr1992951ioy.25.1703322489657; Sat, 23
 Dec 2023 01:08:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABOYnLzhrQ25C_vjthTZZhZCjQrL-HC4=MKmYG0CyoG6hKpbnw@mail.gmail.com>
 <c64745d9-4a85-49c0-9df7-f687b18c2c00@kernel.dk>
In-Reply-To: <c64745d9-4a85-49c0-9df7-f687b18c2c00@kernel.dk>
From: xingwei lee <xrivendell7@gmail.com>
Date: Sat, 23 Dec 2023 17:07:55 +0800
Message-ID: <CABOYnLzKaMLnuAffjwhsYCt3+j-KisSFpX=-EOpfz=KqGR5BAQ@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in io_rw_fail
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot+12dde80bf174ac8ae285@syzkaller.appspotmail.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	glider@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2023=E5=B9=B412=E6=9C=8821=E6=97=A5=
=E5=91=A8=E5=9B=9B 23:46=E5=86=99=E9=81=93=EF=BC=9A


On 12/21/23 3:58 AM, xingwei lee wrote:

Hello I found a bug in io_uring and comfirmed at the latest upstream
mainine linux.
TITLE: KMSAN: uninit-value in io_rw_fail
and I find this bug maybe existed in the
https://syzkaller.appspot.com/bug?extid=3D12dde80bf174ac8ae285 but do
not have a stable reproducer.
However, I generate a stable reproducer and comfirmed in the latest mainlin=
e.


I took a look at that one and can't see anything wrong, is that one
still triggering? In any case, this one is different, as it's the writev
path. Can you try the below?

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4943d683508b..0c856726b15d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -589,15 +589,19 @@ static inline int io_rw_prep_async(struct
io_kiocb *req, int rw)
      struct iovec *iov;
      int ret;

+       iorw->bytes_done =3D 0;
+       iorw->free_iovec =3D NULL;
+
      /* submission path, ->uring_lock should already be taken */
      ret =3D io_import_iovec(rw, req, &iov, &iorw->s, 0);
      if (unlikely(ret < 0))
              return ret;

-       iorw->bytes_done =3D 0;
-       iorw->free_iovec =3D iov;
-       if (iov)
+       if (iov) {
+               iorw->free_iovec =3D iov;
              req->flags |=3D REQ_F_NEED_CLEANUP;
+       }
+
      return 0;
}


--
Jens Axboe

Hi Jens!
I test your patch in the lastest mainline commit:
5254c0cbc92d2a08e75443bdb914f1c4839cdf5a
without your patch kmsan still trigger the issue like this:

syzkaller login: root
lsLinux syzkaller 6.7.0-rc6-00248-g5254c0cbc92d #7 SMP PREEMPT_DYNAMIC
Sat Dec 23 16:19:30 CST 2023 x86_64

[  144.535556][ T8092] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  144.538187][ T8092] BUG: KMSAN: uninit-value in io_rw_fail+0x191/0x1a0
[  144.539959][ T8092]  io_rw_fail+0x191/0x1a0
[  144.541020][ T8092]  io_req_defer_failed+0x1fa/0x380
[  144.542458][ T8092]  io_queue_sqe_fallback+0x200/0x260
[  144.543714][ T8092]  io_submit_sqes+0x2466/0x2fc0
[  144.544880][ T8092]  __se_sys_io_uring_enter+0x3bd/0x4120
[  144.546222][ T8092]  __x64_sys_io_uring_enter+0x110/0x190
[  144.547673][ T8092]  do_syscall_64+0x44/0x110
[  144.549724][ T8092]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  144.551518][ T8092]
[  144.552075][ T8092] Uninit was created at:
[  144.553119][ T8092]  slab_post_alloc_hook+0x103/0x9e0
[  144.554387][ T8092]  __kmem_cache_alloc_node+0x5d5/0x9b0
[  144.555672][ T8092]  __kmalloc+0x118/0x410
[  144.556694][ T8092]  io_req_prep_async+0x376/0x590
[  144.557968][ T8092]  io_queue_sqe_fallback+0x98/0x260
[  144.559246][ T8092]  io_submit_sqes+0x2466/0x2fc0
[  144.560397][ T8092]  __se_sys_io_uring_enter+0x3bd/0x4120
[  144.561706][ T8092]  __x64_sys_io_uring_enter+0x110/0x190
[  144.563024][ T8092]  do_syscall_64+0x44/0x110
[  144.564122][ T8092]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  144.565559][ T8092]
[  144.566140][ T8092] CPU: 2 PID: 8092 Comm: 5e5 Not tainted
6.7.0-rc6-00248-g5254c0cbc92d #7
[  144.567756][ T8092] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.16.2-1.fc38 04/01/2014
[  144.569423][ T8092] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  144.570623][ T8092] Disabling lock debugging due to kernel taint
[  144.571689][ T8092] Kernel panic - not syncing: kmsan.panic set ...
[  144.572796][ T8092] CPU: 2 PID: 8092 Comm: 5e5 Tainted: G    B
        6.7.0-rc6-00248-g5254c0cbc92d #7
[  144.574525][ T8092] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.16.2-1.fc38 04/01/2014
[  144.576180][ T8092] Call Trace:
[  144.576782][ T8092]  <TASK>
[  144.577329][ T8092]  dump_stack_lvl+0x1af/0x230
[  144.578192][ T8092]  dump_stack+0x1e/0x20
[  144.578957][ T8092]  panic+0x4d6/0xc60
[  144.579714][ T8092]  kmsan_report+0x2d7/0x2e0
[  144.580753][ T8092]  ? kmsan_internal_set_shadow_origin+0x6c/0xe0
[  144.581892][ T8092]  ? __msan_warning+0x96/0x110
[  144.583055][ T8092]  ? io_rw_fail+0x191/0x1a0
[  144.583952][ T8092]  ? io_req_defer_failed+0x1fa/0x380
[  144.584903][ T8092]  ? io_queue_sqe_fallback+0x200/0x260
[  144.585884][ T8092]  ? io_submit_sqes+0x2466/0x2fc0
[  144.586798][ T8092]  ? __se_sys_io_uring_enter+0x3bd/0x4120
[  144.587825][ T8092]  ? __x64_sys_io_uring_enter+0x110/0x190
[  144.588848][ T8092]  ? do_syscall_64+0x44/0x110
[  144.589707][ T8092]  ? entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  144.590807][ T8092]  ? kmsan_get_shadow_origin_ptr+0x4c/0xa0
[  144.591866][ T8092]  ? __import_iovec+0x2b8/0xed0
[  144.592746][ T8092]  ? __stack_depot_save+0x37e/0x4a0
[  144.593688][ T8092]  ? kmsan_internal_set_shadow_origin+0x6c/0xe0
[  144.594818][ T8092]  ? kmsan_get_shadow_origin_ptr+0x4c/0xa0
[  144.595876][ T8092]  ? io_import_iovec+0x7d1/0x9d0
[  144.596776][ T8092]  ? kmsan_get_shadow_origin_ptr+0x4c/0xa0
[  144.597844][ T8092]  __msan_warning+0x96/0x110
[  144.598689][ T8092]  io_rw_fail+0x191/0x1a0
[  144.599489][ T8092]  ? io_setup_async_rw+0x7d0/0x7d0
[  144.600419][ T8092]  io_req_defer_failed+0x1fa/0x380
[  144.601349][ T8092]  io_queue_sqe_fallback+0x200/0x260
[  144.602320][ T8092]  io_submit_sqes+0x2466/0x2fc0
[  144.603270][ T8092]  __se_sys_io_uring_enter+0x3bd/0x4120
[  144.604075][ T8092]  ? kmsan_get_shadow_origin_ptr+0x4c/0xa0
[  144.604731][ T8092]  __x64_sys_io_uring_enter+0x110/0x190
[  144.605359][ T8092]  do_syscall_64+0x44/0x110
[  144.605867][ T8092]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  144.606525][ T8092] RIP: 0033:0x432e39
[  144.606959][ T8092] Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17
00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c8
[  144.608998][ T8092] RSP: 002b:00007ffcbc551c78 EFLAGS: 00000216
ORIG_RAX: 00000000000001aa
[  144.609905][ T8092] RAX: ffffffffffffffda RBX: 00007ffcbc551eb8
RCX: 0000000000432e39
[  144.610758][ T8092] RDX: 0000000000000000 RSI: 0000000000002d3e
RDI: 0000000000000003
[  144.611601][ T8092] RBP: 00007ffcbc551ca0 R08: 0000000000000000
R09: 0000000000000000
[  144.612452][ T8092] R10: 0000000000000000 R11: 0000000000000216
R12: 0000000000000001
[  144.613299][ T8092] R13: 00007ffcbc551ea8 R14: 0000000000000001
R15: 0000000000000001
[  144.614149][ T8092]  </TASK>
[  144.615019][ T8092] Kernel Offset: disabled
[  144.615507][ T8092] Rebooting in 86400 seconds..


with the patch that you provided make a little change to apply to this
commit: 5254c0cbc92d2a08e75443bdb914f1c4839cdf5a

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4943d683508b..0c856726b15d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -589,15 +589,19 @@ static inline int io_rw_prep_async(struct
io_kiocb *req, int rw)
      struct iovec *iov;
      int ret;

+       iorw->bytes_done =3D 0;
+       iorw->free_iovec =3D NULL;
+
      /* submission path, ->uring_lock should already be taken */
      ret =3D io_import_iovec(rw, req, &iov, &iorw->s, 0);
      if (unlikely(ret < 0))
              return ret;

-       iorw->bytes_done =3D 0;
-       iorw->free_iovec =3D iov;
-       if (iov)
+       if (iov) {
+               iorw->free_iovec =3D iov;
              req->flags |=3D REQ_F_NEED_CLEANUP;
+       }
+
      return 0;
}

since the reproducer is in a loop
and I ran for about 30 minutes it didn't trigger any issues.

I hope it helps.

Best regards.
xingwei Lee

