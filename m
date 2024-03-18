Return-Path: <io-uring+bounces-1117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CCB87F2CC
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A2FEB222E1
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3177F5A4CD;
	Mon, 18 Mar 2024 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NX1fgGfr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9DE5A4C4;
	Mon, 18 Mar 2024 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799338; cv=none; b=Xkw2olPxe9AsyM6XBOpzSxv47SxNxKpDRqRbFVcJnMcwGHGdA5yEaDnf3EvGd6a64U+fjTqfjeMFduKdXx0o9i7lsJkEdDnw/RIEetbIzl8cxVgvcT5Jqw8z9QASOslcK7cm/dJNFNgJv2B2ZuVT7awLFQNNKNhmqVRkI8L86sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799338; c=relaxed/simple;
	bh=9vY/DtUnP1rqLrlOMEZB7dtzAeVsa67WGy2r3MI5zp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG04r3npXmbesHwohNLBnHh3r1K7xtaU76RfLnoRSN7b81BMyXYVpi6OwBTC/RyrAuU2OwM5ofXN1bs+4k5WWTtJ6NfWwy87x2B/Doi9D86DGPqOqHzRICQKzIjNhZBSho6oS5nkhbIWRjKvUJ21eCkEjwU130okGYnZ14NA/eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NX1fgGfr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33ed6078884so1805406f8f.1;
        Mon, 18 Mar 2024 15:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799334; x=1711404134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Vz9qyCAXh48FsaL90phLZ5p6nLM8jmfgDzdMhV6mLY=;
        b=NX1fgGfrsFL/+llp3VE2ZAiYrJj2P6cZnjpvWoAJaO1x9uoi6Dg2o8lps74gBOPto6
         5L0PIT9JcVcFZz1PsV2idliTDZusSWJ0DsaClhG4VV/WBtk9GpKMkZ7gzpffN6QV00bD
         Ql9cj+nACHxlS8c0JW7/diJqqWKMjvIc50AXBk5M/qqSZLgIwPWyn/kcX+bv5iGeNCUq
         29aQc6mifhYUiIFIm8owAHViV2lvm5CW16X3MYdL1A1dkaFUQY8gCmnxBtXOlH8xMRQZ
         H+WfeuaQz5cmTBbLCo9OrtIRpjvAr8WG4YQRa/nE5FSvSxxUu4g8/gWEr2LILxFkUDWs
         XTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799334; x=1711404134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Vz9qyCAXh48FsaL90phLZ5p6nLM8jmfgDzdMhV6mLY=;
        b=iHTMcAycSMqHDEy13jbhHcO7oRgVWcskHXb/+QbXUzc4FcwWcw6v9c5Y11bBsJXr62
         TOPUxHCIGJP0vbXCBhwZkadJykV4hTKgqx+1ZSmETcGwSpjqykS65c7V8Wj1C1iXvoc3
         a85YDiPs5e85Bfda/YH9ds/8Finly9kF6HhCWVFtdXu/eKUUO7k3dfn6GJujYo5mBctH
         cTJ7Je9pfaLe94tbsoZPu4MvonxIoRxE0RRjq9hgbBhrEo1lekYwWU/rjjNlvXM4hhA4
         5ZT97H+20JVlM7e8pf/hjQhCCcSClIwQvW+STjBPZn/xXRIigXWWiK0ZW1O56N57jVfq
         7mEg==
X-Gm-Message-State: AOJu0YxQ86FUmbqja62VLZ9CMPxx6vvIdsJqtEczBGiA2ukqjvFpXvTT
	xV8jNBf0L7lFzYERzSawf3mkJ8CDGu2wOcUjZqDyysPf/vlnfBMHlU3mSGYu
X-Google-Smtp-Source: AGHT+IG5jlNB2MPc7bXOq8Dnjr9Xh8n0k8tMahOd1m55YdFwq5AVjcgtPyOc6ckF8HkXT6a0o5GcUA==
X-Received: by 2002:adf:cf01:0:b0:33e:6ef3:b68e with SMTP id o1-20020adfcf01000000b0033e6ef3b68emr622948wrj.34.1710799333795;
        Mon, 18 Mar 2024 15:02:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 03/13] io_uring/cmd: fix tw <-> issue_flags conversion
Date: Mon, 18 Mar 2024 22:00:25 +0000
Message-ID: <aef76d34fe9410df8ecc42a14544fd76cd9d8b9e.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

!IO_URING_F_UNLOCKED does not translate to availability of the deferred
completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
pass and look for to use io_req_complete_defer() and other variants.

Luckily, it's not a real problem as two wrongs actually made it right,
at least as far as io_uring_cmd_work() goes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 7c1c58c5837e..759f919b14a9 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -36,7 +36,8 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 			/* ->sqe isn't available if no async data */
 			if (!req_has_async_data(req))
 				cmd->sqe = NULL;
-			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
+			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL |
+						   IO_URING_F_COMPLETE_DEFER);
 			ret = true;
 		}
 	}
@@ -86,7 +87,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
+	unsigned issue_flags = IO_URING_F_UNLOCKED;
+
+	/* locked task_work executor checks the deffered list completion */
+	if (ts->locked)
+		issue_flags = IO_URING_F_COMPLETE_DEFER;
 
 	ioucmd->task_work_cb(ioucmd, issue_flags);
 }
@@ -130,7 +135,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
+		if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
+			return;
 		io_req_complete_defer(req);
 	} else {
 		req->io_task_work.func = io_req_task_complete;
-- 
2.44.0


