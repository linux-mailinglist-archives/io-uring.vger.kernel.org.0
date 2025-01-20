Return-Path: <io-uring+bounces-6011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69406A164ED
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89B763A183A
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB9341C69;
	Mon, 20 Jan 2025 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="erVbX0CH"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DC1182D9;
	Mon, 20 Jan 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336572; cv=fail; b=X71Lmff3nWSG89HPpr7wevrel3kLZ2eXrch+qzxkl2SyOf12N91GAgFQ0QLLCtMpwzb33u+KXIS035kqFAJQJkM6gh2N7i/+PASf2RseDw/cmTklWE9VybYjKDrUJcIfUCkWjjaLONQQXOrw0Ezgx+tDx+RxHWNED/2fuEOFocw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336572; c=relaxed/simple;
	bh=S+7ysY0RTzuYdjULXHC7D+qIvtVYjfUhKMKcTmQRIq8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=IjQmMOAybU18MQlFoFKPULkC7Lww1dgt6ZG7hP/edGil/iNuw6fd/p4vc3m/Hrh2rf15DzcmCa/XV+QfksyvNVI8kWdwTtzaKQgQly3r/3Ig3E6IHJwpyhlZOVPMlUBLnj1tW8Dby46i7rt0k8OjkNMNbmSCMONR6AXXiPhPX4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=erVbX0CH; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40]) by mx-outbound43-175.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnRG0URaYDtZDKpapEmrh3f5eAJOCESlynrBXDjP4cLhEPMQhkVyL4lYZP9ySW/9kpRj1ZAolk9Kpld4v0Xxhow6VwObBR0sBwuYq1qOMEGs4DqW4uAsmf7L0ZvjJYQ8EmFJXgdl0KCPS8q8+kObtMkX0egIuTSAYEDMARTuyw78WwB80VkrPMw+t/UkVvg1rvtaF62pw5MB+KeFRjiUgaGWO6RV8s7JIhJxmSiIE1gRA+2VyzLQhDQpw8aiD/U/npSZe+gU2hvb731q+EGOr5nqGjtdmtogkj8KzIaWvczbh+ZB35ffXkWqadM7M0WH8iLUrftnC4rVrWc3hAQQAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pJqgWKPrsE/F8nFiUcG32KiNEnO/Aq3p64DCxkgh0I=;
 b=lV3L3O4kzDz5zgpfjqp0dlSqe92Rhg1hM1LbEXlzAque+SWltsv1JvpgcrGYFTS+ntHr3NmE75BqhsXdPyUTTo417eauiHxWqQnsl7jLYLt2ELgSG6wVsfS/xGkSZXgJHVqDrFhqdicQTUBw2as4FXiHrRaDwPt+64sxKdFjxYoI6FNINrqEawrh0QZs2oU93Hzrj1GJd+KyPiVRh/EKYwNC52bm9pnGQ2n13d5BcaLrgdISwS/jypcpENlBQtK4MtvWeEZ/G27jlrguACa8lgHr1IJ3bCKSfah2WhaDhu/FGLujoVI0ljI85tiIp4W6AZ4X+iRlx2CCauez5d2lug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pJqgWKPrsE/F8nFiUcG32KiNEnO/Aq3p64DCxkgh0I=;
 b=erVbX0CHI1WR4ndk/hfxh8m0IugBnhTnSfhyeoaiUiUqboibPRv8Y5cx9SLnqGv28o5qPEjU6sGy8HOq5vDN8D+3vNH3HSgN5PwrGqDoqjaWIJPpjr7JTSXdHT8l12GZqG4AyTrD9ONkg50QYtcDbUE1KumcZezKzoRIHAWK5wY=
