Return-Path: <io-uring+bounces-13328-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PuBMHPNBWpGbgIAu9opvQ
	(envelope-from <io-uring+bounces-13328-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:26:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A21535424F3
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 505473004CAE
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B7625E469;
	Thu, 14 May 2026 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="mawDdgnV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2000CA5A
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765165; cv=none; b=DpjiIuEvJR5lLr53ovdcRd0uaNWpGKN5JI5r2rz28gW+W2Hgwt2A6giaD1ITD8lNqITd1wxP7kc9CVSxNjXJfTyM3FARCZURqpeQyukPtn+jmkiwzTWHJYgPEDchW3qruU3/o98ePcZ+YfKHJpOawcxkghdyRzpxiK2lBHNag6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765165; c=relaxed/simple;
	bh=7uCudAWp/2ugWV7GwpWv8i8qCVITPuVE6+slUhHCnIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDEoOpzf++6jS5nokB6Y3PAbG89l0J+jcvlL5TXVGfwjBfq9lHEjCQ540roiKUx3KiF+/IlTncj+2nQTwBNZQn4tvkEU0Z5Hy0XlbJ51jhmUfz2cwqWSYxPyre//yrEObbXY5dj+bA3OOfBrp3HjedESQU/uqoFi6M97RY57Kgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mawDdgnV; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-439e43d16bdso1049394fac.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 06:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778765163; x=1779369963; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DREA9g2Kfe7wmoiXBkymc+fgvMh17jjhzIZtNHnDePI=;
        b=mawDdgnVgWBDu18yyeFCYj2P5hiYA+a1FshfyNzcvkJ+eJmPlZIk2IxTLKChRuDBjf
         AOqWWWGYdMMNuxB9CIyM62M58nCbkhUfFl6T5Th2y8Fxa2nNVLwlVf9y7xj4j6EWVm2W
         uj00ydIakDEiquTIezJ7YY7+hQ27ELiQaIKJe3WWcjeNPRrLrV//ZqlNd7P5ZT6abzQh
         4onKEeobb91Nofo04gu+S0JNFpytclUKTzpm1caljmAQLt+Xdizl0QWIknpuTC6xVv7/
         l8BWBHz15LisVtrKBo2Q/0PIU9O2Zoud1JQlQ/we+/da/DLWmQp0m7o3f9FeY2GzTHxu
         ncMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778765163; x=1779369963;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DREA9g2Kfe7wmoiXBkymc+fgvMh17jjhzIZtNHnDePI=;
        b=G9IFlJXx1tjEEy+4X7sriMZ5kHoSZHVjevo3xdNWU53qlwJF7bPHusNL5D1+TQnqmy
         Dl87LprWT7od67K1DEKs94tHsfrrjObdoayj5kh1YHx41dOKYgNK+ZdKDx8U2/QUaBEL
         BSsi2zAFSfiAbKsNx2qjR9kEi+3xi95X8b7UPuc4fkAyTlhT29n/RP7MJ+cUNZhvmMWn
         K5ENenRvAomMTqdbunLOp5eRPNwNOhKABl+UKoKejx/pM1g/mdto/3aeh8+b6yv6Jg8K
         uIJpFrXjk9aAuEsWJ3PoJFQxii5ceQBti4UshBI20rcBZE7na7hivR7LN1tnfRVaZ+Ey
         SP4Q==
X-Forwarded-Encrypted: i=1; AFNElJ8p///IbZmiOYqg9fv6CGnpi34aem9sL05H95ttbEVhNOFYwZEy5gII59C0ss9hwHx2GfUeDvPpfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuwm2vDpZC0bxVxjWu6ZKKN9gHhsuxvFOnV1uEJswQtgfsJr13
	EGqQlBy+QTdi0aPGSU8dlWP61h3ppFo+5ENTnovT+P1cjZK0LFpfXNHwZ0pJelLEJSg=
X-Gm-Gg: Acq92OG2scxnxSo7s4o8CjROm4gun40PtOQ8cw7DKWFQm4pSlmfL5i9PY+JJQq+dtZb
	UkJPduXChibM0OJPrfDXNYWAl4lATv3FTloOXBYRBul8+cW/lF22hsQ2vYYgetKt/ldSsDPLI8e
	PWejbXTQ+spFuqNiF4pz6RARdinZvRr2ZQBi6JXARpMfifXf9q9WuPBqor83DLZLpOQbdOLCyov
	Zc/atqdxFRxyoJD24xio7CkPDKS9Wl+ZVtDDiaKnpZ6Nfh1Fe7B6GdTfIwIk+sEV4D0ZfATntlB
	HCe/y5n4ID5My20cpHm0unRQoLL6lnvC0QPJ4Y9L7J1q+/OatZ64rtEUJugpYg+SwjSwSHn03b+
	HUH88LQwiPQXawmuvzy8D2yWUEiUhcMk0SvzEikReZgVV3xpyI7hZZ08oUjkEvLY2I1wAKoRzwC
	ikpMTSpiG6p1FgkT3aQGh245pKEDNBXXSYWqSj6wP8S9kmzYJvoFrIwZOrbygnF4C0TMEHg9WEG
	2EeN5mm
X-Received: by 2002:a05:6870:5a3:b0:439:bae3:50b5 with SMTP id 586e51a60fabf-439ce452ca8mr4395299fac.34.1778765162752;
        Thu, 14 May 2026 06:26:02 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc4d7ff3sm1849169fac.9.2026.05.14.06.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 06:26:02 -0700 (PDT)
Message-ID: <ca0a0f6f-f760-4c6a-813e-93eb187b1b9c@kernel.dk>
Date: Thu, 14 May 2026 07:26:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: validate user-controlled cq.head in
 io_cqe_cache_refill()
To: Zizhi Wo <wozizhi@huaweicloud.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20260514021847.4062782-1-wozizhi@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260514021847.4062782-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A21535424F3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13328-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[huaweicloud.com,gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,huawei.com:email,fedora:email,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/13/26 8:18 PM, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> [BUG]
> A fuzzing run reproduced an unkillable io_uring task stuck at ~100% CPU:
> 
>     [root@fedora io_uring_stress]# ps -ef | grep io_uring
>     root  1240  1  99 13:36 ?  00:01:35 [io_uring_stress] <defunct>
> 
> The task loops inside io_cqring_wait() and never returns to userspace, and
> SIGKILL has no effect.

Thanks - applied with a few edits, see final result here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/commit/?h=io_uring-7.1&id=f44d38a31f1802b7222adaea9ee69f9d280f698a

The comments (and commit message) read very LLM'ish, so dialed that back
a bit. And there's no reason to put io_cqring_queued() in a header file
when it's only used in io_uring.c. And finally, the 'queued' variable is
now useless, so kill that too.

-- 
Jens Axboe

