Return-Path: <io-uring+bounces-2296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CBE9104E7
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAFF4286A57
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4621AD499;
	Thu, 20 Jun 2024 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kv83NW30";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PUugbRjy"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8CE1ACE76;
	Thu, 20 Jun 2024 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888172; cv=fail; b=BPbMTQviKkOrR1QMZ+X8hKTWZbo/ADM/rGRP8qtjaIQ4EsDICKgZfXu8c7gEhXvL1J/gGafd95nRcTCMOiEHBj83SUHckbC3j9jxcVsl+gNLjhUaUTQOIyLhTfiCbxyarjed14ZuDAhd3y2R3NgB3uR5R6yoLoOp4kcSEsyc31g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888172; c=relaxed/simple;
	bh=MBSLZXCGPswbj5Ji5qHqFHaBodyKmw1NJwKarTGj2/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ItFDg4pHh0tJtRcNc0EJeRy0u0inVwis+K1/VIkYU8hJT0nHVo6dxcK3IkYVcHM0eZs0bYsvWMndVRmwboaMXlkuXB6vQiJD+cukWlwNGaNLvWrXeMIHUguhw4eacLN9lwFxcDLaoJgwAH7lfsWIGEvHIsfj3vuMTMqw/xnk+v0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kv83NW30; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PUugbRjy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FjjW014911;
	Thu, 20 Jun 2024 12:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=hKEsTIi4kwQMcHsGvo+ulq4GZSRO5ofNKcQ8PU1sS9g=; b=
	Kv83NW30UNffzAtL07V7Hz4XUhYRmEp91bf8SE/rogGP7Cl15PRFEUxuO7xBOnJC
	LVupg59x0z1/r/CsbigEfZ1jw62N7D1c6AgH20KggnDkjdewKlC+kwr+7QWD62X3
	4Fswqqe/9g4YFnwz2RR0OoZNlesJ8D+0M5Jb2xJYM64JrNOEOIkqn27Ktz0Dn0i9
	/ddwIcCwz89uS47vz/ZG/vsz0sAxzfZozqoZqgCyvMLNebhe3NBMFilGYCiQjIq1
	R8kkTxlIP57EhDrespKBDt2OieoRIP4uc1j/AV7LW/9frEUGSBIUqCW0UrFU4ed1
	Ql6o8WuNqmEq3yrAX03wqQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9gk54b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCbFx0032811;
	Thu, 20 Jun 2024 12:54:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dae6hc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrdDvB9PrBpLwbfhqh2PSEynzNYevxEW6bOL6F7tlKUWnVPWvIsXh/tGL9axVvnNAMy/8hCIeR2EJWG3PGluJo41qU+LBFu/IBloDCbKU4efm2PLX1D/ak8XqS7s0xiUVgj9HrPli3ATtg/0Ao4FFO4mGjQ7nI3FfsJ7tRrqBvuEqygFZNLRCoxuMQOUZVvbdhS6RyFg0j4AtM9ZW3fGqckZq+yTK/PFnUtrlE1d5ZmgFkZWG9gTc/8DRMtzWei+KayzPL8Ylwj+QVo7wCAKHjiWd9r5olrpzNEu15HZwcIEsWPW0RZiSkf0CZp4tyFGaAiJtHCFNBgoX+ImVcfzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKEsTIi4kwQMcHsGvo+ulq4GZSRO5ofNKcQ8PU1sS9g=;
 b=mV90fniL4ENaRfK7U4HHjvEkg7GdfKNtG1/l/zRxYAd/fOB0mbou9LOjHgsVlIk6NlMv/MM8TLYP8z53jgttMMkx+EbOS67JWF2P8DpCMXJXNbNm1yDAWCfaHAzVThNoBOSpXo2oV9iHQSASgU1ITUzbvqpOrAOWPdgq1/tMPWcQB7EuDjDQedXzRWGGMYEjMiWBJhN4NY3grWqhi7lOCr3dBu9fKJGUW8lSHm65BtNfe1RlgECWi3lqLjgCT2ny21TjPbSgN/8oLhj95LHNuWeXBs+hwfWsY7rFn/EBuRGJsdkS4wPQ3xrlgJnVA39n7f2btnW0IgX+HXiPaKFIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKEsTIi4kwQMcHsGvo+ulq4GZSRO5ofNKcQ8PU1sS9g=;
 b=PUugbRjyEQMOgDq+3/ZhVssYkNvKRmTMbLyv76/EbkbNwRaSUyNblIpGFgSe+ep81lSEhWZ5b5ewHmuvFGPbYfI7CIkLtskQRQGkxAJX7hMSUyUINNZljq9DrVT7TXPTehT0NLmLqkRrT48W+5Lerhmydjx1NNvdTcO6y9bxsm4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        John Garry <john.g.garry@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [Patch v9 05/10] block: Add core atomic write support
