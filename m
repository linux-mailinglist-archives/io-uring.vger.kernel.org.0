Return-Path: <io-uring+bounces-3347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 130E498C097
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 16:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B1BC1F2218C
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 14:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E263E1C9B97;
	Tue,  1 Oct 2024 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MI4mTUNa"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2344C1C9B82;
	Tue,  1 Oct 2024 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727794003; cv=none; b=l8RRTCqNONJdBdYajalFtvWxkeG64YrhFcrKbOVL28/EJTABWOekiCUOAoIoqOJhnfffSP1twKkU/CV0bNHVE5N+8o1t2d9n5p9zN7Mx6Wg3XHtsIOx+VuYH6IqWHzZPLUgcifUwCmede7hfG2oGOLSPnM/C4tZpMYD35FcWMB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727794003; c=relaxed/simple;
	bh=qeu2p0M191IZpPsImbZWXrJj32UkejC5lQR1EYkKbAo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GcEPRwbXu0zqqLC9zjCnFn7yr8J99NZJTyDzZ/jYxnEt1hMvlOkeJTz30bPgfws+/8FS/DGQwIhJKxdSFDWypvsGGdKjlRGoFG0+uCem0wTFpOtz+EO0v2KjDoKSvCjt/rAbZm7oEoB3Jq0wlyLo9/qaMSWu7YFnRox3wE50Zr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MI4mTUNa; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727794002; x=1759330002;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=qeu2p0M191IZpPsImbZWXrJj32UkejC5lQR1EYkKbAo=;
  b=MI4mTUNaO95HgBmSiueZkjA/0CnfJcZ766+aPCBRvSjBwIwlgrFNdmea
   ybyHhsWOQ/Q/zsraoH3McIU64pVChUCaydOReKqCaYo3oTYI2ZTgsfQWm
   Jp6xijsLMb2KGBL0y/rbIrFmGnV1PX3kb7Yu2HhrqRfEeUWpePZXzEbxV
   G3kwCI2XuzPljZ0zcNuYS7G/HVdkikIpDm07Vch61c/4nAIQ2TrLlvsZM
   mnBxXgQ0B8yo2KMJGpYCY2X4MMnYiQ5jJKyGkfjBJxPGE3F3W7/k2GEgM
   xYhGXphYr09f5AJ2ZQRXrkYgL4jmyArtXKqScd0+AdVcfIx4QPpGboFRO
   A==;
X-CSE-ConnectionGUID: qPf19ojMRv2jdEFGqmCBFA==
X-CSE-MsgGUID: 76ccR8GaTn6N8qlNq9LwCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11212"; a="26435938"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="26435938"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 07:46:41 -0700
X-CSE-ConnectionGUID: Y4Yhc432QH2y9kMfwC2UMQ==
X-CSE-MsgGUID: 72gVyCxAS0OmaDCKq/Gi7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="73358083"
Received: from spandruv-desk1.amr.corp.intel.com ([10.125.108.208])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 07:46:40 -0700
Message-ID: <95b31cafb584c055bf303dc79ed7c389538d29c5.camel@linux.intel.com>
Subject: Re: [RFC PATCH 6/8] cpufreq: intel_pstate: Remove iowait boost
From: srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To: Christian Loehle <christian.loehle@arm.com>, "Rafael J. Wysocki"
	 <rafael@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com, 
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org, 
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com,
 ulf.hansson@linaro.org,  bvanassche@acm.org, andres@anarazel.de,
 asml.silence@gmail.com,  linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, qyousef@layalina.io,  dsmythies@telus.net,
 axboe@kernel.dk
Date: Tue, 01 Oct 2024 07:46:40 -0700
In-Reply-To: <fa623b5e-721a-47fd-84c8-1088d9a6a24a@arm.com>
References: <20240905092645.2885200-1-christian.loehle@arm.com>
	 <20240905092645.2885200-7-christian.loehle@arm.com>
	 <CAJZ5v0i3ULQ-Mzu=6yzo4whnWne0g1sxcgPL_u828Jyy1Qu1Zg@mail.gmail.com>
	 <0a0186cad5a9254027d0ac6a7f39e39f5473665c.camel@linux.intel.com>
	 <fa623b5e-721a-47fd-84c8-1088d9a6a24a@arm.com>
