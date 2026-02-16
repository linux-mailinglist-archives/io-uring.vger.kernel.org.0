Return-Path: <io-uring+bounces-12246-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8K6IFDo2k2mV2gEAu9opvQ
	(envelope-from <io-uring+bounces-12246-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:22:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B95CE145772
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43D58303EBAC
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B1631D72D;
	Mon, 16 Feb 2026 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A4C/EmPn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAD831D36B
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255055; cv=none; b=LKr7ToTJpB4Gw5nQ+NvozTo+ozOu36hUnsP55FDYByxAF9ngsqkS1WK18XI0Hw4OBEgKEV+EVHaqsSfReC7/Ih7sYKIe7OL4OSXXENszZu+/XEYC360jGHzvwpja5tDgam0yuLPkwu1lXWAxqmO1+U+ZS0r+++lnir5zwfcvipg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255055; c=relaxed/simple;
	bh=qJw0joW4EjNsIlJaj2C7aIWaKGEHhlr0Uo4RZ5N8S/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=np5QBG/yPs/g17ehgJtxZBopb3fOc95VUKdXZw7SgQ38NBuVi9mOmFopMshi3jp3Ssd0ErtM00CIFCbXikkPwITv1l1cGNXaL6q0aTqyp6bMFZK5o/JXYJcXkN9K/qmzub/5AB4WXRrl5T9FVUAZa6wN3y0+0VnVwmkh2ThKniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A4C/EmPn; arc=none smtp.client-ip=209.85.210.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7d19d3c7208so2179755a34.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771255053; x=1771859853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9C//XEZDNwWkGCkC2JYMJxrOrxKQOzrtF/PutHIOjQg=;
        b=A4C/EmPnd2qvDNbb2Sv0E5xxxmRSGJFL+pdnyL1M6D5ki+INWF5YdjV+8nhUT/oXmA
         5xApCyAtKc6wZJQd0/7unzvzhOnRWcWu6/j/ktCpGZoz1eF0iL03vyPv7BM4BxkWO1zG
         ngIwYYMGZ9MH9ztC3vCQqWeQWJqqK3swng6JAPKUWRS8uLcV9tOPsOOUC7bFcHN7U9fx
         w7UhOXsa7hxnFT3Uw38TUoXju5+1uOd6zNvvmC5s4q9PVmDlK7QnaZ81COChIzW3gmyW
         FgHEbyJ67QsVDScPUY0J62z6W7rczj7qQSpd3Y8PUfuo5/aqX05E9W8LQH+amJbYdbuo
         gzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771255053; x=1771859853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9C//XEZDNwWkGCkC2JYMJxrOrxKQOzrtF/PutHIOjQg=;
        b=FILWBQJ+x+wsjuJVMeeV9KTtbxkwjHiGiURYUGAJNA+UZaewg4X8L8GIUuRqoeUXPJ
         TzbYi+oWbqQuGbTvtr9QFCvMIn6vTwghDfQQF5GVAluggz3pVkrYiBxssqZd13MXRNlK
         9nWxO72kOK+bhjBFJqgnHNuE+4wyFT9ohuz87HEiHRCdimJIL6777EW8nFtH8jGW9ghE
         G3cqtTwHc8cEMK8I479/e5179rSCTHS/tLSPd3ilefW9NUo30ukBCkOI/2gk6W3/UgsC
         NtR8fvHqj57miztUZNfL2DExaLGc+oMWuMDA/l0nRouifg1r9s20a7Qy1VN4U5CXDoD/
         t9dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKc264qLOGr9cNLsEoFWFDAgZ6HpJNwAXUuCqUv5V0lK9VUda2eNB6ENrVf1ERK3TeG8HLbXg8qQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyF2gwx225keAAx+nxaaK6sq3q+tKB0dAtB9KwKGI7FAuoTF28j
	ZeG6ZLJsyq2WpH6zfFk1wBIKFZ0EVipemUBRmlnMIzQw/i1drLBFXj9Y7krl/RCoi14=
X-Gm-Gg: AZuq6aJMgHs6xveQvRORS5ZlhedoyjJ75T68faiTADHI9OtDO0r29dxF2FUux+rbAVx
	iuu8ETFSA6IUDFKMHGMQF1333brVw8F58sa/hZSfmy+XyceB7hkJfVcMNZFa6Hi7XQ6AI0dx/vR
	VTQjRzE6uRohyPfb3qpvfnswCLWmcSw0btuGfJOQjjRlYrIgFXujJE0/GklQv2YRtdkVLFByM35
	fgPe1222UytXmXQjr9lr4BmNiT1t8snql3R8ZqYgMYqIq70UaY8YtMbBbsE3zBVmZIGpSRD9ol5
	jaNkEH+GN+dShXzP5d2bGccICuyO0ey5kODJ+wJGbjUu2YrbTakIn+ula5Yc7yF6aKmNAVCPRWL
	bBLcXz+SjHwEhk7cglxZAKiCH6UnqjEdIxXt62WAhiHXSnwStRraD4Ww1tohrT42/v2iwqgiN58
	VlWbZsOjjbcPFV9ys4dRmGjUBi78FoctsomEFbr4IBCd/iZ5KGROH8HnYwXeFY2z/0N2jqdPLYv
	0147wrLqQ==
X-Received: by 2002:a05:6830:2708:b0:7af:1d61:1055 with SMTP id 46e09a7af769-7d4c4ade32emr5905053a34.21.1771255053074;
        Mon, 16 Feb 2026 07:17:33 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4cfecfd7dsm6518125a34.8.2026.02.16.07.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:17:32 -0800 (PST)
Message-ID: <7f1f9575-b9a7-4c67-832a-d8ae45d5dcd1@kernel.dk>
Date: Mon, 16 Feb 2026 08:17:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: document advise SQE field reuse for 64-bit
 lengths
To: redacherkaoui <redacherkaoui67@gmail.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260216113701.4650-1-redacherkaoui67@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260216113701.4650-1-redacherkaoui67@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12246-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: B95CE145772
X-Rspamd-Action: no action

On 2/16/26 4:37 AM, redacherkaoui wrote:
> IORING_OP_FADVISE and IORING_OP_MADVISE reuse SQE fields to
> support 64-bit lengths without extending struct io_uring_sqe.
> 
> For IORING_OP_FADVISE, the length is carried in sqe->addr when
> non-zero, with sqe->len providing legacy fallback.
> 
> For IORING_OP_MADVISE, the length is carried in sqe->off when
> non-zero, with sqe->len providing legacy fallback.
> 
> This differs from the more common addr/off/len interpretation
> used by many other opcodes and can be confusing when constructing
> SQEs manually.
> 
> Document the field mapping in the UAPI header to clarify the
> intended behavior and reduce the risk of misuse.

What is this patch against? Not the upstream kernel...


-- 
Jens Axboe


