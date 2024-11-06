Return-Path: <io-uring+bounces-4511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1872E9BF672
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 20:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C691B20C24
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 19:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCAA20968F;
	Wed,  6 Nov 2024 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="PCQfEn+a"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E821920967F;
	Wed,  6 Nov 2024 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730921328; cv=fail; b=dL1pQCCOLN/8sCn+7rUc3KFwzsDZjp6Gk4LMm9fuuQ9OC4Tp9CO05EqpymMLReQCyvFa4X4dfTNulyQhZjQr9xHKweNQ+ATD/SRE23NQSk2BiwSIAiqLOcHHP7pxQFVSuGCLc2HMqWZGgcYcVbRW2MV4tQ/8XMX1hYEmo1L/yo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730921328; c=relaxed/simple;
	bh=bC6YtYLh4Xuba/Dgfmsn+NgK+5H+Yeo57/Z1NUXSW+Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tEZAnfk2JirO8k6tEiIyRO1VEPyCGDT8lPLgMTSz2dyrKlX+boWDbHOYs6rq7E/ppmH9F3xevUIa2ZXRgOAeTEo4mRBnqrRcmV+NSGdgO5pPIpNwwGn5nsraW2YKMtNk9OHZJGnB0SXhSwd4Gc6923zC09J3mxxQGtcBUn4a8ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=PCQfEn+a; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42]) by mx-outbound19-17.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 06 Nov 2024 19:28:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+9sCmIvyN0OmmN2J1xZ3YRf9iojJUWAnBVIlSr2nUByzpRvjeqoXtG/5jLwYUQ0nAf5S1eDGiNVw1rvCt0rTG24VbChoGjs2S6cJbj2rw/IPqFVMaEMMR7Sr1tVy1+N30W+qms/sMvoVU9d+QzvtmUq415dXZA/adSY8akvbMNJ9t/6pU8lUmAQTqJB9PppGfhyzGXOdtpbrWRccMEQ8WOgBxKeV5VWCe4WoFhbv2GL/JaHzTXduPeC6O43Yv5pmFftYEv8gm8MISBVJS/XFNHj2OHAuhL3ui3Srjz+t89X7DqixnINuF7OSKA13kF+qQXq2Dy38RMBEXQq4irxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bC6YtYLh4Xuba/Dgfmsn+NgK+5H+Yeo57/Z1NUXSW+Y=;
 b=YLju/rV/VXIp54v74L3bu4enP/Bjf1tMtwFmrO9qfE9G+AVYG0CpjM0RB45YoQTs475djLMfEGWHf4sXDjZK3HU9KZftuu/0sHOgG7MFl0mGBcQ2a9aUeyOKgZDM7+hE2kxG6hPS1Iy/IsZGzGVTLbM7+NJ1xSOVmwKrwN0+KgjIS35aMeqs3xSNjeZF66G3XM+tEr4zy1RexGEfvedirkotheZ5n7KooQvIbvU3GX9HO6lNlb30URWqJQlUogomtHklfMJtjgKraKKur7E7fTcj00eIf7rBkqBCpy0FWuOtsU0Rcsh8IEiGSps7ZvptzYp+l2dk3/lGsUDDzWqtzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bC6YtYLh4Xuba/Dgfmsn+NgK+5H+Yeo57/Z1NUXSW+Y=;
 b=PCQfEn+aoYSnD1NIbCv9hI83V7vo0mqegnnxSAX3Z8FG2PNyQa72GB4wZYwog2JBGQFQa+NUm6ND/3Drv38hTuj6Z5gR30UkCEasfX7Z5+JAk53c0t4JXkI7LjurET03cYaNguN3XuCJUg42y4rC3LzHI7Oh308+VZKUGzIUhSc=
Received: from MN2PR19MB3872.namprd19.prod.outlook.com (2603:10b6:208:1e8::8)
 by BLAPR19MB4307.namprd19.prod.outlook.com (2603:10b6:208:254::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 6 Nov
 2024 19:28:31 +0000
Received: from MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911]) by MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 19:28:31 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi
	<miklos@szeredi.hu>
