Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A805B692A55
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbjBJWly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjBJWlx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:41:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5CE16AE1
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:41:51 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-318-uEi7rd_bNiCq5v_5lLrP5A-1; Fri, 10 Feb 2023 22:41:48 +0000
X-MC-Unique: uEi7rd_bNiCq5v_5lLrP5A-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Fri, 10 Feb
 2023 22:41:46 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Fri, 10 Feb 2023 22:41:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
CC:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: RE: copy on write for splice() from file to pipe?
Thread-Topic: copy on write for splice() from file to pipe?
Thread-Index: AQHZPXSEPyXic8n4vkmqtvVlaYw2Fq7Ivx9Q
Date:   Fri, 10 Feb 2023 22:41:46 +0000
Message-ID: <304d5286b6364da48a2bb1125155b7e5@AcuMS.aculab.com>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
 <CAHk-=wip9xx367bfCV8xaF9Oaw4DZ6edF9Ojv10XoxJ-iUBwhA@mail.gmail.com>
 <20230210061953.GC2825702@dread.disaster.area>
 <CAHk-=wj6jd0JWtxO0JvjYUgKfnGEj4BzPVOfY+4_=-0iiGh0tw@mail.gmail.com>
In-Reply-To: <CAHk-=wj6jd0JWtxO0JvjYUgKfnGEj4BzPVOfY+4_=-0iiGh0tw@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMTAgRmVicnVhcnkgMjAyMyAxNzoyNA0KLi4u
DQo+IEFuZCB3aGVuIGl0IGNvbWVzIHRvIG5ldHdvcmtpbmcsIGluIGdlbmVyYWwgdGhpbmdzIGxp
a2UgVENQIGNoZWNrc3Vtcw0KPiBldGMgc2hvdWxkIGJlIG9rIGV2ZW4gd2l0aCBkYXRhIHRoYXQg
aXNuJ3Qgc3RhYmxlLiAgV2hlbiBkb2luZyB0aGluZ3MNCj4gYnkgaGFuZCwgbmV0d29ya2luZyBz
aG91bGQgYWx3YXlzIHVzZSB0aGUgImNvcHktYW5kLWNoZWNrc3VtIg0KPiBmdW5jdGlvbnMgdGhh
dCBkbyB0aGUgY2hlY2tzdW0gd2hpbGUgY29weWluZyAoc28gZXZlbiBpZiB0aGUgc291cmNlDQo+
IGRhdGEgY2hhbmdlcywgdGhlIGNoZWNrc3VtIGlzIGdvaW5nIHRvIGJlIHRoZSBjaGVja3N1bSBm
b3IgdGhlIGRhdGENCj4gdGhhdCB3YXMgY29waWVkKS4NCj4gDQo+IEFuZCBpbiBtYW55IChtb3N0
Pykgc21hcnRlciBuZXR3b3JrIGNhcmRzLCB0aGUgY2FyZCBpdHNlbGYgZG9lcyB0aGUNCj4gY2hl
Y2tzdW0sIGFnYWluIG9uIHRoZSBkYXRhIGFzIGl0IGlzIHRyYW5zZmVycmVkIGZyb20gbWVtb3J5
Lg0KPiANCj4gU28gaXQncyBub3QgbGlrZSAibmV0d29ya2luZyBuZWVkcyBhIHN0YWJsZSBzb3Vy
Y2UiIGlzIHNvbWUgcmVhbGx5DQo+IF9mdW5kYW1lbnRhbF8gcmVxdWlyZW1lbnQgZm9yIHRoaW5n
cyBsaWtlIHRoYXQgdG8gd29yay4NCg0KSXQgaXMgYWxzbyB3b3J0aCByZW1lbWJlcmluZyB0aGF0
IFRDUCBuZWVkcyB0byBiZSBhYmxlDQp0byByZXRyYW5zbWl0IHRoZSBkYXRhIGFuZCBhIG11Y2gg
bGF0ZXIgdGltZS4NClNvIHRoZSBhcHBsaWNhdGlvbiBtdXN0IG5vdCBjaGFuZ2UgdGhlIGRhdGEg
dW50aWwgaXQgaGFzDQpiZWVuIGFja2VkIGJ5IHRoZSByZW1vdGUgc3lzdGVtLg0KDQpPcGVyYXRp
bmcgc3lzdGVtcyB0aGF0IGRvIGFzeW5jaHJvbm91cyBJTyBkaXJlY3RseSBmcm9tDQphcHBsaWNh
dGlvbiBidWZmZXJzIGhhdmUgY2FsbGJhY2tzL2V2ZW50cyB0byB0ZWxsIHRoZQ0KYXBwbGljYXRp
b24gd2hlbiBpdCBpcyBhbGxvd2VkIHRvIG1vZGlmeSB0aGUgYnVmZmVycy4NCkZvciBUQ1AgdGhp
cyB3b24ndCBiZSBpbmRpY2F0ZWQgdW50aWwgYWZ0ZXIgdGhlIEFDSw0KaXMgcmVjZWl2ZWQuDQpJ
IGRvbid0IHRoaW5rIGlvX3VyaW5nIGhhcyBhbnkgd2F5IHRvIGluZGljYXRlIGFueXRoaW5nDQpv
dGhlciB0aGFuICd0aGUgZGF0YSBoYXMgYmVlbiBhY2NlcHRlZCBieSB0aGUgc29ja2V0Jy4NCg0K
SWYgeW91IGhhdmUgJ2tlcm5lbCBwYWdlcyBjb250YWluaW5nIGRhdGEnIChlZyBmcm9tIHdyaXRl
cw0KaW50byBhIHBpcGUsIG9yIGRhdGEgcmVjZWl2ZWQgZnJvbSBhIG5ldHdvcmspIHRoZW4gdGhl
eSBoYXZlDQphIHNpbmdsZSAnb3duZXInIGFuZCBjYW4gYmUgcGFzc2VkIGFib3V0Lg0KQnV0IHVz
ZXItcGFnZXMgKGluY2x1ZGluZyBtbWFwcGVkIGZpbGVzKSBoYXZlIG11bHRpcGxlIG93bmVycw0K
c28geW91IGFyZSBuZXZlciBnb2luZyB0byBiZSBhYmxlIHRvIHBhc3MgdGhlbSBhcyAnaW1tdXRh
YmxlDQpkYXRhJy4NCklmIHlvdSBtbWFwIGEgdmVyeSBsYXJnZSAoYW5kIG1heWJlIHNwYXJzZSkg
ZmlsZSBhbmQgdGhlbg0KdHJ5IHRvIGRvIGEgdmVyeSBsYXJnZSAobXVsdGktR0IpIHNlbmQoKSAo
d2l0aCBvciB3aXRob3V0DQphbnkga2luZCBvZiBwYWdlIGxvYW5pbmcpIHRoZXJlIGlzIGFsd2F5
cyB0aGUgcG9zc2liaWxpdHkNCnRoYXQgdGhlIGRhdGEgdGhhdCBpcyBhY3R1YWxseSBzZW50IHdh
cyB3cml0dGVuIHdoaWxlIHRoZQ0Kc2VuZCgpIGNhbGwgd2FzIGluIHByb2dyZXNzLg0KQW55IGtp
bmQgb2YgYXN5bmNocm9ub3VzIHNlbmQoKSBqdXN0IG1ha2VzIGl0IG1vcmUgb2J2aW91cy4NCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==

