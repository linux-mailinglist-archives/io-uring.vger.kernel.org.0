Return-Path: <io-uring+bounces-10284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BC4C1D1C5
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 21:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00889189C402
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 20:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE0735A153;
	Wed, 29 Oct 2025 20:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="iIWwWLzO"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7F434F48E;
	Wed, 29 Oct 2025 20:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761768012; cv=fail; b=VXGyCSE+be5RNYyZIbkCU+7T455PWX6DoVDSsWFwF9TdnBMq/cHggqBCRWAdd1eaiLKFql44rygNrO2XJJZpOkc/vh9J3vaiVpRIfqBQa2t3L0fZvhtBWwkqSWweIl+GcfN7u1walU7KvZneQZKeOcHr8Yxez9pfOsdgdUq8MkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761768012; c=relaxed/simple;
	bh=2f9IEhQhmsZGku2KJLfS9uaAhbPAIJ6BxY++W7fsjNo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=elYp9xjh/yOaQaYKeDCV0KHrTyCHmR6ppiuRCdluFRUni/4GrOyuOfjH3aEwi4ezrEmtCNexQer3PGS4nJIKmzJaOHLtI9YFYZvANncFQ9ApTjZotbpZEMUQ2ZGCjwgzJM6hrshsQeK/6L8fYsDM3avoh/8nZ/i67Limh6SyQR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=iIWwWLzO; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020082.outbound.protection.outlook.com [52.101.56.82]) by mx-outbound45-81.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 29 Oct 2025 19:59:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OaW6SC/41CsjAyZFjfydZsfn73NVR4BSC0Mtn728YUe3tYRdf6zfN9w9HJhDsTvuFskhIokPvgqNEj2V7KPZUGVcH93XivqFNxWPiZCQ/yaEipmnWPHwad/RH66dYcack7ZGL70DGOvZ92xQgugD41YXfz8pUOGsRzImbwWhKXFpq+yXJg1V5XXby9U47gomOgmNWvvEwhUhiV2kd31OzldcBA5OQWmvC+TjlFD+7prCK+IeApzMCXfAJt6H16i6muS/nYexLb0SqNXp7ParZbpAxyLnuZfqir5KfNkPmonKHIiRcE5tOvsZJzOsOaCRTLZsELTTSiBMFBHemJpWKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2f9IEhQhmsZGku2KJLfS9uaAhbPAIJ6BxY++W7fsjNo=;
 b=URrt+JRo/b+KO8wgBXTyyVv2CpqqkASE6BKSsplEzYSDiL9eChohrmMElzaiIqQvYyaIBNUg387I7p+E0OFsSKLDZsn06bsq3NJhiSJuYDc7WFSo3e5UXBB6yrdpWEXieyOuIBUsJI4mvaKU5vHQYPzn5eXZvrfdiv5NWdwz62H09F3TyvVce9UQGjdQ0zqyFOHWnx16oNFD5VZMm7l6WB97e7JN4a2Q5T0wzYIx3we7D8tOB5gq/ZpSUvFO8dUaR4Q0bqBFgPTsXP3X/0Pkz8RHYIPSIbpAMNo49p0h9i8Fh+HEzmjKQtoD80ho+cAJUj6jmRyz2uYnzhfe5+LjPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f9IEhQhmsZGku2KJLfS9uaAhbPAIJ6BxY++W7fsjNo=;
 b=iIWwWLzOWSog+y7HIMEuYwz2GDBBeAuR1APVzHlNQ0/vL8mVNVZ+P+Uu/PcGuMaMtjfjwFKqguSrGFq9XuyafrIJvJ6HnzIzlPkycV6DkBI+wy4L2wLrGaB5tTDTKTzuVZwSQFVGVHqckJp3HUuxKmeHO8vOpvXsEHiC3cVQtB4=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by LV2PR19MB5885.namprd19.prod.outlook.com (2603:10b6:408:174::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 19:59:45 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 19:59:44 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>, Pavel Begunkov
	<asml.silence@gmail.com>
CC: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "xiaobing.li@samsung.com"
	<xiaobing.li@samsung.com>, "csander@purestorage.com"
	<csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
Thread-Topic: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
Thread-Index: AQHcR5EzYLvJgcs6rEeOcRLohsWIn7TZKf0AgABM6QCAABcbAA==
Date: Wed, 29 Oct 2025 19:59:44 +0000
Message-ID: <3bddaa1e-b4a0-4f0a-8b30-05a2cb8fd1fd@ddn.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com>
 <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
In-Reply-To:
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|LV2PR19MB5885:EE_
x-ms-office365-filtering-correlation-id: 4fefd558-c69c-421f-9887-08de1725b4b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dEI3QUJFV3RVUFRPMGtFWnRJS1B4Y01ZU091aXJYL1BQWExvWDhJaTlUUE9J?=
 =?utf-8?B?N3k2dnpndy9kNG1BOE1uUS9uSjA4dkdUaHlZZ0E3cFFSK2FBNktYZkNHZmdJ?=
 =?utf-8?B?TGVUclV3dHlFRjFZUXZTSStvMHBnZTlYbStJUS9pNytiVnljTG01aGczcU1V?=
 =?utf-8?B?NmZRRnhJVjJITUd0TGpZZTY5b1VWL2xveTAwZkFZS01LRWF3ZHdTcGdqekFL?=
 =?utf-8?B?aWRLaWNid05hZlZDR0JRUitIU3JYeE1aWmFpTE1nV2Vyd0JuR1lzdjdGZ0hm?=
 =?utf-8?B?TnJQMzQ4alFFTGY4dGJOMDB0Q3VDRXpZVkFaa2YzUkJ3MzN1LzlubGg1Uy9C?=
 =?utf-8?B?RmVxSDRJcXR1ZE56Q1JybERhQXBhL00vYUdHMDhHL3FLanhRNTVyWjlLYWFt?=
 =?utf-8?B?VHdDdTJxejU0cXB5SGpsTkg0elk3ZDhLMFhBTjcrSW4zb0ZNeGoxV2p4bEdG?=
 =?utf-8?B?SkpGaHlkUG1GaVBvdmFmdXNOZ3pYQTRGdjlWM00ydlBUd0JOZEZsenRlNHpI?=
 =?utf-8?B?TVQxSGw3SWRXS2dKaGptT3N3ZnZCRzg5NVFlT0dqRXdCdUlmMjVSVjk1ZzZp?=
 =?utf-8?B?WGt4ZzhsWjFhNFFObFI1ZnpkNXI0b0JlSkxmNHhrUTNFREt6T0JhWklyQ0VD?=
 =?utf-8?B?T0FUMDdWTk9qdEIybWptSnNrV01icTNvZHhtQU4xYzUyT3lHTy9VVHFIc29K?=
 =?utf-8?B?QWQzNlN3RGYwNnQybWRCbkhGZWozbkgyR0JIS25XcTlvei94TGFuUW05MWNw?=
 =?utf-8?B?QWlFZzZHV0FDWS9vcTFrR01RZnNiaDBLeXJYNFBhOVZZc2dwTnhzd1h2OE8r?=
 =?utf-8?B?SUZXQlFqS0pLZFh2Qkt1eDdyaDBaejY5UDJPT1VvdVRKYjQzSExIOG9Wa0hi?=
 =?utf-8?B?ZWgxQzBrOU9DY2dnWEdoZGxKR2xNYnRiWFNYL05WTHRURVZYWno5RXBxRzVu?=
 =?utf-8?B?dXNXVjhLSjJibEdSUERnN09Udlp3Ri9VS25La1pOZ0FHSEd1b0NDVlR3YjFG?=
 =?utf-8?B?bWw2OTk3THpuaWdPNDMrNDV6b1pkbDB3dlp3RVNsNjh5UkM0UzZDSVFydTZm?=
 =?utf-8?B?Z1J1b3hhTHB4cjlVeUliSHNINkVUMWNaRUpqa2ZFVkZ0S2dFM1JSWTJQMFVQ?=
 =?utf-8?B?V2I5VlJ4TU11d1FaNkw5blFoMWdhUFdZQU5NbUFJUzdsUmRFelR6cFkwdzFu?=
 =?utf-8?B?UWZZeWF1TmtVNGNML01aREtoMWpvcncvMGZ1T2M0NEUvRjZSZVh0S3BCMWFa?=
 =?utf-8?B?T2d6M3NOcS9UZ3hmbTgzMnpsUFhFR1NaM0Raa2ttRVM3SUg3aW9TN29zR3Mx?=
 =?utf-8?B?bmpEa01icDVQMXFQMVMvZ2NoRXVVQitNcEEvZFVlZjFyaDJLRmorTXJRMC9w?=
 =?utf-8?B?VG11Q215MFZLdHdsYUNBbmtQKzlYS3pUc2svUTJSeTVFWUJ5SHd3L0M1VG13?=
 =?utf-8?B?N0xaazY5cXBiN1M2cnZIZ2hiQ0ZhTk54Q0IxU2VrSytiV0s5SS9IdE4xejlD?=
 =?utf-8?B?K0kxcUpwblpuMkdGUTF5cVhRVlBRczZrMVFjb2J1WmVvdXdxMDViVGUzcWpi?=
 =?utf-8?B?MDBtNGlPQjAxdnhISTBXUmJGdWV3U3J3WnhTNWJtZ0dzaVRNRDFVZ2xJZFpG?=
 =?utf-8?B?aGF3TFg2ZFMwb0hQY0tBT01EcjFESFc5VWx3eE0xWGh3WUd3Z0hrcGFIcU1x?=
 =?utf-8?B?V0lPMjZlaEJNemJEVEQ3enpxSFVLZ0FaWkRSRlpRTnRZcGhvU1p4MTBhRlc1?=
 =?utf-8?B?ZzgrNVhyR2cxV2ZBZ0o4M05reElrNDUvckcwVjM1ZnkyUGRzVnFXbTJhRDZm?=
 =?utf-8?B?eU11ZlIwejVIazQwb0RrRFoyZnhzckFFd0VBMW5SSUZ5UVF6aW5mQVU3MDlq?=
 =?utf-8?B?Zm5Vc1BQZEQ3Z3EwaTlpc2ZxUERoYU1aVDJoL2VpR3dYYVdEZDF3dC91cnJR?=
 =?utf-8?B?MkdDZzNCbHNYbG1jTWorK0pxeXFUckRTUnJ6cEx0ckdnS0FSOEVxU2tmM0NK?=
 =?utf-8?B?YXRQVmhtZ1pwMWJLVkpvZWo2MkIyT0xMSVF6a1VucEgzWFgwby9mY2FaTkFO?=
 =?utf-8?Q?1xw4Ap?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VlpPL3p4a3lpaCsxKy9aWUJrVEtXOXUxYWVjWERBZnlwbUpZYm9aelJvUG52?=
 =?utf-8?B?b0dDWUxrdDM5ckZKSVVtSFJmcjUwNG1KWm42SjVEajhWNmZpMWZpMEVCV3NB?=
 =?utf-8?B?WWt3ckl0S3Z2NnpvcHE4M3Y0c080dDBwS2RJRlZ4UitYaDNaYk1tdXc1Vzlk?=
 =?utf-8?B?VlJXbkpWUmZRTHNkdGZ0N0xQWm02Q0Ntd0dpcjlHQXBSOWhNQ2gzNFZJYUV3?=
 =?utf-8?B?bU5vUmNZUFAvaEtNeitBWktwMWdnTXY1a0ZYcURtRmhsUjlMOGhVODZjbW9n?=
 =?utf-8?B?WXBGTXNJVVM0SFZFRm9uK0FBT3FmQWg5Y3JQcjZTOVBMTEV6dlp0clM0WGNi?=
 =?utf-8?B?NmtrRWJCZW81N1hUNUJiZ011SWxjai9rUlZwRkd1Q28vMjJXZ0JaMFF5VEpN?=
 =?utf-8?B?Y3UrTWNLZXJNU0drYWlzUHZvQ2RzSnN0dTVFV2NrK1AxbUFTRWxFSFFobnM2?=
 =?utf-8?B?bEVCRENWTVdqZGtnRDJqZXMyUkJaZG00Y1dXNnFpd1VTQ0Z3NnljaW55WHNk?=
 =?utf-8?B?QmhmV2JDRFlFT3pxVkcvT2UwU3hPOGVqUFQxWDN4cG9TQVBTZWtyQzFKR1dI?=
 =?utf-8?B?Y3ZDU3pWcnlWODdoNmttSnJVL2UxQ2RqaSt2SkxqVlZTMWNGM0o1SElkbisx?=
 =?utf-8?B?TGhwRmszUkhWL1JOeTdYSnJFdjFiVkN2YTV4UU1FejA2bUM0eGozN2dIR3Rv?=
 =?utf-8?B?SFhETGQyekx4a1grMVkxV2tWcHErQTdYbys5WjQ2amdQNlp2RGg0TWpyKzQv?=
 =?utf-8?B?S0w1SHordWlOZm5DTDNIWGVXMVVlcm1kWktBSGVNdjlKYk1hVnR2SXJCWU9T?=
 =?utf-8?B?MUs3OFo3SjdVZk5JUlRYbDBYVXVvKzcrYTlCNHBtaTN0amJhVUYybEUyRnZr?=
 =?utf-8?B?bnBHNklQQlFFQWJQVE9tZnA2S2NJSWZac2pxRExTU3pRNWxFMjFNeFRVU0tX?=
 =?utf-8?B?bnVOQlAzWFgwVTRXMWw4blo0eXhMc29RVXhnWEtVSFJ3dUg3YnFIMjN5SEl6?=
 =?utf-8?B?MjJ1c3hGUy9FeW1US1dqaUpSYm4wdnhXZWtEUW5lWFpXMTZ6YlgrWjQ5QWpt?=
 =?utf-8?B?V1dYMkNSbW10RWtTTVcwd1N4RzVrTHB2Mnd4KzhJakhndkRad2ZUYnhPTU03?=
 =?utf-8?B?OHIrSkNEYzMrM24xeFJNalFjWWJhMXUySWo5RVJxYWV4MEpQdHZrWDdUWmhi?=
 =?utf-8?B?ZUtlY2c3RlFnNWRyeko4SUtYdEdyR0lVVDByeFZQallLVTFDZlpVcXBLTlZV?=
 =?utf-8?B?TEc1RGs4cnhHK0VaRThKUTJiTU5jbkpCMXBCalZ0ZDkrc2xJTndCQ3NwOEZT?=
 =?utf-8?B?VXVrdzVvUTFHakVHbVVNMnBUUE9qRHFlNXVtN1VLZHpNdlRPRDMzMXg2MGps?=
 =?utf-8?B?dU0yTWJkaG45UVRORzZmNmFsSThBVHJaN0V5dVE1NTZMc2pvRDd2dHlib1Fp?=
 =?utf-8?B?MmJZM3IwNC92STV3YU16M1djU3NvMno5NFlHOS9PMTd2SmdPRTIxYmJJdkZy?=
 =?utf-8?B?N1BGV29uYXNIcVdUcHRxY0NtczZuc3NEZDBkUmdKc0N1azF3U1E2UWZRbk1D?=
 =?utf-8?B?VmsyUUduQ0RCT0M2Y2phQk5MMTRJclRKb24rMUdrS2ZyMi9kdndBeVRiam1r?=
 =?utf-8?B?VDZxVXhvMFFyL3l0bGhLODNRbG9yVEJWOWE2UDNsTXk4WmlZYUFGOUdCZUcz?=
 =?utf-8?B?TjNuUjNCUVB5U0dLRU5PYU9RdWNMK1Y1OXZYVlBHYWhQRkZFeGZJTWJnSEls?=
 =?utf-8?B?RTAxUUxhWnQzVCtWcVJUWjlaRU1LR2QwYWRweG9VVitvYnZ1b3BMNnd0M2Yw?=
 =?utf-8?B?L29Td2p1UC9XRDU5cTRKL2VVRVZzY1ZFZ2NKeVYyam81Qmo5Z3NubEw2Vks4?=
 =?utf-8?B?WStHUWEzdWovT0VTRURtVUhwbFBuNmdpdkI3SWdESlA1VDhvTXVodmN4N3Mz?=
 =?utf-8?B?d2VldCttZHcyemptSFZWeEY3NkZMd0RqSmZOcjZpelBpS3F4SkZPeTdPTE5E?=
 =?utf-8?B?QXNpNnFaSkxyU1ZERkJURDRTU3BaTVlCdXRGRzI2TTlnNTlSVTdISllvWHJp?=
 =?utf-8?B?Y1loUVhTZUxHcjdQQ1Ixb2g2STVhMm5jYzUyN1ZlUzdTd3c0RGsxOUprNHR4?=
 =?utf-8?B?UStIQ0hpamg4eW5PYnlzWEdBTUZsejB0UGpmUk9WeU5teXZESTllbUxsZHU1?=
 =?utf-8?Q?gbFT86OUe4/aBX67NXPe9Oc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36B4260AC205DC468EA3B89999544763@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yUxwYr949r+rq9TlU9Z1Kf1dWXiUI7JyiQzlyRE2K0biGfdqyM7x/20mDOKBgOIRD+9fpgDqqJvJMale8zyY3ipQn2SQwNsLQg8SQTBojn9Ur/y6dGChwIHtZQoy1Jhg6pzhRBxnNu70Egf2X7/TZid9IRNqokquo0pBhpHs5kWJnpKErkzTdVknm+YxiW+57FMp8OZlV8dA1O8Gnl0FH444ePHMQeNTgkx4j2JOPACZGpgb+ILwlpdQG4AykvImhU/yT8P6AD+QEcGJvCB0feXw5r10O9nWkpys7G/eK0yVwkF6BtVZBX2WRAPGtUd169pe68hg5yRJOPskaIIFidQ7297StywUDWPs8/WzcJpmsTSr7HBIGtLT7wxfLIrl4ayzOOnmZ2bSqLOVGOOQxLS4zfsuTkaeHSsRoRW5gZfpP7h53pVxG0hJOAMYLw2cBUgBEOMQFwlP+nbr4lC62aWZ6McnCoP6h/Q36/YX0jDtkTAQkuUrGowliB+eX7KsjNhHYqatKBfq+mpzTY5H8HWre7IQO7QM2wLVUHvgs/t3TRyMcfOnuWucIKruETb6pPkU1eeqgvu0ZmjTtzUDzCkwk9yZivkHi4Tzk8pSXoCIyO8Q2YIWhkr3op/GCH0asWGjJfa36gMKCiTffdlC8A==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fefd558-c69c-421f-9887-08de1725b4b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 19:59:44.5693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 12AF83ns1OGfA/xdrjhaZ9iK5HW75q0kbdyYu/n0tPaIYnXn12QmFaZxdgkShDlY+qkIw5/B3wVEDid0FFWhqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR19MB5885
X-BESS-ID: 1761767987-111601-8799-40264-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.56.82
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWloZAVgZQ0NzAzDTRMM3SLD
	nZxMTI3CzJxMjA0jjRzMjYxDg10ThJqTYWAOsRewdBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268566 [from 
	cloudscan11-3.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTAvMjkvMjUgMTk6MzcsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4gT24gV2VkLCBPY3QgMjks
IDIwMjUgYXQgNzowMeKAr0FNIFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVuY2VAZ21haWwuY29t
PiB3cm90ZToNCj4+DQo+PiBPbiAxMC8yNy8yNSAyMjoyOCwgSm9hbm5lIEtvb25nIHdyb3RlOg0K
Pj4+IEFkZCBhbiBBUEkgZm9yIGZldGNoaW5nIHRoZSByZWdpc3RlcmVkIGJ1ZmZlciBhc3NvY2lh
dGVkIHdpdGggYQ0KPj4+IGlvX3VyaW5nIGNtZC4gVGhpcyBpcyB1c2VmdWwgZm9yIGNhbGxlcnMg
d2hvIG5lZWQgYWNjZXNzIHRvIHRoZSBidWZmZXINCj4+PiBidXQgZG8gbm90IGhhdmUgcHJpb3Ig
a25vd2xlZGdlIG9mIHRoZSBidWZmZXIncyB1c2VyIGFkZHJlc3Mgb3IgbGVuZ3RoLg0KPj4NCj4+
IEpvYW5uZSwgaXMgaXQgbmVlZGVkIGJlY2F1c2UgeW91IGRvbid0IHdhbnQgdG8gcGFzcyB7b2Zm
c2V0LHNpemV9DQo+PiB2aWEgZnVzZSB1YXBpPyBJdCdzIG9mdGVuIG1vcmUgY29udmVuaWVudCB0
byBhbGxvY2F0ZSBhbmQgcmVnaXN0ZXINCj4+IG9uZSBsYXJnZSBidWZmZXIgYW5kIGxldCByZXF1
ZXN0cyB0byB1c2Ugc3ViY2h1bmtzLiBTaG91bGRuJ3QgYmUNCj4+IGRpZmZlcmVudCBmb3IgcGVy
Zm9ybWFuY2UsIGJ1dCBlLmcuIGlmIHlvdSB0cnkgdG8gb3ZlcmxheSBpdCBvbnRvDQo+PiBodWdl
IHBhZ2VzIGl0J2xsIGJlIHNldmVyZWx5IG92ZXJhY2NvdW50ZWQuDQo+Pg0KPiANCj4gSGkgUGF2
ZWwsDQo+IA0KPiBZZXMsIEkgd2FzIHRoaW5raW5nIHRoaXMgd291bGQgYmUgYSBzaW1wbGVyIGlu
dGVyZmFjZSB0aGFuIHRoZQ0KPiB1c2Vyc3BhY2UgY2FsbGVyIGhhdmluZyB0byBwYXNzIGluIHRo
ZSB1YWRkciBhbmQgc2l6ZSBvbiBldmVyeQ0KPiByZXF1ZXN0LiBSaWdodCBub3cgdGhlIHdheSBp
dCBpcyBzdHJ1Y3R1cmVkIGlzIHRoYXQgdXNlcnNwYWNlDQo+IGFsbG9jYXRlcyBhIGJ1ZmZlciBw
ZXIgcmVxdWVzdCwgdGhlbiByZWdpc3RlcnMgYWxsIHRob3NlIGJ1ZmZlcnMuIE9uDQo+IHRoZSBr
ZXJuZWwgc2lkZSB3aGVuIGl0IGZldGNoZXMgdGhlIGJ1ZmZlciwgaXQnbGwgYWx3YXlzIGZldGNo
IHRoZQ0KPiB3aG9sZSBidWZmZXIgKGVnIG9mZnNldCBpcyAwIGFuZCBzaXplIGlzIHRoZSBmdWxs
IHNpemUpLg0KPiANCj4gRG8geW91IHRoaW5rIGl0IGlzIGJldHRlciB0byBhbGxvY2F0ZSBvbmUg
bGFyZ2UgYnVmZmVyIGFuZCBoYXZlIHRoZQ0KPiByZXF1ZXN0cyB1c2Ugc3ViY2h1bmtzPyBNeSB3
b3JyeSB3aXRoIHRoaXMgaXMgdGhhdCBpdCB3b3VsZCBsZWFkIHRvDQo+IHN1Ym9wdGltYWwgY2Fj
aGUgbG9jYWxpdHkgd2hlbiBzZXJ2ZXJzIG9mZmxvYWQgaGFuZGxpbmcgcmVxdWVzdHMgdG8NCj4g
c2VwYXJhdGUgdGhyZWFkIHdvcmtlcnMuIEZyb20gYSBjb2RlIHBlcnNwZWN0aXZlIGl0IHNlZW1z
IGEgYml0DQo+IHNpbXBsZXIgdG8gaGF2ZSBlYWNoIHJlcXVlc3QgaGF2ZSBpdHMgb3duIGJ1ZmZl
ciwgYnV0IGl0IHdvdWxkbid0IGJlDQo+IG11Y2ggbW9yZSBjb21wbGljYXRlZCB0byBoYXZlIGl0
IGFsbCBiZSBwYXJ0IG9mIG9uZSBsYXJnZSBidWZmZXIuDQoNCkkgZG9uJ3QgdGhpbmsgaXQgd291
bGQgYmUgYSBodWdlIGlzc3VlIHRvIGxldCB1c2Vyc3BhY2UgYWxsb2NhdGUgYSBsYXJnZQ0KYnVm
ZmVyIGFuZCB0byBkaXN0cmlidXRlIGl0IGFtb25nIHJlcXVlc3RzIC0gdGhlcmUgaXMgbm90aGlu
ZyBpbiB0aGUNCmtlcm5lbCBzaWRlIHRvIGJlIGRvbmUgZm9yIHRoYXQ/DQooSSB0aGluayBJIGhh
ZCBldmVuIGRvbmUgdGhhdCBmb3IgdGhlIDFzdCBpby11cmluZyBwYXRjaGVzIGFuZCByZW1vdmVk
DQppdCBiZWNhdXNlIHRoZXJlIHdlcmUgb3RoZXIgaXNzdWVzIGFuZCBJIHdhbnRlZCB0byBrZWVw
IHRoZSBpbml0aWFsIGNvZGUNCnNpbXBsZSkuDQoNCg0KVGhhbmtzLA0KQmVybmQNCg0KDQo=

