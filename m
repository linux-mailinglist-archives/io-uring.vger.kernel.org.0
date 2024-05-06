Return-Path: <io-uring+bounces-1793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A8D8BD2E9
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0F551F21B0A
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31EB15575A;
	Mon,  6 May 2024 16:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dd9fbWf8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YoIfPsNx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E92414293;
	Mon,  6 May 2024 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715013186; cv=fail; b=WEId0rtQ+/6sjDRxFXHhIh9mTk5Nd7b7D0T8tHJ+YDM4YuwHa5mkMBwKMVFQTI3MrcTXFWlyHMclt0fOQS13NCkc0NjCgVl37Rj0oCFDAJubknb0/uIeeQ2SvJvXybnfxqAZJw4/x2zW2od5rltl6y6JR35PctnEsILnNP40qUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715013186; c=relaxed/simple;
	bh=qWVDWiUWZFraaj8kb7Iym6tndbe4h5T+nUOUei0/CyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RsBlLMvtBTfiD291eXYjg4s63IcputTSIjVvW6aDaGS4K62C3H0M8KbZYBqu3dx6bVsibpGH38wMmrRaiPs2Nd/+FELXrZpMAnaJMqWNafB0YNgowhm+OKOxyb1f8666g5zug/a6jz9Op69vf3IfuXwVkE+gTuF95CVPswWLBGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dd9fbWf8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YoIfPsNx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446Amx42018880;
	Mon, 6 May 2024 16:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-11-20;
 bh=tVWU6s/ThW+WwoE2GW213T6lTHfHA2on7z95CmN9QIU=;
 b=dd9fbWf8xCWj/cudxJiJ6Rrh2reDT5erS+qYef7YuuEdNV0ietf8ageLP/E8t1rIS1cj
 5zs3d5VCwApTYelsj8SkDJ31KUWKM5wgmxZ7jiRr2ySoAZysD7vfDVOkkzmsykc4bhww
 tmvzDkZ0Sgsihx/E75CQoqLDh8nkQTR5R0ZpfsWW6dtSQr08uvdInCQS4iur6/ebeEDg
 ZtGgJKV+xzohdIly1kT/hsvKqs7m/7iJ54fwH88mFK3QXDf9GKfQRJFM/n8QgZ771gEw
 8Wqsn/Tkhq7n9+A+B3X5XQdDo+I1QZNwk8XP+pYMaGq6fjkbTuxB8iopYvljFE5QUrpO 4Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcmvb0p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 16:32:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446EpSko027556;
	Mon, 6 May 2024 16:32:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfd3amr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 16:32:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrUmfMUPiML7IIKr4SKZ6Iyb7jzy2V0cRm+Cuc/59o55MrbZClO7VztRAiIPmrkFCAyy5gdotzPDnRiCCfk1RasOasisrXUdbtrc5z7QioESkkzOuIkhlRhBvyZSzITW902FRr8qTfXWlCFCr0XUJBh/67x/K+gLeyv8qMg35j4zlK/26tEbuGwlZ2XhuwalgmoRzBjghEvKqM/jbHNQ2tqX8f0losrcxR/gEPEokhpvI3LAiMLCFEEoPnVBlnDYEfIjvOczhgvL06nr/yK0MnDMvFqwIew8i/SOKMKLQoEmou9xViRwFbB6fy9OcCAHeWXrqQOAM70pa2m9v2QUsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVWU6s/ThW+WwoE2GW213T6lTHfHA2on7z95CmN9QIU=;
 b=EkNP6ah6t6meRSb3059QleEnlKC40EE9RiMSZBVw9m7JFsgaR+7bcqfxaj57EdTAency/TQvXPY+7Ea/Hp2zrtUNswVvIyQHH4wkTdRjd+1tlS0tEyifnw0oCKr2Ht99pmsDwQ7nfDlVMGTtPymYSpUIjChcTHBfu93aCGI0TKLeTLchp5n0XzI/iNJ+J+Mes4o10dN2VGJa2y8SmstyL6HbBPzVAbn2gaysEI6PzdMP1/3w1LXN1mOP0ceoefWnCs2eH50/jlZLsL9/7XlSWZW9inD++B+Lsx1vTgPi2c4fEgzORQx5G/4o3s/kMnAJ+j+K6K+TvDBzIKL9JxPYqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVWU6s/ThW+WwoE2GW213T6lTHfHA2on7z95CmN9QIU=;
 b=YoIfPsNxJ5q0WKAK8Ha2T5FLg0chiuQMpP8BmKvHPLRoH056XZ/SnB7FaU067IYgLngsLZJSGmXxskL4fIBqyezcFtqZtSUD9ukN2p02VdxQadUuqebU9e7kQAaygBf/MQkUowjFUzk9/9v3sClreoQq0hZ2DJ+bNlvWt1APZAw=
