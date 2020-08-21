Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5797C24CD33
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 07:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgHUFVD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 01:21:03 -0400
Received: from mail-shaon0143.outbound.protection.partner.outlook.cn ([42.159.164.143]:43445
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbgHUFVB (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Aug 2020 01:21:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6VU8Bvy4iwtSoSte++U6kv4XeKahmRlZCY/r/mPJ2ryzPwDA7iUTgIkosLaWXNeUXY+0EdIU/uPVtU7XObXV1UAug4OhQUngeQG3YfbtxZoIrFIfKO52nIFUfvp6viRw1v9RSE8+kzqFZ2LnJkF+jvEU2vFlFBePnGZFsQ/n9GmXEGWbOd8ceWt5LnKTslt5p2PoXg1Zi2c7bqtmQMYixWWM/+CGsr9NCC6VU5nRT2h1IqmDeL61ok9Nc7owh6ZQORZ+oJczNBMVpE4tFH93pXFWH9k9fZRd1FLWbbXXeetl+gFXbtkadD9wXkp3hs26sCqd60x9PK+7EojHC9eNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWluLr3aiLqVQmS7PeQITlRdmIvgnICELyvj1YRRonM=;
 b=mKxCQyZCV2cKGg0KeDOmXJgFqoEoTIieTg0j6Wa9CUIGfZGqP+mHJdBp2beVFcJrCUDtCaQrUFBsu3v7qDE1H4XTe6p92koOagSb5ZokO4N4/WddQAq9oYKzt2Y1Kg9855lDXlVSkgc4F0WSBCf0tHiPI7igqDZ22fr2lrAekxbESfvYQquRkB4DemaVhdBrg13+g4giPPmg8S/A3cblgIZeopL4NGztoNMZ+r7WiZcEYvc21BUWq9iEvtASPhn4ouE/ouxC7uDLll2ZCO125EWmQpkTjI9omxStzfdVtTe6ug8be5BvbR0yj06mbavmF06k809Zb9AXK7Ab6Mx14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWluLr3aiLqVQmS7PeQITlRdmIvgnICELyvj1YRRonM=;
 b=TOPcFpykysSoeWRzLzcJlQwmXHD912qws+OHetZmFSXdnzsw5Pz7rh3WQAM9ggLtFBJqUobAPAO8N880UebUXvRvEn/qduwlDjIA8Nb0SXqx5bBdloHz54kCCSRkovETTIaNfeiqCERJA2PbL7sw/eM7n9C5jizPaOWeMqnf8HY=
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn (10.43.110.79) by
 SHXPR01MB0591.CHNPR01.prod.partner.outlook.cn (10.43.109.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Fri, 21 Aug 2020 05:20:54 +0000
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79])
 by SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79]) with mapi
 id 15.20.3305.027; Fri, 21 Aug 2020 05:20:54 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Re: Questions about IORING_OP_ASYNC_CANCEL usage
Thread-Topic: Questions about IORING_OP_ASYNC_CANCEL usage
Thread-Index: AQHWd3pWlsNdUyZFBU+QynpRff5tTqlCBrmA
Date:   Fri, 21 Aug 2020 05:20:53 +0000
Message-ID: <C78150AD-A5CB-4876-B5AA-BA737325F519@eoitek.com>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
 <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
 <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
 <1e733dd7-acd4-dde6-b3c5-c0ee0fbeda2a@gmail.com>
 <be37a342-9768-5d1e-8d80-6d3d28f236e8@kernel.dk>
 <9271f312-4863-fd3b-5ced-d200d68cfe22@gmail.com>
 <1B338A13-1D60-4E7A-94C4-BDF06F20975B@eoitek.com>
