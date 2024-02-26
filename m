Return-Path: <io-uring+bounces-726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 246EC867002
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 11:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 900F71F2212B
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33051CD39;
	Mon, 26 Feb 2024 09:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SF1nBQBP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aTMr4IXC"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EE7249F5;
	Mon, 26 Feb 2024 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940806; cv=fail; b=YERLjUw/Wi8/kWR+9Xhg3oASao+4fS9gMeZI1FNk1iyjveLVUn5DeDc1/INfcFKC0Kp9G0Rbjm+aJ+kKKDTNwRq8s5cx1Zo26kGYqrS7tGEux1BurpxOC1iy/muHRRw09j9cTc5rw7N+aZ//4JovqD0GHQM3AQWFkM0bt1QaJag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940806; c=relaxed/simple;
	bh=bTvk9vXPqUIVk4RDJC9GU9pfa04/a9z70sP4Jn+2zcU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fo4nY/+QunLXt7ap703Co3TP1fTDGmYi/zMHF9X1G0aaWJC23Lf5Tlz56UnuULRr7Pc9zAWJ20lo/DJYfHkUWbvz91dhCDfha6IpnZu79BHB8l6mm3dRL8cc3bKLM8Ke5zCBvh6EqX+/+hTzz19vingOzEqASycbrNZURAYa5x4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SF1nBQBP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aTMr4IXC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q18SsC020498;
	Mon, 26 Feb 2024 09:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=BnwTHdPjRCfpYLu4wdGlxtr413Sa79LBHWc61E1r8m4=;
 b=SF1nBQBPmHydrgUc6SAuQepZe1ZZuzeSkvtEdzFzSEN9nhyFDxMMKY0E815XlpjsYpo0
 rJUbehzExXwtI/N2SqjA5iWWTY5TnRtit0uI81WSdlZkoQzp80Q1oYDxiXoUFQyNszD7
 RESUuh0KnRJxwOh4gcfcOAplIRNnIgZidJWKsg6nd2hjoTXFAyX7w6z1xIk/04dqRiWY
 YVW4zTdiziLQhcnaOGXZVY87n+sswCaLd0KQG/RGiBx+Q0Y1Nmn/nbAmCppyAAkpTpln
 msfe0quYlCHuxHRUv0L9loOQv4nC/DuHKJqup9plZfiNsPO0iNQ3XM8X2wonmq10WYXp 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8gdc905-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:46:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q7uv1Q013946;
	Mon, 26 Feb 2024 09:46:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wgbdh59t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:46:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xy8KUXY9c8kKult3FdWicjd7XkwEWzwVw3UxW1JR8xpmUzwVCbzCAZqjxLamFrevDKMwYn7GMyHQW0P5WGxLZMzFSkklhVazyXbWA2KxBJEn9rV0IpC3pVTy6N/6kVHt/0zj0tOOAZuTPtO3xSj+J/781e2OQqOkszbXkpe1NcNf4JC5Pk3PYd6xUHOW/j3/RBz+00MY3bLEWVW/PsC1bi6tlpj4Zfnaj/wZy0J8OG+IfSjETaqZmN9uQ/GUULe/DaQT5KOAsSgE1fIQjuassG8WLBlPNfCw+5gIX4O1q6PF9RrWo016eWXN9+Fb/GWLpEipw5CGO+dAjgvh1a7CjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnwTHdPjRCfpYLu4wdGlxtr413Sa79LBHWc61E1r8m4=;
 b=XD2Zdo3CWMy7mALIYUrsAxIJemimQf21pSe8hwlMAULvyXz+kw2oAP8j2cpujEbD1FfJ3P8JgiTNc23JYQH7f3NEZ1WEMVQUFwUFwq6+GJyTDwOTD56bJHKNaH8tJGU7ytViiWqqh4K51DVoz3aq28MNrYLnk/KlnKA6PUxWYqrpcc4l4B4I0hlp1nDiPvJw5v876ssbEnnqtwKiiUtxvts+vdKEMoVWIHz5rUll8d0uxzRaYD8PEm+8fksLIuGVg9+pS9Wkce3/FQ4PWRSGQG9LqAuwnIPVnP06dPxS8DXHSG6Mm3FMSpm+xKh/pdO6N719x4wMZxpMycxuTjgumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnwTHdPjRCfpYLu4wdGlxtr413Sa79LBHWc61E1r8m4=;
 b=aTMr4IXCwvqzjMxRxBkDi0OGzU6mAqWRxqyipTAOJftr5+y/96dQCX6LAKK07+9sDdys9y37EDIzF8KRuD37X6JE0OmrNpOMkahfNHfDC4tzJav0N2OV6WnYnKU9nhLPGi+89+0Kkz1RGet67cn/ifbuW9B7qJRnjapbNvNVYP0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5999.namprd10.prod.outlook.com (2603:10b6:8:9d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 09:46:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 09:46:08 +0000
Message-ID: <b99970d1-b5e0-4103-8f1c-c1e665e3ee09@oracle.com>
Date: Mon, 26 Feb 2024 09:46:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] block: Add fops atomic write support
Content-Language: en-US
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, axboe@kernel.dk,
        kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com
