Return-Path: <io-uring+bounces-8453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E88AE51BB
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 23:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40008442788
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 21:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B4E221FCC;
	Mon, 23 Jun 2025 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="nC7nBa7N";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dpYGdihb"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C06136;
	Mon, 23 Jun 2025 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714617; cv=none; b=UjcaeLmjYsZev1pih2KJ815NB3UF1h0WtSlxqvNrR1uGGqCw6EedAgpK8+KhJHSQ9BCoOzGMMyM0ah+VuxRL4DVxDOi0wn+3MaLhAl8oVhVSztKy3t9Tz3k96M3vByRVte/5UUTu8q586M6qDwckxx6F1WsuoWfsqoulEEPhxLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714617; c=relaxed/simple;
	bh=SCn1Yx2GJkVpjOpv/4QEPjgM9kYQui+0rL7plOJZwiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLHrYdcYF/NtfTkDEUiC0s+RhP1/bGhtmw/au0+lOZYTOjsSlBozPZFgLADqjWoujSjzp9tffru/RfL4ncjCmMYY86T6i86uXq7htl6Rkg/V0/tgfQEOmevFu3tL5aPRDELz01S+V92kLpXXRZoH1H0EmgQDz1Pj4eDf1Y8X3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=nC7nBa7N; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dpYGdihb; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id F2A1F1D0006C;
	Mon, 23 Jun 2025 17:36:52 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 23 Jun 2025 17:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1750714612;
	 x=1750801012; bh=1O5oTAsfQtJqqg2dLOQIjX/38obNeA6p5ZjB+E45Xr0=; b=
	nC7nBa7NytWBA0YuhznDUxw9NFNIwr/XlAjC03YeREIRMFeuQevMQG/kBCP75o4f
	H1bJxSotFFlpE6WYgNjuRIs/S7N9D56IKcYhHCfTZR6H14pV2sSBnWqBaqSv2j2x
	qdEKrTXcJLOMepOaLES0tMw1YkrP2sN3UqOpwcEASrYCCpiTx0WCbzrCAP/uT5nb
	WoL+OKNbnf6FYNq92o8+J/9LKBXsDoBrXU34pkNu9zRB5Er+VZldoSQg3J7/MfFJ
	3yd0K9Ku9q+QrQWXd0CpGkusS9RGYsA+p+YuHY2498FDwjZXhlJsUb3JanCPRu/1
	5QFQL48/wY9bXZQJ5SoHIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1750714612; x=
	1750801012; bh=1O5oTAsfQtJqqg2dLOQIjX/38obNeA6p5ZjB+E45Xr0=; b=d
	pYGdihbxd7De67dYbuEoKn/910NeBTV1zsUfnPPd0Xh4qEXsrGFL1sedTQscZIQM
	nlzVP7y8sAYbh+CL984vzXEHA9zC9rdORCbTwfgBCalfdQD6R6QTfVNEK9chgnQ1
	KKyjb5WxJWOSWtOPKx92mwhhhqAXKXAbux0sRq5SWfzqNDM3WDdqdDGJoO+a4ISd
	BbcxeDgJVMYrShDBrAboQMBaihcH3Fi8o7Nw8EdkHCXlUdE3EA1aXJX6q2Zd1ZZq
	DELuPxm3q+aPyxSxmihAMiBOZ8G+ANKDMch2Wby1lCyLkL/qneHQbjs9VvbHT0b3
	P5erXr4ZAqbZJ1IQl2CgQ==
X-ME-Sender: <xms:88hZaM7B-7Nhc9-IsdT-P23diQU16q5iohoso8hTOCMcy0q1CmXjeA>
    <xme:88hZaN60LmjiG9BCInb9CRoFmVuQI5E3q9VhXoyErInmjBs5yxHCFzu8nutWoTIhR
    le2kOU2GEeQ5r-h>
