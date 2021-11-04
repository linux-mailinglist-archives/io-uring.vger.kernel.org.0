Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9EB4455C2
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 15:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKDO7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Nov 2021 10:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhKDO7w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Nov 2021 10:59:52 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E280C061714
        for <io-uring@vger.kernel.org>; Thu,  4 Nov 2021 07:57:14 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id bk26so8377218oib.11
        for <io-uring@vger.kernel.org>; Thu, 04 Nov 2021 07:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e5aDcQqoN+TmTOIKa8Bzk1Bexe+fx0B7R8UqAlQsBNs=;
        b=pUEnJpGqOH3BoVsp3T3ulsaEVgGOuzO2VR99qm0S/wOpVSsIWzsq78YZe+YhygV3Nh
         /jMKADCdkv3IuKlzzEACyPJHbItdxQJzwdktxXuew7iE7rMHXZ1zBcqsQ4eegTMAN02Y
         /9s86OoWtmSiiyAfvNDmY8YDrIBZPO3SfdClbm3/RoAiYsFd4gS1b9CHaXSB6H2BTVY2
         /azqfwd9Oiga8ahGgGw5y8bfwXxISupspLsFQf6sUtk4ULFNk4YzgPbpIC4C/1HPsIbd
         GFdVQVxLdAlUkZdF8/tclxnC2M+kGdH/BY7yyqjLsudTyps4QTPoE1+4CnYx8faEV785
         gpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e5aDcQqoN+TmTOIKa8Bzk1Bexe+fx0B7R8UqAlQsBNs=;
        b=2WfVx7w/uhhbfBDG3+3HswPKR9QGD2Z74qsHu/xp/Opfyip/rGlvN4z/rsjtBmApNv
         32JLwl5RW4sCOE7PhMrFPr8eKGJ/bwovk1d599WeRlzVPXOlnvCBnwc7aWG9c1R/l0Nb
         H5ilg/TJDeavkixkek0o9+NWO2wg8OjbQXftiXkV4UB0pD1Ze444EgxlXuz77u53/x51
         67XFyRJsNmvSynI9Pw+YosaBbqISGnFTa5E0E9vrT/N3SUy0P47BfO2s04g2jv/m/yas
         TsnW/L/Z5YjIRQjTgl/X5afEbuBztZMs3u6o5t0lk1Cu+zkEqN75bfYe96HoJhI5HSZH
         sM3g==
X-Gm-Message-State: AOAM533PsR6UuwOnHjAVZ/W1d9aChKGN2eKsxh4yPV1dvnIgpxZ05P27
        cBGbKi50zgER7CGldghGE9h+04ENBs9YyA==
X-Google-Smtp-Source: ABdhPJw3rIh1RfkT8Obmc2LAEW3UhJBWq37a1u+Jmzs/honpQ1RPQGuXfs44eP0er8UmM7ATO/px0A==
X-Received: by 2002:a05:6808:20a6:: with SMTP id s38mr12360491oiw.152.1636037833850;
        Thu, 04 Nov 2021 07:57:13 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x28sm1521278ote.24.2021.11.04.07.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 07:57:13 -0700 (PDT)
Subject: Re: [RFC] io-wq: decouple work_list protection from the big wqe->lock
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211031104945.224024-1-haoxu@linux.alibaba.com>
 <df8a6142-73f5-32e1-6ffd-7de1093abab9@kernel.dk>
 <b77a69a7-5637-0d20-bbf1-d8d2936fdd16@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8adbf2d-1bb5-8864-759d-98bedcd5ef5e@kernel.dk>
Date:   Thu, 4 Nov 2021 08:57:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b77a69a7-5637-0d20-bbf1-d8d2936fdd16@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/21 5:35 AM, Hao Xu wrote:
> 在 2021/11/4 上午3:10, Jens Axboe 写道:
>> On 10/31/21 4:49 AM, Hao Xu wrote:
>>> @@ -380,10 +382,14 @@ static void io_wqe_dec_running(struct io_worker *worker)
>>>   	if (!(worker->flags & IO_WORKER_F_UP))
>>>   		return;
>>>   
>>> +	raw_spin_lock(&acct->lock);
>>>   	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
>>> +		raw_spin_unlock(&acct->lock);
>>>   		atomic_inc(&acct->nr_running);
>>>   		atomic_inc(&wqe->wq->worker_refs);
>>>   		io_queue_worker_create(worker, acct, create_worker_cb);
>>> +	} else {
>>> +		raw_spin_unlock(&acct->lock);
>>>   	}
>>>   }
>>
>> I think this may be more readable as:
>>
>> static void io_wqe_dec_running(struct io_worker *worker)
>> 	__must_hold(wqe->lock)
>> {
>> 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>> 	struct io_wqe *wqe = worker->wqe;
>>
>> 	if (!(worker->flags & IO_WORKER_F_UP))
>> 		return;
>> 	if (!atomic_dec_and_test(&acct->nr_running))
>> 		return;
>>
>> 	raw_spin_lock(&acct->lock);
>> 	if (!io_acct_run_queue(acct)) {
>> 		raw_spin_unlock(&acct->lock);
>> 		return;
>> 	}
>>
>> 	raw_spin_unlock(&acct->lock);
>> 	atomic_inc(&acct->nr_running);
>> 	atomic_inc(&wqe->wq->worker_refs);
>> 	io_queue_worker_create(worker, acct, create_worker_cb);
>> }
>>
>> ?
>>
>> Patch looks pretty sane to me, but there's a lot of lock shuffling going
>> on for it. Like in io_worker_handle_work(), and particularly in
>> io_worker_handle_work(). I think it'd be worthwhile to spend some time
>> to see if that could be improved. These days, lock contention is more
>> about frequency of lock grabbing rather than hold time. Maybe clean
>> nesting of wqe->lock -> acct->lock (which would be natural) can help
>> that?
> Sure, I'm working on reduce the lock contension further, will
> update it and send the whole patchset later.

Sounds good, thanks!

-- 
Jens Axboe

