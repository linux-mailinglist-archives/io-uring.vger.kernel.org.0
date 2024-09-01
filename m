Return-Path: <io-uring+bounces-3009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D772E96772B
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 17:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DD22281E96
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADED514EC46;
	Sun,  1 Sep 2024 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="P8dv02mC"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046744C97
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725203391; cv=fail; b=s25gDIzjxmVBS/jmq7LcMQzEeaKgHR/EYgZep2Ou+bpuUiWIbsXWdm+dERzllTbXVVwf31CmhK9pDExQQrxQ3cTBY0ryA/3xJpQW43zbIQKD0xptHZFu/fNPW6SDmVR/q7d/we80/msb9oK5AooMVps+Lwv358qNLXhxTYLlQX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725203391; c=relaxed/simple;
	bh=fuliOyC1lcweNpXS+AQqKEdtF9y9TtcVKajjb9Lh/Lw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lnfEn6Zb3uEQLNo7yX8shdzqtcZDCAXbRTShSWRqOUbzm3EmfgP+zD7/YD1atDxuNigaGIHIPvZnz61MZC+Zld6+WpoGBtCu+/hXvLXNwlEvo8Mp/zYca28QlaN8MkhsE9qvZGRe83ia7ysb4mfPjiQswXA7eQyFtmEYps5YiO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=P8dv02mC; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 15:09:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHftSqIRMePAeedB1ucXsNociIyhBgvprkXjQxaOXaqipd48WNmJdMST+7jXbuhFXBqRyU6UD5sFdUMTaymr8wnvqqKrCytXBLE2e0IfseFX34RrG+1/3Q/z2x9d+BVCdVWs16SxF77bvUZuVhV6qd63O7s38wVNNi/FjO3OCHsdNtt1VE+Er5yIzT36xBzNr0W0wua1Wmn6pizFWHETs2tYvdIh3sDiWjuGd48JSSM1FYI5tk8X889Xw6Q+M4eM4GhZaxCcwPdH/+6hjrMhmlwXYwt5Bq6j4OcZfkgHs8+HLP0RJpUxIQ1fonISNECYLhC3TnIcF0Qk27+xIUyVKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LLShqviQXhEKujvXEobFQRhi6pw9v0mOs5fr/Dw9Mk=;
 b=v243etDb45LZvWXJRIQbxwqz2E4NJ4gQoqCWsN0/7O7+K0fLWrj77n19bxIc3KMxo4BtB4zNIBPTbh4lp3IfE+ovzbIO+IPvgdXDIjWDQmUZKG5fWTNR+H69pHjTRH8AOyZXCJDVDtvxsYCBT5PfVmBWl2ejqlbZgcfQWyU+F2hgamyER7K/hv8amK4XpczCjCoY0mbW31kiZJDJQYvg1msswk6FLVFRy3O2cV7aRP91t9o+tW8cvvN/R+uB+vSruVbmQExigG7kpihA0MgOeAqFSqTqSYtZg6tJdKZqEETk57O1IoiU8t8t7z30+Nr/a+os+Xmbbe0WqOvQCjD9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LLShqviQXhEKujvXEobFQRhi6pw9v0mOs5fr/Dw9Mk=;
 b=P8dv02mCnc5FHMmSEy2MQZKPTo21VrcXj2bSodRDtzEBOAO0uYcuQ6glxQ0ttYKEMr7KsoQ7W5zY8q+4Z0aZvfFwi5fagN91ekrSiSEJB/JBZM6wg5CcYj1kRhkQH+b6PqXU9YVhw0jM1jz8M/t1Gs+qn4YzNgEI4qVjy4nVzWE=
