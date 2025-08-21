Return-Path: <io-uring+bounces-9146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE67B2EB1D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:09:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E50F1CC278B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DE62D8DD1;
	Thu, 21 Aug 2025 02:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yZe5GI3E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89262194124
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742129; cv=none; b=KMjrr/1pXGn6U6nmObxTCsCsZoPCXZ+nBGa8jEjZcNjukr2H0GilG99191d2UkoJep8ZjyxpyS6+JZm5JyJaNIwBxaj5Hr+zw3/fwvhILLQr64lWYyekTGeJyNR4X9vjn47sc26X8RLKH1Xpm7IV+dBHTnvRYApU3FT1VN7jQ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742129; c=relaxed/simple;
	bh=ZurEwPBGqFXVnl4VMyKgv1fgolPjRZpN9Lh0EAeyXSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/3TjzljvB0puiBn72pYczooaZuYox9R8BkMlYb+veWW2ucyLhM+eLeEmBhwUWavpldmNZh5BCCkGfwJK+19eo2EJO+vCu9jri5ogUwrVv/moLbTG7x5M0j7b/xQL/XzDm+qvIkYXrjEugYPLKV1QSe0OZP4O+2+zA8Udy2eS1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yZe5GI3E; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32326e09f58so632603a91.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742127; x=1756346927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dm4vhpWrvJJ0HQql3aNzo477HiNDvGpWHj7PVQcGbCI=;
        b=yZe5GI3EaFJsbI4wK/1kmeEWCRnh4v2mSnFx+lfbyMQ1GwrMCnygkO/fTmIo1BYO/a
         0VNkIgd53qzvo0pWAUJ+L2cO7HkTmHY6HEW5Tpg8pwk/OnsaOD2JWNav4hR864KM9bfP
         qMSxcwdDDfmxr5k++jpv01olWWipdke/OCutf7MZNBKa06Lblq4rm/mWx6LwBttTwNBy
         cqfKf/BpsZy9ESxaPJXTtWpAPUlTQ7i+hMe5R1+3cgiub6fMfya9gzORxT3cIIS9oFft
         I3jIiVAbR5aO1PGl+xxWCncM6A+pqhI5/G2WMGnqIhgjwP9mkflxEq3RIQyZaJ1ljF86
         Tsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742127; x=1756346927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dm4vhpWrvJJ0HQql3aNzo477HiNDvGpWHj7PVQcGbCI=;
        b=tftb4qMYa3HSfDcqbFC4ly8d7swZfE37CoSPgJLqpDERn/yL9Y4JWY4f7MoxDULWea
         +3rbptom9iw6EgF5IR9pZAQDv9TW2BfxjFgX9GP8KF8u6upOP7Zujdn4nt7+RGb/dhVC
         ncJhq2HXLbUFO6uR1B8ofE3mDoUoOcefECCwPlCBZxKh3AIeiO7qR2+0sRPfsUwnuoFb
         awU8dqzt9yROsXjBnmlTD23zOzo4Cc4FGJ88DW3Cd/dABOCce4COVOQc6v3MCQ4Q0lpH
         BVls2WRcNdqj8XvplKgqt8+WHfH6+jQhSKOLIkh+q12S7GR3/7C4vnQPisCmLOvyPiAa
         o+Tg==
X-Gm-Message-State: AOJu0YyU5V0OV7QyIOQOSbjAkQb80Wl4RCcuy1e+OEAcaRbr3eblL9nd
	5TgLCvs0/r0AirKbqssvOrK4Tuj3zj83/wjFpve4BbkWspPzRuVRCINJntDJ/pveBqYaQRPV1UA
	f7ZDx
X-Gm-Gg: ASbGncsl8erLoTWZ7TH3oAYWfK9b29hi9bHSzppg2mG8EoJUhwinNCvr/c+FNgyDLcz
	RRXS0h3GcvjbxO5xES0mzrAxy8sD1oMW3V+BRWvoPl+2lg/jEztvu3iJZgansYV180AvIsym+1n
	r+QuANelAgyL8wtO/uEhR1B6QvZw7YXIFFuD2WSA3ZAdkV8NXK8YQP3mii6XkISWYrlDEA3zO7g
	8Bnx6YpiAIGSteTN4kKCj8sI9tRLEJJggd15m1X/eMDjCLLMNC1XBjiKMSXdBlmFBjDtWJ9305y
	/gOaufsUmEpZ9XEZJLsV9AJRpQa5ZhziYwzr/l2dSd92uWgj0ThgglpgFwKcLb1RzmmOdvMVN4V
	XQlLfKg0=
X-Google-Smtp-Source: AGHT+IHM5B4cEki8r2h07uquVuG2ybroATn0FqwNQ+uqL/+MKTtyE78CO3b6MuXRXFQt5rqo9eC5eA==
X-Received: by 2002:a17:902:d542:b0:242:d0c9:f08a with SMTP id d9443c01a7336-245febfe24emr11779685ad.20.1755742126863;
        Wed, 20 Aug 2025 19:08:46 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/12] io_uring: remove async/poll related provided buffer recycles
Date: Wed, 20 Aug 2025 20:03:40 -0600
Message-ID: <20250821020750.598432-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These aren't necessary anymore, get rid of them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 --
 io_uring/poll.c     | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3c25b75dee9d..6247d582fb40 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2025,11 +2025,9 @@ static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int r
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
-		io_kbuf_recycle(req, NULL, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		io_kbuf_recycle(req, NULL, 0);
 		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
diff --git a/io_uring/poll.c b/io_uring/poll.c
index f3852bf7627b..ea75c5cd81a0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -316,10 +316,8 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 
 	ret = io_poll_check_events(req, tw);
 	if (ret == IOU_POLL_NO_ACTION) {
-		io_kbuf_recycle(req, NULL, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		io_kbuf_recycle(req, NULL, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
@@ -686,8 +684,6 @@ int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req, NULL, issue_flags);
-
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
 		return ret > 0 ? IO_APOLL_READY : IO_APOLL_ABORTED;
-- 
2.50.1


