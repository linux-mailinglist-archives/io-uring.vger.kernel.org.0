Return-Path: <io-uring+bounces-4543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 985FC9C0C86
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAD141C21C00
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98731217463;
	Thu,  7 Nov 2024 17:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="oy6hjSEE"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1152170C2;
	Thu,  7 Nov 2024 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999084; cv=fail; b=qvqpgdDNhdIf7WNHmApVIyJBZrPDsc6F7Q/oeLR43lZEJcA44jjQ/QaqHirQYLtolGFsRdoIUny3S1wSJWwLVLVLbchNB0+eUIzNtydfduisEvpEZlkAjGv0Uxp6mQ4i5Y5N3KvC1YMZ2evzOt8cTpCKWFwbQbi5kn5FjoNGfuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999084; c=relaxed/simple;
	bh=OJTUt4mkYH2WA2Ni9WafRVps8f5ApriSf2zsr8pPUVo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a/W0AVryiyZWfZ0w4wxMtxkKdvzyJugr6DMVC0im/rIPv8xOYI1MY9JYUK0ZezwyrkTbzW8+bMQdm50UyxHZzLc+Qt89blf+MaGQ0flaq733aOFsf4hVH/K+sl02rAPvdyGhSl/KO+VAFrzhOuCrL89djL0QzQ1X/t3sEGTWcRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=oy6hjSEE; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173]) by mx-outbound40-242.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKparzKYWpUsO+3KN9iAQmMLvbCCOL05oqkVZpKpS6gq7TP/M/a0h0YuLO95iitSGbju0mWY/gvrsOTVpZZk3XR9dhlU4+doz7DzFiFkS+J5UZQdK+naVy0m6OfQLbkQ2SnbhwgV2h3QBvMiTJgGJfX9ebg6K8oNgkL+X3IYyzzD0uEUs5oy8tTOmu6v5p0sif9loG7xX7gBPJuKoQVZaZKxXGr6KUK0tM6HWcsVreITjo2873L1LZkYnwlHZHeM8FR25w27YaXFgzM+AzBdyXbuEXg7qA8x9CNgNtcrR9BQ2nRsw8eArfuNoMlL5abTjMr4SKvBCBw20z+8SCcJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNXPFJF9TCL5bosK5gGEE984IyCYHF3MK/GzXxaPR1s=;
 b=ACxfXBFZi05kIdiDIPXGedMYEez+5+Pqw9KEoq3cdP8mq2bqmDtzRJW201rZnuWOHdSz9oaEpIwEbG+3E+H172QeZDHlrKYbKKDuX3gzziZeDELnMbRcj8olcHim8Yh6+AybgD8e0H9SGmE/7Ce127uH4BgKGzfO9OyCHNwW5plct4l57QJ/4S/LG54BFtooCxQZzPfEbvDUFhzkCiPbgKtJoSrc3wI8WaaEMnJsPcf2HmzWsvybucV8IryAio5C8fMv+DM663ukxIxxv2ZWMt8iCb81DEvmqftev1ELdDN415SHkS1rzNsRD6h0ijRpNuYmD26h1SfMsDjva3Bvdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNXPFJF9TCL5bosK5gGEE984IyCYHF3MK/GzXxaPR1s=;
 b=oy6hjSEEVEdA6VORxUn9tU1jmQz+QRRtEsyLLxw6Nc8PtUaDCdsinITjs3m7V9Cfa+xuCJ6caD3pP4im0F67/TbGt8SJEc4qSn1TIV0o7lBRmVUu2do0miy/AM56KZWP591t9XDyq33YTDXaERy76xKY8KlCFpr60nspsu/AM5Y=
