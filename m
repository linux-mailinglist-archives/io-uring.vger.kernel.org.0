Return-Path: <io-uring+bounces-10653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A468C62C50
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 08:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D55E7362ACD
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 07:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54107319603;
	Mon, 17 Nov 2025 07:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L4b72QCw"
X-Original-To: io-uring@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011026.outbound.protection.outlook.com [52.101.62.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F6430F55E;
	Mon, 17 Nov 2025 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763365116; cv=fail; b=uTuHsexlCkPu9BNk6R2rxeoT/V/edD/9jYfUsvhol+7mDsQeLNHWbs3ZwNHuh5qyNPZ1Wtv/uf6eg6GEVeb7H3jljuW4FX3cRshNqyCITxUGruc1Lgu+eDMkuihso19/qjH1L9jF6FbHl+6oAzISHj49RmMWLOGL68rCxnJZcqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763365116; c=relaxed/simple;
	bh=KfksTT9MPO7DX2djdHxphQSTBxmszsv+aWJP0tc8FF8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iOUzYLgY2m2uldsP0WenGAQtZQUZhyO/oMEN5TbWicev3o0AwhYhK2hNpBEljeQCbj/EY0F7qV6v7or2TDOG0O0km+ZPyelOWFcDxOcJEGhCTWN0FH12oVNLxjdLxGEv5acrT4f3uYF1yJp/cSmk0fIm6Ljga5SY4GmT315GUdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L4b72QCw; arc=fail smtp.client-ip=52.101.62.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OzQXuoNCdaNMamm90B6NzU6CQl2DrNPTHu/lHs//ZqgDWP7FE5cZdm2TMJyas+a0yhn2W5KeRHBsbZr4+VuXA0mIacCMLgdT1XlECE9c6+ZhDMSqnRVVDvBOxfdJIdrM3gvBXz3XtQ0dJ2CqqiIlkeM3KC89fnTqvDQw4LjNW2+rJuFkaZfmA6HgcuhlDA099txvZAy9hHoeWw/jkgWw5oum144EjbbfRS4BQXpnfyyJ2bHyh1pEJSB8G1pJj3jx2c0vTUu+B1LW0JiU2NMx/9WJHzEedn+Gp7luCiUKxwx7CtaIjwVtZM7suaPo+eB+P9i/YCXh9P4knhX0R2hMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfksTT9MPO7DX2djdHxphQSTBxmszsv+aWJP0tc8FF8=;
 b=H02BqJH0CTqGRhvmzuwa1J9XQ7pRKY4TPPrRC0SAYlYLciMrPA4Z5PE19UjgQ1AgXTEi/Q09wC5kPmUCNYw/eAcqQnasxZK8JPDK0saPT9D6LxR97Vy5083GPxEW5OcD/KY44n0yL97Q1oPeV0GaV0QEr1psoik5tr9HuHHZVyaqEIs9kBYHL755ahY3DCIJH/2DywfzSOsu6nbICWPcuJTiANM+8tEDlYjvxywJ4dfRciP21b56ofxnLPkq5XeXInvzcjQWS8P/PGe8DQfKnYrA4o/QMpp6W7/5AFjf8utKEWyzxU08hDpREqEkODpWgI4QO09aSjedvtn9pNORzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfksTT9MPO7DX2djdHxphQSTBxmszsv+aWJP0tc8FF8=;
 b=L4b72QCwuou2rEy9L/jNl7p9OCUiKSGSOiqCYcLVQRf8jk2tOZFqsyqaGnKlbLaJGDcE3RAAEpycNYOcAkX9WKFK36Dae6Ucprg7rYxlBhIGWuukNK7CYUx7BE0S4T/eiKXYwSCfPozm4O/AE03lTzL/GIWwnB/+97hB5xVLdh1l+I3JQebZRovcZmK61xQgAlKafNij84PWZ3YNrsMwHE2QNmh2Y0jRHSnDC5YWAwUITSJS7luIzJpELmD3H4bNHh7XKkgaLy59PBJpcyesRA7Yvnt+QkCYH5lNgpJQLrkVfGyp8o/bAHuVWbnq8KyacduhM+eUtqwBibnX0vJvRg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 07:38:29 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 07:38:29 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan
 Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
	<martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>, Stefan Roesch
	<shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>, "linux-mtd@lists.infradead.org"
	<linux-mtd@lists.infradead.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 10/14] fs: factor out a sync_lazytime helper
