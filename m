Return-Path: <io-uring+bounces-12583-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNSHFKrHrmlwIwIAu9opvQ
	(envelope-from <io-uring+bounces-12583-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:14:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DDF23985D
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A82DB301C172
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E40D3B8959;
	Mon,  9 Mar 2026 13:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uxxyQxWp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFED3BA24D
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773061898; cv=none; b=FTUh4XluBsu0novShLom6RV9SdFk2zDX9dCSLmvTEbpJWPv+i6ICHYcXfRXA1e1zDrnvdTbWPRAC0Oaro8EmS0JbVM2E4x5Et24/+uhTMgqkmHa9Q14TRPvG4fdKk/Su2WTyLgb+CH9QPEvvxMldHxpvOKYnT7DZqOUpGlCsNgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773061898; c=relaxed/simple;
	bh=oeob2fuLyQlPnO6SuJrLZeO3C4L6X4wU9QdohmlwS7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hcvj7hHBd25MEPz7wtOj5UX8Esbge4pCEDbGm04f55feiqVrbUI7MRUlqEJmT2tev98I9+WNjwZbKLGvoOY9WSS+EUlduXB3BMMDAF+YRrPk5jtjNghS57tFAOPp3sUYLSwXnVOJwZHLNzJjhdYKSxEuYqb5Cz8CeeGWDU4N4uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uxxyQxWp; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cd80f56b27so145244785a.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773061893; x=1773666693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+j399pLZ+uCFFZegnh7B/GLRkXzNzBj7hwY8ivxyDs4=;
        b=uxxyQxWpvW0ywA+OjJAvo9klrZb9rc3wJCjGcpGQf5aCL7gMGnzzrrfc+Hy7llCnna
         Cj9VhcijXOvcoW5CByFrHEpCucN7A5zbpR+6cWtdc7dzGzel2GAhR4jgZ2U09VUjk5mq
         yRSNFHqCK5+FVlUFmBOZJpRTRzVz5N1Rw5//gCF/zT8jXPuEkYVAKk7K6u8emCDwmmG8
         Yo+N4hD3QnDPoe+i4EEnHSz7+Hyq2KDMCUCLlEk4JHVn1reTD7KAUqQBsDeYM3sq3d02
         aa1dqoaOWj2eJGON4u13/Oz7MkEjE5yAq6DOphjDg/EBvc9sJbljLzFiTcZyvB96CIyL
         M3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773061893; x=1773666693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+j399pLZ+uCFFZegnh7B/GLRkXzNzBj7hwY8ivxyDs4=;
        b=SK/1C6G3jj6SX/2uCGWSoKuyPvdazhRWT3nnr8S8LK6ZyXOAQJ4gRTEs7y55W+Cd/7
         8uXAx6JCLWF7bXbLnJBtrQ+RjxaJbq3GfL/dFdgmvPnzl09yGc7x0RBsaWaYbB1r6Bsx
         LxtNhaKzNBaf/p3SOjV8Rmk53o6Nu7AOg//3W+J+VN5FpQZhEZo5rOhfFGvBW/+ELhEJ
         h1rf0vqYp6WOsHdYOca0dwft0B/0Ay+afwE5J7ltwy0SVa4nJI0SwMLao47h1CfG3m0a
         IvqGTFqLAfbFWS4h7DZgDQ3zyqL860bDdP3wBqf2oi3H04QI6/YXWQgg3g7+6V7d3/W/
         COgw==
X-Gm-Message-State: AOJu0Yx1IOLKW2eqU4vmwj4LAd1Lud1VanCLtdcZNy8ACLb7/nFPR/wt
	fKBNXJwvBYt0tQm4WF7MlcCvWTD7sOuqBgwg3ux5dTe/w8jFMJ8DUia+QjSqjnThua0=
X-Gm-Gg: ATEYQzyYtzcIVhxhe+LACrTNafucV2OWJAcWwQ1w9iN41vJc6dJkDLOKLCQkZpzH3iV
	oXs4gZNApZNOa/CxqY6hvycSHlCVUFHWZLf406TCgdeh0SgPtBgyCdieBSf/ezrC6nbEZJD52z3
	RUA4qI8CDHPTpWT6pNUlN5QGcA+uywoz5DAeY15oO+IpEeEuoaXDc/IrOtzcn+kiLPyOr8P/2fZ
	1pbbTszrSV4c13M9Wa13pqVUIHAwli25aux3RpZkPb1j1J1tbcBFLm2xvEgkPu9xOcVRn/efvU8
	XfvxsZi+fsMvLs3FIsTkDy1F0/DYLS3lxiE/NmR3/M2PAkph9Djk1HOmKNZeDZjYNduAhlPcpjK
	psTAfdxtIECw68iEjuCdT/rCJD3RuyX9LG0ijcjwpjbpXwa+gme/KsR8iMPf8vwWNda7XLDfIlh
	HqNgr9ig+I9knZBo1NFCce+VmKjze8udllEoTr+5NqRg+Qt5IYQA==
X-Received: by 2002:a05:620a:4146:b0:8cd:827a:2abb with SMTP id af79cd13be357-8cd827a371dmr585176385a.31.1773061893070;
        Mon, 09 Mar 2026 06:11:33 -0700 (PDT)
Received: from [172.19.0.48] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8d4cac0esm136699885a.36.2026.03.09.06.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:11:31 -0700 (PDT)
Message-ID: <959a75c9-4de5-42d1-8f43-636f4aab5df8@kernel.dk>
Date: Mon, 9 Mar 2026 07:11:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in
 io_register_resize_rings
To: Hao-Yu Yang <naup96721@gmail.com>, security@kernel.org
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260309062759.482210-1-naup96721@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260309062759.482210-1-naup96721@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A2DDF23985D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12583-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.941];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 3/9/26 12:27 AM, Hao-Yu Yang wrote:
> During io_register_resize_rings execution, ctx->rings is temporarily
> set to NULL before new ring memory is allocated. If a timer interrupt
> fires during this window, the interrupt handler (via timerfd_tmrproc
> -> io_poll_wake -> __io_req_task_work_add -> io_req_local_work_add)
> attempts to access ctx->rings->sq_flags, causing race condition and
> a NULL pointer dereference.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000024
> PF: supervisor read access in kernel mode
> PF: error_code(0x0000) - not-present page
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <IRQ>
>  __io_poll_execute (io_uring/poll.c:223)
>  io_poll_wake (io_uring/poll.c:426)
>  __wake_up_common (kernel/sched/wait.c:109)
>  __wake_up_locked_key (kernel/sched/wait.c:167)
>  timerfd_tmrproc (./include/linux/spinlock.h:407 fs/timerfd.c:71 fs/timerfd.c:78)
>  ? __pfx_timerfd_tmrproc (fs/timerfd.c:75)
>  __hrtimer_run_queues (kernel/time/hrtimer.c:1785 kernel/time/hrtimer.c:1849)
>  hrtimer_interrupt (kernel/time/hrtimer.c:1914)
>  __sysvec_apic_timer_interrupt (./arch/x86/include/asm/jump_label.h:37 ./arch/x86/include/asm/trace/irq_vectors.h:40 arch/x86/kernel/apic/apic.c:1063)
>  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1056 arch/x86/kernel/apic/apic.c:1056)
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt (./arch/x86/include/asm/idtentry.h:697)
>  RIP: 0010:io_register_resize_rings (io_uring/register.c:593)
>  ? io_register_resize_rings (io_uring/register.c:580)
>  __io_uring_register (io_uring/register.c:898)
>  ? fget (fs/file.c:1114)
>  __x64_sys_io_uring_register (io_uring/register.c:1026 io_uring/register.c:1001 io_uring/register.c:1001)
>  x64_sys_call (arch/x86/entry/syscall_64.c:41)
>  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall)
>  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
>  </TASK>
> 
> Fix by using spin_lock_irq/spin_unlock_irq instead of spin_lock/spin_unlock
> in io_register_resize_rings. This disables IRQs while ctx->rings is set to
> NULL, preventing interrupt handlers from executing during the window when
> ctx->rings is NULL.

I see the your crash, but this isn't the right fix - you can't just have
that one spot turn the completion lock into an IRQ disabling one,
that'll mess up the rest of the use cases in terms of lockdep. This lock
is never grabbed from IRQ context, hence it'd be misleading too.

You probably want something ala:

mutex_lock(&ctx->mmap_lock);
spin_lock(&ctx->completion_lock();
+ local_irq_disable();

...

+ local_irq_enable();
spin_unlock(&ctx->completion_lock);
mutex_unlock(&ctx->mmap_lock);

which I think should make lockdep happy with it too.

And then I think it wants a comment on top of that local_irq_disable(),
explaining how this is meant to prevent any irq/bh from triggering
task_work additions that touch ctx->rings to set the IORING_SQ_TASKRUN
flag.

Does that makes sense? If so, please do send a v2!

-- 
Jens Axboe

