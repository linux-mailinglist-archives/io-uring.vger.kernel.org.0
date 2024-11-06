Return-Path: <io-uring+bounces-4512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB369BF69A
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 20:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3B501F23CE2
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 19:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F5020A5E7;
	Wed,  6 Nov 2024 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="oCfaVZRx"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E5F20968E;
	Wed,  6 Nov 2024 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730921679; cv=fail; b=caMe0BtmSYKXSs8c6b55PIag/QS1AkbaNXDC0mc/syWdh9iyaWGbmgRRzDQodojP8X2kNoPyJ87GkkE/Jd542ksc4arX++4jEB/Vn3SOKB0Eo22rnhg3+4s0B3rJaJs9SNRsPmM2GhH/CTZgJEGHeRV2xgz6/8+wcTkAjOWQpLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730921679; c=relaxed/simple;
	bh=JPyN+yYaaFJ0AJHfzxqRWfdMWIYn25OKpMvQBLnHKl4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZsTetzFiXiDWEUScSayS0Hv/FksizcZhKpNqyyM4Yw7fzZmA+AEYEixiROzKeCY2Pi5NfqmQboY2eZuaz6eJbQxxBHbzGd/oXC7H/ySOxxkg6j3YYWltANgELp0QoP5q0KD3RHjiE3zPIeW+eiyukcOB0cyDe9vD3EHkzINpIVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=oCfaVZRx; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40]) by mx-outbound40-228.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 06 Nov 2024 19:34:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTZb8nwBHSVkstXyIjVua/ZE2C2/K/dvEE7xg+jnoTRj0urGRX7NG3XIuxBCTFjXmpX3CnNc1MVPKloVZs6Q/F2KcYYdBE4IVyj4dUIxXB9hYTD2b7XxmJgl8lB0iouzxi5nV9KZh1qU2AfvapRpiszqV3K7ShP0HlasAWIH86you57QmxggZttRIAGyKG4BTB3L/NJhJzBatS4L4q8LES9hw0WtKZGGEAjyYwNTWyQwAif/pIGUp18dEd0DQlQmVJ5HYTg+EFYEnd+nK9PKaH00kMImnsQ66I0j4Yu3SxySpEV5FD9TDDzarSmPJJBpt8ReGWIefHnqh2id/2S3vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPyN+yYaaFJ0AJHfzxqRWfdMWIYn25OKpMvQBLnHKl4=;
 b=kX5DgmcZBGnxxecHIFYHNIcKLaxv8BRxMzvQr7AEgBC4ftrSwK9MEVfkvfxs4M9uiYGx6u/WXhZmq7OVPEGFXbZIY6aFoOH0wy55vPtLGg4jkahOlVDKuCWz4n7BYwEvgzVieyP7Icp0ULoeszA6mnWf87maDZwh+Qwk1g0F3KEpkpKUinRhqxP7+JVy9Ok0IKXyIuZIu8Sobi/bUfYHJRyKKB2Ya97ZkqPppsTdpgwcVCwc+zTDQAMT/QAS1huFGDzZ/ngGwfFcucM3YjlhEmsLk/KVe1TvR80a0z25M9pvznj8nCkrEE6MITjK624v3KbJUnMay612mWevAsHhDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPyN+yYaaFJ0AJHfzxqRWfdMWIYn25OKpMvQBLnHKl4=;
 b=oCfaVZRxr0FlhycHcuWkZ3OKk/cj1qmSpduxLfN5djDpKgdlqw5t09PDoU70d8OCKoAkrzAgZB2z0SFbLLFFf8YRbP+hEMZBMpEVhaJcUdlcKx0VVFXLGdeWKk+ofv2sxdsKIokJ/LHu01/cqkQkZTwKHMeon/IeCy3ITpzyIHw=
