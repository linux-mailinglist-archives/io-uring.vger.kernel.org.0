Return-Path: <io-uring+bounces-13229-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qB/zAw2O+GkVwgIAu9opvQ
	(envelope-from <io-uring+bounces-13229-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 14:16:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 752D74BCCD9
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 14:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6529B301627D
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 12:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4833347BD4;
	Mon,  4 May 2026 12:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="OZVS5FA6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2826E28DB49
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777896970; cv=none; b=DrpRSW5Ck77EIl+BbI4K8Ym7HfvQjnScw5OHA+lD6SynjN8o0gy7hPXJxt2bOpF6p8SGsSlp+JLfDOTHA078+Mpj/22DETK6cje4u3Ggpko7dcK70cA8XxepnnXZkmCTv+CycMg5Biu2gv2nyHWZJRMg+DZyZypmHXDMAzTwY3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777896970; c=relaxed/simple;
	bh=vuDA8Ugju8drRnFH0reUsv1Qi61BNTbG4Zd68t3UP8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=issQETUxum/yod5ZfTKMO6BxjcW3CxWL/CxZxIhNLNnRF6SLlZSl84a0rF0HT+z9Img4IBt4YYWad0dSQTynabZfBns5HRx8sFQ0+3M+kvlhpXQTnSNS1CcEoqutNyUQ9mtwNfK7I7E3eoyZ9ec8o3u/HherTuZYkuFmxTvo5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=OZVS5FA6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so32358175e9.0
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 05:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777896966; x=1778501766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xkYMixTNcU3YZDXGC6rYgyPR/xsl4ZS0kdPy6pXeG1Q=;
        b=OZVS5FA6xsFM5C+uY6DpYhs6ohjQACK/vsopNZJ/Xh3jgzmvS5qdbjqfPnOv02PTVt
         HymPZIeUcE4ffnFnWYd2HQ5cucWK9SpiwQLyHX6mmEH6pQM/oOIVN3s0xBF8eAG+J6to
         25eJ5pf1O4k4maclVGUdF+9UhCKfy9cUBZlwcG3ZqDt2jxgng6uR2I7KsXCfGtA7sUfD
         AQlaE/cG+6wblFzjwrzieMsPMlXgI7vrLwIE/bnOnMydoowBYsJUZvLQL16ynnLEM1pz
         05a0K/KyX7AAEmsqD4QxNdFzmjormBwAAIfX4vR6pxsY5CBmcgjQW3ohHHi2mnSnLiQd
         RO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777896966; x=1778501766;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xkYMixTNcU3YZDXGC6rYgyPR/xsl4ZS0kdPy6pXeG1Q=;
        b=TB+G0COTzuoUv3MCAU+hQ2U1tOxv1XDgwr3h7t+pDij5oa7pxhjLKNK4dY9R0S2iDK
         HGY1+4t32U7ZACerXXoJib0EuiS5TQsaIcFyvh7VyjLwhnt5tkaZO6VSY7INMtmUupkN
         crt8VstyebEooJgDCYLRUO4xXmZ1yHMvTw3GTKAA5CfdRuGRS7wwpPJU9OkF1/8lSGDs
         I32aNgf+SdFV2ndLumvnpbQ+wME11zdVX2P22ArQTC5IokMc65lyPD6qDsofEQ+Qshwv
         rKkd/T9Xp/x9Ubv97uHbhSaOGo2Goa8T5H4cz1B2oxBUphf/KjLIu9nM9wREMe+DWx6m
         G4aQ==
X-Gm-Message-State: AOJu0YzuuRmmbdS8HgLyUtZQKuRue2bh8yB8JoK1nbfnFUq//qOz6MVG
	UU75XIPQJGunwallit8SeQhChIiOFCvgwsbaMe8HPUuAH8r1+bBfftdh71XfpYTpjEbrj1Rk319
	7R6RiHWDGsA==
X-Gm-Gg: AeBDietMlVw9ESZsG9slvjKJFkqxZELfGXhn/M+2XXsbWn2Qm2gywweJ3e7LJxP2KiG
	uCgAS/Ztqvpn08aN2qOMcifxaS59GvrpC5Ce051mxP7BB51fLky7M2vNzVV8bNsxJiO5p4ZKqR5
	Y31jRC3Dxb4vYipYh3YryaOTFA6RCNzYYAYQhfAFXFEs9bQeVCF/dlfD+MMCb1ZgGf1Da89WcZu
	NrXp4s+T3F2l3J8xqgE/MMs6PuI4knbcS3cWEEXFT5o8sog44XfA5ym3B1GZ+V+Gr/T+rLw2lrp
	wqmn/ssxu1OJsiozFGW7lsr33w7tL75JEqguR6WpXWHn2NONGZlcqPOh1DglRlaoFAKFsE9/nc5
	8D7bgNLER5F+wuJUinjYBd6CmbfVis210nvIDz5cvymjuaVNlsyCYot/CB1nlzumtG3YhmPvJpu
	9M1t1wVl1mG7Q+s9+XCTWrdBYjE5CJ7RY6aZkwkXMyOj5SJIOOe3qk+Yv5TgDCoEXlHAwKV3mbi
	huBtsIsY/C0HDZEwMh3
X-Received: by 2002:a05:600c:1e8b:b0:486:fbdb:b718 with SMTP id 5b1f17b1804b1-48a98674e70mr150749355e9.25.1777896966413;
        Mon, 04 May 2026 05:16:06 -0700 (PDT)
Received: from [10.211.9.114] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a981defb3sm34368413f8f.20.2026.05.04.05.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 05:16:05 -0700 (PDT)
Message-ID: <cbc92665-c340-4827-980e-f36a6dd9ec8e@kernel.dk>
Date: Mon, 4 May 2026 06:16:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] io_uring UAF: io_uring_cmd_issue_blocking missing sqe
 copy before RESIZE_RINGS
