Return-Path: <io-uring+bounces-11846-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJN/NJnBb2l3MQAAu9opvQ
	(envelope-from <io-uring+bounces-11846-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 18:55:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B02348EDA
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 18:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1C029869FE2
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16143A8FF9;
	Tue, 20 Jan 2026 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E1F3B/j2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="odMTLjdJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F041322C;
	Tue, 20 Jan 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768930421; cv=fail; b=teU4iQP0wwuxmxqevn4W/NN24GAbFM6PprL8qqOLOAWkBXUzPMkqdNmTXp6a6wl0ZS8Q7OoqzyJoIHcp4OqbMg1CdGBf63OaNzI0y/yX2SXedCoJDwvQXnn6lcEyc7APOdoHQNAeEF/L+W7Ed1qrALUfFK5SXmu54MuWyygp7cE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768930421; c=relaxed/simple;
	bh=qaC2PZ/bOvmMgBBzLwRMnEVIXjYjh9yijZdClph3l6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nPFqUjyJ5BolQCII0UmWJSpehGUaxhQxSupiL6Ch/9ceUtg8LPoejo/PdtBKESuckUY/OTffNhvGnzy2Hl+XzyKE6//dHEV6b2XIQmvbRujUL74ltYWOTkoJ0y+wd7bTPn4LTmTHTO1q0SIdT8NWBC3xv2gOCqR0U7gRlvy+Sbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E1F3B/j2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=odMTLjdJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KDK8a43867879;
	Tue, 20 Jan 2026 17:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A9A50iZG9sUwtEzXvg/EE8I2UHtjuv7Tr7aXhRlNGEg=; b=
	E1F3B/j2vqJVHeuCfp9+7o0k1xK2Yro6SMQ3tV4thwo0PKTOQW0tFctbWxafIHgv
	p4InYV377OiqP/ApxyFxR1gH2BPexPn/CV7lzYh8O1iTXImiUGR954S1ajFfAIOV
	9mVM7euG3Plx6AHX2H34QSv28cBGNstt5NJvksxZu2Z+Tea0M84lwf7ZjlU2hab1
	1dCpWmEygPINH23UY25378g2mfL54lAvSZiZRiuLLkE/NIcPgny+LmCNJ7TEtIvK
	2eUO5k6ILkPPoMZdWwrI0w7uV6leyY//wh7EQlx/ZEF/N+CUE67v0tmIOGyzGIVK
	SsFgdKB3oS8TshmAaiDbMA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd0fug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:33:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KGP7Po015530;
	Tue, 20 Jan 2026 17:33:25 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9yx0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KokUjOrvOVZ7Hood8VGzI7ZUcWKFrLOS5IY9j1yUbUStTGSq5Y/ciw9KqFGgsnQ2c+JU5BfZw36YmhwQzitLFDkaI380rHr335EwgBE2xefuS+Y7YuQTjYX+u4YM1dtD7rwoO5r1vtDB08JERh5PSNCLeCvbJnTsz2BNV1cFtR7yEsUBNDrTmZ7y7abJdhsvQTjf9wU1rvErSOSsajzcJjK6Kxk9OWQW5P7GoLiNPPBWZbe3nUI10J3Ujn4rm8qo8awmkEW3quatODFa2eVYyyc7YzXZnvtMH5i7dymG+vC4lKY+4xd1mPUQlX+f5eorgrtGn2r/iFWmQchWRPd2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9A50iZG9sUwtEzXvg/EE8I2UHtjuv7Tr7aXhRlNGEg=;
 b=gGEAY1Q0MUCrFuMIKD13fwjwgUVdn2TdLwUEI6kHxkrBv9ZjwPfnk/Ga5eRnXwWrJTyGzVICty8wiDjS6TymuLbnla2zeJChgz7n6EPWUbUwliqFX1s/F6ESxo2OO1ZECNk6ujRiVJQCWoQuBMnFy/p/H7SMgv7V2SOt1mMT/c+z1FT4KxY5gkWPj2Bh9pTvac4X2L3XjXpZc3znuFWDLL7h0YlNEX27bsTa1ZzdiGZ5lGeNPuJ2S2x7qfSYymvlRqS+95MX/F4ieve4ALICrSk0QdumKXouWc/3g+/cpwcyHw3nTH1PUj7oDCtGuKsdnxiuDmonc+BEgPxeN1soig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9A50iZG9sUwtEzXvg/EE8I2UHtjuv7Tr7aXhRlNGEg=;
 b=odMTLjdJeh0lab7IMUNRFjDeAYZLzkLl9QAzAb8FrvXQKpNg4hB4M0hqo58XIfgQtX29QkUXlV3ewok8Lq8YqjiIr/CrBqH/IKbnJ+lHs2L3Yd+Lf2Q3g/69/NxfF60MwsfzLVHdDJwT/ZIIx4nRugN//U1BehT6BezyxWGtCz8=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA2PR10MB4442.namprd10.prod.outlook.com (2603:10b6:806:11a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Tue, 20 Jan
 2026 17:33:22 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 17:33:22 +0000
Message-ID: <b53d5207-0dbc-4e1e-93e7-e51cb6c85383@oracle.com>
Date: Tue, 20 Jan 2026 23:03:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/kbuf: fix signedness in this_len calculation
To: Qingyue Zhang <chunzhennn@qq.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suoxing Zhang <aftern00n@qq.com>, cve@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0214.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::8) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA2PR10MB4442:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e50ad33-69b4-427a-ed35-08de584a027e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGdlZSthTGpNcGp3T2Zxc2Z3NU8zWG1jdWhtcFUyNVlxWHpGWFRSYTBZTnFk?=
 =?utf-8?B?Mk9ibE4waE5UMEhkaWFMR1U1cVMzcGVML1dJcWFJdi8yRk51S1Q5QkpTK21O?=
 =?utf-8?B?NHdsR29uUzgvNFdSbFhHT1hBZWFEYmllZCtRRVVrQS96VzdrZDNncHZnTkZP?=
 =?utf-8?B?TWQ2WVV1bkV0SEFzZUNsR0p2Vmd5ZE53MUt6N0VOdk1qYVlSQ1Zhc0czb0JY?=
 =?utf-8?B?dEpLbGpKWUxmWG9SNGNmdVhHbDhUcjVqdjIzVGRZRUQ2SEVrRWxjTEJlN1R0?=
 =?utf-8?B?MXlUemFhenI0dmFPZmVVTEdMT2JxZithUSt6Z1pqZkhUWTkrRDdvbGIxcmRT?=
 =?utf-8?B?TjRldGZ0a2hXTHhKWVB6T1ZSV0NHSUxzbUlXTjg5OEVlTEZkSUQ1VUFvVno4?=
 =?utf-8?B?Y3lFSzNlZWxnYlJsRTRzSDd3L1lxNEdvMlNOYVpWU3Y5SmhBSTl2bHRqUkNl?=
 =?utf-8?B?MXRnMmlDSGR3SERHbTM2aVhYVUtXV1BKRVlZaWNLb0xkUlJ3Z01YTmwxbWRn?=
 =?utf-8?B?TEdZRVRYWjdhbGJySTE5S1JYbVRNSnNiSWptVXhBV3V2ajVMdWpKK3Qyc0xG?=
 =?utf-8?B?U1RoSW1QVjl6WWVyTUYzcFEwMU9kVFczTWcvd0NjNFQweGV0dW1sZkJiOWpn?=
 =?utf-8?B?ZzIrMXpVbGVzSW9oRkdHZURxZVByYUdDTUxPbTducFYvYjU0WGxwSVozK0lp?=
 =?utf-8?B?NkNwSFZIaWsxQ2ZlOWk2UUZ4YkloZWNlcDBJL0pYdkRTSERPTGJWUStFa2dt?=
 =?utf-8?B?WWwzRHRralRTRFFxN2QyZkxTc1ZXR05oQUgwRm5vdXh4UitXa1dnYmdkd0pt?=
 =?utf-8?B?MEViUjBnRzJVQWZDeFlUT3MvbjhxL1NKM1MyWVBsbnJoWlhOOExzSklVQ2ZK?=
 =?utf-8?B?N3NzR1VDcUxwd3RaOGJxTEZwbEFIaWRPS2hQSmFLL2FwaXVJVlhTSTVPN0py?=
 =?utf-8?B?R3pqVGQ3QW1TWTRxaFBQUEJITzdHcnNBbVBBd1hUN0FnQ1NDSHQwUXVRQWJ4?=
 =?utf-8?B?QWs3dmsyb1EvdnhuRkR4ZEtObjRucllGeHBud2swNXE2aHFmNkhKTnNnZGdt?=
 =?utf-8?B?aVJKZEVJVEUya3VkbHgwdVZMeUxiQWF6RjlJTnhONXIyZFd1TjJ1bk4zOWky?=
 =?utf-8?B?RUgzRGxjNnpJOWMxVXhVZXdvZmNVb2krN1IvckY0ZFl2V3FBalB0WlN2RWoz?=
 =?utf-8?B?Y0c1eGN4WEs1RXFSRENsL3VlK2xrY0FvcFJ2a3UycFRRTDJVUEFveDFSSllH?=
 =?utf-8?B?d3Jab0ZQSEREQmtQRUs3UjRhVTkvakR1VmVaRWtuc3B5eUhnd2VjaU03ZGdZ?=
 =?utf-8?B?RzJFdGFzWVE1REp5MEh6eWpkcGNjS0g0NkU4UDA2dkhRRVo5WE1uTW81T1Vu?=
 =?utf-8?B?ZWxIQlJEdExOSUcyS1JnNFBqV050c0Y3WDZvTXFTVXBWNE5PVzRqd2JsUGsr?=
 =?utf-8?B?OHlWWFc5VjB4ODNLSUpCbWZzRnUvZ01yR1U2YTkzZUY0eWd6dmRSNEtCazI4?=
 =?utf-8?B?ZHBoK3MvVmwwc2tkblFia3o3MjhDSitNUVpuOCtyRDJUQk41all6NmZ4S2VM?=
 =?utf-8?B?VmtKVXNpVFhrU0pGYUVyVXhNME9CSzZIWHFqaW5MR1owRFlHTjZnUHUvVFM5?=
 =?utf-8?B?QWNmMDNrSWpPUFQxZENqKzk5VGZReFVaK210TDlnS1lTelVzenU4cHZya2pk?=
 =?utf-8?B?TFZ0YXM5SEMyYWJYWUIybzMrS3o4QUpVQjRxK0F0WVlBOFpyN2R3MlJJbmhE?=
 =?utf-8?B?UzAzWk9EbG93Zzg2L0piZFptZkQyUjZIWEpscVB4Z1NlWDV3UGczS3E5aUtl?=
 =?utf-8?B?N0svSGJ0dzhZMGI0Vm10cmFUVmF5c0FKQU52Z2VlRXpRalBPQWN0Ujl1dlpN?=
 =?utf-8?B?eDVZdnd1YWVMZTlkV0pJNnlNb3pCa2F2clJIRE5qR1B6aldPcnVXd1hkL0pL?=
 =?utf-8?B?ZlRiQU5BOUhmejJvZUwzby8xRnZCK1ZVaDZ3emcxdG0zblJ4cnc1Y25sQm1J?=
 =?utf-8?B?cnliR2FLbjVxS0hGTkMySS9aS0J5VXo5aHMrY2FIQkdCQ1dOUXlBUEgrbHFB?=
 =?utf-8?B?KzRJNU8wcEdEZlQvYWJhaURJMWt6c2JWRGM0bkVNLzRNa1EzejNaZHJNQmg2?=
 =?utf-8?Q?1O9eMYeKxzkjW0Xi+iQWRLPeV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ukx0Z1JvMm5OTHBnQnplejBRZFZHbGJKbHdsWHRVTlh6R3hBcm15WTh4a3Bl?=
 =?utf-8?B?dlBIWnFxa29WM0ZQV1FSMmJLNGF3ME1wVXFxNUZnQmlRZVR1bExkZmx3czlm?=
 =?utf-8?B?bEJqdkxGT3ZyUFF3ZWFMREN2SCtzZHhKVVZoeTBvYndvWk5ILzEzOEJQWmNF?=
 =?utf-8?B?SmM2MlZOdzl4eWpBUGhpdGxxUCt2c1k3cWJDV3Z1QUVHdllodTBxRStqVzh4?=
 =?utf-8?B?NnVjVk03SFBOM3pZbHRveU5jRWhsRTZyR1I3d243UFVXQnVseTdXYTg0ZXJV?=
 =?utf-8?B?bzZZU0JhRWhGVFA3OFd3WHVRNHFCcW83cy8zMElxUUFhcUlYYXNtSmErZHo3?=
 =?utf-8?B?WjBGNDdwdUxSQXJPc2RNdThqaitkMFhxYXVpRUxlYks3dm90ZHdwc1Z3Mmli?=
 =?utf-8?B?Y21zZ1VJdWJNLy9KdkkvbCs4dzFXOGJHckNkL3U0R3JhelZvT0N2OGJoY3BM?=
 =?utf-8?B?bEl0eTh4UGtmay9yc1A0MTdkdGI0ajE3MlJjY01vaUk4dzZNdGJTUWV4WUtq?=
 =?utf-8?B?bnZpeDI4NlRvUCtRNEYzYVZhUXdNSmhXQ2l3Q0x6dms1UEN5TndkaEtHMUMz?=
 =?utf-8?B?a1hIaVBwZHcyZDFOUkVpQnFLTnEwY1RxL3FCUVlsa0UyMk1aVFFMcFl1WjRY?=
 =?utf-8?B?N0hvTXlRNEpBS0lzNE1BdDNPTVF1M290MEpXWndOc0toMHZxQWtuaWtNM2di?=
 =?utf-8?B?Q0xpdXg2eENGWjR4V0tIUlRFN3doTU1FcHl2MG40ZVRlNExoRExySk91a2dy?=
 =?utf-8?B?aW1NYmVpeU5xOFlHSXlMNkxOM3NCSXR6bDg1MngxT0pEbEppNWwvOXB5Z09C?=
 =?utf-8?B?QUpCZDB4SGRDcHUwTTVaL1hsaVJTQURxRERVenJ0VU9BRzduY3d5SkU2bEpH?=
 =?utf-8?B?a24rTzlPWENkWU9QZUgzSXFQRkd3cjdsMEhMYzRKaXdkeUxMS3p2OTRQSUo2?=
 =?utf-8?B?TmdFRkdRU2FlZFVGb3N2bktXRjVqOW5KVURSTFgwczNiNkFWWmM4OFFCTFJ3?=
 =?utf-8?B?ajB1TllRYU9oUUNDNDg4QjR1VVpJMFA4cktnU1ZBZHIzMk1KTlBwaDZoak9S?=
 =?utf-8?B?VmtxVXJnVUdRaGpmT0U0VFFma3JTR0h5K2VVT3Q0aVlaOXdmZFV0VnN0c0Jp?=
 =?utf-8?B?ekJ5aHByWXRtOXFtMUZZazFKcFovWnlDYkJFNkxjR0ZQdzJ5SG1hS2dpVFo5?=
 =?utf-8?B?bXBKWEdocHNuUVRvSERkU2tLdFYrK1ZPTTI4MzQwaXpOaWdIY0FrZWRLb0Nr?=
 =?utf-8?B?ZXFMeVdxajU1MG9IMStvVTBqaW45VzQ5bGZUeGpvcjR2RzZCUkMvaW1NSjlH?=
 =?utf-8?B?a2hVK3l2L09TNmRYb1hNaWF5Q0RpL05sUUlUK3dSWE5jQVdlY01HRkpXMkpJ?=
 =?utf-8?B?ZFhyNkxwU003ZkRvRnhhQ3FlMHBnKytFVG51YTRFR3RCZ3hYUSs2T1JWQmdC?=
 =?utf-8?B?K3prUmNrZm03eE1FMTNPNGttY3NYS080MVRlSFNvR0ZDZmdkbGMxeStvMXlu?=
 =?utf-8?B?emJ6VGgzZFBpMmFHUjBaTk5TNkhnZ1M1c2c0SVpwRnBPOTN2Q05mRGNCWlFh?=
 =?utf-8?B?STZ2c0U0TTg3RmRrSjRpa3lVRU1DeWdDbUZiOWd3anpRT0VpM0FkVTNLYmFB?=
 =?utf-8?B?cXgwT0svWDBIUDlxcDdEZWxsME9QeGJ4VEVNeGRHUU5oRW52U2JtcW51cHk5?=
 =?utf-8?B?SkdmK3JKMHdnekRiRmx6dVZrc25TaHlGZzE1Y3kzWk9TQndVdEhNd2pMa1Vw?=
 =?utf-8?B?WVpDSEcwV0krSGdhaVFuTXV5WmdwcGQ5NWs4UXljQUcxSFNNck1rYjNsMzVF?=
 =?utf-8?B?bG1mcHdFT0ZNa1JiaEJYRmRBZVl2b1pxano2M0htVEladnExdzNnc3Zicm5o?=
 =?utf-8?B?Wk92SCtRS1VQSjBlUDdNOU5OVmU4eFdnTzVBdGk1ZGFrVzZaeC9pOEJoS3g0?=
 =?utf-8?B?dWo3UkJ0cjRSRXVUalhEb0JmRFZPM1YrVkpHZytSU2pWK3krY3NPZFNxajVF?=
 =?utf-8?B?cG4yUUFtdEZlZnp1bDV5d1F1aHgwdmc4UzdpT2FnMzh1eGFXRUhVTU5aa3VZ?=
 =?utf-8?B?WXVIWU56TTZQV2U0QllvSDc4b21TUkhDbGhqZUZHQ1J5Si92eEdLVmhRL0t4?=
 =?utf-8?B?L243OVJ5RFFmbzhYRXZkOGVhbTk5VVZjQTBSRFg1RTBSRGYxcWVIRlNhZUpF?=
 =?utf-8?B?cUw0VlFFckFFRXhPb2RkclRrMVE5MXFoVEoyMnFHaWJvTUJKWDlzZzRaakli?=
 =?utf-8?B?Y1YyT2hZdEp5THVmUlZ2ZUNlbmFsdVdLQXJxVjRYa1VSU1dVUG40anlOQUpN?=
 =?utf-8?B?eEJvdnZscGFHemgyT0FwMWkrdkQwM3l1OEVITjd5VWJqTmJHQ2hsQ2RPTjJ4?=
 =?utf-8?Q?e0qr83GphYpXeSjEtN73pxpP3ZCN5Jh2JnG0D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LDQj+5PSH3xdzeKcupTg+2b869fH5bgVW3Y7t1T4UJG+vyo664zieVuG0hR6KwBgQChdJBFaKmfHVh9srnczRfXxqKQQHdnlrWnRktGyUO/ytOIZYMHSo7og7rymCSW7gOtbk+fFBFg6rkVhQNw7TC0LfLndWv2EMHTOYNOiGX6lJBeDeSG+Ntb/9f9WzJ7bnodnYFijFsh7QEoPz5sriCBm4rX1d1fT8jVAV3ttYfZEbwhILt69GjUtGFBysKvUw5RfDDCXTXcXx1zxUDhTECfEy13LvxEc+QbJfinrg2szHcUrky1oEvp2wmUPsVf5vqVS3qfzdcB4rWVTb0n8rkkEgd17xvwIvBl+57OVwilBxgWhYk4Os92kVpxqNoisiJk1mdDmepu8pTNpEmyEbJk7P1lyHVvr1dOLtPDc/dM/j+FoCDWf6rqnOOeQadTaL/3nJbpOcoa7OC3dN2ioPWGG6JobLl0vkTYOqDxGx2aUnnYuuozI5WsQM1TsINqyluD5Q+snGBtVHOo1t2tQBa3pD2FzBhYyIa+CqoslSm24Qi3dnv9aJBLet6IBpaftsuYCwoMfvv7hwPSGYh3HixKHcG+YNT0fvkuPqvi4vAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e50ad33-69b4-427a-ed35-08de584a027e
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 17:33:22.7773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2NG/jaxRpdL7T1cJQUr8+GdKft7T366kvtcLSBhpcUoD3bHdiS5xx6JlV6PM833tIujx/ZdZ6TGcOFr7e4lZQMHibfH9LzLikkZIU8w3h4DuVBJiHhYXX0/41j2YpKx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4442
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200146
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=696fbc66 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=dZbOZ2KzAAAA:8 a=Kf_pOl3uJM1yrusWolYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gDsvgbHnBWwqO0lolghjVFfchVDwi3ow
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE0NiBTYWx0ZWRfX267kqP2MNnwO
 i9Oy3DMpVIStUZjyTyc48/cop19RnVUixJTuv2GOg68UAb8QZljIphl/u27kYL5MQCNlEtdK3uQ
 RLN7+QC6YYX+CcxzMAO6o8VlHiHQUMaoIFNl0nvEv+uqiOpT8WghpC62vRCR8v9jx7+QeHDiQqN
 7VAFqySKXRBBaLIwjoz+munB8GOt1gTOZ7n/Qaea/7avWxhaHqcAe1NzIOx3q0jhuMjDtstPxKl
 9yaC1DWTooRhwCDp34bnARThvmLUyY7gCBHslM2/2GxS59TEL0TWxv/rfqGzOEwGg+J5Hy/MqOR
 rC+SE968QCRJ62dYkPW7kGG8/Ci5Xf8b5lIsJT9DSrJFgTtS/sUPIvIkRrWfw+snlGAtkyNdGxd
 hd6+QE6f3WAC3ZNIZYcxSTfOGW32GQX9AIC9N+EDDtdW95rYllm+UcpMJv28uU/9FsRTREcF8QV
 TOlD+GskTa+j+akVaeA==