Received: from MN2PR19MB3872.namprd19.prod.outlook.com (2603:10b6:208:1e8::8)
 by PH8PR19MB8149.namprd19.prod.outlook.com (2603:10b6:510:1bc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 19:34:23 +0000
Received: from MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911]) by MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 19:34:23 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Ming Lei <ming.lei@redhat.com>
CC: Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi
	<miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Joanne Koong
	<joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, Ming Lei
	<tom.leiming@gmail.com>
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Thread-Topic: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Thread-Index:
 AQHbH18k5DcsQ3cILESkRv/PhXIC7rKmYjoAgAFtMICAADBNAIABbwGAgABfuYCAAPiUgA==
Date: Wed, 6 Nov 2024 19:34:23 +0000
Message-ID: <c85045a5-0865-45d2-b561-d6b1cfb75c38@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
 <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
 <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
 <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
 <CAFj5m9L9xjYcm2-B_Dv=L3Ne3kRY5DVQ8mU7pqocqXE13Ajp-g@mail.gmail.com>
In-Reply-To:
 <CAFj5m9L9xjYcm2-B_Dv=L3Ne3kRY5DVQ8mU7pqocqXE13Ajp-g@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR19MB3872:EE_|PH8PR19MB8149:EE_
x-ms-office365-filtering-correlation-id: 67889623-a9ed-4eae-e61f-08dcfe9a04a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eVhpUkkzaUlIMlhiS0NqNDhWM2FEOThmc0p1UktrVW4vNy91bnpyekNINTMy?=
 =?utf-8?B?MzZta1JCL2xQemdYK0wzMmVMaW9tQVdhZDZKOUkzdDNROFpWclBZb1lwSFE0?=
 =?utf-8?B?QVczd2xHa0NIWWE5cWNQdVlubnU2NEpwS3YzaVVtaGp3b1N6QWNFTjFSWE9l?=
 =?utf-8?B?NzV6WkNMcXdreVZsSEdoRms4T3RsNW9CLzIvbHo0TkZvcmVXbGE1aUJTUHRD?=
 =?utf-8?B?UTdraDNKbW5yMHVoQk5PcTE1WGp1eUwrait6Zkt0bVFJV25YblVEMjhTck4y?=
 =?utf-8?B?a09ZeUEzVVlWNWZZTTlxaFAyc1oxSHFwa2JrNXhOcTh0SmJKeGNzcW8vZTdB?=
 =?utf-8?B?TjFOcWVwRmlKZG5IT2c5b1l0MEc1WHRzRzVEeXJvQVQ1Q21JeWx4VHEzWmxD?=
 =?utf-8?B?akJicmFYc0xKVW5KMU5uUEZZeGErRm9xdjRwMlM4WVRSS25vajFRQkM0RWx0?=
 =?utf-8?B?Mmg0LzhUcDI2S1dGbE45UkJVZzZ6OFNlM0dOcHdQUDRjL3J3c0xGNkthRVFP?=
 =?utf-8?B?dHhJYVhSZkpiSTAwUHZteURqdTRCS2hBNjF5SWErUkVUam1ISzVqL2NSUmV4?=
 =?utf-8?B?bDV0aDJJbWEzNUY3bXorUzE0ZTQ3UXN0dFI2K1hmdURaTm14bnREYWdRY3cx?=
 =?utf-8?B?MGM5aUpDbUFqeFA2ZVY3QytmVFBqNVJKbHUzNzRqTXczWmQvL1Q4ZzVnb000?=
 =?utf-8?B?ZXplUDZZMVpYeG9PcVIweThQYjZvUmdrWkwyNDY0Sm1IM1ZmMXdKRGlWajBz?=
 =?utf-8?B?Yk5lMzR4SkVLOXJyTUYyakJmRG5zSnpVQ21UWkZ1bC9hTW01ZWtzRlVtT1Uv?=
 =?utf-8?B?Q3ZTVkdmankzRkp6elFOUkJIcEMwQ0Vja3YxQlhVcEdIOEpncElEMlFOektX?=
 =?utf-8?B?Q1ozWWQyVmdGOVg1RGxtYUQyRmowWWI2S0hkY2pldDN1bVhXVTlLS0tqcVJJ?=
 =?utf-8?B?cGFiVndoZG11dk5TOHY4RFFtZ2k5UTNmMzlBMmxucUFwN3BXQzUrYXFLRFI0?=
 =?utf-8?B?eHpoN1JBME1mSVpKckVlc0xmVVcvV015MzVJM3NtcllybHlGY3JvdUJCaTE1?=
 =?utf-8?B?Zm4wVDc1cHdzeFB3bE01VlI4NnI1WU9SdjdaaGhSOEtnUXBkRnFvdU9CeFVE?=
 =?utf-8?B?eS9BL1MrU3QzR1M2bVR2ZjV4RFJYWlovOVU4bHFwcGY4SklBbndTMWNqWEZP?=
 =?utf-8?B?MUdVRWV4UWU3eFk2RHVYcGJXVG5mdWRad3JLR1RIRHlMK0hRUTVkYVVKSHg4?=
 =?utf-8?B?Z2VBc2d5R20rU1FnMVZZaWhBaUFpVHJFSzVUVFhiempBQmtaMUlCWVowWWM5?=
 =?utf-8?B?YlRLcGVYN2ZybUFEUUNLNm9jN3hxZnYxSnZFLzFicklmOVM3N0lUaWFCS3p6?=
 =?utf-8?B?WDhWQkVZYlhheFJIYkZya2Fudktmei9mM2wzd3hHTGxEMVhNamQwenQzQ2FQ?=
 =?utf-8?B?NWVZVnd6SmxqS3lQS0l5bjIxK25YUHJwbnNDdjRMYXV1VFFoaU1CbDFsYkNZ?=
 =?utf-8?B?QlY0K25rQW14ZkdOQ1UvUlpRRmRpeXcybWFmRW1mVXJxVFlyODJaV00wNEgr?=
 =?utf-8?B?NU02dlZBVUJwditWcjJOeUpIWjl5SkdIcDVqcEw1ajNuNE11aDVudkptdVQx?=
 =?utf-8?B?Z3dNV2preGk5REVBaVdBZm13S3RCZXFlNnBiZmJuaUdvUEVYODNLbkVhRTFl?=
 =?utf-8?B?N3RqZ3BxSklaRzcxNjYrRkE1ZTU3WHFKcStWc0FtZi9DZUNIV1E4L1k3V3hR?=
 =?utf-8?B?UUFuWm9LY2pYOWRIOWJHREljUDZvbmhSZWVhVHY4KytZSDNFRERZZXpsNjdF?=
 =?utf-8?Q?FrOS5Br4wkA6B/2R4+nwlJFQOY0KHOrA1jSEs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR19MB3872.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WEU2QTNMME1GdHRGSW5QeTVybmQ2WTZzUmdVZ29MczY1dVJzTDRmOWswSnNZ?=
 =?utf-8?B?UG1xS0ROZy9Kb290dTU1L1hydUNuQWhJSktoL01QMDhLZDdwcGdVeWFJUExu?=
 =?utf-8?B?L29JVkxFRENDMTlVeHY0Q2FaNXd2TEp5cU10cmZNQjBSaTYra1RtaUJrdXVV?=
 =?utf-8?B?WEp3UlcwamExYjF0MG9LRTdYdVBDeVd3Tk5LWkhWUHZrakQzWHAwT0FXNGcr?=
 =?utf-8?B?ZGN5OUhuck05enhFZk5sbGtzQmVURGxGVG5OdUNHalpMMmhuTkJzN3FQbnY1?=
 =?utf-8?B?VVJoL1hNUGxGSUFMUTVTbmhPSUFwRHYrdmJyMGJ0MHZ0RzRrTlpHYWs4Vi9E?=
 =?utf-8?B?cm5qSWxPMGdpRWNtQVNDVmgxMDVKZUthWmdqdnB4KzV5K2xKODhpVEdxSDNl?=
 =?utf-8?B?MXg3RnYrSFVYQ0xVS1hqZ1pYQitlSXBWSHYxRVBtT1RzejlFT0tDcEZGSHFT?=
 =?utf-8?B?eXNhOXRoVFJCRHZLSmVyb0lBcWg2Q0crS0pwdFZyZjhLLy9hbEt0UG9RYmhj?=
 =?utf-8?B?cmJvMjVhZlBIMXhwSXNBS3FNMXQ2b0dsMG9rMUZnU1Q3M2FDN2ZmUzUxQjhj?=
 =?utf-8?B?L2ZQdUErK2JPN2xEa3RqT1FNR2Iyb3pscDVsY3c4N0JITTZITnh6ZXg4WTE2?=
 =?utf-8?B?WFNsVjNsM1BKUmYxRUlkYUpaMm96SGxVYkxFWkNZY2NCc1hZNUdxN25DR2VX?=
 =?utf-8?B?UUkrOXp5d0NoWWZpOEt6NU9walZidTlrdkZ3ZU1sS2tsdmNhdm9lZWg4ZUha?=
 =?utf-8?B?a2M2eTJ3TExUUGNPOCtaREp2SW84N0h2L2FyRWl2VUxWZXJIc0M4VEFPejhr?=
 =?utf-8?B?aW42ZmtQeEx5bnJVdWhtbmx1czNIUy9Ub1JiaTM3WXFpMjZrNVd2LzhJSDE5?=
 =?utf-8?B?cTBIR1A3L010MWtMaUtmRklXbjZoY1lQWktzSGwxaHdBOFliZVpZQi9Xd0NK?=
 =?utf-8?B?ZFljeXBnOXBscDFCK0VkREU5RWJNS0Zpd0kxT3ZqLzZTODN5K25oZWI2d3hy?=
 =?utf-8?B?eGlMb0p3dEIvV2Q2VFdnQXhialRlOHRLY2loaWZZam5OWFozVUtNVEdWWnRp?=
 =?utf-8?B?aytsc2wwVWRJa0EzYnlQL2lDVkVRaDRleTlRSTZyWEd0cnNtR0RDbWl1MGVh?=
 =?utf-8?B?MEFWZWZTVTd5Tzc3RnJvMHhYVnN5V1hoOGEydERUMEQ5VDF1NEh6ck5WeHUw?=
 =?utf-8?B?ZWZmMnYvZTRzV25lbzlnRjhFWXREVm1wVXRQN2x0T2lRUExJR0dYak5FenVN?=
 =?utf-8?B?S2lpSDVJYU4vTHFyMlRQYTBuWnIwUWJBU2lvZjNnUjZScHM5cExpTXVyRkEx?=
 =?utf-8?B?N01JVnZ4UmdGMXVocFZNa01OSnM4cEthaGdBbDVpdGJGWXQ5dVd5VHZ3b2xF?=
 =?utf-8?B?RWREckxZb0oyZENGRW5wbzEwZ00vZFp5b0JIR1FIOUFycXZBVmxadG45ajIv?=
 =?utf-8?B?Tzk1U2IwSTNNZDBYaDNwMlZUWWtFMjZSUUsrWWRGZi9oelRmMGpmRklTUzhz?=
 =?utf-8?B?UUY2Y2tZRTAyQkJhMDNGcCtOTU5ObHM1ay9KYUxHZHBPV1U2dkxJbFhoTWZv?=
 =?utf-8?B?Z1pWcTV5NVp3NEtreHNyVW9XTWo2UEJKTXdiV1FoT1ZIMzNhYURnVHMwOGZ5?=
 =?utf-8?B?VHYrS011aUNiSExRenZaMis0OVNvNVN2dnBYNVVBNzNPOGdEMVErdG55cHhq?=
 =?utf-8?B?QVV4SGhyWkRlOFNSaDlHeUdCelovSzNmYU5mOUV5bVMwUWxOdGlJY2ZLRTFq?=
 =?utf-8?B?U2pDSUEyNmE5cy9XelNXRHptVDJ3N3FveTVDdkN3RWhlZmlhSENoUzRsdGs0?=
 =?utf-8?B?akgwMXBVY2pWWGEvemRiTHFFNVJYWE9GNWNzRTlEMVVVOXpYM3UwczQ1UkQw?=
 =?utf-8?B?ZzZRYU85anlFc0xUS2M1azROV1F2THdhSGh6M3BZTmNTR2lKd0R0UHBOUG00?=
 =?utf-8?B?UGtGM1hUV29QdTlHWWJ3YjBzRWFLeTFMaThFQnZZd1NBUW56elNVSHhJUjQ0?=
 =?utf-8?B?QVpKTzdjVU1vcWFybHVhK2RQd0szTkIyMGliLzg4Ny9LblM4STd4enQya1RE?=
 =?utf-8?B?L0JkM21nZ3BwZVBiSy85NEQ4Q2ppYWI5YlRHZGw3NmQxSlZwcUI0V1o2K0ZK?=
 =?utf-8?B?Ump1MmJYalVWazQ3ODFUeE5UamNvQW9reU0ranhOSHdLQ1dIMDdBNHkzVUs3?=
 =?utf-8?Q?0n15O/A9Vd0sDwInxbYD99k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DCE181CD4E1A649A5345EF0EC64E61C@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DWpfXXHb6OyEBhWHnF8hYjB7BGzBZCSncyhFvH9Qu9Hz4DWMN+7n/wV9HzmR1eQpD5johoPl4pFRUxd3QduzpoMVl5eGReCucZzCclHnwsWbRCrH28rRm8OO2ikFLvl52jE3quzZk71otFa4RpWT34HDXmzerJI3aedj5zE8zsmK19ZoRtnALrSaYMOnnBoRpvft2Z/A3qqrxhnZJLwilp3i5k34mBPYQ5fyCq/cHP2v9024eaELglZNE0fjwpjNrS/B4bqHBeV6EdmJ8gwM1FgNBxLKnw93TiLtMMHYHtu0DbwwKfmiRf5c/ALz6I5UQlLBINkJKvoQNKeDORM6Qug8finJt0hhTR9NGqPCt1J12/wAKS2QOQpIBPpgLBDmfiX4Arq2F6lt8286cwLOGZwbOYWfbLQ46ciONlx2CDb2Bp6emSARX9DO2VkGDS+OK0Hmvt49siKDZNQg9hAQFuKCmng/w+7wdU+VjiIFcU+GUkKciY8zRmG7S1uj+JL9Sr6N3JeM3WHjTyRViwLxVeMIIWgXRTTqO0EsSB3aGOAlnoEPLUrzUL3wj8Xp2SDEJojcBIPt/+NsJr3B8CWhCSM0Ysmt+jJOOqfOpjWYOunfZz93xHI95ehw/e3yRCKzQq4kZM9ekFVh25+g5Te6Ew==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR19MB3872.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67889623-a9ed-4eae-e61f-08dcfe9a04a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 19:34:23.5267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ha2oGFOKJSppY5JzFQkLc7oFNZvyVSIRqOn/NazNU8PdrQGh9noyqfn8elhuvUJPaLeOCotX5PZ5VPBv4NWs9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB8149
