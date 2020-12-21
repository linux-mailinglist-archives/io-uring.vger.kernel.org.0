Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5915C2E0142
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 20:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgLUTwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 14:52:44 -0500
Received: from mail-eopbgr680066.outbound.protection.outlook.com ([40.107.68.66]:52868
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgLUTwn (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 21 Dec 2020 14:52:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAicNhQZ9HuJ+r6JIeXryDnR+fCYr57VtXRkyFrypR5lkdkYusuKjatNGD7bzXuZ/rP4XQxNNu75dz+vMEjutXsnKJGpqcfiYGYeCkIHpk4gWGpo8OR6sAJMf+iWw8tsz+yxrUBz4Yait5o6Xbn4ViwL5CZZJUVvaaBkj/ZxjpVoBqKCufimq7I6lOSYpKYdwtLkCnisF5gzufBsxBf8CrNXZEmveRLkbxbObPmbMrKQiLZTRybzDuIUX8uz9Rhmt8Z0oXrnPZmoG4Bz4K97Abz48G8noXNRx/0P1aUn7wSwygYCr8ffORiKluqM9qP89+U//5lmkWmFaFioAVAYHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOowHVkO9BAVArQ3BI8BQKgxB0ML6N+RSePRfx6Qeoo=;
 b=ATSr+FNTCABkdbMh5ZZ1ep7ubYSoDBgNOqLuxhGajoM8DbzWVcQARuo/qBAOo0q7giH+cWCxEF/KhDoSb0+l376kf46/N5i6QqUMlP6VnfVykeDlNpe/Xrana1ZfC1rcfg+M4rz9B0wdCMr8Y2j8bmy+a14DxjDf4wAUqkPw9OPmX/6f9b9CAZujBHSt3NJpzQN86Lmrjqg7PRKdEGyJsPQbvbCpY8gHWLEj5wemgOD0b37woXMta3i2cFm/rpNl/UooHO76FbFZhcAZMnTTjkKafW356fPhDIT8zGAO1WUwXJA1VxTQfHMGovG/TFFzAONHkDSU3uEDGzKAxsYewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOowHVkO9BAVArQ3BI8BQKgxB0ML6N+RSePRfx6Qeoo=;
 b=nl206Qy0wKPkpNx81MAv60+kY/vThdItXRWt1E6oC32K7/JImo+HHvpR+QKdPsyDyuWn2YVwk7sufLA5plZDE4An5PV4TN3lGSkdovvvccsYorPMfDv6suNozXZwCr719ojPX24fWPVRFqNUPD5qS7jISDXO+IAeIx3IfzCMotE=
Received: from BL0PR05MB4772.namprd05.prod.outlook.com (2603:10b6:208:29::17)
 by BL0PR05MB5553.namprd05.prod.outlook.com (2603:10b6:208:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.24; Mon, 21 Dec
 2020 19:51:53 +0000
Received: from BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::cd2a:22df:cd7f:937d]) by BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::cd2a:22df:cd7f:937d%7]) with mapi id 15.20.3700.026; Mon, 21 Dec 2020
 19:51:52 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 03/13] selftests/vm/userfaultfd: wake after copy
 failure
Thread-Topic: [RFC PATCH 03/13] selftests/vm/userfaultfd: wake after copy
 failure
