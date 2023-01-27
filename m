Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45A67EF16
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 21:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjA0UDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 15:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjA0UDU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 15:03:20 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7E3908E6
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 12:01:29 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d3so6061254plr.10
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 12:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0qDFotLQKcvpZGv4NiLLCTNFuHzpv4aEoaONI/+Kn4=;
        b=b5ghtGMl/Mvc5ODB/InrkPVt1xMMtshP1cUA8aCS+6aiXY+FbQfLP238Poe2teIvav
         cBK9QrI5SKLH/hz/93+ypjMHr0uL1JQBAq1KKftq8l1UDjNzU6jg87kQBPyPG/s8bbAo
         HGWMKJqqo7E3jU0ZV46n5K0LTxCkCEwp6BKDYGElTCO7SCHS3pVRGtA1SUYJWw1EalUf
         BWMVaJn9a6iRJxEiQ0WnZZ+bWUhrIHPjIVpG0uAuhxmOqd1J5QyFJwoUGF/jynUgeLL1
         uTRitVwcppDg1YP5iolC7zNr5YQw3j3GPslf5Iq1hcZcsptm8bqkn174V7GbRt1iauum
         KBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q0qDFotLQKcvpZGv4NiLLCTNFuHzpv4aEoaONI/+Kn4=;
        b=kT2YBu43NmYn9qxjAp1ptikmXaw/1BROAo7HJ8uQUuLDqI7eia+DLq1DdTbjOfH7DA
         tLDz9nWCCrGG+71F11VzxbenF4Qzh1TtbPHiD+5IkP74YeYVP31vvYulGcLdPlszxojm
         cuHjmUf2OABTsRAyyNtVSalZsTk1bcCKxIeywm+azcVJ8zmkHBazcRlUXpW7mYb99GMA
         euWT52pE6/o9yVO0IMAzyhjs7f8nCY6cmhW6sb41dljvq5b6q0RK08VFhqIsbWJjliOR
         0WKbYuEf7Fd1QlsjbogKsUzuF9iPuF25KUQnK791QhqvSw1BdZmvWkSGi0a0RjcfLdEz
         aZRw==
X-Gm-Message-State: AO0yUKXF4TR8MqvwMeHaTUMi/y3IjDX/mvKhaKHIIQek1FjG7BF3O46X
        crdOfsk4WW7qplELN/rXmxTIENvNITacTD3S
X-Google-Smtp-Source: AK7set8bGRStscS5j6geyodRTcrQwBEkeKEg3tsqg1wNP+uL+NBJvPJu5NnUOg9BX8fZ8nQx3SUzkg==
X-Received: by 2002:a17:902:e88d:b0:196:b0c:f084 with SMTP id w13-20020a170902e88d00b001960b0cf084mr3899346plg.0.1674849688048;
        Fri, 27 Jan 2023 12:01:28 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902b58800b0019615a0d083sm3225621pls.210.2023.01.27.12.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 12:01:27 -0800 (PST)
Message-ID: <55d9c30b-6a67-3126-d7a3-b844e00324d6@kernel.dk>
Date:   Fri, 27 Jan 2023 13:01:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.2-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two small fixes for this release:

- Sanitize how async prep is done for drain requests, so we ensure that
  it always gets done (Dylan)

- A ring provided buffer recycling fix for multishot receive (me)

Please pull!


The following changes since commit 8caa03f10bf92cb8657408a6ece6a8a73f96ce13:

  io_uring/poll: don't reissue in case of poll race on multishot request (2023-01-20 15:11:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-27

for you to fetch changes up to ef5c600adb1d985513d2b612cc90403a148ff287:

  io_uring: always prep_async for drain requests (2023-01-27 06:29:29 -0700)

----------------------------------------------------------------
io_uring-6.2-2023-01-27

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: always prep_async for drain requests

Jens Axboe (1):
      io_uring/net: cache provided buffer group value for multishot receives

 io_uring/io_uring.c | 18 ++++++++----------
 io_uring/net.c      | 11 +++++++++++
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
Jens Axboe

