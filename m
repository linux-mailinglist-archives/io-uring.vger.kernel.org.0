Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83CD1E0211
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388158AbgEXTWV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388133AbgEXTWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E167DC08C5C2
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z26so7931051pfk.12
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dRxVLULuo23vPsgtEWsGYGFpCYUxsZhIaT6u42Hql2E=;
        b=V4mIXVQFyA2xlU324aezgz7hoH5/kwrcukrZDA1MEw3qMNYi6vXFPLbiXDJ35lEn1M
         cz+I3E0aSOYnWOWKnM05PwTsEls9yrhFa1tZ/Oyxfddc2RtB03mcUSpferTg5lavJIqJ
         Dj5UTA49dxBRYaCq/zzgZHSotdJgYJMe4YTpXOUfPwjxszbv2+Rj3Diq6hu6rCdGQgeR
         jCdV/0Q2QAhgKJmNRqUY3HFNQUHsB+4Yt2ZVj5amRvJ7o3JkwGLTixFLXi1j/pnfGltP
         8shg/8s9ZL/+mu2rqdj8zLMzh+R2KH1VtFdrw+ufEj28wz2kyOkdQqQeGPprP02KtqDR
         DvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRxVLULuo23vPsgtEWsGYGFpCYUxsZhIaT6u42Hql2E=;
        b=ORurMIlgEyDXOJT2U11BZsPzOURBVzfaixe0fiJnWMFmb1wx+dEon2o+6jm1UIaTDg
         840hhAqH13mqsBG1A2AfpJDFAcTkpzW7gG3+/Qcq9oqlfy4jaAWXxqIyaj30SoYWphUA
         h/z9AwwkBbrb0sXdNRBzuS1KFoHvuzULXZOPOVJqxOAyeR15ibpcKKqw2UUs4aBJzRXb
         BpAYBs7t22K18XrqIqsiEitRMNUs++SBG0ylL1fUU0YO1TKv1eWr3jl5adf1sEsHESfH
         goSxX/lHe+Jq09V4mGCMvbjZSreFJtSqSwq0klguQjQGY3EqwxLOmEtaeD3Mpecand/X
         lDFw==
X-Gm-Message-State: AOAM530uOM/+cFrIo4jLUp0/UoE7tbmO8Im0SmKN3ii2/St8N/8UHdqz
        FMtBDMk3EinYVndBwcZ1TL0NejCnmtT5VA==
X-Google-Smtp-Source: ABdhPJxHDlFcrCLi5owVvTlCdr8UZ55c4LZkRSpCvAXkOESdBdFKXVcEhLCnvkoAqx+qXu+nn3WEWg==
X-Received: by 2002:a63:712:: with SMTP id 18mr22778908pgh.96.1590348138120;
        Sun, 24 May 2020 12:22:18 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/12] mm: add support for async page locking
Date:   Sun, 24 May 2020 13:21:58 -0600
Message-Id: <20200524192206.4093-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
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
 include/linux/fs.h      |  7 ++++++-
 include/linux/pagemap.h |  9 +++++++++
 mm/filemap.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e84d823c6a8..5a5434ff7543 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -314,6 +314,8 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+/* iocb->ki_waitq is valid */
+#define IOCB_WAITQ		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -327,7 +329,10 @@ struct kiocb {
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

