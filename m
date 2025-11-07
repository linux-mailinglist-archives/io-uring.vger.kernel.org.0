Return-Path: <io-uring+bounces-10450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B828C41D07
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 23:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5B5E14E121D
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 22:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F6F24BBE4;
	Fri,  7 Nov 2025 22:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="nbJwYDIQ"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D54231327C
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 22:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762554238; cv=fail; b=AiTv1AL3gXVN6EjpuSa2lBbgvgLJsHhtTneLGH5o+CPDklfcvK5e5t1/6Hg2/1pRsD/X1eMt3VmBqBbM+A3PjbcJxJ9Ycaegsc+EEEPNhfh1jfAMsHwXPo5+MYa1mwj+KEDuihff7V1ArxCxMQCgtY0LnilUgpyk01j68YcT0lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762554238; c=relaxed/simple;
	bh=iUhvUnTqk7W9nOH4ze7m62V06yUeMypLxjPivqaFOwQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RCqsUPYwr8yOAv7HZGNVU9niKf6wVM+T1WXl4kgGT/pdm00tZILFT5hq5pGp9dor8hqVbqRmuz9oNccWAntBZfgP2czbIJmpLJYgAAjG0bNfzQf3uBER1xKo6JNCPeiTIxQFTmZ7kqp0Czce1ZYyKitdDk0Wh1NFbqvqsKBkfnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=nbJwYDIQ; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020093.outbound.protection.outlook.com [40.93.198.93]) by mx-outbound13-197.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 07 Nov 2025 22:23:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7xr6m22TKQczr68duiFJd1J7+XwCi3tbEbRQgV5gyHSeufiK7YOb+VgShuTYNNkwDRyvuQxcxnr1/MGXt4ecQjJLUxNn5htcNPdby/Oxjbm8TwPiBZJmsKE5Y5ikD78g1QlLttzqFGdcw9KdZhkfJscCVTz4KM/mJTfnvLYoL/bpmD3mSfkiGHYffXq3Z9opmOEpx0IuoAGCfQr4t8ZSrrj+AcUwq324hCAVZuxNRM9iYDfGlW3uy48NDipDazRv27V2VNVHq9uNsy3t5UzoCUq0R7x5hvCSdQat1/+esQfJYTAbm4mE/qNyugHhIid2QyadiHjMzQmy/ZhN5Zgug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUhvUnTqk7W9nOH4ze7m62V06yUeMypLxjPivqaFOwQ=;
 b=E5e+7zMrkwRgVpLmhOPdI4Jt6Q/a/+SCjtidCD6TFO9/EDYkAExGlIU1diubjrnFapbSq+ufbz0yhUykxU5OiUGeIEj/6hzVNtK5ndJN3dEEzHuXxuJX92+YnizjuqHRNkJnkRcSM047TXv1CeYlxXXYoM+oqWdkG3vYByznj4HDjOsyvg7kng4TzR1GdjV0n985wOJlrGVeGmU+B5sxUB0C5kltENkrd/IwY9Kr6H2lbdoRc+inmyd+rkuYV69C5PwFcCj2rySswr5G15JNZzK5ELVAvb1ZT/DS6tAmuqoLI25pnpu5myMpL/le/gKhBrcV0Yt7SdS+qvstdQvlbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUhvUnTqk7W9nOH4ze7m62V06yUeMypLxjPivqaFOwQ=;
 b=nbJwYDIQnItm8Ia5WLZ8SLggtv4gGCRGvuLZuECFJx0xgQDnp4GjKChaiXb5EBiBSRj9RDBtgHZE8MGDV7+2lIatmmZYzuZE6PURjtVwo/PyIDSrS3s/0jp9473IBliUMAcevt3CwtMMs3p/Znf1cDBSXUCAhpYo5IWR+bbtSac=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DM3PPF1779F935B.namprd19.prod.outlook.com (2603:10b6:f:fc00::70e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 22:23:36 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9298.012; Fri, 7 Nov 2025
 22:23:35 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bernd@bsbernd.com>, Joanne Koong <joannelkoong@gmail.com>
CC: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "xiaobing.li@samsung.com"
	<xiaobing.li@samsung.com>, "csander@purestorage.com"
	<csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
Thread-Topic: [PATCH v2 8/8] fuse: support io-uring registered buffers
Thread-Index: AQHcR5E5yU8N2HqhKk+omirF/pkiNrTmHY0AgAA4NQCAAYOCgIAAAemA
Date: Fri, 7 Nov 2025 22:23:35 +0000
Message-ID: <92b4d406-dbf2-48ba-88ab-843bdee9e370@ddn.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-9-joannelkoong@gmail.com>
 <a335fd2c-03ca-4201-abcf-74809b84c426@bsbernd.com>
 <CAJnrk1YPEDUbOu2N0EjfrkwK3Ge2XrNeaCY0YKL+E1t7Z8Xtvg@mail.gmail.com>
 <bf239433-741b-4af1-ae72-ee5dbb1f5834@bsbernd.com>
In-Reply-To: <bf239433-741b-4af1-ae72-ee5dbb1f5834@bsbernd.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|DM3PPF1779F935B:EE_
x-ms-office365-filtering-correlation-id: ded8b2e6-d4d2-4d50-5fc0-08de1e4c4b0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|7416014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YTlGMHorNE1aNEdLT2hlVjJxeEVoVW45QUNBaTVmbzhZMnhaajdvKzZuWHNh?=
 =?utf-8?B?YkNiVloxNEFaZU05RE83ZXc1S0QvbHhlTllSai9uenUvd3hsWVFYK3BUeHVa?=
 =?utf-8?B?QktWNzFtMTkyVlFocndBNER3RTczRTRzbGVLRC9Nc1creVkvSDlaQXRZZmRm?=
 =?utf-8?B?eTlyTzdDb28rbWlqalRyU2c0eVlCT2JOYitxWlI5M20vQlBoZXhIbHMrcFd0?=
 =?utf-8?B?TERmQXNFaERVbHQ5TFFjZzBETFpqVWJVdksvcDRYUVFOOC9COUlBbFdQNFdv?=
 =?utf-8?B?Y0N4MTlSWkJXUXhmTFI4NzdIU3kzR0VaeHcwYnVOQ0NBTzl0NG9KNHZxZTRN?=
 =?utf-8?B?a2tZNWVCdlJlb25QWWVSdEFOS3p2bTJobnRFMGhCTVpEeVU5S2s4YkFjczZ3?=
 =?utf-8?B?MjdSZ213S2d4R3RXTFpYbHFXUjdWK29ZTldIcHhVS3RBUjM1c1Jlc1ViUldX?=
 =?utf-8?B?ZTVXTldTV1YySFRoRnl3eTFJb3NyeTdLNVdzN09aM1JOSzMwbmxaaXZ6YXRR?=
 =?utf-8?B?aThEMFh0TDFleXZidUx5UVJqL1N6czk2enFkeTE1N1I3RjRzdGdvMkVHRG9t?=
 =?utf-8?B?bUpuOHlDc0dSdmgvcVdvOXoxTG0rMkJ0UlE3Vk53NXVuWW52Qy9jVHV3NHJk?=
 =?utf-8?B?RnZVWlhZcVZmUGFVWXNQeU1BSFRRSlJNWksyWU5hRk95b3ZhM2xCZzVRREZM?=
 =?utf-8?B?QjJBcEQ2QjUvZmNxSzdUbHVhaVpxVXBaYlZ6SitVeU04L1VHQSsrejloNE1O?=
 =?utf-8?B?YzNWV09lZERqaHJGdDZ6QXMwTHZqSkZLTXkzY0lhODE4akRhSTBtZ2ZMeWNh?=
 =?utf-8?B?dXFYNy9jSE5rNGF3UmdPWmREb0dlNGhaSWJ5Wmw4RHRzSXpTSk1tR2ErTjFa?=
 =?utf-8?B?NW05NmRvRy9WZzZUUVgvSHFiQTkzdml2T21saWtvY2kyZVpRWjRFejlkY2Fm?=
 =?utf-8?B?ZC9GK1lta1hZWEZGczRxcjl6Q1d6VWRLTXVuMUVaVlRFZXNWRlNkRXlDcHhF?=
 =?utf-8?B?ZVhYMllxRU91Sm5USHU3cm5CVnBCU1Q2SVp5enlVYStkVjcvVUF2V3N3L3cw?=
 =?utf-8?B?NlV0UTV6Ky8wQncrS0JpcGFxck41R1p1WDRYV1VJdWN0ZWlZTlp5MStlVlRB?=
 =?utf-8?B?M1Q1YTVqTnB0QzROY2NoeldzclpldFEwOGpEYWZoZ0EyMmNFL1pSenBMVXh5?=
 =?utf-8?B?TGlUeGFiTFhacldjbUZ3aGZ1ZWRmRG14Vld5dXBQTFBPemFaUkhsdGdmc1Jw?=
 =?utf-8?B?Ti9EOGZXbVJzK0pmSVZHckhPNTU0cUxJL0tnK2FadGZsV3RaSnlCdE11N0FQ?=
 =?utf-8?B?Q2N0UjFETTJXSm9ZamthMDZpb0diRHFPeklNRXBTTUx6bGFGNFdPTXFjV1lx?=
 =?utf-8?B?V25oaXUrUFh1UW5pUkFySTZPK2FNK0ZSU1Y2QWk2bTN2NEUzVlFHejlIOUNG?=
 =?utf-8?B?THIvYkVueWRkSUN1dWVVM3hIYzZDZjVIOUNkUlpieGJPYWV2T1ZTWjdhRjNi?=
 =?utf-8?B?UFBhMHNEa0lQTHNGUkNJS2p5eDRjZUNDc2hpQk9UUUJ1L3owRWtwMmJpajI1?=
 =?utf-8?B?eXkzUkxlUnYvVlh6ZCt2SGczaE0rZnlraHI5dWJZbkpOeWFzVmxPeWlKZEdH?=
 =?utf-8?B?Ly9qZThPRlp0M1kvTDV4Tm1CdnY0cEpWTlU0UVJoaVg2M3Z0T1FEcU1qdGl4?=
 =?utf-8?B?bVd4L3A2S1BHcFk4TERvRkw0aXVMbkJRTlM4SW5Yc1FHdGNuc3ZRakdSMnQr?=
 =?utf-8?B?SWk5R25vUEEvYWlQU2QrSUFrS1J3cHZwbzNqODJqNHMzZ1daMndXdXQ4WkN2?=
 =?utf-8?B?dTlVYnNwVFNOT1AvSGtZYXM4aGNSUnlXaTNoSTkxbmhSbUtJNFZ6YjV4dW84?=
 =?utf-8?B?RDVIdWZiaUJOQUtiV21PYlpNZldWcUlRWGJNd205UldOaStGKzNkcS9uQ2Jp?=
 =?utf-8?B?ZVdDd2ZsSndzSDRJREFFKzFlT1k4UG1NeGpEYUlIRWpnOFdOR2NqeHRwZ0xa?=
 =?utf-8?B?STJDNHdOdHJWTjFhT2pZNnVBSnhKRTFTZ1l6V2dKcUcrR2xhK0cxUFBDWkNh?=
 =?utf-8?Q?T77Zr0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(7416014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MWlITXBBaEpuZlFXclo0TXNGaGoyQ0hOaTVmdkhUUnVWcS8xQWJ5NXlJWWdr?=
 =?utf-8?B?ZWQ0U3Q2dGwwUzQxZDd2cFJPMU9vRTNDWHQyVERndjBBT3RwR0kxM0xCQ2k4?=
 =?utf-8?B?VDhodGtTbXdLWWg5R2tya21WdHd5OUsreGxsOVhrczZnT2RmdDR5azFUZlEx?=
 =?utf-8?B?MStlZHZJcU00S2J0M25oOHFIeTlDa2VVbldTNUM4TzExZzVlWkV5VmhpQm9V?=
 =?utf-8?B?SHlVVzcrVUp6T0dyVElKc2hTYUdjNFJ6S2d4U3dlRCtXNkRyK0JZaGZCZTV4?=
 =?utf-8?B?a05UM091ZndZRTJ1U2VDdlNPR3NQZU0wYURwbnlUYnRiMG5Qei8velJTbGhx?=
 =?utf-8?B?ZHRmSllNTmZMNlVaNFhjQTFob0k0ZFVpQUlUYlNFZkM5N0g0UE5DODhnbHRF?=
 =?utf-8?B?WDhHdCtZay9Dam1wc092TEVHZXF3SUtJVUhyRHVhbTduMFd4UlhFMllaSHhP?=
 =?utf-8?B?bU1RWXhhT01sbk1kS0x0a0ZaUGdESEhuTG9hY1k3YTdFMUpiQlNiRjhVUU5N?=
 =?utf-8?B?SzJ0UW9tUVdnV01KSWVRV0FJUnB1bmFmRk9Cek1YeXN0cEpwTVJEWkxDYUFL?=
 =?utf-8?B?Yk5OVGtxRUt2RkM0dGEwSDFWNGE5b3BDV09WOFNwZHV3clBkZW80bjVqUGpZ?=
 =?utf-8?B?QW5GMDVUMlJZN0oya3c1c2V2Z0tCR0cwT0ZWci9YTWtRVkE0MTZEVjlrVXl3?=
 =?utf-8?B?TUszU09QS2tiTWhDQjRnR2VkWUk0d0o3akEzcGpuN0czMW5MQTZxSFg4ekcx?=
 =?utf-8?B?cXptcXZKbWIySXFRc1lwdEZsc003VTkxdWVrNmFkYllqemhsSjlHdG5wc3dj?=
 =?utf-8?B?ZGhNb1FUV21FU0hBczdLM2lCNnhKcW1XQTduWitwS2dNbUtYQUZDaFd1cDk4?=
 =?utf-8?B?Y2VyNTBxQlpzTUdhVWx4NHVId1ZNY3lCRnBVeHE1V1VCVkYrSkRiaG1xK2E5?=
 =?utf-8?B?SWcyK1BNSUczRkx2dFczNVRYWDhkT3M2eTJmWVdCaExjZ2lFa1UrZ1lMRDRY?=
 =?utf-8?B?c21SVlFDNDNHQi90eTRZOS96dER3TGFlb3BoTlczdXRUa1JTSHRNRHUvb3BC?=
 =?utf-8?B?L0JPL3c0Y1JxcytSMnRITHFCR3FmcEprNDZOOXVSUi9VRlNhdW5lVXRrczEr?=
 =?utf-8?B?L29Cc2ZqSGpRdXI0MVl1eWVpb0VrYlJNaUFlTHBDOWpDWE1MUWxQUllaRkEr?=
 =?utf-8?B?T2kvbm5iTUhFZ3FXaWN3aGR3WUF0QUFOU0FVc3I2aC9HRVVtL0lMNUUwQ2w4?=
 =?utf-8?B?MTYzcCtVMFZRU0JTcnBnLzBhOXFUUFJFTXFWb1oyNE9LbDF6MkJGMXBkenRz?=
 =?utf-8?B?SlEzdm9uTnV3RFN1Q21Yc1FtMGRiQXNsNEZrUUxZNHB5OHVQQXNDd1FlQmxQ?=
 =?utf-8?B?T3dYNGFTTVhhTkxsd3dLdWM1bTllK1VuVlZaekFGeTZjV2NUNVdnZWdMNUdJ?=
 =?utf-8?B?K1dPSmxZUkYxNmZUUmJjM2VnMWQ2dG1jN01DTmVHOXNHamFiNWhNMmdKekdI?=
 =?utf-8?B?NTR4WEYzczBURHprUFBCLzJZeThBbG9UM3NWUVBBT3FLMUkwaU9PMVNBZzRU?=
 =?utf-8?B?Tis5dVczcWtZWGkzWmZZTXJ3aVQrcHFZZ3JoZzByc1h2bEVuenE4dC8zVTVR?=
 =?utf-8?B?RVdqTGk4cDhvamN1Rk14Z3lQTVM4LzBXbXg2cGpIYkdpNDI2QzkyendRZXhj?=
 =?utf-8?B?dytDMis0V3pMaERHTC9tZ012S2IyanY4ZDBVYjRpWFB4RkFJZmFGczY2M3RX?=
 =?utf-8?B?THlYOHVhU2VLQmpoVk1FODJTNk1sellKOU84VFZ0RVgwK2xaMjdTblJEZjEr?=
 =?utf-8?B?TXlWL213QVR1dnRGdCttM1MxdHpQSkVydy9YdTNLd2Q1am05T0x5cVpHTHk5?=
 =?utf-8?B?ZnBPSHRpQlgyNXk1V1B4bk45UncvTVlUVDhJbFhFQy9TYXR1Q2x1aVREZy9X?=
 =?utf-8?B?TUZRYmxGcjdSR2xsb2VtbzhKVUc0YkpSZkM4K1FsTFdUT0ZGWG43SU12L3ZJ?=
 =?utf-8?B?QWE4RG1ISlUxM0dpeFU5TGFtMHlEVStBdHhrYU93TkNXNUJIWFB5eExza3hh?=
 =?utf-8?B?WkNReG5UQWVkcitPZGpLSE94cVVZVXJ2L0xzeFBWRW56RkpOQW9EQXl3K0h1?=
 =?utf-8?B?YnQ0SDJpTkhjVGxwOGxZcWs5NU4vK0NQZ0dsdEhRMzZEKytuTGpMeXpidVVt?=
 =?utf-8?Q?5g1Mu6CqCLoAdYarhmYjcXM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD4C21907F064F429DD93D61DFDECE41@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ob+JkQ5itgPUyM+3Bs79h+bE8zIMkR8BANVa/8LzuqDgXXpa1hD0j+ctdBSp2u5JUIk9yfvOUWQj/+ygrhax85/pzdyesbdtpShef0d0nvanNwmyLMktwSW/hQLHx2TXujzvPD6SWAJSRSPNRFhXOeYsra/5h/hoVBHQJ4N9UHxWQeRRur/DYaA0frEr1dkS+4QjzA8H0mP+JMgS5VI49zmUCAGwa7Aj2N3u/FpJGFKM7WbUkWrpbJvcMyMg6lRAkSzYf/1sXQd/5DeCszKqLobLYKaOX7LHEVdNEFKDNcWsMqB5hEFVyachy7+n6wRhk4ikiZ/t7kc6/XJgDy1bYfTauEYBG/rQoVp50iGPXPO74kReCZzSqfkqFXMbtVbPkelvMQ7Y8l/7gAdfBX+9LjWa4Y4pcOlB4+Wv2+MYY4AKBdJH3VMxoA1/rjcz5Dcc3JNxnL/4zz7lNt0Z2QzzytnfaR+8lyuQoK0sKVcn0Qjd5wGCXwgJO5cVIB7iz+ZIdJ2Kvxh9aDxxOJ5dKhoW6HUNjap+PEYfLW/iXhDFe8JROWBYClYxlbZHYUohZ4P+s5bjg7bGMDG8EDLPwdYvMl3BeR6jPT5suhrgUqNRMU7R+Ogwp59pntnGhxHw2afWLGWtY459eLpk/IVFA7c3Lg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded8b2e6-d4d2-4d50-5fc0-08de1e4c4b0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2025 22:23:35.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v45bmz/L8pa4f85FAKyJhEyN+yriBP9a8kLCp1IDLZwv9sphiWGnGM9XLPzjtpjtI/htwuhocunB+OFtS0i1og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1779F935B
X-BESS-ID: 1762554218-103525-7687-13392-1
X-BESS-VER: 2019.1_20251103.1605
X-BESS-Apparent-Source-IP: 40.93.198.93
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaWhqZAVgZQ0Ng4KS3FPNncOD
	HJJNncxNTYODE11dIgJTnJxNjUJMlQqTYWAGXxjb5BAAAA
X-BESS-Outbound-Spam-Score: 0.40
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268784 [from 
	cloudscan22-185.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.40 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_SA085b, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTEvNy8yNSAyMzoxNiwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+IA0KPiANCj4gT24gMTEv
Ny8yNSAwMDowOSwgSm9hbm5lIEtvb25nIHdyb3RlOg0KPj4gT24gVGh1LCBOb3YgNiwgMjAyNSBh
dCAxMTo0OOKAr0FNIEJlcm5kIFNjaHViZXJ0IDxiZXJuZEBic2Jlcm5kLmNvbT4gd3JvdGU6DQo+
Pj4NCj4+PiBPbiAxMC8yNy8yNSAyMzoyOCwgSm9hbm5lIEtvb25nIHdyb3RlOg0KPj4+PiBBZGQg
c3VwcG9ydCBmb3IgaW8tdXJpbmcgcmVnaXN0ZXJlZCBidWZmZXJzIGZvciBmdXNlIGRhZW1vbnMN
Cj4+Pj4gY29tbXVuaWNhdGluZyB0aHJvdWdoIHRoZSBpby11cmluZyBpbnRlcmZhY2UuIERhZW1v
bnMgbWF5IHJlZ2lzdGVyDQo+Pj4+IGJ1ZmZlcnMgYWhlYWQgb2YgdGltZSwgd2hpY2ggd2lsbCBl
bGltaW5hdGUgdGhlIG92ZXJoZWFkIG9mDQo+Pj4+IHBpbm5pbmcvdW5waW5uaW5nIHVzZXIgcGFn
ZXMgYW5kIHRyYW5zbGF0aW5nIHZpcnR1YWwgYWRkcmVzc2VzIGZvciBldmVyeQ0KPj4+PiBzZXJ2
ZXIta2VybmVsIGludGVyYWN0aW9uLg0KPj4+Pg0KPj4+PiBUbyBzdXBwb3J0IHBhZ2UtYWxpZ25l
ZCBwYXlsb2FkcywgdGhlIGJ1ZmZlciBpcyBzdHJ1Y3R1cmVkIHN1Y2ggdGhhdCB0aGUNCj4+Pj4g
cGF5bG9hZCBpcyBhdCB0aGUgZnJvbnQgb2YgdGhlIGJ1ZmZlciBhbmQgdGhlIGZ1c2VfdXJpbmdf
cmVxX2hlYWRlciBpcw0KPj4+PiBvZmZzZXQgZnJvbSB0aGUgZW5kIG9mIHRoZSBidWZmZXIuDQo+
Pj4+DQo+Pj4+IFRvIGJlIGJhY2t3YXJkcyBjb21wYXRpYmxlLCBmdXNlIHVyaW5nIHN0aWxsIG5l
ZWRzIHRvIHN1cHBvcnQgbm9uLXJlZ2lzdGVyZWQNCj4+Pj4gYnVmZmVycyBhcyB3ZWxsLg0KPj4+
Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBKb2FubmUgS29vbmcgPGpvYW5uZWxrb29uZ0BnbWFpbC5j
b20+DQo+Pj4+IC0tLQ0KPj4+PiAgZnMvZnVzZS9kZXZfdXJpbmcuYyAgIHwgMjAwICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPj4+PiAgZnMvZnVzZS9kZXZfdXJp
bmdfaS5oIHwgIDI3ICsrKysrLQ0KPj4+PiAgMiBmaWxlcyBjaGFuZ2VkLCAxODMgaW5zZXJ0aW9u
cygrKSwgNDQgZGVsZXRpb25zKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9mcy9mdXNlL2Rl
dl91cmluZy5jIGIvZnMvZnVzZS9kZXZfdXJpbmcuYw0KPj4+PiBpbmRleCBjNmIyMmIxNGIzNTQu
LmY1MDFiYzgxZjMzMSAxMDA2NDQNCj4+Pj4gLS0tIGEvZnMvZnVzZS9kZXZfdXJpbmcuYw0KPj4+
PiArKysgYi9mcy9mdXNlL2Rldl91cmluZy5jDQo+Pj4+DQo+Pj4+ICsvKg0KPj4+PiArICogUHJl
cGFyZSBmaXhlZCBidWZmZXIgZm9yIGFjY2Vzcy4gU2V0cyB1cCB0aGUgcGF5bG9hZCBpdGVyIGFu
ZCBrbWFwcyB0aGUNCj4+Pj4gKyAqIGhlYWRlci4NCj4+Pj4gKyAqDQo+Pj4+ICsgKiBDYWxsZXJz
IG11c3QgY2FsbCBmdXNlX3VyaW5nX3VubWFwX2J1ZmZlcigpIGluIHRoZSBzYW1lIHNjb3BlIHRv
IHJlbGVhc2UgdGhlDQo+Pj4+ICsgKiBoZWFkZXIgbWFwcGluZy4NCj4+Pj4gKyAqDQo+Pj4+ICsg
KiBGb3Igbm9uLWZpeGVkIGJ1ZmZlcnMsIHRoaXMgaXMgYSBuby1vcC4NCj4+Pj4gKyAqLw0KPj4+
PiArc3RhdGljIGludCBmdXNlX3VyaW5nX21hcF9idWZmZXIoc3RydWN0IGZ1c2VfcmluZ19lbnQg
KmVudCkNCj4+Pj4gK3sNCj4+Pj4gKyAgICAgc2l6ZV90IGhlYWRlcl9zaXplID0gc2l6ZW9mKHN0
cnVjdCBmdXNlX3VyaW5nX3JlcV9oZWFkZXIpOw0KPj4+PiArICAgICBzdHJ1Y3QgaW92X2l0ZXIg
aXRlcjsNCj4+Pj4gKyAgICAgc3RydWN0IHBhZ2UgKmhlYWRlcl9wYWdlOw0KPj4+PiArICAgICBz
aXplX3QgY291bnQsIHN0YXJ0Ow0KPj4+PiArICAgICBzc2l6ZV90IGNvcGllZDsNCj4+Pj4gKyAg
ICAgaW50IGVycjsNCj4+Pj4gKw0KPj4+PiArICAgICBpZiAoIWVudC0+Zml4ZWRfYnVmZmVyKQ0K
Pj4+PiArICAgICAgICAgICAgIHJldHVybiAwOw0KPj4+PiArDQo+Pj4+ICsgICAgIGVyciA9IGlv
X3VyaW5nX2NtZF9pbXBvcnRfZml4ZWRfZnVsbChJVEVSX0RFU1QsICZpdGVyLCBlbnQtPmNtZCwg
MCk7DQo+Pj4NCj4+PiBUaGlzIHNlZW1zIHRvIGJlIGEgcmF0aGVyIGV4cGVuc2l2ZSBjYWxsLCBl
c3BlY2lhbGx5IGFzIGl0IGdldHMNCj4+PiBjYWxsZWQgdHdpY2UgKGR1cmluZyBzdWJtaXQgYW5k
IGZldGNoKS4NCj4+PiBXb3VsZG4ndCBiZSB0aGVyZSBiZSBhIHBvc3NpYmlsaXR5IHRvIGNoZWNr
IGlmIHRoZSB1c2VyIGJ1ZmZlciBjaGFuZ2VkDQo+Pj4gYW5kIHRoZW4ga2VlcCB0aGUgZXhpc3Rp
bmcgaXRlcj8gSSB0aGluayBDYWxlYiBoYWQgYSBzaW1pbGFyIGlkZWENCj4+PiBpbiBwYXRjaCAx
LzguDQo+Pg0KPj4gSSB0aGluayB0aGUgYmVzdCBhcHByb2FjaCBpcyB0byBnZXQgcmlkIG9mIHRo
ZSBjYWxsIGVudGlyZWx5IGJ5DQo+PiByZXR1cm5pbmcgLUVCVVNZIHRvIHRoZSBzZXJ2ZXIgaWYg
aXQgdHJpZXMgdW5yZWdpc3RlcmluZyB0aGUgYnVmZmVycw0KPj4gd2hpbGUgYSBjb25uZWN0aW9u
IGlzIHN0aWxsIGFsaXZlLiBUaGVuIHdlIHdvdWxkIGp1c3QgaGF2ZSB0byBzZXQgdGhpcw0KPj4g
dXAgb25jZSBhdCByZWdpc3RyYXRpb24gdGltZSwgYW5kIHVzZSB0aGF0IGZvciB0aGUgbGlmZXRp
bWUgb2YgdGhlDQo+PiBjb25uZWN0aW9uLiBUaGUgZGlzY3Vzc2lvbiBhYm91dCB0aGlzIHdpdGgg
UGF2ZWwgaXMgaW4gWzFdIC0gSSdtDQo+PiBwbGFubmluZyB0byBkbyB0aGlzIGFzIGEgc2VwYXJh
dGUgZm9sbG93LXVwLg0KPj4NCj4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1m
c2RldmVsLzlmMGRlYmIxLWNlMGUtNDA4NS1hM2ZlLTBkYTdhOGZkNzZhNkBnbWFpbC5jb20vDQo+
IA0KPiBIbW0sIEkgaGFkIHNlZW4gdGhpcyBkaXNjdXNzaW9uLCBidXQgSSBkb24ndCBmaW5kIGFu
eXRoaW5nIGFib3V0DQo+IHByZXZlbnRpbmcgdW5yZWdpc3RyYXRpb24/DQoNCkFoIGZvdW5kIGl0
LCBzb3JyeSBmb3IgdGhlIG5vaXNlLg0K

