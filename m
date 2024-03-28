Return-Path: <io-uring+bounces-1274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E6188F5EC
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 04:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A191B2195C
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 03:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FBA364AE;
	Thu, 28 Mar 2024 03:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SxzF5JJ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7320B29;
	Thu, 28 Mar 2024 03:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711596698; cv=fail; b=YObpfJACmMpYIbEsoK6FzTUFxFptz9Pp14A5vHSXhvaIu9GcpwzTOOicRYrTZiC6Ag00hU/ZqL4wcrKO6xNn0DcbLbB9FufAXCgu9Hj0BbRcA5kcTeuARceYT43NeyqNVbz3QgNLtbXbMy0fHZN19zwJB3rnZL9Qxa+6BfvrAvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711596698; c=relaxed/simple;
	bh=WxptMEdLRenuh61EZrXCblRn3K2BwdHOgP4XTWP2uHM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U498RweCxYZGd9AVXUpkhKv1NFZLVJBe8oE0uGsw6dTyR8sDtZ3RRNfq++aTN1bDi99Fn0kg4HGaIkwNPjWvDeW4QTYO1uRkb1lIcpZFiv1sdoUtoBIvIyJibXX0moEY+jljtlZMPvV8N6V7lfyIyHEGpaGXhl7WUB+n8pMy+P0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SxzF5JJ2; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711596697; x=1743132697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WxptMEdLRenuh61EZrXCblRn3K2BwdHOgP4XTWP2uHM=;
  b=SxzF5JJ26Tf4FZyGm6+iasNSUcQp8dHxYkwquWuSf7BCSXzW/UsXWePW
   Y1Mmyj1UM1A1Ile8N4aLKBW6jCPznFwXp8gU562pYeKHHR6dZUlEvV5gu
   zzQNDpYwjM6o36TBf5Hinz66shNa6ST6vWx3zprUIcfAsOndObkESgDat
   Rp0jH6SmBsowMjc0kU6BAohKP+QvkAvpfE14HEI1g0Q0lJ7jex4bjG7V4
   v0teMoavCucudDuND/sTpTuIh7ClNeyUteM+gkY5Ickn7Cp7erlDwSpOU
   lICBCkL/UEcTJRbsLmb7hCR6zL9pbJdXC2zQBJeQGNMOwl60tq1HmqDJj
   w==;
