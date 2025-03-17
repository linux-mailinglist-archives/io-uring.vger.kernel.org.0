Return-Path: <io-uring+bounces-7089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E803BA64A06
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 11:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20F307A450B
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 10:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071DB23372E;
	Mon, 17 Mar 2025 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YN1rZSqo"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC4229B28;
	Mon, 17 Mar 2025 10:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742207528; cv=fail; b=eD09cpkd5meagO/rQWFysON5nCIKgzSdUIkuk+GLE+Nbk2Yo7ytbJGCS12VW2tghkYBBtH3AEqrhMNTXh6n+i2mgNF82wATe/h2CVVyNnwSs25EmRwaDoUR8phX/kHA7niDxnWolDqvhWWQdYCjQTQBtju5eGpwLsiIFIKLLi1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742207528; c=relaxed/simple;
	bh=osJKbui3KzINKSwfFM9oMkDVQTRit3CP+D8NzTtuHac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=CxfjaSva4ZSUWvUlCQZXLnypp8EG3v9rNseVKfBkOLfdTak2THf8JOEs/IENmsdD0Lgo7oVrgZYbpXjxeFD+fe1P+vVnSSomPXopW8lndF/LNtex5e1HFREMUydwJNdd9cZdaEczmaj/sb4Mrcr3UksMPcrxQjs/aFS0TLnZ85o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YN1rZSqo; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52H7YiK7021902;
	Mon, 17 Mar 2025 03:32:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=osJKbui3KzINKSwfFM9oMkDVQTRit3CP+D8NzTtuHac=; b=
	YN1rZSqohHRECCP6Bz4S/vzp1phcPICM8ZZlzrChm098Z1udow4yfHGXUmoMtmI7
	Rf116DjaGnWZTlh1EOZWWaZD5yt+pr81N30rwl7LBsTjjD5Az2HrRmFREfk1uzG+
	vP5Nou5pVwyePXAG5zYIh7Btuk9BjtfJFggO4hiTD2CnlA7Fflw5FanK5mA11fbn
	/YMWmgCsCMP/vZQkHJo0O0pM4oJ+LHta+4dwZC96qomMAfwxmt8u+3tGC5CugYIM
	Lwpx5VT10sPfxqOsqWSfrrbP16kT/HAU9W5A7JlzfPW16lWYGS7YRZAdR165qxG1
	LWqpwsPBufMASsC0HkZ0wg==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45d8v1cdet-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 03:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anr8WpBinUBidQS14A17RxWilpiObzxj1RRZ891cO6Z2lnnOLThztf4jJqhEUxHCxZYnAWnOJc42/NWDQyoWyumuYnD7lOQkXSJr4CD9e3NJ8pU1iY53ijThvEjRoltHMdu0zQ3krUfbYamkbI9SNZsLA//mhPxgPj9YnrWSzMV76n9b7oockpnfWlNjHwJrcdc11rdxwSpVhGGH168vfeY/xCkNJI51tMivcg2+lTqn6FLSLCiNyLZLTp6xrlvG2trUAlYLSHRMoyqW5toGpUsBxZnk8huAmT0BhKfp34xSFdIISysA/RnJn6bjjYS4WdjbYXvgJt+Xe1HqZhf0uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NeG+YvhZgOFXxtXDSU7nDejvicfVBoli7I1SJij+wOM=;
 b=dIYE13NRoICfk7KTE7ffV9N1vnqxL+N2UK7Ne7Y3f7g5t31ooDnyuXYxNExkcDjqEGkxDnC3f+qdupmA90wQuwixdOzvGww0+8Yg9F4x6vc97veoT3u2xz2qfHNd6vHu6ZZkvTMBNCgY6czKqTgvhREugBT6Mj6HbbppWUydGPcAz5zh/5ZAQGx5EtnwgLcZWavMx0+3WJun9bX2km8bu1HOa2tjaWB9aSQ0ND7eNKcYRl1rTbxeZFtGSCPM3zrMKcm4/BzENGZ5Ibys4mOXV9mdf/m4DZTRnvSjdnlMpEKxGBsr9PDM50lSe9zl1iejA7dELEmUfejCpE2mbH9bPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by IA1PR15MB5534.namprd15.prod.outlook.com (2603:10b6:208:419::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 10:32:02 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 10:32:02 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Pavel Begunkov <asml.silence@gmail.com>,
        Sidong Yang
	<sidong.yang@furiosa.ai>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba
	<dsterba@suse.com>,
        Jens Axboe <axboe@kernel.dk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/3] introduce io_uring_cmd_import_fixed_vec
