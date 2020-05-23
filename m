Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C3A1DF410
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbgEWBvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387551AbgEWBvE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:51:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0B8C08C5C4
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id a13so5119309pls.8
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L1+j2GDKy7H0PZDITKGHQ/OK2MPTBbiVlQTxtSNa/Ns=;
        b=z7HrSHy4DQ2KZLhor2+yKvhwKT3M5/avWRT8S5R2AJrrVQ/VvR19prxLmKkLZNkWzq
         pHUgk9D6XUmUkOewAT1qi3cXjH9XC3tQueuJoJCrrykyAZZ+GOo3XUCGFcpuqJUu77Cz
         qk5yHlSqkNewDc77Jj62TymY5U/UdV7bywroR1YBrukWND7+OAWlQLM4T/pruKlF8ECE
         ovOPYa9TZGG1f8t1lGBZ7YpIwfOtGCnVq9R2LgjgwzOVpCW9Vx8hYR07sVJrBcwLrhzj
         MPtjnH9yMF6hgSftEGBDEHfwTDDM2yWJWVxvIHOfr8e5Wc+D/P6S2Jyk9whuX1JG/BB8
         N9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1+j2GDKy7H0PZDITKGHQ/OK2MPTBbiVlQTxtSNa/Ns=;
        b=QkQ0r+0k6fJC0jDeogJuQGltP0aXMFe8R6szN4dmZtBqzG6uio8JtRnqwk2T+YEHqr
         xSXk92oKL5yNdv7ZKhwcaKXQkASZVYsNU8o1QdFVt8IEM69bJxuCgheQoZtqDXSJ7hCj
         INaofj3xHrNAnB1vacjf292jBKLpBZb6qsVgtoXodglKTndrJRB6NFKc/jmA9Gaij/+v
         76B3LHEXpypJD3j3Am6kTDEnteZ8pdh1EkFD7ka2XSkyCJaaD4E6lvuoRLErKzqVxXC4
         OXzcEqD6BZDMKwVNRBcE8qsGlAXV3xAAbHgbIVCWrvNE29kvBKDZkaWIEvIv8gBQNksr
         z3qg==
X-Gm-Message-State: AOAM530tFyoyHbTZuHffGtSjVmjcWl8b505YOiGqg+XY3faTuA+b3MzM
        eeWErYBrVj88wBuLelFc8NzrPtKKI48=
X-Google-Smtp-Source: ABdhPJw9gKQXC8DtehX4lEQgYciMv55f8G+1qS4JkrtGXjBLDVm3iWFTcJNG1joBJBOAhIVEQbPUvQ==
X-Received: by 2002:a17:90a:268f:: with SMTP id m15mr8317135pje.190.1590198662520;
        Fri, 22 May 2020 18:51:02 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:51:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] mm: support async buffered reads in generic_file_buffered_read()
Date:   Fri, 22 May 2020 19:50:42 -0600
Message-Id: <20200523015049.14808-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523015049.14808-1-axboe@kernel.dk>
References: <20200523015049.14808-1-axboe@kernel.dk>
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
 mm/filemap.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a01daafd49fd..b49836ff0fdc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2086,17 +2086,25 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
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
+								iocb->private);
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
@@ -2184,7 +2192,10 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		error = lock_page_killable(page);
+		if (iocb->ki_flags & IOCB_WAITQ)
+			error = lock_page_async(page, iocb->private);
+		else
+			error = lock_page_killable(page);
 		if (unlikely(error))
 			goto readpage_error;
 
-- 
2.26.2

