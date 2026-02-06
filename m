Return-Path: <io-uring+bounces-12083-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eL4XIHg3hmmcLAQAu9opvQ
	(envelope-from <io-uring+bounces-12083-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:48:24 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B5E1023CA
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45203306B098
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 18:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28931425CD0;
	Fri,  6 Feb 2026 18:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FfjusHjY"
X-Original-To: io-uring@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA809423A92;
	Fri,  6 Feb 2026 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770403082; cv=fail; b=YIbawi6KbjgkvqA7Z/Vfzkhg7D8CFrH1mgZsCvLsxyoagPySTMaMin2xiMpq2Btjz5ClO59HSRbBoBQTnB4YxCwIlQgpsnK/i2c/i2y9JkXG1gh54/nUiWfsZoa2Q5Mfr4h/P/gKeddErHcwO/Qh4vi9bdAT1ntqnQpwI1hlx2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770403082; c=relaxed/simple;
	bh=85TM0Z6SP+1IN0zA5vMPGj/AoIp4XU+ieCUzyLnsMnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SjZBqHTnCp935b7A8TSWYdR5nL92vGZm9ihk/0s+BLniKxdIgfbrz3zz2wjpiOhmRRpchtGUXCQVB9IFmeuq4/0YmSKQ3PVe4hrmZRaHxAjCwQEIOA79bMuMsiZ1bBALnK2lnT/u1mW01IRLyLzTrTe4l5PpjnTJEQ6dKZau7PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FfjusHjY; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5oHvmr1TLb7skaFtHRiIhlo4+PlICcDveNhw5BgpmuPZo9+ozOzJZZ74WnqU5MTJg3Ffm0J1fTk+1Nmb2TDpGRLlxnkYQnkHYIpjbdw2hqwIYFg9X8PThFyp87cl82hQGWZmKKmXjbnrqLgq7uvQJYMxilBp1yp1TMLQFNA3+yq3Nvz5TtdfrsBGzPwI3Bk0kx+ucE4pdJXtl/tIktvzgpbBO7ij0gQkwUjVvUQqun1k485zbq0Pceus26x4sk49Su5iP3411ojHSfrtCBRa2eeG8fOxLKQ3DAJeXpgV2za/HGYGK+OB59W2jWfjUM+INVJg/XF7eI5giXCJ5YypA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JktVcUSj4gI4nPeQIqLSd4CWQFgjmB6BUB9Up06KVA=;
 b=VIuqIkZdCkt7j+F669IcBwSCDy5Ao6SPhr0nMwjMTQhqoXqSE3cmB1ln+oNNXkijuyaLacUr7hlzd7t6G/M14/5iZtNWTGRzBuJMkqaymw6Iar/5iiL9pGcivsvTfkqzY798lL4TPvT0X7U1uhV0QSJ88rGt0FU+BUnd2S/NAEcRlrOyuDXufV9wv8miPz7kfbLSKjBTrXB1mBOrWKT3Fs4u8LfC/kIyqw6M1zZ5hfHKsOB7aIC6jmyAg6OPpWGZK62P+Q5x+lfbof13+OHBjDEzxrIG8oezzum/r1rxYSUzWz48cxULiAe0XqKp1XPsXFXB8Q12PKU+pirRap6sNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JktVcUSj4gI4nPeQIqLSd4CWQFgjmB6BUB9Up06KVA=;
 b=FfjusHjYX7pPMyOsWlNEugN1nB/VbFGMqRgtwsckAUMMBeLmULgE+jNFuBBkY+K2Lg1lOFj9+nFvkSAfFROiDKL2OkFwLFymvXWepM7a5c04EwXg29S37FDqE+8NB71lWTqZVIKbLhQJ8HSOBPP0P8Ilku65JPOTaQfCxJOPaUvyQYn4O4syl9HBj5cGj+Hmj7TDwwjBWc0Utr/5GoBigRNXGtxp4w/oz+Tfv6QFmv+itiz67raIEBH7BIINu6I+cUNpmjb5nzsCF9S5gfdUPAQ9z8T6SnBFGIA3SBNS/CbzMVSor/WWUmqCZ8oznkiOU9D/stTYwNTTDWKsfu553g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB5844.namprd12.prod.outlook.com (2603:10b6:8:67::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Fri, 6 Feb
 2026 18:37:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 18:37:58 +0000
Date: Fri, 6 Feb 2026 14:37:56 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Gohad, Tushar" <tushar.gohad@intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260206183756.GB1874040@nvidia.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
X-ClientProxiedBy: MN2PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:208:23b::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB5844:EE_
X-MS-Office365-Filtering-Correlation-Id: 71639f04-b13f-47f6-0118-08de65aed941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oS2CKmbguk+Ty6A/w53MGMhiYXp4vd7uVuVAk3mX190GEnRHdCDzKdN1CpTV?=
 =?us-ascii?Q?ayqFYdw9HzYIr0xmqVdY1P00JoIqYacOuz1lxyd2VZdscwtuAGQ8iqrYRlla?=
 =?us-ascii?Q?W5zu/Of5xMAJbk58uCtFF7UIAGnVBReuKBsnow61luJGbm5KogYNgJg0ppW0?=
 =?us-ascii?Q?ZHUcTavcloizQFgn1DuLIMqYOiPJOSJyBEkUlGBBrMr8njTOuhKhFBSs6jru?=
 =?us-ascii?Q?iwm2Id8R8vFByDdDlqsPhfy2i7t0lbF7FVTAxqUvvMtyMXWpTfgdQD+b4BCO?=
 =?us-ascii?Q?diocDDC2Cz3HIcn0q8aQsy42JfIwP5DWZfk/oZcd+mKC1B0VwqhdbSA9dD8L?=
 =?us-ascii?Q?mx0gCbiW0Tj3MdVQ5GSSbFEMGAII0DZs3pIPF9DSKdxISsCOEugmIvlKIBFT?=
 =?us-ascii?Q?QBFMnEWlBIdDd8HwaOpUtBWWnVE3RGyyVFJy5ZZJyqsqK/6Vdx4jzaLg+Xe3?=
 =?us-ascii?Q?mDLRQEQXT2H6r1XFUb9Phc9XYPRBltVRK1OJM1NtwP92hHukXzO8DRSZ0FUE?=
 =?us-ascii?Q?PD8izKe7x9+kTNHlgzfmCSUperQN8TvLY0i1optkQJv31GkT21/kI4745NYv?=
 =?us-ascii?Q?5NBTDsOMk2C4oDUqkpM/W2aykym3j6abLkHKOgA+L1CR1pQSqLdt8NEsG4xo?=
 =?us-ascii?Q?4CSC68KVhUHNIwNNTQ8x2RIBrjwNOAcpoWlc88sLLoqaw9xo1KAWqU2MsWzV?=
 =?us-ascii?Q?Qg5adGQ87Y0eJ/0vGeetjNNUL7DKrCcBM+5tIvU3vaayhHFl9uMdifqbBN0o?=
 =?us-ascii?Q?aF0vL6isJqCSX9OJ59rvhwrxiwBKxMsmUt4/wQDXJSfsp6pnKQgRf+lj5wZd?=
 =?us-ascii?Q?2EuqCZHF5wRqXn+Vx4T129LQxeT3hkzm1LKqhnGC8JZm+qWZl61X27TL2WgS?=
 =?us-ascii?Q?nrsMBeuRE/hr0X98U7lNC9BwjRnQObFNDN4jN8o23nt5hhnzMkiSdSHKFiBh?=
 =?us-ascii?Q?bbtxbRqpQEJeaZHokiWBhcgoBS+aQ7XbTbjcGBy8wYO+xB6DiucMB3AN7FeE?=
 =?us-ascii?Q?pM3PQPRmRiBQukCy6ZE8Rm+cmm78wJy67WmVksLKYSyvzbk5TzFebe3lKUsy?=
 =?us-ascii?Q?8nP2Zd2cbO1NJ/XjAM3JC+u/ff+Uf9vCjSufAJQ9NzR1przxOP5L02ZW5mBp?=
 =?us-ascii?Q?1Wnk/NscNHas09gA+T8uV2HBV+7Ce+/QeV+sCvpbz4T06Bcnwrn5Z/m6gSNy?=
 =?us-ascii?Q?lx1ehisvNjX11r6VZYHcCH/zZ/NqXNVxZEmu+EbKnmubHxOUhf0ICnX/TwSQ?=
 =?us-ascii?Q?QClE7WJ23I1u53u2+gakcTAB9g+VfnOufqNnzML3VpKs13x1gAkkjV2lnKL+?=
 =?us-ascii?Q?qHyo75JXIDWFELDD/M/G+R2AI5gzXKTwS6HlKTnGUx2DzZNs9hsEUmp2S17J?=
 =?us-ascii?Q?ii3IKk5N3toNm2e0UkLvGTZiMb7njJlgmXRYy8ifJeqrWCkrIHYJMqi93im9?=
 =?us-ascii?Q?lL25+eDx7jOWD15RGDnSM00JYzP4Hbt0kiIr4XHaaO2zvMiXrHon+8tvXw02?=
 =?us-ascii?Q?ZuLc5yM8uYaJk1hMIOnwDHcmlM4ovriBh8450ta2yqcPbkwbnbeBP8Luq71L?=
 =?us-ascii?Q?cmyUI0lxAMbozzU8q3Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nDHW9ESdD2vV9mMKPqBqJB3MQrIEI/A0/nJoxhEgdm5ju44w4oPEX8aDqecL?=
 =?us-ascii?Q?+IU4MgPBV2PJ87W4ItyhMArnzoE3KRdHrEiiC7A3dSu91u9Z004kEX4ldVc0?=
 =?us-ascii?Q?gDRYTfrJYAYWxm0cc/z4PuGfwYOV5pGab8fDKcEW52bMsXMfhlKTA69bV2By?=
 =?us-ascii?Q?FmKq23MrHlYxcCfVNLtcAaMa7thy6o9ayqaaZSM+X6rvbiFcPgEhX55tDU6h?=
 =?us-ascii?Q?QHV7aavC4Veey4gTT6iFuYXyTZzOgaBtF2vx7JYy1cUVxPlvCjz0fsrCWwnH?=
 =?us-ascii?Q?fv/z4UOeygdPyFUh50zVnHDHcvEE8PAtrnJb6fY5vdANlBZx9o5qx700sIuV?=
 =?us-ascii?Q?WNQglqpacT3QWZUhgNPTtJSoTZ/vBiwRbXBbUE7NN9BUFX6OogK32odBqefO?=
 =?us-ascii?Q?8CNtE6IXNIsSeCP+/OIIbG0ERR10FHjr9P9WGJJ7vxNLFEMCzJqWwA87yEQW?=
 =?us-ascii?Q?Ipp798eBd+GQGB3KpVsMmPKncanxBNpFRbIBR8wjOlAJABXTrsE9WlRCQE9M?=
 =?us-ascii?Q?2SxJmdxG4Od6m6h2KdGW/c7Lz5wb+xKGL8NjBikZrHoN28ZxxwhDwb6mHBdd?=
 =?us-ascii?Q?YXER4YPsbh2IgwT/fkpl4EX2Mx2+frIA2U9hwOlDjoRAk9c81AvG8yScWlAF?=
 =?us-ascii?Q?QfadFSipe2w+PHgYBUi4XAV/crHwee95eACNu1Ip9KeED2RHDDCXeL3wy7Fi?=
 =?us-ascii?Q?nNOy7tvcBp/sjbUcLn892hY75iL86gyA3mD6RQsE0klwfiFPRIGGdJnBrn4e?=
 =?us-ascii?Q?G3Jsq+rIioqrbRudem7shmfrfoEAddCQraby93hyOfpklGsfYGlViXv99KZR?=
 =?us-ascii?Q?QjUp/4JOb/EoWaR0xPgPv8yecgN6sfZqi0JlvJntO8Nc8TWENqSA5okihRUY?=
 =?us-ascii?Q?voBicIFlox7KeBwQ7NTz7CMTUvR/FpjqN95HzVRGHTPFzwAKoOiq39JNXNT+?=
 =?us-ascii?Q?5SkVnmdjkuYWNJaXwTSPQbmAKC3CuOQuan1r2TDRo6RWKz/Q6SOtsdUw/HPh?=
 =?us-ascii?Q?SlaqgIpNv5jHW6ai6zDZSU4mUSfo9k8SXqVSMhbIq3C/usB3ReB1keHnkuun?=
 =?us-ascii?Q?GWaF8aJTswADuMCFeqQzDkIMBPEIj4ZReMOD+A/PLxaBkuqeEOYHB44Yyjgn?=
 =?us-ascii?Q?yc48yBCgTVZqqgGMBsdeiKYusZFKKjD/uuX3K8wavKMBJzSFoAMySY9xM35m?=
 =?us-ascii?Q?KOa/Vcryte3aeErV/IlZxDbe3BIZHy9MsaUhYaXJtd3VcI5KZzUYS3CoCSup?=
 =?us-ascii?Q?nHAeMvHshIGgbYD4t3pdkSJVA5SPSaqE4vRi30RNDluZtkYuYGJJ47wgPXNT?=
 =?us-ascii?Q?HSOX7VfO+vuXW1Mr+v8ge6ijFru8c1hsF4OGwrNbI1DapjggxJYzVNWrtIet?=
 =?us-ascii?Q?HBlXDY+hwm16Uooodzw8+fomAVagNpc3XKkL/FxVAa2g3hTL6rCn7r6oeSlQ?=
 =?us-ascii?Q?Vz5fUEtiwha+gKfwLSlb42NOdbsv2SIRqwciJ9K/QiZrfz/mHql7skFloXt3?=
 =?us-ascii?Q?6rlybDx+zbeNOzye19jNLbLv7MylZ+hmwzy+nyvfi9ZMb/ZMBqNYtPkjxeQ/?=
 =?us-ascii?Q?wfvNNYVedKKxHRu9HMuH65et/Cr/M1TNZ+iq2YLzgndrIE11uK7oaJh186s1?=
 =?us-ascii?Q?F+7JPRzrW/j/v87MPodXyrvOeXqYA1l/G1XRibl1enyw8HVtciDHakS2BkUq?=
 =?us-ascii?Q?SwodeVYBNWgAU0/ujquqEK85VC7T2CpqI9cXkW4KcoC4ZTtVuazRvS9Q4sQv?=
 =?us-ascii?Q?CvEbytlIMw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71639f04-b13f-47f6-0118-08de65aed941
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 18:37:57.8753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKcdKSFZRrSWeb7RypLaHG+NkbkyTDlooj6G3q5mdIEcPxRJVGD/Kys9OtQQ5wpZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5844
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12083-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.945];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: D7B5E1023CA
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 05:57:14PM +0000, Pavel Begunkov wrote:
> On 2/6/26 15:20, Jason Gunthorpe wrote:
> > On Fri, Feb 06, 2026 at 03:08:25PM +0000, Pavel Begunkov wrote:
> > > On 2/5/26 23:56, Jason Gunthorpe wrote:
> > > > On Thu, Feb 05, 2026 at 07:06:03PM +0000, Pavel Begunkov wrote:
> > > > > On 2/5/26 17:41, Jason Gunthorpe wrote:
> > > > > > On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
> > > > > > 
> > > > > > > The proposal consists of two parts. The first is a small in-kernel
> > > > > > > framework that allows a dma-buf to be registered against a given file
> > > > > > > and returns an object representing a DMA mapping.
> > > > > > 
> > > > > > What is this about and why would you need something like this?
> > > > > > 
> > > > > > The rest makes more sense - pass a DMABUF (or even memfd) to iouring
> > > > > > and pre-setup the DMA mapping to get dma_addr_t, then directly use
> > > > > > dma_addr_t through the entire block stack right into the eventual
> > > > > > driver.
> > > > > 
> > > > > That's more or less what I tried to do in v1, but 1) people didn't like
> > > > > the idea of passing raw dma addresses directly, and having it wrapped
> > > > > into a black box gives more flexibility like potentially supporting
> > > > > multi-device filesystems.
> > > > 
> > > > Ok.. but what does that have to do with a user space visible file?
> > > 
> > > If you're referring to registration taking a file, it's used to forward
> > > this registration to the right driver, which knows about devices and can
> > > create dma-buf attachment[s]. The abstraction users get is not just a
> > > buffer but rather a buffer registered for a "subsystem" represented by
> > > the passed file. With nvme raw bdev as the only importer in the patch set,
> > > it's simply converges to "registered for the file", but the notion will
> > > need to be expanded later, e.g. to accommodate filesystems.
> > 
> > Sounds completely goofy to me.
> 
> Hmm... the discussion is not going to be productive, isn't it?

Well, this FD thing is very confounding and, sorry I don't see much
logic to this design. I understand the problems you are explaining but
not this solution.

> Or would it be mapping it for each IO?

mapping for each IO could be possible with a phys_addr_t path.

> dma-buf already exists as well, and I'm ashamed to admit,
> but I don't know how a user program can read into / write from
> memory provided by dma-buf.

You can mmap them. It can even be used with read() write() system
calls if the dma buf exporter is using P2P pages.

> I'm not doing it for any particular driver but rather trying
> to reuse what's already there, i.e. a good coverage of existing
> dma-buf exporters, and infrastructure dma-buf provides, e.g.
> move_notify. And trying to do that efficiently, avoiding GUP
> (what io_uring can already do for normal memory), keeping long
> term mappings (modulo move_notify), and so. That includes
> optimising the cost of system memory rw with iommu.

I would suggest leading with these reasons to frame why you are trying
to do this. It seems the main motivation is to create a pre
registered, and pre-IOMMU-mapped io uring pool of MMIO memory, and
indeed you cannot do that with the existing mechanisms at all.

As a step forward I could imagine having a DMABUF handing out P2P
pages and allowing io uring to "register" it complete with move
notify. This would get you half the way there and doesn't require
major changes to the block stack since you can still be pushing
unmapped struct page backed addresses and everything will work
fine. It is a good way to sidestep the FOLL_LONGTERM issue.

Pre-iommu-mapping the pool seems like an orthogonal project as it
applies to everything coming from pre-registered io uring buffers,
even normal cpu memory. You could have a next step of pre-mapping the
P2P pages and CPU pages equally.

Finally you could try a project to remove the P2P page requirement for
cases that use the pre-iommu-mapping flow.

It would probably be helpful not to mixup those three things..

Jason

