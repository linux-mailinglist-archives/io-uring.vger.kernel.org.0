Return-Path: <io-uring+bounces-5654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 440B3A00094
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 22:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9618D18841C2
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 21:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E4E1BBBCA;
	Thu,  2 Jan 2025 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kwBTpn0A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0DrhakIL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E911BB6BC
	for <io-uring@vger.kernel.org>; Thu,  2 Jan 2025 21:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735853000; cv=fail; b=MQvEpq/HVJaii2z0JNvmPMzHj6L/A+gfK1vizW57RFG2tP273kwljL/1SP8lvIkmh1Zi8DrZlvfoRqj4kfG1/fun8XKxZCUQsqnZ4dJgK6Fr+BEz/rMYn3iMR/ylDqrcegaLTN5f3iPpcn+10pHENqtkVu2hfYFSO2X0SJJOgmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735853000; c=relaxed/simple;
	bh=3w3kjrKEN8fJVgjvUPXKV4eOZXYz+H1O977VIG8N/7A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WFhNNDzwl1nnVGBTiGIKa1178TKso9vkPOf1LuLLSosjynniJ/vTI3uVeZsja3g3uPtOKZJDEbBRtmFKqG13WMnbHtUhhTJ4ObP8CUOi9Ghw5VuAyskjSANGYbeotdH2t540HcjWwnM4hD6P8E483EhvgATTmWGfCQIk5Z9qIms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kwBTpn0A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0DrhakIL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KfreH016425;
	Thu, 2 Jan 2025 21:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=yOoc1Rm2VbXdKUatSJ
	d0ZVIkigoxqqQgJqoqnoViCkQ=; b=kwBTpn0AD9u5J134w23U9r7GlIegnhD13m
	PCocwa9kLQTBrydtcjoUzFQ99FH0IXmCzho+m+nLBfVdtq6Y3/45aIHiIaiJTKHE
	bjm7XMkiAtAAx4LCZnSZyf6tQ4EiyC1yAVbDJAMzw0EUJ+7aRfwSsOesPH8g+aH8
	AnjfqWf3DzDfEO93ps0Lp3hMbDT2Ndifi3qGObsmxjRFx6KBtpwj5XgtEoo7ujB0
	kZgClRpmCtOSQvE6JyDf18cZhOtAtRbxCFTjOElry17w/lK8czTl2eZNk1HrW+pb
	JWiQUj+4oq730FT2a7rAF00+lbPyz+KWkKmIWtzmrROQQZOJEOzQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t7rby8nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:23:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502JkIN8012901;
	Thu, 2 Jan 2025 21:23:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s920s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:23:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QSDBEaSih1MjkczWAEY2juYj2WLUzIz7bbdn7heaVjLs1Q5FksuWgHYfxnAqdTtdr1c5GwuyOLpkH8bfxxQlHZZ9mA98X5HAlLTGOCucr8yh+9VzPOM0p39keoP/OKiorla3+67qrdy1ZwKeDviXSE8GtrLU2YRirEQA6Yf+aOv1QbVzJdIIeBMryvbotuT4VmBhChAWOq+FSJJDPkGYHrEjFARbvkrDgS/i3NG1Z1A/PSttOKTYZ9Fki+03BdpR4pY95t8DCLO1ZCb3FJjqG1MToeu1fsmk63DkZvMkd0y4wjcsPy6z3n8Q7KRO2oOPu+akOTP59pqQzFPvyoT6hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOoc1Rm2VbXdKUatSJd0ZVIkigoxqqQgJqoqnoViCkQ=;
 b=VY1NIQEUCuCc1vUwRYHIuZlgFt6PqegI/r2p/qH3kPdvXTDc785VeP6ac27SuKcxyVKpJwrjeUTBnT4r/bda8gcYYDaes+EVR+g+c9l5+LhmDgUAa7xAkcbRfVi5tzBsVtTVu69AQ7/XSWPPPpwN7eDq3zySFMCHlv5Q/Phaur5BmXFJecA9eaSsgXQ5K00sAMd5phFUu94XiP5b2HAFyLOmB8DklVzhMlLuvO66Oi4PpbKPH+ytwCc9fpfAY+3i9F2oI3McWEVvrDty8JC8A2WuBU5NyvXXqSjB8BfZMnzO7BoE83C/YQA6VpeRv/twIBUY7KfZOAWmG/dqxzuUZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOoc1Rm2VbXdKUatSJd0ZVIkigoxqqQgJqoqnoViCkQ=;
 b=0DrhakILBAUcr6FPveY1NCb+KmeBZUvR5hfql3M9LbN+YELlQU7W1jlqyllnvb1sD7eoer3NbgnImxb4T0ktpKvjHpHcoFIktptqcGhtRAXmZd5Zto2/sX2ml6vT0nTjUWmpxjr+vVFJk1EgInoYuMP49qx9OOPoDqgSlDHdUXs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7462.namprd10.prod.outlook.com (2603:10b6:610:188::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Thu, 2 Jan
 2025 21:23:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 21:23:06 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, anuj1072538@gmail.com,
        io-uring@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH] io_uring: expose read/write attribute capability
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241205062109.1788-1-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Thu, 5 Dec 2024 11:51:09 +0530")
Organization: Oracle
Message-ID: <yq17c7cewsl.fsf@ca-mkp.ca.oracle.com>
References: <CGME20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316@epcas5p2.samsung.com>
	<20241205062109.1788-1-anuj20.g@samsung.com>
