Return-Path: <io-uring+bounces-7242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1E1A70830
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 18:28:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E380A164985
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 17:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A30F19D090;
	Tue, 25 Mar 2025 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zh5Uy97X"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79A1891AA;
	Tue, 25 Mar 2025 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742923681; cv=fail; b=k10aPmkPBFkUjNgJNKVrcfyM0SpIGIGkY1lwZst6w92JLG7sD/BCCUwyYKPYl/Pqj1107utexeXxqSUzdz6RaNjKN9Obecnh6jvMtidt34G6vgTE3TAgX3E6mPEJ65NfjIIz266aOLNrq2NG/vGqf5dZL7GOOmK0FduoYjkRbCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742923681; c=relaxed/simple;
	bh=PRKzcs3Nk2n/78D7IIpVmxNJzOgTRC+w8RH7gpr8m+A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gTDXcMxbhDzkidHIG+Kp1hCx1yewtVengLgDKglLJRwNqNMWo8w8lwPv1Jq+5u730p65nXu5CgzXtd8pJTXo7qNxLtkoFc3BszFOhfP3RoLDZPVF1XX6lVzEZXmqRUK5zPf3xqa8vXr+/FcyO87FvMDcFvSEHdUGXHleQ2PDYQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zh5Uy97X; arc=fail smtp.client-ip=40.107.100.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+GNI4yTtOAn08uSO11Yzb6TVfdGZ3I9gHdqNDLKXy/b7VjA21ZY8H/Eglc487vZt1+iLbFw1Aw+GAPVWUCZabV2mYK7nYOkAg4X1hD6L9ejSk8CX8rYD5vxjoNzI3cQwCXIkEWMHKdAg/FekDAhOFcaNSinBJyI4WJS71YkrL2GhQdAHDwRgFpGqyQQTs4q3RnejXBIaQh3WP8XZxHv00p+Nqegf2Zi4p2PnhsRiqAC8Wy+aE6uedTSS9+u4Yq6zI7SakeuZmEKPv7E7Lh3s54v5d/XBEXw2WqWh/65vgF9Mm/suy7hWp9Du9QBtOH4vBjLNOvLaiZez48LU5RApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRKzcs3Nk2n/78D7IIpVmxNJzOgTRC+w8RH7gpr8m+A=;
 b=nS20nfw4RbZdtKWH+p2Yha4Q//ZpgUK6zXriVkeSpqcojsj+2xZxeujCkPiUTbCdFZYJrW/zabYWRvZWZNyEyx/jUYe1vY1cSL+ymt8/xuKgSS2uj+9Beur5+/wRdr0inGsAr9Vg5Ai4hSnJyTcVhpqBdZNxdeTQVK55j0QROH7LTfbkPlLhRoXAww+Qzd7xHGpdmFuIzkeMiFjpZJVZQHbI0581/Jmv/wFyKi68vAXW2BetWyFyQ3wrQTUaZ21TelrvcYocT+cly+ZFTIwegYbTWffVN8TqeN1w673cWvGa4FwfgWMBJp96lrnSkdhe06VpcdRKj8IOm0S1m2t+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRKzcs3Nk2n/78D7IIpVmxNJzOgTRC+w8RH7gpr8m+A=;
 b=Zh5Uy97X8vea++SJBIuG54S4VibZtLcu6+4E9uXlZo9PzFyeLT5cWxuj4EBH9+SJQyHG51czgv2zaseSf/PNBRHLiC31sxS9OpqcfgfgqRfURBJWyyf43o923ZN2YK/skv81vBnl6Df3+eTI5k03jjeHXuhkUlsH8VzR02Ayy/P2bCmnCfizj8FobJRklakwZewRlHr44rls8lQWkLaMVT1eEejhTK14QXpDCLdp55PnSsQudDpUCdgCT7krFWPcTZPMx2YPv1WdqBunXFQP9leJFSJGk1W+l+Zq8JHBYhlMaQGHTG1/FPA2dTwy8YMwQjXwA/QPI+mCEpwyCvB6Pg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB6327.namprd12.prod.outlook.com (2603:10b6:8:a2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.42; Tue, 25 Mar 2025 17:27:55 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 17:27:55 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Caleb Sander Mateos <csander@purestorage.com>, Keith Busch
	<kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
	<hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Pavel Begunkov
	<asml.silence@gmail.com>
CC: Xinyu Zhang <xizhang@purestorage.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] nvme_map_user_request() cleanup
Thread-Topic: [PATCH v3 0/3] nvme_map_user_request() cleanup
Thread-Index: AQHbnPhIsPjXWhuJ9k2O7fCVxRZMC7OEHIsA
Date: Tue, 25 Mar 2025 17:27:55 +0000
Message-ID: <36e514f8-27a6-40e2-88dc-c2f985b0d04a@nvidia.com>
References: <20250324200540.910962-1-csander@purestorage.com>
In-Reply-To: <20250324200540.910962-1-csander@purestorage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB6327:EE_
x-ms-office365-filtering-correlation-id: 01d894b4-3e98-480c-fab5-08dd6bc26106
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|7416014|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Umc4NVZIbGRSM3ZEemtzVU82cEphMTJYZ2NGK0hyRmJqeVhaSEVoLzdGem1y?=
 =?utf-8?B?T09KcGFpVFdPTnhGRjg3SFg3ajBFM1BNQ2F3Q0JwUlJYdUQrc3dpTnUyTjhk?=
 =?utf-8?B?NHo3NmZCcXg0UkxWa0lIeVZGY212b25YZldzZ25XMzh2U1h0akRQVjFEajFE?=
 =?utf-8?B?b1dGSDV5ZGNrVXEvRW5uaXVKeEdhUkRiOGhuOUtMYWxVYWk2VUlOd29hMnN2?=
 =?utf-8?B?eTZqZXJKTzVBV01HQTNDU0JFMFJPWDJwbEFqUEtLeWM0VlVKZGcwaHpEUzYw?=
 =?utf-8?B?bjY4UVhHN1dKdFIrRVdac3dIQUl5d2pTR0JOc2UwSjB0NEtjWkoyYytPSENJ?=
 =?utf-8?B?T24ycWQ1UkxnRWgwa21HREdiN1NIS1Qvdm11Nlh4NHcvWmxiY25SZmZTcDNS?=
 =?utf-8?B?YURKaytKeFYzU2d0dkliK09BZWtFMFpIRnhadDliUG10VTJkYzNnaURZRWtt?=
 =?utf-8?B?YmI4UUhuWVhUWDhqUXY3MGtUYlhzdzN3QXlKTG9kOEwxQ1pCYU1ScUg0UWFN?=
 =?utf-8?B?SC8yUGt3cHRyWGpyYmtpbTlpc1NVazZPclVJdE94eHlKbThYVmFwK1lKci9B?=
 =?utf-8?B?dFZZbit2QlYyWHZGNCtTcHlOS0Z1VTRqdzhLTFpWZ1FMNWZBUWlIRVVWbSti?=
 =?utf-8?B?SW5xS3hVMTZ1bk1VMGNHREk0akIvMFowTTBMdVJDZ01wL1g0ajJ6YXlmZHBL?=
 =?utf-8?B?d2hVSlNFQ2lyMVkzY2xiYkw3d0REWXR3dHlsd3pVbUFOcVJVbSsyVHBnNFhm?=
 =?utf-8?B?TzFhN2xNVUhydE9rZ01sN3RvVGFKWXZmMnhpVVhKSGt4cDdYSE5oQTA4L1Z1?=
 =?utf-8?B?ZytjMG1TTHBOK3JlMGJXM3dUUDVOL1ZBeFJ6ZkJZcFhhdnNZbWd3ZjBWNThr?=
 =?utf-8?B?REhWUXZUZmJIUENpNjJVRStya0lZSFU2Q3ZMK2lpSHlIMGRVaWttSk5rNUls?=
 =?utf-8?B?eE83bm9lQnRRTXl0SytDc25DcGNPbXc0NU5hakYyaTVPbjNBbGV2STNDbHRn?=
 =?utf-8?B?TFR2cWpSNkkyaVdIUDBaSlRQaTNjbnJOQ0IyL2tGS1JBQW83OVA0Z2JYektU?=
 =?utf-8?B?WUhubHpjQUs2cjFDdy9QVlltR0VzNVVEVGNsUHo3blhoWG52RFYzK3hIVmFQ?=
 =?utf-8?B?U0ZGWlVKakgvYVowVlNyVnl6QksrQ29ESjNaUXJ2ZjlNdGtrWEUwNTBac2M1?=
 =?utf-8?B?NEkrYnFHT1FKQUdOUDF6cTNHTEFqb1pVK1ZLeHozWmpOcFBYalRqcUF2RGp6?=
 =?utf-8?B?WjZsUmtQcFFyRTJuWklyN1dPQ1dpS3ZwVUh5UVUvUk5DdEx5bWV6SWwwMVRG?=
 =?utf-8?B?bmJ3U2RTV0EzZHY5MlpyaG5weW1Oa2puTGFpTWJuZ0NYQmR3YTRBT0FvZTJR?=
 =?utf-8?B?OWRNWWI4UnBVVHdxa0R2MnRESFc0UGdCWTdqTFBJcXhRaWdlMjJmeHFDMzRM?=
 =?utf-8?B?bXppNDhXcmkwdSszSnp5TjZBemV4azdFUlJlYkxUUWhLV3ZmOU81VXYwQ0x3?=
 =?utf-8?B?NjB1VC9XYS9XRFdOVUNsMHh2cThFb25SNCtXeGRqUlNLY0U0S3lPZzZscVhM?=
 =?utf-8?B?RHkrd05IYTNCRmQxVlh2S0d4TGhRTHduRXJINHNTQ1lzSnlSWTczZFFiZWQx?=
 =?utf-8?B?RlVDUmp2WG9jY0dGZ3Fxd3czRWN4YnJDVVBIZjMvdTFqUEY1dkc5WUpMUHNl?=
 =?utf-8?B?RVd3Q0l1SDZpYzFIZUxqSUljQytVM2IyRW9hNnpod051anJ5L3NjRW9zSE9R?=
 =?utf-8?B?d3F3RkJkc2VnMDh3STBuYi9VaVpoVXlnWnAwMWxJMlJvODBBcHZmOXFyS3FZ?=
 =?utf-8?B?Z2ZTZzdaM2R6cHoxNTcxUnBzMnFPNjcyRlVWWWo4a1NQd0J1VXJ1aFVTdkZh?=
 =?utf-8?B?UTN3azhRalEyQ1BJZyszTlFyMWJ1azU1dTVnUTYwL24yOU9GdkJzRGxlQnZU?=
 =?utf-8?Q?9MfrxdRmXotv3QR+vNuzSGZTu/3L3AlZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(7416014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXdwdzhOTWdudmxhY2VKWW1QK0ZhaGxIVFVxWXZOS0JiUEhWWENtTFE4Qkpa?=
 =?utf-8?B?VlBBRmQ3L0JFRExaenJ1aWhVUGdGSExNVjBRV0FhdXRGVzVhcDhSQlJKRnF1?=
 =?utf-8?B?VjA4ZHJDRHMvYXNOMnJTVGdiMWk4WW1sQ1Nvd2ZDaXp2M2VKVk5MMEFYdlR6?=
 =?utf-8?B?eG1CdGFLSDFLeWx0RlpiOUZzR0UwZXZidWJCYTRENFZyRlQ1bmNDQjlLQVAr?=
 =?utf-8?B?QWQ4YnhEZ2ppc2RPUzB4dHhWOGdLdnZhR3U5a1RwT09aaVhkb2VLNzU4S0NF?=
 =?utf-8?B?OXRFQXZjaXFrMlFrSUVyYktBcTcxeGlzQktmVC96eitVb2s2ZjJZVm5JN0Vz?=
 =?utf-8?B?K3NxWkVoanRMWGR1VFFrTXUvYWVIUmJpS3BHenhFSHg3WlNWOUxvdThSdVFX?=
 =?utf-8?B?bFBpSGdoTXBBQUd0ajBPTnRnOTlUZENCQVRnT3pRYmhaRWhHVUNWYjdpbVky?=
 =?utf-8?B?NE9TSjR2TGpaVWZ3ZmFiSE9iaWJra2EycmtUbzUzQmxNYSsxbWVyczRpZjdl?=
 =?utf-8?B?SC8vTlA0ak9WY2Izc1k3VVN3MXhuL0xMSzFnYThxa0phMzhLcDZpYW9vWXcw?=
 =?utf-8?B?dWxWcmZRZlZPUHMxeEoxaUcrZWZkN05hbmNlTTdocDJEaytjQjFkTS9ZcXQz?=
 =?utf-8?B?eEhuVUdBRGd6K2hCVmx0eFhOQi9nMWUrZHlSRWJyTXFEa2ZhR3R6ZVJGNTVo?=
 =?utf-8?B?TFlhK3BCdUV1UzhqdzA5TFpucHBxekU0U3g2cUdaRVA4blNmQzVNOThQMEs5?=
 =?utf-8?B?TnBmdmdrN25HbVZvTTNrRGFlUFQ5VjVQMllzT3ArOXprV251ZGNROVRVRXZk?=
 =?utf-8?B?bFc3WVpRZFlDKzd2UmV5MU1kWjJ0dk53N0daV1FjQVJzMWpSaTRZdTBUTEFS?=
 =?utf-8?B?ZG42S2JFZENuaTQ5M3N4MVY2K1o3dUUvYjNJQlF0TG5XSXpicTZncWlsTzVO?=
 =?utf-8?B?RTB1N3Bsa3R1UUpncmIxY2xuWHdzdGVKeTNXRXFUZ0RFSjVnOUMzYzZOdWxk?=
 =?utf-8?B?M1dnS2svenI1VlQzWDZObXRHT1RzUU9QVnVDc0J1OFRtbTlDOVZicCszSmJJ?=
 =?utf-8?B?RVR1MUhqdnc5bzNRVjhtVGJyVi9wU3Q5ZHZ6U0VzRkplODJ4R3prdFFmMnZh?=
 =?utf-8?B?Wk9nekRPRTZNaDFJMHpQV0lvS0dYVm9na0xuZko4aHRrN3VIWVdRTkxPaXlt?=
 =?utf-8?B?THB4OVIzcWdHaG4vY0VzbXFxM0JFRGlnYXY4eTJBK2JYcFVZeDVvQjF5VnRz?=
 =?utf-8?B?emFITC9HeEdUcmxtKzVBTE5vS1hiaUlhSHF4UDB2bXl6ekhpV1ZCMHArd3Vq?=
 =?utf-8?B?elhJcnB2MHBHOURkbHVqb0hoem1hWk01bVEwUFRzRDI2SGlYNVM0d2ZkUWI5?=
 =?utf-8?B?YTV5QXBSRHFaUzN1bnZSMWFsMlRPMklrcklPRXQxWU5qcCtDbGJVR0FNOGZU?=
 =?utf-8?B?aDNIdnVBczd1QXFqcXkwSjMyc1JzYjcrZlJkdjNVcGg3UGVadGJKOWM3eDhk?=
 =?utf-8?B?RWlneW04a09vV0JnL3owY0xLbmlNUFNnMkJCdnE2R2c1dCtiZEdzV0Y4R0or?=
 =?utf-8?B?Unl6ZWltOFFaTUNkM0U1Y3dEVFdJVVdxb2NPZCt4bjl5UVp3aUtYU0g5ang3?=
 =?utf-8?B?YjBCNnFLSEhjR1hwSXZaY1hQVUN5bzhGMGRsaUxqVlVtZVU1NHFCbFM3NFVx?=
 =?utf-8?B?OTUvM01Kb21EL0MzMWlMNmRLaEdXZTRQT3Q2emdRNzJVMzBXZmt3RmlZYXNt?=
 =?utf-8?B?M3VrMzE5bjZTSGZZL20yZzhtMDVOM25YL3NEZXpuVHo0RmxGV0dmVnpMekUr?=
 =?utf-8?B?VGRXY3VscnhKRzRNdzhlbEpoQ2YwdDJPNTZ3eFpBLyszandUU0NTZmNSRG4y?=
 =?utf-8?B?UXBvTTlid05nUEFrS2QxQzBQWXl5TGhoUm4rSmxhUCsvVU4vU3QrU3phbjJT?=
 =?utf-8?B?V3ZRVWM0Z0ExaXpOaEdQejVGQ2VYWE1BNDJ1Q1FYUEJLQVV6QkdsSDgvRlFN?=
 =?utf-8?B?MG1NanlmckFpby95NW1NRnlmd3M0anJCSDFyT3NmdEdsVUlzWUVsUFdQQlpk?=
 =?utf-8?B?MVN3Z0VwRVdBcHlSU2x2TktZTGRjVzBDTXZKck5qcnhmSmNNYnlESldGUmVO?=
 =?utf-8?B?cDFmWmovZUlHWmljcjRnWG9zSDJqeEZ2WktEMDhSSW1GeW9ONTNydm1lNHpF?=
 =?utf-8?Q?X35kPVepsGfb8oOM8tNMRUuLYK+4eedeshBRfaqPuFA2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59B2B04E63D2D84B9937CB76DF25BE95@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d894b4-3e98-480c-fab5-08dd6bc26106
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2025 17:27:55.2019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5fKpE5q6bDv47PXfyrY5EcDTxnSV6DAfnLRjqZXIajaRmfSBPO7LI5f4AQjYVUk+RWF1fbXj7LBGZmuqF+ahow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6327

T24gMy8yNC8yNSAxMzowNSwgQ2FsZWIgU2FuZGVyIE1hdGVvcyB3cm90ZToNCj4gVGhlIGZpcnN0
IGNvbW1pdCByZW1vdmVzIGEgV0FSTl9PTl9PTkNFKCkgY2hlY2tpbmcgdXNlcnNwYWNlIHZhbHVl
cy4NCj4gVGhlIGxhc3QgMiBtb3ZlIGNvZGUgb3V0IG9mIG52bWVfbWFwX3VzZXJfcmVxdWVzdCgp
IHRoYXQgYmVsb25ncyBiZXR0ZXINCj4gaW4gaXRzIGNhbGxlcnMsIGFuZCBtb3ZlIHRoZSBmaXhl
ZCBidWZmZXIgaW1wb3J0IGJlZm9yZSBnb2luZyBhc3luYy4NCj4gQXMgZGlzY3Vzc2VkIGluIFsx
XSwgdGhpcyBhbGxvd3MgYW4gTlZNZSBwYXNzdGhydSBvcGVyYXRpb24gc3VibWl0dGVkIGF0DQo+
IHRoZSBzYW1lIHRpbWUgYXMgYSB1YmxrIHplcm8tY29weSBidWZmZXIgdW5yZWdpc3RlciBvcGVy
YXRpb24gdG8gc3VjY2VlZA0KPiBldmVuIGlmIHRoZSBpbml0aWFsIGlzc3VlIGdvZXMgYXN5bmMu
IFRoaXMgY2FuIGltcHJvdmUgcGVyZm9ybWFuY2Ugb2YNCj4gdXNlcnNwYWNlIGFwcGxpY2F0aW9u
cyBzdWJtaXR0aW5nIHRoZSBvcGVyYXRpb25zIHRvZ2V0aGVyIGxpa2UgdGhpcyB3aXRoDQo+IGEg
c2xvdyBmYWxsYmFjayBwYXRoIG9uIGZhaWx1cmUuIFRoaXMgaXMgYW4gYWx0ZXJuYXRlIGFwcHJv
YWNoIHRvIFsyXSwNCj4gd2hpY2ggbW92ZWQgdGhlIGZpeGVkIGJ1ZmZlciBpbXBvcnQgdG8gdGhl
IGlvX3VyaW5nIGxheWVyLg0KPg0KPiBUaGVyZSB3aWxsIGxpa2VseSBiZSBjb25mbGljdHMgd2l0
aCB0aGUgcGFyYW1ldGVyIGNsZWFudXAgc2VyaWVzIEtlaXRoDQo+IHBvc3RlZCBsYXN0IG1vbnRo
IGluIFszXS4NCj4NCj4gVGhlIHNlcmllcyBpcyBiYXNlZCBvbiBibG9jay9mb3ItNi4xNS9pb191
cmluZywgd2l0aCBjb21taXQgMDA4MTdmMGYxYzQ1DQo+ICgibnZtZS1pb2N0bDogZml4IGxlYWtl
ZCByZXF1ZXN0cyBvbiBtYXBwaW5nIGVycm9yIikgY2hlcnJ5LXBpY2tlZC4NCj4NCj4gWzFdOmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2lvLXVyaW5nLzIwMjUwMzIxMTg0ODE5LjM4NDczODYtMS1j
c2FuZGVyQHB1cmVzdG9yYWdlLmNvbS9ULyN1DQo+IFsyXTpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9pby11cmluZy8yMDI1MDMyMTE4NDgxOS4zODQ3Mzg2LTQtY3NhbmRlckBwdXJlc3RvcmFnZS5j
b20vDQo+IFszXTpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTAyMjQxODIxMjguMjA0
MjA2MS0xLWtidXNjaEBtZXRhLmNvbS9ULyN1DQo+DQo+IHYzOiBNb3ZlIHRoZSBmaXhlZCBidWZm
ZXIgaW1wb3J0IGJlZm9yZSBhbGxvY2F0aW5nIGEgYmxrLW1xIHJlcXVlc3QNCj4NCj4gdjI6IEZp
eCBpb3ZfaXRlciB2YWx1ZSBwYXNzZWQgdG8gbnZtZV9tYXBfdXNlcl9yZXF1ZXN0KCkNCg0KTG9v
a3MgZ29vZCB0byBtZS4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52
aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==

