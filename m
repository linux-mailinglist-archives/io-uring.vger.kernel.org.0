Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C20F51C905
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 21:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384353AbiEETdq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 15:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbiEETdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 15:33:45 -0400
Received: from SJSMAIL01.us.kioxia.com (usmailhost21.kioxia.com [12.0.68.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4AE34652
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 12:30:04 -0700 (PDT)
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 12:30:04 -0700
Received: from SJSMAIL01.us.kioxia.com ([fe80::c557:f37d:d981:76df]) by
 SJSMAIL01.us.kioxia.com ([fe80::c557:f37d:d981:76df%3]) with mapi id
 15.01.2375.024; Thu, 5 May 2022 12:30:04 -0700
From:   Clay Mayers <Clay.Mayers@kioxia.com>
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        "hch@lst.de" <hch@lst.de>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>, "shr@fb.com" <shr@fb.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: RE: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Thread-Topic: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Thread-Index: AQHYYEffNsZGDQ8MAEyuOCh/GTUQpa0QnLIAgAB9pYCAAAIxAP//jjdA
Date:   Thu, 5 May 2022 19:30:03 +0000
Message-ID: <0b16682a30434d9c820a888ae0dc9ac5@kioxia.com>
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com>
 <20220505060616.803816-4-joshi.k@samsung.com>
 <80cde2cfd566454fa4b160492c7336c2@kioxia.com>
 <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk>
 <93e697b1-42c5-d2f4-8fb8-7b5d1892e871@kernel.dk>
In-Reply-To: <93e697b1-42c5-d2f4-8fb8-7b5d1892e871@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.93.77.13]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNS81LzIyIDEyOjExIFBNLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBPbiA1LzUvMjIgMTowMyBQ
TSwgSmVucyBBeGJvZSB3cm90ZToNCj4gPiBPbiA1LzUvMjIgMTI6MzcgUE0sIENsYXkgTWF5ZXJz
IHdyb3RlOg0KPiA+Pj4gRnJvbTogS2FuY2hhbiBKb3NoaQ0KPiA+Pj4gU2VudDogV2VkbmVzZGF5
LCBNYXkgNCwgMjAyMiAxMTowNiBQTQ0KPiA+Pj4gLS0tDQo+ID4+DQo+ID4+PiAgZHJpdmVycy9u
dm1lL2hvc3QvaW9jdGwuYyB8IDQ3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKyst
LS0NCj4gLS0NCj4gPj4+ICAxIGZpbGUgY2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgNSBkZWxl
dGlvbnMoLSkNCj4gPj4+DQo+ID4+PiArc3RhdGljIGludCBudm1lX2V4ZWN1dGVfdXNlcl9ycShz
dHJ1Y3QgcmVxdWVzdCAqcmVxLCB2b2lkIF9fdXNlcg0KPiA+Pj4gKm1ldGFfYnVmZmVyLA0KPiA+
Pj4gKwkJdW5zaWduZWQgbWV0YV9sZW4sIHU2NCAqcmVzdWx0KQ0KPiA+Pj4gK3sNCj4gPj4+ICsJ
c3RydWN0IGJpbyAqYmlvID0gcmVxLT5iaW87DQo+ID4+PiArCWJvb2wgd3JpdGUgPSBiaW9fb3Ao
YmlvKSA9PSBSRVFfT1BfRFJWX09VVDsNCj4gPj4NCj4gPj4gSSdtIGdldHRpbmcgYSBOVUxMIHB0
ciBhY2Nlc3Mgb24gdGhlIGZpcnN0DQo+IGlvY3RsKE5WTUVfSU9DVExfQURNSU42NF9DTUQpDQo+
ID4+IEkgc2VuZCAtIGl0IGhhcyBubyB1YnVmZmVyIHNvIEkgdGhpbmsgdGhlcmUncyBubyByZXEt
PmJpby4NCj4gPg0KPiA+IERvZXMgdGhpcyB3b3JrPw0KDQpJdCBkaWQgbm90ISAgU2FtZSBudWxs
IHB0ciBkZXJlZiBhdCBuZWFybHkgaWYgbm90IHRoZSBzYW1lIGxvY2F0aW9uLg0KSSBkaWRuJ3Qg
aW52ZXN0aWdhdGUgdG8gc2VlIHRoZSBsaW5lIG9mIGNvZGUgc2luY2UgeW91IGhhZCBzZW50IHYy
Lg0KDQo+IA0KPiBUaGlzIG1pZ2h0IGJlIGJldHRlciwgdGhvdWdoIHlvdSdkIG9ubHkgbm90aWNl
IGlmIHlvdSBoYWQgaW50ZWdyaXR5DQo+IGVuYWJsZWQuIENocmlzdG9waCwgSSdtIGZvbGRpbmcg
dGhpcyBpbiB3aXRoIHBhdGNoIDMuLi4NCj4gDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
dm1lL2hvc3QvaW9jdGwuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L2lvY3RsLmMNCj4gaW5kZXggOGZl
N2FkMThhNzA5Li4zZDgyNzc4OWI1MzYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0
L2lvY3RsLmMNCj4gKysrIGIvZHJpdmVycy9udm1lL2hvc3QvaW9jdGwuYw0KPiBAQCAtMjEsOSAr
MjEsMTMgQEAgc3RhdGljIHZvaWQgX191c2VyICpudm1lX3RvX3VzZXJfcHRyKHVpbnRwdHJfdCBw
dHJ2YWwpDQo+IA0KPiAgc3RhdGljIGlubGluZSB2b2lkICpudm1lX21ldGFfZnJvbV9iaW8oc3Ry
dWN0IGJpbyAqYmlvKQ0KPiAgew0KPiAtCXN0cnVjdCBiaW9faW50ZWdyaXR5X3BheWxvYWQgKmJp
cCA9IGJpb19pbnRlZ3JpdHkoYmlvKTsNCj4gKwlpZiAoYmlvKSB7DQo+ICsJCXN0cnVjdCBiaW9f
aW50ZWdyaXR5X3BheWxvYWQgKmJpcCA9IGJpb19pbnRlZ3JpdHkoYmlvKTsNCj4gDQo+IC0JcmV0
dXJuIGJpcCA/IGJ2ZWNfdmlydChiaXAtPmJpcF92ZWMpIDogTlVMTDsNCj4gKwkJcmV0dXJuIGJp
cCA/IGJ2ZWNfdmlydChiaXAtPmJpcF92ZWMpIDogTlVMTDsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1
cm4gTlVMTDsNCj4gIH0NCj4gDQo+ICAvKg0KPiBAQCAtMjA1LDE5ICsyMDksMjAgQEAgc3RhdGlj
IGludCBudm1lX2V4ZWN1dGVfdXNlcl9ycShzdHJ1Y3QgcmVxdWVzdCAqcmVxLA0KPiB2b2lkIF9f
dXNlciAqbWV0YV9idWZmZXIsDQo+ICAJCXVuc2lnbmVkIG1ldGFfbGVuLCB1NjQgKnJlc3VsdCkN
Cj4gIHsNCj4gIAlzdHJ1Y3QgYmlvICpiaW8gPSByZXEtPmJpbzsNCj4gLQlib29sIHdyaXRlID0g
YmlvX29wKGJpbykgPT0gUkVRX09QX0RSVl9PVVQ7DQo+IC0JaW50IHJldDsNCj4gIAl2b2lkICpt
ZXRhID0gbnZtZV9tZXRhX2Zyb21fYmlvKGJpbyk7DQo+ICsJaW50IHJldDsNCj4gDQo+ICAJcmV0
ID0gbnZtZV9leGVjdXRlX3Bhc3N0aHJ1X3JxKHJlcSk7DQo+IA0KPiAgCWlmIChyZXN1bHQpDQo+
ICAJCSpyZXN1bHQgPSBsZTY0X3RvX2NwdShudm1lX3JlcShyZXEpLT5yZXN1bHQudTY0KTsNCj4g
LQlpZiAobWV0YSAmJiAhcmV0ICYmICF3cml0ZSkgew0KPiAtCQlpZiAoY29weV90b191c2VyKG1l
dGFfYnVmZmVyLCBtZXRhLCBtZXRhX2xlbikpDQo+ICsJaWYgKG1ldGEpIHsNCj4gKwkJYm9vbCB3
cml0ZSA9IGJpb19vcChiaW8pID09IFJFUV9PUF9EUlZfT1VUOw0KPiArDQo+ICsJCWlmICghcmV0
ICYmICF3cml0ZSAmJiBjb3B5X3RvX3VzZXIobWV0YV9idWZmZXIsIG1ldGEsDQo+IG1ldGFfbGVu
KSkNCj4gIAkJCXJldCA9IC1FRkFVTFQ7DQo+ICsJCWtmcmVlKG1ldGEpOw0KPiAgCX0NCj4gLQlr
ZnJlZShtZXRhKTsNCj4gIAlpZiAoYmlvKQ0KPiAgCQlibGtfcnFfdW5tYXBfdXNlcihiaW8pOw0K
PiAgCWJsa19tcV9mcmVlX3JlcXVlc3QocmVxKTsNCj4gDQo+IC0tDQo+IEplbnMgQXhib2UNCg0K
VGhpcyBkb2VzIHdvcmsgYW5kIGdvdCBtZSBwYXN0IHRoZSBudWxsIHB0ciBzZWdmYXVsdC4NCg0K
Q2xheS4NCg==
