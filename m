Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6F417EA49
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 21:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgCIUlr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 16:41:47 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:35593 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUlr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 16:41:47 -0400
Received: by mail-pg1-f177.google.com with SMTP id 7so5262144pgr.2
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2020 13:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZFYNeN9E+pLhseDBgKJ/GoRs886TwtNsvECCa3IPcSs=;
        b=AxR2I2DS/l58TYQcidaajKkQ3hWNkV3JisnRG2RG/sOExlVsk3lmdOP5TFWh20nmpm
         fzqJkISnu/NHauXwm2tcudAN2LaEiHKmt2NWe4aIrLfThE+Ja/JkATL1jzOB2bVcJGw2
         KQ3Os4v1tbXGLVBeMUoh6DU4LvIncNHmcPm41Uo4TFeqgOprjUb6UlQgj6nFj+kRfctc
         5souqUe6TgTNP6TYhOc5gjzkhm0RxUjasUnclCeUBewOicYIHLhY5K9ql/7zCP6SV24z
         ubJy1I2IB5rnVCYCBm+/VrI69WZgOs3oDAMi1BZCXpvpMEFx8KLo/rH2p9tnG/QCEqfK
         mzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZFYNeN9E+pLhseDBgKJ/GoRs886TwtNsvECCa3IPcSs=;
        b=nXHmkePoFljGG5w73N63tFfuIQRl42uLrjcpMjbXerkgdefJ41bUUsPGthkfE61KU3
         TPr0CeLejwxbnHiYtcLtjh5pcVB0pulnvw3ZauMqg0/JauNlvSWj58I63yMk/fEIZKpc
         o38AhCssp4fBoEXTuZC4hr7OQFf9EoPZsDA3gA7awjEd1LGVp4gIa4el7EMNE9E59ycM
         3h2uV+12MsF7ZXlJ5stAMdJx2RC8Wfq/ahAwVvZx+0KfhJBDjBwHXdxj8TDNiI7/Sr31
         maT/Er7FxC4RQ/oFOgvL21IxBV03at0dHi9rTdTy29r4hjYef6ELGj/GqImrwyql0I9o
         o+TQ==
X-Gm-Message-State: ANhLgQ2/Bc8R9VbYRBn8uDAyhyL3Mn2gICxYGMxkTdfMKZLz5o7euW1y
        GG8lc5qm+MrVBeKSN+AGcUeGjH8m8YM=
X-Google-Smtp-Source: ADFU+vu+HXP+YSmt6ji5drlc8N74RndxSrTWoO2VD/7KDfYb7UiJXV9Q0AmFGnehesS0SbPn9NchAQ==
X-Received: by 2002:a63:f311:: with SMTP id l17mr18148551pgh.142.1583786502730;
        Mon, 09 Mar 2020 13:41:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m128sm46720324pfm.183.2020.03.09.13.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 13:41:41 -0700 (PDT)
Subject: Re: Buffered IO async context overhead
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
 <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
 <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
 <0ec81eca-397e-0faa-d2c0-112732423914@kernel.dk>
 <9a7da4de-1555-be31-1989-e33f14f1e814@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d704bbee-c50a-ab99-bed3-17a93e06ddeb@kernel.dk>
Date:   Mon, 9 Mar 2020 14:41:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9a7da4de-1555-be31-1989-e33f14f1e814@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/20 2:03 PM, Pavel Begunkov wrote:
> On 24/02/2020 18:22, Jens Axboe wrote:
>> On 2/24/20 2:35 AM, Andres Freund wrote:
>>> Hi,
>>>
>>> On 2020-02-14 13:49:31 -0700, Jens Axboe wrote:
>>>> [description of buffered write workloads being slower via io_uring
>>>> than plain writes]
>>>> Because I'm working on other items, I didn't read carefully enough. Yes
>>>> this won't change the situation for writes. I'll take a look at this when
>>>> I get time, maybe there's something we can do to improve the situation.
>>>
>>> I looked a bit into this.
>>>
>>> I think one issue is the spinning the workers do:
>>>
>>> static int io_wqe_worker(void *data)
>>> {
>>>
>>> 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
>>> 		set_current_state(TASK_INTERRUPTIBLE);
>>> loop:
>>> 		if (did_work)
>>> 			io_worker_spin_for_work(wqe);
>>> 		spin_lock_irq(&wqe->lock);
>>> 		if (io_wqe_run_queue(wqe)) {
>>>
>>> static inline void io_worker_spin_for_work(struct io_wqe *wqe)
>>> {
>>> 	int i = 0;
>>>
>>> 	while (++i < 1000) {
>>> 		if (io_wqe_run_queue(wqe))
>>> 			break;
>>> 		if (need_resched())
>>> 			break;
>>> 		cpu_relax();
>>> 	}
>>> }
>>>
>>> even with the cpu_relax(), that causes quite a lot of cross socket
>>> traffic, slowing down the submission side. Which after all frequently
>>> needs to take the wqe->lock, just to be able to submit a queue
>>> entry.
>>>
>>> lock, work_list, flags all reside in one cacheline, so it's pretty
>>> likely that a single io_wqe_enqueue would get the cacheline "stolen"
>>> several times during one enqueue - without allowing any progress in the
>>> worker, of course.
>>
>> Since it's provably harmful for this case, and the gain was small (but
>> noticeable) on single issue cases, I think we should just kill it. With
>> the poll retry stuff for 5.7, there'll be even less of a need for it.
>>
>> Care to send a patch for 5.6 to kill it?
>>
>>> I also wonder if we can't avoid dequeuing entries one-by-one within the
>>> worker, at least for the IO_WQ_WORK_HASHED case. Especially when writes
>>> are just hitting the page cache, they're pretty fast, making it
>>> plausible to cause pretty bad contention on the spinlock (even without
>>> the spining above). Whereas the submission side is at least somewhat
>>> likely to be able to submit several queue entries while the worker is
>>> processing one job, that's pretty unlikely for workers.
>>>
>>> In the hashed case there shouldn't be another worker processing entries
>>> for the same hash. So it seems quite possible for the wqe to drain a few
>>> of the entries for that hash within one spinlock acquisition, and then
>>> process them one-by-one?
>>
>> Yeah, I think that'd be a good optimization for hashed work. Work N+1
>> can't make any progress before work N is done anyway, so might as well
>> grab a batch at the time.
>>
> 
> A problem here is that we actually have a 2D array of works because of linked
> requests.

You could either skip anything with a link, or even just ignore it and
simply re-queue a dependent link if it isn't hashed when it's done if
grabbed in a batch.

> We can io_wqe_enqueue() dependant works, if have hashed requests, so delegating
> it to other threads. But if the work->list is not per-core, it will hurt
> locality. Either re-enqueue hashed ones if there is a dependant work. Need to
> think how to do better.

If we ignore links for a second, I think we can all agree that it'd be a
big win to do the batch.

With links, worst case would then be something where every other link is
hashed.

For a first patch, I'd be quite happy to just stop the batch if there's
a link on a request. The normal case here is buffered writes, and
that'll handle that case perfectly. Links will be no worse than before.
Seems like a no-brainer to me.

-- 
Jens Axboe

