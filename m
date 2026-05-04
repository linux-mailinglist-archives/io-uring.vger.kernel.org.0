Return-Path: <io-uring+bounces-13222-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJIVGIpJ+GlMsQIAu9opvQ
	(envelope-from <io-uring+bounces-13222-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:23:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5034B94D0
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6BCBA3001598
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 07:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9C82DBF76;
	Mon,  4 May 2026 07:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b="felCcfd8"
X-Original-To: io-uring@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013051.outbound.protection.outlook.com [40.107.44.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183BA277C96;
	Mon,  4 May 2026 07:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777879426; cv=fail; b=baZ9QbBQvPCZLz0pJVVQVAOxc6OFUtM9r7ovnJEf0HWdTlW3Q/KFMFNgqjPRRaN3j4+3GoA2Wn98ptMw37cISjXX38njLytixCI3kd7+LSQe6Y4ebrDUjqrFBYAtG0CR7S8xz6qAnG6Zn523mnCU2cgd8hhCzV8miAMeB2f9KhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777879426; c=relaxed/simple;
	bh=xV1IIgybr9C+O+Bqj2zi1Bq+9L7+tmgqK1uXZxTpRBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ga/wD+39ohrgsevmUriClWZmuq1cbLvI5QcrCkJoPNCRGIMsukvoMnzI8Wgao0mZDuPlXb5l1+i/I2dYr4+9Seluxn57jhjdJ5LIoyov4Hjy0XN/YZ+dFZVgjmeKB8uN1RrYPYI0nX3epWWb0BOpk4+Tmr9aEemrv4cUkpZK11Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg; spf=pass smtp.mailfrom=ntu.edu.sg; dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b=felCcfd8; arc=fail smtp.client-ip=40.107.44.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ntu.edu.sg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vR86WutbGnlMPEuVUEGEO088/UEGtSbQBoCep7mROacKqnnct8NricZb1kcoeybS/yqiLYuHdpryEW4sp+iVuCQJ9PyvZR6RIQ8Wt1OKX7QCWY5389Gm2m7v5NqRdHN4oK24CFwaJyl7sQE44e/8TO/fr2e+6Tlq5zH1J/s3aC4NaaTcsuoaGFBgeqvtmbLDyA/2iKowYildVeZPfTEmggKrZ1JBk+N+df/RQ/MgskAitt2u81QLSVonf10KqkhjOKzBQ99x128OyaTP3W6JOj1u7V7nJhnXjrI+hFnAK6uP/Mm1rLo06DtKceIgf3jXwMt2mwUaKQkkviUPDMzT4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YczqJDIox1xs+w/alkChwOuPxSQbEyXOLYzyudnvkAE=;
 b=J//c6ldJ7hl98A0ZgGTMBleS3b1BzykDAm5DhqeqIQSd9Jf9bowtaOvUzLR1XfPhzUeal/zUV6R7wrAGC2ldEOYK0FcFw7GcQQBu/npceloGVP3Wz9MUPyn/XT7XA5SfeaQGd7lT29fVTqbUZlIBA0ju4Xq4/gOAciKPh0/uW6B/ka4crJza8gqBbVjbUj4iLNXgHHexImpyQBeemtzoswHBPWcKtDdjTGpUgC7b+QVWFsD9RHHQ2Zi6XjCNhhNv7M41N1zNoXLSmnSLuW8WbiOc44WDEkkC+LxlP8HKjhiXGrimoq+50H+vNAXFDF5zEkpU4oKrXi1xSAZ9iw1QPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ntu.edu.sg; dmarc=pass action=none header.from=ntu.edu.sg;
 dkim=pass header.d=ntu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YczqJDIox1xs+w/alkChwOuPxSQbEyXOLYzyudnvkAE=;
 b=felCcfd8JFximbHFIRC/FLZA+KsK2VJBiEmugEy+NaIV7KlguUjKGC+sXJjM6OqM9JNf8vkFzKcIqxrg6OmEgfyDNqQeiHHqtiimuCJSB1Ev+/dV3UBaKI28tZjzYoZkyuuluQ1iEPh6m6f/XYyQQWGi94Q9u98xWu5BeZc/XAGgIj0DGEiaQMCwQwZMYSTm2qJSUTK9FP/0ESyl/PGuRw7VYyuvisd1Nkycr2FsN8WtziyFjr+nC4rZU5taVroAAu8wtQQxxG3kmdw/kxk/DVZ9yxxpcpemRAmkvXVClVnlxhRZt+zU6kIlAR3R0JvD3+hWkT1NMeo+wO5MTPmkFg==
Received: from OS8PR01MB6749.apcprd01.prod.exchangelabs.com
 (2603:1096:604:28b::10) by SEYPR01MB4391.apcprd01.prod.exchangelabs.com
 (2603:1096:101:5f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 07:23:40 +0000
Received: from OS8PR01MB6749.apcprd01.prod.exchangelabs.com
 ([fe80::2aaf:ec6:ef03:639c]) by OS8PR01MB6749.apcprd01.prod.exchangelabs.com
 ([fe80::2aaf:ec6:ef03:639c%3]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 07:23:40 +0000
From: Xie Maoyi <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
CC: Andrei Vagin <avagin@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
Thread-Topic: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
Thread-Index: AQHc2gC1O+evKeW+H0uOkX1nIKwMBrX6iDUAgAAZu8qAAca854AA+58AgAAVbdQ=
Date: Mon, 4 May 2026 07:23:40 +0000
Message-ID:
 <OS8PR01MB674993B75C46D1763F925ADDDC312@OS8PR01MB6749.apcprd01.prod.exchangelabs.com>
References:
 <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
In-Reply-To: <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ntu.edu.sg;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS8PR01MB6749:EE_|SEYPR01MB4391:EE_
x-ms-office365-filtering-correlation-id: 1c7740ed-3eff-4398-7ce6-08dea9ae10e8
x-o365: NTU-OFF365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|366016|1800799024|376014|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 OZ4Ksz5WDGq5DkZN5H4DyskOmniD7FxOWheK4AnG1U2AGT8jl2r2y3mWqmftOqbVfKB7Sz2m851h+7o8acv5P/zxlgW4A5gyEWVpnFNxfgX/jM+t786ZgLrwDrEMfmsNLsIvdEhwOKTOSIoMLuniOaRmqsihA4iaPXYAIlgtkUAR8G+SemXTT6jT8wDEHI/l7X0zFv8+/GDk0FICWTKhhtD0SpGh330PV9Y51UQxOaCn/gaDfPHw+psEFHwMvBiKcjuJLYmDQi7ZVK6sqZGl/+5NNwERsOkqmVo1O7Tb8ELp47UR3uJksqVX9FKyXJGOnguGZcJNeHhx60KNws4X7mm0KuGUnfamEV6u7l/1REFv/aDCf5zmFuvWcY6my40KFYcSh5RKeqo1PUv5EEb9MZ1YF28rr83cjz7rRrw0G1UKk3fnABjofm3IKMu/aJ+9LszKBnIMfJHo1pLKo3cn6RgY6wtWrm9pBWr9LmG5qD+L8Y/lGb/tRBOdFcj/r9sqYio4gtIXJizZSvTDF8Ie1AF9f1IS3bRNn5dW/HUTG0ZhROkxMHORlcffODjzwbdXns6jyw6Bq2F3PK8om2YBeUQyHnZOlXcEt6VnCwwqTsA7CJknP/0KO5GeMqwBXDnA2+YkCHOdphpnJ2kENybHCe7ulooMQoMLX26XM/BdL368Z2dmCfRG8bW7aHvBb0Co
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS8PR01MB6749.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?mGqIgH8pfVCWSksIMi6S0fWRon+WEyyzBCut6f+M30rNjGq3dX/llJh7Tm?=
 =?iso-8859-1?Q?e9hoQ89y0bUIrDHvFCJwdpOwaI7h9Gwy0tUODwm8X5NTGT9k7mkvaTQzhx?=
 =?iso-8859-1?Q?vouje8zzw+svpnfGFmNJTq1EMJBHAcXC7UL8cxen9Mc8iFPXFV6bkXftCf?=
 =?iso-8859-1?Q?UQYYBYjEpscGWRhmZJhszR7AnA9lTJiU3S9eEqKnl5oZykXaJhAeYRGaI4?=
 =?iso-8859-1?Q?qpRcA7M4QxGIP+u8MSqL9G+QovpxzgXrnEVdW7bRQsXluAmlouG6RiCPFY?=
 =?iso-8859-1?Q?h3oFoXXduLGthfj5DdWTQ5SHo3rcnPn8dxzHFQdC0uoXcNSbk09UjRZwHy?=
 =?iso-8859-1?Q?IipVEsVKCWj0TiU6FB10xNRmZKTANW48SsG8eL0JturxuHYZsO9hNpacid?=
 =?iso-8859-1?Q?oJz0qf02/5pn11xFeZdzsgtPVOEA6DWt1PbngTzZNao5Q5QvYhjv3N4k/R?=
 =?iso-8859-1?Q?woEfEKJ7A6mU8rNZrGEQoWBMftn3+nYg4uGm5ZTZD6KvVn9D+xIR9OmF7r?=
 =?iso-8859-1?Q?vVKYYJGYZKoZbEx273jeG9IqSBGwfot2LHS+YIf8hBmhj4Onw6lw/ozVPe?=
 =?iso-8859-1?Q?YVvrr0uwBvwjQSX9gUfPcdmTzy3hTAuKw7Bqql6MqcGo0z6HeBI+f2dQDE?=
 =?iso-8859-1?Q?xMiNS16szNmgbHY6UgV6oLqbYlMc8BqjayMm/6NZ8qtYMAtbrklx03qoeR?=
 =?iso-8859-1?Q?1mTOIaM0ZoHDoIPbIz1bJApdSIHXfye56OK1cwPzzS1BvfXlALLmJ+Jy/Y?=
 =?iso-8859-1?Q?gG7R61yYSPsE5VLLYLwYC/j/MDZb8tJpc7SlNF/ZIWcyUiv8xYnphngniP?=
 =?iso-8859-1?Q?4bWxhoNVd0oSaFLnb2fz9x8giyPzNvFvIF/BZ3M6Sa1cpSmdqZDnO4IbUL?=
 =?iso-8859-1?Q?twvA6//8FuoK+0wpmiBxtTuPkiawBzNeBUMOoPw+26isRp4tnI9Cr7sL6o?=
 =?iso-8859-1?Q?VIa4VBKkAgol6K1Ach1Q5nLGdqzTtfvR0IPrHHDfxrrM/JvKMh+2PRmke6?=
 =?iso-8859-1?Q?DW27EKrWV3a5WS1fbRkWnx2i1K55dsuT7Vcvtk9mu+1bDtX/E/qq8wuRx9?=
 =?iso-8859-1?Q?itDqkD8tISmbS0rD5MbJji2f5AU+DEQycIzNUEYSXK4HT9GgagZOb4rXqj?=
 =?iso-8859-1?Q?sSZ8AkZMZ+/TmeNbKFoMJ1LaPnvWftldot91WTM36wDz4x2W+89pyn8E5h?=
 =?iso-8859-1?Q?Kc3JMb+h7pnmvtmCLqSZfuUmQ3lPRvljvNFxpXgZiEa8mwFuicvv9GWv5F?=
 =?iso-8859-1?Q?howj2nV77VBIlICdYH8CS6jbIwynyV2d8g/PLXMkaKEXwg/+6P8w24g8uD?=
 =?iso-8859-1?Q?iwSYzsHNRoQBGrel2fidnGIP6heOMMLBXps66MxyAx2PTcavA5tX5VtkDp?=
 =?iso-8859-1?Q?MzvqXczcand+uqW1AVog+rqFQrF8YG/K9oFcZJ9Ky3dLQFGJhjER4Cqp8a?=
 =?iso-8859-1?Q?RyPFwK/Lv9isb1oAz4VYAuy2DZSDZGlwaXwjfJpqwE5rlnL5K4zrl245L4?=
 =?iso-8859-1?Q?DdpeeEEKDi378+nJJNgBzfEz0GonmZ03Vtv7vzs/EbEFG+iuUJSajVhifw?=
 =?iso-8859-1?Q?j3WOF+kPJpbaceN1MEGsdIkuj+3GqgDjWdxQt5/Gsiu7geR/NSOttPbWlY?=
 =?iso-8859-1?Q?iDbEyLEnOzqkkh+8rR6V5kHiVI5lz5FKnFZaw6A1rftPLipkGzre+jP2iW?=
 =?iso-8859-1?Q?VSDdmnxNYBWeD4vZO5U/CwWcKJXrAe0IMyZ9K/zHpOMthljXFUL1AEqo0m?=
 =?iso-8859-1?Q?zr0MJ9qg+eLBexdJd+vq8DSQTTMdgSFxjoU1O5qI54vTleNDeH2d3GUyec?=
 =?iso-8859-1?Q?jmgpDLkgDxQJyfMSne4xNjwMkMM9y5c=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ntu.edu.sg
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS8PR01MB6749.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7740ed-3eff-4398-7ce6-08dea9ae10e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2026 07:23:40.5674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 15ce9348-be2a-462b-8fc0-e1765a9b204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GNGicZ7mJ1dNdVprUJb3q83ADzvrVJwJV8tjdHwBjdNToGjj4ZWRuk1GcPVBdfJB3KnXZFjf25z7tvOUJFLC8N/Rnh6hWrMXA5jeXwWmB4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR01MB4391
X-Rspamd-Queue-Id: 0E5034B94D0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ntu.edu.sg,quarantine];
	R_DKIM_ALLOW(-0.20)[ntu.edu.sg:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13222-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyi.xie@ntu.edu.sg,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ntu.edu.sg:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[OS8PR01MB6749.apcprd01.prod.exchangelabs.com:mid]

On 5/3/26, Jens Axboe wrote:
> Might make sense to refactor a helper that does the time translation,
> and then patch 1 would basically be Pavel's fix and patch 2 would be
> sorting out the io_cqring_wait() translation as well. Both should be
> able to use the refactored helper.

Understood. I will prepare a 2-patch series along those lines:

  1/2 io_uring: introduce io_timens_to_host_ktime() helper and apply
        it in IORING_OP_TIMEOUT / IORING_OP_LINK_TIMEOUT (=3D Pavel's
        fix for io_parse_user_time).

  2/2 io_uring: route io_uring_enter()'s IORING_ENTER_ABS_TIMER path
        through the same helper (covers io_uring/wait.c around the
        ext_arg->ts parse).

Could you point me at the right base to develop on top of? Pavel's
draft uses io_parse_user_time which is not in v7.0 mainline, so I
assume the target is one of the io_uring trees (for-next?). I will
also re-run the SQPOLL and ABS_TIMER reproducers against the
series before sending.

Best regards,
Maoyi
Nanyang Technological University
https://maoyixie.com/
________________________________

CONFIDENTIALITY: This email is intended solely for the person(s) named and =
may be confidential and/or privileged. If you are not the intended recipien=
t, please delete it, notify us and do not copy, use, or disclose its conten=
ts.
Towards a sustainable earth: Print only when necessary. Thank you.

