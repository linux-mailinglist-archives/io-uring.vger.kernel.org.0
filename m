Return-Path: <io-uring+bounces-4733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFF19CF2EE
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2DD1292DE0
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3C71BBBDD;
	Fri, 15 Nov 2024 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kOyrR59O"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72393166307;
	Fri, 15 Nov 2024 17:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731691824; cv=fail; b=JF91ChxDZ+XtvqnfIP5PGuCvlwh2ZZybvmqLWdXyIr+H6cgSG1V1lJK3wL9bnk7hyA4ADkVxtltebVdgUkv0M4hd6z5q7bINNQzTmkRnFYTN9afyrYP5HEp6tnzzZ/7nFNUpZwgFLG+xSC8wzX73oiyKMUajDUaVUfvI1nS2RkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731691824; c=relaxed/simple;
	bh=WE88R6AhtrtgSm/0OPvs9BRojbvI4HLVsUh6xiVssSI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=gwhHdK6AG4yFIkCIGLW1upaSxehys/KMX8b0zIGYpbf6Qp7NqfRD/S6K7Rsg4n1NsegCODE9MrVIAu6+5PyN+hehS/w41qSVGNpgT5NJJw/FMTln0aarRgxIxe9r07p5rnRi5TsRYazBkdu/kcQvVmNYXRdHPSxDvu898y9Cwco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kOyrR59O; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFGZiYh015743;
	Fri, 15 Nov 2024 09:30:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=xZdkIOn1jtvW2rlPx7+HdI68Xey1dstxAoMG0/uvl10=; b=
	kOyrR59O0Q3VhuUE+Ci4qiCh/v15a8ainkoHVSGJgZH7BA5BYcrSt9cXAKxPUejc
	7ok4PLUQRNSFvzF8GX2rn90tTCzsqJaa9meUP2W3Lt6fZCaUachn5euQPuk8mGtt
	qJZpX/Cy7LkKgiBhmz8FemUoKmr8EpEzcRZ4w4NEkZuFuTSWwXUrMO3pQHuDLD9O
	rygUaLmkJsgr52un7HwaFPMhuIuNbEFbGn7NBHpTLETEbebIxr2EDhSpkxbYcouG
	ulYclJ/2v2+ZEkOBrK4ZdE3dJcOu6eTVRmb3enX8dh1f3Ptu4raFGZJ2bmCocUk6
	E73cmBdsvhbQ9cui8fHF4Q==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42x6tysv6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 09:30:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpYDCGgPShnl+wGm0R6RycEs0gS2pCctUU0yI5SAfEu+u5AgyjmloRdHkpyLYL8IPwV4PG9VA2YDjzJ2AlWDKfWcU1V2x/cMDBwzojIkt0S56hEQh9NuRNUs5OpiTX6UuuIneCuugXmhHQn83PV8aGBBv6DncnURow7g6NE5cpm/s1X0V+yYqY3sDaLw4se3cv98q6Yp7e/HOE7L3gnaa8mFBeCp2XlwXYVRWLopHJgYVCTYBqTYXAYGvL3mQUjwKT7IgJbGLXzYNOunC826OlA4Kw3tQsQyXKA0IDB2yDzCfa/DJjTaD/ns0SyKuaj8wbfP1usuG3pU+aJyAQbnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqzQj7trLiVPa1N7j0rGp/4oy+uELaScsmUp8WUy7Xk=;
 b=A5P38Svnh9OXQukMhNarQaEGrK0gXJkZ7fFFiuNhrt8h5HwbLTe/eihrG9sMPAHbKy3ymV15UhsmauuTvoGa/jC6X5C3JyzuQLKR7k9XD7aQh/o29nOtjLtNLoiZaZAWJr/lFIASxXUC7+nLUC4q3ZtFCxWjfQVtryLxGtnOlagsydHeiB+9qhyZwDTKy2RsjjnU5vB999HLd48OQoA00l3K3qfsVeqBF8DVI0US6RSJ/he0/uVDAovM23PKNsTV9H9f6aukX6lIN7DRzIsF8l+G98WhVa3zxJkggzYVL1eGu25x5sProDUUfsxQWPcKwWUZ6m9Ue19sHQWnK9NopQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by SA1PR15MB4499.namprd15.prod.outlook.com (2603:10b6:806:19a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 17:29:43 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%4]) with mapi id 15.20.8158.017; Fri, 15 Nov 2024
 17:29:43 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Jens Axboe <axboe@kernel.dk>,
        "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded writes
