Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8B514FE50
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 17:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgBBQfE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Feb 2020 11:35:04 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:35192 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgBBQfD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Feb 2020 11:35:03 -0500
Received: by mail-pf1-f179.google.com with SMTP id y73so6244002pfg.2
        for <io-uring@vger.kernel.org>; Sun, 02 Feb 2020 08:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k07KNJEV97nfLXEqAbM0Hcb0RDV+JoxH6UX4bIJTbVY=;
        b=RZyxv3LpwZk/CrNaaMbStkQ+6+2vJcuXWW9g8ydNf7zTE58DRsoM7lvZ5sw+0bK9LT
         fNGsghALvKMypojQ/p8nOih7MspESDdTo0ufOJm5871tBswi6JcUtXSP9ix7SQ9HwsOl
         tN5qKh3OR7x/HTBI6rdxx84HyKXWEYiQO5YLVMecvQGdBUuY99LJO2bSABUnZbyz3huV
         Qh08V7HqDN9Wfwf5lVRCtFPYDK/AA11NuldUf2gums5cBqCRNoPlU6/vhfs0deDdnowY
         +mmMuluEn1MWtfBwPYaNtLmM95On/PFm+bGjgfGIwCQUl+N4gAeE1Ele/xfXKYrXx0OH
         lJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k07KNJEV97nfLXEqAbM0Hcb0RDV+JoxH6UX4bIJTbVY=;
        b=JMoz1ulYhXa8iY/v61gYslz6bj+3h9omG9VQ8Wsqwcoxj1tu63B8xI3qrGbvl5AL6g
         eZPAzrQWV2vuda6WrEH1fuUXrjaL0uQ0kN1Do30FNXYWlPCSdEx3JXgMsSTR/csl8YVz
         O9qQ5vqgS451Ex74hX3msOZhIiMyZcgTX88V7FiR4SqrC8lBcYo5+6S1l3XrMrAq5mLB
         4RWpj4hAJxIbm8NZ45uAvZhFSJaKEWRF61+NnEIgigzBqVAIwTY2BNuLCpd+z1VXD5vH
         oXYYG1kdlJnRWuJ19id0Sat2RFr3aeBMLgt10C/WWWWySJ9aSsgoZExBhQdrPSuWO4pc
         FSfw==
X-Gm-Message-State: APjAAAW3LCxGstqvn0tPHvyTFBm91iY87tWxhRABlm0nB5dWzgVKQ6sQ
        WZZ4TncARcwmj8AGgfXRLTDSjg==
X-Google-Smtp-Source: APXvYqwg8zmZLiVS07kmWqDu36LRW47j5kCdGILKl7pkUJysvx9diYC2G1KCfsKSfycFLqHDzKz7oQ==
X-Received: by 2002:a63:6f0a:: with SMTP id k10mr21374353pgc.113.1580661296012;
        Sun, 02 Feb 2020 08:34:56 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 3sm18224550pjg.27.2020.02.02.08.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 08:34:55 -0800 (PST)
Subject: Re: io_uring force_nonblock vs POSIX_FADV_WILLNEED
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
 <fab2fcb4-9fc2-e7db-b881-80c42f21e4bf@kernel.dk>
 <20200202071435.2hqg5dtqkejpjpft@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <781ebd35-c26d-6414-7b3e-81d5cb0e8051@kernel.dk>
Date:   Sun, 2 Feb 2020 09:34:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200202071435.2hqg5dtqkejpjpft@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/20 12:14 AM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-01 09:22:45 -0700, Jens Axboe wrote:
>> On 2/1/20 2:43 AM, Andres Freund wrote:
>>> Seems like either WILLNEED would have to always be deferred, or
>>> force_page_cache_readahead, __do_page_cache_readahead would etc need to
>>> be wired up to know not to block. Including returning EAGAIN, despite
>>> force_page_cache_readahead and generic_readahead() intentially ignoring
>>> return values / errors.
>>>
>>> I guess it's also possible to just add a separate precheck that looks
>>> whether there's any IO needing to be done for the range. That could
>>> potentially also be used to make DONTNEED nonblocking in case everything
>>> is clean already, which seems like it could be nice. But that seems
>>> weird modularity wise.
>>
>> Good point, we can block on the read-ahead. Which is counter intuitive,
>> but true.
> 
>> I'll queue up the below for now, better safe than sorry.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index fb5c5b3e23f4..1464e4c9b04c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2728,8 +2728,7 @@ static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
>>  	struct io_fadvise *fa = &req->fadvise;
>>  	int ret;
>>  
>> -	/* DONTNEED may block, others _should_ not */
>> -	if (fa->advice == POSIX_FADV_DONTNEED && force_nonblock)
>> +	if (force_nonblock)
>>  		return -EAGAIN;
>>  
>>  	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
> 
> Hm, that seems a bit broad. It seems fairly safe to leave
> POSIX_FADV_{NORMAL,RANDOM,SEQUENTIAL} as sync. I guess there's there's
> the argument that that's not something one does frequently enough to
> care, but it's not hard to imagine wanting to change to RANDOM for a few
> reads and then back to NORMAL.

Yeah agree, not sure why I didn't cater to the normal cases. I'll
adjust.

-- 
Jens Axboe

