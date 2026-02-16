Return-Path: <io-uring+bounces-12271-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHDhDJJwk2nk4wEAu9opvQ
	(envelope-from <io-uring+bounces-12271-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 20:31:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF6E1474C3
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 20:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B734303798B
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 19:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DB22EAD09;
	Mon, 16 Feb 2026 19:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WjXGCGLe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B865270EDF
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 19:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771270274; cv=none; b=OR6XjCTg4S/MO6Zxgk2a/oHYqJKtQ3cIFnQL8stFshbkwjlH2m40uKzs2MKXiqnLZGUPfurUNNYmmb2qtpi2vSwpg06osCOpYSgjeoSKbDf4FhuyRMxJqKKt7at1NGYky/NANNpGLjXz7srbSX3QSK5mpb78pqXBhQJP32DIEuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771270274; c=relaxed/simple;
	bh=5LkCEH7PCvp0KTQ1nCDvN2mdPDuX881mkd9aectmrRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SlEciK/8ZRsNjRbG3bmGrmOuWWIo3o+H/Vv3+RKpOQBEWvueE+CJjWjJnPx2bnFJh4TEaklJqqZak65xGab9JFrufewEzchCtCl9XL8rJiR0BV1HlAA9fLjr9dy+4U2c0ClioG6soOUOiAPzJOSkISB34TKbsHw71vJ0Nnu3PDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WjXGCGLe; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d4be7c4ebeso1983071a34.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771270269; x=1771875069; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9moyXsTzCUADcAY7M3U1Yqe0jCuF2Om5P3kLH/jjSJw=;
        b=WjXGCGLeuASO5p4ygeDjg2Z0VDtf66tgvs9va2VrbFUnEqjE/XbEw/V9dgvrQqjzje
         3a0SBFmcFMQAtnloujgbpLv6xLWCafYE4Pmrx/MElXqTGpCwl276PRTLHs0gvRyKkE8r
         zkNIuuKbA6vZ+g2TGjrTsYIJ9yhsRwcuGnPV/OaJfntleb9cfamCretnd4pbVQ+5o/yR
         YfEJWWZ2kTJYGUVsse1DCekMzI4IJdx7u5YJEhYkj5E0/ekPikZrPoUiZG5w6TmEuZPf
         WzVWJ8cQ5sHCgGe0QClcEVBj/7eMxB1OQMwI60hcCnIAjTz4uqz7IaaFo4TwFTCsxRNe
         qi1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771270269; x=1771875069;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9moyXsTzCUADcAY7M3U1Yqe0jCuF2Om5P3kLH/jjSJw=;
        b=GtD+FyT8Yb8/LmWeTBgbHl0qGf/RmYun13PDu3Y4HeMQisr0WxJjUMWttyGEeVC/C6
         CGpbqqj12NdWNSQRZ1/ebCcMnaibNSuRAUXJzULePeTMqozxayttZtdBjc+LXCJYOI/w
         SnZhm9iA3yuENIGdjdlOvfnP18pnyY8cmO0RFiatDgy5dc11/IKIszEuw5c3G+3K4OFa
         NWXcKBqo2ri1BvmStND8Diwesi1bSAJHH7fGrZdHJyY53l4OHf3Oar4yBrjS5FOUaGLu
         Zg+RmVwv5LKSlqrSHLpgN2nY+36U3JSUltAnTALB2M1V8H3VTQpzsOsqsnhEEKVH0VRI
         x8Dg==
X-Gm-Message-State: AOJu0YyaH9HhhBXtggRP5jv16F8+ZS+rKJ90D8Vrwpq99ZxJN1ceO7we
	V3TAlbd4mF8x8MyvjQu6+pVzyL1XOJ7R8XlsCC4nXauKDUdtv/5rER2DTqs4tNV3TOI=
X-Gm-Gg: AZuq6aKe7Eo19rTn9dPArVI7Fy8lEyzDQduJqUWFZmDR8WWmdNSK3dc0g+aB7RuDocs
	JC+uNNSwFny6Bh4pCPOg72PlZ+mWbPOU/pePzALHL89qSrwpHxJ+HfyxRHMAbJ8mtAdFJ3zKF6q
	+PyaTvBpBqlZHdI6alb4w7G9JzmXjR4wY7qQYJvSzNGzfThldnl732OEmbw6osM8CI5R1VNqIkv
	F9N5ZeVp4S9cVnFJqtXVXeoX7Fj/02jlWfACoS4VXu/fyK7ekBgU+sNHRKdKzoeOwbxcMVoVOvd
	CVTxsxFCzlpcdaaaiMiSJLhAl5dZaZEUf7aOplo7tRfg3x3+XT3czGLfZO+0cTsyPJIYt+9xs09
	QyzjC8Vt8o61vossFAJpqQlfxGW+8RRt/mdgInJHsHiRHEKrZNm1cv0WbK/oASDKo/GLat1/cGP
	BNsTc46n8Y6qJZsWeXiwAi6oTWL239c2glzIhrQtasuUlJv9sNZRVEb90p9OHYfiHawvLGYFuDd
	ebDOsEP+O79UIUi4bma
X-Received: by 2002:a05:6830:661a:b0:7cf:d201:c32d with SMTP id 46e09a7af769-7d4c4a0a6d1mr7105592a34.3.1771270269308;
        Mon, 16 Feb 2026 11:31:09 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4c6727752sm8124012a34.23.2026.02.16.11.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 11:31:08 -0800 (PST)
Message-ID: <2240f73c-628a-4181-8720-8d9bbfd90ee5@kernel.dk>
Date: Mon, 16 Feb 2026 12:31:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/cmd_net: split ioctl code out of
 io_uring_cmd_sock()
To: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260216160354.73239-1-ast@fiberby.net>
 <5bdb3ec3-8b25-4021-9d99-f866c4fd588c@kernel.dk>
 <4f0b080b-f5ea-48c3-a507-c350d3b9d2e0@fiberby.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4f0b080b-f5ea-48c3-a507-c350d3b9d2e0@fiberby.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12271-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+]
