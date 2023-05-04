Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93846F6D85
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 16:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjEDOJ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 10:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjEDOJ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 10:09:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BCC83FA;
        Thu,  4 May 2023 07:09:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bc2feb320so859243a12.3;
        Thu, 04 May 2023 07:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683209394; x=1685801394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RM9Ca/E1x9z/ehVV2ens1sHIiZlbsELcW8zbvp45NXU=;
        b=S8sXJlk1Z3ujOWn83w/A8d4Kgo9fsdXVYJAs4vUU7pbRrJ5FH/ubU4ru5YVtB5Xvi4
         O0gZY5/31T/iNK+MBdZbuYNjjGICfbPQbL/akOtxSZkHqPq8rkq+QHUifNG7u7tRufcK
         w4x3CGLFowKa958P2P7Dh7ePYMXcmHsu6lsitLaOcQyqEtJALZA4pIa3nIFGr4P95gVA
         /VG32ESjd/8kd9Pv/HILCf69NsbzjDwuOwU5sHGRPm4zLW2SPA4LGn/cqw851mc5pOL2
         W9dCK2y9fJIT1ZwUhbffq/Rf8u3V2zJn11luZ8Ck262KwHxW0+2LW9ImbYO94lsFh4Am
         7eDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683209394; x=1685801394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RM9Ca/E1x9z/ehVV2ens1sHIiZlbsELcW8zbvp45NXU=;
        b=GUuNkpyC0bgKHrGJQqiaHMU+LeBrtFX2tirDsVIPp819QNHr2XYR4acG0MRR5NQDaz
         uv+CQvCJses0k3YjKsnvaX9ic27b0T0mtAOFB6dbQkRsxWpBE2HDjXvSBNBRfaM1VxyJ
         hkkR86bROl/fDW0jpFMToqmATyiLoX5SQ6/i/3utWY9jfvJHMusLJ3CdjWc/R/NXSIOH
         8obnChxZ9Y2bTdM1yQzk/y/I2Azq/gpnXdOCwomi+upncZbJm2YcXYfPamDbawOLt7Wh
         HJK+PxiwNwGBxfaGJWSlUqz1qQEIpunckpcM6+7J2jjVrnwJbB2Dj4cYXVfBrPNhDzUK
         N9UA==
X-Gm-Message-State: AC+VfDwnLVCU57sdDw3rlISQ1bNv86NRAUOA4gnM5BQqidX/8w0fcZlY
        QZ3tcleL+NoJI8sjI5R9zhU=
X-Google-Smtp-Source: ACHHUZ6w78XWE7vgQ5zdFqMb3sHlKvkr5gsykVkpVOQwrs3z4tt1/+k9hZ5rIvPjqFwJuvLOlt9AwA==
X-Received: by 2002:aa7:da5a:0:b0:50b:d421:a0f1 with SMTP id w26-20020aa7da5a000000b0050bd421a0f1mr1531749eds.41.1683209393664;
        Thu, 04 May 2023 07:09:53 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::20ef? ([2620:10d:c092:600::2:1631])
        by smtp.gmail.com with ESMTPSA id w17-20020aa7dcd1000000b004ad601533a3sm1907576edu.55.2023.05.04.07.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 07:09:53 -0700 (PDT)
Message-ID: <4451b9da-09b2-1269-54fb-630178e78391@gmail.com>
Date:   Thu, 4 May 2023 15:09:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 0/3] io_uring: Pass the whole sqe to commands
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@lst.de, axboe@kernel.dk,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
References: <20230504121856.904491-1-leitao@debian.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230504121856.904491-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/23 13:18, Breno Leitao wrote:
> These three patches prepare for the sock support in the io_uring cmd, as
> described in the following RFC:

It doesn't apply, seems there are conflicts with ublk, but
looks good otherwise.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Link: https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/
> 
> Since the support linked above depends on other refactors, such as the sock
> ioctl() sock refactor, I would like to start integrating patches that have
> consensus and can bring value right now.  This will also reduce the
> patchset size later.
> 
> Regarding to these three patches, they are simple changes that turn
> io_uring cmd subsystem more flexible (by passing the whole SQE to the
> command), and cleaning up an unnecessary compile check.
> 
> These patches were tested by creating a file system and mounting an NVME disk
> using ubdsrv/ublkb0.
> 
> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
> 
> V1 -> V2 :
>    * Create a helper to return the size of the SQE
> V2 -> V3:
>    * Transformed uring_sqe_size() into a proper function
>    * Fixed some commit messages
>    * Created a helper function for nvme/host to avoid casting
>    * Added a fourth patch to avoid ublk_drv's casts by using a proper helper
> V3 -> V4:
>    * Create a function that returns a null pointer (io_uring_sqe_cmd()),
>      and uses it to get the cmd private data from the sqe.
> 
> Breno Leitao (3):
>    io_uring: Create a helper to return the SQE size
>    io_uring: Pass whole sqe to commands
>    io_uring: Remove unnecessary BUILD_BUG_ON
> 
>   drivers/block/ublk_drv.c  | 26 +++++++++++++-------------
>   drivers/nvme/host/ioctl.c |  2 +-
>   include/linux/io_uring.h  |  7 ++++++-
>   io_uring/io_uring.h       | 10 ++++++++++
>   io_uring/opdef.c          |  2 +-
>   io_uring/uring_cmd.c      | 12 +++---------
>   io_uring/uring_cmd.h      |  8 --------
>   7 files changed, 34 insertions(+), 33 deletions(-)
> 

-- 
Pavel Begunkov
