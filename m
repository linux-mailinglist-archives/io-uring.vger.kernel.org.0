Return-Path: <io-uring+bounces-2966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FF7963883
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 05:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB09528578E
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 03:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D2B38FB9;
	Thu, 29 Aug 2024 03:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YnsB29Rt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0JWzWb4e"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB89C3A1BA;
	Thu, 29 Aug 2024 03:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724900472; cv=fail; b=XLaJWZp+FXPLdcvrWf53bJJbANJuvVkcCYqh+ZKU00UT5Gi3CRWd/nkVD3FT7PEmhGndqB2CO3lFdJ6Oj7f9D9ZBEMRygkTTv6b3kw40gWTX4Q7WPMWKMNXfmPLlldmTxb6K3xSDhtcT1Piv32KYh7vwA3ik9mdV9wArD5IG6DE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724900472; c=relaxed/simple;
	bh=yseTarmPSPmfMtuUhcIp7I6FkUWU4D/dO6JvVmidP7U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KXzwBquBe54brZIBwoIPT97CKdc+ajAsBmBzPdq1EWNZVybmdwrYrHKbzmUDKICvqazmVCK/Wtw1MXEfiajbWbFxYxBokuJeiQDlqxDTDkUVeRXCENxbUXFSI/oWpSFCAjDROVaWTUSL7byhBgDyZg4qcjRJG/pVP1OXtwFwumk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YnsB29Rt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0JWzWb4e; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fWX5030195;
	Thu, 29 Aug 2024 03:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=n29aZURNZ90Ol4
	LJ2hbcVXst7p8Z7lkcHOq1jZSIUEY=; b=YnsB29RtWsJXlrxXITcEhaAd7WA9O2
	Ur4+uOkq2xhawoa8udgkJO4NMviVAKFV8fitDcWWO3VbYs9DvOnhUB+X6mK5+rxE
	2b1J4b4qYTBuvwvU68ZBKRiBeKeZYEZs0+/MlItsviDLJtH/TZdpwESLbNohnoWS
	XvB9upM1V/YmnId3g1YcJKTnw7CVfaTuPmusHWgVgD6P5poxBIuMjbBQMRYhuHy0
	Cmx50RF9V+ddNae2KN2luWlDGQwS7TtcvcCTccFz1ZWJt1u8KjE3jnlpsv7KgaCg
	XGpqiFMtROe+2hkd/OAf5wv7je4LzhbuAhtEM0k/zEW9t/EDbknsspFQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pup37ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:00:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T0YR0p034787;
	Thu, 29 Aug 2024 03:00:54 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4189svbrev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jIalsm5+p62wWJ0J8ReaPa+yo44y+LylkPkyA4RMVT6TZRZUQ3jpb47dr5TtBbmofKT7pBUECBNCPujZr19AzIXUqPbDDGsMCb8RCa9J/o7Z+WlxjsSGMVkjFW9n/ccBRgpV0VAysa7NsQr8ILvIw2pLedMFPeaDSXgfIcMfvnt6WMAmXYS5+wS5TuZ9q+4xcPLAXLLDU/ImXIDR1Qdqi3kXFxjdNPJZlI6jWzUBcZ9nOoLkVfHahOvLl4yrVc6FT3HC8ANLlcr5Jq6p/IplsLTU5QCVFKLoXdJRl/X5rRyZ3O4vDwISqEkt1+90vC2HodXtt8yiozn8nziNH6nPEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n29aZURNZ90Ol4LJ2hbcVXst7p8Z7lkcHOq1jZSIUEY=;
 b=jx6YG65ijAVLZl/p4WhT2Fdf8vhrtHVIutBTkVNEvY6831C9AjOZAetK2kgyziUY1AUsiSWgUMrgiqm+lpQe9StDSra+10UgxkYDkFrho6JW5vNctaEjq12x6AXONbF/LF3iS8UjLbmDbji5a0hYFWNNOW6pEX485hecJVX0X2WcmdNmeCdh2t+I49TioV1n5ZIjor/Iqm7zXNDy8vdBRTSWLaYJsm+GCL9x/LgFWj977r3bQcjPPMFq0nRP19ZjTX2XyVIQdrMejOFK9SamWHckFc6Hq9JwsJXOkb7gYLkPYgQHB/0DVtZjvxpzkFywY9aZiiAJbZKyo3lIZc2hsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n29aZURNZ90Ol4LJ2hbcVXst7p8Z7lkcHOq1jZSIUEY=;
 b=0JWzWb4euHLThJCeVbjQDR6fCamxvMLZNMZT/wvDcJoPydGEXbNFbYLZjZEjTUTXt/HMHE4+JT4fFJ25pZzBrKZwJpyT8CuXv1snbXsWT0PdCn7oayqipKMJYq7FZD0CEpOemrsSFRmV75zQ3KFxTxHS2rpQaIjUQjyj02v3F2o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7575.namprd10.prod.outlook.com (2603:10b6:610:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.14; Thu, 29 Aug
 2024 03:00:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 03:00:51 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 09/10] nvme: add handling for app_tag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240823103811.2421-11-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Fri, 23 Aug 2024 16:08:10 +0530")
