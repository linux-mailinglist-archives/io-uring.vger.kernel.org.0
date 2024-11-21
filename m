Return-Path: <io-uring+bounces-4952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C62429D569A
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 126F8B21509
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47AC1853;
	Fri, 22 Nov 2024 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="vmsJ1Dvn"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1635CB8;
	Fri, 22 Nov 2024 00:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234601; cv=fail; b=SYrHVfPydWM/x3RlcbsYZ2K7J3VfEl6H/6skuMiwxj5MZyPaQcSiO4t9S6U/kziOheHEW9I3EKLNWbbYMBeNGzJzGL45TFoTUGqjSEpZet2oHgygYYTvpjjNQsw/VKyx4Ct6oH/NE52YPWhCxbd73xJZPqz/JmYFvdn5cjocWSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234601; c=relaxed/simple;
	bh=9PzkB61bj/XR2Z+Wxlq+/t+fdgKvUzyQ0tG8Huxq6vA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=io8rZ0/ziydIWxgA87SEtSY6Tp+FIfvzufhvDE+wVhIh7tBdrbdSJ498lBPrU3gDHLYvzb/pEOWsUGSWEc7pyohLi6yrmQCocqFdhqhjEjqM1w+Bhc3fkooWkEtG4Rr+NEScMw8c+ris/CzPQrLyJSXTuwHySaSvtnmQ1TTVe4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=vmsJ1Dvn; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46]) by mx-outbound20-210.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeKf7ZQjfFQJaiV6QNk7H0lDONOzjYngL8OtIX4dDih3O5nCHlEBB79Sz633LT0dwyx57rNV5OTiPK6ej3PLbBcAZBjjlcVLhGJTILjYk3/qQbA414ItXYj4FTqMH2c1Um4+ZXrK6GzN++zmDcw1zhLdO+HNwr+pgPd8J5dMvI/2SOe0OqqGBPT5gfC4CKgMYOlZNfv+FFjgKjW1CeoMT5JjOtBMzn2NKRoAz/eWADRWoZlmVcCfrk0zwcJts4BmHGDNHuw/Ajnka/LnvSe3z2hVgYgsGmjhfANlSqdXZD2owu1pb2lE+SeA52Z7pu8+qhaxxAWSuKfTgTr0JStakw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K6grFXYQFUPscAqxdj4dBIZiGWdtyrh7ixfQODKKbA=;
 b=rX7Krq7Lv4FTEMFhlIGKq2BdI5ImD2QTnMq8IqnCkJ0WdVLICeCRZO7KY7lPXIJGLl1spr0g/rbCfwKtO1AqqKTK8i0qDI580WNRHzqiYc/JAG5qdlhChwTZ110pft/LsImICI5C9/v8ss+8UhE9WU2716rRsh/lpVvYkIi+aqEoBsJ5eUtWXq27Bk+wN4wXcf4x0uGUwS0SV8P7Ds9RO8rm+BVBzqAwn99cEO9kNBU9cvr+PXVTnmKWX9MdQmvQOiSL21qAm2s/iwlb4uEpjIVrj+6yZ50YF9Ylt/GprnxNVWnD0JtBjNcKBxWTpICYQFOX4aT890OalxMY5QVtoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K6grFXYQFUPscAqxdj4dBIZiGWdtyrh7ixfQODKKbA=;
 b=vmsJ1DvnKYVXqyfte7VypXoOBHelBdfaMdQ6QFTegNJT8AQdN4XgcpYjQDybwv0lnolbP05kLdR7PTU/PDBJwlPwU4YOtm7ouyY1ptT8CPMxf44LSMcTrdhWuAiZR8YJB0nv8EkWQvugxE5EpF4hkjGsw0oDSX1Ocf0YXoLEzEQ=