Thread-Topic: [PATCH] btrfs: add io_uring interface for encoded writes
Thread-Index: AQHbNSBtaJCXHCfze0m8qru/4VIzGLK0IeiAgAR7wAA=
Date: Fri, 15 Nov 2024 17:29:43 +0000
Message-ID: <8f8a9001-351f-4f7f-af39-b43a9b91872f@meta.com>
References: <20241112163021.1948119-1-maharmstone@fb.com>
 <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>
In-Reply-To: <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|SA1PR15MB4499:EE_
x-ms-office365-filtering-correlation-id: d89e3c68-4fe1-4ec0-11ff-08dd059b17b0
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K2JEKzB3eklPZnRPRkZjTTUrZmYxdERjT2F6YUFzeDlDVU54Z1RiUHR2Y09O?=
 =?utf-8?B?UFRuVEEwdU5DdTJRMVYramRJcU0xd25KQmpoSlY0N3MyZ2Y3OUx0Vy8vYWRT?=
 =?utf-8?B?NU5wcG9wRjZTVzRzcWNHTmlnYmpMU1dkU0l2T0VRNmgzWkpZcWJCSFpnaW1s?=
 =?utf-8?B?Uk1oZi9tVC9FbmhRTkE2NytHa0NhVWFxaGh1Uk15Uk4rNjliTk5UdDFiSnJF?=
 =?utf-8?B?VGRld3JXbzhBdm1JRlQwdDA4NnlqUWVpdUFubjFqY3JwUkNNSys2K0xFeFNC?=
 =?utf-8?B?NTExbHdMK21LSEF3N2RSRDlsRDBMY0F1YnZlV2dURE1wT1N6ZVJZWHdaL0ND?=
 =?utf-8?B?TDdSblZQVGx1WUlLRGVmbERjeFM1RXNWaWpjeDhaV2huSUtXb3dac1JKbUNp?=
 =?utf-8?B?T1JkRnp6UEJIblU3SEkra0hXblVXVVpmUU5xbVVBY1FWTU44UTU1N0xzRU1t?=
 =?utf-8?B?RCttRENjVkN3MGg1SlVRQWk2MmdSVllCT0QxOUFWdU5BT0ZlVGI4ZTg3K1lS?=
 =?utf-8?B?aTFQWFZQWE9vaXhtMUpmWEVTMmpqY1FDcEQ2U3pZc3NPQjNLVW95d3ZyRlRk?=
 =?utf-8?B?ME9vZFByR1VzNVVYVDZKN0dOL091cHVaVVJvbHpXL3FXaHh3ZmtQcFNQa3ZI?=
 =?utf-8?B?cGRKOU9sYittUFFRZGdWcTR3K2llV2NweXZrOEVPei9uMUpZaHRDS2pIbWh0?=
 =?utf-8?B?cDlJUitqVi9HUFI1VHJxNzNKK2Y2bXpMNm9IYnRPOFlSbUZENjllRG1NTmly?=
 =?utf-8?B?TU15c1c4N2VLcnhLcXA5ZVl3NGs5SXA0bEdCY01VbVQ1citaOHc3Z3hEdUJS?=
 =?utf-8?B?OTJIS3VkTTRKQWlrRzdtaXJEZFBBdmV6Mi96WDI2WTJLQlFobUZvT0FUT0pY?=
 =?utf-8?B?cDhOMHRZRVhYaElxRkRuaVZFREdMemRLL1pCd3pHTUt1VGNsT09sdHRFMmdL?=
 =?utf-8?B?OUUxQkQwTGpwcmsvNENsSEVhVytFNHd5TUJRV3FjVDBJbzh2R1hnaWhjczZr?=
 =?utf-8?B?WW9CTi9Qb2ZRRkhtUUN4TFd2R25yMGVpbXY4aXVLd3RDSWVGM29DdVlGSTlr?=
 =?utf-8?B?RW0wUGp1TWtEWmlDaGNrZk5rNUdQTUV3TFNPMlo3VktWNnZCb1oyckRzamVE?=
 =?utf-8?B?ZSt3Q09xSG4vM1RqczlrOTduV2lPbjNQT0wwQ1NoWTd6b2FCQ01FQ2dxSTVZ?=
 =?utf-8?B?Um5EaldTaUwzSE1Qdy9ndzIyOUp1M2tCMlo1ZS8xU2J4dXViZ3pmRkhwNXVu?=
 =?utf-8?B?SmRjc3puU1RwYXo4UG5CelgySmFxMjMzQ0VCUUJaTlV5aDhrSEQ1SzVCWEpJ?=
 =?utf-8?B?aGpJeVlDYk9FR2NGRmdzaEhVb1FTOTBhNUxhMWdUZ3FsOHFPa2x4dGhVVkxB?=
 =?utf-8?B?aFBxaDMrZFhhdGFBMjlteThTSnNpOUVFZ2p1aFNVLzlkakpsZXYraEtsSWVP?=
 =?utf-8?B?endiakdOaUlTc2syVzQxR0ppc0pVc3hqbW1aay9jL0NrT1dDcnkzeWpOUkRC?=
 =?utf-8?B?ZWFHSG9PTWtjWXN2THc0T1FYV1hsVGEvUjJybkFndWM1ZDZIVDNPSUREeFB0?=
 =?utf-8?B?cGZjOWFDdFR4cXo1aU5vZFN4UExGbFp0YzIrZ2ZoNEpEOHhncUc4RUt2NXdH?=
 =?utf-8?B?blBUNmQ4RVVUTERiY1p3RWZzT0JSNDExODM5NVhCMUtGL0NmMmp5WTVya0ln?=
 =?utf-8?B?ZTFFUG1LMlpHbHEyRUlaRE8wMXMwYVBodFdwMGVKZHY5cWJibDlPOEk4ejgv?=
 =?utf-8?Q?3bzeyPJLgAP6TdrwTe8sDNnOiqpNcx4fzdU7qcq?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cERlME1zUGprVHZlYm9LQ0tObTYzNml4Q21zUlU0M3FzZGZWSXp1NmtJeEt0?=
 =?utf-8?B?UVVZKytnMGlJV1JKQkNJbzU0NElqaWRMNTdFeEovQSt6MzJteTFQb25WdXVp?=
 =?utf-8?B?T2dIbkZFNWRZejZHRGJuWFF4YUpvcUJrcUwvZVdIZmtiOXFJTVRxa2dId0c1?=
 =?utf-8?B?WTh1bFN1SG1XNjVocFN3bE5pVGtkTkowTklxR2lvbFJsUFEyUEFvWjBjRWpF?=
 =?utf-8?B?UFJBN0ZxNC9DVkI5amNlQ1FqT1pNTXk3eWU2bk9MMkM0bG01UU55Y0szRThE?=
 =?utf-8?B?NUhxZFNVMW9TUUJUR2cvUSs4NUU1WllERkFVSUpaeEprdmJMeFU1cFZjOW9X?=
 =?utf-8?B?bTJMcmZmcEFzMEdGMERVM2FJc2Z0M1Vya3pJN0FNbHpheWlNLzhjNU14azQr?=
 =?utf-8?B?TE1ja2hHQmNCUUwyV1BUcm9MZlM4d2VCcWxpSXdnMTVMRkl4bWJpNEZVR1kx?=
 =?utf-8?B?OFlvbXcyamRvZGZpY3ZUOFJOYmZnRjJIcktiOTBGUE5OM3d3ZWp2RnZaWng4?=
 =?utf-8?B?Wit6b0NpZ0VSaGpBNjMzd2NMN21tNVN5Ly91amh3cnphY0UwcVp4aU0xczRy?=
 =?utf-8?B?OGJkeWNSMHYxcHZSbE1idFpSZURzUHd3YUI0VmI5clo3ZVJtRFRPWEhicm50?=
 =?utf-8?B?WGo3QmQ1ZnFmZnVVdHkrdnNoVEVLL2Zabmt2ak9XRmhjcWNNR3Z4aUhEQkZU?=
 =?utf-8?B?c2VILy9LM1JkSmtWZmw4Rk1qaGpERGtobmJGaUVqYXQvNXV6b1paK2Uxeklk?=
 =?utf-8?B?dDZSNzUvcjZucy81dU14RlhsNGI2ZG4zY3l4d3d5eFNRamxYNlViRUpnWkFG?=
 =?utf-8?B?WXN4ZjBLRnZkZ3NBZlhORkZYYWRrOWpDS1lmZE1DM0ptbVZkb3RIWWpFUmFo?=
 =?utf-8?B?UFlmcDFwMktNd3JRTXBUaUI5NTZSN1EvcllTcGVxQnlZRE9zU0EweS9BY0tr?=
 =?utf-8?B?OVFLbmpTb1czdlV3RmpiQkphZHFUaXhjUDdYcU5PMUZSQ2h1R2RrbkFRYjRM?=
 =?utf-8?B?L0NaK2FyYnh2SytUbndac2xCdlM4UXBmVDdTWGdOeDNINVJOekt2SFo0WDVP?=
 =?utf-8?B?U25NN0dpMmVnVXZmdXJHWDNER1REVC9UcUZqUzRJb0c3c3FUZERicXdCckQ1?=
 =?utf-8?B?MFFMUHVqRUVVcnpRam5jWmRzd3BRM0JOaVlvSUxWTmN4QVYwQzRpbjc5NUlx?=
 =?utf-8?B?KzlEd2pUYjNwMXdJWTI5RDZuK0VrckR3c2lIdWpyeVl3WXkvU0Iyb0hHMTcy?=
 =?utf-8?B?U2lwNCtEQ1dqQVJic2JHd3Flb2o5TDZFRllGaXc3L3FJTWdQdzI0eWJHaDN6?=
 =?utf-8?B?MUpYdHR2MG9YeTQ3c3hqeU1WcW5TeWpWR2wxbmVlVk1JR09hVC8yOEovNHVu?=
 =?utf-8?B?Q3J3YU5jTU91c0RSVTZhNDhvVnd1RWlKTTMwUTcrTGlCdkNtd09VRDhWVHl5?=
 =?utf-8?B?MHlrKy9aMzZyUXZnNkFINFk1cjl4NUgrTTVkbG5VKy9qN0UvNFRhS24yQi9n?=
 =?utf-8?B?QmgxUUtSNlVoaGtRV3czL0tMNUNlbnVFOVRSMloxUXZUSllYWkJHeG05UW9t?=
 =?utf-8?B?U3VBNll2T1k3WjVyWklwSzB0Mk5oVGt4UVB3RGwvbGliSEgrZW1sd0V0NFhl?=
 =?utf-8?B?NzZ6UU9nWHZETGpNUHBVS0xkZTB5RXVIQmEvVitMNjZLNHQ4WXM2T1B0RFlZ?=
 =?utf-8?B?UVFPVXRTamN6MmFUaXBoSlFEcHBYUzJHalZxczJ4Z0JGZ3czTjQrRVNQMHZH?=
 =?utf-8?B?dTlOb2FOUUNYQk9yUU5LdUU2dXRFbks2RWxxSGVlZ284akptRnEremdLbENZ?=
 =?utf-8?B?MDR2MTZvbGpGb3pET0g5MTRjQS9XMWZWZ0QwaHRReS9Qc1RXR2FvM0JML0FU?=
 =?utf-8?B?US81RVlVczlWTzVvdmthZ3ZMUDlPMUhCREFBTmRaZnRWL2prUUpybDliZW15?=
 =?utf-8?B?a0tQY2EyTVo5dllCWW4xQVE4SzdoT1J3Wnpqdis2RjZiVTl1c0FoWG84dStu?=
 =?utf-8?B?VGFvU0JqeGJtbDFhRURXdlVtbHh6ZW9mZE9kZ3gybXZ0Zk4vTmxaRkpuT20x?=
 =?utf-8?B?YUIrOFVLN0hObnVoelVpUzU3WTkrUWErOCtRRVZWNUpHcklmWFhTWFVSSkVz?=
 =?utf-8?B?Mll0RGpJSW4yZnAvTS9oc1U1dkdUOWdXM0dMNzVBQUt4NkRqLzlLbWZpTnIz?=
 =?utf-8?Q?NvFgZZBb0chYBmPpxswBsSw=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89e3c68-4fe1-4ec0-11ff-08dd059b17b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 17:29:43.1902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1L+cc+o4GLHJzWo7K2FCMiZQgsab9WONjZflWwoC2olcoQ3k7VcVaAEfhLDHUix5/2UGqWwQ6tCMYfYv5BxjDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4499
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <DCA25568163C2F48AFDBAABF8FBC5B9B@namprd15.prod.outlook.com>
X-Proofpoint-GUID: xJJp8UKKakLNM3s-dZ9yKHQYW57T1a_J
X-Proofpoint-ORIG-GUID: xJJp8UKKakLNM3s-dZ9yKHQYW57T1a_J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

