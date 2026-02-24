Return-Path: <io-uring+bounces-12399-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKMaFPDNnWn4SAQAu9opvQ
	(envelope-from <io-uring+bounces-12399-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:12:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A94FF1899DD
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 456973019E19
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 16:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A963A7846;
	Tue, 24 Feb 2026 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/tRMtHI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08B23A7839
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949543; cv=none; b=nTEDEGEvW/acBjy6LYld3HWOs1ZbVpFW5IqAY3zhKGyRsF0nlvmk2YmkyiO/nVBSnCAs6uyJc1LCwMZ6SKCHkXuCA26a4J14i4otTcs5gleEp1rYFn/SGC38H0+wMdECkxfM5oZoDkbIg0J2pB78YeO5qtPAL2ju9oYyyou4Dwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949543; c=relaxed/simple;
	bh=MBzY4Fe5ou9LSHMKOE4et2n25mjJ7KMecydLPGYJwHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFr5ELVgjJKFn0gZ/OYHMcbox+BtRmQLm04UkC1Jyu4E0Fw+sx0TnBz+/JAqu1TeoqTYlTK94Ti+8nI3XtEhTVUoAjs6EPiO7Q1i3baCH396byNBw9HZr81WUgMxX/iCXXmeG/ih95sOzQatk2K5AIwBTCNtgQLK0CDKpqPWH7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G/tRMtHI; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4833115090dso55356785e9.3
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 08:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771949540; x=1772554340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lggmug3FgJKs5IhWreFmUFYYtc7Kp2Q1AnrZTEOLmrg=;
        b=G/tRMtHIrCv3mju692MOu+LGpNy4nKfZeoFhmkq6gKp94ODIVmiKz5rCXBcYt/ms5F
         Mte4HyIe6G7V/PP2W6GpY20TJ0ObSrJOcMcWfM0cm8YogButQHahIutQK9Y8Exgpes8D
         /JHS500S4+SRys0kNCFhtMopWAVlgU84PRmoGJ20pDgP1ZVE7yOh5jOtDEVQkytHsg9s
         tS2+7AjjN+DZfnGCWHjrvdTkHPv1qs115PaWcs3i2S/bmAHh6IBSXUca05lFWA8xUfxV
         8w+/XqeG/exK2mlGyyt3YiM2NkBmrMZ75/H0NwYp9xp0ajrp96qqQ5vygeefK2vIe7p6
         /4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771949540; x=1772554340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lggmug3FgJKs5IhWreFmUFYYtc7Kp2Q1AnrZTEOLmrg=;
        b=CleMWzTNT13LIjzQfdlVw5TcITvCQ5c6PgjMkLm3ugUPoJPCMSRYjyp0dkYIfxbdLl
         2T9OEtNg49rDU43hCqPK7UlAuw5rN0ipBBTtdQrKloGc/OOlDJbiwh53WgFqesQBAPUs
         oXPFIdyIDYPP14spQ+wY2qhBvAHOWVdlX6Z0+mZtf+w9Pt8pzcxPAw8pf29uPg2CpJIA
         hh/1NTP7c59STDpsbSjCTYvfFjLMmC0Fl6kRHjf/KBmfOAeJWYbeu5IWxyBRVHC5iUmN
         2uG2ku0nvoaAEB/AgWJ4vDa6i/IeotZvDi+9uHYhhAZpNSxL+a4DyNXtWWLWMblxCm6P
         3d5A==
X-Gm-Message-State: AOJu0YzlTt2wCrQWfw8nP6bvCQYtHFGy8BVYV4inIeskS6VLwJCGNqQa
	aXHyDpqk+n2ZHdBfxG9WjyaEGpFaIeOiTPfMntybJGEh8b6M3cWV5t2uzyF07A==
X-Gm-Gg: AZuq6aLWMeqJcf8+yr0N35Awnuq/tEEEFPRGEEkwQPROdA1XXYsN6m488+d11r26C4l
	rIm1szMQvsMEax+Ss+dPiVFlfGqDz1GywBJzPA7/PtwG5BRaYhxG6Qv/f7HGZMGNZ4jrKxvutlJ
	+c/Uxlu8pSzimyP4MRqkNYHkHkccHGMS2aC1nZbPaaQV5/00MHlBkoQhcu3BKs+rLY2iHZzdmAC
	6LHlRPxHnWdUypKU9d55S25pFhtQSIAPMt7Iel1lUFXzkD55Vk3DcXYKFRUrwAV3pkrheXaf1tI
	7XDem/nKg+25Zv8F8qqXIVF9Y43j0NfM4sW6CZpuW2as521X49NNsLrJm8wv7+H5UjlbrVGAhEl
	Fo5MxgHA4Vv8rcefD51j6n4BiogfPjiep5n/0iUye+ro0XnYtLsR3jOS3QN46ABt7Li7lzb1ndm
	IeD6GicCmux/FNxcN+z4k1kU0lK8PxY/VWWuFlxQK3Ubwwrc1lGH8AQroyx415AKsin/jvD1DNQ
	o7D0u6T0gJS+kEy83Wv2y7bnlahIw==
X-Received: by 2002:a05:600c:45cc:b0:483:4807:210c with SMTP id 5b1f17b1804b1-483a95f5611mr235449815e9.24.1771949539675;
        Tue, 24 Feb 2026 08:12:19 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43987f3ed03sm6292977f8f.16.2026.02.24.08.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:12:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 2/2] io_uring/timeout: immediate timeout arg
