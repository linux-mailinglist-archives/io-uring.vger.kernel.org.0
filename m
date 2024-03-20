Return-Path: <io-uring+bounces-1177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 882FC8819B7
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4181C210E7
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D581E87E;
	Wed, 20 Mar 2024 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gAmIKYNP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902AC85C65
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975503; cv=none; b=QZWs72/Iw7iWgWlscbrshFH3rO9xSuakqhIe5MaowQmIMREl/alSIv+1PfoIFvVCIgIXvQ9xVDOHGRqplSg/saj6cVj9A48sLjOAXYRRseNvIrM7KN1zT75pqDcbfBYvbSFfokxDJUykiYNWWMvgulwyzWUHOalz9+vlyAkrhEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975503; c=relaxed/simple;
	bh=4wN+eMVoL9e72mNvWWYFnGOyQ5/owDLs69We+rw9488=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9956007Y9QN0Gez9bdccyev6qJjNILs8ut3udG5CrsyFUqLDbW/CvpwHSYHQqvU7WMQ/o3awO/rlUw02U22V37tZ3WS+JBmfzSVLFa2vGrAne1Kz1M2AQqaZYIArVnm1pecxRQ3/SkdT7mS2M7jp6ycCU+jjbr6iJ6P0aNBhQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gAmIKYNP; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so6269039f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975500; x=1711580300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6Dq8Aq42rQFuVjQCYhDK27TFaOTjwnZrM1PePD0aC0=;
        b=gAmIKYNPtyB6ZhqPH58MX7GXl7DczXgNDme87rw79PxiPSgsGiUV7nK8MzH7GLgn7H
         Fje3QBeEkvir+ASWnK111UxCr/sHQgCoiMGydipD+2ihhdL1wgPQZre+PnYpSdqPkq3t
         cB7LeisROFR/ZHJcUB2CsValsaY4pAvr2DjEFdqybXluL6Il4lz7lYFd5lAJUn8IIR1s
         37T3xf8+gAMYx5/rf/DdwID+tZ1/W23cg15v3PZAfn7/EETPJ2o1dZ0brqo9vwL1bygN
         iZswDz4iafrOJGJ/j2Pgz9yxYMW2xH1sncmeGWOkcNt3Pot5kARuJzWlQ5XVuECyzwIZ
         tVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975500; x=1711580300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6Dq8Aq42rQFuVjQCYhDK27TFaOTjwnZrM1PePD0aC0=;
        b=nxxd3d0Ul2de7jYy0SzCIC/0ca0uYxgaYBwyQ99vpzxobNCBt5uj3N9BJOTQxxEbxR
         t43mjT/vyYvMsxdh0eOI0l1X7XSHsgUcwI9YD+00Ej7MCj/M/qPgKNMeR0FCUyHL8oJP
         5zG6wW5EhudE5kYVsgot+1i+vp630yA+ZHRumMR3M8iw9MhlzStaB+cjwqtelzKLCtTd
         Zyn7948rw5Jw4QPNEptCxIPWm67l6RQkKlf/4yZqRIai4YZ7SkZJ1e0CCpJfUhe3Ku/2
         3qvPFeoAbnt+VGcnBsDhnMpWtw+UKzg1KM4nIdTRiOyNrFqNX7OXNBusxC6PsHo0pGvU
         6hrw==
X-Gm-Message-State: AOJu0Yy1IXjCtE5+g7USvcyo3re/j9Ftj0IYD+MxiokGGGcbFw2ZhJVs
	XgQfCa9BmfRLYe1G5EeqJm+SARnnEPBeaWOCKjVoS6wz+/GcTppspfXTXz9WhIPdzg/cuSEbQsH
	q
X-Google-Smtp-Source: AGHT+IGXCl6RHxETjLp+uYT75eZfU5J2KIkCfP/DhdsSVfDaVw32lOLhX+1QNGQubHNqNy+nEUezog==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr6851938iob.0.1710975500449;
        Wed, 20 Mar 2024 15:58:20 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/17] io_uring/uring_cmd: defer SQE copying until we need it
Date: Wed, 20 Mar 2024 16:55:30 -0600
Message-ID: <20240320225750.1769647-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous commit turned on async data for uring_cmd, and did the
basic conversion of setting everything up on the prep side. However, for
a lot of use cases, we'll get -EIOCBQUEUED on issue, which means we do
not need a persistent big SQE copied.

Unless we're going async immediately, defer copying the double SQE until
we know we have to.

This greatly reduces the overhead of such commands, as evidenced by
a perf diff from before and after this change:

    10.60%     -8.58%  [kernel.vmlinux]  [k] io_uring_cmd_prep

where the prep side drops from 10.60% to ~2%, which is more expected.
Performance also rises from ~113M IOPS to ~122M IOPS, bringing us back
to where it was before the async command prep.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

~# Last command done (1 command done):
---
 io_uring/uring_cmd.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 9bd0ba87553f..92346b5d9f5b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -182,12 +182,18 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	struct uring_cache *cache;
 
 	cache = io_uring_async_get(req);
-	if (cache) {
-		memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
-		ioucmd->sqe = req->async_data;
+	if (unlikely(!cache))
+		return -ENOMEM;
+
+	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
+		/* defer memcpy until we need it */
+		ioucmd->sqe = sqe;
 		return 0;
 	}
-	return -ENOMEM;
+
+	memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = req->async_data;
+	return 0;
 }
 
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -245,8 +251,15 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
-		return ret;
+	if (ret == -EAGAIN) {
+		struct uring_cache *cache = req->async_data;
+
+		if (ioucmd->sqe != (void *) cache)
+			memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
+		return -EAGAIN;
+	} else if (ret == -EIOCBQUEUED) {
+		return -EIOCBQUEUED;
+	}
 
 	if (ret < 0)
 		req_set_fail(req);
-- 
2.43.0


