Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154E03223F7
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhBWCBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhBWCBH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:07 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACEAC061793
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:53 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o82so942251wme.1
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=a+6Txhif436kMWxOdx3AyYXPR9ez3pGZr5Rtl2jyfPs=;
        b=bsN2+HR1PD/Y1sOeTmAggBV5VmyaRIu62rXn3WKrUpTWUszYDMi+cPqyZ50GIdCS/F
         J9YFZGLSYiCGB/bn+GyEUWOYHp19PYnBEbRk0C8toxOkMB/Xe2AdWjDnmEq76ne+7K6z
         cGvYs5u2bQBNZeI9lLADZur2hJQaAeHJbklDk0zmSnC07t9LvaBaNcuv13ztZe2yGfmq
         T+4Qmg8n6a05qBeWLQ2AysfgVtexiWFkLGU5JoF1TgzkruAKR5TmKNKwDBVBZ+eNXB4k
         PztguU7hOfXvNMfR3Y5BIpLxt2xsDh/B9e9UNXwV8Yf/UEkrn6dsVXpsXEl00N4y+CZz
         S6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+6Txhif436kMWxOdx3AyYXPR9ez3pGZr5Rtl2jyfPs=;
        b=V7d/aP/E8BY6vrMY2+vF2AKUsvwoo75qZjKHO18LzFeClEgSbrDxijJHdS/qwXc2sA
         uge+BJbJvxKkIgxMd8sXpOvDCJLsF+8Xl134lZag5iZ14+eEk5XysMir/hOxVnLZlK9G
         eZDNPNpGtc/Hu5lNE3r4zYqDTc/bqAGOz3bp9GIDUVQ4ohZNsHTS0wHqckhNWgIUP5GQ
         IEmVDzjmSUPW9kzilidzEQ90FVBKcV/vngw9cE061iXj2R22BymKK4hStsZ4g9CqIGy9
         Os3pxWs13MyvzMzRJ4z8Bpvyt0QfvIIOVXSVtHgRDWGU/F5il6zsfkemCw7WDLZOVOWW
         pwEw==
X-Gm-Message-State: AOAM530TcJOiR4WNuHkU6ltEs/oWO69VCtiROzDBko9ArkOAjQlHTvgb
        ZJTLWIdWgUZShlZ52Dot3p4=
X-Google-Smtp-Source: ABdhPJxXWaQG/r59hHfKoRVJU8+nXLPk+Y4e16jE6hcz53Bz8tG/fbaqt37tONLqghQh6F0sW5uKSA==
X-Received: by 2002:a1c:3c02:: with SMTP id j2mr5655257wma.92.1614045591979;
        Mon, 22 Feb 2021 17:59:51 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/13] io_uring: refactor provide/remove buffer locking
Date:   Tue, 23 Feb 2021 01:55:41 +0000
Message-Id: <d534cb75d8605746fc801f0e5eeed53b9d799ed1.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Always complete request holding the mutex instead of doing that strange
dancing with conditional ordering.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 692fe7399c94..39aa7eef39c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3937,14 +3937,9 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail_links(req);
 
-	/* need to hold the lock to complete IOPOLL requests */
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		__io_req_complete(req, issue_flags, ret, 0);
-		io_ring_submit_unlock(ctx, !force_nonblock);
-	} else {
-		io_ring_submit_unlock(ctx, !force_nonblock);
-		__io_req_complete(req, issue_flags, ret, 0);
-	}
+	/* complete before unlock, IOPOLL may need the lock */
+	__io_req_complete(req, issue_flags, ret, 0);
+	io_ring_submit_unlock(ctx, !force_nonblock);
 	return 0;
 }
 
@@ -4031,15 +4026,9 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-
-	/* need to hold the lock to complete IOPOLL requests */
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		__io_req_complete(req, issue_flags, ret, 0);
-		io_ring_submit_unlock(ctx, !force_nonblock);
-	} else {
-		io_ring_submit_unlock(ctx, !force_nonblock);
-		__io_req_complete(req, issue_flags, ret, 0);
-	}
+	/* complete before unlock, IOPOLL may need the lock */
+	__io_req_complete(req, issue_flags, ret, 0);
+	io_ring_submit_unlock(ctx, !force_nonblock);
 	return 0;
 }
 
-- 
2.24.0

