Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7F31DF07B
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgEVUXY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731045AbgEVUXX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFECC08C5C2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q9so5461790pjm.2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E5DEkxIJkQWsUJs0qbxunHfP/DfTSgAGYfxGVJ+umf8=;
        b=M62vZgt7Z81D/uiR+GCOQQB3NqfNockOsJ/6frjYkhnWPNPJJZTcIPvOcq1e+OIlDL
         A7Uaby6+5+yzzVPToxB0CyZzT5Jw1ob2YGIEZqHXjXgKhQGh5U1q8a2A9pPN0Cj5rGty
         y3qU1pliP06kZl8w8cUT7dvfF3ahpHIQJ7dNrjzqotZO6ri1R9SVfzOckoAebjqf/Twx
         j91VjdHpplZRnRM3EsEkFM0HXA1ovT2U9jd3h2He485CnEKSF5f+kF6cuKM/q9U1z8MV
         UmuaS9qHJ8zAaJnmJl/2IfxSZvQnvGic/q3WR7JBZtt23tccTdCAAtq96+R89GOMjP2k
         aoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5DEkxIJkQWsUJs0qbxunHfP/DfTSgAGYfxGVJ+umf8=;
        b=ujLt97uy5HqGTZ/HO2BXUmROl2JbrPOX5kV/1mz3M6kLaneeEVyRz72ysMFEBOAbxT
         Bk0YcRtj12TdMQUr4Ja8QZBD2PDqXMTi6yVavjuZ8fpYhX9gF4jlmSMXBHyBauFk5hEQ
         elG4DV2EgSpjanGgURB7uIbohxWw2QUxXCE9tHAOeEvHtGtWhiycpdeedhBvny5g331v
         +NSyJkA6B1IFcNq1up6ypCdiselPms3/9cghHMNWjiOk85ShaLIdzER9UP194r0HPQwM
         QzfPvOidT9rcX/96v0BnGot5SExsE6Dex0reLXIiZ1SYOu5xUdJ4zoOSdeoj6wyRLsdQ
         +GGA==
X-Gm-Message-State: AOAM532L8orJQOWvSo3uwrylVP9mBJqJt3QQNCFGNUbkYkPaHgz82fwt
        SQqYMARApKKM+YLcOtjwg+QC8MM6dCk=
X-Google-Smtp-Source: ABdhPJxj+N3pVChoXFbbBEseusfqTToenJpOK897u7XCplyacE6niX5gkU9YVqdofi7hj7Jnx22hMA==
X-Received: by 2002:a17:90a:4809:: with SMTP id a9mr6555363pjh.196.1590179002017;
        Fri, 22 May 2020 13:23:22 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/11] mm: add support for async page locking
Date:   Fri, 22 May 2020 14:23:03 -0600
Message-Id: <20200522202311.10959-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
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
 include/linux/pagemap.h | 22 +++++++++++++++++++++
 mm/filemap.c            | 44 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 61 insertions(+), 7 deletions(-)

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
index a8f7bd8ea1c6..39af9f890866 100644
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
@@ -494,6 +507,15 @@ static inline int lock_page_killable(struct page *page)
 	return 0;
 }
 
+static inline int lock_page_async(struct page *page,
+				  struct wait_page_async *wait)
+{
+	int ret;
+	if (!trylock_page(page))
+		ret = __lock_page_async(page, wait);
+	return ret;
+}
+
 /*
  * lock_page_or_retry - Lock the page, unless this would block and the
  * caller indicated that it can handle a retry.
diff --git a/mm/filemap.c b/mm/filemap.c
index 80747f1377d5..0bc77f431bea 100644
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
@@ -1210,6 +1203,38 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
 }
 EXPORT_SYMBOL(wait_on_page_bit_killable);
 
+static int __wait_on_page_locked_async(struct page *page,
+				       struct wait_page_async *wait)
+{
+	struct wait_queue_head *q = page_waitqueue(page);
+	int ret = 0;
+
+	wait->key.page = page;
+	wait->key.bit_nr = PG_locked;
+
+	spin_lock_irq(&q->lock);
+	if (PageLocked(page)) {
+		__add_wait_queue_entry_tail(q, &wait->wait);
+		SetPageWaiters(page);
+		ret = -EIOCBQUEUED;
+	}
+	spin_unlock_irq(&q->lock);
+	return ret;
+}
+
+static int wait_on_page_locked_async(struct page *page,
+				     struct wait_page_async *wait)
+{
+	int ret;
+	if (!PageLocked(page))
+		return 0;
+	ret = __wait_on_page_locked_async(compound_head(page), wait);
+	if (ret == -EIOCBQUEUED && !PageLocked(page))
+		ret = 0;
+	return ret;
+}
+
+
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -1372,6 +1397,11 @@ int __lock_page_killable(struct page *__page)
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
+int __lock_page_async(struct page *page, struct wait_page_async *wait)
+{
+	return wait_on_page_locked_async(page, wait);
+}
+
 /*
  * Return values:
  * 1 - page is locked; mmap_sem is still held.
-- 
2.26.2

