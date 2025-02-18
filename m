Return-Path: <io-uring+bounces-6522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7270BA3AB68
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0F2173DA1
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D121CEE90;
	Tue, 18 Feb 2025 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kTE8upDE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894821B87FB
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916104; cv=none; b=UWweB9MEJpgyZbfWai0fNCvsMSvzmXRaWvD0nXfGY/mIYIth03ZQzbtLDbxKFRYhEQjLBSSi8gZ2AtXnRyzuBK3ItL7w3iURJDrkTJ34FrVgwf2/Pah3EEFh2a6762Mf9spTfLJT6Ygeb2R5t5E/5vMnkyyAynn8GuxOLevTAoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916104; c=relaxed/simple;
	bh=U9GBcTbEhnvXwzkuE+H/Yp0pys+0CVLQaKSQ1CPjWqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/nSOFEBpyxkBOoiz6RikK6+lX1/z/zkd2gLN5dUS0M8wOVHv4MtaHqEQOYEyCzNaHx2EHRtsrOrlKdvKKvwsJkmUj9Lst+S60V7FfvzL3d2yxhvaJQDdQjTd6j4+ZGiR1HY520I1Z4rZhsN/NWRE847jAtKID/gjb20isF2KrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kTE8upDE; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-220d39a5627so88763495ad.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739916102; x=1740520902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e6p0eNHlExhjC1VzHu83sWwv40KIotSYsW7eaEIok/w=;
        b=kTE8upDEJu/7lQzUXOFD/MJBmEPXadjOjjP95CSg1SotBMYg6m8WrhB8YLbJQit/QK
         GyZcR06dZqypzX7gage5LnAPXd8iieWhA6up4V+tofZ+WCS/wwFILcB3dCPg2rLovQvZ
         Fi/Fmj4NjShBCDAHELlzU6G7Qvzs8giZzoEgyMVgigxokwsBe437B13PWYS8PM6Ba1V1
         EqpibI4pid3//Z3cDQsl2fHFZvYMAhdrQv2OwIj/xptSOJMjvwTFVqa39TmN/E7ZJvg2
         zx/T8o94WIZ8ZjthmD3OCKpnjtd9fk19HkF+bNUR3I6By0fimob6G0OSYToU4QtpQpCv
         1uVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916102; x=1740520902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e6p0eNHlExhjC1VzHu83sWwv40KIotSYsW7eaEIok/w=;
        b=jVLOQtOIqIH1djr+ORZ+DAYPgG3XqE/8J73AO92hrFmjhMsjYxsq+Xypbu/1iF7pAw
         Uc0FK0X7nwDfhcdFYd0U5VLvtoYo4rlxAPBAfTNHDUWHSilLiDYConRsYN7pLLLDvQAT
         Bw4CZwsE90riUY4OHQJpEpgifnXBZRdYvlwLi+Vu3VcAnqOmKfkmgZBFi/wPrVV43VRT
         9h7u/pqlDUa+SYOOnmGSR39t6w8X/AFF73A0t+Q/apclmT+nIDxFTsocj52lbDKD5k5T
         WiY4WLpY09qqnbsAkFkVDeCvJEAabZB1u4Y63tBi3t8DXabaBnpNRpPfQDj/TaxJ3mMd
         +rOw==
X-Gm-Message-State: AOJu0Yzc9Y6QvbU4cd9IFxlk+VRzicN0xYgN7haL6+r4QAO2eG+RMc5F
	g/0NPq0Z1JfXW2JL1TKHfopiiI1+IJ8jzievbQ5OpobuP5JgjFKeQxf3EA+mOB6pwI570O7Uv+G
	Y
X-Gm-Gg: ASbGnct/Xhzl2npyqFn+3OS3TBe+prI4NG5FVuVEG4XWxV7YpO/TrRc9KA0q2gOO5En
	Qg99UJTmNPuz9iEHdxYSkjMEdGXOu6Kps+IqQpwfK5xW/RwhUYxC0hHBto78CrXEyrMkrCASSi/
	nzhyd4SFVEFQw1zbAUG8IDhLgHqW1JHxmV38L2SARB3M7aEXtVWyirInasy1C5NBuBqBVcV8ad1
	1gLRONswNHcHmNPtRIH8lIXyZcV8AcS+spnuiDfstVYKizfLF7F+sFmIBZrNwedX5GRsS1lLkxE
X-Google-Smtp-Source: AGHT+IGlx3m5MCiO8Zg9auf9bVZQjrQsAmNJsaRQnBxzGUecJ8W3oGwRoNCcE2J4ejoTZvCbg7UJZw==
X-Received: by 2002:a17:902:ec84:b0:220:d532:834e with SMTP id d9443c01a7336-221040255d9mr233647425ad.19.1739916101788;
        Tue, 18 Feb 2025 14:01:41 -0800 (PST)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545d4c9sm92906565ad.140.2025.02.18.14.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:01:41 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH liburing v2 1/4] liburing: sync io_uring headers
Date: Tue, 18 Feb 2025 14:01:33 -0800
Message-ID: <20250218220136.2238838-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218220136.2238838-1-dw@davidwei.uk>
References: <20250218220136.2238838-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation of syncing headers w/ zero copy rx changes, first sync
other unrelated changes.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 src/include/liburing/io_uring.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 765919883cff..452240a6ebb4 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -364,7 +364,7 @@ enum io_uring_op {
  *				result 	will be the number of buffers send, with
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
- *				will be contiguous from the starting buffer ID.
+ *				will be	contigious from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
@@ -424,7 +424,7 @@ enum io_uring_msg_ring_flags {
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	user_data;	/* sqe->user_data submission passed back */
+	__u64	user_data;	/* sqe->user_data value passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 
@@ -616,6 +616,10 @@ enum io_uring_register_op {
 	/* clone registered buffers from source ring to current ring */
 	IORING_REGISTER_CLONE_BUFFERS		= 30,
 
+	/* send MSG_RING without having a ring */
+	IORING_REGISTER_SEND_MSG_RING		= 31,
+
+	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
 	IORING_REGISTER_MEM_REGION		= 34,
-- 
2.43.5