X-BESS-ID: 1730921667-110468-24149-6643-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.51.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGZiZAVgZQ0MTUxMDEwNDQLC
	XROMkgLcUw2cQ41dQ8xcDc0iDR1NJcqTYWAK3Kg1pBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260247 [from 
	cloudscan14-68.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTEvNi8yNCAwNTo0NCwgTWluZyBMZWkgd3JvdGU6DQo+IE9uIFdlZCwgTm92IDYsIDIwMjQg
YXQgNzowMuKAr0FNIEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRuLmNvbT4gd3JvdGU6DQo+
Pg0KPj4NCj4+DQo+PiBPbiAxMS81LzI0IDAyOjA4LCBQYXZlbCBCZWd1bmtvdiB3cm90ZToNCj4+
Pg0KPj4+IEZXSVcsIHRoZSBvcmlnaW5hbCB2ZXJzaW9uIGlzIGhvdyBpdCdzIGhhbmRsZWQgaW4g
c2V2ZXJhbCBwbGFjZXMNCj4+PiBhY3Jvc3MgaW9fdXJpbmcsIGFuZCB0aGUgZGlmZmVyZW5jZSBp
cyBhIGdhcCBmb3IgIURFRkVSX1RBU0tSVU4NCj4+PiB3aGVuIGEgdGFza193b3JrIGlzIHF1ZXVl
ZCBzb21ld2hlcmUgaW4gYmV0d2VlbiB3aGVuIGEgdGFzayBpcw0KPj4+IHN0YXJ0ZWQgZ29pbmcg
dGhyb3VnaCBleGl0KCkgYnV0IGhhdmVuJ3QgZ290IFBGX0VYSVRJTkcgc2V0IHlldC4NCj4+PiBJ
T1csIHNob3VsZCBiZSBoYXJkZXIgdG8gaGl0Lg0KPj4+DQo+Pg0KPj4gRG9lcyB0aGF0IG1lYW4g
dGhhdCB0aGUgdGVzdCBmb3IgUEZfRVhJVElORyBpcyByYWN5IGFuZCB3ZSBjYW5ub3QNCj4+IGVu
dGlyZWx5IHJlbHkgb24gaXQ/DQo+IA0KPiBBbm90aGVyIHNvbHV0aW9uIGlzIHRvIG1hcmsgdXJp
bmdfY21kIGFzIGlvX3VyaW5nX2NtZF9tYXJrX2NhbmNlbGFibGUoKSwNCj4gd2hpY2ggcHJvdmlk
ZXMgYSBjaGFuY2UgdG8gY2FuY2VsIGNtZCBpbiB0aGUgY3VycmVudCBjb250ZXh0Lg0KDQpZZWFo
LCBJIGhhdmUgdGhhdCwgc2VlIA0KW1BBVENIIFJGQyB2NCAxNC8xNV0gZnVzZToge2lvLXVyaW5n
fSBQcmV2ZW50IG1vdW50IHBvaW50IGhhbmcgb24gZnVzZS1zZXJ2ZXIgdGVybWluYXRpb24NCg0K
QXMgSSBqdXN0IHdyb3RlIHRvIFBhdmVsLCBnZXR0aW5nIElPX1VSSU5HX0ZfVEFTS19ERUFEIGlz
IHJhdGhlciBoYXJkDQppbiBteSBjdXJyZW50IGJyYW5jaC5JT19VUklOR19GX0NBTkNFTCBkaWRu
J3QgbWFrZSBhIGRpZmZlcmVuY2UgLA0KSSBoYWQgZXNwZWNpYWxseSB0cmllZCB0byBkaXNhYmxl
IGl0IC0gc3RpbGwgbmVpdGhlciANCklPX1VSSU5HX0ZfVEFTS19ERUFEIG5vciB0aGUgY3Jhc2gg
Z290IGVhc2lseSB0cmlnZ2VyZWQuIFNvIEkgDQpyZWVuYWJsZWQgSU9fVVJJTkdfRl9DQU5DRUwg
YW5kIHRoZW4gZXZlbnR1YWxseQ0KZ290IElPX1VSSU5HX0ZfVEFTS19ERUFEIC0gaS5lLiB3aXRo
b3V0IGNoZWNraW5nIHRoZSB1bmRlcmx5aW5nIGNvZGUsDQpsb29rcyBsaWtlIHdlIG5lZWQgYm90
aCBmb3Igc2FmZXR5IG1lYXN1cmVzLg0KDQoNClRoYW5rcywNCkJlcm5kDQo=

