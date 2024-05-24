Return-Path: <io-uring+bounces-1962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DCB8CEC96
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 01:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 684E21C20EDD
	for <lists+io-uring@lfdr.de>; Fri, 24 May 2024 23:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47C08529E;
	Fri, 24 May 2024 23:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AIpsMpA7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0468E128375
	for <io-uring@vger.kernel.org>; Fri, 24 May 2024 23:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716591915; cv=none; b=Ka2KXoIgvS/przk34g5gkNHaUEtvvkYXoej+VYWip7TRURedaZ86C3APYz2IJugEHetgcgnpr0ugva2x5iVQVqLuKs817Bz6xmFgX1GoEtVb55SQC8H+cdM06JLbt7G/snbI0+ashdsPzQ/Z56hBtYkza6mI9jzb1PUWJyUgVcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716591915; c=relaxed/simple;
	bh=HuwTchKXVEOVFWPvm1c8IrnxAYgzECvApfsMp9S2qiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMy3p5WY0yjhxsB3RIWlHFXdXnMJAoBp41ySF6kCQLzmVdEpK5UZ865OPRv8cHydGbOxE6RxBpuLldc+LLvN0ZwORh+h5IZgGHybU+7JBLuqQ7yS94phGzktPboHV22ud/72bJuEsazQLfflbD61HKiY0EDkHOqkozDKJZYzaIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AIpsMpA7; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2bf5ba9a2c5so255375a91.0
        for <io-uring@vger.kernel.org>; Fri, 24 May 2024 16:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716591913; x=1717196713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tTCqtzG38P5ezjXGz+gaZMEKifQ9r85IputMtEIhqE=;
        b=AIpsMpA7uMzDdie+YHXHkvUIe1c6jIgUPTVV1pZ2IkgKzyjLC0s6uUW7B1+hEHKrw+
         hz+vQZ9o28msrsmB0UeOdRmYr8W29e1YWlJR3zB4BMF7N2a2gjat9cUcpDK3ZR97STFN
         zyoPAb8hxS7hDUVzJIr+4aOmLDeaN+iNW00X/m+ohjMaobjq0ajEMMw+1Imj2l5wmJyU
         JnDm4OVcVSXU2O1Bnjo/ov4Mq+a/8GVK7QUzufcbEEwMk8Zs76FQyh1Uw9HSgeI3dTn1
         k2im7YrszVpSk/oJqDXv/w80n6NLK/IZF1HqLRPmJivWrI7GTDECg6Rhh0XIsP5Fxsz5
         R8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716591913; x=1717196713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5tTCqtzG38P5ezjXGz+gaZMEKifQ9r85IputMtEIhqE=;
        b=r9+gHKCe8q+FMzeyEppXRvmT0rKOHyA2tDtUPO5smWujyIKka3SNXCPUj9Wyks16Ac
         bkLqhUfdQlrZ3Zl7o60OFLf5Q8QgGADWg14ysSjkUlSzJ11sWDdmlQNfEP8K7LdPaRwt
         rO9aW5KbFX7T8YfU4caKg8x+Cm4hT6H4mn2LcA71SMSaAhNm2aP9S07IMsGxmQcMJue+
         tmr92P2dlQKF48egORG/9XeSzcP3uYCBZ0JFcleSDOI6KQN+4tdQ4bPA5MmiCoZmSqsj
         I4y6uJ35DxGlTU7iAthHY0Q+1G83f1TIVCNO36eYnBrPCWjJe7fgqV49fUolScv97xeF
         feVA==
X-Gm-Message-State: AOJu0YxIG1LDv/mZkjWP4FssK8fU7I+fW7j/QBy8FVKyO0c8SMPEIhwG
	IPLxgFRL7KB1zpgfcXm9j0gTfV6/m5XXdD3X87qICZr5XveTpNa8YzSGrQhe4fQ/0+To992I9Vo
	1
X-Google-Smtp-Source: AGHT+IHaLUK3HyBDLm6geJTOxcEhm+y2CEUUteAZTFKpKZ0Z0nkF8zP+ciRt5mhakuBomYa+A1GpLw==
X-Received: by 2002:a17:902:e5cd:b0:1f2:efdf:a403 with SMTP id d9443c01a7336-1f4498ec503mr40824855ad.4.1716591912828;
        Fri, 24 May 2024 16:05:12 -0700 (PDT)
Received: from localhost.localdomain ([2620:10d:c090:400::5:7713])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59besm19147625ad.106.2024.05.24.16.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 16:05:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/msg_ring: avoid double indirection task_work for fd passing
Date: Fri, 24 May 2024 16:58:48 -0600
Message-ID: <20240524230501.20178-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240524230501.20178-1-axboe@kernel.dk>
References: <20240524230501.20178-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like what was done for MSG_RING data passing avoiding a double task_work
roundtrip for IORING_SETUP_SINGLE_ISSUER, implement the same model for
fd passing. File descriptor passing is separately locked anyway, so the
only remaining issue is CQE posting, just like it was for data passing.
And for that, we can use the same approach.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 48 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 3f89ff3a40ad..499702425711 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -299,6 +299,41 @@ static void io_msg_tw_fd_complete(struct callback_head *head)
 	io_req_queue_tw_complete(req, ret);
 }
 
+static int io_msg_install_remote(struct io_msg *msg, unsigned int issue_flags,
+				 struct io_ring_ctx *target_ctx)
+{
+	bool skip_cqe = msg->flags & IORING_MSG_RING_CQE_SKIP;
+	struct io_overflow_cqe *ocqe;
+	int ret;
+
+	if (!skip_cqe) {
+		ocqe = io_alloc_overflow(target_ctx);
+		if (!ocqe)
+			return -ENOMEM;
+	}
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags))) {
+		kfree(ocqe);
+		return -EAGAIN;
+	}
+
+	ret = __io_fixed_fd_install(target_ctx, msg->src_file, msg->dst_fd);
+	if (ret < 0)
+		goto out;
+
+	msg->src_file = NULL;
+
+	if (!skip_cqe) {
+		ocqe->cqe.flags = 0;
+		io_msg_add_overflow(msg, target_ctx, ocqe, ret);
+		return 0;
+	}
+out:
+	mutex_unlock(&target_ctx->uring_lock);
+	kfree(ocqe);
+	return ret;
+}
+
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -320,8 +355,17 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_fd_complete);
+	if (io_msg_need_remote(target_ctx)) {
+		int ret;
+
+		ret = io_msg_install_remote(msg, issue_flags, target_ctx);
+		if (ret == -EAGAIN)
+			return io_msg_exec_remote(req, io_msg_tw_fd_complete);
+		else if (ret < 0)
+			return ret;
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+		return 0;
+	}
 	return io_msg_install_complete(req, issue_flags);
 }
 
-- 
2.43.0


