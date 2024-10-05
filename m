Return-Path: <io-uring+bounces-3428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D5799138B
	for <lists+io-uring@lfdr.de>; Sat,  5 Oct 2024 02:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43ED01F2375A
	for <lists+io-uring@lfdr.de>; Sat,  5 Oct 2024 00:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2693322B;
	Sat,  5 Oct 2024 00:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="FLcE3F+I";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="g2n7d9H5"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C529CA;
	Sat,  5 Oct 2024 00:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728088753; cv=none; b=c71/mPDmgeD5ZBue3k9Hs2yWoQSQMAgW+h553UdtfUM0O4/C/GLcyOm80buEu9++GODyPOtvl4+p0EDiChpMQaB/tBqWt1giV3mdbgILRpAJxfaOFt7tPN4sq/petq8IifNw/OM9sdFgCrrMhzLXyN8R4DK2Iy4hbDfv6QJox4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728088753; c=relaxed/simple;
	bh=t4ox1moCdNVjEYfw/SHgaraLE+A3E0RXcZOmdLZSsiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qK2q22u1M0KM4LuAXdTFUrStw+dc2mTqsPsa+qWVK3CsEaopvLMkJRU4flTY29qIPCBDcBex4B6AEv8/KC+ev5fDXDUrAddKg77XAzDhPJn2C0vAwdTITxba0vZHImgW2MkjPozsWv7kg5xTbiP0PLTV/kjeu0c2PizVM2YOVo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de; spf=pass smtp.mailfrom=anarazel.de; dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b=FLcE3F+I; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=g2n7d9H5; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anarazel.de
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 24A5C13805E2;
	Fri,  4 Oct 2024 20:39:10 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 04 Oct 2024 20:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1728088750; x=1728175150; bh=lL/jeDhQ0T
	2sVRGSKsBanrFa3Wo3OgPVAPdrzYDOaZU=; b=FLcE3F+I3TrTMVjYyDkHVlZ1n5
	vEYCC2QDkMDZBebW5oFYwMAtAmdxjAmVqLtqznvEI/8GNJOmak+0ZVMGWrOwLxlM
	ffJADAQQwmGH0tgBhirF0Ksvh+q0WWflOO7BJF6cnG3ggxzTUC2Ejo62LwuX4Ik4
	WhI+wpukN2w/MbDJANbSnopVgn/UDBsSQkfRKGiib+BCKJ4w0QWgBlWhaDZE1UVf
	/ATcabESghztfA8cGEs8tfCeFC6E3p2NwGluTm6rl8tbIPRKn0Hslb7CoLTllViM
	HApgSgN60haygR/zKM0BWUdSCGRq5KcCsZG0Cjrf1wyQNEvr7PoSaSHTcbpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728088750; x=1728175150; bh=lL/jeDhQ0T2sVRGSKsBanrFa3Wo3
	OgPVAPdrzYDOaZU=; b=g2n7d9H5qF2VLDZmYmKun1q1hn/Iu9i8re2x4x0PKc2R
	wvD3XeYKzspl/qLzJNWZ7aKQSqqIINW05/ukUfG//Qh6fG9sPTsHKHzos0T9+A+z
	v3ZXjMWq93ywpOvqs8IS62Np/dw2o0ZbxgdE7CHiHbhenXjRQ2OPgNF1GMlYFTW0
	3ELaPnT6J5l0cAWDHp0Gr1Hgm5QiKY0egi3VQSUf7ykoyQnSmUPF/YKAYmkHsBuq
	cUCExSWZ3BF4XrSjnWkXFS7y2K/YITFzTXtK8uchNmIF21P8Gahv1eiqvY0e7SZJ
	r/kxjh7N01iHSeV2ar/wMqX9TS5YgNGz6PFQZzdwXA==
X-ME-Sender: <xms:rYoAZ_3FW5MbKjgL9PdOD64TaYWoBmrlMrm4YFuySfkOn1GogX8nOg>
    <xme:rYoAZ-G2JmWxFA0ua5DzEbmEyBJcUXETtyL2Jm2bf8iY7il5o1440cCQ81zqj3cUC
    _8NA9HBUVcBLnTFYg>
