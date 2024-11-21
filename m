Return-Path: <io-uring+bounces-4963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A25F9D56A9
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AE85282C6E
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB93515A8;
	Fri, 22 Nov 2024 00:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="w6+wkObP"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A75D10F1
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234704; cv=fail; b=q+L3952xZpk1YhX1Ldh0+lmBJMVL9DpAM17SH4YS1OJVwciz+2upZD8ayFW34t18ZVmT5tbsVYL5rUXs6OiO6mYaTaEZLqjnFbsgxJ5rn4EAnqKPNuL72LdlqUQqEDQsVRBhwnU5DvyHPUqk2D9rHWE+mM7U8ln7Z/Lzv7ktT8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234704; c=relaxed/simple;
	bh=8bpQStyBkK91KdDPIkZbc6pmdMPnSPEubYTK+qw3GyU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=OEV6wCx7wWVWPMddJF0+MsEMZ5s6g5YHp9oeEYzxZgrBXezb3KQO7KZyuYuCsiW5XNludQ+C1zHRrOcU+UuAe1AJoFxY/4YWAutXarjs9G0UQJNCmfbSBVpv7+8VZ4VsKqu9PIvNYDjySUPU2pEJDljg3gxdXmyERgFyi+n1tFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=w6+wkObP; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45]) by mx-outbound45-128.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:18:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mR+sS32rI5Bvl8zLZxfsxwZ3GQgtn6E+jCFXyyZnh619VuIRg2IvXahaCUdmo9GJVXka5T53rd7tQ4jRSZ1ZpNmJ6y5T8pnkXU2Hpn5puaATYlccOm/LqzxahlpsuVukgv4WwaH0V5kAWw1+rvCLttMfkngORsHhV3YnlKgHCYKfgxd6QlSWRanTB1ICQ5vQoh5IKtgBRcIQGAyeWQhhznIbdipi76j93PBzrORj0i/5XSwiLINCtpEpFP4pbJdfnI2GVRXWN+yiCdcjt7dMrfKevAkx0uk24wg97/rAwsO90hh9zAOJw6kCJC9gFinF5Hy+s5kF/Ki4/8IxiBdurw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J23l69YX7NA/7349eRj0sLkXHILG+D4JySFTE07qKlk=;
 b=h96vFcuWUuotl96VPP+TMFEGlLNkLdr4KIXmPrCUeQ4Mes7xT04KXCuv3QuLGlrAbWzfy1J4FA4Th9ePbal8D9RTwbpZWHOXfeBV8u/uN6x/AIlxEQj37MuBPeuLFLTgxy9itLRoeMVMwIeVlhwBvPD9ZD11XZamRVt8CBXt6t4A6KCg5t1SmSdf+tEx+WCBREyWrq4qvrD8QM+WRVLDtsv+esZMcdiGQN3+zcOLm+5kUDCirA8zBD7kv/0xfcJetZ9H+L6mB8hwxZFu3mWWWvEbE5FjHpfnsbaz6WMM5yAuuRCT6vWttRGyHNw6l3TDHV/+H5dql2frTRtTjA8hug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J23l69YX7NA/7349eRj0sLkXHILG+D4JySFTE07qKlk=;
 b=w6+wkObPBHx8qg23kAqd2Bwr/ihcVX857mbU7nqwzYdIZezNgJBXTytjzazbV24uhUJKX57+TVOmmQ7exisnxPzYbmb+kT8tD4ApEazqs9xeeWzMkKgGsToM6KQQuLF4LKVYS/px0td3gskI2VH8UA/WFHWufrTDb29wzDTfXKk=
Received: from BN9PR03CA0199.namprd03.prod.outlook.com (2603:10b6:408:f9::24)
 by MN0PR19MB5897.namprd19.prod.outlook.com (2603:10b6:208:37c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Thu, 21 Nov
 2024 23:43:51 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:f9:cafe::9e) by BN9PR03CA0199.outlook.office365.com
 (2603:10b6:408:f9::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.16 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:51 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id F32972D;
	Thu, 21 Nov 2024 23:43:49 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH RFC v6 00/16] fuse: fuse-over-io-uring