References: <87cysk1u14.fsf@doe.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <87cysk1u14.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0125.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5999:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e313c7-4ad4-4c95-6800-08dc36afc1cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3QcyuUVHPnn0P8NadljAZfTJPzAZ+Pgi52GtlHy23vjYXAvSWtLfv2h4XD9Lsj1jiVFs2zARsbaO1zwwraIg78li/b3INNi3H3n2LoTYwRUbQdY/OEftunaZWMn+6MFPlmCqe9b6L4+s1vqMFcf60k6MjWtSCqVxtt66+R43DSqC4vw4585ZEFu/UgKzk+1p45RxI/0ysZBJCwXjL8Y1Z7n9ahAp6APvb4T1Srk38YkPJOEJK42nGtL1ucjXf7pp2OgmJJr71TtyCXoqrsHbENR78qVFNjtKboYu2os935rCexo96mRzel6gPva+FxebgNYVK/JrfPMnIxT1vXNpwQ1jMwVIvaO3zdsB2LqiHstg3hcte2M1n22Tvyy1U7jLqRg6OZVAh3Kd2kKZEqyZXlTKOeDsQ6QSmX0fX/KyYvG7i2G8moL+VHz0az7IkuxgADWuVplWQhlRbmZsG3rxFcTbF6QPJpFqjaUgcff25lCBWXIbbjKoIl2mq74Wh4o/Df5ki0Pfq4VJ0h/yYnxP1NIc43JJsWNr3M7NzAnAnYsdbhsis7BnUCaIn69JOdg7WwrtHDAArGXvvKcD+nZpcxYkziZPgkxwh7BkNsiGp5B/sDhIaZzf+OLBojxgR21HKd1mXKN/g3l7maLFYmYIeGYMcyzyEDDHGDQdt6raKFibspF7t+BIbxDUsm+ivWMYbzlPaCjOMe6oKgFm18cjeg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WWJOa3ZrNEFDem4waGlQYUNXQ0hGdEtzcEQ5dzhxUGFIVjgrRkJuZ0l3S1gv?=
 =?utf-8?B?aHJubWJJdkV3Y3ZuOFZYUzh6S3FSR1UzcmJTYUNlU1lIaDZRQnZLTEIxdmhl?=
 =?utf-8?B?anAvNHc1aW1Mc0x3cENNaTJVMnFFaG05Z09XOUsyL3Z3NXNxWXZjWWdIMmFv?=
 =?utf-8?B?K3lFTWFWekp0R1gwQ2pOU01od3p3azhpYzlwd0ZOUE16WWdEWVAwejlxcGxl?=
 =?utf-8?B?RmFSZGRSRnliL20vNVdXVmJhczU4SWRwajh3Y2ozZ1FLelhHNk9QN2VYczJi?=
 =?utf-8?B?R2lybnZHVy93TGFlYS8xNnoyRVNMMnZ0QWxEMlVaRjNTWHNUcTFaZTZTMzhR?=
 =?utf-8?B?Z2Y0VUV4ZTFkQmdpNFNmSHBJQk1iWmZ4TEhsQTJ2UlFkRHBnc2t4UjdYYUJQ?=
 =?utf-8?B?Q1dLM3ZmUnRJVUwzYVVrMDJZMXRrQVhQZTdKRHdSM3ZrejUzYklKeGxXdDVr?=
 =?utf-8?B?UXRSTXdoYXcrRlRIV0VLSVFUaWVXWklMcWlIQ2pvbjIwdGxIRXNsN0lDZE5T?=
 =?utf-8?B?ai9XWEltRHcrYVNqYnhPcS9UdzZiazdnSDFCMGVEYlUwa2dOKzhiZFdiZ25h?=
 =?utf-8?B?T3YyWlhxMnN4azlMZUpXeTFra01LL3FrV25kY0NHaWdZNGFiYkxsN2V5RmdL?=
 =?utf-8?B?ZVR2cmlnS25ETU5hNytpOTJRcjZlNzdsTDUzV0JwcXBJYXNXT3RSSnVMdzZz?=
 =?utf-8?B?VU1qdFNUdGptbzFVZkxVZXd4T3Ryb0JBTWZ5aDhIaHlWbTU1dS8yUUdPWlRM?=
 =?utf-8?B?cmppcWdlaVpjSStkRDFqMzhoR1QvZ0FTeFVEQXlUeWpTeWNLRHp3djRxblk4?=
 =?utf-8?B?WnYvYTFVQkE2QUxIWWVjYkxRSFR2emo0ZHFSeVBFUVBzbUZEYzdxbmIvdDVV?=
 =?utf-8?B?UXRaYWlVekx2KzR1YlZiSWFQYm80VlpHWURZNFZNREpXUW1FUGpkS1U3SE9Y?=
 =?utf-8?B?OVU2QW1FL2NZTEFXc2lvT0NBTThUQjMvVUZBbmVveEFjQ3E0cTZLcW94b1VS?=
 =?utf-8?B?TU4vTHZSQVducmJuM1E4YTZ1UWNRZW9YanhjZGJYaE1LWUMrRHQxTHJuUy96?=
 =?utf-8?B?dmNIbjczZFhWVEJQQklIalNIdER5TklPSWcrVG9YaGcrcHdkU0tnM0RjMjdN?=
 =?utf-8?B?SFAxSW5tSU45TFE1d3B2Smo5cGlZM2lpNkJFTDZ4ZUdnUkkxRDJSMVZyTFVP?=
 =?utf-8?B?TzlUWm1yNWdNTGhwRVZwZEs0aVhDajZja1BJZEFTUVQzTTVPYjlUbVBvUTl2?=
 =?utf-8?B?a0JxTGl1RmZIbTlLRXA3NDdkYVkyc0ltSlQwUlJDZWtYeVpHNUxTU2YzWkgv?=
 =?utf-8?B?TFQ1aGhONEd5NXlUOHFXdlZxRUI4OFkrS25kckVXdEs0Tm1oaUdBU3EwOFBK?=
 =?utf-8?B?a3FxQXZPb3hFK0lROGx4aFNjQklaajdRTjY3VHhZNWpNOXpJMDA0bml3ZG5B?=
 =?utf-8?B?RXMvbFFmL0phU3Z3blZsTkdNbG9MZU1UckZRRE5tVUQwNEpyTE1zOFdOMXlS?=
 =?utf-8?B?WGZtRDZCQUQ3eGsxRlpPRU1tS3BmeWJ6bGlrSTRnRFdmdmlITVRRNVU0U2Q3?=
 =?utf-8?B?N1NMa0J5TWhhUUpOd0lqY2ZFVXdqaG9XM1pKS1h4c040OEp4WnBEQWFCL2xB?=
 =?utf-8?B?aDhLU2I5WUx3VjFFblBVYXZZTGcwdjFqWkE0MDJBNW9lQU1WRE9QQXJzZ3di?=
 =?utf-8?B?NTBnZklPb3RTNWdmNkJCc09oV0loNjVLMUVxWENnU0l5ZHkrc1ZxTURqdUta?=
 =?utf-8?B?c3VtdEhDUGJoRVplRTcvaDFJcExvbDgzK2JlMFhoMC9vZDBFbklWNG1vcXZQ?=
 =?utf-8?B?dFpkaXgwK2lMekg2V0V6NHEyQXppTytGa0Q5S1pneHAweEFHTkRXS2ZqOW9y?=
 =?utf-8?B?dzZ0VDROenZLS1Q3L2ZXUWJUeFpBeUpOeTdmYjNFL0Jtb3hOcGNpelMwRlF2?=
 =?utf-8?B?akRja1ZaZm92YjB4QXBZV2ljcjNyTTlHRjNrNlQ2NW5KUkJCZmVaUWE4bFZR?=
 =?utf-8?B?U1ptWC8zRnBYeGRVaDQycVVyVVdlUUR2a2tQUlhDOXRmWUF1QjFZNGNRVEx2?=
 =?utf-8?B?a1hrYlMxYXpHb2E1V0VqNWpudXZHaEFlamcrZ0VpMWtnZVJ5cytpV2pxeEpo?=
 =?utf-8?B?bFdCb0orVHJQNDQzWVdrZ3RKakU3SFZrR0ZORnJONXBUUXpVbXgrZ0pxTGl0?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8NWtDyC4uPw8F/kCOmcKt1Rh3TEkej+N7dP6ui4b5MWo0ROmePkJBarrkoE2SZESZH1xA4KaJQNqsbaLZzAqvxTrkjSb/S83jNppyWsEW9/Q6TcrJx9E27c54LCjxawgQCkpt017a7pKDmGnBe2+YFDCVoJll8FBGYaIy6al88WNo6QSZWXvCk6jTev3i4mU/mCZv7POeJxX5OdaIUv3ySIqvSRK3KC99AlZ3y+CCyIBEosbDzcHRwMvDqLR0qjQWsQf3Uh1IeHatg457+Uj0glohAuhDuXe8EO7o5y7voUugcwn/vJ5eFVO3G7V4AZxR8dbKcLxNzSihfiU++PPFzYUscZZW1ft/SRQN/YSaoy+BwklkjXDQ3NfrdUL6AJ4eGGqc6nQst6/D/T4hgWpW2HXdcLwkb6iqOJjLZHFkSbrn3gE6anMNZGti2HIyjRvolb/Z2GaiCLqoamhHebTddgizcfNIgvgUdflzqHjs/jXfIb58s3rUTA9oeJpKWcLSKFhEC2HhSSC4OEJ/TfR9gXARJj6w4tQcGhLUatu8xD7YSz5VqnbYbZnjj9+zDP9gSpuwj1/9Yjs4S9L5T4yCNUvKlQF7AUAhrFGlsirIF4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e313c7-4ad4-4c95-6800-08dc36afc1cf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 09:46:08.0329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnP8xXVjG3qNgPw/1pR6t4byF0xaMgpJ0X7xDoQtUR6xVX1HJ/6Jc5eFMbEkG8Od8c+LcrmJ3tyVKnbNLEAYnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5999
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_07,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402260073
X-Proofpoint-ORIG-GUID: cPtHu2MNmApFdzGtXY2rIL5OcxrhQNYA
X-Proofpoint-GUID: cPtHu2MNmApFdzGtXY2rIL5OcxrhQNYA

