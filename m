Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516721DF0D5
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgEVU5Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731023AbgEVU5Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:57:24 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECD9C061A0E
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:57:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so5710331pfn.11
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h1P/xo8AaX3jjKt86a2Y3pBxxtNUWegSfV+Hhuz+jdk=;
        b=0fvIuQQnbJWtjugF4UCX5gQtYykfEWNXVl847bXb9v5zQ1p4X2EGBrdtM+o2A0LEgN
         YLRaBUdaLUa50GjkG1ZBMnZx8/PIQvIcTc1ixjjj/oGm33TgnTSoaOATtQvITIlNMQp1
         I7cYEFSv4tnXPrK9EMG++P+uqEo4VSe1Q6hJ7/pbC2za2nD7fZtAp7ta+mROxdBF/DPP
         bBJQocZli2Z4TtzB7/DnGQ7U6MJ5T+HfG4K5R9v1ARgstiV80JaqqKCUbyB6wcL0hA1r
         K0OWaeNCwLQ0bLl1ENxDGo3twoYkeVra4noiBRdWQRvlLvht3xy6sDbAaAfgvsNtNJI3
         8ZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h1P/xo8AaX3jjKt86a2Y3pBxxtNUWegSfV+Hhuz+jdk=;
        b=HdGVJj17MVwW/KKktqoCIOaaEwfMRLWUSp9AFzClKWY00dDWpQPfkmd2X+o9YNcay2
         uFebOtVQcorWZEdczWpG7hem7vdItvaqfqZTkQHj+Puk8REct3sy9CvNCPrsHNwsxVRs
         YrhEdmPdlZYsPNGVMCjt5kwjo4ZVulhJGF/gKyQrgF0T1FCqUXQbU8pVxglmx99wEStO
         JbZRKoYgXouO8MCB/TlECKrO620Whg50xQBfk4aNKU/8QvHsgPRjKbKcv+c6DY3oouIB
         sQPFH1ADUO1NUSEg90Dnl1o34cOSIb9NjCMkWIaa8D9IjF5OiZuE1HL77mu389pNSjlM
         tYzA==
X-Gm-Message-State: AOAM532bmLsMgWJ6tlHpwIjP5TUbuLsp4PFsXMogkJSR3Oo/L+7uCla0
        PGGjQxmAP8ljoitbWkxMPSceEA==
X-Google-Smtp-Source: ABdhPJwqZOezu8aVuOxmNjbD2ILSdyDll2DILbLtdsTm9YD/gHE6euUwuS3QA3EPTkgeG8sgNaq/rg==
X-Received: by 2002:aa7:9532:: with SMTP id c18mr5642306pfp.255.1590181042363;
        Fri, 22 May 2020 13:57:22 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:e0db:da55:b0a4:601? ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id n205sm7738080pfd.50.2020.05.22.13.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 13:57:21 -0700 (PDT)
Subject: [PATCH v2 03/11] mm: add support for async page locking
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200522202311.10959-1-axboe@kernel.dk>
 <20200522202311.10959-4-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43ad2c54-1e42-35ed-26be-6535cb0541b6@kernel.dk>
Date:   Fri, 22 May 2020 14:57:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522202311.10959-4-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/20 2:23 PM, Jens Axboe wrote:
> Normally waiting for a page to become unlocked, or locking the page,
> requires waiting for IO to complete. Add support for lock_page_async()
> and wait_on_page_locked_async(), which are callback based instead. This
> allows a caller to get notified when a page becomes unlocked, rather
> than wait for it.
> 
> We use the iocb->private field to pass in this necessary data for this
> to happen. struct wait_page_key is made public, and we define struct
> wait_page_async as the interface between the caller and the core.

I did some reshuffling of this patch before sending it out, and
I ended up sending a previous version. Please look at this one instead.

commit d8f0a0bfc4a0742cb461287561b956bc56e90976
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri May 22 09:12:09 2020 -0600

    mm: add support for async page locking
    
    Normally waiting for a page to become unlocked, or locking the page,
    requires waiting for IO to complete. Add support for lock_page_async()
    and wait_on_page_locked_async(), which are callback based instead. This
    allows a caller to get notified when a page becomes unlocked, rather
    than wait for it.
    
    We use the iocb->private field to pass in this necessary data for this
    to happen. struct wait_page_key is made public, and we define struct
    wait_page_async as the interface between the caller and the core.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

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
index 80747f1377d5..ebee7350ea3b 100644
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
@@ -1210,6 +1203,33 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
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
+	if (!PageLocked(page))
+		return 0;
+	return __wait_on_page_locked_async(compound_head(page), wait);
+}
+
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -1372,6 +1392,11 @@ int __lock_page_killable(struct page *__page)
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
Jens Axboe

