Return-Path: <io-uring+bounces-5792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D4BA07F99
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 19:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CADFE7A2F17
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB45199385;
	Thu,  9 Jan 2025 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="DaT55KZA"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7B91946A2
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446259; cv=fail; b=NSolak7R6DrdIdZ2nRi9J8RjYMPLpWd6NxiNWmDhVa7sJD8dpwaGKPexKpw+nyGyl4GuNKNoKGe5kPT1ynH2x/r/9sTvXnlQipSQMTNUcSfI4ikkfxKPHrK5tk5gU9iZC2OPSYgcZPvzxX6L+CpXOrkDTiE50Ta4wdkcZNrhGoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446259; c=relaxed/simple;
	bh=dxcNvRuSmdXlKXNOFlhj4S/HVX53pUWBVobEsA9NH+U=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hmqHbzjmMxoyenCC2xi+u6lw581iLcu8IDKMYzrJC2UgSI388E5txY9VaTHiyFBA6nzlw16HYkkBDa/XDMBmGKu37GVK1wPyv2PIVs9BEqeF3Bfw75q7OCzwZoLiCuICSUbV/4aKprd98goBRd6L+64sGTOFymtKsbbAM894prI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=DaT55KZA; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509Hh62b006425;
	Thu, 9 Jan 2025 18:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=dx
	cNvRuSmdXlKXNOFlhj4S/HVX53pUWBVobEsA9NH+U=; b=DaT55KZAE/Ny2rGgka
	ukglJpjgLwHcojvZaCChCdUtGphN+EYjh+tQuTRF7BodmyRY959xrwF21XkONiIp
	Anl2xyMikw3oaUS2uiAOYy8nCiVePYPeE9lZxl80rsEBWp40wCCDUn/rS6MWzUov
	JRVi80EYCA0vawG6yXt7BhyOIAfk36sGRyxqeXHC2kI8fFALq5CziZxSV1zRTEKm
	KC6hr0Tn0L7RGaosNnTgCEyTIPGDgGBMCdN+GK33grec7O5hQe3oT6di4Ei6M+Jw
	b7bZ22gNkjnzImoXMWqSPG6P1W4SnRKYiFH72QIn6B9FbIfLxQ1Pzh0GpmpqiEGn
	tRyA==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 442k3q0anp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 18:10:45 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id BA1F2D1EF;
	Thu,  9 Jan 2025 18:10:44 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 9 Jan 2025 06:09:55 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11 via Frontend Transport; Thu, 9 Jan 2025 06:09:56 -1200
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jan 2025 06:09:58 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRkkWLs6tZ2tO5pq6riVT8tXafix9jbaICeK26xcV7Syq4BCnWLCmQPXGGWSkoA/zRhaR/iCiovR/nPu2+sjD6m/zWqXCnRGtF8T8HQsLwUBBLTJxj5uAJRGnXiPeZqGOO+AAtFDZ81prv91XJbu24lCdfJVtJnQIrl6b6V5gJ6sTd0XWgco0c1UgTCOhntfbRD5tO8Pnjo6dZ/7soZn+gVAJlxocuCJKvRGZT8cW8ChrvZgXe19qd7zPuPOJs8zrxwRzDj25q8M7DFnhtcCg20n+RGZznOBXMWJoBmr7+WRUJog0M9DtkvYMqJTUIQAJ/l24n95uy461Q7UTaw/Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxcNvRuSmdXlKXNOFlhj4S/HVX53pUWBVobEsA9NH+U=;
 b=ElyvizC3I5PJ6a4irOz1RNIhtSLkLmaoNctqCoCOpgg8i4PPSnmYILS3KKGmq2zAUfxopmWMhc4LBUXuvUW0uKpcnBlBRZniGjg3NUeLD6r3iw1Ojz9YGz0frA36/uXn7Nphyi9lDd7bzZMWONR5xRyHVfIj7sO5nAyfp5CFv9RgZbJMWP1SzGvy6WmZFG63B2RO7CFE5ZHRpn5eN+J/ZnCk7X0xaSJqF+ybusHm0gBJKreAQKl6vrlMyJgT2jScdJRbNqgUN6kIrZNnPsYQPRmq7nY8jLTtB7H/wecwygR7XGwB7/Hu+DApG7OK7mBY9rlCzhzk2fHI7XxHdvIRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:9a::7) by
 MW5PR84MB1570.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Thu, 9 Jan 2025 18:09:56 +0000