CC: Jens Axboe <axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, Joanne Koong <joannelkoong@gmail.com>, Amir
 Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Thread-Topic: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Thread-Index:
 AQHbH18k5DcsQ3cILESkRv/PhXIC7rKmYjoAgAFtMICAADBNAIABbwGAgAAUGgCAAUKPgA==
Date: Wed, 6 Nov 2024 19:28:31 +0000
Message-ID: <d86483fe-8753-4e22-bd82-ce53ceb4b344@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
 <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
 <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
 <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
 <1ec098a7-8c69-4d9b-8d81-ccb0f4c35904@gmail.com>
In-Reply-To: <1ec098a7-8c69-4d9b-8d81-ccb0f4c35904@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR19MB3872:EE_|BLAPR19MB4307:EE_
x-ms-office365-filtering-correlation-id: cd1161b3-7dfb-4589-5a9a-08dcfe9932c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZTRSdUxOL0VRakFhNGVmTjViekJ0WkltTkFjSkk1czlVeW90eUtDVDlKK3Yx?=
 =?utf-8?B?cWF0ZFF2WkVqaFp2NExtWEc3R2FGZnNTc21yWUl6WWhGRjBhN2dnRFFBQXlx?=
 =?utf-8?B?a2dudE1VR2pCcHQzdjYvODNSN3dMclA1S0VyV1c5YmYzSDZpcHVCZVJQUFFq?=
 =?utf-8?B?dFdjc1FCeGRmY1IvenVlSjBzc2RhbEtrbzJrZGtnOERVUzVZVW1KeDlKRzV2?=
 =?utf-8?B?WEIzbnRKS3RCYmg0dml3ZzVla2JsbWF4MEV4b1lKZUptTjBkbnVDOXhmQU1O?=
 =?utf-8?B?U2tMbjVkeTlXcTBBOWtQN0d6b0gvam5ZZXJGTTh5WnNBV1ZXN005bUp5Wi82?=
 =?utf-8?B?U2lyQ2ZUR0JNL28rbFVVT0JsbVZRVWxiK1JtSjJRYWdIbUtLWUNQQlFPMHly?=
 =?utf-8?B?MzNYd3VvbmF1bXNERzRZM3JQT3dEQmlNbjhHNk55MWVVc0piTnZ4OVpSbmhj?=
 =?utf-8?B?eWRUMXNDSzZvejNYUm9udHNpb2dwUU1WZjlHUmpoTVdMSmtvTll3dEpJWmJq?=
 =?utf-8?B?VjhxVzlDL2NUQjl0TGZyUGdmOTdaMTBrSHRMcEJMZ0Q4ZUxvMmt5YmxVYUxJ?=
 =?utf-8?B?TmczNWVwMHRVNnoxeXl5aEExVWUrMzVqZHFSMHR2WnNSMkFCQzNwYTh2bjAr?=
 =?utf-8?B?U0NFZ0VxQWNXQ2JDN0trS0pXVHVmaVViczZ4Qi9TRTlkcTBWeVhaN0tJdk81?=
 =?utf-8?B?RGF2ZDJGUjN4eUJOYXl0Rm4wVnBvc2YzTU9jWGNJV1Z3ZDlQYzZmZkdYZWVK?=
 =?utf-8?B?Z3ZnNU15UFNEdVMwZ2NhdjBnNURSaWZjaElFcVAyMml2alJ6b2Z0azJqMkg5?=
 =?utf-8?B?OVloUjhiUTlKRXM4Z1JUdG1YcDFZdmRuZW42K1haRzRqdlcrNWZ3THUwblR4?=
 =?utf-8?B?a2pLVnpwYk9PYUp1a3dmOElENExxRVZRcEgvVGw3WGp1ZXlVeTQwSXhXZWVi?=
 =?utf-8?B?cmdDaHJLQ2ZNbVpPYjExa0hhZ21BaFczUzlUR2FXTzJsT0NCV3A0V3JRRWZr?=
 =?utf-8?B?S2VHQTdzNjdFRStDdWluUFB1cm1HZFJzWTlvUHAwWGpYTitmSEZreG9pamRx?=
 =?utf-8?B?c1cwWFpveWJKS0QvTHBLTllSL2JxNGkyalpLelZyRkI4SSsxWEs1RmlXOXFF?=
 =?utf-8?B?VGl2eFJXVktwaHVhRzFmZGZJNnBnN3Y4WWZBZThINm1FRzdScFl1YWJ1YWV0?=
 =?utf-8?B?RlVlNWZ3SFFMM1RjUW1xMTRzejFGTmY3eFpnWlQvZXFmYnEzSjJtY0tHbGxR?=
 =?utf-8?B?ZzdYNXhOdjB5M2tQUmxUS2x6ZmRSalBnS2M5NGYrUlVVYnp0VTZaTlRtL1pj?=
 =?utf-8?B?ZEkzbmVZWXhtUTUrMjNVQ09oN05iV2x3dVc0OFBIeVNjVXh5R0JJUWNkR1U5?=
 =?utf-8?B?VXVDc2dxdzBpR01NK0RKdXc0SE40TnJDeHl3TXRiUGdQajdmUzRBQUxvSms0?=
 =?utf-8?B?NXhaVWNuaHRpcFdrOWhObmhkSUw3TDZaUFZqRE1vSFduNGpKZ21SVWQ5UWdI?=
 =?utf-8?B?ZHQwNTZ2amN3dGhTeVppUjZiaUdGUXlXbWkvbzdYY3lndlhvSUpST3NSdmhY?=
 =?utf-8?B?aHVPVDlxKzk1L3hQemhxdFFvejY2US84cndEekNwOWJGc3k0VmNvV0pYcWNO?=
 =?utf-8?B?NlIxazRqVUk4Qk9vb3czL2Z0azdncXkvcitqampIRXo4eEU1YzN0amFHTTBi?=
 =?utf-8?B?Mml5WWsyeU9aY2xIa0YzbmhmRDdSYzFWNnVadklyeGJGWlJJWm9xT1Z4alU0?=
 =?utf-8?B?L0Uwc01JR0EzZlVxaEpuNHZVSUQvT2xvUEEwbWhoaTk5S2lWTzFRMFV0aGNC?=
 =?utf-8?Q?oBFyWjN+pndXDSpMbvS8cfOtPi89gvAZOKhYs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR19MB3872.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dXRSdEYzWlRrV0xGSlcxN3c1dG5nMkpTM0xkRVdBcHlUY3VBeTBvZmlXWCt1?=
 =?utf-8?B?ejVOOUJtQUlLWXBlK3JPYjRBN2xkNTJpZm9kbVh5VEhVR0FrZXQ3ZGV6ckQ1?=
 =?utf-8?B?cFgzbzk2d1hqOGtFMmdTbmsycmlzZEgwQi9FS2lwREJpYUROOTNTNWRKQ2J3?=
 =?utf-8?B?TFBkV2ZDZWNjaXM0RWd1YmoxSDZmSmxKWFg0M2ZqZy9FKzhuZDJUOHJXQkRF?=
 =?utf-8?B?TDM2Zm9lWHozZUd2U0srN1orTTc4bFZjNThscXkxWUptMWFLS0NySzZKZC93?=
 =?utf-8?B?TGVWeU5uTHg0SHMvaG1lYlpiOEsyM203d05pNVBPaDNFZGtvS0lEQzNhUmxj?=
 =?utf-8?B?SHRlLzJ3OVlUUHJhbkpmSkJmeE1IbU5wUVU2WlhuaUJhYXpiTFBiMzBTNWkx?=
 =?utf-8?B?M0xiSmxXYXVWZmM0dkVIU3VvUDNodG80c0NXNXlXZkNSY255WVZtWkVBREpI?=
 =?utf-8?B?OFdTVWhZZktvMksvaDhBeHprMFl3UVZCTE1VQytWYktzUEpnMkNEb3dVZERO?=
 =?utf-8?B?d0FEUlR0ZUlVeFJSZ1p0cHQzMEtJSG5sSHVrY0ZuMk5rb2tJRlFSbUo5ZnBj?=
 =?utf-8?B?MERVM1RpTE1Gdy9pRW5jQXZtNU9QNjVaK2tEOEVucndZbXhPdkJZZ2RzR2o5?=
 =?utf-8?B?S2lrbExYZHNXQ29kYUxCWVZUQ0JMWnJJS0FmTHltYzQwT1N6YmhOU29hU2VP?=
 =?utf-8?B?Sk9wR0k2OXg1ejlrMWROUmZQRWlFN3NGWmlwYkxuT01ZeDVOWFQ0UmpQM1JF?=
 =?utf-8?B?Z2JWQ09oSnIvZkk0U0dPNjBFdWZpVDltVllxaWZBNTE4cFZkbVN4dXd5emgy?=
 =?utf-8?B?cklLSUNIaUFSVFJmaW5NZHFlVklhRDBWR0VyTUZJNkMwT1ZEbDlnVDY0Z053?=
 =?utf-8?B?aUhHRkFhR0R3Z1l1Y2NuVVZma1FOZDUzdFVwVFN4d3JzODYrcllURjdpemVB?=
 =?utf-8?B?bFd5YUhxYlVtNXNyelhaTFJwb2lYQmNqeVZjYzR6UzBmRDZ3TVp2cXMvd09a?=
 =?utf-8?B?RGhmNE5UcFZaMGJ2QU41RXduNlN1L0o0bWc2WWVwMmdtUjdjOXVKUjBWSWVm?=
 =?utf-8?B?c2p4NkcwaHJpaVhUTGNSMmp3WEZGMEFGMEUyV3F2a25xS2tlQWw3VzRkWlJl?=
 =?utf-8?B?bGtpNEpKZzVxSDAxc29RQy96MGlMSDJ1eWRWMG1HZWVtVGUzdGY0aGpNY0lK?=
 =?utf-8?B?SHNCbHZ2RnpGbmZpUXFRWnZ4aVZOWHg5ckhTUGZQTCtaYWwyVklyc1kxNVIx?=
 =?utf-8?B?Qllvek1NYlNFcVIwTWI2TW9VaTlGN2dQdGhTSVR0SFFtUDJXUnY2UXk1aWxk?=
 =?utf-8?B?aDJsYjNSWmF5bmI3YlBRR2pwL1gyTWdNV1RuNUphRnhybkhCMEhWMG1YdDgr?=
 =?utf-8?B?MlBFQnRtTmlncWxxaEE0SERadkVHNlVoZlVMU1R3dWFYc09NZVFjWXppOTF4?=
 =?utf-8?B?eG1EUlcyVytnQkZIYzVDMVpaSTBEbXpiNHRrelFxNEFjVXFDZDh2czBvWmZS?=
 =?utf-8?B?N2dELzBuVnhIdWY3RWRXWWk4bmVaaSthSWN4WUE2N3RtUFcyR21tQmwrOEEy?=
 =?utf-8?B?amlXVnN5WkFLd3RGNk02c0tBenoxZFR5L2pSUy9hNVg3ZWtzWlFvZTk5L0dP?=
 =?utf-8?B?TSt1ekNZbjFmRFdCOW5PZGRNeHZ0aUNDM3pYSEpkalhZNGJsakhwM1Jua3NL?=
 =?utf-8?B?aWZqK3h5WWRFRFplc0ZReDdzeTlNTGM4WXVCUm9lNC80dVQ3NlprNFpQMlhE?=
 =?utf-8?B?ck9YYVQyMXB1NzE2Zk43NXE1dmV3UmMzbmJtZzBpWGErdEdXcElkOHhOQ2o1?=
 =?utf-8?B?cHJ5eGQvOWNuNE56ZE1ib1VyMjlpVHJvQmNmSEkyWEJJREx6TnNZUUtreFla?=
 =?utf-8?B?NGgwRCtjUUwxUUIyMmxTcUlkMnRnWnhPeXBlTGpVNHdWRHlickVuRkVzUVEw?=
 =?utf-8?B?NTcvYXRiWWJ0ZHdRM2ZocVFOcVVtb1lpOUZsQk5TTkFXaFM4anRPcVoxMW83?=
 =?utf-8?B?emNoOGsvSmNUcEFQZnhubGN2eXdjUWtUbDd2Q1NwQVFsZ1RUcGxQeXJEV3lV?=
 =?utf-8?B?NzVCVEhNMDNvd3NLY3BiU0daK2gzYXI0S2cxN2QzVisvY1F6cjRrNnR6Rm5p?=
 =?utf-8?B?ZUcvUk1pRWtmdnJjUzBCaFRTbWFDTU5ia09zM2VUdDYySkQwMjZWRmJjRlgr?=
 =?utf-8?Q?1Op7lsfU/3+Q96QY68VkcWo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA3C9AB88707B34F9AD59A69F774C436@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BTjAABm5hNZU5vIe8um5BDTbuS5aHBZcueA+nWKNatigEPhP38QYEsv0HESKsu9Pm/ICkGjBHdbkZrZYwkxFkoxCnhkIoI1fijBpm1kcWBAfsCetUEli/TtUI+FSNQFEyWXSzO2NL8lB04xO8HiaO7oi1akv3gzZO+dxwjLnRNWWQTpQlAFIQawFzzKIF2mB/UqYAp8loljIuxGOtOuwWlzEeVXZQf+rLRWLPqECN0+S+BZR/rly1OkDThoZX9KQAtVw0cX4GJoXIStrpkj/EaGy/IzOPpkzck6BdRy8EOkFt21oo7TSYZPkZDZKOusH/iD75MgQmJWPAIKJoM3jyQhutRGCHgcwwF3tKxKzgyg3oH+ZxvE0BtA+V5CQm/IgUdN+C/Rb/+/O7qnvaCDjv6L/ApAAHLTrgXS5L2Zk6XYYt689JJkiZxlACkEL7YGmWG5h4JCzLKGmRnaQ45rNtxM2bWBmXU0Cd0g8wIk0Y7uZmvPGsc1VZu0lzWHmwWKOD7LcTujuutfUd97YbfOlPx7/OCsmgaPX08sKt37yF1vOUXx5HnoUEGJLRTM6BNCDIJKPj87mtSd95jS8RF8bfSWKl0JwTBNrSHs1YH59SzQJeJXnVqrUGx0krzvVf4VK5EInRwPfaChXjEcraKAbKg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR19MB3872.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1161b3-7dfb-4589-5a9a-08dcfe9932c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 19:28:31.4400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xYIGAbOYEhpJ9xm6Mtzezlw8qmgwHKjySmMqcIPw6ykb3KRzGOCoa+s1kJPGemZl9xAzrCXXJscVzqYO8PsRzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR19MB4307
