Return-Path: <io-uring+bounces-8694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D12CB0749A
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 13:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80A8716CA2C
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 11:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367572F270F;
	Wed, 16 Jul 2025 11:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S9q9WoFK"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9FC2C15B9;
	Wed, 16 Jul 2025 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664999; cv=fail; b=P2BZFocv+m54DFDIvXGeWpjdH4643hPN4iI+EH0wDB6NVrUaWABPQxeVY88wRGQrsjgxF2h6buKKpIgG2o7g6L6Lo9BMcMGtXJO0nIfQMyX+ZYvM4vgQM24wXisazWfxCmLoLSJUx9MH9fSma0zwQx3tqCJJZK9CxBvUvhwAkq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664999; c=relaxed/simple;
	bh=ijOngAeAq6bda1ArRlwkFu8ii1D1CWYM4d/otKxnaaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bpeeaXY4ORSLxGEvyCIS4lfE06jAiD2o5MXVtpsQo07CLwbNPt0/P6irhxcE0dAqTJmuZuAtPoD/kntAl+UqZmMPE/CwCYfhA7hAnzUJBnf7AVDDSXA6wRWRV1IcSe2p1ng0sAngfYygFVnirr5ro7Tc+36EtPbCnTD8sYqI93U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S9q9WoFK; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2YNko1mOvi6stVdljpabvh6NB2ceaOmiELLM8qh0NBwvhLWWnJBtZJhxz9o2QfvvLydyyjua4yT7EmjauzMAsstLEOLQawGcS3njwoa04uVEr3V/q3gy5swS6yF2fKU2Kce8baClfBe+fgZs6zOwRJ6SEjHmgOOAVpM6mSMhB+A1EZ86bxSeL/63MASq2AyEF90/lZjtMni3rlF0dHhwk0HS6VTmUJpDOIATl72tWkBljiV2mO+3deNmaC9K6oUqZsG5t7Rcbe1B96/a0Ti530FygMsLnqxmgsbPO4T8UDeSJKvZo/gszUq1oBLnLnoSQ4Zw59wXQ+EDZdrHk76qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7SYvvZ4iriIZ7j20q+rQwlYFLU9PEi3UdhI6QlY4bI=;
 b=IoS3ZiRqdQ3d8rMFCAy02gGiMNRfcYjCB3T4Wg8YAogxGatpuA8I1sL/1iJDi/qFin5TsZaQuIuMXt/0teQOO3XwyJ80Be81Rbnt0vua15iXTKY/JNXxXOuQbY7V+q/v9HxDDpcwLciicC5fxTYZws9vM9QdRg7Ngb+m+gJyU39ZS1ywoSZSopadDOYOsratedYwI5yJGj0zuMyTSvMBcSwEucnDCfDp3ABj1l5ImiZI/4H5sOlDEqMg6MFkequZyoHcEXyeclXP00O74HxhLNlj1DNQSG4RA/RtQ9ivd1bz1JPI++lDM+6Sb4ZgxDP5uEy07ovj20NnMYtiYyZEag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7SYvvZ4iriIZ7j20q+rQwlYFLU9PEi3UdhI6QlY4bI=;
 b=S9q9WoFK5ItUPmaaW9CrWgqE9sz9lPPotAVZOJBO9ku7nGskbSbJTVOYnBTe1ELHNTjYubBjIk53ut2rxFIk3wl1Nje/VMcMlcDmVvGsPKSjCsUPWfR/1UlWSFH0XFFjYc0Xe//N9cx5Mf7FfO1SZSUXip6Uw2N4cX2pb/b6imPIR7L4tqqXCEoBzBS2FbRkY8Vq++wHhj2rpJQthJDDBzTHOez7Ch5u8mJ92CnHd0EfPC2lGWFhoyXcHJmTwVCCLLqsnqvKmsQHf9oNeb/nQIqKbeJEOJH+f9kqrB45KUGvak60dJHcha2hxcZkw5denyalMW6jdOp6ydpJJpWpsg==
Received: from CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11)
 by DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 16 Jul
 2025 11:23:13 +0000