On 25/02/2024 14:46, Ritesh Harjani (IBM) wrote:
> John Garry <john.g.garry@oracle.com> writes:
> 
>> Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.
>>
>> It must be ensured that the atomic write adheres to its rules, like
>> naturally aligned offset, so call blkdev_dio_invalid() ->
>> blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
>> blkdev_dio_invalid()] for this purpose.
>>
>> In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
>> produce a single BIO, so error in this case.
> 
> BIO_MAX_VECS is 256. So around 1MB limit with 4k pagesize.
> Any mention of why this limit for now? Is it due to code complexity that
> we only support a single bio?

The reason is that lifting this limit adds extra complexity and I don't 
see any HW out there which supports a larger atomic write unit yet. And 
even if there was HW (which supports this larger size), is there a 
usecase for a larger atomic write unit?


Nilay reports awupf = 63 for his controller:

# lspci
0040:01:00.0 Non-Volatile memory controller: KIOXIA Corporation Device 
0025 (rev 01)

# nvme id-ctrl /dev/nvme0 -H
NVME Identify Controller:
vid       : 0x1e0f
ssvid     : 0x1014
sn        : Z130A00LTGZ8
mn        : 800GB NVMe Gen4 U.2 SSD
fr        : REV.C9S2
[...]
awun      : 65535
awupf     : 63
[...]