Received: from BN0PR04CA0158.namprd04.prod.outlook.com (2603:10b6:408:eb::13)
 by MN2PR19MB3871.namprd19.prod.outlook.com (2603:10b6:208:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:15 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:408:eb:cafe::b1) by BN0PR04CA0158.outlook.office365.com
 (2603:10b6:408:eb::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7962.2
 via Frontend Transport; Sun, 1 Sep 2024 13:37:14 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2DAC8D2;
	Sun,  1 Sep 2024 13:37:14 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:11 +0200
Subject: [PATCH RFC v3 17/17] fuse: {uring} Pin the user buffer
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=14839;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=fuliOyC1lcweNpXS+AQqKEdtF9y9TtcVKajjb9Lh/Lw=;
 b=Q8z+lAIf+jbe9nQjluggxgiC9SytD+gmu9E9HXTwLswknJUjzcZPqgg60/PcYyY8TAjJ3WrBN
 4kFdWBQQrswAv4OuOANc8Tu67WxdGh0bJOu/V9r8HeDYMVBllqtv4fw
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|MN2PR19MB3871:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f49997-62d6-4d33-143b-08dcca8b3101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHoyVHhBQ0lQMzdvTC83NUh0VEZCOUQ2WmFORzdtT05SK1BWamQ3ZnZ4NFFV?=
 =?utf-8?B?aUJIU1BTRm51SmY1SDkydkdsT3Y4dkg1NktnVnYyYUsvZlpmcFRxdGlSZlZQ?=
 =?utf-8?B?cWJrZjJSc0t5K2h0RVpzeTAyT0ZKQ1BabnJDMy9QZXBRZlRZZDZWTi9VcnVJ?=
 =?utf-8?B?MjBXbkpJNjBCVHBGYWp1bG5RRVMzUG5oSVN1OUFJNm9rTFUzaWd0R29XUkFy?=
 =?utf-8?B?RkhDeXZEQkJDUDFLVXhHb0RGS3VIK05hNE9JZjR6QndVSWR5SVR2bEFDU3Ru?=
 =?utf-8?B?WkdQSVl1Q2pyc2R6Zi9SbURBRENlRkxKTE5DRSs3bzNlZ3FON2JmVHpOSmRJ?=
 =?utf-8?B?Y0daRTJYNDVmN2o1QndBeW9DYk8zRmp4QTVTOEJicERMMVRyMFpMYXBiUTZ3?=
 =?utf-8?B?cklRWFBBQVk0WnlmWVlrcnJjZUREeEtKN0dpV2VCeml3THZhWTg2dEk0WS9O?=
 =?utf-8?B?NVNaMjhJb2hIWHdwSStocUdqNTN1WFBRMXlmSmZNcFFFbjBvWkV2RXFJWG1Y?=
 =?utf-8?B?d1FINjh4ZS9HaFVaRC9aTmErbEpXbW4xK2d4YnhGeUhncTR3MFIrR3pWZ1Rv?=
 =?utf-8?B?U3ltWHBUVE90UUJsenFHVWtBdUFldlI2SGg0bHlac0t4U0RjWXJvMnFoZHU0?=
 =?utf-8?B?aEpwQUFSQndXcnVQcExSSExOSGozL3BLcDRUc3ZXTkpmN2FDVGxoTFJ3SXRZ?=
 =?utf-8?B?K3k0ZXc1R3ZVYUpQYTE4aDN1UHczM3Z4bjBXZTY1Tk42UkkvbXR4anE0dG5O?=
 =?utf-8?B?OWpVbDR1UlBxYmtJOTJvUFd4amFzMllCWXR1Qlc0ZWZNVHRRbFhsUHl1WFli?=
 =?utf-8?B?VGRyUkExZDZLOEZBQ1hReSsvZzNONlFsc3d4VWIzYjBnNGh1VitUaTBQVjc1?=
 =?utf-8?B?QUhEc2U2RUNmSHhhU0E2OERmcWNlM09pclZzcUEwajNtRDNVZGgrU0dVQUJ0?=
 =?utf-8?B?TEw5MzdweWxqTlIrZGZjZ1pDUTg2QzRxR2UzWlVRZXR6V25CUmtNaUxaWEJn?=
 =?utf-8?B?a3JpcldGcjR0MGF1YmNMbVhHQnh5RHRlZk1MYjVMd2VuZVRNdjVDMkpIV2M4?=
 =?utf-8?B?TER3ci95WmcvZ09mdjVaK1JSTzlCRzQ3Vlk5ZXZJQm4rbVZMYk9iRW9XTWhy?=
 =?utf-8?B?TkpRYXFBYjZIck1uREZMTFBrVmRDL3AwZU5YZ3FlNHU5K2I0Y2ZwTDNWOGJB?=
 =?utf-8?B?bytPY0ZSTDZrT3FVQzhPYjBkMlNCN0pxeUVFd3MvMExwa29JOW16NlhTb09w?=
 =?utf-8?B?WGU4NjZQQlpUOVBRUUpJNkYvN3J5VEVoZFExVlRyRVFCcW9SNVFVdUN5eDJN?=
 =?utf-8?B?eHAwR0NvRHRDa0kvcXk1aGNZQVBSVUU5V3RDbEtvRWwwTFVEODBrSzZwb0pR?=
 =?utf-8?B?bWFZL2Q3WFpzWURRaXN1eXppVE1Gb29QQnMzWjBkQ0s4L24rKzFseTFzb3U0?=
 =?utf-8?B?eHFWVWRseStFTjM5Vmcra0lhUlJzZFY5Rm9hNHpDMVZiRnRMejB5MG1KVjhi?=
 =?utf-8?B?WVhidUdad0kvaFRhc21jQjFoaFk5TUZDdzFpbVF6aUMvdk5RWjlXZldmTjBs?=
 =?utf-8?B?dElRTUw2UjRYNmpqR1B4VGlDUnZ6eDE3Z2RrSkM2YVlLRkpjV3dYTDZTZUkx?=
 =?utf-8?B?WXE5aTFFcEpVSm81QjV3Y0dGVnVTZjFEWVBmWXlwUTQ2WVN5WnRpbzc5L1dz?=
 =?utf-8?B?YmZNdkVnYXZLVGpsUjFjVnF4WnJSRjgwSkl3TVQ0dFdONmF0dkhPek9NNkcz?=
 =?utf-8?B?RlVQSXBjSWd6YjZMK2RJVzB3a0hyRy9XOUU0Q3BpMm1LendaZFdpd1JIVGNH?=
 =?utf-8?B?ZEx4NnRsbTR3R3ZUTmIyNVhTNlg2R1hMVnpkbDQ5Y010bVNrRGcxSGlGSnk0?=
 =?utf-8?B?ZUQ5ZTU3RGJNckdtYVFCa3hvREliK2NieDR2NSttNnZEbCt2T2s4UEpVQlBR?=
 =?utf-8?Q?C7C5vZhtYExvId77ew5adrUWXXsJJgB1?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+TJICCPMfNBUw9gMaVZal1ZcafMpmEyOSb2vKnUdsL0mmC+0A7GQa/Ds1uVu5xl1bbLGzCUqqnWErVuU4bZ+SZesv4yqZUD7PVmndgtiqaol/8qLCi1QcqV4Uk4c6mW02AsM4LKChjYuIu3bQPloWM5dpfY5PUKD6mAL6ypMWOYY1vyGlZOyUl9+FaIpX+utbPty8Owr0s7u4kKNSGd1DbTG16++GTQaK9i5mhh1wZWfdumDi26rQ5/+nTnnnKJIz/Go7dxbfgx7gWUp3W/Tw543AxQschsIk8b4E9z1FyVVgkC22VF5xUvkUDnkkZc6BpC8188chzgyuUkRvQiuA9C9oPZIFSDrezMPHiziqioW+qqTqN5tJpO1RiLbtw4A9IcCGg/2tA18l/x1/wBY7/fQ6Wr0/IWQjbKvXbun0+RngrRMcau+f7oVGgqex+HENy5OETY5drglVxyEqMEALipRpoV92V0H/lJk5p8yZXEI8MRDU51zgD69d6BCUCmr5ml08pxxWWusVYjk+MYvMvJB3TeAvps4QdSLplNdHZqXhjikT0Ivj7DZiVpre65Hi/Qov0SXTS06nQNC61ec9wlmP9/TudZQZ3ggm9w1s0ziFVKyDLMJhdrE/3PQpmhtSWDme1vTBV2pqiB8x76gYg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:14.9624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f49997-62d6-4d33-143b-08dcca8b3101
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB3871
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725203387-104050-14418-8297-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.70.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmxmYWQGYGUNTc1CQ5zcTCJC
	3J1Mg8NSXJ2MTI1MzSwMDS0iTNwDTNUqk2FgAL0xEmQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258745 [from 
	cloudscan13-175.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This is to allow copying into the buffer from the application
without the need to copy in ring context (and with that,
the need that the ring task is active in kernel space).

Also absolutely needed for now to avoid this teardown issue

 1525.905504] KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
[ 1525.910431] CPU: 15 PID: 183 Comm: kworker/15:1 Tainted: G           O       6.10.0+ #48
[ 1525.916449] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1525.922470] Workqueue: events io_fallback_req_func
[ 1525.925840] RIP: 0010:__lock_acquire+0x74/0x7b80
[ 1525.929010] Code: 89 bc 24 80 00 00 00 0f 85 1c 5f 00 00 83 3d 6e 80 b0 02 00 0f 84 1d 12 00 00 83 3d 65 c7 67 02 00 74 27 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 74 0d e8 50 44 42 00 48 8b bc 24 80 00 00 00 48 c7
[ 1525.942211] RSP: 0018:ffff88810b2af490 EFLAGS: 00010002
[ 1525.945672] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 0000000000000001
[ 1525.950421] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000001a0
[ 1525.955200] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[ 1525.959979] R10: dffffc0000000000 R11: fffffbfff07b1cbe R12: 0000000000000000
[ 1525.964252] R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000001
[ 1525.968225] FS:  0000000000000000(0000) GS:ffff88875b200000(0000) knlGS:0000000000000000
[ 1525.973932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1525.976694] CR2: 00005555b6a381f0 CR3: 000000012f5f1000 CR4: 00000000000006f0
[ 1525.980030] Call Trace:
[ 1525.981371]  <TASK>
[ 1525.982567]  ? __die_body+0x66/0xb0
[ 1525.984376]  ? die_addr+0xc1/0x100
[ 1525.986111]  ? exc_general_protection+0x1c6/0x330
[ 1525.988401]  ? asm_exc_general_protection+0x22/0x30
[ 1525.990864]  ? __lock_acquire+0x74/0x7b80
[ 1525.992901]  ? mark_lock+0x9f/0x360
[ 1525.994635]  ? __lock_acquire+0x1420/0x7b80
[ 1525.996629]  ? attach_entity_load_avg+0x47d/0x550
[ 1525.998765]  ? hlock_conflict+0x5a/0x1f0
[ 1526.000515]  ? __bfs+0x2dc/0x5a0
[ 1526.001993]  lock_acquire+0x1fb/0x3d0
[ 1526.004727]  ? gup_fast_fallback+0x13f/0x1d80
[ 1526.006586]  ? gup_fast_fallback+0x13f/0x1d80
[ 1526.008412]  gup_fast_fallback+0x158/0x1d80
[ 1526.010170]  ? gup_fast_fallback+0x13f/0x1d80
[ 1526.011999]  ? __lock_acquire+0x2b07/0x7b80
[ 1526.013793]  __iov_iter_get_pages_alloc+0x36e/0x980
[ 1526.015876]  ? do_raw_spin_unlock+0x5a/0x8a0
[ 1526.017734]  iov_iter_get_pages2+0x56/0x70
[ 1526.019491]  fuse_copy_fill+0x48e/0x980 [fuse]
[ 1526.021400]  fuse_copy_args+0x174/0x6a0 [fuse]
[ 1526.023199]  fuse_uring_prepare_send+0x319/0x6c0 [fuse]
[ 1526.025178]  fuse_uring_send_req_in_task+0x42/0x100 [fuse]
[ 1526.027163]  io_fallback_req_func+0xb4/0x170
[ 1526.028737]  ? process_scheduled_works+0x75b/0x1160
[ 1526.030445]  process_scheduled_works+0x85c/0x1160
[ 1526.032073]  worker_thread+0x8ba/0xce0
[ 1526.033388]  kthread+0x23e/0x2b0
[ 1526.035404]  ? pr_cont_work_flush+0x290/0x290
[ 1526.036958]  ? kthread_blkcg+0xa0/0xa0
[ 1526.038321]  ret_from_fork+0x30/0x60
[ 1526.039600]  ? kthread_blkcg+0xa0/0xa0
[ 1526.040942]  ret_from_fork_asm+0x11/0x20
[ 1526.042353]  </TASK>

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   9 +++
 fs/fuse/dev_uring.c   | 186 ++++++++++++++++++++++++++++++++------------------
 fs/fuse/dev_uring_i.h |  15 ++--
 fs/fuse/fuse_dev_i.h  |   2 +
 4 files changed, 143 insertions(+), 69 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9f0f2120b1fa..492bb95fde4e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -769,6 +769,15 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 			cs->pipebufs++;
 			cs->nr_segs++;
 		}
