Return-Path: <io-uring+bounces-11985-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id JpTtNuwqfGn1KwIAu9opvQ
	(envelope-from <io-uring+bounces-11985-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:52:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35855B6E80
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE636300E396
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 03:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D848720D4E9;
	Fri, 30 Jan 2026 03:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C17WvFnj"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551021F5437;
	Fri, 30 Jan 2026 03:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769745129; cv=fail; b=RXZfFui4ITdQaKkNyqyT5tS93qJZQVRZRxC6/GRd05Z1ZZvjFeOqYUKKBNciFBAEO5eJtxZgD/WGu+ZyxQF/7L2fWwUw1dMx31R+QIht60X/CLDdMLXkIcCHcch4XBTpFkFZ81XzpP7xv7E51LNy7Q41zSet+ymOL174kP+s74k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769745129; c=relaxed/simple;
	bh=dsxfmdmMR03yOibqk/vhF9VAkcMieZs843L3tx5wdHg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OYpgAAR93VprFUknQvKKIRTyxGyc4HBeH3EcFikVTArjVqihoPa616VdrmFvpoOQQb1EhWliS9zElr1cm6xBZZaSmYPIn0vcLD5Y1pZ4UKLTLKm/zSCZWVue2NxmOc/NTMgYTNZMNyvt+F0tliHcWHda/W9zSJdgmBOSNwcPjZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C17WvFnj; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mg5o85panGrkA5OS8zute15i2zqZ8iv8GycpnSDXn79/VSitWCw/X2XUn0tlugzb2G0hlQIr6yzb08/UTK4TylGk3EOpvu9NT2G9Q0RJx5l9uDva41clC61FDxWH7r2RduIV4GFrOWC/4TzPwzfU6aYlvMh0P5JiAZxK305FEYk0Xchv/eufiKxwSW4qYB3hnsfPP/zitWPB1sWxbRwxKUK+2UdIQDliX0uQPXDNvr3RDBJ1s04PPZ0UejP7dyaHzPnrlUoxpfjB/IVzuk2xDP5wPMkwYoeLIFlaKthjp7FJE07SdA5c2RHU+d6sQOs1iD7uA1kM5afU8MSVNjunSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNL9/Astls3whxLVdPXv45xRRjmYoYnaL8lRzk0um9A=;
 b=V3F9PvX1NL0ls+6S3aGAGIoRfgC1nASDQbboP/US4NOhgLI58Z9Rxa0LRieye23aiaQfJFv/IOJATPtbYeFRXvgUIROn/ThErrm0rGufI363bP+xxlddNRxnAkCCUPQ/H77x1slbqwipNLzHcKUnEr7FoDXSVIXnIKNG+xq1o2ZSwb8PVyjOZGRq8N5DhC7QAuhhGw+dvVVqaZ845P5VtAEITrDEujGTbRV234n6wyGZ/aI/6P1XYUc86tXjK3JBBJjwbNOAm6GQTyKMPQLHY6SaYYEWVsi/ZLQtQZtGY4xIaVd/JX7Bvgt2Da8X14duPFuVJOCa1aotAqoc7YUY4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNL9/Astls3whxLVdPXv45xRRjmYoYnaL8lRzk0um9A=;
 b=C17WvFnjlYwybFODO6QyUUe5TjiCbGLZ2kgPqLk72KG0roTak+NrVUF8MmgboGPZFw5/jEHIZsF9k9Rerso2W4pSjs5su5oDglaawz3WWrw9PSsEBXPgF7FBB9DICyofyxB6zcNYG1obQ1J2FXvDCXq2ISLN5LlKsaoCMrNnRjHtZlJYw//ZbsqRDWFtH/H3tEoom/5ni0yBQBJWhDOv+/+pRWLxeFJKbADXKnXNSSBiKsmAk6Sm8Y9nzCvzrPXPAfmhWHXncCRGSbEr2yM7xYdj9kkyeu8bHMYfRwubXTHI+fnDpMjua/Bnsl6/CwvvsbDMq1tGlBPsLtjDVY4S9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:04 +0000
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
Subject: [RFC PATCH 0/5] Separate compound page from folio
Date: Thu, 29 Jan 2026 22:48:13 -0500
Message-ID: <20260130034818.472804-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:36e::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: d4039194-0c7e-47b9-8474-08de5fb2ee6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QX0LQDXA3hRbmDY0vItO+5z0h7OnAN3NdHlw7Kwi3OKyn32CNOYyj5lZ3XVM?=
 =?us-ascii?Q?sSzMAHBbAsVPX7AB1+Q6kwJyaC8aAhAwpi0wu/mLB4Tpqb6pJfBWNTHVE4al?=
 =?us-ascii?Q?YW9idQCTNSJbZT4mTQmVcZf/htSoLY9D+g5Y9gnQkqi4JcDoVBRakXb8e0kQ?=
 =?us-ascii?Q?H7BsG3uCwqyztF/xqbzyI3PP2j/bVK+5jAhDI9iwsmGrfNCbfW4tuiiTB9Pb?=
 =?us-ascii?Q?caFngHQ9+J5JqH2Bxta0EbGJ7CUezJ+AWhR7CzJQ+BkckSmyhqkVVn/G7K+0?=
 =?us-ascii?Q?QwUuAeEwhIxiqkIP4TM4h24vMHMNvbQBHHqLqXjvlYJH4zzo24qDo0tYkkfU?=
 =?us-ascii?Q?5/CLxm2Dx6IuvCbRilNl50gkQRaiMQR5hatoWjeA+OCPF8P/utvUZ6sbGioD?=
 =?us-ascii?Q?1yEpTkZt3rsFb9EF4wMQYUnZ8ryRa5w4wmR+rqQQ0Y0+tew165CTtb/A9uq9?=
 =?us-ascii?Q?n72SuKwmoo0v/SMZ/1ffYzhfwU3a+XrR05VWS2hIdV4Sd7co91n6gdi9AAvJ?=
 =?us-ascii?Q?QM4oQRA16XxVoTUbYPld3bwJYqZ1yn8dLDbq8m9Y+3GgIwjchnBA2ZLJqiIj?=
 =?us-ascii?Q?TSa7jjFCRWBKDLm+OXJ02o8tHcAXetses0PB0Ai8N6mIrGcPZW09Os02JRRA?=
 =?us-ascii?Q?16Wldn2POIrp6uGLRDY4cw2LWgaepJ8gfY1ObCbn3aWQeaz88TKYziRtkFNA?=
 =?us-ascii?Q?4nmZxPCLObCb27RqYmfbWq/9tBWqYo/paG9/KDu4EXuZAxfQbQBhN7GagCb4?=
 =?us-ascii?Q?nG4QG1FiSlJUoLZeeCt1KkOLk/ObcLDdGqwzXCyaUdt4vH2/KNjz/qgB3nEH?=
 =?us-ascii?Q?gCbt1g9+gQnhy5KHGPg+lPbLZiyWiwkysQOlV8aoQC6syju6lQsqdkiSpsOJ?=
 =?us-ascii?Q?etERzYFzdUrjbl3WM9W3f9L+BL7x8FJuIkv/FJGGsFiHhKJyqFCadKX0osRl?=
 =?us-ascii?Q?XBMWikOWBYIIQX2jT9WfeTqS2FMdL3IgNeG2afnJHW1tAL/Qpwn2y78KEHwa?=
 =?us-ascii?Q?l2OUtFsrnMXK9S3oY7wiFZbEEdoCz/TqIaYXI4pZiwPFC19uYX0lREX56EQh?=
 =?us-ascii?Q?AMH9xQ0wJKC266a2VDKLW7YoZLssRMYb5APhRmV+qVG6sM7T92ElOoF15jbw?=
 =?us-ascii?Q?ClG8ejvZZiIBocyCDCYyB3VGKKk1+Uv9VDst4XHGQyfboclSzxhU5/EhxxS6?=
 =?us-ascii?Q?IBWRJbOgE8KdCYeU1hc5ptxKx6Pe7mX0L+ke8CX0Wo4oA1Y6B8XRDJTOzUCb?=
 =?us-ascii?Q?eV1U9huF8Y8FO+2i4DiaL1I0yt5VKs9P2qEJYmWJIbNsmdK2RAE88v0MW6rJ?=
 =?us-ascii?Q?Ft04aNiGdS/pnQXoRk1sVaJL0Ho+N0pMqUhX/WRTSojmyk0YAWkJRvhdVRn9?=
 =?us-ascii?Q?o/8bjB/lf62v8X4JcFcPGhYOZWMGxo3oPDZHbbQ6RvuuC3BXb4oH2Cj3I64y?=
 =?us-ascii?Q?aqgal0vF5inJJT/vlh/znc/cKCCfvkpyWlCo8QZY4F5CZRPMRClRNyffgh0D?=
 =?us-ascii?Q?9xDH6saAQnM3aytglT7qwVT39OejVVXCn2Hr/IQ5bgTJbavphcq/CX9i9C5Q?=
 =?us-ascii?Q?WPFiI//zy4/6yOFyP8Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QQmQIbocdO9PeoS+Rt0uLxdgEmKYT7dLxRIVs7YpbYeE/eCxf0O4bWAkPzct?=
 =?us-ascii?Q?6cau+9b1l5tGlQ+h2iKUhETt7KjS0P0YarniGMtCxS4qrDFHyidiT7tyUHtQ?=
 =?us-ascii?Q?pMn/JP9BBcvcXisPuPX5CmjzH9ke2wUBUde93kz7/upTgN8kTbo7J1aX9b5x?=
 =?us-ascii?Q?PXC6P34PIcGl7tSXOf1jLUjLkzMoSQy8mCfZ39J7wGW4v/FmPP6Ihe6l9HfG?=
 =?us-ascii?Q?rjTijJt2rz7dySCXVIzbO+M97bUy0Ra36XpKHGTWoa9SBceh76PHlgqYUh02?=
 =?us-ascii?Q?pBeTk3lHuoWXCMioPZFSXO+/G4otAahrctiyP8pwEmUJMrQqmwCy4GasYoTa?=
 =?us-ascii?Q?8ovZjtABtX2Jg98q5HL0v4CtL/MfuLmX4MXLeA9qkxdPKNefffXPYNATDVnN?=
 =?us-ascii?Q?jBswufhpkkXEB6hkRfW4pwwyHYVnAQ9BLl5id05WoqnJQkKULhIWOcbazZ+c?=
 =?us-ascii?Q?tlELSGdW4ZtyeUgIhkvy8nVFE8Unj2ia4fz1ATnx+gPqtrL6kRPVceaIDAVg?=
 =?us-ascii?Q?kwWOBBP4aemjO4yzdZ/DGhnvQejnN8agZoFTShCrsKtwBMOs8ZiPwNjpR8WE?=
 =?us-ascii?Q?edqo6oAasHb/aN6UCCgFE4Ifyd5yuBYMgvUrzvRlNhSIUT6W625x1n3SLktV?=
 =?us-ascii?Q?1gz8VRstP7LOfH105hBpRgT+nP1HvrHR0Pmbl1ZR2HilC3E4+CyP8bbAHxFy?=
 =?us-ascii?Q?gLg0wilEqhiwMBYcqU+p5eU1Bck3pw/lHX2c9s39c4+khRvrMM2Vy3Uu35EB?=
 =?us-ascii?Q?55JrIpIOOq1pKDh5a+hFJjy0XoT35FLGSIAWRe6NbeiBX8StTqyeJjXkzvKf?=
 =?us-ascii?Q?7X2a63UgmkHUruZcTnP2VmMGkQk/oAGpwLj5GY+Ohay4+5dK8vJzR5AlicEE?=
 =?us-ascii?Q?QFQAEpqPhXK3IGq3l7F58qdZVO7rCVmy65qyxVvNka3L7s8brmjqfuJg0wUL?=
 =?us-ascii?Q?fqYWCd6WBYtIz8KOuP7OS+45DNy53fh3fScBDM9X8PCHjhVYybEjF4EJ2LvK?=
 =?us-ascii?Q?TVDIZk47hodalJ2ARs4opBaTvEGCJuBLj2AQ0CYtmy/LM6p7GvwgTiIBN9n+?=
 =?us-ascii?Q?GXRDUCpgYq8fZLu84pJ2a0jp1byX1kuvOJwtuPdTCeZVQKGQ/lfXD4mZF7Mi?=
 =?us-ascii?Q?Ba2DYdax0PHIixsq+bnxy1hLaXpLrK3CNEV3nAHi/C6CWu+N+zEl+sZh3JDr?=
 =?us-ascii?Q?jbWg0HNKtD92Mg6K3lb1qhguT33cpDLtcCCY94fUKGrDqa3H92h0no5pDODf?=
 =?us-ascii?Q?9QXtkvLQ6kemUbXNyJPtvqVBfHolHMfWTT+Jt+61lrKdHh7GxpLsKLh2113E?=
 =?us-ascii?Q?ZQ3Yrevv7TL1E8xJ/YttmetuejiOIF16rWAgSvwyUnf4ebPGEFaIAlUnycjT?=
 =?us-ascii?Q?DJwX2CWtKRMICiaOXbgyQAdPL8BBwNu3mPuUGr4DYC7skKTZtiT0LTJCXHX5?=
 =?us-ascii?Q?YeXiTK22I1rrH5LZgz9sD5ON88kqb9tN4fCiyQpquLTqkSBDEOaX4zBwJZEW?=
 =?us-ascii?Q?hIQugEgft+jqcEONSaLmJbhUFht721rCndF0D7zerrbtqpjZJMMs+ScWb9bC?=
 =?us-ascii?Q?IpEr9LWhug5d5Cocp96qjgZ8GOgFRp9z20ThS6uuvvrFQQ+L2i6yFtyMkV6F?=
 =?us-ascii?Q?rWgE76KmV9X0wZC4eSHEzEE6FiMwH2IJdZ2iOaGcrFkEzOc+I1ahVMvC6SCk?=
 =?us-ascii?Q?S/2NVm8MxWWAlAHt10vZIus2MhBfukViySjVroI2zJ9HiwIg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4039194-0c7e-47b9-8474-08de5fb2ee6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:04.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LfAYg4sGgD11vueTDpxN2N/S7tdYEiIBRoAp8vpTN8+tlxB6l/mf9tF8FZPsKSS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11985-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 35855B6E80
X-Rspamd-Action: no action

Hi all,

Based on my discussion with Jason about device private folio
reinitialization[1], I realize that the concepts of compound page and folio
are mixed together and confusing, as people think a compound page is equal
to a folio. This is not true, since a compound page means a group of
pages is managed as a whole and it can be something other than a folio,
for example, a slab page. To avoid further confusing people, this
patchset separates compound page from folio by moving any folio related
code out of compound page functions.

The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
passed.

The key change is that a compound page no longer sets:
1. folio->_nr_pages,
2. folio->_large_mapcount,
3. folio->_nr_pages_mapped,
4. folio->_mm_ids,
5. folio->_mm_id_mapcount,
6. folio->_pincount,
7. folio->_entire_mapcount,
8. folio->_deferred_list.

Since these fields are only used by folios that are rmappable. The code
setting these fields is moved to page_rmappable_folio(). To make the
code move, this patchset also needs to changes several places, where
folio and compound page are used interchangably or unusual folio use:

1. in io_mem_alloc_compound(), a compound page is allocated, but later
   it is mapped via vm_insert_pages() like a rmappable folio;
2. __split_folio_to_order() sets large_rmappable flag directly instead
   of using page_rmappable_folio() for after-split folios;
3. hugetlb unsets large_rmappable to escape deferred_list unqueue
   operation.

At last, the page freeing path is also changed to have different checks
for compound page and folio.

One thing to note is that for compound page, I do not store compound
order in folio->_nr_pages, which overlaps with page[1].memcg_data and
use 1 << compound_order() instead, since I do not want to add a new
union to struct page and compound_nr() is not as widely used as
folio_nr_pages(). But let me know if there is a performance concern for
this.

Comments and suggestions are welcome.



Link: https://lore.kernel.org/all/F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com/ [1]

Zi Yan (5):
  io_uring: allocate folio in io_mem_alloc_compound() and function
    rename
  mm/huge_memory: use page_rmappable_folio() to convert after-split
    folios
  mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list
    handling
  mm: only use struct page in compound_nr() and compound_order()
  mm: code separation for compound page and folio

 include/linux/mm.h | 12 ++++--------
 io_uring/memmap.c  | 12 ++++++------
 mm/huge_memory.c   |  5 ++---
 mm/hugetlb.c       |  8 ++++----
 mm/hugetlb_cma.c   |  2 +-
 mm/internal.h      | 47 +++++++++++++++++++++++++++-------------------
 mm/mm_init.c       |  2 +-
 mm/page_alloc.c    | 23 ++++++++++++++++++-----
 8 files changed, 64 insertions(+), 47 deletions(-)

-- 
2.51.0


