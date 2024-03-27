Return-Path: <io-uring+bounces-1238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA1988D4AC
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 03:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31DF4B213FD
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 02:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D48D21101;
	Wed, 27 Mar 2024 02:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mODcLDzX"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A3412E55;
	Wed, 27 Mar 2024 02:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507381; cv=fail; b=dQFfMCf2yf53BNm3Teup8toL83bnyj9ai3gHFOEVlho4ZFblJQe5g50u1YgwNET8xANnp15YMjycMGU0RDEoKg6D0cZmo+phg4kv1c9vW10yKcJZY2Enpl+SwV3qvAHCN9X6GvKlAENF2T+YYG7KgeWgIRu/rvhJbHEZtzI3ZEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507381; c=relaxed/simple;
	bh=Wp4RbzmbdSayEsE4Fr0vfezB0CpgwYdfSpqgbsxGMIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k6c/bFfbu05u2XJ8OpSYs4PtxsXenrSQpcuQ+cANoph6JERDGkkbg9P3OyJziQI1aEkXihIVbfhhK6N2/GwCR1ipWRvNQ2IyuCr+4NC97rmGBoXo7fKmhazglYJvCupY6cU/LVf4cCcJ2neRwdG+RhHsw8PurvJtX3ygbtkdCrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mODcLDzX; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711507379; x=1743043379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Wp4RbzmbdSayEsE4Fr0vfezB0CpgwYdfSpqgbsxGMIg=;
  b=mODcLDzXnbTPdFv0ZC3cy3Jwv42oJbsqnhuEWnORaxfG7MkNOKxC7Hfw
   wM4PGzR93ZqFstHp8aEwslSIZ8BoLKCruyeqSgqpCCU173yCc6K+qjHYn
   w6elZdPGluuzHyEmuXKqqR+FtywgQkEjLN+EallH2b6AHqRGSc82wEyLP
   SOzaUwtv0GEiZRWpqg51wH3oYIJfP9fsaTnAsqRRR4JbbhRMdOjkfMHSu
   xA1DNJiueRw+xFjbOHUtQIFRympCBbYZ9s3LL9FeClOhhzYG9o9zbU2o6
   B1k6ZAmxsJrD/adB/sVKuGXQMtlViUAUsVLWWZdkcQ/B5X4U4aH08UQMG
   Q==;
