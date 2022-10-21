Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B2607805
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 15:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJUNN7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 09:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiJUNN0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 09:13:26 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6157353A5C
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:10 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bk15so4711307wrb.13
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PPAlpYhtcSJdoaoMe4YYTKsYe9rn+3SoGT+MNFriE9U=;
        b=g5NrhTuoVHjnQ0WqDamKahuKUMdUip9xdUyDNy8wQu4K2VBvZj+5WEDzCNka+0XeSr
         tWc6EzJr6coOcKHkQOTnRv+6cN78vp5B3IWyQSet8SEyuI15aCahUeTIErW1Y+yUO6VL
         yFrkST3LEJIVgXB+n7d6eM1oagcL27butcuSpFbYXqutjDKV9jcP6hek+JOiuoBLry8e
         J6KCl6cbRZ1WxAScKWImSnVj21Mp2sk5WgL0RvN9WiQz19nTGEn9fMu76+FXZXLKFFvZ
         uts9n0Tt5c+7zQF3veBfCkpzpJ9j4IzPgNbrSOqXWkH7/3RMDMXsb1RJUsLoh/dHSqwn
         2yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PPAlpYhtcSJdoaoMe4YYTKsYe9rn+3SoGT+MNFriE9U=;
        b=0prrGkPKRYu1Hh5RU4jFa1l+frljEHviehEGaJ2ev9Hv9peW4xsW9/ZIYFRBn7bfAz
         ta7RXMAfHui2qGF2d66P8qZ/veUiZexCIolunwQTJR/UXfzfGyq3q139pD6Ui1/dMPAE
         P+fLq9W0BRuD3zSm6XRuI3rj6Cvl/NvBtEo1kvo9Zd57/x42RT6JwyHXWy+Drcf9dCe3
         9zXh4RZvfbCMRlQA3zGw1XfIWbyZyiZpp4ms1fKx/5kgirsNtTHHsHKI8k70wZ5y7Vpb
         aVo5AKuRlW8eg4fKbgw3yEwqggW/MTZhDzwSa0GaYrHHxV9WRTs0HmxU93t0PhVR76Z1
         hyYQ==
X-Gm-Message-State: ACrzQf2H2zqtcNJtI3jAgduRamsKcEcMHK0mLAcK8CM6cGLDJ+kkkK8X
        qNNh1uhtHyCD5hM7T+UgvMUJaV5q/G4=
X-Google-Smtp-Source: AMsMyM4iDU42yDwUrfOU66kMjusEuvzgF4MZgWh8+zUrn5mAKAEzGpJwcr0tKueun9NZJT43lEm50Q==
X-Received: by 2002:a5d:6484:0:b0:230:7cad:c268 with SMTP id o4-20020a5d6484000000b002307cadc268mr12736226wri.335.1666357986847;
        Fri, 21 Oct 2022 06:13:06 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id n4-20020adf8b04000000b00231893bfdc7sm20739442wra.2.2022.10.21.06.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 06:13:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] improve sendzc man pages
Date:   Fri, 21 Oct 2022 14:10:57 +0100
Message-Id: <cover.1666357688.git.asml.silence@gmail.com>
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

Add a note about failing zc requests with -EOPNOTSUPP and add a paragraph
about IORING_RECVSEND_FIXED_BUF.

Pavel Begunkov (3):
  io_uring_enter.2: add sendzc -EOPNOTSUPP note
  io_uring_enter.2: document IORING_RECVSEND_POLL_FIRST
  io_uring_enter.2: document IORING_RECVSEND_FIXED_BUF

 man/io_uring_enter.2 | 98 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 2 deletions(-)

-- 
2.38.0