Received: from SN6PR16CA0057.namprd16.prod.outlook.com (2603:10b6:805:ca::34)
 by MW3PR19MB4361.namprd19.prod.outlook.com (2603:10b6:303:47::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:03 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:805:ca:cafe::76) by SN6PR16CA0057.outlook.office365.com
 (2603:10b6:805:ca::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.16 via Frontend Transport; Mon,
 20 Jan 2025 01:29:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:02 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id CFAE034;
	Mon, 20 Jan 2025 01:29:01 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH v10 00/17] fuse: fuse-over-io-uring
Date: Mon, 20 Jan 2025 02:28:53 +0100
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANWmjWcC/33QPW7DMAwF4KsEnsuCkmVKzNR7FB1k/cQaYgdy4
 rYIcvfKRpvEQz2SwPv4pGs1hpzCWO131yqHKY1p6Msg8GVXuc72hwDJl0UlUSqBooF4GQNccuo
 PEIcMBAIhR6eAhMfoyDQimqrETznE9LXY7x9l7tJ4HvL3cmpS83ZBkVFAq57dwk01fKZzN1zOc
 DzaE5QZgSXqqGsWSqk37/tXNxznS7/d6P9uk5rjJep0UxNRuMfnZlNzbyME6g2mKUwwRGi5tGB
 eM/TESLnBUGGkCeS8x1CgNaOfma02en5UrdraErfW2TVjHoxE3mBMYTxHjpKUbEO9ZviPaXD7b
 3hu47ShyFZb9g/mdrv9AGUlOU1pAgAA
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=14552;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=S+7ysY0RTzuYdjULXHC7D+qIvtVYjfUhKMKcTmQRIq8=;
 b=+nY3d+Rd2Ze2K7cxo3WoRBI8HeUEMXPI7pWmcEXsUOW008123MqpYWvOUs5YALpa+8PLiHe0o
 JCHiRrQQxHBCPOrOzr9LwDojBOjHc6ftnKoHu0zXlcsLPBCT/aEFMgL
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|MW3PR19MB4361:EE_
X-MS-Office365-Filtering-Correlation-Id: 21a2afb4-6592-4790-7b1a-08dd38f1d275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzNRQVFMUkFrVzVpMkdGcUlVUzZDMWhCK05NVGRoMmFmcmNYMmhvSElSNkcz?=
 =?utf-8?B?c0hnRUZzckl2OWFLdUlXOEdxSEx3VENXRmkrNmtTN0JHNGs2UjVTVGM0MWkv?=
 =?utf-8?B?YkY5eERtQ2dHd2Q3d3RYNXN3TVNqTFRETUE4ZE1sUDUxUTA4RjFpNE9EZndG?=
 =?utf-8?B?QjgxL1JVUlJhMTdiTXRqdmIyemU3TmZnbFJ0Vjc0MDgzTGtKVzNvS3NSK1A3?=
 =?utf-8?B?TzVHRVpOd2FjdzdYejRzcExXcGZLNDlBZGFDb2c4OWl4aktLU1dOZ0srNHpY?=
 =?utf-8?B?Qmx6NElZaGNRcEdPbjZWUHpXejd6YzVBZ1h3ZG9Ma29taVpjcTNwVE1ESEc4?=
 =?utf-8?B?MGJ1cGpMNEJpT003SDdkWlBuQS9nWHRhZ3FRTzRZRThIVHovYmIraStWMkN1?=
 =?utf-8?B?QWI5ODFaQmdMRmI3dUdIUWI3UDNxeFoya1lrdFY5NzdlOCtwMTZDNmd2ZVU1?=
 =?utf-8?B?SmhRSkFEUXJyeUxoSWRyMWQ4UVJ2NExkRUpHcGM1ajNNUFJUdmVWMHBvZVQ5?=
 =?utf-8?B?T0VNWFdJa1o3TjdXTlFVS2VIdlQ2OVlFWVlEVU9zWlV3SkZtSStlZGdiYUVU?=
 =?utf-8?B?eTdUd2VHWitlMjNreGVVNllpSHAwT0JBWXB3KzN3c0N4WDZvVVVrUUVtVXIr?=
 =?utf-8?B?K3BpN3NNNFd6aml5eDBzUnlWQmM1MktUWlVHaVhGanFYeTdSSWpFY0gxVW5v?=
 =?utf-8?B?Z05jSkhBL2dsYlVYOTFlbGFqM0RjcFBGN3Z2NTg5R2VGT09jdXBSVzZtNDUz?=
 =?utf-8?B?bFBzdGw1VmlVTXBjVDJUV0FOSU5CNnZ2RVFHVVZKaEFBYk1jUUdvdWFENm1l?=
 =?utf-8?B?RjBkZ2JLaVZ4b3FGZVRUM1ZXbFZWQ09XcTNJTHlOZjhJUlU3cVFLUlFsKy9F?=
 =?utf-8?B?YnZySE1TNUZJOG1kc3lScFhSRUVnenZzazRwWHpjMmJrLzZpS0JCWUdqYWo5?=
 =?utf-8?B?dWdmN0YrM3RWa0tWYUwwZGEvdi91QVhiM2sreVZUUDRvajd5eDRraWtKNlRs?=
 =?utf-8?B?NEtrNnVDdUg3eHQyVXVLTENDRXd1TWszY3UvSmVBc1dHMklXK0hJeXhPSkxv?=
 =?utf-8?B?UFdJbFcyR01mbHZ2V2gzMXhOQXZteGlXR0ZkaWkrem16bUFRT1RPK3NlWnI4?=
 =?utf-8?B?a3hJMDZMT0Y3NEhWTmNUVVRqZ1dackJMdDBZaitWVzZveWZIV1dySHhhYjhT?=
 =?utf-8?B?MlhpaGJPci9BUEQyRkViZVJlTGd4bmpXMGZidjhuWGI1QVhxak81dVM3QzNq?=
 =?utf-8?B?Q2dYaUNaMUtuSHhZMHJDRHMrOFdXZW85ejhTUS82TDMvWDZnVEsrN2NwSGtk?=
 =?utf-8?B?VFNKNlE5SndtVW1sRFQ5SE43bURlem54eXRscmhRNEN2YWJwWmNTL29FRFlL?=
 =?utf-8?B?dEc4UTRtN3grUllzRUlweWMxSHl4ZmhlTDFTL3FJNzk5a0RaaldmcFdpd1cy?=
 =?utf-8?B?b3hYNHc1ZFd2OFpWRHZWQXprRUdPVzhGeTBqR0dHRUZlUGlQZ08xZ3FhZ29K?=
 =?utf-8?B?ZFB2NFAyUXNYQlI5b1kwK3o4Slo4OXdEMG9VbG8xMTFsWGFOSDUwRmE0Wks5?=
 =?utf-8?B?R3RCRnE4VUxPL1lJVkllUVJvMFVFMmdYRW9sbzFTWjliNTJKSXhoUXdTZ0E2?=
 =?utf-8?B?SVhOcTllSk9LWmNYWmcrZm5BcjVHME5ETmlKV0hML1JrT1ZBekt3SWdpMC9z?=
 =?utf-8?B?WGFJMHU3SGFkRVpjU2xMWllpU3lycmFEaWhNT0ZyL3p1b2JCQS9tVXlwSExK?=
 =?utf-8?B?V2t6NUxNbHdMYU56L3diTzlVUWJveVl5SzkycW56SVpzWkZuWnJTakhaczBS?=
 =?utf-8?B?K2wvaTR0alBlWDdjL0hkeXdPWGwyczB2YTJKSGxMTVc1N280U3VyT1h2Q3ZF?=
 =?utf-8?B?eDBXaWpuS0ZZMEpLaWgyQ2phSU84cUxpZnNmbXV4T2QyRXhRaVdKSThEUTdu?=
 =?utf-8?B?VERIaVUxWXFtUVZiNVpSbitpb21HVTNkdXo2djM4dm96Si9qOSt4MGc2NDRj?=
 =?utf-8?Q?Ax7cy7fF36Py70xihzQVa4mzGLSv9k=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O3+gF+BO0CWg+4ZH76O4upIjdoMMPJ5m6COJuYnLArzfuDJChVQUW27C6wZsWee7Os6WvER7rvRrt80t0ospk7RjUlTKvNNHEudvvmbW+F5x8VMNyj+D8HT4a1U5h/VCkNjNNwLdMd9dXe7RCDvUUw8AeFlzPifyxJwET9nFuDl12HBP3U9QTzxMGabpMLdHU8EkzCiCAr8BRb/EDCl1ma4SgX2I0vcHIlJ2UAfUzAHWw5b0V89b+C3WZ/VoJRTBlho8M5hF+GIrMb2oMpdNvuyDLVb7wl1V3VM1swWmgOj1jmpso8pfOBAbC4OtGKRUO9DQ/h2EJ3GunOiTILa48ppYQBCc19fUx9n0Qs1YFuDSZ7MYsOX71kqOo5pCgUcTPXwjVgAEApQU5rqSq648yHTqABRlUYoFmbf5sVIr9VedViK4JE3Tak3Z4jM3BmImw74UESOn4Cld+c3pNuhcPzKZVyA1Boj7aIdQltddCcABdrBB8kZ5lCNwMC7QhMvrITiGFztZ8Wu78cwF1qo9GkML77OuUt+QVtYOwrcI7RQVdP6KY5ljIPxr/J8pyrOygbzM26C5o5PV+ipQXg8aYNZBjA9PDQsOFmZy66Nq/JSt0kyW81tojbaqppvfraonjasP8/IQmqts8ry87bl8wQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:02.4885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a2afb4-6592-4790-7b1a-08dd38f1d275
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4361
X-BESS-ID: 1737336547-111183-13449-2033-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.55.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmRmaGQGYGUNTANM0iMcXI2N
	IsMcUk1cwkNdHYwCDF0tDI3MLc1DItTak2FgB8w6yuQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan14-7.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for io-uring communication between kernel and
