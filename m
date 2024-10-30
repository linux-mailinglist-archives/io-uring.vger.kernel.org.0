Return-Path: <io-uring+bounces-4248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1AF9B6E9B
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 22:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F0D21C21857
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609D31EB9FD;
	Wed, 30 Oct 2024 21:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zox8MNWg"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF931BD9D3;
	Wed, 30 Oct 2024 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730322955; cv=none; b=mtG+0V0MUZnByMkm5r5VV8c5Z1njwrJkpUxGrjaysym7VookjXNpeWk6lh2NPparik32zx35nrkXqnStxA68RlLX3Grc68wGzX9ljXo+43RwWhdBB0dHTTYSyVhoSHoWa3qxgk8Kktye/nVMGRuxGKfJJVWQRJzCpgHqttOZL38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730322955; c=relaxed/simple;
	bh=b4DMBOXHUsK1o4aXcsj1mIAeGTxICrtIEl/X4S9aMmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHDrbOg1zgxwklBlhjKOOpWYXUdW53D94rbLrqLLqYzNc4crSgTdDrYc5JdGqNB4qZyq3CKpzvSkJzZYfEJd1byRhRrEhWo/e51Utvql2lAkMb9HmivOaeWKTJS/evZG590idyT+e1xV15JPuLAEHa+J27XphONGUppgeUu2xbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zox8MNWg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xf0KN5GvpzlgMW3;
	Wed, 30 Oct 2024 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730322949; x=1732914950; bh=b4DMBOXHUsK1o4aXcsj1mIAe
	GTxICrtIEl/X4S9aMmM=; b=zox8MNWgMID5qKcjZdijr0DcLrVbE5phS46vpu24
	wrFxrcFoUCjZa2CDHmNRcfuOEvopYpTxUde44SD4j7i5fjKckz2WLPCYhxf96jYt
	uEs30sP8COFtc0ARm32FHRAGZeHmslxs5iW3+2aJs8fTPL+mwdS5ROGgpDsgkYyd
	flVIYEV1A1/kLmVGL2GYC/9Ur4dqBcVHn3gxyPdUjiuWDdGFwRC48zT8oShGWppD
	F7f2l73E52JY4WcXgOKj5lpGAOglQ4k/2+r8uABoqeE8J4/GNyUQvcDI1a2UXZOh
	iQnyofz45pN9aPpmgSsxjLqATqaSJ0eCNuHT6JgMPgawEQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Khb2TIHA1NgX; Wed, 30 Oct 2024 21:15:49 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:dff5:f005:4483:ce42] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xf0KH031BzlgMVx;
	Wed, 30 Oct 2024 21:15:46 +0000 (UTC)
Message-ID: <4ee729b7-a3c5-493c-bcda-feb3e9aab5ff@acm.org>
Date: Wed, 30 Oct 2024 14:15:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, javier.gonz@samsung.com
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-5-kbusch@meta.com>
 <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
 <20241030044658.GA32344@lst.de>
 <ZyKTACiLUsCEcJ-R@kbusch-mbp.dhcp.thefacebook.com>
 <7f63ba9b-856b-4ca5-b864-de1b8f87d658@acm.org>
 <ZyKY_xdxcM2aSMow@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZyKY_xdxcM2aSMow@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 1:37 PM, Keith Busch wrote:
> But if by "not atomic", if you're just saying we need a barrier on the
> bitmap_copy, like smp_mb__after_atomic(), then yeah, I see that's
> probably appropriate here.

smp_mb__after_atomic() follows atomic operations. bitmap_copy() does not
use any kind of atomic operation.

I'm wondering whether introducing a variant of bitmap_copy() that uses
WRITE_ONCE() or smp_store_release() would be appropriate.

Thanks,

Bart.



