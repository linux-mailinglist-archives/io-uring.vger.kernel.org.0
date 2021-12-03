Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E223467AC1
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 17:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbhLCQHa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 11:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbhLCQHa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 11:07:30 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC66DC061751
        for <io-uring@vger.kernel.org>; Fri,  3 Dec 2021 08:04:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so5234677wmj.5
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 08:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LIPjRGEw1tZHM9X6pc531MFU/keF7K2sjoUFL02KU1s=;
        b=liaPGJA5BXa4MrAFuS3xQgJ3wx+gOJAfQ8WyoIDlResGwoABCsiS5ZKzCIQl3u4CXz
         o1OOOWdubnCAjiI1xO+IyNaZQImqhJntOrJU+CRskkNwNOgKbHseL8nls3sQFdN8/ozn
         pDOIQXbLO8IptLLaJWUdt11vF2PUj4POP0ZvC86Lb/4WcSafnavppemtemYYafcqvF1t
         7ANgst0PnU7U+WecFiE/F1I/giQjy9IiBzgewx6NhjbFyq6BuTMEzkW9Y7ITOyeYooyh
         P650zKHEQWnr7QI+S9fqmZLFeB6MsSRBxB4+VuSUUtQT9V7PWwUuQ38T3flvO48pkOUC
         HHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LIPjRGEw1tZHM9X6pc531MFU/keF7K2sjoUFL02KU1s=;
        b=lxr8K1kuUW1NgdhJG8G/WcTvdDlu3qJe9zjnq2Yx34KTpLkOXmHjqT1edHIMwe2KNf
         w4qWB0rJB7o95LU6sfe7GDLfrclNcYFkUTlbSAXlJVHfLv2VTWtlbr2FxYBJpL0ZXfp9
         Uwag4033Q5vvJORm1+Waiq4IK6tA/VVJY2j7yxvMnfo4HRjk62/ZeG0YnlzdYqpTFKYB
         krBJ0mGPmp2kUa1axhz4OUGaI7VhoKMB+7OFzszAHSSiUquLzMqXnmiqGcjyFfl5ifqT
         yKQsDemU3jhsPiQW1LLZKceD+LhydDMLdCprw+AFv5KkVEXbUsdavN+l5/DJWpnOwKyl
         GneA==
X-Gm-Message-State: AOAM532RHJ3JSKTijXW7JYfaWspeKgvjb1juHANaJVtDe8wiv+ivTUK0
        WS+OeHzPa/NayJuyAjUCkJ4=
X-Google-Smtp-Source: ABdhPJzek3pEglpCe9cA2jJnangMciW1QWz/3aR5T3j0kiA9cxiHxBjY0hK5z2AhipMRfPkqmqXeZA==
X-Received: by 2002:a1c:7f56:: with SMTP id a83mr16082271wmd.32.1638547444423;
        Fri, 03 Dec 2021 08:04:04 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-141.dab.02.net. [82.132.231.141])
        by smtp.gmail.com with ESMTPSA id r11sm3012037wrw.5.2021.12.03.08.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 08:04:03 -0800 (PST)
Message-ID: <8cc826ea-c721-a178-eea1-2ee2a03722f3@gmail.com>
Date:   Fri, 3 Dec 2021 16:03:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: Question about sendfile
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <6a7ceb04-3503-7300-8089-86c106a95e96@linux.alibaba.com>
 <4831bcfd-ce4a-c386-c5b2-a1417a23c500@gmail.com>
 <1414c8f9-e454-fb5a-7e44-cead5bbd61ea@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1414c8f9-e454-fb5a-7e44-cead5bbd61ea@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 08:50, Hao Xu wrote:
> 在 2021/7/7 下午10:16, Pavel Begunkov 写道:
>> On 7/3/21 11:47 AM, Hao Xu wrote:
>>> Hi Pavel,
>>> I found this mail about sendfile in the maillist, may I ask why it's not
>>> good to have one pipe each for a io-wq thread.
>>> https://lore.kernel.org/io-uring/94dbbb15-4751-d03c-01fd-d25a0fe98e25@gmail.com/
>>
>> IIRC, it's one page allocated for each such task, which is bearable but
>> don't like yet another chunk of uncontrollable implicit state. If there
>> not a bunch of active workers, IFAIK there is no way to force them to
>> drop their pipes.
>>
>> I also don't remember the restrictions on the sendfile and what's with
>> the eternal question of "what to do if the write part of sendfile has
>> failed".
> Hi Pavel,
> Could you explain this question a little bit.., is there any special
> concern? What I thought is sendfile does what it does,when it fails,
> it will return -1 and errno is set appropriately.

I don't have much concern about this one, though interesting how
it was solved and whether you need to know the issuing task to
handle errors.

I didn't like more having uncontrollable memory, i.e. a pipe per
worker that used sendfile (IIRC it keeps 1 page), and no way to
reuse the memory or release it. In other words, a sendfile request
chooses to which worker it goes randomly. E.g. First sendfile may go
to worker 1 leaving 1 page allocated. The second sendfile goes to
worker 2, so after we have 2 pages allocated, an so on. At some
point you have N pages, where any particular one may likely be
rarely used.

Please correct me if I forgot how it works and wrong here.

>> Though, workers are now much more alike to user threads, so there
>> should be less of concern. And even though my gut feeling don't like
>> them, it may actually be useful. Do you have a good use case where
>> explicit pipes don't work well?

-- 
Pavel Begunkov
