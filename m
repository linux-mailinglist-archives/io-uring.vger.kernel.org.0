Return-Path: <io-uring+bounces-5449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 962679ED6A1
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 20:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0748281798
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 19:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D722F1C3F04;
	Wed, 11 Dec 2024 19:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="drHp1FUF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jGpgHBKf"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7961259491;
	Wed, 11 Dec 2024 19:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733945981; cv=fail; b=G8oEkAUN37FtaTku+C5pLmih5V0oa3E7r6jVLqFZ2wATQclqkawHW2muwb037lGCTxMe5Jdw6OxToOyRvjg3tnOdMDN+mWmrLOURBZo7+ElRqzCUKMjefRpZQXgBnz/2e5crN/lRpof2NPs2qiSohRS9/1VqfO4nAskMZTKU8ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733945981; c=relaxed/simple;
	bh=P1i1MLayk5pPKDzQ4kopV2NwZBBK8g/Bfhox7SVDYYQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HrkubmS22jubZafw6y0vfkeRIqr1/D96OXAJml8fqyy15BI4EQAOcq7HmDSASZZkJM97ikirW6/fB5bWp/WmSZGP3E4AcuR85J5bvqVM81JFHTkSoc4Yhb37HuKoR6hGIKgUv6mBnZIGpoaVpLJDFPNjf0qMh3y27Xkx6YCRfL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=drHp1FUF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jGpgHBKf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBEMqop016661;
	Wed, 11 Dec 2024 19:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qCVwjm5XmeJEQJmqjC
	To/3WxBtj9hlHaxX3lbIDN6nI=; b=drHp1FUFBzjt25I8e9ld1obobqlqxGlKx2
	ALaMZg2FDoP313ESh1U0WyjLJoUBywyGHH3zDkcvHGpd6uOwfFbf5PokHj7qZdeC
	UjC1WziAsWSISpvvDTid7y1xACfZNOL0wFvO8jMiHcXGmZfS+4rt9WFMw9qa7ir9
	s4090A3rgyppJVDthf0/86buWY2Bi1QWGLQoAXAqkKLoU5ItakO2lxaFD+IRt+aq
	Od+Em6WEgwfbgoCEVnyOSCGAAetLWRzj2RWI0CBThV8RK9/uFpBejMdy8kvjZoIF
	OPyycUCk6ppNgzxbcDAvwXWk9SarrKkZcycKu3NAMR1GqB2tOvJg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cdyt1e3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 19:38:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBIr142035555;
	Wed, 11 Dec 2024 19:38:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cctae58v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 19:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p512B3lykd/whyqUPVch1r5eqIpftlqrv01bB4kIlV5Y2xWZcS9/PYzmL9vEb3pvVMkh1nAz47J/KxArKa0OBnKbUt+7mh6BxvK5VZUGj1pNcoIDt8AGZJsgeA7iPp8rtxNGxvGHmDTya/UglFNvHIGaXYt5g9NeYRoteQXP3sBeefYVd1Ugi7pq+eVh0pcBi3F1bFQ6uiO0QzB71dFvXRvy8ZUzbImqLn/qrQPYKutJV9WqyWVYXICPgwQPewu0tcY8IcANXlAUY4g1N7p8kxxznigGslU6JbSePWAQe3xjUYp8cTM7LzTSsbCK8zzVMCN6DB6qZ8TZJ92Oc9g1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCVwjm5XmeJEQJmqjCTo/3WxBtj9hlHaxX3lbIDN6nI=;
 b=TGQLWyaM2n9tKb5VUlpMW8SsAYbk3MrprM458DNtcsemNxAtcDfG4iTblwATWexvWY5MhMIIPkf0Mrri4G+Bj5cWqemh/6xgBsmvrrpdqih8pRmuGxxNz5C6fbt8EsRS75GydYibDvf4yCkZII/DzvnThKZrmyExwFZvMW06IIGY15vWXqeiIivIvS2hAGlXZs6HTxWXQLA5NwDC54547flbN+I9Dv8HY8cvVeHUmYbbZ7TVeQ8HHGLZGzZ/LtSv5Bfg6N8pyALP4aeaZKkFBY/F2phjW5ndK59TOHoBEBPLg9CKiCqfVp2HPqAOObBanwIO8MOw4pwT6070wrpUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCVwjm5XmeJEQJmqjCTo/3WxBtj9hlHaxX3lbIDN6nI=;
 b=jGpgHBKfvSvguOlUmIWEY1gBL2Ci0ilRJt3sz4VkE8/AuwJ3FRnkSAq7taO/paSN+x9bY5xN9uBi/6L1W20ePN//VBte/W0ODi3r+N3DcofERSg16Tmq5XKQWuvcDQn19XOXjubEe+K/PGi45bqU2J7ak+XU6v3gzOYcqxjq7po=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW5PR10MB5762.namprd10.prod.outlook.com (2603:10b6:303:19b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 19:38:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 19:38:27 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nitesh Shetty
 <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <7d06cc60-7640-4431-a1cb-043a959e2ff3@acm.org> (Bart Van Assche's
	message of "Tue, 10 Dec 2024 11:41:48 -0800")
