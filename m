Return-Path: <io-uring+bounces-3335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F27F998AE76
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2D322826A0
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38011991D6;
	Mon, 30 Sep 2024 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gts4qvFq"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F033D17BEB7;
	Mon, 30 Sep 2024 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728554; cv=none; b=HcfWWlXUzB0DFwoIgunRX+hIMw+ulox3757AFh5QgUwe2I437I1vWASvZV2xbKS277mOGBfaOS4VASZDWurTr1NAtO8YbAt/ZGm//s3uHswtEz4dWvY45dobbs4jXGODw2Q9234I2K5DPhRbkb4XkQqjnEnWP/OG+0jMxrGDoos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728554; c=relaxed/simple;
	bh=ZhM5xPUfYNbchBISZZvzM6P6dwshGNX0e5Ob6ktp4L8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ooeNqsLVQ92mXxNSRy5418+rCQAaQf+MRff5SiW95sVHLfBPS4yP45HZh7ySSegMW6hawRu3Y/oI8UNU+K1eIjOqGM9J8/UOFYLPPnm/Of8qkJeS3RhEO3JnX3QsdzBfS+MWDr2xkLSo85Kndhw1tELC6qLaVYz43cEOH0xhhM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gts4qvFq; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727728553; x=1759264553;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ZhM5xPUfYNbchBISZZvzM6P6dwshGNX0e5Ob6ktp4L8=;
  b=Gts4qvFqzzf+nCGf8iqRY//9l0pYVkQiJ1FDRcIoYUtuL9gbAplygRNB
   od995AIqYug3bZ7Gp2YA38mnnvELDtoxceITHKxrP0LXl4tNCZwTZFA8V
   ltXtyUzHmLrzZnfC7Rux8POmmKJlZ8U0TTudTFA/p9xgknDWeffWRXLNp
   Gh7/D6gfsUFv6xRvmnwB559u/iTWNKFpHhHgzBR1/Vl7lvmsFq8dy4+wc
   d7XbPBnzPGwZHNeF4Q4JSRa53DF5y+qmDl8B2Qm0395SuAF+enPlL4iVA
   GskSHU/+sXJrt7TA4JYWPFBgvG+mTLyEp7k139RtD1/tgYI7nFqomnbB5
   g==;
X-CSE-ConnectionGUID: k4hU7PHPQKOtoDGyKGLJ0Q==
X-CSE-MsgGUID: cdNQutrWSFu4Zy3vEKNSxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="27015650"
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="27015650"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 13:35:26 -0700
X-CSE-ConnectionGUID: mCndPb4cSxe1tsWd0dSacg==
X-CSE-MsgGUID: k+nXGbSLQ7m1pH92QfsDxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,166,1725346800"; 
   d="scan'208";a="78392383"
Received: from spandruv-desk1.amr.corp.intel.com ([10.125.108.137])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 13:35:26 -0700
Message-ID: <0a0186cad5a9254027d0ac6a7f39e39f5473665c.camel@linux.intel.com>
Subject: Re: [RFC PATCH 6/8] cpufreq: intel_pstate: Remove iowait boost
From: srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, Christian Loehle
	 <christian.loehle@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com, 
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org, 
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com,
 ulf.hansson@linaro.org,  bvanassche@acm.org, andres@anarazel.de,
 asml.silence@gmail.com,  linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, qyousef@layalina.io,  dsmythies@telus.net,
 axboe@kernel.dk
Date: Mon, 30 Sep 2024 13:35:25 -0700
In-Reply-To: <CAJZ5v0i3ULQ-Mzu=6yzo4whnWne0g1sxcgPL_u828Jyy1Qu1Zg@mail.gmail.com>
References: <20240905092645.2885200-1-christian.loehle@arm.com>
	 <20240905092645.2885200-7-christian.loehle@arm.com>
	 <CAJZ5v0i3ULQ-Mzu=6yzo4whnWne0g1sxcgPL_u828Jyy1Qu1Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTA5LTMwIGF0IDIwOjAzICswMjAwLCBSYWZhZWwgSi4gV3lzb2NraSB3cm90