Received: from CH0PR03CA0103.namprd03.prod.outlook.com (2603:10b6:610:cd::18)
 by BY5PR19MB4083.namprd19.prod.outlook.com (2603:10b6:a03:218::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 17:04:21 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::25) by CH0PR03CA0103.outlook.office365.com
 (2603:10b6:610:cd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:20 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 0AD19121;
	Thu,  7 Nov 2024 17:04:19 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:54 +0100
Subject: [PATCH RFC v5 10/16] fuse: {uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-10-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=11956;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=OJTUt4mkYH2WA2Ni9WafRVps8f5ApriSf2zsr8pPUVo=;
 b=9fDb2QVegfeKmKwZ1ia3Yyj13buFeQMTJVrOl53JqvMD4K6PeOHUHF4frSpMWpOvM7Rt+G630
 HiAWo/eOODhA5OEDCF10g99qNxDAdMSfR/2z5z+8NolAvy9s1CO8sxi
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|BY5PR19MB4083:EE_
X-MS-Office365-Filtering-Correlation-Id: 44da4f2a-1c51-4dd7-26d6-08dcff4e38fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1dEditWRG9GWjVWeENaaEZ5c1lLV1VDSkZQa0RpZnZuTGZyb21PQnlFNzh5?=
 =?utf-8?B?TFpMQUR2OUprc3VOMFNKR21LdlczRmd2NU5FbGxrOVIraG4rbkRGOFk1RldV?=
 =?utf-8?B?NldVSElxNzc1S3JFOFdMMDJGZmJhbWU1ZGUyQnFrMEtDTlRXSHNmMlZpSEwz?=
 =?utf-8?B?TkxVYnM2ZDFsMEFiVGRkR3BJWVNlUjNyY2MzOFIxTjdnVnVPZ1d4cnJ0bCtF?=
 =?utf-8?B?VUhBMktFTlc2Yk44S3V3dlNYZG9MSWR3N3htSFVSL2xiVjZpbjdHUlk5WUd6?=
 =?utf-8?B?bHZNUVJOMGZxL2N2RUlGdzRuTTZDZG9wcUNkYWFkaW1lcWJnNTdaZmVxUG9E?=
 =?utf-8?B?QjJTVlZYTWpMdTV0K0NRaCs3UzQzZnF6bkpYRFFFQU9rY1lTcW5UazlqWllH?=
 =?utf-8?B?bUFVRzVwL3EzcEl5anFXaXF1VnExVGVLUkhQdU5NU3FHNWtyaG1RTHRJMFFB?=
 =?utf-8?B?Y0RrYjl2eXJNYXVRbE9QdW5RR0xJdmtQV2VReFBxbm1rcjdsMFhvblcwOUxS?=
 =?utf-8?B?UnE5T0l6K05XRkVmSzIrL0FUaVZ0M0hZZk56ZFBFMTJQOG9Fa2dtK2lTMlRR?=
 =?utf-8?B?dk1sTTMyMjdhZXh5eDV4dEJEbWxHVGljQjhGTW4vMXV6ZTF0NW9yaVpZSHhE?=
 =?utf-8?B?Wi9kci9xdDB5Q2dTeXlnKytkU3BYbWpJMGtTclVqVFJ3ZWRjM21DVUFmK0Zu?=
 =?utf-8?B?WGdoRjl6R1Q2VWNZdnVRaW1sYU5uK0hpTW5SVklXRnhHZWtKRmx0R1U3VVNq?=
 =?utf-8?B?WVpJeklndHBVYWp5TzFvbHEwWWlqdU51YllUWnBZSWFMcVpZY0FkVGFJc0FE?=
 =?utf-8?B?NWZvWlFTdE1vb25JclkzVWNvUWZoODVGRUg1NFpxTHBCWGp3eHRxLy9hcU1F?=
 =?utf-8?B?ajZ1ellWVTAzSTFVbG9uU093cGh2VG1RMjJ4cVBCQ0FMZXA5cWpWWHdZdUNI?=
 =?utf-8?B?aW1mcUhmN2FDUXV6bk0zVHM5VVk5N29OcStEVnZZNXdGTHpQK3VVSmdlRHBK?=
 =?utf-8?B?RXl4d3N0aEZlN0FJNURTeVZJdkdYem5zb1ZhK0NmOTJKckZlTGI1bWsrVTJy?=
 =?utf-8?B?S2NNU0FqQUQwRDRLZm9xMXIwUkJJcGJzYXdzVEVvZUlxNmd1eHZFUFVnZnNm?=
 =?utf-8?B?cVJUbSszUzFWYXlYZ3l1alFtMTJRaGQrekk5dkZ0TVRGTVpwa09JQXZMRGlQ?=
 =?utf-8?B?bjFvRHM1SDNKOU5oZGtUSVNGZjRLRHFsUW9nY1JDTGtvVENEL0N6enhXaWIy?=
 =?utf-8?B?NzV4K2lLVGl4YnFUODIvV0RWekw1K3c5aHFTU0RLK1dyV0I0dTY3eEtLa2pm?=
 =?utf-8?B?aW9TV0NFb0lQT3NtZ1JFSHFnM2ZMZldyU0N4WTF3MWU0OXBiWWRZUXY2S0Rm?=
 =?utf-8?B?TkVIN2dMM0VIWTVLdy96a0I3S2VrOHViejdBaGd1NFNGN2d0MlB6SlFEMXAv?=
 =?utf-8?B?akVyYnRZTnI0emFwNmtzL2dRT2gxKzJTc2p0emlWdGVNcnVuNWxISkdZNXZr?=
 =?utf-8?B?L1k4RU9Ic3hDeHZBT2RZcVdoMzdaVUk2NFc5MlEvQk85ZUdzMmlWdmNpUmwr?=
 =?utf-8?B?ZW1oVHdDM1M3Z1Vtc2dsVmMrZWl6anZ2VFBXYndSY3NqT1NIdmZqSjNKWjZL?=
 =?utf-8?B?YnhXS3ZveEl6LytBNXFZaUVzVmNVSXRTK2NLMm1DNTFrODNuQ1JWZGh0aVhD?=
 =?utf-8?B?NjFnbU1UODNvOVRwZkhJa0dJTkg2TUptTUhDRHExTGgvR1hTaEZ1c2c0Q0lQ?=
 =?utf-8?B?ZFVra2ZXWkhhbG1TR2doTEVLczdNVTE2eThzMDZRWk8wcmVKWk9pK0o3SmxE?=
 =?utf-8?B?MlpMNjJyTmR5U1hCUUpPT3NZV0F5YnFMRTg1TG5hOHgweHpuSXUyQ0VHdnhF?=
 =?utf-8?B?MEEza3RMVHdwQm9xYUVFazJBMzBJOElMSE5FKzd3MDB2VkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v0oLS8rSAikTVZNNqr1AtQL5Fj4W2yailyY9IIKIF9Iv0noK4ByDiDferbH193+ZMGH7yiiYj8LT05XK5vYR309Hyp4QXEXkPA4TIk2bR68ZTBVUhntBn+hILJW3Dqdy1nJVLGPRNS5whRsQt/EjabsOUdmtmC4rMTmAaWOehdH6OyOxV5wvZS9l6uYKTNLEu+VxoOGu2bqTs3zJgl5WltqoRQoZxYTzVJlJcRvVxJITQvtZp1SMlEWBjZgYGvtnr+I12GE70dFVue2cPOxsqbFzwqfeAWyK/EPS8hFtO7Zk9YmSvGs1+BMvJgkGFuvPdmTFt2MmMOrVqAHpFRiuHvPOi5YpTD/VlBvZ4MEdssvdCUut9rYn1aH9qjN9Pysah2m4DEm1hCmlgtB0yktMBw2C6SJrynitrebEhZ/7Ug7dmYPZOklzF9U9lN4/LSifF6Kk0H6Zs9UxUwaA119B2+8EFvjCo5eKeyNCx42iIJ2IIBvO7QqIzUFI17sT2mP1LMMNen0u8HAZffEF/1nZlynlIz4ilHadF3WmL5Y976Hn5MQNuYqXQ9T7+Chk8Pxda/us2unpKU4TMnxzS7Nob8QurdZ6wRMxVAdoOvRbHSfO2Y4c1HZ2BlNTALdWOMh7OMCxj2anh36MZ8M+fTXUiw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:20.7567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44da4f2a-1c51-4dd7-26d6-08dcff4e38fc
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB4083
X-BESS-ID: 1730999072-110482-12748-9945-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.58.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGpiYGQGYGUNTYONXM3DLV1D
	IxNck81dwoycDE0CwpMTk5zSDF1MjAQqk2FgDq0YHJQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan11-34.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On teardown struct file_operations::uring_cmd requests
need to be completed by calling io_uring_cmd_done().
Not completing all ring entries would result in busy io-uring
tasks giving warning messages in intervals and unreleased
struct file.

Additionally the fuse connection and with that the ring can
only get released when all io-uring commands are completed.

Completion is done with ring entries that are
a) in waiting state for new fuse requests - io_uring_cmd_done
is needed

b) already in userspace - io_uring_cmd_done through teardown
is not needed, the request can just get released. If fuse server
is still active and commits such a ring entry, fuse_uring_cmd()
already checks if the connection is active and then complete the
io-uring itself with -ENOTCONN. I.e. special handling is not
needed.