Received: from BN9P221CA0018.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::35)
 by PH8PR19MB6858.namprd19.prod.outlook.com (2603:10b6:510:1be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Thu, 21 Nov
 2024 23:44:04 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:408:10a:cafe::b5) by BN9P221CA0018.outlook.office365.com
 (2603:10b6:408:10a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Thu, 21 Nov 2024 23:44:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:44:03 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 90F5F2D;
	Thu, 21 Nov 2024 23:44:02 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:29 +0100
Subject: [PATCH RFC v6 13/16] io_uring/cmd: let cmds to know about dying
 task
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-13-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=1916;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=DJ3dd+IL74OJQCvDusXpPNgQqk5rs1+4ays6c3lVSGQ=;
 b=cfYGZaden8bc3p9bplsulDzUkb/nlafClLRUtAgHYXOstW+kMnYaW3B3ckBaEZid3o6vFw+HB
 pZeGJZAaXj3CoAu4FtFbKnt0PDre5w1rUd5LA+eA1YpfmDXJGJpXksn
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|PH8PR19MB6858:EE_
X-MS-Office365-Filtering-Correlation-Id: bdfcc517-1d27-4810-71d6-08dd0a8661bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enlVNElyaVgvdDFtSlpKNzZlcmRQSlZnQXBETFpaaDg5OHp5M056UG5TM3lY?=
 =?utf-8?B?L3dVdUVaNGVRSnljUGhDcW9nenRjLzE5VFBnQW5KZ2l5OW0za0UyUzFiMGcx?=
 =?utf-8?B?Z3BRY2t1YkcwK0NTYWdPZ21QbVJLZ0MvWlZDVDY4SG4vWFNvQURzOUxzMHlV?=
 =?utf-8?B?Ky8zRVJubzVKUVZOc05ZRHM1VDBsNGEzdnNMQWZuelpqamZ4YVQ2anpMR2d0?=
 =?utf-8?B?Y3NYb0d4YkZJQXVZTXZrb0xSSjlFZkQyd0hmZDJOV3l2bS9mZEdkL1dVSUhk?=
 =?utf-8?B?YjZ4Q1h2dWFYZnZnbXgwaVlPZ0RjUHZmYmJWcVNFTk1VU0R5NjUzVWUwUHRW?=
 =?utf-8?B?SzFiaDVVSFlld09YWDNxSDkxUTVneGE4WVg5TGNPbXpmUG5kS3UrdXdBeWJQ?=
 =?utf-8?B?dDNOV3hWVk9nTnRMQVM4NTdMQlNaazZpeXZaZWZsb1kwN3U3SExZZ2N5bmc1?=
 =?utf-8?B?c2NQdCtqaXZyN2UrcUpEQXJka3E1WjB0d3hwWlcyNUhzRG91b0tsVzFLL2I0?=
 =?utf-8?B?Z1J0aFViQ3pvcmIvNGlGN3B5V0NZMUJqUDlFSzNMR1MzTGZNTTR2WDZ1Mlhx?=
 =?utf-8?B?VC9FTkZOMUNuaVY5dnpUU1ZuczJtbE5oNmZ2ZlcxSUVpS3ppVFlpSXJkUk43?=
 =?utf-8?B?VFZOMC9nZ2F4bTN3aVMwMHhQd1V6Unlzd1F1VDM1VUdVdWtsZDBadUk5UFJQ?=
 =?utf-8?B?NVRoL2ZSdjBCcC9TY042RzVQYlcxLzBkSkVHWnFHUWdETTk2c00vdkpTUG1p?=
 =?utf-8?B?M0FsZkNRQUsyTTNiSktWS3pZdHZwWHdtMGV6alhIRDhQazBOSUlsN2R3TEtL?=
 =?utf-8?B?NGFPS1lnVVZRamhtd01wYVM2eWlBaHR1MmhudC9FeTBzSzZUYUdxdHEvY1Nw?=
 =?utf-8?B?SFZWTXR1ZENoZDR6SnZ0eG9wL1FFeFZzUENyWUczc3VwMW9oRkhoSjVFSVgy?=
 =?utf-8?B?WkpTVlVTdkJ2enlteFNpQ1FTYUNlR1lRQ3cwY1RZL3dJOVZhR2haNDU1VDlz?=
 =?utf-8?B?Zm5vTTZPcUpZVlVjWVBuRlJvOTBxZ1llV2dzNndMOFYzOUpZbnNxOU1pSkUy?=
 =?utf-8?B?K2xGZ1JPTGlBSzB6LzY0bmJIbDEzaktSdkd0QjlaMEhGeENGYkxieUlNV1BZ?=
 =?utf-8?B?bmplYzRUM0diQTR3TmNJK01Ha1dwdmVhWlh3c3dVb1d3Zmc0UFZpa1psTzY3?=
 =?utf-8?B?VjJrUU5SczBtbE1GS3lUdDJETFlWVEI1UFVUVU9WM0JKdkFMeHYyZ0tFZGp4?=
 =?utf-8?B?cGpZbjJUQitUYzBycmc0WUE1YXBPNEtoRmF2Szd2YVNLU0tac2V2cW9jY25I?=
 =?utf-8?B?QlZCNlF6RlZGL29HSEdwKytDeE5yZnNYSS85eHJNUlJuVWJUV3MvTWFEY1JL?=
 =?utf-8?B?UDB1SG5GWDNPUld5LzBJZlJ6MEJNSjhTVC8ycEpsV0N5Q3J1YnIyUDdaKzEv?=
 =?utf-8?B?SUxNaTBwTlQvR251QVRYTDJ1OUdXM3lRQzFpNTY3WDQ4TXFjeTNGQjRhOGZM?=
 =?utf-8?B?dzNERUlLM3E1SFdNY0JmblJwSmlHaCtUb2MzdkgydFNiZGhzSVRzVEJlRVhR?=
 =?utf-8?B?UFVNSERyRTN6dXBlTUJPZWF4ZDFyTk11WjF5OW81VXU2NUFISlRTcXlDQXVw?=
 =?utf-8?B?ck5NQlQvTWd4QnhJNWdRSFlRYVlMMWtpNytzdGMyUXJxS1IxaGMrZ3V3SS8z?=
 =?utf-8?B?dGRCR0xzbm85SlM4L1NlRm1FVWJ1MWp0NjBZOWRVcUdDcjlaRk1MN21WVXcy?=
 =?utf-8?B?TktyN1BFTFlVRC91a0xCOU9qWStVVTJWZVJtK0hXOHgzNnByQjMrdVBlSHpq?=
 =?utf-8?B?eWpwcWxjMjNlQVpWSHdQU3Z6Z0c1WE9PMjUyQWV5azNydmE2MFBsMHNWSEow?=
 =?utf-8?B?NE1tdWZRTHRTbnlDSTZKYU9WdCttaENDRVp0Qm5majhYVUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0h7QhxvFyGpHRq+0aCXBfmw5DioAEObIVxxGbnwhLZyeFBJnqzsHlM+8wbQ/aVbeOsMoxWWjtbDgx1pF352Y8ma9vpoDpr5iUFLUbBRw8BYjPnIKTHnwCKconaDBrHsYrnvxOsCx+xnE2Nn8Y/Yc6Lt5TigxWOWwDSllJKNGvVn/s64tZAXCd4VASKxwpuWIF74hIHWzvPHLZIQUXJs9rBVsemoVQMqTGUmXXxlSHOxsPmqyc8cDgM+LylsHZeSDm0SJ1+0lDmDYT6F2C7fNaMnCDSTP6H+gpIEMtkWTajDamUBrx7Jl9kTGYxKLu8+hbqAKwWtan4asVzMpuQSe2rhgNgLtq3eKBtXZums68nEDSn1ikEMBJ49snacma/Xur8U/3WIwwG3epl3jr4sDdie5K9vdZKvVwEmFrH8Xz9eyq9ewArGr/9NZad5rUIUQzvpm53NJFDGXFgGNVRmRL9mGkKjegxhNZGXUt6XBjaFYZbTPumdhdBU6bPYeWkpLvLECEmbImD1GrsaKeevRFfhpkfTpzRJ+awJvUb87SlFnCDIpCSPLzESIX03rKwlYH4Q+VcQRgpZcSdUkvVpjz9hktoH/OaVQRLXF98D+TY8eShBerUcwIsIB+FchP9FArNNG6JpX5Z1fuDDcCqXkJA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:03.6642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdfcc517-1d27-4810-71d6-08dd0a8661bb
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6858
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234598-105330-23902-62646-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.74.46
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaWhuZAVgZQ0MwozdzMNCnROM
	0s1dDI3NLEIM3SIsUg1cQ8ycQs0SRZqTYWAP8mqz9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan17-70.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Pavel Begunkov <asml.silence@gmail.com>

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/uring_cmd.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4b9ba523978d203ae23fb4ec9622d6e4e35a5e36..2ee5dc105b58ab48aef347a845509367a8241b9b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 39c3c816ec7882b9aa26cd45df6ade531379e40f..38b6ccb4e55a1e85d204263272a280d3272557a4 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (req->task->flags & PF_EXITING)
+		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,

-- 
2.43.0


