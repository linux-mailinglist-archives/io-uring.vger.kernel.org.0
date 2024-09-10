Return-Path: <io-uring+bounces-3116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD44D973AFB
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB0721C23CE1
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 15:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17465196D9A;
	Tue, 10 Sep 2024 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="q/qNkKoe"
X-Original-To: io-uring@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2064.outbound.protection.outlook.com [40.107.20.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E574D143C4C;
	Tue, 10 Sep 2024 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980894; cv=fail; b=oh07kTXeMOdDnKV7a+qfvBe54XosnPV/7yJBQqgAoJf2LagORoL4FANpKW+GBdUNjR57IQzjkW22i9ct64/O2nefUlzaOlBSBF5hFuTj5Qz9xUsaNPamRVo4HegBUqSoEV/Guhzj6jKOM36nbup8M5Mj6Xibk1PAVWKs7cthaC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980894; c=relaxed/simple;
	bh=AL58VOKZczphaudr14BELtv1TaM0k4HkfkC0iduLPEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OPR0xLk+8o5kof0K7gKMmbF70bmI1i2oYUD1zPQzT9fTIfIvxbAmOZmldp0tXNQMoTxxrA5UfZdy2xFzrSjZj+/Dq6BlJLus7xdH32WzjffkmXx0zzZgsDTHrs0HEjUj+2md4LWuai7Y6G/PuqGLcObbrsXrEJkykR2O6L5TuCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=q/qNkKoe; arc=fail smtp.client-ip=40.107.20.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rsoy2x7I/NCWenX9CmV1ZxeazHmcb2zLK32BvtJyAo31Qwwh5qS40kfCZjpU0knor+wUiezuFesRDC0B9I2tD4TgxsqNe71DozXLjzrFAJEfqITNWoccI7JYqBMwFRplC2MGSny1y4K3Uako2nWEPdSH8tg2wr+DpQPM11YrH4rmMoQeaK8FS4vYMVAPsuM/W5XURLfFwc5zfIFxWMKEadzz8H4JJmNeYmcPjm+G87tCuZFs6Q+stz0NxW6C8rW2/AndZulOdzP6QY/w/kND6qMS52B+G2Xjwjzs/l/SvSzR95YoQCt2TDdO7vLQsrmOQ5K0oyryJ0u8+FV0b2WlSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AL58VOKZczphaudr14BELtv1TaM0k4HkfkC0iduLPEw=;
 b=T4P5FAo546A2irQESEbLMWmWR8Je6xR/XOXAhUfRfWGJYOHVi6iEDEKAj7OjGdHrQ3SF1wRU4G4qJB8BPi6LKMfo1E7jx2BMj6ZoTqXatXzvwZAte/BGUbQztv2yz1kENHSGJNS7f6gx4jco9z6rI+zXxoLQ0E3z2MVw6nFRlSliSsUQV+0D0/Fd4mMaJaBU+b/6JTau2tLAcVIwgwXRTBhGFajcMfhsIkCbY3fubRwtJ8DoBGkTgK0b5h/Nw5yo3EjbtAqtyywA89gYUrV8vQZmjRNWJnrkGRhJARNE+zEvcS4nMlv1VI6NxaJnb6QE/Y5lat9VmnF0JN8AkZKo6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL58VOKZczphaudr14BELtv1TaM0k4HkfkC0iduLPEw=;
 b=q/qNkKoeHEgprtNQheyWEog2awDGMRelJJmvdzv0KV+Sv8McOh9POpPAb3KzGVcZRZ+P4bG8SBWjkTDCRZODBm+pRpzTdhhKDmDkjueuHpv+uLGiTJs4GwwHpbLWjL/06aktZHEbaHlKJQp3eAUDeZLUyaJbpuIgFeNQeK5+eUQGPpVjXrrPH87/f2dEv4V1RbZXMMhWl8LvznmtDvaDe9H+n0K5ht4FVTaZoj4sWQDaUta9ivdV8J7FZnq0Hs/Al3hlEg16Fy66ffN0YLnDb/IbEfd/lhSGnsveuq7i32VWXzkFpY0HPvaw7HdL+3xOWPBl6O9Yx5MC+h2ioaOH+Q==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by PAVPR10MB7331.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Tue, 10 Sep
 2024 15:08:07 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 15:08:07 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Bezdeka, Florian"
	<florian.bezdeka@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "longman@redhat.com" <longman@redhat.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "Schmidt, Adriaan"
	<adriaan.schmidt@siemens.com>, "dqminh@cloudflare.com"
	<dqminh@cloudflare.com>
Subject: Re: [PATCH 0/2] io_uring/io-wq: respect cgroup cpusets
Thread-Topic: [PATCH 0/2] io_uring/io-wq: respect cgroup cpusets
Thread-Index: AQHbA45p2jJwLZGl/U6eNmWxPlYEebJRGycAgAAENgA=
Date: Tue, 10 Sep 2024 15:08:07 +0000
Message-ID: <92d7b08e4b077530317a62bb49bc2888413b244a.camel@siemens.com>
References: <20240910143320.123234-1-felix.moessbauer@siemens.com>
	 <ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk>
In-Reply-To: <ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|PAVPR10MB7331:EE_
x-ms-office365-filtering-correlation-id: ced0a4a5-e4ec-4387-3133-08dcd1aa6066
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dnc4WUwxYm9zaHVEMURqdUJuNzRoM2ZTeUt2UnovalNHN0tiMVBFMmdQYVI3?=
 =?utf-8?B?K0VjZmNPYVZycGtVZ0ZtaDNYYXArOFlURzlYMnVCVFB6c1ZCWGwzYmZ4Z2NK?=
 =?utf-8?B?RHlWaUNMdlQybjFQTkIwRE4zZEhjUmhpVklBT01GOG5rK2loL3Z3bDNvL0RY?=
 =?utf-8?B?QUhLN2EwR0dKb2VRSGlGK2txNXA4SXVGS202VDFsY0ltbUJONC9TekpLcFdH?=
 =?utf-8?B?ZWdXYThydHdyTVU0RU1YR3FmTkx1T0FIQWdsVWpMdE1qOW9pbFl5TUdXVEUv?=
 =?utf-8?B?RGFKWUlNUE5Jc2tQTHpQOGZibWJ6TEw1QUtmcG02cTYxV2YvVEFmTzcxdk9o?=
 =?utf-8?B?VXdVT1pidU5lVzdhUW40a3RqVFhkRFNRWGxsdHVNVlMzVk0wTlc4aCtkMkk4?=
 =?utf-8?B?a0dRSFo4N1VXSnhleVJuZ2dIb2pwUEd6ZkQ4SzhoSTNnOGQ4Sk1QSlJ2MGht?=
 =?utf-8?B?cTZrS1l3UjVGSzZyUXJCcGloNUdHMzVJaVl3cDJUU2JHZzFqT0hDek9sUy9H?=
 =?utf-8?B?aXpyc1FoUmhtN1JOQm5YNFJHbTcwcG9Cb1lOMTN6UllOcE1xOTlFeEhjSlZS?=
 =?utf-8?B?UnlEN01aMmJpK1gxTzM0QzJGN09NaDFqTU42ZVFXWlFIdS8yVG5jcXpzNGhE?=
 =?utf-8?B?UUoxekhSMDRCT1IxaGZHYWdqeGc1QzZhakNGMzh6Qll1cEZnU1JHUlJsREJL?=
 =?utf-8?B?OVJPT3ZzN0o3YWoveTBJRXg4QjJuRHdIbmZEZEZqODlCUjFJSk1PREhFaWhG?=
 =?utf-8?B?SDF5bzhpRFVPODlsWUIrcjVmZk4zSGU1WUtiVzJIaklIc3BCMmVtT2R4VTRk?=
 =?utf-8?B?aHVaamRrdksxajBmOGpMMk1UTFFWNEY0TUtPcDFsSTBCeERDOVJuUXRtMWFv?=
 =?utf-8?B?SXNGTFpLWmVkUXpCWlgwRlp0Wm1KNUQ5eEVIVCs0d3Uwd1h0UTA0RVM2OVVh?=
 =?utf-8?B?cnpMSGJudnRGcWxZVTh5clRxQjlteXcrUXhZWXFlS1ZwazdqUm94TzlVQ3J1?=
 =?utf-8?B?N3M1ejZGcmJpbndQcmdQQlhjSDMza2M3SVRqTE15TjJ4ckpOMGhLVWYxeGNP?=
 =?utf-8?B?Ynl0V3N2U3hhTHp6UVVCc2NYL0RUSC95MTZKcHlyMXMyQjZhSmlFQzdMQkhY?=
 =?utf-8?B?N3pMOFlWMjZKTUVEdXVjbFlucDBqeElMcEdRV0p2SFROc29UVXllbjg2a2tu?=
 =?utf-8?B?NWJQL0M4VzhmNHdZOVo1QnFEdlVBYkZyV2d0RzNMTE1zT1BldW52bGIxZERr?=
 =?utf-8?B?RTF1a2dLakM3QTFtcU5aRFFnc2xwYmxiUWtRdUJZWFBlNzNmRkt4N21WUjdS?=
 =?utf-8?B?VHl5QUFGRHBoeGQwSThmN3ozM3N1TzJ1SmtrZUVMWlVFSkxpUUNGQzNTUmRm?=
 =?utf-8?B?dGd5RjRKd2xrS1J3cE53dytQTExCLytiS0h4UHZKTmNrcURlWEFMNGdhcVcv?=
 =?utf-8?B?OFVES0JmWkJ6OXduR1dXVnRmak03TEFCOG5PWUtUMDRJV2ZzMW9sMS91S2dk?=
 =?utf-8?B?LzJGcjRlZ3hZRUovNjcvTE93T21mLzB3WGJha21NVkZ4am1hS0FOU05qY1RC?=
 =?utf-8?B?eTFYalZNOWlmRDE1UEZ5QmZlTlFMV3NtUXdFR2tlU3RsSWc3OWVtaXI2M3JI?=
 =?utf-8?B?NVNhWVdsZ1crWWgybTh6WERpWjNsT3hscXhXZ0dJSGMvaDJCRkphTU5nVG1P?=
 =?utf-8?B?bCtUblliNXRQZUEzVG1rZ1phdGsrZ2dGRzZiZ0RxazNBTjh0K0gzd0ZFV3JB?=
 =?utf-8?B?TkpxTkY3Y3o4enEyZmpFRFg0Rnp4c3FSU09qc2VEcHU1VVo1WGJLU2Y4NCtp?=
 =?utf-8?Q?qn1Yo734js+iDBzrj14k60FMwRVyrMnsioUQA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NmVNK3Y0QlpTc2QzTFlNaGNub1pyQ25jZWNZa2JTMGljeWJOdGRESlVIZ0Q5?=
 =?utf-8?B?SlN4SEh3UEJ3bmdVNVl5L09xakU0ZkNIaDN4ajFncG5sNG5ENVVNMjc1M1B5?=
 =?utf-8?B?UTdsVjN1UHdmWGt5ajRKcVcxYmVIaHluRERaY1R1RXlyTlRWby9NcUJhV0M5?=
 =?utf-8?B?MG9ZSkkvZlVUN3ZuVUtxczZnUVBlZFlHS0M3a1p3VE9neGI4RzJFd21pa0Q3?=
 =?utf-8?B?Mm5obXJJR0NKcHZNeFNjNjFkeisweEx4RW5MeWwxU256L01kby81L1JCbWhT?=
 =?utf-8?B?V0thM3V1QXREZXY1N3EyVzAwZzVRUzY3RE1heE9ZQ1ZpS0JxcndZV3lDbUcy?=
 =?utf-8?B?YU0zWWZLcHhENEY2d25uaHoyVFE3NCtOS3VBY1lTUlk4bEc5NWowaGNlZ0hK?=
 =?utf-8?B?dVhSSGlVRXVJZ0dtTXR1ZzNnK1dvUFd2ZFlVN1crdEp0Vm4zOGtoZEVXaXYy?=
 =?utf-8?B?QTVHNEFncmU2RmdFam5NTVFDUjRNMXRkVUs3cE13dDUvNGExcXN1RlZKNnpv?=
 =?utf-8?B?TDZIV1BFV3ppcXVNNFNtcGdrbmdzai9CN29vWXNpeEUyRW1VaGpMbHZkVVI0?=
 =?utf-8?B?T1BBT003RW5td1RwZ1U0cE9FazljMVhaRFlydHp1UnVOVkJXVDBqVWUyZTlW?=
 =?utf-8?B?UjlFaWh6S0hCdWFQbkloYTZPeFpsYmEyK0IwSkU3MCtMRnQreGlyNUs1OXJr?=
 =?utf-8?B?dzhtMjFBaVk2ei9zQzVjQnIwUTFoczhlOThkZnJMemtoVHY2VC9hMXNuZ2VU?=
 =?utf-8?B?aHNkaVVNR3hid2xwSXFjWUJEUWtkd2lrZy9OWXp3UUhpR3hOc2hQeHlqaTkr?=
 =?utf-8?B?eUtLUVF3MFpqNUc2d0RSb1AyQkFiajhtcGZlK1BxOFUwTkdwV1l5SEUzRlRm?=
 =?utf-8?B?SDJEVy96Rzh2UWRUNEN3cytrQmgyUWMrS0RIellqNmp2dCtRWEdieElNQ2J4?=
 =?utf-8?B?WGFiWWtMMFN4UCsweTAyQzNUR1pNVlRSUkd6VFdsbjF0ZVZERTZnQXZpNWNr?=
 =?utf-8?B?UEdPUjI3TmdsT1FMTWVkaHd6ZHdlcnVNR3ZRRFMybnM4TlJVVUJiZWp6MEJ6?=
 =?utf-8?B?Mms0SzFSaDJmam9md1BvMHJGWGNnSmJkN0gwTXlMYXQ2aS9lYTRlb0Z4QTdr?=
 =?utf-8?B?Yk9yWHN2c1FabnRJTmhYQ3luNHJ0NTlaenJnclFJTVV1em4wb1dIeHhOcHd2?=
 =?utf-8?B?S1V2V3dVdFJuQUoxbG9GT3dLcjIxLzduaXh4YkxoZzlUdFlOVXpQN2ZQa1BQ?=
 =?utf-8?B?eEhoQzR1alNvQlVldXVOeEdBUXQvdU41WW4xeWgzam8vZklzUUVkMmhNZTBG?=
 =?utf-8?B?MWlqT2hCUkVnM0lsT2JPY0VjWXRvNnZ4Ylppc2FuM0xFUmhFL3dyWFFqbEx5?=
 =?utf-8?B?MHBGT0dVenVoZWlSUnlOYjZrWGcwZjhrT3BVKzR5cmFlYnd3Y1Bhc2tnNWJr?=
 =?utf-8?B?YURvbUF0T0JzYVlhdS9UY1h6aWdMRmVvVG0wZVp1VlhVd0dHd1o5YXdZc0Nn?=
 =?utf-8?B?eXBPWkZzMzUrVWlSUlJOTStyYlQvR2dIZkMvVnVXRU81UGZTcER4dDRFWHBy?=
 =?utf-8?B?Uk1EMGtUK0dUcGdGV2tmQ0FnOUNMUjFRM2thejBZelhHQjBXeTdISS9qZkJE?=
 =?utf-8?B?a0Joc0ZNT01ZZE9PT1BwVFVVZEFqK3F5QnI1ZEx5SFo1R0xWR0pzazBYczR4?=
 =?utf-8?B?dzJPWDF0QW5FUGF2cG5rcXdBYkpyNjFrb3dKdmNxZSt6eTNuOVowVWJVRXN4?=
 =?utf-8?B?b3lvOEx4Ti94OVpRUDVGTGR3U3RPZzJrNmxxbXhvOXpoMkdBck15NktPTUR2?=
 =?utf-8?B?QVhLRkhsWkdZQS9XK3ZGcUNvY2xuZmplRHE4OEE0Mm9GaUlPbUZkM1UxL3pT?=
 =?utf-8?B?eWFYTXZvSnRzZFhMTVhiTlovQUMxWlBHVWYxZzBSa05TWGlwbTI3RVNzVzJ6?=
 =?utf-8?B?Nmw0dXRyaU50Rlg2RmVqZHE0WllnYXNBdWNkUHcwbEl6UDF5a285ek8vZjZC?=
 =?utf-8?B?Y09mWm5mOTN0dTlyYUFiMWN3bzhUeDI1TG00NnU5REFYWlpmbENtLzZzbysx?=
 =?utf-8?B?VHhPWFRWd0w5NTIwbVdia3pFejhweGptY04zQlU0ZnRtOC8yNHJOTG1zNnpS?=
 =?utf-8?B?YzRXd1FlU0pmY1VXNE1md3JOTDM2QjBxSFI0REZzSC91bFMycTR6bEFqbCtm?=
 =?utf-8?B?RU03bXBJN1A1cUk1SEpFV3pxZ0xmU2Z0dlRTT0tsVjZnZ3hZejl2YUVqT1F4?=
 =?utf-8?Q?lk5NsLME3kzlKUHTnJ/SWguhRtpfhAhN98crV65Q+o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF71610E4A57F94D8C7E2E77EC4E2256@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ced0a4a5-e4ec-4387-3133-08dcd1aa6066
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 15:08:07.1110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nkpjlkL4HDEuOnFf8ZUoYgNiAWqGFEAgqINVdnuvQkDndvNCPFWBkUibCc3OPWnAw9i1KHlntn/FTVh9ZrXXyx3bewyqbT1oKvC7Y59kR9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR10MB7331

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDA4OjUzIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA5LzEwLzI0IDg6MzMgQU0sIEZlbGl4IE1vZXNzYmF1ZXIgd3JvdGU6DQo+ID4gSGksDQo+ID4g
DQo+ID4gdGhpcyBzZXJpZXMgY29udGludWVzIHRoZSBhZmZpbml0eSBjbGVhbnVwIHdvcmsgc3Rh
cnRlZCBpbg0KPiA+IGlvX3VyaW5nL3NxcG9sbC4gSXQgaGFzIGJlZW4gdGVzdGVkIGFnYWluc3Qg
dGhlIGxpYnVyaW5nIHRlc3RzdWl0ZQ0KPiA+IChtYWtlIHJ1bnRlc3RzKSwgd2hlcmVieSB0aGUg
cmVhZC1tc2hvdCB0ZXN0IGFsd2F5cyBmYWlsczoNCj4gPiANCj4gPiDCoCBSdW5uaW5nIHRlc3Qg
cmVhZC1tc2hvdC50DQo+ID4gwqAgQnVmZmVyIHJpbmcgcmVnaXN0ZXIgZmFpbGVkIC0yMg0KPiA+
IMKgIHRlc3RfaW5jIDAgMA0KPiA+IGZhaWxlZMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgDQo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIA0KPiA+IMKg
IFRlc3QgcmVhZC1tc2hvdC50IGZhaWxlZCB3aXRoIHJldCAxwqDCoMKgwqAgDQo+ID4gDQo+ID4g
SG93ZXZlciwgdGhpcyB0ZXN0IGFsc28gZmFpbHMgb24gYSBub24tcGF0Y2hlZCBsaW51eC1uZXh0
IEAgDQo+ID4gYmM4M2I0ZDFmMDg2Lg0KPiANCj4gVGhhdCBzb3VuZHMgdmVyeSBvZGQuLi4gV2hh
dCBsaWJ1cmluZyBhcmUgeW91IHVzaW5nPyBPbiBvbGQga2VybmVscw0KPiB3aGVyZSBwcm92aWRl
ZCBidWZmZXIgcmluZ3MgYXJlbid0IGF2YWlsYWJsZSB0aGUgdGVzdCBzaG91bGQganVzdA0KPiBz
a2lwLA0KPiBuZXcgb25lcyBpdCBzaG91bGQgcGFzcy4gT25seSB0aGluZyBJIGNhbiB0aGluayBv
ZiBpcyB0aGF0IHlvdXINCj4gbGlidXJpbmcNCj4gcmVwbyBpc24ndCBjdXJyZW50Pw0KDQpIbW0u
Li4gSSB0ZXN0ZWQgYWdhaW5zdA0KaHR0cHM6Ly9naXRodWIuY29tL2F4Ym9lL2xpYnVyaW5nL2Nv
bW1pdC83NGZlZmExYjUxZWUzNWEyMDE0Y2E2ZTc2NjdkN2MxMGU5YzViMDZmDQoNCkknbGwgcmVk
byB0aGUgdGVzdCBhZ2FpbnN0IHRoZSB1bnBhdGNoZWQga2VybmVsIHRvIGJlIDEwMCUgc3VyZSB0
aGF0IGl0DQppcyBub3QgcmVsYXRlZCB0byBteSBwYXRjaGVzLiBUaGUgLTIyIGlzIGxpa2VseSBh
biAtRUlOVkFMLg0KDQo+IA0KPiA+IFRoZSB0ZXN0IHdxLWFmZi50IHN1Y2NlZWRzIGlmIGF0IGxl
YXN0IGNwdSAwLDEgYXJlIGluIHRoZSBzZXQgYW5kDQo+ID4gZmFpbHMgb3RoZXJ3aXNlLiBUaGlz
IGlzIGV4cGVjdGVkLCBhcyB0aGUgdGVzdCB3YW50cyB0byBwaW4gb24NCj4gPiB0aGVzZQ0KPiA+
IGNwdXMuIEknbGwgc2VuZCBhIHBhdGNoIGZvciBsaWJ1cmluZyB0byBza2lwIHRoYXQgdGVzdCBp
biBjYXNlIHRoaXMNCj4gPiBwcmUtY29uZGl0aW9uIGlzIG5vdCBtZXQuDQo+ID4gDQo+ID4gUmVn
YXJkaW5nIGJhY2twb3J0aW5nOiBJIHdvdWxkIGxpa2UgdG8gYmFja3BvcnQgdGhlc2UgcGF0Y2hl
cyB0bw0KPiA+IDYuMSBhcw0KPiA+IHdlbGwsIGFzIHRoZXkgYWZmZWN0IG91ciByZWFsdGltZSBh
cHBsaWNhdGlvbnMuIEhvd2V2ZXIsIGluLWJldHdlZW4NCj4gPiA2LjENCj4gPiBhbmQgbmV4dCB0
aGVyZSBpcyBhIG1ham9yIGNoYW5nZSBkYTY0ZDZkYjNiZDMgKCJpb191cmluZzogT25lIHdxZQ0K
PiA+IHBlcg0KPiA+IHdxIiksIHdoaWNoIG1ha2VzIHRoZSBiYWNrcG9ydCB0cmlja3kuIFdoaWxl
IEkgZG9uJ3QgdGhpbmsgd2Ugd2FudA0KPiA+IHRvDQo+ID4gYmFja3BvcnQgdGhpcyBjaGFuZ2Us
IHdvdWxkIGEgZGVkaWNhdGVkIGJhY2twb3J0IG9mIHRoZSB0d28gcGlubmluZw0KPiA+IHBhdGNo
ZXMgZm9yIHRoZSBvbGQgbXVsdGktcXVldWUgaW1wbGVtZW50YXRpb24gaGF2ZSBhIGNoYW5jZSB0
byBiZQ0KPiA+IGFjY2VwdGVkPw0KPiANCj4gTGV0J3Mgbm90IGJhY2twb3J0IHRoYXQgcGF0Y2gs
IGp1c3QgYmVjYXVzZSBpdCdzIHByZXR0eSBpbnZhc2l2ZS4NCj4gSXQncw0KPiBmaW5lIHRvIGhh
dmUgYSBzZXBhcmF0ZSBiYWNrcG9ydCBwYXRjaCBvZiB0aGVtIGZvciAtc3RhYmxlLCBpbiB0aGlz
DQo+IGNhc2UNCj4gd2UnbGwgaGF2ZSBvbmUgdmVyc2lvbiBmb3Igc3RhYmxlIGtlcm5lbHMgbmV3
IGVub3VnaCB0byBoYXZlIHRoYXQNCj4gY2hhbmdlLCBhbmQgb25lIGZvciBvbGRlciB2ZXJzaW9u
cy4gVGhhbmtmdWxseSBub3QgdGhhdCBtYW55IHRvIGNhcmUNCj4gYWJvdXQuDQoNCk9rLCB0aGF0
IGlzIGZpbmUgZm9yIG1lLiBUaGVuIGxldCdzIGZpcnN0IGdldCB0aGluZ3MgcmlnaHQgaW4gdGhp
cw0Kc2VyaWVzIGFuZCB0aGVuIEknbGwgc2VuZCB0aGUgYmFja3BvcnQuDQoNCkJlc3QgcmVnYXJk
cywNCkZlbGl4DQoNCj4gDQoNCi0tIA0KU2llbWVucyBBRywgVGVjaG5vbG9neQ0KTGludXggRXhw
ZXJ0IENlbnRlcg0KDQoNCg==

