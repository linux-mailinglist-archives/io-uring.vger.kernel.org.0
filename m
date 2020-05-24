Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE09A1DFF47
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 16:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgEXOFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 10:05:37 -0400
Received: from mail-bn8nam12on2101.outbound.protection.outlook.com ([40.107.237.101]:42304
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728875AbgEXOFg (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 24 May 2020 10:05:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofrm+h3lYEE9tpgs960lOvLpNMKJPI7uf3XSnyXgXbeC5Bh/evuQ5kbABjtpGL3LIWYtc95IgxE2nAWKZ5+/kNjFTzF6sBNMYqXkHhNzAWiEtazdk9yXkI5JkLqJu9IWn6XpdWzKpg3bIei2Vfe8yeJnWPv5+iZlvdl8GS11x5idyJaBwsyFxcXqHaLEmGjvDBniwkkDGFLwnzWeuARux+7wbAFcUwcxHgdOpuSUG87cHM3SDlv4GPjlhtSgjSfHba+DZ865mqvia3aEwhoRHyDW0ZKM35MqrjtqZd84RhkuLs1Bor9UYdD3A73cRzO4G8IAVJ+gC7U0is+8MnQlmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDdupJoyjbIOg8U4UFqvWafTJwAWxJcGp/fD51v9YDc=;
 b=Uk/akTgwf2Aa9jPZxBcg60/oI8n8yqydXydAnk2OeVvFTP0UuNPHrQRZmZKkvFOwuhN+Qt02WbJnXjWErXfotDxHjoU86yIEni7EuUT4qN1a8kqo0BuMupQACeKGKJdg0fZF8h9Mju8hiOQXGP+zrn6pygG+p09h89RMg5QPlc6nNNMyO39/N1dEgBusQZ4wH02fa4FhUaE10kwtQAyVVl+ZKYxSR6UEyX1zzszCX6RFZTJCt4TQBvlvs/AP7aDj/46PSBXy9eWqi+tu4UCUi+AchrQqiLRg9xEp1gGNm8mjRLNKHKVRTJHUIaiaNs4paylhg5Xm4d78Y5yDatVlbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDdupJoyjbIOg8U4UFqvWafTJwAWxJcGp/fD51v9YDc=;
 b=A9mRWvAF3MBLCYmGsFS3QWBaJq+scCc3r5LXMaHUKJh5RgAB7EzJ9ljFZ17h2QM6KRtw/qTXIst+Mqewma2bulxvHc+GLuXYGj13TG9u9R8pKz+7wvuFBWJ0RkCGCfLmqe8hjNXQLf0sR8uH07Ua/EIw7yL9RrotejAsf26r/qA=
Received: from CH2PR13MB3398.namprd13.prod.outlook.com (2603:10b6:610:2a::33)
 by CH2PR13MB3448.namprd13.prod.outlook.com (2603:10b6:610:28::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.9; Sun, 24 May
 2020 14:05:32 +0000
Received: from CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493]) by CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493%6]) with mapi id 15.20.3045.009; Sun, 24 May 2020
 14:05:31 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/12] mm: support async buffered reads in
 generic_file_buffered_read()
Thread-Topic: [PATCH 05/12] mm: support async buffered reads in
 generic_file_buffered_read()
Thread-Index: AQHWMTQyNgEk/N+TVkeE2BGKfkqi2qi3RlkA
Date:   Sun, 24 May 2020 14:05:31 +0000
Message-ID: <264614fc4fa08df2b0899da1cd38bb07150cd7f3.camel@hammerspace.com>
References: <20200523185755.8494-1-axboe@kernel.dk>
         <20200523185755.8494-6-axboe@kernel.dk>
