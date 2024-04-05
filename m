Return-Path: <io-uring+bounces-1402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2FA899A33
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 12:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73F7A1F2311F
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 10:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669AE16132E;
	Fri,  5 Apr 2024 10:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B/jsPsJ6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i1ZzWv+O"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E75161312;
	Fri,  5 Apr 2024 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712311608; cv=fail; b=iMaim7schsKGE2dymJj7We6eLPJ+z3LrIFf6Jm9H8r8a+dC7UM5bY45x/FUDBQyPfmTbe1icbBZxqqVmy+WI/33LDM0kREInYs8yxKXWktmVCt3p9vmZJDoneNI69p5NTJ0orIme47uqOsrTP2l7IDv9sMgUILUHZAvys/89GBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712311608; c=relaxed/simple;
	bh=2X6pbwTpFQdv2yn2RwE+nmVNnhLCkQxW3PgMVDAF+jg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sx4jsGOwtT3B9Oan4U1vBN6zLFkbh2Z2mm1IQ8fjmaZtcT0FW5sYsumxPaQaKfzIO0e1N8gf0vwpjjhOOGJvLXmHOFmA9TCSfQZ8i1oLVmCCIw42xK3D/72SpDdW9s/I7NjPldNd6Yp1O3WJNtyHD6efTQXXsJXGajLDP4n+T0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B/jsPsJ6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i1ZzWv+O; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4358XxDO024044;
	Fri, 5 Apr 2024 10:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=lwB6ADMgJD950hxwSEvlQ+bR679Q3DB079fHl+5MqPA=;
 b=B/jsPsJ6jPaEZgsguyVa8mM2IiITBbh182SQNkzikAkUcpW584H9/g4vCnUpvEDKIIUk
 5apJWyDPZy8pAjwL/JbfW62y+LD48RG3VOKsUyKgbjVk6wjwuR8QxkyZRSdkY5J2BgL2
 IidQ0LtSEhDgDCmVcdE3ubtCldmgOwk1wz0/qCPqeMNVurPCENrFfJR8z85B+H11B5Qy
 +EuNcf/uEis2pWbWV3DLXpVLhAD7HOgQjwLWZPFkONCwEVZwxVfVfQ81DIqcl3hLP67U
 bxJK6+7ERATHp7X/YtR4roJ5VfvvOM11sUwAZcr0oQSvZwauEtlLEy+H3Mb0pTsqCR97 Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9f8pb3ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 10:06:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43588arp009297;
	Fri, 5 Apr 2024 10:06:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emmwbb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 10:06:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtelDyhgGyIOoLw2dtLxHylkaF/gtNMwIw8F2ON0r5DZCbx5lVAgX2ZEi0Kn4y+jFZmXu7aFkpoGSVHGlK28wYC/jHtWD0cfM8aA0hlNpVfLwOhEKOAmDyyIGZPBmaCpW+6+sMvsh9p58fOyTr1fdy9TL0riVpIAk8WbWefuBnMine3nSPJ7kkkLjkhP29VUjK6kP0NXhBslRcGTK1s+VYhauPyUR2TDVZqzPghB93Vdy8AMbevAlj4SwI7ZD5Db0V5FExH7MKY4nvh4DZXkUJtWRwe41Z6I7dMpVTeKc+MCkk169Hn0KN4NIFZw3wu5g26P3/lEzJfwEBBTZ/Fl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lwB6ADMgJD950hxwSEvlQ+bR679Q3DB079fHl+5MqPA=;
 b=Q5DzdzweJYy419eX4z0zL6cXJ1JGHmBEjdj6maYHumlu/Q7K0szW1hXByC/bqcG6Ui9kGzUDDh0qpvUj9zOPjJcM4B6hE+HFfso8H9MLLPfEXXLg3QiXDHiUeI7VrBQ8YFtPQmu7EsOpG2zJ+htp4k9mlSnWL/r26/pSJleEhS+Tya6n80iVASvGJnY+kMKUbLGsugwPQqH2jMgCC2MwIi3Aa9rzSU8kdn3j6V3G849Ow8b0SSrd7wp/jlmf3XW9C8N4qa2xWZwPxrMKqbIdSqLY5SM2VcxrJnK4p7erMkmkzb9r9JD9zLoWXP5bVrgB4s2EmNxUMCL45XmzJOpdTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwB6ADMgJD950hxwSEvlQ+bR679Q3DB079fHl+5MqPA=;
 b=i1ZzWv+Og+61mWS/cPPRPDeflXe+J1bans6EiVRTF4yff1vrXCk3OkrCxKV8ORRo68gBuoeF/i8EjZCjo13GvJZ3hs9PDAr9hFONX3/QbM0ThNq3PbTh9qJnOjeHXFReT3j78/2onB9x4xUW8CwzJ4rmvKYTRt56uX6QlJQ9ocs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM3PR10MB7948.namprd10.prod.outlook.com (2603:10b6:8:1af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 10:06:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 10:06:06 +0000
Message-ID: <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
Date: Fri, 5 Apr 2024 11:06:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] block atomic writes
To: Matthew Wilcox <willy@infradead.org>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0192.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM3PR10MB7948:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	O8Ux3mX8pSrWGl7wjQpmOR3625+0cOszhk54Q9DgF9f0tqmqiZ77b8CN+GTJNKMEa006/EEDsUFAFDSCYw16AsDjvb/Hd4jzkwS5pWTav1jJqpq5Nb1V87aJ8gS1JrjEjPk/pzu/Yt3VooeZ5oQEy+ISMpPR7YqBoxhzvGJZ6fXlTof1JKs5mx3p1BLXZn2IyacPMZlBXLke3i3lob10lHFVnsJdQgwEW4QonxwkliOJjlk6eQ7/5t0Wkija2ILiGpi6b1w1SS5o/wZ8y2tuMu+2G2Rgq7Zwt0lMglcwYQKI0jub3psLyJcg5HU11gLEM7bE5WTfoKaFIdz8vOqme/Hj1fCJAkaqr7/30CeW/qWddPC+exdj5TSXIqaX06jtAlfHEfPjIUXSQLIlffHqjHXZMWUEQ1f3xRPhFdl6XpsUPzQvUJmmY438XH5R0bYLZmkugVX3gJIQzyMFSq5CSD6zMe3n0UgYAvfuE6b9yWpJpixltUH3aCD6H6n4oXfwq9vWZPAoCSZMwcTnJDdfiyUPnMsx9LzhKTT53QnBlZcYCLzPnkKU6Smguuq2MS2ocsLmfAC6jVQXfR3qOogzK3YHxx/4A5OF1zhdMx22Q79XVg7wlkvqpJUmSfjhrDU592oMiU1Eq+zY39aXrwsNzJz8FuFJYaifw+qehqKkRRk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WWtGNmZzYldqOFBHdEVJYXoxNkgxVDczVmIwaUh0blpHTnJURTR5dm9UUGgz?=
 =?utf-8?B?N2F3OVZPS0xzNW9uQ0FKejhzTmdoWFpMcmhFQjFVOVdsNDZVbXp0aEpyR21a?=
 =?utf-8?B?ZGQ3MXI4cml4OU9tV0dIc2p2cWRWOUllS2labysyTjZmc0Zlb0t5RDgzTHdm?=
 =?utf-8?B?SlphSGFYSmpjL1g1LzZnV2ZsQXFnZGx4dTNRU0hhdTVIYzhtMVVUN3pweE5p?=
 =?utf-8?B?ZGFWZmVHUXJMd21SbEV2ZzFiVzNiWEZPSGN1Qm1GaXJQWkdTSlgwOE1NRUZj?=
 =?utf-8?B?eU9tWVBXUnVVdFR0ZHB4b3c4anFDZ0JFaGRzdkUrbmprZnhhZW9aT1J4b0Vu?=
 =?utf-8?B?SzB0d3NRdXlvQlczU2ZmMzRaL0V0Ly9LcjN6bm9Xa0twK25PRlQ5Z1BGY0cx?=
 =?utf-8?B?d3VVa2RBYWZCejBrWGF3YVJpdTZVdUtvaUNpWUdRZlgzK0V6ZXZzeklhRm1U?=
 =?utf-8?B?cnNwL202aForRklsSTgyTlgwdmcvSnFpck5pUm5kbUtPZzVCUm12ZitMOUQ4?=
 =?utf-8?B?eFhDNDRWSHpWYkRETFdFMS80UUZwU2MycC8xK1A4RDZKQTBCOS96Wkt4ME1B?=
 =?utf-8?B?dlh3ME43WnM1VHpvUUVrV2lQY1Irb1hHL1BaMk02cGY4K3JJMVZxN0Q4K0ox?=
 =?utf-8?B?NWZDaVhyVmM1dFBqYlZ5allOcnh2VXBEZHJjZkc0RnVhblFhcmVES0N4cC95?=
 =?utf-8?B?UkVLd0x2MVIwOW42VXE4Nng1d2JiOFNkOVRyYXJmSUxmbGtWWEl3Y1pkRDI2?=
 =?utf-8?B?emJnUGYyZnd2MGl1QmR5d28vSW5aVzE5dnhycGVlR2pKbC9xMVJtdDh5Qjdw?=
 =?utf-8?B?cDNXYis4WFZGb2Ribk5pVnp5ZHJCL09JSkpESmsrSDZyZE9xN01LNiszSmFp?=
 =?utf-8?B?aUgxWlczdjdsUG5wRm4vaFhBMEZna1F3RzFWZnhhVGpHK2V0RlZhVWsweWd1?=
 =?utf-8?B?WlNuU1FuYzdiSDc5MWZCVFJ3NEFscllTREJ1bFBCbm1rS2tYRkRnNkJMM3Nt?=
 =?utf-8?B?NlplRDJoREhnYnpUTG9EZWVueUQxMFBvTGdHendSbzZya1I1VndKazh0elR1?=
 =?utf-8?B?cHFYWkdoR0Q1amxlRm1hWDRIdEh0QVpNQ1QzdUk4cUtsV3kyQXdVUTRGVm16?=
 =?utf-8?B?REVhV3d4UmtaZ0s4T1huN0pTSFVpd0xKMDIzeFdyRzBKMXpMTmNoYzM1OTVx?=
 =?utf-8?B?NkNhaFJzWUZPM0RkQXdHYVBGdU9aUjJsQlBxTHAyUy9qY0NvdkpKbGtxZm5P?=
 =?utf-8?B?S1gvNGQ3eXdqUTRJK1FmVE0rSjhhZDAzQm5MSlRySC9yQmFMOVBGdzg4bnh2?=
 =?utf-8?B?NjduSHJYS1hVT3NsbTRGcnRUMG9TMm0xL3VDVmZ1UGJyVGcwZDBnRWMvNVd3?=
 =?utf-8?B?YlVRQTdCQVBQdHN1M2ZjU0FJaEdnL2VvY3g1US91ZFJETVVXeUdIektvTFMv?=
 =?utf-8?B?QnBVUXN6V3BkdDVuS3FDRWVwMW9DTmx1b0pSdzhpcWxRN3RyN0F2Vi94a2hq?=
 =?utf-8?B?T0FzcnZzeXFoeDBzemNQQlVIRzl2eHNocCs5c3FaTC9lTGpSVW1WVm9wMjBt?=
 =?utf-8?B?dDhLTFJ4Nyt5cGc3Yjk0ZVp5V0UwenV6MUNHUHl4YXFRMUgxZDdVSFNkQzZk?=
 =?utf-8?B?WTRtZWJFTzBJWEcvU1JzSi9rS20rUjRoQTU3VklCRmthbHRtN2pBNUNPd1Fz?=
 =?utf-8?B?cXZBN2NRZDRZY09Ub1ZkaW5hOWd4U3lpSTB1WlJuNGwyRXAwQjVwQmcyU050?=
 =?utf-8?B?UUlTcVJjU29VRTVlK2FiUW95T0o3c0JydThuRklIVTBjVi83T1d2dkFuUXp0?=
 =?utf-8?B?Q2RaVGpOZTdOc2RaaGJDQ0poLzRtMEt0TWMxZC9oNHhTby9LRGtzK2FGTkNn?=
 =?utf-8?B?eHZqdmFYNGRjNXJnaDEyR0pMYnE3dEpicW9Od2V1VFkzNWYxSVQ2ckFaeWdK?=
 =?utf-8?B?OG5HODhIcnF0UHRra1ZPR1U4RTNMM3pUU1pNd1d0RHhBTTE5RzZzTXQ5UEJL?=
 =?utf-8?B?cUtrOHBJUzE5Q2NpMkVFTUZ2TVhZbVNpVXdXVzA2dGJnVXJxWE5acFBnMy9B?=
 =?utf-8?B?WjFzcXhURDJjdHk0T2w1eDJQVVZyZG9SZ0dWbzdnVHY2RlE5bCt0NmlVVmdk?=
 =?utf-8?Q?BL6/YC5xKFEzYmbt3XMTkF9Yo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/SscM1uHIVkTwxg1qsqXZ9/hOPg8QY4VrZOmm/QlRgz6e0SkAepK+VX1sq4hoHCJbtYNq1zjZE3OuyALYL3CSFhdPbq0jP7zlmd52PmrMzVJ+yW2BU+DxbQ2Kb81VKX7kYIQcTS5i1XIxVVVJ0FLJoTjwvdIC7oonVTMA0GYFzyQYDpVXEevlEVXKD6yxGq51oFSJ8MWX0xWMy83FoyJufE+2BJVuwUuA7abvDS8ySyr3A2J0nRg3YqOgjO0cczQdZa0tuIRW4JSjqEXhRqmFFsoghL6eHN6mW3qvI3lh0o1Y5KHZnmE+2mzTycGhfhXb9cDz5ffNifz6xgOWKcF5ZZm+sFsSg/w6LKt1P7wmC5apokiN/DEPj7ILa/tcCaBZ2SiPbBbzxOguI6uNLJ7APTnBnx35KwUVDo4IHtDm7qyWWdzrgsusbvKaEFjRZ1eum1/QWP16183OTp0hDT+lNr7noV3OaMfT0ABC+uOLcyoa9Ulx9kiLtMdMtBnvomYvNyX+SQoCtJ7NBMw9p6r7tEvyIbaAxX3eaEpDIoPTWStLoAgucA+wLR9AhrCwOUweGAM6TyaiAwqnT70GZYA7raytcfdXm/hcCJRmtrrdJc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686e7b25-ff98-4c23-8c26-08dc55580246
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 10:06:06.6372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ff6lytwqquihIj6PzQDNB5WbILfSTQrpqbme81bg8YxBFTIp2nJOilk4bp79C99RkoTiZ7OgpPg8m0/685Y2Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7948
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_09,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404050074
X-Proofpoint-GUID: UyO-vC1s00mC5iTNe4zczoTaDVrRlujJ
X-Proofpoint-ORIG-GUID: UyO-vC1s00mC5iTNe4zczoTaDVrRlujJ

