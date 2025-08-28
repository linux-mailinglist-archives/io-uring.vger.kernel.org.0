Return-Path: <io-uring+bounces-9405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA6DB3A4B3
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13CE5362017
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 15:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863DA24169A;
	Thu, 28 Aug 2025 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PBsfAUl+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KuSOfHTo"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C5220F3E;
	Thu, 28 Aug 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756395538; cv=fail; b=YXldbLthk1nps5SWvXeP4jUUqHRLLJf5iKfnfaYhLG1oXuJbuZPqzVE3IcqPf30iztSjl8TNkGLBJE+HdEr9weBUB2saaSgIYizGXMSEcruaxpZwhI4JLtev+snCHf0RlJburVR/B4vAiwN/gTERaoOynvbjXfJXopP8U5LV2Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756395538; c=relaxed/simple;
	bh=UNL9qOAMPdsUPUH44mHCwpuz1gcAr9y+nn48Ir+/r3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cc3GFNUFrMZ7BCyJC9APJOeRHcrWQ1D2e1ofQE+uwKPup13Xo4XMrey08BZvPtI9HVMpc+h5nshbMYYnzIh7kdk6+UBKr5XwYJvWAecnvZ0hfGW8Yn8XDnisIs7E3U4I8rsDOpNbrEUkZJIPEcqjGITUFHqKl/Ii0zoVZjbJuYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PBsfAUl+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KuSOfHTo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN49k024014;
	Thu, 28 Aug 2025 15:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ND2gbL9Rqwhi0GLYSo
	uoflbQvyoYSfX5/2V7wGdJNps=; b=PBsfAUl+Z/PIrSJE7xwdY+MHTMEgsedYcP
	uQ3C9LWF7aFWthAr47hYYpFqQXBjiaROCu03vMNHnbq3uehoI7S8nN6/eTiisH5O
	vMpzaHB9kRSnEFSuELIWp7FKkoN3Rq8NADFT2v+x6/MhBDVd1uc86hUp+K63Z24d
	OwBerKCeVA7pe/OH9itPPlsrgjrMRrIg8j9cXcM7ABjV8JV282rFv/okRnBNJOEU
	5gIpF8r79LDAvTej28Y0H3V12OOte94VhX64QLbvYPROMPHjKNBSYsLbZisWOwHW
	JfqMUTa3uVcsWSCY3gJXOBXwPdLZPDrL4FywsiQj2d8HQ8g2eW1Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48ervnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:38:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SF1mRs005003;
	Thu, 28 Aug 2025 15:38:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8c9kpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ckcotqVTYOIu66II0lsteT6z6jB3psqs8Q0ojSyK2Ab2tisjQZsUDexCIMTKbn9WcYAatwatEysoDH/7sbz7ybz+AOIIaUgVbXhuBnNB5eCZjAWn3hoZqURE10b8KgmjDldpk5mTUcUuJeDphyY77POUQTZEGul6S1Cp0MBuf8y7G8PZQnI1+/kfZWXBYl3GZUiyqyjkBQVWdnA3qzHVFLK22TSH622UXNjFX0vRxTVxXc8ZpxCEZVsbowZR0hg5IjNvTqor4qB2hG60p9ycN0KnIIKGHaVyg7Gwp48Hs6tkVXk1B2V9e5Lpt+YpskC7igYTGFNstToz/EMSnPe6Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ND2gbL9Rqwhi0GLYSouoflbQvyoYSfX5/2V7wGdJNps=;
 b=bjQcv7qB65Rucc45/AZLwpZmpj9sl5TV5k7kjwYbchUqP9Jl/6IndbFaDIoyiy5uuxKLqN+O0dJzkxxakoTIzQRjZ22k7QiTU4YHOhzaC5JZaq2PH+vLkivaFLq9sFyBdWVvNVwnBkFJPLfwIWcumARI92qMg7dIYu0uuqIuY32vXtkp1m9ZVN6z8BcH0VlTgWwjmX3X2lLTlGns9btqPZWnghroOPL1nO58+T1OZegbvZ6RZDktm4GAju4Nd8GClnV79b64R7n0d0FCTm8OifRDx15jGDau6WJ2UKk2Fc6SERftGqNg2A2traJYmrTSZUP4WB+v/XrRPvXWq1BNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ND2gbL9Rqwhi0GLYSouoflbQvyoYSfX5/2V7wGdJNps=;
 b=KuSOfHToZezeLl17GF9+VChf1HZJ+J4uRoNNxYpYbMdBPm75+q3o9niho6JhbYuYiZxnC3jhFiIVmuFql/6iRXLaFaJwBT0uGHfn2NhXH/vVVmqQ88IrcRqbIXzdnqSU0lm8imjT44d/dZODVZlereKyBxMgZtU1xmsAW5wQNmk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5921.namprd10.prod.outlook.com (2603:10b6:208:3d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 15:37:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:37:59 +0000
Date: Thu, 28 Aug 2025 16:37:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <cebd5356-0fc6-40aa-9bc6-a3a5ffe918f8@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-14-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0675.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: e64703c1-7fe5-483f-84fa-08dde648ddd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wHQSSRIy4jLm4LIhLg3ZCjDd+Jge9xDtwixggLdQdwF1KzoW/nLxFr5Ckzl6?=
 =?us-ascii?Q?4vFW21KyyuIHeeVLQGpTineixwcKiSsR7N6DWeBz//FGSHjgKohioDkeoIjj?=
 =?us-ascii?Q?o/JcWclN9l85J7UCrQ0C9dNAyD8rexKrilmkfOL3ZxcrfVhySf35qK6FnKVL?=
 =?us-ascii?Q?KDxwSslGlg69SMHclwW8w5514IESG9rBq9BBMusJgKTBDzfbwxZkp6FTeTsm?=
 =?us-ascii?Q?mZhMpc7uAv4T6FutK/vq67rz/JSsRgoufA6cVn4nmXipMEVBYqkDTvCZ/ysC?=
 =?us-ascii?Q?Q5zFB+3/rH9oLuRhroMJT8UVyvddb653XR1Ny2qwNXB8hURyY+PNH4iuv974?=
 =?us-ascii?Q?ps1nCu14LtfCYtTiJa9bB/4E6+GOAxKiyk74YW2DJmRRNFF39+7N8K80MYpo?=
 =?us-ascii?Q?LF1d1Mc1vG8sNPjuqiKn1jFg1NZnc0n9uYPdkxazi/j+SBXKbuv/C27cQ7Jh?=
 =?us-ascii?Q?WdiZt7BExiFEpzr2v9C4LdbFb+nT2Bn8C16KOrjeKwpw52lhp7eSYXs3o/t9?=
 =?us-ascii?Q?yM5qCghXrW6C/DQ06Y2RmuxR+3n7UHPKSeqCj6/rEDSNxBlmyCfmLDT87NqA?=
 =?us-ascii?Q?YcbUNeFVZSCOQLEOlz12Vuk2F+sF+Cqi93XyR2XDxWIo72I5lAW/OXUlr+cH?=
 =?us-ascii?Q?nSZJgKRAwp0NqtozyycgmLjD8wIxlLdTWv4gjTjuuwK1OYH1z6Q2TaAAN7fv?=
 =?us-ascii?Q?JwnAIgngh8HNraZ5z5u07wXBN/EuVMFEfbwLJzlQBVyDfvexl0+ytQzXApOT?=
 =?us-ascii?Q?mPd5rZREnk9/V/yD2dAUQH6gNLgFeNV0StBxhVa1gDsjbWM8khc/SAeLgB89?=
 =?us-ascii?Q?3JEgN5fDDW/YIy0V/ZfAJHeOgMgL+T80jCfKbnMAigtokDiDGMrUaFhPD6mI?=
 =?us-ascii?Q?MkRjiFHZumqF4uujf+q3sNNxjihb/yOyiRx0wXHExp+Bw7r1QaSjSj94Tmg5?=
 =?us-ascii?Q?zLpIkd4FbKoS4ylSXUURAsTEMiXtkjPjhwGfhfSLw1UyxOYIEbsOxVZifhOK?=
 =?us-ascii?Q?Muw9bEmPW9+/O3Jm8QFJi2UejLRJ932Gqwbd4lcMutva56aWRhDSNZXZhpnM?=
 =?us-ascii?Q?6MUwnO/rBqrgAIRdD0AkapB7Hb7YgcrnjH4Tn4nkv0fZnCagUe8dsBxsl+41?=
 =?us-ascii?Q?JIvBd+FcfF678e8wgVgOJNreMUzhDtB3Udf702rXe4Uo9ONjzikPtmTsCpse?=
 =?us-ascii?Q?7eo6JJQzBynGsk5bWW5AC4PiEq+iy63Ax6ylXS0YMS09eOOO+d+D1yLORRpG?=
 =?us-ascii?Q?7HuLU3boDJ7HiIeAX2hBYZ62FX8QTdrEu+q7OhIaSIGMO4IeokOsezmpsV+f?=
 =?us-ascii?Q?9IPsjFH/hX6PHEhzFSupZpLNec/zQzor1Gvrj+HsqRjBUgWRb58Up8kw10yb?=
 =?us-ascii?Q?TyPses3+qDd8xsyXWH3Crarfyl+cgCfxpJONorEBEAIxoeN1bA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gUThK5u/7NvLJOFl2iWFVJWT3+UFwDunB/kUSbUAB4H/oKOdUNJ2yW5/t2m/?=
 =?us-ascii?Q?1HqYmjinaiWqhhjvg5nvwW23363N8vaMaTu/X26P6MweqdQ8lSv3FxFqJxfp?=
 =?us-ascii?Q?bp/kULTYHflVsUdbMRJHX4WgAMl4nzHjPRw/wXSXVKlozO5kG/KTHmS0Wdrz?=
 =?us-ascii?Q?w72xV9g0i7pQuUdUusHgxK5PnVS2CVmnORiWKbWm5acd1RaYLJJH1F0I5z+K?=
 =?us-ascii?Q?zOx5FdRnMtIH45lpSSh1f/KTxwXsC3w+MxnlzMTcN8PsbwWhC4OfxCsj50ol?=
 =?us-ascii?Q?U8/US0cA0fAdscKtq5QaG0/bo7Kf78WPiPRVzIgZzDO+hU8FYxV+TDZ3A0g7?=
 =?us-ascii?Q?WE+KYIV3eDY5lDM0OMOkQYUq4DZTMbwSr5Qk48hzPXTtKCqk5p7NsZnEinXe?=
 =?us-ascii?Q?9/GAomRFGSC9gzOYAjDv2IaiB/9Go4pdz/WX4RM0qoO6c0c1Hmwc8hsurwfT?=
 =?us-ascii?Q?d5/nbukBIC2D0OQNBANNEmJsHKoTinXeFZl0PO3DGLONsvR7+iDkt9VcpAx6?=
 =?us-ascii?Q?b/SrsR3F4xAtcwoXBItrEjL5ykiIVWcbiv2X4Lfl1xybl5FJ0zN8W6rsGiUv?=
 =?us-ascii?Q?ynLUxwZLa/UApnAIbfQB1MwxE46VUNblaYLNUfy/jpB2bc01PMJWi40cU54P?=
 =?us-ascii?Q?4vzOBuW0P7voyFUXniOtZY5U9BBMD1prvwsgYFAxIutmBOd5dzVe4tXlFN5H?=
 =?us-ascii?Q?QEWZWdb86Q2tGNYkQyFic7lBbAN7qavnexB3x/1DyqYSPKlmbEvAoN+F6bxO?=
 =?us-ascii?Q?+fLb210zaXf0X9XHN00IkBfgZB71RyVaY0ax36CBanh5BQd7Yww5frSUk6Al?=
 =?us-ascii?Q?1Z8TmMDDz9DfAqeK30xNClnMam+nPqMYtauChQp2BeM0dy9d60tya1ZdzaPN?=
 =?us-ascii?Q?dIkJkEFSXgMJNZl3OoYsC0IrRMNWK4bVJU6SrPJdhAeE0cbiBy3zzXuMGSyo?=
 =?us-ascii?Q?BBaogUUwkm4wZ7VWd5AhTnyDdjzx8C/Rf4pt8//H/7+7af7BSHeEAYK8d1w6?=
 =?us-ascii?Q?Awcluop2wJrHhHFk0QTIooGMmFG4Lwib1UyEEV3YwJqVLeU5O42/aH2T/X79?=
 =?us-ascii?Q?5PBxXL1kZWkmDEQwHFm2FH2Cz6au+NAgzzF7cOE7izDNckYBez6VnATdjJev?=
 =?us-ascii?Q?tkfGmCmxBPGMGP3RcpLUmsA1DBlKzzox1HT+3DFVkMWJPHynmBxLV+g2m0jt?=
 =?us-ascii?Q?eZi92Fs72izCWm10o3VmqR/2nMMHTVPPrPhDdpOSxScRMcZDzesPyQTFbZqk?=
 =?us-ascii?Q?aXq9plIGpW3P7/2Z9mtrGddZTJv9thi6tupeyHdcwebvwm7EZEcMJOWZxWMs?=
 =?us-ascii?Q?4yGuf0PrW2H3owtJqEoVEY4ER6o5xV1lSUWVufBjYGGNMpz04KMqF2l/DeSE?=
 =?us-ascii?Q?R49uLrEVeKPDBzIGaUIbQMCoHpyB1S+Ql56vs4j1vvXGJndazDb3FwC7YFbF?=
 =?us-ascii?Q?msYcna0+CwxTX1OP0UW9pP/mAEcFR6JEGVZ/tZGLH4g+0vqCPs1vIgZIPeC0?=
 =?us-ascii?Q?Jgl5Pcf/xRaiVgt6ztdYDT+s/us2IDbHWjpka3k5ij2ywdIaMmK3tkVDrvMQ?=
 =?us-ascii?Q?jfoZBBFDny+llvcIUzfPzHRstn7Foqz3zz0hsF/eOa1MNThhAmeNQKnKsvfW?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w87fMFwQcfp9ZmOcIF4yzZG+F3FV60tqP+tfYJZVnyERaenYikoIMyAXwvPemX1K9b4LmvmF0pl32L60a/LSNGg7ugiGTCERDIoUO5qPTf6Wle1i9NUhUKQv8X4kYf34kpSA636g5JnB3fECzNSIjkAP5yhFPXtQIZLQ43I5nYqKmDiNsNH6R6PXDezTNLbqBLs4AaVgk/He44N1p7CHPMc0S3G7VvvPP9yGwXlkZ3KZQqlg3t2Anv6TzZ4f7tJjJR+x52TCOlwhXYcQDfFvZbLZoHMNkqKD8FZsly8FiF/UeljYdFtc6yGuQiQiUYqYRDw8BUD7nr2Ocgj4TNNhQQv0EAnN7fdXmeWCZ/lbadoJsVirciO42jGiarBotmTSTlI2RyrlUCfQzcSnEG3oEYYS8/uICGY/guuA54zi++YQK6mMbXSvuXvmGqhZwCeRQZtq6gHpWX1W68cSdfUnmENc3wHxSCVZciJ3H7cHx3RfbCjKAaw9aheI752MlpZPl3BC6f0z+OGSVwQmTNJ30ScljRVNUYfE1g7DK9XhJh6gzM2CQ5eWFrKCBu3HiMqxmxI/x9B7s2sNbePp3HV0cbjIXuxvBErjOWu366bZCos=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64703c1-7fe5-483f-84fa-08dde648ddd5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:37:59.0912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Aik50dyldEMvx4QJo3+EVLd9Z/De/v/PtL3fzwPhqFB10F/TsDPJL+7s+Egu2eTtcFmjDzUca1eIwHiCvDDMqNti0MS7oEQ+WmEJUgf8Is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280129
X-Proofpoint-GUID: AtCtxRj6YTv5_vEnK7mEjffz1I4h75Vu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX8ilB6xE3nezT
 Vv9Uii2NtOyGARgz96llUi93MsVLFHQpCM2bdF2akRNVdLyIRTLyBpFhSqcUx+2YWb2QUAY5FGk
 tEOmiL8LsT4QCX8vziNbJoRIBTuUda1sBMeI4dpgY40Ag5okQF5LpMJFwrsM7KCPrl9yQO9hdne
 P9gm0SOV9/S6VKS+/Na0VAEOUf/Y6yjbuVqJJv5Uys9+Y9QG+8OQNzoaoOiofF0YbNuSDn6Y/NI
 dPpNwitABa/gRfCTEP5J0GZCo+PMUxgs6oztf7SLUTGBV9pLjZPmA5YVzK/6Wi8C7rwmRZaA84g
 ZWZSXuFD4Ce85i3zsllqIhuoMsDef9TIDh/wVawesLpb0B3v1yzr82NLdThoA6brden2/fA4/Lg
 pjPopYYPBJdig2b2Qf2RZ4T0htNyxQ==
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b077e0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=gNetrjGkTYvpCEqV3pYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: AtCtxRj6YTv5_vEnK7mEjffz1I4h75Vu

On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
> We can now safely iterate over all pages in a folio, so no need for the
> pfn_to_page().
>
> Also, as we already force the refcount in __init_single_page() to 1,

Mega huge nit (ignore if you want), but maybe worth saying 'via
init_page_count()'.

> we can just set the refcount to 0 and avoid page_ref_freeze() +
> VM_BUG_ON. Likely, in the future, we would just want to tell
> __init_single_page() to which value to initialize the refcount.

Right yes :)