Date: Thu, 20 Jun 2024 12:53:54 +0000
Message-Id: <20240620125359.2684798-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0002.namprd15.prod.outlook.com
 (2603:10b6:207:17::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 798024fe-376c-4861-319a-08dc91282104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?9lph+fVJ0NWzSJfv3kQa4NAoZjI7HSw5sk9FXh89y+Yp/tE0BUffd4K8/+dV?=
 =?us-ascii?Q?uKTRICjrLhDQZBl8gz5oVpjeOpMLO8T/nMczuQkkdNvNJY2kbyg43JL/J2gm?=
 =?us-ascii?Q?JtKIzpZcECJivLMDqF02xzAR5389N8YnxUBL0c+pHXA8WKnn/Cyw+VUi3yuV?=
 =?us-ascii?Q?cm/HD69FX4tyQ7199TBHNVQSOs+UoiYyCYKRYQd6nRZbvnHZbfX8p2rVQaYn?=
 =?us-ascii?Q?fZvybEpJ3jDnUwr5yIPXG+k91x93NFTKdpcwYLEGCCPednU0vcpbgRpnEUos?=
 =?us-ascii?Q?flFR/N0rQcU6R0luApkaYLMNWYr1gOUd4DEWr/vjwrdZDvkMcCaFSI9iUcHv?=
 =?us-ascii?Q?6/OGuQuHJlf2Yh5DbeV17BS6keRTBlCfpT0sAU4B68Fk/7WzPkH2yp3icah4?=
 =?us-ascii?Q?75er9qWsbBpE2rsPe70cF6h1ob+NyVh6uSilTzyHsCqOmsCBkV6qlKPp8TFA?=
 =?us-ascii?Q?mz50CrnskWFdCDWFG0Mg4FM776//F2RyeGMfmeVqnLske0sSqWmx7LIVzpK2?=
 =?us-ascii?Q?4z7ftLDsTu/QmvY5KLd19uOe07f6qxJlU7035C/424bf70XVAVi/DNQXdqEv?=
 =?us-ascii?Q?720fnLxZrYz+rnW+5lBFrzT5XKJjiOreWjpdP8Q4XK2pzOM8301FRiALwTpd?=
 =?us-ascii?Q?TsuB4vDUNzBDLnkwPnhYzuObMmJv1a7lM0k3o0aLN53sOlPpn0jHIjFZyp/c?=
 =?us-ascii?Q?kGcFNLeHzL5qZcyatvsSr6HUvgBd7ZKpq0JyM2e8Zpezc+gwIc+ANaM615sz?=
 =?us-ascii?Q?Zd+xPidZv6rqSJBSCEGlGUXt+FGT+G8sXpOrmEm9ShfTMp0ryj6qKFK/EGNN?=
 =?us-ascii?Q?7LUnscbR1U4lxcgeEFFQIRgoGOxgNs9+EtfYFrFXOp49S4j1wZ3OpvRwq6/S?=
 =?us-ascii?Q?nQhxUaF8Tr5Z9n2IMXIe7QTlVuLmxEyPbS3irxj5J0Cv9ZDOm2zvZ731sx6C?=
 =?us-ascii?Q?foqwMY3PfliN+64il4D/N2/rx/PDmo/u7UXR7fK07K5h3Vw0owDMDzCPCIGR?=
 =?us-ascii?Q?GTxQXzBHzJYmgbQcB8NbCV45Nw7rlP5o8SbO/WHo/CGHzVByq50BoxeWTlYf?=
 =?us-ascii?Q?9L50/SisMt1pdbYlrEXhsxi4XtDaMragO6ce2j/vWf9Loy+V0yqicbAehobP?=
 =?us-ascii?Q?71IOZWfCfQc6udfKwcS8PViql9qicj8rAttvcMGQ1+B5IBsqIsbDIJsghz9N?=
 =?us-ascii?Q?bgA+WhiATUtKN9TPzhtwR5S3CpPURaMBx3zzhCqwEIvS2ZTXTEr2eHkLqnuR?=
 =?us-ascii?Q?OGyPyt68qWkOxlH9tnZMomKYJPPaF4uPl4CVUjsR8MQXC0wOySCk/uri0gnN?=
 =?us-ascii?Q?+mB+Q3gcPmj2YcwlSRhwWYW7G7aRMhMbeokyE6MJb5Hh8VVKyhbC9Kz6omSe?=
 =?us-ascii?Q?VbPRcjA=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?cKj/BpesXwdcjA3ef//00MhTVyC+mtvtBRIfHWIwfBcUdBIsNQEYeE8wjpcZ?=
 =?us-ascii?Q?Gs4q/PgaryDqewhpofKWhRcfBYC+oQeDVH3bR6EOeIT+RIW4hGamIqJaSoHo?=
 =?us-ascii?Q?YkoxMlH6pp+B7FzjZOhGVRSMXg93GHCokwKo51Fv5ufAt007/Lr9Ao6D3GsA?=
 =?us-ascii?Q?KIOLjHKJ27VcWa3jz8s4leGnTkx3Zu53d+GS1RAFtjQAqQjjhjoAhOf7rQxE?=
 =?us-ascii?Q?wP+kprrJFqRIl9aOtkToEvyhpotb27M7Jf9HCZ7isw6HfrOtFAw5j0t4hVES?=
 =?us-ascii?Q?sSJ987WJ43IaRmAKJd6GbDB1l2M89G+QbllFs2A0XPI3UYkTfKuRspWYwSHQ?=
 =?us-ascii?Q?NJcpEMZe41L5yTTxAtE6K6hBH9uEf80rXpffiAaaol79jc1S9EFfkl1S+jfK?=
 =?us-ascii?Q?mr2UZ84hwlj7KzwaFgbT24JQtNMF718Q0hwLtvnGI2lVLD0ypD1slqNiLzq/?=
 =?us-ascii?Q?QQ63O0RTJpKNmfXq3wsTy2Pte9LDdmguCmImJMR2yv9CAj6+/K75wALLRsZO?=
 =?us-ascii?Q?Y4mQGCsvOCuiWT8henYfEWCqe1tAvmtS4QP+vDI4c+92n/8eqIGqeBMn0aeP?=
 =?us-ascii?Q?uabhZ6MmRKG1LaA0K7OOtlA5wXviyhdjv8IpPaMoAy34lrkYRLjmoBK3tneK?=
 =?us-ascii?Q?S6WiJsOpnGMZ7dVyn+IZCmW2U4pPsXGxVtn999BDaJfICa39DPoH7s/zgQqE?=
 =?us-ascii?Q?no/A9NvRNaK2fE8JG63qLq35DpkzjY6AWZlsrHNuvTLBishpfLiut+kxXB/x?=
 =?us-ascii?Q?id8Z8VaTEZZwl5dAj76TlrJKZjd55MhPoRDX/0D/ZfxMrOgCyXG2tmqXa3I/?=
 =?us-ascii?Q?mqdQztx1ELycxbxZB/BCvtvfbefn+2EwcFaQYj/TCrx5rqKI4wmisifgDtU9?=
 =?us-ascii?Q?zp6N0kmRlL0sC3aiT67UKhHiaMtfZQuCAuCxk/pYns2P4REF8WhGM0M6kWSA?=
 =?us-ascii?Q?4J0UVJwqzJBDpPPSHUbKEg8C2lDN6GsEoBQV40X8NTMJVsTW23WTTMVRX1WD?=
 =?us-ascii?Q?d9f/0i32kXIA5mbXcoNX5UqNtKLq5CReJz+oTuvd7dU1ffgWAAVeCuv2ZLsx?=
 =?us-ascii?Q?PkrXVRhyhv0v7WJNovVX5X7k9ZDZryhG0Thx32Sld8N77fOWjdzMi0gdnQd5?=
 =?us-ascii?Q?ePB5+iHoxK/H6+XOejjrXQo24bUsNMOzWuuE9BMlUlVc57dgWxsFe8uaRk1b?=
 =?us-ascii?Q?u878JEBxLlSH5nM+diu+U3DPM15oFFXJZjI8Kk/H+Pf9oB2xa4udaHBw1z+o?=
 =?us-ascii?Q?fnmUcj+41V+BA5yDXoDcGUYyasPleATFVhTk5tGo76wVIg94AOepPuXuPoTr?=
 =?us-ascii?Q?JaCjSmd1vFKvgN/U3P0PuP6XiOV7bLSv6Ss0eQEbeqdDdo57QJcEANk3T0rr?=
 =?us-ascii?Q?EAtHAbs4rbZ4LdeJ/YAuLNgS4wyttnrk94QKJ9S29pJu5YKYcC8VM9Rxo0Wp?=
 =?us-ascii?Q?y9R52qK5dcAfFLG3XR3GVzC1jnAR+y1rywWvEs7VsOVxadpZU7rxbE+gk5AT?=
 =?us-ascii?Q?D1Z7MRSAA7UoWsK2U8+VvQz3XtzSC66qgZrzjW4GpMP5V+1iVKkhRd0zED2q?=
 =?us-ascii?Q?88miG8t+AhF2GIbag+ChVrKi6XdT4rBZzwCPzoKH4xNUbd22XR4t9kOJVGyh?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fq5N4kac1PzgyHDbrKyfv3N9xqQj/Uo25oRNGplXS5GMeVddlFZz5wB6wnrw+ZMxvIbDjqtDK9nZnZ68E3Hoc5NdcUFJ4+h3vg/fgHiHWyqjcfF6LT0teb6+SCt2vcAqfqfD6up+JAkAfBcY3IxW70J5DWZrc79oHrv9B507WAKUSNvv0fKTh/oy5F6kv8rtjqGuSZlSEfjM79oa5Ld9ZkZ9VucPKatkvwVWdpnMT2ZUPHvl7f/VT9Jp2Sh5YjysahJcULeM9+BjFrOsOHneQqKQTw5NUA+ClXkf5ZSKpp/niQugJ1m/DM/HqEmT6gN1XHqiFkdObACn318vyOacl93u3RE19CjLOgwT6GoQnuGNVSA6L1xTLU963SMCzj73b2icQbZ31KCiBDnrMkmZ7qHGcGroe4hnFxQB/sKU+FlKSldKo7o2wP2IS5Mjww5jOD5O3qSH0Xx0bcYes6sn8qLpcqtuxt1+WfyYPfGjt/0UhQSHM1psqQmCf0qu+u+jbbJ8atypHJMCrTpPw89vISKKQ0UIHv3mdcW2wyn3sSkXMcS8WhkAWMAvcb/cUlRXgt42rbbTFasNH8CdU0jAKeBJqmacnP9jLQHm8bX76XM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798024fe-376c-4861-319a-08dc91282104
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:31.9653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GxNpLaB+CyvdvT5kzxQpHUXH72V39e+lLOeYplVdZF8rbrSaQJguSHBaifYnmgWqtViq9VA0a5vgccyDfdjWzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406200092
X-Proofpoint-GUID: GKvkbmgKIevC4R35Lj79prY4lRd3zFl9
X-Proofpoint-ORIG-GUID: GKvkbmgKIevC4R35Lj79prY4lRd3zFl9

Add atomic write support, as follows:
- add helper functions to get request_queue atomic write limits
- report request_queue atomic write support limits to sysfs and update Doc
- support to safely merge atomic writes
- deal with splitting atomic writes
- misc helper functions
- add a per-request atomic write flag

New request_queue limits are added, as follows:
- atomic_write_hw_max is set by the block driver and is the maximum length
  of an atomic write which the device may support. It is not
  necessarily a power-of-2.
- atomic_write_max_sectors is derived from atomic_write_hw_max_sectors and
  max_hw_sectors. It is always a power-of-2. Atomic writes may be merged,
  and atomic_write_max_sectors would be the limit on a merged atomic write
  request size. This value is not capped at max_sectors, as the value in
  max_sectors can be controlled from userspace, and it would only cause
  trouble if userspace could limit atomic_write_unit_max_bytes and the
  other atomic write limits.
- atomic_write_hw_unit_{min,max} are set by the block driver and are the
  min/max length of an atomic write unit which the device may support. They
  both must be a power-of-2. Typically atomic_write_hw_unit_max will hold
  the same value as atomic_write_hw_max.
- atomic_write_unit_{min,max} are derived from
  atomic_write_hw_unit_{min,max}, max_hw_sectors, and block core limits.
  Both min and max values must be a power-of-2.
- atomic_write_hw_boundary is set by the block driver. If non-zero, it
  indicates an LBA space boundary at which an atomic write straddles no
  longer is atomically executed by the disk. The value must be a
  power-of-2. Note that it would be acceptable to enforce a rule that
  atomic_write_hw_boundary_sectors is a multiple of
  atomic_write_hw_unit_max, but the resultant code would be more
  complicated.

All atomic writes limits are by default set 0 to indicate no atomic write
support. Even though it is assumed by Linux that a logical block can always
be atomically written, we ignore this as it is not of particular interest.
Stacked devices are just not supported either for now.

An atomic write must always be submitted to the block driver as part of a
single request. As such, only a single BIO must be submitted to the block
layer for an atomic write. When a single atomic write BIO is submitted, it
cannot be split. As such, atomic_write_unit_{max, min}_bytes are limited
by the maximum guaranteed BIO size which will not be required to be split.
This max size is calculated by request_queue max segments and the number
of bvecs a BIO can fit, BIO_MAX_VECS. Currently we rely on userspace
issuing a write with iovcnt=1 for pwritev2() - as such, we can rely on each
segment containing PAGE_SIZE of data, apart from the first+last, which each
can fit logical block size of data. The first+last will be LBS
length/aligned as we rely on direct IO alignment rules also.

New sysfs files are added to report the following atomic write limits:
- atomic_write_unit_max_bytes - same as atomic_write_unit_max_sectors in
				bytes
- atomic_write_unit_min_bytes - same as atomic_write_unit_min_sectors in
				bytes
- atomic_write_boundary_bytes - same as atomic_write_hw_boundary_sectors in
				bytes
- atomic_write_max_bytes      - same as atomic_write_max_sectors in bytes

Atomic writes may only be merged with other atomic writes and only under
the following conditions:
- total resultant request length <= atomic_write_max_bytes
- the merged write does not straddle a boundary

Helper function bdev_can_atomic_write() is added to indicate whether
atomic writes may be issued to a bdev. If a bdev is a partition, the
partition start must be aligned with both atomic_write_unit_min_sectors
and atomic_write_hw_boundary_sectors.

FSes will rely on the block layer to validate that an atomic write BIO
submitted will be of valid size, so add blk_validate_atomic_write_op_size()
for this purpose. Userspace expects an atomic write which is of invalid
size to be rejected with -EINVAL, so add BLK_STS_INVAL for this. Also use
BLK_STS_INVAL for when a BIO needs to be split, as this should mean an
invalid size BIO.

Flag REQ_ATOMIC is used for indicating an atomic write.

Co-developed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 Documentation/ABI/stable/sysfs-block | 53 +++++++++++++++++
 block/blk-core.c                     | 19 ++++++
 block/blk-merge.c                    | 50 ++++++++++++++--
 block/blk-settings.c                 | 88 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                    | 33 +++++++++++
 block/blk.h                          |  3 +
 include/linux/blk_types.h            |  8 ++-
 include/linux/blkdev.h               | 55 +++++++++++++++++
 8 files changed, 304 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 831f19a32e08..cea8856f798d 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -21,6 +21,59 @@ Description:
 		device is offset from the internal allocation unit's
 		natural alignment.
 
+What:		/sys/block/<disk>/atomic_write_max_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter specifies the maximum atomic write
+		size reported by the device. This parameter is relevant
+		for merging of writes, where a merged atomic write
+		operation must not exceed this number of bytes.
+		This parameter may be greater than the value in
+		atomic_write_unit_max_bytes as
+		atomic_write_unit_max_bytes will be rounded down to a
+		power-of-two and atomic_write_unit_max_bytes may also be
+		limited by some other queue limits, such as max_segments.
+		This parameter - along with atomic_write_unit_min_bytes
+		and atomic_write_unit_max_bytes - will not be larger than
+		max_hw_sectors_kb, but may be larger than max_sectors_kb.
+
+
+What:		/sys/block/<disk>/atomic_write_unit_min_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter specifies the smallest block which can
+		be written atomically with an atomic write operation. All
+		atomic write operations must begin at a
+		atomic_write_unit_min boundary and must be multiples of
+		atomic_write_unit_min. This value must be a power-of-two.
+
+
+What:		/sys/block/<disk>/atomic_write_unit_max_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter defines the largest block which can be
+		written atomically with an atomic write operation. This
+		value must be a multiple of atomic_write_unit_min and must
+		be a power-of-two. This value will not be larger than
+		atomic_write_max_bytes.
+
+
+What:		/sys/block/<disk>/atomic_write_boundary_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] A device may need to internally split an atomic write I/O
+		which straddles a given logical block address boundary. This
+		parameter specifies the size in bytes of the atomic boundary if
+		one is reported by the device. This value must be a
+		power-of-two and at least the size as in
+		atomic_write_unit_max_bytes.
+		Any attempt to merge atomic write I/Os must not result in a
+		merged I/O which crosses this boundary (if any).
+
 
 What:		/sys/block/<disk>/diskseq
 Date:		February 2021