X-ME-Received: <xmr:88hZaLfOaoqyYmMnQyyVwS4HngPeGxEr6dlA0rW10h-5v9aMECsMR18hY2HJr7lW58cDztOO4ywZwljmiZIAcjgigQgcAuSiEBvgmfFLcFkYJvmr1a43>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddvgddukeduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertd
    dtvdejnecuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgs
    vghrnhgurdgtohhmqeenucggtffrrghtthgvrhhnpeehhfejueejleehtdehteefvdfgtd
    elffeuudejhfehgedufedvhfehueevudeugeenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsg
    gprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepgihirgho
    sghinhhgrdhlihesshgrmhhsuhhnghdrtghomhdprhgtphhtthhopegsshgthhhusggvrh
    htseguughnrdgtohhmpdhrtghpthhtohepkhgsuhhstghhsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtthhopegrsh
    hmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopegrgigsohgvsehk
    vghrnhgvlhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhm
    pdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:88hZaBLayWyQbdvW8uE6G7H4cdze94u7P-baXDliNdJuURhFniC7rA>
    <xmx:88hZaALKuYzA5g6k6lpjTmv2_zKONMdZ8r6Nc_sEv7793Y4ljoWsIQ>
    <xmx:88hZaCxrV02JAh5mNojpewvG_f_w4Y0Lh2PbGHd1zsl9QJ0Oo2ZoEQ>
    <xmx:88hZaEK7r9-K7SLrVnSg9oQBceyr4LKG0ULR3L0yMT60hQPslgnKCw>
    <xmx:9MhZaKNtJ_KjHMA9v-WDweRIeeonGmOr7NE3tOMWFatNm1wmxINQEvCO>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Jun 2025 17:36:48 -0400 (EDT)
Message-ID: <7f7f843e-f1ad-4c1c-ad4b-00063b1b6624@bsbernd.com>
Date: Mon, 23 Jun 2025 23:36:47 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
To: "xiaobing.li" <xiaobing.li@samsung.com>, bschubert@ddn.com,
 kbusch@kernel.org
Cc: amir73il@gmail.com, asml.silence@gmail.com, axboe@kernel.dk,
 io-uring@vger.kernel.org, joannelkoong@gmail.com, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, tom.leiming@gmail.com,
 dw@davidwei.uk, kun.dou@samsung.com, peiwei.li@samsung.com,
 xue01.he@samsung.com, cliang01.li@samsung.com, joshi.k@samsung.com
References: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
 <CGME20250620014432epcas5p30841af52f56e49e557caef01f9e29e52@epcas5p3.samsung.com>
 <20250620013948.901965-1-xiaobing.li@samsung.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20250620013948.901965-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/20/25 03:39, xiaobing.li wrote:
> On Wed, Jun 18, 2025 at 09:30:51PM -0600, Keith Busch wrote:
>> On Wed, Jun 18, 2025 at 03:13:41PM +0200, Bernd Schubert wrote:
>>> On 6/18/25 12:54, xiaobing.li wrote:
>>>>
>>>> Hi Bernd,
>>>>
>>>> Do you have any plans to add zero copy solution? We are interested in
>>>> FUSE's zero copy solution and conducting research in code.
>>>> If you have no plans in this regard for the time being, we intend to
>>>>  submit our solution.
>>>
>>> Hi Xiobing,
>>>
>>> Keith (add to CC) did some work for that in ublk and also planned to
>>> work on that for fuse (or a colleague). Maybe Keith could
>>> give an update.
>>
>> I was initially asked to implement a similar solution that ublk uses for
>> zero-copy, but the requirements changed such that it won't work. The
>> ublk server can't directly access the zero-copy buffers. It can only
>> indirectly refer to it with an io_ring registered buffer index, which is
>> fine my ublk use case, but the fuse server that I was trying to
>> enable does in fact need to directly access that data.
>>
>> My colleauge had been working a solution, but it required shared memory
>> between the application and the fuse server, and therefore cooperation
>> between them, which is rather limiting. It's still on his to-do list,
>> but I don't think it's a high priority at the moment. If you have
>> something in the works, please feel free to share it when you're ready,
>> and I would be interested to review.
> 
> Hi Bernd and Keith,
> 
> In fact, our current idea is to implement a similar solution that ublk uses 
> for zero-copy. If this can really further improve the performance of FUSE, 
> then I think it is worth trying.
> By the way, if it is convenient, could you tell me what was the original 
> motivation for adding io_uring, or why you want to improve the performance 
> of FUSE and what you want to apply it to?

At DDN we have mainly a network file system using fuse - the faster it
runs the better. But we need access to the data for erasure,
compression, etc. Zero-copy would be great, but I think it is
unrealistic that application would change their API just for fuse to get
the coorporating model that David suggests (at least in our case).


Thanks,
Bernd

