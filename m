Return-Path: <io-uring+bounces-13899-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id re/HEqr+S2o6eQEAu9opvQ
	(envelope-from <io-uring+bounces-13899-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 21:14:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F715714DA9
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 21:14:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=ka+TCsPw;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13899-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13899-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08EE13240852
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 17:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C0D3B8D6C;
	Mon,  6 Jul 2026 17:39:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F23B7B98
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 17:39:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359558; cv=none; b=nnBiKXPDAooJw18P4AUV6EwAKYwxrmbpw1VyBxQhijeBR1fgFvmCwZ2N0DW4bKGDBh2JzTTgukfIzWlA0K9Vkjx0JqeOHAuE2Rdagj9qkmyc8ajG7TF8OGjv6Pw/bhZkQTaKmT21zeoa7us6AgsaM4PktfVrBCgvZfBtq3YaYV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359558; c=relaxed/simple;
	bh=uYzpmj22orIyaQQ3zp02L3VmOBVttpG5qJbjF0MQIyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YgASNigX4iiZgfJmMM5omrsRMR7Rer1ha3/b0mqmul/e75zUipBuETTmI2TRLfmjxE2U7aPWb1Dc7tL+Ub96VGO1SmUnuKE1IepUDj9wJdRAI1oPsOBHI24Qdo4Qw3S7pFzc+NHGECOZf19peDuus8+bnGIZ25fjtjcQHSjOc0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ka+TCsPw; arc=none smtp.client-ip=209.85.167.181
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-495c63c4141so2448530b6e.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 10:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783359555; x=1783964355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q2LV9ZLj19EGpD+IaiTun7+wf1a9LAhJH+7cuwQb1oQ=;
        b=ka+TCsPwjivsnkU2dxUEpmRZ6JO73ixYrhFGj7ixyWS33a4zX1ZqJOXqAhEhSMngZv
         URYlZIr+SfpesdlWezDXkz0MJedSK8Isu/yxOnUgKtq5MVka9h0GYVflPtxhBqf9XCpz
         /5h7vZIDMwUbnAFV61gHY1bMHGp2YHqO/2rtOL5NnhyetgEqJ9l3Ki9jil3SaUptYhX3
         /QBxJbNCd+mm+2W1k4/ubF+zWNEGaDTMYuC/Uz5uexHMiWcZ36CkxFY8wdZN8SoHF2YR
         tLe2wpoC4yiDw88LOLUk5vbgBQIv5jx2vhBwgdGPIjin1GsIpPJo7KpgZa3ZC0qju5UZ
         xweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783359555; x=1783964355;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q2LV9ZLj19EGpD+IaiTun7+wf1a9LAhJH+7cuwQb1oQ=;
        b=rNsbveV7/vgWnvVSSrxasPN0Kb556vjrtTOif/rCvSEBShFAk3SP69JCXGkd1GppA6
         xmJWFkc2CnEO+OODLK/uIu+dGoVg1wPe1uV9XZHWd+2C7twUOc1WTx4sCkSX/IeQwuGT
         K9dRhojgFlOljr4efF0SxsJ86N0kPKiNveTghBMdsaF4XNqpNfHPMyfBRruwBKnUUnFB
         Ub2Ectth/zy5tR6IeaDttRxxehQm1TV9+Sd2BFhSdO2ik1JBQw8PAFLB6FKa/h7URno7
         xpxn/5iLZsf+ai5x38YMwxMDtX69pmeSszl12KzpBCtR2pqaIG20BZfd3NSDf4X6HRv9
         EvKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ehmTtTtrrI7lYtZXUv9x+TQl5LU85VEHmeqXWQW1Fv08HxJgkcY/M4vOJPLBRrIetu/yy3ClQtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEOSKoKy+L6MErqGhxyAMh2k8oFQtnk/esykxBjEmFD6noFAV+
	CydUbQB+EKJq4LBG+45qPjopaHYPI5B5x5Bi7sWcSCpvoyrzSjKSMx1pVvKf4CDVQLs=
X-Gm-Gg: AfdE7clqvtx5lGzFxquQDw399Mp92SkJ/HJ27SwoFzAhiM+eHM+pIB39YcpiwifCk3A
	9wZGrh6ocXD4dSBDLOIrBMOWLQIL3uICmcdpP/n6rrmRGhEZlSAV979E5JjQ+mo7T+dhVH01ddH
	KHwRHS6tL9M9huRWNKPbvOG5PJ1bgj8TghYLwVHFkZ4Uwism8/FDXSTiHdmBF99xPm/ZI/a2ChG
	yaDgThZ3NVgbqYP4EU+JwxF2MkwIr5SXfqjP1Xrm9z5cyuqNjAyGyClAPrnCXMXLiNHllphXreG
	sicHC5JAgWnFgMDU9yA5VPby1tnkUliZzg8ZdHDcQNK8E6nTVDU3AI0mXytkaY7wxsMfGpXMjXF
	pplajTrytkAoveUfbCiDDv/6XUWVnbfJZIvKYXRz2ZFKkbEHEBfIwV7+q4Mh7X7WZVrUUvmmgEC
	FdoNS3rzjnAJUsGvVGhPNTPrnl6MbApHLRrqQLCSvQH7VHX0xEgv+zFpRHCxkPmoio5L99hgou1
	+j09M0ung==
X-Received: by 2002:a05:6808:6f93:b0:49a:8f0d:cdcf with SMTP id 5614622812f47-49fdc871dd2mr1317931b6e.19.1783359555652;
        Mon, 06 Jul 2026 10:39:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-497d1853afbsm9484686b6e.8.2026.07.06.10.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 10:39:15 -0700 (PDT)
Message-ID: <92f036c0-2759-417c-b912-8b6f003bc390@kernel.dk>
Date: Mon, 6 Jul 2026 11:39:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
To: Hao-Yu Yang <naup96721@gmail.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260705234534.768138-1-naup96721@gmail.com>
 <0a370728-f8be-4aaa-bbc6-276376adc5ce@kernel.dk>
 <akvfYLvrpF5104us@naup-virtual-machine>
 <dbf0ae11-ce9a-4c98-bfcc-ff3f8f12b26f@kernel.dk>
 <akvnOaiLOvcHyalG@naup-virtual-machine>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <akvnOaiLOvcHyalG@naup-virtual-machine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13899-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:naup96721@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8F715714DA9

On 7/6/26 11:34 AM, Hao-Yu Yang wrote:
> On Mon, Jul 06, 2026 at 11:13:55AM -0600, Jens Axboe wrote:
>> On 7/6/26 11:01 AM, Hao-Yu Yang wrote:
>>> Sorry, i forgot to cc others mail
>>>
>>> I discovered and wrote the PoC myself. Trigger way is
>>>  send1: Submit an IORING_OP_SEND request with four valid
>>>  provided buffers. The system will allocate and cache an
>>>  iovec array (of size 4) for this request and store the
>>>  pointer in kmsg->vec.iovec.
>>>
>>>  send2: Submit a second send request with 8, and I set
>>>  the fourth passed-in address to point to an invalid address.
>>>  Now kmsg still hold old iovec, but old iovec object have
>>>  been freed.
>>>
>>>  So this will lead dangling pointer.
>>
>> Side note: please don't top post, linux mailing lists always reply
>> under the text for better readability. Top posting turns any kind
>> of threaded conversation into both a mess, and it's also wasteful.
>>
>> Great thanks! Want to turn this into a liburing test case? Then we can
>> include it there as well, and it'd catch both UAF and memory leaks when
>> run.
>>
>> -- 
>> Jens Axboe
> 
> How to turn this into a liburing test case? Should this be included in
> the v2 patch?

Look at the tests in test/ in liburing. Or just send the reproducer and
I can get it turned into a test case.

Should be separate from a kernel patch, it's a patch for an entirely
different repository.


-- 
Jens Axboe

