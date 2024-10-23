Return-Path: <io-uring+bounces-3930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 987039ABAF0
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 03:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51D86284B9F
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 01:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69E92F34;
	Wed, 23 Oct 2024 01:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="miN6tT3u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uee479NL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D0120323;
	Wed, 23 Oct 2024 01:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729646476; cv=fail; b=H1oH765X0DcezZ5b0bjpfZksVOZjPFOHVyT4CLpOUOVZRizrlZtgRvCIS0vijl+v5EwQKi/i2x6+4kCJhhcbW+7HbFaNNs9L9jwY7nAZIIKX9/SGDtoa8+lsuPuPYdxAVwlp3RpQGwRwk/rndkEfBzSaqn22ok+QqlSg+G/CvHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729646476; c=relaxed/simple;
	bh=I85j95G/VMLCX+N+zkK9/3DGlZlu/k8qGwUJRlKzjw8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dLIhT2mw7c3BWNP6B40Mlx1ikpiV2Agfd4SU83u480XmmLMbDjTsxCPLgCaP1aiuysbjSc26SDN8w+qFvNBQ7OUeuCghrYxngYA81waoC50fESfAKHu6xKkfM4KuZH/MyM+CLhXzPwhVKzj5UJJVX3M/42ZT4+Y6ul/vRfUfDw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=miN6tT3u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uee479NL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MLQeTk007925;
	Wed, 23 Oct 2024 01:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=2tadeby2Z91q/SFpFQ
	OE/QydW0Yhq3z6gFjf1wYu/i8=; b=miN6tT3uasyyd7Eahqxgf990G7q5zAhEds
	GEVWWhAsxs1GAVUAWLKiMAA2qIijn+0lcnxT6SR7hwlQuzFD6VPrHV0U8CgDRdBl
	vQHQBYKQcaIgkhH5oJPE8NWJTsQMEDUk7q6v5eVb1iPJNBNk2KLbb27ardWqx/xq
	5ROXmS0QqjLxv/ff9WRiOuuX/f6iY0n2ZCH3lQs5/aOm5zxiAYlmJ1t7w8qeJ9kv
	PvC8WqxLmrmTL96kJMSSL06/ivU8tUeJMZnzk8A308CKb7ezdAnxQjTJMrtyhrrT
	WVmapoysSVw9YYVrV06xo7TKfq6MSHON0BINt2jrsqEkJLUeFrag==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c53upyw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 01:20:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49N1EEew039423;
	Wed, 23 Oct 2024 01:20:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emhackft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 01:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIcbw6X5liYUDnRzVJrmt1LPC9leS/pbHOiPR/PHGoNzVpcBF4LFfReax8OmN5cc50CWb5BhEEX+wH0bmfWqfA9RQEsO+MbGtebJzJJ5I1jXwaU41rDgscCIR6iy18+Edyr/9C9Aai89zKc5sZIyzCsoqu0sLABLUZurLpE9xt1ShOKZLg9gJCxjNUg9j83VcIUpMhX5m1E8fmwNLdsf0Hcz2RlGn1NHUfCIn7D/j6o6i4aWyqwxZ00zJiX6N3HV1CMn2yNg9IDhnE2gQTMp96WKe2abGhp2B87gtRzaTN/rhyEH8TfITEPKDFz+AmaOB314Hm8TVmwFZP836Em4mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tadeby2Z91q/SFpFQOE/QydW0Yhq3z6gFjf1wYu/i8=;
 b=C3GYEpsWmGyNZiCucy+070Fbe1+zkTTMALrtgIJ1dq7lyQ53zNZpIP5CbYXCwEOvJIdeoIxgOVT1/N2q9+jlysP0WoAk35h/slMi398MTvSRwQ/SiMQ0wtZYOHXu8h1bGcyt/Tqf/5tMHwyYGDiNYtPrxccTF2ofprpQFoS2M48z9C27Zv82gF1Bh1WejJETXNwniB9ExUXZJ8fWoje2Rgc841jMlJ5X0JsOep5TW6c+IcqBGfBxSVX4fneaQhU5jwDs+4iNQpuAUfXOpxG9SlhOBiMJXvUla1lbfFWPI+AHwq0aR3Ja2VfdmT17VE0fsaEi5UJNrIyQDwkdq+YNew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tadeby2Z91q/SFpFQOE/QydW0Yhq3z6gFjf1wYu/i8=;
 b=uee479NLGKW/BbSzk6VTMVR58ISmn1W3acEwyjgIu0cqmZxGaVzL4k+3c/4uJ/FxEDpJR6pAAdQKyU+auClKFWdgWW8UJjQanfK4YTZa6SOuKqDpZOJ8bcj9KcW+VZZ1pbCpbrvIU216qm7OZfXrOSo0yxlb8duHFo8sVZYGN2w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6780.namprd10.prod.outlook.com (2603:10b6:930:9b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Wed, 23 Oct
 2024 01:20:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8069.027; Wed, 23 Oct 2024
 01:20:45 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
        asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, vishak.g@samsung.com,
        Kanchan Joshi
 <joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241022060451.GB10327@lst.de> (Christoph Hellwig's message of
	"Tue, 22 Oct 2024 08:04:51 +0200")
Organization: Oracle Corporation
Message-ID: <yq1r087iqc7.fsf@ca-mkp.ca.oracle.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com>
	<20241016112912.63542-5-anuj20.g@samsung.com>
	<yq1h694lwnm.fsf@ca-mkp.ca.oracle.com> <20241022060451.GB10327@lst.de>
Date: Tue, 22 Oct 2024 21:20:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: 833e68b6-4b32-47a4-420a-08dcf300eb58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gk+y0XtHcn+aS1n0YEM1471cDOXEgUKDkoVk85/AVODRbSp2TSSXE6YflwSL?=
 =?us-ascii?Q?BV30/KjKjLjNWKGzAiXSRy56KBgEX78XnfMoF6Mk5eMK2DOOfxKO7nIqc/5L?=
 =?us-ascii?Q?P3+7TdUKxnsMGPdiSwoT7EfnpaLxSuug+mnPyEHqcZvmALC/3bAD3/nSj6WS?=
 =?us-ascii?Q?J9MJGUDfqoyuaG9otEStsqMr0bZUOfVbm2KIAAYhxCCqunzGR7ht4p5GqUhQ?=
 =?us-ascii?Q?oHXkfWwF1vfjD3JIENOfkdVlv87oHaMXTBlPyWYhjG6ecEQ+SEp2JAAIqIDh?=
 =?us-ascii?Q?MfcnBZ/ZK8fusJzay0fCzOhx73jOTPKUVo03V0B2vzGsTXZUAXtPqNK0wN/j?=
 =?us-ascii?Q?u79RBUrkrMmrKsbnY6IZsPWkxvn3h1G9FTmvx6jBivC6t5iCO0R8aZRfqM8Q?=
 =?us-ascii?Q?lvLVzEq6V4Tqq30nR1dPdLKOdvPC9eKbdibLONDW4DaPBXK1a7QO+CkS1t59?=
 =?us-ascii?Q?DnY+TmZNOk3LX0297VG9E5vV80vQhIaEF1BpoMaJkvhhA1+uvm+Vvdd4QiWo?=
 =?us-ascii?Q?DKw8QjErZjE7A7gpe1tmjNTLUfZk8W+CKcWwkgudTAwxFT7rF/aIGC9Bn/Em?=
 =?us-ascii?Q?RM7vn2AmSffUHX9NrjyUzQPZUSungYUA1iow1OAkAK/JGFo/R93a5Hu4PLUp?=
 =?us-ascii?Q?spuxAzSi29FEERkLjVx31ME5n/aEvLbFXUa9DfsZJidJS/wF8GPbMiFTkMxu?=
 =?us-ascii?Q?25TaV6GWIgsa/po3vEpzpVNp7yRULmbPWFWWw4bkYKU1OZ/GvoCeXS/dF8fX?=
 =?us-ascii?Q?hYY+zKTADP/ZwlKwQweBDVadvloqu5cTzm/6fHesydiAGteK9DkP4sh2csrG?=
 =?us-ascii?Q?PE7wy+audvoUpQOd0vzHyFBkcystC8KI8DNlFb2e+G24s03yUAgyeXR0n2Ra?=
 =?us-ascii?Q?74D8lwG8h1mg/i3ARFlJ66V2dt1YF6jbEqe3PxuvGVLw6hlE5oAppiVKg9uF?=
 =?us-ascii?Q?ZSeI0M09MhG37SOAONuELbZrMcybOiCiQYovJ2bdmZb2F6ECFBwHABX9sHrv?=
 =?us-ascii?Q?mRVV6inmTM3bSwTN7M0VhlA4RxOtppDeeYf+FRcDcj50yOsbK4s1fs0pwO2e?=
 =?us-ascii?Q?/GZgGCgsCXg+lNAa0KkaQ9HlGWiJwssSw9FNugKtR5UZYiiXuaV7XMh+6Xw5?=
 =?us-ascii?Q?OXkJsUEUjGBtdjiG6f5bZsHHLTNgMBZfHzj5UU1l6VnJNlbK7/xleycgZ0Ao?=
 =?us-ascii?Q?Li56+mbjNuHT1syvgJRJpIQSZQSO+/0yTm+GyherXnTDJw6koJxqBJ0lqpxt?=
 =?us-ascii?Q?TDsLHBdLVU97Jf2on7ls5VsgGajdiJXE9uDkB5F2v8iJGLYaIi6jWP5uDN0i?=
 =?us-ascii?Q?UkjDdPpIK9fyBVJ5Tn6PFjMC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ClI4lkqRVCk2XuX/NEBKRV+n/46KcO2bJNp6RdDOxrVKGZCXnxpGASRawQt?=
 =?us-ascii?Q?JuCfucOIs+fyrWf+bbDt9Vaw2/f46ZZgX3EEyntQOqoGiGL6+VwIbLCTvTOA?=
 =?us-ascii?Q?/VqQaSENcXWHgW49OeZg2zCzO331HELZ+Xaylkvh3TxlA0ze+hapcpcPr1Ih?=
 =?us-ascii?Q?/UoR5Ds3A9u2pAkiHII/8ZimyknrWWTHXqVARrpO/B8yjNY0Sn9+DlC7lHWp?=
 =?us-ascii?Q?1fweT1BkyUHchOLrN8Xwa8Psvcbf7lCCEhAUPYTZ0tKGRV/U8283ZRt9zk2e?=
 =?us-ascii?Q?PZsivNtnWqgCQ72Ij9hgN7QVqbpb/LLAmR0DkC8V1DLfGyO1BuY6KQY5jnkG?=
 =?us-ascii?Q?vcAU1EwcRJ+ZPXckqQyi5gviNoxC6A1CnGHKKbA9yusZsv85iXZiO6JyK+Rq?=
 =?us-ascii?Q?y/OMYpgVd10vV5Quz4irBAq3ry+rTFV0QlKMw+6u6UZ0De502oD3dZEfyRSZ?=
 =?us-ascii?Q?gMVqJAa2b7Wj39Y6A6X6FcQvpW2bW9gEiTDy2JejMesjHqoGgBKl3lQBQQrV?=
 =?us-ascii?Q?fDxRqKaMWs8rsFaXeLdNPbmGiQzN6s1kPFQ2TuLLeOwpwwTtQO7XKApQvQuw?=
 =?us-ascii?Q?fJRP1D4zKE1H3T0huyzVLF8h5+a/uXvBeU/XTzJ3a4XhimIE1J4iiqdv3JU7?=
 =?us-ascii?Q?RW5tJGzaUrnnFICk5gYCuL8HXKjOdaVTHHvggIF+9IoqK624QkT+BLWvbY5h?=
 =?us-ascii?Q?zwHe5wC7TwdLYI3dB6VmnlVbTLrRhPTJMX99+t/MXAmsuo3ktYhSysDA3EXx?=
 =?us-ascii?Q?8y6OTvrJsRIOH9f4eBuc5dckhmICXK30ipV9YcsapaOslk1o69+Us1Xnci+e?=
 =?us-ascii?Q?nD/LYQmN8VnskQ/uPw4TtA9U6NX+p3BaeyaXRvHju+lED+AZsUo4CkVOPapA?=
 =?us-ascii?Q?HdgFX41jfV4b3JR1RJDxdp7KQpv5hd1JEV+S3/NSfjSEjS0oLDbZvWLblsPB?=
 =?us-ascii?Q?oKB89U8kxImDLmVbcz2QsNGUfpcsyJ4A1W2oBtZhwx6NfSdNNJaNONhLktlD?=
 =?us-ascii?Q?6060+eWi3teC44Ii07jTAvc/BQl/G1J1Ta8Jue+0kb6fyb8I/vqEh0795PQb?=
 =?us-ascii?Q?+ii56gfWriSlTXxJ+4x/KwCCWAw9Oq+jh75t/WydxhDYSNvSCA2936iuHdu3?=
 =?us-ascii?Q?sxLbMKFZDqPoB3xEdGbx/Fu7fuJI4SIGfN5gEnwlPEkkO5jNUh1QSmwyueZo?=
 =?us-ascii?Q?LGU3W3PrzUFpJ9sFNz6BlqoKc1+9LSPrrYrh+RESyOtfyZo630BSD9sQMYWG?=
 =?us-ascii?Q?Lae71e0ZVr1iTpeL2B2DJixh24Ih9nIbJUQJbVjeS+BwhuHxc6+tiErkMDSb?=
 =?us-ascii?Q?STK1+Yg0b6KNI43SPfOS5H1bp3a9yjfjfJx+wwVPVM0I1C7e1J6o3YHndkMt?=
 =?us-ascii?Q?AZiD49gXv1thbQRdQ9hOrIfP9m+VKlKk0G3BgpO7/NZOCHjtt7o4qvUMXC7C?=
 =?us-ascii?Q?UVU+bO84aY/ay+5WtZP+wlPojnrfQlnac0GRkqnvrNkoBpPb8xtvMN1aqTGl?=
 =?us-ascii?Q?e8DnuvWXIvJsDc/7Z+JA0kt5CccQu9uBfHgBC0qI6tPKvn7xTwmSYNK4B+n6?=
 =?us-ascii?Q?7dMVkvMcFfuclcun5EekSZlHyNCeb1We4EkatyiPpufEuOTCEv1/D6IWcrD3?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M5zN9Sgm//ncMykURPmZBzsgtrBqCG28olXRoVaLYixN7DBzfHJYVzJ7pHrayFkxBLZgc+OX6YF/El6zHk492T4iNUFcpzg0+qfHzqbLvRCgn7nMV/IDemp74dr1BjD8Hsw9nTVG3Zj7Osk00DA4KdF62/kI3ZS7OKK7CWhPJfpbJ8TrfAEji2ynXj+R1pOK8gqodg/y53WML/gfeeutZaAtdBRBzUV3OvF0V28IZRJCyLD0MRIwwgh1O6iI25tgM5DjM9UvZAEucBDOlYOC5Sz6kZs1uvDn1aOQZ1Ib76plOqWHuXucJ2xoxier4GK/83lyKurgcZXN1+DvpHifPPxwylCXuHPmZZREYkeNAqR466WRcC79gFxvo2hKr7IEz5bKjw6ESh9PJGzjF9ne3s5D07WefoHeF4Z57QhakO9ITl/m5NA2/zv2stWqE4V5WSj6UkRW3Wd+pWAFCaHxlpECpupfoJqwlWfvIW6ecBmLU1teywuPkGPS0Z9bQz0/Fn0MTfV5CGE4zR4aToFjAUpNyPQ4kqQVxH/Fr9K+jAZ/945KDO6sSieaDVolXy2R9mAaPZaA3Mc7L5k+UpiSCfpubfx1JXVFfdZVsDZou7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833e68b6-4b32-47a4-420a-08dcf300eb58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 01:20:45.4772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVV1zOyieoRBgKQ4oygfxBguBqA9edIT3pQvcOWS1UtWcBCQUb85KgtAEVIdqS4k57jDC3nOzkzmnG70k1IYsgBiqNWnZju66xZQlQv21cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-22_25,2024-10-22_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=796
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410230006
X-Proofpoint-GUID: T9c8XdDqKsmCpVK_Fb02wQ2HuAMtrO4O
X-Proofpoint-ORIG-GUID: T9c8XdDqKsmCpVK_Fb02wQ2HuAMtrO4O


Christoph,

>> Not sure what to do about the storage tag. For Linux that would
>> probably be owned by the filesystem (as opposed to the application).
>> But I guess one could envision a userland application acting as a
>> storage target and in that case the tag would need to be passed to
>> the kernel.
>
> Right now the series only supports PI on the block device.  In that
> case the userspace application can clearly make use of it.  If we
> want to support PI on file systems (which I'd really like to do for
> XFS) both ownership models might make sense depending on the file
> system, although I think just giving it to the application is going
> to be the only thing we'll see for a while.  Maybe we need a way
> to query if the application can use the app tag? 

tag_size currently indicates the size of the app tag available to the
application. I.e. if ATO=1, tag_size is 2. And if ATO=0, tag_size is 0.

To properly support the NVMe extensions I guess we'll have to have
fields indicating the actual size of the reference and storage tags.

-- 
Martin K. Petersen	Oracle Linux Engineering