Thread-Index: AQHW18+FycdL3uClaE6RLwJGWN/OTaoB9dSA
Date:   Mon, 21 Dec 2020 19:51:52 +0000
Message-ID: <2B08ECCA-A7D2-4743-8956-571CB8788FDA@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-4-namit@vmware.com> <20201221192846.GH6640@xz-x1>
In-Reply-To: <20201221192846.GH6640@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:104c:8d35:de28:b8dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f48a03f1-9cb9-4a98-36b3-08d8a5e9dd28
x-ms-traffictypediagnostic: BL0PR05MB5553:
x-microsoft-antispam-prvs: <BL0PR05MB55534283F457A07DC3D2A385D0C00@BL0PR05MB5553.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9QVArjQVz2AWr07iLlmrFHBjjH/yhScnpeefmr6zLJ2eq4jO+mLwPj4WI6NfbUvlcacvbu1EBzX7fyEp6ZwD0E8hvNSYp/2aZVPiVjqHO43lUxoGHW0AcSirfA322dwg4Ez2GP0Ls2jTz/6WClIo7uhtRezjHR//Ebgib+yHgUdGcHLlVMlCW6F03rv9CSrafo+HdR3Pch4eVN4NxCINlP56j7PpBhwt3Fs4/UwhHOUhLrxaUIH5j9mMjjEgRTER7MdCI5HTGnOCiyd8SIVwfbHA3ANBCNl9z6HdrNF4bPiWVbiCDpKgfeIMv7oYfw6feeEpiHebSDoyDAZd+3NNHD//VMJ4NQpnCSPoWSc8B/+FX03fxHbShW3reVxKirM3Z0mO1b++/zf9wLOuHaXQsqkISuAUqcFo+y3fgIFa56AIQaOaLi8SW1sz7XNHlhmM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB4772.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(64756008)(66446008)(36756003)(6916009)(4326008)(71200400001)(86362001)(2906002)(83380400001)(6486002)(91956017)(6512007)(316002)(76116006)(2616005)(53546011)(33656002)(478600001)(8936002)(66556008)(5660300002)(8676002)(54906003)(186003)(66946007)(6506007)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZkdqSVRuS29GbkhrWmQzT2N5YzEwODJjTENtaVZLZHFTNmtCZkd2OHJTenVB?=
 =?utf-8?B?V01nczZDRys5L1VWcWtWV2Z6cmdnV3NnR1FVZ1IrcGI5WnhKMjZJZklrVHJw?=
 =?utf-8?B?cHRXYmMyeHowTml6L2dLcG9kYWNrQTFPTVJoUnJzcHZjT29SM2JNRy8reldI?=
 =?utf-8?B?VWR5VEs1NDZRZ0p4VmFaWkppMWluOGNSRkFvRFpwakEycWZXYXEzUC9xSTda?=
 =?utf-8?B?NmVTVE15REdqN3oreDJJU2Fad25IeUc3VVJkcGcyVGtheXpjT2hyOW0vR3Jx?=
 =?utf-8?B?bmdhVXc3QXgySVl4YXZBOUtDaXBjMXE0RVhMYVVyVmdXSmxyY1h6OEtTK2tr?=
 =?utf-8?B?Z1VlaXJhdVpuK2h6SkZTZEdIbkRFWVFZV1FCZ1VtOGF5VTRQZUYzS2w4MDBq?=
 =?utf-8?B?Zk10UmpqNW9FYmcxc0I0VG93cGJQNmIxTjBGTmozMzI0Q0l1dEF1UUNpQ2NL?=
 =?utf-8?B?ZElrSnNzOGsxZmxXS0tYOWpTZHh1WUdQcWUwOUs1eTZpRjZBdU1XRmlNOWcx?=
 =?utf-8?B?U1RxYUJUbWRMZEsvYnNtU0sydWJTOFdGYXRuUTV3ZUZPRU43OU5KOWRjeExs?=
 =?utf-8?B?NFJKZHA5MG5ndlE2UzdWQlMwRWxQSTFvbC9VRzZ4YUYwV1BweVdPMGNIRXAz?=
 =?utf-8?B?YlhzNWowZkJxTkFqdWVOeEFIU2dIS0RiUlVpdHovU3liOXoyQWJGenZGbS8x?=
 =?utf-8?B?VWM4WjBWaXFoQVVibk05czBzcnZVOHkzQmFOejF3d3FocUg1d3B2WXBwYmhh?=
 =?utf-8?B?aUtQakNOZk8wbWU2S1VYcEFrR3ZDc3hIVWZZV1JTU1V4WW1JWU1UYXFhN3V4?=
 =?utf-8?B?b0YwaENTSjRXcTlFRDU5dldVbHFEQ0VKei9TR0FybVZLUTUyZUtOdDJ3Y3Yw?=
 =?utf-8?B?Q2NtaVRpNmRTY2JUcjVadHhsOGZDRmNKV1ZjeUF0alpoVVBNV3NEbXY3eU0v?=
 =?utf-8?B?MmxDZzl6UWszMGVoWFJBZjhaSmw3bTJXd09XSGlGd204bGJSVStsenJ2R1JS?=
 =?utf-8?B?N0t1aFJ6ZVJQVSs4eTBUbC9HQ1duMWQ1blhIY0JkY0I5ODJMekdrNFk1MnNo?=
 =?utf-8?B?cUVrUXgxNHB0U1VtRVA1R2xCSndpRWZXNXVIUml5cUVVRWJmb3UzcWk1aUtP?=
 =?utf-8?B?UXlqODRIY3VjWnI3MGpmSmxoU0dBb0NFcWhtS3RlaWdWM0ZjR2JZRmNCZ3Q2?=
 =?utf-8?B?bW1weEoxQVRocklsQUordEtlZ0JscW9kRU5kOWdVMEs5bDZBTlBWbkV6eVlq?=
 =?utf-8?B?NklpdUFiV0VTWlg1V0NmZWNFbXNNa3RXa3NqY05DeFBVSVhucGw2UDI5UHUy?=
 =?utf-8?B?eG84djZKQlo2dGUwK1lqUkFPTFlLYnUvN1Q1bXY2ejFMOWZDOHVrZWI3dnBG?=
 =?utf-8?B?YmhlRlA3K1NmOEdGUUVkbFNKMmh6STEvSTVNcWJkRGVNdndSem0vdjJjaGRD?=
 =?utf-8?Q?Hllaxicl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E74FAB526238A14386E5045504682126@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB4772.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48a03f1-9cb9-4a98-36b3-08d8a5e9dd28
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 19:51:52.8179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XygaxrBl4XaSyUPh/lNcwHJ/FLgSO2eqNLLoFE/2WwyUzifYzk4jV0LxKhH1KbXUZIsdCE6rDwGIaTUiF3NXeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5553
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

