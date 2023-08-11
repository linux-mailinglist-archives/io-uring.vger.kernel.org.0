Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317B6778FF1
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjHKMzO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHKMzO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:14 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F305D114
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-99c4923195dso270795566b.2
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758511; x=1692363311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xViQ+UkUWQ0OXWR1P9K62Qd578cNB7ZDE1O1vUIN/qo=;
        b=shUpGLPyFf8zQn6qw22UJYkIqOF+D2gro1W0m5PPXAkb5YdgVM2I/pbL2uxDZ3brTm
         JTCBI+I2oc3qdcc5i+NLucRPwuIF4OBcumcAgNtj/L54qm5zx9YS3IKJa6glPcD5qKU9
         KCOOyzp3PmEWEtVkfd8XGZrptK6IvyKpze88YOxUTA1CYo9BZ5pENh8gx/Pjvd33uMer
         B5vILywQig8DHdyCzaM/YuSVBbKAJgkhl2pNiY1o9E5qqeMfXu5fEbLuuCFr0p1fCG0B
         GGnb5VZbh9bor0qY3DqXnSFj0y3pllePC/XQMrWNrDh33Ceap1SqL/YIZzhctHMMHLL6
         nDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758511; x=1692363311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xViQ+UkUWQ0OXWR1P9K62Qd578cNB7ZDE1O1vUIN/qo=;
        b=Jbdw9mNINHoJlWoT+UBvYIjTd9yQTzZLF/rt9pbo751qaqmwMiOvoE60+crqEWO8fe
         b66MRC8A3LTCmNp/2S3rEgwSv0L7fhzauZR41bLE1sfVWcOnPTf7QpPtWJO6oOD1lhuy
         h7phBbpLjA4j7hFaicnNrk9D1Ng+3CjsSwyoSnQCBJwS4hhaMzxfiI4Hv/SVPuMVBihq
         w7rfixCM5p/eaQ0kMD+3YWf/3ZtuWcZkAs34kjqor76hSwA8ZPwCaCmN9uM5Ql4cKdik
         pYQh7qWhTImV5ny9j63a2uBjwg3Mmp1BZJS6lOVD+GyzknfC2xEaE3QGLSbKVR9+QHk2
         qXyA==
X-Gm-Message-State: AOJu0Yz1d4FiX/6+byAfW0/lBStVjk4kEI3h0jJ2RBS+xNKM98d9cHtV
        Zs8HEnC7IiVsC+ugI3Qx2syQZkGkk90=
X-Google-Smtp-Source: AGHT+IGLntDlh/d7T3z+iMePP2P+zb/maxJeE2zAEHDJOHl0ypAU6XduapsDCwMrPL5ue7SGegp+jA==
X-Received: by 2002:a17:907:270e:b0:99b:bc51:8ca3 with SMTP id w14-20020a170907270e00b0099bbc518ca3mr1686677ejk.1.1691758511186;
        Fri, 11 Aug 2023 05:55:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring/net: don't overflow multishot accept
Date:   Fri, 11 Aug 2023 13:53:41 +0100
Message-ID: <7d0d749649244873772623dd7747966f516fe6e2.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
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

Don't allow overflowing multishot accept CQEs, we want to limit
the grows of the overflow list.

Cc: stable@vger.kernel.org
Fixes: 4e86a2c980137 ("io_uring: implement multishot mode for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index eb1f51ddcb23..1599493544a5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1367,7 +1367,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		return ret;
 	if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER, ret,
-		       IORING_CQE_F_MORE, true))
+		       IORING_CQE_F_MORE, false))
 		goto retry;
 
 	return -ECANCELED;
-- 
2.41.0

