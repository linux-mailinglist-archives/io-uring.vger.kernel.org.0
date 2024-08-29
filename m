Return-Path: <io-uring+bounces-2968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F103963893
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 05:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 963E9283616
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 03:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D5938FB9;
	Thu, 29 Aug 2024 03:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f8cMpdvh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W5SWBpZa"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170B94A00;
	Thu, 29 Aug 2024 03:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724900767; cv=fail; b=EA9IGZkNn8eR6dtYedn1OfL9W/Hg9EZSnwGP42RGEtc9Fi0Rz8klHSmlgGKMjL4TbnMsAfELLz1TWEk7AVF9lbIY0GZadclwH0M26uTWEgtHtb5hBlYbZ5IGtCP9TaIJa8m40cWAhG0+SOtVyXLwirwS2k8wqoF5cf/V5vNdHUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724900767; c=relaxed/simple;
	bh=9+krpBge+0ORNNgZvvwt4yrzq0xO8zpPMaZeT3hqtb4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UHfhF8DQugRCx6WrPQK7KlGDYE9GIy+mHd+B8U8tS6PtEivuvZ96PpGzOS4xZlRUpkx/xn3yxwwtLaG4PVT1Bjt9ugaOhi7tTWS0amZwQBl/0JbKVjwZ5E7k5RB1aVoKXAAKUR5s3Piux+3ba/zqMoLLjrmiKewk+5a5f/RZtVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f8cMpdvh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W5SWBpZa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fWJg013659;
	Thu, 29 Aug 2024 03:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=ZLhU+39LDDD/i3
	9AdWX+jZYomlL6TH9VF9I/o+pe3+o=; b=f8cMpdvhSH0F8nlI7ehVaBE5JuNcJf
	wgoTo45lxzL2crZeT5YvkxQnudxQKhGEyt50Y/WghRXscPUOcgU0zubL5cPDad63
	n7MOsh9zdZtFtqo4rQlCbJf5RB9ApbhW04pk0RMtrQpBB0kqDlG4CTj9m5eFYLRX
	lZ6Jag+1ORftXEnn1VYc7hcsIKl0rf/UeZNvAjlLS5bq5BiMGMiBjaqIR7cjYDqR
	I5+z1ZnqVuXgMYJBm2o2fOKV0WozpeKY7Nw1nUoRYvoUfq+TTTAtJNT48aix4/K5
	oa7CuJuc2P61LRD/8K786cYcibGEQYP/ozEGGUEw7AuYb+QOHNk171Yw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pus35cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:05:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T249Lg010667;
	Thu, 29 Aug 2024 03:05:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q531f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUdZQ3UEbpTNnY1sByNfNbb8luDfLjYy1WMGjyqhseVdsSTDBYtG5bpzUJOVP1OsU5NHi6PDJVVZh/7S6b2gk+eF/b8K/vAfuX4mTMwRoZMElsCaBtaW0etA9pSn9VdOcRIGjJcL2upzoEE9Nn7DdEEmHHjCIYEc9fo5ZRYGNhVPVEIV0C02qFa7GZtt/Hmt0Qsh4MzMijSABhBv4pmgf65qXsjAxHagIcrVr+4R1sKg+KISijsaznm7oA9TgA7tvyqYeTDQNSUVQmRgX58/f+J+6wbzm6fnP8ZvIPz27T7k+VFKw276h3UjhoVu11SSeriCI8Rabb6YOhsb8viHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLhU+39LDDD/i39AdWX+jZYomlL6TH9VF9I/o+pe3+o=;
 b=UV2G+tLkQ62TQ9QnBHNMOh6g7G5ozYjQisU/LfSupC5y6zNbk/D8pjhj63URqfXoucI0+C6NDmp42ouavsDFFocFX/r0TqxwGess41yhyRSfopJsrWh/3gz3UtEvFr/sdK9igCslfgWA7bToX4JW3IlrAp882S75/rUqy9+3r4uKPaZFnrf18udAsS3fhmFzBHoKoGpm37kaMZK40i3vCrzylzojIju1L2HdquqjR57zG0EY2sziWR8hBNh57UVZesl7Vd3yglyrgPhRsQZGHnGzNIn9I6MPHAVa8wFl0TyHb/977s1GZmmdVaY8Z0eFHa+19W5bM2j7RMBAJ9NrDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLhU+39LDDD/i39AdWX+jZYomlL6TH9VF9I/o+pe3+o=;
 b=W5SWBpZaiCg4XQVnAK7gyAg62hud0n82S9avfsxORfzDSSk2WpGCRY41kthnKJPG48rDAlhUxCa2qV6L0ZKAy0ZrYUUag5rYtVxVMAPDe9zUjtrNtKcCpJddWBlymB0ixN0cfeJLrf6iyIROAx7Ly17KlgHQIDWzauf06db2HNg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5824.namprd10.prod.outlook.com (2603:10b6:806:236::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.11; Thu, 29 Aug
 2024 03:05:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 03:05:44 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 01/10] block: define set of integrity flags to be
 inherited by cloned bip
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240823103811.2421-2-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Fri, 23 Aug 2024 16:08:01 +0530")
Organization: Oracle Corporation
Message-ID: <yq11q28c9kz.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104616epcas5p4bd315bd116ea7e32b1abf7e174af64a1@epcas5p4.samsung.com>
	<20240823103811.2421-2-anuj20.g@samsung.com>
