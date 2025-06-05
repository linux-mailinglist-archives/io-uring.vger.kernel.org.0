Return-Path: <io-uring+bounces-8238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2448FACF849
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 21:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D961C16B312
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 19:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B5D27D779;
	Thu,  5 Jun 2025 19:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C5xg6QQI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9465227703E
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 19:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152860; cv=none; b=lPBZ0WjnEofIIBq/dlf1MIeYEY9qljof+WS4AkDMLVcZ72S4vQAyTFgeU39eHMtxzaPBvp8W97t+GwBFtyIyIzd0N9J/o+2bcBB38dpF0lM3FiSLWn0uJQNsBNOyxCOGlPEfXvbCSCB5BYsTUyFbNgi4HLsVWVqfncKFCmT1Z1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152860; c=relaxed/simple;
	bh=ScHs11hD3Ox5LLS1497W6az2HhWuaJKk9KCYf797vj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6dm9NRu9r1bKCsbtoQ9I6jsv3Xuaofj9427JQUTwxD9Y2k9joxRHfvF6QhjJf5m9PKgoZg/WCNSBl6GjSjIreMAtiSTjCK+wqWr8dZ9BFTRA4uv0RgM0d1qj4K1nFP250vGRYe8/n7kYkqlMiHswqQpm7KhP8TiWh4FkQuspw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C5xg6QQI; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-86a464849c2so46946539f.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 12:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749152857; x=1749757657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/FUdwzcVt7GeoNZ5819A3pXsvOycoDp2EUJoLzaImc=;
        b=C5xg6QQIIqZHRdl06cagF+9AKaT/J0XQHpIrz2oOsePtoB0eiRTfhIiA/ZljWIgOOt
         Bn4TTZMTQH1MxYmT3W3MAbn6FwdLwJMC7Un8rE3qqlEgXMXbV6QT4KV0M8GIL9kea0XO
         fwNIb1rMT1uato8ekiOPA0s70QNj24+W7TTnt0QnUdUUIgAbpA8EqgDARcMXl52yQVTO
         CVHn+ze/UHe/FaAiZqqRQqOpvZLTXV0Y/qvUCcXpuZyKzjSE2PUY3WxtH62YtMlocSs0
         EnowJ0/g9htvE+2BYCeIS5DAtCD4mMLi9rhu7kBKxwatMKYqyu+bzSt8jg+i5ogO8Hmk
         n+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749152857; x=1749757657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/FUdwzcVt7GeoNZ5819A3pXsvOycoDp2EUJoLzaImc=;
        b=gzeHcRObC7x7dfdtP/Xd3/HOhfa3pAGn1Lo6QxJwgYBVhDUf4OjMo1OL+7aqV5Q6R8
         K5fPmQ0nhyXoDPXyjyrNb/RMWWFlmuUw7xmo4RPAeHfL9Y82fUNXMem2AYkjhnuqAIgT
         wKmEtnDeIgSLinXrYwksGFLv7O0piI+6WS6KMG3NMqoJi6UDLIrSIDpxKPmX87q8TzLG
         Lk2kCKZWLSVo+KRnYRDRyHkZMg1Z+ZDk4lw4SSN90O5XXYbk7+qr3ZyeHalsGJd5LEA7
         4Ai3omOBru0KDiaJzh2VKuSnwuiy3AhebAruDJAf9W8qyfXLXisQ/PqVcAjELcgEWOug
         1g4w==
X-Gm-Message-State: AOJu0YzyizGCuxWiLXUOqTP1qNw0uRvy+IHzplUt8+8TvQBkKEyRaEDi
	dybV3AIIYWe/bgvdHtaT9nOwOmUNvqygA8dXAfPKnpVL6IGzKFM9FuNV5weuQIGjgFR91Gku6sz
	aYrCz
