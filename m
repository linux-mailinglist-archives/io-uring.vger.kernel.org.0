Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD3769283C
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 21:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjBJUYP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 15:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbjBJUYL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 15:24:11 -0500
X-Greylist: delayed 975 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 12:23:28 PST
Received: from SJSMAIL01.us.kioxia.com (usmailhost21.kioxia.com [12.0.68.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF2181283;
        Fri, 10 Feb 2023 12:23:27 -0800 (PST)
Received: from SJSMAIL01.us.kioxia.com (10.90.133.90) by
 SJSMAIL01.us.kioxia.com (10.90.133.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 10 Feb 2023 12:07:09 -0800
Received: from SJSMAIL01.us.kioxia.com ([10.90.133.90]) by
 SJSMAIL01.us.kioxia.com ([10.90.133.90]) with mapi id 15.01.2375.034; Fri, 10
 Feb 2023 12:07:09 -0800
From:   Clay Mayers <Clay.Mayers@kioxia.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>
Subject: RE: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Thread-Topic: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Thread-Index: AQHZPXpawtZ6JevJFESaC3bXWuk95a7IlJlA
Date:   Fri, 10 Feb 2023 20:07:09 +0000
Message-ID: <65b5a06a163246e293a0452c03a59a2b@kioxia.com>
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
In-Reply-To: <20230210180033.321377-1-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.93.77.43]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

PiBGcm9tIEthbmNoYW4gSm9zaGkNCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAxMCwgMjAyMyAx
MDowMSBBTQ0KPiBUbzogbHNmLXBjQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnDQo+IENjOiBs
aW51eC1ibG9ja0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW52bWVAbGlzdHMuaW5mcmFkZWFkLm9y
ZzsgaW8tDQo+IHVyaW5nQHZnZXIua2VybmVsLm9yZzsgYXhib2VAa2VybmVsLmRrOyBoY2hAbHN0
LmRlOyBrYnVzY2hAa2VybmVsLm9yZzsNCj4gbWluZy5sZWlAcmVkaGF0LmNvbTsgS2FuY2hhbiBK
b3NoaSA8am9zaGkua0BzYW1zdW5nLmNvbT4NCj4gU3ViamVjdDogW0xTRi9NTS9CUEYgQVRURU5E
XVtMU0YvTU0vQlBGIFRvcGljXSBOb24tYmxvY2sgSU8NCj4gDQo+IGlzIGdldHRpbmcgbW9yZSBj
b21tb24gdGhhbiBpdCB1c2VkIHRvIGJlLg0KPiBOVk1lIGlzIG5vIGxvbmdlciB0aWVkIHRvIGJs
b2NrIHN0b3JhZ2UuIENvbW1hbmQgc2V0cyBpbiBOVk1lIDIuMCBzcGVjDQo+IG9wZW5lZCBhbiBl
eGNlbGxlbnQgd2F5IHRvIHByZXNlbnQgbm9uLWJsb2NrIGludGVyZmFjZXMgdG8gdGhlIEhvc3Qu
IFpOUw0KPiBhbmQgS1YgY2FtZSBhbG9uZyB3aXRoIGl0LCBhbmQgc29tZSBuZXcgY29tbWFuZCBz
ZXRzIGFyZSBlbWVyZ2luZy4NCg0KU29tZSBjb21tYW5kIHNldHMgcmVxdWlyZSBmZWF0dXJlcyBv
ZiBOVk1lIHRoZSBrZXJuZWwgZG9lc24ndCBzdXBwb3J0Ow0KZnVzZWQgYW5kIHNvbWUgQUVOcyBm
b3IgZXhhbXBsZS4gIEl0IHdvdWxkIGJlIHZlcnkgdXNlZnVsIHRvIHdvcmsgd2l0aA0Kbm9uLWJs
b2NrIGNvbW1hbmQgc2V0cyB3L28gbW9kaWZ5aW5nIHRoZSBOVk1lIGRyaXZlciwgaGF2aW5nIGEg
Y3VzdG9tDQpOVk1lIGRyaXZlciBwZXIgY29tbWFuZCBzZXQgb3IgcmVzb3J0aW5nIHRvIHVzaW5n
IHNwZGsuDQoNCg==
