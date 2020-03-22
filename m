Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF018EAA7
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 18:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgCVRIl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 13:08:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33208 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgCVRIl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 13:08:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id g18so4848894plq.0
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 10:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JFvPSOdaR2IQKGP5VbQxSsbE7AnWm5jNOZJ2cbeMHCs=;
        b=SDKjjmSS7c/tLzsodl1dbC8sNX3LgsNkhgEYX4tkRqIbMXx0drkmpljE6RoejsyTDH
         6Ab56stzKxG4WElveVE3gJJxRntRo1OR+eruGeuh8nmRT7RRBcP7VnWJaInYnpx8WDSz
         jQw8Vvd9ouAwFiHw/ycipdKINwXd2ydnYJSMAz//Rug1rviMSjVP5+PUu3l7wl1Os++s
         SKcY19Cx0R2Gszl7+KLL/IOuCrLiHYEUDFKzf+4Gg7zDSmphKv/L8mF0Fnmawe2KKkIf
         B9/uWcYFdCZaknLs1n4U/l94DWMpYVv6jfukRpd/Qru4zPsgjy2PHHpR32Tbx0Y8Hhs6
         MqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JFvPSOdaR2IQKGP5VbQxSsbE7AnWm5jNOZJ2cbeMHCs=;
        b=oTMI6OUH8uK6xSt6MXDDYubjgk2NJa6B+zi1QFuOsJ1YwZFd8YCKX64QjPeJ3ZXR1b
         b+ZKtQe6H3ANAjHMSGTn1q4jmroVR3UKdnfOwoKTgvZJrDBP1dG4dkWYmG171lGdigIr
         eokrGgNu+tzrAEAcpTvmvYIOtSjEaatkfJ8Z2ij/76h1tVIdtMYObesezxuYryBZm5uO
         XB5Fcb4FkgMcSozTk7lYy39KFJOLK7NZ2C3w1nrVX68GeNFsWzwtp1UJSBFWhJDSYMi8
         +YD0N+qySYOgmW5OTxfZbZJMXdMB+N5eqURRf4nYR9sjTwNftS2dLMVLuNubRtfDFg+d
         FTow==
X-Gm-Message-State: ANhLgQ2CtWYBBE46CsDGJfFg0OsTt1su7NSOx5LWs+HbXiV8BSetM2Xb
        74pCnMpsKLk4lqKxcnvuWjg3BuHVxtxEBQ==
X-Google-Smtp-Source: ADFU+vvKpktMllO2VRUvOVtEOFKZWGal6A6zgRWnj0P4Fhti6+1oT3drQeBQ/IHAklWNa6dNrkpJxA==
X-Received: by 2002:a17:90a:aa0c:: with SMTP id k12mr21196730pjq.193.1584896917833;
        Sun, 22 Mar 2020 10:08:37 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm11162397pfb.36.2020.03.22.10.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 10:08:37 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1c0d0978-0824-b896-d100-e0b7664ba81a@kernel.dk>
Date:   Sun, 22 Mar 2020 11:08:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 10:09 AM, Pavel Begunkov wrote:
>>  		/* not hashed, can run anytime */
>>  		if (!io_wq_is_hashed(work)) {
>> -			wq_node_del(&wqe->work_list, node, prev);
>> -			return work;
>> +			/* already have hashed work, let new worker get this */
>> +			if (ret) {
>> +				struct io_wqe_acct *acct;
>> +
>> +				/* get new worker for unhashed, if none now */
>> +				acct = io_work_get_acct(wqe, work);
>> +				if (!atomic_read(&acct->nr_running))
>> +					io_wqe_wake_worker(wqe, acct);
>> +				break;
>> +			}
>> +			wq_node_del(&wqe->work_list, &work->list);
>> +			ret = work;
>> +			break;
>>  		}
>>  
>>  		/* hashed, can run if not already running */
>> -		hash = io_get_work_hash(work);
>> -		if (!(wqe->hash_map & BIT(hash))) {
>> +		new_hash = io_get_work_hash(work);
>> +		if (wqe->hash_map & BIT(new_hash))
>> +			break;
> 
> This will always break for subsequent hashed, as the @hash_map bit is set.
> Isn't it? And anyway, it seems it doesn't optimise not-contiguous same-hashed
> requests, e.g.
> 
> 0: Link(hash=0)
> 1: Link(hash=1)
> 2: Link(hash=0)
> 3: Link(not_hashed)
> 4: Link(hash=0)
> ...

Yeah, I think I shuffled a bit too much there, should only break on that
if hash != new_hash. Will fix!

>> @@ -530,6 +565,24 @@ static void io_worker_handle_work(struct io_worker *worker)
>>  				work = NULL;
>>  			}
>>  			if (hash != -1U) {
>> +				/*
>> +				 * If the local list is non-empty, then we
>> +				 * have work that hashed to the same key.
>> +				 * No need for a lock round-trip, or fiddling
>> +				 * the the free/busy state of the worker, or
>> +				 * clearing the hashed state. Just process the
>> +				 * next one.
>> +				 */
>> +				if (!work) {
>> +					work = wq_first_entry(&list,
>> +							      struct io_wq_work,
>> +							      list);
> 
> Wouldn't it just drop a linked request? Probably works because of the
> comment above.

Only drops if if we always override 'work', if it's already set we use
'work' and don't grab from the list. So that should work for links.

>> +					if (work) {
>> +						wq_node_del(&list, &work->list);
> 
> There is a bug, apparently from one of my commits, where it do
> io_assign_current_work() but then re-enqueue and reassign new work,
> though there is a gap for cancel to happen, which would screw
> everything up.
> 
> I'll send a patch, so it'd be more clear. However, this is a good
> point to look after for this as well.

Saw it, I'll apply when you have the Fixes line. I'll respin this one
after.

-- 
Jens Axboe

