Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BFA16F28F
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 23:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgBYWYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 17:24:45 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53208 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYWYp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 17:24:45 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep11so365015pjb.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 14:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xC+CXpeax1+vu/LP8D6JWv7cMLXjLdhEgPK+sSrRpJ8=;
        b=yQI1FgcRIK0QN5z5VaH7p7dSf1hLLdLay2CcZh5VZ6lE/AiJZCJkV5v9YHg5mGma5A
         R4zmSKlD9ad2SFdPvCOWuvKv9yy/6sEID25YUADihTOunLAfPHf92ZLzcscE/xmn3u6Z
         OBNZ4mlg9kbX7F9ejkIElrQF+rjnNc7WCIIbJ5DJ37jfYcv6WAGj4ucQCvC+5dtd8BAT
         5bVcjB6LMiopkmQicfuJgjUChSPVV34F1M3ZNWZPYbmhsNkKi67rHSfUnEhD2Qa3Xd80
         RoTwPL1FhSWNNMuWDy6CM/TA0lKj/4k5saKvXFusO8zCZ3MHb4uqX7hSTWyajflx+5sB
         63AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xC+CXpeax1+vu/LP8D6JWv7cMLXjLdhEgPK+sSrRpJ8=;
        b=KVB/FsS7jAEMKF2mw4x/W1cnUITnOjaEGsl2BUlsh+1PYm257DvvaRHt5LVG1zteIg
         s01BoEjKsGWE3dneybzMZIpN5FQQY3GcIap8YovCeuCzcY3LSnWkEtRLE8jb7/H/DL3i
         VOsR2KrSizOVECiIRf5v5E9ro1c2yKmgshXnt9yeX751LHmuqcHYD5Gnh+bqMHC9vHSG
         SyGvJt4noSLg/wTbsYKyR5rG5rgZ3j1xRJgSDePbzS3pCVwmheVpC1vi/Lxpae0GvtTX
         LGrlspgNs8TbsHjlrBP6mm7CUZ6tHxFCpCV3CZluRy5lNhRzqZ55sN/bfd0EGb06cqa8
         Bq4A==
X-Gm-Message-State: APjAAAW2M5g1cTZ1MdRfmMdFbLK2QlYWOF0Fjsa5w7MmK53eLqMRg3jD
        MXJnjZipAVuu+VwsL6YOYbXrR6fb7/QQDg==
X-Google-Smtp-Source: APXvYqwE8Q1ng2UbUFlZTApJZFHhdLP+MiaRN+e17r4D+ZKx1A6BqGdux5q5qO5gkM3q44BWVjKUiw==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr1445544pjr.22.1582669482462;
        Tue, 25 Feb 2020 14:24:42 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e7sm85613pfj.114.2020.02.25.14.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 14:24:42 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <f5cb2e96-b30f-eec9-7a0b-68bdfcb0b8e2@gmail.com>
 <6c476531-7ba8-1c2a-66c3-029ad399f0b1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0f2fd3ba-81e2-1a54-03a7-dded262a0c9f@kernel.dk>
Date:   Tue, 25 Feb 2020 15:24:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6c476531-7ba8-1c2a-66c3-029ad399f0b1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 2:52 PM, Pavel Begunkov wrote:
> On 26/02/2020 00:45, Pavel Begunkov wrote:
>> On 26/02/2020 00:25, Jens Axboe wrote:
>>> On 2/25/20 2:22 PM, Pavel Begunkov wrote:
>>>> On 25/02/2020 23:27, Jens Axboe wrote:
>>>>> If work completes inline, then we should pick up a dependent link item
>>>>> in __io_queue_sqe() as well. If we don't do so, we're forced to go async
>>>>> with that item, which is suboptimal.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> ---
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index ffd9bfa84d86..160cf1b0f478 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>>>>>  		} while (1);
>>>>>  	}
>>>>>  
>>>>> -	/* drop submission reference */
>>>>> -	io_put_req(req);
>>>>> +	/*
>>>>> +	 * Drop submission reference. In case the handler already dropped the
>>>>> +	 * completion reference, then it didn't pick up any potential link
>>>>> +	 * work. If 'nxt' isn't set, try and do that here.
>>>>> +	 */
>>>>> +	if (nxt)
>>>>
>>>> It can't even get here, because of the submission ref, isn't it? would the
>>>> following do?
>>>>
>>>> -	io_put_req(req);
>>>> +	io_put_req_find_next(req, &nxt);
>>>
>>> I don't think it can, let me make that change. And test.
>>>
>>>> BTW, as I mentioned before, it appears to me, we don't even need completion ref
>>>> as it always pinned by the submission ref. I'll resurrect the patches doing
>>>> that, but after your poll work will land.
>>>
>>> We absolutely do need two references, unfortunately. Otherwise we could complete
>>> the io_kiocb deep down the stack through the callback.
>>
>> And I need your knowledge here to not make mistakes :)
>> I remember the conversation about the necessity of submission ref, that's to
>> make sure it won't be killed in the middle of block layer, etc. But what about
>> removing the completion ref then?
>>
>> E.g. io_read(), as I see all its work is bound by lifetime of io_read() call,
>> so it's basically synchronous from the caller perspective. In other words, it
>> can't complete req after it returned from io_read(). And that would mean it's
>> save to have only submission ref after dealing with poll and other edge cases.
>>
>> Do I miss something?
> 
> Hmm, just started to question myself, whether handlers can be not as synchronous
> as described...

It very much can complete the req after io_read() returns, that's what
happens for any async disk request! By the time io_read() returns, the
request could be completed, or it could just be in-flight. This is
different from lots of the other opcodes, where the actual call returns
completion sync (either success, or EAGAIN).

-- 
Jens Axboe