This scheme is basically represented by the ring entry state
FRRS_WAIT and FRRS_USERSPACE.

Entries in state:
- FRRS_INIT: No action needed, do not contribute to
  ring->queue_refs yet
- All other states: Are currently processed by other tasks,
  async teardown is needed and it has to wait for the two
  states above. It could be also solved without an async
  teardown task, but would require additional if conditions
  in hot code paths. Also in my personal opinion the code
  looks cleaner with async teardown.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   8 ++
 fs/fuse/dev_uring.c   | 211 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  51 ++++++++++++
 3 files changed, 270 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index b085176ea824bd612a8736e00c9b6f8f9e232208..d0321619c3bdcb2ee592b9f83dbee192a3ff734a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2241,6 +2241,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->lock);
 
 		fuse_dev_end_requests(&to_end);
+
+		/*
+		 * fc->lock must not be taken to avoid conflicts with io-uring
+		 * locks
+		 */
+		fuse_uring_abort(fc);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2252,6 +2258,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 4f8a0bd1e2192bfbc310eb53dd8e89274e6f479b..2f5665518d3f66bf2ae20c0274e277ee94adc491 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -52,6 +52,37 @@ static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 	return 0;
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(req_list);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry(req, &queue->fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_splice_init(&queue->fuse_req_queue, &req_list);
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&req_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		queue->stopped = true;
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -110,9 +141,12 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 		goto out_err;
 	}
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->nr_queues = nr_queues;
 	ring->fc = fc;
