Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAA46D08CB
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbjC3Oyv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjC3Oyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:41 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F5E469E;
        Thu, 30 Mar 2023 07:54:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l12so19362276wrm.10;
        Thu, 30 Mar 2023 07:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKfMO97Puxbxg9b5V2zEzriSKSgWDMsPXMYWqPT9qnU=;
        b=NY7Rm6tRHFZ76SKQjHQdrDnj9n2jWzPmsbsXRr5sKH2eH3gRHQlQaR4Xoy5egkkK3c
         EGB/hzWp1i/3AzduUWZ0JfogkFiG/lN3KpUiFOWNOj0HuAABld2CwxHAYYR91+cifYln
         lLkPPpPcxJcB/9hItQ8keDXeLXji7HIwIybnBFNggrZtCIS5IwaZYLyw+ykua7UJmNwc
         jumPip94qNG8lZOkxUUzU8YTEBlEIkRpRgMXlhTiDkvZUBuZ4Vy/AsMWi4vfnLGJn7+Y
         of2tdDBRpfALUs8LZOZoKBAM22ckJDR5ThRkc3GrCWEjvxS0GdqOQzIw72A6U6d2B1cS
         xdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKfMO97Puxbxg9b5V2zEzriSKSgWDMsPXMYWqPT9qnU=;
        b=rnOztK7g0qXOxoferby0TlKXPJE0sR8f3Vf9pWOMbMgoaM7GAZOt+m5j2vRU+ImoeH
         Rgl0wKkBN7/HHitMojaD1+MbZ9QXNaDvRBaaEsTYETz0vmpynM3glevcuFRAWAqFxB4a
         NaesG+542U+xeRDtIYY3pBSttkQNW+WegNEL2kfloxkzkBiP533cPTtMdKN9DGE9+dck
         QQ0mPuUHRiV7vDU3gIhDqSKQ+G87Lm5FPyLIDNVQht36M15bb9PEFKSo2HpO64x7Y0j4
         5qSwOMBsl25mTIEbscG9MEEYJZGqT5hI37a6y+fvo3Ty0PwzZCyMPNAzRV8XENJRk4Uq
         bYjA==
X-Gm-Message-State: AAQBX9ecNOoehB6Rh6UIDnDjU+HRWCUqGXI8TyLDIF/0sy51yFCz4qib
        tmFSvpk0OrpqLIFEn5ztbxevWUxComM=
X-Google-Smtp-Source: AKy350bQ2GkJl2HDcIMYZj5AAqTY05jsUSoyx44ho7iOR7A3DUp83IYa9NPnl7OD3yU2vmXXWOB3+g==
X-Received: by 2002:a5d:500a:0:b0:2cb:29eb:a35e with SMTP id e10-20020a5d500a000000b002cb29eba35emr5127532wrt.11.1680188077486;
        Thu, 30 Mar 2023 07:54:37 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] io_uring: io_free_req() via tw
Date:   Thu, 30 Mar 2023 15:53:22 +0100
Message-Id: <6b0c640860a6250abf883840b160ccd50fd5f311.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
References: <cover.1680187408.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_free_req() is not often used but nevertheless problematic as there is
no way to know the current context, it may be used from the submission
path or even by an irq handler. Push it to a fresh context using
task_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c944833099a6..52a88da65f57 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1116,7 +1116,7 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 }
 
-__cold void io_free_req(struct io_kiocb *req)
+__cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1130,6 +1130,12 @@ __cold void io_free_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 }
 
+__cold void io_free_req(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_free_req_tw;
+	io_req_task_work_add(req);
+}
+
 static void __io_req_find_next_prep(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.39.1

