Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EA6346F4B
	for <lists+io-uring@lfdr.de>; Wed, 24 Mar 2021 03:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhCXCOk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 22:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbhCXCOX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 22:14:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC91DC061763
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 19:14:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x126so16233769pfc.13
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 19:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=L5VATD+SgSvP0uDDMv0XEmMh9UsDKLQL6ZxPV2i7Yxw=;
        b=EbIbrB3jhU2ezolVNh038d93wXGIPGQlWRfFzJtv3R7zlPJdVHGDPnpgAjpK1CUFTV
         GN0BMr+Ls8uCBrL168IF4TOtYziKqCs/Rl0v2ADkD4hu2vEEQbV4XQV1B3vbfy4UwiuS
         SIyrembSTHx8vy+bHVbUDjAyZy5QYUuU3gVtAw4uPnWpChDK4S/moJj/WIRmHbaG5xWJ
         /J9rByvniMcAulkWI4zEMT0S7cT+k80232Dzy3SSjrkWy+8/dvMRyZ5BX8kVk/jCp/2n
         RiSpfhJD2UTtf+GZVzABgr/Lw4p/+Unx1JRsi1cn6D7U9m0WgGwKjDBW6OFLmFZA39kb
         iXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L5VATD+SgSvP0uDDMv0XEmMh9UsDKLQL6ZxPV2i7Yxw=;
        b=bSZijcoEq/GCC3avYuaZuq+K/kfDY2wGxZsumL59ZNpeI8ZgJwL6YSbyuifRNRQmJ9
         10jx47NL1Lds9rK2fXpcCIvwj234+euJ5DdDbEgnsnzki0zDgIPupFi5ezs3puGhqKdc
         Gqb4yQzWZfJOWREf0mScin+mOK3nXe8V4tVTISIi15049yrIjctwDC2y6DEPKFa5hzUE
         lWRLjSyUGvazk5UmxWAtQeErSzM+kjL/E5fw1beKxW1m30dXdBiTTEAp2LFiKfmQztg2
         ieYa9a0TvLN+ji6RVgYzZZk9sEKfK6fl6ynU/SexMYqqFAneDvjQ8Eqyx5qGvEEXvqNO
         //xA==
X-Gm-Message-State: AOAM531rAzhPt+l+bpvIE2idZjNyo38+KyxipJF1/795mEXhOOhPdWoK
        3cqg4uDsTxEtUf7xrWZBbtFsS6KflqY=
X-Google-Smtp-Source: ABdhPJzQ3MpLwZgTV9MzaxYNulsP4JQQX6g+Wo5jJcSRpREb2UzwbmT2r1ThtR0FNHZ4y0EsbIQ5qg==
X-Received: by 2002:a63:de53:: with SMTP id y19mr1019050pgi.191.1616552062571;
        Tue, 23 Mar 2021 19:14:22 -0700 (PDT)
Received: from B-D1K7ML85-0059.local ([47.89.83.92])
        by smtp.gmail.com with ESMTPSA id d2sm404214pjx.42.2021.03.23.19.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 19:14:22 -0700 (PDT)
Subject: Re: [ANNOUNCEMENT] io_uring SQPOLL sharing changes
To:     Jens Axboe <axboe@kernel.dk>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Hao Xu <haoxu@linux.alibaba.com>
References: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
 <30563957-709a-73a2-7d54-58419089d61a@linux.alibaba.com>
 <1afd5237-4363-9178-917e-3132ba1b89c3@kernel.dk>
 <293e88d8-7fa5-edf4-226c-1e42dec9af67@linux.alibaba.com>
 <7a6899a6-ece8-f2f8-3fbc-3adfcbf942b2@kernel.dk>
From:   Joseph Qi <jiangqi903@gmail.com>
Message-ID: <67d886e8-12ee-0b4c-25a7-a8cf687c2e49@gmail.com>
Date:   Wed, 24 Mar 2021 10:14:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7a6899a6-ece8-f2f8-3fbc-3adfcbf942b2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/24/21 12:22 AM, Jens Axboe wrote:
> On 3/22/21 10:09 PM, Joseph Qi wrote:
>>
>>
>> On 3/22/21 10:49 PM, Jens Axboe wrote:
>>> On 3/21/21 11:54 PM, Xiaoguang Wang wrote:
>>>> hi Pavel,
>>>>
>>>>> Hey,
>>>>>
>>>>> You may have already noticed, but there will be a change how SQPOLL
>>>>> is shared in 5.12. In particular, SQPOLL may be shared only by processes
>>>>> belonging to the same thread group. If this condition is not fulfilled,
>>>>> then it silently creates a new SQPOLL task.
>>>>
>>>> Thanks for your kindly reminder, currently we only share sqpoll thread
>>>> in threads belonging to one same process.
>>>
>>> That's good to know, imho it is also the only thing that _really_ makes
>>> sense to do.
>>>
>>> Since we're on the topic, are you actively using the percpu thread setup
>>> that you sent out patches for earlier? That could still work within
>>> the new scheme of having io threads, but I'd be curious to know first
>>> if you guys are actually using it.
>>>
>>
>> Yes, we've already used percpu sqthread feature in our production
>> environment, in which 16 application threads share the same sqthread,
>> and it gains ~20% rt improvement compared with libaio.
> 
> Great! Any chance I can get you to re-post the patches against the
> current tree?
> 
Yes, we'll do it later.

Thanks,
Joseph
