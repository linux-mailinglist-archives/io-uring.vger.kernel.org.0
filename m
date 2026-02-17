Return-Path: <io-uring+bounces-12283-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePrvJPdNlGktCQIAu9opvQ
	(envelope-from <io-uring+bounces-12283-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:16:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4635414B3C8
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2F50F3014693
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398EF1624C5;
	Tue, 17 Feb 2026 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlU8ZTfx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34D9405F7
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771326965; cv=none; b=HrF4nQrvD4239orzeszFfsjFJiDDjy0Ub3BE/u0QynuFoK7HMNCO2ljIfJ1OYv9Hc7V2zDyBzCy4t2iKj7FB1XuF15/u03Z4axlLBozqYuwegEXP3RVQgw7Z4ke1QDb+puHcpsL5/Ul6Awfl/My2Uwe+7ZJ4NOiIY5k4AEW0Fj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771326965; c=relaxed/simple;
	bh=4fDl9Tx52tN8Vvz+cKLth/oj3oWDegy3VzS2lXLMkyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h8UAMEK5DBVPVK5hy2zBZ+PWMj1pbFGxvrsWMYdJRrhD5sQNAuwNXYYA02AL3Ddi6gazoTEB095yectASi42VV/cLmm4TVX6teU03UQ39CGil2O600BuhN0+uHKY8iltTtFSfKNKKuocTgU8Hqfe56CnbejIC2BZ37ErAFD5Zcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JlU8ZTfx; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48068127f00so43596525e9.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771326962; x=1771931762; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=udd3c/j5y/czJyPaoZAr0Y1gQMOGk+/cJRnG9X5J5bw=;
        b=JlU8ZTfx06MTRlO/YsM3NaNlBwPDbXM8v1/qUhPpOz0RkjIgTIFiMruhjDGN5tt5xP
         2WWVAz/q/vkIdUC8zG1e6VCNZuzRZ+uIlWREsVaLb6kcIDvfeykeH1PHSbvc+HSaN9uO
         gR7zE7RxXmW6BBu5oPJvatK1jk8HSXiCjEG/1Vmb287BmulfVURlr+kjgC9GqNSESfkv
         ekM+Q4pH7Hxyhc2cUD9+6sWXc0rX+w2YwDt+8suPmmP3LKdl0mNd2UFO/g1jNT9l5fO1
         sNLDC6mcpjW05/jYrsbbD4IK5S0s/Lf1jiT3Y/+tn02pXllONrRH+2lOnYqygstitr2L
         +DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771326962; x=1771931762;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udd3c/j5y/czJyPaoZAr0Y1gQMOGk+/cJRnG9X5J5bw=;
        b=do+4y5U+JUTwmjunBcaNwoUIj1bq9L7Mdvwv2kxFeG0PcXbBcU+UvAFEkMAxSY+YG1
         MYgl77W13TaLyde3bKZFinpfNlxYOg5X68sG1KxMi7BEXMsqJgxwkoRP7hqU8muAe20k
         j7a9WMimP7MRtFQnudMHHlsXT3iEXtcA9AWnXWeCwyVKkccHKyptPKRvrujwDAQz2D2F
         W18Rz+CP2jIb3sT8QYLQjL6DrV1vxNbM5nSWgSo01kHsYv276FzBeiijFhgdz9U8Uq+e
         TdCzOy85aalL/5CRpWIbWh71WHi85amFBfd+XKVDz8vFXqlCpFmK0RpD+yV1+s7ZFmAe
         h5PQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuuEpnL9uUibYSti3dHpuPHyvqIUwz1fd09medHG5yQgB4H8OgMJ6aatFkHaMIu480bf41Yip5Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSfM4f1xl/xGYMdBTClLk/XdyufBnLK7hFEDm0cwxyjSYb4DE/
	SJuoOwFH65iGYkF98p/6ej6exmxfYWIzWazsTOP4ZtDyT33sm/lDxUhQ
X-Gm-Gg: AZuq6aJLgTtvR9pNAa9G3xwL0Fycr/6yX0QZhhkretjnKw7B6U7ITn5p1YLoFJyqEni
	3IdnqcAAhCdzFNc92Vd0LOsruVJ1YGHlpGA3MwFqW2NGY2MhlLWn0u7Y+ZQj/tLyr1QHxPcPONz
	6tpkqpv8hUx6cNQ6NvN/mP9GRRtT4ScTuSUIJM+6+pPUIKTbLGZ2c1Nnwub9tayT1K3y8hIe7/Q
	oNyn8lVqcP2pgwOowJ+heE5BeODAsP8s441h9j4zu7J1U00q9HjUTaEueQHzl47mp1ExqBBCpQv
	vi4vxZNf2db2WAs1knC44kY/TmS8LEMeIz8Dh4lJETuDwLUDUkApJFjInrNsh749gAqZrdFACbK
	3Bo7VpGFvLMO1vV3X+2mraKZVJ10aj4QtZekSzl+l4xm6kmoI7sjNXyZS5yMLnw6X32J8ZBxuVM
	WnqLk1H4ZYUYl4h0jIQd59neKbSh00srhGOlTm8c+xkyVpUgYTUuyABp0QVzBsSDsnb8Jq8orF3
	22cMrmV44pSCuK9YTNQ72+qdnjg+avADLg4BhUCP9Qx1iFl3AsE+RWK4XFpXHm3vz02JUpcZn3S
	Fw==
X-Received: by 2002:a05:600c:6206:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-48373a0842fmr193691605e9.2.1771326961606;
        Tue, 17 Feb 2026 03:16:01 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dfb4bd4sm457899105e9.7.2026.02.17.03.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 03:16:01 -0800 (PST)
Message-ID: <3888d916-259b-4d1f-96c2-157c289d867e@gmail.com>
Date: Tue, 17 Feb 2026 11:15:58 +0000
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
 <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
 <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
 <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
 <133c27e8-7b5f-4754-9f8a-17d96e736621@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <133c27e8-7b5f-4754-9f8a-17d96e736621@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12283-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 4635414B3C8
X-Rspamd-Action: no action

On 2/16/26 17:27, Jens Axboe wrote:
...
>> There are already 6, it'll be 7th. I also have one or two more in mind,
>> that's already over the half. The same was probably thought about
>> sqe->flags, and even though it's twice as many bits for net, those
>> are taken faster as potential cost of redesign is lower.
>>
>> Fwiw, the code is nastier as well, more branchy and away from
>> other notification init because of dependency on reading the
>> flags.
>>
>> @@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   
>>       zc->done_io = 0;
>>   
>> -    if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>> +    if (unlikely(READ_ONCE(sqe->__pad2[0])))
>>           return -EINVAL;
>>       /* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
>>       if (req->flags & REQ_F_CQE_SKIP)
>> @@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>           }
>>       }
>>   
>> +    if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
>> +        notif->cqe.user_data = READ_ONCE(sqe->addr3);
>> +    } else {
>> +        if (READ_ONCE(sqe->addr3))
>> +            return -EINVAL;
>> +    }
>> +
> 
> I think just remove the else part here - addr3 is valid now that
> IORING_SEND_ZC_NOTIF_USER_DATA is supported, and if you mess it up in
> your applications, you'll find this via development anyway. Since addr3
> == 0 is a valid value, it doesn't make much sense to check for it being
> non-zero.

Gating it on a separate flag but not checking when not set makes
it only more confusing in terms of why would you do a flag in
the first place.

It's not like a flags field where any value set would be an
> -EINVAL case. Doesn't even exclude having another flag for using addr3
> for something else anyway.

You can override the behaviour with another flag in either case,
but realistically it's better to avoid as it's always messy,
unless the features are clearly exclusive.

I know there is no way to convince you, but v2 already degraded
the uapi as per requested, can we have that one? The "else" branch
doesn't make the api worse, on the opposite.

-- 
Pavel Begunkov


