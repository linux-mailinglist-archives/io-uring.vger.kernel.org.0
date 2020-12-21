Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DE62E01B6
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 21:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgLUUzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 15:55:39 -0500
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:50400
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbgLUUzi (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 21 Dec 2020 15:55:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/5jbaoeFdrktVc9R681KG401UEBJtFEhJIodJzF/F1mMsAYzEGovzt+22vA5KciorchPSyYH5jSS3Gk57OYOUPR7NrDyEiJFePkwcv7y33KPhteHHiJe5UBcQhsrTJClecn4edWcLj/9nHGqexBrM+VfbrqxtZkP8187g7Me/6nOLfnsSI2iyKajC+M2cdKZ8uVBrNOSDVOaHxQUaDEASQd+C7W1z0lh0H17GcMxIeNwYj5xDvZF20Q6YfuEEX3udReGY9/dTnjuL06m5ZQgoh2qKDqwiLq95uEnbADxWcvE2lVdLxBQ43rOLDuYbbxM7to8rLopd1yD3SRo6nD7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rzc3Q2FmjUTHNrSBHGf4m6BrY6TKWnQeczaJx/Jxe0=;
 b=hx4W3ssOU0w8B2P6OA+mPJCCaMBoj6RIVUwnrKVPtyAfFh9ICWlMvp36E3mTtTRw2n8MJQNZQgpTS3vCdfyAIyWkV1ojUINh46T2cdEQgYIA5yCiw9Q7wD7anTtr6kEQ5zVYHmXqBhid4l/hR9uivauoaAaWemOFHock2K7v2HTawljoxL2DYQC1a8QoilL/UZLjz8tzXbilSVWzR1d+QVlB2ksmCxlF7UmYu5dDZ9VQr+QVStNUTcN+JrdqRkvSGwxBUelfWLsp4gnMiB6SkXgk1Ew/bN0x7yKhhvB43WqW2iQQBeIrPS9vYDbQtAOvscOt4O3B0Y16QKuFhUPLiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rzc3Q2FmjUTHNrSBHGf4m6BrY6TKWnQeczaJx/Jxe0=;
 b=1hDMElFZ2VmR9N/4Lb3tzLJjWUqT6OSC7L2zZLiHHPuGMABj4cyN8j9WBZf0UDmySGx+BF97TESERL5Qx3DZjWaN4LBzOwQ4sgJt90DpJ+ZFh4Qx27PICnh+wexYlpBZeW71RNel60YFHz/LgPaO87tS/XaU3NDdJaPcYDhe7Do=
Received: from BL0PR05MB4772.namprd05.prod.outlook.com (2603:10b6:208:29::17)
 by MN2PR05MB7103.namprd05.prod.outlook.com (2603:10b6:208:196::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.24; Mon, 21 Dec
 2020 20:54:43 +0000
Received: from BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::cd2a:22df:cd7f:937d]) by BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::cd2a:22df:cd7f:937d%7]) with mapi id 15.20.3700.026; Mon, 21 Dec 2020
 20:54:43 +0000
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
Thread-Index: AQHW18+FycdL3uClaE6RLwJGWN/OTaoB9dSAgAARA4CAAACNgA==
Date:   Mon, 21 Dec 2020 20:54:43 +0000
Message-ID: <C45D3815-1214-4501-BCE6-46F1AB2CC77D@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-4-namit@vmware.com> <20201221192846.GH6640@xz-x1>
 <2B08ECCA-A7D2-4743-8956-571CB8788FDA@vmware.com>
 <20201221205245.GJ6640@xz-x1>