Thread-Topic: [PATCH 10/14] fs: factor out a sync_lazytime helper
Thread-Index: AQHcVTBWu7YlmtLPv06FPmR4YBj4MLT2f/MA
Date: Mon, 17 Nov 2025 07:38:29 +0000
Message-ID: <cff9dffc-dd49-45db-bc47-efab498065c4@nvidia.com>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-11-hch@lst.de>
In-Reply-To: <20251114062642.1524837-11-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|PH0PR12MB5629:EE_
x-ms-office365-filtering-correlation-id: 2264c477-119d-4bec-abca-08de25ac4d61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?azBIbG9CWkZGUFBwTGpNMDJKOGdFeWJHTEJJT1VNUHJzemxnNFlPaGt5cVdE?=
 =?utf-8?B?d3lja3p6czVBM3hsang2YmxlUHB6LzRnYnpWN2p5eWR3WldPZXlCeFdZM01R?=
 =?utf-8?B?NFZlR1h3UEVGajg5R3Y3aGhaSENKSmEyWk9HcDBSTGk4OVZ5MHdScnA2U1B1?=
 =?utf-8?B?cEV1UXlab1RwK2tkRXRrWU9uV2VHdDhueUxUS0s2c1BGSERKTFhKUW9DcFhK?=
 =?utf-8?B?UUUvb2hwd1BFWnMrVGw3SUhUSGVIbmVVdmpMSkJWY2pnQno5Y0t2bVZBZTBU?=
 =?utf-8?B?Y0tjNFVON1JVT3ZEVS9nSldxUUZHVEk0ZkJiSFJWZU9PVlQ4aldJaDJmeS9R?=
 =?utf-8?B?VGhKSFJJR1A3clVCN3R0WWdZOGRvZnFING1FSFUvUDV1dW1KSWFvZXFSRC92?=
 =?utf-8?B?aXJ1UjRXc2lPcTc3N3B0VjI3eURZMklQUE42R2lKa3N6V3VlbWpycWZ5YUxt?=
 =?utf-8?B?MGtORWQ1ZExDdk5rb0hhNGV5VWluQTNEcWpNVG1qME9GUGtlQkRHQmk0enJm?=
 =?utf-8?B?UTlFVWpmY09hMW5oaVFZdlBzdEFYTVBsamhmTHZkL2FmQWV3a29xR09ISXpK?=
 =?utf-8?B?Qm5CQlh1eHN1elFQNjJKbzlqdlpCVTFUa2hNQ1lpdUZmVDhkMWYzRHRlbnVl?=
 =?utf-8?B?M2d1eU90MitpTHZjMGNTbVFFazlNT2lOYUgyYnZXT2pheFQ5SzFhRVR5NGRk?=
 =?utf-8?B?ZkVvMDBHcUgzMzNaWVRTUzdBdk5rNWx1NWsvVTNZS0pvV2t6N2VOb3I2WkxG?=
 =?utf-8?B?MGVDMjlzU0hYSTBpQzZUdHM3UVVPVWNVRDVFckI4OGp2VEkzZ2VRWldueUY2?=
 =?utf-8?B?bHhySjF1SUVObEhEOEI4b3RGN0VmWFN2UEpUczBsK1FVMEpuR2hZTGswRVcy?=
 =?utf-8?B?UE9JcDBZRS9lYVBESUc3ZlF5K004R3R1ajRUbWFUa3JqOFhKZk0rZ2VDbnZX?=
 =?utf-8?B?aEJaTFFIZFZ2K1U1ZTBNT05JMG5IQVF0MWF6T29EMDZob2g2cmFWWGhTUUdF?=
 =?utf-8?B?V3ZDaDNxNTBMSHQrSUtEZldzdUtrQlpvaVkwZVJqNllSbHcrMWhmaUs3dCtu?=
 =?utf-8?B?d3VjUlNYWWhRblBScmVRVHRsNy9NVFkyQkhsVU5pL3FzaXJyaFlKZHZheXlM?=
 =?utf-8?B?bUpHbW1HN1laNDBYQTBJVHdjMCtPdzBuc1YrYTBsS3cvT21IcGVyRi9wTnIw?=
 =?utf-8?B?SkhMYlVWRkZFWjBPY2NWUUxuc05QUFVJQk9NanVNbE5Xa2htbFJvTWp1WVlO?=
 =?utf-8?B?VENxSE5uS3lzci9BbXcxeEltMnJla0YxTnpyc2JCYlJmZDBtYkVPdnp6a2J5?=
 =?utf-8?B?WFdUYzBRdHBkbjJzQkFUa0dqYnIrdzVhVjNmc3NpVFROc0Ywai91dzhyRENv?=
 =?utf-8?B?aWtubmp1emc5Nnc0R3puYmVVZzRLaHA2ZUZPOTgzL3RVaHBHZlpuZ01KaFRI?=
 =?utf-8?B?WHhDbi9wR0NlK1luRGlCZzQ5SC9sNWRVcHZjL1VLZFB6T3dCVHpJd2s0ZlNz?=
 =?utf-8?B?dk9pTmRSamEybGpyMDFoN0tmaXRaZ3VkYURZMnRNSWlsSXpzTkQ3aU5nditw?=
 =?utf-8?B?NXBHT3JWRGY5YjByRy9XMmt3QjdPZWRNYVlWeHRwSjZidWtZNWdOUEd3WnhW?=
 =?utf-8?B?STE2M3pUeStrZ0srVG1WZEQvTHQ3dXFTY1pESFI3cTlMUWczVzJSNERNQ0c0?=
 =?utf-8?B?d0M2dU4zdk5XWE5HNWdYSHRoMDl5MkU3QjVJMkMvbXBnZGFaMlMxRTdlcW9O?=
 =?utf-8?B?K29wR1lqVDFHSUhVOHVSc053T2pQc0lOMEdCemx3K2JMQytXTm1GR2F1VjFu?=
 =?utf-8?B?NHo3eWlua05JblRkNGpIUUF4cUFRYjZUU2txN3FPdGRCU0tUT1J2WTR1Qkxl?=
 =?utf-8?B?d3ZLTmJmTEhwMCt6eGc5RW5xd3Y5U0hpZ1Y1YTFYUnlsMEJUd1BOZ0c5TkYv?=
 =?utf-8?B?ZGJxZ3E3NE5NMUFPUHRZVEJYejNVaHhMNVJSck9MbUZxYnI3TWJtNHZkS0FG?=
 =?utf-8?B?cnd5T1ZLTUF0cFA1RkcvSGQ4cDNOQmwzU0FuK1lvb3dPdTh2MERrU1FlVG16?=
 =?utf-8?Q?v/RTEo?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TGg4Tk03OU5ZUnRxd0ZFVUZ0WHpxaGVzL1h1R1BHTy9nei9TcVBucm50R3h1?=
 =?utf-8?B?L2t3ZkRMV2tVSHgrWXdpbzVUME8vODBSYmZkV04vdlRPbVQvZG4ydGJvRVZ3?=
 =?utf-8?B?U3NsZlkrVEFaY1V0d2JtNHZ6MGRPWjJDRGZPblZpdzRkb01SUXVjb25tR1FC?=
 =?utf-8?B?anozSFYzNUljRTRoODIxRElvZFJRSlFJOUNWRnllV2U5eFBVVjhaRnRZSUp0?=
 =?utf-8?B?WUczY2QwK2FNaGdQNTkzbUZPbjF1THd6VmtTVEhKWjlZQ0FmdFd2MWNoTks0?=
 =?utf-8?B?dHFQd0pxRituSXNRbTZmUEY5REpXTW4wekl1RGdKYWhCeWYxQ0JhMEVTR1Mw?=
 =?utf-8?B?SUV3VmpxZEtUZnJpQ2Y1VG5PblEybWNaQU9oS0trYXI1M3EzRm9SVHRuZUZE?=
 =?utf-8?B?c0NyeDBlK0VoQXM4V3dtSFU5Q1UveHNjZ1pacUN4UHlzK0dkcVdid3dRK1g3?=
 =?utf-8?B?YmI4NWgyV1o4UU9ZUDdzcEtQVmcvT2c2aUFyZUp5K1JWbHNRTFRqR0pTdUZ1?=
 =?utf-8?B?V0tzYW1ySTlEMVNVQ3RtaFVDeDR3bDdyVEtTN0ZmQmlId1dmOWtBQ1diTkdr?=
 =?utf-8?B?R0xhMVRqbDk5cFl1L2ZPNzFBeE5hUjdkMlJkUC9qTE1HRmhQYllxRHI3Mlpv?=
 =?utf-8?B?WGpBM3B4OUt0bDFpN2pXTW5RRWh6VHlvRzNHYjB1N3ErV2hCNTJIRDh3VWlH?=
 =?utf-8?B?TkFwZDlMQ3ZhWGFCZ1AyY0c1ZnVKaVpHZ1MrYlhmV3RGYTlOQWROazdBQ1A4?=
 =?utf-8?B?a1F5NlZqdXBoMDJra25ndHhxRWpSdkw3cm9GU2dzc1d0VTBpWjFOU0tXbFc1?=
 =?utf-8?B?bWIrdUdoaTJFdU0yazJjQisxb0dodDl3RGQ5T2JLTGd5M0dUZm5iN05KMHNx?=
 =?utf-8?B?R2lMaGFuVVJPc3c3OWRmL0VaK3JRdnFlSERVcXA2d1AybzFPSy9GT3FuNkNp?=
 =?utf-8?B?eS9SY25GUVRSRW1IUzloR1cwMHlUVmhwUTJVZjllNWlhYlhHVnMxRmxENDJ5?=
 =?utf-8?B?QVlacHp4QjJwOEJIR2FKcWZyL0JadGJqZFAzdUNRb0MrSzlOSDVnaVVRcGVG?=
 =?utf-8?B?YzFvSnpGQ1FPM2w5cWJOU0x5Y3JxWDBTMytEaXgwQmh1cmV1TUd2L29qdHhT?=
 =?utf-8?B?d2xJY2VHMmxOOTlNWmhzck1SOHdvYVNvQ0haRldMa2N4aWh5TkplZFpnRUtR?=
 =?utf-8?B?YTFkRnNZMm8zY0RqeUxBV051djA0T2RCbWgwZlFzckF5eHpaaHFBOTk4ei9D?=
 =?utf-8?B?R01BbnFVSFNCYW1wRHluYTJ4bno5cVNwcXNXQWllbDNZZEdFZlJzbE9OS3hM?=
 =?utf-8?B?Y3p0YW9Xb0p3NlRha25wZFhxMWcwN3JpS0hhT3VnYXNoOCs2UTdYbTFZQ3Qx?=
 =?utf-8?B?VEdPWlBpNWJGY1B4TXo2cDI4Mkg4aHJySyt4R09IMmxZZXFXd2FjekhoYU51?=
 =?utf-8?B?eGhvWXZGYnAvbGhSMGp0YUNkUTlOVXNPQXExM2RSejg3bC9INTRrOEp5N0k4?=
 =?utf-8?B?ei9NbzBpYzZFUVc0UEtGQmFBdVpyUTZ3eGFidVFhVEM2NVNwRjVBOVFvQlpp?=
 =?utf-8?B?RU03N0lqUlp2NWNHT3g3T29xWDlOZGsyaFk1RzVtYWFmT1UzY0ZlQUMzRUY3?=
 =?utf-8?B?bjZWaVJxTWFCd1huVkU0Q1BPOUxMSEtUWndwYWlUNEo0cVhEc0NwZ2lkY0RN?=
 =?utf-8?B?enE3Sjg4RlNNdGkxY01FMUJBZTdlNm9FYzQweW5CdGNkYmRPWG9qMnB4MGdz?=
 =?utf-8?B?Kzk3a012VzhhOVZ2ZGpMeE5zNjNkTXZhQlBNdVZnU2F2anJXcU1KUkZGSTQw?=
 =?utf-8?B?bURxOFlONityTmJoTGZLb09jd3U3aTNwSE5yZmpYQTQ3bVZSSjBIVkZwUlo3?=
 =?utf-8?B?YU5QQ09Pb0JjOWRCK0ZzZ0hkNTJDMDQyMStqMGdoUHhEaXkwM0tOdkVLcCtl?=
 =?utf-8?B?S1BiMzBGd3RwQ2NYWGp5YmlUaXU5UTl6ampmdFJUTWJWRlBsc1ErTGlRK3dG?=
 =?utf-8?B?SkNzQnIvc2h3YVBwVW9FcmNJOW5tMGdzRW9XcmJPV0FDckhTdXcvbU9ST3JH?=
 =?utf-8?B?QTJJcGpqUWZaUGppbWU1T1ArRC8zb1ZIaWkzMkZWSWpZcC9SS3FvcENtTzkx?=
 =?utf-8?B?eG84SGF3NTVLUU1FOXRZdWRMMTVJRm9oT2pGSnczWFlVTlpyLzE5SzFlb0lR?=
 =?utf-8?Q?AK7wbHJjcYnBj09HyuMN3Z99tuEsvu3oHVQQVrr+sJRJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58D8676D718B754184FF7E052797999D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2264c477-119d-4bec-abca-08de25ac4d61
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 07:38:29.5688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KogLpJ8/3aX8Av8x2dCpA5ir74sA8SBSq6HZbZy1cc8CIu0glsVd2Pm/6b/LmR7ZSo/V8ibVrc8yy535SZs2BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5629

