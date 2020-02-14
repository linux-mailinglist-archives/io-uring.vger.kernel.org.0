Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A80A15F81C
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 21:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbgBNUth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 15:49:37 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40657 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389583AbgBNUte (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 15:49:34 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so4148357plp.7
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 12:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3U2D6HYT6vmvK+0M3hWyMuURZVRb1mRZEBo7yfrXwDw=;
        b=sgrjrQL6mvKeETuJ5BsVxee8Sl2+MrnplKYiL8hBjdUsVrvn2FkGwDFwvemEVjrBPX
         ll3GatjCBzQuPyZq88dgbHgD00V4KpyFBhahxp3jRFoGhnGlmUdHW8Q/YLCipWK9ABjm
         riMmphpIXqKZ+Az/CYTRA3eJsgtVLC0gIov9FI1Kl0j7lDsClgELTqANjfZN26HqA3K7
         5lH32qEYHtzvTQEIj3gzBQxYJA0hnibGUinREALxaInUkLHqpmk2pbJPqoLfb6d9tkT8
         Xzhsp+SO26vS4tmUQWnMRoBAqA0JwBr9GEs+MA+36DlASn+UziPJAuFcT+OcsuXACzrQ
         5Z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3U2D6HYT6vmvK+0M3hWyMuURZVRb1mRZEBo7yfrXwDw=;
        b=YmO1fOtS3oxDr/JekmV01AT/s+iFUwFVT5Hu6EiDiPfsKH4nEC036Fq9VDY1VYew/o
         L9mlYb/6BfWZ0qBdVeTLZatxIVeEexzuxchGQs3vQYFcxA1mOGV4eLRVqhCISR0fldjd
         XQ4RjaMMY6QcrMlQe2jRo3O2JmljLcHsIh+3ocNqQFuYcuH4ciybetKYjig6cF5RPCFS
         6YIqOfL6Gl02uV6qqLT5wEAZYr3BPndB/MbLVDJ/O0lRxIIsH94RWPWX7RyiJ6YNEOMF
         tNxCVTcVnsslRbxLDjNl0a2yGmfxOwxX11pg+jJa+Za5HezeTjKqTd/wBndSbooqtuQO
         ZkMw==
X-Gm-Message-State: APjAAAWCuulo8vgEfCZ7Nl5XMzzy3lA9YOy92PCyVOwMBPEAWIu2kuLm
        fgUzybPUnksLiskWiKUJ59BiwFWHkOc=
X-Google-Smtp-Source: APXvYqy51dXuiYsL6ecBylJzniO9VMpemDqAqKDfr6YCHKGaUODo6X7/mraa1T0Y64ee/rTdIBTTOA==
X-Received: by 2002:a17:90a:1b42:: with SMTP id q60mr5609544pjq.108.1581713373288;
        Fri, 14 Feb 2020 12:49:33 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id gx18sm7855731pjb.8.2020.02.14.12.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 12:49:32 -0800 (PST)
Subject: Re: Buffered IO async context overhead
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
Date:   Fri, 14 Feb 2020 13:49:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 1:31 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-14 13:13:35 -0700, Jens Axboe wrote:
>> On 2/14/20 12:50 PM, Andres Freund wrote:
>>> which I think is pretty clear evidence we're hitting fairly significant
>>> contention on the queue lock.
>>>
>>>
>>> I am hitting this in postgres originally, not fio, but I thought it's
>>> easier to reproduce this way.  There's obviously benefit to doing things
>>> in the background - but it requires odd logic around deciding when to
>>> use io_uring, and when not.
>>>
>>> To be clear, none of this happens with DIO, but I don't forsee switching
>>> to DIO for all IO by default ever (too high demands on accurate
>>> configuration).
>>
>> Can you try with this added?
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 76cbf474c184..207daf83f209 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -620,6 +620,7 @@ static const struct io_op_def io_op_defs[] = {
>>  		.async_ctx		= 1,
>>  		.needs_mm		= 1,
>>  		.needs_file		= 1,
>> +		.hash_reg_file		= 1,
>>  		.unbound_nonreg_file	= 1,
>>  	},
>>  	[IORING_OP_WRITEV] = {
>> @@ -634,6 +635,7 @@ static const struct io_op_def io_op_defs[] = {
>>  	},
>>  	[IORING_OP_READ_FIXED] = {
>>  		.needs_file		= 1,
>> +		.hash_reg_file		= 1,
>>  		.unbound_nonreg_file	= 1,
>>  	},
>>  	[IORING_OP_WRITE_FIXED] = {
>> @@ -711,11 +713,13 @@ static const struct io_op_def io_op_defs[] = {
>>  	[IORING_OP_READ] = {
>>  		.needs_mm		= 1,
>>  		.needs_file		= 1,
>> +		.hash_reg_file		= 1,
>>  		.unbound_nonreg_file	= 1,
>>  	},
>>  	[IORING_OP_WRITE] = {
>>  		.needs_mm		= 1,
>>  		.needs_file		= 1,
>> +		.hash_reg_file		= 1,
>>  		.unbound_nonreg_file	= 1,
>>  	},
>>  	[IORING_OP_FADVISE] = {
>> @@ -955,7 +959,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
>>  	bool do_hashed = false;
>>  
>>  	if (req->flags & REQ_F_ISREG) {
>> -		if (def->hash_reg_file)
>> +		if (!(req->kiocb->ki_flags & IOCB_DIRECT) && def->hash_reg_file)
>>  			do_hashed = true;
>>  	} else {
>>  		if (def->unbound_nonreg_file)
> 
> I can (will do Sunday, on the road till then). But I'm a bit doubtful
> it'll help. This is using WRITEV after all, and I only see a single
> worker?

Because I'm working on other items, I didn't read carefully enough. Yes
this won't change the situation for writes. I'll take a look at this when
I get time, maybe there's something we can do to improve the situation.

-- 
Jens Axboe

