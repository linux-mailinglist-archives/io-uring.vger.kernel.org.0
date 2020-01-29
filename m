Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE9214C3DB
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 01:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgA2AP6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 19:15:58 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42215 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgA2AP6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 19:15:58 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so7879880pgb.9
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 16:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vDKFfja0wxVkVE5aEmaSO6knkPbzXG2aeupL1b7P3Hw=;
        b=hMPFNoQC6fgFbkL6yE4wHcvc/AlkbTSNtThg9rr+VUU8BMYHp36tXE/LZO2J0nkBLg
         orP6W8HhWhAGWeofWhMy8W5y3FC+VhGV7WzP6+okE5fPosRCXhHRdDKSGjuHVv80b9mn
         nNObb8NVaVqofWTmf89xKlgq8lpalkN6T7izeOCDnzBL1zb7GnZMsDmrhDmtU8Z1MXcG
         /hgKjLiF/n21EIwjkV7MfswL0mYguP7pxusZ6yPFy9RIwFvsydUhqG0chXz3xypJGSYZ
         b+LUy3DEnhisjyRR7cVWxax2gaJKegmKqrB2Zz0Q7rLciDOfYj4ZE2EMpwWzgfyqXJ8L
         yrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vDKFfja0wxVkVE5aEmaSO6knkPbzXG2aeupL1b7P3Hw=;
        b=MOes5z7GHH6TE5EMDOdAQNbayqlZ7u4UHo1cYJvVUgSMSLiQaBRiCfnroLINVwX7sr
         2eVGPA8NfBI04a5AjZitH1oYlW9Pw9uEk/LZp128eBC06romzM+c+hvbSC2UJSzyOv+B
         sHRYkYOUShEN28Z8WVCPxQFxT5ZtVF0WHQ+mPG4SM9SHsREkXrEfHISBmAYjFbqZq1en
         Q5zjgoqxzAHeAm6d9rN4iiNgv+HuuV/O3UdySJRS7dXhC1q7l8yCa6ENtfjoNwe+5RDF
         PBYj51rz5UyJ0fZF4VyO3ijTBWzDY6MlzoIhov3m8Ds8BO9xPDCiKIpb6eY4Mu2qeNYi
         q48w==
X-Gm-Message-State: APjAAAV6/gw8tF3sYwQZMip4BYif74rgoPUxvLNWg/7jckN9PfHrqKfZ
        8NuyuoiRQLkAtvZKw6eRq+l2B4yqPbY=
X-Google-Smtp-Source: APXvYqw6bRBoOK+t4L9i4oAyGpbiPxWhFzYCp/L6BdeUzU8QpDCvV+AiL59lDG0l3fmq6psry078IA==
X-Received: by 2002:aa7:957c:: with SMTP id x28mr6518207pfq.157.1580256957216;
        Tue, 28 Jan 2020 16:15:57 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u18sm236887pgn.9.2020.01.28.16.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 16:15:56 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6415ae98-e205-5374-296d-0442e1ed2034@kernel.dk>
Date:   Tue, 28 Jan 2020 17:15:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 5:10 PM, Pavel Begunkov wrote:
> On 29/01/2020 02:51, Jens Axboe wrote:
>> On 1/28/20 4:40 PM, Jens Axboe wrote:
>>> On 1/28/20 4:36 PM, Pavel Begunkov wrote:
>>>> On 28/01/2020 22:42, Jens Axboe wrote:
>>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>>> implementation and use. And the fact that we'd have to jump through
>>>>> hoops to make this work for a full chain.
>>>>>
>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>>> This makes it way easier to use. Same branch:
>>>>>
>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>
>>>>> I'd feel much better with this variant for 5.6.
>>>>>
>>>>
>>>> Checked out ("don't use static creds/mm assignments")
>>>>
>>>> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
>>>> request, but if (worker->creds != work->creds) it will never be put.
>>>
>>> Yeah I think you're right, that needs a bit of fixing up.
>>
> 
> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
> override_creds().
> 
>> I think this may have gotten fixed with the later addition posted today?
>> I'll double check. But for the newer stuff, we put it for both cases
>> when the request is freed.
> 
> Yeah, maybe. I got tangled trying to verify both at once and decided to start
> with the old one.
> 
> 
>>>> 2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set as
>>>>
>>>>     worker->creds = override_creds(work->creds);
>>>>
>>>> Where override_creds() returns previous creds. And if so, then the following
>>>> fast check looks strange:
>>>>
>>>>     worker->creds != work->creds
>>>
>>> Don't care too much about the naming, but the logic does appear off.
>>> I'll take a look at both of these tonight, unless you beat me to it.
> 
> Apparently, you're faster :)
> 
>>
>> Testing this now, what a braino.
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index ee49e8852d39..8fbbadf04cc3 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -56,7 +56,8 @@ struct io_worker {
>>  
>>  	struct rcu_head rcu;
>>  	struct mm_struct *mm;
>> -	const struct cred *creds;
>> +	const struct cred *cur_creds;
>> +	const struct cred *saved_creds;
>>  	struct files_struct *restore_files;
>>  };
>>  
>> @@ -135,9 +136,9 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
>>  {
>>  	bool dropped_lock = false;
>>  
>> -	if (worker->creds) {
>> -		revert_creds(worker->creds);
>> -		worker->creds = NULL;
>> +	if (worker->saved_creds) {
>> +		revert_creds(worker->saved_creds);
>> +		worker->cur_creds = worker->saved_creds = NULL;
>>  	}
>>  
>>  	if (current->files != worker->restore_files) {
>> @@ -424,10 +425,11 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
>>  static void io_wq_switch_creds(struct io_worker *worker,
>>  			       struct io_wq_work *work)
>>  {
>> -	if (worker->creds)
>> -		revert_creds(worker->creds);
>> +	if (worker->saved_creds)
>> +		revert_creds(worker->saved_creds);
>>  
>> -	worker->creds = override_creds(work->creds);
>> +	worker->saved_creds = override_creds(work->creds);
>> +	worker->cur_creds = work->creds;
>>  }
> 
> How about as follows? rever_creds() is a bit heavier than put_creds().
> 
> static void io_wq_switch_creds(struct io_worker *worker,
> 			       struct io_wq_work *work)
> {
> 	const struct cred *old_creds = override_creds(work->creds);
> 
> 	if (worker->saved_creds)
> 		put_cred(old_creds);
> 	else
> 		worker->saved_creds = old;
> 	worker->cur_creds = work->creds;
> }

Looks good to me, I'll fold.

-- 
Jens Axboe

