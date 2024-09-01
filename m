Return-Path: <io-uring+bounces-2997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC9F9676AE
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D44E281B9E
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815D061FEB;
	Sun,  1 Sep 2024 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Bgpmkght"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA17617E009;
	Sun,  1 Sep 2024 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197842; cv=fail; b=tZXwS1T2ZmL3L4fqknp69sE0vNt1MiUEYBp3iFlZJcX4qBtYHjxWyqEAWH2aB64UgF9XCJd83SjB6j6/8qb49e91OLKXlWiazPiRyjG/3nf/jyFPXE3frwioTiAKQC8DLKlBA8pVrMxIjvZdZQ4bWY83O6VUyGHFslpBt7eDdOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197842; c=relaxed/simple;
	bh=w3I2I81oijYHRhDrNbBhBfrVu52q84THeahpP/fjLaQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ID8Ehun4RXkDqRJhV5eBYFtLNnAkagLMiKP3l1mCenSLVg9K3dwm0fsK1csbp891Jnc19HknOhiwp0JZ4GgNu5f/J9BHvb5Cgx6J5DNZ4Mu+9ATznVbwOftrMWY44+77y/aWVoDXfC/LOL9juPOq0uApvZeLV/w0xUTDSry1IUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Bgpmkght; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170]) by mx-outbound40-32.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=frQBPn/QjogOqGLNPfk8PveN1SJXS+URZDKnl+XlE7UgoPJ6gl3tHloqSe2O95M2MGB0CXI+UI+l+SMWq2yDDg6F5P0uYTW1NhYWhdn3Z36wO2soT9ar++bJ3GeltozNi/nBay4h8nhsYS+chYVSQsRz7xGOf7yJ6V9Bb02LLQ3XhITpjtUpteGRVOiBf2BX3iFnUoqBEkfAY/wlWZv3yEBy8u18q6SJyZMSbiUpKJz9I8gSyiw+lnl+Ac44Ayh8xDUE5iC3re77dtdcPHNd4Ge8h5AFvOlVr5Frgdebu72t8mSF0jbkURkZeNXqenJslXOm/FnVeNXPY6EKwBW0OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6q5S1PNJl48cu+U85QaUzCSaX5qozR8G53hTnF9P3g=;
 b=trVFwdnYM0ezKrMom4Wc8il/dmmmL/L4PaFMAG4nQoS8oXXzSRcQiRb/VKaeg5XTf5M7ZYyrkoBrPW283CyxdHOYAVyVnN83xnbohscnv9CMmWbxTHeh11ggZZTF4EPrfo9SHLDcpC+z+Fl67zOBXNGYtA718v3qo+ML8lHwsTNO7WnXPSbj4dhsCbx3sURVgXI8xSXNFZDwrKLNFdSMfDjDGvQ8KaAHq8c7y+Ae9WPW+mp8OcAdPGO62XuW0nRSGBnZD7oTffqSukcuJzwzYcVwtA4pjm4eRY4WGV0Mw88tefUjPpmlIU8mzD0mQnHBzs4qlrBpCdzgtfAjMrFLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6q5S1PNJl48cu+U85QaUzCSaX5qozR8G53hTnF9P3g=;
 b=BgpmkghtlUB5ZM5KzImu91OTxYb8tRU2fqHwQO6jSmrk5UDHl5abKmgG0DvBItsDP/Xn09+FAHotYNTXE7t2d5eRZw0zcXWwyIX7MzhiuLy6VpyDCXSUoELPMu27UniO4FaYKU2RN+1/JMIzK2V8u7YCBm3WbDwJYKoBNrPTHUE=
