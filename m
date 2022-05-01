Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED99B5167EF
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354913AbiEAVAj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354855AbiEAVAg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:36 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5091AF1F
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h1so10919971pfv.12
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LIxyimj0VJGNnPZR4BglNnZw7ETc2pESA4G7J+Ug0Rg=;
        b=Ww5xh2nUNp3ViwHqSqj653Lhhysl03aSxPQoXiQQq8YoHquIie+l6S1S6yG5DaMwM5
         mgGwL54GY3m1wvOqYhCX5gh8d8n15S/fCwexnyZSb9lTpJ1Wl3DdmT5IzNx9aydATPV1
         o93XuP92ovTBEC9OTlcEeRBvc6i75GNw91gpgohPPDy7Aua600g1usCgLS2TJtq9xczp
         grROIU3iMmSMWZ91WVNUBrtV9O+ohAFdEOg8N7zDUUPRhGUG4eYnDCxnXySaIYWYmIhr
         AlGpZqLlHoq1Zbahoopf4lPzkiRDI9EKkv+1SxMHM8+5ur63xvgg4G1uksUmvdrOECoE
         JmUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LIxyimj0VJGNnPZR4BglNnZw7ETc2pESA4G7J+Ug0Rg=;
        b=kZ9UIVKqfrQd+Ar3udfpj+w0Z9wZAxzbBhzkaOFP7YO5+Zt4usIYM5fkFYjF/OXIss
         rMm0eOahIbKcRk2sFzJKZI7ktZz5utWtL6d+qzTBTM2m9SN3402dkZr+RdLuNgJ8U3Un
         64RhYTAx3HQQbewreuddat0psMPvT2Jc+PsBzY07/UlHXV+kVJ1gTwoeoHuCMTqrUsKo
         W6AdFGulX0pL5xU8YcYBHrP/xNWhnYg6sD07oRnxeJOIFINgNbs0Bw348STBlntOA0AS
         7WhZDewVHCDw/HYhetV6mp+TIP4xbBE8JrA6JOKzUrSiEy3yHzIpZoKlHDkYqIzX8DPq
         IAuw==
X-Gm-Message-State: AOAM531JrmTkH1L9fo4NwfrU+wm2kAipe2nNLeY3B9B5aZ4EOYFRKe2z
        cj9C6O9tBJPy3BFqrdk44YikSg66vEwIMQ==
X-Google-Smtp-Source: ABdhPJy9Oa4ch1iwJ/yhHrfUKA6jjRZZzOujpQAIvWwS1t3TNcQw0nYfE11KIXWHV01TpBQPG0DRpg==
X-Received: by 2002:a05:6a00:22cd:b0:50a:69c9:1806 with SMTP id f13-20020a056a0022cd00b0050a69c91806mr8539092pfj.51.1651438629479;
        Sun, 01 May 2022 13:57:09 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 13/16] io_uring: don't clear req->kbuf when buffer selection is done
Date:   Sun,  1 May 2022 14:56:50 -0600
Message-Id: <20220501205653.15775-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not needed as the REQ_F_BUFFER_SELECTED flag tracks the state of
whether or not kbuf is valid, so just drop it.

Suggested-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff3b803cf749..cc6b5173d886 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1569,7 +1569,6 @@ static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	list_add(&req->kbuf->list, list);
-	req->kbuf = NULL;
 
 	return IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 }
-- 
2.35.1

