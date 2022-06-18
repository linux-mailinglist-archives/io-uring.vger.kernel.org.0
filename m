Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5D655046C
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiFRM1w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiFRM1v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:27:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D16140FD
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:51 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gl15so13192729ejb.4
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9gnS8wQoGxUe+DfpWcujfNxbnz2mC4j3Xmiqg4/n7qo=;
        b=pzhwhjxPfhnnGmRRnrPkPSE+oqOeYaktTQ78pX2dNG4E9pmJPoqSt5ye2v6MjmsrdN
         D+uY3+t35pXH7DZI/Y1T9cl7BqlVMm20dvja4ZZdrFRojHa+IEfRqd+K5qAtO8axsCY1
         32Qox3Px60uFwlvpT9zWLt0KlW4Ib0ZlTZTr6mCQxbdltiH0e/OZQDpbaAqLX+4vzq0R
         h31LtxeTxEeZnI3DQYkQvp423JB0oLhGC8AmuqYlzLhNSXt5uPC4HepipuI8Xwwx4wGj
         KJPi9VncvrEXOsXlHLGpRt1EhmeGfCvdVRougIU5elD29LFu+xZDd1l4H/FeYMgoVC+l
         FvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9gnS8wQoGxUe+DfpWcujfNxbnz2mC4j3Xmiqg4/n7qo=;
        b=ka1Pc9AyIV2jo/im4Xbr+sAj/UuT2pTPPbozIU0H1VO44vFS5078dh2ITAwNHdwM0t
         9ztX1YTwtGn4hg2eiZ2GRaxiSuH5C6Zno3kp97zOWi982muHUkq5RKietY9B54TlnWe0
         J7nj2ID0CVqHphwvt6TiCGlcPnpDIX6bYK8PpZgHqsPhRQ8O7r1FDsGrQ+fk3u99Q/An
         JxgihRP+whL81U3K+iGnyuyCEI1unRuCNy7qG+o05ZMIo2z7a96Qq3lfXGEgx0oV96RZ
         Jfj5EWdJmPf3a7XxB1iwpP2y6GO856Sge7vOHZkNFj0fAdbS31WJjXzbPsLFyFlqx5et
         Y8DQ==
X-Gm-Message-State: AJIora9NdwqxXRsu6D1D3IJA2ZYPKT9gFnnSQea06Tm9w2ng6Kzr7vxY
        XJXb4ogNDH7HRV/SlalSCUffBgNjpNoTHA==
X-Google-Smtp-Source: AGRyM1sjwCqO0dXRPkSCLB6aiCGmb7Q2IitaxXRofCWdoWpnuNhMhf/BLCEb1sVNeXlqKi0HkXx6Wg==
X-Received: by 2002:a17:906:5d0d:b0:711:d49f:e353 with SMTP id g13-20020a1709065d0d00b00711d49fe353mr13584169ejt.381.1655555269205;
        Sat, 18 Jun 2022 05:27:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u23-20020a056402111700b0042dd792b3e8sm5771523edv.50.2022.06.18.05.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 05:27:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/4] simple cleanups
Date:   Sat, 18 Jun 2022 13:27:23 +0100
Message-Id: <cover.1655553990.git.asml.silence@gmail.com>
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

First two patches moves fixed buffer iter init into rsrs.c and decouples
it from rw requests, 3 and 4 are just small unrelated cleanups.

Pavel Begunkov (4):
  io_uring: opcode independent fixed buf import
  io_uring: move io_import_fixed()
  io_uring: consistent naming for inline completion
  io_uring: add an warn_once for poll_find

 io_uring/io_uring.c |  4 +--
 io_uring/io_uring.h | 10 ++++++-
 io_uring/poll.c     |  5 ++++
 io_uring/rsrc.c     | 60 +++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h     |  3 ++
 io_uring/rw.c       | 69 +--------------------------------------------
 6 files changed, 80 insertions(+), 71 deletions(-)

-- 
2.36.1

