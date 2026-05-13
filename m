Return-Path: <io-uring+bounces-13318-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UFc5OHYPBWrvRwIAu9opvQ
	(envelope-from <io-uring+bounces-13318-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 01:55:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B0C53C296
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 01:55:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40BDE3022563
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 23:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD383CB8E2;
	Wed, 13 May 2026 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="g5xNXmgT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111AE38D400
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 23:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716532; cv=none; b=YoXJCr4LtzatUGOqiJOkYiubgFhNY66S3fhdPIfRIEFeKyFyNCpaUWvWfBSCZvhH9LtNKyiqEnZwQ2R0MmfrPBAu0N6+MDRSigoObsdLY1d8y2aGZj+VvXM/94Gt/qsIl14/l2DazGzkoED+fSc+DexKSqa/HTVP5c/wg8Rvodg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716532; c=relaxed/simple;
	bh=/VCUPSYTwU5lk68z074TX5RVkw/mp+1Mh5MFOSlSLbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUtAi/8uQ/2YSIe2LMnRcVGwDoUpZTZfjboNb0ZXNGZe+9kyenN798Qoo6A/nBRLIjWqhkCeHc0nJcbrYyBHrsKEtsctHQULwj4KbUxwAzz/3l6vwYvgv+eo0FzAhWuJN8RxgSrRgpIDsXVzhTaHfSC4E89t9sv8mO/9ZIY4ZTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=g5xNXmgT; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7dbd23bc684so4207181a34.2
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778716529; x=1779321329; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+STMRzOjKsrkBq3aIptVEGpXFmaW8TA3EJXL5xx0koI=;
        b=g5xNXmgT9jfKrr0ppNL4gDriac8Ul99K0PQgHENCnhk26Ox6t+i2SlTSG/4Y8MHBqz
         8dkPWYIYharw5AlAnGdYgyQbvBC+GOGhhLyDANm7FWOWeDHoMKFOTQfCjN6XlSFNBr8d
         33+JATRELd+6FIPeEhCBFjTYAXweIIoX61LgeNuzB7QKpggjR0hHo7ZR2cHb1xtoUJ5g
         NA9OD5i5M+I81WK1F3CukAqPHvG3Bjv+pBPsl74OQFdKphIhpMfj9Mle9+mlRl/ekEyN
         4h3etwCSeAsU9J1MpUzZbVmeYIzluCCkxZf4JFbb8Z9Uhny88Lt0y0v3z7IrFZX1+hKG
         TSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778716529; x=1779321329;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+STMRzOjKsrkBq3aIptVEGpXFmaW8TA3EJXL5xx0koI=;
        b=gyxKy0OayfHshNDmW6/PFgkUQCzV4yvLKu1sKkVKk9ZHZunOWKhEJtAOMQN/uWEAq+
         OM+pCE4+4OBt5fi1c3/1HGsjO11Go1+yf2LUW/Z3OyAEcY4gV5PxfBBnQHRxev3o9ZK9
         rFLsiQDMbHKI41D+agjUDfZCCXGTyQnaKvuxaZrye2xVF28FxoZF2uRceFxnexas/Moy
         wZYbOoQhsx1H5pjXNjguKRwHrtclXC126gKumr1mLsRh/s+M6aq3F/epHBIEkhBlYdZh
         o+CrtcHOCRoahZu//chSaIqhEzKgsVS9UoQFYJo+ekyKB1/45lNrERxkd50uQScotlfF
         hRGg==
X-Forwarded-Encrypted: i=1; AFNElJ9Ii87MP7PPYsvMo1EfI1Dbw1eKml/SEwf4+zUjFI7SUU6oMmjErjbl1Uk+Yjz/+u2vmxhTeFJp3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUPjEWy2t+6JxMP3SpwzQf6dIixQTCsqs1zG9B6kFPPPUj8kDX
	XhykPiltP2vvrA+utI1lBOMPseJQraAKvLPPGvNnlUFB4Gvc7xNg2g/YcQEk/1sjzzg=
X-Gm-Gg: Acq92OGcQf27pzCXaROR3MAaEq0+NKcJH83F0jD289+PuBKkR4TEqcuMGaZOGheK21K
	jQGkfPD5Q7/QvOGk/p9JyAD+I67+iFOgnJUv9JaUmselvvhs5iKI0AU46BMDz8ILKdxFUK9/xUn
	JoKxZDzRvYu04R0hJ/8Qw6X6l69OyT8376fqyd1I7Z5fI+ZRdAzyTvs7WTIxNIAugcM21wqZyIG
	WrNDeQIKBO+TuxAgGBLvvEDexyDSPOnlC1xOeCARGL/ZVHn2Minp8Ob/AJ+QHeaSFNUGpkSHtyQ
	k50MfMdSjJyWmA6fO0puZrFxRRdyDaSPiRKMo4+GZj/WW09Jop2pciKXwi+x/c0TDQh9UYJP9QE
	zmZNrPY9lz4fInatuy4cVaLkesgHK9lKXo1XEyyUa/FnFMfUOkIIz6I8TNeEqCsct1N6Sw2Dlss
	spcbarQyiNR0rNuecB7VJ/Z3pZLxkpuirLnfQU6wgf4t81W/u8Vkj5RYdqBtLaZFIPdkS7PUbUj
	txiU1g2Yw==
X-Received: by 2002:a05:6830:3805:b0:7dd:e032:3cdf with SMTP id 46e09a7af769-7e3da49b6f5mr3549354a34.19.1778716529041;
        Wed, 13 May 2026 16:55:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e3f3e8b76esm679586a34.13.2026.05.13.16.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 16:55:28 -0700 (PDT)
Message-ID: <d1098d70-30ca-487e-8e01-b8537eb23ade@kernel.dk>
Date: Wed, 13 May 2026 17:55:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: use refcount_t for io_rsrc_node.refs
To: Oleg Sevostyanov <savant05@gmail.com>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <CAJv4CsvbaJd5GoHjYPzi3bgEO0fPT-3xj+UV7JMhqTyh2qr5tg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJv4CsvbaJd5GoHjYPzi3bgEO0fPT-3xj+UV7JMhqTyh2qr5tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 46B0C53C296
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13318-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 5/13/26 5:15 PM, Oleg Sevostyanov wrote:
> Hello,
> 
> This patch converts the refs field in struct io_rsrc_node from plain
> int to refcount_t.
> 
> Background
> ----------
> During a static analysis pass of io_uring/rsrc.{c,h} I examined all
> sites that touch io_rsrc_node.refs:
> 
>   - io_rsrc_node_alloc()     rsrc.c:147   initialises to 1
>   - io_buf_node_lookup()     rsrc.c:1117  refs++ under io_ring_submit_lock
>   - io_clone_buffers() x2    rsrc.c:1199  refs++ under uring_lock (lockdep_assert_held
>                              rsrc.c:1232  asserted on both ctx's)
>   - io_put_rsrc_node()       rsrc.h:107   --refs under uring_lock
> 
> All four sites are correctly guarded by ctx->uring_lock, so there is no
> present race or overflow risk.  This is a defence-in-depth change only.
> 
> Rationale
> ---------
> io_mapped_ubuf (defined in the same header, rsrc.h:40) already uses
> refcount_t for its own refs field.  Aligning io_rsrc_node to the same
> convention:

Because those can be shared across rings (cloning buffers), hence we
cannot rely on the ring lock for that.

>   1. Gives lockless overflow/underflow detection "for free" on kernels
>      built with REFCOUNT_FULL or on architectures that provide
>      REFCOUNT_ARCH_OPTIMIZED (x86 since 4.14).

It's certainly not "for free".

>   2. Makes it harder for a future patch that removes or relaxes locking
>      to silently introduce a refcount bug?the saturating behaviour of
>      refcount_t would catch wraps and emit a WARN_ONCE before a
>      use-after-free could occur.

You could just add a lockdep assert for that.

>   3. Self-documents the intent: the field is a reference counter, not an
>      arbitrary signed integer.

I mean, it's named ->refs, you'd think that'd make it clear enough.

> No functional change is intended.  I do not have a stable kernel build
> environment that includes the full io_uring tree, so I am unable to
> provide a Tested-by, but the patch compiles cleanly against the 6.8
> source tree (io_uring/ sparse checkout).

So in other words, you didn't even test this? And it's against an
ancient kernel?

None of that matters though, as that's a hard no on this patch.

-- 
Jens Axboe

