Return-Path: <io-uring+bounces-10551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EC3C54DEE
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 01:02:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5EA6F4E0462
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 00:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89E1C141;
	Thu, 13 Nov 2025 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KEd9i8Yb"
X-Original-To: io-uring@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D563CF;
	Thu, 13 Nov 2025 00:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762992143; cv=fail; b=YbaNASeqy8CASZzJdFp8ZtHzR+CapSqCxuMEHt/pu0EPeMG+ChIVf9sL8Bm+dxzZS8KwMUTwy3SFml5ern59bKoPVp6nIXA6r5RsoCCc/sjzgO6S9Guqgcjh3szwIQE7MhwIcqOdwC3l5fuEf0a2CMRTDv1eS4KNbMgBNkYVx3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762992143; c=relaxed/simple;
	bh=53C4CiJ8zTGH11R8rtwxhuHUoHGlVb2JCX+K5wSk8lw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c6hDXJddHM7jMD4GCZELZR78tApQ4uNvYMmNlHdnStnvSxxyEjlTuNnyMZfEu1e8kGs6NinX8cLO/QCSFQ8o7Ofjz/i+6/ck3oRZNDDogrzvqdoIWM7HYnDYtkw5foEJ+t9xwamH1PzD+rzJACseTh4aTDl1DgDnAxo73LXFA3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KEd9i8Yb; arc=fail smtp.client-ip=52.101.48.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VrSM6JyN9Je2abNv1K/587Xk0Vov9rsvZ1gFjVxAnMSbcFJPV9od6PkmZWfAR/Tm0+lbRFhn8q++VliAvIv6V0SScYXmm9ZA787y2NvaPs5bQvKDKcmaDuPZ2EyTMdRV+XpSouPmNlnlC0152SHuc+nNs4AlbONIqzVRMaAyq1n1BB8Ww596VOAkdh8hYL1Tl4yjmx9qwrFhw7uO9HH3b2cyL8TpJgrvzJ3NLlh4nd5S6sJpeumaN9mfA99XXrZp/o135350Iq0C9XP46d56xaOgIP3xTTguiwNja8DRg2WAVEHV64XmbAMGBkAGaW9Z9IOOtDKzD7k4V8VfiuMkbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53C4CiJ8zTGH11R8rtwxhuHUoHGlVb2JCX+K5wSk8lw=;
 b=avLN49inRk6QRkLw1khxoOSYuyHTZgGxkvsPbB2nHNyAMff++jJv+Ad1l7N0woQIYcc6o6eW7urgPE31ikS8jw9tFIeh3X0mGz3hCVmOjF3U05Kqg7Z5P/3JmrGMXWVdmsery+wHNGcaKxrX4DboPm+WUKJf1OO2usptqTuzPHNcfmqlrbe7A+Aj8HLABpKzn2tFyH0mzbXj1gMY/sddJ1GuhM2xSTkix8DfnCpfdG4PbonF43CJX3M+HF1jjF4XwhrMb1FzLEiQCZXn9ayKu/4Tghq+2YUPmHIh3EpC0OEHER9xNHNY0F5V1EZau3LMtYEtvsFKVHodVhsf5TvVcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53C4CiJ8zTGH11R8rtwxhuHUoHGlVb2JCX+K5wSk8lw=;
 b=KEd9i8YbUhrbLBxFn8gyv0U24j9AAq9GcGyDzCWdSEYi6O7RBeKQs0GtvoREkytAquAUyhhFPxVKlYW9hg4lCjG+9mS6UrrUNuG1J1uWu58g/Lt9pMbu5hUQzHIrrV+ry8iRGApgMzCYcxHwT5HF6+rLO3Ctrp1ZLcm7R6F+AjafbVlhCnVn4SX142aSZvKawsucOygqrLsGYsx+KtsfMCVnAcMIMJvdjIoOeYllBAReaWw9bSUDNuiFYWPmA+HpAk02WIhy5m4Ss0vE+XrGVjCV2d/TOCGcA2rJcuOpyh7sx4BQksTPzSUJDYxIU9zzmgC/rS/7tc7KVDBwGcNYXA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by LV3PR12MB9185.namprd12.prod.outlook.com (2603:10b6:408:199::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 00:02:18 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 00:02:17 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong"
	<djwong@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro
 Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 2/5] iomap: always run error completions in user context
