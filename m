Return-Path: <io-uring+bounces-5253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F02DE9E5F8E
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 21:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C23D416AE40
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 20:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5551B87E0;
	Thu,  5 Dec 2024 20:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NPS0tSKf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iaw054ok"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFFE1B219E;
	Thu,  5 Dec 2024 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733431140; cv=fail; b=ZOAIdn7Py+o0/qxc3epXj//LAYF9cO7hUsdIvOgKv3FdXmbuTW/8ON6FGCLzYeaidEXeipzpYBgvyiZpg+5vkpBNqGxDB6QdBI6UPtbg2F6lUPt7J6tF6t9Icot7RxU1jBXBBUlnj7sK58kmznWUkIZ9BhhRPZwS+J8QQpzJJhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733431140; c=relaxed/simple;
	bh=pCUCrCfQUOWelaXYGWOsMTfa8ni/zGc2izFmxfCtNu8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qKb6goDF/8tL6Xob/8/kCuJ3vH8ulAXib8u8uIV1HzzLs3AYTp98xk2CJh1iC6HbvRPlqBR4Qvd+3wZRk9HNWrRN8jccnNMybZwaitey/fh7D56g+JLDNerEL2qmG6FonseBDfYJUVHLBR7V9Irn8PYHqBDx8BjFEDp6foimYTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NPS0tSKf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iaw054ok; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5KMxE7017655;
	Thu, 5 Dec 2024 20:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=yftB716s6++uM2kwtv
	ld+wCmvigjjHcnJ1Pml40T7KM=; b=NPS0tSKfenedlsrGrU34a+oV0FSeo9ieuR
	CFDjSmKELWTmyjbgKvH3NRjIxxpi55ZOC37SZFPCsRBjB91hBLWsiw9OnoBCF33+
	NF1za5gq+LgawBuWV+2GzdddFm2Ijs6CivcKBf7Gc4lXGQ2hAs/KObx8ZySIpwhr
	/K/XebMJlb3Gd38lE/WOkJKSCh9halSqNb+FsN17Gqiud1z/ttdheOhg29jy7iBe
	do8cJIamCNJVVjOOjm8ZG/nqPai18z44PWzgocg2NYJAUA8v45JjzjkdhM65KwJp
	ZRPi7udC9AUyz/Mt/iB6wDCtbIlMyPFRab0e2XhX8hZxBib8fNww==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sa046b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 20:37:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5K2SZY040102;
	Thu, 5 Dec 2024 20:37:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43836xc9v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 20:37:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EXPrGf17P5Pp+vWWabRxjHq5DeEzIw0xaPT4UAUNevIpZarSwEbDNrBLueRziCvIKUxV12WhwSAPUF26wBvJENkczb+TOml8nksrgxfFRv6Uj5faL1fGc7KmLhk3WD7lwrdTpCpJEQt0K1NXLXmylTTk/MFtjfkK18kcyAxBNaP8luB2158v3WSuq+gmZ0WyJEluHq+wjMeaZIt9nrstRsFk/7GeAtRcpDJID2hxvMvjOxMqbzCJYGOKc0zaja9LMrBRSU88qvCA7oici7GIXDH65U9tlBhdyJx86ODQvv2ZQ6P9H9cLeegv+LJWc/2bNGIcOYl4juteHYc+pug30w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yftB716s6++uM2kwtvld+wCmvigjjHcnJ1Pml40T7KM=;
 b=F1uPw1hSoaamYnFGun5ZuOyXrGsdLLSIkI1y0DO3Ez+q2MTJHrbfQPLjdNC0zvKtZmQ6l92CkZ8Zwc9GerFRkJ+8DY5plSspgOwPLSRuMTvlLPkTFc28uvf3Jzb659Omjg/DLAhdYdvZ5OcEEJSKFHjJFa9QL2P8Vr4SD2dZ4urminVpbq7odeMW3nsWF9kFw6fPFFu4vHJG5N9oMtVYKChoioTObGyM3ZFt07O08REtaJT9jNwq5zZd1EzHzIkTJWyIElx2kYs2kYdpJAnywSwSWYTnzbHRhXGvHs8J8OvfQ3tvKqo8DEGqLaty5YMKSkt23GShTOJX899eeOUNIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yftB716s6++uM2kwtvld+wCmvigjjHcnJ1Pml40T7KM=;
 b=iaw054okieog1TbVEXIaTY2OHXi1RIrAm7N1oWM20bNaFJnLpy2Pcakh2sLoalCZHRDgO1Ixx9LCf+zZWMGvzIysM4CoYpeJh0Z7rPNE2Ld8idmbmOKXSEDDyN4ZnMniQcDiAaHDIDv26VcGjPhjRum9al45l5BjKFRwL1weL58=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7766.namprd10.prod.outlook.com (2603:10b6:510:30c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Thu, 5 Dec
 2024 20:37:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 20:37:28 +0000
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Matthew
 Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
        Christoph
 Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241205080342.7gccjmyqydt2hb7z@ubuntu> (Nitesh Shetty's message
	of "Thu, 5 Dec 2024 13:33:42 +0530")
Organization: Oracle Corporation
Message-ID: <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
	<20241205080342.7gccjmyqydt2hb7z@ubuntu>
Date: Thu, 05 Dec 2024 15:37:25 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0107.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::48) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 019e5509-7585-48ef-062b-08dd156ca26d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g/JvgSjBgHO4AGrlrNAvwL+NgMK2bf1bj/gA8Ec0j91PMk7uEatWz9tb1cTr?=
 =?us-ascii?Q?H8m0wZjuNerIRyc5A0HwaPUboaXmuJXL4rGvGOgApAFlDe8tRGh8r6q2sBEg?=
 =?us-ascii?Q?kOtBt1aGOp1KBmYPbJAx6ixQsmS4upg8nOkw7Mc4Uls+D0TpaMmUTyhj2AMl?=
 =?us-ascii?Q?Wo6L2TpxaAVb1lZAy2eAm32ulULacAN2nLBxTD8kAZpFYujvxb4zuMW6wAlk?=
 =?us-ascii?Q?G4w2RYQkkLpP+e71DJ/0tfN+NiP6t73a5gYCvEFmfvlyO8ceVq+UPdHDi/j8?=
 =?us-ascii?Q?ml6nXQcJf06ZzUCjXlq7/sQ+DXXN+nMoeCQOGE8E6Kp3cBxVf1TIhKFtYYML?=
 =?us-ascii?Q?WcvofJcXp3gqKGpV9l6DCWdluWLzFPP9kWzFie4FufVcj9dtPZE2ce9+H6K2?=
 =?us-ascii?Q?mDl+8YChBPhP/SKQFJaIDImAzq2PmbAbtZv8yhc4UyEgZvqYdcGdmy0Em5xJ?=
 =?us-ascii?Q?krAGtTR9FWrN+JUp8LNFIy5B9cFUOozMrot5GlwsIWz77x5JdheT1IOJ8U9L?=
 =?us-ascii?Q?j7j6iF/bbuAB1Hr/NoAeJp67BupGc/7+g5YCmOo8YIv6ertTVb2mtiCmhCVg?=
 =?us-ascii?Q?C6aZuVl+KTwc738hYlR/n+h0m/CLsAxeSBV9mBjYKLCJB6vNCIaq9M1mZBws?=
 =?us-ascii?Q?UYLEe1ASUXF8TfLKU+NirE9DAbzXmaRXh/5GKd5hMK7OA4rol0wij+J6V+4H?=
 =?us-ascii?Q?jkM7Yfzy1NdBoByT/L4Kp0J0U6DDO8F1dPAT2gmZdi36OD3fwQA9x31FG6eA?=
 =?us-ascii?Q?WUT89Vr3ugJQqy8z9hAypzgeVczdErevG2MSx/Fuhdz9AiPKNZS/2RtgWXFt?=
 =?us-ascii?Q?+mL8gK45/1IaOyT1dDNnVeke+jQ/kHOizzM7ghjyl8oiC+pf+s2IP+nlThnV?=
 =?us-ascii?Q?I6Z7ovB8RWdfrJOPg4Mn7Z+L3pL1/MjxIP+f4EJKS5PJvXifsylUV8qpjbHZ?=
 =?us-ascii?Q?sNkq2ImukLFD9bigicfGy6gS6kh8VEWMEBkitm7x1D118OnyrUHIZhpaAHvH?=
 =?us-ascii?Q?hU74EUIrJcVI8n4diM0ih5IM0c4quddsw2jB3ql9uBrka61Y59ekv6D8bVfT?=
 =?us-ascii?Q?CX+ohDhYGqm5jW3jc+cc3vdiqTb714LEMb9Lpn7mULvHiKCRqXW0A0ierpVL?=
 =?us-ascii?Q?GXfvnKq3OG8aTbtAX5rl3UUmHe7P5PCAThdAXx7E3OhyLIlK/YC9n9W26QFV?=
 =?us-ascii?Q?lOlrKohK4wXFPU7R+eUtuawi7FPg54vv2HYtYGNGay9kUv5yK7fZn7nMRvDP?=
 =?us-ascii?Q?sxYoVkHeCU6OfedNeSwtIFOIeEwboQ2jgWQjohqB0b/4Lm22mbIKPb8qZ/iI?=
 =?us-ascii?Q?K3ioEpvHoLGNSpRHZJX6gshxxQ0x6rsEpjz6D5W+eHgzlg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9QctB4ac5jTUOHG+1d7eA3ZuT4X9Tlh/J+XNTGyAdGxrEucl00Yg8vYodRLC?=
 =?us-ascii?Q?kV8lV7KHCEBQvDlbSeKpc0oJkHoJLZkLlZjWqL3jruzEVMV9i4hgfV1utS+D?=
 =?us-ascii?Q?7eGt70n03ptZUE8/mpRaS0Dm6Lfno/EGT3RXOQeeuQzN8Sgy1Eb+IyygYd43?=
 =?us-ascii?Q?4MAoES5U1FldTDrySlqTbd+oKNhh2qR1T0FgmrP1VX8lf2ZfoY1h3ZM7a7Pk?=
 =?us-ascii?Q?cEKBIXvyKqCxrGgisn7nw37hCn5ULBc1D8oMWCrg7OpidQJSMuNVT4nF6gbt?=
 =?us-ascii?Q?0zXC9P1j8CMVm1BVyJWYa6LJxzd9YYjxQTS5R3V95Sx6W+Bt+x59tDLOIP1N?=
 =?us-ascii?Q?+6AnqeAvEEOwHlPgALqedX/N/iXrbaPUsoTAeLy2SQwx255+D6A38Sr9/wlU?=
 =?us-ascii?Q?DTmQwEweA8Jw6zRYOGp9B8kt5Ue+R4Za+QxGbGnMg83zrUPfRXO+OIk5RS6A?=
 =?us-ascii?Q?d00+pep70fyObyYFv5FdOodP/MLVciDNzO2jujv6VxyRj+RJann+BNB0gMtp?=
 =?us-ascii?Q?TDs/IMvrXfTTXoOPUtN8JhMF7RzriFvrbiuc6GCni0UZhIcU4AWPzmGi3khR?=
 =?us-ascii?Q?F55l7taE6EyHPjMdjES+7UH6BmgAXpLiFZR5KfyzvzQVje8YhScBpcLaTZiy?=
 =?us-ascii?Q?D4kb7vsX24wXWboPcZz/Svj29+GyCDeit2iIYFFiHrBcukzmC9MN4E6AN/zW?=
 =?us-ascii?Q?0haO5TBkZZ/YtsA0Y+sdiX0P04KKEAVN4s4GbwepNwimMZzY4QCxeWH7gEvk?=
 =?us-ascii?Q?NKJYHs0b+Mvrx6V37u7AP29tSIL8Ad6sXAw7kE+iUkExknOOH9j+YmBkaPy5?=
 =?us-ascii?Q?6jwQMrkZNoVVmtjQX2c0ojUNMo+BCXYmRuZF2/zlUfcNbCjqX8Rr0Zl2rLCm?=
 =?us-ascii?Q?EiaXaCaH/vmC7XZetAHOaScFRu2kbyeyNWY/BlrLpneEBV0F4BYdQmsCpuLM?=
 =?us-ascii?Q?xgTGHv8C0l3B5iCqxjdT7X65YhhnGzOgsXZ2WHzm1tIdbpIIlMI+eaaQGI4j?=
 =?us-ascii?Q?u7wGPC0Btgeq4DZaO9NMFqzhYsWG71dWQp8W08hDjSQyRK632iXptd3qOw4w?=
 =?us-ascii?Q?nlfaqSinYpSKFzSoHS0U7/Zg8bEkLDY2Bw3iJDJzQRjNlTZKjndSb1IFDys6?=
 =?us-ascii?Q?rSxvzbsM241bF9DhcYSLZRtrnNzq8D1hlYyA9iXEjo3rkRV1B8/uONjsf6Bw?=
 =?us-ascii?Q?c8s/05jZ3flrscZxMB4uES5pzD2Hgp0WLNW++MsnUkwlo5Vu2D1xtdG6pHd0?=
 =?us-ascii?Q?l14hSGHhhpt6cih2QKqhL/ZLQpcVh7Bx342c45Julm9KndxPzesHnSzV0EUX?=
 =?us-ascii?Q?Ola7+is5z+kvF5FuftwtZjghwdQW8M9hk8Pq4c2a2Ij2UVs6BvBNjlaIHbUN?=
 =?us-ascii?Q?c1KyZnTahyZP9BuhCSdW5Cb0bor0vgUyMzNA8RoqwCys4gWLLnHCa7v/Uxop?=
 =?us-ascii?Q?bzpGfpCriNhgtMlihuLJxXN6oYJDZHhOm3Jiy9SkZB9KcMB9BVUVTmPrz60p?=
 =?us-ascii?Q?3KmeR6YlBmJiedbuHZEgQBEToUh/Om+UG/CJYxbujEnIU22D2c3+DYC0THKB?=
 =?us-ascii?Q?WDPnK/NAlh3gznTt94UNjr1oX9ZwB7RLqbOqAVjh2jLG2ykE+YkvCs/PrTTR?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rnQXKlxr2ELK4ssrPXcitRbo8y19IQ66MYfxFb0dS7bFg5sAwaLk6YMsElmtdaXM+Wee5dJgJPH9XSe8aGYNa3nOKQquSMlYSgnUSFU65R+G1lVExRyayXZs0ggSwUQnKcZs9VGqYd+i5TB9i89W/6JjS8A9i48ZmHmBwCXZO9RD3EWmglqEMBWBShVG32zz8+DkRPZxUzBXrNI0YIkI100uCRX/X4b3VIOmJ2ZnKkPmIfcMG6MJnv8YUC88yHizg7BYksKKI0eLDc/yANJ6gI3NFbXBGNpk/HreoVCe3O1LmEko1WW66o11JC9MPtgldU0xGw1KYMMgfqkOJv3qcJ/iSIaYsLRK7EV/Vh3scX6B1A3gPLOpTHLnM/S9LXZSVsCMHkY1pSI34U9ru7eBMotnjXfPFsO8j32JPyPwnACGiBswjg3+yCwFUFPNMGZhBinW0yzdj5lgctHIVi3lEB/d5Ik+DArioHjijMPMaTE2czw8L0LozM5GLEd2hmxO9iP9AVOPtwr74vWemZ+f3btFxz9tKSVua96d9EcNXnZHOAU5qPRckyZg94rtLiE/hzTVf2H+pJnV2yHQQsHz9v89YiKnQKwul+NQ5mXs0l8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019e5509-7585-48ef-062b-08dd156ca26d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 20:37:28.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Isre8DQfcLughtwI1/s2uRwj+dBjV4xv+jJiItLImDqVuEHPKe/YBbdoPfIX7k2QFdIkXAqWnkuT+h7clYO3EgNAW8LeIxImgTFSV3vBzyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7766
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_15,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412050153
X-Proofpoint-GUID: HDzAxoBwdFFIJKCQAiXSh_FKA7QHEUyW
X-Proofpoint-ORIG-GUID: HDzAxoBwdFFIJKCQAiXSh_FKA7QHEUyW


