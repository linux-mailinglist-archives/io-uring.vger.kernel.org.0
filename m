Return-Path: <io-uring+bounces-4630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2245B9C603A
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 19:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A85C21F219B4
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 18:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4011215C62;
	Tue, 12 Nov 2024 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="GLULatpm"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B943213154;
	Tue, 12 Nov 2024 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435510; cv=fail; b=q4JSFH8h9CxYl28LO2N3XyDXOczCnYBR5JaT/duYI78HmQXK23rufS8vHAFZfTgnjTenf5azr4LIbmbOSaK/lppRa/h+FEUiMxmMlcvXSQbagHRKtuT5qYKW0gY71xevBDR+kd+kwLKi4FBgWmJvrzfGpCgEtYRdj4v3KWEBs14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435510; c=relaxed/simple;
	bh=QOkph4MELoShBOF7ciQhC3olAN3KRjdHtHMVWRqOiiQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=my3e8kr0+KHRAbEQmKrJLP760rWZHYrvOPWCTRzl5r9JiVgTr9MdnJgR6DmVtwk8xl/JqBdYv9Vded8GSfR5CLmT0qlDSQFwT86vK6tWRrvbMOI3QRWFEDXMn8f4mh1R4jw2o4ikMynlRxDjs2FmiVUYs1hnd8T5AtbcDD2Bqk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=GLULatpm; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ybtt/6U9GSpPkjI4Q30Ey+IM12CmzUK3DbuEDoeFZAW0ooo99K/cKr34EaTlDmjfktmEz4OlAAqqc9mSzlVKWsRJuPfDOLgh6cQp1gVRdf9IpZ2HGDwJ4+aiXxtPtnLAv6l2vlizBGLYV77U6GCztxZ4icFR+I1kE+YBRMEFf/HYZ2c3QSjtL3Mjd9RkwyX6koQ6aH39FZub0JpJ9gt2SnGhh+4MPEIWzk3F7ZSaHYYM2bG+vxe3BcOoDk7Kts4m90hms1bI2lyNKnsHJXofsOfiCMO/bgjYoX2w1hIifov21wBPR4zZs/XqClMN46EclMwZltoK/Dm4MO4bnr99CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQ5zc7j3g4QN4zCC+/oQiyi38xboZ9P77OmnY/MIZfk=;
 b=H60oafM5EzwHs9A+EXtgY5pnZ79Hei7BLFQj68MViZ63RecIEXpmraK2cRdmuhcL3r5HmljSgLJNto/NL3LGP/iXjtuBhLCBkqY8VM9CMPD165UQV/hyeH2eL22XKdVoj7bVwNEECJGVnuppoFP1v5T/aMR0hNG421Lpnn4jwUKJKQbmhieil6tnToEzPIDxjW0GO0Vhe4lvTxggY548UBcUpLAhCJGBtQdF4iSjau27uksHoo/udIy4VbIbF1uSpz31iCIfK7PZggZmonlxhqQp4n+Ga2g/cLxO+toDMOqKcLucTISSDn60CvtYR/2PxgcmC+WwgHg1O7EMCbhrEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQ5zc7j3g4QN4zCC+/oQiyi38xboZ9P77OmnY/MIZfk=;
 b=GLULatpmY3U4UTJMNbRlsK0L3jfuOEC6KeC5MKbBI8mK/HrYsfSIduJWkjnUYSPqnHFlOv7q1twUDzUilU5bKcSRMIZHkKOetOGyK/x71tU2g4+0U9CUQOs2Jry/NqQTeQ8bPLEqGYuy/5iP6pyVHMCs537eJK9xnqoqnhbgEa01hVzicDEPIyUMIV+wDSnIHsDISIYrfaGRU9Q8uGm6mJsSOKi+dMosSyl26xO1e/nQojkqAS2/3NwIQjsCkUy+Lq/3YNGHKZ/54wqW+WF/GpPABg+UVeEkK//rPnXG7wYMSvYUntg2tdQ5ib/yU6XqWkh6zlXrMahs2z2eipxifg==