diff --git a/block/blk-core.c b/block/blk-core.c
index 8d9fbd353fc7..6fc1a5a1980d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -174,6 +174,8 @@ static const struct {
 	/* Command duration limit device-side timeout */
 	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
 
+	[BLK_STS_INVAL]		= { -EINVAL,	"invalid" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
@@ -739,6 +741,18 @@ void submit_bio_noacct_nocheck(struct bio *bio)
 		__submit_bio_noacct(bio);
 }
 
+static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
+						 struct bio *bio)
+{
+	if (bio->bi_iter.bi_size > queue_atomic_write_unit_max_bytes(q))
+		return BLK_STS_INVAL;
+
+	if (bio->bi_iter.bi_size % queue_atomic_write_unit_min_bytes(q))
+		return BLK_STS_INVAL;
+
+	return BLK_STS_OK;
+}
+
 /**
  * submit_bio_noacct - re-submit a bio to the block device layer for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -797,6 +811,11 @@ void submit_bio_noacct(struct bio *bio)
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
+		if (bio->bi_opf & REQ_ATOMIC) {
+			status = blk_validate_atomic_write_op_size(q, bio);
+			if (status != BLK_STS_OK)
+				goto end_io;
+		}
 		break;
 	case REQ_OP_FLUSH:
 		/*
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 68969e27c831..cff20bcc0252 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -154,8 +154,16 @@ static struct bio *bio_split_write_zeroes(struct bio *bio,
 	return bio_split(bio, lim->max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
-static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim)
+static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim,
+						bool is_atomic)
 {
+	/*
+	 * chunk_sectors must be a multiple of atomic_write_boundary_sectors if
+	 * both non-zero.
+	 */
+	if (is_atomic && lim->atomic_write_boundary_sectors)
+		return lim->atomic_write_boundary_sectors;
+
 	return lim->chunk_sectors;
 }
 
