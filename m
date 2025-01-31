Return-Path: <io-uring+bounces-6207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 832BAA241E6
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 18:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD18B7A2E3E
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CB71B0F21;
	Fri, 31 Jan 2025 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGB/dGJu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ED9A935
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738344661; cv=none; b=KXuh5n3ygN0nA04ucN9DGldQVErxCgnJ3Py52+hXaxxp8Cel6CQx5jsBpImB/4TpA9XoKoL4lV4JgcKhxC9hNAoAtduUtkUzLmJlzb8A8JD9CpUq/SIeTbFqU9JNfd9PzSX3+RFpKUk7fUVP1Ne109+SkUaGqsiAow0mUUb1a0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738344661; c=relaxed/simple;
	bh=NS1dguMEp7jPweWvBKQXobmZYkAN+t8IawGZX9p2+kI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pL9IIEl6Zipfo47WFEeWj+9AOSymwP96X+Qgqg5knuTvmHFC8oHVy2WhnLJk8RG1qAtdsYqvqXRb/o7RBmMVHsFpwPmowTsHgaMIGK2xXH5gLRMRzlhqGAiPjHqkZldGOTNSwQHHH6REggXHt/PSjUceSSJtk/Mm/JF48LBRh0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGB/dGJu; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso403775666b.1
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 09:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738344657; x=1738949457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BzsTozdAa0zP4VqowVp2+cY/C4HrKJ4soXn4ZnhZgc8=;
        b=TGB/dGJu/lVUpQqSx8HcI/YZLQPePiH2eovb1aJpYTYI6gt99pt301t1gHnDUALK/4
         3h9QZR7nlCMcYKLpMxPnC/cU3ztKrgkLL85btjxuc2c4Ocp2QHz7Y1Z9+R+8vcnV8M4W
         iUS1kp+WVu4do3JufUSl7U43Ve8tYTZNK4Vd8sm+Cgxw4zR9tCb9Ve03qn+LGAev6W3u
         jpt4pMWihmbJcoawT0Zf2HUy4GbXI92BsBwUmYAvoUAX72ii3/Tg0amzCQ+wN+xpHoCR
         hpAMrp/JkFc+n0SAdb9CK6Wz92lbLDccNukej8TnAHL31u78b99z7NBNwXBSv4ixTukO
         7wTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738344657; x=1738949457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BzsTozdAa0zP4VqowVp2+cY/C4HrKJ4soXn4ZnhZgc8=;
        b=P+Uv95FaFf1ferPUV7LVT0WbrrGjR7fM73Gq6UirsrKlqpFBTw81ZbDGVf7JIn8YFe
         wJq6Z8kD7/JgXvgd58BQC7nfvRpx7eH+bWSW9TZ+QtqqCaa6i75P8NeubZghMrtCE9TT
         t4t4Mi717Yv+u4F4RZtUjRX69GAulynCHvGM/ASsjgafrBmxujRwAM+JFYLOIJmqB02F
         hDIfIVwru2NafQ/vppBZnUWIk2uYSD6raV1WqwkZVZ1dHBessbGGaCAd8bZGyjSoBdjd
         CruzPnQ+0L4KDYTn3BSpC1OakQxHs2FZqsOsqaGHqgsAFmo93vzWCGQna0VRGmDXXr0V
         su7A==
X-Gm-Message-State: AOJu0Yyr1dQst+0T+E/auJg3l6HEuId1CvDXw8bf0ysH8BWzOeBYQ8Qw
	7KNyEDtWpfakOR/sTF6e7FLKfsjL0Y88ZL5/0IhmTu03HI2kMdcx7OL4Lg==
X-Gm-Gg: ASbGncsussuG34TeWwQ1KZqAIXXpWlEYSuW2sFm6f+8Z4C24fe7rA3m2LNONHQT7XPf
	5i79qqxC4rvQg98ztKDpU+kmw7YCGo9NR67V1UcEQQzTRRPyO/RpQq8TZDR8T1L5JFVg4OEoqyF
	lB1eICFIgrgAx219+FsAHh+zqQplbBje05DWrVRb53dV+anP7qUlvSiKwb0uMW9EiD8RJt+xWKr
	bDpS31a0mFOv1L3ZAyY9Dl/duVy/kfXLsmtvAeNKlo1NegUwtpAjCYSoGQwpsyT9cEiwi6FaQE=
