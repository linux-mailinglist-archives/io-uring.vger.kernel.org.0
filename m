Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B2F4178F1
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347524AbhIXQib (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344065AbhIXQiM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:38:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B19C0612AF
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g8so38222414edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rMjmxdosJwCWERhXhGA5JeUltvRDhbQHXuwlhLP9Mds=;
        b=NB5c9LULkUiwzQzkrsNvzeflbPUoHRyn1MDjtnf8eaMQ4G+NfT1CwP+9qv4UKIs+vQ
         ZJil7Vy1/ktq98xgtcUSsjn92bkMdWbFxcp6lYB5fK3gufJ1kqnJwOvcnm2HYVupP5rw
         6VjnGPYmL0p4XfOJOxYN6+CDEJ6KpRBcmwXhxIaindvaOqe52EM0MjzVi9f8+CL9/U2P
         G2rjBFfX/XJK83s1iHWf3bpdMIoHqabwlA/v1QrCe6r5zy7K50BKS61ZUVyzSsUoZKgf
         4h3bG8bJOm3077j+PB2GJOpSHgMMg6S9qj3IY1T+pCh6lmUoGARpT5EzmtKWspowARsY
         Fr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMjmxdosJwCWERhXhGA5JeUltvRDhbQHXuwlhLP9Mds=;
        b=2gNB41CxTGhy/RyRpIH8Rxk5MC/PIJhw9nYeqwWWtmbPx5AIMj0AALFRU8ZW3NB5HV
         4uSowsTbh9YMwOnY26S8wcPYUYtd2HI/PexJ9rKV0hSlesBBHkEpzzGkQfB23WEdUI8J
         Lt6pxBa6X+SpQ4TU1hamFYIzLNhBSLgzX+XGqDeffKwxXV++XLFIUB/+o183iaWUJfCk
         kzz+E8Es05822sBJENoeiQYvti8Q0BW5Bz9louRZoZNHcUSO91Dv72B2rQtn4rUxPJ1W
         Qj+ZjR5s3jsHQ0AcR0aPuuFy1j9M8Aa1RxOaofFufr3hAmNMTis6jENIOJbyECxBfjSA
         bRbw==
X-Gm-Message-State: AOAM532w0s9GkLh1k6+4+jEKcbuwVY0U6tXjgNSdOwUlnlPLv8AGgeJg
        sSDYfJXWsZnSxL1UU2uW/qS/cT2ZDHw=
X-Google-Smtp-Source: ABdhPJw3GKZ6T7k+rUIhqMBclhSbPuq3UBDnNFJA4KPRUY2YYkSY+VKsaa+Gbr3Ga+PJdZgByWUm9A==
X-Received: by 2002:aa7:d74a:: with SMTP id a10mr6052543eds.102.1632501186611;
        Fri, 24 Sep 2021 09:33:06 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 22/23] io_uring: kill off ->inflight_entry field
Date:   Fri, 24 Sep 2021 17:32:00 +0100
Message-Id: <c3ca5e467274879fc753bd389f746318397960a4.1632500265.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->inflight_entry is not used anymore after converting everything to
single linked lists, remove it. Also adjust io_kiocb layout, so all hot
bits are in first 3 cachelines.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3ddca031d7d5..c53e0f48dc69 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -868,18 +868,15 @@ struct io_kiocb {
 	struct percpu_ref		*fixed_rsrc_refs;
 
 	/* used with ctx->iopoll_list with reads/writes */
-	struct list_head		inflight_entry;
+	struct io_wq_work_node		comp_list;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
-	struct io_wq_work		work;
-	const struct cred		*creds;
-
-	struct io_wq_work_node		comp_list;
-
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
+	struct io_wq_work		work;
+	const struct cred		*creds;
 };
 
 struct io_tctx_node {
-- 
2.33.0

