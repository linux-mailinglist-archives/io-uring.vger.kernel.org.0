Return-Path: <io-uring+bounces-5300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06A409E8CF6
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F405D1886C98
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E632156F5;
	Mon,  9 Dec 2024 08:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="aXrKLfYJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EjKSgLh1"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41448215163;
	Mon,  9 Dec 2024 08:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731338; cv=none; b=eg2yXXAj6YZhYtx20SCWTo+DO8iy0rvPHTL0dVHBc6aIvfBWzAZI8jcIMbig+PXOCv9uUesioM51cuJxyfB6Qbsn57TGQH978nIv29C7LaTOzB6HWM8oG6EJjZQ/7CCjHIpf2yA00C7o2TDS1HhC2OaQqtFraTxBz4dz+TJW0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731338; c=relaxed/simple;
	bh=GlILRVtCUgPv60lF0m60GMmC5sHH96Oxu3ALnNgIEhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpcwgEPTbZ9kP22VLkRv2GRMyPOpL1zo71P7Yuhs9BjoDZgxl/lejnC11iKoc1TF2+olGmhs9NjZhntoKuLgJgyBR00oMSoCN8pEZ51VZQaqgRZ0N4lBoKxjCgTFOaGerAUgFwSSX3KiRCp+b6VlaKthOjYs4dtC1LmZRcc9fOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=aXrKLfYJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EjKSgLh1; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EC40A254011B;
	Mon,  9 Dec 2024 03:02:13 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 09 Dec 2024 03:02:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733731333;
	 x=1733817733; bh=uYnTf+urMkAuBTorx2BTqGiCMWrBS4cNzY/BkhxJ8vk=; b=
	aXrKLfYJqkNkYz1HPiJXpk793SrId/5DH3sHkK/g1fn2l4+BJvCg3vxO+Aaeyn91
	iNZUHOlLRR3PGWzbOW19kyfBxLS1pJ9qtI5jxqIeFj7wtwivMNltg81R/eRHebDZ
	2BzzHgtc8z9rWNzq2tqmRm9axxGuvcVBBb5CjZF7XBCYOztLCk0PJBPdPT7ERYT7
	RjgUqLfqn3j1rpSCC/6ot0VJL3orfiFxUKX5ik7l3pyUkcsBxwW6ZxzSkBE3p0uR
	uWmmoDDq+Pl4hRAWMZng0K/8zke4EKAFKlMzLhq3QB4iHTErHh3szrPqDaNU+fU5
	VkYUiO77xwOLyHA0aFFBFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733731333; x=
	1733817733; bh=uYnTf+urMkAuBTorx2BTqGiCMWrBS4cNzY/BkhxJ8vk=; b=E
	jKSgLh1FuTYxLDTSALhxsDF1ybQmgZWznbYFnoHxH2xyKPk1D+6AfXdGMLxOKaF6
	MKakg/2gVrd+J3X/YEW8dPWdTADh8zNVOflhU2TI8xDFffImcaLcYX29WnYwFkMZ
	kQjYRy+ktItssD7CV5mzOvONBPcZxx4ZfK20k3NdUBMb3K05V1knbovud0YAefO4
	afGVQa/5J+UpLqY5M8tz2aO4fNNdRjAZwhzTDIa4yM4gggarRoSrlF4GGd2omCZh
	xOTNiW2TDKEsa40O0y3FH2pG6g34qztaU32+eyiV/gHo/OlfoYaK2J54S1eJvgyx
	raiiW9hwJx+WdeD5WJpgw==
X-ME-Sender: <xms:BKRWZ5c_cZVSXPJyyvmpVhlgB8BXq-xuRxbfrBsUX_FoDM44cCsJ2Q>
    <xme:BKRWZ3PZgzlUmqXeAKkVkaaqNrhUE7EtZArw2xLTqKTJ1aQgzs5atojFeJnM3zH7w
    yZOwq3c9XWJZdhx>
