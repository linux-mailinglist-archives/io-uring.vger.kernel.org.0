Return-Path: <io-uring+bounces-1275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B4A88F5F6
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 04:32:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A74F61F2560B
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 03:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C5E32189;
	Thu, 28 Mar 2024 03:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MIwxsbWb"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3C1DA58;
	Thu, 28 Mar 2024 03:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711596756; cv=fail; b=W7bfLKgatxQXRf7kT9cGHccj1IP5Kyef4PLA5XbBz6CKVJKGGHHhdY3M9Fo/n1Ix0Z67HMhq4/BzZsl5Gnwh0Pgf6QcUNzx3d8NlLZMhLz1z4DUqtVaJg9dqJl38VwOaS43Km2lm9Ni8aOzdBJT+7px2kH87vdreu1i1A3gcVEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711596756; c=relaxed/simple;
	bh=Tr2Ltw1YmFe+DTdS4PeZUtno3NM0r2yP3OiwFqPFLfI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=niOU6eemxJzWET29BQLeKDI+apWoVCqaw8yJ7ta29Ouvs6zitrQyX+aKaMwKtIldkV4KQbWUCTiq6Yq5HuiDHhNdD8TYzLpOO5K9T5YDE8FQFvBA1CSuhL8PbSjwndZGHwIOa5a7NAVrwFH4WscGPrdBuQVnlICVRnZ4AqWRYbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MIwxsbWb; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711596755; x=1743132755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Tr2Ltw1YmFe+DTdS4PeZUtno3NM0r2yP3OiwFqPFLfI=;
  b=MIwxsbWbPxQcWeu1RUSfheQLXmKczc4ruWiaJLjWZsaa63rM5fw2dvPX
   zUoidsCzn4UA6mnPc9G/PYLu+DbZihr94LHB3ErFgbfm1z7aOWkcPrXOq
   KJgTxrJUN0Mrg0awG+XI3ORBSjDxJ9TMf6T0ivMJKNk8kNCkLWwtDqqnd
   +bto4jdzxu7TUyGC98my80z+m0RLz5Nyi2pHuLxzPw/h9WwMvy+mrajeS
   ZKkv7TQ8d1Ihk4hcZxEkwDPagRoWfT1psrX/J3g5DlejhX81tbqFoi6Aw
   IM7ZvtWFpzZeo1mFZfo2pSoBiHQu1/s3W9HnWjivlLuZGkMlqnPCmiZ/t
   g==;