Nitesh,

> This approach looks simpler to me as well.
> But where do we store the read sector info before sending write.
> I see 2 approaches here,

> 1. Should it be part of a payload along with write ? We did something
> similar in previous series which was not liked by Christoph and Bart.

> 2. Or driver should store it as part of an internal list inside
> namespace/ctrl data structure ? As Bart pointed out, here we might
> need to send one more fail request later if copy_write fails to land
> in same driver.

The problem with option 2 is that when you're doing copy between two
different LUNs, then you suddenly have to maintain state in one kernel
object about stuff relating to another kernel object. I think that is
messy. Seems unnecessarily complex.

With option 1, for single command offload, there is no payload to worry
about. Only command completion status matters for the COPY_IN phase. And
once you have completion, you can issue a COPY_OUT. Done.

For token based offload, I really don't understand the objection to
storing the cookie in the bio. I fail to see the benefit of storing the
cookie in the driver and then have the bio refer to something else which
maps to the actual cookie returned by the storage. Again that introduces
object lifetime complexity. It's much simpler to just have the cookie be
part of the very command that is being executed. Once the COPY_IN
completes, you can either use the cookie or throw it away. Doesn't
matter. The device will time it out if you sit on it too long. And there
is zero state in the kernel outside of the memory for the cookie that
you, as the submitter, are responsible for deallocating.

-- 
Martin K. Petersen	Oracle Linux Engineering

