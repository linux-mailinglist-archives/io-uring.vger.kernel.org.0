Return-Path: <io-uring+bounces-7756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3832A9F173
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EA2C5A1B4A
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE3F26D4F7;
	Mon, 28 Apr 2025 12:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tnx74oFa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F41926A0C5
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844711; cv=none; b=eCLt2PHlT9d29nRv07Rj0GKb6Iork0UW+uDyRQiB7KjKcm/T5B8ljxeGlkN5sAHLdqBHkIo/yTyXLkGyV2cNLNa0HQFvjsu9LpyEXvNKDxPkQwLbIr5l0yP0VRxK1MMpa37/S3IeIYjUvlUKZVcdRJjw2T5JrSPCnRjsFZQ7l8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844711; c=relaxed/simple;
	bh=qiIDawR6f9YymLBxjqbUwteaeq9mc62tMCVZXMImDag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuwjlYsVLnhO8u3KlgssBDkYr55KwP3PLRK4ZLTvOoVOYaZfXvgbzDn8t1u39PYVvxdLJ/M8aAITKWmvTXpgr27NnRTDiC6uiBS/m42jVG2z4FOOIdy8QbzVZt8uRzdIs4gxJtgz047Q6REdzPUtNgaQQtsbZP2RkZM5kG5EG/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tnx74oFa; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac2a81e41e3so845443566b.1
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844707; x=1746449507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4PmLMi5pMAMMzPeJ0wEMo442XH1xHZUTg9j99WowPw=;
        b=Tnx74oFama02rwNrJyI63d/0zmrRFQhdml14d3OqOqqFKRMtZgihncnCHf7USGazTl
         5X+oAN2545Gt3Y0LUnlzXrhzedktPb37u1D/nmSdkWssJyTLb8IDo9/ui6bsF1Xl+W1Z
         uTrCGOF1Scw/ud2Uf1LKge1ViirVhHmnGpgKbHyLx+SzlkQiETSRpihettoujWifSib9
         Hvq9hLWpwVWiER+XEWsm8BX5uxq/c98KWVxFhN4L1cGCr4bB+Zw2BskmUWVGnoD098pN
         thq1ulTfBu8/tIs0BJTSPcQNRo09ksWnl89J9kG696MWIFwtMNx5DHT9Cw71ozIyKMDW
         oSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844707; x=1746449507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4PmLMi5pMAMMzPeJ0wEMo442XH1xHZUTg9j99WowPw=;
        b=gRnrf91V2TMjd08u30yJw1wGHP7KMWHkLl/e6Zfb/Pq/Wg/84XfQnxFwaFL1wP7P+n
         Xb5Jt0jsE64daMNGgPZkXJTZBOt5oEROS7vGhtBEjFhfMMaEI0k6PekjYtOlVs3BWgCo
         vUBUlmeM+Ex65fXK+gUDfYQnPoYuGSjqXyIzHfq1vapWHTULK9vJAv4OdwfoUUSxgect
         KPCWMJRTUp5hu9FNP0icM6bYZM1y9iMVh8r3BjeKp0y1uDPGxmPj5OPozXJ5/5/MDtHx
         MIjgMDElvCoc17oBuAXgJNJrAGRV+RuY580P0+h0FC1xIC1Rnbfo+e7zsDhIfKQ1fULE
         +AQA==
X-Gm-Message-State: AOJu0YyRO2wA8EEikynSdhNzXFE+Qt8OF2k/w90fG0uZtIrvJ7fYTdjd
	9uEayEJU6XS8VLX0AGQdV7sn761bKr7ysnjnM6zjquLVEvDHi8jQhoHp9A==
X-Gm-Gg: ASbGncuphUBUp3WWS8zg2rm+vYRygyGruqHX3sAXt5HBkNJpTq6+scNczhcIJTs4Tiy
	Ls0BLLNwIcVyNyraWZCS3pJ60Bqbhgpm/OgdCM0Im1MxcBnPOlHwqsRqZvnJVEgq/47pifNw9h6
	AcOBrSz6NTR9UV78/IUweEap1M0aAzU1qXryT4b02Xz5EXNSHjiZj8usImpKEtzFe4I5tXCYcpL
	mJKsv4kHZOEYlQkyr5nvDfA9WFBqj5FLo7yEL2qT3PtJqmPCmXeARYDPYjuxiX2xNIR4dHgDyFG
	v9RpGaN0m5BDBKJyviRICWKh
X-Google-Smtp-Source: AGHT+IHipXrCJQSWPuAcgdCvotF49jCR9qKRmtxn/pO0OKgInhQweC8BZTNGTdxlEIbfSADoixn+Iw==
X-Received: by 2002:a17:906:d54a:b0:ac8:179a:42f5 with SMTP id a640c23a62f3a-ace7108a276mr1169535466b.14.1745844707253;
        Mon, 28 Apr 2025 05:51:47 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 5/7] io_uring/cmd: allow multishot polled commands
Date: Mon, 28 Apr 2025 13:52:36 +0100
Message-ID: <78412e3b83f97c0855c002579ca2ee4b0b3e98bb.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some commands like timestamping in the next patch can make use of
multishot polling, i.e. REQ_F_APOLL_MULTISHOT. Add support for that,
which is condensed in a single helper called io_cmd_poll_multishot().

The user who wants to continue with a request in a multishot mode must
call the function, and only if it returns 0 the user is free to proceed.
Apart from normal terminal errors, it can also end up with -EIOCBQUEUED,
in which case the user must forward it to the core io_uring. It's
forbidden to use task work while the request is executing in a multishot
mode.

The API is not foolproof, hence it's not exported to modules nor exposed
in public headers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 23 +++++++++++++++++++++++
 io_uring/uring_cmd.h |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 34b450c78e2b..94246ba90e13 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -12,6 +12,7 @@
 #include "alloc_cache.h"
 #include "rsrc.h"
 #include "uring_cmd.h"
+#include "poll.h"
 
 void io_cmd_cache_free(const void *entry)
 {
@@ -136,6 +137,9 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
+		return;
+
 	ioucmd->task_work_cb = task_work_cb;
 	req->io_task_work.func = io_uring_cmd_work;
 	__io_req_task_work_add(req, flags);
@@ -158,6 +162,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
+		return;
+
 	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
 
 	if (ret < 0)
@@ -299,3 +306,19 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 
 	io_req_queue_iowq(req);
 }
+
+int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
+			  unsigned int issue_flags, __poll_t mask)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	int ret;
+
+	if (likely(req->flags & REQ_F_APOLL_MULTISHOT))
+		return 0;
+
+	req->flags |= REQ_F_APOLL_MULTISHOT;
+	mask &= ~EPOLLONESHOT;
+
+	ret = io_arm_apoll(req, issue_flags, mask);
+	return ret == IO_APOLL_OK ? -EIOCBQUEUED : -ECANCELED;
+}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index b04686b6b5d2..40305a7de038 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -23,3 +23,6 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
+
+int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
+			  unsigned int issue_flags, __poll_t mask);
-- 
2.48.1


