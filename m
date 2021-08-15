Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989093EC9CD
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhHOPCM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhHOPCL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:02:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A3FC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:01:40 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a20so18027417plm.0
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zQPTqysy8m+ax7yLDwBYwEwuhsj3hNd7WqeASOalnPw=;
        b=yxYF8u1xMzB3RVGbBa+Qt5tSlN9J/jCHfuS5vBswRO+q0Il+Dq/IcN+aGwx1RDcCT8
         GNgHCMroAvBZXlJiN7dmf3eIS4IuK4FQArgd9vCNAS6YA2wbUlQAvE+yhGFl5dn7uy8D
         Bq6QWn6b9Up+4TBVAMV+k2wrNY9K0al8huuE2Po/n9hnfQp+ho1vz9cI7MF8lYdxgzwc
         HJWP3Ds8a1+dXmRey/ZnN8YPAV2koBl64Eo35laXw626zoTX6Qg+v1agn4ceGD0JNVRI
         dxGNcdPd1Jze0KGUfn9ZFXsuUElkM6pm9QAUwzDpqdic1YH3XcVy8fwP/0gkKfel+3Et
         KMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zQPTqysy8m+ax7yLDwBYwEwuhsj3hNd7WqeASOalnPw=;
        b=MAXLmWf1aAN6b2p+vL7gw2oy5lf8KpEF8ySA/8vzzPSQF6nFM5lpZLsuEGJ8UVXqaS
         ZXl80bkSvDqFA3BxCelL1Rn84KFGs1R+9BQfoo7dAJDuZsaoPIEeTYq810s8Yx03aWLj
         sIWKYppqe+yvVFGblA6fuz6KnlroXoWJbX2RjmcRtKsvxHdnqY4spdhJuNaSnXC6wGRU
         M6NXXh8wtG2VcxMvKlCUt46S3ociUdUjzjpi0gtTW9/rBTfT7Kil5ESjlxHQvh1hCfQs
         +2348CI49ESVOMcbpiat1YkhGwdXXPaIdBfhccFeh4rAsg8nuBixReW6zzHw9Z9z8QXW
         zKiw==
X-Gm-Message-State: AOAM530seU/ox818tDP8cMKKBIY0gmBfGP1XydHXG2D3Hf0OzjmOP8Yw
        UDbHM1riz2OiwGZHSgKwLN2hTLIE9hVExF6t
X-Google-Smtp-Source: ABdhPJy4x9Yl6rROl/olfSQ7+bGS9sJoFRIZY7ANCgwyPnAwunML8884hLmLDYFQUvDXNLVT+iSkFg==
X-Received: by 2002:a17:90a:a087:: with SMTP id r7mr12429149pjp.84.1629039699900;
        Sun, 15 Aug 2021 08:01:39 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e3sm8390785pfi.189.2021.08.15.08.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 08:01:39 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
 <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
 <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
 <a583a8e2-68d0-9baf-c7c2-8a3a06848f4c@gmail.com>
 <fe8d2eea-a2a1-2c30-474a-edaae5cdcd09@kernel.dk>
 <2cf31753-cf71-d7c6-c94c-3c8685be76ec@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca7d1a29-a0ab-6a8c-2443-f99d3dcb0e94@kernel.dk>
Date:   Sun, 15 Aug 2021 09:01:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2cf31753-cf71-d7c6-c94c-3c8685be76ec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 3:41 AM, Pavel Begunkov wrote:
> On 8/14/21 8:38 PM, Jens Axboe wrote:
>> On 8/14/21 1:36 PM, Pavel Begunkov wrote:
>>> On 8/14/21 8:31 PM, Pavel Begunkov wrote:
>>>> On 8/14/21 8:13 PM, Jens Axboe wrote:
>>>>> On 8/14/21 10:26 AM, Pavel Begunkov wrote:
>>>>>> If a requests is forwarded into io-wq, there is a good chance it hasn't
>>>>>> been refcounted yet and we can save one req_ref_get() by setting the
>>>>>> refcount number to the right value directly.
>>>>>
>>>>> Not sure this really matters, but can't hurt either. But...
>>>>
>>>> The refcount patches made this one atomic worse, and I just prefer
>>>> to not regress, even if slightly
>>>>
>>>>>> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>>>>>>  	atomic_inc(&req->refs);
>>>>>>  }
>>>>>>  
>>>>>> -static inline void io_req_refcount(struct io_kiocb *req)
>>>>>> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>>>>>>  {
>>>>>>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>>>>>>  		req->flags |= REQ_F_REFCOUNT;
>>>>>> -		atomic_set(&req->refs, 1);
>>>>>> +		atomic_set(&req->refs, nr);
>>>>>>  	}
>>>>>>  }
>>>>>>  
>>>>>> +static inline void io_req_refcount(struct io_kiocb *req)
>>>>>> +{
>>>>>> +	__io_req_refcount(req, 1);
>>>>>> +}
>>>>>> +
>>>>>
>>>>> I really think these should be io_req_set_refcount() or something like
>>>>> that, making it clear that we're actively setting/manipulating the ref
>>>>> count.
>>>>
>>>> Agree. A separate patch, maybe?
>>>
>>> I mean it just would be a bit easier for me, instead of rebasing
>>> this series and not yet sent patches.
>>
>> I think it should come before this series at least, or be folded into the
>> first patch. So probably no way around the rebase, sorry...
> 
> Don't see the point, but anyway, just resent it

That's the usual approach, first a prep patch to clean it up, then change
on top. The opposite might be easier since the other patches already exist,
but it's backwards in terms of ordering imho.

-- 
Jens Axboe

