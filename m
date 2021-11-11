Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E476844DB1F
	for <lists+io-uring@lfdr.de>; Thu, 11 Nov 2021 18:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhKKRbG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Nov 2021 12:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234414AbhKKRbC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Nov 2021 12:31:02 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D19C061766
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 09:28:12 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id s15so6532670ild.9
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 09:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t/Z/LVvpVvbFtHt1+l2RK4usBIBqBEP1/qR7ZyuDbRs=;
        b=VmfrYkJKnQfeFt3mVPyp6RukFKySwZ64KldcOi2YBfoKhgL4vY+QelMKrMiZnlyYAR
         z8Uf+GfgXkIm5dwWS6jpJJtUSaoPK6q0eB9EmShQZnghvNtZX4Fj2SEWbCQgOQngKRHc
         KLM4V4nfGUOJ+leFTjsv45qt71xmR1Ws9m70VZw3pFE0yGdYF/qz2opUmKz0eBLpeubD
         5vv33qlt2PNnYwInQT20CtXwfyQFybcYWHLSxSW5KRzMa4RvzMa3bMWCLyMbgo/a7o4c
         Mv4FSfeW3nEJUHtkDTjW+7qeqjUDBhM5My2L7rZPyaD/uC2073vkG02f6C73IhxJNOpK
         7Hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t/Z/LVvpVvbFtHt1+l2RK4usBIBqBEP1/qR7ZyuDbRs=;
        b=pxqwDdgvBzUGQip4MfvSt5ha9WZhiU++YWPbPsyUir3yOeCKOb6gIXabxt9tcqo3EW
         06DgVH8WcLeW6f1FcrieGIsqmYNFeT8c0Vkb3OumgGGRiMUQomT3DSbfUBh5eEkBZc4U
         v3OsXca4NbRZfULhBIMCN1GvoHKzdVfwoM5F1v3boGMBM7KA9/1vW3Vb64SLoKoD9scJ
         u+mv/GvZkCA5faKwQfg/3mE9is01c7gsW5lus8bc46xhwBrTgaNjM4YWuXyHYhxp8Ep0
         aercGpHT/zCcaOxjhwk6cP85d2VJr+OJiPMxPRJBWcbldcg6QH1QPeU9kqA/jQGfnWUb
         PuJw==
X-Gm-Message-State: AOAM531ho8ixHNBOwIhYznrLZplMSA5Tv25nS5KWuQbs4x0RXCqLD8ef
        UP61VEitFsezkQO/bxTu1BoDnZ/i1tXGpOx6
X-Google-Smtp-Source: ABdhPJwXCTt3zO6uTGu2go9MsWqGkZmj5KtRS534qFOZe91B/ndoqfDe1/oRAv3UgYGXtkeVccBt6Q==
X-Received: by 2002:a05:6e02:1848:: with SMTP id b8mr4976841ilv.299.1636651691710;
        Thu, 11 Nov 2021 09:28:11 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e17sm2366607iow.18.2021.11.11.09.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 09:28:11 -0800 (PST)
Subject: Re: uring regression - lost write request
From:   Jens Axboe <axboe@kernel.dk>
To:     Daniel Black <daniel@mariadb.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
 <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
 <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
 <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
 <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
Message-ID: <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
Date:   Thu, 11 Nov 2021 10:28:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/21 9:55 AM, Jens Axboe wrote:
> On 11/11/21 9:19 AM, Jens Axboe wrote:
>> On 11/11/21 8:29 AM, Jens Axboe wrote:
>>> On 11/11/21 7:58 AM, Jens Axboe wrote:
>>>> On 11/11/21 7:30 AM, Jens Axboe wrote:
>>>>> On 11/10/21 11:52 PM, Daniel Black wrote:
>>>>>>> Would it be possible to turn this into a full reproducer script?
>>>>>>> Something that someone that knows nothing about mysqld/mariadb can just
>>>>>>> run and have it reproduce. If I install the 10.6 packages from above,
>>>>>>> then it doesn't seem to use io_uring or be linked against liburing.
>>>>>>
>>>>>> Sorry Jens.
>>>>>>
>>>>>> Hope containers are ok.
>>>>>
>>>>> Don't think I have a way to run that, don't even know what podman is
>>>>> and nor does my distro. I'll google a bit and see if I can get this
>>>>> running.
>>>>>
>>>>> I'm fine building from source and running from there, as long as I
>>>>> know what to do. Would that make it any easier? It definitely would
>>>>> for me :-)
>>>>
>>>> The podman approach seemed to work, and I was able to run all three
>>>> steps. Didn't see any hangs. I'm going to try again dropping down
>>>> the innodb pool size (box only has 32G of RAM).
>>>>
>>>> The storage can do a lot more than 5k IOPS, I'm going to try ramping
>>>> that up.
>>>>
>>>> Does your reproducer box have multiple NUMA nodes, or is it a single
>>>> socket/nod box?
>>>
>>> Doesn't seem to reproduce for me on current -git. What file system are
>>> you using?
>>
>> I seem to be able to hit it with ext4, guessing it has more cases that
>> punt to buffered IO. As I initially suspected, I think this is a race
>> with buffered file write hashing. I have a debug patch that just turns
>> a regular non-numa box into multi nodes, may or may not be needed be
>> needed to hit this, but I definitely can now. Looks like this:
>>
>> Node7 DUMP                                                                      
>> index=0, nr_w=1, max=128, r=0, f=1, h=0                                         
>>   w=ffff8f5e8b8470c0, hashed=1/0, flags=2                                       
>>   w=ffff8f5e95a9b8c0, hashed=1/0, flags=2                                       
>> index=1, nr_w=0, max=127877, r=0, f=0, h=0                                      
>> free_list                                                                       
>>   worker=ffff8f5eaf2e0540                                                       
>> all_list                                                                        
>>   worker=ffff8f5eaf2e0540
>>
>> where we seed node7 in this case having two work items pending, but the
>> worker state is stalled on hash.
>>
>> The hash logic was rewritten as part of the io-wq worker threads being
>> changed for 5.11 iirc, which is why that was my initial suspicion here.
>>
>> I'll take a look at this and make a test patch. Looks like you are able
>> to test self-built kernels, is that correct?
> 
> Can you try with this patch? It's against -git, but it will apply to
> 5.15 as well.

I think that one covered one potential gap, but I just managed to
reproduce a stall even with it. So hang on testing that one, I'll send
you something more complete when I have confidence in it.

-- 
Jens Axboe