+	} else if (cs->is_uring) {
+		cs->pg = cs->ring.pages[cs->ring.page_idx++];
+		/*
+		 * non stricly needed, just to avoid a uring exception in
+		 * fuse_copy_finish
+		 */
+		get_page(cs->pg);
+		cs->len = PAGE_SIZE;
+		cs->offset = 0;
 	} else {
 		size_t off;
 		err = iov_iter_get_pages2(cs->iter, &page, PAGE_SIZE, 1, &off);
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index a65c5d08fce1..4cc0facaaae3 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -29,6 +29,9 @@
 #include <linux/topology.h>
 #include <linux/io_uring/cmd.h>
 
+#define FUSE_RING_HEADER_PG 0
+#define FUSE_RING_PAYLOAD_PG 1
+
 struct fuse_uring_cmd_pdu {
 	struct fuse_ring_ent *ring_ent;
 };
@@ -250,6 +253,21 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
 	fuse_request_end(req);
 }
 
+/*
+ * Copy from memmap.c, should be exported
+ */
+static void io_pages_free(struct page ***pages, int npages)
+{
+	struct page **page_array = *pages;
+
+	if (!page_array)
+		return;
+
+	unpin_user_pages(page_array, npages);
+	kvfree(page_array);
+	*pages = NULL;
+}
+
 /*
  * Release a request/entry on connection tear down
  */
