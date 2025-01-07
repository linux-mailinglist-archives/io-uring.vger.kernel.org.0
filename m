Return-Path: <io-uring+bounces-5744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A39A04926
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 19:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2535F18860FD
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 18:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E6715B135;
	Tue,  7 Jan 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="FmOD4aQV"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655C686330
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736274296; cv=fail; b=GG3Q37YE6XfRDdRmP8Eq503+a4YLWYVJmvV/QUJScdl5P+35LW4o0UEWYzIl/3eYUVFR2Hk8WMgOOB8rdje7ZqdLA7mErs9qOq9WaIh3i34y+WO194X9dg076gSHAZgYA9IwQcS9ZZSPkgpPuPO+iIu3eh7ROOq7BB4ep0eMBr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736274296; c=relaxed/simple;
	bh=HSO7B97/bHERpCfzLkwy3HsqhBij//kJYjQWJv3QmOM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nrJSXzlG3cSvKmTu3XuO1yGvbcEqbVFMEGZTxD+HKXj9HiLbuJk+DwPrCwY2quVLEXhjmTnt9PuK4frjGDbfwo/RFlX0/9WSXylIVmUiKU+zumHUvFbB02mLDBW7Bni/9PN7tDREk4fznXbOyvAS2U8YxhKsnBzazWbfezE+GiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=FmOD4aQV; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507GYFOe023220;
	Tue, 7 Jan 2025 18:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=HS
	O7B97/bHERpCfzLkwy3HsqhBij//kJYjQWJv3QmOM=; b=FmOD4aQVUv95kXA6ra
	aMKFFSMMU8bmDaJhZ422+0v8fcaD3mHGObJFspKcyliB88bOnD2w5+pcLD8psT2e
	0j+NityDHwDLSbk1LsoPhwgq5/Jx+c0t0qE9WYRGAbKUVub05qirUvYCoQlxTwyG
	oh4bjrTLj/9PbOWfMGG5jUYs9Jariwy99rwIzbuPAM+SUKtdhUv0k2BQh7+FvAju
	EgUxxzIku9Ko9rLIjqZIq1BCfM6rqQv11VN5b+Qa6rQlpPLAmagDcNT+Y1HkVp+h
	Hg+IGAWmDc3dMW+m0SZywBIr3NnB23CKVdkWkbjh1ZnITuL5HW17fIE6VbSHAd7U
	uzJQ==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4417wg1072-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 18:24:49 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id CDB5A2FCC1;
	Tue,  7 Jan 2025 18:24:48 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 7 Jan 2025 06:24:37 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jan 2025 06:24:33 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11 via Frontend Transport; Tue, 7 Jan 2025 06:24:33 -1200
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jan 2025 06:24:38 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tpn1XStmIKC4q8SZyy/zSOQFQiUvEcSAEMwvaJ+YkqMfV1cegIzFZDBkrnEFws1mhmjcqkWNCxuwh25w6Ls5I2dgaUEKzOmf4ujDRGn87DoTC7+wWIrKnZe1h/ER2qGhx3AJBHVqq6xZUrH8fm8f7UsjNOQHvWCW1gSrhvMuyerRSSljJ+IJ7FRI0AoiuPsFry0khtA7Z2/Wu3yE0e4hGXbI0+SFvPd2QMys7d0PF6Na0y6QlwGvkTxmXkXId8TCxJlO9JCvE+lqwyWxg/j5qNgPk+IGFgEB/olN64ZQxDWxidEnBUGj/5S9+MsLk1xf8UBpQhbsJulQMBs6vCJKvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSO7B97/bHERpCfzLkwy3HsqhBij//kJYjQWJv3QmOM=;
 b=nLUjlGh6v2R1B++jnLKPnM008ja+c5i8L7Vxm1zRZyUrmtqmi2ijU83c93hy+cIwNWlW35Zk0AsmqGCox23PBi31gF6WPNGuVjIGZqOGFvtLFBpWtLcgNatod965td38UWDQrh7o9gwBwHsIt6EQTr2TZkP3sXN8c1p7xKLULrZYC/wxQL4mWs1wrpA1U/LLuPtcNoiLs5WFEAuW2mLp4lHzVz/eX9vzZwRMHRIOkYWQ3b7cUykVgNz0+vGRvY/4NFqUXeo/6cAJ06Xpt9uTHGovEDZY+TibyJeqPNElXu/SOXLeT1egR1sTmKCBbbDrKkSX5kWG/mLD+lFlfcLADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:208:3e8::9)
 by LV8PR84MB3880.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:408:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 18:24:33 +0000
