Return-Path: <io-uring+bounces-10390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DF5C379F0
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 21:05:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4268E1883878
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 20:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1147A267714;
	Wed,  5 Nov 2025 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pTJ94I15"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F682D73A7
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 20:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762373005; cv=none; b=icNhE7pWHCl6OcBDWoorbXTxlJmJ8dRqP/cibySwo7XMQn8TdkZx1Hp7nV0XwTyiiRUwgHtr7Fx43D7pnkElH1+KFrKdUyuJmYna9StJaL7TilcsuyKZUtA0OBqAh1bPn90dz9T0UhxmjDTDgj3GJFaQtf4jZEiWvWKL7RpVA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762373005; c=relaxed/simple;
	bh=vX2Bm2xPWaiosl5qxmftHhu+8hLFZKbWZG0x1Beq8eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSEoSRtUWnl4D2YQqjTpnzaSymU/QiLJS0jYOjMiL6xJB1BCiE7a0vLPObRYBFFP5zh1uLuyLA+DOjHsA4yyIZIzbDoUOQdywecCNWfcOMdxsKbFS9YelprE1kYhlxy4IXSkDDvUokeJVhoZD6rHWWXqmo4D82c3RYEWFggWJlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pTJ94I15; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-4331b4d5c6eso688205ab.2
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762373002; x=1762977802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qW6E+DGy/J4pCHmuZueCBefec+tLXdhkndNW4zQuEfg=;
        b=pTJ94I15XplvYWloUbko7PWXdHmYQSoCm4A9xD8JRjwuPKWVMnu+RHMGoUhxTbXQkx
         1PdmcCJrZh8/T8xavKuAFpkG3QJVdgGy7hSepKavuYipjZt5P9HdJSVlMA+BTC/sVL7B
         v1/VpXPTkEeKyprIRBhH7W41j8ftP/jXt8M2HcAHD+Kt9hF1n8najOkdQUm5A4WVcUGG
         48ZXGovmQbxxCwflQf0bufXc7HfWPZbb49hSm2mOArcHVZfrfLxedTrbgqkcgVZt62gQ
         8j8JFobVP75u/YFQRi9Cf9MB5ydL7XZFT8embieQBjcylEw/UcWzf51Bq5/DokAoxu4c
         +nGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762373002; x=1762977802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qW6E+DGy/J4pCHmuZueCBefec+tLXdhkndNW4zQuEfg=;
        b=irZrER3fiLve+id/yRl/qX+urNypf9sMullg7Rfr7BcFLVropJrARfPxj9OqUcuD9B
         cPatRi7jRltJZjc1j7eY4r3Ho6X1kTTHawvX5QY2p4q9JSfgLmlJEfcvu9Ie2AfqNkiH
         Pvi4yRGAeQbLbgWJqMBusIu+0j0m4rLZpUnNL4Len1aTg+nlVy8yktRfYYVDClNVJCeE
         SMSPJ3y3S7/Hxh3akqiE/uQkrgLFSW2UP7Gs02ho83JNhEr0z8nQTyatsBmcyqlhzQHB
         BxvrT0CRU9M9dU5nGJUhtUNCjsLEPBK6mAVVXZmQVA1Y0QhtSVEWrKlVBwU5fpfZnqVf
         qWZw==
X-Gm-Message-State: AOJu0Yxy384z7Fv7BpdOcLKD3q7H3KeqHNm9aELLTA/lvLLkY53TEJVC
	CUXS2Mq/poqL51zHC1mb2d0gkNKuzBLKLPj5KjEMPRW53usY6ZwPchh1C6zTQVObuM5xORRTaFw
	hRLVk
