Return-Path: <io-uring+bounces-10308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C07DFC2474B
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 11:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A66973A8386
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 10:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C8B33E350;
	Fri, 31 Oct 2025 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="mIsOjBuN"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B92727FA;
	Fri, 31 Oct 2025 10:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761906471; cv=fail; b=ZmKp2Sx+c+/OZF27vlf4zYaR/dlGjD1Zuu0p9ThuHLvGQBhvI7qS3QKdkQmJciE9dujO5iDeEuZ307cgic++e05bMN03pUI0mJHKLghvJsTs0jtjAzUMFCgMp2H3amgPV8OL3gOdxTqHE9QJGnl6J8lRSt5zrmNjulEaAufKjI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761906471; c=relaxed/simple;
	bh=d9l2RCFWikGi7gsOW0hvW22oprdAotccfQNWMVqZUAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C8lgcBs7omt6naUj3YqWCbMjLqect+2WiwArxNetMkzwVJQKBOpwf+wqmpQtmtJj+MZoh4bodtESl5HHjc/NEMSnMT8pxCh/6oqOJKvs8XJRhLyQYjZO5VbEBJjw9N1T6QHRn3LjN4UEJaoC1fg12WnD35MF9L5BQSro1fHVoAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=mIsOjBuN; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022112.outbound.protection.outlook.com [40.93.195.112]) by mx-outbound9-177.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 31 Oct 2025 10:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxek8oGU8hLn3fUB25Hn6Bu/OkioIUXhTMOjy6XbViHTxuvKY0EK03HXF1e0wS1rnEh7I3IIKE1MDFj+i/pyEPHIr3m9Quntth6hPk0MXirY5JflvKaMDXa41gjsVTR5z5P0KQ48hHgFm4ufvXN/A1vdCzhKBw9Nnjf8x3oJH44K/5vyyrAzHfx/Vkx9xiygi+7pRo8u2e2FFDvi9LfaUyrH1GAE/KGkQpSuZR6/W9/eODDBUeZA5a8ztCfjuojJZCBED1uCxpCTCgYzmr+E/wrKAtjwQlCU8yMWRLEb8Msx5YE7XVaA8PD9+vxc9lNyJAo5eaVXaL804f2wyHBXzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9l2RCFWikGi7gsOW0hvW22oprdAotccfQNWMVqZUAA=;
 b=TuKyI7K/r5ExE/FQDRHG6vqLbN9FEr0R4GFA1a+TTGkRMCqX7aDT9ZTJE+WH+vig0mzwB1AMXxB+HlSsK20K/5J50LcDSN2/iUQDIT2dNqz2rbc9ivEbaqrkaMZ8G7PIoHKN9HIE9JE+UIXNq4wh+Q7s+WVfkruoSbqaiVHJU8j/RSKXJuehqsfdwJCZpQIzquOfKCX1ZLfc+RLbAxT4xQBy8bTx6auvxla8h5jlmZPrs8YwMICj0Z8O+ei9bgeHJweSC3AMV8iuHVCwVnfBNKQdl4TESbMaymlVwrvil6proOmjPE1rSeh6G6ylWloNqpKX/ASWuMr34vGXRrvJow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9l2RCFWikGi7gsOW0hvW22oprdAotccfQNWMVqZUAA=;
 b=mIsOjBuNhmzcaWYcP6Tk+nx/3CMOFdf79PfJNGYpoli1x0uR/Xto5RORupV7ujIZ6mVvnqEv9+qTksG5Q2XsMpDnjKSh1tctW6bhGmBxRxu8S/3/eRjxY6hlmmrUH9DGzuYCXjcjFoDhSiEA9rKsom3qGrAmSOQaObpOLLQbAPU=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DS7PR19MB4405.namprd19.prod.outlook.com (2603:10b6:5:2cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 10:27:36 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 10:27:36 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>
CC: Pavel Begunkov <asml.silence@gmail.com>, "miklos@szeredi.hu"
	<miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"xiaobing.li@samsung.com" <xiaobing.li@samsung.com>,
	"csander@purestorage.com" <csander@purestorage.com>, "kernel-team@meta.com"
	<kernel-team@meta.com>
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
Thread-Topic: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
Thread-Index:
 AQHcR5EzYLvJgcs6rEeOcRLohsWIn7TZKf0AgABM6QCAAYm7gIAAR+iAgAAYT4CAALH3gA==
Date: Fri, 31 Oct 2025 10:27:36 +0000
Message-ID: <ebecc186-b5fd-4c55-a253-64c889f17062@ddn.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com>
 <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
 <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com>
 <96c4d33d-4f56-4937-bae7-9bda17f3264f@ddn.com>
 <CAJnrk1ah68G4NpDj8A41tX6J2M+NB6jNAUYdWEzTD3N_QrDJ_g@mail.gmail.com>
In-Reply-To:
 <CAJnrk1ah68G4NpDj8A41tX6J2M+NB6jNAUYdWEzTD3N_QrDJ_g@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|DS7PR19MB4405:EE_
x-ms-office365-filtering-correlation-id: 1bdca987-0e17-490a-6608-08de18681c29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QnM0cG9oWnJoSGNEUHpwVVJiZTJqcHRyUkwzTGpIU002eUkxQWk5eGFXUnNN?=
 =?utf-8?B?d3Zad1UvRUREb0I4VVJJcG56dG01ZEMxMU9wYytKcFd3aUtjSURKZjk5aVFa?=
 =?utf-8?B?NmNFbk9ScWVoTGpYQ3lCRXNEcEFYMlhaaGZiaGh5TEh4NTNPQzN6Tjl2RWlD?=
 =?utf-8?B?QkZiendKUXo1RU53SXNEYnZjb2hIK2hVdHNuUUJsaUlxUzRrMVV4RXBtY2ps?=
 =?utf-8?B?N3ZMMUpsQ016N1NFZWNIcXdsMkJQbjlMbjVWRFhzamxES3I5N2wzam5zTXV3?=
 =?utf-8?B?UExrQ29sSnpWZEt6dnJwRFhzYlgxTzZ2S3oxbm1NUmVORnB3QWRUR1VqVGVB?=
 =?utf-8?B?MXFCOXF3elVuUXlObHJ1c21MTEd0L1lrQmltUFlzSk5NUTVBblkyemlFNlp2?=
 =?utf-8?B?RDQyc2dKa3YxUVp1bFhOM0xCVkNNQ0VQT2ZJdThnK2tnS3p2ZTl6bXlUc1E4?=
 =?utf-8?B?ekJwWmJPaUFkSTlsRmNDUTg4dmhMaWo5NFRlVFgxOU9PWEhKa3ZSbjNTVUQy?=
 =?utf-8?B?d1N3c3c5SjRtbHBIQitaUmJxbzlQM3YxZzBaNmlSdGtINmlWSFozc0NMSVlm?=
 =?utf-8?B?Qnp2Tmw2RTJNWld3YWt4RVBmaGNTM1hkTWFPcDBuTUFkdTZiY1IwM2lpaGdE?=
 =?utf-8?B?Uy9jTE5NVGtjKzhRdVZ1cnNHaXQ4aEVETUx6SVl2ZjZEdVpkclVtVnBWUjFD?=
 =?utf-8?B?MEh5S0hmKzRRUEY5bkU2by90aVk2d2hiMFN3WFJkSjlwZUt4d1FPYU02aUI2?=
 =?utf-8?B?ZzJ0SG02OGVxWUlRRDVLUTNvb09uaVp0Q2lHV1R4Tk1rbkRqSVVhZzRzNWZj?=
 =?utf-8?B?TFNSOFg3L3ZkSERHWWhHMU5mbGxMa1lBRmU3OHNuM0piR0xQNHFEdG56Y2ht?=
 =?utf-8?B?YkwrUFFlWERjY3paT0xtQ2VMVXRpRkkwV1V0K2VCclZMVDRZSGhjK2ZOc2hH?=
 =?utf-8?B?WlZycGl6djZQNlA3b21Ed2cyUjdVdGdxVzYvRDZlRnZ3UE1Gc2pZV3dyYUtJ?=
 =?utf-8?B?L3l5RG0wQi9ZZEtncUR0Q2s0VHJ1RyswRHFSU1N1a1NkVjRoUm10VlJwZzBU?=
 =?utf-8?B?U2pmdUxlR0d0ZDhsY0Z6NkhCTVh5UVcyNi9MTEdOYjdURm11d2hGMTdYSkZF?=
 =?utf-8?B?UmEyRkdiZFgyTDJVa3JrRWY3UEdjMXdLN1JZK1RpMzNzVllIOE85MENnY3Nm?=
 =?utf-8?B?YkNYRkFmYjRIZjE2bWZBWFpnTXJHWUxYY013NEl4UC9uZ1kyWWUzM2FTcVVm?=
 =?utf-8?B?N0JaQng2UStWaHdIWVVPYml4bXRMT1JKa3l1TThuN21vS1ZuR0tMRG9yMnZK?=
 =?utf-8?B?SXAxWWtnVHlBN25tenV3clVlOWoxTTY4emxsMkw3ai9HU0JBZzl2TnE0Tmpj?=
 =?utf-8?B?SlFOMDNLZGZ0YTl3MHJ0cDZ1RHNNMUsyS2lPeDBpOGVmRFFDeURzT1dmSWE1?=
 =?utf-8?B?RHJRUE1LMEFtL0JhLzlXR24rdU9LRGRBUW14Y3d0USt4ODY1S1JZMkV5UkNy?=
 =?utf-8?B?dHhJK1pvRzhyV3RsMm5Ba0FkanpkVDVhalBHRXBMU28xRmhLQU1wdzgwMnJO?=
 =?utf-8?B?K3RMOU9NUDhEakhaMkNQeWhxMUVvS1dDYk1Ud1BWZmRXanNDMlg5dnE0QThr?=
 =?utf-8?B?ZnhlNHk4RVdoYUlmbFBzVFZicmlrdE9GWFlsZlJuT2dCWmQ1NGdpa1h2N01k?=
 =?utf-8?B?MDc5aFNoZDdhc2MxQnBZQStJRW5NQUxEK1FyYW1tMEJQS3Q0c0RyWURnY1U2?=
 =?utf-8?B?OGlMMCtWTE9VMzBKWVhRNWE5Z2JBMTJGVkdzeFgrS1BnUlpBeE9PUjhRZEdi?=
 =?utf-8?B?SEFUK0lXdXYxZEFSeVg4YUpzdzVnS3pjcFVWY2NEcmpyeEJ0REJBaWdPK2Rv?=
 =?utf-8?B?MWFBYnhHRFF0STFzcDhreSsrZExoM3gwdUowUHkyN010bnE3NzA5RjJReXNt?=
 =?utf-8?B?eDV4T0xENlUyMTQ0MDk2VWxYYUJndUg4VkdreXNjeVN5R0lsWkhrMEdwWWNq?=
 =?utf-8?B?bm02NEUvWnRzUEQzbVBqVkxEVGJNUmE4VGR0Ulp0d2J4OG0rUVQvZmJIVVA3?=
 =?utf-8?Q?0OGtc6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aVBsa0pjRnpUUEdYNloyWXdLN0xQb29kUjFsbjB6aVJmNCtoVlR6ZzZyazN3?=
 =?utf-8?B?c3IrT05pRGdhaXBtemJGVm1wYXl3OVRDcEtHaGNSSHlEUldod2FrU2Z5RmdJ?=
 =?utf-8?B?UUdFMkRLMXk2ZWcwSmRaVEVRN0VYMXRkek01U1lmUVFaajRGWXNiSjFzQWM5?=
 =?utf-8?B?bXdxV0JwVnk5U0hLUlFBRERPQkxPb1FManVQdTVKTXdENk10dnNyOXB1djlE?=
 =?utf-8?B?TTFHc3VIb21rUnVkQkVzNmdoM1FzMDZrcHBCdFdad2M1ZjVoSGZQOEhVMmNk?=
 =?utf-8?B?eGErTDZmdXhMZ09rVC82RERUeDNhV1UvSWJTRDE5YXNncWhQV1U3bFJkL3hM?=
 =?utf-8?B?ZWJZbUs0b2dhV3FxWi8rNGc4NUg0ekJWUWRMdlNtWmF6bTVmL0FoU0ZGajVF?=
 =?utf-8?B?N01uMFZZTjRFS1h2L25QTUwvUStUL1J4VWYwRWhDUk5RTGZWL2FSY3pxTk4v?=
 =?utf-8?B?em5xNytpRUtOWUFNdDRMTS8zLzJpK25PSldQNkJzbnBsZXFpOXd4TjZSNk9D?=
 =?utf-8?B?cUczVnJlcEQyQVdrMTlpMnFVcUhXRzRkUFJyNDBTQm9lM0ptSnc3MG5TN0ZS?=
 =?utf-8?B?WElmdnpaNlZsbnZ6MHhuaGY1RXJWRjlMZU0rZU1sWmZsekpjN01BZHI1ZWdY?=
 =?utf-8?B?eXpjVmZMQy9VM0I3YmxVeVY5MjYycWFGd3RKQ3ZUVEZ2czhwWWxRWnhUVDhy?=
 =?utf-8?B?RVZ2WTZ4Q3ZsNHdYSVR3bU9NaWlQWEVUcmVjb1Y4N3hSNlNGbVZ0c2R1SFdE?=
 =?utf-8?B?QzVSTGtDdStTVFM4TkNNZC8yOW9lc0NEWHpuR1h0b3BJT0FGbHk2TFJ0Zkda?=
 =?utf-8?B?VkhaamdoSGpSb2ZYQkpFNys1dWFuek9ySmpsU0ZTYTVCdTBwKzd5NWhaWUlR?=
 =?utf-8?B?MDVhMis1NHkybXN1elA4ZnlIT25MRGtvRDB4VnF5STJyRzhxRTh6KzFKcXd1?=
 =?utf-8?B?SExETVgyekxhY2llT1duNVJYdkpKR1pUcTdYek1wK2lsYXpadkV5RS9mZkJC?=
 =?utf-8?B?VDAzVUlFRjNld3Y1dm1jVTV4K1g1VkVEdzFmWUlxWTRVc0twekxPb29La1FW?=
 =?utf-8?B?dDE1QW5EdkdqcnAybHhEUDJWSDN5dkRLVDlZQ2lxZjBkR1hWZDBJUlFIWFUw?=
 =?utf-8?B?WXBGQXd1aFhUK0wwUlRvM2pQVU1XdjI3M1FadjNacVR0UnZiNTBTN2Q1NkNj?=
 =?utf-8?B?aFg1RUViRjZsSmdqbUliR1ZFN0ZJa1haUTFOYnBEVUlhZDZOeWpteUhSZUpV?=
 =?utf-8?B?OTFteTNYa2dhWUNuVkxiYm5sRVdwMXZtaUFqTEoxYXE1dXRMOWJRSGoycmZD?=
 =?utf-8?B?VUk4d2FQVEdDcEJUOUxLcFRMMWJpOG43UnZTbVBkUk9nSkxUSVBvM2Zud0tU?=
 =?utf-8?B?elpXbGNkT1BERkx0UE9MdzY5aE9RSEdRa05zVFZiRGp6clZ4SXdkR1M0cjY5?=
 =?utf-8?B?bjJMbkcvVzNjdGUxa09SWGlCQlZWTi9vRVp4NGpCMERBbmJySnlhemEvd0kr?=
 =?utf-8?B?SWgxdVUybVJGRUtZbXZBajJRdndYTTdxNnRYbzlzZE9QTEVoMXI4bElGNVFR?=
 =?utf-8?B?YW0xcVU2ck9ZYnA1ektCWjdmL1FtU09PTjYyeFRPSnFXVmZ3MVdvODZMT0o1?=
 =?utf-8?B?S1kzRDNtdXJYUzRNWXo5eFcwVGJOM1JuZ21XYWFQck1CakloYlFqcFN1REFo?=
 =?utf-8?B?K0xZR09BbkI4UWVpQzJkQWh3TmVRdmhYRnJUVHROblRRQ3R1bTFCSmFTNVVm?=
 =?utf-8?B?Z0pIdGtRMUEzSll2QS9BZ0FWQVkvTGFCRkUrOGJtYUpKTmxMbUNOdTdwdlNk?=
 =?utf-8?B?QysySnFEZ1ZSd0ZCUG1xSVMyeGJvTUJxMzFjdjhSTENyTUhFbjErcnpHNXQv?=
 =?utf-8?B?bnM4RXVwM1E4YzM0QzJ4SzdHN05MTkxEeDZJbzdMNncybE92Rm9xeDhrb2po?=
 =?utf-8?B?eW4ybElFL2VjV3ovSGNITmVMclQ2TnJTeTk1b1E1WE01N0JHNUdNY3k5bHRj?=
 =?utf-8?B?aEs0eklRMzBBRTlzbERYUjhOMGJwY1hzcXJNNXdacVdhaVl1UWdIQUx0Z3R3?=
 =?utf-8?B?WU9kZkp6MGNDZEdJbHFpdUZVUlFjeFIyVFF6ZHkxWWlWSWV2M21hcWRoQ09S?=
 =?utf-8?B?RTh6R2g2NjBlaHVpaUQxN3dDK1JiMVpNcVIyUTZwaHpFR2dmNkpSS3M2M1ZR?=
 =?utf-8?Q?JTE1lLPzNvVODAfHJwQ6/Ic=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E695619E27DC5847B96AB126EB4F6F42@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dsVizJoN73SCnYoof2x7YnUvOCTc8MDFAcb6h9xn/Tjev9Px894X18e7cws2iAqiW6fqAenD51bH1eOqShibKpUK/ta66LA5xTYPBHzyj4cS5BZc+4zOwCljkq4jzlHtljAHsp/0yNSYQo9DRqGwp2lHLBRmxes6XrEqU7I3CN2qwod+H+Xr8BAHdcQj16wUfzc114cDNy/I6pQTmgyGxCWMN1nzelXx4JgxWgY2zlFknd6svcnHFdyJCuLtJ+5ylMJGip9lxnh+IwNTif/R6QkZd1iFZBFeB0SZk+LU/Wsl6SWbhUrB78S8ENiZDiiislyUG8pF6S1BFavP2RbGLVByTzZk5hzQR2kjan6edh3PKosYhLs1L9hrUWQZ/RSCeGVrCHHLlBlDwLAcjMqSYjUkWNTV3SOCVnsCKsJzVUwfk21EXjvE0zje9oHxln9Fpc5CsCOp9T3YMqnzkaPrwBAejfP72vQbMHPdbgNLfgoIftw2WF/yvAIbrjdJ7SFxrmAH2Nyq9su+6frpBsCISQ2R11LUC3u2a6ohLkh3+oeB33/4hXZbxb23RtoF0WRsBy1CNDjVYrMeyHyhRKcCkUHncTMlytchtHfM3MR845dQ/ruhRPuOYbQ+E+sUYwNphApEkmGnghIsLD7O4zTqPg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bdca987-0e17-490a-6608-08de18681c29
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 10:27:36.1012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: txuwNnRHzQM/JKPkTDCfYh7aLDaVRdAdr5EKRIthiKbar37mqEZUuIYv2lYiwpUGNPtMHSDkGeRDIwSVO12PEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB4405
X-BESS-ID: 1761906458-102481-26155-29137-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 40.93.195.112
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsbGFsZAVgZQ0CLRKMnUwtjcNM
	3SzMwk1cLAKDkxOTXFwjI5OdEkNTFZqTYWAOgDkC9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268604 [from 
	cloudscan17-110.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTAvMzEvMjUgMDA6NTAsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4gT24gVGh1LCBPY3QgMzAs
IDIwMjUgYXQgMzoyNOKAr1BNIEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRuLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4NCj4+DQo+PiBPbiAxMC8zMC8yNSAxOTowNiwgUGF2ZWwgQmVndW5rb3Ygd3Jv
dGU6DQo+Pj4gT24gMTAvMjkvMjUgMTg6MzcsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4+Pj4gT24g
V2VkLCBPY3QgMjksIDIwMjUgYXQgNzowMeKAr0FNIFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVu
Y2VAZ21haWwuY29tPiB3cm90ZToNCj4+Pj4+DQo+Pj4+PiBPbiAxMC8yNy8yNSAyMjoyOCwgSm9h
bm5lIEtvb25nIHdyb3RlOg0KPj4+Pj4+IEFkZCBhbiBBUEkgZm9yIGZldGNoaW5nIHRoZSByZWdp
c3RlcmVkIGJ1ZmZlciBhc3NvY2lhdGVkIHdpdGggYQ0KPj4+Pj4+IGlvX3VyaW5nIGNtZC4gVGhp
cyBpcyB1c2VmdWwgZm9yIGNhbGxlcnMgd2hvIG5lZWQgYWNjZXNzIHRvIHRoZSBidWZmZXINCj4+
Pj4+PiBidXQgZG8gbm90IGhhdmUgcHJpb3Iga25vd2xlZGdlIG9mIHRoZSBidWZmZXIncyB1c2Vy
IGFkZHJlc3Mgb3IgbGVuZ3RoLg0KPj4+Pj4NCj4+Pj4+IEpvYW5uZSwgaXMgaXQgbmVlZGVkIGJl
Y2F1c2UgeW91IGRvbid0IHdhbnQgdG8gcGFzcyB7b2Zmc2V0LHNpemV9DQo+Pj4+PiB2aWEgZnVz
ZSB1YXBpPyBJdCdzIG9mdGVuIG1vcmUgY29udmVuaWVudCB0byBhbGxvY2F0ZSBhbmQgcmVnaXN0
ZXINCj4+Pj4+IG9uZSBsYXJnZSBidWZmZXIgYW5kIGxldCByZXF1ZXN0cyB0byB1c2Ugc3ViY2h1
bmtzLiBTaG91bGRuJ3QgYmUNCj4+Pj4+IGRpZmZlcmVudCBmb3IgcGVyZm9ybWFuY2UsIGJ1dCBl
LmcuIGlmIHlvdSB0cnkgdG8gb3ZlcmxheSBpdCBvbnRvDQo+Pj4+PiBodWdlIHBhZ2VzIGl0J2xs
IGJlIHNldmVyZWx5IG92ZXJhY2NvdW50ZWQuDQo+Pj4+Pg0KPj4+Pg0KPj4+PiBIaSBQYXZlbCwN
Cj4+Pj4NCj4+Pj4gWWVzLCBJIHdhcyB0aGlua2luZyB0aGlzIHdvdWxkIGJlIGEgc2ltcGxlciBp
bnRlcmZhY2UgdGhhbiB0aGUNCj4+Pj4gdXNlcnNwYWNlIGNhbGxlciBoYXZpbmcgdG8gcGFzcyBp
biB0aGUgdWFkZHIgYW5kIHNpemUgb24gZXZlcnkNCj4+Pj4gcmVxdWVzdC4gUmlnaHQgbm93IHRo
ZSB3YXkgaXQgaXMgc3RydWN0dXJlZCBpcyB0aGF0IHVzZXJzcGFjZQ0KPj4+PiBhbGxvY2F0ZXMg
YSBidWZmZXIgcGVyIHJlcXVlc3QsIHRoZW4gcmVnaXN0ZXJzIGFsbCB0aG9zZSBidWZmZXJzLiBP
bg0KPj4+PiB0aGUga2VybmVsIHNpZGUgd2hlbiBpdCBmZXRjaGVzIHRoZSBidWZmZXIsIGl0J2xs
IGFsd2F5cyBmZXRjaCB0aGUNCj4+Pj4gd2hvbGUgYnVmZmVyIChlZyBvZmZzZXQgaXMgMCBhbmQg
c2l6ZSBpcyB0aGUgZnVsbCBzaXplKS4NCj4+Pj4NCj4+Pj4gRG8geW91IHRoaW5rIGl0IGlzIGJl
dHRlciB0byBhbGxvY2F0ZSBvbmUgbGFyZ2UgYnVmZmVyIGFuZCBoYXZlIHRoZQ0KPj4+PiByZXF1
ZXN0cyB1c2Ugc3ViY2h1bmtzPw0KPj4+DQo+Pj4gSSB0aGluayBzbywgYnV0IHRoYXQncyBnZW5l
cmFsIGFkdmljZSwgSSBkb24ndCBrbm93IHRoZSBmdXNlDQo+Pj4gaW1wbGVtZW50YXRpb24gZGV0
YWlscywgYW5kIGl0J3Mgbm90IGEgc3Ryb25nIG9waW5pb24uIEl0J2xsIGJlIGdyZWF0DQo+Pj4g
aWYgeW91IHRha2UgYSBsb29rIGF0IHdoYXQgb3RoZXIgc2VydmVyIGltcGxlbWVudGF0aW9ucyBt
aWdodCB3YW50IGFuZA0KPj4+IGRvLCBhbmQgaWYgd2hldGhlciB0aGlzIGFwcHJvYWNoIGlzIGZs
ZXhpYmxlIGVub3VnaCwgYW5kIGhvdyBhbWVuZGFibGUNCj4+PiBpdCBpcyBpZiB5b3UgY2hhbmdl
IGl0IGxhdGVyIG9uLiBFLmcuIGhvdyBtYW55IHJlZ2lzdGVyZWQgYnVmZmVycyBpdA0KPj4+IG1p
Z2h0IG5lZWQ/IGlvX3VyaW5nIGNhcHMgaXQgYXQgc29tZSAxMDAwcy4gSG93IGxhcmdlIGJ1ZmZl
cnMgYXJlPw0KPj4+IEVhY2ggc2VwYXJhdGUgYnVmZmVyIGhhcyBtZW1vcnkgZm9vdHByaW50LiBB
bmQgYmVjYXVzZSBvZiB0aGUgc2FtZQ0KPj4+IGZvb3RwcmludCB0aGVyZSBtaWdodCBiZSBjYWNo
ZSBtaXNzZXMgYXMgd2VsbCBpZiB0aGVyZSBhcmUgdG9vIG1hbnkuDQo+Pj4gQ2FuIHlvdSBhbHdh
eXMgcHJlZGljdCB0aGUgbWF4IG51bWJlciBvZiBidWZmZXJzIHRvIGF2b2lkIHJlc2l6aW5nDQo+
Pj4gdGhlIHRhYmxlPyBEbyB5b3UgZXZlciB3YW50IHRvIHVzZSBodWdlIHBhZ2VzIHdoaWxlIGJl
aW5nDQo+Pj4gcmVzdHJpY3RlZCBieSBtbG9jayBsaW1pdHM/IEFuZCBzbyBvbi4NCj4+Pg0KPj4+
IEluIGVpdGhlciBjYXNlLCBJIGRvbid0IGhhdmUgYSBwcm9ibGVtIHdpdGggdGhpcyBwYXRjaCwg
anVzdA0KPj4+IGZvdW5kIGl0IGEgYml0IG9mZi4NCj4+DQo+PiBNYXliZSB3ZSBjb3VsZCBhZGRy
ZXNzIHRoYXQgbGF0ZXIgb24sIHNvIGZhciBJIGRvbid0IGxpa2UgdGhlIGlkZWENCj4+IG9mIGEg
c2luZ2xlIGJ1ZmZlciBzaXplIGZvciBhbGwgcmluZyBlbnRyaWVzLiBNYXliZSBpdCB3b3VsZCBt
YWtlDQo+PiBzZW5zZSB0byBpbnRyb2R1Y2UgYnVmZmVyIHBvb2xzIG9mIGRpZmZlcmVudCBzaXpl
cyBhbmQgbGV0IHJpbmcNCj4+IGVudHJpZXMgdXNlIGEgbmVlZGVkIGJ1ZmZlciBzaXplIGR5bmFt
aWNhbGx5Lg0KPj4NCj4+IFRoZSBwYXJ0IEknbSBzdGlsbCBub3QgdG9vIGhhcHB5IGFib3V0IGlz
IHRoZSBuZWVkIGZvciBmdXNlIHNlcnZlcg0KPj4gY2hhbmdlcyAtIG15IGFsdGVybmF0aXZlIHBh
dGNoIGRpZG4ndCBuZWVkIHRoYXQgYXQgYWxsLg0KPj4NCj4gDQo+IFdpdGggcGlubmluZyB0aHJv
dWdoIGlvLXVyaW5nIHJlZ2lzdGVyZWQgYnVmZmVycywgdGhpcyBsZXRzIHVzIGFsc28NCj4gYXV0
b21hdGljYWxseSB1c2UgcGlubmVkIHBhZ2VzIGZvciB3cml0aW5nIGl0IG91dCAoZWcgaWYgd2Un
cmUgd3JpdGluZw0KPiBpdCBvdXQgdG8gbG9jYWwgZGlzaywgd2UgY2FuIHBhc3MgdGhhdCBzcWUg
ZGlyZWN0bHkgdG8NCj4gaW9fdXJpbmdfcHJlcF9ydygpIGFuZCBzaW5jZSBpdCdzIG1hcmtlZCBh
cyBhIHJlZ2lzdGVyZWQgYnVmZmVyIGluIGlvDQo+IHVyaW5nLCBpdCdsbCBza2lwIHRoYXQgcGlu
bmluZy90cmFuc2xhdGlvbiBvdmVyaGVhZCkuDQoNCkFoIHRoYXQgaXMgZ29vZCB0byBrbm93LCBt
YXliZSB3b3J0aCB0byBiZSBtZW50aW9uZWQgdG8gdGhlIGNvbW1pdCBtZXNzYWdlLg0KDQpCdHcs
IEkgd2lsbCBzdGFydCB0byB3b3JrIG9uIGxpYmZ1c2UgYXJvdW5kIG5leHQgd2VlayB0byBhZGQg
YW5vdGhlciANCmlvLXVyaW5nIGludGVyZmFjZSwgc28gdGhhdCB0aGUgYXBwbGljYXRpb24gY2Fu
IG93biB0aGUgcmluZyBhbmQNCmxldCBsaWJmdXNlIHN1Ym1pdCBhbmQgZmV0Y2ggZnJvbSBpdC4g
SS5lLiB0aGF0IHdheSB0aGUgc2FtZSByaW5nIGNhbiBiZQ0KdXNlZCBmb3IgbGliZnVzZSBhbmQg
YXBwbGljYXRpb24gSU8uDQoNClRoYW5rcywNCkJlcm5kDQo=

