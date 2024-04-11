Return-Path: <io-uring+bounces-1502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC0E58A0AD5
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 10:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BB8D1C21BA9
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 08:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA07113F45C;
	Thu, 11 Apr 2024 08:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XmROqLru";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="srElMAH9"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1047C664DD;
	Thu, 11 Apr 2024 08:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712822823; cv=fail; b=OWhOl82IzjNO8aO7UzAKmEItlUMk6D9rIQkdTnl4Snips3sLQHh1h8RT0/xxoINNkKIEkvSTt0vx06sktXkX6+WqA//JwYhKT6QXKdE+MrVZ/rgmvnPLBZfRAnexJhHvzf5NddNdAAUZ6cl4L04PE52cPifV6xbdDEUqOMjh/fs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712822823; c=relaxed/simple;
	bh=LZZ9PfwBFY7w/QvSQsKrHpH+bj89pqYkTqy1Xogn+ok=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hx3xUpC4c3x+1ypXVo+jtugztMGYaqUl3d1gWMH22pS6UHiRRbib/sR5CPivjiRQrxkD4eXMUZoBJaSPr3xMFb94ij9BavOi44Z1xszzJac0zjw3NrMHf4FKA7ME3NHSi85Q66NZhdzw6p17vFh6YySO7VjXTcWTPkUZfmD5RTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XmROqLru; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=srElMAH9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B70SDY008867;
	Thu, 11 Apr 2024 08:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=vcXcA4ffpHZ/rqS6D2KgwABq1LjKHmq4RdQIs/RJ244=;
 b=XmROqLrub8kqzFDNd8aSrk+2ISPJmF4FrOn5XqRVM7CG0wVNW4+ZU7WuVJi7j3CTWnXg
 WoszkLzipczEn5OZEy7p4baaArQV9fFJ2JQ6oB/oCdAE5RYmMPnuCZ82ygyEt2jfGK4P
 rmtDS4TdblT+rPbkBJE6iwoSDOvQxbgx27R0OwCMVKFaDW7UrCuWxAjJna8iAY8lG4kd
 Vm04T2Qs/YQJ2Z3D25XKJSd6SR0RXhoAKIMZ5HxwbVDgYSABIkTwYKFhTlrCQVwRbIfJ
 SmuDraqKJu8wYxsPXtoRVhE+weTP6S2SQ8HBuTjC92WBSoWiTzm3vIllqR3EQ0dP6SkK gA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvh28a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 08:06:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B6L4Di010514;
	Thu, 11 Apr 2024 08:06:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu97m0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 08:06:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebOXx6KybQt5GsCwL03jKz64CqacfCMUV9vnVyuxFv3Zu2gn0N7QKSyz+cNOoMhSZRqf70p3bfIHEafwEFRHJecNGIdFFLJN2Dw1mdV9a8vc2zQCYNenbGTP2kKJ/ChAOLml9WfF06ve1lW8it6IoYISxR63+Muw87LoKWyhQqNaIHZRseg9nLHkkLAP2CcbOJPjLw9wq2CnZF+L5hpoqmnQAZept7n0f2IP/pXjaOgTABeMTpeij+h538Xkmn9nzyTJSPe4nWAp0f39gXvuCrm1/Ns+qvw5a5xdfQc35c8wCuq5d9S6ov6H12zEbbWzuAwneVFfxoVufPD9xr9T9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcXcA4ffpHZ/rqS6D2KgwABq1LjKHmq4RdQIs/RJ244=;
 b=Kyin0E5ShkfQqliwNTjUUfWfOke2KbaozhOJUwj7hq5RUe14WJNNnVGPTgy45bWLXd5HTNEl4LLXCSewML3+JShJj71x+ykqL7jU3+BDqF3yXNyVRPHZJhuRKpjWqXcd3AwYBhibfI41aLuGSZn1HoI8lxQfttxfOE1d7zhMq6BNWQokr0nCPSGyFCCnjh6sjAEoNLlwefO/MD/oN9lifIKtw5pBT3XLCQHFz26EpNcvtkB1Ki48zJztUjl+mQb7hOeAHpPe8bMj7HZi5Nexzo91KhDLenEhXCwXj5LqfO/R20h9FWIc3NBwL0JuB9HghHmVVwbmVGG6OezG37nyyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcXcA4ffpHZ/rqS6D2KgwABq1LjKHmq4RdQIs/RJ244=;
 b=srElMAH969J0MWU/HCgKL/6c6FHEW/Sq5vmacWf4VLJVF9/OF3sEwRdk/nNzpJMhpiPBpvKYteb4jzWQrJGzB6swzh7MuHw5KZh9U8bBs7TAc+cnJo85KYVW5ETUnSzE8XR0g7pHs55BfKDINsahgAz7+rQmZUgnyEMaM9n25vE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5756.namprd10.prod.outlook.com (2603:10b6:510:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 08:06:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 08:06:29 +0000
Message-ID: <849639fa-e672-40ed-ad5a-fd1f72f4180c@oracle.com>
Date: Thu, 11 Apr 2024 09:06:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] block: Call blkdev_dio_unaligned() from
 blkdev_direct_IO()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-3-john.g.garry@oracle.com>
 <ZhcYddRtAoMghtvr@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZhcYddRtAoMghtvr@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0466.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: a586c645-4486-4a6a-a177-08dc59fe4ae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0agl5rq83Z7WafSRCVusBu+Y/DuJQeKydTdcUpgl+Kfqj3lJTJJA96eshKh8thj4PAj9I7rspABB7nKSAiF7DOfErrGFP+kvvBro2KJ+IPFJstJ1IRQdkdLYtl+ckS0emFPxPAuIzSyRYkxSUtXMeyFCC1i16Myws85HE7ciyA4xVaVJb1EaJsY7LAEYh/TvMwlr1QDBrqigdVWB/hdAcW98I2rgW/JYtcR2n6Ku32eZYylLJMt9e53+2b5bBygUVYElFYL+l66R3gtMbPXd099ITcLJaJBkGQUiFP/9nM0WKpOP0JLwOBxXFMTL6iMMdDR76eV85tFlCzz8H9YwnT527F7ziPfOhZQSJHdhRNf1sM1YJW5N0BnOIBDHaQ32/P+nWGHVxgdlMNzy1gZC+JuaRJvubQocRw3xBYcNX+8k48wqbrRHjuXekRC4D0eugw5HJLVjdWLiefp8CwK6buI3VCaG6XkEHY4S5NLmnoTd/zv6AK7/YvsMIG+w01HdWigNOSd8O+Mtv6Wwtg8DMb8NO5APwrzAuAlnMBXlcXmQBDqt9n+srAxfnjg07oqICJL/O4yIBzb44wq2MFXlJ4hu9WMHkqyFaUEdQt0JTtP2vXRsgVzKhM4ul65Dlvbl58ydWRR41MpgUwxrNdMynZDQiYanXt7zAIRy2JIUPS4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?c29Ebk5aM3BLQ0RySXI5QmN2bDcrLy94MHRoaVlLSlNSTmord2l3MUc0T1Ey?=
 =?utf-8?B?QmxUS1VjNitGMnJqUGN4SFJVQThybSs1aEl4QTA4TzNIT2ZaRTdIemhYRE44?=
 =?utf-8?B?eGV0NWtPUU9aUERXN01OTG0rMkFCanJNbHQ2SHA0eWwxUm1IS2xEcXdxZzJx?=
 =?utf-8?B?UDJPQWJMRHgxbzgyOGRrdks4b3RaTXZEZmt6QTZqQmlUSmRKS2hpeUFvTGEw?=
 =?utf-8?B?b3FHNGJBU0pNNHgyaW9RYXE2VzJxNmJCN3B0dHJjeWJ3bGR2dnlzcXpNMVRj?=
 =?utf-8?B?b2EyYkJDYXJnMUxCV2lKaFFOSUdrNmNRc1gzMmdnenp5a25wT243b21pS1pS?=
 =?utf-8?B?UFhONGVieDQrMENDTjNlZk1kSExQMmpVbXB2MjlQZlM1MTQ4UUlYeFljUmJS?=
 =?utf-8?B?NWpKQW44NnAyVkhrYVZneENBQmFaSjB2a1pTWVBPVHF6bjdHdHdDQjhTVkI3?=
 =?utf-8?B?bkhZZFRDVEU3Vk5pdG9QMzVCMXI5OCswRWhTbHNBYjZsWDE1OTd2bUtFMlhL?=
 =?utf-8?B?TDVBT0o0b2pSbTh0eEpMeHNLSFo1M0EvcEEwSitJam1VUzcrVVQ4b2pCL1FD?=
 =?utf-8?B?TGd6RWEwOGswU1BsRnVFTFZtWnlkNmh4UHFFczFoVS9WcG54OUYxTGd5c09I?=
 =?utf-8?B?M0tSSjE2TVg1U3psU3hlQTBKbmJPUjQyTGp0OWdYTmJQY3RPcEp0R1g4dERh?=
 =?utf-8?B?RWE2Q2UwVmljZmtjRUhyS1RZMFNnNlM1ODdyV052RkRuSm1zN3BKSUdXalZm?=
 =?utf-8?B?US9vT1c2QzlzNUo0d0o1Nzl1d2xDVmJXeUlieGRUZnZCbzNXWml6bHFBYkJh?=
 =?utf-8?B?TFRaZ2ZUUEFMRTc1dEdBV1lJWVhBM1hWU1RLZzMrMUxjNzhNS05sSEVUR1Vm?=
 =?utf-8?B?UldNNlp0SllRdkswTFBJbHRZQWlWL3dxWkU2RDBIK0J3N083QXBGUE9DNW93?=
 =?utf-8?B?dGwvbThZMU5BVkExSDIrdUdEZVZPWFltL1ZNQ1NVQWsxbUNyZS85cEFTMDB3?=
 =?utf-8?B?SHFZTWVOSWpBMmJPa2ZZZG52aFkwWlU5cFVLR09OUnpadXhkcjdYQlRudHhF?=
 =?utf-8?B?UlJlSHFPNGtSYnUrRWhnOHVxM3VFNUhqeHBualFFRlhXaktMRnVjTit5SXBO?=
 =?utf-8?B?S1lMQlBLRVE0dmlSNVJaUHhnYVZhbXpaTnVob0tWUjBBUVhvN2ZYOFVscUxh?=
 =?utf-8?B?QTlnU09pNFd3SC90MlFHWkhSSFQ5Q0VqK1N1R2ppcnBkRFFqQVlOVHFIYWpm?=
 =?utf-8?B?alNhTTdRdG02ZWtKOEs1R3NiMjZwWnpvOW5PZDRBckJ0M2FKUUh5UzVBZ2Zi?=
 =?utf-8?B?UUFZVVV1OTRlNkVQYmsyUVlwQldZa3B1RWYzS0NXY3RLdG5mbERGMVBPREgw?=
 =?utf-8?B?c1FVTVVXYm1LK0VrRHA0TzBBd0JsTG9ORmhjNWk5YmNLVU93VXNkL3kyN0dF?=
 =?utf-8?B?QzgxRnBvUEhlYy82cm0xckRNR1BvZDRLQW9HRjRsSlh2WU15enB1amprb3JJ?=
 =?utf-8?B?QUtKWGlBOTl0R1gvQm9yeVFDaDJnRlhyK3lIRktRdklvekNJRE5Ic2JZSW9Y?=
 =?utf-8?B?dlpuSEc1QVRjY09KYWNvQ29qU0NTdjRLMzFOMFpEeVZDcEhmOEhvVXBINmov?=
 =?utf-8?B?ZHZVNFdsVHQ0cEhWMHByOUFDbkNPWSttNHEyaW1sa1lrVlRGeHdOUUl5WTc5?=
 =?utf-8?B?YnM3SWZVMys2N0U3VTEzKzV6UFlMNVY4cDRWVEVCRE5mWHBnVVRLbXBzd2tk?=
 =?utf-8?B?cVdwaG9kMjdWUlpFSlYrQjJrTEdILzR6ZFpUYnIrM2hTR0hWVHp3OFdLZk5y?=
 =?utf-8?B?WkZFUGVDVWVmV2dYZXNnWk1hdFprSndiZnhmZ21mdHN4ZzRlejJLMXV0bkM0?=
 =?utf-8?B?ZTJoeTN0ZHN4UXRGejB3U1FHbjZOOTdQN3RVb3pEQnVXVlVUbTdkTFIzNExu?=
 =?utf-8?B?UXpmYnM3bGxpVFlTbEFmUFpxL1orTGFFS3BQNTJCcldpdnoxeDZLSVZ2R3hQ?=
 =?utf-8?B?a29tRllxUGk2N0ROMHhqUWdpZzVOdnE1ckJvb2hrbFBibGZMTGZTTVJ0QllR?=
 =?utf-8?B?Tnl0cW5oeUN5RitaK3ZkazJRNlliSk9UekphVzhlMUtnSlJoU2xGWGI3Y3h6?=
 =?utf-8?Q?0vBIkH34GWI6yIM0mqu+cK1cc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6UIn6XtXbwyHzzWqPqhGBeKJvXTA8pYPBbFzO5573QYShIzOjeXKZ/UmrY3rnMUzNYOVd3zJnlL/d/xU0dewgl99BdZsj/0KQiXqEns+l1eY8ijvU63yV78CR65HntgGzsu7s+IMzBPt6tr573li2Qp4su7tt6DyVxvfdQCrkK4hwaDKhrb+4R/ldUEyJnuOxPF/He7yd2F+0i4thnMjqSKaLJQWTAOeh9oZv2ExzKwnEfHz8cKJaC4tkfGQmqdPQQAVdTkeV7ZFaaXsP2Q5DvzdFsFexiqNwUdhct43coPju4hI8AV+vBtuJrQJO516ZwpCO7g3I3R4v9hQwPZYS5NSfowd1sNp2FpcjwwIAorzz4V9uYsT2SzvvfzXLjvdBBv/l/Z5s1Jp4Z21UPaBkCXxxM0LlPXYSlHbvdWPYJhdbHQ4qXGGXoEyqX9L/ms06A18NL+7j3TT7Lzxu2mmW+M+7zqE4X972cSedy980SpzXvYREii7xCyKSMmcfwjpEuwYiAcR6p8hGkKVlSaI7EUg1lyJ69YyUN1+NeaojOF8yVg93IPNYpeFnnLz/wY0E+Etg07a/6cRqY23jOcEF1004hYFyk54RFi+LLumcaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a586c645-4486-4a6a-a177-08dc59fe4ae0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 08:06:29.4775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1gdXHF/ihkxwiTxK/DP8AcXfof4brM2e6uvmKExRmlOtRMdOl2PCmCd5o4W6SaGffXudUJbpyDQ/CnBikVLAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_02,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110057
