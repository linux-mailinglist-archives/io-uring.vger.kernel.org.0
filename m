Return-Path: <io-uring+bounces-2246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8FC90C47E
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 09:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26A75B20AE3
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 07:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A2F13A864;
	Tue, 18 Jun 2024 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XUy3QRaj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vbn4zrEX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9015380C;
	Tue, 18 Jun 2024 07:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718695394; cv=fail; b=Ud4gEq8mFv886GFTX3gb5G0YfthTxpg8iNRKN2R65P7fzzRlIt9niGKWbxk/wanWOv1WcmJ1nmxm2VVmQxncaQdUlLq5y96Sr1SwCFCQipGDdyVx1idiNZN96v5d7Uk6NlCGt0GhtlNtblE/OSJkuN38AjvFHh9rTJS/+2DaRBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718695394; c=relaxed/simple;
	bh=8pnc6s/vJ6lt/kgJ0xfYPEUiuoP4cWweAO8I5yAc3w4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mht6CuaekePhR1+i260gvNuzbO2fylYN+HX4MzsheUnTqXWqgBQrRuCUfI/wv+lyi3Uw+RwnKOF/LRNRMZ126+QSrBqwMLmL+qTRd803FsnVuJJH2BchNnylAujK97M/QE3i2tYVse8y2tgawqYaCQ0b0bIVjYlJuptFmaEnkrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XUy3QRaj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vbn4zrEX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXRNT014777;
	Tue, 18 Jun 2024 07:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=8pnc6s/vJ6lt/kgJ0xfYPEUiuoP4cWweAO8I5yAc3w4=; b=
	XUy3QRaj6q2MsKb6aQM785ew+lXgpONXAJ9qAvwt1RlB69QBBHnbQxuvULuPd+ou
	MQ7JhjnoJ0evYJ3njZqgpJV1mXATLsvaLfF0LGHt+RudDhX+qjkEcFtCDDIs885c
	YZKI2O3Ui3iab/GfhQpFiLxbU7onL5RAdaZukUqMvLBVKaVq9e+iGjvoxsc4Aa9x
	cbvcWQz1sQt/D5RFFvQqBiBUMzwEnrhx3yNFtWlEdA/cSCLIVkgvuVCdEoxTH4iF
	CnjTownUmS5CAunejrMADs+vkILEdbZuyZOSLCuW7YJ3vafkXxDR0gWyRMaedD/L
	zJJ8GeC+1HLaCQRoF/vZpQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1r1v9w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 07:22:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45I6SYiK014806;
	Tue, 18 Jun 2024 07:22:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1ddrjj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 07:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTI4TeQZd9MbZhAgco0h+/WxrSwMHuLhA2mDztbhndnewutD7B1XDP+NvD22fA86NfBqP/6mkHO5AwqWH9Oc6vtnyywqGwLjLNApjyw49XeJ/o8GUsiFOJ+7ZF+1+GnSwerA65ItZEuw+2q66a6gC2ss34FKoIo5EHz6thfzwJ1xPofhwwkudMmOluoARaITPwtA3fydsNY+pL71YHUEOEmOejY4B1xBi19nuRjwCBojgV1hdMwfFFMaObte2fIgTeswV8t2neYselLobGbNf/WNGVAvM2gac87axq9TDUgbPO3RobqaAjcVuR6zIyq+Y+aydZibmt6rGAz1jxK8Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pnc6s/vJ6lt/kgJ0xfYPEUiuoP4cWweAO8I5yAc3w4=;
 b=dLaIfAj4aNgb/15wPmNx7BlRyKtRfIHsBQINJUwhlobRyyDv4y63XZ/34qqUPzaynTNj0m0O4RfU5JP7omppUeE1D6IJhB4gh1N64jPWZsUOZNkldONkfbq/zfDad8tBNJMU1zexg+JSlZ7IX+Uzf5Iwp9zELVNbCE9FsZ40t3vd7/mdEOMGYyXM3zD0gwr+SnMES65dR4bvhNhdgkv0R+83lo3YJGfC6rFC/rJCkmQSAHzPhDKDUUoqwu/fcyA9fX8Ai4VL1x2BMvyvJh86pNaI03bIIfqdck1W9MU86CSMp4AKiZTAC4ajGVxVMIH1uKajSgWnrvJYuuEV4Tz7pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pnc6s/vJ6lt/kgJ0xfYPEUiuoP4cWweAO8I5yAc3w4=;
 b=Vbn4zrEXDZsXkBvgZw3CW0o6qNDHjCSdlR8fyMWHqtaKok0721NWecVQmWfgm+1UZ5ouk+b/24OgFJWzYaThHVI/P2ew9UuJeYsX/7mVx5ZH7uDXjPVQ8dJKVd1/AkU1OO8/eNIqWtpIsr8gIrnvBDMgTW4RYG8uP32QXCjmAQs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 07:22:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 07:22:10 +0000
