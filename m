Return-Path: <io-uring+bounces-3574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E291A9993FB
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 22:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEFD81C227EF
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 20:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886D81E104F;
	Thu, 10 Oct 2024 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="Dv+TusJv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eqHOByfW"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB2F1CF5C5
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 20:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593777; cv=none; b=n3v+Yyg71m9O+wlYyCC35NoJRv+69eALxkl/0q5eIOg31mZboNkolnAdL4pWMAWrnZIde2t+HUvjCfwXS8niscEEiTilsz8evgVtY4cx4zb6OkwQey2ISM/hwkfo0TeJN/Dp9au/NQbKfDIFZPnzC3Su/J9VNAVvAIDBWLIedrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593777; c=relaxed/simple;
	bh=Nxt0JYqXSajs+mJAtTuVqwVMU5klA2+Ya5dwcCQO5Nk=;
	h=Message-ID:Date:MIME-Version:To:From:Cc:Subject:Content-Type; b=t4oAlXXTr1hxzgsaUTc5OgL+OUbYpP91kfpdu7i7IkOcvxWm0eKCzppG6WI4Y2GS5seMJGdXhANuY/1m1oC0JektKBwL3fImt0M0nVFWswCQ+NHE+C1x2E2dz7yTYlnPmItEMY3MFU5ULr3aEduI2PvNyTHhyYQXLq1GgVuMM5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=Dv+TusJv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eqHOByfW; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5FB6B1140176;
	Thu, 10 Oct 2024 16:56:14 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 10 Oct 2024 16:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1728593774; x=1728680174; bh=eO
	9AdGQREfGnxWrI8QDdDSBzJ8WmL1r/7w2ykspxwQ0=; b=Dv+TusJv6AHLB4v2aB
	fwsJEgfem08wJgv0uVLqeDcPbdosPTnuxmG4MV4C/F3XH8UUi1MtBC2pX2ebBkef
	UMoj4HN+o9/sT0vnWMgiXSmyEksdvDoIwmxfpTAUNmRyAwVm2OmBAtTEjfX7BG4T
	i646sKcQW7lVw0OikX+qYTER32rfVsqdpLBzj3xkFvc01mi+6OE5cNUE6vm6qOuA
	8r9wKBFP18yDUi+W9han/QSXNPuEnSQxV5mpRRiCkXAYg3mGFssCWf9z7+DrpCoY
	w82VMnhMrzId+wQohD2PtEnrAdHELKAA/37+JHH5TU8DrXowWOG5Ytdb2NQDtQ4+
	ce4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1728593774; x=1728680174; bh=eO9AdGQREfGnx
	WrI8QDdDSBzJ8WmL1r/7w2ykspxwQ0=; b=eqHOByfW2AVHrl2V8muNggDsiugp/
	Lt8SYSxvZ6DHjwu0X18pgX7bjtX60Wg0aorgfKWxtRJhBqUmCaWG9mrCFEp50/LK
	P0RaIFlfwgc85FmucLGQFyt1zG3KEIP4hbn9UTSxpgJz1qGG853HKpJCwvmuoGWx
	wwvn3aKYV/06nTm0mjvCX1O1steT9PyPV9uKLHKKcbW0j/hx/kW05djcfCDOT48n
	xPNcSUAij3889uFTovC6hxjG7VWASgFUV4M1UT30zca9WQ4VpicBuCi3naL5FtN1
	DrOuipFhHNyCpq49fRRI4btVD4s0d9APUuNEY1+klslUYF9uB/ttnYkGw==
X-ME-Sender: <xms:bT8IZ5FcReLWNx1qc2H-D66r75aKlotrm6Ar_tEuCNRBAYE_vk_OZA>
    <xme:bT8IZ-XLVATewQ91gPsL3ygDyNb4MlkNmuRfouLl9CZb1rE0L3dsxn_au9aY4wzYj
    2UCz-OMhJacvWe9>
X-ME-Received: <xmr:bT8IZ7Lmxov35PVQXgenUZkkdhl9G9mHn0-9Tg7Fh77ZUwSykPg2_loSXC32bQtKpO92xt3VfsWUXcilmt82mTyFVGltBv2kxittm2fCulrRjs5b5nty>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefiedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfvffhvefutgfgsehtjeertddtvdejnecu
    hfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrth
    esfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepuefhffdvffefiefhleel
    feffgeegjedvjeegvdegtdfhleefudfhtdeuvefgkefgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehf
    rghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuth
    dprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhope
    grgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgv
    ughirdhhuhdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomh
    dprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:bT8IZ_GR74MzefNIWYhJx2Nfg0Ed4gY7zLvbsLToo-Pj8MWgrtO3sA>
    <xmx:bT8IZ_Vtjy6dgwU6_e8zietQr6Gh2lR_2nOcJYfH8szJG6VucV1TEQ>
    <xmx:bT8IZ6OLngTbh_hFXB-CpQT4u5bUpz83mm64iSGM50zYjhpFButZwA>
    <xmx:bT8IZ-131-9f_6DiKVPT9mfMZ832auZHvkkjwo_QY11SBxSNXxsbSw>
    <xmx:bj8IZxIId_v1Th4xd-RSv7UUpSn5u92LShYLppQKLLGUlL6SzO4eCriG>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Oct 2024 16:56:12 -0400 (EDT)
Message-ID: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
Date: Thu, 10 Oct 2024 22:56:11 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: io-uring@vger.kernel.org
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
Subject: Large CQE for fuse headers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

as discussed during LPC, we would like to have large CQE sizes, at least
256B. Ideally 256B for fuse, but CQE512 might be a bit too much...

Pavel said that this should be ok, but it would be better to have the CQE
size as function argument. 
Could you give me some hints how this should look like and especially how
we are going to communicate the CQE size to the kernel? I guess just adding
IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.

I'm basically through with other changes Miklos had been asking for and
moving fuse headers into the CQE is next.

Thanks,
Bernd

