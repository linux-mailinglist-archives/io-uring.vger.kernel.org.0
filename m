Return-Path: <io-uring+bounces-11987-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GkfKxUrfGn1KwIAu9opvQ
	(envelope-from <io-uring+bounces-11987-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:52:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 307DFB6EA4
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71A5530214F9
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 03:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA296365A10;
	Fri, 30 Jan 2026 03:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cl0iBwR/"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7275434CFDD;
	Fri, 30 Jan 2026 03:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769745132; cv=fail; b=JjtpgbmsxXwa+Xejo+5Y60oQr8rZfh2mTw931JrnmTS3yNGcrNbwy3eE1P6KnkFZrXXfAbYM+vnlngB8PavUM7pFH4RukLpbffb6mBCW/Vf9Nq2U+u01kVQOCorXEJ9yCsLebCD8/goZoCipKzcwZTMc8oTvFcTERszVGxgHs3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769745132; c=relaxed/simple;
	bh=NWDWL+OZsk0I88OuXyEYk7lWENAmgeQjoDLWBRPlnoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i3iYKLcD0eZaoJeMFIGbiT7uKhoUzC0197pLo1Z9TiIYYhbmAOgV9hHujtSqSqtnpc3CPe1HKInSCUPG1oT6uQVTHAYkAqIxA1CRkxMUSCDMGYJRJJeByeizVtACoTm5jdtY7anogFVFniTtyLlVUw3u19NZYSJNHL/mheBKpwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cl0iBwR/; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/ZW0SB8icM0WAqvP/MlyCyBEKE1gkdoGwbq3xa6vit17uzHzo/JbdxpRdcOz+DhqiJHWXjlurqK2ewjhdBP9ugCsPq+UgrNxfriNDZsLuSWstwHCt+sR/hzetBG3Fh2sxTGA6P8a2ByJFJtsHrc2sJG7m7Hao2+UwTPefoVXHV1nqIxFAYwP4mIPZyuGGOQ0nWPYmz65OvSstZcoy1h+WzV4b/U+G7dfC6hGax9CwGgnggOLFBMIe+3bAMHXnlbJvgofc3Mb5kJN3Zv/QEjIL9yQX7Hv3xcplOD3/4FRDXRUIf/Bdas8PcRL5qQrHn/q/moaGRM7BA0nY7UpMYWJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGmtYMB7wSNXy9JriJgwExQCsUxhIMaJdhohoIIAxVU=;
 b=u4kOy/JPaygKlVBTWcmtxTkhdNw2x7SJ/tcqobteJGNOYni0jQFXBmhiZchTmdick/vhwzeH8oax3LSfjbeJYYwlRasyBUygNiey552huWU1X6HLzQM73C6F8dKH6cdy4EkOh/Poy9L8TUmwRpyxSPHVkyzE6+aDjWHtsAH376NPYEAkJ7oP4sLmNmEqxPdHgIegMKGp8pBQd5lNJ5QnU4L3RdMH7PTBXhmEGeD+5v7ilE/AW/CUMNYh4UClrSeH/b8bP7aOVamMLh8nKjfHrLOrrGV6PumXz8OyUl47REgVIKcuIFAVKHZMvwUPBbRUvD5vFUoavJ7f8HMP3hbL8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGmtYMB7wSNXy9JriJgwExQCsUxhIMaJdhohoIIAxVU=;
 b=Cl0iBwR/SSRkhfGHmIi3j0md5s0c7EZI/0BaY7CrCaM7Dm4++jImpybf/m/YBWYBW1cLtqSA06FBLGjwXzrJDduIe92ArrK7p5rgjg+B8fkCyopc+2ch0uCRDZgjB4uSFVoEl9RKICbz99a44mgjUXmM7LzZ+hLvCttJdVrCEMtdscFR3+wdAueZFk2tyiOhapO56mhzl0Xu6MeO8SlVOgXy9D/Ak9CuEszrYx+tVf5thkUxKiXvJsoUB8cuhidsGFkfBUl8Ps8x8Z/U8WOipmTAJWy6S9Fmyai+qMNAnDxqookgTETqbkcTJNAVJ79qvAwp18NB5BURy6EPwKdfLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 2/5] mm/huge_memory: use page_rmappable_folio() to convert after-split folios
