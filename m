Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0B549F76
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 22:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbiFMUhI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiFMUgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 16:36:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA71DAE6E
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o16so8357864wra.4
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AhDRbRo9cDvgYzSBZLLaDpgZAz5miOsbty8yCwYW3TE=;
        b=VX34UvtjbDMYEsrvceJXjlV62/wrz1EtK43uu/MLo2PJ2ym5yyjVOnkLjba3GE9e4o
         XiVVoVypbpM6c/X8r1AogR5vNGcvc44UUwRBY89lXI5G10LRUPTl/L81yyzSD8jBtsGM
         kFH6LT9E15cayNt10uAenj/EOZVdf60g1lWjmKYvyH/rrR6/AI+KLDMr+sARC30gk2N0
         pUmtBEOJAbTPEuGi5QlKKPhKl29V/95v5ho9l9+WVG8adJTTtbz38GcM11xPFIoZ/yrG
         mwMsxvPlj12B4Ft/Q3vmnfLS84Jby7IW9Lb5vmQj5eQaQKJ/u6FsSBiXtUyRU51qWpCv
         bnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AhDRbRo9cDvgYzSBZLLaDpgZAz5miOsbty8yCwYW3TE=;
        b=A9Vkju0RQFYvJej6+et2fHgR2n4YIXTHs5M5q2BXaHpBnqx1GSpnHpKqcrGS409Omx
         Jvx0hoe7pb/q/FpXG/4DJe4JMxIZCMUuEBeIWqWksxvFbPBndCThyNyqzui9vY3UHulN
         QEkaxPgHu5pDfsliBq3zUv9mTYz3HC56hbmgBSahGja/4/ZFW4F53V9hKb8fKR1zSSj6
         hf94RQKkfJ50+E9dP74w5jC6FE/vHNfq6Gw43q/onfLDP++WpAqaWjYzF2HXRCCMRFXI
         UgE/1oZo/8U7LrsRE8jgXfn+JDkZ1ciCzHSXvyDLv7GCmvWdAWzjX8AoQ4pmBi64zGpY
         9lug==
X-Gm-Message-State: AJIora8SMGfSl8dAWa5R8Bsewub9DzRTbWl+A45THbOSTYS3Q+jE3TY1
        AR7U83AF/Qqqg+KN52/cw51c1PM5cMvTizIi
X-Google-Smtp-Source: AGRyM1uTnH69/7nPdq9nAGb4NgcZh/SrXiR/Q65hqqZD+7AQlhqn+K9pR1Auyy4hT3TZlclkiUqW5g==
X-Received: by 2002:adf:fa03:0:b0:210:dcda:ee82 with SMTP id m3-20020adffa03000000b00210dcdaee82mr1247977wrr.139.1655148405254;
        Mon, 13 Jun 2022 12:26:45 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:f4c0:c139:b453:c8db])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b0039aef592ca0sm10163198wmg.35.2022.06.13.12.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 12:26:44 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC 0/3] io_uring: add support for IORING_OP_MSGSND/IORING_OP_MSGRCV
Date:   Mon, 13 Jun 2022 20:26:39 +0100
Message-Id: <20220613192642.2040118-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first patch just refractors the do_msg function so that its different
parts can be used in io_uring.

The last 2 patches add the support for the async msgsnd/msgrcv.
For msgsnd the pointer to the loaded msgbuf is saved in 
io_setup_async_msg_msg for the case when the call is punted to async
context.
For msgrcv, the pointer to user-defined buffer is already stored in the
prep function.

The correspoding prep helpers and a simple testcase for these in liburing
are present at https://github.com/uarif1/liburing/commit/17f6685ca398265b54a07ce4246ee344b5390aad.

These patches are currently missing compat support.
If the patches and approach look acceptable to start review,
I can send the next series with compat support included and also add the
man pages in the above liburing patch.

Thanks!

Usama Arif (3):
  ipc/msg: split do_msgsnd into functions
  io_uring: add support for IORING_OP_MSGSND
  io_uring: add support for IORING_OP_MSGRCV

 fs/io_uring.c                 | 152 ++++++++++++++++++++++++++++++++++
 include/linux/msg.h           |  11 +++
 include/uapi/linux/io_uring.h |   2 +
 ipc/msg.c                     |  52 +++++++++---
 4 files changed, 205 insertions(+), 12 deletions(-)

-- 
2.25.1

