Return-Path: <io-uring+bounces-1804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CC68BE4CC
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 15:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B7B61C23429
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 13:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A7C15ECFA;
	Tue,  7 May 2024 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzqKzerg"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C9815EFC7;
	Tue,  7 May 2024 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715089879; cv=fail; b=UAOh+0Cnw5Wsto3kURu3TzejYRRqZqSqsEls5YhNy4tkCqFrYiTW8t3FEUREfiCYkbfGIZVNWiEhVwES1GHbo+738e/31vsCrS6UDhLTx6s15VzV/IYKSXwFT731C/2uF0OtjRhhTe3TSdOBuaTd8SrdiCXV5pEKFBYxcegEMtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715089879; c=relaxed/simple;
	bh=qnbtq4AGkVm76QjtUhRGwW5NV8eLD3GirgIDfFMHmdE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MqD3qHIohTCwn94jA5LdqPs6KDR4fNtfN2qdmXPR2tXJr+n7qCWjshUGFlNpbCdzi23S4vEicvYGBndFjOKsFsgkw38mjWIwe5IRhsP/Bnyi89thQ5vCr2bj1KWtpMKfbTrE+/0bRI4ItcSNF05yoyRKNdZGk6K3TesfZHjSo9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzqKzerg; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715089878; x=1746625878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qnbtq4AGkVm76QjtUhRGwW5NV8eLD3GirgIDfFMHmdE=;
  b=UzqKzergd0sBO4IP7qJFO63Z8/vFpnEJviyeBa7qx0U8u+XOm0G8oK0Z
   wQKw/t8vhoiLzYpCUn7cLW76LwOs2mwIr0b6Z6ZPPB125cavD5xQGedjd
   eadKiHrDiWQ9oQIdCZ2psjVSN1ebufhOgGPrrfRaovqWjaRgiIbCRXCQF
   0Szm0HYkOWnVDXbi/umSYt5cDwkfJ27UqEhmjTJWcuSCR6UdZ/wUKv92O
   fVZ9Hna4pw6dOJ5OMiQh3tdx5Kg5RK4CqOAoqYhYT7J2BCHSKNwjFJQ4k
   T+3UO87YAl2UxnOG16eEpZk3QdW08BLiTV6zHvRcdZLsTvfgSFvsVt/FU
   w==;
