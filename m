Return-Path: <io-uring+bounces-11875-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OGZeNSVhcWkHGgAAu9opvQ
	(envelope-from <io-uring+bounces-11875-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 00:28:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C5B5F822
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 00:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0ED5384BF2C
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AAD33344D;
	Wed, 21 Jan 2026 23:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KheLkmx0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AB2D4B77
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 23:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769037954; cv=none; b=gmZJotsLQS81+I3y+4wMPH4irVGuguB77/2MuJdmxlKpMbW7pHBv1RER1j5FkMgM7/cs2GQa5ddU3/lVzTWcpfRhO++/+G2pNmq43QepXnFO2OJARCaQaNYbyaDEgqv25j8zpYQLeybWsuPb8pqky29k8NX7wWbwIXQNHg9nd4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769037954; c=relaxed/simple;
	bh=3lXUHqwKF9fLZ1FcgNksjFce7N9DrZP9zqRx1EJXoks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2nca91bICP5XnLMlcr0VuSTM716WKDHAa9ZghWj/NgJrc700OXYQ9ZPtXMVXirZytJqqRCH4BJz2b/WjKy0BH4/i+ppSGkHTY2TOmjTQPX9Qy9uXPtEsJqN1f2MtmksvUnVG5C0Ugt2XgTvhMzgIuxhTVRFTgafXfLP7PFUfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KheLkmx0; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-40866616d47so293542fac.2
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 15:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769037950; x=1769642750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FO/pZlZgbf4thFJL0FS4bzzKHd2UJKdJziP+DXk86PY=;
        b=KheLkmx0pDk7Bt+0M718D2UhkZpo0xpBb1HmZde79wyrvL8gSmA9p+AArgrpIKJmNz
         EdIwKYoStxn6bzCoyQdQorGdgzp2A8EQa0R8rITvW1kqSZ20bqExKfUe4zz8F0JGTEur
         vl39glelL0RrW0A27E0PJs5RcgpJxnjSKHwG/dhj2iuDj6o9d6Nm6NQob1RCTdTj4ys4
         9ybaj948wgMLhDDQ9+6kt7MP15JiKp/CH/66BNYfLH6tyCkzzPGidAqN2pRBDtMnwvVm
         NmuUjZNJh1veMUa6cpHSkMyK8JOkY63OIl5BTwDy8FzJZFmoSVSmiVXrIBLyEsO9+RtJ
         E2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769037950; x=1769642750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FO/pZlZgbf4thFJL0FS4bzzKHd2UJKdJziP+DXk86PY=;
        b=arPx+qvg1WUUKUaTLa5VMzD/eIxsI2n94GFy56sjTTbGi3Sq35hKcn+fmxGe6axYyt
         nW6uDX09apzzF23anvKGIyDQ6WxgwT9+Xusa8lqg82Oq7ZvZeohZ0/itWlNgPiuotGms
         qzBTWvWtOJ2Xk7PVDROG1vGaTDZ6cWIqLwTUc/KFPOy65oTBtckbyAbFz2xBw57eOGHL
         OKXsqZve6h1/DFJP9x2bVlOJPkuPgevJIBhfrX8hd9DyxQkxJeLY2/rn9iF4ilhXqoEJ
         wAlCtyeuoQgYZ9HrdGQmZ9wUZhxklxLJl5SAPzg/qUIizBhN6t5rzKUi7b3WANighdHA
         NRlQ==
X-Gm-Message-State: AOJu0Yzb2/NCYCjAM5A1n/VRy5Tx599luJRQ9IP72EcGSWQ6i5GNnk4n
	AKjlE9H9lhyr7/c+DM1D3mf/AUn0ExBXxdHYXMvbVItFmSx9PtDXYyIhZMDXoL6GmEGsdkq4RSY
	Jya7q
X-Gm-Gg: AZuq6aJbeY1NsZ62bCLU9sO/y4JAU0EWDMlBqfkzvQPLaiJ7kXKXgGEsKoGO50/6ZuN
	rLBVcvxOoHla8hcmPfmA8jzwhPpXz6H8+eFNPVuu+KFd94ovWO/7uKbs28i6vT7c7JzVMiVOKwm
	h3ghgIeq5rrYDfYLyXnioHQ3bqqX4bD68CWrFOHzZ6D8u/WGs8WFml9W0eaChH4Twq1qJrX59Gx
	UrfAxhsAUhCL+mHQdvjdWecp4OR/HYpBqhu7Rq0FCjt6wR67kkVKyKWGhCHMRxv9q/ARP3DP7nF
	Hg3Ke29C6nmGIvrti3srr7j8qKZAFN5HACZDu47AauJgX584Icuhh7La7sFA6iN9nbHayK1SnRR
	SW7kRRtbGs5ZwGeTQxL2Pxb21RbJ5p4DdQYEv0VMCRhvwU/cp7LoNHSsN6gNKX0PVhX98C6PDJn
	Sa1nTLaGqdkOnH2m9MRJsWLKdOyIXMI9bO5XdXwQc+8M9JonX1hkyk9Eyj
X-Received: by 2002:a05:6870:eca4:b0:3e0:788f:261e with SMTP id 586e51a60fabf-40846ab0ccbmr3466076fac.18.1769037950481;
        Wed, 21 Jan 2026 15:25:50 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bb55928sm12074632fac.7.2026.01.21.15.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 15:25:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: add IO_URING_EXIT_WAIT_MAX definition
Date: Wed, 21 Jan 2026 16:22:16 -0700
Message-ID: <20260121232546.260055-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260121232546.260055-1-axboe@kernel.dk>
References: <20260121232546.260055-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11875-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 36C5B5F822
X-Rspamd-Action: no action

Add the timeout we normally wait before complaining about things being
stuck waiting for cancelations to complete as a define, and use it in
io_ring_exit_work().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b7a077c11c21..8f01e8503a64 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2984,7 +2984,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 static __cold void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
-	unsigned long timeout = jiffies + HZ * 60 * 5;
+	unsigned long timeout = jiffies + IO_URING_EXIT_WAIT_MAX;
 	unsigned long interval = HZ / 20;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a790c16854d3..db5350d3ca3f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -89,6 +89,12 @@ struct io_ctx_config {
 			IOSQE_BUFFER_SELECT |\
 			IOSQE_CQE_SKIP_SUCCESS)
 
+/*
+ * Complaint timeout for io_uring cancelation exits, and for io-wq exit
+ * worker waiting.
+ */
+#define IO_URING_EXIT_WAIT_MAX	(HZ * 60 * 5)
+
 enum {
 	IOU_COMPLETE		= 0,
 
-- 
2.51.0


