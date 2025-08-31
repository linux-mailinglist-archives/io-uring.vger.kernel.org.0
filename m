Return-Path: <io-uring+bounces-9485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE72B3D05B
	for <lists+io-uring@lfdr.de>; Sun, 31 Aug 2025 02:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E75445431
	for <lists+io-uring@lfdr.de>; Sun, 31 Aug 2025 00:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D353E2E40E;
	Sun, 31 Aug 2025 00:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cTKCUQ9K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VQm/0l/z"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540A01D6AA
	for <io-uring@vger.kernel.org>; Sun, 31 Aug 2025 00:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756601373; cv=fail; b=jp5fUn4vFQsVe5K/KqccvE0A67dylkybcoEdtUWFEPWJ8CPxCdJstxw0GbFqlCu0NvS/UKieU4t4Qa9RfuLJaLWz+r7LwaNQ2A3YR1LFexkIcaonzCe2vvqTekg0UVtf2LOxPt1AVLAvkMhVwX7oI/AsHO9n1UgqmwjQxMUa8pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756601373; c=relaxed/simple;
	bh=fmR2q1xVdWimqZ9njY8eT+/R9hkHiIfaBJHQHc3XL/I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZYyx6xGaLgPU1064GT3v9bfVOohfKcOGrwubl6JQG4jQ1OuTus8J/U2tNkWBTCjqpl+jFUczuWZ39rn7gjyVML9JV7MDfsu9HlsVEiPB3lABX812qwgIIDkCKqKcuD9LsNRTXI5lGXOQCguGIT6lpEyA7mslUTFncJEldO6Dmyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cTKCUQ9K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VQm/0l/z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V0m9Nk024578;
	Sun, 31 Aug 2025 00:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PU75O6gC55z/ytpweP
	279Waz/eRA4WTRf9TKD6nEnM4=; b=cTKCUQ9KkaqL3DjJLnJrbJjwuNlrCu02Jb
	zxLfErO1pf+tfBxr/uBK9e/+6rLHFqrkfUfusZtmUDFLKB5dc2lxicUpN3wtLr2j
	Uli1+dmI1BCyWuZpyEg6q41Tp+iIbaNyGRw8Oc7p6tkdMLPTpCJYeXB9fBQBB95U
	qmkxMcA7N24KtaDJXruZZo0NEdEwsDlD3iNTUIUVRY6kAhxAHQLXSuPvSd3rl0iy
	f8SpYYXxY14qaavg2g4fGznJzLjWtrm8scqr9TX7U0mwXmGTu+vp96ncI4Lq6b1I
	ziHO8ouYpGH0MRv3kJ9/T3BxU4JDXU/rwwCi1avaru1abT17Qh4Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ussygk31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 00:49:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UJ1a6T032214;
	Sun, 31 Aug 2025 00:49:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd9ccx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 00:49:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQcDJPPWADZrXgx7JmSpCrg9DCHogTckEGpYN6ex05i+i8CG8YG0Uovbl9FckC2Olqy6g2HJ8Sh7mYcpJmATYROObqBVbZ6zXGjTXFh7u0r0cPnJUd4sh7mhAryji5gs6aeQ3BL6n6B9Zx+3JLzQ4QnUCKhJp8n4nVH8y8yfDwYUXTsx12ZOnZFW6StcjIjSYJ7c0lmLxJ4AXKOk9LqZavmq5r7MfjzA4Z4/dV8n0C4HXerRXS4ZTH1vtymDzaiqis774u75AdG/rEcw1vOo42IzeD9OlLEa9/zMDNEjmstKgV93ZVPyqUvRzrvwADsvmyy7Bf/rg8oarMpjSOgXwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PU75O6gC55z/ytpweP279Waz/eRA4WTRf9TKD6nEnM4=;
 b=Z5ehmKYrndRV8mbLubSux4lkCQZt+DfczWg0Z3c3vZRW2iWYvkYZzZvfCIZ7P+Asg0+x1K+D/1ZSJs9tP/Zhd27V3CXL9AWaSATk5MRdjqKxKLPRUCIUYQAJl4iKI4GEAzoeQ7i1h9II2kK6ClqXn8BBiuWLcI2CH3Sqyc6c6deaXm7ZZqUteu7pESZlBNpzP0q8HU2iFJTrJuu7c6S80umyisNpna7mLO0Kwdiega3eNMktXMeVLRIQFlgERCcVvyNlUf6RHirDtLoWJmX/mRbccJuTxImO9jro8UzTeTe91ehX2Exi6127kbkKVK9fU/oIBuq95l4il51kZcsqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PU75O6gC55z/ytpweP279Waz/eRA4WTRf9TKD6nEnM4=;
 b=VQm/0l/zXaXwMZ/Wsg0BbZqYQl67JCjYD8G6URd3RkpDYwS6j6vcXSG8TiC2tqyveudGGZ604n0hHm32pbzVf/1epXKwb0E2TlF6YjcQXF2lSD+8vrNKE9J4WTyo1v5l0VgSRJ9T080T1d2SXU46aM3O/e4jE2K1FZZzATMNtew=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB6345.namprd10.prod.outlook.com (2603:10b6:303:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sun, 31 Aug
 2025 00:49:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 00:49:23 +0000
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [PATCH v2 0/3] introduce io_uring querying
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1756373946.git.asml.silence@gmail.com> (Pavel Begunkov's
	message of "Thu, 28 Aug 2025 10:39:25 +0100")
Organization: Oracle
Message-ID: <yq17bykgvwm.fsf@ca-mkp.ca.oracle.com>
References: <cover.1756373946.git.asml.silence@gmail.com>
Date: Sat, 30 Aug 2025 20:49:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 668a7df5-dc78-4f99-4295-08dde8283a4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FJvC3eTsa3jcv6CfIJ66Pg42kv9V2BJpFP0/VLNHLvSDrSF0M+EZhCM/Kp5s?=
 =?us-ascii?Q?vAmySC1gzwrk+MgAnzAIQNE26daj/gUZV7O0vEqSdtdTfbAxTpbz5F1Uk/vS?=
 =?us-ascii?Q?Sb6gHkwgM9ICbiBbyQkW3/OqizvbiXBvLYNgIlHq9spul3LPe8LSK78c4Mx/?=
 =?us-ascii?Q?eK7jFZn0vyd88e6bapMKtuclQJknMZELq1494hIZqMncZ7h1xtMbBWJ/m8ae?=
 =?us-ascii?Q?9g8qzbOzqtvJz4HXIxIwMbt7Afd/OyR6vY4m2Ws/HllcNORqZN+QRDYrqe5s?=
 =?us-ascii?Q?f+INSG7hCym7CGZlUlhoxccEjF+h1e2I5Xawac5t/HWzEox4coy/LZc2YBA3?=
 =?us-ascii?Q?Zn8Av5DWmy7QNdyYwUsFZCQHEbd9HR55CeO1BOk1lEOd6bVKPualxnJRW3Ov?=
 =?us-ascii?Q?wwSDGcUhRS3uRMC8L6hP2THEA4DYlvQ68CByzvbbIYx9sNqDm824cJm4SllH?=
 =?us-ascii?Q?78xvtJD7ZZSX0gAkwv63ORjNncfLnxX2UAeG7SmqlLDNM/4CSQK8ORXL7Qg6?=
 =?us-ascii?Q?QqJLEaL/2O5ktNIzfQxYENJp+XphMruA8fffvYbyAcOwMtQT2riumCvsi6By?=
 =?us-ascii?Q?KEVNnXesYR56+m3f7DPtySIJRQ/FXMhIAQSv1H2e0No36SBSxlFV4YBtp1VR?=
 =?us-ascii?Q?VRZF6DLonugzjcL6YLsio4dBkNYk0lHnmv9qM+/F6szUJ5FkLty22dW0gYk3?=
 =?us-ascii?Q?WUh37123xZwBD+yoVEi5c6W46tBWD6uzpvbV1yk4bSdxqd1MG+k1Je+5LduT?=
 =?us-ascii?Q?z12cc6LVstF408XqbnHHnJJ1hN1bp2YFnzkbwU//5ARDBSkDUD5c30StTXCI?=
 =?us-ascii?Q?g8LP9CeK24BAW5dlBX7PbV1A4vpQ2d0/o92XZ5gXH1iMlhsR4C6dFXUieS8l?=
 =?us-ascii?Q?U0x69+TmoPmV2OmKmBPWdaqO3txTzKWg0UBJlty4s/9rNbWS/cKGAZCCH7HJ?=
 =?us-ascii?Q?YKq03AF/NzLbdRPwlOraQW9Sp8QzDsqSgPhbmBtbjAlqA5F76V75G3LX0t4e?=
 =?us-ascii?Q?2G6Jtp88xLbhz3RAn+EWw6Y4J+1mARM43n8YxuVfDdSKMKUL4o/OANTxevj5?=
 =?us-ascii?Q?jj6uDSUgMEiiE2J/haJg44YXhR7wIGYo5NDdfYu9npFwjNlXWt2XQ0SphULe?=
 =?us-ascii?Q?y+AF1Qr5BqxfQfytEuTqGrbQc/qOmx4h8x+Q3b084XBXC94O+RFlKyPP6Fyz?=
 =?us-ascii?Q?G8im/FFLlhvL6ekWGcxza6jcEyN4VeZ9HVunJwW6hDT5pCBEttHIrxTbS9Nf?=
 =?us-ascii?Q?7A5ohmFFumhAtq5S81jo3/AUKBySxsjdLOVoaMH5R9EdIgW4NF4rr1j8XmVC?=
 =?us-ascii?Q?mu9KblghOwd7hKiBj0+StC8EeF5G+8cJ5K1VFZlWovzqszj/QMPkUst30Ffh?=
 =?us-ascii?Q?BZJvL/SS/sRiMQoaJrK6ryXYP9g4VbyUVIMPA9LCLh9Huh0/sbO7kyp6FyyO?=
 =?us-ascii?Q?lKYe6AWbr7c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ao3DqFVQmprCRV6w/39AbiW5+CYDzSJxUmDEcLs6SKci/Zokx2Bdcg5T0Ll+?=
 =?us-ascii?Q?YUo/6XbN7JWQAnx2Xnn5Bj9fAXwKCRJWGFEZmTN/Ua1iLNgWxZSH1lFF8FKG?=
 =?us-ascii?Q?qjEAOYca7gTJeRdpPs7bUU04Vb/IukzNx1eph69Ded3eD60RCxDIp1zGfU+S?=
 =?us-ascii?Q?ito2kzhJM7ITioNY1ToBYksNw4buwwMMJWUZ5i8o4HMR8KFcjL0lx+Vq+H+I?=
 =?us-ascii?Q?aS2GXIF3MnlKOcnOLP6uPQDpwlrIgcOUG4yvI5C0nxqRxuTf2rvvu9aCrLpa?=
 =?us-ascii?Q?+t3pq0O6AS6OuxQHEuWc9WYcbdT8pb27Z1sHrULQsaIu844aOVIXTKi7QW7r?=
 =?us-ascii?Q?L2k6dYB/ZYJcDrUdv97ffk8LQjZC2lDK9qvTqJ1nDSCyJ+5J9u2HbKnkSqtS?=
 =?us-ascii?Q?3e0hdP5hwTZp2w8QbfA9jTCxf6UWYCwHp8pkiPEFD/bvypTW1gNouv29zBUL?=
 =?us-ascii?Q?Fo4K0CUxc0urlB+hQ6us6csRUygMXbXClrIVoy3cIcI5v8KpxU6Fc8ofSQLR?=
 =?us-ascii?Q?nYI+Ra30ETTuwHvtb++LauD0LtftC44lHEDi1VWZT2xWj/2f8jWzSOJvOcoh?=
 =?us-ascii?Q?3MctqlbEuwHclvCm2NMhm6SZxz/99kMBaAFK8WM1Dwd6IdzOcCjv1UUHBcLU?=
 =?us-ascii?Q?e4ompUUCINS2bFq8k0hZUomzcFDTUrE8/OjJ2dH2TAO8fqOR3bK/SYQa56Yb?=
 =?us-ascii?Q?PmoYsgqtxd799N/mXPg/WYTwQeGTrkWEwNNbt0PYwRL90e3UnwDFyl88CuZl?=
 =?us-ascii?Q?A4MEAsbA43Fz9EJmgfOT685WiWQFNrU9EGc2CzOEkQmo7ViplVeG5csNEP0T?=
 =?us-ascii?Q?qLZITQ1F5ihhvKVi2DswlmMrvpWPrZG+sTohxmZ1wRIcd6INLBUCeRgYbqjH?=
 =?us-ascii?Q?pYUjnaiMiwOcYF+rB3AmKmwGo9MeLq0lTsmDwMmMyX9i5YGdKOeYka7VhDUC?=
 =?us-ascii?Q?C7OlVXtEDAV8iaBeCDZiT71Cbr1DMDVoN4QZcX6jCBnRhiRZDllg9KA+lsR5?=
 =?us-ascii?Q?RQGhmDRq8FSz7Xnn7ghK5/jg2TDgy1QdBkZHwrkFJ2TqLPDJczscj40Qh4FX?=
 =?us-ascii?Q?glsluvz1DvogFcwC1EaBCfnN1l9C676rFR4YPO/x9Pgthqi7kvFCtlyCnuks?=
 =?us-ascii?Q?YMM9dnXkVR9AELzKdiJi5FAfvq5EKvRkZmZsPHusD9NT3hMfyMJc3O41+1jz?=
 =?us-ascii?Q?HEg6otEJTqNtR81d3Ru4iKpbjsfMO581b02+Mn/Kfu75TerBiMwhv8/4ivx1?=
 =?us-ascii?Q?l+YEKMCI2IHLzoT5YknjhrvoRcjRgC0w1hbud7bkh3+V4HphrsDHGWX2QjDh?=
 =?us-ascii?Q?L71HKDlgvtODWBWOfDMJfgkM72FZ04zl77X/atU0rMWjjEUArJke/3d/vxWk?=
 =?us-ascii?Q?LsHNT5/MS75DawSPP3CPOySIYQr2Uzr1QUK2h1x7OeAImgOEmML7oPiIPaK7?=
 =?us-ascii?Q?Q+yYdcBPxxLhLOfNUvIcEMg1evknVtD49cwl/1ZaNF+zeOYQiUBHVJdbITXX?=
 =?us-ascii?Q?OqiCHZkBVtt/vibr3b890g8R4TVmuo7Scrhx46j14W07n9l4cVXV9ghi3qWn?=
 =?us-ascii?Q?DeogMQWdQg/wV+z0tHjHyK3qhVyeFWIeefZMvzYKrHGVnOyF3Oxf2jfSgM48?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	De3Hm29DZ7m21AqDi08evzneXEsIBPiAucHaCufxazmn9JYZWZXyMY8M76anwnLKTvF1cN72cmjHSB2ExEr8CkgAelvdLMFxrL+mVEk4jtSP8pwFaolQuP8t1oqomiyfymvBgFlE16yrYyI8BGUviO3KCq8x7obI1YzWhaHA7nL2faOE4uuu81rbbKdxlHSKKYWA5b8CJiOgiZfH+kZkwOFfHIWErMT0aG2u4hcZWDBWkiF2y++8UUS7fnnDUvzrotoftWGVcmWbtSNPOCSEwAQ3OiQmelqUd5V9jNR8PnWis+eiN8CbPTRlFGLe12FosV8YsH3TFgywkkS5ox7+NTEY9yg4tABzGW9abkA0zosrMOPhcRS4kSJT7GJ5AoZV0xRXLqNwaw6e5mWttVAv2yDsoF1aEzAnnnuNjqGTGx0w/5ZycdIRAYUMTamORXNdAf9ol1mwNTN+tgPcosuXDSQePA0AEpePheQEaKJCNM0oHhZVlWS+hc7RGqmkBJwGWHylFoxM6Z/elEouaTJOhKSM4xlIBuNKR9PrMpqzubB4lFA6iIUFCeJAbvGsL3tD2brTl0BCre/Vz7P7KyNhtZ2WUwVq5FvWE9V2SG3Znzk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668a7df5-dc78-4f99-4295-08dde8283a4b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 00:49:23.3069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjHwYbt26IE3Zt9aOaA3IczUcqb7ZDkNhocs3Q9CRVRdCDKpOsBpo46t4MIswrw4zgZ9LsjSRzjKRYaZ0tkLVMuF+ZzdNE+9BWfrb0SmTlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=884 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310006
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX/PNkNf5VSuNG
 NrJYTGV5QdmxNsdnQIiFoBmPJbktBZJev2mW17wIeir4v7OGQmCKrZ6qC3CMlF5r1HzXHAB8rqX
 GuJypNrfzBopnNNy7/DddnmJlMGoVirfVEoHxXed291AkPZMASrtsOD+sxROuXbhPZVH9vVrwm1
 xpxAwzZhC9W4evsMfPCs6C32FFYejPHAvEz2E0KCILMVG4ESTDcq1GN0N1ze1+Scxpf6MZTLITL
 jrYHdqWdezIAInpjEqyrK2Cs34fxlDZncLpKBxIpJEAqpVTIRmkDVlxixRl7uvT5P70IywtHMT8
 dZXZWAPJEOJ5R3hRtEARicQ50t9iql9izI7ilm7KDKcQpXt9QlgK8jlaSkjVaMYRxE8MMzBwC8j
 8DtiuAVj2GSwPk8hjtP5xkOWQbOJNA==
X-Authority-Analysis: v=2.4 cv=X/9SKHTe c=1 sm=1 tr=0 ts=68b39c17 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=95jXlZnff1HFoGILqVQA:9 cc=ntf
 awl=host:12069
X-Proofpoint-ORIG-GUID: I5WCqRBOFBGrTrG_v4ypNUBzu-xbRvpq
X-Proofpoint-GUID: I5WCqRBOFBGrTrG_v4ypNUBzu-xbRvpq


Pavel,

> Introduce a versatile interface to query auxilary io_uring parameters.
> It will be used to close a couple of API gaps, but in this series can
> only tell what request and register opcodes, features and setup flags
> are available. It'll replace IORING_REGISTER_PROBE but with a much
> more convenient interface. Patch 3 for API description.

Happy to see a better interface for querying the feature set implemented
by the kernel. Also great that it can be done prior to setting up the
rings, removing the need for a two-stage setup process.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

