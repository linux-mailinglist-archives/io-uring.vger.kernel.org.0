Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2A51C872
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 20:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbiEES4W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 14:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiEES4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 14:56:22 -0400
X-Greylist: delayed 901 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 11:52:40 PDT
Received: from SJSMAIL01.us.kioxia.com (usmailhost21.kioxia.com [12.0.68.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FE33916C
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 11:52:39 -0700 (PDT)
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 11:37:37 -0700
Received: from SJSMAIL01.us.kioxia.com ([fe80::c557:f37d:d981:76df]) by
 SJSMAIL01.us.kioxia.com ([fe80::c557:f37d:d981:76df%3]) with mapi id
 15.01.2375.024; Thu, 5 May 2022 11:37:37 -0700
From:   Clay Mayers <Clay.Mayers@kioxia.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>
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
Thread-Index: AQHYYEffNsZGDQ8MAEyuOCh/GTUQpa0QnLIA
Date:   Thu, 5 May 2022 18:37:36 +0000
Message-ID: <80cde2cfd566454fa4b160492c7336c2@kioxia.com>
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com>
 <20220505060616.803816-4-joshi.k@samsung.com>
In-Reply-To: <20220505060616.803816-4-joshi.k@samsung.com>
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

PiBGcm9tOiBLYW5jaGFuIEpvc2hpDQo+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDQsIDIwMjIgMTE6
MDYgUE0NCj4gLS0tDQoNCj4gIGRyaXZlcnMvbnZtZS9ob3N0L2lvY3RsLmMgfCA0NyArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0MiBp
bnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPg0KPiArc3RhdGljIGludCBudm1lX2V4ZWN1
dGVfdXNlcl9ycShzdHJ1Y3QgcmVxdWVzdCAqcmVxLCB2b2lkIF9fdXNlcg0KPiAqbWV0YV9idWZm
ZXIsDQo+ICsJCXVuc2lnbmVkIG1ldGFfbGVuLCB1NjQgKnJlc3VsdCkNCj4gK3sNCj4gKwlzdHJ1
Y3QgYmlvICpiaW8gPSByZXEtPmJpbzsNCj4gKwlib29sIHdyaXRlID0gYmlvX29wKGJpbykgPT0g
UkVRX09QX0RSVl9PVVQ7DQoNCkknbSBnZXR0aW5nIGEgTlVMTCBwdHIgYWNjZXNzIG9uIHRoZSBm
aXJzdCBpb2N0bChOVk1FX0lPQ1RMX0FETUlONjRfQ01EKQ0KSSBzZW5kIC0gaXQgaGFzIG5vIHVi
dWZmZXIgc28gSSB0aGluayB0aGVyZSdzIG5vIHJlcS0+YmlvLg0KDQo+ICsJaW50IHJldDsNCj4g
Kwl2b2lkICptZXRhID0gbnZtZV9tZXRhX2Zyb21fYmlvKGJpbyk7DQo+ICsNCj4gIAlyZXQgPSBu
dm1lX2V4ZWN1dGVfcGFzc3RocnVfcnEocmVxKTsNCj4gKw0KPiAgCWlmIChyZXN1bHQpDQo+ICAJ
CSpyZXN1bHQgPSBsZTY0X3RvX2NwdShudm1lX3JlcShyZXEpLT5yZXN1bHQudTY0KTsNCj4gIAlp
ZiAobWV0YSAmJiAhcmV0ICYmICF3cml0ZSkgew0K