On 04/04/2024 17:48, Matthew Wilcox wrote:
>>> The thing is that there's no requirement for an interface as complex as
>>> the one you're proposing here.  I've talked to a few database people
>>> and all they want is to increase the untorn write boundary from "one
>>> disc block" to one database block, typically 8kB or 16kB.
>>>
>>> So they would be quite happy with a much simpler interface where they
>>> set the inode block size at inode creation time,
>> We want to support untorn writes for bdev file operations - how can we set
>> the inode block size there? Currently it is based on logical block size.
> ioctl(BLKBSZSET), I guess?  That currently limits to PAGE_SIZE, but I
> think we can remove that limitation with the bs>PS patches.

We want a consistent interface for bdev and regular files, so that would 
need to work for FSes also. FSes(XFS) work based on a homogeneous inode 
blocksize, which is the SB blocksize.

Furthermore, we would seem to be mixing different concepts here. 
Currently in Linux we say that a logical block size write is atomic. In 
the block layer, we split BIOs on LBS boundaries. iomap creates BIOs 
based on LBS boundaries. But writing a FS block is not always guaranteed 
to be atomic, as far as I'm concerned. So just increasing the inode 
block size / FS block size does not really change anything, in itself.

> 
>>> and then all writes to
>>> that inode were guaranteed to be untorn.  This would also be simpler to
>>> implement for buffered writes.
>> We did consider that. Won't that lead to the possibility of breaking
>> existing applications which want to do regular unaligned writes to these
>> files? We do know that mysql/innodb does have some "compressed" mode of
>> operation, which involves regular writes to the same file which wants untorn
>> writes.
> If you're talking about "regular unaligned buffered writes", then that
> won't break.  If you cross a folio boundary, the result may be torn,
> but if you're crossing a block boundary you expect that.
> 
>> Furthermore, untorn writes in HW are expensive - for SCSI anyway. Do we
>> always want these for such a file?
> Do untorn writes actually exist in SCSI?  I was under the impression
> nobody had actually implemented them in SCSI hardware.

I know that some SCSI targets actually atomically write data in chunks > 
LBS. Obviously atomic vs non-atomic performance is a moot point there, 
as data is implicitly always atomically written.

We actually have an mysql/innodb port of this API working on such a SCSI 
target.

However I am not sure about atomic write support for other SCSI targets.

> 
>> We saw untorn writes as not being a property of the file or even the inode
>> itself, but rather an attribute of the specific IO being issued from the
>> userspace application.
> The problem is that keeping track of that is expensive for buffered
> writes.  It's a model that only works for direct IO.  Arguably we
> could make it work for O_SYNC buffered IO, but that'll require some
> surgery.

To me, O_ATOMIC would be required for buffered atomic writes IO, as we 
want a fixed-sized IO, so that would mean no mixing of atomic and 
non-atomic IO.

Thanks,
John


