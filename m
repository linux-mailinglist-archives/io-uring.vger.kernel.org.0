Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E1A3F79BC
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 18:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhHYQEW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 12:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241960AbhHYQES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 12:04:18 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E81EC0612AF
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 09:02:36 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so3904142wmh.1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 09:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8kx61jP4tjaTLN6VdLuRy0F0z68dQ7IMKGpmpu5DG7c=;
        b=KZ8fImdZH7mxoLEBWLPeqozE5uaZhObYYjtUtsJ9y02hnmbZkSV93p2cXflg9aSzvY
         6o1PXGURsUN48bbQwBEBNZuKsbLNvLVPY9gQpEgqWyP5/RdBC2dto7ZYZ1mY3PlGFDJY
         U8V88mvBqxTufMb4d8cW1JJHLcnylOkcChhCeQadOk87v8B8LIAs1hkS0fYvr1XE1fKR
         RKnS2Sb/hnXKbSmLcxDNemPPcdbglU25Pjqb/m9y4D+x1bBVfHYlWUZrtoMouqqwRmcK
         m2zLyc4F1ZCu5gbA32E/Bj9prPFd9BWqohuXHrCcCwuhE18gynq/+2mOCAMeYzqqduLk
         w8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8kx61jP4tjaTLN6VdLuRy0F0z68dQ7IMKGpmpu5DG7c=;
        b=BUM15eZC+210Td8ce7Ag6ezGIfLfFKPYwDC7g7pP5bNpWuClTn5MnVGnFNXy223COT
         G3yUcZNl7n3SBJ/6SNcGmc9ujeKk5lgbgYC1C4fOscl3LJx6dx7zbLsYGvcRyvUE23z1
         JEu1OIHx4T+268/h/RJ8yhNsinLO8lqa9zUORQSN8limunArrIYVZf46eqvXSA0ksDzX
         IepEWmzX8UT1i7xiC+aRLk3l6R6APIc+sLWFtTnL/6G8Lqsj2VzgJf/YG+2jvbwVD4sf
         WCq+OIejQbo+9rjhMnZw0jXWUBJX3Yg3FRpDTXN1NPQnKuaSPQePGe00gi1i6yTrS4CL
         L1pw==
X-Gm-Message-State: AOAM532rKaOFTAin7l3ZQPjLefsDzmRwbbws07DSOvcCYRtU2apsu8uQ
        9Ih1SGWnJE6nEIo++7zu72o=
X-Google-Smtp-Source: ABdhPJz7e/t4QlDbKgZwP1PLg4GdHUfPTw6qwbslu6/aFE/sFoRjDsOJdjUtMyA6d4B9zKujU+jMpg==
X-Received: by 2002:a7b:c8ca:: with SMTP id f10mr10057281wml.140.1629907354931;
        Wed, 25 Aug 2021 09:02:34 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id f7sm5741142wmh.20.2021.08.25.09.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:02:34 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210825114003.231641-1-haoxu@linux.alibaba.com>
 <03767556-ac49-b550-6e73-3b00b3b66753@gmail.com>
 <2157392c-5bdc-c5bd-cce9-c9c8ac1fe165@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: don't free request to slab
Message-ID: <78403925-6da0-7059-484e-cfdd5c2c500f@gmail.com>
Date:   Wed, 25 Aug 2021 17:02:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2157392c-5bdc-c5bd-cce9-c9c8ac1fe165@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 4:38 PM, Hao Xu wrote:
> 在 2021/8/25 下午9:28, Pavel Begunkov 写道:
>> On 8/25/21 12:40 PM, Hao Xu wrote:
>>> It's not neccessary to free the request back to slab when we fail to
>>> get sqe, just update state->free_reqs pointer.
>>
>> It's a bit hackish because depends on the request being drawn
>> from the array in a particular way. How about returning it
> It seems a req is always allocated from state->reqs, so it should be
> ok? I actually didn't understand 'hackish' here, do you mean
> io_submit_sqes() shouldn't move state->free_reqs which is req caches'
> internal implementation?

I mean it uses implicit knowledge of how io_alloc_req() works, which
may and actually will change. It's just always too easy to forget
about that little one-off thing while changing another chunk.

To give an example, if one decides to remake it and first serve
requests from state->free_list and only when it's empty look into
state->reqs, it's too easy to forget opening a pretty severe
vulnerability.

If there is not much profit from it comparing to the risks, I'd
personally prefer to go with a safer way.  


>> into state->free_list. That thing is as cold as it can get,
>> only buggy apps can hit it.
>>

-- 
Pavel Begunkov