In-Reply-To: <20201221205245.GJ6640@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:104c:8d35:de28:b8dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c337e12b-a7be-423b-df3a-08d8a5f2a4d2
x-ms-traffictypediagnostic: MN2PR05MB7103:
x-microsoft-antispam-prvs: <MN2PR05MB71033C7D90D49D7ED8F36497D0C00@MN2PR05MB7103.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O6eCW4zueF54cKTnOXhStfuYx65ND6MBcxz79hnf3wOsMbApm1yt1bTGcwvx4nsCmFs8gCxiauSttG9xLlKquK8Rmgm5hl22qVB7SfMgxDeF/nJOzyJUso8EjJfRbpeOxrUtfJ+hwBnAyBblJ7FJJhwE1FuRqfEjTlBUXkk6iqQyCsgWCFXLP9Cun3CGSS2kXwlDR7d3VHDZ27SAL/CPTgKrocCS2yECnMOLJ18Trv33Shw/DtwgXIOsyOp9mfzKWgTaq4hO09odQ0slQ6ytipj4MdtnOSfZiKC/z85Wc3rPpjO2S3fSkI3oqt14/TjFrzdaqgZxIyVPtSKVJMA9vtudN+8rnobWcPChsIRoskh215lTaGs6KzzqE0jPLm7S8kSN65gA7D9neZnt1wGcG8JnnCGhFrVWA8ZO5/GSN/WBt2w64uvHakntu9BWm2IB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB4772.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(5660300002)(54906003)(33656002)(6486002)(64756008)(316002)(2906002)(66556008)(53546011)(186003)(8676002)(6506007)(66446008)(83380400001)(86362001)(8936002)(478600001)(6916009)(66946007)(71200400001)(4326008)(2616005)(66476007)(6512007)(76116006)(91956017)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?V0JJd0dRQlVKcytwZG1wL2hLUGRPK2thT0VDSnN1aStIeVMyWC9hWE44TEZr?=
 =?utf-8?B?cTNZQ3pKSkZUOWJSTUx1ejRGdW5DZHpFVGlHUldaa3JJQXl0T3VCQWl1SEhE?=
 =?utf-8?B?OVJXUllZSDc0VWIvWnF6Q0RDaWFqbVJFTEtKaDlqU2V3L3RKUFVxT0JJQXJL?=
 =?utf-8?B?cjF1cExpMlpBcU5lb3kvemRuWHQ0WHNjcVBNbHR0NytydHlSOVp6VmovSjVJ?=
 =?utf-8?B?T3Joem0wRXVEaG5XVWdwWVpmMzMvYlMrREhybG1yY253c0M3OTdMVXY2UGJT?=
 =?utf-8?B?THJzVU9RZ2I4N3FweGg2UFVwMS95cjdzc1l0WU9ZL3pHNURFeUY0VEt5akVE?=
 =?utf-8?B?ZmF3TG9oMEs2RUh5aXdXa1ZieTJGUGQ5bXJDcXFlRmgvU214ci9pQjU4SWFj?=
 =?utf-8?B?dmM0bnY3dW9qa3FXRFVYQXJmL0ZTQkREQStoWUlnR2Rtek02Y2pqdjhzdUF3?=
 =?utf-8?B?YXZSVCtSOHdpMlNPVzZkR1NlVjJ5K3dpQ1VrQ254c01BNDFKYUx1eW1Tb1c4?=
 =?utf-8?B?VzZTWnhpanUydmpPMmpXM2ZsZnZ5S1BqaXg3c1M3cTBSWnNuSVpaM2NRMkpx?=
 =?utf-8?B?Z1dVVTFpdmEzMFBzVGRzUmloWUZBTjJMekgvOTFIUXhBa3Ixem52YWg4SXpU?=
 =?utf-8?B?aHoxNXFFUXE4bS9nVVFiUEVwLzQ2WGVnTkpnTEZpQUUyaDZ3NC9iSExTWnh5?=
 =?utf-8?B?YzhtNlFRQTlWaXNwN0dhM25uZnFEczZqcC8rRkliY2RkYWo0NlhRcGs5SWZJ?=
 =?utf-8?B?cGk5eFhPVWZsbmFUWTJNbnYyQlhGeEdBSzN0OWdLL1lnTUJoSHI2REpudHcx?=
 =?utf-8?B?K0dkVGxtMTl3Y1hyY3pZZGtpQ1I2L2kvK3R1Z0UrMzhsMjRteGVTdHAwb0VJ?=
 =?utf-8?B?QWxLcWhtUDRSQU5qeURGWVhhR0xmUHp2blYyTDZObzVvYm5EN1ExSlhGb1Bq?=
 =?utf-8?B?cUZuV1lDa1NlcE41VmpPbXkzVnJFTjFFNmRVMmVtK3RPL1BBUDFlVloyR2to?=
 =?utf-8?B?Y1ZURHJHN2kvanArR0hnVFpJaUlKZE1kSTcvbVBDS0wzRDVURTBTTVZIZklE?=
 =?utf-8?B?dDE5cE42RWN4VFh6eXk1S3RFZXpVQXZlMDk3T0tpNGQzUXpyK3RzOXlFZWlT?=
 =?utf-8?B?czcwcDVsalpUYWRqWkdaM3RPQ0hPb2FIeVJXa3lGSU55UzlONzUzRy92c1Rl?=
 =?utf-8?B?MGZBV1lrd3ZMYUVudWNRaTVoRFQ1WlNHdm9qNVJWZmhUN2ZOUWppOEszVXlt?=
 =?utf-8?B?aUUyM0QvQjJlaHo4SWhqYzFFcGVSSmVOSXR4WWJHRWdKSU9VUVdqeDhDK0Jo?=
 =?utf-8?B?bmRmNGJsME54d2pFTmloK3MzaDQ0dlVidytTdFUyc3FDT2tObnNsTndCNWxG?=
 =?utf-8?B?Qyt3STNCUm1GTVVWR1c5bUt5RnMvOXVrN0pRZGlLWVRDNkZRWVhEczUrUlBJ?=
 =?utf-8?Q?n51K9IL/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC81CF6AC687784285C139098BCB4CEF@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB4772.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c337e12b-a7be-423b-df3a-08d8a5f2a4d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 20:54:43.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RdQ0Kiz8go7ITjNPCmciVViCUdOs7UZb1GkruJU+qCm4q3IWd6efPqIwlCAemtpV5ZqiJ/Rjq+diCdJy6k9GWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB7103
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

