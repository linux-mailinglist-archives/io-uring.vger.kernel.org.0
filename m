Return-Path: <io-uring+bounces-12454-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGehL8PFoWkVwQQAu9opvQ
	(envelope-from <io-uring+bounces-12454-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:26:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D141BAC6E
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:26:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2DD6830068E2
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0711142E007;
	Fri, 27 Feb 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="amBzVi3M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5371042EED3
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209306; cv=none; b=Nra6ToEXlaKNtD7ijB2aG61UYKPCCshu5eTlgTvRK2vhiyV4H5Tf5I4xRonKcEoRqJZ2OFCaTyBqA1s6jDhJ8pw7BbQBjnf/R9Crsh2dTAocrKmnZuCdd4gN8LG3Wy8JIrfjy5PNhMPmHzcTVoGS06q/iQDzx3RF9FuFmknOvDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209306; c=relaxed/simple;
	bh=+a2iPDkykRR2ESZYtjOMj01IwIgXCIKJui3GIQ2z0zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VsCLuUvl230Ulhq8HR+EXbWCyRFlkCsPUCFokZY0ES5GMcPj4CnSu7ASLUWRCeZafB9kCIsv/T5oaIVkh37eSiu7MQx1OaXvb9VZsbOUZ3BAgrgpwlLn+i5j/EhWcEZoAQPvUG0lVYmGXoa99XGkIRIVtMFCDeuTji4O0Rkh1wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=amBzVi3M; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-506362ac5f7so20622411cf.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 08:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772209303; x=1772814103; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=odlmkRs/9BXow5CsGGgFSgd5BPlp+k8NICkgPrz0uRo=;
        b=amBzVi3Md0U9dczyB5Z6KSZn3nvMoZLJ2MF4TXERPp/SbGhpdMQHnyrvLhCxpkrTkE
         GQgL1OXsZ/QZBa90pErg6fbSXHBUqgZckYmRaOJn/bMilKbhAHz8iTSVA2m2e117FsD7
         RCvuIJJ9vHLu5iPtduEsErQa3Acqu4XbYaXCqlozSidxVHYsU37eM9pqu9sLdJzBLFrC
         vPnANHunVK9TU0Vwgh/vN6mgnEGclY4JS34O414eaXVXq4/LUjGm376ngNybhO92Nfad
         09Y4uERC+otAxw0UZpxZR9Mbzljhy4FYoWNUBmr5+kd1d8qftQBbxJAkEc10w4bOpk9n
         XAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772209303; x=1772814103;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=odlmkRs/9BXow5CsGGgFSgd5BPlp+k8NICkgPrz0uRo=;
        b=g5MAfwQUpLwqlc7Ft/DfykSCopxEcH3qdZ9v3Yn9xeMEkoOfwOxG70Fvp2s98B1gGk
         ZvYqEKgflx6N2Qh/ze7cc5VYTqRyZS7C34wWNnwbePJ5ltRUJNTRcy84GFaV63tdR4qo
         xCtCxkCzPgJnzDJopH6pZSmOlm6mxdqVz0raQAA9QZSyGrIE1KgmWv0dkUEMdZd85GUG
         +MVTkvLkbL75tlCTEGtCiNgvajje+CdXS8asnzbHkN2Zw4Z8/s+vnDqm1OrMvIQhct7T
         C4yjE9Hzgink+Op7g5M5Z1yCe7L1LP7/BlT8wmV+DLnmuJX0pc8eNh7FW/kvq1IXnK0U
         6aAg==
X-Forwarded-Encrypted: i=1; AJvYcCXR+gRQY/1kx06y5HxjUSltb1lJcu6wSd6yEU/HyhA/dTeh3kThvsy7VTkzT9f8L7yVjym1SAyokg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwiZk+YIEskF0DXqIZSILAXrTUj8FOkkgHUe8sDSq8jKxpOhLQ
	SjcVh38qiN8e3bagjVlNX/44qcpQWYzkCD0d4K/C0YcGf9uUvB+Orz2mbMY5yaAHtBo=
X-Gm-Gg: ATEYQzzio8I14W2YwfphyEB8S7ePRxzZ3nHg1NIzRO0RAq9/nnHu6WfTOzLGZmH388Q
	v897f0XIl9isWy/xeqput1BeC8FTdQxMczuRfz+d8+GAQd7D0pnicbw3DAgBr2fB3wrz2dpM1C9
	hh2JFlGfvZJ79mnyz5cW7SRfEmeg31d5i2uYXKnHDCli8uKkjk2bHv4WfJfBow3lvwRB5aVPTwM
	fZzFFyd7pEMaig0ovhlcFA6P+mfBX95E2Ub4H5nXyQO7oalts9vHqM6ZTSuMKJlkym+TFYYXIAs
	E/FjKjH/8zYV3mgr20jqyY3iCurDknjVEYWFhquPgcW8Jt4yR32Vy0AtTdhUy3vRF+eqSMS+xH9
	ZlMqS5gKAjiB9HrD3XzWRFU7RrTwvxZz9+OmLkkF5bpOni2EwQVrE9WSDo59aTgcTnMn0MK04c7
	MEgRGCcAg5ZsuGxx9dI+k+xwXlSFQFWWj5ZlBmmDGqC3EKeh2WFXvoKLegDID+OMW/JFilZe0+Q
	RBFKId6okCiigwj4VQ=
X-Received: by 2002:ac8:5f4c:0:b0:4ff:b261:c6f4 with SMTP id d75a77b69052e-50752762997mr46025991cf.21.1772209302970;
        Fri, 27 Feb 2026 08:21:42 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744af0731sm56496211cf.31.2026.02.27.08.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 08:21:40 -0800 (PST)
Message-ID: <82c6812f-828b-4a28-af7f-38079490386b@kernel.dk>
Date: Fri, 27 Feb 2026 09:21:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Stefan Metzmacher <metze@samba.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <79408230-ee5b-48e6-a111-f76c40f52df5@kernel.dk>
 <df890812-04bc-428d-b9b5-40b836e611ea@samba.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <df890812-04bc-428d-b9b5-40b836e611ea@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12454-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[samba.org,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 35D141BAC6E
X-Rspamd-Action: no action

On 2/27/26 9:17 AM, Stefan Metzmacher wrote:
> Am 27.02.26 um 16:05 schrieb Jens Axboe:
>> On 2/27/26 7:08 AM, Stefan Metzmacher wrote:
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
>> There's ->addr3 for another 8b value, so yes it should very much be
>> possible. I quite like that idea, it'll then be the same as the regular
>> timeout options, except the values are passed directly in the sqe rather
>> than needing the copy.
> 
> Yes, attr_ptr and attr_type_mask would even be two 8b values together,
> basically the same as 'struct __kernel_timespec', correct?
> 
> So we could even add 'struct __kernel_timespec ts;' to the last
> union of sqe...

Let's just encode it in addr and addr3, I'd prefer not to further
obfuscate the sqe definition! And on the liburing side, you just add an
immediate helper for setting it up like that, done.

-- 
Jens Axboe

