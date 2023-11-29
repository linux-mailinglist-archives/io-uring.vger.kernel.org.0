Return-Path: <io-uring+bounces-168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F3E7FCC62
	for <lists+io-uring@lfdr.de>; Wed, 29 Nov 2023 02:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3802B28320A
	for <lists+io-uring@lfdr.de>; Wed, 29 Nov 2023 01:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5769A1854;
	Wed, 29 Nov 2023 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XCbporUb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vg2K6p8U"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FD2183;
	Tue, 28 Nov 2023 17:38:04 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AT0u5Eo031328;
	Wed, 29 Nov 2023 01:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=L3Aw8Q7iOsxMqWZ5nffn5IQU58It66eKfegayr/8SE0=;
 b=XCbporUbIJBg05FII+hI7aT1Ft2zdxSD/FCxPqu1hVqTp91kVR4Qawho9ve1fcvTxrpQ
 uiOKbOoiYTk8fj7+MlsiSwQjE7Jzo9pUyVjtCvNeP+HMsB6BCWJunW0HL4ygFWNoU3VT
 p964W3hLmb7WoTFi5BjhFMmfMuSi6yw62m55GhjALk/JXlxPSWzJwwMAbpOHKJkp68/t
 XUa66I0q8Pff272NEAHhsrrtf/eaDhYzIBSc/sVA8oOgtJM073smDcf42H7dbtTFt+N4
 r6mc+IfjxbD+217tE3dKKPDYj7gQ/MV2A7l0iv6gNq51R1wQSGzt0+I9srgcFkfp+X+P sQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk7ucqakp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 01:37:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AT0jwDJ012649;
	Wed, 29 Nov 2023 01:37:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c835jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Nov 2023 01:37:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrcM8Ar8w9H5sygIhqIdw5VyURXgEHxVMqH8RVCrSqL9UwtG5CZo6iRNHgslBM6qvJEn/oUqt/0s6mkJSnExmpC6uvxAsg7qAbRBww+UQPNCdq8XQtiO4NaUDx6cVuXnBAF2Hw+y+ngclD7NR69WZ4iAursU+gjsY4h/9PK4wbf0uABVxWfSgaApdN1wP0wztpLWSzu0PfAhYXQJIvhP3JrXWmENO3GjNeedcIUDkR5NGaygv6xeLde3H7iomSnmrjuoEf3t8vZPr8PmX09sMmAAVmnFCapgwB9dAx1DflMNTMhuKHx8rsRo4P+41rap3F5oHiMZi2fmDB5zwRnSmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3Aw8Q7iOsxMqWZ5nffn5IQU58It66eKfegayr/8SE0=;
 b=cK9LY6/Nn+6AU1TWW5mjQSj9kbCv4pIKgi1SUB5p7DGy5Ri7Sd97MxNSeqjxF+OEMAveAa8J32zXNt7T0g5oC8ZggI57aEXG17lj5FVuzQMbJDMA4PxCFAfPMdFKJ7VbsaaFbSm2Ck0eg37V5jbtVt9f6WW3+G7MSyYdvJjaCE2uzMrj2kpxXKRhs9ZpfSIQ1ydRDLcf60UnbsHflB9C208cMK7dY+OVJIbyacWFcpCVmx7zikAEtOAr0fNO+dLhyA4Dkte9jEO6QuyXIHOzjYfL0yH86iv/syiVA44eNFAU1vzGEaLF3Pshxooiowuemh4j8vbDyXkVnwa5AjdlLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3Aw8Q7iOsxMqWZ5nffn5IQU58It66eKfegayr/8SE0=;
 b=vg2K6p8Uv4N+jExE7iPrVPSPHK7mwo7H0QgWbCgnDnPORWkjx7n3wmQcVI8Pyz05bRJFlAr4kq6+hVIV4PP/a7hgVz3SrblTbnbRK1ROmdBqo67KDbA1J99QgKxTjGN7cUjGwwIxNmq7zC4KvUlRRpz8P2JcOJjymQT0UqBFvUw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5760.namprd10.prod.outlook.com (2603:10b6:806:23f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Wed, 29 Nov
 2023 01:37:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::995d:69a3:a135:1494]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::995d:69a3:a135:1494%5]) with mapi id 15.20.7025.022; Wed, 29 Nov 2023
 01:37:35 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <joshi.k@samsung.com>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 0/4] block integrity: directly map user space addresses
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq134wptk5a.fsf@ca-mkp.ca.oracle.com>
References: <20231128222752.1767344-1-kbusch@meta.com>
Date: Tue, 28 Nov 2023 20:37:33 -0500
In-Reply-To: <20231128222752.1767344-1-kbusch@meta.com> (Keith Busch's message
	of "Tue, 28 Nov 2023 14:27:48 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0025.prod.exchangelabs.com (2603:10b6:208:71::38)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5760:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f07e18d-8eb8-4550-7ed2-08dbf07bc399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/17RWTK49gbDpDG7qufGbwBBBQoKJuhV457p9NnXM4akAMyy9UdxwAc0qbYYxvsFUVH3MqPk9vzRG0VoXsxEt4JTsgPtkvByL5G33P8L81W0YU/4m6nya9jCZXmN33ppOWBoGMCvqwi+izfjqvpn5/bjcXshOTkW6y6eGfE+AinHYVQmjFfv0MLWY8O3fNaTyaSz82HYWahJQvI98l+NQ0N5Aixse2tbW5aARSlnOI+h3PC40aF9qCsEhBopVCTAubX85bENXfGLjwE34ki8pJWUVfyrEjX/CEvznoBB0ZCkOparwwWCn4Mn6kBKmQjXRbFHJsoCzua1DuJloN4bGimxurLp7rN7Z58Q0BjLMXhYK6HoVkMRQz2ZzKeFSyeUtGb3SnaYsAcpvf3RRahCWBsRFOTOgH9zIlcf0PGqEuZ8Ia1r41c1WRw9bjcYgCSdoXEd0aONiK0eQ40ZTboYyKXHvtOJAiMbfZacd66tUqxGdle+DEVmHOLH35P1GcMqdM+KLxAg4BN4hTxRlPmJfJFh4uMCboA5P4WPBMs2QQACVcJhRLsBKY9dw+gX/qV8
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(136003)(396003)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(4326008)(8936002)(8676002)(6512007)(6506007)(36916002)(66556008)(54906003)(66476007)(316002)(6916009)(6486002)(478600001)(66946007)(4744005)(41300700001)(38100700002)(86362001)(26005)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?03yjgzT4rckyLTmMz0iYyGpjR5JogOgWR5i/11KJOfyZOcoX8Jm5yClFPLrf?=
 =?us-ascii?Q?iP5IuPqGIfg2DTOtXODXf+NhsUyZxtsQh28t5BUEC7BF5V71sl1YHDUIpFHS?=
 =?us-ascii?Q?Bgr6ZRDQwvMLr6BoCqLLLy7RzcqB0CE2Cm4+vVtUVvhzfiRyatEeTUKJmpwg?=
 =?us-ascii?Q?l1TSc252xeTvwrZrevwf9PYUYiI81Ny4WMCDws13GMLzsjPbKVdGv7c00iOk?=
 =?us-ascii?Q?ZLfjZccTmoUbqnotKkYaxcNocVLu3v8tcd5HcFazcMDWih4kU2oSRfe9A1vm?=
 =?us-ascii?Q?Gpcape8JpF9e/JjEErwI/bBydu33xahgTOn+71PfP6DJPePADRDdP/mo82Ex?=
 =?us-ascii?Q?dpT/4GVle4ofVRNIfxeeY+DNZN4xRc4fi1rZobYBCNyqphuVZrAtKK9yUT8A?=
 =?us-ascii?Q?n4wF6K2vAiwXWI6UoeD5Q3wPHvo9+8SlAcSUmvV7MxKKl5q4/GCptIUi9SbG?=
 =?us-ascii?Q?e4Bc1Q8vXsPbUa/ToAvIjLAYU3ixY3bB9uA63DhCwzPjwamY1CUYm2JwiJrK?=
 =?us-ascii?Q?s59iuBudCcrGlgYG5pKJQPOOXpKelxI2e5opUpzG6Byh9jSZDTLWDk7VU5rL?=
 =?us-ascii?Q?TPeRSkPzRHqCfs668DbVTzoCfeQvZ4x9K9tBncJuDcdzyGwwU0TpO30BxPpf?=
 =?us-ascii?Q?FVjbC9COXIilpRfj7FVBAYl0EroGDbhhJ7jV1kz9LkYHUg0QAcc/Q0xMA/2T?=
 =?us-ascii?Q?YOAVyRqZ3x6ln9LmCb2eCQVfSydqauLSpqWzGfl3NGJ8m4GZtztiF/zGv8rx?=
 =?us-ascii?Q?nMSPrFzQEot1IsDaL6lOLuD+Ul5mm38H3fkKb4yr18szrQ+om05a7h1alZm8?=
 =?us-ascii?Q?vy0tol6mWYsnEtQzH28HrPOKf9SjqCpNspWdOA0PN+hc2GkTZQRo9UjUTzpK?=
 =?us-ascii?Q?RYp/BYJjyO5ogzirTp+lQY9ics+OxChs6RUFHleJ0Ji66s/g5//zakv0cAFD?=
 =?us-ascii?Q?EXJFw3lN8hruahkLKELWlc3vxj4u+HBDsizd8L4OglGrBDiteXGvtaOeOEMm?=
 =?us-ascii?Q?LlGktzsvnXvwaHHNYYvfhJRe5qAjv4BvxpG4ykGjoeEc4ha8BBudxW2EJoyL?=
 =?us-ascii?Q?roVfYGDAW9g1Q2HKSmJU5MDo13hwI5Q/9LykVL+Itxwr47zTkFVcjdc1fn9G?=
 =?us-ascii?Q?t+V64PGf1dILRhOidTbU2R256GGe0j20uuTazHPn9susVgwSPZ9CqPR7mRpq?=
 =?us-ascii?Q?zGmPaKFLkUWJJBGRuLDcNRREOI8UmvXmOFQznVSXPO9CvLjBNwutzsoYUmLS?=
 =?us-ascii?Q?njJS7lyYf9LLWyEJ6Zjhm3M6X740rybdHCK06+7rksox7NxCgxWu8QqES/VU?=
 =?us-ascii?Q?jnq80HUlH9Tr6SuRkr49EzLifMKD1+w/lcUih7jxkWPIsBmiot7hwn2HZ2HK?=
 =?us-ascii?Q?3YyztbLQsL+LZYOycMWB4YBPDh4ZS1Q2Vsz8HrvK+UiYzXpnD9QnpohIznPL?=
 =?us-ascii?Q?NGdSbfor6CiDX9V4LW87jrOc6Mvlvhi65E0i/l4fu7ZD3TDKcSCUFk2YKsCu?=
 =?us-ascii?Q?FSGFLCXREeG/D4ziwHdy9zKiAIitmqxTIBajHu4lDbyhYCWp+nzIEHFWUwdq?=
 =?us-ascii?Q?BSDEAXPqDfSUfyqzHH29zpaZPoJFiC8CCYnpSvRPWAvn1CMFuOZT9JqtG7YD?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?OAkhNbfftPabOY8CzHwdR4sks2DrSQ79fk/dz3ALOriFVVKqKtDFtMxI/sJu?=
 =?us-ascii?Q?cxOmlrJ56RYU3Sae4J29OlnMqRFzQd7xBFvSmUtOSjqlkFcAKdMYXDvXZM9T?=
 =?us-ascii?Q?+tar96z7ZVaPoggV5pSZzB7XdN1iTDWZAajFIKKZpmIvrVyGO2W/9M9waE7x?=
 =?us-ascii?Q?pip723/oJCWOvakptlQfjN5vH8UziXorqM1Rq5VmscF3iE+HaJ6Bj6MXa6jA?=
 =?us-ascii?Q?xbOe3xNAOTgQEOU/0Akgy6xVxJEYKeWS0irxhOMui++y+9NRGK1UO2YrmiXX?=
 =?us-ascii?Q?C5hifx7rCs7gb4jnED9SDc8heARYzqEmkU/oHtGNwkOXMRt4W/JmTB9ZAgfJ?=
 =?us-ascii?Q?i5C5cLdeY3gWRo+tkbquoWzNIfx+iFhI2ZFCKgISlbYBRhPYgRK9WhnrfD0b?=
 =?us-ascii?Q?Wbxidjm/COO/xA3KHIFClmJ67Iw+Y/dQkxw8ZE9f81xXSR7ybw6LgUZ61NDd?=
 =?us-ascii?Q?8STK7jOCAPUh9OQTW+L2b7o9ySZbmfnSgkaDGpDZQncDAR1loEHNp1hznqLw?=
 =?us-ascii?Q?0YmZ8hL9jwnbqtQuk98VWvs6WBAHFVKPJ5VwSC6thL1kW9eLuNhKSEIvU+X3?=
 =?us-ascii?Q?PuxR+F4hJs+XtiZB4Vq95KobnUJhWcCDPX8stRYRnB1m3sBRSWG2NYHsqOoP?=
 =?us-ascii?Q?zMPuVNhPrGAZxFYs6j2ONog3ktq69RTDJfU9QHtYQ8epeNGiitjh+vgcuDsC?=
 =?us-ascii?Q?OQdIfxDsNz2UP/eQisdV9NEjMTbbNi0GKD9jZe1PpFuv0Gmzwzzv3ANFj5mu?=
 =?us-ascii?Q?ESADyGehbl9ese+MpU1QnjK3Mhlt5uPxsm0u6BQPBGA41yPP4QKucw6mc7Cw?=
 =?us-ascii?Q?HxbidErMJUNq6009MyAFfU7EUp0YBNWWuvw7jgGuLRwNp5+fcut5wPIfGBcR?=
 =?us-ascii?Q?DPB1M8A71MY9fxtm7FwxASh2y4kgtOB8Vqs9EXeukN68W9hqZqch5Ad07cSw?=
 =?us-ascii?Q?CNq0U4kEWgvv1JXo/qChfp7n0roba8GHMUW42l+2qZg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f07e18d-8eb8-4550-7ed2-08dbf07bc399
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 01:37:35.7376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOFGQEsFLzc5BYOWFa2yVQgAuajnltPaNrs/wkPDrEvq59vKRyoDXFZ/lTJkq8dZDxkgw/70aWrpWq3pz8H/sBrhLsBAe8408zmHmWUiG9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_27,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=815
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311290010
X-Proofpoint-GUID: SDKyaYk7NF9_gw66wLl5UfRvapmaorAW
X-Proofpoint-ORIG-GUID: SDKyaYk7NF9_gw66wLl5UfRvapmaorAW


Keith,

> Handling passthrough metadata ("integrity") today introduces overhead
> and complications that we can avoid if we just map user space
> addresses directly. This patch series implements that, falling back to
> a kernel bounce buffer if necessary.

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

