Return-Path: <io-uring+bounces-4283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B370E9B80E3
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 18:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71B1D28217E
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 17:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2ED51BDA85;
	Thu, 31 Oct 2024 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="mI+uxhlI"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983341BC9ED;
	Thu, 31 Oct 2024 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730394540; cv=fail; b=cPpsOBrdEg2B1w6hToUmYguOjP5sYmnBT4Z/yzeMvwvpS+OYIwr/DQpS0MNnUQkI4SY730ewQb9u9UoFJq1DGbwkvtgSP8O6r7qojHbcbDnT77UiRGjsubONcRtdXArErADoWxhMmDOVxBGLK08KTEzIiAWUxcNE7zIE08+k2FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730394540; c=relaxed/simple;
	bh=cclqR7TobUy3rto8FmI7p2d5cZVHbMmr8xnyC3MU5G4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=SDHACV/0Q1CyjdVU/ISzkDk8MXpnEAdxqtL/WrKeEs7qo8z49Urschgqbvok/cOaXSks4Aj5PfKeXQPQ6JDMcMdGaqnNJhJBbkhlh7WzMnCBtLJMCJe5wWAMq5jwiS8v47ECAB9BagVQgrLJs0RGidl/5wyq1j5UcGiYd8Nk7UI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=mI+uxhlI; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49VGltkG013825;
	Thu, 31 Oct 2024 10:08:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=gFUA5fN89Wk5T512d3esRynTpFXVzjEdPMMOUZAiSTI=; b=
	mI+uxhlIamv0OQSykGOCV2yB5ZSan+kCCwmuGnXHtHCJZLY9vjKEeP+y/tU7AYnK
	C2cjzwit5mkSScZa1xNvM3MaQY6guITrhziCIlxapNLCV3J4DFIo7Jnmf0YYXZ48
	S6QaEzqa4DzKZdGU5E6NC+G0Voo+sxC9P9fzZA7APVDgZPXlMHaQfR/G/WnrKQIX
	W57nPIgMWVZsu1Wh3dAYLQRC16fv0ATuKkDqXjjlqeZqi3lCLfNGxhftojn9KO11
	21txKctelOJyjOYQbASBOwfr1HtFyG5xytV/BHPekMP4HUcPRY7gct8Z395cfSne
	keA3FlRUreayPb/ljMV0nA==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42mdmqr91x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 10:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+n/gMclmzF32gcguw6j6gwXKL4pv1GSWZt/37xiRBGyI0VfyK0x3LJHHV0Yv1xFe5yQ9ohUSh1ruEWvdRTva38bHSkYZxENOaVhjPiy9F7Y3Gg/EHI4gBkeyNPQAoVfW+yH+PjkJQIw4lqdGtRqPe1qHRubL1+tGxDz5/PpfxHcc3mxfphrz6nKWvD7tYwoFtNvcv42LPmbeuR/sbmdha0osi5sistKH4VfLOTvy5xs0P/RlPueaSvSYtRj9LAh+eF1OQ5et0F2OtVIbSgGx6EmfjgKfQI6+tPL7fisw3Yvs2JWSIT0w8mxQJLku6oOLP/CJnOEXStW64worrAWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GfMQp87lmRTlkSKirTUAf+PNsNGGdz+oDlY7qipAC8=;
 b=BjjW/WZB0pBOYvyK1Ed11DAH2ff9K/DhKrRASvkjz36qR3biTuKz7f9gDKw5x+HEFrVAmk12uTRHQbuCNev8mpOrDaU3cyhSvGtG18dLgjtKgI1A3qO50kgt9PXXbZ73RWZfViVWqUeiDPc5DawUr3Dq6afySGQWnPZKoeJZ4QokR0cOYrTzkhTbC7vZc1EWH8+tyxOnSiaupZmE0QEzfST/WU8UXnXA1YpgO8DY/PbWfJDANuftP21qkhmCm7i/HrVi59oxeYYD5C3tbdq97BRtds8qX2bppQ+8px+OyFPuOHao6ckYxT0KT4kTdR1xcQ5lphbpeDizmDC+dNcEhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by SA1PR15MB4853.namprd15.prod.outlook.com (2603:10b6:806:1e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Thu, 31 Oct
 2024 17:08:52 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8093.024; Thu, 31 Oct 2024
 17:08:52 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Pavel Begunkov <asml.silence@gmail.com>,
        Mark Harmstone
	<maharmstone@meta.com>,
        "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Thread-Topic: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Thread-Index: AQHbJJHC7Q2WygCDb0ahtsoMBhbyubKehNOAgAKhJoA=
Date: Thu, 31 Oct 2024 17:08:52 +0000
Message-ID: <46aa1f2a-d0c6-429e-a862-1b3b8c37c109@meta.com>
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-6-maharmstone@fb.com>
 <63db1884-3170-499d-87c8-678923320699@gmail.com>
In-Reply-To: <63db1884-3170-499d-87c8-678923320699@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|SA1PR15MB4853:EE_
x-ms-office365-filtering-correlation-id: e0df5aa8-b931-484d-828f-08dcf9ceb205
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZVdaMEFzaU1rSnBSWFpYYm1ubnh6ZXIwZnM5RlV5RWFQd0FHYTl6cklXQkNZ?=
 =?utf-8?B?UnJwTS80WXcwejh4bmxoQ0pHQnlhV3Y1T2tKMWdQOW1WellmWUd1WHZvMGxS?=
 =?utf-8?B?cmZiN1IvWkYrT0xiUGFzZk9lSmhFWUEzdDR6TzhuV3NFY3IzKzdpZzE1SnVR?=
 =?utf-8?B?bjZwTVJVNE82dWIvdFphcUxhczRpdGpBVW1XZXdYcnNaSndqYkZ4MDFlYnNl?=
 =?utf-8?B?c0srWXZvaHNnd3lJbUF6RHAzZEJ1ZlgybVJPZFNXOVV1YjNyOWc4NTAzb0NE?=
 =?utf-8?B?WFJpck5aTWFneWc1UnBScFFoYVdVOHp5WFpVb0dHWnBodUpGSWlPWUdBaitm?=
 =?utf-8?B?ek05M1Izc0dPUXVQanQrZFF1d2cxSEM0L2kwYW5MczZrOFhhTzA1Mkl3TUJZ?=
 =?utf-8?B?SkJjMmd6dWJ4UGF6M3FLUTRPellMMjdObTh4bUhFcm0xdkZvbWJtZVArZ2dl?=
 =?utf-8?B?N090SEVOY0xiL3AxYm5EelFIY3BkODVWbm5SWVlQRFIwTVpIMWp2TjhnL0Zo?=
 =?utf-8?B?Yk9Yc0d0Z0xWY2lENU5TSVZqZmNCNmRqQkNyL1lqMHdPbEJoQVNWMDBrKy93?=
 =?utf-8?B?R0ZXcnZ0Z0RjWFpwRUhqbFRaZkdpNG1ML2J3MFRGbFdGRDJrNkdiSHRQOUt5?=
 =?utf-8?B?OExIbktqcFVhT29LT1ozRURxajJmR1I0MlZXVVA3WUJwczkxQTNFOUpkTHZL?=
 =?utf-8?B?WCtyeFZ5d1QxcGFIZGVuSHZlNWd6MUl5ajNRSWpYZ2lyTkVPOWxFOEN4cS9K?=
 =?utf-8?B?c0hwWlJ5NE5ZUU16M2dINDRQK3dONE5pWVBHdWZJbkk2Z0REL2c2OHAyQkFv?=
 =?utf-8?B?QkllUHZVM0VIN2F4TkI1dG1DbEFqYTh6RVBTeExkTGtBUXJWY2pHOEdTRndF?=
 =?utf-8?B?YWJaYURyN2NrQUlmQXB3UGZFYnd5d3luUWMyVFJlMGxkUEFEK2Z5aWZ5Z0tm?=
 =?utf-8?B?TVdHMmNCOGxnakhJQ1ZXUlozVUIvY0E5bm9vdEZKZ3pXSmtPdnFobllxRk1U?=
 =?utf-8?B?WUw3M3VVRVMwaGU1WnBEcnNpVXhZc2IvK2Y4dW9aRER1RW9vYm8zM1FJT0hL?=
 =?utf-8?B?aXVGRDhEMHZsdHZrZGpVcVZUQnhCY3VLSE5aaWdlM21GVDhhcDNHMTNBbXpS?=
 =?utf-8?B?MFkvSXc3ekNNemczUnkxV2FzTVdXbHY0VU53VTBOVEt3ZkxMVWx5K0lDNHN2?=
 =?utf-8?B?WVNhVk5NQSszK24yajU4MW5MWUM0Q1NzZXZHUGhiSkd0dytkamFLTjVmNWF6?=
 =?utf-8?B?eHVVdGJUVVhnaFJPakJhVkVERnZSeEo4cThRK0tsN09kREN0d0ZTZHNqZENM?=
 =?utf-8?B?VHBmazI4ZHBFWktwTXJYWjR1N2M3R0Q1UUtGbjZVRDI5RzFvcks3QkhnMVdX?=
 =?utf-8?B?NVJlTVhIZWV4OS82ZERBRW4wdFl4aHJJYkc0K2pyQ055Y0lNSzVyb3V4dU4v?=
 =?utf-8?B?bkkwU2o3d0tHMEtIOHgybEp6eGRLNTc3SitFV0RNRnpwUFBNa2MwTUd0a3Mv?=
 =?utf-8?B?ZVRkc1E5QWdCdU1aakc0WHliSzlWTlZKTzhEWlRtNlVpWFB3OWhXTCtpWTFG?=
 =?utf-8?B?aHphNDFqY0lZaDJtZmVRVVR3QndYelRMMVNUS2k2bUQ1cTdsTVhVQ0VQVHhk?=
 =?utf-8?B?blc2M2FqTEVMZ1M0ZHRzUCtDcDcvWWNPV1J2ODNPVkZ1alA5aGIvRjcwZXMr?=
 =?utf-8?B?NUQ5NmZGZDEraUxNZmhZWVJvcVR0TkpEK05ZcWJNZU13WGJ5NGQxdUNzRmNt?=
 =?utf-8?B?dzFEaUJMQ3VGRTNQQ0JRT3RjOE9SY2RuQzBqRS9FSjcxTWVBakVjZDZrZkdP?=
 =?utf-8?B?bTJLOWJGa3BZTmIvZU9hTEJsM0FFaittUlN0aHBqMEJCTWl0S0NaUjIyM1NW?=
 =?utf-8?Q?s+qGjzQKRNYi9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c3Q1Yy9Bd0VVQzhhSUdiRzFOaU1ydUhKbHFxMkVpa0FGclRIaDBNOEFuYnQ3?=
 =?utf-8?B?MjdMNzZQcC80eE8waEYwU01MWGZFUWpycjBXMDgvOXlCSGpuOU1DOW00Ni9z?=
 =?utf-8?B?NU1kNWFkUjZQdjh5bCtKOVlYRVFSaUx5K0JvcTNVVGZyVkFTamRVaWZwczVL?=
 =?utf-8?B?VjZCVG9lUzBCY2JxVitRN0xoNnRkam5VeEdieUQ5WVU2b0J0OFRpZStwd1J2?=
 =?utf-8?B?L3ZqckE4VWozVHltblBLaVduSnBoQ3VhaDZIeE9ZUHUvNnZENG1nTUVBYVFL?=
 =?utf-8?B?V1REcDVSQzF3Y3E5bXJvZkhZWVhNaW85d1hNaVNWTC9DZ2V6VFVrMmtlcjdC?=
 =?utf-8?B?clVxbEZER3ZJc1NvYTNyRGgyRUEzN0JFeXk2Sk1maTRmQXJYSW91UFZFZXZ3?=
 =?utf-8?B?cW5ZVUtmMmE1RCtlbUFvaFl5Slk0SlBJYksrNGZEaFN6K0l2dWhVSTcvYWgy?=
 =?utf-8?B?ak9YOE9ERkh1QWZmWXQxU2FoUEs0THFKbGY5MEgwUWlDd1EzcTZwaWdCZDdh?=
 =?utf-8?B?ZW5OQllqT3ZLbzhNeWdBU0FBU2xNQ3hJTU5ZNTVVS083aG15VXU4Q1hOSVl4?=
 =?utf-8?B?OVYwa2s3T0dFbGFKdFVDbTFxRU5pdjdBVXgyM3ZnYzBmMm8vOGRna25VUGY2?=
 =?utf-8?B?c3dZd1dLUXpkTVM3QXhhaHBndlFaTVdsMjhUd2gySzhGWkc4bisxeUd2Q1Ni?=
 =?utf-8?B?QXRVNVdKa3FGRGFYMEp2dktCbitxWjlSUUJkRUZQR0lxNk03UktRNE5Lek02?=
 =?utf-8?B?NE5HNjZCbTVBOVNvUFpQZ2hIc2tFcU1nOVlxZEhiKzJpUmlOUlRqMDdiYVVx?=
 =?utf-8?B?Y0JrOC82TU92UWdTR244bGVObTNySVk2UTZmTVZ2MGZtOW9Od0VvRWpzQlJH?=
 =?utf-8?B?YzdNSGpMRldIK0ZGUjFxZlRkSVRiMVdxN3g4cTBoa2FyNlZ5enVyaE9aL2hM?=
 =?utf-8?B?dVFzRWdSRlpNZXVLZnUwTktXMS96K0t4bE1tRlBrOXBQeVE1T1dTNjBUZERh?=
 =?utf-8?B?bEtHSGlEcTdFVEtXcXJHWDBsMXJhZmZNZEpWeUM3QTNqK0hWQk9tOWcyNnVm?=
 =?utf-8?B?eVlGV0lPaXNpZTYxTkgvTHRJRXN4aDhzemZ5RkpadWdKK0NkVkhwdmdTdVhG?=
 =?utf-8?B?dzU4bTZlVTdFVVJEek5ONVJFT0h2aDZhUGQ2dlFLWU1UZzFPVmNscEF1d3Y5?=
 =?utf-8?B?cnNjZERuT0NIbjBWK2JJVTNYRExtN0Y4S1VyUTBVVVkvRGtnVUM3YU5wVHNl?=
 =?utf-8?B?aTJETGJRNzBWcXFSVEkvY01Zc00rcFlsQlg4aGVQZlNtek1MUllGZy9pWmVs?=
 =?utf-8?B?RUhic2FvejRXTTRGYWVSMTZjS293Wk9kRzR1d01abXVsNFBiUENvMVYvaThO?=
 =?utf-8?B?K3ZnWWR3eUhzaXJaK0hQVmRZQ3h5VG0vTUxtOUI4eTdXeUNTMjNhQklyYnF3?=
 =?utf-8?B?QmtqSjNUV2NWWGg2ZU9vY1JXSVRsbXpVRTdoNDZYWklLRFJtSmlyRW03ZU16?=
 =?utf-8?B?Qzd1L21GOEZzYlRPTkhiOGp4VnpmdnMvYW4zQTFjcCtsSk1DNm1MdU5YR2NX?=
 =?utf-8?B?Si9jSFEyU3hQZ2htaHBwdS94RmFVK0JSRklVWmU2Q3E3Q2NpdngyU05qWEJK?=
 =?utf-8?B?cS82cVU3a0lpclNhQXJFSzgvTEJxWnFQbXVEdjEvUFlCWTdHUWFqTDZOZEEx?=
 =?utf-8?B?Tk11VkxuRkoyWEZPUnlpZWZRTWp0Qis4Ym84NEczb0N6U3Y4YUdQeVJFWStx?=
 =?utf-8?B?ODlKQ3ZtWE1US2YrcllJL1diOFpNbmJWcDhJakQ4Z1d3K1k3WFFqeHdZRUMx?=
 =?utf-8?B?Y0U2R3NrZjl1SHlsYjM3SW94czhkWW5JakxkdStVOUhYS3JzWkFkSzNtczUr?=
 =?utf-8?B?SVdMMXpncnJpeUIyY0VZRCtJSndzVTFQaVJQMjNKOFd6dzh0bXMxS1N6YmNT?=
 =?utf-8?B?UVBrMVEvT1Z1eTkvN3p6ZmlIcC9taGN4TVd5VzlEL1luZDd1dklvbTlkenNy?=
 =?utf-8?B?Ykd2NlRhTVdNWDBIUXZlYWJRNCtDUTdYbHVBUDRIZ212bytJUzJkMmREY3N5?=
 =?utf-8?B?TDhQWktDNFFGM3N1dE05UG90MWVJNTRvRUtCRkNCZmhaRkU0TXVzQXpReklO?=
 =?utf-8?Q?E4XQ=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0df5aa8-b931-484d-828f-08dcf9ceb205
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 17:08:52.4695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jynCjH286Z9bly3BG5rGcq8PGjmazs53rHpGjy64m7RS+Mbsvfs/Z4PUoJpRihAj04Tce0+ZzAbBS5uCW+enCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4853
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <32B9D9F890E77145A3837A938134114A@namprd15.prod.outlook.com>
X-Proofpoint-GUID: _YmuKfPrLPukB1cegRe9yTgSAIlOOdrc
X-Proofpoint-ORIG-GUID: _YmuKfPrLPukB1cegRe9yTgSAIlOOdrc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Thanks Pavel.

On 30/10/24 00:59, Pavel Begunkov wrote:
> >=20
> On 10/22/24 15:50, Mark Harmstone wrote:
> ...
>> +static void btrfs_uring_read_finished(struct io_uring_cmd *cmd,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int issu=
e_flags)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_uring_priv *priv =3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *io_uring_cmd_to_pdu(cmd, st=
ruct btrfs_uring_priv *);
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_inode *inode =3D BTRFS_I(file_inode(pri=
v->iocb.ki_filp));
>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree *io_tree =3D &inode->io_tree;
>> +=C2=A0=C2=A0=C2=A0 unsigned long i;
>> +=C2=A0=C2=A0=C2=A0 u64 cur;
>> +=C2=A0=C2=A0=C2=A0 size_t page_offset;
>> +=C2=A0=C2=A0=C2=A0 ssize_t ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (priv->err) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D priv->err;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 if (priv->compressed) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i =3D 0;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page_offset =3D 0;
>> +=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i =3D (priv->iocb.ki_pos - p=
riv->start) >> PAGE_SHIFT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page_offset =3D offset_in_pa=
ge(priv->iocb.ki_pos - priv->start);
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 cur =3D 0;
>> +=C2=A0=C2=A0=C2=A0 while (cur < priv->count) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t bytes =3D min_t(size_=
t, priv->count - cur,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PAGE_SIZE - page_offset=
);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (copy_page_to_iter(priv->=
pages[i], page_offset, bytes,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &priv->iter) !=3D=
 bytes) {
>=20
> If that's an iovec backed iter that might fail, you'd need to
> steal this patch
>=20
> https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c=
753666e@ddn.com/
>=20
> and fail if "issue_flags & IO_URING_F_TASK_DEAD", see
>=20
> https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-13-9739c=
753666e@ddn.com/

Thanks, I've sent a patchset including your patch. Does it make a=20
difference, though? If the task has died, presumably copy_page_to_iter=20
can't copy to another process' memory...?

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =
=3D -EFAULT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto=
 out;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i++;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur +=3D bytes;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page_offset =3D 0;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 ret =3D priv->count;
>> +
>> +out:
>> +=C2=A0=C2=A0=C2=A0 unlock_extent(io_tree, priv->start, priv->lockend,=20
>> &priv->cached_state);
>> +=C2=A0=C2=A0=C2=A0 btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>=20
> When called via io_uring_cmd_complete_in_task() this function might
> not get run in any reasonable amount of time. Even worse, a
> misbehaving user can block it until the task dies.
>=20
> I don't remember if rwsem allows unlock being executed in a different
> task than the pairing lock, but blocking it for that long could be a
> problem. I might not remember it right but I think Boris meantioned
> that the O_DIRECT path drops the inode lock right after submission
> without waiting for bios to complete. Is that right? Can we do it
> here as well?

We can't release the inode lock until we've released the extent lock. I=20
do intend to look into reducing the amount of time we hold the extent=20
lock, if we can, but it's not trivial to do this in a safe manner.
We could perhaps move the unlocking to btrfs_uring_read_extent_endio=20
instead, but it looks unlocking an rwsem in a different context might=20
cause problems with PREEMPT_RT(?).

>> +
>> +=C2=A0=C2=A0=C2=A0 io_uring_cmd_done(cmd, ret, 0, issue_flags);
>> +=C2=A0=C2=A0=C2=A0 add_rchar(current, ret);
>> +
>> +=C2=A0=C2=A0=C2=A0 for (unsigned long index =3D 0; index < priv->nr_pag=
es; index++)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __free_page(priv->pages[inde=
x]);
>> +
>> +=C2=A0=C2=A0=C2=A0 kfree(priv->pages);
>> +=C2=A0=C2=A0=C2=A0 kfree(priv->iov);
>> +=C2=A0=C2=A0=C2=A0 kfree(priv);
>> +}
>> +
>> +void btrfs_uring_read_extent_endio(void *ctx, int err)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_uring_priv *priv =3D ctx;
>> +
>> +=C2=A0=C2=A0=C2=A0 priv->err =3D err;
>> +
>> +=C2=A0=C2=A0=C2=A0 *io_uring_cmd_to_pdu(priv->cmd, struct btrfs_uring_p=
riv *) =3D priv;
>=20
> a nit, I'd suggest to create a temp var, should be easier to
> read. It'd even be nicer if you wrap it into a structure
> as suggested last time.
>=20
> struct io_btrfs_cmd {
>  =C2=A0=C2=A0=C2=A0=C2=A0struct btrfs_uring_priv *priv;
> };
>=20
> struct io_btrfs_cmd *bc =3D io_uring_cmd_to_pdu(cmd, struct io_btrfs_cmd);
> bc->priv =3D priv;

No problem, I've sent a patch for this.

>> +=C2=A0=C2=A0=C2=A0 io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring=
_read_finished);
>> +}
>> +
>> +static int btrfs_uring_read_extent(struct kiocb *iocb, struct=20
>> iov_iter *iter,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 start, u64 lockend,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cached_state,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 disk_bytenr, u64 disk_io_size,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t count, bool compressed,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct iovec *iov,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct io_uring_cmd *cmd)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_inode *inode =3D BTRFS_I(file_inode(ioc=
b->ki_filp));
>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree *io_tree =3D &inode->io_tree;
>> +=C2=A0=C2=A0=C2=A0 struct page **pages;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_uring_priv *priv =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 unsigned long nr_pages;
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
>> +=C2=A0=C2=A0=C2=A0 pages =3D kcalloc(nr_pages, sizeof(struct page *), G=
FP_NOFS);
>> +=C2=A0=C2=A0=C2=A0 if (!pages)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_alloc_page_array(nr_pages, pages, 0);
>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 priv =3D kmalloc(sizeof(*priv), GFP_NOFS);
>> +=C2=A0=C2=A0=C2=A0 if (!priv) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 priv->iocb =3D *iocb;
>> +=C2=A0=C2=A0=C2=A0 priv->iov =3D iov;
>> +=C2=A0=C2=A0=C2=A0 priv->iter =3D *iter;
>> +=C2=A0=C2=A0=C2=A0 priv->count =3D count;
>> +=C2=A0=C2=A0=C2=A0 priv->cmd =3D cmd;
>> +=C2=A0=C2=A0=C2=A0 priv->cached_state =3D cached_state;
>> +=C2=A0=C2=A0=C2=A0 priv->compressed =3D compressed;
>> +=C2=A0=C2=A0=C2=A0 priv->nr_pages =3D nr_pages;
>> +=C2=A0=C2=A0=C2=A0 priv->pages =3D pages;
>> +=C2=A0=C2=A0=C2=A0 priv->start =3D start;
>> +=C2=A0=C2=A0=C2=A0 priv->lockend =3D lockend;
>> +=C2=A0=C2=A0=C2=A0 priv->err =3D 0;
>> +
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_encoded_read_regular_fill_pages(inode,=
 disk_bytenr,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 disk_io_size, pages,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 priv);
