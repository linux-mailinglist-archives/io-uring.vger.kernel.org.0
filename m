Return-Path: <io-uring+bounces-537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E35784BAD1
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B97E1F25231
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7671350C4;
	Tue,  6 Feb 2024 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wuT6IRah"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7F8134CFF
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236657; cv=none; b=D3iFsu4SyYk/kO0ReKZzO9SEUsfNGFHBmZmakSwSRhKLkOd2WKJkcpvuJbkSL75XjDVB4L1QI9Cqwq7w2x8LmieE6F73AFd6aAdeQ6m073YV3DJLzpXDUHX7JV+rr4DhuRSAEjew7/dYRTy4xWr4e5XSdCTv0O5BYyc0SfjY0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236657; c=relaxed/simple;
	bh=+OxtjrK4uEvJXTurejEo5/X8jfGWKREe/uT9iKMACNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyRjh9NSQyacp4iwL8phbUzCgVDdAHFL9AEfX8loBE7nFT6ZC19/18ngBcqj9L+ETtMsVy2Xtna2V1vlTf99RKxBDN9MJpjSywlue2iv40n6P9fIOxyFhcxQ5P2TAn8RUsxoMmhOZfBOsWzV4I696oIrz8Go67bAQ3Y4fO7vwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wuT6IRah; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso16581039f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236654; x=1707841454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xcXfzwvlM8i1i3PC8yvPbeMAxX3SSeQ1hy/DHx3+Lkc=;
        b=wuT6IRahhg7jqYAKUrVbHPPiestDiFKx5ogrfDNfrd6i4KkCLZXJEfl89vkuQy65cQ
         u5YQhPOGge/46xAXvkM0qH0SzcVATcd+8PEMZzg/IdDpekU+gwS5MXvlskBiGT9YQC2J
         qD26Gvi5LM6giqiW9OWsHgwEEIH8+8KECLvuYZkRpDOdp2/epVI4ieyJkItzAoybA8Ix
         nVbZ5QBK24jS/gzQNfMC6AM6MN3G2CEK0Cdik6yxOWz/P+hNQFU4WAuouNNge9nIZmtI
         sXHFXUyhKybIQYCtAnDT6rpjEE8lX5raLTZ2LMeKNrJ3datjDSEpHPcRAH6vz5vlJSYI
         Rx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236654; x=1707841454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xcXfzwvlM8i1i3PC8yvPbeMAxX3SSeQ1hy/DHx3+Lkc=;
        b=maDtdcdZGdRmS4+krQZBFct8zKmMJhoGLnSwR01P5v7IA0vWIjLGkN8a8/VFR+U00v
         xAR/dVCfy04upCvl8lSlMbFB9ZoQQmIaSqxn+ZZ9sorZzYnUU4jDhyx4W5pRCzqomItb
         Q4c6Hzn4F6fsimtU93sZU+Rtt+JhKGWoM0fop8G/erza6Gk6spHPeo7kIuyRqtuaR30d
         XNDLFHT/bswFOkdayOf2ExG6wLWVtWdaUTUnnR68k5Hdx6GPpXKpVs59y4R6n2sLdkx+
         hROLZ3Y0lDLznhnVc9jA2qpYx1li/g0/hRpjUMWNdaE4rqhBvvCTHmKyBZQo6wFloVPr
         Rhqw==
X-Gm-Message-State: AOJu0YyGZq7RGE1X16nSTzEPb5rscnFsBWT/jFfsPv8qQQ9ZzgSsKgVt
	F8aUe+sLAQeR6h71L+sDFqVBEW0kxOdOv4aSyvsjp2sEI2uWaT9xMBkzI9Sj+nHVPHOFQBcAlKY
	cxFo=
X-Google-Smtp-Source: AGHT+IFwpEf7QjW3ovkgo0m0mQPhIq3HQbGgfhE6640h7R4jlyGBT5hEQGzToXk7ZtyQQiIPjLKZSg==
X-Received: by 2002:a05:6602:2bcf:b0:7c3:eaf9:2cd with SMTP id s15-20020a0566022bcf00b007c3eaf902cdmr3500309iov.2.1707236654608;
        Tue, 06 Feb 2024 08:24:14 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a6b5b11000000b007bfe5fb5e0dsm520031ioh.51.2024.02.06.08.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:24:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: move io_kiocb->nr_tw into comp_list union
Date: Tue,  6 Feb 2024 09:22:50 -0700
Message-ID: <20240206162402.643507-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162402.643507-1-axboe@kernel.dk>
References: <20240206162402.643507-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

comp_list is only used for completion purposes, which it why it
currently shares space with apoll_events (which is only used for poll
triggering). nr_rw is also not used with comp_list, the former is just
used for local task_list wakeup optimizations.

This doesn't save any space in io_kiocb, rather it now leaves a 32-bit
hole that can be used for something else, when the need arises.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 69a043ff8460..8c0742f5b57e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -602,8 +602,6 @@ struct io_kiocb {
 	 */
 	u16				buf_index;
 
-	atomic_t			refs;
-
 	io_req_flags_t			flags;
 
 	struct io_ring_ctx		*ctx;
@@ -629,8 +627,11 @@ struct io_kiocb {
 	union {
 		/* used by request caches, completion batching and iopoll */
 		struct io_wq_work_node	comp_list;
-		/* cache ->apoll->events */
-		__poll_t apoll_events;
+		struct {
+			/* cache ->apoll->events */
+			__poll_t apoll_events;
+			unsigned nr_tw;
+		};
 	};
 
 	struct io_rsrc_node		*rsrc_node;
@@ -639,7 +640,7 @@ struct io_kiocb {
 
 	struct io_task_work		io_task_work;
 	atomic_t			poll_refs;
-	unsigned			nr_tw;
+	atomic_t			refs;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
-- 
2.43.0