Date: Fri, 22 Nov 2024 00:43:16 +0100
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJTFP2cC/32OQU7DMBBFr1J5zaBxYk/irpCQegC2iEVw7MaLx
 JWduKAqd2cSocIGln9G//13E9ml4LI4Hm4iuRJyiBMHejgIO3TT2UHoOYsKKyVRavBLdrCkMJ3
 BxwQEEiF5q4Bkj95Sq6VvBdcvyfnwsaNfxcvpWbzxcQh5julznytqf21kNCjhXf2GM7PUcA3zE
 JcZxrG7AGcEU2Hjm9pIpdRT30+PNo7b3Lcg/S1Y1Fbnqm10TUTuXt/Mir7bSInNPxjNGNcSYWf
 YwpgfzLquX5CHfstRAQAA
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=7248;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=8bpQStyBkK91KdDPIkZbc6pmdMPnSPEubYTK+qw3GyU=;
 b=got7cwJ1en6LqEqZdp/Exs3L7f9nZ+eJ0JGyEzfDBa8UKYdRBM6N/PriYKw6m4iDxRKI+Dppu
 NW+NTnHhrmOBiCuLp5F3dCGrzmf567Wz7uAJHhbxqE+FHSp+kGKh0gk
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|MN0PR19MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: d1b7d453-fd28-4aed-47e4-08dd0a865a47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?ZGN4b2FQNEl0UU8rdEE5dW9VT2YyVGpScll6SE95U2l3ZnZBS1dzV0dzc3BT?=
 =?utf-8?B?MEpIRUl4RFY5OXlsK0VhWEVkZnVycGVZbmxqWmZ5Qjl3RjBxS1UxcGF5ZWkx?=
 =?utf-8?B?QlM0N3hHVVVLcWFyaElmUHdCN1M3SG1lYVlqb3ltVERuN1Vaa0JFR09KMVdt?=
 =?utf-8?B?ZE05cEthWXorRStVRnc3dEhEcmp4Uy9Td29hYnNsV0d2VVBBenN4bjZ3dEla?=
 =?utf-8?B?U2t1Q29tU3duSWZoTjd2cUlua0pGYnVKUEh2UW1KMVFoMGZoR28xelM4WGs5?=
 =?utf-8?B?K2p1NWVVSy9kMUVsUUlQV25wQm9YQTZtN0pRaE9PM1c1bEtrcFNvVVcvVUQv?=
 =?utf-8?B?VjJHUE9xTWhOV1QrRVIwQ3ErczgwSzY2TGpKQlNFQWlFODFuZXdnS0ljSENq?=
 =?utf-8?B?Q05QZDE2RlFWbFl5SERQWWdEdUNrak1RUHk1L3VHVExvR1k5S3Fub2x4bW5Y?=
 =?utf-8?B?aDB0YUdwY2hHeURraHU3UitBTndieFg5QzltazBZeDF0Q0ZKNlZYVEh5blM2?=
 =?utf-8?B?TitBbllqQnVPZ0J4ZFVhTG5tTmYwMVFkRC81bXJPMFN0UEV1dVBYMkpjNGZm?=
 =?utf-8?B?cEQ2dFdrM2dTVUt6cDhqQXJHY1d3WkdXb0tqWVBjRXFvUmlobWZqYitCTHRX?=
 =?utf-8?B?UkxkK0JqY0MvN1R1VmhISmtUcjVoQWxaUS9ZZ24yTFJUVzFKMWpMbnprc1Fa?=
 =?utf-8?B?VkdpMFhhL0t6MVlUOHRtcXBMcmsySXd4S2ptaXBCWTk1WXBINnpOYVFYUGVU?=
 =?utf-8?B?dTVKL3lWMVFLaExuRmExY0Y0SDRkYzlTVGN5WVBrdTBVTUlBUXFNNG05NmFz?=
 =?utf-8?B?YW1VSCtKL29VYTJDRkdvakhqZzVvOTZ3V041SFl6NjJmNHlkVFVlc2NRdHpB?=
 =?utf-8?B?Z042bGlGKzQxV0xwdVBsSFYvMkxzR2hBZnNSak1MTmdTdGxldUZlUng5QUgx?=
 =?utf-8?B?VUVCOWZTQ3dISXJtaS9vYTJ4TXBpcXZuQkJLcHRmemcwb3dNZ3pYZHdxSWdS?=
 =?utf-8?B?RUhLSmg3TENwL0ZnaVJXTlpkN1pBaUFScFZvdVFUZmRQYmZ6UTBnK2UraUls?=
 =?utf-8?B?amppWnZBcnhKSkhCbEpSMmhGbEdibWRQdU1iS3JkNlhqZWVzWklQcExFMGJz?=
 =?utf-8?B?R0N2ZnNVOVFidjg4WnpuVzZxazF2U3JYTSttV0VHZ2trL1VvakdtcklJV09h?=
 =?utf-8?B?c1BMenFlYm9iYXZBT0NuRUpoVllxVGJ3Nkk1YmZwVHcvcFA1WWYwem5yS1JG?=
 =?utf-8?B?N3QrUEF2WStPUUtRWVV3WldXNGVQczJERnZ0bFZVZEFFeVlBR2N5ampyMVZr?=
 =?utf-8?B?Wld6bGplbldaQ1VlelRmK3JLQU8rSnhkODdicUltNm5UVEpsQy9jaEhXZXJq?=
 =?utf-8?B?RUcxYmxJWC9wMmRnekdQUHdLeVQzYTJjcVphZWpReWVvc0RpcmJoVElZNnhy?=
 =?utf-8?B?VHU1WktRa3BOY0tFNjNYNjl0aE0vVDg1YUNkRmNUZG5wU09OOGd2dHdJMXRt?=
 =?utf-8?B?NGhGaDk5WitxOWxYSDJtdS9pYWJIZ2JYSStiL08rWWJDUXVCRUtZdFhpWnBF?=
 =?utf-8?B?cURScUNIMlJGSEhoekx2VHRrVXM4K3BQaGFZM0VtWERlWTZjZEM0YzhYRmhk?=
 =?utf-8?B?Z1R4dFdKUllDUnNVREw5Wkh3b0JSVmNPTDAveDBkNXN5ZEpjc3Y5c0JJL01l?=
 =?utf-8?B?WVdpVDNMUWRvSFpEcHBEVFBHT0tvWWRNeU5kZnM1OTgrc1RuM2JXeG9UV3Rz?=
 =?utf-8?B?ZE5mb1hRekkwVzVqZ1pJTGp1Ym42OUJWQzhETE83QkJ2OGFKSmk5L2RpTE5L?=
 =?utf-8?Q?HZCIlTGpDOx52QXWgZ6rEKD3yctkkTchlzcj8=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 irKO96hGFgu2wXg55i2mxPQWJk5qNgjmlLv2gCuHiDSHNuwlMVs4lpGCBvo3DllWKKy2U+tjGkhQP2dcsxstqa+BMv6aS2cWdniSrY6a65ZDQFN3NBqGQVb2QijQOVSWdD8PaLV8lp9Ho3Mdw3jTUxX/WkO1s3qIVtzIoqMz3ufmGRVvdItiZyHP23qhSiVLStpGSowtcsFwOr68xg1XByB6NYa1tnXKzUDaprjCaRe9irR2iqQGb5EOdY3ALJhv6qN++tlJnm+9RKdCshqha9ZILmgfae1T6x3qGC0v81TB2IOWhbRohVteaVMI/ktwt0T+cjJ2q6azLHfpN82jMrsIU99JyTfLrhxiw5bkeuQ4c6rAaEoIpFbM8PHjnxnUAoiXFAf7xLVh1BBCHoUhhrFvv2BoJwxKz1/ITik77BdZqSjsxkCWeeuDhvPuFCoSOlDYkqy2Ew2uMHTnanJC5E9gjCxpq9Mv6eU3Qrt/nWbMKY6pqHT1NzAAYBceyz7aL3MgX3D3Qmz1+SH6RFB/6REF/P0wuWusylu8Nj3NAZmFw8W1DoXALjOmenKLmLorI/QYqBCQsgOCc+sfHtdHpzmAMX1kiYJyx7CiYrrJpe8eoG8X09nd/afE7nPVQ9By1To0yUqL8ZNSOK6RF4Pzjw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:51.1588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b7d453-fd28-4aed-47e4-08dd0a865a47
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5897
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234699-111648-7012-28475-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.55.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuYGFpZAVgZQ0DwtNS012SIpNT
	nVyCLRDIjMk9IsktJMkswTUxLNjJRqYwHAQVDMQQAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan9-5.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