PiBPbiBEZWMgMjEsIDIwMjAsIGF0IDEyOjUyIFBNLCBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5j
b20+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBEZWMgMjEsIDIwMjAgYXQgMDc6NTE6NTJQTSArMDAw
MCwgTmFkYXYgQW1pdCB3cm90ZToNCj4+PiBPbiBEZWMgMjEsIDIwMjAsIGF0IDExOjI4IEFNLCBQ
ZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFNhdCwgTm92
IDI4LCAyMDIwIGF0IDA0OjQ1OjM4UE0gLTA4MDAsIE5hZGF2IEFtaXQgd3JvdGU6DQo+Pj4+IEZy
b206IE5hZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+DQo+Pj4+IA0KPj4+PiBXaGVuIHVzZXJm
YXVsdGZkIGNvcHktaW9jdGwgZmFpbHMgc2luY2UgdGhlIFBURSBhbHJlYWR5IGV4aXN0cywgYW4N
Cj4+Pj4gLUVFWElTVCBlcnJvciBpcyByZXR1cm5lZCBhbmQgdGhlIGZhdWx0aW5nIHRocmVhZCBp
cyBub3Qgd29rZW4uIFRoZQ0KPj4+PiBjdXJyZW50IHVzZXJmYXVsdGZkIHRlc3QgZG9lcyBub3Qg
d2FrZSB0aGUgZmF1bHRpbmcgdGhyZWFkIGluIHN1Y2ggY2FzZS4NCj4+Pj4gVGhlIGFzc3VtcHRp
b24gaXMgcHJlc3VtYWJseSB0aGF0IGFub3RoZXIgdGhyZWFkIHNldCB0aGUgUFRFIHRocm91Z2gN
Cj4+Pj4gY29weS93cCBpb2N0bCBhbmQgd291bGQgd2FrZSB0aGUgZmF1bHRpbmcgdGhyZWFkIG9y
IHRoYXQgYWx0ZXJuYXRpdmVseQ0KPj4+PiB0aGUgZmF1bHQgaGFuZGxlciB3b3VsZCByZWFsaXpl
IHRoZXJlIGlzIG5vIG5lZWQgdG8gIm11c3Rfd2FpdCIgYW5kDQo+Pj4+IGNvbnRpbnVlLiBUaGlz
IGlzIG5vdCBuZWNlc3NhcmlseSB0cnVlLg0KPj4+PiANCj4+Pj4gVGhlcmUgaXMgYW4gYXNzdW1w
dGlvbiB0aGF0IHRoZSAibXVzdF93YWl0IiB0ZXN0cyBpbiBoYW5kbGVfdXNlcmZhdWx0KCkNCj4+
Pj4gYXJlIHN1ZmZpY2llbnQgdG8gcHJvdmlkZSBkZWZpbml0aXZlIGFuc3dlciB3aGV0aGVyIHRo
ZSBvZmZlbmRpbmcgUFRFIGlzDQo+Pj4+IHBvcHVsYXRlZCBvciBub3QuIEhvd2V2ZXIsIHVzZXJm
YXVsdGZkX211c3Rfd2FpdCgpIHRlc3QgaXMgbG9ja2xlc3MuDQo+Pj4+IENvbnNlcXVlbnRseSwg
Y29uY3VycmVudCBjYWxscyB0byBwdGVwX21vZGlmeV9wcm90X3N0YXJ0KCksIGZvcg0KPj4+PiBp
bnN0YW5jZSwgY2FuIGNsZWFyIHRoZSBQVEUgYW5kIGNhbiBjYXVzZSB1c2VyZmF1bHRmZF9tdXN0
X3dhaXQoKQ0KPj4+PiB0byB3cm9uZ2x5IGFzc3VtZSBpdCBpcyBub3QgcG9wdWxhdGVkIGFuZCBh
IHdhaXQgaXMgbmVlZGVkLg0KPj4+IA0KPj4+IFllcyB1c2VyZmF1bHRmZF9tdXN0X3dhaXQoKSBp
cyBsb2NrbGVzcywgaG93ZXZlciBteSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgd2UnbGwNCj4+PiBl
bnF1ZXVlIGJlZm9yZSByZWFkaW5nIHRoZSBwYWdlIHRhYmxlLCB3aGljaCBzZWVtcyB0byBtZSB0
aGF0IHdlJ2xsIGFsd2F5cyBnZXQNCj4+PiBub3RpZmllZCBldmVuIHRoZSByYWNlIGhhcHBlbnMu
ICBTaG91bGQgYXBwbHkgdG8gZWl0aGVyIFVGRkRJT19XUklURVBST1RFQ1Qgb3INCj4+PiBVRkZE
SU9fQ09QWSwgaWl1YywgYXMgbG9uZyBhcyB3ZSBmb2xsb3cgdGhlIG9yZGVyIG9mICgxKSBtb2Rp
ZnkgcGd0YWJsZSAoMikNCj4+PiB3YWtlIHNsZWVwaW5nIHRocmVhZHMuICBUaGVuIGl0IGFsc28g
bWVhbnMgdGhhdCB3aGVuIG11c3Rfd2FpdCgpIHJldHVybmVkIHRydWUsDQo+Pj4gaXQgc2hvdWxk
IGFsd2F5cyBnZXQgd2FrZWQgdXAgd2hlbiBmYXVsdCByZXNvbHZlZC4NCj4+PiANCj4+PiBUYWtp
bmcgVUZGRElPX0NPUFkgYXMgZXhhbXBsZSwgZXZlbiBpZiBVRkZESU9fQ09QWSBoYXBwZW4gcmln
aHQgYmVmb3JlDQo+Pj4gbXVzdF93YWl0KCkgY2FsbHM6DQo+Pj4gDQo+Pj4gICAgICB3b3JrZXIg
dGhyZWFkICAgICAgICAgICAgICAgICAgICAgICB1ZmZkIHRocmVhZA0KPj4+ICAgICAgLS0tLS0t
LS0tLS0tLSAgICAgICAgICAgICAgICAgICAgICAgLS0tLS0tLS0tLS0NCj4+PiANCj4+PiAgaGFu
ZGxlX3VzZXJmYXVsdA0KPj4+ICAgc3Bpbl9sb2NrKGZhdWx0X3BlbmRpbmdfd3FoKQ0KPj4+ICAg
ZW5xdWV1ZSgpDQo+Pj4gICBzZXRfY3VycmVudF9zdGF0ZShJTlRFUlJVUFRJQkxFKQ0KPj4+ICAg
c3Bpbl91bmxvY2soZmF1bHRfcGVuZGluZ193cWgpDQo+Pj4gICBtdXN0X3dhaXQoKQ0KPj4+ICAg
ICBsb2NrbGVzcyB3YWxrIHBhZ2UgdGFibGUNCj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFVGRkRJT19DT1BZDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGZpbGwgaW4gdGhlIGhvbGUNCj4+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgd2FrZSB1cCB0aHJlYWRzDQo+Pj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKHRoaXMgd2lsbCB3YWtlIHVwIHdv
cmtlciB0aHJlYWQgdG9vPykNCj4+PiAgIHNjaGVkdWxlKCkNCj4+PiAgICAgKHdoaWNoIG1heSBy
ZXR1cm4gaW1tZWRpYXRlbHk/KQ0KPj4+IA0KPj4+IFdoaWxlIGhlcmUgZmF1bHRfcGVuZGluZ193
cWggaXMgbG9jayBwcm90ZWN0ZWQuIEkganVzdCBmZWVsIGxpa2UgdGhlcmUncyBzb21lDQo+Pj4g
b3RoZXIgcmVhc29uIHRvIGNhdXNlIHRoZSB0aHJlYWQgdG8gc3RhbGwuICBPciBkaWQgSSBtaXNz
IHNvbWV0aGluZz8NCj4+IA0KPj4gQnV0IHdoYXQgaGFwcGVucyBpZiB0aGUgY29weSBjb21wbGV0
ZWQgYmVmb3JlIHRoZSBlbnF1ZXVpbmc/IEFzc3VtZQ0KPj4gdGhlIHBhZ2UgaXMgd3JpdGUtcHJv
dGVjdGVkIGR1cmluZyBVRkZESU9fQ09QWToNCj4+IA0KPj4gDQo+PiBjcHUwCQkJCQljcHUxCQkN
Cj4+IC0tLS0JCQkJCS0tLS0JCQkNCj4+IGhhbmRsZV91c2VyZmF1bHQNCj4+IAkJCQkJVUZGRElP
X0NPUFkNCj4+IAkJCQkJWyB3cml0ZS1wcm90ZWN0ZWQgXQ0KPj4gCQkJCSAJIGZpbGwgaW4gdGhl
IGhvbGUNCj4+IAkJCQkgCSB3YWtlIHVwIHRocmVhZHMNCj4+IAkJCQkgCSBbbm90aGluZyB0byB3
YWtlXQ0KPj4gCQkJCQkJCQ0KPj4gCQkJCQlVRkZEX1dQICh1bnByb3RlY3QpDQo+PiAJCQkJCSBs
b2dpY2FsbHkgbWFya3MgYXMgdW5wcm90ZWN0ZWQNCj4+IAkJCQkJIFtub3RoaW5nIHRvIHdha2Vd
DQo+PiANCj4+IHNwaW5fbG9jayhmYXVsdF9wZW5kaW5nX3dxaCkNCj4+ICBlbnF1ZXVlKCkNCj4+
ICBzZXRfY3VycmVudF9zdGF0ZShJTlRFUlJVUFRJQkxFKQ0KPj4gIHNwaW5fdW5sb2NrKGZhdWx0
X3BlbmRpbmdfd3FoKQ0KPj4gIG11c3Rfd2FpdCgpDQo+PiANCj4+IAkJCQkJWyAjUEYgb24gdGhl
IHNhbWUgUFRFDQo+PiAJCQkJCSBkdWUgdG8gd3JpdGUtcHJvdGVjdGlvbiBdDQo+PiANCj4+IAkJ
CQkJLi4uDQo+PiAJCQkJCSB3cF9wYWdlX2NvcHkoKQ0KPj4gCQkJCQkgIHB0ZXBfY2xlYXJfZmx1
c2hfbm90aWZ5KCkNCj4+IAkJCQkJICBbIFBURSBpcyBjbGVhciBdDQo+PiAJCQkJCQ0KPj4gICBs
b2NrbGVzcyB3YWxrIHBhZ2UgdGFibGUNCj4+ICAgIHB0ZV9ub25lKCpwdGUpIC0+IG11c3Qgd2Fp
dA0KPj4gDQo+PiBOb3RlIHRoYXQgYWRkaXRpb25hbCBzY2VuYXJpb3MgYXJlIHBvc3NpYmxlLiBG
b3IgaW5zdGFuY2UsIGluc3RlYWQgb2YNCj4+IHdwX3BhZ2VfY29weSgpLCB3ZSBjYW4gaGF2ZSBv
dGhlciBjaGFuZ2VfcHRlX3JhbmdlKCkgKGR1ZSB0byB3b3JrZXLigJlzDQo+PiBtcHJvdGVjdCgp
IG9yIE5VTUEgYmFsYW5jaW5nKSwgY2FsbGluZyBwdGVwX21vZGlmeV9wcm90X3N0YXJ0KCkgYW5k
IGNsZWFyaW5nDQo+PiB0aGUgUFRFLg0KPj4gDQo+PiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0K
PiANCj4gQWggSSBzZWUgeW91ciBwb2ludCwgdGhhbmtzLiAgSSB0aGluayB5b3UncmUgcmlnaHQ6
DQo+IA0KPiBSZXZpZXdlZC1ieTogUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0KPiANCj4g
V291bGQgeW91IG1pbmQgYWRkaW5nIHNvbWV0aGluZyBsaWtlIGFib3ZlIGludG8gdGhlIGNvbW1p
dCBtZXNzYWdlIGlmIHlvdSdyZQ0KPiBnb2luZyB0byByZXBvc3Q/ICBJTUhPIGl0IHdvdWxkIGV2
ZW4gYmUgbmljZXIgdG8gbWVudGlvbiB3aHkNCj4gVUZGRElPX1dSSVRFUFJPVEVDVCBkb2VzIG5v
dCBuZWVkIHRoaXMgZXh0cmEgd2FrZXVwIChJIHRoaW5rIGl0J3MgYmVjYXVzZSBpdCdsbA0KPiBk
byB0aGUgd2FrZXVwIHVuY29uZGl0aW9uYWxseSBhbnl3YXkpLg0KDQpZZXMsIHRoZSBjb21taXQg
bG9nIG5lZWRzIHRvIGJlIGZpeGVkLg0KDQpJIHdpbGwgdXBkYXRlIGl0IGJhc2VkIG9uIHlvdXIg
ZmVlZGJhY2sgb24gUkZDLXYyLg0KDQpUaGFua3MsDQpOYWRhdg==
