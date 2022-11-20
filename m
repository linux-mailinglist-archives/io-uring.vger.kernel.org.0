Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC29631583
	for <lists+io-uring@lfdr.de>; Sun, 20 Nov 2022 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKTR2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Nov 2022 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKTR2P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Nov 2022 12:28:15 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4DF275
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 09:28:14 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id w23so8618006ply.12
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 09:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PFYeB16E8OQeb3PH9IjjhzmkhNWhHwQwZNzRu+UA0Q=;
        b=dCxZIiOHkwbwo5XNI4H68fmTG4oB1Ws5wPLUZKh5+mTC/48TuDgcneIlTt8i1L/kep
         VsxiRlO1MEsVvDNiCdOobUARKsehLLMkKarPLMzMW++gmiOWIfgsTYM7cok7dEFWvXLA
         R7DJUOM9j4icjTpUQVjZKpcQ399jd66aEdek1AvB8Vh6zQAs18JtV6hVivMvqqfbHRXx
         FfaEzKchY4d8W4dIaX/Ax0aDxvQyYRDLq6MSir4Hbz3ctsQOdJ0iSOHmzW4seSTTWlWr
         ul0tC7MSGlnYTVvlRoizXX7R1q5JHRuPdq+mQrK7bXnk1ySW/1WZh/iH+b0/kyDY1scA
         aszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PFYeB16E8OQeb3PH9IjjhzmkhNWhHwQwZNzRu+UA0Q=;
        b=twUpk36pSukshdoduzLXL649iuz6CVPkQZvqDap8el+VbsM+xoK9L4zQmH+aiEjmLt
         4b17m9RmiN9EPE1FlFf/nR63dk17+vhW7ShYVKhXLT6Rl+m9dXXJSQw0zZWfK8b30Msa
         4mDNIVVmYNbQMPzif+x4vjE0Ul5eWhn5BxuVNLehnBoIJp/8BXgGwbHnLdbEKb1TTBam
         wqkRtrR9jr/CwsNZfYjh1tiqJuLu1EK6Ht2AtTubKt6dq8mQ3PzmbsVHo5p1Z2pYJvta
         en6Z9pt5HqXZhHa70INRNnewA4m7n2pMny9UPWPPz6g0t4NacOtNA6OcRv3XiZHypwpT
         7iUw==
X-Gm-Message-State: ANoB5pnKi2k3Wwm5Vz2zF3CDSWzyehhioM9BrY9mp1AsVJIxmeeLd7/Z
        uJkTzGjtDkmbN3d9/6wUxhkL2DyCPNZZPQ==
X-Google-Smtp-Source: AA0mqf4N9SralDyhqe7mXeyNuD3r4ax1RIwjl0w0y/M62wlRvR0MriYA8b1xKzn1JUOyUcici9sW1A==
X-Received: by 2002:a17:902:6b07:b0:186:df61:4693 with SMTP id o7-20020a1709026b0700b00186df614693mr1646301plk.173.1668965294106;
        Sun, 20 Nov 2022 09:28:14 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0017e9b820a1asm7876953plh.100.2022.11.20.09.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 09:28:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] Revert "io_uring: disallow self-propelled ring polling"
Date:   Sun, 20 Nov 2022 10:28:07 -0700
Message-Id: <20221120172807.358868-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221120172807.358868-1-axboe@kernel.dk>
References: <20221120172807.358868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 7fdbc5f014c3f71bc44673a2d6c5bb2d12d45f25.

This patch dealt with a subset of the real problem, which is a potential
circular dependency on the wakup path for io_uring itself. Outside of
io_uring, eventfd can also trigger this (see details in 8c881e87feae)
and so can epoll (see details in 426930308abf). Now that we have a
generic solution to this problem, get rid of the io_uring specific
work-around.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b5d9426c60f6..5733ed334738 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -246,8 +246,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			continue;
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
-		if (io_is_uring_fops(req->file))
-			return IOU_POLL_DONE;
 
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-- 
2.35.1

