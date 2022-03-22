Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3587C4E42A6
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 16:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiCVPTf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 11:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiCVPTd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 11:19:33 -0400
Received: from SJSMAIL01.us.kioxia.com (usmailhost21.kioxia.com [12.0.68.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF0862CA;
        Tue, 22 Mar 2022 08:18:04 -0700 (PDT)
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 22 Mar 2022 08:18:03 -0700
Received: from SJSMAIL01.us.kioxia.com ([fe80::b962:3005:acea:aa09]) by
 SJSMAIL01.us.kioxia.com ([fe80::b962:3005:acea:aa09%5]) with mapi id
 15.01.2176.014; Tue, 22 Mar 2022 08:18:03 -0700
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
Subject: RE: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Thread-Topic: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Thread-Index: AQHYMwaP8WKeHTnbdEm2AUHWA0dFWKzLlXmw
Date:   Tue, 22 Mar 2022 15:18:03 +0000
Message-ID: <d66a6bb2d0974171b44777dd07889473@kioxia.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com>
In-Reply-To: <20220308152105.309618-6-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.90.53.183]
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
ajIwLmdAc2Ftc3VuZy5jb20NCj4gU3ViamVjdDogW1BBVENIIDA1LzE3XSBudm1lOiB3aXJlLXVw
IHN1cHBvcnQgZm9yIGFzeW5jLXBhc3N0aHJ1IG9uIGNoYXItDQo+IGRldmljZS4NCj4gDQoNCg0K
PHNuaXA+DQo+ICtzdGF0aWMgdm9pZCBudm1lX3B0X3Rhc2tfY2Ioc3RydWN0IGlvX3VyaW5nX2Nt
ZCAqaW91Y21kKQ0KPiArew0KPiArCXN0cnVjdCBudm1lX3VyaW5nX2NtZF9wZHUgKnBkdSA9IG52
bWVfdXJpbmdfY21kX3BkdShpb3VjbWQpOw0KPiArCXN0cnVjdCByZXF1ZXN0ICpyZXEgPSBwZHUt
PnJlcTsNCj4gKwlpbnQgc3RhdHVzOw0KPiArCXN0cnVjdCBiaW8gKmJpbyA9IHJlcS0+YmlvOw0K
PiArDQo+ICsJaWYgKG52bWVfcmVxKHJlcSktPmZsYWdzICYgTlZNRV9SRVFfQ0FOQ0VMTEVEKQ0K
PiArCQlzdGF0dXMgPSAtRUlOVFI7DQo+ICsJZWxzZQ0KPiArCQlzdGF0dXMgPSBudm1lX3JlcShy
ZXEpLT5zdGF0dXM7DQo+ICsNCj4gKwkvKiB3ZSBjYW4gZnJlZSByZXF1ZXN0ICovDQo+ICsJYmxr
X21xX2ZyZWVfcmVxdWVzdChyZXEpOw0KPiArCWJsa19ycV91bm1hcF91c2VyKGJpbyk7DQo+ICsN
Cj4gKwlpZiAoIXN0YXR1cyAmJiBwZHUtPm1ldGFfYnVmZmVyKSB7DQo+ICsJCWlmIChjb3B5X3Rv
X3VzZXIocGR1LT5tZXRhX2J1ZmZlciwgcGR1LT5tZXRhLCBwZHUtDQo+ID5tZXRhX2xlbikpDQoN
ClRoaXMgY29weSBpcyBpbmNvcnJlY3RseSBjYWxsZWQgZm9yIHdyaXRlcy4NCg0KPiArCQkJc3Rh
dHVzID0gLUVGQVVMVDsNCj4gKwl9DQo+ICsJa2ZyZWUocGR1LT5tZXRhKTsNCj4gKw0KPiArCWlv
X3VyaW5nX2NtZF9kb25lKGlvdWNtZCwgc3RhdHVzKTsNCj4gK30NCjwvc25pcD4NCg==
