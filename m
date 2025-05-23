Return-Path: <io-uring+bounces-8096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1366BAC2280
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 14:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25119E544E
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 12:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC8123535B;
	Fri, 23 May 2025 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="J4fNICEn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B432F3E
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 12:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002678; cv=none; b=AhRCdlC/ajkm1cTQiAPuZm8WJNFSMrJedW/N/ZjnNt/qhtOgbdbycdzar9Q+n5g6wkMoMHJdrpz92YEfLWhS9fkCBGuidB9VZ8SqcHgD+3M9cCds379pIy0QhNIy/wRyPSUxe43JqMPAUd513+6sOpFHXwTpqLmTCqYIdR7KIG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002678; c=relaxed/simple;
	bh=LrdHIljZMFq1x5wUx1yLFa/TWthwM+q11xCHvKSoBCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH0Y5X5s2CuUYuL8vaOSV7iYLnLEPgckI1xeixDbZ2ED9loNwcOkuWX2KU2OmXQTyNQIcfYcx3dZtL/d7v3bvFR8K032Y3JIPw7hC03rNycge7bWP1wZCbRYk9eFH4WP0Gd000wbAt2/vtftXFrOlZ8a6McT9r7V7Wci64TSwvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=J4fNICEn; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-864a22fcdf2so30402039f.0
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 05:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748002674; x=1748607474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CordaKYb4K6NDiwr3klSNzqa4GeYHeyDgehf281Crw=;
        b=J4fNICEnztlm4qKOd+KCJYBwKc6N9MwedUVNIb4lda7kIT59A3TyU+0lhVRLhmmC9P
         Cnv19Ddw2j5fi2Fm7LDThSEpuRVflIoX2gqqfhWZpJ+DqWMoIkx5UlLsxhc9Ijq9Yc7i
         3SqetYTSHQTYBJYwbFmjg2PpWVrv7gxuThSQyLH+a7WXOiQGNnwpEqFID7YbAQD3MHto
         sPyR0B/xOFo4XV0rk7JHa+0fq8bxqsuHN5SHN+a4lcJEdsb44LlX+o8e5fMAoUiUlaNc
         mSO4+dtEqsi6TiPoJxWnRv2V1AXgU0jPwbQ5703vR971+V7CP640YBNhpjfxJT8YOCRw
         Bnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748002674; x=1748607474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+CordaKYb4K6NDiwr3klSNzqa4GeYHeyDgehf281Crw=;
        b=Wxo3Rn7Rpq/rNY4DPuSSM0vAdcCEpPYs3yMXsZ68IGWxQrNI2WDF+2wNjKADJFFt8A
         ayGf+ZfOCWVgrZBB0VieLLjTAN+ixHk7lrparrrh3VBJsKoZUdxwQVVRlyVOxK1l/fan
         JExw+yiGnOZCY9qhlcg7jAxik3T9vSDHw8cI7lAOZZnkRUmYPX1iAk2heh4AD6Wrg+m0
         468nh5dSeszSWusjfSTXYiArNniC+qfbwzjmLPwbv8VV3+cophs1OWnW0HXrX3Y/ISRv
         BDVL0vpTg8p0grW5H9y/SONLeThVMv18+J9m0lWFwY8MiLCjStpSsnozpaheer3mChz1
         uucA==
X-Gm-Message-State: AOJu0YwiH+u07KVMZwYmih1JEucXbwNhZc25gh84g5enDgKTOT7xsiiS
	XJa6PaO7zGCwzUZt4li6buwVWFtzodoocaTIw/mfIzdQbzJBl5F3WiEg71IX6U4AtmuHAqAQ0nt
	+oSlz
X-Gm-Gg: ASbGncuij2RFbNWz3BE385puPPt1SauXCdBtZPdh8/pfmSzTTAUVBjgH8+jOuEkpQTI
	B1aFvjK2PJMG2zLjkIFKLkZ6oAuNLtX7tVDWlodh+NtyuTZIp4QmLsa7fUeNQwvUTmIr+6RcYL1
	7unQRiJLIILQVFQBbsUay+4FfryCxSCqMiDttISlMRbSMkLCOePMFctdoKJt1aAnoJublrqDujN
	tAfOrHqfezmFed+iqo1BZXJoY5bzaBiXMGj1z8BS60sPchlAGFFIKu5dYkoYXIT05uJSTVKt3xf
	wUHpoUFfvRqQIm6BQrUSf7lkN4ct5aO937OSws7BYZY5CUVfesXAsElA
X-Google-Smtp-Source: AGHT+IG8hyZFUKjDl1f5SJEd7wCOMn9IbqSs50H7G/pr/PMO4wQrGbqKTv8ud9EkU4VzYDH0tAQ1fA==
X-Received: by 2002:a5d:898d:0:b0:85e:16e9:5e8d with SMTP id ca18e2360f4ac-86cade094f2mr264631939f.7.1748002673703;
        Fri, 23 May 2025 05:17:53 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3ddeafsm3617552173.71.2025.05.23.05.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 05:17:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	lidiangang@bytedance.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/io-wq: move hash helpers to the top
Date: Fri, 23 May 2025 06:15:13 -0600
Message-ID: <20250523121749.1252334-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523121749.1252334-1-axboe@kernel.dk>
References: <20250523121749.1252334-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just in preparation for using them higher up in the function, move
these generic helpers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d52069b1177b..d36d0bd9847d 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -150,6 +150,16 @@ static bool io_acct_cancel_pending_work(struct io_wq *wq,
 static void create_worker_cb(struct callback_head *cb);
 static void io_wq_cancel_tw_create(struct io_wq *wq);
 
+static inline unsigned int __io_get_work_hash(unsigned int work_flags)
+{
+	return work_flags >> IO_WQ_HASH_SHIFT;
+}
+
+static inline unsigned int io_get_work_hash(struct io_wq_work *work)
+{
+	return __io_get_work_hash(atomic_read(&work->flags));
+}
+
 static bool io_worker_get(struct io_worker *worker)
 {
 	return refcount_inc_not_zero(&worker->ref);
@@ -454,16 +464,6 @@ static void __io_worker_idle(struct io_wq_acct *acct, struct io_worker *worker)
 	}
 }
 
-static inline unsigned int __io_get_work_hash(unsigned int work_flags)
-{
-	return work_flags >> IO_WQ_HASH_SHIFT;
-}
-
-static inline unsigned int io_get_work_hash(struct io_wq_work *work)
-{
-	return __io_get_work_hash(atomic_read(&work->flags));
-}
-
 static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
 {
 	bool ret = false;
-- 
2.49.0