On 12/11/24 21:01, Jens Axboe wrote:
> >=20
> On 11/12/24 9:29 AM, Mark Harmstone wrote:
>> Add an io_uring interface for encoded writes, with the same parameters
>> as the BTRFS_IOC_ENCODED_WRITE ioctl.
>>
>> As with the encoded reads code, there's a test program for this at
>> https://github.com/maharmstone/io_uring-encoded, and I'll get this
>> worked into an fstest.
>>
>> How io_uring works is that it initially calls btrfs_uring_cmd with the
>> IO_URING_F_NONBLOCK flag set, and if we return -EAGAIN it tries again in
>> a kthread with the flag cleared.
>      ^^^^^^^^
>=20
> Not a kernel thread, it's an io worker. The distinction may seem
> irrelevant, but it's really not - io workers inherit all the properties
> of the original task.
>=20
>> Ideally we'd honour this and call try_lock etc., but there's still a lot
>> of work to be done to create non-blocking versions of all the functions
>> in our write path. Instead, just validate the input in
>> btrfs_uring_encoded_write() on the first pass and return -EAGAIN, with a
>> view to properly optimizing the happy path later on.
>=20
> But you need to ensure stable state after the first issue, regardless of
> how you handle it. I don't have the other patches handy, but whatever
> you copy from userspace before you return -EAGAIN, you should not be
> copying again. By the time you get the 2nd invocation from io-wq, no
> copying should be taking place, you should be using the state you
> already ensured was stable for the non-blocking issue.
>=20
> Maybe this is all handled by the caller of btrfs_uring_encoded_write()
> already? As far as looking at the code below, it just looks like it
> copies everything, then returns -EAGAIN, then copies it again later? Yes
> uring_cmd will make the sqe itself stable, but:
>=20
> 	sqe_addr =3D u64_to_user_ptr(READ_ONCE(cmd->sqe->addr));
>=20
> the userspace btrfs_ioctl_encoded_io_args that sqe->addr points too
> should remain stable as well. If not, consider userspace doing:
>=20
> some_func()
> {
> 	struct btrfs_ioctl_encoded_io_args args;
>=20
> 	fill_in_args(&args);
> 	sqe =3D io_uring_get_sqe(ring);
> 	sqe->addr =3D &args;
> 	io_uring_submit();		<- initial invocation here
> }
>=20
> main_func()
> {
> 	some_func();
> 				- io-wq invocation perhaps here
> 	wait_on_cqes();
> }
>=20
> where io-wq will be reading garbage as args went out of scope, unless
> some_func() used a stable/heap struct that isn't freed until completion.
> some_func() can obviously wait on the cqe, but at that point you'd be
> using it as a sync interface, and there's little point.
>=20
> This is why io_kiocb->async_data exists. uring_cmd is already using that
> for the sqe, I think you'd want to add a 2nd "void *op_data" or
> something in there, and have the uring_cmd alloc cache get clear that to
> NULL and have uring_cmd alloc cache put kfree() it if it's non-NULL.
>=20
> We'd also need to move the uring_cache struct into
> include/linux/io_uring_types.h so that btrfs can get to it (and probably
> rename it to something saner, uring_cmd_async_data for example).
>=20
> static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned i=
nt issue_flags)
> {
> 	struct io_kiocb *req =3D cmd_to_io_kiocb(cmd);
> 	struct uring_cmd_async_data *data =3D req->async_data;
> 	struct btrfs_ioctl_encoded_io_args *args;
>=20
> 	if (!data->op_data) {
> 		data->op_data =3D kmalloc(sizeof(*args), GFP_NOIO);
> 		if (!data->op_data)
> 			return -ENOMEM;
> 		if (copy_from_user(data->op_data, sqe_addr, sizeof(*args))
> 			return -EFAULT;
> 	}
> 	...
> }
>=20
> and have it be stable, then moving your copying into a helper rather
> than inline in btrfs_uring_encoded_write() (it probably should be
> regardless). Ignored the compat above, it's just pseudo code.
>=20
> Anyway, hope that helps. I'll be happy to do the uring_cmd bit for you,
> but it really should be pretty straight forward.
>=20
> I'm also pondering if the encoded read side suffers from the same issue?
>=20

Thanks Jens, that makes sense to me.

Mark

