Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A7C51F226
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 03:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiEIB3L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 21:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiEHXxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 19:53:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DB6BF4C
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 16:49:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e24so11673957pjt.2
        for <io-uring@vger.kernel.org>; Sun, 08 May 2022 16:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vIJbseLiUT2Wb4QDxebtpxaWDMXF6DqY3saVloRryo=;
        b=ga67mLACADlOBoSNaDQvERCh7Zqzf+tJpgGtQx72t8g82Uevq0ktWdxiBe2idoHTky
         6ZzKOFhqCMW/LkyYZpF1MK/Am5ecmjAuwkJZxXor7HGligQjXxaZT+bfiYHgc1SPNvop
         gLPfNMZxAH9HD/ZmKCLK1QqP8VsoFXClxvlMScfNjKXADCnfDRhUlJOYiSQl9iKmgVWZ
         hski6j+jndE5aUqyT1tqrFYn/5cztnlLHMtvStA3VtBhG1rsiM+FmT9c/GGEk45V0nU3
         Jt4wppJXBDI/WEmdyxOtJml8w3GfiAP91/hEO1z3vT7YpT15vMV353sWYM+HOpquqBCz
         pH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vIJbseLiUT2Wb4QDxebtpxaWDMXF6DqY3saVloRryo=;
        b=RsMAAx/la9ss/bjav98n5hWHodGdqV7sLOhRGL4hjzFQkyd01iekFC+jRg2xAww4a7
         bQ/9K9lL17KgMXwUJ+m4HGHHgx5GWWCZw1/5KSBzsmoIwd/B2Vqv2Nj2MoT4hdjzPkTy
         bXH0MjzwIDoVxpRkq5rcjh4d0J+lN57+ryYpmEzR4gLvbU6jnWU+1ezP4xspFR3X/kOj
         Vqqumw+BWMtbm52CSqONbIbkwdOF5QzPyp0adux87QpHckP70wkL/K9NVezzV/tJUe/M
         J00BgA4/DoUwkE/Z/jytpwoSAht8HZ9K9b+QY6Rby81uaKyZyb83luOI9U5vRamPL9iz
         LDdQ==
X-Gm-Message-State: AOAM530hjEoD6Mgld+qbsFKXmlVtXbcVvP/ztABBvG5n1sUOEOjjIxNB
        S6M9Up1AylN+FRYxI1CauGIrhO1ftXD5679U
X-Google-Smtp-Source: ABdhPJxd+u+H2usVmdg3w7Hq4kXFe5MKv/7GP5ciOQbnWqLtbROSWKJtRrAlX+cQrgZKihgZJEmqCQ==
X-Received: by 2002:a17:90a:e641:b0:1da:43b8:95b7 with SMTP id ep1-20020a17090ae64100b001da43b895b7mr15166687pjb.180.1652053756778;
        Sun, 08 May 2022 16:49:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a170902ccd100b0015e8d4eb2a2sm5675249ple.236.2022.05.08.16.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 16:49:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: allow allocated fixed files for accept
Date:   Sun,  8 May 2022 17:49:09 -0600
Message-Id: <20220508234909.224108-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508234909.224108-1-axboe@kernel.dk>
References: <20220508234909.224108-1-axboe@kernel.dk>
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

If the applications passes in UINT_MAX as the file_slot, then that's a
hint to allocate a fixed file descriptor rather than have one be passed
in directly.

This can be useful for having io_uring manage the direct descriptor space,
and also allows multi-shot support to work with fixed files.

Normal accept direct requests will complete with 0 for success, and < 0
in case of error. If io_uring is asked to allocated the direct descriptor,
then the direct descriptor is returned in case of success.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 986a6e82bc09..9fc38c749492 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5802,8 +5802,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		fd_install(fd, file);
 		ret = fd;
 	} else {
-		ret = io_install_fixed_file(req, file, issue_flags,
-					    accept->file_slot - 1);
+		ret = io_fixed_file_install(req, issue_flags, file,
+						accept->file_slot);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
-- 
2.35.1