ZToKPiArU3Jpbml2YXMgd2hvIGNhbiBzYXkgbW9yZSBhYm91dCB0aGUgcmVhc29ucyB3aHkgaW93
YWl0IGJvb3N0aW5nCj4gbWFrZXMKPiBhIGRpZmZlcmVuY2UgZm9yIGludGVsX3BzdGF0ZSB0aGFu
IEkgZG8uCj4gCkl0IG1ha2VzIGRpZmZlcmVuY2Ugb24gWGVvbnMgYW5kIGFsc28gR0ZYIHBlcmZv
cm1hbmNlLgpUaGUgYWN0dWFsIGdhaW5zIHdpbGwgYmUgbW9kZWwgc3BlY2lmaWMgYXMgaXQgd2ls
bCBiZSBkZXBlbmRlbnQgb24KaGFyZHdhcmUgYWxnb3JpdGhtcyBhbmQgRVBQLgoKSXQgd2FzIGlu
dHJvZHVjZWQgdG8gc29sdmUgcmVncmVzc2lvbiBpbiBTa3lsYWtlIHhlb25zLiBCdXQgZXZlbiBp
biB0aGUKcmVjZW50IHNlcnZlcnMgdGhlcmUgYXJlIGdhaW5zLgpSZWZlciB0bwpodHRwczovL2xr
bWwuaXUuZWR1L2h5cGVybWFpbC9saW51eC9rZXJuZWwvMTgwNi4wLzAzNTc0Lmh0bWwKClRoYW5r
cywKU3Jpbml2YXMKCgo+IE9uIFRodSwgU2VwIDUsIDIwMjQgYXQgMTE6MjfigK9BTSBDaHJpc3Rp
YW4gTG9laGxlCj4gPGNocmlzdGlhbi5sb2VobGVAYXJtLmNvbT4gd3JvdGU6Cj4gPiAKPiA+IEFu
YWxvZ291cyB0byBzY2hlZHV0aWwsIHJlbW92ZSBpb3dhaXQgYm9vc3QgZm9yIHRoZSBzYW1lIHJl
YXNvbnMuCj4gCj4gV2VsbCwgZmlyc3Qgb2YgYWxsLCBpb3dhaXQgYm9vc3Rpbmcgd2FzIGFkZGVk
IHRvIGludGVsX3BzdGF0ZSB0byBoZWxwCj4gc29tZSB3b3JrbG9hZHMgdGhhdCBvdGhlcndpc2Ug
d2VyZSB1bmRlcnBlcmZvcm1pbmcuwqAgSSdtIG5vdCBzdXJlIGlmCj4geW91IGNhbiBzaW1wbHkg
cmVtb3ZlIGl0IHdpdGhvdXQgaW50cm9kdWNpbmcgcGVyZm9ybWFuY2UgcmVncmVzc2lvbnMKPiBp
biB0aG9zZSB3b3JrbG9hZHMuCj4gCj4gV2hpbGUgeW91IGNhbiBhcmd1ZSB0aGF0IGl0IGlzIG5v
dCB1c2VmdWwgaW4gc2NoZWR1dGlsIGFueSBtb3JlIGR1ZQo+IHRvCj4gdGhlIGltcHJvdmVkIHNj
aGVkdWxlciBpbnB1dCBmb3IgaXQsIHlvdSBjYW4gaGFyZGx5IGV4dGVuZCB0aGF0Cj4gYXJndW1l
bnQgdG8gaW50ZWxfcHN0YXRlIGJlY2F1c2UgaXQgZG9lc24ndCB1c2UgYWxsIG9mIHRoZSBzY2hl
ZHVsZXIKPiBpbnB1dCB1c2VkIGJ5IHNjaGVkdXRpbC4KPiAKPiBBbHNvLCB0aGUgRUFTIGFuZCBV
Q0xBTVBfTUFYIGFyZ3VtZW50cyBhcmUgbm90IGFwcGxpY2FibGUgdG8KPiBpbnRlbF9wc3RhdGUg
YmVjYXVzZSBpdCBkb2Vzbid0IHN1cHBvcnQgYW55IG9mIHRoZW0uCj4gCj4gVGhpcyBhcHBsaWVz
IHRvIHRoZSBvbmRlbWFuZCBjcHVmcmVxIGdvdmVybm9yIGVpdGhlci4KPiAKPiAKPiA+IFNpZ25l
ZC1vZmYtYnk6IENocmlzdGlhbiBMb2VobGUgPGNocmlzdGlhbi5sb2VobGVAYXJtLmNvbT4KPiA+
IC0tLQo+ID4gwqBkcml2ZXJzL2NwdWZyZXEvaW50ZWxfcHN0YXRlLmMgfCA1MCArKy0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0KPiA+IC0tLS0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgNDcgZGVsZXRpb25zKC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2NwdWZyZXEvaW50ZWxfcHN0YXRlLmMKPiA+IGIvZHJpdmVycy9jcHVmcmVxL2ludGVsX3BzdGF0
ZS5jCj4gPiBpbmRleCBjMDI3OGQwMjNjZmMuLjdmMzBiMjU2OWJiMyAxMDA2NDQKPiA+IC0tLSBh
L2RyaXZlcnMvY3B1ZnJlcS9pbnRlbF9wc3RhdGUuYwo+ID4gKysrIGIvZHJpdmVycy9jcHVmcmVx
L2ludGVsX3BzdGF0ZS5jCj4gPiBAQCAtMTkxLDcgKzE5MSw2IEBAIHN0cnVjdCBnbG9iYWxfcGFy
YW1zIHsKPiA+IMKgICogQHBvbGljeTrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIENQVUZyZXEgcG9s
aWN5IHZhbHVlCj4gPiDCoCAqIEB1cGRhdGVfdXRpbDrCoMKgwqDCoMKgwqAgQ1BVRnJlcSB1dGls
aXR5IGNhbGxiYWNrIGluZm9ybWF0aW9uCj4gPiDCoCAqIEB1cGRhdGVfdXRpbF9zZXQ6wqDCoCBD
UFVGcmVxIHV0aWxpdHkgY2FsbGJhY2sgaXMgc2V0Cj4gPiAtICogQGlvd2FpdF9ib29zdDrCoMKg
wqDCoMKgIGlvd2FpdC1yZWxhdGVkIGJvb3N0IGZyYWN0aW9uCj4gPiDCoCAqIEBsYXN0X3VwZGF0
ZTrCoMKgwqDCoMKgwqAgVGltZSBvZiB0aGUgbGFzdCB1cGRhdGUuCj4gPiDCoCAqIEBwc3RhdGU6
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBTdG9yZXMgUCBzdGF0ZSBsaW1pdHMgZm9yIHRoaXMgQ1BV
Cj4gPiDCoCAqIEB2aWQ6wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBTdG9yZXMgVklEIGxp
bWl0cyBmb3IgdGhpcyBDUFUKPiA+IEBAIC0yNDUsNyArMjQ0LDYgQEAgc3RydWN0IGNwdWRhdGEg
ewo+ID4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IGFjcGlfcHJvY2Vzc29yX3BlcmZvcm1hbmNlIGFj
cGlfcGVyZl9kYXRhOwo+ID4gwqDCoMKgwqDCoMKgwqAgYm9vbCB2YWxpZF9wc3NfdGFibGU7Cj4g
PiDCoCNlbmRpZgo+ID4gLcKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgaW93YWl0X2Jvb3N0Owo+
ID4gwqDCoMKgwqDCoMKgwqAgczE2IGVwcF9wb3dlcnNhdmU7Cj4gPiDCoMKgwqDCoMKgwqDCoCBz
MTYgZXBwX3BvbGljeTsKPiA+IMKgwqDCoMKgwqDCoMKgIHMxNiBlcHBfZGVmYXVsdDsKPiA+IEBA
IC0yMTM2LDI4ICsyMTM0LDcgQEAgc3RhdGljIGlubGluZSB2b2lkCj4gPiBpbnRlbF9wc3RhdGVf
dXBkYXRlX3V0aWxfaHdwX2xvY2FsKHN0cnVjdCBjcHVkYXRhICpjcHUsCj4gPiDCoHsKPiA+IMKg
wqDCoMKgwqDCoMKgIGNwdS0+c2FtcGxlLnRpbWUgPSB0aW1lOwo+ID4gCj4gPiAtwqDCoMKgwqDC
oMKgIGlmIChjcHUtPnNjaGVkX2ZsYWdzICYgU0NIRURfQ1BVRlJFUV9JT1dBSVQpIHsKPiA+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgZG9faW8gPSBmYWxzZTsKPiA+IC0KPiA+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNwdS0+c2NoZWRfZmxhZ3MgPSAwOwo+ID4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyoKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgKiBTZXQgaW93YWl0X2Jvb3N0IGZsYWcgYW5kIHVwZGF0ZSB0aW1lLiBTaW5j
ZSBJTwo+ID4gV0FJVCBmbGFnCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICog
aXMgc2V0IGFsbCB0aGUgdGltZSwgd2UgY2FuJ3QganVzdCBjb25jbHVkZSB0aGF0Cj4gPiB0aGVy
ZSBpcwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHNvbWUgSU8gYm91bmQg
YWN0aXZpdHkgaXMgc2NoZWR1bGVkIG9uIHRoaXMgQ1BVCj4gPiB3aXRoIGp1c3QKPiA+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBvbmUgb2NjdXJyZW5jZS4gSWYgd2UgcmVjZWl2
ZSBhdCBsZWFzdCB0d28gaW4KPiA+IHR3bwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqIGNvbnNlY3V0aXZlIHRpY2tzLCB0aGVuIHdlIHRyZWF0IGFzIGJvb3N0Cj4gPiBjYW5k
aWRhdGUuCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodGltZV9iZWZvcmU2NCh0aW1lLCBjcHUtPmxhc3Rf
aW9fdXBkYXRlICsgMiAqCj4gPiBUSUNLX05TRUMpKQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRvX2lvID0gdHJ1ZTsKPiA+IC0KPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNwdS0+bGFzdF9pb191cGRhdGUgPSB0aW1lOwo+ID4gLQo+
ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGRvX2lvKQo+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludGVsX3BzdGF0ZV9od3BfYm9v
c3RfdXAoY3B1KTsKPiA+IC0KPiA+IC3CoMKgwqDCoMKgwqAgfSBlbHNlIHsKPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludGVsX3BzdGF0ZV9od3BfYm9vc3RfZG93bihjcHUpOwo+
ID4gLcKgwqDCoMKgwqDCoCB9Cj4gPiArwqDCoMKgwqDCoMKgIGludGVsX3BzdGF0ZV9od3BfYm9v
c3RfZG93bihjcHUpOwo+ID4gwqB9Cj4gPiAKPiA+IMKgc3RhdGljIGlubGluZSB2b2lkIGludGVs
X3BzdGF0ZV91cGRhdGVfdXRpbF9od3Aoc3RydWN0Cj4gPiB1cGRhdGVfdXRpbF9kYXRhICpkYXRh
LAo+ID4gQEAgLTIyNDAsOSArMjIxNyw2IEBAIHN0YXRpYyBpbmxpbmUgaW50MzJfdAo+ID4gZ2V0
X3RhcmdldF9wc3RhdGUoc3RydWN0IGNwdWRhdGEgKmNwdSkKPiA+IMKgwqDCoMKgwqDCoMKgIGJ1
c3lfZnJhYyA9IGRpdl9mcChzYW1wbGUtPm1wZXJmIDw8IGNwdS0+YXBlcmZfbXBlcmZfc2hpZnQs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHNhbXBsZS0+dHNjKTsKPiA+IAo+ID4gLcKgwqDCoMKgwqDCoCBpZiAoYnVzeV9mcmFjIDwgY3B1
LT5pb3dhaXRfYm9vc3QpCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBidXN5X2Zy
YWMgPSBjcHUtPmlvd2FpdF9ib29zdDsKPiA+IC0KPiA+IMKgwqDCoMKgwqDCoMKgIHNhbXBsZS0+
YnVzeV9zY2FsZWQgPSBidXN5X2ZyYWMgKiAxMDA7Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgIHRh
cmdldCA9IFJFQURfT05DRShnbG9iYWwubm9fdHVyYm8pID8KPiA+IEBAIC0yMzAzLDcgKzIyNzcs
NyBAQCBzdGF0aWMgdm9pZCBpbnRlbF9wc3RhdGVfYWRqdXN0X3BzdGF0ZShzdHJ1Y3QKPiA+IGNw
dWRhdGEgKmNwdSkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzYW1wbGUtPmFw
ZXJmLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNhbXBsZS0+dHNjLAo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdldF9hdmdfZnJlcXVlbmN5KGNwdSksCj4g
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmcF90b2ludChjcHUtPmlvd2FpdF9ib29z
dCAqIDEwMCkpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMCk7Cj4gPiDCoH0K
PiA+IAo+ID4gwqBzdGF0aWMgdm9pZCBpbnRlbF9wc3RhdGVfdXBkYXRlX3V0aWwoc3RydWN0IHVw
ZGF0ZV91dGlsX2RhdGEKPiA+ICpkYXRhLCB1NjQgdGltZSwKPiA+IEBAIC0yMzE3LDI0ICsyMjkx
LDYgQEAgc3RhdGljIHZvaWQgaW50ZWxfcHN0YXRlX3VwZGF0ZV91dGlsKHN0cnVjdAo+ID4gdXBk
YXRlX3V0aWxfZGF0YSAqZGF0YSwgdTY0IHRpbWUsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuOwo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoCBkZWx0YV9ucyA9IHRpbWUg
LSBjcHUtPmxhc3RfdXBkYXRlOwo+ID4gLcKgwqDCoMKgwqDCoCBpZiAoZmxhZ3MgJiBTQ0hFRF9D
UFVGUkVRX0lPV0FJVCkgewo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogU3Rh
cnQgb3ZlciBpZiB0aGUgQ1BVIG1heSBoYXZlIGJlZW4gaWRsZS4gKi8KPiA+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmIChkZWx0YV9ucyA+IFRJQ0tfTlNFQykgewo+ID4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNwdS0+aW93YWl0X2Jvb3N0
ID0gT05FX0VJR0hUSF9GUDsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0gZWxz
ZSBpZiAoY3B1LT5pb3dhaXRfYm9vc3QgPj0gT05FX0VJR0hUSF9GUCkgewo+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNwdS0+aW93YWl0X2Jvb3N0IDw8
PSAxOwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChjcHUtPmlvd2FpdF9ib29zdCA+IGludF90b2ZwKDEpKQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjcHUtPmlvd2FpdF9i
b29zdCA9IGludF90b2ZwKDEpOwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSBl
bHNlIHsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBj
cHUtPmlvd2FpdF9ib29zdCA9IE9ORV9FSUdIVEhfRlA7Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB9Cj4gPiAtwqDCoMKgwqDCoMKgIH0gZWxzZSBpZiAoY3B1LT5pb3dhaXRfYm9v
c3QpIHsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIENsZWFyIGlvd2FpdF9i
b29zdCBpZiB0aGUgQ1BVIG1heSBoYXZlIGJlZW4KPiA+IGlkbGUuICovCj4gPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoZGVsdGFfbnMgPiBUSUNLX05TRUMpCj4gPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3B1LT5pb3dhaXRfYm9vc3Qg
PSAwOwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZWxzZQo+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNwdS0+aW93YWl0X2Jvb3N0ID4+
PSAxOwo+ID4gLcKgwqDCoMKgwqDCoCB9Cj4gPiDCoMKgwqDCoMKgwqDCoCBjcHUtPmxhc3RfdXBk
YXRlID0gdGltZTsKPiA+IMKgwqDCoMKgwqDCoMKgIGRlbHRhX25zID0gdGltZSAtIGNwdS0+c2Ft
cGxlLnRpbWU7Cj4gPiDCoMKgwqDCoMKgwqDCoCBpZiAoKHM2NClkZWx0YV9ucyA8IElOVEVMX1BT
VEFURV9TQU1QTElOR19JTlRFUlZBTCkKPiA+IEBAIC0yODMyLDcgKzI3ODgsNyBAQCBzdGF0aWMg
dm9pZCBpbnRlbF9jcHVmcmVxX3RyYWNlKHN0cnVjdAo+ID4gY3B1ZGF0YSAqY3B1LCB1bnNpZ25l
ZCBpbnQgdHJhY2VfdHlwZSwgaW4KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
YW1wbGUtPmFwZXJmLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNhbXBsZS0+
dHNjLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdldF9hdmdfZnJlcXVlbmN5
KGNwdSksCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmcF90b2ludChjcHUtPmlv
d2FpdF9ib29zdCAqIDEwMCkpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMCk7
Cj4gPiDCoH0KPiA+IAo+ID4gwqBzdGF0aWMgdm9pZCBpbnRlbF9jcHVmcmVxX2h3cF91cGRhdGUo
c3RydWN0IGNwdWRhdGEgKmNwdSwgdTMyIG1pbiwKPiA+IHUzMiBtYXgsCj4gPiAtLQo+ID4gMi4z
NC4xCj4gPiAKCg==