Date: Tue, 24 Feb 2026 16:12:11 +0000
Message-ID: <e2382dc6580567e12b892af8bc1b5a0e3fdcf3e2.1771949518.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771949518.git.asml.silence@gmail.com>
References: <cover.1771949518.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12399-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A94FF1899DD
X-Rspamd-Action: no action

One the things the user has always keep in mind is that any user
pointers they put into an SQE is not going to be read by the kernel
until submission happens, and the user has to ensure the pointee
stays alive until then. For example, this snippet:

void prep_timeout(struct io_uring_sqe *sqe) {
	struct __kernel_timespec ts = {...};
	prep_timeout(sqe, &ts);
}

void submit() {
	sqe = get_sqe();
	prep_timeout(sqe);
	io_uring_submit();
}

Would lead to UAF for the on stack variable ts. Instead of passing
the timeout value as a pointer allow to store it immediately in the SQE.
The user has to set a new flag called IORING_TIMEOUT_IMMEDIATE_ARG,
in which case sqe->addr will be interpreted as the timeout value in ns.
It only works with relative timeouts and rejected if set together with
IORING_TIMEOUT_ABS out of concerns of not having enough range in u64 to
represent a good long term API.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 +++++
 io_uring/timeout.c            | 11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6750c383a2ab..8f4de786e6e9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -340,6 +340,10 @@ enum io_uring_op {
 
 /*
  * sqe->timeout_flags
+ *
+ * IORING_TIMEOUT_IMMEDIATE_ARG:	If set, sqe->addr stores the timeout
+ *					value in nanoseconds instead of
+ *					pointing to a timespec.
  */
 #define IORING_TIMEOUT_ABS		(1U << 0)
 #define IORING_TIMEOUT_UPDATE		(1U << 1)
@@ -348,6 +352,7 @@ enum io_uring_op {
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_MULTISHOT	(1U << 6)
+#define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index d97f67d85ea3..e051c8374c1a 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -528,7 +528,8 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	flags = READ_ONCE(sqe->timeout_flags);
 	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK |
 		      IORING_TIMEOUT_ETIME_SUCCESS |
-		      IORING_TIMEOUT_MULTISHOT))
+		      IORING_TIMEOUT_MULTISHOT |
+		      IORING_TIMEOUT_IMMEDIATE_ARG))
 		return -EINVAL;
 	/* more than one clock specified is invalid, obviously */
 	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
@@ -557,8 +558,14 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
+	if (flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
+		if (flags & IORING_TIMEOUT_ABS)
+			return -EINVAL;
+		data->ts = ns_to_timespec64(READ_ONCE(sqe->addr));
+	} else if (get_timespec64(&data->ts,
+				  u64_to_user_ptr(READ_ONCE(sqe->addr)))) {
 		return -EFAULT;
+	}
 
 	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
 		return -EINVAL;
-- 
2.53.0


