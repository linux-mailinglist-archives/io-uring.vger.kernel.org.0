Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7444B2A90
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 17:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbiBKQjf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 11:39:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242091AbiBKQjf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 11:39:35 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F6102
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:39:33 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id 9so12104966iou.2
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=8+8IolD1lac0TeVTBZq1Exwxs1rYX1hSFFbrpHJCzCo=;
        b=J+V/xPeEKOaaq04Rv/d9r94/uJ2f84rPQu5arSCMjhXUpRxjG7vu0veEXjZ2HRhNWt
         2WpS7mnpQMLHj5nsQJp7bw1X8zMIgCZSABktsUsDaLF7T/v0RbGXG6r3u1MxlSBUuPJZ
         wJeqQy21gOTnFownWq3GX0RiX/wo7viTPkfzEQi/YIrHJv2cya/HHk2hXuT83r4bofkO
         h6RFgfXa+K4fVYHKfd9t72Z8cBvRRvGsSPBNCHUrzjKrAuZ8cbx7kil58imfWM3ed6A7
         B7sHFhTG3f5UlgycSq3Pb4zm+CSMEWb7QR9jye+tK9DVnyWWoyV87eLb1/OD/aOrJ9HN
         lcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=8+8IolD1lac0TeVTBZq1Exwxs1rYX1hSFFbrpHJCzCo=;
        b=IjV2NteLUzTtojPHBxtwiyDEOnEvGAiPE4XQoG62zpMu+YKfpMAJ4qtETByy4E5DgU
         K1cRkLEjVFZUCQpRGima9u2TjxN3JIqM+0+mF0BoyWC3b6ynZl5OoSDm0D4/RL+Lh2Sc
         0URgc2wZSvJg8Pfj5vJT0jsGdXi6sY9dYnlKhEbGC/CXJvXADq09MYxjMOjYNX/Be//x
         ozC8FKwjlDKT3kYguvHABDqPiULgf7iJwUz6cApg8WhWkBCO84uxxHJgNn+P/a2N66My
         dDNsaoae67Mh144//FIsR32vqI0uFZPbI9It8OSsG1lWva1Rm1bjpcPAVO13KZtkoi11
         Ppcg==
X-Gm-Message-State: AOAM532Te5g1XArxi2KI8uvSb6L1IPbWXJgxX0d4KEA18ni+Zm2aauQH
        45Ocloc12gqRblMnOfW97Qt+1c+S57ge+pzR
X-Google-Smtp-Source: ABdhPJz/EdVKKRcE7Icquzv6QylBvENT63t3xAW6NdkdlNCyX32RzbqFC6DDt8Dm1om4xKlKJWLs+w==
X-Received: by 2002:a05:6638:2054:: with SMTP id t20mr1281350jaj.207.1644597567992;
        Fri, 11 Feb 2022 08:39:27 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p13sm14374628iod.51.2022.02.11.08.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:39:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Nugra <richiisei@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
In-Reply-To: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
References: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 0/4] Refactor arch dependent code and x86-64 improvement
Message-Id: <164459756644.76233.12603309737975123760.b4-ty@kernel.dk>
Date:   Fri, 11 Feb 2022 09:39:26 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 11 Feb 2022 22:57:49 +0700, Ammar Faizi wrote:
> We have many #ifdef/#endif in syscall.h since nolibc support is added.
> This series tries to clean them up, separate the definitions into
> smaller more manageable pieces.
> 
> Also, optimize function call for x86-64. Avoid libc function call for
> syscall even if CONFIG_NOLIBC is disabled. If this patchset is applied,
> CONFIG_NOLIBC is still meaningful, we may still use libc for malloc(),
> free() and memset().
> 
> [...]

Applied, thanks!

[1/4] arch/generic: Create arch generic syscall wrappers
      commit: d238216f0d45d7670d7aa10e753ac049c2b9bd61
[2/4] arch/x86, syscall: Refactor arch specific and generic syscall wrappers
      commit: 8347a3d9553a2f31affddacb7bd9eaa14f2e7ed7
[3/4] lib.h: Split off lib header for arch specific and generic
      commit: c099b832a97dc1880b89734ef6a5420497a1be0f
[4/4] Change all syscall function name prefix to __sys
      commit: e1f89765f957accc4c9a0e3ca233532c6564548b

Best regards,
-- 
Jens Axboe


