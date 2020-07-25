Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B6522D71F
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 13:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYLoD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 07:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYLoD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 07:44:03 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FFAC0619D3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:03 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id di22so1634126edb.12
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bPXude+rqWbj8oBJu/n7iWmqexptGHuvGtprRcLQtn0=;
        b=nyZVu+qoaAIWH9wEUC93gtVslI566tv0rSOFCRRDdgaDZ1rLJ2vXCPi/h/av7sK8CZ
         5mX/RdEjb5fHWXD0ZLi8belsigCTY3OUbmHSipaUtiwpKt0OVcgyiaKVrJAxjLywqmuv
         Mlk8AGFldGFE8Zh3QX3OTaNgcPvYI6ohaBwgDjrOSEAbysGdc0Iv/SSDuqB5xjLLbyou
         T7iBDWlaQ7ZAVunDC8zVAOcSCkYH7oFZ2wjCP4VLugr8vSu/Oy6GnJXsv0ji48pyfcIr
         F3M4LxNimL/MOk3nith0c24ApN+x2mXznXDiN8xBsEdGJz2mXoiJ51v9oNQtwJ1GnZ5J
         L1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPXude+rqWbj8oBJu/n7iWmqexptGHuvGtprRcLQtn0=;
        b=n9QQtKrbe6N0ZF4kfkDl5B6QSJ+zYG43shH9cyZRyHLWwlvC/iWPgHJt2XqtjR4rmX
         wehWY3D7giDPWjsOrjTWF5hiylJ/sSfW/S3OXxXAuDRIKNaTcAPCsVQ3PaW6Ks1ozGvO
         VgLJqBugzK4GOXPI+yEVOY/wC+o7QvvGNXYCrN1Hjj7C9l+Zel4O9GChVCwZetq9iYAo
         J3fWaasARvBVWjW5O6iBARWLWw1qR0DgKQSS5eRyk5rtb4F8+a0jRp+X2Or5Pw1j9DMY
         a4OrHuTWEm28fJ2m87C6Oj2ZT8OjJMugbDCc2FM880McNW+0rwTHFKf3m70hV0LfzMSu
         9ejQ==
X-Gm-Message-State: AOAM531ewfn0UzqSYD2ioKOnZk9dgInBxhfJqRU9hvBGEcJjrPV3fa6v
        IESkZa75Pgr7sg38OzJ4QLFC8EJv
X-Google-Smtp-Source: ABdhPJztAoq8oK1M7r5n8m2kWXFyp6MxCNUS4AnCsZRzOgCdvyzTeaMslU90ESzwLapavb5fD0t1JA==
X-Received: by 2002:a05:6402:318d:: with SMTP id di13mr13575229edb.172.1595677441848;
        Sat, 25 Jul 2020 04:44:01 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id i7sm2743601eds.91.2020.07.25.04.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:44:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io-wq: update hash bits
Date:   Sat, 25 Jul 2020 14:42:00 +0300
Message-Id: <289b0606676f6261cdd765aa55a0d980eb34b7a8.1595677308.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595677308.git.asml.silence@gmail.com>
References: <cover.1595677308.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linked requests are hashed, remove a comment stating otherwise. Also
move hash bits to emphasise that we don't carry it through loop
iteration and set it every time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8702d3c3b291..e92c4724480c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -490,7 +490,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
-		unsigned int hash;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -513,6 +512,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		/* handle a whole dependent link */
 		do {
 			struct io_wq_work *old_work, *next_hashed, *linked;
+			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
 			io_impersonate_work(worker, work);
@@ -523,7 +523,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 			if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 				work->flags |= IO_WQ_WORK_CANCEL;
 
-			hash = io_get_work_hash(work);
 			old_work = work;
 			linked = wq->do_work(work);
 
@@ -542,8 +541,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
-				/* dependent work is not hashed */
-				hash = -1U;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-- 
2.24.0

