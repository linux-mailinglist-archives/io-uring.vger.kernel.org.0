Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431E251608C
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245109AbiD3Uzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245095AbiD3Uxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C3913F70
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:26 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so9956622pjf.3
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PjWgR1h1fKdvS3YyRmsbCkFB9vbVcOXVuG6naj23CyY=;
        b=Q4ZPGAsmB1yMyF4mMqI7Aa1GH//ayM76qTlVD8jYwbo4Fg3sKrRndulE1ssd0dqoLo
         TAjAC+tqZzYklhGAUR/Qapa1/fBfwjzk9VYluSHus57hYRIMysC+pjOVkD9sfIdiUCDS
         8R+fD0I8q3VuYYBItviGL/kPw9BPmORtdJqwSbi2xjD7sy2mZNQF94sxbdH4rzDnUVKD
         DAw64qDcwVoO6FCTNOn3NjSLnpY+d8gmjfjIUH63lR31vWMX6ZdJu7kbVjyeWLgVXYEZ
         TZqxhbCQWrGVoIkvAizLBd4Xd15h5V2CBnWM3rldYyVVthDtYbfynK7WRAsKWsB9JdV6
         vDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PjWgR1h1fKdvS3YyRmsbCkFB9vbVcOXVuG6naj23CyY=;
        b=ibN0Pga68JMV/irATpvbUSREpZ30CqOczfqbJJxTeS+/CTmAJcz0xgb/+Qb3xZ8djF
         jAMD2PFrKinPyBxUTScnYo0EEx2MZO0vbJApR8OYU53OhR0RChLU63TIM2Zx5EZAZjBb
         pv+0TPFbyEYYSFF0Vq2rpVCw9UmDcfUZx+717QQDGGKwWswm2j+CdMRi9DnQKKtrGB3O
         NUI+qi497h76o8TwMwM/3RQTzrr+x0xrySikyfmyZkb5Ol5O30bJxEjQ2WQGajUMlQ4z
         l3iElObUBMrO9QGpUkzvkKKQQOi/r7MWGbHZWOjCKdpfTeCnFNB5rbcZUN7nmcKvZu7z
         ip+A==
X-Gm-Message-State: AOAM530k8ic2sK1nIBI/6RtXqg/HCPFn97jdN2xkLMuT8B+MlCG84Edu
        gkoAlzrya77wHAYAqqqmrmZyS0GxABmkiJNY
X-Google-Smtp-Source: ABdhPJzCkC+CY+EpocCJ2vB51OL52BQTg1nE77A1N5NdKtGtkHGyC0JA7ph50quGxdMcCKJGFpc30A==
X-Received: by 2002:a17:90b:124a:b0:1d9:de12:520f with SMTP id gx10-20020a17090b124a00b001d9de12520fmr5607849pjb.28.1651351825892;
        Sat, 30 Apr 2022 13:50:25 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/12] Add support for ring mapped provided buffers
Date:   Sat, 30 Apr 2022 14:50:10 -0600
Message-Id: <20220430205022.324902-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This series builds to adding support for a different way of doing
provided buffers. The interesting bits here are patch 12, which also has
some performance numbers an an explanation of it.

Patches 1..5 are cleanups that should just applied separately, I
think the clean up the existing code quite nicely.

Patch 6 is a generic optimization for the buffer list lookups.

Patch 7 has the caller use already selected buffer information rather
than rely on io_buffer_select() returning it for REQ_F_BUFFER_SELECTED.

Patch 8 adds NOP support for provided buffers, just so that we can
benchmark the last change.

Patches 9..11 are prep for patch 12.

Patch 12 finally adds the feature.

This passes the full liburing suite, and various test cases I adopted
to use ring provided buffers.

v3:	- Speedups
	- Add patch unifying how io_buffer_select() is called when a buffer
	  has already been selected.
	- Build on above change to ensure we handle async + poll retry
	  correctly.

Can also be found in my git repo, for-5.19/io_uring-pbuf branch:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf

 fs/io_uring.c                 | 475 +++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  26 ++
 2 files changed, 382 insertions(+), 119 deletions(-)

-- 
Jens Axboe


