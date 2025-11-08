Return-Path: <io-uring+bounces-10460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C575DC43316
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 19:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE2E6188DEAC
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 18:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8182274666;
	Sat,  8 Nov 2025 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="hnXzvCmw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3381F271441
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625671; cv=none; b=nqTJMkk6nDB9TWBWyxjsi98cr2Y2f0HlR94A9FsAXVyZ7Co8MfmgXYAsLJsdmZzv894/BydCm9x6YUieARk4ooxZvIdN4UFHcYOoBz608vs5jb/EFQCzvGRDZ9BIlWUatojiCPeGwRpU4bfXdZuLwlswfJmoXkCfcdpdFBj4BOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625671; c=relaxed/simple;
	bh=RZO8QZNl3njWNXuqdNfw6N7pEXP58ME3UMHZJeNoP2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ1MiIyTbJ5BsF+vfcDaBqWWkLWQWJj9mQrOkKp2pm5poKpKx8lqas9Tk5z3mGNoEQxvHWjQQT/p8wulOq9OUCbwPr7OHOPaZ0D1UWPMmT+dXFZz5oI55X3SZmoLay/gPAju5NexFn3f11O4A0lYk6shE/vOanfuOVBLd3l0xw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=hnXzvCmw; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7c531b9a45bso467092a34.0
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 10:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762625669; x=1763230469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2vw8iUOwVqaGoE8XlVsCXxMXbv+G8Ki5VhI3SGzvvU=;
        b=hnXzvCmwE4XitFzLitVU8cvksvkYkS6TcGLse02JCoRNbi9gIKGD28DDSgQfpOI6b+
         CG6pgkT366a4oCMhMNvpctzVqi0MEX3AWeMItXvUqa321ycBTszEhR9OKFWbA7bKQCnU
         bXFUeKk8q+hZbGw+szdcJmlQAzWQiB+kk0BqG6u7SxbUb37Yf0MLuc8ROxEO+4y/35Pz
         LEkQTtCQTwHYBz8U5nn0L4ZLJjwlNlWCNFpRurR9vgFO3wL83OyempQDrZbm9pYVyoCI
         j66EVSt8/qp5bWDnud3JuOWKViVzN2YZLFWA0RbqSi9txY0OYdDD4QysYvwV8hWhuJQT
         NjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625669; x=1763230469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e2vw8iUOwVqaGoE8XlVsCXxMXbv+G8Ki5VhI3SGzvvU=;
        b=cI91ofwy+d0/yiVhce3iYFe5O368pKAWUfkHCN/whej/5vw8tezKdXOj2+utR3OKEx
         To0xiUzn3U9X/EOqfzV9coozBHhWYCpnbVOblMVg31/vlfnuGxkiuFPYgpROJO9Pz7j+
         IvU8wu7mpCgOUA8a/8j0zzNd0wtP9j8CR/eq8zLqQUxmqz1rY9c4+HdKp9ydtbq63XP7
         mEbXHEXcUT1rj9wr8COKxOiwOSOTQRU+qgHcS5RI176r/cFy/KebLqx4l+DxGzy2X14B
         tyYho5nuZf8fI0RsiTP0M9sAY49vDKPvVfgKoEWK/2dVXQvEYQAaiFHA3WNOyQDNqITE
         gkhA==
X-Gm-Message-State: AOJu0YyZoiAW+HARARToQH8GoGE8dXQPJBjGM1rCrMeIA4TMwaqnUcyK
	6WFj8MyekME3OXny2GUrZ4VdbfXcipJWxrEnII1sIzQO1U21rJIkzGaV4IphqcuBxoiQUDkDoX8
	OkbCY
X-Gm-Gg: ASbGncsOH4zNJjLooByHiLkHcPvhC21/CDpJrKlICentCUgzQ17caNi+z5iNv8Yh+OB
	ZL48dI45f3kO42eMYAZuzZynUStvDosBQBbWeaMQe2LOYxt7VvfUMenggmqXUflzucenDRFERru
	Gi7JcGCtuIKWnMkX9ptmE9j+UEH1hpWSWeHd73i8UAXeptE0e4oYGLruqm1x6rFO4DEUKJOFlhc
	EYjJbRvOHuE/GmQKtjC3ujjb3zMst5jqSuDSgs9jO4CPa5VG5VtF35+VUE7JVkNiP/M1E+IN3OF
	ZdeCYEnRA0c1QxoIa8DvY/JjQDrSV4/ytvBoXl82vDzslZMdoQQg/tamrYPj8kXoR62hqW4fOyP
	5HFTxScNXS5t1d198L0A9A5jgEDe0gtvEW2VIl/DtzD7hPs9jESzxCEX0gkF5FTuJG1BdKKEj+L
	SAE27FeEJXg4MixnjmKwP1Mk8xQw==
X-Google-Smtp-Source: AGHT+IF6gNSwYnRgghPkpBkUYnXcSqhkM6QyqQFlgGWnDcCoQdXuPUj2PJbBzvCf/8jntLmS8eJ3+Q==
X-Received: by 2002:a05:6830:4873:b0:7c2:8937:5d2e with SMTP id 46e09a7af769-7c6fd7a7ffemr1540255a34.15.1762625669187;
        Sat, 08 Nov 2025 10:14:29 -0800 (PST)
Received: from localhost ([2a03:2880:12ff::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6f11323a0sm3249772a34.27.2025.11.08.10.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 10:14:28 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 1/5] io_uring/zcrx: count zcrx users
Date: Sat,  8 Nov 2025 10:14:19 -0800
Message-ID: <20251108181423.3518005-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251108181423.3518005-1-dw@davidwei.uk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

zcrx tries to detach ifq / terminate page pools when the io_uring ctx
owning it is being destroyed. There will be multiple io_uring instances
attached to it in the future, so add a separate counter to track the
users. Note, refs can't be reused for this purpose as it only used to
prevent zcrx and rings destruction, and also used by page pools to keep
it alive.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 7 +++++--
 io_uring/zcrx.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5f7a1b29842e..de4ba6e61130 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -482,6 +482,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
+	refcount_set(&ifq->user_refs, 1);
 	return ifq;
 }
 
@@ -742,8 +743,10 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		if (!ifq)
 			break;
 
-		io_close_queue(ifq);
-		io_zcrx_scrub(ifq);
+		if (refcount_dec_and_test(&ifq->user_refs)) {
+			io_close_queue(ifq);
+			io_zcrx_scrub(ifq);
+		}
 		io_put_zcrx_ifq(ifq);
 	}
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index f29edc22c91f..32ab95b2cb81 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -55,6 +55,8 @@ struct io_zcrx_ifq {
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
 	refcount_t			refs;
+	/* counts userspace facing users like io_uring */
+	refcount_t			user_refs;
 
 	/*
 	 * Page pool and net configuration lock, can be taken deeper in the
-- 
2.47.3


