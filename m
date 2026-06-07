Return-Path: <io-uring+bounces-13625-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id v0h+Nm/BJWriLQIAu9opvQ
	(envelope-from <io-uring+bounces-13625-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 21:07:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C10651573
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 21:07:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=vKGo0pP9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13625-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13625-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3EFB30015AF
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 19:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536CA2EE262;
	Sun,  7 Jun 2026 19:07:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B6623AB81
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 19:07:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780859240; cv=none; b=VEggQIJ0TnWLdY274v65fX4XbSD0DMmeLMFktVw2ylGow3dvul7tizhNDz7BQZL7YKjFVRNKPN8ETjy8yQwwa9heEICWlKdzyqE3IlKhZGVcvHo5hdqtRcRTupaJ9qsnTbgb3QaHZ+dNvFtyvHMsLVQiqWy9eVIeFzVI8aOutFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780859240; c=relaxed/simple;
	bh=Nv+IuUeu7QHUcyDigJjy/119CXZqiZ3izQIWywAjeHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZKdSVMgqk6H8VASqOTsRo5cs+p/U18XIYbSU060Eu6xxPC0VKXZvUhN0yelBjj0iDhgTp+OZGPkGto6b9Xc6IleAcVA0hV4QmW6eJLyy/oIH/5RljYFKDnIgPH0obR7ngQ8mXWju43DU6My/hqkbI2HdWe5V8lHSDy+3/xLNYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vKGo0pP9; arc=none smtp.client-ip=209.85.167.182
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-486503ae8f0so2637626b6e.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 12:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780859237; x=1781464037; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eokQC1Z5vs2eUgGBLXd9scSPkjDARsD4VafD1xgopGI=;
        b=vKGo0pP98J3wrPoIQeX22bcIWk7sxCVVnFCm5I1Pb4Ql0zF6bfofupnzbNySSR15TB
         0IYVwcOuCBuNONayQRCMyCbQNn/pRuobr0KzcQu2xTmYy+0Qrj+aqS5R6jf1RS5XKsgt
         sUcL2TimzhcJ+ZLA8EuBQRG5oEDa+0DfZTuVp0v4e1oEMJ7U2wNmAc+F0xb66bpUfv7T
         pMLt5WjwLuH+nsfaJ2DfV0fHk0Ju9RtCVAFV3wv91z8ejWSxRaVnRb0PlgY1TyhWWB+k
         P57YsqPPdqe4NFd2o5UM7NMm0vqL+OI1jhLYNtlVe42k+YUpwREnV+xAg+Nqc/reKCBc
         gkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780859237; x=1781464037;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eokQC1Z5vs2eUgGBLXd9scSPkjDARsD4VafD1xgopGI=;
        b=m8L4Q5Y9BPQcyLR8Ta8J/mtNswsltkF6mub0Ls2PQ8jCBwD0Rfdb594uLAntOoXo3K
         wnV/57sbAmoy0HnZZbDATsoQrs2Tf5D+JxUAkSZdlEsbUyCXBygYnhN1iKmGB3JXLU2v
         chtGDmE4EUeAW147IYEjk7JgmEoAZpBiz8mtFwguWIUI3tvylxsm7UylfFXB83vUToMT
         eq6IKZHoEZWgAdmG45PwUkbf721afN/8qpA79H1jyPCJnJy/4F7y4lnPAteDHrXqc2gU
         GKg7u2Vz14OBH2z3iBYGvdmHbMMC/GXIWUmn/Py8j1P8FSv5eQZ4/rqkhR1yRxLN28wp
         9Slg==
X-Forwarded-Encrypted: i=1; AFNElJ+9Dz6ZaXxp509LcwKZFssZcGitObCIhEkDaUBVEsqlwLBtT0xnt9bD8+EUgK17DLbGL2O/jnGskA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCicFaSVlQ4GSvTPuwjs+NaB6S/wuNkQ4pHp4lWIat4efnMRRe
	DuH0kA8aQSOmFQIPb24wOlIf0gyMWgwuJ6Wr8r1YLgJvRBJDhW+qavzmnPqRwgOXa7/AiG+4h2Y
	qn2xw
X-Gm-Gg: Acq92OFYrq3GaCbWl86VtvUksihyTjzpgnBPfNvNSqyqqklYZrXDlGnuITaJY/D3O6x
	u3Da3w9jfbe0vIHa2UZWjYZDKyPwsFryMH5BG8+PvmzYw1npPjZhjihaucrJIGMpg25dy2lYQfK
	kSPJM70RFCWN/dB5mBe/L1sdynvIzxFCVdSebjOeu1BQ8nozb34K4HQWE3CgQExhTsC5ymNoEoa
	UkQF9FDv+ZTdtvvBnzLNCGCH+MImGE/lAU1QJxUu2gosioHuA02pu2Id/G0nALBCocMsXGSJbkR
	s/ubQS/+rnhMWWZy6ERb9xqIOc0yeGj2ESZh+P9mpb/MU08Ipiomvrv8T0NrMNk+IcobP2Uz+F6
	Ihczv6Al1X1NAmwj2FOklQuTXiQhHIcpRWh2rxY0zsCavgpY5sHPw94BnnsEt0SmzwQaR5hwUPF
	wxGFEWf6x19gPOOx1zPwd1rlz3BjZpPW4jqN/b9cA8/6d5F2cIUwFLs+lqpqywB23rUSFgmohaS
	HdMlQUDCqvJWvsmmdHQ
X-Received: by 2002:a05:6808:1991:b0:467:281e:3d85 with SMTP id 5614622812f47-4868def7241mr6781474b6e.29.1780859236808;
        Sun, 07 Jun 2026 12:07:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b91ead7sm12254490b6e.10.2026.06.07.12.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 12:07:15 -0700 (PDT)
Message-ID: <71417fb0-4060-4823-8e4f-f216ce0235d4@kernel.dk>
Date: Sun, 7 Jun 2026 13:07:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink
 non-INC pbuf ring len and affect later READ operations
To: Federico Brasili <federico.brasili@gmail.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13625-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:federico.brasili@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:federicobrasili@gmail.com,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:from_mime,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C8C10651573

On 6/7/26 5:41 AM, Federico Brasili wrote:
> Hi,
> 
> I found a reproducible io_uring provided-buffer ring issue on Ubuntu
> kernel 7.0.0-22-generic.
> 
> A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
> ring can persistently shrink the user-visible buffer descriptor
> length. The modified length is not rolled back when the receive fails
> with -EAGAIN/no data, and a later unrelated io_uring operation, such
> as IORING_OP_READ from a pipe, consumes the corrupted length.
> 
> This is not a demonstrated privilege escalation. The demonstrated
> impact is deterministic unprivileged provided-buffer ring metadata
> corruption across unrelated io_uring operations.
> 
> Tested kernel:
> 
> Linux ubuntu 7.0.0-22-generic #22-Ubuntu SMP PREEMPT_DYNAMIC Mon May
> 25 15:54:34 UTC 2026 x86_64 GNU/Linux
> 
> Summary:
> 
> Create an io_uring instance as an unprivileged user.
> 
> Register a non-INC provided-buffer ring with two buffers:
> 
> entry0.len = 4096
> 
> entry1.len = 4096
> 
> Submit IORING_OP_RECV with:
> 
> IOSQE_BUFFER_SELECT
> 
> IORING_RECVSEND_BUNDLE
> 
> req_len = 1
> 
> MSG_DONTWAIT
> 
> empty AF_UNIX SOCK_DGRAM socket
> 
> The receive fails with -EAGAIN, but entry0.len is changed from 4096 to 1.
> 
> Submit a later unrelated IORING_OP_READ from a pipe using the same
> provided-buffer group with req_len = 4096.
> 
> The READ returns only 1 byte, because it uses the previously corrupted
> entry0.len.
> 
> A second READ then consumes entry1 normally and returns 4096 bytes,
> showing that head/bid accounting remains coherent and the corruption
> is localized to the poisoned descriptor.
> 
> Observed output from clean unprivileged reproduction:
> 
> [INIT] uid=1002 entry0.len=4096 entry1.len=4096 tail=2
> [STEP1] RECV BUNDLE on empty socket, req_len=1, expected CQE=-EAGAIN
> [CQE_RECV_BUNDLE] res=-11 flags=0x0 user=0x1111
> [AFTER_RECV_BUNDLE] entry0.len=1 entry1.len=4096 changed_buf0=0
> changed_buf1=0 guard_before=0 guard_after=0
> [STEP2] write pipe bytes=4096, then IORING_OP_READ req_len=4096 using
> same pbuf group
> [CQE_READ1] res=1 flags=0x1 user=0x6666
> [AFTER_READ1] entry0.len=1 entry1.len=4096 changed_buf0=1
> changed_buf1=0 guard_before=0 guard_after=0
> [STEP3] write second pipe bytes=4096, then second IORING_OP_READ
> req_len=4096 without republish
> [CQE_READ2] res=4096 flags=0x10001 user=0x7777
> [AFTER_READ2] entry0.len=1 entry1.len=4096 changed_buf0=1
> changed_buf1=4096 guard_before=0 guard_after=0
> [RESULT] PASS: unprivileged RECV_BUNDLE -EAGAIN poisoned pbuf len and
> later IORING_OP_READ consumed the corrupted len.
> 
> Why this looks like a bug:
> 
> The failed receive should not persistently alter the provided-buffer
> descriptor in a way that affects future unrelated operations. In this
> case, a no-data/-EAGAIN RECV_BUNDLE changes entry0.len from 4096 to 1,
> and that corrupted length is later consumed by IORING_OP_READ from a
> pipe.
> 
> The suspected root cause is in the non-INC provided-buffer ring BUNDLE
> selection path:
> 
> io_ring_buffers_peek()
> if (len > arg->max_len) {
> len = arg->max_len;
> if (!(bl->flags & IOBL_INC)) {
> arg->partial_map = 1;
> if (iov != arg->iovs)
> break;
> WRITE_ONCE(buf->len, len);
> }
> }
> 
> The descriptor length is modified during buffer selection/peek before
> the receive operation has completed successfully. If the receive later
> fails with -EAGAIN/no data, the buffer is recycled but the modified
> buf->len is not restored.
> 
> Additional observations:
> 
> The issue reproduces as an unprivileged user.
> 
> The effect crosses io_uring operations: RECV affects a later READ.
> 
> The effect crosses subsystems: socket receive affects pipe read.
> 
> The second READ correctly uses entry1 and returns 4096 bytes, so this
> does not appear to be a head/bid desync in the tested case.
> 
> No kernel crash, OOB write, UAF, or privilege escalation has been demonstrated.
> 
> Expected behavior:
> 
> If IORING_RECVSEND_BUNDLE fails with -EAGAIN/no data, the
> provided-buffer ring descriptor should not be persistently modified,
> or the original len should be restored during recycle/rollback.
> 
> Actual behavior:
> 
> The failed BUNDLE receive leaves entry0.len shortened to the requested
> length, and later unrelated operations using the same provided-buffer
> group consume that corrupted length.
> 
> I can provide the minimal C reproducer and full output if useful.

Please do, no point in me recreating one for it. Then it can also get
turned into a regression test cor liburing. Reproducers also mean more
than a thousand words in an email, it tells us exactly what is bring run
and what is going wrong. Or in some cases, what the wrong expectations
are.

-- 
Jens Axboe