Date: Wed, 28 Aug 2024 23:05:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:207:3c::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 238098b0-703b-4303-5b35-08dcc7d77923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J0YOyOB3Ay75iGsIq78gCpgCcNcW7oCrqQf/rv6gJQiUPNFHXl9b2xy3Vwmp?=
 =?us-ascii?Q?4GGfJBoGIgb1JUROJ9UjH/UtnXx8WgteaXwEKwBS5FrV1sI91gVvgR5+a0/U?=
 =?us-ascii?Q?VxwGLT9Q7qQsqriZWqDNlDODgktiDjlwt0Y5EECRGs8t6hJFx8keN9R3ApP9?=
 =?us-ascii?Q?wrWHgJhh5gd3FjOg9OMCQeDg25J6IW89qEcneZwfnwXbDt9bCJlHruFjJGT0?=
 =?us-ascii?Q?LgfgoZ0zl2S8JLy/hysmg/Wu5ZPTgRgQ/kTTeGMbaeMJD7IIOme2LDsCtKwp?=
 =?us-ascii?Q?BZNyNFHzLezVs9hfdBVYYefLgOYYNfjkMKVfHcfrFnlcZXknepa8vDOSiS8C?=
 =?us-ascii?Q?H4t6Ef8EqG1mezCNlQCVytyMGzK7XiFvkQCygeYbypVwSudJZjneY+C45OKg?=
 =?us-ascii?Q?tOzkfZ8jLqHsODpuf12U+RrEsPYkIa5I0zz4SW+6bTzqwnrsXwLBMMSJJ6ys?=
 =?us-ascii?Q?fqXQvtDeza7CqzxM5YhxyRuMnZNnvpwW/WzP2GBMFHyAAIoV+PLZtE/Nd3/A?=
 =?us-ascii?Q?ZV/89iL5dAZoUTsNqVy3D2IAiJcH7p3i9i339WJcWtbTsvfKB8dFwoO/TpEE?=
 =?us-ascii?Q?AMF837d4V61K7P5QAlpaZF/6BXChGYg+QZcZs2ZHSRwPmPywEGfxtOajwWzO?=
 =?us-ascii?Q?FwjGdnrCC6t3wMTOwmtNKBMHdUFQdZDXjWY837/foamj+j+LoeowF6Sl1YnD?=
 =?us-ascii?Q?SmNQCWydTs5R0qA07RnMyHLKL93KijDv/WKR7zsuzLJtOqe9tA5guTpu7GlO?=
 =?us-ascii?Q?1vOHAvVaEcEKxhsygrx/VH6ww4afry+nktJwscg9hJsGHf/8WPpK+ydGOKzd?=
 =?us-ascii?Q?Tcf0s9EFURZKDo6LXfI1pElyPVPdPKpHs8CU0OGPQE7OCd0SHOfqfKHyiZO+?=
 =?us-ascii?Q?5Gw0SbTL+O8qd/LjsM1D4YP1mS23me1ly3lhFKifcTYXmm1ZdzdPpiJ47lVL?=
 =?us-ascii?Q?zQfPOT0ouqtI07/+KVqvPQ32W/oTY8Uo1lvK4IVm3q6gqtOxy3Ro2AcHLID5?=
 =?us-ascii?Q?cJeNfbk92JS+mCm25ZYgttLipWGCVg2E5hVHnoNJWQi2LeUpezftJF7Nwc6A?=
 =?us-ascii?Q?v3LNY670tQAsEkvsTFC49U4SI2jeWVzxCIPJ9oeS/f+wbWuCIkOlpMdbMsez?=
 =?us-ascii?Q?OMSlRtNNbi07Zk1e5bHcTOJtNCjxAtJXDiZVEcTtHufHFpoHOM4eGRerAYrT?=
 =?us-ascii?Q?190yuhQ7h3L5bYexEHgWCfrtDCcFR0NjIhes3U22eGh2cpty5dc/udYGCGDn?=
 =?us-ascii?Q?L4AchrZhbfr2o2zWZeavWnBd5+GWP/1JpayjRrLk9jluZ1YUeuDLLgYT2htz?=
 =?us-ascii?Q?hPT89zPSoh4Y0TPNHDjYZcNZbnb780x7uupxPx2+KW1eQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wYGGU4hlUylQ1iNrF2jFZpAXWgc1uGmtO5uqQL+5KbzVE+1PC5cR6KYFnZNG?=
 =?us-ascii?Q?8zsOGFReWlYoyxDluHS+7+ZMqAjc1o69jGZb5R9tW0mWyBmww1XS1txvOI4e?=
 =?us-ascii?Q?dKU0WO9A2MoiBC967s6IEvTAlLGxP19jexVLxJKHdZVsm+EkeRQnqmnwoSPt?=
 =?us-ascii?Q?fp8nP9JbQOhW3L5WjF2xu7SutDnnJGdZzneANyMhpTz2fAUsdeMJxFPsFeNO?=
 =?us-ascii?Q?xijccpYJM4uyDuV+PYXK5S7//OgZ1qZnCqjgvGb12O85nZSM2ybsJ6F4499R?=
 =?us-ascii?Q?iPtbByrh5HyJdoCdqeIkOoKQ20cxwJGlS99D8udqu4RMj+cVzjpLL1Os8urH?=
 =?us-ascii?Q?+rlzeXMLnWacNERMC/MQnay6Hvejz460jHdyWcOphl8IPS2NZeS3GToGoyyM?=
 =?us-ascii?Q?5AWpBMxDnq71sWpqNflBd6Tg3SlWTmKpELDg2Ls3zk15FKu8o9NWgb73uOMw?=
 =?us-ascii?Q?AetDQMWW6ZFDNBODI0phmPmMu8xhrOGomHzZhZghN/ig9FH4epbywSZNHA/k?=
 =?us-ascii?Q?H9AiujOe3tps8AimhPCGSLvoeBXZHi8fJawyEfsp1LcsZw8z/g/m5zTRKmS/?=
 =?us-ascii?Q?jeXeiXSvcJXOmeDHduqwbYyVcCOMMIK0BYIMeKT+XYPML/IIk4LHJJRNFnba?=
 =?us-ascii?Q?KtwcLi9Y3f04CMcp2+a5SV3+n2LVHC8KROqpk5mx2ym5iPPvlEEUWkgOyOQp?=
 =?us-ascii?Q?BlS/AndLNSN4WSKndFA32vDc23NixGlUA9kk6k29xCp+b1y3i2z/utP2OfOK?=
 =?us-ascii?Q?ujMNTGVb3QiICSdevb4N+zgIMSx5FkMWVRC4xkfE4sLQZcX1oiuR3muNkfKX?=
 =?us-ascii?Q?sC0MHZYdU/Zg16I+LVjp7Mubel33UqrI+uc3+eJgLRgOyCwrWlv8xX/BHt8g?=
 =?us-ascii?Q?aC+v7TcxWY5kgAm/thU4i0SWyFmmhelj3ngzhRVVvp7CeCG3bXlzNtSoSfxI?=
 =?us-ascii?Q?IhvaH2rqIj3Eg9ee4YlYGdmYaOQmZafJkfrXRawZVcLiLoNgic8HjLnHTSfK?=
 =?us-ascii?Q?/4crvWfPC/h6UffUMz2+5k0Rh8wBOcnvGfnnZp9XHeq1XZzwmMC0iGXJw4oh?=
 =?us-ascii?Q?bjDNwLxCIeXyEU/IJj0D58owYril1v4kKMVbsR7+X0V9TfJ4gxEhFhv6mYhu?=
 =?us-ascii?Q?ay3/AriRBqW84tIrMXp7kp4RhDumSgKpcNlrCkKGuH5tkrHAJ/qSscaBAOsH?=
 =?us-ascii?Q?184iBAeWAfqXOZDl5CPY0nFCc2aM8eSCuw68PFa4Tu12WwLemjEvb9agwa14?=
 =?us-ascii?Q?mHeB0GtyTVDIBlKJEd8nNHLYIb76Fo2ft9h9lIYEJMDWdL7aMA7XW6VOK6Zm?=
 =?us-ascii?Q?tt3X3KRcniIes8DLsjet8IorEGA4xf5OY40wpu14J1zzpZpGKDFbWxVjgLcm?=
 =?us-ascii?Q?AASkAWNyaylSsqab55blfSu0cGC1FGdwGKrFrV6Au+MGfV9khGlUL9Mw5v4F?=
 =?us-ascii?Q?3esXj4nZdeXxN3WeGxMyL7Rq2+YfcqJaF4bAM+mGrqk0Dq2Gu36Oo7yLyRBR?=
 =?us-ascii?Q?PJOhWVraMQmDk7Hxo4eW8gWnE/pC37JGJ0H80H+9MzHROKAiyldS6IIC1eSL?=
 =?us-ascii?Q?Pg01Q/qV0DyQK9MLpIGZz+1SGOpNVX1fliL/gvvucQc4HOmUjniKB0T7yhN/?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mdTrYDOYkHwA249jwZi6O6EqP34ufP5Up1KU7dp0i4Qbh/A8kZ4GbJs0LUAV+aE+gBCY2rp5tdLyRQHFBRRHSbrZFp15w/7V784NlqLO41Eb6jbPaNbXaRCgfteoDeU070nfvHk7LTXLbwe2rDf61gIBJMVblL1F6opa1AnNs0nrRwTv+vT8/lcqsWGk66wh6204HQWappc/igHoDgi8LF64QRnfuGPxLbGjX9h517mYORRhnEqd6dY8wzCfmGpcv1W4RjcrILr8NCJSw1IKn7VEJm+sl0ENYR8/dDIogwSLbQQy5K4KJnWLArlYuxgbGpGVl9FIVDyzk0O2RwoHHQ+2K/z1KVKx7a8fcWR86y7YNGt0r0v0yHctSAhPThjJ3J9ON6dw+jRGSBG66ZPaXuxxQqj1atZRWXkrwEQjDE1SajUZ80KC/poUyyxmFDsxa2J9F+BnycYInYmUHgTQBQIIkStYoW2pHP/50+W7l4iuqZdbWPV1UkPrDfDmcdzR6D5bfTwY1/7P1KdyiygugFRXGat4Tdko8CmK/yTVtkVHC2YmM+jo+fzoqhZfKagWnV69Ij3k30jrvZ5L7VGyoquF0AIbg0QbEcx9O4LSVTs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238098b0-703b-4303-5b35-08dcc7d77923
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 03:05:44.5047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2TUUWYyOIoT9fONGHC13cIl4ENBqt/J1fqaD5ng9v2ZGleh9ehrtWGGRxJ7x3CAVoW+qIuMqwqh9XIzfmOPZM7Eydg31gsHTu9JTH8hmPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=913 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290022
X-Proofpoint-GUID: -hZNaArrqXrX-Jh4_xqDEM1Gxyn2-Jhi
X-Proofpoint-ORIG-GUID: -hZNaArrqXrX-Jh4_xqDEM1Gxyn2-Jhi


Anuj,

> Introduce BIP_CLONE_FLAGS describing integrity flags that should be
> inherited in the cloned bip from the parent.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

