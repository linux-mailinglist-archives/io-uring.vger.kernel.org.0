Return-Path: <io-uring+bounces-6085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CCE5A1A648
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39A093AC811
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A615121420E;
	Thu, 23 Jan 2025 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="BaCGiPxT"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE28820F971;
	Thu, 23 Jan 2025 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643911; cv=fail; b=YmOjeuO9emJcpjCuiyM9MCumzi2oaTD26Ve+bkI83olfrHZO/9Rhw5VYxRwYQuodDp5ud6BO8nWBIEzMYX1eIKGgH5ha7cYKEfnYFHIrXyc95+GwQvxJUSS1JGpqkCQJB4DXSiJS5evAxBiGSTwJpYIpHKxolMK8AXNKP2v4NOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643911; c=relaxed/simple;
	bh=NXZl+GygX3zSlvpFSX58oVOh7EcV3dfte05lWH9sgmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZvCxClUt1uZg3dRMltn2T47H+Nbi2NsxiAPbs9uBDYdJjvMZFZm7pn3NCq+rJwkcoDgrTF8+6kGB68vrGMDNC+LWtgTCQH/6TtP6T9mPboILajuJIGZ+bx7+j71nseIsE0895sfZ48T9PhmQBvzzkg5V2oQDQr6MyA0tbLmwlKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=BaCGiPxT; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44]) by mx-outbound20-29.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjKTbjNLIduvZWuIl0I5QdUAkOtzLolNGuz6hEVSvi8t532iFXvYitFvaVPP0iVvCtI7jWp+Q7cjkhmKbw5zSu/XsxNKkbK53g0npDLoin4La4FuoOglHoPjnKzrVcbBp5VJ0c8sSVd4FzuCBHxduav7uuwMAnRWcg9T+hLUf2XGOXuDdOc7o8345J4BWtBNmmX3K7YUfOmCeDv3V0NZMinhyZ/2xg9v5Uq0uXXl4fNp13sLGb3YqBBTN82i+T8kLQQ7AeHWx/WnAp4yg+l56IeOk3xmqo73WYsDeCcC2CHuLLUeo409WqNyChYbdnGHJit6NdMFC8dbtvzWVOaokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdU8JhlrwpeChLQ7InT1cILLXjG3597xLtLscm3hkUw=;
 b=FXLCQxKtCEp1RgC6hD2bMnHwfrhgYcy3RKb3hAtgZnaWR1NOA/dYcXq8WDZWkTU3sSWgADpR8H3BKm/8K0CWqf9YQWYFVRLqR32AIRLFK4183v0FgKgOMFHXih0b3rJy67gwAclR6dNQZPLr6Y1fY70OZq5NAnwpAPENFmQbclhEg1N2u+OfDUbhFr4yC9rV6/qAnigLytBnevQ/UF0xo+sUCU05e6DQROdWhJswHP+Ja3W41kq47JgSWoGWPphrEUNEEEF59bA0ozJaYmGdA3BAQ4N0QK+ngoSIlz0OomhoKimsV3zPryjd4Gcta+3ijveDGKmWqOYDDZ89v7bQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdU8JhlrwpeChLQ7InT1cILLXjG3597xLtLscm3hkUw=;
 b=BaCGiPxTzpDsP2asurpwtHuYK0f7Lv9J4j4gHD7jhtjfm/9lwpIJcQ9uKFlsXVIuyyG/VlMXeYHWYiEjXHjOAen5KXae3AXDt/1+vWNp6sULtK5ZB1tDxFlHx9S+iqcUSvFKTY0CPIAzgxyeetcljOOWAttVuqO8nLIkLRkM2F4=
