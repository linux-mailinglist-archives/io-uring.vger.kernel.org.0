Return-Path: <io-uring+bounces-4133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F06CE9B5046
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:21:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB423284EA2
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DD51DAC8E;
	Tue, 29 Oct 2024 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mr8om1zC"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA4319DF95;
	Tue, 29 Oct 2024 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222506; cv=none; b=p6SL8kkfNQ2fq59DMGGPt9U82KNGoZz8TMh7iwDblCmbOgOQQNpH9ACrzAbQW27LoUN+C0os245rc1vAN02LW0ywLJyinY7hQKS7ZX/Jey42lh2qxMScC82BJzoOH9FcLZY7NuEYFiGkl6MKvffedr3fJDLGNi0/LIs4v8EiEFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222506; c=relaxed/simple;
	bh=kWxA2MoqlYM7QZbbvu93a6SsGPq/fk680PMkDpoUNZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hx8ybtTSa2Zrzh7Ctfres/q4z6kZJK3Hds8O/su+AVubQwVcxlzII5mIp8tU4npZYC26imyXxymFMza1f8tJ2N7zeD2ICAcARQQzYeMbYxFiF4xz5htYIAEZaDT2d/6cUqUi29izDbiX9uUMC2PWC7Hb9dfd1FplN0wwdrD1UGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mr8om1zC; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XdH9h4kpqzlgMVd;
	Tue, 29 Oct 2024 17:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730222502; x=1732814503; bh=kWxA2MoqlYM7QZbbvu93a6Ss
	GPq/fk680PMkDpoUNZk=; b=Mr8om1zCYZlXfFJPZLFZ5EPYfgfjGUA2eC9iCLsQ
	/V7XgRPhQEyix0foLSFomx85RWH/3vOoU7W54KqWeLerOC2IZL2+KIHV4Mecty99
	8JRZIgNngzLcEIXc5ViZZHHfBS53Efsb8/Ffj5yr6sOPvV++hTKA+K8WcUwMwcWp
	ZVflG1VMAaNGkU8QZLm3sk4wtmg+khMsXY6k11FKYUZ7ZcgDhRd0sDMmQPWznD3F
	TYmby0JwZ5KXtP4+UMhhlFFsKeKBCujcr3c747l3lt0mn1goj0Lata0GZe5UjmyL
	7f6+dbO52tPRhFN4fNevdgH5puplxRaN+Yc8TUeXWNOfxQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lALfxPIoeMd6; Tue, 29 Oct 2024 17:21:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XdH9b4nprzlgMVY;
	Tue, 29 Oct 2024 17:21:38 +0000 (UTC)
Message-ID: <88b530fc-e5ca-487c-9af5-75f225d321de@acm.org>
Date: Tue, 29 Oct 2024 10:21:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 1/9] block: use generic u16 for write hints
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-2-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241029151922.459139-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 8:19 AM, Keith Busch wrote:
> This is still backwards compatible with lifetime hints. It just doesn't
> constrain the hints to that definition. Using this type doesn't change
> the size of either bio or request.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


