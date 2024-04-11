Return-Path: <io-uring+bounces-1504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D338A0BB8
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 11:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5FE01F2481D
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 09:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B284C1419A6;
	Thu, 11 Apr 2024 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U83YjrUa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VjklxB4E"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6CD62144;
	Thu, 11 Apr 2024 09:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712826047; cv=fail; b=EDcDEKYL8IEVaC6i8QdrCyisWE7KBz3Zqa2U5/3X/IBmpm4nBnGYJhYGLYDf0nw85mnwFxSXpQnczTTPVRdi45KNQWqhOKtSYCtONOLgA4f6CAQ6wnbx3GHMwFHsZrew9p8vAIE31/kC7s6NnxcYykW+LDASCHNfMLqZIp2Wa0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712826047; c=relaxed/simple;
	bh=9j3da7PfxveOEODjS1ujcBGFXCyShUjiiMg/cLM0Vlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L7YjETiclfnXQm9chSQZcLBGD0/RhH7oqm5T54NxNd1ti2o4g81tMF9dWNhg2YlgPqXF9S3tncAtehl+rtDFEUvNaryFKq/FbQZkrHFYFo3W8lnw7+++RraYa97feYZN0QK2Ynr04WB8pErOGBMz2AaaeUxgZPNQWu3WCV2gsqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U83YjrUa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VjklxB4E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B75ggL016184;
	Thu, 11 Apr 2024 09:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=rU8T6E9XCEcte3A5IrLevqAugVkChC/EHDyt2LMqDwM=;
 b=U83YjrUaR6thJPPOnDn3ca1L4nsbrgWRL5W76PK0O3KMJIni3237PZnR9dDQKBeGmuO6
 Gupg+7yWji27E0KS+ld3r5dbhryRBMJAf7HbGqLfTe2iwq0yOS7KeBnpOrNHThkFFytT
 HxeXtXzjOvtsD31NHtzYNqcChPD7AOhrYzHyE9AY2eKDWdUa3xgte0BXuCB/Ow023z3N
 vtD4PVmM7JZaKmDM7giKblAOyu+vu0O8LF4EhArfA+tq+4hQ8mhIErEQAEi9sqy8iADW
 s5s0tKK7u0KBf/lSikhpwOQIk9LvoAIVWbEBFIshlVhbHpShYkKT4vDkIed7RUH9L+n4 og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw029825-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 09:00:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B6IKhQ040105;
	Thu, 11 Apr 2024 09:00:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavufhxpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 09:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuOYsC/eb5jLtm2zGZJhDoZnYjAzbKBznOV1WL2zDnbY6NSLU903tLOvzhlPO4nEZQlQLEJSRS6uKuZsLXPLr04vvKpjuiCBcksKnEhrYOTxuAeXIpxtIpyseiCfIZ7E30KiFSuu5HaHRbSdyZC8lubgasiQ8OZyIUNiNbZ9BhyQSejOjFhzVNU0ADwRnraBSc/AnmCuugkxEr6bzHzKTjT4irf3E/QCPudoL2/JX72PP0CgiYwnMi4df4oAoo8oB8B/JGKugqH3afCEGAHwWxsJYWdeZvXrpIjbEB0taMMSyt/LvDTnvWBvxdpTN9K+vltxAWfNCVsg5b5VZqXMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rU8T6E9XCEcte3A5IrLevqAugVkChC/EHDyt2LMqDwM=;
 b=jn56rdlY/2WUUmgygLTDXi6nGQQmMQPH+4lNNlTuAoTRKflr2Y4Mt8zgHncWRhc0a4JisTHeKzMcqGTBDkfWzXs7iYFyqlparirI72ripF0xOL8VAaKqvdjfjESx6fXOOiImT6o7ivnkoT7VoVXMwTAUFeT3bZu5hj7CRVmY6gdG+nIiJLry01QEA5uW0hcGrkiGm2H0RPK+nW7bm0JeZ8rYm2B9e7uvlAw3TFHKYmzVRa/CMPdVM3fwh3O6xnSBtscL3OE2Nb5lXbG78wzVEXCIjQIYszUgVWz08qcwwpLKkoNUg7fstiFyxGbzU0dG8xCOWBo+BiarnC8qsiNmmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rU8T6E9XCEcte3A5IrLevqAugVkChC/EHDyt2LMqDwM=;
 b=VjklxB4E85DrydTjXc0HoRu/CX3r8AeYNPT1dRooJ2ffTKXNeeuOkmiIW2HewbDZcDZnVluLT6QP7zO4VC/vHwdwN7Hmx/pZa3E0MCiNvuH+y0biT1x8RG31Y9Aipn2BAIuJEtYwaBgJNBGp9euqhVVIglqojhf/82TDYquwoLE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4721.namprd10.prod.outlook.com (2603:10b6:303:9b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Thu, 11 Apr
 2024 09:00:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 09:00:03 +0000
Message-ID: <143e3d55-773f-4fcb-889c-bb24c0acabba@oracle.com>
Date: Thu, 11 Apr 2024 09:59:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/10] nvme: Atomic write support
To: Luis Chamberlain <mcgrof@kernel.org>,
        Dan Helmick <dan.helmick@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Alan Adamson <alan.adamson@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-11-john.g.garry@oracle.com>
 <Zhcu5m8fmwD1W5bG@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zhcu5m8fmwD1W5bG@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: b87b6591-b9f8-4dd0-6a1b-08dc5a05c68f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ud+3b1MlJnSFkcDo4rB6BREW7Yo4dMRhimxw9mo73aRIZUXXQWDLkp7Mt8GqNKluUR/joN+qzg12waQ5v1hogZYMubf3PoWSX02qWf9HoYrT2n+wHixX1d2YywIEQZZb45sCyNLXlwdfuC3tiO4Qdd1ofKyFQ3UOJZ5qJZ1+8Wa3PNLGzAtAMmLNl/GJTkuKwVS/8ABqiGjfKZkARNmcRpIdiAbUDnVcBjeLfd0Np1ZUtQF6puIIzRHY5JnACxUMnjLwDDFDmAfm6pqEaQ9fNUZ8o2NYYe1Phu+LT3UbfTKLiHzrbSsskppR1NYZ6PWx1Z95PMQsz0O3e1BLWM43Hq8gw6YkQQ7qz5ucGuCtjKYxRdm/GUGorSK36AQSZ/HuPF4yiqs0MwiKNeCPV1R1s48XN146rYj2HtGbHXY/JxO1aXqQnySEMiyGpkus+otvvNTcqWT8zcebM0hqMyo/hLNCLeUggqVM8gM1+m7UsGIyGDi/CRSF55icO77eIK0wu0JcrKI1YE6Erk9K/kn4x0SzunnePrF1FKf71ZTucdl4RuYhq45LioVa6wWyunqp4qdIHimeaFhjPDfwgAQQjTdG997vTpIajUDvFwvXpV1D7OQbxgOWi3U30EgeQTCfqr5przracYsdCVi0Ydwzh/2+z6zXF0qlbcN7reKM9XQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NWppYXR0WGhCS3dHSEkwK0VZMVp0d0QwUHlvNlR6eWFmdVhiL1l1SDNXcDk3?=
 =?utf-8?B?eUVNWUxVVTl0bU1vSjN1V3BmZmJwUkp6N1IyOVJLTWM0QXAxaUwwM2xXMlRp?=
 =?utf-8?B?ZTBOVHJJZXhQRGhlME9HWmZvckFxTHVlMWl1TTBrRnZpakMrbXlNcUFXeitZ?=
 =?utf-8?B?dVZwNVY4b2FWODQ3REtFYlBFcUpMZDlCVDNaeTVXdEhpOW0rQlFxU2ZjZkVu?=
 =?utf-8?B?Q0dPdlFlSngyWkhWdHdoL3pxQ0ZrUDhjQmxCQzdsb1pVcUUyaCtseUZocnNh?=
 =?utf-8?B?RG1obmJwVVlSUU5iTmpTaDRDMnBUbzErMkxkMkh3U2ZUYVMxRVVwR3dPd3Bo?=
 =?utf-8?B?cGJEeU5VdDZBY0RiekVZWHVXa2t1a1hveGc5bDBhcWRRVnNmbTY5UlduS1NF?=
 =?utf-8?B?T2dPYWxpOU5WV3hnaEc0S0o3ZzR4OWlidTJRU0tGWG1nV24ybS92QlNIRDBi?=
 =?utf-8?B?TDRUNVg4TGV5ZzhYNHpyelh3WXRCUHZBTnFaK1RiQVpubWRqNG0xQ1FydThj?=
 =?utf-8?B?T2N3UWNia1pEdERoSlpCWG1ScERNT29mZXMwNzFQUU9Cc3ZUeWJOWHFSeEdp?=
 =?utf-8?B?TlRWS3RWZzFMYVMzalNwaW0zMlhrTGd1a3pSR1ZOUU1XS2o3K0EwTWZlZkhP?=
 =?utf-8?B?VHVMSFBOckhLUDZEVEViUXdQOGc3MHdOcTFrRDlzeWg4MnNNczZnWVpYRXpo?=
 =?utf-8?B?QTVNczNjRXBiM1cweWNIYklHS2dpdDRWYm1MVTJiTS9SUkhyMjZReUw3YzQ4?=
 =?utf-8?B?L2hDalNGSW1uYjF1TmFadmMwamVQVjZaSDBnRlJ5SjI4RmpVL29lN00rSzFm?=
 =?utf-8?B?eU1yUG41SzNVbHBqZkMxb3NIM1JUZmpROThtTnU0WGdJcllITjdoTFdoQXh3?=
 =?utf-8?B?ZFRZa3g1ay9DK1hqYUdLdzZWVHdrWlB4MEpsWWhpeVhlTkllU0J5TE1wNXVN?=
 =?utf-8?B?S3hTLy9NdmxXamN4R2lvOGkyYkpQMUlnZ25LTkdrOUtDMGM4WkFnTUY1Wmxw?=
 =?utf-8?B?ZlBZUDlOdFMyaWJJcmdLcnhYUHlYcFc4RjVDSmVVeWc4ZWxCa0ljaEUxdE5j?=
 =?utf-8?B?Y2VjaGwwNUdLM2hVeTdySmhteXd5OW1Mbm1WeWdyK3ZkZ2R0cEFhSEdYZEdm?=
 =?utf-8?B?cFhpQWZPNFBFaDdiTWVEQkNkZXl1VU5mS1A2OWVqbThPVk5VSldDc3hWYjNx?=
 =?utf-8?B?dkRaNkNFdFJ5dWFYUDdURnBodkFua2FaWTBjVXc0TjRQZlZlRGs4WGd6bU91?=
 =?utf-8?B?S3FBdlozQ3czSXZLUXNXTXhmd2Vzd2NBS015ZEpNMlBkb1Fya0ZHSFJPbWhv?=
 =?utf-8?B?VndMVCs3c0paV3MvdTdmdkRXaklGYTVZNkY2UGYwUDQ3SGJFWlordHZ5bkpy?=
 =?utf-8?B?UDF1amtvekJQTXJPWUZWQnR1c3l0TW5yYTIyZjA4aTUxc2MzTWlTKzhXZDlR?=
 =?utf-8?B?QTJ1aUZrYVBobmgwYnNnUGlTZjRlZms4YldLR0xyTkdDZ016d0FmdGRhcHgw?=
 =?utf-8?B?YUxKSWQ1cjJlbFlOcXVveEVGekRLL0l1L1NaRVJkYkRLUWxxQU53R2tGYnVz?=
 =?utf-8?B?bWtBcG9IZ1lmQS9wSC9ObXdiR2dkeDhWM0c4U3JyVHhlNmVJbTZuQUdYZnFN?=
 =?utf-8?B?MWFIMTFJNEcyakFEOERGczVJR3ovSks1Z0NyWGdFVlhoT2FUMms3SU5oUDhX?=
 =?utf-8?B?cGNRejJwSlFiYkJiTlVIaG5KQVpkd2Q0N0pMUjNQZjcyMEZORzVXSGFqWjNV?=
 =?utf-8?B?MHZUV0VXamRNT2tZQVR4KzdyRXBjYkJLcVlQSnVhaGlOR0Y2UE5GWmgvQ0xD?=
 =?utf-8?B?akE2UFFyQWpCbng2N0Rib0wrSVF1bUlyZkQyNVFOeXNwTWZxeGQ0QXFBQWZo?=
 =?utf-8?B?a1BXUTdmSVcvdU1pYVQ0ZDJzanFjNzB4NUs2enZ0bi9sTm1VdXExdnRaMnVp?=
 =?utf-8?B?dWJ5bUs4SCt1MXl6NVM3UmxITlVnalcwaFg5S3F2dWRqWEhXczNIVkJLa0F5?=
 =?utf-8?B?ZFNSZWY1UE9qR29pSmdldHpMbGVRNTcyc1VvWjNJdW5DbStaeTFuVjNEOHQ3?=
 =?utf-8?B?eGkxK1RsMFUxWmN0dGhvQ0dMVGhhTDgreVBOak9RKzlSTkhPdk5UbkhGU0ZT?=
 =?utf-8?Q?4WEJ9855pfjQGODn2Gc7gsZO8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	JW0LoeiUaXygLYlqJ5f1D5LPQzHWbhMG7pISaVOcb/uG7XE2C83pOYI4Gwir3AOScX6njQuJWMk7oBQ+fp52d1r+dTFZqyQXcna4e3fo7tqxdTNt1kbI5KoMtj1IsqTxqIVp/ZQtIRlP4zlU8+uQ+CJ9c9xCca0Gz00S7nPqRGRC8oegTaTOAzRKHFUwW7sU3xi0AHqtm16Bk6e3p6+JSssAlpUkHA/Pdy0lVoFhzIPr9ajam/l5lAFSp6GvsEtXF+Sx3jdma8pQQzp1uYoIHn71m5NlfGtXSOI4+bO7qZfmEsmdAVOsQMfNylH+xI6c5JnCJZeFNNEUz5yySqWc0NPG7dRhTfmpdvADbSwxQJKh/GzwCfDV6ZxNqivrltUClrV+wWZpcb2Rx0TkldJkoD7KEDyg/U3a0UyICh7C7bliJz7VV1VHqhXqXRLwsCjgU81NoonYqin1G+xT/0+60nUJVx4+4B2ZUtm0xNHP1/jYWcWi6yAI9Dg6BeF0kjV0Sk2Dcyfw1kdAzOJcbFJpzZ38jal+wfZBCFIDhywWVloAmwVCoSj7ED6BOeK0gErAgLw7z4x5nrb2XghREcSFVwYTTADH7l3pwY1lgVhGVWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87b6591-b9f8-4dd0-6a1b-08dc5a05c68f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 09:00:03.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMOTiYIAJxeFA7qLuFkrCjfw9/9IqyFVAOBcmPG3EbGE9/koY4GFhbw5j2u6PtAantqHShKE7Sn7oouY70HKkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_02,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404110064