X-Gm-Gg: ASbGncs6KHuqKLYtKMdQtGfPOc0RpY4dmXrGwkzFNxt+6/JzJFextPCD9HueXYzz6mQ
	JvyxqCIi5/Nus9fVSRzuozY3b6ayDD8iDpVZP4JYSfyUV/P+H5lrSAaEF5D6aEEIF7tJ6Y9ds9Y
	3lCRPtg2R3NwpKqDafTTRD+utlzKyLyWQyWEn+qyETpF+v5GquKygxv6H7r8O1z/Rye6gAX76bO
	H86HXdSCQh/SIvjmxlGCPzfY04aGrPXzd6YQumSPoDuNwlqPx9NUMRKtTyMET33ssaURbicZbWh
	pKENKQGIL7ttunzODqfpIWACSHpcUaA/l0KDU+7HLwL9oLPoByhoyvFNIEGDM0K6GkFpn1yeTSB
	qJ4qR8ekn4cvrXRzEO/dhRsiuDISaryutDLozg5JJ85G11Pd/9/s=
X-Google-Smtp-Source: AGHT+IGud46Nv9vMx7FuCE7fmXxdTzrkQKYvrRoE9Ury06x6zOG+8++JXeLiii3cR93wvf6mwsmO9Q==
X-Received: by 2002:a05:6e02:1aab:b0:433:206d:5333 with SMTP id e9e14a558f8ab-43340800e28mr66473365ab.30.1762373002030;
        Wed, 05 Nov 2025 12:03:22 -0800 (PST)
Received: from m2max.wifi.delta.com ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7469631cesm49632173.54.2025.11.05.12.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 12:03:21 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/futex: move futexv owned status to struct io_futexv_data
Date: Wed,  5 Nov 2025 13:00:58 -0700
Message-ID: <20251105200226.261703-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105200226.261703-1-axboe@kernel.dk>
References: <20251105200226.261703-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Free up a bit of space in the shared futex opcode private data, by
moving the futexv specific futexv_owned out of there and into the struct
specific to vectored futexes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index bb3ae3e9c956..11bfff5a80df 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -17,7 +17,6 @@ struct io_futex {
 	void __user	*uaddr;
 	unsigned long	futex_val;
 	unsigned long	futex_mask;
-	unsigned long	futexv_owned;
 	u32		futex_flags;
 	unsigned int	futex_nr;
 	bool		futexv_unqueued;
@@ -29,6 +28,7 @@ struct io_futex_data {
 };
 
 struct io_futexv_data {
+	unsigned long		owned;
 	struct futex_vector	futexv[];
 };
 
@@ -82,10 +82,9 @@ static void io_futexv_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 	__io_futex_complete(tw_req, tw);
 }
 
-static bool io_futexv_claim(struct io_futex *iof)
+static bool io_futexv_claim(struct io_futexv_data *ifd)
 {
-	if (test_bit(0, &iof->futexv_owned) ||
-	    test_and_set_bit_lock(0, &iof->futexv_owned))
+	if (test_bit(0, &ifd->owned) || test_and_set_bit_lock(0, &ifd->owned))
 		return false;
 	return true;
 }
@@ -100,9 +99,9 @@ static bool __io_futex_cancel(struct io_kiocb *req)
 			return false;
 		req->io_task_work.func = io_futex_complete;
 	} else {
-		struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+		struct io_futexv_data *ifd = req->async_data;
 
-		if (!io_futexv_claim(iof))
+		if (!io_futexv_claim(ifd))
 			return false;
 		req->io_task_work.func = io_futexv_complete;
 	}
@@ -158,9 +157,9 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
 {
 	struct io_kiocb *req = q->wake_data;
-	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct io_futexv_data *ifd = req->async_data;
 
-	if (!io_futexv_claim(iof))
+	if (!io_futexv_claim(ifd))
 		return;
 	if (unlikely(!__futex_wake_mark(q)))
 		return;
@@ -200,7 +199,6 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	/* Mark as inflight, so file exit cancelation will find it */
 	io_req_track_inflight(req);
-	iof->futexv_owned = 0;
 	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = ifd;
-- 
2.51.0


