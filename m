Return-Path: <io-uring+bounces-13894-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XTCqG3PeS2r9bgEAu9opvQ
	(envelope-from <io-uring+bounces-13894-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 18:57:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C5A713970
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 18:57:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=vZsRbFM4;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13894-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13894-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 71106307BE25
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 16:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD1A3F8EBE;
	Mon,  6 Jul 2026 16:20:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E5E395AC0
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 16:20:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783354839; cv=none; b=Q+/rkSLZ7AS14hV9M+2OGS3pmm+ey0PA7GEIbDGfc0YKKabW+qubpLvbkvpKDSk26xKVEZlJzwkZCWvLne+8bnlRIRWq4Y/ve7ZNzQSUGaOS1zawC8oCVe/c/kBsPGNalvw0uzY7Iys/Pegx6WombYMcez0CsXge4mWl5VIOwEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783354839; c=relaxed/simple;
	bh=oR0WvqZjV70FbMSpp+7vB1Jt9kCOVocW2H7FBZ5EjMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFmU5Cf1xTv9K9maCk8oO3NBhmnsedQ0qYbkdNDES2sihOsFufBa17LiGd5tDIQaHo+PjopGobQrnkKJNeQbQ7RJHKZFehiPgCUTtN4tOIQrpG51hD7xt/2mcKQuovuWkDeBUR0DlILcWST1lndRt51g7cGIYgeADvISddUc2YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vZsRbFM4; arc=none smtp.client-ip=209.85.210.47
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7eb68bdf53aso1043735a34.3
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783354837; x=1783959637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2cUQU8CIImJ7kDrBTq8y47XEOwo0AWHu00WcVNGsvI8=;
        b=vZsRbFM4lUbXUIp+uXwobDJBbLygNyhtUGauWVwvbbju3RzzoKE7xOEU2w5CAZXObs
         e9/I2XJjiNkl+Smi52q2R889XL1QThIZnYGMCe/WUAQ04CGmuRoGHOOgZjcTvhwNLQRl
         FTyFp7zFh57JOjFmpJfKjL8bPvdrWXzdPEWwYYNYYq4UfKYekmqAJTqGo/XphsBEq8hK
         HmcWOpGR3fcyeS+3kmsXgS7yMLVhE0dDd1M+RQraT3X0/BfDv/xAtFnfBh5/0zFXr7gG
         QEgbX0KTc11q9C8BYzNcA51bkSKB3vBt+QQwS88jNrQzGbefBEX4fYWGOo4O00zaxSAH
         BjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783354837; x=1783959637;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2cUQU8CIImJ7kDrBTq8y47XEOwo0AWHu00WcVNGsvI8=;
        b=H/2WhfwmbhAYELCy5thjCLDAHGJfJG2dTMi03N/fyzZ0upqnWdggaQnjjAnINTRHdS
         3GG8iyR2MDH+2AipTchP9PRScTddNhKeWHzvC++vrNYclVrdAXeULobKTaJwBPUvwP8Y
         TTtE5+NfD8bNwukgSJmVObreUe7mxUaS9A3D0Al70lGypyga7NPiY4044j/8PV6NCsd+
         TYvRv9l7O3+lGm55TFV4wqjPj24l7LD0OTabQuwsIh3jp4ITTkdtPO6mPo50ZBJtUuLT
         erZAo0NW3E2F76dPYoFR9qHvNAzmMZCQRGMg3yNNetHv61qjT6w7QVHN7y6yfEbnZiD+
         Sbfw==
X-Gm-Message-State: AOJu0Yw2FHq96tXLXS0L2ZBlMTFmc6r67bPsOFmhM2EfX2fh0/a2Ytak
	VvS/Gbgxy2bzYq/NvFt4esy8MCIqGB3qPzkgFf0ywqlkx+6cNAxWAfdgao3D/XVzhb3/cI5VBW8
	JY+jmbxY=
X-Gm-Gg: AfdE7clR1RO+rAsrc1lAZ7xYhrR1qjyuaQEjg47IRLNzVR5tBacwbb9fO0L5LC1IwsU
	Q+8xv3ZRnvbOPwtF27fhKiiv5I2VuPN1etXqSKgPGkqFfAwiaSrBh6WBWTeMl9+iEgbMaF/arM9
	SOmxgJAKsgvcNBPYniVbA+ZzpcS7ZfhUJRS5+tNq7YSG9usfdP4PZMz6L2R4FPNvN+DBnxKYEbs
	lTK5GSJLMP2d2fCIhVPk1jbcUWrV1LSctzIFlCM/7IpOaRKEhW/dUK03EC3HC8Z3PQnRskFEYqx
	oKkqR4J6zNXgRufsJ0qefsD2WCUaGAPiFS2BK97ML6zAH9tAR1kllUaOKNIwz6ApAKgUPIBVd6b
	BL3bt4cInB5f/Fo3Kfobrw2tT49BGjqRjnsN7YTynHCI0j2IMq7HAAQvBQqVu5mhP8I/78vm6ir
	CVaoTOYj3frCtc0X9CTWJiWafTsNOPyg2IHOnAU3zL1Ma+LJu7RWTzNyQ9FzSEhXJ5dBSmGeJ7D
	PRpx9DL1A==
X-Received: by 2002:a05:6830:2b2c:b0:7e6:c752:3f0c with SMTP id 46e09a7af769-7ebb23649a7mr629964a34.24.1783354837302;
        Mon, 06 Jul 2026 09:20:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb54291227sm11909993a34.3.2026.07.06.09.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 09:20:36 -0700 (PDT)
Message-ID: <0a370728-f8be-4aaa-bbc6-276376adc5ce@kernel.dk>
Date: Mon, 6 Jul 2026 10:20:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
To: Hao-Yu Yang <naup96721@gmail.com>, linux-kernel@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20260705234534.768138-1-naup96721@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260705234534.768138-1-naup96721@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13894-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:naup96721@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 40C5A713970

On 7/5/26 5:45 PM, Hao-Yu Yang wrote:
> BUG: KASAN: double-free in io_vec_free+0x2c/0x90
> Freed by task 73:
>  kfree+0x104/0x3b0
>  io_vec_free+0x2c/0x90
>  __io_submit_flush_completions+0xc03/0x1e40
>  io_submit_sqes+0xdb5/0x2310
> 
> Allocated by task 73:
>  io_ring_buffers_peek+0x559/0xc60
>  io_buffers_select+0x1c1/0x460
>  io_send+0x770/0x1050

Please also send your reproducer, the above looks a bit synthesized
rather than a real trace... Is it actually from KASAN, or is it from
whatever LLM you're using?

-- 
Jens Axboe