To: Carlo Conti <carlottoconti344@gmail.com>
Cc: io-uring@vger.kernel.org
References: <CAAiJJe3rVHjEO6yZ=w6S0igYFE8ROBay+An7PnuMX0KndxwXOg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAiJJe3rVHjEO6yZ=w6S0igYFE8ROBay+An7PnuMX0KndxwXOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 752D74BCCD9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13229-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On 5/4/26 5:59 AM, Carlo Conti wrote:
> Hello,
> 
> I have identified a Use-After-Free vulnerability in the Linux kernel
> io_uring subsystem, confirmed on Linux 6.19.11.
> 
> The primary finding is the UAF itself, both a read and a write
> primitive have been confirmed experimentally. As a secondary research
> step, I also attempted to build a privilege escalation chain on top of
> these primitives. The LPE reaches root but with a structural
> limitation described below; I am reporting it in this state because
> the UAF primitives are reliable and independently exploitable, and I
> believe the escalation path warrants further investigation by the
> kernel team.  
> 
> --- ROOT CAUSE ---
> 
> io_uring_cmd_issue_blocking() in fs/io_uring.c calls

fs/io_uring.c hasn't been a thing in many years?

> io_req_queue_iowq(req) without first calling io_req_sqe_copy(). As a
> result, the ioucmd->sqe field continues to point to the original
> sq_sqes buffer.
> 
> If IORING_REGISTER_RESIZE_RINGS (opcode 33) is issued immediately
> after, io_free_region() frees the old sq_sqes page. When the io-wq
> worker is eventually scheduled, it reads sqe->ioprio and other fields
> from the freed page ? Use-After-Free read.
> 
> Additional issue: io_free_region() does not call zap_vma_ptes() for
> single-page non-vmap regions, so the userspace mmap of the old sq_sqes
> (IORING_OFF_SQES) remains mapped to the freed physical page, providing
> an arbitrary write primitive ? Use-After-Free write.

Can you expand? Seems unrelated and also unlikely to be an issue, unless
it's missing something explicitly.
> 
> --- PRIMITIVES ---
> 
> UAF read:  confirmed. ioprio=0xFFFF written to live page before RESIZE;
>            worker reads it from freed page ? blkdev_uring_cmd() returns
>            -EINVAL. CQE ud=0x2222 res=-22 observed.
> 
> UAF write: confirmed. Arbitrary write to freed page via stale PTE,
>            verified with sentinel probe (new mmap of IORING_OFF_SQES
>            does not see the sentinel written via the old mmap).
> 
> --- LPE STATUS ---
> 
> Cross-cache struct cred overwrite is blocked by a refcount invariant:
> vm_insert_pages() increments page refcount 1?2 at mmap time;
> io_free_region()'s release_pages() decrements 2?1 (not to 0). The page
> remains KPF_MMAP=1, KPF_BUDDY=0 while the stale mmap is open, so
> cred_jar cannot allocate it. Closing the mmap frees the page but
> eliminates the write primitive (fundamental mutual exclusion).
> 
> A fully unprivileged LPE would require a second independent write
> primitive or a different victim object. Current PoC achieves root via
> a research-context SUID binary to demonstrate the primitive chain.

> 
> --- REPRODUCTION ---
> 
> Requirements:
>   modprobe null_blk queue_mode=2 submit_queues=1 home_node=0     completion_nsec=500000000 queue_depth=1 discard=1 size=1024
>   chmod a+rw /dev/nullb0

So... you need to be root in the first place here?

Since a) you need to be root, and b) you sent this to both the public
list and the security list, why don't you just send a patch for this?

Taking security@ off the CC.

-- 
Jens Axboe

