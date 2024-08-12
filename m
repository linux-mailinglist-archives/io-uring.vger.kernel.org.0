Return-Path: <io-uring+bounces-2702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C4594F02B
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9AE51F26000
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 14:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4976A18453E;
	Mon, 12 Aug 2024 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="efduv/de"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826EA186E5F;
	Mon, 12 Aug 2024 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723473994; cv=fail; b=JkYKOO8NuE4U3B/YR3PYNywwRpfJVqYaxh/aHNS1ycJ/J/52kH6GPuAgwMWd3pM6VpwCY6NnQb9/vAMjjfit7UE/KcvEeUoPd5oiKpP580ZNR47Q/mB+b3zkPyV8L9NrbeblOTXtmRvzyK4b5r1a9p3r2klybf0MOGzaOujVDLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723473994; c=relaxed/simple;
	bh=kPGFSuz7B6pF9iUW7ga274T6tgSPiAGiDVCZRARV9hE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Uxtc+nSZeNktX3SgIlVGo4Z2PzyKCmYLcxUl1l2ObXZpef9H00wWepCDCY2bowuwQvmGDSBodv5/3Tv6OeZ6eDhVAA+ZpLs4A3+wChTzoocWfVVF8FZl/fytUYz4WXELbTsZsf3Pl4FeZHvzKDY+unV5EGcRViXfCnH6BDxlt+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=efduv/de; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CEeJ7B029727;
	Mon, 12 Aug 2024 07:46:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=kPGFSuz7B6pF9iUW7ga274T6tgSPiAGiDVCZRARV9hE
	=; b=efduv/deRHRFb22zVQbLx4QiGyQY0hEwb8pVSuBiezpTXa71GEFpX1kHT0l
	+OmAtsLtSQEt4mI9K0F6gVWRgGAKeUFs2gtmcGuyF1n8kALfACcji2g1VCwVfhfv
	9HbMsK3s6doXuIOFmlq5AZWgnXrgRBBX/hUc9LAe4bhyVMbfzMm7GsdW8aqI/uLA
	2FMwhmySlRABtc5xMM2W7+FiBMt1uDRs10WUM2VzWIQWw9XL7+fQSwRvLoq6+6wq
	bk0nfH5pYflYUMb9ZKrgGLnxb3XrgDpbvLBmWeLmXXPeF3gQIksbD9JyN+BuyeCX
	f9jeLWDx/Wex/51mcUNH16wm9Iw==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40ycedjqv1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Aug 2024 07:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxkmMltR2wRdayTHSQZc9Y7kUfd5qrxZIqbh25MvjyxyL3WBXdCKtfIuqtysx9EIn4QqNyrxjx1TPvkhSeXjYSdpruMvGDLjfbrEWf/PkZJBgPcQWmpEeuSa0u/2wOZxZinHyjkB3r+gH/yRHThG9ATVuF+80LHhWN8Wj3re4dKsaq+O8Tq1klps5Zm+tpxCyopdcJbYcjcSFoEh14zNOI1C6f4r+5M7tXQ40onNj4nq9yRgbYzv5eY2JazIx/h6UCAmJrJjkGTQ94sPV77NIATwJqZSGGw2VDeemF+VGZjv9xBZfqixtDxW4no/PxzZ7P6yMONt9uwYhdECTyhOcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPGFSuz7B6pF9iUW7ga274T6tgSPiAGiDVCZRARV9hE=;
 b=NI8jr3gmI3UndL0vqhYkAh9tOmr15ro1xmexTX3xcwcraj7QijmbPGtP0NGcdT0/iqxw37t+/txk2sc78+E2hjIQV0oJeTSwoCeqh7X38PGL29Z6dS9/M0/sb7pfreobt4fOvx34WZZWdrvrW7aYceoT3/1p5tGTfltKGAzPb3fbPogTM3UUi19b4IVJ8l/JbPLS/RJ7P5mBhqQLOC1Ccq8s0BeKtHd4HP9kht9eWJZTjFUjsRNuCmG+2TJANNljC+wpByFqcIQOrReQ5pwTwAVsKMD4/gW5/6LFy0elSHhm/7yTkzvRUG8ZXrxq1OXV5cZcShxXU9ml8FGXGjD3vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by MN6PR15MB6313.namprd15.prod.outlook.com (2603:10b6:208:47e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Mon, 12 Aug
 2024 14:46:27 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%2]) with mapi id 15.20.7849.019; Mon, 12 Aug 2024
 14:46:24 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
