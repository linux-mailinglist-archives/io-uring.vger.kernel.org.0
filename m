Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22BF1D67AE
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgEQLZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgEQLZN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:25:13 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828AC061A0C;
        Sun, 17 May 2020 04:25:12 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a4so5490102lfh.12;
        Sun, 17 May 2020 04:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YKbSELN0l7cHzpwYGDHQPZKeqFZ1P5TAwLPgFHhXmgo=;
        b=YWaZjFkqHIeOpn54/x2FhvMVGtUL2g8BF5ylkcpVOQH2v5xVrWjPRO2gkJbaJ1Q/kN
         RKiQ44Tga/BrS/UR6euaGZ2SutEhouKvbZJzcODau7l3RXEpqy+2BP7I4An1yPDAuQTK
         bzyTdgfGS7zAsjVz+H5k/04QAu0DcZ92/gWgADi5qJoX/43K3WqLQzgRMNlxYaVZG1j9
         pHrNULXAIEnBNG2Hmw8H7QgvzFDoiVpQi2R4tCdk5Ec1dp9cbPA+4CWLIIT5riD1tbvL
         Y8xkmwfoQi1SM5U9bJBRvbPyBPEC8yQ0USiHhn+hR6hQovNOdArPx6rD3oDXj3KNrMqb
         s++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YKbSELN0l7cHzpwYGDHQPZKeqFZ1P5TAwLPgFHhXmgo=;
        b=KNJZOk8AoX2rxERilxBfZ7mFw5gr39Lqe5td/Z38KE1IUGQuZ3xnv3jNvM1VB/RNJ/
         gDSuzcTiYiwY5vfh2ZAnTFmSCLNPkNdMtVRG3ft0+bosDkSVbW1u/Ftrmop6fxmNnNme
         jD2bORWm6uEyOuwXanKmxPIvhICeeO6Mq6yVvBLSDRhaHbw5b3yIGvTxjPbVGeF5+APh
         EDwLEqxNBgeAIppUn1U/J5PMXx7maSDDehIwXMVS3BNSZJRc4C7bO2Fd/ct9/Bh6DWfq
         yB+4fiDdJ1GtkP4Fi1N9zXVySWCN4GR4eHeKJkytRS1aGgCrUElYydVPE0Q05r35zXJ1
         QH3A==
X-Gm-Message-State: AOAM530coABLjtBwTzYTvr+fhhVhE62SHhQzSJB0H4xQEDD8MPbSHdut
        uRSztcyRL4s0io7deA5rN50=
X-Google-Smtp-Source: ABdhPJwdo7mcU+TlukK4He0EVI0vdQmLKDdxBSd2EyfB3yfGe4Zysm+/rvXNBonx1KgjPadzl26P7A==
X-Received: by 2002:ac2:5e9c:: with SMTP id b28mr8203570lfq.50.1589714710973;
        Sun, 17 May 2020 04:25:10 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id c78sm5639828lfd.63.2020.05.17.04.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:25:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 0/4] splice/tee testing
Date:   Sun, 17 May 2020 14:23:43 +0300
Message-Id: <cover.1589714504.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tee and improve splice tests

Pavel Begunkov (4):
  splice/test: improve splice tests
  update io_uring.h with tee()
  tee/test: add test for tee(2)
  splice/tee/tests: test len=0 splice/tee

 src/include/liburing/io_uring.h |   1 +
 test/splice.c                   | 538 ++++++++++++++++++++++++++------
 2 files changed, 445 insertions(+), 94 deletions(-)

-- 
2.24.0

