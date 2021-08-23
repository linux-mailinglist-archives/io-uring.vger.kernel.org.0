Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3728E3F4884
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 12:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhHWKUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 06:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbhHWKUJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 06:20:09 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3B6C061575;
        Mon, 23 Aug 2021 03:19:26 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e5so8929074wrp.8;
        Mon, 23 Aug 2021 03:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axyxULOuLtbA7C76eXFhQ80MZCAfJ/IfweqX0FcQqRw=;
        b=YXXJ1A3GavVryfBdohZq73O+KN5V4xRSw7BWG8y3lPYVjtych9OxyGQp5xSjpbILLr
         O0kddzIcljgl2qHC2flzxckBCj9Ac8BWVEvYLpNWcJQ8U4oCJkpKF8IEja3x7zQyunGR
         nJU0rpvigxPNX5Uxz2CTs5n7Pf7ngCZP/gfPSJ9fVIfUlQlGtjPzwvetiawcSyqio3ZK
         0BhfrqvWMYOUf2rUFub9DpGadynaEtk7tWUnu2739TfkIczQGglEh0IBdmV3lUhBmvar
         fpxuYh/X5vnjdtldRucxJNsDMLt7uouBGNRuOiY+j3yZEYcDpilW5z9ekBdWDrwc2An9
         a8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axyxULOuLtbA7C76eXFhQ80MZCAfJ/IfweqX0FcQqRw=;
        b=asoFtW30h5XZEaAaID3TlsmMmMH44YCOJTM36O6JWO4Pho8bI9Ov6zPy3jVLH+4Emw
         pw6q8U6/OIZCkwfjFwRIuGCFd76a7xh6uObmYuw7bSfRiXdlAlY2/BZj8WPFYjQzuUvF
         c8wOVepUlFdoSEpKn+3R6+EYSGTmRemjERO4WJVa+QRRxLsvPORBEP9OA2MECQ+4Bpkg
         uR/dsvou7Yic7DXS1wvTtlqYkS8XXoe44eupAiJGA24omBzDRhftJ0BFf0SM0YnBSS7E
         QLTbGiCB1SBOeWFNlPcniRLU7L1NEy/dHUbnWbi3VWCSpJ+n5LMtnOySH9yrjyfk6+Dv
         INbA==
X-Gm-Message-State: AOAM532QQjW8BAJWYrJSoT95ZXqEjvytfrQQZidqVRZa6dlktc+/xIG8
        wROOeQa0Iv3mwqnyIv6a7T4=
X-Google-Smtp-Source: ABdhPJyPvDF9zY0Am+esDyQ7YMUTz4y3I+F5R8FeXC2s8yE8AM8lGnIOOe33MxZJMWWJ6EOvXh4kcQ==
X-Received: by 2002:adf:fdd2:: with SMTP id i18mr6979780wrs.406.1629713965104;
        Mon, 23 Aug 2021 03:19:25 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id l18sm20539922wmc.30.2021.08.23.03.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:19:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com,
        asml.silence@gmail.com
Subject: [PATCH v3 2/2] io_uring: reexpand under-reexpanded iters
Date:   Mon, 23 Aug 2021 11:18:45 +0100
Message-Id: <4b5fcd229bbf1b73414cb77a4a0224498ebd19c9.1629713020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629713020.git.asml.silence@gmail.com>
References: <cover.1629713020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[   74.211232] BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x809/0x900
[   74.212778] Read of size 8 at addr ffff888025dc78b8 by task
syz-executor.0/828
[   74.214756] CPU: 0 PID: 828 Comm: syz-executor.0 Not tainted
5.14.0-rc3-next-20210730 #1
[   74.216525] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   74.219033] Call Trace:
[   74.219683]  dump_stack_lvl+0x8b/0xb3
[   74.220706]  print_address_description.constprop.0+0x1f/0x140
[   74.224226]  kasan_report.cold+0x7f/0x11b
[   74.226085]  iov_iter_revert+0x809/0x900
[   74.227960]  io_write+0x57d/0xe40
[   74.232647]  io_issue_sqe+0x4da/0x6a80
[   74.242578]  __io_queue_sqe+0x1ac/0xe60
[   74.245358]  io_submit_sqes+0x3f6e/0x76a0
[   74.248207]  __do_sys_io_uring_enter+0x90c/0x1a20
[   74.257167]  do_syscall_64+0x3b/0x90
[   74.257984]  entry_SYSCALL_64_after_hwframe+0x44/0xae

old_size = iov_iter_count();
...
iov_iter_revert(old_size - iov_iter_count());

If iov_iter_revert() is done base on the initial size as above, and the
iter is truncated and not reexpanded in the middle, it miscalculates
borders causing problems. This trace is due to no one reexpanding after
generic_write_checks().

Now iters store how many bytes has been truncated, so reexpand them to
the initial state right before reverting.

Cc: stable@vger.kernel.org
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a2e20a6fbfed..b225aff6d586 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3323,6 +3323,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
 		/* some cases will consume bytes even on error returns */
+		iov_iter_reexpand(iter, iter->count + iter->truncated);
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
@@ -3462,6 +3463,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
+		iov_iter_reexpand(iter, iter->count + iter->truncated);
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		return ret ?: -EAGAIN;
-- 
2.32.0