Thread-Topic: [PATCH] btrfs: add io_uring interface for encoded reads
Thread-Index: AQHa6oKXcffdr/iQJkqMwwpZ694dJLIjgBAAgAA3uQA=
Date: Mon, 12 Aug 2024 14:46:24 +0000
Message-ID: <ac79ec76-200e-44bd-80fc-08ca38c565d0@meta.com>
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
In-Reply-To: <Zrnxgu7vkVDgI6VU@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|MN6PR15MB6313:EE_
x-ms-office365-filtering-correlation-id: 103c9718-c87e-472b-fce8-08dcbadd8a34
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VUtaeWs3Mk91U3lrY0lXWVg0UGhDZmZpQ0o4WTg4WmtTZW5xZGtDWlVXRU4y?=
 =?utf-8?B?RjhieERVSExtaGM5emlpVWdaWUxlbEIvL0E3SHJVclFnelFnbkpUMU8xNDZa?=
 =?utf-8?B?T3h6dThzNVFVYWUvYWRIUk4raXc0M3RTcVNtNk04SkRqL0l2YzhLUXBLMGZU?=
 =?utf-8?B?a1lCUnJoRWVQNEJ6OXpGRk4wMnQrWFhpb0dtWExCRkVmNldURjRqYUc4N1l1?=
 =?utf-8?B?NWNnMjN2UFN5YnNudkpBVExyOUYwb2FEclp5dTJ6ZGs3cERtVURwTkZ5UzVY?=
 =?utf-8?B?cWlDUmo1UjhmRzl4Qk54S0RPeHNLSXJuTUZUT1JVYmpOc0FFS1VTVCtIdUVL?=
 =?utf-8?B?WWFQVnJvVktoUElGai93T1lqZUdFWlRxT2VrWEREbHNQR0NkdkJvV1BndjFS?=
 =?utf-8?B?WDQ4Q294ejRMS0lWYWY0WUtMczlIK1diZVljNXp6MkMzWlhoSlJBM2hDNGNK?=
 =?utf-8?B?ZlA3V05KdndER1YvMmJhdjdsTnE4b0NQWml5Znhackw3WndMRmUxWkxicGU2?=
 =?utf-8?B?cHlrcU5GWStiZ1JHMTVTWVVuK2VrcDk3STJIS245SGgxaWRQVUJKUGdaSnB1?=
 =?utf-8?B?QjFySEpKYXMxYXo1TmxnMHpvcjZGTEtDTk0rL2RkTHhKeEhDK21oWk9BRkNH?=
 =?utf-8?B?ZFVsMFBXMDI0WXRFNWxBWkVmUU5JQ3hQWFZXWnZsYkVtdlVEZFVCSmRLdDVq?=
 =?utf-8?B?c2V2S2NWWnBocDg2cFhlMlRYYTJUVFJBWnZjQzBJR3JNUUZOcmdwS1ZTbnRB?=
 =?utf-8?B?aCtoUHo4SXZBSWJBMFpEWm8rQ0tHRytELzc2OW5keTFYMWZSUWo1Uk9KMW9K?=
 =?utf-8?B?Y3IzTXlZQi9YOFFuYUlGMUI1RGhFKzVyVGZyVnRySXhZbVMvSHVmTUNuV0d5?=
 =?utf-8?B?ZU0xUHVBWDZMbFFCdnlTR1p3ZTJCRWpzMmxxVFVlMGVOWDAvT2dMNzNGa29N?=
 =?utf-8?B?NndEaHV1VXg5a0wySlcxVUxidnFSWjJrV2RiUWJjWHF5UXhUS3RoTXdsRnRn?=
 =?utf-8?B?YVRRZFMyS2hBeFgyOUtpTjZ1NllpVGdWR0ljMjQxU1RGbWg3Zkkva1B4a0gr?=
 =?utf-8?B?ZjJxRTIzV0hMaGt3TTQzODhpdnVSOXpYeFI5QW1zaU9hUDFZZktZVFZXbW5l?=
 =?utf-8?B?dDY1MTI0ZnJtdDBKL2lZN0hpa21WOFlMc29oZDRhdzFsYTlYYmFlak5HMFFX?=
 =?utf-8?B?WjU5WVhvR3JYNGhJdzVjZHZsT0ZHR3pZT0xOOEU2ZlZUZW00bVFpVUZnM1Br?=
 =?utf-8?B?MENMTlM1QldkZWxGRURJM2FVVmN5azZKelh6U042OEVENzZsSFVEbVBaQ2tp?=
 =?utf-8?B?MXNrM1N1UmpSOGU0TGV2dTZhNXpjWW45YlJLSUk1NWF2SVZpMEVqQ0U0d1pR?=
 =?utf-8?B?OGJtS1pZN1dtcWpiai8rTWhrVlFyeE14RitvNzlpN3JuRkoycTk5NVIreWpn?=
 =?utf-8?B?UmtwWTRyb2ltZ0tTdEFrbWpZZDJqSTNBY3hYMTlCOVFqbFNPV1lqOHlCY1Q2?=
 =?utf-8?B?Yi95MjVwRXIxekIrQ1hqMUlDYUZEdm12MjdBVzNrbVRiODVJL0NHdjY4ZGJJ?=
 =?utf-8?B?T2NGaThsQzFRTmtaUnFTb2NkajlvVERkVHpwemcrQ1hra09rdVpQeHU4Vmly?=
 =?utf-8?B?blM3ODB3aGZXRkRvZlB4RXZuN3hnM1IwaXpjZUg1MXFvU0xRQTIxNWpWV2k1?=
 =?utf-8?B?cXJET2c4VHYvSGVTd2pUNWFDY05iNVRsUXNCWFd4bFd3Y1JzcDBtQUxGRlZE?=
 =?utf-8?B?VjN3NjFsd2lCMDVoTWVrd3l2SU41RHV5RkYyOTZVdzZBVXBmWFNTVUR1SU81?=
 =?utf-8?B?S1NVd2J4ZXAxRGNuRGdnT3lOcXErN2RHbGVUNE0wZ2U0bEJ2dzVNc1hkdEtW?=
 =?utf-8?B?amRsR3ZmYmhYTGZ4WFJwY3dGTmtzaXg2aGxKOTQrOWY0SkE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MHFhS0pRVkt4WUlCUUpxbWZSRGplN1JuZmJwdVdWU0N6dUdqSldPU3NmaWJ2?=
 =?utf-8?B?QmQ5UzR1dCtGeEIwWllJeEVTQm5WdE9COG1YOGdTTUsyVWNFc0VWREdyQ0FH?=
 =?utf-8?B?eStsWVFYbVJwNk5Sem9jRGJwQlBzNkY5ckZoZkd0SmNhT0lkVk1vanAzN3ZZ?=
 =?utf-8?B?akpITWFtOVg2YmV4b0hDN1VVZU1HbUczZmtDd3BLcGtBS3VLczJSaGIrb0RU?=
 =?utf-8?B?ZzVubW5qYUxORmJCZTdBRzJVWUwrcWkzOXo5RWpuNWJoeVYxWUFIYVN5YkNM?=
 =?utf-8?B?RTIyMjdFVE9YOFlUTXgwY2M1VmRZbGhTc1dTS2VkdzUyZklzamJzVG80cWU0?=
 =?utf-8?B?Z29Xa3BxV3RjRkxCVUFHK1Z2RFo1ZDFVazVrZTFBT05tVFNNdmplOWFNOUlY?=
 =?utf-8?B?N0ZaNDBnME1rNEVMdzdsRkMwOHVPY3BXZC9qOGZidTFnR0pGTkJ1NUtzVGRa?=
 =?utf-8?B?NHFFQVhsR1NUNlVwMm1JOW9WMFJZQmtmZUh5VlZuVHNIUHUyUFZ3TmlGTytE?=
 =?utf-8?B?VW13aEJJMnhmdWRucko0bWJGenR4cTRoNVRvM3RyWmptaU1VTUdQSUtXY3lL?=
 =?utf-8?B?OFVQbTlQemxjMTlJRm4xVEFsWGZzZThDcnE1QTFBVml6TWQrZDBBQStHTUxu?=
 =?utf-8?B?T1pzMlU5SnJMRm5iK2VYT1IvMHhFbUs4cjdkRkg4OUFjdHkvMjhlTWhvMUhK?=
 =?utf-8?B?UEFDRkhReDBOUnZEOGZ4R3ZzRWwzWVVUUUJMZjJhMGFXaUZZZ3A2K3o3L08w?=
 =?utf-8?B?NUN2UkxOR3d0aEJQcC96enREZXM0eENqWnoyMXd4b0pzN1oxN0pxTnd0eDNK?=
 =?utf-8?B?UEdtM3ZGSFlDcllnWGhTdGcvMnppTUN4cXR1WGJOQUd1VXd3U1c1Nk1nTGFi?=
 =?utf-8?B?SXNsVHZjZGg4K3RpQ252Z1FFMitaTzNrbS8vSHlIWEl4Z3MwVDk0Tk1iZTk3?=
 =?utf-8?B?TUp2cEY2R3RkWGxxUVdtWFo3Wnl6WWs2V3hkL1JvU3MzZ1Rwek9KYUEzbzdX?=
 =?utf-8?B?YVJ3Y1Q1QU03L1RYOW5RTmxZY3licXR3eFNSR0hURzFpeFVHRUpyNCtDa05z?=
 =?utf-8?B?WGU3MnV0RjZwUEQ2a0RaVG1UL1BrRk9YQkFzcmpqTzZGeC9iOTBVbXFtNU83?=
 =?utf-8?B?dUwzOTdJS2hody8vWG1oTDFmT3dPcFZCK2U2QXNZaWtzV25sN2ZpWWZaeWpz?=
 =?utf-8?B?bXRtcVhSeGlhVkM3bjhiRnQ5MC9WRTdWb3pPUjg0a1BFYlAxQkpKeFUrWnV1?=
 =?utf-8?B?bXBxV2NwRGRhVTROZTlqeDcyRU5vNjZocEE0UkFhUkZjZWVyMVcxZGxkRHFO?=
 =?utf-8?B?cWtGMGpDaGhUSnV0dnVLa3I2cmxqQUNrWUc0dHlQL2FkTlFqMWdNZlBNRU1m?=
 =?utf-8?B?d3dmb0tLRnppNy9JZ3k0WjlkYy9XOGJKOVZXT05tQ0tOQW5HUGZ2bjdSZjRn?=
 =?utf-8?B?WEFuaVJ3SEttanRQcTRnaDV5a0ttTVMzSnZMRXVqUmlhUzNndkRyWi9GT0E4?=
 =?utf-8?B?cE1ZSlF1ZU05TDlTTEsvNDlPT1FCMTQrbXRKRW1yVnBkSkhpeUFCYVR2S3ZG?=
 =?utf-8?B?RDRrdmphVGxGWGRsZ25KL1FQWXlHRTdqdWdFbityOUo0RDJyWVBjOU1qN1N4?=
 =?utf-8?B?ZHlkamJ2YmRQVlBHQmlSbjBiUmVZZjVzd2ZDSWdYUS9DWUpWUXVBTUMxa2VG?=
 =?utf-8?B?Q0REQVRPMFpsMVhYRFdYR1U5T0xCcTVBRG4ySWVTYnRKdkNtTUl5K0hvMEJ3?=
 =?utf-8?B?WStzekdGUEhSQjNsWEo1ZnhoVDZCWXk5cGltSFZFUDE5QXMraHYrUEJBR0RD?=
 =?utf-8?B?TDZWQ2FHREdVVVpPYVNPSWpBVkZ5V1pLeDdnTDBvUjZwUHQ2Y0p6ZGU5OVlv?=
 =?utf-8?B?eDlUR2QvcWZ1N012Ung2VjNnR0pVWmhtNDZJVTRJU2s5MXQ2TkxtQzRsS0tN?=
 =?utf-8?B?Vk1XemNiZFZJT0pJOUFiMDBSK0R5cXFDTHZFYkljcHJsTlFqVTlVU2YzSWla?=
 =?utf-8?B?N0dlendJaTRjanJLTWozUVBLZ3N0dy9RQVRBUTdYeUJqMUk3UlAyMFd3TzJj?=
 =?utf-8?B?Mk5odjN6L0QrNjhtdzkvVHovUmRJWVVLZFdpYkNBU2ZSRDBqOGxYa0lQWnYr?=
 =?utf-8?Q?U+gLjBEwnBBbXOAKlgdZGnp3H?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB5478D23FE9C04BA4EDE3832491F80A@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 103c9718-c87e-472b-fce8-08dcbadd8a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2024 14:46:24.8591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Glel891ByDVcdCyQ6nEA7MpWPOzRSdKyPwFOJ211aSKCpjsYVfd7PZwFuQj6z2e+T4eaG72ltEuOcPfeZc7U7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6313
