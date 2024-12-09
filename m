Return-Path: <io-uring+bounces-5333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4959E99C5
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:00:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8D57167A3D
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4371B1F2C47;
	Mon,  9 Dec 2024 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="sRd1fnlw"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BE41F2C32;
	Mon,  9 Dec 2024 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756232; cv=fail; b=OedaKGmiDapS/DSCSrgr1yzGpJ5zSxH5+PU56hC7WLl8tHk9Cd5k3gnpX9m6+Rtkash8DdANu+87GEQiD5jiQ4zZQkJ15q2m9XDEwtp1f3v05vaLlhoHV6iHqicmutjpNddOHnLXgvy4NjO3may1wdQC2UEEiCXb8mvL5Ku9+80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756232; c=relaxed/simple;
	bh=vyvDQSJ1XI+fEabnJgEM/4jvYF5XKXZtUiZp5djYTcg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=DbFnQrkPncWgyeY7IZhxYVRRLBWQgSKtbEn4OgJbrex2xiEFmcqYS2cm7U7NDgjrVL+C+HurCKv6mpUzpN6Cn/O0dZ5GkcV7FILKCtGj3QfZT+Y9hYbLLAPoOjWGoHhBpfNH+GVa6OuyVoRbyv3o/jznOyJjIf4LTnjFwBVDimE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=sRd1fnlw; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170]) by mx-outbound19-133.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LusxB/JRfXhFSHBKT+FAM1ZaobZ4c4cScwwAnARRS19tc2AAThDP3rCbOig0PwGrZ8x88vCprMHK4yFTmW9Jm7gA2cw4Co6OzHzHw3Ohg0GQMfoYUs/cY8vskV9zdzj4NofDg6EqfWb73pbU38WnUbUxZBLdHFcWWMp0TbAaJYA4UjcVFFR2HwgQAFKrbiBK9Ysl60UJYMbksBZOcctqSCYfY3Xm0CnYJxdWi2ON1OQgUoZzhrbE5V224g/kD/zKbYdXs3YxBORxxkO49JVodr3AYmxtN4iyhlwilDC5PKzegQy5l01FMaOmbv+vZkfRuqsNOna9B4CFgGq/ZEDeBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bc7UKzah+8GcrxUNk9mUTn42LF1VHiJfXznsz4g5wK4=;
 b=ctFmlige/4utjCXo3m4ZscO9BCFCRJHVBZyEq7QFEv6ankW/Y9qe1RkqXs6Ji5/Mm709ynZTAljSU5Yt6gk9oERGW0zW6c9UsW958G3x+UxBHKrZ/AwiGZmGtwrxqrfg3zayhzOrlD7VHHRJLKCFuyHpuslkJF7XZSf0xjmLwm9DJMOxWB/hLsVJb+71YdyT+DlEzTtocBAa9yjzwxO3vUxXa52cLIErfwfnOdKpkQkEK/oCH6Bo67Ywccs/a8gjj9c0Gtdv5rCzOeRkHg0Dr1+Hf4qCTuqon5g2XuUZsJ9rE1ck8THPQFK3fWzszy04GytQQLec9nK2+35tEYuBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bc7UKzah+8GcrxUNk9mUTn42LF1VHiJfXznsz4g5wK4=;
 b=sRd1fnlwBY7QEMLnPs2X6vPXfh2BJcQxLoMElEYh7BfoUVH8lo7HU+9gBSE8NPs5Ugmhwy4QRl+p67U4NcTHvy9xDTzC4Ik6L0JF8Q4PJ/nGV0+TDAxxRlGOsXJBdYYAxETUyU1KFQX3GnDDfwLO2vJwW9LTCFuwiRmYFtwm2hA=
Received: from MW4PR04CA0202.namprd04.prod.outlook.com (2603:10b6:303:86::27)
 by MN0PR19MB5827.namprd19.prod.outlook.com (2603:10b6:208:37a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 9 Dec
 2024 14:56:41 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:303:86:cafe::19) by MW4PR04CA0202.outlook.office365.com
 (2603:10b6:303:86::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Mon,
 9 Dec 2024 14:56:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:40 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id BDC204A;
	Mon,  9 Dec 2024 14:56:39 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH v8 00/16] fuse: fuse-over-io-uring
