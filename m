Return-Path: <io-uring+bounces-12472-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CgAOhcIommEyQQAu9opvQ
	(envelope-from <io-uring+bounces-12472-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:09:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CC31BE1A1
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AD683044144
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23E8478866;
	Fri, 27 Feb 2026 21:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrlCRd0w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7A478E43
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 21:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772226580; cv=none; b=nPnz9p6k8CaZB2EjGMmopHyqirIeOW4goH3D7aa4JAb5JhMC/8oIBReFf8dx94WUSSMj//5hTDb0LV/hzA67kvg2IZjBKwXKHzRkvbSE7ljt85xe0XY7EwxLeqXRpCtxTKkKElTgklvlH4UxPP+7mBGS9VDd5pk2dZ2+52sbvxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772226580; c=relaxed/simple;
	bh=/K9tVvy3dxKVWEdLJluWJ2Dmz2B0sFvuvIOlkr7Y/4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iz65WIjeIdgus0F3Xg1y24gKqkaIB6qQ3CGUbFHRihY3vUM8soZJyPPEYUiny66bJtEEZqP3z50ivhflcqo4ggM6rZqNUmwBvNoexMkB1lgjuExhIPKAhh+D/iMJFPPB6gjaXZ5nVdl3m3rZ3skG/2VKBv9q3AZ4SagEbpJIypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrlCRd0w; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48329eb96a7so19429595e9.3
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 13:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772226576; x=1772831376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F8joMfB378QB/APTJHKGB6A4t0/fziwnXXFoCps2m04=;
        b=QrlCRd0wju9zvmvFlAyBz1BA/iZO4KprJfzDWqTGj/VzMDFdHp3gKV3iAKTN1wIFoY
         GZVHNH9WWQ/dO+YgO5JZH/tNL0XPky3p/QzztPLZl9SW70Oqsx1T6xijtaWZOAFz/cYO
         456Tp4ifskHgpZJvWLrKzOvsJMvVI2iysX1ooLC79XR1FCDq/bSP+KSXVq+llNMsuJ9R
         MbtHV7IFlouthWd75ZF8t1BffdACNB1qxWnzHErHJ7vPHFNeHte8rsq3WMIkDod9oPSO
         fdmC6O+6GJBd7N8+ZBtJlhVE2ldIa8q/40A0r5//Fuhf4rxLzIsqBjNEDeLh6CziyNmy
         EIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772226576; x=1772831376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8joMfB378QB/APTJHKGB6A4t0/fziwnXXFoCps2m04=;
        b=aC3hJFBYxpj19R1xcfpORsAmm4hTFpSeoS7a97BjfG2DT7r2Tyjq3GztSDUo4dBP1o
         Qno6wl0nXhgGZMT+htA5VhsP96a5SMDwr+H3ax5dcfZznO2bsIaxg9HSSF9N0Bzat57u
         TIh027w99nK36mc87VGdTOkiCbtSGeUMtVm+Q3x0HMakMQrQxIib7JgoVurKIQ50PFiJ
         ky+Qp/odzWU6MC4FJffdVOyKkFoYyu96X/H8IHOkeCWRhA7sYS0ELP1gcnw8DBGUTiHC
         rzHgKLWzSz72Dxsmz7Krs1Q+6dgV5DoIUvwWROuSxy+qRA0m8h07NGgolLqThg2s1jka
         P5Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUQbk/2UcJiFXjMFDlqNMGLtqVuIMv09Q7RLvVXAs9Di7Q2h5NHfLtMRtaCKYcoTLoLIRUpGxacGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2RcLNmVBtIA6q2otc+Iy3wZcjsqk3Rx6zV0pUu+aAcrTCJLEi
	znxwQLXhfmDg1WzHNejV84kOmQTzKAUy+0w5I4YphyKl3uIF+ph4ZaQ4J8qJzA==
X-Gm-Gg: ATEYQzw6V9AoS+lOzdA+QM0zagOXbH9pBPkdq6ZFuWACWk8OPc5SIY/UUKzkwIFlmIq
	cKOV15ynkQaneYB1HC1qKpgBUIl0vtIWKfFffuZkH39ssamHlGIk652AAEXo1E7SjZdZe3Bgm3w
	an2w2Kkr2SVlSXKafKduRqBMl8nxwEO6c0rCThypSgy9SZ9ItP/5fwQNCtCjzj4yw8ZkVZT8jni
	BZgmf6fa+g1uc/qOeYSR4RJgdMEGor23gpo1dd7y6cbIc/K0tUfUk76q2xteKfH8qDkGmQzhKCX
	2iJzhzn6oh7QZ11QE3YuHWGyvp+E2DtFOKrAS+cjYv5Q96+HvlJNTjcwK4ZfgYD1/QWvjLxlKMb
	cbD2WD6KhxpscE3eQBoo2XIojdcbIjpTYzI8Y1IMivx8uAmOfafk2az8md4+v8X7je7UHpb78LE
	KpIkNDUo4ncPVXd8XYmrQ+A4IA+QxhDxIs9576OrlDFml9Lkte7xVuXXv4nPag1EckylNAL9zCG
	WuqeUdo1ltANuYpHcz5rIgbNXfz9Tn2L2uCd4xlbvnNab4X0rLWUs8MU8gPDD+zptvHLdWM9Np/
	qw==
X-Received: by 2002:a05:600c:4e56:b0:483:612d:7a9a with SMTP id 5b1f17b1804b1-483c9b68304mr78899875e9.0.1772226575478;
        Fri, 27 Feb 2026 13:09:35 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcbd781sm133710765e9.8.2026.02.27.13.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 13:09:33 -0800 (PST)
Message-ID: <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
Date: Fri, 27 Feb 2026 21:09:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
 <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12472-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 45CC31BE1A1
X-Rspamd-Action: no action

On 2/27/26 20:19, Jens Axboe wrote:
> On 2/27/26 1:03 PM, Pavel Begunkov wrote:
>> On 2/27/26 19:39, Jens Axboe wrote:
...
>>> I don't think it's about length of it - if you can avoid the div by
>>> doing ns_to_timespec64(), that might be very useful? Would make
>>
>> hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
>>                                     ^^^
>>
>> io_uring just needs to flip it and use ktime, but I left it for later.
> 
> I think we should go all the way with this if we're doing the immediate
> mode. And I do think that is a good idea. Doing a half-way thing doesn't
> make much sense to me.

One time people will tell you don't do premature optimisations,
merge the main thing first, another time it's the other way around,
you can never guess.

In either case, it's useful by itself. Div is not that expensive
to be a break dealer, and div by constant will usually get
replaced with a mul by modern compilers.

>>> userspace simpler too potentially, and basically make the immediate mode
>>> _exactly_ the same as the non-immediate mode, it just delivers the
>>> __kernel_timespec in a different way.
>>
>> I very much want to believe that everything about kernel_timespec has
>> some deep meaning, but I fail to see why they split it as sec/ns and
>> left invalid ranges for ns, why ns is signed, and why even after a
>> large revamp one of the fields doesn't use a fixed width type.
>> I'm not sure exactly like it is actually a good idea.
> 
> But that's the API for anything timing related, whether it be timeval,
> timespec, or __kernel_timespec the latter obviously only existing
> because everybody else could not be bothered to do a proper 32 vs 64-bit
> agnostic type before. Hence that's the API that people know and use,
> there's no deeper meaning other than that. And I agree, it's kind of
> crap in how you can have an invalid range and it gets masked.
> 
> It's like like I'm a huge __kernel_timespec fan, but for consistency's
> sake, I do like it. With a clock source, then it does start to make
> sense. 

What's about clock source? I'm curious

> Not that I think there's a lot of ABS use cases, I'd expect
> relative to be what people generally use here. But at least then the

It's probably common enough. Not the "wake me on Monday at 5am" kind,
but rather get the current time and then recalculating intervals
from it. Would be nice to return the wake up time as well in a CQE,
if only it was free.

> IMMED API addition will just work regardless of what you do in the app.
> That's better than someone a few revisions later than saying "hey that's
> cool, can we do ABS too which I use because of X and Y" and then having
> to hack that on top.

Hack it up in the user program? I didn't get it.

-- 
Pavel Begunkov


