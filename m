Return-Path: <io-uring+bounces-1372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE15897128
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 15:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D1641C27965
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 13:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828B7146D65;
	Wed,  3 Apr 2024 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kkourt.io header.i=@kkourt.io header.b="kmlp5/pN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gJnFAYxt"
X-Original-To: io-uring@vger.kernel.org
Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8040148308
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712151132; cv=none; b=N117fA1zrDirz4/+JLVT1wL8f08hSGis3Ep66t6HD7hoPRqP3Sa5Q0kwh7+nFgrG8JegEHblYDq71x+A29SQTlxYiw2P+onL+M5h7tMpIs7seyZICWANYREu9FgbJs8fr8AuFfNW9tCynuUwSsWoSRyLuF1MABeGO4eWoGGhEkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712151132; c=relaxed/simple;
	bh=OOzsKNSeN+UtCJeodqy9vg1bD+Tk1QlFKsob2NwZ5as=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Wpic6BdNa9YDs/daEI6ejFxRIXc4O+wDytNrcnIM/wGcTSO8NskXmW0lmOE2MPBRIir8VlmgLKJOBWxjT5SiGHKxfctOQ32o/53WN6OSKKS0LhxM4YNUWR2ugUx55e7yplmUhoB87ribCcq+kbNc6QQ5S/6BXYEnrSbFBH7s4G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kkourt.io; spf=pass smtp.mailfrom=kkourt.io; dkim=pass (2048-bit key) header.d=kkourt.io header.i=@kkourt.io header.b=kmlp5/pN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gJnFAYxt; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kkourt.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kkourt.io
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailfout.nyi.internal (Postfix) with ESMTP id BC61F13800FB;
	Wed,  3 Apr 2024 09:32:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 03 Apr 2024 09:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kkourt.io; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm2;
	 t=1712151128; x=1712237528; bh=eAAGDtLpNk5ZrtoVruCLmCNNamwLDd62
	si7DPz6B19w=; b=kmlp5/pN9wGT1yhZC1I+r0jzGrIIbvsHVuE1KLOHuPwMQYmn
	O8hRFXwM2oFniZRyt6hc2SZtmPM4PWDlt0J4Apoimmw3SFnBIxQfmrbe25btla/u
	aP7TLNvMuo4th1ZHO9G0/LXlnCQOq9uOyDHweeKgHEfESR8a5uUxIvDX/JNg94Nb
	asg6aKeV0fW3XT7kHk3xYpWCGG/nqaEhXHgYmkHZtbgo/eIneQvt0AqjKL9NKIIH
	VZzFENb8IN7YHNbgSJ0PWDbz78Qs8qEyP7iAKdhNR0H6cuKJukbaCiIsneErqbvP
	Sl6kLnrkDqYNE0Gj9bRgwMLjLUCNIequv9leGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1712151128; x=1712237528; bh=eAAGDtLpNk5ZrtoVruCLmCNNamwLDd62si7
	DPz6B19w=; b=gJnFAYxtdZDoqpi+WH8NjpwkMrKIonCeLoSC+nmcwFfd9Ozpr04
	wLGMmVWjUsErbAsB+cejS3QmvQpxGnauZRdYE2vJfkrtMjB1vlw7IpRJjph72Nen
	2jSDgZ0O3p98XTMFeQx5VzYo136EGg1Q60MeMpoW4CAz46ENrt9/A+Qp/jxnusBR
	vp1XaXPZjsbxxAg1Cxt7GdNcNfc+1YJ+qROjCfYSJSfgEsJn5TKWobC+gWQ4hpo4
	1gKOlVYCR2fXA0daFJ2uCOAz0MrO0Su8YoVuWdx4ATes59JKlg9FqGKtN5r08etQ
	pKM0qP9qppOXKgQzYWrlzwyCyZsKN0bAEBQ==
X-ME-Sender: <xms:WFoNZu0VE3G5waXnMHYIIGlG6hHpw_ptUgu97JjCMw8Mcg_QmpNv6w>
    <xme:WFoNZhFgRU_yPUscBYogBSdvMeqdWM6v0AuzSHYzSbwxyuIUQ9W55uQ2YPieySq3A
    R6OtW50J1fe_hffNw>
X-ME-Received: <xmr:WFoNZm6F5VniGkJxMdDCN0xrf4ySQ5d3cJYKQ2Rvmj1kl29H_oRHPemuT387DH75e0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefiedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkgggtugesthdttddttddtvdenucfhrhhomhepmfhorhhnihhl
    ihhoshcumfhouhhrthhishcuoehkkhhouhhrtheskhhkohhurhhtrdhioheqnecuggftrf
    grthhtvghrnhepvdelkefhueejffejgfdtiedthefgleffhfdvuefhvdekudeuudegkeei
    ueevtdevnecuffhomhgrihhnpehkkhhouhhrthdrihhonecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhkohhurhhtsehkkhhouhhrthdrihho
X-ME-Proxy: <xmx:WFoNZv0P5ia6vU-45IVvYXLe9j3fsm_CmCMQoDjI-mQwHvFEfuu-Pw>
    <xmx:WFoNZhHh0aHZIoQKYP1fRusfsOx5tyJc_bWOI1TwIIQeg7VZb3fV-g>
    <xmx:WFoNZo-2JDG6gEKywnmoQdCuWvIQw0SOQEwDeBjjWveaZn4ZlrZXSA>
    <xmx:WFoNZmnGF6l-ZD2BfnUu-3ABDdgwY8HE-4QuLKkJH_bsmZNjl3T7sg>
    <xmx:WFoNZlhZasmjPqyatvSz42F7IQ9A_xTMPyFzHaMClD_7rtfpDrSzGQ5i>
Feedback-ID: i890b436b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Apr 2024 09:32:08 -0400 (EDT)
Received: by tinh.kkourt.io (Postfix, from userid 1000)
	id 8E9732540AE2; Wed, 03 Apr 2024 15:32:05 +0200 (CEST)
Date: Wed, 3 Apr 2024 15:32:05 +0200
From: Kornilios Kourtis <kkourt@kkourt.io>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: registering files returns -EBADF in 5.10.214
Message-ID: <Zg1aVQVgBO3Rw0_4@tinh.kkourt.io>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

In 5.10.214, registering files seems to return -EBADF

Running the file-register test from (latest) liburing:

 liburing/test# uname -r
 5.10.214
 liburing/test# ./file-register.t
 test_basic: register -9
 test_basic failed

The test seems to work in 5.10.211:

 liburing/test# uname -r
 5.10.211
 liburing/test# ./file-register.t
 file alloc ranges are not supported, skip


Best,
Kornilios.

-- 
https://kkourt.io/