Date: Mon, 09 Dec 2024 15:56:22 +0100
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABYFV2cC/33Py26DMBAF0F+JvO5UtjFjnFX/o+rC+BG8ACLzS
 KqIf++AqpQsyvJaumeuH2wIOYWBnU8PlsOchtR3FKq3E3ON7S4BkqfMJJdKcFFCnIYAU07dBWK
 fAUFwyNEpQOF5dFiVIlaM6tccYrpv9OcX5SYNY5+/t0uzWl83lBsuoFZ7l7i5gFsam34aoW3tF
 ShzMJLrqAsjlFIf3nfvrm/XS7/b8P9ts1rrVHW6LBAxPOvrsrl8rhGC6wOmJCZUiNwaWmHMK4M
 7RsoDBomRVUDnPQ8EvTJ6zxyt0eunClUXFk1tnf1jlmX5AQv6gzTaAQAA
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=11064;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=vyvDQSJ1XI+fEabnJgEM/4jvYF5XKXZtUiZp5djYTcg=;
 b=2NFy+kl3ovfHq0V9kzMeMqPmOB0hhax6at9YEFLthh/1/Qal9e++PxSqBye76lh1+EoHsyceJ
 T6LUBqE1UugA77O7RiAKIjl1crHNvKgUtGt6StE6m0gCTNSRcSTEE5I
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|MN0PR19MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: 299d60eb-8a12-4d3f-db4f-08dd1861b059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWVFNXBiMGdVejdDQlNZbmNYWUFwMzdQNmZKZWdGMExRSm5lbzJhcko0Ykh5?=
 =?utf-8?B?L0RFNERGQkN2Y1N3VHVhSDdUaWVpVzVtWVZ4aFVqRTdZcjZTZUd1UWloYmxK?=
 =?utf-8?B?cHptZTZocDU2c0xVZ0J1Z2FkUGcwTDBOWDVOV3BQVytob2VJWGVYakxDKytH?=
 =?utf-8?B?bWdIYkxtRWtPaitoQ1MxVE1Xdytyb1ltU2JwVkFzT0lndUdIZ1dXV3JLbEtZ?=
 =?utf-8?B?eGtQaEludWxjbVgvckIyRlNWWGxHeWFKTW13M1RYL1pWSzRtZnlHK2xJc2Ux?=
 =?utf-8?B?NlZ1d2YreDFrbytqZGNwcVh6RGs5aUFMUDNoTG9BRlJkN1dyMmZsKzBJTXJT?=
 =?utf-8?B?RHhLdkZtdEhlODNPK29zd1NFdmk3a0JTcW43ZlR2R1pUclJFWGdZOGp1L25q?=
 =?utf-8?B?UEUyQ2IvN2dNVnd5NTFvMjhPYXdoTGlKRmpnQ3hBQkdlVG5jQU10S2dmRHhr?=
 =?utf-8?B?UDZKNmVNdVJQYmlqejRKd2RhRDRUVkFOWXN3eTZWMGNzQmF2N29WMUVOc2M2?=
 =?utf-8?B?QjQ0NEU5VUxSV1duZHYvc1orTENpOWhPaHRZRWdUUVp2SVhtbk1RYTEyRkxp?=
 =?utf-8?B?czNZcG90bUNNUXRDOWdyb21idkhZUlo2VU9QZFVmYWlBQlZpQ0FOM3d4em1Z?=
 =?utf-8?B?TXVCM2E4VFJ5RG01RlZ2cWlsTjBiM1h0SkxlSHlKZUZLVlI2NHh0WHVML2FW?=
 =?utf-8?B?d2VxMkduWjhTR1BlTlNjMHFuQ2tkQ0QyZlpWdzd6NFowRncwRk8weml1U3hv?=
 =?utf-8?B?dUt4RVVKUk1DRnRQTzNtSU1NNnZMby9FT0QxbXBOcEJoQVQ5a0V1cDVGWXJP?=
 =?utf-8?B?bG5zTlNXblVWWWVxMm1zVG9QSXZ0VGNyclFIbkZqci9hdExzdTRCWDc5N2JF?=
 =?utf-8?B?TjZVNG93N0tmcHdRcnBudWxGZzhQVUl5WVNvRFplRzZ6MjlMSDZVUFcrMzRt?=
 =?utf-8?B?dmVrY25FeExIUlpXSTEwMTkvaVUva0gxNWt5eEZkQkVoUE1aRXhLWlJxcThs?=
 =?utf-8?B?amt4eHB0S0tLSGVYOFFOclNTZUc0N2NuZkNBaW9LOVVJMFd3VHc2U2VmRW05?=
 =?utf-8?B?QUtmcDdjWDhOWXQ1WE03N0ZJb3N5dk05SnB3S2NZQjFnbC9FUHpqVFIxb2lM?=
 =?utf-8?B?TjFFUUZydWdzdW5UdEtjeG0xc1JPYXJWRWFScFNqMG1QaFQrQk1KdWt0MUJO?=
 =?utf-8?B?L3BEQnBTSXZDb3haKzd1dnFZbEt0c0JHeitCNzFLLytnUDFoVzZKbFovaVhO?=
 =?utf-8?B?a0EvVzVhZjlBenNpRUR6T2tTQ09LYzFIemlRbE5kUW82T2JpeHY4NGFFdExC?=
 =?utf-8?B?aEJrVERXQm9MWWhpWHVMVW5pMS92enZlQU41ZzVnUytZanltRXNXZDZUTHZk?=
 =?utf-8?B?cUlCZFZHT3VXVTFjcXhwck4wdnlXeTBRK1VXWGVyVU9uVEtDTHB5MXFZWDlK?=
 =?utf-8?B?b1hqbUswOVhUS2pVRU44ZjJUYUFIRlNTd3lNNzZLYWlzTVZRRkp0WStqSCtT?=
 =?utf-8?B?VlpVcTRhWjRwMHFjSGVHbE5rZU9GTXB6SSt2YUorNVpVY09ZQ0ZDRndOU1g3?=
 =?utf-8?B?VEpzL1FHZlZFZW82cU1jazAwbWtPMXY5b0Z1bHY1RFdWanVKNXNGWUNZeDRK?=
 =?utf-8?B?dkt6MTdPRVJFQ0l1czdOalBaZzJtV3ZhT0czOVhwSEpnVm1YUThPN1JwQmpR?=
 =?utf-8?B?QTFrUXNvcERCeXJGUUYyL29yYWtUeFdoQkFHajJUa0s5NStkOHF2bXMxb3hw?=
 =?utf-8?B?WWZxWkJnU2RwdzBpUVlWZTF1SHd5ejJyczZlclNLRnpxYVh4dUhFOHFmTTIv?=
 =?utf-8?B?RTJBQi9XakNQRFVGMENGcTZMTjBMOXR1UHRqdVVvOVFEdzFyYUJxUlE1Mjg3?=
 =?utf-8?B?M0NLNnlBaGR6anlTUElXRUpCcU9Ob1pkQVJRQ2ZYUnpRM1hhU0VpRjZ1ajVu?=
 =?utf-8?Q?798K2Oo9KOXBLqAUeXdmwKW7UI7V13zJ?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oqj1emcKnw81eF5gbqUI0mM2KCAQjhiKmyZmOJHHWPjRuUMO0PA3KfPw5Ub+vQXcGP5/jYJyh9TmVJh4SxrAY03qps5H06r5zTvDJIQzK5pdr98QfW8i4QwJx3uaowNpjYE+y65SRB1klMig+i7a/VpmWtp6elYsYERNzSWi1X6ZFnviZJQ2Vp32isV1+4B4SkK4NYrNUJfaE15S8JM+m1jai7hLihz/dMkc4FerGEd3+w5ha/punN/PQQd9mBbxXShYowNtJWLh1uzvGYTkLLXSYxqkUy/L9PO388DpHvOzx7PjcBXu78vhlWbvK0Ttyj3lZ2t91S/ZeBabNRlnGg1XomhpJqUARjoBmtoGRcHALF73qNe75emtF/a7IRwm5eBNAjRK5K7ct0j+MTPsCzL9d0T9Ryj3BT5Y3YpwBEXAe58wXvYs6Tm2QX1POqRVEM8VmwovSLVT3mr+SO9h6CDxsDVMnSpTigu1+kgu/bnTwqC1kJXETi2Szrao3q3jJHUpblEKf4s5Uy69QeW5wTOaDHJfnsmiQnpB87npCqGDp59cwzRZB3aUqOCn/mZRSuzb6Cj42EkUgjSPq+XhUDj8IW8dvUeGkIDSy1avMEwJ7j11EnPUCmxZNewAQeFKxamPndY51lXPrlm09gUpwA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:40.5114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 299d60eb-8a12-4d3f-db4f-08dd1861b059
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5827
X-BESS-ID: 1733756205-104997-13378-6651-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.56.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGFsZmQGYGUNTS3DA5ydLI1N
	jAIi0pLdHMyDAlLTXVwMwkySg1LdUgTak2FgB3YbGdQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan19-214.us-east-2b.ess.aws.cudaops.com]
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
Bernd Schubert (16):
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
      fuse: enable fuse-over-io-uring

 Documentation/filesystems/fuse-io-uring.rst |  101 +++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dax.c                               |   11 +-
 fs/fuse/dev.c                               |  124 +--
 fs/fuse/dev_uring.c                         | 1308 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  207 +++++
 fs/fuse/dir.c                               |   32 +-
 fs/fuse/fuse_dev_i.h                        |   68 ++
 fs/fuse/fuse_i.h                            |   27 +
 fs/fuse/inode.c                             |   12 +-
 fs/fuse/xattr.c                             |    7 +-
 include/uapi/linux/fuse.h                   |   76 +-
 13 files changed, 1910 insertions(+), 76 deletions(-)
---
base-commit: e70140ba0d2b1a30467d4af6bcfe761327b9ec95
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


