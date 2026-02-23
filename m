Return-Path: <io-uring+bounces-12382-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uO7LBYVhnGkoFgQAu9opvQ
	(envelope-from <io-uring+bounces-12382-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:17:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADE1177E87
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D626F307E86A
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DB0281358;
	Mon, 23 Feb 2026 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ct9ndkmy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD15285061
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771856098; cv=none; b=rWfSjaq/k/DCBItAAg5bTY16ZFib+yB8w+lGDdg/euBGIwucuuh+1LqqnBIXNOkfo3rS6qcBwUxLV9v1c1JYLk+j3yGkwMjWyY7YQ6l3XohL1ERgX7KMfQlMBn3oA7Wz7l6bgfrFhhewPlcQMEvnd6LL8sDB1mNfrnITW16rX90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771856098; c=relaxed/simple;
	bh=H2jrWjwNR/gUdKONLXS6LvcNwyFd90yQbxCggKjpgV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AxE6dG9Rn62wVBltuy72xZZ7rRkO4W0DMs2vvrHk0Ny+/VDhRKCkHnwCpupTFdK8Eff9fL+Q40CCWwU1q09U2MviIiwhkLH1s5xHWdIWAe1S8pBvaFAwds1HDcDyM3fwpfNf/1xbt1wtjl/9Wg/hGZo8zU2pNkn/iZSKbVOXt9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ct9ndkmy; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6799774d0fcso2481460eaf.3
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771856095; x=1772460895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=85tbePhfgcNJBXnitvJ3AoABj6IMgYNXONGM7ClTMEM=;
        b=Ct9ndkmyd/O1K7daR57aLTu9S7Fmj7NNyVTgCrxvynmhvWp3SAZBvjgJRfWR0xC2j4
         ZATPyNy3fyLqPsFilE6dmPlcMjl+b4nkFKl8ONd7Iti67IiHoEeCWRhd8XfOdRhLb/1V
         XAIZD4pjy5wqLVoKJCQ9vB2b6NoEU67WmoXgOwBMgsP8WxRY/39A6Idm67SaSd0mQp4/
         YMavf3Gqa+Mixe13hv6NF+8x2/yfYRmljKKC19o2KVatM3sk9nqZhmA/KxM9fHu9gCsA
         x5DkQGdgpRTxDvCvDqPv2i4Fn/lMPvwpSpA2a6wPg/yrTo4tiX+kEow8SO8FZ3TPTTe9
         Ad/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771856095; x=1772460895;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=85tbePhfgcNJBXnitvJ3AoABj6IMgYNXONGM7ClTMEM=;
        b=OzPfq0tHFeLzk4c6glII5C6n1c/A89Jnit3ZG6XeRc3fZEy2toEdLtpXktiZ1um8Mt
         ohJpGsTNs6Ue3gPuYm8qBXbXwL5XdaX8rSS52CXiWoxcfkp5TqUZmGbleC2nhdKrxKt/
         5twVefgmgHohh0H+unXwTvjy6T4nBDk9ikXg43tckXI+fP+vglcR3FNKvuRdeI2Cve9V
         SOE+rpzinThV0BYH//3J+MZzHP6XMwISlWYguzSspNy1ex7CgYPviywwMx75tPF5tpjq
         J6TlTR5SH67ROZkRYG5bA5Dyc3LcGh9OLWlS2UaqVZHffFDcf2saO0c5YM3aqE4CMZe1
         T82g==
X-Forwarded-Encrypted: i=1; AJvYcCXeB+dsEmn8s0TtuCXtuHQ3jotBUTGYFOVbhBOorq+4MsUQtxfLiIWGPXh9XTLlQoNz998cA3HChA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDQ91qnBUsH8zAOA5gNjWWerU0OYDqlMVrcd9qeWd6697jKSeY
	TjnAatnoTVK6CB4ansatu6fMeLfUMf9i+p7hUsuBH0Tq1I6+L22GROeEdA7Sx2ghyYo=
X-Gm-Gg: AZuq6aJWd2+fsUY3yKDSt3/Tf8/iZ5uLOPTwLRfD7KvvIRoF76ZMKRMx3fNqhgmoPhx
	IBiizO2ieoX94u3Wd8aUAghZPRfRfXY6uJleEKtD+Y/MZWyK7GUiWrCO7lL3EcN/aGkaixEHNvA
	uQL1p3j0FXZqOeoTuueWcqhe8WGWycqoy68o26F7WlLy68/1fqLOYDR4pyCuXfv53RjCTqIdz8O
	iIGTEmetUuTy7vs3/pjhOGjU/5AMBHZL+rNSVIUkHC93h96dACdQilXC7CCE/+u/rdVNjY59vP9
	d1JdH/onK7EM4TiD48lkB3poiaCRlYK87u9MNX8XCFN0teW8wSGHQ48+ZV+0hZD+cnt9zgWyUpC
	WK7OYiUWfRMj1asFnxmLgFC9UgqE1v+SIFHWuel5vQTd5pxZl3i6IqNrlnaHASds2DZUBXnt4Bh
	iBT7f9RAgAMkYlYlKRlGsCh9h2eERYsD76O7CJTxqeiPl13nLO7Hbcdu2tGFSIIp4EBdtuUk7LO
	hBa75RTwg==
X-Received: by 2002:a05:6820:1624:b0:678:7fa2:aa6 with SMTP id 006d021491bc7-679c450719cmr4818167eaf.57.1771856095672;
        Mon, 23 Feb 2026 06:14:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4157cfed28esm7460837fac.9.2026.02.23.06.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 06:14:55 -0800 (PST)
Message-ID: <9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk>
Date: Mon, 23 Feb 2026 07:14:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] extra io_uring BPF examples
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1771850496.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1771850496.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12382-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 6ADE1177E87
X-Rspamd-Action: no action

On 2/23/26 7:11 AM, Pavel Begunkov wrote:
> NOT FOR INCLUSION
> 
> Alexei asked for extra more realistic examples. This this series is
> based on top of v9 of the io_uring BPF series and implemented as
> selftests. There could be more, but I stopped with 3 that should
> give an idea how it'll be used:
> 
> 1. A QD=1 file copy program that show cases state machine handling.
> 
> 2. A BPF program rate-limiting the number of inflight io_uring request.
>    That's a good example of what users asked for before but seemed to
>    be too niche to be plumbed into the main io_uring path.
> 
> 3. A toy example of how BPF can interact with registered buffers.

Let's please keep examples in the liburing side, where they can be
with the documentation too.

-- 
Jens Axboe