T24gMTEvMTMvMjUgMjI6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBDZW50cmFsaXpl
IGhvdyB3ZSBzeW5jaHJvbml6ZSBhIGxhenl0aW1lIHVwZGF0ZSBpbnRvIHRoZSBhY3R1YWwgb24t
ZGlzaw0KPiB0aW1lc3RhbXAgaW50byBhIHNpbmdsZSBoZWxwZXIuDQo+DQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gICBmcy9mcy13cml0
ZWJhY2suYyAgICAgICAgICAgICAgICB8IDI3ICsrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQ0K
PiAgIGZzL2lub2RlLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDUgKy0tLS0NCj4gICBmcy9p
bnRlcm5hbC5oICAgICAgICAgICAgICAgICAgICB8ICAzICsrLQ0KPiAgIGZzL3N5bmMuYyAgICAg
ICAgICAgICAgICAgICAgICAgIHwgIDQgKystLQ0KPiAgIGluY2x1ZGUvdHJhY2UvZXZlbnRzL3dy
aXRlYmFjay5oIHwgIDYgLS0tLS0tDQo+ICAgNSBmaWxlcyBjaGFuZ2VkLCAyMiBpbnNlcnRpb25z
KCspLCAyMyBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2ZzL2ZzLXdyaXRlYmFjay5j
IGIvZnMvZnMtd3JpdGViYWNrLmMNCj4gaW5kZXggOTMwNjk3ZjM5MTUzLi5hZTZkMWYxY2NjNzEg
MTAwNjQ0DQo+IC0tLSBhL2ZzL2ZzLXdyaXRlYmFjay5jDQo+ICsrKyBiL2ZzL2ZzLXdyaXRlYmFj
ay5jDQo+IEBAIC0xNjkzLDYgKzE2OTMsMTYgQEAgc3RhdGljIHZvaWQgcmVxdWV1ZV9pbm9kZShz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgYmRpX3dyaXRlYmFjayAqd2IsDQo+ICAgCX0NCj4g
ICB9DQo+ICAgDQo+ICtib29sIHN5bmNfbGF6eXRpbWUoc3RydWN0IGlub2RlICppbm9kZSkNCj4g
K3sNCj4gKwlpZiAoIShpbm9kZS0+aV9zdGF0ZSAmIElfRElSVFlfVElNRSkpDQo+ICsJCXJldHVy
biBmYWxzZTsNCj4gKw0KPiArCXRyYWNlX3dyaXRlYmFja19sYXp5dGltZShpbm9kZSk7DQo+ICsJ
bWFya19pbm9kZV9kaXJ0eV9zeW5jKGlub2RlKTsNCj4gKwlyZXR1cm4gZmFsc2U7DQo+ICt9DQo+
ICsNCg0KVGhpcyBzeW5jX2xhenl0aW1lKCkgd2lsbCBhbHdheXMgcmV0dXJuIGZhbHNlID8NCnNo
b3VsZG4ndCB0aGlzIGJlIHJldHVybmluZyB0cnVlIGF0IHNvbWV0aW1lIGlmIG5vdCB0aGVuIHdo
eSBub3QNCmNoYW5nZSByZXR1cm4gdHlwZSB0byB2b2lkID8NCg0KcmV0dXJuaW5nIHNhbWUgdmFs
dWUgZG9lc24ndCBhZGQgYW55IHZhbHVlIGhlcmUgLi4NCg0KPiAgIC8qDQo+ICAgICogV3JpdGUg
b3V0IGFuIGlub2RlIGFuZCBpdHMgZGlydHkgcGFnZXMgKG9yIHNvbWUgb2YgaXRzIGRpcnR5IHBh
Z2VzLCBkZXBlbmRpbmcNCj4gICAgKiBvbiBAd2JjLT5ucl90b193cml0ZSksIGFuZCBjbGVhciB0
aGUgcmVsZXZhbnQgZGlydHkgZmxhZ3MgZnJvbSBpX3N0YXRlLg0KPiBAQCAtMTczMiwxNyArMTc0
MiwxNCBAQCBfX3dyaXRlYmFja19zaW5nbGVfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IHdyaXRlYmFja19jb250cm9sICp3YmMpDQo+ICAgCX0NCj4gICANCj4gICAJLyoNCj4gLQkg
KiBJZiB0aGUgaW5vZGUgaGFzIGRpcnR5IHRpbWVzdGFtcHMgYW5kIHdlIG5lZWQgdG8gd3JpdGUg
dGhlbSwgY2FsbA0KPiAtCSAqIG1hcmtfaW5vZGVfZGlydHlfc3luYygpIHRvIG5vdGlmeSB0aGUg
ZmlsZXN5c3RlbSBhYm91dCBpdCBhbmQgdG8NCj4gLQkgKiBjaGFuZ2UgSV9ESVJUWV9USU1FIGlu
dG8gSV9ESVJUWV9TWU5DLg0KPiArCSAqIEZvciBkYXRhIGludGVncml0eSB3cml0ZWJhY2ssIG9y
IHdoZW4gdGhlIGRpcnR5IGludGVydmFsIGV4cGlyZWQsDQo+ICsJICogYXNrIHRoZSBmaWxlIHN5
c3RlbSB0byBwcm9wYWdhdGEgbGF6eSB0aW1lc3RhbXAgdXBkYXRlcyBpbnRvIHJlYWwNCj4gKwkg
KiBkaXJ0eSBzdGF0ZS4NCj4gICAJICovDQo+IC0JaWYgKChpbm9kZS0+aV9zdGF0ZSAmIElfRElS
VFlfVElNRSkgJiYNCj4gLQkgICAgKHdiYy0+c3luY19tb2RlID09IFdCX1NZTkNfQUxMIHx8DQo+
IC0JICAgICB0aW1lX2FmdGVyKGppZmZpZXMsIGlub2RlLT5kaXJ0aWVkX3RpbWVfd2hlbiArDQo+
IC0JCQlkaXJ0eXRpbWVfZXhwaXJlX2ludGVydmFsICogSFopKSkgew0KPiAtCQl0cmFjZV93cml0
ZWJhY2tfbGF6eXRpbWUoaW5vZGUpOw0KPiAtCQltYXJrX2lub2RlX2RpcnR5X3N5bmMoaW5vZGUp
Ow0KPiAtCX0NCj4gKwlpZiAod2JjLT5zeW5jX21vZGUgPT0gV0JfU1lOQ19BTEwgfHwNCj4gKwkg
ICAgdGltZV9hZnRlcihqaWZmaWVzLCBpbm9kZS0+ZGlydGllZF90aW1lX3doZW4gKw0KPiArCQkJ
ZGlydHl0aW1lX2V4cGlyZV9pbnRlcnZhbCAqIEhaKSkNCj4gKwkJc3luY19sYXp5dGltZShpbm9k
ZSk7DQo+ICAgDQo+ICAgCS8qDQo+ICAgCSAqIEdldCBhbmQgY2xlYXIgdGhlIGRpcnR5IGZsYWdz
IGZyb20gaV9zdGF0ZS4gIFRoaXMgbmVlZHMgdG8gYmUgZG9uZQ0KPiBkaWZmIC0tZ2l0IGEvZnMv
aW5vZGUuYyBiL2ZzL2lub2RlLmMNCj4gaW5kZXggNTU5Y2U1YzA3MTg4Li4zNGQ1NzJjOTkzMTMg
MTAwNjQ0DQo+IC0tLSBhL2ZzL2lub2RlLmMNCj4gKysrIGIvZnMvaW5vZGUuYw0KPiBAQCAtMTk0
MiwxMSArMTk0Miw4IEBAIHZvaWQgaXB1dChzdHJ1Y3QgaW5vZGUgKmlub2RlKQ0KPiAgIAlpZiAo
YXRvbWljX2FkZF91bmxlc3MoJmlub2RlLT5pX2NvdW50LCAtMSwgMSkpDQo+ICAgCQlyZXR1cm47
DQo+ICAgDQo+IC0JaWYgKChpbm9kZS0+aV9zdGF0ZSAmIElfRElSVFlfVElNRSkgJiYgaW5vZGUt
PmlfbmxpbmspIHsNCj4gLQkJdHJhY2Vfd3JpdGViYWNrX2xhenl0aW1lX2lwdXQoaW5vZGUpOw0K
PiAtCQltYXJrX2lub2RlX2RpcnR5X3N5bmMoaW5vZGUpOw0KPiArCWlmIChpbm9kZS0+aV9ubGlu
ayAmJiBzeW5jX2xhenl0aW1lKGlub2RlKSkNCg0Kc2luY2Ugc3luY19sYXp5dGltZSgpIGlzIGFs
d2F5cyByZXR1cm5pbmcgZmFsc2UgZ290byBiZWxvdyB3aWxsDQpuZXZlciBleGVjdXRlID8gd2hp
Y2ggbWFrZXMgZm9sbG93aW5nIGdvdG8gZGVhZCBjb2RlIGluIHRoaXMgcGF0Y2ggPw0KDQoNCm90
aGVyd2lzZSwgbG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8
a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==

