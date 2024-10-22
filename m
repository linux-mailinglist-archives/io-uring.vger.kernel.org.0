Return-Path: <io-uring+bounces-3876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 371719A95D6
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 03:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFD4B1F21A90
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 01:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AE613CA95;
	Tue, 22 Oct 2024 01:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lAvZYZex";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TRrONQ1I"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A259C139579;
	Tue, 22 Oct 2024 01:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562365; cv=fail; b=SJXuinftnt+pUpn/TWrRB5YE7pcANlJVUZHUL5J/aor5A2cmUL5TyoJf7yo4WLS32MXMESJkHBs5DVpE5SDd0BqPVlKx9nppYfC/JH0fh+DCcd4+XCNjQGleVxkYxUI4AmNucqZRYaFshttTKhxw7X4jDs0Nk3snHJWgXZqxooo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562365; c=relaxed/simple;
	bh=ap9tFRUkhGSylwXa3uqetziJgvzV5vpHJV7Q/J5S5Ns=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JzHjAPGpvHoiCumvEzNMt9SkHk9RjsjF9SVlgq3KYsg1ikdaGRVxC1tARH3hs/pGcLMlgTJXypkGuBpCKbeJRMCLm2DbQZwDgJWM6iS68tqEJC068HJMfcf4QJO0nXVjjhjZFVWNUTyKoOL+x5t33MRbIT349pdi+hJVw/g1BCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lAvZYZex; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TRrONQ1I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LKfc3r011839;
	Tue, 22 Oct 2024 01:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=JNFrjxnJG9+kjIoOki
	73K6iMTVCwv0zzFS4PT21GLLs=; b=lAvZYZexg5c7+D+gkCikAm94sKJt3scAH5
	gCOvRRVI8uJlJI2GA8bnzj/y4khupV1kCEcth9lvhjn9WCUYVGYxnHqSKfD4U7hD
	gZsVET3AdMbosZILt+jyVO9N5gwEEwahUIy/KlzWuP1nOV3xlKV23g8gRn/9co4Z
	5JjYtWEfZDQHPiKOGXQX7gIB3PESf+KRWmBZiJ0aski+E0HhUV9gVSUEBH1FSGxG
	8B5Wwl5wfi1iCbh8WRiq+jDmEp4wuzHMMN6/F4f6rft2bfubX91O1I3QQDt76bp5
	pu5Nqi18wT5hH52G6ZtBklJVuGyYy9irV5XH7BIV7tfk1h+jlhKg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c5ascfgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 01:59:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49LNjpO2019657;
	Tue, 22 Oct 2024 01:59:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42c37d8630-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 01:59:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tTVYR8DO5S83V+6OeH6HMX8Nc8E1ZJhSBznRfkirHonkspvKweJ8cCcXjixflXw7EahYbnxm+oHvdsSxx72j4rg6bukw1xYhJzP7urfRyQMlOjUQW30TGGzPHcLlAOjW8nS3pS0kUogO6cvlyvMoa+gYpkwzJbTDClZYkBTk4Ma/3CDm/xWkilwasM2I0A2bc8zNd4BF4ibEQ1oAIkda6y5DlQoglnZhRdkWWBbyJMAwhPobKFGpyJxXN1zuUVweeivW2UMn2DJsDpxt0np7IU7hCEtL725II8zQ3zePVzcSdTShWe4V8Z8VcjHuW99cjuJG/g13xbCfqOdroDU0fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNFrjxnJG9+kjIoOki73K6iMTVCwv0zzFS4PT21GLLs=;
 b=Aq18otBou4ZsCjaHKDyU5FZUesJS0z9fFwfxJokHpcf7MoXcsUV6wt5awH3PwVW7KlOZnBBDnr3T2ZPz+U+v+zCstbhxPO1XUFymHh26s7ZLhjbcXpx+P8Vx0E07iM4Is5l+SaWu0w3ByAJxjPw9PXuNE0VrshoA6oEv2N5GUThKivefSw1QSHntrXtCxP0McsxpaR+awYSny9eWDr+19rhSrp4NQy/dAbI64qn7o8JzHu9ryfmJohjpXO8+Fi9fhn35NzSklnW2iW3TSqaAcmPdb73vfGOqmVSEP7Oj9XMrFbfH7CW9wcnKDN9XamocA8L/FJ9tsMq/r1MvLReAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNFrjxnJG9+kjIoOki73K6iMTVCwv0zzFS4PT21GLLs=;
 b=TRrONQ1I78+2CY1cdr279njlNnzDWpNddB7pHGtx3otklvZssQ95PV6VTyYHWVKxSNhgvYfLXYaO2dWHgbObYxhsRKdev5t+EEH+mac5+MEF4yqCAv4trcV1bNw82uFSVzQQL1WCEcVgSf4C2TSKdA6RTWyySl/Kt79ARB9na+c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN6PR10MB8166.namprd10.prod.outlook.com (2603:10b6:208:4fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 01:58:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 01:58:59 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241016112912.63542-12-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Wed, 16 Oct 2024 16:59:12 +0530")
Organization: Oracle Corporation
Message-ID: <yq1sesolxa6.fsf@ca-mkp.ca.oracle.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com>
	<20241016112912.63542-12-anuj20.g@samsung.com>
Date: Mon, 21 Oct 2024 21:58:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0401.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN6PR10MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5e5e9b-6860-4f62-63dd-08dcf23d1826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JrQN8Lp63r/rLYNyRevb6jlMiPwne8+iOIuYhQ62yl6I85uFbo8Pf29HO7xB?=
 =?us-ascii?Q?tPqGEKfDtbmAd/RjgL5ZeD1iVwzbHVgJ6tmVtCipwhNfAa45lruIv+Z82N+l?=
 =?us-ascii?Q?l5jqdarxCq1kufFhTp1XLyUekoe5JNeAollSTNa5aJSTt0EKk4ga93aAo5UB?=
 =?us-ascii?Q?3B9knP2A5Z+D3t4EsUrIjR4cVz/gWcgeCeE+kuwPXI/R+uQYy9ylgpLE0ePP?=
 =?us-ascii?Q?YM7PF0rEWukWiAiBxdhWFel8u87VdyPUWjb4cKoX/XHzQeOaXILBIXLFvQqP?=
 =?us-ascii?Q?YjXIOej2fwKAyZMp8u16RjZs4Yrcy/SQLl1vocIgsD3kgbVEXDKG9S/fluyv?=
 =?us-ascii?Q?jwbk6l7yVJE/j+c1f+HuDM7kULy6fzF+gr6QQnG5K3nEMr2BR33pGPjcPYYb?=
 =?us-ascii?Q?LBV9NKDWRIhCUvEDf5ptakcjzI+BicfGOxpk+d/aB3PB1FudqNJbUnNPF7VO?=
 =?us-ascii?Q?7DaFzzU5co0CiJvSAfCjMpttq2LSPJXV1U2ggdn8wRxJsRgzBG0Xvc0cEkpQ?=
 =?us-ascii?Q?UHWYceZhxl5txPs7w0x4MGwvFrtZbEMfI46dQHbQG5BGXvdfzeKqpwYPf0eH?=
 =?us-ascii?Q?AxAqtSZvo7A1483CGKguinyG4hckRtjiAcC4HQw/pPPDeeAmzxcqOqYmQR9L?=
 =?us-ascii?Q?lJhi9UO+9gQT+EyFuD7fcgESfnDvm+lq2rOI3fp6tzxuA4rWY4Kee5wSlAdP?=
 =?us-ascii?Q?pGt+YPTFCZBNGJcSV2q2M62HVsX4kaBHcRRG1+jfHYDVtc6zLI8oS9MjwZN0?=
 =?us-ascii?Q?Q0GOOaG157qmspfR7M4yLfNpLNAqNNb4eZ6ZJ9uYihtQ3q+5N6iER5kOKusP?=
 =?us-ascii?Q?D1j/xIYnSObxLUXadRFuKVPcfNIO7EM/cAEc1PiaYjrimN2PLhs7NuH5MotM?=
 =?us-ascii?Q?Sgpe0Ns1RNDjv0gb7Bky/0nsobyVREZbsm1RwgGVvgsHXQitfMCgn+RseWO6?=
 =?us-ascii?Q?varCVGe0Mi3jLuDx6ix6QfZ8QJur2H3sSPVagK7bfx7KFWsZ0vO+GLKxDTyf?=
 =?us-ascii?Q?p2Ni2lFBYXFMLjdNbxlMMYrDaKJZR5qsMUiDPrG3OkKQJpN2i5sJFjiDkVJV?=
 =?us-ascii?Q?j9ux0UrHoipY8TVyub5hl4+FvQEPgTFKlUxObYDdH5xjmcQD9gej+wx7U+Bf?=
 =?us-ascii?Q?K9upmLtK6ZKQUFsWDiH3dZM8K8GQXH0dTEFidoh9nB9KnMs3mnIaNx4Qoa7X?=
 =?us-ascii?Q?wBkEFWYAxFS+L5dojpsYBGH/MDyxxwzl0gv5sCkfywxJhD1Zp6jSbRE12DW3?=
 =?us-ascii?Q?Whv3g0Nalx4VUIoKGQstMsOSS5BGNZ6l4mmzk5fJYF87siJ4H3XaaaTedIOX?=
 =?us-ascii?Q?SkVMZCzSXwJpQUyW8S6eZCAE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tgd+6ZaC0aWa66xrLI9yXxO2r4j2HezOZWMD56p2a/8QtNGmSx1IgPinpgSW?=
 =?us-ascii?Q?Fv4pVv+R/79Tc18fpgzAGKniDl/cnHizxe4o9EzSe+0btvlQCyVgiPhTBKmk?=
 =?us-ascii?Q?fOVz4CAQqm9dID/L/KokJ2pRO1BebI0FEsnGWk8YxbJxcaAHR7BmMCXok8Va?=
 =?us-ascii?Q?7+m6UYaG+9EBo1d+V5uqoCBAQqC6Doh40T27c5Tlba4w76BcNg79gI3QPaw7?=
 =?us-ascii?Q?YJotPNUxKbssHBhfwrcbuiKVkPSOnlcMP4dsz7w6XGrKOeZGO5D9LHSWk6wz?=
 =?us-ascii?Q?UWP7xXggRCR0pNSnjCvbiEw2yYym/u1GM8FioFM+oYGW0/N36ujZacC2kBGI?=
 =?us-ascii?Q?WXA3e+wQlZToHNcvklCQKgpiN3h1qHPNwEvEKZRL4AxFhiivmeGRL91d6SfI?=
 =?us-ascii?Q?rUv5f6NFEUKIqG3N9YwF3I2JzaWq7tDnSZFr2C/T2S3Sbl9n1wxZWgL5rEdb?=
 =?us-ascii?Q?ivi/3x/JuLSxFBG9nWauVExN0XBYPngU6j9SsgQsVLqlsTOycDIrDQ8FARYC?=
 =?us-ascii?Q?rF2Sd9ARMi5Oy2HzGgQzEaW/jzh4qCUjQ2P5Z42aG1yo1r8noT3r9qOJ32w6?=
 =?us-ascii?Q?HwAwDze6QaCAEEvwLL2HlnQOCZxtUVg5Q99zWeROEjAHtrQhu4qBoCBxoNIb?=
 =?us-ascii?Q?w2cRsojooTekDBWivST2Lr1feiDy++F21t7Lg8yM1ALjD6YmrkoLdVTyzYVL?=
 =?us-ascii?Q?tJkLVMVyx+OVaEa8Kf0NLLGj1Ga3AgYFAQ9Ew10/bUxq+h//KYLZa9MqYUIc?=
 =?us-ascii?Q?TrPZssFY6xnO4Wbzntk40cHeqlwL9LiSO19jX2dkGEBbZbCuDGKIgM4ZDqhb?=
 =?us-ascii?Q?2cr08iukbeLQzDBL4hcASgS2VkNJWutYMCntUON1EHQG3WA4dRcbKhIMaIqa?=
 =?us-ascii?Q?jvReUgpplWPtxFALuVnlr3PAmaZpbWC0/WATBbLlxw+94fwHiPCu21aplx9/?=
 =?us-ascii?Q?UnXwWr1dECiyKj9Mgo2tCptnKZ4QZw+7xsSb9SEROLQuZ2iWyv9yc1TaSGdF?=
 =?us-ascii?Q?5VPHKCuJTpxk41l3TYux23HG66EZn1BdQXktJXSYywVQfFdfY88XZZFGGrIR?=
 =?us-ascii?Q?HNNnR6bsTfiG+MFeWAo1Z+guZnsq7JIQBvZ67O7yckGpQXJR8/kaV0Kcw15H?=
 =?us-ascii?Q?IG6jyMzULyyiUEUrpSkzU4gM0dc/0gevvkEAgRLYSMRXpdHjZKmB3A4dYxx8?=
 =?us-ascii?Q?O/TjJ4ykLFxIg6/RM/kLZuTzVR9mjLMYNOBog5SqOirKxd8baJe8lYb9lQIn?=
 =?us-ascii?Q?0Ti86WLvQPEcmhahJHg/1FiLt/7U1lw9S72LqEZMhu+FAkStXbmhjpPR8c5N?=
 =?us-ascii?Q?3jMa6NRvCPxUjlSqwnOnvRKGej53+rJ/ayX1GjNKXiGGFu9Qc19dpHTS3PRa?=
 =?us-ascii?Q?/CcJqFc3kKhurE+vGySqkVddanac9oPNgXKdb6cyx6nDul01tuXipOhMsx/8?=
 =?us-ascii?Q?7Mxwqftym4Vf5KCWwpd35oGEEC+/PJB+ejCsEzLdC97mcTvc4M093vGzfbOm?=
 =?us-ascii?Q?IlSDCbMAIF2CQh2qHn74Vfvz6zHh3mxYCOt6lLCLYjguIN46veCiq0Hg5Tjg?=
 =?us-ascii?Q?jHji9iIS4so4a/LBLsijVk7IsYcN1MTK9zF1m0LadMFqGzP79gEnI6idC3dv?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EYcCi/zrLzAUATKZMRdfXj/ciCYe5XsasTfEJTGji3O36IXOMu8vIvwRkWzCTwdy1WaBPltqoVhBieDA6ozU7G0OeKSg2iq07oRbDUyeVmJL6TpnYY34DrxHkndtcg6YjXkmk+zNKdXPPWFjF5gbdC7VoZ5EmxB5XGrlICykXvJ8pR5RrDI7dX1FfbScsaYnxVIDOU5UPWoIOIKUVpZG68FejGXD6sHDrApGVIwyjdAr7i+3bbQN1RKKoeEtBuSE5cswamPXnNZnUhOU+c4AGf8y+CRj3gLG4B/hjEqmuPKVGGOFKCF4/SQixYKySXzNLPNv8zYThm3nNUd8cdJ5NLVB/26JgS8b9z7XR3X7fcBtOTccgNK68nhLKiKq0zgTKEhrYsGdWeBSCh7gD5yQxiNCAgOxCJHTb3/mZv26kL/cjGs73XPmgAr3FnQughWEzby6MGsrx0iRNSy0cqK06NXzyh/ND82Iuu0WnqJ/wCidtwzfMEgK2sAF4y1fFaGzxhrQkiO8S35LdqRSB5RV7Nh7qrXWTHswDYWr/G8r+MSLpF3HBY0n3hS68rpOo2emmgUtXahe2SwyAaW3AWPQCfHYa76SyUC3QR9nhIMY9J0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5e5e9b-6860-4f62-63dd-08dcf23d1826
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 01:58:59.3644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zA39eAi6730QORo2GrResPJ21Qir8EUlwP7MNaZolWHVyRGO8v8jPOVt1uH+v1fLmjMLQay1FJVmHZNf81XTHBKpNOnPdKvhamGHDEf0JlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-21_25,2024-10-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=714 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410220012
X-Proofpoint-GUID: hwNiR-OdyN_uxIcr186lEOLNZhc57SKp
X-Proofpoint-ORIG-GUID: hwNiR-OdyN_uxIcr186lEOLNZhc57SKp


Anuj,

> +/*
> + * Can't check reftag alone or apptag alone
> + */
> +static bool sd_prot_flags_valid(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = scsi_cmd_to_rq(scmd);
> +	struct bio *bio = rq->bio;
> +
> +	if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> +	    !bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> +		return false;
> +	if (!bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> +	    bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> +		return false;
> +	return true;
> +}

This breaks reading the partition table.

The BIP_CHECK_* flags should really only control DIX in the SCSI case.
Filling out *PROTECT is left as an exercise for the SCSI disk driver.
It's the only way we can sanely deal with this. Especially given ATO,
GRD_CHK, REF_CHK, and APP_CHK. It just gets too complicated.

You should just drop sd_prot_flags_valid() and things work fine. And
then with BIP_CHECK_* introduced we can drop BIP_CTRL_NOCHECK.

-- 
Martin K. Petersen	Oracle Linux Engineering

