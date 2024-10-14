Return-Path: <io-uring+bounces-3656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0421999CA9C
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 14:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 884341F23232
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 12:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280331A726B;
	Mon, 14 Oct 2024 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="i2eLTC58";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PRf2I3Gk"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E655E1E4A6
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 12:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728910078; cv=none; b=Maz0BGo5Rfj7bJwp1W8KPu2aJitxILN/bL9PHwhUuCFz6dgQS729pngXKukXhDpleI38a8KvO62pgFAOOrFesWZTxOQR7sw14YTLFjAooZlm8mQHlaLdqNsFUd74ZwYpNEVTfXWGNWOBUUyWpUdo7tH8kJ1KpgLn3qO0bQe88hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728910078; c=relaxed/simple;
	bh=yp3+YVWhV4NxEBdlR2T01oKs3Ij+C0NRYrh/kaKBLCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fmkTradN2ksmvcfQxNUUtNQbfsbS3U34w8anrKnxC5feCsPGAsxesTHURt4g7Zo0H6In35gEnYLBxUAY0OulWG44IC94K/TJFi8LYwlsbqKnsEUKVjl9U/BMpiKKN3klfzodFicW7j3cFuXs6f8ROWlQ65NyWoLi6Vc2WY80qWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=i2eLTC58; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PRf2I3Gk; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2A388114015B;
	Mon, 14 Oct 2024 08:47:55 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 14 Oct 2024 08:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728910075;
	 x=1728996475; bh=L1dLjmKsNlzQUi6LsMnb18neaK5/7oE06XSsRM/eo/4=; b=
	i2eLTC58iUQl5x6pTLXvT3OJxvT9G/sI2zgHEUv6qq7f2hSqlIZ08OLtz0ig1yjn
	ZbNpR6C682Zl8YcdAObjwAM+0QE32Bcsa0EfU3VKLclX6RKP91sdzHR09y0cCN3H
	JuQk+y3J8s6ds4DvXWPphNg1Pb2H+B2YxOWIWQtyqt7RpOliyLfngl9REUd3ORnJ
	500ilyATIn+gVqvnKg2gmqLMxklKfU2wAxTHNEwPkMPnnhHDj8JDVcdq29ZvqOdt
	Vil6lXHsiIvLv/Vf46CmwB7GWI2Z6rEgsytE+ZNQvyUaLiG05glHOyi5q5Bc5EXn
	2ojJu+0rRrBI+IEXG3DUzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728910075; x=
	1728996475; bh=L1dLjmKsNlzQUi6LsMnb18neaK5/7oE06XSsRM/eo/4=; b=P
	Rf2I3GkRZXQvZqz/CUjR+j+t2EkWQ2kWyCJyGQMbTHywYVrkZYjCzOCYlBzbBxCJ
	jPVBNck7cesaAmD6IdX35F6QjdvfGr9Dsh05KVAPQAOYg4hVvm/rT7NYsAorvm5p
	V1EfaL3JI2H1L5kGtSypqxX9M3affvmtIs3aLTgO8h21IXMkWYh3uZ6OENWx4SA7
	xQvqgiHaYcEou63D7tpzNCoO6F3xmhPMS2XEIQepSlUiSs9EzELVaJ/IF47WDzR9
	NpQeWh84btxz6/22ouVmyMGBWv1sV6Gxk+wMhp3ZcT0eXOmtgrKjw7Y/LdWx7Aso
	+q1Xneon+bSZiQkjGSWjw==
X-ME-Sender: <xms:-hINZ2Hqc6fGcmpa4XVWdeZTi-QktshyysOrwYCvLV1i8t6UTX-pYw>
    <xme:-hINZ3UNUOjUMrKeuc3sPwfSfcvuXe3vnqBdcv4c1DhtQK8-l-76BQ0r9_2akiqa2
    vHvEpKCrwxWWaVh>
X-ME-Received: <xmr:-hINZwIxaauLzRE_-WeEZcp4lW3xkc7GEHUofY069rHbtZN56GM5YD4wj03uTU3NhNA_69MLwL-JHXCgcdo8jvvtVOqtNClLX6FMXAVIIoXqhWseoQ6k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeghedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    thhomhdrlhgvihhmihhnghesghhmrghilhdrtghomhdprhgtphhtthhopegrgigsohgvse
    hkvghrnhgvlhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:-hINZwEWjay54hw8ZsmvrCDBPRHAWljw8L1qQSGIrIDPjLsTgq8P3g>
    <xmx:-hINZ8UIB52I08oKj5fm7CyTtG9Hd437jIb2hAJzrz2Kq6BzYMQLQg>
    <xmx:-hINZzNWYpoXJi9mg9Nz4h_ncU9xOX5a0vPI6RRpULzYHmsr1gktAg>
    <xmx:-hINZz0X8jiMTXFqD7v8ro7rjt7u1lNZINyih34_ZhMwSVd4x4SkOg>
    <xmx:-xINZ_He24ecHJmELpMbLB5zRLapsIhIL8CZf_qghnl7-78Imy5FzL2e>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Oct 2024 08:47:53 -0400 (EDT)
Message-ID: <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm>
Date: Mon, 14 Oct 2024 14:47:52 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Miklos Szeredi <miklos@szeredi.hu>, Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
 <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm> <ZwyFke6PayyOznP_@fedora>
 <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 13:10, Miklos Szeredi wrote:
> On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:
> 
>> It also depends on how fuse user code consumes the big CQE payload, if
>> fuse header needs to keep in memory a bit long, you may have to copy it
>> somewhere for post-processing since io_uring(kernel) needs CQE to be
>> returned back asap.
> 
> Yes.
> 
> I'm not quite sure how the libfuse interface will work to accommodate
> this.  Currently if the server needs to delay the processing of a
> request it would have to copy all arguments, since validity will not
> be guaranteed after the callback returns.  With the io_uring
> infrastructure the headers would need to be copied, but the data
> buffer would be per-request and would not need copying.  This is
> relaxing a requirement so existing servers would continue to work
> fine, but would not be able to take full advantage of the multi-buffer
> design.
> 
> Bernd do you have an idea how this would work?

I assume returning a CQE is io_uring_cq_advance()?
In my current libfuse io_uring branch that only happens when
all CQEs have been processed. We could also easily switch to 
io_uring_cqe_seen() to do it per CQE.

I don't understand why we need to return CQEs asap, assuming CQ
ring size is the same as SQ ring size - why does it matter? 
If we indeed need to return the CQE before processing the request,
it indeed would be better to have a 2nd memory buffer associated with
the fuse request.


Thanks,
Bernd

