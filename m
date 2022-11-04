Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A030619514
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiKDLDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiKDLCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9222C124
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a67so7016880edf.12
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTMFnPh1n90Hv/m+Li9XRv95Ppzz2u2qp0OsR4mKGF0=;
        b=jIQcxt0sQTe2ZHqDQT4pUMQ0X7a3QaTCDhtMHrFsrFyY/xJ3kIp453/TVtj8PBuves
         D9LrFhf+eGIqbc+6DjgXrRqyUMdLMeR0YCH2TZXKQ6hvITkn831sLx+nPKcozPiO5sDK
         c7Rah8P16FMJK36VBZC/VDLoyluxghtx5dHE4BXqbDDeKhM6lKLlzWvcbeFjj/ilvH9c
         BTdb6FpJI+Loz5KzXs4HoogDeWoHJIMU6hy32Rj40tIZCcvkln4p0gwxzHg0Ipf0HRrl
         2J5iaCs/1zY1fv2fhSF5KcPaTZuOPYyoR4iOl5TaUwjAXse3Vs2A+NuS31rdk4b18BJF
         v4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTMFnPh1n90Hv/m+Li9XRv95Ppzz2u2qp0OsR4mKGF0=;
        b=Fa4zcP0yXGqrFXC3xRLKW94vQaodLWOCOreejl1ZLlPKdfEnb5i2Qoa6GmrXE0EbjF
         EK2oxOve8IbiDkzR7KYepGEkWqSzgmjbZf00x8Pjyk0mfRKhpgUUyvFMubnoToK+jUXE
         M41AZ3Ca7gRiq1cKQ2dtqFlxiE8AGSoU62QSDE6b6wyztcwtfe7r8d7DvzXe56r3Kp7p
         F6xMMIYlsnw4YpQ/MLZozK8it3pgcPmt2DMJWxyMmUIewwR0duwqYjrZvlArpvjRQawo
         1OldZWMngLkROusQHzT6IAj4eWq53fr08O3U9YpuOFURKwa7BNq2JYpKASlU7crahnFQ
         qT4Q==
X-Gm-Message-State: ACrzQf2yHSHDsr4QyJND9PR4dvIMC2CTAkcMSazanZ703eEXGLahyr8L
        Imib946rO4jpJTSf+dpUhhmDV5/fj5s=
X-Google-Smtp-Source: AMsMyM6UjdQcswrjB8AYRRgEv+NGQxHB4xscMhVDEeX8fgV41zuX3pZx2Y6afxPUhVBdAS0qnUiutw==
X-Received: by 2002:a05:6402:1771:b0:463:c94d:c7d9 with SMTP id da17-20020a056402177100b00463c94dc7d9mr16974998edb.135.1667559750011;
        Fri, 04 Nov 2022 04:02:30 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/7] io_uring/net: remove extra notif rsrc setup
Date:   Fri,  4 Nov 2022 10:59:41 +0000
Message-Id: <dbe4875ac33e180b9799d8537a5e27935e82aac4.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
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

io_send_zc_prep() sets up notification's rsrc_node when needed, don't
unconditionally install it on notif alloc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 4bfef10161fa..59dafc42b8e0 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -60,7 +60,6 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->task = current;
 	io_get_task_refs(1);
 	notif->rsrc_node = NULL;
-	io_req_set_rsrc_node(notif, ctx, 0);
 
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
-- 
2.38.0

