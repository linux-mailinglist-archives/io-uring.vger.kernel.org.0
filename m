Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74DC16100E
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 11:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgBQKaF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 05:30:05 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:41522 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbgBQKaF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 05:30:05 -0500
Received: by mail-lj1-f178.google.com with SMTP id h23so18226857ljc.8
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2020 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k7nCoU7LzX5GTmp3qoFLkP3vbF2557EICTjXtwcNvEo=;
        b=SuslNW8iPPKCaUWjyuk1lbpaYfA4E+FH/ifsW8955+4tOGtWY7T/57xImNE8KDsc0z
         8ykfGgiAG16pryw4XXTcb17348OqvNk+SrUFUb1iwIUvNHHEzTSzELYkB+mjYrkH2zAq
         PhpnWvfD/VmSL6AGy7OqEh4C1eLXzLYYxhzpyu2z+LScGuGERiFLpLDS1iU0ggih2MoX
         ohtrLZZlTKaoHFX7qYoZNjXv4y3cNN5zT9UMhqQP6NGm53wHs/pIvFphmxGJ621iqB+n
         yRr3e8atco2lhwxsjo6PgdtJtjVViCoxv7baJrukvnjKqCszOW0oPXEZ877hZm1Vbp67
         0pzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k7nCoU7LzX5GTmp3qoFLkP3vbF2557EICTjXtwcNvEo=;
        b=PY29uXHlUlV+GAiCZUY9QZP39pRZ64lF9a+KRPbUlfhdkIJ1MIEItHW2B126BOxIuA
         dJ4a1QLKjAVwYMg+yFLOuQHKfd4TP2R4U5M32X4PYlUH4yxShotveE7KUgVkif76fnq5
         69VZos+BWYYSb9cotAtxWTo13eUlwW8qYLGEvqNAyxR1YQjyP7Y8UA8jy4msgm05d0Y8
         3yx4yM9AvolXHZYo0qPCCUOpr6BdxiGwjw/RS6Bg/pzQ5sCtIg1n+8I2VlpssJ8VjRJF
         JPWKtem7yT3+8+TpnSIBXRi2huDEY1npLCK8LEx93qJkKg3XqxhjHFJM+v6BjxgtHKRv
         5YIw==
X-Gm-Message-State: APjAAAVzmkzi7qy1V2otvg7E9tPwU+HvFKvBarmxNKvsqvuWhEhkqEs9
        TfWgBjcWw4oA8WDTM9ZF9/STkYFY42s=
X-Google-Smtp-Source: APXvYqz9PnmsxBjjVSIcFxAMLZ9w5WjAGwFC0vuApVHfRtwO1slSOzetqOM8VoJ+pEzzRJ51ck8Sng==
X-Received: by 2002:a05:651c:120d:: with SMTP id i13mr9579263lja.173.1581935402565;
        Mon, 17 Feb 2020 02:30:02 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id 144sm58148lfi.67.2020.02.17.02.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 02:30:01 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
 <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
 <08cc6880-be41-9ca7-3026-7988ac7d9640@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d7f5d742-609e-0de6-11ce-e621e4ec8d68@gmail.com>
Date:   Mon, 17 Feb 2020 13:30:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <08cc6880-be41-9ca7-3026-7988ac7d9640@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/2020 1:23 AM, Jens Axboe wrote:
> On 2/16/20 12:06 PM, Pavel Begunkov wrote:
>> On 15/02/2020 09:01, Jens Axboe wrote:
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index fb94b8bac638..530dcd91fa53 100644
>>> @@ -4630,6 +4753,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	 */
>>>  	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
>>>  	    (req->flags & REQ_F_MUST_PUNT))) {
>>> +
>>> +		if (io_arm_poll_handler(req, &retry_count)) {
>>> +			if (retry_count == 1)
>>> +				goto issue;
>>
>> Better to sqe=NULL before retrying, so it won't re-read sqe and try to
>> init the req twice.
> 
> Good point, that should get cleared after issue.
> 
>> Also, the second sync-issue may -EAGAIN again, and as I remember,
>> read/write/etc will try to copy iovec into req->io. But iovec is
>> already in req->io, so it will self memcpy(). Not a good thing.
> 
> I'll look into those details, that has indeed reared its head before.
> 
>>> +			else if (!retry_count)
>>> +				goto done_req;
>>> +			INIT_IO_WORK(&req->work, io_wq_submit_work);
>>
>> It's not nice to reset it as this:
>> - prep() could set some work.flags
>> - custom work.func is more performant (adds extra switch)
>> - some may rely on specified work.func to be called. e.g. close(), even though
>> it doesn't participate in the scheme
> 
> It's totally a hack as-is for the "can't do it, go async". I did clean

And I don't understand lifetimes yet... probably would need a couple of
questions later.

> this up a bit (if you check the git version, it's changed quite a bit),

That's what I've been looking at

> but it's still a mess in terms of that and ->work vs union ownership.
> The commit message also has a note about that.
> 
> So more work needed in that area for sure.

Right, I just checked a couple of things for you

-- 
Pavel Begunkov