Received: from DS0PR08MB8541.namprd08.prod.outlook.com (2603:10b6:8:116::17)
 by IA1PR08MB10589.namprd08.prod.outlook.com (2603:10b6:208:595::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 18:18:21 +0000
Received: from DS0PR08MB8541.namprd08.prod.outlook.com
 ([fe80::fb1c:d78b:e57:bc81]) by DS0PR08MB8541.namprd08.prod.outlook.com
 ([fe80::fb1c:d78b:e57:bc81%2]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:18:21 +0000
From: Pierre Labat <plabat@micron.com>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
CC: Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "javier.gonz@samsung.com"
	<javier.gonz@samsung.com>
Subject: RE: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi
 streams
Thread-Topic: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi
 streams
Thread-Index: AQHbNCTMF7f8bx5wU0eiHulTQqfrSLKzpKeAgAACTYCAAA5HgIAANe5A
Date: Tue, 12 Nov 2024 18:18:21 +0000
Message-ID:
 <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
References: <20241108193629.3817619-1-kbusch@meta.com>
 <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com>
 <20241111102914.GA27870@lst.de>
 <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
 <20241112133439.GA4164@lst.de>
 <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=435a90b9-d1df-40b8-9522-6522c59b0a47;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2024-11-12T17:39:14Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR08MB8541:EE_|IA1PR08MB10589:EE_
x-ms-office365-filtering-correlation-id: 38e3c41b-3d81-44fe-ac19-08dd034663be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?9uHQVEqCRqouqp/miLWv2ZvCB3rqSaQxrSVO9GV+bH6rWm0G2XRgIje3qdCP?=
 =?us-ascii?Q?1fWpoSRXYVoNgwzTeylbbF0taBHb84HFkOjieVWl/dTNdhxF5dQ5pc5dbmgR?=
 =?us-ascii?Q?mFzYOJsCFtgWE77boqPD1Mjq7HuLyjaIn4d/fg0tFtfNFsPPTkvNAeBKi7gQ?=
 =?us-ascii?Q?0zuWQMJkVNayi7huM/Xe+7aVNLUPy3fw8nMSXOVeW7wb3GEcSAbA2gdla10R?=
 =?us-ascii?Q?vPVRONRmCsMqmAmTzENmXBCfoMzGNiTq/N7j3aghifMBvqLgSQLAiYhdXRN5?=
 =?us-ascii?Q?rxpejEV52w2ZgoTznOPB4bRNhqoeTcU7hYw8tMRke1/KeT+sUy7iW2qQKhsl?=
 =?us-ascii?Q?bXG/VuUeDj8GZpvoeoM704zjreOZHGMrUYjFvooNy4X7KAPLyj6AwyRu3X4g?=
 =?us-ascii?Q?zGQeTkkThP+i8kEjyVvgqNk++iUqUrcMkuLSEa45pKQqZMoeFgjLAfYZY0LU?=
 =?us-ascii?Q?HPPdFAN/o2KB8t/dvxXxse9pwXVydl2FVB0hV/Me6kykLNFGNLxtygUV3Z3u?=
 =?us-ascii?Q?aSkS73Xz1EBtNGzCPsmfSjYaar31j1tq9zpiuxJDLy+seqP5YSHMtdeKvPUB?=
 =?us-ascii?Q?9E2pu6qJfp49ihIw+1bJvpSihAG0ch8jwEPL7i7IJ2l+Dj1XcMHSma9ttlP3?=
 =?us-ascii?Q?AH3nTmSnwqI3oYOnIt+iAgTciR750dtenE0rpwp68DZbDraEjbS1QoTW08Yq?=
 =?us-ascii?Q?ed8A4wE2rKlPy1HP9S68yFkeit9a5WHOq5exgiGkRZ3ATGTzHNTs15ngd5bW?=
 =?us-ascii?Q?PDmEupfYPvnj5HmV13NczMJhnWtTVFXjGE7kLK+AU9tcT6r0qRWm212ahUpN?=
 =?us-ascii?Q?3bM7qHspRC2YxvjiSLbzVOURhpm9gz4a6tQUABa4ZrlJID99IdQE/tOz6bVc?=
 =?us-ascii?Q?SJTjVTfAR3CJuDnq9s+ngn1ruwZr+P+p4zA1xSS7aLy53k7OFpHzFTsECos9?=
 =?us-ascii?Q?AbQ+XjvIoZ6tv/EMZRZmMzCElGtyTIXsFqkDQ5QHnVEhwwwR2UP+wRE4dvJQ?=
 =?us-ascii?Q?CCxpIPmA3Mst5iw3gpIhWYCd7cWrTfq4P4MoqUwPdLELlbW/Tuf+KGc1rxrq?=
 =?us-ascii?Q?4sSwBctZp57upOUrxSRq3SrlEkjqRxUA0vfVsT8JxP2bpkn0IqaiH87xrxXu?=
 =?us-ascii?Q?3po1Va2zT2OSiOZwGq5lD77nh0AKttY5w3WIQgfmUai4xojujfnwCcmy2jZG?=
 =?us-ascii?Q?W6Y/c7dev4kpoKM9CSPdk8tJ+MAZSX6PNhddtIiJ0s6SGm+FBGg5u3kRFou4?=
 =?us-ascii?Q?2rd8jFIsgF5ivZo965be9AHDJGvZe0G3LxlhmkyrjTu3+e8knqy2dJiE3oT8?=
 =?us-ascii?Q?6CrRs5FZrw9+xZSfSl9N91lse4FamchsCaFZ4mJFM80rxD448iIbJWLuJyGy?=
 =?us-ascii?Q?pdK3oH0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR08MB8541.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?hc/XSXcYR1anGozFrWMRNdpAGH1RpY/vEbVSzy2NO3w8sfYsWhSrUtQXWkPF?=
 =?us-ascii?Q?Salw+HfcIn0hsq9phEIPmf1zSw7HmNALoDs7lq8Y47C6NV0Rs6yPAnUfbZjU?=
 =?us-ascii?Q?OE1bqZuwMfuD2rFrSj40mj+KcALYCwKYBrob2T+RgVVRxA0h+AMwR2Zd6Ht/?=
 =?us-ascii?Q?4SvN2KwVvn/IRZs8JT9lJGPfLB+6Q3f1k7hwZdWvS9nGSuwHSiGvl7NDiCW/?=
 =?us-ascii?Q?cBphz10dRLF1NfRlXOMU6XvMHZZeimDFclYgzlG6Sk6KbWN+YgxvEv1x70Pm?=
 =?us-ascii?Q?AciR16cP+m9HtltTM1Ohz9R14Fa+YkZurxXCSSE1p9Si7cBRT8aegAjE2Pqc?=
 =?us-ascii?Q?ZiWPIAPxymFKOVZapRGTzn9Be5jIWk8kvN1WPTpoqIczuWo5AcYuDa4Q4JCg?=
 =?us-ascii?Q?rpk+Zv0LycwmaRUNGzpON83bMdHrGCsBNCNYtmay0IhDAfrC3MAVeJJy86FZ?=
 =?us-ascii?Q?ZmNmzy5S5niGhdeNq+tSXRFRCRCbqsVq9vLhayU1daSh+rVhAXZt0pmG6oda?=
 =?us-ascii?Q?h7yc2VPetRw3bZUC9+Sfr1rrn2sU4mPOJtszhxh1yln6XxH9SEsdIeeGOf9b?=
 =?us-ascii?Q?fj2NI3zvJo57WTUxwPQuyG2s6r5sh0d+3WZPtbIxXo9B8/3/FlHyJ2fQ66gO?=
 =?us-ascii?Q?UxXT7c86cGc5ecxVACPtPTfFuiGzD7BYC3xHUskc9tpJELS82EXDyJtW7bNy?=
 =?us-ascii?Q?23SjdDBH/emVauS4wJKYtQjQPRwkUZvPYgwH9Q2gz6Gc6yURGphHHDWGrZWk?=
 =?us-ascii?Q?mozJqnIx2zifLNb4VjSv7TRuleFQvrhu5OSpfjzqYZo+7n5ytpHjLHRLbFIi?=
 =?us-ascii?Q?utJueLrfK/KeRedEgaApA7ONpt1764tQUL/p0BOwaDd67aKKhC3vo0KKuKkS?=
 =?us-ascii?Q?ieuBDaSOtIfpcRd4ZkWpMjke9NiNbQzdFi/tkou+2RjDMuXkKJw+3QX1W8E9?=
 =?us-ascii?Q?uAX61FAdC2Zw+3ejYeYYQlJgnI7BNGVR2rzvd8wsBFx7TEgAP//+rNM1znLQ?=
 =?us-ascii?Q?bxoEv5pl+3Y+xts/Sj+6GK2RRfgFCNEwemBqWMUVgFiWezSMttLE/CoUYmWM?=
 =?us-ascii?Q?1pyxANTjaUd57fWnv1itX5MxbvoG0jp2GgGrukY1QP/TOmkffEe+HA+2Hm1B?=
 =?us-ascii?Q?/sW3bpuuPd9Jr2P5enyuws4xZXv4BJBdQ4vP3zoOS6TVOf3YjHrh/8XXImoJ?=
 =?us-ascii?Q?LuorgbbjKT/Vnl+Zf3sf6JF8NcO2e3Vtb3UC36CSyRc06hMq7LihMpbQvopI?=
 =?us-ascii?Q?lkC3BnpyWBgLJUSNsajFntFwCeTDcC8viWgl+dleazpRtWtJpejNPs2szDvI?=
 =?us-ascii?Q?b/W+r7k0OAxlFi9U/q3MhVLlAey6FLxF2nyaPUg5PdW12FpFdkllclmkAB8u?=
 =?us-ascii?Q?dsqISXB6r6WzYIyBGZo5mglzwZGeYg0xDDoV12sVa/YocsShog3O1hVXV+9D?=
 =?us-ascii?Q?tjZMymCUWyFCzaG1+zBUd3ipYHPmx+Lg1iUmae2BgCXo7+hGcj8Oti6sab42?=
 =?us-ascii?Q?kZOYh1p8mdQJAIFm72gfs5pdyYXNlH7qcAGDmWeSjICu1TFmuSZhV+n0j39s?=
 =?us-ascii?Q?rebFgpLWvc5RFr01t3A=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e3c41b-3d81-44fe-ac19-08dd034663be
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 18:18:21.2333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DKqzn6nILOkU4gSMPlzDeaWey/DvbD9R8Y8OpuM0zx1PTqajbyPkXO0Sy1/NesYRDFzpGRFBoai4Cq8dcaJWhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR08MB10589

My 2 cents.

Overall, it seems to me that the difficulty here comes from 2 things:
1)  The write hints may have different semantics (temperature, FDP placemen=
t, and whatever will come next).
2) Different software layers may want to use the hints, and if several do t=
hat at the same time on the same storage that may result in a mess.

