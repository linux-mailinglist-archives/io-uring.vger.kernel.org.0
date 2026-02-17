Return-Path: <io-uring+bounces-12296-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJPjOiuGlGl9FQIAu9opvQ
	(envelope-from <io-uring+bounces-12296-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 16:15:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6366014D809
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 16:15:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 89D61303C83E
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 15:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BBF27F18F;
	Tue, 17 Feb 2026 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F9VXiHb0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65772737F8
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771341318; cv=none; b=vEYpefOsukfZPm99kAJbgDDwq9A08aToRPqSUGHwVGnwT69voiD0/LdpI1Gmc7o8k6JnR2wJDiR495StqupBWcNUqqQWHLu2y9cBczjv8K/GdBjXiqWwIbLZrR5eh5YYoORnrbr32oRseNt1Ur39hoAPJKhHM3LqjvMYtvHx/40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771341318; c=relaxed/simple;
	bh=SPMe7ykwx20gQdIvYCkSCFSm7VTWUN4vVvLaZcEicEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=prTO2v2ngtmLpazrHn8QmjP17ntyahmC+7Zc6RMxHk4SZiuJLl0RWsV9nuX59xndzHWsatsgrWVDow3QoBtCwbouiusMDE1muzKZfaGgUXwngX0Lwz5hvFI4KF+TFWgZcJC+2iEJl4gAU9v6BaTuTcQbBukSyPZt9sDd8ATqQ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F9VXiHb0; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-66ee7b9af94so1436443eaf.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 07:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771341314; x=1771946114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MKqIbh8Ank5PMu5FLaUaA4VaeExW0IAtZSFBux703oY=;
        b=F9VXiHb0rO3w5uZ8ZT1rgWLrtsZi7MoXuzVZrtPKN6RNt9sf0Z7dOVD2/jtizm8F1v
         7Qa9CeNAdsekv+bg0zfJ0Q7D3OCUECeL9IWnSKNcnm4UfrCEh7Ak4HR0hLQ9NQ6rMN0L
         cYZ8geZTC/VVMumhwYPmnzXQIMNFTIokF3L6oRXZQoyonkbWTwOnHsApyZ1etwTplqia
         IiTZ12oEPcFiKVtulGTC2AMo/gZW17of7SgWWQtaf4m6hJNZuQ4sWTbDNtpCAAxyuG7G
         fnuiQ5D3i919T3Fbn+zXv7IoBUrHWjwmWJOPkyqQRYEZ1sVYCAckko3zVRwn/A498eeM
         SKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771341314; x=1771946114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MKqIbh8Ank5PMu5FLaUaA4VaeExW0IAtZSFBux703oY=;
        b=UWjHyuwM2jPTSBjkKfQRqyfncwdrLji9/NUCzjYPVyxDr/CUct2b5CCwmws6tEOFPq
         JC4He2QZRvEI9b3ANIIX63ZiVEC6dL3m4p7OhBGXMFSYw9Qxa9IqLK39cAHYsD1fjwsI
         aMZzLAe0O9++5Ne/vum/SjuDxPIyanxg8R8QXaT0iKEbI60fVo4H3cVFfks/iwht8kl4
         +H39xO1tFt3xXF9osg1fxGYB7sYsU/16UNObPmpJqhUF5OtL5xdX3obsdIFM/g0slClS
         WB6ggvWRyB/3Xf9YO3P/TFAcGv2cAuLXDFQDR2txCjpa/YpjGHqA91WZRLpAuGcnVYYc
         inVA==
X-Forwarded-Encrypted: i=1; AJvYcCXoCgTVbGUdjcemJ0XDzRdqQeG8abE8UbBjlyq24csvm3waMeRiuUe82ETjUDqtJqw4FyM4vFxbuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5I59/VPlLnMz8MKFYw61alcZxBfL38sTF/vY6S0zrtVQ6lA5H
	/RwC1AcY0/N9c/o5jcdBfILLYo/4HiMpxtk6xCcAkD8kokCCQSiwrge8+au2/DiaN1KwqDylIQT
	fkht4VA8=
X-Gm-Gg: AZuq6aKYZHEx2yS+1y+JyKbnbc3N/65v/7VrwxFQZqsQ5UbVp67XchohRBlgUxFd7Qp
	392e1ledZujpqLP4vTdhtuOETGgQ/94ibZHpF0HahYFe8QDY9WRwabM2HM3Yy9HO/0UIJfdhPMk
	S7S+qrHYVprckSHNOFdmltcomZoubx7kuwbiB0WmeU+wsRXyX0R1HuL/JNOEMTcdh08WcCNE9mk
	ibg7hlBunHXOZWSf7KHPPhamalzL+PrF0b+Fy+/OR5qaW3DjKJaOCLGafB2zhtavccNNLYhV8Kx
	Jj5jMTTRDzLO/KHE32B00SqXuugshkjOvCynI0YOCIFEdJ23xJuwERzYLvPdZn9Gjorccx9HbZt
	vTracxYzEFdGPCClCgVL5uqjAxMyWBPuCN5eF9kxYPA/In5fy7PQzpxoAliJ4Geq1SiYOjpkx/Q
	iFmCziEKtFuaj267hzwaDeFvPyqRvEw3szhyO/vEJXeTAG5IHFoZqt63vAGrbgBAUxxiqsdVDq/
	yVA5R8oEw==
X-Received: by 2002:a05:6820:4007:b0:679:92c7:2c18 with SMTP id 006d021491bc7-67992c778d6mr2342313eaf.0.1771341314382;
        Tue, 17 Feb 2026 07:15:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6777c128a11sm8076808eaf.0.2026.02.17.07.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 07:15:13 -0800 (PST)
Message-ID: <56a3e17b-8ad1-4623-bc8c-e8f4e9f4e265@kernel.dk>
Date: Tue, 17 Feb 2026 08:15:13 -0700
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
 <fd6ac244-40ee-48e1-b41b-d4d78839fe72@kernel.dk>
 <5eeb233d-74e4-453c-ad18-f30382dc44e7@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5eeb233d-74e4-453c-ad18-f30382dc44e7@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12296-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6366014D809
X-Rspamd-Action: no action

On 2/17/26 8:03 AM, Pavel Begunkov wrote:
> On 2/17/26 13:12, Jens Axboe wrote:
>> On 2/17/26 4:15 AM, Pavel Begunkov wrote:
>>> On 2/16/26 17:27, Jens Axboe wrote:
>>> ...
>>>>> There are already 6, it'll be 7th. I also have one or two more in mind,
>>>>> that's already over the half. The same was probably thought about
>>>>> sqe->flags, and even though it's twice as many bits for net, those
>>>>> are taken faster as potential cost of redesign is lower.
>>>>>
>>>>> Fwiw, the code is nastier as well, more branchy and away from
>>>>> other notification init because of dependency on reading the
>>>>> flags.
>>>>>
>>>>> @@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>          zc->done_io = 0;
>>>>>    -    if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>>>> +    if (unlikely(READ_ONCE(sqe->__pad2[0])))
>>>>>            return -EINVAL;
>>>>>        /* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
>>>>>        if (req->flags & REQ_F_CQE_SKIP)
>>>>> @@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>            }
>>>>>        }
>>>>>    +    if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
>>>>> +        notif->cqe.user_data = READ_ONCE(sqe->addr3);
>>>>> +    } else {
>>>>> +        if (READ_ONCE(sqe->addr3))
>>>>> +            return -EINVAL;
>>>>> +    }
>>>>> +
>>>>
>>>> I think just remove the else part here - addr3 is valid now that
>>>> IORING_SEND_ZC_NOTIF_USER_DATA is supported, and if you mess it up in
>>>> your applications, you'll find this via development anyway. Since addr3
>>>> == 0 is a valid value, it doesn't make much sense to check for it being
>>>> non-zero.
>>>
>>> Gating it on a separate flag but not checking when not set makes
>>> it only more confusing in terms of why would you do a flag in
>>> the first place.
>>>
>>> It's not like a flags field where any value set would be an
>>>> -EINVAL case. Doesn't even exclude having another flag for using addr3
>>>> for something else anyway.
>>>
>>> You can override the behaviour with another flag in either case,
>>> but realistically it's better to avoid as it's always messy,
>>> unless the features are clearly exclusive.
>>>
>>> I know there is no way to convince you, but v2 already degraded
>>> the uapi as per requested, can we have that one? The "else" branch
>>> doesn't make the api worse, on the opposite.
>>
>> The else ties into all of it though, as it perpetuates the "user_data is
>> zero is not valid" part. The reason we have the addr3 check in the first
> 
> How come? If the flag is not set, it shouldn't be user_data and
> the kernel shouldn't care whether the user assumes otherwise. It's
> a general unused value check, and it is unused exactly because the
> field doesn't have any meaning put into it when the flag is not
> set. Same way nobody argues that sqe->__pad2[0] shouldn't be zero
> checked because a user might mess up the ABI by accident and put
> some user_data there. It'd be nice to be able to check if it's
> "set", but the best I can do is the typical "0 == not set".

Check if it's set == IORING_SEND_ZC_NOTIF_USER_DATA is set. That's why
the flag is there.

>> place is to have a way of saying "this field isn't used for this opcode,
>> may be used in the future". Now it is used/supported, and I don't think
> 
> addr3 is not used nor supported in the else branch. You'd allow
> users to set addr3 without the flag, but what behaviour does it
> supposed to achieve? Just ignoring doing nothing?

It's not supposed to achieve anything, that is the point. The only
downside I can see is that you now always need a flag to say 'use addr3'
for this. But I think that's better than if we had used it for something
else first, and then you'd need a flag later on anyway to say "no it's
not X, it's Y if this flag is set".

>> we should be checking it. If we end up with future flags that also need
>> addr3 and 0 is valid, then it'll end up with more checking for that,
>> based on which flags are set and which are not.
> 
> Or it can be used without any new flags when the user_data flag
> is not set, assuming it can tolerate the default 0.

So you'd have addr3 be user_data is IORING_SEND_ZC_NOTIF_USER_DATA is
set, and potentially something else if NO flag is set? That seems pretty
confusing.

>> The patch should just be removing that addr3 -EINVAL case, and adding
>> the two lines that check IORING_SEND_ZC_NOTIF_USER_DATA, and if set, assign
>> notif->cqe.user_data from addr3.
>>
>> But I object to saying this is a "degraded" uapi, to me it's very much a
>> better one as it allows all values of user_data, rather than have some
>> magic 0 value that's not valid for no other reason than force policy.
> 
> Well, we clearly disagree on that one.

In the spirit of making progress and not wasting anymore time on this
fairly fruitless discussion, I'm fine with adding the else branch, and
hence v2 as-is.

-- 
Jens Axboe

