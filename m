Return-Path: <io-uring+bounces-6836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99539A48085
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 15:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76E5417CCD0
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 13:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD31C22C35C;
	Thu, 27 Feb 2025 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="fmvTZrn0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="flsWnd2A"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC465270052;
	Thu, 27 Feb 2025 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740664760; cv=none; b=FODU8PN+JZKef8hSAfQ5c7hZPh20RlXA/b9CY4JXgtQdPlC0GZNCu9DVI1VlIAmr4CbvqCldw8SfkD7C1IHog0hbFXGGBjrzmG/bYmI9PCCAqvE6bgBtHSqSjPzbpk29f5ad6cHhCqX2GjPDUCB6wRLCGPegTyzkrHQt3Epk07g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740664760; c=relaxed/simple;
	bh=y+Bkv+VAEn09oS8FSYeFM5PWtC+mtLYKTSBaTQol2mY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=H63DLyy3hCj7ZEbqoOmFmh6ITzNg8KCf8nIj6g9YFiiiaRLJ9f6k+HnLTDVIEcZvEaNXb2pSe8LTkgVFoIm5WEC+hLJDsqIC24Lt931Rf2/YluDfN3Z1dtvvNLFavRemgqZCHa650A4NWcvQn1peOfmFSYLAu4TBsgV6JC7zOcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=fmvTZrn0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=flsWnd2A; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C989D25400BC;
	Thu, 27 Feb 2025 08:59:16 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-11.internal (MEProxy); Thu, 27 Feb 2025 08:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1740664756;
	 x=1740751156; bh=LV/WRSas3PMFQMKytZr9MeXHFEcC6OwrMrorB24cdCc=; b=
	fmvTZrn0JXHJdcLxLj35zXruAx13i1axGpMHA7J02NJUm/rgsSRzZBNgaUo2vgKG
	IbApSFgWDy37K72HaJuMgrotCQarLz46vOYWMqXgSYZZpIlNcAWaQBP9L8yIdYDx
	rCSF5Ht2UbiZjzgj56m7WB95zNnwcLV6uRmK8YiL44MzA4L6jeKWvh+dxDqij5tL
	7YsQrsjljSXRvAe5ni9RDL2bBu1Jgvj9MwbYlc1CktCgauilxTNfk5EB/3OShhH2
	Y+8gUZ3rzdyvVvlCBveWFJfQSpnXZuPPQw1JYyDiGQUh7Waf5s6DSpfdwX9Qi+TI
	lbxC8ciyclAFnAH2kIqWKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740664756; x=
	1740751156; bh=LV/WRSas3PMFQMKytZr9MeXHFEcC6OwrMrorB24cdCc=; b=f
	lsWnd2AjyipmUfreWrE469HkXPxVsVk+vcCkhS8vBy5K+p0BTT0TPMeYIcAt6Gq8
	Aj4dQq60LdiPx+xA/YcVTNAI3ZcVT6+KrkmyL5j1sfX5iqPbkYwe5dMB14sWCi+o
	INfc037KrGvgWkLKZOQlwTCWOA3nwFyom+hDT7aAWQOmCqOer4BW8fvtDwCnkt1t
	ZEDUChjn5YCFnTqzsyQg+5y7yUUo6G13KITPKvCjJtvHJahFLPM7WvqpVxGYWOj/
	yt/yJECcjl+ObvvoU7iPBDjLC6a1LwZp4rMnvcVpDwOe5sNMQJ+2JXpIvDkwO0VS
	EMlm2dOhfGcp4giCpnoDQ==
X-ME-Sender: <xms:s2_AZ9gMmvWWs2xgfqo-fwGBgCMEaaOCd26RDcGtRWLRRJjDBBGOYQ>
    <xme:s2_AZyCkN2lIRU92iI2HdqDZtV-p7oy59jVXxhzMnKJJ1OKpouEd-Bi06QjTK31vI
    F_x2q8Y9lC0zLXsL4M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdekjeeigecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteef
    gffgvedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeej
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegufiesuggrvhhiugifvghirdhukh
    dprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphht
    thhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghrnhgusehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehkrhhishhmrghnsehsuhhsvgdruggvpdhrtghpthht
    ohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:s2_AZ9H5Bc-ZumG0jf6bcdHXnVceKT-TvJWwfuycWdoWX5U-wlAy8w>
    <xmx:s2_AZySQjFM3Xc-jS7NlIszjjbNM2B_fHGxHl9qtdAr0VOaFnK7Ntw>
    <xmx:s2_AZ6x7zTEv_zW0IRY3OrQHIp1TnCKkCl3lRVakoXRtRu1EQhpiMQ>
    <xmx:s2_AZ47MEH17T6RIwrl4xSnHnjq0y5Zbabm6J3nbXf_StjA_gZWHfw>
    <xmx:tG_AZxlYhA0pD4Xods2ezKRaOCrC_babLhBzYxqg1HnZJexergIoegjb>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D5C8D2220076; Thu, 27 Feb 2025 08:59:15 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Feb 2025 14:58:55 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Pavel Begunkov" <asml.silence@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>, "Jens Axboe" <axboe@kernel.dk>
Cc: "Gabriel Krisman Bertazi" <krisman@suse.de>, "David Wei" <dw@davidwei.uk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <9ef40a88-6243-4baf-8774-e4b72bfbb2f3@app.fastmail.com>
In-Reply-To: <275033e5-d3fe-400a-9e53-de1286adb107@gmail.com>
References: <20250227132018.1111094-1-arnd@kernel.org>
 <275033e5-d3fe-400a-9e53-de1286adb107@gmail.com>
Subject: Re: [PATCH] io_uring/net: fix build warning for !CONFIG_COMPAT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Feb 27, 2025, at 14:49, Pavel Begunkov wrote:
> On 2/27/25 13:20, Arnd Bergmann wrote:
>>        |                      ^~~
>> 
>> Since io_is_compat() turns into a compile-time 'false', the #ifdef
>> here is completely unnecessary, and removing it avoids the warning.
>
> I don't think __get_compat_msghdr() and other helpers are
> compiled for !COMPAT.

They are not defined without CONFIG_COMPAT. My point in the
message is that io_is_compat() turning into a compile-time
'false' value means that they also don't get called, because
compilers are really good at this type of dead code elimination.

> I'd just silence it like:
>
> if (io_is_compat(req->ctx)) {
> 	ret = -EFAULT;
> #ifdef CONFIG_COMPAT
> 	...
> #endif CONFIG_COMPAT
> }

That seems even less readable. If you want to be explicit
about it, you could use

     if (IS_ENABLED(CONFIG_COMPAT) && io_is_compat(req->ctx)) {

to replace the #ifdef, but as I wrote in the patch
description, the compile-time check is really redundant
because io_is_compat() is meant to do exactly that.

       Arnd