userspace daemon using opcode the IORING_OP_URING_CMD. The basic
approach was taken from ublk.

Motivation for these patches is all to increase fuse performance,
by:
- Reducing kernel/userspace context switches
    - Part of that is given by the ring ring - handling multiple
      requests on either side of kernel/userspace without the need
      to switch per request
    - Part of that is FUSE_URING_REQ_COMMIT_AND_FETCH, i.e. submitting
      the result of a request and fetching the next fuse request
      in one step. In contrary to legacy read/write to /dev/fuse
- Core and numa affinity - one ring per core, which allows to
  avoid cpu core context switches

A more detailed motivation description can be found in the
introction of previous patch series
https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com
That description also includes benchmark results with RFCv1.
Performance with the current series needs to be tested, but will
be lower, as several optimization patches are missing, like
wake-up on the same core. These optimizations will be submitted
after merging the main changes.

The corresponding libfuse patches are on my uring branch, but needs
cleanup for submission - that will be done once the kernel design
will not change anymore
https://github.com/bsbernd/libfuse/tree/uring

Testing with that libfuse branch is possible by running something
like:

example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
--uring  --uring-q-depth=128 /scratch/source /scratch/dest

With the --debug-fuse option one should see CQE in the request type,
if requests are received via io-uring:

cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 7060
    unique: 4, result=104