Date: Thu, 02 Jan 2025 16:22:57 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: 95476970-1b11-4802-68b9-08dd2b73a608
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+HJNMJv3xwtCaOisXJwypyQA4hC5wgar7JdtboR2Mu73RLDK7tbXbiCyr2ub?=
 =?us-ascii?Q?75RSa5UModuGNT8JabfvDBk9GWU3o+p7iIksOMQgOZhf/V1DYMjOX7e2sncb?=
 =?us-ascii?Q?Bmouqq0RkhYpk2u+BzX/ZXmvQ0As8WyW/3rr2g2aAT5dr/kp24mAoExgxpwn?=
 =?us-ascii?Q?J9KN/uxygKBpXSyvUmBJELVMSkqak3wOtu8MadpT0do/YHdJL1ymtoItOk4G?=
 =?us-ascii?Q?4qouv0zsw85+J+GzUq0TwtUjn78+eXocElFGu7nRNMZNdwBvVlDDwr/uDoVV?=
 =?us-ascii?Q?BeUqlyOgr3AdaOlDj+Bs3JyFH9hwRGbRrXPU2v7d2VcO/ENi17TYya1qZSmY?=
 =?us-ascii?Q?oKwWgwz2avHTVeDNxdD8c2jtxlx9uer0UhJPqoNEfU7DHl2ucjTn8k2jZ+kg?=
 =?us-ascii?Q?VzJxAcQzeo3fSoNIvnE++TT/aaUmsRjaj3grQY78AcFZvFMOPC9iR1Bu4SX/?=
 =?us-ascii?Q?WDbq7j8ErFcAKww+PzsZD7UBFCr0aMSFo4oosipCqE8gWBbDjQxc1u9zXYsE?=
 =?us-ascii?Q?4JslRpjGLKipYR42G7xVe3rMAL+ZPnYUQX3odxbLUM55VrSavjSKvVmOmfih?=
 =?us-ascii?Q?QK4AXhm3E4M5rzUwGmAw0Wh0pygEF1XNfctyQepb67AJJPuznFIuNrmh5mAI?=
 =?us-ascii?Q?eplOBG95N2SMiVGZC3B6S0bVRscvoQp9KKwQGhTuSZYh3sYo60AXIqqUwzf7?=
 =?us-ascii?Q?4EbBABd01pNyOQSTprRYpbFCrW9ORsbIhfD1vmphxiajD+yGqOoF7UgCxGmY?=
 =?us-ascii?Q?lyUzqyCyUAdOamvqfi6vdl2khw/rBxyF79uFzHi39OM4ziXBc/oidRL1moOr?=
 =?us-ascii?Q?Zua9liKQwhWBTaJJzgwSQOlVjztqJR4a/1pP4xaqX+xkqzzwMBpXxqMmeW0o?=
 =?us-ascii?Q?rzGhIOkoeB8upLaM7lT+R8ljXEKpxO7jZf5Q58dqNOPXnjYTrouFNlnN/Ikh?=
 =?us-ascii?Q?YizCDNWL/LW4fh4jyiXDncufbO9YF9pAGJeN/RtBNwgfi3f8Wn7vU9hFNFfV?=
 =?us-ascii?Q?+/hreZpGz6U8TqOw6GQ+bvRlKWhkYOV4fdc+LtG+91yEEyUFoIQ5qbRrDCLw?=
 =?us-ascii?Q?/4V1LdqAO5Vd/lyfyza1rlbN8y0rVyya23kV/lPtbMhCfO4wAi2YI51BUqNU?=
 =?us-ascii?Q?J0MKQL1/nyn2RRcPABlz/xdK0m620vi5uG73HH+0b0/A5uWq5EJsR1y2B94m?=
 =?us-ascii?Q?jdrNVzIeWAoP4ru3z6FJOCJfEKh/cy1Q11ceTJVuyuBC/ZkcaFs9wFmpgK0c?=
 =?us-ascii?Q?od5cS8TQgsIp0Aa2PrbBHWDyit/wkaAp+AeOVsroP4JvdZJ08ow4000nIwEp?=
 =?us-ascii?Q?QY7URNs3fePOVCZa0nbPJEYdv9rRr5repb/EQteW3Ztso3AkTaG/rxygQoqt?=
 =?us-ascii?Q?KOPjhydfpdfvskfGe6vh8el60egC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ucwa+1iiOzzO5dYxwGP5hRMK+RNuRNNhK6PgktxsbKlkeL56UtI4jgqi0pur?=
 =?us-ascii?Q?ROW1LGAp6G1dJgRlCZObx8jWUEB+UW1Kek13gizFsyRucjLTyMn5yKSTItlz?=
 =?us-ascii?Q?MG3/J9aozl+u0o2ApaTSQpMZ8nRPG+0RiXMZad13ChYXAeTdMyyBqtfk4cxN?=
 =?us-ascii?Q?0nCHrlvY6Dkr8CdwKscpUojwls9eyJU5PlyyW8YkvPAu6lMCcV9T6j1W4Ama?=
 =?us-ascii?Q?T0UxkcgxNg/JJqi+b9qa5CMj9T6s817XWKF/niQ17MwWbQdjaQtzqq1eZ/VY?=
 =?us-ascii?Q?lJ10W1shdJEA1LMdg4Eg5v9OHnx9o/ydaKWwhRHLPj6+d/G1gltY7LCoOyY1?=
 =?us-ascii?Q?pSwvzNT3dP3nI0qT261nyxCHOi4uAVQ5DwUoDGuROzHibuKGA8Jv6493DlDo?=
 =?us-ascii?Q?gdLjgINyEUrIlDnJffzZr/DcVla4dhfigBaAnTNpUHXnitlxKXTI5Drlyq4B?=
 =?us-ascii?Q?zDIYNUeedtZIGjxU5R6RDpluX3ONFvn+DqBk1r7FLiyNwKSnTt/0EqWRygPz?=
 =?us-ascii?Q?+cNCNT7BKVCehTCegJm4Lgvo5vxY/ldPjrzlaQZ/al/Ar3ep7N5nNP7xxphL?=
 =?us-ascii?Q?KRurf59TkvQiUZbK04QfWQ8dozjN/tt3JGkjNXqqZgNtPvZK/7mjtxLhYwu3?=
 =?us-ascii?Q?xlqtD3R91R4zs0fp4EDWJSKER5Uf45KwCDwZa+EAiA14Dpf58+Ad8/ygdxXE?=
 =?us-ascii?Q?AGds/YX56tHi8aC/uaeh/GaTWUG/riDjg3c7pIELqpN2fN0Azz71SaQlJfvQ?=
 =?us-ascii?Q?B6OI9NfZdr9LSUcAvmF3khXaQ2Z909D5cXNOZzWqVmfeH5feOzJQV3uFqmby?=
 =?us-ascii?Q?yvru5Lyy3d6PKmQf9rKepQ1knPAzL/bgAHcDIjnmMIXhf5LrZMLYFFA0aTkG?=
 =?us-ascii?Q?GFjD2PrbW28wYfu1OhPV1HhsKZ5ncGtBjMFI4SvUGeO2qvLpFYFLWpnwFmCV?=
 =?us-ascii?Q?J8ksH33hkUcaDgCK6WFCLWzfkJfR5yL21zL+O/GJPiDCGKjxSuER8KMWhIzc?=
 =?us-ascii?Q?lPv2SCSzYb/Snj3vcSu9KKI83pjn3MZPPbnhCBHKrnj9+/7oeZTfn9rJHtpR?=
 =?us-ascii?Q?PT5zivwWG3lIKDcli3AVRFsXLWd8QThPkxy8qnl6xT2FStbL30LX2zf3rdAa?=
 =?us-ascii?Q?NgLbUd9BuzDs69gos1MYgy6zxFpIiRBZCFUQrNaHezfE6yu3oTXB2Q942bLE?=
 =?us-ascii?Q?gJY9hxSmvyP28l10qb67Rl7p96ppJlvIgTiOo3LIVECACzas95UD+KQ8mQfx?=
 =?us-ascii?Q?+M1RahoitK6XWfpV1uKZAhc/JrTXjc0SzteJWJQkZFYxLPgvfkFjkH/Vb3aa?=
 =?us-ascii?Q?86zD837qBpiD2Gd8wd/G4zpl+gxzFVwqNuiyUPyT7MDOdVbuqKlmfqfZpF/w?=
 =?us-ascii?Q?WVXdX3Kku+sOjVpMKUUmMKOQpIBqDQyRr4MLP0BUDSvdVW8gzHrhh9ulPhRR?=
 =?us-ascii?Q?t4x3xm5ByPp9kBMLPN47tPNDiaE1qoNWRsu6SpVcvRL+kz3jdu5MoefGzgle?=
 =?us-ascii?Q?avMo63j05WAXMwLLcmjUlE6wyvl3q2+LoLh6FZUJtpJ5HhsRH56p0Vg77+X9?=
 =?us-ascii?Q?62Dq5797G0v95DQKX8yAyhVpH2Jpg0leHq5eiq8dfawd3GeZ0HRBzrDUvNSG?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qHjyzcLKicfmtJnHnew5udISCuaeI8jCPSSfmeOuEhBA1FSgxKzkjkFSImvsCin5mVn7ORrfPCUQLa6bqC869yD66DRVF2FRF0UixNJgBMBJrfZViuN8tVHB+JAGee6kVmmAY0mQ9Sln01cD5db68LwTiXOjFvcmWSUGIKOkYDSYqHKxrXfROdCzkoSbCZVPVtvclNvsARd/F5dp41dc0xW68BICLjks6sGgFtl+1GwaMecRf+tmIG1FnZaT/I1qQGJkA74AATntWS7DycOjW9IOf9wqYCER5NbKm4eiARAaVlyRFKNsWNamnvsuvuRrivLZZheXwz8I+eJbw3JLJ8NVmpKDCnxTurYAd/TFEZxXjHAYu3oHTGI1/Lqhu7nkhFTurjhEZeFzM/TWLqyUFgnuBBPetjcuHmi72YBtWTqgYuGAFQUdfalOCj0ErvnRUjn9+C7ctdY6jApv8FqegdFhxdDULPrJwOAmBOcg2d99s8iP+rfSX+7rgjQ5amvjNR7ZhcdXjji1v1v1lj8EaEQk0x9rWK/fowNHPtbj/TbmfrEU8O4L7F0kZ5vCMxVFTLt4iyEmMYgJObtdS23IHv5cK+juxJXuapy/KrkF6Mk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95476970-1b11-4802-68b9-08dd2b73a608
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 21:23:06.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRYTa6p+1WQ5nwBinWxs5ZRpZIR0kK7fkL5sGakMuJUmK02fUyM9VImaKCrGu9lqaTJnPppobtAUzXP87gZOfJR73GU10cZxkEY5vBXqfxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7462
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020186
X-Proofpoint-ORIG-GUID: coSFSr67zsW_6gJs6pRUEw-BQpl-oMWH
X-Proofpoint-GUID: coSFSr67zsW_6gJs6pRUEw-BQpl-oMWH


> After commit 9a213d3b80c0, we can pass additional attributes along
> with read/write. However, userspace doesn't know that. Add a new
> feature flag IORING_FEAT_RW_ATTR, to notify the userspace that the
> kernel has this ability.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

