Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573D54EE66B
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 05:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244358AbiDADHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 23:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243721AbiDADHF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 23:07:05 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA22B193B73
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 20:05:15 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p8so1378561pfh.8
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 20:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=r7khBnonEiFThq13FqiG7LKVSQ+MeKxonEXk60vTiZk=;
        b=TAg1e9zBJTGmVQlIFL6G6CAqhYDbb5339K7GUDokxjlYMqdwqoz8hphzJUz6vFyzZp
         cBgh7/mOFVp2zT5x90Jr3DZ8JCaY90NURmqmn0Hzl1k9C934soglkbvMvJufqGHACvFs
         JYLLrnAunOVL6MNaKUdtNyh9xbWUVIELUeL62O3Si8bzhS05OWGwUiFQQAvOSI6QtNHx
         cFq/PJrXJzZTa0cwKj5Lx9JM8qfUAOG8uyPzjf/H9eeICIbDnWy8aBvV+OLCxX0cjt/t
         9qH4BGFylh1FGR1l6hX8FIAxJ6i7wfgWG9jalSIiOTKsA+Z5BV0bW4qOUtPSA7Y3m57t
         FJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=r7khBnonEiFThq13FqiG7LKVSQ+MeKxonEXk60vTiZk=;
        b=l7kztq9m+idTv0Nfm3bTLvPVw8SErrwN2OuZRm/fGn1mHP0aVIFnViKtwXR8tSHBTa
         51vIOKZ7+aC/7c8n2GEZt7DJQhx8vEuawY3KQ0hL1JwosNDOM0sIeXMxnrF0cfg41V08
         za4t4dof6PQKK6gXkHFLlNPMutIKRHzxV2c2sZ4PNYRXsptkuBQ4QrOc6U7UqQb791Ju
         86RNHiWqt7uKyz5RM0WMV2HTw9gJdYVNNDCy+kV+f/P6gQP009QzgFJ0E3cx4ykZMGOy
         BFRhebXLRvA/g5EqCrKcxjLiR5zV0fXbpvj+yUepAnlK9g9+Yw4+Yq/g14np03BIVpn6
         G+AA==
X-Gm-Message-State: AOAM5307jKKG/mVIBF8a/oR7SKMZkpaokQsBER6rqpmPC9zmwTJoT/mI
        HBO2uxV0UnVLKIV9CkEMIHkABw==
X-Google-Smtp-Source: ABdhPJwf62CCz6zDtBAJs+C2QiuuIuYi30RJGbEXPrLs61j0DQUYOxVD0TojYqnwKOjPNvTYR/PrGQ==
X-Received: by 2002:a05:6a00:ad0:b0:4e1:2d96:2ab0 with SMTP id c16-20020a056a000ad000b004e12d962ab0mr8542870pfl.3.1648782315250;
        Thu, 31 Mar 2022 20:05:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ds15-20020a17090b08cf00b001c6a4974b45sm11003304pjb.40.2022.03.31.20.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 20:05:14 -0700 (PDT)
Message-ID: <f082f9e9-5ebb-48df-cfca-01cd1770c886@kernel.dk>
Date:   Thu, 31 Mar 2022 21:05:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com>
 <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de>
 <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de>
 <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de>
 <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
 <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk>
 <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
 <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
In-Reply-To: <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/22 8:44 PM, Jens Axboe wrote:
> On 3/31/22 8:33 PM, Kanchan Joshi wrote:
>> On Fri, Apr 1, 2022 at 6:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 3/30/22 7:14 AM, Kanchan Joshi wrote:
>>>> On Wed, Mar 30, 2022 at 6:32 PM Christoph Hellwig <hch@lst.de> wrote:
>>>>>
>>>>> On Fri, Mar 25, 2022 at 07:09:21PM +0530, Kanchan Joshi wrote:
>>>>>> Ok. If you are open to take new opcode/struct route, that is all we
>>>>>> require to pair with big-sqe and have this sorted. How about this -
>>>>>
>>>>> I would much, much, much prefer to support a bigger CQE.  Having
>>>>> a pointer in there just creates a fair amount of overhead and
>>>>> really does not fit into the model nvme and io_uring use.
>>>>
>>>> Sure, will post the code with bigger-cqe first.
>>>
>>> I can add the support, should be pretty trivial. And do the liburing
>>> side as well, so we have a sane base.
>>
>>  I will post the big-cqe based work today. It works with fio.
>>  It does not deal with liburing (which seems tricky), but hopefully it
>> can help us move forward anyway .
> 
> Let's compare then, since I just did the support too :-)
> 
> Some limitations in what I pushed:
> 
> 1) Doesn't support the inline completion path. Undecided if this is
> super important or not, the priority here for me was to not pollute the
> general completion path.
> 
> 2) Doesn't support overflow. That can certainly be done, only
> complication here is that we need 2x64bit in the io_kiocb for that.
> Perhaps something can get reused for that, not impossible. But figured
> it wasn't important enough for a first run.
> 
> I also did the liburing support, but haven't pushed it yet. That's
> another case where some care has to be taken to avoid makig the general
> path slower.
> 
> Oh, it's here, usual branch:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-big-sqe
> 
> and based on top of the pending 5.18 bits and the current 5.19 bits.

Do post your version too, would be interesting to compare. I just wired
mine up to NOP, hasn't seen any testing beyond just verifying that we do
pass back the extra data.

Added inline completion as well. Kind of interesting in that performance
actually seems to be _better_ with CQE32 for my initial testing, just
using NOP. More testing surely needed, will run it on actual hardware
too as I have a good idea what performance should look like there.

I also think it's currently broken for request deferral and timeouts,
but those are just minor tweaks that need to be made to account for the
cq head being doubly incremented on bigger CQEs.

-- 
Jens Axboe

