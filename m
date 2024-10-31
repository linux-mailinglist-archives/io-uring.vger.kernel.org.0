Return-Path: <io-uring+bounces-4280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C873C9B7FF3
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 17:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 893552810F0
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4901BC088;
	Thu, 31 Oct 2024 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DS/kCq4o"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC541A3047;
	Thu, 31 Oct 2024 16:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730391802; cv=fail; b=PUvKVgy4G17iENYeQucV2mUIlqKK6MOaCXNfdO8QMzQlifEGjla44tk2sraIwg8S45sRCJjVIRHuZq+rB6LJwDa5tBSbFY4EoJeUrAtNx+AK9RsXIAKcncn9DOzKzGU1CSD2hwO+WLGBWNyWEjxX5bIyosezgpVNuiCZsL5qX90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730391802; c=relaxed/simple;
	bh=WEvanaMdVDsfrZrzetjGuk3tZom2XcnG2ZgXqxOwv1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=ZVv9rMJ0nIT3l4qspr8Vn8/9csNkePQEoYeQy9ODVit9iin9DuM6LM0UxGgC8qqkRRJKHWPd/KjK/K3S9jtF4tgsSzZlKAxbqYPYeoefWd7zWRgCaExQzRlzccdwP0bZAkNvHEhbvfXrw5yacNH7r5+HT0FXuPt62RY7kOl5PSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DS/kCq4o; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49V8xLBd011448;
	Thu, 31 Oct 2024 09:23:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=WEvanaMdVDsfrZrzetjGuk3tZom2XcnG2ZgXqxOwv1Y=; b=
	DS/kCq4oAJEeHGBiWsNHL4e4FM7M+FnNGRhtgNZfgcQ0OL+QD18YNbUn7JOL1g+Z
	klkbawRl2fh8I2W6Tvm09EcDHkL8EFCAaibE8CyscP79S0OL/fJ57AgZYtJ5Haq8
	wGh8pFoJVc/DZz/1q+rF/SlGnnKJ421TXue6q3kfwLYvdPKvMec7qxemPtN2FE3z
	TFsO8K0uYJabOVoZdjqbYuY5KIyw1cHuunIAUGz7QYXPpahg50gU9TZqH/ntME48
	Usjpryr7EUjXchAWVGodmjP2IJ5p7zrVLBPgJJ/yi1DMcJn3bbwHYaU7Ss7bHRdd
	usQhelsP0LkvCRmLa/FhhA==
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by m0089730.ppops.net (PPS) with ESMTPS id 42m6ujtykj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 09:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XP34K275XjEUBAcqVgOSP7P8g4vZJbeyNSpf0vd00CrLkdU1bBnpMduSM+Hi5rjYyGo63J+0rSAEjCUDBSDcJGWYEkx+oyeVeGq7V9qJIMQjGzVZocOmZs3LyS1G8Yl29UxUb1wumxXT0sa6xrN1Ou2ZeYagK+koO74UlRFX4CWXlUyElxLslHUfJmFt/LqkLLM3uO531afM5FpUhjZ4hwQZ4Q0X+6YC6SIRNt8FYVQgcILeTEhLaLWCEiuebtfSz0xUWDvu6UHfkrVEh3dfTM1RNX30eha8Og6Xa3eFWj2kIWrAtVPf4g1mOaUbRjdxgiyganuwzPzaAGXnDTHMLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HZmdfJ9JcVME/W2vzWftvLNuBvDRZsciCxF/4WVlYU=;
 b=Fm4HO9hv5LJjU7rPozjMAnePOz4xygcW7fZCxo50s9qyhGIxrChkcgKqJ9yCncYigNca19DVLtzEYn0bLxrxuoWTwg1n4nVz6ZbgxZ8RYxOv5C56jRSfKdPj7ONuin2qQlT2wfK0t6AFxy5RSksHKgVZi/Ue4fmW4nT8ZsF4LcQr3ivFKkXjdw+yApNt6AaW/KaRFoQi+w1qRj/ZnIdBQH//JEC3VjjOeI14k80jayqyAmpY3Z9HqVZn7IDhb1S4pFkzRkWfdwd8l6s9bDu2aPeplDYp0i/3m7cozQ59KFMCrOns5ATxqslTax5uMmcJWP4FhY5/mV3m+Zmown02pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by SN7PR15MB5828.namprd15.prod.outlook.com (2603:10b6:806:352::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.18; Thu, 31 Oct
 2024 16:23:16 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8093.024; Thu, 31 Oct 2024
 16:23:16 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add struct io_btrfs_cmd as type for
 io_uring_cmd_to_pdu()
