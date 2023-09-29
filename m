Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B457B2EE9
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 11:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjI2JKR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 05:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjI2JKQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 05:10:16 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF24180
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 02:10:13 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-65afc29277bso16301456d6.1
        for <io-uring@vger.kernel.org>; Fri, 29 Sep 2023 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695978612; x=1696583412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gVPoDwED/3vdT2y5haESWfuwV08aq3nQCh+nBXXODQQ=;
        b=EvWNAh4DK4uHF5s+F+Mc96yfPUufWKQNa9BCIsOqP9B/2SzVuug+dzLqW8GyBCoyDw
         y75cpe+/j8h8mbFqY1akTzhgZwW/U9cJ5DTWgrQJFLr7dlfhwGuQCRTh4Tyc9UnWRC5R
         Q1igVD/HLppbGEX81cYUGzkj7k3OdmEOxYaJjFXs/yigHZJzawtQXrfKfcWf9TO5my9G
         Wc+twhVdEXruv1oY7WLcc9otFobURT0xn3htmgd/L7YiVgK1E2Kb8ZHn+xATZukmoojv
         PEYkknPJKrx+/tGHDcHG0d8MMdejtqxu6uo5Rv8+9nwy2rvtuLSjJJj1El/Lsj3X/8j/
         tPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695978612; x=1696583412;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVPoDwED/3vdT2y5haESWfuwV08aq3nQCh+nBXXODQQ=;
        b=LgqRIuJnovABN9Vo3/vXRJZMmEcQ/dhDzK4tsV07KbncOB7QLDnBWmwSX0ET/Zg+IG
         30iD7tKFDuE3mYgAgsv+FWtNPOOwG6v5QttyeVS4igZFYQS2l6Z/4TDIIHexVhPw5yDC
         bUcnADNZWbTbLeXY7vCGQgQ6s3OUQaxScDtQ17vVYZgVrQgTOxXJNXBovjyp7q/MzKHR
         uF6a//l6bNR7bkj4ku1FQwUmeXrZzQz7lel/eghJBIkE+cm7TSJJ8JD3d/Fux6XUOiSg
         qnAGATcB06CVr3ZJpzyKkbArlBSHxeT2LzgN0ILM0WESna1XM4qPD5zLZE2GUs9SOdaG
         gVVQ==
X-Gm-Message-State: AOJu0YyfFKdtH1cp1E4awweLwcBmkoDkjq68KPW2LpOZF2NcREcpZD7r
        ZOkzzWpmxePN0p5UXvyJ1PNRHA3rnDTJqWOv6A6nGA8x
X-Google-Smtp-Source: AGHT+IGStYonvNO0VqWJsT5++UUu+RHLNXsXq+UyHPwzSkPPFphJ9C14OI5PHETR2fRrdBDClheMLw==
X-Received: by 2002:a05:6214:4015:b0:65a:fd40:b79 with SMTP id kd21-20020a056214401500b0065afd400b79mr3737678qvb.5.1695978612478;
        Fri, 29 Sep 2023 02:10:12 -0700 (PDT)
Received: from [172.19.130.163] ([216.250.210.88])
        by smtp.gmail.com with ESMTPSA id o8-20020a0cf4c8000000b0065b260eafd9sm2859274qvm.87.2023.09.29.02.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 02:10:11 -0700 (PDT)
Message-ID: <d3d75866-fdc9-425c-93ce-559b1a2e8212@kernel.dk>
Date:   Fri, 29 Sep 2023 03:10:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fix for 6.6-rc4
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <e997821f-7f68-4ca3-9689-b6e10ebd6978@kernel.dk>
In-Reply-To: <e997821f-7f68-4ca3-9689-b6e10ebd6978@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/23 12:06 AM, Jens Axboe wrote:
> Hi Linus,
> 
> Single fix going to stable fixing the flag handling for
> IORING_OP_LINKAT. Please pull!
> 
> 
> The following changes since commit c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f:
> 
>   io_uring/net: fix iter retargeting for selected buf (2023-09-14 10:12:55 -0600)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-28
> 
> for you to fetch changes up to 2a5c842528a0e745fbee079646d971fdb14baa7c:
> 
>   io_uring/fs: remove sqe->rw_flags checking from LINKAT (2023-09-28 09:27:15 -0600)
> 
> ----------------------------------------------------------------
> io_uring-6.6-2023-09-28
> 
> ----------------------------------------------------------------
> Jens Axboe (1):
>       io_uring/fs: remove sqe->rw_flags checking from LINKAT
> 
>  io_uring/fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Note: I amended the above commit to add a Reported-by tag, which I
didn't have originally. Everything else is still the same. Updated
request pull output:

The following changes since commit c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f:

  io_uring/net: fix iter retargeting for selected buf (2023-09-14 10:12:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-28

for you to fetch changes up to a52d4f657568d6458e873f74a9602e022afe666f:

  io_uring/fs: remove sqe->rw_flags checking from LINKAT (2023-09-29 03:07:09 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-09-28

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/fs: remove sqe->rw_flags checking from LINKAT

 io_uring/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe

