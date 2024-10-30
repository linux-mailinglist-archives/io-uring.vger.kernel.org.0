Return-Path: <io-uring+bounces-4241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 401639B6DA2
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 720D71C21AAC
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 20:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D2B19CC24;
	Wed, 30 Oct 2024 20:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IBlnjePq"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFD1BD9D4;
	Wed, 30 Oct 2024 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730320015; cv=none; b=Nvgj6LwwqYioZgPvTJA/jLL+T4efOkqw20dvt9nMgBFehUW/r12/yiXfnE74UdzG6o+IwgL+aSKiiWHxtGHnrUiP9N8Ow5StvkxiHcy3MGk84Yi4fohXjSEkq1puti5rF3JMgO5NVAD5uFDY0TRJNgnJeJEe9rM4q3EQ/H80HCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730320015; c=relaxed/simple;
	bh=A2hPNyQ3TJFCTbGZfB80k/GB7WNEspn0Ro/REZtShPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSaMXjBx9K4vBpo0NAWI1fAQAITYeialVzDZA4pB3EfTS3JwLcUGBI7X1cObTMacqS/FlkVIlRHExF6kxGh50zYsQI3++wHAV3OHuTC+eKQrzHYZQbuHldHIbFDIw7x59a/HUSen2Sn4WPsFO6nC60gSGEeyAffgv0B2lqOkHGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IBlnjePq; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XdzDk1cVczlgMW3;
	Wed, 30 Oct 2024 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730320002; x=1732912003; bh=ZwX5HQBRdls9HGl562/3LWDH
	exYSLiXyMo3oYf3ZMSM=; b=IBlnjePqqXFRQURyxJU9Of+9zoHkLQBQCOhKK3al
	ygFLunnXoIaFdI566iOuvPbuLf+Z+ihJ7CqaifLU90rnkRlJ9PsllTu7s2ZuhizC
	XuJeKEXLhOSBbjodsRQvM4tpRmK9FRiPwglQvSYABX4wRXjv2Zt7Y+VRH9XJGWrE
	1/iAvd59vbi/aCeHPu5II+WWalxby3oRSJX9uku+VxA+hsI10nUOeWe26FmxOtKQ
	93jwQzRvWvcFwxxZSARePy90PPaAJBhrXXYtkfhFwUW+hTfiU+pwtdTaQFaNjeUv
	WeJcnOEG28u+TYcrIFQMnRx57zenYleIY0ytrXtW+03Ahg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0JqpT7IAAI3o; Wed, 30 Oct 2024 20:26:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XdzDb6wflzlgMVw;
	Wed, 30 Oct 2024 20:26:39 +0000 (UTC)
Message-ID: <7f63ba9b-856b-4ca5-b864-de1b8f87d658@acm.org>
Date: Wed, 30 Oct 2024 13:26:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 joshi.k@samsung.com, javier.gonz@samsung.com
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-5-kbusch@meta.com>
 <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
 <20241030044658.GA32344@lst.de>
 <ZyKTACiLUsCEcJ-R@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZyKTACiLUsCEcJ-R@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 1:11 PM, Keith Busch wrote:
> On Wed, Oct 30, 2024 at 05:46:58AM +0100, Christoph Hellwig wrote:
>> On Tue, Oct 29, 2024 at 10:25:11AM -0700, Bart Van Assche wrote:
>>>> +}
>>>
>>> bitmap_copy() is not atomic. Shouldn't the bitmap_copy() call be
>>> serialized against the code that tests bits in bdev->write_hint_mask?
>>
>> It needs something.  I actually pointed that out last round, but forgot
>> about it again this time :)
> 
> I disagree. Whether we serialize it or not, writes in flight will either
> think it can write or it won't. There's no point adding any overhead to
> the IO path for this as you can't stop ending up with inflight writes
> using the tag you're trying to turn off.

Shouldn't the request queue be frozen while this write_hint_mask bitmap
is modified, just like the request queue is frozen while queue limits
are updated? This change wouldn't add any additional overhead to the I/O
path.

Thanks,

Bart.

