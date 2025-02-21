Return-Path: <io-uring+bounces-6621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EABCA3FEAB
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 19:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FAE6168E5E
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72BB2512D8;
	Fri, 21 Feb 2025 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="tzBzq42O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fqnsLf6w"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520782512FE;
	Fri, 21 Feb 2025 18:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162207; cv=none; b=h80FdWRGxxrlfgZL+PybEsOEP+75Qyoze789mN/PuKfljG6jS3Q17Bc9U9zBKqdnkoBbOXB7uwkNr9Hb8JhLuIBUBXQnbP4fRnzCmAhyn4FnpeWMjz8v7O4zF3NeaYALQsoeCPWQhV0j4bCfnCf4CKe5OHlv11FDLNfc3zE1IVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162207; c=relaxed/simple;
	bh=5gNbIVO1Q0xR4f8kWNwQWFznZAlXNb5Y9bHWdVu03TU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F76ntsf0ImSxr9PVXbXwNVkWWEV8GCPyWFskR0jVbfmw4lPBIpEC183tvgVYY71zPGgoot3/NiWYg72exkESHhpt/rRIjXWy1KSgmgVyxxWD0UaXMnQTBfhHpXQfNiQ0ZKDznxE0uVPx3tnYLfmIzSEW72MUYiwfKXWsRSSEkcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=tzBzq42O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fqnsLf6w; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3F83225400F6;
	Fri, 21 Feb 2025 13:23:24 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 21 Feb 2025 13:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740162204;
	 x=1740248604; bh=5gNbIVO1Q0xR4f8kWNwQWFznZAlXNb5Y9bHWdVu03TU=; b=
	tzBzq42Oli72eTRBX45hbRNgB4qTPHs1Bg3N7eNjhHJAAAeBJcW4WqOkoJmUzKbD
	+gBwfoZu4/U7BqqTUahOsc+sXaoT02erTuxmUpMHEXW4Y1329E6575Of3SC2UGt2
	H23Uqmh18EFn9i+r15uRlMz59fbN1XRkClbvVWV0AVeB0+wgTX/ue2w+9K8aa1Oc
	f+REIMANuOVSRssk6Z3DfpsQVSWWH8CS1Shl+KnyvCMkjc1xmiwo/5Xcrb1R1vfG
	9I9qLGTFomwB550sTtxN9aTReyLjfpagKXW/u2CHNAIIMNmxgwtPomEwmfq4ZBKD
	BGin7ETrIPKp/Qn+yA1Fig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740162204; x=
	1740248604; bh=5gNbIVO1Q0xR4f8kWNwQWFznZAlXNb5Y9bHWdVu03TU=; b=f
	qnsLf6w7WXGMKKdL0ZpMz/I0LVBPdTHFzaKOvXBxK0X5QCts1nFj9LrHHRgJluB/
	bEADp57Jf4wBcPDErKeA//lvcdRE8+m86YN9kIXjNARru/Noqvr9yB4NfsOZG4RJ
	rCIQSL09kjAZoo9hWaQEhKpdBG+XJJn23FXsk0zh0+wKNOQUcZpgPEpRgL/0nCyh
	JDn25I+vIMvQtIQRIAX0+UN+xbo5HbV2gh30KXfpGL8uqagcWhTnxwQ8Dj9K6qX/
	yZHDABlHKpyPcSphJTcm6gIvUByVhQpqIR3pzYXQeAJTF3+VKRQ2Mb9v73Z92He2
	RfdIrAeS1OAGmqzR1aeLg==
X-ME-Sender: <xms:m8S4Z30Ub33g3S7Y5qqudg77FAVa-hJk_xkoQ1MSDUc6_67LM4p_Pg>
    <xme:m8S4Z2Ej5sW9oxr0dZATgHi5S4TdUMPaPG2q74ZmgyVMZle7y_jOA2Y2e9eKcYZiG
    VzIsNamy28I2zpo>
X-ME-Received: <xmr:m8S4Z36OkrlwQFrKtw8JfhgZkqs2ZSlVGaQxOZJ4WcpEKrUgvGDJnk9ONC_xzA8iQAHUUKN4QPugmqjTx__IyqdBlQ2vjf0d026xDpWAJ-hcbuVqCG9t>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdejfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhepleeuleetffekhfeitdffieffvddthfek
    ieeihfetleelfeehjefhueeifeffhedunecuffhomhgrihhnpehgihhthhhusgdrtghomh
    dpudejrdhithenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeeipdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehmohhinhgrkhgstddtudesghhmrghilhdr
    tghomhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtth
    hopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhr
    ihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:m8S4Z81Ld5R94sPqqXnyPjGDlvmq2554gWGp_gOBeWc3D2kLzHRDtg>
    <xmx:m8S4Z6E4JUiBBiRcFs0GhbY5b6bv6nPUyKGFx7eP_xYmlK1AJhIyjw>
    <xmx:m8S4Z99eDHyhZwDZg3SnZ7sEkVYgKjC30PwFVIcQvLQzkj-vetMPFA>
    <xmx:m8S4Z3lQsjiDJO77pPlIghuE8cKFDQ3XgwmJzBATuogT0vyGsk6ZdA>
    <xmx:nMS4Z_6SbovzPlwHTosv4wQTPx53Bnc9dYq3FVbyykRcMVQcsVui2_Iw>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 13:23:22 -0500 (EST)
Message-ID: <7af8193e-0761-415f-9940-6c4d1c8073cf@bsbernd.com>
Date: Fri, 21 Feb 2025 19:23:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Moinak Bhattacharyya <moinakb001@gmail.com>,
 Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
 <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
 <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <72ac0bc2-ff75-4efe-987e-5002b7687729@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/21/25 19:13, Moinak Bhattacharyya wrote:
> I don't have the modifications to libfuse. What tree are you using for
> the uring modifications? I dont see any uring patches on the latest
> master liburing.

https://github.com/bsbernd/libfuse/tree/uring

This is a development branch, goint to create a new branch out
of that during the next days (now that I'm eventually almost through
with libfuse-3.17).

>>> It is possible, for example set FOPEN_PASSTHROUGH_FD to
>>> interpret backing_id as backing_fd, but note that in the current
>>> implementation of passthrough_hp, not every open does
>>> fuse_passthrough_open().
>>> The non-first open of an inode uses a backing_id stashed in inode,
>>> from the first open so we'd need different server logic depending on
>>> the commands channel, which is not nice.
> I wonder if we can just require URING registered FDs (using
> IORING_REGISTER_FILES). I think io_uring does checks on the file
> permissions when the FD is registered.

Could you explain how fd registration into the ring would help here?


Thanks,
Bernd