Organization: Oracle Corporation
Message-ID: <yq1a5d2gi91.fsf@ca-mkp.ca.oracle.com>
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
	<yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
	<d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
	<yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>
	<7d06cc60-7640-4431-a1cb-043a959e2ff3@acm.org>
Date: Wed, 11 Dec 2024 14:38:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0046.namprd16.prod.outlook.com
 (2603:10b6:208:234::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW5PR10MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9d3d18-4134-44a7-f78d-08dd1a1b6233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oQTdmfYRm/K6QUeiLcG3iqDFO/SiIEzZPhP3ITtZr9Caf9Aqs7SPXxNEpZ1A?=
 =?us-ascii?Q?K2d3KCvh0wxYnn6owr6HD1HiFX+x022EzzdNdcCKetnzz0CerBsWTIhG7tuM?=
 =?us-ascii?Q?WR/Luu3rUAaZDGUz7esPBf1CWJCcKYC8agEm+O417Fq7ISBYoRDmTLzvVp+p?=
 =?us-ascii?Q?AdvbXgwQZ8ZRpgwTyrm0FLgwBVZbVwvavVZHOAo6NwpI+vwrQTeScOxpsas2?=
 =?us-ascii?Q?ryT/pZqYW/YUuav1rUnAXlP1qd2kuzNv6KjNuONR255N0/VkLUOiOXYBvKtv?=
 =?us-ascii?Q?VLdpc++pEJ5jl+oXIoPI2M2+2lXplhClx2Gv4uuISxxgzhvwIbFcN/lWXwCL?=
 =?us-ascii?Q?8okgTpNEXsnvVrYDhlkKKsq5mY7sSuaNXh9Qc8hcmSW0bOrEgwK4jWmGvxLw?=
 =?us-ascii?Q?yaD2ZNrvp+owmrTDavwYUn+w1WYgP3CdsvW+5bb/4YJV5QMYHD7GMK9/WbaL?=
 =?us-ascii?Q?6cR0qNYSPHJf1XLbAzjJ+NheC/R1rH+qRbAfnV7iOtGRXte36KbkLExslUob?=
 =?us-ascii?Q?xImlPs8NiYxtvPvv3AgVb9JFDZiVtGy4UH5ZM4EnhPEAOJakQ4aLWUCZSaBc?=
 =?us-ascii?Q?XnmiqeUF6xZL4qIkzPynWkItafBOMVYpxZz6NxrnJqrz8lrmJSATPlfXjlWo?=
 =?us-ascii?Q?RuA2M3VrTc1W5nCmVchUqQn0NHfxIksJWi6SBf4fo4DwiIzZezyMvy0H8kP8?=
 =?us-ascii?Q?0b0aorQ4zFcUumQslXQUoDFaGj+9+eogQLQh9TO71+boQQlStjcih31AHwGk?=
 =?us-ascii?Q?goUuNElnzdg0jRMWc54HPOiwpSN1M3JLb4TKjE8OodeYAwUOTto0fRmqZh7z?=
 =?us-ascii?Q?RD3p84rtOPDxEzf0JZeHACvZVJYbqr2aTbm+9hOMNYAANTVW9Qs4o0vjKBSK?=
 =?us-ascii?Q?+EoqoVZJ3OTR9q16XUz40uCvUTjXsLYUcT7jimT2JtlmQUKexNeryzISWCTK?=
 =?us-ascii?Q?sJzHoX1S1w1HJH6zjMuQy6jNpS4Rp0RyUGuTYf1LII5XO4n375zdl0PeRV13?=
 =?us-ascii?Q?W6GVtPHXo2moPXX2u4NsWc8hejJYxDb+ueln5pWyzLH72PLcIFRQT5wlNgHe?=
 =?us-ascii?Q?zf7C4xRKFjtYag8lD7r3wNPcy5r9hmKX4WWmOJy4JweQJR9L59arS//xQu5k?=
 =?us-ascii?Q?DejkNWqX9R9k41ze8X8M9Xq91kZNsw4WlhRyBDeuyzdvZcQ1EwoaTUgGvyDY?=
 =?us-ascii?Q?NP4gp8LdzoX5r1TcAQ9fL0ZbluinNlGJBCT2G1Kx1ofwJ9pndVhZEreixBcS?=
 =?us-ascii?Q?44F5/oKoWiQYuHMsHmRR0sKZ/3QRX2RKBymfvoRkpZ/J6l77dV7JSwmyLRUU?=
 =?us-ascii?Q?hknlC2JtX+jSM+2OSxhSa4P+E2qflHkZjFniFRy2HtDNog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v0kWa3NuxF1k2ZvuppW5bduIMe8SohegSPx59F7vtLtzstoDzvcQA5yrnv9B?=
 =?us-ascii?Q?OqtQZYcjJ8wc9egU1EUXZYc7tr5o2Q8BCeTg/E1+jrbSxgkYUu4qbWQExQh3?=
 =?us-ascii?Q?hthEpqhOXwCwPWBy+nJblAiSsGsys6CDZ/nwBthEvTNH2C3y98Ycc0l9Y/aF?=
 =?us-ascii?Q?hHeYX5oGiLOrePO7OGTF3AmHCCyw8KFf2EuqIRqWCZCmp6NJp8sfC5ftJOzk?=
 =?us-ascii?Q?8Qpc1LNANukwAuJGlu8JRpHdIrSeM5LfWbVg4bunXkV7ekx8zVXo7U9LDv51?=
 =?us-ascii?Q?pwINB08rA2iu/yna4jPIcIE90hJJDcjhUoKaTDTBgEHCt7pz67V0OhqNpD/Z?=
 =?us-ascii?Q?4Ob2dEr58pUDhFwuWC/xEeFlZJW0yQzlX4dOHlaCcrA49oTPiim0GACTDFlA?=
 =?us-ascii?Q?S3kVENNy1gkah0Af+bQVd1l27u2kwEq8Dq7GX1kNojr0G2wRXQbsEcOKFCnn?=
 =?us-ascii?Q?xXfxK5AIchDBfmsc6O+Xxclg2pghXgPL/a9YJJPwmcg3S3N2sVYVXmteaDnJ?=
 =?us-ascii?Q?uyR/kiwHY6alC0Q+iKy7WgJ1VRCTRX0wpPg4EN5l4pqP8bRv6lyZMfRF2dCj?=
 =?us-ascii?Q?p8o3DdZIzoCTdXuKgnCdXlP+Skdibiy6fQKcpV6bxneMi9cB3fBoKWVsOh07?=
 =?us-ascii?Q?y4RuX65zwoq/8dQFh0gNxFQcUj45nw38r0ync108s5E29ee9acZwvaMlGTEM?=
 =?us-ascii?Q?jE5ddMV96WRU4RdbM2HoVOx/NhE1YUzjsTizYD2yyc0tKS2jCYfzVX4pUeIG?=
 =?us-ascii?Q?3ikyzgqnccLl4Kd65KsmqAA0GShPf7ZUnlXaowKflVf6qnQbAp0rO1/lQ0ZV?=
 =?us-ascii?Q?ncVIYB3WxFPs/12LhPmv5RJI5CnafHsW5An+gu3hfB6EnQPwTw6RzopPhY8i?=
 =?us-ascii?Q?hDH+1fAFw7mOEjH3QDPlG42QYZLhkrb1kJa16Cw/rB8e3VwtENaTqx6x3fEc?=
 =?us-ascii?Q?jpKyPNht96HkhFZ71RqRrwGsc1yCGDdbjcS6mYjMDFN72K76kNAqzLul0DwP?=
 =?us-ascii?Q?XbT9+yUwvamefqqsTffxHtzKQ+X5bc2kNNV2cE/2wRuowqMXRbpzZd93yGr+?=
 =?us-ascii?Q?XBQUNh9K2lyUx6RT4QKMnj/T3BX3tOPJlJfo62jCcij4dGxfoXo2xcpvn9L5?=
 =?us-ascii?Q?97tDbdGNYEV/c4pPxWaZ8p3FCE+ij/XndLTJE5KBQyZ0uGzaohT95b3BJY8J?=
 =?us-ascii?Q?qrydDVZJuQl9DRE3OwUcmJFfJvoo0qWiozhcAjjbGwWxVp57ITXkkr4UC8CF?=
 =?us-ascii?Q?4GzBr/1PDxDdd57DT7conAzgsO6y8lBk+UyESp9zRDNqcS7L0xEvHa5OSBYg?=
 =?us-ascii?Q?t+Y3/XrV7X7dzT9sb03S6FtfIB+B/2QeIpfgvVd/TsoKMCH2TOwqtQrqdnRd?=
 =?us-ascii?Q?bEz4ZmWQBzIoEkdBs5paL6qH4E5K/FKfDAR3Zp5sF1uthTo6C9eX3EbTfbUl?=
 =?us-ascii?Q?eqMd0fFps5tZrK2DKZgpeEAz2UTtwyS6USRrbLBAVasnaiuBSJu7ivJX61Sa?=
 =?us-ascii?Q?VUk7QUvxlOAXQIJg2+ELwgS0AUuW1kcN8QRjx5jQXmZHF+IypEzI8tkk5572?=
 =?us-ascii?Q?19KtOx1DMmrrkp6H2wPEdMMLctJIEU6zKTwBmHSXs54PcYM2T4OQXM2N5QID?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xIjtIZNDpqwr8l0EB7DP8rhPmxqzIHqYKqeJZhx4YdqMgOjbAaBnda6aTW5mjMXTE9wCwJbZqaeVFAgwdeKTMvucqnle+F+s/wzPjs+GpMlZiGpcNAghjk/4ESUxtkkkixvNFLaVVvNGDmXomD9AwoQs6KgmFYxzsWIX32nOaWNtKEaKcPjVAgj5Y2u90mUewFfG/emo2ro5aAFx1Qdo+KB4SaLQcQ5XhofCV1Idzq0apROOe7zftvqvC1EhAgRrHXKaxOmGf/Yem5Wyy3VykVOLu1e9hUMV1SsP0JTOq9pBwVW5CTON6SYim3sfLdNBIx/OjW/mwsNnypHhR/Pmb6MC8EIrySo0bkNEjooH63R+7/YfrcBt9nzAb/ePS6Wg1lC2NTaFcf/XHAAE2q1Q35nAJSG49J2shB5AB34VVazi88+FVB1QxpHFZAkeKaoNgDl83QmDhPRUYHe7dmLAv4jbGaPUnYbadKHywQ3t3BK+2ht+FdidyWe90VmbjUu18cK1vXdfExZvE/yUN/6aAWCNFWYW0VzNwGNq2aC6AxrhnhiwMda1xoSPU9ibX34Gg88uB6Pj6jqdme7O1ThO1Lj5Vg2ikP6WG3KaZdmvsN8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9d3d18-4134-44a7-f78d-08dd1a1b6233
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 19:38:27.1909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QCQjPkbNe+3xgneCr1b/a3qFb8K08spkJOXpT+qYyejy5j238MJIn/6K66TyPrHncbh9w+08XetdW5aqgxWEd5b8qQ0S7PerZocEdj7Amk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5762
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_11,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412110139
X-Proofpoint-ORIG-GUID: lrZRQsz7-t6nrY16sSWUtiMQuyjXWRsd
X-Proofpoint-GUID: lrZRQsz7-t6nrY16sSWUtiMQuyjXWRsd


Bart,

>> What would be the benefit of submitting these operations concurrently?
>
> I expect that submitting the two copy operations concurrently would
> result in lower latency for NVMe devices because the REQ_OP_COPY_DST
> operation can be submitted without waiting for the REQ_OP_COPY_SRC
> result.

Perhaps you are engaging in premature optimization?

> If the block layer would have to manage the ROD token, how would the
> ROD token be provided to the block layer?

In the data buffer described by the bio, of course. Just like the data
buffer when we do a READ. Only difference here is that the data is
compressed to a fixed size and thus only 512 bytes long regardless of
the amount of logical blocks described by the operation.

> Bidirectional commands have been removed from the Linux kernel a while
> ago so the REQ_OP_COPY_IN parameter data would have to be used to pass
> parameters to the SCSI driver and also to pass the ROD token back to
> the block layer.

A normal READ operation also passes parameters to the SCSI driver. These
are the start LBA and the transfer length. That does not make it a
bidirectional command.

> While this can be implemented, I'm not sure that we should integrate
> support in the block layer for managing ROD tokens since ROD tokens
> are a concept that is specific to the SCSI protocol.

A well-known commercial operating system supports copy offload via the
token-based approach. I don't see any reason why our implementation
should exclude a wide variety of devices in the industry supported by
that platform. And obviously, given that this other operating system
uses a token-based implementation in their stack, one could perhaps
envision this capability appearing in other protocols in the future?

In any case. I only have two horses in this race:

1. Make sure that our user API and block layer implementation are
   flexible enough to accommodate current and future offload
   specifications.

2. Make sure our implementation is as simple as possible.

Splitting the block layer implementation into a semantic read followed
by a semantic write permits token-based offload to be supported. It also
makes the implementation simple because there is no concurrency element.
The only state is owned by the entity which issues the bio. No lookups,
no timeouts, no allocating things in sd.c and hoping that somebody
remembers to free them later despite the disk suddenly going away.

Even if we were to not support the token-based approach and only do
single-command offload, I still think the two-phase operation makes
things simpler and more elegant.

-- 
Martin K. Petersen	Oracle Linux Engineering

