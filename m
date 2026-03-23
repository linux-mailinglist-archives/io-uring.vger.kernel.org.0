Return-Path: <io-uring+bounces-12804-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKafAYZXwWmBSQQAu9opvQ
	(envelope-from <io-uring+bounces-12804-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 16:08:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 826A22F5DA1
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 16:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 40735305F27C
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 15:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5527139657B;
	Mon, 23 Mar 2026 15:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ngzzRSRu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4211B25A35A
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278097; cv=none; b=IP3RZR+jj3zfIan8jxFGvGZVHqCfFS20uBLYIrbRD0YxbRktySo0V5kA39MHmxOgL2Y5+osrUNv9QjUPLZr1JE26A7gfSKecWEvkM3GSRiZxvpGUIYO7j2Dgt848B2cT7pAXcT/KyEyitIOHw6TZfFcEGEJjCJLFT41GDMBh5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278097; c=relaxed/simple;
	bh=YJAGFGGqTDdOapPqoyMIufJSNynlGJlzEAnVFZvT4oA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IaD8yt8N4ROPARiA/hsVOyWodbXXndDhv1O1DkOASA3S0UN/yahZz5pYRbyFuO6U8aOXAYoO1fPYZJDzKeZUYoJHjWMMATE3keNLFjVRITwcC9shDs5ZS3zT7tKClH3iziuGJnmgL5GRlWIfbYbsk0ZtPT0yDt3M8knk3YXtFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ngzzRSRu; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4152698e745so1030069fac.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 08:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774278093; x=1774882893; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uOPOYS/nGpT6q8jY3dWvKs7qQBZ0laozgcfEFZVyZg8=;
        b=ngzzRSRuyM8B3sEkL1nkBwYw746zNpG1KVfpJREhN15HtNmX0w9trIFjMfkuANx+W/
         JPP9bMj/Ufz2oNoguTJyfY1zGK4cU+C6Wku4qI3/3ZXsx5G7Ol2nTv8h0CDhW/x7FbcY
         13j7fXR0WXHqW9IIHz4K9lB4wVGeuaeqvvmayFuL6Xioi3gmoTsGr08QatTiP8c6BkKT
         I6Dey+RWxOGSPKHFRhxkTOIBuRJHdD9owWxXQMFcD9vIy70RvcChG1k91KWJqCRNEH8g
         U1VV1ZNnOhEwL2vbXZJAC5Dm19rqmAofOYuoA1Uklkr3oekqDIC+dLWhEXVCN6sBlgaJ
         zg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774278093; x=1774882893;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOPOYS/nGpT6q8jY3dWvKs7qQBZ0laozgcfEFZVyZg8=;
        b=kOY+gfa8Bu41pHr3OmHxGVQ3SsfKVVAGQqZCD0nf522Qo5F1K5w+X+vCSmbA94tDwK
         RdhS3SPpqCRdiYUwGLbJsLXhvQrbNFBEFBahkYGY1E870D5FsNulC5kIESCC99YvZ7H4
         +wglFllye0ZuhYj+bavzMNBMfurGRCTosJOJhIwxkcJSCIWLIjjbsJFITOS8wY/Dc+uI
         l5nfGz5elctWNlRI7kB5Njz0d99FM/5y8yAqPzv2iQN8jeDWB0KtJQlebatMNdP8Gf3V
         knk+iqNOmL5uQU+m3FfRHdTh2zBb4hj4Rx+rDA6mCnh3/4LxI3kK7tIAALe6MZkA/mfu
         ae2A==
X-Forwarded-Encrypted: i=1; AJvYcCXE0KjtVE54lbT8OgMUGkAMmdfnSQ9ZIiCRG9z5BpcJ3CzfOVW0TZMxPqD+2NC9Ym5cDGPcNYy8Wg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/1LmJFmHcbwKmceD6RRmvXm8idjdGoU7oCmJpm6XvMxv9klvF
	3P56J5KQp/B2lSLNeUOlIK9YBvTWtsspe4OQLHiUN6aBQR68ZhCfC4aB4giCcU+d+Ec=
X-Gm-Gg: ATEYQzwOcOanS8kPl9oJc+hjV2vRGPL/umH3yHD/QhV46JRNDMVDS0GiEcFf3pQ+rGV
	nCrngEcs7VFvQOqovlwFGY0MD99VuGU92kMqGcTHFKKMSCWf2y+b1uORgCh+6Ze/q4d1bPaBkUm
	IPFuNJnfsyqVajiLV7Hps/2Jx0dMmpIsN2amN6IuVksKWCZuqNyP5UxPhqRk3FCKY1QW91+SjH3
	L5graj4UKNVKER8WfjCMpYo1wD3/OSVaMfhKzY77m+XVtZQyomfA32FwLZbo3xXlHpYcTk4Q9Uu
	wS75mtft/NSNw8S+E1i9UXg2Z+lPqcn2eCXrYdrdy0OLy0dB2vU1qOG5FQmEp61U7z+pmvFKQ5B
	qVza5MfOOsfgnDKtSWs9p0VdCoR5THsWB3TH1SKHTqTqnVTHl+nzIM0WaQJwNip503HCk+4Johf
	9t/Tnfmx/e5uHj9uNJvdpTJRmxSK0C0jm4HTtZQImuSBeaKGXjFzJ6/L+cdErOSQ7yW2ryTSem8
	7xeqJV7zQ==
X-Received: by 2002:a05:6870:28c:b0:417:5828:ed3 with SMTP id 586e51a60fabf-41c111f5247mr7123073fac.38.1774278092544;
        Mon, 23 Mar 2026 08:01:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14ddbca8sm10822185fac.15.2026.03.23.08.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 08:01:31 -0700 (PDT)
Message-ID: <1b3ad321-866a-4cb8-9810-5eae7805647d@kernel.dk>
Date: Mon, 23 Mar 2026 09:01:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 01/16] io_uring/zcrx: return back two step
 unregistration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, Youngmin Choi <youngminchoi94@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
 <0ce21f0565ab4358668922a28a8a36922dfebf76.1774261953.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0ce21f0565ab4358668922a28a8a36922dfebf76.1774261953.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12804-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 826A22F5DA1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/23/26 6:43 AM, Pavel Begunkov wrote:
> @@ -898,12 +933,15 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>  			unsigned long id = 0;
>  
>  			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
> -			if (ifq)
> +			if (ifq) {
> +				if (WARN_ON_ONCE(!is_zcrx_entry_marked(ctx, id)))
> +					break;

This break is inside the scoped_guard(), does this need an ifq = NULL
here? I do like scoped locking, but this seems a bit tricky...

-- 
Jens Axboe

