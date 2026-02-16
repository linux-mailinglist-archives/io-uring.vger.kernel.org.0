Return-Path: <io-uring+bounces-12254-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IELYBnc9k2kg2wEAu9opvQ
	(envelope-from <io-uring+bounces-12254-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:53:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C14D145D00
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A644C30011A6
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D592745C;
	Mon, 16 Feb 2026 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWuueufu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B159031B812
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257202; cv=none; b=R/7xOqbIp+1/2+lvvYHKsyfck6jKMsohLwjvQ0b/Hm7HE8H/WRJUoYqmtW2ZDkPm33xiyyrDwBBoTlwONsZ/HuOCpJXBWd0CWY7V1uq/2HIXycSoeVn+rIRlhUGiM5ydEwhRwCyZqODkB1Ye207xYskFgZskZVRosKS6fK/MjY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257202; c=relaxed/simple;
	bh=auMVbmgPMDjD5Phlc+AxI0RKBoq1WQUxWBlTv1Ay06g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O08sqm4kuo2OP5tRp+lSSCEFgXekYW60AsDkdv1rJ+TfdTAujiIKYJ6H2hytFN8k38FfdP7XSPikUt6W4NCXM1sNpD8H1QZ3gnNvWmqUKQKPi8dzRBdPTIqwhTwepI/X7u6u7pmQvPOPOsZKkmeYmYz/bbQmpeElYBMNhFSZ8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DWuueufu; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65a431e305eso5663965a12.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771257199; x=1771861999; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AxhY+fG1iDyWD4mLc5GdPOed+KOjBmKa/Z0mXj2zKgs=;
        b=DWuueufuAu1nFxrBewUqTlRvdJMLcOU+v2jlSpUe+1vqqFX7SAVD0zBB3O9G5XhjPy
         K55Ws6UP8VW68SXxPRXKubkTKn/td9jK6ddNzJb6e8z8bUMJE8G9/GICuh3Sj6B89iiq
         msX2lUmqzcXxLgXG2xRiuPFX065W9rDJO66M14G9oN/HUFNmYB9dwEmf6JqznblmWJ1x
         UsD6siqubs1rqWkyPpZwqzCsIBXnjjfqrrGvQZjiLU6I0fXQkZSCuG4QzCTchg/Ny7gV
         ta8nrhGjgZ5UOkK6dQCHQIBOf63mGwBvvOo2/YgjAEens4zz+Tp7NDEB0rDRQ1BObE8A
         c2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771257199; x=1771861999;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AxhY+fG1iDyWD4mLc5GdPOed+KOjBmKa/Z0mXj2zKgs=;
        b=vgnPmdt1eKQCxXGddvUmCrdKQrvRLIB9PJSgHip2mPK4HFmfRhoAXi9aS9rLzLwrAW
         g0TqXFFOPSB8U6qG/CNol+zo63hgyErC6+UFvKT5ObdQ25MQGLWJQduAOeHrfHiEbpic
         zDQcjZsewA0CmVNYkB3b9igHLsUBa3n6NJHiUZqEU0Q2vfBAC0rka3xcWkYYXgEygU5F
         1N05vpwzM5sOrTwYdzIldXKgdoepV8Bayl8kwHOwMveLqf6hWrqZun9Av40TvTvW1jIf
         o7nlEmglxbmJEmco8hqcWpGJ1UMakaceoloK6Kd3wXBDwgITTr0zY2ma/gzareI/xM0U
         4CsQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/WhqRPAQKoZmi0zA7jOXeSvsyJIFEFIo8WynBIOeNHP3w67T1HgvKhhk1tOAo3Cfhfd9CaYtB1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRFqQiqSWLvngfvqv86R7g8Udu9i0LhPhLe60ZhTtHYw+AKxUp
	hHoI+kZOeAP5yy9GCimQQpno4+QGhq/RbJzD6fiuFEgnrdN0TtVHg6+IarVxJeMn
X-Gm-Gg: AZuq6aLmmT/MDpTJ4XMBm5NfCE50MsfRqqj4vxBdNNaVELaia0pMsEL/NG47u0CQ0BF
	t31RLaK850YdRlyw1ngW2ppG4quZQJv97L6BTdNygoHK6MA+Or1/aPAGrLW+YcYkWezRf0GWhns
	fIdArbfWIDyrkgxJRE7wPRGAdwT57K7rOSZFo1YsILqSr60GQdl2K0INQ5zg+ohntpQ+2iZZ+Uf
	FrCWsQifV6O5tz0FY75Dq75HgW+az3j6HrIgU6vztrnpfKoTESsR832fquQKiA8epKiK5nr6d0z
	6zsKzFpHfQ5n5mMggOyNpuleDookPyQxQooBwv8n/ikHuwmAa+qTlyUVvLskZxJnzd6nkaxpiGM
	y9XrwvfgyXIipJcgf/gwSQmwJlGZkxAB9lWr6jWXkBv782wpRNVxd+3/r1f0uDuwmAdxmuI6+pJ
	twizgqYzF1UFOJV9QndzIsFGswk/GK8H203rQR/VJp+bT2E9GEUvbKgiZwwZcAEKVnfXmcbAlPD
	b4072Ga0oP+WqwzF3iWR7Jyl30BNFp9safCoN8I3igYGSZTGrBjShGvYw==
X-Received: by 2002:a05:6402:520d:b0:64d:2920:ef29 with SMTP id 4fb4d7f45d1cf-65bc7854994mr4086557a12.2.1771257198791;
        Mon, 16 Feb 2026 07:53:18 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bad3e390bsm1932343a12.17.2026.02.16.07.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:53:18 -0800 (PST)
Message-ID: <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
Date: Mon, 16 Feb 2026 15:53:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
 <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12254-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2C14D145D00
X-Rspamd-Action: no action

On 2/16/26 15:52, Jens Axboe wrote:
> On 2/16/26 8:48 AM, Pavel Begunkov wrote:
>> On 2/16/26 15:10, Jens Axboe wrote:
>>> On 2/16/26 4:48 AM, Pavel Begunkov wrote:
>>>> People previously asked for the notification CQE to have a different
>>>> user_data value from the main request completion. It's useful to
>>>> separate buffer and request handling logic and avoid separately
>>>> refcounting the request.
>>>>
>>>> Let the user pass the notification user_data in sqe->addr3. If zero,
>>>> it'll inherit sqe->user_data as before. It doesn't change the rules for
>>>> when the user can expect a notification CQE, and it should still check
>>>> the IORING_CQE_F_MORE flag.
>>>
>>> This should use and sqe->ioprio flag to manage it, otherwise you're
>>> excluding 0. Which may not be important in and of itself, but the
>>> flag approach is expected way to do this.
>>
>> What's the benefit? It's not unreasonable to exclude zero, it won't
>> limit any use cases, and it's not new either (i.e. buffer tags).
>> On the other hand, the user will now have to modify two fields
>> instead of one, which is cleaner. And you're taking one extra bit
>> out of 16bit ->ioprio, which is not critical if it's all going to
>> be flags, but it wouldn't be an outrageous idea to take 8 bits
>> out of it for some index, for example.
> 
> The benefit is that it's weird to exclude a given user_data value, just
> so it can get used as both a key and a flag. IMHO much cleaner to have a
> flag for it which explicitly says "use the user_data I provide". Also
> easier to explain in docs, set this flag and then the value in X will be
> the user_data for the completion.

Ok, I'll respin, let's go with wasting bits for nothing.

-- 
Pavel Begunkov


