Return-Path: <io-uring+bounces-11897-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YI/zHDyCc2kDxAAAu9opvQ
	(envelope-from <io-uring+bounces-11897-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:14:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3391D76D14
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 15:14:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 253FF301BA7D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 14:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56F32EA15C;
	Fri, 23 Jan 2026 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eR62Lxnb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432DA3195F0
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177658; cv=none; b=pAGYQjGCBjj9PM4vVTcw15An5JbOotIBbLs28rvMWSYu1jXVeE5h4mratZ8IDR0fnYL39DePQzzqJ0Sp0Q0fIBhJ0ONx2mNbZDLG+d92qH31h79nze0CBlEeIC6ho01lw2r8B0Z6nJTpiP53g9/OXQvC3WKuVkBDVFzxw2fijM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177658; c=relaxed/simple;
	bh=xDx0D/SVXMRl2ys2bZzE9SUuzB+ZuR+GQDgcnh85B1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BuVkd7enxzZuFSI9r3fKxuiqFBKvPCe2TNg/C/0E4sXmef99fCMRfOP/13j8km3WZcTkou9BHAT1eZrGHCK13OgVeZbY40T1Xe2u7m5Cermxw4TCis5b0+WIpwQWWxQQkrRi1A4agUkyHhde/4fcH41gSYNosEmQyxaBNSV7y8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eR62Lxnb; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65814266b08so4289798a12.3
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 06:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769177656; x=1769782456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MuqbcrSQPSHXR/mR9VMorhFj0Qxjk7TiCqgq7iicb2I=;
        b=eR62LxnbXLLtd5s0lOKGa8ZsTH1SrbcH8TG3gGHv5+hjqP+yeVub8gTi8XqUuqqQJe
         plcCtqR4guDANa28l6EuMbXanmIKO2qA1DELwe4dEN9kH0wJhFEYd+x3e2fRyO8JTt94
         lwDYE/it48wCwPcI1nTP4ZLISTe5btaaG57Y5GTTNOB2gxJ8pt3nc4tY2ibv+lfRPppX
         dzg7PkTHYwOpT3OYuc7v4zxg5G8kA4Y60e672XdunRDMG4PSYt2eUUuGKg9dd3GFIUlR
         jWs7lk0AmYGYxdpiSzzBSYtr6sBjaORq4tkOC5SyIQBAvVtnUewmaA6IyHqWF4Uak7XT
         w9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769177656; x=1769782456;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MuqbcrSQPSHXR/mR9VMorhFj0Qxjk7TiCqgq7iicb2I=;
        b=UieRqRzg/wWV0Po2mKf+orLqxQ/29kem6u8Y03wIT8L6gDGxZ+aiFrQDbSCYHLjdEN
         WFlBl4Q9rrZzfgdTXd3XgGflh2+SHWkRca8eN2MX3ynLKA1hfbMdYqeUs80HwEob53Ej
         12j0XC5JuKI1MPOntRvtwExlfgghhMSFlBvODveQ39XO7dip6UWpPiQbpyjpVcp50oC0
         lCjId0FDaGlK82gqeSiX3ZHl3NN4ztis4EJ9otBicDQDEMqo6bnZi5kmqXy1sSLjqhTU
         jqXW31U201O9+nm9aIWFHSjyEeXBX45698Q0gwVP7BnpuDsCKYzPe48LPRK/DvzpcOZg
         sNrA==
X-Forwarded-Encrypted: i=1; AJvYcCVCgR4DZuJi2P2YI8MfJHI+nOXd9dLsMmA7JjNa8+507jb5GuhFbQHxSCPmSj/OUDpqebdNHmLDZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlyTvfuZSOT16fMttyx5eaA207STSD61U12sx39mNKsYpgh2VG
	S58JN1Pi9zcvloIiteNBzxHyl+IsFCZR2VMQ2592eMICGWu29DcZyf4gErfSzFGs
X-Gm-Gg: AZuq6aJWKAYFeW16OBVDX6dny12SCyE/4P6yuP0H84hn5IkXcXejWvNfEEni22vyvKC
	xIpqaREcFD43biSm30wZOf4irIqL/+dBrzUxEiMJuhNTBIg0ApCacWYKcqj41Tsuhxc4mrjUIyZ
	uTbR+ujv6iNclL4fcqTb8P2k3MApTEJCgE8x39zrc3hGhYeQ/nG0RY+w27gHlghZLEI2FJcLoum
	9RoEdLR6HufYlqwJPYEraEcEf/J69HH+lKzOaOc8KgekITOcmeEafgBQ2GsE/B6TgJTg9Bmxuf+
	IN6Tn2UxKMWGl1eTgVjSwBPO5aMkUSPNf30NwtkVC+AurvzSai37J8Y6OFJ9bXNvFWR3K+9FJ4n
	f3/o3bJvBw3z7fwymaACCZJ/db2n3Q5ahxWtWLD0ApWLLAVJfCXrs3B5OZVcQSyE2za/3kQKfGV
	nJCc3gEG8rkje24Fuz/GLImuieYNhM9MH/Pf8RRiMfZ7aQ9+LhHNFcf5qN+/qwakBK5cybBoNkO
	HJFcydpWhwHm+VUB+Ec6IQi7Bkp/nfgAJ1qizmqGlLm0Ak=
X-Received: by 2002:a17:907:3f17:b0:b87:117f:b6ed with SMTP id a640c23a62f3a-b885acca601mr228484266b.21.1769177655357;
        Fri, 23 Jan 2026 06:14:15 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1951])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b4407b0sm114436766b.29.2026.01.23.06.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 06:14:14 -0800 (PST)
