Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53491A28F0
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 20:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgDHS6F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 14:58:05 -0400
Received: from taper.sei.cmu.edu ([147.72.252.16]:34498 "EHLO
        taper.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgDHS6E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 14:58:04 -0400
Received: from delp.sei.cmu.edu (delp.sei.cmu.edu [10.64.21.31])
        by taper.sei.cmu.edu (8.14.7/8.14.7) with ESMTP id 038Iw2lN015578;
        Wed, 8 Apr 2020 14:58:02 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 taper.sei.cmu.edu 038Iw2lN015578
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cert.org;
        s=yc2bmwvrj62m; t=1586372282;
        bh=nDGwARLz6IzT4e2hihxcIa84jDbOOqw1v9YebUxCeRM=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=GdiAiX5CrfyK2G8N9XAoHJPVNUDEWCoftyMzxMqWydCzr1W2LOLWyMRT9bFgaMKVM
         CO6laUIOQ5Wm7R8wMZQaw4x2DK8ZmkgR8MywLxAYSwuSnU0nSCj7jCZlMRwzatZOa2
         foy3OHzbOyB2eyrBaO09TRX+sx22wC2jylccaJak=
Received: from CASCADE.ad.sei.cmu.edu (cascade.ad.sei.cmu.edu [10.64.28.248])
        by delp.sei.cmu.edu (8.14.7/8.14.7) with ESMTP id 038IvvTr028408;
        Wed, 8 Apr 2020 14:57:57 -0400
Received: from MORRIS.ad.sei.cmu.edu (147.72.252.46) by CASCADE.ad.sei.cmu.edu
 (10.64.28.248) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 8 Apr
 2020 14:57:57 -0400
Received: from MORRIS.ad.sei.cmu.edu (147.72.252.46) by MORRIS.ad.sei.cmu.edu
 (147.72.252.46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Wed, 8 Apr 2020
 14:57:56 -0400
Received: from MORRIS.ad.sei.cmu.edu ([fe80::555b:9498:552e:d1bb]) by
 MORRIS.ad.sei.cmu.edu ([fe80::555b:9498:552e:d1bb%22]) with mapi id
 15.01.1847.007; Wed, 8 Apr 2020 14:57:56 -0400
From:   Joseph Christopher Sible <jcsible@cert.org>
To:     "'Jens Axboe'" <axboe@kernel.dk>,
        "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: RE: Spurious/undocumented EINTR from io_uring_enter
Thread-Topic: Spurious/undocumented EINTR from io_uring_enter
Thread-Index: AdYNHCB8t2qqN/asQKmA7dRl2D+7cwAKrhOAAB25dbAADHSFgAAGsldQ
Date:   Wed, 8 Apr 2020 18:57:56 +0000
Message-ID: <00c3981899fd44ff9727cf36494992e0@cert.org>
References: <43b339d3dc0c4b6ab15652faf12afa30@cert.org>
 <b9ee42f0-cd94-9410-0de1-1bbfd50a6040@kernel.dk>
 <d8a2a9fe86974f999cb41f0b17f9e9a7@cert.org>
 <12cca225-d95c-da61-fdba-f69427a2726f@kernel.dk>
In-Reply-To: <12cca225-d95c-da61-fdba-f69427a2726f@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.64.23]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC84LzIwIDE6NDkgUE0sIEplbnMgQXhib2Ugd3JvdGU6DQo+IE9uIDQvOC8yMCA5OjQxIEFN
LCBKb3NlcGggQ2hyaXN0b3BoZXIgU2libGUgd3JvdGU6DQo+ID4gT24gNC83LzIwIDU6NDIgUE0s
IEplbnMgQXhib2Ugd3JvdGU6DQo+ID4+IExvdHMgb2Ygc3lzdGVtIGNhbGxzIHJldHVybiAtRUlO
VFIgaWYgaW50ZXJydXB0ZWQgYnkgYSBzaWduYWwsIGRvbid0DQo+ID4+IHRoaW5rIHRoZXJlJ3Mg
YW55dGhpbmcgd29ydGggZml4aW5nIHRoZXJlLiBGb3IgdGhlIHdhaXQgcGFydCwgdGhlDQo+ID4+
IGFwcGxpY2F0aW9uIG1heSB3YW50IHRvIGhhbmRsZSB0aGUgc2lnbmFsIGJlZm9yZSB3ZSBjYW4g
d2FpdCBhZ2Fpbi4NCj4gPj4gV2UgY2FuJ3QgZ28gdG8gc2xlZXAgd2l0aCBhIHBlbmRpbmcgc2ln
bmFsLg0KPiA+DQo+ID4gVGhpcyBzZWVtcyB0byBiZSBhbiB1bmFtYmlndW91cyBidWcsIGF0IGxl
YXN0IGFjY29yZGluZyB0byB0aGUgQlVHUw0KPiA+IHNlY3Rpb24gb2YgdGhlIHB0cmFjZSBtYW4g
cGFnZS4gVGhlIGJlaGF2aW9yIG9mIGVwb2xsX3dhaXQgaXMNCj4gPiBleHBsaWNpdGx5IGNhbGxl
ZCBvdXQgYXMgYmVpbmcgYnVnZ3kvd3JvbmcsIGFuZCB3ZSdyZSBlbXVsYXRpbmcgaXRzDQo+ID4g
YmVoYXZpb3IuIEFzIGZvciB0aGUgYXBwbGljYXRpb24gd2FudGluZyB0byBoYW5kbGUgdGhlIHNp
Z25hbCwgaW4NCj4gPiB0aG9zZSBjYXNlcywgaXQgd291bGQgY2hvb3NlIHRvIGluc3RhbGwgYSBz
aWduYWwgaGFuZGxlciwgaW4gd2hpY2gNCj4gPiBjYXNlIEkgYWJzb2x1dGVseSBhZ3JlZSB0aGF0
IHJldHVybmluZyAtRUlOVFIgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvDQo+ID4gZG8uIEknbSBvbmx5
IHRhbGtpbmcgYWJvdXQgdGhlIGNhc2Ugd2hlcmUgdGhlIGFwcGxpY2F0aW9uIGRpZG4ndA0KPiA+
IGNob29zZSB0byBpbnN0YWxsIGEgc2lnbmFsIGhhbmRsZXIgKGFuZCB0aGUgc2lnbmFsIHdvdWxk
IGhhdmUgYmVlbg0KPiA+IGNvbXBsZXRlbHkgaW52aXNpYmxlIHRvIHRoZSBwcm9jZXNzIGhhZCBp
dCBub3QgYmVlbiBiZWluZyB0cmFjZWQpLg0KPiANCj4gU28gd2hhdCBkbyB5b3Ugc3VnZ2VzdD8g
VGhlIG9ubHkgcmVjdXJzZSB0aGUga2VybmVsIGhhcyBpcyB0byBmbHVzaCBzaWduYWxzLA0KPiB3
aGljaCB3b3VsZCBqdXN0IGRlbGV0ZSB0aGUgc2lnbmFsIGNvbXBsZXRlbHkuIEl0J3MgYSB3YWl0
IG9wZXJhdGlvbiwgYW5kIHlvdQ0KPiBjYW5ub3Qgd2FpdCB3aXRoIHNpZ25hbHMgcGVuZGluZy4g
VGhlIG9ubHkgd2FpdCB0byByZXRyeSBpcyB0byByZXR1cm4gdGhlDQo+IG51bWJlciBvZiBldmVu
dHMgd2UgYWxyZWFkeSBnb3QsIG9yIC1FSU5UUiBpZiB3ZSBnb3Qgbm9uZSwgYW5kIHJldHVybiB0
bw0KPiB1c2Vyc3BhY2UuIFRoYXQnbGwgZW5zdXJlIHRoZSBzaWduYWwgZ2V0cyBoYW5kbGVkLCBh
bmQgdGhlIGFwcCBtdXN0IHRoZW4gY2FsbA0KPiB3YWl0IGFnYWluIGlmIGl0IHdhbnRzIHRvIHdh
aXQgZm9yIG1vcmUuDQo+IA0KPiBUaGVyZSdzIG5vICJlbXVsYXRpbmcgYmVoYXZpb3IiIGhlcmUs
IHlvdSBtYWtlIGl0IHNvdW5kIGxpa2Ugd2UncmUgdHJ5aW5nIHRvDQo+IGJlIGJ1ZyBjb21wYXRp
YmxlIHdpdGggc29tZSByYW5kb20gb3RoZXIgc3lzdGVtIGNhbGwuDQo+IFRoYXQncyBub3QgdGhl
IGNhc2UgYXQgYWxsLg0KDQpTb3JyeSwgSSB1c2VkICJlbXVsYXRpbmciIGluIHRoZSBpbmZvcm1h
bCBzZW5zZS4gSSBqdXN0IG1lYW50IHRoYXQgd2UNCmhhcHBlbiB0byBoYXZlIHRoZSBzYW1lIGJ1
ZyB0aGF0IGVwb2xsX3dhaXQgZG9lcywgdGhhdCBtb3N0IG90aGVyDQpzeXNjYWxscyBkb24ndC4g
QW55d2F5LCBJJ2QgbGlrZSBpdCB0byB3b3JrIGxpa2UgdGhlIHNlbGVjdCBzeXNjYWxsDQp3b3Jr
cy4gQ29uc2lkZXIgdGhpcyBwcm9ncmFtOg0KDQojaW5jbHVkZSA8c2lnbmFsLmg+DQojaW5jbHVk
ZSA8c3RkaW8uaD4NCiNpbmNsdWRlIDxzeXMvc2VsZWN0Lmg+DQojaW5jbHVkZSA8dW5pc3RkLmg+
DQoNCnZvaWQgaGFuZGxlKGludCBzKSB7DQogIHdyaXRlKDEsICJJbiBzaWduYWwgaGFuZGxlclxu
IiwgMTgpOw0KfQ0KDQppbnQgbWFpbih2b2lkKSB7DQogIHN0cnVjdCBzaWdhY3Rpb24gYWN0ID0g
eyAuc2FfaGFuZGxlciA9IGhhbmRsZSB9Ow0KICBzdHJ1Y3QgdGltZXZhbCB0ID0geyAudHZfc2Vj
ID0gMTAgfTsNCiAgZmRfc2V0IHNldDsNCiAgRkRfWkVSTygmc2V0KTsNCiAgc2lnYWN0aW9uKFNJ
R1VTUjEsICZhY3QsIE5VTEwpOw0KICBzZWxlY3QoMCwgTlVMTCwgTlVMTCwgTlVMTCwgJnQpOw0K
ICBwZXJyb3IoInNlbGVjdCIpOw0KICByZXR1cm4gMDsNCn0NCg0KWW91IGNhbiBkbyBhbnkgb2Yg
dGhlIGZvbGxvd2luZyB0byB0aGF0IHByb2dyYW0gYW5kIGl0IHdpbGwgc3RpbGwgZmluaXNoDQpp
dHMgZnVsbCAxMCBzZWNvbmRzIGFuZCBvdXRwdXQgIlN1Y2Nlc3MiOg0KDQoqIFN0b3AgaXQgd2l0
aCBDdHJsK1ogdGhlbiByZXN1bWUgaXQgd2l0aCBmZw0KKiBBdHRhY2ggdG8gaXQgd2l0aCBzdHJh
Y2Ugb3IgZ2RiIHdoaWxlIGl0J3MgYWxyZWFkeSBydW5uaW5nDQoqIFN0YXJ0IGl0IHVuZGVyIHN0
cmFjZSBvciBnZGIsIHRoZW4gcmVzaXplIHRoZSB0ZXJtaW5hbCB3aW5kb3cgd2hpbGUNCiAgaXQn
cyBydW5uaW5nDQoNClRoZSBvbmx5IHRoaW5nIHRoYXQgaXQgd2lsbCBtYWtlIGl0IG91dHB1dCAi
SW50ZXJydXB0ZWQgc3lzdGVtIGNhbGwiIGlzDQppZiB5b3UgImtpbGwgLVVTUjEiIGl0LCByZXN1
bHRpbmcgaW4gaXRzIHNpZ25hbCBoYW5kbGVyIGJlaW5nIGNhbGxlZC4gSXQNCmxvb2tzIGxpa2Ug
d2hhdCdzIGhhcHBlbmluZyBpcyB0aGF0IHRoZSBzeXNjYWxsIHJlYWxseSBpcyBnZXR0aW5nDQpz
dG9wcGVkIGJ5IHRoZSBvdGhlciBzaWduYWxzLCBidXQgb25jZSB0aGUga2VybmVsIGRldGVybWlu
ZXMgdGhhdCB0aGUNCnByb2Nlc3MgaXNuJ3QgZ29pbmcgdG8gc2VlIHRoYXQgcGFydGljdWxhciBz
aWduYWwsIGl0IHJlc3RhcnRzIHRoZQ0Kc3lzY2FsbCBmcm9tIHdoZXJlIGl0IGxlZnQgb2ZmIGF1
dG9tYXRpY2FsbHkuIEkgdGhpbmsgdGhpcyBpcyBob3cgYWxtb3N0DQphbGwgb2YgdGhlIHN5c2Nh
bGxzIGluIHRoZSBrZXJuZWwgd29yay4NCg0KSG93ZXZlciwgaWYgeW91IHJ1biBhIHNpbWlsYXIg
cHJvZ3JhbSB0byB0aGF0IG9uZSwgYnV0IHRoYXQgdXNlcw0KaW9fdXJpbmdfZW50ZXIgaW5zdGVh
ZCBvZiBzZWxlY3QsIHRoZW4gZG9pbmcgYW55IG9mIHRoZSAzIHRoaW5ncyBvbiB0aGF0DQpsaXN0
IHdpbGwgbWFrZSBpdCBvdXRwdXQgIkludGVycnVwdGVkIHN5c3RlbSBjYWxsIiwgZXZlbiB0aG91
Z2ggbm8NCnNpZ25hbCBoYW5kbGVyIHJhbi4gVGhpcyBpcyB0aGUgYmVoYXZpb3IgdGhhdCBJJ20g
c2F5aW5nIGlzIGJ1Z2d5IGFuZA0Kc2ltaWxhciB0byBlcG9sbF93YWl0LCBhbmQgdGhhdCBJJ2Qg
bGlrZSB0byBzZWUgY2hhbmdlZC4NCg0KSm9zZXBoIEMuIFNpYmxlDQo=