Received: from DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::2d35:fec1:e913:c9d3]) by DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::2d35:fec1:e913:c9d3%4]) with mapi id 15.20.8314.015; Thu, 9 Jan 2025
 18:09:56 +0000
From: "Haeuptle, Michael" <michael.haeuptle@hpe.com>
To: Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: RE: Bug? CQE.res = -EAGAIN with nvme multipath driver
Thread-Topic: Bug? CQE.res = -EAGAIN with nvme multipath driver
Thread-Index: AdtgdgRGzetgECR+TH6K9ws7LfEKsQAIC1CAAAWSV4AAADmFgAAgmIAAAAA4RtAAAEL2gABjlRYg
Date: Thu, 9 Jan 2025 18:09:56 +0000
Message-ID: <DS7PR84MB31106A2E2315A53CFA33B2B495132@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
References: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
 <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
 <da6375f5-602f-4edd-8d27-1c70cc28b30e@kernel.dk>
 <8330be7f-bb41-4201-822b-93c31dd649fe@kernel.dk>
 <df4c7e5a-8395-4af9-ad87-2625b2e48e9a@kernel.dk>
 <IA1PR84MB310838E47FDAAFD543B8239A95112@IA1PR84MB3108.NAMPRD84.PROD.OUTLOOK.COM>
 <4c531b2d-c852-4a33-bed6-b8bbc3393f98@kernel.dk>