X-CSE-ConnectionGUID: 08CHtxGwT0yNKhwkuroSLg==
X-CSE-MsgGUID: ULn9lR6oSH2NM/dBYx76cg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17285364"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17285364"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:31:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="47711846"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:31:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:31:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:31:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:31:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuqhGjREsxGCcpvWv4YsFvAuQfOfQfo2XG8S6RHfflTOHulSjAl8VamBJ1AFnDxJYjTvjOqx1i7cBvBXaNcLrbnjG9uzLkiLDASvJfaast6YR9CYMlCBFWeKc3/lHQRi5kU0Bn9pS2RUtNDLgGbNp/fySlf1UCOx4XKraC08/yGp5QTeawqT+QRNDex7OxX+4AwNNcinEJP/1+GFBvFoVM+gZDJJvWoRc6sZltZe9hzcII5pP7J16Mzaclo4AvR0lfWEwjfqSeFYZjN2VXp00XTAVo9A0Q2kdZrgzdKkiNSltbmB2tv2tulboowQ+AXeAJJulOGzyeCVcjlp+bqGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxptMEdLRenuh61EZrXCblRn3K2BwdHOgP4XTWP2uHM=;
 b=ZIgtiTjkGNrVVaFPQkmE1nYEpkrsnJYwGk0YLtMyBQC88yprlG2soavbHz8NSOgmRMYhmupREyunjTFrMPMJhKOOn2L8wL1tC6wUlCRNGbYaGZObosomnzDhBdKdj6XtpbV3DXwLhRnbOQ2qbHwTHGK9/1tKFMXdf69qkfLZHaaJRVpZtaXCT+/XXSnjeRJE2T1tWN3aurL2wNoJW5oCO6hzk/FH4I9jJo8aa0RwkjQpjwO1Qoby+N6qLmCwwRMhjEPh7wgOJmduDXEjzMDN9VDCFzXiwlGGvuhb+KswW+J69oo4pg2wi/6e6GW5PpI/0F5rEwzu/4Zqy/k6Ufg8Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYXPR11MB8731.namprd11.prod.outlook.com (2603:10b6:930:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 03:31:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 03:31:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "keescook@chromium.org"
	<keescook@chromium.org>, "luto@kernel.org" <luto@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"debug@rivosinc.com" <debug@rivosinc.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
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
Thread-Index: AQHafyO9StMvuMMYIkm9Rry80msHU7FLJGgAgAFeKoA=
Date: Thu, 28 Mar 2024 03:31:32 +0000
Message-ID: <dbce0b982b71c563e282727c42d0719b1ae491fd.camel@intel.com>
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
	 <20240326021656.202649-3-rick.p.edgecombe@intel.com>
	 <6603bed6662a_4a98a2949e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <6603bed6662a_4a98a2949e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYXPR11MB8731:EE_
x-ms-office365-filtering-correlation-id: cf7a6d0c-d547-4f90-e221-08dc4ed79005
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUI4x5IERdjC5X/UGWRjV0D37NSI6lW2xG2RQ5qBAkoRbuhjw1O/+IMld09eN2hnUoVUDXQ7FydDHtXEM/Rxdjk4mzVzBu5NuSXvezEJ/92kwulrCbSPEmI7FCqtesryzV9bGCAJTjk37BTuWYlGhl4WRd+5BLmR2SUHHXOtW8KO//1LumAkZi1Gt06rcGthlkiLForx4TuRtxUp18K7tC1in3Bo9JzDnx2jhpQI6nh2ACXUnK+/+c/+jMHh+asQMfWtza+QnQFFI2O8MO4I85Buj5NIeM05Kr9yTUC6rz0zaJCw7HBikbs3eGFvBjQ3JHluR3CuyfZU0MV8RvDcHMY7b/XRQILi5SeU0/Ym2DK05Kclj08wLCwLKbdQGpFpRUe9rRAiswkz6x4gNUjvmBIXCn0UVAihR/CQ1rXxTr4b7QRO9ZvlfxlVfDG8TnAm6PuwjYGqeURczlbiwftOcQSzquvTiNkxVtpYhZchOdtH1UCFJCPaOcLneNBbPSsnHuof1/JfSlPE2IotQs2wAqMH2Gx6wfXXAZtvXPRN/nWVy/BNl/3JG5r46hhUNB+zYw+l6olb2ewGibe2yJgtSSGH94KyRhH7IEbjzu3YxaESOfVTHKAQnREQ/wXFVSnMgdH5TqG5EFOern0/OaSv4J8iXIPdDW6xu1e1DFu18MUKikKPCm2raWCRlCiBx5OPevGYYiF05EByTU7azFYnafYeYHD+wZBWXBPkELuDNvI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2xmZWVEQnIxNDFlTHJGL3lYTmVKTzVhQVFYTVhYZ3dtdWE5MDRBS09BVlpE?=
 =?utf-8?B?NlpKbllmVjVCWUtkTWVqUnFlVkREMUNxT3NUTW9Xb25VR2xhYWU3OVhmOEFn?=
 =?utf-8?B?dThsVmI0bStTQTJVQWY1TEN5TXl1eXlHM2dNOEdndzhad3BVdmpma05VOWNW?=
 =?utf-8?B?bjB2eEF1WXJBUEFnL3hrSnhWRFB4eDB6YU9JdTdNeWJLZkE4alFsNEE4R1Zr?=
 =?utf-8?B?Q3FnUzhHcDNwUUpkbFM0Um5HeTZaVEtEOUtaNlV6NzI0SU4wcmRpLzVEc3lI?=
 =?utf-8?B?ODhMY3hTbVNwK1k0c2lBVTgwakEwUFFvL0g2SGdjbEVwUFViMzB5WlZYdGdU?=
 =?utf-8?B?dzFSNGk2ZUgrVHMxQWlNTHFCVjFnU2dpa1JSWGJoNlFHQzB4ZzRKNktqQnc1?=
 =?utf-8?B?QTMvSVZ0Q202WnZST1VUcWhaNERBUDRLaTFTMlpVWXc5UUZxSmtRSW42amFv?=
 =?utf-8?B?cXQzS0gzS1NmZkVBM1YzOWVuTVRxYkdqbVFtTkdrbFYvL05iME1wTkxVblIy?=
 =?utf-8?B?a3lWMEJoUVQrU3MzZmpCOHltdWFQdVdXRzMzalFWc2YySnZ2VkJzeDdiRFFF?=
 =?utf-8?B?M1NPanhZOXNxb3UvMEVJVlhYbDJ0VnhmakIrcmJRSkUwM2JDMGRpS045dHBn?=
 =?utf-8?B?Qkxjc1RHMnRkNXg4WTBhY2pHdzh0RFNSdlBLbHlYU1E2eU9TMGZPcjNhZElR?=
 =?utf-8?B?eVdCNHBpYndJU3h4Q1dqbjI2MG9MSGV4UEdLcElaRlVaQlZJaTBsSGVSYmVC?=
 =?utf-8?B?Z3FzQ1RVbU1UVDJsSmpEVExxYWI1djF5T0RQY25XY0ZoY2lvT3NoQXg3OFZo?=
 =?utf-8?B?YW1DVjVEL1MxNkNzZ2ttWFlkeGlIS1dKcHpCeXVacWhZQXdYT0gzamx6UGhx?=
 =?utf-8?B?YkplMDkrOXkzTTFpODVKT2QzVlgxYzFyNXd4Q3ZGRmxvQWh2cXRBYSt2MlR0?=
 =?utf-8?B?dUw1QzIzbHRvMjErd1lrUFVSWm9CK25YdEoxZE4zaW4vSE4zcFBmdHhwNlBR?=
 =?utf-8?B?RlZvVkYvYWNxcEwyUzNZNE9CUFRyOTZERXFrT2l2MW5qdi9yU1YvVFdsQXNq?=
 =?utf-8?B?WDF6R0szNEd0a3JYRjB2VEQyVndZZHJLSnFKUzhNNmRMbTZoeUd6R0I5MFJh?=
 =?utf-8?B?RHJtMk5XdmppZGZtazE2QTREM1AzR2VPSlErWkxVbVRZNGNyUTV2QnVyWndT?=
 =?utf-8?B?TlMvakNCTEVWRU9QOGNlc2dUMGpMdGJNUWRPMlREc1ZFcVh5R1JDbXl4elVx?=
 =?utf-8?B?ekk1RUc0Zm1qblI1aWZpT29DQUlNeDBXUjdPWklFcWpKR3FXbFJ4ZkhXZTd2?=
 =?utf-8?B?OXhEZjJZS1JPTWR4YXVIM0gvdDdZd29Ca2MzUlZqRG9NQlpnSWRyZUt0aW16?=
 =?utf-8?B?Z0tuNzUwVkU2NXliOTBBek9xMmJDYUFKdnRjS0hCeFZQV1dVcU1rbTZtNkRK?=
 =?utf-8?B?L0h3V0xBOWwyY2pYc2ErMDhnQlhySjQ1Nlp5ZjB4ems1UEZaWDE0SlZYd3BL?=
 =?utf-8?B?bzZDYk1EMUJ2QmR0NkRaZy8xS0h2SjRyNjZaSUZnZnRFdlFrZGpyNXJFQk51?=
 =?utf-8?B?TkpUZnJYMHdGV2pITFM5OGdSeFVMM3lZVm03dCs0bWYxZDFRTHNHbWRjOUtt?=
 =?utf-8?B?MmZRdFFzMS9aVUJGUERoK1ZMTU1oWHhhNjZwRkRqVWdWT3R4OVZDMEJNdHVH?=
 =?utf-8?B?Zml5UTVJdEp1Ylk0ZTNwbXpWUmlCRlpFb2tOKzhOQ0huVHJrTEE1d1ZPcWh3?=
 =?utf-8?B?YU1BU1Uza1VDVWtQa2g2U0FGdmZmNlc5RkdxWmpkdU9wUkZmRFJsYzMxN0x2?=
 =?utf-8?B?TVl2ZFh3R0l5SGlUeWJmbUU0T01zNGtmVy9wTm0zN3pQVC9IUDUrK05TblAv?=
 =?utf-8?B?bTFCSjg0MEgvRHhUYXRwL1ExVXozZmV4Qm5IdjhqNXUycUF5WU85WGNBVlZw?=
 =?utf-8?B?bkY3dmlBTDhxSUU5dXpOOExLeGMwc2E0ZlJIcHpWUW5zeVVNMkVHcmdaTWJE?=
 =?utf-8?B?eG4vT1p0dk1xYitNcWpZcEtHdTVLZlhNQ2JlZ29SUGJQZXRFMW01RFlxdEk3?=
 =?utf-8?B?TUsxMTJCZXVFSnFsVVFwUXcrc3ZJUUh1VER6VzVvMUYwbVlJcnR5WlZxZEEz?=
 =?utf-8?B?cjRlN1lWMjNzN1hGdm93ZVkwb3FKU053NGhkWDNGelBYdHJ6dGNmVDdSZzBP?=
 =?utf-8?Q?f8FNLP3eG/mi1FbZYkKqFH0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C534C69410F28409FCB46161624EBCE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7a6d0c-d547-4f90-e221-08dc4ed79005
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 03:31:32.0745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bw7Ks61N6o2k3T+QpZVB+uPN5VYRpejoiU+5mTXZLlM0jYt8BBrrfIwb18p4BKX4bhJPXFo2wm0dWisFa6CZHCRarc2dUA2gqKy93tOiE6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8731
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTI2IGF0IDIzOjM4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
ID4gK3Vuc2lnbmVkIGxvbmcNCj4gPiArbW1fZ2V0X3VubWFwcGVkX2FyZWEoc3RydWN0IG1tX3N0
cnVjdCAqbW0sIHN0cnVjdCBmaWxlICpmaWxlLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgbGVuLA0K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25n
IHBnb2ZmLCB1bnNpZ25lZCBsb25nIGZsYWdzKQ0KPiA+ICt7DQo+IA0KPiBTZWVtcyBsaWtlIGEg
c21hbGwgd2FzdGUgdG8gaGF2ZSBhbGwgY2FsbCBzaXRlcyBub3cgbmVlZCB0byBwdXNoIGFuDQo+
IGFkZGl0aW9uYWwgQG1tIGFyZ3VtZW50IG9udG8gdGhlIHN0YWNrIGp1c3QgdG8gZmlndXJlIG91
dCB3aGF0IGZ1bmN0aW9uDQo+IHRvIGNhbGwuDQo+IA0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmICh0
ZXN0X2JpdChNTUZfVE9QRE9XTiwgJm1tLT5mbGFncykpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiBhcmNoX2dldF91bm1hcHBlZF9hcmVhX3RvcGRvd24oZmlsZSwg
YWRkciwgbGVuLCBwZ29mZiwgZmxhZ3MpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBhcmNo
X2dldF91bm1hcHBlZF9hcmVhKGZpbGUsIGFkZHIsIGxlbiwgcGdvZmYsIGZsYWdzKTsNCj4gDQo+
IFRoaXMgc2VlbXMgc21hbGwgZW5vdWdoIHRvIGJlIGFtZW5hYmxlIHRvIGEgc3RhdGljIGlubGlu
ZSwgYnV0IHRoYXQNCj4gd291bGQgcmVxdWlyZSBleHBvcnRpbmcgdGhlIGFyY2ggY2FsbHMgd2hp
Y2ggbWlnaHQgYmUgcGFpbmZ1bC4NCj4gDQo+IFdvdWxkIGl0IG5vdCBiZSBwb3NzaWJsZSB0byBk
cm9wIHRoZSBAbW0gYXJndW1lbnQgYW5kIGp1c3QgcmVmZXJlbmNlDQo+IGN1cnJlbnQtPm1tIGlu
dGVybmFsIHRvIHRoaXMgZnVuY3Rpb24/IEp1c3QgY2FsbCB0aGlzIGZ1bmNpb24NCj4gY3VycmVu
dF9nZXRfdW5tYXBwZWRfYXJlYSgpPw0KDQpIbW0sIHlvdSBhcmUgcmlnaHQuIFRoZSBjYWxsZXJz
IGFsbCBwYXNzIGN1cnJlbnQtPm1tLiBUaGUgbW0gYXJndW1lbnQgY291bGQgYmUgcmVtb3ZlZC4N
Cg==