Without the --uring option "cqe" is replaced by the default "dev"

dev unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 56, pid: 7117
   unique: 4, success, outsize: 120

Future work
- different payload sizes per ring
- zero copy

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
Changes in v10:
- Updated fuse-io-uring.rst (had missed the rename to
  FUSE_URING_CMD_REGISTER / FUSE_URING_CMD_COMMIT_AND_FETCH
- Removal of ifdef CONFIG_FUSE_IO_URING in dev_uring.c (Luis)
- Rename of all remaining '*ring_ent' to '*ent'
- Fixed a startup race and added WARN_ON_ONCE(!ent->cmd)
  in fuse_uring_ent_avail. That race actually looks more like
  compiler reordering - 'ent->cmd' was not set immediately.
  The issue was found by an additional patch (not part of this series)
  that does pinning of header/payload buffers, which slows down
  startup
- All 'ent->cmd' is now set/unset while hold queue->lock
  (for the issue above and also noticed by Pavel)
- fuse_uring_add_req_to_ring_ent() must take fiq->lock, to avoid
  a possible race with request_wait_answer()
- fuse_request_queue_background_uring() was in the wrong patch (Pavel)
- fuse_uring_get_iovec_from_sqe() in fuse_uring_register() was
  an accidental leftover, the actual caller since v9 is 
  fuse_uring_create_ring_ent() (Pavel)
- Simplication of fuse_uring_req_end() and callers, removes  bool set_err, 
  (although might set the error twice) (Joanne)
- Rename of subfunctions of fuse_uring_copy_to_ring(), as that
  reduces changes with an additional page pinning patch
- New helper function fuse_uring_dispatch_ent(), called by
  fuse_uring_queue_fuse_req() and fuse_uring_queue_bq_req()
- Removal of an error check in fuse_uring_queue_fuse_req(),
  impossible condition and if it would have happened, it would
  have left a bad ring_ent state.
- Several "nit" fixes (Luis)
- Just return of -EFAULT on copy_{from/to}_user failures (Luis)
- Add missing fuse_request_end() in fuse_uring_commit_fetch()
  in error case (Luis)
- WRITE_ONCE() to set fiq->ops = &fuse_io_uring_ops (Luis)
- Simplified flow in fuse_uring_send_req_in_task() (Luis)
- Link to v9: https://lore.kernel.org/r/20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com

Changes in v9:
- Fixed a queue->lock/fc->bg_lock order issue, fuse_block_alloc() now waits
  until fc->io_uring is ready
- Renamed fuse_ring_ent_unset_userspace to fuse_ring_ent_set_commit (Joanne)
- No need to initialize *ring to NULL in fuse_uring_create (Joanne)
- Use max() instead of max_t in fuse_uring_create (Joanne)
- Rename FRRS_WAIT to FRRS_AVAILABLE (Joanne)
- Add comment for WRITE_ONCE(ring->queues[qid], ...) (Joanne)
- Rename _fuse_uring_register to fuse_uring_do_register (Joanne)
- Split out fuse_uring_create_ring_ent() (Joanne)
- Use 'struct fuse_uring_ent_in_out' instead of char[] in
  fuse_uring_req_header (Joanne)
- Set fuse_ring_ent->cmd to NULL to ensure io-uring commands cannot
  be used two times (Pavel). That also allows to simplify
  fuse_uring_entry_teardown().
- Fix return value on allocation failure in fuse_uring_create_queue (Joanne)
- Renamed struct fuse_copy_state.ring.offset to .copied_sz
- static const struct fuse_iqueue_ops fuse_io_uring_ops (kernel test robot)
- ring_ent->commit_id was removed and req->in.h.unique is set in the request
  header as commit id.
- Rename of "ring_ent" to "ent" in several functions
- Rename struct fuse_uring_cmd_pdu to struct fuse_uring_pdu
- Link to v8: https://lore.kernel.org/r/20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com
- No return code from fuse_uring_cancel(), io-uring handles
  resending IO_URING_F_CANCEL on its own (Pavel)

Changes in v8:
- Move the lock in fuse_uring_create_queue to have initialization before
  taking fc->lock (Joanne)
- Avoid double assignment of ring_ent->cmd (Pavel)
- Set a global ring may_payload size instead of per ring-entry (Joanne)
- Also consider fc->max_pages for the max payload size (instead of
  fc->max_write only) (Joanne)
- Fix freeing of ring->queues in error case in fuse_uring_create (Joanne)
- Fix allocation size of the ring, including queues was a leftover from
  previous patches (Miklos, Joanne)
- Move FUSE_URING_IOV_SEGS definiton to the top of dev_uring.c (Joanne)a
- Update Documentation/filesystems/fuse-io-uring.rst and use 'io-uring'
  instead of 'uring' (Pavel)
- Rename SQE op codes to FUSE_IO_URING_CMD_REGISTER and
  FUSE_IO_URING_CMD_COMMIT_AND_FETCH
- Use READ_ONCE on data in 80B SQE section (struct fuse_uring_cmd_req)
  (Pavel)
- Add back sanity check for IO_URING_F_SQE128 (had been initially there,
  but got lost between different version updates) (Pavel)
- Remove pr_devel logs (Miklos)
- Only set fuse_uring_cmd() in to file_operations in the last patch
  and mark that function with __maybe_unused before, to avoid potential
  compiler warnings (Pavel)
- Add missing sanity for qid < ring->nr_queues
- Add check for fc->initialized - FUSE_IO_URING_CMD_REGISTER must only
  arrive after FUSE_INIT in order to know the max payload size
- Add in 'struct fuse_uring_ent_in_out' and add in the commit id.
  For now the commit id is the request unique, but any number
  that can identify the corresponding struct fuse_ring_ent object.
  The current way via struct fuse_req needs struct fuse_pqueue per
  queue (>2kb per core/queue), has hash overhead and is not suitable
  for requests types without a unique (like future updates for notify
- Increase FUSE_KERNEL_MINOR_VERSION to 42
- Separate out make fuse_request_find/fuse_req_hash/fuse_pqueue_init
  non-static to simplify review
- Don't return too early in fuse_uring_copy_to_ring, to always update
  'ring_ent_in_out'
- Code simplification of fuse_uring_next_fuse_req()
- fuse_uring_commit_fetch was accidentally doing a full copy on stack
  of queue->fpq
- Separate out setting and getting values from io_uring_cmd *cmd->pdu
  into functions
- Fix freeing of queue->ent_released (was accidentally in the wrong
  function)
- Remove the queue from fuse_uring_cmd_pdu, ring_ent is enough since
  v7
- Return -EAGAIN for IO_URING_F_CANCEL when ring-entries are in the
  wrong state. To be clarified with io-uring upstream if that is right.
- Slight simplifaction by using list_first_entry_or_null instead of
  extra checks if the list is empty
- Link to v7: https://lore.kernel.org/r/20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com

Changes in v7:
- Bug fixes:
   - Removed unsetting ring->ready as that brought up a lock
     order violation for fc->bg_lock/queue->lock
   - Check for !fc->connected in fuse_uring_cmd(), tear down issues
     came up with large ring sizes without that.
   - Removal of (arg->size == 0) condition and warning in fuse_copy_args
     as that is actually expected for some op codes.
- New init flag: FUSE_OVER_IO_URING to tell fuse-server about over-io-uring
                 capability
- Use fuse_set_zero_arg0() to set arg0 and rename to struct fuse_zero_header
  (I hope I got Miklos suggestion right)
- Simplification of fuse_uring_ent_avail()
- Renamed some structs in uapi/linux/fuse.h to fuse_uring
  (from fuse_ring) to be consistent
- Removal of 'if 0' in fuse_uring_cmd()
- Return -E... directly in fuse_uring_cmd() instead of setting err first
  and removal of goto's in that function.
- Just a simple WARN_ON_ONCE() for (oh->unique & FUSE_INT_REQ_BIT) as
  that code should be unreachable
- Removal of several pr_devel and some pr_warn() messages
- Removed RFC as it passed several xfstests runs now
- Link to v6: https://lore.kernel.org/r/20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com

Changes in v6:
- Update to linux-6.12
- Use 'struct fuse_iqueue_ops' and redirect fiq->ops once
  the ring is ready.
- Fix return code from fuse_uring_copy_from_ring on
  copy_from_user failure (Dan Carpenter / kernel test robot)
- Avoid list iteration in fuse_uring_cancel (Joanne)
- Simplified struct fuse_ring_req_header
	- Adds a new 'struct struct fuse_ring_ent_in_out'
- Fix assigning ring->queues[qid] in fuse_uring_create_queue,
  it was too early, resulting in races
- Add back 'FRRS_INVALID = 0' to ensure ring-ent states always
  have a value > 0
- Avoid assigning struct io_uring_cmd *cmd->pdu multiple times,
  once on settings up IO_URING_F_CANCEL is sufficient for sending
  the request as well.
- Link to v5: https://lore.kernel.org/r/20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com

Changes in v5:
- Main focus in v5 is the separation of headers from payload,
  which required to introduce 'struct fuse_zero_in'.
- Addressed several teardown issues, that were a regression in v4.
- Fixed "BUG: sleeping function called" due to allocation while
  holding a lock reported by David Wei
- Fix function comment reported by kernel test rebot
- Fix set but unused variabled reported by test robot
- Link to v4: https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com

Changes in v4:
- Removal of ioctls, all configuration is done dynamically
  on the arrival of FUSE_URING_REQ_FETCH
- ring entries are not (and cannot be without config ioctls)
  allocated as array of the ring/queue - removal of the tag
  variable. Finding ring entries on FUSE_URING_REQ_COMMIT_AND_FETCH
  is more cumbersome now and needs an almost unused
  struct fuse_pqueue per fuse_ring_queue and uses the unique
  id of fuse requests.
- No device clones needed for to workaroung hanging mounts
  on fuse-server/daemon termination, handled by IO_URING_F_CANCEL
- Removal of sync/async ring entry types
- Addressed some of Joannes comments, but probably not all
- Only very basic tests run for v3, as more updates should follow quickly.

Changes in v3
- Removed the __wake_on_current_cpu optimization (for now
  as that needs to go through another subsystem/tree) ,
  removing it means a significant performance drop)
- Removed MMAP (Miklos)
- Switched to two IOCTLs, instead of one ioctl that had a field
  for subcommands (ring and queue config) (Miklos)
- The ring entry state is a single state and not a bitmask anymore
  (Josef)
- Addressed several other comments from Josef (I need to go over
  the RFCv2 review again, I'm not sure if everything is addressed
  already)

- Link to v3: https://lore.kernel.org/r/20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com
- Link to v2: https://lore.kernel.org/all/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com/
- Link to v1: https://lore.kernel.org/r/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com

---
Bernd Schubert (17):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: make args->in_args[0] to be always the header
      fuse: {io-uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add fuse-io-uring handling into fuse_copy
      fuse: {io-uring} Make hash-list req unique finding functions non-static
      fuse: Add io-uring sqe commit and fetch support
      fuse: {io-uring} Handle teardown of ring entries
      fuse: {io-uring} Make fuse_dev_queue_{interrupt,forget} non-static
      fuse: Allow to queue fg requests through io-uring
      fuse: Allow to queue bg requests through io-uring
      fuse: {io-uring} Prevent mount point hang on fuse-server termination
      fuse: block request allocation until io-uring init is complete
      fuse: enable fuse-over-io-uring

 Documentation/filesystems/fuse-io-uring.rst |  101 ++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dax.c                               |   11 +-
 fs/fuse/dev.c                               |  127 +--
 fs/fuse/dev_uring.c                         | 1318 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  205 +++++
 fs/fuse/dir.c                               |   32 +-
 fs/fuse/fuse_dev_i.h                        |   67 ++
 fs/fuse/fuse_i.h                            |   30 +
 fs/fuse/inode.c                             |   14 +-
 fs/fuse/xattr.c                             |    7 +-
 include/uapi/linux/fuse.h                   |   76 +-
 13 files changed, 1924 insertions(+), 77 deletions(-)
---
base-commit: 5428dc1906dde5fb5ab283cda4714011f9811aa1
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