>
> Further, adjust the comments to highlight that we are dealing with an
> open-coded prep_compound_page() variant, and add another comment explaining
> why we really need the __init_single_page() only on the tail pages.

Ah nice another 'anchor' to grep for!

>
> Note that the current code was likely problematic, but we never ran into
> it: prep_compound_tail() would have been called with an offset that might
> exceed a memory section, and prep_compound_tail() would have simply
> added that offset to the page pointer -- which would not have done the
> right thing on sparsemem without vmemmap.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/hugetlb.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a97e4f14c0dc..1f42186a85ea4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  {
>  	enum zone_type zone = zone_idx(folio_zone(folio));
>  	int nid = folio_nid(folio);
> +	struct page *page = folio_page(folio, start_page_number);
>  	unsigned long head_pfn = folio_pfn(folio);
>  	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> -	int ret;
> -
> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
> -		struct page *page = pfn_to_page(pfn);
>
> +	/*
> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
> +	 * so these pages are completely uninitialized.
> +	 */
> +	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>  		__init_single_page(page, pfn, zone, nid);
>  		prep_compound_tail((struct page *)folio, pfn - head_pfn);
> -		ret = page_ref_freeze(page, 1);
> -		VM_BUG_ON(!ret);
> +		set_page_count(page, 0);
>  	}
>  }
>
> @@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>  {
>  	int ret;
>
> -	/* Prepare folio head */
> +	/*
> +	 * This is an open-coded prep_compound_page() whereby we avoid
> +	 * walking pages twice by initializing/preparing+freezing them in the
> +	 * same go.
> +	 */
>  	__folio_clear_reserved(folio);
>  	__folio_set_head(folio);
>  	ret = folio_ref_freeze(folio, 1);
>  	VM_BUG_ON(!ret);
> -	/* Initialize the necessary tail struct pages */
>  	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
>  	prep_compound_head((struct page *)folio, huge_page_order(h));
>  }
> --
> 2.50.1
>

