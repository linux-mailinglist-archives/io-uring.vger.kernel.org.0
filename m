Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB3854F388
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381191AbiFQItm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiFQItl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:41 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9999269B4D
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id o10so5293047edi.1
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Owqv22wezmgZs+1ZJTJEX/a94fMETE+DUG+tJC7wNLk=;
        b=FbvKTx567YtxNiCzSSOhSXXsc4bI/rof95pOw1Fp3nqs3Z0j6PTA//NsaurCT6Ob1o
         blt+BS3iH89UZ+F69e8Lh4tj2nmpjKlS5AFxJg3lqwnD25Kk7+ipRL4lFjdwmKzWRMCJ
         kkPM9GEjqeQ1RobwolEitwAjHdET6DkFY4PdJw9UO3mijZ/StwD0mxO0laekR98H+mUZ
         WbywwFm6O4loSXTe3IqnvP4R0SCn/6Cfb0juaUOGRIDKd7vuGfx3kTyqmZzgt2kOVG0U
         HoD+c0CfPXwhu5u77EK4G0d6uEBSxTc/LEQq53TmUjofB847B4P5N5Y4AGdq0cA3/nUY
         C93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Owqv22wezmgZs+1ZJTJEX/a94fMETE+DUG+tJC7wNLk=;
        b=o4Aq8S3T+TRsZgReypkT+hxcL8JzbYDv0BrOphYauqxRAosg2pOUeDM9TfNIjhvxbd
         47DNVH8dq3a2FmTMw/sQ1S5gulOVQe1BfMb66dvBgQJYIusZH55lGHNoABWrY4lxI2Ve
         aj3eNrtx8hAhpgJJzbyTkU86KdGloaEQRCyjl0MvrFOk+A6e4vaQvKbrufEDH1y561iY
         UfpoYsOZJ2/tFj4vXzsC0g3gL76rwnQJFR2xTDddw4wZsP07zGh8vBz/vWtwrtwcWFNS
         6umE2TYnpneWLFsDvQKxeXfh7eU0SSKD/cvvDeS5XPFlKv0GFoTDSRPb9blrSgWsG+L6
         HXTA==
X-Gm-Message-State: AJIora/luMyrqYpxABWReoiGwGB2YyKtwBBybyEwU0VhmL3q/Y4qO8Ri
        eZSJ9Hc8o7rAoPHVehvGHU4Oy/sa0wFUTQ==
X-Google-Smtp-Source: AGRyM1vBTQADwm70T9JLK3fD1Y7oeqGzjvha8FQO3+NGoouLdfvj0DZy+psG40JWyl7ia8oRzyVbpw==
X-Received: by 2002:a05:6402:1d51:b0:41f:cf6c:35a5 with SMTP id dz17-20020a0564021d5100b0041fcf6c35a5mr11018069edb.25.1655455778875;
        Fri, 17 Jun 2022 01:49:38 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/6] clean up __io_fill_cqe_req()
Date:   Fri, 17 Jun 2022 09:47:59 +0100
Message-Id: <cover.1655455613.git.asml.silence@gmail.com>
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

Clean up __io_fill_cqe_req() after recent changes

Pavel Begunkov (6):
  io_uring: don't expose io_fill_cqe_aux()
  io_uring: don't inline __io_get_cqe()
  io_uring: introduce io_req_cqe_overflow()
  io_uring: deduplicate __io_fill_cqe_req tracing
  io_uring: deduplicate io_get_cqe() calls
  io_uring: change ->cqe_cached invariant for CQE32

 io_uring/io_uring.c |  73 +++++++++++++++++++++++++++++--
 io_uring/io_uring.h | 104 ++++++++++----------------------------------
 io_uring/msg_ring.c |  11 +----
 io_uring/net.c      |  20 +++------
 io_uring/poll.c     |  24 ++++------
 io_uring/rsrc.c     |  14 +++---
 6 files changed, 110 insertions(+), 136 deletions(-)

-- 
2.36.1

