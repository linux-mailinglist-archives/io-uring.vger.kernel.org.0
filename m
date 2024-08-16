Return-Path: <io-uring+bounces-2791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA940955074
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 644841F21948
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCE81AC8BE;
	Fri, 16 Aug 2024 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GBRyhW7Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC22817
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831311; cv=none; b=a0tqzQbCkOe4wAKzEmFm2evyFa+/U0AygJ8iJTDGomKS4g90OcWqeFaSQ1GsbXgeF/i3D4+ZhP6I4Jsn23DehBBA7lhxoEMLdMIvf1BEoxH4lCLPtuPsUKwAhD+iP+EsODkfrD6T3os3pgT+vGnhKrm0XGHdWNFfZBgVpNGO49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831311; c=relaxed/simple;
	bh=yFKGedKuPBa3S0+7uB7UWdAyJrfTNFU8KGIzmwuXnbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9wTf4NZfLSH3As/TzDiS1yOF0yBo3JMwzUkeTGb/Kg9ar+8+V67OksTuIFPtQE0XCzxngwOhxIWzNRsmuad9O25Rjz3Pb5RYSb3b9rDkhIBtbZmHayKusnuLNuQZ+IR0uS6lCTlYc9qceBMFiVyMWcoeIDARLsE6T/ASydmdVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GBRyhW7Y; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc587361b6so22755865ad.2
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723831310; x=1724436110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ODSNCq3XO6ZTig/ZFVCsOJdFuiYzJaGhHl4OgxeGI0=;
        b=GBRyhW7Y+S/chTxcdDZHw0MqVU53e6NjfqKDyvldxdGhxBn7WHoEGMyxEQR48DPmTj
         IJEgKrT3cIiH7XN2uKd1xmhSfi69bnR32hHtgrsiDGPnMRrzuYWZOQGsFrcMnfKxnlGV
         qdPKLLRk6keKJZFIuXmX5qEHxUSJknbU8Uw4Ij8rMDnYiNVO1z6Jl+/r2ytFtj1ynKVR
         ByCiYl+952xvvSnuBKIhYjo5BQRJJjKg7xgxhJrUeoeXR7yTLm32NOAgoY8cwA3fyYth
         q894cz5KytmxkVg3YKqud94+nSRff1a++viOKzeqaG1L4XtiBqbeVeJtQqvXUEFZmak+
         xxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831310; x=1724436110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ODSNCq3XO6ZTig/ZFVCsOJdFuiYzJaGhHl4OgxeGI0=;
        b=IipEcH7+ZB71HZNqfvzM78DojQN09gGgrKINnrtHG+E1+HUwX10QZ+iOfFDX+WYUeZ
         6yuVhOfOuBD0aQJQv6bKUcII5BqDN2irO7MgJ1EsRKuGzqvBLSPSGy8MIJmn6ch08JRS
         s9x20ofEUkbPnSokFkseCloeSkrbF8yE2alo2iow0en1ZufQtRsUCOPZVYLdiviJqo0x
         tL1fbqowvVMv4mz2NzD85DUS3ISCLPCU7fS77XyCrPTfcAElDBWsRJP8SpKZTOLDkMXR
         uTM8w0vNMmGrO4Yw3xb/02kILcjy8S6wNY3IB4B7HwSYZj0I6bgTfqRPfac6gDMuYVFv
         2BUg==
X-Gm-Message-State: AOJu0Yx6hp9f7yduW/g+xwPjUuWOwLEjvekYSyIhfruJbJqwRK7pVORh
	YwcKv997/P3Z29RTQdMRSpCC1Flncrnn6+Msf2QUcV6W0YxQtVWAToIkyfTBedRunfQ7H0po8Yg
	W
X-Google-Smtp-Source: AGHT+IEP0HQo6RYpMQ6Wm2uO3cHAroAu069Rt2Uf+SthnJsbp9NvmCbiY1NTzPikoIop2N/4nMKrrg==
X-Received: by 2002:a17:902:e74d:b0:1fd:78dd:8578 with SMTP id d9443c01a7336-20203f4fdb5mr48748585ad.55.1723831309511;
        Fri, 16 Aug 2024 11:01:49 -0700 (PDT)
Received: from localhost (fwdproxy-prn-020.fbsv.net. [2a03:2880:ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f037589bsm28245345ad.166.2024.08.16.11.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 11:01:49 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 2/3] io_uring: do not set no_iowait if IORING_ENTER_NO_WAIT
Date: Fri, 16 Aug 2024 11:01:44 -0700
Message-ID: <20240816180145.14561-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240816180145.14561-1-dw@davidwei.uk>
References: <20240816180145.14561-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for IORING_ENTER_NO_WAIT and do not set current->in_iowait if it
is set. To maintain existing behaviour, by default this flag is not set.

This is to prevent waiting for completions being accounted as iowait
time. Some userspace tools consider iowait time to be 'utilisation' time
which is misleading since the task is not scheduled and the CPU is free
to run other tasks.

High iowait time might be indicative of issues for block IO, but not for
network IO i.e. recv() where we do not control when IO happens.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/io_uring.c | 4 +++-
 io_uring/io_uring.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4cc905b228a5..9438875e43ea 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2372,7 +2372,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	if (current_pending_io())
+	if (!iowq->no_iowait && current_pending_io())
 		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
@@ -2414,6 +2414,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.timeout = KTIME_MAX;
+	if (flags & IORING_ENTER_NO_IOWAIT)
+		iowq.no_iowait = true;
 
 	if (uts) {
 		struct timespec64 ts;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9935819f12b7..e35fecca4445 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -41,6 +41,7 @@ struct io_wait_queue {
 	unsigned cq_tail;
 	unsigned nr_timeouts;
 	ktime_t timeout;
+	bool no_iowait;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	ktime_t napi_busy_poll_dt;
-- 
2.43.5