Received: from IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::6d6f:af4c:884d:c7ae]) by IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::6d6f:af4c:884d:c7ae%3]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 18:24:33 +0000
From: "Haeuptle, Michael" <michael.haeuptle@hpe.com>
To: Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: RE: Bug? CQE.res = -EAGAIN with nvme multipath driver
Thread-Topic: Bug? CQE.res = -EAGAIN with nvme multipath driver
Thread-Index: AdtgdgRGzetgECR+TH6K9ws7LfEKsQAIC1CAAAWSV4AAADmFgAAgmIAAAAA4RtA=
Date: Tue, 7 Jan 2025 18:24:33 +0000
Message-ID: <IA1PR84MB310838E47FDAAFD543B8239A95112@IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM>
References: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
 <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
 <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
 <8330be7f-bb41-4201-822b-93c31dd649fe@kernel.dk>
 <df4c7e5a-8395-4af9-ad87-2625b2e48e9a@kernel.dk>
In-Reply-To: <df4c7e5a-8395-4af9-ad87-2625b2e48e9a@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR84MB3108:EE_|LV8PR84MB3880:EE_
x-ms-office365-filtering-correlation-id: aebf19dc-71a4-4694-7498-08dd2f488892
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aE81dnpYUVFMeEgyaUZINmhjOUlzZUVJQWRGQW8wa0RQTis4OGQvY2ZQSmwx?=
 =?utf-8?B?cHYzWWJDZXl1NGJ4S3ZuWXNlWTNlckxGZmh2RGd2a015Q3ZSWWxnM1E4MFBK?=
 =?utf-8?B?b1lMV0ZxTktEenh4bTRDQTEvdUNLdFNYNHVmTkE1R3J0bkYrRjZlazIvU3da?=
 =?utf-8?B?cm9kNExUbzE3Q1k0TUlCRkk1VTFGRHVwZGlzcmxFdWdrd1J5WEtxUGRRdFRj?=
 =?utf-8?B?b08vZDFHZmJCeHRDRzdoMWNzQVEwdEhLMGV0NXlvMmNrV3d5bUFsbmt6K1Zt?=
 =?utf-8?B?djRIb05pbVBjYUx4Uncrb2RYS2tSeUttUWdZRENwT21QL2JndEZscW8xME5u?=
 =?utf-8?B?VnNlUjYwVmV5QkYvYUxXWExqaitNdTFQck9JSlg3akNKMVF3dGIxQUd0WDBJ?=
 =?utf-8?B?d2ovMnN4dCtMYytZT0ZWSXNLbElnaWxLbEFkWUJSeUwyUWRMZHYwMU5wQmdv?=
 =?utf-8?B?U0gzME1JK25zVnRNdXRrZW9uVFpkRExoNG5aUmtRM29zN3lodkkxUjIwYlBy?=
 =?utf-8?B?U1JzMjJRWmhlOTU4TjY0NEN1MDArbDJ5L3FadGZraUlONzdHMEMxZjRyMHRM?=
 =?utf-8?B?eUFuYVZ6N2FTRnN0Q1IvR3UzK2prVkdVRFJGUDRhWElXZko5WjNiWnl3eXRD?=
 =?utf-8?B?TzJhSWJjdVQ2TmxMc2xpRjBlNjgrdUlybmxWSWVMb1Uva3dCS0JpREJUOHVG?=
 =?utf-8?B?RFNSVFh3TmFrcWtWMWZCOEVvdEhlaXVNaGV2UTVCTVptRU9ZRWdWVlpQSi9h?=
 =?utf-8?B?VGJDNGtRelJxRDNvTGYrZ3NWZVc2ZU5IRzZvcFlhL3JmVXB6UmNTeG9DUmV3?=
 =?utf-8?B?TEtxbERCOTBVM1FvVzUzV0lkMDhqeERTaWZyTGRQei81KzNha21nTEJEb0cz?=
 =?utf-8?B?L3hnR0UvY095SXE5YWU3SUZuLyt1T2ZTNkN2QmkxYTBVVytWUnFGSC8weStz?=
 =?utf-8?B?aEZUSXhwWjBXSUViN25xMHRMQ1NGYjJtZ1BpVlYxRVFpaER1cmxqSUs3WEtO?=
 =?utf-8?B?ZmZJU01QM203aWk4ZElVeTltNHhObzhUNWxSUjI3SWRFdHdSWmpXZEpYcFQ4?=
 =?utf-8?B?S1JpY01XaVFIM01YcmhKUlBLTG5IYlJsWU1ucTVESkNjSjRmVTBxMDJRNGpE?=
 =?utf-8?B?WktoSG5LK0w1SDVqSVNmWmFNMFU5dzBOenJVeE0zVW5xeEpwN3hpVzYvRkZK?=
 =?utf-8?B?SDJwMEVCWW5XOXBmSE9vOEp2OWhmNGUyMDJuRktnRXRscSthbGFGVmpldXhD?=
 =?utf-8?B?TDhIZmFqQ29CVE45b0pSZHZaMUJNS0swWUg0SUxVUWY1RTV2QmxrZ3hWREV0?=
 =?utf-8?B?MlYzME0xc1VWVFF1MTErck45akwxREVoL05VWUxmdFY1bEhhaHE4ZUtUWlpM?=
 =?utf-8?B?MXlnRWw5SStnNVU3SzgxMFJLcEFwMko4dTRBQUgwS3VOSFY3NExPMWkyMzNi?=
 =?utf-8?B?dHJpT1NNY09PcHE3RHppOHZtbzl3RFVjVW1nN200dGl0Zzl5WSs2am8rT0Rj?=
 =?utf-8?B?cHNmNk11TkZlbzhLN0pHZDFjY2MxbzR3Z0VvNFNoZXVHMnNmb0hVMjhLVTcr?=
 =?utf-8?B?cWg3MlVKVGF4bTRNcHJ1cE9uUmJIbFpMbXcycDl1bFZoY1VjMGROKzE2ZmdR?=
 =?utf-8?B?S0Nrc0VKZkF2VUVJS2t2TEpJME83U1R4OFpHcmlPUUdjWnNUTzVFNG1NVkZP?=
 =?utf-8?B?QlNZUWlucDdCeHZ4QTlzOW1qZjI3TkhHK2Y5aXREUkN2N1UzRmVMNFNJTUQ2?=
 =?utf-8?B?VnF0NWtHT1AwR0ROMjQxaXRDOFJhUytHYWZFdmRWcTJPekU5VnFPVzdKaity?=
 =?utf-8?B?UUhjVlpFUkJ6MVk4aStlQ0JHcGVudzJUNTROY1pNWjIyRzVRK21XUFZVa3RL?=
 =?utf-8?B?U29kSDhtc1FJUnhMelhKNWpuVkoxRGROVk9DWUh3alZLelE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzRoOEhtSDB0NUFTcmF2OVplYWxWd2dUd214Z3Q1N3k2K0tLRURpcU5PQ3Rh?=
 =?utf-8?B?L2Y1b2lpMVlSdDFSNHZ3dFNvSUwzc3FQLzhFVzZ2anpVUDNLRHpsTGs2dDVO?=
 =?utf-8?B?bzc3UDUrQ2gvQnYzSE5EZ2htK3NGV1NLTmh1blpKM1o4eWZmUTFxNStPanhl?=
 =?utf-8?B?L2NycmZ0ZEhPNGZYb0h6KzJsV04xZWFuaEtHdTVEaUZVRjVpbklRdHlDWnFv?=
 =?utf-8?B?UGdjQzc3cUVmaGpjSzR5RGZRVXV3b3krcXhZdTE4WFZRaTBEblN6YzR4Y2l2?=
 =?utf-8?B?TmlEajRzbFNtUVVPSUNVT2NnRnFUSWxYUEN2MUgxQ2VjbHhsZDk2Sk9xeXYy?=
 =?utf-8?B?RllTbkFaWW1Pdk1FOU8vMzZ5Ym1tcGxmZ2FYMTNlaVB5bE9Pb1Fjc0hiNGlP?=
 =?utf-8?B?UmFGaTY0SmNJY2pQNEpUYjJwR0FUYkt5a2FEZHhzVWsyeGE0Qzk0ek9ocENz?=
 =?utf-8?B?RURJdFhMYjk0c0FjTUlYWHQ2NzgyMWduaVFKQWVmTmhJQ0I0WWdzblBsZVJU?=
 =?utf-8?B?c2lpODRhRko1MHZBZkMwSjJ1Q3dOMnZGbXlIbmp6TUI1cDBlQmlYU1FmUWE1?=
 =?utf-8?B?bnk0eGtOVTR2UVZqbndYaUs4UENSVVNqQUFHRlNWYVBaM25xUlR5YVFyclNN?=
 =?utf-8?B?YWtlMjg1bzBmMGtRUUlYTkZvRUtLZVIweW9Rb2hQMGgxQnVIbkRGOEdBb0dE?=
 =?utf-8?B?VWwzRkdvbStJOEo3anAxTVUwdllsNE9jZGVMMitFTTIxRGoxRFVtdEpnVVpi?=
 =?utf-8?B?azllRjRvU0RnZzF2S2R4RUZuS2cxOWQrNzhmT3YyTkE2bEJvVTA1dGQweHc5?=
 =?utf-8?B?eGZDU3JiNjl4K2U1QmE5MUg2b2RKTFpUQnV0bDhYOWxtMXJKeXVVclJFWDFC?=
 =?utf-8?B?NVdtQUtYS1l5MmY2em1STmFEMnN4UUpMYW82T2w0M0JxSCtGZnljVjJZcUx1?=
 =?utf-8?B?NnU0MWtWcjJleVpqOG5tRzVKUUQwTDZORGdPK1lJc2dNd3BFcDEzeFJSbFVz?=
 =?utf-8?B?NDkrYUFaNUlqdnN1NGNhRHVBeHRuWFVjcmlZL1ZteWVNTDFGWDlMb2UwTU50?=
 =?utf-8?B?OE8wTVllTXBYZWwwRHpTeUtpQXg1N0FGZUJlUDZxajQ4MnRHMFpKVlIrd3cz?=
 =?utf-8?B?MXl0Rzd0L09zNDAyc01ETGlxeU5GMERQTUtsdTIvZUJ2WGlBZFNsdWtwaE5K?=
 =?utf-8?B?Z2JkMzByekRrKzBRQVp1bXBXWHpMMmlIcXN3NWwzNGVTZlcrWEs1ajh3Zit1?=
 =?utf-8?B?dkNVOUJJekJlQW5OQ1NySzI3QWlzeDJLRWdoKzBCZkFMbFUwRTM2VU4rRmIx?=
 =?utf-8?B?ZjFzQklTOVRGam5kcHFxUm9pZ1hNazRtU0NYYmZwemNTMHlYZ0VTSm4xQnpz?=
 =?utf-8?B?a2tzQUl4d2VVdTZsZGRBR2VjZmthZzZtbU0raTBIMUZnS3UxMEI5dXZqeVYx?=
 =?utf-8?B?WDUxaXVpWjU1R2lwSGdjVEZRRjlmQ2REZ3RIWmZhc0x1ZFNPWnZmYStaSXpQ?=
 =?utf-8?B?ejdIZGR3VTdBRE1lbUd6a1dqOWRpVFAyT3BUM2hLdXJybmR6eldtaE1jVEFt?=
 =?utf-8?B?UWhVbi9PNHpYTXEzdnFFb2loOFYyZDRzd2E5VkhFQ3JPY2NHaUtRaU1DNm12?=
 =?utf-8?B?REs0MVRrODdUTE9nRTRlSEtGWEY5NFVlc2N2ay8vVlBhWGdJNk9iTVZUU0xx?=
 =?utf-8?B?QnZtRUk2bnd5TkQzZkZaSGFJczd2eXliR0RJWlFxS0h4TkkwblJTaDMwc3p3?=
 =?utf-8?B?RGVhY3NXN0xyNi85dlhpRE8yU1hqbWYxdnBNSUwxYjBSOVpDYVA3RGxLeFdZ?=
 =?utf-8?B?MS9LcW9VK01KTUxRWExLUXJMb05CaktLRFcycGlNQmpDN3BqV2hwaDBpTHYx?=
 =?utf-8?B?WjltQU5KVzhweng3dlV2NElXaW9aT2pneWFFc0NGV2VyUUYrNzZsT2tFb3Vt?=
 =?utf-8?B?cnhGL2hCQ3ZPYTVNMmZxcWEwcEZVSWd4YTVHOTlXdTMwUm9RTm4ySkgyeEJZ?=
 =?utf-8?B?NlJRRW1jLzI5NGlmQzBVWitlV2I1Y1JTTU5kRkFDRFMreXF0QlFKdFFtN3RG?=
 =?utf-8?B?UXNxZXFOZlN0dS9hVGs5YUtnRGJqTUZwNVZiVWZ5NjM4NWtkTGIyUVY2dTVE?=
 =?utf-8?Q?Dv1uVMXf8nED/GYbsPL3MVwyA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: aebf19dc-71a4-4694-7498-08dd2f488892
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2025 18:24:33.1531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v6JCttz8pkFSJ66O7hdxgTW3gGZCH/iTiCQRloLYiG6P3DNVhiscSfHc1wlsBpOKbBJQ8wCid2//wPr8jD5URvtOeXnHm7V4APXui6mmhi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR84MB3880
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: xDCUzgAAMavxh_CrHBUwpnIT-ePMDia0
X-Proofpoint-GUID: xDCUzgAAMavxh_CrHBUwpnIT-ePMDia0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501070152

