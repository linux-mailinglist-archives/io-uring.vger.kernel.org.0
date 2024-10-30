Return-Path: <io-uring+bounces-4172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1FF9B588F
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AAF1282E68
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCC1DDCD;
	Wed, 30 Oct 2024 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GJvFK1FR"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157D17BA3;
	Wed, 30 Oct 2024 00:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730247883; cv=fail; b=q33Nhu8FDz+WBBfVbRxxH13gq+W61w2qmmiSJQI3oHGPl5FfgszzvOd/bnMS/QQG+apzf0stzgYKTKPV7NSxFaeh5DL0MoS6o/lhJPCeE84Giijw9Pwhvb3gSI1ib+skzPfKJo15IaEKIFNcchQ4X3jHt/KHFLVbjkF39xL1y4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730247883; c=relaxed/simple;
	bh=zmK1CmROcRjiR8++MIO1Ow8CqzfZkbG+GirwJDVxCSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CHonUmtQiADM4ON8tcKjkUqcCJ/p8qEzL6KJvPek020Ip4jEh9slbuyD2UnmtNPXi3dGqOUq/6B4NT6GF84g18GfL76VS4DceareRDHQPFkt5EaciWaSwtkPf1TUo6G6VVB8I8Tta12nyED2XxqkQvt8WGlRgyi7SmobkNeXMHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GJvFK1FR; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bdTsuOIZCYZCZGiXbeZtYKKYvlvLTCtnJh0I9R1b62IhZs9/3ANSex/It9RH8BofV6XxHZq6+8NrgOMaitwaU2a51GYNfue9tGdngQ7BSM41Pd7sb+nOjI+4ViSgTsPMwvZT/pmrgqje2jWfiFhrPZSUmgr1wzLnRwCK3mWIQEdTgGq9eDflz+g38/9sPwI34kGCjjI+v0KjdoBOyHCwZ5xlP05vzA4EBK9KQl0fYIaGk0OM9IjjXMuFJBOnpS+iUScB3yg6MBpq3aNTC8u2eMDayWaC5VLcQ4GAj0DTC6oOHP5NUKp7EEzMlEvlDENS9BUeNv4m/WUGc+vSXYITsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmK1CmROcRjiR8++MIO1Ow8CqzfZkbG+GirwJDVxCSQ=;
 b=PU+6XsT8Oo4v2USRZ1YBBsIFzesTxL8H1OanmVv4YzP77Lx4uz7nTdb8rhOFpeguPRk3s2ymN7ppQ3yKmUjfdG14/UYBISrv+TRzn+k0ryPpxv43mgpShA8j24c7mAlxWUqxksIIviU55MRtAKTReogP5zziuDXEB5fuQNsnAgc2+Dt3Py9nChYIYhfDS1Qx3H5kvk7XFjaIchRD8tVEjhc491pJJP99lT0iYOrRZsm8z59hCuDoHlvi16ZqIml0DG0cahNOv4qdxJIngy70nj497cOONvxPr8lakp2k/8NxGMPM4F1eNBbVZ4MqYyavvJbjTwMp9rzSN32Li8tRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmK1CmROcRjiR8++MIO1Ow8CqzfZkbG+GirwJDVxCSQ=;
 b=GJvFK1FRI/MiUfRQfhdRRpaeTmepN0XwqdUnCesPk8G/Ya7+IGUaKW4Kkmz1cw/4/Vtlr3UYFunnmo+XeCQpRrjnsznqXL8V2vQ2LauAhmqKj8N8zpPmZDF2GHzBkAQvpk7jqGXWDUFMDNmCLa4lESS5zIrSL9mf1qnOzeW6Q5LvafF7KeKN0Ra6WWoPw2SquBs/cmn52obPNT9eR9zkhC6MoP7OYwMDjdWyWhrWptWFWEg3EWvkQC3bGEuYef3JVW+4IkqSnh2rowd0AYO8G52yaTIN39IOvrrbJh/rDSpeX1sVvA7wdkRwa8o1Zzvm8tQB/GQ5BEX5VbDvwmppSQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB6327.namprd12.prod.outlook.com (2603:10b6:8:a2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.32; Wed, 30 Oct 2024 00:24:37 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 00:24:36 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Keith Busch <kbusch@meta.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, Hannes Reinecke <hare@suse.de>, Keith
 Busch <kbusch@kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: [PATCHv10 8/9] nvme: enable FDP support
Thread-Topic: [PATCHv10 8/9] nvme: enable FDP support
Thread-Index: AQHbKhnFqFw09mz6l0G3oMvQ9Qhj9LKeb/8A
Date: Wed, 30 Oct 2024 00:24:36 +0000
Message-ID: <33648c19-d527-4085-a2d7-3444db9664d0@nvidia.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-9-kbusch@meta.com>
In-Reply-To: <20241029151922.459139-9-kbusch@meta.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB6327:EE_
x-ms-office365-filtering-correlation-id: c5349eb1-9648-495e-1152-08dcf8793c7a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?alhVWUwvVFIxL1FLS2pmdDVHSkM2U3AzRlpSMWM1YnpZbENHOGRKRVZtV0g5?=
 =?utf-8?B?c0xDNHZFbDdGQmRnUk4rVzJocGthYWZzMUNTSGRsaldvWjMwbzBJRW9oaldD?=
 =?utf-8?B?ZDdmU3ExeXBWdFdQVmwwajFGWVgwY3RmODZqWndRS2Y4UVRQNHV3UDFjSm9w?=
 =?utf-8?B?cXRaZWlRdmJBVmliMlhtMFYyNjNpRm5KdVpXbEtkQVFsL3ZvNHRXQnM5T05q?=
 =?utf-8?B?cXYyN0l0UTRNVTgxWXpEWTdERnR3OElLOUpqa2hNYU5ZNWludjN3OWt5U3hm?=
 =?utf-8?B?RkNjb2EzL2k4ekVFMGVydnhIOEJGVkhBTFhTTXBkaDBPY2R3Q2c4RjIwYzRY?=
 =?utf-8?B?d3hvSE95UXNpbE8yN0RQUWtUQTJzc1NhaThESC8yb2VoTm1pNFJnL09jc2FH?=
 =?utf-8?B?eUpRSHdHWGpNdm5UM2dHYkRnNS8xK3l6aGk4clpGSUlBVmJQZmtSbWtiVE0v?=
 =?utf-8?B?NkFkNGdKbnhWUmFzNEc2aGRTQWo1NGx3S1RCVDhFcCszKzRSUTczWFhwY3V1?=
 =?utf-8?B?UGpRN213SmlKNmpyV3Nac3hSakQ2czhFMU5iSGxwejhXWDFTUkh2VlFkVGV3?=
 =?utf-8?B?LzdCMDVtcFZzUmd1cVRFMW1CQmFiUEFST1JFL09CNzBaRng4dXZQL05hT2NR?=
 =?utf-8?B?T3ViVE1XWmdzc3ZmRHVJV2JXZ3RnY3FkYWlXSnhZZlVWdTR0eFdtMUNiTHF5?=
 =?utf-8?B?QVhYdmVTc0s3dnM5NDRVSXBTVGRrRzFFYkVmVUgzU3h3RU5vWWxuUS9OdVJo?=
 =?utf-8?B?OHk4a1d3TDRKVDlmeW9yMUpFSldqL0lteEQ3Y0RBY0JTSzVDOEx5dXZJdXB5?=
 =?utf-8?B?Q3FOdnZQVFFOeThTNjBoRFZWRUxITFZ4YmNWUTRlVmlZQjY0REVlc3hiMzMz?=
 =?utf-8?B?MGQ2M0dES1BSZDYrUFc2NDRNcFdmWDcrWGpDeFVGUUgwVGxDb3NyY2tndTJ2?=
 =?utf-8?B?RXZYRHA1aXNGQWZJcUxNNVdVK3ZyZ3VOZW5FMXNHc25oVlJISHVCbnlEQUMw?=
 =?utf-8?B?OUZhWW9nMFpkZ2hQYnBEbVJyekdXQzdJZkhKc1luTzdWVkZxekFxNlRlY1Yy?=
 =?utf-8?B?SDBOU3Y3WkVNOWVwcUhOazFKVjVUdmlpUnBqWExXZ1R1c09MNkNrL1R6ZFBq?=
 =?utf-8?B?a2laWU40eDV1NTdpQkY4YVp2UG5TRnZjblgwazhxaGJCTHd4Uktnd1pFWlp6?=
 =?utf-8?B?bExvaFNWSzYxN1lieTdMWmhWb1VWMUFObm45S1hZSUlxQ0w0alNGSTMvOEVz?=
 =?utf-8?B?ZXk2N2VCdUhPcjFGcmNqcTdaSFZKMndMVTIxL1hScmpPWHB3ZWsrU0ZKbGFn?=
 =?utf-8?B?RlpqOEhTVXJjLy9pbkw4a2xHUkJEQ3F3U2k2d0pXRHFqY1YzeFFrK1FPVDI2?=
 =?utf-8?B?ZmR1MVMwRFZ1elYzVllMSHBGYU15cytEOXVMSVlncGIvN3M2WTJnazFLM0Fm?=
 =?utf-8?B?V2ZDSnkzeDJBd0poY3IxeXlQVXR5WVBHVERjME9tWUdWNW1OTURtZ2NvUHNR?=
 =?utf-8?B?RTVRVDNDb01IaGpKS1c2ZEVNamxWS0E5dGFlemd4V2wxRlZVeW41a00wdmp2?=
 =?utf-8?B?MElubkswL1RTSzdIUm12ZjU4NEdOQ2laWkljNVRPUXhsd3lrSWVyNEZ2YSt5?=
 =?utf-8?B?TUhLQ0ZxU05MV1Q5OUhDMC9uV09WZDhscFRuMVFPWVFiSmswbFBITGFHRzhU?=
 =?utf-8?B?YUZqMWNVQ3l4Z0JnaUhrUVhhL29Nd3JtdWwyUE1ZemN1WGlVeDlUYjVFZ3lx?=
 =?utf-8?B?VVJ3UW5MUnk4R1ZtdnQ4cnR2QVptTE1VTXV1bllObkpYT04zSlhOUmVGNExi?=
 =?utf-8?Q?T9GLA76+Gz2Kw+yVghyKCatrOeiSUiy60cHms=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TXNwTVVjZlhINXVkcHl3eGpFR0ZSQTQ2aXM1dUtJME8vbW1rbXR6Z0JhTitN?=
 =?utf-8?B?Y1Z4cEd3REhRVVlVS1k3VjdadnBhQUh2dE42NkFRV2doWmx0RTYrZmZvQ01V?=
 =?utf-8?B?T1JDR09yV3BQVG5YZnI5SzdFVE51NC96UU82NjMvdGswQ1VOSWMzdlVjaDVC?=
 =?utf-8?B?MkNxUWdjenROVDRTa0lkeFhUTkpWeThtY0F2YVp6M2VqMU9UdDQvZlUvWThW?=
 =?utf-8?B?VzNzZytSSitCL1hYSHRBNU91NkRTbkpTcDJTbEdKMkt4T2hOMzd5VkN4NW5P?=
 =?utf-8?B?S3R2aFMwYzBFUzh1SnpuNmNnSXVGSWEyR2RpeEdHdE8rMTJEK1FralVZMXZt?=
 =?utf-8?B?Sk1UazlKbFcvNDI4SnFrTGhYbXdXV3ZQajRTNDNDR0hsMGRvSnV1S0ZMOWFD?=
 =?utf-8?B?ZzRpS3RDWEJGWmRvWWNXcEJIblF6Rzl2Tm83RjU3d3R0aFFDSG9MWUlWSjIv?=
 =?utf-8?B?Y3lXZWF3dzF5WDlnRFhQQmhkcnZhMUtIcFp6UVhFV2ZRVXZYdWtZY3AyWWlQ?=
 =?utf-8?B?ZmdQT0hyeG0vUmRNRGd6WHFQYjA4NVJ6Y0Y1MmJxbGNoNG03ZS81WGhVdTFH?=
 =?utf-8?B?NWt2OHM4a1ZZUWhTVVNQR0ZPOTZ1VVlsYjlWMnFJbTN0ekNqUERJOVBoZWZQ?=
 =?utf-8?B?dVQ1L3Jqd3hIbGdGalVYaVhrWXZQNUVXMXg5RE9jeDJxbitzQ1krSmFLVUg2?=
 =?utf-8?B?M1k4ekU3SnJTU2FWUU5wMHJiWjhKbFhjSEtaWndsWlRCL2YybGR5d3R6R0px?=
 =?utf-8?B?KzVEYUNSK0RrVE9KSFp2bDdBb2s4MEppQ2ZnMXhGSXJ4NDFTb0hjRVh4R0w1?=
 =?utf-8?B?UlVuWXFIcURSNTdtRnFUdkRaWjJlcFdhaFpCTW10dkRQM21hUGY3akZXNnlT?=
 =?utf-8?B?OGdjNjdYOXZsTHRFRXFnQndpbGJwTGVoSVpMUk02NE1MUDFEdURWYUhlSUxt?=
 =?utf-8?B?Mk44ZFB1Mmt3aGlMa3FvWWR3NGNhYno1SERvTnAyaFlSS1h0SVVmNW9HZC9C?=
 =?utf-8?B?dWZvODgyazgzN0Q5KzJnQThpSENERDJOQlNLMHRyMDN5SDdTNkhJcTJpTVY4?=
 =?utf-8?B?Q2VNMmFqREJIczNldEV5UTdxQ1ErRFZZKy9CU1dwek42V09DaFBJTVFyTjc4?=
 =?utf-8?B?ckJmTTBRdm5jZCtEb3RVMXRnRFBMUjBhRWJMczRPd2xHVFMzQUFnUTlzOTc0?=
 =?utf-8?B?YUxOTEEzMUxlOVdON1c1MXJCbWtFUTZ4V2ExNlpvbkdDK0wwUjQwMTJGWTFR?=
 =?utf-8?B?L21mK0JjWkd3emtNOTl0MzM4Zm5MZk5JTnZlS1FVaHVJUlZKM3ZIYkRtdWh2?=
 =?utf-8?B?ZU9DT2N4bUE3MnFCUGRwd1djU1FxTzdhU3kvUm1HNDhLYjF6d3hZSDM4N3BT?=
 =?utf-8?B?YUhiOU5iekkrckdXenV5QmpkTnBpczdHamRocW42Q2JwUGhzY05IVHFPYzhp?=
 =?utf-8?B?RWlBSVpwZnlrZldNUkp3S1RGcWlXekpkRmJvY3p0RE91RDRkNDFUd0FCQ1kr?=
 =?utf-8?B?cSs1TnU4eTJsOHFtQXVYaUlXZGhPVng4R3NteVU5a29EQ0NNbitXQlJjWS8z?=
 =?utf-8?B?WXVzNk5OcnFWR2Z3MWYxdlMyVmgxakxlb3BaSVZGNjRXaiswWExaZlNWYU1R?=
 =?utf-8?B?cHp1VVBGc29meUduRkExTlpEVkZESXlMODErbHg0LzdMQWx2YTByN1dBS3hm?=
 =?utf-8?B?eU5DN0s5ckFJSW8xcnFJMGtPVFRTNDFpRDFiR3h4SldkeE5nWml6ODJybnNL?=
 =?utf-8?B?aWp0cmYwUHJlOTNIYjZYSUpyeTZFZERxWHJFbjFDSHhpMmN1WUpqeGw5SUxj?=
 =?utf-8?B?L1ZyeEZGbWQrSFBpZGVUdHJFbXVLcENvU3ZVeWRpS3l5WDdXTUwxb1VzMWNz?=
 =?utf-8?B?UlM1c3VRZi93NTdnWDNpSUtiZmRMV1lMR2thZzcwMmRpREdsVzl6cWMwS2hn?=
 =?utf-8?B?SFVYQ3dmWU5IT3Q5ODJ0TThoR1ZSTGdhTG5CRzVib2FrS2dlREFZVnRzci9P?=
 =?utf-8?B?NmFCT3JjcEIwdUJSWXg0NEVzSVhDcXM3elY1NTY3QXFnM3VSci80cWFmd05S?=
 =?utf-8?B?SW1tcEdGUVorYlRKdzFRWHRBZWNUbzltaXgxbXdvS1JxOS9KS2hUNTFCOG1a?=
 =?utf-8?Q?YPecwU7fBku7Wr68I7reKnjnL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE383CDE6653B7459365EB3A998F1771@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5349eb1-9648-495e-1152-08dcf8793c7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2024 00:24:36.9103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXupEno1kV6XJYdWGouR9JKrt/c7CxzIFsX65Jy4ufTPjzhVdazqjTssmoki3sYERvb/mHXyTJcQDT2SG4Yk4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6327

T24gMTAvMjkvMjQgMDg6MTksIEtlaXRoIEJ1c2NoIHdyb3RlOg0KPiBGcm9tOiBLYW5jaGFuIEpv
c2hpIDxqb3NoaS5rQHNhbXN1bmcuY29tPg0KPg0KPiBGbGV4aWJsZSBEYXRhIFBsYWNlbWVudCAo
RkRQKSwgYXMgcmF0aWZpZWQgaW4gVFAgNDE0NmEsIGFsbG93cyB0aGUgaG9zdA0KPiB0byBjb250
cm9sIHRoZSBwbGFjZW1lbnQgb2YgbG9naWNhbCBibG9ja3Mgc28gYXMgdG8gcmVkdWNlIHRoZSBT
U0QgV0FGLg0KPiBVc2Vyc3BhY2UgY2FuIHNlbmQgdGhlIHdyaXRlIGhpbnQgaW5mb3JtYXRpb24g
dXNpbmcgaW9fdXJpbmcgb3IgZmNudGwuDQo+DQo+IEZldGNoIHRoZSBwbGFjZW1lbnQtaWRlbnRp
ZmllcnMgaWYgdGhlIGRldmljZSBzdXBwb3J0cyBGRFAuIFRoZSBpbmNvbWluZw0KPiB3cml0ZS1o
aW50IGlzIG1hcHBlZCB0byBhIHBsYWNlbWVudC1pZGVudGlmaWVyLCB3aGljaCBpbiB0dXJuIGlz
IHNldCBpbg0KPiB0aGUgRFNQRUMgZmllbGQgb2YgdGhlIHdyaXRlIGNvbW1hbmQuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IEthbmNoYW4gSm9zaGkgPGpvc2hpLmtAc2Ftc3VuZy5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IEh1aSBRaSA8aHVpODEucWlAc2Ftc3VuZy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IE5pdGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBzYW1zdW5nLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEhh
bm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBLZWl0aCBCdXNj
aCA8a2J1c2NoQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUu
YyB8IDg0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gICBkcml2
ZXJzL252bWUvaG9zdC9udm1lLmggfCAgNSArKysNCj4gICBpbmNsdWRlL2xpbnV4L252bWUuaCAg
ICAgfCAxOSArKysrKysrKysNCj4gICAzIGZpbGVzIGNoYW5nZWQsIDEwOCBpbnNlcnRpb25zKCsp
DQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMgYi9kcml2ZXJzL252
bWUvaG9zdC9jb3JlLmMNCj4gaW5kZXggM2RlNzU1NWE3ZGU3NC4uYmQ3Yjg5OTEyZGRiOSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvbnZt
ZS9ob3N0L2NvcmUuYw0KPiBAQCAtNDQsNiArNDQsMjAgQEAgc3RydWN0IG52bWVfbnNfaW5mbyB7
DQo+ICAgCWJvb2wgaXNfcmVtb3ZlZDsNCj4gICB9Ow0KPiAgIA0KPiArc3RydWN0IG52bWVfZmRw
X3J1aF9zdGF0dXNfZGVzYyB7DQo+ICsJdTE2IHBpZDsNCj4gKwl1MTYgcnVoaWQ7DQo+ICsJdTMy
IGVhcnV0cjsNCj4gKwl1NjQgcnVhbXc7DQo+ICsJdTggIHJzdmQxNlsxNl07DQo+ICt9Ow0KPiAr
DQo+ICtzdHJ1Y3QgbnZtZV9mZHBfcnVoX3N0YXR1cyB7DQo+ICsJdTggIHJzdmQwWzE0XTsNCj4g
KwlfX2xlMTYgbnJ1aHNkOw0KPiArCXN0cnVjdCBudm1lX2ZkcF9ydWhfc3RhdHVzX2Rlc2MgcnVo
c2RbXTsNCj4gK307DQo+ICsNCj4gICB1bnNpZ25lZCBpbnQgYWRtaW5fdGltZW91dCA9IDYwOw0K
PiAgIG1vZHVsZV9wYXJhbShhZG1pbl90aW1lb3V0LCB1aW50LCAwNjQ0KTsNCj4gICBNT0RVTEVf
UEFSTV9ERVNDKGFkbWluX3RpbWVvdXQsICJ0aW1lb3V0IGluIHNlY29uZHMgZm9yIGFkbWluIGNv
bW1hbmRzIik7DQo+IEBAIC02NTcsNiArNjcxLDcgQEAgc3RhdGljIHZvaWQgbnZtZV9mcmVlX25z
X2hlYWQoc3RydWN0IGtyZWYgKnJlZikNCj4gICAJaWRhX2ZyZWUoJmhlYWQtPnN1YnN5cy0+bnNf
aWRhLCBoZWFkLT5pbnN0YW5jZSk7DQo+ICAgCWNsZWFudXBfc3JjdV9zdHJ1Y3QoJmhlYWQtPnNy
Y3UpOw0KPiAgIAludm1lX3B1dF9zdWJzeXN0ZW0oaGVhZC0+c3Vic3lzKTsNCj4gKwlrZnJlZSho
ZWFkLT5wbGlkcyk7DQo+ICAgCWtmcmVlKGhlYWQpOw0KPiAgIH0NCj4gICANCj4gQEAgLTk3NCw2
ICs5ODksMTMgQEAgc3RhdGljIGlubGluZSBibGtfc3RhdHVzX3QgbnZtZV9zZXR1cF9ydyhzdHJ1
Y3QgbnZtZV9ucyAqbnMsDQo+ICAgCWlmIChyZXEtPmNtZF9mbGFncyAmIFJFUV9SQUhFQUQpDQo+
ICAgCQlkc21nbXQgfD0gTlZNRV9SV19EU01fRlJFUV9QUkVGRVRDSDsNCj4gICANCj4gKwlpZiAo
cmVxLT53cml0ZV9oaW50ICYmIG5zLT5oZWFkLT5ucl9wbGlkcykgew0KPiArCQl1MTYgaGludCA9
IG1heChyZXEtPndyaXRlX2hpbnQsIG5zLT5oZWFkLT5ucl9wbGlkcyk7DQo+ICsNCj4gKwkJZHNt
Z210IHw9IG5zLT5oZWFkLT5wbGlkc1toaW50IC0gMV0gPDwgMTY7DQo+ICsJCWNvbnRyb2wgfD0g
TlZNRV9SV19EVFlQRV9EUExDTVQ7DQo+ICsJfQ0KPiArDQo+ICAgCWlmIChyZXEtPmNtZF9mbGFn
cyAmIFJFUV9BVE9NSUMgJiYgIW52bWVfdmFsaWRfYXRvbWljX3dyaXRlKHJlcSkpDQo+ICAgCQly
ZXR1cm4gQkxLX1NUU19JTlZBTDsNCj4gICANCj4gQEAgLTIxMDUsNiArMjEyNyw1MiBAQCBzdGF0
aWMgaW50IG52bWVfdXBkYXRlX25zX2luZm9fZ2VuZXJpYyhzdHJ1Y3QgbnZtZV9ucyAqbnMsDQo+
ICAgCXJldHVybiByZXQ7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCBudm1lX2ZldGNoX2Zk
cF9wbGlkcyhzdHJ1Y3QgbnZtZV9ucyAqbnMsIHUzMiBuc2lkKQ0KPiArew0KPiArCXN0cnVjdCBu
dm1lX2ZkcF9ydWhfc3RhdHVzX2Rlc2MgKnJ1aHNkOw0KPiArCXN0cnVjdCBudm1lX25zX2hlYWQg
KmhlYWQgPSBucy0+aGVhZDsNCj4gKwlzdHJ1Y3QgbnZtZV9mZHBfcnVoX3N0YXR1cyAqcnVoczsN
Cj4gKwlzdHJ1Y3QgbnZtZV9jb21tYW5kIGMgPSB7fTsNCj4gKwlpbnQgc2l6ZSwgcmV0LCBpOw0K
PiArDQo+ICsJaWYgKGhlYWQtPnBsaWRzKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCXNpemUg
PSBzdHJ1Y3Rfc2l6ZShydWhzLCBydWhzZCwgTlZNRV9NQVhfUExJRFMpOw0KPiArCXJ1aHMgPSBr
emFsbG9jKHNpemUsIEdGUF9LRVJORUwpOw0KPiArCWlmICghcnVocykNCj4gKwkJcmV0dXJuIC1F
Tk9NRU07DQo+ICsNCj4gKwljLmltci5vcGNvZGUgPSBudm1lX2NtZF9pb19tZ210X3JlY3Y7DQo+
ICsJYy5pbXIubnNpZCA9IGNwdV90b19sZTMyKG5zaWQpOw0KPiArCWMuaW1yLm1vID0gMHgxOw0K
DQpjYW4gd2UgcGxlYXNlIGFkZCBzb21lIGNvbW1lbnQgd2hlcmUgdmFsdWVzIGFyZSBoYXJkY29k
ZWQgPw0KDQo+ICsJYy5pbXIubnVtZCA9ICBjcHVfdG9fbGUzMigoc2l6ZSA+PiAyKSAtIDEpOw0K
PiArDQo+ICsJcmV0ID0gbnZtZV9zdWJtaXRfc3luY19jbWQobnMtPnF1ZXVlLCAmYywgcnVocywg
c2l6ZSk7DQo+ICsJaWYgKHJldCkNCj4gKwkJZ290byBvdXQ7DQo+ICsNCj4gKwlpID0gbGUxNl90
b19jcHUocnVocy0+bnJ1aHNkKTsNCg0KaW5zdGVhZCBvZiBpIHdoeSBjYW4ndCB3ZSB1c2UgbG9j
YWwgdmFyaWFibGUgbnJfcGxpZHMgPw0KDQoNCg0KPiArCWlmICghaSkNCj4gKwkJZ290byBvdXQ7
DQo+ICsNCj4gKwlucy0+aGVhZC0+bnJfcGxpZHMgPSBtaW5fdCh1MTYsIGksIE5WTUVfTUFYX1BM
SURTKTsNCj4gKwloZWFkLT5wbGlkcyA9IGtjYWxsb2MobnMtPmhlYWQtPm5yX3BsaWRzLCBzaXpl
b2YoaGVhZC0+cGxpZHMpLA0KPiArCQkJICAgICAgR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKCFoZWFk
LT5wbGlkcykgew0KPiArCQlyZXQgPSAtRU5PTUVNOw0KPiArCQlnb3RvIG91dDsNCj4gKwl9DQo+
ICsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgbnMtPmhlYWQtPm5yX3BsaWRzOyBpKyspIHsNCj4gKwkJ
cnVoc2QgPSAmcnVocy0+cnVoc2RbaV07DQo+ICsJCWhlYWQtPnBsaWRzW2ldID0gbGUxNl90b19j
cHUocnVoc2QtPnBpZCk7DQo+ICsJfQ0KPiArb3V0Og0KPiArCWtmcmVlKHJ1aHMpOw0KPiArCXJl
dHVybiByZXQ7DQo+ICt9DQo+ICsNCj4gICBzdGF0aWMgaW50IG52bWVfdXBkYXRlX25zX2luZm9f
YmxvY2soc3RydWN0IG52bWVfbnMgKm5zLA0KPiAgIAkJc3RydWN0IG52bWVfbnNfaW5mbyAqaW5m
bykNCj4gICB7DQo+IEBAIC0yMTQxLDYgKzIyMDksMTkgQEAgc3RhdGljIGludCBudm1lX3VwZGF0
ZV9uc19pbmZvX2Jsb2NrKHN0cnVjdCBudm1lX25zICpucywNCj4gICAJCQlnb3RvIG91dDsNCj4g
ICAJfQ0KPiAgIA0KPiArCWlmIChucy0+Y3RybC0+Y3RyYXR0ICYgTlZNRV9DVFJMX0FUVFJfRkRQ
Uykgew0KPiArCQlyZXQgPSBudm1lX2ZldGNoX2ZkcF9wbGlkcyhucywgaW5mby0+bnNpZCk7DQo+
ICsJCWlmIChyZXQpDQo+ICsJCQlkZXZfd2Fybihucy0+Y3RybC0+ZGV2aWNlLA0KPiArCQkJCSJG
RFAgZmFpbHVyZSBzdGF0dXM6MHgleFxuIiwgcmV0KTsNCj4gKwkJaWYgKHJldCA8IDApDQo+ICsJ
CQlnb3RvIG91dDsNCj4gKwl9IGVsc2Ugew0KPiArCQlucy0+aGVhZC0+bnJfcGxpZHMgPSAwOw0K
PiArCQlrZnJlZShucy0+aGVhZC0+cGxpZHMpOw0KPiArCQlucy0+aGVhZC0+cGxpZHMgPSBOVUxM
Ow0KPiArCX0NCj4gKw0KPiAgIAlibGtfbXFfZnJlZXplX3F1ZXVlKG5zLT5kaXNrLT5xdWV1ZSk7
DQo+ICAgCW5zLT5oZWFkLT5sYmFfc2hpZnQgPSBpZC0+bGJhZltsYmFmXS5kczsNCj4gICAJbnMt
PmhlYWQtPm51c2UgPSBsZTY0X3RvX2NwdShpZC0+bnVzZSk7DQo+IEBAIC0yMTcxLDYgKzIyNTIs
OSBAQCBzdGF0aWMgaW50IG52bWVfdXBkYXRlX25zX2luZm9fYmxvY2soc3RydWN0IG52bWVfbnMg
Km5zLA0KPiAgIAlpZiAoIW52bWVfaW5pdF9pbnRlZ3JpdHkobnMtPmhlYWQsICZsaW0sIGluZm8p
KQ0KPiAgIAkJY2FwYWNpdHkgPSAwOw0KPiAgIA0KPiArCWxpbS5tYXhfd3JpdGVfaGludHMgPSBu
cy0+aGVhZC0+bnJfcGxpZHM7DQo+ICsJaWYgKGxpbS5tYXhfd3JpdGVfaGludHMpDQo+ICsJCWxp
bS5mZWF0dXJlcyB8PSBCTEtfRkVBVF9QTEFDRU1FTlRfSElOVFM7DQo+ICAgCXJldCA9IHF1ZXVl
X2xpbWl0c19jb21taXRfdXBkYXRlKG5zLT5kaXNrLT5xdWV1ZSwgJmxpbSk7DQo+ICAgCWlmIChy
ZXQpIHsNCj4gICAJCWJsa19tcV91bmZyZWV6ZV9xdWV1ZShucy0+ZGlzay0+cXVldWUpOw0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvbnZtZS5oIGIvZHJpdmVycy9udm1lL2hvc3Qv
bnZtZS5oDQo+IGluZGV4IDA5M2NiNDIzZjUzNmIuLmNlYzhlNWQ5NjM3N2IgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbnZtZS9ob3N0L252bWUuaA0KPiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9u
dm1lLmgNCj4gQEAgLTQ1NCw2ICs0NTQsOCBAQCBzdHJ1Y3QgbnZtZV9uc19pZHMgew0KPiAgIAl1
OAljc2k7DQo+ICAgfTsNCj4gICANCj4gKyNkZWZpbmUgTlZNRV9NQVhfUExJRFMgICAoTlZNRV9D
VFJMX1BBR0VfU0laRSAvIHNpemVvZigxNikpDQoNCnRoaXMgY2FsY3VsYXRlcyBob3cgbWFueSBw
bGlkcyBjYW4gZml0IGludG8gdGhlIGN0cmwgcGFnZSBzaXplID8NCg0Kc29ycnkgYnV0IEkgZGlk
bid0IHVuZGVyc3RhbmQgc2l6ZW9mKDE2KSBoZXJlLCBzaW5jZSBwbGlkcyBhcmUgdTE2DQoNCm52
bWVfbnNfaGVhZCAtPiB1MTYgKnBsaWRzc2hvdWxkIHRoaXMgYmUgc2l6ZW9mKHUxNikgPyAtY2sN
Cg0K

