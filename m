Return-Path: <io-uring+bounces-2180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBCD905410
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84EE61C22D36
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 13:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DEA17DE25;
	Wed, 12 Jun 2024 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="PfdQ4BgC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ayM4U6eK"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh6-smtp.messagingengine.com (fhigh6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FBC17CA07;
	Wed, 12 Jun 2024 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718200006; cv=none; b=QD19wrwCRgPrsDJzSc9RIke845idrXNOj+cXgOUTOgHv5I9GJdrbgnJLV00Xwhm+U3UeqMBSHIUUzS+0Agn6CaWXgsj3Fqd+D9Jaz56E93BEqqd42Y+GTL+Ik6DavuUSTg9uXeq3+M851LshhvyUwP76HiTpeiy0CHLc1J4qAXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718200006; c=relaxed/simple;
	bh=xM2mkgCYXY3LW4Gkd+ntoO/HJ+6A/plCYS7Ibh5SWu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXzVqI384DDxuGFlzNbgPqow8BEyxGYLDsWUZ0jrPudIYbxygDLYLHnilEaW1R0SBWvYPHsI6u2yZTLrtRBX9tZ3ECHKy2qFVlrZqHO9xGLi1JgthHrxqp5oTJMUy5Lgz+CGStA2X6kQ3WLrErd7DSW4tWqhvVQkgeiwsihFzeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=PfdQ4BgC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ayM4U6eK; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 6F0111140150;
	Wed, 12 Jun 2024 09:46:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 Jun 2024 09:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1718200003;
	 x=1718286403; bh=9Gox+jN/71my3TOsF6ZDOvg8wmlhZO67uf48HwSqNWQ=; b=
	PfdQ4BgC+n1qUiSSGVFI2rgrHt28OBsKJcaSPLf5aMC4d+MSSmRMSEBbWZ5YyY5I
	8SkvO9KqdJSSO32O0OjzhCyPY3UG0PPYS90Jkj0kXpV+S5dzYPeWPkkYwOq2BTYa
	EhV0aHGWC/bcr52RyS1CqgfPNIGbBXTZOFtGPQzgMZT8JaHHGmD7SoZCJTQeWxBe
	+jpHScF73lQX1UGgMBGD424wdVBbFH2IvhJgSYDKK2HiPDdpFJpllLNKuoFu0rvY
	ctN7ojcdllsVjPmj9kai05uKW5bxOpbPjoUfWgjkth/WcbA4KgcXi7zm+QFcCd4o
	KklnSbBOauR1vcyUVES0yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1718200003; x=
	1718286403; bh=9Gox+jN/71my3TOsF6ZDOvg8wmlhZO67uf48HwSqNWQ=; b=a
	yM4U6eKarymhG+Spu+gnmFOG22w4gWtVsWcS+cf+6lkSNxY5QErHkxwty7ucgkLb
	b5zRYlmbuB+qdlw2jTtFBhgSB3TzdVLJD2pERY9s7xZWW0nFjK43B8SmXiiaeevB
	p2MlVqIYLik+3zZWAOMEI8H94tzz7O4Uc028b74H+UMQbclNUYwVtSCi3wnZQfrJ
	WxzQf/eq0DslTTEe6UO64T/MY3NhkOFeRBLFUtsVBOv6Ka/ZtYBWoV1wnEUQx3x9
	mR1dscUydEqNnb3s+JmtMqe7D/jAzcCsxAXgLMNoYVDnfQww/iXYhVxq4UC+W4Fl
	cn10tRkm/YnFIrivGF8Qw==
X-ME-Sender: <xms:wqZpZqGwUxiWUYLLhiu9iaSfxpmD0AqUevgmd4OjlSG7oDOSOU3sIw>
    <xme:wqZpZrX2tEbASKYc_Zaa9JIrIenbi9BldEYJVNPRwRQHAy8vSwvgC3ju4qzXi8bBy
    670FErpIubhl-4F>
X-ME-Received: <xmr:wqZpZkIB8AyIBXBiYujqxJzHVrdkcDBhKhawkb14c_PVHMzN6s_S0vhKG2jgNKUVLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfedugedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfgtdfggeelfedvheefieev
    jeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdr
    fhhm
X-ME-Proxy: <xmx:wqZpZkFBDc1bBVDorJ5bBj8njkAik0_6wuaB_zFvPWOJ-n32rigkBQ>
    <xmx:wqZpZgXzdPl7md2UpwSI9Jvt3-Egbh9Q6ipucKwGY3iw83Ns6fdmpQ>
    <xmx:wqZpZnOTpCjaq3gXpeWEicpjfS6SbnmJSInYMDj1rn-MUbomJK5bSA>
    <xmx:wqZpZn2rLUUp6vUImNy1uuZ5Jh_0tsINej7wZLKsbUurJI-i6Ha69w>
    <xmx:w6ZpZvNoosnWCu2UcXknQ6W27s7cPVMmMGS1Q24x6ySCUxsj4unU1Jfw>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Jun 2024 09:46:41 -0400 (EDT)
Message-ID: <1a5c214c-db14-42a4-8415-ab2c90a04917@fastmail.fm>
Date: Wed, 12 Jun 2024 15:46:40 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US
In-Reply-To: <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/12/24 15:32, Bernd Schubert wrote:
> On 6/12/24 09:39, Miklos Szeredi wrote:
>>> Personally I don't see anything twisted here, one just needs to
>>> understand that IORING_OP_URING_CMD was written for that reverse order.
>>
>> That's just my gut feeling.   fuse/dev_uring.c is 1233 in this RFC.
>> And that's just the queuing.
> 


Btw, counting lines, majority of that is not queuing and handling requests,
but setting up things, shutdown (start/stop is already almost half of the file)
and then and doing sanity checks, as in fuse_uring_get_verify_queue().

