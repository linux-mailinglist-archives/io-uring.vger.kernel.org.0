Return-Path: <io-uring+bounces-13843-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id N+/YETCYPmr0IgkAu9opvQ
	(envelope-from <io-uring+bounces-13843-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 17:18:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1709C6CE69A
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 17:18:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=OJj+MZdb;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13843-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13843-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 480033007AF6
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 15:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D926A39A063;
	Fri, 26 Jun 2026 15:17:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F2939E184
	for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 15:17:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487061; cv=none; b=DVWx3PfGwqpXxlIAyu5fnWiCHkj7DcwZk7oXjfVhm+gSHlIdtTgHIEkvU9Wp+7m9DBPKNSqFI/Bbz2qd8Mivn/e9lwf1QDRRznGIvMFV2gHxCRvCYVnmNQKOgu6gD4+lE7BO3Isdq5So1zh4TKadjdYiGPD+8qsXoQVexBdZyrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487061; c=relaxed/simple;
	bh=r+NZ0420PJVYrD2z/P9ZjzU5OEb0JNghtOI0MY0wyQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fuuXNBrFUU+mENlCLFWLEFo5kKGqewk9OSbrKhQ+zZQf2c4OwuJmeddLwietwsF9HGr8luuz6h+CgyV7gW2VoeZeaqWbVPqfAQ7/H+bJKHCtKAxtD0xz12lmFwNtuXwNG9BoJDU+MMxmnjHxES0rKUybPN5sntQq9po2JM+mQrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=OJj+MZdb; arc=none smtp.client-ip=209.85.161.41
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-69d7aa0ac14so909926eaf.3
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 08:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782487057; x=1783091857; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T7VOxyR6F/akNiquT5AocjILii/ty3Ln1bGY4nMpuNE=;
        b=OJj+MZdbWFaTYICwtLEX/zAkYHp2h5TnDp8/DXHj9m33umwjZ4ZDbBFqXsd99v5sn5
         Z5gnyYzvCt+P0emNYPmTR/aMLaAqHWiHC/yr2RAj+8VUcvdepy3hQFPTCLvCN2gp7oiM
         Givf3HcAV5lUs2TOfPw8SGEGlSeX/rVTyL/XnCSrf9lo7CRLebrID8KQ+l6C2NTYWY92
         /yl5jf/MbitAMHohduNuljgPtxSzpogBc7ivEiM8v3CDlXSBbAu/KoozMbLA8HZXqcK7
         VdgCSYiallX0WJ0YuRBWTNvsbe4BR3o+yN/tQ9MRepaGq8SWhZ7kq5w3MUcNy3sqD29y
         6EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487057; x=1783091857;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T7VOxyR6F/akNiquT5AocjILii/ty3Ln1bGY4nMpuNE=;
        b=negUd63CcjlJ2A+VCIE1l8k/xdPO8uhMSoXNRAtKMiETHDLean9xbFeXrNThrilivS
         VOzzUOQYMyjteTsyeZ68J9ggQdYYZw6uuk2DhW5mcUXHLZA4VCMSE0BfmreXXbJo3FdJ
         PwkAyZO6lVSqyMivd94iJhLzaKLDhzmEgBmHoarGsILi7sIYg+cLZ74woVYFrsWrxDxg
         rpdKewfFaWyzD8ToRQuQ0iWTGPdl0+IL3tOKAHqj8jm5DGAvnRtKL73roMXwWFZsOjIi
         qCpTosBaXt2fE4L6mrLnzmxr3M6iV4EyN/ocADKAnk3tICP35TAkirKlYkKQ+Y5Qb9Ux
         hgmA==
X-Forwarded-Encrypted: i=1; AFNElJ8i2bNxeDymMkI2zxfIoBb57tEGaP/JB8/p1bgH8qBYWtWBDawxYrNyg3U5M8cvnmJzpb085lJuqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcuGOMuV9rcsvPXvC7R/JTDXfZfX2RzKHKOLQN43fpH1egGLqn
	PLTokgVZYavZedLNBihgN3eU9fKRC0bJzlqZCI1TuDGkD99u74Owq0QxNhU+CH0GhhI=
X-Gm-Gg: AfdE7clwHBLPHs9rZtDRuYXcB20WYwq9HqadXJPrOjTlp2FqH2xyJxqCe1rFcXLTIWP
	eqNCfCD5lLjO0eOWsiOQWRO5zCyemv405cCTGt7A9GxoCUOrQpd9sWLrOmgiS7wpx2J+jr0Px5M
	IeiVfWMwBfzkrem2SMHVwnd+awUN/g5oafiAQYkU2NAta76MvTAZu06tv838VtbGMB5xoJYbBWH
	mS+O5+DNd8XigscixgN42dLwaNVZgKEYJp3TU+4L7f8OKslzzl880CNaYXGH2UrOPWKef1z5iG0
	elDvkDTQ+dRLHl89Nz/0yxuvld49X9S5OERTCZUmEe3waZybC0kSivPm2pBDMMybDFOPw8DvEAQ
	jzoPtdKeVg92ATvtyxAE7BGTlAbAUfz6mhGxczhPDSpfLGM1005FSQL/8nkaFq+7MoHi9mSnmeQ
	/DlmELL94GCFOOEHUJJNSL+uudUNj0723voH0IGrYS/xA3kEuit4TYh9ZsYB4DROmi6R5K4w==
X-Received: by 2002:a4a:e90a:0:b0:6a1:200b:2e77 with SMTP id 006d021491bc7-6a1500e5e1fmr703541eaf.42.1782487057225;
        Fri, 26 Jun 2026 08:17:37 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ec5fd4csm15682729fac.2.2026.06.26.08.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 08:17:36 -0700 (PDT)
Message-ID: <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
Date: Fri, 26 Jun 2026 09:17:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Ben Carey <benjamin.james.carey3@gmail.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13843-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:benjamin.james.carey3@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1709C6CE69A

On 6/26/26 9:09 AM, Ben Carey wrote:
> From: benjamin.james.carey3@gmail.com
> 
> Hello, whomever this may concern.
> 
> I am working in a lab researching energy efficiency of I/O servicing and
> completion mechanisms, and we have encountered an issue when using io_uring and
> completing I/O requests while polling NVMe drives.
> 
> Description
> ===========
> 
> When using fio to run io_uring test benches for energy consumption analysis
> on our lab server, we're encountering strange kernel locking behaviors as
> numjobs increases.
> 
> This issue occurs on our workloads the poll for I/O completion. Specifically,
> whenever the numjobs parameter scales to beyond the nvme.poll_queues
> parameter, the job takes much longer to complete or doesn't complete at all.
> 
> Notably, this issue occurs also on a QEMU image mimicking our setup. Using GDB
> to read dmesg output we get the following:
> 
> ...
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-7): P1070
> rcu: 	(detected by 7, t=252035 jiffies, g=1985, q=25149 ncpus=8)
> task:fio             state:R  running task     stack:13296 pid:1070  tgid:1070  ppid:1068   task_flags:0x400140 flags:0x00080000
> Call Trace:
> ...
> ? blk_hctx_poll+0x34/0x80
> blk_mq_poll+0x2b/0x40
> bio_poll+0x94/0x180
> iocb_bio_iopoll+0x31/0x50
> io_uring_classic_poll+0x20/0x40
> io_do_iopoll+0x233/0x430
> ? io_issue_sqe+0x2f/0x560
> ? io_submit_sqes+0x270/0x820
> __do_sys_io_uring_enter+0x228/0x770
> ? handle_softirqs+0xc7/0x250
> __x64_sys_io_uring_enter+0x21/0x30
> x64_sys_call+0x17c8/0x1dd0
> do_syscall_64+0xe0/0x5a0
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Expected behavior
> =================
> 
> fio job completes after specified runtime.
> 
> Actual behavior
> ===============
> 
> fio job never completes, system becomes less responsive (if the number of poll
> queues and jobs are high) and RCU stall checker detects stalls.
> 
> Observations
> ============
> 
> After some minimal investigation we found this notable function being called as
> the callback for q->mq_ops->poll:
> 
> static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
> {
> 	struct nvme_queue *nvmeq = hctx->driver_data;
> 	bool found;
> 
> 	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
> 	    !nvme_cqe_pending(nvmeq))
> 		return 0;
> 
> 	spin_lock(&nvmeq->cq_poll_lock);
> 	found = nvme_poll_cq(nvmeq, iob);
> 	spin_unlock(&nvmeq->cq_poll_lock);
> 
> 	return found;
> }
> 
> This function, when stuck on the RCU loop, always returns 0. It also always
> calls the helper function nvme_cqe_pending.
> 
> Following this are some items that may help in reproducing this issue.
> 
> Steps to reproduce
> ==================
> From a running QEMU image with the latest kernel:
> 1. Attach GDB to the running instance.
> 2. Enable io polling via sysfs (echo 1 > /sys/block/nvme0n1/queue/io_poll).

That's not how that works at all. You need to setup poll queues on the
nvme driver side, using the nvme.poll_queues=XX kernel parameter, or if
using nvme as a module, load the module with poll_queues=XX where XX is
the number of poll queues. You're not doing any polled IO as-is, and the
above should also have dumped a dmesg message about how that does
absolutely nothing.

That said, it should still work, just not doing polled IO. I'll take a
look sometime next week, OOO right now.

-- 
Jens Axboe

