Return-Path: <io-uring+bounces-5964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D291DA14BDC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 10:12:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FA601887C35
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 09:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817C11F8AD6;
	Fri, 17 Jan 2025 09:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="Ya+ZVQBY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BS4GCkf3"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9318A1F790B;
	Fri, 17 Jan 2025 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737105163; cv=none; b=IE+iu5uZxj1ZMAZ48dW7PrV5B6IdGkEBkcVsWO30EPB3zfxDLF28P43cPQjpM21vYPRqDO/YIhXyXud6Xd1zwoZCkABOj9mdmQap73qeD/UMu2nAfTZuvCdrh5kLvrM5KFjy4nYJG77VEjM0XSykUogg9nhc22HqRS/UG004EYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737105163; c=relaxed/simple;
	bh=YSI/TNIVJK/bhs/7Wtwsk4NeOwatTUT7X3bYHfX64j8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FN69TwuD5M7l6kNUAeKOzW+t/jYdjT0tsjv+YoJ4CJSrkcjrZFO0N3yJjTwYW5FIylkCfr3wQPBh11OOJecO0p7U8qZ9fvN6HycIOtfWdyM0rjkGLLxGACYgyouSlaPrkywTdw3vfT3HWkzwYSsbMe7up4DHN2qdIfa+qMVJNbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=Ya+ZVQBY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BS4GCkf3; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 664A713801E7;
	Fri, 17 Jan 2025 04:12:39 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 17 Jan 2025 04:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737105159;
	 x=1737191559; bh=HHPK2XxCcGaC6vn4FPLZzyhcNtuPp7llqs7Fxc1PV/o=; b=
	Ya+ZVQBYLQCQX99RuEZ7yCrp/WX8hhfrw95zHZzvVR15jpO3OoRebX6IilUU2pZW
	Gf9TZiwb+GdVeHmuh4pi2tM0r1s/NCLNOWkv3D1+xa9lYL49lFyujJosRFQuD7CI
	2Cu+39bdTVgGM8Rac3Wty4XNuBWMQ0mLw2K0ea3FZbXHUXEjHyLMUwn9CsoVd2PH
	WpAV1HAIN/wSe/oFTIl+W5VI+x0bqgXYoaVhn9km1JfIJHDG6WWHQ9xdOaJklbFu
	pJ3ctHKaUKg/3mMGPFekUFRu4tolra88Wreg92d9vUz8Kz+WLNLDIBtSJNsSdqhc
	SBbsJyClRqFbJO/KqOLhdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1737105159; x=
	1737191559; bh=HHPK2XxCcGaC6vn4FPLZzyhcNtuPp7llqs7Fxc1PV/o=; b=B
	S4GCkf3RW6BOUgqK/MftfHqY6R3UOPE0EX79EQb1PW2wZ87bPljiRFCD30d10Y3d
	nG0QgeLDxKSieICKxljGwd6qKmAob5tAAg3DpEbQFYtY0wMFMRFlGyNqaj/zp0Fe
	naY8gWC4pZ6b4wWTv/WbTDUeC2NOXaUr8LCIFt5V4U7zH0PjoSjfKCHKRf2H4RgL
	InRkuJTKEb/gSdA2SHKC8lnlpnyqZ5ouFjL2A2XVG4yvX5yM17fb2eFuhcNCTfpW
	Zt0j9l6/cVYzn62jUdmKEU2fSn+/XMgUAaEYhMBLdRr/2nu1f3VUgF0VWq8asyJ8
	CVdMyO/sEoVg2bJbNormg==
X-ME-Sender: <xms:Bh-KZ_ESss6eT3_MKUn921LMRDfEmYkspy8TXUasr_1F10gt7n-ylg>
    <xme:Bh-KZ8Wy-Lp2Ripe0sGUjr_KavwaKqP1K49HbQQ8-Wdu5k1fQgvcgOZkSIa4Al_oV
    NhwE6TcWPl9O-Zi>
X-ME-Received: <xmr:Bh-KZxJ0fafXOc7uEpxx0Oz17dwAKGqxS8Q_Ow4f5LvHYrt7aogy_YAFRcWpLKwgcCt0lIX5r7gLZDazEb5sJvxKzZOdv8ve4QC9fDSf3oIA_B4uXhuN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeifecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffrtefo
    kffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsuc
    dlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfh
    rhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtg
    homheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleffuedujefh
    heegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghrtghpthht
    ohepuddupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmihhklhhoshesshiivg
    hrvgguihdrhhhupdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgt
    phhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsih
    hlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgv
    lhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghes
    ghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtg
    homhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:Bh-KZ9EDLuhKjMuYxRZUfjVE2M1YNS9pvNS_1eTA54ugyQO5Ija0uQ>
    <xmx:Bh-KZ1Uq9TFXgyG5X5kWsQLcJzNMn252HJf9vemKUI4JLFAE1s2BTA>
    <xmx:Bh-KZ4MArsZVOTbD6yQjy9RpUWLdlPIeKvWc0MlM8Yni5L4Q6k9Wgw>
    <xmx:Bh-KZ0177XEY0W9Ov53Q3KOs--qQv6q_u9FX4DsDix_grSFrVcj2XQ>
    <xmx:Bx-KZwM6IWj9T3txKslZUHWkdNvibPQn2fQJs21aYYHBUPq21ses-OfZ>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jan 2025 04:12:37 -0500 (EST)
Message-ID: <3135725b-fe31-42bd-bb9b-d554ebb41494@bsbernd.com>
Date: Fri, 17 Jan 2025 10:12:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring
To: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <CAJfpegvUamsi+UzQJm-iUUuHZFRBxDZpR0fiBGuv9QEkkFEnYQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegvUamsi+UzQJm-iUUuHZFRBxDZpR0fiBGuv9QEkkFEnYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/17/25 10:07, Miklos Szeredi wrote:
> On Tue, 7 Jan 2025 at 01:25, Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> This adds support for io-uring communication between kernel and
>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>> approach was taken from ublk.
> 
> I think this is in a good shape.   Let's pull v10 into
> fuse.git#for-next and maybe we can have go at v6.14.
> 
> Any objections?

Sounds great, I will have v10 in the next hours (got distracted all
week), there is a start up race fix I found in our branch with page
pinning (which slows down start up).


Thanks,
Bernd