X-Proofpoint-ORIG-GUID: 1t_S7vx1C-HMNWas5cPLIG-HsFFG7pdW
X-Proofpoint-GUID: 1t_S7vx1C-HMNWas5cPLIG-HsFFG7pdW

On 11/04/2024 01:29, Luis Chamberlain wrote:
> On Tue, Mar 26, 2024 at 01:38:13PM +0000, John Garry wrote:
>> From: Alan Adamson <alan.adamson@oracle.com>
>>
>> Add support to set block layer request_queue atomic write limits. The
>> limits will be derived from either the namespace or controller atomic
>> parameters.
>>
>> NVMe atomic-related parameters are grouped into "normal" and "power-fail"
>> (or PF) class of parameter. For atomic write support, only PF parameters
>> are of interest. The "normal" parameters are concerned with racing reads
>> and writes (which also applies to PF). See NVM Command Set Specification
>> Revision 1.0d section 2.1.4 for reference.
>>
>> Whether to use per namespace or controller atomic parameters is decided by
>> NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
>> Structure, NVM Command Set.
>>
>> NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
>> are provided for a write which straddles this per-lba space boundary. The
>> block layer merging policy is such that no merges may occur in which the
>> resultant request would straddle such a boundary.
>>
>> Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
>> atomic boundary rule.
> 
> Larger IU drives a larger alignment *preference*, and it can be multiples
> of the LBA format, it's called Namespace Preferred Write Granularity (NPWG)
> and the NVMe driver already parses it. So say you have a 4k LBA format
> but a 16k NPWG. I suspect this means we'd want atomics writes to align to 16k
> but I can let Dan confirm.

If we need to be aligned to NPWG, then the min atomic write unit would 
also need to be NPWG. Any NPWG relation to atomic writes is not defined 
in the spec, AFAICS.

We simply use the LBA data size as the min atomic unit in this patch.

> 
>> Note on NABSPF:
>> There seems to be some vagueness in the spec as to whether NABSPF applies
>> for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
>> and how it is affected by bit 1. However Figure 4 does tell to check Figure
>> 97 for info about per-namespace parameters, which NABSPF is, so it is
>> implied. However currently nvme_update_disk_info() does check namespace
>> parameter NABO regardless of this bit.
> 
> Yeah that its quirky.
> 
> Also today we set the physical block size to min(npwg, atomic) and that
> means for a today's average 4k IU drive if they get 16k atomic the
> physical block size would still be 4k. As the physical block size in
> practice can also lift the sector size filesystems used it would seem
> odd only a larger npwg could lift it.
It seems to me that if you want to provide atomic guarantees for this 
large "physical block size", then it needs to be based on (N)AWUPF and NPWG.

> So we may want to revisit this
> eventually, specially if we have an API to do atomics properly across the
> block layer.
>
Thanks,
John


