Return-Path: <io-uring+bounces-12080-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODyPLncHhmkRJQQAu9opvQ
	(envelope-from <io-uring+bounces-12080-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:23:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CED0FFB24
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99C26304503C
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 15:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9C1378D65;
	Fri,  6 Feb 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rTzhfJae"
X-Original-To: io-uring@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012042.outbound.protection.outlook.com [52.101.48.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFE26ED40;
	Fri,  6 Feb 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391319; cv=fail; b=ORUewpapwn6IEdZZN2CSvt7qsY8wBoQ+YWXc+CekKHm3qUBHnMn3YvLE9RSZTon3/+zhnSl/Xv1hY55NzI56o8WXU8OPD4rzjF9jB/zw5NzFKH2WC6FJTxa9nn5Cx/HTBW480FjOf7Q0rVciCtD5FkTWs5YjHen9g7HZctNoEso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391319; c=relaxed/simple;
	bh=A6Ojb8dxUh3k0Td6vBEVUVGjYQ1eTDkvVkQcqkC656c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mNDLpB6VxHkXGi7xnHuGcWo2ypXY2Xrc8oWyi+Pe32JUi9FL+rtLUnc7GZY9kEJUYLENlUiOw9G2rMSpwHtvtDMlCKhK4KEdP8KN85L9ZjNpcQIlFMTlE/PThjT8NbaV0in1KYJHyaTpGm9ItccMnwDijYI4++xdhcgYYctzvzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rTzhfJae; arc=fail smtp.client-ip=52.101.48.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7pNMk6fdGvEP3bsBhAcHeZ37mTXUk0f5x5uQtxVWZMD1UN03oK29O5SUttZb75aio+QkrnkRAdZpFIj9bTqR6gF/bqY0DuoKSpNFWKMFXv8iUnzze7SbWqZuofkaBfjKnns0+sT8ayqkH9oR/z5lqMn2yP1gs88Dd7hmrp0/k8RsRJMEJC1pdKRWDMmKpKjeSxoBLVG2u38tlibz+BLWWo0fKx3hW2rEZ+CLHf7dnb0ka1+sY+9wDHfEBKgTGayYQkt8AoGn4ItSRlPnTixKMFDJ04jXFQdVNjcWZ+TjXvq5qLjyBJG0m0UcYf4ZAWrcEM6P6Rq+shoa312kGbNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xrEr2Zchvi8lIseaBZbYVJQkbfDt2Gj4olYv2k8w9k4=;
 b=w/riXolH/0w+SPmgnGts4Ga/LRUlzdyPTZP3w8Nf61YxQGtNSM0rO9pqqljo+5tq1MBi7QiBwZH6/+wicL4nmqL0JD2bpDldhneHB5yfvD5/hdNh/PuNAAQYyJxIU/4FKKnSitQTZxP4p3DDvMDManQqOMWlUnfR2zkAJhWnRaDJlo5uHR0UinZBR4iRmPzyofAWl+yNSQRcZKcSEzokIzdsK891lH3T5Al+IulJkoPQdnseFLaz5fJ0yGVNru0PRRqhnPpLP9dUXE+ukAcOfO2JSDixeC6WjZbk6gYrs1jxX+t5fmifZJUztI9zqkWjVGaDCPiI7dp8MWVTbDdueA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrEr2Zchvi8lIseaBZbYVJQkbfDt2Gj4olYv2k8w9k4=;
 b=rTzhfJaeeyc05yFhrIQNQcBopfwcxyUlrAIPlOAYqd75qe8OXSj3cVxww9/7iyJia4ZF2EwBQMx746LhoA+k4TcU/BvJNq4yP8mYlspeU+AogvbEB0Biw5M1a/teVpp9vy+HJiYfkTRqwFf1dUecsuX8+K9QGLXH8DmWr4ealvr7MSxcRIxR36+851laZ00ZK1SRlGEe1HO1t2wSkrKo3dPNxceRNPXnID6Ca4+pl65yyQtPV3PcuEX54IsVy+6aamR2ZCR35FyYebWptHlfi3XjZKWHaCeON+uw6wCB0zhBUCx3s6+2Xk0df/XvN3FFK3Hc6FCIeCejLyETQSPvQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB9465.namprd12.prod.outlook.com (2603:10b6:208:593::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Fri, 6 Feb
 2026 15:20:43 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 15:20:42 +0000
Date: Fri, 6 Feb 2026 11:20:41 -0400
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
Message-ID: <20260206152041.GA1874040@nvidia.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
X-ClientProxiedBy: MN2PR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:208:23e::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB9465:EE_
X-MS-Office365-Filtering-Correlation-Id: 0abc8731-d730-472d-b85c-08de65934ae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?jEnPI++6s8FQGU8Qxga0srk8f3ZtlxPTQshT/3WlzWBF77db/o+L2567YaPV?=
 =?us-ascii?Q?nyQZ3Wt0jbqySUui5ixJOgwIOFkSKBf52jRAGSHGJbX0FVoQ/0dKrn3sbKmD?=
 =?us-ascii?Q?BNJwwcnS/5mrrn+zRsNhqAgekfgzpdixcoCoCXQw6+j2JUn5AIyo+mjPdfJ2?=
 =?us-ascii?Q?74CfnkbJhelyRqDHQw3VX3OyGzahvA/Vw+AeF/SF3nVBe5ifTU2rexjVTz7D?=
 =?us-ascii?Q?AWGueFXDsoXVwU9B0uTpoTC+i5WvxIgZRI36YNlYduLcOqxEOhU7ZXyKVj8T?=
 =?us-ascii?Q?eJYmbajou7++LH7f0xtLIxFOr5uyUVDMbGQiyZwyL8HpzQaNjFCaLY6QXHB7?=
 =?us-ascii?Q?EtBJXcuHYoLkGRjEn9hYqLcFWKD4jD/8uc9/AY0GzF03LUUWDNTs5uo95ugj?=
 =?us-ascii?Q?ug0XaVz9WDqq5MRh5yKVKJEgvpfU7aPf+CVrjTz3BUqK+uklNz0img1LaEZD?=
 =?us-ascii?Q?DHcfS4YV3uYwRfSSwr7eVku3gL0UN+ZP+BRiCMf5qjdoa6ehT+cCbCEbmzh7?=
 =?us-ascii?Q?42aFaB73lMVTMYfoAzylzGbhS+eDsFpVZt99Of2Jp4nOLsZLfQvQ37pDHtq/?=
 =?us-ascii?Q?95FGhdfJSNaGFlknnTBhO6xw8C8nmtCXwnqTrFU1qsYNkMUiC/urM8rLPf4m?=
 =?us-ascii?Q?XSo9mPo+i88LThJTIAjjkGLb/4xtCijIyXF5waElLKeWDFjnfi6kp6E/TU1x?=
 =?us-ascii?Q?yX1igLFomxKJLUhGZmyGDdj6WPguCSvmFEFsBjd2hiY4G/4jJRrM5QIfhhG/?=
 =?us-ascii?Q?xQNX1cdHI0/Aoig7veTFHIsKKHMAvqgmsLRF86Ot1qqbHBz0f9Hi7dQcQXSS?=
 =?us-ascii?Q?RwyJJHOvgMMnZ+oFUK5iw9cMYYmwh3vCVbsYctzZ7WnnU4FPhxU+6zgVzByU?=
 =?us-ascii?Q?sXECp16TxQV+l4pX9AVKkMRE4DwNuWjwBWRXK9+AHq2/wO7eFT5hmVHH5sJt?=
 =?us-ascii?Q?fu54uL4WaKYLXB5AFa5bDp+PWsj73ByQWNoGqSy3DTEmiGejs9sIQYiEVO5E?=
 =?us-ascii?Q?EKzXcu78jBbETQ3PtGzk7QGCdtUKfgO36URrM7O7fkCVibrTF2uJrK8fW9rP?=
 =?us-ascii?Q?itrkJCBCQq7k5lzye4fewFQULceoTi66h1wI7GrFOpLxbXXnzzVr0EjRkhna?=
 =?us-ascii?Q?RQW4D9kNJ4NpNJtSGVTAQUN5DIHJ/RWgYIWp5k5iFQrkS8GvtaWgYYBwS4tJ?=
 =?us-ascii?Q?yfcbyFvjWl0Fg6DHN8lIcZmWJeVGARjHGOTWuspdDtnFrel5fXvEvBT+B182?=
 =?us-ascii?Q?p2VCrTEQQkg6DNAFzGVfSs5T5yNWnDRjXydO2UlxUvZ9hWt2+xP0OeZZh4ha?=
 =?us-ascii?Q?wDuovsM4Btjxzsaf/kAlIk+UYU9LP2CHLdFG6Fo61fL/Nipi98gCsZWSvfYR?=
 =?us-ascii?Q?OdTycBPvS7zvjA4rgAs5KDerRUsW9z1RKP5STyWuEYisKKeSb6jf24uCS9AV?=
 =?us-ascii?Q?3FMantp7cWAn49BB6xFwc+/lyMyQECZogLMv4WpdrHJxUYRASZ7aRD9KGE32?=
 =?us-ascii?Q?8150vT4qIOPy6ayJ4/9oNFjRKdadgjR/3DGoETOGStct1YAlsORLNvVjV3eS?=
 =?us-ascii?Q?sibNafvlVh0sLSGzDFE=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?KHA/khnj0suUuKj669gQSaq5iymW1WeVmQgMa6oN2d6C5cbUJlqn+rnazO26?=
 =?us-ascii?Q?oPkiQSRDZCEwwnjW07SO7bRqT/kSOZ2YmZfT6uOL/kc2/GSP1jGW3cLtmwdi?=
 =?us-ascii?Q?HxGQWrTJkz95/wmO2OO7wpz6T+QMYB2LXPchyCInxLFo43RtpJQMH1PNnW46?=
 =?us-ascii?Q?miL0eY/8weu1Gj0I+XLr5qf+ZU3lYZP8sxylh7ST01NqWB27Pa4d7ATNOF8n?=
 =?us-ascii?Q?svp+/F2XT0FgTAPo8MnbVg5vLYKuvjKDBaBSWEj87+v24YoMOyR4JhotAspB?=
 =?us-ascii?Q?UnZrdJ2jcM9qxoFKPdx6OruPT+rA+TZRqFO7P+TBZH2rReJKLcC0VaO+iFyQ?=
 =?us-ascii?Q?HPb34VDpOtdT+2GCrdvPlJ8DSNcp3XhmiEM7XDHhRr8yXR0j/NmIuKd9owad?=
 =?us-ascii?Q?eAKqaPFwBflFald73+BoS9jMlUEhuf7TEBkKDKLxBkLifUjN8+fAUJn11gAS?=
 =?us-ascii?Q?QelVSX2Vv0QCsVNlxTOyEizCK7ME0Y9myStd7WWPLsnsNOIJyxZ4WdVkk48S?=
 =?us-ascii?Q?MwuozA0lJehN6DWQw33S3OWbVdWlPxHqNj3In42I8rs1KA+r1Hsln0LwZeM8?=
 =?us-ascii?Q?RQWcUkhKnK4svIEcOzsoeHM/9McIOpDyOkyDxlXNy7AzwydX6OaL6BAstGAC?=
 =?us-ascii?Q?ulPYnlWD4mETKgiDtd+uSF3TbyeUUIh+6wkHmgaUvys9s/pI3fHWu0K56maF?=
 =?us-ascii?Q?mTHUoyA99G5309D+43YcXpAHFm0U7bKimtR7YpIInCHCe5ZtYcKqV/bED7MG?=
 =?us-ascii?Q?n0rTdO2suwzTQCJF4rBia+VavZdbaw/doUiokq/oEKtRywBPIcnvc+W/QV2s?=
 =?us-ascii?Q?dsW3EWUjsaEZwqVyQL3Id/Hf8lJ6hJqZvNS2hGtrhG7ppsGuREFW7i8D0rKT?=
 =?us-ascii?Q?nRhI3jF0UpJztIBVckdGNc933NI1HCi3mN31XFc3PHfU0P+/Z5d44UwRLEQn?=
 =?us-ascii?Q?jtew9/qaC3FunMXUv1TR1tu5lZOhBV/DCn51evzJArF6hOiDXEb9BEft5hwp?=
 =?us-ascii?Q?oXsOTG8GoLtkvZ+IvHZl4UWzgWzDvkQuSOZJCeXsr+22wK7rf02U70PAepo0?=
 =?us-ascii?Q?foAs90FfrWSUhI/oNRtyWqIJU57NaFFk0ELovzqt31LtbUurdM64dUBYY/4Y?=
 =?us-ascii?Q?GQme8op2DC2aLF06gcZl4VhcwViRkXIC4pFEP5Gjgn37eFJXZG1tRoiZKIMN?=
 =?us-ascii?Q?NoIPcp/BXKBi7Camr3BkSV4+M3/lzzHzjs49/4w8y4qOw9Tl38uu2fcqHM3X?=
 =?us-ascii?Q?6fo/XJfvojxx+fqwKaYj+0UHq8uB9V/0zcXJ0EaT9nWTUoJ+kZMwsHixz2th?=
 =?us-ascii?Q?knJ1jjwuoYc+cShJGHixXAxG0vgEk137QAi6GD3E/+U+7qf47YQcCrTeOuD6?=
 =?us-ascii?Q?mFhbOJxYhlkS364p4NGNo9WZjVUWt3lplWAJtsOmaSV8lyN+dq1ebd98AMuG?=
 =?us-ascii?Q?LOTzeiViG790a4y33kZgc8MyHsuWlMZo0LcM3QT6IVzXu4ptbQsMr7QyejJq?=
 =?us-ascii?Q?BECNuFYd6JKEZwybpLag3Wt8Unh5M4b1ZAm/CyEwewVc/d9GjH5clBGmBDQ8?=
 =?us-ascii?Q?4Lvg+A2ZIcMHbpD589ramsiYEfgHMkmkLg4DlX3XQKLTdXESJXpMRI/ARUKT?=
 =?us-ascii?Q?LhJgTWFDLrZEP/tNs++XVdmj9C7xtUJwk49n0RVLyq0WaVGLtikGCU4ibYpS?=
 =?us-ascii?Q?N4BFugn6RijFYDwlPekN7ALxeXjDXyKN3xzVhh7tSyBiHn5A2480VCv245J9?=
 =?us-ascii?Q?JKR/vpAopA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abc8731-d730-472d-b85c-08de65934ae1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 15:20:42.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Se+BAvmjccjAiI9sdK1cxRaEyDCz97UxpGov3A4auOD1ScFejgVbi3XxowPWDXjY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9465
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12080-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.936];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,Nvidia.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3CED0FFB24
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 03:08:25PM +0000, Pavel Begunkov wrote:
> On 2/5/26 23:56, Jason Gunthorpe wrote:
> > On Thu, Feb 05, 2026 at 07:06:03PM +0000, Pavel Begunkov wrote:
> > > On 2/5/26 17:41, Jason Gunthorpe wrote:
> > > > On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
> > > > 
> > > > > The proposal consists of two parts. The first is a small in-kernel
> > > > > framework that allows a dma-buf to be registered against a given file
> > > > > and returns an object representing a DMA mapping.
> > > > 
> > > > What is this about and why would you need something like this?
> > > > 
> > > > The rest makes more sense - pass a DMABUF (or even memfd) to iouring
> > > > and pre-setup the DMA mapping to get dma_addr_t, then directly use
> > > > dma_addr_t through the entire block stack right into the eventual
> > > > driver.
> > > 
> > > That's more or less what I tried to do in v1, but 1) people didn't like
> > > the idea of passing raw dma addresses directly, and having it wrapped
> > > into a black box gives more flexibility like potentially supporting
> > > multi-device filesystems.
> > 
> > Ok.. but what does that have to do with a user space visible file?
> 
> If you're referring to registration taking a file, it's used to forward
> this registration to the right driver, which knows about devices and can
> create dma-buf attachment[s]. The abstraction users get is not just a
> buffer but rather a buffer registered for a "subsystem" represented by
> the passed file. With nvme raw bdev as the only importer in the patch set,
> it's simply converges to "registered for the file", but the notion will
> need to be expanded later, e.g. to accommodate filesystems.

Sounds completely goofy to me. A wrapper around DMABUF that lets you
attach to DMABUFs? Huh?

I feel like io uring should be dealing with this internally somehow not
creating more and more uapi..

The longer term goal has been to get page * out of the io stack and
start using phys_addr_t, if we could pass the DMABUF's MMIO as a
phys_addr_t around the IO stack then we only need to close the gap of
getting the p2p provider into the final DMA mapping.

Alot of this has improved in the past few cycles where the main issue
now is the carrying the provider and phys_addr_t through the io to the
nvme driver. vs when you started this and even that fundamental
infrastructure was missing.

> > > > > Tushar was helping and mention he got good numbers for P2P transfers
> > > > > compared to bouncing it via RAM.
> > > > 
> > > > We can already avoid the bouncing, it seems the main improvements here
> > > > are avoiding the DMA map per-io and allowing the use of P2P without
> > > > also creating struct page. Meanginful wins for sure.
> > > 
> > > Yes, and it should probably be nicer for frameworks that already
> > > expose dma-bufs.
> > 
> > I'm not sure what this means?
> 
> I'm saying that when a user app can easily get or already has a
> dma-buf fd, it should be easier to just use it instead of finding
> its way to FOLL_PCI_P2PDMA.

But that all exists already and this proposal does nothing to improve
it..

> I'm actually curious, is there a way to somehow create a
> MEMORY_DEVICE_PCI_P2PDMA mapping out of a random dma-buf? 

No. The driver owning the P2P MMIO has to do this during its probe and
then it has to provide a VMA with normal pages so GUP works. This is
usally not hard on the exporting driver side.

It costs some memory but then everything works naturally in the IO
stack.

Your project is interesting and would be a nice improvement, but I
also don't entirely understand why you are bothering when the P2PDMA
solution is already fully there ready to go... Is something preventing
you from creating the P2PDMA pages for your exporting driver?

Jason