In-Reply-To: <4c531b2d-c852-4a33-bed6-b8bbc3393f98@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR84MB3110:EE_|MW5PR84MB1570:EE_
x-ms-office365-filtering-correlation-id: feb3d154-9e8b-4882-4eb0-08dd30d8d2e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YzlGc0FlZnNYYUdaS3ZiZEJrSEp2amQrY2p3dUMyN3g0UlMzUkZYdERMVnFR?=
 =?utf-8?B?a3pzd0tKZzNsVDE5LzBRUk01TFZmbW9IT2VVTXRjeEYrQXFsclBKeGlXZmho?=
 =?utf-8?B?TlVlNlJQdE1ib1ZiUjFjZlpKSXNxenFRaGlXQ3I5SnFLdlNpK2xxOTRDTFB2?=
 =?utf-8?B?SDNvcndtWjVHbnpiVkNhYTM0Ri9RK2xCaWU3T2pES3lTdFNLTlBqWDIwUTZL?=
 =?utf-8?B?YVhwdUNEaG1iU0FVYjRZSWNOTjRjZWZrTmdwdTZSbzFCOW44L3lvZG5MQ3oy?=
 =?utf-8?B?OXVGdVVodDJ4ZjNhb0o1ZVVHajc4UXFaeXBCY3I2S1VsUFljRElvYzBWRzJQ?=
 =?utf-8?B?aVNSN2JMV2ErRGlOaUp6d0thMGRzUFFWT2lsejNnMHhrR1JGQXd6ODdFQ2x4?=
 =?utf-8?B?bnJCdnZVck9VUW4xOFZBZk11SkJTNE55NGpwd0pjNGJOYkU0QTFyYTcyeGJ0?=
 =?utf-8?B?SFk4S3JnODZvaXNTSFkxcFhpVWlhMnVKR2JOU3NPWVlERVI5QWhDZkFmMUpL?=
 =?utf-8?B?SWZ1blJhTXdib2V0SGJnRUFKUEsxT0NIa0VCaFlpeVhkZks2U3BIRWRkR3JC?=
 =?utf-8?B?aWd1N2x2dUZUN3VNRjhRNmVMNTB3eVdzR1BLREQxUUx0MGYwWS9kSHh5SXJw?=
 =?utf-8?B?Zm11L2l4RTVtbk5mbXNKWGhxWWNsWjhPSE1QU3FRZEJJU0oyZmVLVjFEaE9a?=
 =?utf-8?B?clQwRlR2dzVYSTBKVm9HVHdZeDVSVEtickNualR4bGs4UW1UcjFUYVRiVzZz?=
 =?utf-8?B?ZE5PMWhTMzBOY3hVQjR1WFU3QkpnbU5GYXVPNzhNVFdiSnZPbXdpejhKczZT?=
 =?utf-8?B?blVRMVpiK3pTdU0xZkVrNCtKeEg3VDlWRDJteC8zZkE2b3BsM0I4VUVReThh?=
 =?utf-8?B?SW1OTkF1ZXU1b0dmREg0Rlk3dE1xWFllRE54T3hYVXg4eStZQkp1TlR5NnhX?=
 =?utf-8?B?Y0FVRHpKeXJTcjQvakpyNGhmRTRuUU5vZzRLdlVuN21jR1BCcmVuZHhOLytW?=
 =?utf-8?B?UHROdndseis4N0ZnOXdzSXRvOG1zUzdJc2oreko4NXVpK3dGZXhNMTJoNk5r?=
 =?utf-8?B?R0luLzNkRGV2citMR1JwVU5HVklDVURSdEZKNXByTTBYZzY2NUNKdDg1SkJp?=
 =?utf-8?B?T29PYjErekxQT3hHeHI0R0tybU1ISG5xRGJmYXZJaHB4eXJTY2ZXSXF3NXhy?=
 =?utf-8?B?ZVVzUFFIdzFUaURxdVp4anI0aXA5Ym9RYnUwSWY1ZC9sSDZWOW1DekJwc3Fh?=
 =?utf-8?B?MGtEMnBEUTZJSkJzbTc4UkJ6NnA3SWFMRjZUekVLZjN2K05xNCtTR2RUWGFZ?=
 =?utf-8?B?WWUyaXFxUzBFaWtuYnlKdUlGbnJRNERTcllkN1VXYUVuRG1KKzM1cDJJOUxk?=
 =?utf-8?B?dnZoNy93bExhY2YrUWNRdWhaODJUaGI3TkM2YXJuZUhvc0RZc285bGJmejQy?=
 =?utf-8?B?SnBVUEJselBISE5VNTN2eTM3emVjelJPVTFtNExEazcrMHJUQWwxdDE4Nnoy?=
 =?utf-8?B?T3RoTGU2b1V6TDZReTgxMGFydm1XTnZUdENkdjFsTDYzQjAvbHFVUnFwTjYw?=
 =?utf-8?B?S3ZVWDdmb1p6YUEwSmx1U2FmckxRVFZxL2NsZGtwQWNCREtZVlJQVktEVHR1?=
 =?utf-8?B?WERBcDVPZDVpMDJ0U1B2d1dKNGxlS1RlaUFWb3ZvaWNWZ0ovTENnNlhWRWty?=
 =?utf-8?B?aW10MHRHOTJGVlA3VDF4cG15VnFuMjZVbCtYWUZmZ1M2R2lVNDYzR2U2V0RB?=
 =?utf-8?B?VWFlOGhLdlhHUDk5TjBMalBwczZNcmoxT3p2c2RQZUNaWjZuUHhSL3BnNkc0?=
 =?utf-8?B?TnMzR1A4bHFVb29XaE5hUEVsZk5KTS9MbDc4eU4rNkQyMGd3T09rbkw4RjNW?=
 =?utf-8?B?MlIyTFVnMHBKd3NtUUlVam5EdEtkeWRyc083MW9hNTZ2MVdWWjAzYkI4dHZI?=
 =?utf-8?Q?6XG6d1sK5Mn4pDaTITDb772vPyIcz7zI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sjk3ZVQ5eC9RcXJlbnRzUEdScGZqRmhDQVZWM21Gd0tWQUw0RzhvWWRIQnFR?=
 =?utf-8?B?NStlRFNTV2orTHNSUTlWZmtwZE04Z2drRGo3TjRjWE1WRmxqWXVzWlFndU9a?=
 =?utf-8?B?VXM4Ym4rQ2EramhsbDA0ZllUelN0T1dVaVNZNXRVdVVsN3E2ZHhhUVRJTzJO?=
 =?utf-8?B?MG41NnJvb3VoYisrd3VqY0tGUEx0M3ovTDA0emFXZnJFWUNFSWwzQ1BkVEZD?=
 =?utf-8?B?TFVIOVFvMW4xaFBzOHFHa2w4d0JCSS8wa0ROTHJneG5wK2ZpdUNFRzdDVG1k?=
 =?utf-8?B?Y2txaUQzUTFCd0YyalM3UWRxVGZobVhMM2NhaHFtaTQ3azcrUGdXV1o2dElv?=
 =?utf-8?B?dTVyd2dhZ2FZZEZOZ0xDOUg3Y1FxNStZYkF5KzRnM0xpelRkSjF0QjBRakZm?=
 =?utf-8?B?NjV5czczSDFTMEVXcHVKc3d4Qi9nUnVFQkVKWXUwNml3K2xNTXBSMC9wRERN?=
 =?utf-8?B?TUlmbFExanFpMlhYTzMrNHBoZlRmNHUvUDFzQzRrU2Fxb21vMmlLczNYQmFo?=
 =?utf-8?B?ekFvUGp4a002c3JwVExWQ2E0UUg5NDRhTHJkNkZYZ284NWUyWmJ4dkZGVXFs?=
 =?utf-8?B?MEJQRzM1cDA3RTZiQytNVVpsVW9lc2JGY3Y3SEpNbTJSOGVHb216N0c2Vjh0?=
 =?utf-8?B?TG1sY0VNVFhNZ1c3VHZBb0FTM0FVYXg3MUxMMjRnKzBxODcrUlUxSkYwR3pZ?=
 =?utf-8?B?Vy9TNjlCL0tuVTJKNjdFeFE2Z2U2VUlYNzQ3R05TZWU2TlZ0TEtFWkl4SDFU?=
 =?utf-8?B?Qmpua28vVUtrQkhmYnV5YWZGRE95Zm5kbTJQVWxhSWNRSHJRNnlTTXJNSFNm?=
 =?utf-8?B?RXVwNEpmUHZzNThPOGlqaHh0SDE5akEzblJ0SjF4VFdPYituS1FyYUZOeXF0?=
 =?utf-8?B?TU13NUVGV1NXckZ6NmloWm9TN2lhMnVGVFNvdkgzenZFQSs4dkJSbU1vU20y?=
 =?utf-8?B?RXAvL2pGTGhuNEFsS05HUG13V2djVFErUUhvdFJIZ2dBR0IxR0xxLzNjNWxT?=
 =?utf-8?B?b0g0RXNkNCtBOHp2b3FKeGRmNGhTTDg0eE4rWmx2L3BrK0k3Y1BLVzFCaVV4?=
 =?utf-8?B?cnExUFFySmtucWdTUW9rYlNVZE9nbFlsNUJ4QVJvZnJzRkFqVEdBcFJEV2hT?=
 =?utf-8?B?WFprTXE4MHl1UjNJTHFCSGJJZzdnTVJFOXh4UUErSGJ1NGdWY3dVckNzTUg5?=
 =?utf-8?B?TDlBMWZtR3VOVkN6dW4vRWRmT3BXa2VFWlF6MlFJVDVCZ1U4QjMxUzBhajRG?=
 =?utf-8?B?UHA3OFkxZTYzU0YyUDd2dEpmMDQxOHB6WTh2NFI5WkE1Vm1JamZjNXo3V2tC?=
 =?utf-8?B?MEtQTFZ2M3ZvUnlVV1hpdlk4QlVWU3ZLZ1hnaFl4dERDOXc2b1NsYmtOYml5?=
 =?utf-8?B?VjJyZ2FJZklaVmJScEN6dll2S2RMY0hCQUJBQ2E3ayswYmRwbEtrcDdkZ0Ir?=
 =?utf-8?B?b3FQeGJTRXNNM2g5OW14SUpoSlpkN0dGbXNPMG1oRW00UzV6TjJZL1lISmQz?=
 =?utf-8?B?U3phRlhTcmRJOWI2dCt6bEdvRzduN3ZnaEZCSHlzZ1I5ZDBxdlJOUFdPK05p?=
 =?utf-8?B?Tmk3RnlLU0E1TzZqaEtTK3RDVTlQVDB5RkJYWHdkVzY4WGFJS0VtdUNPbWpU?=
 =?utf-8?B?d3dKRE01R3NPdFExbkIxVTR5em5JNklKcnk2MFBWLzMvNEllWkNZTFVyTlNL?=
 =?utf-8?B?SmwrMWlwancyR0ZGOWlteXNGTW9oL2FZU1UyRlZKY1l3N2tqUnlEM2JlYUoy?=
 =?utf-8?B?bkVrOW1pMyt0eStuNUErZjlOSFczU0ZhNzR1VGtYWWV6TzNLbFc3dHBYcFBQ?=
 =?utf-8?B?UVRWampkYkpoNndaZ3J4clFSMFZoTlR4eEl0cXVRL1hicm9MdFg4eW50RW9l?=
 =?utf-8?B?U1pBdCtkd1NMRnJ5dS9rY3pMQWpZY0NkUXZFZFhMdUZMYWJaTTI0WW5LbktF?=
 =?utf-8?B?Qit2U1FySFJybDhpa3V2WUV6NlhJQmwxRWtqNVI1aVdDUGp1UTQ5YnlRR2tD?=
 =?utf-8?B?MGJzeFVGUCsyeG5wZWRmZTRUU2wzT3pNLzc3VzBrMGZkT0hrVE4rN052MmNz?=
 =?utf-8?B?elNJa3BKSWhXTGlGbVRKREV4VkdIa2FFMXkxNlYyNzJ6OCtqaWNrOEpodGNy?=
 =?utf-8?Q?DHduEcjMqJpzvAYeYSpJfUazq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: feb3d154-9e8b-4882-4eb0-08dd30d8d2e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 18:09:56.5485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9vIYc7Irx8eVUKTEgX67bkOc+rN9Uh4fGQSsesYNZurtgX+fPgNTMNVBPy+2TPpCW4Q+qirl1BdLav+1I5lxqcmOZ2AEDit9ZskJyJlmTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1570
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: -F9xADfKCOk11i_Noc_-UVxjTB6bTloD
X-Proofpoint-GUID: -F9xADfKCOk11i_Noc_-UVxjTB6bTloD
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501090143