Received: from SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9)
 by IA0PR19MB7653.namprd19.prod.outlook.com (2603:10b6:208:404::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Thu, 23 Jan
 2025 14:51:21 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:a7:cafe::cd) by SA9PR10CA0004.outlook.office365.com
 (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:20 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id EF09D58;
	Thu, 23 Jan 2025 14:51:19 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:07 +0100
Subject: [PATCH v11 08/18] fuse: Add fuse-io-uring handling into fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-8-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=1834;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=NXZl+GygX3zSlvpFSX58oVOh7EcV3dfte05lWH9sgmo=;
 b=pRv1iOxHRc8hadrdtLkP3YoTjRo8ZryTyKsiuANahe9uD139rDkps4NGo52/2ILrAjVtwTE4q
 IPC5xOc4R/AC4U1c/+t08AIHrDsHYW/DykiZ8G2uPZNxoHOjQl5y1Zk
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|IA0PR19MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 8540f14b-6996-48a2-5c19-08dd3bbd6656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekFEejRQdm5zNytsYlN3Zm8wcitrY3RpNUZUVjBJT3QxMHJ2OWYyZlhTK1VW?=
 =?utf-8?B?ek9uSUE4UHRlcWxnZnJqM2R1eEplU0ZTek5BWWhPS05rNTVmWlBkZlIxYktu?=
 =?utf-8?B?c3huTHZxUHo3Zm43M2lQNGlvMm9MZ0tEb2FHR1NpazlQeUdlaWNDM2RKd1lI?=
 =?utf-8?B?SStSSEZGMlV6NFAwQ3RSUkM3Y3IwVUJzREttNllaQzh6aGRmSzdheHBHK2hS?=
 =?utf-8?B?SGRnYzZXbTk5and4RnZQelgrWFdKV3JMMjNtaVB0S3hjRXFwTXoxQ3FTVVlV?=
 =?utf-8?B?K1BuREhBS2JjK0t0RkNzVVNDME0wRHd5RzBTYnEwaDdDSFU3Z3VxWFNXdHVG?=
 =?utf-8?B?OE82SnNTRmtHb0xpbFIrbE9aMW8wcjUxUVBmK2hnWUNpT1hGbjh1MVFzR1ZW?=
 =?utf-8?B?N25vM0dvaE9nbDNUVGo5UUlETlZqaGluMUxRdnpUL3pNcWdSOEZmaEFiRWhu?=
 =?utf-8?B?VlR5QjNVU1VwQkRRMW1PUE1NQ2hmakt2MWV4VC92QmlHaHVsczN3MkgwWFFK?=
 =?utf-8?B?Z1o1b0FTZXZyZ2RZRVNFanJKdVhCUFVLSkJ1M3JLbUFzWGdUTUtMWDVzY04x?=
 =?utf-8?B?SXJkTHN1RU9DYVA5ajYvUjRhYmZpUC81VmZMcnpWL2dYcmt6ZnF6djJWWmZs?=
 =?utf-8?B?a1BldDRhdTRnYjA1UUxKTTkycEE0cG83MkhsMHBQODJXZ1lWajlqTUlLN0dJ?=
 =?utf-8?B?NlVDbVV1N3l1RndYYUFnSENKejE2YW0xTjlOWGthN3JIVFpRQXVkSHBrQlhh?=
 =?utf-8?B?aEl1THRZMXBHMngyZ1pCWXpGNzM1dkZGZmNtTWhDeUFKeGlvcUx0MC9aTXNv?=
 =?utf-8?B?TVVZbDRkaFZ4K0pLRkNkd05FRkJMTm8vYUQrMGRpZ2ZQejFoQkFrWkpWcUlI?=
 =?utf-8?B?dmoyaXcwVVZnOE9PNGR3VElxTXZhbkcvTW5xVUxXTVVuYkNyNVl6VXhGS05r?=
 =?utf-8?B?aXl5ZklVblIxdTRRRVVPV2t5bVU3aXhzc3N2cXF6U2o0dk1IMXo2VE5aUUk0?=
 =?utf-8?B?MUhVZ0R1NWpvUWlKUGlWQlphb00xejBGdFlleEEySWFxMXI2UVRpK0VTU05u?=
 =?utf-8?B?Z3BERXM5RThLUGd2bmVSR2ZLOE1abjlLVitWWUMwMm9lVXdkMXlXM01rVHZJ?=
 =?utf-8?B?Y0pIVGI1WGF0a2J5N0NHNXdYRGkwbzhhWm45Ti9XTmg0UjViZ0tXcmV1UmMw?=
 =?utf-8?B?ZWhlaTNUQlc5NVBtK0NsLytKQmMrTWlZVVhOZnhGTGhuazVHL1Fnbmw3QWVW?=
 =?utf-8?B?bWdmZFNNNGFBTUdSZTVjQzlZZnVSTzZzL082L0hmdTA1OWM0cE1rOEZhZmVx?=
 =?utf-8?B?R21iRUZjUGZvcHNiYlRVRi9FQzcyWXlNK0tWTTAyL09VYlVFMCtCT0FOamI5?=
 =?utf-8?B?UUQwaDdLeDc1TGxOOWh3d25KcVlrNEtsbGE4ZVFuK2ZoaWVPMWZ5S0xUbyth?=
 =?utf-8?B?T1dMTUNaQklKajhocHlXQnZXdUZCU0JQVG92d3l4eUNZcnhLVGNiQ0JuYnVy?=
 =?utf-8?B?OG10TVl1MkFESU04elBuYkU0MU5qaVR4TWpzSTFSbG9PT21FdmpQZHRmYk1J?=
 =?utf-8?B?TEhteS8yK2tGTjBVSUpJa1hZS01WbkZiMlFERU1ETlQ4eXV4ZkFOQU5CRUs3?=
 =?utf-8?B?NzB0UktZSmtlc1RlaGoxaEJSMFVVUDVHQUFhOHJoUHN4dGUzaEFZTjlqdkFS?=
 =?utf-8?B?YXp2NWZKUmR0NGFhOE85UW1vSzZLY3Y3cjZjbkdGQm1LRktCOXpTTEpiVU44?=
 =?utf-8?B?UTZGQk5PMHRyM1hxNlhhOUJseDBQSDZWQmdUTW5YYjE0NjRQM1lsMjBscW4v?=
 =?utf-8?B?NTZRaEF4enVUWitFWTcvOHVHYk1ZUGs2RHUrVHgvcUszRW4wVTBVTHFXMFNO?=
 =?utf-8?B?MjQ4RzV6Vm5wZFpFZFdUaWw1VHB4VlB1MmtiRDZEQklQQXNta3pWeE9QbnN6?=
 =?utf-8?B?YnArTlZOZ2RLWDNoMTJrcFV5dlNWeHZsSExCNmV2K1NETVI0MzRWMExXd2E5?=
 =?utf-8?Q?YKVdr9xNKAayd2Vmli4uQ1emnqZ7+s=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	POpvlF4gHB/ffajc0alZ5Ze5rcP/6ebNJ+vivmdEfspLriG5nKtHT+8bh8y3bOMwzeJYdNxPXRIopN2dNq/rlnhGfOlNCdFwtYv37lJ0vCCV058XTqfxxlvQErYLKAsTlEkg8rDWYoPq6d3YDnhIIVRYeuYJ06dX1MfU2RIVFzPslr+RzUISaEOx9vrLiVsC36vkt0ZufmVsHsbzC1bKz+KaH4dU1/4F4q1izZBNx+3EkheLVwPiae82MFcyXaniy2WdnFyq9Uf7eoUmQJMkjcdsI7kGxcE07WOUIO6/GKIKwithxCO+yavqZwupOqSE9+oMKbB2VkH1cG1r23kwi1M4ZozjXa9pA9oDSN/4VpTNybfb/8apCjbJxTMJx8rE+OYnm7o4yw0RFcSP3yob0bL6PGyX0nIMbxYpkJZK7FbsC6WOek63kS2MqvFZ5G0x0yqAIRrU6bohoipEdIFoGn1Bc/QTiJcznVT2V3UpQ551YSx7tgX/Lm9EgVIjgP/qAA9k72Qla5oEkuMv0+9QFwo4nCj2g7M+3k1wOP0vlh9PARuNgwT8rmimnq38qA+SusrDwXXGbesCk/TCMp3l7o2wlHi89M9GR1sUkwDV8jabkiC6J+dqaHpjk39L+R89YyxeGyMO1lV8PPgMMhMisg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:20.7490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8540f14b-6996-48a2-5c19-08dd3bbd6656
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR19MB7653
X-BESS-ID: 1737643885-105149-13395-5958-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.70.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobm5mZAVgZQMMXEyNjE3MI0OS
	3REEgbJ6VZmKQmmSWaGqVYGicbpyrVxgIA1hau40EAAAA=
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262003 [from 
	cloudscan16-40.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Add special fuse-io-uring into the fuse argument
copy handler.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c        | 12 +++++++++++-
 fs/fuse/fuse_dev_i.h |  4 ++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6ee7e28a84c80a3e7c8dc933986c0388371ff6cd..8b03a540e151daa1f62986aa79030e9e7a456059 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -786,6 +786,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.copied_sz += ncpy;
+
 	return ncpy;
 }
 
@@ -1922,7 +1925,14 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned nbytes)
 {
-	unsigned reqsize = sizeof(struct fuse_out_header);
+
+	unsigned int reqsize = 0;
+
+	/*
+	 * Uring has all headers separated from args - args is payload only
+	 */
+	if (!cs->is_uring)
+		reqsize = sizeof(struct fuse_out_header);
 
 	reqsize += fuse_len_args(args->out_numargs, args->out_args);
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 21eb1bdb492d04f0a406d25bb8d300b34244dce2..4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -27,6 +27,10 @@ struct fuse_copy_state {
 	unsigned int len;
 	unsigned int offset;
 	unsigned int move_pages:1;
+	unsigned int is_uring:1;
+	struct {
+		unsigned int copied_sz; /* copied size into the user buffer */
+	} ring;
 };
 
 static inline struct fuse_dev *fuse_get_dev(struct file *file)

-- 
2.43.0