Thread-Topic: [RFC PATCH v3 0/3] introduce io_uring_cmd_import_fixed_vec
Thread-Index: AQHblc8LqwQUPcHiI0SUWoKr8+1R7bN1XKIAgAHHYoA=
Date: Mon, 17 Mar 2025 10:32:02 +0000
Message-ID: <785d1da7-cf19-4f7b-a356-853e35992f82@meta.com>
References: <20250315172319.16770-1-sidong.yang@furiosa.ai>
 <3c8fbd0d-b361-4da5-86e5-9ee3b909382b@gmail.com>
In-Reply-To: <3c8fbd0d-b361-4da5-86e5-9ee3b909382b@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|IA1PR15MB5534:EE_
x-ms-office365-filtering-correlation-id: 142a7c0b-7736-4c75-58ad-08dd653ef48f
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?a254dGlPYUxaUktxOTJxS2llMDZXdk00d29BdEJrR29TN2NpVXRRd3BhdWxD?=
 =?utf-8?B?bWNLYTl6Tm5OSHdPU3hjRUtaTDVqcVc4d1JNbmZKcVpzUUc1eXpKMkNvZWNK?=
 =?utf-8?B?Yld2dXRqb3hBdGtmQzdad2J2aXdTU0dDakNGcDJackpheGVqRkY3NmpFbC9C?=
 =?utf-8?B?cDU5L0hTUENZZzU3SUtqaWxKUERqNkNPMlVCVnRUOEVpci9MTnNkWEoyYm5F?=
 =?utf-8?B?d2k3WnlZRDhwV2xnU2JiWEkyZW13R0tFMkROLzAzaldJV2lJVkNLaXRjckN3?=
 =?utf-8?B?RmFFVEZLYTY2MUhvbmp6aG9ibzk2TW53STVTR08zMCtqZGoyQi94Ykt6MGZO?=
 =?utf-8?B?MEFTdGtrWG1rMTBxcjdzWFFjUitmSWtZREdoeVR6REhXV2gwZTA2RXZ4ODRC?=
 =?utf-8?B?V3BBVFZIcTR3MzVGTU43dVIya09VZERTczgwUElUSEIxRjZNbkVKVzM5anIz?=
 =?utf-8?B?T0tteWMrdGtKMVhpa3hkMEFtZldONllBbWRjSStHTnJyOWJvZHNjSWJjSUhH?=
 =?utf-8?B?eDRSaEY5cEhyNmJDaU5aRWQ0VGRkdENwRkFtSnIzb0lvd3p0MHZFR2tuUk5s?=
 =?utf-8?B?cjRYU2tJWVAvYTlORnYxM3pxSFEydmw2dXQwUE5lSGpJVU1qcnNYS0FHQ3dQ?=
 =?utf-8?B?Uk9vREJRNFE0TW9raFpFQVdqOCszNWJMNFg4Tjc1SC91MExpd0NSUGVjOC9N?=
 =?utf-8?B?TmVORS9VNC9TUFMxWGl1NFl4MmpQa2MwN050aDd4K3hlV1NUUzI2eEJIRnEw?=
 =?utf-8?B?a2ZXUVl4bVNRYTZtSzBFZytSVXRNUXk2MlcwU3A5RTVmQ3ZQL2J6TnR0L0tr?=
 =?utf-8?B?Tys5UFVhK1QrZEZpSE83UDZQS3o5YWJJeGhnWmlmZUN5T3MxRThSMGVURG1T?=
 =?utf-8?B?WWxadUZTdDNtOWZVYXFiY0lPckFJSTA0dVRndlVvSzA1V3c3WUxlWi9UK2pH?=
 =?utf-8?B?ckgvcmszdUxoVkJCV3lRNXIxZUVRSEF2ZjVNK2JTT0NvcGc0SWVQVU1KQXFF?=
 =?utf-8?B?YnVXY2VWbU01RDFMTUNaY0M2UitaL1lpZ1VnRHlQZWFXYXJFN3hDTThqcDFQ?=
 =?utf-8?B?bG5leVZRdlVLa29YYmVXUG54eEk0L2psNDcyVFpBRGU0UFpmc3lyUk5TTmQx?=
 =?utf-8?B?YTVVK1dwOCs5Q1VjOTg5dHZFK09vZGUzb1EwbFAzSXlDSmtkZTlJd09DbmZx?=
 =?utf-8?B?VUZMaFZsOTR2Nyt4Qjh3UHRBa3k5dWN4RVF6bzMwK2lZUEtvMGdMeWhMaGZY?=
 =?utf-8?B?UEh4WGpJU1IyMlZQV1JheStGVTh2Y3JOMW9jMXl4WWtKYkROQTBIU21Hbmgz?=
 =?utf-8?B?czRJdUM5eFR3czFtL2ZrUjM3ZWlCcUphMTlZNjJnZXM2UHFieXhubk9MSHF0?=
 =?utf-8?B?aXlzRkM3endYbzBkK2dMZEUrVWdTM1Z1aUp6aGZOWWpBZGVjVUVaR3BoaVFV?=
 =?utf-8?B?RVVNVkltb3NIM1dVRWNsN1JhUTR2ejRvKy9JNlNNU2hQSS83L0hjS0piakw1?=
 =?utf-8?B?eGhkZGZ4WjFhTmNGbVBDck91N0FjVkVGb2IwWWpMWHVFWDUyV01ZTGkwQmpz?=
 =?utf-8?B?VjhvWG9JSkNtTE43ZDlHV3RlWkM2WjdsQmUyeEcyd1J4Mkg4eEFhUzk5WGZx?=
 =?utf-8?B?QlZZSVh3aERZcUdQRCs5UThuSUFvV2ZQRWlRd0lMSjNYNGZIZk1qeDlxQzBt?=
 =?utf-8?B?d1BYMitrY2EwbHlwYU11VWVXY1BJWW91aHdmMkFaZWlTNnI3Z1h0TTlFblpi?=
 =?utf-8?B?UzY2QTI1d2s3bVgwekJ3R1VQYVJ2RzRMMWR6czRHMnJRL2IraXNhTGtGcWQ2?=
 =?utf-8?B?M1BRTFR3cWUzN004Um5JWWFzeGZYVkdRR0FkODd2KzBHS05aZFhtelVsdVBB?=
 =?utf-8?B?WVlBOURvKzE4cFFVY3RkTUZLTkFlZ2dRc3dvNW1hVkpxTkxuMGIxOFNBMWto?=
 =?utf-8?Q?Wif3B7r/1V7godaC31aVaBgNgXMXy98k?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZFUyS1B3N3JUSmpPeTR0akpuNFJrb2dTcStndUZ4bTZ2MWxtQTBmMHBSYzEy?=
 =?utf-8?B?b0JsNkQyWURuQnFhK3NuMEkyaHQzaGxjOGFkbHA4MEZuWEFuRHNoVHltUXpn?=
 =?utf-8?B?VnNjT2g5UUFCL0lEaDQ2VGdaQVNRdk5mVmJISDNOVU1BNTQvdDNMOHZLNWY5?=
 =?utf-8?B?aUtyaVAvem1ibG9yUG05dXNuZnBzMmU5MlVyZnRLVFRtWWY3Vm5ZQ0VrWmRT?=
 =?utf-8?B?VElCaVZzZUhCczY2L1NDdHpKYWdKYWRGbkx0YkhIV25rdDZqM2lxdVE0UGxL?=
 =?utf-8?B?RWErelVGNWtlWkp2VTFjQXRyYWgzTkJhUnJScWU5WWFzNnE2a2Z1RGtmdEVI?=
 =?utf-8?B?ai90T2ZWN2l2OXFucWJ6ckcvOUFnOTZnVjk5cDdJUmVMWERrUzc5OFVCVUY4?=
 =?utf-8?B?cThmNVVVcmRRa05DYmFTT0NEa1Y0elVMOFRmQXQyZUprTVh4S1gvaFpWOGhF?=
 =?utf-8?B?eDVURk9QUEYycnNLNUY3RE5YSFUyMWNZMmpFSjB1Z3Z4TTVGb09SQllKZVhV?=
 =?utf-8?B?anZsRXVvR2pDYnQwbU1iOTVINVZiVFRjSHZUcHFTaTJya1g1WGt6SUZza3p3?=
 =?utf-8?B?VkpZWFpIWGxJY05RdER6dFhua1E1SGxMTDVJZHBFeFRMTmNYVVkvbDdlWWU1?=
 =?utf-8?B?cTNuTjZyckNpWGJkT045NHd4cnNTdTRHMlVvd3phd0VrS1IzdUhKKzZkSGJV?=
 =?utf-8?B?RzgxYWF3TkQ4alF0eWM2Y2JkSUZkZWcydUY0NTVET1NEcFB4K0dUajBjeU0y?=
 =?utf-8?B?T0ZLZFVlaU13M2xQaFpFUlFoci9zLzB0TWJRd2dPSHRZZE5Va2hUeXFuWUlk?=
 =?utf-8?B?RXN6V1RHeG1HaEROYlc2Vjlsakp0NFN5em9kbU4wTWNtRFFvQWpmMmt0NnpB?=
 =?utf-8?B?cUZySUVvQktjRXdISDRWTU9Ibm1peExLOXhNSVhzTzN6MWdVa0FBditwNk95?=
 =?utf-8?B?Qlh2M1phZkl1VGw5UEo4czIxZEVtajIzYVpDYmNJRFNFSmRWcGZyTyt6WlpL?=
 =?utf-8?B?UEY1V1krQzdLaEMyTHBFdUtwaHdseGlFNDVMN21NNHdVbVRNYjAwTkRZdFQw?=
 =?utf-8?B?QkVFRDFyVy9aZjVNMTVabDU2MXljNEFlWFhLRk1oVHhhaTI5Ym1lY0Y0QXo2?=
 =?utf-8?B?dm1pRWNrSFVoY2JYL2grY216YzdkVmpmTnBiUGI0RmJFb1hBcmZVT0hBUFV2?=
 =?utf-8?B?eThQZGhXYUlZTmo1MTVhRjFhdTg5YjZuMXBNQ0lUMEFuQXluTzN3SnRRa1Qz?=
 =?utf-8?B?QUFGTWRPWDVMQjl0NGdyN2tsUXAxTEw0L3VxMUxJUlBCOUVNQlBGWFRzeU1s?=
 =?utf-8?B?d0xtWVJmNTlsVHFXQXZHRWpjUnVvdndmZVhlWmRhbGRvT3MwQWdkbUIrLzlU?=
 =?utf-8?B?SmkrVWpRb3BKZkdNSHNZc2tqWHFBVi9GQkVmY1dKS0hvSXBieXZPazZFeDI0?=
 =?utf-8?B?eWhCOGk2cEx2RzVjYlA3TmxwNzdHZnNlU2lCSjZFVDlJZURCZHVpZC9DcGtw?=
 =?utf-8?B?YUxZeDFnNUpzMCsrM2FOYS9MbEJ5Umx4NFJ1b0xQRlJaS0RvRmpFaWhIL0Z3?=
 =?utf-8?B?ZmVEYThqdHRJZVpDZ3FHRGVlNkl5aEpSZDB3SjVFaHJhSklUMGhUVVpCNFg5?=
 =?utf-8?B?Z3grRXYxZjFKRDY1UGZEd1VKSm1yLzdTQmFlK2Z3aWdVUlZhMStrR0JOelcr?=
 =?utf-8?B?dkM2ZEZPV3QydlRoYm12UTlMMy9kbHlaNTF5a1NwOWMray9VK0hRa0huckcy?=
 =?utf-8?B?Qm4wVjFOUTFIRDIwUjJxRzRhbkdpejNVL0JBc09PaUlhbkdWQlI5M1FzVExW?=
 =?utf-8?B?VW1qVXhSZ1NqcGVhaUlXZkRsR2lzZ0RSb2FJeGNBNUc4ZFVULzluTGRoZVBC?=
 =?utf-8?B?SHhpYzZkeFpiTEVLdndzbDZncGFRZ3pkNkJQdWhXR2V6WGRUWHdoRWRZZTNu?=
 =?utf-8?B?OWwyOFBTRmdmWnd2ejFGclhzY0NxTGFycWZ6bFc4dzJuQS9odWM0QW5Hdk9F?=
 =?utf-8?B?YWRYSUtWRENVeGJocHdtZGZLTG1vMlNxcEJBcW9OMmtENjMrRjhGazhOempN?=
 =?utf-8?B?UE5KMEk4bkRjUXZkTW9tV05KMWVGL0FvR3dJVitsRXU1MUMvREZCa3huTVFL?=
 =?utf-8?B?d0NJRk5lb0hGMFFGZFZISXdOdkVVbHdzS0xLbEVSdkJvNXAvNmQ3bVc0RDlo?=
 =?utf-8?Q?47g2uo3A0Ldi5IausNXTrYY=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142a7c0b-7736-4c75-58ad-08dd653ef48f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2025 10:32:02.1851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQWZEfGjqikN/YTesHf/McxeBcphWrYeHFndAIzcVqJnR6uxXrAG3tJ24gS+PekIO0CnCKanjQwc7mzqeLcVDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5534
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <DAACC1375066F34A97358CAB7019B00A@namprd15.prod.outlook.com>
X-Proofpoint-ORIG-GUID: 7GW4dt_ihVpvNQD0D89rN3augbGH9OQn
X-Proofpoint-GUID: 7GW4dt_ihVpvNQD0D89rN3augbGH9OQn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_04,2025-03-17_01,2024-11-22_01

On 16/3/25 07:22, Pavel Begunkov wrote:
> >=20
> On 3/15/25 17:23, Sidong Yang wrote:
>> This patche series introduce io_uring_cmd_import_vec. With this function,
>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>> for new api for encoded read/write in btrfs by using uring cmd.
>>
>> There was approximately 10 percent of performance improvements through=20
>> benchmark.
>> The benchmark code is in
>> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
>> ./main -l
>> Elapsed time: 0.598997 seconds
>> ./main -l -f
>> Elapsed time: 0.540332 seconds
>=20
> It's probably precise, but it's usually hard to judge about
> performance from such short runs. Mark, do we have some benchmark
> for the io_uring cmd?

Unfortunately not. My plan was to plug it in to btrfs-receive and to use=20
that as a benchmark, but it turned out that the limiting factor there=20
was the dentry locking.

Sidong, Pavel is right - your figures would be more useful if you ran it=20
1,000 times or so.

Mark

