Return-Path: <io-uring+bounces-11854-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AJgzFvv9b2mUUgAAu9opvQ
	(envelope-from <io-uring+bounces-11854-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 23:13:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0533A4CCFB
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 23:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1B2BC925D41
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799FC3C1FED;
	Tue, 20 Jan 2026 21:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hf+2bxIb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C26309EF2
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 21:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768943522; cv=none; b=U7BaJtkxIwMeQV0A3psAw0JG5LQ6Vi+my+3/gN2OF/0Qy+RAt+SXWi40voGjRipI6NiF1MY1ILLvzj3Mv+cRSp4vtAC2AHcGJDhS4JELsgNXf+5xj9ENVCL09A85yMe0PfptyoCnqvB5qUB+vuLRn9loFe0ChhLmqMfE5oggF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768943522; c=relaxed/simple;
	bh=p0D1gnZtZI36CjhsIyvQyfu7Wnd//lj7qh3wn7vcIAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9OSoDMBKME9rDF7tbWjs7Fm5FenhsCszmlTtIf06F/9uhB3LHM5T3dIYqWtMZ21Y8pIk/AzTJ3sLOUHlWLB7tpzoZI3camWl3geq9+UUEpqIMP29kmFmUUtsZtJwWy3d0UxXQTELOs5NSA4dDgkFWlV4rTyL634V3Q2aO8ENmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hf+2bxIb; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47ee76e8656so68381545e9.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 13:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768943518; x=1769548318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zfrYjKIlU6OXrfd9/ZWgFn0KLX3Jf/bLQZQDgqnNWS0=;
        b=Hf+2bxIbB82rtAUMkBbq5R0NDoH5VJzOfoD3N+kopHwmfyNDPel8cYGXf7WrSKreMy
         IANGYF3yjbTk9YD5SXIvDv6hCsiWkbooRJ50qMAsqtipbydfsZoe4heKLQQKEdApG88x
         1yEF5Uc3NukVKH9zqtQptcK6fYK2jWdvhvCjeR1sC1MK/bYiO6tFwNoE7iuuZBcvqf90
         PCPIFsB98JwwAZdQcAsA2hq/5l7UqWGbmEf/qCgJYCbkAs3+Wq+6hR2cXk+jYgKZ48By
         XwGppba4BfpMRicfiOSIU22f+l8gblS2re8bSukTRfgeXUB9CVHY42LPeWkJesy9FtKF
         nyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768943518; x=1769548318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zfrYjKIlU6OXrfd9/ZWgFn0KLX3Jf/bLQZQDgqnNWS0=;
        b=Lc93v0lvr6GdqOWgTeHLm4zBKJkUkmkvSDQCLaItTTX5nn7tPew92mdKwyNSvKi+ow
         QglV3zBYke29tvEtJgBh4FjuIbpFR4m+/jL5uOCTK/H+wR9pGNvIrtyp/uqktFGclGgF
         uH6JyaIlaDGB6Wuiaz96mmolQXgjmdl/2DRfgK927xGcb1o2+jO7qbgmiARCK+7LYklv
         AvQslSmqumcA9EqXAwtMsZmbr7EN329RA0hJzqlnZugvl8q9xdyDgZQcFi4X6mIDu+KK
         sH+Ey1V7QfaQywfiI6umXcw2Ud29QombT2o29ZuEInVLlCX9HGSoDXG58KKEUhOBP307
         c8Ww==
X-Gm-Message-State: AOJu0YwNUobex4iNMJW4FvucTq2YzFyB0aC+eeseKeTtHD71YuaaHiQZ
	HLBYykmQGMZRvZdY+hha6nyvcWXPfydl6WtP3k7JEy9bxJ20LUabXFRmRKx2jw==
X-Gm-Gg: AY/fxX4Rjl8s9sTHHClsf2HVHgKhe0j2KX81DdF0Bv3yt6wRWjaN1cjtetF05tcWqPK
	lV84tPEg0X9JoeRPHsxD4vL8Hjqe2FLmp4Q0q4W4tSg/9lnLnEXfoL5ZjZOAdzhhlHnSig/ov+S
	1VBmgTv2CR7I3i4jSWlzDRhDjwYdYtESTbkcVACl0IfmlMxkf7t7ZA4xOykQcsDVWifkIy7S+nc
	GwqDRYdTXzblCsA5Q/Ax+W3OcuYqpzEw4fu8KYCqEMQba9QrCaAPkZDCS2m+YjTXWE/OuwTz3Ny
	Z43IeOdT6fmak+aaFHpMD+SLfJLZ7sWnHFwfAKX09vMxbkmWqA0TqOiNE+EBvsHqktOtAQGV3rK
	4WzqHPMR2YZQ0TWE/9jyXEfoCYWmr1YU2oJsqcfVNHZHZDixKw1nXVtUZ5D6QVANkNps/uZjEIz
	p0MOTWUCUJTKjxufn2ufdJ7hj6eouwOhwUC8P1nMQdaHzcXw1Pcrv+qYX2UpV3ak1KTGCMBrDsF
	HXLZvG1aR/zVq0j
X-Received: by 2002:a05:600c:1c0f:b0:477:9986:5e6b with SMTP id 5b1f17b1804b1-480416867bemr23067935e9.28.1768943518354;
        Tue, 20 Jan 2026 13:11:58 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48042b6a3e2sm1750445e9.1.2026.01.20.13.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 13:11:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/2] selftests/io_uring: add io_uring_queue_init_params
Date: Tue, 20 Jan 2026 21:11:44 +0000
Message-ID: <91358479bd530bea5e9400d1eae12a4f3a4d5d3a.1768942757.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768942757.git.asml.silence@gmail.com>
References: <cover.1768942757.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11854-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 0533A4CCFB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a ring init variant taking struct io_uring_params, which mimicks
liburing API.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/include/io_uring/mini_liburing.h | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 9ccb16074eb5..a55407b09dbb 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -126,21 +126,18 @@ static inline int io_uring_enter(int fd, unsigned int to_submit,
 		       flags, sig, _NSIG / 8);
 }
 
-static inline int io_uring_queue_init(unsigned int entries,
-				      struct io_uring *ring,
-				      unsigned int flags)
+static inline int io_uring_queue_init_params(unsigned int entries,
+					     struct io_uring *ring,
+					     struct io_uring_params *p)
 {
-	struct io_uring_params p;
 	int fd, ret;
 
 	memset(ring, 0, sizeof(*ring));
-	memset(&p, 0, sizeof(p));
-	p.flags = flags;
 
-	fd = io_uring_setup(entries, &p);
+	fd = io_uring_setup(entries, p);
 	if (fd < 0)
 		return fd;
-	ret = io_uring_mmap(fd, &p, &ring->sq, &ring->cq);
+	ret = io_uring_mmap(fd, p, &ring->sq, &ring->cq);
 	if (!ret)
 		ring->ring_fd = fd;
 	else
@@ -148,6 +145,18 @@ static inline int io_uring_queue_init(unsigned int entries,
 	return ret;
 }
 
+static inline int io_uring_queue_init(unsigned int entries,
+				      struct io_uring *ring,
+				      unsigned int flags)
+{
+	struct io_uring_params p;
+
+	memset(&p, 0, sizeof(p));
+	p.flags = flags;
+
+	return io_uring_queue_init_params(entries, ring, &p);
+}
+
 /* Get a sqe */
 static inline struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
 {
-- 
2.52.0


