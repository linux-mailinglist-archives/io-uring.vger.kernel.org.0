Return-Path: <io-uring+bounces-12418-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCfqHicen2lcZAQAu9opvQ
	(envelope-from <io-uring+bounces-12418-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 17:07:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D054119A3F2
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 17:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1A573019BAD
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 16:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF45E3C198E;
	Wed, 25 Feb 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lggK7ZbN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916583D6480
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772035335; cv=none; b=VBXyKpUKhWS8EzBBilxFYXqWSHXb7jE+bi1KCB8BLUMamSAf8/lCF8r8wvyOQoqvfbDQF9xwwPySTvfUI2Y7I6IJg+JEt5roO4QgI8YpTqPDBU0SkniguVFgkQxYpjZLLzmAts5LqwNZNTBA+JFzTo0IOSIK596cpid6lUmM6ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772035335; c=relaxed/simple;
	bh=jLCraLPS4X2czbJAbnR093R3tA6F5lL2vkQD1l5PEkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tiGFBrGoAuCMy1YLEFIuvwfDrkpf9L9Xw1DB0NhrBlsMse+5IisTSfm6wnRoBuM7oEovBlMbhWJsn+tmsz3dj2w/MLshqpK9DIabFKMKd9KEoE9+BU1mVWdesjn+lb9rIAIRh1GFmxuLYAqW10TCNm7gOdD/Z8bABQbHKDThVsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lggK7ZbN; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45f18e8f2f5so4838185b6e.3
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 08:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772035332; x=1772640132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s3Ua+njvWzcow557tvVCwtsOlf5lqG1BdrQ5GEwOo2A=;
        b=lggK7ZbNLK+aETL3SbpO/Ft1yC0YpOQ1XU5TywRtsokvBXGdglY9SzExfO6Xz74jEw
         I67tlbV9ilYrhdOXlEN4SAN4q2MDH+Y1qVQrvngtRDMkXilkXwlj/lWXdeX5W92FWt19
         dEjVBz10jrJ777HLpiG4P5Zy80lGQ8fdNI86ldVT/pAzJBs7F2xg7hk5EUahl4gnvW4M
         oBQeKl5EkCGmo+Hc/PprGtaRlEbP8lVuSezWsMBln+FVYserd00MqhS4HViRrV+mUe6C
         BM5S3vi87kGI3GgoaTGnFR+wh94gsG4gMhlrMmE4E2Ky82PplkvNZJt5+wYAbUEJeHSF
         uRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772035332; x=1772640132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s3Ua+njvWzcow557tvVCwtsOlf5lqG1BdrQ5GEwOo2A=;
        b=sja26PtJJKamMfKGQ8GNJtZIfSNqGY5VHkLnoZrT0XMSybfR/jwV5CmBYE1S3w6wcQ
         gBwALnCGSGP5bCueMgs+WA4tX48r5aOfrvwjBSZ1gP9WLodVri8Zlso/srC9G/2vItoY
         XkjkYoaXaS1xi7biUabJlJ2wGBHVngV1LSppA3tJk54xPDaQZ7/NFhT6q0V4aAqwXfQr
         7gjzRcm/WyR3ksQR+hc7/h5pErujN9X9ZpQtVelZMr82ZNntCXgHajW1ENSsiYT2N4uC
         2REYoxjLp7cDciX6KUQ/fzqmCd/iYZ9iRaGrr67+AeQDFl2Dav5BxQpG52Lr1XmbPJ5C
         S9MQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQwiVYErwup0sZakPk9miiYfBIexOM67oteDnPZ8TU08ZhAsFj5iHdPWhwTIpFPRPiqsobnkWltQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd9OMooQqcE4K+oal1USmjiizJkCCmi5xwSWpVfQ4Ey9Y9JCpX
	OHBkelF5CqALtuHXcQfSwnZGbc9GfmgWLfGZ3Xd2cNjP/8LpZCHUI1qmSqaJ21dB7YA=
X-Gm-Gg: ATEYQzzJmpU4ijJuf0oUM6u0Cstxwlb5WVbVPR74teY9DlAYQ2EdqL8cgl4vYe5FuZY
	LnwvKkHdV71rvR3nuCYe4OEZU3lJswmIdexprh/Pu8NHqAghsYlqqbO7IVHRWGKbzta7BatS9np
	Ly0D60FpbqFmYvzuIRN32mhkUmLr7eYEIv3QwUbJBQ+sRY1l6SqV5ykxgDz/m3l5ydt5T708tNH
	wE3+u9V0bYYs6wyvVc//BWAMJpN9JF4KYSRelPx97TALM4Wx9zd0GfeRtxNJJK679zA0DsElHkC
	qRSI0EQ1hl9eO124KpbBpzoo6U/QczObTSxFO5VEbiDBVD5mm5W68dU1WYTekVnCZC4UTm5ncut
	zb6tb2SWhfLXF/CSTtRVliO0sz0KEwrpClGR6xf6OSb22u6YOLfPl8rcAsadFtHLFBB0dQTZOhx
	qGY+97++MtcnzKroecLiYg/HbV8eDcN3OMWFJRfSl9hIHjc3wALvgtuFiGFxoG6NIeRSuUuPiq6
	9tbiG+L4hA5RBHCuqzj
X-Received: by 2002:a05:6871:7508:b0:3e8:8b6f:9d85 with SMTP id 586e51a60fabf-4157b0cf368mr9914294fac.29.1772035332184;
        Wed, 25 Feb 2026 08:02:12 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4157d2d320fsm12966124fac.11.2026.02.25.08.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 08:02:11 -0800 (PST)
Message-ID: <0c1ce09d-a91b-48a4-89dd-56650b58e8ed@kernel.dk>
Date: Wed, 25 Feb 2026 09:02:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] tests: test timeout with immediate arguments
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0e0674b59c96d821f884b9063607dd194d91b551.1771949741.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0e0674b59c96d821f884b9063607dd194d91b551.1771949741.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12418-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D054119A3F2
X-Rspamd-Action: no action

On 2/24/26 9:16 AM, Pavel Begunkov wrote:
> IORING_TIMEOUT_IMMEDIATE_ARG allows the user to store the timeout in the
> SQE without indirection to a user timespec. Update io_uring.h and extend
> tests to cover the feature.

On a kernel without immediate support, you get:

test_single_timeout: Timeout not supported, ignored

and the test stalls. We should probably put the no_timeout and
no_immediate assignment both in test_single_timeout() gated
on the 'immediate' arg.

Outside of that:

> @@ -1773,6 +1788,15 @@ int main(int argc, char *argv[])
>  	if (not_supported)
>  		return 0;
>  
> +	ret = test_single_timeout(&ring, true);
> +	if (ret == -EINVAL) {
> +		no_immediate = true;
> +		printf("Immeidate timeout arguments not supported\n");

s/Immeidate/Immediate

-- 
Jens Axboe


