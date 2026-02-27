Return-Path: <io-uring+bounces-12468-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPv8I6L4oWknyAQAu9opvQ
	(envelope-from <io-uring+bounces-12468-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:03:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE39A1BD2D1
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F6CC302C930
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25FE3559C0;
	Fri, 27 Feb 2026 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXpAhIh9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2173451AB
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 20:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222623; cv=none; b=T3m4ZKYwcuXzhQxXPFF12wo7vO6oUC6ftPQSFVRze2TJMnrG38gnzZQge+Qm8Waq756wzbLsd+/duTS9rDLN90pcc4aWd996N2hLMy67xeKXX/CgRkniEzG/gCsnMy5dx67anqkLvCTXxtNEmxaCO8ZeMQ5ks209WwKlGoPVapI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222623; c=relaxed/simple;
	bh=7iYCDeqOQ7ZWydkycqxu8uk9FFQMas6z/tLOdKWYmvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=st+th7GAaouZmpjbEH1Fa4CigGdUttdLpLAABiAmehE+ykluGBixYEtkGlT+0VSgdLBb2g26zIrZ/1choOTfW8L7bYpfSDy2s2bB66e3N7GbV0nr7wYV/gAZrB9fWr6RLpnq5Ly/wym4/mKhZ05QIOwLNksXeUMpGcNQVDIRbKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XXpAhIh9; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439857ec679so2184259f8f.2
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 12:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772222620; x=1772827420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7ry9dRoWjSPaoxwUgxxQliDkZlIdEiZwMbRrYjZMjg=;
        b=XXpAhIh9rUEYWsFB2kR3H3gRy7bH+elYIJ6oBJi1VUSQw8l4SkBN51L95wL79UrM8C
         1fvnl3gEbaJ//DJgwFNHEKRz/MK7A7GnMO4tgYmesg854HTRR1Fwg7HKfykQVsdUdx+x
         GHD+qceaQEhWInkKoK8KsK2P2cAFVBWA0dzeG8W4AyViN9d9BSxD3c1bJCEWIisUrSav
         DP+xlwPnD3AplOaRhjUqsl12hUFdhJ7NsMYN7zKcJyuLnp01Mbvs/FEIQsSwf4xDwUwe
         l/2pmnaVAtbZK+jjxlOQpYlg8VeEcouc2bGGHlsZXb+LfKEspZRU5M/VOyBKZwAgTlWS
         9htw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772222620; x=1772827420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7ry9dRoWjSPaoxwUgxxQliDkZlIdEiZwMbRrYjZMjg=;
        b=FczTYt6E26HLVqLPcwz1EbINV8UnhYmio6rxpJJzVIUXNWl/Z2mMVymIFsybnajxG3
         cwNct78k3Xj1mClRvpCV+eoFBKb9msmMIjZTRZ78vQP55KUlOfPhWVcbYy2IHNReD+0r
         sV8YIujeLUVpoyTdVFZVR0DGbdgK+AExvTzJTroY5P/PeZC+JgH3LbQVtO/+2qWjaoXE
         ftcIdUBdTUkmZ6rr0vhi2jfcZGbyc4pVzLqpvNfzQDFEusIxZ3IvIIkrHDiJ1KR3qoNm
         gOeXy7RLPyRrPdU3ASI1doKXtsg08yy+ZP11KmEiC7YUGzYm4EOM7dAFOJ3E1pdvrkB1
         Y+lw==
X-Forwarded-Encrypted: i=1; AJvYcCU4kSBudCPxZSl1pTaPvWu7MaqN+8srXuSHwUNihOQtq6um0ZUsHZDRhsYcB6rvbxW35rmAlbsJBg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh3/wFbQpbIcqxFZavwkzyozIU3N6XtW6v1SfYhhaUK9FP9FUf
	ITlbCpAEDTr4Jyue/CZwOB4Ot8VafGuDYtnZy8YSYjPgKC/c0cz0WnpA
X-Gm-Gg: ATEYQzx9nS6agfG0wR1OsUBPtnYDyZYEryzHT7PFpe4bDP94YiRb5dDLqyc3LpY0ZUB
	0/iZkssLiiMp/eUgyGsmGQIrBP1h5mUDlZKDNNwLpeWxazKwaVixLHy06yMMuTf22T6hcBXFkPE
	T0/GWWlGOziAaRfRyOWhRObRhoiBea+7EyVdUB/VlMh8s+1KMv+UJTJ2nEudnbWAGgBQ37qPL2+
	qy80frwUUFi0TEqv2mLc9HYEEiaK+FTgg+v06fwunsX1j1MmWOr5BInlttihtfQw6HnydYnhrex
	wB2EBXF9mqXm4NEUNofZTYtoV0Oy409TD2ijWEk3D1sNnsZnOQhcBuHQ3QS8c3jjfWYip41PQWq
	VEf+zC+I3lTQFH2VOqmzxSuUqQYqbXDi3hrvttDpDdHCWdsbpp7x7iR0FdqP0AqtWa5cIb2zzds
	n/KYPBjEaUrmDE1hDPKxJXF8WqVhqmvfVxaMHgm/Xm3oc1fPdtRHIKs/Vzi83WkK6qAf2nAxtQ8
	xiIXcMimpxMVi9TY12RUxxyoTQKY7hHSBx6qKlYtknJBAMxTPkyJ1VXyYtYTSigRBM0zmHQ1YqK
	4g==
X-Received: by 2002:a05:6000:2210:b0:439:8580:18e with SMTP id ffacd0b85a97d-4399de3ab67mr7073718f8f.55.1772222620519;
        Fri, 27 Feb 2026 12:03:40 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60e404sm10133924f8f.8.2026.02.27.12.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 12:03:40 -0800 (PST)
Message-ID: <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
Date: Fri, 27 Feb 2026 20:03:36 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12468-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DE39A1BD2D1
X-Rspamd-Action: no action

On 2/27/26 19:39, Jens Axboe wrote:
> On 2/27/26 12:08 PM, Pavel Begunkov wrote:
>> On 2/27/26 14:08, Stefan Metzmacher wrote:
>>> Hi Pavel,
>>>
>>>>        if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>>            return -EINVAL;
>>>> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>                return -EINVAL;
>>>>            if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>>>>                tr->ltimeout = true;
>>>> -        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
>>>> +        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
>>>> +                  IORING_TIMEOUT_ABS |
>>>> +                  IORING_TIMEOUT_IMMEDIATE_ARG))
>>>>                return -EINVAL;
>>>> -        if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
>>>> +
>>>> +        arg = READ_ONCE(sqe->addr2);
>>>> +        if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
>>>> +            if (tr->flags & IORING_TIMEOUT_ABS)
>>>> +                return -EINVAL;
>>>> +            tr->ts = ns_to_timespec64(arg);
>>>
>>> I'm wondering if there is enough free space in a small sqe to hold a full timespec?
>>> So that there is no restriction for IORING_TIMEOUT_ABS...
>>
>> Well, u64 gives ~500 years in ns, it should be fine to just
>> allow the abs mode. We just need to make sure to zero check
>> the unused fields in case it'd need to be extended.
> 
> I don't think it's about length of it - if you can avoid the div by
> doing ns_to_timespec64(), that might be very useful? Would make

hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
                                    ^^^

io_uring just needs to flip it and use ktime, but I left it for later.

> userspace simpler too potentially, and basically make the immediate mode
> _exactly_ the same as the non-immediate mode, it just delivers the
> __kernel_timespec in a different way.

I very much want to believe that everything about kernel_timespec has
some deep meaning, but I fail to see why they split it as sec/ns and
left invalid ranges for ns, why ns is signed, and why even after a
large revamp one of the fields doesn't use a fixed width type.
I'm not sure exactly like it is actually a good idea.

-- 
Pavel Begunkov