X-ME-Received: <xmr:rYoAZ_5blobP6qtwk42B_OtikgmWS8lMc-jJ3xg8IWRMvWReOCbKikyIfXfVxUBTghnGE_VQ7zXNDVRla45iHAgnjZz2x2d2Qzzvz_1TSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvgedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomheptehnughrvghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivg
    hlrdguvgeqnecuggftrfgrthhtvghrnhepfeffgfelvdffgedtveelgfdtgefghfdvkefg
    geetieevjeekteduleevjefhueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggvpdhnsggprhgt
    phhtthhopedvuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghvrghnrghssh
    gthhgvsegrtghmrdhorhhgpdhrtghpthhtoheptghhrhhishhtihgrnhdrlhhovghhlhgv
    segrrhhmrdgtohhmpdhrtghpthhtohepughivghtmhgrrhdrvghgghgvmhgrnhhnsegrrh
    hmrdgtohhmpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhm
    pdhrtghpthhtohepqhhpvghrrhgvthesghhoohhglhgvrdgtohhmpdhrtghpthhtohepph
    gvthgvrhiisehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheprggurhhirghnrdhh
    uhhnthgvrhesihhnthgvlhdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlh
    drughkpdhrtghpthhtoheprhgrfhgrvghlsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:rYoAZ03Ltrv3p59gBHhTY4FxT2sSl3xMzXIVBbfA1nRXa7W5Hfdvsg>
    <xmx:rYoAZyGCu5QE_Ho3nDlpzGWyENASseovlZ7ERK4hpLfr14tBGW66gQ>
    <xmx:rYoAZ1-qEuCjBO4ER8GUjAGBb9sRHoG8Wp4HaUK_qr3aqLh6gI-HZg>
    <xmx:rYoAZ_l1NRE4Y4W15VPejdSx8vmeCVzmapLq_40PO5TOaYfZjilf1A>
    <xmx:rooAZ2MgYa13qAD6m7jbaRPID47t20DOaN6SylC6RlOOm9xFY3AcQ58x>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Oct 2024 20:39:09 -0400 (EDT)
Date: Fri, 4 Oct 2024 20:39:09 -0400
From: Andres Freund <andres@anarazel.de>
To: Christian Loehle <christian.loehle@arm.com>
Cc: Quentin Perret <qperret@google.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com, 
	dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org, 
	Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org, 
	bvanassche@acm.org, asml.silence@gmail.com, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org, qyousef@layalina.io, dsmythies@telus.net, axboe@kernel.dk
Subject: Re: [RFC PATCH 5/8] cpufreq/schedutil: Remove iowait boost
Message-ID: <io3xcj5vpqbkojoktbp3fuuj77gqqkf2v3gg62i4aep4ps36dc@we2zwwp5hsyt>
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-6-christian.loehle@arm.com>
 <CAJZ5v0hJWwsErT193i394bHOczvCQwU_5AVVTJ1oKDe7kTW82g@mail.gmail.com>
 <Zv5oTvxPsiTWCJIo@google.com>
 <6e21e8f1-e3b4-4915-87cc-6ce77f54cc8a@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e21e8f1-e3b4-4915-87cc-6ce77f54cc8a@arm.com>

Hi,


A caveat: I'm a userspace developer that occasionally strays into kernel land
(see e.g. the io_uring iowait thing). So I'm likely to get some kernel side
things wrong.


On 2024-10-03 11:30:52 +0100, Christian Loehle wrote:
> These are the main issues with transforming the existing mechanism into
> a per-task attribute.
> Almost unsolvable is: Does reducing "iowait pressure" (be it per-task or per-rq)
> actually improve throughput even (assuming for now that this throughput is
> something we care about, I'm sure you know that isn't always the case, e.g.
> background tasks). With MCQ devices and some reasonable IO workload that is
> IO-bound our iowait boosting is often just boosting CPU frequency (which uses
> power obviously) to queue in yet another request for a device which has essentially
> endless pending requests. If pending request N+1 arrives x usecs earlier or
> later at the device then makes no difference in IO throughput.

That's sometimes true, but definitely not all the time? There are plenty
workloads with low-queue-depth style IO. Which often are also rather latency
sensitive.

E.g. the device a database journal resides on will typically have a low queue
depth. It's extremely common in OLTPish workloads to be bound by the latency
of journal flushes. If, after the journal flush completes, the CPU is clocked
low and takes a while to wake up, you'll see substantially worse performance.




> If boosting would improve e.g. IOPS (of that device) is something the block layer
> (with a lot of added infrastructure, but at least in theory it would know what
> device we're iowaiting on, unlike the scheduler) could tell us about. If that is
> actually useful for user experience (i.e. worth the power) only userspace can decide
> (and then we're back at uclamp_min anyway).

I think there are many cases where userspace won't realistically be able to do
anything about that.

For one, just because, for some workload, a too deep idle state is bad during
IO, doesn't mean userspace won't ever want to clock down. And it's probably
going to be too expensive to change any attributes around idle states for
individual IOs.

Are there actually any non-privileged APIs around this that userspace *could*
even change? I'd not consider moving to busy-polling based APIs a realistic
alternative.


For many workloads cpuidle is way too aggressive dropping into lower states
*despite* iowait. But just disabling all lower idle states obviously has
undesirable energy usage implications. It surely is the answer for some
workloads, but I don't think it'd be good to promote it as the sole solution.


It's easy to under-estimate the real-world impact of a change like this. When
benchmarking we tend to see what kind of throughput we can get, by having N
clients hammering the server as fast as they can. But in the real world that's
pretty rare for anything latency sensitive to go full blast - rather there's a
rate of requests incoming and that the clients are sensitive to requests being
processed more slowly.


That's not to say that the current situation can't be improved - I've seen way
too many workloads where the only ways to get decent performance were one of:

- disable most idle states (via sysfs or /dev/cpu_dma_latency)
- just have busy loops when idling - doesn't work when doing synchronous
  syscalls that block though
- have some lower priority tasks scheduled that just burns CPU

I'm just worried that removing iowait will make this worse.

Greetings,

Andres Freund

