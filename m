Return-Path: <io-uring+bounces-6094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 649CEA1A67B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 16:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C9673AC9F9
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F238E2116F7;
	Thu, 23 Jan 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="NOh/rMb+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SdZD/A8R"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208C2116F0;
	Thu, 23 Jan 2025 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644581; cv=none; b=AQgl2p51GEZmHYsXEX8LM+heBEKXTvEatFmrEOvm8nbgkIlrYPugzSEumbroD9WD0H/0rlHtOWNVCGJfXJrnA5w/7m42yS1vPPLHNAW3exVk4HrasDTfAXwujrTs1Kf0Oa8/QzMhpPDNst4BxL1/q/L2SKAQAaQ0hp+7+Q36F0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644581; c=relaxed/simple;
	bh=Z/EDfFbRlgpMx2NCz15vpaBTpxPumg3vUGBy2K8L10g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QqBllrt4B9ZHfJcLU58stttHDTyTHJbTt1RGxfRzOPx9rWxeZaQNcCw9v2clvg6qbDlF0LTsu1+YYnw1aHbpQ330B3w5LlAAP84uRLLuIa/zeu6uRGmq/NwJ5/c14zxcO/6ZZfZ42wX55Z8xKLNePVQN0aZ9jw32AyKWRBMmMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=NOh/rMb+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SdZD/A8R; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 78E021140096;
	Thu, 23 Jan 2025 10:02:58 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 23 Jan 2025 10:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737644578;
	 x=1737730978; bh=o/d6b6eVW/XFDokEz+VR83w1zd0LrcwPR/6asWacYqI=; b=
	NOh/rMb+BW/RS0/y4D6OteMOqc7PLxK2rensXEnV9sEevYB6Egii52x7Is4aywQF
	/f1FeG+6rDs3hpm9+2lMJUOf/D84xg9J7TM1y+xi33/rS0d7LWTfCXmr8l80MupZ
	dES+xUpAbTIxZflP+6NWd5Lr4DCzzFOQIc+4QCuRNZvCCOzXWrkXG0XYMdJAR9I6
	C6TZN1k/AUAvuXT6KoDtYL9ArV48dIUtcepZ0TTiAdWzcohnWBuKm1X8XLF71MpQ
	jy00FA0tjjYs9pmkmszaFS6lL20sPi5BABNnDtx2s/FQ71mCkwKJcS/r8jd7i7pS
	CcJ9p4k95D+MhkqBwzjb5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737644578; x=
	1737730978; bh=o/d6b6eVW/XFDokEz+VR83w1zd0LrcwPR/6asWacYqI=; b=S
	dZD/A8RXi04SjkLB4II94aUujNvV1BCWSCu+7VGWBbWyIHcOMrOc6zUACXFcIaYC
	zC8ZciU3UBiMhcn/d3af8b2t5TkK2KsXDQUWoGJDiiMd2TFjSBpcnofN3aKPERYN
	qJnfClyNI8iBfSJF3gzLFinHnl01qkLPE9NczdxGfDniXVx4+Axe/MGVaw0IBCpH
	T5PnPXH5oAQoGBGeZpkQi7PNeHCoWCrMFBMX2wbnF1XcWIfclt8IoetVZhkqvKe4
	qco9ABsZISZN8zP89Dy8u+9+K5Co2ANfBN6IRS5wpI2bYdwlIDbQYRcu0KfSa6VI
	WVVqtKgC/2Wyxv1yIfQDg==
X-ME-Sender: <xms:IlqSZ2Ku_XYc-5AxMzz2UXeWH-ecPMS8kVzfLzrWk9GxXM79VW9UVg>
    <xme:IlqSZ-Jn_Zorm1F_ri54pxosMRFlfvfZwLm_DWOAg4DFOuxHGQK3DOTXX6vkFYigN
    bNWoMRuts_DNuVB>
X-ME-Received: <xmr:IlqSZ2uf8mCAEgXRYRvfapOYk8ZOwFoiNsMOXl4uyJb82YJaO4OVH26WwR_OMp8K8An0CjZzc3wC2Buhilq80Mms15LWS5vmDOXTKvK-hjmec3SvIKWo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejgedgudeljecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepudegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmihhklhhosh
    esshiivghrvgguihdrhhhupdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtgho
    mhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmh
    hlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrih
    hnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhho
    ohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnh
    gurgdrtghomhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:IlqSZ7ZuD0jSwvcNOwKy1hGSSBFu9f13wsv1zCqZNHm75VIHqHujbA>
    <xmx:IlqSZ9ZrFaziaYDHDTfTz2msqIQfx7QWSKlrVOTdwyl0_wLK4llg1w>
    <xmx:IlqSZ3DKLwLil4gRO3d6RbN5KGQtfd1OMf3dKI6m9jGbAbHNomOcYA>
    <xmx:IlqSZzZjFxDas4pDWnHUm3Rf1y8npQl0naKJ30SfeAaLo_vVa3sXvg>
    <xmx:IlqSZzwZsX8_9HqRipXb8AGK_XcWvRLsvRMBw3L5g2Kf2NyRXJisjyNc>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jan 2025 10:02:56 -0500 (EST)
Message-ID: <73edbb01-fb11-4230-b8aa-a2d81f4a836c@bsbernd.com>
Date: Thu, 23 Jan 2025 16:02:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/18] fuse: fuse-over-io-uring
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Bernd Schubert <bschubert@ddn.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>,
 Miklos Szeredi <mszeredi@redhat.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
 <9516f61a-1335-4e2b-a6e7-140a0c5c123d@bsbernd.com>
 <CAJfpegu0Pyxo3qLHNA=++RHTspTN-8HHDPNBT0opL0URue3WEQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegu0Pyxo3qLHNA=++RHTspTN-8HHDPNBT0opL0URue3WEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/23/25 15:59, Miklos Szeredi wrote:
> On Thu, 23 Jan 2025 at 15:53, Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> Hi Miklos,
>>
>> or shall I send you a fix-patch instead of resending the entire series?
> 
> Yeah, you should send incremental fixes.  Much less bandwidth that way
> making review easier, and I can still fold it into the original series
> if it makes sense.

Ok, will do, I just tried to make your life easier, so that you could
just apply the patches. Fortunately just small changes (just in a
meeting, will send immediately after).

Thanks,
Bernd

