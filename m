Return-Path: <io-uring+bounces-2036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8AD8D6835
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 19:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85FF01C218F0
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 17:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D06D16F83D;
	Fri, 31 May 2024 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="SzrAQqfA"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C90A2E3F2;
	Fri, 31 May 2024 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717177013; cv=fail; b=sX2pmhIJY30IZBfqNZmjs9jNSL0bTRXMi+48oH4Exg5sK+7X584Ny7II4ZlQ2twsf0B0oNwgjn/Z5DjQrwuS4WgDCnO1ybTttvK0teKULycAYbUZvUepKb6SNv9AwaQIjH9DRRpva07ES8rBviJ5KjRMU6tkyfn1HR927bjae8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717177013; c=relaxed/simple;
	bh=9CWxS5PnPdnCzdwU380p2Wg5JKKhThiMkHjGLK6zW/w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CW9D9pEDLWQOIlfvUiXtvLJksUu5rXinqyybPkSIrqxGwYm2qxEATtU4C+5FMsJd4MmJpeWtQN1+BeXaIgfNjEAY61f9EoUjkWrxtN77NDAtC8frkjEhGlLEN+j7cdoIyCUVCvdora6dIJxPbwwdBE4qL4hNdHgliVMym2FqRs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=SzrAQqfA; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101]) by mx-outbound10-69.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 31 May 2024 17:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBe748frS2kDvEESa2nuowyX5HehktutEiv+msYMbExvhrFbmDjLF4C5LlXa1Dbh6ZSQrFnR475DyRRWysLfMYF4df4f984Ul9wkjzC0BABGa83cAQzaBjldGMeQH98GbM/IoOVrXjTuCIZfVRTfdYQV25cKk3ZCu+YG8bzt0HD8c8K+YWBq6p1RntNnNw3X60jXzZUaiYkZ/4cC8CrN/SMSl30++rgfg8t+PahW+KQlX3pteF1fIUFYeOpV1DAsSaO1katpqpj8OtPRU3iF/ubmZoIZfzwcMbrnaRL+yXOg6avj89I9xLo5FPBIvPTignN03xn6e3WQN4K4p2zg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CWxS5PnPdnCzdwU380p2Wg5JKKhThiMkHjGLK6zW/w=;
 b=lat7PuAXUyfY9bOWrZPOCQtmvuT1mEHk6xJmE0KjcrLUZoCAV/r2SqvpGSDE9YG0Oe166feBFEJckHrYdSEbD9Gx3W6MRX+HB81tcRXa+R065lksN5OxBBY9O6ms4BuslzYWo/6uPm0bN41iN8CZ5rNHW2Qbe0v9mkXKeWl+6XtXAabksOw9MiBx/Si6h1Weho7TgVEwbwMRQ3HKFfTasaNy9cxO4ERJOsSQqwbKMajK80eSKkF7I0+70vBqw4Vqz8dAVv3S41mhYwcItodDWEAPVbQ5mHvuAdA29X1TbCpfw57n2+E+SxdeXeZyNfOR3cdHeSrg07cWLMat+ifnEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CWxS5PnPdnCzdwU380p2Wg5JKKhThiMkHjGLK6zW/w=;
 b=SzrAQqfA3r9DPcEPuYtzFtSV0tUkgaCLaDlJwPLbu9uBJPi6fiYuJdkzrrFSUFQfUph5cNp1h694d1VcgpnKFY1Otrh5xigvq7axmsnqZCcs5td5Xz+EDz9+Nl/DeITDenb25j/Aoqh/3YfKL0XkyqCknJJ/DbLVZKnU/WyWIIw=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by PH0PR19MB5052.namprd19.prod.outlook.com (2603:10b6:510:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23; Fri, 31 May
 2024 17:36:33 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 17:36:30 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>, Amir
 Goldstein <amir73il@gmail.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "bernd.schubert@fastmail.fm"
	<bernd.schubert@fastmail.fm>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH RFC v2 19/19] fuse: {uring} Optimize async sends
Thread-Topic: [PATCH RFC v2 19/19] fuse: {uring} Optimize async sends
Thread-Index: AQHasfIzde/tVN6LyE6lAq2q8evYZbGxif4AgAAUQgA=
Date: Fri, 31 May 2024 17:36:30 +0000
Message-ID: <870c28bd-1921-4e00-9898-1d93b031c465@ddn.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <20240529-fuse-uring-for-6-9-rfc2-out-v1-19-d149476b1d65@ddn.com>
 <ee075116-5ed0-4ad7-9db2-048b14655d42@kernel.dk>
