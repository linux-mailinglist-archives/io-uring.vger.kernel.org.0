Return-Path: <io-uring+bounces-12587-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJTFEOfKrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12587-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C54239BB1
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E758B3076B7A
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC1F3ACF11;
	Mon,  9 Mar 2026 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pzXtr3Ll"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800713BD622
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062682; cv=none; b=fZVN4ShKigrwjn/18u7QUGVY2gNpeY8VPgzmrwh5xQnzDxg976EeuVlqtIbsegrwBTDZHtcHXPw2RMnbVaF9EM2WeDe6ZrBcdS27Xcm73F8pkVS885QdGVpy0of2SoYRK1rLWWiwzfgfbUx1qsHDZiKIZ2wvJkO/5p5SF8Z7j28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062682; c=relaxed/simple;
	bh=V8KO6GqVaqahP9/O1cWxemAseKgl1ku9gN4j6PMP8eQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPRRzgrR9MTA4urPO4t3ZrNRU2EGYcqARS06f8iNCHaZBTbbyYbaUmWsxKumieuTJv5EOA6UYMF9RW6F+2GpARUWv8BZZ2LQP7FFS0ghkg7qVa1TOfb+XK8BEUUu8KjXHSgwSMptc1NVApkFxbbp2NBRfD3CcHxy1qsuhECUnT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pzXtr3Ll; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c70b5594f4so1182341685a.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773062679; x=1773667479; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZWdO/bTxThCt2UJ38v8pF9JafjdbDv6ZEsdeftb80X8=;
        b=pzXtr3Ll9CIVeJl5ewTrU6VfVcYjlvbYapKm8MuPFMsy8yTHGErM0Aq/EWv5i5iKMJ
         P2ucnR7i5lcwLW5qtqnZjIcV2BsqY8c9j1JB72u3qulqdgaEpS5PSBfaWhOPvFR+5VBp
         GvqT9t7XXMq2cinyBIlt1XvpnNUVPPs8yfBzW3kDcdFc05dwXhmeO+VSuF5ffxpjF0ak
         Ju7eVrPEi3MlRwKPzRy7w/KSnVH3LYQcKDPyvjio0Effgfxo2W+wLRWFBv+iMV4E0rEx
         xO0jxiNX5Q6KiFFvO+0Z3aVPa+zrSpPuMTIJPIi5y2PglIRxV3wqGzlOQ5xA9YqnYBOh
         LU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062679; x=1773667479;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWdO/bTxThCt2UJ38v8pF9JafjdbDv6ZEsdeftb80X8=;
        b=Irz3crsx1YXK4V3wae6K/6bjo9YDGJYE5JoRyxeyQL4orTrn4dWKwxH4CHaA4jrGWl
         WaouLTqNGu7yqi1Q+i4b756L5RSsFsOIk/orKgo1tI6Ok32dIJt9pqK0LNza8oKVrvdU
         0x/iJPixyIKosSiETcfEMmXxbAE708T7HYtYuO3WVVrMGdLF3HBZ6NwZ2/j7zCPX0qvK
         a17fHFnf7YqP1Jsmw/OaLk0RTmpxgwsH+QCGfDr8QzLbEt6QVwCEhQmSVgv/LlGGIPPy
         MNOWNlqVjhj0G0LCmQxPNB3txXNpYu6IW6Pj143VulBCOUrrgvC5UjqKUKp+ENMthI1q
         ZZ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWuYKeYGkHYojxGr266s/ApQnCnl3AT5KfTxV9CQfV23NW/QGulDhzolAHrT2hOZBKbm847RCXg1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5dHab7BxDF1ngIZ2J9+kZB6OH9doqFBt2aeYWnSyR27pdiFE9
	KwLF1lMeVKRgLTxWNAQaTyr6ZmhJMSjNGBVOjxjqx0Q2AzwrhHU+nRPwhncCDYIm77RDsxDfjZk
	sM0whO94=
X-Gm-Gg: ATEYQzxCgNQsQcQ3zdx3gsESmvSbr1vQxYYIUu4LSY/4thp/5svnJ+ibcV+vO5v0jAO
	h5eHqUbN1tYVkGfIUtBP4EqM7NBsCoGnxO6764PihocO4LYr7PLz/tt2SBhF2VpNDNqUYkhl0S1
	fQ0uTIYMrtLdWpgjmpoMU+crCFVdDcuu7IIdbdZ3ARIyG6gvCLDAPUe8rwKFCI8TAfDmwbj8iQ/
	ygI/7t9NHaRbjhjJGB6FY1tIHe1MDjtz/hdymLIJDMSve1AaT/p8D1i3HsacgS86uRubT0KvHxu
	cdBlhPICR8JxTGA8xap/4PxMkfuM9KIhKWxMBGV0ucSJI0G6lEoPfX1La/KCl1WPWHcvczWOXyD
	KLHrNXhoqwDk51ubeta1t9gbYv4NbGT5I2+4y0UCU5ngBZXo48E3CPXNVE72DiRNJbzLo1CMwEh
	/y5ZyKYkhMIZxv3gWJvrOGk+iRcaYNLAQf3PRr3Ri1RLhtP13YdA==
X-Received: by 2002:a05:620a:1a1c:b0:8cd:8452:9b4 with SMTP id af79cd13be357-8cd84520b72mr498646385a.12.1773062679458;
        Mon, 09 Mar 2026 06:24:39 -0700 (PDT)
Received: from [172.19.0.48] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd90608105sm65498785a.34.2026.03.09.06.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:24:38 -0700 (PDT)
Message-ID: <af558995-aaee-47cb-8099-759462222370@kernel.dk>
Date: Mon, 9 Mar 2026 07:24:30 -0600
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
 <56a3e17b-8ad1-4623-bc8c-e8f4e9f4e265@kernel.dk>
 <218c175c-680c-4ee2-9e00-c81202e4841b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <218c175c-680c-4ee2-9e00-c81202e4841b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 98C54239BB1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12587-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.984];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/26 7:21 AM, Pavel Begunkov wrote:
> On 2/17/26 15:15, Jens Axboe wrote:
>> On 2/17/26 8:03 AM, Pavel Begunkov wrote:
>>> On 2/17/26 13:12, Jens Axboe wrote:
>>>> On 2/17/26 4:15 AM, Pavel Begunkov wrote:
> ...
>>>> The patch should just be removing that addr3 -EINVAL case, and adding
>>>> the two lines that check IORING_SEND_ZC_NOTIF_USER_DATA, and if set, assign
>>>> notif->cqe.user_data from addr3.
>>>>
>>>> But I object to saying this is a "degraded" uapi, to me it's very much a
>>>> better one as it allows all values of user_data, rather than have some
>>>> magic 0 value that's not valid for no other reason than force policy.
>>>
>>> Well, we clearly disagree on that one.
>>
>> In the spirit of making progress and not wasting anymore time on this
>> fairly fruitless discussion, I'm fine with adding the else branch, and
>> hence v2 as-is.
> 
> Looks like it got lost / forgotten? I can't find it in for-next

Indeed, I think that was waiting for last weeks rebase. Did both
now, was OOO Wed and on a plane back now, just catching up.

-- 
Jens Axboe


