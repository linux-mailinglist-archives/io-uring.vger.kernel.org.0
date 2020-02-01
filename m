Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D096014F5E5
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 03:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBACKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 21:10:46 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38542 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBACKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 21:10:46 -0500
Received: by mail-pl1-f193.google.com with SMTP id t6so3528456plj.5
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 18:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=k93QIXrlhVKvP7ezICOk3caRM5BxpPtO926JL6CGXc4=;
        b=WzJTUP5Yd/yOi2pp6mKUiEg5Y0sTCDhOnWOow3LVm9HbMEo9yewdTOGRujYdJMrLHC
         di0stniZHIsZSf1ca98dPzIpwRLgU03JMXkzIp8zlJwynW6ovU+Na1fb8lQH3loT/Uis
         6mfdncX2AadVERJvdPfCHeILLUGXLDmq89+uQMQ7niNSP0mkLjOjfd4OrJUYM7kdwso/
         sBpoyFEA7ZXyvd2q5awC8NsO9PQIPEA7rAAcSfvkLeso2K51Hh7m8okJ1WN7z6RnBJJK
         Dc9wD6CjrBAnQ6fS/3e7+Gn4bkL5n9HU9Ba+lZJ+aW2mXqe8CkBiAKewUtey/GD66djp
         /EtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k93QIXrlhVKvP7ezICOk3caRM5BxpPtO926JL6CGXc4=;
        b=FmNrbGciqV5FiZT2RM+Iz3FVz/y7w5S8jjlImHLwM4Cu7bjB1RFudFftkfg3YJLV3M
         pTFyd16+EQ/jRp2P5WQCFP09mffeFgqTen7PkvdRsd5HWLr7XgCsd/Md6Rx8V3aG+rI4
         7x1iZ+jL6OOgwYuWlU6Ca1Ak1EqI25x+A55h8F7S/cYpkHdFFPsZ8PSB53/gB4Qih2Sx
         7ve6HMIrNXY/7+CqkGWdhEXCBF58L4Bualu5s9yF5frZU/lno2dJhkbshWYZFxcA3YXn
         dXEiGqHBkW9vUQig/pN4EjuLLnDs8FtAIZTwAJ9TS6XMsyN/3ldjUWt1w+5x7VtCjmO9
         3JWw==
X-Gm-Message-State: APjAAAVj3ciloA5Kc82KR3Oty3Gq+GrP6NPOog55mDah1wWgu/R/xPcj
        8MFlmWGrxBAZw11aKCnfSTiwOg==
X-Google-Smtp-Source: APXvYqzzyMS5+MJH6hdO4YgucV12idd1nE0F8fU6Mb37cO9QTx2XLAH5YCfsk+SO5RsMUbbNJvrDqw==
X-Received: by 2002:a17:90a:a385:: with SMTP id x5mr5223992pjp.102.1580523044195;
        Fri, 31 Jan 2020 18:10:44 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id p17sm11327441pfn.31.2020.01.31.18.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 18:10:43 -0800 (PST)
Subject: Re: [PATCH v3 0/6] add persistent submission state
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
 <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
 <18b43ead-0056-f975-a6ed-35fb645461e9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1124e9e0-cf3b-767e-40a5-57297e5ec17b@kernel.dk>
Date:   Fri, 31 Jan 2020 19:10:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <18b43ead-0056-f975-a6ed-35fb645461e9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 5:31 PM, Pavel Begunkov wrote:
> On 01/02/2020 01:32, Pavel Begunkov wrote:
>> On 01/02/2020 01:22, Jens Axboe wrote:
>>> On 1/31/20 3:15 PM, Pavel Begunkov wrote:
>>>> Apart from unrelated first patch, this persues two goals:
>>>>
>>>> 1. start preparing io_uring to move resources handling into
>>>> opcode specific functions
>>>>
>>>> 2. make the first step towards long-standing optimisation ideas
>>>>
>>>> Basically, it makes struct io_submit_state embedded into ctx, so
>>>> easily accessible and persistent, and then plays a bit around that.
>>>
>>> Do you have any perf/latency numbers for this? Just curious if we
>>> see any improvements on that front, cross submit persistence of
>>> alloc caches should be a nice sync win, for example, or even
>>> for peak iops by not having to replenish the pool for each batch.
>>>
>>> I can try and run some here too.
>>>
>>
>> I tested the first version, but my drive is too slow, so it was only nops and
>> hence no offloading. Honestly, there waren't statistically significant results.
>> I'll rerun anyway.
>>
>> I have a plan to reuse it for a tricky optimisation, but thinking twice, I can
>> just stash it until everything is done. That's not the first thing in TODO and
>> will take a while.
>>
> 
> I've got numbers, but there is nothing really interesting. Throughput is
> insignificantly better with the patches, but I'd need much more experiments
> across reboots to confirm that.
> 
> Let's postpone the patchset for later

Sounds fine to me, no need to do it unless it's a nice cleanup, and/or
provides some nice improvements.

It would be great to see the splice stuff revamped, though :-)

-- 
Jens Axboe

