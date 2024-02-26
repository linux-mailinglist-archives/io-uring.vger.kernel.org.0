Return-Path: <io-uring+bounces-727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D624286700C
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 11:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F7761F24BB9
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBE0627E7;
	Mon, 26 Feb 2024 09:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DKFxWoMo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IC1VGCIp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A924208A3;
	Mon, 26 Feb 2024 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940854; cv=fail; b=UlxQ/vMXb9+cbdVjUb3ChO1+2R2gtLYSWkzyJr9Ikgn23zcXL3OJr8oHbnOHaSqHTOsu78ATRZW7HYw5tttaLQ3i+/q71uHRW/pZt3tf6Jx5vWlt/hxduvJrW2WwHZuHwN162K+bQ9txoPkKmxfmygHVSqgApfFuSNSfuKkQ9sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940854; c=relaxed/simple;
	bh=tiWGiHXXuhWicPScsbxtzINR3K6tz24tnXSNKJlWQnY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K+D7TeHa83PGhRPHCW8uNNEEl1moWyode9fgv2/CQLawtNKSOxqmuwgypS/iLYmOdny7Zq3p6Bpw2kG9El7K0VOn+rofwf5PHS6Op5g4Uz8svCcWUxPXWeXOewjFLR0jbHxDfipMGhQ5dXtnzgxYc7S2B8CAPa9DvHl8SoPm+EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DKFxWoMo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IC1VGCIp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41PNV82x005665;
	Mon, 26 Feb 2024 09:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=jJWM0mUNtw+HzR0eYqt9C7/6OtQ9L0nYdVwfID624JE=;
 b=DKFxWoMouB231GVJ8r9JfEc0dlpDXg/psIsjur/myybueMxwOW0A2XS6x5n5uhzF2NXB
 BGVkBccNIC+JTaz4M/yl67IUHceduY1BzekWzKqgeKwWcIWVvXag0QHUebaK54vjZqQe
 Im/2yuAs3JDmwIr+tihj5R8A2ZGwEWZfeF39FB+1O0th8qVyTIECk4uFfF5uDdWm2md9
 I01nwu1n+ZP3+yORAMuBZ/KkpHa+3cYJiJpIEbnpuuKIZ7mFPjMj3wCcicfMbYtZIDP+
 sfY689yq1zZUB2LdHmAs4LqJJjmx7zUJXvxpEHYT2oYsx5HxZoIF8b+zo9tqgu/RvEyX oA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722c5b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:47:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q8vsgf037279;
	Mon, 26 Feb 2024 09:47:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5j123-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:47:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgLR6kMv0fPnJ8ADGSuv5Po7VTE4Xa/bMGZgJQ+jsri0ZJN1RdpWNR5Pp7/craHei7qHYiCqnCws38uhFjz/0f1xcGXYRabBnHHAUzUGcjCyW2PSDXGwj3VeybmXZ0ibue8ddmpM/xja6zq01qCP//1Py+LDg7ONWUMK/wJjzWd31m9d4uJRzi1P3h1A31OA4ph4iWhkyzaIprdseAZca08kD5bguj3pfXqJx+NDUc2hmmvaUnlsVkdvxE4auHnt4RkRv+J8yBcrxuermwQFe7BdkjzVpwHiq+irfJjPv8TWPhFxGqa2dzg4EZK6FXD+P/ltDZ7INYA/p8TkPE4xkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJWM0mUNtw+HzR0eYqt9C7/6OtQ9L0nYdVwfID624JE=;
 b=Q1ICGutsT6rDgcbSnsLUFYJTPxwLoSPKoiVLYjbeXG2Yecfos4HUA4QJ7TJit2G7aUDuoF/rQnhIJT56F5C/vI823K0XZsbC8I2m1NgWye0FZxH5+NBMBGdguVlWwzmouXpnjsiFQZqm0qNtnBKfMv8SvmlBsKemLUuZ4QB2OxBylNOCoR3tq9pczO2HfK4wQWUkUNOAWCirBk+UBh6sFwvpb2uH6Y6v+pLoqABWu1P0OrUH8ss7b4tBc5rb8edydBIGjiUo/uwmtVAlSKsJjU0B9QC4PrBMcGJv15tN4Xq2Tra8pL6ite6YDue7MqbdG2pPf7s+/hN+cD4p6f78pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJWM0mUNtw+HzR0eYqt9C7/6OtQ9L0nYdVwfID624JE=;
 b=IC1VGCIpOw+6F3iM2wwiCjTXlJgphJbdxDdrDaTsU3z3cggdZ1QNX+pXhhXK3t/PH3KIAOHvh0EYny4wFPyMf4zHAINsVD+9guU6A0wQPKDT54jddgVyghsn8oliZHC5Q6hANPodXnNT/kGGgcnsx/GWDOB80sL5q+bI3Etjtt8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5999.namprd10.prod.outlook.com (2603:10b6:8:9d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 09:47:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 09:47:01 +0000
Message-ID: <b9bbc1b9-6dc2-48d2-a4ae-4b28516e4131@oracle.com>
Date: Mon, 26 Feb 2024 09:46:58 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
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
        nilay@linux.ibm.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <878r371tce.fsf@doe.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <878r371tce.fsf@doe.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3ab82e7b-0458-4a42-47bf-08dc36afe163
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9y/MuJx62xNCCB63MwipM55XMfs0DUUAzWBoJLeYtmv4bteVjvZoEI3hPjL/dZ3KnbOR0OQ6A90+dZcZ7CjNX/A5aIY6xdjb4hZKkGWM+eDFEMocSp+4PELPqlohoW0g2mxBSwTLTrQ2Wx1nNj1zIqdZr7jbitwSrABJinL+WDplDgemdNX4WiiaF1fBfU53JTaxhxBSKcYyBO7wGd0OPNJboExisc6NsYVJDNRRbUp3W1qmEkyvRk6ru1WhMFIAvPI8QFkMvarkO+MJBcCcGuPT79UpY/zxLyGfA/ieBhTxVOXiT87oY5nnuB9Pr7DBALXc8RUWXkc/Rf6cv2sjP9CcYdeCCZFdK8VoEdHSmn8LlhKvumtY+3Ydj0zAynwKtVtDB3P2WES/NAX3qUzNarzKrxEpnFqSczfBhM3BQbBAD4yGYk8kT7jd6LIPq2nyEMtum5J/SkhKBTME3h5gHJL6PEhgo5gx4WujOgpF/3vzRvdCoUcdhDH5ZUKbyeONev0SJuTIlY5OqXfnYW73IAJrKj7UiiKyhS9nHS+vzaqur3yb9TOaJEP+ARF1vTcjKfCOwr2hxKX7VWoeCmvupw7QywB/rcIQv7JZdqQhFfO+VQPbCXFp506uphYxDX9k9V2PbL4QFkcXwNdGyZyAV+5VK0ii9Q3Ax+COWl9NJ5P0cIthhUknE5egSnASOZNol20RpiKdSVf6MIPQVa9s7Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZWNPcnB2Rzc5T29vSGQzV2xjWm8yVDVrQ1plTFpnZHFVOFY0MEJKU0tkem5p?=
 =?utf-8?B?L1lSdFY4NHR5U2dKMm96VkVWRjNQeWhaanNuYXdZMC9EWHl0bjVlTHRnZlUx?=
 =?utf-8?B?a2x3dkQxQW1mb2cxRGJZUXh6cjliTWJNeTdoTUQ2VlZoaUJjRmdHdEtEdGJs?=
 =?utf-8?B?RklwTWw1aVhrblBBbWhxeHBjaUdXditMam84ZG1aNGlwRW1ubmpCVmJTd0VJ?=
 =?utf-8?B?WnhPTTJZTUhaNEthVGRKazlpWnIzTEdhdW9jdTZFWXBtT0tlemtCWlJaV0ph?=
 =?utf-8?B?TGt2MUZiVG9LY04vVGRUU3ZJdU44ZXNLZWcrZ04vWGZIeUNweCtWNVQwR254?=
 =?utf-8?B?My9JQnhnbkpEcTc1dEZkaTVyMHRMWU9MRlVyVkRYbkVBTkIzK1BBR0lteUcr?=
 =?utf-8?B?bkkraE5RRFNPMnFmd1p3WW85cm1XeFNxQ3d3U2p1eDdyazRzdVFUZThvQW5Y?=
 =?utf-8?B?ODhVUWNYQjFYTkRacUhROUFzSEZjeU5nRVF1RkdKSEFnUERzRUdvM1ZwTkNv?=
 =?utf-8?B?eDc4R0dYcGNWZ0UxQ1hVbWRBYkdoVGNNY2pXcDQ1UVl3cnVzOWo4SXlqZW9K?=
 =?utf-8?B?SWJ3L05zS09EdmlDeE5OSFd4MnBOcllaRTBvcDBraURwRDFiUG5NdHF5MjRR?=
 =?utf-8?B?c0tOZHY3MzY1clBJV2JOdjhXbGNhOGpoRjVJbWFXMUhUWjBCQzBsR1VSUW5Y?=
 =?utf-8?B?L3VyY2srTU9mY3IzQWJCVTNjQm1iZU9PZFFaVkYvdW5nTy95R2RDZjQxMmRl?=
 =?utf-8?B?QzYyOEovM1ZKVFcwbE00eHRNenQ3TVRDTldsWnk3UjFsZ24rdUJhWWVyWndR?=
 =?utf-8?B?ZU1tZWVnV2VOUmFabExDdzVFdGZpWlJPVktQMU9KQ0R2cWtncnY2NGY3dXdD?=
 =?utf-8?B?MWpVTDJnSjc0c3NRYVBnWjdSeTE2OG15SWFHL0hWcm5QMVBtRW9HZ2huN2Fn?=
 =?utf-8?B?UzZQOXhlWllMb1JOQlkzc1oyU1p1WVZTUE5ZT1hNa2h1dGtRZFJ0Zk9DZStR?=
 =?utf-8?B?N3IxQUVXaVA2ZDQxcElmd2FJcFdRaFhPcC9mSlg2NHNKTXBkcDJDR1V2SVRl?=
 =?utf-8?B?K3gxaGEzQkU4cnkrdUxSMi9KMEFwUElhdVRGaEYyaDdKeitmWTJ4WjFjN29Z?=
 =?utf-8?B?bUZvandydW5yTThZM3dwL3o4REhOblFWcVlXRGZXY09rZXdsbGdMc0tWRnJT?=
 =?utf-8?B?YmdzMkJNV1hyTDhWWEMxV2IzUXRqQTlHeW1xVi9HbmVmYnFtTjNBZ0NPWW8w?=
 =?utf-8?B?NDdOZUpaTUtTaEZ5L1hSY2psckNPa2daK0xyRXUrQVZBRE5KcGpzeUJ3R0NO?=
 =?utf-8?B?M21BNGh4b3dDTHR3UnhDZmU3dWJ0MEtsK1VZNWx0RnpUUW9UK3ducGNnaUdC?=
 =?utf-8?B?aGV2bEpZcUp3a1RUUUhpbGUzdWhEcnV0eC9wODRxNW9teWpDaCtUeXExQVRL?=
 =?utf-8?B?Mm0wT3FwSU8vTzhRenhsaS9PcFhJNDFpS2lsWmdpZGhpMkkyMWFqaGRWc3Az?=
 =?utf-8?B?dnhTbHpTcHhEQndSSXY5RXlYWDdVSFkvR0dYd0VPY1hnZ2VDQzFKdWkrSlFV?=
 =?utf-8?B?U2UybFFrcHlMMiszSHp4L25qb0tZc2luRW41VTRrRkptOXBESVNvS1h1ekVr?=
 =?utf-8?B?TnhjTUN2YnFBbjJqbnB4L3pkaTdKd0Z2eVJxM1FZRDRYRFZhMU5aZVVMNUJT?=
 =?utf-8?B?b0JkbDIyQU5FbStUaCs0UW43NkJ5dk5ob1M4TGhncFlPaUcwMnZ4RVRsM1d1?=
 =?utf-8?B?ZEtxWHYzRllCWVJ2clduN3F6VWVEUnE1RkVLQ3BqanRHaTA0L0hTSmI2bUZ3?=
 =?utf-8?B?TXdDZEg5OVg2cEswWEFMLzNsN0FhSEMxOUpMRk1KMFA5b05sdUJiRXpXSXpS?=
 =?utf-8?B?TGpOciszYVRqQ3ZUU0RxQnZwZUQ5TDkrR0tHdE1qZjRlUlpOU0dId2txZWho?=
 =?utf-8?B?YTZqYlJIRkxVaDVhZ0RrQyttS0hBV21LanRYdkRyK3Iwek1sbS9aTDBOOHdI?=
 =?utf-8?B?d25Qa1VLbHhjdGkwdjJDbURHYzVLOHE4c1ZFekkrdEZKdkQxM08rdUFEWGVZ?=
 =?utf-8?B?RnZrVlpSQW1KcTFNOURTSVZmR1VqYXpOcTF2aDIwSUdVaUZBU3ZlVitpUnRv?=
 =?utf-8?B?cUVOYXFsOTFvVUc3bDVPaDRjK2w4RlNQanBNWHA0NGdsK25EUGQ4bElHazFI?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Lpn4+KUGOu4z0fauujmXkA15fzZVlF4rZbBn0kow1ag9IEpDFQjWXDfoqB+fIRe8udLN3LliXEYmgodlap76SLjE1FzM8A+JaxbsAhS62CbzC/zOVyT/eopK8EKG9YTksfkETjZipxqPW7g/s0eospkgRYszMjxoCX47ratU5B7vGasLP0eNSV6q5XEtRKhAErYxzbCWh1PyAp6NgR6Ftl0L07RcLPtW2uDxb6r2lQzno7hpIlv44RDN4t4OABPO9AeBXDCdq8jLbTzeZOclkg5AgJQbpXKIz+FOSSE0WULRpPk7tZmJiW3E7H0Zwditpn3tLiIZ0rwjLYVmOqB9TPyIRCRj8ox8beFUaqgMJUaF5x4sU7LxCXSSVPZMiVnqb6BHuqFT3QUsG3Gdgsz0FRVbWDlcpRARBziJy/mEA6Tcl8lObIqS5PN9p241fJheC4ggEo/iCTnDRq7WZATbfNb+GKOBxNQenkynvE9UNM9upcbrvqJM3bp6A44yqaeWXbjtVMev7lwJlfisQp7PNJ2aUYfDe2FlRpxwMoC5xm1MarVP6rZSGaH43b1P0uRJ/dk/QE9yzjRzHq9dkzOHhO0jrFYykgnjiFzJcLoiXzo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab82e7b-0458-4a42-47bf-08dc36afe163
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 09:47:01.0513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q088fEmSBqfi7pFwjUbsiaFjvifC1dSpxZkwLMSZDIVFopQiaTHCP/il+0hTuI5jQi9G21DtKKQ8d5wdpUof7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5999
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_07,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260073
X-Proofpoint-ORIG-GUID: maucKdwenRrHyx57bOKWzv35Qe6WprUg
X-Proofpoint-GUID: maucKdwenRrHyx57bOKWzv35Qe6WprUg

On 26/02/2024 09:13, Ritesh Harjani (IBM) wrote:
>>> maybe generic_atomic_write_valid()?
>> Having "generic" in the name implies that there are other ways in which
>> we can check if an atomic write is valid, but really this function
>> should be good to use in scenarios so far considered.
> It means individual FS can call in a generic atomic write validation
> helper instead of implementing of their own. Hence generic_atomic_write_valid().
> 
> So for e.g. blkdev_atomic_write_valid() function and maybe iomap (or
> ext4 or xfs) can use a generic_atomic_write_valid() helper routine to
> validate an atomic write request.

ok, fine, I can change the name as suggested.

Thanks,
John

