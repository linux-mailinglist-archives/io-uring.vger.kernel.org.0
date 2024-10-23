Return-Path: <io-uring+bounces-3954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 861C19ACFE7
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A70D81C2137C
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C521CB529;
	Wed, 23 Oct 2024 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="boF2UW0H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F901CACF2
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700134; cv=none; b=Wbgv5JRtr3v0DqnW7kZ3chbsmSHsqe3RHdNZW7KVtSlAEyUtjh0nxYFNhSxifq2LKzPOKN0e3XVpg6nAdnrvXYIzXLujLcGIXF7w+cO5o7oWS9gsnkjLXVKL5RmU4BA8RWVZiCj+0qllp9G01JRFdhDii2VXR94OkN6q4h+sVBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700134; c=relaxed/simple;
	bh=YuhWb2M5dzo6ojcH45qDoA0CSpsw64SGLAi2xdBIlAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daynYhIjjl2+QEhN9PInNzO6y/x4txfMU0Lb5YNMufmuMpEKWc0n3HPXQi2mkSa+s/xbgaMSfPAvQvASNybcAG0Pw2asYrK+v6XQO2i3faO/OXf8mgZuL2uqMea2cVjbxiNC5uZAVXiYF9HEwc//c5hGmOU+L/2hjbQGI4CZsFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=boF2UW0H; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83ac4dacaf9so167547739f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700131; x=1730304931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJyur77YgFvOdwKbBr8lEG6FQOpaV6oMhyKIQWH8OSY=;
        b=boF2UW0Hz4CeaoHxqJm8OMAA9hdtlwp9FbjAPvURYqXUFcUe6i7y8Fr1qgATCNrFW1
         dUwGiwqk2xXQGAajE2fNG7X9D6Eus0GocGYfg3I6Jt37BlfBrBRb33QARXlcvIK4DcML
         1eRwtkyqoTXypM7PaqAXp6BuqkZxD8mCpM8YjB8rdagkhaYjBYlTh3DOsiT4PGqtL3K2
         Nlnbaczt82SXbdDDQ9u/IRgkToQ8thLqsxK71DSLwQgm/Zqj2iPVb5G/yFhF8LLzfxw2
         vEbS/7HvsW6daX+5WoWE4rThE1ImeIc71N9h2fWLAlVuYNjLcs2ISw4CSTunUoe1uVVk
         X7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700131; x=1730304931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wJyur77YgFvOdwKbBr8lEG6FQOpaV6oMhyKIQWH8OSY=;
        b=jD2cchHuGTWasgHN+ipXfdYwcWyHhFSF0YVTV2f73nuJbQ+Lf6WtX8xa7/Ecy6zCYk
         Aktrt7FBlNDOwHbOLOcQa/NE+xyF1LojRlx/zf631jXg3fVvk0+GiO52krB2YNlNVgsw
         EtWwKv9hVqaez/V/UjaNJfJBLnnmip7mVpfHar033cD0hb66MpO1QvitEYhBD9vaJKZk
         3kMOBUk1GflnOFpjU1EqgtHpkAzFKK0yy+QVgeLpI2sTybwcv/NcSTuR76oPGs8xPiXC
         mOQZrWGeTpKZ+WkaUXx8DWDlEkKfjilIpw3telFTqG1um0stUj22axrtf+Fru+EtnOvt
         wMkQ==
X-Gm-Message-State: AOJu0YyU/mbPmxzeUhEwGowEsI4dD5gYvzvFVoxim+zsqhsFBdzSED8e
	eT1d2Zf69PRUjf+QPdaST5iSS2cwxWOB/kZKcIL7iau2rh2kyo04xq0H0jTTEWngTGceUDWQVyE
	p
X-Google-Smtp-Source: AGHT+IHGdfQAIlpQAR42Ix7MxvZ9+JMaMIhDkpSCtqwmWZCH7Mija65LKy7SStmsTNerUaZJUjajnA==
X-Received: by 2002:a05:6602:6b0f:b0:82a:4480:badc with SMTP id ca18e2360f4ac-83af63fea2fmr346953339f.10.1729700129456;
        Wed, 23 Oct 2024 09:15:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring/net: move send zc fixed buffer import into helper
Date: Wed, 23 Oct 2024 10:07:37 -0600
Message-ID: <20241023161522.1126423-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
References: <20241023161522.1126423-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to making the fixed buffer importing a bit more elaborate
in terms of what it supports.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 77 ++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 13b807c729f9..dbef14aa50f9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -81,6 +81,9 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+static int io_sg_from_iter(struct sk_buff *skb, struct iov_iter *from,
+			   size_t length);
+
 /*
  * Number of times we'll try and do receives if there's more data. If we
  * exceed this limit, then add us to the back of the queue and retry from
@@ -578,6 +581,37 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static int io_send_zc_import_single(struct io_kiocb *req,
+				    unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
+	int ret;
+	u16 idx;
+
+	ret = -EFAULT;
+	io_ring_submit_lock(ctx, issue_flags);
+	if (sr->buf_index < ctx->nr_user_bufs) {
+		idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
+		imu = READ_ONCE(ctx->user_bufs[idx]);
+		io_req_set_rsrc_node(sr->notif, ctx);
+		ret = 0;
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	if (unlikely(ret))
+		return ret;
+
+	ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
+				(u64)(uintptr_t)sr->buf, sr->len);
+	if (unlikely(ret))
+		return ret;
+	kmsg->msg.sg_from_iter = io_sg_from_iter;
+	return 0;
+}
+
 static int __io_send_import(struct io_kiocb *req, struct buf_sel_arg *arg,
 			    int nsegs, unsigned int issue_flags)
 {
@@ -1365,40 +1399,17 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_async_msghdr *kmsg = req->async_data;
 	int ret;
 
-	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_mapped_ubuf *imu;
-		int idx;
-
-		ret = -EFAULT;
-		io_ring_submit_lock(ctx, issue_flags);
-		if (sr->buf_index < ctx->nr_user_bufs) {
-			idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
-			imu = READ_ONCE(ctx->user_bufs[idx]);
-			io_req_set_rsrc_node(sr->notif, ctx);
-			ret = 0;
-		}
-		io_ring_submit_unlock(ctx, issue_flags);
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF)
+		return io_send_zc_import_single(req, issue_flags);
 
-		if (unlikely(ret))
-			return ret;
-
-		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
-					(u64)(uintptr_t)sr->buf, sr->len);
-		if (unlikely(ret))
-			return ret;
-		kmsg->msg.sg_from_iter = io_sg_from_iter;
-	} else {
-		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
-		if (unlikely(ret))
-			return ret;
-		ret = io_notif_account_mem(sr->notif, sr->len);
-		if (unlikely(ret))
-			return ret;
-		kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
-	}
-
-	return ret;
+	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+	ret = io_notif_account_mem(sr->notif, sr->len);
+	if (unlikely(ret))
+		return ret;
+	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
+	return 0;
 }
 
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.45.2