Message-ID: <d106a68d-e981-4239-b0db-21a311ec03a3@gmail.com>
Date: Fri, 23 Jan 2026 14:14:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1769034107.git.asml.silence@gmail.com>
 <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
 <517fc5f0-5e6d-46ef-800d-9ef4428278a1@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <517fc5f0-5e6d-46ef-800d-9ef4428278a1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11897-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 3391D76D14
X-Rspamd-Action: no action

On 1/22/26 23:05, Jens Axboe wrote:
> On 1/22/26 3:59 PM, Jens Axboe wrote:
>>
>> On Wed, 21 Jan 2026 22:23:20 +0000, Pavel Begunkov wrote:
>>> Add liburing support and tests for IORING_SETUP_SQ_REWIND.
>>>
>>> Pavel Begunkov (2):
>>>    src/queue: Add support for non circular SQ
>>>    tests: add SETUP_SQ_REWIND tests
>>>
>>> src/include/liburing.h          |  5 ++++-
>>>   src/include/liburing/io_uring.h | 12 ++++++++++++
>>>   src/queue.c                     |  5 +++++
>>>   test/test.h                     |  2 ++
>>>   4 files changed, 23 insertions(+), 1 deletion(-)
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/2] src/queue: Add support for non circular SQ
>>        commit: c22129cf0b8c936eb478d920ef84e53d89c6a5cc
>> [2/2] tests: add SETUP_SQ_REWIND tests
>>        commit: 346c063d16bda52f02d00feb744aafe35b4002a9
> 
> Hmm I do think you're missing some spots though, no?
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 987b28aaf99e..016be1e80ef2 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -1702,8 +1702,13 @@ IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
>   IOURINGINLINE unsigned io_uring_sq_ready(const struct io_uring *ring)
>   	LIBURING_NOEXCEPT
>   {
> +	unsigned head = 0;
> +
> +	if (!(ring->flags & IORING_SETUP_SQ_REWIND))
> +		head = io_uring_load_sq_head(ring);

The head should already be zero. Actually, sounds like the get_sqe
hunk from the patch is not needed either.

-- 
Pavel Begunkov