@@ -275,6 +293,8 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
 	if (ent->fuse_req)
 		fuse_uring_stop_fuse_req_end(ent);
 
+	io_pages_free(&ent->user_pages, ent->nr_user_pages);
+
 	ent->state = FRRS_FREED;
 }
 
@@ -417,6 +437,7 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 		goto seterr;
 	}
 
+	/* FIXME copied from dev.c, check what 512 means  */
 	if (oh->error <= -512 || oh->error > 0) {
 		err = -EINVAL;
 		goto seterr;
@@ -465,53 +486,41 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 
 static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 				     struct fuse_req *req,
-				     struct fuse_ring_ent *ent)
+				     struct fuse_ring_ent *ent,
+				     struct fuse_ring_req *rreq)
 {
-	struct fuse_ring_req __user *rreq = ent->rreq;
 	struct fuse_copy_state cs;
 	struct fuse_args *args = req->args;
 	struct iov_iter iter;
-	int err;
-	int res_arg_len;
+	int res_arg_len, err;
 
-	err = copy_from_user(&res_arg_len, &rreq->in_out_arg_len,
-			     sizeof(res_arg_len));
-	if (err)
-		return err;
-
-	err = import_ubuf(ITER_SOURCE, (void __user *)&rreq->in_out_arg,
-			  ent->max_arg_len, &iter);
-	if (err)
-		return err;
+	res_arg_len = rreq->in_out_arg_len;
 
 	fuse_copy_init(&cs, 0, &iter);
 	cs.is_uring = 1;
+	cs.ring.pages = &ent->user_pages[FUSE_RING_PAYLOAD_PG];
 	cs.req = req;
 
-	return fuse_copy_out_args(&cs, args, res_arg_len);
+	err = fuse_copy_out_args(&cs, args, res_arg_len);
+
+	return err;
 }
 
