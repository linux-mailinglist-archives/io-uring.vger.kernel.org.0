Return-Path: <io-uring+bounces-3868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66BE09A708E
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 19:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95727B2206F
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC0B1E0E0E;
	Mon, 21 Oct 2024 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fIol4+iS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE671E9072;
	Mon, 21 Oct 2024 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530327; cv=fail; b=ixSUc6DdG1N/iaktYBAHXIWnZ5+/4TK6aFtnPgUaIHLlaXiCuRX4Qch5h2N9LCz8fMjf2tlDvweckMQTRgXIOknvzDkIzeJcC/EvM0HGnEZrlPt/J2z4NlCplCWYzo+NFyfUk9TVWdo6R7ykZYvEyupxZhvSPz3NFX8nrX83DQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530327; c=relaxed/simple;
	bh=5b4z6EfiN8azQNkAzMr0T54XeWhH7kon5SN6Pl4UEf8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L8Rvlv4i+ZSdUDG1LNcqi6oDeOCbT2OFUS5OXeTLl4E2yQSZvWi0QoBIkc292wQN7fqmWirRB9FYkJbKh/jGxynkbobxLFlIynqEXiWIHUpWuxq6Ehk10GVjQpRV6RORAIvZMi1Zj4xviTbUQXpnL7H7hWo0n4bLbE6YEBT7ygk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fIol4+iS; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LDiuce030529;
	Mon, 21 Oct 2024 10:05:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=5b4z6EfiN8azQNkAzMr0T54XeWhH7kon5SN6Pl4UEf8=; b=
	fIol4+iSouNE6zZR0c6dCaWQilOyDn6LTo00frrTEBIpqTiDGFre1SH5sKeRKfuC
	gxHRkOOOeO44JcQOCS1M5QpgBHX6cjnQLSV3ulu6Tn601lXxIudIfZAogwConHbA
	digZUYoFZD0oZdrlyYdyOKZvmVwHUb+eLNBM92DgF7yqaSQ3UBS+CQWxJcLhjzMD
	fdjL9PDGCSFfAFhttpYJT+F04fhzleA+Zp+ghQlC3O6i5j0XV+yTHrEaTFhneQAM
	3C3m73CXK1QTsxy1FP4NdDsmTjUuExGxa8O85MKB4Eig0X1JjeENKtT0QWGFnXYl
	O5Qnh7jQkoORmrprkuShkg==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42dr3ysr0p-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 10:05:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNWAukp1p4y9E/5DNf0br4VqYe96DY+f7b7rnXsHjHeTds9O7szLT2ZrUIVhHzzBjxwUPjjO/QAWNGSOpC3+AW5FwDETfrp6IsiF4A8RyPN82k6O1b/GbGDzuPsbnl53+cgudHTjBHC9mjA1+58cYkkNu2B3CD/Ivv5XO8bkfXguhWEqeCwHcZBww7s8A3/iCsJ79cd+MVyDo3Z4n+f90ERF9R9wyNwjX9l+JsqiXboQzmwqKS9mAlh8XgeI9xS3maGCX9FP1+kNE42ji1Qf42dAdP+P0O9B2SYXihdBN15ei5QdaKgv4bdbQn8zBxOyvDq5dFG2P2oGAbpo5yWW9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b4z6EfiN8azQNkAzMr0T54XeWhH7kon5SN6Pl4UEf8=;
 b=mXZh6GAEQ4pzyTjGCPAI1hGsrD0HMZ1QX6rLLBLTKGB/kIiOMxc6op9aGMCnO0/wNjIjSzUncix72trcHAeWzXCCxfbmu5AZNqclFgeJcjaz2WrCMJHs0ozN+L9afwWHJhs9AvBV3h6CyWQGwHHW1U/B3Vqk8Otw5bOphl0L0MnFrVnGOm8RNBo8U85/UBR3WhldVxmXQsQSoRR2lsWaIsgKW62J6vjlAUexhpZHbaekVAOdhj5KibkQSf1wMoIGsm+7NstJJdzJ2vNL76Gd/CcxZwj2YsEM9typfwsYx/ohXsSYZPnaNFcA7MnO/3kzWFamqYKzbjTD5lZWcOlTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by MW4PR15MB4698.namprd15.prod.outlook.com (2603:10b6:303:10b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.24; Mon, 21 Oct
 2024 17:05:20 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 17:05:20 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Thread-Topic: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Thread-Index: AQHbHl0hRgvHSvFL8kWBhZGVLitDMLKRQ4mAgAA2jYA=
Date: Mon, 21 Oct 2024 17:05:20 +0000
Message-ID: <f4f64bfe-c92b-4656-adec-d073b6286451@meta.com>
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-6-maharmstone@fb.com>
 <20241021135005.GC17835@twin.jikos.cz>
In-Reply-To: <20241021135005.GC17835@twin.jikos.cz>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|MW4PR15MB4698:EE_
x-ms-office365-filtering-correlation-id: 7e6a6234-8373-48d4-bca7-08dcf1f28b80
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MUxycEVRR0hvZWpIVm9rSjFOYitzOW1idWw5SnZqVnBTd0JlaUpSLzgvYW53?=
 =?utf-8?B?NXVCT2Urc3RCOVdBcjZlSkpvdGNrWERkTmhUN0QxUDVrdlRqU1ppUGswVU1O?=
 =?utf-8?B?MUJ3YU9hdDVQZUwxcnp2L1RIMkhySUQ5Y2w3RjdlOS9SU2pwdDVYc3pIWi9D?=
 =?utf-8?B?L3YzaGxOMktRckJBYVkvT2RaN2s5d1UvSG5nc0RXNVU0elkxT1FrblVkT1VE?=
 =?utf-8?B?YTBTeEdOYTV3TzQrNnk2dXY1M1ZxVk1RQUUwRW04aE10cW9YSFptR1FCdnho?=
 =?utf-8?B?UE9BckZrVjBwNlMvWkF6UlpCM25PM25INGswUGoxVGw2Ky9zcmJXcGxzZFBQ?=
 =?utf-8?B?YVNzV2J0allKVDh1VWlyQ1Y1c0d6c2RKbE4rMXg0Z3htR2FPeVVxd1VTUW0r?=
 =?utf-8?B?N1NwWFlGcWxGdVVyYnZHY2dzeDJiMkFsRjEzYlZkTTV5cWo3WUdCVS9sbXhk?=
 =?utf-8?B?dzZpMVdOSE5IZUdnVk90Q0Z2N2J2WFZmdlNoRFU0T2NKaDc5bTI1NjZxZ3pJ?=
 =?utf-8?B?bjFWS0pTK2FoS2V2Z05TZmpZbHY2NkkvRTJWc00vWGpXOVdsQmI0YlVSZDV4?=
 =?utf-8?B?dVZpU3Z3QjVFbG1VOVJBUG5uSkt4Yit4bDE4NmsrWjUzSWVjK3RuSG54SUNQ?=
 =?utf-8?B?alQwRmlGdEo4aXE0OXRuT2R2bXRDMk5QL3JPRzg4MVlIVHJYb0lScXVzT2VR?=
 =?utf-8?B?QUxFd1FzK2xHMTNBcmIxdWhXU25aRXpyUVVOTHYvbW9oZFd2RkdoVGQ2NDdy?=
 =?utf-8?B?dHVNWWw3cnZCV0dlRS82ODBScVFaM2hWdEFtbU5ENzI5UjNVQlhyaUVJa2k2?=
 =?utf-8?B?dGwvV2MvUUVSWVVZMW8zOHhacy8reWwxTVYrbEZNb2xpWUhxajZ5MEx0NnF4?=
 =?utf-8?B?bitHQ3hJVTU5SStSdzBFaVI0eElXZXMvOFdLY0YxU2FjOGUzYTd4Skt6SUVa?=
 =?utf-8?B?U1ZWT1JWdllxTlowTHgrYUEwT01lVmsxb2NKSlA3dWNxcjRCZVUvT2o5b0sy?=
 =?utf-8?B?VDlmdzlzcUVrSmw5R3pkVFdCR2prQnJUSnZLMWpGaTFWZ1NJdkFmOU9Teith?=
 =?utf-8?B?L2JiZGk1VlJWRlI1SmJQZzRZZ1lMdTZKNGIrTlRIWkxHMkZFMEFEaUxSRDBM?=
 =?utf-8?B?MWNWVGRmL0ZHZW9EVm85eithSXJKLzNSajVIVVpIK2FOdjVBcGZUbkl1cnhy?=
 =?utf-8?B?ZkFqKzI0MGdKb2ZrV2s5OGQ5ZUpRZTFid0NsQmlZNUZhWElIN3VMY0NPb0Qv?=
 =?utf-8?B?dkdJRUdXT3Z2elV4OWZjNC9kb3pQaFdwSXFpN1VINW1rcHJvWXhFb2trNVlq?=
 =?utf-8?B?R2hBbjVnaHRjY2gxdkI0dWhjZWtDM3RCTWdBMEZpM2VSR2RISDA5MExKaFBC?=
 =?utf-8?B?NUVkWkI1RFFrWnJETXlJU1pCLzl6Rld4ZFRxK1RaeG9OR2wyL1NSN0RnY2J5?=
 =?utf-8?B?V0FWZVJpNURLN3lPbDJNVWNkNCtPaUY5ejQ4SHdMVHRCeHRDeTBNay9ER3lK?=
 =?utf-8?B?b3lOMTBpMHcvWkg0OUh3TnVTaDRlS1FidU1uZSs0T0hkbnRxZU9mSUltU3k1?=
 =?utf-8?B?eXRoclVFSmNNN1RPZ0xOTE44aEIwSkUyQ0FhNDY1Y3B2VVFacHhDTXMvZENn?=
 =?utf-8?B?RnRwVHBLbC9KaEVzY0szQWJGYW1WZjVtVnVaa3BhdHh3dVpTYmNOZGwzSFRj?=
 =?utf-8?B?VW1oMnRBdEdidUU5VC9MQXNDem93Yy9DaG9WUU5sa1V1VmpYTmNmMUlHL05U?=
 =?utf-8?B?VFR4TGlUVy9oNWpFaW8wd0s4dTVaKzF6MXdkeDZZcVB5M0dqaFVrMDFWOUtj?=
 =?utf-8?Q?CgXvVSoVK3+kT3ENV+yuKMzONgfmU9VXycF7g=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MldHY0dVWWh3QW02V21jVDA2TlFzWkFTR2piK1FTRkJDTU9EVnFSV0ZrL016?=
 =?utf-8?B?VVpJcXh4M1N1N1VoYlY4eEdHb25tRklsNTVkZnluMytTcGV3ZFdETnFMbllJ?=
 =?utf-8?B?TklPZjBVeFYzdng1WkJvbEpFUkprblVUN3ZvNzB0Ykl1S3dSMUtFUjVaVnZu?=
 =?utf-8?B?SEwzeG1Qd1VaMGpYYWs5WkdTRTZGYXJlM3luMlB6cXpucy9nSXpBN0pvQ2FS?=
 =?utf-8?B?TUxuNHB2T281cFgxdHhGQVM4ZnhkRjMrWjg0U0NjM3lqd2VvS0s2bjc0UjZi?=
 =?utf-8?B?a0xNSG5pSGdob01RaGRqdWVZTDN4YlJFRGRuVFE3SVV5NnB3MzY2VUxKQU9P?=
 =?utf-8?B?NjcvZSsrOXpsM2ttMnJweXJEbGpqRlM2WEh2dklabHdjNm5lcXhPTUZYYk5H?=
 =?utf-8?B?ZFVpS1ZTQ0tZazIvdUIyU3NseCszSHB2WDhuekR5Tldkb3BOMmloNTRkbkVD?=
 =?utf-8?B?b09uREFDaWQxazJlREFuT1l2ZHVVeTV2RUxTK0dwd2ZkcXEvWDhuTDVmcnJC?=
 =?utf-8?B?QU9CSCtDb3g5YmRYNFpCZDEyYTZ6WnByREJ0MUJNQUVVenQrTzM1ZzIwT1R1?=
 =?utf-8?B?QkhUQWlYSkdsbjRzc2xMVTBleng1dU5kU0RTZEt1NlZBdmNrTGRGeTJ6U1V2?=
 =?utf-8?B?ZXBlb01PV3pBbDdoRTBlSElkQm11emFqYzN1dCt1RWlvYzllVUwwdGswaTlN?=
 =?utf-8?B?VXJsZ0FnaldnSjNNTE1UZUl5NWpGdllpY0x5MGtnWDB0T1RTUktnMzRMVjJB?=
 =?utf-8?B?aVZqY1M5S3BSZ1NyQzhzak1BVkRuVXd3SE90SlI0Y1Z3N0FtRjJ3c1FSWSti?=
 =?utf-8?B?ZFdQSTBUWGpXMGNuQTJsTzVTZEhDa3BjdVRxV2JOMFZOR1AvOGV0TGJLOG1h?=
 =?utf-8?B?b21CTmRZQnJlMC9TaVdlWnM3c2tjOTV2SkhXdlRHK05JYm5reVN0V3JFV0c1?=
 =?utf-8?B?WUwwbThzd09MSEZiR01ieU92NGpTNnkrY3BaT3hzK04zSGxEaWVZN1lwVUVw?=
 =?utf-8?B?dUlaczl1WW9nS0x5VmtJQ3FoeEwxRU4zcXdSbFovUlhPU2JmODRWS05TMk40?=
 =?utf-8?B?UE5jVEZYOENHYnQ4N3Z4czNLanhFRlh5d04vRlQyeEk0TEtjaU5vK0d2MnRX?=
 =?utf-8?B?VXRYb25zVDFYOEVKNTlCQzV1cnlTU0hHcUVrWG5nQzJXM3JXRmlYU3JxRnA5?=
 =?utf-8?B?Z1BmcnFmaU1wYkNCc1htZ2FKVVE2WU5laVM5VDk3ZERtc3V6SzVkb1JqdDhy?=
 =?utf-8?B?L2Y4Y3pVVWVPUE5OdEdNdHhERGprM0hJeUV4SFFrVFRJZU1iU0cvM1RlcDN1?=
 =?utf-8?B?S0JNWkRmcWdjNm5uSk90bU9zQ2NRSE92THpHQUlVcGlvVjVuOUg2MUZSekxy?=
 =?utf-8?B?anFFay9qU3RLVVQ2WFBxZFFYOFZuaThTZWpYcWpRL1AxQnZudy96MG1XUW1Q?=
 =?utf-8?B?NGZHZzNTcmdyV0w4dGVtcWhXSitWM09URklzMG1UZlc3TGJmMDEvdG5Na1JK?=
 =?utf-8?B?REQ4MFRaRmFHbUZ6Q080d3ZwNjlmdFVqU0dkeEtPeEVia2RRZjhEVzdUTXNp?=
 =?utf-8?B?ZndkWmw0OEFPWFdqRDVwcW8yU1dvYVdWMVd4WFBEWlE0RHdHbUVFcnNxMlQy?=
 =?utf-8?B?ajZNODVuUUFTd1FveG1mY3orTS9OU2txR2FQUkU1QmdlWnFoSW4wTlNUVjVh?=
 =?utf-8?B?MmptcFFmMXFqc2lSdjBVYzQvWVRzWXJLY2dPVEg0Z2FmaUxuaFhXRXB4eVdT?=
 =?utf-8?B?SFpJTFdsR3ZuTWhleUdWdzRocnRCTks0QkFsdDhNWjNCVU1hMFZWY09OeVZR?=
 =?utf-8?B?cGNIRmlnSDVhRDdzUm5ZUE1SKzVscGU2aGhZZFBpMXk5Sy9OQXFYYnRsbk8x?=
 =?utf-8?B?ZlJFNXVxbmYyOWhKV3FaYVFvK2kyMXkvMzFaVFJSR28rS0pWTUVaVkM4bjYv?=
 =?utf-8?B?ZEQ4aVBxVXQzWng1N2VGMnZYUUxyeHRQNy90bm1nS0dUdkw3dXhlbGo2bXFT?=
 =?utf-8?B?ZUx4SUZkUFdHdXRwMjBuZndaTDZlQ0pUUXZSMzhwQzYveWxWTjNrbkhxTWlM?=
 =?utf-8?B?bGRkdXYvK3QyV2lZUStvSVdGZHdWaWtoMHNtZ1JzWmdFa3pMYUxBK0lmd3pX?=
 =?utf-8?B?MVZUQVVOTHREckFUdnRORi9NaW5hY2l6YkJYUFZiMkFsbnRDNm9vN2pweXRT?=
 =?utf-8?Q?sgJG9TQMThZnB85TnMLMGj8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A5C2CDBF32EAF459C45A507118C0741@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6a6234-8373-48d4-bca7-08dcf1f28b80
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 17:05:20.4096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2u2SkzAPKYLZ2aiq8ZezQr2IzoXoKF0BPUd6BTyRRXgEFFqbrTiguCXglPB0hHHZDYmxZ86nbT+Xm4YkjwRXvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4698
X-Proofpoint-ORIG-GUID: i-skGWIxy93L8-k_hLauNCepoJoS0iqr
X-Proofpoint-GUID: i-skGWIxy93L8-k_hLauNCepoJoS0iqr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

VGhhbmtzIERhdmlkLg0KDQpPbiAyMS8xMC8yNCAxNDo1MCwgRGF2aWQgU3RlcmJhIHdyb3RlOg0K
Pj4gK3N0YXRpYyBpbnQgYnRyZnNfdXJpbmdfcmVhZF9leHRlbnQoc3RydWN0IGtpb2NiICppb2Ni
LCBzdHJ1Y3QgaW92X2l0ZXIgKml0ZXIsDQo+PiArCQkJCSAgIHU2NCBzdGFydCwgdTY0IGxvY2tl
bmQsDQo+PiArCQkJCSAgIHN0cnVjdCBleHRlbnRfc3RhdGUgKmNhY2hlZF9zdGF0ZSwNCj4+ICsJ
CQkJICAgdTY0IGRpc2tfYnl0ZW5yLCB1NjQgZGlza19pb19zaXplLA0KPj4gKwkJCQkgICBzaXpl
X3QgY291bnQsIGJvb2wgY29tcHJlc3NlZCwNCj4+ICsJCQkJICAgc3RydWN0IGlvdmVjICppb3Ys
DQo+PiArCQkJCSAgIHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCkNCj4+ICt7DQo+PiArCXN0cnVj
dCBidHJmc19pbm9kZSAqaW5vZGUgPSBCVFJGU19JKGZpbGVfaW5vZGUoaW9jYi0+a2lfZmlscCkp
Ow0KPj4gKwlzdHJ1Y3QgZXh0ZW50X2lvX3RyZWUgKmlvX3RyZWUgPSAmaW5vZGUtPmlvX3RyZWU7
DQo+PiArCXN0cnVjdCBwYWdlICoqcGFnZXM7DQo+PiArCXN0cnVjdCBidHJmc191cmluZ19wcml2
ICpwcml2ID0gTlVMTDsNCj4+ICsJdW5zaWduZWQgbG9uZyBucl9wYWdlczsNCj4+ICsJaW50IHJl
dDsNCj4+ICsNCj4+ICsJbnJfcGFnZXMgPSBESVZfUk9VTkRfVVAoZGlza19pb19zaXplLCBQQUdF
X1NJWkUpOw0KPj4gKwlwYWdlcyA9IGtjYWxsb2MobnJfcGFnZXMsIHNpemVvZihzdHJ1Y3QgcGFn
ZSAqKSwgR0ZQX05PRlMpOw0KPj4gKwlpZiAoIXBhZ2VzKQ0KPj4gKwkJcmV0dXJuIC1FTk9NRU07
DQo+PiArCXJldCA9IGJ0cmZzX2FsbG9jX3BhZ2VfYXJyYXkobnJfcGFnZXMsIHBhZ2VzLCAwKTsN
Cj4gDQo+IFRoZSBhbGxvY2F0aW9uIHNpemVzIGFyZSBkZXJpdmVkIGZyb20gZGlza19pb19zaXpl
IHRoYXQgY29tZXMgZnJvbSB0aGUNCj4gb3V0c2lkZSwgcG90ZW50aWFsbHkgbWFraW5nIGxhcmdl
IGFsbG9jYXRvaW5zLiBPciBpcyB0aGVyZSBzb21lIGluaGVyZW50DQo+IGxpbWl0IG9uIHRoZSBt
YXhpbXUgc2l6ZT8NCg0KWWVzLiBJdCBjb21lcyBmcm9tIGJ0cmZzX2VuY29kZWRfcmVhZCwgd2hl
cmUgaXQncyBsaW1pdGVkIHRvIA0KQlRSRlNfTUFYX1VOQ09NUFJFU1NFRCAoaS5lLiAxMjhLQiku
DQoNCj4+ICsJaWYgKHJldCkgew0KPj4gKwkJcmV0ID0gLUVOT01FTTsNCj4+ICsJCWdvdG8gZmFp
bDsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlwcml2ID0ga21hbGxvYyhzaXplb2YoKnByaXYpLCBHRlBf
Tk9GUyk7DQo+PiArCWlmICghcHJpdikgew0KPj4gKwkJcmV0ID0gLUVOT01FTTsNCj4+ICsJCWdv
dG8gZmFpbDsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlwcml2LT5pb2NiID0gKmlvY2I7DQo+PiArCXBy
aXYtPmlvdiA9IGlvdjsNCj4+ICsJcHJpdi0+aXRlciA9ICppdGVyOw0KPj4gKwlwcml2LT5jb3Vu
dCA9IGNvdW50Ow0KPj4gKwlwcml2LT5jbWQgPSBjbWQ7DQo+PiArCXByaXYtPmNhY2hlZF9zdGF0
ZSA9IGNhY2hlZF9zdGF0ZTsNCj4+ICsJcHJpdi0+Y29tcHJlc3NlZCA9IGNvbXByZXNzZWQ7DQo+
PiArCXByaXYtPm5yX3BhZ2VzID0gbnJfcGFnZXM7DQo+PiArCXByaXYtPnBhZ2VzID0gcGFnZXM7
DQo+PiArCXByaXYtPnN0YXJ0ID0gc3RhcnQ7DQo+PiArCXByaXYtPmxvY2tlbmQgPSBsb2NrZW5k
Ow0KPj4gKw0KPj4gKwlyZXQgPSBidHJmc19lbmNvZGVkX3JlYWRfcmVndWxhcl9maWxsX3BhZ2Vz
KGlub2RlLCBzdGFydCwgZGlza19ieXRlbnIsDQo+PiArCQkJCQkJICAgIGRpc2tfaW9fc2l6ZSwg
cGFnZXMsDQo+PiArCQkJCQkJICAgIGJ0cmZzX3VyaW5nX3JlYWRfZXh0ZW50X2NiLA0KPj4gKwkJ
CQkJCSAgICBwcml2KTsNCj4+ICsJaWYgKHJldCkNCj4+ICsJCWdvdG8gZmFpbDsNCj4+ICsNCj4+
ICsJcmV0dXJuIC1FSU9DQlFVRVVFRDsNCj4+ICsNCj4+ICtmYWlsOg0KPj4gKwl1bmxvY2tfZXh0
ZW50KGlvX3RyZWUsIHN0YXJ0LCBsb2NrZW5kLCAmY2FjaGVkX3N0YXRlKTsNCj4+ICsJYnRyZnNf
aW5vZGVfdW5sb2NrKGlub2RlLCBCVFJGU19JTE9DS19TSEFSRUQpOw0KPj4gKwlrZnJlZShwcml2
KTsNCj4gDQo+IERvZXMgdGhpcyBsZWFrIHBhZ2VzIGFuZCBwcml2LT5wYWdlcz8NCg0KTm8sIHRo
ZXkgZ2V0IGZyZWVkIGluIGJ0cmZzX3VyaW5nX3JlYWRfZmluaXNoZWQuDQoNCj4+ICsJcmV0dXJu
IHJldDsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGludCBidHJmc191cmluZ19lbmNvZGVkX3Jl
YWQoc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLA0KPj4gKwkJCQkgICAgdW5zaWduZWQgaW50IGlz
c3VlX2ZsYWdzKQ0KPj4gK3sNCj4+ICsJc2l6ZV90IGNvcHlfZW5kX2tlcm5lbCA9IG9mZnNldG9m
ZW5kKHN0cnVjdCBidHJmc19pb2N0bF9lbmNvZGVkX2lvX2FyZ3MsDQo+PiArCQkJCQkgICAgIGZs
YWdzKTsNCj4+ICsJc2l6ZV90IGNvcHlfZW5kOw0KPj4gKwlzdHJ1Y3QgYnRyZnNfaW9jdGxfZW5j
b2RlZF9pb19hcmdzIGFyZ3MgPSB7MH07DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICA9IHsgMCB9DQo+PiArCWludCByZXQ7DQo+PiArCXU2NCBkaXNr
X2J5dGVuciwgZGlza19pb19zaXplOw0KPj4gKwlzdHJ1Y3QgZmlsZSAqZmlsZSA9IGNtZC0+Zmls
ZTsNCj4+ICsJc3RydWN0IGJ0cmZzX2lub2RlICppbm9kZSA9IEJUUkZTX0koZmlsZS0+Zl9pbm9k
ZSk7DQo+PiArCXN0cnVjdCBidHJmc19mc19pbmZvICpmc19pbmZvID0gaW5vZGUtPnJvb3QtPmZz
X2luZm87DQo+PiArCXN0cnVjdCBleHRlbnRfaW9fdHJlZSAqaW9fdHJlZSA9ICZpbm9kZS0+aW9f
dHJlZTsNCj4+ICsJc3RydWN0IGlvdmVjIGlvdnN0YWNrW1VJT19GQVNUSU9WXTsNCj4+ICsJc3Ry
dWN0IGlvdmVjICppb3YgPSBpb3ZzdGFjazsNCj4+ICsJc3RydWN0IGlvdl9pdGVyIGl0ZXI7DQo+
PiArCWxvZmZfdCBwb3M7DQo+PiArCXN0cnVjdCBraW9jYiBraW9jYjsNCj4+ICsJc3RydWN0IGV4
dGVudF9zdGF0ZSAqY2FjaGVkX3N0YXRlID0gTlVMTDsNCj4+ICsJdTY0IHN0YXJ0LCBsb2NrZW5k
Ow0KPiANCj4gVGhlIHN0YWNrIGNvbnN1bXB0aW9uIGxvb2tzIHF1aXRlIGhpZ2guDQoNCjY5NiBi
eXRlcywgY29tcGFyZWQgdG8gNjcyIGluIGJ0cmZzX2lvY3RsX2VuY29kZWRfcmVhZC4gDQpidHJm
c19pb2N0bF9lbmNvZGVkIHdyaXRlIGlzIHByZXR0eSBiaWcgdG9vLiBQcm9iYWJseSB0aGUgZWFz
aWVzdCB0aGluZyANCmhlcmUgd291bGQgYmUgdG8gYWxsb2NhdGUgYnRyZnNfdXJpbmdfcHJpdiBl
YXJseSBhbmQgcGFzcyB0aGF0IGFyb3VuZCwgSSANCnRoaW5rLg0KDQpEbyB5b3UgaGF2ZSBhIHJl
Y29tbWVuZGF0aW9uIGZvciB3aGF0IHRoZSBtYXhpbXVtIHN0YWNrIHNpemUgb2YgYSANCmZ1bmN0
aW9uIHNob3VsZCBiZT8NCg0KTWFyaw0K

