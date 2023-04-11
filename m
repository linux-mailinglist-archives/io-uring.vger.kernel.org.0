Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9A6DD91A
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjDKLNQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjDKLNE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:04 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA3B49E9
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id q23so9873161ejz.3
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8pcSBrPZA4+KOGPAVzPd/1ZLXVHdZRqUya+mQQiFKg=;
        b=TQd3SyFcmcVoIk4NmthibvfpDp699QsT+7U2cQ7naTnXbjGiM/Pkkjqq+FfGPdP2F0
         UpfL2IgmbPlU8m+o8u3XulPTHmSUtMYCWe0Sc7Dq8hZFjUZQrCWILv9EV34BjNgKcBFO
         ezcYXR5QNEE+DJtajZ8Q2KnG1BYUReS4H0Xsa1FfETLhJyWtE0QFWnOATZzuxhqWvDNG
         vKCxdfR8z7V2uZHfm+IsZ5bMt/wsrJJWla60KtGavLeryxp1y8IA7OGVsgrlDSuZGnMz
         OBd5CIwZC/8gNb+fmxxK3OqDSbue4HxhTtx7tZ8ekdVzLHa0Q/mSG2xflo2D+/u1cjp/
         Gl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8pcSBrPZA4+KOGPAVzPd/1ZLXVHdZRqUya+mQQiFKg=;
        b=wukHAIS7GCkmNZxJ1L0XC+xKLpxy9hgg3VechZZ+rQaX9POKcrQ66nN+wSdHVWQIAp
         9/ajYFCQg0/KidgoDSAADqaUv3v6oUwOl4VHYpdDX6o79wLd9pRoJQUWUxd59upLOr86
         CyNi1ZcgEYTwgXX2vI7t8wo7/1MPHlzkxxcId2vGZ9a/CVyw/Dpp+nn+hvkR0GESqmPZ
         p8/RMtFUtBNOulya7hirumqb2mdy9Ddh1DiDRvmZcuIW8gugImP/kQ3lFhu9SBuB/35X
         bXswM3QFPQx4I0T2AdbQu9P5e369V6cQQRJyG9iyq1jlUgIOHh1nPaXhkTiP4YWjQnnk
         odKA==
X-Gm-Message-State: AAQBX9cQbtRSuvX5TERhAlR/2uEvCDnNihXjz6DXBjiYV9OHWFeDb5Km
        U89KEImFAyx6y45YS0sV+CN7Ax9Nhyc=
X-Google-Smtp-Source: AKy350aWfjy48ALIIlUCN+3H1wujd6rxoVtKmhAGt+u6PTWSRXV3yy2GyCTy8xSOn6mVtEZkaU1rqA==
X-Received: by 2002:a17:906:c206:b0:948:112e:c49a with SMTP id d6-20020a170906c20600b00948112ec49amr11484625ejz.24.1681211570020;
        Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/8] io_uring/rsrc: zero node's rsrc data on alloc
Date:   Tue, 11 Apr 2023 12:06:06 +0100
Message-Id: <09bd03cedc8da8a7974c5e6e4bf0489fd16593ab.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
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

struct io_rsrc_node::rsrc_data field is initialised on rsrc removal and
shouldn't be used before that, still let's play safe and zero the field
on alloc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 73f9e10d9bf0..329cc3851dfd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -218,6 +218,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 			return NULL;
 	}
 
+	ref_node->rsrc_data = NULL;
 	ref_node->refs = 1;
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->item_list);
-- 
2.40.0

