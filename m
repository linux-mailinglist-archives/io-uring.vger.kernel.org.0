Return-Path: <io-uring+bounces-11154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7D2CC8C45
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 17:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 96B1C3031B7E
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 16:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402D634D4F0;
	Wed, 17 Dec 2025 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kjRhehD8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F134D930
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988765; cv=none; b=KhrrV7+iaOeXJScN0JjOGZXXuk2AmV4DNf+4mK0M/LvLg4uByiEKL3AT8YbH7sesoOYms6DT376W9VWQHT/LbbT+/Q05kGqkmy+PqjjdFUi8/wv5S4IOG+q4INvYvTDJkZ+skrcZfwX5bHbDyBKuLmZG9w9Q3kfO6IL3t9x3dKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988765; c=relaxed/simple;
	bh=QpVb6dZ4gIZn7HvIi025+ZqIR20UX4OBHP1VIRnbcZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NZCe+RD9P9kGL4xdtha8Q7h5Tzk1Wt0SKn1UasXt9l+YXKdueg3lCx7eoEPC2FM7cKvVi0o1ZdCeJvCxQ0jCS039Xk1nLhR54DL+9SHE5WXfOaiK6xq/zt55ZZxRehlnAJ7osv9FXBeBo2PpYTjtF4Wf5LtfFa8FQY8YKl7a3AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kjRhehD8; arc=none smtp.client-ip=209.85.167.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-4511744b411so3047846b6e.3
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 08:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765988761; x=1766593561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=otpHvvceBIgaUYg2RTGFQXfdQlnmB5ZOpMfY+5dD12w=;
        b=kjRhehD8fDmrEnR0tyOghjaDzO62x7MyP2DjP8+j4kGMJpq/vmsWoV6URgCnPCnSW+
         olACEoSfJmQX/zMM56ZySTfrTOwYNX6Bd/lB4HXEeK39yvHDUwu81eWEE9XoawpR+JSm
         HXDEKnYyBhVIdkQAZ1QRprJNYlFQPbpqYUxg+IaU7O5Zol58VG2el5C8xOlfk+h3T90K
         YxXvpMnHLLATOlZFZR3/ZChiH9WZ+NX7dcMgDDxd4nmw/3z49uF2XZAO2YjmYmxKJBON
         fwwyN8bJVl6EVRmOaISDdCD4CzE6UYkq6iO7f7zGr3vLI2F3oZn/fa4QS9+mATSdSKp9
         2spw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765988761; x=1766593561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=otpHvvceBIgaUYg2RTGFQXfdQlnmB5ZOpMfY+5dD12w=;
        b=uHSrLks8O3HEqR2NEcJN4n8jCkZTu81i95F3UPFZJUMw6LYuNtDHm/ZUvRMzDbXs+4
         +F+u/A0yy3uC2DM5wBHplgawHwqUdRi95vq0OD3QR/1TdgRagTf9m/2dHI5NFOroFtxR
         oo5d8esvAwHRx1ZXDL2GQVSIZfIF1qo6OWXjHuJaflXwq8UTZKbMF5RV1BbUuhf1IJcH
         1Rvf3oc+uWB8RMEB/mSfECauW6wmH6CUorFpFmFt8gccBh18DCVKClUxGDzpBBYHaeYE
         ZUO0UAAS51wIGkK9v/kS7Jvs0dRGB3GPF9rB311mKwVp9UGZXPV8w0BDQqnrElF4DPi8
         y+JQ==
X-Forwarded-Encrypted: i=1; AJvYcCVs0lU3kTIPm/WryDjuhqGRstiRlg2Mmv+t8B6DMMvvTbjjTUicVrzJNvsQuTZgh1PD/K4TfrmhvA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0rGqLD1jHqLwLzPBKWtyga4QzqKQzHUG1y6mVvtb2Fj7WeLDY
	/A9uefNcfOGSDk0Py1vi2hFHQUDH130pqOu+AKhWy2baJmuTBB2INFEUPtiWHYCyBMs=
X-Gm-Gg: AY/fxX7IdNTI4/fmbqcMwCFPnzNtnPgICpMLUF320d8oOkARge95Mo15kZywer5LTR8
	44NMCGFzcgEcgHDph55t1n++AKtQ+x8quiGHCGP2y8zsnHNcpGti7JIp+gRCdz69uyol2O9wMW5
	VPsyg/BmKnhHPJOpw9x2eTxI7+1ViGWNnuVrbBT/NPfJXkBTtZUhRwHfckxG6qGpD2zsffsIRnf
	aSktzPDWOgaCQtDD3DYKtzU8c7vAtmu2V63rgNGC7lZm4ATZ53oTCHk9J8sjIaO262YLSKEkTWM
	nx8ZHjgD7mCr531VMcAtp8lyRUJuJP7igRHj96Z9gioIRX2JDPDrX+5WlzsdLIW0nNMTooe0aUV
	iSoPnZXaOq/CZ2TJwa3cp6zoxqqyFJyZ/skKxVDtZA8TLQfWC5fz1LIxHA5BnedCwhZLbs3UTre
	bTjNq8YMw=