About 1)
Seems to me that having a different interface for each semantic is an overk=
ill, extra code to maintain.  And extra work when a new semantic comes alon=
g.
To keep things simple, keep one set of interfaces (per IO interface, per fi=
le interface) for all write hints semantics, and carry the difference in se=
mantic in the hint itself.
For example, with 32 bits hints, store the semantic in 8 bits and the use t=
he rest in the context of that semantic.
The storage transport driver (nvme driver for ex), based on the 8 bits sema=
ntic in the write hint, translates adequately the write hint for the storag=
e device.
The storage driver can support several translations, one for each semantics=
 supported. Linux doesn't need to yank out a translation to replace it with=
 a another/new one.

About 2)
Provide a simple way to the user to decide which layer generate write hints=
.
As an example, as some of you pointed out, what if the filesystem wants to =
generate write hints to optimize its [own] data handling by the storage, an=
d at the same time the application using the FS understand the storage and =
also wants to optimize using write hints.
Both use cases are legit, I think.
To handle that in a simple way, why not have a filesystem mount parameter e=
nabling/disabling the use of write hints by the FS?
In the case of an application not needing/wanting to use write hints on its=
 own, the user would mount the filesystem enabling generation of write hint=
s. That could be the default.
On the contrary if the user decides it is best for one application to direc=
tly generate write hints to get the best performance, then mount the filesy=
stem disabling the generation of write hints by the FS. The FS act as a pas=
sthrough regarding write hints.

