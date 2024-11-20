Return-Path: <io-uring+bounces-4872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5989D3F5D
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:50:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A4E52846D8
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F0213B2BB;
	Wed, 20 Nov 2024 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AR1SqSlu"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3182D137930;
	Wed, 20 Nov 2024 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732117846; cv=fail; b=Z81bXNb0/I+sjpRIDWkPdqfiZv8fNxGLQhVFYG2A4rrtisR2n+3mL/TULZ4L7UREwELgAlCmHP+MRlbMR5oA3DqQ/x2moUJssHWD4XZZpfp0RJl7O0jS5fGiSVoC9yoMtjhFS2Js65W1pvtFX8fJfSNy7Xu9yOCnGc5x3VQrGRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732117846; c=relaxed/simple;
	bh=rUFCNTSmcOrizefVIMe1a5EsfsOcsJRUH1Ov/IyJ2Gg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=cFdq6SGiHjpc1MEwEqv6SFoQ4IFEMuLzPPlCE3CNkkZ5eCeAtwAS9SYkPEPFm5ilv9pj0eNHc1aITg+DQqSdjda+ud7ioLGBtqRZi5GbGcYoL7V8IeAsPHBiZpKMg8LHugS7sxW3oSysaXXrJQ5cJQkmH213vdwdxeBWn9lruzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=AR1SqSlu; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AKEoett006213;
	Wed, 20 Nov 2024 07:50:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=0FcBsc31E3nKGs3F3eCoxNINwx71K9RtoLKxUfvTcAk=; b=
	AR1SqSluSyF3zw+RIR9+/b4OykJ2ICie0R7WgfYTaotz142ddyWxRPX28kLrfCeB
	jFIcah9OWLQb54MQO/+bc16o57jM3GIcQTw/qcl1Z2om1wVqps149XDSs8kfdZ/d
	E68h6NgGdO1LDqxudTv+16/5TkPzh8FdG86kA7k9yhRymspq1ql9Kx76oydJLY1K
	Kjf3ylUVtANavGk8+F4QHQN8vNOZm3Op32hXdBbARtlUQJ+KQmkLeL6oZLDH1tFq
	tzOdLf0xsPW2T2FN2ew5U8E7i2D+iPBUclB3nSsrXGvLZvYwUvXEHpDnAN4TMyFx
	IJxVQEcS/1yZIgLSjX36EQ==
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 431e8ghm0s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 07:50:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HL4JACKyYZwMnlKIII/MAudpKSRuWiut4dHTnab4NFG21vd5d9p5Vxf/62xrL8ToGDJpYJEEJbO6mGNUEa1FJD+yyPiw5UCq2PcZ1h4lK3H3W/zMp/d9KgEYBHhOf2OrS0JHi4FR9OhTz+geT1c8A6pWLk2JmctuLtxyBlYsNEj3Tp0XW7Y24ldPdE4frESm3FW1O7IU6c3DQJED1xOYfOhDLwx3gNyPhRbRREwXKM8KTFAiusgUfT+8v4NJUPC4Q/DM5tslgZ5XNAQ3YYOKGAyOVg4mnV/TzWUHVV4jGoGbvfBVLhcCQ65e/hixpH4A6AVDVh7NL8tHOY4zr6rfvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMeFyrX658TjK5EXQg+Hb1ZhOCNy/gI3WLmFPr0cSD0=;
 b=alJO8m+mjwPBFblPSZCEUeHSCFNhdnDeUJ8ZHoHuhsjEabDazOWSBnnXSq3i144gBE2ssrPIK4AIN2fATRlMLNbW1bgU44Fjc/p6PMWyp3UEvv9lEcs4K9fMs/yoGACaKPqlqveMI6YArxTP123/IRoVK9Phb2H/tMVWmfhp7Vw3z9goCiQGkKjVmUXXevPLSIA1nM+uxmSbw0MnJupnekC7NyJXwJtMiOotbUiP3SYIKGakKbaAQMRDT8j/Gj401EJWenMiKX2AEdLkYS7IqnjR5Wv8HAP6XinAS2u8yVjCnp605H7PtevDCRpGXKfuC+h6vOhyUas8WK5zcyR/+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by PH0PR15MB5264.namprd15.prod.outlook.com (2603:10b6:510:14e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15; Wed, 20 Nov
 2024 15:50:40 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%4]) with mapi id 15.20.8182.014; Wed, 20 Nov 2024
 15:50:40 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Jens Axboe <axboe@kernel.dk>,
        "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded writes
