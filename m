Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79153E4516
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 13:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhHILxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 07:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbhHILxh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 07:53:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF9AC0613D3;
        Mon,  9 Aug 2021 04:53:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z4so21044303wrv.11;
        Mon, 09 Aug 2021 04:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cQ0GxBzmBn0cY4nHySpyNtgPjOaBNrfUlQpeSZNDkRc=;
        b=oJhSh/0kkq4ODlZ8g6e4gwwOCd0/b5GX3iAlo8/MygyVVnj8d4uuYo/k1ph36Ncs1U
         zP591o9YDk0R9aXmLARU5lr1qYpAS3HmB4Mo346d08Cduh8TJBPKvtEcVvWpY6G1X+Kh
         vmS+8+Q9BdZGFK3oP877jYxRFLOIJoWT2jSNIvIpEphrL8N3XzQwN4tK1b9EyNJbl+3G
         AMMVAH0TVmvaIQyiRKUSf+TxFVjfRzsZbw7J3/lIv0othlBEzJA3iZJuI7Nmw+Mm9xnG
         /TKaRZpRdQD7QKWKYE7cAqhvRsOC3w4ZI6w4gKG6XpIDl0EHHC8QmGpSOTgIboyknSZH
         NhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQ0GxBzmBn0cY4nHySpyNtgPjOaBNrfUlQpeSZNDkRc=;
        b=DMH3PIl1XJ5RuiEclGDWscT3Pw8wVw2qkpex8T8tYrokgmFOjHZJBFLm7UcMmmm8Hc
         Y5R+hPxL7//H2VMygdFQWWiErMYMhtdZvEbrewfjllBnqDMxRvPX7ai2akdSyb84yKWp
         j9DbEZCC+SOHfFDlOcIRszHhUlWBqqC3x+dgwPPRaPKq1xzv01+rHuuXuOn47Y5+jCPe
         gnZXsqh6VoDeaAm827X/X5tq9ixlXCIcvdMp4cav+LQQDYJDwbATUnQ00An+FrdhO+1/
         nSMbqX4mkgxUKoWUOfEDNJKb0iZEGQuIaoPj/J4EGK/72nHdFoyrV5MZMU7+RCeG5MYd
         9eDw==
X-Gm-Message-State: AOAM530OAVZ+Q5lBXapTwc3R4j/iAZhPUcQUAjqFLwdIxfMHq/DbMPGw
        iTOMPTvmaar0/EeprDK3j0o=
X-Google-Smtp-Source: ABdhPJy1phGKVLGPj+menLFGblTXvdBjRjBg64U7LWqKRet8qKm9kO9ZxIuA3zLJHglSJ0e+eDB47Q==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr25068018wrq.98.1628509995252;
        Mon, 09 Aug 2021 04:53:15 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id f17sm22876828wrt.18.2021.08.09.04.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 04:53:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: don't retry with truncated iter
Date:   Mon,  9 Aug 2021 12:52:37 +0100
Message-Id: <8860f13c571b5b691253d84f781abfb0e97a0c39.1628509745.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628509745.git.asml.silence@gmail.com>
References: <cover.1628509745.git.asml.silence@gmail.com>
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
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf548af0426c..ebf467e0cb0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2425,6 +2425,8 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 
 	if (!rw)
 		return !io_req_prep_async(req);
+	if (rw->iter.truncated)
+		return false;
 	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
 	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
 	return true;
@@ -3316,6 +3318,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
+		if (iter->truncated)
+			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
@@ -3455,6 +3459,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
+		if (iter->truncated)
+			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-- 
2.32.0