>> +=C2=A0=C2=A0=C2=A0 if (ret && ret !=3D -EIOCBQUEUED)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fail;
>=20
> Turning both into return EIOCBQUEUED is a bit suspicious, but
> I lack context to say. Might make sense to return ret and let
> the caller handle it.

btrfs_encoded_read_regular_fill_pages returns 0 if the bio completes=20
before the function can finish, -EIOCBQUEUED otherwise. In either case=20
the behaviour of the calling function will be the same.

>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If we return -EIOCBQUEUED, we're deferring t=
he cleanup to
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * btrfs_uring_read_finished, which will handle=
 unlocking the extent
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * and inode and freeing the allocations.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +
>> +=C2=A0=C2=A0=C2=A0 return -EIOCBQUEUED;
>> +
>> +fail:
>> +=C2=A0=C2=A0=C2=A0 unlock_extent(io_tree, start, lockend, &cached_state=
);
>> +=C2=A0=C2=A0=C2=A0 btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>> +=C2=A0=C2=A0=C2=A0 kfree(priv);
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>> +
>> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int issue_flags)
>> +{
>> +=C2=A0=C2=A0=C2=A0 size_t copy_end_kernel =3D offsetofend(struct=20
>> btrfs_ioctl_encoded_io_args,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 flags);
>> +=C2=A0=C2=A0=C2=A0 size_t copy_end;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_ioctl_encoded_io_args args =3D { 0 };
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +=C2=A0=C2=A0=C2=A0 u64 disk_bytenr, disk_io_size;
>> +=C2=A0=C2=A0=C2=A0 struct file *file =3D cmd->file;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_inode *inode =3D BTRFS_I(file->f_inode);
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D inode->root->fs_in=
fo;
>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree *io_tree =3D &inode->io_tree;
>> +=C2=A0=C2=A0=C2=A0 struct iovec iovstack[UIO_FASTIOV];
>> +=C2=A0=C2=A0=C2=A0 struct iovec *iov =3D iovstack;
>> +=C2=A0=C2=A0=C2=A0 struct iov_iter iter;
>> +=C2=A0=C2=A0=C2=A0 loff_t pos;
>> +=C2=A0=C2=A0=C2=A0 struct kiocb kiocb;
>> +=C2=A0=C2=A0=C2=A0 struct extent_state *cached_state =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 u64 start, lockend;
>> +=C2=A0=C2=A0=C2=A0 void __user *sqe_addr =3D u64_to_user_ptr(READ_ONCE(=
cmd->sqe->addr));
>=20
> Let's rename it, I was taken aback for a brief second why
> you're copy_from_user() from an SQE / the ring, which turns
> out to be a user pointer to a btrfs structure.

sqe_addr being the addr field in the SQE, not the address of the SQE. I=20
can see how it might be misleading, though.

> ...
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_encoded_read(&kiocb, &iter, &args, &ca=
ched_state,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 &disk_bytenr, &disk_io_size);
>> +=C2=A0=C2=A0=C2=A0 if (ret < 0 && ret !=3D -EIOCBQUEUED)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_free;
>> +
>> +=C2=A0=C2=A0=C2=A0 file_accessed(file);
>> +
>> +=C2=A0=C2=A0=C2=A0 if (copy_to_user(sqe_addr + copy_end, (char *)&args =
+=20
>> copy_end_kernel,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 sizeof(args) - copy_end_kernel)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EIOCBQUEUED)=
 {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlo=
ck_extent(io_tree, start, lockend, &cached_state);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrf=
s_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EFAULT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_free;
>=20
> It seems we're saving iov in the priv structure, who can access the iovec
> after the request is submitted? -EIOCBQUEUED in general means that the
> request is submitted and will get completed async, e.g. via callback, and
> if the bio callback can use the iov maybe via the iter, this goto will be
> a use after free.
>=20
> Also, you're returning -EFAULT back to io_uring, which will kill the
> io_uring request / cmd while there might still be in flight bios that
> can try to access it.
>=20
> Can you inject errors into the copy and test please?

The bio hasn't been submitted at this point, that happens in=20
btrfs_uring_read_extent. So far all we've done is read the metadata from=20
the page cache. The copy_to_user here is copying the metadata info to=20
the userspace structure.

>=20
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EIOCBQUEUED) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 count;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If we've optimized t=
hings by storing the iovecs on the stack,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * undo this.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */> +=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!iov) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iov =
=3D kmalloc(sizeof(struct iovec) * args.iovcnt,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_NOFS);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (=
!iov) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 unlock_extent(io_tree, start, lockend,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 &cached_state);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto out_acct;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memc=
py(iov, iovstack,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct iovec) * args.iovcnt);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 count =3D min_t(u64, iov_ite=
r_count(&iter), disk_io_size);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Match ioctl by not return=
ing past EOF if uncompressed */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!args.compression)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 coun=
t =3D min_t(u64, count, args.len);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_uring_read_ext=
ent(&kiocb, &iter, start, lockend,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 cached_state, disk_bytenr,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 disk_io_size, count,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 args.compression, iov, cmd);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_acct;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +out_free:
>> +=C2=A0=C2=A0=C2=A0 kfree(iov);
>> +
>> +out_acct:
>> +=C2=A0=C2=A0=C2=A0 if (ret > 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add_rchar(current, ret);
>> +=C2=A0=C2=A0=C2=A0 inc_syscr(current);
>> +
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>=20


