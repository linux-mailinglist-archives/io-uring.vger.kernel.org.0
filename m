Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2E1E2F55
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389243AbgEZTvf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390301AbgEZTve (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5525AC03E96E
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l73so276623pjb.1
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ooHBrOZD/3Y3JOqiI+j5WGnGx9rNLKp4UPlTrA3k0fA=;
        b=bmGfUVJWYu6f/+lClc0yvwBvsEefc8SiuJxE38gUHmvCG67ZCMQ1ZoFC93WjnhwWQ4
         yZg7fQlvm/Sucx7ncKy3qvV98rMGm86zWQnvA8hq14lOsPQmzOry1k+ft5gveL4FUJQL
         gaUBcnu8T8B55uU9BUZgRqOrmN0p82G3CTFOtVxJUrhxYK5Gn/8JEk4HKkHRhEAIvpxF
         8iJj/6xBx4Ipgxa4B/+4ClHWKS0rVZdsYpFYzgcgIZxh9GvRIk8QENgpCADWhtcWb7U6
         btJvYpMYxIv2afcSGCvbCXlq8oQ8SvKxQmlD9hcdrFZzniK3vSqmkl4k4ZoCvIJr0Avu
         Vabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ooHBrOZD/3Y3JOqiI+j5WGnGx9rNLKp4UPlTrA3k0fA=;
        b=lgQCPrdkZ4sMQXKeo9x2WrH4aqZCiKPMSnq1CJYZsPrLIYbHsUhboAzwU6ZlGJvocf
         S/I3IuBL76MBdTgk+3VJjZIx8rlKsgd4dkpLsBk+NNWLua733T8CQsCINScBUbuLdoc5
         GFiisQ2e0k4/uviJp2sE9Y+bq/YP5UU4pgBfGKzK4sIhEztKfd/4iR+kDnSAt/kNbDAE
         Erh7fXfOfTEv/g3MsQH/NR1OiRh/nV12YRaPB/5cm/GdlqARRLp3Vrj1DX2j/KXqW5Vu
         ZuypVfS//2+29Dz8uvzTw99TzKGrAfuNQ8ai5hKYdf73pbQjw5ySMwCnYO18Q5nyY9Qh
         Isrw==
X-Gm-Message-State: AOAM531yZlNgtQiw2YiwAquQk2CaUTnXSvJiU+SMeA5edArs6JttFADj
        gqAIrC5NaMGC8/CqpdrlBpZl9Mn2/ggijQ==
X-Google-Smtp-Source: ABdhPJwGQ4LouRwKTJPsAC18WrHUCMfjZtLRZJD5qeryOylS8TBNaNMGloP6eX183Bgo+/GUML+3Rg==
X-Received: by 2002:a17:902:b110:: with SMTP id q16mr1318137plr.221.1590522693552;
        Tue, 26 May 2020 12:51:33 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/12] mm: support async buffered reads in generic_file_buffered_read()
Date:   Tue, 26 May 2020 13:51:16 -0600
Message-Id: <20200526195123.29053-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use the async page locking infrastructure, if IOCB_WAITQ is set in the
passed in iocb. The caller must expect an -EIOCBQUEUED return value,
which means that IO is started but not done yet. This is similar to how
O_DIRECT signals the same operation. Once the callback is received by
the caller for IO completion, the caller must retry the operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/filemap.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c746541b1d49..18022de7dc33 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1219,6 +1219,14 @@ static int __wait_on_page_locked_async(struct page *page,
 	return ret;
 }
 
+static int wait_on_page_locked_async(struct page *page,
+				     struct wait_page_queue *wait)
+{
+	if (!PageLocked(page))
+		return 0;
+	return __wait_on_page_locked_async(compound_head(page), wait, false);
+}
+
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -2058,17 +2066,25 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 					index, last_index - index);
 		}
 		if (!PageUptodate(page)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
-				put_page(page);
-				goto would_block;
-			}
-
 			/*
 			 * See comment in do_read_cache_page on why
 			 * wait_on_page_locked is used to avoid unnecessarily
 			 * serialisations and why it's safe.
 			 */
-			error = wait_on_page_locked_killable(page);
+			if (iocb->ki_flags & IOCB_WAITQ) {
+				if (written) {
+					put_page(page);
+					goto out;
+				}
+				error = wait_on_page_locked_async(page,
+								iocb->ki_waitq);
+			} else {
+				if (iocb->ki_flags & IOCB_NOWAIT) {
+					put_page(page);
+					goto would_block;
+				}
+				error = wait_on_page_locked_killable(page);
+			}
 			if (unlikely(error))
 				goto readpage_error;
 			if (PageUptodate(page))
@@ -2156,7 +2172,10 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		error = lock_page_killable(page);
+		if (iocb->ki_flags & IOCB_WAITQ)
+			error = lock_page_async(page, iocb->ki_waitq);
+		else
+			error = lock_page_killable(page);
 		if (unlikely(error))
 			goto readpage_error;
 
-- 
2.26.2

