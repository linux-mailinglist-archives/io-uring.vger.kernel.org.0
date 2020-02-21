Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63863168981
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgBUVqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36544 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgBUVqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:19 -0500
Received: by mail-pf1-f196.google.com with SMTP id 185so1958820pfv.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5oPocjKYMCYAb6Mcw1M1Q+crx+RKeUSYt6f3grn+wYg=;
        b=DGZIs0ouUcudrlH1zZiX69o9zazIiP+lV2nfcWNgPcDwoqUw/+JYGfjl9FV0EHwyAx
         y998RFKwhV4NCIadwDjg2Lr8bPcnlpuaJYOnsKWhShXfghejWfNpjv70TgiV7chYy+hC
         tiSRqopoDDRH5gd5DuUvt4ljUl+rxCz9FQm/GiQPy10DbmWHJMB/62dL+vV02QddPhWb
         wrPTRsB852gY1NOcimGHJHcP3waARmd6PmO2nVlfQ0BPpLTv1DaLjsypDzZ1d1WfC2V7
         nDdlR4/4h/FzaySJFRBbMs+GgxsU6J2C/a8zPlM6ndh82A44fN5JkHaw/Hvh5joRPRNH
         UIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oPocjKYMCYAb6Mcw1M1Q+crx+RKeUSYt6f3grn+wYg=;
        b=geftN4Mzx0UwJ66q5bR1Sd+RhNTcQoGazb7xiejSP1HTERH0dQO6aFWGYMyiuLgwWV
         /h3SbLyyYL1DYeiwp2HzjTX6FlZ/J8ajUYRcJ2dX+XYwzgBfktgIR6gO8pzjpi5WUptF
         LJCZmBsUe7aczqun4cZGpCEly1e0kHoDfV0r5duOzBRjiL3uTq0MzLewqweeenMyl4u7
         Xt4lbSoz6pT/uLFiHJ7EiuhtbVUpq+QA+i74j64PXNj/n5TXb263CYaiS0XqsIHnboPH
         /w8978l8Owlo3C4o7Ly8nAmYUt8QO4MVdyDEy8Gpr7JyJnwBSZ9KUA7Yp17s8UtuK5Vp
         x8hg==
X-Gm-Message-State: APjAAAV3shCpsuDT5BmRRknH7+2PSlGWPbI3TN+MwxB8Xs8wWEBuW7Js
        2sJnJPZN8BVsvwNklHEGclq/YQlEEbc=
X-Google-Smtp-Source: APXvYqx2IuALjVlupaw9Sy0zDLMwKk51AZRIHGdSpYOpn+wvx4VVflLD4PVML3CfmAfetlUWeLdjoA==
X-Received: by 2002:a63:4281:: with SMTP id p123mr39685627pga.371.1582321577146;
        Fri, 21 Feb 2020 13:46:17 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring: mark requests that we can do poll async in io_op_defs
Date:   Fri, 21 Feb 2020 14:46:05 -0700
Message-Id: <20200221214606.12533-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221214606.12533-1-axboe@kernel.dk>
References: <20200221214606.12533-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a pollin/pollout field to the request table, and have commands that
we can safely poll for properly marked.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5262527af86e..129361869d09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -624,6 +624,9 @@ struct io_op_def {
 	unsigned		file_table : 1;
 	/* needs ->fs */
 	unsigned		needs_fs : 1;
+	/* set if opcode supports polled "wait" */
+	unsigned		pollin : 1;
+	unsigned		pollout : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -633,6 +636,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
@@ -640,6 +644,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -647,11 +652,13 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -667,6 +674,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
@@ -674,6 +682,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -685,6 +694,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.file_table		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
@@ -696,6 +706,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
@@ -724,11 +735,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -740,11 +753,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECV] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
-- 
2.25.1