X-CSE-ConnectionGUID: um6J18tPSJSskrFDTZpawg==
X-CSE-MsgGUID: 1LoMvLqdQPykfcDPsCK9fQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6416906"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="6416906"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 19:42:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="16219247"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Mar 2024 19:42:57 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Mar 2024 19:42:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 26 Mar 2024 19:42:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 19:42:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKjtwKqJwjj+8oIFtKmCkkh8IL0tYId2qt99Af0Qrz/3UJ/18yTfG951SOw+upkMdB7uS0gDgKOkTHrRPLWQQR8tR/V4k6nneXbTdcaT2pI4okYXhCAZtPlOT1uczx5O5EVLwVLlqlS7HrUaCi2ztplvZajZBdRiSXgp6tynRAl7VLPfnxSleUAleGJjONYuBbGCCo4PWBAaEm7GjjjUo6vjhDUF9D2+IOJ0c56++D0EZ+n64smFHo06+iASsYqED8SpQgkJ+WDjEeUKfntD8veM88bO8B864Kw6Wp8aYPrikR+2DzQjzEXADGY6CQkh7FnnlBtdTj4T0RnIC60ZFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wp4RbzmbdSayEsE4Fr0vfezB0CpgwYdfSpqgbsxGMIg=;
 b=UFypck1eEn7fBurv+PLyIWwu/fitgCz5F/hQkw3gTh6qctcHkawEfzn3HAhjn+17lnsSk9EyS4MFgnFkuxGwcI7NCqXZPFPhfivoZVT8Wvgkin2u0GkjDlPHtpK1GfPXBjppiRgfzOKIYvbV2IXtQiLpaCp/yNif/JYEqmwjqmoRvtUKf7WJqH/dXjPk3JVWEIwZePMjezC9rK5pVDJnjcwyhs1QDpfYzKfdW4er+4c0NNJYuKuP87JhejlrHn44rfjUg5Knw4e7kfFuGVMQ5R9sflVese5K3ZkMdHSIjPStrbQ0tN3DQZmOR0AvApsnx1x7n0sDoMUxPV7YL6pQ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6005.namprd11.prod.outlook.com (2603:10b6:510:1e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 02:42:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 02:42:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "keescook@chromium.org" <keescook@chromium.org>, "luto@kernel.org"
	<luto@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "debug@rivosinc.com" <debug@rivosinc.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "christophe.leroy@csgroup.eu"
	<christophe.leroy@csgroup.eu>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "sparclinux@vger.kernel.org"
	<sparclinux@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
Thread-Topic: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
Thread-Index: AQHafyO9StMvuMMYIkm9Rry80msHU7FJ60+AgAD3UgA=
Date: Wed, 27 Mar 2024 02:42:49 +0000
Message-ID: <5b585bcced9b5fffbcfa093ea92a6403ee8ac462.camel@intel.com>
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
	 <20240326021656.202649-3-rick.p.edgecombe@intel.com>
	 <D03NWFQM9XP2.1AWMB9VW98Z98@kernel.org>
In-Reply-To: <D03NWFQM9XP2.1AWMB9VW98Z98@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6005:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /7G9qkKF8Pgmf5yb8+W+SP1GIiOJIKvXjDpt0oOT0uPgQngzM1IckelnV7PYg+OzAp1MfFnGl16ASg5omxbSsX1sZkVzxyrqkkesQmAr5q3ktD//qFhRKKUJ1WzuAVSwDql/U2PHo0PUcbg+ZXo/94shbz8nYrggfWduZwbKR346QFW7MRARyRFIze46SYpaItC2D1EkMDzVBRZlltTKYTGu93jjKKpO6USTlwYx0RZX78q1DybYNXMP3DDImfh07m6j8v2Gse2qt1b48Xe5c0k4EWhWxuhN9XZ5I7WdFxTwGiS5SI+GuQpeXCvTXQfKY9bqL0hNncXUx4UyeupS8wk1d97y7RRB6/IgdVpwPh8MqTJ0GFWoSv5K1eTkblZmnZTQRuk0kyC1l4AD+tlv4LFRwUkiGwxl9Pi8Ow4TgxcAH3wJt6rcp9JyqlQ1ZYioml2sG3ZcVYNv6L5TUQVsoITqdbKNkxvVV1GpAwdnobyLH8jSOSm3Si47qCDOcilfGzcQ9BA7Giwy2qRwMsomtH42YsvKM0giVUudyeeTHWZ9OyFkn2/vTdDzBNaBjc1PrjKNfzZsxIDhNWwY6nAkLXI2bmPe8dG7hBD2BXwXtvjkDibFQNNBoIOkbpEI+BA+dGgyE+RFLBNuw59hftTwOEGeR8FyGSK/1ymYccWYob6zNDSF4prA1gYBjcMwBuC/VbjSAnRFz+RWXFeP2Z+lkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVRMbUNvTjZMWk5kY1ltQkxvM255My9UM3VGWGM4SkNqNzRVdlRKQ1c4OEZV?=
 =?utf-8?B?b2hBV2FGeWg2K2h5b1RhbFF3OXgyYXlQb0JsdHNCQUxzSTZDRlFSSCthUWRN?=
 =?utf-8?B?dkVZeFhxbG1OcmQxWlhrQWFpbEhISElUR0dYSkwzaVdrRDlmY0lXeFhVeGxp?=
 =?utf-8?B?TnNWN1N0cnhIT21rblZ6K1A3dWJYdlFVSnd1SWVyVFlNL0hXS2Z0WXgyazVE?=
 =?utf-8?B?MkhldVV0OExBU1I2Z3VKYkY3Q2JDNjczRWx3L2FzTm9HQWhlWGxTNGppQThB?=
 =?utf-8?B?c1hIS2U0WTVobUxkdEZ0b2loZFE3SVRzdjgxY0pYYUswVmVWWHJBazMvRU1M?=
 =?utf-8?B?d0c1VjdaUGZTVmtEdDN1RE1ZNEF2a1dBVW1xUVVVVE9WODhFSlBnYStQWmZ3?=
 =?utf-8?B?MlZWZDFvV1p1TXlFdjhRdkg3S2lVUmJYWUJ2N3JDbzhyOUZET1RqQ010ejNE?=
 =?utf-8?B?UEM1YkVrN3dTd3NpVXNseDJwUGFQcGdnSlJOTXdWWUs2ZEllTll4NWk1cFVn?=
 =?utf-8?B?NFp0NTZYaHplbzVzMmV3c09nZDIwRlYyeThoYklNY28wZHB0T2trbUFGamVu?=
 =?utf-8?B?dUpkS3ZSc3pOTW9jY2ZXa3VZQ2VjaUs1SzExSmMwSG5MaUExOVRNS0l6U20w?=
 =?utf-8?B?MzBObTZqSVVwS0V1MXhUSVRERzVEMHVId3V5MmplNFZKaDRJMkZoQmZFS1po?=
 =?utf-8?B?MDZ0Y2FRSEJ0VE16NExheG44dElqNllMKzF5TlhYdnpydGdpV2NhaVRNMXlU?=
 =?utf-8?B?WGFqQXp4eFFsc0RHYTh4TlRvQ1ovYXlGckFpRVIzRlJQZW84SUkyc1ZrS1dN?=
 =?utf-8?B?RnRFN0JhZ0tOcEtQdEVubGxPNWVWdE9EREpKbGM3L1Q1Q1dibm5JNjQ3TkFm?=
 =?utf-8?B?cEpxdEUrMTkxVnVBM2s5YjBkYkYvTW52dzRsTk1PVis2ekcxNXN5bWR5Yi82?=
 =?utf-8?B?U2d4dVZkVVBpOUpaRFY1SWRjeG9JemFZWThzc3lnNHUyUDJLNCtEOTdoYXAr?=
 =?utf-8?B?d2N6bW9SS0ZibTEveWZWUWlDNWMwU3Q0bVJJaUs3eHEwUU15VDBMRnBIOW1B?=
 =?utf-8?B?SS85eE9ZZnIvV3R5c0JIOWlmZ21GcS9hcUwvQUZob1JrZWZvd1BMWXJNWENW?=
 =?utf-8?B?VnN5MFNheHljUmoyalpaSTFzVng5M2QrWGZlMWhtWncxZEp0anZsdzdJbk5X?=
 =?utf-8?B?Q1hOVDRYSU5LQkF2V2xaNStUWW9KWVRPV3VBR1VsZkN4eGRSSlF1S0s5UVc3?=
 =?utf-8?B?NVNRemN6MkNNc2NMeEVUSzhHUVBneVJxQU8wSThhSWFBZGN5UkFJNDBzU3pY?=
 =?utf-8?B?a2R0UmdIeTVsVFQ0ZDlMUnd0c2poTHpqMTdWS0ZNRVhhV1lVMnZxQVl3bDl2?=
 =?utf-8?B?UjRhdElFN2pXWWFCVFBQKzNkSjVBaWc1Sm0vTHl1eGU5TCtrenA2eVAzNFYv?=
 =?utf-8?B?cm50K3dDSzVsa2F0cGNQb3p1bVNQTDlQOHhzaXkvQzc5bldEYzJaUVd4WUlz?=
 =?utf-8?B?a1U0Y1cvWUQzVHlmVFpSOFZUczBIcHB6L1FxakE1SjNBcGlSYzJ0OS80TFBy?=
 =?utf-8?B?ZVd3cXVtQVFhcERjS2FqMGxHUFQxSFBxR0cyZFcwNFp2M3l2enRMR3V0VzVm?=
 =?utf-8?B?YzUwcy9SWGY3Y3ZWdW1UWHRZYlY3c1NTTWhWSWhlY1lWRWdjMGd3akhxQjBp?=
 =?utf-8?B?dEE2T001blVVUWlTaXpBeHhmTmt1bGlFSVFGVXBsL2RaSUI4bjNaRzZWRFVp?=
 =?utf-8?B?N3E2MktoNTdWcGUzNDNUV29uWWRwWHVUMFZ0aG9UeitqTUlDWUpMS2JsRTk2?=
 =?utf-8?B?cWdsNWFyZlUyQTY4eFZjWlRxU3lrdHBCQnpoK3p4WXRUVjN2MjBSWXFFTE9n?=
 =?utf-8?B?MHl5VmZLWTJVUnRreTEvTyswbWZuYW9NU0UrTHd4dTdJTENLNWN5RzJrYmpt?=
 =?utf-8?B?RFJuWEFBa2lRY2t4VnR5Y2tPdnIwV3dQSHZGd3VjSDg4RXBEbHp3UjE4Ukxw?=
 =?utf-8?B?TCtMSVZjYndoelRleWNUNUVvNS9xUXZKWmpFRXAwNE80azFiVHRSWmFpSkZ1?=
 =?utf-8?B?aG9iTVdSTEhmZEdvVGhkNmVsYnBYSFBNQkJlTzJEUUNmb1NqTFNkOWxSUUMz?=
 =?utf-8?B?U2Fic0VvSnhYUWI3cnVZK2ZuZHNlOWZ0U2d1UitlenNWcjFoYXdjWUZCNG4z?=
 =?utf-8?Q?/3+YcxdhURUloUx5XiU30sQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63F138383CD23146AFA8BC68B20A3FA6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c37148-2aec-4dc4-82a9-08dc4e0797d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 02:42:49.8851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: du4wWoYp7dcmPFyLd+gS23jAafnFvb1t9AoEs0rCnVxyQLpdXOdS7bRbdXxwhr6j4cQFSH8NTAFUr1/BOE0QDJaVpaiZdeU7C1gNQcBYeIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6005
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTI2IGF0IDEzOjU3ICswMjAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IEluIHdoaWNoIGNvbmRpdGlvbnMgd2hpY2ggcGF0aCBpcyB1c2VkIGR1cmluZyB0aGUgaW5p
dGlhbGl6YXRpb24gb2YgbW0NCj4gYW5kIHdoeSBpcyB0aGlzIHRoZSBjYXNlPyBJdCBpcyBhbiBv
cGVuIGNsYWltIGluIHRoZSBjdXJyZW50IGZvcm0uDQoNClRoZXJlIGlzIGFuIGFyY2hfcGlja19t
bWFwX2xheW91dCgpIHRoYXQgYXJjaCdzIGNhbiBoYXZlIHRoZWlyIG93biBydWxlcyBmb3IuIFRo
ZXJlIGlzIGFsc28gYQ0KZ2VuZXJpYyBvbmUuIEl0IGdldHMgY2FsbGVkIGR1cmluZyBleGVjLg0K
DQo+IA0KPiBUaGF0IHdvdWxkIGJlIG5pY2UgdG8gaGF2ZSBkb2N1bWVudGVkIGZvciB0aGUgc2Fr
ZSBvZiBiZWluZyBjb21wbGV0ZQ0KPiBkZXNjcmlwdGlvbi4gSSBoYXZlIHplcm8gZG91YnRzIG9m
IHRoZSBjbGFpbSBiZWluZyB1bnRydWUuDQoNCi4uLmJlaW5nIHVudHJ1ZT8NCg0K

