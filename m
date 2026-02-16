Return-Path: <io-uring+bounces-12259-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDADCUlHk2mi3AEAu9opvQ
	(envelope-from <io-uring+bounces-12259-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:35:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B657C1463DB
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD07030089B3
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D138C8F48;
	Mon, 16 Feb 2026 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XZCR7r5v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8642A26158C
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771259718; cv=none; b=FCUggIIFVFzNpmvyls+QzV9CTTe80L+dCVSSxwlUQGOSJ9But71to14eLMiUXRTj9vEwrrcbHDVQoO7JyLk2eBCN0uRYR5Cl2CweFkhNYgByf8ITEWl6efeln9Rj77JmRvwbUY6Ln178ROsfjR9/w8pMvFHdLO3nRq0G0tQblfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771259718; c=relaxed/simple;
	bh=+8KPNwFbt15+Z9jAZEciQcBXTyJ98ur7YB1h/HWRLQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=snZw1prEID3vTKRzbbtuANJJE0xZaUPwm6Vy1qM3uOCIx0U34SNqfS8fAKNwM8Y/zYgIha9uARCj8unPOTYTg8jVFOgjq/keO/mRA2nCyebqiqwDXnDAgabYXJlZKJxSQA3MCUN34E6ZtJYiQDRHgVhuVtAbw6K1WQxn1nsmvno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XZCR7r5v; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-463967f35d7so2015002b6e.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771259715; x=1771864515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dWEZpEz8hEEXUVD+o5wlLkFA3Ns9YsOAjcCTAhXAKA4=;
        b=XZCR7r5vU6eCK6j3Xs2pLZtY7qXAGJ/1Gk/ZdWrSBEQANWBB/w3A7gT+cNnSRkgMLo
         roWnhUqnSlOU+Wg1f6xLyxhIkQS8tv8xq+Y0Cu7p/Gm/LAenKNDyHirvYuReEbU+5lhD
         +hUiuQe13cV3fooDSGPRPMzcmdR6lZagB+uenwUsahhetMseVm3O0eMxypwXGIWw6tZw
         mb1si+y7XUn8KMlo2TR05Lr/OzgKThhBqAHuO5lo1p6ZWDrfrIld4fRFwjOn/XsGRx9T
         QhPAdCamouBBwyXHlPBcgfy3FXtT/SeVbSw++XSi+5jMYRvZvPi3ckEEJVbQdLi6Mfc1
         SAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771259715; x=1771864515;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dWEZpEz8hEEXUVD+o5wlLkFA3Ns9YsOAjcCTAhXAKA4=;
        b=e4FRiaI0Af78xqcCMCUlCXJK7s7GEZ3mHxrRKhCFXz04wBZ4uRvc+BJT3VEFL8fZ1Q
         6Zaa1ZWHwQKlVlpJVcuXU7s++Vgpmr7ZdnsMPMW21SGE1kzMJV3xHhKXXegz91Xb5Up+
         vJNBtq3Xz+JFn4UsBNEcCwZoEUfzo5olCsQzNXgkkKwK598q+8TCm0JdI8/wU8Eo85UI
         2OuMUWXXvwQSwcKnLH44F0vBDuo/XN+758lhKJv6ZS+ZrqpQO/x/nlVOPu39pQLUYaLV
         MUboXWzuXNjNjkDIfOsR5OQbT1LDVNlnUjLher4Oat48l4URONrrLsu9ZTWfSpNS7xo8
         mpWA==
X-Forwarded-Encrypted: i=1; AJvYcCVkofNlcW50Yjb9jGDYAuenaahKG4Oj8xjAT0phty/FIzsG+myRr0IYSarBqsOVtYRoUn0BIF5clA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg7gqDuxz7FLRXKS78bBmZpdIBJP186Fe33fxhLRel/Wd129CY
	1l9IuP56uQq4T1yctfEUXqkl/vfWT9Ox+CA6KtXhqnrbblIRj/97tcvR1zDwItq+V4o=
X-Gm-Gg: AZuq6aK6djrga7SHxDw2kphiYkOSOkkOJOI30xlMNcNGS+ZzQRI8AVbMdZwsdMpTm/A
	ShDI876V3FeXjVXvlpD0TUsni3iFXaa5guK5Vtoz66hV89UEp9Ljbgehn+InJWIkykXTclw+SRC
	wSMyY8oVFmvQX8bD9nKlntyqcyMokIDBl0aJdlzb9fIeUYTVwvh9ynrW9/uWaSN1EV+bf+y0aYG
	C+OjYuBkVho2UnqiyMpfX872uc9lGyy/XJKg8r794IkWmrsfhgMJlIGu3fwxbKLgRyL1Tw+fR0D
	xAH3ldhJ7zncQbI3LuYeKwn0O2iv+oFFIPQCbcMTx+Q9okcnPM3E5SQMW3Jna+IwQymJ8sbfQaU
	/z4nJfq5XzsQsZU4zJzU7oskE2zGOAOSrXIEtvcAZiNAh9D2lO9RTVmQxdCieY7yVNwTQrVYfyw
	BZcT1TfuSNcu+cWcb7FyYylwO1QerAcyy7AuoRlchrnZs8/FuFjm0WzUv5VQrer39wwQhGKdaKP
	VzEe1+EEg==
X-Received: by 2002:a05:6808:4f08:b0:45e:e0d5:95ee with SMTP id 5614622812f47-4639ae311d2mr5662122b6e.52.1771259715475;
        Mon, 16 Feb 2026 08:35:15 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-463a6a369e3sm6411630b6e.4.2026.02.16.08.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 08:35:14 -0800 (PST)
Message-ID: <a2d0fa90-463e-4b97-bea9-85ed6b0ea85b@kernel.dk>
Date: Mon, 16 Feb 2026 09:35:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] deduplicate send and senmsg zc issue handlers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <cover.1771240334.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1771240334.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12259-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: B657C1463DB
X-Rspamd-Action: no action

On 2/16/26 4:45 AM, Pavel Begunkov wrote:
> There is a bunch of code duplicated between send_zc and senmsg_zc,
> let's consolidate the functions.
> 
> Note: it's based on top of Dylan's patch removing buf/len accounting.
> 
> Pavel Begunkov (3):
>   io_uring/zctx: rename flags var for more clarity
>   io_uring/zctx: move vec regbuf import into io_send_zc_import
>   io_uring/zctx: unify zerocopy issue variants
> 
>  io_uring/net.c   | 125 ++++++++++++++---------------------------------
>  io_uring/net.h   |   1 -
>  io_uring/opdef.c |   2 +-
>  3 files changed, 38 insertions(+), 90 deletions(-)

Nice cleanup, looks good to me. I'll get this in once -rc1 is tagged
and a 7.1 branch can get kicked off.

-- 
Jens Axboe


