Return-Path: <io-uring+bounces-2201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B66B2906529
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 09:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EFBB28979A
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 07:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26E713C67C;
	Thu, 13 Jun 2024 07:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eGc+oDjI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b4b42uJW"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D3313C3EB;
	Thu, 13 Jun 2024 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718263964; cv=fail; b=YeR13CDG6+W6YqMPwI8M9363RDj9cwl+hyUHtyo+frq4mXXr/gmKxlTdD9kmGO64hgrSRokn8Tds+oj2maYj6h7NYKUkwqsR/Ix+TilwHGPqvcsD44nGFyv0HXHWdkZgLPLPrNSGkuKMZ0m6sHCICpkD5CST2jR2zknTqKFDPjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718263964; c=relaxed/simple;
	bh=SVtAzsu3YuQSLA32KHDvGywoiTNToCCuXODHARNld5c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lfHwd3yBaLZAWF8fJsviqJ/p4bVcF6jHfDsA/8OBTEDOrrJQ/IOXfX+2qL3ZMp/lPitNmJeXH9VYsW7vmDLLMsr5aCFH5vKwjOsDduV/WcKYPBXQu6WA4YDT12nNjgHHIdjRkF5FcVnzx3xC9LWvvvrTSjzbfG/Xk5qdm04co+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eGc+oDjI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b4b42uJW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45D2WxZr019554;
	Thu, 13 Jun 2024 07:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=znIGhPlAdIagKv0m7Olcz3MPgGbhryzKWS2pfJgFNuM=; b=
	eGc+oDjIuKZ4FVK/M12u2/Mz33lz7T988e0YFqIuPpcD6SNY6lGj55+iYOAVPjNq
	oL9Ic4Uz/QWxs28WTTTBcG+J7HJ7RQQE1V3yThF1qN0Hxgwf+TIDY7KbAFDuB26G
	3LcILxPhWsVodoietAGOoW/ex3v8qBYmDJJMfB9EnNjhgNlqKDfK1QT9whrwoK8O
	eXPZNMH60BE/eccKVSywEH6Om9RQDUAfDX+MhSzQ61PF50xSC1t2j711rOPU8EWR
	L5cGdX0bKNi55+lOqqg33aw+VmQmssRtwXu+8knvxOoANzA8549c+oMPkBwKqKPk
	vbCbOIAxK2o9YvX/iIQ1Eg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1mgxbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 07:25:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45D5tdee036756;
	Thu, 13 Jun 2024 07:25:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdyv99r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 07:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHJD266DpeKcel3uufR2J+HEbPMipkjim9e7n0pgushSs4FoOj0MJlbHfopae5plOdyjoSmRLwCLPhJfwGKsTT/dvsACaitxf6OfnMaXDAY1z3FWQgltZDeQpfqvqAtt24FfWl+E2TjTRxDY4AYc5D5HVUIxk1WM0VkBXwQKopdMnJaYeEIbccoR3W7tT3V71ooC7HKz6y3alesTHAFXtN2wInFEptavXcyiSn6F3bSHpuI3mgcn6ntAny/X4usjNkXQTp6FQWshqEF27AoYwW1gBB8NK8zVz7X98bU3pefudNYydrqHT4O+G3PeQMLnhJkpKWNy0hhFwUJSSv6j+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znIGhPlAdIagKv0m7Olcz3MPgGbhryzKWS2pfJgFNuM=;
 b=lyraEzb17u5R/T++UF/+gy6E5cbWQsFK/Dqx8hsKb+gFYdOMk2AkG6MI5l9dcDnHXVaMaO7pZlZC9lTUeuCpeqYbok2oHnKtFFRMg9DoGX3LM+w5XCrHPxCAFWNkDoxriENXU5JG9yObp4x3TINlpZyirNlCZLz4b5+CDvCihS9b8hlMlTBWOesL4WUDoH5daAKXrln1VNGsO0PkGvd1OBBw3JvTZnO/X0HvvQ8taifs4pgptB7wPDcd3BVeJIO4ONXOkmmqDuVH8hgjMAaWAWrKRL5JfbSQFRa15giKi/syzQIXzQ9tbSXISqzOW2bqk1ptBZHvdrM9/oUyuQmI+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znIGhPlAdIagKv0m7Olcz3MPgGbhryzKWS2pfJgFNuM=;
 b=b4b42uJWrcM9ptA3QhZcaUoFtsi/nc26zSTOJBY1E52sVP9SXlJfjdupTbNd89AC/T04l5GVvhRJoJf0SIxFSkcrkWWQNIQIMa1+oZxgmIcmYgfGasIFEjSLIiOXH0IWYRvcYyiS+icx7R5x22c+n+816BOxjelzHBplGRmwEVo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5029.namprd10.prod.outlook.com (2603:10b6:408:115::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.23; Thu, 13 Jun
 2024 07:25:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Thu, 13 Jun 2024
 07:25:29 +0000
Message-ID: <db998b4e-8bd8-4c8e-b165-069288588ed2@oracle.com>
Date: Thu, 13 Jun 2024 08:25:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/10] fs: Add initial atomic write support info to
 statx
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <20240610104329.3555488-5-john.g.garry@oracle.com>
 <20240612205433.GC2764780@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240612205433.GC2764780@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cbc7f29-f9b6-45a0-7e6f-08dc8b7a00a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230034|7416008|1800799018|366010|376008;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?UzFqZG8wZjBWenZoSnprUzcrRHU3Q0VIemRHRDhNb0RNOS9JV2FJdjNTVFRk?=
 =?utf-8?B?dFBGNW83cEZpZFhRdG5xemduQ3lNVlZNbStOUHArOFluemNYcXJGRFRaYnFv?=
 =?utf-8?B?QW1WbUF2SSs4aXorckFZdFRzVXNSdnc1VHdBS0VzSHREOXFrRzBWaXdROFYv?=
 =?utf-8?B?Q0tTNDhYTHQ5OEtLL05uak1NUURGY2JKZ0FzSm84RlZhd1RDQ2lkR1JidzI3?=
 =?utf-8?B?ZkY1SVpCTjFtcjNDNnhpTlFxUC92MlQxaEltRlFtVlJPaUFNSFMzekVKUVRK?=
 =?utf-8?B?elEvdEtrOFFpZnEvcExYVXRMa25PSWRnaHc2UHZReDJTZG9FUDdDdzZ3WXpY?=
 =?utf-8?B?c3BZaXFudjBaRUJOOHVraXJkTWZpSUVGN213b0lwV3VRTlovazhCZ3VpY3lt?=
 =?utf-8?B?ZHVFY0JYRFl1T082UU1aQ05MTVkrU0g2UURsclBPZlNaaXc0RWozTmFucDFM?=
 =?utf-8?B?TEVGZ2NyQkIzRmYxVWRTZUVJc2tCWDVQVWMvbkYvanJPbWV0ck5JV1VJb1Y5?=
 =?utf-8?B?bm5tenR0UEhoZFRyd1RoNFk2eG13Nlpwbm5nclErNEFCR3lyazhJV1RLTW1w?=
 =?utf-8?B?S2JnL1JmeStFSzV0SWdqOCtHQy9zcnY5dHNNZjRwd2dvN1k5eDIwVmV4cXBU?=
 =?utf-8?B?TnFxcENhV2ZnbzFncHF0bmNOK2pybEh1S24wQ3dXb0ZWSEIvMnJFRG5XS09k?=
 =?utf-8?B?T0xaanNhWnRHL2hpVWpIUmpqeFovNURZaVZvaEc2bDRaajNWTGJaKzZONThj?=
 =?utf-8?B?QWNlcllXd2tlOUtEQmlRYVRxb3A0NzVyVTk1NGJaUGtzVytRUW5KV0sxVVdt?=
 =?utf-8?B?NE12bGtaTUM5Ym5qVEZ5dldqZ0pkdWtrYnhxaEc1Smx2MVJnV202ZWlRcGxO?=
 =?utf-8?B?UnNNeURaQThhUzFQK1BqaXdRNVdiaWNqbGdXMVdEd2l6eW5sUmZLTng1ZnZz?=
 =?utf-8?B?NkZIVTlCSEhhTmNlUldpb2lYZUVQS2lSRXFKK2VFb3BNWk9IaVEvVGlJR0s3?=
 =?utf-8?B?WHNTZ2VER1RFSytnd3o5clE2NCtmcVVzcEp3cU9jMkU2cHZMNGFZb3NHOUtY?=
 =?utf-8?B?M09yMHlxL2dWS3RTZ3ErYmhhKzZYTEtwSkVOQnNnN0lwUjIvSUhsS0tuUVdj?=
 =?utf-8?B?djJtL2JkTGJwWlFVOWpYNTdQMU5WVmE0TWluTTFMdFhRVTR2Z09DOU44bG1w?=
 =?utf-8?B?eEhXMW1qS1RnVzB6V2dhdFdkRjZmeitoeXE4L2pRWm9IVUZBSXVvNGxrWXVv?=
 =?utf-8?B?bzNNVU45Y0xDWDR6MDJJeHZyZ3U0Q1pSQ3JrbTBnMHh2SS83bUdSWnBjcnF2?=
 =?utf-8?B?UzRWNHYzK29NVngzTnVWM0pEaWxKL1FEdnVLaXg2WjJNc0orWXFjbmtneStH?=
 =?utf-8?B?SGtqaHRRYlZEMFdRQnJCMWJIdDNGMnhLL3FkdXJYazdJelU1dmR1YUc1QVoz?=
 =?utf-8?B?V0kxQWpYMnRTK0c2OFJ2bCtkbGFMdStQYnZ5dmJQbVpQQ2gwWFU3d3JPQXVL?=
 =?utf-8?B?M1k3bGRld1h6cEhSSVIwSkFXdUF1a1J3RkpzUXQ4amt3QldqbCtkOVUvc2s3?=
 =?utf-8?B?UHV6VjFUVjQ1cjVOYVNMOTlqZXl4QVJIWVFsRnRmaE5MeU9NU2Fva0FHRjdS?=
 =?utf-8?B?Z0VOc1NSc29JODFKQUhHNlZXZDdVOXZhNUVjaUlwMXFvNUcxa2FvQWJnd3kr?=
 =?utf-8?Q?4abx+qH2dHLkD6R+KMV5?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(7416008)(1800799018)(366010)(376008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NXJMYnB0ZzU4TzJMdkI1UWZvaTZpL2hScXNkdE5Sa2dEUlRkVnhNQzh3SS9v?=
 =?utf-8?B?Umk2M2wyU3RnNVJDa3pKQUtxQUdpbExUL3h0cDBxM1pHTXFhVU1OblkyOXRL?=
 =?utf-8?B?RjhHazNCSFZLaWtSMTNaQVF1OWs3ZmsvZTd2L1dqNldCNlhnbUZsYkV6MStY?=
 =?utf-8?B?N0Q1cGdQNkExczlnMkFoV1U2TnhmdnVvQWY0dTNvNkRyWmxnMUk2UWs1RTlY?=
 =?utf-8?B?aW5lVVJwVHNKRXEydVE4VmtOM2gzM1VoVnBtZkNTenZ3dDFVRENXdm1BVUI1?=
 =?utf-8?B?a28rdVhlaEkvVjZvWE41TzJ3OTA5SXZVTVVOTWFpczk5aS9JTG5FdXVJU2FB?=
 =?utf-8?B?VW8ybGRySG1hT29aZTAwc3I1aEszUWpEYXBwRDhtOE1SRHYrWUZ4R0JlenRE?=
 =?utf-8?B?MTJaTUxuMlR3aFdITDRYdTJJNmZscS85cFEwbG16T25iSGtrZ0lxY1p3V2I4?=
 =?utf-8?B?aUNPeGsxa2xZT2pQbEVOVVBPRjR6aW5rc29xMjljbC8xVkxYWi9LcjdDWHly?=
 =?utf-8?B?VVltOGhEdTNlNjhBaEN6Z0FVVTFDZjE0UHJpZ3BlU3RhTTNnYytJaGlhb2My?=
 =?utf-8?B?N3NlQUljVTVVSkNaVmJzbTdjb1RreXBvdENQZVVSK1dOYVlGdXZERHB6L0Ew?=
 =?utf-8?B?L2sweitrcUs5N25qV2lvNlU0R2pQVExIeFFOcWk2c3JYaEYvdHlNaERGbEJa?=
 =?utf-8?B?aTdLbm5IT2F5Y2NNUW9PREFmTnoyQ1VWSFhqbmUrcXZ3bnhwTklCRVMvZW1D?=
 =?utf-8?B?dGZ6dVFQeURadkJVVGFBMzhEMGg1RVlaS1ViNzQ1QXpvSldQL2pXSEhUOHVu?=
 =?utf-8?B?N3hjZmYvdVpGTkV2cGhZUWlic2dsQVZwNXc1R290OXJJVzRIWEIzRFgxRG9U?=
 =?utf-8?B?S0ZaZzM5cE0vOXNIWEtKU1hNdlVtSlZzKzN2eGpMMmlGTmFHRWNOMWp0TlRl?=
 =?utf-8?B?QlhkLzNUMHhJbDh3U25LeWptekE2UXh6LzdjSTFOMGNHZHpPSjk1ZHY1UC9G?=
 =?utf-8?B?QlpmakdjNTRNYmJScG9mVFEzNitaTU9zVVRoOWVWTTF3dE42QUw3Y0NxV2FF?=
 =?utf-8?B?dmxEbklDdFFqTjZ0SzlIMXdiVHk2bEtyZXhiSEZTTEZPOHIrNzlkQWdiL1Z0?=
 =?utf-8?B?ejd2S1lpbUlTcDJROUxlKzZCSExDTXlXWW94Wm42TFU3ekpiM28vNjZqeTdi?=
 =?utf-8?B?Q3pFempLSytLanZsT1gzODlwWkpPZzRhZzE4MVp6dzUrUlFHdHhKeUo1bW9V?=
 =?utf-8?B?OFgzcms1VFlnckEyNzFUNmNTSXo5WFJod25DUGNaMi9OTkl1QlNtSTg0Wmhr?=
 =?utf-8?B?dWI5VHpqSU1RWS9sM0k3ekNLMUphWHRxVXJnYmpwNmttTUVpc09jVTBDcWdD?=
 =?utf-8?B?MnhlaFhRNUM0dHJnNTZsbFgvTzRvSmltL1Z4SkJCek9nREpZK2tUelIydjQw?=
 =?utf-8?B?NlRZVUJzKzI4SkRCSW1samplUTRVSEI0SHlvd3RCN1JSK243dTRhVlhvdUZk?=
 =?utf-8?B?ZWVCdWpOSEkyNnJBdStGSGNUcHlWMDFxZ1pPOGdoZDFkY09iTlA4ZG1ja1RU?=
 =?utf-8?B?c3cxZmdiVDRSa05oSnh5WVA0QURIRnlnZ3VCZmxZa0hzOVZnL2VOZWJUZEpX?=
 =?utf-8?B?WnVRcE4rSU9IU0RueXFrNlZaUmRob0Y1WG1aMTZrVU1jeEFaWnF2bFlSZEFl?=
 =?utf-8?B?bGlEZHJEVitWRXZmaUd3YUg5UWNxWGpFREpVUytmUHZEQW1VLzRVZ1V4Sksw?=
 =?utf-8?B?RnUvd202M3N6L1JGdjlodFNDZHdXaUZzQTgvZDdYbjJZaEFtczBNMkh6REpZ?=
 =?utf-8?B?YVdpaXU1L1NNVGdKSEp5V0x5dHlZZmdHcjBnclRxWHd0QW9hYjI1MGpDN2NT?=
 =?utf-8?B?REY1NmNORTNhei9BdFdScWdmL0djR2VFcG9TWHR3WDdLOUhVSU5tZ0RWSHIw?=
 =?utf-8?B?RkU0aGJGT1lYVlpyRjVSdHJWNzFWdGN6OFljb1BEck91cnlpdXdFeDlPWkIr?=
 =?utf-8?B?MnR6UU5aZ1lHaFpmTjJWNlN6eWZsdGNoUERyWU9RMXlmajgwOVNZS0duRFFT?=
 =?utf-8?B?QzJFTnEzckN5dHNqbU9pUEZhOW9oWnB5WkhOMGt3ZTdNMGJ1UjhGVlR1Q2Z3?=
 =?utf-8?Q?9/rxQndoIs8w6FiFvZMWIDd+D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fq2ly7abU6DP3W8BJBABwjx2MKlhVs9dtHRzMUZZSfX0m/R+zzhtnmo72Nhlnm6KDGdE2yu00RMN2TTu2vZ4dv/yQdlQHB/MI7/3MpFNe1eijgV5yImFOtGedX/MaNAr/pzZK27aTtPFb/THAx6/kjVNskZZQjLHHNP3XuybjTjrsVCw8pZRqoZy7+BokLr7nSZXoLwPpDf9EECjFSnSNh7qDfjbv5b9WhE07iP9Tu4B98RogtOBPfctmQo3KUAIlLIF3XqiN1bNt3HJzgrpGUjOfOclHYO45IWYGuoGJNXzP/7/hgH+R4HO0DaezS9G6nMNjTzdEGTuMsF33SPZ/Jaa/i5o4nX6R0vzuWLY8hpsrZZZQY0kG4Uu+UklxeU5LL7xYcJ3viLSuY2WtTALUmw7+mz+K78TRApB8Mq5v9Pb/zbyJKR9OZKhvl0mkLrhqF1zhHqoccQsvI4bQdC79gbj5P3+wtBlSbB/NwMeMh/ZUJJ5shXnXb1E67SSB8o+u4ZR6EfCqbxPmvo/2X1Ymcpj+8g6urWsIuv7L42hUdhqyLEKHG3aJSyrGBjeNDtn18oM+qTVNSYh44/hR+O7gsbbieG75alZHg51N1RRCfk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbc7f29-f9b6-45a0-7e6f-08dc8b7a00a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 07:25:29.5198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJcu3KnIaxHkL0iBF7g8oUzk8Q6COI32MboM3cbZ6Bo3FdxNfGEcBh4crODiDB4LAphD036IkFr2aI0gNpE0xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_12,2024-06-13_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406130051
X-Proofpoint-ORIG-GUID: qwz7SSgcCncKzMbKwZs8PwqqTidtz2IA
X-Proofpoint-GUID: qwz7SSgcCncKzMbKwZs8PwqqTidtz2IA

On 12/06/2024 21:54, Darrick J. Wong wrote:
> On Mon, Jun 10, 2024 at 10:43:23AM +0000, John Garry wrote:
>> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>>
>> Extend statx system call to return additional info for atomic write support
>> support for a file.
>>
>> Helper function generic_fill_statx_atomic_writes() can be used by FSes to
>> fill in the relevant statx fields. For now atomic_write_segments_max will
>> always be 1, otherwise some rules would need to be imposed on iovec length
>> and alignment, which we don't want now.
>>
>> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>> jpg: relocate bdev support to another patch
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> Looks fine to me, assuming there's a manpage update lurking somewhere?

Sure, see 
https://lore.kernel.org/lkml/20240124112731.28579-1-john.g.garry@oracle.com/T/#m520dca97a9748de352b5a723d3155a4bb1e46456

I'll post a rebase, but the API is still the same.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks,
John

> 
> --D
> 
>> ---
>>   fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
>>   include/linux/fs.h        |  3 +++
>>   include/linux/stat.h      |  3 +++
>>   include/uapi/linux/stat.h | 12 ++++++++++--
>>   4 files changed, 50 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/stat.c b/fs/stat.c
>> index 70bd3e888cfa..72d0e6357b91 100644
>> --- a/fs/stat.c
>> +++ b/fs/stat.c
>> @@ -89,6 +89,37 @@ void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
>>   }
>>   EXPORT_SYMBOL(generic_fill_statx_attr);
>>   
>> +/**
>> + * generic_fill_statx_atomic_writes - Fill in atomic writes statx attributes
>> + * @stat:	Where to fill in the attribute flags
>> + * @unit_min:	Minimum supported atomic write length in bytes
>> + * @unit_max:	Maximum supported atomic write length in bytes
>> + *
>> + * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
>> + * atomic write unit_min and unit_max values.
>> + */
>> +void generic_fill_statx_atomic_writes(struct kstat *stat,
>> +				      unsigned int unit_min,
>> +				      unsigned int unit_max)
>> +{
>> +	/* Confirm that the request type is known */
>> +	stat->result_mask |= STATX_WRITE_ATOMIC;
>> +
>> +	/* Confirm that the file attribute type is known */
>> +	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
>> +
>> +	if (unit_min) {
>> +		stat->atomic_write_unit_min = unit_min;
>> +		stat->atomic_write_unit_max = unit_max;
>> +		/* Initially only allow 1x segment */
>> +		stat->atomic_write_segments_max = 1;
>> +
>> +		/* Confirm atomic writes are actually supported */
>> +		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(generic_fill_statx_atomic_writes);
>> +
>>   /**
>>    * vfs_getattr_nosec - getattr without security checks
>>    * @path: file to get attributes from
>> @@ -659,6 +690,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
>>   	tmp.stx_dio_mem_align = stat->dio_mem_align;
>>   	tmp.stx_dio_offset_align = stat->dio_offset_align;
>>   	tmp.stx_subvol = stat->subvol;
>> +	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
>> +	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
>> +	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
>>   
>>   	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
>>   }
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index e049414bef7d..db26b4a70c62 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -3235,6 +3235,9 @@ extern const struct inode_operations page_symlink_inode_operations;
>>   extern void kfree_link(void *);
>>   void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
>>   void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
>> +void generic_fill_statx_atomic_writes(struct kstat *stat,
>> +				      unsigned int unit_min,
>> +				      unsigned int unit_max);
>>   extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
>>   extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
>>   void __inode_add_bytes(struct inode *inode, loff_t bytes);
>> diff --git a/include/linux/stat.h b/include/linux/stat.h
>> index bf92441dbad2..3d900c86981c 100644
>> --- a/include/linux/stat.h
>> +++ b/include/linux/stat.h
>> @@ -54,6 +54,9 @@ struct kstat {
>>   	u32		dio_offset_align;
>>   	u64		change_cookie;
>>   	u64		subvol;
>> +	u32		atomic_write_unit_min;
>> +	u32		atomic_write_unit_max;
>> +	u32		atomic_write_segments_max;
>>   };
>>   
>>   /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
>> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
>> index 67626d535316..887a25286441 100644
>> --- a/include/uapi/linux/stat.h
>> +++ b/include/uapi/linux/stat.h
>> @@ -126,9 +126,15 @@ struct statx {
>>   	__u64	stx_mnt_id;
>>   	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
>>   	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
>> -	__u64	stx_subvol;	/* Subvolume identifier */
>>   	/* 0xa0 */
>> -	__u64	__spare3[11];	/* Spare space for future expansion */
>> +	__u64	stx_subvol;	/* Subvolume identifier */
>> +	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
>> +	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
>> +	/* 0xb0 */
>> +	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
>> +	__u32   __spare1[1];
>> +	/* 0xb8 */
>> +	__u64	__spare3[9];	/* Spare space for future expansion */
>>   	/* 0x100 */
>>   };
>>   
>> @@ -157,6 +163,7 @@ struct statx {
>>   #define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
>>   #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
>>   #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
>> +#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
>>   
>>   #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
>>   
>> @@ -192,6 +199,7 @@ struct statx {
>>   #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
>>   #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
>>   #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
>> +#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
>>   
>>   
>>   #endif /* _UAPI_LINUX_STAT_H */
>> -- 
>> 2.31.1
>>
>>


