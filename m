Return-Path: <io-uring+bounces-634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F9B85A44C
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 132AE1C2234D
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3585D364D2;
	Mon, 19 Feb 2024 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jHuKskMz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FzS2/d/8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A5F3612A;
	Mon, 19 Feb 2024 13:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708348000; cv=fail; b=FMoEFX04MVvXdQNmsxZT57/ZXzxyAuQDYOawQ5RjqfTWK/zKqf9Mk6kYernDm9j2xPbb8E3IYR8SCHeUlyocAdGPOWWAzZQlZyikIO/9d9ZuBMxIS+Wyfi9Fr2BrFsDDk4FEZBcoRMBJAk43pjGNsRvU17PjsWKRHE05O4LSJ9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708348000; c=relaxed/simple;
	bh=OPfU/Tkd3zftI9fqsaWyjC1x67rqDhMSB0sd3AUgwq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XJWgWecBX6DpdzsbZMd80DQHULlXZOKaYhtv/DsbwFWJinB3cb16WDnQEEydjA+0G+S4hcTgMarV3XXppEK65oeT8S8GTX/s9G8WK23upnmmVzsA8Jik1wAWBZeKtFsRmqxCZlyDywrGoeAAsX3F/WmZcaah9m2ADWvVhtam08M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jHuKskMz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FzS2/d/8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OEjS010902;
	Mon, 19 Feb 2024 13:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=nHx1hyaJMbhfJmp8DWV+HBm9MJEKloLiie8SWT8nV6E=;
 b=jHuKskMz9GPwt3bGNrKDICtnff+q9r8F4XSCd0ZFQPOQKnZFPcWVzR8XoXXXJq33D4Xn
 BfUjdz1QdmyUwTogXQK5DDj+qXR5Ya2LuanOB73bDmmRuCxQENkQwTr3bM9mr+ne/EEx
 LZZBdL46FMyGlUjV7Umr9vDxWBG/ZlaDb76whp2NqZrsVFkItDfNw5KQxzoWvJGJXiLt
 u60OxoIbi+bnb2ia005sbZ6MP5IatdTh0ML39b25vAC3qsF12vuWGf9sbBbMfv8uM0tg
 mJ9MmRtE4XC/VZJVW0ayJnZjegaMg9FEDM/j3yM3pSuZEYo/1ahYENU/yCVpsgjFnMvz Ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wak7ec4h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPC6c006570;
	Mon, 19 Feb 2024 13:01:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak864knj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIWBkgtWNZ2BZCtu7uSLqmQ8E5sOHdgTPvh2lcR7+nRtXiSUM2AaW4KuU064zRZIYvi0tEQevdGuFXJnFoujZa/Srx7DClZZEAfx2dZuViKGS+buXouDuDLY4TpHIIygNwUx7OgP1s0QkDw7i51O7aVFAG0Osf3arwkf1w7tbmrhuPLi4MOqDZeon1AljWmtqgTceD79XAeSWftC38PaNHoQV/amJ00GLI2c9OYiPg/roNvNZZ1iIMpAiIUIemxMuC68kOWzVrHIrYV7gGbIHZtMUwKgxuIwKWGZpKBhDzHhSU4kkm9sbRzPOj6RSYNTjRYar76aGzbubCw2mNLV8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHx1hyaJMbhfJmp8DWV+HBm9MJEKloLiie8SWT8nV6E=;
 b=jK49m5BxkWjXk9aQL1o4xK/pdEHpqHha9Gb8al/V9uDBbaLYrKtT5PH3HsKmL1Y0oqTOVBGex6VB8OO9gK+xOoeMSwa+/EKbiaE4iv3Q+cYRRyr34mSlN072bWU1brzcuApVTkslB4JxKUOHCxytFcEVNvI4s91k92CmINgY2RKyckOsov/fblFXuvCUdzlPbMbkWwJJUznCd8Cuf9Uv6Jka8MA2r8LfbRrqp9wyflq2Z71IAfI/aIU6MZrvk5m39cpUBlZ0ADMpDMBWmjLs/I2LBf5RpMGb32iQm3KUUPMBZPE/qaXFw1yl/h5jCYBhaAVHPRaPx+0y3wsjCZ6NRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHx1hyaJMbhfJmp8DWV+HBm9MJEKloLiie8SWT8nV6E=;
 b=FzS2/d/8u6Ql87Gi098wzUr8zI1vntM7qw2E/WnCP+BZkMNIcBc+6k6DE6lK+eR3QsNH3PZ3NRRLtdjOE1WJdL/oB9Igx/Q4+EMz1MCm9IqpNbDAqJtFdBD1HHbZ+oQoOCys5zw30qh3xtixfBQXj4hNRGdEQ+YpK4wylhIPq5M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 03/11] fs: Initial atomic write support
