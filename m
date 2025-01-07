Return-Path: <io-uring+bounces-5712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8472A034C5
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 534DC3A4E52
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A01D74059;
	Tue,  7 Jan 2025 01:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HXwzjhI0"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9C97080E
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215173; cv=fail; b=D612/ScZgHHJYP9HKuIH+IlJ0fvhyxJX8rbPpnuNfrPNTQ6zttYIuB0bkIER4rhCxUqjTy8BvsRM4WcsfrNVyt+E3/jAm/ZUj/nhpcO8me8jtdzONTApd4y1rTMFSPA3GEJzyRdJwf7iDt27tu8iB9ldNPDxYjOb2XFxq2WHj70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215173; c=relaxed/simple;
	bh=M3GcQWwOaa8BbwZh7SUIGaTx+lkvQ0F1YCuEjX2dKV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WyDsc7TZcXnnZ0ht+WJoqTRLLL87zLnyEpSprL0aKe8gl5dTZEj29kXWTgpJUksFpTYwPYAopXz9JW6LHEJi+YRiMmGNxvyL8HM8XJRfpg/enCP+fZv2IAPGvjo7I69wMnqJcIXe7ulv1svtqZ5t676EdhCKpQCC0NWHjw55edY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HXwzjhI0; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44]) by mx-outbound16-53.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lHY4M/6vra0mdNCp8WRFB8KylsrVffvdcDfjg7OXRyevx01OKfSKTWgPg2BcA0YEPmHegF68KxPUXgYIO1ONn2kAxrWJ4eFrQHGi4Hyy3DYjcrgG97cwijeOwZnR0sqwCaAXJO+FD2jJ61yDK/rxzVH5MFcHpVC6TPLTjp4J9zqEX9MfFkzMuZWDK4nxt9hkGGthVp+DX3J9S7HjLV3jkwIfb/XNNyY+e5q6EsD/Bt55UT8zEVtw2tQUbyWP40HflwlnxqzBIt3DV72riU0iVVTfMf3w1j3PfE6a+53ZuM4lf36wgLlw6Ev2NtKr+RSwJdiA9io0rjCNZJTeIzdAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHfDcEdVZVOJHvupseE7n5zjDtvZEF9X34YNo8Rsf3U=;
 b=U5m8Yy2+RrZiEeQUOp+yDsyw1NrRK1EpX/ky0oJlfx7JfhN0i1nXuKf53uo1ot9RVtWRbaNwmHU+vTr8gmwFiSRv4ayV2arH/TdTgosl84yVvk0XDKiOdUJbxuAJKvvwUwfAJGY6sQDR1Icx7r+2vvq+jx0XjaQg5lzuHpU9x7yt3sCuGuZ03RyMOfWhG7gOBSdzECMVC0uTnaJvCtmNLLLvFYRnK6Yl+UbCUiN9BnBKCUgWalX+Us8FNL4TAP9yyl5qv8582I1fe+tHWVH57B1iyUaq5REYo/QAKMh6B3NgJShR7TTd6wHa9vefafjEXh/DergvQm7uJxobJem4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHfDcEdVZVOJHvupseE7n5zjDtvZEF9X34YNo8Rsf3U=;
 b=HXwzjhI0wkwzMWeeWejyVEvNvU0hgnI0oKO7jlYhDY4VGCJeg9T27eS779GH4COtDqc3wDpi9SK+WW+d8mW8mUJhJlWj8I9e/ct6TxNOw2nquJGQKWK0WCVp5nKSuWn9fFrSXhPHtSqb7rduUo21V/WKV7B9TGxF1npbiq78OM0=
