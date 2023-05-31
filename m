Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494A171869F
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 17:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjEaPoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 11:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbjEaPoL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 11:44:11 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19DD12B
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 08:44:03 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-776f790de25so30753739f.0
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685547843; x=1688139843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VCDfCinS9stSsitWfjmIvk+rqXPfi4hHCoTlLHm/DaQ=;
        b=mmnwjchbyQVxfJ9UNtHOJgGG5cLtQcxBhOoPDbUqjgNbYh2aT78GRhWENfG1gZ5VvW
         MH1VMJiV8RgwrpLe14jGdZ0PvrCe2zUWNMEbUq1kLdcgjgnMw2cfmdEK3fIt1gukCmLP
         LmVdSHpl0/vZ62e06VlupyOcCc4iujQEU7ac+B3QmfPZMB75Jl+c8QxxWblAv0hT3g4g
         YCIew5zV6D25X2eYbAwAyR/Z2UBe3Sa3P0bd0oSA6Wv6GIagZMqBJxY4H6OdwwD7Olaw
         uFvoqTu0mKgTv9q6olsZRjlDPo6af8HIB98vqHnjc0F2ssxr7XfG0H9QnueBsAT0J7bF
         P8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685547843; x=1688139843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VCDfCinS9stSsitWfjmIvk+rqXPfi4hHCoTlLHm/DaQ=;
        b=ln5irkam/ZY8CYW2vgtbjJnvT68OkJYTFWYIq2nlYFN4tuZ7P7brx5aMhAWYI6qXXN
         bumaNEqExgHCbnnVPnwAvdM2317Mx0bQRsQ1E9B9WdSlq9vNOiQ1YOj4NGFvlc4LKvfM
         U/NfnpU1YcOgpQ0LZoSe2mHI6tiK1Mc2H/sSLVI5ALfbm2AVPu5OupJNhUYiW44oyprD
         i/HnmQGoiQSZqjpkP2BwW7HEq/NyHt0kg0WkE0naNahWFd/ev5iw6MUdMrXG3MsaH4lH
         Se/y1gxNTIX+sNpZTOgQK8jAJLk1sD2q+u3N/BBufFCLrbfgEwuiZrV3REGsXZLU0fxA
         KvnQ==
X-Gm-Message-State: AC+VfDxfCUGkzqFP5drYuFgX6eaMzx9LwkeISJhmgi3esgNcSWh0RS/P
        tBYY/DNPHB5Pj+JDJG6gbr6eFw==
X-Google-Smtp-Source: ACHHUZ4CoWPBD8nTys5HQpKoFV41Udgwurj67i5533KRVHxL5b7Yj2c/OT1PXJgesQ9+vB7pOT60Cw==
X-Received: by 2002:a5d:9c42:0:b0:775:78ff:4fff with SMTP id 2-20020a5d9c42000000b0077578ff4fffmr1741351iof.1.1685547842906;
        Wed, 31 May 2023 08:44:02 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u10-20020a02b1ca000000b004189da0d852sm1525121jah.167.2023.05.31.08.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 08:44:01 -0700 (PDT)
Message-ID: <5f4f978d-7fba-4d43-b347-dd1bc8add55e@kernel.dk>
Date:   Wed, 31 May 2023 09:44:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring: set plug tags for same file
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230504162427.1099469-1-kbusch@meta.com>
 <ZHZggvjNnhl/69s/@kbusch-mbp.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZHZggvjNnhl/69s/@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/23 2:45?PM, Keith Busch wrote:
> On Thu, May 04, 2023 at 09:24:27AM -0700, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> io_uring tries to optimize allocating tags by hinting to the plug how
>> many it expects to need for a batch instead of allocating each tag
>> individually. But io_uring submission queueus may have a mix of many
>> devices for io, so the number of io's counted may be overestimated. This
>> can lead to allocating too many tags, which adds overhead to finding
>> that many contiguous tags, freeing up the ones we didn't use, and may
>> starve out other users that can actually use them.
> 
> When running batched IO to multiple nvme drives, like with t/io_uring,
> this shows a tiny improvement in CPU utilization from avoiding the
> unlikely clean up condition in __blk_flush_plug() shown below:
> 
>         if (unlikely(!rq_list_empty(plug->cached_rq)))
>                 blk_mq_free_plug_rqs(plug);

Conceptually the patch certainly makes sense, and is probably as close
to ideal on tag reservations as we can get without making things a lot
more complicated (or relying on extra app input).

But it does mean we'll always be doing a second loop over the submission
list, which is obviously not ideal in terms of overhead. I can see a few
potential ways forward:

1) Maybe just submit directly if plugging isn't required? That'd leave
   the pending list just the items that do plug, and avoid the extra
   loop for those that don't.

2) At least get something out of the extra loop - alloc and prep
   requests upfront, then submit. If we have to do N things to submit a
   request, it's always going to be better to bundle each sub-step. This
   patch doesn't do that, it just kind of takes the easy way out.

What do you think? I think these are important questions to answer,
particularly as the overhead of flushing extraneous tags seem pretty
minuscule.

-- 
Jens Axboe