Date: Mon, 19 Feb 2024 13:01:01 +0000
Message-Id: <20240219130109.341523-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:a03:255::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: a8042768-2753-4f43-403f-08dc314ae8b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xlor15mgWYpay+Dao/hwY0zonM2dBSN0LIBwO6gCjkZXdChujlrfBr5F1aIxGgdb+3KymlhtM+Od78J8dYyiZEVGERT8Wk1IKimXjAF4g6rYga91cyNhREwN7d9TbEgK1BUivmhk/j6uIpB2FvwN0jbNhkEKjiRrjZPlsYLXYU35rC8ZcAUOXg4Ni/WjCCErp4cyrqbXzlmaLePiMwzUP6iaG07ufdPpTpcTgHCOdTJ3d7SNVDKrBYxgdmHdBqUy0xYPU7QumPx6udOE0L7XrZmkgyNCuagH5On7eQsygHuPwMTSPbf9gLfYb0DphmZhGYEo81Fngu4R6g90scDifgwwHvIBCRZsNHsdFQX7T+KAmPzdSugFRSEP9ykOB9gk1alJHd7HKpLbeICHpLMu5dVS9gZdI4CASTnnRAQkXARsn4lGUMqOImWemkpEtcXXqcJiqkx4UJIc8plp3A3OsAfDG2DAdRbYcii2GfcdbRRyG1A2dn72vfGbhxwE9inHkbTdo3nEBfCez3/BixHuQUEO86E9cnn0cKFLgAl7VoLWys2/lY/BD4DjgvQS0UE0cjy0wWXXuFTSP3BdFh7/P5CgAxCB5Wp4sL6La4xwVLU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tkQgAcWle0PokRNTlYcKL7V57D9q56gt/QwTL5aiFXuKeqdN4tuZay5DKaC1?=
 =?us-ascii?Q?KAS4wtu61IpOu+5FA60kKS1P1bGruCKLkDgE/RSsTF8536BCgoi6gAgYJrqx?=
 =?us-ascii?Q?wuTpzsvtUFUZPdI3+CZMwdBZjGzaXa8eLJy20F1cjtHtYMf6bJe2UWWrKE6q?=
 =?us-ascii?Q?r6LO0BUBAAtDmXcPRShXvQhZ1NTHlJrJGFMaCKUeOv9IsiOxQmfJVl7pe42r?=
 =?us-ascii?Q?ITQ6km+A7vKB3mBn0LaY8vlhHG78bYeHP4LtUXeh7lDc98pi9AINvWOg9WEZ?=
 =?us-ascii?Q?3EI3EftO300T8G2y/JG69fFLx3WcMLqzaf8GxjstnxzBIUG8A3PfMOMTrqWB?=
 =?us-ascii?Q?SHwgFgnjVpCdCk1wL491mkDert/2BAPd4mU1MCYdcxXLy/CK4vz5v+KWaHQz?=
 =?us-ascii?Q?Dkf6+DjMV3eH/tWW9lmWdRrY8xV2acuzY2T1N9INDLapa/C0xd6bjj6sY9pJ?=
 =?us-ascii?Q?y/wR+iZ2N0EN0LQUSXVF/fbdZfdta8LyGjhd75Nlsox9weLyZN4OzfwkuWqf?=
 =?us-ascii?Q?+HHIqRrDHGOqPWNt4qrZcD7Icv6ABjbE+w4k8GJ3MSe6yqjJCfzolrSaiDFN?=
 =?us-ascii?Q?g1FIhpFZR77wKxwoaDe3o+ej7pzsjaGyqcQu2n+tGUy8mWfe6hvah+hhwqMj?=
 =?us-ascii?Q?+sP8T2+DL/XUaGxUr2RTstm4M3vLKkiP6HaspoVZlVlROUEH9svr2eOh2AAG?=
 =?us-ascii?Q?pwrJiofdt+mCRU0rPa4QahQTNSAQxBwDSNGlwXpp+VA68x1swEzSdKJ+uPIj?=
 =?us-ascii?Q?qYKDrX0tue5kMnMbQ1Iv6AYM8nzj5lj6nny+rP6i0B87ZU9Zq4aoRSqzM9SS?=
 =?us-ascii?Q?ZQoi6RE1UUB+k6ko1sSoYr4BP3c6nGDxNnkEu3hSAmDmqn92/Lz9bBpHhkPX?=
 =?us-ascii?Q?4pN9ethy2Z5uiGqNhUw4iWzpXlOhPxylr4r99BsvRL4k0L086xFv7/EENR0B?=
 =?us-ascii?Q?sRBvMDxqihdyDFO8S/nNmIkU25L8RF9NyjJ94IQdgRevAo+vqMiomNxzvuRO?=
 =?us-ascii?Q?VbLk2I01jQqJ6+vbndFFSkwGIgdcgKfoMpQBKP/pM8lyYdkRi3gJujY2pI3E?=
 =?us-ascii?Q?RcjWmYnqwgbhgfpcVpFrIXSn+lwVwytNbxgbrb91zh8mFIst4ybKfFX3R1SS?=
 =?us-ascii?Q?CjAmoAmmdjQfAMqCS6XaVBXwHR0SHIvYf+jrmrevShvhi4ltWTv85XVh5ZXh?=
 =?us-ascii?Q?GiChICMGsAxRoOmxPOQdN6iPmGhy/5bTv7b/55d1SUXQrxYXBR/HivHCeRjg?=
 =?us-ascii?Q?JHpU95y39dOBRio7pzRLXnn+MjqlPVf820gq4cTisQ5cGQb1znS2Y7pYtXXR?=
 =?us-ascii?Q?Ee9uO5vGLBKVImHbqM2qWGdn1uSMxZNV/PDI4GcYtVcTU0S5q18EcwIeLXwL?=
 =?us-ascii?Q?LgFFE6eTZhltbgLdDcZpoxr6GYTKcLPEKe7++OyKJUGxqXcYmo/5OdxlI1FW?=
 =?us-ascii?Q?quBdwBW4hoKIkhvPi6KAxJZzYL0uScqlps0xS0RkwMu+WHLwsQjFEc/BvkY6?=
 =?us-ascii?Q?csH6hoKpb1JKBsiHyR6dt/Fvc9S6Aa8BiN/RbPb1Lr9ACxZzNbgx9y3XlNTl?=
 =?us-ascii?Q?/h2WPKaoBD9stsvaZW/o9lv1t+iKVlHYYRs35VfKiJ9aYzL+epXnf1Vr8kq8?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PdbPABrsS22coTJlHDDDHRIn0xaAA6A6yuVl9r8f6+gmd5kZTcDgrfqfVyToRbtiTHktZzmMb1LcNQzDjX2Bk7ZZXa8FLcL48vgOBcZBewjnUbX6pDoliI3yQd94HpkeFYabdx69oevap3WkD0HwAPgEaCjkiLI/SK5U+hZuaU6wH8XzM1UAY/hXwPLuw42qZY7i2KV+QIlW443sYTK4eKlDOZs9idTmt9sV/CRFA/rGFdB68/rvoLSqTv/1C29WCZwEAddkt0ksSQz58e8xVeXK2CGYW0lUPEIYrGToSvYFVd2z7Dsdm615827+jqHgthxbW0clW3QiRgkX0xF7pdhy8gtQdktLsrlFlFfgZ3WRV2/Y953sBnThosuYVbK4JXipyRdAOf/jKhZVA+KmN+PGx3iNoeWh2YnAMvHFtn3Ypi1yFCoBQr78X4K9mhXeXV3EKniy3NTdfNkI35y6fjVLSlgI8FTE3Pzwt5qHfUVnhe5EUMi2bYeihvYsgEXWqh91KXQaUARSs9qg/Nct8nt6Hjp6lJnpajhKWieoJjsUCSMecsZCKctQpLF6Y2Jq60iPEjlpDE7PUS+Tb9NrCX5hCJ7NxsM2jWZJRF48LLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8042768-2753-4f43-403f-08dc314ae8b3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:38.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPmrmMam2uMPL0+IEbA6bi8Dg83pparjLWDE+0TQG49PXd7hePK3dUVJ5klluZ5EjzYi6PylcMSa/aP+yGQigQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: u2Ro1MPHJWSV21Hjz9-0-ZPCBd30PZVg
