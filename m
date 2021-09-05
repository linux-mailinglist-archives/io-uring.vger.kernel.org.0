Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46599401169
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 21:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhIETp4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Sep 2021 15:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhIETp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Sep 2021 15:45:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B8EC061575
        for <io-uring@vger.kernel.org>; Sun,  5 Sep 2021 12:44:53 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id n18so4542761pgm.12
        for <io-uring@vger.kernel.org>; Sun, 05 Sep 2021 12:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfRHVFqB2C2Y8VLvrzuyykwZQ1yNxAFKQDDFuNABMHU=;
        b=DayioVgQEMqAdDq+t9ZSL2uxKn6KsvA582FqEoMVhdyijRR3UU3z+i4/M8fJZTF2yi
         FA6ckP9RA8TcsSSInqHMCQ64m8hrzfFtgdt8y4Ax1maWXlNE2YbFKlUa4DDkblU0tWCN
         /kZc4c++5N2LKqQDiLiOosSNpO0n5rhCw6I9xBFr4TJ0kwmuxEGfZhiCqT1r6KWaHJp/
         eM2UsewXYtIbXxaH42wgGYD7CFqwp5evI747GkHAhTkSnSrLZYuedzjJfLKj5oRWXDRY
         qf/BdghMBxFwUCKhvN2yFFFIcluxSULwSJJ6rqcAwvv8BdHmFqOhnFWHJFOB7sRzGmw2
         FGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfRHVFqB2C2Y8VLvrzuyykwZQ1yNxAFKQDDFuNABMHU=;
        b=huu1WvLq8LJ+iIqZliravFa6f9tN5wrLgfV6aEkE8kIF13B3LgLEDwwy064chdRY9p
         smrZ2kr1Rou/MW1QI79Sj/dykCzntY6minSYdT/NykYdpTyBNRUpeQqfiNhCC6+obIZP
         RvBsuFwazf1b8zHQ6ThtxHjdwgIT/NsVjV3rr66yWRwhq9QL0g8i2gmM0rpA3SOIfs5T
         hRFS4JFlwzQf9m+3RUsyIPef8uU/50Emt50Y29WJlVM0yPgb+mmANcd2/0zHc6ZN5iHy
         kmAfMH8JRXu/KhUE+3ChV/jFkPbnLcVpSSHUNtUs48CujwaqvVJqIlRd9nL1SaQ6vWPw
         jDOA==
X-Gm-Message-State: AOAM531XDmSussONm1YWOAmgJeQQABBqwmQ43A/fSuGqOyEEiQkhiqm5
        NXgrKq4KPaIwJCWFnpMufvMVfA==
X-Google-Smtp-Source: ABdhPJwml47P3SRxfab79SRlpWJOWUXv8DMiW6qG8w7ZougT0zndVy2rYJ0mMDtrePQLpNwJdDclpw==
X-Received: by 2002:a05:6a00:1a03:b0:414:5c97:777a with SMTP id g3-20020a056a001a0300b004145c97777amr6124736pfv.58.1630871092505;
        Sun, 05 Sep 2021 12:44:52 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y11sm5281321pfl.198.2021.09.05.12.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 12:44:52 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
 <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
Date:   Sun, 5 Sep 2021 13:44:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/21 4:46 PM, Pavel Begunkov wrote:
> On 9/4/21 7:40 PM, Jens Axboe wrote:
>> On 9/4/21 9:34 AM, Hao Xu wrote:
>>> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>>>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>>>
>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>> ---
>>>>>   fs/io_uring.c | 14 ++++++++++++--
>>>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index eb81d37dce78..34612646ae3c 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>   {
>>>>>   	struct io_accept *accept = &req->accept;
>>>>> +	bool is_multishot;
>>>>>   
>>>>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>   		return -EINVAL;
>>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>   	accept->flags = READ_ONCE(sqe->accept_flags);
>>>>>   	accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>>   
>>>>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>>> +		return -EINVAL;
>>>>
>>>> I like the idea itself as I think it makes a lot of sense to just have
>>>> an accept sitting there and generating multiple CQEs, but I'm a bit
>>>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>>>> which can currently be:
>>>>
>>>> SOCK_NONBLOCK
>>>> SOCK_CLOEXEC
>>>>
>>>> While there's not any overlap here, that is mostly by chance I think. A
>>>> cleaner separation is needed here, what happens if some other accept4(2)
>>>> flag is enabled and it just happens to be the same as
>>>> IORING_ACCEPT_MULTISHOT?
>>> Make sense, how about a new IOSQE flag, I saw not many
>>> entries left there.
>>
>> Not quite sure what the best approach would be... The mshot flag only
>> makes sense for a few request types, so a bit of a shame to have to
>> waste an IOSQE flag on it. Especially when the flags otherwise passed in
>> are so sparse, there's plenty of bits there.
>>
>> Hence while it may not be the prettiest, perhaps using accept->flags is
>> ok and we just need some careful code to ensure that we never have any
>> overlap.
> 
> Or we can alias with some of the almost-never-used fields like
> ->ioprio or ->buf_index.

It's not a bad idea, as long as we can safely use flags from eg ioprio
for cases where ioprio would never be used. In that sense it's probably
safer than using buf_index.

The alternative is, as has been brougt up before, adding a flags2 and
reserving the last flag in ->flags to say "there are flags in flags2".
Not exactly super pretty either, but we'll need to extend them at some
point.

-- 
Jens Axboe