In-Reply-To: <20200523185755.8494-6-axboe@kernel.dk>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 224fc63b-e9ed-4619-6acf-08d7ffeb858e
x-ms-traffictypediagnostic: CH2PR13MB3448:
x-microsoft-antispam-prvs: <CH2PR13MB3448297762706A8FAD0C9512B8B20@CH2PR13MB3448.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0413C9F1ED
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MnAx/qT9JUCNF8HxvqOWDhZXoIPsVQffF7OCxD5SFRne1WlH/Y1p7KjIk0/+KsKZLycIg/potbNMoe42E4eo/WcTBETbRjk5NFa1gJ8rglj0PSkqe+XlIqDJpt6qm/4wYUl2WeVP4CQh3hYsIAxP5ZjFKjLdTwWawS1BSVL6jNN63SYd9JtJ6Wxv2+dMS2lKi337DBLLje5wmErREX7TRKQ4ODHyh0Ha73LYSs6tktHrrRzQVWQE7DRmN6GcYftxoXWEPDN9f6GRW5FlX7BlidGRzrbC29poCdOwswMYztkGkP1aB/Rs3Ycr6GlyWoJgq89ogftOa8HqV/SFOi0Nkia7OWXD+8e/usN7yUCJoIfGHWz8TkA3EE4ZF3E00Q3B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3398.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39830400003)(396003)(376002)(136003)(366004)(6486002)(110136005)(36756003)(478600001)(26005)(2616005)(54906003)(66556008)(8936002)(2906002)(66476007)(5660300002)(86362001)(64756008)(66446008)(71200400001)(186003)(66946007)(6506007)(4326008)(8676002)(6512007)(76116006)(316002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JlDrNoCp3zhjun7JmKnhtn6LICBQMiQlpw0G6bSzFPiit1gEkF01UJtBuoOExsu+yj/OMgxyutz8NnFpzE9zhwlk/ACpmibaxdWdwFNj9aydfieO1fqReCgUgxViC+F7bZ4pHv+m70gOj3X0Djazc3UUySDNLPtJ8QY40as4hP6Spca2fnYlHfCLmCVX8vMXG5qCe5o/Dh7ZzaS0ajCgZBhZldtGiCxarYmqxfqeF5sfHS01clnH/+rcOqnimiLzES6A17iqwklPOZ86NyrPO0V/5k0l06pFzR7NgPPs7dFG013kWcAwiXhdD+tRloIosPNJBn+RyF6xBGyHu2DshRx02okE2jfpYsc4e2Vhud7PIfRB4iEzQpnoO0Zh+dTASf8Q+c/A4iJt0ptLUaFw8e9n1XVmrjPNMCr89NLYx618lZp2/i8DICbfKAjmShxMNa3sV4zGyvHHeqlezhMkF7YS98BMS5yR+Jm2/ijib44=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <85C147503CB437449457176356FB74F5@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 224fc63b-e9ed-4619-6acf-08d7ffeb858e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2020 14:05:31.7586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+eSaCiPA9CNVMETEq7h7y5ruLM30C4l8tlfzWHAezGaYYje+FfLgiPR6sfkz3RwQnV6TC1s8R6rTCNUU40P3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3448
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gU2F0LCAyMDIwLTA1LTIzIGF0IDEyOjU3IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBV
c2UgdGhlIGFzeW5jIHBhZ2UgbG9ja2luZyBpbmZyYXN0cnVjdHVyZSwgaWYgSU9DQl9XQUlUUSBp
cyBzZXQgaW4NCj4gdGhlDQo+IHBhc3NlZCBpbiBpb2NiLiBUaGUgY2FsbGVyIG11c3QgZXhwZWN0
IGFuIC1FSU9DQlFVRVVFRCByZXR1cm4gdmFsdWUsDQo+IHdoaWNoIG1lYW5zIHRoYXQgSU8gaXMg
c3RhcnRlZCBidXQgbm90IGRvbmUgeWV0LiBUaGlzIGlzIHNpbWlsYXIgdG8NCj4gaG93DQo+IE9f
RElSRUNUIHNpZ25hbHMgdGhlIHNhbWUgb3BlcmF0aW9uLiBPbmNlIHRoZSBjYWxsYmFjayBpcyBy
ZWNlaXZlZCBieQ0KPiB0aGUgY2FsbGVyIGZvciBJTyBjb21wbGV0aW9uLCB0aGUgY2FsbGVyIG11
c3QgcmV0cnkgdGhlIG9wZXJhdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2Ug
PGF4Ym9lQGtlcm5lbC5kaz4NCj4gLS0tDQo+ICBtbS9maWxlbWFwLmMgfCAzMyArKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNiBpbnNlcnRpb25z
KCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21t
L2ZpbGVtYXAuYw0KPiBpbmRleCBjNzQ2NTQxYjFkNDkuLmEzYjg2YzlhY2RjOCAxMDA2NDQNCj4g
LS0tIGEvbW0vZmlsZW1hcC5jDQo+ICsrKyBiL21tL2ZpbGVtYXAuYw0KPiBAQCAtMTIxOSw2ICsx
MjE5LDE0IEBAIHN0YXRpYyBpbnQgX193YWl0X29uX3BhZ2VfbG9ja2VkX2FzeW5jKHN0cnVjdA0K
PiBwYWdlICpwYWdlLA0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQg
d2FpdF9vbl9wYWdlX2xvY2tlZF9hc3luYyhzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gKwkJCQkgICAg
IHN0cnVjdCB3YWl0X3BhZ2VfcXVldWUgKndhaXQpDQo+ICt7DQo+ICsJaWYgKCFQYWdlTG9ja2Vk
KHBhZ2UpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKwlyZXR1cm4gX193YWl0X29uX3BhZ2VfbG9ja2Vk
X2FzeW5jKGNvbXBvdW5kX2hlYWQocGFnZSksIHdhaXQsDQo+IGZhbHNlKTsNCj4gK30NCj4gKw0K
PiAgLyoqDQo+ICAgKiBwdXRfYW5kX3dhaXRfb25fcGFnZV9sb2NrZWQgLSBEcm9wIGEgcmVmZXJl
bmNlIGFuZCB3YWl0IGZvciBpdCB0bw0KPiBiZSB1bmxvY2tlZA0KPiAgICogQHBhZ2U6IFRoZSBw
YWdlIHRvIHdhaXQgZm9yLg0KPiBAQCAtMjA1OCwxNyArMjA2NiwyNSBAQCBzdGF0aWMgc3NpemVf
dA0KPiBnZW5lcmljX2ZpbGVfYnVmZmVyZWRfcmVhZChzdHJ1Y3Qga2lvY2IgKmlvY2IsDQo+ICAJ
CQkJCWluZGV4LCBsYXN0X2luZGV4IC0gaW5kZXgpOw0KPiAgCQl9DQo+ICAJCWlmICghUGFnZVVw
dG9kYXRlKHBhZ2UpKSB7DQo+IC0JCQlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX05PV0FJVCkg
ew0KPiAtCQkJCXB1dF9wYWdlKHBhZ2UpOw0KPiAtCQkJCWdvdG8gd291bGRfYmxvY2s7DQo+IC0J
CQl9DQo+IC0NCj4gIAkJCS8qDQo+ICAJCQkgKiBTZWUgY29tbWVudCBpbiBkb19yZWFkX2NhY2hl
X3BhZ2Ugb24gd2h5DQo+ICAJCQkgKiB3YWl0X29uX3BhZ2VfbG9ja2VkIGlzIHVzZWQgdG8gYXZv
aWQNCj4gdW5uZWNlc3NhcmlseQ0KPiAgCQkJICogc2VyaWFsaXNhdGlvbnMgYW5kIHdoeSBpdCdz
IHNhZmUuDQo+ICAJCQkgKi8NCj4gLQkJCWVycm9yID0gd2FpdF9vbl9wYWdlX2xvY2tlZF9raWxs
YWJsZShwYWdlKTsNCj4gKwkJCWlmIChpb2NiLT5raV9mbGFncyAmIElPQ0JfV0FJVFEpIHsNCj4g
KwkJCQlpZiAod3JpdHRlbikgew0KPiArCQkJCQlwdXRfcGFnZShwYWdlKTsNCj4gKwkJCQkJZ290
byBvdXQ7DQo+ICsJCQkJfQ0KPiArCQkJCWVycm9yID0gd2FpdF9vbl9wYWdlX2xvY2tlZF9hc3lu
YyhwYWdlLA0KPiArCQkJCQkJCQlpb2NiLQ0KPiA+cHJpdmF0ZSk7DQoNCklmIGl0IGlzIGJlaW5n
IHVzZWQgaW4gJ2dlbmVyaWNfZmlsZV9idWZmZXJlZF9yZWFkKCknIGFzIHN0b3JhZ2UgZm9yIGEN
CndhaXQgcXVldWUsIHRoZW4gaXQgaXMgaGFyZCB0byBjb25zaWRlciB0aGlzIGEgJ3ByaXZhdGUn
IGZpZWxkLg0KDQpQZXJoYXBzIGVpdGhlciByZW5hbWUgYW5kIGFkZCB0eXBlIGNoZWNraW5nLCBv
ciBlbHNlIGFkZCBhIHNlcGFyYXRlDQpmaWVsZCBhbHRvZ2V0aGVyIHRvIHN0cnVjdCBraW9jYj8N
Cg0KPiArCQkJfSBlbHNlIHsNCj4gKwkJCQlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX05PV0FJ
VCkgew0KPiArCQkJCQlwdXRfcGFnZShwYWdlKTsNCj4gKwkJCQkJZ290byB3b3VsZF9ibG9jazsN
Cj4gKwkJCQl9DQo+ICsJCQkJZXJyb3IgPQ0KPiB3YWl0X29uX3BhZ2VfbG9ja2VkX2tpbGxhYmxl
KHBhZ2UpOw0KPiArCQkJfQ0KPiAgCQkJaWYgKHVubGlrZWx5KGVycm9yKSkNCj4gIAkJCQlnb3Rv
IHJlYWRwYWdlX2Vycm9yOw0KPiAgCQkJaWYgKFBhZ2VVcHRvZGF0ZShwYWdlKSkNCj4gQEAgLTIx
NTYsNyArMjE3MiwxMCBAQCBzdGF0aWMgc3NpemVfdA0KPiBnZW5lcmljX2ZpbGVfYnVmZmVyZWRf
cmVhZChzdHJ1Y3Qga2lvY2IgKmlvY2IsDQo+ICANCj4gIHBhZ2Vfbm90X3VwX3RvX2RhdGU6DQo+
ICAJCS8qIEdldCBleGNsdXNpdmUgYWNjZXNzIHRvIHRoZSBwYWdlIC4uLiAqLw0KPiAtCQllcnJv
ciA9IGxvY2tfcGFnZV9raWxsYWJsZShwYWdlKTsNCj4gKwkJaWYgKGlvY2ItPmtpX2ZsYWdzICYg
SU9DQl9XQUlUUSkNCj4gKwkJCWVycm9yID0gbG9ja19wYWdlX2FzeW5jKHBhZ2UsIGlvY2ItPnBy
aXZhdGUpOw0KPiArCQllbHNlDQo+ICsJCQllcnJvciA9IGxvY2tfcGFnZV9raWxsYWJsZShwYWdl
KTsNCj4gIAkJaWYgKHVubGlrZWx5KGVycm9yKSkNCj4gIAkJCWdvdG8gcmVhZHBhZ2VfZXJyb3I7
DQo+ICANCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIs
IEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
