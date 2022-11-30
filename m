Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DC163D94D
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiK3PXZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiK3PXY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:24 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E3F74CD0
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:23 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id w15so14430291wrl.9
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=foL3X4GlTyfiEn6RrTzFcSbhTXnVxwE4w4R01EbJ6U0=;
        b=lqzDeLTA0ntPYntJXNxV3ykM3AEyGwZ7UiumKpfnBNuxmDwPRhrgEhfciwDr9NkShG
         QE/i4D7bV4TOOu3iFS5DeI2OCO3zRFT19eoZVID57uU2GXi1b/Y4BthDNB56q4OFYRQr
         8NRr5sXUdG78ZEgXH4PCUf/kI+EmsHle51bMb9wT81CAcwjVGJw2TrCw4IqnOp4p1dUH
         lzF1ArhUVMFynl3kWrdNiRipdJnhr4NJT4D7dWR8E+glFXDTBWwP7wW2rc/KUZmrI5rd
         jF7+PiduScaWeCCJB8422ruXD9TMlSb5Popn6OLuGaBrLwf482YRg8FQ35Fm0ZQu+rEI
         1TYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=foL3X4GlTyfiEn6RrTzFcSbhTXnVxwE4w4R01EbJ6U0=;
        b=1RvvQCnoob590x5djZ6WvpNu17sWEBjYNDnDnHWfM1JnqbDhryEjpVkX3Ey0u4XG6R
         NHGX1kZxtIVQmTy9SXgjx9aCKOSayDRDqUREV1jzq2ByHrX64EuRLbg0yj7yi2i5oZmo
         Cy03Btl/VlXg6g6bShMdcmGjP025MVLymS0HPbrLEKsxda5gOb/i0pY0ttNZX7fOIY+J
         DGrjPufCBdKyTWOTUUkYzsiKeWU9N97IEj51JpuA3BCVkbb2wvzkjpjs9M53V9U1zKDd
         7NQiPTUjfH7/XgO8WT4RTHXwYfKEw6qAEToxr3rDS0Ro7NyMKqJh388QJ6MDkMFv/p3e
         jXbg==
X-Gm-Message-State: ANoB5pm8KJFf4LBYqjNr97Vmx9Qi32KPykZM0yg40e0RC4uRY+mkFn/n
        M+qYi6hmhIcYnXtopb7WXdB1CFjMS7A=
X-Google-Smtp-Source: AA0mqf7440GdnnrwzfQfhYozQ104/VSyt4bdAH1c7Ol/gfK3t6b9H2mhBOdIq8ge1FYmrqwNk/ZWxA==
X-Received: by 2002:adf:fd85:0:b0:242:2ea1:593c with SMTP id d5-20020adffd85000000b002422ea1593cmr1803683wrr.497.1669821801412;
        Wed, 30 Nov 2022 07:23:21 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/9] poll & rsrc quiesce improvements
Date:   Wed, 30 Nov 2022 15:21:50 +0000
Message-Id: <cover.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A bunch of random patches cleaning up poll and doing some
preparation for future work.

Pavel Begunkov (9):
  io_uring: kill io_poll_issue's PF_EXITING check
  io_uring: carve io_poll_check_events fast path
  io_uring: remove ctx variable in io_poll_check_events
  io_uring: imporve poll warning handling
  io_uring: combine poll tw handlers
  io_uring: don't raw spin unlock to match cq_lock
  io_uring: improve rsrc quiesce refs checks
  io_uring: don't reinstall quiesce node for each tw
  io_uring: reshuffle issue_flags

 include/linux/io_uring.h | 11 ++---
 io_uring/io_uring.c      |  4 +-
 io_uring/io_uring.h      |  5 ++
 io_uring/poll.c          | 98 ++++++++++++++++++----------------------
 io_uring/rsrc.c          | 53 ++++++++++------------
 5 files changed, 79 insertions(+), 92 deletions(-)

-- 
2.38.1

