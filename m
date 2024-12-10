Return-Path: <io-uring+bounces-5375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C15969EA482
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 02:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15739281B58
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 01:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C218E1863E;
	Tue, 10 Dec 2024 01:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eAaLCnpO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pSyeuCY2"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0935951;
	Tue, 10 Dec 2024 01:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733795426; cv=fail; b=I3bGM13yQNmwtRdIf/uMTY4WaBNU8Rbbw/LicLLt6SMKadVqWHv779L2liECmovRTwly9NTOtbauL8Oedre/zqCMIPolVBw7dM6Ed5qe5auWcQh3EoAF9Z28668m3tlBHbCJSIqIISyqo/7NQevanuXKYMYWN5oVbdrrv5ZdIdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733795426; c=relaxed/simple;
	bh=L+Y5rbEdqylMgCXP1oKipQFCZeIxqHszUx4l+REsNyI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dFlrp5pzlxOYEeu7k0kaPsimSzkyuUrnSfj9EXr6gTdNTQfbK6S8R3lcvYhih5FucQ5HBqxC7IvB20yZ2JuNKAyxlyqusG+nULyAWrJERwrkg3F+tZgw/mLm+Ej5Tg9gFl1BKV1UFdgj5Rs1lbiUjQj8Q4mmeIX6/hT/twp9VGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eAaLCnpO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pSyeuCY2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1CERl025235;
	Tue, 10 Dec 2024 01:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=enbXDVFPYL6Q26qFtR
	u2LCy8291GssrkIa3C5+DF5Eo=; b=eAaLCnpOf6b1C7U0IfZikNQsMSk+dG3/5Z
	KKgNGj37+cNsfmsl5nT8iZnol946XqPcp1YLxg+EGIr4Jl/KJPkx07JyPW5qV8bz
	sQQm/KuS4BhvBZDT7YoPMcQyT7aZQJUhcYhEKQDUD2luupsxvCsr4ZFMmykIWeDd
	1kCaBmazuVq38VeMibnJqhlb8gJ15k5xXNjdkYwKds6kyGEr5M/2rSIMwSoJgQP6
	u7I1GGgIzk/pV4XIzge7zU3jticgWZ3dtU7FWU3sdTSl1igILN3np637mdMbdMkM
	YvpqWLbgWTWxF4km0BopXj9T1S/fKCG3jHQRrUuW6ZNxek3HUi3w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cewt4pck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 01:50:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA0K9LS036264;
	Tue, 10 Dec 2024 01:50:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct82eyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 01:50:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WOTUMs02XYQoaNrk5AQmeebQjQQilBA3doYL1BQtXSHRQE7EAZ5LxnMIdxsA6CO/y3G7/BQB993T5r/vkAKXiOJ/nHuZHaVE5IZfqBqC/tHszY88f8BiXQm1hfkEQafwvwnwdPHJqZ0F8N+Y3ATcUL7j1HN2g8aToIMtzFiG6wVwZu4X20+WO2Fs0LU1yPouCoCzsdWCTBNEHozec+mL6iPFopjJv+EULC6yqMd3BbuRkgGcZtZCwyjtJWWlWN7GXR7MvdsbNrEiAh9uDpEACR6QEUvkpjgxRnJn0ZldN8yF9iIfkYGS49k/58fKZGgaOOJ48ZE9j9y5ta37LUUCrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enbXDVFPYL6Q26qFtRu2LCy8291GssrkIa3C5+DF5Eo=;
 b=F70HHciFQOYtmBxNSzzpsFRht/1vD0vpUM1zI+yzf90U1+EIF8Yc0NLoNob67q50jnSo1X5v7MbShjVZuVASVXWpCO1yZm88NGox6/6ZVwCQkCFkpNY6xzwfk7i4xVhz1Q6A7H6X1n2z2pK/+KJ0g13vXt9CFbiY/5XCG3MW98JEuD4SPW2jIR2QxJod83ywnnRW9SwjVvpFnCCEaJOjq69gbaNrw73Kjavfquy3mRdvsGEs8yHNE4B7mPy6/1hFKipnfQCl0Q+ik0TMQ5nDD6/nFJyVBBzSemNH2pD2EeTs9SN0hYCWDOMxqGnee7rng4ujy7Q8BD5vTS4HB3bGBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enbXDVFPYL6Q26qFtRu2LCy8291GssrkIa3C5+DF5Eo=;
 b=pSyeuCY2C3+aNJ/EVxIIGviAuF2nfmsvGAvVwr+P5mVN+DOxI37pp8gB2v4PF84OcKaw2zex/erGQhmMLSKjzlyHm+ebh+Qwlx5r1Qj4EIVzJ5fhBb+YBDseR5PEw1mgV2WMMB9bALygrJlLjs0uHzrfvnzMAux1ttCEy1YvaZ4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4592.namprd10.prod.outlook.com (2603:10b6:a03:2d8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 01:50:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 01:50:00 +0000
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
        anuj20.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCHv12 00/12] block write streams with nvme fdp
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Z1cVx-EmaTgdFgVN@kbusch-mbp.dhcp.thefacebook.com> (Keith Busch's
	message of "Mon, 9 Dec 2024 09:07:35 -0700")
