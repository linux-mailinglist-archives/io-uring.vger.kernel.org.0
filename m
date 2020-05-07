Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0AC1C7F92
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 03:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgEGBEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 21:04:51 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:41231 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgEGBEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 21:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588813490; x=1620349490;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=mgLJPqabMWDWSnT/E9DXYGzfgXs0DHdceKUrdhCdHCY=;
  b=T0bCoSiClaAuE+Hi7AoetVl6wTuGRsXTnc0R94NGJC/6CG9YC/gRlpP5
   7JkW2xklMa2iczvjtj2nnSEx0/vJ550xUW1kIcgOOokBOXuPhihfSiyqz
   UPSkqQEDvmv3G7SV6MWQVKhmNu/AduVRe1dq/Vc3Wu6C6oE+BsjEL+ExN
   U=;
IronPort-SDR: U1w7QfcdayWrSz7L3taJ1ecNcNITqvPXR/fK1RKq+uXBdVtB8ji+07QvHHXxV7USaCa8ZGnYmY
 vg7q33QaCzRQ==
X-IronPort-AV: E=Sophos;i="5.73,361,1583193600"; 
   d="scan'208";a="29005515"
Subject: Re: Non sequential linked chains and IO_LINK support
Thread-Topic: Non sequential linked chains and IO_LINK support
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 May 2020 01:04:38 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id D2AF0A22F3;
        Thu,  7 May 2020 01:04:36 +0000 (UTC)
Received: from EX13D10UEA002.ant.amazon.com (10.43.61.18) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 7 May 2020 01:04:36 +0000
Received: from EX13D14UWB001.ant.amazon.com (10.43.161.158) by
 EX13D10UEA002.ant.amazon.com (10.43.61.18) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 7 May 2020 01:04:35 +0000
Received: from EX13D14UWB001.ant.amazon.com ([10.43.161.158]) by
 EX13D14UWB001.ant.amazon.com ([10.43.161.158]) with mapi id 15.00.1497.006;
 Thu, 7 May 2020 01:04:34 +0000
From:   "Bhatia, Sumeet" <sumee@amazon.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "Hegde, Pramod" <phegde@amazon.com>, Jens Axboe <axboe@kernel.dk>
Thread-Index: AQHWI+9s4Fi5GrZNSkiih0IwBQ/oNKibnsoAgAAvCVQ=
Date:   Thu, 7 May 2020 01:04:34 +0000
Message-ID: <1588813473189.20383@amazon.com>
References: <1588801562969.24370@amazon.com>,<62a52be6-d538-b3ee-a071-4ff45da85a87@gmail.com>
In-Reply-To: <62a52be6-d538-b3ee-a071-4ff45da85a87@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.180]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