[Still marked as RFC as I need to run tests on this version
and need to review myself. The design should be complete now.]

This adds support for uring communication between kernel and
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
Bernd Schubert (15):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: make args->in_args[0] to be always the header
      fuse: {uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add fuse-io-uring handling into fuse_copy
      fuse: {uring} Add uring sqe commit and fetch support
      fuse: {uring} Handle teardown of ring entries
      fuse: {uring} Allow to queue fg requests through io-uring
      fuse: {uring} Allow to queue to the ring
      fuse: {uring} Handle IO_URING_F_TASK_DEAD
      fuse: {io-uring} Prevent mount point hang on fuse-server termination
      fuse: enable fuse-over-io-uring

Pavel Begunkov (1):
      io_uring/cmd: let cmds to know about dying task

 Documentation/filesystems/fuse-io-uring.rst |  101 ++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dax.c                               |   13 +-
 fs/fuse/dev.c                               |  139 +--
 fs/fuse/dev_uring.c                         | 1339 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  201 ++++
 fs/fuse/dir.c                               |   41 +-
 fs/fuse/fuse_dev_i.h                        |   69 ++
 fs/fuse/fuse_i.h                            |   21 +
 fs/fuse/inode.c                             |    5 +-
 fs/fuse/xattr.c                             |    9 +-
 include/linux/io_uring_types.h              |    1 +
 include/uapi/linux/fuse.h                   |   57 ++
 io_uring/uring_cmd.c                        |    6 +-
 15 files changed, 1939 insertions(+), 76 deletions(-)
---
base-commit: 3022e9d00ebec31ed435ae0844e3f235dba998a9
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


