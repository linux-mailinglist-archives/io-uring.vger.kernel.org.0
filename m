Return-Path: <io-uring+bounces-4781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F0999D1959
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 20:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ED992875BC
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 19:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09C81E571C;
	Mon, 18 Nov 2024 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="X615/zyB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jAhKgecz"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AB31E5716;
	Mon, 18 Nov 2024 19:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731959718; cv=none; b=YDpN+ZTGPxUKD1Y3Ng9BAart8GU2GDxRUNhG9XCEtp8DnXmnYSAo1dbcMjptlm+suWUbuKxuoxYlScExRDHu4XYofvOLJgzJZ8s4AfpC7k2HTO6Txv7N1aqQ5RA5jJH08v/FUpd54iXmQ9GIJFgAuUCn1UT2fcOcfWHwBIHaTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731959718; c=relaxed/simple;
	bh=COFra1cSkMU9Tj3eTsmknQdxGlsRcbc69822/W9wdvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uojZk3JX4cx86tzyj+r0mcpQ65yniWEsSa0FHB8pWeQFk0U1zggne5zaqJYuo+qh3CYdABaznEUw6JMe90f+q9NBuZsFPYJcOvsEBOeZ5XKJWHVVhf2Tx/J8nKNlP9YdI3tatmB7FXcjzZw9ohhyRoO9CrKThRqdLEZOwJYRK5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=X615/zyB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jAhKgecz; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id D094811401C4;
	Mon, 18 Nov 2024 14:55:14 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 18 Nov 2024 14:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1731959714;
	 x=1732046114; bh=2gYqUUbZvLTaQ3uZ6C/LVYQaFrShCqkJFSOIxl7fPjg=; b=
	X615/zyBBjo1B4G41LulVTbxuSYsVJ3HIJHfv1w4EbMfG/MT4XpsWrlG4BAfAAmy
	ONTAN+QO/fUjSzLuUo3J0rKxKQOe85FQhQvur2qCSE/TXEyzvz5Lyqae+ABx8SQr
	b4HxuIdXKM+37eGGJRqiioMutslE5PX/R3xq70YXLPNXnM9ifm2eF2rwfil7Bo9B
	ZmwgfKEurQDNSFwqEr4bYkaF4QncI6DQD4rKpCHBM2K4YYAxkW3iojnIrTP2u/X9
	9E03P6tsrx2elpL3jRtN80tgXVLTP884sW24LqDTxeIN4hqOxtoduWTSUH08dQr5
	Hw+QgoDm658fF4wAazb2GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1731959714; x=
	1732046114; bh=2gYqUUbZvLTaQ3uZ6C/LVYQaFrShCqkJFSOIxl7fPjg=; b=j
	AhKgecz+RCn1LFujoT5BMC0NwUb7gwlDb7zSu1xyyDFmcTe3Qbmpo4ap3HXZ5OF/
	OZWLJnPxRjWtIRSKvxbGCzHCB5iPKeMW87scgLA9vapWES4DwtF0NmumTCeKd1sS
	pk/z3gW9Ebkmh/SwyQlU1s7ViCKYSQBkwnlq8KiFSjyeeWfLXGQQYbpFaRihyxP9
	px3Ep6No2l5Uxp9G4rdPnZp1eYy7KyI1i65OmT/m6tgp3XKawP46RwwZEJSSEODx
	/8QtD2AVwBwFJP3q38PX//qjRTCYBpJPOF2OKoNL3Z1Mp9YFukdJcAEHaYDqN1gp
	/vKv5oyG684VG0S5Ss4Lg==
X-ME-Sender: <xms:oZs7Z0K8mU7MEU-2_2JgTH9TtUDVN91_j1U4wu9HjR-9EbQhqlbR4w>
    <xme:oZs7Z0KQZqcxqJMoesC90KLgSWyraBmagh54uru8rHLnRj7B9EL65FJ9maeUv9Xbu
    S9-2SAyG5u6i5DL>
X-ME-Received: <xmr:oZs7Z0sQf5xOZdg438Z4esPCMARkH2G5UHCPdPhQFsv1wj4fmdvo1so5tu5GBGN0pcJi9ImjgxTA_6XxAM2neyxLmHTXJomtWiH4k7D9Y7zFkT4SAGTy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrfedtgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklh
    hoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhmpdhrtghpthhtoheprghmihhr
    jeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:oZs7Zxa-xB648lPpDUKK9MSJ1MNjbxPhiJEGVfV0ue1HgansQ_PxXw>
    <xmx:ops7Z7Z3GGnjZ8aFKLfEUdfr5vR8Y0S14r2pq_Bpt_X9W9ZclUoEXQ>
    <xmx:ops7Z9AYp2s9L5ff9j4jk-65MzuMe1PR9hsFc2ufYYvchSAQshp6mQ>
    <xmx:ops7ZxYCzqj5YXPG_-IEcaggwynUZclrQRbuqhFCojJl4p01ecd7_A>
    <xmx:ops7Z_Sz9lDPrK82gnJpHeua8Ih2goM8gcV6wYgr9c867bW9uoxkDmkJ>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Nov 2024 14:55:12 -0500 (EST)
Message-ID: <97f18455-7651-42c1-9e76-4fb62220e739@fastmail.fm>
Date: Mon, 18 Nov 2024 20:55:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
 <CAJnrk1ZexeFu7PopHUe_jPNRCGWWG5ha-P9min0VV+LJO5mAZw@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1ZexeFu7PopHUe_jPNRCGWWG5ha-P9min0VV+LJO5mAZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/18/24 20:32, Joanne Koong wrote:
> On Thu, Nov 7, 2024 at 9:04 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> When the fuse-server terminates while the fuse-client or kernel
>> still has queued URING_CMDs, these commands retain references
>> to the struct file used by the fuse connection. This prevents
>> fuse_dev_release() from being invoked, resulting in a hung mount
>> point.
> 
> Could you explain the flow of what happens after a fuse server
> terminates? How does that trigger the IO_URING_F_CANCEL uring cmd?

This is all about daemon termination, when the mount point is still
alive. Basically without this patch even plain (non forced umount)
hangs.
Without queued IORING_OP_URING_CMDs there is a call into 
fuse_dev_release() on daemon termination, with queued
IORING_OP_URING_CMDs this doesn't happen as each of these commands
holds a file reference.

IO_URING_F_CANCEL is triggered from from io-uring, I guess when
the io-uring file descriptor is released 
(note: 'io-uring fd' != '/dev/fuse fd').


I guess I need to improve the commit message a bit.



Cheers,
Bernd