VGhhbmsgeW91IGZvciB0aGUgcmVzcG9uc2UhCgpVbmZvcnR1bmF0ZWx5IHdoZW4gdGhlIGFwcGxp
Y2F0aW9uIHN1Ym1pdHMgb3BlcmF0aW9uXzAgaXQgaGFzIG5vIHdheSBvZiBkZXRlcm1pbmluZyBp
Zi93aGVuIG9wZXJhdGlvbl8yIHdvdWxkIGJlIGdlbmVyYXRlZC4gCgpGb3Igbm93IEkgcGxhbiB0
byBtYWludGFpbiBhIGxpc3Qgb2Ygb3V0c3RhbmRpbmcgb3BlcmF0aW9ucy4gSWYgb3BlcmF0aW9u
XzIgZ2V0cyBnZW5lcmF0ZWQgd2hpbGUgb3BlcmF0aW9uXzAgaXMgaW4gZmxpZ2h0IHRoZSBhcHBs
aWNhdGlvbiB3aWxsIGhvbGQgaXRzIHN1Ym1pc3Npb24gdW50aWwgb3BlcmF0aW9uXzAgaXMgY29t
cGxldGVkLiAKCkkgd2FudGVkIHRvIGNoZWNrIHdoZXRoZXIgdGhpcyB3b3VsZCBiZSBhIGdlbmVy
aWMgdXNlIGNhc2UgYW5kIHdvdWxkIHdhcnJhbnQgbmF0aXZlIHN1cHBvcnQgaW4gaW91cmluZz8K
ClRoYW5rcywKU3VtZWV0Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
RnJvbTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+ClNlbnQ6IFdlZG5l
c2RheSwgTWF5IDYsIDIwMjAgNjoxMSBQTQpUbzogQmhhdGlhLCBTdW1lZXQ7IGlvLXVyaW5nQHZn
ZXIua2VybmVsLm9yZwpDYzogSGVnZGUsIFByYW1vZDsgSmVucyBBeGJvZQpTdWJqZWN0OiBSRTog
W0VYVEVSTkFMXSBOb24gc2VxdWVudGlhbCBsaW5rZWQgY2hhaW5zIGFuZCBJT19MSU5LIHN1cHBv
cnQKCkNBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
CgoKCk9uIDA3LzA1LzIwMjAgMDA6NDYsIEJoYXRpYSwgU3VtZWV0IHdyb3RlOgo+IEhlbGxvIGV2
ZXJ5b25lLAo+Cj4gSSd2ZSBiZWVuIGV4cGxvcmluZyBpb3VyaW5nIHRvIHN1Ym1pdCBkaXNrIG9w
ZXJhdGlvbnMuIE15IGFwcGxpY2F0aW9uIGdlbmVyYXRlcyBkaXNrIG9wZXJhdGlvbnMgYmFzZWQg
b24gc29tZSBldmVudHMgYW5kIG9wZXJhdGlvbnMgYXJlIHVua25vd24gdW50aWwgdGhvc2UgZXZl
bnRzIG9jY3VyLiAgU29tZSBvZiB0aGVzZSBkaXNrIG9wZXJhdGlvbnMgYXJlIGludGVyZGVwZW5k
ZW50IG90aGVycyBhcmUgbm90Lgo+Cj4gRXhhbXBsZTogRm9sbG93aW5nIG9wZXJhdGlvbnMgYXJl
IGdlbmVyYXRlZCBhbmQgc3VibWl0dGVkIGJlZm9yZSBhbnkgb2YgdGhlbSBhcmUgY29tcGxldGUK
PiBvcGVyYXRpb25fMCAoaW5kZXBlbmRlbnQgb3BlcmF0aW9uKQo+IG9wZXJhdGlvbl8xIChpbmRl
cGVuZGVudCBvcGVyYXRpb24pLOKAiwo+IG9wZXJhdGlvbl8yICh0byBiZSBpc3N1ZWQgb25seSBp
ZiBvcGVyYXRpb25fMCB3YXMgc3VjY2Vzc2Z1bCksCj4gb3BlcmF0aW9uXzMgKGluZGVwZW5kZW50
IG9wZXJhdGlvbiksCj4gb3BlcmF0aW9uXzQgKHRvIGJlIGlzc3VlZCBvbmx5IGlmIG9wZXJhdGlv
bl8xIHdhcyBzdWNjZXNzZnVsKQo+Cj4gSW4gbXkgZXhhbXBsZSBJIGhhdmUgdHdvIGluZGVwZW5k
ZW50IGxpbmsgY2hhaW5zLCAob3BlcmF0aW9uXzAsIG9wZXJhdGlvbl8yKSBhbmQgKG9wZXJhdGlv
bl8xLCBvcGVyYXRpb25fNCkuICBpb3VyaW5nIGRvY3VtZW50YXRpb24gc3VnZ2VzdHMgSU9TUUVf
SU9fTElOSyBleHBlY3RzIGxpbmsgY2hhaW5zIHRvIGJlIHNlcXVlbnRpYWwgYW5kIHdpbGwgbm90
IHN1cHBvcnQgbXkgdXNlIGNhc2UuCgpGaXJzdCBvZiBhbGwsIHRoZXJlIHNob3VsZG4ndCBiZSBh
IHN1Ym1pc3Npb24gKGkuZS4gaW9fdXJpbmdfZW50ZXIodG9fc3VibWl0PjApKQpiZXR3ZWVuIGFk
ZGluZyBsaW5rZWQgcmVxdWVzdHMgdG8gYSBzdWJtaXNzaW9uIHF1ZXVlIChTUSkuIEl0J2QgYmUg
cmFjeSBvdGhlcndpc2UuCgpFLmcuIHlvdSBjYW4ndCBkbzoKCmFkZF9zcWUob3AwKQpzdWJtaXQo
b3AwKQphZGRfc3FlKG9wMiwgbGlua2VkKQoKVGhvdWdoIHRoZSBmb2xsb3dpbmcgaXMgdmFsaWQs
IGFzIHdlIGRvbid0IHN1Ym1pdCBvcDA6CgphZGRfc3FlKG9wWCkKYWRkX3NxZShvcDApCnN1Ym1p
dCh1cCB1bnRpbCBvcFgpCmFkZF9zcWUob3AyLCBsaW5rZWQpCgoKQW5kIHRoYXQgbWVhbnMgeW91
IGNhbiByZW9yZGVyIHRoZW0ganVzdCBiZWZvcmUgc3VibWl0dGluZywgb3IgZmlsaW5nIHRoZW0g
aW50bwp0aGUgU1EgaW4gYSBiZXR0ZXIgb3JkZXIuCgpJcyBpdCBoZWxwZnVsPyBMZXQncyBmaWd1
cmUgb3V0IGhvdyB0byBjb3ZlciB5b3VyIGNhc2UuCgoKPiBJIGV4cGxvcmVkIGNyZWF0aW5nIG5l
dyBpb3VyaW5nIGNvbnRleHQgZm9yIGVhY2ggb2YgdGhlc2UgbGlua2VkIGNoYWlucy4gQnV0IGl0
IHR1cm5zIG91dCBkZXBlbmRpbmcgb24gZGlzayBzaXplIHRoZXJlIGNhbiBiZSBzb21ld2hlcmUg
YmV0d2VlbiA1MDAtMTAwMCBzdWNoIGNoYWlucy4gSSdtIG5vdCBzdXJlIHdoZXRoZXIgaXQgaXMg
cHJ1ZGVudCB0byBjcmVhdGUgdGhhdCBtYW55IGlvdXJpbmcgY29udGV4dHMuCgpUaGVuIHlvdSB3
b3VsZCBuZWVkIHRvIHdhaXQgb24gdGhlbSAoZS5nLiBlcG9sbCBvciAxMDAwIHRocmVhZHMpLCBh
bmQgdGhhdCB3b3VsZApkZWZlYXQgdGhlIHdob2xlIGlkZWEuIEluIGFueSBjYXNlIGV2ZW4gd2l0
aCBzaGFyaW5nIGlvLXdxIGFuZCBoYXZpbmcgc21hbGwgQ1EKYW5kIFNRLCBpdCdkIGJlIHdhc3Rl
ZnVsIGtlZXBpbmcgbWFueSByZXNvdXJjZXMgZHVwbGljYXRlZC4KCj4KPiBJIGFtIHJlYWNoaW5n
IG91dCB0byBjaGVjayB3aGV0aGVyIHRoZXJlIHdvdWxkIGJlIGEgZ2VuZXJpYyBuZWVkIHRvIHN1
cHBvcnQgbm9uc2VxdWVudGlhbCBsaW5rZWQgY2hhaW5zIG9uIGEgc2luZ2xlIGlvdXJpbmcgY29u
dGV4dC4gV291bGQgbG92ZSB0byBoZWFyIGFsbCB5b3VyIHRob3VnaHRzLgo+Cj4gVGhhbmtzLAo+
IFN1bWVldAo+CgotLQpQYXZlbCBCZWd1bmtvdgo=