PiBPbiBEZWMgMjEsIDIwMjAsIGF0IDExOjI4IEFNLCBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5j
b20+IHdyb3RlOg0KPiANCj4gT24gU2F0LCBOb3YgMjgsIDIwMjAgYXQgMDQ6NDU6MzhQTSAtMDgw
MCwgTmFkYXYgQW1pdCB3cm90ZToNCj4+IEZyb206IE5hZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5j
b20+DQo+PiANCj4+IFdoZW4gdXNlcmZhdWx0ZmQgY29weS1pb2N0bCBmYWlscyBzaW5jZSB0aGUg
UFRFIGFscmVhZHkgZXhpc3RzLCBhbg0KPj4gLUVFWElTVCBlcnJvciBpcyByZXR1cm5lZCBhbmQg
dGhlIGZhdWx0aW5nIHRocmVhZCBpcyBub3Qgd29rZW4uIFRoZQ0KPj4gY3VycmVudCB1c2VyZmF1
bHRmZCB0ZXN0IGRvZXMgbm90IHdha2UgdGhlIGZhdWx0aW5nIHRocmVhZCBpbiBzdWNoIGNhc2Uu
DQo+PiBUaGUgYXNzdW1wdGlvbiBpcyBwcmVzdW1hYmx5IHRoYXQgYW5vdGhlciB0aHJlYWQgc2V0
IHRoZSBQVEUgdGhyb3VnaA0KPj4gY29weS93cCBpb2N0bCBhbmQgd291bGQgd2FrZSB0aGUgZmF1
bHRpbmcgdGhyZWFkIG9yIHRoYXQgYWx0ZXJuYXRpdmVseQ0KPj4gdGhlIGZhdWx0IGhhbmRsZXIg
d291bGQgcmVhbGl6ZSB0aGVyZSBpcyBubyBuZWVkIHRvICJtdXN0X3dhaXQiIGFuZA0KPj4gY29u
dGludWUuIFRoaXMgaXMgbm90IG5lY2Vzc2FyaWx5IHRydWUuDQo+PiANCj4+IFRoZXJlIGlzIGFu
IGFzc3VtcHRpb24gdGhhdCB0aGUgIm11c3Rfd2FpdCIgdGVzdHMgaW4gaGFuZGxlX3VzZXJmYXVs
dCgpDQo+PiBhcmUgc3VmZmljaWVudCB0byBwcm92aWRlIGRlZmluaXRpdmUgYW5zd2VyIHdoZXRo
ZXIgdGhlIG9mZmVuZGluZyBQVEUgaXMNCj4+IHBvcHVsYXRlZCBvciBub3QuIEhvd2V2ZXIsIHVz
ZXJmYXVsdGZkX211c3Rfd2FpdCgpIHRlc3QgaXMgbG9ja2xlc3MuDQo+PiBDb25zZXF1ZW50bHks
IGNvbmN1cnJlbnQgY2FsbHMgdG8gcHRlcF9tb2RpZnlfcHJvdF9zdGFydCgpLCBmb3INCj4+IGlu
c3RhbmNlLCBjYW4gY2xlYXIgdGhlIFBURSBhbmQgY2FuIGNhdXNlIHVzZXJmYXVsdGZkX211c3Rf
d2FpdCgpDQo+PiB0byB3cm9uZ2x5IGFzc3VtZSBpdCBpcyBub3QgcG9wdWxhdGVkIGFuZCBhIHdh
aXQgaXMgbmVlZGVkLg0KPiANCj4gWWVzIHVzZXJmYXVsdGZkX211c3Rfd2FpdCgpIGlzIGxvY2ts
ZXNzLCBob3dldmVyIG15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB3ZSdsbA0KPiBlbnF1ZXVlIGJl
Zm9yZSByZWFkaW5nIHRoZSBwYWdlIHRhYmxlLCB3aGljaCBzZWVtcyB0byBtZSB0aGF0IHdlJ2xs
IGFsd2F5cyBnZXQNCj4gbm90aWZpZWQgZXZlbiB0aGUgcmFjZSBoYXBwZW5zLiAgU2hvdWxkIGFw
cGx5IHRvIGVpdGhlciBVRkZESU9fV1JJVEVQUk9URUNUIG9yDQo+IFVGRkRJT19DT1BZLCBpaXVj
LCBhcyBsb25nIGFzIHdlIGZvbGxvdyB0aGUgb3JkZXIgb2YgKDEpIG1vZGlmeSBwZ3RhYmxlICgy
KQ0KPiB3YWtlIHNsZWVwaW5nIHRocmVhZHMuICBUaGVuIGl0IGFsc28gbWVhbnMgdGhhdCB3aGVu
IG11c3Rfd2FpdCgpIHJldHVybmVkIHRydWUsDQo+IGl0IHNob3VsZCBhbHdheXMgZ2V0IHdha2Vk
IHVwIHdoZW4gZmF1bHQgcmVzb2x2ZWQuDQo+IA0KPiBUYWtpbmcgVUZGRElPX0NPUFkgYXMgZXhh
bXBsZSwgZXZlbiBpZiBVRkZESU9fQ09QWSBoYXBwZW4gcmlnaHQgYmVmb3JlDQo+IG11c3Rfd2Fp
dCgpIGNhbGxzOg0KPiANCj4gICAgICAgd29ya2VyIHRocmVhZCAgICAgICAgICAgICAgICAgICAg
ICAgdWZmZCB0aHJlYWQNCj4gICAgICAgLS0tLS0tLS0tLS0tLSAgICAgICAgICAgICAgICAgICAg
ICAgLS0tLS0tLS0tLS0NCj4gDQo+ICAgaGFuZGxlX3VzZXJmYXVsdA0KPiAgICBzcGluX2xvY2so
ZmF1bHRfcGVuZGluZ193cWgpDQo+ICAgIGVucXVldWUoKQ0KPiAgICBzZXRfY3VycmVudF9zdGF0
ZShJTlRFUlJVUFRJQkxFKQ0KPiAgICBzcGluX3VubG9jayhmYXVsdF9wZW5kaW5nX3dxaCkNCj4g
ICAgbXVzdF93YWl0KCkNCj4gICAgICBsb2NrbGVzcyB3YWxrIHBhZ2UgdGFibGUNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgVUZGRElPX0NPUFkNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmaWxsIGluIHRoZSBob2xlDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgd2FrZSB1cCB0aHJl
YWRzDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAodGhp
cyB3aWxsIHdha2UgdXAgd29ya2VyIHRocmVhZCB0b28/KQ0KPiAgICBzY2hlZHVsZSgpDQo+ICAg
ICAgKHdoaWNoIG1heSByZXR1cm4gaW1tZWRpYXRlbHk/KQ0KPiANCj4gV2hpbGUgaGVyZSBmYXVs
dF9wZW5kaW5nX3dxaCBpcyBsb2NrIHByb3RlY3RlZC4gSSBqdXN0IGZlZWwgbGlrZSB0aGVyZSdz
IHNvbWUNCj4gb3RoZXIgcmVhc29uIHRvIGNhdXNlIHRoZSB0aHJlYWQgdG8gc3RhbGwuICBPciBk
aWQgSSBtaXNzIHNvbWV0aGluZz8NCg0KQnV0IHdoYXQgaGFwcGVucyBpZiB0aGUgY29weSBjb21w
bGV0ZWQgYmVmb3JlIHRoZSBlbnF1ZXVpbmc/IEFzc3VtZQ0KdGhlIHBhZ2UgaXMgd3JpdGUtcHJv
dGVjdGVkIGR1cmluZyBVRkZESU9fQ09QWToNCg0KDQpjcHUwCQkJCQljcHUxCQkNCi0tLS0JCQkJ
CS0tLS0JCQkNCmhhbmRsZV91c2VyZmF1bHQNCgkJCQkJVUZGRElPX0NPUFkNCgkJCQkJWyB3cml0
ZS1wcm90ZWN0ZWQgXQ0KCQkJCSAJIGZpbGwgaW4gdGhlIGhvbGUNCgkJCQkgCSB3YWtlIHVwIHRo
cmVhZHMNCgkJCQkgCSBbbm90aGluZyB0byB3YWtlXQ0KCQkJCQkJCQ0KCQkJCQlVRkZEX1dQICh1
bnByb3RlY3QpDQoJCQkJCSBsb2dpY2FsbHkgbWFya3MgYXMgdW5wcm90ZWN0ZWQNCgkJCQkJIFtu
b3RoaW5nIHRvIHdha2VdDQoNCiBzcGluX2xvY2soZmF1bHRfcGVuZGluZ193cWgpDQogIGVucXVl
dWUoKQ0KICBzZXRfY3VycmVudF9zdGF0ZShJTlRFUlJVUFRJQkxFKQ0KICBzcGluX3VubG9jayhm
YXVsdF9wZW5kaW5nX3dxaCkNCiAgbXVzdF93YWl0KCkNCg0KCQkJCQlbICNQRiBvbiB0aGUgc2Ft
ZSBQVEUNCgkJCQkJIGR1ZSB0byB3cml0ZS1wcm90ZWN0aW9uIF0NCg0KCQkJCQkuLi4NCgkJCQkJ
IHdwX3BhZ2VfY29weSgpDQoJCQkJCSAgcHRlcF9jbGVhcl9mbHVzaF9ub3RpZnkoKQ0KCQkJCQkg
IFsgUFRFIGlzIGNsZWFyIF0NCgkJCQkJDQogICBsb2NrbGVzcyB3YWxrIHBhZ2UgdGFibGUNCiAg
ICBwdGVfbm9uZSgqcHRlKSAtPiBtdXN0IHdhaXQNCg0KTm90ZSB0aGF0IGFkZGl0aW9uYWwgc2Nl
bmFyaW9zIGFyZSBwb3NzaWJsZS4gRm9yIGluc3RhbmNlLCBpbnN0ZWFkIG9mDQp3cF9wYWdlX2Nv
cHkoKSwgd2UgY2FuIGhhdmUgb3RoZXIgY2hhbmdlX3B0ZV9yYW5nZSgpIChkdWUgdG8gd29ya2Vy
4oCZcw0KbXByb3RlY3QoKSBvciBOVU1BIGJhbGFuY2luZyksIGNhbGxpbmcgcHRlcF9tb2RpZnlf
cHJvdF9zdGFydCgpIGFuZCBjbGVhcmluZw0KdGhlIFBURS4NCg0KQW0gSSBtaXNzaW5nIHNvbWV0
aGluZz8NCg0K
