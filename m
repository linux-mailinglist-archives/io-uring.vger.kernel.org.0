Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F91476573
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhLOWJK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhLOWJJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:09 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B895C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:09 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b7so20566149edd.6
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zk7tq+jeU/KIuJIF1RK+uXu2NXCXDfvMa8p3uA92U8s=;
        b=oXdEBVUxQwmOgzqS0LPSzYxLqpFqNxBAAHFAvcuyb0v+avMaDRUde3MakXgL+FbKyM
         KyJSudObZy5RUvN0ZwzlwKBJI6iyu7+sLVnq3LzpIyLkh9eRAwDjqOpItUyR7IRLrWNm
         IN+YQAoqe/dnRi+eO67NvcLNvOgcJpiwB9w31EAWg1o90CcNmTkQusPyrC9/HXpru99i
         /txqUNdD1tMwM5pLyc/l5a1Eb4LBMXFIKALx3JRgsHAdUMr+4DY8HecuehpiCMC4hMg+
         g6yqpp5jCWSAxOdlxF4/u8o37EQhZZ92qVkNWEH/+UqgElb2nlsVw82yOeQu6ClE6NCX
         3Ycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zk7tq+jeU/KIuJIF1RK+uXu2NXCXDfvMa8p3uA92U8s=;
        b=5kEWeGTiM//Sv4MHsqpuK1JB/r0KJ6YFgm2oBcqPGv+mixgcRW7733o8E02WI2SWSS
         WfJji0/MrWECU7dtj7hpAxaqulnkQ4jdyXXFOQzyV18BkMomD76cV+Fcl7x+PIN83ofj
         NZOB1YREMXiVPmJmnw/ZmBiOd64wahXq3qCaHpqtgplKRw5UgU3gGw6LvDlPdkXQKCtA
         DnectPbKa3741CvlVsPLWn8ux7T4ymU6s4/pfDQ+6wg3Cw5b5zoDnFuGaXZvVAc5gAEi
         ez4A7/pPC+dvK/z57FWNcvJNFlhstGbc3ajDQ7lmwIJVsyQxwgf13ywJ1oJdlgDfMiOR
         xzYA==
X-Gm-Message-State: AOAM5332WlrObcripWhxZBg9kJKbjulaadO//lxAH8J/GKC6+Oaw2GXX
        2E0SJqVtwN4kSQbDwb1Lx0JujlXaaRQ=
X-Google-Smtp-Source: ABdhPJzSbzG19Hzr7xvBretYnATUtAFPozbL1NU+XpMckYJ+qOqK8xAtBrF1qXNsVzL+MZAFmobzLQ==
X-Received: by 2002:a05:6402:26c8:: with SMTP id x8mr17167360edd.156.1639606147622;
        Wed, 15 Dec 2021 14:09:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring: use completion batching for poll rem/upd
Date:   Wed, 15 Dec 2021 22:08:50 +0000
Message-Id: <e2bdc6c5abd9e9b80f09b86d8823eb1c780362cd.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use __io_req_complete() in io_poll_update(), so we can utilise
completion batching for both update/remove request and the poll
we're killing (if any).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 20feca3d86ae..2ff12404b5e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2778,7 +2778,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static void io_req_task_complete(struct io_kiocb *req, bool *locked)
+static inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_kbuf(req);
 	int res = req->result;
@@ -5903,6 +5903,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
+	bool locked;
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
@@ -5928,13 +5929,16 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 		if (!ret2)
 			goto out;
 	}
+
 	req_set_fail(preq);
-	io_req_complete(preq, -ECANCELED);
+	preq->result = -ECANCELED;
+	locked = !(issue_flags & IO_URING_F_UNLOCKED);
+	io_req_task_complete(preq, &locked);
 out:
 	if (ret < 0)
 		req_set_fail(req);
 	/* complete update request, we're done with it */
-	io_req_complete(req, ret);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
-- 
2.34.0

