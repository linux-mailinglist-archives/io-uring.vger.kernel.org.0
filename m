Return-Path: <io-uring+bounces-4601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCFB9C3B23
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC10280E0F
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 09:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55DF14A605;
	Mon, 11 Nov 2024 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S38CkVZl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dw2C1MMw"
X-Original-To: io-uring@vger.kernel.org
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9B2224D6;
	Mon, 11 Nov 2024 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318222; cv=fail; b=b3tsikb9uGOk134RtftLVbNWCbDsClfQO4dTLINtANOgCJgpeg1eNQn2lfLl5KB103541MR8VmUSwFzzju1C+LVRy9aS+u0E+WUXAMRZFZRRabRsSoNATvfvQRAGDytSCanpO3vrSm2k4yztuxKHtEAz1h3+nNZjtYeKCc0EY2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318222; c=relaxed/simple;
	bh=J1Os/4E37F4jGgyVqXvHLY6RhRZ1Wvi9ACtBkcTjyF8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N0YsryjdhVxoz4lgpfLX2K8qUrECdxhXVb4pi3pCTwvq1tOEgaSJUNVrjtO2v2FasZ5i/Q37pPLotbtOoxOVkTuqs70u1DtzFViXE9KRuWScuoUNFOPhKP3yVH9y3m+0er39xTLR8cnb/lFTgMCnlUcaXaomgCkzv+6HuLNOJeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S38CkVZl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dw2C1MMw; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731318221; x=1762854221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J1Os/4E37F4jGgyVqXvHLY6RhRZ1Wvi9ACtBkcTjyF8=;
  b=S38CkVZl1zo0zPmUe/hIKuGUcGkWprwmgFl873iqC99io3Np8L67tpA4
   gvTWyP6YIYvbtCwAbp6lOXiIz8k0CTeL0Vs/b42lgvVffqdi9ZZ68vAdi
   /6aK6g/aLCAlm7lSohnJ1dnbS3E77/6vL6XPGmRTlCEGj9sKsx3Ih15d1
   lcNdRtiuPEZ+6hPf58dqA7L7Jqh1BvaN0+ylXRUXKSEqEJce4c+ELLl5R
   VsRzW/2zuRZp3cZ4CwQWC6ir9RDMTg9HtK+xH6HK+M6s1r1ZxC2XYWstw
   5PAuQTCVkAiM8pqUXFyUL4cUWHGlPZyrgfadobvexH4D2vGCEQRArMIWi
   w==;
X-CSE-ConnectionGUID: 2rv/p5L3SD+Jfn5qUDYUtA==
X-CSE-MsgGUID: Msrb53GVT/eDra3AT4UQbQ==
X-IronPort-AV: E=Sophos;i="6.12,144,1728921600"; 
   d="scan'208";a="30540049"
