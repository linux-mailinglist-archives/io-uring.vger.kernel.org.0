Return-Path: <io-uring+bounces-2320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A503B91282D
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 16:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 260811F22976
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 14:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E03E2BB1B;
	Fri, 21 Jun 2024 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jh+o1wGc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LLuqG0uj"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B928DD1;
	Fri, 21 Jun 2024 14:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718980962; cv=fail; b=u4dK88lP+tlu3vTu7i2TuxTlnuVWayuEeMU932hz/D7FYEUm82BEfk4KBGiXUvbhVht1sKULUA0Z4rSJri8MlhLZAu/AaBMzmyweX3CBOtOLXbvqSDmceRQEbj9bhTBZLsSJBxPG91YTdrrhT7WYgy2qd+L11Cbd4o2c32lAyls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718980962; c=relaxed/simple;
	bh=+J4SqbO1h3HVl1Pd3I39b25kMH+mm13+sgUOwB6w6W0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ce3MakZBYPWQvDnmTEo+1AnTGtIQlVrwlj/iXBnoJw8rTa5MoO3cdpXFyWL9hPJYpGcC8cpv215mYCEHOs7WVGEFLUF5hSO8Ha1aUqm/wROOCk7yRDbRllxw0eVFB3quTIT8ACviu75osuX/lJrlEE+K0JT73pSJoToRAK7Ji6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jh+o1wGc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LLuqG0uj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LEXPaq026149;
	Fri, 21 Jun 2024 14:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=+J4SqbO1h3HVl1Pd3I39b25kMH+mm13+sgUOwB6w6W0=; b=
	jh+o1wGc4G93Sf3B8sgLtFZxJ0ExFSN7VImu+cIt6Yz/58ukVosIuJBCQveQ3uOt
	oMsSoIBuIIOjPWNnPlOAcGU6hECPmAspljsqGCaZ6nciHE+uvJ97EqhXpJXb67C1
	muePBglfGLCxJMCKHliP/vpH5UgifBnmY93A5h1qQV285dhWZA16FXsMCc8SygE1
	jbbbFAgQFoUub8EBU4CN10Rlu0dXYZp6TH/Tzj7eQHJCiBkzJBvw7eQOkSuJWQJW
	y9S324h9snzEdtmdGX3tl2HLYNNonm6ShjTDHuY5DsmB0bE71UgE08jtgxSTfLGv
	6ObUIzXYySbDtfL8BDe47w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkfsw2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 14:42:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LDNaFl023654;
	Fri, 21 Jun 2024 14:42:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn8pj04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 14:42:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrstjfB3ZWTnxgyLiPXPPs7PE3o7qDti+1DuW8MeI/PJNYiVvZtN9yESdjQ5laUXfvBAfa0ZH616au56Gh5Za07KOhl//5R7XnirXspjw30agp/lpDaFbdSRAO4wBFKsRKE4YdCaBmAOzi/EEww2+69XxXNz97VDXPDj4TMxDbNi9U2SyXjI4o9Ohk1MiqfJT3H8zAigi5btgB6Rbx3n6T/Z+PClsM02SyeoXGIeYuiMp1YyoxR2VabzjqMWFFPxfkYYK8/4LgKOyz1lWDywgncc9c7yAFtCAcoiXBQezlfIEn+717SABHpe1G0w/f3TIqKNIjGfcCfvtMHaYzla5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+J4SqbO1h3HVl1Pd3I39b25kMH+mm13+sgUOwB6w6W0=;
 b=hgTiZ92Yp/bEZrJ9Ctd+jmm+6iCIyf8WJljyErMYrae3RD39G66fa6TCq/SUuP/Oa/0eGSwINBtIbEgZX9PDC+lP3fwiYa+Lr/8KR5ykOQCvKa/i+kmIixQpKtMgCjScCpWe97Sj5LMC101RPdcdV4ljbjewasatQBBJBcQrkFFDDG4DdcWm5qCk+GknfGkn1c6wQqz0E8PT2QYRfh4KjVLAM3CFjJ+mo12eIWM060VjU/xujDhwyYzLzumF3ztmfQSZUwVZTHbHRWR1BGJdg13aKeI/mv0PjWFWo3SPeF3uENdluJ/DJAmfV9KVSVjDp9D/Mx9Ajici1D9b9YZAAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+J4SqbO1h3HVl1Pd3I39b25kMH+mm13+sgUOwB6w6W0=;
 b=LLuqG0ujtId51IRrQ6mRllTbffzPyQMZcC7RxUsLPV1khHL1thvINw2N1ZpItbdsCD/h/A3KhGYslG4GN3vok1PGlkfB8rDEiQFomfsPft6s7zqnXlPR8QOZ+o17YpOWspdN+KEuaEDCgAfHtgzhk/G1DkNMI/0ZTUkbBrkpikM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6791.namprd10.prod.outlook.com (2603:10b6:8:109::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 14:41:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 14:41:57 +0000
Message-ID: <351e602c-6af3-4d86-9c07-4a715f34cea4@oracle.com>
Date: Fri, 21 Jun 2024 15:41:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 00/10] block atomic writes
To: Jens Axboe <axboe@kernel.dk>, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <171891858790.154563.14863944476258774433.b4-ty@kernel.dk>
 <674559cc-4ecf-43f0-9b76-94fa24a2cf72@oracle.com>
 <2159f1ad-98c0-4a71-acb9-5e0360e28bfc@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2159f1ad-98c0-4a71-acb9-5e0360e28bfc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0158.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 71178e87-cd49-46be-93fe-08dc92004d52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|7416011|376011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?V2c5aHJOcXZpNHlibkRQQ0hHMm5Sd2h6cm55cGhFYzM1Sk9lUTFKM0pJK05U?=
 =?utf-8?B?S093WloxYTBLdXloUUk3OFVxZGh6YWhqaTZPcnVaeVA5VGQ5UG5SOVAvdXUy?=
 =?utf-8?B?S0w1NytDbStKaUR5aWRMK3pqWWRVN05JVVlmSGMxVzNtSDhNSUMzelVoSlo0?=
 =?utf-8?B?d2VlblNVK3ovQmN0WHVRMUpIUTZyellibnBDV3laUnRrWVBjSEFYNy9VN1VS?=
 =?utf-8?B?YVhNZzZEaFJ1MjZWcGF6bmJkZ2ZZYWcvUEhKbWNsektpVlBBQ1pNaWJzcUc2?=
 =?utf-8?B?dTl6a3JCNm5SSnpYaDFBKzZwdDJyWkQ2YThYMEd0dVNHY1FodkhRaUV6c0Y0?=
 =?utf-8?B?M1ZnTStGS3cwYjJFcnJmVUQ3cFE1N015Z0RWektxZlFXTlRKS1U4K3d5a2hT?=
 =?utf-8?B?Sm52MWsyajd2dnFZdTlaK2ZGSUhTYjQ1QWoyem1ZZVVadFFvYXd5Zk9hQ1c4?=
 =?utf-8?B?aU5vOVpIK0ZORktUcTJ3a2EvMDZSclJoeUorNXBPRjhxaTd2VEJZcHRnYlQz?=
 =?utf-8?B?ZC9zaU5jZU9ld1R6WHB2QXVXZHZVWk5UZ21JRXdFcGlYMDUxdzJBTUNqZW9n?=
 =?utf-8?B?Vy9RWFpKUXZnVk5PMWh3RWtYMU5JRU4vN2xxUFdmUlBnNTg1U3c4SWMxWFBP?=
 =?utf-8?B?Kzc5OFpxUDFwRnFJQ2FMcjYweEpHbFR3blVxci9UdnhLUDR6UW50a2ZxUTZS?=
 =?utf-8?B?WWVyTGFaQXlOb3FKSzNaeUVNN3NaR1FqTjNkVG9HYVllWXA2dkpDMGF0V1ox?=
 =?utf-8?B?N1kvZlQrQVRwZ1ZneEdVbHIrL21HWTd0UzVZbk94TlN0SmxmSy81cENONFlF?=
 =?utf-8?B?aGxvbUNmbGpocHVMRkdib1VGaTF4NXJZWUM1aXdLRGU5VTFqOFBrODVTQkc4?=
 =?utf-8?B?aWZXak5DMzNzeTQ1dC9VaEU4SUNqT29nbXdPdkpoRTlJOGdycy84T0NCRTk1?=
 =?utf-8?B?TFAySm96d1F6SVBQY2RpSnlxRmtCM3ozWnhVQXFtb0JvajdMVmdtVWJLcUFy?=
 =?utf-8?B?Q2NQVkt1eUN0cWVpb1F6ZmUxV2lQRHM4K25LTEpNS0pFTTF0UkVhaFdVNEh3?=
 =?utf-8?B?NHlzWXkvb0xHajZHN1ZvY1gzWXM5T085R1dCSHFkNUdrUEttd0Y5WlRXb2w2?=
 =?utf-8?B?MG1mbk5IczQ5aUtiM0w5QXRxckJyWm9qclYzOHIwdTdSdy9SL3BydThUbTBm?=
 =?utf-8?B?MWp0RlpRdUhMZEo0MzVzYS92NzZ0TkI0dWcvQkJJalBqdVowSGtxZkRzMjI3?=
 =?utf-8?B?WUR2WFNMaW44M2Y5aW05M2RZeE56Mi9KS1psdHJ6aHluVSs3U0xFK1FuYkpv?=
 =?utf-8?B?SGd2a3N3YVc0dkZRL2RuQXJrdnVXaFFabmVabGJEdExXM1hSdVl1YTBhbENO?=
 =?utf-8?B?bjdjdlJ6RjNOUThrNFFQTWc4VzFxYld3U3RGdmE0MC9uYU9sL1VPK2diZHpM?=
 =?utf-8?B?TDhJMlZST2pNU0F1Njgwak9IY0pPSUc3b2h3SFBsd1VEdzYwYTRNSXdjc215?=
 =?utf-8?B?T0RlR25ZVmhab045OWMyRVI5NWxsaWlhRE9KTkxqQ2pzN0NMNlg1N3VQNEdC?=
 =?utf-8?B?WnVBdDVVUmlncG5FUnM2b1Ftc1prTlQrMEE5a3cyaXE0SnBBakhuUTZpUTdC?=
 =?utf-8?B?elhhU2cza3pQWTRteTlkTW1RSG1VbU9FTmJFZjlLdWRzaUY0aVorV2piQTgv?=
 =?utf-8?B?NWI1MUZJYnVUVnRFWUl6T3labDlCSGovTTE3akk5WHhaSEY1NE42bk85RkIz?=
 =?utf-8?B?OERmdEp1WjZhMS9tVFYzQ015NVBZSFRqckRJZXFuSndXbXV5Z2ZoaU1LMUJF?=
 =?utf-8?Q?laaCUkJETAeGQmOVraU7w/oyDLRpHIAYGcDd4=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?blFZeGl6dERZbkVHSGZMTmdZblRMOERReWhZbTFlOEcxRVhSZDYyU2w5WUFw?=
 =?utf-8?B?ZytpQTN4c01QYzJhSWVQakxwU2MrampNKzk1c1Y2YmZhSmRMa0RIVEJXZHRJ?=
 =?utf-8?B?SldXN01KbEE3VU9HSHpxTURvM0NFZm1OYjhTWkNnMkhyZHoxd1ZTbXJLWTJG?=
 =?utf-8?B?TkRPU09yTitWSjhEMjFGWjE0eFZXajYyQmNtbEJWVk93NWJETGg4ZXBNWEtL?=
 =?utf-8?B?akJIclgramRZemptcmF2UmM5OTd5aGtweXIyWk12YVF4MlM3TTdqSXhRUzcw?=
 =?utf-8?B?SGRQdUlBTklPc0RhWldQeWFqWVZjNFpnV3VsYWxNVzN5UFYvUWYxZFFVUEVF?=
 =?utf-8?B?c3Rla1JZTFRkbUh6cVowQlJUWEJGcXYyNEd2NFZXc2x3aXkzTVpSanNXR21l?=
 =?utf-8?B?eURBYlNlTHlHNG1oRldVdlNQai9PZDlwWG9PQmZGdXd0ZkpmdE50NHlyQzlz?=
 =?utf-8?B?cmY1MEZIeFoxdUFva0V0TW1YL2VkVEpFU3pYc28xRDY4RTBlZzJIOUlWR2Rr?=
 =?utf-8?B?OUdVdWJCK29SVGVVeDVMUW1Na0cyVzlFZzFDSzNhYWQyc1NXM1dwWWRoZjh0?=
 =?utf-8?B?NEdsK0ZUZVAxTHhwVTJ2UVpWVzl5WnZFaWhYNTJCbzhPTi9YSTVzMkNpM1JT?=
 =?utf-8?B?ZldXL1RZSi9yQlNkYlhaS3lobmdDUysvU3k2aVB1blpDekJML2J5elIzS2FV?=
 =?utf-8?B?WGhJSUVJRG5aTEdNTW9KQnN2MlZzbmYyeFIzNkptV1hiK3lKdktsZzJGbzNB?=
 =?utf-8?B?eHY0aTB4MDJGUEdWdHljOG82QWdvbkxQa1dMNVZZcEl4Uk1IWUxjOXhteFdl?=
 =?utf-8?B?MmlYeUtMT0NUV1BLZTB6dC83d3pGc25FK1hBczBGb0R6VGpCMHppa2Y4aTVi?=
 =?utf-8?B?Q2FPZ29WZjBLNEt4TzFPRGdGU2JqQ0NETUVaNUdZRGtIOTIySnRzRkgySjhr?=
 =?utf-8?B?VlJpYXdzNWVQbFZUWDZOVUE4UFplSEpPVlZUSlQ1QXl3aFdqanFFVWE4Zjkr?=
 =?utf-8?B?aCtVVXFwZVByQzJVNVJEU0lpazhYQzNobTBHaTQ2WGFqUW1zV0k0VkUvU2xY?=
 =?utf-8?B?M2dPdml5MHk4a01mQ1FSU1NGUEgxb3V5ZkpNL015c2R4MG1iQ2ozeWx0Y2xG?=
 =?utf-8?B?T0RESjZlUS9SVEhiUGloSDg3RjVCbjQ0YW54TVc5NnkxbGZjNHNranlUb1VV?=
 =?utf-8?B?VWxQNXdCREExLzZRYndiNWlseFByQm9MZFRyOVcvSlRXNjJMVTIvc0dzRWZI?=
 =?utf-8?B?Q2dIU1l4QnBzcHkrRWJoMEVyd0VtVnZlN0RneXlzUXBqQnpsVXFJODhNQWl1?=
 =?utf-8?B?RWh4NGVNVGt4bHY3KzEyU3ZOck5qSFI0b241cEVQZytjMjhITVlCOWh5RVNr?=
 =?utf-8?B?NlQ2ZElJVFNXS3lHMUlXaFlUU2NDa3JBOHkyek9PMEpvbW9JYTRaSDdrb2p4?=
 =?utf-8?B?dGpsU2h6WERxYkoxS0dnNnl4NWIxNW5CVDNZWHVUcUJHZ3duTWpGekEyM2FY?=
 =?utf-8?B?S3luc3BoOEJIZmpkRC9NWlZkWmkrdzBQQWdsbnUrOHpVTFZFclkvcEFSWFVo?=
 =?utf-8?B?UDlPbkJxeWUxZEZsZVZuY2plZmsxQnMyTWxacnRBOVhkdVdSc0E0dGxreTN2?=
 =?utf-8?B?SExCSFd6MG9KaTF6OXdabTdPay9nYmh1VXVHalVXZENkTy96dUlDN3lMVm9k?=
 =?utf-8?B?OS9qa0NaZTFHLzdmcnFuM3FKRlgzU2ZETkZLRFNKaHo3MXkxR3FxRVZ0bS9v?=
 =?utf-8?B?cUFmaWFTbGx2RHcyYnJPeDN5UGMvRXFaaHZMN25peW5qVU93eXRSRkdFdk1E?=
 =?utf-8?B?Rkh4bEdHZUR6NC85VmJZMG90UjBXMXkxRFVhUFlyKzRSSTlrQUNjQSt3Q211?=
 =?utf-8?B?RFFzRE5hQndDOTRaRUxraGxkaDdKWDRUbmFZU2Z2S29nVG41UDZJQUYwbXpk?=
 =?utf-8?B?dithRklSZDBocmJUMitXdnFVVHcvZ2hJZlJDSHgydGR2YmkzUzNsNkVLSC95?=
 =?utf-8?B?cFMzYlZDVldtTyticU41T3B0ZW9FTmNoalVYbFhiZjJGZWZCbkNGZ1ZKMGhj?=
 =?utf-8?B?RjJUS3ZVZTJ3d3pwdUVDUFdRR0xFN21YMjFFa251QWt0TEJXcXlyK3htOXEz?=
 =?utf-8?B?bkFWSG02dFppR1VzbDNwRHdOeHlTY2Q3WmhNNjBia3JNRS9Nb3RyaWt3K0dz?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	EERYT36ryfIyLcS84zJI4pVL/y5AlQ52cEHVgXzjhuf4HDSV/gRNRsBpcBjatbsmrwdl8uDAonugUKwKR3ROdjUcfji/D9uUXDTUgdQhMI2cybM0RHSwXSw9HvsvyBm3dOrkvW1PiS5nbC0K2fLdVMdm1NHYEOKY2FuZ+oeB8KX0IdEATko8sAZDc42y+F1sOgDvdgZiqkB+liw+/EjgTyM15t/8F+7FAPx02JklNWi4CmGnr1pqkPjgdNJiiGLUYtJ65d9slX7ICV/ww0X7WNKJyheImyZUcmy6Ng7kOeD9v/px/b45sQ9gQLW4brn50cPJeR2t6qVWB9C/9jPXqFRJpaCfwbrjKraofyk9WQkH5c9tpjMOWcTPyK11sHCGOkNXS8gxkou1NqxEyn6+5ypSGhTsoDivC5k6RTbRDDFbnPi+eoI2FH8ka/WgO2lmpM3ZRnOHhAkwe6X1/I99WtxU04IGKQq9bhb1tDepc94zt8nJKp6+3m/+53L1kt4G/XAig4DuIgUb9yC0MM7gLXwCNt0kZuTpXbF7ya2bj1Afi7nP1rDLi5wmRYgDuJV/gOpvzbV6JM9u29ui4FwG5kwbQdymi58CgZWVA1Yd4Zg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71178e87-cd49-46be-93fe-08dc92004d52
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 14:41:57.6949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+DH1ugDypdCOWNSeOseOBaYIJvQdiQlyEBnS/IKzlQXPM1pY4moNa+KsOLWeV1gG1ATJxAlu7y7T4P1QPlEyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_06,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406210107
X-Proofpoint-GUID: 4x1RdYhdJdj3lGWXTu-la4sgBhzp2Whe
X-Proofpoint-ORIG-GUID: 4x1RdYhdJdj3lGWXTu-la4sgBhzp2Whe

On 21/06/2024 15:28, Jens Axboe wrote:
>> JFYI, we will probably notice a trivial conflict in
>> include/uapi/linux/stat.h when merging, as I fixed a comment there
>> which went into v6.10-rc4 . To resolve, the version in this series can
>> be used, as it also fixes that comment.
> I did notice and resolved it when I merged it into my for-next branch.
> And then was kind of annoyed when I noticed it was caused by a patch
> from yourself as well, surely that should either have been part of the
> series, just ignored for -git, or done after the fact. Kind of pointless
> to cause conflicts with your own series right when it needs ready to go
> into the for-next tree.

ok, I will co-ordinate things better in future.

Thanks again,
John

