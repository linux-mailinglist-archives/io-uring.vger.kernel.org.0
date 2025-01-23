Return-Path: <io-uring+bounces-6086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 130C0A1A64B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1676188826A
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C98F20F971;
	Thu, 23 Jan 2025 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="ONgH7q7n";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MZ4psVHC"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222A20FAB7;
	Thu, 23 Jan 2025 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644010; cv=none; b=kNnErioBIZzowzP0HWCt+AO0CGIBSK/Wi1MtulpzK98Ovw7jmzvQjg/x4Bi2FesL1r2ro3lBSXeQrcRSI4sS1fUF+dnTttu5X3Kk/HilWQE0CauZGaiHJyn9DAhmGyUFcIKxiBaXNf6Lqf837sZAQOalxE3mdgaWxNeQ7KAR1Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644010; c=relaxed/simple;
	bh=sGw5YsIctgSBZq7lju/LXN+/XHi1lwJtDpccxoDmoxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MUaKI4GdmRQTxJPOULk/HlJTQxJnqDtQndiNFD9exFg4TPnFpkcR1ZvhbV6cnasctBH7chYfYhf6nbMsFOP0N7Lds1MXAi0lGjA1FvJ6kYZOQKpSQahy2khFaQFz2YQihykfS9eyM37RwnLgvrGPBhshGVTOIuD6/PVeG/gYEBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=ONgH7q7n; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MZ4psVHC; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 64C3D1140096;
	Thu, 23 Jan 2025 09:53:27 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 23 Jan 2025 09:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737644007;
	 x=1737730407; bh=sGw5YsIctgSBZq7lju/LXN+/XHi1lwJtDpccxoDmoxk=; b=
	ONgH7q7nxuQU7ESO8PDIXForL2wCE9qbIuU0rE6oAPaPhSwvwYDjzvswTxr1T13H
	G5MFwsrdHAKRPTYk7qXoHNo6wTBkimgHu6aUe72ZJDdOnUX9Z/aC4pE6RpP6vngO
	yFvKdoETXY+/HohLcKf+s3hJDozjHtWTDwJ5uTlLZmUd2uF75bzfScOM5VVGR44f
	1bbZdOtQwwHRj7Y9sHWWBfQM9v+DRkSflXhx99qKPtPQ42E+O6Yk+hgR8bQcOPW1
	Z9LDvD02+CuRekso72nAIruq+FWUcbKHi7td38qOP8lwTlxIGNrDy0XieA2EDk8q
	+E2bglhbq19VVH3ST3E3mQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737644007; x=
	1737730407; bh=sGw5YsIctgSBZq7lju/LXN+/XHi1lwJtDpccxoDmoxk=; b=M
	Z4psVHCM4Vvu/ciy6tMcKp4IIN5KLQfczMXMHllJfHY3zLSTliHRg1tVmI8qWgTB
	PxfL196IWEZ8WaZg561MYz2xAbWg68OPCLlVUahSCDvMyCfNteNjqxpqeoDBmZpp
	bzjs2Ngt8izoT0QXZ165SIRjv9JLBY+lqw3fNC1/hHvZ1zuM/mu5WhjlkcrdzOwI
	4j3htIQHkN/jI79tXT2JEbdR+8vVEqefP0hkj9/NS9vZjrU9rHq5dEWyE/Zai57V
	BQyK9PdUzrMltzwsO/CyIpR8eJnWtezhO+8KDhpqDdFmMOCSHL2DapdBarC0JFjD
	9+/4AoLss18smlnn88bCw==
X-ME-Sender: <xms:5leSZxVhwJEl8Rs8mNU0-27ulCucB-oMDpb_asWm8mLaGffHvO-_7g>
    <xme:5leSZxlQdOOyoUUnxwQnSO9hWeiS_uAgkUFPbY59Jbxao89YWU8Q30QS5C_nUSZFf
    S67PzZ4rk2DYf23>
X-ME-Received: <xmr:5leSZ9bo6NQaK4PG94wmmbj9RsI3buMx2b8go0b657fYUIhypJlAq2Eid05qm8_sS4aj5gDl275B5kBpEfwQ0lCzDUU-eMLDY4Sdq8Hne0PhPj_4L191>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejgedgudelhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepudegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsshgthhhusg
    gvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhh
    uhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmh
    hlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrih
    hnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhho
    ohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnh
    gurgdrtghomhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:5leSZ0XThmYvnwHZrjZIuniaqUZ1sgXcSWd7Es-qCX9IpmNk0np0tA>
    <xmx:5leSZ7m2F5_FWPQ2u8h2kXC7Nd1daX4A78V6-YzkUX-mP-LTLkV9ew>
    <xmx:5leSZxeftWxGvcaCtnWHEJwMzc22mbtIIt4Yenl8KHROhyLbxk8q_g>
    <xmx:5leSZ1H4FIRf7jdC6r2K1cUQsNdeDTGJXi36r6S1XX_HH-okPPJckQ>
    <xmx:51eSZw_6-6iRDHNtMKB9F0MGUC3xKnF1G-fzdv41ZtxwLGPuZF3CR1SS>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jan 2025 09:53:24 -0500 (EST)
Message-ID: <9516f61a-1335-4e2b-a6e7-140a0c5c123d@bsbernd.com>
Date: Thu, 23 Jan 2025 15:53:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/18] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, Luis Henriques <luis@igalia.com>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 Miklos Szeredi <mszeredi@redhat.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Miklos,

or shall I send you a fix-patch instead of resending the entire series?


Thanks,
Bernd