And SCSI device I know which supports atomic writes can only handle 32KB 
max.

> As I see it, you have still enabled req merging in block layer for
> atomic requests. So it can essentially submit bio chains to the device
> driver? So why not support this case for user to submit a req. larger
> than 1 MB?

Indeed, we could try to lift this limit and submit larger bios or chains 
of bios for a single atomic write from userspace, but do we need it now?

Please also remember that we are always limited by the request queue DMA 
capabilities also.

> 
>>
>> Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
>> and the associated file flag is for O_DIRECT.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   block/fops.c | 31 ++++++++++++++++++++++++++++---
>>   1 file changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/fops.c b/block/fops.c
>> index 28382b4d097a..563189c2fc5a 100644
>> --- a/block/fops.c
>> +++ b/block/fops.c
>> @@ -34,13 +34,27 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
>>   	return opf;
>>   }
>>   
>> -static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
>> -			      struct iov_iter *iter)
>> +static bool blkdev_atomic_write_valid(struct block_device *bdev, loff_t pos,
>> +				      struct iov_iter *iter)
>>   {
>> +	struct request_queue *q = bdev_get_queue(bdev);
>> +	unsigned int min_bytes = queue_atomic_write_unit_min_bytes(q);
>> +	unsigned int max_bytes = queue_atomic_write_unit_max_bytes(q);
>> +
>> +	return atomic_write_valid(pos, iter, min_bytes, max_bytes);
> 
> generic_atomic_write_valid() would be better for this function. However,
> I have any commented about this in some previous

ok

> 
>> +}
>> +
>> +static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
>> +				struct iov_iter *iter, bool atomic_write)
> 
> bool "is_atomic" or "is_atomic_write" perhaps?
> we anyway know that we only support atomic writes and RWF_ATOMIC
> operation is made -EOPNOTSUPP for reads in kiocb_set_rw_flags().
> So we may as well make it "is_atomic" for bools.

