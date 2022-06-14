Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5754B6D9
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347661AbiFNQwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346279AbiFNQvz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 12:51:55 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A674B4477B
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:51:53 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso5128098wml.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tlRk2ASjGS8ulvxtniqINBQx/GEVJfrI5oPh1DfmHRc=;
        b=k1h/T7LIZV6FSB5hb+IeOwhw71rVSoZTUIE/9WnO7llB36lc+v0fpSdg680k0NjcBv
         RoMxeqcouxIbCF368Nt0DaGUPOjjHZboyuuiWC6qBTdAvgsw+NtvHxvoMj4Ar/13Jw7y
         fFi7skkBJFlh6tZ0ghfGpZYecIsaxxpi6qT83zOJpfFDukMyl8sttQffbO3/5Sz235kW
         RVMyKwMmKiAt29S2khyF+HtXS8Mit3OJ0Hc4mBFyX4WOtEwcWhs4ULm/B6GI9YevMC4x
         l4GmAXS1sz5McwNxdf0EuZyx96EViDPhpfED2vzRPgc6qZoar1eQka4TBVE9FQjMPRks
         T98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tlRk2ASjGS8ulvxtniqINBQx/GEVJfrI5oPh1DfmHRc=;
        b=WLRER0XfNIPCXB3p2AsIV8HcWud2sqpNd1Wt9dN8axt6SribESTVgsXOGStMeYO+La
         3plQuXCMkdkqruwSscJusNcgEM12f/ovviK0hJhRYlFfmw5UaaV1jDeIvhLAGLkHsbcG
         msv+8ZwC9NR2bpBoBFbMn8SANw7fQjGlDGYfk20b19jaqx4SXij/7jlZ/kyXvknLY/8F
         Q2Vm8wW4OOnk1C1h0c9IUjxCKrFJqv2lR8UaXLrD4Cn4FLwVZTruSa9pvzv/eOqxNk6x
         aVo4LZbIWzEPruol/7QgT4S89lThpR4dzm1vSAp/6peMx1EKZcLhGRg5Zx7784WfKENE
         SG5Q==
X-Gm-Message-State: AOAM532EfgoSzDJ25YBwcIQU9rMazsyY/vRxmU8Qjy61HTGzwfoGpiVP
        4wrlSedDboWfs+elXuxczZG1C19r1km1RA==
X-Google-Smtp-Source: ABdhPJxBVq+1xou+va0EOtHU70S0qbi4bd5OLFKb7MMDGFnFpnkHLOOx1UXr149Xhr/BbmF9VhrX4Q==
X-Received: by 2002:a05:600c:3485:b0:39c:7db5:f0f7 with SMTP id a5-20020a05600c348500b0039c7db5f0f7mr5211232wmq.8.1655225511980;
        Tue, 14 Jun 2022 09:51:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z16-20020adfec90000000b0020cff559b1dsm12648966wrn.47.2022.06.14.09.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:51:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 0/3] 5.19 reverts
Date:   Tue, 14 Jun 2022 17:51:15 +0100
Message-Id: <cover.1655224415.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

We've got a couple of nops debugging features, which don't belong to
upstream, and IORING_CLOSE_FD_AND_FILE_SLOT nobody knows how to use
reliably and with a couple of unsolved problems.

All came in 5.19, let's revert them.

Pavel Begunkov (3):
  Revert "io_uring: support CQE32 for nop operation"
  Revert "io_uring: add buffer selection support to IORING_OP_NOP"
  io_uring: remove IORING_CLOSE_FD_AND_FILE_SLOT

 fs/io_uring.c                 | 46 +++--------------------------------
 include/uapi/linux/io_uring.h |  6 -----
 2 files changed, 4 insertions(+), 48 deletions(-)

-- 
2.36.1

