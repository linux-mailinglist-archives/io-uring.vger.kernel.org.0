Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7EE513FA8
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 02:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351229AbiD2Aqw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 20:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbiD2Aqv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 20:46:51 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F0C972A3;
        Thu, 28 Apr 2022 17:43:33 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z26so8254122iot.8;
        Thu, 28 Apr 2022 17:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xc0ET8Batlb6U/Lg0I9CS2P6YAlMdChkuQuGfUJdrV4=;
        b=XBDQ9UQndwImYPyBveiw9mLb5HIMyJ8CS2CVm3JqVe36/CQoGL2O9nHXFKwU1hH/RE
         srYCEBiYlUmJ3V1+cHJfWE6uKBE9I2DxRv/AQ2YFJiu5mdxyk9g9sjUFvLpBbX9FKhLV
         hTv++pnFSDW58TtXUfjdcwES3JlKsUj9Bbl8xP36Zk5EdocRsUQ4Ui14jZysEPhgUi8s
         qzMxsPc3Ez1Vcea07IGWflZ9f7le8MU9XoeZmXC9aU6+34kp9I9BVQqdy8MZwAHBWCvP
         DqCikgp0HR+jgxYrlGgAmnsvOcoHC15L2W4MUwfLJ7kV9aWPPpTiuvVGOW+/WOQMrXX4
         Z1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xc0ET8Batlb6U/Lg0I9CS2P6YAlMdChkuQuGfUJdrV4=;
        b=6W8Pnj5yrL8aUYiqsZ+4ZhLB9orEXDHAgyIy8+C/eNqaeDMQINwlSUJiEhqY5mwleq
         JWQiwdcky7q+OxhJG5ST0KKj3JsufaNA807L968HLZAnc/8KnsZjq5iZTQektBQUTNsw
         Oz41w7pPl5WpUwfaVxTi1d8Q41Wyn519WbaSFGg/ohwhqnARINxuBwdWVAn26dCuRNWm
         HIVO8fmCtW1YSxz9c2z9HSr0r5sVBmvc46X6R53ndHLBEWDeIdotFtfMPdEWRIqJhNKK
         tYN1jdA0chThri+J+mk1F/toojqeoJFEa02+cGa936GrsmMIa5yavHELpu6jmU6HchDE
         V41A==
X-Gm-Message-State: AOAM531qe46wj7/89vrf+oRJxF/mOWnZP1WCEXsogPRfVQWw8D/lXYiO
        oedkWGfj1NqXLhJ+6qsPvC8=
X-Google-Smtp-Source: ABdhPJwx4W+My2QTL5LGVwIKMcLHUkInIP3RHfhzx12TTm7rgrZExQQU4ZUoUODtaESA812DXk7j6w==
X-Received: by 2002:a05:6638:491b:b0:32b:2786:cb23 with SMTP id cx27-20020a056638491b00b0032b2786cb23mr3601703jab.214.1651193013318;
        Thu, 28 Apr 2022 17:43:33 -0700 (PDT)
Received: from localhost.localdomain ([205.185.209.216])
        by smtp.googlemail.com with ESMTPSA id t3-20020a92b103000000b002cde6e3530csm134006ilh.86.2022.04.28.17.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 17:43:32 -0700 (PDT)
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] io_uring: Fix memory leak if file setup fails.
Date:   Thu, 28 Apr 2022 19:42:45 -0500
Message-Id: <20220429004244.3557063-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If `get_unused_fd_flags` files fails (either in setting up `ctx` as
`tctx->last` or `get_unused_fd_flags`) `ctx` will never be freed.

Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
---
I very well may be missing something (or there may be a double
free if the failure is after `get_unused_fd_flags`) but looks
to me to be a memory leak.
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a3b76e63f9da..9685a7be48e3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11863,7 +11863,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret < 0) {
 		/* fput will clean it up */
 		fput(file);
-		return ret;
+		goto err;
 	}
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-- 
2.25.1

