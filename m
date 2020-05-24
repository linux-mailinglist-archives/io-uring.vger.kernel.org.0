Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352271E0095
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgEXQas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 12:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgEXQar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 12:30:47 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5A0C08C5C0
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 09:30:46 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so6605031plt.5
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 09:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JN/e+A9ktyHXM8zsyrn02aJMxhSbMiH8/CW921mNbJc=;
        b=nmQu6o8G5J+l4W4zBcQp+jsl3Uw+smSVCJtpS5T4yTJA1GGwd8/BAGRhBqMPopGKIO
         KWVANpynxh85QYUvlV5rO8XjAPqs//u8yPnD1I5y6NTb8H3mCizC8VVC2x33wBncbGZk
         +35uSLRNn9+PyaGO4oGDCOrdUiKMq86a2LKXF1k7S24lQwLtyoiZyKxu/olMYC8dpv7D
         VW9av1A11ah7C3/YFl3fo4X6OZK/UacH6xrxHnj6V0bam5MU/qHdAOqdN2yqgwluSqMy
         sTvxfgXqVT7aUwQXOND45i9ojAn7Qpk8fDNxaZW5dQym4SPC5SFhMKop7cJ8SrmLYhLu
         TKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JN/e+A9ktyHXM8zsyrn02aJMxhSbMiH8/CW921mNbJc=;
        b=kGweHJLNQnzsoLtpTpoa1clrbRIpQ2mixIZnqElaTm+92Ol8HEHB4+n+QJO8k+QOoz
         1Ek2p4IJ3YMT2jRPSRbj11t7w0bTafHonlLBS/tdpQCCUZQHtqApVRwD2+duzaP/8nUg
         cwWU24jFo5BrVapKHpw4XbQBxhmXuODkA071+tgXTbsY3P6Fx33zL/+Z0SG6VuuVANqQ
         9mWq8tQt87gYn7mlMah71UjusFz93I7hCp5jBI2xY4MqMzWPk7E13dhdXwVKkSRORYWP
         kCrQkr1tA+K16hfGgrCJ+3S3jIGRmWPCG1aoL8yrx+Xk5A6iwCiYrJ/9v6sgrJhI1rSG
         Eahw==
X-Gm-Message-State: AOAM530Ng8VAiPF0HLkAu95l/nAHyR1VMKL8p35iOrlEEyKjJrL/S3Dw
        3UBfF+Oh8AG8NJmGd0CO5BXixg==
X-Google-Smtp-Source: ABdhPJyAnCWSpBZuHzIMhJn2QD1jU6hTg5Vw1EN325mx9Y5SVQek+j7ZmlgXjm+POf7NuknYCtKFwg==
X-Received: by 2002:a17:90a:890b:: with SMTP id u11mr5692496pjn.233.1590337844549;
        Sun, 24 May 2020 09:30:44 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:8568:4ec4:ebd3:32d1? ([2605:e000:100e:8c61:8568:4ec4:ebd3:32d1])
        by smtp.gmail.com with ESMTPSA id go1sm10608240pjb.26.2020.05.24.09.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 09:30:43 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2fa7104a-ea85-55f2-692c-514eb3b88a88@kernel.dk>
Date:   Sun, 24 May 2020 10:30:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <264614fc4fa08df2b0899da1cd38bb07150cd7f3.camel@hammerspace.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/20 8:05 AM, Trond Myklebust wrote:
> On Sat, 2020-05-23 at 12:57 -0600, Jens Axboe wrote:
>> Use the async page locking infrastructure, if IOCB_WAITQ is set in
>> the
>> passed in iocb. The caller must expect an -EIOCBQUEUED return value,
>> which means that IO is started but not done yet. This is similar to
>> how
>> O_DIRECT signals the same operation. Once the callback is received by
>> the caller for IO completion, the caller must retry the operation.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  mm/filemap.c | 33 ++++++++++++++++++++++++++-------
>>  1 file changed, 26 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index c746541b1d49..a3b86c9acdc8 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1219,6 +1219,14 @@ static int __wait_on_page_locked_async(struct
>> page *page,
>>  	return ret;
>>  }
>>  
>> +static int wait_on_page_locked_async(struct page *page,
>> +				     struct wait_page_queue *wait)
>> +{
>> +	if (!PageLocked(page))
>> +		return 0;
>> +	return __wait_on_page_locked_async(compound_head(page), wait,
>> false);
>> +}
>> +
>>  /**
>>   * put_and_wait_on_page_locked - Drop a reference and wait for it to
>> be unlocked
>>   * @page: The page to wait for.
>> @@ -2058,17 +2066,25 @@ static ssize_t
>> generic_file_buffered_read(struct kiocb *iocb,
>>  					index, last_index - index);
>>  		}
>>  		if (!PageUptodate(page)) {
>> -			if (iocb->ki_flags & IOCB_NOWAIT) {
>> -				put_page(page);
>> -				goto would_block;
>> -			}
>> -
>>  			/*
>>  			 * See comment in do_read_cache_page on why
>>  			 * wait_on_page_locked is used to avoid
>> unnecessarily
>>  			 * serialisations and why it's safe.
>>  			 */
>> -			error = wait_on_page_locked_killable(page);
>> +			if (iocb->ki_flags & IOCB_WAITQ) {
>> +				if (written) {
>> +					put_page(page);
>> +					goto out;
>> +				}
>> +				error = wait_on_page_locked_async(page,
>> +								iocb-
>>> private);
> 
> If it is being used in 'generic_file_buffered_read()' as storage for a
> wait queue, then it is hard to consider this a 'private' field.

private isn't the prettiest, and in fact this one in particular is a bit
of a mess. It's not clear if it's caller or callee owned. It's generally
not used, outside of the old usb gadget code, iomap O_DIRECT, and ocfs2.
With FMODE_BUF_RASYNC, the fs obviously can't set it if it uses
->private for buffered IO.

> Perhaps either rename and add type checking, or else add a separate
> field altogether to struct kiocb?

I'd hate to add a new field and increase the size of the kiocb... One
alternative is to do:

	union {
		void *private;
		struct wait_page_queue *ki_waitq;
	};

and still use IOCB_WAITQ to say that ->ki_waitq is valid.

There's also 4 bytes of padding in the kiocb struct. And some fields are
only used for O_DIRECT as well, eg ->ki_cookie which is just used for
polled O_DIRECT. So we could also do:

	union {
		unsigned int ki_cookie;
		struct wait_page_queue *ki_waitq;
	};

and still not grow the kiocb. How about we go with this approach, and
also add:

	if (kiocb->ki_flags & IOCB_HIPRI)
		return -EOPNOTSUPP;

to kiocb_wait_page_queue_init() to make sure that this combination isn't
valid?

-- 
Jens Axboe

