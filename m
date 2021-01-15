Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB672F82B5
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbhAORmd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbhAORmb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:31 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB246C061796
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:40 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c124so8117811wma.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZBF0H0DztW7+LbpLr7Z5t5wlqhA7pO1cuRj1XFutUYM=;
        b=NQ3Aq/CyRJDzT+jhNJKodswY/lics1BIn+yMayjFwzTiTUnYUNBGK9hiDQXFuTBnD8
         aC3arMghnXRvClSUrROBXt+kYt7WRMl9UsXLulFi2ADtLnWvJzcRFamFOLYwHTyTef2J
         ZpeqAhEJMfFjMf2qxv5IK1uCrvBUla90RuKXq5uUbckpV7SibljCcoWSBmTlqWExg5E6
         4BRuBaQKi6jHNdccOufiA/lBdwMeXR3TYANik49Wqm7B/PVzVHaooyA80MQ11lOo70Mr
         /HX2dVOXmKWy+ja0h8HbhR2G35UBJ2TVA+W9JjRQcGLfDveK6Q6bLD/HJ91yGFfp4Ld0
         /0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBF0H0DztW7+LbpLr7Z5t5wlqhA7pO1cuRj1XFutUYM=;
        b=ps9SdzD4FzvjFQy59HVPVk39CBdPRCYbz7dNqrQtkzkmQYg/5NlqOBakTcbSJN68xV
         9F1MsbOty/i37ir/Aa0MnYxUz2fvK6PIiKBTD8h1wl4aMwq/A1gRMWSIHTXoJT49v0uY
         XKUANQ/3NzhZuFLsf/gjLPIq1JuLbYOYhv6+PYUUMbS4sW9mA4W59+p0/TxvPF54vOwS
         flY5VxLJp/SuTEwtfu92PYe3ClzIC3riWLcSgByK5l8Dy+j4EU7Tt1Z5dYhsBHBjV2nC
         ys34/m64Ma6QEhQP3xcorJIzOff9CPJSEwrtTDBuNd1kGKvdZXXI4U4VaeKWDcC3Y/nj
         OaAA==
X-Gm-Message-State: AOAM533g2yQgWu7lDOUSQYzurxaHXq8MmIMjh7zlft4+YtxC55+RSttR
        rAB/hU6SGKV86mvafUkCcd4=
X-Google-Smtp-Source: ABdhPJxci412hAReghUeY8SU1703O3GBsM+P0/wNOxvpxS91IomkF8vWZbWlLTw9swERatFlHfUcQA==
X-Received: by 2002:a1c:6089:: with SMTP id u131mr9894740wmb.187.1610732499469;
        Fri, 15 Jan 2021 09:41:39 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 5/9] io_uring: split alloc_fixed_file_ref_node
Date:   Fri, 15 Jan 2021 17:37:48 +0000
Message-Id: <434f683bd6817dd282555ab0fbef872ff145d840.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Split alloc_fixed_file_ref_node into resource generic/specific parts,
to be leveraged for fixed buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6eeea8d34615..9a26fba701ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7723,7 +7723,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
-static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_ref_node *ref_node;
@@ -7739,9 +7739,21 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	}
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->done = false;
+	return ref_node;
+}
+
+static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+			struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_ref_node *ref_node;
+
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!ref_node)
+		return NULL;
+
 	ref_node->rsrc_data = ctx->file_data;
 	ref_node->rsrc_put = io_ring_file_put;
-	ref_node->done = false;
 	return ref_node;
 }
 
-- 
2.24.0