Received: from MW3PR06CA0021.namprd06.prod.outlook.com (2603:10b6:303:2a::26)
 by MN2PR19MB3824.namprd19.prod.outlook.com (2603:10b6:208:1e6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:13 +0000
Received: from SJ5PEPF000001EB.namprd05.prod.outlook.com
 (2603:10b6:303:2a:cafe::9f) by MW3PR06CA0021.outlook.office365.com
 (2603:10b6:303:2a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001EB.mail.protection.outlook.com (10.167.242.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:11 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 564AB55;
	Tue,  7 Jan 2025 00:25:11 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:06 +0100
Subject: [PATCH v9 01/17] fuse: rename to fuse_dev_end_requests and make
 non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-1-9c786f9a7a9d@ddn.com>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=2781;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=M3GcQWwOaa8BbwZh7SUIGaTx+lkvQ0F1YCuEjX2dKV0=;
 b=/TcddYdapSGIvwvi26FQV53HSeaAFbuQX7b58z06Bi3e9BFCdW3mDLI9euem4zeV4oCKfSL2Q
 5iCnc/i3FjMDSYwflfxyp1fe61lRjnpk5Fw0XyHoHQwTRNbypvMvVeT
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EB:EE_|MN2PR19MB3824:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d650d0-e1fb-49dc-657a-08dd2eb1bfee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0RGTHlINTFIVloxWFozYTk1dFoybTA2SkRaRjZENWVhc1VGM1NwazBUV2JY?=
 =?utf-8?B?Tnhwa2tmQ1dteTdOV0dtbTZXR2c0bE11NS9SZUJldEsyMjV2VGpIaWVySG9y?=
 =?utf-8?B?bnpIams2Y3V0Ry9IL2RxYnJjUEtnb3FtaGJIYVo3UFVDaFJ6VU9GeEoySHdU?=
 =?utf-8?B?OUgybGNwK1ZqTTRJU0hjZ0h4bFhmVzFLS2FmNzk1eWFGOUlSVUNtNTRYdnlr?=
 =?utf-8?B?UGVXUGlEL2Joc3hMQTMydUZadlgybGhKejF6YTc5SmVZc1lvSEk1b29HV1pZ?=
 =?utf-8?B?Ymo5RGcycmQ0bHFoWFBlVVlOVG1kTzNqbWM5VUF1VXg5cnNMSEFQemhURVBl?=
 =?utf-8?B?MDJxRkw5OHpjdkZrV29halVSb21sOVRiTWZlTUh1U3JGYTNYaSttRGpZSWwv?=
 =?utf-8?B?NElwcFhDNS80YncyTUpSQ3RpL0pSelVPeFJkem9ENDRNYUpoVmQ4VFNieG1N?=
 =?utf-8?B?Mnk2K2liTktPb0Mxc2QvUlZMejBvQWN4cTJIT1lpaFo1L3BxeUhackU5alVT?=
 =?utf-8?B?RkpIMGFFeFFXOWZGdmtKVG9LQW9Bb3N5Tm9oRDFIQmpwMkNvcWJkcXh1bFBJ?=
 =?utf-8?B?bFRsaWFOVEE2Qk1scTZEN3hNWVk5M2V4TzFBa2dTUnRPbzd4SndFSlBWb3lB?=
 =?utf-8?B?UGd2OWZ4TGR2UnB4WTFud1RIQWoyVDRycXcwcXdhRUs0ejhjTVh0b051d0Vv?=
 =?utf-8?B?TW04YmxqQkNrSnZ5by9HWmxtS09NcTBJSHRPSXh4N01WZmIvUVgzdmJReE1D?=
 =?utf-8?B?eEZ6L1hUVWczTlM0L0wzeHVSYjJzbzlHSkMxQklTQ0lVWDgrUC9yempHeFp3?=
 =?utf-8?B?czBLa3FDTFhOVlA2N0N0TEtwKzZmeThnZjNJSjRsbWRuTGtCbmU1VnJKVTZJ?=
 =?utf-8?B?QTE2TFp2ZVF0dU9FOFdDd0taRWwyd0xOV04yTy8za2YvNTV2UVJsWHVTVXdU?=
 =?utf-8?B?K1pPWFpGVVBoaFFyNExVa25nelZ3dTNHS1VMcjVDbEVQSktqaWlYVmhmYkNa?=
 =?utf-8?B?ZlVjcUVZSE5aRktGRng1RHhHaWRRRWJ3UHlOSENyV3ppMkt6NlJzVE9uaGdT?=
 =?utf-8?B?alhQdkkwQXlOUnRudlFoMmJ4dStPb0w4eXVGOGVNRHV2eWt1ZnR1MXZvNVRn?=
 =?utf-8?B?Z3RnaGdrNiswMUM4RGtIVnRIb0RMd0svTnAvWWVPb2dHS3o5eVBiYkJ5bEZI?=
 =?utf-8?B?cmJwZ0JOZFdwQXplNU02ODFoLytyUzhDejg2bjlrV242QVp5aDlxeWFqalR6?=
 =?utf-8?B?bHVJYW5nM0FEVHJJamY0OWd5eWFiUWtyaitrREZSeE5haWQ2NmRBWDV1ZUpm?=
 =?utf-8?B?b1c4VGJESElTUTdOcjBNQlRYRnBnOHJTTkdnajh6S1hKRzcrVFNycmdVaTF6?=
 =?utf-8?B?T2YyaEVvTk5VcHNkMFZlLzJqK1dNTG53ZUE1Y2ZXTTh0cVpTTVlJNWJwZytW?=
 =?utf-8?B?VTlMUlhxSkxkT0NhRys0R1RUMWVUZzllVFZnRU91akIvTzlWK0xLZW9XRHM2?=
 =?utf-8?B?bytFTUpYK1FlTHdBazJVQ1YzdGw3blhMaUMweCtkWVYrMlF6anF6TWg1RmJm?=
 =?utf-8?B?NVlrbHhqNWk5OElTNFU3MFhyR2phdHI0ZmJvaGl0amlhanpSN0krMVNJK2wz?=
 =?utf-8?B?VFg4MFpsQzQ5WU1QN0NhSzRmVnpHazB5ZUF5R2xzaHFpU1RMc0lOSkFqRVBC?=
 =?utf-8?B?Nms4QzZSYlNwTkhMTEpOWHZxQ2JjZFBma0svcmpYNzBmS0hHTlhPbHZnbGUr?=
 =?utf-8?B?aE41WldVS0FNbDJXU1JWd2xmTUhlYmxFVVJTWDdhNlpXeVpYVnVZYnh2alZr?=
 =?utf-8?B?MUxBQVJBc0tvN2Nid1FHdjhad3AzWGREQUZGTms2azM5K2tMMStIbzhqK3pm?=
 =?utf-8?B?UnphOUcxOTEzdllZS2JMNjNDMVZPV3JRVFdqREttamlFZzEzMEp2YTcvYWpO?=
 =?utf-8?B?OEVhSFpLVlBpZDJIR1k5UnJ3UTlUZHNoSXZmK0pmQmQvWlNQN1N4bG1QMVZp?=
 =?utf-8?B?dzQ2ZVdwYkxBPT0=?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EHmlyMXwR67kMHVrC1wSdxTgYnjvyMW6qsqc3uFnE+Q8WHu4weMib4rRM25nI0a86KegGKulIlnWWdWOEfYHDfnT7hoCE8j1BcMWIPAUQSt7TSB8B5JN5wuRuuW1bcmbK3NJgdZ8BpBYeDBr9IbKOLnmBlMmEyOkXAykFJMvN1nFfXTk4zcb3bJECIG5O0J45a9rBH9yLxTIcRJ1IW222db+jRXUec5mQ4uZBDn/U7subCIAXHCIIQf9ExOjsg+m1bD/qpAvZ7RK4cAsRBb0eyTLfxNUrM+6cv58fq8AGHhys5N6CkP2kDXrj3CQCzj63tWz/IQSqUoUpey3XCfaiQoXViRqBO0JCd7N5IFXCq+EHRLcLwCaglbbqkpVb7RbU8gUKgSwecSAkt6+VFNPSEEemxTW33J4llYwL38y1VR7RireT6Rmn+CRMEZmpFsG3XMSHAIsS45qrAdRhS+ZMVAbPv5x9lsRZZ4IOIkeH5/FQFz6SC3SX2rdzgm1NC89Mex8SHVkPwuaub6UiS6Vpjil4bTyGW5cEhX/H9EoEomUM4PRCAkZAg1inlOP40eDxGkEhy9dMwV0uLoZGpSRqK2MT4A9BiOoe4ljrEtMthjmyrii0QUTnhJI/0ZCf4/IMRvSjWKPxi1s3t5ckuL1ig==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:11.9545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d650d0-e1fb-49dc-657a-08dd2eb1bfee
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB3824
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215166-104149-13342-9666-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmlgZAVgZQ0CjJLNncItHAwC
	Q5ydLcNM0wzczYJMXIOCUxKck42SBJqTYWANiVMFtBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan20-158.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This function is needed by fuse_uring.c to clean ring queues,
so make it non static. Especially in non-static mode the function
name 'end_requests' should be prefixed with fuse_

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 11 +++++------
 fs/fuse/fuse_dev_i.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 27ccae63495d14ea339aa6c8da63d0ac44fc8885..757f2c797d68aa217c0e120f6f16e4a24808ecae 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -34,8 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static void end_requests(struct list_head *head);
-
 static struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -1885,7 +1884,7 @@ static void fuse_resend(struct fuse_conn *fc)
 		spin_unlock(&fiq->lock);
 		list_for_each_entry(req, &to_queue, list)
 			clear_bit(FR_PENDING, &req->flags);
-		end_requests(&to_queue);
+		fuse_dev_end_requests(&to_queue);
 		return;
 	}
 	/* iq and pq requests are both oldest to newest */
@@ -2204,7 +2203,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2307,7 +2306,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2337,7 +2336,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..4fcff2223fa60fbfb844a3f8e1252a523c4c01af
--- /dev/null
+++ b/fs/fuse/fuse_dev_i.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2001-2008  Miklos Szeredi <miklos@szeredi.hu>
+ */
+#ifndef _FS_FUSE_DEV_I_H
+#define _FS_FUSE_DEV_I_H
+
+#include <linux/types.h>
+
+void fuse_dev_end_requests(struct list_head *head);
+
+#endif
+

-- 
2.43.0