Thread-Topic: [PATCH] btrfs: add io_uring interface for encoded writes
Thread-Index: AQHbNSBtaJCXHCfze0m8qru/4VIzGLK0IeiAgAACrgCADDkNgA==
Date: Wed, 20 Nov 2024 15:50:40 +0000
Message-ID: <fc40c4a2-fc0a-40ad-9bcd-8218aad96646@meta.com>
References: <20241112163021.1948119-1-maharmstone@fb.com>
 <5ecbdce7-d143-4cee-b771-bf94a08f801a@kernel.dk>
 <ac7a8504-8d83-4ba9-9518-98288bbd4b52@kernel.dk>
In-Reply-To: <ac7a8504-8d83-4ba9-9518-98288bbd4b52@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|PH0PR15MB5264:EE_
x-ms-office365-filtering-correlation-id: a49ba1fd-5f56-427d-896a-08dd097b1596
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UlpFYmdzQ1dMS1dzTGIydzNVSTd6VTFpbXMzSXhIRTFGTzB5RW1QRGk3UThJ?=
 =?utf-8?B?U1h2UkxYcHVKTDJlUDhPRUhuQjNrY3FINGNkamN6OE9kMVBoSzJRTFJ5eEk1?=
 =?utf-8?B?N3B4Qm1pMkIwYWo5eExXdHVOTkxHQ3BiSnRxd0V6dE0vS1hMbEo2ZlBzUmpQ?=
 =?utf-8?B?L21VMFRHK3QrVnVXVzZrQUxnWFYzeFZNZ25tcXVXL1paMGFxVVN2cjZyck9M?=
 =?utf-8?B?VW4wZ2x0UXIzM2lPVnIvZmQwdS9UV1dYV2lKY1laMml4a2N2aWZ3dHlENkY2?=
 =?utf-8?B?VnQ0WWdrMUJXK21LYnBFZGxVU2phM3VmWEdLUFQ5d1F1RHh3R2EwbHNmcmpB?=
 =?utf-8?B?S3VGeFQ1M00zMmVjR2R4a1dxVlE4dnJFZVNJNThoSjRaZHUwbENFc1dPeU1r?=
 =?utf-8?B?K1VFdEJMMzNMV0lMR2piaW5adGF3RitpNzdRakZtcXdEdjI1c3grNk5ZQ08v?=
 =?utf-8?B?OExGdCs5VFRmNDJqTThZc0l3aXArV1diaHpEVXBqWHcrY0dPUHkyUjlNMkVG?=
 =?utf-8?B?eGowV1k3eHhyMW1JcXh4SW9OYkxLOXVMS2JGVTZMYXJkRUE1YkxpNmI5Szdm?=
 =?utf-8?B?VU9Db1g2RzJBQUdkdENuK0RTck9iQ1VQVWxsM1czS2lvWSt4c2tRaVFodmNG?=
 =?utf-8?B?ZVViUFVjNHVvMFpqalZERnBld21uT1p4VGNoVUJneU1iUFk2ZkZZejlZSGJo?=
 =?utf-8?B?THkzYWFjNFo4dUtLN1g0YWR5bGJCK0NGUXVNWU0vNGpWNXZDMlhSOHNlNGN6?=
 =?utf-8?B?YXliM1o2NllrTEh4ZExmSFlORVYrTE53VExEbjBMMVhCWkVqZWwvSHAveDlW?=
 =?utf-8?B?aVdIWVJJY3ozQ1ZmaVNnTHFkNW12ZFp2R3lVYk54akFsZUN5QUhIUEIvOEo5?=
 =?utf-8?B?dWE2R0grR3RqTEFjK1o0ajY1TWluZzA2VFdIVHU1WnR3V1hZUGZ0V0d2MXVj?=
 =?utf-8?B?VTIrVkI4WlFacWtMZTRPa0N6RVZzb2pyWFMzWjVENUpWMWZUY093MG9WQ3V0?=
 =?utf-8?B?dVA4UW04Z1kvQlNXbnJ6Z0t6c1VJSVZ1WGJtTmxUWXFrN1ExdVdsMUVITy9C?=
 =?utf-8?B?alh3anphNi9NZnkwNFpVWlEvNk8vZFRzbHc5clRYVVFQc0lmeC9GZG9MOTJZ?=
 =?utf-8?B?Z0h5NWRvSDkrTEtzb3dpSmIrV1U0T052RXh5OG43QjAxeDdacGRtbUVTUWt1?=
 =?utf-8?B?KzVmendnYVdmUStDQ2FSSEVpanhmQ3htZHlHeXNESTg2Qm1BaTQvZzIwQjdh?=
 =?utf-8?B?ODlOOGVUT0hKUGJPMUNOSExpSi92cmpwS2JMaGIzSW9iUDl2SitHMXpOd05j?=
 =?utf-8?B?TUZHSE8zYk54UklnQ1d2eXlGNTRVcDFnZ0pjSHFYeXRzSHJjTFV5bGVXSVpX?=
 =?utf-8?B?RHhhSkpnRHhLMnIyUjFYNDZ0QkYwZks0SU8wdEZ2TjUra0J6dzJtTHpQWjZT?=
 =?utf-8?B?TFpuaFpLRjd0Z0NPOU9xVGpVOXp3ZXdLTERYM2hBSFgxdStJdHdjZ0hJcDFn?=
 =?utf-8?B?enRBTE5XcXRrK0dMVnk3R2k0bmJFa3I1SFpSbllBNlZybk5vUlJ2d1R0Qlpq?=
 =?utf-8?B?dWowTXhXNnBuci83VGZhaTVyeFdpQi9QMzN4MzVBUEJlY2tIWGZCZGZIWHF4?=
 =?utf-8?B?RWF0cld4dHI4bkdpNVEvOTQ4SXQ1TFhzNXBnRGhOaFMxbjZIeUZobDBnNmk5?=
 =?utf-8?B?ZFVrd0V5cVVFRzdEcEM3M0dvbWxuZXlZOVdWRmVBdXFNK1hlcEkzTTFzaWlI?=
 =?utf-8?B?L2VrWE1ORkQvVmFyb0ZwWEI5Rkpwb2VXTHB5bTNuVERhSERlSS94MmNON2NY?=
 =?utf-8?Q?vzoUmUhRjz5D1Vvx8dWM4iManlSUBH6m9O5rU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RlJlMzdPZkE5cXF0TXZ1WVlNRkNPK29QUTY3bHd5TGxQTGlEY3BFRVRUdmJo?=
 =?utf-8?B?M1FxMmVlbWY2RWJRbXBZbTVFRGtXS1lWQWlrOWI5SitVSzdxY0gyTUxlSjR5?=
 =?utf-8?B?UFNWNGR3WDhQRU9ZSUMvWjYxUGFLV2ZlVjZHcDNZMzF1U09BTFhMR1dqWUd1?=
 =?utf-8?B?WDUzTjVPVDFIWmlTOS9rSlNwYXJFaWZ1QnpSK1pzQ2tZYncvN3hCNXhMaGZE?=
 =?utf-8?B?RW90Y2s2T1V2L2NxRzNEV1RZUDY0cldDMVNLV2piMkZaVkc2dDFYWmJabkhl?=
 =?utf-8?B?dkEzR0tvdWRhejZkbWFuNGVCd2ZicVNFNFlQU055MlpsNHZTOGU3bWtrTThu?=
 =?utf-8?B?ZlVrYTVXRDYzbVdOOUJVTWpGUzdwY1R0d2JLc2J1cUYwV1ljanJXbUxEN2ly?=
 =?utf-8?B?TUdhb2dCRndhUGtLVmxMMEZMS3U4RnQyaXg5ZlZqeG5vdHB3SzJVUU5mLzVj?=
 =?utf-8?B?R0UvalBOMko3dzZoOFhKa1RiYkhLVjVkOHB5RTRSQm5Yd2VDRzV3Q1dwV3Vv?=
 =?utf-8?B?RXo3T3VtTDl3cVljbjhsdmowbzROUlcvemdMTDUvUklzYXRBUHdDWXhFOUZl?=
 =?utf-8?B?WUZKbUd2RmFsUW9mQTdUWExtQmhwZXNTaU11K0k2Q1FRYkd6cjFMWklzQW9W?=
 =?utf-8?B?QXhzSkw1OFlDNWdQK1cvQXdLVEJ6T0Fzd3crbnBxb250dG5HWkZjTWVFQ2hF?=
 =?utf-8?B?WEZ0R1FWVCtXNzluY0dHbUJ1RG0vaFlDRzJWRkZRYThIbkNEK055Y3IvSkZI?=
 =?utf-8?B?amxGTWNOMi9MVnV5aHh6NjRycEZkRFE0S2E4dk51OUV1b3lnL2E4WDlRWm9v?=
 =?utf-8?B?MjlvcHlra0tMWllUcEJGOHlQazRZeTJOeVRyRDNHUk9OaUQ5RWZMZVphbDAy?=
 =?utf-8?B?TTNqNEtIMUM5MjQ1Nkd3M05GUDRGTC9YWTI0d1BlSTE1MTlxQ21rUVpDVU13?=
 =?utf-8?B?SWRCQ0xJZ0s3Zkw0alNuem9rOHhJMXB1RDFZMUhtWk9yVWRybEE5YmlBMjdQ?=
 =?utf-8?B?N3o1YjRpL3pUYWR0dGE2Y294NGgwL05lcDRYM3NyQWlnOHNIM2xTMCtJbnZQ?=
 =?utf-8?B?aElGdmovRERmdkxxeDkrQVV6b0pBaU04WTR6TXN6NFgyaEpCRDlCejFqOUZ2?=
 =?utf-8?B?QUdoS1ZDY0VNcVFzWVQzM2ZmSnF5UEhqVklheE8rcytFTmZnbUZLTGJ2THQx?=
 =?utf-8?B?T1hHRll5QnEzcjlxWnJxRFZMWHE2bnI3bDEzWExLWFdtaEhVdXJrUEEvVTdV?=
 =?utf-8?B?aGNPaVdLdmRDZ1JvT1ZIckU3andVMlFpUzA0azlRU01FZmxVVEhYYXI2WW9Y?=
 =?utf-8?B?Vm1KWW1HblhmS0ZlZ2I4bE9kTWR5T2l6Q0ptRGJ1aDJSSWpTbUxsRmZXVXF1?=
 =?utf-8?B?a0lOdjloS25MNEw0OEMra05sc2ZVTmZvQy95UFp1VWtRcXVkZUorRjFCT3FR?=
 =?utf-8?B?RTc1SEkxWUMyczJIS0V3ZlhJaGpteFFCdnFYUmx2MHoxTlNTMy9PVmNuMmFl?=
 =?utf-8?B?OWFlWTQydHZoS21yQzRBSE05a2RXM0ZEUzNNalQzSTh1S3MyMUQzY3VCRGEw?=
 =?utf-8?B?R3Q1RjRIL2pvZUNLZkE0Wk1tR3NmNjV3ekFNeVVueHliaXM0azVJdFZOckNk?=
 =?utf-8?B?K2U0L0RsMDZCSTl3WndlRnFpaWlEYmpvYzdqVXJBV1hDU3dxdktpcHdBZXdn?=
 =?utf-8?B?RXJxd1k5TEw5Zmg0dzBZYUM0RkJmYWpuSHNuUlZ0aytqVGFuMSsrbm90dzk5?=
 =?utf-8?B?Z3ZaRzI4QTUxVnc1ZXMwQ2pvU0wrWnZINEpTM29EbkxGWklpN21Odytpd0hU?=
 =?utf-8?B?dUNhZ29ZMnB5Z013WVZIeXpOcWdQUVlQV0RJeGZKeXhCUzBhSlZSTFpkNmVo?=
 =?utf-8?B?aU5nYXNzeEtzNGtITC9TLzZYZUs5YjFMOENGa1V1WXlvWUM4MjlTWUpzMlRO?=
 =?utf-8?B?QjdXNDM1UVBTa3plUDBSU1hrNU5maDNMa2xKY25nSXVqa0FrdElRWFlKOFhP?=
 =?utf-8?B?N2pQUzdRUU1UWXFIREFYU3NyMWt3bHVsc0ZnZnVPZlpnbTJBOTJ5T2RJN1Rt?=
 =?utf-8?B?K1laSGhHRG9QekY4aldybVVQd1MzVjBwSXdpZjY1dGZjTnhIREcxeXRFdCtU?=
 =?utf-8?B?YTZqZHp0elZIMWExNnlUKzh3Z0xKb1o2SXFlQVF2OWJiTGdkVzIwTGZtVlpQ?=
 =?utf-8?Q?ZdZO041endE/SfZx5SjlAq8=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49ba1fd-5f56-427d-896a-08dd097b1596
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2024 15:50:40.4127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mVTSfv+LsrsF+Zn4NVFWJdg+2iMakEXZXjoMD7yvL87UXKp2Vptn55noslHxnRccdsIRJ2s9lZ5us4Y4wzxvrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5264
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <9246AE5BFF330A4CAA2131ACE1E76456@namprd15.prod.outlook.com>
X-Proofpoint-GUID: p_A0SHZ_tVXHOgw9vlfbfTkA2Ri-R2vP
X-Proofpoint-ORIG-GUID: p_A0SHZ_tVXHOgw9vlfbfTkA2Ri-R2vP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

