Return-Path: <io-uring+bounces-13918-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NE/YAuHpTWoUAAIAu9opvQ
	(envelope-from <io-uring+bounces-13918-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 08:10:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3246772212F
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 08:10:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=EcFAP7xa;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13918-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13918-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D0A9300C583
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2026 06:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3BB38330B;
	Wed,  8 Jul 2026 06:08:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011029.outbound.protection.outlook.com [52.103.72.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955FC380FD4;
	Wed,  8 Jul 2026 06:08:05 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783490887; cv=fail; b=jNatif2GjTsre3jTOVY5GSaFym48uQkJOZFOZrD39UTmitmb88TKr++rFxg/FBRqxyoygwI3/WRCX15ePyIE+kDFPmFK1UnqkHB+e6B/m0V6Pz+5VnJ3nsdBlwX8e1gGLGqDQSB8RD8U9dcpnEEa4ZupLd4n14FyJTYg6uUzMN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783490887; c=relaxed/simple;
	bh=BpVYIqFkqUWQ6ULDyvPjb2bLbLRTXhTpRJU4FMdj/vg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UPXhUPLsx3o/TyMp5f9JgKD4WV3O1NznLx4j8S1YryHC7CvftRwkKS9jVduc77ONL4H2tEAQR+2mELMQw68x1oLhywIRgbBjMmzFKYTSSqRTEgv/Xi6R9W3VpFRPBJ21SJn7LDksWG+PdDoeXxEvOhWqoUgsNJFqssEhl0lOosA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=EcFAP7xa; arc=fail smtp.client-ip=52.103.72.29
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PMrKw8ALks8pyafHVIEKo63CcQZjmbgLMhJqVQ9hSRD6/TYKKzGP7A7+RnX14MGaxwutQz7sGi523VLcdH4m90nNNcl4LK0+T7+3vj2zKW381ID0j+lMb5g3joP8ojHeB0PBtz/2m6ll2ZZr99OxbBS9uHKfzor4QkJCf+koVRq4hralgNXRknsVXHtD0fjQNbiSrJKytcjhDdX5CDcMZdL9AdIty9zU0CUXM4la5FYHgYuC76/SAJlTkLt6bK3ojROCuu4yJ24hAUyWHJBN4Fs0a7l5/zBhu6zu4aAHaZXKO/Uf9yvYCbNyP9+RMk3QuBQI82P/y6IJ53guNu/Jhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpVYIqFkqUWQ6ULDyvPjb2bLbLRTXhTpRJU4FMdj/vg=;
 b=EpNjNsawds/eE4DuXrbsKxPRatx9qDr2N32HpvwjdoPYGlsm0knvaiAzwoz6VWxh7OvZ4WeFu3jSznj/URBMsUH8h8w3lzGziV8c2b3dx81jywU/IpuoteXwhVTm3rxxj/GIPnfhtwu5plGQCZlVvkdEn3uUfoi2VWG9fip5PZ2lw2vRSvif/4dGLUwQFKrjKSQY1Ja3c6eMwcH9OfdHIn3+tKCkdeHGejP56cOEaCED9m0/zTjokd9TxX0+XWIo/mBctg0e2g9nkynAbHiEe4EiLxozn1oh/7nid0iaq3Rcl0asSdSmVjQQ2w2paptuRJHHg1qshESVjIc8dyRVeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpVYIqFkqUWQ6ULDyvPjb2bLbLRTXhTpRJU4FMdj/vg=;
 b=EcFAP7xaO2H0LQZcxiS/Ouvdltj8VGhpKhsjjqN+frAjtMAZDgmsKdLG8wH+IRqpS0Ze5AdJblnWREABvEcA9sQVMSeYUHQoK6gySO1+H/MOFHNDXNzCQHdBCTPALg3Jl9KUzaaXtpcvySmFh+mMiucgXI6VW9Op48zcWsuhiOIF+KhrRlg7z7Cb7XsUfb0QRusvD/o4GB+80lDOEGfPOwKh3+wE48GjV2RY9FoYHRKyd3DjbogesDtRNQcVocUP8utjAKTUvmgBjYoCnSLvSpyxoO1A89VHyzahxgv9uln2WAj+U8gOD0/CFd090at/T2isER7dzIqmhAv6QHR02g==
Received: from SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:250::7) by
 SY8P300MB0029.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:22e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Wed, 8 Jul 2026 06:08:02 +0000
Received: from SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM
 ([fe80::b047:715:42bf:b733]) by SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM
 ([fe80::b047:715:42bf:b733%3]) with mapi id 15.21.0181.010; Wed, 8 Jul 2026
 06:08:01 +0000
From: Feng Xue <feng.xue@outlook.com>
To: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring/net: clear stale vec on buffer peek error after
 expansion
Thread-Topic: [PATCH] io_uring/net: clear stale vec on buffer peek error after
 expansion
Thread-Index: AQHdDqAJPKEZda61eE6W7PaDug4+6g==
Date: Wed, 8 Jul 2026 06:08:01 +0000
Message-ID:
 <SY0P300MB0070983BEEB976B8F46E3D4790FF2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SY0P300MB0070:EE_|SY8P300MB0029:EE_
x-ms-office365-filtering-correlation-id: a6280139-e57e-4370-8cd1-08dedcb74430
x-microsoft-antispam:
 BCL:0;ARA:14566002|37011999003|31061999003|19110799012|15030799006|8062599012|8060799015|41001999006|55001999006|24021099003|25010399006|15080799012|4140399003|52005399003|40105399003|12091999003|102099032|440099028|26104999009|3412199025;
x-microsoft-antispam-message-info:
 =?gb2312?B?d25NNmhXbktwQWh6dlpJRlRVM3A1OHZNMmp5WVV6bGdPdkpxMnoxWW5zWkhv?=
 =?gb2312?B?OXhOSTN5V2pkbm9STTZ3dWhmUXZveFFPek95VkVtd3d0aDhjUFc1bGR0M3k1?=
 =?gb2312?B?UjVvay84WEJhQk8ybDlXemhVSHB0NlY1U2U3S29HSkl4SU1Od1FVdVNoM0ZX?=
 =?gb2312?B?TUo3NEN5bVBsMVNueFZCckp6N3Q2c1pWUzFGeXB0MzlGMXZacVgyR2lvbVlM?=
 =?gb2312?B?dGZBUERhbkN1VktTNFBoZ3Q1c0NOeWw5b0dLcyt5NGNpemdpSVpWUStuTVkx?=
 =?gb2312?B?dEduTkFRQUY4ZEJpclhra1ZGMk54dUdDWVVON3o5NFBjNlRaSkppalBmcVpB?=
 =?gb2312?B?Z0ZmNzlydGIyS1dmNnFqcVl1MERRemw3VjBad3BGQkFYU1hZUitaOTBQN3Vq?=
 =?gb2312?B?VFIwM0RkdnZUSlBmdjZydHBuc0JIbUtFc1dScU9sN2lyZWRpdHFlanlSUXZr?=
 =?gb2312?B?U1ZNTUNWc29nRXBvdlIwZFNXR0ZlNnI5aytkWnZyR2FHdkNaZ3FaMG9tL0F1?=
 =?gb2312?B?bDFBYjNRVGZRUFY1SVM5UFRXNE9pVS91MjkrZnVvSmFOSDF0YmxjYS9DWXVX?=
 =?gb2312?B?SEhDRlJ3SjRDZ1hmZkFqNDBTaVB5eW5iUTZvY2Y0cmlzQ1VKRFFweTcrTTl4?=
 =?gb2312?B?VEFqR0NGUnhORStFalNsdXl1R2EraE5IYW1TU0xCYTlDVEw0Y3Z5MTBEcjdE?=
 =?gb2312?B?YTdaR2FSMSt5VUEwN0ZQQ1M3RmoxTE9SZzdmRGtQYXFlbFh4MDdCVnJRRWYy?=
 =?gb2312?B?c3hVWnd4TFY1aExTWUxIWldrYVJnU1FQY0J0Qk9YWnBHN2hCRVNKeUV3WnNx?=
 =?gb2312?B?c3djdDVNK2kvaEhuZzRPYStQWkNCbG95VnVwMVk1a3ZFYmFLUUxXcGtsSDBW?=
 =?gb2312?B?QmFBNTVTOEkyTjM0Rnh3Yzh1Uit0clNFZmZua2NhSkRUUjdGd1EzU0RmOGwr?=
 =?gb2312?B?aVhKTitORnFEc2hlaGhPOTZ3OTlCODEvOWd2N1pOQnQva2I4dXJxTENvTXVE?=
 =?gb2312?B?c0JETEs4SkRoM2pGVkFjaEpXdWgzZ0tISkFQWEp3dUZEMFdWaXhGY0l3Mm5H?=
 =?gb2312?B?TzdNUDJtdGdEVnlobzBPVmdTMjltMkFUMG4vTkMwUUNpTlpWajhIR0NrZVhN?=
 =?gb2312?B?RElzNFFxaGY2SXpsemVPRjVwL2tHVVFWVjg3bzl2WlNKVVBtdHBuZmxzZE93?=
 =?gb2312?B?STA2dHpZR3kxWDlUTklZOTRNU0FKdkVOVDFQVWdidFUycnZscVROYzJUblhK?=
 =?gb2312?B?YTFwT2ZId3gwZ0V0ODRCRm1mdHpvUEpGd3ZrQWNkaHZ3NDlwVTVCQm9Mb2po?=
 =?gb2312?B?Q2k1ekZxSjdnTGpEUTBIRkl5M05qaVd4ZTJONEwxQjJvLzEweCtra2ZsdzUr?=
 =?gb2312?B?ZWtmTTVtcEhJNmpVTnA1SVUvMmkzRzVlNER4TUsydkhMWUFwekxheEZsb21m?=
 =?gb2312?B?QVUzQmNGL3IzNlRIN2RQdWVBVkkxV1pGa3ZDeEdDdUdaQXA5WDI2WkkvWlZF?=
 =?gb2312?Q?/nS8VM=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?VzZ2VlVJNUVKYUdTajJSZitYOTYwU1hRSS9RMnRIRU1Ld2NVUlE4ZGFSMVhG?=
 =?gb2312?B?aFIxb01JRy95Z3RIbHBKVmhUQ3RwYXFCOG45a01JbVFiV2RGYzRGV2RFT1do?=
 =?gb2312?B?NlJrTlJSOURvSzFsdCtJcG5TeU9OVWxYWElNdzZab25hWjNYMEt5bStadzFB?=
 =?gb2312?B?Zm00Q0EwYzgrTmFDenEvaGxwd2cyS0dOejBHTFM1cVBEakVRL01iWlNpWnVE?=
 =?gb2312?B?ZS9ibHl2WFF0M0xvWStUZ3ZDODFMVURIZXh2WkpaTk15REF1K1RTSlJEZi8z?=
 =?gb2312?B?VjRtM3J4MkVvaUhISkdMS01YT29VbHErS3VaOHFlcmR0S3hLUlNLeWlQNVVB?=
 =?gb2312?B?aVZ3dTFHc2JjMFQreGRpUCtsOEVuM09vNFp3T2doTUU2TWowYVlJcWN6d295?=
 =?gb2312?B?cVh5YWZGbm5LWTU2bEl0YmR0YWtIOXpiMTl4YWRVSFl3U3dpdno1UFRkRG5V?=
 =?gb2312?B?Wmo5NW5JeUhSV0J1Y0l1ZU4ydkNray82V0lsZUw5UFU2ektZMWRVRkllZmR1?=
 =?gb2312?B?S21wNHRnZFdoTlpmWWV5UWoyd2loV2R6bWJqTGNyWUNyV3NvYlhFVDlNTGw2?=
 =?gb2312?B?aDgyQ2NlVXN5ZFc0NDNSMlRMZlpVM29va004T2hIdWVoUUJBeSt2SXZWVmJ5?=
 =?gb2312?B?dHp4OGpQNkw1bFJ2VTltN3F1TmtaVmJpYmtLVGszcUVWMWNTVEg5YUpoMmRW?=
 =?gb2312?B?Q1RLWmcyRjFBL3ZmV2w1K3BkV2JGcmE2YU9XTENHOFJUdVk4NGVpT1loOGI3?=
 =?gb2312?B?czRXWnhpQm8zcUhKR0h6ZnY4d0pkdjg4dWxmMmwvZlY2dUVCdEVNS2liT25K?=
 =?gb2312?B?aWlSUnM2ODhjQklURmtrV0txajYvL2xmZk1XY3Y1bUJ1L0l0STRIS1JjUEQx?=
 =?gb2312?B?ZTM0YnJFK2Q1OWEwWXM0Qk5seEtrY1MyVmNsSFlRUk1tOTlBcDMwaU5yTW1J?=
 =?gb2312?B?Qm4vSWpEWFZYTEtSRUxCdXAzVVNzdDJwWGN6UnZoc2xnY29xVm5Ba2xZeDdm?=
 =?gb2312?B?NXNyc2lyU0I3ZFFDT0hydFppWlVSZnUzUmdBUzdsdzROK0luNzRZenhpVG9O?=
 =?gb2312?B?Z2NxdkYvM0Rxb2wvSUFsR05lY1RUMW9CalpWKzFIZ2l5MW1CZEJJYlYrTnRp?=
 =?gb2312?B?VWhzN2FjQzhnVW1YSUc2enA0azVid0VsYnBwL3NEU25yYVFBQ3RHb3ptQysw?=
 =?gb2312?B?Z3lPZUl5S1BHbHR2WXBlNTJBelhUdnFHUTlNaHhvZllFUkVwc1VSenN5Qmh1?=
 =?gb2312?B?Q0FLbWs2aFJqUlcxaVdxL2o4ZjZhYXN3UzJ0em1aTk1GejUrVFNsQnBJZ3RB?=
 =?gb2312?B?OVNVWkFDSzhrMWh1SjJsb1k1M2RFUGpEK1VxKzRsOWZVT2cyTEw5NkVlc1Rk?=
 =?gb2312?B?NzlQQjBiT2tDb3RtMFFwZWliYng0Tkt6SHhjai9WRHRkVkxXVkJXWVM4NHg0?=
 =?gb2312?B?aFhNdVpVTGpYeFh1ZFZ4bW1GVW1Nbm9LSk5DaVBPbGVGSUxjSjZEM2dXeWJ0?=
 =?gb2312?B?MnViRGxqSTVyakFUYnJkaUFKNkEweTFBV3RYQWF1Vm1hWVM4MUlzd3BBckx6?=
 =?gb2312?B?S0VTdTljUGN0ZlNTYmxST3RNTkhPRnlwRm1GMWNiU0ZlcE9Ma2REY1ZBK1FV?=
 =?gb2312?B?RllMZ3dZUGFpd2RZZE53eE5FTUdYUnA3S1hRUXU1MHRuMDBzMVFzNVZRM0JD?=
 =?gb2312?B?MkFuWGV4WEhnV1RhQURqekl1MC95dXBJVjVWKzNvNU1FaHFwQklPdWE4M2Zk?=
 =?gb2312?B?L2ZGVDJwMWtqQUlrdnRKK2J0amVKaVR3cklxbFFxbHdsdjY2YnhoaTBkZG1m?=
 =?gb2312?Q?J3WfhG8Kuyb/2xZi70BUPzoXGyGzeiuGeP+q0=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a6280139-e57e-4370-8cd1-08dedcb74430
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2026 06:08:01.4270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY8P300MB0029
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[outlook.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[outlook.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13918-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_FROM(0.00)[outlook.com];
	FORGED_SENDER(0.00)[feng.xue@outlook.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[outlook.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[feng.xue@outlook.com,io-uring@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,outlook.com:from_mime,outlook.com:email,outlook.com:dkim,vec.nr:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3246772212F

U3ViamVjdDogW1BBVENIXSBpb191cmluZy9uZXQ6IGNsZWFyIHN0YWxlIHZlYyBvbiBidWZmZXIg
cGVlayBlcnJvciBhZnRlciBleHBhbnNpb24KCldoZW4gaW9fcmluZ19idWZmZXJzX3BlZWsoKSBl
eHBhbmRzIHRoZSBpb3ZlYyBhcnJheSBkdXJpbmcgYSBidW5kbGUKcmVjdiByZXRyeSwgaXQgZnJl
ZXMgdGhlIG9sZCBhcnJheSAoQSkgYW5kIGFsbG9jYXRlcyBhIG5ldyBvbmUgKEIpLgpJZiBhY2Nl
c3Nfb2soKSB0aGVuIGZhaWxzLCBCIGlzIGFsc28gZnJlZWQgYW5kIC1FRkFVTFQgaXMgcmV0dXJu
ZWQuCgpUaGUgY2FsbGVycyBpb19yZWN2X2J1Zl9zZWxlY3QoKSBhbmQgaW9fc2VuZF9zZWxlY3Rf
YnVmZmVyKCkgb25seQp1cGRhdGUga21zZy0+dmVjLmlvdmVjIG9uIHN1Y2Nlc3MsIHNvIG9uIHRo
aXMgZXJyb3IgcGF0aCB2ZWMuaW92ZWMKc3RpbGwgcG9pbnRzIHRvIGZyZWVkIEEuIFRoZSBzdGFs
ZSBwb2ludGVyIHN1cnZpdmVzIGludG8gdGhlIG5ldG1zZwphbGxvYyBjYWNoZSB2aWEgaW9fbmV0
bXNnX3JlY3ljbGUoKSAodmVjLm5yIDwgSU9fVkVDX0NBQ0hFX1NPRlRfQ0FQCnNvIGlvX3ZlY19m
cmVlIGlzIG5vdCBjYWxsZWQpLiBBIHN1YnNlcXVlbnQgYnVuZGxlIG9wZXJhdGlvbiByZXVzZXMK
dGhlIGNhY2hlZCBoZHIsIHNlZXMgdmVjLmlvdmVjIG5vbi1OVUxMLCBzZXRzIFJFUV9GX05FRURf
Q0xFQU5VUCwKYW5kIHBhc3NlcyB0aGUgZGFuZ2xpbmcgcG9pbnRlciBiYWNrIHRvIGlvX3Jpbmdf
YnVmZmVyc19wZWVrKCkgoaoKd2hpY2ggd3JpdGVzIGlvdmVjIGVudHJpZXMgdG8gZnJlZWQgbWVt
b3J5ICh1c2UtYWZ0ZXItZnJlZSkuCgpJZiB0aGUgYWxsb2MgY2FjaGUgaXMgZnVsbCwgdGhlIGFs
dGVybmF0aXZlIGNsZWFudXAgcGF0aCB0aHJvdWdoCmlvX2NsZWFuX29wKCkgofogaW9fdmVjX2Zy
ZWUoKSBrZnJlZSgpcyB0aGUgYWxyZWFkeS1mcmVlZCBBCihkb3VibGUtZnJlZSkuCgpGaXggdGhp
cyBieSBOVUxMaW5nIHZlYy5pb3ZlYyBhbmQgemVyb2luZyB2ZWMubnIgb24gdGhlIGVycm9yIHBh
dGgKd2hlbiBleHBhbnNpb24gb2NjdXJyZWQgKGRldGVjdGVkIGJ5IGFyZy5pb3ZzICE9IGttc2ct
PnZlYy5pb3ZlYykuCkRvIG5vdCBjYWxsIGlvX3ZlY19mcmVlKCkgaGVyZSChqiBBIGlzIGFscmVh
ZHkgZnJlZWQgYnkgdGhlIGV4cGFuc2lvbgpibG9jaywgc28ga2ZyZWUoKWluZyBpdCBhZ2FpbiB3
b3VsZCBpdHNlbGYgYmUgYSBkb3VibGUtZnJlZS4KCkFwcGx5IHRoZSBzYW1lIGZpeCB0byBpb19z
ZW5kX3NlbGVjdF9idWZmZXIoKSB3aGljaCBoYXMgdGhlIGlkZW50aWNhbAp1cGRhdGUtYWZ0ZXIt
c3VjY2VzcyBwYXR0ZXJuLgoKU2lnbmVkLW9mZi1ieTogRmVuZyBYdWUgPGZlbmcueHVlQG91dGxv
b2suY29tPgpBc3Npc3RlZCBieTogWEdQVAotLS0KIGlvX3VyaW5nL25ldC5jIHwgMTYgKysrKysr
KysrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvbmV0LmMgYi9pb191cmluZy9uZXQuYwppbmRleCBY
WFhYWFhYLi5YWFhYWFhYIDEwMDY0NAotLS0gYS9pb191cmluZy9uZXQuYworKysgYi9pb191cmlu
Zy9uZXQuYwpAQCAtNjMxLDggKzYzMSwxNSBAQCBzdGF0aWMgaW50IGlvX3NlbmRfc2VsZWN0X2J1
ZmZlcihzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzLAogCiAJ
cmV0ID0gaW9fYnVmZmVyc19zZWxlY3QocmVxLCAmYXJnLCBzZWwsIGlzc3VlX2ZsYWdzKTsKLQlp
ZiAodW5saWtlbHkocmV0IDwgMCkpCisJaWYgKHVubGlrZWx5KHJldCA8IDApKSB7CisJCS8qCisJ
CSAqIEJ1ZmZlciBzZWxlY3Rpb24gbWF5IGhhdmUgZnJlZWQgdGhlIG9sZCBpb3ZlYyBkdXJpbmcK
KwkJICogZXhwYW5zaW9uLiBDbGVhciB2ZWMgdG8gcHJldmVudCBzdGFsZS1wb2ludGVyIHJldXNl
LgorCQkgKi8KKwkJaWYgKGttc2ctPnZlYy5pb3ZlYyAmJiBhcmcuaW92cyAhPSBrbXNnLT52ZWMu
aW92ZWMpIHsKKwkJCWttc2ctPnZlYy5pb3ZlYyA9IE5VTEw7CisJCQlrbXNnLT52ZWMubnIgPSAw
OworCQl9CiAJCXJldHVybiByZXQ7CisJfQogCiAJaWYgKGFyZy5pb3ZzICE9ICZrbXNnLT5mYXN0
X2lvdiAmJiBhcmcuaW92cyAhPSBrbXNnLT52ZWMuaW92ZWMpIHsKQEAgLTExNzQsOCArMTE4MSwx
NSBAQCBzdGF0aWMgaW50IGlvX3JlY3ZfYnVmX3NlbGVjdChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwK
IAogCQlyZXQgPSBpb19idWZmZXJzX3BlZWsocmVxLCAmYXJnLCBzZWwpOwotCQlpZiAodW5saWtl
bHkocmV0IDwgMCkpCisJCWlmICh1bmxpa2VseShyZXQgPCAwKSkgeworCQkJLyoKKwkJCSAqIFBl
ZWsgbWF5IGhhdmUgZnJlZWQgdGhlIG9sZCBpb3ZlYyBkdXJpbmcgZXhwYW5zaW9uLgorCQkJICog
Q2xlYXIgdmVjIHRvIHByZXZlbnQgc3RhbGUtcG9pbnRlciByZXVzZSBvcgorCQkJICogZG91Ymxl
LWZyZWUgdmlhIGlvX3ZlY19mcmVlIG9uIHRoZSBjbGVhbnVwIHBhdGguCisJCQkgKi8KKwkJCWlm
IChrbXNnLT52ZWMuaW92ZWMgJiYgYXJnLmlvdnMgIT0ga21zZy0+dmVjLmlvdmVjKSB7CisJCQkJ
a21zZy0+dmVjLmlvdmVjID0gTlVMTDsKKwkJCQlrbXNnLT52ZWMubnIgPSAwOworCQkJfQogCQkJ
cmV0dXJuIHJldDsKKwkJfQogCiAJCWlmIChhcmcuaW92cyAhPSAma21zZy0+ZmFzdF9pb3YgJiYg
YXJnLmlvdnMgIT0ga21zZy0+dmVjLmlvdmVjKSB7