Regards,

Pierre
> -----Original Message-----
> From: Keith Busch <kbusch@kernel.org>
> Sent: Tuesday, November 12, 2024 6:26 AM
> To: Christoph Hellwig <hch@lst.de>
> Cc: Kanchan Joshi <joshi.k@samsung.com>; Keith Busch
> <kbusch@meta.com>; linux-block@vger.kernel.org; linux-
> nvme@lists.infradead.org; linux-scsi@vger.kernel.org; linux-
> fsdevel@vger.kernel.org; io-uring@vger.kernel.org; axboe@kernel.dk;
> martin.petersen@oracle.com; asml.silence@gmail.com;
> javier.gonz@samsung.com
> Subject: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi stre=
ams
>=20
> CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unless yo=
u
> recognize the sender and were expecting this message.
>=20
>=20
> On Tue, Nov 12, 2024 at 02:34:39PM +0100, Christoph Hellwig wrote:
> > On Tue, Nov 12, 2024 at 06:56:25PM +0530, Kanchan Joshi wrote:
> > > IMO, passthrough propagation of hints/streams should continue to
> > > remain the default behavior as it applies on multiple filesystems.
> > > And more active placement by FS should rather be enabled by some opt
> > > in (e.g., mount option). Such opt in will anyway be needed for other
> > > reasons (like regression avoidance on a broken device).
> >
> > I feel like banging my head against the wall.  No, passing through
> > write streams is simply not acceptable without the file system being
> > in control.  I've said and explained this in detail about a dozend
> > times and the file system actually needing to do data separation for
> > it's own purpose doesn't go away by ignoring it.
>=20
> But that's just an ideological decision that doesn't jive with how people=
 use
> these. The applications know how they use their data better than the
> filesystem, so putting the filesystem in the way to force streams look li=
ke zones
> is just a unnecessary layer of indirection getting in the way.


