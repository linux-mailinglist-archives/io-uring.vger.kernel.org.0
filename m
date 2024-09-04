Return-Path: <io-uring+bounces-3030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AEB96C321
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 17:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E22FAB27398
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 15:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D981DB93D;
	Wed,  4 Sep 2024 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="WCGJ8T/w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="s6T+q1E9"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4193B1DA31D;
	Wed,  4 Sep 2024 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465269; cv=none; b=tXMS5WmgjrCQQRcJgi1/wdz2Hv6GLobJWsMucRTdpyGUS37QMx6/Sq+cmkpqKfRX87hAK5dnXSWMaVu/euvfGJNgHVLznNDlSIUqW7Kr3YebHkAQb69W4ZhEf50H3MLRtYLT+e7kl5vxBusdQkgbRwaHKsTtL41Qme32WgdErOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465269; c=relaxed/simple;
	bh=uTeGjUV2eqp4zafhgMnOh63k6Ei/UhxukuoPHIVUx/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TpRnbe9i7sr1oR2NFsEBn+nnwmP94TPxqrpWCA6rZBcBh2T7T5vS5nk2ECHfMZKqewd10mcPRzmGDTU2hpgYbr2rCVYoY5dW6bTNkGl2AN7LSLVmOSH+CjSAOpLk0UwyLOsD2U5hvqxaHDJb/eLZ4Z/5xKW4J1FZJQE+G3Q9HJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=WCGJ8T/w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=s6T+q1E9; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 654481140223;
	Wed,  4 Sep 2024 11:54:26 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 04 Sep 2024 11:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725465266;
	 x=1725551666; bh=XQZd8hqtMO4nrcJiZAww1aEmw/qaiSDxx08kJ6nfGpc=; b=
	WCGJ8T/wF0ZAcTfiiWmYJaD3Dh8Q/6Cc7B/U7gLX7NNL5Pqc1F6f90t1t1Qrinxe
	jYjK7ooj0dmVXp2oTWiWSvdHwRXD/hl49jtci0Yh0zxVsBMrk+dIs/qoTGQ76pdv
	IocjIvRC1t/ToWXUiD2RCojzgnk4BnKt3zNbLT+YE9Oy8WwerzjaZm6CAERV0DmG
	EPp+WacwoenlZV5wOUv/49vwTdyzeT/3Gan9sHD4rLCrQwsQW0ePgsVHeuZwfguy
	NlyoylnkqT72I/0GAIYasQ+mrV9OQtcQCZo8sdv0RQqLGDO6USKET6/eAL4zlTcR
	PI3jVdAQEJXDnGR/Q4mjEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725465266; x=
	1725551666; bh=XQZd8hqtMO4nrcJiZAww1aEmw/qaiSDxx08kJ6nfGpc=; b=s
	6T+q1E9ANAUmIsJZJ2WARvwEnTgxzY21UTEMML6BD6xicjAWkfOgVKToZOcLHeC1
	kttZcyhGHPnuiSQJhQIPA87KMSFOAJAPaIoPLdIhla/JktQyOFZmftFmSqIiiP0Z
	7JNmN/d34ZD3qeoFsFmN4LfMnnSGCx/1bkZgs/LtlUyEpfXAZslkLFel3yvM8FCa
	rVpZS15O56DwuoyRYNoXYdR+YTiDIUXGf99lFMro4llvSRis3F4kjveFwo+6bEDY
	CW2MRpN4lGGYLis6GG36tortG+Fq6aleTHs4VaOf79vdICsEuVtLgpRINk2w3Jgv
	C/5nvUZF+AxH1gU4wGV3g==
X-ME-Sender: <xms:soLYZmEJUdFW4JzHV2Zp3DFniGjuVNhSxQgsQyfWHsIQt90jhP-Ocw>
    <xme:soLYZnVAUPlb98gkRY2h50dfgFhYBfpmqby-3ItyDYOY-sAz5bCfsTTZ_HDNlW2M-
    j1K_wUOqfweBR6t>
X-ME-Received: <xmr:soLYZgLoUBp2234DPlVKirQlymGtLj2PAkGM3z8te2uzMWX5E9_g_KyR7SsHi4kbGERKRdLi1zWt6P5qPJzTYQ4qZm9h7txvG2xPWLv1UNaTt631wRoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehjedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegs
    shgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrh
    gvughirdhhuhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtgho
    mhdprhgtphhtthhopegsvghrnhgusehfrghsthhmrghilhdrfhhmpdhrtghpthhtoheplh
    hinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjoh
    grnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfseht
    ohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:soLYZgEBoMdlPocBRJA5E22ztgQcN7FA84PHngq7XcDbmFo_FIdW2g>
    <xmx:soLYZsUXN8cNX_I-gd6L0-OgEWEnjeiNs4Z8cw-1l5BHlVZ2Edcj3A>
    <xmx:soLYZjO5UpIRpfdHeFWZDdLqwNaU5gOULcixCSB9LxTMGEvk5onZtg>
    <xmx:soLYZj0-PgfLldXGoRqsHzql7MiTAF8W17Ydlq4Xc3VQVErqDAIrLw>
    <xmx:soLYZlMl1zjYMLIEysL_vh9acmvNwbMrvwVVPfVQ41-fAeyd2SOA_Sn6>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Sep 2024 11:54:24 -0400 (EDT)
Message-ID: <b12cb939-6ab5-46e0-b791-74cfb80802b5@fastmail.fm>
Date: Wed, 4 Sep 2024 17:54:23 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 15/17] ate: 2024-08-30 15:43:32 +0100
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bschubert@ddn.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Pavel Begunkov <asml.silence@gmail.com>,
 bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-15-9207f7391444@ddn.com>
 <58ace88b-2046-41cd-891f-88a331a84eeb@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <58ace88b-2046-41cd-891f-88a331a84eeb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/24 17:43, Jens Axboe wrote:
> Something went wrong with the subject line in this one.
> 

Oh sorry, 
b4 shazam -C --single-message d2528a1c-3d7c-4124-953c-02e8e415529e@gmail.com
didn't find the message-id and I had then manually added in the patch - 
something must have gone wrong.


Thanks,
Bernd

