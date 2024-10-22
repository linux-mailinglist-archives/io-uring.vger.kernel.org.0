Return-Path: <io-uring+bounces-3882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 770FC9A95F3
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AE50281237
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A6C5B216;
	Tue, 22 Oct 2024 02:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G0YMf1+5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q6x4ZhUw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C559B1E51D;
	Tue, 22 Oct 2024 02:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562716; cv=fail; b=iwTowpXAq/RpItpqI/Pt5cLz8JqlAnoftW02MaGP+FFKIcc+M2WaXNuxtQPMTUoYPwKO+gNRAqDPqygeh+JcdNfvCNxeMToe/sQlj8GkubtIGfKOEawkHwKBMzh1OgVMB4ZEtivNkYPI9FLIJVHWlBYYvKr/fE4dWNZtzdKvR8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562716; c=relaxed/simple;
	bh=fy38wrhf8/65etUm3z/O6hrR/fUTw++h6lV2iPGEYik=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Rv4vX9+JSblMZfpGV+yOCoO1TM+ViUDQfhblnH4SklTQcgbwcq9hrjGcjihsBlew6ou+POQXeyZtWhEfNj8ztyZNl42IHwuF9H1VS/gKOWxXWRyerIrSrzBgqMr+ENbU0Sg/Vue+IPN8T1mOsUYTGQYl+Hr41p1pGihfeAfYkzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G0YMf1+5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q6x4ZhUw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LKffWY007647;
	Tue, 22 Oct 2024 02:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=RKMM1C1ShQ/yWRXlZn
	IG2TebHWeo7Adu2juMA8CgEUs=; b=G0YMf1+5HtmUOUunmw+NFQ9Jw9xeaCtowB
	MWUEBvYx01mP/mOYpsJC1IxN8LAIyy9SvjCEEopsL9mr7Cb8xOmBT5v9n+Ledv0k
	OLluLVgIi91sYFRrUVHscde7H0sheu5O0LTNVNp/0R9uMwhJ5gCVnUUZa+8QGlEl
	k8Hb3Kj4NXMJwUzTNOOS8mFRt0EByfnfeB2sDsim1VjJgL00kfGahszsL2kSz839
	urVh5ztr4PWQTiJvFWAUnt7IHb7m3thM9p3oEW6/41shF+Y/9zSHwrPRdis8/Gas
	wQ+TE2uAAxJVk097A2HUSLZSCDZ6HCzP1b3hcjvFmKl1//o6sidg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c53umfxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 02:04:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49M0Ffgf007617;
	Tue, 22 Oct 2024 02:04:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c3772vux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 02:04:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tH1WSYJEIpbGK84MRt2PPdndYrBK9xuS3Dtb6A7MDLg4E1+gmSPoJaaZgj7mraoR7SJSKVBbWbgLNLu9lWPNEcNb6INYWo3vXDWcgojDDhPUHUpbfwFqDqOlUPHiaeEVb9EZ7JUsJ/qmI/L8RBV4yt2vtM7s4aJGZGvcAO/Vk8tSI2/L4EEz4xtHnNymLfKxSPs/9oB6FHyndNuGQ2N+77XNaOb0EmIPSEP7t1fIWAdLfXSNL5EejG4ODoSwELO3amDonPcS+HQ8oxGZLzZUSXhD+T6GJ3lkm1OLuQe2NMTtUlmr+Ln72y5F+s0Kbz6L8i9HJ4JZQ5ZZGUvZCu+HUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKMM1C1ShQ/yWRXlZnIG2TebHWeo7Adu2juMA8CgEUs=;
 b=YttXjx5r3lIjuXZ2oTsxH/bvfMzcQpciHq9Mz8qdXpK0wupqdYjlp2VolFw1oKcSppW9kSA58ZmUaSZlwwVp9rHpr2S7CqnKmopXdtvzCSK3u6QDFDaqZF9pWiwXoV6sLK7lINbjWamO9FrN4qRum+1eaDkDJKsYhziNxFoqtACl0JUk0SBVpr99zZ0QhAaBzmnm/opbWMAVY+nuST1YGxIufU/YQPnlSQWoZPgL9tnZ7YjJXc+7VXyl7klvbBotWeC1FsUANSe35szg+LVyesgZ9sy0uyN0G6zksazoWuUuS7JsZwiTAqFKWj6aIEDhodOwhZPJtN/a2oZGKaDuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKMM1C1ShQ/yWRXlZnIG2TebHWeo7Adu2juMA8CgEUs=;
 b=q6x4ZhUwhHjZXdoXgW9ei9zoe1V8HBF61aM/qf9A6nRMc4QX4MxtJ/wxCj1Oj5mm8ria1mXPqjNBJrbB65Or/pVriORGJQ30Fc+USKmRCPmGsILP4ftWLmnCJ5c1FFMA0A4VBgJtO9orhjE4/BWSo+pnjMoYnoPIlBrL5joiSMc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 02:04:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 02:04:54 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 00/11] Read/Write with meta/integrity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Wed, 16 Oct 2024 16:59:01 +0530")