- /*
-  * Copy data from the req to the ring buffer
-  */
+/*
+ * Copy data from the req to the ring buffer
+ */
 static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
-				   struct fuse_ring_ent *ent)
+				   struct fuse_ring_ent *ent,
+				   struct fuse_ring_req *rreq)
 {
-	struct fuse_ring_req __user *rreq = ent->rreq;
 	struct fuse_copy_state cs;
 	struct fuse_args *args = req->args;
-	int err, res;
+	int err;
 	struct iov_iter iter;
 
-	err = import_ubuf(ITER_DEST, (void __user *)&rreq->in_out_arg,
-			  ent->max_arg_len, &iter);
-	if (err) {
-		pr_info("Import user buffer failed\n");
-		return err;
-	}
-
 	fuse_copy_init(&cs, 1, &iter);
 	cs.is_uring = 1;
+	cs.ring.pages = &ent->user_pages[FUSE_RING_PAYLOAD_PG];
 	cs.req = req;
 	err = fuse_copy_args(&cs, args->in_numargs, args->in_pages,
 			     (struct fuse_arg *)args->in_args, 0);
@@ -520,10 +529,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		return err;
 	}
 
-	BUILD_BUG_ON((sizeof(rreq->in_out_arg_len) != sizeof(cs.ring.offset)));
-	res = copy_to_user(&rreq->in_out_arg_len, &cs.ring.offset,
-			   sizeof(rreq->in_out_arg_len));
-	err = res > 0 ? -EFAULT : res;
+	rreq->in_out_arg_len = cs.ring.offset;
 
 	return err;
 }
