Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89331E0228
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbgEXTWW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388154AbgEXTWV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A970C08C5C5
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 145so7920817pfw.13
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ooHBrOZD/3Y3JOqiI+j5WGnGx9rNLKp4UPlTrA3k0fA=;
        b=OxFpYtFBwzHltasPWMU+lcpGv4rU/W2vOx/T4krzJTwDePkK92WnP8Q9D4KmLLpY6f
         Gd2powlWYp6amNjj/pqEmErKe4G4P2gbejJam6uJcPC941s8l3j4LkrKcWofDhf2REGi
         YTJZ81xesGaQk5qxaVPuAbcllAJUCMysF5nbqjuG4CmorTuNG9vIpk0d1uNk8acf8Rff
         1jlX4yGiljx2GdZ16Qma2k/cZGqRuC3kacJw2yDCzjvloXbodfZK/edA2Q6I/0OGROAn
         1nP5uZaH7v6Ns2RKRSS6SiYvJFi0QZwo9hTw2Aqe4//xgAmUbZgp7F+hMebtqROV82zc
         2Wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ooHBrOZD/3Y3JOqiI+j5WGnGx9rNLKp4UPlTrA3k0fA=;
        b=Hi9WjJUM9cdOGOKDZweAwCW+HO3WTHmzU2dIlQBWnb7nFbA/UCbSM/t89cCM6fF5cf
         GGQ216UQQTpTe/XpSO0tlgXU/Vn0YKScNwq2Q4KlPTt3tfCWusBCjEmy5Esf6Kixl7kX
         lNl+Ze/+PFM5y3aeF9lwGx+G2+whull/HOLCqzNyvvd5nJg92xbRclGhNlCLOnmdR4pY
         4Sy3gkezRKh4vKjibKrfk5CiBNY1mGN9KboSX0JnRmvtIVJQHhMi8t2NNQl2+7o4Khvs
         WaTnEyDfXEEdOzCLjPp6rwC+grKXgQm74DqaitN4JEv0zzGXa2Bnpo5UoF+5dPUj3AY0
         oyiA==
X-Gm-Message-State: AOAM532ZQA+a4Odojd8jXYzirSsltA5ae0GVKfBvmyKigZnN+/R8sMJJ
        bLe4uaRyrA2n4owyJFEvDs9HJ9VL1yyYEw==
X-Google-Smtp-Source: ABdhPJwRpkNyoDLEGaBTPeF9s7BrdfA7F20JjdHpfn1NdnYqPnUj6c2W2tKIFVS9+VwQSQs0Ka0myQ==
X-Received: by 2002:a63:381c:: with SMTP id f28mr22576826pga.361.1590348139455;
        Sun, 24 May 2020 12:22:19 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/12] mm: support async buffered reads in generic_file_buffered_read()
Date:   Sun, 24 May 2020 13:21:59 -0600
Message-Id: <20200524192206.4093-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
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