Thread-Topic: [PATCH] btrfs: add struct io_btrfs_cmd as type for
 io_uring_cmd_to_pdu()
Thread-Index: AQHbK66JtQG59q8hsEaiN403yRHkV7KhB16AgAADbYCAAAA3gA==
Date: Thu, 31 Oct 2024 16:23:15 +0000
Message-ID: <94b8be7c-1091-4a2e-952b-f89799bdd4e9@meta.com>
References: <5164632e-6c76-40d1-b732-5f08f5678f98@meta.com>
In-Reply-To: <5164632e-6c76-40d1-b732-5f08f5678f98@meta.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|SN7PR15MB5828:EE_
x-ms-office365-filtering-correlation-id: 88fb60ee-4c03-49d2-db6b-08dcf9c852f0
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UXZGQm1HQklXUklSa25zaXZIUHFLcDJsVCtTSVFkMnhGT1NOUEFKajc2eFRn?=
 =?utf-8?B?SDk1TXdKRUFCbHVISmtZQlVCL3ZxSitMc0lzVFpubjRWdEk4MFBwemg4OEox?=
 =?utf-8?B?cjNSVVBsQ0RFMGk4Q1VtcFVDV2xFYjZmZWxvNGVsNGc1aEJGUUFLS015bTls?=
 =?utf-8?B?RlNhS3lZMzhkVEc5Sm5VZm5iTm5SR0lpUEJqU1NUb3dyYXcyeU50K0FoaDBy?=
 =?utf-8?B?TGFHQW9qL3A0djIvTUFUVjQ2WW9JOGQwcFdxR1JTc0JGUHpCekhKaG9WRmR2?=
 =?utf-8?B?ZWJjNXl5VDAwRE5sV0xBaTMzVi9UMEo3MDVXVGtDYktwcmdteGNnYXk0c2JR?=
 =?utf-8?B?WnY5NWJsa0tWdnc1RlJBUTJocmROeDBWQ0x1V0ZjeUFBZzU0TzJUZldOYTdV?=
 =?utf-8?B?eTlwMW5tS2JTVWFmVkNXcUM5OE9JWXlDRi82eTcvNWFOeTFVcGw3cGNzT0Zn?=
 =?utf-8?B?Q0ZKeWxmaC9sZjJIS1dTS3ppd3A3N2lqeUFGaGpjWFNFNmJYTnVrUHBoWmw4?=
 =?utf-8?B?ZXVKWEF6WE0zR24wN3diUUVoSWZZdE9IOU5GWFFNUmxvaFNoSDRHQmg0dVdm?=
 =?utf-8?B?Wnh3L2JCbEU3em51MTZHZ094RGNNN1FHZm9LOUtwQU1qSm5hVVhyZWp0NVFD?=
 =?utf-8?B?S0x4RGdFTXB5bHdlT1A3dWpQTlFWRmNwYzhCWDc5MWJyUEkxTDlOOWdkUXZv?=
 =?utf-8?B?dmZFV2pWWEQ1T1NyelQ1WkpCcmlkeWNWNTltMHZZSEprRmtCY09mNSsvTXlG?=
 =?utf-8?B?ZVlHbnNUaWN0Ry9CckJNYjJTQjU5ZWZQUnd0UHQxRE9wV0tGanRXM3Vha2Z0?=
 =?utf-8?B?VHZnSE94T1lxMVdyZ3d4VXphUEowOWpYM1Frc21PbkNXUEtQclBucnFkMXRa?=
 =?utf-8?B?WUpMMUxpSFNYOHZMZHN5M0NSYjhQblFIMk5aWFBkVnN1NU9BNmQ5eG04Rjdi?=
 =?utf-8?B?c0VsNk01WVI0anMyclZKTkNhVDJ4VVAzL1BtTUw5by80YkM4SnV2YW82TE5E?=
 =?utf-8?B?WDc3dGFtblNDczhWS3RNYXR4S1FzVjB2bGJWTXlhQ01QU2krTHhMd3hHSTV5?=
 =?utf-8?B?N01MdmM5dkk2ZDN2Ymp3YWordy9UalkwbHVUek1XSncyNENDdFNacHgxcTBv?=
 =?utf-8?B?MkdDVW45ZjIxbzBwb2I5ZmxuQ3JaREFiV0xUR1ZvYTVqdy9nZTJZNXdIRC9z?=
 =?utf-8?B?Z0RsY0szcjdOM2RMZ0hHc3o5UGFIUmJZQ3NvYTBhSXRhUFdqOHJLR3hHOC9T?=
 =?utf-8?B?Smo4a0NnKzBCKy92eFBGb0hLZWNZc3pLWTNDRTF3Y2wwSzYreHNzTllNdkpz?=
 =?utf-8?B?TUhMTDV4SUJ0eU9peWRxa0FoR2YyVit3UHRlVkNONy9VRnZFelMzM0FoeGlk?=
 =?utf-8?B?bGZ3c0tINDZaR3pLV3VPYzczd1JLYXQxZG5RN0RDZDdlRFBlMklTQzRJdHRa?=
 =?utf-8?B?WTJiYVpMb2N1cVpBeG9QQ0lWRngrN1RJRlBOTU9RN2hsOXVrUEpETk1hcXE2?=
 =?utf-8?B?blBtRWtycXNvU0trL01yOHR6Tld6L2xaOWxPb0drdUJhaTltQkFVenRxYlVn?=
 =?utf-8?B?NGloTTVXWnN1aGZxMmpWcFN3SElpNGdCb3YrY0lWRlRZQTJ4Z0w5UzVLRk5Z?=
 =?utf-8?B?cHBwblI1UHVjME4waXhTTkE0UmduWmpxKytzdGtKektEMjgwbjJpS0pBZmhM?=
 =?utf-8?B?OSs1S0ZScGFjMkJObXJJbjFkVTJDK1pxamxZVGdBOXd0clFDSm5JK1F3NWFU?=
 =?utf-8?Q?1P4DIK7BnG8p/Ti1rEWb1lamx7zeXK4bYMoCyZg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?clpCVmFCVFRoR2xmSElGOEpQUkdTVE9rWk9lQWovc3AvN3V3dVRmQndSbXg5?=
 =?utf-8?B?ZlBDYlM3VFpxeWJ5alNHbkR1YVorR3kyRkI0MVJYNnpoQWJ5NVhKciszcXlm?=
 =?utf-8?B?elV1bTQ2REpRTWR0YTJ0Tit5ekFrdFdEMXpiaFBQemx5UU94d200ZEFuc1Qw?=
 =?utf-8?B?RXBVVkNjbGQxVjFSVUJCVkROUit3UXJmU3lMVUtFQkNkc0M5dFZuNkFQc3Fo?=
 =?utf-8?B?MUlLVTJRaG9tam9lbmdydkR0SmprdWtLdE9EcDZMYWpBSXU2L2hrMjQwNFF5?=
 =?utf-8?B?SU9Hd0JqZTJ6aHpLQy9XQ0ZJV0UzZERLZkhCUUIxM3RBT0FaUXozVlg0dyty?=
 =?utf-8?B?eVFxWGt5UWIxM2RySmRmWkdYRnM4RFBYdkRFdGJ3TlRBUlRLeUJDSFZOUkZF?=
 =?utf-8?B?eEhWc2taRDhLR3FsWG4vQjg1Yi9oRjZobFBQbStraGJvSjJmblBJU3JYUk9D?=
 =?utf-8?B?c0tDbytjSlRUR2g5SVVaRG5hWk9MWnJDdXd2aGNuQnJiZkFOK0o2dk1lT0oz?=
 =?utf-8?B?Zk0zYUN6TklZa2l4TlVPdk8xb1ZRZHA5cEl0ejA4R29VTVI1VUd3RENsbDMx?=
 =?utf-8?B?MXlzenozRkNYU3hpY0VKOU0zeFkrTSs4NDFBWjZRUUpMMXRFakVzQnR5dXhC?=
 =?utf-8?B?Sk5TUlc0SDc3NDJvaDNjVUtuMmRyUDM4R1hZOWJYM3Z3a3N0MGNpcVBwa2FS?=
 =?utf-8?B?WE1ZckFEc2l1Qk84Y2cwekwxUkhKZGkwSlYrSmRySkJqQnlXNUpDa29Sd2Nr?=
 =?utf-8?B?MEdGYnpYOGtMV3lwSXRuY2I0aFF5Yy91ZExXZXpqUHF5d2pjRmk3QS9QTGNT?=
 =?utf-8?B?bWxRTTQvTW1aSVBwNVNZd1ZFMFZVOFROc1NRZDdQNk0rWmlobU5aRXhqS3JS?=
 =?utf-8?B?eittRGoxOHZhbXhzQXREYlV5cFhIUWhMM2VYb0Y2WkR3STVLWmVpZ0dJSHMx?=
 =?utf-8?B?M3NQZVp3aWtyY2ZNaGFNL0NnUVE0L2FkeVZGUlRFcTh3TmdKeHV4QTdScDFV?=
 =?utf-8?B?OU1OVjFiT0l0OXdVdVA5NWdzR3phS05RcmpwcTlvZG51WlJHa3ppTG5zT21U?=
 =?utf-8?B?Q25LbDR5N0JzempZdG9jLzJ5U3E3S0w5UXZhVmZNMEFpbnFBMmZ1bit1WHRG?=
 =?utf-8?B?V01VWEc4d0ptY3NSeFJtR2VVVGxYUDJPT3hQRXR6b25OYTEweDE2Z2N2b25p?=
 =?utf-8?B?a1ZHS01BTkF4ZmR5RDdWK3YxTWJIN3BTZnBwWThVL2duRXU5UTYzQUljQTBM?=
 =?utf-8?B?akhuRnB3M1ZsYmEwcHYyQ2daY0IxcDRCbS90ZWwxSlFhV1Fmdk80QTV5SXl3?=
 =?utf-8?B?bFFpL1VudGFwV0p2ZFIzRHRLaVI0WFVKcmNmTzBRUURoT25BWDN3eU1RUHRD?=
 =?utf-8?B?NithZzFCZFlaUWdUQ3hmY3NWeDl2dDJCalBkN2ZTK3FoOE9CUThLK1VHazc3?=
 =?utf-8?B?WEZTUFVjTER2WXhXcjRzUUVMbUdqaDFBREhwdStqZnFQb0x4a2crSTRCOGJl?=
 =?utf-8?B?aFg0UXhzSytJQkRpZ0NNL2tuYUdVMi9Dcm1EaVRhanVEeXpSaGlwYWFWcVY2?=
 =?utf-8?B?VDBkWG5iZGo3OXZHU2FZbXFacXI5aFpLcnRRT0R4ZTdTa2tkS0ZVOTdXbTVl?=
 =?utf-8?B?MVBZUmY4WUVxbVBvcy8vVlVGb2szQjdLUEZra1JxRDhSUlBac1ZubXVoRG51?=
 =?utf-8?B?ZndTWDg3a2xvK2ZrNStMMU1VUXFiZTNTRHA0WENvWHFYTVc1VE1pQ0pibmcr?=
 =?utf-8?B?WVI5ZUlRZE5ITEpHRm00d01EQzAwQ1RNcDM0UUlnamV1TFIwQURLdlYzWFF1?=
 =?utf-8?B?M1o3Y0M4VVdpblpJcGcxTFNYVWtlek94R2w1QUE0Z0ZpanZ4QTNoeUIwa1Qv?=
 =?utf-8?B?RDZPbzI0RWwvaFBQOXNRNjdOa3F3WXl5VFVjMjhRb3lhYXlKOTN2M3ptR3Uw?=
 =?utf-8?B?L0YxSSs5TVo2aU9ValBaaE9xSldBb2dNRnhwazBXRE5mVnFqUjFKZjA3QWln?=
 =?utf-8?B?K3cyVVFnV1c5UFZNNlpBVDhqODNsQlhvR09OQ3hxMjdoZ3kycnl2ODQrWjNZ?=
 =?utf-8?B?WGMxdDBEODAvSHA4MXZyMExYc1cwKzZ2TXNtNk9TanVFREhLOFlQaUpVamdF?=
 =?utf-8?Q?vHwk=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fb60ee-4c03-49d2-db6b-08dcf9c852f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 16:23:15.9705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m1+b+GLIZkC2jOy0ViY7swePPSgENuc4L2XOgurZd2xY3ep0E/Ln/t7K83YfckP7BgqZH3+eVKvfgJ34CNocyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB5828
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <414C0C626260A045A83AC88445AF5499@namprd15.prod.outlook.com>
X-Proofpoint-ORIG-GUID: HgKMNv5N4CmTsixjAaqrscnFWnfy97Hx
X-Proofpoint-GUID: HgKMNv5N4CmTsixjAaqrscnFWnfy97Hx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

On 31/10/24 16:10, Pavel Begunkov wrote:
> >=20
> On 10/31/24 16:03, Mark Harmstone wrote:
>> Add struct io_btrfs_cmd as a wrapper type for io_uring_cmd_to_pdu(),
>> rather than using a raw pointer.
>=20
> That looks better, thanks. I don't think your patches got
> merged yet, so you'd need to send it together with the next
> version of your patchset, or even better squash it into the
> patch 5/5.
>=20

Thanks Pavel. All five patches are already in=20
https://github.com/btrfs/linux/commits/for-next/

Mark