X-Proofpoint-ORIG-GUID: VPpjFEQ4ZS4Wu9jAR2OgBzJNy7UBd7qK
X-Proofpoint-GUID: VPpjFEQ4ZS4Wu9jAR2OgBzJNy7UBd7qK

On 10/04/2024 23:53, Luis Chamberlain wrote:
> On Tue, Mar 26, 2024 at 01:38:05PM +0000, John Garry wrote:
>> blkdev_dio_unaligned() is called from __blkdev_direct_IO(),
>> __blkdev_direct_IO_simple(), and __blkdev_direct_IO_async(), and all these
>> are only called from blkdev_direct_IO().
>>
>> Move the blkdev_dio_unaligned() call to the common callsite,
>> blkdev_direct_IO().
>>
>> Pass those functions the bdev pointer from blkdev_direct_IO() as it is non-
>> trivial to calculate.
>>
>> Reviewed-by: Keith Busch<kbusch@kernel.org>
>> Reviewed-by: Christoph Hellwig<hch@lst.de>
>> Signed-off-by: John Garry<john.g.garry@oracle.com>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> 

cheers

> I think this patch should just be sent separately already and not part
> of this series.

That just creates a merge dependency, since I have later changes which 
depend on this. I suppose that since we're nearly at rc4, I could do that.

John


