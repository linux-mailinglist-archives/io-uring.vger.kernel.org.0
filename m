Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC251618A4
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 18:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgBQRQj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 12:16:39 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39793 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbgBQRQj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 12:16:39 -0500
Received: by mail-pf1-f195.google.com with SMTP id 84so9221184pfy.6
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2020 09:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fbCrINXry1TOX5vwKsb/e7Cfj0hm/b1fBbWFyX+WosY=;
        b=t6crkzVQ2HrUDDP2QBUOvisDPe1FWNDHZ50xTbJiwD1WjKB7Lvi4Cbp3xV62n6sqTi
         +OXThzYMMdlY3rKK/Baa6Uv0Oo9fBB0EpTgIevHonjLWo7xtKozIhL6adz543P98Zcmk
         d8pGv+tcUctQyQmIEjz0r7OMh5TjOdW9IJfM1AdnIwz/IAidDAKOwuE+8Sr1P/nPCueA
         aaMO5D8ucJRuAgtWXqiqpztE0Al8FUOQH2TvMGl5GQw5IRwkt1U03ZCPqUBNf0fT+oUn
         FHXj0oNBK4NcO4nUnfnTiUmdBrs18l6EQWGGxMrAv3iq4GkFoJJM4bFjQZPQJmSTsd09
         PNtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fbCrINXry1TOX5vwKsb/e7Cfj0hm/b1fBbWFyX+WosY=;
        b=PGoNPCHSFEVFUZJWIiXBVmTxozXP6s+TUnmehpoy3XDfK4J9giEgztTKUdKUgG9eRY
         +6LslZO9w21fgz2vSE2OYq2tgmNFxwHUSZeWpbIxFkogr01rsmfMV6OpmA5UKEYfOaC5
         X/T8dmR9NbpNEQjtckRl/UypmcpO17N+dHbAAdeEddLhDeE1KIs6s/R4tfIlzaENQaoM
         /RcILk1rGusMQ+/XEoB/rY3EeVBGvjuQ4dpaxqootfqx09Yae5YBx+GXBR0vv+LQffPb
         7bc3By83WF4cvSA6dTF7JTcxQM2MzFOiykmRhmzNBXqFOTy/oZQyU84UUwPcF14r631B
         uakg==
X-Gm-Message-State: APjAAAX6F/D+sGQfXXz98GEy0P697ZSzMyxhRAMaQBYzB8aRCQJPhmyp
        0a7z2TPUX0BT3mDSactjXIBhGGlJJFY=
X-Google-Smtp-Source: APXvYqxRaUYzMp1F5tOWQtZw4OFESPhxK+JI1CxIlerXKjTCA5xg0WDAhHx2CECwUkQQCaWOZ94Vjg==
X-Received: by 2002:a63:7a03:: with SMTP id v3mr18257898pgc.256.1581959797092;
        Mon, 17 Feb 2020 09:16:37 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6957:8f58:7996:df24? ([2605:e000:100e:8c61:6957:8f58:7996:df24])
        by smtp.gmail.com with ESMTPSA id f127sm1069775pfa.112.2020.02.17.09.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:16:36 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
Message-ID: <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
Date:   Mon, 17 Feb 2020 09:16:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/20 9:12 AM, Jens Axboe wrote:
> On 2/17/20 5:09 AM, Peter Zijlstra wrote:
>> On Fri, Feb 14, 2020 at 01:44:32PM -0700, Jens Axboe wrote:
>>
>> I've not looked at git trees yet, but the below doesn't apply to
>> anything I have at hand.
>>
>> Anyway, I think I can still make sense of it -- just a rename or two
>> seems to be missing.
>>
>> A few notes on the below...
> 
> Thanks for continuing to look at it, while we both try and make sense of
> it :-)
> 
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index 04278493bf15..447b06c6bed0 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -685,6 +685,11 @@ struct task_struct {
>>>  #endif
>>>  	struct sched_dl_entity		dl;
>>>  
>>> +#ifdef CONFIG_IO_URING
>>> +	struct list_head		uring_work;
>>> +	raw_spinlock_t			uring_lock;
>>> +#endif
>>> +
>>
>> Could we pretty please use struct callback_head for this, just like
>> task_work() and RCU ? Look at task_work_add() for inspiration.
> 
> Sure, so add a new one, sched_work, and have it get this sched-in or
> sched-out behavior.
> 
> Only potential hitch I see there is related to ordering, which is more
> of a fairness thab correctness issue. I'm going to ignore that for now,
> and we can always revisit later.

OK, did the conversion, and it turned out pretty trivial, and reduces my
lines as well since I don't have to manage the list side. See here:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll

Three small prep patches:

sched: move io-wq/workqueue worker sched in/out into helpers
kernel: abstract out task work helpers
sched: add a sched_work list

and then the two main patches before on top of that, one which uses this
just for the poll command, then the last one which enables any request
to use this path if it's pollable.

Let me know what you think of the direction, and I'll send out a
"proper" series for perusing.

-- 
Jens Axboe

