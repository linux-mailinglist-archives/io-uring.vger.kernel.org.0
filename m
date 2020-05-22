Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6212E1DF07D
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgEVUX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731046AbgEVUXZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A69C08C5C2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q9so5461817pjm.2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pk0mOQuIM8W3goGTEUJ7lPQkF+2EvbiQPRxtP96y/VQ=;
        b=XR1Hfpngk92X60W6mtjRxmwWQjUpXxr57sMRlRMp6WKXl0EGRM1SyAOYAgYY/8k15p
         InaZ+j7vcNDYMPyNeT3pDlSC7+7MpYvudX2nOoV8UHce1YTszpzP9mKmUYM9+1SSZXq5
         luaLISz3wcOf7+VgrtBaX5me2bW3GJ2GmAjc5UYbYKCQVBBAfA0DmjLo7fD31fEdUXGr
         jHzVrF/TM6JPGmvwNE0mpRc+1IJz9vT6u7Y4z3e0+t6sID85Socj7145P1lc8My6fsi2
         kejNXdw85Mje1pDKxQKcH2qKiA+KYZmlq8rNRp4E3T8t8Bj9P56S+c++YndQX8+ING/I
         WFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pk0mOQuIM8W3goGTEUJ7lPQkF+2EvbiQPRxtP96y/VQ=;
        b=lq0qFS83IyoZx9G+JeGjVqxoRvSfx/AJgcUSZSnduX8GxgC0GBG/+6TD7bnYFVpuVT
         k/f/3qK2sm8+h+za9EnUHdzc8Wjj+Gsar+Mn8ZrKGOUXEq4e1LSkgGQI4IohBXIBTsnA
         qAcEqPoaopAaoW0Co/uLVrCh4shqV1mGPS++UIiaxBEjP97/6sQ6++GxZ7cw6Vkcd6IK
         AMRDktCEs0BsaQItpy6RUvbbl0uCmGtvW3YvWvz7W7IRhVFA2NbmABKJf7JxKI7R8Dpj
         2tikflsravV8KJrZKJhBbgQyIFJqwCC4MKeWbUG5wcfBLJYxvBo8gkPgBKJOM1rUaUyA
         rCew==
X-Gm-Message-State: AOAM532mI233mcdK7BBvVzVQIMBRrwTVfATtPS40qKfLT70aXZwVs2sa
        clpi21YvuEpcbbG8AnhqnkqMc0VLwYg=
X-Google-Smtp-Source: ABdhPJwS7xFlgv35cRDBhVL35NxCpOL//x8P0nJbD9YCPQRRanDgUxHWeCBsTZZ0WIpa+r85qBpFhw==
X-Received: by 2002:a17:90a:c594:: with SMTP id l20mr6422753pjt.123.1590179003224;
        Fri, 22 May 2020 13:23:23 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] mm: support async buffered reads in generic_file_buffered_read()
Date:   Fri, 22 May 2020 14:23:04 -0600
Message-Id: <20200522202311.10959-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
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
index 0bc77f431bea..d9d65c74b2f0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2074,17 +2074,25 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
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
@@ -2172,7 +2180,10 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
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

