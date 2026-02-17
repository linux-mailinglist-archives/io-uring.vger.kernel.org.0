Return-Path: <io-uring+bounces-12291-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oO4AIGBplGlFDgIAu9opvQ
	(envelope-from <io-uring+bounces-12291-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:13:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEE414C70F
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 14:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47AE13014C59
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 13:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FA43346BD;
	Tue, 17 Feb 2026 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eU+V4e0V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0171535FF5B
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771333933; cv=none; b=fImHmfibkTD3tXONBvmiogux9wodVF+tC8rh4DmeeeEPDe9MYKNZy4+dXnhtiNvxSfNR7dwc4qZ9jCJFE6UUhCDzcBqNjpgh+90n8gQWVwune255YX/KFN0K43z7d27Fn77iVoQztlZb1w0zLRt02EV8NrxaIUJdH87ltI72UeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771333933; c=relaxed/simple;
	bh=uPQgbNaRuZvxwElvEbZnqSKqr3yGl85I0rv35TTTFlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLWBZT59pdLXrqYa6VDndvGEMvwRKcvgG6D/wPBLASBNacfN2RC9E93pMCAtQfqHddgY6h43mq0gERKWiX7VljxgkFqSuocZp518ai4En/Z0Z30xuDFhI6xSpaikV0QwtOP3NkavE6y575fc7UJKzOYyWXy2ZPWQsioC9+Fwh9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eU+V4e0V; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d15b8feca3so4907535a34.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 05:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771333930; x=1771938730; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KtDB5uuETc94flMW44bdg4zOAnTdQgs/Wo9k9jb+DwI=;
        b=eU+V4e0Vn8zsI/00Eeybz8GGsSH5xunQJnkRNT3RMBUyngBdRA6kcVJdkojlFK7qBY
         BFgPBZXqEeiGWZONkAiCbGW8MB6VdphPiTGnsF1sm3yFTbTTG75aFtSfGOVoOzcnz2il
         xrP15cX0XVN8zyYZTdxDwFbMm+eeMNNGyz4QPkv16eMqTTBoDRMtyaJYEfChfvwiAXae
         CWtcsiVrH3+8hfiY3Gl2fextD5A29/yAaRCmOnq5M/UTILr6Tov5ZdRQBZrAM5arFOTZ
         nZLXZ0fMqOYSnjCPSlBJH0mz7u7lm7XF05WUB0ivcE7mx8L7BKKW0CjFom4DXTueRbUs
         xoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771333930; x=1771938730;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KtDB5uuETc94flMW44bdg4zOAnTdQgs/Wo9k9jb+DwI=;
        b=BzykS96xH3dg0gMf9Sxh9hjKwTiO1Q4EOpw54lWBYFV4XTfijZmw6dj1dLax7hDbLk
         yujOo1QPSfHm/ciTvMDVN6uTExME1fftNoAXdnMBGEpo3X1wI7z8sJpBN3zgJFbS8U1M
         nL1nGaKty35dbNaZkBYgt3L9ulkjL90FPGUufW2qRW3Tzi6UmKr8bw+8yJickZnqL5C5
         /NBUimScHeovD1URsSbrEpaUQH4LwkRWJ9v1w9qprA49N6i1vS0zvGut3NUkhzhVv6bt
         YzX4rnG0hRhZ7RfODPRvv//CV6heFMd8X/mhW6xKf70VnXqq96CBzeevimRmtvRttnwx
         WuhA==
X-Forwarded-Encrypted: i=1; AJvYcCU+xOJ/4cMCtjLJaAjHdRSE6dSJIhX+YLHaaRRebQhQCJ/Z5Jo4tuMgiZ3tRO8rJBCKFobXoEiEpg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOfxP6JajuLQzR81cez/K8v2BV+LDWihXQjDozrz6S0OzXuMeW
	pGI6924BGOgQqlrR+fTE9tb1OQYO9kMEnoub6wzZsym2jvcOAw1fvRKi3WXEdXuRt3E=
X-Gm-Gg: AZuq6aLR5Na83rQdDiJo2oOK5dYlYcw0fX7GsffgPMBUacn1u9zilLQQANF+FnX0jwT
	1b7uoGFv1XQcr+YLKd1+hqSJT+3kzKoLF6OWPbu4bd6ZKfIs8JqhnR2Ko1153Tg8BfoGEoGsL72
	2UACakKswkp79b9/foWz6GNpjd8zIzpp5h1UZkdt7SI52UfOr6AoiGHvCyGOrU5V2DwvtZFC/ox
	U0GHM3QVj0nijtGdw+BPwhY3dkKeumsVeRoTZWkpA6lgBrigpyxzuMXOgVZPwGVgkADR88H/4HU
	1eQkzg6nO2zIlul4mwJxOLRcTycrkEPZVOZUTOR8rbde9u3/sb9U2sLszhM9+2UoRQoJ7Yik4l5
	484YDFiF1vjb8aFZEZ0ABfpWGvDvMf9LPMGdIczctdzXkrZ18PKvgbzW4aY7BBqeVs/8wuGpcUk
	3o3H+ww6jOOnJBq9FqrDbaqd3ArcfntjTzz84bcfXMGXNA3Wssg21xTM/Z6svI8UjW4Z4m7OZGa
	vj1PmcU2w==
X-Received: by 2002:a05:6830:700e:b0:7c7:62d0:b462 with SMTP id 46e09a7af769-7d4c49fbff3mr10253467a34.6.1771333929843;
        Tue, 17 Feb 2026 05:12:09 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4bb66a066sm11983097a34.19.2026.02.17.05.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 05:12:09 -0800 (PST)
Message-ID: <fd6ac244-40ee-48e1-b41b-d4d78839fe72@kernel.dk>
Date: Tue, 17 Feb 2026 06:12:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
 <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
 <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
 <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
 <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
 <133c27e8-7b5f-4754-9f8a-17d96e736621@kernel.dk>
 <3888d916-259b-4d1f-96c2-157c289d867e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3888d916-259b-4d1f-96c2-157c289d867e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12291-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: EFEE414C70F
X-Rspamd-Action: no action

On 2/17/26 4:15 AM, Pavel Begunkov wrote:
> On 2/16/26 17:27, Jens Axboe wrote:
> ...
>>> There are already 6, it'll be 7th. I also have one or two more in mind,
>>> that's already over the half. The same was probably thought about
>>> sqe->flags, and even though it's twice as many bits for net, those
>>> are taken faster as potential cost of redesign is lower.
>>>
>>> Fwiw, the code is nastier as well, more branchy and away from
>>> other notification init because of dependency on reading the
>>> flags.
>>>
>>> @@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>         zc->done_io = 0;
>>>   -    if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>> +    if (unlikely(READ_ONCE(sqe->__pad2[0])))
>>>           return -EINVAL;
>>>       /* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
>>>       if (req->flags & REQ_F_CQE_SKIP)
>>> @@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>           }
>>>       }
>>>   +    if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
>>> +        notif->cqe.user_data = READ_ONCE(sqe->addr3);
>>> +    } else {
>>> +        if (READ_ONCE(sqe->addr3))
>>> +            return -EINVAL;
>>> +    }
>>> +
>>
>> I think just remove the else part here - addr3 is valid now that
>> IORING_SEND_ZC_NOTIF_USER_DATA is supported, and if you mess it up in
>> your applications, you'll find this via development anyway. Since addr3
>> == 0 is a valid value, it doesn't make much sense to check for it being
>> non-zero.
> 
> Gating it on a separate flag but not checking when not set makes
> it only more confusing in terms of why would you do a flag in
> the first place.
> 
> It's not like a flags field where any value set would be an
>> -EINVAL case. Doesn't even exclude having another flag for using addr3
>> for something else anyway.
> 
> You can override the behaviour with another flag in either case,
> but realistically it's better to avoid as it's always messy,
> unless the features are clearly exclusive.
> 
> I know there is no way to convince you, but v2 already degraded
> the uapi as per requested, can we have that one? The "else" branch
> doesn't make the api worse, on the opposite.

The else ties into all of it though, as it perpetuates the "user_data is
zero is not valid" part. The reason we have the addr3 check in the first
place is to have a way of saying "this field isn't used for this opcode,
may be used in the future". Now it is used/supported, and I don't think
we should be checking it. If we end up with future flags that also need
addr3 and 0 is valid, then it'll end up with more checking for that,
based on which flags are set and which are not.

The patch should just be removing that addr3 -EINVAL case, and adding
the two lines that check IORING_SEND_ZC_NOTIF_USER_DATA, and if set, assign
notif->cqe.user_data from addr3.

But I object to saying this is a "degraded" uapi, to me it's very much a
better one as it allows all values of user_data, rather than have some
magic 0 value that's not valid for no other reason than force policy.

-- 
Jens Axboe

