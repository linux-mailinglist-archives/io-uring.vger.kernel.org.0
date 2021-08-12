Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269EA3EABF3
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbhHLUlz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 16:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbhHLUly (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 16:41:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324E9C0617A8;
        Thu, 12 Aug 2021 13:41:28 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l18so10096648wrv.5;
        Thu, 12 Aug 2021 13:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=syTDIp7PiP+AZjzDYgWMScbh9JnkTpS8wJ/cVx+Gs1M=;
        b=Q5WRUJ3myVlg59GgTCXeJx00IHuP+JQt6euiBQoSPgwLoiKHe3doy6cRbgODFU/zbt
         PctWu5EoqQPnZ0mNq9RaPWIpQXlRPIBciLriVDOig46D28yNGrx9VKSy9P17IkS2W5J5
         JAR7qTrrQC7JKQJkuP3ev6nXOdoAh0hHFJzb9AteZ2hTrze331Caa7QXhfIDo/TyJCg4
         fnX7mksG50YGQ7BQHOSv5JBgzgQ1wR4y6riU4BAEGj9HVcePywbIS2Oi47aaHRp5j2vn
         Gvglw1UrNz2crqp4JP+jOA62ymhtF/HJIVc/7NfDNULlebqNwdkIJbNDYlntlCh6qAO/
         B1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=syTDIp7PiP+AZjzDYgWMScbh9JnkTpS8wJ/cVx+Gs1M=;
        b=Z2v+oGEtdafqxOTWUDwCO1q6IXkSM9jW0Ke2eOeb0PVc6IQ5phTb7q61uOi236BRQX
         6DWSD9alKMEG5rpspE73aum7FytQHHfqXnnGt7VQ4Cx6iFQTUQ6Lxzo3ZGGHxGO/lgO1
         KN8Y4gUO9NHGSa7hFIzKow7TcDLENIbLlsfrkoOZeDmW9RnLocMmGB12maHrlrIbH+MD
         alebtErpYg+ctacjWyiuntGy+o1iPKtAbDlhyigGqCA4wQP0IpzbiVchbYj5I5sCjvjK
         LmynYFeHYVxyXlcYvWDYfdXf4y2hgn45LN589BefXGpWprtmaTzIVXnFvn/yjSKMJjcc
         xiog==
X-Gm-Message-State: AOAM533Zu7dzehVxDHLzEB2kaXttikK4w98Ne5St22XY5mH5bKvGkHLe
        AlaBTVu/mqAfJmksJ/IZSeM=
X-Google-Smtp-Source: ABdhPJw8cXFyTyLdG6JCAtbc4sjRmCNTK77Ir+mIF3DcL3bP6srisXk3GfWyXEwIMY1ekRG9lqltNg==
X-Received: by 2002:adf:9d92:: with SMTP id p18mr5984751wre.20.1628800886867;
        Thu, 12 Aug 2021 13:41:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id i10sm10296556wmq.21.2021.08.12.13.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 13:41:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com,
        asml.silence@gmail.com
Subject: [PATCH v2 2/2] io_uring: don't retry with truncated iter
Date:   Thu, 12 Aug 2021 21:40:47 +0100
Message-Id: <71d0711b4e28d01cd06e2c96db5adf0b766ac27f.1628780390.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628780390.git.asml.silence@gmail.com>
References: <cover.1628780390.git.asml.silence@gmail.com>
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

Avoid reverting truncated iterators, so io_uring would fail requests
with EAGAIN instead of retrying them.

Cc: stable@vger.kernel.org
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index efd818419014..2e168051262d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2462,6 +2462,16 @@ static void kiocb_end_write(struct io_kiocb *req)
 	}
 }
 
+static inline bool io_check_truncated(struct iov_iter *i, size_t len)
+{
+	if (unlikely(i->truncated)) {
+		if (iov_iter_count(i) != len)
+			return false;
+		i->truncated = false;
+	}
+	return true;
+}
+
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
@@ -2469,6 +2479,8 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 
 	if (!rw)
 		return !io_req_prep_async(req);
+	if (!io_check_truncated(&rw->iter, req->result))
+		return false;
 	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
 	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
 	return true;
@@ -3328,6 +3340,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
+		if (!io_check_truncated(iter, io_size))
+			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
@@ -3467,6 +3481,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
+		if (!io_check_truncated(iter, io_size))
+			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-- 
2.32.0

