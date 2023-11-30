Return-Path: <io-uring+bounces-174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D807FFBBD
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0617EB20F26
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E06F5FEE6;
	Thu, 30 Nov 2023 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Otj0HMzD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A49DD6C
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:44 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7b38ff8a517so16096839f.1
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373603; x=1701978403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Eqt0miAnRu0iNO8NoAJMZVKKakVekPyJk+CuHmgmXM=;
        b=Otj0HMzD59nkOcFkalnjDuX8kiNjrlO4Oax1+AKJjUTNosJ5M8IAeX6ov3CrfwoXVc
         z0V5hiMDEBk0jaJ2BuNFiqLK6cAY8TejdxFpeR1H2MGcWoCwvagBo768W8ncnPre14jX
         sGA6PQFTOm55WOrmJesr4giw2WjOJnRP+WsFo9A1e45On4lDqOCELWapkjKG4qmUG91R
         V8jEJNPNAdQRopnAuu5UkE+p2H1k7X8c9GEYjWL7+1U3mNWjXNcHZKGOpI1/+PSaD8KH
         2I6/Zm96sk8/5L6eKOlAzEGsUdQkZiubW2c+Ef3Ef7KlPwLoJ4crQCncq1fZQvU0hFp8
         H1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373603; x=1701978403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Eqt0miAnRu0iNO8NoAJMZVKKakVekPyJk+CuHmgmXM=;
        b=ALqVaXBBXggo/J9uCYJRBEaThDFxz3WdZx5CAxxJ4JLDzIOxp6dfLyxK5NWKTA+fKn
         aGeyJU2MYKCoxlR+jLrgQ1gAonI55l8INbOsbQOh4OHpJvHeokQpkgohJX9NH8YZ/ChP
         G2ZZnL+jOaitvF1F/LEQhxcnOUJBxCePlVJyrqNI3WppE3I7/3bg5i9YHdG2SwgYOsEw
         VbeWNxcvNESn4GzKuQbLDnCKbEz88xBjfxJfDDvhfpbxa2bkGxNZiMCwNvE7lyGiDQge
         Uh/w++g5dGtWl64KQqQto0eJ+0KqiDYxn45Tu8el7f3HN1QHioqIVgRprMHtLSmsoaUx
         s2yA==
X-Gm-Message-State: AOJu0YzEiVLnrmFYUa1FaTYuV3IAV1y0ylNsYFjZO4vK1bPyAvs+mlAu
	txRbUae4H1zVzuPYbHvG0ZQiuLEKh5EqYBEO/pFjuw==
X-Google-Smtp-Source: AGHT+IGUTY4qbf+aOjTRd8OzjvlLIKHbF75D0ffWNDx+6r0irNKJVFSOO6uShhcFGcrikpV+VEe0gw==
X-Received: by 2002:a05:6602:2bd2:b0:7b3:e4a6:45d4 with SMTP id s18-20020a0566022bd200b007b3e4a645d4mr7544673iov.0.1701373603556;
        Thu, 30 Nov 2023 11:46:43 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring: enable io_mem_alloc/free to be used in other parts
Date: Thu, 30 Nov 2023 12:45:49 -0700
Message-ID: <20231130194633.649319-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using these helpers, make them non-static and add
them to our internal header.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/io_uring.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 52e4b14ad8aa..e40b11438210 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2666,7 +2666,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-static void io_mem_free(void *ptr)
+void io_mem_free(void *ptr)
 {
 	if (!ptr)
 		return;
@@ -2778,7 +2778,7 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	}
 }
 
-static void *io_mem_alloc(size_t size)
+void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
 	void *ret;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dc6d779b452b..ed84f2737b3a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -86,6 +86,9 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+void *io_mem_alloc(size_t size);
+void io_mem_free(void *ptr);
+
 #if defined(CONFIG_PROVE_LOCKING)
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
-- 
2.42.0