X-Proofpoint-ORIG-GUID: u2Ro1MPHJWSV21Hjz9-0-ZPCBd30PZVg

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

An atomic write is a write issued with torn-write protection, meaning
that for a power failure or any other hardware failure, all or none of the
data from the write will be stored, but never a mix of old and new data.

Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
write is to be issued with torn-write prevention, according to special
alignment and length rules.

For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
iocb->ki_flags field to indicate the same.

A call to statx will give the relevant atomic write info for a file:
- atomic_write_unit_min
- atomic_write_unit_max
- atomic_write_segments_max

Both min and max values must be a power-of-2.

Applications can avail of atomic write feature by ensuring that the total
length of a write is a power-of-2 in size and also sized between
atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
must ensure that the write is at a naturally-aligned offset in the file
wrt the total write length. The value in atomic_write_segments_max
indicates the upper limit for IOV_ITER iovcnt.

Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
flag set will have RWF_ATOMIC rejected and not just ignored.

Add a type argument to kiocb_set_rw_flags() to allows reads which have
RWF_ATOMIC set to be rejected.

Helper function atomic_write_valid() can be used by FSes to verify
compliant writes.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
#jpg: merge into single patch and much rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/aio.c                |  8 ++++----
 fs/btrfs/ioctl.c        |  2 +-
 fs/read_write.c         |  2 +-
 include/linux/fs.h      | 36 +++++++++++++++++++++++++++++++++++-
 include/uapi/linux/fs.h |  5 ++++-
 io_uring/rw.c           |  4 ++--
 6 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index bb2ff48991f3..21bcbc076fd0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1502,7 +1502,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
 	iocb_put(iocb);
 }
 
