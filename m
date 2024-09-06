Return-Path: <io-uring+bounces-3063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C55AC96F5E3
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2DC91C24087
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08BA1CFEB7;
	Fri,  6 Sep 2024 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="aK10lSGZ"
X-Original-To: io-uring@vger.kernel.org
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2068.outbound.protection.outlook.com [40.107.103.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34F51CFEAD;
	Fri,  6 Sep 2024 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.103.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630760; cv=fail; b=U0jHed0Hvfvkn8ATYV2Bx/S7QaWkBNZqTNRkDbfhDdEDdyqZR/rSlYZznxq+9qK93vxkXTRkcpagOaBHKWRp+MWylT50mEcrX0srX9IxDFXYnvIaZzwOK+STFGDFH6bgmFz/bXOnnizTO+fhmhyrGG6xUU2ebpTcFE7IQLtaa9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630760; c=relaxed/simple;
	bh=gdwfrKJ7Z4Io2UfE6TO3thHRo/G0AamyGuepG7wE3r0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HyFGqaeqFC7yRtLTvYnN1BRV8Raf0r9bMEm88es0h7j75wWXgMTmtPLatL+poVGPlAzklDxawAk1E0uQ3GeJbCem3RUI/UzXtmVFqHRFXrCM9K2aGoeSukbN7Uvnlh7prau9Wy7YmPBeKHjgE4ZYYkpdLO6yuEz3m6RqOjHkCng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=aK10lSGZ; arc=fail smtp.client-ip=40.107.103.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+WCe1kixx1QvHyepSm6mI8WjF30X8UogSmYAIioiV1apYOLouMuAZjVnNmUtIEyZSIvyHVKVBLZJ+75qWXRT5FqZehC1vGa/UxtvQFKm2tvSlPJCEGpe5LDOoDHNm9dMXr5O6RqH1Rp8DT2wiaGjoeWKUmEMjc5tT1BNxxK4+qWfU6a5l2/c4dGB+ZDu7xvIO9s3oqaw6iBOHWd9fulG4/Y9q6dM3p35jzxAbJDSEWtFGFqVkqETJCNnYbHMOn0wCvQaaiOK7dnNQwMeavKR2ngXHOf8djfUnayHYCJlzy8ylFoNcMr/oEExIYKdyGsBiMA915HFoz+fQz6zQD3Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdwfrKJ7Z4Io2UfE6TO3thHRo/G0AamyGuepG7wE3r0=;
 b=SUP3TRcxMPdIoHIrkJiFl1K/hTNP+rAfUv0qTcbybc6tpEWfwVIgqm9rR+5Bf7NdjAPZGbCmX1yUQiUHeFv9MXs4b3gtHVJQv7/UNuFen/EK32pIktS9mzkifcEldiwVUzOsHTK2pInKF2UXXIBscc+LZBKG3qNabI4GyED5MpL2yj7VB+gltplA7g+kPd0AJqYzdA4A8gxzVjbDizn0jdyfC2f0KOfV3/xtSZ9Bw2zF6mBN1xlDhBOe2hHpJh9P3YZvGYJmSGLIh9xtueaUT/ESBBNrXN7+pqneLS6zE8bccTiWOYWhwugf7YhpoeIy+r9fE9BdEqTRLGgZUcO7GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdwfrKJ7Z4Io2UfE6TO3thHRo/G0AamyGuepG7wE3r0=;
 b=aK10lSGZpl6i2+vsj5CyB3+arXQMVISSQUq/UjaZ3FoEmnC9xcy4/Fa9HjoDVDkcSC5CA3O82iQmJjrkBBa6VxXWcNk8rfXOqJ17SjocaLTfQKQ/MZDJxJB0Fkm0fVJo1lDXKRK0eK7he3tgWxUyC+qK/qUfVOxSZFCJvejbzheJMX/YZWyEJaOTQIhIowl9nbotQe3fV3OFH7Xg0SD3NNvzOw8S5fQtoWbeBX7KefYyeqZntu/ITjAkVd6KocrUv8RRhex786z0xjEmAab587ID0fkOThQTIRYBBVrFccI7583iLd6NZQwzLcBiyq3Z3ukOB7DQ2B9FKmIGoflOhA==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by AS1PR10MB5365.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:4af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 13:52:32 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.7939.017; Fri, 6 Sep 2024
 13:52:32 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Bezdeka, Florian"
	<florian.bezdeka@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "longman@redhat.com" <longman@redhat.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "Schmidt, Adriaan"
	<adriaan.schmidt@siemens.com>, "dqminh@cloudflare.com"
	<dqminh@cloudflare.com>
Subject: Re: [PATCH 1/1] io_uring/sqpoll: inherit cpumask of creating process
Thread-Topic: [PATCH 1/1] io_uring/sqpoll: inherit cpumask of creating process
Thread-Index: AQHbAGLxf6ZNL69Ud0ylOs+YhD3Pe7JKxdUAgAABboA=
Date: Fri, 6 Sep 2024 13:52:32 +0000
Message-ID: <236f0c6d019e8c25301f3db0a5c9d4971a094eb9.camel@siemens.com>
References: <20240906134433.433083-1-felix.moessbauer@siemens.com>
	 <8633f306-f5e0-42f8-a4c6-f6f34b85844d@kernel.dk>
In-Reply-To: <8633f306-f5e0-42f8-a4c6-f6f34b85844d@kernel.dk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|AS1PR10MB5365:EE_
x-ms-office365-filtering-correlation-id: 44a8cd0f-4878-4923-20ee-08dcce7b27e5
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c09TNksyVC9oNEF3TC9mQVdNRkd3R1JOZ2o4cC9peGswUWRTZThGbkMzR2hD?=
 =?utf-8?B?d0dVdnZKMVhocm9CUnJvMG5LM0RBVFBpSm51RmRXSHZEaWNRN3VXVFIwYlNx?=
 =?utf-8?B?allhQlNQQUNhUWZsWVBSN1E3bFAyS0NWUk1UaDV5bTliY2Nsc2JvQUZxbGRF?=
 =?utf-8?B?UTVBNnM2b2xrV21qYkNYMGdwRTl6eGkwQjhUcDVYRlpHajQ5K3dLUE9ET3pO?=
 =?utf-8?B?dnYrWE8rVTZiNlNNUHdMNjJJZlpzb3JpZUdrUXZRQ21nWDV1UlBYSDdBU1cv?=
 =?utf-8?B?TnZzVGlsNmlpdlBna1FHZThKdDBWcDVzVmJjOXdrNC9QbGMyNzFEWThSNlFV?=
 =?utf-8?B?NkczQlRuaXBVYk5ZR2tnRUh1WFlyNnJlWnMrQ3pnVGY2UjBLelU1UjFDSk9M?=
 =?utf-8?B?SUk2LzhySGMycFY5c3plYmh5UFFmY3B2dm40aWN0eGxtWE0ycE9XV1o2UkY0?=
 =?utf-8?B?RjZqMDRvRCtsS3RLMU40Z04yNmUwWWFWd1VCSGgrbW9KOC9LMG43QWtQOU1V?=
 =?utf-8?B?VlZoclRncENDQXFEMkMraEZXRXZBRFJpZnI4dTNWS2xWaXJUcDF5T1k4eUFO?=
 =?utf-8?B?VmN4VDF4aUVzcDdqUzdEaGE4azZnS09vUzdRWWYvT2llRWM3VGZUS2hySHE1?=
 =?utf-8?B?cEdpZHpIMmJ6SjEwd240czNZSkluWkNhcmlsUDEwRTdETEkwRUNKV2Y2ajVW?=
 =?utf-8?B?UGhlR3pyTXEwOXNKTTJ1OUQyTGVCMjMvaThHeS92ejVVSzU4c3RrUS9pT1BS?=
 =?utf-8?B?dnlqSnd2R003YnVWTS95QVJ0Z2RmbmhYN2xrYm9Rak5lcU5qTHZzTWlBaWhw?=
 =?utf-8?B?NFQ2Y2JadjhCQ3hRak9peGVreGkzZ1RzOW5VcWMvMFdQSXd5emgyMDJ0ZWdB?=
 =?utf-8?B?U0Q1U1dSQ29oNXBSSTJYWlZQbmhLcWc4YzlrMC9CTU0yRTNNMS9KdGZ5ejRu?=
 =?utf-8?B?RjNBUVRrbnRDT1FlY0pEaFc1UGpVS0dSd0lRZWtWWlNoQmJxVFR3SE1RenQ2?=
 =?utf-8?B?NVppNENSOEQxNkh2TmEvNXlST0J1dzZyc0x0SUlFU2ZWU21sUW93NkNGZ0hn?=
 =?utf-8?B?TUxtbngvMVpQQnZkdFBFZ1p4Zk5XUGVxZmh4bjFJeHRHdEJOUXRpZ1prcWJn?=
 =?utf-8?B?NHFkNzRtUG9SOGR0Wkw3clhhR0hFWDZZUUJJUTJEblVsZkJ0ekhiampsSFJa?=
 =?utf-8?B?UEtQWFlZNGp3dnVuU3c0S2o3WHlNalh1Q2dsZ0VzY3ZiTnhUZWJZejdTaWVS?=
 =?utf-8?B?VnU1WEY2ZVVHcEF5MDI1aGRFMFpLakQwUGY1em9CN1VLL0JYYWRtQ0dmWk9E?=
 =?utf-8?B?TDJpTzZUVHNkN2RraUJweUVRTzZCQkEyUXN0MVlGTW4rZ0x3c3dnczN6RFlC?=
 =?utf-8?B?em1BU24vMmVjZ2N5d2Yxa1pRTUJmY1NJY2d0WVdZZzQwQVB0ZWZ5VUNxYmk2?=
 =?utf-8?B?SU5INDdxZHRxSU1IN29HdlovRE4vdkUvanNXUktDZHFHWFV2amd6ZGw1d00x?=
 =?utf-8?B?WXZITmk2SEtjU09CZzByMkNqK0xQLy9ycE0xcStLZmhUSnVxdk9wZHNSMTdt?=
 =?utf-8?B?UGkxajN4SDViRTJ5cllNR21Vd1ZOVDFjb0VVL3lsZkpFODU1UzlGM0JBVUEv?=
 =?utf-8?B?UVZ4M0x5ZHIzUGdSdjhPZERQbVRKNUJIZzR4ZmhiV2VHNmVSbG1UYitxUWxi?=
 =?utf-8?B?czdPajd4VlcyNjdqV0tDc2JmbjRDSVhtVGxSbDNMWFhyTm1ZWXVPRTgxUjZo?=
 =?utf-8?B?bUJDT1JvY2tHRFdqQktnODFhVTg0b1Q4SE93bllUVW5VS0RpcHlNcGFSaGsx?=
 =?utf-8?B?NDcvczh0dERUdS9Oa0xzNmpWRGVOUy9zdDZhVTFVTjNkNEpxU2NvaVFYM0Zh?=
 =?utf-8?B?MDJseXVLdVhqZ0lDeXJCVmx5bnh2TmVkMHFady8zZHViQnc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UlBKSEcyb1hLRHdUeUdJQzZRWTF2ODllK3FtdVI4TS9RSFRoSk1VaHNLVXhr?=
 =?utf-8?B?SHBybTZnRTFUYmNIMUNCL2dJL2pTNTl6SDNXenVuQjArNFRvSTVROThMTEU2?=
 =?utf-8?B?VHdUQVhCeVI4bTF3MEQySWk2bVJFUFdYcS90NzhkVWNiaEdId21qV0lwcW5a?=
 =?utf-8?B?S1pKR1llOXFURFFJSWNTK2N6Rk5SdHhPalZNRUMwYytNMWU3V1piYmQ3WnV1?=
 =?utf-8?B?ZXlqdEhHZngwNm1aUFZuanllK3Bkazk3OC9ZZzV5QjhFZmRyKzJ6Q0RINEhq?=
 =?utf-8?B?a2xvQzFGRVpVK2hYeUVuTk1VUlQ0dWxlQkFGU1lPVnF2L0Q5TjdPY1NRSm1j?=
 =?utf-8?B?SG1lSTBRN0pTQkR4WFNLL3prT0pLajhZTHhFT2VoU2RnY0g5SWxrbmFhL2VI?=
 =?utf-8?B?VUpKZTdHbVhIVTNXZk9EMGtwblgyYnBqZU5UazJNaGpQNzVyejlXTnIvU2FS?=
 =?utf-8?B?Z0NON1U3RkhOeCtQNWJ5OTJBeU9kcnV5blFJTGNKVjZpaGt4eWhiZVZPK2JO?=
 =?utf-8?B?RERVQjA3Slg1Q2krZERmVzFUTFE1aHJGWTZmc1praVJESTk2Tm1ZSTZMWU9n?=
 =?utf-8?B?MjdaZTBUOGh6R3JYRkl3d2RZeHRDanlnZUMvNlR2NlZWQ01iOFFhRWxmME5w?=
 =?utf-8?B?VUNob3I0VGhyVi9vbWRpSkVjN1NnZkh6Y3dWcldNRDh3VjNqd3ZOSkthYm8v?=
 =?utf-8?B?UGlrb0g4QzYwZHRwUVN4T2Z6d25haXRxeXZpeHFBRzEwcVR2VVJ1MVZIQ0Zm?=
 =?utf-8?B?S3N5dm12TzhZYU96RXRxMUhqQzVJUzAwQVRBVC9wblVpSTNXVXV5TFpnckJl?=
 =?utf-8?B?VTlzWWdWQWVoNmJRZm8vSHI2clpQRkxIRHhXayt0bjNFdXg1Q0tyY0hYeEpN?=
 =?utf-8?B?QXBhZTNZK3Y0WGw2U3Iza2swYlRSQ256bEJPOFAxNDBPMG1KcVVDdlRBOW9o?=
 =?utf-8?B?bFhxNXg4K2RYWnNSdW92UzNXQ1BaVnV5ZDY5bHBxQkN2ZnlPQkV2NUNtQ0Fn?=
 =?utf-8?B?QVNHSFAwYjh2Uzk5Q0lzdkFxTXZrY2FGYU5vMUc4RXRXUDV1dkFYMWxJbVdp?=
 =?utf-8?B?RzVwYlhhVzdCVERERHlzS1pFZ2ZvSEJ5RC8vYTVsU2dJWUc1UmZEeVVEOElE?=
 =?utf-8?B?MmZUQXhEaCtIUUFUT3hCOHZad25NUUhGa0NndElWTjVGY1J5VHU1UEUzSjZp?=
 =?utf-8?B?am5JQjV2TUs3eHlrTEtlSHlRWU52ZkplRDdqMnNwTmVSQnUvRXVxeUJnNkFi?=
 =?utf-8?B?OStsQjNmeWZVc0hUekhxckgvaEd5cW1wcE9STHR3UC9udVkvYjdFOUNLU00r?=
 =?utf-8?B?eUZPQTZ3MXRDaVUva0s1WDJtR3BCdlZYMEdNRFBScmhOZ28xNW51aGs0cGRa?=
 =?utf-8?B?UmUvdFB4MmNlQmppclBBaGs3cEdxblFzRnZ6MkJieTFDd0xOdmFTc2MzUFhK?=
 =?utf-8?B?WUV1YjJQWk8wYkRBdlB4TktRcENwdkIrUXVDMGVJNjc0RlBibnZ0Wk1lNmwv?=
 =?utf-8?B?UUFJMU85dFRPeHJEais3ZzI1d0hlQ3c0Y2Z5QTVYSkFsVVhoSVYvNlBxWGtl?=
 =?utf-8?B?Z1JVR0JBd3ZCcWxhcy9tV1MvTHN5TDMxYTlQalpFSUxkQTMyRnRGM0RvcGl0?=
 =?utf-8?B?RUFONERSbEdBY2puTjIzOUJEdzVzNG9MUHREWXBIVTFIZzRrSm9GZEZQNWZp?=
 =?utf-8?B?WVN4UE1EcmpDKzE4a0xDMHpSVVA3QXhudmt3QVUyaEZBWWgzd01TT2Z1RW4y?=
 =?utf-8?B?VEx3YUdOcjJsTHhaaTNENFR5VzZwWlg4a1d5cUYwZVN4d0xHNGRuZ2R2c0pu?=
 =?utf-8?B?TVdTa3JTMmxkSENNY3BZM0w5WXpIZVZ4SlNUMVF3cFhPZHp1VUFsenFrR0F0?=
 =?utf-8?B?NFVlRVFJcXpLS1BDVERjZnZMU1MyT3o1OGphWDR0dnZyOTVVZExoMVpLdkxQ?=
 =?utf-8?B?SUsvUlFOdkc4NzQxbXlNTWRKVWpncXdaT3hQcStBaDlzUjdMU2FWcXExS1kw?=
 =?utf-8?B?YVM4K2puV2RPaHZGSHJrOGZ0T2lyRGZ1Z3IxelEvMnB2QWZ3eDI0SE13aDd6?=
 =?utf-8?B?OFVFSzkxanp0VkhRV2VFdXVIY016NFZVOHJhUUdSQTlsc25NSThucVVkVWYv?=
 =?utf-8?B?NHZWQXFyNlZRM3ZvckhTSjNYL0NFVzJtNURBRERuRFJjU3ZaZzdtdEd3Vkty?=
 =?utf-8?B?V2ZEWGg1OEt0ckhPSmtrNzE2amZJZDdCelRYUldoekNnWmNFQXdoTjJ3NVJE?=
 =?utf-8?Q?Y+GiqFPXJIxbnbQxGozIla7Y3MjqE0m59jSdSoSJE4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <701F7F20A1D11745A6F912C70E27DED5@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a8cd0f-4878-4923-20ee-08dcce7b27e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 13:52:32.5165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rYZWireCjLH7SCbVE1kMN89Skz2wV2EeuH/yz09mCfsVhqEGF9smMJMSHrr2WWq7E+UEeaXsXRvPDL4JsZ6K4NqOq7/i0xNqc+y1debT6qg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR10MB5365

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDA3OjQ3IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA5LzYvMjQgNzo0NCBBTSwgRmVsaXggTW9lc3NiYXVlciB3cm90ZToNCj4gPiBUaGUgc3VibWl0
IHF1ZXVlIHBvbGxpbmcgdGhyZWFkcyBhcmUgImtlcm5lbCIgdGhyZWFkcyB0aGF0IGFyZQ0KPiA+
IHN0YXJ0ZWQNCj4gDQo+IEl0J3Mgbm90IGEga2VybmVsIHRocmVhZCwgaXQncyBhIG5vcm1hbCB1
c2VybGFuZCB0aHJlYWQgdGhhdCBqdXN0DQo+IG5ldmVyDQo+IGV4aXRzIHRvIHVzZXJzcGFjZS4N
Cg0KT25lIG1vcmUgcmVhc29uIHRvIGJlaGF2ZSBsaWtlIGEgdXNlcmxhbmQgdGhyZWFkLiBJIHVz
ZWQgdGhlIHRlcm0NCiJrZXJuZWwiIHRocmVhZCBhcyBpdCB3YXMgdXNlZCBpbiBjb21taXQgYTVm
YzE0NDFhZiBhcyB3ZWxsLCByZWZlcnJpbmcNCnRvIHRoZSBzYW1lIHRoaW5nLg0KDQpTaGFsbCBJ
IHVwZGF0ZSB0aGUgY29tbWl0IG1lc3NhZ2U/DQoNCkJlc3QgcmVnYXJkcywNCkZlbGl4DQoNCj4g
DQo+ID4gZnJvbSB0aGUgdXNlcmxhbmQuIEluIGNhc2UgdGhlIHVzZXJsYW5kIHRhc2sgaXMgcGFy
dCBvZiBhIGNncm91cA0KPiA+IHdpdGgNCj4gPiB0aGUgY3B1c2V0IGNvbnRyb2xsZXIgZW5hYmxl
ZCwgdGhlIHBvbGxlciBzaG91bGQgYWxzbyBzdGF5IHdpdGhpbg0KPiA+IHRoYXQNCj4gPiBjcHVz
ZXQuIFRoaXMgYWxzbyBob2xkcywgYXMgdGhlIHBvbGxlciBiZWxvbmdzIHRvIHRoZSBzYW1lIGNn
cm91cA0KPiA+IGFzDQo+ID4gdGhlIHRhc2sgdGhhdCBzdGFydGVkIGl0Lg0KPiA+IA0KPiA+IFdp
dGggdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24sIGEgcHJvY2VzcyBjYW4gImJyZWFrIG91dCIg
b2YgdGhlDQo+ID4gZGVmaW5lZCBjcHVzZXQgYnkgY3JlYXRpbmcgc3EgcG9sbGVycyBjb25zdW1p
bmcgQ1BVIHRpbWUgb24gb3RoZXINCj4gPiBDUFVzLA0KPiA+IHdoaWNoIGlzIGVzcGVjaWFsbHkg
cHJvYmxlbWF0aWMgZm9yIHJlYWx0aW1lIGFwcGxpY2F0aW9ucy4NCj4gPiANCj4gPiBQYXJ0IG9m
IHRoaXMgcHJvYmxlbSB3YXMgZml4ZWQgaW4gYTVmYzE0NDEgYnkgZHJvcHBpbmcgdGhlDQo+ID4g
UEZfTk9fU0VUQUZGSU5JVFkgZmxhZywgYnV0IHRoaXMgb25seSBiZWNvbWVzIGVmZmVjdGl2ZSBh
ZnRlciB0aGUNCj4gPiBmaXJzdA0KPiA+IG1vZGlmaWNhdGlvbiBvZiB0aGUgY3B1c2V0IChpLmUu
IHRoZSBwb2xsZXJzIGNwdXNldCBpcyBjb3JyZWN0DQo+ID4gYWZ0ZXIgdGhlDQo+ID4gZmlyc3Qg
dXBkYXRlIG9mIHRoZSBlbmNsb3NpbmcgY2dyb3VwcyBjcHVzZXQpLg0KPiA+IA0KPiA+IEJ5IGlu
aGVyaXRpbmcgdGhlIGNwdXNldCBvZiB0aGUgY3JlYXRpbmcgdGFza3MsIHdlIGVuc3VyZSB0aGF0
IHRoZQ0KPiA+IHBvbGxlciBpcyBjcmVhdGVkIHdpdGggYSBjcHVtYXNrIHRoYXQgaXMgYSBzdWJz
ZXQgb2YgdGhlIGNncm91cHMNCj4gPiBtYXNrLg0KPiA+IEluaGVyaXRpbmcgdGhlIGNyZWF0b3Jz
IGNwdW1hc2sgaXMgcmVhc29uYWJsZSwgYXMgb3RoZXIgdXNlcmxhbmQNCj4gPiB0YXNrcw0KPiA+
IGFsc28gaW5oZXJpdCB0aGUgbWFzay4NCj4gDQo+IExvb2tzIGZpbmUgdG8gbWUuDQo+IA0KDQot
LSANClNpZW1lbnMgQUcsIFRlY2hub2xvZ3kNCkxpbnV4IEV4cGVydCBDZW50ZXINCg0KDQo=

