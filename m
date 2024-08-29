Return-Path: <io-uring+bounces-2969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 487289638A3
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 05:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73B4DB21E83
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 03:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F87A49626;
	Thu, 29 Aug 2024 03:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NWO0vtKt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T1RO9GQe"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1049624;
	Thu, 29 Aug 2024 03:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724900818; cv=fail; b=Zfg518ncQrSoDT2FbqSIznecmfdmoTboeJ3YenbLBW8juH0/hfxoke98ynRTXyV2EdKXJLGhEvBCYn5GijV+5TuW1SpuMGABlKSQzBklsPiD7nAaTxkUaOe6yv8WwWV2zOtsx6S5tUfiXmYqFkSBhlXuQ7P/ZdFi1yamKvHZLps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724900818; c=relaxed/simple;
	bh=HBGOWDzNxxmkvPx1YoyEpeBKLqglthzhwJTTuNEYRjE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oxcpW1I1/NgDV5XQXKkLKiyWA0R1pt1TPP2EWNoADNZ8uR+UR5VOs5MNl+Xqt9j7AEw2VKf9VsI9V1ONe/W34aFmB/anKNBFhPqOSAUS/uWMKXSWf35HOPkErwKRaQr97qcJgo2ZQQiAMQPLG35ox4hiQZEJFfULbg8XTWml9CY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NWO0vtKt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T1RO9GQe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fZAp028737;
	Thu, 29 Aug 2024 03:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=7cbBz9ZceA856D
	ZsLhfkfpa1Jcw8p6+OqTzbThkhHNY=; b=NWO0vtKtfviQqTtZxhFWD7YuN1Ggfv
	/9xpTJBnHQLNmDmjyViGZfV3MC36EedWknX2Bakjhv01AIIs6YRwsn0nEcZRk7WI
	9vd311yGkmsgPLRZs8grAoczXdnu6oE+gVhGUlVm38Oop5GerY3B+LePxXUr9vd0
	DFeDdisf1nT8uA2OBuc0h0ekkxxaZ1T2SwKA8+r12ZtFskw4KMxBa9a7w3alnUck
	xyPP1epjfPxHbRnOnKjK05ZI6F7tv1ksLx5sOXqGDKZPRu7J3pPIw/e198qh28wp
	dWghiJvO3fmNw3O9WyjTrqhy0W6aCZtf7dV+hg3vIeePkdTxdoIpoh7g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pwv35gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:06:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T2wMb4034714;
	Thu, 29 Aug 2024 03:06:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4189svbwce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:06:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E1STqX5gLP/OrxJlQryDhRuovqPacS/ir5FhQXP1Aly950Zy3tN4Jrw09mFyzyRIXh7iCV3H6Fl+kXdAQ9K10Xv7vMM7xkqAqsFhB6SCGom/R4JXGDC/Hr5VPX2H0Q8A55fxm6KO3rYeMNqLhLAa0HHNCFiM1RdlLelM59OQara7HHtie2U5+ur/nZSsszSuJijdOpek6NhRkzDi+fR1acLmWgjduQa3XgdfYG+GnsRKKnqvJ/bZ9faXk6xDn790LrToNS+pPi5GNbd9kerv3VXnycxjMhdlzX8jhOYoIePIS1KCt8+vppltYYNLs4HOGdQE7+o5sEiuNdo/P1CrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cbBz9ZceA856DZsLhfkfpa1Jcw8p6+OqTzbThkhHNY=;
 b=yRBtH2tnxEVHZ/V7fmKVopOv4u6bdULUunVDMP4DXQsnHvdRabQca2tadpgsNMkzL4WrB9S+hgKo7O04y5Wu6zfJzFq3rbyCG9eK6FkAW2/AAWfbaQflW3l2RxBToBil9ezX/1uXBBp8Bn67tAyYna/evG9M9N7BVBVHQtnW9JzxyatN69ZTbnY/WnYQk24dvj4l1HD0ewW0J1ktlMAsk/LnopmlwUXIdw5XPL0/ci4bDOVW71iFMVQgLqo7dKKiv0xWhw3BXimZrhRcWdwh0UiKvSvN/IuMYI3LVqBMGMQiO/pQV/Xsg/tooFQ0jGKxp+gNI27v43g+478HsO6oPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cbBz9ZceA856DZsLhfkfpa1Jcw8p6+OqTzbThkhHNY=;
 b=T1RO9GQeuH7E2egAw3iFzGp5gBG6qwo8xJsiFMsGhlvsnzqjWtDRukqYGppYPqmZ5wxVAJSR+OmbX4j+BsWt+L7oPdS+9R8w3o66SmWQB27J62I1Ze8XlZOlc4KAFlORbGnirXUT5fk5n1PnMyo7ql9984VE566Y59cMQtlaP10=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5824.namprd10.prod.outlook.com (2603:10b6:806:236::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.11; Thu, 29 Aug
 2024 03:06:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 03:06:06 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 02/10] block: introduce a helper to determine
 metadata bytes from data iter
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240823103811.2421-3-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Fri, 23 Aug 2024 16:08:02 +0530")
Organization: Oracle Corporation
Message-ID: <yq1v7zkauzv.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104618epcas5p4b9983678886dceed75edd9cbec9341b2@epcas5p4.samsung.com>
	<20240823103811.2421-3-anuj20.g@samsung.com>