@@ -531,11 +537,11 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 static int
 fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
 {
-	struct fuse_ring_req *rreq = ring_ent->rreq;
+	struct fuse_ring_req *rreq = NULL;
 	struct fuse_ring_queue *queue = ring_ent->queue;
 	struct fuse_ring *ring = queue->ring;
 	struct fuse_req *req = ring_ent->fuse_req;
-	int err = 0, res;
+	int err = 0;
 
 	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
 		pr_err("qid=%d tag=%d ring-req=%p buf_req=%p invalid state %d on send\n",
@@ -551,25 +557,27 @@ fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
 		 __func__, queue->qid, ring_ent->tag, ring_ent->state,
 		 req->in.h.opcode, req->in.h.unique);
 
+	rreq = kmap_local_page(ring_ent->user_pages[FUSE_RING_HEADER_PG]);
+
 	/* copy the request */
-	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent, rreq);
 	if (unlikely(err)) {
 		pr_info("Copy to ring failed: %d\n", err);
 		goto err;
 	}
 
 	/* copy fuse_in_header */
-	res = copy_to_user(&rreq->in, &req->in.h, sizeof(rreq->in));
-	err = res > 0 ? -EFAULT : res;
-	if (err)
-		goto err;
+	rreq->in = req->in.h;
 
+	err = 0;
 	set_bit(FR_SENT, &req->flags);
-	return 0;
-
+out:
+	if (rreq)
+		kunmap_local(rreq);
+	return err;
 err:
 	fuse_uring_req_end(ring_ent, true, err);
-	return err;
+	goto out;
 }
 
 /*
@@ -682,16 +690,13 @@ static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
 {
 	struct fuse_ring *ring = ring_ent->queue->ring;
 	struct fuse_conn *fc = ring->fc;
-	struct fuse_ring_req *rreq = ring_ent->rreq;
+	struct fuse_ring_req *rreq;
 	struct fuse_req *req = ring_ent->fuse_req;
 	ssize_t err = 0;
 	bool set_err = false;
 
-	err = copy_from_user(&req->out.h, &rreq->out, sizeof(req->out.h));
-	if (err) {
-		req->out.h.error = err;
-		goto out;
-	}
+	rreq = kmap_local_page(ring_ent->user_pages[FUSE_RING_HEADER_PG]);
+	req->out.h = rreq->out;
 
 	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
 	if (err) {
@@ -701,7 +706,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
 		goto out;
 	}
 
-	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent, rreq);
+	kunmap_local(rreq);
 	if (err)
 		set_err = true;
 
@@ -830,6 +836,46 @@ __must_hold(ring_ent->queue->lock)
 	return 0;
 }
 
+/*
+ * Copy from memmap.c, should be exported there
+ */
+static struct page **io_pin_pages(unsigned long uaddr, unsigned long len,
+				  int *npages)
+{
+	unsigned long start, end, nr_pages;
+	struct page **pages;
+	int ret;
+
+	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = uaddr >> PAGE_SHIFT;
+	nr_pages = end - start;
+	if (WARN_ON_ONCE(!nr_pages))
+		return ERR_PTR(-EINVAL);
+
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+					pages);
+	/* success, mapped all pages */
+	if (ret == nr_pages) {
+		*npages = nr_pages;
+		return pages;
+	}
+
+	/* partial map, or didn't map anything */
+	if (ret >= 0) {
+		/* if we did partial map, release any pages we did get */
+		if (ret)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
+	}
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
+
 /* FUSE_URING_REQ_FETCH handler */
 static int fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 			    struct io_uring_cmd *cmd, unsigned int issue_flags)
