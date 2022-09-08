Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0135B1CBA
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiIHMWr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiIHMWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98221F6B99
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:37 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so37674684ejc.1
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=D+ecdhJlRbp+3w2pEHxMWQ4ag1rTO2U6MFY9gi4eQAE=;
        b=pm+jDTOXOeHux5XVYr2rxaUQ3BWV7Uk5d+iS8s4CM1bkeHQMVFX5XTEF+8xSs55xz3
         00pn8Jl42gsiisa1NRvLxafG+o4gulmf9S2AAw/CbHHeDQ2KbCBuCfp5cVki1/rUhXWR
         42ZLdlgUZ/bLg8LwRaiZ9w+ETOMuQhzK781mjYHXEY4r3sGjqbvmjjwZwUMeFldKzSYi
         b8hQHYsOZFxS9NqdiY0tyn8gkZrCkw1WsEqbWJOUisFLwZRdtv3bdnObhXLTTJkmxBqP
         wJbA/cKpy06kadpOe5FwcgwvCbmGssKvEGmDvu6hUdmyCDvHlvdgt7q7rE9Sun16FkIO
         jzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=D+ecdhJlRbp+3w2pEHxMWQ4ag1rTO2U6MFY9gi4eQAE=;
        b=6LUlLhsZRRpZXmQzQQKK8j/YrzgoDDA1qZ15LrmEiyqz0UWxQuFyxeDxTHaObW9dxt
         SY0TJOdFYRshL7ngxuo6gPrzmAiken3OrB8oKcvOOUxDOFs7J6K/DRpHmxE+qwuS/sWm
         RnvNkjybX2Cl9/tFy72vZoPQaa0N+sMVacxXNGLymqtuIGzDYFu+JyIPtz3ncoONIrhu
         DcRpQGKxEV3dO6wBdBEd0g3E5Y73UJRbHskyCSG6aMCEvV0ACoKIpStwJV0onA0r44jx
         PZl7WwS1PVk0Fm3RNOZywrZPSCqRFWo54OK8JHDzOjnN/YAnccFxpFnHsWnAQH5j4Tkz
         9zUQ==
X-Gm-Message-State: ACgBeo1W9mXSuvzMEgpqR4mzlqyNY/a6yoci9PmPsgimuPL31tyRMNG1
        BJNJoS63/WVQAMhpGt+8h8tG3pXIofI=
X-Google-Smtp-Source: AA6agR5csa/8f3C/oWGsD/7gKntbzhYSSV4Ix5Fwf9I4dMgGsmkLs32js8xu3xWCT5tqxEdbpG6omQ==
X-Received: by 2002:a17:907:e89:b0:741:9f6d:fb88 with SMTP id ho9-20020a1709070e8900b007419f6dfb88mr5926454ejc.597.1662639755111;
        Thu, 08 Sep 2022 05:22:35 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/8] io_uring: kill an outdated comment
Date:   Thu,  8 Sep 2022 13:20:27 +0100
Message-Id: <38902e7229d68cecd62702436d627d4858b0d9d4.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Request referencing has changed a while ago and there is no notion left
of submission/completion references, kill an outdated comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0482087b7c64..339bc19a708a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1885,10 +1885,6 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		/*
-		 * Queued up for async execution, worker will release
-		 * submit reference when the iocb is actually submitted.
-		 */
 		io_kbuf_recycle(req, 0);
 		io_queue_iowq(req, NULL);
 		break;
-- 
2.37.2

