Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA63D12BEB0
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfL1TV3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:29 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46406 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfL1TV3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:29 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so16072436pgb.13
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OCDlzjKBtNA5nDEjW7SKlUxJxiS4FORDY5crjxo8fOo=;
        b=CaJwWqzgWaaIsjrgD7aASGjBz2Ik0LOBvA7LxkLCejZe9exQo3Itf8zEpxvg0POm+g
         03PcdNqyd05JD/pOW3YkrVufA9yX8+VwN3ao9RvmEIXF+88zSHiKKdBCBQx1NaJfOhpl
         4lRMcv7WF1VIr0uB+unnT6YoeAqlv9LAn4jpN4kD0chvias0oYAPFyIRw76EJn9XRDbE
         nrsRWUC9TAOor9PNvjt4K/tmrxsL8cabCpoR5EEK3vH52f1dC8DAbvTSoL4B7r0o8qu2
         Ke9hVsje9jnBV1VDsex7HHFmXAhbkExgwVkwJ4TK58WVTdgocE9GY6MkcWVjJFEj0WDW
         n4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OCDlzjKBtNA5nDEjW7SKlUxJxiS4FORDY5crjxo8fOo=;
        b=XfBU8OCgui1A8W/n/dBoz8VVb02LN+Qs6ZiXtYZrIcQ44pPmuSfz373plyjYmpU9B8
         OnuYhrBQ+Gq44sm5Ehf9C9zql26D/ik+3xFBRV9xHnELzmIaoV7ndQUDoX2cS+av+bi7
         UEJtEOELG7+2/F6sHWWqTneCcXP+c2T0eJHo6udqz+GF+UDxv2F8yc4hHowd+CknroW8
         NE+AqOmYycWM98OQezj4QhZ5HdG/BQAnyikDHOGrPGgBCGDCP/ZR8+NH+lF7SNdtLD0j
         DzREi+LX2LgiLN1JfhDEBwqp2NnwhFb4iSN5PhzodoNEDXscTymb3tucj5P0jhL5bQDi
         PDbw==
X-Gm-Message-State: APjAAAVoviwfieZDe2PcimRidqdMSaAoXH55sDsKaZuSaQvyUXgEP9FY
        hCs/awgv0QTWgxWhlKyclQFS+zNVhiBRXQ==
X-Google-Smtp-Source: APXvYqyKSf1p9u8SIYXruqa1PZoR4ynTGaoDZfR9y9og8uVMz5Q3zveIQ0txSE0cJyhoTV614zFZQg==
X-Received: by 2002:a63:710:: with SMTP id 16mr23567613pgh.58.1577560888254;
        Sat, 28 Dec 2019 11:21:28 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] mm: make do_madvise() available internally
Date:   Sat, 28 Dec 2019 12:21:17 -0700
Message-Id: <20191228192118.4005-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation for enabling this functionality through io_uring.
Add a helper that is just exporting what sys_madvise() does, and have the
system call use it.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/mm.h | 1 +
 mm/madvise.c       | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c97ea3b694e6..3eb156c3f016 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2328,6 +2328,7 @@ extern int __do_munmap(struct mm_struct *, unsigned long, size_t,
 		       struct list_head *uf, bool downgrade);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t,
 		     struct list_head *uf);
+extern int do_madvise(unsigned long start, size_t len_in, int behavior);
 
 static inline unsigned long
 do_mmap_pgoff(struct file *file, unsigned long addr,
diff --git a/mm/madvise.c b/mm/madvise.c
index bcdb6a042787..43b47d3fae02 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1044,7 +1044,7 @@ madvise_behavior_valid(int behavior)
  *  -EBADF  - map exists, but area maps something that isn't a file.
  *  -EAGAIN - a kernel resource was temporarily unavailable.
  */
-SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
+int do_madvise(unsigned long start, size_t len_in, int behavior)
 {
 	unsigned long end, tmp;
 	struct vm_area_struct *vma, *prev;
@@ -1141,3 +1141,8 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 
 	return error;
 }
+
+SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
+{
+	return do_madvise(start, len_in, behavior);
+}
-- 
2.24.1

