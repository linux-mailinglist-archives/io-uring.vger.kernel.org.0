Return-Path: <io-uring+bounces-3651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC2699C3C1
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 10:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D55CB23EEB
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 08:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EEFA14EC5D;
	Mon, 14 Oct 2024 08:42:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78B61494A5
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728895367; cv=none; b=PNs+Z35J1/6vNPiE5u2JmlJpSOMrvgEm9t+Xjbl9Zw7cIXQ80Fjxe5hCjOZZPLmp9FnqvQwyvwCUgmFHe7SF49s8hH0EIHqqE8hVJtc5Psxg1BY7bE6Rdopv4+gWkXk2prDwIg3ZLthBSXAgzH8YdWC9EAW1PxHHNxmseuafjsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728895367; c=relaxed/simple;
	bh=5yHjcG23l2RiY+X6SeesaOy4Cjp/tQ5jwtipApmb/RA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=NKJVJsXQaFghriSoRZ/azVgELaoua37Py1Ozhd5ibfpGtONfbUmOpfBNjugEWIyJoCe88IanBKoUGKAI22i6yI4hzD7KvHG8wPWSqSwT9AmwMstZZ9PbAexVzRmyZUX4ZwAKGYBX1hsT2C9VvmFDJ/3CtXSZhzfPoAYybvbkEsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-237-As3E12owNUiKpRqDsAirYw-1; Mon, 14 Oct 2024 09:42:43 +0100
X-MC-Unique: As3E12owNUiKpRqDsAirYw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 14 Oct
 2024 09:42:42 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 14 Oct 2024 09:42:42 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Jens Axboe' <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>, "David
 Wei" <dw@davidwei.uk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: RE: [PATCH v1 00/15] io_uring zero copy rx
Thread-Topic: [PATCH v1 00/15] io_uring zero copy rx
Thread-Index: AQHbGz/uyU8SPZfot0qITi1hCcBR0bKF8pRg
Date: Mon, 14 Oct 2024 08:42:41 +0000
Message-ID: <bee3c385d0af490ea0dc92adeba67dfb@AcuMS.aculab.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
 <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
 <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
 <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
 <57391bd9-e56e-427c-9ff0-04cb49d2c6d8@kernel.dk>
 <d0ba9ba9-8969-4bf6-a8c7-55628771c406@kernel.dk>
 <b8fd4a5b-a7eb-45a7-a2f4-fce3b149bd5b@kernel.dk>
 <7f8c6192-3652-4761-b2e3-8a4bddb71e29@kernel.dk>
 <9bbab76f-70db-48ef-9dcc-7fedd75582cb@kernel.dk>
In-Reply-To: <9bbab76f-70db-48ef-9dcc-7fedd75582cb@kernel.dk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

Li4uDQo+ID4gVGFwIHNpZGUgc3RpbGwgYSBteXN0ZXJ5LCBidXQgaXQgdW5ibG9ja2VkIHRlc3Rp
bmcuIEknbGwgZmlndXJlIHRoYXQNCj4gPiBwYXJ0IG91dCBzZXBhcmF0ZWx5Lg0KPiANCj4gRnVy
dGhlciB1cGRhdGUgLSB0aGUgYWJvdmUgbXlzdGVyeSB3YXMgZGhjbGllbnQsIHRoYW5rcyBhIGxv
dCB0byBEYXZpZA0KPiBmb3IgYmVpbmcgYWJsZSB0byBmaWd1cmUgdGhhdCBvdXQgdmVyeSBxdWlj
a2x5Lg0KDQpJJ3ZlIHNlZW4gdGhhdCBiZWZvcmUgLSBvbiB0aGUgcnggc2lkZS4NCklzIHRoZXJl
IGFueSB3YXkgdG8gZGVmZXIgdGhlIGNvcHkgdW50aWwgdGhlIHBhY2tldCBwYXNzZXMgYSBmaWx0
ZXI/DQpPciBiZXR0ZXIgdGVhY2ggZGhjcCB0byB1c2UgYSBub3JtYWwgVURQIHNvY2tldD8/DQoN
CglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwg
TW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzog
MTM5NzM4NiAoV2FsZXMpDQo=