In-Reply-To: <ee075116-5ed0-4ad7-9db2-048b14655d42@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|PH0PR19MB5052:EE_
x-ms-office365-filtering-correlation-id: 4d7765e2-74c5-43dc-b071-08dc8198350b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?MjJlM3ZQNlNyanZEK1hPV2V0SHpZWTVVcFNrRmR3UGYxdEdISGxoM3FBS3ht?=
 =?utf-8?B?NDUrNmVsYWdpM1AzMFFKMCtjTTlmTkpucUVPTGtyOVM0R3NyMDZrbzEwNWZK?=
 =?utf-8?B?UmFQUElJTzFLaXllTFVaMmRzT25qb3ltRStNSnV2ODY0dk5kMC9pTHoxdXN3?=
 =?utf-8?B?SVQ1ckdiSk54RTFoNnJheCtIQlFkOW85K2tBUnFab1BuNi9vZk1KdGc0OWEz?=
 =?utf-8?B?MkREaWtKNDVqcFNoUkRGM0dhMmIxTnJFVGRaWnpEajVHaDZpWnVyWnNlbU9q?=
 =?utf-8?B?ZUFwNzRzY25CT2lHSjI5OHR6TDI3aHBlbEhkK3hlSGsyeVp3bEx0SU1ISXZR?=
 =?utf-8?B?ZWxWd1lFeVhreEM3ME1lMC8xanRuQkdJR2s1ZU9aVDU0M1ZneXBObWNmVC9W?=
 =?utf-8?B?Q21UdkRxMUFLbFU1WHc5cmRUQjl3SGIwQ0NEUkpBZDFSNzlWdFdXVFFuOXdG?=
 =?utf-8?B?STRrSnBKWDhQTHh5UFFMSkUyUzh6QlRUNmZ5U2RNWC9uczRGVlVpQ2RhUngz?=
 =?utf-8?B?NERpZUNLb2d6dEhmUzV6MFRQZzJ2a0VZdTdTaWd3VDhDRkp6bS95UEptUk5E?=
 =?utf-8?B?ZXRNRHlZQ3RQZWVqOXhuMTlGVlJDRkY2NFp2aWppalhBUDNjYWxSRkVJN1FG?=
 =?utf-8?B?NDBUZzVQdDN4YWEyaU1pSHJPOHY3bWViM1VPanAxcU1mVEVNc0lXV1ZaNU1r?=
 =?utf-8?B?V2xYT29WUEE4MlV2emRNRk5rRTNhcHV4em1iVjZXakxWL2RuaUtyRjZLcHdk?=
 =?utf-8?B?TjZ0YTh3YStEZDhtUi9IRm1TcTQvOEI5d2lFL01qaGZPR1BPbmRxSXJoNndN?=
 =?utf-8?B?VlhkdExVZnR2elZRWFllb3ByV0NPUjJCMGd5QnlIUXNYMnBhWkxzVFBnUFN6?=
 =?utf-8?B?dnNhSDJiN3h2RU5lYjRoQ3ZzZ1NtcjcrdFVXRk1qTkxRZjZrTWRKUm83L3JZ?=
 =?utf-8?B?a2lFdjFKbnRLdVVoc1BDVFRXOFdzaFZxbThiM0tVTlVpOXhLL080R1RuZVdw?=
 =?utf-8?B?a0ljTTRWNnNZWHUrcE5Yb3RrYkpiUURIcURlZGU3QTFTT0hPSlVHQXJqcmJG?=
 =?utf-8?B?aHBDWmtDd0dYMUJNNWRWSmNoWEhMQm1mSEFrcnU1MUR4MVlFMGg0MmRFK0Jo?=
 =?utf-8?B?WXhMWlZRYmRKMWc1SjFUL2orQ010VEF2N0MvQ0JUU3JRN1BKMElXVS9Ecm1U?=
 =?utf-8?B?aWV0WnRVelFsbElRWW8xdnVxZjZwV2MxNUQzb0ZCREJOdTlldlFlYVp3Tllx?=
 =?utf-8?B?UUxNcHBRTjJMOEpRcGk3dHNJbjIycWZiUHdRTFFuczZZN20xRWtSY1o4SWlM?=
 =?utf-8?B?NDgwcmVGQ1VCaHdHa25QMGhPdWdZdkFJeEJ4aGdnMHIyeGpKOWhBRXdWUU9S?=
 =?utf-8?B?aTBjb25Pekg2TE5jQlhNZGRiVlpYR0poa0NZUDhPUTdock9HeHhLcFBmRWRj?=
 =?utf-8?B?UnJ5QWlrYWIzVkdobkxUMDdMNzBxcWM2eXNyQlpLbGpac2NuWTNtdlRadldt?=
 =?utf-8?B?d1pUSzFJMDFZTzFSM3p1Tk0vclVEMnVmTVBBZFVWOGt0RUJKUjhZNStCamhu?=
 =?utf-8?B?R0ZuQVlibUdxcGFybzdYREFGUThKeWwzanhCamVGdEJEVU9hdXhYUzhzbitt?=
 =?utf-8?B?SlRpbHE3K1U1VXltdVFpQ0NKV2cyalM5Q2gvRGpsUTN1eUorVnR1cG91Y2xi?=
 =?utf-8?B?NFdyNStOWlVOQytIdHdmMm9OVUpYSnY3QlM2a1JtU1NVMlg3dWVEL2NiOGpH?=
 =?utf-8?B?VTdHeFRWQTNxV0FZUGkySXVlTGNsTWVlOXQrUSt3bzNYbVQ1alRHT0xLL1d0?=
 =?utf-8?B?ZHc3QTA4STRhd1FZSzZlUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NjNDbHh2ZXIyRmVyRGd3Z05CRDZlbUx5ZlBvUmt2V2tEcEZQbms5S0xIYUp5?=
 =?utf-8?B?UzhsbGprelVnOWU3T2U4NVJvdDA1ZUhCVUJRVGw4MUNwL3h1Sm8zTHpPT1Vw?=
 =?utf-8?B?bkRTb3Y1OU1WNStJb0JiSGlRNnhTYmkyM1NrbC9hYXlCUndLUDVZeURXb0E4?=
 =?utf-8?B?N2NYOGNHQ1dxSHRMMy9HY2dOY3ZxNWNHbzRhajlMY0Q0TmFRcldEci96S2li?=
 =?utf-8?B?M0U2cEYrb0FsMzhwUjBURWRhRENLZE1IRzJnRzNMY3NLNGx2ZmFON2pjNWUw?=
 =?utf-8?B?ajd6bWwvZTJoMU82UHB6RFRNWWY5MmRDM2REQ0dTeUNMdERYZ2Y0T1U1Nm1o?=
 =?utf-8?B?dlNxK3Q2QmZiT1VKNGZ0MStVdVI2dVZOa00zOE50WEoyK2lnWW5PL0ZGUFV4?=
 =?utf-8?B?V1kwVmFTVXRkRFhvbkdMNFBvUnVsZXlwSlFEdWhYLzRPb0pzbjk1WVViNkpi?=
 =?utf-8?B?VEFGcksxSDU1dU81NzhIaUVicHBpUEl4bThzMWRrQTZ4NjFnVkZIZEQybWhx?=
 =?utf-8?B?NllNZkRMTDhmcHBFbVNJVGhJbU4vSGRHU2IzMEtvTE5xRFRML1FDTG9WRzN2?=
 =?utf-8?B?V2hMUnIrMFRiR3QxTG5QdjVvdXpFSlk3VWpncjhrMHgrdURyRmN4d0JHTzNI?=
 =?utf-8?B?eWdSYmtlR28yZ1U1ZFErZy8vcStKZXZuM3paZFFBMDc2QSt6NkNadFJKZkxH?=
 =?utf-8?B?d3VWeXFJT0l6Wmh5U2o3Qjd6OGRZQldnOUJiOTdWcS9zd1VSdi8yNUtUeXhF?=
 =?utf-8?B?ME04U1hIUXRYUnAzT2hkODJQQjZqczhhYmRwZS9SWEFlcUJkNHhjUWN2V09D?=
 =?utf-8?B?Y0p3S0RHYmJPc3FWazcvdHdISlQzZ1QyM2pvSmhBdVpQdlBTVmYzVlpTa2tH?=
 =?utf-8?B?QUtzN3EwU24ybWFKc3lOV0FPSm9FRUJrbXdXU1BNeEpVSGpsaDBUOTFORmY3?=
 =?utf-8?B?ZnR1bzhJQlNFUW5wbURjc0g4VWVKYlBSblllMkpGa3NrNmZ4YU9nTUZGWWFV?=
 =?utf-8?B?a2JodWZiQW9oM3IxcDBSOE9GbjhyYzNEbnZER1l1RVppOVYzS3BUbUtYZFJo?=
 =?utf-8?B?QmhsWEtKbkRDSDlNZ3JZWjBGalVJZlgwbWZSRjRhcm1Xbjhza3h4WGsrM1FH?=
 =?utf-8?B?eWNUbG5NZjdxcmw3eS9vd0JwaTk4Z2taZHBTL1JRRXZHQmRMRzRFbmVvVnRP?=
 =?utf-8?B?L1AyY3I4bW5BL0lXeml6SEFvL0NvSjF4VkVncDRPaU1SUStsUHltZ3FPS2Qr?=
 =?utf-8?B?WUdGUlZ5K0JRUWduT29Pazk1b2NxSloyTWk1THNPaG82ajRxcmNEVE02MlM3?=
 =?utf-8?B?L3VRWFZJdEt0QWFVN0RHdDlOQis0ako4dDF2N0tIT2lxYXo4dkJKbUVMN0do?=
 =?utf-8?B?YlJyNGJDRndUdzFSUDBqVTlhTDZoQkVHb2xDU292dUhOUWdXS1FGdHlCL211?=
 =?utf-8?B?cEc4cGFpdkhRMFhSdkpRTjR3WWtMY3VwOXRYVDNlNG5uaktWbUtJMVlsaEFq?=
 =?utf-8?B?TDJJakJUOHc1SHlyRUZndTJSd1JhamZBY0l1ZzhIN1hnbTdaMWszWTlmTWIx?=
 =?utf-8?B?SE81ZmhSTDBGN0FVZDdIdk8xL0VPcnZyNkt3cFIwU0psVFRPcTBzLy9zaXYy?=
 =?utf-8?B?R1ExTnFNT0h5T05lOGpkMkswQ093UzRxejNPRVRwMVQxK3lEZ1NtUmFmY3hT?=
 =?utf-8?B?dGZTcW5uN0hBS0hGcTcya3hnOU5oM1UxUlVvNndRU1lIQ3FjR3hyQXVpNWRZ?=
 =?utf-8?B?alMxaFNabG5aalVZOXVXSXN5M1hQanI4RlZQaHlTL2NGR0cvNlFkVGZNNUEv?=
 =?utf-8?B?R25oOVNUUTVzV3dPUWZlRGZ3WHJRWmlBUFZvV0ZrdHBFd0IzeEw1VFdVSjl6?=
 =?utf-8?B?a3IvNklQVmRXOUhFMTNRMDh1aXZSeWlqWkE3VmxIT2dpeE9tbzVKUjZUWjUw?=
 =?utf-8?B?SGw2ZzFMQThjMXpJUmpRb1ZQdXBYd2o4NjNjUXNOUmI3WlhhalY4R0RBR0lJ?=
 =?utf-8?B?Qm5DbURFczdJcmZTL3o4eitwWFFMenlCS0x4UWUvYzRQQnBQN2VLYmViTE12?=
 =?utf-8?B?c2VZcnd5N01aZXhOM0ZaYmYzc1V3dWdDbkc0OTF1T2ZFdTB5WTlHL2ZwSENW?=
 =?utf-8?B?eGhxcmMxcTQ2ZTd1UEZxUk5rMHFPM042ME5QZFlQdWhPa1ZRRVJpZUNFQW5z?=
 =?utf-8?Q?OkdeWHDywSF8t1zpfEM/7x0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC09376E96A5744891C20A32EC7BA011@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YJZAQC6tYtbigfHEa389Oa8DcJv8NAVRIIULX8w9TbjUG7vqwR0jRw/mfVnP9GjvjofLYGSY4OjXS4M7NW/tVsoDrCtkjkNDZnsntYhd98XbCJEJGv8StMvx1bNdtOeza9RM7kfiBm38OkH38UGp8V+nRC7gH0L5sUjYPqntdhzaM5iyFaDYI3ymOQGndHbSqzcjD5mnGEsohqtrSBzYM+cpq5YDmg8Y0FHF3TB4z5mUISOtQZz32OyRIBkrattU2/UiUEeqeL555jrDQOV5b1VV34gqXWZMbwiKDs/4r+1yEomhUmk1sK9SioXj8fuPweQQkXodgz4CpIPlhNQp9ZgQflbGMC3HCFgUjlzamtGWwIVtchi8gxL4U71c1pno9HaVQUK96Q+3JOtjqBY+mcBGH2Cr1c4DtkKdxfy/92MQYPSk0BTZ7sxswMLQ/dwTXd7rVbODQaFb1bEQ+J+pAnt7O8LuH7YQTlKuu/TBDdGLhWOzrmmxrf/6DO/kE2qRKCCz832dJ5HRsTra0lLPeEqCddoZMDiPAR9UKFA6GKzkcltGrjdwDdc8vJ5rPj0HnQHgFnPbI7ZrlguAqHaS27/JbIMetjWb29guWdWv5Ev6D79gQyDUmcJZ2y6P/U6tfgC4nNfzrnAGk6ZLxbG4zQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7765e2-74c5-43dc-b071-08dc8198350b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 17:36:30.4163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2S0Ujx4d5nyTOXnfFIGuI5Gdng/rC7E8CCB2Sw0zrVlug3SOcyQrveVMzh7F87BjQhVKWkFHYKSQGH8YqdTO3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5052
