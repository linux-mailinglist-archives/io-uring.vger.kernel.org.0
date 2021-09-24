Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8E2417CBC
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346541AbhIXVCr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348464AbhIXVCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:43 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51346C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s17so22186267edd.8
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xeoZgsDqM54B6GznowZRq0c4NCbCzAE0CjNGGozWv0U=;
        b=KFUhyTCLZCCkfRz2lGRMaGqpUe1L1NDgCnYVZDh70gAPbHK8HRS6pmH5XwV4/Jefcm
         8AV3kC3g6MdZsUoTplRMILbYyFoDd7hPakYCK1Tfg3i/h92M7i3pXPT+ivrpq2izo09r
         Pq2Bpox3DjO9IrCOFNqUtE2DMpTaCh4fq+P4xGjSzyarso5pr5uEei7H8As8Z0vEHY0D
         ce2D20dnM2pIvo7rq8RGb1FerpUUoO55RRMcyQr987leFpp+sYorgjucSw7QFq4ZMqCJ
         uNQcpPvpyb3Pnex+F/XdY3c6tXuezijjv3XZNlu6XNP11Stiy+hEpJz3ICSGAi+65wsY
         Y9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xeoZgsDqM54B6GznowZRq0c4NCbCzAE0CjNGGozWv0U=;
        b=Q8n5mBT6+OQMKVOEuANY8kO+OjvHj4ZwgK0vmEdgdmo/krEwbFohqsmW6HB0eBV6bN
         lZmA3jY7n8bSN4HakU/qterx2T8CNZh4rkCohlnWlA4OYrdSQtuuYvdRoviAGiAp4L6d
         QAxd/1IZ1K+shfeRA+rnp6BhWQsGJfUZPK55NRg3WYsU5M2diFyyKBat2hUuvYaFB0cj
         EdMkGKGF/z0mSOEhZ97n/Yyl4rH2UXVUu1cXl1sAo6w2q62rTmS2Au0Yg3xTP0scEwW6
         wkh3TOB3XqQJ4UezK4V6JxQkdjOUHocCtQXA/wJAwO/HLLlwW3ClEMtD6naBAN2AOPpg
         ZJ2A==
X-Gm-Message-State: AOAM531+QCC54wL6F/kRz4JzgL/Xo/phPtC0ZiyCVVT36RVbJdSg9tZS
        YI1aYWOoNb9E3rlAV7TDcY4=
X-Google-Smtp-Source: ABdhPJzNbPiSHLhJAaSi1InTheNE17T9o3UAyVQVIPOs4CsuGzQvUqkzGvpDVNAq8f8u2VR8QEjgCw==
X-Received: by 2002:a05:6402:168b:: with SMTP id a11mr7600669edv.295.1632517267968;
        Fri, 24 Sep 2021 14:01:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 22/24] io_uring: kill off ->inflight_entry field
Date:   Fri, 24 Sep 2021 22:00:02 +0100
Message-Id: <fd8d68087ede26c4e1707ce6b175aa1eb2381f2b.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index b3444a7c8c89..34c222a32b12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -869,18 +869,15 @@ struct io_kiocb {
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

