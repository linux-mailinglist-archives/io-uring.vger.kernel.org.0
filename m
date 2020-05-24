Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B227E1E00DE
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 19:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgEXRMu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 13:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbgEXRMu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 13:12:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E431CC061A0E
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 10:12:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 145so7836416pfw.13
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 10:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xZU7YPutzDudiXDbOu5V9kxMpNCAHn/94lq+JvMMNGA=;
        b=s3WWLmhIBDzWHUwLoFqnGK0yBXoTyqmTZJLgIGqlAUxRBDhAfMZwdqyk3Zsnnu9fd4
         /5MP0Rk6jT0nU3BIeuywIlcoU4UapexFBY2evnBLVr6MuE4WSrNOId3FsiIxNN2884TZ
         8cVqh9J2/L0anXIafBCS19mEzqQY0MNNZG4nC3xBMnNe2cL+hKfCZj0ZUQ1ZQYf1Hh2i
         a9NAdULi4EXWgYSZNJyq7QBcVUwieQ2Z6kaqOQwaALR+KGYwiqxNlHNskqNol2GHI3k5
         TSJnrBRuVtNuQHmw4zsag6UaCs5IKIQw5KqubNpAGDm3HkiTeIuOvY/nWCrbAZoVM4bR
         wxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xZU7YPutzDudiXDbOu5V9kxMpNCAHn/94lq+JvMMNGA=;
        b=A3qnIftDMttJxCqjrMbeS97PUEun8uoEPRV4Db+20Iwp85eJaiEV1ckNUIjkXVv6Yk
         0POHpe8Hq1HeRYu8v7C/AS4bZEFSsL5pp2Y/N2kCdtdo5gXxebIwnWlgJJktLQd/Z+P9
         sItMyNWPY7TJm00WSaz5kCp37uC19/EzZ6mQGu2UJItFRYod5NouPYN8u3M70tqqIJ5+
         cYzCgkd3owoJzY9sCY44IOYOwhdEb25YoXO/xltWYi83fOYgE5mIWOYUPJWITT96eMtp
         Ep/loYLsNFLRuWRq4nQLpH/nxXj5iKCD+SUppO6p6rL3zbXqdzcOlmdjYljs1ClEiLK2
         8L+A==
X-Gm-Message-State: AOAM533hHkALYuBAfdEnZ/eJvRnLI4/Z98wJnBaRBgK3W8sheN5oP4Ib
        JQyBj+aCfl9da9pAbYxEVW+sJQ==
X-Google-Smtp-Source: ABdhPJx1hYsYfmrHIeoHeg4igltIqYp5/GAPkHjzFc90UY6cZ10XBXydydpLQ0MN+xx00db6ker7Hg==
X-Received: by 2002:a05:6a00:46:: with SMTP id i6mr13904666pfk.146.1590340369238;
        Sun, 24 May 2020 10:12:49 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:8568:4ec4:ebd3:32d1? ([2605:e000:100e:8c61:8568:4ec4:ebd3:32d1])
        by smtp.gmail.com with ESMTPSA id r21sm10949605pjo.2.2020.05.24.10.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 10:12:48 -0700 (PDT)
Subject: Re: [PATCH 05/12] mm: support async buffered reads in
 generic_file_buffered_read()
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200523185755.8494-1-axboe@kernel.dk>
 <20200523185755.8494-6-axboe@kernel.dk>
 <264614fc4fa08df2b0899da1cd38bb07150cd7f3.camel@hammerspace.com>
 <2fa7104a-ea85-55f2-692c-514eb3b88a88@kernel.dk>
 <dca84a29-99dc-c9f0-7758-e47fc4d6fbc4@kernel.dk>
 <f1fd056deb6d623956c356abb49264278aa71be4.camel@hammerspace.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <476e123f-0269-5e88-5318-de9a63f13048@kernel.dk>
