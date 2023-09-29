Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6076F7B2C2B
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 08:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjI2GGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 02:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjI2GGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 02:06:12 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A27219F
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 23:06:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3232e96deaaso1536959f8f.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 23:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695967568; x=1696572368; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAD8UdNvsgIL3ySpK/apYpZ4eBhDESH6f7tq8mwUvA0=;
        b=fREKwQjPDaKp8nOER2rR/cGmRWGim/28UfEPYeIA0Al+6xkMU6+u/JDRtrKrcETHyi
         bGNAljo+xsltvZMDrb8Tz8cA6EXnECfnPlXnDTS77JImRrYnrqVO4/lBYfKDit+2rii6
         TWoPWjVVbpY9q0V+2o3D6hs7Kmsr7nj91Qj64UwwlUizBjH0TylUgAvr+en3Bu9wTsuz
         ak5QoWhzzO3C5oEWUGos4i4kTo/SM7yUCvy359Gx5fiNHOZri86zAXUoA8gDwCtDtLmZ
         fwc2I4GxPc4Vyz9dy8DMPmnFJn+G9WW5ZxMCcIKwsrKmL92rQ00Ecmeh2Y4H5KLFaLqe
         cNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695967568; x=1696572368;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MAD8UdNvsgIL3ySpK/apYpZ4eBhDESH6f7tq8mwUvA0=;
        b=WE2yofkrvUy6IK8FtvYLDtAP+yAJ2u3PrQmvN34rWBb7s2B/HeTWPkvOaQsGgTCDXU
         H9w5QH+NFRwFhzXDRDZcfsFP1i/tWeiFh9pjNPHnUdaDKyh1c87N3Arba7dHhAqalEap
         MmmUtiSxq61Cm9dAjZsf7Tm9brVKSNZ+T9v1caH4P8Vb3JxjTMb1aviPnn3g7QHm3ry5
         4pwm+fEts25+p78IYOcWZwB0w/161JE2YoeKgvZ3LgGaWpR6maGelKOWAiJLjb0bRTOs
         p+wwD7+kj5OnYmJ56nJMYZZr0sjrkh6fXjr8ddOv4BIV9rn4peHb/38f6wQrmY6MO/a5
         v0sg==
X-Gm-Message-State: AOJu0YwaH2uweMoBQM49xErSDFVIuyfMB4HJ6YITB+NZarWQXhq2RcoG
        yXRpCwcV+BEcsOZvg6vA1wvUvL8qjjXD5mnraLwkg2q/
X-Google-Smtp-Source: AGHT+IG7X+L03tfR1vNVEt/8KwmXbEF9x6W2bO41qJdRPtDBCTaqx9iXEPgHQxeZ/dSlByqPzlqt+w==
X-Received: by 2002:a5d:5151:0:b0:31a:e54e:c790 with SMTP id u17-20020a5d5151000000b0031ae54ec790mr2632742wrt.6.1695967567870;
        Thu, 28 Sep 2023 23:06:07 -0700 (PDT)
Received: from [192.168.50.224] (ucpctl-mut-vip.hotspot.hub-one.net. [94.199.126.32])
        by smtp.gmail.com with ESMTPSA id b15-20020adfde0f000000b0031c6cc74882sm20900372wrm.107.2023.09.28.23.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 23:06:07 -0700 (PDT)
Message-ID: <e997821f-7f68-4ca3-9689-b6e10ebd6978@kernel.dk>
Date:   Fri, 29 Sep 2023 00:06:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.6-rc4
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

Single fix going to stable fixing the flag handling for
IORING_OP_LINKAT. Please pull!


The following changes since commit c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f:

  io_uring/net: fix iter retargeting for selected buf (2023-09-14 10:12:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-28

for you to fetch changes up to 2a5c842528a0e745fbee079646d971fdb14baa7c:

  io_uring/fs: remove sqe->rw_flags checking from LINKAT (2023-09-28 09:27:15 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-09-28

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/fs: remove sqe->rw_flags checking from LINKAT

 io_uring/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe

