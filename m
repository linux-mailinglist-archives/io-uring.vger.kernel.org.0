Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF156FD3CA
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 04:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjEJCR5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 22:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjEJCR4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 22:17:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F205BF
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 19:17:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ab0595fc69so10979985ad.0
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 19:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683685075; x=1686277075;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wMJx/u/pBYVd7Zt4eeqFR3I/fhY0U5ZXB++bJG0vXno=;
        b=SZEUJlGBuDB3sRwE0D/8GD4meNu7D2ZykHyEdRQA1nG96faLOaQgdSi1FM2VUR0ol5
         YPn5q3KPXEgKzUTYl273YA6Q1D/unrkk6BLetzJwChr9/rmC30chg7a+zcGj7Lry5fKR
         MYGt+7K9yLWgCeqqhDTRIG7MBhVtRHY3NdA0dWRvK23W4vsoADNG6KcoLDp/vaW0cW/t
         zFYd5hSRNZqG666tV13mzwZlMiK0f0lAAn8UgkwN26oN+mKNXsHpcrAm2rMnK460oA4i
         R66nv95do3v/+lvUQu2FZu3WcxBTdyE42eNvTy/uue2e6pO18KhV1WY2IlreC+Agj89d
         NnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683685075; x=1686277075;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wMJx/u/pBYVd7Zt4eeqFR3I/fhY0U5ZXB++bJG0vXno=;
        b=CZ1T27kVhG0OUQJ/u4kZkllEq3e0XH8/2G2bGEjoDScmKoVFQvfZrOeP0+4weZcLdd
         DSp4HZZUHojOMegwl7otSKAy1MG5ozTtrbOdpvwHHS/xhAHMQaLudqd//0enFUzv4L79
         9DRkFPvF0eIkuYkRa3YqXuNXRQbzDQKB+7dYEpVvkPA+ERT9FCJtoJQZFt57KG09USzv
         393nonAheRBz7u+4YYrEw1aI5V9LNfeSq4RoeT+pexyCyTJKQCj5HYnYQyc/DSyRTwHH
         91/WA650zXseKpjuYbr67w3RJKbZEQhpVMSaBUkZdN0drPkK7+jQXfrAAbayVWDhvShR
         LG2g==
X-Gm-Message-State: AC+VfDzs5+cwl6QPm8lyYvoN/asZk5OJQsCIVweSbS5T41WPmFvgFTWN
        0gx7T2mTU1mD1/+IVk+AUV3lqg==
X-Google-Smtp-Source: ACHHUZ63SBLSE29exYA5LPsG2pRkV8oXtGxZr/XXJIPvu7KlYtPUBOSp7qEDUVJiCI/bIb/nd/mjUg==
X-Received: by 2002:a17:902:cec7:b0:1ac:6153:50b3 with SMTP id d7-20020a170902cec700b001ac615350b3mr15056493plg.5.1683685074847;
        Tue, 09 May 2023 19:17:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bb5-20020a170902bc8500b001ab05aaae2fsm2361211plb.107.2023.05.09.19.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 19:17:54 -0700 (PDT)
Message-ID: <1155743b-2073-b778-1ec5-906300e0570a@kernel.dk>
Date:   Tue, 9 May 2023 20:17:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
 <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
 <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/23 8:00?PM, Yu Kuai wrote:
> Hi,
> 
> ? 2023/05/10 9:49, Yu Kuai ??:
>> Hi,
>>
>> ? 2023/05/10 9:29, Yu Kuai ??:
>>> Hi,
>>>
>>> ? 2023/05/10 8:49, Guangwu Zhang ??:
>>>> Hi,
>>>>
>>>> We found this kernel NULL pointer issue with latest
>>>> linux-block/for-next, please check it.
>>>>
>>>> Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>>>>
>>>>
>>>> [  112.483804] BUG: kernel NULL pointer dereference, address: 0000000000000048
>>
>> Base on this offset, 0x48 match bio->bi_blkg, so I guess this is because
>> bio is NULL, so the problem is that passthrough request insert into
>> elevator.
>>
> Sorry that attached patch has some problem, please try this one.

Let's please fix this in bfq, this isn't a core issue and it's not a
good idea to work around it there.

-- 
Jens Axboe