Received: from mail-westcentralusazlp17010000.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.0])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2024 17:43:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWxBT7UuV/Fb4DrVmEymNpTsxOg2J7RkJgc9cg1lFSZG1yYAoG6On+0iuFRp1+hfkte38cqAC+kS8l1Xq1tEKRUvrCLyN/hi9bgrWr7fqRAmV4Pi/R0tVZibk1VB1KYqfcJlnp+Sa3PikPTzqOMYc0gSBZep7Q0CO49D5KgBVPqUjTGiTPnVGIMeD+j29JgBheOQ1CaGDA0Z0J3+Wn69bQv08kWM39wA3Qhr3EBWs0739XYCtja/g2n0Yq6l6M+3pC2JaIg+LjaBm8mk4AaLpKCGlJcG9/mHd7Kx0EXAO0w4OYK50q4eB78dKa/bNjl5I6I/npLF14W9YurY8ZaB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1Os/4E37F4jGgyVqXvHLY6RhRZ1Wvi9ACtBkcTjyF8=;
 b=Mq1ahdoLjHoQEjJ2NoUvjDt0IL8X5ADFUWZ3pBvDMyc9+gGWyifEUlUFJUWmsgVlO6EtDJQz1qv0Lnv6V/5OfR38vtjYTd+awqlFea4RiNNqrKLVA3eUr4UHHIUVG8+Oo/1Tm0E7K1RV3IfLSs02wS7A1lB1WeB1G0a+fUCJF9TQR7IFVAVQU6NcKgu/gJxIElMVUP95JX54ruJaTdscV3HCgb29jhj8XamRjZQZHuE3Y52km5RNNdawo7M116xR/YmNk7CrlLci3FMJgj6eSVhoeb94NZHGQ8ny/PqOB4DqdyY2tYvMfsb1KKZotfTTmbQdctDhLoIqZpe04irniw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1Os/4E37F4jGgyVqXvHLY6RhRZ1Wvi9ACtBkcTjyF8=;
 b=dw2C1MMwLjjE+MSLCGaEOyxwSzDinhNc/1UYGu/bHAFFVkgx8BpW6YPq5tO1aZ+CDeNOUS68j2E0k4aQiPlRtCz8aRqCVovrafzJYPTTWcG/oeow7PzPys/vtSjutW8/4isXh8vmEyMwbiiOah6TWT5zEF4+dOXh2miUnfAo/Zk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6740.namprd04.prod.outlook.com (2603:10b6:a03:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Mon, 11 Nov
 2024 09:43:31 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 09:43:31 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Javier Gonzalez <javier.gonz@samsung.com>
CC: hch <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Keith Busch
	<kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Thread-Topic: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Thread-Index:
 AQHbKhYzHqfk+FHNy0OApJay8pJjFbKo4KEAgAN0q4CAASjNAIAAGeOAgAARnQCAAA29AIAEANkAgAAsYACAAAHdAIAAATCAgAAAjYA=
Date: Mon, 11 Nov 2024 09:43:31 +0000
Message-ID: <5e29b698-e09e-4819-8be4-04ac1bd94142@wdc.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
 <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
 <Zy5CSgNJtgUgBH3H@casper.infradead.org>
 <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <20241111065148.GC24107@lst.de>
 <20241111093038.zk4e7nhpd7ifl7ap@ArmHalley.local>
 <81a00117-f2bd-401c-b71e-1c35a4459f9a@wdc.com>
 <20241111094133.5qvumcbquxzv7bzu@ArmHalley.local>
In-Reply-To: <20241111094133.5qvumcbquxzv7bzu@ArmHalley.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6740:EE_
x-ms-office365-filtering-correlation-id: 58bd7985-573e-4589-6730-08dd02354dd4
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cVFpUzVVNE0zRW4xdTFNS2lmdlBmZDdQYWpRNlZiei94M2VLRExmRDdsS3dj?=
 =?utf-8?B?aE0rVmZuTUVmaDduVk9pVXJ1NEQrQ3E1d002MXc4a24xRDYzSXJyaFhKWG1p?=
 =?utf-8?B?QWYrK2tpSTJCNklOS3B0RGJESlZab1JVYTN0R0NNVnZCRzFQWncxTEVLVWI0?=
 =?utf-8?B?VFZMMFJxV0xGaFFrVXRFNDk0VjZJdlZYTUhWcE9lYlMvTHVEVWJSdUtoN0p2?=
 =?utf-8?B?UUQxSTJRYVJ5U0NST3dTYmZ2YTNTVHhZQ1UzTlViUFV1clM1aWtaOVBLZW9u?=
 =?utf-8?B?SFcrVTdpZGpjcUxqNTN2Z2trK1lBdUo1ZHhCUmg5aUM5MDE5R3JoQitKaUFK?=
 =?utf-8?B?WlhjMllJWEY5ZjAvcW9UL2JjQXYzSnJDTVRmTC9RSVNVQkhkL1NDWnJ3Q00y?=
 =?utf-8?B?TFlKOExHeFI2V1IwUG90U3hoWTVPNDJRblFyc2kwRXphQ3BCQm9wUjlxYUZU?=
 =?utf-8?B?R1hmZktiT3FoYzlxdEtPdUYvYjBubGVZS1EybzRJUFBrMmIyZm1VbFp6QWdv?=
 =?utf-8?B?WCtsbmtmR3RuUVYrZFhFaXk0WjREQ2lqblNUQWpjNlpKQjJ4amwwT2RDMFJL?=
 =?utf-8?B?QlcwY0szOUVFVWxwNnJZVEQ3UGJVczV6cVhMSHRHekJBb0xxeHZ1cDFTS2sw?=
 =?utf-8?B?ZFlxODRwZllRTGNlemVxU2pWUUdFZ0h1Rmw2eUpHQ1gwcnp1dldwRFJJNE1k?=
 =?utf-8?B?WUJGTEx4bk9HdFYwU2pXMXE3M0ljNW5zSmd2VWtUMHdGTTd4M1pRKzVWc2pU?=
 =?utf-8?B?RDM5ajlkOG5HYlEwbHQ5QWtvZHF3cG9xcjFqcUxESkF1UGR6R0dGWFJXSTBU?=
 =?utf-8?B?Y3NJbjJKQyttVzJuU0ZWd2psL1pxcUtkKy9PN0FXL3QwUm1UQ0dYSDllY0Nv?=
 =?utf-8?B?R2Z5TjdDbUpRTXZWM2ZHbEVnaVhIc3hTQmphTGc3TTlYSldWU3I0MENRanJD?=
 =?utf-8?B?YWxHbXdVQm4yVktFb1dKUTdVNWk1UVpDVlJ3S0ovQ0lDeGlvbVdvZk1wV1U1?=
 =?utf-8?B?WDEzby9ObGw3b0hScktFV0M4Y3lHWnhoZVlFbVRpNDBPNTlrc0NJc2tIVVUy?=
 =?utf-8?B?djZLS2FMV3Rob2Z3TUVydXVsR3B0YUNtUVZLZ1NHUzQwaEFza3Q5SFdDck9k?=
 =?utf-8?B?a3o4VTJCQjh5cFlBeDlwZEZzSGFVZW9qNDNhVER2MnN3NGFocVEzZ3NJNDlh?=
 =?utf-8?B?dW1GNFpyQVkrVkFla1ZWYWhzR0RwdnYwcVNZeUpjQTBmejB0MGFQMzJoc3Qr?=
 =?utf-8?B?TGhQeHUxZ1Y1dWtKajF3RWEvYjhLM2ljR1A1K2xJcm9qd1lWS3BoNmRIVXZL?=
 =?utf-8?B?VkJCVU5LcG5XZStsME16ZTVmeExvUWVBTU9JSzh0emhnbTc2MnllSFB2cFVU?=
 =?utf-8?B?Y1h3d0NSYTQ1SUZuNVB1WVFicUY2cFhKTHlRVE9sRzlyVncrNDA1aXp0VlF3?=
 =?utf-8?B?c2NuL2JyOWtIc3NXSXBpQWkwTFFEa2VmNHRtYjg4QjE3RERlbHUvMlhnUnY0?=
 =?utf-8?B?STBWd3BIL1lvYUVRUVNWaCtIU3pyQjJ0ZjJEckdYeCtXUEptVEhtWDVqa1ZS?=
 =?utf-8?B?NUZzVk9EbFFmZ0I1a014MFk0QWV1OU1zZ2JlVXJ1aTFKanBKOEM3TWhCNk1m?=
 =?utf-8?B?M28xT2o1eUovTjF0bG1EblZsWTJha1FzMU1MbUFybmtIRmlKNEtJYTB1alFG?=
 =?utf-8?B?Z1g2VHRtcXFQZDJ4cm9wYkMyZEZnMkFteGNYMUN5anY2ZnNGc1I5U2RjOWg1?=
 =?utf-8?B?ejFoOHhKejlwaUdzcmh3YWtGdDVxeGhPdVladUkrT2lmQS9kcHYvR3E4WC83?=
 =?utf-8?Q?wsM0VxMEcoym37X4YETAYp2EMf1VOkiHh1/CI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VzFLdUNNQTlqMkJZdU5MRUZNejdueWZIMkxaTXFLS0hhdVBQdFU2TEFMMG13?=
 =?utf-8?B?cjRKaC9SZW0zVjFGeS9mSkk1RkZlRGVHNzBITE1sZjk2dWlhWkc1K3J3Q0xx?=
 =?utf-8?B?YzE2eDhrQzFYSlhkV25kUjRza0lrN2JNeTEwWjRMQWtZZWhxNERJZEdsZDUv?=
 =?utf-8?B?ZW5yeTB1TmNnV1hwWnNhTjk0VDJTTUVQSDFzYjdaZkFOQ1kwVGhpV1RUNkR6?=
 =?utf-8?B?VWdWblNpcXI4dVdid2lZQUJJcEh1RlFvR0NKNnRBWXQ5dVAzZVpYdVI1YWdK?=
 =?utf-8?B?cUxxck52ZThRTW1HRXhNM2RkS1JlWURwZ0NycVR0ZG9NOFdwRmVvejUxVWVC?=
 =?utf-8?B?a3RaSEVxMVJDMGJKbXVTdVEvSXdzb1VPVC9hSkhzaVpRTTh4QjdMOTZjVWFP?=
 =?utf-8?B?dUFOWkxYeGpNQ1prNjgrbjBUTkJjV0REWFdWRHBaT2dMSFJlVFZvRHE2Rlo3?=
 =?utf-8?B?eXN2NXo5cXhRSW9VYy91U3FuekRpc3RRanhZZkpPdUVORDdKc1VuQlFFUGJO?=
 =?utf-8?B?ZGxkanIwS1Zsdk9Vb0lVVGMyTnFQVkMxMUJJb1BiWFh2azREREpFWGo5dXFn?=
 =?utf-8?B?ekdMaHFPTFR4cXBHc0NRSzZMcXZ2MEFINnhLNFZtS2xmYkU4a0dVTVpoL1BZ?=
 =?utf-8?B?TkU2alF5anFtY2VURGd5WUptTU1vVC9GeWxnTUpNcHM5VFZ4TkgwZDhQa29t?=
 =?utf-8?B?Q0Zldmd4ZzVudW5VVk9xdVZFR0hlWDltekdVVHEvY05oTkFCWkJpTWI1Ri80?=
 =?utf-8?B?UVdUOUxzTnp0cEZmNTg1MlhaeEFaVTN4S3BWQ2N1QnZTT0pTOTJ4Q2VWek53?=
 =?utf-8?B?aXk4TzFpRVdwbzB1WU9YTXAwNEFDdnpqYytZdEdTUmg4TGRUb1NVUjY5TmxX?=
 =?utf-8?B?VWV4a3A0bS9HRGlPZmdTYnJCRi9ENURaYWJSaEFKa1AzbkhzRHBGazJ5b1FK?=
 =?utf-8?B?RTBBR2dscS9iekIrMU1UekkwRFBCUHBScVJUNjhYU2wzU0JYdFh6NUlYZWtt?=
 =?utf-8?B?QloyOWZpWHI3NTFVTnltN3NGeEJ4UEhQV3BCTUd5Y1BwbVNQTmpOV3BXUEdU?=
 =?utf-8?B?cWJjajRkU3o1bjc4VkUyRU4rZmplakhudFFGT3lGUnJYbXNNY3Z1elNGOWM2?=
 =?utf-8?B?M1FQN24yaUNPV0l0UzBaSW04TXJ0NHdndUE1WEx3QlN5WWlIajllMytDa3Ey?=
 =?utf-8?B?MHZ3Qjd6bDFuK3ZRRGVSU2VSRFJkWUQvWnZhUkIxSEpZUUcrV0NNamkyU1dF?=
 =?utf-8?B?b216QTdqUUNLS0w0TjVraVJGT3BRRTFxSVFaOXpYNW54NkFZaEZXS1RKaWU1?=
 =?utf-8?B?NXZyQTVlcmxDcy9uQ1hBb1d4KzBQZ2VkZ1VOMkpBZkhTMVczSWxKVXZXdnRa?=
 =?utf-8?B?ai9qS3lOUW5uL2k5RjhJamZSd1lTL0s1aVhvMXVlcjNCZFJHbkprSnJPdXdW?=
 =?utf-8?B?dDUwRjlGaVZtM0VSTnQzd01OTG8zWmpKOXdESGpBNzVRc0tQK3NmVVppMnYz?=
 =?utf-8?B?WGwwcWJOc3BWTGw5RjROOENTeUh2WGgrZlNBaWhPU1c1c2taTjRMREFKZlhP?=
 =?utf-8?B?eFNudlplT3piT2ExWG9kWkJuM0dYMXY5UmlVbHJJd0NCQnYyVmRMa3JuSTdI?=
 =?utf-8?B?ekxMclozSXM5d2cvcGpZQWJoSWdES1g1Y3IwOXRhdi81Wkx0dm9YZXVacHVh?=
 =?utf-8?B?MTBydng5ZTJYbzgwRW9Wc2VlNFpyQTBSeWxob0R2VUhMOUZ3aG1ndjZrVE9B?=
 =?utf-8?B?dFAzNitFZzBucU9lUkw5cDFMMWNUNDdqcFZzS1RpUkoxSVhud0EybkhiSDBI?=
 =?utf-8?B?VjVTYjAvYTg2ekYvbFUyUXV4aHcvNDVVaTlEeUptZXlCb0lTang5NWR5T2xn?=
 =?utf-8?B?MUJmN2RYZ3YxdEl5WHE5aXM2OEhHd2l6N1FnWTRQU3V4NUtmT25NeitNK1dy?=
 =?utf-8?B?WXJPQ092aTZ3KzYyZi9iU3ZmQTRzV3FaUENBTnI1SzdnT2NWTXB1UjBrTVZS?=
 =?utf-8?B?MjVvVDd4SUtIcnZtM3RnOEw4RHptZjZSRSs3TWlLNFJpN0J4ZmxIZjhDRE1Z?=
 =?utf-8?B?TGZzUHU3MUVNc283WmZ0dnJRNmRyZGJxdkt5TnhIQVpTOVhzVStnL21MOVpk?=
 =?utf-8?B?NDNOSjNOaThaTUpFSlNaV1loZnQ0SExhOEtZVHJwMFk5UlVKQklCMmdVVG83?=
 =?utf-8?B?U2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DC42A600D39FA4496BF3ECEB246C93B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CiXRDqgwPog7d0g/We/bDOB2+zzISAR3mupC+6Q1blDc+Qcg4+BzpqOAn8PdMaqcratAUlUj2ckdGt7Of52ep19TkC4PWNUxWSZKCx1icGWb8R56h7bQxO29XkFq7t0T7AdgIsp769HOJp1IeM+PmQKGmij4l0wc8PYvJS6oZWARf8tYbKt9rtexwBQc7ABK5YBQ1RRYHXxjz3YShc2r8y7+PdUAq1JsQn9LlmH9yExJeYEIDOv8KAy6jE97Z/b9dHlNGB3DLPPe1PT3tFF+MyWCWzlsA+4jt8yvV/p4vkneCdl2OF0e/kMPAh6vVGpoPO4wnE9mB162GIXCEfebOe9LnJC5z/9kyZR5jtZ365zmpswoPHiNt8b5gCX8qTFeR3q3O/zcOys/h1o3EPMxqB2Vr8oruvvhgDFy3etzYFZKwamCwDSFfCZqYgP66JtDlz0PlA2VRu3ulKppkHnLNQNMpM0Bnz4P49LWW7+g0bjFB38WYCqQfGb8Jmv7GqKk4lRLOmRZhzTk/EsMJVtRu15BG/sOw0kfj3AOklpNxyO2SN4vEosKqnDSBHio5CK1h3qvtFdkxyrv58arGBZnAtbX+8MuqC1of+QmDWFbwBac/EGQuVX94poTgnivGdPv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bd7985-573e-4589-6730-08dd02354dd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 09:43:31.8604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Ejh5Q1WTSst3hKNufNatjglttV1oNq9xQv8XgPZfD0rGMkxquQezmvzQg0z4uIUv/m+LgtbVi/KGA2Nn9P1cj8c280iONnjA7rEQEOMW4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6740

T24gMTEuMTEuMjQgMTA6NDEsIEphdmllciBHb256YWxleiB3cm90ZToNCj4gT24gMTEuMTEuMjAy
NCAwOTozNywgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPj4gT24gMTEuMTEuMjQgMTA6MzEs
IEphdmllciBHb256YWxleiB3cm90ZToNCj4+PiBPbiAxMS4xMS4yMDI0IDA3OjUxLCBDaHJpc3Rv
cGggSGVsbHdpZyB3cm90ZToNCj4+Pj4gT24gRnJpLCBOb3YgMDgsIDIwMjQgYXQgMDU6NDM6NDRQ
TSArMDAwMCwgSmF2aWVyIEdvbnphbGV6IHdyb3RlOg0KPj4+Pj4gV2UgaGF2ZSBiZWVuIGl0ZXJh
dGluZyBpbiB0aGUgcGF0Y2hlcyBmb3IgeWVhcnMsIGJ1dCBpdCBpcyB1bmZvcnR1bmF0ZWx5DQo+
Pj4+PiBvbmUgb2YgdGhlc2Ugc2VyaWVzIHRoYXQgZ28gaW4gY2lyY2xlcyBmb3JldmVyLiBJIGRv
bid0IHRoaW5rIGl0IGlzIGR1ZQ0KPj4+Pj4gdG8gYW55IHNwZWNpZmljIHByb2JsZW0sIGJ1dCBt
b3N0bHkgZHVlIHRvIHVuYWxpZ25lZCByZXF1ZXN0cyBmb3JtDQo+Pj4+PiBkaWZmZXJlbnQgZm9s
a3MgcmV2aWV3aW5nLiBMYXN0IHRpbWUgSSB0YWxrZWQgdG8gRGFtaWVuIGhlIGFza2VkIG1lIHRv
DQo+Pj4+PiBzZW5kIHRoZSBwYXRjaGVzIGFnYWluOyB3ZSBoYXZlIG5vdCBmb2xsb3dlZCB0aHJv
dWdoIGR1ZSB0byBiYW5kd2lkdGguDQo+Pj4+DQo+Pj4+IEEgYmlnIHByb2JsZW0gaXMgdGhhdCBp
dCBhY3R1YWxseSBsYWNrcyBhIGtpbGxlciB1c2UgY2FzZS4gIElmIHlvdSdkDQo+Pj4+IGFjdHVh
bGx5IG1hbmFnZSB0byBwbHVnIGl0IGludG8gYW4gaW4ta2VybmVsIHVzZXIgYW5kIHNob3cgYSBy
ZWFsDQo+Pj4+IHNwZWVkdXAgcGVvcGxlIG1pZ2h0IGFjdHVhbGx5IGJlIGludGVyZXN0ZWQgaW4g
aXQgYW5kIGhlbHAgb3B0aW1pemluZw0KPj4+PiBmb3IgaXQuDQo+Pj4+DQo+Pj4NCj4+PiBBZ3Jl
ZS4gSW5pdGlhbGx5IGl0IHdhcyBhbGwgYWJvdXQgWk5TLiBTZWVtcyBaVUZTIGNhbiB1c2UgaXQu
DQo+Pj4NCj4+PiBUaGVuIHdlIHNhdyBnb29kIHJlc3VsdHMgaW4gb2ZmbG9hZCB0byB0YXJnZXQg
b24gTlZNZS1PRiwgc2ltaWxhciB0bw0KPj4+IGNvcHlfZmlsZV9yYW5nZSwgYnV0IHRoYXQgZG9l
cyBub3Qgc2VlbSB0byBiZSBlbm91Z2guIFlvdSBzZWVtIHRvDQo+Pj4gaW5kaWNhY3RlIHRvbyB0
aGF0IFhGUyBjYW4gdXNlIGl0IGZvciBHQy4NCj4+Pg0KPj4+IFdlIGNhbiB0cnkgcHV0dGluZyBh
IG5ldyBzZXJpZXMgb3V0IHRvIHNlZSB3aGVyZSB3ZSBhcmUuLi4NCj4+DQo+PiBJIGRvbid0IHdh
bnQgdG8gc291bmQgbGlrZSBhIGJyb2tlbiByZWNvcmQsIGJ1dCBJJ3ZlIHNhaWQgbW9yZSB0aGFu
DQo+PiBvbmNlLCB0aGF0IGJ0cmZzIChyZWdhcmRsZXNzIG9mIHpvbmVkIG9yIG5vbi16b25lZCkg
d291bGQgYmUgdmVyeQ0KPj4gaW50ZXJlc3RlZCBpbiB0aGF0IGFzIHdlbGwgYW5kIEknZCBiZSB3
aWxsaW5nIHRvIGhlbHAgd2l0aCB0aGUgY29kZSBvcg0KPj4gZXZlbiBkbyBpdCBteXNlbGYgb25j
ZSB0aGUgYmxvY2sgYml0cyBhcmUgaW4uDQo+Pg0KPj4gQnV0IGFwcGFyZW50bHkgbXkgdm9pY2Ug
ZG9lc24ndCBjb3VudCBoZXJlDQo+IA0KPiBZb3UgYXJlIHJpZ2h0LiBTb3JyeSBJIGZvcmdvdC4N
Cj4gDQo+IFdvdWxkIHRoaXMgYmUgdGhyb3VnaCBjb3B5X2ZpbGVfcmFuZ2Ugb3Igc29tZXRoaW5n
IGRpZmZlcmVudD8NCj4gDQoNClVuZm9ydHVuYXRlbHkgbm90LCBicnRmcycgcmVjbGFpbS9iYWxh
bmNlIHBhdGggaXMgYSB3cmFwcGVyIG9uIHRvcCBvZiANCmJ1ZmZlcmVkIHJlYWQgYW5kIHdyaXRl
IChwbHVzIHNvbWUgZXh0cmEgdGhpbmdzKS4gX0JVVF8gdGhpcyBtYWtlcyBpdCANCnBvc3NpYmxl
IHRvIHN3aXRjaCB0aGUgcmVhZC93cml0ZSBwYXJ0IGFuZCBkbyBjb3B5IG9mZmxvYWQgKHdoZXJl
IHBvc3NpYmxlKS4NCg==

