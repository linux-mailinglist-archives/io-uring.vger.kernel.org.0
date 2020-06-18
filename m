Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB36F1FF540
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgFROqL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730955AbgFROoI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:08 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7425DC061795
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:08 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i4so2777829pjd.0
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=L8y2vzO4eFciFziI46a/ttSbeGYaIdwkqPPuYZk9V/Y=;
        b=YeULpx9IMVYlet06hXXtF3Dyovfb6OWV7znBhPslocYv61JEKGOzA86Uf7KlkwQUxA
         5veTkQm0U3FiHje/G2qBCvINtR+5H6+EjnG+6Sf5DBiwhwEgiK3ZySkgoWKeRlArsl6Z
         KII1sM40sgw0BBBEt/0RNUdVdIscLTYaAk11C3WKb8/EKEdqvKbfubfLIO/VBQ2Xx9WL
         CEYBtGHqlJYku+rfQdHayepPiSv6ME4oZxtjXE8I56CTLxFCqrzXuobRRnwbzTHobf+i
         uKAVIMjqM417ECasSBzSLduZSGdbDtTFAHLkWJ12coSXUTQ7pSi5y5D2Y4Jzync6tV9q
         xrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=L8y2vzO4eFciFziI46a/ttSbeGYaIdwkqPPuYZk9V/Y=;
        b=n82t1DMP9in5HARho0WMEcNhWDXKXJVDloMOmONf3Wv0CdpKqcxoi3HmghGxsOHS7P
         fzkoltXp29ZVORjsKnevBPgECBZDvNwYu3O4Dtul44D/Sb/1qJGrm6o319qFtBJZTqOM
         2+L+E9TYH9RmEVM/Exp2TWwC3QccFIwb0UI14n77xAUqqmVopPATa+HPnMIzHyk6JC4X
         fhivnUeu/8dX1QVPimVIY5Qa/EfG9uJa5D316qo0At+LJ0s+UioBJQkk44xxe+CwMZfs
         0fg+ux4QhsFWcNGKMQOkN9hR3QSqi1Na7CX1sDTPh26Hhtm05IFBkVyUkv0WKFujrcmc
         hfSA==
X-Gm-Message-State: AOAM532uDNwd7HkmLjC3rZTy4uwErAvPwH6Ta35VdJM4fliZCPKRgvkI
        ZDWYYFK3Jqla+qnXfAtkQjXASVXDHHPLEw==
X-Google-Smtp-Source: ABdhPJwx9um0vmY0DnYUG9kEzc1v1xMH5bH+K7HVKhmpcv+yl+Hyx+jkxHpVYBs3czBGcr7qfQ+u8g==
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr4021455plo.257.1592491447688;
        Thu, 18 Jun 2020 07:44:07 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:44:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 06/15] mm: abstract out wake_page_match() from wake_page_function()
Date:   Thu, 18 Jun 2020 08:43:46 -0600
Message-Id: <20200618144355.17324-7-axboe@kernel.dk>
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

No functional changes in this patch, just in preparation for allowing
more callers.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/pagemap.h | 37 +++++++++++++++++++++++++++++++++++++
 mm/filemap.c            | 35 ++++-------------------------------
 2 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index cf2468da68e9..2f18221bb5c8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -496,6 +496,43 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 	return pgoff;
 }
 
+/* This has the same layout as wait_bit_key - see fs/cachefiles/rdwr.c */
+struct wait_page_key {
+	struct page *page;
+	int bit_nr;
+	int page_match;
+};
+
+struct wait_page_queue {
+	struct page *page;
+	int bit_nr;
+	wait_queue_entry_t wait;
+};
+
+static inline int wake_page_match(struct wait_page_queue *wait_page,
+				  struct wait_page_key *key)
+{
+	if (wait_page->page != key->page)
+	       return 0;
+	key->page_match = 1;
+
+	if (wait_page->bit_nr != key->bit_nr)
+		return 0;
+
+	/*
+	 * Stop walking if it's locked.
+	 * Is this safe if put_and_wait_on_page_locked() is in use?
+	 * Yes: the waker must hold a reference to this page, and if PG_locked
+	 * has now already been set by another task, that task must also hold
+	 * a reference to the *same usage* of this page; so there is no need
+	 * to walk on to wake even the put_and_wait_on_page_locked() callers.
+	 */
+	if (test_bit(key->bit_nr, &key->page->flags))
+		return -1;
+
+	return 1;
+}
+
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
 extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
diff --git a/mm/filemap.c b/mm/filemap.c
index 3378d4fca883..c3175dbd8fba 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -987,43 +987,16 @@ void __init pagecache_init(void)
 	page_writeback_init();
 }
 
-/* This has the same layout as wait_bit_key - see fs/cachefiles/rdwr.c */
-struct wait_page_key {
-	struct page *page;
-	int bit_nr;
-	int page_match;
-};
-
-struct wait_page_queue {
-	struct page *page;
-	int bit_nr;
-	wait_queue_entry_t wait;
-};
-
 static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync, void *arg)
 {
 	struct wait_page_key *key = arg;
 	struct wait_page_queue *wait_page
 		= container_of(wait, struct wait_page_queue, wait);
+	int ret;
 
-	if (wait_page->page != key->page)
-	       return 0;
-	key->page_match = 1;
-
-	if (wait_page->bit_nr != key->bit_nr)
-		return 0;
-
-	/*
-	 * Stop walking if it's locked.
-	 * Is this safe if put_and_wait_on_page_locked() is in use?
-	 * Yes: the waker must hold a reference to this page, and if PG_locked
-	 * has now already been set by another task, that task must also hold
-	 * a reference to the *same usage* of this page; so there is no need
-	 * to walk on to wake even the put_and_wait_on_page_locked() callers.
-	 */
-	if (test_bit(key->bit_nr, &key->page->flags))
-		return -1;
-
+	ret = wake_page_match(wait_page, key);
+	if (ret != 1)
+		return ret;
 	return autoremove_wake_function(wait, mode, sync, key);
 }
 
-- 
2.27.0