X-Rspamd-Queue-Id: 8EF6E1474C3
X-Rspamd-Action: no action

On 2/16/26 11:31 AM, Asbj?rn Sloth T?nnesen wrote:
> On 2/16/26 5:46 PM, Jens Axboe wrote:
>> On 2/16/26 9:03 AM, Asbj?rn Sloth T?nnesen wrote:
>>> io_uring_cmd_sock() originally supported two ioctl-based cmd_op
>>> operations. Over time, additional operations were added with tail calls
>>> to their helpers.
>>>
>>> This approach resulted in the new operations sharing an ioctl check
>>> with the original operations.
>>>
>>> io_uring_cmd_sock() now supports 6 operations, so let's move the
>>> implementation of the original two into their own helper, reducing
>>> io_uring_cmd_sock() to a simple dispatcher.
>>>
>>> Signed-off-by: Asbj?rn Sloth T?nnesen <ast@fiberby.net>
>>> ---
>>>
>>> Jens, I'm used to net -> net-next taking a week, as it only happens
>>> through Linus' tree.
>>
>> Looks good to me - since this is just a cleanup, let's defer to 7.1.
>> I'll kick that off in a week or so, at which point I'll pick this one
>> up too.
> 
> Thank you, and sorry for posting during the merge window, I always
> intended this for 7.1. I just took it as an invite that you merged into
> for-next right after committing my fix to io_uring-7.0, given what I
> wrote earlier in the RFC: "I plan to submit v1 once that patch
> propagates to for-next.". I wasn't expecting it to happen that quickly.

I do it a bit differently than netdev - my for-next is everything queued
for this release, and the next. You don't need to resend patch headed
for 7.1, unless I for some reason forget to merge it... But I tend to
try and tag these things so I don't forget them. It's a bit easier post
-rc1/2 time as the for-7.x/io_uring branch does exist already and it can
just go straight there.

-- 
Jens Axboe

