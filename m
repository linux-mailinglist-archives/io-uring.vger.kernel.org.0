Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5D7D109C
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377084AbjJTNjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 09:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377074AbjJTNjb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 09:39:31 -0400
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C0F1A4
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:29 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so128278366b.3
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809168; x=1698413968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPVCNZmXkEwAvTHmzZYSbM7sNjgRBF7UKw1+YB0r9L8=;
        b=N5M2RXo0PEOOBOw+x5KqKEp+SPSXaP+dDun6UlORCmbvSC0UmrKGgbO/fSpw5nnlue
         VaUcErVS55I2z/rI4rDS4Etkn5AariviBANoig8r4pA6CubGlx6s+EQLJbTa0ePjra2K
         B/o2pYn0TacHn4p8Pw7JKMdw0ZBcYrPkJTd3sxN8T3nvaMkzPPd8oXui+oD8C+tzr4/R
         YbXX2hFVM6PvehGpHBo/YECUcsh1+ptfpNY/ShAweQRNXRd0eT+aGnWpW1sdjio681gL
         S9RVQPenPb/p6E76tuMoxLHb0dihzXpWjPXqbJ9pZk+qOjj84bZccXFv8mjpQgb5i4hJ
         7qYw==
X-Gm-Message-State: AOJu0Yz5ITO2Gkajx6ZWkn4+mg2qOXGHpPlisPvL8AiIsmNa4RjXFSz9
        PgzKYYul37S1/lhwJqo14ZA=
X-Google-Smtp-Source: AGHT+IHeIloKidVP73leu6JYoqxxlVjkWc/XavMAXi9ZUZd2kaUlmVsANZjQvGpVCmxojQI5ilRqAA==
X-Received: by 2002:a17:907:94ce:b0:9bd:931e:30d8 with SMTP id dn14-20020a17090794ce00b009bd931e30d8mr1324949ejc.14.1697809167471;
        Fri, 20 Oct 2023 06:39:27 -0700 (PDT)
Received: from localhost (fwdproxy-cln-005.fbsv.net. [2a03:2880:31ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id m19-20020a1709066d1300b0099bd453357esm1507011ejr.41.2023.10.20.06.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 06:39:26 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 0/5] liburing: Add {g,s}etsockopt command support
Date:   Fri, 20 Oct 2023 06:39:12 -0700
Message-Id: <20231020133917.953642-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These are liburing patches that add support for the new
SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT socket
commands.

This patchset basically synchronize the UAPI bits, teach
io_uring_prep_cmd(3) how to use the new fields, create a unit test and
add the proper man page documentation.

Breno Leitao (5):
  io_uring: uapi: Sync the {g,s}etsockopt fields
  liburing.h: Populate SQE for {s,g} etsockopt
  tests/socket-getsetsock-cmd: New test for {g,s}etsockopt
  man/io_uring_prep_cmd: Fix argument name
  man/io_uring_prep_cmd: Add the new sockopt commands

 CHANGELOG                       |   4 +
 man/io_uring_prep_cmd.3         |  34 +++-
 src/include/liburing.h          |  11 +-
 src/include/liburing/io_uring.h |   8 +
 test/Makefile                   |   1 +
 test/socket-getsetsock-cmd.c    | 328 ++++++++++++++++++++++++++++++++
 6 files changed, 378 insertions(+), 8 deletions(-)
 create mode 100644 test/socket-getsetsock-cmd.c

-- 
2.34.1

