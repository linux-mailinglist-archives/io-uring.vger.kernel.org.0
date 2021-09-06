Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DE8401C3F
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 15:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242192AbhIFN0G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 09:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241543AbhIFN0F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 09:26:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273F7C061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 06:25:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so3763702pjb.1
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 06:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HPoxsfvKEJ134tapTJmvDlhRonpOrrlylKqWCI7v9cE=;
        b=tQA7DXk5l14O6w9TiME3KXMjgyGaDo2o3Bnk9pwWxAuQmDdIFgBQ0Ayro+pM9SuAzl
         hXkTyYG48MlC86JAy15CbbrdzAQT+TGzsv8lguuBvtgwOkXMgW7eHvMN63AWchAncssO
         PuDI4g0/eScd/f2pQ2resZmHhQHNHl075q/2SKqwM7r/iwGbIIIndUA23T7L+eVHQu07
         dzKflD/9dPYO1QGta4vhdwrAAtR9nDkOSbmtoWib7Ob8zFVfBTc3DrOeLJBliEmumI8h
         1oHyxCd5DSo1RPTLFg+mH12IjyKWf1d1ThgWTRZKU8fEqNEGescUxjc6NzaxC9Vv3m5V
         gCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HPoxsfvKEJ134tapTJmvDlhRonpOrrlylKqWCI7v9cE=;
        b=A9YLrgI4AFDUaeFSZ5lBpozNs/M4B7tzp9vxBCCqhCPAdDD+S5dMWq17cTrPMEsVYo
         D3WjfurIalleETgkbH7JzfA8FSC2zbcoy2oWAtzx2o/OZ7yTGSvzE748cYqsFI0Oin/M
         bqYspVyClrmh3YAJnscCuCqeKqfqUzMcrvVLyEgFOGvOZE0gPd6XNh5PstDhGZokYFIM
         GT53pSsduIDKCJUzvw9HQo9+RgMoZeVaM7bbIoYR3ybrj7khE1x64xqYZpND26yAFxgU
         7syPDTtjnei7LHIdsrNNCc4qbibocjbIv4If2ezNNxgIAzRMJt1Z55V3o+cFwSbuy64J
         vcXQ==
X-Gm-Message-State: AOAM531ImKuIr2cXALXfMOguqwh7XyPdb1KKvUbnuZdjz15BzJeLqbwY
        V6rqD/zMInDWaqIH2dcsfHrPjQ==
X-Google-Smtp-Source: ABdhPJycJELaOd055t5EUAQZAsHLskwqCbdcF1qm156HkSZeXqZVOBmtQnfh/j4QcudTF/IQ1NE9lA==
X-Received: by 2002:a17:90a:ec0a:: with SMTP id l10mr13919886pjy.26.1630934700449;
        Mon, 06 Sep 2021 06:25:00 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j4sm7737492pjc.46.2021.09.06.06.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 06:24:59 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
 <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
 <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
 <c991b4fa-e099-71c0-656f-e952a0758fe5@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c990184d-334a-7769-57eb-21fd658c3800@kernel.dk>
Date:   Mon, 6 Sep 2021 07:24:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c991b4fa-e099-71c0-656f-e952a0758fe5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 2:26 AM, Hao Xu wrote:
> 在 2021/9/6 上午3:44, Jens Axboe 写道:
>> On 9/4/21 4:46 PM, Pavel Begunkov wrote:
>>> On 9/4/21 7:40 PM, Jens Axboe wrote:
>>>> On 9/4/21 9:34 AM, Hao Xu wrote:
>>>>> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>>>>>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>>>>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>>>>>
>>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>>> ---
>>>>>>>    fs/io_uring.c | 14 ++++++++++++--
>>>>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index eb81d37dce78..34612646ae3c 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>    static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>    {
>>>>>>>    	struct io_accept *accept = &req->accept;
>>>>>>> +	bool is_multishot;
>>>>>>>    
>>>>>>>    	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>>    		return -EINVAL;
>>>>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>    	accept->flags = READ_ONCE(sqe->accept_flags);
>>>>>>>    	accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>>>>    
>>>>>>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>>>>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>>>>> +		return -EINVAL;
>>>>>>
>>>>>> I like the idea itself as I think it makes a lot of sense to just have
>>>>>> an accept sitting there and generating multiple CQEs, but I'm a bit
>>>>>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>>>>>> which can currently be:
>>>>>>
>>>>>> SOCK_NONBLOCK
>>>>>> SOCK_CLOEXEC
>>>>>>
>>>>>> While there's not any overlap here, that is mostly by chance I think. A
>>>>>> cleaner separation is needed here, what happens if some other accept4(2)
>>>>>> flag is enabled and it just happens to be the same as
>>>>>> IORING_ACCEPT_MULTISHOT?
>>>>> Make sense, how about a new IOSQE flag, I saw not many
>>>>> entries left there.
>>>>
>>>> Not quite sure what the best approach would be... The mshot flag only
>>>> makes sense for a few request types, so a bit of a shame to have to
>>>> waste an IOSQE flag on it. Especially when the flags otherwise passed in
>>>> are so sparse, there's plenty of bits there.
>>>>
>>>> Hence while it may not be the prettiest, perhaps using accept->flags is
>>>> ok and we just need some careful code to ensure that we never have any
>>>> overlap.
>>>
>>> Or we can alias with some of the almost-never-used fields like
>>> ->ioprio or ->buf_index.
>>
>> It's not a bad idea, as long as we can safely use flags from eg ioprio
>> for cases where ioprio would never be used. In that sense it's probably
>> safer than using buf_index.
>>
>> The alternative is, as has been brougt up before, adding a flags2 and
>> reserving the last flag in ->flags to say "there are flags in flags2".
> May I ask when do we have to use a bit in ->flags to do this? My
> understanding is just leverage a __u8 in pad2[2] in io_uring_sqe to
> deliver ext_flags.

We may not need to, it depends solely on whether or not we currently
check that pad for zero or not, and -EINVAL if it's not zero. Otherwise
you can end up with the unfortunate side effect that applications will
set some extended flag on an older kernel and think that it works, but
the old kernel just ignores is as it isn't checked.

-- 
Jens Axboe

