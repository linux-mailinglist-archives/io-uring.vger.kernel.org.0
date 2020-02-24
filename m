Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBD116A9F3
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgBXPWg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:22:36 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:38021 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbgBXPWg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:22:36 -0500
Received: by mail-io1-f42.google.com with SMTP id s24so10622749iog.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OJvb4fFXrDoDbppHGx81hnbUfTIepvAfuMGiTMQq4lg=;
        b=Fdducxli5hH6T/8GXFqOoFC3ymqraLYJRXLaNFq7q+X7vzqFaOvD8Q0iacdWVILEVh
         6YPsNZBLU2T10mvjlvx4ccMdDbfdXiWdMCztnDlG3aYCO1mfQ90WXS9VgIqAej7dHQ1p
         x3K+nNEtYVQ/aBKrWSId/LD2p7Yj+O2Z8JMYmyroVzxF8ZLAlVbHAG1SKAT7tha0NvJK
         eYvZKW0nsceorFNANoi/JOU87X7MeJnp/pDyB2T8bRpc0y9aI24/zvOq9OanbeRak5bD
         oU8PRZatVkTyMljQyia0N/oRaaimfbMzmKgW8PLB0bSPYVrKhrm+Yv9bFO0pKJFioUc2
         2TOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OJvb4fFXrDoDbppHGx81hnbUfTIepvAfuMGiTMQq4lg=;
        b=Xx1zLIB6KMP5xOzjotwYTBDb7Iq94PipXZpW3qIZVb6XIT6rgeNF12zmKVIIMV6Dlv
         qIDFd0fkFeUavLkIhrgXiiWMdCFQtSlEMECeH/cE9/OT9aapzJgx3tQ4/m7cmw31l9rB
         PhKK7GE1l6RmpbRiie3aQRrm6guSgOikiS2mWlPaqVmzaQO5u9c3RWcJztnI6zZuyFOX
         XIGS5aQtdRxi/UC6QduOHwS9RSE4b9yyqnzmcuNFn3Tk+d6dMZY5mo6wbpPSqPbRA1W0
         debZpDCGIVsDKHE0O9OlPez4HrQ9y/0FltCRl4kN3WVZZzYqSDiwaMv3F+iTW5qg6XEu
         PDqw==
X-Gm-Message-State: APjAAAU23SA1XGCDz6wV9tXiiDR7Q5XWAX3BK6NOsgQ4nq9ioZ2bMFXv
        vsm03Aow9sBXUbwfYj3SVqMBJSik/vQ=
X-Google-Smtp-Source: APXvYqwi0jBdVCKK7mUWNlwyAE02ERvnLs69IIVFDS0h+Y2BMqKk0Kep+c8PRkoeSqEtouCQF5tefA==
X-Received: by 2002:a6b:7215:: with SMTP id n21mr52884242ioc.131.1582557753783;
        Mon, 24 Feb 2020 07:22:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v63sm4441113ill.72.2020.02.24.07.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:22:32 -0800 (PST)
Subject: Re: Buffered IO async context overhead
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
 <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
 <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ec81eca-397e-0faa-d2c0-112732423914@kernel.dk>
Date:   Mon, 24 Feb 2020 08:22:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 2:35 AM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-14 13:49:31 -0700, Jens Axboe wrote:
>> [description of buffered write workloads being slower via io_uring
>> than plain writes]
>> Because I'm working on other items, I didn't read carefully enough. Yes
>> this won't change the situation for writes. I'll take a look at this when
>> I get time, maybe there's something we can do to improve the situation.
> 
> I looked a bit into this.
> 
> I think one issue is the spinning the workers do:
> 
> static int io_wqe_worker(void *data)
> {
> 
> 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
> 		set_current_state(TASK_INTERRUPTIBLE);
> loop:
> 		if (did_work)
> 			io_worker_spin_for_work(wqe);
> 		spin_lock_irq(&wqe->lock);
> 		if (io_wqe_run_queue(wqe)) {
> 
> static inline void io_worker_spin_for_work(struct io_wqe *wqe)
> {
> 	int i = 0;
> 
> 	while (++i < 1000) {
> 		if (io_wqe_run_queue(wqe))
> 			break;
> 		if (need_resched())
> 			break;
> 		cpu_relax();
> 	}
> }
> 
> even with the cpu_relax(), that causes quite a lot of cross socket
> traffic, slowing down the submission side. Which after all frequently
> needs to take the wqe->lock, just to be able to submit a queue
> entry.
> 
> lock, work_list, flags all reside in one cacheline, so it's pretty
> likely that a single io_wqe_enqueue would get the cacheline "stolen"
> several times during one enqueue - without allowing any progress in the
> worker, of course.

Since it's provably harmful for this case, and the gain was small (but
noticeable) on single issue cases, I think we should just kill it. With
the poll retry stuff for 5.7, there'll be even less of a need for it.

Care to send a patch for 5.6 to kill it?

> I also wonder if we can't avoid dequeuing entries one-by-one within the
> worker, at least for the IO_WQ_WORK_HASHED case. Especially when writes
> are just hitting the page cache, they're pretty fast, making it
> plausible to cause pretty bad contention on the spinlock (even without
> the spining above). Whereas the submission side is at least somewhat
> likely to be able to submit several queue entries while the worker is
> processing one job, that's pretty unlikely for workers.
> 
> In the hashed case there shouldn't be another worker processing entries
> for the same hash. So it seems quite possible for the wqe to drain a few
> of the entries for that hash within one spinlock acquisition, and then
> process them one-by-one?

Yeah, I think that'd be a good optimization for hashed work. Work N+1
can't make any progress before work N is done anyway, so might as well
grab a batch at the time.

-- 
Jens Axboe