X-Google-Smtp-Source: AGHT+IG+tYxp2/R0jyj+cu8Jj9wiyYTilZEZ6CrIrxFMIBRvsNy8CiuKeDiYh/FO/9YmfyMfLibQwg==
X-Received: by 2002:a17:907:94c9:b0:a9e:d4a9:2c28 with SMTP id a640c23a62f3a-ab6cfe12fe6mr1272232466b.53.1738344657184;
        Fri, 31 Jan 2025 09:30:57 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab70861b56asm55862766b.153.2025.01.31.09.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 09:30:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: sanitise ring params earlier
Date: Fri, 31 Jan 2025 17:31:03 +0000
Message-ID: <363ba90b83ff78eefdc88b60e1b2c4a39d182247.1738344646.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do all struct io_uring_params validation early on before allocating the
context. That makes initialisation easier, especially by having fewer
places where we need to care about partial de-initialisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 77 ++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fad178325cb2b..1824f5da168fd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3535,6 +3535,44 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
+static int io_uring_sanitise_params(struct io_uring_params *p)
+{
+	unsigned flags = p->flags;
+
+	/* There is no way to mmap rings without a real fd */
+	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
+	    !(flags & IORING_SETUP_NO_MMAP))
+		return -EINVAL;
+
+	if (flags & IORING_SETUP_SQPOLL) {
+		/* IPI related flags don't make sense with SQPOLL */
+		if (flags & (IORING_SETUP_COOP_TASKRUN |
+			     IORING_SETUP_TASKRUN_FLAG |
+			     IORING_SETUP_DEFER_TASKRUN))
+			return -EINVAL;
+	}
+
+	if (flags & IORING_SETUP_TASKRUN_FLAG) {
+		if (!(flags & (IORING_SETUP_COOP_TASKRUN |
+			       IORING_SETUP_DEFER_TASKRUN)))
+			return -EINVAL;
+	}
+
+	/* HYBRID_IOPOLL only valid with IOPOLL */
+	if ((flags & IORING_SETUP_HYBRID_IOPOLL) && !(flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	/*
+	 * For DEFER_TASKRUN we require the completion task to be the same as
+	 * the submission task. This implies that there is only one submitter.
+	 */
+	if ((flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    !(flags & IORING_SETUP_SINGLE_ISSUER))
+		return -EINVAL;
+
+	return 0;
+}
+
 int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
 	if (!entries)
@@ -3545,10 +3583,6 @@ int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 		entries = IORING_MAX_ENTRIES;
 	}
 
-	if ((p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
-	    && !(p->flags & IORING_SETUP_NO_MMAP))
-		return -EINVAL;
-
 	/*
 	 * Use twice as many entries for the CQ ring. It's possible for the
 	 * application to drive a higher depth than the size of the SQ ring,
@@ -3610,6 +3644,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	struct file *file;
 	int ret;
 
+	ret = io_uring_sanitise_params(p);
+	if (ret)
+		return ret;
+
 	ret = io_uring_fill_params(entries, p);
 	if (unlikely(ret))
 		return ret;
@@ -3657,37 +3695,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
 	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	ret = -EINVAL;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		/* IPI related flags don't make sense with SQPOLL */
-		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
-				  IORING_SETUP_TASKRUN_FLAG |
-				  IORING_SETUP_DEFER_TASKRUN))
-			goto err;
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_COOP_TASKRUN))
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
-		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	} else {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
-		    !(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
-			goto err;
+	else
 		ctx->notify_method = TWA_SIGNAL;
-	}
-
-	/* HYBRID_IOPOLL only valid with IOPOLL */
-	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
-			IORING_SETUP_HYBRID_IOPOLL)
-		goto err;
-
-	/*
-	 * For DEFER_TASKRUN we require the completion task to be the same as the
-	 * submission task. This implies that there is only one submitter, so enforce
-	 * that.
-	 */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
-	    !(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
-		goto err;
-	}
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
-- 
2.47.1