X-Proofpoint-GUID: gDsvgbHnBWwqO0lolghjVFfchVDwi3ow
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,qq.com,kernel.org,linuxfoundation.org];
	FREEMAIL_TO(0.00)[qq.com,kernel.dk];
	TAGGED_FROM(0.00)[bounces-11846-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[oracle.com,reject];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.onmicrosoft.com:dkim,oracle.com:mid,oracle.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel.dk:email];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshit.m.mogalapalli@oracle.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 7B02348EDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

I have a question regarding the Fixes tag for this.

On 27/08/25 17:13, Qingyue Zhang wrote:
> When importing and using buffers, buf->len is considered unsigned.
> However, buf->len is converted to signed int when committing. This
> can lead to unexpected behavior if buffer is large enough to be
> interpreted as a negative value. Make min_t calculation unsigned.
> 
> Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
> Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
> Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>


In the upstream merged commit:

commit c64eff368ac676e8540344d27a3de47e0ad90d21
Author: Qingyue Zhang <chunzhennn@qq.com>
Date:   Wed Aug 27 19:43:39 2025 +0800

     io_uring/kbuf: fix signedness in this_len calculation

     When importing and using buffers, buf->len is considered unsigned.
     However, buf->len is converted to signed int when committing. This can
     lead to unexpected behavior if the buffer is large enough to be
     interpreted as a negative value. Make min_t calculation unsigned.

     Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental 
