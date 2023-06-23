Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E9C73B60B
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjFWLYj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjFWLYj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:39 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377B51739
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-98862e7e3e6so58212666b.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519476; x=1690111476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jztTkx8nrJc8gpz3HDPr543pqJbofjQgf+UEBY3+Ojo=;
        b=Qgdix4KLdOV3r4nGZJ6nQOykveQRY4r/KLhWMXpLx/pEoIetiDt5m+7fKnynNCxQzr
         JVDvyLhQjIAkMO5bnL3cXK+xhAdIPWXvmkJOR30hhKxxSDKfkynIzmK5nhzaD0qIjgJ/
         kBrmgNji7N+ZMtkoP4i4qX/NrP2v1Rx2YwI1HK/1qI82MolxqJJI7uws5AiZhaA9TbPY
         y4xnhu3XDzE5sFlXQKF14z574TmbcYNevgfGwmXaDi3T4QBkli0Np8ZJBPveIlTU7Mu3
         Mgik7a3FPkt09sTe6vwKziMypSPY5pEEfJmX0B5mPuvdS+A3aCO6L36vb/Qpsuygc7kB
         SRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519476; x=1690111476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jztTkx8nrJc8gpz3HDPr543pqJbofjQgf+UEBY3+Ojo=;
        b=Nft+XO3wi/3Q/58dV4Pbl0U8fEnc8wFe4NL2oF2VRBUUjUY1BRcL1yylEIw+aOUygG
         V4gCwywaFiLsBGZc4DiSrDZcNuEUr9DPJ3QoTKB6ulUhqVIejtTr1yMTuRQRXs34SZDc
         2rPIABdxTEu4AVDEdhTIX7szRv1Npo21L+jE/f5mpPmyCn79VvyWcBa1DB6mbfEM4Aae
         9uw0LXEY19gnpSqobUruTm+RchrKTh3V5YRYMRfHVjpVfdBEUg56d+GS7dhC2mWaVZLM
         zuxrVa5cN6gSCM4fL5aTvyVXmjgTnsUObmXQMzxcRw5kerkXnN8Xkyl8P4pNiHK6IvNI
         7WWg==
X-Gm-Message-State: AC+VfDxg/G8PU0Gu6Deykzg5J58RkmNWzQUmHeVeI6rQah/5zvBVbv/l
        3GlBgL1jZpJrAHCKnNo6aUCReAMPZOM=
X-Google-Smtp-Source: ACHHUZ6CjBxtAE9aHn598Rkr+9ouJiw0F0xIcgQLIrmWcNC7MzluxIPq7VDFL6lpucxTbqi3Y4Mtdg==
X-Received: by 2002:a17:907:25ca:b0:988:8280:2b60 with SMTP id ae10-20020a17090725ca00b0098882802b60mr11594580ejc.67.1687519476297;
        Fri, 23 Jun 2023 04:24:36 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 00/11] clean up req free and CQ locking
Date:   Fri, 23 Jun 2023 12:23:20 +0100
Message-Id: <cover.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

Patches 1-5 are cleaning how we free requests.
Patches 7-11 brush CQ / ->completion_lock locking 

Pavel Begunkov (11):
  io_uring: open code io_put_req_find_next
  io_uring: remove io_free_req_tw
  io_uring: inline io_dismantle_req()
  io_uring: move io_clean_op()
  io_uring: don't batch task put on reqs free
  io_uring: remove IOU_F_TWQ_FORCE_NORMAL
  io_uring: kill io_cq_unlock()
  io_uring: fix acquire/release annotations
  io_uring: inline __io_cq_unlock
  io_uring: make io_cq_unlock_post static
  io_uring: merge conditional unlock flush helpers

 io_uring/io_uring.c | 223 ++++++++++++++++----------------------------
 io_uring/io_uring.h |   7 +-
 2 files changed, 80 insertions(+), 150 deletions(-)

-- 
2.40.0