Autocrypt: addr=srinivas.pandruvada@linux.intel.com; prefer-encrypt=mutual;
 keydata=mQGNBGYHNAsBDAC7tv5u9cIsSDvdgBBEDG0/a/nTaC1GXOx5MFNEDL0LWia2p8Asl7igx
 YrB68fyfPNLSIgtCmps0EbRUkPtoN5/HTbAEZeJUTL8Xdoe6sTywf8/6/DMheEUzprE4Qyjt0HheW
 y1JGvdOA0f1lkxCnPXeiiDY4FUqQHr3U6X4FPqfrfGlrMmGvntpKzOTutlQl8eSAprtgZ+zm0Jiwq
 NSiSBOt2SlbkGu9bBYx7mTsrGv+x7x4Ca6/BO9o5dIvwJOcfK/cXC/yxEkr1ajbIUYZFEzQyZQXrT
 GUGn8j3/cXQgVvMYxrh3pGCq9Q0Q6PAwQYhm97ipXa86GcTpP5B2ip9xclPtDW99sihiL8euTWRfS
 TUsEI+1YzCyz5DU32w3WiXr3ITicaMV090tMg9phIZsjfFbnR8hY03n0kRNWWFXi/ch2MsZCCqXIB
 oY/SruNH9Y6mnFKW8HSH762C7On8GXBYJzH6giLGeSsbvis2ZmV/r+LmswwZ6ACcOKLlvvIukAEQE
 AAbQ5U3Jpbml2YXMgUGFuZHJ1dmFkYSA8c3Jpbml2YXMucGFuZHJ1dmFkYUBsaW51eC5pbnRlbC5j
 b20+iQHRBBMBCAA7FiEEdki2SeUi0wlk2xcjOqtdDMJyisMFAmYHNAsCGwMFCwkIBwICIgIGFQoJC
 AsCBBYCAwECHgcCF4AACgkQOqtdDMJyisMobAv+LLYUSKNuWhRN3wS7WocRPCi3tWeBml+qivCwyv
 oZbmE2LcxYFnkcj6YNoS4N1CHJCr7vwefWTzoKTTDYqz3Ma0D0SbR1p/dH0nDgN34y41HpIHf0tx0
 UxGMgOWJAInq3A7/mNkoLQQ3D5siG39X3bh9Ecg0LhMpYwP/AYsd8X1ypCWgo8SE0J/6XX/HXop2a
 ivimve15VklMhyuu2dNWDIyF2cWz6urHV4jmxT/wUGBdq5j87vrJhLXeosueRjGJb8/xzl34iYv08
 wOB0fP+Ox5m0t9N5yZCbcaQug3hSlgp9hittYRgIK4GwZtNO11bOzeCEMk+xFYUoa5V8JWK9/vxrx
 NZEn58vMJ/nxoJzkb++iV7KBtsqErbs5iDwFln/TRJAQDYrtHJKLLFB9BGUDuaBOmFummR70Rbo55
 J9fvUHc2O70qteKOt5A0zv7G8uUdIaaUHrT+VOS7o+MrbPQcSk+bl81L2R7TfWViCmKQ60sD3M90Y
 oOfCQxricddC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Christian,

On Tue, 2024-10-01 at 10:57 +0100, Christian Loehle wrote:
> On 9/30/24 21:35, srinivas pandruvada wrote:
> > On Mon, 2024-09-30 at 20:03 +0200, Rafael J. Wysocki wrote:
> > > +Srinivas who can say more about the reasons why iowait boosting
> > > makes
> > > a difference for intel_pstate than I do.
> > >=20
>=20
> Hi Srinivas,
>=20
> > It makes difference on Xeons and also GFX performance.
>=20
> AFAIU the GFX performance with iowait boost is a regression though,
> because it cuts into the system power budget (CPU+GPU), especially
> on desktop and mobile chips (but also some servers), no?
> https://lore.kernel.org/lkml/20180730220029.81983-1-srinivas.pandruvada@l=
inux.intel.com/
> https://lore.kernel.org/lkml/e7388bf4-deb1-34b6-97d7-89ced8e78ef1@intel.c=
om/
> Or is there a reported case where iowait boosting helps
> graphics workloads?
>=20
GFX is complex as you have both cases depending on the generation. We
don't enable the control by default. There is a user space control, so
that it can be selected when it helps.


> > The actual gains will be model specific as it will be dependent on
> > hardware algorithms and EPP.
> >=20
> > It was introduced to solve regression in Skylake xeons. But even in
> > the
> > recent servers there are gains.
> > Refer to
> > https://lkml.iu.edu/hypermail/linux/kernel/1806.0/03574.html
>=20
> Did you look into PELT utilization values at that time?
No. But boost is needed for idle or semi-idle CPUs, otherwise HWP would
have already running at higher frequency. But we could avoid boot if
util is above a threshold.


> I see why intel_pstate might be worse off than schedutil wrt removing
> iowait boosting and do see two remedies essentially:
> 1. Boost after all sleeps (less aggressively), although I'm not a
> huge fan of
> this.
> 2. If the gap between util_est and HWP-determined frequency is too
> large
> then apply some boost. A sort of fallback on a schedutil strategy.
> That would of course require util_est to be significantly large in
> those
> scenarios.
>=20
> I might try to propose something for 2, although as you can probably
> guess, playing with HWP is somewhat uncharted waters for me.
>=20
Now we sample the last HWP determined frequency at every tick and can
use to avoid boost. So need some experiments.

> Since intel_pstate will actually boost into unsustainable P-states,
> there should be workloads that regress with iowait boosting. I'll
> go looking for those.

Xeons power limit is in order of 100s of Watts. So boost doesn't
generally to unsustainable state. Even if all cores boost at the same
time, the worst case we still get all core turbo.

Thanks,
Srinivas




>=20
>=20


