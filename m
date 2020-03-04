Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D0A179112
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbgCDNPU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:15:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41289 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388150AbgCDNPT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:15:19 -0500
Received: by mail-wr1-f65.google.com with SMTP id v4so2337558wrs.8;
        Wed, 04 Mar 2020 05:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4UBTK6J3rpVi/KYhKlg8PAB4+/xBpnflvxGLCxGBorc=;
        b=Rb1sGb7PqahV3DpcK/AKTrC/KysMpDn+NZphw2eb29LNUCKWwuhKTi6qkyKUl6iAcf
         s/Lf1fMUQDzoWT6RltAKD6StREKLIVLg/m7YZTeTbfeaddT/UPXwyPNANlm+DdoCqG5u
         ceREQs5zKKfdT4Oxh7ZWveLOoE6V+eAv0L3fJ3VNqg+DWwWQLGjEWnA6OnH+gJJsW1jq
         nyW0QjN3SP6fAKL0CxznXxJ0UAv7MnNCSV57rXtotU8R9/pcGj19kgJ390LgftjgQ20m
         6Vc4AiTdPMewJyv8LWBqryJ5jDyxxdsvJcJx710oQnGC1OJ7TddUn5twZ64oq9x8gql3
         iDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4UBTK6J3rpVi/KYhKlg8PAB4+/xBpnflvxGLCxGBorc=;
        b=WWJz2frW5IE37JYvKwXd3qJyHr3aWOQ73fxUe0lqqEaBGvkrhVZXaeMXrqDXu2/HLb
         Gzoje8zoKg6xYJsXIt5W2Mku10gByBakMJ4moPgFvq+KOUg1bfmP0BvQf4BsTimEEPwo
         qiEjTiGMHeP2zCoUx3fcMlOKTygb9QzX66yPnq7qtUmS+7DpfV/3ip7lmTwWP5DY0k7S
         uwnUYta0mz7PMKrA0QFijBwabWpain7Joxgu29H4yAd48zcUGVbNvPkQo4eGWPFeJGUI
         eOvn2V5a56zYmOPaWvONadeBtQZruKyFvN+KSIE/vNaYWkPRdiOalNg3TcYfd2AGvzA9
         140Q==
X-Gm-Message-State: ANhLgQ2asVTT02S6CabzV5dBpuZKDJZHO235uxjyocD6UpkXfY49OFL4
        42IPCH6tCpp/RDgzPLlN+ZMrvOtj
X-Google-Smtp-Source: ADFU+vuNWLha8k9dLIwpqU+/2UgVvj6c57vLiCl9DSbhVVQCUisiZQP1Fh6yllpD6rODMNAD0GwKqA==
X-Received: by 2002:a5d:494c:: with SMTP id r12mr3853586wrs.50.1583327716460;
        Wed, 04 Mar 2020 05:15:16 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id c14sm24746746wro.36.2020.03.04.05.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:15:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io-wq: optimise out *next_work() double lock
Date:   Wed,  4 Mar 2020 16:14:11 +0300
Message-Id: <aa8a2327904fa536492fa6f4ffdb003cd18c70cb.1583314087.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583314087.git.asml.silence@gmail.com>
References: <cover.1583314087.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When executing non-linked hashed work, io_worker_handle_work()
will lock-unlock wqe->lock to update hash, and then immediately
lock-unlock to get next work. Optimise this case and do
lock/unlock only once.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 473af080470a..82e76011d409 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -474,11 +474,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
+	unsigned hash = -1U;
 
 	do {
 		struct io_wq_work *work;
-		unsigned hash = -1U;
-
+get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
 		 * the list isn't empty, it means we stalled on hashed work.
@@ -524,9 +524,12 @@ static void io_worker_handle_work(struct io_worker *worker)
 				spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
-				spin_unlock_irq(&wqe->lock);
 				/* dependent work is not hashed */
 				hash = -1U;
+				/* skip unnecessary unlock-lock wqe->lock */
+				if (!work)
+					goto get_next;
+				spin_unlock_irq(&wqe->lock);
 			}
 		} while (work);
 
-- 
2.24.0

