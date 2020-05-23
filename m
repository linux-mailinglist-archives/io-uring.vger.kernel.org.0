Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D877D1DF3F5
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387540AbgEWBvG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387549AbgEWBvD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:51:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F5FC08C5C2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n15so6027483pfd.0
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NV7E3PVOJV+DrSVqvM0fq14D8mCjxQwXXmJVa/Gbb/M=;
        b=1BEPA92fmudyakxYMuwGsAvSGUef6CrxjH6Bj+rHr3hQcssDmsjZAxSXEVeNVW9Fty
         PWUD3QdpmKM5iq0HszoeTfCMA01j05FWDCTJT+ql9n1VlCQnHzNc7Q6nQ/xQMa5CgxA8
         mLv9i7KCHFCMyHnP8zgt66OnVYNBM1bbbWcJE1a6sciQhVGnb+1bBlJVuo3ShpMWDDhg
         z4zjxYZHveqzePLvtpxYt1Dj5N86tvWAwk+TazmMENq06Oglw+kgGhErg95vm+UQlG6I
         GYRk0xuLoOgcAaXEaWbnkZXRAwHsMDP/0Qe86Y2fHE4GApP4c/yBIfM/NLTY5rx+tiCz
         9tvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NV7E3PVOJV+DrSVqvM0fq14D8mCjxQwXXmJVa/Gbb/M=;
        b=Ve9c8kjFFCx7paCeCf+oX5Ih0+TIo6QkRa1EAkOrXnOYCBNlFvYrE1P9QxwYQb8xgv
         CyY8sJLGoDJQYDe47qZLl/2sEbLU19Aqs9bchsEPLT5PNgQM15EnNbALuufZdfh5aFGW
         6+mSPLr7pZe5hxfBhPzCMLRknCAETRMYrO0Mf4c9DyfwG0rMvSLA9AXKSVi9lnohA4f5
         Oli54vGPw3pBKoZwY/uL152aXDDLfdEoLfY6AazKs/JyOjbgj5zJ2igY37ygysEpgl6V
         hxIzLy8eBl6xyOU3J9ixgVR0yvHSg5nYqdbS+ngN2wUhuvA+q+xdxaGpivY/Cb29JTcX
         vISQ==
X-Gm-Message-State: AOAM530qjZ4X1JhAs2L1zQP89ZdyFyDj87u6RYDBgyD49Ia4WJsUj96F
        jc3/PGPt7XnkFR9t2HEfjtDo00+gQag=
X-Google-Smtp-Source: ABdhPJy3zSBLoF6AYULdnKhsv41lX8Bgq50w4QoyGby7dLFXVxT8537akfk9NdlKdcMZ176gJtXwvQ==
X-Received: by 2002:a63:7d4e:: with SMTP id m14mr16808897pgn.391.1590198661379;
        Fri, 22 May 2020 18:51:01 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:51:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/11] mm: add support for async page locking
Date:   Fri, 22 May 2020 19:50:41 -0600
Message-Id: <20200523015049.14808-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523015049.14808-1-axboe@kernel.dk>
References: <20200523015049.14808-1-axboe@kernel.dk>
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
 include/linux/pagemap.h | 21 ++++++++++++++++
 mm/filemap.c            | 56 +++++++++++++++++++++++++++++++++++------
 3 files changed, 72 insertions(+), 7 deletions(-)

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
index a8f7bd8ea1c6..e260bcd071e4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -456,8 +456,21 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 	return pgoff;
 }
 
+/* This has the same layout as wait_bit_key - see fs/cachefiles/rdwr.c */
+struct wait_page_key {
+	struct page *page;
+	int bit_nr;
+	int page_match;
+};
+
+struct wait_page_async {
+	struct wait_queue_entry wait;
+	struct wait_page_key key;
+};
+
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
+extern int __lock_page_async(struct page *page, struct wait_page_async *wait);
 extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 				unsigned int flags);
 extern void unlock_page(struct page *page);
@@ -494,6 +507,14 @@ static inline int lock_page_killable(struct page *page)
 	return 0;
 }
 
+static inline int lock_page_async(struct page *page,
+				  struct wait_page_async *wait)
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
index 80747f1377d5..a01daafd49fd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -990,13 +990,6 @@ void __init pagecache_init(void)
 	page_writeback_init();
 }
 
-/* This has the same layout as wait_bit_key - see fs/cachefiles/rdwr.c */
-struct wait_page_key {
-	struct page *page;
-	int bit_nr;
-	int page_match;
-};
-
 struct wait_page_queue {
 	struct page *page;
 	int bit_nr;
@@ -1210,6 +1203,50 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
 }
 EXPORT_SYMBOL(wait_on_page_bit_killable);
 
+static int __wait_on_page_locked_async(struct page *page,
+				       struct wait_page_async *wait, bool set)
+{
+	struct wait_queue_head *q = page_waitqueue(page);
+	int ret = 0;
+
+	wait->key.page = page;
+	wait->key.bit_nr = PG_locked;
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
+static int wait_on_page_locked_async(struct page *page,
+				     struct wait_page_async *wait)
+{
+	if (!PageLocked(page))
+		return 0;
+	return __wait_on_page_locked_async(compound_head(page), wait, false);
+}
+
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -1372,6 +1409,11 @@ int __lock_page_killable(struct page *__page)
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
+int __lock_page_async(struct page *page, struct wait_page_async *wait)
+{
+	return __wait_on_page_locked_async(page, wait, true);
+}
+
 /*
  * Return values:
  * 1 - page is locked; mmap_sem is still held.
-- 
2.26.2