X-BESS-ID: 1717176997-102629-12766-12110-1
X-BESS-VER: 2019.1_20240530.1612
X-BESS-Apparent-Source-IP: 104.47.58.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsZGFqZAVgZQ0DTN2MQ8xcDAKD
	UpKc3EJNXY0izRJNkk1TQpNQkonKZUGwsAOqXr40EAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.256628 [from 
	cloudscan22-90.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gNS8zMS8yNCAxODoyNCwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gNS8yOS8yNCAxMjowMCBQ
TSwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+PiBUaGlzIGlzIHRvIGF2b2lkIHVzaW5nIGFzeW5j
IGNvbXBsZXRpb24gdGFza3MNCj4+IChpLmUuIGNvbnRleHQgc3dpdGNoZXMpIHdoZW4gbm90IG5l
ZWRlZC4NCj4+DQo+PiBDYzogaW8tdXJpbmdAdmdlci5rZXJuZWwub3JnDQo+PiBTaWduZWQtb2Zm
LWJ5OiBCZXJuZCBTY2h1YmVydCA8YnNjaHViZXJ0QGRkbi5jb20+DQo+IA0KPiBUaGlzIHBhdGNo
IGlzIHZlcnkgY29uZnVzaW5nLCBldmVuIGFmdGVyIGhhdmluZyBwdWxsZWQgdGhlIG90aGVyDQo+
IGNoYW5nZXMuIEluIGdlbmVyYWwsIHdvdWxkIGJlIGdyZWF0IGlmIHRoZSBpb191cmluZyBsaXN0
IHdhcyBDQydlZCBvbg0KDQpIbW0sIGxldCBtZSB0cnkgdG8gZXhwbGFpbi4gQW5kIHllcywgSSBk
ZWZpbml0ZWx5IG5lZWQgdG8gYWRkIHRoZXNlIGRldGFpbHMgDQp0byB0aGUgY29tbWl0IG1lc3Nh
Z2UNCg0KV2l0aG91dCB0aGUgcGF0Y2g6DQoNCjxzZW5kaW5nIGEgc3RydWN0IGZ1c2VfcmVxPiAN
Cg0KZnVzZV91cmluZ19xdWV1ZV9mdXNlX3JlcQ0KICAgIGZ1c2VfdXJpbmdfc2VuZF90b19yaW5n
DQogICAgICAgIGlvX3VyaW5nX2NtZF9jb21wbGV0ZV9pbl90YXNrDQogICAgICAgIA0KPGFzeW5j
IHRhc2sgcnVucz4NCiAgICBpb191cmluZ19jbWRfZG9uZSgpDQoNCg0KTm93IEkgd291bGQgbGlr
ZSB0byBjYWxsIGlvX3VyaW5nX2NtZF9kb25lKCkgZGlyZWN0bHkgd2l0aG91dCBhbm90aGVyIHRh
c2sNCndoZW5ldmVyIHBvc3NpYmxlLiBJIGRpZG4ndCBiZW5jaG1hcmsgaXQsIGJ1dCBhbm90aGVy
IHRhc2sgaXMgaW4gZ2VuZXJhbA0KYWdhaW5zdCB0aGUgZW50aXJlIGNvbmNlcHQuIFRoYXQgaXMg
d2hlcmUgdGhlIHBhdGNoIGNvbWVzIGluDQoNCg0KZnVzZV91cmluZ19xdWV1ZV9mdXNlX3JlcSgp
IG5vdyBhZGRzIHRoZSBpbmZvcm1hdGlvbiBpZiBpb191cmluZ19jbWRfZG9uZSgpIA0Kc2hhbGwg
YmUgY2FsbGVkIGRpcmVjdGx5IG9yIHZpYSBpb191cmluZ19jbWRfY29tcGxldGVfaW5fdGFzaygp
Lg0KDQoNCkRvaW5nIGl0IGRpcmVjdGx5IHJlcXVpcmVzIHRoZSBrbm93bGVkZ2Ugb2YgaXNzdWVf
ZmxhZ3MgLSB0aGVzZSBhcmUgdGhlDQpjb25kaXRpb25zIGluIGZ1c2VfdXJpbmdfcXVldWVfZnVz
ZV9yZXEuDQoNCg0KMSkgKGN1cnJlbnQgPT0gcXVldWUtPnNlcnZlcl90YXNrKQ0KZnVzZV91cmlu
Z19jbWQgKElPUklOR19PUF9VUklOR19DTUQpIHJlY2VpdmVkIGEgY29tcGxldGlvbiBmb3IgYSAN
CnByZXZpb3VzIGZ1c2VfcmVxLCBhZnRlciBjb21wbGV0aW9uIGl0IGZldGNoZWQgdGhlIG5leHQg
ZnVzZV9yZXEgYW5kIA0Kd2FudHMgdG8gc2VuZCBpdCAtIGZvciAnY3VycmVudCA9PSBxdWV1ZS0+
c2VydmVyX3Rhc2snIGlzc3VlIGZsYWdzDQpnb3Qgc3RvcmVkIGluIHN0cnVjdCBmdXNlX3Jpbmdf
cXVldWU6OnVyaW5nX2NtZF9pc3N1ZV9mbGFncw0KDQoyKSAnZWxzZSBpZiAoY3VycmVudC0+aW9f
dXJpbmcpJw0KDQooYWN0dWFsbHkgZG9jdW1lbnRlZCBpbiB0aGUgY29kZSkNCg0KMi4xIFRoaXMg
bWlnaHQgYmUgdGhyb3VnaCBJT1JJTkdfT1BfVVJJTkdfQ01EIGFzIHdlbGwsIGJ1dCB0aGVuIHNl
cnZlciANCnNpZGUgdXNlcyBtdWx0aXBsZSB0aHJlYWRzIHRvIGFjY2VzcyB0aGUgc2FtZSByaW5n
IC0gbm90IG5pY2UuIFdlIG9ubHkNCnN0b3JlIGlzc3VlX2ZsYWdzIGludG8gdGhlIHF1ZXVlIGZv
ciAnY3VycmVudCA9PSBxdWV1ZS0+c2VydmVyX3Rhc2snLCBzbw0Kd2UgZG8gbm90IGtub3cgaXNz
dWVfZmxhZ3MgLSBzZW5kaW5nIHRocm91Z2ggdGFzayBpcyBuZWVkZWQuDQoNCjIuMiBUaGlzIG1p
Z2h0IGJlIGFuIGFwcGxpY2F0aW9uIHJlcXVlc3QgdGhyb3VnaCB0aGUgbW91bnQgcG9pbnQsIHRo
cm91Z2gNCnRoZSBpby11cmluZyBpbnRlcmZhY2UuIFdlIGRvIGtub3cgaXNzdWUgZmxhZ3MgZWl0
aGVyLg0KKFRoYXQgb25lIHdhcyBhY3R1YWxseSBhIHN1cnByaXNlIGZvciBtZSwgd2hlbiB4ZnN0
ZXN0cyBjYXVnaHQgaXQuDQpJbml0aWFsbHkgSSBoYWQgYSBjb25kaXRpb24gdG8gc2VuZCB3aXRo
b3V0IHRoZSBleHRyYSB0YXNrIHRoZW4gbG9ja2RlcA0KY2F1Z2h0IHRoYXQuDQoNCg0KSW4gYm90
aCBjYXNlcyBpdCBoYXMgdG8gdXNlIGEgdGFza3MuDQoNCg0KTXkgcXVlc3Rpb24gaGVyZSBpcyBp
ZiAnY3VycmVudC0+aW9fdXJpbmcnIGlzIHJlbGlhYmxlLg0KDQoNCjMpIGV2ZXJ5dGhpbmcgZWxz
ZQ0KDQozLjEpIEZvciBhc3luYyByZXF1ZXN0cywgaW50ZXJlc3RpbmcgYXJlIGNhY2hlZCByZWFk
cyBhbmQgd3JpdGVzIGhlcmUuIEF0IGEgbWluaW11bQ0Kd3JpdGVzIGEgaG9sZGluZyBhIHNwaW4g
bG9jayBhbmQgdGhhdCBsb2NrIGNvbmZsaWN0cyB3aXRoIHRoZSBtdXRleCBpby11cmluZyBpcyB0
YWtpbmcgLSANCndlIG5lZWQgYSB0YXNrIGFzIHdlbGwNCg0KMy4yKSBzeW5jIC0gbm8gbG9jayBi
ZWluZyBob2xkLCBpdCBjYW4gc2VuZCB3aXRob3V0IHRoZSBleHRyYSB0YXNrLg0KDQoNCj4gdGhl
IHdob2xlIHNlcmllcywgaXQncyB2ZXJ5IGhhcmQgdG8gcmV2aWV3IGp1c3QgYSBzaW5nbGUgcGF0
Y2gsIHdoZW4geW91DQo+IGRvbid0IGhhdmUgdGhlIGZ1bGwgcGljdHVyZS4NCg0KU29ycnksIEkg
d2lsbCBkbyB0aGF0IGZvciB0aGUgbmV4dCB2ZXJzaW9uLg0KDQo+IA0KPiBPdXRzaWRlIG9mIHRo
YXQsIHdvdWxkIGJlIHN1cGVyIHVzZWZ1bCB0byBpbmNsdWRlIGEgYmx1cmIgb24gaG93IHlvdSBz
ZXQNCj4gdGhpbmdzIHVwIGZvciB0ZXN0aW5nLCBhbmQgaG93IHlvdSBydW4gdGhlIHRlc3Rpbmcu
IFRoYXQgd291bGQgcmVhbGx5DQo+IGhlbHAgaW4gdGVybXMgb2YgYmVpbmcgYWJsZSB0byBydW4g
YW5kIHRlc3QgaXQsIGFuZCBhbHNvIHRvIHByb3Bvc2UNCj4gY2hhbmdlcyB0aGF0IG1pZ2h0IG1h
a2UgYSBiaWcgZGlmZmVyZW5jZS4NCj4gDQoNCldpbGwgZG8gaW4gdGhlIG5leHQgdmVyc2lvbi4g
DQpZb3UgYmFzaWNhbGx5IG5lZWQgbXkgbGliZnVzZSB1cmluZyBicmFuY2gNCihyaWdodCBub3cg
Y29tbWl0IGhpc3RvcnkgaXMgbm90IGNsZWFuZWQgdXApIGFuZCBmb2xsb3cNCmluc3RydWN0aW9u
cyBpbiA8bGliZnVzZT4veGZzdGVzdHMvUkVBRE1FLm1kIGhvdyB0byBydW4geGZzdGVzdHMuDQpN
aXNzaW5nIGlzIGEgc2xpZ2h0IHBhdGNoIGZvciB0aGF0IGRpciB0byBzZXQgZXh0cmEgZGFlbW9u
IHBhcmFtZXRlcnMsDQpsaWtlIGRpcmVjdC1pbyAoZnVzZScgRk9QRU5fRElSRUNUX0lPKSBhbmQg
aW8tdXJpbmcuIFdpbGwgYWRkIHRoYXQgbGliZnVzZQ0KZHVyaW5nIHRoZSBuZXh0IGRheXMuDQoN
Cg0KVGhhbmtzLA0KQmVybmQNCg0KDQo=