@@ -172,8 +180,18 @@ static inline unsigned get_max_io_size(struct bio *bio,
 {
 	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
 	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
-	unsigned boundary_sectors = blk_boundary_sectors(lim);
-	unsigned max_sectors = lim->max_sectors, start, end;
+	bool is_atomic = bio->bi_opf & REQ_ATOMIC;
+	unsigned boundary_sectors = blk_boundary_sectors(lim, is_atomic);
+	unsigned max_sectors, start, end;
+
+	/*
+	 * We ignore lim->max_sectors for atomic writes because it may less
+	 * than the actual bio size, which we cannot tolerate.
+	 */
+	if (is_atomic)
+		max_sectors = lim->atomic_write_max_sectors;
+	else
+		max_sectors = lim->max_sectors;
 
 	if (boundary_sectors) {
 		max_sectors = min(max_sectors,
@@ -311,6 +329,11 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 	*segs = nsegs;
 	return NULL;
 split:
+	if (bio->bi_opf & REQ_ATOMIC) {
+		bio->bi_status = BLK_STS_INVAL;
+		bio_endio(bio);
+		return ERR_PTR(-EINVAL);
+	}
 	/*
 	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
 	 * with EAGAIN if splitting is required and return an error pointer.
@@ -596,11 +619,12 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	struct request_queue *q = rq->q;
 	struct queue_limits *lim = &q->limits;
 	unsigned int max_sectors, boundary_sectors;
+	bool is_atomic = rq->cmd_flags & REQ_ATOMIC;
 
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	boundary_sectors = blk_boundary_sectors(lim);
+	boundary_sectors = blk_boundary_sectors(lim, is_atomic);
 	max_sectors = blk_queue_get_max_sectors(rq);
 
 	if (!boundary_sectors ||
@@ -806,6 +830,18 @@ static enum elv_merge blk_try_req_merge(struct request *req,
 	return ELEVATOR_NO_MERGE;
 }
 
+static bool blk_atomic_write_mergeable_rq_bio(struct request *rq,
+					      struct bio *bio)
+{
+	return (rq->cmd_flags & REQ_ATOMIC) == (bio->bi_opf & REQ_ATOMIC);
+}
+
+static bool blk_atomic_write_mergeable_rqs(struct request *rq,
+					   struct request *next)
+{
+	return (rq->cmd_flags & REQ_ATOMIC) == (next->cmd_flags & REQ_ATOMIC);
+}
+
 /*
  * For non-mq, this has to be called with the request spinlock acquired.
  * For mq with scheduling, the appropriate queue wide lock should be held.
@@ -829,6 +865,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
+	if (!blk_atomic_write_mergeable_rqs(req, next))
+		return NULL;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -960,6 +999,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
+	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d0e9096f93ca..45dee600d6c1 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -127,6 +127,92 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 	return 0;
 }
 
+/*
+ * Returns max guaranteed bytes which we can fit in a bio.
+ *
+ * We request that an atomic_write is ITER_UBUF iov_iter (so a single vector),
+ * so we assume that we can fit in at least PAGE_SIZE in a segment, apart from
+ * the first and last segments.
+ */
+static
+unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
+{
+	unsigned int max_segments = min(BIO_MAX_VECS, lim->max_segments);
+	unsigned int length;
+
+	length = min(max_segments, 2) * lim->logical_block_size;
+	if (max_segments > 2)
+		length += (max_segments - 2) * PAGE_SIZE;
+
+	return length;
+}
+
+static void blk_atomic_writes_update_limits(struct queue_limits *lim)
+{
+	unsigned int unit_limit = min(lim->max_hw_sectors << SECTOR_SHIFT,
+					blk_queue_max_guaranteed_bio(lim));
+
+	unit_limit = rounddown_pow_of_two(unit_limit);
+
+	lim->atomic_write_max_sectors =
+		min(lim->atomic_write_hw_max >> SECTOR_SHIFT,
+			lim->max_hw_sectors);
+	lim->atomic_write_unit_min =
+		min(lim->atomic_write_hw_unit_min, unit_limit);
+	lim->atomic_write_unit_max =
+		min(lim->atomic_write_hw_unit_max, unit_limit);
+	lim->atomic_write_boundary_sectors =
+		lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
+}
+
+static void blk_validate_atomic_write_limits(struct queue_limits *lim)
+{
+	unsigned int chunk_sectors = lim->chunk_sectors;
+	unsigned int boundary_sectors;
+
+	if (!lim->atomic_write_hw_max)
+		goto unsupported;
+
+	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
+
+	if (boundary_sectors) {
+		/*
+		 * A feature of boundary support is that it disallows bios to
+		 * be merged which would result in a merged request which
+		 * crosses either a chunk sector or atomic write HW boundary,
+		 * even though chunk sectors may be just set for performance.
+		 * For simplicity, disallow atomic writes for a chunk sector
+		 * which is non-zero and smaller than atomic write HW boundary.
+		 * Furthermore, chunk sectors must be a multiple of atomic
+		 * write HW boundary. Otherwise boundary support becomes
+		 * complicated.
+		 * Devices which do not conform to these rules can be dealt
+		 * with if and when they show up.
+		 */
+		if (WARN_ON_ONCE(do_div(chunk_sectors, boundary_sectors)))
+			goto unsupported;
+
+		/*
+		 * The boundary size just needs to be a multiple of unit_max
+		 * (and not necessarily a power-of-2), so this following check
+		 * could be relaxed in future.
+		 * Furthermore, if needed, unit_max could even be reduced so
+		 * that it is compliant with a !power-of-2 boundary.
+		 */
+		if (!is_power_of_2(boundary_sectors))
+			goto unsupported;
+	}
+
+	blk_atomic_writes_update_limits(lim);
+	return;
+
+unsupported:
+	lim->atomic_write_max_sectors = 0;
+	lim->atomic_write_boundary_sectors = 0;
+	lim->atomic_write_unit_min = 0;
+	lim->atomic_write_unit_max = 0;
+}
+
 /*
  * Check that the limits in lim are valid, initialize defaults for unset
  * values, and cap values based on others where needed.
@@ -264,6 +350,8 @@ static int blk_validate_limits(struct queue_limits *lim)
 	if (!(lim->features & BLK_FEAT_WRITE_CACHE))
 		lim->features &= ~BLK_FEAT_FUA;
 
+	blk_validate_atomic_write_limits(lim);
+
 	err = blk_validate_integrity_limits(lim);
 	if (err)
 		return err;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index da4e96d686f9..1e1f5016b43e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -118,6 +118,30 @@ static ssize_t queue_max_discard_segments_show(struct request_queue *q,
 	return queue_var_show(queue_max_discard_segments(q), page);
 }
 
+static ssize_t queue_atomic_write_max_bytes_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_max_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_boundary_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_boundary_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_unit_min_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_unit_min_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_unit_max_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_unit_max_bytes(q), page);
+}
+
 static ssize_t queue_max_integrity_segments_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->limits.max_integrity_segments, page);
@@ -505,6 +529,11 @@ QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
 QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
 QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 
+QUEUE_RO_ENTRY(queue_atomic_write_max_bytes, "atomic_write_max_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_boundary, "atomic_write_boundary_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_unit_max, "atomic_write_unit_max_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_unit_min, "atomic_write_unit_min_bytes");
+
 QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");
@@ -626,6 +655,10 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_atomic_write_max_bytes_entry.attr,
+	&queue_atomic_write_boundary_entry.attr,
+	&queue_atomic_write_unit_min_entry.attr,
+	&queue_atomic_write_unit_max_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/block/blk.h b/block/blk.h
index 20c5718815e2..d0a986d8ee50 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -194,6 +194,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
+	if (rq->cmd_flags & REQ_ATOMIC)
+		return q->limits.atomic_write_max_sectors;
+
 	return q->limits.max_sectors;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 781c4500491b..632edd71f8c6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -162,6 +162,11 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_DURATION_LIMIT	((__force blk_status_t)17)
 
+/*
+ * Invalid size or alignment.
+ */
+#define BLK_STS_INVAL	((__force blk_status_t)19)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
@@ -370,7 +375,7 @@ enum req_flag_bits {
 	__REQ_SWAP,		/* swap I/O */
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
-
+	__REQ_ATOMIC,		/* for atomic write operations */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -402,6 +407,7 @@ enum req_flag_bits {
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
+#define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4ff5886d3ca4..c0a5a061f8b9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -379,6 +379,16 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	/* atomic write limits */
+	unsigned int		atomic_write_hw_max;
+	unsigned int		atomic_write_max_sectors;
+	unsigned int		atomic_write_hw_boundary;
+	unsigned int		atomic_write_boundary_sectors;
+	unsigned int		atomic_write_hw_unit_min;
+	unsigned int		atomic_write_unit_min;
+	unsigned int		atomic_write_hw_unit_max;
+	unsigned int		atomic_write_unit_max;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -1409,6 +1419,30 @@ static inline int queue_dma_alignment(const struct request_queue *q)
 	return q ? q->limits.dma_alignment : 511;
 }
 
+static inline unsigned int
+queue_atomic_write_unit_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_max;
+}
+
+static inline unsigned int
+queue_atomic_write_unit_min_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_min;
+}
+
+static inline unsigned int
+queue_atomic_write_boundary_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_boundary_sectors << SECTOR_SHIFT;
+}
+
+static inline unsigned int
+queue_atomic_write_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_max_sectors << SECTOR_SHIFT;
+}
+
 static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
 {
 	return queue_dma_alignment(bdev_get_queue(bdev));
@@ -1650,6 +1684,27 @@ struct io_comp_batch {
 	void (*complete)(struct io_comp_batch *);
 };
 
+static inline bool bdev_can_atomic_write(struct block_device *bdev)
+{
+	struct request_queue *bd_queue = bdev->bd_queue;
+	struct queue_limits *limits = &bd_queue->limits;
+
+	if (!limits->atomic_write_unit_min)
+		return false;
+
+	if (bdev_is_partition(bdev)) {
+		sector_t bd_start_sect = bdev->bd_start_sect;
+		unsigned int alignment =
+			max(limits->atomic_write_unit_min,
+			    limits->atomic_write_hw_boundary);
+
+		if (!IS_ALIGNED(bd_start_sect, alignment >> SECTOR_SHIFT))
+			return false;
+	}
+
+	return true;
+}
+
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
 #endif /* _LINUX_BLKDEV_H */
-- 
2.31.1


