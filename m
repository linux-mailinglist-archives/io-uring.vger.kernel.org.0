Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562421A2758
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgDHQld (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 12:41:33 -0400
Received: from veto.sei.cmu.edu ([147.72.252.17]:33128 "EHLO veto.sei.cmu.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgDHQld (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 8 Apr 2020 12:41:33 -0400
Received: from delp.sei.cmu.edu (delp.sei.cmu.edu [10.64.21.31])
        by veto.sei.cmu.edu (8.14.7/8.14.7) with ESMTP id 038GfVIb036485;
        Wed, 8 Apr 2020 12:41:31 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 veto.sei.cmu.edu 038GfVIb036485
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cert.org;
        s=yc2bmwvrj62m; t=1586364091;
        bh=jf2ZsUPjhI2hveYHuH3dlbwSrLOnLn05HSbXXT0VhyE=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=rxBn48gVb0GPXRx1NSJHkHZm9bSek5GR8v08nWrF5XM/t9ekHM1kV88gZkt1cOX2q
         74ql1YxVWmeNo8AA5yGiKsORzgYlmkLMqDh0ewXfEFW7VDl6RFHWuaMHqvC90rXymL
         p8slW82IYtS01PRsQZLdseUjAJXS/PDKBuQA2nlg=
Received: from CASSINA.ad.sei.cmu.edu (cassina.ad.sei.cmu.edu [10.64.28.249])
        by delp.sei.cmu.edu (8.14.7/8.14.7) with ESMTP id 038GfS7x043197;
        Wed, 8 Apr 2020 12:41:29 -0400
Received: from MORRIS.ad.sei.cmu.edu (147.72.252.46) by CASSINA.ad.sei.cmu.edu
 (10.64.28.249) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 8 Apr
 2020 12:41:28 -0400
Received: from MORRIS.ad.sei.cmu.edu (147.72.252.46) by MORRIS.ad.sei.cmu.edu
 (147.72.252.46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Wed, 8 Apr 2020
 12:41:28 -0400
Received: from MORRIS.ad.sei.cmu.edu ([fe80::555b:9498:552e:d1bb]) by
 MORRIS.ad.sei.cmu.edu ([fe80::555b:9498:552e:d1bb%22]) with mapi id
 15.01.1847.007; Wed, 8 Apr 2020 12:41:28 -0400
From:   Joseph Christopher Sible <jcsible@cert.org>
To:     "'Jens Axboe'" <axboe@kernel.dk>,
        "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: RE: Spurious/undocumented EINTR from io_uring_enter
Thread-Topic: Spurious/undocumented EINTR from io_uring_enter
Thread-Index: AdYNHCB8t2qqN/asQKmA7dRl2D+7cwAKrhOAAB25dbA=
Date:   Wed, 8 Apr 2020 16:41:28 +0000
Message-ID: <d8a2a9fe86974f999cb41f0b17f9e9a7@cert.org>
References: <43b339d3dc0c4b6ab15652faf12afa30@cert.org>
 <b9ee42f0-cd94-9410-0de1-1bbfd50a6040@kernel.dk>
In-Reply-To: <b9ee42f0-cd94-9410-0de1-1bbfd50a6040@kernel.dk>
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

T24gNC83LzIwIDU6NDIgUE0sIEplbnMgQXhib2Ugd3JvdGU6DQo+IExvdHMgb2Ygc3lzdGVtIGNh
bGxzIHJldHVybiAtRUlOVFIgaWYgaW50ZXJydXB0ZWQgYnkgYSBzaWduYWwsIGRvbid0DQo+IHRo
aW5rIHRoZXJlJ3MgYW55dGhpbmcgd29ydGggZml4aW5nIHRoZXJlLiBGb3IgdGhlIHdhaXQgcGFy
dCwgdGhlDQo+IGFwcGxpY2F0aW9uIG1heSB3YW50IHRvIGhhbmRsZSB0aGUgc2lnbmFsIGJlZm9y
ZSB3ZSBjYW4gd2FpdCBhZ2Fpbi4NCj4gV2UgY2FuJ3QgZ28gdG8gc2xlZXAgd2l0aCBhIHBlbmRp
bmcgc2lnbmFsLg0KDQpUaGlzIHNlZW1zIHRvIGJlIGFuIHVuYW1iaWd1b3VzIGJ1ZywgYXQgbGVh
c3QgYWNjb3JkaW5nIHRvIHRoZSBCVUdTDQpzZWN0aW9uIG9mIHRoZSBwdHJhY2UgbWFuIHBhZ2Uu
IFRoZSBiZWhhdmlvciBvZiBlcG9sbF93YWl0IGlzIGV4cGxpY2l0bHkNCmNhbGxlZCBvdXQgYXMg
YmVpbmcgYnVnZ3kvd3JvbmcsIGFuZCB3ZSdyZSBlbXVsYXRpbmcgaXRzIGJlaGF2aW9yLiBBcw0K
Zm9yIHRoZSBhcHBsaWNhdGlvbiB3YW50aW5nIHRvIGhhbmRsZSB0aGUgc2lnbmFsLCBpbiB0aG9z
ZSBjYXNlcywgaXQNCndvdWxkIGNob29zZSB0byBpbnN0YWxsIGEgc2lnbmFsIGhhbmRsZXIsIGlu
IHdoaWNoIGNhc2UgSSBhYnNvbHV0ZWx5DQphZ3JlZSB0aGF0IHJldHVybmluZyAtRUlOVFIgaXMg
dGhlIHJpZ2h0IHRoaW5nIHRvIGRvLiBJJ20gb25seSB0YWxraW5nDQphYm91dCB0aGUgY2FzZSB3
aGVyZSB0aGUgYXBwbGljYXRpb24gZGlkbid0IGNob29zZSB0byBpbnN0YWxsIGEgc2lnbmFsDQpo
YW5kbGVyIChhbmQgdGhlIHNpZ25hbCB3b3VsZCBoYXZlIGJlZW4gY29tcGxldGVseSBpbnZpc2li
bGUgdG8gdGhlDQpwcm9jZXNzIGhhZCBpdCBub3QgYmVlbiBiZWluZyB0cmFjZWQpLg0KDQpKb3Nl
cGggQy4gU2libGUNCg==