Organization: Oracle Corporation
Message-ID: <yq1cylsc9w2.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104636epcas5p4825a6d2dd9e45cfbcc97895264662d30@epcas5p4.samsung.com>
	<20240823103811.2421-11-anuj20.g@samsung.com>
Date: Wed, 28 Aug 2024 23:00:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0195.namprd05.prod.outlook.com
 (2603:10b6:a03:330::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e68abf3-6d72-4536-11e8-08dcc7d6ca9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oiN1saE1zpm28prmPebWKIYZipI0lX88xpB57r2pvLQZK+uhTmECXIXqIOVw?=
 =?us-ascii?Q?CumG+J7ACrFxMIyItIxb28PUakprjfdomzpfvJ6ykh3tIEeQyhutxRCh03oD?=
 =?us-ascii?Q?XRIU+HXXUeqszmPwN+A/G5tEPC7wkn0O3YaxSUmlmGza1YEfECoed9X9RPTX?=
 =?us-ascii?Q?iX7nwtYnkUXBhA493dTDkQSsCGcbz2XheeDHUyI7NnsN5lxTTyXavV+w6+8R?=
 =?us-ascii?Q?Qo0cKugs4UDnXTZXxZmW6c0X1PZ0dkbMzSm8eomWJDHTizd18xIYaBeS6iYQ?=
 =?us-ascii?Q?IJcnWTbZhirLW+lpHA8hMLR3V4gFNfCQlg1SOggy0EMqfvbQR2FCjF8G3eH5?=
 =?us-ascii?Q?UFHwvq0JZx44SKTZbmh3+srr4nYUnlYSdHgpnDap2zlzp1M/SnJRazna3TtP?=
 =?us-ascii?Q?v+nbHA3bRGu+qDPwDvhsuZ5nEL8Qexdp5gube+s6SW2cmYbUB6HvBI2zoeSC?=
 =?us-ascii?Q?zOLSpJTV0VewlDvEYsD9xN00Lmbuz5TaZ8mafdF6/kWJGLr1BBzrQ4VKb0T1?=
 =?us-ascii?Q?RFGCE+ntwK74cVC8Irp4WPn5Al8KUmR2f4SPcPebIY2g/bXYCcWG/48qsShL?=
 =?us-ascii?Q?XY3s4ag4Hena88dZXOb01tZh0tlMSaKZyQM3eQUa+MAPD1xKDwlMx1KyC/rM?=
 =?us-ascii?Q?GD/FOiyJPVuQMZrdVd75ZTg+sEsHqdG2JaM1A2XOiFGGxHI/9QXVhRwMkFPX?=
 =?us-ascii?Q?hp/jfaQTSxTn8lQueAHHc+zeBZkAppsTFZVsd4s6h8ldhTaLfjKXq7H/4cFQ?=
 =?us-ascii?Q?dAGPLCa9/95xBXpYMmDfJ4a50U9v8W9T1BrPlJp/ynzwlRXDXj/xYxRKhgrw?=
 =?us-ascii?Q?h0jbtMeQ96Wn6wjrHnsDtqk1Qw/9ovXq57JizS7SrB+MsR2czKYSoXYrvkuB?=
 =?us-ascii?Q?unssYNOrjQH/L53Tfesu0jdMtYxnbdsi+ute0ArAqBhjqYZ9DTmuJyOo3lqg?=
 =?us-ascii?Q?vSkajU+1npfUVXThDIK/wjtpY/lfg9VE3n2HfCySMYfajZdr93GdryKOBNCD?=
 =?us-ascii?Q?L7tyFReqYkklJCR2JMwwnXs69F21wuLuvVBFeBIv+K0YBi+HDkT/rNRcMu3c?=
 =?us-ascii?Q?KW6L2QC1D+MIxDsiGwGbCu8CLW49NEjPani0iFGhsTg2AyvQkxuRHRX2j1MR?=
 =?us-ascii?Q?E7udltymvLvQkYLDHJ/zh7xSpjMpgr8peMZgcxikugOVATu9F/Ceg2317wL9?=
 =?us-ascii?Q?iZ+zy7NBM5x8A8kkvsETNr1IbSnAZv/4/EtYPRky8mtY2hMCgcsFXvqyHDnV?=
 =?us-ascii?Q?2Rgt02T1tu9X0TS6neO3NJV2td1IfkJmCo+7GPETR0WseCONfZBTeY8HqlcY?=
 =?us-ascii?Q?nNxvwt5WCWy1AF5G9aTqGyRDY/IodgLskfX5XQBzkYjWNA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D9WVdCP0Tevd88v8LpJyozEfv9Dlf/QUWHQc+B/MR1AI0UlBVnjpiry3wGvf?=
 =?us-ascii?Q?BBqSfBXTraszoXYJxG74zrl7t8F+Fq6uYgBMzQ/a7uyvA0glAMimrF76UPJo?=
 =?us-ascii?Q?gkN0efW8IamBzIk6szqOoqzD1JaFbLomJYi2LzP6glgzEqjRh+Go2xNHpXiB?=
 =?us-ascii?Q?yi4RWLn0i3N1OSalwHNYMNONntWppovVmHkXzUMsyV+1qsN6ZE4Dac/V6FAX?=
 =?us-ascii?Q?YUpBGVrKWGQL3wq7BTW4SdkJIGNjqZtsNMzhgfc3+dWxKw4Iei/LeA2Z5HC5?=
 =?us-ascii?Q?Stn27+aEdoPE7fLFMXFUdYasv6U5Nc8dr2tT3jw6iGXcfIP7p+NtfyOp9Ee9?=
 =?us-ascii?Q?nZc2GeIQSrbybTSxBdwJmTFNZOkJCe9rClfv+NX3DfpW+bYHX3UKwKuJ6pq4?=
 =?us-ascii?Q?JvcS29gf5aqYZnY5T7IgbCHFbKS1bxVQI/+0rz7jrI1g05MOHHcJuPnhUB+N?=
 =?us-ascii?Q?66nogF2QBzxIna6WPTv3DBMttCcKf3COu34b62Gu9dhgcz5TV5RkDbbsKm9A?=
 =?us-ascii?Q?WyxTQkc/Dyg1SjGnhWp5Ved0sMnvVYZ4g0rjjU5P4/VDP63QCEiL2K7H20/1?=
 =?us-ascii?Q?AwKl4yylNb6SZfRYaIV7U9o/gZxAOaDEbPLHKPX32AWxtynpD/cMRwP02XIs?=
 =?us-ascii?Q?3nP2YyEBIlHrCJwIW8tSC5Kwp9EfXCB231wTfT7j6NQ1XoSYr93ks7zhCn9H?=
 =?us-ascii?Q?j4SAa0247IQSRK2N+hoNaEHViRDbI6ljHUeNCXhO2ZYwx2dEQOb1peUuwBR3?=
 =?us-ascii?Q?wiEVVfZVtjO09xiK25FeXGRgFnCgyln7akx1O00LVf14xJCEkbOzlwvhAiG3?=
 =?us-ascii?Q?iWzpqv53yXsp7LKl5Ti0SUwWFq+20ghJCPnthJZ94DHXrLaOV0r/1J/Ym9bQ?=
 =?us-ascii?Q?FO/A9HSRDHPpZci4hW12rEoiAf7S7aJhILSPSs+nrIGPFyGu9ao7Ax5NNbiY?=
 =?us-ascii?Q?T41/DF55I+eS42CYf5WlPInHhkYkq0soJ6GRz1cJkczjuygXKxgQXkqltmLi?=
 =?us-ascii?Q?tB1h1FmU1NZulI+LqjbPPAmk/wD2w8gaKcw2/chAfIMaxs1RnTXAPpSE0YWw?=
 =?us-ascii?Q?005HsNnlvFz4KuvGJFnIktMN1/aXtTLbOwuRRtmmsto7CGmpW0UhsUkCn6RS?=
 =?us-ascii?Q?HrFHXB6B5KYORUDkkao1Mc53cZSyv5FkTzYiQIc1whVLwRTFbcL16LHTtPj8?=
 =?us-ascii?Q?ZbB7jS6UdiXfNH+6YiZfQlD+SyUoiWTcOvwahGr+zYPG8ZYhfOQwPTUjGJul?=
 =?us-ascii?Q?VPUkyBWN4mmVjW2NK1oPZGrYqhtpLISR5n+k8XyzuRAjQclB4kea8K465Z3R?=
 =?us-ascii?Q?05HITuWdBMb9fo9vsnyuvczp5SSVjRq5jS/tU/JtbpcpSouiyFWs6kr7F5Z5?=
 =?us-ascii?Q?JVCSbcCH4LtPxYHT4gf5Da1Y5XRoHoNNUmCpYG8k5vc98pQZvJ23hf39HeUq?=
 =?us-ascii?Q?nZl8H1s0sXlwrSfU2eL1Dwn7akN+YI2NBanKhbB9TXCC0cevhwT4mjaaUTev?=
 =?us-ascii?Q?y+4xFFu0pjuRBNgQb+8nAWhx8mBVowtm59I+s04h1iDUjTj4tofahj5MIOt8?=
 =?us-ascii?Q?tAuWDika+zDVrGZMry8Z0vQ1chPRNEP91/sDw+3th0e/TOPJ23JjjaKy7ni0?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GU4e5S+1nVRkpPRixewmYP43LN986/zKLYY33c/VvYweuDn04YXitXJVwkeN5JR66Nw3ysgEMKI9W/C1BQ0Rh7kwvC6u5UT6d4YpXME+d3WT3xPUlbBVowtuJS8uh/W9CjGAlUiDMBh09M+wWIzYW5q+vU/QkEOfOBIYYfBzKeUuo8kG85UH891Jc3EgJ26KhPkUP9NzSpHxE/ygam6CCUNTcLdI3qQA2R2XDE9et1gg0LgexyTVucYSmoxyI7BwvkY+se+vDxJU/UGTryDAstr8SF7RjY0RyjyfZ8kbcbe3Q3N4cdPKCuNTGtMUU9x2p8ULlx5BMsvEvSHeJf2sNUIVr8ieinTzFzG+ToIpLG3tohZDJXuxiVHNEDzeojOchADxggJNw23VugZlVDDU4iHFfoCcY7mERVQBie6O8Xx0lqZZsxNLZcV7bjIZsDU3dPSPnwH6bg1i/gBnASroJIeWcuuT9FvqXD0b9pUzOdMtaIdu0hUKK4EwdXJ0bUhTBoB6IR+fCDXUjcmX5xMwQ5PdBUP8wA5qoHKCmrtEpLlV9P6H82yOlG3RfzcWQ6kSmmI+aAdBY9JYqIw1SILirAzYnijSuO02vX42yw7iYbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e68abf3-6d72-4536-11e8-08dcc7d6ca9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 03:00:51.6883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHZzIuYYs1Kd8PM+Ay1n1V7dgiR9hjCPRESmeTkNrpokvVNKoruMibTnRou6f1ZBFIneRWhtLzvtxziuqxLn3fmwzKHpA0hOKe9RS6llFzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=832 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290021
X-Proofpoint-ORIG-GUID: t542fSzv-xGSlk6IEmu-MD6DvNi34_YF
X-Proofpoint-GUID: t542fSzv-xGSlk6IEmu-MD6DvNi34_YF


Anuj,

> With user integrity buffer, there is a way to specify the app_tag. Set
> the corresponding protocol specific flags and send the app_tag down.

This assumes the app tag is the same for every block in the I/O? That's
not how it's typically used (to the extent that it is used at all due to
the value 0xffff acting as escape).

-- 
Martin K. Petersen	Oracle Linux Engineering