+	atomic_set(&ring->queue_refs, 0);
 
 	spin_unlock(&fc->lock);
 	return ring;
@@ -173,6 +207,177 @@ fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
 	io_uring_cmd_done(cmd, 0, 0, issue_flags);
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	/* remove entry from fuse_pqueue->processing */
+	list_del_init(&req->list);
+	ent->fuse_req = NULL;
+	clear_bit(FR_SENT, &req->flags);
+	req->out.h.error = -ECONNABORTED;
+	fuse_request_end(req);
+}
+
+/*
+ * Release a request/entry on connection tear down
+ */
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
+					 bool need_cmd_done)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	/*
+	 * fuse_request_end() might take other locks like fi->lock and
+	 * can lead to lock ordering issues
+	 */
+	lockdep_assert_not_held(&ent->queue->lock);
+
+	if (need_cmd_done) {
+		pr_devel("qid=%d sending cmd_done\n", queue->qid);
+
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
+				  IO_URING_F_UNLOCKED);
+	}
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	list_del_init(&ent->list);
+	kfree(ent);
+}
+
+static void fuse_uring_stop_list_entries(struct list_head *head,
+					 struct fuse_ring_queue *queue,
+					 enum fuse_ring_req_state exp_state)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent, *next;
+	ssize_t queue_refs = SSIZE_MAX;
+	LIST_HEAD(to_teardown);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry_safe(ent, next, head, list) {
+		if (ent->state != exp_state) {
+			pr_warn("entry teardown qid=%d state=%d expected=%d",
+				queue->qid, ent->state, exp_state);
+			continue;
+		}
+
+		list_move(&ent->list, &to_teardown);
+	}
+	spin_unlock(&queue->lock);
+
+	/* no queue lock to avoid lock order issues */
+	list_for_each_entry_safe(ent, next, &to_teardown, list) {
+		bool need_cmd_done = ent->state != FRRS_USERSPACE;
+
+		fuse_uring_entry_teardown(ent, need_cmd_done);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+
+		if (WARN_ON_ONCE(queue_refs < 0))
+			pr_warn("qid=%d queue_refs=%zd", queue->qid,
+				queue_refs);
+	}
+}
+
+static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue, FRRS_WAIT);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_ent *ent;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		spin_lock(&queue->lock);
+		/*
+		 * Log entries from the intermediate queue, the other queues
+		 * should be empty
+		 */
+		list_for_each_entry(ent, &queue->ent_intermediate_queue, list) {
+			pr_info("ring=%p qid=%d ent=%p state=%d\n", ring, qid,
+				ent, ent->state);
+		}
+		spin_lock(&queue->lock);
+	}
+	ring->stop_debug_log = 1;
+}
+
+static void fuse_uring_async_stop_queues(struct work_struct *work)
+{
+	int qid;
+	struct fuse_ring *ring =
+		container_of(work, struct fuse_ring, async_teardown_work.work);
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	/*
+	 * Some ring entries are might be in the middle of IO operations,
+	 * i.e. in process to get handled by file_operations::uring_cmd
+	 * or on the way to userspace - we could handle that with conditions in
+	 * run time code, but easier/cleaner to have an async tear down handler
+	 * If there are still queue references left
+	 */
+	if (atomic_read(&ring->queue_refs) > 0) {
+		if (time_after(jiffies,
+			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
+			fuse_uring_log_ent_state(ring);
+
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
+/*
+ * Stop the ring queues
+ */
+void fuse_uring_stop_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		pr_info("ring=%p scheduling async queue stop\n", ring);
+		ring->teardown_time = jiffies;
+		INIT_DELAYED_WORK(&ring->async_teardown_work,
+				  fuse_uring_async_stop_queues);
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -563,6 +768,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -730,6 +938,7 @@ static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
 	if (WARN_ON_ONCE(err != 0))
 		goto err;
 
+	atomic_inc(&ring->queue_refs);
 	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
 
 	return 0;
@@ -756,6 +965,8 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
 	goto out;
 
+	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
+
 	err = -EOPNOTSUPP;
 	if (!enable_uring) {
 		pr_info_ratelimited("uring is disabled\n");
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index c7bac19e91b781fc9ccce540e39d99b39b751f6b..c9497fc94373a6e071161c205e77279fd0ada741 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 
 	/* ring entry received from userspace and it being processed */
@@ -83,6 +86,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -97,11 +102,50 @@ struct fuse_ring {
 	size_t nr_queues;
 
 	struct fuse_ring_queue **queues;
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
+	 */
+	unsigned int stop_debug_log : 1;
+
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
+	atomic_t queue_refs;
 };
 
 void fuse_uring_destruct(struct fuse_conn *fc);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring == NULL)
+		return;
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_uring_abort_end_requests(ring);
+		fuse_uring_stop_queues(ring);
+	}
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring)
+		wait_event(ring->stop_waitq,
+			   atomic_read(&ring->queue_refs) == 0);
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -114,6 +158,13 @@ static inline void fuse_uring_destruct(struct fuse_conn *fc)
 {
 }
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


