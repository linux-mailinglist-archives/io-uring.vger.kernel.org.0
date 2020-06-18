Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F29B1FF538
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbgFROpn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730962AbgFROoK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB535C06179B
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s23so2879589pfh.7
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=ugefse5kKTqXQ4eIaIDMHVyZsS3OmAuYWslFQFrKGAg=;
        b=nPiXsRi6BRt5JXEn23LLT0VlfowWc9FFrkRNPpQKyLz9yJSlB/8/wAL82qAGNedSkF
         cFv9Mr/dmOS/jD0ExP7JdeFsVG0cpLkPOn+Mv46eMO76ZpXYm8G+eaVtyJaSY5qfTAid
         FGe99XxOvLrha9M1k68N9nt6NIVNYnuM6FbUXYkyHG4WXFzvEDR8h5yR+ORXQIzt6rOY
         nlAC2fElI7Ax5Ja40mz8CQ3+pneQvvbUW7ssoIRcg++V8szsXNlw7tYb2iFTM3zhNZ0R
         BV6S7vWTAo03tso3K4liAsMATX93QS+pb1jxyiHuCxXSSpR0IvQ9l4/kjEcYZ79DaA9F
         dzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=ugefse5kKTqXQ4eIaIDMHVyZsS3OmAuYWslFQFrKGAg=;
        b=QufLTvZCsrbGOfLI9RhEJ5Oeoa1y69LdZZBwrKhBywmNxGQHaC8hEvCYOC/vLsZc4M
         ZMfUiACeh0b8nFYmcYp5orJU2+9a75TNzZchTzlLcVrwRp6aOHFniEtOSBDQhxKHL60H
         Bs2KhCTpqwVrMcDRcp7qAMiUKXX0XYx3h/HbK/oNVZU1P2ZrtLPXaIzi7oYjR1/EhGXo
         8Pn4GFPScnJLUXE78auJAxftxthvCuHS7I7B6vMIn4GP3C2oLLZNy6aQL26KyqTs5SWz
         eG+XwBr7URlNbs6GWthUtE74+CS3Loo19LcDZcP1Ob611lggcycEyudsNlme0ryGWz9P
         Swiw==
X-Gm-Message-State: AOAM533U8WeLm+UiF1XCxfOFquXmW8IY4tQe+bQawPIFfdzRBs1WCIRQ
        KKChFOJzDP9x/dgguyX+mZdFmrre7+c1eQ==
X-Google-Smtp-Source: ABdhPJzwVrGYYhzPh7B/cl4K86rqVhqHG34HLw3paGpNlY/2JChA4DR4YVjWC/vOkk6B5Jf1Y+/RRQ==
X-Received: by 2002:a63:d858:: with SMTP id k24mr3368619pgj.288.1592491448987;
        Thu, 18 Jun 2020 07:44:08 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:44:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 07/15] mm: add support for async page locking
Date:   Thu, 18 Jun 2020 08:43:47 -0600
Message-Id: <20200618144355.17324-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618144355.17324-1-axboe@kernel.dk>
References: <20200618144355.17324-1-axboe@kernel.dk>
Reply-To: "[PATCHSET v7 0/15]"@vger.kernel.org, Add@vger.kernel.org,
          support@vger.kernel.org, for@vger.kernel.org,
          async@vger.kernel.org, buffered@vger.kernel.org,
          reads@vger.kernel.org
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

We add a new iocb field, ki_waitq, to pass in the necessary data for this
to happen. We can unionize this with ki_cookie, since that is only used
for polled IO. Polled IO can never co-exist with async callbacks, as it is
(by definition) polled completions. struct wait_page_key is made public,
and we define struct wait_page_async as the interface between the caller
and the core.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h      |  7 ++++++-
 include/linux/pagemap.h | 17 ++++++++++++++++
 mm/filemap.c            | 45 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6c4ab4dc1cd7..6ac919b40596 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -315,6 +315,8 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+/* iocb->ki_waitq is valid */
+#define IOCB_WAITQ		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -328,7 +330,10 @@ struct kiocb {
 	int			ki_flags;
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
-	unsigned int		ki_cookie; /* for ->iopoll */
+	union {
+		unsigned int		ki_cookie; /* for ->iopoll */
+		struct wait_page_queue	*ki_waitq; /* for async buffered IO */
+	};
 
 	randomized_struct_fields_end
 };
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2f18221bb5c8..e053e1d9a4d7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -535,6 +535,7 @@ static inline int wake_page_match(struct wait_page_queue *wait_page,
 
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
+extern int __lock_page_async(struct page *page, struct wait_page_queue *wait);
 extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 				unsigned int flags);
 extern void unlock_page(struct page *page);
@@ -571,6 +572,22 @@ static inline int lock_page_killable(struct page *page)
 	return 0;
 }
 
+/*
+ * lock_page_async - Lock the page, unless this would block. If the page
+ * is already locked, then queue a callback when the page becomes unlocked.
+ * This callback can then retry the operation.
+ *
+ * Returns 0 if the page is locked successfully, or -EIOCBQUEUED if the page
+ * was already locked and the callback defined in 'wait' was queued.
+ */
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
index c3175dbd8fba..e8aaf43bee9f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1180,6 +1180,36 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
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
+	__add_wait_queue_entry_tail(q, &wait->wait);
+	SetPageWaiters(page);
+	if (set)
+		ret = !trylock_page(page);
+	else
+		ret = PageLocked(page);
+	/*
+	 * If we were succesful now, we know we're still on the
+	 * waitqueue as we're still under the lock. This means it's
+	 * safe to remove and return success, we know the callback
+	 * isn't going to trigger.
+	 */
+	if (!ret)
+		__remove_wait_queue(q, &wait->wait);
+	else
+		ret = -EIOCBQUEUED;
+	spin_unlock_irq(&q->lock);
+	return ret;
+}
+
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -1342,6 +1372,11 @@ int __lock_page_killable(struct page *__page)
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
+int __lock_page_async(struct page *page, struct wait_page_queue *wait)
+{
+	return __wait_on_page_locked_async(page, wait, true);
+}
+
 /*
  * Return values:
  * 1 - page is locked; mmap_lock is still held.
@@ -2131,6 +2166,11 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 		}
 
 readpage:
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			unlock_page(page);
+			put_page(page);
+			goto would_block;
+		}
 		/*
 		 * A previous I/O error may have been due to temporary
 		 * failures, eg. multipath errors.
@@ -2150,7 +2190,10 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 		}
 
 		if (!PageUptodate(page)) {
-			error = lock_page_killable(page);
+			if (iocb->ki_flags & IOCB_WAITQ)
+				error = lock_page_async(page, iocb->ki_waitq);
+			else
+				error = lock_page_killable(page);
 			if (unlikely(error))
 				goto readpage_error;
 			if (!PageUptodate(page)) {
-- 
2.27.0

