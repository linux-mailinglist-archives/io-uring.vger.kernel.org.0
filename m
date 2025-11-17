Return-Path: <io-uring+bounces-10654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E58EC62CE6
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 08:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C5DF3B3179
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 07:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EB3321437;
	Mon, 17 Nov 2025 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hvK8+zoy"
X-Original-To: io-uring@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABA531A7E6;
	Mon, 17 Nov 2025 07:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763365844; cv=fail; b=sEVyXyEaWAuIR4zjkMvkOk4WySx96yRxJZN3rPrGQCTLU4bqwwp3F9qvqmAHT86gK3IMG/p3KNTXpnOnkIFAIGYKQfTYXsyoHTpZEoQni3LDvnGxrgybViWVS80Eh9s9DzyHo0eshkJBJd392sR0mtewgzRr+bv8qzlYOYzcXS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763365844; c=relaxed/simple;
	bh=H/QZNWwgyFrCjdBD6cnuu0jW2iPQRa87idIB3yC/hn4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=prs/7A3F7upMqlV/YEB4OH/628gAzcdRSoL6oRSTH6jhERrem1LPVFO3/xhF2zb59KtLQx0Xk9kPPcQ+veqFhnML6GoZ7PcvAQC67S8wp1QdMuuBUTefK+QVvVrahPgTjeSFc4Oz0wgeYdk4GL3RRQhoDXvJHr6IuhB4zaId9pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hvK8+zoy; arc=fail smtp.client-ip=52.101.53.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LeZSa0Cxe4yZBJdMYM2n/gkb7KB2/sVsyORjji7JSG5tq6iJL6tWvwe+RtGLOEyzgY18JS/EIimc9lUBIhs8r6U3OlUu82/nkOemlWJFMIHJeMZ4kWUdON+DLXYWlL0Hz5joic63mevVYBDzTbLOtgyGdpc1KxF3aks0KbnsfZNxcRMdFt0DXjcDyfPyyj/OyJsBRzEtW55lWNXDlOekkglWlW67WHhpUpAB9wNGFLtuSSfEVfLElc9AUBbic2Uz3hNgY35ngXyay/a5yoBrIHcWVVMjKZUpAG6PUeEbcnMIZL558WGwxU3mmLIQAdkR7LfculxwOkOuaHbRotzttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/QZNWwgyFrCjdBD6cnuu0jW2iPQRa87idIB3yC/hn4=;
 b=mqRft+xdzOfy2/i/0WD2KU2eV7eQyBShROLv5t5wyjgNOgmqUHcXJujHbuDmq+h4G1p7Sa+DBj5m7rxrTZhQNjkdtUQmz/xrlbulzIaJG7YmiYjnU0StUrtweEdeurTIu2SxFDKNIc+kZTAgGeXQRcEnBTW5BEEgC7xJewScxkVeQ5h+3hfJkQtBwoWcKrggno3JLoBpbf9BUXO7cjhibUrrJNLW15Adc4yp2iIo7aYkJRek9dAoD6XZyHuLSgTrycrJwlMFiEZ5X9gDfBzeuoIv/4Sv2kEJdvLQ0772wr7/WfgqN+Su8igMpOaJMeMJI+hyqGh7NILdxzMAErMyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/QZNWwgyFrCjdBD6cnuu0jW2iPQRa87idIB3yC/hn4=;
 b=hvK8+zoyQBPdWARsfnIYylQ/lV6a43mJroj886+kzA44MKhjA4GMi9OQ/mwCVhs8tKMSC8DgOREeOAl7/aZ4CDexnDqkOdkYkxII+1OM/MFO1HZl56Q9J2KNryTwbW6yoiC9e6IClewbR06jg07fMo7mVaGzzwNwfNmIdcAkgzX+Q47hm3/Hd4kWTSK6zaL0MyUzm/EnVnsmZEA5qdllJd1d/S+oFCo+YGlAGn3S/Z1zJmAuE3D9IAR69pGlbFB9DbkrglBFDtzqN8Bn5iPq/4usdCEv11Uhnv5YwFk/epxi6CvgtHialf++GItlrVJcEDfhO8WGjgJVnUk3i0lgwQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SA1PR12MB7152.namprd12.prod.outlook.com (2603:10b6:806:2b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Mon, 17 Nov
 2025 07:50:39 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 07:50:38 +0000
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
Subject: Re: [PATCH 11/14] fs: add a ->sync_lazytime method
Thread-Topic: [PATCH 11/14] fs: add a ->sync_lazytime method
Thread-Index: AQHcVTDviPep/5c710KCD/va/1nG0bT2g1gA
Date: Mon, 17 Nov 2025 07:50:38 +0000
Message-ID: <47527262-c79b-43da-ad72-f52474c2cf30@nvidia.com>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-12-hch@lst.de>
In-Reply-To: <20251114062642.1524837-12-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SA1PR12MB7152:EE_
x-ms-office365-filtering-correlation-id: 796a1a89-e520-4f86-d70e-08de25ae000d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OEVmQm5GVzZYYUlTNnBFZXBxVHYwU2l6enQ2dmRscGNOeklpcWtTdHF6QUlu?=
 =?utf-8?B?aW91OFFUWVNjNW5ZUG1jeVE0Z3NxOXhCWEpncGowbmZCNWVTeHlMR202d2hB?=
 =?utf-8?B?Si95TWJBVnRrWjU4RVpBS3RadTRxa29QRmxNd0ppZGt5aGNlTFNUTW82MVlQ?=
 =?utf-8?B?M1lEZ2cwWGk4bFc2a2drbjJMVFo5SDRUU2UxcmkvZWM2ajFyQThLT3R4dWQ4?=
 =?utf-8?B?NkdTZXJmK3huREVVaU1wejBEK0t6VXExMnA5dGtZYURpNzhZNW1ZeGdhdUQw?=
 =?utf-8?B?NnUzYzQrRTFRUGtaQjFrbzY1VEZmdlQwV2R5RGczL2RBTDNwVnRCNkVSZVlr?=
 =?utf-8?B?UnN6TG8wYlQvbG1YYjJxWTlPeFFQelFkUGZUZjhJcTA5V2JKb24xMmd2dTVE?=
 =?utf-8?B?bjk0TExUbGV0NmNJN0FPUHdId1ZvNUQ1VFF1ZkxpaFJVKzFZcG5xMzdJQUxr?=
 =?utf-8?B?K3pBK3R4empDcmsxVk1QZk9DZngvK1ZacjdlTUxoZWtPU0YxL1dxYzc4dUZP?=
 =?utf-8?B?TXNJSVlLaFlGQldKN0pvbnR4VlZNT2EvQWhMZitxeFRsMXlpd0RubWsrQTNR?=
 =?utf-8?B?L0FKWTNjZ1pnRVNjZkFielRodzBEcFErK3VZNlBYU1NYaHgvVUYzNE9hSC9i?=
 =?utf-8?B?MHFsNE5xWFFidmxEOTVGZG1xcVlONHZmUUM5a2RvckpjaFAxVG9sQndPVUZ5?=
 =?utf-8?B?SUFDQllpL1Yrd243cGVxVlZvbFM5TUs3VnJYY2xWek4raVN5YnNIUFdOV0tU?=
 =?utf-8?B?L1Bpc0NiVTRTZUI0cVRJcVkzWEFIT2N5dTVlUkVtVlpyTGk2ZFVYVVV6Tlh2?=
 =?utf-8?B?cjlRT25yZ3Ewb2ZIckZpaTNzRFgwbE9ZUzR0Wk9GT0Q1ODh0cXhSam05dDZD?=
 =?utf-8?B?dmh4NGZndTBQMGdFbTZQNklTUjlLcFBNc2cvSGd2VXZlcVFjRWVMdG00aE5Q?=
 =?utf-8?B?cEJXdjlDVlhHbG5ubUtIeTJmS013T2JGUS8zc0RaUUJldDZ1VllrcW1CWXhq?=
 =?utf-8?B?WjVrWkpkaFB3MXB2STM5T003bkhyeU9Fa1VSVVFjNTNTSTJmU1JpZ05pZ1F5?=
 =?utf-8?B?YjlUbFdveWo2aDRuQXFYT2pKNEJtVytzNHMrMWFGcXhrQWJ5eU50clR4WWZW?=
 =?utf-8?B?ckFCSC9IeXlVeGxZcjZPeHNNYXV2VUFSeDlpVE9mTkFVVnJhUUhIRGJGalRM?=
 =?utf-8?B?bjBGNkhVRXluN2hLamxnL0pHUyt0M0UremFZNWVpeXkyZ1pTSVBqM01JYURD?=
 =?utf-8?B?dkhZNXhJZVpXcVVHV2pXdVpUWGJtZXZINEk4V0tQV0J3d2wrZ3l5d1JEam4w?=
 =?utf-8?B?U2Z3NnBLOXRVemEzTVNPdTlybVh3MTVMWk5hT1dycitubkFla3ZhZk9NSW9h?=
 =?utf-8?B?SDZQTnMyVmcyMTFURGZSZktYb1FhbmRqY3JWdTVhT200ekdUN2lHUVhpaFRZ?=
 =?utf-8?B?YU9aYVlCbGdrSEVRTTFOWEdEanNXYWJTTXZ5aTR4cFlHNHNSOVFwNmRpOUxK?=
 =?utf-8?B?cVdINGY5WTRuV0M5K1lqWHZQMW1DL1JpaUhEeCtkd0hjNzRhMTEzNjZ4VENO?=
 =?utf-8?B?UVZIdGlPZmNpWllHa2pKODBrVUdWS0NZN0lORmh4dGFKQTFhMTlBc1dDekho?=
 =?utf-8?B?MktJV0VTS01Bbzd5czk2S09TMDYvSGZnR0ZjLytvNzZLZ252YjEvQUEyUXVC?=
 =?utf-8?B?S3grdG5WZkM3YjZCcFMyazlHTkduVnB2TXd2NXgvMzNGTFlmQ3ZxOUZmMFln?=
 =?utf-8?B?azV5M255QUppUWJZQURTYmVwVDB4Y1hvdFBVRFNLbVp4QjRZUU5rcmxsckRX?=
 =?utf-8?B?dmdRU1RrOEd4dkI1NFN1NWtHSTlFcmtEeEk2dyszbVhqN0xkcTZTb3krLzVo?=
 =?utf-8?B?M21iaTYwbWpDT0k2d3JRbnJlSEo2MEluWUVkRi9oVEZKZ1NiT2pmWjNxYjFL?=
 =?utf-8?B?SktGd1AxcitPKzB4MkduZWswcGQyelBqYmJUMTVKN1NON24xYStjWlBSMnZP?=
 =?utf-8?B?aUhJb09zTFI0cGdidU9rdjBIR0lCanZnSEV6SExoVlIzYTV5cWlESE9jL3lN?=
 =?utf-8?Q?9megtH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3VUTGlLdzZtb3FBc1gvZUZaMUpOTDRYUXFvUkpwUDlmT29hYU01ajJObkdL?=
 =?utf-8?B?a0ZqQjFCWWxWV1lkck5lL2hzcmU3bGVLWEwrbGlBOGl2bE9sYWVoUjFVUFBu?=
 =?utf-8?B?NGJCOE50OW5SWnExQ3A2RlN4Qk1yUkJPWTFZQmFMTGZaNUZwdUgraGJEKy9s?=
 =?utf-8?B?eWdnd0JobFFRYTIvTnkvNXp6cWtCbFhRQjc4V292bzFuQ0c2dE1ldVQyN2E5?=
 =?utf-8?B?QlRmemtERnBFdUx4YTNaaXY3RW93WmpXVDRrc0xzU3ZsNm9PaFRtZnY2R1hC?=
 =?utf-8?B?ZkRKa01xRFhUVndocXRud0dVaWZSaUY2N2pkWkF5MXJHMkxTV2h6aGlyUVdo?=
 =?utf-8?B?SWtvM2lUa2ZxS3VQWWdXaTUyUFV6KzdYRlBMaTRkc3RtMFNRS2NVK2d1K0Rw?=
 =?utf-8?B?UHNoOURDWDAxVFRkeFBlQkxZa3o1TUc3NjA4ai9aaFV2KzFLTGM1UVdTUlZS?=
 =?utf-8?B?ZlJQR0lXRHVkK2F3WFlHNXhDL1U5M0YwUTFVbWI3eENYd0Y2ajBtaUNCV3Iz?=
 =?utf-8?B?ZUdtTVY2UUJnSmdRMGZ6Ymp5UnJvaXArb1Q3V2M1dHA2OXFEaE92N01ZZytr?=
 =?utf-8?B?bWtES1Q1dkR3MTB1K1FYQVB4MHFhc1BHZUFqM1RORnZlbTUreHl3Ri8za21M?=
 =?utf-8?B?c1hwMEZmYU80S1MvM2JSQ0RCWGhqbUtpcnFkK0p1T2Z4QUMrd0lJVnFDdFlJ?=
 =?utf-8?B?QkkvbnN4dGFXYW12NERNMDFFZERWb0ZSeDZWTVJoUS8zaDRTR281T2VCTm1R?=
 =?utf-8?B?Mm5JZlBxb1gySHlOUjlGWVBVMk50MGFoUUtSVUVJdndhcyt2eU1IRHBoTHVI?=
 =?utf-8?B?aUZrVm5VK2ZndytGd2lUdXk2WUVBVjhMWXNQNU1qZk1MUU5waXVWZXhqcTAw?=
 =?utf-8?B?MWxBRUp5T2VTNXZEbjEwUlBHdktMZ1ptYlArTW9VNkk2eTlvNWxwcm1mbjVy?=
 =?utf-8?B?V2tNZzIxYTZ0dWt3ZFlMNnZYdUhQY29nTlZiNGFpYzBVNUxyMXZVZXdWaXZM?=
 =?utf-8?B?QlJwbFVNM3BrR2YzVXJIcStJV2tuUlREUTBFTTNuOU05WktsdEFXajV1eHkv?=
 =?utf-8?B?bmtScWdYcnpERXdJTlBhNk9VVk95UHcrN29EMVY3dEVHNEJ3UUp2dnhFdUsr?=
 =?utf-8?B?OU01bzR6R3dYeVNrM2l2K2NqT1hzWlFyWkN1YytVSFVwZnk2QVpRVGlMa0dV?=
 =?utf-8?B?RS85Ti9GaUgrSXljT2pGMG01U3c1KzJMdzVPOGFtdnNGTm82NndWQmJUWWpi?=
 =?utf-8?B?RUNMR0ZEUzFSK21GYjBLTnJYQlo5YTQyZUYvWkVuOE1HbGNmNXNFTWZWVm96?=
 =?utf-8?B?NTBIaUt6MTdsZ2kxSUdjVXBTa3hmeUUxQVV6Nk90WVVjbmg0Q29DUWoyWWtZ?=
 =?utf-8?B?U2hZOGFwdWh6ODluSS9RaFc5dVBoOWZsNHpOYTVpcUJBdnJKWUozTEtDN2xB?=
 =?utf-8?B?RXJiSldlY1VTRk1hV1FXWkQ2Q0NCWXJyN0hsNklRbkpXUjRpT3VSYUQvVG1t?=
 =?utf-8?B?YytIUUpOYnlWczQydU1BaW92YzFudzhOcWJLa1NkQ1hyT2VETmh0Y3hUNnh4?=
 =?utf-8?B?NEZUZ2lQbDR2VnROS1o5NUVRdnB5dnFHUElsOXRPOTM2TTZrQ01sT1lpS0V2?=
 =?utf-8?B?emZoeVZUT3R1c3NURlErcG1OSGxMdjVFbVhoUis4SlhBY1ZFSDNRcHpzV3Zl?=
 =?utf-8?B?U2pkMU1UT1duNzY3UUtLSEMyaXZWNjBUKytid2dSTnY3YzViazRWaWM1eEdk?=
 =?utf-8?B?QnpMQm1xQ2dkQmFkcTRGaEs2Q3VnVnViUUVDU0tIazFCWURSbVB2ZUtaUEpL?=
 =?utf-8?B?dVVWRlQwR2pPV3V1cjJpdnlFYWZsYlFCYjhYS2tPdjBVVlpqNjJjSUpTdWkw?=
 =?utf-8?B?OXpzbzFmNDRmZzBySmVFcGlHT29ZRUF3VjVSNDU5NHR5YnNGamhrYmxsU2Vn?=
 =?utf-8?B?dTNXUzcrSmFwSlpMSVk3bS9KRzFHUGxkNG9OSjhrV1U0ai9mWDJwdllNRFFY?=
 =?utf-8?B?dEpMeW1uZzlvd0xrK1JMTlRTTkZMdDh6alZ2a0NHRWtkek1XL2RTYXRhaDFr?=
 =?utf-8?B?ODF3OG9yZG5tcThrbmFwRElGNFlzeUlmK3htN0F6OHdjOThJUEVFM0tsRE5B?=
 =?utf-8?B?ZjVuR0ZoTkZLOTZEUnBjY0pYV2g1THdwcTNzbzNHZTF5OFRnUUpJdWY2bnYw?=
 =?utf-8?Q?zGW6F19UDWYT6/yJG8jzChyXnvQW5PzrKqgGDjIB8Crf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C395380C56B2A45A8F7FBB2C8988710@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 796a1a89-e520-4f86-d70e-08de25ae000d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 07:50:38.8311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5Gy7O4RxrKpZb2fyfZ+1oNjtWN5LD/+hPndVU8sTDfCrdR8iYUc3aGyJp5l1buwk9+Bpsa4vdew9Y3Qb9KOVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7152

T24gMTEvMTMvMjUgMjI6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBBbGxvdyB0aGUg
ZmlsZSBzeXN0ZW0gdG8gZXhwbGljaXRseSBpbXBsZW1lbnQgbGF6eXRpbWUgc3luY2luZyBpbnN0
ZWFkDQo+IG9mIHBpZ2dpbmcgYmFjayBvbiBnZW5lcmljIGlub2RlIGRpcnR5aW5nLiAgVGhpcyBh
bGxvd3MgdG8gc2ltcGxpZnkNCj4gdGhlIFhGUyBpbXBsZW1lbnRhdGlvbiBhbmQgcHJlcGFyZXMg
Zm9yIG5vbi1ibG9ja2luZyBsYXp5dGltZSB0aW1lc3RhbXANCj4gdXBkYXRlcy4NCj4NCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWc8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICAgRG9j
dW1lbnRhdGlvbi9maWxlc3lzdGVtcy9sb2NraW5nLnJzdCB8ICAyICsrDQo+ICAgRG9jdW1lbnRh
dGlvbi9maWxlc3lzdGVtcy92ZnMucnN0ICAgICB8ICA2ICsrKysrKw0KPiAgIGZzL2ZzLXdyaXRl
YmFjay5jICAgICAgICAgICAgICAgICAgICAgfCAxMyArKysrKysrKysrKy0tDQo+ICAgaW5jbHVk
ZS9saW51eC9mcy5oICAgICAgICAgICAgICAgICAgICB8ICAxICsNCj4gICA0IGZpbGVzIGNoYW5n
ZWQsIDIwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL2xvY2tpbmcucnN0IGIvRG9jdW1lbnRhdGlvbi9maWxl
c3lzdGVtcy9sb2NraW5nLnJzdA0KPiBpbmRleCA3NzcwNGZkZTk4NDUuLjliMmYxNGFkYThjZCAx
MDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9maWxlc3lzdGVtcy9sb2NraW5nLnJzdA0KPiAr
KysgYi9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL2xvY2tpbmcucnN0DQo+IEBAIC04MSw2ICs4
MSw3IEBAIHByb3RvdHlwZXM6Og0KPiAgIAlzc2l6ZV90ICgqbGlzdHhhdHRyKSAoc3RydWN0IGRl
bnRyeSAqLCBjaGFyICosIHNpemVfdCk7DQo+ICAgCWludCAoKmZpZW1hcCkoc3RydWN0IGlub2Rl
ICosIHN0cnVjdCBmaWVtYXBfZXh0ZW50X2luZm8gKiwgdTY0IHN0YXJ0LCB1NjQgbGVuKTsNCj4g
ICAJdm9pZCAoKnVwZGF0ZV90aW1lKShzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IHRpbWVzcGVjICos
IGludCk7DQo+ICsJdm9pZCAoKnN5bmNfbGF6eXRpbWUpKHN0cnVjdCBpbm9kZSAqaW5vZGUpOw0K
PiAgIAlpbnQgKCphdG9taWNfb3Blbikoc3RydWN0IGlub2RlICosIHN0cnVjdCBkZW50cnkgKiwN
Cj4gICAJCQkJc3RydWN0IGZpbGUgKiwgdW5zaWduZWQgb3Blbl9mbGFnLA0KPiAgIAkJCQl1bW9k
ZV90IGNyZWF0ZV9tb2RlKTsNCj4gQEAgLTExNyw2ICsxMTgsNyBAQCBnZXRhdHRyOglubw0KPiAg
IGxpc3R4YXR0cjoJbm8NCj4gICBmaWVtYXA6CQlubw0KPiAgIHVwZGF0ZV90aW1lOglubw0KPiAr
c3luY19sYXp5dGltZToJbm8NCj4gICBhdG9taWNfb3BlbjoJc2hhcmVkIChleGNsdXNpdmUgaWYg
T19DUkVBVCBpcyBzZXQgaW4gb3BlbiBmbGFncykNCj4gICB0bXBmaWxlOglubw0KPiAgIGZpbGVh
dHRyX2dldDoJbm8gb3IgZXhjbHVzaXZlDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2Zp
bGVzeXN0ZW1zL3Zmcy5yc3QgYi9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL3Zmcy5yc3QNCj4g
aW5kZXggNGYxM2IwMWU0MmViLi5mZjU5NzYwZGFhZTIgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50
YXRpb24vZmlsZXN5c3RlbXMvdmZzLnJzdA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0
ZW1zL3Zmcy5yc3QNCj4gQEAgLTQ4Niw2ICs0ODYsNyBAQCBBcyBvZiBrZXJuZWwgMi42LjIyLCB0
aGUgZm9sbG93aW5nIG1lbWJlcnMgYXJlIGRlZmluZWQ6DQo+ICAgCQlpbnQgKCpnZXRhdHRyKSAo
c3RydWN0IG1udF9pZG1hcCAqLCBjb25zdCBzdHJ1Y3QgcGF0aCAqLCBzdHJ1Y3Qga3N0YXQgKiwg
dTMyLCB1bnNpZ25lZCBpbnQpOw0KPiAgIAkJc3NpemVfdCAoKmxpc3R4YXR0cikgKHN0cnVjdCBk
ZW50cnkgKiwgY2hhciAqLCBzaXplX3QpOw0KPiAgIAkJdm9pZCAoKnVwZGF0ZV90aW1lKShzdHJ1
Y3QgaW5vZGUgKiwgc3RydWN0IHRpbWVzcGVjICosIGludCk7DQo+ICsJCXZvaWQgKCpzeW5jX2xh
enl0aW1lKShzdHJ1Y3QgaW5vZGUgKmlub2RlKTsNCj4gICAJCWludCAoKmF0b21pY19vcGVuKShz
dHJ1Y3QgaW5vZGUgKiwgc3RydWN0IGRlbnRyeSAqLCBzdHJ1Y3QgZmlsZSAqLA0KPiAgIAkJCQkg
ICB1bnNpZ25lZCBvcGVuX2ZsYWcsIHVtb2RlX3QgY3JlYXRlX21vZGUpOw0KPiAgIAkJaW50ICgq
dG1wZmlsZSkgKHN0cnVjdCBtbnRfaWRtYXAgKiwgc3RydWN0IGlub2RlICosIHN0cnVjdCBmaWxl
ICosIHVtb2RlX3QpOw0KPiBAQCAtNjQyLDYgKzY0MywxMSBAQCBvdGhlcndpc2Ugbm90ZWQuDQo+
ICAgCWFuIGlub2RlLiAgSWYgdGhpcyBpcyBub3QgZGVmaW5lZCB0aGUgVkZTIHdpbGwgdXBkYXRl
IHRoZSBpbm9kZQ0KPiAgIAlpdHNlbGYgYW5kIGNhbGwgbWFya19pbm9kZV9kaXJ0eV9zeW5jLg0K
PiAgIA0KPiArYGBzeW5jX2xhenl0aW1lYGA6DQo+ICsJY2FsbGVkIGJ5IHRoZSB3cml0ZWJhY2sg
Y29kZSB0byB1cGRhdGUgdGhlIGxhenkgdGltZSBzdGFtcHMgdG8NCj4gKwlyZWd1bGFyIHRpbWUg
c3RhbXAgdXBkYXRlcyB0aGF0IGdldCBzeW5jaW5nIGludG8gdGhlIG9uLWRpc2sNCj4gKwlpbm9k
ZS4NCj4gKw0KPiAgIGBgYXRvbWljX29wZW5gYA0KPiAgIAljYWxsZWQgb24gdGhlIGxhc3QgY29t
cG9uZW50IG9mIGFuIG9wZW4uICBVc2luZyB0aGlzIG9wdGlvbmFsDQo+ICAgCW1ldGhvZCB0aGUg
ZmlsZXN5c3RlbSBjYW4gbG9vayB1cCwgcG9zc2libHkgY3JlYXRlIGFuZCBvcGVuIHRoZQ0KPiBk
aWZmIC0tZ2l0IGEvZnMvZnMtd3JpdGViYWNrLmMgYi9mcy9mcy13cml0ZWJhY2suYw0KPiBpbmRl
eCBhZTZkMWYxY2NjNzEuLjcyNDVmNTQ3NDE2ZiAxMDA2NDQNCj4gLS0tIGEvZnMvZnMtd3JpdGVi
YWNrLmMNCj4gKysrIGIvZnMvZnMtd3JpdGViYWNrLmMNCj4gQEAgLTE2OTksNyArMTY5OSwxMCBA
QCBib29sIHN5bmNfbGF6eXRpbWUoc3RydWN0IGlub2RlICppbm9kZSkNCj4gICAJCXJldHVybiBm
YWxzZTsNCj4gICANCj4gICAJdHJhY2Vfd3JpdGViYWNrX2xhenl0aW1lKGlub2RlKTsNCj4gLQlt
YXJrX2lub2RlX2RpcnR5X3N5bmMoaW5vZGUpOw0KPiArCWlmIChpbm9kZS0+aV9vcC0+c3luY19s
YXp5dGltZSkNCj4gKwkJaW5vZGUtPmlfb3AtPnN5bmNfbGF6eXRpbWUoaW5vZGUpOw0KPiArCWVs
c2UNCj4gKwkJbWFya19pbm9kZV9kaXJ0eV9zeW5jKGlub2RlKTsNCj4gICAJcmV0dXJuIGZhbHNl
Ow0KPiAgIH0NCj4gICANCj4gQEAgLTI1NDcsNiArMjU1MCw4IEBAIHZvaWQgX19tYXJrX2lub2Rl
X2RpcnR5KHN0cnVjdCBpbm9kZSAqaW5vZGUsIGludCBmbGFncykNCj4gICAJdHJhY2Vfd3JpdGVi
YWNrX21hcmtfaW5vZGVfZGlydHkoaW5vZGUsIGZsYWdzKTsNCj4gICANCj4gICAJaWYgKGZsYWdz
ICYgSV9ESVJUWV9JTk9ERSkgew0KPiArCQlib29sIHdhc19kaXJ0eV90aW1lID0gdHJ1ZTsNCj4g
Kw0KPiAgIAkJLyoNCj4gICAJCSAqIElub2RlIHRpbWVzdGFtcCB1cGRhdGUgd2lsbCBwaWdnYmFj
ayBvbiB0aGlzIGRpcnR5aW5nLg0KPiAgIAkJICogV2UgdGVsbCAtPmRpcnR5X2lub2RlIGNhbGxi
YWNrIHRoYXQgdGltZXN0YW1wcyBuZWVkIHRvDQo+IEBAIC0yNTU3LDYgKzI1NjIsNyBAQCB2b2lk
IF9fbWFya19pbm9kZV9kaXJ0eShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBpbnQgZmxhZ3MpDQo+ICAg
CQkJaWYgKGlub2RlLT5pX3N0YXRlICYgSV9ESVJUWV9USU1FKSB7DQo+ICAgCQkJCWlub2RlLT5p
X3N0YXRlICY9IH5JX0RJUlRZX1RJTUU7DQo+ICAgCQkJCWZsYWdzIHw9IElfRElSVFlfVElNRTsN
Cj4gKwkJCQl3YXNfZGlydHlfdGltZSA9IHRydWU7DQo+ICAgCQkJfQ0KPiAgIAkJCXNwaW5fdW5s
b2NrKCZpbm9kZS0+aV9sb2NrKTsNCj4gICAJCX0NCg0Kd2FzX2RpcnR5X3RpbWUgaXMgaW5pdGlh
bGl6ZWQgaXQgdG8gdHJ1ZSBhbmQgYWJvdmUgdHJ1ZSBhZ2FpbiwNCnBlcmhhcHMgaXQgc2hvdWxk
IGJlIGluaXRpYWxpemVkIGl0IHRvIGZhbHNlLCBzbyBpdCB3aWxsIGJlIG9ubHkgc2V0IHRvDQp0
cnVlIHdoZW4gaW5vZGUtPmlfc3RhdGUgJj0gSV9ESVJUWV9USU1FOyA/DQoNCmlmIHdhc19kaXJ0
eV90aW1lIGFsd2F5cyBzZXQgdG8gdHJ1ZSBhdCB0aGUgdGltZSBvZiBpbml0aWFsaXphdGlvbiB0
aGVuDQpiZWxvdyBjaGVjayB3aWxsIGFsd2F5cyBjYWxsIGFzIGxvbmcgYXMgY2FsbGJhY2sgaXMg
c2V0DQppbm9kZS0+aV9vcC0+c3luY19sYXp5dGltZSgpLCBpcnJlc3BlY3RpdmUgb2YNCmlub2Rl
LT5pX3N0YXRlICY9IElfRElSVFlfVElNRTsgYXNzaWdubWVudC4NCg0KDQotY2sNCg0KDQo=

