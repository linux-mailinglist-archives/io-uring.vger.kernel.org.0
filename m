Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303DB57362F
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 14:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiGMMRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 08:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiGMMRg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 08:17:36 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444E9A238F;
        Wed, 13 Jul 2022 05:17:35 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id a5so15232005wrx.12;
        Wed, 13 Jul 2022 05:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F/hDU5t/SYe5V0/3VS5pxCEmSkWFDNtQGXEw7qwTLNo=;
        b=CFEhMlZFODBTfW/nuPD+pSQIeWu/DMB01MpWxUZjt6R2ysgDL6msEh5/5ntKHCMSB9
         aQnU/H4BPLV1XdaKfnuGE4vOdBthSOSM24dYn4hOmxy6C67HU7zuoeFeA8Jf4MSq/lTE
         jiCtZ0E7+7XYGl1GWFRAc6IO377a3KedIH55Le0aiHr257UXtdTkQvR+X5tatNnLOUeb
         3UVT85LnwbLvbD/ICGLweg16TLx8mzKOD7ald6vPrf6X4KhEBYh/3vrhw0JIQDkbAZAM
         IaVi3NN0B2W/Vrx6V39imgQMZGdHKjxryFOZCvMCXFHabKd5ClVadO7IYcLfoKtSfigr
         +mTg==
X-Gm-Message-State: AJIora+Kcgt9l8XNb+FJyJsq8d6g+h2JwyTHn+FjVx3F58RWGt2ZRsbZ
        NiZW6BhnNk4FbujEvA6BacQ=
X-Google-Smtp-Source: AGRyM1tAELyc3EL80IJoRz+3GsaLhUTzyAc4LlhFA9oAzjwelcEYV2FL/crE4onZIaPYOe0ifaiCCQ==
X-Received: by 2002:a5d:5983:0:b0:21d:a811:3b41 with SMTP id n3-20020a5d5983000000b0021da8113b41mr2821809wri.441.1657714653787;
        Wed, 13 Jul 2022 05:17:33 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id c11-20020adffb4b000000b0021a34023ca3sm10852773wrs.62.2022.07.13.05.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 05:17:33 -0700 (PDT)
Message-ID: <474e9b28-033d-f951-b79b-45db31c2129b@grimberg.me>
Date:   Wed, 13 Jul 2022 15:17:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com>
 <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
 <20220711183746.GA20562@test-zns>
 <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
 <20220712042332.GA14780@test-zns>
 <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
 <20220713053757.GA15022@test-zns>
 <f15bc945-8192-c10e-70d8-9946ae2969ce@grimberg.me>
 <20220713112850.GD30733@test-zns>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220713112850.GD30733@test-zns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>>> However io_kiocb is less
>>>> constrained, and could be used as a context to hold such a space.
>>>>
>>>> Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
>>>> can still hold a driver specific space paired with a helper to 
>>>> obtain it
>>>> (i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
>>>> space is pre-allocated it is only a small memory copy for a stable copy
>>>> that would allow a saner failover design.
>>>
>>> I am thinking along the same lines, but it's not about few bytes of
>>> space rather we need 80 (72 to be precise). Will think more, but
>>> these 72 bytes really stand tall in front of my optimism.
>>
>> You don't have to populate this space on every I/O, you can just
>> populate it when there is no usable path and when you failover a
>> request...
> 
> Getting the space and when/how to populate it - related but diferent
> topics in this context.
> 
> It is about the lifetime of SQE which is valid only for the first
> submission. If we don't make the command stable at that point, we don't
> have another chance. And that is exactly what happens for failover.
> Since we know IO is failed only when it fails, but by that time
> original passthrough-command is gone out of hand. I think if we somehow
> get the space (preallocated), it is ok to copy to command for every IO
> in mpath case.

Yea you're right. you need to populate it as soon as you queue the
uring command.
