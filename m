Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3B3FB5EB
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 14:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhH3MWN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 08:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbhH3MVX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 08:21:23 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DAFC061575
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 05:20:29 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j15so15831375ila.1
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 05:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=818DC2EDywxUbKC2uoAfu/iisD+DzZ+L0/94QgWLgPM=;
        b=kM9LSmbMC/nmk7y/tEIokNBOpd83m61CckmwoEV5zLNXWH3HsPQvKHEf+9cr5a4dKW
         buZUSEHBioSX9baaQ1PuRVa/jKJLeP2QvV321fYsrd0+THcZ+g4CosS1eFhKnYPRPq7v
         lZCpKRkMUeD2wtQdGyFYU54591SPmTun4gLow2qoQOV2OxRSZ/F4uPBkjnY2C563RfHK
         qbo6QslhEOxz3o9fI0glcjalwtqOZnSm4qYqKB0oBt0tvxySKDhj0qb0wShPy85H9Yop
         wzd4Xr3ztUiJXnDSgcSAjIAQozcYCvsKOoE18Ive9iS68zT8oUrlKDfH4sXKGBWbKm6P
         qTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=818DC2EDywxUbKC2uoAfu/iisD+DzZ+L0/94QgWLgPM=;
        b=LwfxZfeKx6xS5sH75EBpDzsp/T9qx2VexitiScnBw1yKYKxROlAqysrJU1ccC2kPNd
         yfvLUeTK54fVJ/Wu7SideYR5FgDmN2twJ5uY2laZ7uV7ObDVowW9JlZmnIMqLWxOhf5n
         YyXEEcCAdyQkRUGad+Amd6/6uYQI5kDBK07esltVrjQxLLC6D7GDhDqdR3WptZ98fAKP
         osf9g2CfGUZAB+Tm/nQXFsQwXWEEOVJ4h9KB3Z9NG0DfFBX4QigL9neaaDJ9qHnh5nxT
         iESgUg2sgJTOYmLGLHpoqoXiATlA4wcQUauHxjeEkMmLewmNSTYkZpSyzF/Ag88bykNE
         Ag4Q==
X-Gm-Message-State: AOAM530s9Mw3MNm+EwS26skTfZFGOQJI64FnRmsBokOQD+f+hMEgKVAG
        I70pQjq7gIlzzGgRCrNsZAq7nR8C9dO9Cg==
X-Google-Smtp-Source: ABdhPJzlsPXa1t5plJ4iMPQm9+qhq69G5+XqtnSZlOx1llYVxpq0WA6fH55exeHCziFsCFrX2U/94g==
X-Received: by 2002:a92:d586:: with SMTP id a6mr15782726iln.283.1630326028563;
        Mon, 30 Aug 2021 05:20:28 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p13sm8512680ils.69.2021.08.30.05.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 05:20:28 -0700 (PDT)
Subject: Re: [PATCH] io-wq: check max_worker limits if a worker transitions
 bound state
To:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
References: <8b32196b-0555-8179-1fa0-496b4e68ae4c@kernel.dk>
 <10bab869-3875-4510-e38a-03193f0b6dfa@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b82ce5d7-9f5b-8510-c8e4-49199a289f79@kernel.dk>
Date:   Mon, 30 Aug 2021 06:20:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <10bab869-3875-4510-e38a-03193f0b6dfa@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/29/21 9:06 PM, Hao Xu wrote:
> 在 2021/8/30 上午6:19, Jens Axboe 写道:
>> For the two places where new workers are created, we diligently check if
>> we are allowed to create a new worker. If we're currently at the limit
>> of how many workers of a given type we can have, then we don't create
>> any new ones.
>>
>> If you have a mixed workload with various types of bound and unbounded
>> work, then it can happen that a worker finishes one type of work and
>> is then transitioned to the other type. For this case, we don't check
>> if we are actually allowed to do so. This can cause io-wq to temporarily
>> exceed the allowed number of workers for a given type.
>>
>> When retrieving work, check that the types match. If they don't, check
>> if we are allowed to transition to the other type. If not, then don't
>> handle the new work.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Johannes Lundberg <johalun0@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 4b5fc621ab39..dced22288983 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -424,7 +424,31 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
>>   	spin_unlock(&wq->hash->wait.lock);
>>   }
>>   
>> -static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
>> +/*
>> + * We can always run the work if the worker is currently the same type as
>> + * the work (eg both are bound, or both are unbound). If they are not the
>> + * same, only allow it if incrementing the worker count would be allowed.
>> + */
>> +static bool io_worker_can_run_work(struct io_worker *worker,
>> +				   struct io_wq_work *work)
>> +{
>> +	struct io_wqe_acct *acct;
>> +
>> +	if ((worker->flags & IO_WORKER_F_BOUND) &&
>> +	    !(work->flags & IO_WQ_WORK_UNBOUND))
>> +		return true;
>> +	else if (!(worker->flags & IO_WORKER_F_BOUND) &&
>> +		 (work->flags & IO_WQ_WORK_UNBOUND))
>> +		return true;
> 
> How about:
> bool a = !(worker->flags & IO_WORKER_F_BOUND);
> bool b = !(work->flags & IO_WQ_WORK_UNBOUND);
> 
> if (a != b)
>      return true;

Yeah good point, I'll change it to be:

if (!(worker->flags & IO_WORKER_F_BOUND) !=                             
    !(work->flags & IO_WQ_WORK_UNBOUND))                                
         return 1;                                    

return acct->nr_workers < acct->max_workers;

-- 
Jens Axboe