SGV5IEplbnMsIHNvcnJ5IGZvciB0aGUgbGF0ZSByZXNwb25zZS4NCg0KSSB3YXMgdW5hYmxlIHRv
IHJlcHJvZHVjZSB0aGUgaXNzdWUgd2l0aCB5b3VyIGJyYW5jaC4gSG93ZXZlciwgSSBkaWRuJ3Qg
ZXZlbiBoaXQgdGhlIHNwb3Qgd2hlcmUgc2FtZV90aHJlYWRfZ3JvdXAgY2hlY2sgd2FzIHJlbW92
ZWQuDQoNCldlIGJhY2twb3J0ZWQgeW91ciBjaGFuZ2VzIHRvIDYuMS4xMTkgYW5kIHdlIGRpZCBz
ZWUgdGhhdCBvdXIgb3JpZ2luYWwgaXNzdWUgaXMgZml4ZWQgd2l0aCB5b3VyIHBhdGNoZXMuDQoN
Ckl0IHNlZW1zIHRvIG1lIHRoYXQgaW9fdXJpbmcgcGVyZm9ybWFuY2UgaW5jcmVhc2VkIHF1aXRl
IGEgYml0IGluIHRoZSBsYXRlc3Qga2VybmVsLCBqdWRnaW5nIGZyb20gZmlvIHF1ZXVlIHV0aWxp
emF0aW9uIG9mIG15IHdvcmtsb2FkLiBNYXliZSB0aGF0J3Mgd2h5IEknbSBub3QgaGl0dGluZyB0
aGUgcGxhY2Ugd2hlcmUgc2FtZV90aHJlYWRfZ3JvdXAgd2FzIHJlbW92ZWQuDQoNCllvdXIgcGF0
Y2ggZGlkbid0IGNhdXNlIGFueSByZWdyZXNzaW9uIGFmdGVyIDFkIHRlc3RpbmcgaW4gbXkgTlZN
Ri9SRE1BICYgbXVsdGlwYXRoIHNldHVwLiBTbywgSSB0aGluayBpdCB3b3VsZCBiZSBnb29kIHRv
IGdldCB0aGlzIHBhdGNoIG9uIG1haW4uDQoNCi0tIE1pY2hhZWwNCg0KLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4gDQpTZW50OiBU
dWVzZGF5LCBKYW51YXJ5IDcsIDIwMjUgMTE6MjcgQU0NClRvOiBIYWV1cHRsZSwgTWljaGFlbCA8
bWljaGFlbC5oYWV1cHRsZUBocGUuY29tPjsgaW8tdXJpbmdAdmdlci5rZXJuZWwub3JnDQpTdWJq
ZWN0OiBSZTogQnVnPyBDUUUucmVzID0gLUVBR0FJTiB3aXRoIG52bWUgbXVsdGlwYXRoIGRyaXZl
cg0KDQpPbiAxLzcvMjUgMTE6MjQgQU0sIEhhZXVwdGxlLCBNaWNoYWVsIHdyb3RlOg0KPiBUaGFu
a3MgZm9yIHRoZSBxdWljayByZXNwb25zZSENCj4gDQo+IFdoZW4gSSByZW1vdmUgdGhhdCBjaGVj
ayBvbiB0aGUgNi4xLjg1IGtlcm5lbCB2ZXJzaW9uIHdlJ3JlIHVzaW5nLCANCj4gdGhlbiBpdCBz
ZWVtcyB0aGF0IHRoZSB1c2VyIHNwYWNlIHByb2dyYW0gaXMgbG9zaW5nIElPcy4gSSBjb25maXJt
ZWQgDQo+IHRoaXMgd2l0aCBmaW8uIFdoZW4gd2UgaGl0IHRoaXMgaXNzdWUsIGZpbyBuZXZlciBj
b21wbGV0ZXMgYW5kIGlzIA0KPiBzdHVjay4NCg0KVGhhdCdzIGJlY2F1c2UgdGhlIGlvX3VyaW5n
IGxvZ2ljIGFzc3VtZXMgaXQgaGFwcGVucyBpbmxpbmUgdmlhIHN1Ym1pc3Npb24sIGFuZCBmb3Ig
eW91ciBjYXNlIGl0IGRvZXMgbm90LiBXaGljaCBpcyBhbHNvIHdoeSBpdCBnZXRzIGZhaWxlZC4g
QW5kIGhlbmNlIHNldHRpbmcgdGhlIHJldHJ5IGZsYWcgaW4gdGhhdCBjb25kaXRpb24gd2lsbCBk
byBhYnNvbHV0ZWx5IG5vdGhpbmcsIGFzIG5vYm9keSBpcyB0aGVyZSB0byBzZWUgaXQuDQoNCj4g
SSBjYW4gY2VydGFpbmx5IHRyeSB0aGF0IGxhdGVyIGtlcm5lbCB3aXRoIHlvdXIgZml4LCBpZiB5
b3UgdGhpbmsgDQo+IHRoZXJlIGFyZSBvdGhlciBjaGFuZ2VzIHRoYXQgcHJldmVudCBsb3Npbmcg
SU9zLg0KDQpQbGVhc2UgdHJ5IHRoZSBicmFuY2ggYW5kIHNlZSBob3cgaXQgZmFyZXMgZm9yIHlv
dS4NCg0KLS0NCkplbnMgQXhib2UNCg==