Organization: Oracle Corporation
Message-ID: <yq1msiwlwy5.fsf@ca-mkp.ca.oracle.com>
References: <CGME20241016113705epcas5p1edc284b347de99bc34802b0b0c5e1b27@epcas5p1.samsung.com>
	<20241016112912.63542-1-anuj20.g@samsung.com>
Date: Mon, 21 Oct 2024 22:04:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0354.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eeada20-378f-4383-c43d-08dcf23deb89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dXa+gVmFQI1T9hXVwKSikhYxYRA62hbQ+rDdxLQwkaCSnpediT9thliaa85i?=
 =?us-ascii?Q?o8zv8cCPtD0EUxkQgFlXisTJSwZ3lpbkz6UbshbLFxe2xMV8HBotNyIC8WmL?=
 =?us-ascii?Q?RzgDcynDa99rvqgy90eDx3A15MEyJBLmRGrFEG5xZy6bDHdeOpITPgMyUKzC?=
 =?us-ascii?Q?W/yc2VA3FcECdK/9zqMXG3/92VFBjGuZ6v42gyyK3MOEJACPv60W5EjyBz81?=
 =?us-ascii?Q?OBvwzBjQJE27ovb53w/JVd7SRT94OqT4A/h1pYh9buzet7/k5KLKcV9klnAB?=
 =?us-ascii?Q?nIklbT/AnQ1JnUCTpSCV6K/aWgBh9BSTvt2SKYyYXm5bKQJ1uTcIFhXztIQ+?=
 =?us-ascii?Q?VeRYZK4tkSyEHaFc9xBB/Td23xFeHaBN76etVoWwi5mc+0nHmJevEJGDrmQA?=
 =?us-ascii?Q?dJh7KOq09XO8QJPL23+DXJP9A5mc1F6h9Hn+Fzr3RV2tjklcw6hnTXg736dM?=
 =?us-ascii?Q?Iho9r2LcmY3jvo9vGamFr8+tBLQeU5ihZ3piI2FJen1KgN1F3Jo1TKLuNZir?=
 =?us-ascii?Q?mBLT13pXAYrl+Za9aYXgJaDOHLhEK7YwW8x6sJQgDaSotswSllK2YmgFjXBg?=
 =?us-ascii?Q?TvcMF3ad1gaPSfoVjJxvnHkgaUAFY+SJUDO0ECf6QaTqXCrRrhwOzC0R2Z+g?=
 =?us-ascii?Q?IlNe6Xq1conIhM1shOHIJmxfPwJ/srZX8aoIybJ/OX3UTplHTl5Ze3L05kr8?=
 =?us-ascii?Q?s6wGddXcfYKDfsTjCE3kh/FyoO9D4KqgGLtxU6i7P5/5240jcLE5PnNcc83w?=
 =?us-ascii?Q?XtyUJpgquzPNmv1Ovhb/ES+4sIrxW1Zo2wjGeRLcnBLfCtSlFOtE2Qn6C0m/?=
 =?us-ascii?Q?yYQeYfkA4k8UyzQ/bPbUyb6je+xMc37nvmisNG3rqp7hlcBkUOQA5yM7eg4q?=
 =?us-ascii?Q?XkJNkGng3Cw7Uop/uX3Vw8h5BGzHn5pFt0PgD7Tblk45wtOlISPw2BoXQaIK?=
 =?us-ascii?Q?6x708jkvk/PZ2+Hph1LXJNDwruukzlISM7dtMztTwVgSpduJ/8eRAFl1ngY3?=
 =?us-ascii?Q?TiW3yGEe5Vh5Y/laZIR69p+/jFh5R6Ytfw1d7TWgunBGcwRsfAHvfr3qYA31?=
 =?us-ascii?Q?K3gOnSn9HzpEVi+Ki7LU6tzebAE+Ugdqm6bjuLAQEKIOg67QO6b3siw0OHgq?=
 =?us-ascii?Q?JAxGW0j0JyspdrX6DD7MxSfq/IVkgePlnZVr+e+K6BCLQ4GaEVOVue6Lu9oU?=
 =?us-ascii?Q?c1PQw9v5QsNkWCuR3cn7q2QuunQU/TzInnnbkudgTEPMuG31FB0XC788UGWx?=
 =?us-ascii?Q?gtDooeQl6rhBheM/zOoaNrJG1OpqSWGb30kWQV/VXA6oKOdPnoaPquHouMNk?=
 =?us-ascii?Q?QvA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LYWOzrfdiRqEAkdouNuq0FS6P1HOI12zkB19rH4G6dNcN+nu7GxCpNRgh2wp?=
 =?us-ascii?Q?irc0/49gCciZPhSbT4+1mieLFvzz59ATcCwfPlnDWkyZ2eSc7FX/rt7DnD8o?=
 =?us-ascii?Q?5Sy7h/v3Vl0LjcjBI8I82M3Am8Mo16g08iJFOBiBKwU6ithWf3MAexvPdQn7?=
 =?us-ascii?Q?o0uxWHRp87Zb3YNPfXqwWcFJYc3LskUPTNsOQXVKWpw5pAt2blrMS3rXOjr/?=
 =?us-ascii?Q?3R2I9l6a4RBev5nW6iFdEuQXBujgL2DbfD4FZUS9RKtVd99v5vMfI/daMsrx?=
 =?us-ascii?Q?apbueq9w7teBoCvChTA6WNjJxDX6FozQy1ncNjSEldU/ep/Czo5ocqxuNBH2?=
 =?us-ascii?Q?OuGMOSAboUDOmk7Jlsevql7qX3UGvxu1+F//EJI1vJ1Z9c3PUg1tWi85yj4X?=
 =?us-ascii?Q?3wVB2zv0rfVsCFXFmUTQI7n5wWRk5k84yi1f5Vjv0FbFO41J7oqaXy41Gok/?=
 =?us-ascii?Q?RewLvAkQfbGpUDA5GODYr/3kSTRcfYbu5DrU1B4ZrsxmhGQrMhtLKU6kNzjF?=
 =?us-ascii?Q?i4pzYRWzc57dkA00if5N+1+sv2rHQkIPaaQkfxknxkBInAppxYn92e1rAjV9?=
 =?us-ascii?Q?LC1Nu4ZMX24MXv9mgGzCY4CBLzA24djjDVCvn7MCcI3GwlonWL/QXwEkcqMt?=
 =?us-ascii?Q?c4Tu3pCe3XV+a5JKTqbvsSVbnI1ndLmr3PLv1TBSwkquuP/pcq5/ukPiuEUF?=
 =?us-ascii?Q?hdTwIBppwFJ67DeHllwAlmJ1eSNJ7VXWnAvlqSBOZjHj6sAL0KljlnGd+SfG?=
 =?us-ascii?Q?7lqf6MjUFpTQfv+sPKmrbUfqkCndS2xTKSQ+x0Jeb14SoAIM8XDEXut3GhST?=
 =?us-ascii?Q?xoTQZ1lbrlHdEOKAI1mbTssjoK2ecONZOWtWDdRcE4I0FIL7EsebQaH0Oidk?=
 =?us-ascii?Q?m7/aQMFUG/gdmbW/ypRI6rjj2jL/Dclw1bnx3pmq+x52BZECkss/qW49xc0R?=
 =?us-ascii?Q?X7CpcG5VlF289LZgM3qGmVeOXyKSi72KO5m7TQfmJdqrt2VswQJLcW7FC7ds?=
 =?us-ascii?Q?i53JWTCSksBaq8nt+VDWkC2FjvuNNnUWNvB2jJ40sYgut0BSQ0fzjsYxWVRM?=
 =?us-ascii?Q?nS2cfMVhhBO+gq9vRT11tXkH6cOp7aIDfxeReFAP14etl0+AjjsmAFksCLdQ?=
 =?us-ascii?Q?0VyP9HM2FZs/KWna7SMq5lgurStHUnMfmS7l6oAHhUWNlyCWLShzbHDY86Th?=
 =?us-ascii?Q?F6kdG1BSDbAKL6p2RuNGln/pm8wGJQthVjVhMGyzMSHVpj+xcrTvHIfRPp0T?=
 =?us-ascii?Q?K9Mqg+TbomwanfjGe7ZfZiQDEQ2eV/lmXiVrmQboDmoe7hTgar+oxyheHZFV?=
 =?us-ascii?Q?8KkQ2qS+sOMGNq/7YAgRwXVDMStoAxw8PgxK+3tp55frRfYoTrp24HUhjK0Y?=
 =?us-ascii?Q?rJ7f4Q2URwGID5MS9ycZ2S3FkUTQ1lyh2C6d9+uGuDGqCFL8ve8pWQrR/frj?=
 =?us-ascii?Q?WRcaWmCSDN39UreaVYUOMkEnaeKV07nVv0x+Aiunijzoxs/HySInJd9AFMda?=
 =?us-ascii?Q?cUVk2hGXbCeZn0IyVbZ2X33OdPC14Xra2DEg1NqBlk1fnfwITr8jr+WqL8Ad?=
 =?us-ascii?Q?P4WTl+V8X56baZwjtgvBsGYCAY3PY+cEXzxQLqQ5Bt1cY/eygoN+s//UANBP?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RNsVz2BSmZVIe6ITiwdTe/h08elUkhmfy6peUKEs7H2nEjhv/hvLzt4dD3l4uIyojxF5quX9S3hM4ZDLzEXUKT70y2Q2zGI7WfNhpMxT+SsimCyl7cfHDGy+nCJlCTGCF+TkEexIBWvs1cIZZnOnWYCkFbaKM01p3kvDBssQvanCoYhQk5RQgjKDD35XXq5rSInXTDn+fHq5M7ycnvgW1xoX2MMFSmXxooVQgonAHSd2SCnr2qluWc0UXC7b77qTCDJsPXQSAOBjF6eHoMAJ/VaZ0ErZ0CEttbQMHFxQfPRTrhXSydeR6VgvCTI3eu96eNtM0rhNhvZnqktLgJik8lg8J4Tx/9QDtpJCsAJYjGZ6DLGX71RHlMymuj3p4drvpyjMaqezgl/y60BUqd51XqJPDPeYeTAR8m1zHM3aqq7+9eZtz1TuZnfADViWH26U7soN1TXmiQBU1GKghoKF6Ik7yl47RthvwHYdZ79hpWNe+ItTpe5aEG3ES1tPD+3w3bAY+uXxUVeT0bAg3izgqlkTT7WpMzMlxCnp3F/EQ5/g60lFplwLVwuN/tzAHIhj5UMAYNWe4C1wMi0n94VVgQbIchLtqJPi395EYZ5Aw00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eeada20-378f-4383-c43d-08dcf23deb89
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 02:04:53.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qsyTpM8f3vv+t71H+yii4rg49hFYbo8E8DgPjH7rK7wMsGgD9yNQq2z/F0hgjXXH2qvcw/62Ji8ihC2HhmgaTr1L/yNTxI2CARKOuQsf+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-21_25,2024-10-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=663 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410220013
X-Proofpoint-GUID: 35U2VWRap6gEOxxCR-QZtid3iCK8avph
X-Proofpoint-ORIG-GUID: 35U2VWRap6gEOxxCR-QZtid3iCK8avph


Anuj,

> * meta_flags: these are meta-type specific flags. Three flags are
> exposed for integrity type, namely
> BLK_INTEGRITY_CHK_GUARD/APPTAG/REFTAG.

It's a bit weird that these are BLK_INTEGRITY_FLAGS since they are
exposed via io_uring.

I have reads limping along in my test tool on top of this series (with
the sd_prot_flags_valid check back out). Will work on writes tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering

