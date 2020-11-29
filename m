Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8742B2C76EB
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgK2AuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgK2AuV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:21 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B0AC0613D2;
        Sat, 28 Nov 2020 16:49:56 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so7767805pfu.1;
        Sat, 28 Nov 2020 16:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l/Z8FKlQx4uPsR2N2TmU0wX19nThj5BIa2agvJuzNHs=;
        b=B6+nMYKwKJ4hMGar1ZDhLuHnwmrkqzZ1MImfumwqd2HseKfQ5iE6w4aXKmat5EOLN2
         ZgtFyypw79nA5lB+2B7b3FOLsq214EIQ73rgnlo7Bm+w8+aOagMI36mmeu0c/OEo6umq
         WKJmEokmFR3+kgrNkiPI9mVwklCmL7CBFt0cX2L6ltEtkbzs0y3hEwQTLyTuuC3f2xMl
         TvhSoE7YajZWGu40VmH3ezKqZCIE5TqIo1ZMpNsE0UaLl4QNx24hhOd1VmfCsILiADwN
         8ZRzzuKUD8EDfBacEoKs2dzJzuKkklRM7htDJlz3hxhXr5UAV2iw78MokJXHycR3+0cS
         aoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l/Z8FKlQx4uPsR2N2TmU0wX19nThj5BIa2agvJuzNHs=;
        b=MLWmO3BqklF9WSWeFmMBA9C8CzPKjAOiWGBzI47HixUQAOpgv9rWSJOCe2RzAyjhNv
         ZlGDwdkh6KVuzKGjAwYlQU7m6bP3YdYoQfhPEJxqSowWE8I3Ou8Q9vwmzOKEoAXkgwl1
         9OoGJhuGvF5Arhi8/+jZclVl0atB6S3S1Q40+p0C1PmXGYD07j90OIO9wV4/wKQc3vI4
         5u/9qlPH6xEzDo3ntZvWGrQhxB4L+KjxRXTUPIcVO+BmUbGFsU+91NpKTheqeBBtU709
         xk0iZVBqseIM4hqLqrTdgltmHZUJNkCw8UhlwLDoUEFOqq87jK19ZJwyXIdDZqZHoZPW
         weGg==
X-Gm-Message-State: AOAM531bGvqhYNyBPT5wKFqfnvDjJTUolz0SHzB8XB4mooRELJAA8q5V
        h3V710/MJKyZc/Yq3kgDly4BsILCZEQeAg==
X-Google-Smtp-Source: ABdhPJywBaA7WF3l1QVlZ/0iev6HcvYcWxP1cEM+D4hAm7IrnJMAcUdTAhr+98nM4pSoy1jJk5U9Nw==
X-Received: by 2002:aa7:9501:0:b029:155:3b11:d5c4 with SMTP id b1-20020aa795010000b02901553b11d5c4mr12958529pfp.76.1606610995913;
        Sat, 28 Nov 2020 16:49:55 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:49:55 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 01/13] fs/userfaultfd: fix wrong error code on WP & !VM_MAYWRITE
Date:   Sat, 28 Nov 2020 16:45:36 -0800
Message-Id: <20201129004548.1619714-2-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

It is possible to get an EINVAL error instead of EPERM if the following
test vm_flags have VM_UFFD_WP but do not have VM_MAYWRITE, as "ret" is
overwritten since commit cab350afcbc9 ("userfaultfd: hugetlbfs: allow
registration of ranges containing huge pages").

Fix it.

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 000b457ad087..c8ed4320370e 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1364,6 +1364,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 			if (end & (vma_hpagesize - 1))
 				goto out_unlock;
 		}
+		ret = -EPERM;
 		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
 			goto out_unlock;
 
-- 
2.25.1

