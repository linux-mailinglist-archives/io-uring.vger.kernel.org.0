Return-Path: <io-uring+bounces-13527-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KNiLLcXF2px3wcAu9opvQ
	(envelope-from <io-uring+bounces-13527-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:11:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9B55E7839
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BBFCB302593A
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4253CBE74;
	Wed, 27 May 2026 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="p3PoEzqv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F583803D9
	for <io-uring@vger.kernel.org>; Wed, 27 May 2026 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897812; cv=none; b=NIKD1kSpPn6EveL1VoHoMW3LjVJvVUO8d9kupZfF6rwFS1fTEeDmDMV5xYTzJ0ohJhHovHavPG4MF+5dYBTwOncrNvuptgginz7wk0Lt4351Q3AYW061NMp40DgTFfw/GY0JFuczg1yRgHzItAsRj09Lg0Ktoe/VjwAQrWtbzSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897812; c=relaxed/simple;
	bh=jfHYVvAv2KLPbWszFU9UWn6gSBGjDMujZa9kYNQiUyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSdTIApOTihn90vYiCTOTZeT6GxEbD/UHKc5cVnogTgCM3oSOi+Jh60wYPjB4iMb5+rU3cZJfMYk2HJTdFXrSCQeCixQxVQiDgrsRfv5DyZX+EtzNkw5iqBPospbmVW6fbXGbFhtrcVyzZDub+dLaQMU9mBzeP98F9s4V0sk3f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=p3PoEzqv; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7dcdaf06498so7685854a34.2
        for <io-uring@vger.kernel.org>; Wed, 27 May 2026 09:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779897809; x=1780502609; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gntijPqsvuiGRryRGaewxCELZ5a6Qr0krHV7SCIDMB4=;
        b=p3PoEzqvIwCDKqu1d2DE3TstqFbMSY6eCzEUZ4nAjFKTII7VwecNYGybvd8CjXKkC3
         tsupMB/EID6Aa2HQeld19Q3tlb2tUw8wfiMKcODRX1Y6d6GEKvv4g6tprpxzq/YzwO2B
         gXeMDo5zxBSGLho53SSlLAn0B2rDXwcFzs+S5K939WEcgO5+DE0T0oJUZO4CSqnf7tA9
         8BxHBE+WPwFLpQd1aVCL3T89ed8GUP79mY17chmOQWYDx28TS7o2ju0jadAWemuyQJ3z
         PqJp2cEqb5XVt4hcD13u5AqmxVszUsy8oviQCzXSJbpOSiS1/WwddFRRuBDymuKCC6EI
         6hOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897809; x=1780502609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gntijPqsvuiGRryRGaewxCELZ5a6Qr0krHV7SCIDMB4=;
        b=C+5yAG7Jbvbrbb+RjNzxu5VUsYuI5ADnpjbUi2mSgoMiuMYaELZw4Xst/3+15/jj/E
         4bkVEI2YRdk7kHwu21gx7+Kf4v/fPJmCGqIw+T2mNw/mOLD/orpY2eSJZfU/6ujWTJwN
         mV3RiqaecQEXpWnQ8cdfMQ77INWp/9sxzL5+42POvSOeL+CymI/EZTEuM1pcoPslCDR+
         9V62MuBW999XPvV/nn/nvj2MVlcOvEUamUS8fiskSrPBoCjnqlQ7bPdG3rTsZprCs7FU
         zFwVczxcrg4GRr0vlOiRFDy5COc04+vF+HQr/VS1wJuaOQwyNMoliSWx7hhGJPDQxUT8
         4jsQ==
X-Forwarded-Encrypted: i=1; AFNElJ9rNepfbCv38g20/nqKta4gfspFHlvo0OfXX3zGTcbUGhsyJhSHEJwAEwYxQL+pVUmFx9xztmRIeg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz91j/TkSoYpPaFcrDCeO7FvBQ70u0l+s0rjsUkvMIY0UwLdrNm
	maQgY6q5QnyKh3YWhBL9f0//cSGuP77xeSlaVd4SIzyR5hHtscfNPNs6Oo7/VsAtWfM=
X-Gm-Gg: Acq92OEqRIsRVm5qBaoAxqb7a+trdAHaEoYWFJIZ4W6ZPBJwkeWa7pF3fiVsqShu7He
	g4TS7WjJSKQTC3f8Rx+6D6ZhkE+fMObve0llnYL/oAs8m1NBo0OWihIlDjgki7WJ0ZNj4AYYwy3
	3gYiw4rmxMBGQwpk8ryEkcEYcwlY4yIpSo/LRukwMTT6OEyM7szacv27U8dXoe8IMPo6h80YRe8
	l+XRbjiaXJ5WvUUiApdnLC5WgmQEakvR3mWdiUO462DrplFBSzjoj9T1P7K6C9xK4MCms/VDNuw
	4Hx14cAicc55oVfMJAToKv1r761FY85DyR5PMd9JzZJibGS5lgzRsdRA0/WdAwEBntsTveiwTs6
	LJq5v7N50yKREDZf6zkdyoVWKW15giMFonqfMHe4mGID/fK1T3P5on3pmWZFP9LAlhEufN3hC0z
	T3VquAK6kVi6r2eM2T5fEM27gEHq6AC0d/URcMxvCr04pesR12REQFxqcSMJMMs/qxLUicPhe9R
	EjYxmNklCNvpmzSoY8=
X-Received: by 2002:a05:6871:4390:b0:43a:f95e:cf14 with SMTP id 586e51a60fabf-43b5aaed6f2mr14617454fac.12.1779897808999;
        Wed, 27 May 2026 09:03:28 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639f3609sm16097799fac.13.2026.05.27.09.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:03:27 -0700 (PDT)
Message-ID: <919d86f3-1164-4084-9f72-d3ead0522c5e@kernel.dk>
Date: Wed, 27 May 2026 10:03:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked
 work item
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
 jianhao.xu@seu.edu.cn, stable@vger.kernel.org
References: <20260527143726.1272269-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260527143726.1272269-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13527-lists,io-uring=lfdr.de];
	URIBL_MULTI_FAIL(0.00)[kernel.dk:server fail,kernel-dk.20251104.gappssmtp.com:server fail,sin.lore.kernel.org:server fail];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: AE9B55E7839
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/27/26 8:37 AM, Runyu Xiao wrote:
> Commit bdf0bf73006e ("io_uring/io-wq: check IO_WQ_BIT_EXIT inside work
> run loop") fixed the obvious case where io_worker_handle_work() took one
> exit-bit snapshot before draining pending work, but the fix stops one
> level too early.
> 
> io_worker_handle_work() now re-checks IO_WQ_BIT_EXIT in its outer work
> run loop, yet it still snapshots that bit once before processing a
> whole dependent linked-work chain. If io_wq_exit_start() sets
> IO_WQ_BIT_EXIT after the first linked item has started, the remaining
> linked items can still reuse stale do_kill = false, skip
> IO_WQ_WORK_CANCEL, and continue running after exit has begun.
> 
> That means the previous fix did not fully eliminate the exit-latency
> problem; it only narrowed it to linked chains. A long or slow linked
> chain can still keep io-wq exit waiting for work that should already
> have been canceled.
> 
> The issue was found on Linux v6.18.21 by our static-analysis tool,
> which flagged linked-work loops that snapshot shared exit state
> outside per-item cancel decisions, and was then confirmed by manual
> auditing of io_worker_handle_work(). It was later reproduced with a
> QEMU no-device validation selftest that preserved the same contract:
> a three-node unbound linked chain, an exit actor setting
> IO_WQ_BIT_EXIT after work1, and slow post-exit linked work. With a
> 3000 ms delay injected into each post-exit item, the buggy path
> spends about 6066 ms after exit running work2/work3, while the fixed
> path cancels both and finishes in about 2 ms.
> 
> Re-check test_bit(IO_WQ_BIT_EXIT, &wq->state) for each iteration of the
> dependent-link loop, right before deciding whether to cancel the
> current work item. That closes the remaining stale-snapshot window and
> prevents linked post-exit work from stretching shutdown latency.

I think this change makes sense to further cut down on the time, but you
need to send it in for the _upstream_ kernel, stable only does backports
of those. Eg if you send this one for current -git and mark it fixing
the correct upstream commit (not the stable one) and add CC stable, then
it'll wind up in stable as well.

-- 
Jens Axboe

