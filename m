Return-Path: <io-uring+bounces-3816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEC79A435E
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B900EB22093
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3C520262C;
	Fri, 18 Oct 2024 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2uVJSzJk"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293F133987;
	Fri, 18 Oct 2024 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729267893; cv=none; b=VaQdiA6uXnNT3W4sn0GKo5gs3werbXLJhEfACN1kK0PIxP/zhJQfCT6qqA1gjRVQanlw8I2gx8qHZgzhKul47QJpDPC93I0111/RQURCPaws7be3vi/RdAwXXWjI5KALU5EgaAfzzGQeJRqHyWOd69R+YI8H7AHWmnBrk03lH4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729267893; c=relaxed/simple;
	bh=sFOSvS9yUPDz43ddDEY+XeZrFdWX+17k7HigJqpHdio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EkvfvXqIYVgrcRJcVyth/QW2niqOghsaCgbdeDJy1tQOhX6uimM7hfdvUEDe+t7uL+pWLWY4ajK7tPU9stiOC0zc/GAIJJLGRTkQE3GJu+MjBSK4rSq+NXnaioaR0w6K5WyQfKWmC1FKxafHoAcbgUekaFUbYIhLKSkocaeTttw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2uVJSzJk; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XVV7l3Vzbz6ClSpy;
	Fri, 18 Oct 2024 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729267883; x=1731859884; bh=kEmzdJ/Pc8ND50WdJniLJozP
	O03McgYyB0Bd/e0lB0g=; b=2uVJSzJkdlwNEqOpx9tmSMH+CPOezCQCNAoiyIPi
	1U4b3IoNqFGi9NwxX+k2z24xxT4cUiEG98zI4htS4Wu59EwlBVDHr2xKdM3bf1eR
	4EF2hGtuxBvFEXOWIbpGA1nZ/FolbIciC/JWngD0YyH9NqbhVYuvTQo+XYB/wO+Y
	07AMTmLBf/cw/tm06LPqfLBPiRa0rFJiAZHzcJLT3FeC7T3Gm7c+RJVPHO1vU56h
	XW2PuHZEypIQPAVHM3M8NGfZ1h+llopdNalmX5Xs9jrRbDTMH4Qw1BJGB+mUJ77t
	2mC06KRXxRlU1asJtRWoNw7Bjp6PGROMWkF5yir2fg/7+Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dCHz-rmM4GJs; Fri, 18 Oct 2024 16:11:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XVV7S1wb9z6ClSqP;
	Fri, 18 Oct 2024 16:11:13 +0000 (UTC)
Message-ID: <09e672a2-4421-4637-bfdc-e1c46af4d0ad@acm.org>
Date: Fri, 18 Oct 2024 09:11:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
 Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-2-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241017160937.2283225-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 9:09 AM, Keith Busch wrote:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3559446279c15..04e875a37f604 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -370,6 +370,7 @@ struct kiocb {
>   	void			*private;
>   	int			ki_flags;
>   	u16			ki_ioprio; /* See linux/ioprio.h */
> +	u16			ki_write_hint;
>   	union {
>   		/*
>   		 * Only used for async buffered reads, where it denotes the

Why 'u16'? Shouldn't this patch use the type 'enum rw_hint' for 
ki_write_hint and shouldn't this type be changed into u16 in a later patch?

Thanks,

Bart.


