Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328A13EC868
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbhHOJma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbhHOJm2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:42:28 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B505C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:59 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q10so19365734wro.2
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1A9/5MKCDsS8GvaDYG/EidjiDRUXGw01kLDgK+mpQ7c=;
        b=Tim3uEmDzo3XMI/ZiXqPFz+5ovBjumHIpv4u1fSrqlEdnVlJ3U1oSSotGjIuu8xovN
         UpPXClWh4Q5uzcFwglf25Qt3OFv/J3NtDWrsALbAYanGZGEYQvEhdXh4jfZBrpmbNF1Y
         xMvIqUhUywYO5Pq69ymjNki5LFZ+NMDAx0TNwb3CVrVIfPV3Yv5GP44uzVExeiMlE2C5
         KpJNkdNkS4F/qGPyh1168wOI7ZgWZ0uXWc4AXnuJUr59Cw8RtrtRGOjvQvLpuJUyygKI
         OLRG4rymzjW1lxwSC6+4d5Elye/G2fIEvVkXgviMoGKXi8bWBr9ur81X3ZyRCEtpXd6A
         XJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1A9/5MKCDsS8GvaDYG/EidjiDRUXGw01kLDgK+mpQ7c=;
        b=pevrfslFog4aiYQNJ0yJzZcmGKnoaX7D3RSt50nyeq/99oNpl4nbF4kO23rxyuuPgx
         buyrpPLSrSjsMv/YKRrJirVpkrUiEZJc6JPHMvoF0WXKn2+wf6jlRT7TwhhYk4ubmcOY
         uEZ2LPR81tj6aRN4kITcNH2J5f9jHv7FnS6FjHsxsudpUVqLimwMU0TMPrYpN4xaG8oy
         PBvsyB0/iHUTe5djsk1jNe75hS+HYruFNe4TgcCF53dsU8ZrFNtG3Wuf8p9dh8sE8/Uy
         D3FUKccsRV3rEje9QuiRl1moccu+PSHbzwiKV7gJ+E8MKvr361qoq0UU7I3k82H4oIaj
         d6Jw==
X-Gm-Message-State: AOAM531d0G+R6/sNIxkZWvn/cOB0vKW4Ep7EOYhbTtKuDFze0F7XWM73
        EUx8Mi5Nup0QP4+ZhqWtkNChG+oUhD0=
X-Google-Smtp-Source: ABdhPJzwrmPhb3vQsV708k6/TlHLmxSVQQyy6ApDCE7dyAV2meIYd5RDeA8Mk7xlBayxK0E/AXGB0w==
X-Received: by 2002:a5d:4ec4:: with SMTP id s4mr12677021wrv.245.1629020517501;
        Sun, 15 Aug 2021 02:41:57 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 7sm6921958wmk.39.2021.08.15.02.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 02:41:57 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
 <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
 <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
 <a583a8e2-68d0-9baf-c7c2-8a3a06848f4c@gmail.com>
 <fe8d2eea-a2a1-2c30-474a-edaae5cdcd09@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2cf31753-cf71-d7c6-c94c-3c8685be76ec@gmail.com>
Date:   Sun, 15 Aug 2021 10:41:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fe8d2eea-a2a1-2c30-474a-edaae5cdcd09@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 8:38 PM, Jens Axboe wrote:
> On 8/14/21 1:36 PM, Pavel Begunkov wrote:
>> On 8/14/21 8:31 PM, Pavel Begunkov wrote:
>>> On 8/14/21 8:13 PM, Jens Axboe wrote:
>>>> On 8/14/21 10:26 AM, Pavel Begunkov wrote:
>>>>> If a requests is forwarded into io-wq, there is a good chance it hasn't
>>>>> been refcounted yet and we can save one req_ref_get() by setting the
>>>>> refcount number to the right value directly.
>>>>
>>>> Not sure this really matters, but can't hurt either. But...
>>>
>>> The refcount patches made this one atomic worse, and I just prefer
>>> to not regress, even if slightly
>>>
>>>>> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>>>>>  	atomic_inc(&req->refs);
>>>>>  }
>>>>>  
>>>>> -static inline void io_req_refcount(struct io_kiocb *req)
>>>>> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>>>>>  {
>>>>>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>>>>>  		req->flags |= REQ_F_REFCOUNT;
>>>>> -		atomic_set(&req->refs, 1);
>>>>> +		atomic_set(&req->refs, nr);
>>>>>  	}
>>>>>  }
>>>>>  
>>>>> +static inline void io_req_refcount(struct io_kiocb *req)
>>>>> +{
>>>>> +	__io_req_refcount(req, 1);
>>>>> +}
>>>>> +
>>>>
>>>> I really think these should be io_req_set_refcount() or something like
>>>> that, making it clear that we're actively setting/manipulating the ref
>>>> count.
>>>
>>> Agree. A separate patch, maybe?
>>
>> I mean it just would be a bit easier for me, instead of rebasing
>> this series and not yet sent patches.
> 
> I think it should come before this series at least, or be folded into the
> first patch. So probably no way around the rebase, sorry...

Don't see the point, but anyway, just resent it

-- 
Pavel Begunkov
