Return-Path: <io-uring+bounces-5082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4311E9DA8EF
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08738281165
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31881E526;
	Wed, 27 Nov 2024 13:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="ls0XdH9n";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="1KKakUS3"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2728F1DFDE;
	Wed, 27 Nov 2024 13:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732715144; cv=none; b=Cypk9noUQc90o3sYF9RQjdSsFXkp4sB3EOW0Fz2OcfBGy92w0T73SJfSTFIUmqp4b+NsAa66E9d42/S15umIS0uviyD06Qo8pxMTe1RsKmzOs1S1hjLnCCAusfnJNB2S41KsWmqt9E9RpdQ5VnpQ5hNZ0XkKgcW5cJTfnI/j1LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732715144; c=relaxed/simple;
	bh=WASvX6hE/rWlVrt9suJmdieDasH6GZNfFERR2LOcQo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvCpK+Kb52PPAu5e+odnQfSQsnw4uheG/ZbfrPdaOK1UFZj15OJbK7MlAu5BRAbcopVpgxKMVf93J2myBOP9pmabsHhb9bngP9wifBf02m/TDyL9yotAhSUIGh9mCL4YoOq1BTe3DRXaC0ZJeqgqcz5P75nry/yPhG0pbUMLu7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=ls0XdH9n; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=1KKakUS3; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1E5DF1140176;
	Wed, 27 Nov 2024 08:45:41 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 27 Nov 2024 08:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1732715141;
	 x=1732801541; bh=WASvX6hE/rWlVrt9suJmdieDasH6GZNfFERR2LOcQo8=; b=
	ls0XdH9nMrnVo4q23xg4eN6u9OvcFHMVLANpmjWNt/FhRrUcigL2BAXRfLXUjM1y
	bsVeCIt0GgphkhpLCjxuRKcFkdC2uIPWZygQ3D/eSLS+iawptOl01D5OnI4oM+77
	ainM754U3IXlvGvhMPJK/7nOcIkkRCowARStT8yIxJ4VU2uAfK9R4mikzkp5nhJp
	QfBBVAzauEL2IALfTS8I6zJAOgkuc6SjYuvWYQb+C2zkxd96bMAmFW0Tr4mmYOsl
	Ao2MWIJEC7EIFYeYbWiedwOE47VuRugloXE0OFm2b6IBRaY5/LVymqo1V5ybtIKC
	CYdGbJV2wQffUvb2nrTsLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1732715141; x=
	1732801541; bh=WASvX6hE/rWlVrt9suJmdieDasH6GZNfFERR2LOcQo8=; b=1
	KKakUS3x7pr08JKrmEHxjhuEnH1Tb0GGXY0OqmUWu981UuHsV7GH1dF7r6jLU2pX
	ADJbks1qGZQB1di+YlotTMaYJpwOM6XCT2VVl3pVq75oYZks59YKVs3jRPe5BYP/
	XUaVM/ucuW4HjvUpRPcB4PiMLWIroVKEmL5S6py12kRYk6R2nQC4TXVRkTDZAhVG
	vygpeOjFaiAr/M5NfCfCvGZZTKkjfgTf9sMcUiABFfCL+syn57hTD01/g3j+WPTd
	jxLB9aqG98wU/NbNwSX9ebW/u5zUEFmLXEamGBS4n+AznomgkKQoMgUMsdfITgsV
	KU0PobM6u8wyIZbsXo11Q==
X-ME-Sender: <xms:hCJHZ8_gjzhFAOA_ZiIC2rWgY0d7TPVjwHvuTYv8Gm8o7XgeL7Zuug>
    <xme:hCJHZ0vOBmIKpykQh69737ctQ5uABO45CwJ677Oj0VTbpGAYCZ1IUhZoBm3qT3d8v
    az3OrIsa2VVezKF>
X-ME-Received: <xmr:hCJHZyCQwQgA6NKgmwrjBi6JDGM-lrA-UWv6oB7NSct1sM093rgKvdu0Q7XkGK7cOMPSHLIqUpO_Io114bmDGmpu1V5m7kkEpxNlLernYAcOXFWVFmNx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrgeelgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrh
    htsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddugfdt
    gfegleefvdehfeeiveejieefveeiteeggffggfeulefgjeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthes
    fhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtohep
    mhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnh
    gvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhm
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtth
    hopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomhdprhgtphhtthhopegrmhhirhej
    fehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:hCJHZ8eJSoQa65jLX3Sz1rmcZepTGDbyGDirymdx2q60qKK56v3LjQ>
    <xmx:hCJHZxM4PR16H1lIwKHyLOaUTo246KngNdGmihf97P7Qs8TVdRxtjg>
    <xmx:hCJHZ2mO3B-srq6zK2pCAqQejNMrmjm21kR1pJFpO1UQ7zPMG4yocQ>
    <xmx:hCJHZzuKRII2NrQ0jbP11dliVard0_b_3kmalnc4I8C_JeCPr-Rk1w>
    <xmx:hSJHZ1mP4wXp--MdfTTQ9lcSCBzqWlJccRFeJHUUSa_IyQ-0EYlq3-vB>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Nov 2024 08:45:38 -0500 (EST)
Message-ID: <821bcf94-4e95-4be7-9136-f5839c18009f@fastmail.fm>
Date: Wed, 27 Nov 2024 14:45:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 00/16] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/24 14:40, Bernd Schubert wrote:
> [I removed RFC status as the design should be in place now
> and as xfstests pass. I still reviewing patches myself, though
> and also repeatings tests with different queue sizes.]

Sorry, my intend was to remove RFC status, but then forgot to
actually unset it :/

