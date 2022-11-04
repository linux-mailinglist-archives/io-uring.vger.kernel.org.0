Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86045619510
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiKDLDN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiKDLCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:31 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD012CCA7
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ud5so12346071ejc.4
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7MlbuTbNyUdrJscW9LibbOjJlk3V0YhPeu+LsTKFc8s=;
        b=guRrvx4rJGF8BA9NVOvSq12nuXECgVG7V0wBhH2mRWpbesrPU82dnUnNDVeV1DP/9e
         zcNsHgZUQTh6FzqdBbR1s39AffuAHuWvmssVqENgtG7nNhg40wuTkW6l51caNSQ7+aS7
         F0tVmAJ8x5ZQLN/2tn6BA6uizUHSTrCTB8PzjmrEGnWJcxZ00hN1h+xRLaN20oaAVcEN
         yN3l5yScbFOjhyVhQ9ZsNnFl+ehIOItK/aN2RpKPXbApaf1VZCOqLS5M9/Cwb+MTer4s
         imPBpGbcnc35zd+hTruMYT654bC5LIOtA35hlJu72OyBaWwOl+AFwbKEZgueJe3a21HJ
         44gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7MlbuTbNyUdrJscW9LibbOjJlk3V0YhPeu+LsTKFc8s=;
        b=leagwp4AUQYGD2t885ed9p02aG6a/YrrlC7DC7MC8KGrDeJ+kcfJscRQY/SIPlHxCw
         Ib42jx5qiFC8sNQfzxO58TF2HnzrQ7amvNUqwvu0l9BJvv4q6bdV2XdNIV5lgJ41qpES
         2JeN/8WTFabk0IvDG7Lxm7uQ96PVLtpSsthFAnB3LlBRJS4jjUq/Aij3M0ZDAqmScAHu
         nDxx6uQ+KD7yeG4YakfyQ21m22X+N5U5SyuwL/Xo1SYZpfBw7950qid7wuZ78MpUdgQK
         gLjoGzv+nTqwJPKINAkM3K0HlqGL+pbx9lRGCXVsEnmyzb+RvPN+IOGX6ZeqDaxoJvkD
         C/DQ==
X-Gm-Message-State: ACrzQf1PIow/5W8zTV7nwGqRgH3Y1l72VA6jHJ2K6gJtxklEW1gTulYz
        4OUc0fSfq2AIG7Wqvbp5JmKHDFOi5EE=
X-Google-Smtp-Source: AMsMyM51lEYnlVt2pafsvoQBrAjdgqLKAXMjOjjtDRaCVAiQ3IB0XLtka3WLqBNIv91f0UmdeNihJw==
X-Received: by 2002:a17:907:a4c:b0:77b:ba98:d3e with SMTP id be12-20020a1709070a4c00b0077bba980d3emr34586808ejc.13.1667559747772;
        Fri, 04 Nov 2022 04:02:27 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/7] small zc improvements
Date:   Fri,  4 Nov 2022 10:59:39 +0000
Message-Id: <cover.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

Remove some cycles in a couple of places for zc sends. Touches a bunch of
bits here and there but the main theme is adding additional set of callbacks
for slower path and move in there some optional features.

Pavel Begunkov (7):
  io_uring: move kbuf put out of generic tw complete
  io_uring/net: remove extra notif rsrc setup
  io_uring/net: preset notif tw handler
  io_uring/net: rename io_uring_tx_zerocopy_callback
  io_uring/net: inline io_notif_flush()
  io_uring: move zc reporting from the hot path
  io_uring/net: move mm accounting to a slower path

 io_uring/io_uring.c |  6 -----
 io_uring/net.c      | 25 +++++++++++++-------
 io_uring/notif.c    | 57 ++++++++++++++++++++++++---------------------
 io_uring/notif.h    | 12 +++++++++-
 io_uring/rw.c       |  6 +++++
 5 files changed, 64 insertions(+), 42 deletions(-)

-- 
2.38.0