Organization: Oracle Corporation
Message-ID: <yq11pygmij0.fsf@ca-mkp.ca.oracle.com>
References: <20241206221801.790690-1-kbusch@meta.com>
	<20241209125511.GB14316@lst.de>
	<Z1cVx-EmaTgdFgVN@kbusch-mbp.dhcp.thefacebook.com>
Date: Mon, 09 Dec 2024 20:49:57 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4592:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a27ab22-f87e-4366-5e79-08dd18bcf50b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hb/Ydi8++QYKcxqhklsdIc30Qds0YTefN6d32BjgvoenAiREMpchI2tTEjwQ?=
 =?us-ascii?Q?sQ+K1xQFPU3h5TUzHTx3/DKMOhPuyenQS5aE1+wlqvkTZ5LjuxUTk3qxxDfZ?=
 =?us-ascii?Q?0Mj7SWpJR6snz98Ycw4IFEwt5Nk/zZQJ+uI/0PphhkX1dbMpKyXTgweHjRWI?=
 =?us-ascii?Q?x9igweeYE91AiHs2Dwl20FsouOgqKdm914BB5pr83m7ifUmxH+Bg3yAelCqj?=
 =?us-ascii?Q?TPK44e/yIy4DOnNosUXiEJ6DcvsrRvcD2S7TqQ2WHHmeITTQFaqHz9C8seqg?=
 =?us-ascii?Q?NHoMjL1SQcoSY0FT0min2csp8vss2lB7eLg1UNW/knlS641llsQsOO9i+3lG?=
 =?us-ascii?Q?Dg8TJV1hojeDG6FEM5LfTw43+NcKMITjBLsC0YzJVxvvmIz2p2Iuc/fR8Oft?=
 =?us-ascii?Q?qMLag9dGapbTPcd0JwxHUheo6DbNt/P+4ccmEPg8/WboEvOKN/75odY1QcTH?=
 =?us-ascii?Q?7FpGplCm0tdl8IjcJ6qvBCFmlVCePBYyUwT8321w/avIzDqGiV/MrxI+9L5d?=
 =?us-ascii?Q?cT7Mvpdjvv4thziKoCNVOBpZFVP5S97IF5BYyMs8evZPo8uREm96Dkllaq8M?=
 =?us-ascii?Q?xh73slKC1LiToSrOLffnNTZA1p9cA2/oq4eZl+EOezxxG96+yUov4qfAXehf?=
 =?us-ascii?Q?950szbcplzv1giXECC3w84PwHODbgVFQi792K2sT/Ha1mQHUWHTAAJip44sE?=
 =?us-ascii?Q?fWTPg3cW2YTHqvA2G9RlOibFYHWZU49iY0e0Psdxf7vEOm+jGVw4HVuBkxVQ?=
 =?us-ascii?Q?cOb6ZR4NdlCKYubukQWFG6ebZ/3tZxrX2dIJr+hzfsUxrezVgA15+sfv7dFg?=
 =?us-ascii?Q?FJkU7jrDmySh8VuxJwM5EJfaaaec+TXdQD2Zw39ldHH2+fM63XZ/yczSLSYc?=
 =?us-ascii?Q?sr3y6LdF6twTQUbkbTicVZn74ao/o4e8muJBVopDCgoStu1JWfbUGuS9v6xl?=
 =?us-ascii?Q?jzj5khKwLczgagyn7hPw1mufEsPTFiMbhTxgp9fCFJhemMRdL3Mkwiu93hPI?=
 =?us-ascii?Q?G3iFBFP6RwkJtKjHGTLIqYxbiMm/ROqb7nDVskqBAd83KxMOMVSpprEBWGGt?=
 =?us-ascii?Q?tcGsf2U9W2avKj4tPyIoB9GrxV42/tqP+AhsoAciPtYS3wOP/mue608bZ7ux?=
 =?us-ascii?Q?vtmGGJnXyONvP+GbX/nhgj+uWIYLZ6qdpb2Qm5H0n/MlmKqa822Rz/8WfGkR?=
 =?us-ascii?Q?j/VzBQEiWWenRh8hud9k7mr99rSIK2h/X1zBrAmolJwOP+84G+RBRYv25tVH?=
 =?us-ascii?Q?IsUjilIFKbafsridg6VhmTSTXpbnZrvWMW6cimK5ja6B/UMHXIydAAMnMN4I?=
 =?us-ascii?Q?s7RSqJEjVq3iPdOWqwt89djrEf/Vf76gT+7YSN7VBQAe9Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FLNqur22hCYw0uix7mKBHlRpRkY3tbw/MyjA3Z0t0nEzfqe5ePO5IalOkal4?=
 =?us-ascii?Q?zR+ko+27GtPlY34e8HbZHdO4yi3CahrImoRwI3uZ4LlUagoK2gvKd0KzzkLA?=
 =?us-ascii?Q?vMyXZEeuq3muJ4LmgQucvXYlJ1c47Qdf93V5UYtwX0fD+t9HE92B8OGF5Rks?=
 =?us-ascii?Q?cXnzyrFJVhIFjl3sJVBCe3P6oatqBsitMqGQqg5GD5Vwc4mRmwHmR2LaAbIp?=
 =?us-ascii?Q?BgI1eHzQ0UYabjRzBAegijOQ0619AEQ8Fc6T5gB5FvQk1GFeGboo5Y8LmTMu?=
 =?us-ascii?Q?9T6k/ISiDMTROZpBLWtQges7Jd1dV+OsEoSNfgraO45KRe6cUu8cXyywphll?=
 =?us-ascii?Q?kowaROENzyEXb+lwjR15I94Z7Pm/lT1eRi4CSSB6POcCNSdOJjNl2Z3WeJvM?=
 =?us-ascii?Q?uW9c82B3qTkaydQThB7gJzp8gLD9JZW+2hAfJEw/MLG8t/aCaFuPGXzMReYD?=
 =?us-ascii?Q?bBp+deAPI9QgJZLtSYqPkr+oCH1g+HssF4j9c5EAaOYsNN5XdRqx/PiwqP61?=
 =?us-ascii?Q?KOBmCWN5eTWcdjpF1IYi4jSLEe9LMyxMXSLartj0DD2Dr90pc9NymC+m6DSi?=
 =?us-ascii?Q?i9pB40oLzqoRTz5GgkXZuHjEVYInTSwFOoZDDgrP5yXDB0MJJLugdTtg7b6e?=
 =?us-ascii?Q?W/wu8i+ujNRyZTTuHqXZLRZ/MvVOsbX7gwuLq6+F81xupSa5iaY+OnMildfY?=
 =?us-ascii?Q?ggczIwm6hzSnm95yIfhCdBcweMpPdlWA0+5YWsJZFtR9Ccp+XDgRk6q8SZG+?=
 =?us-ascii?Q?lUVsD63XeJF4ldoYoQaJicwOUgD0wLhSR3z0kGfVQyciIswr4AZiVGbrF7pR?=
 =?us-ascii?Q?1z3nOe45K2MXymwB008hKAGsfmgfNnLWzuq5Lt0TnUHwwKd4QhQzLiPaPRuw?=
 =?us-ascii?Q?bWbAFuBJeVOjWckR2o3HeXk1qKLRqF00hebla+typkj2kB6uGXAoGixsWLEX?=
 =?us-ascii?Q?00wPReLa+jPp72p0wC7ueg0sCej7t/1vQFPu7Rlm20eHcLEWHwz8SKbOv71k?=
 =?us-ascii?Q?sI/cnozHDBCgIeTGyA6aGwQVJFgs1MHtRoV/8b3GkcEr4ZENLcqJeiVARapT?=
 =?us-ascii?Q?X8dQ7V1jLHhZqKRzgwzM+yFmHYoAtmdkjHb9E91Vu8w5OhJuUFZcuCzkcB8c?=
 =?us-ascii?Q?iePaTO0aa2vTpRd18GjXCkX1O3zEtK7IYT5BI3SRBoZ5PKg2Z9PGLWoLbsAB?=
 =?us-ascii?Q?gfbh77Vw0tS6yumuwsas7M2mSzzX886BPXoIHnEfnxwxG9JvGlolHRq3Ct96?=
 =?us-ascii?Q?j0fZbd1sDL+vNzgzq6VU2btxtbkGoscHZytkJTwiaYMxIxCP5DcYXZZgbnQ/?=
 =?us-ascii?Q?7moMLTlCmJHZJzEIiumcuOw1S6ta+Z5AS/mtmP3iMgstQJAFk91GP3hpCbAg?=
 =?us-ascii?Q?coH2yJQBIXSSc2FVt0/J+bQmU7TGv8TDsp8ItkHj5s2cPU9i6nF8ZpUN3V5B?=
 =?us-ascii?Q?Lq5R0pdE2RPxksUsAogKBESfdfWTF2uHjXJio4sPdzNlZZyIjq8dfXw92xLM?=
 =?us-ascii?Q?SRYwcdTvwcfI855kxs5LLPvLjeJtVdHltbs6vfdH7XH9rt1zw4OJKSxfx85j?=
 =?us-ascii?Q?yVAxI6G1wI15IXPmuWfIkaNt4Fvgly68Vm84mLOBCRnPl1KdSwYN129a/o4g?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RiR1KTM/t+yBtQT0rP0vvwqiWBLu9thAUVCEOdJ6OenQAOv0ma+J1iyxFEk5r9a1jiAxs9Alqzlj8BnNbiJlMQkQIiUUYdTInBgg24U2TPxcpgQM3wjLTO3jXhdxd9CGGvxdSKyE8w0kYUjCeIx9K+smVq+nzYTxcZJSdnJywnK0VY5aVlmbmzGVKrnBR3udb28dfIIK7J/wtHSp5PjFFOg21zFdCWfFG5kyC7IN0qd2pz+eDn6iS0fYt9sk+u7W7KmIQLY1jhjA7YfZZRLZ/seT/vkyvAeRkoPmqgVUuKJBu5Xt2uFn11KSlHcXf/4FPgvS4a7pd6uJtkb9H1yn5fqUcGyenmzaMHp5fXU3bZpc7NBbXgKhAnS3frxNtxVCdltGbS978fYgjJZ/r3mh1Jb6Bxh1UgUw3NdipqZc+R39Qa3x5PM6HVqbUKriHS9pPyV3YBX039eBuEaT9oHN3VFmoCpa9putRV55rW+LfON/sq1YcjWn5WzDo6ITFa7jg5j2/I0tbDVegdSZVn0nJR3c328BTUDWxrNQ8rlOJVJ1PodvylYuprKqh7/Z4kRWFzLTtQ5bRllI9tMJS6svR8/zzKRRIhcOeW/r9vPlUbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a27ab22-f87e-4366-5e79-08dd18bcf50b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 01:50:00.1805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBL2xg2bZaWzB7dzXEu4H5BMLj1trx/QBmRqLBuzP935XYS0lNgLU/1wt79Sk0fGhz/MdtN0QyntAM5d1dEiWZLvzianHr5B4tdAUe6dt/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=805 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412100010
X-Proofpoint-ORIG-GUID: hDEs2-NShFzZnDE6aXeztCsqzI1hu5m7
X-Proofpoint-GUID: hDEs2-NShFzZnDE6aXeztCsqzI1hu5m7


Hi Keith!

>>  3) drop the support for the remapping of per-partition streams
>
> Yep, pretty much. I will revisit the partition mapping. I just haven't
> heard any use cases for divvying the streams up this way, so it's not
> clear to me what the interface needs to provide.

Since the streams are a (very) scarce hardware resource, it does seem to
me like we should have an explicit interface for an entity (whether
app-on-bdev or a filesystem) to allocate them.

While there certainly are cases where there is a 1:1 app-to-device
mapping, as soon as you add virtualization or enterprise apps to the
mix, that assumption quickly falls apart...

-- 
Martin K. Petersen	Oracle Linux Engineering

