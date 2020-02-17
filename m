Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D1E161B9D
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 20:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgBQTae (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 14:30:34 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35584 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgBQTae (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 14:30:34 -0500
Received: by mail-pg1-f196.google.com with SMTP id v23so6335516pgk.2
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2020 11:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AjuKtGi5DKghnSIcB42ZcnH9BwW878p7skwEuhckzfg=;
        b=yD2erpbpB0PcDOHVhvugzZj5MPbf/9Gf0ErDsIXdJ/WMOTrbAfNA5KZYHfqeCtU3Mv
         za/DRTSXwzqTKB+z740zGFD0Ea5B8HREX9xCVAZScOPdg1Vy4wPB76jg2no9PFfcmk1y
         rXPk8q45jjUh+2TMq4vJWzd451yrJOzmXij30CD8YWdgg1uX7P8R6hENfEUvhKltWr5S
         PkJNGaV/dvnE7E3pmRI3y4T2GpIk/J0VPKUCm2ksQe1K1lHA1c5ntT0+N3t8BgNmJSLy
         qV+qCUxsnVuQlKD6gD2v8bYWFWyDRtz8jPL36qHWlcY1TGrl6Km+T3ewZRrSyqP50Lpk
         hYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AjuKtGi5DKghnSIcB42ZcnH9BwW878p7skwEuhckzfg=;
        b=s2yKo23qiN7LzdGARhyKoVz1ye560Ia8Brw4hTdMkrC7Js3S6uY7wuVehINzSgIxs0
         2E6KyTm+TB/UDgd8B3KBtK6X40CdqjiZYVwZBPIt2daFfTKsQrVSmaEnfms6I5WAleMb
         S8vmaG48bmPM1rSQ6VanQaSx/ITB6S7HgM2JNOzws0nuS6YwnsI0J70PFtwog5KCrtlI
         ES4FJS80VCUaRNkh2iSks6C1nprmFebWdJhl0lKm5m3SfLNbTryi3wdn+wto9OeV8FvI
         D6dzmkssrA61zkZGXVQmT/GgN5HSeenAREzN/qDMjYrhmVOtMouugUQSUHDd0oa+y0Gg
         7rLQ==
X-Gm-Message-State: APjAAAWutzm1r8hH7fOFSyLkDSC4jHxmbLiastdBMPlmRiOQf40n4B6a
        fLgY5up3Ru2zSsfwwv7vI+b8edC6b5k=
X-Google-Smtp-Source: APXvYqxTJnn00cgRc6BtHWfZQDe/md786cR9dlNEaPCYEAd9k19rlrrS3e8EYs+ncdnNfN2NrgRQNQ==
X-Received: by 2002:a63:1e17:: with SMTP id e23mr18715905pge.6.1581967832168;
        Mon, 17 Feb 2020 11:30:32 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6957:8f58:7996:df24? ([2605:e000:100e:8c61:6957:8f58:7996:df24])
        by smtp.gmail.com with ESMTPSA id b15sm1208120pft.58.2020.02.17.11.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 11:30:31 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
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
 <d7f5d742-609e-0de6-11ce-e621e4ec8d68@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <64b82f99-f468-627a-3530-c72e29e747dd@kernel.dk>
Date:   Mon, 17 Feb 2020 11:30:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d7f5d742-609e-0de6-11ce-e621e4ec8d68@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/20 3:30 AM, Pavel Begunkov wrote:
> On 2/17/2020 1:23 AM, Jens Axboe wrote:
>> On 2/16/20 12:06 PM, Pavel Begunkov wrote:
>>> On 15/02/2020 09:01, Jens Axboe wrote:
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index fb94b8bac638..530dcd91fa53 100644
>>>> @@ -4630,6 +4753,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>  	 */
>>>>  	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
>>>>  	    (req->flags & REQ_F_MUST_PUNT))) {
>>>> +
>>>> +		if (io_arm_poll_handler(req, &retry_count)) {
>>>> +			if (retry_count == 1)
>>>> +				goto issue;
>>>
>>> Better to sqe=NULL before retrying, so it won't re-read sqe and try to
>>> init the req twice.
>>
>> Good point, that should get cleared after issue.
>>
>>> Also, the second sync-issue may -EAGAIN again, and as I remember,
>>> read/write/etc will try to copy iovec into req->io. But iovec is
>>> already in req->io, so it will self memcpy(). Not a good thing.
>>
>> I'll look into those details, that has indeed reared its head before.
>>
>>>> +			else if (!retry_count)
>>>> +				goto done_req;
>>>> +			INIT_IO_WORK(&req->work, io_wq_submit_work);
>>>
>>> It's not nice to reset it as this:
>>> - prep() could set some work.flags
>>> - custom work.func is more performant (adds extra switch)
>>> - some may rely on specified work.func to be called. e.g. close(), even though
>>> it doesn't participate in the scheme
>>
>> It's totally a hack as-is for the "can't do it, go async". I did clean
> 
> And I don't understand lifetimes yet... probably would need a couple of
> questions later.
> 
>> this up a bit (if you check the git version, it's changed quite a bit),
> 
> That's what I've been looking at
> 
>> but it's still a mess in terms of that and ->work vs union ownership.
>> The commit message also has a note about that.
>>
>> So more work needed in that area for sure.
> 
> Right, I just checked a couple of things for you

Appreciate it! I'll send out the series for easier review and
commenting. It's getting better, but still a bit rough around the edges.
It passes the test suite now, except for:

- socket-rw and connect - both of these don't get a poll wakeup from the
  networking side when the connection is made (or data is sent), which
  is very odd. So we just keep waiting for that, and nothing happens.
  Need to figure out why there's never a wakeup on it.

-- 
Jens Axboe

