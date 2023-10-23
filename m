Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDF7D2921
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 05:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjJWDfw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Oct 2023 23:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjJWDfu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Oct 2023 23:35:50 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98FEE8
        for <io-uring@vger.kernel.org>; Sun, 22 Oct 2023 20:35:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-27e4e41a4fcso250131a91.3
        for <io-uring@vger.kernel.org>; Sun, 22 Oct 2023 20:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1698032147; x=1698636947; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SWCegtYp8nwfQoYjg8i2/ArRcZBT2vDQSf62c++I3vQ=;
        b=C4JHesz0fbK86A5M9SivEMJH/odsJYZFxXVKw01SMXeIBMp3lCX8c5voio8WESN2Ue
         +1Flt3Kzt9SqNmTDIQSWa42Dugc8Aooi4pmigaVMDbUfdTYmS2pJbApyhyry921+NVpW
         YttytDQLVNcXVzDzrx9El+LeEmM3BEeqdYMczqH4g+3/TYnCgXX6A7iT1xDIIz/TVkxw
         DWC9LE39dYIjDOsoVp7ecHa4bplFPk/rw5YQH6f7WJ2W0v/09QoknsanEvh3OzMhJlNn
         6JgQUALru2jeIPBcp+mkubz7rXiOl+wHBPN2/ov8nq+QdILPRzB1R7OTmb/KouVADPTZ
         nKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698032147; x=1698636947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SWCegtYp8nwfQoYjg8i2/ArRcZBT2vDQSf62c++I3vQ=;
        b=PatY98OIX6fLtUWQYeIV5LR9tKepb2lL0d9LJLcWkUljI2i+wLRvTumS1CogoDxkBy
         p2dwssw/hh/KARJfXNTOZkmpIb2cA3BO7pCkXlr4YSzbXWSAT89r4brycD/UVms2GFmY
         OPsqDsMRwyyBl6HTHc+f8IkVp7p2fq1Uqi5aIMs80jDB18mzTqszPia81cJEqqCdPtxG
         ffXnzAhIU+kD/69XBFZ49Oh2ZL2wI4Pe+jsj/Om9mmhHwas2Cm4ypj4QHDLtxwlONH6K
         S3s3tcsP92BtLSXjuMUvPqrOAYSvUIVpuoEwUuyNrN4ghx0ACE2GHOK/sKdI4mMwhW+U
         VTdQ==
X-Gm-Message-State: AOJu0Yygs10YQPwl4x/GgYDft2mPdfbwuJbuebeG6bIB3LtXpG9Gs62G
        5aDby2/K6wsbnoAyA+VFNGCrGg==
X-Google-Smtp-Source: AGHT+IGj30MoOaVHQFRMT35CFQ5h4aVbtCV+b2A8ofQa/0Atnc2ZnTJtoqCHbtoFEmZO4yaIxgx42Q==
X-Received: by 2002:a17:90a:202:b0:273:ec96:b6f9 with SMTP id c2-20020a17090a020200b00273ec96b6f9mr5688112pjc.25.1698032147161;
        Sun, 22 Oct 2023 20:35:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21c8::1237? ([2620:10d:c090:400::4:c4c8])
        by smtp.gmail.com with ESMTPSA id ip1-20020a17090b314100b00262e485156esm6415514pjb.57.2023.10.22.20.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Oct 2023 20:35:46 -0700 (PDT)
Message-ID: <afcb3c40-0148-46ef-b2be-fa4adc57b88a@davidwei.uk>
Date:   Sun, 22 Oct 2023 20:35:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 00/11] Zero copy network RX using io_uring
Content-Language: en-GB
To:     Gal Pressman <gal@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230826011954.1801099-1-dw@davidwei.uk>
 <1673427d-b449-4f9e-b344-027c0dc2ec9f@nvidia.com>
From:   David Wei <dw@davidwei.uk>
In-Reply-To: <1673427d-b449-4f9e-b344-027c0dc2ec9f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-10-22 12:06, Gal Pressman wrote:
> On 26/08/2023 4:19, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
>>
>> This patchset is a proposal that adds zero copy network RX to io_uring.
>> With it, userspace can register a region of host memory for receiving
>> data directly from a NIC using DMA, without needing a kernel to user
>> copy.
>>
>> Software support is added to the Broadcom BNXT driver. Hardware support
>> for receive flow steering and header splitting is required.
>>
>> On the userspace side, a sample server is added in this branch of
>> liburing:
>> https://github.com/spikeh/liburing/tree/zcrx2
>>
>> Build liburing as normal, and run examples/zcrx. Then, set flow steering
>> rules using ethtool. A sample shell script is included in
>> examples/zcrx_flow.sh, but you need to change the source IP. Finally,
>> connect a client using e.g. netcat and send data.
>>
>> This patchset + userspace code was tested on an Intel Xeon Platinum
>> 8321HC CPU and Broadcom BCM57504 NIC.
>>
>> Early benchmarks using this prototype, with iperf3 as a load generator,
>> showed a ~50% reduction in overall system memory bandwidth as measured
>> using perf counters. Note that DDIO must be disabled on Intel systems.
>>
>> Mina et al. from Google and Kuba are collaborating on a similar proposal
>> to ZC from NIC to devmem. There are many shared functionality in netdev
>> that we can collaborate on e.g.:
>> * Page pool memory provider backend and resource registration
>> * Page pool refcounted iov/buf representation and lifecycle
>> * Setting receive flow steering
>>
>> As mentioned earlier, this is an early prototype. It is brittle, some
>> functionality is missing and there's little optimisation. We're looking
>> for feedback on the overall approach and points of collaboration in
>> netdev.
>> * No copy fallback, if payload ends up in linear part of skb then the
>>   code will not work
>> * No way to pin an RX queue to a specific CPU
>> * Only one ifq, one pool region, on RX queue...
>>
>> This patchset is based on the work by Jonathan Lemon
>> <jonathan.lemon@gmail.com>:
>> https://lore.kernel.org/io-uring/20221108050521.3198458-1-jonathan.lemon@gmail.com/
> 
> Hello David,
> 
> This work looks interesting, is there anywhere I can read about it some
> more? Maybe it was presented (and hopefully recorded) in a recent
> conference?
> Maybe something geared towards adding more drivers support?
> 

Hi Gal,

Thank you for your interest in our work! We will be publishing a paper
and presenting this work at NetDev conference on 1 Nov.

Support for more drivers (e.g. mlx5) is definitely on our radar. We are
collaborating with Mina and others from Google who are working on a
similar proposal but targetting NIC -> ZC RX into GPU memory. We both
require shared bits of infra e.g. page pool memory providers that will
replace the use of a one-off data_pool in this patchset. This would
minimise driver changes needed to support this feature.

> I took a brief look at the bnxt patch and saw you converted the page
> pool allocation to data pool allocation, I assume this is done for data
> pages only, right? Headers are still allocated on page pool pages?
> 
> Thanks

Yes, that's right.

David