X-Proofpoint-ORIG-GUID: nnhMYdlifkfnoS2d7jt2le6xdNqV9obo
X-Proofpoint-GUID: nnhMYdlifkfnoS2d7jt2le6xdNqV9obo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_04,2024-08-12_02,2024-05-17_01

T24gMTIvOC8yNCAxMjoyNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdoYXQgaXMgdGhl
IHBvaW50IGlmIHRoaXMgZG9lc24ndCBhY3R1YWxseSBkbyBhbnl0aGluZyBidXQgcmV0dXJuaW5n
DQo+IC1FSU9DQlFVRVVFRD8NCg0KSXQgcmV0dXJucyBFSU9DQlFVRVVFRCB0byBzYXkgdGhhdCBp
b191cmluZyBoYXMgcXVldWVkIHRoZSByZXF1ZXN0LCBhbmQgDQphZGRzIHRoZSB0YXNrIHRvIGlv
X3VyaW5nJ3MgdGhyZWFkIHBvb2wgZm9yIGl0IHRvIGJlIGNvbXBsZXRlZC4NCg0KPiBOb3RlIHRo
YXQgdGhhdCB0aGUgaW50ZXJuYWxzIG9mIHRoZSBidHJmcyBlbmNvZGVkIHJlYWQgaXMgYnVpbHQN
Cj4gYXJvdW5kIGtpb2NicyBhbnl3YXksIHNvIHlvdSBtaWdodCBhcyB3ZWxsIHR1cm4gdGhpbmdz
IHVwc2lkZSBkb3duLA0KPiBpbXBsZW1lbnQgYSByZWFsIGFzeW5jIGlvX3VyaW5nIGNtZCBhbmQg
anVzdCB3YWl0IGZvciBpdCB0byBjb21wbGV0ZQ0KPiB0byBpbXBsZW1lbnQgdGhlIGV4aXN0aW5n
IHN5bmNocm9ub3VzIGlvY3RsLg0KDQpJJ2QgaGF2ZSB0byBsb29rIGludG8gaXQsIGJ1dCB0aGF0
IHNvdW5kcyBsaWtlIGl0IGNvdWxkIGJlIGFuIA0KaW50ZXJlc3RpbmcgZnV0dXJlIHJlZmFjdG9y
Lg0KDQpNYXJrDQo=

