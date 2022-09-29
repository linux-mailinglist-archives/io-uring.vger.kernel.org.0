Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B405EFF39
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 23:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiI2VYY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 17:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiI2VYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 17:24:24 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A462C888A
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:24:23 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id iv17so1768608wmb.4
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8J21rjsSqRuyBWN+DHumf3v8/nkIKqPUvMt2G71If68=;
        b=bsc3pHa28JnpzRswomVtotvMs0Vpc7+Byuyr9cAfE+xvT4B5jUbRAihC5YmMnxBscm
         xvrr2ESOnYzJQEBPKpjmCJjqkpyPPwQ5A3GwNZBPAB+dWaZoAlw0WoVdErP2HMGThh+j
         Z2bk2JvNzEmXc38IxLLLwzYw0Qp0YtNERhYR+sEoSlwDiNYdtEYNMlf0RRr4sjCIfmRa
         NQG6bYE3NRMQ8A/N9cUg6HEk7rwacFTQUGHmuB8hz0HrjUE5qBtWkYDa08ZxMoKBX5Ch
         D7/82R9y5x1+K9SinP69Orswe2/pHS8lQSGIj1PG1rLZQlzswNwaAREw1NsaXdP09rKq
         5zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8J21rjsSqRuyBWN+DHumf3v8/nkIKqPUvMt2G71If68=;
        b=1NdaLq5TKt4WnkfcBl3wKQoCf9hAd9Zzj7v+JLASN+jR94joP6mD2LYHJ/en7yF7mP
         lnRV/VgF/CzGtO28i21PhxQBpk77+TYLpLgFQyopQSrGgP9zl474iZxpOEnnZEd/j1Zj
         19x9GZTcCE1Ap4H6a57WocY/rosb+k2o7X0xS30I+JsW9bqr6XoI32m4wbHcoIP0AhVQ
         RcKKRdvqLBsG1SMxGc7RM4wmV4AS9AsaHhsAtrNshppiz9bxBoUeYKTWlfFnV8S6y1Ou
         DS6BCK+qL+F1D8NJSHE6+m8NbpjHU/wxgLiVcbL2bT9Rv9jRPLN9A7sRyrkIZZhymlh1
         Mxiw==
X-Gm-Message-State: ACrzQf1RhYMCu8hOwf3GLCANTdS5cPzdZoR+wLpm/wmMy6WNHe12hgNI
        9zAaOhszIZvAKx9UiDxztsD8nOKjYsU=
X-Google-Smtp-Source: AMsMyM5d1MHZbipgpz3QRnesPP1OoI9dpDwQn8m7PQwTfco/cZHPtfh8dXfE7Zh/ccfRcaOlM1+lPg==
X-Received: by 2002:a05:600c:1ca0:b0:3a8:41cf:a31f with SMTP id k32-20020a05600c1ca000b003a841cfa31fmr12488823wms.161.1664486661388;
        Thu, 29 Sep 2022 14:24:21 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id x24-20020a05600c189800b003b4727d199asm435023wmp.15.2022.09.29.14.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 14:24:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/2] net fixes
Date:   Thu, 29 Sep 2022 22:23:17 +0100
Message-Id: <cover.1664486545.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

two extra io_uring/net fixes

Pavel Begunkov (2):
  io_uring/net: don't update msg_name if not provided
  io_uring/net: fix notif cqe reordering

 io_uring/net.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

-- 
2.37.2