Received: from CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::e571:5f76:2b46:e0f8]) by CY8PR12MB7195.namprd12.prod.outlook.com
 ([fe80::e571:5f76:2b46:e0f8%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 11:23:13 +0000
From: Parav Pandit <parav@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>, Jakub Kicinski <kuba@kernel.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>, Cosmin Ratiu
	<cratiu@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Pavel Begunkov
	<asml.silence@gmail.com>, Mina Almasry <almasrymina@google.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Thread-Topic: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Thread-Index: AQHb8kYbLM5zoGcCakGbq+Zrkt38erQyZkUAgAA6FgCAAI2+gIABctUAgAABBIA=
Date: Wed, 16 Jul 2025 11:23:13 +0000
Message-ID:
 <CY8PR12MB71955664081E1B2B7BE5FAFCDC56A@CY8PR12MB7195.namprd12.prod.outlook.com>
References: <20250711092634.2733340-2-dtatulea@nvidia.com>
 <20250714181136.7fd53312@kernel.org> <aHXbgr67d1l5atW8@infradead.org>
 <20250715060649.03b3798c@kernel.org> <aHeJfLYpkmwDvvN8@infradead.org>
In-Reply-To: <aHeJfLYpkmwDvvN8@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR12MB7195:EE_|DM3PR12MB9434:EE_
x-ms-office365-filtering-correlation-id: d4551435-6927-4fd0-518f-08ddc45b2731
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?XS6uqja4N0e/oWDKKpq5G6cwVod+1gL9MKTXpV55HV18uTPiMrjbqbhtOpac?=
 =?us-ascii?Q?qK2Q5EtvzZfDFMbIaoL7yKe5ZCKWnH1+wh37T6JvfGOLs+QgT89uO8GQk4bO?=
 =?us-ascii?Q?RAd4P943tOHi3Ebb4o8q/9xYq/oc7YdK36kVgymjEYUo7SucPP6E5GZchLcJ?=
 =?us-ascii?Q?/IZLd7jylAsiE2YdW2ngoMlyzuKIh6ks92eapLGaZiu6d8PcRalthe7VGlTV?=
 =?us-ascii?Q?QMzhd7JCzJfBp/ZinnNGH+cXJAPufwjRn3PqpfodZgI8YNR6bZ8Vhj0vGMqA?=
 =?us-ascii?Q?059XIhLjdMR/wswPjV0Vzkhei5I5dWuIh4HacFhsdlA/spgrdeglPUyeRiff?=
 =?us-ascii?Q?su4PU8v86SGZNpcn7LhB6zQSWc+4Kf9mhlwelF6w74dIT34pEZApBwdZZGaV?=
 =?us-ascii?Q?snYS8krsydBCGN+/XEl1It9b+R0wKFl45ZeNw8P8teztqipOmjVkhwS7c7Xe?=
 =?us-ascii?Q?lVxSoXRgH8VjLZ3u5eUcx+YxIZSi6YCAljLsTU8HhGqh9yEcUzpMokc6TvVE?=
 =?us-ascii?Q?tJ/BKkDOT3OSQKmgpAnPru8tl4FoFbBd/ZVg4rJseNPNP74yhitRwZilP4e5?=
 =?us-ascii?Q?9H8Hpg89SFl+dvvAnnAUd693VddGvwLcjatIKz46UOu7GszaTXGrluPAL/o8?=
 =?us-ascii?Q?kL9GgLpj4UspXh4/7fCRjWlzLypjdJ5j4n6V2/DHMX/WRErerUmzh8c9bsmR?=
 =?us-ascii?Q?KGhRi0b2BJTkahv1ip8UPj6b3Zsb8huwLelLp2NCzCwAzAqOWc131Z1UkHly?=
 =?us-ascii?Q?6/MrMSLe3DzLgnyoSx3QiUUg9GwDly9OgLZqe5dhNpV8Nv12QMKTFMQgV68n?=
 =?us-ascii?Q?cNHfbbZIgqbRLiCEuwGSNg2I60RVS3+/qkq/Qx97tUj1DcnQxMWsmSZecmVG?=
 =?us-ascii?Q?yqAcCf+P1h4SQLnSeRcJCb03uPbkf/PejZsteX60w2MaG7V9Oj5UUXa9u1vd?=
 =?us-ascii?Q?d1JDbdRhwEfrB2EnNWES88ew/CMvXef2yHS8p71QKTkNeTmC6MXkOcJOui/g?=
 =?us-ascii?Q?isRyIWEFWnA7X7uBLobQjQCvDN7KT+wtFDRzhk/xXrwTpX6ZgaI7VWJXv+zu?=
 =?us-ascii?Q?dsPmfzRvEVlbQQWZiNeOBlnGHuAlN0Fcxd4aGGRclwW0pStOB9z5Ya5d3h0F?=
 =?us-ascii?Q?lXm3CNaP1NG6aBQR4Weg6CNrD5RvOZNIesZlsgodFXJ0ZvGKwtBAASnuRJoF?=
 =?us-ascii?Q?c8nMsgq6Pvwfr+pWOtIeZ1bFi7/S40uxH2s6vA47K0oXCLB2esKRDnQDZEEC?=
 =?us-ascii?Q?PGcoFJdauKTQQFioMxUUD6KyubbF5zTndiXQyswL/2RwtYMOUDmB2JJqSKaG?=
 =?us-ascii?Q?lFB5reVhgB85Y1kfcKUOM5479nl8UFz/m6r5SM4PdJzfM6tJwm0BGlVtF0jy?=
 =?us-ascii?Q?H5l/LTi4PAa2izHKPE5KkzBF+RXpngwWvCz1zYSCoEUjn84VAJXVObvLGFds?=
 =?us-ascii?Q?CioISQlJgZ5iXWRIKYoMZf4icgK5Fxcx5GgNLqS4166SxtPWlctmfX60FLoR?=
 =?us-ascii?Q?lIzKhbHbK193VVA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7195.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mXAC3FtSAfS0QPq0psti+M51nNAmrxBznMAiPfOZBoMpTjb5PZO+iz8RvJA6?=
 =?us-ascii?Q?jtACI8WewJndqppHGkiBF54b9MQ89PeztgSw3G8eheokss12rqeu4p08TPvJ?=
 =?us-ascii?Q?SlEo4SuElVsySvFQvi2THOfIuKoeh2axHtmfIebKqY/ARhEWOA3VQ9LWyeyK?=
 =?us-ascii?Q?oi9/ImFKFMCqqKiX8+l2+js2ikAA4KoU5sXns32G3SedjepDi4IxpVXSBa/X?=
 =?us-ascii?Q?1CLGxTPjIjHA/83UhY+phTlZhK6wz4URkmEQfHpvZWMGvS9LqIpUZ5yDxCEW?=
 =?us-ascii?Q?9cy9ThKmtHQ4antZzjZWskJYVCv+a8jfplI6Otl/1v68DdroA7GhgGJGg00h?=
 =?us-ascii?Q?evuMnxr38beTX12BfLpXuQZm4obvwgoh0hIbgu3vQODhGYItIPemKiRoz+Iv?=
 =?us-ascii?Q?LQCHQGDF2ukzUAS1I74oUcJ0YVO3a4Kh8Uuki30J56Ym7qJ/T8uPUvoj7pzB?=
 =?us-ascii?Q?4xt64kYtXSvDkkCD2ouH2JFUk9IsS+9wPNAMNxltWSPOliLf5z8SJMfqKOvc?=
 =?us-ascii?Q?weEQ+aU6PDjNqpUn/6MrNaeKIZr2DVvZCLvqD6YsHIysABFgJxkoB2IORyhJ?=
 =?us-ascii?Q?h1rujxUgTi6O7Ad8eLy9GvBkUvTXhzS/rH8tIuh+1bDGf7yJwP0ILRm5bVF1?=
 =?us-ascii?Q?TxXDOq7XYLIJKJ1oUngCuOQIBkhWGwJM1/TEIYAtTRQl8eAQ/rQOTfM/jLD0?=
 =?us-ascii?Q?rTcQiXnRlmptdD5Z8Dsv1nLEeP15tzkTvepUwiHBP6joCb4dq4sjq6JzSNlY?=
 =?us-ascii?Q?b/St5/0KsCX5YsxKha7hFJ5Cqoz+ZhR52wY+pK/Ztb0gJ1tk12UMonzv5jNR?=
 =?us-ascii?Q?wHurDEksWJUgLqi/mgn4CoOiMzthLXhvRZprv0VuVP+422n9JxCeuCHTsUhB?=
 =?us-ascii?Q?hukuMoS2k3iVuQ1RrZDeiacUIyL45EDNjBJ7MT2LybWuXV5z7Dpp4jagbOhq?=
 =?us-ascii?Q?iDEDhjbBXS8Te+QCKei2GqF+GkEoyJiPiZuBAGRzeyDc089Masfs/BCtfW90?=
 =?us-ascii?Q?ocqf4FCyVRQnmHaIDPvpw1J0ZFPXCkrtF5IqmjrZTdscgyJy1hJCjB68MkpQ?=
 =?us-ascii?Q?QfM7ecC6gmI0EpcYEiyAxvtB4I9mkXBc0YN1VkDAEOxXKoZYccm+FQkwTxEu?=
 =?us-ascii?Q?yZNGJSU0RuOTWwMq6GZ5FZSPBRRO9EJUBK1yVp1WIw8USVlnVdkaWPztfOS4?=
 =?us-ascii?Q?6UeMXcW0moVUNdgaxVAnX+W8XJVmiyUF9HgBfLZgNM3t4wPORDAREkRXhuK0?=
 =?us-ascii?Q?hNBrdRNDt68R2jtGE6m5goW/8XmAN736166xRGfgBnJxq1BeZYwB2LNi0asa?=
 =?us-ascii?Q?dOnro7msDuS9xqGSfb4tiHnnBPlWsRGV0regSwNGInxfMFayv3djnDZnXvjh?=
 =?us-ascii?Q?Hh5dPToNWFxAxCYixkX1tAf5S8G16O6B+4TZeOPZbTNeCTNHkqyIjUrdew4Y?=
 =?us-ascii?Q?eXeoxzdDE4c3hMN7Gcid64M1NQlOGEoRObnQskCmWnOCZ9SOVeA8UXS2LzXc?=
 =?us-ascii?Q?I+Y0G8EL59jWlqEzhLGOqK4IrmkW/+e75gIAvDA8toijSgQ8VKxbwv1CqdrS?=
 =?us-ascii?Q?f38OwQpsLFfiQ/PICAceWj8bFU4peM8z1QMVC+hotp58lA5PnaYd0V/UKonF?=
 =?us-ascii?Q?NTOq4/b990NoitXjhtCkq/Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7195.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4551435-6927-4fd0-518f-08ddc45b2731
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2025 11:23:13.4709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GC2Tkr5fba85V8t+M1zFnsVIEPHsrHJFQbEwmBwx8/4zv11Hdbja/Qk67Ge7xNvP+EdIPJUyslCKrMHEIW64EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434


> From: Christoph Hellwig <hch@infradead.org>
> Sent: 16 July 2025 04:44 PM
>=20
> On Tue, Jul 15, 2025 at 06:06:49AM -0700, Jakub Kicinski wrote:
> > On Mon, 14 Jul 2025 21:39:30 -0700 Christoph Hellwig wrote:
> > > > LGTM, but we need a better place for this function. netdevice.h is
> > > > included directly by 1.5k files, and indirectly by probably another=
 5k.
> > > > It's not a great place to put random helpers with 2 callers.
> > > > Maybe net/netdev_rx_queue.h and net/core/netdev_rx_queue.c?
> > > > I don't think it needs to be a static inline either.
> > >
> > > The whole concept is also buggy.  Trying to get a dma-able device by
> > > walking down from an upper level construct like the netdevice can't
> > > work reliably.  You'll need to explicitly provide the dma_device
> > > using either a method or a pointer to it instead of this guesswork.
> >
> > Yeah, I'm pretty sure we'll end up with a method in queue ops.
> > But it's not that deep, an easy thing to change.
>=20
> Why not get this right now instead of adding more of the hacky parent
> walking?
The previous RFC version (v1) [1], the driver was explicitly providing dma_=
dev=20
at device level.
Queue level is even better; it will address the Netdev with two pci devs so=
cket direct use case too.
Not sure how difficult it is.=20

Dragos can you please evaluate?

I believe the dma_mask check in [1] should be removed regardless.

[1] https://lore.kernel.org/netdev/20250702172433.1738947-2-dtatulea@nvidia=
.com/