On 12/11/24 21:11, Jens Axboe wrote:
> >=20
> On 11/12/24 2:01 PM, Jens Axboe wrote:
>> This is why io_kiocb->async_data exists. uring_cmd is already using that
>> for the sqe, I think you'd want to add a 2nd "void *op_data" or
>> something in there, and have the uring_cmd alloc cache get clear that to
>> NULL and have uring_cmd alloc cache put kfree() it if it's non-NULL.
>>
>> We'd also need to move the uring_cache struct into
>> include/linux/io_uring_types.h so that btrfs can get to it (and probably
>> rename it to something saner, uring_cmd_async_data for example).
>=20
> Here are two patches that implement that basic thing on the io_uring
> uring_cmd side. With that, you can then do:
>=20
>> static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned =
int issue_flags)
>> {
>> 	struct io_kiocb *req =3D cmd_to_io_kiocb(cmd);
>> 	struct uring_cmd_async_data *data =3D req->async_data;
>> 	struct btrfs_ioctl_encoded_io_args *args;
>>
>> 	if (!data->op_data) {
>> 		data->op_data =3D kmalloc(sizeof(*args), GFP_NOIO);
>> 		if (!data->op_data)
>> 			return -ENOMEM;
>> 		if (copy_from_user(data->op_data, sqe_addr, sizeof(*args))
>> 			return -EFAULT;
>> 	}
>> 	...
>> }
>=20
> and have it be both stable, and not need to worry about freeing it
> either. Hope that helps. Totally untested...
>=20

This works, but I get a KASAN crash because=20
io_issue_defs[IORING_OP_URING_CMD].async_size is now the wrong size.=20
I'll send a patch for this.

Mark

