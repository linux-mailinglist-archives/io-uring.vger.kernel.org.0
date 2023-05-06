Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93166F9108
	for <lists+io-uring@lfdr.de>; Sat,  6 May 2023 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjEFJza (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 May 2023 05:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjEFJz3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 May 2023 05:55:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44ED61BC
        for <io-uring@vger.kernel.org>; Sat,  6 May 2023 02:55:27 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-50bc570b4a3so5212513a12.1
        for <io-uring@vger.kernel.org>; Sat, 06 May 2023 02:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bnoordhuis-nl.20221208.gappssmtp.com; s=20221208; t=1683366925; x=1685958925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Zp0g8EVdGMmY8uSMeuwsRh51ediJMyuUPhX+LDF0To=;
        b=iyaOjd1aqCjHhe0KSwhsZb/A2YqTKgc5vjmJadoj4QnVng2X2MTZQsQtgQL2gPKXRY
         2K4dRJB3uT5au0JCO6WpJ3hPZP2mXjTDw0xQ24A/t2sZE9M1Xx7Qpl94Zo7rAdk3W+rj
         rbpXxFuwc0y4sNGEeA3gQmM1hENwmvGhT2aAc/RfJREjzszLGvVsRpOtrVk0tFWWle0f
         pE51qyQ8WrMYSmkdQ7UM1YuPf0nzgjTyooGiFf7FUxUBSv5azLbv1qX5QdCjf6fbG7Iy
         pIFgoSijpBJVec43182XiON1UvRKWns5sMV3Xmkjc9VjqRAFRhR6KWw4fZiyJm1gZeG8
         ELGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683366925; x=1685958925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Zp0g8EVdGMmY8uSMeuwsRh51ediJMyuUPhX+LDF0To=;
        b=gMwIzuZa0wzwZsGb9P8RnSTmSrwL5K5yDQSS+BT7QMNFs4k3TjlYwB0fuZuvYqqxx7
         1RCqL1tZc0u52JArh+1EcRdAnWiuE/kcDX0vj146CfWQAerMC0vYsGXVfgAyTDQIw4EZ
         uy23MRAB2Oe/JlaL1xZBTb8xmpXc+P79H3OaVxhhLvDTksf/O6WkHsBgb5eRojCe4FPB
         uxA1xmfMPCvUJWmYuMtfshfCOUk5DbrVOGlsDPBYHcsBsPuRN2vPHn8j/4nGyVnHsKF3
         xBdjOWpEupvAimZ3oHpovK4IaZa3+vM1gZImgj1MDgqeuu3KPeUFh/bO+9c58OMs+KWn
         Aeiw==
X-Gm-Message-State: AC+VfDxZjcVxukQBCaKvu2zSp/kIoDuGXY2Jceazd2Pa5hoRzQeyCIIu
        fg5+oox8pJ+3toslnq9jSS22uNNlo+/DVB+Zlgo=
X-Google-Smtp-Source: ACHHUZ53FOhizY6/QO54Rw9p86h3Ke4Er3fsgR/IHdnzkhG+NJ9/KVs+1ryklbvzDsMVeHqzE49yDQ==
X-Received: by 2002:aa7:c950:0:b0:50b:fb85:8608 with SMTP id h16-20020aa7c950000000b0050bfb858608mr3457927edt.25.1683366925448;
        Sat, 06 May 2023 02:55:25 -0700 (PDT)
Received: from bender.fritz.box ([94.231.240.204])
        by smtp.gmail.com with ESMTPSA id s16-20020aa7d790000000b0050a276e7ba8sm3781552edq.36.2023.05.06.02.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 May 2023 02:55:25 -0700 (PDT)
From:   Ben Noordhuis <info@bnoordhuis.nl>
To:     io-uring@vger.kernel.org
Cc:     Ben Noordhuis <info@bnoordhuis.nl>, stable@vger.kernel.org
Subject: [PATCH] io_uring: undeprecate epoll_ctl support
Date:   Sat,  6 May 2023 11:55:02 +0200
Message-Id: <20230506095502.13401-1-info@bnoordhuis.nl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <64e5fbc2-b49f-5b7e-2a1e-aa1cef08e20c@kernel.dk>
References: <64e5fbc2-b49f-5b7e-2a1e-aa1cef08e20c@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Libuv recently started using it so there is at least one consumer now.

Cc: stable@vger.kernel.org
Fixes: 61a2732af4b0 ("io_uring: deprecate epoll_ctl support")
Link: https://github.com/libuv/libuv/pull/3979
Signed-off-by: Ben Noordhuis <info@bnoordhuis.nl>
---
 io_uring/epoll.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 9aa74d2c80bc..89bff2068a19 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -25,10 +25,6 @@ int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
 
-	pr_warn_once("%s: epoll_ctl support in io_uring is deprecated and will "
-		     "be removed in a future Linux kernel version.\n",
-		     current->comm);
-
 	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
-- 
2.39.2

