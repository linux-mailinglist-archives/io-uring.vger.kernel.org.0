Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AE42968EC
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 05:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375115AbgJWD5i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 23:57:38 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:34752
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S370032AbgJWD5i (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 22 Oct 2020 23:57:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJilAXiL6mP3v6XAbeKq41xp54ANG7KxSJtwAZ0ObcEizDkjGP70hxhcsn2HvhirYpTs57JgqrbLQw2JtyH4ZYQTHWTQL1RgvQ96uZxIKJgWYTf4tglT4cNqbnJGS2dKQ41eYigwVASeqqU0hLy08I8naVPN1PfGbM2GVoU/l/Qkq/gS/3we7GyPh8HQX/4HeeMPkYQlYp/mWrUrSCKbkGxs/wAlIrJZYxjArI2mXwgJVz2lkjJqjJT4hiwaUruCi5Z8aeqyQfXHOlLJRRtawRf677dpLf6hbBc7ynYyIXOrC06n+qTuoKS/PMWjfTpc4nJSTqsxNPKyVSbb7NA/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu22tUf21nu1+gcpdlf+Frn35Hf6HgYhpcDafdoSpJE=;
 b=DgePUWnTI2+1yo9DTfJwPfD61gZrWMJejBBDRND/AK3fKxnSwecj1+kdDI54ywxI7XKwtdQ1xkhEKxwFjgDvADxKSRn/5ct3bT77p5Z1Gwcdf7WxMf3imWxzwFmfhSXv32/l9Jr2iPfZEJOLn+NEStBz9055n9hn6wbdsCEx8YWIyPokOFwiakYI8VXirfC/IKNub4T3AobTzyt3oBP87nX7tRoE6ObRn6gCMuTtOV9QzZV12eiifnW5T1Hem1YBeixBQ3qcF74R0Hi6hu8PASeYIANyQBethzkRAanHMFMLiZWcXrKWGjullVkLx/EP+97mTPMVScYx4KP77/jhPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu22tUf21nu1+gcpdlf+Frn35Hf6HgYhpcDafdoSpJE=;
 b=QnR/WUVD2pOuII4xUULYVaYg8owMh7KcDTIIZGtSZqhyPouDaQ1APg2Ley2t5uGStiEPmEEacxkpWomVqfFZsgJTFPFsT5MUc5Ml/pP1jXYsww+NH1OyUPgVDK5zQDvLwnPJVQ38r1Bdiiec5KJUe9QdihIPqQuj8kAc2S71Bq4=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB3223.namprd11.prod.outlook.com (2603:10b6:a03:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Fri, 23 Oct
 2020 03:57:31 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Fri, 23 Oct 2020
 03:57:31 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogUXVlc3Rpb24gb24gaW8td3E=?=
Thread-Topic: Question on io-wq
Thread-Index: AQHWqFIIJfBUWm45qk6/o7Xr3klK5qmjqOaAgADl1fCAAAFT6A==
Date:   Fri, 23 Oct 2020 03:57:31 +0000
Message-ID: <BYAPR11MB2632500DAAE5C09DA7C5A6C9FF1A0@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <98c41fba-87fe-b08d-2c8c-da404f91ef31@windriver.com>,<8dd4bc4c-9d8e-fb5a-6931-3e861ad9b4bf@kernel.dk>,<BYAPR11MB2632F2892640FCF08997B36AFF1A0@BYAPR11MB2632.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB2632F2892640FCF08997B36AFF1A0@BYAPR11MB2632.namprd11.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed9d9d3a-6889-41f7-42ed-08d87707c451
x-ms-traffictypediagnostic: BYAPR11MB3223:
x-microsoft-antispam-prvs: <BYAPR11MB3223C6D8D4A0C160AF9F510CFF1A0@BYAPR11MB3223.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lS3ERxEktofW+ibP1Nr7q/TJoEqoUwJtxV6YGY2ZbnNF0m7n74tRZYs1NiZrm4tBl/p8DkvdZibgHJ16oL/rNC5S8WelythrVHZUqPp4pHCM3DO/fvaXVaj/GXqIuBmbjTNe+o2JTs9WY6EY6VEONK1aUxJ2m6hXBIKJZgjDZgTOosHZwpR+rTn7OGNs/RpN+tLFR3mPEXCpS279hxfljYpKYMYz1N0qCZPoy9q2qS1H/vbj1QWa+NGZITDo/jVBCj6qv+xd9v9m8H7P6vzvpoMm67KLAQi4Nh2BDf/DF96QDdtYe/p8qqftsi67pUbg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(396003)(346002)(136003)(224303003)(86362001)(2940100002)(83380400001)(8936002)(71200400001)(4326008)(316002)(54906003)(33656002)(5660300002)(7696005)(26005)(66946007)(9686003)(55016002)(2906002)(6916009)(52536014)(66556008)(91956017)(64756008)(66446008)(6506007)(76116006)(53546011)(66476007)(186003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: t/aPvEy/xV0MNvX2+bKgxykTP5GZcsn9yCadOpX2qxaa9RKPbStOXT6Z+5LTfsBO4CjrnnykQLALfpOTdB6SSZG/Fv4sxc+z4mwjBRy0iHKyTo9MF25ZMsYxKpobTyMQY/IYdy1RLJXCSyjW+BUL961po5lHHY0B3gyk5O7dUdG7mNBliemv+uxLHn6vMnZVIxalGV47PZ1FrHZIz3piXSlQy2+pC+47YI43YwBWxpedOZb00EhqHk/I8aT3kQDaA75/AJ8CVunWX7N1GL5XUvhNMtMTkROa4I/hlGRBtcruFobA7ntwPWuc4X4L7Doln/7mpj8slj4N6lqWYuCxdn//A3e1UUindQVYuElfBwJTwWZjLZLACluSGcHmEHQVgXUbNnL+iseFW/UnXNmrOPlbIyuVAJ7Cyj6+bnKMk3I0qVbNHWuKzYIS9UF5VYyzal3W8HfV+gmab0ReXYwBGla7taKMwFPnvafyJLs9kQigMjdwyomF8IeXfUM34O/ClYZ5OKIWNZqFMWFP1/doZbPOt0SX9MATTDPOTSde8GWlg1Bz461TUzzhWKvv7bU6QMvTOlSZ9dALkX8MdXJ+LyqxgFx7m78VBWZSSP0KROOD763079g5yMVkz67wG3sGgIFstSQZiZvMMBckq3zLaw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9d9d3a-6889-41f7-42ed-08d87707c451
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2020 03:57:31.4391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gitMO8g7TaOJ+WTrmP2bhWC7y/Ogw+Qt3B1EKpQQLYa0Nj5aG5QYjKFRhzx1snqT0QQaMazUwCc8mwYZnRrGDgFz9LV8MFqwvqhV0zrBnyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3223
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogWmhhbmcs
IFFpYW5nIDxRaWFuZy5aaGFuZ0B3aW5kcml2ZXIuY29tPgq3osvNyrG85DogMjAyMMTqMTDUwjIz
yNUgMTE6NTUKytW8/sjLOiBKZW5zIEF4Ym9lCrOty806IHZpcm9AemVuaXYubGludXgub3JnLnVr
OyBpby11cmluZ0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnCtb3zOI6ILvYuLQ6IFF1ZXN0aW9uIG9uIGlv
LXdxCgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Kt6K8/sjLOiBK
ZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Creiy83KsbzkOiAyMDIwxOoxMNTCMjLI1SAyMjow
OArK1bz+yMs6IFpoYW5nLCBRaWFuZwqzrcvNOiB2aXJvQHplbml2LmxpbnV4Lm9yZy51azsgaW8t
dXJpbmdAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1mc2RldmVsQHZnZXIua2VybmVsLm9yZwrW98ziOiBSZTogUXVlc3Rpb24gb24gaW8td3EKCk9u
IDEwLzIyLzIwIDM6MDIgQU0sIFpoYW5nLFFpYW5nIHdyb3RlOgo+Cj4gSGkgSmVucyBBeGJvZQo+
Cj4gVGhlcmUgYXJlIHNvbWUgcHJvYmxlbSBpbiAnaW9fd3FlX3dvcmtlcicgdGhyZWFkLCB3aGVu
IHRoZQo+ICdpb193cWVfd29ya2VyJyBiZSBjcmVhdGUgYW5kICBTZXR0aW5nIHRoZSBhZmZpbml0
eSBvZiBDUFVzIGluIE5VTUEKPiBub2RlcywgZHVlIHRvIENQVSBob3RwbHVnLCBXaGVuIHRoZSBs
YXN0IENQVSBnb2luZyBkb3duLCB0aGUKPiAnaW9fd3FlX3dvcmtlcicgdGhyZWFkIHdpbGwgcnVu
IGFueXdoZXJlLiB3aGVuIHRoZSBDUFUgaW4gdGhlIG5vZGUgZ29lcwo+IG9ubGluZSBhZ2Fpbiwg
d2Ugc2hvdWxkIHJlc3RvcmUgdGhlaXIgY3B1IGJpbmRpbmdzPwoKPlNvbWV0aGluZyBsaWtlIHRo
ZSBiZWxvdyBzaG91bGQgaGVscCBpbiBlbnN1cmluZyBhZmZpbml0aWVzIGFyZQo+YWx3YXlzIGNv
cnJlY3QgLSB0cmlnZ2VyIGFuIGFmZmluaXR5IHNldCBmb3IgYW4gb25saW5lIENQVSBldmVudC4g
V2UKPnNob3VsZCBub3QgbmVlZCB0byBkbyBpdCBmb3Igb2ZmbGluaW5nLiBDYW4geW91IHRlc3Qg
aXQ/CgoKPmRpZmYgLS1naXQgYS9mcy9pby13cS5jIGIvZnMvaW8td3EuYwo+aW5kZXggNDAxMmZm
NTQxYjdiLi4zYmYwMjlkMTE3MGUgMTAwNjQ0Cj4tLS0gYS9mcy9pby13cS5jCj4rKysgYi9mcy9p
by13cS5jCj5AQCAtMTksNiArMTksNyBAQAogPiNpbmNsdWRlIDxsaW51eC90YXNrX3dvcmsuaD4K
ID4jaW5jbHVkZSA8bGludXgvYmxrLWNncm91cC5oPgogPiNpbmNsdWRlIDxsaW51eC9hdWRpdC5o
Pgo+KyNpbmNsdWRlIDxsaW51eC9jcHUuaD4KCiA+I2luY2x1ZGUgImlvLXdxLmgiCj4KPkBAIC0x
MjMsOSArMTI0LDEzIEBAIHN0cnVjdCBpb193cSB7CiA+ICAgICAgIHJlZmNvdW50X3QgcmVmczsK
ICA+ICAgICAgc3RydWN0IGNvbXBsZXRpb24gZG9uZTsKPgo+KyAgICAgICBzdHJ1Y3QgaGxpc3Rf
bm9kZSBjcHVocF9ub2RlOwo+KwogPiAgICAgICByZWZjb3VudF90IHVzZV9yZWZzOwogPn07Cj4K
PitzdGF0aWMgZW51bSBjcHVocF9zdGF0ZSBpb193cV9vbmxpbmU7Cj4rCiA+c3RhdGljIGJvb2wg
aW9fd29ya2VyX2dldChzdHJ1Y3QgaW9fd29ya2VyICp3b3JrZXIpCiA+ewogICA+ICAgICByZXR1
cm4gcmVmY291bnRfaW5jX25vdF96ZXJvKCZ3b3JrZXItPnJlZik7Cj5AQCAtMTA5Niw2ICsxMTAx
LDEzIEBAIHN0cnVjdCBpb193cSAqaW9fd3FfY3JlYXRlKHVuc2lnbmVkIGJvdW5kZWQsID5zdHJ1
Y3QgaW9fd3FfZGF0YSAqZGF0YSkKID4gICAgICAgICAgICAgICByZXR1cm4gRVJSX1BUUigtRU5P
TUVNKTsKICA+ICAgICAgfQo+Cj4rICAgICAgIHJldCA9IGNwdWhwX3N0YXRlX2FkZF9pbnN0YW5j
ZV9ub2NhbGxzKGlvX3dxX29ubGluZSwgPiZ3cS0+Y3B1aHBfbm9kZSk7Cj4rICAgICAgIGlmIChy
ZXQpIHsKPisgICAgICAgICAgICAgICBrZnJlZSh3cS0+d3Flcyk7Cj4rICAgICAgICAgICAgICAg
a2ZyZWUod3EpOwo+KyAgICAgICAgICAgICAgIHJldHVybiBFUlJfUFRSKHJldCk7Cj4rICAgICAg
IH0KPisKPiAgICAgICAgd3EtPmZyZWVfd29yayA9IGRhdGEtPmZyZWVfd29yazsKPiAgICAgICAg
d3EtPmRvX3dvcmsgPSBkYXRhLT5kb193b3JrOwo+Cj5AQCAtMTE0NSw2ICsxMTU3LDcgQEAgc3Ry
dWN0IGlvX3dxICppb193cV9jcmVhdGUodW5zaWduZWQgYm91bmRlZCwgPnN0cnVjdCBpb193cV9k
YXRhICpkYXRhKQogPiAgICAgICByZXQgPSBQVFJfRVJSKHdxLT5tYW5hZ2VyKTsKID4gICAgICAg
Y29tcGxldGUoJndxLT5kb25lKTsKID5lcnI6Cj4rICAgICAgIGNwdWhwX3N0YXRlX3JlbW92ZV9p
bnN0YW5jZV9ub2NhbGxzKGlvX3dxX29ubGluZSwgPiZ3cS0+Y3B1aHBfbm9kZSk7CiAgPiAgICAg
IGZvcl9lYWNoX25vZGUobm9kZSkKID4gICAgICAgICAgICAgICBrZnJlZSh3cS0+d3Flc1tub2Rl
XSk7CiA+ICAgICAgIGtmcmVlKHdxLT53cWVzKTsKPkBAIC0xMTY0LDYgKzExNzcsOCBAQCBzdGF0
aWMgdm9pZCBfX2lvX3dxX2Rlc3Ryb3koc3RydWN0IGlvX3dxICp3cSkKID57CiA+ICAgICAgIGlu
dCBub2RlOwo+Cj4rICAgICAgIGNwdWhwX3N0YXRlX3JlbW92ZV9pbnN0YW5jZV9ub2NhbGxzKGlv
X3dxX29ubGluZSwgPiZ3cS0+Y3B1aHBfbm9kZSk7Cj4rCiAgID4gICAgIHNldF9iaXQoSU9fV1Ff
QklUX0VYSVQsICZ3cS0+c3RhdGUpOwogID4gICAgICBpZiAod3EtPm1hbmFnZXIpCiA+ICAgICAg
ICAgICAgICAga3RocmVhZF9zdG9wKHdxLT5tYW5hZ2VyKTsKPkBAIC0xMTkxLDMgKzEyMDYsNDAg
QEAgc3RydWN0IHRhc2tfc3RydWN0ICppb193cV9nZXRfdGFzayhzdHJ1Y3QgaW9fd3EgPip3cSkK
ID57CiA+ICAgICAgcmV0dXJuIHdxLT5tYW5hZ2VyOwogPn0KPisKPitzdGF0aWMgYm9vbCBpb193
cV93b3JrZXJfYWZmaW5pdHkoc3RydWN0IGlvX3dvcmtlciAqd29ya2VyLCB2b2lkICpkYXRhKQo+
K3sKPisgICAgICAgc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrID0gd29ya2VyLT50YXNrOwo+KyAg
ICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOwo+KwogICAgICAgICAgIHN0cnVjdCBycV9mbGFncyBy
ZjsKICAgICAgICAgICBzdHJ1Y3QgcnEgKnJxOwogICAgICAgICAgIHJxID0gdGFza19ycV9sb2Nr
KHRhc2ssICZyZik7CgotLS0gICAgICAgcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZ0YXNrLT5waV9s
b2NrLCBmbGFncyk7Cj4rICAgICAgIGRvX3NldF9jcHVzX2FsbG93ZWQodGFzaywgY3B1bWFza19v
Zl9ub2RlKHdvcmtlci0+d3FlLT5ub2RlKSk7Cj4rICAgICAgIHRhc2stPmZsYWdzIHw9IFBGX05P
X1NFVEFGRklOSVRZOwotLS0gICAgICByYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGFzay0+
cGlfbG9jaywgZmxhZ3MpOwogICAgICAgICAgIAogICAgICAgICAgICAgIHRhc2tfcnFfdW5sb2Nr
KHJxLCB0YXNrLCAmcmYpOwoKPisgICAgICAgcmV0dXJuIGZhbHNlOwo+K30KPisKPitzdGF0aWMg
aW50IGlvX3dxX2NwdV9vbmxpbmUodW5zaWduZWQgaW50IGNwdSwgc3RydWN0IGhsaXN0X25vZGUg
Km5vZGUpCj4rewo+KyAgICAgICBzdHJ1Y3QgaW9fd3EgKndxID0gaGxpc3RfZW50cnlfc2FmZShu
b2RlLCBzdHJ1Y3QgaW9fd3EsIGNwdWhwX25vZGUpOwo+KyAgICAgICBpbnQgaTsKPisKPisgICAg
ICAgcmN1X3JlYWRfbG9jaygpOwo+KyAgICAgICBmb3JfZWFjaF9ub2RlKGkpCj4rICAgICAgICAg
ICAgICAgaW9fd3FfZm9yX2VhY2hfd29ya2VyKHdxLT53cWVzW2ldLCBpb193cV93b3JrZXJfYWZm
aW5pdHksID5OVUxMKTsKPisgICAgICAgcmN1X3JlYWRfdW5sb2NrKCk7Cj4rICAgICAgIHJldHVy
biAwOwo+K30KPisKPitzdGF0aWMgX19pbml0IGludCBpb193cV9pbml0KHZvaWQpCj4rewo+KyAg
ICAgICBpbnQgcmV0Owo+Kwo+KyAgICAgICByZXQgPSBjcHVocF9zZXR1cF9zdGF0ZV9tdWx0aShD
UFVIUF9BUF9PTkxJTkVfRFlOLCA+ImlvLT53cS9vbmxpbmUiLAo+KyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGlvX3dxX2NwdV9vbmxpbmUsIE5VTEwpOwo+KyAgICAgICBp
ZiAocmV0IDwgMCkKPisgICAgICAgICAgICAgICByZXR1cm4gcmV0Owo+KyAgICAgICBpb193cV9v
bmxpbmUgPSByZXQ7Cj4rICAgICAgIHJldHVybiAwOwo+K30KPitzdWJzeXNfaW5pdGNhbGwoaW9f
d3FfaW5pdCk7Cj4KPi0tCj5KZW5zIEF4Ym9lCgo=
