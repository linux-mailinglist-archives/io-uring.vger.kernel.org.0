Return-Path: <io-uring+bounces-3875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CEB9A95B1
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 03:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63E591C22A67
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 01:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6A484D29;
	Tue, 22 Oct 2024 01:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y6HZL4lD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tMpEZ6iq"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3166648CFC;
	Tue, 22 Oct 2024 01:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729561838; cv=fail; b=O5DN5qk+hf0j9lRRFsyg4Yb9T7+ZYpsEmr3P2Psi5Q55qSd7OOYSBqFNcq4M8Zx8SiYECg1fKUOEti3umlr7d4dpASuJGKujS4lCStDPe8Tn3KQkdQXrMJ15oJ4tAomrEpvGmpcjRl9yO5F/k98mks6rKIDf1biBeu9cuLzzaCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729561838; c=relaxed/simple;
	bh=t/46+bn/QvvIRpvi3THpbGIwKCQ6cOBnSf3TQIHqqMg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pPo+xrXpVrO6WlxFjWD4CGO75bG7mx4FBU/33IMyJxjHmCgB9ITOIS07um0M9bNRTnp+OqAlKBbEmSb23avYW0X0UG6ETsuhz4n3K0fM7ITefZQaePRCxIpX4UZJROfNvlwXwALaGMjxzqhI21GXX5x2J8FDQrwkx8ndY2tzM9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y6HZL4lD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tMpEZ6iq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LKfets017771;
	Tue, 22 Oct 2024 01:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=WpxqcP2Ha+zHr/Bl1T
	a9CCUKis/Yd5EZhyJkJHn53cg=; b=Y6HZL4lDppyBK4dm/4UzmDJvt8LOTAfqfH
	/OO+wmX4on+W5oHUoN5LNRhxaYpgXSZmZ81MsTRM7oMCl6z+uig+DrH7m0y0Caan
	lvdYh0nfHoS6DRVDw3jF0i8msu2tm+7E6K72S3lTkzZ7BFzmd4WwJHqmKlDTvdQY
	gBGywsp75PIFZKXC/uxcw+NkQfpVspBtHCMZNxiPXxRBCun9iJjFg/3/9TVYMkCr
	9Kq232mcFvnOBZ0EMneKm/QQvworsM9tQGEkofMYiO4VIo+LVLpG+3KHnoJfPTY7
	PovFI1x4rTZFLWThYaqNfuXbsUS5oJxWi0KQwdXflMc51okqqBlw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c57qcecr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 01:50:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49LNd8SJ020318;
	Tue, 22 Oct 2024 01:50:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42c37d81gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 01:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dEn+EvXLG+tEBa0iHhtRiRkY2hIOVS+ReEWVenObUFEce9QHXNXr/oFo+ySeH+AWfWYhU6JKQrmwPI9qyKjqok2Q928lUqSEL5s9gwjlHv05Gmv+TCdb4nVxIrdzk2kPhd0X6cQ985QcVk2h3paNfI86oxVacmkcwIItElh84blbZPJJiMHmMxZXKs9OGc8GC1gK1nyLCiwEot55hFgUJVxlU3nakw3r9qH4JxXujstQ4QrFqpJhp+LQm5+x6aLvUGjkzYhjd5Cz9GBNrwaFS4tc9Qun83vvb0ZK0fuakCLeSYDiq9Y9e8s0/D5jX2WQBxjkohPD3i5f1wSNhhH+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpxqcP2Ha+zHr/Bl1Ta9CCUKis/Yd5EZhyJkJHn53cg=;
 b=LJDg2CBiBbnxl5Df0ZgaR6pEDh4qWldm/RB/KxI6N3aIT54eiLu0nOEOLoUtsXM9ww1jqWuY73gla/+dDlqM3ztX9xot88rRgKE6mpgHW+Lg6Rk7U3JGfFS7hV7PRdkO3SdhjZ/OtcJ2KDM+4OSMNW+tOiTNJ3Di631iI0vSMAAYPrjtcsGCiP61dZ6xksR8+BE7Ycl3KI97UwR2R9igL6mg5h6y9yJMpS6/wA/VQ3M49sfi8Renmmz8lgU3cKCqyscweptYUql4DNce2hyf0kwanuMnB6Qoh2Mn4ZBQr7WVwU/EL2I6YVFeO5NqTEQX2cARSfzwHKFYbQ5C6RZBTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpxqcP2Ha+zHr/Bl1Ta9CCUKis/Yd5EZhyJkJHn53cg=;
 b=tMpEZ6iqRhuIavjvWUllMn4w87kewp/RUJsxlUh/nonCj6A52Mi5F8AToWARA0qhi9EidHZ2SHLOkzOy3MHlL/d3Q+bgFyLmeveezi0W5hPchbW41+BoOLYg5EqU9I7JLEgHz3dErLcJCRO3edj2017Wc4jgYlNttZTKKdKb09Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN6PR10MB8166.namprd10.prod.outlook.com (2603:10b6:208:4fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 01:50:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 01:50:05 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
        martin.petersen@oracle.com, asml.silence@gmail.com,
        anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 07/11] io_uring/rw: add support to send meta along
 with read/write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241017081057.GA27241@lst.de> (Christoph Hellwig's message of
	"Thu, 17 Oct 2024 10:10:57 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y12glxu1.fsf@ca-mkp.ca.oracle.com>
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4@epcas5p4.samsung.com>
	<20241016112912.63542-8-anuj20.g@samsung.com>
	<20241017081057.GA27241@lst.de>
Date: Mon, 21 Oct 2024 21:50:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:a03:334::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN6PR10MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: ecbf117c-8155-434a-ccf2-08dcf23bd9e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gae9ZItSK6oqg0vN/G24i6lF3Zo1X5K/+qec47KESTGszd3qTDc7fIbuVchq?=
 =?us-ascii?Q?vI2Gh70SaC4CesXFX0ttkPrmCqpTtklPFd9uWQEeipFQuqzj1Y2NTVP/Fkiv?=
 =?us-ascii?Q?KkitFumjaWIUQaM5ycnJibWd6ZU+8Mdd6xNFyLdOLGC+rnTAI5/MkSIy2Fao?=
 =?us-ascii?Q?xq7PZu9a/xpetiKkhOe24KRX7PHOhHnLEOEJ3ZKeXIL2iEjYfoQSAuSavnGN?=
 =?us-ascii?Q?EWoSwm5ycrxH/0a9ihJUoopTKXwud4V0dj22J27ZoinmkvzDIaXXh/IF4cuY?=
 =?us-ascii?Q?T0dPRGGlRnLrMg41W5Qw8BEh2443TrtPjZIhfEA8/biNooVAX0QjfxzZkBUg?=
 =?us-ascii?Q?5i4JKOTBylaWPTsS9GgfR/EvG04Nt6u6RNsN3+jli2J2ZVnZbGpzggzWZU8R?=
 =?us-ascii?Q?N73ZZm55iI8cLMYcp0IPMudxPxtc0QfR6Xjfs4WHObUprN9/tgup61+JkEEB?=
 =?us-ascii?Q?W2i9SJClGZMBwsM5gPXb5F1QZ0YcaDZijbSj2t+wwKenz8iv19pFS71++bvi?=
 =?us-ascii?Q?ko9iQIg9s3dW3oGn9HJnUGeLmNZWV8mTqLprV5Dy0h8BipOnGYMj0hTiTSmJ?=
 =?us-ascii?Q?RX6Ug7oB70ZShQRY9IpJ/AwPzsWiY1RYNZzjuXwtMyQzFcR+7jkCscnO2x3Z?=
 =?us-ascii?Q?BhsYjxg51STxbSY43mY9npFSl8tlYJmpKU2/9oudErIHpivB71pSj+fEcY6l?=
 =?us-ascii?Q?D8jW/sy+YxMlBQmApsfbFCr+dd4P1uhq6FUAHTf65w5qlcqmHCC9vAV4ORUt?=
 =?us-ascii?Q?Qe2ZMjaZ4NzbgQA+YLGBbwaREyGmcNtQLBRI3cV+aQBnbfmX+CxZGSmZt8FF?=
 =?us-ascii?Q?9Vh+CHjyvZGnP0IzMVnOleJToUCG8ZP3bmmKpDlWhRig4+1yVfGnzdCnZKRN?=
 =?us-ascii?Q?oFOSdlgihxTNUibWC8VhavQRSX94wTZDM7jFAsFzeyJX21fnu9V5Dcqk0bz/?=
 =?us-ascii?Q?/WFs5ApMxCQrNKW8aBDjtiqJ4VMO7Mvvb4jwHHf2Ucy4GeS20WNtjcqkmmpM?=
 =?us-ascii?Q?5D62Qez/0vC5mojM7hrOaSgo/IQ2IsOT8vcxAkbymBrsQ4scPsH2/6GG14xD?=
 =?us-ascii?Q?EXEvcFmYFBkuDIYw4KAaJLc/ftyWHkrapcbCP649ywLX6WFCO59qJY4qh4uP?=
 =?us-ascii?Q?IJeeaoccZ2aPus1fvlB5akusqFZJhvE1lklo6cXFz2v74BHM+FyY7KgOMtqp?=
 =?us-ascii?Q?fg2eBAOa63sdfpbQzf10LdiSXbewH5/nPNAJ4/KthlmthT4AI0Jq3032jGfR?=
 =?us-ascii?Q?RemjNzLmfQiXh0bAcydOplEH2CXiVS9EV4nuDiiFRElvl1PJnjqcel7igFZf?=
 =?us-ascii?Q?iPuxvFAekJ+3pJJdYOb2rArR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rwh69YtnWj0+ca24Mu1i6opAXA50HeqkXA+j8LV+aXxlSpLFKTmKL+6GDBTs?=
 =?us-ascii?Q?4wchgdxdeBgFnnUYXqfeu+0P8IQQEd9v/Iyldof4Oz8wQMHx3gqZPGVA3Fk5?=
 =?us-ascii?Q?zLV0igALJco5s38P7890XVgLNT9Je7jDK7yvJTGFzhZLWgynKjNEOF8gFOVR?=
 =?us-ascii?Q?ok/hQN/YVA/U1Rn90OOsDn1fo6v5BCzRqPjFgQuMZNzcK4srqbCIoWDbZH7z?=
 =?us-ascii?Q?/7M6j7J0eYrQYDOJnJGQVoa7O1J5OrpVx7hzsfCSWNG0jR8OkYbnQI6HZc/I?=
 =?us-ascii?Q?hiUGdN8sI+MXUPv5Y1QEuInWsS9i0tJ+GqpFiHf/0Wu3HXvclCqhKYPfjjQD?=
 =?us-ascii?Q?f1GaKN2UljJnXhUbIAFvWOES8/hx3QvpJCloCQLfLaj/yNkSyLqyHmW2hthZ?=
 =?us-ascii?Q?EY01kzKZr1gLerCnw0TiS6pALhUjPb+po9m0ndR0A3wroucNv76eSiAaQ0eR?=
 =?us-ascii?Q?RCIZi0j5pqmlk/fvN9tRbzsf4nbMZPX4szzdy0EfkohIZxO9JWZHSkIMWy00?=
 =?us-ascii?Q?7sGpWP4n5Jg5ZyY6id5v5WD139/cILdK9wRy4L4OIg0gO21loXazwBkRKgH9?=
 =?us-ascii?Q?Ir7YPCToM3IiX5CV3I9S1iTJU6bFhMZdVXksFLHi0mS821qcn8pyy/7QhFWi?=
 =?us-ascii?Q?3YfjDl+5B/Tw08NyPR1rMP9C34RoduZaoL2zjJ9kD8IpFNsBrsr78884Dzyt?=
 =?us-ascii?Q?HwBjG+x2FwhU3sgeERA0I7WfzfE+5Hm+cxdifInh58Xjg3cNMMcnvzE4SNMi?=
 =?us-ascii?Q?9yl48FPrTjKDnJzjOqLmF49ughT5cISNhhsxSAGv7ren1Riht1DUZFrxvOvA?=
 =?us-ascii?Q?qRnVbVVU5WFYtWaQqaDRCQAcGBTzBOHyQUZ7QFMp3qZ7MtqxX/yXjrX9jSPH?=
 =?us-ascii?Q?9UfVvPFo+9nsT9J/K6k2lnSaeUEXcppAjRdY0fjc6EYlNl/4MoLlR0Og20FL?=
 =?us-ascii?Q?+xD8khY+V6PHIFx6Ku553e8q8KDJuXiqVxQyu2UjvVJSHoSEaLCmEVk57T8G?=
 =?us-ascii?Q?KZsAuy5M/9fFCAGlNasntzRRXMqbjP8UFX+rOy6Z5RTl7737ehedWR51oeZs?=
 =?us-ascii?Q?Jj36ZdECrLysDm31oRCX7Gvg/m95nZT3CoAuE3FJkO1/po12JsdxhbH/6F9X?=
 =?us-ascii?Q?uIQPjVeveJnGagCj/Vmh7Zu3D6xjD8P6B2coCGRTQ5QV1ddRA2r8Zpylvu8B?=
 =?us-ascii?Q?NXFYR/a7v8xFZ7/bT7nodZbzWRL9+Md3j2MEZLB59Mtn2ePWA5hLyEhfSMdq?=
 =?us-ascii?Q?AxdFUajkIAjbA2NL1YffPuXugr9g6DSAW/5muXH+yW9xY0MHoU3qZ+6PHnkv?=
 =?us-ascii?Q?tR4tPu9W7NPdwUYLfsFrCkfPdx9dnYwcExAMVOrJntpqydigSXo+l5wGGC8a?=
 =?us-ascii?Q?lkqRUSRLOn+TKQJkkh6h2PP6jn9CAKudeVgYl7raGxduECrxxTOV6vu0IEWy?=
 =?us-ascii?Q?a0Dx0VkX16MfHi7FOQ0CDz47iC3nlf/j1sOoIau9BEe6JlUVbs+lYRu54VON?=
 =?us-ascii?Q?dGv+P2rjL9wljL2cglDxK3IsTftdr/cb2oBa0f4+7Xd/KdDtywWbhAG5+9RI?=
 =?us-ascii?Q?AA+pE38OBR22x+SpcGRwoH7GJvmYO/oaS4fEwYEd8id5jGZfZW4hrHrDIIHK?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	49wO1I4mmgyeitFLmRcur0ZYIbEtswehFSrqsXK8SQbiTOVofdkz6gJ7EWHzV3ZEIUDYuK9gj1S5bjDlGDHWMho6K4Wfqj52ESgY1fS45NW+Uf52zjfOGUSCUfdpGGYvRRU4RHlYUiJIimO+UzCdipN2HG0Kysrl0USJ+7qwyO24S7fB9/o+eny9HVxOBLafu3GyQ4LcTTdwdNTFmLsxfuJrR76ZmZh57OPMfEGD3AyQIeu9i1YqK9V3g5Yb+SEOPZapxaHpzxUwC4+JjlUXXeEgpsEV+gHPtx6O4yH7+f7HII9w5XkixLF8flXt59W8Xr7Z1h4cD2qgZRWNUC5i2GUC/5EQ8VYo9WMrZricXwXvRT+v0Oy3BWvvFmlRvWg6s9oUjvJFyBdTh4YPTmz12sgQW50yZE2iF/MVmoPDebC3Dh0zPd6pHrREUKnsmWIkKLrPZOOBwRkpUoENJScXXLIOv7YaslioJ0U/owI0cHYYK4hFn+Qb3WoXwP0PSZghlLyZBVzVYsboIm1VmeDaDsVsT0ZWJOzscGX85f/UN9ARUfD14FpWTIuWxobxRthuZ4RhtOx9r6179a5WfcJrPyp2ZIhoLQQiEh8tV2Jyc6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbf117c-8155-434a-ccf2-08dcf23bd9e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 01:50:05.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbpTkb6FPKcqCpqYJegjobujA44s/QD9C/t3pY9m/D3bt8quKBF7UIsItHvhJLcCM/3hKB8WfQJf09qmTCbD5d3ybwePk87XIJ6nLQPCtaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-21_25,2024-10-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=678 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410220011
X-Proofpoint-ORIG-GUID: mKFLVKpCiQyRIEzVn58_KRW4Ael_y7Mb
X-Proofpoint-GUID: mKFLVKpCiQyRIEzVn58_KRW4Ael_y7Mb


Christoph,

>> +	if (!meta_type)
>> +		return 0;
>> +	if (!(meta_type & META_TYPE_INTEGRITY))
>> +		return -EINVAL;
>
> What is the meta_type for?  To distintinguish PI from non-PI metadata?
> Why doesn't this support non-PI metadata?  Also PI or TO_PI might be
> a better name than the rather generic integrity.  (but I'll defer to
> Martin if he has any good arguments for naming here).

It should probably be "META_TYPE_T10_PI". "Integrity" was meant as a
protocol-agnostic name since there were other proposed protection
information schemes being discussed in the standards at the time. I
didn't want to limit the block layer changes to one particular storage
protocol.

NVMe implements features that are not defined by T10 PI such as the
storage tag and the larger CRCs. But despite those, NVMe still follows
the defined T10 PI model. So I think "META_TYPE_T10_PI" is fairly
accurate.

-- 
Martin K. Petersen	Oracle Linux Engineering

