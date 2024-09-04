Return-Path: <io-uring+bounces-3036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2B696C7A6
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 21:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE3FB1C22A5A
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 19:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E1113C3C2;
	Wed,  4 Sep 2024 19:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="CP/L8Eso";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sxNmrbra"
X-Original-To: io-uring@vger.kernel.org
Received: from fout8-smtp.messagingengine.com (fout8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3384A27;
	Wed,  4 Sep 2024 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478629; cv=none; b=HME9+N11WnafohKOKOFXhHcW8p+BPXsvZpR+BCIpA71iolCsOYeodnPs4hqReQOUmlBxgyHD+O6LvD85n1+uk0oSDqFGj5z/VjotqF4oILq5GWCpXmpVnH2XldYuT/kmrj/oPwvukr3BzZiOe61yaYtdTOMNxPNAm5UEwlZ6rn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478629; c=relaxed/simple;
	bh=WXLBYws3lOOhhmemXY9s0yF1S/8d/7OC6/5xIPaUf8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EbhRVHprm/CYFQ//TsJ2lgMK1EMzu4k87CjNIcpTh97aUncnWa75UOmeX7jPY7yc2FEbt6gOG2+io61t6hDlbhKqQvjZcS/K/DU/+DsWTufAaLnG6flO+4bLOUulNViTwHkqETgkKH6RRlj9amty6V9Mo7K5VtTqg1/X98CtUqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=CP/L8Eso; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sxNmrbra; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 095E21380140;
	Wed,  4 Sep 2024 15:37:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 04 Sep 2024 15:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725478627;
	 x=1725565027; bh=lRQ0gFMcstNID5luvvk1fu5bLIw733PRkFBZc2IEINE=; b=
	CP/L8EsoUBZsJntz4Owkd0mNHU0IgZsWoNG1oPTmjJcCtwtiedK67y3Ss9/+bKYv
	DyWhZly8mN+LJ6K76xjDKh5KRRLHf1jrUCJftTwlq7aZ+ypb4ELfdGvjELGOR1L5
	Pkk4t+TR2AsaXtwDxUloqv3pkHf2bA+LZgAhIdtcPUDXWH08zCMtgt7McP0dTDD0
	urca9l8q3TxY8+zcTrrJvJV9lAzQwCvAL7IdBi6yfp5qHFWXDyRUKDmNUkqj6cZq
	XR8DVdmyi3egl61FfloFVqniU5cUZBs9lT4uz0UBDf76IZb6lQvUKVIKSzFrwrgp
	JHUPZhn3UIwxkt6fZSHZxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725478627; x=
	1725565027; bh=lRQ0gFMcstNID5luvvk1fu5bLIw733PRkFBZc2IEINE=; b=s
	xNmrbra4uADkU2fd/DV9oTQ5Mo52fdhpl7n1ih5LRUB1nX0P9tsIxHRhoZaK2Ecb
	uyXsjnmNuAr6iQnJgbDc6jNnnGRTNthvqa8V+6LtXh/rE4KHNW4tHLWXXGny6zqH
	MpolddZhmg0p4RLEm6Oo3TN5b7dtjW26S5ZReYz8S30vMd3IzQb0ltPuJpn4kaDQ
	qohEc4PMixdm/HR0w5jnClXScUM5iCxs1UhgZsEnMBJWfIk+EYKcrhW07Tk4l8Bf
	5fT5x4bV4Uwo2oCyCiSGxPFCk1wEJ+2Zo2tPtvf/3WyoNakqipfg2RvT7gq2eMxe
	AybfHkZqyn6WahRZrxcpA==
X-ME-Sender: <xms:4rbYZlyZeRanYoSIGMUX8e5MqDi99lqHsymhj1Bg-bJUB6o81GC6VA>
    <xme:4rbYZlQQVUKTU59LD5xwkYvQ_KA3ApaaN7LBpKDQvwuviB9x4mevI9MS4Z1khn2eF
    lLqe8-K3IAZdqcq>
X-ME-Received: <xmr:4rbYZvXDs4cnMOmeXYsWNfMSLnP951g_TYg-yPQlHqgXPyTxBFVhaJt_uAZDJ58kEn9iBqyyo4K0aKPIvuoNfIoZsU9f6q0XtpOw3TyYJrAR6UCM2SYL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehjedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusg
    gvrhhtsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeffjeevfeefjefg
    hfefhfeiueffffetledtgffhhfdttdefueevledvleetfeevtdenucffohhmrghinhepkh
    gvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdrfhhmpdhnsg
    gprhgtphhtthhopedutddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgigsgho
    vgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegsshgthhhusggvrhhtseguughnrdgtoh
    hmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopegr
    shhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopegsvghrnhguse
    hfrghsthhmrghilhdrfhhmpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghi
    lhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:4rbYZnj5V6rZ1JQTwFWH3qKYz4LRsmOzpLKpFRjQ6sU2iEqICSpRsw>
    <xmx:4rbYZnDMetjmaiysf7JsSp_ikHJzIme7Vn_6MVVWM6Y1t76AxntE9w>
    <xmx:4rbYZgJIHJjGz_YFCg6vEc08JjYeL9PdQLqE96q2r7qqYe3oXtpD1g>
    <xmx:4rbYZmAGMr3HxzWXxPBxPBn5KcU3zlh8secuX0DBswkLvbZrE9WuNQ>
    <xmx:47bYZr5a7R9jchVOAnsCtvBE5oS-BuheVt6k7DjKRCX7eWhw25A_Oopk>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Sep 2024 15:37:05 -0400 (EDT)
Message-ID: <93127b12-77ae-4e25-bb48-8c8596c7702f@fastmail.fm>
Date: Wed, 4 Sep 2024 21:37:04 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 00/17] fuse: fuse-over-io-uring
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bschubert@ddn.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Pavel Begunkov <asml.silence@gmail.com>,
 bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <e51abb75-b3f9-4e91-91dc-81931ceacad6@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <e51abb75-b3f9-4e91-91dc-81931ceacad6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/24 18:42, Jens Axboe wrote:
> Overall I think this looks pretty reasonable from an io_uring point of
> view. Some minor comments in the replies that would need to get
> resolved, and we'll need to get Ming's buffer work done to reap the dio
> benefits.
> 
> I ran a quick benchmark here, doing 4k buffered random reads from a big
> file. I see about 25% improvement for that case, and notably at half the
> CPU usage.

That is a bit low for my needs, but you will definitely need to wake up on 
the same core - not applied in this patch version. I also need to re-test
 with current kernel versions, but I think even that is not perfect. 

We had a rather long discussion here
https://lore.kernel.org/lkml/d9151806-c63a-c1da-12ad-c9c1c7039785@amd.com/T/#r58884ee2c68f9ac5fdb89c4e3a968007ff08468e
and there is a seesaw hack, which makes it work perfectly. 
Then got persistently distracted with other work - so far I didn't track down yet why 
__wake_up_on_current_cpu didn't work. Back that time it was also only still
patch and not in linux yet. I need to retest and possible figure out where
the task switch happens.


Also, if you are testing with with buffered writes, 
v2 series had more optimization, like a core+1 hack for async IO.
I think in order to get it landed and to agree on the approach with
Miklos it is better to first remove all these optimizations and then
fix it later... Though for performance testing it is not optimal.


Thanks,
Bernd

