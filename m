Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36EE5B6D16
	for <lists+io-uring@lfdr.de>; Tue, 13 Sep 2022 14:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiIMMWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Sep 2022 08:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiIMMW2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Sep 2022 08:22:28 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FA33C8EA
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 05:22:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k9so20569386wri.0
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 05:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=JvORTvNvoMPUsRno65bZWjtpNCjrcXic60bBWZSxOvk=;
        b=AzFYkaYDxUKQsBf5x1EC8sl4ZkvP5bAtivuWQQxATDydrj199Moz/YnZviK6iQ+Fef
         kP/qcEWM2/rwUxKFyNL1rIaMe5qVqPgnyA+R55OV+JzNejsveRYiO1TAwMZaqS7gfTVU
         QAb+INvvuGE4lIY6FgHAMEzRU6pDY7MVrXZUJkRPRtZa1Gnecc3B9DFrDLYyTeBknxY7
         8oXknQJ3ZvUOjRwAVRkMi/4nJNIYgr2GEkbYUCyDI1CRnxsIt1/mOWE/UoZOlPCqKKLL
         /ZePxhmGP/CJDbwFAZVqaDCHIry7AvqhDCXRWPudSTAX+o0aPvb3OauXiQAPt1dDKRul
         zVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=JvORTvNvoMPUsRno65bZWjtpNCjrcXic60bBWZSxOvk=;
        b=e1Y+DPRmXAKs//gnXpzOWLgPoMutOeQr6mcq9ZvwNwt3uwFhtRtoVc7Fndw17XUHtD
         IQkSYvzXcxw3VfJmdcMjtLYaxcKgbvXMvgbRq7jr5igFgMtTv85PxC+kqoKwkLM59rai
         k4mjGDJgw0JvPHowO9VovEjiGna31W/9pXfvR1h/Yab8Y3lSCGfIFIT0rsuqSUz7WHHp
         /mpJbw437P8W0n0Rlm3sLXqecOT1ccIIij7du5DujEfX0CPtK9U1z/G0oM4z/Q6sgm4z
         FBpT6xUXIkONwuh3yathK5C4MeftSMVCJbRsSYUPA6yFXj6nnv9vCYPXP0x978bWidut
         rwIQ==
X-Gm-Message-State: ACgBeo2JmbFjWWqeggZ3dkHcoBj3QhfCDJLNMP2t+4AG/jW3e2cGHilG
        Sv6eAXrkpl3wPH0Lb9rjidoHTCsbRygMlQ==
X-Google-Smtp-Source: AA6agR7muHVR6hMu5e1xn5LX6BSyPjuWrnJd2AR0XITZNXfWpQVxdRqsxugv8YBRe714pCbzJDUepA==
X-Received: by 2002:a5d:6d8f:0:b0:225:6285:47fb with SMTP id l15-20020a5d6d8f000000b00225628547fbmr18828194wrs.211.1663071745862;
        Tue, 13 Sep 2022 05:22:25 -0700 (PDT)
Received: from 127.0.0.network ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id r16-20020a5d4990000000b00228a6ce17b4sm10424130wrq.37.2022.09.13.05.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 05:22:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/1] io_uring/rw: fix error'ed retry return values
Date:   Tue, 13 Sep 2022 13:21:23 +0100
Message-Id: <9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Kernel test robot reports that we test negativity of an unsigned in
io_fixup_rw_res() after a recent change, which masks error codes and
messes up the return value in case I/O is re-retried and failed with
an error.

Fixes: 4d9cb92ca41dd ("io_uring/rw: fix short rw error handling")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1e18a44adcf5..76ebcfebc9a6 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -206,7 +206,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 
-- 
2.37.2