X-CSE-ConnectionGUID: xznfRcewSQGSECYO6Dg/VQ==
X-CSE-MsgGUID: sTN50Z+RQdivEe/JPEOaWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11006581"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="11006581"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 06:51:17 -0700
X-CSE-ConnectionGUID: ykjFW4PvTU+7c6Hn9Yd1PQ==
X-CSE-MsgGUID: n1J5QJhJQPeEM2hhiqKMPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="65964507"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 06:51:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 06:51:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 06:51:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 06:51:16 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 06:51:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kjcb51vhbrYEtnorB2nA7GfLpdTJSxDXzFyB8MJ3kqxLbLA4R5V+7geVXSmrS1j9U2q4tUNNAIE+E9cLQHIRkuDLPBTP223roB6xOpid7qQtmK6ZkuhUwW7rxvqLfoCeNzR7njVOoLbYxXVV/VxFmHrDB+WULFMbp4lTii1NKSHy2wpIZIaS0u6d0Vrn9/mdOeH8oRj1ESGfSXe/OOTSvy9Cnkkg4rVYqt1l965F1P9FJfE0QX1pWotNJBYRSM+u97VJuI1b1vMeroROTUMqJOzlQQ+g2TLKB3s/hTJonMikimQmhM7Sz4nkijSBJUcyBti/5jse+IdEahXIoFjyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnbtq4AGkVm76QjtUhRGwW5NV8eLD3GirgIDfFMHmdE=;
 b=Z3ST9Y3LFlf6ntKowbfx3gDb1Ih8mxRDKwQem2knJHsZ/AuqqddIFn7PnYClZAIAWFQCLvj6iU08/dNvRqIVfujorKxhbVr7VDJB8SO2jLuHk1yrjGRQjjPuYk3QGt2NFZ6bCEAT+u4HkI3Ng7HMrrpxxuHMl0u+bT62IWaZuraL5NU6UNF9DEvHOemkO2t4yn4dqY6RfNBlrWBgAhGVozuLtLQKuCGe4wbP3e3br/lsEoadEAzLAYW4iZJotOFqhRNj4wG2vKMPijU65Z24KxUtuC3vYrajf7ImrmpWTDIk/UOnXyiOV1zMmPmQYCb25LfDhl0VibLnGRpvn2Fo1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6684.namprd11.prod.outlook.com (2603:10b6:510:1c7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Tue, 7 May
 2024 13:51:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 13:51:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: "x86@kernel.org" <x86@kernel.org>, "keescook@chromium.org"
	<keescook@chromium.org>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "luto@kernel.org" <luto@kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"debug@rivosinc.com" <debug@rivosinc.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Thread-Topic: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Thread-Index: AQHan8+VcRuZX/+qhkGkv4gN6Jgd0bGKYm8AgAFpLwA=
Date: Tue, 7 May 2024 13:51:13 +0000
Message-ID: <98f3fb04ebfcf52ffb60867cf024838d94b83907.camel@intel.com>
References: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
	 <ZjkC1KgTTbR4qzhC@infradead.org>
In-Reply-To: <ZjkC1KgTTbR4qzhC@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6684:EE_
x-ms-office365-filtering-correlation-id: 07af9fb4-c408-4b7d-75ae-08dc6e9cc24c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Q1ErNFpPSTFraFcyTDZCTzE5Ylk2b1paTU9aVFFrNStEY3ZIOUl1RVUrbWVt?=
 =?utf-8?B?YjdLOW1NT2hTUmFzalU2SnRmQnlKdVQxQTNzRmRwMWlmc1A2ZWFYUFY1Qlpp?=
 =?utf-8?B?dUhRdUlvZEJUa2VjS0VRRk9iUTBVQ3FLMUdlNXhZS1JYdGhYK0VqUmszV2ph?=
 =?utf-8?B?cFQ0RHROTEk4akxKeS82YkRRT0JvMlQrY0VnVXhuZ0xGaWpOdXgxSlBzWlFl?=
 =?utf-8?B?WmNIcnU0VThFa0lGSnlMR1JMcG1ETUNCTnpXVkQ0WDRxazk5U3B3eW5YbW03?=
 =?utf-8?B?Rk12bHdEVDlFNjhVeGI1OHBlZWtKcDVId0tKMXdqU0FPTjlZeUVXSGM1UHg0?=
 =?utf-8?B?S1h2ZTJ4R1NuRlRsYmhXdnlFRFlONmtaVFdOdjBlVFBRellQSmkyRzJZaHlx?=
 =?utf-8?B?TVNSR2xQa2w3SmhTRitNRlowQmJxZTR1TnFOWkswOWhVc2JyVXJjenpUR3FH?=
 =?utf-8?B?a2p5T1huTVJpRmtXZm9rNWhOYXQvampmc2w3UWFuQmJQRklvNDNKcXNZYXk1?=
 =?utf-8?B?Y284MURNN2g1S3NWWGc0TS9MaHdEWCt5UHV3TWhhRkswN3c2bGhpc1lES2Z2?=
 =?utf-8?B?TVQrREVQakhPdTAxd1oxNjdGeVpPUlRjbk81cXQrVXJHdlVqNmZBMG5Hd0NK?=
 =?utf-8?B?VnFnWjUwVEZLbWdqdHFYeVVseGVlakdHdkZvcXMweW9pRFZXY0J2MWFhRC9L?=
 =?utf-8?B?MWxuT0VmQUlVNjZ5WktpTmE5VXhocWpGUzRYdXhVTnEvK0JXcHNyQnFGR3lP?=
 =?utf-8?B?UG55MTJFWlRQZ0R2Wm52Q2JkTjFXY01EK0dWMllIcVlQQ3Z2K0Rlckx0L0Nm?=
 =?utf-8?B?LzlaSkN2UjNGbFZzVWRCQ0RMWTA0VXRmZ0JkcHlQNHM5d1IxMEJwSGIvRkRM?=
 =?utf-8?B?M0FadVFOc3lZRjdIbVExU0JSRGp5anZTSGhLZmxRMVBRdEc0R0IwRVJxeEFX?=
 =?utf-8?B?SFJranFiaWxkemNnV1psM2ltcWswYU5NNnhYT3RDcXdoeDZXbVNlRzJQK21L?=
 =?utf-8?B?SzJOMjVFN0NLTWdWTSs4dXJWQ1k0MEh4a1d4dXVocnNxcXBLTm5wUExxNU5z?=
 =?utf-8?B?blZ2eEhVakhVZDcxZVRLenNOZjNLRjh0ZW1KYmFlYllzZ3lCblRJYndQbVI2?=
 =?utf-8?B?OCs0MVdvV0NZMFRySDFZcEVIeVdzc2NkZ1k0ZEIzU001RHQwd1V3WmM5OTNY?=
 =?utf-8?B?WHZlQzRKSWovelhNa1NrOElFa2RDdGowQXZaRnExdnpoNzQ0LzI3VzlwUnp5?=
 =?utf-8?B?bmtvTXgxeWE5RGJGN0hyeGN0YTJqUFV0cnY5ZEgwWi80ZzUzYXY4bm92SFE0?=
 =?utf-8?B?Rkg1SU1FWDAydUM0Tm9aVUh4aEV5d0lwYlJPcmgrK2F0THRyMFZ0Y1JiYk83?=
 =?utf-8?B?QkY1WGUrRTROVDJZVnMzNHZqemhKS0Q0MmZWYXFJbzJmL2wwak5CZFFyUldy?=
 =?utf-8?B?WmJZVk9zenZlRXA1aFhtMHI4aFJKOStDWDR5SEpud3lDVVdDNGtpRk4rM28w?=
 =?utf-8?B?SVJnY1ZHZGlvbW9WRjZheUpTNnplb0RyeE1sdUp0MDJJeGVmRm42VGdLSDhG?=
 =?utf-8?B?TitaWjFYdFU0emgxUW5nRjZuSW9IVUMraHN0WkJ4M3U5Y1RBd2pXL2x4aVBr?=
 =?utf-8?B?dHJXRFRnbEFiaWcwUHdYa2RWWEJiRnNyU2pNZDg2dkczZlU4UStUbFJhQlVK?=
 =?utf-8?B?UUVjREQydCtuZ3lPUlpmaGlEaElkQnhReFdwdFlFL3JlY2kvOXZtMUhnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGRyd3JoS01KaDdwM0JZZnhIMlZNVWxMNXpoNE1IbS92cnZVTFdqZUg2d0VR?=
 =?utf-8?B?a1JvRDg2MVYyT3ZSQVhhQzlIQVBoNUhuUHVkQ2NNMmgxZTRER3IxdUxQckps?=
 =?utf-8?B?TGJpWFhBbTExMEFsMzBaL0tETmFwVWI5UWtXNkF0RVR0Z0hxTUFoWStZMDRK?=
 =?utf-8?B?N0gvS05pSy8wdUw5TXpwQVR2WG5HRG5hRmlyemVWKyt0T2hMKzNDekp5OXVu?=
 =?utf-8?B?aVhwdkdoQk11eWs0RmVMZGVnN2pGS3FBbWs5YTB6dWl3WGpwVGlqR1RVRk9x?=
 =?utf-8?B?YVhJM0wrTzh1S2FuODRrU3YrellJL1lDMnVxeXMvU2NZYlJDdmFINmlZTjNz?=
 =?utf-8?B?bHNpQ0pkVEZ4UUNDWlhjbjlLSk5HM0U1WVIxaW8vaVJUWktmK3B3aXNYZklC?=
 =?utf-8?B?UnBKRHIxM0JUc2s5UlpkYmQrVUg0aW9paG5ZZkxuOVEvWmNuQmtRQWQwaVRT?=
 =?utf-8?B?S25abUtBU05oZDhDb1BSTXZiYk1oQzZuM3JPb0J5citKTy9uVHptOGJub1hk?=
 =?utf-8?B?R01hYis1OWcvOHp5UEMzaDVkZnNURzMvR1owMDFRU2VJVllWVXF3QlNWRHF3?=
 =?utf-8?B?Nll6NU9nT1hWbW5oUk54Y1RDVVRWMFB1bDdwNEp3Z0JPY0hDbXJWSisxT0pQ?=
 =?utf-8?B?cVpNRVFTL0YwOGJ6aGd3dWN5UFhJMWFVK2V0QzZFajFDQ0o2aTlzVFdHaTN2?=
 =?utf-8?B?Y01tTVM5dkIzb3RwKzNwZ0ZUdHJtV2RUOGwyL0wraGg3RHlxZXRSVzdEbFNL?=
 =?utf-8?B?Q2Z0K1lGYm5GMWcwbjk2OFpHU1VEdHB5Wm40anp2Q0s4ZTZiY0toUnFNa2NV?=
 =?utf-8?B?ZUF1Szh0NlJNazZ3SXZxekw4VDQ4OExmYk5ERUltMW92REZpSlN4NnRBWDZN?=
 =?utf-8?B?ejVLem9qOU5XRm1rZHNmM1VaRXVIdFJ0TnVtb21wRW5jc1lMMVNvRHhtOUJ4?=
 =?utf-8?B?QTBFZ3J4Um5meTRDK2ZGNVNiU3BKdWtxM2VweE0xT2xTNmFoQUdhdEtGdmlw?=
 =?utf-8?B?T1puTHNpTHNGblhiNHZ2V2hLUWFKdHlWZ0FaMjBUY0FvRGt4MWJiT1oydXI0?=
 =?utf-8?B?MFp5Z3FhQjRMVkp2bXhEbVdFSEhTaTJrOUZwaTE0NHR0blVWL3Vmb3JLcWFl?=
 =?utf-8?B?bGdPSG5aNkRMTW0yZXA2dVhFOXRSNWJJdWJ4RlNRZ0EvRWpkbUtYTmsvTk0v?=
 =?utf-8?B?eVRmOVAxR25EdWgwQ3pocXhrVXR3R1NXWUFMZm85RTNNYTlxZ1ZRRHBqNks1?=
 =?utf-8?B?T0RvOHpML0R5UTkvZE12blp3ek9FNmhZZmsyTHRNazZNYXZ4UXFVdENwTnVI?=
 =?utf-8?B?OG1iOERMOExlQUJiVGNxUDRIblFxZVRqcW5JaHJLZUgvV21wWmN4TmVWdEtY?=
 =?utf-8?B?YWpkYTl4bTYwWDdTdVdXbG0rZmlNaktyeFBjNFJqQkZSNDA5VXdoQlVyWUxU?=
 =?utf-8?B?by9tL1kxU2hlT01kWHcvSnI1V09jWUpycDd5a21Zd3Y1Q3JHWld1cTlYbHZr?=
 =?utf-8?B?YXFEYzZHbm9oTFZ0c3RKMGZreFBJU2lkYUZHUHVPZlFQYm9kTk1aMWNHNEZC?=
 =?utf-8?B?Y1J2Ly9wdXdzaFY2TUkrSU1qcDJJQUFYZUZOS0RKY3Q4ZkIzL09iZUtZZzZm?=
 =?utf-8?B?aktnYVkwd25PMlpPeGJNTzhpWFFNNzREZmIzay9vTXpqNVZ0aXNKOUZUWjk5?=
 =?utf-8?B?WSswYmhjUlpUdCtKTC85L2tBT0ZCdmFmaWYxak1DeVFyODF2c2g4KzJqOUFq?=
 =?utf-8?B?Q3c0ZDNLMzJhbkRESmZmT0l6QjVmNFAvK2htVlA1MExmcGdRdWJQNUdybkRs?=
 =?utf-8?B?TVFkNlNSQ2MxT1BNcDhxZFNpbEtkaFdISVhzcGczR05lbEJldjloR2ZBT1By?=
 =?utf-8?B?ajBMT2VJbE5CSktnVWtKd3R2NG9rdXJGVTBUTXFGWXlQL2xyT2xYNllYSHdL?=
 =?utf-8?B?S2E2d1VVQU9kS1VkL2Fiam1hYzRrUHpHcTN1emVzdFpVb2lxUGNPNWtrV0du?=
 =?utf-8?B?eU1jZ2N5czdLblBML0ZONGh0alZPUWRSS1FYMnpIRDc4UjlzSGwzeFpsSzVP?=
 =?utf-8?B?MURjdVdqMHFMcE1qMHlSeEdrK3RmM1EyUFJtMWg4RHd5azBONk1keWdTV213?=
 =?utf-8?B?NjdXazlrT2UwZ3hSNk9PSHBkdFRybjM5dFdPdm1ZY3NVSk5GcXlkSjNodDg3?=
 =?utf-8?Q?7n9g67glZA84E7w7/MwPLt0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80EA9A8CEE8DF94EB49F79A4DA7C691D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07af9fb4-c408-4b7d-75ae-08dc6e9cc24c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 13:51:13.3139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DU49E4C5KC3GgJpezVLwTH5+WkKomXc7F4McXPZwXQQbhSzkypG7GH6bxGc29AUooZvvJtXHBKVguHMwmnnjHqvBb4Ey8wCDzHQaUfY7BCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6684
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTA2IGF0IDA5OjE4IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gPiBPbiBNb24sIE1heSAwNiwgMjAyNCBhdCAwOTowNzo0N0FNIC0wNzAwLCBSaWNrIEVk
Z2Vjb21iZSB3cm90ZToNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChmbGFncyAmIE1BUF9G
SVhFRCkgew0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIE9rLCBk
b24ndCBtZXNzIHdpdGggaXQuICovDQo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gbW1fZ2V0X3VubWFwcGVkX2FyZWEoY3VycmVudC0+bW0sIE5VTEwsDQo+ID4g
PiA+IG9yaWdfYWRkciwgPiA+IGxlbiwgcGdvZmYsIGZsYWdzKTsNCj4gPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBjdXJyZW50X2dldF91bm1hcHBlZF9hcmVhKE5V
TEwsIG9yaWdfYWRkciwgbGVuLCA+DQo+ID4gPiA+ID4gcGdvZmYsIGZsYWdzKTsNCj4gPiANCj4g
PiBUaGUgb2xkIG5hbWUgc2VlbXMgcHJlZmVyYWJsZSBiZWNhdXNlIGl0J3Mgbm90IGFzIGNyYXp5
IGxvbmcuwqAgSW4gZmFjdA0KPiA+IGp1c3QgZ2V0X3VubWFwcGVkX2FyZWEgd291bGQgYmUgZXZl
biBiZXR0ZXIsIGJ1dCB0aGF0J3MgYWxyZWFkeSB0YWtlbg0KPiA+IGJ5IHNvbWV0aGluZyBlbHNl
Lg0KDQpPay4NCg0KPiA+IA0KPiA+IENhbiB3ZSBtYXliZSB0YWtlIGEgc3RlcCBiYWNrIGFuZCBz
b3J0IG91dCB0aGUgbWVzcyBvZiB0aGUgdmFyaW91cw0KPiA+IF9nZXRfdW5tYXBwZWRfYXJlYSBo
ZWxwZXJzPw0KPiA+IA0KPiA+IGUuZy4gbW1fZ2V0X3VubWFwcGVkX2FyZWFfdm1mbGFncyBqdXN0
IHdyYXBzDQo+ID4gYXJjaF9nZXRfdW5tYXBwZWRfYXJlYV90b3Bkb3duX3ZtZmxhZ3MgYW5kDQo+
ID4gYXJjaF9nZXRfdW5tYXBwZWRfYXJlYV92bWZsYWdzLCBhbmQgd2UgbWlnaHQgYXMgd2VsbCBt
ZXJnZSBhbGwgdGhyZWUNCj4gPiBieSBtb3ZpbmcgdGhlIE1NRl9UT1BET1dOIGludG8gdHdvIGFj
dHVhbCBpbXBsZW1lbnRhdGlvbnM/DQo+ID4gDQo+ID4gQW5kIHRoZW4ganVzdCB1cGRhdGUgYWxs
IHRoZSBpbXBsZW1lbnRhdGlvbnMgdG8gYWx3YXlzIHBhc3MgdGhlDQo+ID4gdm1fZmxhZ3MgaW5z
dGVhZCBvZiBoYXZpbmcgc2VwYXJhdGUgaW1wbGVtZW50YXRpb25zIHdpdGggb3VyIHdpdGhvdXQN
Cj4gPiB0aGUgZmxhZ3MuDQo+ID4gDQo+ID4gQW5kIHRoZW4gbWFrZSBfX2dldF91bm1hcHBlZF9h
cmVhIHN0YXRpYyBpbiBtbWFwLmMgbmFkIG1vdmUgdGhlDQo+ID4gZ2V0X3VubWFwcGVkX2FyZWEg
d3JhcHBlcnMgdGhlcmUuwqAgQW5kIGV2ZW50dWFsbHkgd3JpdGUgc29tZQ0KPiA+IGRvY3VtZW50
YXRpb24gZm9yIHRoZSBmdW5jdGlvbnMgYmFzZWQgb24gdGhlIGxlYXJuaW5ncyB3aG8gYWN0dWFs
bHkNCj4gPiB1c2VzIHdoYXQuLg0KDQpUaGUgcmVzdCBvZiB0aGUgc2VyaWVzWzBdIGlzIGluIHRo
ZSBtbS10cmVlL2xpbnV4LW5leHQgY3VycmVudGx5LiBBcmUgeW91DQpzdWdnZXN0aW5nIHdlIG5v
dCBkbyB0aGlzIHBhdGNoLCBhbmQgbGVhdmUgdGhlIHJlc3QgeW91IGRlc2NyaWJlIGhlcmUgZm9y
IHRoZQ0KZnV0dXJlPyBJIHRoaW5rIHRoZSByZW1vdmFsIG9mIHRoZSBpbmRpcmVjdCBicmFuY2gg
aXMgYXQgbGVhc3QgYSBwb3NpdGl2ZSBzdGVwDQpmb3J3YXJkLg0KDQoNClswXQ0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC8yMDI0MDMyNjAyMTY1Ni4yMDI2NDktMS1yaWNrLnAuZWRnZWNv
bWJlQGludGVsLmNvbS8NCg==

