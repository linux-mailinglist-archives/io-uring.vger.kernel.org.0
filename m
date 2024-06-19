Return-Path: <io-uring+bounces-2271-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8493D90E888
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 12:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECD71283F29
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 10:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C1D12FF91;
	Wed, 19 Jun 2024 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P+dMa48j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oUl6gGp+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9507085626;
	Wed, 19 Jun 2024 10:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718793803; cv=fail; b=ebYb6ykpaaL0ni2cIDu4+CSVXDrKz/DSX8g0JYSaQxNQZ05kEsFjojEepKkd5/hnAw7ZzvYY12cP5Hgw/ImtHqGMv4C3CQwcHkb31QF8WuGToPdNc9Ms9P8YVUow8TV6xHMMKLvRojX0ExnMDQ1ofGvklUXHwck6CS8AnemcmmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718793803; c=relaxed/simple;
	bh=yO3iEBu+KSuq3cwPyD8hjrYpE9Rp6E0yQmGfBuKcRdw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tNxBd7dHQkZQsEu2U0ipRrGcw5+5VjSqvnM2hWv30PciF+lA+GfJqvRFr/xcgT7217g+8nRM0S567BWgp1x+oenjc5uDUF0s9EcFl3SRxr+kpxFuM9ff/HfajBj3NMPJrnBkxGSf7mpHVBJb14gT4qQq35DzlPQx1hRxhMVKC18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P+dMa48j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oUl6gGp+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45J1tghu031358;
	Wed, 19 Jun 2024 10:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ftfEUaIKm0Tsh7fUoCiiyfBybImwCNphALkd+X2ScHA=; b=
	P+dMa48jqnUEzO+3ZsTqfLcr9aDwDli0X2cJ7i/ZE9myGJzvRv4TkKETBtuJkxkL
	KUMva7GfZixOz//oJwBZFN1NYAaRw0ALhxzuCTETqqhkKO3aVSYtnca1P6gn2zJd
	6XpbNtQeXSCBVlkifUZL5hUAh4m2PfvoOPuvkyaWme+p+K4PY6DUrjCgRL467QYg
	kcLZNPQ7FzHsv0VC8f8G6jBWuf/zjcrr10IxvopIi7raJpaZxRp7vDqdqSl3EmNt
	x6B6qxOY5+6X368arA8o6k4xo/0qgin2IX/q9w0RUIXhSWYv+JMtxuIdeBSR5n7W
	XtnsHLnNpwEcDE+n5yMY5Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuja01062-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 10:42:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45JAZGbI032823;
	Wed, 19 Jun 2024 10:42:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d957nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 10:42:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAbLkX7KnWZ87os7wvBFTM9qGOFo0mdw/4hg/31UnykLJOQESdAYFDDOPU9rx2NZdFlJ+hRdd1R97kV5dPaHxJM/Q4rkZLEJ2K9CMPZQiutzqok4zdt+HreK43WKtZmsuMCFNgiiVd7WeUsASWUbzeiMhJbEW6KUdowb+WnRiJ5haSwzo9p/onNCbrpy83nbQaXhQVwhxCsV9fVbhUY2cGijWnAxBUhE3dHv365mqT9BFWkjiRkMcjmokM2lxnSsl7kKGC7sGdll641whP6fN3uStzzN6aeYud2ahR86N7mT8Zu/+bZBi0KNSB1zHqo6qFOZtcfO60FU0kC9uRnbMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftfEUaIKm0Tsh7fUoCiiyfBybImwCNphALkd+X2ScHA=;
 b=fzMeZ3ufqRS9O0Wo3ST/vs1LLF6GerkP8Dix/7tnZVGFQFP6e6Qrt6S/kI1k72KnWkpW1sV5DxIxOvXGkNqTYC8dHl8T39GsDMr+gUspwPxdcNe4jx99pbJ1DJWYk96H6HfhIYhtClSVDkSzYwlfSH42zOgb3ewHSfFZF5xF0JX+oog5YSnXZlOyftq1DV19x/Rjmz0Ew5moKosKNCN1T4g+D4L6LqX1CqiXGchlHflDPG1g3t7bwzKVzr6A/ugsPJh/HsuF/oSocJQfNci8aDQlycSbrKBtdIh8DxAihw4UNbsmeJpTDVYdHIA5An9XTU/KQnbb4eANj08hN7h0iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftfEUaIKm0Tsh7fUoCiiyfBybImwCNphALkd+X2ScHA=;
 b=oUl6gGp+UaM7ze8OxJjpaRHazOjjgGg34b47pZ+SlNTDWA5toskaCa36okwZvKscPKhkzaPXFpAewcQjn+CV59TFBUN51n7L6jzPd4XXT/fIlzoxsa6ilR1brGS5Mb2czHh0FMA2e6InYrlxrsh56DLh91pS/ffEmqY/7UxbcQc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4685.namprd10.prod.outlook.com (2603:10b6:a03:2df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Wed, 19 Jun
 2024 10:42:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 10:42:38 +0000
Message-ID: <5bbf9ff5-83b0-4e93-82c5-f1207d30de9f@oracle.com>
Date: Wed, 19 Jun 2024 11:42:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, axboe@kernel.dk, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <20240610104329.3555488-6-john.g.garry@oracle.com>
 <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
 <20240618065112.GB29009@lst.de>
 <91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com>
 <ZnHDCYiRA9EvuLTc@kbusch-mbp.dhcp.thefacebook.com>
 <24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
 <20240619080218.GA4437@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240619080218.GA4437@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0005.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f5565f-c2f9-41c0-dcb7-08dc904c89ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?LzVXMGUzelF4bm0vWXJ6dlFuRWVid3lyaDZpRHlwUmRRbVllaUt4S3p5NFBl?=
 =?utf-8?B?bGpMOVV2RWZ3UWcvdmdXWU9TRGFnaE4xNXhOTTVGU0VDSGNNQXNzVkVmR0Ex?=
 =?utf-8?B?alovMXpJWmdFWnMxNUNCQW5TZkNFYndZQ0c2YTRucmxGaThxZGNkT2Z2RVFs?=
 =?utf-8?B?YUpvbUNCYkZYTC9OQVpkalJUN3IveWhTenk3T1hpWUNXeXZNMTJSOHNheFhm?=
 =?utf-8?B?dTBJUkJGaUhzVnZSMFJFT1BmT3k0ZEVqZTA2cXJnU0swd1JGVHVBY1VUczEy?=
 =?utf-8?B?VDJhd09ZTzAvNXdtVGowWjlGUWRycWxGVDVDQ25sOGlCY21oQmlDZ2t3UWhN?=
 =?utf-8?B?c3RTb2x6MVRxUzQyMnUvYWtuM1VaM2dsSTJXNSs2WW5rVFQ1YUhJUkpyU3R1?=
 =?utf-8?B?YVhLWXNEMEtpRWZKbE84bFJneTc4MEdLZ0RpY2o3R3JQMzRSSVBRdExPbzBC?=
 =?utf-8?B?NUE2dnZjUFRtcVhPOXN3UmJwTlR5RnJKbXpKWmdLVkt5bDg5YWxrd0RsRnI1?=
 =?utf-8?B?Z09kTGtndFdjazE0THhlVCtlOXBrT1JmdHVuUEdaNEdzNWdZcE43bzJZKzRU?=
 =?utf-8?B?V2FoZ2dFQmRHcWphL1pvL0VIcTg2Z0JlelBpcDNpdGVFZ0Vxb2hjeXlLZTdP?=
 =?utf-8?B?KzlPc0c3UU5oa25SYlE2bVJ4OHo2aHc2c0lnNG0zRmdISlRId1dGQ3J0NEJG?=
 =?utf-8?B?aGwwUTIrNnRIODZJM3pucHJLN1MrMDFQNkE1ZDZ4ZlBFcncvSTBVcDZMNDl3?=
 =?utf-8?B?cWp2bXNjOXBQWCtWcEhabXk5MlJKek1YT2tNaktQNzg2ZGJBQzFSNkRJM1Zr?=
 =?utf-8?B?b1NPZ2ZvUDR3alBVYmZTbE91V2VrdE9UcStObDJiYWRGUDErRnhRd1BMcG9t?=
 =?utf-8?B?ME1SYXN0YnZYaHEwZ1hGL1pUaEdWMFhhZXZIUUJsd0xtcndWemRqbmx6UE1C?=
 =?utf-8?B?ZStvRzNjUEd3aEk3OGR4dzZoM24rNTFhVU1aSjJnQTJEVXNodEdwTjhMd0pW?=
 =?utf-8?B?bmZIa2YzKzF0aG1kbDNZdjcyUTR0S29TQis3elA5YTRYYzhFMlJQaDI2K0d4?=
 =?utf-8?B?QXdjYlQ5bDZ6c2FWZ0dacVZkckhHZldReHlSWmE2cU5uOGhNWWNGZEd4VWdN?=
 =?utf-8?B?Y0xTMVl2RnJqZjJCMDFkNm55b3M4VVhDYUR1cUtOK0NQWXVycm1HS1BSeHhj?=
 =?utf-8?B?SjNyTW1XU3J5cWRtd0NCaU9JVEg1a3VKV3YzSUN4VmVjRUZTZWxnOUIzQllO?=
 =?utf-8?B?cGwzMk9LTElNbm8rQjIrd2hMV2hMTjlsK3p4ektPUEJhVTc3OVlwbkdNZzMv?=
 =?utf-8?B?K01LekdET1hEdWp6TmlaSHF3L2hKWHZCcjJuNExCaWljOFRZbHlZdEtvb1Fu?=
 =?utf-8?B?VWVWRHNRVXowRHRmUUdtS2tEaE0vMHFsRklVa3VyNGFDUVA2S3Qza1Q0T3JM?=
 =?utf-8?B?cmxZVnhaRGpCK1czdUZzbk9Xb09ITjNKd0o4S1FxS3RxTlZmMXlBZUJjOUdj?=
 =?utf-8?B?NEZaS1dkK3hIaG1BbFlzZ2hCVmhVVEhVbTVsZTVlbjZOTndYVm5Td3hocHc2?=
 =?utf-8?B?VXEwU3VVVUp3NFkxazg4bG0yUlVMbFZoQTNNQllmVkpLeWFSQXpHNlprWm9m?=
 =?utf-8?B?ZVhpYktNM21XTlFXcVNhaUtiQWY3dmVHNE1BRE4rT2ludFhValZxMW9wQXps?=
 =?utf-8?B?RWxRMHJBTU8vUk9EU0VKN25lWExqVGs3Z3dQVlJrZlBxSEpWU0tlTUFaRTg0?=
 =?utf-8?Q?DDvjo4WT2SmkOLkp24i4BjEQUQZBJ1Lvff5qhSk?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ODlmRGY4VGcrNWxSdVhkWkxUQ0VTczJHdlBGWjhSNTVCd0lVV2pQcCs2dTdp?=
 =?utf-8?B?R3RYZ3A5dWxab0lnVGNmUmNNQ1I5cHRxMW5Dd1crUmRMQUdSQmVPWEd4L2Rh?=
 =?utf-8?B?SlFGZHVIVmdzVTc3Nlh6MllJV01VTWVsT2VBZjBlVlZnRG5oYnZGM3RuYXpW?=
 =?utf-8?B?aVNMYTVYaHFwQitNZDZVdFR5ZDlDTHlISTM5dVVic2JPNTgyekxxckwxY2NJ?=
 =?utf-8?B?cVp1RFZXeit5Zmp0UFF2aDQ1TmZjTWJnRGZrRVptdmZYeTlvdDZqYXBSazFv?=
 =?utf-8?B?NzMxSG1ZV1FWdUJFZlhicmRLOWl3Y2tXN2JMY0lQSUZlRmZUeW9kcGRhVWtr?=
 =?utf-8?B?QzMzMHZzRmxQam83RGo2Zk1GdWM1VmRobThyRjNYQ2JiSnAyaGJ4TmpmUG4v?=
 =?utf-8?B?b3VBbk1KaVYwY1N5bFdSS01FalB1eGxsbVh5bXVTWDJvMi9QU0taejl6SW5x?=
 =?utf-8?B?ckZ6YWw5WDFUdEdlYmpVS1VPMXA3QkNhSmpKQklpK0lkaGM5VjFCVVNKRERr?=
 =?utf-8?B?N2d1eHRaaEd3Yk9sM3pUT0xrYm5WM0UzL2VMV091MlZkVmphZ1hqWkJjeUxG?=
 =?utf-8?B?MjUzSWlmNXo2bThLQVpuTFNCKzhlNXFiMGNYTnovZmdTVVZUSXZDWUVpV2JR?=
 =?utf-8?B?cGFkK3pVQjNmaVozK1p4R0hBQ3pyYVZxa3dRaGRKdktPMGpHdnlsVk9nY2tE?=
 =?utf-8?B?ZkZxQzRuZUI3dEJReXZubW1Pbll2b01IVWd4RU5kSWhIZnlNaUxYOE53ekZ0?=
 =?utf-8?B?RHZKbll6MFNFN0I0dEpMdlhxMGtKZW1raFhZblN3WGNVcEFDVE1vbWlwK20v?=
 =?utf-8?B?K0g3TGYvU0tKRWlEbnhFb05KWTBhV3FuZXcyRDBjYkwwa3lVTWRaNEhGcldF?=
 =?utf-8?B?cC9vZ1poclpnQVkzajlYSVE3anFzUStzK3gwN0RIMENiZ2pwQSsra3JZNERi?=
 =?utf-8?B?MUFXQlhCMWdjZVNPbkJIN2dwVjlGYlRvbGNyWklDbHRKNGR5emt4elZwNVIr?=
 =?utf-8?B?cUlKTU9zSzhNclllY0dUbGNXWTN3VG1pUXhDYlZRL2d6WWM5SEd6ZzlZTGR4?=
 =?utf-8?B?R2N5dU1PcG9MbGRjbmM2Nm9YRnJzOW1adlFNTUZkNmJ1NlVVZ3RvWEhzSnYw?=
 =?utf-8?B?UU1ucGNmdVhzMlY0aGVYVWNmVjNsMjA2YktZclNMeFN3Y2I2V3BMNWRYeFlm?=
 =?utf-8?B?VW5RekRjZzRGM2lDalozaU5uQWNYTnlrZm9Xd1d6akhRTEIvOW01cVRXY0Ry?=
 =?utf-8?B?ck8yWDd5Zi9PUU9xRWZCSmcxOVZ1SDM5bDFLK2wxUGhCRVNDQVZ1bkNNOU1T?=
 =?utf-8?B?RGFNTG42N2R2YUlKVG1peTZVRlEvTXRSMFZuQUx2KzdxSWVobFpFT0w2cmVG?=
 =?utf-8?B?Y0hyZURuNEpjVjRlSXRGWi9CM1RUbVRyRzd2RWFLVnAzQzR3bHF3VjF4SjM3?=
 =?utf-8?B?bXRweTBTZlFWdXZIbyt5SzE4Zy9CS2xGUkxwQU9rZGFieWpSaDZhMU5GT0lK?=
 =?utf-8?B?QUVDMDZkdmpzeEcreGs1M1VERWE2NDUwUU01MjZIQTFPamU2YWlxdkpROHpp?=
 =?utf-8?B?anh2MkRkUENjZXlPN21uclpVWS9HaCt2UklJYWwxVHJxTnp3MlZWeStoOUZ3?=
 =?utf-8?B?VWlFTVVxUVJRenFNRFEzY3J2K01kYjY4anJhbmsxZ01JOC9ERmR6RURXRm1G?=
 =?utf-8?B?R2M4TTJrTGtNcmVKSmw3TXF1NjdzWTQwR2lTYS9SODZzU2VlSTRIbVQ5bGNv?=
 =?utf-8?B?S0J3R0lEZllGVHpILy9RUndVT2o4c2g3UE1tclByREZFUXYwaHpwbE8vZlFv?=
 =?utf-8?B?MkEvMm9Lbmx2VzlXSnVtc3l6SUd1TkZiWjVaZ1E2T3JUbUNhM3kyMWh1anUz?=
 =?utf-8?B?UWpjNUFJSHR0SW9uT3NRRC9pdjZCOHJraFNyMzBNMWFkMVc4bDFvaTBKQnRt?=
 =?utf-8?B?V0k5NmV4ZXRuem1GalkwSC8xZXlwZVc2ckNsRG1idFVlSC9kUG9YaTZJUmY3?=
 =?utf-8?B?cVBLTkJTaGg1VjBDUmV4dGdWeGU1U1AzQS9zWlpwQnNNVE9UVytMMnpnekQ0?=
 =?utf-8?B?VEFWcXUvd3RKVkxJeVRLdmYvY2dVSmVWNkh6YlNsQkYybTBmd3dPL2xlcWxT?=
 =?utf-8?B?RkNSY0lzbTJ3TVc0c3Z5RktTQnkvUnNmREszU3VPV1NtZzVVd2dGeU5XTFdY?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	khBv4eEmfls1okw8eE5lTRyMIGQyar7xFr3G4PfgIM143hHl/zZhc8fq6XwRHXr5xKI9dCVFEHFIwnIcTRzMbBENaaRNu28PJV5xt9xuP1T7Zjw9jwAWGdqRDSZkURUMXwwxXcwl5yjJMzCWVkz/mKSkYVJrXX+PhYTyHyGg7zgIHrjYFc/5x6T3KHsnSR3FVQSVnSt8G3uheYelEV/xw9LcgJNzKurs31af4RmJaO0GaZrCwRepmxJIQ/+UFP80IZmVwmkxbgg2b4dvDNClWGYYFxivdnjHkK/6oxee0ibvT2XLLpmWfeMUgEcWnkYpMJzYFtbzEl6PEn2pSbm0WpOwbllua6jsUnDRMYM6E8oOsa/bbIWBv7dhXE8ltaV5sZxh2gvHM/jQFidSpKC4cBC72sKjp+O7Dn1BVvIuY8QPQdcX1W+zIofwCgW+pFzIeCanZMHRziAMTrBHJ9UfkuHJf5Q1D9Izg9n8BKQO5P0OrqYsAtHxeNcmLfa8zyl276P9rhcrv4URPPhbkh0frLGWCjjPjdItn8etk3a2j23jK/1j3qXpxU9zENh+PaPIZcEcNgJnGmfqQWxmub7cErk0H0Ajo42Q8IRf80sPsZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f5565f-c2f9-41c0-dcb7-08dc904c89ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 10:42:38.8165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55pwxG401yu0bvZicgAm2ynBVFGGWBoQLHG7wsagf2VHqan4IMU/tXkkSigLyLMNhL/iPJmAPThhlv64kIiw0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406190079
X-Proofpoint-ORIG-GUID: CyqW1w6skufbaugw-UiSL1rGb2PQ88o-
X-Proofpoint-GUID: CyqW1w6skufbaugw-UiSL1rGb2PQ88o-

On 19/06/2024 09:02, Christoph Hellwig wrote:
> Wed, Jun 19, 2024 at 08:59:33AM +0100, John Garry wrote:
>> In this case, I would expect NOIOB >= atomic write boundary.
>>
>> Would it be sane to have a NOIOB < atomic write boundary in some other
>> config?
>>
>> I can support these possibilities, but the code will just get more complex.
> I'd be tempted to simply not support the case where NOIOB is not a
> multiple of the atomic write boundary for now and disable atomic writes
> with a big fat warning (and a good comment in the soure code).  If users
> show up with a device that hits this and want to use atomic writes we
> can resolved it.

Fine by me.