-static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
+static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int type)
 {
 	int ret;
 
@@ -1528,7 +1528,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	} else
 		req->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
+	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags, type);
 	if (unlikely(ret))
 		return ret;
 
@@ -1580,7 +1580,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, READ);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1607,7 +1607,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, WRITE);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac3316e0d11c..455f06d94b11 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4555,7 +4555,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 		goto out_iov;
 
 	init_sync_kiocb(&kiocb, file);
-	ret = kiocb_set_rw_flags(&kiocb, 0);
+	ret = kiocb_set_rw_flags(&kiocb, 0, WRITE);
 	if (ret)
 		goto out_iov;
 	kiocb.ki_pos = pos;
diff --git a/fs/read_write.c b/fs/read_write.c
index d4c036e82b6c..a7dc1819192d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -730,7 +730,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	ssize_t ret;
 
 	init_sync_kiocb(&kiocb, filp);
-	ret = kiocb_set_rw_flags(&kiocb, flags);
+	ret = kiocb_set_rw_flags(&kiocb, flags, type);
 	if (ret)
 		return ret;
 	kiocb.ki_pos = (ppos ? *ppos : 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 023f37c60709..7271640fd600 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -43,6 +43,7 @@
 #include <linux/cred.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -119,6 +120,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_PWRITE		((__force fmode_t)0x10)
 /* File is opened for execution with sys_execve / sys_uselib */
 #define FMODE_EXEC		((__force fmode_t)0x20)
+
+/* File supports atomic writes */
+#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)0x40)
+
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)0x200)
 /* 64bit hashes as llseek() offset (for directories) */
@@ -328,6 +333,7 @@ enum rw_hint {
 #define IOCB_SYNC		(__force int) RWF_SYNC
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
+#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -3321,7 +3327,7 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags, int type)
 {
 	int kiocb_flags = 0;
 
@@ -3338,6 +3344,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 			return -EOPNOTSUPP;
 		kiocb_flags |= IOCB_NOIO;
 	}
+	if (flags & RWF_ATOMIC) {
+		if (type == READ)
+			return -EOPNOTSUPP;
+		if (!(ki->ki_filp->f_mode & FMODE_CAN_ATOMIC_WRITE))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
@@ -3523,4 +3535,26 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+static inline bool atomic_write_valid(loff_t pos, struct iov_iter *iter,
+			   unsigned int unit_min, unsigned int unit_max)
+{
+	size_t len = iov_iter_count(iter);
+
+	if (!iter_is_ubuf(iter))
+		return false;
+
+	if (len == unit_min || len == unit_max) {
+		/* ok if exactly min or max */
+	} else if (len < unit_min || len > unit_max) {
+		return false;
+	} else if (!is_power_of_2(len)) {
+		return false;
+	}
+
+	if (pos & (len - 1))
+		return false;
+
+	return true;
+}
+
 #endif /* _LINUX_FS_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 48ad69f7722e..a0975ae81e64 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -301,9 +301,12 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO O_APPEND */
 #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
 
+/* Atomic Write */
+#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND)
+			 RWF_APPEND | RWF_ATOMIC)
 
 /* Pagemap ioctl */
 #define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..f8c022301cf4 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -719,7 +719,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	struct kiocb *kiocb = &rw->kiocb;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file = req->file;
-	int ret;
+	int ret, type = (mode == FMODE_WRITE) ? WRITE : READ;
 
 	if (unlikely(!file || !(file->f_mode & mode)))
 		return -EBADF;
@@ -728,7 +728,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file);
 
 	kiocb->ki_flags = file->f_iocb_flags;
-	ret = kiocb_set_rw_flags(kiocb, rw->flags);
+	ret = kiocb_set_rw_flags(kiocb, rw->flags, type);
 	if (unlikely(ret))
 		return ret;
 	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
-- 
2.31.1


