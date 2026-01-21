Return-Path: <io-uring+bounces-11861-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIS3Kln6cGmgbAAAu9opvQ
	(envelope-from <io-uring+bounces-11861-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 17:10:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD2059B4A
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 17:10:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4F75272EF0E
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 15:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64692363C7C;
	Wed, 21 Jan 2026 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZziRADvI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89B136828B
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007597; cv=none; b=TghYQJklJfFg+xOxga896eOozse6iVIwer/wD9+eFUkWDPDBSqWQnsopaDKRETvBux6ZkcrVd8E2gL1kZhFF0WoAWB7iWgwOBdtGanKCeNUQmR3hBO2iiZ/g+rXs8vQfS70Km/pWqOWnx/VhOM78S9Rhb4oZywDRe3LBFe/vYXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007597; c=relaxed/simple;
	bh=qi/Z2ETe5nVMmlpmskkRIftB+4ayylMZh0aXzLq3at8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M84Nhz0g62hcSTT1wSm7LbEHNJDfRTuUrboRElP0Cso7fybQkWv/F6DU2KGNyN5OKFp8xYREQuS2/x4uo/8ZQupAnBJ3p41daYI1wx5rkZ86XDd0a/04w7K+2vZettSErQgnPLj8nYgwfkp7pXwdMheLp8bfdPRGNKG7t5gofe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZziRADvI; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c78da5936so493553b6e.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 06:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769007593; x=1769612393; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3swerRYnwqhWtpGyAPWU/v5WaTeow8Irh6yZszKDEkI=;
        b=ZziRADvIhceKrFpYLHxgIjcqKJImsOhum+4ZSiDjluNQ4EC2So6bN1yUm9Qn9vO1PC
         oR7AZW1ZT06+wuRRAerFCOz6+ISe+poGwgkIwX05RWhNCfVkDO0maAIDGYbxDCfeQxgB
         V8pNRQUiFcCiqYCbM27jCMcD5XOstrfUCNVOwZW1oQ2d5mDDdnp2dZWMezOgrAv9b6HE
         mkC+RykoYQZmjntLZrAXx4RHtayV5QJUJv7Kb0U22zfBhAXYjf50+FFWFWV35bQdmibr
         Xxlp9hBdOkC8rjboiezFn0oDwVY+6fw7S0LBiiNVdK9RM5jBdy9tXrPXiSBX3I0jsCv4
         J27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769007593; x=1769612393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3swerRYnwqhWtpGyAPWU/v5WaTeow8Irh6yZszKDEkI=;
        b=enqkT2wXTdEl0Jiwp/M51tqZNbAImDI3RES9D4/n5fPlofQazEchFS5GETCVzJXXM9
         Q8Mb9rPUWsD7hBlgwS66K5ZBTKi7b7lnNUFk8fDWQ7KSzXUICWRIE0/meKkTo1s6X/vA
         uyKl0SeE66KYlJA7I3n9S74MFqhXFtj4QYtzkwujZGkT4Tao+DxXg9X841Ar8mVsKYFo
         kPonNxvcOLkavLcuPJgBdoBHDuGG9t3I3BCgZoH43p3XshEORPhchFFtJUeKl/N+hwn0
         G8Csb0Tft/caPSKehZjFLkTHi23ab9K8hIQtzhLA8cBDUOYcMAiNWkA/01azmhIO8sv4
         lgxA==
X-Forwarded-Encrypted: i=1; AJvYcCURtpauk6myaH1KXUkja/viN3/eGCvWSy5C5o4eD5nxwdSV7h0X5bo+R2zyUawcaZ0563qmtNG05Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJO0qwHLZrrpykfe6/XOwFuiXJ0wksqX7P1ksUUHmGObfWedxk
	AgvW4buHgDUz+N4Fz4PkMBYFFC1heaohZMG4K+u1uEG/MqJxLb0+pwKuFqMXB+HNv1qdG3Yemrq
	I+Lz2B1U=
X-Gm-Gg: AZuq6aLfhhJmFHfJXnfZIY7bA55KPVy2MyeFiWLAUy/fLPxjfLqNXzlL4NEVIlV8qMA
	6egwcgav7Dkw4W+m9YC4YpxcbN0mWxAivM9w8OLsroy0tydYksgJeoFXbIz7+Qqro2TFN0DLpx9
	ngSEsrChaml9n8DXSL6zMg1BQZTubDkk1AedMQ1uoQpWW+K+IXm/44NsJfD/ODrHdlUrzZlhY0r
	LVq6vlLdqzAQV7jW+EGFK7wwnNziXjcclvD+qIgNWOEdgyYaLv5Efhvh2a/qNSgzHALLQLM0FS4
	gDoagdmJPmo/xMoql2/CwuG89JolhhUoum7eU3Rd6TFfgx533P1//b01JsoQKRp5oxPKSCCW35l
	PqFi0uYSCiz1iPGJCspKqgSEam0rwpOcaaa84ZBI9HdumG7nCuP4IL6yrcYuR5b9BAzvYO1Psiw
	zj1bkHoi2v0dQO9ZfOTMQU5pnKYqoS1Gb/Zlq1PjsX277SJ29CQ3jpZJFnZ/mtNQoCjNnYcWhoO
	70rAJhG03oCJP9atQ==
X-Received: by 2002:a05:6808:50aa:b0:44f:ef44:9cc4 with SMTP id 5614622812f47-45c8817ac81mr11585873b6e.32.1769007593003;
        Wed, 21 Jan 2026 06:59:53 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9df08545sm8441805b6e.8.2026.01.21.06.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 06:59:52 -0800 (PST)
Message-ID: <1b75c1d3-88f9-4946-8303-223b068c38c1@kernel.dk>
Date: Wed, 21 Jan 2026 07:59:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] io_uring: introduce non-circular SQ
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11861-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Queue-Id: 1CD2059B4A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 1:47 PM, Pavel Begunkov wrote:
> Outside of SQPOLL, normally SQ entries are consumed by the time the
> submission syscall returns. For those cases we don't need a circular
> buffer and the head/tail tracking, instead the kernel can assume that
> entries always start from the beginning of the SQ at index 0. This patch
> introduces a setup flag doing exactly that. It's a simpler and helps
> to keeps SQEs hot in cache.
> 
> The feature is optional and enabled by setting IORING_SETUP_SQ_REWIND.
> The flag is rejected if passed together with SQPOLL as it'd require
> waiting for SQ before each submission. It also requires
> IORING_SETUP_NO_SQARRAY, which can be supported but it's unlikely there
> will be users, so leave more space for future optimisations.

Do you have liburing tests and man page updates for this too?

The feature itself looks fine, makes sense to keep reusing SQEs
rather than always going around the wheel.

-- 
Jens Axboe