ok

> 
>> +{
>> +	if (atomic_write && !blkdev_atomic_write_valid(bdev, pos, iter))
>> +		return true;
>> +
>>   	return pos & (bdev_logical_block_size(bdev) - 1) ||
>>   		!bdev_iter_is_aligned(bdev, iter);
>>   }
>>   
>> +
>>   #define DIO_INLINE_BIO_VECS 4
>>   
>>   static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>> @@ -71,6 +85,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>>   	}
>>   	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
>>   	bio.bi_ioprio = iocb->ki_ioprio;
>> +	if (iocb->ki_flags & IOCB_ATOMIC)
>> +		bio.bi_opf |= REQ_ATOMIC;
>>   
>>   	ret = bio_iov_iter_get_pages(&bio, iter);
>>   	if (unlikely(ret))
>> @@ -341,6 +357,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>>   		task_io_account_write(bio->bi_iter.bi_size);
>>   	}
>>   
>> +	if (iocb->ki_flags & IOCB_ATOMIC)
>> +		bio->bi_opf |= REQ_ATOMIC;
>> +
>>   	if (iocb->ki_flags & IOCB_NOWAIT)
>>   		bio->bi_opf |= REQ_NOWAIT;
>>   
>> @@ -357,13 +376,14 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>>   static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>   {
>>   	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
>> +	bool atomic_write = iocb->ki_flags & IOCB_ATOMIC;
> 
> ditto, bool is_atomic perhaps?

ok

> 
>>   	loff_t pos = iocb->ki_pos;
>>   	unsigned int nr_pages;
>>   
>>   	if (!iov_iter_count(iter))
>>   		return 0;
>>   
>> -	if (blkdev_dio_unaligned(bdev, pos, iter))
>> +	if (blkdev_dio_invalid(bdev, pos, iter, atomic_write))
>>   		return -EINVAL;
>>   
>>   	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
>> @@ -371,6 +391,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>   		if (is_sync_kiocb(iocb))
>>   			return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
>>   		return __blkdev_direct_IO_async(iocb, iter, nr_pages);
>> +	} else if (atomic_write) {
>> +		return -EINVAL;
>>   	}
>>   	return __blkdev_direct_IO(iocb, iter, bio_max_segs(nr_pages));
>>   }
>> @@ -616,6 +638,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>>   	if (bdev_nowait(handle->bdev))
>>   		filp->f_mode |= FMODE_NOWAIT;
>>   
>> +	if (bdev_can_atomic_write(handle->bdev) && filp->f_flags & O_DIRECT)
>> +		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
>> +
>>   	filp->f_mapping = handle->bdev->bd_inode->i_mapping;
>>   	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
>>   	filp->private_data = handle;
>> -- 
>> 2.31.1

Thanks,
John