Date: Thu, 29 Jan 2026 22:48:15 -0500
Message-ID: <20260130034818.472804-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:208:23e::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: ae0f97de-8c1f-4169-dddc-08de5fb2f032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lPUps5xOKGByx2rtszCqYy60B4QHlNcKbzWPVCUj3fTcTwDhxIC032a/EFlI?=
 =?us-ascii?Q?AAEROsfjCbOIzJZ7HhgzipCr8DMOIiYF1/051GCXAKqaiVFbBLWZKABW+TLk?=
 =?us-ascii?Q?91HfWn9BqXhSODwG+D0quBoPAxIQub1jnhvckZxf76zjNtTXapS+IpcCLs+t?=
 =?us-ascii?Q?lbzdHaNHVtCRKKIZOd/ldGyd9oOjeNPtSZxDMcdNBbHIJY7vnfiGc9tzxqAl?=
 =?us-ascii?Q?YOhbLntiA592peTjBIkiLN4j+nyzDlxlMeB3VjaRWdLjM5utYvrUpn855M3c?=
 =?us-ascii?Q?JUj1UF2sJyG622Ej5NW4WNTk9q7KqepGvG+xsW1phwk6JGrVaxGvsIxkYRr4?=
 =?us-ascii?Q?6Ozabul02Srl527tB0OJT1OxnEFatfeI8gHOlyQEh79vgP4AT6Hh8SOVo1E4?=
 =?us-ascii?Q?Fodoi22YqY/9stoXgwCWpB87Zz1SNhlZIGKCQvpvF0umrxMvVgJme6JPvOlo?=
 =?us-ascii?Q?1Gn8TnBW67BCT6aGn/j8j26u0fXUlIUCaW4RRabG3ds9OfimKwniLtVU+lCS?=
 =?us-ascii?Q?665olu5Q6SKLzywHUXweBGSyrK4wlu1db0B5vWg90F31wqFAvMRiMEjtiRtQ?=
 =?us-ascii?Q?FcreBR5TSpYa7k2nHOvDNx5TjKt7pNu2ZERC56Lvc6mVQzGlGfzHPpoDlclT?=
 =?us-ascii?Q?TSqJgxaowUB6cdvEjp7CpZNIcp+avc7YCu0LQW4dGd6Sipg2VI/poBhdF0H3?=
 =?us-ascii?Q?mDhpNX7aRhydd9xkCC/dYhbjoURveiN1RX/Qk9RP78VvNZDkww9rQVNESzAJ?=
 =?us-ascii?Q?0YDn9l0rOXdZsxYEgIPAHFf8JxXUeCSejgWltCLR473QZcy/YApdPMdXdk9A?=
 =?us-ascii?Q?wuE8VxX/ezx1N6UTgh4X4ly+Z5aECbzjnlNkxJpLQ80UMZgHApGBUkcn7qhA?=
 =?us-ascii?Q?XtULno4zzGl9z1qT08oGeHO3FWQTkVkI+mxHlbl8MZd1IEOZuL+/soFVM4h9?=
 =?us-ascii?Q?xsfD9419nh+IcCDzHJedGzWYduuJ0+W6s6reHFfwvS6sRs6+YVN23J+YNjXJ?=
 =?us-ascii?Q?FXV9VkZFwpehX9rW2ti9rKUcxPMSrF3iQ3QvSnOQkZEzOUXEWA7q2q1tMfYa?=
 =?us-ascii?Q?WCGLcV5PRK5Pgsy884opeHTVG7rX+N1TxNJkjACIHncLUDV6gwX9L7aFSQQh?=
 =?us-ascii?Q?6TzJ85LaX6BF8lMpuIVMFhf+2Hv6vnCMtGhFl5Zk3wcO6bbV1pkdWfdZjt20?=
 =?us-ascii?Q?qXXkBL3UEv94I0Yk14rL2GXamkEP18l0eDt7SQmaD1h+JPA8XHD4YX41O9zs?=
 =?us-ascii?Q?L0JmpOPzSLzIEfqkAlyGDnyKVuvNVt7Bh/JGkmyOFuBdC273EG46mLttkK9z?=
 =?us-ascii?Q?6ef4SuLfG00i4TrMHOm/Ky/7IfFDRC6lVDiTgQKAnkMhnomJh8bbny7iQ2pt?=
 =?us-ascii?Q?we0vA0+KKPUW7uS2dBAgPXpkf5+YSXtkn360KRxnbX/Zoy6FUVUkxd1S4GPp?=
 =?us-ascii?Q?7FMrOFR0IS2LGyqXJ2uvPlQkngTgUitoU7P4Ehb03wLmXgZRjaQ3gJGtik9a?=
 =?us-ascii?Q?2fDY5jPv8fzx5OIGA9tfOpmXE2HqFbu/15+Y4Ny/01Pcl0rrIUEVW8oJM55E?=
 =?us-ascii?Q?IJibDD7qBTVEN/rQ0qs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wWNKk+OZ3v+4WCYc//0yi4CwzPiLa0KfWERtYthAjuQpL/OvN/jOVSTEFh05?=
 =?us-ascii?Q?U4lVHSFSdmEujpxbq4zymTMez414IBEmfZr29Z5o/jvUx9vRyiKhgJQESO/b?=
 =?us-ascii?Q?RQpj9NoBSgAo397/AZrNXO55l5IYOLn31h5WCIxpRtJshDAzY+SQMPNVTkTN?=
 =?us-ascii?Q?86vvx3QRAhOSqGtvo9yly19SwNh2bHeJLHv94yT7c7vcaBOAB5V60mJAx0ac?=
 =?us-ascii?Q?BMirZSmtqlIIE+omMvlRh42e4zcdzMo21tFZAsNLMg2aUHx1tjDlzsF87jSn?=
 =?us-ascii?Q?RUB3aQhN0+AXnX0CW0zumjwTkkFOTMOSHWQzaxXFwHpqt5sOVycipDp1jIxC?=
 =?us-ascii?Q?t770ME5tvWzJ7QJzfCFoH613z6PeATWhJ4XjcKk0NZXOhuhIlGbBu2GPTe+S?=
 =?us-ascii?Q?oDMHtQ7UYpkU3Awqunp355NBqTaOB7ryQmM11VHoysgg4yZz1yPEquoOpUrG?=
 =?us-ascii?Q?C444kxCIHo0uAciM5NLx9wR3ZmgJAi2KzgRKFdKrFJu6dPSLs84GqtAPM8GO?=
 =?us-ascii?Q?tRdSmfU/4+mjioCa78B7ihcOBf5RTz3ripGhAlo/c3PkCdfSRVPkDLcVu/O/?=
 =?us-ascii?Q?kXw96etKVvkVzccM+dnQMYOlvD6Li4HVMQrLTPd65shZuZ4SoZgbEq0O3UnJ?=
 =?us-ascii?Q?m74PohxiQjau/SroLDF/VNsOY/SHRhQZ1oLGvOKykCjM97CqWDg7rtm7CBGq?=
 =?us-ascii?Q?pyCbOrShxfy9eQyxsMjTuFYfondT4m2cQxZb4dkBKzzhZqQhGuWvPELEnVUo?=
 =?us-ascii?Q?Lbv4DU+bVk8VHTzWioHC3fMCerd7BGVcWc7NfL81bFBL2esYemfPyIK6iLIZ?=
 =?us-ascii?Q?cjxOvLCxANxhEOeFzq0cGG2vG1eLLrLbqO4a8hDDkI9zPjW3OS3cpmWGVJSk?=
 =?us-ascii?Q?IjaAkXnz6lQR68g5q/LXF4glOvAnz+Bw5Dy5ZvE8iBKfUk9WxLd3T4yYa0bw?=
 =?us-ascii?Q?bkrt4K3evCuVV75jd8L9NXvORUj6bAm4bQQjEj4khclf0cirTi2C5toHJ1cB?=
 =?us-ascii?Q?CI7mrrPP4sR7xj2Lzd6EZer1N9c9Il1d9gynV/Slf6c6N7NWsAGGp6aFYuQM?=
 =?us-ascii?Q?PMsh3V44IJDiN4tNaKbbntJzLMDFYZz/3P06ma2nGwkN1orevKGTQOdcqbzT?=
 =?us-ascii?Q?reL08rHRrZvxohc1GPNpuHW0vtZtrUNYH1bXQ/+OaCxiXQBXFgXefnr6A/tT?=
 =?us-ascii?Q?fvABcykuyZ5KPYLnMTOm6sH8ROotcrYuoeafmenSsnQIY8gmK9UzftAFxDsS?=
 =?us-ascii?Q?UGNmy5N/pB0HwcSuQbWCxsqisLupAlr3nG0tdMx9TEtM1reg5RrSr8Mgz5Gu?=
 =?us-ascii?Q?IWGWThBrRE0APbFDIlwVgXGs0J7QhYJj/O0408lA8DwLojYkKYSlVXpgDcJC?=
 =?us-ascii?Q?pctkpD/1Akw9l0i6zxKIP8uoJ/VNtXlvvRt9v4mdn/t6PY+D8UTM3lcpL5Iq?=
 =?us-ascii?Q?Ub6JJpENwkqesxNxpFsJfggn6fvHyaFJM0CclOG1dpvCbhBuwjjke0i1gPUM?=
 =?us-ascii?Q?dUqAy43f9MtOq8q2Oudfq+IzHHTmyAP2oXo2QB56pJskLuIAcFgy/FRLKKxa?=
 =?us-ascii?Q?ci1616TEzui3ge3+8Aqd5f3S8/Vy61Ep9TtK1JRUrkgG2fUAizrGrT568Y03?=
 =?us-ascii?Q?STOypehXDtGkIwGxYE+eE7ohzzALLqlHb6A85qbAra/d33T6ndOj+7r4W1bB?=
 =?us-ascii?Q?oVBUKkdO1qJgf5SfIitPBnEDYDoQ3xu8LCk8fbI/iXmyqcG7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0f97de-8c1f-4169-dddc-08de5fb2f032
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:07.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEZ9NngOfNgtqJDLKJja6/icM95Uc9QLK5TyurZ5SsMr7RDgO075cpReRSPtExpv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11987-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ziy@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email]
X-Rspamd-Queue-Id: 307DFB6EA4
X-Rspamd-Action: no action

Current code uses folio_set_large_rmappable() on after-split folios, but
these folios should be treated as compound pages and converted to folios
with page_rmappable_folio().

This prepares for code separation of compound page and folio in a follow-up
commit.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44ff8a648afd..74ba076e3fc0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3558,10 +3558,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 * which needs correct compound_head().
 		 */
 		clear_compound_head(new_head);
-		if (new_order) {
+		if (new_order)
 			prep_compound_page(new_head, new_order);
-			folio_set_large_rmappable(new_folio);
-		}
+		page_rmappable_folio(new_head);
 
 		if (folio_test_young(folio))
 			folio_set_young(new_folio);
-- 
2.51.0


