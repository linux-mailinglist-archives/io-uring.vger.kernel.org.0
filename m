Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6074B35D51D
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241570AbhDMCDa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbhDMCD3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:29 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE6C061756
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c15so5840077wro.13
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X0OYItsxbiGkS4Mmd2UfkRLiUF6mrGc0Eox3os1VEnk=;
        b=jVz6FjdoXZ6sYw3OCGsT3ra8nefCDSxY6sDnYaGPi3K9Zjp0knMdniDe1cqtqrJutz
         JSuOzCDhl5rdpZtM5yC/jTPz+DD3GvBwLKL74ur+Untp4Fw/Sp2ok2N+yMzKt4ZfwZjp
         I+Juc+nEfyb8xlBZQ5yBTyO6hDD6mtDZKzr1vS6UaKqY8spgB9HKxssMittGl3DrzNzh
         W+PjEN8FrXU3gs/WKrOEM74YbjuD+i3pEsK1Atm7I4keZGfCB/MAM2QnGrL8+Ws45QkF
         qwcq4zg6kpYvqMrtfTha9Ox6ZuG9sANCIb+vxg7lyGI1tHMUwUWU9u2U2MOrwUjLykeA
         RhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X0OYItsxbiGkS4Mmd2UfkRLiUF6mrGc0Eox3os1VEnk=;
        b=q6qjHnk3KJviELU2BvxLjGZeus36HXZME4j2Jp/u1ex99r01+v2gd2Ypywy27W2Mkx
         FQYaKSNTYJ9KyQezhvlo+9G7x2hhlS7yu7TvBe26EnqBtPEWiZipJkhDMwLUQzNit/KF
         9USqkSpn/xMpy/WGRdZ/6WiTepXUW1kHYCc3RGBa0vVOF4yWrGqZRILZSUFNATNd/KG2
         32VF72JdWxctIz5WvsMrECyAbr1qEgkzCuA++jHovvFVQ+i9aQ1B1u7FrgojVGWh7YRh
         fqS6mPvVCKibU9OPA6zscflCZWpwuM6ytNdbIi8AvvgZLKsJNUI8hnd9PGXZWNILQF80
         wB8A==
X-Gm-Message-State: AOAM5315/xz7fhlm7wMFgtOZAn7wJ8M9WBRg8HNoAj5VPATJ02sQ7RGS
        wWf1eqHxGbn9xSJ/nJVKD0I=
X-Google-Smtp-Source: ABdhPJwNqYlEg7vlrBvmdRf5hPg23UGsSBIBXoRQ5EYAukN/zdIQGaHT6lBZN1KXYXDoj8hOtYu2fg==
X-Received: by 2002:adf:df0a:: with SMTP id y10mr20327501wrl.246.1618279389792;
        Mon, 12 Apr 2021 19:03:09 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/9] io_uring: skip futile iopoll iterations
Date:   Tue, 13 Apr 2021 02:58:45 +0100
Message-Id: <5b8ebe84f5fff7ffa1f708952dfef7fc78b668e2.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only way to get out of io_iopoll_getevents() and continue iterating
is to have empty iopoll_list, otherwise the main loop would just exit.
So, instead of the unlock on 8th time heuristic, do that based on
iopoll_list.

Also, as no one can add new requests to iopoll_list while
io_iopoll_check() hold uring_lock, it's useless to spin with the list
empty, return in that case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cc6a44533802..1111968bbe7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2387,7 +2387,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 {
 	unsigned int nr_events = 0;
-	int iters = 0, ret = 0;
+	int ret = 0;
 
 	/*
 	 * We disallow the app entering submit/complete with polling, but we
@@ -2416,10 +2416,13 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
-		if (!(++iters & 7)) {
+		if (list_empty(&ctx->iopoll_list)) {
 			mutex_unlock(&ctx->uring_lock);
 			io_run_task_work();
 			mutex_lock(&ctx->uring_lock);
+
+			if (list_empty(&ctx->iopoll_list))
+				break;
 		}
 
 		ret = io_iopoll_getevents(ctx, &nr_events, min);
-- 
2.24.0

