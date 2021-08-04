Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21E73E045D
	for <lists+io-uring@lfdr.de>; Wed,  4 Aug 2021 17:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbhHDPj6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Aug 2021 11:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239122AbhHDPj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Aug 2021 11:39:57 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502C2C061798
        for <io-uring@vger.kernel.org>; Wed,  4 Aug 2021 08:39:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e5so3418609pld.6
        for <io-uring@vger.kernel.org>; Wed, 04 Aug 2021 08:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YbLaP7zp/TBT+Q7+YqQffDvYzau3V52aHChBMgMbfhI=;
        b=O9WXF1x4pvMjKxlTU3T4bxsSBX432kH8pc9YOpQ6e8fQ3W9tAgW2ZNiA1vVTaqbXFR
         QrVLwLQajtIxevyUqGS8cHTvDLITW3qRbYSUy0mivce+ZTkIXQJ7K/7l8u/yb3AXzHtK
         Dz/4nJykAql2ogjXcVmhNwpd5BCVFPzYxscR80yYU6+SsvR0FeFR6hMt5fkXsofc8s94
         bTum2C5YLVtLkRQ0K/0gs8yHGMb/wBksx1/1e4ajK+y6u+dz7Q3Ie9Fq2Y+xTqm/Lt7K
         KCzI5U3NAnO/dOWFOclnYzZRyenKqZAd+YQFD/FzHfKpUwywUvto+K3b0vysaAWrinPi
         BUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YbLaP7zp/TBT+Q7+YqQffDvYzau3V52aHChBMgMbfhI=;
        b=lYkE7FlSEfR1J/UKZfSL7mBuEDzo6ojao2jPQ0wPxdu/5fzi9PUFCwyXBNYF+tQim8
         2Jji+bwg/j0+/0PpPYGCLujpdRSnHyQb7ta/jbksePeBbjxtjH4l0+HoSMcubXWoMSqr
         yIJ5r9Qo5HX/TWjnKWAHjAOgvL6n+TnSevJqk5igb4lu69in6jJHsbt5axwfDRUZZoJe
         IWSpxmWCJFFYQ1Hk7LfaTBWOS/l9aorgYSPq4dBEKQxmmsh9MFxcMmiZNqZiCjg47pcF
         rUpO+lBCrGr0qBN7QWqC8sYQ0axYnOfXurmD5e+LgY302gvJfwjLYOsvV6+4ZR9iE8F4
         IYfg==
X-Gm-Message-State: AOAM530Dz2I7FS2VUf2mdgSaAm+lq9FK4pc3JVidMlb1Q8CpJ/Z/13iT
        LRO9wk2IBJqHVLiKzSKeMuPnyQ==
X-Google-Smtp-Source: ABdhPJzJ4WJ1Q+2KzH0H51gzmk4Pg0T96RDMTv8KoFMK4qpCkO3eDRYnLJ4MvuGElG0swKVF6fN9Hg==
X-Received: by 2002:a17:902:6bc5:b029:12c:c275:ae10 with SMTP id m5-20020a1709026bc5b029012cc275ae10mr2368835plt.81.1628091584814;
        Wed, 04 Aug 2021 08:39:44 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id pi14sm6364106pjb.38.2021.08.04.08.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 08:39:44 -0700 (PDT)
Subject: Re: [PATCH] io-wq: remove GFP_ATOMIC allocation off schedule out path
To:     Daniel Wagner <dwagner@suse.de>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <a673a130-e0e4-5aa8-4165-f35d1262fc6a@kernel.dk>
 <20210804153323.anggq6oto6x7g2rs@beryllium.lan>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <230f62ec-536b-476f-c59d-347fe7826b09@kernel.dk>
Date:   Wed, 4 Aug 2021 09:39:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210804153323.anggq6oto6x7g2rs@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/4/21 9:33 AM, Daniel Wagner wrote:
> On Wed, Aug 04, 2021 at 08:43:43AM -0600, Jens Axboe wrote:
>> Daniel reports that the v5.14-rc4-rt4 kernel throws a BUG when running
>> stress-ng:
>>
>> | [   90.202543] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:35
>> | [   90.202549] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2047, name: iou-wrk-2041
>> | [   90.202555] CPU: 5 PID: 2047 Comm: iou-wrk-2041 Tainted: G        W         5.14.0-rc4-rt4+ #89
>> | [   90.202559] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
>> | [   90.202561] Call Trace:
>> | [   90.202577]  dump_stack_lvl+0x34/0x44
>> | [   90.202584]  ___might_sleep.cold+0x87/0x94
>> | [   90.202588]  rt_spin_lock+0x19/0x70
>> | [   90.202593]  ___slab_alloc+0xcb/0x7d0
>> | [   90.202598]  ? newidle_balance.constprop.0+0xf5/0x3b0
>> | [   90.202603]  ? dequeue_entity+0xc3/0x290
>> | [   90.202605]  ? io_wqe_dec_running.isra.0+0x98/0xe0
>> | [   90.202610]  ? pick_next_task_fair+0xb9/0x330
>> | [   90.202612]  ? __schedule+0x670/0x1410
>> | [   90.202615]  ? io_wqe_dec_running.isra.0+0x98/0xe0
>> | [   90.202618]  kmem_cache_alloc_trace+0x79/0x1f0
>> | [   90.202621]  io_wqe_dec_running.isra.0+0x98/0xe0
>> | [   90.202625]  io_wq_worker_sleeping+0x37/0x50
>> | [   90.202628]  schedule+0x30/0xd0
>> | [   90.202630]  schedule_timeout+0x8f/0x1a0
>> | [   90.202634]  ? __bpf_trace_tick_stop+0x10/0x10
>> | [   90.202637]  io_wqe_worker+0xfd/0x320
>> | [   90.202641]  ? finish_task_switch.isra.0+0xd3/0x290
>> | [   90.202644]  ? io_worker_handle_work+0x670/0x670
>> | [   90.202646]  ? io_worker_handle_work+0x670/0x670
>> | [   90.202649]  ret_from_fork+0x22/0x30
>>
>> which is due to the RT kernel not liking a GFP_ATOMIC allocation inside
>> a raw spinlock. Besides that not working on RT, doing any kind of
>> allocation from inside schedule() is kind of nasty and should be avoided
>> if at all possible.
>>
>> This particular path happens when an io-wq worker goes to sleep, and we
>> need a new worker to handle pending work. We currently allocate a small
>> data item to hold the information we need to create a new worker, but we
>> can instead include this data in the io_worker struct itself and just
>> protect it with a single bit lock. We only really need one per worker
>> anyway, as we will have run pending work between to sleep cycles.
>>
>> https://lore.kernel.org/lkml/20210804082418.fbibprcwtzyt5qax@beryllium.lan/
>> Reported-by: Daniel Wagner <dwagner@suse.de>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I applied this patch on top of v5.14-rc4-rt4 and with it all looks
> good.
> 
> Tested-by: Daniel Wagner <dwagner@suse.de>

Great, thanks for testing!

-- 
Jens Axboe

