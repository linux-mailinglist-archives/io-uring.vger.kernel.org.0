Return-Path: <io-uring+bounces-4966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 171B79D5818
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 03:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFE392829A2
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 02:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3EB70824;
	Fri, 22 Nov 2024 02:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="b3Irpy9C"
X-Original-To: io-uring@vger.kernel.org
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCBB4C6C;
	Fri, 22 Nov 2024 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732241514; cv=none; b=hy+3cc+cRA+GMA9FWEXnResb9N3xlnsdbSpOxUyPQ8Dme9mKjEoDL3ElJyxgqmviuHqgv1/k6NJKpoxAEqjnU1IKH4DR6cRcv5hzTcRizueasS6GyG8nNpVn6zR9d89yS5NUwojcICHkiBWS7t7ap8vDgMngt4gY0Ut4WxnCpnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732241514; c=relaxed/simple;
	bh=Dj6Cd3CPk5BDqSn9Sgb4JB+T8BZAB7Elrl8desRceeE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cKAWcp+uNiwCQrc5ISlegoF7EbKm61AK05oBwcYuaKJ+3ZzjR2w6xpxQe5r4lkri5oagZT13C3AJxjZbIrUwDKxHKmKuS2N5uxLn8HbLtLO+rKcW5sc4ELKemh+bOtDbMytCEAzgWQGrN/+o3XgEmSogvZkN4ZYYk2ZxVJnWQIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=b3Irpy9C; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id DA08D1D4055F;
	Thu, 21 Nov 2024 21:11:49 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 21 Nov 2024 21:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1732241509; x=1732248709; bh=HylobLOw4ozA3ZsgMN3A1CJKTLhCugUmrHO
	t6P6eI6M=; b=b3Irpy9CN1X7xtDjGC5aWAUtKCfwXUFdgndUfSfSaowMMhKH5HT
	q4Xga4uB+cvQU+bZM5/HwJ4ytBCklJRgQVwU6mGeVWhVL7ea6JVdZ7uiwNPUaH3S
	wi0Do0tWSJAYrSNcvdlFLYWfuOHSWwW3qdBPGLeiUePeYsWfgEkWwBX+pfSBwe+5
	agGbCGwWa4uN+vw7Ln9OQsgcCeJEPI4EQqYqJbGuvmm/XzN4qyPRTG7OpgbJdtkQ
	Px/y3VVjUEXHRTUH7yZUxEgBWGE/0YkKKWP0KOgWtc0yudPXRRyfvoy7YcvChGOV
	UHrrSZOOQutg8v0Pluj9+CHyE3BiJAfFTYA==
X-ME-Sender: <xms:Y-g_Z09Sylq-iCp6aQygX3VU2_kR78pMh37D3a1BDsuVoJxkCWx96w>
    <xme:Y-g_Z8sh4hgcLP3UGF8Yi9fW_8_PFABu4tAarOmmBQIv45p6mZws-BkgC45KCQhWh
    CC3uWw2CHSNrovYBpQ>
X-ME-Received: <xmr:Y-g_Z6AdKesLb87FO3lX1YrQ8oNSqX1wZPkds9Hzt73I_xZphv1wWvu0iSktjMg73RDUs-3-rcmXizUZX4iMaeV2PfEBcLLVIDY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrfeejgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpeffhffvvefujgfkfhggtgesthdtredttddtvdenucfh
    rhhomhephfhinhhnucfvhhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdroh
    hrgheqnecuggftrfgrthhtvghrnhepleeuheelheekgfeuvedtveetjeekhfffkeefffff
    tdfgjeevkeegfedvueehueelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepfhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghr
    tghpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehglhgruhgsih
    htiiesphhhhihsihhkrdhfuhdqsggvrhhlihhnrdguvgdprhgtphhtthhopehgvggvrhht
    sehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopegtlheslhhinhhugidrtghomh
    dprhgtphhtthhopehpvghnsggvrhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehr
    ihgvnhhtjhgvshesghhoohhglhgvrdgtohhmpdhrtghpthhtohepihgrmhhjohhonhhsoh
    hordhkihhmsehlghgvrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprh
    gtphhtthhopehrohhmrghnrdhguhhshhgthhhinheslhhinhhugidruggvvh
X-ME-Proxy: <xmx:Y-g_Z0fJgmUY4zg6tAwmozTZioO5XE7ZJl_gwZOC25Oa7u0SmdkZkg>
    <xmx:Y-g_Z5NBPRUn9dEOPinJAYv-jCvHNVIOwrZ0WzGbdfqVA02FOAQ3lQ>
    <xmx:Y-g_Z-mZaYKM6zfhiJbbxvlI1SIhjYJk5t6pF8FPo6Eg-sSiHzP_ng>
    <xmx:Y-g_Z7tvp8oiWAEOuUkRSLnBOjorHTxj93-7BfRDsji_aTt95NdQyA>
    <xmx:Zeg_Z2yeix9dyhXM0QLXKNKwYB8fZ-ksrwGAEHbOLoIBI8fZbmRDZ4Fj>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Nov 2024 21:11:45 -0500 (EST)
Date: Fri, 22 Nov 2024 13:12:15 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
    Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
    David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
    Pavel Begunkov <asml.silence@gmail.com>, Mike@rox.of.borg, 
    Rapoport@rox.of.borg, Christian Brauner <brauner@kernel.org>, 
    Guenter Roeck <linux@roeck-us.net>, Kees Cook <keescook@chromium.org>, 
    Jann Horn <jannh@google.com>, linux-mm@kvack.org, io-uring@vger.kernel.org, 
    linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
In-Reply-To: <d0d818bb9635d43bde2331864733504f6f7a3635.camel@physik.fu-berlin.de>
Message-ID: <dcf5f09a-6c68-4391-2b88-cceac7ff462f@linux-m68k.org>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org> <d0d818bb9635d43bde2331864733504f6f7a3635.camel@physik.fu-berlin.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thu, 21 Nov 2024, John Paul Adrian Glaubitz wrote:

> On Wed, 2024-11-20 at 13:46 +0100, Geert Uytterhoeven wrote:
> > On m68k, where the minimum alignment of unsigned long is 2 bytes:
> 
> Well, well, well, my old friend strikes again ;-).
> 
> These will always come up until we fix the alignment issue on m68k.
> 

Hmmm. That patch you're replying too. Does it make the kernel source code 
better or worse?

