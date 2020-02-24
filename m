Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF64316ADC0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgBXRjp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:39:45 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33990 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBXRjo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:39:44 -0500
Received: by mail-il1-f196.google.com with SMTP id l4so8445162ilj.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3nIAhe6/KXlMKKv3bS7G6Bgh20o9rS+pQ71PyrKZLww=;
        b=ACopfeos/ywWS4a7ry7tIc7ZxTMPNIURjKo0dmuRcRkK559Ufg5cyUq/4hkaWHC3ay
         sBFta71SSQt0yjS1QW/Z5UEDj4tJRZDxLFrAFwsSQadFFJ+1BTq2EZ655rChEXk4yTcC
         gX5+jUqx3mnVQE+zpbJqTMLAnTk4oKHMWDB+G5dE51x1n5SfS5FKNAVwAeu9J7JIMrX1
         +yDabU0KbL8pevLxmEZGOx72II2ufkIRwGieBHGZf5K4PRTU3gzhKB9VIrOAiUqMZjri
         2lDN0aVvNJGgG3Hso+A0cBGFAEuTO0T+qfxrf5kbpSxibZ9zIcQUr3xLiDnVJLcI5Emn
         h9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3nIAhe6/KXlMKKv3bS7G6Bgh20o9rS+pQ71PyrKZLww=;
        b=CgmeWPy+hIH/ffnlL7EQxXSP28AnBFJlQHcslsWA4bZLYYJyKAUwVWi4sRVVoD48hN
         JBjW/H4/0fxWJsXwBD+3ZXWl9+ZtLRY1j3QPsYgnnnRHPUPtOq3YDycyPlmtVWkgZxG6
         C2bk7TSWluH+3maDwvbCuLJsGDpZkgzRGwoPzu7hfy3ztJrfF1x+lgNPiBxCirnplz+h
         ZAJlsOAa7MBhBGLcbU2luqcZ6s4T3A9q1gfRhC9i1+RBqAx6LQWy8W2uzE9g5J0JpkvJ
         4HqoHDzNreBj6RmE2UXDfteZwgX10qrhJedvy4wOLlydRV6cIy7ChxNxOb/yB3m6Wx2a
         /otA==
X-Gm-Message-State: APjAAAXYrno0TEOG0niYwRzzQtzGuWR3ReWv+l0HUsTS5eN5dkqKb2h8
        t95c7bCnCkfm6zsZ244mx12bxZL/UM0=
X-Google-Smtp-Source: APXvYqyiRms3QsVEptmru4/cYKjEQIzNQIx697MPQwV551HYesGcXghv0LpA647ehW+afzd90kC5Rg==
X-Received: by 2002:a92:d642:: with SMTP id x2mr59412317ilp.169.1582565983845;
        Mon, 24 Feb 2020 09:39:43 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p79sm4541982ill.66.2020.02.24.09.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:39:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: mark requests that we can do poll async in io_op_defs
Date:   Mon, 24 Feb 2020 10:39:36 -0700
Message-Id: <20200224173937.16481-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224173937.16481-1-axboe@kernel.dk>
References: <20200224173937.16481-1-axboe@kernel.dk>
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
index db64c7dd0f58..890f28527c8b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -634,6 +634,9 @@ struct io_op_def {
 	unsigned		file_table : 1;
 	/* needs ->fs */
 	unsigned		needs_fs : 1;
+	/* set if opcode supports polled "wait" */
+	unsigned		pollin : 1;
+	unsigned		pollout : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -643,6 +646,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
@@ -650,6 +654,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -657,11 +662,13 @@ static const struct io_op_def io_op_defs[] = {
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
@@ -677,6 +684,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
@@ -684,6 +692,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -695,6 +704,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.file_table		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
@@ -706,6 +716,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
@@ -734,11 +745,13 @@ static const struct io_op_def io_op_defs[] = {
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
@@ -750,11 +763,13 @@ static const struct io_op_def io_op_defs[] = {
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

