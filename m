Return-Path: <io-uring+bounces-3690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B500899E193
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 10:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 260031F2576E
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 08:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B061CDA3E;
	Tue, 15 Oct 2024 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="UvS+L7DJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBBE1CDA1C;
	Tue, 15 Oct 2024 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728982239; cv=fail; b=JjZ10cgKBgyLW20qIf7a/jU+SyfTJs/3Ks86WXlcQzcl+A4/thVwHr+bL6J6uSQdECqfKcmzRwp3Zzsj8GnTjcasRAKS+kkfVtgxdlyLeOoOcpZTNjV/UZajGCb1HfYEmgg+LSSZLoRoj2YoK4fODdG8aHfN9fSSuoQVrVvToyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728982239; c=relaxed/simple;
	bh=AWMshC5EQIRqZ4/MICxqubkvy775QQUgUfEjntXNLq4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=dU9+jJEcU+5QnBYHuTWZwfhoXZ6a195MqAus3Cn2uqbQtJOr2FHx1LNJDm9WtlZDAcONYw5LK6mV8kL8QavGzZbnyHNhZVCmpxWvARoFKiwhOWO/E+8hznXTXrpyn6sWmtlLYpC0fLrbumHvXeR6n4+IvsehDddR17PBSSmw49Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=UvS+L7DJ; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F6QIka016493;
	Tue, 15 Oct 2024 01:50:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=AWMshC5EQIRqZ4/MICxqubkvy775QQUgUfEjntXNLq4=; b=
	UvS+L7DJLU42DtVA92K/RQ3LPWYIkoHJd+Q1Hu2t+YuYOCF+K3QqI2kAM3y/EVbJ
	UYWoaxnq/TmlGMUCXMIug8e0JwVKGODZpakSH4gWZLZ/DSxRYSCONulsBYQ8enlA
	8x56es0qAfPxT8LdOwpkidkn2CZwYQT2lKZkKZDwt5ld5o1it3jBxsqU/41MEU0/
	bDYmlU6F/Hv5xVMoqTI9nqqT+ek3YsNrOsmSamAEVFwcQ0BLirjF7f1ap6IaqejE
	guFcnjo9CHXPeF3KzueYqnnwRy7tuHJfwFwqlYK/TtYEFpsPIMYdcOcJREDNLfSZ
	hc17PFf8d9MZ6xFDY3h6Jw==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 428c4stx1s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 01:50:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnOWP7Cnc84Ij0AwwPI22H6TNaffKgejncGTQzUX9NQuKaK5Ct6d6vpmB9rR68ofDm9c+vdJGMa1hXxNC7l1jtXbiIZ1etnK1vSPnRq0WaIWFUYSMLE1XU7+MNjOQOSgI9ZZby0lUtWM5wlCzEdishcO8k9uPJwoOw7M9QhgPu2lrTjNZRMg73X1/adO9doVcapASdvPWwRIKRy815OetZLuMgDgqAS7zF6lw/jdfCWkVIisjKClqsJlqXTqjUrz4z09igCsYejDRcJuYsuMRdtkd5UGVW5QM164149OINKy5w2hQ06gcuxV9UV5Vqg5GCGXBUCz/FeACyxISGFlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dk8KnLIfN90I3etmTPxUEzwaZU3W1NTgFeHvA4iw/+4=;
 b=QIB9KYLwSrHRd9qGH/yev01qVka2Je8Mc53SGG11HomW5PC0yvOeykTPyCDU/Xw97xl7t8bqGLuNfzHwETm7GyxrVH/Eo8sxbWdbMszugVV8oda/Y9xTrO3WLeWKHeVcPk1WGlmxjeHm7dsu5h4DrCVNkMXJ4B+XmwHQ8wJYerujrXnp6bJ1cQwLAdaQz9jyVy6CPkQylFFJziScKvwaQmL/41eq41ZGG2pbYuvPawyCkJTuq7hJ511DJFlJdM0jyt46uJBTdU9uNBjQARVHlGa5kPknsXCInazDZfjj9vCnHhFoAEe6Vfl7hJGCoB2X3dm28Z9sZXx529Y96Jv7xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5659.namprd15.prod.outlook.com (2603:10b6:510:282::21)
 by MW4PR15MB4555.namprd15.prod.outlook.com (2603:10b6:303:108::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 08:50:33 +0000
Received: from PH0PR15MB5659.namprd15.prod.outlook.com
 ([fe80::dffe:b107:49d:a49d]) by PH0PR15MB5659.namprd15.prod.outlook.com
 ([fe80::dffe:b107:49d:a49d%3]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 08:50:33 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Boris Burkov <boris@bur.io>, Mark Harmstone <maharmstone@meta.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] btrfs: encoded reads via io_uring
Thread-Topic: [PATCH v3 0/5] btrfs: encoded reads via io_uring
Thread-Index: AQHbHl0hWvUhKg3cm02UtrvBgL2H/rKGhLiAgAD9IwA=
Date: Tue, 15 Oct 2024 08:50:33 +0000
Message-ID: <9e42d2da-4160-4f9f-af24-c5e90a555cac@meta.com>
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014174431.GA879246@zen.localdomain>
In-Reply-To: <20241014174431.GA879246@zen.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB5659:EE_|MW4PR15MB4555:EE_
x-ms-office365-filtering-correlation-id: edac03d4-a028-4e94-13d1-08dcecf66e31
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmZ1Z3NqQ3FDQzM0cnVKSXVLRnRiUkNEMVRMenJsOERrbkw3QU1ZRUwrR3lG?=
 =?utf-8?B?a25lTWhWRFBsbVhaYmlMM2tXb2MzZTNuWmRqekt0WmgyWmYySTUwTms3S2FQ?=
 =?utf-8?B?NHdLajZLWFdVR3I4MWo4dXRCV2ZvTEJPbUNCS2NWektCbWVZeWVBSlRHWXAw?=
 =?utf-8?B?V2cvcW5KZ2ZFWVkrWkQxRTZIS2xVRVhrU1NhMDE0ak45REdhRjk3MjBSUkJy?=
 =?utf-8?B?UXJHWkFLZUJUREQ0czJUTHlQSVFtQ0ZnRUxyQW9iL1hOY3BSZGlPSVk3L01J?=
 =?utf-8?B?ZWpoY24vYVpEd1drNzJHVmV1WjNWeHcwUWhVMDFJSFJiWmQ0SEdrYUN3UUFD?=
 =?utf-8?B?M1cwY2ovbTlyYUFDTERibStKd0k3aEo1SWRzM1RPeHFwTmtzRTF3M1QveXlx?=
 =?utf-8?B?SmdlN2xpN1E4VEd5NFBhMHRTRDNnY2hHd21Kd1ZFYTdvTnF5eEhUVnV2VHZr?=
 =?utf-8?B?VHFRSEYwRDNGbjk3Z25ES2RveEVKMDIzOTJtVVlVcXFSU0FXTklxQnJJb0dL?=
 =?utf-8?B?OWFtWWc2VjhrSFZaSWQvcnYyNGNKM3BGNG05bEtnRlFUdzJ0d2NLY2pwQm5Y?=
 =?utf-8?B?YkhJc3RLNjBlOUwzQWpucWVNOXYrWWlpSFBPK3lkMEE4N3k4VThoMStXVEJv?=
 =?utf-8?B?ZlZuMCtLNWkwVHVUcHpjamVVRFRsZFlneDlQYXFUUWJOYUhPd1ZGMFVSd0p2?=
 =?utf-8?B?UDVxNVRLa0NWTVd2Zmt3R0VkdjFMTSt5dmtyaEdhZWhyNG11RUdXdnBhNTlO?=
 =?utf-8?B?T1loWFJoZXB0S2MyUmJOaDNkZnNkZ1dTampzcVRuSGkwZ2JvQVpwNGwrdlcv?=
 =?utf-8?B?cWsyNkluMXB5ZmNnNjJSQXlRWUF0aDBucEo5VkNYU1puOE5pRy9pckJGNlp6?=
 =?utf-8?B?RjN0UUVma0ovTUtFcFpRU3NhV3NiL0hpRHUzOElLMm1LT0lqZmFkUzlsb2Zn?=
 =?utf-8?B?U3l2bEF0ZnJzZG8wdXNUcmpYSUZuWWFiYTZoZEhhSW5nM05LT1FoanZ5cEZ0?=
 =?utf-8?B?eVM4clJJYi80REVpZXc2azMzVVZkdWs0d0Rrc1BJd3QzbHpINDduUkc5bUVj?=
 =?utf-8?B?N3J4RjUzb0k3dkw2OEpNVWtwclpzMTJmZDNzWUZoRHFIL2F2RklOQkNGM3dZ?=
 =?utf-8?B?ZUMrNFA2MWdoTHRsL1RBeVhFOXNwcnNWK3dMd2tqQlRjNGVEd24yZmxOVlAw?=
 =?utf-8?B?djR2M0t0ZEU5VE5RVTV4eTMxZDUrN3VQSW5MeWZndUt6djdTUjEwRVBwOWhy?=
 =?utf-8?B?UlVHRFEyMUdxOTJYUG1tUC9ZcHdrenlCNjdSOVRjMytsaUpLQS9CNk9OcTZ1?=
 =?utf-8?B?Y3h1Z25iSVNKS29PbU05YnhrNEgzRTFqdGNZcTVrd2ZHa29BMW9jdDZVQ0tj?=
 =?utf-8?B?TjNaVzBuSmFYWGh2Vm9BMGJOZTNETTZ0MVRYTzRJYU1BRy9MV2UyeEY2N1c2?=
 =?utf-8?B?R3lDM0cyc0hTTXB3V1lBN1RQclBwMmVTMUp2cmZXWXRHT0Y5S3pzQndtMmVi?=
 =?utf-8?B?RW1CZDJoT0o0SnhQSXZxaWdTNXF1NGZic1NQQmpzZ2QrK3hpMXdabDdGaFA2?=
 =?utf-8?B?V0lZeHhTVTlBM0U1VTFBNkJyaERFK1hkbldPMlJFN29oZGIzMFdpUE1rcUxO?=
 =?utf-8?B?QnZZb2crVVlUMW5xbTg5NkdkWXNMM0xQNG1vZWI0T3ZuV05tTVR3WmI4WFZP?=
 =?utf-8?B?SHRtSjBRaWVlcTNtMk9kcjVXVitJeUlzeVpNck8wbGJYem9uSWlTbU9CdldN?=
 =?utf-8?B?VXlOeU1NWE5XZE8wRllNL0hDSHVZMXd0QUtQS1YxSHhVQkQrUkNNSnE5TXgz?=
 =?utf-8?B?a0VEWWFUaXNDcGlkT25QQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5659.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aE1tdkJ3UmtJV2pNeUMySUsvSTY0NE5Xc1orR0s5dW94Ujg3VzRQR3luS0ZF?=
 =?utf-8?B?UUIxTEVnNDgxaUxISEpJL3BUd0pNc0VvenkvQUt6U05tdEY5MkRleCtQRnpt?=
 =?utf-8?B?c085UUZUUXBaejFqMllCMkIxSVVFRFYvT0tBR2RMNTVZU0xQVHlWeDdIQkRW?=
 =?utf-8?B?NzB0ODhoNDJWWVYrd2gzOFZKNUlyRU5EbzhMajdhWXBHM1d6Q3J4WG9jcXEy?=
 =?utf-8?B?U1B2c1Q0M0VRbjdZVTI1Qms4NU44ZG1mK2d1T1ZON21XTXk4MXpCZTRWaERP?=
 =?utf-8?B?YXN4Y2VCL2RtQ0FrbUpUOUdWSElXWWpQdldqQnJyeEJzOFNBT2gyV2J3Ulda?=
 =?utf-8?B?ZGtYencrd1VsRWdZOTVma2xhWjgrK2MrUlhaRFZ1SUpBSldBZnhJOWY3MDhS?=
 =?utf-8?B?NHN4MzlZM0NJblY4TXpFM2ZKNCtPczliYUgya1pScldObzJrTnJlZ3hxSzJE?=
 =?utf-8?B?TkttaHBHWU1VR1pqdGo3b1ErWWRuNE9qYmxmaXdyQm5lWnhCa2JrQ281c1Ra?=
 =?utf-8?B?RzdZUU9zWldTQjZZd2FPL1FtUEdlQjhtNmFZRFA2dkdRSEE1K0FFcUdnSWo0?=
 =?utf-8?B?aVNVU0JtL0hBdmFLWlBuYUZBZ3ZIUTFwSm1jTTBZQkpHRnlmTWFXR1NFV3Ex?=
 =?utf-8?B?eW5ITkRTck9JOXkrMWVnRm1YeGx4anBxZ3NLMmhKS1RBTW9wc1pvOGRhQW52?=
 =?utf-8?B?UzlDWGd6bHpma0MxNlJIc3ZJbkI5aWxwcEMvVTVMbVpMSVMycWxrTnBFZlRa?=
 =?utf-8?B?L0RRWk1UYUFBVmR5TGVabmhtdC9xVlJIRHBxdGpTeGRxRHdUSHFRbFZtdE1H?=
 =?utf-8?B?UEN0dXNZRksvdzFieGFjaHlyTlFtSzAwU1U2eVNHVUxKYURLMTUzeHZWN2Vw?=
 =?utf-8?B?TkpoQ1Q0MDVzaURhZFdzZjFXNVF1eGpWa2VSOTVVQjJDcjJiSzlZWlllS1hH?=
 =?utf-8?B?cC9qZVRoVEc5WXFaSTZoYW9JMWRXcVBIanczMEZ3eDN1c3pxSUQwc0owVTk0?=
 =?utf-8?B?OERaZEZwWDRZblJ5VlV5NkxjUFVtZFlmRmdNSHlMeWR3aTUxUEg2MnJZZmpt?=
 =?utf-8?B?YTFmQU1HK0NKaDFLQnM4NUZwSlBXY3NHakFpdnZ2Q3BMTEJIdE10OHY1QzBU?=
 =?utf-8?B?ekFsOXFmd1lIY1JNenZaSWtRZDZIejRmV0szWTF5dHJQd2Vkb1Q3ZXNmYWtz?=
 =?utf-8?B?NVp1K1pzNldQNk80M1B6TzhZL0lzWlhjSzJKQWgzaUpzSUczLzJ5MytEMUFm?=
 =?utf-8?B?NmJNS2tVMWRzZC9uRGE0V1hRNU1PeThWUGpOVkRDdGkwRGlKM2NxeDNRSTk4?=
 =?utf-8?B?YjBNK0o2bkY0TlRpUmxHZHdpTzRSQ1VRSko4cVVMdm11Q0JYYVNWaU9sVWVV?=
 =?utf-8?B?Z0RneHJabjc0NHhKd1dZTXZ6VTh1VE1ucHpFNnpsZElXNDBvSEJmMkJ0YU1a?=
 =?utf-8?B?V25raDBFeW1hZTNCQWxHNjFXSUVJVm5qRk5QL2pZdFRzMk9KYjdDUEJvZk1W?=
 =?utf-8?B?amtkdTY1eU9zTjYxODRDcE9TaXJ2N3hHMnFKNytYekMxV1FlN2NVemVSanVG?=
 =?utf-8?B?VEdvMHpwbDdJbytub1hEdlR1RGtyZnRiemxqb1I4ak0wTWJkZ1htOVNCWVEx?=
 =?utf-8?B?SkhVT25zVnFjYUV6eXhNVHpFZEFxVi82cWNtNFA2UEFvT0ZMRU91clp2Mjho?=
 =?utf-8?B?VnhZa1BCbXhTQnMyQ2tDalg3WVFOWWl1eURtL1NUT2hWalNuKzh2Qmxhbkk2?=
 =?utf-8?B?Wmt4aWhBVGNXMDFPOTlNVmxBQUJWaFZ4YmswNFBCSUJIZzVlKzBmTTNqaEdB?=
 =?utf-8?B?YXR3NlA4YTNneVpNandQcmpMZko1bnk5UHJjdGdXV2dMVEhDcGNvR2MrUXNz?=
 =?utf-8?B?YmhsY3djSVVJTUtweTR2bVl2b2hBZDlkM3FNYXRvRXFLUlllQkFIV0Jldlo2?=
 =?utf-8?B?YnJQZDhRUjJEZ2RzTVVia2xvemFRK1diakhJVlFUcjJLa2piTVV2bGt0TGV3?=
 =?utf-8?B?ZFdiZ0p0K29zaTJnZ0VWeGkvNDJUUkV4cXJYLzNKeUw3OXZwRkd4ZDBXZ3c1?=
 =?utf-8?B?alRYOFBtM3QyVkk0enhjcFRGT3lFbTZjRitJcWpsQjVFOVdYN0drRHlPSkZ4?=
 =?utf-8?Q?fTcQ=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5659.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edac03d4-a028-4e94-13d1-08dcecf66e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 08:50:33.4233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A1hr61YmwPG86AsAjKfROcsOfP/5PMpI6MInJQPhPwBxyh4kjYmiXK6Q4DIEdKRCypC3pf9NgluK6BOFGbIdPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4555
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <C5DBD8B45700E94C8C61DE5AB3198C62@namprd15.prod.outlook.com>
X-Proofpoint-GUID: Es7TorHWxX0-W0Drn6A9T-W8iSGCKlfc
X-Proofpoint-ORIG-GUID: Es7TorHWxX0-W0Drn6A9T-W8iSGCKlfc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

On 14/10/24 18:44, Boris Burkov wrote:
> >=20
> On Mon, Oct 14, 2024 at 06:18:22PM +0100, Mark Harmstone wrote:
>> This is a re-do of my previous patchsets: I wasn't happy with how
>> synchronous the previous version was in many ways, nor quite how badly
>> it butchered the existing ioctl.
>>
>> This adds an io_uring cmd to btrfs to match the behaviour of the
>> existing BTRFS_IOC_ENCODED_READ ioctl, which allows the reading of
>> potentially compressed extents directly from the disk.
>>
>> Pavel mentioned on the previous patches whether we definitely need to
>> keep the inode and the extent locked while doing I/O; I think the answer
>> is probably yes, a) to prevent races with no-COW extents, and b) to
>> prevent the extent from being deallocated from under us. But I think
>> it's possible to resolve this, as a future optimization.
>=20
> What branch is this based off of? I attempted to apply it to the current
> btrfs for-next and
> "btrfs: change btrfs_encoded_read_regular_fill_pages to take a callback"
> did not apply cleanly.

This is against v6.11, because it's the latest stable version. I'm=20
guessing it ought to have been against upstream/master...

Mark