X-ME-Received: <xmr:BKRWZyhA5RmjXh-btpXFX83J6tBplMOFtODWqTs1tqQe9qY7Yj7GYUTW6mm_sEnZHs69nLq4mkOglKseRt7IJKGtesMl-AtkpKlv80g3JSKlyKLOu_Tn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrjeeggdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeu
    udejhfehgedufedvhfehueevudeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghsmhhlrdhsih
    hlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsggvrhhnugdrshgthhhusggv
    rhhtsehfrghsthhmrghilhdrfhhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggunh
    drtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthht
    oheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehlihhnuhigqdhfshguvg
    hvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhg
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonh
    hgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggr
    rdgtohhm
X-ME-Proxy: <xmx:BKRWZy-tAxjRtw_vBZNDr_S5dgFiauFW8eFnKUQxwNokk5tJmpeK7Q>
    <xmx:BaRWZ1u7wCxabMcUiFaTXz_UTAxBu2-BruDBMqBcgAg27C5s-0gpag>
    <xmx:BaRWZxEkLlm3zbnNOdJWi9HP6Q8Nts0gAdjF2szaLKYSDeBKAc3mlg>
    <xmx:BaRWZ8MyVt0pNCF6opBdBMJCMs8bvQo_6JN0mI_hLL9XK6LdvVbgAw>
    <xmx:BaRWZ-FpUKbG_xVUsnBMLRB1vg8FOYkeCgF_7BFtRDtXK1gb_Tv8Gxxd>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Dec 2024 03:02:11 -0500 (EST)
Message-ID: <f31ac1c4-b37a-4adc-b379-3d9273aec4c1@bsbernd.com>
Date: Mon, 9 Dec 2024 09:02:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 00/16] fuse: fuse-over-io-uring
To: Pavel Begunkov <asml.silence@gmail.com>,
 Bernd Schubert <bernd.schubert@fastmail.fm>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <57546d3d-1f62-4776-ba0c-f6a8271ee612@gmail.com>
 <a7b291db-90eb-4b16-a1a4-3bf31d251174@fastmail.fm>
 <eadccc5d-79f8-4c26-a60c-2b5bf9061734@fastmail.fm>
 <96af56e8-921d-4d64-8991-9b0e53c782b3@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <96af56e8-921d-4d64-8991-9b0e53c782b3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/24 00:16, Pavel Begunkov wrote:
> On 12/6/24 11:36, Bernd Schubert wrote:
>> On 12/3/24 15:32, Bernd Schubert wrote:
>>> On 12/3/24 15:24, Pavel Begunkov wrote:
>>>> On 11/27/24 13:40, Bernd Schubert wrote:
>>>>> [I removed RFC status as the design should be in place now
>>>>> and as xfstests pass. I still reviewing patches myself, though
>>>>> and also repeatings tests with different queue sizes.]
>>>>
>>>> I left a few comments, but it looks sane. At least on the io_uring
>>>> side nothing weird caught my eye. Cancellations might be a bit
>>>> worrisome as usual, so would be nice to give it a good run with
>>>> sanitizers.
>>>
>>> Thanks a lot for your reviews, new series is in preparation, will
>>> send it out tomorrow to give a test run over night. I'm
>>> running xfstests on a kernel that has lockdep and ASAN enabled, which
>>> is why it takes around 15 hours (with/without FOPEN_DIRECT_IO).
>>
>> I found a few issues myself and somehow xfstests take more
>> than twice as long right with 6.13 *and a slightly different kernel
>> config. Still waiting for test completion.
>>
>>
>> I have a question actually regarding patch 15 that handles
>> IO_URING_F_CANCEL. I think there there is a race in v7 and before,
>> as the fuse entry state FRRS_WAIT might not have been reached _yet_
>> and then io_uring_cmd_done() would not be called.
>> Can I do it like this in fuse_uring_cancel()
> 
> A IO_URING_F_CANCEL doesn't cancel a request nor removes it
> from io_uring's cancellation list, io_uring_cmd_done() does.
> You might also be getting multiple IO_URING_F_CANCEL calls for
> a request until the request is released.

Perfect, thank you!