Thread-Topic: [PATCH 2/5] iomap: always run error completions in user context
Thread-Index: AQHcU6Uq8BLZ12LmdEOoQymlgtgGlLTvukAA
Date: Thu, 13 Nov 2025 00:02:17 +0000
Message-ID: <82ea5d47-1270-4657-bb61-d2aa62df15fc@nvidia.com>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-3-hch@lst.de>
In-Reply-To: <20251112072214.844816-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|LV3PR12MB9185:EE_
x-ms-office365-filtering-correlation-id: 8ecc13f0-cb87-444a-7042-08de2247e87b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|7416014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Szh1djhRNGtqTmM2dW0zdnVrQWpJdVl4ak5vZjE5b2lIUG5Sb0Z6UlJscTBi?=
 =?utf-8?B?OWd4UVNZTW5EcGdOUDJhWVRUSzBYTzZHZUVLMUdwaCtZaHMrNFllb1cyVHF0?=
 =?utf-8?B?ZnFKbkkzZW1VWVQ2ejUxQnpNaEJVR0dubS9jZjFjd0xDRm1SSCszaHdlSmRw?=
 =?utf-8?B?R1FWYlIvK0g3b2lpNmtPSmhwZURwSGdUMkxHd3BXYnpiSjJPdTIyY1dQQVgr?=
 =?utf-8?B?eHVhUGE3VkMzREJQME5vREdlZEF3eVZCZWdzT09oTUVVR3dPQTJCOC8xN0xi?=
 =?utf-8?B?Nm11OFhhcWtDQnZqdzdnM1pINE9WZUwwelV3d3lnSmFicFJYUlE3cjZqdWMz?=
 =?utf-8?B?Mm9scS8zMTlzc1M2RHpaRkFqL2VkNUdBRGtvdHZaSEZWN1gxTlBvSFNVYkUx?=
 =?utf-8?B?UzZoVmpPOVorVitZNzIvUFUyY2FQY21mRmJTc1l1QmxiRmJtUitBUDRDQlhB?=
 =?utf-8?B?UkdPdlZwcERzZkN4Q2pDQnlDVmNLUE44b21XdWx4UVg3aG5jb3U4OWVySFR0?=
 =?utf-8?B?MjFJQldDUHlzQXdmOXlQc3JqWlgvYS9sRENCaEFrcnFyd1V2QlI4NVFhcTZW?=
 =?utf-8?B?Y3VjVThnOEJDUkVuNGpsS1JoNWNHY1pRV0ZXVVRJaFBtdHAreGhJSUdnU3FF?=
 =?utf-8?B?WG5aMHRGdXhVRUEzSW9wYlh6SmNPRGduT2tjTTNFRjM2Y1NoWFpkbUJWLzBo?=
 =?utf-8?B?WHV3Nk9CUkcrbk5vckdoMlV5RE9SZ21pWGlzR21mcmFNNGc2RmhMVG5sOHRO?=
 =?utf-8?B?VHVuNXF1MGFpdlhUQUplWmRvY2h2Y1dnamV0aUNiZVNzTGRIdmZsREZ1OXA4?=
 =?utf-8?B?Mi81SFV2bVFGOHEvMVpMK3ZHNXFWVlJYREVkRXZLZGJ4VVVXb0JrWFM3MGZ5?=
 =?utf-8?B?U2V6b2VVbFZ4RnZIRThGUUVJZUNaVGpwclFwQlY3TVBPZm1ZMUVpbGFwSERo?=
 =?utf-8?B?ZU8wMjIrdzJiL3RZN1dISGI5KzFZU0tiZEtOdVo1Snl2NnAyUkZST3gwSHZY?=
 =?utf-8?B?UDNsUlRNYloyVjJ1VUlTVkhEcHArYlNjaXBWekhiOCtWdjBVQWJnTmlJUjZE?=
 =?utf-8?B?MEZDczVSYU00djEyaG1YKzNKTCtiTlo2S0o0TFRNN2JNM1JENVMzUnAxYWNn?=
 =?utf-8?B?VXYwVmwxZDlSSzRSZ3NMcE9RRk43NWl2aER0ZmxCR1FOSzlLYzJoa05PUXpv?=
 =?utf-8?B?VFpSVU1GSTN6Vkg5Tzk1S29Ia2pxMDlOQlZLMkt4MzFuUm9XMnNicUZLRkkz?=
 =?utf-8?B?WHN3dG9odUFsblg1Y3BTWFIvYW1hQmU4ZFN3dHBwaCtOUXRHZzZTeFVhR2JD?=
 =?utf-8?B?TnlTSktQWmhITjFpS1JWYUJVWmFXMlFVT1lJUlB2SWpVaTU2UDhOam1VNUQr?=
 =?utf-8?B?QkRQdXhMT0hKT0o4aG1HSHk4ODRZNzdhR1g3UXp5R0VQSWorbDc4Qy9uTG02?=
 =?utf-8?B?R2NuelZ6Snk2NjJkNzRtMitmbmoxYmhvN3NsNm5nYXI4TkcwQTlnYVl5bXY0?=
 =?utf-8?B?Q2h0Y3Faa1NUYW1vNjdTSkJtVXdiUlBvdVdvWlRSZjNLK2NweWRIdjJnUWJG?=
 =?utf-8?B?RUtmeGM4Ni9WWDhFLy9NY0JvaFM0MTkxTFVVcllyS3VjVkpWT3BLcDV0aVZ4?=
 =?utf-8?B?RktLOFB1OFRzdXJ4MGFwc1JTSFovcHYxdjRvdG9ET2hlUUpXelUvUHJINVIr?=
 =?utf-8?B?QUJGY0tiamM1RHl1UXNsbHlXR3hiU2tIQ3krUGVrcDNIdEV5cks1RUpsMmtr?=
 =?utf-8?B?YVJ3dFM0ZnlrRGRnY3Nqa0tnM3JGbnFyR2dtbnEwcXBmbStGUlpIb2NoeWNX?=
 =?utf-8?B?bktOVVBScTJNRWRreVM3RmZoSEkzbGJMZS9jelJKTkM1ZGQwR25Hckw4SS9L?=
 =?utf-8?B?S3BReDlKY2UvNm1OL3J3N3pIMHdhd3pjVHI3Kzh2Zm1DSHJDSWIvdk5rNVUv?=
 =?utf-8?B?QXBFYTFkb2crNzAvNDdVc0FKMWxFbFhHL2dLK0lXZGM0ZHZtckNVdHUzSUVE?=
 =?utf-8?B?enIxSlVOaVpGOGpDVXFuenRoa00zWEpEMG55NVpqdkhaY1JkMml6QjhYRWl3?=
 =?utf-8?Q?U1lTCF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MUVrSmVmYTJ5QU9TYlFDblpPVW5hQ0ZzemM3eFZFV2ZlUHc5OW11MUJvNnha?=
 =?utf-8?B?akwyVXVGM1hSdVZzaVY5S1U2UGFicnQyVnJFRzhRdW9yWWxBaEV3OVA1dWtD?=
 =?utf-8?B?cmNpUmtRYzhrcy9rRHJyWXVDV0FETGViWm14cWR0bU10S3pJZXhRSzhtSmQ1?=
 =?utf-8?B?UklGN3EveHJVWVcyb3plSXNJNEZ3ZFlNdng2WEhxR2lPOFA4Ykoza1BSSTd1?=
 =?utf-8?B?WFptSWhMYXhuRjREU204NFNPY0kvRUw1NXVzTFVDWTlqNHliYVU0QVh1WnI1?=
 =?utf-8?B?OUwvMmN0czFDQjlVY3dTWkI1eWxySkJwZStLbHhQdmhjS3RjQU9EeEhxNUtT?=
 =?utf-8?B?Mnhnd0RlMUpvR1BlQVY2NUJVQ3krSEcySjlLRWRkNkcrY0RjMit1Uit6c0NK?=
 =?utf-8?B?UWNGd2FqMDYveWdiYTI1OXo5bVJ4TzFLZEU5MXJ6ZlplemxLWDBGWnVWY0oz?=
 =?utf-8?B?WDh1SHkyMGFwZVdhcFVwdTV3R1JVc3lzMEJ5TEV0bmcwenIwV2VuMStodEJU?=
 =?utf-8?B?ZnJ5Y0YvWU9EYURDREtYc2JNS0pTc1g5RFcxeGxRbENIYUdSeTI0NG9WRTh0?=
 =?utf-8?B?RCtpZTZJbVdKeW1xRG5HeW1sdDlRSWVQT1pORzZSMUxURlgzd2lIZU1yT01Y?=
 =?utf-8?B?UHFPK2h1WWpqUjAvdG5ka1pJU245RVZEY0FsMXJuM08rSk5CRW10Y20wcUV5?=
 =?utf-8?B?NGFpQlRVRUt1RmxVN3lOTmxVQkNYWStsVW9XY2pZcVE1U1MxbU9Dc2c5ekdq?=
 =?utf-8?B?aDlFRzVmWmRHYzJobFJvbTIwZi9BSWtVQ1JFczZvWDV3U0l2dWUwTXhQY2Vo?=
 =?utf-8?B?aHpTSVR3UTZHZTNiZmtvYjRaODVtVGpvRVJkOGEvQVIxQzA4azlZWGFtUktv?=
 =?utf-8?B?ZUtyMTBMMGR0bFQyUlNuWHBkTUdobksxUTQ0ejUybmNCV3RDdXlXaVN2anVz?=
 =?utf-8?B?V29hOTJRNWpsa05GT1d2cldUNUZDSEtSUDEyQjQ3TnNFdmtuYVI4NCtmZ05h?=
 =?utf-8?B?ZzlYNWJFeVRvMllabFNDZCtXR0U4YkxzVU5KU2ZicE41dkxhbGg5V2dFenBO?=
 =?utf-8?B?TmdKeFluL200aFpPM3BJNld0ZjRQZjR6Z3FqUVRDRlhtbVZML1lwaElkSzBH?=
 =?utf-8?B?NmZ4SzFIMEFzcFhtOFpSeVVxckFDcHV5d1g4Y2Z5OWlhQVpGdEdIZytXa3BI?=
 =?utf-8?B?ekEwb2xETXlYQXJuNmZLQkdyNjlHNkV3QkNEaTZ5bVE2U3kxNS9ybjJ3L3Fy?=
 =?utf-8?B?WGlISFJFb1RmLzR6bklYNkZxSktKVjcrYWhjSXp2MGZZVCttYVhqbFhQYjFM?=
 =?utf-8?B?K2xDc1J5K2YrcXhmL2UvMi94emhNN3RHeEMwM2FkZm9WTXozZ2x2L1R4NVU1?=
 =?utf-8?B?QVBPRG9PMTJPRVlFVkNzK0hTdWRza2pPU1EvbXg5M2lxckpib2lCNnpINmli?=
 =?utf-8?B?MnV3czh4TGtaZHNjb3hZR2YvbkJncno0QzM1U2xrMktDK2pKY1hxTlhYMmtn?=
 =?utf-8?B?YlhveFk2WEpkZnpjMjM3R1djT3FHTE5uMzdyVzZCQnRIVUFqM1o5ZTVKdk1P?=
 =?utf-8?B?b0x6V1ErL2Q5elk4ZVZEeGdyYmhVTzRMMEpEcE9aZ1ZiUzRmemFONWNZTUNG?=
 =?utf-8?B?b3RCSTZSM2RSTTkybVhvVzhFQzdDNjRLR2ZkVDdUVi8xY2h6ZnRsY21kMWtk?=
 =?utf-8?B?czhGL1IxY2lpRE9BbnpKS2V0S3kyTFBGOHNhQUg3V0hqb2xQVmFVVVkraTlm?=
 =?utf-8?B?VzBOb2RTdUJaeWxndG0wajRpOVJaM0s3TWZHUCtlSjh2bDVsam9JZHZLRk5n?=
 =?utf-8?B?YXlUYmFQMjBlMHM5OFZvcXJZUFJTMkN5Yjc0Q29aZ1JmV2ZVY3BZcWROSHg4?=
 =?utf-8?B?UnZPMmZXQU8yWDNqMjdla2RVdUN5L2NKV1l3TVU2dFJ2OWFXU256ajYyaTJG?=
 =?utf-8?B?SXV3Z2MyYmo3enk0eGpWUTYrVHQvZ0NQMnladEhxbEU2UHlzU1BhVURUOXZV?=
 =?utf-8?B?TVk3VTJjSVFHbzZJRzNxdXBZTHBYRGc4UnRTYm1TWlN3a0lKamo4WUl6QVFZ?=
 =?utf-8?B?S25YeGNja1NZSEdhWWNyNWZhSlRtQi8xQUtEMEIwRlpOeXdxYXZ0U0VLZTJ6?=
 =?utf-8?B?Und5TXlNcnUrT1grZC9xWjE5UERPWFpsRE4rbEY0bVdDR01NVjdaYmZZVGFh?=
 =?utf-8?Q?zejMfQKdwQargt8rew6SXEpjlF9MX7eYHdxwnVXEC5RE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F72AE22FA32F7D4F8145FDA02733A869@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ecc13f0-cb87-444a-7042-08de2247e87b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 00:02:17.1192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTPBrHgTPuifetWoOPm6HmLeHZ2zzac8yMjDRW4e3LBDtgXpGAvBUopOmS54DGrMxR/x0eKba91j3azfFDyckg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9185

T24gMTEvMTEvMjUgMjM6MjEsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBBdCBsZWFzdCB6
b25lZnMgZXhwZWN0cyBlcnJvciBjb21wbGV0aW9ucyB0byBiZSBhYmxlIHRvIHNsZWVwLiAgQmVj
YXVzZQ0KPiBlcnJvciBjb21wbGV0aW9ucyBhcmVuJ3QgcGVyZm9ybWFuY2UgY3JpdGljYWwsIGp1
c3QgZGVmZXIgdGhlbSB0byB3b3JrcXVldWUNCj4gY29udGV4dCB1bmNvbmRpdGlvbmFsbHkuDQo+
DQo+IEZpeGVzOiA4ZGNjMWE5ZDkwYzEgKCJmczogTmV3IHpvbmVmcyBmaWxlIHN5c3RlbSIpDQo+
IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4g
ICANCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2No
QG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==