Received: from DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15)
 by CH2PR10MB4149.namprd10.prod.outlook.com (2603:10b6:610:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 16:32:07 +0000
Received: from DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490]) by DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490%7]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 16:32:07 +0000
Date: Mon, 6 May 2024 12:32:03 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: akpm@linux-foundation.org, bp@alien8.de, bpf@vger.kernel.org,
        broonie@kernel.org, christophe.leroy@csgroup.eu,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        debug@rivosinc.com, hpa@zytor.com, io-uring@vger.kernel.org,
        keescook@chromium.org, kirill.shutemov@linux.intel.com,
        linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, luto@kernel.org,
        mingo@redhat.com, nvdimm@lists.linux.dev, peterz@infradead.org,
        sparclinux@vger.kernel.org, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Message-ID: <tj2cc7k2fyeh2qi6hqkftxe2vk46rtjxaue222jkw3zcnxad4d@uark4ccqtx3t>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, akpm@linux-foundation.org, bp@alien8.de, bpf@vger.kernel.org, 
	broonie@kernel.org, christophe.leroy@csgroup.eu, dan.j.williams@intel.com, 
	dave.hansen@linux.intel.com, debug@rivosinc.com, hpa@zytor.com, io-uring@vger.kernel.org, 
	keescook@chromium.org, kirill.shutemov@linux.intel.com, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, luto@kernel.org, mingo@redhat.com, 
	nvdimm@lists.linux.dev, peterz@infradead.org, sparclinux@vger.kernel.org, 
	tglx@linutronix.de, x86@kernel.org
