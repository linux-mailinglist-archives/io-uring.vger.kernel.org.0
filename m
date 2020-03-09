Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F35617E9A8
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 21:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgCIUEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 16:04:50 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:55162 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgCIUEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 16:04:49 -0400
Received: by mail-wm1-f46.google.com with SMTP id n8so882000wmc.4
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2020 13:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6DA7aRT4iUJ0PijehcdaHob0dtk1Kmiu7U02yp85I8w=;
        b=RHm/SrAy4ylJkT+/X/PucqimFto2OU9ubQ7qfmjeT74zldK1JRsjl6Lt6kFFejZWIc
         GGoMU8kcc8Ie7GOeEkCTIdiJzU76yYJwJX1dBmIXiwtCzsGH/GlLWonpVLG3NspmxS7X
         KJseWq72IcTEtGpLKHJm5D1YT0sBou1n4pRd/lSiy2CxpKe499I2QMYArBYnKjXw/3pF
         UmSp8aNnTx5WQ64JrjO1ZOGKvYK/sOfh3lxcD1gWtZRSyo1+agLx/jWmvX3EYrfazUgV
         em4yaNDtUnoebiA9rl63i2RXh6EVE3pyM6hcvxJA0uIEXmwCH8b0coTW81QjVq//82RK
         N/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6DA7aRT4iUJ0PijehcdaHob0dtk1Kmiu7U02yp85I8w=;
        b=m1Wx+Y/dfYpkrgNmqLzMCeqgNs2OgNn7mPiWKvsF9GNQ3jkDH7Wl+rOAuHo2PdXeSF
         yNy8xCfXu56zJQT1BSPBdz3a9H+TimKrPMEs7loZbJ8T2KBs9aZqHboGWCo07BsIIK3t
         mdvKPf+06OJj9Q2JTEodb0LEo+h5IBx83+9NknAVFk3rH+SnZuRSUk+7NEhDblb4ocP+
         FZWPd1Qc73peC3uyNpqU036sNvJgIb4iiCI3uidCrHoxMg9RWJ/GPlFUn5Sk9JK3IrRz
         dZl2bUlD1Vu11ofgEoNB4ZGrDLUNOV9m0ZkToHFRpK6sy3plxVdQN7yOTnHzYnCZ14gG
         1n/w==
X-Gm-Message-State: ANhLgQ1bGynt4uUkCq7DotKgQNzTFWp/8c7UGKUAoo/5YJAkS1ZdFvje
        pHsrL/YbEnZSluE9FWaLyQrby/36
X-Google-Smtp-Source: ADFU+vsGh7zewnErfZ++KNEK/DUtGfWOyVbTjQFda6g2ScCBct5bDju6XnlHRkXU3eo4+cPQYxxa6w==
X-Received: by 2002:a7b:c218:: with SMTP id x24mr331923wmi.48.1583784286226;
        Mon, 09 Mar 2020 13:04:46 -0700 (PDT)
Received: from [192.168.43.213] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id r19sm784000wmh.26.2020.03.09.13.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 13:04:45 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
 <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
 <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
 <0ec81eca-397e-0faa-d2c0-112732423914@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Buffered IO async context overhead
Message-ID: <9a7da4de-1555-be31-1989-e33f14f1e814@gmail.com>
Date:   Mon, 9 Mar 2020 23:03:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0ec81eca-397e-0faa-d2c0-112732423914@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2020 18:22, Jens Axboe wrote:
> On 2/24/20 2:35 AM, Andres Freund wrote:
>> Hi,
>>
>> On 2020-02-14 13:49:31 -0700, Jens Axboe wrote:
>>> [description of buffered write workloads being slower via io_uring
>>> than plain writes]
>>> Because I'm working on other items, I didn't read carefully enough. Yes
>>> this won't change the situation for writes. I'll take a look at this when
>>> I get time, maybe there's something we can do to improve the situation.
>>
>> I looked a bit into this.
>>
>> I think one issue is the spinning the workers do:
>>
>> static int io_wqe_worker(void *data)
>> {
>>
>> 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
>> 		set_current_state(TASK_INTERRUPTIBLE);
>> loop:
>> 		if (did_work)
>> 			io_worker_spin_for_work(wqe);
>> 		spin_lock_irq(&wqe->lock);
>> 		if (io_wqe_run_queue(wqe)) {
>>
>> static inline void io_worker_spin_for_work(struct io_wqe *wqe)
>> {
>> 	int i = 0;
>>
>> 	while (++i < 1000) {
>> 		if (io_wqe_run_queue(wqe))
>> 			break;
>> 		if (need_resched())
>> 			break;
>> 		cpu_relax();
>> 	}
>> }
>>
>> even with the cpu_relax(), that causes quite a lot of cross socket
>> traffic, slowing down the submission side. Which after all frequently
>> needs to take the wqe->lock, just to be able to submit a queue
>> entry.
>>
>> lock, work_list, flags all reside in one cacheline, so it's pretty
>> likely that a single io_wqe_enqueue would get the cacheline "stolen"
>> several times during one enqueue - without allowing any progress in the
>> worker, of course.
> 
> Since it's provably harmful for this case, and the gain was small (but
> noticeable) on single issue cases, I think we should just kill it. With
> the poll retry stuff for 5.7, there'll be even less of a need for it.
> 
> Care to send a patch for 5.6 to kill it?
> 
>> I also wonder if we can't avoid dequeuing entries one-by-one within the
>> worker, at least for the IO_WQ_WORK_HASHED case. Especially when writes
>> are just hitting the page cache, they're pretty fast, making it
>> plausible to cause pretty bad contention on the spinlock (even without
>> the spining above). Whereas the submission side is at least somewhat
>> likely to be able to submit several queue entries while the worker is
>> processing one job, that's pretty unlikely for workers.
>>
>> In the hashed case there shouldn't be another worker processing entries
>> for the same hash. So it seems quite possible for the wqe to drain a few
>> of the entries for that hash within one spinlock acquisition, and then
>> process them one-by-one?
> 
> Yeah, I think that'd be a good optimization for hashed work. Work N+1
> can't make any progress before work N is done anyway, so might as well
> grab a batch at the time.
> 

A problem here is that we actually have a 2D array of works because of linked
requests.

We can io_wqe_enqueue() dependant works, if have hashed requests, so delegating
it to other threads. But if the work->list is not per-core, it will hurt
locality. Either re-enqueue hashed ones if there is a dependant work. Need to
think how to do better.

-- 
Pavel Begunkov
