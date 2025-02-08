Return-Path: <io-uring+bounces-6318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D71A2D260
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 01:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C25993A6C41
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 00:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F583D68;
	Sat,  8 Feb 2025 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="uRAVrVHF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nkj80CHT"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7F9EBE;
	Sat,  8 Feb 2025 00:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738975880; cv=none; b=ISjwtyVW8HAVN5cU1OV1IUiD6ath2mwK7EMtd4gcz4pJxDmsp6iw7GJYBAjw9rMOXKllUfj1bbdUXgbbF1fiUoWmip8GrVQ7/vMRnOTp3yldhw1bsCMz7lHmgpm6sJB3L51yT42MUHJdiaaB4NqQmXdijwVyc3HlEppzxuOKuR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738975880; c=relaxed/simple;
	bh=gjJNzpNM9ApoL9TyIvOqm3oRzhAyI9vLBK92oUmdw1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1EMS/tPaEC9bodEqD/rt75lTYgl5XWjPdEGduaimleuiw4am4p6sbdmft+oEQaKmbENPGcxkdDdjhTJdbztzuvK+OQS+tHSFkqsl2A7lvo8hfgWnp538Mu2B1TC3/XJfyn5I40CpNTIBEze9QJAYYGFaZ8k0TLLednBUdtNLso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=uRAVrVHF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nkj80CHT; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 607751140157;
	Fri,  7 Feb 2025 19:51:14 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 07 Feb 2025 19:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1738975874;
	 x=1739062274; bh=D8dWss3j45ZZkgJBmvb6coXG0YqDaF+50BBK7n5fYZo=; b=
	uRAVrVHF/yqIlc9dPMFvutcLROGpoCB/s/9ngaLBCMeiBGmoorqzTBSGdEVnr6SD
	V4V8f/hA158xrV3Ogv1xcTA2kh4FdlrIkxf21cfsQVHZIqiPJKAfPV7lp/O+uHgB
	l+in4K9d1JyFnkz2zr9zv5eno+xj4qCOiDFclTjrENUee+YdQ48AvFo0knSqVjmO
	jMFxUCPv77I7AVtb92NIxGXnnZ0ju5L8j9HHc38kKVzCNH579NDnsutrb3R+KqAF
	jzqBFOndcjchI6uBRF2rWGMlciEDPLrcBzzIpzxXh41E5bB7Rw6T785iPi+5YFcE
	GyKQ5WGtEOEoye9R3FxFCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1738975874; x=
	1739062274; bh=D8dWss3j45ZZkgJBmvb6coXG0YqDaF+50BBK7n5fYZo=; b=n
	kj80CHTk7V9tqLAF8Z4x+kCVi4PgjcfjKIK8H3QDuyCuPtgxtLMpIZjJn/3f9j9k
	7yJ9zvwsNSm/ycLMSZRDMGjZ5bex9iXrtt+LA0hJS7+TpA1ncnylsRrdbllV5lg1
	dq5TgKL83yR3jlxZtAWcytGL8wLIfsMagdtj9OUKcAhYx76ZSLqrS9u8+gaNMyt1
	xzDDp/Vm7fAbxsQ48tb2tU7/rUn3ZJ2jcPcCc76ukybACENbo3x1c9DE9SYawiCB
	0uufSOjADCy/usXxBZ0CKLEkDWI7JlxkAsquBGIQxVkVYa3EjiiNDidt2h+F4gMg
	9CDuyBJQ5eb6TAz80KOmQ==
X-ME-Sender: <xms:gaqmZ8KTntMhXzZtUQ742nXGyKMXzWaFNj9YLJyzE5zpgclAWcteaw>
    <xme:gaqmZ8JRE050-vWs2Uvycbir2GXEyNBffDAFDDcVm54zZ6g9lTHyeebcxG_1hfYvv
    5EfYn9iNag0Wl-d>
X-ME-Received: <xmr:gaqmZ8tz5ivXe857vgnR3CKSvuHfR6XgxTsZaluqPDYP2XEqMHpRg89KG1nTNKkimpIv2ao_8R5PRmJif6jU_uMP4TfMtJvXoL2vwOmaEZDTznexU8Lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdeftdejjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgsuhhstghhse
    hmvghtrgdrtghomhdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdgslhhotghksehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhhinhhgrdhlvghisehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsih
    hlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepkhgsuhhstghhsehkvghrnhgv
    lhdrohhrgh
X-ME-Proxy: <xmx:gaqmZ5YbL8swAomkkgRwv4Wx5mNXETxcAjZ7aRbM5FhRxn7m7K5x9Q>
    <xmx:gaqmZzZHY5Q9-W5ePFO3jPSsHMkD4nuduLiJKzAnlWWs8u0A5GMy4A>
    <xmx:gaqmZ1By7lq-lpxg6HDMOnqAnuWIpyZtkQMXP41gVu_pMTOfKEhmgw>
    <xmx:gaqmZ5YdmCaHSgIzgY8DSAGr9KA0ArjgZ-O5VkekYIsWtVJB6SfUIw>
    <xmx:gqqmZ37Q3Lfvaas9__S4vy302EHdMzmt7dYr42SY25aDgiI6Bd425ErZ>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Feb 2025 19:51:12 -0500 (EST)
Message-ID: <5f6f6798-8658-4676-8626-44ac6e9b66af@bsbernd.com>
Date: Sat, 8 Feb 2025 01:51:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] ublk zero-copy support
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk,
 asml.silence@gmail.com
Cc: Keith Busch <kbusch@kernel.org>
References: <20250203154517.937623-1-kbusch@meta.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20250203154517.937623-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Keith,

On 2/3/25 16:45, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This is a new look at supporting zero copy with ublk.

will try to look at it over the weekend. Could you please keep me in the
loop for future versions?


Thanks,
Bernd



