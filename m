Return-Path: <io-uring+bounces-1232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC5188CC3C
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:46:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7FC3324C32
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7607413C8E4;
	Tue, 26 Mar 2024 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kkL+Xg0s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA5313C3D8
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478783; cv=none; b=l17CqbmlSquUZBXvqzxlAWV2yUofzAKuQZGhfXRDjrHzUg9+KyYQxP1UWTSob62ObLwk5P1tke/hotVTaAfPQuZ8v4AO79zkv0Dd4MoZBnjN3JJyZWFD/rr7tGzxFLQB3mY5eOGJ3ZEeIYCAh6J3WBqYNGw6Tqu86DlvYjvbNc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478783; c=relaxed/simple;
	bh=9HhjGWUhIqjzfz0me/ODfWRKxY7Oa2h+2ifHyQ04mrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+wCc2pXNZoIDdrX0W7e5uSOuTxwY72zX92HON+IhEbGGq4xxZCNHHTNGFcmsGDzItR+n7FHUicQFRVFYQDkMYO12StGc+zpgmEf4rj33dtiqyPQG0SQPsQScOt1bV7AS6jCVjuNIk1P9HD7bXdgdhFtsPRwq3k32wvjII8ANi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kkL+Xg0s; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e0e89faf47so3621975ad.1
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478779; x=1712083579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFTryVI4kc0QXme9znMU16vUwU8JuZfnQ3UDLPF9VYw=;
        b=kkL+Xg0st8qxMMD+CkMW4F5334h8hp2RLNVbMxE09Bpf7gam9mKD4AFVzD/NK6M36k
         8llxayO3JL7k/6qcYw1cix0c3be+vxWXtM23uYYT6NDzUp8NsmR7yUvlKcYPAvYYW+UR
         FGdcRBSeU0GPsotNDluMBSrgwWXK/q0llYsAwT/WFFlkXg7GKrLgOoTBk0vzP5sq8Kok
         KKQhBXkuV+H10SKzwDfqlri41G34jR+1eKVzP11/HQWOUWGwV+MQm5Ty+AImgkc8QlM+
         HxYboLyNPgDH9uYWjvzjTk5YnwSzgq52ib+uE4LDhIH8d45JxClEcZdrEcpDJhh/njBB
         LsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478779; x=1712083579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fFTryVI4kc0QXme9znMU16vUwU8JuZfnQ3UDLPF9VYw=;
        b=m3mI3E9zsFS0ENMFZmxszOO8j4Iph95Ah+Qy4fOd75qvpWUrbo6hqtlniHmS6aPaaa
         1+eVeNhRbB9r48qUa4ti/I8k0lbZi3iJNQbMf9J8XhD8bk3Qmp5RAf/qAJyWNIgAAIwo
         OjhpNyc2FNMSta3sY9k5z5G24PZ5r06kBBUwxftzGVMeO9K5WFm1HxR3MIaIiipmYx06
         Cg5kInjGRX9+znGG8xEMs0bGtZ4BbE3hdkrpxQuS87CjYCFbm7dUI6N37GwmLSLGhf5O
         VMY1wjrq8XFSoRJaFVsh93PkvpGIMeycbg5vl5SZzo0l+6p1E2sYtnfDxak08JRfEZBT
         QHnA==
X-Gm-Message-State: AOJu0YylH+jxYR6d4NrWbwKpz94d50Rk48IoVhkiAIihcRpGNef7F6ht
	cIsmSbW/0SnaaBSJsdB3BLoVmop5PrNT5wMZkRX38d2zuUcIZAQWR6xFgvyuD1h/ep15ltXItbs
	o
X-Google-Smtp-Source: AGHT+IEvbtyw+iJIgyitC43u4CBp/zxR+H800o4mInRCfsROUYdLMpZjFv8jWZRiqs9UlD709UiU6w==
X-Received: by 2002:a17:903:12d1:b0:1dc:c28e:2236 with SMTP id io17-20020a17090312d100b001dcc28e2236mr12672325plb.2.1711478779376;
        Tue, 26 Mar 2024 11:46:19 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170902fb8400b001dede7dd3c7sm7152833plb.111.2024.03.26.11.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 11:46:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: use the right type for work_llist empty check
Date: Tue, 26 Mar 2024 12:42:45 -0600
Message-ID: <20240326184615.458820-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240326184615.458820-1-axboe@kernel.dk>
References: <20240326184615.458820-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_task_work_pending() uses wq_list_empty() on ctx->work_llist, but it's
not an io_wq_work_list, it's a struct llist_head. They both have
->first as head-of-list, and it turns out the checks are identical. But
be proper and use the right helper.

Fixes: dac6a0eae793 ("io_uring: ensure iopoll runs local task work as well")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index caf1f573bb87..27d039ddb05e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -343,7 +343,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
-- 
2.43.0


