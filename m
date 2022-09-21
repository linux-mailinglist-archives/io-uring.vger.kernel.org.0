Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5215BFCEB
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiIULYk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIULYj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:24:39 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4E99FD9
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:36 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t7so9292368wrm.10
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=GAf4t+ngaW1C8kXmw2/v4leVYroVSMso1wp1/IttN7Q=;
        b=hu6wDVlNKZysVGR7FxO746WOvHIDCaEwPZMgdPoAtppcIHb6EOPjpOkkwt09wcP/0Q
         yj4agQ/y8H5DE/Kpz3jygZMX3k5rpmFR+AFShjmRqO/IbpZXwgeuJ51TNLG8FP/ArUeW
         ZbYEYmB/OM829xvwGz/eCgI28giqXPWSmAb6x115wsxqslwZgjd5lAMsjuTl7GlEx6MF
         UrK6QVQlFiCh/Pjnb9Czk8mhE3xOceXhl/xoET1vuMdq0ov0e54eaci6Il4K5eix2td9
         8tYYnePb3j7umwoYGCxo3WfLIm7IXD/yiLCwnqo3vd4Na5h24v/MMvIBUjYYkUSd7esW
         rPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GAf4t+ngaW1C8kXmw2/v4leVYroVSMso1wp1/IttN7Q=;
        b=as7b6SyqWhq8XBZGD74aDlgofB4uyqv0D4+3fDn/w7mwzjIPuor+rtHKcu5qKS/1Yf
         MeJ9469DsaXcBMG5nArRMh9v6LmP6gRilQctqO/cIYwbhGXFPwsL4DKE14CEUgasObef
         /t2tnqWe8u90gJSd0pgN6WUX0sjJniZCsiPAdVzD2ilyet+vuf0L/vGwbJiRJBPWEbBO
         RUe30dadMceAHQOWEZJZD1NOMLGS7b/QdQtrS2m/si9X304ojUFAoZm9nfL916vF2nIs
         iAmfv7wAynGahko9nSzbFpD+CJ6gI89uBBWz+9ezN++dUyvH5cu86CJCYs8xkme3dAxL
         xvUw==
X-Gm-Message-State: ACrzQf1hsscnKWjxvuSeFX+//i4K+IQNAJGa8n7XXd6mHigIYHx5kImc
        jDTNWxfbqocVbM+jqKZez4u/HdFDN58=
X-Google-Smtp-Source: AMsMyM7aXZpr3qZYopL9GZpcMC2iKsg/n1YX2nqujqdJmvNEun1fVOxlIB2bvhuGi2CyY4nlELmipQ==
X-Received: by 2002:a5d:6c6e:0:b0:22a:c36d:e411 with SMTP id r14-20020a5d6c6e000000b0022ac36de411mr16392864wrz.183.1663759474829;
        Wed, 21 Sep 2022 04:24:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id bw25-20020a0560001f9900b0022ac1be009esm2467539wrb.16.2022.09.21.04.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:24:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/4] man: note about notification generation
Date:   Wed, 21 Sep 2022 12:21:57 +0100
Message-Id: <4ae18336994f973d2e5e111479844c79547d7922.1663759148.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663759148.git.asml.silence@gmail.com>
References: <cover.1663759148.git.asml.silence@gmail.com>
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

Add a small note to clarify expectations on when to expect a
notification.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index d87f254..e0ce051 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1091,7 +1091,10 @@ long time, e.g. waiting for a TCP ACK, and having a separate cqe for request
 completions allows userspace to push more data without extra delays. Note,
 notifications are only responsible for controlling the lifetime of the buffers,
 and as such don't mean anything about whether the data has atually been sent
-out or received by the other end.
+out or received by the other end. Even errored requests may generate a
+notification, and the user must check for
+.B IORING_CQE_F_MORE
+rather than relying on the result.
 
 .I fd
 must be set to the socket file descriptor,
-- 
2.37.2