References: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
User-Agent: NeoMutt/20231103
X-ClientProxiedBy: BN9PR03CA0453.namprd03.prod.outlook.com
 (2603:10b6:408:139::8) To DS0PR10MB7933.namprd10.prod.outlook.com
 (2603:10b6:8:1b8::15)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7933:EE_|CH2PR10MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: a298842b-87f5-4dd7-e269-08dc6dea11e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?6M+3HKQ+ldqt4Rtwci88UgMtW/041j8a+bAIZ49j9AMqrKNPzoF9U69E2Bgp?=
 =?us-ascii?Q?Mk+ArKcSS/S/N4LRAxdL4ZYp4zwek0kL8l+Y4Xez75wc0VmxMO8oHAxFTRud?=
 =?us-ascii?Q?cBbMDcHL9xScJCj//BupJI3Uu5bF0AZw0ujrTrcujKno1pOTleg0wtUpmkA/?=
 =?us-ascii?Q?eutgnpJP59tWiBjUJBNiT1054k/dgnuS1gDvXu/TyM/CTPu3pQtvdAvxnQ5h?=
 =?us-ascii?Q?H2+Yrw+SvGcVrgK7oFYHycSJ0gebT8XuPc/uW5zGSaWT2v0rr7M3sgOr9SqV?=
 =?us-ascii?Q?yNouQYXOSXd0S5mYV4eV2kBfXVuparbTiOsuv2pAM1fX5qEusSy4P17T2nE8?=
 =?us-ascii?Q?pztSvv+UxTbn/paKa1iIEyC/YjOZZ5/XLtN0V3qNG51ZzZ+DVf7smDW6UHYk?=
 =?us-ascii?Q?l1vLFf9zQUavZ0pQPoJwzzUtFBT3mvT0c35RPceKDeHIqP9rR9kT7MOXPk48?=
 =?us-ascii?Q?RJ6YmGYQxH3weWet+PimuqwYowsM2eDaFbqrU3Tum0k/tgca10RHxvj1x5eC?=
 =?us-ascii?Q?bbVDi6dMafV8U/VHmF+czFL2EY7rAeiD6DTzB6J5KCk6Y6uaI5sSh8hWemtu?=
 =?us-ascii?Q?gKxnLmxvOhdDSVFs9AMP4z+Z3HSHph3zfDyy6JphgBwEb/68H5L782tBoUXF?=
 =?us-ascii?Q?EIF6ckzKP+qOz9gg3GHp+T4yQOVKbW5NPKiqsjOeqN8pvlA2GbXt2vI4fC6j?=
 =?us-ascii?Q?EgGONj+1WpFk1ySM7FuFtObMyKfr3GqTc99RDR+9gchPaZoBj30vDye/jJoq?=
 =?us-ascii?Q?m+4SmqaorKKynm2PxsOZhBv7+7FcXz5xHf9nHXOl4i1Yil2LtqZMBkkEE5CR?=
 =?us-ascii?Q?W6rxhLPwnIfeuc1hi7yb69REgwzCKDU8JorW4a1aTe0P0+G80njNw+iwkUHt?=
 =?us-ascii?Q?jEdv+AJJJNOetHyUBu3zWBOOErZrFc7Er8lHDweJ76f3FiUdMrtjEqujMIeE?=
 =?us-ascii?Q?uNZzFTaAZv//ffNF1Igi0Xfhqt+K4nfMNGvYlpoSZ5p1NC6aW+Oku2OM+1y/?=
 =?us-ascii?Q?fQw2EZ6cxv1P1+PhY40FqUlo6Hc4bGUuWZ53OrCoJA20o3w7JOBUnLm0jn3N?=
 =?us-ascii?Q?uHk+q5NJhKAsGd4G9+CdZPvJ0lpxqvQo6oFfrZ/QTzn1ZRXlytXA85ET8GCb?=
 =?us-ascii?Q?D9fknq6yzOWddVye83iYP7h5llocDL0zaj9/pDr9K6DXeJuBFu/6OYzQqy/D?=
 =?us-ascii?Q?pD7D0TMKfqu8R14FLEGxy/2m9iNc9AfSHHeMhw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7933.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FQJZXyHpj15Vs3eAhoBqfT+2fkWzDZpGxBzdCRspzGZmUV4JoxfgfeFfpmNp?=
 =?us-ascii?Q?T4vkA3ZrspFmRptYKg5ZgNRJLTiZt4LJreX/hLJfWKK74jhA8LlzNx0QLj+y?=
 =?us-ascii?Q?mFVhn9d5r381lpnoWSLlqLFYMG2SmHZ7rIQQrbp1Ody3yYIOD/0WfPZMUcZm?=
 =?us-ascii?Q?xB2UB5FWohYmYuAQcyHPKZKqcGwk98EoZKl3hsR3G4rpAvIjX3//mlHQCPFy?=
 =?us-ascii?Q?xb/a2E+DzW+WHCn0e7aPjDp5U1sDKDuGIAKNBpy1eQucBL92AysmXDB7MlWK?=
 =?us-ascii?Q?5TT4BHO2dCSB6L6LPIHU218/L7Dy3OC+p07i4y1FTrt5TQj4t53yncp1hXzZ?=
 =?us-ascii?Q?cPJPoX36y3LI2r6AEayqGrnSwfv7vjksWlRqordcYX7sxL8pmlnuriQuX/ej?=
 =?us-ascii?Q?6DHvfffzeK0vAOVt5ExUoyyq1ajO357P/K7IS5K3zMGE+XqibvzW4A4Tgrxc?=
 =?us-ascii?Q?cxUyk6ixeWhkSDAuRmOqfzjeWqyYnvYL/jJTvA5PbaUDnwSrWp0Ni6xDdv/k?=
 =?us-ascii?Q?NhsC8uuivrBtx1umYy5vYr4XxttM1qSzamGpEwe5s7M47/49qVka6jihjull?=
 =?us-ascii?Q?GL2r5Kxy0hkS8JRVDYVZJLiwrQ9sBgc/cxJ91ZwvU+tBkqHpgn5GTKCeua1K?=
 =?us-ascii?Q?kl4oNA29LSHkpVeeS8PS9lVcEKTahQ3GBw11XcMouLLysCcddp7OvHGHR8T6?=
 =?us-ascii?Q?9g1UOyHmBr5gx36Q4llkjkPdqCWO1wpV0kJalq5usQmnAKJrzC50wMNUexcL?=
 =?us-ascii?Q?VRzP5AqqrQwrgShEI2+gsrqiy38UaKjOUEw4l/rjL+WQY5G/Tkj3COxmaToN?=
 =?us-ascii?Q?bGestlPns68iuZXBIjCRds0iiHG3E2BkCbnP0RNlDk7/Lb3+5GfOTyD3yJM/?=
 =?us-ascii?Q?ynZ109qBN5eZC/w9hYiILfze7gZXNhvdquQY6rnIN2y0pdO7Oa2mo4Am5EWC?=
 =?us-ascii?Q?o1NdcxcBxQEOJdfJqbFTcxhR3o5wucIskQEqHRKast4KnGn4l+L18gvv3MHk?=
 =?us-ascii?Q?oGOs9T6+Par+QQFurXTvfFsypZaDALQ525LewRKX6pPbk25MCfVQqaY68QwQ?=
 =?us-ascii?Q?aXq5P/3HvQDUC9dXs4SXsecN9Vc7JxH2oNAdC5lYCSJ2/NxQxD/2ZooWzY0k?=
 =?us-ascii?Q?dk6vhrFQAekEDcz26FBazIRQuB1ysFqFZ08xjewL6HYmzoATJDkeidemDLB6?=
 =?us-ascii?Q?FvDkVGEJ7hc+upgTZyIUUPtYmjl2BgTgkr45NHDMCf72Zfn1qGjCG1t/sVgS?=
 =?us-ascii?Q?LKPq+ISNZ1flbDohwCuepLIRX66mwjqQTzgNQGq/UJgPadkd11+IFKVD+gBn?=
 =?us-ascii?Q?eGY911KyOByPLehuylpzezEPj8nOtR/1mqdsdlsw9grmjn3l6QcSIEDnSaI5?=
 =?us-ascii?Q?NBgQgxWm4BcIPlZkw+nS2quwQIVsmbQ1W+PtTMS0FpGZvUer6pSZqbgqRZgm?=
 =?us-ascii?Q?4PDvP3q/MT55WpdJF4yjcS47kZMBFOdLzHUh23/ylfMzr37mGU5MgMl1CvmA?=
 =?us-ascii?Q?VdhNaW51X8Td6mO6JLI4OWHmRIyPqlEekXqo2FubeC2PawzePj6rNQxYt/f4?=
 =?us-ascii?Q?8qr2IaJryBfzH+kmw4t/wtMHNu19JKg1D4jbgqyN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	08W2z6M7XXaCvtoT+I1jZthd7WgOenKLBocXd5Ac8smhKVR+ormqDtcSqx4KmeTUQGKjHs20S5TixfiLjuz6ENf6swonzXDDaU5kBRGwL5ZfMYvn6by0pS2l8CLPKlC3Mir/3dJEj32sV/urHWMeLREp7VDX1hCD7+tfcCXZISkYCWI8qq8vqRVmsb5PZU3wWPkDD2QNjK25+6RfAyAhr1bL9QnDhJuMwuj4G7SKu7JhmTZQiUD02qNdAty3X9BuRgzpTHCCZ8EPAeg3q4AbwqZLSg404SGWDwU0uaGqAQEwkKBpwanZCyC56hHgGNIhjL9E8Q0YpRo5aUSdJABVqG5/zYmTa9VdE/DoN3kHT7Zf4FT6M1Zc8PTdSMhvLtwJW8OUVCFxCHvFVM/5Gl0Y6kBkaBv4uHRzPZwP3zTA5iMBfegYwFu6qgmcMSBjoLMQmA6Ymr2NRYnYDK8ceT/otSJ2TGwgskAbsA+vQNnL5hF/3PriPvQZ0bV/KuBFrCnjYZfXjpSn05/nfC3C+9xhbvbMIJk9xmJiq+zTJsqegdLajzfOrFXte1mEnBiFaULN/qfdRnEWRQlC4vT5Xr+Eh0Zi/9t+3KnReAMTxBO8m8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a298842b-87f5-4dd7-e269-08dc6dea11e4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7933.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 16:32:07.1740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhNQSx4QKmf4rqQgEAuNnvRPwVCMbjU4yVE59IPAQcoVrjR8cfC0p8foE/22PGUBNCzn8CSPlbJvIqeK6JKXbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_11,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060115
