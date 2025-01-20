Return-Path: <io-uring+bounces-6020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A34A16525
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB4603A18A8
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A207D28E3F;
	Mon, 20 Jan 2025 01:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="rDVe6lPB"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC5E29408;
	Mon, 20 Jan 2025 01:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336580; cv=fail; b=fzs8ma0pF+5E0B4xqOMUyfEfYVUG31bhWJZJL4iJPWrYivylXQEFeRlSdHsgDCs3QhSYrPm+MJVFrYOh2bhX3dKF+0OM2tgJGddtLPh0mgMvISLSSSLoiM+R38VKMz839hdf25kyu5poceG96OhN1eFmX6fTX9tzYW0lO87DpeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336580; c=relaxed/simple;
	bh=kvxZ2XTh1mcC5XvtjF/RhKXqggBAhZ3d9JSPoUzZN20=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hfteQ17gldo238TTsI99+Z1NAJv7ZBBwYdznVsLOqp30MUPN1nF39Cj1V8M1Y7ULsaMhCwCKOXANpxUJfkf7w+AcJR7yShVhcP4fw2RlkL3Iq2DxZ+RqB8XzlJvkDOBXKMiRaAfVJyMG1GS0oprCbZaiZ97+K3kjmdQBwUoLzgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=rDVe6lPB; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40]) by mx-outbound8-131.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfpH0zIxJQPZgS0lgtMGymV7Fuh3+AUonE1LNX88SFvTzARuFGUs75N3Ja4Iscn9EQwWAGGyjnxO7+4VTi4pECs4sXNEOK5sooE1xjUuJWrEv/hxpojO7u+hfLsmHKUREzmYs2+PV50GWxKNvyaGmFO4Ibqei8hGfRPAmea8SDdJCWw5HAiYUjX6WfrialhZGaCZDYq0SoR+fwLcwmLLvARAAgNuOKMtAWeO3LTLNME1adLCiTM59duj/SsyOCQvQXT8qdaPYadbhZhaoItFzpAtXj5nsjBLm7ErLZgHc3c0fRfm0OXvwegg3YLQ1kD0+td6MWUlcBzH6bCHxYsIJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDI3GQZ2NuVrZvSSq/m9Dnu0ngsqHn3awlPtUrzI6dY=;
 b=c8Gds4L++m6MTbd8VnBc2w16WBjNUiRyx5U3xDmMjXSJ+tu26RJ/ODj12vTnOF/gnL6eLDlg6srEqZSvWIsinFguZ2oa75Hej7FIYwD2XQ0nM+RomNeJ8TjR9huyeN16utXDmFCgWKtnrDllhaT/LYWQxVhUrMY9MtQ6jPWbFNi14EqoPK+R/Vmu0fSZeNdcc8J1ZWKRioRekv0QSVEJIJQem7KG1EISD8FkxV/qWwq1aoScVojnMirajM/vg9NcdD4fYwso1JWn4GBABqI2wxTGZ3zUxQpyh6WaNdVb07SjnLF7rNUBKYcSoCrN84KxTJD6cjK5LdiTFk02rwc/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDI3GQZ2NuVrZvSSq/m9Dnu0ngsqHn3awlPtUrzI6dY=;
 b=rDVe6lPBACMGQXbxfqwHMFO9a5vZ66dEZoS+SbrVwwb8gwbClBVIkGJLSH9IycUvYRiTBZeo0qgz7uSysKul47l2sUNpxrHsVjT6rGEcKqNCesTdOs4lSJvZVNhfhGtrgo33wcY8FpQ9fBJs9YNitswIC3ud6EEHNAm8RtccEJ8=
