Return-Path: <io-uring+bounces-12099-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDFnONXZiWlFCgAAu9opvQ
	(envelope-from <io-uring+bounces-12099-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 13:57:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BBC10F402
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 13:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5DB2030086F3
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 12:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E860371063;
	Mon,  9 Feb 2026 12:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qbLFwQT3"
X-Original-To: io-uring@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB2533D6FA;
	Mon,  9 Feb 2026 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770641693; cv=fail; b=UH+8RkEhswscXtItcol3rJAmqEK74i5RUm1tL81EjTcoJZVv4QtYuvbpDZfAUhz/9m4NKrucWL/eibaUKDu9irnFWxZqnY0+eKizigvfuWpQZvGU2dZXcO/xZTAs/vMcvGAbcMSRLstJqv8vEl4yKcitw9yDe//tuQI85F/4wcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770641693; c=relaxed/simple;
	bh=lr8QO/JQkVTtx7tAlDBcrzhfEzQDl+UZEJcecq6dHWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nB4mVDTX0fSV0UuoLb9OuigvNHNZuhY5yx2v7R4NLG/Mwwt0OVvwXfSTw/hVXAkgYC7K568yaK/0pYG52kpJMbO/fq7OG3Psk4d/uuamFCuVlD8pyjeqMOyydGupOLnVNIx85UT4xs0C4y6MLw4UzmoSNY618Xri9kTVKsEAOUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qbLFwQT3; arc=fail smtp.client-ip=52.101.85.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lr0WLEOZIpidrF5H94I2LXqM85oizkWqna/F0DEbmHVFILNYy5KBSoRt2vwM5OcCztReMwP6J/8yww4zj7YFlbmYW+KrMYwgw6QTROgbyfDLoZT64pm5dFxqjuJ8lRu2jlFnvgp9fi//gJWqaGj9cOZk5NI3O6jRANiuWoANzgSo4Zxc7ZAVBmNEVqdobKOzV7CDClc2cykXL4vX20taJBKncJ47qu+C0O3PAPYgHZFvn43g5ch+tmJOcpVKxbDKZP2ThVI6EnBpOCbjbFJxqDFadW3uMqHkiowoZht92AJitvJj8GvB0usskLXsb/M7NCcKrByOVqH8Ex2QyXYWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orrp3tFHsNhkD42vTRj08Ir7vzIrTb1sWQ/JsZKqcVE=;
 b=W6Y4poGQtzmVOqPBoZIZ/eEKY2CvHEUKkrMNKDWGgHzTWFZfeD0+/V/V5ywsSQMjVn6LA8pHzUwvRpXjKulP97miXajEGkfX1ZAw3WNUfymxQYdxSMS0z2NW8TfzWIX4mR3fQ72NIPxKAOfEV9MM7iy9gbpZ+cJnBykOEN5DfN+DmTHXG+LlYe6MjkhPulKfll6u9WdwhErAwSRhUnavmDlzFd0/RZxEQa4ztnWrnuZosgzAXAsrT9T3InXzJjGQ/X010Wj5sMoH18Ezywuu6cmC065gMgisL3GXlbH1nkbsZXwC6vTELiR5gIiyTizb7t21v68gpSBsUHRIDBhiYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orrp3tFHsNhkD42vTRj08Ir7vzIrTb1sWQ/JsZKqcVE=;
 b=qbLFwQT3aQblpcuNaIE0NSq6AYjZlL1wzV8Y2KOhiJC1JFusqh+WhJ4Ojn5fGo0pnV2rvf81m2MlnBZbwpFFCKJxUzBAPGr1pvDpGlbS0XY8ZimqouwyyzsGbeQWFYCpuHG9i3hPGtmdnP/HBXPBPsIT6SvXnBXa7LMdJR6DvUYY/CBHpWMfk5GcTBY+lMxSUB/llpPse6rllJ9RbWsn458A58+99Y43U9blJ1Nnr1VspewTDZzKx7RJCALLBdiDai3tbkPsL5u4L9vCK9HX+yKfQdpgixzYz6AT/ysibOytOqAN+a+DZLqkuqIcHMJP358fDYG9iA0/DEIok+KaLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6648.namprd12.prod.outlook.com (2603:10b6:930:3e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 12:54:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 12:54:50 +0000
Date: Mon, 9 Feb 2026 08:54:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260209125449.GE1874040@nvidia.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <CGME20260206152216epcas5p293f71122593a41954f8a92bff170202e@epcas5p2.samsung.com>
 <20260206152041.GA1874040@nvidia.com>
 <4068f00e-e84e-49b2-b1ac-72180ba19558@samsung.com>
 <b69f230e-717c-4ad4-b086-ea480cf39b88@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b69f230e-717c-4ad4-b086-ea480cf39b88@amd.com>
X-ClientProxiedBy: BLAPR03CA0123.namprd03.prod.outlook.com
 (2603:10b6:208:32e::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: 40c3e51d-8deb-4453-3494-08de67da6962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDVPM3hKbDlDYVR4bDdFRUxFS21XVzdUektlM1d1eE5ycm83VGdNQWV3dVNs?=
 =?utf-8?B?UFNadis1R3YxVjZlME1XNU5zYUQvakxQNGlYbWRLSFpkNmdrcmRHakZyeTU2?=
 =?utf-8?B?V0MwanlNT0ZoWEdKUnR6eWFTRW9QV1FHTCt3dWxjTTZnSVpoejFhOVNYMmJO?=
 =?utf-8?B?eWNaZzBLUGRONnFJc25nMG4xUFExZ3dNNHlZTGJjM1BCMWo5dXFNRDFtVlVT?=
 =?utf-8?B?NGUrYmJHQ0k3TkRYNDRKRFhSeXBrMldEcGZib0Z2a3h0T2ZqbEZWWmFmSXFr?=
 =?utf-8?B?T0svU2FPOUlkOE8wQXpEUUNkWGplRzk0RzZkR1ExZXNlUkhtNnZlZWl2aGNS?=
 =?utf-8?B?OFovbFB4MmlVUnVOekNLK1RjZTFpeVFIaHJHSmFSTjBJOEFhMnZ5TkVUWnh4?=
 =?utf-8?B?Q0ptS29DdVRuU1pkTzFnTFdUamsxSjVOeVVKMFRhQnRSVmhQb0ZPVlR5Wnp3?=
 =?utf-8?B?QWgxL01lUnhSaEdWTEtBelFEMmR6T0RsQ25kSm1jeXJ0TUxaeEo1UkdsNnVK?=
 =?utf-8?B?V2t6OUh5bXVCTVlEbmVTSWhpT3lRRjNQUk9aaGttbHEzZDZyQXVkYXhZZndS?=
 =?utf-8?B?clloRitrbjNPbWN6ZzVybGdxQmhsb3NXMzRDUHNmamExcXRqSVA5dFJ3d2Rn?=
 =?utf-8?B?VURnRHNqSzFaK05oeTlNUTUra29lVng4TTRQbVhNVWhFYW4xNGVjZG9TYkVP?=
 =?utf-8?B?RTIzcWxjczZVV1RrNmtWdWpiZ01jVld5QzUxV2Q4azJTbCtFRXV1c0FCTUhr?=
 =?utf-8?B?dVJ0MGI5UWRTUEQ1SUEwS3krTlprK2pEZVEzRWl2QWRlMGVCUzdaZE5iRGM5?=
 =?utf-8?B?V0RVbUIwYlk0ajJWZXFrM2FEY1RXS0lsQURMZVpORmVkS1I0bS9hTWl1eFEw?=
 =?utf-8?B?MkRJalNiVkhPalg0MDhyVno3ZGFFb0xZeWRQSkhmZWVYMlVHbzRTNlF6MmdT?=
 =?utf-8?B?Q2Z6bEtUdGF0NzBiVmVWWHVxV2w5TWhta1pIVC9JYnVlVjkwYjA3ZDU3amo2?=
 =?utf-8?B?Q1BFWFJRUWplSEt1T3RNU1hLTzJKanlCSC9xYkZCTDRRRXJ4WklIRVNJczNN?=
 =?utf-8?B?T3BON2c5anJLa0drYzEwelE4L3NlRnkrYThnLzh1Tk9HSmtBTVhITDkybzkx?=
 =?utf-8?B?TkdXNlNKVkVCeEZKSW81RDRubFU2OENXZ3ZaTCtpMzhDdFNHUHdOM2swQTZW?=
 =?utf-8?B?S2lFSFluSEY0NXh4ZGVhaFEwa2tZTjcvYi9wK2dDVC9iTUY1Vis5TnFxOHdK?=
 =?utf-8?B?LzhoNVp0YlU1SjJOOUNxQnNhYVN0Q2doeXZ4R3RpUDlEMWJsc2VKTUsxUEZo?=
 =?utf-8?B?UkdVYkpRYkI5RUxzMHBBdWwzTzNtdUZzR3RlQkFaL1FXanlmRVQ4M3VDWnR6?=
 =?utf-8?B?bEZsZFk3WHhjaStFUnF5WDFkbTZMREMyODFHKzJMU1BNUklxWGtJQW1LSEV0?=
 =?utf-8?B?L3YyakdYZ1VrbFBkYm01ZWNLNWhQbHA5YTB6ejJPbGg2SUpkRERiYXdDVExv?=
 =?utf-8?B?ejNQZnNublA5amNlWXlsR0F2TFB0SHlid3JIejJVUDkvZWNMOXpNMzBRcFps?=
 =?utf-8?B?YUp2U2ZmZWh1TFhBNkhZdVhLTmtDa1Z5cGJENTNxa1JZMjIvTlhHR256U09v?=
 =?utf-8?B?VnhWeFZKRXFQMGRGY3U2SkJpTTRwaE5PQmRrem1JNGs4WGpzZ2lwc00zQkgy?=
 =?utf-8?B?N1VCNGp4WHJzcmU1eE9zTmRhQURZcEh4NnRwa2JRRHFGeHQwRnh6L0JUdVY2?=
 =?utf-8?B?TFZ2b0ZJTHBVSCtOb2tFelRZNTFiWHVOZTNlUlQxNTh4MkdnNENGeWNtZ2Zh?=
 =?utf-8?B?eityK1VBNjg1dllRY3kxSEdHQTdhVzdPMDRtc3pYNVhJMmZtQUpoZVVYK1hq?=
 =?utf-8?B?dXRoQmNBcEtnZENGYnBLUWd2NCtINkM0aHJFa05kanQzNkJtSHRqWVdTamhQ?=
 =?utf-8?B?N256MStrS0wwaHg4NmxQdnI5TGdkZzBqV2QxTFNBM1FYVlhmRWI5bXpMSUFM?=
 =?utf-8?B?dkE5L3hDaHRPVzA4TkFqMDVWN3phdEFHUVhoMjNnczBzRFVPbk9adllQdkFy?=
 =?utf-8?B?c2dyNkJoK0hoNlJDQndDTjQxTm5lcXNPODd3bjZuMzRsTCtQMEYvRDBOb2Ri?=
 =?utf-8?Q?0nH0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGtsMmpEbU9kVzgraWF5bEw4RWVNck1VU3huUFNmT1U2YlpOYjlOWnd2UnBJ?=
 =?utf-8?B?YzhFRDFvNFZzK1l5MnA5Z3d6Nm5LRzNtTTFZdlJ2cCt6TWsyakhMS3gyeDBu?=
 =?utf-8?B?RGs1cVYxc3lOcWNBUlJ0b0haRWpBd3dKL2doL3hPeC90bFNJaG9FcTdyZDVr?=
 =?utf-8?B?NUJZbDdSNWhrRFJtZWtwRnlsK1dXZjc3b1ozVm5Ndm1lY2UyNUM2Z0l2NURr?=
 =?utf-8?B?WUFuV25RdmJHQkN0UTk3MnY3d0tiSEpLRU9WNHY3bWJGNmxZRjBNNEYyTGR4?=
 =?utf-8?B?NTlwaDZveXMrMllrOHpubGdnMW85ZWFJSmx1WlZ2b21vSkJNVGNZK3REVTBV?=
 =?utf-8?B?NC9kLzJmSXRKV3R5M01OeVBab3liK1FCZDlISzl3MktiRWZ2VHJwaUljWm5S?=
 =?utf-8?B?Vkk1SzNVcFZjQ2U5N0xBWlhtUlYvL2ZWelZxNS8wVmcxQ2pkYzZCV01SWW1y?=
 =?utf-8?B?S2dBQXpoNVRndW1ob2dkV3NaaE5BSHR4ZWw1TFdpZ1YwUFBoNlhMQ1RtcFo0?=
 =?utf-8?B?VGczbWRNUlN4WmtyS2t3NEUrNW9xNkt5QmZLaThFeng4WjNpdGllVlZIdmd1?=
 =?utf-8?B?aFhUOHZ5K3RHUTRITWk3RXY1RUtCVjdPQ1ZYRllDTzgrN0xWWVFZcFpaVmh6?=
 =?utf-8?B?OEdaQnVhVW5Mem1qZnN1MXVtaTl2Uk56enNSalBqYmE2YVJDVHBqVDhvbVRX?=
 =?utf-8?B?a3hrajJ5Q09WOWxDZ1pHNWhEUDd4NkZPWUo2VDNJb2phK2tzQit1TnJ1UWc4?=
 =?utf-8?B?WEMyQ2tLamx2RURWWEM1eVl6ME93OG0veGZVN2hJeHdweUNuMXdZV2FweVFJ?=
 =?utf-8?B?SlBHVWRRQ2JZMlNFVysyMkhJNGZ4NERiTGlkU3lQMjZTT29OVXdDVm43UGI3?=
 =?utf-8?B?OFpRcE5XYzhleVcyR09WTDRLeEszWTZ2Mk1VK1VDYTBjV3RaL3IvWE9PVUVs?=
 =?utf-8?B?cHN3YnkrMWJqa05lSTNYNDVGMmY5RU54SXp0aVBuRk5JakppbXQzS1BoQkVN?=
 =?utf-8?B?K056eEY4S1EzZEZ2QkI2MFl0bE91TEJxUG9FNmZ5cTB2UGVYS0NzWkpHeGJi?=
 =?utf-8?B?VkxjZkV1ZmwzTzFyZERsSXdtZHpYQlJhK3gxaXh3c25yc0R5U2hZeCtSMloz?=
 =?utf-8?B?dXVXWnZDaHJGN0ExSktvTjNILzJrMDEvQnNaMi9SSE1HcXF4NXhTS2JEbm9Q?=
 =?utf-8?B?Rk9KZUx3Uk14NjBQbDhHbG93ZWoyYWZxaHVDVXduNTlNdEV4V1JWRmErTWx2?=
 =?utf-8?B?Z0VTYTViRitSUytlNFNtMy9xSnB3aGZ1K2VNazl5SGlxb2FUdFExWklUbVdx?=
 =?utf-8?B?Y0ZzVTU5QjgyQlljRDlTMzA5VG51a2dYY2hiaTBaQ2ZGQ1oyVFZvVG5MWlQw?=
 =?utf-8?B?d0dkQlZyZ2dHZS9tOTN1RnQ4elE3c1RSL0lVdUdxYzN4bjJXMFpPMEpyUTFk?=
 =?utf-8?B?b2tnWEpEYjRDOUVFTm1ZVEJ5OWFYUEU5MTl3dmo2djlnUzlDY3pVWDVPa0xo?=
 =?utf-8?B?UHFzUEFnZVFnRW4xZThFTkJtYWxsVm1QSUFOTUdNNDJqUFlGamtCVzJaUVhr?=
 =?utf-8?B?NENqUWpmOUdsMGpUbVdJdkNqTkt3bUFwaiswUWJFemJXelQxRjNjWjhGMUlZ?=
 =?utf-8?B?UmVVaHA2WnlLQnVNU0VCTjlvK25zNmIvOXdZa2ZVQXV3aDVpNGlxb3JVblhW?=
 =?utf-8?B?eGIwamptV2VGczBHT2k5dW9OcE1ObmRvREFBb1Vydms3ZnM4VE94VDdjc0tU?=
 =?utf-8?B?TTl3dEFBMy8rY2VQb1NRU2tkWEJXdUxWakxGVTFpK0xIOWZ5eHlRa3c2YzJq?=
 =?utf-8?B?Z2lNVVRoMWF5dHE5bmpIQ24wNnZNTUtDSGNxMm8wbU5Ha0FvMk1QTzREc2hu?=
 =?utf-8?B?TjdHQlN2S2YyZ1hxV2U5K3dDVVlRMEllQlFGNFFWVzZMclJ2Z1hjbTVwa1lX?=
 =?utf-8?B?VVdnZXU2QzNIWEpKYUh3NzNYNmV4UTN2djJReU55UDVaNkJqVGs5NkJKTVV1?=
 =?utf-8?B?a3lwOGdWYjdONHlVNnZTYkwyd0FzbHpMY2JUQkVNWEtmMXVJTzMybENyZW1K?=
 =?utf-8?B?ckxBVzVxcGZ0RlRTSjgrWU41SmIwUmtWK1lWRWEzcUo3YXVPMGtidGFLbUNB?=
 =?utf-8?B?R3FONlFKdVU3ZEZtbWFvQU8vWHA1V3J2VFRWYmxrTUhqa3l0bSszZldWc3Za?=
 =?utf-8?B?WXV6dlpMcXZMK1VDUkoyWTNiVHl1bzZiVndpaTduTmNza01pVGU5QlVRRmE3?=
 =?utf-8?B?TkM1QjlRNTZQT00xRVNUR1FTOWVQaXBFTDEvZHR2Z1FZeVJYQjdTeGswS29S?=
 =?utf-8?Q?1/t82M7ArpPBslJZAD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c3e51d-8deb-4453-3494-08de67da6962
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 12:54:50.6422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGB0KoZeFvk3KZoEqe64eG8R05o+MmBqKCIQnJ6MhX5cZPUbzHNsCRT/o3gg/k3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6648
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12099-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[samsung.com,gmail.com,vger.kernel.org,lists.infradead.org,lst.de,lists.linux-foundation.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 53BBC10F402
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 11:13:42AM +0100, Christian König wrote:
> On 2/9/26 10:54, Kanchan Joshi wrote:
> > On 2/6/2026 8:50 PM, Jason Gunthorpe wrote:
> >>> I'm actually curious, is there a way to somehow create a
> >>> MEMORY_DEVICE_PCI_P2PDMA mapping out of a random dma-buf?
> >> No. The driver owning the P2P MMIO has to do this during its probe and
> >> then it has to provide a VMA with normal pages so GUP works. This is
> >> usally not hard on the exporting driver side.
> >>
> >> It costs some memory but then everything works naturally in the IO
> >> stack.
> >>
> >> Your project is interesting and would be a nice improvement, but I
> >> also don't entirely understand why you are bothering when the P2PDMA
> >> solution is already fully there ready to go... Is something preventing
> >> you from creating the P2PDMA pages for your exporting driver?
> > 
> > The exporter driver may have opted out of the P2PDMA struct page path
> > (MEMORY_DEVICE_PCI_P2PDMA route). This maybe a design choice to avoid
> > the system RAM overhead.

Currently you have to pay this tax to use the block stack.

It is certainly bad on x86, but for example 64k page size ARM pays
only 83MB, for the same configuration.

> That is a good argumentation, but the killer argument for DMA-buf to
> not use pages (or folios) is that the exported resource is sometimes
> not even memory.

I don't think anyone is saying that all DMA-buf must use pages, just
that if you want to use the MMIO with the *block stack* then a page
based approach already exists and is already being used. Usually
through VMAs.

I'm aware of all the downsides, but this proposal doesn't explain
which ones are motivating the work. Is the lack of pre-registration or
the tax the main motivation?

Jason