X-CSE-ConnectionGUID: VNIn6FkUQqWQm9U5Iv+BFg==
X-CSE-MsgGUID: ErlFYIh3Tdy9KMtIVmTC1A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17879516"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17879516"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:32:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16905185"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:32:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:32:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:32:33 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:32:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFHdjXa171sw5US8vC/ra/0o4TKlCoxoaklMl2JVryCqaM75FM+HqjpjIICdcRPRn83SjiS1g23TzqorLrs7VzgKTbDS3VqC/wL6Spf1qwyUmWoQbsttFWrb1pSwEOvlHoLDlIzItCE5kDTZ9/kc4pf2NDsg/7b0U8f50+UP8vXFsH0IWWe2QCF6bA2fyfX2339K2oBPSQY/L/uMwpqn+2S1//2HU7xdnauf/bQqOdjiMgiMpNkidB8a+ATxUoyJUT48TcAxL47W60wSB4p6Zw8xWyOfC5JV6T8KlWQfmvwSDlLeMHQGNOcitnzxLX96uR2gFP+njnsp0IwcVSuksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tr2Ltw1YmFe+DTdS4PeZUtno3NM0r2yP3OiwFqPFLfI=;
 b=bXw0O8B8uwx9QfaaWKZ/lxv1RmqM7+sB5TrPY+Xd3+8bXSD83jmnqdr1WHI0B2HLbMiBUFDj35ITXXp0RCNthikp6KFo2xiZsjF3wsu9xN1NkLb4hwgg15HvFNYfpgmsM/fT4gSdnX1Cp6ZHXdjMcDRjYnZI3Yh02oaN6YBkx/fk4wfkbSqA6pxzeKy/TyU7Gkon5CpG1fgas5U75uqcxXGxQA6hcSRHKkVYChMIZxX2kowaCaIabSSd64lOoQsO59APBZeor1GDYx9Svc36aRbwBdTEVdYn5lpzpaMCBPphaj97OM6GJ8S8thz1+Q7K/A74xkGbn68Jvyyyq0lYfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYXPR11MB8731.namprd11.prod.outlook.com (2603:10b6:930:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 03:32:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 03:32:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "keescook@chromium.org" <keescook@chromium.org>, "luto@kernel.org"
	<luto@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "debug@rivosinc.com" <debug@rivosinc.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
Thread-Topic: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
Thread-Index: AQHafyO9StMvuMMYIkm9Rry80msHU7FJ60+AgAD3UgCAALC2gIAA73oA
Date: Thu, 28 Mar 2024 03:32:25 +0000
Message-ID: <318e1125ebb852d5132393e14d35d267e9f75c0b.camel@intel.com>
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
	 <20240326021656.202649-3-rick.p.edgecombe@intel.com>
	 <D03NWFQM9XP2.1AWMB9VW98Z98@kernel.org>
	 <5b585bcced9b5fffbcfa093ea92a6403ee8ac462.camel@intel.com>
	 <e15019f54d26898e4b67b84c331cd52d09427258.camel@kernel.org>
In-Reply-To: <e15019f54d26898e4b67b84c331cd52d09427258.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYXPR11MB8731:EE_
x-ms-office365-filtering-correlation-id: aa73f0c7-6b0b-4aa5-1905-08dc4ed7af9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /3UdwnvENLLgwmZOV/tqrSn2Y+Lh6Vtuh0kKHfyUsu+79Su8erXqtZn+c2Bf9alQ6fPJECLFvBoCVR87/2PCtODmcaLZmVuGCQk3UCJ1IRjbaUgFPMz+cm50jPis+GDil56R9fCeA9LqYT5t2fiPDmRdVENx0bvHf8rl0jvAAx7y3PnLBj2Tplrd6sdwHTsfulRVFVGZ/05CUZ1L2iIeuWJoVk2lLIxTVc+i0a8B8IG/3HUc3BPuNO3m1/e8M9j808RoO3jyFQ8dh6stHhVDWYI/gG3sef4lUyOyHZjHFeol52dTO1sZsEJIVSlYVbp7CqJMBIT27QS6Nb+IlSwG0yB7JAGdUiYOnnGblgWSC5X760HXGxD0sxUa+RMETpe3GYxJiq69ifsKSRFngS1APgA6NpBzn3QSlL5r0VQbRTs56o/90+JzNEy6qgVdEc5yRVwEgRtBunO4XhqoilNbhr86cd3P2uVgXouqe/8AvZ+4emml09IrjvabIRIuKYzcHLN6EY48aZPuq166mSVl8OBNRZ/XpgisK17mJuy0kRuA3tmEnHgqX4Mo8R8IzPwbB8ToNSkH8iwXhuQpWo53zbdS76UFO7yP0fJPnc0J5s6TSI+Bzeil4QRtIJqTpBTdBj/ssJaQIcRBPYJdg+a3MAa5HNV86z7tC4SuIaWGAN3oGla7LjR2fQdu2E0tvwQ9k5VXIeqpkAWdXjGPyYTVnidENFqnS8hw57nTquDT9HA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHFJZUxIaUMrM01OSFhJeHpqSFdVUS9vQnI5MXhhR0M1QzhIVG9OOWREMXRQ?=
 =?utf-8?B?VFk5VjZOTnBsZm5yVGZWYm1GK2VjdHI2ZlRhQmdFdjl5WTVoQmF0bUh0alZq?=
 =?utf-8?B?SDlWMW5rSWo4dHZQTldWcE5UUGdETk01WHdaK3hMTXk3ZjMzdmtldDZHMWNm?=
 =?utf-8?B?aXRlakl6cUFpNVJIc084RGV1QndKaEFrK3VKbTE4bjZyTTdWZTJqSkVjRE9D?=
 =?utf-8?B?Nm9UTnhCSVBIaUxJRUYzUm9HQmttVWVEUGJFZ2Rxb2VHZzBzZTRaQndmU0RG?=
 =?utf-8?B?bG9JZXgyVkRrcGZDRG5VV3VOQmNRQ3FLUWo0WG02Z2lUTUVac0Y4TE9sMlFG?=
 =?utf-8?B?WHU5ai9pdTFDTXR5d2xkY2x1UWNpWERJQkdFOWxlVHZzdFdRaDlJdXo4R1U3?=
 =?utf-8?B?Mk14M01HcTRxK1dyVkRtQVZTTW9JNWhsekVFbzVlaG44V3Y1YmhJOGd1QVc3?=
 =?utf-8?B?UE1KS1NlYk14VUtUS3d4VlR4dXhadEhWd3pnVnczcHlFa0dmNkVTeGJaSG1C?=
 =?utf-8?B?TGxiMWE5WjNZL3kvWkFFais0aktmNkhtYW5MRWpNcmdKdENQcjNtZzFXNmpQ?=
 =?utf-8?B?Yk9DVnh4cjJxRkZzWWZSUUhVMkx0OVIvT2RTb0V0bXI5MlM5azMzK0VHM2Vj?=
 =?utf-8?B?VGVGcm9ZejQ2VVQ4NktuOWthZ1F5WXhwUmNwUmF2dmo5bkI2Vk9rSktyTTRv?=
 =?utf-8?B?SFJoc2dwek05ajE1ZnJLaGtKa0RnR0xzVjZ3QTRzYVF1Slg4T3VyUXhEUUh3?=
 =?utf-8?B?NDF6Vml3K0tBQytSSjJZd2VCbkV0UjZQdnB5SlhXM0xMVm1IcktLZkEybkFt?=
 =?utf-8?B?M0xMcnFXUHN0WlFaWHdPMjdoa3pmNHRTRWdiZmQ0Q1J0ZXQyNXZvMWpPa1Nn?=
 =?utf-8?B?bk9PbUtFVkJVVVh1V2VlRys3eGZ0OUVZWFEvWkVuUGlodFZXQmpkZDJtSmJ1?=
 =?utf-8?B?aFFhQ09vQnlFQ29mMnFaS0trVnoxYU1WaW11WVVrMXhxcUc4RkVLMnozMzBh?=
 =?utf-8?B?eHEwdlVNTmZicUVIZEV1N21OZ04wMk1URU5xdUlzQ3FxN05PeFdSRm5rbXBV?=
 =?utf-8?B?YUZreVBZajFoM2x6bDRuS2FXQnpIUGt1emJkOVR0alJrWXg0dzNrTGhYZVVr?=
 =?utf-8?B?ckYvWFhHOWxHVDlaYlBNK21Rby9udFMzMzhTRzkxZlhCckhXMGt0ZmZwN215?=
 =?utf-8?B?ZHVSUGVGMGx4L0pJR3ArRWV1eTNvVmRpbTFiczZwa1dGSVB0UXRORFdFeWZU?=
 =?utf-8?B?b0VORHJLZzdUTmVuRnNBdGo5dExad1k2VzF1SStpak5SZUk0bEFoSTRPTU14?=
 =?utf-8?B?NVE4dFhnSTJ6LzV5SDNJczVqaVVLN2YvU3VqZmJqK2F3V0traTNyWmdvcmhv?=
 =?utf-8?B?RExFZ2pyR0ViVE1EVW56bnNRaXBTWm1wVEdjUGN4VnF3K0F5cHJtZ2RlK2wr?=
 =?utf-8?B?YVBKU2swY08veFhxQ3dmNkZSZnNrUGt4TnlFUjlsL2VIbUJNQU9TWVlaY284?=
 =?utf-8?B?cHFKbmFSWGZGQi9QTkF0eGxrd21jV2pGMnFRWURUOWZYZWFxM2tROG12Vkd5?=
 =?utf-8?B?WkE0aEJvWGRCeXA4cjZ6SnZpbURXR3FEQThiVGVENFNaS095TUhWMU1zTjdY?=
 =?utf-8?B?ZCsxaXNnY0dwQnlFVlhPZEFKeTh4ano4T3FzcXNFMDNlQVVwbTZsSWhVeGNP?=
 =?utf-8?B?NjlnMEpWbnZNcVVadGc5SXFnVkJiZ2dKUW8rVVJ1azZxTFJOQm1zTldRcyt2?=
 =?utf-8?B?YTZKYjFDNzNlRms1cEFTbDhYS2RUSmk0Sm5TbTNsVzJDN2IvcDM2MW5oTUJz?=
 =?utf-8?B?WmNhcVN6MjJ2L0d3RDdQZFgzSHpxR0JzUm05Z1B0d3ZleVJhZy9YNVptOFA3?=
 =?utf-8?B?cFlNVTNBWmhxS2ZxczBxYXdSczdMK3NnMU9BVlEzZzA1cUs3Q3RvQkpIZERw?=
 =?utf-8?B?eDlPZCtrK1JSSDBMaHdTMVl0eUVLbFpobmZ2RGU1aGV1Y1ZZN1doQjFtekJ1?=
 =?utf-8?B?MUkyb3VKRVliUnV6ajJac3Ivc3h6UXg4dnlkR0VuZVdocFhOYnY3MmJiQ2pk?=
 =?utf-8?B?T1lTbnRmM2piVFdHdE1td1ZlZ1pHbFM3YUNyeENMaStENkIwTG5EZEYwQnJn?=
 =?utf-8?B?UzE3clFabEl2TUJHbnlJck12akJwM3pVbVZaWDZaa3l1ckFIRmFZWmNUZlpw?=
 =?utf-8?Q?l+rIWhv8ZLd9JKwMS/ImX9c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <787875CB7CD0624F977A32BD74D270B6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa73f0c7-6b0b-4aa5-1905-08dc4ed7af9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 03:32:25.0603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMpPHKlvhliF8BtOechH6+E/KQQL1B41K1cS1ZOeO0YxXxpHbUTPHRrZAChKtQqT20JklqVm5yIqGd0sCG48TvQSaiu978WRrXxG1kNYRHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8731
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTI3IGF0IDE1OjE1ICswMjAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IEkgbWVhbiBJIGJlbGlldmUgdGhlIGNoYW5nZSBpdHNlbGYgbWFrZXMgc2Vuc2UsIGl0IGlz
IGp1c3Qgbm90DQo+IGZ1bGx5IGRvY3VtZW50ZWQgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLg0KDQpB
aCwgSSBzZWUuIFllcywgdGhlcmUgY291bGQgYmUgbW9yZSBiYWNrZ3JvdW5kIG9uIGFyY2hfcGlj
a19tbWFwX2xheW91dCgpLg0K