buffer consumption")
     Co-developed-by: Suoxing Zhang <aftern00n@qq.com>
     Signed-off-by: Suoxing Zhang <aftern00n@qq.com>
     Signed-off-by: Qingyue Zhang <chunzhennn@qq.com>
     Link: 
https://lore.kernel.org/r/tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com
     Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f2d2cc319faa..81a13338dfab 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -39,7 +39,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list 
*bl, int len)
                 u32 this_len;

                 buf = io_ring_head_to_buf(bl->buf_ring, bl->head, 
bl->mask);
-               this_len = min_t(int, len, buf->len);
+               this_len = min_t(u32, len, buf->len);
                 buf->len -= this_len;
                 if (buf->len) {
                         buf->addr += this_len;


I see the Fixes tag documented is "Fixes: ae98dbf43d75 ("io_uring/kbuf: 
add support for incremental buffer consumption")"

I think a more accurate Fixes tag is "Fixes: cf9536e550dd 
("io_uring/kbuf: enable bundles for incrementally consumed buffers")" , 
Reason: Commit cf9536e550dd243a1681fdbf804221527da20a80 is the first to 
move incremental-buffer accounting into the new helper 
io_kbuf_inc_commit(), introducing this_len = min_t(int, len, buf->len);. 
The signed int here is exactly what 
c64eff368ac676e8540344d27a3de47e0ad90d21 corrects.

I am asking this so we can correct the vulnerable commit for 
CVE-2025-39822. Currently due to a different broken commit 6.12.y is 
marked as vulnerable [1]. If the above new Fixes tag is correct only 
kernels newer than 6.15 are affected.


[1] https://lore.kernel.org/all/2025091616-CVE-2025-39822-454e@gregkh/

Thanks,
Harshit

> ---
>   io_uring/kbuf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index f2d2cc319faa..81a13338dfab 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -39,7 +39,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>   		u32 this_len;
>   
>   		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
> -		this_len = min_t(int, len, buf->len);
> +		this_len = min_t(u32, len, buf->len);
>   		buf->len -= this_len;
>   		if (buf->len) {
>   			buf->addr += this_len;