Message-ID: <b1988e22-c472-4de5-97ce-1f977df56605@oracle.com>
Date: Tue, 18 Jun 2024 08:22:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/10] nvme: Atomic write support
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
        sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Alan Adamson <alan.adamson@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <CGME20240610162108epcas5p27ec7c4797da691f5874208bfcfa7c3e3@epcas5p2.samsung.com>
 <20240610104329.3555488-11-john.g.garry@oracle.com>
 <faaa5c15-a80d-339a-d9dd-2dd05fb26621@samsung.com>
 <2ddb92d2-97e8-4eb3-9c76-8c5438bb2a44@oracle.com>
 <20240618064907.GA29009@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240618064907.GA29009@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a6fea77-3c9e-4459-95b0-08dc8f675dfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WktkbnUxK1U5TTlkMDRMcTZkdWg0c041QlRRRm9MeWZEdkt2QUQvem41RitO?=
 =?utf-8?B?UUpUWE5Ya3F3RWlFenpGUlR5N2RacEsxVm1tczhvQmNQNTFncUR3ck1kV2FU?=
 =?utf-8?B?bnlaSnd2RFFETk1ZdDN6by9lVzNrWWJXRm52RlliR2JPeVdXUGNrRXhIdkhj?=
 =?utf-8?B?VEtWbUltUytiODN6eUpwZ2taUGFGQW5hUUVJaFNjYWlvaW9leGtZc2VaVHNF?=
 =?utf-8?B?RnNyYitGK3BDOFQyaHc5dytaLzc1aDh2S2pVL1Nram9VR2wwZXpqVExnQnZO?=
 =?utf-8?B?VndXbysrUXpzSzljd3F2S0lQdGlqc3kwOGZ6RVlxUUloYmYxYW1paVk0bmNZ?=
 =?utf-8?B?U0k3d2pZT2lGNlRwNnU5WDBPdmZyT0xVRnNaRXZSa3BaUXZkcFJXSVVhbmpl?=
 =?utf-8?B?alprQnpjcmQ0cCtncGRaZjZ6c3F0YjZGYUs4Q2h1Ri9wSWlTa2RxREZHVU1D?=
 =?utf-8?B?NzV6c3Q2dGVLOERQL0NINzhFS2JycW51MGdqbHU4VUdvSkZnbzdRK3EwZ3V5?=
 =?utf-8?B?dU5rL094MllwR0V2Ky8xZ1p0RVNsdWZvZ1dkc1RxVVJJc0VJZitxUnR1RnU0?=
 =?utf-8?B?UUluaC9EdGtKWGdhUXI0K0ljd2hGWnM0U1pYeUVldUthbmpmQmNwZ0hnVDdD?=
 =?utf-8?B?ZzNzRFF5SkF0SFdLWVgvUzBGOHcxaWd4aWNRR3E3L1B6YjgyVVpqNXZjNmVM?=
 =?utf-8?B?YWxkdDNkTnNaWVlYcXlwalJLWHJ4K1BCZytheUZqNHBISWxrOUFiTXllU2JN?=
 =?utf-8?B?dVRxSEFEYlloWHJMMGlFd2dVTHNNVjZwQURNL09UbENNOVJ3QVdQVThEVml0?=
 =?utf-8?B?ckRFa0d4MjMwa0FoRXFPd1BjdFhzTnRsY3ZOcUNzZXdqdEN4Y2ZOeVBVc0ZT?=
 =?utf-8?B?a09pdFNOZ3pLMkxKSGQza0xBdndWREM3UGhKSks5VHhVd0dQcnY0WW0yZEZI?=
 =?utf-8?B?RHF2UDh3S0pXYlB0N3NKVHlrMGYyL2I2bXFaRnVqWWNGdUppZXVTR2FBejJs?=
 =?utf-8?B?WGQ2a2t2SWsyWmo1NWhVbnpOYjN6TUsxdmlIYkRuemZkTHNYSGlGR1JydWFq?=
 =?utf-8?B?N0xON2UxUjJmdVhjc0xSRU14RU9tbWQvRkJjMGIvNENMNHNRNStwd292bW5F?=
 =?utf-8?B?OEJvbUJEZ3RYYUgwcnpwZmNiOTNpQTNESlB6blBibG9wc0FCUm54NE9vVkxY?=
 =?utf-8?B?dG1vanV5RytyOC9VS2hUeU5mcVpXSzVCNkpCV05CeU5Odml4L1RNY25xNTNq?=
 =?utf-8?B?SU1DTGJ6VmZuK2JiNWMyUHlPSlFJQVphVk5pcDBaQmNUV25pVzV1T1lTSVJO?=
 =?utf-8?B?c2liN0hXa1BQeGx4VVU2a1hFTVFZcFFaRTRVQ2tqaytiaVpxaG5ZMFZrRkR5?=
 =?utf-8?B?bkhZWTY1aERXMmltbk96bWQrY0xWK2lRaWpseG1GNGt6WFdjcG1NUkdRdVI1?=
 =?utf-8?B?QzhzSFV3eUFwczZyeTh4S3dkQm94enAvZVR6bVFCT3RrUHlrcWh1c1R4UDJR?=
 =?utf-8?B?LzdCSTdkL0l1MVJZcjlvR3dxeVFYcGFzRGtJaG5oMHJRQy85RUV0R1o2TllH?=
 =?utf-8?B?QUtmR1BvbHNaSXdNc1hJQTdWWGVMZGNqbGtCSnlnVnQ0S1RCOFNOMlF1WFdy?=
 =?utf-8?B?NDg5RkZHcmZYQ2RNdGF5YUFUSWY2ck9yNTV3cFFGZWdWNHIzUTBQZDRvNC9a?=
 =?utf-8?B?TksxSkNNanNHUCtuY3N6dWxPYTRxTlp2bGo5cUlnZjFITWxGZWIwQnR2ZEFr?=
 =?utf-8?Q?ojEXGkmxZPCDvH+jB+SAQcNbOGfb/O+0eeXYEPK?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QUZHV0xjcFl1YzIxRlN5SUdpUGFKTFA1R1N6SGtLdi9TajU3T0huN3UrWDEx?=
 =?utf-8?B?ZVNnVXV5ZG15QWdyZUMvK0c2OEVaRmlkN3dLbGFqQmlISWJyMmQ5cnEvUmk5?=
 =?utf-8?B?YmF6SGtESndyQ1JmV2RPNTdBTktXMnhaUWZmODF0UGY5QndZZDgyMzVDQWlO?=
 =?utf-8?B?T29Ic0xGeFBrZ0xaenVzemRjTDhpalNNVVFvREFnTmdMZmw2TDZxQktaZzRj?=
 =?utf-8?B?TGpRdkRSTzJxcW5QZlAwMjFPVmM3ZURGNm51Q2g3dk42TTF4RzJxSVcyZEhv?=
 =?utf-8?B?QUdwUW1jblBvMDhFNUdYN1creTRyZy81Wk9DSmVISDd4aUg4TTQ4ZHVyVzFz?=
 =?utf-8?B?ckhuVTl1U3ZONEt5Wkd1OVlTSVA0bDNpZlBZN2JRZ2xPVFFwTFJsblZJbTk4?=
 =?utf-8?B?cnFlSGttRXJDRTF2emQrUHBCanp6T0pQV3hySWdFd2ZFTzhxSW9obndJdDlr?=
 =?utf-8?B?eEdsd3llcHM2OENVZEV1VHcrUXFoWW1yQ1QybVFYWExiQ3VBSGhvek5tQkpL?=
 =?utf-8?B?MUNZWDh6ZzB1NzVrK3RKZ1FwblJVZ0VZZURtTzhzSllpTFZTSnN2YmRzOCtJ?=
 =?utf-8?B?ZzF1Z0lrVnMxQUEyTmdVZnlyb05RdDB0aXovSnVXT0dodGQvUml2UDlWSVpw?=
 =?utf-8?B?T1pHUU13SzJFSjhjeUxuWEVFd09WaEhGWng4UzN5c2crSURmWGlEZytqN0xT?=
 =?utf-8?B?S3FlTHMvUGQwNVZ4MkZMYngxanFLTWRKTWQrWjRSUWVidmRRaDBoTHpyeWV1?=
 =?utf-8?B?ckVObGdlcWU3S3dEYVFsanE3R2JDVFJzbE16MGdWTnRuMWJiWEN5cko4bkhW?=
 =?utf-8?B?TDY5TkdTTkRQSVVIZWxxdXlQWXJWR0NZczd5N2dNVzcxL3hTRURwMFlid0JD?=
 =?utf-8?B?ZVZhaXdIZGo4b0pQNVJnVTZjSU1rVGkzZmRjRXF3eXhqZDNXei9nVnpjSzl6?=
 =?utf-8?B?RVdWNnRzSHFtWHNuZEJ1RFV0RXlha2phK1k4RkV2T204bkgzc0Q5RWZyYkJQ?=
 =?utf-8?B?TC9FazNFdFdqY3FsRWRUL25BcWNSN1dFTzMvWXI3K3FqbzZXSzNuWkxrT2xp?=
 =?utf-8?B?Q05GRkV2ay9qa1dxdFQxdmxpYTRkSEF3YVJkMXVGeEJzZzlLN1MzOFpHR1lv?=
 =?utf-8?B?dy91VlBWVkRWRjBKOTFINnpmQVhQVmpYSG54UHYrQUN3Z1ArK21aTGoxY2ZF?=
 =?utf-8?B?eUpLNVZXVDJlYU9XMmFiM3g1NjBlbE4vN1BrU0JFa00vZ25HZWdqWittN3J4?=
 =?utf-8?B?WS9aN1VZL25PWVlzTm5Ja0Y0emwrTTBmYk1qYnVHd05uVmxJb0tETUhLS0xL?=
 =?utf-8?B?WmpCZm8vL3VjL2dlM1VoQ1RNbFV2ZU4wMWdHVGEwcy91NmpXWVYwbE4xS2U2?=
 =?utf-8?B?R3dDbVdSUURjYm1ZSzZ2ZmhRMEJZQU53bkt5RDFnV2RJcy9YVnpDeDdtNk9G?=
 =?utf-8?B?aWtBSFpFVFF5djBtOHg5S3ZxcVpVQjhzd3lKTE5Rc1U4bU5QN2dpenRyWmF3?=
 =?utf-8?B?VzZpcjgvVWdpZ1dhUElYMjd1emxNMjJNd1BRaGE3c1NPUXpFdkJWdGJZUmVu?=
 =?utf-8?B?bmY4bmdTQlA4Kzh2QUQ5NGtNUks5WGxDdlhoSFZkc0QxRzIvVlhzYTQ5Tlhs?=
 =?utf-8?B?cExMK2lkNVNZWXpGWUU4U0hFR2FMenhVUFJmRzkzNWY2Z3AyS09GV2EzTEJy?=
 =?utf-8?B?WDZQL1hFci9jMWNLNnd2b0JNc24wWGNrR1ZGWENRbjM4eFJBZFYwdW9SSmF6?=
 =?utf-8?B?clh5cVhkRjY0bk5JUkxWbFd2bXArWHFLaWZrOHlIYlJ4Q3JuSGxFZ0t5Q3R2?=
 =?utf-8?B?ZysyY1B4MHY3Y2l0YUpHSDV6SWJtQkNucHJVK0Z4SWxoa2lmVm45M3NuR09Y?=
 =?utf-8?B?WDFyM0hQbDd6TW1HZy95OHlDU2FqaDNBaWU4clBmNmN6TTNuTVJEVklzK1VP?=
 =?utf-8?B?eHFzZUpJM05sb2xYZEUxQkpseE5QVDlwRnE3dW50dTNJMTAzaE5wQkZsYVho?=
 =?utf-8?B?TVpHK21OSlF4Q2FyT253NW92ZlpoTDI3VS9rWVBRZ05sTVQ5K2Z6dTVkTzYv?=
 =?utf-8?B?SmxOQkRwZHhYUUZUSUlHV3JMS0ZLSWlkZU05cEN5eVl1K1ZXTE5EOE9qUXJi?=
 =?utf-8?Q?IwSTyOuiVokbulCgyjyYv9Emu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	u+e2Feu25yA2yICuukmV2OZJkbFK/i9IgB4AhK/V3ox4ct2qS8msCWYeAXy7wfBx4vxaF/hberARpy05PMVFsQY7FitCUDWzpCGhx6ogf4c7AeZQuDTtKz5Gb6E8WnAlY3PHzi7FbxG3RqYWZ5XkLJi0G8Qtg4W4M5ajbne4l3MsFLvwvcoU+GKpCg88hq55/4ng/OrdWScOZDgotp0xtC+jrIOcAIlHTSE+z5WYD3BKTcxNQ4STPV/37LY/zdIu0xyWYaXIHLpHW3fQvrSxVa87wA+7NFAaDd2SIKdUTpvXiw5a1pp8dIIejNivLqRmXh5za0/Zb+FvQ+XL5cAfpF5ELZokh1tkQ6Z+u8o7SK7pjzM674NN5EZ20KnOOHF0uBP03R2dwtehNPABL22Omn4pOfI+LswEx2mS6Ml+1jHNK9Vp9k8AN1uVJFApFf8BRV9ZigsnmP7KDLC88eyxmlibHbo3iXKZWUerZGPJOHKBDCtevFRJwCAX1SMmizmeWK9oA+Rq7TRRHtGx53xq2E5IxQaE+OnkdUU4e8vzwubZH5LVg29RTa1jpxyuIEVdS1NPNGdy7CRv3FaGmVe1nNyQosXuqv6F7eCwT4huaZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6fea77-3c9e-4459-95b0-08dc8f675dfe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 07:22:10.3738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TejWu2NOfUEMLravb3AGHRVSUY5UjAPsqiaCsthXb5FiqbUhlfCgfaTWE24FIYLMYnSekT12blGFmS624aaZbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxlogscore=677 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406180053
X-Proofpoint-ORIG-GUID: 0L_BLnQ1kjvU4kUf-aFK1yf-Vb3Da6tv
X-Proofpoint-GUID: 0L_BLnQ1kjvU4kUf-aFK1yf-Vb3Da6tv

On 18/06/2024 07:49, Christoph Hellwig wrote:
>> Only NVMe supports an LBA space boundary, so that part is specific to NVMe.
>>
>> Regardless, the block layer already should ensure that the atomic write
>> length and boundary is respected. nvme_valid_atomic_write() is just an
>> insurance policy against the block layer or some other component not doing
>> its job.
>>
>> For SCSI, the device would error - for example - if the atomic write length
>> was larger than the device supported. NVMe silently just does not execute
>> the write atomically in that scenario, which we must avoid.
> It might be worth to expand the comment to include this information to
> help future readers.


OK, will do. I have been asked this more than once now.

John

