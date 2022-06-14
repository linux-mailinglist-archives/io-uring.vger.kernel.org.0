Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F854B356
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiFNOhS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFNOhR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3913BF8B
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:16 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s1so11556541wra.9
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEfuhkg/6eZKZsc/6qKn0BgAYG3XphiiwBf/pnS/K9Q=;
        b=RPQbSsURfaI71fi0GzyqTHeJy4ni+GCD+yoEsiSs0Iq7+NDBGabK7rk9E7pgyEzZfa
         blbHuLnSsIjAiX9ATM+WKnY6SCKh9Azfw22gBcVtnFdh8uBM7AIrFOK2fwIrJGuys0CR
         1ijZ5OmpCeIgZxxaqZoIDaRo0A/lUzfxGOHyzztI/mnlWhVKKzXgY4yqOnewMchqGTyY
         s5XWDiXdSUXQPFLDOpFo7CIB+TJzjRVNfmfdlvfK+w5IJvhkMqh9f2hJk0k7cH9Ip6xg
         wzeO+BkRML1SQaCILLVNeQpxuP+olsYqg1gN8Wdae4yZZTIAdeWLxFAMMpAruaSHqy2n
         c97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEfuhkg/6eZKZsc/6qKn0BgAYG3XphiiwBf/pnS/K9Q=;
        b=uywQCBLMKOmgxvJrq5Y9Io9dYcc/ISQMf21ZUcmc713EBAknFelkj4b+/PZ2oDVlRK
         oPBOvjZeopOgPOnzRXrlSy9CxpmzMpoXRLhiiwx29TbrdIOU3awextdDa9/A9aRarwZr
         kTdfCeONp/KuKFzyf3ULmitaRO8v/V0jGGr+SBd4q3PUBcKrC38O3YZ84QMVytmDoUhR
         15E+X1NZqJR6IXxZmM4kd/tVcs9/vx9XbdowepQjV5XftPElf4MRM2VhDwscpNgWrmSd
         avRhpekPOhpFUiDuxmkDKRN8XTafMjYaQFscwwxWu3CPhaThxH9mjOQqpWAOlaZtfcut
         Dzxw==
X-Gm-Message-State: AJIora/T8IeRoTzXsg5iByJOzRW6GwPLCOVAOzermmEgwMDvFmukJbwV
        y2C4ejb/4IhEjfzfzlKedpQoM4oTLYX7Cw==
X-Google-Smtp-Source: AGRyM1v9jZo9BytxJiqT+ySgpy1lHpcZtzAyfEofP13193lEpM/CIOgP8jcrGGzH1tkS3DSjvokE0A==
X-Received: by 2002:a5d:5c0a:0:b0:218:548f:86a with SMTP id cc10-20020a5d5c0a000000b00218548f086amr5065438wrb.299.1655217434908;
        Tue, 14 Jun 2022 07:37:14 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d58ee000000b0020fc6590a12sm12169254wrd.41.2022.06.14.07.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] single-issuer and poll benchmark
Date:   Tue, 14 Jun 2022 15:36:30 +0100
Message-Id: <cover.1655213733.git.asml.silence@gmail.com>
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

Add some tests to check the kernel enforcing single-issuer right, and
add a simple poll benchmark, might be useful if we do poll changes.

Pavel Begunkov (3):
  io_uring: update headers with IORING_SETUP_SINGLE_ISSUER
  examples: add a simple single-shot poll benchmark
  tests: test IORING_SETUP_SINGLE_ISSUER

 examples/Makefile               |   3 +-
 examples/poll-bench.c           | 108 ++++++++++++++++++++
 src/include/liburing/io_uring.h |   5 +-
 test/Makefile                   |   1 +
 test/single-issuer.c            | 173 ++++++++++++++++++++++++++++++++
 5 files changed, 288 insertions(+), 2 deletions(-)
 create mode 100644 examples/poll-bench.c
 create mode 100644 test/single-issuer.c

-- 
2.36.1

