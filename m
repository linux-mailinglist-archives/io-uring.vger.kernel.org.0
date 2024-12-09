Return-Path: <io-uring+bounces-5351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 486399E9D24
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D26D5281BCB
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3302B14AD38;
	Mon,  9 Dec 2024 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="FgjATeW1"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BA614F9E7;
	Mon,  9 Dec 2024 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765747; cv=fail; b=JqfglilSpxsfyybUgEiNxxuNi/l0hlnPerBprNYYBHn4293lfAky/AvN+lbFQIyYkUyvdgrLtD8JWV2dpotiaEryRVvPQSBOREhzjEGpAfRdKPkAHV2QW/iF2Crh2R1rj8/4zJW5dEOu5q5x2ONlZsSrPWdL0oyRzZd8su31QH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765747; c=relaxed/simple;
	bh=Zuoy2BcZP6Xx9puSGc6pef17F4/e16uOrFigwuOyJsU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ky2nzgKj/KNvSh6A/naMZuJygYHGBV+iDcSp+Cgta2ovR+01jRRQ+m3tz9T0GV7RA7mxWBj6FVsHwiFyPt0gR5jpaDF8oUfxzK1jXaAg/VsnFDmMJLGycp1J6oKodlp1rPu9PWDShtSeGhpb6qoW0rTh/a6zEu3SJm5c6vjuDyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=FgjATeW1; arc=fail smtp.client-ip=40.107.96.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ihka5erUGs1QNP6p2ckmm8i8y2mcY0fDxPY5u/YRKB/CWS9YSNmONaeUewslwemlmTqxRBFEBGvHqREDae5kmCLssPD5pyhy4fbJ1PrfZM07oJMPi9xvfrul/8y5PsZF3kD448TafHD0DJuRiT8mLU55PCwxmz/JdNE15TbgijOBAw8H77NkaGrM3d34l54G1ycU6hqs7Sy5G+CbF1BgeYX/9aPpi/yx5RKzztLTMICFT5HLqpMJzFOkVDHnbBfQ9LN2VinFhIJL6vD2CvlyU4+yS0/7SXZkCkgBtk5ll4FYuAdg+J25Lh5JbGh2wCAPsFpqlW5Up4JJYPUmFc1OwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zuoy2BcZP6Xx9puSGc6pef17F4/e16uOrFigwuOyJsU=;
 b=jkm8pojJktOr9eYWsVFProAQ9//y6dLHSrURtMBEvdywatLpJ5QnOBZIV4RCsZKJJ0XqtS4JWWq4Fr0kQGRrCnBkq4kzCqC5+9yCQVv5TQO5gMwczqTliiqsffOTsWIi5VM2ApXXYzJdtJJIncvTbUgcWE+gprgLuNJYxsMoQqVXRE1XzZrfEjcw+Lj/qQitFArJj2E33zESpV+D+e18V+ZEGWP+hyHtke96mG9IrM44m3LAo8ETTbuNH96NdUkc7Gv8y0GFXiFaNvdXT6N+lQyUSKTNhB9DUr4YmtRNYTH262FEfuipsD+a3SsXMagbYhyIwwS15P1UVi3N/I5PnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zuoy2BcZP6Xx9puSGc6pef17F4/e16uOrFigwuOyJsU=;
 b=FgjATeW1BuOMuBlls5eAo4Vc5lzJ5eJuey7WVrUvYsn7FP4EZtEj1LJ2F139gsx1B9tiE6eClIcAvGXBVpAbOlbTpI1ujCKX6FHReHWnVgGqlQiREg21GAzU3uZU3CQcN7WBW9ns52QAtLd5VVMqo0dOSXlN87Jgnx+1ApxopRqCJjXgNPf8yFmu/1AEMAVLRoR/uwTAfTUacjybCH0TedSfW9nhivwzin2fQRrJwLykOyrXuxFg2bRchu1AOkmuaE98R9gmRyJpENqz9hHORZvrVdrfxsYCxznjKRAbzrGroO9BCzV3A371RkXf0X7uEHAXCwvYrDV0dTpOP1E81g==
