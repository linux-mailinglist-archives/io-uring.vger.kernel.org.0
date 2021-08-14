Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D9B3EC4C2
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 21:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhHNThK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 15:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhHNThK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 15:37:10 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908C5C061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:36:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x10so11586280wrt.8
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EJXobkkAsZQ5CHlFS9Ms911RxybQxp5b1PGnbDt4olQ=;
        b=AUo54rL1ClrsBGil56rXJxDFPaffBRT4FujDGMPIsDFwXwO4ftKkb8cfAVKKbKouhU
         MZKx99I0vjX3pYvc9kh/EfZwGUbvQFoCyDVaZQXi/4qJP+G+3S15hNJ8vb0j9ehYw968
         MqMzSssIu4ss6U5ZM9YNJ3eqCzw3LiVYbuCHYZeYHrFBxgLmkoeCHKV8mcOcrDAOBIef
         JusjXPcUXRtnmvv/oXne71pvRokcf1vtSE/V4RtYVQpYjfQr8NG0d1Shi+Sedi9Nidpm
         6MYbA7yG0oC30KYeEpuRAjgt7w5ADeex0AmFn3N84Mfc6VZt9Cat4Ol8kazuxjnTZCUQ
         WYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EJXobkkAsZQ5CHlFS9Ms911RxybQxp5b1PGnbDt4olQ=;
        b=MnDwEmRwSPP33LiMNRVoQeJ2JugNDiWP8h4EXfZchpgA8FChsq3Wsengwm9OjEi1Zk
         yw+Ov02ON6xZ362cF+SillyC8p1rdtqUE7GYsBIZ0YtcddhK5pLrLyCLGLM+unUMjWVm
         6clxllf0on8U+94d4PjYkxzUMGa+xc6Ec7wvk3M/HV11rcYyBX4XWfSfK4CQvmITZPXG
         TV6a4JJ/N7EQ5a4hx+YEca74AWykqut8+JaoC8EXPl2eo8keSdcyjqem9rsj13w840zd
         BovvqkxbNr08UKM07qreE7uxobuIhwMqMXqUIAUMIetX6//ytIkCEg2gKWCGRatt9HsZ
         u7AA==
X-Gm-Message-State: AOAM531apQw7GZf2nihcLWTwrpjpVS0dQ2W8zz72A1p6yZWvpuwe6YPM
        PSZKi9h0ksRJ2I/uMLZ1uRgBqia4ivM=
X-Google-Smtp-Source: ABdhPJx3XcY8HmuITS9sosS0jn2JxcwJhR8tNx144vckFf3Hi1diYzc/fr6w46Yl81bfyNGiC8UXOw==
X-Received: by 2002:adf:e0cd:: with SMTP id m13mr9681339wri.372.1628969798833;
        Sat, 14 Aug 2021 12:36:38 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id y3sm5772070wma.32.2021.08.14.12.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 12:36:38 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
 <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
 <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
Message-ID: <a583a8e2-68d0-9baf-c7c2-8a3a06848f4c@gmail.com>
Date:   Sat, 14 Aug 2021 20:36:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 8:31 PM, Pavel Begunkov wrote:
> On 8/14/21 8:13 PM, Jens Axboe wrote:
>> On 8/14/21 10:26 AM, Pavel Begunkov wrote:
>>> If a requests is forwarded into io-wq, there is a good chance it hasn't
>>> been refcounted yet and we can save one req_ref_get() by setting the
>>> refcount number to the right value directly.
>>
>> Not sure this really matters, but can't hurt either. But...
> 
> The refcount patches made this one atomic worse, and I just prefer
> to not regress, even if slightly
> 
>>> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>>>  	atomic_inc(&req->refs);
>>>  }
>>>  
>>> -static inline void io_req_refcount(struct io_kiocb *req)
>>> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>>>  {
>>>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>>>  		req->flags |= REQ_F_REFCOUNT;
>>> -		atomic_set(&req->refs, 1);
>>> +		atomic_set(&req->refs, nr);
>>>  	}
>>>  }
>>>  
>>> +static inline void io_req_refcount(struct io_kiocb *req)
>>> +{
>>> +	__io_req_refcount(req, 1);
>>> +}
>>> +
>>
>> I really think these should be io_req_set_refcount() or something like
>> that, making it clear that we're actively setting/manipulating the ref
>> count.
> 
> Agree. A separate patch, maybe?

I mean it just would be a bit easier for me, instead of rebasing
this series and not yet sent patches.

-- 
Pavel Begunkov
