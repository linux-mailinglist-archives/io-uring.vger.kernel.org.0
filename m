Return-Path: <io-uring+bounces-12641-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNvRCOKGsWmjCwAAu9opvQ
	(envelope-from <io-uring+bounces-12641-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 16:14:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 50AB926637A
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 16:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DBD53044803
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 15:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B943DFC98;
	Wed, 11 Mar 2026 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wQcj484q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C43E35DA60
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241982; cv=none; b=m2QV3KY94poJuK0E/NJ0npM7jsgD2ZcgHvGBWUj3+8KACBGa2TjY/LKYaPaJQ0oiKE865po1g9CtbfNbNGz9I94zbFMzU24ifrd+5xcjEVqQJIBwTa834A3t+WpmhN0Dzr5ck9ZTYxOiC0yY1aaD0b/T/rzjH4rB+nU/Fdh0Rto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241982; c=relaxed/simple;
	bh=5DuFyHHqEMjIoFGEOiSxVJ/igeUI7XA532Umf+smAG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u+i1CFBCCLz4OjIjWA9lakhJ51RHxjKNDOcCSy2h+kRGVuDOZ6HftXWa6DuLS/YAmIGHJx9cU5bUjSWO5QdLblS1d+qmS8EzKfV9OpiuN3Fij8URapVALuMpBqI7PglqwWpFxcqeEr+3ikPX1DU9TQ6nMTSxSbofRq/Dzy06A4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wQcj484q; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4671119c1c0so2005753b6e.1
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773241978; x=1773846778; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=StVXwXUiwmDhCD4t1rrg/FzYEdaFBzAlLdNdaIIhxwE=;
        b=wQcj484q3MdoF38hyzp4bV56fOsZ/IMIXIyrpw1z1mRuaNQn/pymLSERxo1TT2C5z2
         C21APQVfLIOCCO5ucTgkdHrdxxJJ0Y4xTx8tHbEmXdebzYGyxVugvB9RcAaYxPccCBk8
         ybTS1wgNBb1832+jRTs8P/vuxagNHWd/eofM7klpz8CGQzNNE+aT+nMH8eMLW3ZC1DO8
         KqrYp5lX43ZzJ17xwX7/sogGHd9n+/7t5zO1nXRju2poEv38PMtEzZug9BuaVoYc3Nb/
         V5fZb9SYr5Danf93HlEjHZskBNkQEntduSFjlyzgAb4zHNU1Y2oEgdgwziMJlvw0fCVP
         lwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773241978; x=1773846778;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=StVXwXUiwmDhCD4t1rrg/FzYEdaFBzAlLdNdaIIhxwE=;
        b=SU8T+8NRaMormtBDdoGp8vK+TsUIKnbZ+r3WD7xyN7knau+Tk5N0iXYhmbjkm1PL3C
         zEzwbjJVZvsY/AemSJfLKyXtMY12/OOThOq2fO2Zgr+d+Otk2PYaLPplurU01dg0m2tc
         gwboVhgrXByH78YGQUp53WjgGCRFypN5i0q0cx0hAmZtDxls9LDNv8v7X6DYFEeCZ8BS
         53Ivy+ppkqT5QDMs8jlyNWmxP4pU2Mp6ikrWQgRftj5Ea+xt9CdpHbTDSBNzT2sikAru
         uzC1W1lXbASI9+q4I527sKdiQAAtGtSNErgzosqIVzm1W9Jr4IoLzIjzJkkgNB8J/fSM
         U7OQ==
X-Gm-Message-State: AOJu0Yz+aKvNQheCK6dKQsYT3NoES7M0RGmGOu8o9KThRadLb/wMjkuk
	6crvw+4cYPVBORiGgRufr6SX8Cj2DOhml8I0cUDH6dIqC24rb5MAwuaSiwsuaGmqCB4=
X-Gm-Gg: ATEYQzyqIb+Mri61NG4BUvKCPXgxliIVb6FgHRehFH/yCbjk4wotK6pHmHZPGiFvZtF
	HHK40IVHUyOWgJuCARtHnjao87u/Y+XU5GVTxo2nYC7rDUdat83N4713plN9ybqTkgoG5kodFD5
	TXhVmPQ0JNjApF5Oi2heUTGBMtpCatfHBuLVbzWT6nwN71PjpUO7kHhGPWW4VZ9Htu0CZGw91MN
	5bQA9bauMpt4OckHu5F8+CWce3tfH3vCpHPls+x0DtLZULcGxXHxWNhSS9ShiYIVBts6Jh4qSjD
	HfDXZz7dXqN/a8TaJzfH1y4X6oZk7mP1+yoRTO+Tt70cw2Sy+hRNythkZy0VM7aoRi+ZgWvh1wS
	vsTZ7HaMzyEQ3gLb6ivZSO2PTxFCzcESqtywmmlusGGTDYICgYYctevQ7n1+u3B/ITiWZwiKE9s
	EE5aHlk8PQq3Bqe/9Irr6oFlmpZA2+3Jfqmn7PAIoQ5o6MeUbzWcyNoxQ1Rh364qYzvrB8viAVS
	YkUzKpn2g==
X-Received: by 2002:a05:6808:17a8:b0:467:697:7bc0 with SMTP id 5614622812f47-46733603692mr1435825b6e.61.1773241978095;
        Wed, 11 Mar 2026 08:12:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6c7885sm2267891fac.17.2026.03.11.08.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 08:12:57 -0700 (PDT)
Message-ID: <002add9f-6cde-4263-92b5-dd74f04f8b10@kernel.dk>
Date: Wed, 11 Mar 2026 09:12:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: ensure ctx->rings is stable for task work
 flags manipulation
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, naup96721@gmail.com,
 stable@vger.kernel.org
References: <20260311131336.197028-1-axboe@kernel.dk>
 <20260311131336.197028-2-axboe@kernel.dk> <abGE_CLo4vW_-Tkh@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <abGE_CLo4vW_-Tkh@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12641-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 50AB926637A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/11/26 9:06 AM, Keith Busch wrote:
> On Wed, Mar 11, 2026 at 07:11:55AM -0600, Jens Axboe wrote:
>> +/*
>> + * Sets IORING_SQ_TASKRUN in the sq_flags shared with userspace, using the
>> + * RCU protected rings pointer to be safe against concurrent ring resizing.
>> + * Must be called inside an RCU read-side critical section.
> 
> You can make the rcu requirement explicit in the code with:
> 
> 	ASSERT(rcu_read_lock_held());
> 
> And debug kernels will catch misuse, too.

We have lockdep_assert_in_rcu_read_lock(), that should do it. Did ponder
that, and then I could also kill the comment as it's self documenting
by that point.

-- 
Jens Axboe