Date:   Sun, 24 May 2020 11:12:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f1fd056deb6d623956c356abb49264278aa71be4.camel@hammerspace.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/20 11:11 AM, Trond Myklebust wrote:
> On Sun, 2020-05-24 at 10:40 -0600, Jens Axboe wrote:
>> On 5/24/20 10:30 AM, Jens Axboe wrote:
>>> On 5/24/20 8:05 AM, Trond Myklebust wrote:
>>>> On Sat, 2020-05-23 at 12:57 -0600, Jens Axboe wrote:
>>>>> Use the async page locking infrastructure, if IOCB_WAITQ is set
>>>>> in
>>>>> the
>>>>> passed in iocb. The caller must expect an -EIOCBQUEUED return
>>>>> value,
>>>>> which means that IO is started but not done yet. This is
>>>>> similar to
>>>>> how
>>>>> O_DIRECT signals the same operation. Once the callback is
>>>>> received by
>>>>> the caller for IO completion, the caller must retry the
>>>>> operation.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>  mm/filemap.c | 33 ++++++++++++++++++++++++++-------
>>>>>  1 file changed, 26 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>>> index c746541b1d49..a3b86c9acdc8 100644
>>>>> --- a/mm/filemap.c
>>>>> +++ b/mm/filemap.c
>>>>> @@ -1219,6 +1219,14 @@ static int
>>>>> __wait_on_page_locked_async(struct
>>>>> page *page,
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> +static int wait_on_page_locked_async(struct page *page,
>>>>> +				     struct wait_page_queue
>>>>> *wait)
>>>>> +{
>>>>> +	if (!PageLocked(page))
>>>>> +		return 0;
>>>>> +	return __wait_on_page_locked_async(compound_head(page),
>>>>> wait,
>>>>> false);
>>>>> +}
>>>>> +
>>>>>  /**
>>>>>   * put_and_wait_on_page_locked - Drop a reference and wait for
>>>>> it to
>>>>> be unlocked
>>>>>   * @page: The page to wait for.
>>>>> @@ -2058,17 +2066,25 @@ static ssize_t
>>>>> generic_file_buffered_read(struct kiocb *iocb,
>>>>>  					index, last_index -
>>>>> index);
>>>>>  		}
>>>>>  		if (!PageUptodate(page)) {
>>>>> -			if (iocb->ki_flags & IOCB_NOWAIT) {
>>>>> -				put_page(page);
>>>>> -				goto would_block;
>>>>> -			}
>>>>> -
>>>>>  			/*
>>>>>  			 * See comment in do_read_cache_page on
>>>>> why
>>>>>  			 * wait_on_page_locked is used to avoid
>>>>> unnecessarily
>>>>>  			 * serialisations and why it's safe.
>>>>>  			 */
>>>>> -			error =
>>>>> wait_on_page_locked_killable(page);
>>>>> +			if (iocb->ki_flags & IOCB_WAITQ) {
>>>>> +				if (written) {
>>>>> +					put_page(page);
>>>>> +					goto out;
>>>>> +				}
>>>>> +				error =
>>>>> wait_on_page_locked_async(page,
>>>>> +								
>>>>> iocb-
>>>>>> private);
>>>>
>>>> If it is being used in 'generic_file_buffered_read()' as storage
>>>> for a
>>>> wait queue, then it is hard to consider this a 'private' field.
>>>
>>> private isn't the prettiest, and in fact this one in particular is
>>> a bit
>>> of a mess. It's not clear if it's caller or callee owned. It's
>>> generally
>>> not used, outside of the old usb gadget code, iomap O_DIRECT, and
>>> ocfs2.
>>> With FMODE_BUF_RASYNC, the fs obviously can't set it if it uses
>>> ->private for buffered IO.
>>>
>>>> Perhaps either rename and add type checking, or else add a
>>>> separate
>>>> field altogether to struct kiocb?
>>>
>>> I'd hate to add a new field and increase the size of the kiocb...
>>> One
>>> alternative is to do:
>>>
>>> 	union {
>>> 		void *private;
>>> 		struct wait_page_queue *ki_waitq;
>>> 	};
>>>
>>> and still use IOCB_WAITQ to say that ->ki_waitq is valid.
>>>
>>> There's also 4 bytes of padding in the kiocb struct. And some
>>> fields are
>>> only used for O_DIRECT as well, eg ->ki_cookie which is just used
>>> for
>>> polled O_DIRECT. So we could also do:
>>>
>>> 	union {
>>> 		unsigned int ki_cookie;
>>> 		struct wait_page_queue *ki_waitq;
>>> 	};
>>>
>>> and still not grow the kiocb. How about we go with this approach,
>>> and
>>> also add:
>>>
>>> 	if (kiocb->ki_flags & IOCB_HIPRI)
>>> 		return -EOPNOTSUPP;
>>>
>>> to kiocb_wait_page_queue_init() to make sure that this combination
>>> isn't
>>> valid?
>>
>> Here's the incremental, which is spread over 3 patches. I think this
>> one
>> makes sense, as polled IO doesn't support buffered IO. And because
>> doing
>> an async callback for completion is not how polled IO operates
>> anyway,
>> so even if buffered IO supported it, we'd not use the callback for
>> polled IO anyway. kiocb_wait_page_queue_init() checks and backs this
>> up.
>>
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 0ef5f5973b1c..f7b1eb765c6e 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -317,7 +317,7 @@ enum rw_hint {
>>  #define IOCB_SYNC		(1 << 5)
>>  #define IOCB_WRITE		(1 << 6)
>>  #define IOCB_NOWAIT		(1 << 7)
>> -/* iocb->private holds wait_page_async struct */
>> +/* iocb->ki_waitq is valid */
>>  #define IOCB_WAITQ		(1 << 8)
>>  
>>  struct kiocb {
>> @@ -332,7 +332,10 @@ struct kiocb {
>>  	int			ki_flags;
>>  	u16			ki_hint;
>>  	u16			ki_ioprio; /* See linux/ioprio.h */
>> -	unsigned int		ki_cookie; /* for ->iopoll */
>> +	union {
>> +		unsigned int		ki_cookie; /* for ->iopoll */
>> +		struct wait_page_queue	*ki_waitq; /* for async
>> buffered IO */
>> +	};
>>  
>>  	randomized_struct_fields_end
>>  };
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index def58de92053..8b65420410ee 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -498,13 +498,16 @@ static inline int
>> kiocb_wait_page_queue_init(struct kiocb *kiocb,
>>  					     wait_queue_func_t func,
>>  					     void *data)
>>  {
>> +	/* Can't support async wakeup with polled IO */
>> +	if (kiocb->ki_flags & IOCB_HIPRI)
>> +		return -EINVAL;
>>  	if (kiocb->ki_filp->f_mode & FMODE_BUF_RASYNC) {
>>  		wait->wait.func = func;
>>  		wait->wait.private = data;
>>  		wait->wait.flags = 0;
>>  		INIT_LIST_HEAD(&wait->wait.entry);
>>  		kiocb->ki_flags |= IOCB_WAITQ;
>> -		kiocb->private = wait;
>> +		kiocb->ki_waitq = wait;
>>  		return 0;
>>  	}
>>  
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index a3b86c9acdc8..18022de7dc33 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -2077,7 +2077,7 @@ static ssize_t
>> generic_file_buffered_read(struct kiocb *iocb,
>>  					goto out;
>>  				}
>>  				error = wait_on_page_locked_async(page,
>> -								iocb-
>>> private);
>> +								iocb-
>>> ki_waitq);
>>  			} else {
>>  				if (iocb->ki_flags & IOCB_NOWAIT) {
>>  					put_page(page);
>> @@ -2173,7 +2173,7 @@ static ssize_t
>> generic_file_buffered_read(struct kiocb *iocb,
>>  page_not_up_to_date:
>>  		/* Get exclusive access to the page ... */
>>  		if (iocb->ki_flags & IOCB_WAITQ)
>> -			error = lock_page_async(page, iocb->private);
>> +			error = lock_page_async(page, iocb->ki_waitq);
>>  		else
>>  			error = lock_page_killable(page);
>>  		if (unlikely(error))
> 
> Ack. That seems cleaner to me.

I agree, this is better. Ran it through the testing and updated the
series accordingly:

https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.4

-- 
Jens Axboe