X-Google-Smtp-Source: AGHT+IENQMcU6HhDqloZhOktPeqqzKv1O64BdfG00kyEAZ0dBQ+tTTSihdb4MowuI2rVdfHQBXjgQA==
X-Received: by 2002:a05:6808:398c:b0:453:7a2a:6453 with SMTP id 5614622812f47-455ac989103mr9246492b6e.46.1765988761000;
        Wed, 17 Dec 2025 08:26:01 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f614e374ffsm8570875fac.16.2025.12.17.08.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 08:26:00 -0800 (PST)
Message-ID: <9a8418d8-439f-4dd2-b3fe-33567129861e@kernel.dk>
Date: Wed, 17 Dec 2025 09:25:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Diangang Li <lidiangang@bytedance.com>,
 Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
 <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
 <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
 <f2836fb8-9ad7-4277-948b-430dcd24d1b6@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f2836fb8-9ad7-4277-948b-430dcd24d1b6@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/17/25 5:34 AM, Diangang Li wrote:
> Hi Jens,
> 
> We?ve identified one critical panic issue here.
> 
> [ 4504.422964] [  T63683] list_del corruption, ff2adc9b51d19a90->next is 
> LIST_POISON1 (dead000000000100)
> [ 4504.422994] [  T63683] ------------[ cut here ]------------
> [ 4504.422995] [  T63683] kernel BUG at lib/list_debug.c:56!
> [ 4504.423006] [  T63683] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> [ 4504.423017] [  T63683] CPU: 38 UID: 0 PID: 63683 Comm: io_uring 
> Kdump: loaded Tainted: G S          E       6.19.0-rc1+ #1 
> PREEMPT(voluntary)
> [ 4504.423032] [  T63683] Tainted: [S]=CPU_OUT_OF_SPEC, [E]=UNSIGNED_MODULE
> [ 4504.423040] [  T63683] Hardware name: Inventec S520-A6/Nanping MLB, 
> BIOS 01.01.01.06.03 03/03/2023
> [ 4504.423050] [  T63683] RIP: 
> 0010:__list_del_entry_valid_or_report+0x94/0x100
> [ 4504.423064] [  T63683] Code: 89 fe 48 c7 c7 f0 78 87 b5 e8 38 07 ae 
> ff 0f 0b 48 89 ef e8 6e 40 cd ff 48 89 ea 48 89 de 48 c7 c7 20 79 87 b5 
> e8 1c 07 ae ff <0f> 0b 4c 89 e7 e8 52 40 cd ff 4c 89 e2 48 89 de 48 c7 
> c7 58 79 87
> [ 4504.423085] [  T63683] RSP: 0018:ff4efd9f3838fdb0 EFLAGS: 00010246
> [ 4504.423093] [  T63683] RAX: 000000000000004e RBX: ff2adc9b51d19a90 
> RCX: 0000000000000027
> [ 4504.423103] [  T63683] RDX: 0000000000000000 RSI: 0000000000000001 
> RDI: ff2add151cf99580
> [ 4504.423112] [  T63683] RBP: dead000000000100 R08: 0000000000000000 
> R09: 0000000000000003
> [ 4504.423120] [  T63683] R10: ff4efd9f3838fc60 R11: ff2add151cdfffe8 
> R12: dead000000000122
> [ 4504.423130] [  T63683] R13: ff2adc9b51d19a00 R14: 0000000000000000 
> R15: 0000000000000000
> [ 4504.423139] [  T63683] FS:  00007fae4f7ff6c0(0000) 
> GS:ff2add15665f5000(0000) knlGS:0000000000000000
> [ 4504.423148] [  T63683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4504.423157] [  T63683] CR2: 000055aa8afe5000 CR3: 00000083037ee006 
> CR4: 0000000000773ef0
> [ 4504.423166] [  T63683] PKRU: 55555554
> [ 4504.423171] [  T63683] Call Trace:
> [ 4504.423178] [  T63683]  <TASK>
> [ 4504.423184] [  T63683]  io_do_iopoll+0x298/0x330
> [ 4504.423193] [  T63683]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [ 4504.423204] [  T63683]  __do_sys_io_uring_enter+0x421/0x770
> [ 4504.423214] [  T63683]  do_syscall_64+0x67/0xf00
> [ 4504.423223] [  T63683]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 4504.423232] [  T63683] RIP: 0033:0x55aa707e99c3
> 
> It can be reproduced in three ways:
> - Running iopoll tests while switching the block scheduler
> - A split IO scenario in iopoll (e.g., bs=512k with max_sectors_kb=256k)
> - Multi poll queues with multi threads
> 
> All cases appear related to IO completions occurring outside the 
> io_do_iopoll() loop. The root cause remains unclear.

Ah I see what it is - we can get multiple completions on the iopoll
side, if you have multiple bio's per request. This didn't matter before
the patch that uses a lockless list to collect them, as it just marked
the request completed by writing to ->iopoll_complete and letting the
reaper find them. But it matters with the llist change, as then we're
adding the request to the llist more than once.


-- 
Jens Axboe