VGhhbmtzIGZvciB0aGUgcXVpY2sgcmVzcG9uc2UhDQoNCldoZW4gSSByZW1vdmUgdGhhdCBjaGVj
ayBvbiB0aGUgNi4xLjg1IGtlcm5lbCB2ZXJzaW9uIHdlJ3JlIHVzaW5nLCB0aGVuIGl0IHNlZW1z
IHRoYXQgdGhlIHVzZXIgc3BhY2UgcHJvZ3JhbSBpcyBsb3NpbmcgSU9zLg0KSSBjb25maXJtZWQg
dGhpcyB3aXRoIGZpby4gV2hlbiB3ZSBoaXQgdGhpcyBpc3N1ZSwgZmlvIG5ldmVyIGNvbXBsZXRl
cyBhbmQgaXMgc3R1Y2suDQoNCkkgY2FuIGNlcnRhaW5seSB0cnkgdGhhdCBsYXRlciBrZXJuZWwg
d2l0aCB5b3VyIGZpeCwgaWYgeW91IHRoaW5rIHRoZXJlIGFyZSBvdGhlciBjaGFuZ2VzIHRoYXQg
cHJldmVudCBsb3NpbmcgSU9zLg0KDQotLSBNaWNoYWVsDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+IA0KU2VudDogVHVlc2Rh
eSwgSmFudWFyeSA3LCAyMDI1IDExOjEzIEFNDQpUbzogSGFldXB0bGUsIE1pY2hhZWwgPG1pY2hh
ZWwuaGFldXB0bGVAaHBlLmNvbT47IGlvLXVyaW5nQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDog
UmU6IEJ1Zz8gQ1FFLnJlcyA9IC1FQUdBSU4gd2l0aCBudm1lIG11bHRpcGF0aCBkcml2ZXINCg0K
T24gMS82LzI1IDc6MzkgUE0sIEplbnMgQXhib2Ugd3JvdGU6DQo+IE9uIDEvNi8yNSA3OjMzIFBN
LCBKZW5zIEF4Ym9lIHdyb3RlOg0KPj4gT24gMS82LzI1IDQ6NTMgUE0sIEplbnMgQXhib2Ugd3Jv
dGU6DQo+Pj4gT24gMS82LzI1IDE6MDMgUE0sIEhhZXVwdGxlLCBNaWNoYWVsIHdyb3RlOg0KPj4+
PiBIZWxsbywNCj4+Pj4NCj4+Pj4gST9tIHVzaW5nIHRoZSBudm1lIG11bHRpcGF0aCBkcml2ZXIg
KE5WTUYvUkRNQSkgYW5kIGlvLXVyaW5nLiBXaGVuIA0KPj4+PiBhIHBhdGggZ29lcyBhd2F5LCBJ
IHNvbWV0aW1lcyBnZXQgYSBDUUUucmVzID0gLUVBR0FJTiBpbiB1c2VyIHNwYWNlLg0KPj4+PiBU
aGlzIGlzIHVuZXhwZWN0ZWQgc2luY2UgdGhlIG52bWUgbXVsdGlwYXRoIGRyaXZlciBzaG91bGQg
aGFuZGxlIA0KPj4+PiB0aGlzIHRyYW5zcGFyZW50bHkuIEl0P3Mgc29tZXdoYXQgd29ya2xvYWQg
cmVsYXRlZCBidXQgZWFzeSB0byANCj4+Pj4gcmVwcm9kdWNlIHdpdGggZmlvLg0KPj4+Pg0KPj4+
PiBUaGUgbXVsdGlwYXRoIGRyaXZlciB1c2VzIGtibG9ja2Qgd29ya2VyIHRvIHJlLXF1ZXVlIHRo
ZSBmYWlsZWQgDQo+Pj4+IE5WTUUgYmlvcyANCj4+Pj4gKGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2
YWxkcy9saW51eC9ibG9iLzEzNTYzZGE2ZmZjZjQ5YjhiNDU3NzJlNDBiMzVmOTY5MjZhN2VlMWUv
ZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMjTDEyNikuDQo+Pj4+IFRoZSBvcmlnaW5hbCBy
ZXF1ZXN0IGlzIGVuZGVkLiANCj4+Pj4NCj4+Pj4gV2hlbiB0aGUgbnZtZV9yZXF1ZXVlX3dvcmsg
Y2FsbGJhY2sgaXMgZXhlY3V0ZWQsIHRoZSBibGsgbGF5ZXIgDQo+Pj4+IHRyaWVzIHRvIGFsbG9j
YXRlIGEgbmV3IHJlcXVlc3QgZm9yIHRoZSBiaW9zIGJ1dCB0aGF0IGZhaWxzIGFuZCB0aGUgDQo+
Pj4+IGJpbyBzdGF0dXMgaXMgc2V0IHRvIEJMS19TVFNfQUdBSU4gDQo+Pj4+IChodHRwczovL2Vs
aXhpci5ib290bGluLmNvbS9saW51eC92Ni4xMi42L3NvdXJjZS9ibG9jay9ibGstbXEuYyNMMjk4
NykuDQo+Pj4+IFRoZSBmYWlsdXJlIHRvIGFsbG9jYXRlIGEgbmV3IHJlcSBzZWVtcyB0byBiZSBk
dWUgdG8gYWxsIHRhZ3MgZm9yIA0KPj4+PiB0aGUgcXVldWUgYmVpbmcgdXNlZCB1cC4NCj4+Pj4N
Cj4+Pj4gRXZlbnR1YWxseSwgdGhpcyBtYWtlcyBpdCBpbnRvIGlvX3VyaW5nP3MgaW9fcndfc2hv
dWxkX3JlaXNzdWUgYW5kIA0KPj4+PiBoaXRzIHNhbWVfdGhyZWFkX2dyb3VwKHJlcS0+dGN0eC0+
dGFzaywgY3VycmVudCkgPSBmYWxzZSAoaW4gDQo+Pj4+IGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2
YWxkcy9saW51eC9ibG9iLzEzNTYzZGE2ZmZjZjQ5YjhiNDU3NzJlNDBiMzVmOTY5MjZhN2VlMWUv
aW9fdXJpbmcvcncuYyNMNDM3KS4NCj4+Pj4gQXMgYSByZXN1bHQsIENRRS5yZXMgPSAtRUFHQUlO
IGFuZCB0aHJvd24gYmFjayB0byB0aGUgdXNlciBzcGFjZSANCj4+Pj4gcHJvZ3JhbS4NCj4+Pj4N
Cj4+Pj4gSGVyZT9zIGEgc3RhY2sgZHVtcCB3aGVuIHdlIGhpdCBzYW1lX3RocmVhZF9ncm91cChy
ZXEtPnRjdHgtPnRhc2ssDQo+Pj4+IGN1cnJlbnQpID0gZmFsc2UNCj4+Pj4NCj4+Pj4ga2VybmVs
OiBbMjM3NzAwLjA5ODczM10gIGR1bXBfc3RhY2tfbHZsKzB4NDQvMHg1Yw0KPj4+PiBrZXJuZWw6
IFsyMzc3MDAuMDk4NzM3XSAgaW9fcndfc2hvdWxkX3JlaXNzdWUuY29sZCsweDVkLzB4NjQNCj4+
Pj4ga2VybmVsOiBbMjM3NzAwLjA5ODc0Ml0gIGlvX2NvbXBsZXRlX3J3KzB4OWEvMHhjMA0KPj4+
PiBrZXJuZWw6IFsyMzc3MDAuMDk4NzQ1XSAgYmxrZGV2X2Jpb19lbmRfaW9fYXN5bmMrMHgzMy8w
eDgwDQo+Pj4+IGtlcm5lbDogWzIzNzcwMC4wOTg3NDldICBibGtfbXFfc3VibWl0X2JpbysweDVi
NS8weDYyMA0KPj4+PiBrZXJuZWw6IFsyMzc3MDAuMDk4NzU2XSAgc3VibWl0X2Jpb19ub2FjY3Rf
bm9jaGVjaysweDE2My8weDM3MA0KPj4+PiBrZXJuZWw6IFsyMzc3MDAuMDk4NzYwXSAgPyBzdWJt
aXRfYmlvX25vYWNjdCsweDc5LzB4NGIwDQo+Pj4+IGtlcm5lbDogWzIzNzcwMC4wOTg3NjRdICBu
dm1lX3JlcXVldWVfd29yaysweDRiLzB4NjAgW252bWVfY29yZV0NCj4+Pj4ga2VybmVsOiBbMjM3
NzAwLjA5ODc3Nl0gIHByb2Nlc3Nfb25lX3dvcmsrMHgxYzcvMHgzODANCj4+Pj4ga2VybmVsOiBb
MjM3NzAwLjA5ODc4Ml0gIHdvcmtlcl90aHJlYWQrMHg0ZC8weDM4MA0KPj4+PiBrZXJuZWw6IFsy
Mzc3MDAuMDk4Nzg2XSAgPyBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MjMvMHg1MA0KPj4+PiBr
ZXJuZWw6IFsyMzc3MDAuMDk4NzkxXSAgPyByZXNjdWVyX3RocmVhZCsweDNhMC8weDNhMA0KPj4+
PiBrZXJuZWw6IFsyMzc3MDAuMDk4Nzk0XSAga3RocmVhZCsweGU5LzB4MTEwDQo+Pj4+IGtlcm5l
bDogWzIzNzcwMC4wOTg3OThdICA/IGt0aHJlYWRfY29tcGxldGVfYW5kX2V4aXQrMHgyMC8weDIw
DQo+Pj4+IGtlcm5lbDogWzIzNzcwMC4wOTg4MDJdICByZXRfZnJvbV9mb3JrKzB4MjIvMHgzMA0K
Pj4+PiBrZXJuZWw6IFsyMzc3MDAuMDk4ODExXSAgPC9UQVNLPg0KPj4+Pg0KPj4+PiBJcyB0aGUg
c2FtZV90aHJlYWRfZ3JvdXAoKSBjaGVjayByZWFsbHkgbmVlZGVkIGluIHRoaXMgY2FzZT8gVGhl
IA0KPj4+PiB0aHJlYWQgZ3JvdXBzIGFyZSBjZXJ0YWlubHkgZGlmZmVyZW50PyBBbnkgc2lkZSBl
ZmZlY3RzIGlmIHRoaXMgDQo+Pj4+IGNoZWNrIGlzIGJlaW5nIHJlbW92ZWQ/DQo+Pj4NCj4+PiBJ
dCdzIHRoZWlyIGZvciBzYWZldHkgcmVhc29ucyAtIGFjcm9zcyBhbGwgcmVxdWVzdCB0eXBlcywg
aXQncyBub3QgDQo+Pj4gYWx3YXlzIHNhZmUuIEZvciB0aGlzIGNhc2UsIGFic29sdXRlbHkgdGhl
IGNoZWNrIGRvZXMgbm90IG5lZWQgdG8gYmUgDQo+Pj4gdGhlcmUuIFNvIHByb2JhYmx5IGJlc3Qg
dG8gcG9uZGVyIHdheXMgdG8gYnlwYXNzIGl0IHNlbGVjdGl2ZWx5Lg0KPj4+DQo+Pj4gTGV0IG1l
IHBvbmRlciBhIGJpdCB3aGF0IHRoZSBiZXN0IGFwcHJvYWNoIHdvdWxkIGJlIGhlcmUuLi4NCj4+
DQo+PiBBY3R1YWxseSBJIHRoaW5rIHdlIGNhbiBqdXN0IHJlbW92ZSBpdC4gVGhlIGFjdHVhbCBy
ZXRyeSB3aWxsIGhhcHBlbiANCj4+IG91dCBvZiBjb250ZXh0IGFueXdheSwgYW5kIHRoZSBjb21t
ZW50IGFib3V0IHRoZSBpbXBvcnQgaXMgbm8gbG9uZ2VyIA0KPj4gdmFsaWQgYXMgdGhlIGltcG9y
dCB3aWxsIGhhdmUgYmVlbiBkb25lIHVwZnJvbnQgc2luY2UgNi4xMC4NCj4+DQo+PiBEbyB5b3Ug
d2FudCB0byBzZW5kIGEgcGF0Y2ggZm9yIHRoYXQsIG9yIGRvIHlvdSB3YW50IG1lIHRvIHNlbmQg
b25lIA0KPj4gb3V0IHJlZmVyZW5jaW5nIHRoaXMgcmVwb3J0Pw0KPiANCj4gQWxzbyBzZWU6DQo+
IA0KPiBjb21taXQgMDM5YTJlODAwYmNkNWJlYjg5OTA5ZDFhNDg4YWJmM2Q2NDc2NDJjZg0KPiBB
dXRob3I6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gRGF0ZTogICBUaHUgQXByIDI1
IDA5OjA0OjMyIDIwMjQgLTA2MDANCj4gDQo+ICAgICBpb191cmluZy9ydzogcmVpbnN0YXRlIHRo
cmVhZCBjaGVjayBmb3IgcmV0cmllcw0KPiANCj4gbGV0IG1lIHRha2UgYSBjbG9zZXIgbG9vayB0
b21vcnJvdy4uLg0KDQpJZiB5b3UgY2FuIHRlc3QgYSBjdXN0b20ga2VybmVsLCBjYW4geW91IGdp
dmUgdGhpcyBicmFuY2ggYSB0cnk/DQoNCmdpdDovL2dpdC5rZXJuZWwuZGsvbGludXguZ2l0IGlv
X3VyaW5nLXJ3LXJldHJ5DQoNCi0tDQpKZW5zIEF4Ym9lDQoNCg==

