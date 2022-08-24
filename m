Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4813C59F918
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbiHXMKh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237217AbiHXMKZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8FA3F1EA
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bj12so16075599ejb.13
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ZWrfnMhWRZrECVzlS/d2YAKDet+kZUhd238kS+ld1Wc=;
        b=FoB0BBMIAqzcW9888SoEqjvV2RkqPi8cTUSzK/0BBs2bSHT93hUqIxh4dmnyr6R3ij
         QSy9eKl0sT2lqiChIl7mAmEGjVGz6Nx1cVrf+9EsKcfIV1CBXaNMGHdu9asYzfdKvDUe
         NHn63sTtNRz0nTZaS34cEY9PpJirnKUhjpCgZklLL4aJwMkZf7kQSEXx3DddvJlsf6QH
         VluSuP/aXAJD6mY1KzBhMsh41GJPZ8krs6/49ReJXFyvYATMia4uYTdtt+vMQAY4rHo9
         rnnOW5WFdbCPXX/wIlYTzfvTeQSxa6eWP9MSZ3oKOgnhAlDtpgTmhvdtL/a/ahvVauLS
         +pWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZWrfnMhWRZrECVzlS/d2YAKDet+kZUhd238kS+ld1Wc=;
        b=0kxExHVW7gJP9DNlIpagIpEbJopYO8DfSJ0x8KgpmUEhsaaIZpCEnD6rkb/swVlqR/
         wzd6eV9lS6ycSbGCmmYF/aDuy8m7bywJMghcSXhOc2EAw+LZLc4mi0LIzmWiuLTGPNIr
         ivpbeOMVXa1gRie5YYfY2oPFv4435Z3JaucZ7ySdGwIT5W+yFfdp/QduqYZiwQqR/+h1
         3CQCwqRs5qEQ946UMhOy6cVWiwLCUwK6Ibiz0GFRDhqVO6hfdJoPhZLq2LEsS0CDWyal
         5R9RCzdhuo+Vn/KgTE5yFQ9EX/uQX5hnNxDgwu1RoF+jwjNm9r6Jgf0BvJ4RVZmVfrVd
         hHMg==
X-Gm-Message-State: ACgBeo12l+vPvn0mLzCvKJ8ig7GP5oam/PlSoDIP+wSuN5xasjo8bZpn
        tiwxjBO605BEoScqPdZW74Gb2spMoIRxbA==
X-Google-Smtp-Source: AA6agR4jk/SJmacMchchnnPaSl4CadwC5ucGw0TgqtTVSRkQ6ZZ9WRMOeYpv28/nPx/Y+6zXGibwew==
X-Received: by 2002:a17:907:8687:b0:730:7c7b:b9ce with SMTP id qa7-20020a170907868700b007307c7bb9cemr2690326ejc.656.1661343021135;
        Wed, 24 Aug 2022 05:10:21 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/6] bunch of zerocopy send changes
Date:   Wed, 24 Aug 2022 13:07:37 +0100
Message-Id: <cover.1661342812.git.asml.silence@gmail.com>
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

4/6 adds some ordering guarantees for send vs notif CQEs.
5 and 6 save address (if any) when it goes async, so we're more
consistent and don't read it twice.

Pavel Begunkov (6):
  io_uring/net: fix must_hold annotation
  io_uring/net: fix zc send link failing
  io_uring/net: fix indention
  io_uring/notif: order notif vs send CQEs
  io_uring: conditional ->async_data allocation
  io_uring/net: save address for sendzc async execution

 io_uring/io_uring.c |  7 +++---
 io_uring/net.c      | 55 ++++++++++++++++++++++++++++++++++++++-------
 io_uring/net.h      |  1 +
 io_uring/notif.c    |  8 ++++---
 io_uring/opdef.c    |  4 +++-
 io_uring/opdef.h    |  2 ++
 6 files changed, 62 insertions(+), 15 deletions(-)

-- 
2.37.2

