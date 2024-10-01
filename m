Return-Path: <io-uring+bounces-3342-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E9E98B596
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 09:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E20C2818D2
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 07:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781E41BC072;
	Tue,  1 Oct 2024 07:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="tWFmyoIW"
X-Original-To: io-uring@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2048.outbound.protection.outlook.com [40.107.105.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A630B67D;
	Tue,  1 Oct 2024 07:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727767968; cv=fail; b=jOqCMryYdZiNYM5xG8L+5yACr6F+e/IoIoH0I3mRjDWxSQH64Sz1pogEKiHWvdaM73rx08gDKoSBbystzCf4z4aQaqVDhMo/yu8DntNo+JX7Q6V7ssXcNc1PM6afrQ171qVfWLOijqnxCYSKCAYujSNUMuePRm31wvZUqcJS1Og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727767968; c=relaxed/simple;
	bh=v8ZSH7rKB6Ag2JtQTpATsrOofrr4ODenfIT5mviaTGo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QXgva/Ss3WQGh9a/7ENR6+xRch4RKxrVqvPlqK1KEcD9afXABCOOEi8BRVZ4qalpCZLYtLLfsbhcSSlGFF13fP6+0RYbNmnxqZfqP+j6nNiaWf6nFHYugGsR65UOcn6MCpfrxPxWauvaCoWVwpNTxhXrlaFLBaxl5ojXwR+buQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=tWFmyoIW; arc=fail smtp.client-ip=40.107.105.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dawQzMNttRrpsq9iJ7rvVJA2Ado5uyaIF5DmFaBdhVbuTLWRWAT7UrQ6CFSNzn+0Fh9ngzT/0KjTyfWA1ifH2LqAPYIrssdtuSOnqqg6iEgJoRxn0JurH05fU42mwKN0IO9a27SxN8I4FWmKI10Qypi2nI/apt6cXXCCVVjFp0FoIApUgBlux2Ixze5PakgiEQdNMWyJ4Q/544wJOoP85JkZ1GnO7SeoawUpzgYMhPjYtGiGER4+nUUyhtSXhKgMyM3SVlN7R4q9rZie25l5n8yXkuuE6iEBpnTTTpKLb04yKKqfXQ8mPGIXL6ddjjJ+XKuiP89MXzk8vmiNWWaHxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8ZSH7rKB6Ag2JtQTpATsrOofrr4ODenfIT5mviaTGo=;
 b=EksnfSYxQNuR3zG/bLOUscgNQ2X8EvwzjN+5T7BCsP/Zjf62aK4i305vLdoOKviuWgpswBXWRinqhExtxrwbVuKYSui79wrKSIdyZOL9qgKUO+5zd/JFsX8vJyQYEZytq3od1c2fyS6kKSEeldQpz+eo4dDjtwoiTPHP5Pm/z8L1YP30SRg9NX4sICu6q8v+aNeJTPg+9h+tLgQjtkT9mgyNhFmdCcL3lDVXO/AHlkZWE4tJa6opXPZJ7Db6WlLriU0ArIsiN9RXIn1MyVX2PVOqrWt1t3HLVejSxev9Lwh1xwsbDLbafe3RkKCyaRuL8ukBldRZtxnU/nWL3HAeIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8ZSH7rKB6Ag2JtQTpATsrOofrr4ODenfIT5mviaTGo=;
 b=tWFmyoIWi4No2vJOC92YoPdqUjR2Yj4VTfziMqidhixbO+A2bpuYWSPY0EgmyPtS7m0eK+ry7XDSzaNiZfCmFOPdcUdB1ba9NA+m8dl2pj70twas0h23i2EYPeytYqKH6xhvTeT/HylsGaqRJlFe/fDT33ODgIK6UF25uZc+2HAVO9H2EioU7B8aB/RqDv6utXqqjjdUQB11VhGts+RFxjgAOTnBXEOtI2Tuy4cf12ZJHYsylq5iUe5BQCwy1iBP77jX6xauC/ijRbDaa1fMZ35h1eKGsSnrqJMx/O0ii294YKOlOuHQeMafnQyypHtd5+OJRfyKwYGOHIjiN+MP3w==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by AM7PR10MB3841.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:17e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 07:32:42 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 07:32:42 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Bezdeka, Florian"
	<florian.bezdeka@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"longman@redhat.com" <longman@redhat.com>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"dqminh@cloudflare.com" <dqminh@cloudflare.com>
Subject: Re: [PATCH 6.1 0/2] io_uring/io-wq: respect cgroup cpusets
Thread-Topic: [PATCH 6.1 0/2] io_uring/io-wq: respect cgroup cpusets
Thread-Index: AQHbBGbv8dtAmho7pk23U34DSRheYLJw0WSAgADN/gA=
Date: Tue, 1 Oct 2024 07:32:42 +0000
Message-ID: <db8843979322b9a031b5d9523b6b07dca9c13546.camel@siemens.com>
References: <20240911162316.516725-1-felix.moessbauer@siemens.com>
	 <2024093053-gradient-errant-4f54@gregkh>
In-Reply-To: <2024093053-gradient-errant-4f54@gregkh>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2+intune 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|AM7PR10MB3841:EE_
x-ms-office365-filtering-correlation-id: 5ea4fea2-2475-4658-15e1-08dce1eb3c40
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YkUraVZkZ1JZSGlJaWNpb3AzSHRieERndjI1dGRzQ2pNbGFKV0dZNDl4c0l4?=
 =?utf-8?B?S3oyMzFtcG9pV09QTDBHamxIZjBoYnV6UjdKWDVTTTh2RDNsNHBnWHpqTlI5?=
 =?utf-8?B?NGZrZWhhNHU4REwvVDZJM2drNXh3dllrWGM5WlU1dUREQmpIM3JJb01TOUpO?=
 =?utf-8?B?SzJkRkZlQUlKV01naDA1T0ZDSE1uM21aNW9SNmpRenp4aUtjSSs2eDZwWHI1?=
 =?utf-8?B?RlhWUmxIWG5FcFg4S3laQTQraDNzYkgvWHVUbldwbXZ1d2k3YTU0QWV2cDdr?=
 =?utf-8?B?aHhEQzEvWXUrYTNZYlBjQlU2bWpGdkVVWHoxZWdPd2x3Q0FmMEw4bnlmQng1?=
 =?utf-8?B?VUVnSzlqUWNTZUdheCtsRXRVUEJSenJ0ZnJWWVkrSFFYczQ4WVkxZVZjazlY?=
 =?utf-8?B?VHNXcDJrczJQNlFaNG9HYjF5U3NYc3g1WWxJM214OXgxRzFKODJjZmxyaU56?=
 =?utf-8?B?RytkTHBDOXE2QkFaK3VjOE4yRkNVZ3lBVkIwOTlDSjRjMUZhRSs5ODRXbk03?=
 =?utf-8?B?b3RrZWFmSUJWMUxLOGxyOTVSQUc1dFJXM0trUWxNdUtBSG9ocHBQWUowMWlN?=
 =?utf-8?B?TVlSd3BZMm15K3lHR3RzN0puMjRlY3d4T2VKbzBvU0RabGtSWHJtenhTVnpO?=
 =?utf-8?B?NnBwcTBjUXllQ0dJVkJLdVpucHFOOHlXRWI4VGIzdUdtQVJCbnY2WEFNWTlH?=
 =?utf-8?B?STZHZ3NmWWhweWpsY1Y1MHFidmVEc3dGYzZueDhZTjhhRFZzaWdjL2VndFhi?=
 =?utf-8?B?NWdSUmkwMkNVL0dWekttalFqaDZRc0Q4TE1WbzB4d2pRVDdVQlJvRkd1Y0U5?=
 =?utf-8?B?Smh1Y1RZdm1oYUxmNzZSWjk1Y2IzV3pjQnN2c3dZTkpQWHVCUHVxNDJCWnNw?=
 =?utf-8?B?N1YrY2RVZUYzMW9kTnQ0b3dMMU5OOVpkbEQ3eEUwTDFmNi9nN0s5MWFWOStQ?=
 =?utf-8?B?QUxFQmRqdHZLNmVBWnJVMU42dUVNdW52cTJRMi9jei94VlZXMWo1eERrMisx?=
 =?utf-8?B?dzB3V0FYZm5YZHkwdi94ZUVqWk01WGtWandiQXZzajd2M1ArMVIvNU85OHVy?=
 =?utf-8?B?QXVXSUdnRWZpT2FWWERmRWJIazdhcUlNVFQwVFUvQTlOdkhoSjAwNkRuMlB6?=
 =?utf-8?B?bXBIZVgzVVJLOU9nRUlTRTNkUk00VmxOSEhMUFVPT0syMnpyUzBncHhPM3pz?=
 =?utf-8?B?V1NmOFpranNuOGI3ME0yRGgxbkpKOTR3Q0pBUmtJZGZzbFdsM3J5bmpmcytn?=
 =?utf-8?B?TU1BVmFwbkptUTYzdVBrMXV6RTRoSXF2bTZDZnUxWEgwYWVpYTZuMmt3ZHFN?=
 =?utf-8?B?bXUwdnNJT09idXN3bE9XcGZPTGl2dUhzMER1WGhPYkxYTnBrblZFQWdWRkpz?=
 =?utf-8?B?U1hMLyswZC9JRGszdGpvYVZSMjYvOWhyMDJkVGRSTi9HWStuaE5NdFBmY0RP?=
 =?utf-8?B?OFJTdGtOTE90K3h4T0xPUUNLTHpyT0RXUHBjRlp1bCtpaU1NT1FwMHhYaFRo?=
 =?utf-8?B?Qjh2eFBvTjFoQ1AwU3c5M0RobFdFeXNqM3RpWlp2Z2ZvOU5qZGFmVXFRN3hE?=
 =?utf-8?B?bGorNStaUG55RmRGK2JKNnRKZzNtUHpqLzVhV1FrTWpZdGNXS2hGeUYvb21B?=
 =?utf-8?B?N1BsVkdvMUN1UkVGUkk4dGVYMnFkZE4wUnhWcm40eDBSRmYrOGYwVUhJQzhC?=
 =?utf-8?B?YkMyOXZ4QWZOSS9JNTN4SU9PY3lZc1llUURMSi9Lc2VSbjlsS3E2TmNmUUlx?=
 =?utf-8?B?TnpJSTdRRUE4YUpTQUs1WGc4bFBhOUhHamY3MUNoYUhBZkgyV3FGalN2NDhi?=
 =?utf-8?B?ZzM3NmhCaUljdy9rMUo5em9PaFM5R1I4TXRnQlBUVDM4UTQvd3hnUE01YzMw?=
 =?utf-8?B?ejRHWVRXRlJYN2tuRDNSaWJYOHdBTEFkck5Bc3YyZUxXNUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QmEydkw2RGdkVUlJV2dRcnFUQ3MvSkNkQ2tQSStSbHZ0akE5UTZHN1VMTWVD?=
 =?utf-8?B?K1FtMDAxckRYSEU2SFRweTUvVFBPdGJPekQ0WUNkNVEySlYwanZGZjBoSEEv?=
 =?utf-8?B?T3FDbHE5OUtkSVl1STBKZ2gzMC9WaXF1NEJLb2x6eTRoR3ZSajgwdXc4dGJ2?=
 =?utf-8?B?ZkxTSFhEWWxVemhzK3dUVDNyNU5jMzhoSTlHZk9FdU5WN3JMYldPWTZneXNU?=
 =?utf-8?B?NVdLTWdncFF5aHBvYnJ5Y2VhZTdCY2VlVHF6VlFGT3V4eXJxWE9GSUFPWGU5?=
 =?utf-8?B?bEhGbEUwd0ZRWFJHQWlqTy9vVFBidjVseEJJWUtkZVB0dnhERnhIdVdBMTFQ?=
 =?utf-8?B?S1JrRWJ4Z0RBallENG1STVA3NVBmM05rK05rV2o4Q0o3dEVoR1BFNFhPL1pj?=
 =?utf-8?B?K1pDK3NjUStpaFJ5MFVBWWFVR3pRRDNvYjRWdm1RUXpYQndTKzV6a3VWbm5Q?=
 =?utf-8?B?S0U5amdaTlNRdjdlRVVZMllBR01zZFI3Y25sRlBMcUV5RysxTEM2Z05HQnpH?=
 =?utf-8?B?eC8xcFowY1RyVFNGcVlPYm9CSGUybkl6MFNNbStvZ1YyWFlnWnI4d3poSTZC?=
 =?utf-8?B?Y0JZcUR2WnppVm1uaDMwTzN1alJ6MVJXRXNWN1UwMmYwQWVXbnVwMXZlUjB4?=
 =?utf-8?B?Tnh2bnZXcDNlWXNXWW5sT1JBdm94QmN0ckhEUFd4Szh0RXVLZFBsK25HV0xZ?=
 =?utf-8?B?TWM1WThOdC9BaHhwcjdXaURYWVFSWkdVZzRjckkvc0hzRGg5d3RkdXhPWG51?=
 =?utf-8?B?ZWRUU3BBbTBoTFI3YkV2aVNmeDAyM3B0cysvYjU4U1BuajFvYTE5Q2FpTG1N?=
 =?utf-8?B?K1htcDhVeVgvYVRtWjlDNVJJcFZXOWttdzdCaCtUT3RzekpsKzAyQk9xN2lH?=
 =?utf-8?B?dEVsb3NOa3lJdExUb1Bob29tcG9lZnQxOWVSc3krcExXMS9LWkc2UVZHS3A4?=
 =?utf-8?B?NTk5U2UvL1RxZENvSDREc2JwSTk5Z3YyTVpJNzFHbnlkS3pRRHhxMGFyS3Fo?=
 =?utf-8?B?Y1NXRUwzYjlYNmJwT01zcFMybkFOd3pLTGRwRVVmTEpiNDc1UVI2RXBXNDNC?=
 =?utf-8?B?Wm5yOVEzQ3gvQmx6RlBOS0RpM1Z1cTJmSEo4THVhUHBpN3VqemtFT2x6WGVH?=
 =?utf-8?B?Z3ozallOUlU4ZVdoYWhQV0RPMmZNdllwbWR6eFRoTE9NY3QxYk9wZlBqbGVy?=
 =?utf-8?B?eVVSc1FUNGphS1J3Zk5GNS9qc0w4U2RnenNPU0dtck9FUmlRMVh4clozTDZT?=
 =?utf-8?B?VFlsQjBiR2I3S1NZbXhLdDVHMEJmd2pOWTk3NUluaXRoSXEwZUxtRnNEMGdk?=
 =?utf-8?B?LzFRRzZTekMxdHBvQVRSR2MzTUR5dUNPU01Vb3lkdGNEYTFwL0JXcVZhdDNl?=
 =?utf-8?B?K2hXbnJGZ3FPOFpwMWZQWEp1a0tGeHp6THZ4OEZTcmZOWTNtMkVlY1hjTHVl?=
 =?utf-8?B?ZUZacE82bHV1WXpMbUxwSGpLaUlaQU9kd3JYMzExV3RXeEpuc3hMeERzZkxx?=
 =?utf-8?B?cmZLYVVUTUVLdE44bGtoRHZPVXB3ZzlXbTNHNXdOT3NYMnFMV1orcVJWZE5X?=
 =?utf-8?B?ZXhBb2dQOEUwUUtSZXR1TXFqZjRsKzV1bWlhdm1CVmVSMGhCRCtVS2psVFh3?=
 =?utf-8?B?L0Jya1RzYmdIbDJGV3RFMkZEYWJpNHN3dVpEOGVMYVdEY0VhM0F1WlVxaWZ6?=
 =?utf-8?B?RGE4Y3BGbTdNbTZYdEVnaHU5aXRIb043V3dwaW9RVExkRUJPUGQ3VGIyR0t1?=
 =?utf-8?B?YWtISnRQcm5zZkUxZUJHRkhzL0lyTFM0ODhhUS9iUS9yOWdWVjM4eWFiTnp2?=
 =?utf-8?B?MGEzeGNWQmxJdnNodC9SS0k0VE9yUU56UVhYWFEyWnBZRTJuNnBoT3FRSkEx?=
 =?utf-8?B?Z0lkWEtWeFBFQTJ6ZmxMbTUwV0pRSnBQb0IzWlhnSUhVenJJS05qcjRMbzBz?=
 =?utf-8?B?NU12UDdUSkxjNHo2Q3lsdUFwZWR3MldKWGlJeHg2eGJxSDU0Tnd6Z01Fa0x4?=
 =?utf-8?B?U2lRQ2VvazRPRURvckVVZlFuKzVtYWlpSzVZUjVwanZ6TFMzaDdBRnpvYlZO?=
 =?utf-8?B?TUVCT2htZ2lVK3lyNnJaTzdqY1R1UlFFSW9Sbm1KZVJzM0lla3hNVzZINHFa?=
 =?utf-8?B?T3I4cStnaGIvL1dFSURhUmpOeUdUOVpVYkVqS1d4VnBVMkRMdWRUcWZETXMw?=
 =?utf-8?Q?6N86ULuqvFwNZNXsOiXqA/0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69CCFA5F5C79D34189BF87AF691AF10D@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea4fea2-2475-4658-15e1-08dce1eb3c40
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 07:32:42.3789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFKTHDLKbzwRqvnxTYKyQgdhSvjKyIOImo49W4IKzG0i3OlWqP4E9FLCGiYqItgyG3nKm/TKYgAuPdTtquMFIaD6GyxvbN6K2sANEwcUGNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3841

T24gTW9uLCAyMDI0LTA5LTMwIGF0IDIxOjE1ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBX
ZWQsIFNlcCAxMSwgMjAyNCBhdCAwNjoyMzoxNFBNICswMjAwLCBGZWxpeCBNb2Vzc2JhdWVyIHdy
b3RlOg0KPiA+IEhpLA0KPiA+IA0KPiA+IGFzIGRpc2N1c3NlZCBpbiBbMV0sIHRoaXMgaXMgYSBt
YW51YWwgYmFja3BvcnQgb2YgdGhlIHJlbWFpbmluZyB0d28NCj4gPiBwYXRjaGVzIHRvIGxldCB0
aGUgaW8gd29ya2VyIHRocmVhZHMgcmVzcGVjdCB0aGUgYWZmaW5pdGVzIGRlZmluZWQNCj4gPiBi
eQ0KPiA+IHRoZSBjZ3JvdXAgb2YgdGhlIHByb2Nlc3MuDQo+ID4gDQo+ID4gSW4gNi4xIG9uZSB3
b3JrZXIgaXMgY3JlYXRlZCBwZXIgTlVNQSBub2RlLCB3aGlsZSBpbiBkYTY0ZDZkYjNiZDMNCj4g
PiAoImlvX3VyaW5nOiBPbmUgd3FlIHBlciB3cSIpIHRoaXMgaXMgY2hhbmdlZCB0byBvbmx5IGhh
dmUgYSBzaW5nbGUNCj4gPiB3b3JrZXIuDQo+ID4gQXMgdGhpcyBwYXRjaCBpcyBwcmV0dHkgaW52
YXNpdmUsIEplbnMgYW5kIG1lIGFncmVlZCB0byBub3QNCj4gPiBiYWNrcG9ydCBpdC4NCj4gPiAN
Cj4gPiBJbnN0ZWFkIHdlIG5vdyBsaW1pdCB0aGUgd29ya2VycyBjcHVzZXQgdG8gdGhlIGNwdXMg
dGhhdCBhcmUgaW4gdGhlDQo+ID4gaW50ZXJzZWN0aW9uIGJldHdlZW4gd2hhdCB0aGUgY2dyb3Vw
IGFsbG93cyBhbmQgd2hhdCB0aGUgTlVNQSBub2RlDQo+ID4gaGFzLg0KPiA+IFRoaXMgbGVhdmVz
IHRoZSBxdWVzdGlvbiB3aGF0IHRvIGRvIGluIGNhc2UgdGhlIGludGVyc2VjdGlvbiBpcw0KPiA+
IGVtcHR5Og0KPiA+IFRvIGJlIGJhY2t3YXJ0cyBjb21wYXRpYmxlLCB3ZSBhbGxvdyB0aGlzIGNh
c2UsIGJ1dCByZXN0cmljdCB0aGUNCj4gPiBjcHVtYXNrDQo+ID4gb2YgdGhlIHBvbGxlciB0byB0
aGUgY3B1c2V0IGRlZmluZWQgYnkgdGhlIGNncm91cC4gV2UgZnVydGhlcg0KPiA+IGJlbGlldmUN
Cj4gPiB0aGlzIGlzIGEgcmVhc29uYWJsZSBkZWNpc2lvbiwgYXMgZGE2NGQ2ZGIzYmQzIGRyb3Bz
IHRoZSBOVU1BDQo+ID4gYXdhcmVuZXNzDQo+ID4gYW55d2F5cy4NCj4gPiANCj4gPiBbMV0NCj4g
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2VjMDE3NDVhLWIxMDItNGY2ZS1hYmM5LWFi
ZDYzNmQzNjMxOUBrZXJuZWwuZGsNCj4gDQo+IFdoeSB3YXMgbmVpdGhlciBvZiB0aGVzZSBhY3R1
YWxseSB0YWdnZWQgZm9yIGluY2x1c2lvbiBpbiBhIHN0YWJsZQ0KPiB0cmVlPw0KDQpUaGlzIGlz
IGEgbWFudWFsIGJhY2twb3J0IG9mIHRoZXNlIHBhdGNoZXMgZm9yIDYuMSwgYXMgdGhlIHN1YnN5
c3RlbQ0KY2hhbmdlZCBzaWduaWZpY2FudGx5IGJldHdlZW4gNi4xIGFuZCA2LjIsIG1ha2luZyBh
biBhdXRvbWF0ZWQgYmFja3BvcnQNCmltcG9zc2libGUuIFRoaXMgaGFzIGJlZW4gYWdyZWVkIG9u
IHdpdGggSmVucyBpbg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9lYzAxNzQ1YS1iMTAy
LTRmNmUtYWJjOS1hYmQ2MzZkMzYzMTlAa2VybmVsLmRrLw0KDQo+IFdoeSBqdXN0IDYuMS55P8Kg
IFBsZWFzZSBzdWJtaXQgdGhlbSBmb3IgYWxsIHJlbGV2ZW50IGtlcm5lbCB2ZXJzaW9ucy4NCg0K
VGhlIG9yaWdpbmFsIHBhdGNoIHdhcyB0YWdnZWQgc3RhYmxlIGFuZCBnb3QgYWNjZXB0ZWQgaW4g
Ni42LCA2LjEwIGFuZA0KNi4xMS4NCg0KRmVsaXgNCg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3Jl
ZyBrLWgNCg0KLS0gDQpTaWVtZW5zIEFHLCBUZWNobm9sb2d5DQpMaW51eCBFeHBlcnQgQ2VudGVy
DQoNCg0K

