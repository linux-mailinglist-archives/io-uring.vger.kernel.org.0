Return-Path: <io-uring+bounces-1377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE14D8971C5
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 15:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B81E1F220B8
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 13:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BB2148FE7;
	Wed,  3 Apr 2024 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nu0J10Zb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E475B148FEA
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152575; cv=none; b=Le35xFcnVotTZPAsWMFhPSU0hQCHut8bUyGle0kmfh5MwECOQCz+Hh4Oc4vuRV3IX3LdL0KbOB1ycwE+jdi7SEuFL6c8WJC3YNWAJWkeEKd8FRpztJJhOawFoNe85KJhMyLE+bVmUHKqdTWLP8LHYU5rHB3OQixwXVehHVA4tzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152575; c=relaxed/simple;
	bh=Q3ertwRbJ2RqliQR4i/fwo7C3RrhtepZnt+fHIKsOs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egx48O8YgxD8O4PEGqCR8IRhCDIAk6YrghxuznVE/kFgMXzhMgJuoDnlneMUCzD/DLJBDNRotJOazMfzv4qsAA7wSq3ScNpDptY+RKzlZHTOtMkZ2+rFtLV8uWUNMDMGkwYiy0V/9fUjDhPlDNHbr7Zkn/pOhUXNq3vcF3hRDxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nu0J10Zb; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so60237239f.1
        for <io-uring@vger.kernel.org>; Wed, 03 Apr 2024 06:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712152572; x=1712757372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZqqJA8ALtTyDvrrt7I55rk6zP/dlq3hEacG6s3xgPg=;
        b=nu0J10Zb1SzD4K4YZCTugZgc1J+/l4T7BQfaNwBR4JiPHL+NNG4IXoyUSs4WsVM5Qt
         Ty9pxAjncaAX5dnqco6DDvq9B2rcPEP+QONiE823USUsG2EyRY7iCmBfUb/Yr+UmBQ+R
         yq6dRJMT4mJTY8BGHLYifGmNjUS/Y383WoAz71rEQLHS2vmNT65lh3gQmJC5EfE/0fuT
         sb+sb8Ar0DIEPatL67pdFJC2yucbs2GO3Zkq13HkdbU4HsVYlaU8v7BCxqDJaMApT5Vz
         xAqieyMIdyb1wlt/oEKStZXikxmFpPHCtmMRvunzUmAb7a7JFCAUhwu8LAoMbfPdg51V
         f9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152572; x=1712757372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZqqJA8ALtTyDvrrt7I55rk6zP/dlq3hEacG6s3xgPg=;
        b=vGHmrhsY6loBRlQreOg1G12l3oFc1h/wHRqwTeYmhdKL168SCA2CxQibpRb4pJefXR
         aig0PLvsrMRxvql+4ltoJTTCnAtc0UheSS4odD50G69oBbaoGeRAyj28P3hzo9Ug7lnF
         If6fo7ldO/3lT7P8JMf5ibXKRcl2b6R8J+rHFh9mAoww434sQWmNWZ/CEIuSIdbMONUV
         Wj0vLTt7k/nF+2pnhua3H58UL6jav03OD5a5NiLV1YD1zXGSq3qiEbih+pOemiNk0weS
         Q2uBJsVU/lw7HcETRIO0a//PjvB5a7Z6a/rEvbMoyzMMZzxYFoazVnXYprwJzY9BJRIN
         akhw==
X-Gm-Message-State: AOJu0YyjWEGxXIPBk4WVZxR6r6x0uuK8c9MsPVaDF974ceh+gb5DHfAP
	KehJuhLb8OAyQhaSm9CDwhsN/Tp5ltzvvmVweUAyV8/gLuX50XaYFX/NRx19KiKbdJiwITHPZln
	6
X-Google-Smtp-Source: AGHT+IEQZcSivTFZIHLlrt0jRWclzP+hLkh7BSrRwFr6CyInaPLSBuHjFf9QQChSbWn6Jabz3IdU8A==
X-Received: by 2002:a6b:c949:0:b0:7d0:bd2b:43ba with SMTP id z70-20020a6bc949000000b007d0bd2b43bamr11499467iof.0.1712152572647;
        Wed, 03 Apr 2024 06:56:12 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l14-20020a02ccee000000b0047ec296d3c1sm3839460jaq.19.2024.04.03.06.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 06:56:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 3/4] io_uring/kbuf: protect io_buffer_list teardown with a reference
Date: Wed,  3 Apr 2024 07:52:36 -0600
Message-ID: <20240403135602.1623312-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240403135602.1623312-1-axboe@kernel.dk>
References: <20240403135602.1623312-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for being able
to keep the buffer list alive outside of the ctx->uring_lock.

Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 15 +++++++++++----
 io_uring/kbuf.h |  2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 011280d873e7..2edc6854f6f3 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -61,6 +61,7 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
+	atomic_set(&bl->refs, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -265,6 +266,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	if (atomic_dec_and_test(&bl->refs)) {
+		__io_remove_buffers(ctx, bl, -1U);
+		kfree_rcu(bl, rcu);
+	}
+}
+
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
@@ -274,8 +283,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		io_put_bl(ctx, bl);
 	}
 
 	/*
@@ -680,9 +688,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!bl->is_buf_ring)
 		return -EINVAL;
 
-	__io_remove_buffers(ctx, bl, -1U);
 	xa_erase(&ctx->io_bl_xa, bl->bgid);
-	kfree_rcu(bl, rcu);
+	io_put_bl(ctx, bl);
 	return 0;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index fdbb10449513..8b868a1744e2 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -25,6 +25,8 @@ struct io_buffer_list {
 	__u16 head;
 	__u16 mask;
 
+	atomic_t refs;
+
 	/* ring mapped provided buffers */
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
-- 
2.43.0


