Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994642C89AE
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 17:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgK3Qie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 11:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgK3Qid (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 11:38:33 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5E5C0613CF;
        Mon, 30 Nov 2020 08:37:47 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id t4so16993796wrr.12;
        Mon, 30 Nov 2020 08:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bqCl3pNxQfGkCheWTUU/M9zYVOavXCHJsfOfwygnvYY=;
        b=lrmKlJFyJVL8I6EqdgzNoIdInjuR4dCMHi5p0DGc+d9uo+6isIYNWMgYl1Lzzg2fNU
         hxuzqUSTy81KMIzkk9zFc94N8d9dAbUAakY443ApDB2eLISm7fLvTS6rAYf3OmKmyRQF
         n6SSBXYl36B1SpZOiaebcY6bl0TwCbgbpAmTEQezNaP7zyq22buY5/DOlgZ9hLrnWm4G
         Xy3nmPCn9dAuwvJ6/392Yus1iAyBdX1LJri7fZ2Nsok86wm2mt+SZtDy3PQcBbdWdJCZ
         NAeXTsYjqi281BirEceshPk+uDTmOJB4Gk+2GudpYL9LkyqytV7jQcqoZn8P4UY1d2yq
         MOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bqCl3pNxQfGkCheWTUU/M9zYVOavXCHJsfOfwygnvYY=;
        b=HOWoE2rx5GwRLaWCE6YEoMKwFdIIsJEn9IhlM74hYAKdaFYeIexq1ik2FA8fwXb0hI
         A51++norfxk+ksJpdwmb9V0j/BkFAraK/cIUENugYclRMpH65C0ESjdW9M0tAsGkdbsY
         osuIzmARMwfytbe4nuhhb2ZiZXtBIS8S1ej/UlXBW23JAlNflXqKDlEvMspndQmXn2DF
         EHeGK0Z2cabJILYLFIZVH3icbAHsIILYoQDk50XjSRPZluMx6aOnBlLTR7StKxoPHSqQ
         0mFDGyJQl0sj3E8M191e05eo43ip4/d26homWhMjvTbjYYlXLta1Uq7sXRA4xeVVObjp
         3cWg==
X-Gm-Message-State: AOAM532hQrX1Upa75iP4RUy7nv9g8bJr37/EIgylVKbhXmGT1xo0NWYX
        FK92WnG6LUHBpPZ8sg8AxieBonOvGNzYeA==
X-Google-Smtp-Source: ABdhPJz3ev+EOPr2reiFmLDsJp60f9ioQWrFNw6FTBvcXI/D6xfd8Pl/iTN2fu/6doRi76GlvBT1CA==
X-Received: by 2002:adf:b310:: with SMTP id j16mr29170533wrd.293.1606754265612;
        Mon, 30 Nov 2020 08:37:45 -0800 (PST)
Received: from [192.168.1.14] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id u26sm5926813wmm.24.2020.11.30.08.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 08:37:45 -0800 (PST)
Subject: Re: [PATCH kernel] fs/io_ring: Fix lockdep warnings
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, io-uring@vger.kernel.org
Cc:     lexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201130020028.106198-1-aik@ozlabs.ru>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <44057e4a-9dd0-ddfa-70fd-8f6287de4e2d@gmail.com>
Date:   Mon, 30 Nov 2020 16:34:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201130020028.106198-1-aik@ozlabs.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/11/2020 02:00, Alexey Kardashevskiy wrote:
> There are a few potential deadlocks reported by lockdep and triggered by
> syzkaller (a syscall fuzzer). These are reported as timer interrupts can
> execute softirq handlers and if we were executing certain bits of io_ring,
> a deadlock can occur. This fixes those bits by disabling soft interrupts.

Jens already fixed that, thanks

https://lore.kernel.org/io-uring/948d2d3b-5f36-034d-28e6-7490343a5b59@kernel.dk/T/#t

FYI, your email got into spam.

> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> There are 2 reports.
> 
> Warning#1:
> 
> ================================
> WARNING: inconsistent lock state
> 5.10.0-rc5_irqs_a+fstn1 #5 Not tainted
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/14/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> c00000000b76f4a8 (&file_data->lock){+.?.}-{2:2}, at: io_file_data_ref_zero+0x58/0x300
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x2c4/0x5c0
>   _raw_spin_lock+0x54/0x80
>   sys_io_uring_register+0x1de0/0x2100
>   system_call_exception+0x160/0x240
>   system_call_common+0xf0/0x27c
> irq event stamp: 4011767
> hardirqs last  enabled at (4011766): [<c00000000167a7d4>] _raw_spin_unlock_irqrestore+0x54/0x90
> hardirqs last disabled at (4011767): [<c00000000167a358>] _raw_spin_lock_irqsave+0x48/0xb0
> softirqs last  enabled at (4011754): [<c00000000020b69c>] irq_enter_rcu+0xbc/0xc0
> softirqs last disabled at (4011755): [<c00000000020ba84>] irq_exit+0x1d4/0x1e0
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&file_data->lock);
>   <Interrupt>
>     lock(&file_data->lock);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by swapper/14/0:
>  #0: c0000000021cc3e8 (rcu_callback){....}-{0:0}, at: rcu_core+0x2b0/0xfe0
>  #1: c0000000021cc358 (rcu_read_lock){....}-{1:2}, at: percpu_ref_switch_to_atomic_rcu+0x148/0x400
> 
> stack backtrace:
> CPU: 14 PID: 0 Comm: swapper/14 Not tainted 5.10.0-rc5_irqs_a+fstn1 #5
> Call Trace:
> [c0000000097672c0] [c0000000002b0268] print_usage_bug+0x3e8/0x3f0
> [c000000009767360] [c0000000002b0e88] mark_lock.part.48+0xc18/0xee0
> [c000000009767480] [c0000000002b1fb8] __lock_acquire+0xac8/0x21e0
> [c0000000097675d0] [c0000000002b4454] lock_acquire+0x2c4/0x5c0
> [c0000000097676c0] [c00000000167a38c] _raw_spin_lock_irqsave+0x7c/0xb0
> [c000000009767700] [c0000000007321b8] io_file_data_ref_zero+0x58/0x300
> [c000000009767770] [c000000000be93e4] percpu_ref_switch_to_atomic_rcu+0x3f4/0x400
> [c000000009767800] [c0000000002fe0d4] rcu_core+0x314/0xfe0
> [c0000000097678b0] [c00000000167b5b8] __do_softirq+0x198/0x6c0
> [c0000000097679d0] [c00000000020ba84] irq_exit+0x1d4/0x1e0
> [c000000009767a00] [c0000000000301c8] timer_interrupt+0x1e8/0x600
> [c000000009767a70] [c000000000009d84] decrementer_common_virt+0x1e4/0x1f0
> --- interrupt: 900 at snooze_loop+0xf4/0x300
>     LR = snooze_loop+0xe4/0x300
> [c000000009767dc0] [c00000000111b010] cpuidle_enter_state+0x520/0x910
> [c000000009767e30] [c00000000111b4c8] cpuidle_enter+0x58/0x80
> [c000000009767e70] [c00000000026da0c] call_cpuidle+0x4c/0x90
> [c000000009767e90] [c00000000026de80] do_idle+0x320/0x3d0
> [c000000009767f10] [c00000000026e308] cpu_startup_entry+0x38/0x50
> [c000000009767f40] [c00000000006f624] start_secondary+0x304/0x320
> [c000000009767f90] [c00000000000cc54] start_secondary_prolog+0x10/0x14
> systemd[1]: systemd-udevd.service: Got notification message from PID 195 (WATCHDOG=1)
> systemd-journald[175]: Sent WATCHDOG=1 notification.
> 
> 
> 
> Warning#2:
> ================================
> WARNING: inconsistent lock state
> 5.10.0-rc5_irqs_a+fstn1 #7 Not tainted
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/7/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> c00000000c64b7a8 (&file_data->lock){+.?.}-{2:2}, at: io_file_data_ref_zero+0x54/0x2d0
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x2c4/0x5c0
>   _raw_spin_lock+0x54/0x80
>   io_sqe_files_unregister+0x5c/0x200
>   io_ring_exit_work+0x230/0x640
>   process_one_work+0x428/0xab0
>   worker_thread+0x94/0x770
>   kthread+0x204/0x210
>   ret_from_kernel_thread+0x5c/0x6c
> irq event stamp: 3250736
> hardirqs last  enabled at (3250736): [<c00000000167a794>] _raw_spin_unlock_irqrestore+0x54/0x90
> hardirqs last disabled at (3250735): [<c00000000167a318>] _raw_spin_lock_irqsave+0x48/0xb0
> softirqs last  enabled at (3250722): [<c00000000020b69c>] irq_enter_rcu+0xbc/0xc0
> softirqs last disabled at (3250723): [<c00000000020ba84>] irq_exit+0x1d4/0x1e0
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&file_data->lock);
>   <Interrupt>
>     lock(&file_data->lock);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by swapper/7/0:
>  #0: c0000000021cc3e8 (rcu_callback){....}-{0:0}, at: rcu_core+0x2b0/0xfe0
>  #1: c0000000021cc358 (rcu_read_lock){....}-{1:2}, at: percpu_ref_switch_to_atomic_rcu+0x148/0x400
> 
> stack backtrace:
> CPU: 7 PID: 0 Comm: swapper/7 Not tainted 5.10.0-rc5_irqs_a+fstn1 #7
> Call Trace:
> [c00000000974b280] [c0000000002b0268] print_usage_bug+0x3e8/0x3f0
> [c00000000974b320] [c0000000002b0e88] mark_lock.part.48+0xc18/0xee0
> [c00000000974b440] [c0000000002b1fb8] __lock_acquire+0xac8/0x21e0
> [c00000000974b590] [c0000000002b4454] lock_acquire+0x2c4/0x5c0
> [c00000000974b680] [c00000000167a074] _raw_spin_lock+0x54/0x80
> [c00000000974b6b0] [c0000000007321b4] io_file_data_ref_zero+0x54/0x2d0
> [c00000000974b720] [c000000000be93a4] percpu_ref_switch_to_atomic_rcu+0x3f4/0x400
> [c00000000974b7b0] [c0000000002fe0d4] rcu_core+0x314/0xfe0
> [c00000000974b860] [c00000000167b578] __do_softirq+0x198/0x6c0
> [c00000000974b980] [c00000000020ba84] irq_exit+0x1d4/0x1e0
> [c00000000974b9b0] [c0000000000301c8] timer_interrupt+0x1e8/0x600
> [c00000000974ba20] [c000000000009d84] decrementer_common_virt+0x1e4/0x1f0
> --- interrupt: 900 at plpar_hcall_norets+0x1c/0x28
>     LR = check_and_cede_processor.part.2+0x2c/0x90
> [c00000000974bd80] [c00000000111f75c] shared_cede_loop+0x18c/0x230
> [c00000000974bdc0] [c00000000111afd0] cpuidle_enter_state+0x520/0x910
> [c00000000974be30] [c00000000111b488] cpuidle_enter+0x58/0x80
> [c00000000974be70] [c00000000026da0c] call_cpuidle+0x4c/0x90
> [c00000000974be90] [c00000000026de80] do_idle+0x320/0x3d0
> [c00000000974bf10] [c00000000026e30c] cpu_startup_entry+0x3c/0x50
> [c00000000974bf40] [c00000000006f624] start_secondary+0x304/0x320
> [c00000000974bf90] [c00000000000cc54] start_secondary_prolog+0x10/0x14
> 
> ---
>  fs/io_uring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a8c136a1cf4e..b922ac95dfc4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6973,9 +6973,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  	if (!data)
>  		return -ENXIO;
>  
> -	spin_lock(&data->lock);
> +	spin_lock_bh(&data->lock);
>  	ref_node = data->node;
> -	spin_unlock(&data->lock);
> +	spin_unlock_bh(&data->lock);
>  	if (ref_node)
>  		percpu_ref_kill(&ref_node->refs);
>  
> @@ -7493,9 +7493,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  	}
>  
>  	file_data->node = ref_node;
> -	spin_lock(&file_data->lock);
> +	spin_lock_bh(&file_data->lock);
>  	list_add_tail(&ref_node->node, &file_data->ref_list);
> -	spin_unlock(&file_data->lock);
> +	spin_unlock_bh(&file_data->lock);
>  	percpu_ref_get(&file_data->refs);
>  	return ret;
>  out_fput:
> 

-- 
Pavel Begunkov
