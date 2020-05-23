Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813BD1DFA69
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgEWS6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387867AbgEWS6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A3C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:05 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so5754393plo.7
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hENt+q3Sn8CtA9tFAzdLO364i6JHcfhAdPtfDTKZjEw=;
        b=IoUb1h2vKy+f0dtwmFTBDbGpNkk2wMhwXrlubxdrni8AO8E3DlT5YodBAgH9Bo0lAb
         lW1WJtaBGZfKwnRBxn+qBzZenE2peUkQgkHh9d5nebmKYs9YNDiCd8dvOvjDpj5rbO/n
         s0s7FihoaBqMkq0rzhjJcs2EnEd0abWfbDYSs2ekcPcCYLeB3N4zFnamKz+cGsxj8eNn
         F1ChMVdkAafH9S53RqNorXpYaYMzFBN1kPsG+QlVPUMBDg9DTew082jQfzOc2ih2Qb/r
         3M+n7gPxJSlSImnvwlieeQzY2ObPa3uuVP6JcfMVBkARc9hJaWxZEAFois6e3Jy0h+Ct
         G8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hENt+q3Sn8CtA9tFAzdLO364i6JHcfhAdPtfDTKZjEw=;
        b=amVVSjgFF+pBwGkwmhALQTsnYKuakCIIQHuhehYZHmXM3FG3QJFDH6RkIahvAU0xjW
         Ui6MmQzKScfcV910EZbCkO2HwI6cdicPokbTKO9KhqQSp+TqbVPTrnx9RXdI3JduSzV4
         G1mSrcb2kzVRUnljUbAX+hHtaPKCrNE4ScQhE62BCYBQHrD9ybmfFZgpn/db+lEutSQz
         m2k+ICRgizpApLo256kRI9LOzHlqLbL053HD+a8mRINw5/31UcEKMVYXipk2JmU7py0k
         jIL6tJjTQmyuurWdqTouErtoxP1uYDbd44M7szbxyzck5gHB254UTceXrFl6UYNlMdxl
         BWkA==
X-Gm-Message-State: AOAM531SpuKG5V1fcLOHPZWyDGSCYlZCqyptkk1juPiFTML7Cx908Ml8
        bSYHAl1Z1cRVQnqXFF/Qp/tgcvlmkWA/kg==
X-Google-Smtp-Source: ABdhPJz0eo745gK+bLfHgAeIdJu+l6vnctKVtOYWF0tbpRSPS4ji6QlFp3fk/3FEBowyABl4PmcaOg==
X-Received: by 2002:a17:90b:1897:: with SMTP id mn23mr11837825pjb.84.1590260284702;
        Sat, 23 May 2020 11:58:04 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/12] mm: add support for async page locking
Date:   Sat, 23 May 2020 12:57:47 -0600
Message-Id: <20200523185755.8494-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Normally waiting for a page to become unlocked, or locking the page,
requires waiting for IO to complete. Add support for lock_page_async()
and wait_on_page_locked_async(), which are callback based instead. This
allows a caller to get notified when a page becomes unlocked, rather
than wait for it.

We use the iocb->private field to pass in this necessary data for this
to happen. struct wait_page_key is made public, and we define struct
wait_page_async as the interface between the caller and the core.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h      |  2 ++
 include/linux/pagemap.h |  9 +++++++++
 mm/filemap.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e84d823c6a8..82b989695ab9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -314,6 +314,8 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+/* iocb->private holds wait_page_async struct */
+#define IOCB_WAITQ		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 53d980f2208d..d3e63c9c61ae 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -495,6 +495,7 @@ static inline int wake_page_match(struct wait_page_queue *wait_page,
 
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
+extern int __lock_page_async(struct page *page, struct wait_page_queue *wait);
 extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 				unsigned int flags);
 extern void unlock_page(struct page *page);
@@ -531,6 +532,14 @@ static inline int lock_page_killable(struct page *page)
 	return 0;
 }
 
+static inline int lock_page_async(struct page *page,
+				  struct wait_page_queue *wait)
+{
+	if (!trylock_page(page))
+		return __lock_page_async(page, wait);
+	return 0;
+}
+
 /*
  * lock_page_or_retry - Lock the page, unless this would block and the
  * caller indicated that it can handle a retry.
diff --git a/mm/filemap.c b/mm/filemap.c
index e891b5bee8fd..c746541b1d49 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1183,6 +1183,42 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
 }
 EXPORT_SYMBOL(wait_on_page_bit_killable);
 
+static int __wait_on_page_locked_async(struct page *page,
+				       struct wait_page_queue *wait, bool set)
+{
+	struct wait_queue_head *q = page_waitqueue(page);
+	int ret = 0;
+
+	wait->page = page;
+	wait->bit_nr = PG_locked;
+
+	spin_lock_irq(&q->lock);
+	if (set)
+		ret = !trylock_page(page);
+	else
+		ret = PageLocked(page);
+	if (ret) {
+		__add_wait_queue_entry_tail(q, &wait->wait);
+		SetPageWaiters(page);
+		if (set)
+			ret = !trylock_page(page);
+		else
+			ret = PageLocked(page);
+		/*
+		 * If we were succesful now, we know we're still on the
+		 * waitqueue as we're still under the lock. This means it's
+		 * safe to remove and return success, we know the callback
+		 * isn't going to trigger.
+		 */
+		if (!ret)
+			__remove_wait_queue(q, &wait->wait);
+		else
+			ret = -EIOCBQUEUED;
+	}
+	spin_unlock_irq(&q->lock);
+	return ret;
+}
+
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -1345,6 +1381,11 @@ int __lock_page_killable(struct page *__page)
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
+int __lock_page_async(struct page *page, struct wait_page_queue *wait)
+{
+	return __wait_on_page_locked_async(page, wait, true);
+}
+
 /*
  * Return values:
  * 1 - page is locked; mmap_sem is still held.
-- 
2.26.2

