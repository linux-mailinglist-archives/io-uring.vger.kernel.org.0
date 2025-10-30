Return-Path: <io-uring+bounces-10304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B4693C22AEB
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 14B4D4EC64F
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE826147C9B;
	Thu, 30 Oct 2025 23:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="WtadjSxF"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5724169D
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761866136; cv=fail; b=LdTv0w795+XZha4fLLpl5tx/mGNyPJoCZCfZQhyjE2pks3Q+QxCiQ9CPB30EyQjkBm3kpbcArzq5RN9kONAwtNC9dhMBpU8B+62xwb2SNKDrsqMc32MA5WpLdFuwJaiqPVmkdHMBEMzRVmwq9Bc5srOwtr4ROgSAy7Tm3gzUsGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761866136; c=relaxed/simple;
	bh=WSU1j5oG0Xpddcx1JygEm7a6dIJmxvOGERyvtJcrwIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BfkRFJe+rleiBkDFoJByPd73zKC0MMZuC0d9NtOyw2RcNcRAG/Mmy5efLzbJAqa851Xg6fzqc1V0bi7hncQBRaz9WYGBchNyfE99Xogs4TSeVnbegvD1lFdtCSUEoDOXOVCFZWFjpm/Ysjdhy5j1iDsrF9ly4J4DDJ0SPMrz3Z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=WtadjSxF; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020135.outbound.protection.outlook.com [52.101.85.135]) by mx-outbound18-221.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 30 Oct 2025 23:15:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTxTGvR+ey/krKrEUn+VmjIeWPZ1Xxn6diZ50ynZ45UlYL30wd0QrLdKjbUC8g0dXLCuTCndZcMNoXDWUAASC2G8jqZ0hxuSCB8JAs1NGy4jf/JrTZZgVYX5l2rkHNcfeXerDxEkPKDDMygWbiMfsq3rY8kxab8THIOx/QZY5Z6PDzhTCG0jDTf/ce14YmiuBc2LnmhFhS7pNc5DiS57kXikDkNnuaTzdEAyoveZyq+5NXGmqIOBVh1t2t3ThZdlNwhOUs4cQyHNkVjasYBtIU3HslakiU+tkz63R1OLb/1/T8a8rBLFV6YmzLRDJJoV7Q3ClzNsEfZO9FGmSeIbZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSU1j5oG0Xpddcx1JygEm7a6dIJmxvOGERyvtJcrwIA=;
 b=JWkqaoiLtclGkhRTdkhCJxgwFPH4wMeOhbKQ8ixObjv1HphHp+RuL6a82imUOmzF3048qdJSN9MnH2wgIQm5WXqAN03Q+uDMkHXnPJhGwvlKC+5fXl2EfzbbgPaifmBNJ4daeRQEhojACAD8/GT8/0ay5y3YFHBlyz4oR+/GXhAt2JKOcvhIgW2okmAvdw0//b2BD21q4M0DYS5q5EdzOrDZUzwPhyWKX41zm3mExgPfz72S0zC+wo1phgNdH9IekNNsSLuQjU0+9ED5Cw0oF6Z4oE5McVSeVqSnwBZEAgaufjl85lTL47cYsu57P4rTezaCw6FtTXwbVgxlpi4h7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSU1j5oG0Xpddcx1JygEm7a6dIJmxvOGERyvtJcrwIA=;
 b=WtadjSxFv8YZ7/QnnZ4EiRDS7YjYv3AU89qRXKPVVW+Q2nisfztsOg663GDFtk+TNk9qXzFjQnTfXoyO5AiSyJ0obFqJTMN8dHEhIhvCZkskfUE4biGVa/KN9MopsR2bJy5i4GT0/LKxf9K/Sz9cccvOMEQ6Cj7/zt6EPYxpR6U=