Received: from MN2PR18CA0003.namprd18.prod.outlook.com (2603:10b6:208:23c::8)
 by PH8PR19MB6811.namprd19.prod.outlook.com (2603:10b6:510:1be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:18 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::c9) by MN2PR18CA0003.outlook.office365.com
 (2603:10b6:208:23c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:17 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 827B54E;
	Mon, 20 Jan 2025 01:29:16 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:08 +0100
Subject: [PATCH v10 15/17] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-15-ca7c5d1007c0@ddn.com>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=6263;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=kvxZ2XTh1mcC5XvtjF/RhKXqggBAhZ3d9JSPoUzZN20=;
 b=wdFEcwQZyh1xyuXEqktX+nD1NncJnNIiNQGbyxdkfa94bVtfnLs1g89/4C1DcW4BNQYfgbU92
 36ksfxxvheKA/5f5f0jdyAGkFHyUBl8wVtEhDsk5+mUM4P9MtZ0fmvf
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|PH8PR19MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d300f7-062f-4ef6-539d-08dd38f1db6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QktYdTJrYm55Umc4MW4wZmtjbWRaT1F1Zkc5Y09EZmdDWURmQXZFcmJMVTV2?=
 =?utf-8?B?aTRrajdDbXNVSHN5cm8rUEhualhQS0U4Z1FPOFRRMjZETUlRYzhDYWkvU2Jn?=
 =?utf-8?B?cllpbWNPQTJtdFR1MHhmcnRqSmtIcG91dzF0WDJLLzk5dkhMZmNqOXlwRytV?=
 =?utf-8?B?VjIyeDZRK3p3Tmxvd0NtWTdzZUVLQm9jNERNaGg2UWVuRE5RWmRPazVTMFZQ?=
 =?utf-8?B?dHRGa2xtTWVBbG5UQVpWSzJjU0NidGl1alFxU1JKWkFYVHZYR3EvekRHeGI3?=
 =?utf-8?B?Z0tqaWVwU20zRFBEQ1RUNXRwV0U1YVBsdDU3VW5HVE5qeUdtK3pZa3g1Z21Q?=
 =?utf-8?B?VWNjcVY1S1p5dTJ2SnpjaHBpZkRLaGJGN2VuRllaWDEvNVEyczZROGhwdkJh?=
 =?utf-8?B?VW9wYUZqc2RMN1RnSDcyYXY3S25tOU5sR2RZdGhDbU1TWDZuVHRYSEEvQ0tU?=
 =?utf-8?B?UVR6VW1yNkszbmdaOFBQckZCNFhiNktDc2YyeUs2ek5UUTM3a2xQTFcrQkNR?=
 =?utf-8?B?ZmxWSmIyY1dDTVM2bVJpbUZ0cHlZNlVOTkRwQUw0WU5MYXZxaWZteUtZZThv?=
 =?utf-8?B?blFWM04rOXNwT0lNd1pOTkRJcm5OVUNSNzFVZElKR3ltek9pNHhmRzZFNGNN?=
 =?utf-8?B?ZXUySUg0bHVlNUUrQ1hPUXNhR1o2aDB6MEV6NWJRd1lMVVA2c1dyZ1VKa2la?=
 =?utf-8?B?Nk5lV2NpZFVRdXMybVN2N1BzOHlsa2hIM3YxbU5qV2Z1RFpudzRCb0Zia2JU?=
 =?utf-8?B?MUY0Q2RaZ2dkTmxUVkQ2SWZjaml5V0VLblhza2RSejlmQ3NlbVJXakxSTUZx?=
 =?utf-8?B?OHF2anZJM3BuQ3pBbXgvaFQ4K2dBNCt6NTkyZXVoRWFEbjBWdUxUL0JxTTh0?=
 =?utf-8?B?NzdJRmNzRWdGZkgrRlkxSndwcEJOWEQxcGlDRUNYaG1uSkxudkh1dGV5bHUz?=
 =?utf-8?B?KzVoWmtjUDB2c3ZxeTgwa0t2ZFp6N2h3aGdWMkRoVnlVSTE2SjN1Q0V3bTJu?=
 =?utf-8?B?WkhHdUc0TjFFNXFKQnNjcjZjM1liRXY0RHAyRGdJRkpCNVBNYWZPd3loZzdz?=
 =?utf-8?B?RnhndGNuNjNlQUh5WnlURzZGNEpsaXhmSy9OTTU3UWkwbDFSeXVtOTlwNGpB?=
 =?utf-8?B?Q1Faam9TTEtqVTN1cDRtdENUOXRidUloaFV6M0dOWUJCSXBwb2ZLZEVQcWtr?=
 =?utf-8?B?aDRsN21rSHlOblRXRG45amt0MmdTZFh3a3BsaHpoYUdQNW1adHh0Q0lwbzl3?=
 =?utf-8?B?S1l0bVBTeWRZKzIvcERPMW5nSklnS0FOSFgyamhkRlhiYjlGa0g5MkN2S0tE?=
 =?utf-8?B?NC90UVFQNFE4V2w5UExyU2c2ZHdXbm1DLzNSZEd2RjAxeTFWcjZvOVlHVHha?=
 =?utf-8?B?aW1sbGovNDVWdHlHOUo5WHlMUGo2Yzk1QmxXcGU3ck4zMFZOMk00TWUzTlgw?=
 =?utf-8?B?L2pOdXdPSURuM24vR0RDWVdqVFBLNG84UHVkakl5V3d5WGQ1ZHp5cjdqT0NY?=
 =?utf-8?B?aWtNL0dUMyt3b2dwcURiMTVZS2VlS3VXZ1c3WERTeG5WQllmVUd1MkswMVJH?=
 =?utf-8?B?OTVuNlI3ZS8zZFVnSFpsYVY5VnRPS25SOHZlREZPV2FlbzlTc1ZlM2RkTnY1?=
 =?utf-8?B?TDJFeVdpQmlqc053cFpycUxOMXNIRThVcW1WZENXc1grd09mNGFsemdDcjU2?=
 =?utf-8?B?c3FZRkdMUnZSR2ZyNWkwTkRoNDB6cHJlVmRHRk9XQTlnclVLZXJLZnhscXhs?=
 =?utf-8?B?SHJ1SU52N2tMc2tkdGFzeTgxUWRUZkVid1EyMjRpcDJLcmcrVWV2VnlTUDhB?=
 =?utf-8?B?eWJib2RqTzgrdVFYZHlkckhtR2xPWVR4d3Q3R21SMmNKZVgzWUQwejBiTU84?=
 =?utf-8?B?Q28zTEtaOUtSYzJGU2YwMFZoU3lxZnFBRnp1dFI3V3IyVUs2Zi94aERqSlB2?=
 =?utf-8?B?QWl6QlFYQy9XakdVcDZQUHUzUDZZRGtHQzJLUXRpbitzVjdhTWdmSWl2dEZk?=
 =?utf-8?Q?RmgX+K4GXRRfYd4YXxqLzPyy3YUXR8=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VgS2nQSzBc9jYVRDiehtQy9LRZQXNgwc3YWX8QJ04mjQsNSiR4yYs8VGNrG4FiKFTPVpEJrhQsQS6hi5OiTO5fcUZH/opOg5bIMsRyVoosDPygB//2eLXH1KqFITHFCvgXGqiANc1tEU4Oq9sVLLLyQCt2Uvep7vSjaEjiZpLukDLiLRCgufpYLKuz1uK9MiMas3auOP1cjwClchWfh6WNllPjYjDAMpAldj49rZ8T3V1rzoJuzEoqNLqVb88rAqjTwFw2ul0M0meS2Ns2ujBjHk12UKANzurcg/VOTPKP9+2uwzNTgNrB7mBpc/I/iObgL6xIKEq2N161C0/zdFMz22yZ2ZzuEr15PrOmfjnOs/J45efQutVOJz/L6H4pM/53SWhqOkFfmKamQ1T1Qvs/7fUZWTpyPcnZS7Zy+tC32D0NSDAH1Hjzv/BYruCsgWUoLcslO/HtCWgsdJtzZXFk4IS+h985DyuMUP5zve1w45X8PWuMHrcX6NHJT4u2/C7TyaKSvTyp7LCfyKTN0yknWBUFP8OzXWxM8fBUQKQ+vzCO6uSD1BWhHfrCZraFWyNAxVNc6QnrzyYDWl+kngzP+zYzsXjR5xwIjkscnZ9H6VpB0S/XStyhsGMhhRZUea1Rx+Gi7GDvbHJhBQZxazIQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:17.4121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d300f7-062f-4ef6-539d-08dd38f1db6b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6811
X-BESS-ID: 1737336561-102179-13333-11612-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.58.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmYG5sZAVgZQ0DTJIMnEMDnJwi
	LJONk01TDJ1MjMwNgsJdHULDkpychIqTYWABgG18RBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan15-221.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

When the fuse-server terminates while the fuse-client or kernel
still has queued URING_CMDs, these commands retain references
to the struct file used by the fuse connection. This prevents
fuse_dev_release() from being invoked, resulting in a hung mount
point.

This patch addresses the issue by making queued URING_CMDs
cancelable, allowing fuse_dev_release() to proceed as expected
and preventing the mount point from hanging.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
---
 fs/fuse/dev_uring.c   | 70 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/dev_uring_i.h |  9 +++++++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 859e53893eeb5544d57dd961da0e99e7b3d5d9a9..fcce03174ee18153d597e9cd1a2659b1c237e3eb 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -150,6 +150,7 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_ent *ent, *next;
 
 		if (!queue)
 			continue;
@@ -159,6 +160,12 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
 		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		list_for_each_entry_safe(ent, next, &queue->ent_released,
+					 list) {
+			list_del_init(&ent->list);
+			kfree(ent);
+		}
+
 		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
@@ -242,6 +249,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
 	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
+	INIT_LIST_HEAD(&queue->ent_released);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -280,6 +288,7 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
  */
 static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 {
+	struct fuse_ring_queue *queue = ent->queue;
 	if (ent->cmd) {
 		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
 		ent->cmd = NULL;
@@ -288,8 +297,16 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 	if (ent->fuse_req)
 		fuse_uring_stop_fuse_req_end(ent);
 
-	list_del_init(&ent->list);
-	kfree(ent);
+	/*
+	 * The entry must not be freed immediately, due to access of direct
+	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
+	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
+	 * and accesses entries without checking the list state first
+	 */
+	spin_lock(&queue->lock);
+	list_move(&ent->list, &queue->ent_released);
+	ent->state = FRRS_RELEASED;
+	spin_unlock(&queue->lock);
 }
 
 static void fuse_uring_stop_list_entries(struct list_head *head,
@@ -309,6 +326,7 @@ static void fuse_uring_stop_list_entries(struct list_head *head,
 			continue;
 		}
 
+		ent->state = FRRS_TEARDOWN;
 		list_move(&ent->list, &to_teardown);
 	}
 	spin_unlock(&queue->lock);
@@ -423,6 +441,46 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on daemon termination.
+ *
+ * Releasing the last entry should trigger fuse_dev_release() if
+ * the daemon was terminated
+ */
+static void fuse_uring_cancel(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue;
+	bool need_cmd_done = false;
+
+	/*
+	 * direct access on ent - it must not be destructed as long as
+	 * IO_URING_F_CANCEL might come up
+	 */
+	queue = ent->queue;
+	spin_lock(&queue->lock);
+	if (ent->state == FRRS_AVAILABLE) {
+		ent->state = FRRS_USERSPACE;
+		list_move(&ent->list, &queue->ent_in_userspace);
+		need_cmd_done = true;
+		ent->cmd = NULL;
+	}
+	spin_unlock(&queue->lock);
+
+	if (need_cmd_done) {
+		/* no queue lock to avoid lock order issues */
+		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
+	}
+}
+
+static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
+				      struct fuse_ring_ent *ring_ent)
+{
+	uring_cmd_set_ring_ent(cmd, ring_ent);
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -836,6 +894,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	spin_unlock(&queue->lock);
 
 	/* without the queue lock, as other locks are taken */
+	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
 	fuse_uring_commit(ent, issue_flags);
 
 	/*
@@ -885,6 +944,8 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ent,
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
+	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
+
 	spin_lock(&queue->lock);
 	ent->cmd = cmd;
 	fuse_uring_ent_avail(ent, queue);
@@ -1035,6 +1096,11 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 		return -EOPNOTSUPP;
 	}
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags);
+		return 0;
+	}
+
 	/* This extra SQE size holds struct fuse_uring_cmd_req */
 	if (!(issue_flags & IO_URING_F_SQE128))
 		return -EINVAL;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 0182be61778b26a94bda2607289a7b668df6362f..2102b3d0c1aed1105e9c1200c91e1cb497b9a597 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -28,6 +28,12 @@ enum fuse_ring_req_state {
 
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
+
+	/* The ring entry is in teardown */
+	FRRS_TEARDOWN,
+
+	/* The ring entry is released, but not freed yet */
+	FRRS_RELEASED,
 };
 
 /** A fuse ring entry, part of the ring queue */
@@ -79,6 +85,9 @@ struct fuse_ring_queue {
 	/* entries in userspace */
 	struct list_head ent_in_userspace;
 
+	/* entries that are released */
+	struct list_head ent_released;
+
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 

-- 
2.43.0