Date: Wed, 28 Aug 2024 23:06:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: acaf6cfd-d25d-4e5d-7fc8-08dcc7d78602
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KuBou15HqQJzbiXJqSZ7iUQMCVDmQYw7PSkv7OWJurur9psngovgK2ZRZUEY?=
 =?us-ascii?Q?Y6mtzySRFLEA5lmwhst+eF7dAyuu2MQqcbqPkiJnB4K0I9YP6yfTQp+Ah2xE?=
 =?us-ascii?Q?gPTPgvX5q1Y/GrtYsAgcfSZzpb/oX42uqnUUKZsje4MoP0rb39FpWcfJo3Pa?=
 =?us-ascii?Q?clHnfbcIZ6KANFqUvD+msYlAaPeZlKCX6ALeRXc6QDzbJ8NkrgqCQ+XBoVaH?=
 =?us-ascii?Q?NydEQeI9UtRDqrDcbzIUY7AkAc4zeVhYwKwgU+Re6LKpITg4vsEzoITu+tu7?=
 =?us-ascii?Q?sbfLJMccW8pwxewO8Z92+GdlDoc/tuXU5MGRvnAE4xfpXNI3mklHw0+WwNa7?=
 =?us-ascii?Q?gYjZQUJfXGPJ6x3/MRAWsKmFxtvDo1F+skqFZVJaAbIexEFYR0zSh1jxsI39?=
 =?us-ascii?Q?QLf2N1wS9u3DwhKyMfH0IENmsVZzcjTiwsH1tPpU1vWybNDOwEa0/Smba7TJ?=
 =?us-ascii?Q?gOgB91p2kMIon2oRulMPG9vrr7iG03agwRKqHZM4FsS8nQmPXOkeQk8MVHK+?=
 =?us-ascii?Q?TX98+zVN/P7cm2/4FSUCtjqOFXj7KWgHhdIY8LcPiIvrcaAYwaa7qOIKv8pl?=
 =?us-ascii?Q?r7fczN991oHQxFWACLw9SlNhluUGa/1sr6fZSMnoqJ3MIRH2SgkKTr/Cm5RE?=
 =?us-ascii?Q?WORVqJloC8fEnV02eDs7Tj/9HFFqDnXk2cnydMOilctmlquVj4ET2CVeDNSl?=
 =?us-ascii?Q?vK12Kg6KbUFlI2OTN+XwYwScCCHdBTBe3/m+f/aGvL72Ff6EIcuDy6QEqDEL?=
 =?us-ascii?Q?MuPLnoF53ylD6pVzGD/TUBDHid15mp8Mv1RwOgXsZBJYwAFqvBwF9QyZVkYM?=
 =?us-ascii?Q?C2iNwC30Lff4TpIHnH9xPlAkpDxwXmlX+FIXX5ElMm5PcQTCLzEebx1UMl7V?=
 =?us-ascii?Q?0jQS1coBuxm+J/azw8ixHElaRvItDt/I268r9rrr2RzoWFO2b6mdlT2+NQ0j?=
 =?us-ascii?Q?dwz86Q+5L6JhU1XCO+5SmCAFsuOuyh//4piCNGbGcnBBVQWPvdi8Hp2PHy2F?=
 =?us-ascii?Q?ICGE9YoS+kG72jF2reKHbUGMZ8Dhnm/FK5I4vZCF7nZMzmLY6G5xvCftSsn9?=
 =?us-ascii?Q?pR6XC9BArONupAUcuW4Y4hoz8yhQVFnzXBrf7rcKuc2GBWENILJEws8uY3F0?=
 =?us-ascii?Q?mhkW/Px+Gb6yX5tVBAFcNPrP798f02e+zrAd7xV5y3sWCeHidersPvviC93x?=
 =?us-ascii?Q?XZjcoSU5sc1mBHMK0F41qYzcUORNjxm6jB/dNxEKXonQQaCGG0019+qu2uU8?=
 =?us-ascii?Q?Mi4Nyk7xP4mJZ1V9PEgcBJ2FEDxyDbB7PtLJ8DG+heT08qvE4rnSIICH+qNF?=
 =?us-ascii?Q?M4bcTW2FulZtTwNgMOWO2G1bQg4wRzSIEGmTt7zkIfXmyw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WV5hUVV4v65hBtQCnCpRjGiTRIhd6m0d6Cm1cSISdm/mZvnAI4Dl9v6NFgiY?=
 =?us-ascii?Q?XweOdncAyowgchYt+0kPcJYRvo1gzCG1szMurez4nTuecgslRqRVcJyN2/U/?=
 =?us-ascii?Q?MO6bqH+MBT2GQx/zve++gC9UGqdsgZITTiLqFLdcjogC64APRfVCJj5+lscL?=
 =?us-ascii?Q?ghcTpCfgeRMkcIScJaKBbZfLEtqVPBh5BL+VRNQc3ogXH+P6QVNX6rNalQzD?=
 =?us-ascii?Q?KpRqqcxowt5KG0FzfVI3lHvYrUWQbe5cUaCR72RNEPVkV13nBIr8BMIiYizy?=
 =?us-ascii?Q?AeFrOtF154mDlnT2EnezELkDyeQ856i7V6ENGGxrtHLfGz+iesKVBEHx2isN?=
 =?us-ascii?Q?r1lSdZfmruxGhF8d/+vvWOM0nVHMiEkh+C5ABFtitOn0eQ35iZCJnceMdaW/?=
 =?us-ascii?Q?tbud6xr9VM7LB6tLMIESmd2Dzvxh/HlBRfglgwLG1XsKOjncFM3PvUPoHbyp?=
 =?us-ascii?Q?WE952kng+FUMXIM37cxVAThdGN4JP8h6s0zWGcx32IPI5EF0mnXWg3q/SxZf?=
 =?us-ascii?Q?77KGhlNGX6n0H5uJH+62l0dAObJ8rWEEU2Mpg51Yn7UXcOCh2uZ/gu7s4zqv?=
 =?us-ascii?Q?Aai+tSu+pybanlqoZGtwg698JPLi6oXbLHYFBe4s9pzwuG30VBVaUUeTLnVk?=
 =?us-ascii?Q?gqu+Spm2TJ/vJBa4NQSFelZ3aEENJtKrcgqAQxQmtbz+yPpi1jY+gytJt1SZ?=
 =?us-ascii?Q?aZ9xJFxs6sHPvDpEBpqlFZQaXTdBmbk2mkkMauHa7WmflI4bXwqcArBRO81S?=
 =?us-ascii?Q?LbzRWXghFsBHt1Velg4JcW49fljZ4ciq5F02Rh0cbOLbfKWv0ey+s36jeren?=
 =?us-ascii?Q?Z2xY9kYBjAV2oS4YSRjo3jGIw8JYuLiNq5dMPFhiPdJV/gF35Z69PRaqYQgZ?=
 =?us-ascii?Q?iROvCmGoUer/C8OnHOaEM8OiM6YhFazlz3bJDjvmLOhGdqVWoze3AiDeKMxg?=
 =?us-ascii?Q?Bmx8UZh/B5mgBlPeIRSzAg+pkOkE5gwkNXJT5lWx1rVBC+Pa8bsW+e8OK88S?=
 =?us-ascii?Q?VgioOzM19Xcr0pQr9r4NXsDToySKQ4vs2fJnf/DnPaOSgCo+n49dXn+2CSAC?=
 =?us-ascii?Q?1dZPiJhGWyAt505XKTW0wesgSl6J4ka6L7e0BO+bsUp659fxXG7KMwhlReyG?=
 =?us-ascii?Q?ELzl8nHU5cu5BnAcIwTqZP8OW1fxRpkod3fubka8eNl1xnMPyizSVNIeOzdU?=
 =?us-ascii?Q?yHkrgqtVSjcSxF8AbNBrf/hNuHfaSKY00TGt8cSAjZ1fWgkEJKR3oryDhU1n?=
 =?us-ascii?Q?7ck9YesqjdwVrxxp9ZTNmZFCbkSucgFpVJYScdehkwLwZF05m72YdnVpsf51?=
 =?us-ascii?Q?qLWe0E0vurn+tvyfohcryjGwFSawc2wNlQrO3eP8uLYUAwDs9+wyZvjaA/rR?=
 =?us-ascii?Q?JS5pO9Uw3VhBUOdnHfgm8I7P1mAUeS+pYexz85lcej1/evVlEGd9fGuIlOQp?=
 =?us-ascii?Q?VRXiUQHO4hO4gnthYS/FNHhuNk1tSWOFnqQEIZfyohSNuOEccIzSDFfFysdw?=
 =?us-ascii?Q?b5AuZ++0ajt0rYFGkI1YQM+JCnwQNiDOrljuogeHnxV2JGxee9zKftUihDoL?=
 =?us-ascii?Q?n5EzS3rQu2TLA+m1JgKY3+EiYHadwRl5ITrtsNdJn3tBncz3TX/f8qHJ0WHk?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0c1tDQKSrcJbifdqASkLZrciV3wrPOyQmvyjrVq5ndzIA2GM+10j/umfKbtFWP6+X6tXRnXBPeqL7WiuB4odrGzh01/XOmalXQa2bY2JiXGlVrG+JLtT78VWICgGStyw7FFzIL2xZpft7vpENPnvn7ejpQfP115SZfQpGRWfHOR3ZAmWM9vmnOPULacAdVIonpEgiZhVBbB03//RVPjKaePEQXcQeyu8WhFCeQ3Jq6PtU0j+i7CSmmAayo+A/RmxvmBLCMZtLnVUdyDdENJVw6Wbi6A1NjhHqL8GsAOzoSAvY+JmkdZqRBTPKcT7Cd66ZG48w6sK+JHlG/PV/5OTgZv7La+mTgrHqgYaUXOlW1aR1uvylkcjpvFWTKIQxMtLpC7riVLj3yfwgzvPlwPfRg50HDm01wSt8JbD8v7YhRDiKVrsc4hm9G5JUWN2fP20NE0irX+ziVgQFXoUkA347gINJqazR+bDYKmCTCx+G1VEkZ0cPsuGmFj8xYBlULbhxSOTJ5EtPrLbhAxA1DfZSGGsOZykHk6qwZw8cZzX+5EFQue3KwewjG6EgBiEhouL4vR4k66N4BxUiMJhgvvvgqoeKgREC9hCIciQt9p6FWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acaf6cfd-d25d-4e5d-7fc8-08dcc7d78602
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 03:06:06.0871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhDS/7wbvl7uHpomXpHyVq/fr/DvNhekMFvo70jn9WgJy6KYpJTpkA/YU/TaRmO9gxEFcWbCpj3OooGhntKhbdLfKfoSDA7Lm7KljngUb7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290022
X-Proofpoint-GUID: 8SPmiT9FZbHOe0go11A_X6htYTA6VOk4
X-Proofpoint-ORIG-GUID: 8SPmiT9FZbHOe0go11A_X6htYTA6VOk4


Anuj,

> Introduce a new helper bio_iter_integrity_bytes to determine the number
> of metadata bytes corresponding to data iter.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