Received: from SJ0PR05CA0102.namprd05.prod.outlook.com (2603:10b6:a03:334::17)
 by SA3PR19MB7745.namprd19.prod.outlook.com (2603:10b6:806:2f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:05 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::68) by SJ0PR05CA0102.outlook.office365.com
 (2603:10b6:a03:334::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:04 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 867E5D0;
	Sun,  1 Sep 2024 13:37:02 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:36:59 +0200
Subject: [PATCH RFC v3 05/17] fuse: Add a uring config ioctl
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-5-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=13754;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=w3I2I81oijYHRhDrNbBhBfrVu52q84THeahpP/fjLaQ=;
 b=/K8gosAsXvI7UaDTjoC9nRznWvvKbvhrobM5fPl3mMhvYllgyItXheW4y97lmXnDf4MiSqD3Z
 icz4wi0TwXLCoQeveqqBWSBNBx9M4nW1L3T6AQ6bX4KVMcmHaPuCiD0
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|SA3PR19MB7745:EE_
X-MS-Office365-Filtering-Correlation-Id: c1eaa820-f106-4d04-af00-08dcca8b2a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFE4T3BJczJDYzdmemEyZzN2UGJKeER2V1dYTEQ1d25PWXFjM2lpdng5SWxW?=
 =?utf-8?B?UFJJTURzQlNUQXZzc3FFcm92Szd3aG1QWEV2cTBSVXBCc09jNkhmUUUreVhT?=
 =?utf-8?B?NTlUcFBxREp3djZLdjgvMlMvZkZLL1FCV0UvbE5DTXd6Yi9VdHpoK2RjWFU5?=
 =?utf-8?B?M3I1a2UrWkFjVWRsVWkwWVA1OG5wS055a0ZQWldpczBTSHVhajdiVkhXbWEv?=
 =?utf-8?B?UXUwTG5jYmdiZy9kd3lTTGpXVGJCWC9oWDlFVWFFL2Nvdzk2YXYvU1JscEhh?=
 =?utf-8?B?S1JLT2pzZlFWMVBTbVp3dkk0Wm1Od1RicUhDeUtqRzMvVUhUOUp6Z21FbEI4?=
 =?utf-8?B?RVowZkVVeXBNclF2ZWpGUXR5WG1DM1JBWDdoQkZZcm5rU2R3ZVczTE9Uc2FI?=
 =?utf-8?B?SGNpMnAvY0VmbjdtcmU0VmlIajFBU1dVcGpiV1NYZGhpRVI4TjFiMzI1L2tZ?=
 =?utf-8?B?NHNSNFM4V29jQlVCK1MrbURHQ05qTzV6SGdQNUt4SThtUUIzRHpEYWxCcGVL?=
 =?utf-8?B?SHNxMUsyZ0VxWEJZZDhUNkI2eE9na1ptTWhnZndWdjU3RlJIS3NPai9tZFM0?=
 =?utf-8?B?NVZqMGhIOHdJSXRCVzdwR1MxZHNEWW4zalY3VjdOWldsenFsNFRDNkNZam5I?=
 =?utf-8?B?V3FCYjBwZzVOKy9ZbnZ2UHRrVm1UYkhYSzZiU3ZsNG5rMExtbEprcjUvVlZ2?=
 =?utf-8?B?dGZaRW5iRWwxK2xLM29qRUdaN25sYkZJTFNWcFdSV1Q0dUErR0l0SGd0QWVv?=
 =?utf-8?B?Q2JEY1V5N2F5RitYSGI5MHV2TjIxM0ZpVytqZVBQeC9WTDJQZHJlam1wSU9p?=
 =?utf-8?B?YW5MTFJJckhPSWZEdnBxSUdWd210NXdHWEZTK2lRMUVXNmQ0OXdIcUpXaHY1?=
 =?utf-8?B?bE83T3ZiWUdCVG1SMm5mVXVaM1FMVTQrVjFzNUtRUWpLSkVEbFc2VmpFckVH?=
 =?utf-8?B?dEZHV08vMm5kbVlaTlZpTWxrYitodGR0czNlOUFQL0s2Wk1PSGlRai85NnZr?=
 =?utf-8?B?YjB4eUlldllRS0ZkMnFzR1lQSW9aS3BQbWlHQkVUcEttQVpjbnFIK2RyOHVj?=
 =?utf-8?B?T0l6VzY2UC9MOWJFOW1oekNJT2NnbFdWZHBIOEwwUHhWQ0RHUEQxRlFwdWFS?=
 =?utf-8?B?d1lrVVpEYlRjUG4vdkVFWVJxT2RLQnFyMk5zOHQxd1dFT2VTTzNxYXl5QXFz?=
 =?utf-8?B?TjdlejdubXJCRXhJU0oxMC85aHBOaStjc1cybG5OQ3pFM0RFVTZYbTlLOEpl?=
 =?utf-8?B?UG9FcDhpUXBJQ25QWHBLaFpmazFpREhZbE4yQXRUellpS0NvUCsxUmdSczVl?=
 =?utf-8?B?eFFvSE14a1JlQUNtZmREc2orTEhtWEtqMTBGK3B3NFFuWU4rU0Z3YnRlM1ZM?=
 =?utf-8?B?TVlFUzQ2T01TTHJrSkIvbjNMWGVVTVh2QTBnVzZZOFQ4YnlGUTQyNlpGYkxB?=
 =?utf-8?B?cWZlK2FmRlg1TzBrQVc4Q1hxVVdGM3hjR0tpUFIydEZ4aCt1aUdqMWtmd3Z2?=
 =?utf-8?B?UWNzRSsxSTFtTnZVclZZekJEVnhON0RwQ1NyR0N2ZlpSc1QzdE1hbWNTcmFy?=
 =?utf-8?B?SkhFOS9ta0RBNGJyZytGRFVwZFpqc0I1akllU3ByY1VQdGRBVUNLR2t0cEZq?=
 =?utf-8?B?a1dFYUNGcmVQZXZ5UmRFOHg3T0hQL01sRXQ4bHhQeWc3WERvc2Iyb2Q4OUN4?=
 =?utf-8?B?ajgzRDl3K29PZWNOUWJ1VzVxY3dIK3h6L0pHN2VTOGFBdHRmK2ZLanBhUGF3?=
 =?utf-8?B?dWpwM1A2NWlKZ0doaFVraEZ0RFZWNWlFRWNsZ1l2aHRhZUJIaWVLMmlUVXNy?=
 =?utf-8?B?YlluQ1dSNFRZOFcxaklnRHFGcVo3aUdjV2hZamRrUnFoSi90WCtLTHA0TkJa?=
 =?utf-8?B?TkVNcUlXSzY5ZGZrb2c5dGRPTUdIOWh2Z1ZLU3hxZGV6RTRhSEMwQXh4cWRv?=
 =?utf-8?Q?qVdwdQTdp8bEQi0QKAhY6TcUx9UnA7fD?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2i//iVNPFLzMfJWz/EHZ8ZoBeyJS/SUIcjFFPFdSWNBxfIFGR1+zGmOlZaH0uHgKCuhpkKl8VdBYNiYyj+wmXknWFDLolBGyroGW5A94AooDhU57egWQY2tVr+tCA2qDhzUT6790HrJuRuNyc3u6wLf1hREemKH1raAozErnWxF2HWLYFZc9QCiFfYTpQ1sDn40/4I08iO9dYUMtIIZqn9xNrrrkPLCMKqxSX/JapnWRkuEho+xJjQU8rxkzutw7uZJNgdEV2BqYR1RdbgQgwn5V3i5Y1bJ2wkv+p8kTBz945V9tXfXyfq5MOxoqxIy2Z1h4h1i0lq/glsYThAtOY52tfl7ptL89N+U5RfB0jz0GyJmErWBI4nxE4fsPn4NDBr27CmmmN2FV3aR+vxaZYrQfJKFwvJzqaoY7APHwgi95N7nludDqUdz5LR5io52BzdwKEK9dT/n7Hy0Pv0mE+l+Gq9rwrLpAwZqa/I4frOcQBpTadPeo6Po7Pm0B4FMGHLN6hzliOBrl7yL53FqEAc3h06A23ZmOYMcNBqKbRG6fgfXjbg6c2Oykb9WI6lJHGNrJ5yXLD3VnlBWY+SicYw2WXT/2jvH33CgZ7ejXsxg/UcgPblaM+a1h67Jrg/oLxyHXkFGvyCflMQJ0h2THNw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:04.3072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eaa820-f106-4d04-af00-08dcca8b2a9d
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB7745
X-BESS-ID: 1725197828-110272-12687-2086-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.55.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGRsYmQGYGUDQ1yTzV2MwkzS
	I1JdXQ1DLVPMnEyMwkOcnIyNDY1DDNUKk2FgAk3zLWQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan17-160.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This only adds the initial ioctl for basic fuse-uring initialization.
More ioctl types will be added later to initialize queues.

This also adds data structures needed or initialized by the ioctl
command and that will be used later.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/Kconfig           |  12 ++++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev.c             |  33 ++++++++---
 fs/fuse/dev_uring.c       | 141 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 113 +++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_dev_i.h      |   1 +
 fs/fuse/fuse_i.h          |   5 ++
 fs/fuse/inode.c           |   3 +
 include/uapi/linux/fuse.h |  47 ++++++++++++++++
 9 files changed, 349 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 8674dbfbe59d..11f37cefc94b 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
 	  to be performed directly on a backing file.
 
 	  If you want to allow passthrough operations, answer Y.
+
+config FUSE_IO_URING
+	bool "FUSE communication over io-uring"
+	default y
+	depends on FUSE_FS
+	depends on IO_URING
+	help
+	  This allows sending FUSE requests over the IO uring interface and
+          also adds request core affinity.
+
+	  If you want to allow fuse server/client communication through io-uring,
+	  answer Y
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 6e0228c6d0cb..7193a14374fd 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -11,5 +11,6 @@ fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
 fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
 fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
+fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index dbc222f9b0f0..6489179e7260 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -8,6 +8,7 @@
 
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -26,6 +27,13 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
+#ifdef CONFIG_FUSE_IO_URING
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable uring userspace communication through uring.");
+#endif
+
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
@@ -2298,16 +2306,12 @@ static int fuse_device_clone(struct fuse_conn *fc, struct file *new)
 	return 0;
 }
 
