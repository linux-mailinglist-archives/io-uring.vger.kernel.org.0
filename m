Return-Path: <io-uring+bounces-3883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB439A9606
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84D692835D3
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFBD85C47;
	Tue, 22 Oct 2024 02:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fVno49Tl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pEdefXu1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9EB12D75C;
	Tue, 22 Oct 2024 02:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729563120; cv=fail; b=dxDzvm9qFpPUBSwUZM23r1B0EUs25TMBelW/6kKS0GeOnlMVWVT7Gy8FT8t3gCGMLJaPXtA/3mvCVqZNneAbwlcWNcZ2yX2qRJJ+yqrJom7BlJ72EK9WkN8depfslJvQnQP8dtX7ZcIsI+Lp3urFeCyvSBluZ0UWRMiWp0mqgLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729563120; c=relaxed/simple;
	bh=sJIArEWKHEPnhqTvhzK/jc+QUgfyGL1LuxkTAUyA9e4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u1pbbaMOiKbpuUy5wcU35eD+4sGGML/lg/crMYP3ybJ3Ptu9YYERIGj75gAaC/4MlsVeG+/y0tR3Bm/nVhdUYK+i3toC2lKuuX/8GwXw1CWCHM9WuI+8H4DkDTsx2WSYMIpizMqC+Ko6M+3wRB8GzUHdeXra3d6BoNpuysNkUEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fVno49Tl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pEdefXu1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LKfcDS022994;
	Tue, 22 Oct 2024 02:11:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=HsA608S5ZBBfKJLp5N
	i4hb+lPcNA9NZjD++vZV54jvw=; b=fVno49Tlxv1ixEPsAdT2pz0ju08sMos8eQ
	MKclNn9AALnQLuUOuEqGIRIN2RvE4xo3EYTSsV7H7PifgTbSfLqYUOshuQtj+PRD
	90d28YmglNBZfVf6oL3AJE1rsUPBWc5dNhNAzS3+m00XlGFW3TFsg0WHhWNRs5dZ
	npamX25hGnN+KTK56urKln5D6K28PbkKx/5ACcmP/V50RzwUDqo1Gpm1iV3wWRft
	j1Y9gMV+0BS0u+fFTukYS9k2um/LtEtH9QKvDQhz89+G8iW6ZFnWJlGGACtPyf0B
	KiH+xzQv3dMXR6qP/cCfOiHVI1ZJP+Mhhg0wjliNprvIqnGgqSzA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55uvfpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 02:11:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49M289hX012333;
	Tue, 22 Oct 2024 02:11:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42c376urdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 02:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwaTDRx3l2cCQibX7sYebBy+B+bJ9MnyEJoLUk88GEhWilEPXjtzUhnkB2GqZchF5W3ZfT+R1Yo3qZXnLkdMTk5OMthMVs8/IslX14SuXlSOdOnv7yc/YDcUPK3w6uDH9JwoWg0Uwko10SwWrHeF9JfEjXa1QjZwYklNjrBM8Tn711/WP5xmS93GAWNGkyXU+1L3xr+c+HdAPPIqrJw2dnCqE5u6xa6KLgoSPKKsWydLD5AAz9wfz7VfKftG+4NQibTnKeaVud2EKgu0mA9I5+rPgQmXqZdVoGOfCj33RfVnAg4grFYsKvM00Ib6+6Yr01nQNRPfKVOctzzjWdOOSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsA608S5ZBBfKJLp5Ni4hb+lPcNA9NZjD++vZV54jvw=;
 b=VPOR6FUaexcp2XvVsk9lAaPm6D4Caj6QDjLcUkmPQDVzZVSycjZRKCpPRebRIBVl3ntD4+4D6das/CSBRTc3xuuz35lazgyceSEH/o3x/Mf/fry4EAXjVVircSsd4oHBa5KMUGO61dZfcn2VFU0lHDMXhIRTGGCeHx5EpUuUOjNtA88FHms6i4NEsLqAT8Ld+t+W2SKZKueadI573jHODgjTJBhhiqC0/EZhd+Mulh9LcHdaK1RqHAPYfXnAtoNjfJB2kJKhweL9PPhOMfZtgL+W4SBRH+dWjiODnrNe7yxlHGqc7AQXBZ05ZcRpaA5QaRTX35hR677r2SEzT3PdRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsA608S5ZBBfKJLp5Ni4hb+lPcNA9NZjD++vZV54jvw=;
 b=pEdefXu1KrSL+XoeCaA1T87fRaqcRuBjiTdFY+1yzAOMDrC1uu6F34enJpB/PcZGRLlAuBPwf40kgKaNyH1rp7ht1bh18Vj1i2tyjNHXiTs8GLn+NyIcxMZAhC+Hc1CngEWrwf2UIcnBTu8Jha29WV4DcCyXw9YNszvFbDGv0Ks=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA3PR10MB8066.namprd10.prod.outlook.com (2603:10b6:208:50b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 02:11:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 02:11:37 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, vishak.g@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241016112912.63542-5-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Wed, 16 Oct 2024 16:59:05 +0530")
Organization: Oracle Corporation
Message-ID: <yq1h694lwnm.fsf@ca-mkp.ca.oracle.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com>
	<20241016112912.63542-5-anuj20.g@samsung.com>
Date: Mon, 21 Oct 2024 22:11:35 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:52c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA3PR10MB8066:EE_
X-MS-Office365-Filtering-Correlation-Id: df1654bc-ec0b-42eb-99e1-08dcf23edbf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FIFc426aWk6bQHk3RW6W4/fqEzFAOuW0YHwjX04ItWcb3yYuGu6fgZtJdwUL?=
 =?us-ascii?Q?Y3zUYd7MVP/hMW9vsFGZgd6FEurhD+KnloqhE6M6Nf4JsZzqMKbRCmuFImoU?=
 =?us-ascii?Q?VSrgtleH17KncN46OibYo2AspxGTgtyahZeXIu3Bt2EbuaefQK7Cf6G0v77+?=
 =?us-ascii?Q?TJNV84/Lq9QkQFqr0Gzjw1B8bv+mxP5ID9nH76Et+Z7gpw91/V74Oy4ibo1T?=
 =?us-ascii?Q?fePo7JO6I3rMUOgee1F9a0rrEN9T72C31woAuh+f31yMd92tEOK6Utkr807V?=
 =?us-ascii?Q?pfy91MAytAyVo/0xB1FN0eX8Tl+x7h/5gUYiBZGLU2r6763fhuxcs10POX0O?=
 =?us-ascii?Q?sb8XSy4pR0D+cBSHlvGPghFBx9hzboYVTehGo3u+FPMGBiAQK0vPG5iV/gNp?=
 =?us-ascii?Q?QjEqRE8GhARWVeof5ZVAAYAOd+BUXv7VyoOKt0w1yxXo2D2atgGfeTrjDo7f?=
 =?us-ascii?Q?SRRYIjPgel6pAlwVZA9OsQ2yXn/HeV1m66irGMiq+jH4c1+Dl0hFDo/ruWqw?=
 =?us-ascii?Q?bKfGpY1dxtqOaCeTZbF7j6O0y+wZ2cbNhUQ46SqJFfifRDA0F/kNXP3pXNko?=
 =?us-ascii?Q?orowyWegG5yzdzl2YjymLy/qN4NoxVRQSBmA70JUlC6AbNJSccqdTof6LXyC?=
 =?us-ascii?Q?rIggrco34Qe+LkZbKufUxk9ifrDUSGUnLqCshflDw0/vtD2vYLxWmHCxnBrJ?=
 =?us-ascii?Q?1tUWenQnwNv5HkOIar2al3OLc2If0dSgv07AyIZd2E+H93vjUOfB4xHzN0AR?=
 =?us-ascii?Q?/5WgyA5BYB90RWLk+ktwuLNxmsPJQLvR+JbY49f23Nie5AzcFZmVfE8YnpGd?=
 =?us-ascii?Q?vtCqfOZyO6BnRdV/5Cgj7+A+pj0briEn9x7ZG6Ik8TyOTVtktlKJfH3G3Kuc?=
 =?us-ascii?Q?bYpW8AcEnjfR70X+WIbvHUx+SsiuKBR9MiJDjKAjELCC0mRNm8TeC0Py69aM?=
 =?us-ascii?Q?d2yJxQiAHjuliKl31MgB/ZBBlK2h8nWymXxkst1lkB5JBe4HeNWpahbkkwE9?=
 =?us-ascii?Q?8ogUzUALIHIENv5Hq/NRRYiuYtQnemi3t1lT39ru/6ReGDok7kD1goJ5F1G+?=
 =?us-ascii?Q?mTOr3hNIhCVpesEkG50e9nyR7RnPDX1xSW/iMvoSfs8hB2qB0rqBlSltdn/7?=
 =?us-ascii?Q?q87Bh+JOUNtYPXAlj5mSOvhLadHq0dfVd+Qhz20jbUAz+TxhWAcvsJW09lMd?=
 =?us-ascii?Q?2RJnOWHxsUQy+3I9ioOKF4x8wIILHOqm1mRdFUoKv7H7z3SEX0uEcb8ptdaA?=
 =?us-ascii?Q?jgKT8l4RcMqzn6xfrRf8rXyiA96ruXfJnwGyTQOY9Zil+8rD8kcCTtXEZkqV?=
 =?us-ascii?Q?vaUPRav0KqdGE267qttIikIR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5oEQ/q8PtSNkzUMRz036T6OUZ/33JNBU2IQZXx+ZZ7oZuBQ+yU9rNjn7H24R?=
 =?us-ascii?Q?5urWoZLWMIjT1ZZC6s8W2zsuCdDrWGLJ9TTRs4Xf2Rm/HTnpu4j/7atCbu+5?=
 =?us-ascii?Q?jsQ5bezpGRAORunnQ6a7QwAEowMGnYTgQdNx3w0NPq+xVy0/sWS4J85f+yRU?=
 =?us-ascii?Q?L2Pg83tXCgITtLQKbddiAERF8nykN43FsKm86MM7TjH3VK4m8N+pSPs4FKjo?=
 =?us-ascii?Q?ib/D7hARF7O2h+Xmywrao2HPi6H1J8YdKcZ5GN8pOHa27fbVf/rSHDW73zfj?=
 =?us-ascii?Q?YXZMT67mGpNlnryBTZwcYzdh5n2cUryQw2aeBy70ecVQz4cY4E9CbTPLxkFB?=
 =?us-ascii?Q?n+f9ZP8y7Pkt+ZUysQZ56L1V07DJOHfWYWn1IRvgFshPgdKo93G+/RcP9yrX?=
 =?us-ascii?Q?G+4B4MY35eLtF4d58pTF4h1Vbm6tuRcfZZK3fOxBfcwoSQQJWzea+x4J3ITG?=
 =?us-ascii?Q?f+/TnJ4QN6rkw+1sk2R/ISJO0T4B3Ode22As9jVDKVThqCb+q0PRorhkVkiW?=
 =?us-ascii?Q?4TMPVpPuQH7s0+xhv2vE81JGnNViKKHHTMyOgXUpB6ypFNCnU0TgaV3Y865a?=
 =?us-ascii?Q?daKBx8PLoPBhGxmiujkpqRGon8n+pmg4krGuu4T2e7+0ZrB/ZZFZaF52963I?=
 =?us-ascii?Q?RjRKr/S7M+Dcto5hBTfLY39d86EcV8ZgrXPrBCoHfXtdl7QgHt2BSk7H8lg/?=
 =?us-ascii?Q?XBx/8yt+zT4wlMyAwFlHUERwMeLPF4pssS65oG68S1olD/AMsdJyo+itw26r?=
 =?us-ascii?Q?xEfQFWiJxQiPaUuMqT/PmNF7iibES6S+fghW26gXp6pisdvRrkSSjBsdEGGA?=
 =?us-ascii?Q?IuMfJ8w74Y0qC6N6wpqefDfnTINtflZdD8y/KIuHbL+62Gxq0FUVcNIjCkS6?=
 =?us-ascii?Q?2rsGdtRH2slpLCL6XV6G4Rft+gnygqp+Pje3MYaYtxPBgUSTOcFf3ncr42An?=
 =?us-ascii?Q?m0otAzjFVDq+YZGBkB6ScGg0UdVOupDGTABrTZ2Dud3AFBorTHat3xASqNct?=
 =?us-ascii?Q?FgdI2jM8jvXjIPou1xKxEnlmJ3+0vxyk3AINVdGZoHVFnQCunQwQuoi+ayu9?=
 =?us-ascii?Q?ZJxsN09NAbFwUgdLEC6ehbxx5vMWoOz29oFyueEd2SWfjvvwfYA5URZg7h2P?=
 =?us-ascii?Q?xpVBwHXjStgt8R/cBGB+AtskrXczlXBVhwl9gcOkVhOVTVXv/LpOFF5Kcl0y?=
 =?us-ascii?Q?UBlvnGv7CR7DQvR++nX+NxYuCKL/SYBZc0QBrY2Fm/dPceN3ZiAt6wAPJfVH?=
 =?us-ascii?Q?mR+K1t4eebL1/0s7vUAe6b022VxZs+3AoR7T6qZ2vUDDpF0CrCHDWBkEmlmf?=
 =?us-ascii?Q?sAJJsgVCS1hfhjmu6MIj/bYf7ocIp+2bNhbSXBKr5VOWs7AWrEijIpZlw6oW?=
 =?us-ascii?Q?jkLM1SIPqhIo/CpIBEtk6AlZiTvOxX0j3ZPrBsBPJcA+phd5dZHysKjO4RSi?=
 =?us-ascii?Q?VustRkakoO1Zkp9WH79wgkLCzOdAdAVT3Kk5Kcd7aVB3SNkgQ7M7NCRzJ4Mu?=
 =?us-ascii?Q?vAWNlBj8j8WXU2KXjkdp36CcbqiNHX2pnFyNN/raersLSO23VYGxRrEVdA6/?=
 =?us-ascii?Q?h0mQn/E1+zCc0yHwDmSpNwX8CCP/aOhTFILH0Vs/Pd37rgoCKJgE9OuLKs/g?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	odWhETVirf9yqpsK+fGrJMvEKF65QOnPIR+LYa5QUaEiOhKeuaqB2eDRF07UC4JpwbAvGxJbu4v32RuJWFFJ/PaTMws/2umQYTOBLjHqehkojlOafkgBRXV4fZ+RU4TkRZNrJNl28+VjlqXUg8+LRsxJWO+G1rVnmnWHxrJidZQ3QXELB+5oYYsEbsqMsH6KWV/QJNNdUeSwr4TWRiLMGMy2O2MwOOU8a1MDEsJ8Q2NlguaLdWZewrxrJa6vPwJz5wmVWXAmT5zgCvmuHZfmcc5X3NF0wQkBwoo70JnsJGASjNIJzosW6vONwHRl9C/DCNkK/zhK2vyCCINqTzeAfj/KEiV/iR9UkyLuzL9vLKslwZzKjnt0GdSJHMWfZ7J8q6teGxoBe5XzMt2NJiUrhjmuRqrlK4wjgNYISnpj6x9ZNaH57MUpf3UtBJOsKE2+B0XvgZreXK2gOFwN7R2ItMVKaFAsMHUmBhqAnbTahYDCdkMxwjzA2DSqGlFo6fRQWv5tNApqkAjz4JaSkqbuXmHY7UY5xNExtf8nFbK+KIS49LDJxrJi6JxXnf8s/xx9o144h/DGBNs3Vfkm5FLzYURZRanSY6FggmbppfefaWA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1654bc-ec0b-42eb-99e1-08dcf23edbf3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 02:11:37.2999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xPQj4QeJ6HizJBL18McYWvppexl84y9G7CchuShaLeHOfwpHvTJtCnKrOXB8s6xzNvZxFMKHarc5I/I3QUK7BsJm9qVCU1xk/TeFKxXQRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-21_25,2024-10-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=744
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410220013
X-Proofpoint-GUID: D3GNYMaYTAmuS0fizaJNRzV9lBSXlWkM
X-Proofpoint-ORIG-GUID: D3GNYMaYTAmuS0fizaJNRzV9lBSXlWkM


Anuj,

> +struct uio_meta {
> +	meta_flags_t	flags;
> +	u16		app_tag;
> +	u32		seed;
> +	struct iov_iter iter;
> +};

Glad to see the seed added. In NVMe it can be a 64-bit value so we
should bump the size of that field in the user API.

Not sure what to do about the storage tag. For Linux that would probably
be owned by the filesystem (as opposed to the application). But I guess
one could envision a userland application acting as a storage target and
in that case the tag would need to be passed to the kernel.

-- 
Martin K. Petersen	Oracle Linux Engineering