Received: from MN2PR19MB3872.namprd19.prod.outlook.com (2603:10b6:208:1e8::8)
 by IA0PPF85464422B.namprd19.prod.outlook.com (2603:10b6:20f:fc04::cb4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 23:15:15 +0000
Received: from MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911]) by MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911%4]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 23:15:15 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>, "miklos@szeredi.hu"
	<miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "xiaobing.li@samsung.com"
	<xiaobing.li@samsung.com>, "csander@purestorage.com"
	<csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Subject: Re: [PATCH v2 3/8] fuse: refactor io-uring header copying to ring
Thread-Topic: [PATCH v2 3/8] fuse: refactor io-uring header copying to ring
Thread-Index: AQHcR5E17UWFFg6ZFU+ws3WFF/hm07TbVvaA
Date: Thu, 30 Oct 2025 23:15:15 +0000
Message-ID: <49d00ff4-1f8a-4f84-b237-3c8e0a6ad9c2@ddn.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-4-joannelkoong@gmail.com>
In-Reply-To: <20251027222808.2332692-4-joannelkoong@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR19MB3872:EE_|IA0PPF85464422B:EE_
x-ms-office365-filtering-correlation-id: fe8c297d-4eb4-41bc-5aea-08de180a2f5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QTAyRW1nMW9DNC9vc3VKa28zZUUyRGFNUk0zcFY5dWtaMU5veTNPMlp5eElR?=
 =?utf-8?B?ZE5QYlRaMUxPdGtwYk0vSzQxcVJhalNYU0hiWTAzRkJlbEYwRWFRVjRCR0hm?=
 =?utf-8?B?Y3ZWNThtT29oSytQVlo2YmFYWllxamZNcHpGcE44WFZ6bU5GSGxpMG04c1hl?=
 =?utf-8?B?VFZmVWZ4M2FyMW96ZWxXT0l4TFZMK0tQQ3RkYldsZVZNdE5LS2VwcG5rNnFZ?=
 =?utf-8?B?NHlabW1aR0pTekFaRGQ0blVRM2NDRTlaRmVkak1HMXdYNURtNTJzUmE3ZlZk?=
 =?utf-8?B?SUZyU0ROQ2lzcGdzYmNmU3o5UXp2a1JkSnNsTVZ2OTJjMnhwZ3dxRUh3WGtp?=
 =?utf-8?B?d3FtM1NUVDRQWG5LZ2s5Z2syZE1hbzJnWVlFYjFtQUthUnNjMUJKTEtEZVJ4?=
 =?utf-8?B?bms0elpaK2xuK01xZkJBdzdqSHdwcXg4ZjV5cHZYRHdWRUI2bHRpUzVGd2FZ?=
 =?utf-8?B?NDB3SW5NWEQ3bGo0Yk55UlFDelAxTEhKeERzaXVlbzRiSit1bis3empSbEJu?=
 =?utf-8?B?dkJlcnlKam9OcUE1R1YvQ0tOenJrb2swaXhEMDljUVpxSFY4SVoyZU9RZzBQ?=
 =?utf-8?B?TUlTREQ0dDlRVE9ab1JPVEs0cnFOL0xnMlo1dFNWT0J2dGI2MndsVlVDanRo?=
 =?utf-8?B?Q01nMisvNFZDRGUycFZQcTIxVU9pRXZzNk9NbFpFcGhFc3h0NlYxNVRueW9V?=
 =?utf-8?B?SndvbVhIL0Y0ckJUL3N1Y3dVMVJQZ29CbkI3MUV5cWhTWnMrMlFjQUN1bWk5?=
 =?utf-8?B?UzdqQTI2Q3IvNVFXSTQwNmdvdFpjbm5EWE5Xd0huSjVEWHNMZTQ2V0hsQ2Ja?=
 =?utf-8?B?NjhiazNYOUFGeWxHS3RmaDRuelpNOEJCOWZSeDBxZ3pVeUtESk1tVlJrdkxm?=
 =?utf-8?B?bk0za1VrZGN2a3grRGdNZmVEWXZETno3Q0FQWGduN3dUZXEreHpVOUwwb1Fk?=
 =?utf-8?B?RXYxc2RzYWVWVW03d1ViWFVzS1FVZit2K0g5bjM5Y2FFeCt0cFVLKzNkd2Vq?=
 =?utf-8?B?ZC9ZWGwzVUU2ZHJHUlpQcFE2dERrNTVmeEMxdG52VmcxSFBTdm5LbmlUZ1hU?=
 =?utf-8?B?aGVra293NFR5T2hmVWY5MmtLUHBXT08zSUpGUFFGQThIaS9NUkJZaVB4WmEw?=
 =?utf-8?B?dEk4NzVmeHgvdW40UnR6TzJURkRoTjdlRS90bnZEWURlOVhPeC90MHhUVkJL?=
 =?utf-8?B?L2ZnUUlRUFpJM1c4WG9RYWU4TVluMVdNN0REVFpEVjN4TEJlR0NJb0pUa2xM?=
 =?utf-8?B?WlIzMDRJUHlBZFF3MEZjL0dHd3I2NnZlaGp5SnZrNkxRWXlvME9ESXRIdDEx?=
 =?utf-8?B?cDByVkRQWFZMc3FuL2I0MnVkQ2t1ZjZlZDFiMUdzcjVKYXFNemdlbXpIOWE5?=
 =?utf-8?B?NkhXaDdzZmJuTVBnTnFESnRhUWJqdjh6eWJ2YmlROG1aMHNzK3NWYnR5TTl4?=
 =?utf-8?B?OWVlelJOK3pBS3ZSNXI1NXNCbTVzUENTWFRTUER4UVpqVFNYVW9PRUxaa3hz?=
 =?utf-8?B?WEkzNEpGQlk2dktrbU56SHZtRWZ3eEZrVmQvK0dUekplRGpyaStqaHNMMVVK?=
 =?utf-8?B?WmM4UWxmcEZIY3lPUkRBeWtDN1hwUnBtNy9RUVJ5dkRGakg3dnBocGZmZXpi?=
 =?utf-8?B?QU50THlxK3ByTDlOSzVTUFIvdFE2SVVCdzlaSldSSmNzQVZkcHRBcVJYd0N6?=
 =?utf-8?B?S29zeEdzQjRhMnF3N1h1cjk4WXladVBjdjA0eDZlWFR4bFpPQlFzYVNTQVRh?=
 =?utf-8?B?WDlDVFYxamkxTFdwQk40ZEJCalVXQ01ZZ0NWWXQzbkxKM0Q3SUlXUGF2eUEv?=
 =?utf-8?B?a1VZaEcwaitTbXROcGs4L2hOcWhQNmpPbTJDSkdnSlFPaW1wNGZieWllSVky?=
 =?utf-8?B?WHB0akFGeG4zRlZ5UnZ5OTJLaGNDMVllU1dveFFvZFZqS0paUTZZdWtvZ3JX?=
 =?utf-8?B?N0hYaE04bTQyRUFyS3duWnhQL0wwb01iUzFsc2FsRlQ3Ulp5WDFTVWhjSkZ0?=
 =?utf-8?B?Z0psQnpuOGU4UUo3Y2x5Q2MxcWtyQkF0eFNEa1FSR0RNMU5XWDRKaEFvMnR6?=
 =?utf-8?Q?gr685c?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR19MB3872.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(19092799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YkRIQm9sSlNqYmJZR2tsUmh5R04vNy9kM0tGQ20xV0VySysvQkpyVjhncWJV?=
 =?utf-8?B?YkF0OU1MUHN6bUgxbXh5Qm1sQzRmeVY1K1B0dGxKOURHSDlhL21vekNyMFNu?=
 =?utf-8?B?REpYaTVvOWh6bDhsRmRSL3ZpTkF3VmhENWVSbytCeEZyOWFERXBubE1EYXlZ?=
 =?utf-8?B?VWVXZjZVdG5ZUjZDd1pVajJXVWpscTVJeld5Vi9hQ3lwajFIRFQwdzN3OEpR?=
 =?utf-8?B?bDFndHExOU85SCtyOHR4cjJHdzgzV3o5UjBWU0xSTzE4R3JzOVV6S0VSYkk3?=
 =?utf-8?B?MVhzalM1REErVVk2bDJaajBLaGtNNXFpa0hBSUtwY1dKbERsMUtzdjlJNlgr?=
 =?utf-8?B?eHZNTlAxM01VM1RxR3YrVzRMdlc0d2Q0TWNESUI3NWRyVDFjQUpMN1lLOWFW?=
 =?utf-8?B?cHJicWorNG52RldueVp4YnR2Zmp2QktiRzRtMFkrNmdNalFyNE9vU0dzTExk?=
 =?utf-8?B?TFRjRUJMZ0pIcXNjTmU2d2NRSlhhcE5HSUNIVG94STZHWk9yV25SUVVSQ2R5?=
 =?utf-8?B?RW1IcGc5dFc0QkZmUUxKMGRqaFJUREg5Z1NkbFJ1ODZMSkN6NHAvOHZScnpR?=
 =?utf-8?B?SlZ4ZHhmTmlGN1o4a3Z5ZEt0cjVMemlPc3FRdFh3NmRUK0tzL09XV2kxQ3Bx?=
 =?utf-8?B?S0RLaUJ3NEhxU0FldHJWYWk5TDFRbWFBbTg3VVdQdzdSdWlTcml0TnZHV1pu?=
 =?utf-8?B?bTZjMklXN0l6ZjVlZ1hMQzNuOXM4YWFOL001QzVhYlV4cGpYRnVJNVFEZFpC?=
 =?utf-8?B?VU41aWxZYWE1S0xkV0xXWHdGd1JZVk1wZTNRVEMrNlErSXRiRGhwNzRSazRV?=
 =?utf-8?B?bkpMUVIzYnNVNDEvMWtRVkZrcG83NEVaUEcyZWZQdmE2Q3ZPcjdnK2FWMTlr?=
 =?utf-8?B?OCsrcmtEQjNhcXZxS3BjVlZuZ0VCR2ljZG1jeSs4K3p5S2lKWXgwMEE2Mk45?=
 =?utf-8?B?b053VThwV3NRY0h1QlVNQjhBLy9XbDl0bmVtdWdWdGJyWWJlSXQ2Ynk1aFpx?=
 =?utf-8?B?K2Fsb0Vwd2pjR2xjTEY0VWVMZm9PZGp0dW5xWUlUeEZWcHl5VGtuaEJGaXhS?=
 =?utf-8?B?WTFNVThVQ3l4aURsU2ptL0t6WnM0SW5vdWQxTlBmYTNCb3FUTlJxQzVmampR?=
 =?utf-8?B?QzVpRElUTlhQN2FCMVlLeFZzeU4zbENxZjZkNE4rZ3RDOHBaTm5QVjMySFls?=
 =?utf-8?B?ZERkT1pDTjRDaE81Smc4UUgwZ3RlVjE1OXVVdlpTWndlV1UwWHk3bUR2dFBy?=
 =?utf-8?B?Q3kvUTczcDNiT3p4S2VaeThnZkF0Zlp6dFpBWjBZVmdlSXZZa1FjTVBlR3NY?=
 =?utf-8?B?ZGVCYWV5THFuNWg3MjQ4Q2dvSERxb0FicVFGalJteFBjdW9jclJIRHhwY202?=
 =?utf-8?B?OE9LWC80Sjk2NEdxNkwyUWVBUEJqZVAwZC83cWxHYzdzOHhiSWRzd2Y5eitG?=
 =?utf-8?B?dHoxWnVHUXoyaVBCcC9FN0ZqRDJCNTBScHFOTjRoYU9LY0NDSUlIK1FuS2xj?=
 =?utf-8?B?S1dmKzYzRjRqNzRyNHFkZklEajIxRDhXUE1TVFI0VkR6bUNyZ0EwZkxySzl4?=
 =?utf-8?B?eGhuaDNmRFJ0T1dvNDFCbWw4WXlmUFFHaVk1V2Z6T0ZWR2pjTUVYeGhOdk5K?=
 =?utf-8?B?NmhjVkM2a3ZUT3o5Mk9kWWlQK3dKbUlmQ2pKWTQzZXp0OG92ZVQ2NTFObElq?=
 =?utf-8?B?WWYwZ21IK2F1VmM1clN4ZkxOTVhmcG1RbFlKWWg4UC9heDZhdVoyVFV0T1V3?=
 =?utf-8?B?bVNvbExsRjlvaTZBUFIyVXVOdkVmS0NQMngvV2pyNG11RlVZcHROcENCUWlr?=
 =?utf-8?B?VFhhL2pybHpUNGZzaFQwNTlCRTB4Ukltc3hJSFkyOUhPUHYxdkJhTmdpWGtY?=
 =?utf-8?B?L004ZkgzUmpaTStXSHg4MnhabjZtNCtYbkVSTzU4UU5ya1F4WGhhQnZPV0hq?=
 =?utf-8?B?a1g3VkdQN29pSEdYMEpoUk1CbFh6blRwYncxamZmNjRGZnJ4MjdmM3ZialdR?=
 =?utf-8?B?MGUxQjBpcWhXVnAwcUJOZ3B0dWxYSy9aQ0hDSEV5eUdqMHJTMXJwNEZHR3ZI?=
 =?utf-8?B?UGJPRHV5c2R1TDQzNXM1eUNHWm1tSWd4d2pCSHNZSnhNeG1xVFhrMGl3OUcz?=
 =?utf-8?B?WmdUdzY4Mi9WZE9NVEdqSis5UTZxYThUMCtJUTFFTHB0Qm1zMnVCUmIwNk4x?=
 =?utf-8?Q?lCx/83UvkV5b+iAyZpsa1kE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC650D0F4775E541A7EA1D8ADCAC585F@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BlGMRj5myFiS+AICoGn7S6LKMWKASdM7gDkQWcJWqBlUHFeYKrPpLcmuzoKD7DRrAImkUP5W/8TVXy8VAcM55QzlIZ40Qn8bOVM1R9IxE9tonG8SSQRmXHv7gbYiAGCU+P2SbpYoccrx82jF5UJQe/51D7xymnhM6rMOVvQg7dPZ1TUBkRD/0BZrL1GcgIfzhCXvh9eZL18uMvrn/q5Y3ThXD5KAjaRgSRquS1ZoXxcKBymTD15gBHP3WyJIeQnTxepO18Hbb6nQh+RB9dnh0de87fVgME3pN9p82VO/+v2f+h1ZQrGG1ekQ/gx5PwKjoNnMUztIq8+FesE2aGtHPHMO+KA2V3inqbzVmxPfvXhfJ5sXyHELgSekZ2P1vsI72B3L4zsMvQNsWAitE1V1s3I8OxFTdsR5RTPg4DkXTUhZJSTzNLat01CGsPt29M6eTLmDfjSl43G1vCeLEf9oFReQ9Zx3nChlZeqd2P/R4+fU4LvIUsMUqbfSH5T/y/VwZBP9FKdAKgvLFeadZtTNe7TGnX4TW8PVZQIZWFxZq7ktOFe9M3qs/ZEbufCHea/9PNiohm0whHfj5oV3V6DBHVWUWdx9Shi+eo/V/DgMlvQYUOko9wWdvc5yoMW4RG6rs7WHnc96Hct/h49+gxdMKw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR19MB3872.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8c297d-4eb4-41bc-5aea-08de180a2f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2025 23:15:15.6385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y/tzPPoDASkcS/WOXzRIp0w37yyNTStg78ldYMhaRGRTt2a1WBkiV/ugGlWjwI3dcDtAvcIVVS0i0rSeHCbF6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF85464422B
X-BESS-ID: 1761866117-104829-25260-19758-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.85.135
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkbm5mZAVgZQ0NzENMnYJCU10d
	jYMsXU3CDRLDnZzCDVxMQo2dIk1cJYqTYWAP5LZMRBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268593 [from 
	cloudscan19-86.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTAvMjcvMjUgMjM6MjgsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4gTW92ZSBoZWFkZXIgY29w
eWluZyB0byByaW5nIGxvZ2ljIGludG8gYSBuZXcgY29weV9oZWFkZXJfdG9fcmluZygpDQo+IGZ1
bmN0aW9uLiBUaGlzIGNvbnNvbGlkYXRlcyBlcnJvciBoYW5kbGluZy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEpvYW5uZSBLb29uZyA8am9hbm5lbGtvb25nQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBm
cy9mdXNlL2Rldl91cmluZy5jIHwgMzggKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9mdXNlL2Rldl91cmluZy5jIGIvZnMvZnVzZS9kZXZf
dXJpbmcuYw0KPiBpbmRleCA0MTU5MjRiMzQ2YzAuLmU5NGFmOTBkNGQ0NiAxMDA2NDQNCj4gLS0t
IGEvZnMvZnVzZS9kZXZfdXJpbmcuYw0KPiArKysgYi9mcy9mdXNlL2Rldl91cmluZy5jDQo+IEBA
IC01NzQsNiArNTc0LDE3IEBAIHN0YXRpYyBpbnQgZnVzZV91cmluZ19vdXRfaGVhZGVyX2hhc19l
cnIoc3RydWN0IGZ1c2Vfb3V0X2hlYWRlciAqb2gsDQo+ICAJcmV0dXJuIGVycjsNCj4gIH0NCj4g
IA0KPiArc3RhdGljIGludCBjb3B5X2hlYWRlcl90b19yaW5nKHZvaWQgX191c2VyICpyaW5nLCBj
b25zdCB2b2lkICpoZWFkZXIsDQo+ICsJCQkgICAgICAgc2l6ZV90IGhlYWRlcl9zaXplKQ0KPiAr
ew0KPiArCWlmIChjb3B5X3RvX3VzZXIocmluZywgaGVhZGVyLCBoZWFkZXJfc2l6ZSkpIHsNCj4g
KwkJcHJfaW5mb19yYXRlbGltaXRlZCgiQ29weWluZyBoZWFkZXIgdG8gcmluZyBmYWlsZWQuXG4i
KTsNCj4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9
DQo+ICsNCj4gIHN0YXRpYyBpbnQgZnVzZV91cmluZ19jb3B5X2Zyb21fcmluZyhzdHJ1Y3QgZnVz
ZV9yaW5nICpyaW5nLA0KPiAgCQkJCSAgICAgc3RydWN0IGZ1c2VfcmVxICpyZXEsDQo+ICAJCQkJ
ICAgICBzdHJ1Y3QgZnVzZV9yaW5nX2VudCAqZW50KQ0KPiBAQCAtNjM0LDEzICs2NDUsMTEgQEAg
c3RhdGljIGludCBmdXNlX3VyaW5nX2FyZ3NfdG9fcmluZyhzdHJ1Y3QgZnVzZV9yaW5nICpyaW5n
LCBzdHJ1Y3QgZnVzZV9yZXEgKnJlcSwNCj4gIAkJICogU29tZSBvcCBjb2RlIGhhdmUgdGhhdCBh
cyB6ZXJvIHNpemUuDQo+ICAJCSAqLw0KPiAgCQlpZiAoYXJncy0+aW5fYXJnc1swXS5zaXplID4g
MCkgew0KPiAtCQkJZXJyID0gY29weV90b191c2VyKCZlbnQtPmhlYWRlcnMtPm9wX2luLCBpbl9h
cmdzLT52YWx1ZSwNCj4gLQkJCQkJICAgaW5fYXJncy0+c2l6ZSk7DQo+IC0JCQlpZiAoZXJyKSB7
DQo+IC0JCQkJcHJfaW5mb19yYXRlbGltaXRlZCgNCj4gLQkJCQkJIkNvcHlpbmcgdGhlIGhlYWRl
ciBmYWlsZWQuXG4iKTsNCj4gLQkJCQlyZXR1cm4gLUVGQVVMVDsNCj4gLQkJCX0NCj4gKwkJCWVy
ciA9IGNvcHlfaGVhZGVyX3RvX3JpbmcoJmVudC0+aGVhZGVycy0+b3BfaW4sDQo+ICsJCQkJCQkg
IGluX2FyZ3MtPnZhbHVlLA0KPiArCQkJCQkJICBpbl9hcmdzLT5zaXplKTsNCj4gKwkJCWlmIChl
cnIpDQo+ICsJCQkJcmV0dXJuIGVycjsNCj4gIAkJfQ0KPiAgCQlpbl9hcmdzKys7DQo+ICAJCW51
bV9hcmdzLS07DQo+IEBAIC02NTUsOSArNjY0LDggQEAgc3RhdGljIGludCBmdXNlX3VyaW5nX2Fy
Z3NfdG9fcmluZyhzdHJ1Y3QgZnVzZV9yaW5nICpyaW5nLCBzdHJ1Y3QgZnVzZV9yZXEgKnJlcSwN
Cj4gIAl9DQo+ICANCj4gIAllbnRfaW5fb3V0LnBheWxvYWRfc3ogPSBjcy5yaW5nLmNvcGllZF9z
ejsNCj4gLQllcnIgPSBjb3B5X3RvX3VzZXIoJmVudC0+aGVhZGVycy0+cmluZ19lbnRfaW5fb3V0
LCAmZW50X2luX291dCwNCj4gLQkJCSAgIHNpemVvZihlbnRfaW5fb3V0KSk7DQo+IC0JcmV0dXJu
IGVyciA/IC1FRkFVTFQgOiAwOw0KPiArCXJldHVybiBjb3B5X2hlYWRlcl90b19yaW5nKCZlbnQt
PmhlYWRlcnMtPnJpbmdfZW50X2luX291dCwgJmVudF9pbl9vdXQsDQo+ICsJCQkJICAgc2l6ZW9m
KGVudF9pbl9vdXQpKTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGludCBmdXNlX3VyaW5nX2NvcHlf
dG9fcmluZyhzdHJ1Y3QgZnVzZV9yaW5nX2VudCAqZW50LA0KPiBAQCAtNjg2LDE0ICs2OTQsOCBA
QCBzdGF0aWMgaW50IGZ1c2VfdXJpbmdfY29weV90b19yaW5nKHN0cnVjdCBmdXNlX3JpbmdfZW50
ICplbnQsDQo+ICAJfQ0KPiAgDQo+ICAJLyogY29weSBmdXNlX2luX2hlYWRlciAqLw0KPiAtCWVy
ciA9IGNvcHlfdG9fdXNlcigmZW50LT5oZWFkZXJzLT5pbl9vdXQsICZyZXEtPmluLmgsDQo+IC0J
CQkgICBzaXplb2YocmVxLT5pbi5oKSk7DQo+IC0JaWYgKGVycikgew0KPiAtCQllcnIgPSAtRUZB
VUxUOw0KPiAtCQlyZXR1cm4gZXJyOw0KPiAtCX0NCj4gLQ0KPiAtCXJldHVybiAwOw0KPiArCXJl
dHVybiBjb3B5X2hlYWRlcl90b19yaW5nKCZlbnQtPmhlYWRlcnMtPmluX291dCwgJnJlcS0+aW4u
aCwNCj4gKwkJCQkgICBzaXplb2YocmVxLT5pbi5oKSk7DQo+ICB9DQoNClRoaXMgd2lsbCBnaXZl
IE1pa2xvcyBhIGJpdCBoZWFkYWNoZSwgYmVjYXVzZSBvZiBhIG1lcmdlIGNvbmZsaWN0IHdpdGgN
Cg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDI1MTAyMS1pby11cmluZy1maXhlcy1jb3B5
LWZpbmlzaC12MS0xLTkxM2VjZjhhYTk0NUBkZG4uY29tDQoNCkFueSBjaGFuY2UgeW91IGNvdWxk
IHJlYmFzZSB5b3VyIHNlcmllcyBvbiB0aGlzIHBhdGNoPw0KDQpUaGFua3MsDQpCZXJuZA0KDQo+
ICANCj4gIHN0YXRpYyBpbnQgZnVzZV91cmluZ19wcmVwYXJlX3NlbmQoc3RydWN0IGZ1c2Vfcmlu
Z19lbnQgKmVudCwNCg0KDQo=

