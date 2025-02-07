Return-Path: <io-uring+bounces-6306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA4BA2CA52
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF08C3A686A
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF9C19F130;
	Fri,  7 Feb 2025 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QIq1ROp2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB0A19DF75
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949808; cv=none; b=ZaL3yxdXd3pysEWGPzgr60UZgTPwHWH8NsQGuJ3mxndmRKMJ+1otENxmSacWHomIWmZ3XxolwVa9wuYkN6+uTYI65mwpi17HJzpO34tK6QK5OUU1NtuOz1tu5o2VVCQFs21s4YPgvmcU8HX7p4EafiIJp0Q058Vv/zuvkiDL08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949808; c=relaxed/simple;
	bh=9CqAH+/+dru0tVXL9nfonyeHwVvUOEnm71GkeIjGvRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf7PbfSYs6WnzVVN0Ms4Wya7+lN4U9jQKJEnazWY2utZjHlG/ZUOMwgMbxOol/Fba8iUV8EfZkHmWxMuYC3fpUDDYFZ0bBPwK/jxr/OOjN24wxxrvsHH6Uw6edqNXPq7zKUQLfhiaQdV0KITGN7Kepvj/WaNaSnghakSgz072ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QIq1ROp2; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d07df73412so12669905ab.1
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 09:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738949805; x=1739554605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9Ti6y1QSLcy76M2w8lkpqmCcvr5mUocCPUpPmYueYw=;
        b=QIq1ROp2jPQ7vXDU0UDHMqpovJ+0bFWWAVB0jqVuKplQIv6Ms/n0gspR4LpFhqvxtz
         MVMoZU38S0KEV6mdVt6yPRZ5vhZI52FrK6z/lvmvz/Jt74JDQJq5U+F0RAxaKZFqi8MY
         eW04mjaDSR1FcDaTYH1QGz/82I3ALxjn9Vnqcb8t0cwDS64tdoS8dDt9mvQBK1bNDFZg
         Ibf19/R2F3whADMzvbM+nviLqQ+cvq+FHv7J8HAnS3FFJr6HlHJIdHfE2xCCHArjye/d
         K/TuIgIRyJTCUUETgDIFwAIDdpaKi8M/3IXQ6QLDt6rDCXMMG1yF2fx/Rm0YDAw7jerK
         9p7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949805; x=1739554605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9Ti6y1QSLcy76M2w8lkpqmCcvr5mUocCPUpPmYueYw=;
        b=mnl/GHNbtKcfmpxttnwkmjSCESb2l4ZzeS3zSpYsQl9WcZlfNi4Hc2TvUaNoX3I80K
         gGRSKoqjaMO8Vpjsw0ALns8dYVbtYilg7HqHqdOzgptAulg/RHIkrHo3RlY4LTeHZ7T2
         BR7xi+1DbIsEJd0To7XMDW+JWHPo3E6NuBRnfMbVYxMs9JdbY0AmuKLUTw6YFTWwL35y
         g5hK/gjDDW8Q8xvKZkYBYMR1OJPVtyRFmyC5kphSPf7nDn+r6jr/4UpAEoX/pt2alyUd
         7bE0oHsXeVviTnuOo9ps0tsKBjIkGTd5kIVDOHUFMqfeMv1CoBxrxpWQOfnTCHH1Odx9
         YntQ==
X-Gm-Message-State: AOJu0Yxo3zeEP7INIdbT07ZKkwhTWL6Z2QVQM86hg7d7liTvy9yQ3MCM
	Q9hfTiOVD1sfZVplZ2WrAEHpUbSdMkx2StZB4TqUcIHnnu8UmdcT2oCcDfHK4Lg+D6FBfRXe9OD
	u
X-Gm-Gg: ASbGncs/S+famOlgniqMNsHR3h9/aKW3FyNc8L/EbggEESapror99JIhJwlLmwvlPYX
	H+Cj6hcuTB/wEHS3YySXsnpKT5U9d5P23ET2DoOMrDUlaeb9xbvx9y2piSMVPMXgujVszmElWyB
	MVYcR7+u+Sn8EJAYpdM73UX0bCbnYT3bNQwscGIGCuwiNss15EASpGZeYpi5Yoznf46YM7YfjGd
	uHeN7wnxXVib9m4hFZmW2P6L3Ojp1umm76vCQWpl3B+emL/jC2r8UY7jeQ6kKb2ulgsNXALLMU8
	8LxBq3eaXdMkzgOCf+s=
X-Google-Smtp-Source: AGHT+IFPmeblSOGaVkG5w0Ux/nI58zc+Fqb2IC9VZwr48nevrVhclD4bfbjaJIUg0GayPfKZ5zroMg==
X-Received: by 2002:a92:c263:0:b0:3cf:f88b:b51a with SMTP id e9e14a558f8ab-3d13dcfce6cmr34571995ab.2.1738949805333;
        Fri, 07 Feb 2025 09:36:45 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ece0186151sm206241173.111.2025.02.07.09.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:36:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] eventpoll: abstract out parameter sanity checking
Date: Fri,  7 Feb 2025 10:32:25 -0700
Message-ID: <20250207173639.884745-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250207173639.884745-1-axboe@kernel.dk>
References: <20250207173639.884745-1-axboe@kernel.dk>
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
index 67d1808fda0e..14466765b85d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2453,6 +2453,27 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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
@@ -2461,26 +2482,16 @@ static int do_epoll_wait(int epfd, struct epoll_event __user *events,
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


