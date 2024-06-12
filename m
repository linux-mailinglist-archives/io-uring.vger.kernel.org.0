Return-Path: <io-uring+bounces-2188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D5190572F
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 17:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 316441C20BDF
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936101802D7;
	Wed, 12 Jun 2024 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="TSmXuZes"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEC11DDEB;
	Wed, 12 Jun 2024 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206844; cv=fail; b=ausKuiFufrQ4ZRf6pgiRodqbRymDPWLyV7bn3D0rViCNSzEGbvlLtReNMts+OV9RnJtqoKv5riE13F/Z5SmbvB9RDqjz8Fcjh218SN4UkUEPnXhMMJqO0O5/uk34KA7b2Xm1tTr5uZ0TfFZhVk5K0GC1k6XlDdAtHS9aQdyaA4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206844; c=relaxed/simple;
	bh=D7bzJOE4kQW4YJjPdx638sS9DZ+pZrdb5Z//8HyobXs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BUWHtTVoJ6FSavrTrEAooVqkGNPwk7eYu535FICS7cyD3Rj9PToCBq8HcLhq7VcBTYV0PeJ1S1828YtlZ05Dkwao+FO4sDFysKKUJEed5Ye1BG/su57u0gKGfrJUONaVP/X7/Cf1b7G0GNm40XF3PIN3o2iyYENnVpxcxr8E4dI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=TSmXuZes; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101]) by mx-outbound40-19.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 12 Jun 2024 15:40:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaxCGE3r8YpPjpR75s7yXmBp1cmBnJoNuwVXyZW4OCcgg7Nf4QGDgh6W5UArU56PylLlW169GHhfUzv35xzj0TSIzlw2Jkg30Z2D+YYfxI8olOipYEvsbKZ4T9/22mJ5vbU6v+UmBNMSsVRB64ZXShPPbORVbW7pDcT2uFPyA3so7FdWW9tVfTBFJHG7tjjR82R+SjsNVsaYffrFqVQZtDwH3UEc35w4zq15jBbZSZKJFKlYw91JI1kg1NBEKhbaWO24qC9N8r/0P0iJbyS2w4LiCzpqPsUoh7lRXC7ueqX082nFUNlS+aT09rNXTibjdNHO2SFLLcvo/WajQBaPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7bzJOE4kQW4YJjPdx638sS9DZ+pZrdb5Z//8HyobXs=;
 b=MBTWmoXwaYG6o3DfNAEOoFFf2QzxVUEMy2jL6gY8rmOtYT9bsa5zUH8ACFt4kr4JmAFzV3eT50XQrglVBdZvRB2lqFEI98U8FM/Ip6KTwZ7CJS99hfLkeCjcpzsVtWDKHGGGH96pmR7V7vplG+K50mt5Osv37SgitD/5nw9RbPDZDHowtixkGK6repmswwk7hqJrT1uKd3BMcRWLZ/arrUBoVNLd6mI06xO/1DaqXVLtAZ7otlIBP2CpgNtsPQiJB/AqJ7D+gI6M3VJwv8f+Ngkkg5qL6C18XXnowZAek2bQEQ48mmsmjRBzB4IpBO1ax3H+Yc6Fm4WUul9c72+l+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7bzJOE4kQW4YJjPdx638sS9DZ+pZrdb5Z//8HyobXs=;
 b=TSmXuZesHbLCc3Dzbfrg7JPf+Y3/jsdQ+jnkl9gSUwJBB4zGTHzYN8DSaz0Cd/yMGifNNN67eNDJdpQIFwSURqH6FcI7C2fQiRu1WP4NVVgGLYbSRUEKedEdCbXTdyU/4SqG3DA887Dm2S/hrpPoqb0VhpGylvjUpNpuyo4fnA0=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by MN0PR19MB5778.namprd19.prod.outlook.com (2603:10b6:208:376::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.21; Wed, 12 Jun
 2024 15:40:17 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.7677.019; Wed, 12 Jun 2024
 15:40:14 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Kent Overstreet <kent.overstreet@linux.dev>, Bernd Schubert
	<bernd.schubert@fastmail.fm>
CC: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Thread-Topic: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Thread-Index:
 AQHasfIoshMbsaqF30mIAtaLNshpxrHCTJsAgAAjJYCAAFZxAIAAIfsAgABj5ICAAO/qAIAABxqAgAAWqgA=
Date: Wed, 12 Jun 2024 15:40:14 +0000
Message-ID: <4e5a84ab-4aa5-4d8b-aa12-625082d92073@ddn.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
 <a5ab3ea8-f730-4087-a9ea-b3ac4c8e7919@fastmail.fm>
 <olaitdmh662osparvdobr267qgjitygkl7lt7zdiyyi6ee6jlc@xaashssdxwxm>
In-Reply-To: <olaitdmh662osparvdobr267qgjitygkl7lt7zdiyyi6ee6jlc@xaashssdxwxm>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|MN0PR19MB5778:EE_
x-ms-office365-filtering-correlation-id: c9294bdf-b89b-4379-a0e0-08dc8af5f407
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230034|7416008|366010|376008|1800799018|38070700012;
x-microsoft-antispam-message-info:
 =?utf-8?B?TnVldjlrNGdTeEI4b0Zjc0svYllqa2pLbDNYaGVtOUlhdmQxc1pvOHNPblMw?=
 =?utf-8?B?ZEEySmlac2tNV2hvdTgvMUlhUHp2aWFCTFYvQzlTT1ptTEpvM0tpdGg1S3dt?=
 =?utf-8?B?dTBKWTdrOWFvM0o3RkhLbTdVUnY2MFFhZ0tyZS95dnRRN2FnMDFkRGt3V0JF?=
 =?utf-8?B?NEFFeDZ0V3p4aXBWSEg3U3EwOW56MTN2dVVqajNkR25JTzFvdUZ6VFBtZG5F?=
 =?utf-8?B?VG5YbkI5OWNZeUhlSUVxcDJsTGkyV2pyc3QxYzZ3UytyL1NlOWFLcFZIaVA4?=
 =?utf-8?B?OXJmaW8zM2phMFZuVVNTSUxsZzY2ekFXNXE0WkdUQkU3aDZFaUtOR1h0UGVQ?=
 =?utf-8?B?RGxxQi9ITnQrWlUxbGg5RTA0dUpicmd2QUFMdlJDaUxWQ1cwcGRwbHZLV3d5?=
 =?utf-8?B?aVIyS1F3N3dJVEtqRnR3YlpiS3ZTN24yN2RabktRZUhGTzFaMXAyYkNmZlBC?=
 =?utf-8?B?T0VrbVBvZnd4QzRtc1BMNjFXQTlOMFlUN3BkMUdFNENDZmtIbEhmVW8zTFdh?=
 =?utf-8?B?Q1pldTQ3bDJQMVVGT3NORmlQRVdqSUpKRjhyYmszWVA3SnFYWlRFZmlDZXY3?=
 =?utf-8?B?YWN5VzRoSFhyVkhJR1pDQjhwb3ViVjgrZmF3R1FOK1owQ0NFaXpraTR1Z2FW?=
 =?utf-8?B?cmFUV0VtdkViM3BacGNTWmRGNXZyWXAxMGtiZ29jOHYrUFp4RWh5RHRvM3ZC?=
 =?utf-8?B?eDEwYjJHbUlkdW15YTV4cG4weGhUMGtqa3lsOWJMaU5TOS9YMVJheGZSNmlk?=
 =?utf-8?B?OE9CZjd0b0Q1RkpzQVR3SERlUmI5SWM2b3dwSis5aEJMN2MvZFNBbk15dTBS?=
 =?utf-8?B?ZmpWaHVYSFR3SkJmRlNZc2EyK1pjNGorMmlCZEFIKyt3TlYwWEF3aGh6NlhW?=
 =?utf-8?B?aTdibmFOc21MYWlGbFZmZjJWSlRtbUQ4ci9EMkJ1V0Z4ek5LanlHaWR2TFRH?=
 =?utf-8?B?Q0w2VjR1SE43d3Z6Ymo3WFdaK0txb1g2ZmJzRVFUanVwSzJNZ0F4OTdOcnFI?=
 =?utf-8?B?L2hFYlhNT0ZNZGFNRjIzZlZxa0M5RXkzNEZkZ2JZODdObTd5ZWNqUXFvUmg0?=
 =?utf-8?B?N29OK1ZidTdHc1BIUDVvQ2hoUlh3TW1nU2paNWc1cmU1NlpBOUpnYndFTHNB?=
 =?utf-8?B?OE5welQrOFFBY2pwSEpZWC9Dd0dLems3TnpNUjBTQmJIcFQxY0JpN2NhellX?=
 =?utf-8?B?Rk53T0Jyd3oybXc1MlA3bW1yemp0VElMOFpNeXdVWFZ3bm9hQ0F5SkdtUHg1?=
 =?utf-8?B?K2p0WjUzUk52MGNTQVplQjBmb3BiKzl6V2IwMFVvdHQ4TU93ZWFtdUZueFZB?=
 =?utf-8?B?WDIvNk1qRXd4R202KzdtS3UwbmhoMVZiMEVoUVh0T1ZQc1p1cGZwWVcvQldK?=
 =?utf-8?B?WHIyUlE1UDNXbEM1cjUwUFlFUkowcklodUR5eUZiSWkwNEdqOE03VEltM2pF?=
 =?utf-8?B?eU5qRDJWYmdlZ2pUYzg0eDNGRWppYmNPUzZFdlNzMXpkdHpvSzRQOXRiUXBj?=
 =?utf-8?B?U0EvZ1gycGVkUWVCRkttRmdmK29wdldyTnAwT3M4Z1BuT2trSC9yVksxVU9X?=
 =?utf-8?B?Mm0xeUQwVmRqcFVNVk5MMTRQTUdGZGorc2NhZXYyVXpPZERVaW1jaEZMd1lw?=
 =?utf-8?B?ejVTSG84eC9nVGF3dFNXRVVFYXBEaUp5YXFMRmRnbUZCWkU3MnhvWWhXc1hG?=
 =?utf-8?B?Qk80NnNCZEd1LzdUM0FPZHA4YVdwZWJuTEJmVmtNZDFNTDJlOUxudVJmSndv?=
 =?utf-8?Q?x4sbkIuGdqV1bTV0ffirCsiiWjD1FvfYtshQKkC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(7416008)(366010)(376008)(1800799018)(38070700012);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zk5NSEVBblY5SG9DdThyOFE2MWxOVEJPaSs4Q3NxQVFEdnVTZ01TTk54NTdX?=
 =?utf-8?B?QUZlVWJDZWFUdFY1UFRJNDRsTUltNExWQnQrYXRzTFlPR3EvZHk2enN5eDM1?=
 =?utf-8?B?UEhtSkYwU3MvVVdQYmhodE1TRmlEcnBVZlBRNDBCNytrM2dPUm16K3ZWL1M2?=
 =?utf-8?B?TnlYaDVzUjR1U1BweDN3SXV4Q1hIOGp1QjRRbkQxZmJobGwyeFo2cGVpUnQ1?=
 =?utf-8?B?NkNyUXZBL29DZXRiQUdJcmpsU2Jpd3NSb3BwNkZqZkNheDBGNUE1KzFjdkt1?=
 =?utf-8?B?L2xpUTUwWGZKZWNSMDlYMzVxQWU3Y0RGM3BBZURLSnR0N1FQdGNpWVB2bU91?=
 =?utf-8?B?MU5rRXZEVGdtR1BNdDJ3TDRGem16SmZXQ3NBSjFWSjF3TkJqZ0tFVkREcVFW?=
 =?utf-8?B?VEJKNzQwN3BKODE5TDA0dlA2bnJPZW4zYlluTE1qcmZMaWdRWGZwcUJtWFVu?=
 =?utf-8?B?cEtHRktkZlc2ckRSTnFEeEVIUkxpazk1N0FkTXQ3TW9LTmFxMkV6Q3A2K2Zx?=
 =?utf-8?B?dmRqVXRRbW5IbWl5NlZxSkRWRGd1cHg4QTgwS0dyeFEwOHZVdWhlcHlHby9r?=
 =?utf-8?B?UEVzckNoNWRQYUdYOFNpWE1jWmdzWW1SVmhvK2FWK1dXYU5mVXZoRExRYW40?=
 =?utf-8?B?UWRXMG5uYm81U2ZCZDczSkdFZDkrK1pYL1c5SGQ0bFNuNzhnaThZQVNDL2RU?=
 =?utf-8?B?amgreWxrUjhVb0pRNEh0OXpRL3pkQnRmL3dVUnNKNXVEck1hRTdpU082VWln?=
 =?utf-8?B?aFhiQ2V5eTdPSXZTMnVuQkRhc2dmUHdjek8xalA3a0d2aDFrVW1jd3Bka0hH?=
 =?utf-8?B?S0hycHFZNm5OVTl5YXJFcTM3b2pnVFR5ZjJLU1pnTThFaW4rYUE3TC92dzNq?=
 =?utf-8?B?cDhPcm8vd3d2dDVPbGZXSFRUZXVFWEtYZ0sxSThNQkVnbmJGaEcza3N2azdK?=
 =?utf-8?B?OXpjdTBYTkpJWWtSeVdEWXNXbHF5dE9xKzhFRlIxcE1TSENWd0MxNHNyM0VZ?=
 =?utf-8?B?MkszTXdsK3ZZeWRsTXpudy9lb3hhV1RwK0NsYVYycE1OSVgza3J5ZGNTQ2dm?=
 =?utf-8?B?bnRNejFyY3N1ZzcrTk9HWkQ4KzcrdUJkbTFlc0RURWorKzVTYnFLeWJwbEdq?=
 =?utf-8?B?S0RVYnk4OWVDdVhaM081S2dYZGs0emx6WGxTa1l4NjJTSENNZWdTVXJlbWxQ?=
 =?utf-8?B?Rk1ONFkxMEwySFVyWUFkK3N2NzNIb3U4dzV0ejAxSmV5UUVxdWVXZmVoa3gr?=
 =?utf-8?B?TjNEOXQ1QVlpaVczQkwremZiZi9wWWFyYmJhbGNEdmFqODZoKzlCYmxiM0N1?=
 =?utf-8?B?Ujg5VVhVRlowL0xJS3RaNW4wMC9jNzFuRVpxT0ZDZjNSWXpFZDY0MUZXSEtM?=
 =?utf-8?B?eCthMDIxSllqazNuaFlnMVhZRDdTWWlqZnlhWE02cjV2U0dWS0tnR3luZ3RJ?=
 =?utf-8?B?KzBubHB4RWRuNFkrM0dlNW83aHQxQ1lJY1B2T1lGaWExTFIyRU5XS1E1VmRh?=
 =?utf-8?B?bVI4ck5LSnh5Uk5SekxLZDd4dW5nV3RSWHVVempqTlpqOSthdTFsNy9SczFx?=
 =?utf-8?B?Q0tkbDdkbFF0ODR2SGhpNzMyVjlXZ1gyeWdVQm5TZHJrRjZ4MzZERlRNMk8v?=
 =?utf-8?B?eWhvZ0FmVkp3b1ZrcE8yZEFxL1E3MEhDK0Q3TC9ib0d2eVNKVTlpRFAzbzRW?=
 =?utf-8?B?UkJxQkx1dEhZMTN5VEU5cnRmbm5CdXF5UnVYYjVQL2JmN1BUMVh1V25BYVMy?=
 =?utf-8?B?ek9wNkVuNWVjTnFDeFprMVJHd2l3SWRPUXdoS3pIdEhEVER4cUVWZEp6OHRm?=
 =?utf-8?B?RDVjMXIxZkRFalZ6TWZrNGhyNmxGK3VYMUltM29oYktuME5YeTVNSjZhNmN5?=
 =?utf-8?B?SlRIZjJLOWVZNUNUcURyTXNkaWdFMHo0a0VDNDVEZ3F1MXJRcHV3MUxPTXRU?=
 =?utf-8?B?eHNpS0NmMWZPSmRmaHRtL0lkRDVMUmNQTDV0QTZOL2MyRUdsamd0b0J2WlRV?=
 =?utf-8?B?bG92bVMyMFBCZVhvSjBhd1M1Y0huRm9FRjZXaHFlNDcyRmtEK0R6UzdxYk9X?=
 =?utf-8?B?ZzcwaUdDcDdNTGk4Q3psNzV4VE1QZzNzS1Brb1BYdDhOenRENlJTL0xVK1VO?=
 =?utf-8?Q?4ygQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FB4D1818D484143AA623E12018B0492@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Iha/Z6Xx1GfbBQIPJygaaqqm8LjGUWYtQEjJVL8N0wzsHt2lbTovmdXtp+1pIHHBPZdB1qFWov9/ywHvyba0vHCcBP9GHAftybrdQ50WvEg7NOtKU6O+LJGKFtYmUkTyW4PvkLfCrN2YU9GG+zrgQo1AypvKxK8Bmmna5rvvmfTkjaLPz/xAxkjIBi2uyZFV0ItXv7FFE75RMhP/P+eAQc4zbmBxDKY0h5TYbhh4agyLXGbvHnHHbJq+2uxajT1nYaXTDHLT2BrkC3r6McHTtnEfuNTmoYjRL01ofYwgpjd2YUj2FIQlBwUXZ0JFuJyh5G6dk/vxfSRtilUAlpAcTI6mnpA2CkQQpPeSCpSIhKsYlI4QWcLxy9iW8FoHJQj7rcUSbU0MvKqw1hGETXyrl5lWA5Nx7qEq+ffl9mCMg6FqYvDqjYkWB9ZHpyFM5QoI2Tez4zrk78EVGdOHX1XDF/J8FukXIZ+vnjhTJka8CW6Tj/6xpR8JmirTmCxJYFNJzCq5z3iGojde46+Klz9OSwxg43tpzJpC9b8THKEbckFOV9NuyhpQdCI3IhdiY5aV4H7aaQYZGED2pEN8NYnmLruZghBZPN3Onyr5P0yhwZ4rrnSFFu/J8skjhWT3NgGGYAZGTfOz8SkIthw9EI/N7A==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9294bdf-b89b-4379-a0e0-08dc8af5f407
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 15:40:14.5179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: btlL9DwmOjNrCjHIY7eRNO/dKrAP45MmCYEEJoHdkx5QyswUpodmtkF+WJQn5vxm0ALI2lV79uy4l3zCaxl6AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5778
X-BESS-ID: 1718206819-110259-5365-6872-1
X-BESS-VER: 2019.1_20240605.1602
X-BESS-Apparent-Source-IP: 104.47.58.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaWBsZAVgZQMM3UNMnY1DAxxS
	zVxMjA0Mg40cgoOTEtNdHc1MzYLM1CqTYWAL/g/GBBAAAA
X-BESS-Outbound-Spam-Score: 0.40
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.256904 [from 
	cloudscan17-51.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
X-BESS-Outbound-Spam-Status: SCORE=0.40 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_SA085b
X-BESS-BRTS-Status:1

T24gNi8xMi8yNCAxNjoxOSwgS2VudCBPdmVyc3RyZWV0IHdyb3RlOg0KPiBPbiBXZWQsIEp1biAx
MiwgMjAyNCBhdCAwMzo1Mzo0MlBNIEdNVCwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+PiBJIHdp
bGwgZGVmaW5pdGVseSBsb29rIGF0IGl0IHRoaXMgd2Vlay4gQWx0aG91Z2ggSSBkb24ndCBsaWtl
IHRoZSBpZGVhDQo+PiB0byBoYXZlIGEgbmV3IGt0aHJlYWQuIFdlIGFscmVhZHkgaGF2ZSBhbiBh
cHBsaWNhdGlvbiB0aHJlYWQgYW5kIGhhdmUNCj4+IHRoZSBmdXNlIHNlcnZlciB0aHJlYWQsIHdo
eSBkbyB3ZSBuZWVkIGFub3RoZXIgb25lPw0KPiANCj4gT2ssIEkgaGFkbid0IGZvdW5kIHRoZSBm
dXNlIHNlcnZlciB0aHJlYWQgLSB0aGF0IHNob3VsZCBiZSBmaW5lLg0KPiANCj4+Pg0KPj4+IFRo
ZSBuZXh0IHRoaW5nIEkgd2FzIGdvaW5nIHRvIGxvb2sgYXQgaXMgaG93IHlvdSBndXlzIGFyZSB1
c2luZyBzcGxpY2UsDQo+Pj4gd2Ugd2FudCB0byBnZXQgYXdheSBmcm9tIHRoYXQgdG9vLg0KPj4N
Cj4+IFdlbGwsIE1pbmcgTGVpIGlzIHdvcmtpbmcgb24gdGhhdCBmb3IgdWJsa19kcnYgYW5kIEkg
Z3Vlc3MgdGhhdCBuZXcgYXBwcm9hY2gNCj4+IGNvdWxkIGJlIGFkYXB0ZWQgYXMgd2VsbCBvbnRv
IHRoZSBjdXJyZW50IHdheSBvZiBpby11cmluZy4NCj4+IEl0IF9wcm9iYWJseV8gd291bGRuJ3Qg
d29yayB3aXRoIElPUklOR19PUF9SRUFEVi9JT1JJTkdfT1BfV1JJVEVWLg0KPj4NCj4+IGh0dHBz
Oi8vbG9yZS5nbnV3ZWViLm9yZy9pby11cmluZy8yMDI0MDUxMTAwMTIxNC4xNzM3MTEtNi1taW5n
LmxlaUByZWRoYXQuY29tL1QvDQo+Pg0KPj4+DQo+Pj4gQnJpYW4gd2FzIGFsc28gc2F5aW5nIHRo
ZSBmdXNlIHZpcnRpb19mcyBjb2RlIG1heSBiZSB3b3J0aA0KPj4+IGludmVzdGlnYXRpbmcsIG1h
eWJlIHRoYXQgY291bGQgYmUgYWRhcHRlZD8NCj4+DQo+PiBJIG5lZWQgdG8gY2hlY2ssIGJ1dCBy
ZWFsbHksIHRoZSBtYWpvcml0eSBvZiB0aGUgbmV3IGFkZGl0aW9ucw0KPj4gaXMganVzdCB0byBz
ZXQgdXAgdGhpbmdzLCBzaHV0ZG93biBhbmQgdG8gaGF2ZSBzYW5pdHkgY2hlY2tzLg0KPj4gUmVx
dWVzdCBzZW5kaW5nL2NvbXBsZXRpbmcgdG8vZnJvbSB0aGUgcmluZyBpcyBub3QgdGhhdCBtdWNo
IG5ldyBsaW5lcy4NCj4gDQo+IFdoYXQgSSdtIHdvbmRlcmluZyBpcyBob3cgcmVhZC93cml0ZSBy
ZXF1ZXN0cyBhcmUgaGFuZGxlZC4gQXJlIHRoZSBkYXRhDQo+IHBheWxvYWRzIGdvaW5nIGluIHRo
ZSBzYW1lIHJpbmdidWZmZXIgYXMgdGhlIGNvbW1hbmRzPyBUaGF0IGNvdWxkIHdvcmssDQo+IGlm
IHRoZSByaW5nYnVmZmVyIGlzIGFwcHJvcHJpYXRlbHkgc2l6ZWQsIGJ1dCBhbGlnbm1lbnQgaXMg
YSBhbiBpc3N1ZS4NCg0KVGhhdCBpcyBleGFjdGx5IHRoZSBiaWcgZGlzY3Vzc2lvbiBNaWtsb3Mg
YW5kIEkgaGF2ZS4gQmFzaWNhbGx5IGluIG15DQpzZXJpZXMgYW5vdGhlciBidWZmZXIgaXMgdm1h
bGxvY2VkLCBtbWFwZWQgYW5kIHRoZW4gYXNzaWduZWQgdG8gcmluZyBlbnRyaWVzLg0KRnVzZSBt
ZXRhIGhlYWRlcnMgYW5kIGFwcGxpY2F0aW9uIHBheWxvYWQgZ29lcyBpbnRvIHRoYXQgYnVmZmVy
Lg0KSW4gYm90aCBrZXJuZWwvdXNlcnNwYWNlIGRpcmVjdGlvbnMuIGlvLXVyaW5nIG9ubHkgYWxs
b3dzIDgwQiwgc28gb25seSBhDQpyZWFsbHkgc21hbGwgcmVxdWVzdCB3b3VsZCBmaXQgaW50byBp
dC4NCkxlZ2FjeSAvZGV2L2Z1c2UgaGFzIGFuIGFsaWdubWVudCBpc3N1ZSBhcyBwYXlsb2FkIGZv
bGxvd3MgZGlyZWN0bHkgYXMgdGhlIGZ1c2UNCmhlYWRlciAtIGludHJpbnNpY2FsbHkgZml4ZWQg
aW4gdGhlIHJpbmcgcGF0Y2hlcy4NCg0KSSB3aWxsIG5vdyB0cnkgd2l0aG91dCBtbWFwIGFuZCBq
dXN0IHByb3ZpZGUgYSB1c2VyIGJ1ZmZlciBhcyBwb2ludGVyIGluIHRoZSA4MEINCnNlY3Rpb24u
DQoNCg0KPiANCj4gV2UganVzdCBsb29rZWQgdXAgdGhlIGRldmljZSBETUEgcmVxdWlyZW1lbnRz
IGFuZCB3aXRoIG1vZGVybiBOVk1FIG9ubHkNCj4gNCBieXRlIGFsaWdubWVudCBpcyByZXF1aXJl
ZCwgYnV0IHRoZSBibG9jayBsYXllciBsaWtlbHkgaXNuJ3Qgc2V0IHVwIHRvDQo+IGhhbmRsZSB0
aGF0Lg0KDQpJIHRoaW5rIGV4aXN0aW5nIGZ1c2UgaGVhZGVycyBoYXZlIGFuZCB0aGVpciBkYXRh
IGhhdmUgYSA0IGJ5dGUgYWxpZ25tZW50Lg0KTWF5YmUgZXZlbiA4IGJ5dGUsIEkgZG9uJ3QgcmVt
ZW1iZXIgd2l0aG91dCBsb29raW5nIHRocm91Z2ggYWxsIHJlcXVlc3QgdHlwZXMuDQpJZiB5b3Ug
dHJ5IGEgc2ltcGxlIE9fRElSRUNUIHJlYWQvd3JpdGUgdG8gbGliZnVzZS9leGFtcGxlX3Bhc3N0
aHJvdWdoX2hwDQp3aXRob3V0IHRoZSByaW5nIHBhdGNoZXMgaXQgd2lsbCBmYWlsIGJlY2F1c2Ug
b2YgYWxpZ25tZW50LiBOZWVkcyB0byBiZSBmaXhlZA0KaW4gbGVnYWN5IGZ1c2UgYW5kIHdvdWxk
IGFsc28gYXZvaWQgY29tcGF0IGlzc3VlcyB3ZSBoYWQgaW4gbGliZnVzZSB3aGVuIHRoZQ0Ka2Vy
bmVsIGhlYWRlciB3YXMgdXBkYXRlZC4NCg0KPiANCj4gU28gLSBwcmVhcnJhbmdlZCBidWZmZXI/
IE9yIGFyZSB5b3UgdXNpbmcgc3BsaWNlIHRvIGdldCBwYWdlcyB0aGF0DQo+IHVzZXJzcGFjZSBo
YXMgcmVhZCBpbnRvIGludG8gdGhlIGtlcm5lbCBwYWdlY2FjaGU/DQoNCkkgZGlkbid0IGV2ZW4g
dHJ5IHRvIHVzZSBzcGxpY2UgeWV0LCBiZWNhdXNlIGZvciB0aGUgREROIChteSBlbXBsb3llcikg
dXNlIGNhc2UNCndlIGNhbm5vdCB1c2UgIHplcm8gY29weSwgYXQgbGVhc3Qgbm90IHdpdGhvdXQg
dmlvbGF0aW5nIHRoZSBydWxlIHRoYXQgb25lDQpjYW5ub3QgYWNjZXNzIHRoZSBhcHBsaWNhdGlv
biBidWZmZXIgaW4gdXNlcnNwYWNlLg0KDQpJIHdpbGwgZGVmaW5pdGVseSBsb29rIGludG8gTWlu
Z3Mgd29yaywgYXMgaXQgd2lsbCBiZSB1c2VmdWwgZm9yIG90aGVycy4NCg0KDQpDaGVlcnMsDQpC
ZXJuZA0K

