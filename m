Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6188557CD7
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiFWNZ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiFWNZ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:25:26 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6583449C94
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:25 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so1522733wma.4
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFVKuLkgQrpfQUY3Kp2/8Huzegm57YAmtcraHP2vi/Y=;
        b=mNK6qJ989mBNyo38SuaNqu88+9ks99jxdQHz/xV+zGSvelESvdBy+pHBB1MaxBUFny
         AjcBVFWCaHyPdj3uiHEtmC/sGmz6CO8jHwQGhAbHhJitJ1LdwHaS5DVlkWzQ+1Kmntd6
         Y24+zgv7kV2bhN8xom4D6a6DPDqXx7sghU7AUHclncZ6WAAGHUof2sCr9g2WBzqsxGCn
         97C788CPc2KS4bXI1PezWMaMX35suDfgLxZWGx+JmuZpFxL0RYwMz8UxgvERJIAy0NzT
         0gRTTvQc7wlRbeLU9Ax9YLEnEl2W/zib44gtVipqsm3npW8smeGZ/XQ4GTss8vd/3vza
         jbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFVKuLkgQrpfQUY3Kp2/8Huzegm57YAmtcraHP2vi/Y=;
        b=xTL+Z0Ienr8NgR5dlKFnNaozZJvUqKrRG5IfrG+x61Iuw2qjI0q3TknuWjV6hsR56Q
         Oz+p4a44Rki/67kMbdPnHIIh6ATgJhFVwtGyXV1mgN16xBvzsDyqC9NW6TVzVAfLzxPY
         jsKBOTeig1u1Q+79TxUEDny+6hmO34LmqnNJdfuGukqFDfTO/CqImJuo1EI78keonPoT
         RedlxPupmyapCpn0hXUO9rfCIgWHw52lKSwL0QivL6yvAV3Bm+iO7OK2ZYG9iibup7fu
         Oh0V0MjcmVnQC7oYOz+TWwNcqT59ux3f0xnVUPE/vsv5ORj77mdt7orrJ0YLrbeogmKN
         DztQ==
X-Gm-Message-State: AJIora8c4BhQGzXDXybGDizYdz1a7gA7kpdw/yu/KCWk5GlBRl68p5Bt
        rRKGfuOjwPInmVZnENI3X93ulASyWsNADq1K
X-Google-Smtp-Source: AGRyM1tvWS/JJVLYv1onpbf6sZBPwb2QdY0AaZg/g+VrZHuLFCiUejbxjm4TgwcNyNjFdIHeTBto/A==
X-Received: by 2002:a05:600c:3d16:b0:39e:f07b:77a5 with SMTP id bh22-20020a05600c3d1600b0039ef07b77a5mr4165150wmb.140.1655990723611;
        Thu, 23 Jun 2022 06:25:23 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b0039c5a765388sm3160620wmk.28.2022.06.23.06.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:25:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 0/6] poll cleanups and optimisations
Date:   Thu, 23 Jun 2022 14:24:43 +0100
Message-Id: <cover.1655990418.git.asml.silence@gmail.com>
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

1-5 are clean ups, can be considered separately.

6 optimises the final atomic_dec() in __io_arm_poll_handler(). Jens
measured almost the same patch imrpoving some of the tests (netbench?)
by ~1-1.5%.

v2: fix inverted EPOLLET check

Pavel Begunkov (6):
  io_uring: clean poll ->private flagging
  io_uring: remove events caching atavisms
  io_uring: add a helper for apoll alloc
  io_uring: change arm poll return values
  io_uring: refactor poll arm error handling
  io_uring: optimise submission side poll_refs

 io_uring/poll.c | 213 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 142 insertions(+), 71 deletions(-)

-- 
2.36.1