-static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
+static long _fuse_dev_ioctl_clone(struct file *file, int oldfd)
 {
 	int res;
-	int oldfd;
 	struct fuse_dev *fud = NULL;
 	struct fd f;
 
-	if (get_user(oldfd, argp))
-		return -EFAULT;
-
 	f = fdget(oldfd);
 	if (!f.file)
 		return -EINVAL;
@@ -2330,6 +2334,16 @@ static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
 	return res;
 }
 
+static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
+{
+	int oldfd;
+
+	if (get_user(oldfd, argp))
+		return -EFAULT;
+
+	return _fuse_dev_ioctl_clone(file, oldfd);
+}
+
 static long fuse_dev_ioctl_backing_open(struct file *file,
 					struct fuse_backing_map __user *argp)
 {
@@ -2365,8 +2379,9 @@ static long fuse_dev_ioctl_backing_close(struct file *file, __u32 __user *argp)
 	return fuse_backing_close(fud->fc, backing_id);
 }
 
-static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
-			   unsigned long arg)
+static long
+fuse_dev_ioctl(struct file *file, unsigned int cmd,
+	       unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 
@@ -2380,6 +2395,10 @@ static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
 	case FUSE_DEV_IOC_BACKING_CLOSE:
 		return fuse_dev_ioctl_backing_close(file, argp);
 
+#ifdef CONFIG_FUSE_IO_URING
+	case FUSE_DEV_IOC_URING_CFG:
+		return fuse_uring_conn_cfg(file, argp);
+#endif
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
new file mode 100644
index 000000000000..4e7518ef6527
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#include "fuse_dev_i.h"
+#include "fuse_i.h"
+#include "dev_uring_i.h"
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/sched/signal.h>
+#include <linux/uio.h>
+#include <linux/miscdevice.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/pipe_fs_i.h>
+#include <linux/swap.h>
+#include <linux/splice.h>
+#include <linux/sched.h>
+#include <linux/io_uring.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
+#include <linux/topology.h>
+#include <linux/io_uring/cmd.h>
+
+static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
+				 struct fuse_ring *ring)
+{
+	int tag;
+
+	queue->qid = qid;
+	queue->ring = ring;
+
+	for (tag = 0; tag < ring->queue_depth; tag++) {
+		struct fuse_ring_ent *ent = &queue->ring_ent[tag];
+
+		ent->queue = queue;
+		ent->tag = tag;
+	}
+}
+
+static int _fuse_uring_conn_cfg(struct fuse_ring_config *rcfg,
+				struct fuse_conn *fc, struct fuse_ring *ring,
+				size_t queue_sz)
+{
+	ring->numa_aware = rcfg->numa_aware;
+	ring->nr_queues = rcfg->nr_queues;
+	ring->per_core_queue = rcfg->nr_queues > 1;
+
+	ring->max_nr_sync = rcfg->sync_queue_depth;
+	ring->max_nr_async = rcfg->async_queue_depth;
+	ring->queue_depth = ring->max_nr_sync + ring->max_nr_async;
+
+	ring->req_buf_sz = rcfg->user_req_buf_sz;
+
+	ring->queue_size = queue_sz;
+
+	fc->ring = ring;
+	ring->fc = fc;
+
+	return 0;
+}
+
+static int fuse_uring_cfg_sanity(struct fuse_ring_config *rcfg)
+{
+	if (rcfg->nr_queues == 0) {
+		pr_info("zero number of queues is invalid.\n");
+		return -EINVAL;
+	}
+
+	if (rcfg->nr_queues > 1 && rcfg->nr_queues != num_present_cpus()) {
+		pr_info("nr-queues (%d) does not match nr-cores (%d).\n",
+			rcfg->nr_queues, num_present_cpus());
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+int fuse_uring_conn_cfg(struct file *file, void __user *argp)
+{
+	struct fuse_ring_config rcfg;
+	int res;
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	struct fuse_ring *ring = NULL;
+	struct fuse_ring_queue *queue;
+	int qid;
+
+	res = copy_from_user(&rcfg, (void *)argp, sizeof(rcfg));
+	if (res != 0)
+		return -EFAULT;
+	res = fuse_uring_cfg_sanity(&rcfg);
+	if (res != 0)
+		return res;
+
+	fud = fuse_get_dev(file);
+	if (fud == NULL)
+		return -ENODEV;
+	fc = fud->fc;
+
+	if (fc->ring == NULL) {
+		size_t queue_depth = rcfg.async_queue_depth +
+				     rcfg.sync_queue_depth;
+		size_t queue_sz = sizeof(struct fuse_ring_queue) +
+				  sizeof(struct fuse_ring_ent) * queue_depth;
+
+		ring = kvzalloc(sizeof(*fc->ring) + queue_sz * rcfg.nr_queues,
+				GFP_KERNEL_ACCOUNT);
+		if (ring == NULL)
+			return -ENOMEM;
+
+		spin_lock(&fc->lock);
+		if (fc->ring == NULL)
+			res = _fuse_uring_conn_cfg(&rcfg, fc, ring, queue_sz);
+		else
+			res = -EALREADY;
+		spin_unlock(&fc->lock);
+		if (res != 0)
+			goto err;
+	}
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		queue = fuse_uring_get_queue(ring, qid);
+		fuse_uring_queue_cfg(queue, qid, ring);
+	}
+
+	return 0;
+err:
+	kvfree(ring);
+	return res;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
new file mode 100644
index 000000000000..d4eff87bcd1f
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#ifndef _FS_FUSE_DEV_URING_I_H
+#define _FS_FUSE_DEV_URING_I_H
+
+#include "fuse_i.h"
+
+#ifdef CONFIG_FUSE_IO_URING
+
+/* IORING_MAX_ENTRIES */
+#define FUSE_URING_MAX_QUEUE_DEPTH 32768
+
+/* A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* back pointer */
+	struct fuse_ring_queue *queue;
+
+	/* array index in the ring-queue */
+	unsigned int tag;
+};
+
+struct fuse_ring_queue {
+	/*
+	 * back pointer to the main fuse uring structure that holds this
+	 * queue
+	 */
+	struct fuse_ring *ring;
+
+	/* queue id, typically also corresponds to the cpu core */
+	unsigned int qid;
+
+	/* size depends on queue depth */
+	struct fuse_ring_ent ring_ent[] ____cacheline_aligned_in_smp;
+};
+
+/**
+ * Describes if uring is for communication and holds alls the data needed
+ * for uring communication
+ */
+struct fuse_ring {
+	/* back pointer */
+	struct fuse_conn *fc;
+
+	/* number of ring queues */
+	size_t nr_queues;
+
+	/* number of entries per queue */
+	size_t queue_depth;
+
+	/* req_arg_len + sizeof(struct fuse_req) */
+	size_t req_buf_sz;
+
+	/* max number of background requests per queue */
+	size_t max_nr_async;
+
+	/* max number of foreground requests */
+	size_t max_nr_sync;
+
+	/* size of struct fuse_ring_queue + queue-depth * entry-size */
+	size_t queue_size;
+
+	/* one queue per core or a single queue only ? */
+	unsigned int per_core_queue : 1;
+
+	/* numa aware memory allocation */
+	unsigned int numa_aware : 1;
+
+	struct fuse_ring_queue queues[] ____cacheline_aligned_in_smp;
+};
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
+int fuse_uring_conn_cfg(struct file *file, void __user *argp);
+
+static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
+{
+	if (fc->ring == NULL)
+		return;
+
+	kvfree(fc->ring);
+	fc->ring = NULL;
+}
+
+static inline struct fuse_ring_queue *
+fuse_uring_get_queue(struct fuse_ring *ring, int qid)
+{
+	char *ptr = (char *)ring->queues;
+
+	if (WARN_ON(qid > ring->nr_queues))
+		qid = 0;
+
+	return (struct fuse_ring_queue *)(ptr + qid * ring->queue_size);
+}
+
+#else /* CONFIG_FUSE_IO_URING */
+
+struct fuse_ring;
+
+static inline void fuse_uring_conn_init(struct fuse_ring *ring,
+					struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
+{
+}
+
+#endif /* CONFIG_FUSE_IO_URING */
+
+#endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 6c506f040d5f..e6289bafb788 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -7,6 +7,7 @@
 #define _FS_FUSE_DEV_I_H
 
 #include <linux/types.h>
+#include <linux/fs.h>
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f23919610313..33e81b895fee 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -917,6 +917,11 @@ struct fuse_conn {
 	/** IDR for backing files ids */
 	struct idr backing_files_map;
 #endif
+
+#ifdef CONFIG_FUSE_IO_URING
+	/**  uring connection information*/
+	struct fuse_ring *ring;
+#endif
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 99e44ea7d875..33a080b24d65 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -947,6 +948,8 @@ static void delayed_release(struct rcu_head *p)
 {
 	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
 
+	fuse_uring_conn_destruct(fc);
+
 	put_user_ns(fc->user_ns);
 	fc->release(fc);
 }
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index d08b99d60f6f..a1c35e0338f0 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1079,12 +1079,53 @@ struct fuse_backing_map {
 	uint64_t	padding;
 };
 
+enum fuse_uring_ioctl_cmd {
+	/* not correctly initialized when set */
+	FUSE_URING_IOCTL_CMD_INVALID    = 0,
+
+	/* Ioctl to prepare communucation with io-uring */
+	FUSE_URING_IOCTL_CMD_RING_CFG   = 1,
+
+	/* Ring queue configuration ioctl */
+	FUSE_URING_IOCTL_CMD_QUEUE_CFG  = 2,
+};
+
+enum fuse_uring_cfg_flags {
+	/* server/daemon side requests numa awareness */
+	FUSE_URING_WANT_NUMA = 1ul << 0,
+};
+
+struct fuse_ring_config {
+	/* number of queues */
+	uint32_t nr_queues;
+
+	/* number of foreground entries per queue */
+	uint32_t sync_queue_depth;
+
+	/* number of background entries per queue */
+	uint32_t async_queue_depth;
+
+	/*
+	 * buffer size userspace allocated per request buffer
+	 * from the mmaped queue buffer
+	 */
+	uint32_t user_req_buf_sz;
+
+	/* ring config flags */
+	uint64_t numa_aware:1;
+
+	/* for future extensions */
+	uint8_t padding[64];
+};
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
 #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
 #define FUSE_DEV_IOC_BACKING_OPEN	_IOW(FUSE_DEV_IOC_MAGIC, 1, \
 					     struct fuse_backing_map)
 #define FUSE_DEV_IOC_BACKING_CLOSE	_IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
+#define FUSE_DEV_IOC_URING_CFG		_IOR(FUSE_DEV_IOC_MAGIC, 3, \
+					     struct fuse_ring_config)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
@@ -1186,4 +1227,10 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_RING_HEADER_BUF_SIZE 4096
+#define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


