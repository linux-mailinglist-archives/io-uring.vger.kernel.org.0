Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55011418F9
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 19:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgARSgj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 13:36:39 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45419 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgARSgj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 13:36:39 -0500
Received: by mail-lf1-f65.google.com with SMTP id 203so20827168lfa.12;
        Sat, 18 Jan 2020 10:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xNjiUMlglQERXzUkQKKb/phm7LhpDVoHlDxOq9rpQsE=;
        b=QflEfHsyZuPeTAWh490dwhBGPzBQDDRixooRxNF9J6xN/grPk4hBbXOKK730WvDUH7
         4048AtYI7LIC1lanRUMNMeHa+7BcQN2AGm1xA3lDYierQpQhkkixA2mVRQcUmU14efZv
         FAWyEB7V94lbJvz8hx0CszlhwevjAaLWiE22cEVzDv2hYvqjBjk/CZEeeY5Wu8pycm6z
         SYmnKVa75lC6aLxs3xIKKH29PV6b6NYZb8HM9hJAO9L2xCn8MXM0KCkK+NhMugGpN8CX
         jrA89qLVpJyvsVezC7SfeJ5mZ/wtAPUoYRy3F2iyf1ZgnyBRWkKcPjZaQH/KzJsigDTQ
         JFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xNjiUMlglQERXzUkQKKb/phm7LhpDVoHlDxOq9rpQsE=;
        b=n4hh8zfClacm0XycFqssbLyz8NYddr13GX6B986Gh/aHbm3UzKoUA2HQ2PxB4TDt0E
         fvzXVUwOpeMUdZ0jtsDzkbE/27Z+BOdi7EajpshSrgCQLdR48HDR261RqYHCEIC3TIFl
         zLy04tQn0loG77U1+8kglke4hXgkyrgNet0cvb7DroaWNfq2W4jhuIjvxv8YkVJOSvQM
         lwWhAmVV1NLuUN9bCkGyqxq+k4riv6QrfcWz4gHKSLJcsXSq+HdZIXfDT6jKvOVbPfmd
         QAz8x4tqRHlDP1HmsigfXVFdB21WhBtRoFHNclg87+y6BVJ0dvuRS7tvU0lMyJe0EAO9
         3xjg==
X-Gm-Message-State: APjAAAUqQoWL3bEbHmJingTVmjGDW70P5gz30LwfkZ5RypqBiJ0V7op3
        eWxMdC/5zJuPZ3yAgrpowGM=
X-Google-Smtp-Source: APXvYqzoqaaLwfqVm4G44LHAYQNemqL+9bLM3l/YkyLEemeNDfW86pr0SllbZnKSpYsozIv4X0j5Qw==
X-Received: by 2002:a19:4ac2:: with SMTP id x185mr8691970lfa.131.1579372596207;
        Sat, 18 Jan 2020 10:36:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id s9sm16572189ljh.90.2020.01.18.10.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 10:36:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: use labeled array init in io_op_defs
Date:   Sat, 18 Jan 2020 21:35:38 +0300
Message-Id: <b23c570236ab4b1f47603e52ef545875ac632df8.1579372106.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't rely on implicit ordering of IORING_OP_ and explicitly place them
at a right place in io_op_defs. Now former comments are now a part of
the code and won't ever outdate.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 91 ++++++++++++++++-----------------------------------
 1 file changed, 29 insertions(+), 62 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cf5bad51f752..09503d1e9e45 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -604,151 +604,118 @@ struct io_op_def {
 };
 
 static const struct io_op_def io_op_defs[] = {
-	{
-		/* IORING_OP_NOP */
-	},
-	{
-		/* IORING_OP_READV */
+	[IORING_OP_NOP] = {},
+	[IORING_OP_READV] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_WRITEV */
+	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_FSYNC */
+	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
 	},
-	{
-		/* IORING_OP_READ_FIXED */
+	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_WRITE_FIXED */
+	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_POLL_ADD */
+	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_POLL_REMOVE */
-	},
-	{
-		/* IORING_OP_SYNC_FILE_RANGE */
+	[IORING_OP_POLL_REMOVE] = {},
+	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
 	},
-	{
-		/* IORING_OP_SENDMSG */
+	[IORING_OP_SENDMSG] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_RECVMSG */
+	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_TIMEOUT */
+	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 	},
-	{
-		/* IORING_OP_TIMEOUT_REMOVE */
-	},
-	{
-		/* IORING_OP_ACCEPT */
+	[IORING_OP_TIMEOUT_REMOVE] = {},
+	[IORING_OP_ACCEPT] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_ASYNC_CANCEL */
-	},
-	{
-		/* IORING_OP_LINK_TIMEOUT */
+	[IORING_OP_ASYNC_CANCEL] = {},
+	[IORING_OP_LINK_TIMEOUT] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 	},
-	{
-		/* IORING_OP_CONNECT */
+	[IORING_OP_CONNECT] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_FALLOCATE */
+	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
 	},
-	{
-		/* IORING_OP_OPENAT */
+	[IORING_OP_OPENAT] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 	},
-	{
-		/* IORING_OP_CLOSE */
+	[IORING_OP_CLOSE] = {
 		.needs_file		= 1,
 	},
-	{
-		/* IORING_OP_FILES_UPDATE */
+	[IORING_OP_FILES_UPDATE] = {
 		.needs_mm		= 1,
 	},
-	{
-		/* IORING_OP_STATX */
+	[IORING_OP_STATX] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 	},
-	{
-		/* IORING_OP_READ */
+	[IORING_OP_READ] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_WRITE */
+	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_FADVISE */
+	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
 	},
-	{
-		/* IORING_OP_MADVISE */
+	[IORING_OP_MADVISE] = {
 		.needs_mm		= 1,
 	},
-	{
-		/* IORING_OP_SEND */
+	[IORING_OP_SEND] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_RECV */
+	[IORING_OP_RECV] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
-	{
-		/* IORING_OP_OPENAT2 */
+	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 	},
-- 
2.24.0

