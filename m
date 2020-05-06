Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633761C7CC5
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 23:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgEFVqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 17:46:19 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:27983 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729114AbgEFVqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 17:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588801579; x=1620337579;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=JNkcS4lsuZP0g7EBRi8SqcPYsteUbR5HjYFGz6aCANU=;
  b=MGdYGie00Ga1hY85/V2OgWhWmqHx0LWf+e4GenzUej95sMJuhfxkrQEa
   IZ4HJ2Nx33Nq6YedvAU9S206wIDNfymOnGoz6iobQ1trmgla+5h5tNpMG
   ebtjenit0ek7jxOQVFS2/u2BD2TzfL823a9UeZ5OXhdwke0/1BJj9sy/z
   Y=;
IronPort-SDR: Dnna7WK3ceP+0wLejHEVsDRD4obr4ubGcCU4cveKcSXt1Hbq/PbOf6QlazSfuIEqE1J+QWdDXv
 cHoyFC+w43Pg==
X-IronPort-AV: E=Sophos;i="5.73,360,1583193600"; 
   d="scan'208";a="29103268"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 06 May 2020 21:46:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id ECF6EA24E1
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 21:46:04 +0000 (UTC)
Received: from EX13D10UEA003.ant.amazon.com (10.43.61.26) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 21:46:04 +0000
Received: from EX13D14UWB001.ant.amazon.com (10.43.161.158) by
 EX13D10UEA003.ant.amazon.com (10.43.61.26) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 21:46:03 +0000
Received: from EX13D14UWB001.ant.amazon.com ([10.43.161.158]) by
 EX13D14UWB001.ant.amazon.com ([10.43.161.158]) with mapi id 15.00.1497.006;
 Wed, 6 May 2020 21:46:03 +0000
From:   "Bhatia, Sumeet" <sumee@amazon.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "Hegde, Pramod" <phegde@amazon.com>
Subject: Non sequential linked chains and IO_LINK support
Thread-Topic: Non sequential linked chains and IO_LINK support
Thread-Index: AQHWI+9s4Fi5GrZNSkiih0IwBQ/oNA==
Date:   Wed, 6 May 2020 21:46:03 +0000
Message-ID: <1588801562969.24370@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.38]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGVsbG8gZXZlcnlvbmUsCgpJJ3ZlIGJlZW4gZXhwbG9yaW5nIGlvdXJpbmcgdG8gc3VibWl0IGRp
c2sgb3BlcmF0aW9ucy4gTXkgYXBwbGljYXRpb24gZ2VuZXJhdGVzIGRpc2sgb3BlcmF0aW9ucyBi
YXNlZCBvbiBzb21lIGV2ZW50cyBhbmQgb3BlcmF0aW9ucyBhcmUgdW5rbm93biB1bnRpbCB0aG9z
ZSBldmVudHMgb2NjdXIuICBTb21lIG9mIHRoZXNlIGRpc2sgb3BlcmF0aW9ucyBhcmUgaW50ZXJk
ZXBlbmRlbnQgb3RoZXJzIGFyZSBub3QuIAoKRXhhbXBsZTogRm9sbG93aW5nIG9wZXJhdGlvbnMg
YXJlIGdlbmVyYXRlZCBhbmQgc3VibWl0dGVkIGJlZm9yZSBhbnkgb2YgdGhlbSBhcmUgY29tcGxl
dGUKb3BlcmF0aW9uXzAgKGluZGVwZW5kZW50IG9wZXJhdGlvbikKb3BlcmF0aW9uXzEgKGluZGVw
ZW5kZW50IG9wZXJhdGlvbiks4oCLCm9wZXJhdGlvbl8yICh0byBiZSBpc3N1ZWQgb25seSBpZiBv
cGVyYXRpb25fMCB3YXMgc3VjY2Vzc2Z1bCksCm9wZXJhdGlvbl8zIChpbmRlcGVuZGVudCBvcGVy
YXRpb24pLApvcGVyYXRpb25fNCAodG8gYmUgaXNzdWVkIG9ubHkgaWYgb3BlcmF0aW9uXzEgd2Fz
IHN1Y2Nlc3NmdWwpCgpJbiBteSBleGFtcGxlIEkgaGF2ZSB0d28gaW5kZXBlbmRlbnQgbGluayBj
aGFpbnMsIChvcGVyYXRpb25fMCwgb3BlcmF0aW9uXzIpIGFuZCAob3BlcmF0aW9uXzEsIG9wZXJh
dGlvbl80KS4gIGlvdXJpbmcgZG9jdW1lbnRhdGlvbiBzdWdnZXN0cyBJT1NRRV9JT19MSU5LIGV4
cGVjdHMgbGluayBjaGFpbnMgdG8gYmUgc2VxdWVudGlhbCBhbmQgd2lsbCBub3Qgc3VwcG9ydCBt
eSB1c2UgY2FzZS4gCgpJIGV4cGxvcmVkIGNyZWF0aW5nIG5ldyBpb3VyaW5nIGNvbnRleHQgZm9y
IGVhY2ggb2YgdGhlc2UgbGlua2VkIGNoYWlucy4gQnV0IGl0IHR1cm5zIG91dCBkZXBlbmRpbmcg
b24gZGlzayBzaXplIHRoZXJlIGNhbiBiZSBzb21ld2hlcmUgYmV0d2VlbiA1MDAtMTAwMCBzdWNo
IGNoYWlucy4gSSdtIG5vdCBzdXJlIHdoZXRoZXIgaXQgaXMgcHJ1ZGVudCB0byBjcmVhdGUgdGhh
dCBtYW55IGlvdXJpbmcgY29udGV4dHMuCgpJIGFtIHJlYWNoaW5nIG91dCB0byBjaGVjayB3aGV0
aGVyIHRoZXJlIHdvdWxkIGJlIGEgZ2VuZXJpYyBuZWVkIHRvIHN1cHBvcnQgbm9uc2VxdWVudGlh
bCBsaW5rZWQgY2hhaW5zIG9uIGEgc2luZ2xlIGlvdXJpbmcgY29udGV4dC4gV291bGQgbG92ZSB0
byBoZWFyIGFsbCB5b3VyIHRob3VnaHRzLgoKVGhhbmtzLApTdW1lZXQ=
