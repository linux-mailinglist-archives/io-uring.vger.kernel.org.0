Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E1756BA02
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 14:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiGHMrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGHMri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 08:47:38 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6B7606AB
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 05:47:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b2so16263131plx.7
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 05:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=gD0MdOAi5N1Bvv7u45BiubneW3L/S0YMoPCL+vX2Tl0=;
        b=IvLZvKXEI+4Ztrh2H9f8dW1KPWT0F0TaozXmXUuKbbU84urZJDWR1rbqpOXbzrfNe1
         oYTzkK9JhuUc7EwPqSHgulqjHRK+RZmzJOoJoM/jpHDR7LfvLvZb30prEDFpqVxzdfdL
         N5dUsJWwJAUDLW2JSWwFiLQG3Ar9hiGLsWbqQDc+6vZSIlCGO24DPmAF2TcbiGcOOzlp
         Uf8GCmHoNsvUsxb32w6/Uitv8C0xT2d+MiinkvrQ7YOTsn6TWaaYwGlQEDfL2JMZqeAX
         hy2lqZrQP+uAahpPYZEVM3qwtmWldIAR3xG8tnFVxGYWy4uhwvIBPX1aYDoh9/K19NIQ
         LNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=gD0MdOAi5N1Bvv7u45BiubneW3L/S0YMoPCL+vX2Tl0=;
        b=aAXBSVU7xC66jluSqTObbK4B6N/LZXU8vmXTTOn/27T8Pd543xRCFo/t8sGfKttFox
         nORWljMbsTuIsXnFuEZJOp+ZtuRvraWqvkRRVkcPpZ6mmMJuxjHyBTqhMw6Fu1hSLPe5
         GkI6sMevxwupOLyVIwm9aCjjqxzlf4dRXp0S+Rz8SS1AlUCXXlLODI3kkbSPSuPRTdSZ
         1nyipofVtLzp1ncE+zsO8mzKHP0rAJIqG88I6iab36REi1Eq67+QCb7bqo73H0C0QuJe
         uZICXgjX8ZOOUPBKk7YVk59JvGw9A5n8U1DxdxY70DtXpOJGlYKPJ+KjOOvPYb4KUO0D
         Q/8w==
X-Gm-Message-State: AJIora/8UvGRdH8879U0UUyW6j3w8AqjU9+O563T8n483ySOg6ZTUEW9
        DkoX5I3xaZnOt/amCnySrubmixeZ3I2b8w==
X-Google-Smtp-Source: AGRyM1vIzp2xhnsdt/PLp0JlyEqj59DV7iUjXrvyg6g0a/pIauXDODpjXDugIIyD1nagvu9jW7Pt4Q==
X-Received: by 2002:a17:903:22c7:b0:16b:fa15:63d4 with SMTP id y7-20020a17090322c700b0016bfa1563d4mr3560890plg.2.1657284457197;
        Fri, 08 Jul 2022 05:47:37 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a18-20020aa79712000000b0052aaff953aesm1485681pfg.115.2022.07.08.05.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 05:47:36 -0700 (PDT)
Message-ID: <bcefaf51-69bc-ac57-972e-9419ef3d6f8a@kernel.dk>
Date:   Fri, 8 Jul 2022 06:47:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring tweak for 5.19-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a minor tweak to an addition made in the 5.19 kernel cycle, padding
a 32-bit value that's in a 64-bit union to avoid any potential funkiness
from that.

Please pull!


The following changes since commit 09007af2b627f0f195c6c53c4829b285cc3990ec:

  io_uring: fix provided buffer import (2022-06-30 11:34:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-08

for you to fetch changes up to bdb2c48e4b38e6dbe82533b437468999ba3ae498:

  io_uring: explicit sqe padding for ioctl commands (2022-07-07 17:33:01 -0600)

----------------------------------------------------------------
io_uring-5.19-2022-07-08

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: explicit sqe padding for ioctl commands

 fs/io_uring.c                 | 2 +-
 include/uapi/linux/io_uring.h | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
Jens Axboe