@@ -837,39 +883,48 @@ static int fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 {
 	struct fuse_ring *ring = ring_ent->queue->ring;
 	struct fuse_ring_queue *queue = ring_ent->queue;
-	int ret;
+	int err;
 
 	/* No other bit must be set here */
-	ret = -EINVAL;
+	err = -EINVAL;
 	if (ring_ent->state != FRRS_INIT)
-		goto err;
+		goto err_unlock;
 
 	/*
 	 * FUSE_URING_REQ_FETCH is an initialization exception, needs
 	 * state override
 	 */
 	ring_ent->state = FRRS_USERSPACE;
-	ret = fuse_ring_ring_ent_unset_userspace(ring_ent);
-	if (ret != 0) {
-		pr_info_ratelimited(
-			"qid=%d tag=%d register req state %d expected %d",
-			queue->qid, ring_ent->tag, ring_ent->state,
-			FRRS_INIT);
+	fuse_ring_ring_ent_unset_userspace(ring_ent);
+
+	err = _fuse_uring_fetch(ring_ent, cmd, issue_flags);
+	if (err)
+		goto err_unlock;
+
+	spin_unlock(&queue->lock);
+
+	/* must not hold the queue->lock */
+	ring_ent->user_pages = io_pin_pages(ring_ent->user_buf,
+					    ring_ent->user_buf_len,
+					    &ring_ent->nr_user_pages);
+	if (IS_ERR(ring_ent->user_pages)) {
+		err = PTR_ERR(ring_ent->user_pages);
+		pr_info("qid=%d ent=%d pin-res=%d\n",
+			queue->qid, ring_ent->tag, err);
 		goto err;
 	}
 
-	ret = _fuse_uring_fetch(ring_ent, cmd, issue_flags);
-	if (ret)
-		goto err;
-
 	/*
 	 * The ring entry is registered now and needs to be handled
 	 * for shutdown.
 	 */
 	atomic_inc(&ring->queue_refs);
-err:
+	return 0;
+
+err_unlock:
 	spin_unlock(&queue->lock);
-	return ret;
+err:
+	return err;
 }
 
 /**
@@ -920,7 +975,9 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (unlikely(fc->aborted || queue->stopped))
 		goto err_unlock;
 
-	ring_ent->rreq = (void __user *)cmd_req->buf_ptr;
+	ring_ent->user_buf = cmd_req->buf_ptr;
+	ring_ent->user_buf_len = cmd_req->buf_len;
+
 	ring_ent->max_arg_len = cmd_req->buf_len -
 				offsetof(struct fuse_ring_req, in_out_arg);
 	ret = -EINVAL;
@@ -930,7 +987,6 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		goto err_unlock;
 	}
 
-	ring_ent->rreq = (void __user *)cmd_req->buf_ptr;
 	ring_ent->max_arg_len = cmd_req->buf_len -
 				offsetof(struct fuse_ring_req, in_out_arg);
 	if (cmd_req->buf_len < ring->req_buf_sz) {
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index f1247ee57dc4..2e43b2e9bcf2 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -60,10 +60,17 @@ struct fuse_ring_ent {
 	/* fuse_req assigned to the ring entry */
 	struct fuse_req *fuse_req;
 
-	/*
-	 * buffer provided by fuse server
-	 */
-	struct fuse_ring_req __user *rreq;
+	/* buffer provided by fuse server */
+	unsigned long __user user_buf;
+
+	/* length of user_buf */
+	size_t user_buf_len;
+
+	/* mapped user_buf pages */
+	struct page **user_pages;
+
+	/* number of user pages */
+	int nr_user_pages;
 
 	/* struct fuse_ring_req::in_out_arg size*/
 	size_t max_arg_len;
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 0fbb4f28261c..63e0e5dcb9f4 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -32,6 +32,8 @@ struct fuse_copy_state {
 	struct {
 		/* overall offset with the user buffer */
 		unsigned int offset;
+		struct page **pages;
+		int page_idx;
 	} ring;
 };
 

-- 
2.43.0


