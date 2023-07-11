Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F1974F932
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjGKUoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjGKUoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:44:00 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938CE1AE
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:43:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-682b1768a0bso1337177b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689108239; x=1691700239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MjESMioTk0k963l+dIJZ6fHN9PlUT4kb3GUAAzx+6ok=;
        b=3SgN9Nzcd9LJSAjE0up/Q3WBMI2jaqmb7UOPlEF2NAu75ktp5fcVjkkY+FwBWKiSjv
         KAhs2ALXw3z30wP9gmOoxoCPnTYLGfX4DzesF85eZGjAIaNiUFzLBf93dhAE3KlRmLY7
         44ZLi99pliNY6CSeLR+PhscWCXuVmWhBQhj39NIe6pJ20FQnsrcrRhBaLjbdHz7bfdq/
         hvgLOtPg43L9KzVT1khmxiQbpc6h1X0b2hezfeHDTxWMeJHxW/Kh4GKFFol2WIw2z17g
         6wHbgZv4utBcxyzmKqjkvJDzxy2W9g/sDAYnr9fJgcQxi+y/Ual0irtUx6XkANGvtYH7
         sYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689108239; x=1691700239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjESMioTk0k963l+dIJZ6fHN9PlUT4kb3GUAAzx+6ok=;
        b=IcwnrUPLwUMCjfTg4ohFlZ3Ge2krKP4rcL7yNoOd5tl21nGkHJPaOdC4Ai81nNQVGw
         5r1iR4lpmRia8qxPME8DQjVi87i6+tZu46xw+8uo56nraU/+0AOo8jWOVVcWfrK/cn7e
         eXY95tJmXmrPoSy3vF9SkKzsV4um5gRInl/t/apnPckBOq/GHGq7jX9Gmn+TMO7ltr9P
         AIaojn35UlGQdZCco9RuN+Qqqp2qTLI8DfdVLKJp4NrP9YLu+jrT+h15J0LpU3kSOlQJ
         pyV4TCD8sYm+zG+MSejvxJYHfy2MIMlvX1vOfnBDiWuJkYk5+Mm6IB/NEGHlOJWEWWsn
         WACA==
X-Gm-Message-State: ABy/qLZelT2R73aXlpHZk/8rTxKtdA/kE2KEjMAxXAKsmUcRlltuBcVj
        s0CtSQ4Ls48YKa5SAVkat7Ck4f+xz2xqQnY3lM8=
X-Google-Smtp-Source: APBJJlEtMP2E5bwfi5e13FjrN+dMiCc1084WVvCVnaPerCJ3mBn3ukG2cp01ykd4JNTkYx0JGAkpkg==
X-Received: by 2002:a05:6a00:3a2a:b0:675:8521:ddc7 with SMTP id fj42-20020a056a003a2a00b006758521ddc7mr19669642pfb.0.1689108238650;
        Tue, 11 Jul 2023 13:43:58 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f7-20020aa78b07000000b00640ddad2e0dsm2124461pfd.47.2023.07.11.13.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:43:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de
Subject: [PATCHSET 0/5] Add io_uring support for waitid
Date:   Tue, 11 Jul 2023 14:43:47 -0600
Message-Id: <20230711204352.214086-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This adds support for IORING_OP_WAITID, which is an async variant of
the waitid(2) syscall. Rather than have a parent need to block waiting
on a child task state change, it can now simply get an async notication
when the requested state change has occured.

Patches 1..4 are purely prep patches, and should not have functional
changes. They split out parts of do_wait() into __do_wait(), so that
the prepare-to-wait and sleep parts are contained within do_wait().

Patch 5 adds io_uring support.

I wrote a few basic tests for this, which can be found in the
'waitid' branch of liburing:

https://git.kernel.dk/cgit/liburing/log/?h=waitid

 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/Makefile              |   2 +-
 io_uring/cancel.c              |   5 +
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |   9 ++
 io_uring/waitid.c              | 271 +++++++++++++++++++++++++++++++++
 io_uring/waitid.h              |  15 ++
 kernel/exit.c                  | 132 +++++++++-------
 kernel/exit.h                  |  30 ++++
 10 files changed, 411 insertions(+), 60 deletions(-)

The code can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-waitid

-- 
Jens Axboe


