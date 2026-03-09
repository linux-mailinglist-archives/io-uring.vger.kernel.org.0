Return-Path: <io-uring+bounces-12588-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBL9Me7KrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12588-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C529239BB8
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF52730E0DCE
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97AEB3B8D50;
	Mon,  9 Mar 2026 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYe7FFZM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56053A8FF0
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062693; cv=none; b=nEgCViyR2d5ens2kH0vYODjjHFLMqHtLhEsvNFL1ilqM2qApT59YzWOQBFiovODzvCvVGOjaZeNNeKlbO5CVZPxishnD1WGvhmaMj1voZM2wG9hHIK1XX5n+dqHjNrhayKKoPJcvmIPyaAujyscrCps2xhuWfqihNwzQr7bUpcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062693; c=relaxed/simple;
	bh=H1ooMesOsCfbxy1JEoKTVjQr5MpOiYSVF2li1xsXq0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzGHYg0EDDMmu65z52QIBcqbYvrI3/bAKvEB57M4IapXtB5VyevtY9she8KwaMqHIaSYaxs/gDaTgfLbT5P2aM6UyCXXJv8xnyC942k5ZY67ibrdl3mG27FwADR5oHpB+gm3XcPfOR7JwF9c0qxNFDjiYxnorhaGWC6m2p1DE7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYe7FFZM; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso2254305e9.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773062689; x=1773667489; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NopvELTUWATJredMr0Zqp2HDVCba8weCOzzaoYoC+s0=;
        b=RYe7FFZMsfqpceSR9TNk99ORJHEryUyqXZTM3hDZXg5yuqDf3hyrwHKqada9m9jvD1
         73Pd2NFyAnaGtSPsmCcwOGr5emkhuyo+sGlG3wk22qoejULBtf0Lw/Y53ELMN6Hm5S0u
         +kXs3tZglTRbaPhl11x06tV6hH3iruZQVeT+nILQH5rOwbvM6NSfEyjW/PUiUxcCgr2C
         K70HDP0wvdUm/dTmniGzGRL+TCKou13Q6nlB8nplB9SQQf/iu843joJb+yIgDXr1EEVM
         hpc1RezO9z6Zh6fYC/28LgUZkjO9PjF5Abjmd2+1uz93l4rymMJ/WuBOvKkGOBe6QazN
         jr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062689; x=1773667489;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NopvELTUWATJredMr0Zqp2HDVCba8weCOzzaoYoC+s0=;
        b=dQduRyuIyR888NJK+pKn5xPey8uGjWENsvMA4SvVzpsHZazDFWdD+KMU1cD4WcgxDj
         I5+daE/143fnNPBE0/K39dqTHMnwxk7H1P0WJebU7Nx6LPnbMNGIWmP8+B3jOvAIEsMp
         pOsvrgtp7gTvL2RZF58AS3vDCNVKVRp7JLLKztMRYNtnJ076ZBuneWd7d3DiUj+k0SHI
         fGAaslD0VZCl93Wl4hvgmRqok1S8lxXL/Vn+Fg7PIXXPI52ZDL95042orRfJzyZmdjE4
         /Xeo7KwQzCFuGxakKGspuwxVZrVjmPaA5mzlvdLckWyK/u3xFvx7MpqNk1t8l+vU7l6E
         uS9A==
X-Gm-Message-State: AOJu0YwhB/fuIOLdeTYMz+Fcm/rSOkpmWTKmffFdjqoQIF8VHyC0bPeR
	lZ6MIopdyrbfUOLcgXrEj8QOu16pBhSj2tsEDgJWydjzYCoBCdA9mhi5QQSXFA==
X-Gm-Gg: ATEYQzwgXC7HZ5e1JGgrwehsr2Z5ZDCGcmXQ1skbxBCqv7QbtshqpcXBZInJ8v6dxUE
	sFUOKnr8MI8Ec+bu+mjSNkDm9TnhlLCUN1Qr61ICFXSGxbH9HsaNd15TWEbybYGcQr7yLnWqioJ
	icNTyxkzZEAVCi6F8KzqVuS6B+iarV4iSLQ/L0wOUWu1aCe76q0e3nTvKCi4FVraWn8G5AgRj0z
	srJWBUc+meqc6Le6tuATNryFBJ+cYCUjRcJmgdk5mOYrv/qz/CbCmv7rCugt+C+7EQC9IIDNy3z
	/QIKGnd4gfhuZpNILShFBoCx+L4X1nx2BW7lc9l57LHqNwxFRDGTh1MT7ySNkmUWSR+c5zdXMSt
	fVaHMWlSH7ykxloWL649Ewq3xU4DlXp2Tvm2xylDjEanK2uIAQsxG2bQRpg9cQMNNJoxW1C9PGy
	I9t8eFlonrEuqtcZ3fvPZneTt7AgrPCEi6S3RlyxqER1UdOl/pUJCDP4HFQmWQaxhs837sqeFPB
	2oZK8kvtjReP88gm9yzb0YO86XeQY17eALYHMnXY2WJFb59CAPmUd4sggyGWG3c5KkaVjyvk+GZ
	GQ==
X-Received: by 2002:a05:600c:820c:b0:485:383b:d5bb with SMTP id 5b1f17b1804b1-485383bd752mr74888935e9.27.1773062688489;
        Mon, 09 Mar 2026 06:24:48 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485358cd26bsm78402855e9.8.2026.03.09.06.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:24:47 -0700 (PDT)
Message-ID: <d8c8748a-4b13-4097-bdeb-495e6410a0df@gmail.com>
Date: Mon, 9 Mar 2026 13:24:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] BPF controlled io_uring
To: io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, axboe@kernel.dk,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1772109579.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0C529239BB8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12588-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.958];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 2/26/26 12:48, Pavel Begunkov wrote:
> Introduces a way to override the standard io_uring_enter syscall
> execution with an extendible event loop, which can be controlled
> by BPF via new io_uring struct_ops or from within the kernel.
> 
> There are multiple use cases I want to cover with this:
> 
> - Syscall avoidance. Instead of returning to the userspace for
>    CQE processing, a part of the logic can be moved into BPF to
>    avoid excessive number of syscalls.
> 
> - Access to in-kernel io_uring resources. For example, there are
>    registered buffers that can't be directly accessed by the userspace,
>    however we can give BPF the ability to peek at them. It can be used
>    to take a look at in-buffer app level headers to decide what to do
>    with data next and issuing IO using it.
> 
> - Smarter request ordering and linking. Request links are pretty
>    limited and inflexible as they can't pass information from one
>    request to another. With BPF we can peek at CQEs and memory and
>    compile a subsequent request.
> 
> - Feature semi-deprecation. It can be used to simplify handling
>    of deprecated features by moving it into the callback out core
>    io_uring. For example, it should be trivial to simulate
>    IOSQE_IO_DRAIN. Another target could be request linking logic.
> 
> - It can serve as a base for custom algorithms and fine tuning.
>    Often, it'd be impractical to introduce a generic feature because
>    it's either niche or requires a lot of configuration. For example,
>    there is support min-wait, however BPF can help to further fine tune
>    it by doing it in multiple steps with different number of CQEs /
>    timeouts. Another feature people were asking about is allowing
>    to over queue SQEs but make the kernel to maintain a given QD.
> 
> - Smarter polling. Napi polling is performed only once per syscall
>    and then it switches to waiting. We can do smarter and intermix
>    polling with waiting using the hook.

Any comments for the patch set?

-- 
Pavel Begunkov


