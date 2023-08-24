Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F11787BB1
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbjHXWzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244011AbjHXWz2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:28 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EAD1FD7
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-98377c5d53eso33868666b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917719; x=1693522519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUl2RRSOOJ1zzBFK6rQynnQ5/OpqN87Xbc+dPAhq4HU=;
        b=Ecu7Kq/kP7NS+7KT6NUec09qbeGoViEs0Hji8YEosb2ZHpaFJ7OrPAWe6urZD0Y617
         bDpAuBIwIDhhdbyrrW/LBimK9BIX8NNrGDyOWlCZKSsCjVVVuIafvt6MQe4hDVP//JIG
         NcwjqtAFQqlfJa6pYFxE7mAisScC5mhDrjaAn9ef0PWPxoJiTlNn1MJH08QaixXiTqjc
         Dj0zOSPBqyCThHm5+RnezRebaEqsZnwTQiYwZ456gEamRrJPS0wi965j0lhkJE49s0vR
         pRqS0SInfq7253gKzdat0cnyVmb5mVE8Vzy4m6rFW6w/qPUsj80IZ4mcc4QWpq7i5C+C
         U7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917719; x=1693522519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUl2RRSOOJ1zzBFK6rQynnQ5/OpqN87Xbc+dPAhq4HU=;
        b=fMWBmJFkLeQt5D9ynAsIOQ4Ege7+CQgB7vBTU4LzJhpvLL89Org49VKZ0y3X+gyOXm
         +qr9pucIkpnZ9BFf59TLJGFfGPgiG6l2wFkLSPsd8IZ3zWP7zRdiDGvGNDk8ZOKfL/y/
         kjZHEybx59cq+OEUKk2Calm70c3PGZI+EUwNQh10MynM2Y5Cv216u9mPOLvXqk3yet4k
         JP+eCk5q8AT3iIlhrmvYyIy39wA06AsmLMI3w3NKcbsEjMOwS+HR4WUyNRhOt4q5MAfX
         wbESaQc/xlhdBavgntzTKcrLlf4t89F50n1LubBjq/oQ5oxPffe+L7vdIBOwIGYuOfdu
         zzVg==
X-Gm-Message-State: AOJu0YyCr2a1MmWHPCra+8RCBxm2/2ibDu1Gl3HykY4D/Q62JBpMBq5c
        lA3JQzCEiIlVeHRJGRhQwdM/1uteJS8=
X-Google-Smtp-Source: AGHT+IFf410cCv/xJNu379+Qmg18Ad+/Mwj+tl/b8Mb9yS+XqA5kuaMQ3Skl8N2MLU+7mEJxTLxlCQ==
X-Received: by 2002:a17:907:2711:b0:9a1:e66e:b69a with SMTP id w17-20020a170907271100b009a1e66eb69amr4099791ejk.21.1692917719517;
        Thu, 24 Aug 2023 15:55:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 02/15] io_uring: cqe init hardening
Date:   Thu, 24 Aug 2023 23:53:24 +0100
Message-ID: <b16a3b64dde678686460d3c3792c3ba6d3d1bc7a.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_kiocb::cqe stores the completion info which we'll memcpy to
userspace, and we rely on callbacks and other later steps to populate
it with right values. We have never had problems with that, but it would
still be safer to zero it on allocation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e1a23f4993d3..3e0fe1ebbc10 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1056,7 +1056,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	req->link = NULL;
 	req->async_data = NULL;
 	/* not necessary, but safer to zero */
-	req->cqe.res = 0;
+	memset(&req->cqe, 0, sizeof(req->cqe));
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
-- 
2.41.0