X-Proofpoint-GUID: AAmGHJRXJl55T06wLMFRITivgmcPcwKx
X-Proofpoint-ORIG-GUID: AAmGHJRXJl55T06wLMFRITivgmcPcwKx

* Rick Edgecombe <rick.p.edgecombe@intel.com> [240506 12:08]:
> Recently the get_unmapped_area() pointer on mm_struct was removed in
> favor of direct callable function that can determines which of two
> handlers to call based on an mm flag. This function,
> mm_get_unmapped_area(), checks the flag of the mm passed as an argument.
> 
> Dan Williams pointed out (see link) that all callers pass curret->mm, so
> the mm argument is unneeded. It could be conceivable for a caller to want
> to pass a different mm in the future, but in this case a new helper could
> easily be added.
> 
> So remove the mm argument, and rename the function
> current_get_unmapped_area().

I like this patch.

I think the context of current->mm is implied. IOW, could we call it
get_unmapped_area() instead?  There are other functions today that use
current->mm that don't start with current_<whatever>.  I probably should
have responded to Dan's suggestion with my comment.

Either way, this is a minor thing so feel free to add:
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> 
> Fixes: 529ce23a764f ("mm: switch mm->get_unmapped_area() to a flag")
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Link: https://lore.kernel.org/lkml/6603bed6662a_4a98a2949e@dwillia2-mobl3.amr.corp.intel.com.notmuch/
> ---
> Based on linux-next.
> ---
>  arch/sparc/kernel/sys_sparc_64.c |  9 +++++----
>  arch/x86/kernel/cpu/sgx/driver.c |  2 +-
>  drivers/char/mem.c               |  2 +-
>  drivers/dax/device.c             |  6 +++---
>  fs/proc/inode.c                  |  2 +-
>  fs/ramfs/file-mmu.c              |  2 +-
>  include/linux/sched/mm.h         |  6 +++---
>  io_uring/memmap.c                |  2 +-
>  kernel/bpf/arena.c               |  2 +-
>  kernel/bpf/syscall.c             |  2 +-
>  mm/mmap.c                        | 11 +++++------
>  mm/shmem.c                       |  9 ++++-----
>  12 files changed, 27 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
> index d9c3b34ca744..cf0b4ace5bf9 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -220,7 +220,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
>  
>  	if (flags & MAP_FIXED) {
>  		/* Ok, don't mess with it. */
> -		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
> +		return current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
>  	}
>  	flags &= ~MAP_SHARED;
>  
> @@ -233,8 +233,9 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
>  		align_goal = (64UL * 1024);
>  
>  	do {
> -		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr,
> -					    len + (align_goal - PAGE_SIZE), pgoff, flags);
> +		addr = current_get_unmapped_area(NULL, orig_addr,
> +						 len + (align_goal - PAGE_SIZE),
> +						 pgoff, flags);
>  		if (!(addr & ~PAGE_MASK)) {
>  			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
>  			break;
> @@ -252,7 +253,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
>  	 * be obtained.
>  	 */
>  	if (addr & ~PAGE_MASK)
> -		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
> +		addr = current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
>  
>  	return addr;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 22b65a5f5ec6..5f7bfd9035f7 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -113,7 +113,7 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
>  	if (flags & MAP_FIXED)
>  		return addr;
>  
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>  
>  #ifdef CONFIG_COMPAT
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 7c359cc406d5..a29c4bd506d5 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -546,7 +546,7 @@ static unsigned long get_unmapped_area_zero(struct file *file,
>  	}
>  
>  	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  #else
>  	return -ENOSYS;
>  #endif
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index eb61598247a9..c379902307b7 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -329,14 +329,14 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
>  	if ((off + len_align) < off)
>  		goto out;
>  
> -	addr_align = mm_get_unmapped_area(current->mm, filp, addr, len_align,
> -					  pgoff, flags);
> +	addr_align = current_get_unmapped_area(filp, addr, len_align,
> +					       pgoff, flags);
>  	if (!IS_ERR_VALUE(addr_align)) {
>  		addr_align += (off - addr_align) & (align - 1);
>  		return addr_align;
>  	}
>   out:
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
>  
>  static const struct address_space_operations dev_dax_aops = {
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index d19434e2a58e..24a6aeac3de5 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -455,7 +455,7 @@ pde_get_unmapped_area(struct proc_dir_entry *pde, struct file *file, unsigned lo
>  		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
>  
>  #ifdef CONFIG_MMU
> -	return mm_get_unmapped_area(current->mm, file, orig_addr, len, pgoff, flags);
> +	return current_get_unmapped_area(file, orig_addr, len, pgoff, flags);
>  #endif
>  
>  	return orig_addr;
> diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
> index b45c7edc3225..85f57de31102 100644
> --- a/fs/ramfs/file-mmu.c
> +++ b/fs/ramfs/file-mmu.c
> @@ -35,7 +35,7 @@ static unsigned long ramfs_mmu_get_unmapped_area(struct file *file,
>  		unsigned long addr, unsigned long len, unsigned long pgoff,
>  		unsigned long flags)
>  {
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>  
>  const struct file_operations ramfs_file_operations = {
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 91546493c43d..c67c7de05c7a 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -187,9 +187,9 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
>  			  unsigned long len, unsigned long pgoff,
>  			  unsigned long flags);
>  
> -unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
> -				   unsigned long addr, unsigned long len,
> -				   unsigned long pgoff, unsigned long flags);
> +unsigned long current_get_unmapped_area(struct file *filp, unsigned long addr,
> +					unsigned long len, unsigned long pgoff,
> +					unsigned long flags);
>  
>  unsigned long
>  arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 4785d6af5fee..1aaea32c797c 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -305,7 +305,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
>  #else
>  	addr = 0UL;
>  #endif
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
>  }
>  
>  #else /* !CONFIG_MMU */
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 4a1be699bb82..054486f7c453 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -314,7 +314,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
>  			return -EINVAL;
>  	}
>  
> -	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
> +	ret = current_get_unmapped_area(filp, addr, len * 2, 0, flags);
>  	if (IS_ERR_VALUE(ret))
>  		return ret;
>  	if ((ret >> 32) == ((ret + len - 1) >> 32))
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2222c3ff88e7..d9ff2843f6ef 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -992,7 +992,7 @@ static unsigned long bpf_get_unmapped_area(struct file *filp, unsigned long addr
>  	if (map->ops->map_get_unmapped_area)
>  		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
>  #ifdef CONFIG_MMU
> -	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
>  #else
>  	return addr;
>  #endif
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 83b4682ec85c..4e98a907c53d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1901,16 +1901,15 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
>  	return error ? error : addr;
>  }
>  
> -unsigned long
> -mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
> -		     unsigned long addr, unsigned long len,
> -		     unsigned long pgoff, unsigned long flags)
> +unsigned long current_get_unmapped_area(struct file *file, unsigned long addr,
> +					unsigned long len, unsigned long pgoff,
> +					unsigned long flags)
>  {
> -	if (test_bit(MMF_TOPDOWN, &mm->flags))
> +	if (test_bit(MMF_TOPDOWN, &current->mm->flags))
>  		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags);
>  	return arch_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
> -EXPORT_SYMBOL(mm_get_unmapped_area);
> +EXPORT_SYMBOL(current_get_unmapped_area);
>  
>  /**
>   * find_vma_intersection() - Look up the first VMA which intersects the interval
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f5d60436b604..c0acd7db93c8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2276,8 +2276,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>  	if (len > TASK_SIZE)
>  		return -ENOMEM;
>  
> -	addr = mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
> -				    flags);
> +	addr = current_get_unmapped_area(file, uaddr, len, pgoff, flags);
>  
>  	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>  		return addr;
> @@ -2334,8 +2333,8 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>  	if (inflated_len < len)
>  		return addr;
>  
> -	inflated_addr = mm_get_unmapped_area(current->mm, NULL, uaddr,
> -					     inflated_len, 0, flags);
> +	inflated_addr = current_get_unmapped_area(NULL, uaddr,
> +						  inflated_len, 0, flags);
>  	if (IS_ERR_VALUE(inflated_addr))
>  		return addr;
>  	if (inflated_addr & ~PAGE_MASK)
> @@ -4799,7 +4798,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>  				      unsigned long addr, unsigned long len,
>  				      unsigned long pgoff, unsigned long flags)
>  {
> -	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> +	return current_get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>  #endif
>  
> 
> base-commit: 9221b2819b8a4196eecf5476d66201be60fbcf29
> -- 
> 2.34.1
> 