In-Reply-To: <1B338A13-1D60-4E7A-94C4-BDF06F20975B@eoitek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=eoitek.com;
x-originating-ip: [180.167.157.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9538687-ff5d-48fc-16f8-08d84591fa0b
x-ms-traffictypediagnostic: SHXPR01MB0591:
x-microsoft-antispam-prvs: <SHXPR01MB0591CBB2CD6B131487D68B2E945B0@SHXPR01MB0591.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G8imSpPy4Bfgnlh5gOLrW+mewecqvAwebq+FdspFOIVk65iK4knh9WhROtTWpXef/aXdSod67z/e54U4N2gXHTeGoOUF3+F1R74poohg6JoyCXqIZcg8cQvy09+eGr8FYzWSZMWo2rKLSahNkdzX8/5qMgpX0uYbdDS/RjIvHaE3J8y/V3t/WQ8O/uFHxTRpAvTCrJUGm6ImJCfEFIKt/c38OQRBTu0ZEVdC20wHav9zCMXyHZ+H1NLBbv5eKJBiUtU/1XUgH4jvSJ99mkPTg6lXsyqU3lkTKFPnpbwU/tslLX6jWcelHLIUo93hsd+Nd2ErNcIb3zoYaPyTH9nTDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(329002)(328002)(85182001)(95416001)(6916009)(4744005)(26005)(2906002)(5660300002)(8936002)(2616005)(8676002)(36756003)(186003)(508600001)(86362001)(59450400001)(66476007)(33656002)(66556008)(71200400001)(76116006)(83380400001)(66946007)(66446008)(64756008)(63696004)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: My/1jbN3PTEc2r3EOl5TxFlCQJ3eE1gXlrHUgF4TyDAMWrr98FHYdp4SpUQGIN6mC9eFveJvDj9Dc/mCy/21KHherJ4/dF8f91bRqMc1Y6R7LwU9qkH3Y79OzOnGmz16Zn5UmePm5t22tdc8nlAzuGPPXb+0uEA3ti6BbsS883tpbA0kXU7VNIAX/hkuxnK+l3nYsXIZoervF/a0ysk8oURV58fO58cElUJ8zIXkfPLbqokgaeYyvJlAQN/PAYGwIiYLTNfV9OiOeU3OtodDAGLyp88A5lo+WdjjDYtmgTCZvS8mtuaZAwSCCZE+85+85l8ZI020f9UBBXuXCAjQKdV2f3SQebchMQLrTNDNWeGzfWdOtCuHdQcOe/aEuZ0uH8Wgwdffsfv9ZFmbvnDqimrC8nrmtub8B9/BafyKDkjoDLicd+4A/gv8OdUF7h4PfOaMqZ1OTbYOc45O7k1KRrpN/Ds0MA2pmSVm0WFj5rsApcbhdJ3b0nEH9O6/N6Ro6ejAUTPoWxmA01P5xQFe4xllGQFg6RJNz/x2C962ckISU1NpQUylhrK/GR9aZULunvVdNyyzFszeQsp+G9WyUw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <64770A6F3FB20E41A95FDEFCC45A75DA@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: e9538687-ff5d-48fc-16f8-08d84591fa0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 05:20:53.9670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yb5cAkDhVWxZViSa3TTmqSp7UEnFnkFG9v20rLB5mcVfptr0kU8H8A9stKhDAbbLE8y94q2PXBqCXuRo0ji/zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0591
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

U29ycnksIHBsZWFzZSBpZ25vcmUgdGhpcyBtYWlsLCBJ4oCZbGwgc2VuZCBhIG5ldyBvbmUNCg0K
PiAyMDIw5bm0OOaciDIx5pelIOS4i+WNiDE6MTfvvIxDYXJ0ZXIgTGkg5p2O6YCa5rSyIDxjYXJ0
ZXIubGlAZW9pdGVrLmNvbT4g5YaZ6YGT77yaDQo+IA0KPiBIaSBKZW5zLA0KPiANCj4gSSBoYXZl
IHNvbWUgKCBtYXliZSBzdHVwaWQgKSBxdWVzdGlvbnMgYWJvdXQgSU9SSU5HX09QX0FTWU5DX0NB
TkNFTDoNCj4gDQo+IDEuIERvZXMgSU9SSU5HX09QX0FTWU5DX0NBTkNFTCBhbHdheXMgY29tcGxl
dGUgaW5saW5lICggaS5lLiBmaW5pc2hlcyBiZWZvcmUgdGhlIGlvX3VyaW5nX2VudGVyIHN5c2Nh
bGwgcmV0dXJucyApPw0KPiANCj4gMi4gRG9lcyByZWNlbnQgY2hhbmdlcyBvZiBhc3luYyBidWZm
ZXJlZCByZWFkcyBoYXZlIGFueSBpbXBhY3Qgd2l0aCBjYW5jZWxhdGlvbj8gQ2FuIHdlIGNhbmNl
bCBhIGJ1ZmZlcmVkIElPUklOR19PUF9SRUFEViBvcGVyYXRpb24gYWZ0ZXIgaXTigJlzIHN0YXJ0
ZWQ/IEFsdGhvdWdoIHRoZSBkaXNrLT5rZXJuZWwgRE1BIG9wZXJhdGlvbiBpcyBub3QgY2FuY2Vs
YWJsZSwgY2FuIHdlIGNhbmNlbCB0aGUga2VybmVsLT51c2VybGFuZCBkYXRhIGNvcHk/DQo+IA0K
PiAzLiBJIGhlYXJkIHRoYXQgYWxsIGJ1ZmZlcmVkIHdyaXRlcyBhcmUgc2VyaWFsaXplZCBvbiB0
aGUgaW5vZGUgbXV0ZXguIElmIGEgYnVmZmVyZWQgSU9SSU5HX09QX1dSSVRFViBpcyBibG9ja2Vk
IG9uIHRoZSBub2RlIG11dGV4LCBjYW4gd2UgY2FuY2VsIGl0Pw0KPiANCj4gVGhhbmtzIGluIGFk
dmFuY2UsDQo+IENhcnRlcg0KDQo=
