Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA30177BEE
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 17:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCCQ3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 11:29:55 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40056 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgCCQ3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 11:29:52 -0500
Received: by mail-il1-f193.google.com with SMTP id g6so3280348ilc.7
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 08:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bHqnqRwud5tCLDWzSgVYyMsZnd8YHHXZanC80bGJ5O8=;
        b=Ay+0jYLIuqECJTZm+G8WqdQ6JLuVHhx+JTFTQfJa63acVRGTUzu0CoVgczUjzNmDsm
         mbpjb1VcQvZ/om6X+fltyGMoKEPijNn7lnlBAP+XBfJtXtdOMosYdJsSpu0Cu4HurFY0
         bLdEFH+OBKDCijDoDVuMmF2BQZM/wIVzEKP2CsshzzwbKjEg7x7tGutS52O24aObpqal
         VpEeEuaunwTCMzygO9jxcjJPCez1VUGu0j6mrg7LhSMr4R4jwIMIG3MWKIu4lRQ8nNTJ
         63GgUUbK8SfX02r3S7zHcyegwu/X/iKwDmzfQkIGMCRbghCZj4Uws9/CmMgq3ERCsBJU
         8Enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bHqnqRwud5tCLDWzSgVYyMsZnd8YHHXZanC80bGJ5O8=;
        b=GsSY5gFnr7HdwJ7EyxJRKQ7sU3p1LOHJsa7fNvOiI/YXenFNYhDnfVP8ZcgUm4zfRh
         JqXpA6D/s9lC1erOXM3jdEhbzf1VEHzDtCvnMMCTglzza6TA2/9DcakhPklMWyE8/H2i
         E48Uq6hpTY+DjHwz5BVRPFFW55kHLx6n4SM6lRxeKPiYOrBczvv0NZTiy+DPZrtH68E9
         ON6Z/6ALNf3V+4VoYU+VYn/m6tXXkxW+RZMYYwEK+NA6zzk5xX1soyk4woSb2QBCsK1d
         ZrMCd8IJmlIimyHa1UV+KXZPsfSZQ6nfLFX7uInU/OaBB8mA5wTkLokB15Y9G4/YWf50
         aP1A==
X-Gm-Message-State: ANhLgQ2XJK2kQg3w8p7I5IbevjoVqypKxCqQK5SNoRd85Hb1pTW5urxN
        X6R2/MTfgNkjos4SpsfxM5Fhvg==
X-Google-Smtp-Source: ADFU+vtw2ooXY8bgX36hXoMG17cL5yeCZEMPNspBFcQs1750nnNwgKLmx5NEt5gXM4Ayg1dmKdVVYQ==
X-Received: by 2002:a92:8d41:: with SMTP id s62mr5145756ild.63.1583252990750;
        Tue, 03 Mar 2020 08:29:50 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j3sm4861403iob.77.2020.03.03.08.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:29:49 -0800 (PST)
Subject: Re: [PATCH v2 4/4] io_uring: get next req on subm ref drop
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583181841.git.asml.silence@gmail.com>
 <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
 <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
 <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
 <9ead66eb-cb5d-2dab-1a78-02466958674a@gmail.com>
 <153662f4-0ab9-8dac-1577-0df1ce35f320@kernel.dk>
Message-ID: <3837e24b-4c27-78b0-869a-ebbe42fe3a3c@kernel.dk>
Date:   Tue, 3 Mar 2020 09:29:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <153662f4-0ab9-8dac-1577-0df1ce35f320@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/20 9:04 AM, Jens Axboe wrote:
> On 3/3/20 3:46 AM, Pavel Begunkov wrote:
>> On 3/3/2020 9:54 AM, Pavel Begunkov wrote:
>>> On 03/03/2020 07:26, Jens Axboe wrote:
>>>> On 3/2/20 1:45 PM, Pavel Begunkov wrote:
>>>>> Get next request when dropping the submission reference. However, if
>>>>> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
>>>>> that would be dangerous to do, so ignore them using new
>>>>> REQ_F_DONT_STEAL_NEXT flag.
>>>>
>>>> Hmm, not so sure I like this one. It's not quite clear to me where we
>>>> need REQ_F_DONT_STEAL_NEXT. If we have an async component, then we set
>>>> REQ_F_DONT_STEAL_NEXT. So this is generally the case where our
>>>> io_put_req() for submit is not the last drop. And for the other case,
>>>> the put is generally in the caller anyway. So I don't really see what
>>>> this extra flag buys us?
>>>
>>> Because io_put_work() holds a reference, no async handler can achive req->refs
>>> == 0, so it won't return next upon dropping the submission ref (i.e. by
>>> put_find_nxt()). And I want to have next before io_put_work(), to, instead of as
>>> currently:
>>>
>>> run_work(work);
>>> assign_cur_work(NULL); // spinlock + unlock worker->lock
>>> new_work = put_work(work);
>>> assign_cur_work(new_work); // the second time
>>>
>>> do:
>>>
>>> new_work = run_work(work);
>>> assign_cur_work(new_work); // need new_work here
>>> put_work(work);
>>>
>>>
>>> The other way:
>>>
>>> io_wq_submit_work() // for all async handlers
>>> {
>>> 	...
>>> 	// Drop submission reference.
>>> 	// One extra ref will be put in io_put_work() right
>>> 	// after return, and it'll be done in the same thread
>>> 	if (atomic_dec_and_get(req) == 1)
>>> 		steal_next(req);
>>> }
>>>
>>> Maybe cleaner, but looks fragile as well. Would you prefer it?
>>
>> Any chance you've measured your next-work fix? I wonder how much does it
>> hurt performance, and whether we need a terse patch for 5.6.
> 
> Unless I'm missing something, the worker will pick up the next work
> without sleeping, since the request will have finished. So it really
> should not add any extra overhead, except you'll do an extra wqe lock
> roundtrip.
> 
> But I'll run some testing to be totally sure.

Testing with link-cp, not seeing much if anything of a difference. Not
in wqe load either.

-- 
Jens Axboe

