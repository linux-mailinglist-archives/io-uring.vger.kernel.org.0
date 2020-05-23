Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDAB1DFA6B
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgEWS6I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbgEWS6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980A8C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:06 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w20so1561467pga.6
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QLIKOC51UDi6y8ydZtCT2FsP1dt+ucWxar6wAIDn3TQ=;
        b=MWKaekWvtx+WTMH7SA8TxEwVGEMQRZ6Y3Djw7RNC7oEYUCXetIPXBjtiJgnyF71Y0b
         UMa3s3nv9VNBNz/E5zE58K6odN5gP1YpWtoRtR26Jtt0hxzlYhRsfCdDXvyf1atMh5bs
         o3zeYxTrMI80Xwj9+WtyiI7NO1qDg3KQpO4qdC3SwkxvfVqMOsKdB1CW997onc1jjj0s
         glvIv02sptmvS0nrlsCIZFZqjJuVPnwA32f5p/IDDJg82jymdpaM0DYrJhhfbQg3g/lN
         7krBmUvtb5GR2kiVrgRdtyjFenuM4+KBhSnVAZc+Y4QeRkSFLNE8OUmPmx2atAUI+eH/
         IZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLIKOC51UDi6y8ydZtCT2FsP1dt+ucWxar6wAIDn3TQ=;
        b=piAxWaE7pNHVZa5AJT4hsG+Ld5ekrofwrMWWrHLxuNZB3DTclAwSzxAwVHf1EOyyXP
         jMszvK6qL5SE5jqb4hR+WFOEPsSZJ7Dv1xSuizBnEKaoiP8vt5DWHUCEUMev+aqGnMz7
         isip2E92MfEaDXDFQDgV3MyrGFZ02Ok/xRh9VSCsLafDDrvIKB8aLMMFA9F0F0cf/l83
         LPE0WIMzRAdZGaozavXBysH94L1Mh8mfSsEmJY0pSd2UcHDUwJQdxtHT62vScuWxZI4T
         lScQ5TGHQVD0WSKgMIVUoCcQ2bK30idxrlslBgULNBh6wweMI0zPMmgtRj12MxQs2od5
         Q5cA==
X-Gm-Message-State: AOAM530B98hOiYO1JMGY4+oVisozpe9uMsSGkDfMuZltI+JkXDtp/424
        C2peqH7YGHPDAZ4a6H5MJ9+TXxJ2PtCiGg==
X-Google-Smtp-Source: ABdhPJxlGEJfDdI/CHMnwiSfxbLnvzCi9W829t09wDrbokAThLoEnwexsOcrvdVDPXc3WyV+F2HO2Q==
X-Received: by 2002:a65:66d5:: with SMTP id c21mr18973961pgw.155.1590260285870;
        Sat, 23 May 2020 11:58:05 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/12] mm: support async buffered reads in generic_file_buffered_read()
Date:   Sat, 23 May 2020 12:57:48 -0600
Message-Id: <20200523185755.8494-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
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
index c746541b1d49..a3b86c9acdc8 100644
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
@@ -2156,7 +2172,10 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
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

