Return-Path: <io-uring+bounces-6566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 463BDA3C625
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 18:26:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A908B179506
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96A32147E6;
	Wed, 19 Feb 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hpTWkeuh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC402144C8
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739985967; cv=none; b=ZlYADRWX9BVYQhYYt2iAkUBfyvAGfY69yAUUhKM7w7zZM3mpeJVknC2tMFuuJFD62Kxhj1mc52Ph8Omyue/WmBmPtrmCJUV+x0VC+Fleq5mQ92GhEWX3Y+0cQ1XmWnvGulJimsK4yF7zjillYUPAUkBJhMelMqCfIE6t/bTaSgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739985967; c=relaxed/simple;
	bh=ncIk5lZdtXMareZLLRLznXToBtthtk/Cr53z96DFIhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMxefQAw52xiv//T7lqkloouH/J1b1EvMBseUf6KlFRtecL7K+y8ERr7ncalKF9CbsShL+rC8EiJthub6VFgsGaxuylQy3Gc7GWS1kIDU8DnyX1VKMlqLCVbwg6wYT/hIXBRe6vPqcbFiFT9LjO6r6uC4nI4xTRQbr3TC+5W5yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hpTWkeuh; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8559020a76aso1012339f.2
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 09:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739985965; x=1740590765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0lcG2A37eoJmBm5Sthc9LwQizBsGAmnbEYmyOv84yU=;
        b=hpTWkeuhigZzu26F/jVaGSUM4d8OQOkOogJ1TW3UtqtNsN5h9GrW3HIBGqwkA49MEV
         U6/NWIxedO1TCL5gnPYP6ah/2K+Limag27Nq09AoTf0eTkJFKMR0MggZfTUQdYkBNcNM
         sGSHoHyJQ49g2o5keRuiYFkVaMrzyRPsmogkAVse/Y53duT8V/cTnYuxQF1HPLP8Xwqg
         CCnrNPMmv0GAVCIJjooqXOB8mbIOU72twwzqifKiBIkwQNCd7aRYSfTZm8zSJ/aOTcWR
         ZowSQ29Np4r4rfIE3ytdt9DiYBbLw/hpfCTuRrEiM5MHNmxhe5Fb+VtrG8J6qNYKhCeO
         5CLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739985965; x=1740590765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0lcG2A37eoJmBm5Sthc9LwQizBsGAmnbEYmyOv84yU=;
        b=A9jPfPlP0LK/6JK8aze8EcsimRGRS7+pubzcdFoUmUCLdL9i1RJ0b8kNa4bp9DW/jp
         e4sOzgdm71jt+83y60hchupQy+1T87sq3zGxQHe3H9Vgqn2Zga/390cXlfF7mdsY/9As
         iOQMIL9IoysqGiC7wJoSwY1pqqXRbEysPggAAgiSvo0Z7r9zJYyEwtRh+DDmDLhes52v
         qyPE8PpQZl4vRjF5JE9CEEs0sxCw51UFRtKjM0x0MTo3LMQ0zwwTfWpTEpwmzoStPeD2
         jp5i/W6A2YdashIO1ddgJyqzirSuXXOJ7VRc5obXT49uxGkyZpi+NYC9tz6cG2xpvqnA
         Jr/A==
X-Gm-Message-State: AOJu0Yy0RaSqjPRLYbCfbLXW6bfuK/diIvr7+lCT394AGbhgOmNkj8C0
	a29a5Wu/1Qe4YkPevvmjowavIhCG3lr5fUejPJQZhP6Q2eFvfzZsOWwXVVTqcKL3HcwHLGHQpwf
	l
X-Gm-Gg: ASbGnctXVsqhSxI3oC9NMwOTEEMaXTD8ACnjz7FpQ+z7x3lEUrbrnwGDAWxNQfu8MvS
	Yn2AOgc8D9YEB4SfCmcUVhtjtGhJ4Mc9V4bhmjUsydNJ/gdxWur9lpZ/c02CTB0nUh4PQ5NHZ21
	PZvsR5Ex7xCbUn01Ns/tYX7sUDXM1WWKP2Ix2yum2zaETt9jWFjriETsdVAE8/q/LNu+0EFHLc5
	RQSiZYHRr5fdJB28yQ398Ck+pwQC9uyLI8l4JIM8y/RUM5UTvGD/d0x8F9XjauMB51e1G/F69Na
	OV4hMFaHpHcRV3TSZzM=
X-Google-Smtp-Source: AGHT+IGYIPWi9eQLHYtKf1drbY2zK8Yd0TsYlqHyvQz2uzX5viGmpOXBKHoGJnimabLO1Cg8mKr3uA==
X-Received: by 2002:a05:6602:1346:b0:855:b8c0:8639 with SMTP id ca18e2360f4ac-855b8c08f1dmr326646939f.14.1739985965016;
        Wed, 19 Feb 2025 09:26:05 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8558f3ccdcesm142192839f.16.2025.02.19.09.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 09:26:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] eventpoll: abstract out parameter sanity checking
Date: Wed, 19 Feb 2025 10:22:24 -0700
Message-ID: <20250219172552.1565603-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250219172552.1565603-1-axboe@kernel.dk>
References: <20250219172552.1565603-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper that checks the validity of the file descriptor and
other parameters passed in to epoll_wait().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7c0980db77b3..565bf451df82 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2445,6 +2445,27 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	return do_epoll_ctl(epfd, op, fd, &epds, false);
 }
 
+static int ep_check_params(struct file *file, struct epoll_event __user *evs,
+			   int maxevents)
+{
+	/* The maximum number of event must be greater than zero */
+	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
+		return -EINVAL;
+
+	/* Verify that the area passed by the user is writeable */
+	if (!access_ok(evs, maxevents * sizeof(struct epoll_event)))
+		return -EFAULT;
+
+	/*
+	 * We have to check that the file structure underneath the fd
+	 * the user passed to us _is_ an eventpoll file.
+	 */
+	if (!is_file_epoll(file))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_wait(2).
@@ -2453,26 +2474,16 @@ static int do_epoll_wait(int epfd, struct epoll_event __user *events,
 			 int maxevents, struct timespec64 *to)
 {
 	struct eventpoll *ep;
-
-	/* The maximum number of event must be greater than zero */
-	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
-		return -EINVAL;
-
-	/* Verify that the area passed by the user is writeable */
-	if (!access_ok(events, maxevents * sizeof(struct epoll_event)))
-		return -EFAULT;
+	int ret;
 
 	/* Get the "struct file *" for the eventpoll file */
 	CLASS(fd, f)(epfd);
 	if (fd_empty(f))
 		return -EBADF;
 
-	/*
-	 * We have to check that the file structure underneath the fd
-	 * the user passed to us _is_ an eventpoll file.
-	 */
-	if (!is_file_epoll(fd_file(f)))
-		return -EINVAL;
+	ret = ep_check_params(fd_file(f), events, maxevents);
+	if (unlikely(ret))
+		return ret;
 
 	/*
 	 * At this point it is safe to assume that the "private_data" contains
-- 
2.47.2


