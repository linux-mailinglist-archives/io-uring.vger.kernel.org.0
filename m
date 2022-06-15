Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33754C56A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiFOKFo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiFOKFn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:05:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEC93BF8E
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:42 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z17so6032827wmi.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEfuhkg/6eZKZsc/6qKn0BgAYG3XphiiwBf/pnS/K9Q=;
        b=acTJvf3fgDy5dguagDPaMgMVhPlE78vtB9K8BlEoEUJXFXpc8+Po60b1sjibz3TNhC
         lxfxXdQYSnjI3H0J0PUQhM/DyvtALowu/ckh1B6H8HWYRdi5svVsOCL9bjEdQEbYIwQd
         Y8u/gUYoNTg5t9/6SubfVEW8/8CirIEA63PByVpcRZERGO4kn30hQPY276jcOMkDArre
         Xunmg0kSX1FwyNv+vomDMWyfc6rGA6rKB7NJFUG8clRNes0RCCoy5o7XXSo2q8G5lUIf
         70FGGi11zLSVUHdZI3Ave3ApiXrc7uGU0Ziej91JlJDTuEoXLN7t9V/6Z+TvHQMPaJIR
         Smsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEfuhkg/6eZKZsc/6qKn0BgAYG3XphiiwBf/pnS/K9Q=;
        b=8C8vpb4WSIQ31dhpLms164n9FHw21b1gckmMtHW/5rnH7lk2xPKrebL6TtpdEa1kru
         Lbrh5L4UwCp+u6zB09otUCyonmoVhHEiG0zCVlEvcnyLF0xgu9AcFZxbHWi2NKrVcuST
         Sg4ESeBbFUaa9uOj7TqMJgQ/dusOuO/5HKi/fxQ4Q6nMFMpQrtHeIzfjKbV6OCxeBqcj
         OZ5iydh1PK8zeHvqaUMBv651lC2417b4+k0o44L1eynLi/ktHq7uY5YaI294JvpdzNAG
         5Nnz2aSiW8t3rF3ehdEZgd5bDb5s0hFOxWP4mVHPLgR13yn8mcTzsMRE2wPGjmDcIG5m
         OruA==
X-Gm-Message-State: AOAM532ug5+nA1sbnD60yJuUxFTNccoGMPyo0JZbzWGkpf45dZRg18gL
        v9sdTlkV2DVYj4glQHzEIZAlZYJZX0lc6g==
X-Google-Smtp-Source: ABdhPJweVscKT7YQzCLmUck9saCPksfG6zSumy2F3rzJ+I/1dfPsL03mVAIerUeLmP3JYnx5m8F+ew==
X-Received: by 2002:a7b:cb4b:0:b0:39c:49dd:b2cc with SMTP id v11-20020a7bcb4b000000b0039c49ddb2ccmr8834289wmj.123.1655287540910;
        Wed, 15 Jun 2022 03:05:40 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id w5-20020a5d6805000000b002119c1a03e4sm14074984wru.31.2022.06.15.03.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:05:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] single-issuer and poll benchmark
Date:   Wed, 15 Jun 2022 11:05:09 +0100
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

