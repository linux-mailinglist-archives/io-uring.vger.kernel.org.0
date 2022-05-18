Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E0F52BD7B
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 16:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiERM4Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 08:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbiERM4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 08:56:22 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327DB2CE01
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:56:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n10so1925689pjh.5
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 05:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to;
        bh=gdn+EYijGDSknTpwH9gM61IzzhTMdlqMO7KrX3pL348=;
        b=elboMiGEcdrPrKDibX47lPX8NI8DRgRi70JhMEo77HP0DT3gH+azgRCGZKijwJ46cJ
         OnGGp47FToTbo9wkEh4GqZ3VQ9z9Ki2+WfEIYiEkG0Q/4j0wJzgr6WG7PFEmdnXiAMV2
         724MqIxvwoZ7ywvdlU4Ae+MPdViRjg6HQhGIQ2ppFa+cHHluxCWWf+7qyY8OybRvDJpT
         OBC3Lvm/W6cfFowHhV3TheEtg3i3PNFYKg9eAWE+g8gmrzrgQRqMYJm/1uOiMIOUgi9k
         IErpkdO/5W96D6hCeM27m5n+oxDDe0Nh9W21EIP1Nh7110kZJkPpNpu6gZojwmsTtSpc
         tSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to;
        bh=gdn+EYijGDSknTpwH9gM61IzzhTMdlqMO7KrX3pL348=;
        b=igtTbD2fRus2GldAUBWxJDsBuaDR9qUmgHjiLliTxNZGa/cYTr977W3Kw0LzMbooc5
         4jkYLIqT3elBgEbyMUVlwx9eshdOWT0RZN4ppPMbNAnkBYFHGQC7mYfWShwY4DhyW1hT
         q6jyEkVHAe8LCySsWmdIkZPJmeBpEE9tLGJ7ZZ0hb8d6dlmgxOMqOxGepwMDQNv605Km
         is/I1mXMKs3DPz6EPZPBR1DbgSslEV27Xnb1saAAdGZOlrO0ZmaMXz7meHph3ut94dkE
         Eb4kNCnjgwfgeWQcJDYYqhbKN4TXHUig1gpg6t1aFFX8Kg8WLAIDfi57IWxGsHd1KJYD
         jFag==
X-Gm-Message-State: AOAM532n4iZZOgSmWjo5eZY1FGQNnryOEBu+dRjc6HKmtj4p5Iz6d5VG
        CAm1zUJC9TPIMFV7up4Pnq1aDw==
X-Google-Smtp-Source: ABdhPJwylPK+dLvrnB1KYjl/XWL1ktkIAT9wvNrejW++O9CK+3a5n0bfpVnj5GDOo8QZqolqLXdTYQ==
X-Received: by 2002:a17:902:7483:b0:161:80be:cd37 with SMTP id h3-20020a170902748300b0016180becd37mr13531721pll.138.1652878580381;
        Wed, 18 May 2022 05:56:20 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id je19-20020a170903265300b0015e8d4eb295sm1557875plb.223.2022.05.18.05.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 05:56:19 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------0r0puKxDv8vMP2cjpXkFteNT"
Message-ID: <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
Date:   Wed, 18 May 2022 06:56:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YoOJ/T4QRKC+fAZE@google.com>
 <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
 <YoOT7Cyobsed5IE3@google.com>
 <d503d5ff-4bc5-2bd0-00d3-cd7b0a0724cb@kernel.dk>
 <YoOW2+ov8KF1YcYF@google.com>
 <3d271554-9ddc-07ad-3ff8-30aba31f8bf2@kernel.dk>
 <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
 <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
In-Reply-To: <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------0r0puKxDv8vMP2cjpXkFteNT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/18/22 6:54 AM, Jens Axboe wrote:
> On 5/18/22 6:52 AM, Jens Axboe wrote:
>> On 5/18/22 6:50 AM, Lee Jones wrote:
>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>
>>>> On 5/17/22 7:00 AM, Lee Jones wrote:
>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>
>>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>
>>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>
>>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
>>>>>>>>>>>
>>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
>>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>>>>>>>>>> in Stable v5.10.y.
>>>>>>>>>>>
>>>>>>>>>>> The full sysbot report can be seen below [0].
>>>>>>>>>>>
>>>>>>>>>>> The C-reproducer has been placed below that [1].
>>>>>>>>>>>
>>>>>>>>>>> I had great success running this reproducer in an infinite loop.
>>>>>>>>>>>
>>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
>>>>>>>>>>>
>>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>>>>>>>>>
>>>>>>>>>>>        io-wq: have manager wait for all workers to exit
>>>>>>>>>>>
>>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
>>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
>>>>>>>>>>>        and that uses an int, there is no risk of overflow.
>>>>>>>>>>>
>>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>
>>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>>>>>>>>>
>>>>>>>>>> Does this fix it:
>>>>>>>>>>
>>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>>>>>>>>>
>>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
>>>>>>>>>>
>>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
>>>>>>>>>> rectify that.
>>>>>>>>>
>>>>>>>>> Thanks for your quick response Jens.
>>>>>>>>>
>>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
>>>>>>>>
>>>>>>>> This is probably why it never made it into 5.10-stable :-/
>>>>>>>
>>>>>>> Right.  It doesn't apply at all unfortunately.
>>>>>>>
>>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
>>>>>>>>
>>>>>>>> Let me know if you into issues with that and I can help out.
>>>>>>>
>>>>>>> I think the dependency list is too big.
>>>>>>>
>>>>>>> Too much has changed that was never back-ported.
>>>>>>>
>>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
>>>>>>> bad, I did start to back-port them all but some of the big ones have
>>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
>>>>>>> from v5.10 to the fixing patch mentioned above).
>>>>>>
>>>>>> The problem is that 5.12 went to the new worker setup, and this patch
>>>>>> landed after that even though it also applies to the pre-native workers.
>>>>>> Hence the dependency chain isn't really as long as it seems, probably
>>>>>> just a few patches backporting the change references and completions.
>>>>>>
>>>>>> I'll take a look this afternoon.
>>>>>
>>>>> Thanks Jens.  I really appreciate it.
>>>>
>>>> Can you see if this helps? Untested...
>>>
>>> What base does this apply against please?
>>>
>>> I tried Mainline and v5.10.116 and both failed.
>>
>> It's against 5.10.116, so that's puzzling. Let me double check I sent
>> the right one...
> 
> Looks like I sent the one from the wrong directory, sorry about that.
> This one should be better:

Nope, both are the right one. Maybe your mailer is mangling the patch?
I'll attach it gzip'ed here in case that helps.

-- 
Jens Axboe

--------------0r0puKxDv8vMP2cjpXkFteNT
Content-Type: application/gzip; name="patch.gz"
Content-Disposition: attachment; filename="patch.gz"
Content-Transfer-Encoding: base64

H4sICELshGIAA3BhdGNoALVV227bRhB9lr5iYiAFJZLW/VbDQZq0DwYCG3Vj9KEoFhS5tBaS
uSK5jFIU/vfM7C4p0qSbh6B6EMm9zJ45M+dsJOIYfP9RKAhGcT4S0j+llyFsax99kUT8K8yi
RRyultvNNBpfXs4WQTxfb7ZhEC9hMh4v5/O+7/uNKH3XdZuR3r8HfzJdeEtw6bEBHMhVVoQK
hGSnFP7tQy/jcSiLRDEF+Jpf4ZBdE8qn44ErIROIZMJxpu/2AiWfRIiLTzLb84yZPW7HHrvA
bHXPYXcHkSuWyIhDeCx2R/1KwRtYipzb2JTFdDH21uBOFzN86CwCJUL4IkWkUzFH8a9CObUE
9SgMzXNA8YMTy48iYUVykOGeiSx1fjql3H9HnwMDYh9nHM8OC8ds9ADfcc7viRicCmLEQxYk
EVM8VzbIKfXfEebBABf3LBW8NklcDIgtimSZfCVOjV4M53aGqzFM2J8JvmVGJAeRcNhKeTC1
xoyKhKUFL3idopQjPykfaJaXG2oSd7lZe5NZjWYdJcx4oDireG1EoSAetON6CAQHqKOJf7OT
wHO4BvzX3UYFMeVIBFFgF1UlqZpOJCFl3yTH9Fa5SQX5HkPv1Q7hRsyCloluMscyUda1ehKh
tMDDSPi7aKzz30ajt9GFZ9KorSZwupI3f7Df7u+dOobBAMWFVfuPQnfUuFHkVn17pjXtOWYk
46rIEoiDQ67JfNaFXE1W3grc1XSO2v8f6khZGZu6voabO/bn7+yXjx8/s4fbD3cPt7/SklbN
UNDIzTGTIc9znuvK+mfFV+tsUbGkwZ6z4sjslia9V9otdO4Iluvup8zX06k3wdTXU+zhulVo
/JQQewqS4BHz1uYxjAIVaLwUVlNCQnGMF8hC/fw93ZeSx3r7LwtoK+dXdRrTB+q0NxoCRsWu
ubsHkUPO8UZIIjhxeMTXHc+QcvzYBV+4bdMclATiBIYji4kgsC1qxpTgw81npiN6oE+nzHkJ
DD2MaUmQrBwDKpbomUG4M+LQLU3DPcNTNWv7RHdkyvO/aOHfnmXT9igB8+D24dMnm295nHFa
c+Az9ngLh9sJw/1xFG4XCLdpvjT7ihZPgVD69POV1qXKMuB3++Olh59vg3Mrj62L64t7MjM3
92Q+7bi6hyZxo2anSHLxmPAIJV6gLqOmhhk1edXqpF802lZepc1QQl3zL/IuBY6t22LQg3Hp
yzhhBdeyZaehRzJWDy4aYxeVxb4pPfYcT3c29No+UVtyZalcbbzJhLhcbxqOqD2AMcsSViyT
/7QMsXS8emDtxjabXMnji1O1tbUV94rgflxvXXLTFvpKD1e1hk5M/W8ylczZqQoAAA==

--------------0r0puKxDv8vMP2cjpXkFteNT--
