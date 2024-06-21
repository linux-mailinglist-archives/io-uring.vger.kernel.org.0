Return-Path: <io-uring+bounces-2315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE6F911DE8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 10:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32672282796
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A046016DEDE;
	Fri, 21 Jun 2024 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JZkyH0et";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jjJTt5KZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF82216DECA;
	Fri, 21 Jun 2024 08:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718956808; cv=fail; b=a7u138DieHN8QZW5VyRuYycTlcJLajkbGng397hM3p4dq9wSMcHiJSN1WMVHL9GsPo4mDt92wz2QZdNwiBr2/44dTPw47HgIBq6CF0NXuWwmWAiQv4+ZUMieycJvQ5ecFCz0tJDASlE6Qhdv5thVNC7ERmofmjZWs0/6qJZzgow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718956808; c=relaxed/simple;
	bh=ECh8NiifBZDS2YgXDZG3bmX5vNkFH7o2HKSdhJ84Djk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eMjfQ1BysrEV27KBk3x2OLhneRkIrZLkjUQzb6qP5j98xYtxqepSNHVozh0k1xIEHgemIGN/RktP2wFP1EWVJL3is7AwVAVJdgM32OpO+FMWIHuIvMsdG8Pw1K1/8Bs9aDY2QicibyMLdvUXY/8Z/7ti4DuSIAipQZ2qtrWnHiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JZkyH0et; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jjJTt5KZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45L7fQ2Y027816;
	Fri, 21 Jun 2024 07:59:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=UudgEtUoUc3VB4pE8CO6giLAsGlC+mp5+XdMJuizxGY=; b=
	JZkyH0et748HRqBxRGDvJ+8c+S5efZ4tRuIOz6Pwo+NeCmsEPWF4YizaZsBh9PsF
	PMpVaTBMY+GkrEgyUPnCDhMvTtBio4EUrE2oJwYYHUwL/qyx4aq9G3FsxED/stjG
	x+hGFBfp8FGqNoR1oh+uKrwDs5mI11L7tq43CrnOkeJzMN5xx3z8wiTvtEXoxr3K
	4B/Qycr0/TILfdR6jCSBp4SyE3/g8Y2QZxVPaWiSOp30PvfigUpm16mPpFnPvaE0
	iYuoBO5Ag7WrRggrbA8H5gNqhTbP9XpNVunnawIXFMZEiT2/IB4ykG1wVGxjFI+R
	L/ODtsOzhs/ZB9hYk73sDw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkts964-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 07:59:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45L71e1m019618;
	Fri, 21 Jun 2024 07:59:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrna1r7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 07:59:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6/tlAKbU3Iz7iU3Phsm/zBa+8+m+zRH3COaow5vHyzd9Fj2jqcSOL6jFxJGbLCySEuA/mnut3nUTPF8oQFo/MdoujflcveT2NX1GwC/1AEszzVJ7KGX0Xb0Qw7dy/JaCDJsMY03KjzFcIqWLLxO7nj3kaNe9tY98J7ad5vr+xUkSSeQaVjN2gx8uFRB22YUevZyQozk1n83NP9lMygT6FqzXTeU122b87npi33lK8Qllcu2fIUWj/32ZQfhb25ouLhgiO7a4ElL1pGopGE4ETAJLxG/A7bhq9M85eJN5Jl+nhMgst+3EWGyTiL4Qs/2aXetzY0es02Ge2dH1Vq+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UudgEtUoUc3VB4pE8CO6giLAsGlC+mp5+XdMJuizxGY=;
 b=HXpdfOx7FQALonyZa2dq/U/MsbacxgBVjHUL2OI+E9e3+TbgyQjiriU04MRi53ppok1+WuGGP+wKxtC73KsAJ+KH/+D2yDgv94yDzjglQN6MT5gUJTSkGoIaCTFZOLJ67+IxG+xCZiLpbna32gTg3GIQGfikMbVK1H/yxgMkfUa56NpTqD3NTWB0UzjB3wsYQFqVnpVSU48VTnPv46/2t0Z3XAaoZBBPkB1uqq6Adhr2o3eQqY/Cz/pErfxtTOBVhllOyRjHmn4573z/3N+cyPYVqP5yDJwaiiktF/YhocmlaDFa0aaadFxSXtS63o7Q1gNbM2eWR3D5eZhS8Tyg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UudgEtUoUc3VB4pE8CO6giLAsGlC+mp5+XdMJuizxGY=;
 b=jjJTt5KZB4nYysRtFl1njM3Gh0Wbe/ipgU4Ob/Xdk1HICXvlky2iq4evmQICazcPKOiZdKnPYcNW0SUfimdR48BAxXL20CjoE198akHnHCOTsfU5znypoG4qYHWMERO0PR8id/jG9Qe0xrAOIKgCuwQw40SeqHY61rYYU5XI4fk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6862.namprd10.prod.outlook.com (2603:10b6:8:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.22; Fri, 21 Jun
 2024 07:59:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 07:59:26 +0000
Message-ID: <674559cc-4ecf-43f0-9b76-94fa24a2cf72@oracle.com>
Date: Fri, 21 Jun 2024 08:59:19 +0100
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <171891858790.154563.14863944476258774433.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0626.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd9138c-6132-4027-8689-08dc91c811ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|366013|1800799021|7416011|376011|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?Z0N2UGw4MjZmV01JcGlwT2VhdEEvVGtxczZLZ1d0dUpmL0FyT0ttUlNFengr?=
 =?utf-8?B?M2FsRjczV3RsRTlSVWY0Q0lxTW5QOHVhN2MxN3hhc0VjZTIwYlg4aGw3cUhZ?=
 =?utf-8?B?Q003RisrbGNZYWhmTFB0MktnRnpkbC9wcS9MT29KQ25PcGdOd3ZZME9Gb1Vn?=
 =?utf-8?B?RCsxLzA3Y0hxd0N3dnZXTG94VTV4ZTRlZVhmejU5eHowL3VYdWJuZ1ZnL1ZU?=
 =?utf-8?B?VFJ0bjk3VDc5TlFXTklqRldnL3FxNVJkckJNOHZzRkhIRFdYSUFtc1dHNkhH?=
 =?utf-8?B?QUg2MDFjbWl6L3k0WFVaVkNFR21zVk9vUHhMbnZEQndoSERiMW40YXdwMlp4?=
 =?utf-8?B?VXloYmZnYVNIZEp3cDV0aGdOOU03eVEyOGQ2WEhMS3ZHNmE3ak9rTkVXOTls?=
 =?utf-8?B?UFZScTFJUnJGTVRtc3FKbXU4N2VRcnQxS2pRNVdYNGxwbHgyWks2NzRGb29H?=
 =?utf-8?B?elZyT2xKb2RiVUx2cklEa2had2pmUGdpc2FJTmZ5OHd1LytzWWtmUVRoYm1y?=
 =?utf-8?B?Q0NobjJUVk9YZjBSaElMdlY0dmR1V0xYaWJSZmlDSjYyNDkvKzU4T2dpQUU3?=
 =?utf-8?B?T3BrVjk2bWFxVG1PNjJweE1PSFN3blAzWlhFbDIweDVMNHM1NDBRNHA4RVJp?=
 =?utf-8?B?WCtXeEFlVDRTRmprYlJBdGhmNC9DSTBGeTVYQ04xS3dvY1JkSUVYSGFURHVq?=
 =?utf-8?B?Z0hRSy9BczY2ZmRLMFVMYVdtaTcvSUo4OTFDaHBPZWlocVFIMUJKK0k1Mitt?=
 =?utf-8?B?bjdIaThQZzNYVmRLRHpXcG41SWJlUDEwYTRhTTBVSjI0ekdITGl2b3ZTYjFQ?=
 =?utf-8?B?ZWltOHFqQU1UNlpBK3RLZ2lyZVFHYUgwdXYxUTZ2YWt5cjRWbDE5aDgyQ2ZO?=
 =?utf-8?B?aE9lTU5MZmtxcU16aEw2eEV6Z3F0V3FpN2RkbjhIRTAvdUhuSzJBYXlFRmFt?=
 =?utf-8?B?T2N1amtLMmxtU1drSHNUVVM5b3htdlhPY2xMUVQrTHVXUGFWem9aMU1ZOVBI?=
 =?utf-8?B?RFhvM01KaDJ2N0NuMjhTVHRYYUQ3aWI0TXo2Zjl3dW1QN3RZc3VRVXRwc3kv?=
 =?utf-8?B?Vzc0dVJuYmk3TCtaQmkwVGx2SXVYTWd1WTBiSWNycTFOOGtIYmVpNGI4Qjhw?=
 =?utf-8?B?c3RuS2VKRTlnbE1lL1czTnBudHZ1NzlJYVhsY0NIRnNXdVJnZjdJenVrVjVP?=
 =?utf-8?B?aGtLSVM5LytLMTY5QWdzaXA1Vkg0WnFvVjBMSHVqaE1kYzJxQWFTUGd4Qmdw?=
 =?utf-8?B?YnRNeWx4eDVMc1VhQ1N5VXFnQldxb2IxS0djc1BYaW94WGNuTVJRT1dueVBr?=
 =?utf-8?B?Q2dXcXFpKzk3YjJEWExKYnQxYVh3SXNmL1VLZmhWc25mSlBPODkraEFvVXpD?=
 =?utf-8?B?TUJidk5mZ1o5UktZL3UzM2hvSUtzbUtBWDhKYnZZRk1FQUVhWnRvRVgvcDB6?=
 =?utf-8?B?SEYzblBNWmIyZXV6N0tka2U3UVplQTYwdEZ1UmpOWm5jeHEwUngyU1lWV2p2?=
 =?utf-8?B?cUQ2Ylh4SUl3TUhwS05XOUlIUlgrK1dzcVl0MlFpbUVCelRIcnlRYWcwdmJG?=
 =?utf-8?B?YU1YcVBzcDZlSGVPMGpuVjl1ZTA0QmlGYm5XMTcwTmdXVHY2dTJheFZ2Q2Zz?=
 =?utf-8?B?Z2l4MVlQcURLbnhnY0dJNWcrbFVsVUZMV3VXTkliTU13a3FlM0hxeU1sVGlR?=
 =?utf-8?B?anpON2thdDBYRkcvUTg5YTN4MnNEWmRiTXFsVFFUckJIeldaZmNyRnh1bWFT?=
 =?utf-8?B?MDIxV1RRVXNDZzE2RzZoODArV1FDdkZlWWt2NFpDWG9jWFZRS255dVowQVZi?=
 =?utf-8?Q?ZDVsy8SNQE+lTkDWq/DN/ho9qxLJW/5fIWZeI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(7416011)(376011)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N2FiY0hORkg5alI5bGJVTFgySWhqMnQzVjIvZDE5SG9qY0dyc05QeW1rVjBn?=
 =?utf-8?B?L1M3TUhkMEpFaitNRTFUK0R1YkJielYxVnJMV1BxTjJERVJzM0NJalRUelY4?=
 =?utf-8?B?OUlSbHpwamhDWHQ4ZlV4T3hqU0lRVXdpdS85OEdEaVdGaGUrbmFJN1ptOW9v?=
 =?utf-8?B?NklqcHErZzRNMnlhL2lGZVBBUW8yNGlLSmdpVnVaY0JiUGhTM0pVL081Qm9k?=
 =?utf-8?B?allJb0hDQldYaHAvUmNsWjRvL0NsZHVCWFRCSUZwbFg3VHEwQ0hRSE9LYlpa?=
 =?utf-8?B?MU1VQ0U3cStjS0RlQUk1VVk2UExqZk40R1dRdlJua3hOcHRhTnZONFViYmIx?=
 =?utf-8?B?ajFKajVNNWp2cFlMR0ExdEV5dkxwWitMeVVnc24xbmZFa2hrSVZMaUg2QnZk?=
 =?utf-8?B?SGx2alBnOXVZUUo5YjB2dnoxVGU0dS9uRG4razYySk9qMEZFWlJnVWlmOVox?=
 =?utf-8?B?dGV6Q1FFT1JyMnRnbW1sZXNKWjhjdTUrSlRtNFZXMEM1cUFjazlYbFFpaVl1?=
 =?utf-8?B?Z2VLN1NaRUt3YzdWMXBNdCtXVjdBY0dwNUdIQUF6bXFDRHBiUHk4VW9HVksv?=
 =?utf-8?B?T24yQVNEeDV0ZWJsTFZhKzc1Q2lBSDFGdmQweXZQTXhHejVJd1phdjdxUmJp?=
 =?utf-8?B?ajkrWWo5NTdLTGQ5R2Zwd1NBd2ptYVZ0M2NUWTczT1FRQ2dpdzlXSHh1Z2dK?=
 =?utf-8?B?ZVJwMjdiK00wLzBKb3ova0dPckFKYm9iR3pKdXB2TUwwTzZ6Zmx1VDRlR2Mr?=
 =?utf-8?B?VU1NR3I0QmdFbC8zUnJqSDFNVnMyNTlSSWpkcVRDUHRianpWVFJSYnBVdFRs?=
 =?utf-8?B?RVBObW9Qam9jTHYyc3Nqc3BEdEN1TUF5V1dZZDJuaW1HZ2xFVVIwdHZxUjZl?=
 =?utf-8?B?WEZwRWk0bkszZmZEYVNlalZIVGk1UXNSaEg1bGN3aWpvNllwVWxqemhpYkdC?=
 =?utf-8?B?eGp4czRuZUdnanltRUhkY1AyRGlWaDkrS09KWFZuY3hXTWl0M0Nub3dVbGZh?=
 =?utf-8?B?SXhHUTRHbVVBZUNNSzhOQUd1VmxGbjdaNU9KTkNtOGhQTlNoTEZRN25xcW0v?=
 =?utf-8?B?bTNlK3Zod0N3VURDT2pYRUl3em51N0Z6c2dlTHNTbmdHVUpiYjRQNi9xdC8w?=
 =?utf-8?B?bkVYMytUdXQ4QkJvVEFuY3hsb1BKeUZnS0VzaW9wT2lsSEw2ZnZUZmFxS3JX?=
 =?utf-8?B?SnpLaHJCdnNCRmhhaTBzUWZwaDlNbVBBeXpkOHM3TmdCY3IrcjcyRHJ6dFZ0?=
 =?utf-8?B?ckI3SW1CVWRUOW4zUXhCTy9IcU9CSGpVeUszUHg5eHVpOXl2clNhNjJnSVlo?=
 =?utf-8?B?YytqR0hBMEI2cjdpSUFPSU1hV0I2bjVRd3h1NURnTnZjbmNrVHUzekNsQWk3?=
 =?utf-8?B?YUJQeU52QUU3NEdlM2FiT1UyVVlrdzQwY2VSeW4wd2VJTE9ZbXJPNWlXNHBn?=
 =?utf-8?B?SHYrT2pmeHlDeW5MYlNnWndEMTdkb3dKaHY5ODNHVmZMSmxSK003Snp6OWw4?=
 =?utf-8?B?OXhHcG4yaWxvc2RqWjB2eEFiQ3MyWFhORG1QSUdVcC8vQ0dkTFV2d1cwTlVB?=
 =?utf-8?B?cWkxRVp5QnU4aHFkRkV2V2lQNFU5bGZDUGlQbFhlVzhwMjBPU25UR1RJWmYv?=
 =?utf-8?B?bCtHM1kvbmJScmVMb1dyaHBQc25MNVRzZ2VXSTBaNWtxWUoxTHhXQ0E1Mml6?=
 =?utf-8?B?em1DQmhDdW4xTTNSU2xYQm83cmJyblFWSzhQUlpRSHNCRFB4ZlhaZDFnNVVM?=
 =?utf-8?B?bERsNWFEUXpuV0hXdS9UYXB4MmRSb0U1czJMY3l3bDVxRk80Ykd4WU10VklP?=
 =?utf-8?B?Z29LUnpwMVZzdzJwZWNhREQwdWE3UHlxWEhaa2QxdDVoMWtBTHVDU2VabXBQ?=
 =?utf-8?B?Q2JKcG9YUWk1amprU0NSeTdwTEtGbG9Sc0FYWmM0VFJWMUYvTGVYL2lKRTND?=
 =?utf-8?B?U1loREVaWXlOUDQvYjlmckw4em1jSXRZaVFBcFR6aldUSlZ0U2hNT1JRVzln?=
 =?utf-8?B?WWVYcDlBeXBmVlRjSU8yUWZxbG5iYm1RVk81WFVzejlzbEY5Y3Bac0NFQ3dQ?=
 =?utf-8?B?UVoxL3laR1BKQnNpcXBSQjN5YzdIbzFlMlU0ZjJLZVc5Q1NpYTJzbXZIelRE?=
 =?utf-8?B?SncvZER6ekw1bC9IRjFVYTU1elpZa0V5Mk9pUHlQZHhQLzExcTh4WkVzU3Zq?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ojqqnlkFzOg1J5EARD1TNCqpDlRyqNZZLML3CBRKu7GJ0ifSHCqqS2dE+x2kaj6OVUaScBfWpX/a20+Bouf9mPXfYLFinCtMKL0uU2hepnruDZgl2r2i45aAI+pQ+GZdLvPgC83A23NzEdRDE37ecHkjIybfoVNx649r8mMhakE5gfubbVmS7Zvvf1kpq+n9UnY3fdnL0zgCJVq3K07ac7ZlZBaCpLgC6eunIBMUA6vobwvauSCEfwnKYdyc0gQlAZc1q/c6MVJJ0f5ZjQ0ilql+ejWUWA+4Hxu060dLLf0Q6cnQwxMZhLuJg6yuGBMod094WKY3Ezz2sJM3hRQDSWfAXQ3At7qY+HWdBYVLUcRM02bdi75ZSMJEk/a2WbvcVts7rBGBY8dnmxqWy91ctwDMtTu4yjpETLLu8SZ20EQ1oiwCc4SSN9dSKGzJTZL4xN2fcmUOG8u8SBnKkK4bJ2a9337SbBStm90iThreDAaYf/8o4aK/0uSxDcOm1ONAGbZC69dvWanAi399tAxu6IpE+UdAkzk+Gc1Hp9HYUlnbBU92G9YFBNbqTSFJIuBwcYhFe2w3ydFKhnhPLWZ7R1C81KWOzl0hYRTF2eV2OWE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd9138c-6132-4027-8689-08dc91c811ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 07:59:26.3290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBjMsjZrISrNHWb5XrN0UeBEbYTglfztRjK8VjQfqFxYboRDtCi9kBxavVhJEBkB5HK/XBu1xmw/T8mfyI+Kig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_02,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406210058
X-Proofpoint-GUID: -nixIB4eY_krX9dnp8JZnIT47Z2tXypj
X-Proofpoint-ORIG-GUID: -nixIB4eY_krX9dnp8JZnIT47Z2tXypj

On 20/06/2024 22:23, Jens Axboe wrote:
> On Thu, 20 Jun 2024 12:53:49 +0000, John Garry wrote:
>> This series introduces a proposal to implementing atomic writes in the
>> kernel for torn-write protection.
>>
>> This series takes the approach of adding a new "atomic" flag to each of
>> pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
>> When set, these indicate that we want the write issued "atomically".
>>
>> [...]
> Applied, thanks!

Thanks Jens.

JFYI, we will probably notice a trivial conflict in 
include/uapi/linux/stat.h when merging, as I fixed a comment there which 
went into v6.10-rc4 . To resolve, the version in this series can be 
used, as it also fixes that comment.


