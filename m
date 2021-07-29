Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82C3DA71C
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhG2PGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhG2PGk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:40 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE25CC061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n12so7379642wrr.2
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/edalpX3IIPPgS5dt1orPPCyWo5MfeZJzBqpbFwWmVQ=;
        b=cwsGhWkFcgrKWrRVKXIi+N6mb5pVXSOlNN5BJt6cLNydGhK+OZxLwaXl69kxd/Pmq0
         ZKgVJfct5z+d1rN0tbULDacwskOxdmd1RwQuUSmYr67bB/hOWHbCvPMFcNMKB5SLNmdE
         1YOS59ChpOpYeTZpv7vpoZWE+5LH1AU2ecWbhPhv39zpxCOyktIxgjlJCx+7cq9GEMy0
         IHNvjV6uyyo7ax+DuZaYlAHDZIEvW+la5XvSYX0lLj+tlcqT9+gV62KuJ0DGKenkmMN/
         wrk+tr1cU6TRRz7IRnfTzhV+PWSQ+1+Ji9ekQZhBSULuXC21zrZU/vTYWbKOA2S6AqBv
         BMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/edalpX3IIPPgS5dt1orPPCyWo5MfeZJzBqpbFwWmVQ=;
        b=iLSGDBkc9ql1vYZeA6pXwShREG2DIA9gOBteRNmXHUs3JXxaWZvTLAbNrLUg1t10hj
         TOqYS9KlDA80OWiBhzv+/bzQC5plcITG7b0cPnu14sPflhtClF+0A41ea+/QsyObEQZk
         fbcgl+NoePfzHWob/RWM2CJP1HNvzwPm0TrGz27cLfeoUnLcGCYuV07FYCgNeU202WjS
         HBQm2b+3h3vw66Jznb4eElmUbGw6HQK1WufRAKiqE/62d3m5wILSHVGKbatfwxDhVzoY
         IaKcvSXisEGsDKTE4+QoQBMDFv9KVOMoopJxKADFy1qsiGJfidz8rHpNlJtOtLI0TY95
         powg==
X-Gm-Message-State: AOAM5323UPxOE1EHSDr6RJWsMXsxUXpHYTFoLrRJ/KDSRazdxUdkn3Fv
        pFf5HsLvk+cCU0DLnMk8O88=
X-Google-Smtp-Source: ABdhPJy1lS/MUqADrhWxRzVHbanScgKpjJmMTR0AYKMjUdxMcMvEVdMq+J6cqRAJxbpt+Y9HGpsRCA==
X-Received: by 2002:a5d:6d89:: with SMTP id l9mr5291399wrs.371.1627571195430;
        Thu, 29 Jul 2021 08:06:35 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/23] io_uring: drop exec checks from io_req_task_submit
Date:   Thu, 29 Jul 2021 16:05:41 +0100
Message-Id: <847a7e69c3bcc92c855370a4d78856f469a4a9f4.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of on-exec io_uring cancellations, tasks already wait for all
submitted requests to get completed/cancelled, so we don't need to check
for ->in_execve separately.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7066b5f84091..1a7ad2bfe5e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2034,7 +2034,7 @@ static void io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
+	if (likely(!(req->task->flags & PF_EXITING)))
 		__io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
-- 
2.32.0