X-Gm-Gg: ASbGnctgGDRDzmQlb2Siz4gsYpqmdQbb1/74vISTtpzidT6ZZoHdf+Dc7jLYVcHe/Dd
	zIXVtnkJUSQQlKDbrmSgDjoBqFZRfelrDbCqk/sWcf/T6plVxEVB/JgLJx7nPvVRDIQp4He9ok8
	kOgQbr21n8/dO4vRX2Nobdb9aJEIURHqLmDn8apSpuq9l2+laUM4grH+dmxGLP4qKb44dr5fxHq
	Zl0jV6xuwu0ZLzovYYIfEmcIngaVYjfJEh44j8ZJ9NMlFwbWjx6rXTnqkhHWLDGimwMEJIWDlEl
	F4cVgBiRfunixJ2u5HsWZVGJllhDCQj5rxsGQnZuvypGNU6uh9QZhvQHRy4UjNnJDA==
X-Google-Smtp-Source: AGHT+IE1pQJGCczX+MzNI2CmEdcdG2eAtLZwSGatVv4EnGxfbj9rYMN2jnAbi/m73doh+zxAP5IKew==
X-Received: by 2002:a05:6602:3791:b0:867:8bb:4d8 with SMTP id ca18e2360f4ac-87336f04279mr76008139f.0.1749152857119;
        Thu, 05 Jun 2025 12:47:37 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm317783639f.19.2025.06.05.12.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 12:47:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid unnecessary copies
Date: Thu,  5 Jun 2025 13:40:44 -0600
Message-ID: <20250605194728.145287-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605194728.145287-1-axboe@kernel.dk>
References: <20250605194728.145287-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd currently copies the full SQE at prep time, just in case it
needs it to be stable. Opt in to using ->sqe_copy() to let the core of
io_uring decide when to copy SQEs.

This provides two checks to see if ioucmd->sqe is still valid:

1) If ioucmd->sqe is not the uring copied version AND IO_URING_F_INLINE
   isn't set, then the core of io_uring has a bug. Warn and return
   -EFAULT.

2) If sqe is NULL AND IO_URING_F_INLINE isn't set, then the core of
   io_uring has a bug. Warn and return -EFAULT.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c     |  1 +
 io_uring/uring_cmd.c | 35 ++++++++++++++++++++++++-----------
 io_uring/uring_cmd.h |  2 ++
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 6e0882b051f9..287f9a23b816 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
+		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
 	[IORING_OP_SEND_ZC] = {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e204f4941d72..f682b9d442e1 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -205,16 +205,25 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ac)
 		return -ENOMEM;
 	ac->data.op_data = NULL;
+	ioucmd->sqe = sqe;
+	return 0;
+}
+
+int io_uring_cmd_sqe_copy(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			  unsigned int issue_flags)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_async_cmd *ac = req->async_data;
+
+	if (sqe != ac->sqes) {
+		if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))
+			return -EFAULT;
+		if (WARN_ON_ONCE(!sqe))
+			return -EFAULT;
+		memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
+		ioucmd->sqe = ac->sqes;
+	}
 
-	/*
-	 * Unconditionally cache the SQE for now - this is only needed for
-	 * requests that go async, but prep handlers must ensure that any
-	 * sqe data is stable beyond prep. Since uring_cmd is special in
-	 * that it doesn't read in per-op data, play it safe and ensure that
-	 * any SQE data is stable beyond prep. This can later get relaxed.
-	 */
-	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = ac->sqes;
 	return 0;
 }
 
@@ -251,8 +260,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
-		return ret;
+	if (ret == -EAGAIN) {
+		io_uring_cmd_sqe_copy(req, ioucmd->sqe, issue_flags);
+		return -EAGAIN;
+	} else if (ret == -EIOCBQUEUED) {
+		return -EIOCBQUEUED;
+	}
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index e6a5142c890e..f956b0e7c351 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -11,6 +11,8 @@ struct io_async_cmd {
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_uring_cmd_sqe_copy(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			  unsigned int issue_flags);
 void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-- 
2.49.0


