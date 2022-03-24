Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAB74E6A1E
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 22:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353025AbiCXVK4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 17:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353945AbiCXVKx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 17:10:53 -0400
Received: from SJSMAIL01.us.kioxia.com (usmailhost21.kioxia.com [12.0.68.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A0076281;
        Thu, 24 Mar 2022 14:09:20 -0700 (PDT)
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Mar 2022 14:09:18 -0700
Received: from SJSMAIL01.us.kioxia.com ([fe80::b962:3005:acea:aa09]) by
 SJSMAIL01.us.kioxia.com ([fe80::b962:3005:acea:aa09%5]) with mapi id
 15.01.2176.014; Thu, 24 Mar 2022 14:09:18 -0700
From:   Clay Mayers <Clay.Mayers@kioxia.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "sbates@raithlin.com" <sbates@raithlin.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>,
        "javier@javigon.com" <javier@javigon.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "a.manzanares@samsung.com" <a.manzanares@samsung.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: RE: [PATCH 17/17] nvme: enable non-inline passthru commands
Thread-Topic: [PATCH 17/17] nvme: enable non-inline passthru commands
Thread-Index: AQHYMwoHCN0mZHqKz0OTQ9/5LjtdfKzOvDUg
Date:   Thu, 24 Mar 2022 21:09:18 +0000
Message-ID: <6a1cf782310d481aa5ef2fc172f55826@kioxia.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com>
In-Reply-To: <20220308152105.309618-18-joshi.k@samsung.com>
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

PiBGcm9tOiBLYW5jaGFuIEpvc2hpDQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDgsIDIwMjIgNzoy
MSBBTQ0KPiBUbzogYXhib2VAa2VybmVsLmRrOyBoY2hAbHN0LmRlOyBrYnVzY2hAa2VybmVsLm9y
ZzsNCj4gYXNtbC5zaWxlbmNlQGdtYWlsLmNvbQ0KPiBDYzogaW8tdXJpbmdAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1udm1lQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LQ0KPiBibG9ja0B2Z2Vy
Lmtlcm5lbC5vcmc7IHNiYXRlc0ByYWl0aGxpbi5jb207IGxvZ2FuZ0BkZWx0YXRlZS5jb207DQo+
IHBhbmt5ZGV2OEBnbWFpbC5jb207IGphdmllckBqYXZpZ29uLmNvbTsgbWNncm9mQGtlcm5lbC5v
cmc7DQo+IGEubWFuemFuYXJlc0BzYW1zdW5nLmNvbTsgam9zaGlpaXRyQGdtYWlsLmNvbTsgYW51
ajIwLmdAc2Ftc3VuZy5jb20NCj4gU3ViamVjdDogW1BBVENIIDE3LzE3XSBudm1lOiBlbmFibGUg
bm9uLWlubGluZSBwYXNzdGhydSBjb21tYW5kcw0KPiANCj4gRnJvbTogQW51aiBHdXB0YSA8YW51
ajIwLmdAc2Ftc3VuZy5jb20+DQo+IA0KPiBPbiBzdWJtaXNzaW9uLGp1c3QgZmV0Y2ggdGhlIGNv
bW1tYW5kIGZyb20gdXNlcnNwYWNlIHBvaW50ZXIgYW5kIHJldXNlDQo+IGV2ZXJ5dGhpbmcgZWxz
ZS4gT24gY29tcGxldGlvbiwgdXBkYXRlIHRoZSByZXN1bHQgZmllbGQgaW5zaWRlIHRoZSBwYXNz
dGhydQ0KPiBjb21tYW5kLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW51aiBHdXB0YSA8YW51ajIw
LmdAc2Ftc3VuZy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEthbmNoYW4gSm9zaGkgPGpvc2hpLmtA
c2Ftc3VuZy5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9udm1lL2hvc3QvaW9jdGwuYyB8IDI5ICsr
KysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjUgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252bWUv
aG9zdC9pb2N0bC5jIGIvZHJpdmVycy9udm1lL2hvc3QvaW9jdGwuYyBpbmRleA0KPiA3MDFmZWFl
Y2FiYmUuLmRkYjdlNTg2NGJlNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvaW9j
dGwuYw0KPiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9pb2N0bC5jDQo+IEBAIC02NSw2ICs2NSwx
NCBAQCBzdGF0aWMgdm9pZCBudm1lX3B0X3Rhc2tfY2Ioc3RydWN0IGlvX3VyaW5nX2NtZA0KPiAq
aW91Y21kKQ0KPiAgCX0NCj4gIAlrZnJlZShwZHUtPm1ldGEpOw0KPiANCj4gKwlpZiAoaW91Y21k
LT5mbGFncyAmIElPX1VSSU5HX0ZfVUNNRF9JTkRJUkVDVCkgew0KPiArCQlzdHJ1Y3QgbnZtZV9w
YXNzdGhydV9jbWQ2NCBfX3VzZXIgKnB0Y21kNjQgPSBpb3VjbWQtDQo+ID5jbWQ7DQo+ICsJCXU2
NCByZXN1bHQgPSBsZTY0X3RvX2NwdShudm1lX3JlcShyZXEpLT5yZXN1bHQudTY0KTsNCj4gKw0K
PiArCQlpZiAocHV0X3VzZXIocmVzdWx0LCAmcHRjbWQ2NC0+cmVzdWx0KSkNCj4gKwkJCXN0YXR1
cyA9IC1FRkFVTFQ7DQoNCldoZW4gdGhlIHRocmVhZCB0aGF0IHN1Ym1pdHRlZCB0aGUgaW9fdXJp
bmdfY21kIGhhcyBleGl0ZWQsIHRoZSBDQiBpcw0KY2FsbGVkIGJ5IGEgc3lzdGVtIHdvcmtlciBp
bnN0ZWFkIHNvIHB1dF91c2VyKCkgZmFpbHMuICBUaGUgY3FlIGlzIHN0aWxsDQpjb21wbGV0ZWQg
YW5kIHRoZSBwcm9jZXNzIHNlZXMgYSBmYWlsZWQgaS9vIHN0YXR1cywgYnV0IHRoZSBpL28gZGlk
IG5vdA0KZmFpbC4gIFRoZSBzYW1lIGlzIHRydWUgZm9yIG1ldGEgZGF0YSBiZWluZyByZXR1cm5l
ZCBpbiBwYXRjaCA1Lg0KDQpJIGNhbid0IHNheSBpZiBpdCdzIGEgcmVxdWlyZW1lbnQgdG8gc3Vw
cG9ydCB0aGlzIGNhc2UuICBJdCBkb2VzIGJyZWFrIG91cg0KY3VycmVudCBwcm90by10eXBlIGJ1
dCB3ZSBjYW4gYWRqdXN0Lg0KDQo+ICsJfQ0KPiArDQo+ICAJaW9fdXJpbmdfY21kX2RvbmUoaW91
Y21kLCBzdGF0dXMpOw0KPiAgfQ0KPiANCj4gQEAgLTE0Myw2ICsxNTEsMTMgQEAgc3RhdGljIGlu
bGluZSBib29sIG52bWVfaXNfZml4ZWRiX3Bhc3N0aHJ1KHN0cnVjdA0KPiBpb191cmluZ19jbWQg
KmlvdWNtZCkNCj4gIAlyZXR1cm4gKChpb3VjbWQpICYmIChpb3VjbWQtPmZsYWdzICYNCj4gSU9f
VVJJTkdfRl9VQ01EX0ZJWEVEQlVGUykpOyAgfQ0KPiANCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBp
c19pbmxpbmVfcncoc3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kLCBzdHJ1Y3QNCj4gK252bWVf
Y29tbWFuZCAqY21kKSB7DQo+ICsJcmV0dXJuICgoaW91Y21kLT5mbGFncyAmIElPX1VSSU5HX0Zf
VUNNRF9JTkRJUkVDVCkgfHwNCj4gKwkJCShjbWQtPmNvbW1vbi5vcGNvZGUgPT0gbnZtZV9jbWRf
d3JpdGUgfHwNCj4gKwkJCSBjbWQtPmNvbW1vbi5vcGNvZGUgPT0gbnZtZV9jbWRfcmVhZCkpOyB9
DQo+ICsNCj4gIHN0YXRpYyBpbnQgbnZtZV9zdWJtaXRfdXNlcl9jbWQoc3RydWN0IHJlcXVlc3Rf
cXVldWUgKnEsDQo+ICAJCXN0cnVjdCBudm1lX2NvbW1hbmQgKmNtZCwgdTY0IHVidWZmZXIsDQo+
ICAJCXVuc2lnbmVkIGJ1ZmZsZW4sIHZvaWQgX191c2VyICptZXRhX2J1ZmZlciwgdW5zaWduZWQN
Cj4gbWV0YV9sZW4sIEBAIC0xOTMsOCArMjA4LDcgQEAgc3RhdGljIGludCBudm1lX3N1Ym1pdF91
c2VyX2NtZChzdHJ1Y3QNCj4gcmVxdWVzdF9xdWV1ZSAqcSwNCj4gIAkJfQ0KPiAgCX0NCj4gIAlp
ZiAoaW91Y21kKSB7IC8qIGFzeW5jIGRpc3BhdGNoICovDQo+IC0JCWlmIChjbWQtPmNvbW1vbi5v
cGNvZGUgPT0gbnZtZV9jbWRfd3JpdGUgfHwNCj4gLQkJCQljbWQtPmNvbW1vbi5vcGNvZGUgPT0g
bnZtZV9jbWRfcmVhZCkgew0KPiArCQlpZiAoaXNfaW5saW5lX3J3KGlvdWNtZCwgY21kKSkgew0K
PiAgCQkJaWYgKGJpbyAmJiBpc19wb2xsaW5nX2VuYWJsZWQoaW91Y21kLCByZXEpKSB7DQo+ICAJ
CQkJaW91Y21kLT5iaW8gPSBiaW87DQo+ICAJCQkJYmlvLT5iaV9vcGYgfD0gUkVRX1BPTExFRDsN
Cj4gQEAgLTIwNCw3ICsyMTgsNyBAQCBzdGF0aWMgaW50IG52bWVfc3VibWl0X3VzZXJfY21kKHN0
cnVjdA0KPiByZXF1ZXN0X3F1ZXVlICpxLA0KPiAgCQkJYmxrX2V4ZWN1dGVfcnFfbm93YWl0KHJl
cSwgMCwgbnZtZV9lbmRfYXN5bmNfcHQpOw0KPiAgCQkJcmV0dXJuIDA7DQo+ICAJCX0gZWxzZSB7
DQo+IC0JCQkvKiBzdXBwb3J0IG9ubHkgcmVhZCBhbmQgd3JpdGUgZm9yIG5vdy4gKi8NCj4gKwkJ
CS8qIHN1cHBvcnQgb25seSByZWFkIGFuZCB3cml0ZSBmb3IgaW5saW5lICovDQo+ICAJCQlyZXQg
PSAtRUlOVkFMOw0KPiAgCQkJZ290byBvdXRfbWV0YTsNCj4gIAkJfQ0KPiBAQCAtMzcyLDcgKzM4
NiwxNCBAQCBzdGF0aWMgaW50IG52bWVfdXNlcl9jbWQ2NChzdHJ1Y3QgbnZtZV9jdHJsICpjdHJs
LA0KPiBzdHJ1Y3QgbnZtZV9ucyAqbnMsDQo+ICAJfSBlbHNlIHsNCj4gIAkJaWYgKGlvdWNtZC0+
Y21kX2xlbiAhPSBzaXplb2Yoc3RydWN0IG52bWVfcGFzc3RocnVfY21kNjQpKQ0KPiAgCQkJcmV0
dXJuIC1FSU5WQUw7DQo+IC0JCWNwdHIgPSAoc3RydWN0IG52bWVfcGFzc3RocnVfY21kNjQgKilp
b3VjbWQtPmNtZDsNCj4gKwkJaWYgKGlvdWNtZC0+ZmxhZ3MgJiBJT19VUklOR19GX1VDTURfSU5E
SVJFQ1QpIHsNCj4gKwkJCXVjbWQgPSAoc3RydWN0IG52bWVfcGFzc3RocnVfY21kNjQgX191c2Vy
DQo+ICopaW91Y21kLT5jbWQ7DQo+ICsJCQlpZiAoY29weV9mcm9tX3VzZXIoJmNtZCwgdWNtZCwg
c2l6ZW9mKGNtZCkpKQ0KPiArCQkJCXJldHVybiAtRUZBVUxUOw0KPiArCQkJY3B0ciA9ICZjbWQ7
DQo+ICsJCX0gZWxzZSB7DQo+ICsJCQljcHRyID0gKHN0cnVjdCBudm1lX3Bhc3N0aHJ1X2NtZDY0
ICopaW91Y21kLT5jbWQ7DQo+ICsJCX0NCj4gIAl9DQo+ICAJaWYgKGNwdHItPmZsYWdzICYgTlZN
RV9ISVBSSSkNCj4gIAkJcnFfZmxhZ3MgfD0gUkVRX1BPTExFRDsNCj4gLS0NCj4gMi4yNS4xDQoN
Cg==
