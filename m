Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A52A5EDC1E
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 14:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiI1MA6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 08:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiI1MA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 08:00:56 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8DF6B14C
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 05:00:55 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id iv17so8364284wmb.4
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 05:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=V5SvN6MgO+MSDOscXSvoP6p8YAbWnWYEDCv3rox03yM=;
        b=S25TT1s6RzM27DhmDN31aY9oebCnDbSxN2JaJ9vp/+yiH2nw2NM7DE9byjZXrI5DLB
         p4a9vfIoAoxwldQMjGA/Sy0TLugt4d+DF0Tpzs61fTyE4Eatf1KVcrvTW2lDYBDz1wpX
         3qN7qjkhTy/BIXXIUTupc4G9+JoY1iFUrF6JaBl0t6dgpeescFj1cqbFl10cdnzYfH+0
         9o9Yin35gmC7XQySqw5xUDMJqJbIcZzeDVCAUQyTRwKuyF5AO2RNhDMwt8sVtSKiS/qb
         +arJC8hDMD3UGPzk11LHMYeaFY3aqQqRkgsZd98mECaa4aU+zHPl0I7bvHHM24pa9EBr
         UBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=V5SvN6MgO+MSDOscXSvoP6p8YAbWnWYEDCv3rox03yM=;
        b=3TM3/IT+P4KA1wtvPfv9hh//69TMEBxrhLlC0i2AkTRvh4V9e65/xRxn7ek5LCz3km
         ES88NjTn8Z+WJjdoh8+xy/3Jb94kcM1kUFovbfY2pD/P/cBiVQlFmWjFcUoAOCC47QrH
         qnPaJDQkFCLNrROin0MO8YAqsQuSvlqF38KRAbWBzV/ZWcwoI2TJrKCDhtIReKDAoqHA
         5iBkuPPblaBPXTnWLBZn3w2NQI4tPxE3Pmsl1EQFyMcsVQeVu07WjnZOF4RcRZ+IkYEp
         3B7vgrFGwQApgJ0BSPGF6ZGTFpA1H1alffLGo1SI9oTHbWxaCzp5FjqMniULZsn3Va+M
         XW2A==
X-Gm-Message-State: ACrzQf1knrxdk0gTcQhmfrOQ9qU9Rvv8xEJtFTTH3IAfffy7rNwj00fk
        IYfY7gurkULv8qNGsdhsx7Q=
X-Google-Smtp-Source: AMsMyM7yt6WDfa5hLATXOOt4ZuxwpMjiGJ7YoMU3LkZEKi12jhXeVwh6iQZGMvUbJMktW+oDXstlQA==
X-Received: by 2002:a05:600c:4793:b0:3b4:7276:1c5e with SMTP id k19-20020a05600c479300b003b472761c5emr6670237wmo.118.1664366453700;
        Wed, 28 Sep 2022 05:00:53 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm1778761wmq.37.2022.09.28.05.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 05:00:53 -0700 (PDT)
Message-ID: <8059c7e2-c3e7-c3c1-6994-2fdb75d5d5dd@gmail.com>
Date:   Wed, 28 Sep 2022 12:59:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Chaining accept+read
Content-Language: en-US
To:     Ben Noordhuis <info@bnoordhuis.nl>
Cc:     io-uring@vger.kernel.org
References: <CAHQurc-0iK9zawpc_k_-wSUVMp_+v14K+t-EJEDXL0pYkzD80A@mail.gmail.com>
 <ff41b5f7-93a5-26ee-bae5-80fc828e1a45@gmail.com>
 <CAHQurc9e=BU3gXbc=brb1b+vLb7nmeyeVaGwqkgRoqnSyHT2AQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHQurc9e=BU3gXbc=brb1b+vLb7nmeyeVaGwqkgRoqnSyHT2AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 11:55, Ben Noordhuis wrote:
> On Wed, Sep 28, 2022 at 12:02 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 9/28/22 10:50, Ben Noordhuis wrote:
>>> I'm trying to chain accept+read but it's not working.
>>>
>>> My code looks like this:
>>>
>>>       *sqe1 = (struct io_uring_sqe){
>>>         .opcode     = IORING_OP_ACCEPT,
>>>         .flags      = IOSQE_IO_LINK,
>>>         .fd         = listenfd,
>>>         .file_index = 42, // or 42+1
>>>       };
>>>       *sqe2 = (struct io_uring_sqe){
>>>         .opcode     = IORING_OP_READ,
>>>         .flags      = IOSQE_FIXED_FILE,
>>>         .addr       = (u64) buf,
>>>         .len        = len,
>>>         .fd         = 42,
>>>       };
>>>       submit();
>>>
>>> Both ops fail immediately; accept with -ECANCELED, read with -EBADF,
>>> presumably because fixed fd 42 doesn't exist at the time of submission.
>>>
>>> Would it be possible to support this pattern in io_uring or are there
>>> reasons for why things are the way they are?
>>
>> It should already be supported. And errors look a bit odd, I'd rather
>> expect -EBADF or some other for accept and -ECANCELED for the read.
>> Do you have a test program / reporoducer? Hopefully in C.
> 
> Of course, please see below. Error handling elided for brevity. Hope
> I'm not doing anything stupid.

Perfect thanks

> For me it immediately prints this:
> 
> 0 res=-125
> 1 res=-9

The reason is that in older kernels we're resolving the read's
file not after accept but when assembling the link, which was
specifically fixed a bit later. Jens, are there any plans to
backport it?

-- 
Pavel Begunkov