Received: from DS0PR08MB8541.namprd08.prod.outlook.com (2603:10b6:8:116::17)
 by SA1PR08MB7213.namprd08.prod.outlook.com (2603:10b6:806:186::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 17:35:40 +0000
Received: from DS0PR08MB8541.namprd08.prod.outlook.com
 ([fe80::fb1c:d78b:e57:bc81]) by DS0PR08MB8541.namprd08.prod.outlook.com
 ([fe80::fb1c:d78b:e57:bc81%2]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 17:35:39 +0000
From: Pierre Labat <plabat@micron.com>
To: Keith Busch <kbusch@kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: RE: [EXT] Re: [PATCHv11 00/10] block write streams with nvme fdp
Thread-Topic: [EXT] Re: [PATCHv11 00/10] block write streams with nvme fdp
Thread-Index: AQHbSjkfn7E40X+xN02QKPCe64Si9rLeJePwgAAERQCAAAFGcA==
Date: Mon, 9 Dec 2024 17:35:39 +0000
Message-ID:
 <DS0PR08MB8541FB9AF1CCA39239E85861AB3C2@DS0PR08MB8541.namprd08.prod.outlook.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
 <20241209125132.GA14316@lst.de>
 <DS0PR08MB85414C2FDCFE1F98424C0366AB3C2@DS0PR08MB8541.namprd08.prod.outlook.com>
 <Z1cn-LLW3pGqJFqC@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <Z1cn-LLW3pGqJFqC@kbusch-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=49b88dd5-cfa6-4cf2-97e3-e6d7998f96cd;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2024-12-09T17:30:01Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR08MB8541:EE_|SA1PR08MB7213:EE_
x-ms-office365-filtering-correlation-id: 0fc804bb-9945-4661-d6ce-08dd1877e63a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0z2D0Z2wlQvXbgnT03g8cHe88pcR/NfOT+id88iArSMeyzKQWiu1+PijfzbT?=
 =?us-ascii?Q?cGgYRYdNyP/nfW9IfjJ2TiXDt7JNQw0siAwV28kbSEAqYMEiPcR3kLWs2TEz?=
 =?us-ascii?Q?YEOVvlS75q/O/YmIh9SDj3SYmpVQL/IhFO5wGwSQkxFk6pQRR9m+bmaESbfq?=
 =?us-ascii?Q?raJ2bmgaFyCAsgqGGLXx8AdkSh/wMGiJ+7QCE2Ew8XWQ6cYCUf2yD5+M1oBV?=
 =?us-ascii?Q?MwoxFv4WZaWNC8o4AR7yPsgxDr6cPJkZUcjSxhYUa7P3w4LmMuw+vu8oLbbT?=
 =?us-ascii?Q?RJAa6/EgY4uGSzqR3jFAeg5u5BXP+ymL4gLFw7JgwfB/y+/kIKkR/pVlgrY7?=
 =?us-ascii?Q?SieJwY7sjHQIEBLJyWekEV7rhtjpXLo869hMBR4t3HFwSbQM5YiZ8F85BkJX?=
 =?us-ascii?Q?pUlrSm/7Hh47LmTOM1DOreug4UkLZFjHPOHSPCf+/exaqO20E/qPr23ABZqb?=
 =?us-ascii?Q?CKRoXItR7mFiMVuKDZrlBxmsBLqlEV7OI/XPIuSlRoi+UtNqyOxApDIVMJwE?=
 =?us-ascii?Q?aKmE8wkonH448BB5YMpXWlPAB0BGJ9q3jzi/26IwHhLs6I6kl0poTI7ZR0hu?=
 =?us-ascii?Q?s3uFqDeCXkYaSiDGtb8UM+6nb6XJAOAJxz3e7nar0oO9G9Wln9So5JRhZWcN?=
 =?us-ascii?Q?YCBEN7OrIYpFWxrHpDhZHPtWPLsEfLN6FIeaCs74wn130AqIBAcOoKb1vQR2?=
 =?us-ascii?Q?LYTIUEjzF+MGJI79L2ywnvr/eV88XSg6Vu1ArLcpWysfYPR4bVLpLdV2UjcC?=
 =?us-ascii?Q?aU5tRkgLfkC8wovwAEEsOl/wNL+rleU0IBSrLWeWpk3cnGbTopeZk6LW0euG?=
 =?us-ascii?Q?ZlvkIQ09UXocQ3KsAx17KuUfVYXbz0Cu6pp36Ibc5XbUn/7QXED9lM2TKw/Y?=
 =?us-ascii?Q?aOk6YfoLGGhKm8u9tns7KJtCiZ24cwmSm6wxYDwJzYXiW0EOEPZ4gdRldTZz?=
 =?us-ascii?Q?H0UtkVPXklHAD43wTC56lCJjXBu0vuLkzyn+i5Iwna5NWXOYJbeyELb36rQa?=
 =?us-ascii?Q?gW4O4b7ho5lU3YTzQAX0XmNiwBOwPNa+x193wZ03AMfTRB0NjoGdmQt5680q?=
 =?us-ascii?Q?3Fyr0lVaPA/LhPhsJnpjWkPfZWOhsL9+UOpd3SSBSmu0Dpx1A3iCvZ0/xL4M?=
 =?us-ascii?Q?S2c6qtV+xSnsGy9AxZFfFLk2vlh/fMJCz5BIvP6yWe8J/+1BEJHbeeGNK9FQ?=
 =?us-ascii?Q?ud+B51BPKNv7zpyA5OAYhgRkxS1lmS3DfIAGOR/96iVwfBLHDAmT/UBVGJsR?=
 =?us-ascii?Q?XvFOc5veYFDxgtCcVq4l8QltTkfAGaxvXcdlPhr70PTbkssLrfEmDczJM2rb?=
 =?us-ascii?Q?mQLXeIXaT8S32A9igLLnxhTt4JLLCKDl38SNwk4oE8WCTzc3Pdk6BlLxk+pV?=
 =?us-ascii?Q?sOyC/Ds75vtiuotm0liEgarVOUyb1H2grU7dISUhmnEilnmNOQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR08MB8541.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9lCY7ktPEy3fPBtayTjfbEE8D9VcFwNMfOWkHbeRwbCxrD7HZrRtQFd1B/wg?=
 =?us-ascii?Q?+9h/lOx7As7KOBWeEOjeMHWpXNC9fZSiX2Eg4WlZd3tdcAcK6DifgPEDRbqY?=
 =?us-ascii?Q?IiF8PZNVh3EWwHt21UFx3MLqpcCg0NerJ702Myxyl2BnxRdzMI0IXdkZtcQa?=
 =?us-ascii?Q?8DG8jyp40u1ZaUf7BUv3gzgukDUtLlLtaHxs+hsJfTm5axDRSsCLe8jny3iq?=
 =?us-ascii?Q?W8NBtgV5A2fA5X7DeazvPNumEuFsGDkdvqc38PCxySEbW41P1DbpNbUK1Xqi?=
 =?us-ascii?Q?NZ5w+Zp8tk/TF0bjJ+/uAt9T2ZD5YKpf+6HoyrEkGADmbsh+1hQN2yvqj7De?=
 =?us-ascii?Q?Ss+iC78K1B9pxsg20hcMoy/uocJmPfn6H9B7ZuLfKietR6CxYx8bu8j3yu0D?=
 =?us-ascii?Q?sW8LiYnlhigDyJczanXHiF3BXJkFiD/G8PHRuAYcWOe+cwh7K5isHx9MXtgG?=
 =?us-ascii?Q?1VTS0Uaf1XH0TikxWDS+MWmYiCAjAibdMRYisGtedzvoE9f/NHuHpVHhaD9F?=
 =?us-ascii?Q?QgrpoaXVmZgiClaOmdqdCx4JotGT1R0CaUJ4cZvJFYxNzSjBVddi7KZe+hW6?=
 =?us-ascii?Q?nSbbuHcScTDz60UsSAVk+qSHppFeLlLar2ZHV6cH9jkmePhFj6eu7RUN11Qx?=
 =?us-ascii?Q?TQHVSgKqQJn5/eUp9cjx2AmNvdNIylzyrsjgZi+Zfrllu6kb9TAOKHTmiyYO?=
 =?us-ascii?Q?O+XUEqMOuiVovbFdoVYlLx+EbjCsKUIR46SfErLsAKcFcsH8QysDrwUG5Hfr?=
 =?us-ascii?Q?sTX/bjmDLYYzVtZ3iuTi17IjUy7jOZrWkxj3JU2w3TORwJHg8SLs717DKHLA?=
 =?us-ascii?Q?ZPXaaZdVKxnaVASJHF9CIEO5cjZE3+PfNpxZz0mMUQJnd9wLbAcj8GRwYNeJ?=
 =?us-ascii?Q?EOP1SxNq0esJ93znb3k2BiJV2VXi2KMCdwlLzQSkdCcNy/8k5RDsmxvEGoak?=
 =?us-ascii?Q?Ki4eMJ2ub3SofOpsaKY3MPKuUDQHphQmRgcjub3kdzHuzFCO2zyhzzDQd7mS?=
 =?us-ascii?Q?4k3n6xnlkRjgqqGY/SbSJPQTtmyK/4jsXYhVg2ffNCIhvUFxKmHtcamhPvIF?=
 =?us-ascii?Q?FKJcSBnEBH2fruyNVF3k7W3kNmaFQEyhC4JZTVlAooRQAnAMLOIM7B4B/pCP?=
 =?us-ascii?Q?kWOboSRvxIGj3U0B0abeqpzMV518XVqdt3E2jbbo6jZg/U5jgzeNtKLCxIgK?=
 =?us-ascii?Q?dhWAg1o3n3xHWUuDpj3LkgsJx/LRkuRJxIarkNtl31atpVTE3bzCB7MKx9eX?=
 =?us-ascii?Q?AQgQQ10ys56MQCkVKvN5b1hp0+2cTucIBdEQvuJiKbJ1qtE/3bNc7Uvqvh38?=
 =?us-ascii?Q?/wnwajQlWYQ7vqtgj+WzrA5XTwNP5WEIGsU49RNxBUX1JF7NxsORARK2KX6v?=
 =?us-ascii?Q?tre2VS16OJhHvwHeS2q9ghqVdcz9b5l+92KcfPtfI1jZBCPq9Tc7ObSvpHmQ?=
 =?us-ascii?Q?r14v9z+L+c8AfqK8E/BHm3xkelvgJO9ShTMaIfT9Hm7dxpI/56tJiM3XvIBG?=
 =?us-ascii?Q?rOQR1NoiTC1lhdZlEXV7c/URE4Mw0wR7xX+90w0q1k6sG+Zqqs0p/7r0WCob?=
 =?us-ascii?Q?6rXl33ewXXiGTUxqnkQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR08MB8541.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc804bb-9945-4661-d6ce-08dd1877e63a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2024 17:35:39.9205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F2HJi0sEieaqJy/FXqCMO5+wEySqDN5WlxZDhdvJe021PrVhJCmQusbSzzoEoOgairjxoQVh+hMyyRS0CqiF7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR08MB7213

Thanks Keith for the clarification.
If I got it right, that will be decided later by the filesystem maintainers=
 if they went to convert the write hint assigned to a file via fcntl() into=
 a write_stream that is the one used by the block drivers (for FDP for nvme=
).
Regards,
Pierre

> -----Original Message-----
> From: Keith Busch <kbusch@kernel.org>
> Sent: Monday, December 9, 2024 9:25 AM
> To: Pierre Labat <plabat@micron.com>
> Cc: Christoph Hellwig <hch@lst.de>; Keith Busch <kbusch@meta.com>;
> axboe@kernel.dk; linux-block@vger.kernel.org; linux-
> nvme@lists.infradead.org; linux-fsdevel@vger.kernel.org; io-
> uring@vger.kernel.org; sagi@grimberg.me; asml.silence@gmail.com
> Subject: Re: [EXT] Re: [PATCHv11 00/10] block write streams with nvme fdp
>=20
> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless yo=
u
> recognize the sender and were expecting this message.
>=20
>=20
> On Mon, Dec 09, 2024 at 05:14:16PM +0000, Pierre Labat wrote:
> > I was under the impression that passing write hints via fcntl() on any
> > legacy filesystem stays. The hint is attached to the inode, and the fs
> > simply picks it up from there when sending it down with write related
> > to that inode.
> > Aka per file write hint.
> >
> > I am right?
>=20
> Nothing is changing with respect to those write hints as a result of this=
 series,
> if that's what you mean. The driver hadn't been checking the write hint b=
efore,
> and this patch set continues that pre-existing behavior. For this series,=
 the
> driver utilizes a new field:
> "write_stream".
>=20
> Mapping the inode write hint to an FDP stream for other filesystems remai=
ns
> an open topic to follow on later.

