Return-Path: <io-uring+bounces-2268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0D290E50F
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 10:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D24CD1F25762
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 08:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2ED77F12;
	Wed, 19 Jun 2024 08:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KohsGPPu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h2phi3+8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B66F2FC;
	Wed, 19 Jun 2024 08:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784025; cv=fail; b=ihbfGuaUMsl6rqT3d25Q2Zb1APRrhKpF+QDe1J0muCg9mle5JZHxY0jnucJI6wOkX5+z24xzs+ATR3YrvVRhpOjkfyW2RWFagrZTyWWdrGvGuahrABKn9rE2w1JfcXG1KBaZf/YzIDnnekkIRjGNMjt8VD8bDBdcOs9cMeHzLeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784025; c=relaxed/simple;
	bh=PxnWbu7W/k0DBQ8iwLDuN0elsnI5fS8/x0T6PJIHhyI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YHO4Py++BJJk/Ow80k9Jad6J7w9Af7jBGvLR/j6TS1S2Hpd6M8tjTxAUGzs9xW2c/uS9p+s6DwefrNAeZqO//EU3TshUs8PQUfsDYFp7kgHmJ3rQWYpENz0qJheM5n/2CWzmuelmiScVFFU51j6aRBYIS2kk7yQJpH0dIqQNrqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KohsGPPu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h2phi3+8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45J1tXtR005086;
	Wed, 19 Jun 2024 07:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=4N6+5jGpXdQdd4bv/0poq++dwYQYpBBRndtRTSZDNBw=; b=
	KohsGPPuoEqBU4X1ukbUMxgvxi1a6WwIY/pTpVMCsLfmGntjZVER7S4Gy8v78r8q
	4+LzwAF0Z4cbp7xXlrrDgnMhsNLn+jcS3+nVVOCkP+xtPjVgFkDrySiTwC3pS5iR
	/1cqJtwbpj9NpUxmrxSpalU/PQZXTVOjsKrT7ivoGpZtn2+3hvnuy25vcozAyzCE
	5Y7uzj1kLpvn2epGZoai5z+fJoMN0VUgfo/ldjUynVz6nrUhA8OvIcjja5ZUKy/W
	X7vKMVr5VHfm8LPhIxAE7eDwQ6b/LQIna9Q/X5UBAS+HJNakP90Yg0W0OymY5Fod
	ANRDz2n3a6RDYzWMmVskQQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9r0q2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 07:59:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45J6Dcsw034831;
	Wed, 19 Jun 2024 07:59:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d982g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 07:59:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkt3jq0hTX60WfBIaWhvOF1JZT92afQv9AsXkWnDbbExWE7D288O4Eaz8aem9YtWooa2LyKzZSyP0lqdWA3hZvDuwLigwVGts3sfBw3tw2jTN7e8b9ohWse9Kdr5LiH/cPzh/Kfsm74CZGbVWlPbLHGDUn/PL/qwxzQKSvwWsSeNYH+zibXEmm8POevVLPqOPWW7/oKRWPegadk91QOJ/s9PGwbk5OZJQAcZHCrz7bTwd+SH9Rkj+LXZ1YBHaeEGyT9OSIqik+ejZcp958sx9eHweB2x3Rh6hqnNbdwbK1nWXjaMofDxRG8hBRJZ5IkYyclD4JNHhwSHMZJKGKBAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4N6+5jGpXdQdd4bv/0poq++dwYQYpBBRndtRTSZDNBw=;
 b=WkRtg9rWCm7Hq6P2/7VWJ0oX/esDcYDQbmxQzi1sWC2SZ2T4catH2NQI7rf1tL5Q5s+FhymBuqaiRN4Vk05S331FB7UH0l84cwvbWfrE4wcA3VuZ07OJ6P9v+xQj7Bzug/QCzb4x0mKEnRBsOGofefxnqglJxe18Gcivaa70vyKK/mB6SsbE5cdVZXbIjViZD4gkiVbyt1x/OvCUWricFVDSfc3ttHmfTvJHBYeHh0T1IAsOmgBdEb2EoN+7Vz4IviPcrGYm4yJ+nWVVmFM4f8OzzOUsyclymngfZkdS6QEl8AfGE6N4j7PT8IU6++iukyRhVd1K4Ga3VVi8ZEnVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4N6+5jGpXdQdd4bv/0poq++dwYQYpBBRndtRTSZDNBw=;
 b=h2phi3+8GUmT64VWoyclyzIHw+gyIToKLlqkk5Aum08b1QS1fRNcZTlS9UCDu6IGlk25Z/nhkL0txJa5X7bIWrHymRBD9xxUrqb0G5VXh5lJTCd37rYekzal7ZJOSysiPol4weXt9TitJewZw9zUaPAIDtbMd8PuFK2RRVjWL/E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6615.namprd10.prod.outlook.com (2603:10b6:806:2b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33; Wed, 19 Jun
 2024 07:59:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 07:59:39 +0000
Message-ID: <24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
Date: Wed, 19 Jun 2024 08:59:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, sagi@grimberg.me,
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZnHDCYiRA9EvuLTc@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0282.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: 6405b2de-20d6-49cc-0f92-08dc9035c52c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011|7416011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VFpDRzRxQWFmOWU4Z3JPVExNZFBuelhjWXNPcnJiREdRMlRaRmpVdXVpOUwr?=
 =?utf-8?B?YTFkUUFQV3oxeUtmRG5mSlo4TkwrSFptRjE1ckU0cVRpaVU2MVFTQXFpOEVN?=
 =?utf-8?B?QVNzTi9wVkNaeVZrZzZoTDFaY3JqOFdFdVkrWlk3TTNMV0preTh1cmRTV2tO?=
 =?utf-8?B?Vm1BVFJ0dWpaQnRHSWxHeSs4aFcvWTQrdHhmVUloWXNuM2ZHWjJUWHRNQktU?=
 =?utf-8?B?T0pxVTZjOXdIUEF0bTJmWXFqQ3lpT2xQYjdNdzJheUszWkJMcTVMdEphcmV3?=
 =?utf-8?B?WDZ1VEZQZStzQjlYSGtLVHlXTzliY0QzUElKTU5aamNKc25iUm51NEV2eEFB?=
 =?utf-8?B?bGlYQmhhTy8yZmxXQmFnR3U3SU9rVjJCcXlpU1F5ay9jNlQ1NzRRVzl6eGRw?=
 =?utf-8?B?WEprRngrUlZsc2pCa2d0eUhyQVpsSitBYk5CY05JalNMZWJrclM4dWoxQmtY?=
 =?utf-8?B?Um1Xb2h1WXRwVVI5NFd5aldYNUZJdDFaUUhhaWk4VXQyVnJZNlZlWkw5Ymp0?=
 =?utf-8?B?Vm9yL1NzWHgrNlBhY3gvZjBlVFN1eE44TUVqVG5vVGc0S1dtWkpPTS9ud2tF?=
 =?utf-8?B?aWlQcXh0NmdxbGJGQzBqRXNlcVJlTDBEVGs3MU5Bd2RXQXNiZ1JyWXM3YkFt?=
 =?utf-8?B?STBCT2pzWWlGb3puZzliUk5iYjZhU2hCQWFBcm56cSsyTjE1SGhHZnBSZ0xn?=
 =?utf-8?B?dmMrQms2a3JwU01LdGJ4MHJ6OU5sUm5lQWNVU0dZSkdLSVhLSUtVVmQzc0x2?=
 =?utf-8?B?RmZWdHJXV09IQTZrOE1kOUc1YVp0TmIxQUZHV0QxdGtad2g5NXNRZW5jVEx2?=
 =?utf-8?B?VmJya0Q4blg3cmo1aTlDeGtQQzhoelQ3TW5ubWJCaTZNeXRCZXZDN2hJbHdM?=
 =?utf-8?B?U3d4M3M5Q0J2SFVweFJORVhZUmpxZUoyTEYrTHZidjB3NGYybXUrdjdPTlI2?=
 =?utf-8?B?Q3M2aDBLU0RlazF6cHFLaHRSRHBqRnlzR2ZEUWJlYTZEVEprdy9nSzZBeUNN?=
 =?utf-8?B?dlE4ajJxT2VLNEFUbDdBb1dzK1Ewb2ZhN0pXMHpWcG4xTDF6YUdyK2piSzZB?=
 =?utf-8?B?QkVnNy9TMGtGdVFzdllGTVpBdzFEOGtkYVRrT1lvM3RDc2F4bzBFSDFEVjR3?=
 =?utf-8?B?ZjVIeEtISlNyV2Zhb2FiQk5kRnc5R29YZXlJM1F6N1pUTVJjSStSNjVYNmNq?=
 =?utf-8?B?aFN3Wmk4YjM5LzBQSzNCRVdjSExwVEFOZC9JRWZud2pqRUwweXowQWdJcGhv?=
 =?utf-8?B?UVJtYldiWGJGVjJZNnJiWnVUU1ZGRWpBT2xIOHI5eVJWM2VDbHE3am9yMWVR?=
 =?utf-8?B?aDF5TmZhdmwybFM4cW0wY09WTi8xWkhBN3JnNlVVcVk1c2Q5L1JqZkowMDRQ?=
 =?utf-8?B?V1NSNkNlQ3R2dytCQ2ROeDRlVGRSdmk2VU1mVGcvQ2JtdjNFMWl6VEFlYXdP?=
 =?utf-8?B?L3VYenI4M1VYOFJVclpQd2dEbDNLUFcrMEUrV1J1RndMNFVUOE1xMjhQS0lr?=
 =?utf-8?B?d0NLNUI5d1ZESFVhRVludm5DakU4c3lqLzJ4OGsyb0dQQzQyL1JwY0thQ0VK?=
 =?utf-8?B?WHVEQklsdy9JQUlJcHE5UmI4ZjZITDhoRVNvY21hOWpwUEZPanlreEwra3da?=
 =?utf-8?B?eXJNZWoxSTY4QmdYNnU3NjFsWFhnNEpHdDNDM3FsTWluVUlVb3pZbVNyTGlE?=
 =?utf-8?B?ZjBMVEZNQVZTa2QvbEsyR0Y0Sm9jYlc0OE5lN2JFOVpGSVY0WXhtdk0rYmNj?=
 =?utf-8?Q?mT4wm2LfXLVob3HwKn8vNJJcTgxoYe8hkQeE6Jn?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aWx2VDVCYllBQW9iYWNVdHY2bVd2M3JRcHdlZFppNFJ2WjFOcXBFMlFoYTNs?=
 =?utf-8?B?WVNmSldrbXJxaHpiUEZqN3VGTTlWMjhqUUxXMmxDaWVoR2tseWlpNGt4QVJT?=
 =?utf-8?B?cElqVEwxaVlWQmdEam9SbTlodFRGcEFQZ2dMK2d4a0pmeFlJZWVkL0syMUVG?=
 =?utf-8?B?QUY4RkUvMW5jRDF0NXZSd09jTFhoblhiaFR3M2Z0MVZLSDdvczVyelE2OTdY?=
 =?utf-8?B?VnNGN01CRVFUY3hCVjhUWGRKeHdwMG1LSmtVSGx0NDl2VXQ1bFMzbE9YU1p4?=
 =?utf-8?B?cnM2aDYyaGMzQnlZTUtKZTdKM01Dcnk0anVqSU5zdFBSblFBU2FqOU54RWtV?=
 =?utf-8?B?ODZSTmtiWnpWNXBpSFEyTWkvVVZHMFdNeEJUQUc1UUYzN3dtRURWTFljTExT?=
 =?utf-8?B?UEVTRmZIcmk4b0JEWHd3eTFCNGd1WkNzK3pRNDlBSWljd3BZVE5EK1Z4Q21j?=
 =?utf-8?B?RW9xdEJNdFJmWHQ3UHUrNDl1ZjEvVEs5S3pWSVZFbnVYS2szenNvNkRqb2tt?=
 =?utf-8?B?R2xKVGlSaEh2Tk5NK2p4cEhSclRrbEZzcVdFU0RIK0hUaDFFNXQ4cmU1QTBD?=
 =?utf-8?B?NVgvK1FBb1BqemdkS2FWSTVIOUVVbkdOMHlxTXZ3M09JbVNoc0xMMHorYnFG?=
 =?utf-8?B?akI0WE9DOWtoK01pQzV3bzFkbHBDMS91WUZJWDJWVWRKOFFRRHF0L2VtcUhG?=
 =?utf-8?B?UE12MXdQZ014ZU1aR3BBL1BtTkZRZUdRMlVjQXl3RTMrWFE2NjJRTnFaREhw?=
 =?utf-8?B?T1gzTWN6VHR3c1BjWHRnRzR3Uk80U09QL0QwSkdvNFJ6ZXV2WUtteDVWdkZT?=
 =?utf-8?B?bUJ1VDQwMnFHMkxFS3U2d1BuMGdBZ3pNZmJ1UktzVGJ6Z0doTENoYzBUSnBk?=
 =?utf-8?B?TmwrUjNqQUZ3aG5MaVB5eVRrRjJFUHdjbXZPLzc4WUtWNFBvTFNjd2pHdU9x?=
 =?utf-8?B?YnJBQWs0Vnh5TklDRDlSTy9Ud1B2MzVMbE5rWkpuOHczSElUYWlRTDZjaTBl?=
 =?utf-8?B?VzM2SzVaa3o1QUZERGl6Qk1ud1ZzY0NPOG5DZE1QeDl0ODBWS0p2ZUI1cXpI?=
 =?utf-8?B?MjcxRTh6SnJJUjNxVmt2bHhWTFJWcWxWdW9JTkxJcURLQlZXZU43eFVvTW1X?=
 =?utf-8?B?U1Jua1VaQzBUZmRLSFNabUJYSWc1L05oYUQ4RFUvOGFXMW5rUjIrZ2kxcndR?=
 =?utf-8?B?ZjdGY0RFTlVMeHgvQkVXNzhhbnRPRTdiN1FRNHdvMEgvNDltWU1mbTZrZHVF?=
 =?utf-8?B?Rk5KQTROV3huU0hDS3RNaWs1bTIxM0pFVmduYmd5S0lHRmRuUE1OclpCSEQr?=
 =?utf-8?B?WVVrYkhHdDNWeVJleUJDcWhxK3I2eGlEQ0x2S1g3bkZkbWVjZEplNjBoc0I1?=
 =?utf-8?B?M0tSNjFMeXlkZjZYa2JnbVhsU2tqVFJ2SkV2a1hxY2t0amFJM2FwSkIvTHVq?=
 =?utf-8?B?SC82Vm1DNDFxVVFJNHMyTXhHRlFPSWdCKzQ5Qlp5eWRVcTA0d3J5RU9VUTBm?=
 =?utf-8?B?YzRRZExmdWl1WUhMYjMxZTFqRnl0eXJDWUlyTHlxTHFaRlJIclRSdXdkeU4v?=
 =?utf-8?B?U2tPR2dCYmZrNmRhKzFGQWFhWHI4KzhqR213Y2pCMzRBN3BxZlRGYmZyeDVF?=
 =?utf-8?B?Z3k5Y3djOGdQVmFwS0wxWlVzcmVEdEVkNjZER0hJZllmTllFV0NMOHArcHZr?=
 =?utf-8?B?REo4V2J0NHhFVkFaMTVNYngxNU1Yb25lVHc0TjRDQkgrN09ob3dBczRTMlZy?=
 =?utf-8?B?VGVaZXNWMXAyMEp4YnRPL2JkYjlmVHV6aVF3bUVkR0phOXpGTXRDdnl6eTU0?=
 =?utf-8?B?UUJuaUhzOEVKaDd2akZYMXA2N01TZTBsc0pweGhpTVZXenhRNllmTUI4Smt0?=
 =?utf-8?B?UUJJRTBvVnBuaWVVUTRtRUZKQTd2NnljOW9CaCtoTzErUkNQMzJVZEUvYy91?=
 =?utf-8?B?eHR1aUduRWdaMWRTQkV2S2dnZDVFRkZJTmYrZ2tyU1NhdEM4NkZKdkcvRXp2?=
 =?utf-8?B?cU1lbTM5QkZ0S0k2aWgvK0NOUC9uNEdseHJ3U1lJS283TlM5M2NyV013elBj?=
 =?utf-8?B?a2N1WVQ0WFRuYzAwbk5HYUFMbGNKMi85Z2YxQk0rMStvdVFGcG5TdVB4WERz?=
 =?utf-8?Q?mCL8k+irGM46MSiNTH5YPXwNA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UbL/1SXOY4GTTjuWPpgMm7QMgDogXyEZ246XVNKkfcSTACnpFKDuWH2GUU3FxHA3TJWSqQtgox+AeMKjH0PsKmfw7EPjoYzNPrB5j7YvMNclA4u2qbycG6J54f9kKOaUgxIj4IkypLAqjObHcuxObGqHWUAo6v8VplgxuV2kSAIK43w1c4nNyhsH8BU3tRkg3sfIoR9tO6kUawPQxx2fvXSLdLIx+Ah+uAkyFwx/aAeKMjiEc30FglFTqy3WSTMaDcU2o6Nozk2USVyNk5OtbmkG2eDbQhzbvD0fbE7C4MHhJH3OFvPRsNlkrivnQDxlVpH0z7uCyIx+RgRNamnHy3UmAYzx6mx9xY00KrkMU0QzfOAdscTBSqo64pc4HyHnhR/5hG3SJRH9Rd7/R1rhSmZKkSv3nBr9ZhrBkNxZzBeY70SlHqSxa+uf3ZJXWlPMKYS1UzGiBnX6Jiv8YX6hJVZWg+jhr+toAP1XRsr431oqIysJkXdkCoe5YmrysS911iQNkEygQ4Wa8ZVcZZ1VuyD74U5T+BiPZI8clFyUd+wyZiZTFkr5Z/mhjC8C6ZJor0SgNhJkW0Lo8iEran34XTC44623YFBlALR4ZtsS6CU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6405b2de-20d6-49cc-0f92-08dc9035c52c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 07:59:39.8514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPDgv1zX5EN21PmhDRcW4Tf+TqaT8EGwlwXUGi88F4PZfurjupOzvG9aVFTFFkORlF6naip9iTevaGPTPKtTEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406190058
X-Proofpoint-GUID: Eh-hUpn75HL-w8ie6QpJjE2wF58z-MuP
X-Proofpoint-ORIG-GUID: Eh-hUpn75HL-w8ie6QpJjE2wF58z-MuP

On 18/06/2024 18:25, Keith Busch wrote:
> On Tue, Jun 18, 2024 at 08:46:31AM +0100, John Garry wrote:
>> About NVMe, the spec says that NABSN and NOIOB may not be related to one
>> another (command set spec 1.0d 5.8.2.1), but I am wondering if people really
>> build HW which would have different NABSN/NABSPF and NOIOB. I don't know.
> The history of NOIOB is from an nvme drive that had two back-end
> controllers with their own isolated storage, and then striped together
> on the front end for the host to see. A command crossing the stripe
> boundary takes a slow path to split it for each backend controller's
> portion and merge the results. Subsequent implementations may have
> different reasons for advertising this boundary, but that was the
> original.

In this case, I would expect NOIOB >= atomic write boundary.

Would it be sane to have a NOIOB < atomic write boundary in some other 
config?

I can support these possibilities, but the code will just get more complex.

> 
> Anyway, there was an idea that the stripe size could be user
> configurable, though that never shipped as far as I know. If it had,
> then the optimal NOIOB could be made larger, but the atomic write size
> doesn't change.

Thanks,
John


