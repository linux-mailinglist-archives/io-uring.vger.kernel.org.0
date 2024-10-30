Return-Path: <io-uring+bounces-4198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6CF9B6329
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FDDD1F219CB
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 12:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6C81E5734;
	Wed, 30 Oct 2024 12:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AKIdWO8J"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED451E260D;
	Wed, 30 Oct 2024 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730291850; cv=fail; b=G5OtTcwbVj1KsRFo7UJaUZ4DJw0ECZVg0FS5Kxc4x/NtvWJe9ihrNLJ3j7j/97beoRaPV+9XmVVy+H/LxWI/r5pwb4ttET9ibyg5+lqG1DDN9FWRrKR8PwKBwT6rvHyTrub0E4ZYaglF+QCkf93Y7TdUBkDHh1PDH0Eu2hR3Dxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730291850; c=relaxed/simple;
	bh=uKzyXUAdo+si4KIwpi8U+ZrS78JIK+1cc8N4ESiXOYE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fswdjn+y8rBTQa49Mj0rijE1Y9+Fjbv74sH73xk3WGZG+7xnV8QsVxijwaY+oz9/HUqQ7To6X9KLgEasPPsx4E9aP/wgcVAbsCDhKZGvzVf1VkeSIU1kDB6ipE0XV7Yol1u68kcNdPHss8ppn4aNBLm0Ks69UXDa93WieUAGEtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=AKIdWO8J; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UAommB021043;
	Wed, 30 Oct 2024 05:37:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=uKzyXUAdo+si4KIwpi8U+ZrS78JIK+1cc8N4ESiXOYE=; b=
	AKIdWO8JDzIY/GabLNH9umKlojBJjumFWXb56FOqoWOt4qbuHiBWk53XAZC25GwC
	WlIyCK+n8x53m0aNuooOARYhZpNOYLVEwdfjjM4xG0smw0Tk/8PgBd4as0fGP+lQ
	T88noaTmo4P4BGuhzrGgNhV5Ks2E+Y5sDOlec4d1N84vBGoBd9O6Blf27WW1fTnH
	1I2ahWQ8577UiImo2N62TRvNrMbiWwjWkgTIpv84T2iTyRA1MBTBPmyAY44IVd0p
	yGP6MLFMK+M+IF0v0aDmnmcdOjykHR/MASREdrN+D65Q6jJcnh1vL6rODUEYejGN
	GnuMRjXegayMHENhbNlqpA==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42kkd4rkmb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 05:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2/Z1bf0DsWA3Vxq6+aUCi6V0E6WvtV6m0t3egdx+84tzDJHQ0fzMuLuKUol59mMj1n0TxD0jX4EzHTYxTV6bZKf0leB/6hP31gx1bdNKXsMACY8cHJaHZ8ThOxXBFPAsfl65ogwt5iJJdJol6y8t+JT7BZTPq8S7os6akU0CI9M3q4/sa6zy23CSt7yZmjqz1CaYU9wYKkFn4RcMw/40+CVtoBcaXckBAw/NndQblvVPI/xF3rBB6iTE2CElQd8SPv8DADTPHO2mjwQoiUHuZ+7Dff0nni791CWNuc4oCubADYs1cUSg132r/VkeXj0/ZnXmd9WHvG02Dyoi9pl7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKzyXUAdo+si4KIwpi8U+ZrS78JIK+1cc8N4ESiXOYE=;
 b=VEE1K4LwcPCp0Jq842AE5e9ExyjYjfQVusQIownUhAQj2UveQI7rDauwi18YqmcMaZ8BJScUMmH7uZCN1WX3dJZlZgoL3MJ3J7x30qFnsODOrHzDNPoEaRhgYX6pIaNoKWc7JOzJ9n3DxPTxM7MrC3dL0i9uESElSdSXAfqmoV7Hl6lQ7n3BHzP0aExYYhqhWWtwbeTZk+e39WMDSmwPjbPCduFPH4ZIRdDSIq4AyLCIw3jiBEZrRhzWoeJ7yUyMxnp/RJUys/TMkFk4JZVu70nAkepB4g66P1yRbIVUcO28S0fzTKQcHUD5EzGkmhHquBE32SvagrmkNTE7egjvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by CY8PR15MB5847.namprd15.prod.outlook.com (2603:10b6:930:6d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 12:37:23 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8093.024; Wed, 30 Oct 2024
 12:37:22 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Mark Harmstone <maharmstone@meta.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
Thread-Topic: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
Thread-Index: AQHbJJHBGU/CKSkKSEaVm6GhyzSUH7KeShQAgAD9tgA=
Date: Wed, 30 Oct 2024 12:37:22 +0000
Message-ID: <0da7065c-78eb-4615-b618-8e641d0c749c@meta.com>
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241029212918.GS31418@twin.jikos.cz>
In-Reply-To: <20241029212918.GS31418@twin.jikos.cz>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|CY8PR15MB5847:EE_
x-ms-office365-filtering-correlation-id: 2e4b2d6d-6354-4c1e-395a-08dcf8df9a32
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d043MVNCUVpESXBMeW9BOFd2bHZDODQ1VWN3M0NTVVhHeWVKQ1FXMEQ3NU9X?=
 =?utf-8?B?OEJyMEM4RnRka3k1Qi9EYmgzYVlKaUpGdndCZlNGazhkTTBNaWpyLzF3K2lu?=
 =?utf-8?B?WVhwM3FaZms1eFkzOEtiSnlpL0xERmdJLzJrQXF0emIwRXhpYmJIZmxEekNt?=
 =?utf-8?B?Q1RrRFErRDlyTjFyRi9Fd2FOYm13OTNVa09YdFRQWHgvM01ZZUdhbnZzRXE3?=
 =?utf-8?B?dEx3VElieHF5bmd2RS9xQU10MnplZTlURmI1bU8rSW5LR2FuZk5pYnJSUVIx?=
 =?utf-8?B?V2ptMlhackNtejg4MWk0TlJJZjFyLzl2RW53ZHc3SkJDTFUrSkl3YTdaUXFM?=
 =?utf-8?B?ak9vUy80dHhySk8vZFJlWkZlNG04UUcyYnRZMzZqbEhONEhleTBXZFQ2QWdz?=
 =?utf-8?B?aDZQMjFyRUhzNi91T0tXODVoenBmWlJPR2JoMnRucDUwKzM3MmFuY1pqNVJp?=
 =?utf-8?B?ZFV6TGlBVk4zYlV2Z0pXVmRJelZSQzBMZk9MWkp6TE9vN0VXdTJHS1loQ205?=
 =?utf-8?B?V1IzS2NFMVFTc1pudWlLT2ZONDBkcTd1RWdxTHJ1a3hFemdtR0gyNHFzWkMw?=
 =?utf-8?B?SGZrOW1sVlMycjRCdDArcVI3YnkrR3ViY1ZsazgvSHFhbWdWc1NXYmxmenc1?=
 =?utf-8?B?VnBFd0ROWDA5L2RIcjA2M3YzcHdYV2RIck1uNGhSa3lyR0E4Z0JacGZtL3B0?=
 =?utf-8?B?UTNmRXRWeE4wMGJJbGlaZk5JY041dTRRY2REbklPZGRhYU1ZUDg0ZVZqZEtn?=
 =?utf-8?B?L3doUjVGVE9CN0h5VnRKb0w1ZFJlKzFMUEkxYW9IT0xveklqT2wyQU13VXhO?=
 =?utf-8?B?eDhFckhSZGhscmxZUjd1UXdIaXBLb3hqRm5JSmswSlcxQytSSTZIMU45eTQx?=
 =?utf-8?B?RUdLOGFqWERVbTVReEY2YkdXT1BpYmNNcVc0ZE1vZGdab1h3NVRqdWxxUUJT?=
 =?utf-8?B?L0kzWUdOQ1lQeUZUSmh2cGl0K3l2eExYbWZ1Zm1mblFncXZlOUFFTFlLWnVr?=
 =?utf-8?B?ZVE3RkhKcVI3THNvWmdzeXRnVFc4My9MLzlHbk55M09ZMW8vWkpyQ2xXTjJy?=
 =?utf-8?B?QUJ2SWZxa01NMlYwVmRJZ3hVQTExOFhBcEVjRjNwYmxVTFhyckFFN2xQNlhy?=
 =?utf-8?B?UjFMKy92VS91Z2MrMzJEaDE3ODN4M3pJM0VqY2s0L2tDVkJ3QlFlMDBXdXp5?=
 =?utf-8?B?eEFUYkg5djdjRTgzdlVpZW8zTEFYTTF5SmdjL0ZrM3ZUWnFBd1FzVDdId0J3?=
 =?utf-8?B?THkvRE5XV2NscmJSemlpWitzMk5GYTdyWFBBdEh4QVkxOGExb09tSlR4VWIw?=
 =?utf-8?B?L3Nib2FrRnhra1hhYU9ndU1pS0JoMzBYK3FMRFRvTStCeXZyMEF3MWNMUGg4?=
 =?utf-8?B?bkhrUlUvY25wZ1V0U2Jod1N6TU9YdmZKS0JtWGl3Z1FkY0d0azNEOXRYQXRT?=
 =?utf-8?B?ZHA0N3dha0djZDk2RW5hZTZtRE9hVkk4YTFlM1Q2UW03OC8zVU1MM2NYcDR3?=
 =?utf-8?B?VXpKV3VUa3NMakdQd0hYdGNaMDFvcEtzRVBSVzVMdFpRaWtRak1TYzNLZFEw?=
 =?utf-8?B?d3hsQ3p5U0htRUJxRklwZndaUGNmR1V2dHhOSzh4VGdNemhvRXFyU3FYTHVi?=
 =?utf-8?B?Z3FWRzBkSXUveXJRU293aXcvWE5wQk5ZaWhBUG5OMkhydEw1MEU4YU9RcExy?=
 =?utf-8?B?VzhzNTQwRUgyY0FlK1dNUldacnVIL0xDWnpackVFazErOVMrbW5aVkh1ZU1z?=
 =?utf-8?Q?UAKi5qiQMcl2cGUOLT+EVGAYj19hK0BMYKoQRjr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QnYyM2MydW81MnhhOHMvYVhFQi94TkQ5T3B6UzJzeml6WHlOV0VySDFJalRB?=
 =?utf-8?B?ZGYxTDJQM0NVdkhkZjdmR1ZqN0xvdVk4dFB0M0tvYUFGeGxiWEU4WDBNSUhV?=
 =?utf-8?B?RXdYVUhCZzE3MGNNRFAxQkR5TkthektSUEF3QlgrR1VDSzZRWW9pVUh5SVQx?=
 =?utf-8?B?RDFta1NiZ1BiMlRZY21EMnp1Z21tWDBtUU5rZ2xoWUlWRlZtZ1pKTnkxOUZB?=
 =?utf-8?B?UEdPclJFVGFORnRGRUZ2ZnVEYUlmU2swam5jYi93MkQvQk5LeWlXMlVyM0Zp?=
 =?utf-8?B?cXVBYWJCV2JTR3FEUENTTDR3ZUJldm11UXZadFZWNXJkWEJTT2owQVVJSC9o?=
 =?utf-8?B?RDY4V1AyZk9nTW0yQVg2bHExZWo3S0pYak1IeHd1Z0VwVzZ0UmhPRVV0MjVs?=
 =?utf-8?B?cUVZZ1VrUlVmZzFmKzdnZDhkR0QxaWxvdmt3UThPeU5zUzVkRHJQV0JVRzBx?=
 =?utf-8?B?Q0dLWU94djNoWWNlRzJTOVJ6TVozZ2tPK1ZTaUk1TDZKcjkza1hGa2FZZVpm?=
 =?utf-8?B?K3o3U1IrNU9HTWZwZk41UEMzZWkvMEZsNEZuZFY2TmNRVFB2NWx6MGNPaHgy?=
 =?utf-8?B?ZkFmZ20va1VmMHg2czdFcHhRZEtXOUlwY3hPTENKUHVjUEt1aXY4d1RvdXFp?=
 =?utf-8?B?WTNVZDRkZ1FSLzk1ODNqUmJKTFF5SlZ2YUxSZnhVTHJJYjlLTDZ3aGdKWHhn?=
 =?utf-8?B?a1grMDBERk83U0hWOHRMMWwyaGx4T25FeUYrSlExamtoem5WVnpXNXJTdVMy?=
 =?utf-8?B?VXNta1Z2c3VxU1lXRDg3RXdWN05IRnBHbUtuWmM5UE5UYytEdnp6Tm9ORFNC?=
 =?utf-8?B?NVFPdHhsUzAxVVI2TnhrM0c3cFhjdklJUWdwQnpYNEpNQ1RoWU92UnFBaEds?=
 =?utf-8?B?cjgrWkorSzFCTGlNMXNFMlVSUFNhY0dBVjJNU3h2cWJIa2w3eVFMbENsVC8v?=
 =?utf-8?B?ZmpKLy9UejZEbmVtTjZwMnBvWUc5RkFNcHBXclJQSy9JeVVYZkxpbHlJR05B?=
 =?utf-8?B?WTNZK1RJbFJtU2RGS2hrMktaN2RwRzFjTGdsNVJvMVA1NCs2akhNZElySmJy?=
 =?utf-8?B?OGVJeDM4aEQ4TndJSW96c0RuUDBHRXY3RzBHOGg4VDJkaEhKVElPY1FGV0hs?=
 =?utf-8?B?N1l0TlRoWS9odGxjcFFRNERzTVZIQkdpa1FOT3MyMkVVS3BWUEJDZDVTaFdS?=
 =?utf-8?B?aDJ5bkJNNXUzRW9vcU81RVNLcGtXWVlXM3ljMmtHNXpOczFoY3p4L0xDalFB?=
 =?utf-8?B?blpIaUY1Zzd3TkJQcmw5S3JjQmc1Rjcyb3QzZmVkcTFxdVJCSXI0WEV3aVNt?=
 =?utf-8?B?YWwyWTlzRUtDSGdpWkRQbitNay92MDViWTB1RU1SRHdVTkFXOFZqNFJDaWRp?=
 =?utf-8?B?ZkJuUzdrZFZJdk50OXNYYm1sakYzUkMrUFBES0N5OVZaT09XVUJrTGlrRXdw?=
 =?utf-8?B?WkV5Y2p5OVkwTTVMaE9Ddit2MVlBL25GOUtDM1R5enRnRENnaTBwWVVRNlFi?=
 =?utf-8?B?MFFLai96QVhjQU9DcmY1akZuekVaelFrUzBPdEZHRHozYmIxVUNUYm5lRGkw?=
 =?utf-8?B?YkZIQ2xDWGFHTFdvMGFhaHZtWHgvR1o1Q2F2bDlleEZNRHdha3hxVTRkMGpE?=
 =?utf-8?B?OEU4UGRXR0FZK21jb0pDSld6eSs0dmpKbmhCZHkvb285VURBYjZ5Vm5WeUl4?=
 =?utf-8?B?ZWE0MmtXVnpKR1prMXF0YjRYMUlsZDUzdlUvbDhNN2dMY1FVUzBHakJqellG?=
 =?utf-8?B?TkdXSEl2QmdmL1UyMG5icTZGWStKNExnc0hEUHIvSnBVei9BemJIVjBUV0lT?=
 =?utf-8?B?ck1EeGRLeG1OSGxZUk0yNStYNE02Sm1abWxsSnJiUFpJdW5obTE4UEVaV214?=
 =?utf-8?B?SElmQllMazJHekM2Mm9EUFVnMzZjMWpJRkl4WVg4SDFwYW5RbTdEOW16UHZW?=
 =?utf-8?B?UFpwaHprT3oySTZuQWU0MG1MVWdyaWtxaXl0TUY1SksvNTFmVXkzZ2RmdGo1?=
 =?utf-8?B?dXhJeEQ3WGlYdU5kQTR5M3RUZHdCeEcwWDJObklyVEhpTEhTeC9rZSt3WE1V?=
 =?utf-8?B?R216eFZmc3J6TENNNjFteEwvUEZ1dmxWeTFncXV2dUxwZER1NmJjdDhZT2hU?=
 =?utf-8?B?cW1JR3k2Vm5SeWROSUlCQlN5bG1jZC9qVFJ4dC93NWlqTVpMQ0szQjNxVkpS?=
 =?utf-8?Q?jIgA8exsmXDsj+PcNJnW7vI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89F836AD401439489D166AC85CE8C93C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4b2d6d-6354-4c1e-395a-08dcf8df9a32
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2024 12:37:22.7942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8gP+TZCdTNUVCPBMD/pBRcn+JB5aGXIADB5yFFrkXpyfJ7UF+/q4CQyRpPDXVmMlcgEZAjlLvsvGng7ijWdXVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5847
X-Proofpoint-GUID: Z1dosr8eyx5GEk1IKGZcQ-cJpWmFCLZy
X-Proofpoint-ORIG-GUID: Z1dosr8eyx5GEk1IKGZcQ-cJpWmFCLZy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

VGhhbmtzIERhdmlkLg0KDQpPbiAyOS8xMC8yNCAyMToyOSwgRGF2aWQgU3RlcmJhIHdyb3RlOg0K
PiBPbiBUdWUsIE9jdCAyMiwgMjAyNCBhdCAwMzo1MDoxNVBNICswMTAwLCBNYXJrIEhhcm1zdG9u
ZSB3cm90ZToNCj4+IFRoaXMgaXMgdmVyc2lvbiA0IG9mIGEgcGF0Y2ggc2VyaWVzIHRvIGFkZCBh
biBpb191cmluZyBpbnRlcmZhY2UgZm9yDQo+PiBlbmNvZGVkIHJlYWRzLiBUaGUgcHJpbmNpcGFs
IHVzZSBjYXNlIGZvciB0aGlzIGlzIHRvIGV2ZW50dWFsbHkgYWxsb3cNCj4+IGJ0cmZzIHNlbmQg
YW5kIHJlY2VpdmUgdG8gb3BlcmF0ZSBhc3luY2hyb25vdXNseSwgdGhlIGxhY2sgb2YgaW9fdXJp
bmcNCj4+IGVuY29kZWQgSS9PIGJlaW5nIG9uZSBvZiB0aGUgbWFpbiBibG9ja2VycyBmb3IgdGhp
cy4NCj4+DQo+PiBJJ3ZlIHdyaXR0ZW4gYSB0ZXN0IHByb2dyYW0gZm9yIHRoaXMsIHdoaWNoIGRl
bW9uc3RyYXRlcyB0aGUgaW9jdGwgYW5kDQo+PiBpb191cmluZyBpbnRlcmZhY2UgcHJvZHVjZSBp
ZGVudGljYWwgcmVzdWx0czogaHR0cHM6Ly9naXRodWIuY29tL21haGFybXN0b25lL2lvX3VyaW5n
LWVuY29kZWQNCj4gDQo+IFdlJ2xsIG5lZWQgYSB0ZXN0IHV0aWxpdHkgZm9yIGZzdGVzdHMgdG9v
Lg0KDQpZZXMsIG5vIHByb2JsZW0uDQoNCj4+IENoYW5nZWxvZzoNCj4+IHY0Og0KPj4gKiBSZXdy
aXR0ZW4gdG8gYXZvaWQgdGFraW5nIGZ1bmN0aW9uIHBvaW50ZXINCj4+ICogUmVtb3ZlZCBub3dh
aXQgcGFyYW1ldGVyLCBhcyB0aGlzIGNvdWxkIGJlIGRlcml2ZWQgZnJvbSBpb2NiIGZsYWdzDQo+
PiAqIEZpeGVkIHN0cnVjdHVyZSBub3QgZ2V0dGluZyBwcm9wZXJseSBpbml0aWFsaXplZA0KPj4g
KiBGb2xsb3dlZCBpb2N0bCBieSBjYXBwaW5nIHVuY29tcHJlc3NlZCByZWFkcyBhdCBFT0YNCj4+
ICogUmViYXNlZCBhZ2FpbnN0IGJ0cmZzL2Zvci1uZXh0DQo+PiAqIEZvcm1hdHRpbmcgZml4ZXMN
Cj4+ICogUmVhcnJhbmdlZCBzdHJ1Y3RzIHRvIG1pbmltaXplIGhvbGVzDQo+PiAqIFB1Ymxpc2hl
ZCB0ZXN0IHByb2dyYW0NCj4+ICogRml4ZWQgcG90ZW50aWFsIGRhdGEgcmFjZSB3aXRoIHVzZXJz
cGFjZQ0KPj4gKiBDaGFuZ2VkIHRvIHVzZSBpb191cmluZ19jbWRfdG9fcGR1IGhlbHBlciBmdW5j
dGlvbg0KPj4gKiBBZGRlZCBjb21tZW50cyBmb3IgcG90ZW50aWFsbHkgY29uZnVzaW5nIHBhcnRz
IG9mIHRoZSBjb2RlDQo+IA0KPiBUaGVyZSBhcmUgc29tZSBtb3JlIHN0eWxlIGlzc3VlcyBhbmQg
Y2hhbmdlbG9nIHVwZGF0ZXMgYnV0IG92ZXJhbGwgbG9va3MNCj4gb2sgdG8gbWUuIFdlJ3JlIG5v
dyBpbiByYzUgc28gd2UgbmVlZCB0byBhZGQgaXQgdG8gZm9yLW5leHQgbm93IG9yDQo+IHBvc3Rw
b25lIGZvciBuZXh0IGN5Y2xlIChidXQgSSBkb24ndCBzZWUgYSByZWFzb24gd2h5KS4NCj4gDQo+
IEkndmUgbm90aWNlZCBDT05GSUdfSU9fVVJJTkcgaXMgYSBjb25maWcgb3B0aW9uLCBkbyB3ZSBu
ZWVkIHNvbWUgaWZkZWYNCj4gcHJvdGVjdGlvbiBvciBhcmUgdGhlIGRlZmluaXRpb25zIHByb3Zp
ZGVkIHVuY29uZGl0aW9uYWxseS4gV2UgbWF5IGFsc28NCj4gbmVlZCB0byBpZmRlZiBvdXQgdGhl
IGlvY3RsIGNvZGUgaWYgaW9fdXJpbmcgaXMgbm90IGJ1aWx0IGluLg0KDQpJdCBjb21waWxlcyBm
aW5lIHdpdGggQ09ORklHX0lPX1VSSU5HPW4sIHRoZSB1cmluZ19jbWQgZmllbGQgaW4gc3RydWN0
IA0KZmlsZV9vcGVyYXRpb25zIGlzIHRoZXJlIHVuY29uZGl0aW9uYWxseS4gRldJVywgdGhlIG90
aGVyIHVzZXJzIG9mIA0KdXJpbmdfY21kIGRvbid0IGlmZGVmIHRoZWlyIGJpdHMgb3V0LCBwcmVz
dW1hYmx5IGJlY2F1c2UgaXQncyBhbHNvIGdhdGVkIA0KYmVoaW5kIENPTkZJR19FWFBFUlQuDQoN
Ck1hcmsNCg==