X-BESS-ID: 1730921314-104881-26888-14239-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.57.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYmBmZAVgZQ0Ngi0cTc2MzcJD
	E5Jc3AwDQlOSUl1dTczMLA2MAgJS1NqTYWALCxPDFBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260247 [from 
	cloudscan12-8.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTEvNi8yNCAwMToxNCwgUGF2ZWwgQmVndW5rb3Ygd3JvdGU6DQo+IE9uIDExLzUvMjQgMjM6
MDIsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4gT24gMTEvNS8yNCAwMjowOCwgUGF2ZWwgQmVn
dW5rb3Ygd3JvdGU6DQo+Pj4gT24gMTEvNC8yNCAyMjoxNSwgQmVybmQgU2NodWJlcnQgd3JvdGU6
DQo+Pj4+IE9uIDExLzQvMjQgMDE6MjgsIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPj4+IC4uLg0K
Pj4+Pj4gSW4gZ2VuZXJhbCBpZiB5b3UgbmVlZCB0byBjaGFuZ2Ugc29tZXRoaW5nLCBlaXRoZXIg
c3RpY2sgeW91cg0KPj4+Pj4gbmFtZSwgc28gdGhhdCBJIGtub3cgaXQgbWlnaHQgYmUgYSBkZXJp
dmF0aXZlLCBvciByZWZsZWN0IGl0IGluDQo+Pj4+PiB0aGUgY29tbWl0IG1lc3NhZ2UsIGUuZy4N
Cj4+Pj4+DQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBpbml0aWFsIGF1dGhvcg0KPj4+Pj4gW1BlcnNv
biAyOiBjaGFuZ2VkIHRoaXMgYW5kIHRoYXRdDQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBwZXJzb24g
Mg0KPj4+Pg0KPj4+PiBPaCBzb3JyeSwgZm9yIHN1cmUuIEkgdG90YWxseSBmb3Jnb3QgdG8gdXBk
YXRlIHRoZSBjb21taXQgbWVzc2FnZS4NCj4+Pj4NCj4+Pj4gU29tZWhvdyB0aGUgaW5pdGlhbCB2
ZXJzaW9uIGRpZG4ndCB0cmlnZ2VyLiBJIG5lZWQgdG8gZG91YmxlIGNoZWNrIHRvDQo+Pj4NCj4+
PiAiRGlkbid0IHRyaWdnZXIiIGxpa2UgaW4gImtlcm5lbCB3YXMgc3RpbGwgY3Jhc2hpbmciPw0K
Pj4NCj4+IE15IGluaXRpYWwgcHJvYmxlbSB3YXMgYSBjcmFzaCBpbiBpb3ZfaXRlcl9nZXRfcGFn
ZXMyKCkgb24gcHJvY2Vzcw0KPj4ga2lsbC4gQW5kIHdoZW4gSSB0ZXN0ZWQgeW91ciBpbml0aWFs
IHBhdGNoIElPX1VSSU5HX0ZfVEFTS19ERUFEIGRpZG4ndA0KPj4gZ2V0IHNldC4gSmVucyB0aGVu
IGFza2VkIHRvIHRlc3Qgd2l0aCB0aGUgdmVyc2lvbiB0aGF0IEkgaGF2ZSBpbiBteQ0KPj4gYnJh
bmNoIGFuZCB0aGF0IHdvcmtlZCBmaW5lLiBBbHRob3VnaCBpbiB0aGUgbWVhbiB0aW1lIEkgd29u
ZGVyIGlmDQo+PiBJIG1hZGUgdGVzdCBtaXN0YWtlIChsaWtlIGp1c3QgZnVzZS5rbyByZWxvYWQg
aW5zdGVhZCBvZiByZWJvb3Qgd2l0aA0KPj4gbmV3IGtlcm5lbCkuIEp1c3QgZml4ZWQgYSBjb3Vw
bGUgb2YgaXNzdWVzIGluIG15IGJyYW5jaCAoYmFzaWNhbGx5DQo+PiByZWFkeSBmb3IgdGhlIG5l
eHQgdmVyc2lvbiBzZW5kKSwgd2lsbCB0ZXN0IHRoZSBpbml0aWFsIHBhdGNoDQo+PiBhZ2FpbiBh
cyBmaXJzdCB0aGluZyBpbiB0aGUgbW9ybmluZy4NCj4gDQo+IEkgc2VlLiBQbGVhc2UgbGV0IGtu
b3cgaWYgaXQgZG9lc24ndCB3b3JrLCBpdCdzIG5vdCBzcGVjaWZpYw0KPiB0byBmdXNlLCBpZiB0
aGVyZSBpcyBhIHByb2JsZW0gaXQnZCBhbHNvIGFmZmVjdHMgb3RoZXIgY29yZQ0KPiBpb191cmlu
ZyBwYXJ0cy4NCg0KSW4gbXkgY3VycmVudCBicmFuY2ggZ2V0dGluZyB0aGF0IHNpdHVhdGlvbiBp
cyByYXRoZXIgaGFyZCwgYnV0IA0KZXZlbnR1YWxseSBnb3QgSU9fVVJJTkdfRl9UQVNLX0RFQUQg
KD40MCB0ZXN0IHJvdW5kcyB2cy4gZXZlcnkgdGltZQ0KYmVmb3JlLi4uKSAtIHdpdGggdGhlIGlu
aXRpYWwgcGF0Y2ggdmVyc2lvbiAtIEkgdGhpbmsgbXkgdGVzdGluZyB3YXMNCmZsYXdlZCBiYWNr
IHRoYXQgdGltZS4NCg0KDQo+IA0KPj4+IEZXSVcsIHRoZSBvcmlnaW5hbCB2ZXJzaW9uIGlzIGhv
dyBpdCdzIGhhbmRsZWQgaW4gc2V2ZXJhbCBwbGFjZXMNCj4+PiBhY3Jvc3MgaW9fdXJpbmcsIGFu
ZCB0aGUgZGlmZmVyZW5jZSBpcyBhIGdhcCBmb3IgIURFRkVSX1RBU0tSVU4NCj4+PiB3aGVuIGEg
dGFza193b3JrIGlzIHF1ZXVlZCBzb21ld2hlcmUgaW4gYmV0d2VlbiB3aGVuIGEgdGFzayBpcw0K
Pj4+IHN0YXJ0ZWQgZ29pbmcgdGhyb3VnaCBleGl0KCkgYnV0IGhhdmVuJ3QgZ290IFBGX0VYSVRJ
Tkcgc2V0IHlldC4NCj4+PiBJT1csIHNob3VsZCBiZSBoYXJkZXIgdG8gaGl0Lg0KPj4+DQo+Pg0K
Pj4gRG9lcyB0aGF0IG1lYW4gdGhhdCB0aGUgdGVzdCBmb3IgUEZfRVhJVElORyBpcyByYWN5IGFu
ZCB3ZSBjYW5ub3QNCj4+IGVudGlyZWx5IHJlbHkgb24gaXQ/DQo+IA0KPiBObywgdGhlIFBGX0VY
SVRJTkcgY2hlY2sgd2FzIGZpbmUsIGV2ZW4gdGhvdWdoIGl0J2xsIGxvb2sNCj4gZGlmZmVyZW50
IG5vdyBmb3IgdW5yZWxhdGVkIHJlYXNvbnMuIFdoYXQgSSdtIHNheWluZyBpcyB0aGF0IHRoZQ0K
PiBjYWxsYmFjayBjYW4gZ2V0IGV4ZWN1dGVkIGZyb20gdGhlIGRlc2lyZWQgdGFzaywgaS5lLg0K
PiByZXEtPnRhc2sgPT0gY3VycmVudCwgYnV0IGl0IGNhbiBoYXBwZW4gZnJvbSBhIGxhdGUgZXhp
dCgyKS9ldGMuDQo+IHBhdGggd2hlcmUgdGhlIHRhc2sgaXMgYm90Y2hlZCBhbmQgbGlrZWx5IGRv
ZXNuJ3QgaGF2ZSAtPm1tLg0KPiANCg0KQWggb2ssIHRoYW5rcyBmb3IgdGhlIGluZm8hDQoNCg0K
DQpUaGFua3MsDQpCZXJuZA0K

