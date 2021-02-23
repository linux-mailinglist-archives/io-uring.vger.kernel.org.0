Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB683223F9
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhBWCBL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhBWCBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:09 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A2BC0617A7
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:57 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m1so962839wml.2
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GqlOkRULl0QCIwb4aTB0E8o2aMv3xZ7A/06vmFZkPkM=;
        b=trze2FNmbPm0dDoPgzAPqpOAwwNIRxBy7GrT6WeMxQGkpvAzp5GJZPsYJPVMepZxIS
         xKqWWeHZs9SIDaHgoCxESGwGPrLKdbHzEDJU88uN9Yx+ViThYjFhbz9poQZSJe3o/psX
         ucA0uszQU++MK9BiB3m46SZWb3BC2RstEAt9EOzL4aDkdO185HO/lmv6Ix36oghhE1PG
         5AxjPIt96LQLad2hicQyr4MUaLnWRHMiRDgPzKkrWULxzgBF7RPRWfEPLM4ClDf00hdr
         UarsYmLY9+IHVSeSaygOgvxoc+T68xRQDloFqcurIBPrFpv11AE3Z+Cv24gL6uuWJGG6
         vk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GqlOkRULl0QCIwb4aTB0E8o2aMv3xZ7A/06vmFZkPkM=;
        b=bbdcMIC5z9ppXitW3SjDkH0YuG1OyxC+4nGu+zx9rBF/coW1233Jqspsxj+utsGXZ/
         8icLt9JUspW/hsuJR6C2uvdbY9EpHy1AbkWAacft87NG5sSF9BYmfcKTwMCgqQbSHGcK
         BtP0FTUloJa/LXHMB7K/ljtiwgJ8KKIWIGWKNnA82/OenRY1cH5lA3CZ9He7RrmNJAzV
         7mMC7+Djy5uvV20TiV4or0g9YsVkYLjShMAFgi/ngx6uXLpFd4aUj5dLocDlgJ6Cgpve
         ygEajhcBzucMh1VsRZ81t0DDV9028jHzaApFOkPIwdOSCvvhjVeFYQqrzCA9+XSnFDSd
         AoIA==
X-Gm-Message-State: AOAM530ZsiyKx9ijdCEXd/2b/SslAPVR/WmqrY19D56GUlxOVm1OF5KM
        jeQti+w9aGP8XW8IdZA1uBlM5cmE55U=
X-Google-Smtp-Source: ABdhPJxZri4AgZxuAVprrm3KFvyKm2WbmeRd9TZN0awg5LJ6A3SHPNyuqavCzZnqcIS3LRklKgU5qQ==
X-Received: by 2002:a1c:7f93:: with SMTP id a141mr22926283wmd.105.1614045595891;
        Mon, 22 Feb 2021 17:59:55 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/13] io_uring: refactor out send/recv async setup
Date:   Tue, 23 Feb 2021 01:55:44 +0000
Message-Id: <d97add1614ede8229e923747a01a9b755d62628b.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_[SEND,RECV] don't need async setup neither will get into
io_req_prep_async(). Remove them from io_req_prep_async() and remove
needs_async_data checks from the related setup functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4d69f9db5fb..b3585226bfb5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4325,8 +4325,6 @@ static int io_sendmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -4546,8 +4544,6 @@ static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
 
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
 	ret = io_recvmsg_copy_hdr(req, req->async_data);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -5802,10 +5798,8 @@ static int io_req_prep_async(struct io_kiocb *req)
 	case IORING_OP_WRITE:
 		return io_rw_prep_async(req, WRITE);
 	case IORING_OP_SENDMSG:
-	case IORING_OP_SEND:
 		return io_sendmsg_prep_async(req);
 	case IORING_OP_RECVMSG:
-	case IORING_OP_RECV:
 		return io_recvmsg_prep_async(req);
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
-- 
2.24.0

