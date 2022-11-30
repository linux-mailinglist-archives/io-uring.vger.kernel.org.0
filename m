Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD563D950
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiK3PX2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiK3PX0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:26 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3510872082
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:25 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id o5so18614763wrm.1
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmyl7LkvaPhzlhUrU0LzfCAM48z0JEbH4UQCVKBCzOI=;
        b=CjfiXD0wsH9piZI8ulENctV8dpWYqMhtsbfujUQ48h8FmANWxjJoasDylJBxdFOf+y
         IM4EGfVUfgQMuv+36Vxx3olcCDFRv5QiKEsUe80TlZ4IDrzbfNNujoptDQ9nmt6h3+Dm
         NhvTdmAHvssGaCw3/Pkxc/9HS+5p0jrtnQF5B42qWF3dUGrFNr/EtgWIN2VXQ2EWdDfR
         EvkQmzfPrRVhpGklIjPUpiGMGz10VOZ+LvRA/btXKluxVF+mtFiVhowIQJXtW2l3hACh
         /ccMX6RNJP2YWH89BB3AhTWmHqhGU7MAq4LYG7RJA9yFEwo+p3c7/Gtpz8mu8k0XtAou
         D8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmyl7LkvaPhzlhUrU0LzfCAM48z0JEbH4UQCVKBCzOI=;
        b=R5nz5hQcA5BAQZlWZN3VDF9lxLpyqf+krf0z11toreTamU30kxXxrOCTRV+GOKgL/F
         9nRh/ktMHGsPxYtOmnK/ogD4wKNN4fm6BM0xcIKDWzS87NC8XEfEPv3mZxsY5FqCzERj
         wWJWA8l2ncT8Oy+2LKxLwntPU7Xg9/foN+QeR6AtP5s7Fjx6xKbYY7ThIMOn4aaqGErl
         Ooy+6PE5CprulJg8XA8ifTfN3q6z9RcKcltcMuG30HEvS+DO073N8S66qxwUIbIT3847
         k5kdvh+eedmk8QjRTaFqYxWCog9nYe2p6fS+3LvibnMqbjc52+7H5ozCdU6cT4b+VAD0
         GqZg==
X-Gm-Message-State: ANoB5pnWajcehirrbEhDa0rpRwlJAQX30OQlaTB8q8n+FICIM6KgX9wM
        vjrUV6YOFV3POZme4rYltZgrxmeyn7c=
X-Google-Smtp-Source: AA0mqf5ML+UX00idL1nlEFtWsX6hbLqB7yi9GYE7ISn3ZJef6TKIg1QJNgjCevMfVqPLFLldY2q2PQ==
X-Received: by 2002:a5d:61cd:0:b0:241:f8e3:7111 with SMTP id q13-20020a5d61cd000000b00241f8e37111mr21165472wrv.299.1669821803585;
        Wed, 30 Nov 2022 07:23:23 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/9] io_uring: remove ctx variable in io_poll_check_events
Date:   Wed, 30 Nov 2022 15:21:53 +0000
Message-Id: <552c1771f8a0e7688afdb4f538ead245f53e80e7.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ctx is only used by io_poll_check_events() for multishot poll CQE
posting, don't save it on stack in advance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8987e13d302e..ada0017e3d88 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -237,7 +237,6 @@ enum {
  */
 static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	int v, ret;
 
 	/* req->task == current here, checking PF_EXITING is safe */
@@ -289,7 +288,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
 
-			if (!io_aux_cqe(ctx, *locked, req->cqe.user_data,
+			if (!io_aux_cqe(req->ctx, *locked, req->cqe.user_data,
 					mask, IORING_CQE_F_MORE, false)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
-- 
2.38.1

