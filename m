Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1A91371AC
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 16:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgAJPrp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 10:47:45 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40351 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbgAJPrp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 10:47:45 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so1319551pfh.7
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 07:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KAg7QIm8jImHikUoSOMs5glP8O4K1H+Tjxl6C2b09Qs=;
        b=qOl9QFBlcZiHxiGK52h4/8M3/n2zocyp5aOgkMhgQcAOyq9f9KQsI+A7NOTym4c2SX
         uL7JxRaIckN5V3bACPRAFezd9Cl87tnT/gviSWBRkZpUa3NfnG/Cg8eAxuoeIZaqFzsQ
         YT626P69FUp1SeXP+fOrYiZI+YqREpnEyOkfdrRz27p6Hq5Y4Z801IQqDD4mY+yV4Vo1
         UprGmZAf+XwvRsR61/J/GDr3cK+ezDYJ6O5FhvH2tE7N1HnGsYcRdzRlV9tvR6eE4zDG
         Qw1N9mz0P98CP0sx/UJfR5mYYNcfKssVkTwATm4bMeJfXMgwtEQmnoQO0ToQRZLt4QzS
         TGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KAg7QIm8jImHikUoSOMs5glP8O4K1H+Tjxl6C2b09Qs=;
        b=paseFnodM+oUoIMEVM47QWu9jwGCcOUaxhuXmK+WgJ69pZCcfr51UwchcZdAsOWNT9
         S93v9Ub/1AUkfTAZVpdsw+DdXhSfUedDhCfjxONb6o42/i7m6ucLF9EPPQhQRsFCpCib
         bxj/GiS3GBVnE3/+BnfoArkDphinocZDk7Mqf+p4pXML+rsoWXJ1yCHKHSx6r98tIXIg
         z/Ym4QG9Ntw/MvgE4q2inMIcKkgnNyvvURRXfwP8uK33+OeVLmbEi9B4amBJ0aDID3Gr
         TCxFIGOYpbMFc3WxtKPq7TwRVqhCnui4cBVLkGZnFdkvrL2YaxMaIZhcxo3z1mx8i4aD
         ZBpQ==
X-Gm-Message-State: APjAAAUljf4IFb2LPak0Ab9qAqY+B5AEZJjUhSS/UC6PnAqNdCxmcic/
        xDYhXuE+YpoAdRPueMFoBY+xsyhKOAA=
X-Google-Smtp-Source: APXvYqwoxEzA6d9ySBwwZb72IUvmAA51OESb6WnmFufqREvnNTQk2wRRkJwqjLvXMMAkB/+D11ZgOg==
X-Received: by 2002:a63:5442:: with SMTP id e2mr5034197pgm.18.1578671264202;
        Fri, 10 Jan 2020 07:47:44 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 3sm3489520pfi.13.2020.01.10.07.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:47:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] mm: make do_madvise() available internally
Date:   Fri, 10 Jan 2020 08:47:38 -0700
Message-Id: <20200110154739.2119-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110154739.2119-1-axboe@kernel.dk>
References: <20200110154739.2119-1-axboe@kernel.dk>
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
index 80a9162b406c..766cad8aaa60 100644
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

