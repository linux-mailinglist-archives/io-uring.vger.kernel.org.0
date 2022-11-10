Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F728623EDB
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKJJnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 04:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKJJny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 04:43:54 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3F81A04E
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 01:43:53 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9MIcZU010641
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 01:43:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=vz9Xm1mMW3H+z6zekiUYFJAIS1vJZyP0r8Zd/tUhw9w=;
 b=L5mi9DeS7Ke7NnTbvNRjvu2+JIOlppCVgJ5c2cjgw8Tue0fBNhBKpmpEok0Dknm1RRkH
 gIFlGRLIAIIwqXCEeJPwSm4D9WrWRTKcLvi04KQLHDLkmJS9wNDqwisRbNmDTUcYwr81
 vPV9ldq9b3whc0atjANGFDXZULCgaJczp6r7WiuObQC5irqJXN5Grd9+MhIq0c21o8E8
 8z1U5mVdQWIBlO0Z2AiNvwz3Wpdto31LX3/Xo5UkqGNfMOw0pugOQ/vH0dsnRQa1qj3a
 fQwCsCRaXcHUWGW2sqJCUqJpYsRMCPoGqeZSZF+zNyZz08timyMA9cmXDGb14KYVHSIn xA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3krm5q3x88-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 01:43:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYCrzXYMmnJ7FsTd1imlaGGsWGbF0jA8B8dv2lju0H3wjclpl2hj1W3MPzE97U6Kcm8AzDmbtsMouacEmStYz65XxieMha3C8Z9vZB8Sd9lghfd9yKsfyt2wz2AHfOh3LmTUBLCBUUoToGWyiSJX2yosvXLrxkOEQGiJLtGENIbBis4ApYypXH4mYVtQzMOvyUfQCYUymQf0mlDdsj8pvLPm25Bi3EUtJ9kayIi3H+2BP2phelv1/WaTjLiLlTHBPr6Gz5O/6hlMoucM1Kzd+PtWCGZEJN/ZX0pmoe5lYZiEQ/fwgrpeTBGZhrrdOyEukerKyO9UaoFaCYX/6TXvHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vz9Xm1mMW3H+z6zekiUYFJAIS1vJZyP0r8Zd/tUhw9w=;
 b=R39zdAQH7X8OnMojLdP52hsbuWmwq5+QRtG2dee3rC37VA9uNLk+qcBuwwtSS400T49OsOHi65ftWlB51BQQXAhxnjBrDYe/1kQR8I2PrzVcmEpKOVCkfjhYnkW7mtpDpfWxeabX0eV5/dINoaLynFB6yyXnh96cVoZSPnpRYVYu11uLsdKLahC7PBPkqhVGc27KnEhvA/D7rwaSJs7+Q02EuSFXoZ+PF442dvRJm8gZ6+3f7oDts/aAcAum9rUTyJoJXWqnchGOep0F1hUyTtMT6gPzHBdKDHeMUcFsdvEf580xs7JejUhK7IRDvo8lsFrZl3KsAqN17h3LNhiPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BYAPR15MB3462.namprd15.prod.outlook.com (2603:10b6:a03:112::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Thu, 10 Nov
 2022 09:43:48 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 09:43:48 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@meta.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "dominik@thalhammer.it" <dominik@thalhammer.it>,
        "rjones@redhat.com" <rjones@redhat.com>
Subject: Re: liburing 2.3 API/ABI breakage
Thread-Topic: liburing 2.3 API/ABI breakage
Thread-Index: AQHY9IK6dpY3qAMsNUSPoVdq00qp4K43ZuGAgACB9YA=
Date:   Thu, 10 Nov 2022 09:43:48 +0000
Message-ID: <baf1f51132d42319a6a845ba391b21731ef80d6a.camel@fb.com>
References: <Y2xaz5HwrGcbKJK8@fedora>
In-Reply-To: <Y2xaz5HwrGcbKJK8@fedora>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|BYAPR15MB3462:EE_
x-ms-office365-filtering-correlation-id: 34b0f7be-4b39-4307-9396-08dac3001169
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Sk6B4vmpEYOsAk/9WAZYQXbJzf9PMhpB7lTMZt+wbdI6oP6cLMMgt2rM6LKaV34qwmfBlkZ3h/p98uWXdujAAMerapE8LXTCiCa9h2/7XF0MRf5CbA8aQKyQpItkjPAzLyKj/paJCpNQg6gfbsTQ94uIEirE1R0rjZn4bJPfQPl5RgeAXwRoMPxf7bg8MuARFADvCUTAbs5sLun2gcvou+2VDx2sqd24oN1m7Hbb/0c+d6DNp5DlYtarbE7IhHChpfHcA2mMgUAK5XCgGPVfgc0v57VtvXU6/Z9eLHQivid7Iz2MYuv4AqTBN3WAPVgZTRI7rscgFTSihNw1eSjzsC5t447EApDEaxmarwPdPt1cG3q0K6LVCYnIgg8svptRI2z7uW2zc50aRdZxyXGFfp48mpWvOIewoSpv0gSVdZa+cDnZGl8Z178MmwNRIOV5CMwSKLaYLGS9w1gHrIxrYr6OQSTOMv68LaYa9AiB0ewucVvDJ8qlIVIKARlbID0GyyQMh0fe2ntrCr73b/kOaxIktU7ylprKArECyeb0bj5r8b71Z8B3auBqEY54yEG6q7aVtHKsDS7DNZFpFtsLhJbozs4xRui/SnM1HaTCsQjSpvJItZyhOFW9gVrSVIcDin2MSJj4V6+x3VheqQllPd0RpU+L/vyC/rVTmoHufq9qA0v5NSPK7edIbxUgJtC/3gut+Q4YWR/y5dA4ayRbMtFbtQ9YF5FqoRfL59HpO4AqWwdW/jn7976BZaXIPqzh86oq+e1w0oWyaqB4uK59w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(38070700005)(9686003)(41300700001)(8936002)(5660300002)(66556008)(8676002)(4326008)(64756008)(86362001)(54906003)(316002)(6486002)(110136005)(66476007)(76116006)(66446008)(2906002)(91956017)(36756003)(71200400001)(66946007)(478600001)(6512007)(186003)(38100700002)(83380400001)(6506007)(26005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGd0a1lOMCsvU1ZVbXVMZGRSNUhWT05aWk1CeHpnL1pUSmY3bTJMMTR4bndw?=
 =?utf-8?B?bDU0YWZmbm1ob0RIYU5LdEM5ZFJubHhBbi9vQWgxRWF3L3l4VlpmTEYycGF0?=
 =?utf-8?B?QVd4SDFCTE9QaXkzcnkvQmQ5blZwdXhLdlJ3SDhFZDBtRTJ0TTduOThGSjZ1?=
 =?utf-8?B?dFRCTlVhUnhGMGZoWmJld2FUUTRxaFcyVHZab3IvY0xSTUkwTTZvNUE3eDBE?=
 =?utf-8?B?ay9KSzdkTUtaUWVaeTNCSFpiMzJJWUg2UURLQXVhQWZVQkRVSjkrRVhQSTNu?=
 =?utf-8?B?bzR4cWM4amQ2ME1KVWptOFgvWDNEbElBZlVvQUlEbjZyNWg0endRWkptOGNy?=
 =?utf-8?B?emMyR21GVlB2WlUydTJGT2EyRmR3L0RjL1NjL3FGNnp0d1ZEWHY0SGFqYjl1?=
 =?utf-8?B?R3ZMNis1RUF4T2l6YkhhdWppUTVSUmpaWHdyVDNpWUVtNU1Vc2RRY1llK1Fs?=
 =?utf-8?B?SkJZVkJoNTRLazRYZlhUMVVhWldXQlpQUDNLdklrNkVVL0YyQkpPTUFtdzRD?=
 =?utf-8?B?UVNzWmZ3bzlPdkI5R0kxamx2b0tEWE44TWdSN0ZKc0JWbkFxZ0ZnbE1kc2Mw?=
 =?utf-8?B?SW1YU2lWN2tWcmZxcWExMGJ2NDhFZklIUVdRTnRTRlF6ZHNjTEkyaXNEVmdk?=
 =?utf-8?B?THBNd2hZazlNYUwvSE5xMGtaeDFJdE5vVVlXam1KTkQydjFUc0tYd1lmS2sz?=
 =?utf-8?B?QWx1MHR2enBlYXR4MjhmSmdlaElmdUtIQmZ5K1NDRkV4YitNTkNNbGJYMXVB?=
 =?utf-8?B?OFBUMHBxUUdjY2oycEU1SllOK3crNWlyeTZVMk93Q3laYmYvclpSOFlYUWIw?=
 =?utf-8?B?NjFoVkdWMUlMazNMMmpPWFpHODdGZXRMb0hIekc1UzNjbUo5OGRrMEo3Zkoy?=
 =?utf-8?B?SmRyRngrNDNGcmwreGI3RDRzQXB0eXBpOHg3SHJqQU53a0VxVWhOUG1rKzdP?=
 =?utf-8?B?cnRxY1JBeURuallEQ2VYRDVrTi9VTDZlOGY3Q0h5SUZLVFdvVFAvRlVmZWFQ?=
 =?utf-8?B?azF3MGVpd1lIWkEwRkxKeGtUeEpwNjZvTXpjeTZXTkhPOTRtRjM3VEVMTVRD?=
 =?utf-8?B?UVZhcHN0cmdDdUpsNUJlUVpwek15UjVnN05FMFpyckZONng0d2ROQmhIVHBP?=
 =?utf-8?B?UElvY3VYQTExUWxrTEw4b29WMkxnNll1cXRlZ2VReW1mN1FPNnoyblBuMkRy?=
 =?utf-8?B?WEltdjhzZUNUNDFJYVl3RXdXakJseVZqdEJyeklNTlVJd2poM3FKMGd5dTNw?=
 =?utf-8?B?K2JocFlndFUxMWpaV1JJL2YzN2FFODdvb0R5UjI4SEt1blpmQnJCRGNZaTJX?=
 =?utf-8?B?UUFJRCtWWm5HOXo1UTkzVjNyOFZFUjFxRklJMnRLbUpNRlZFcTRYZHlBUGl5?=
 =?utf-8?B?T1p4b3hmYUc1Z0g5UFU3Z0tyVFVlSElqVEVzd0RzV1ZpVFBwd1JSNm5xbmY4?=
 =?utf-8?B?OTZrN0hqUkhPTEFyRyt1U2ZFZit5WGZoRGltZGNKS0tkWjlUdU93RHE0QW5l?=
 =?utf-8?B?bGsrTEhmWlI3ZExVODdrS1hDcFplYUtGZy9oTGJ0a3h0bXoxTzBlNGFKSmpI?=
 =?utf-8?B?cUMrN0JxRDhxOU9hS1YvT1VkZ2VGeTFxOXo0cjlNV250YXgwK1dRcG5CaWFj?=
 =?utf-8?B?VXh2c2ZYSDVoSEF5WFltMlFHUG9zQ3g1NldCRFdVTkNYWEtrWVRYSWMybXR1?=
 =?utf-8?B?RDRhRkVHNTRKeUVEWm12RzRzODcyUS9rQkwyOGxMc2dJT3k0RmRyNXJlSm9i?=
 =?utf-8?B?MmxGQkpCek9QUzBpcHZmSzRPTXhqT1hkQkJ0c05UQis3U1RXUjE5OS9kbFZh?=
 =?utf-8?B?QlVUd1BpRGh5U0NYVjNnMHVKL1hOY3lqS2VocXFsKzYxR0kyWmw5cGhIOTkr?=
 =?utf-8?B?djdseG1oV2FrcFFmL3JRdDFvWHhqTFJwUTE0a1B5TW1mbTRRcHJxTDdDR015?=
 =?utf-8?B?eTA1U1gyRWx4NEVxdklTNEhuNGlGWk1WZ0VsSzR4cVVYVVl6eUpkV0lqT01a?=
 =?utf-8?B?MkY0R2tKako3bnFLam5BOFY0YWM0bENQT0xRdVJkK0ZDRllwdG43NVdibk1X?=
 =?utf-8?B?ZHU4ZXV0REZJSjRFNjhCK2o5US9xVkVDUG9aZjJiUHNYakpyUHZySlV0YXFW?=
 =?utf-8?Q?vZXj8G5nWK5HZFXMNofZYbryw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <023BE6CDEFF4A742A8AFAC13C0117FDA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b0f7be-4b39-4307-9396-08dac3001169
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 09:43:48.5582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t/nAg0ErlV/gxzmULea/ODGP6qbAER/INaak6iLRDKcvT5snIRP25UiLQsbnKHK3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3462
X-Proofpoint-GUID: aCNvmICKKLeXQaJZ4ZiZJR19RaISUkR-
X-Proofpoint-ORIG-GUID: aCNvmICKKLeXQaJZ4ZiZJR19RaISUkR-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_07,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTA5IGF0IDIwOjU4IC0wNTAwLCBTdGVmYW4gSGFqbm9jemkgd3JvdGU6
DQo+ID4gMi4gR29pbmcgZnJvbSBzaXplX3QgdG8gdW5zaWduZWQgaW50IGlzIEFCSSBicmVha2Fn
ZS4gVGhpcyBpcw0KPiA+IG1pdGlnYXRlZA0KPiA+IMKgwqAgb24gQ1BVIGFyY2hpdGVjdHVyZXMg
dGhhdCBzaGFyZSAzMi1iaXQvNjQtYml0IHJlZ2lzdGVycyAoaS5lLg0KPiA+IHJheC9lYXgNCj4g
PiDCoMKgIG9uIHg4Ni02NCBhbmQgcjAveDAvdzAgb24gYWFyY2g2NCkuIFRoZXJlJ3Mgbm8gZ3Vh
cmFudGVlIHRoaXMNCj4gPiB3b3Jrcw0KPiA+IMKgwqAgb24gYWxsIGFyY2hpdGVjdHVyZXMsIGVz
cGVjaWFsbHkgd2hlbiB0aGUgY2FsbGluZyBjb252ZW50aW9uDQo+ID4gcGFzc2VzDQo+ID4gwqDC
oCBhcmd1bWVudHMgb24gdGhlIHN0YWNrLg0KPiANCj4gR29vZCBuZXdzLCBJIHJlYWxpemVkIHRo
YXQgaW9fdXJpbmdfcHJlcF9nZXR4YXR0cigpIGFuZCBmcmllbmRzIGFyZQ0KPiBzdGF0aWMgaW5s
aW5lIGZ1bmN0aW9ucy4gQUJJIGJyZWFrYWdlIGRvZXNuJ3QgY29tZSBpbnRvIHBsYXkgYmVjYXVz
ZQ0KPiB0aGV5IGFyZSBjb21waWxlZCBpbnRvIHRoZSBhcHBsaWNhdGlvbi4NCg0KQWRkaXRpb25h
bGx5IHRoZSBpbmxpbmUgY29kZSB3YXMgZG9pbmcgdGhlIG5hcnJvd2luZyBjYXN0IGFueXdheSwg
c28NCnRoZXJlIHdhcyBubyBuYXJyb3dpbmcgaXNzdWVzLg0KDQpJIHJlYWxseSBzaG91bGQgaGF2
ZSBwdXQgdGhpcyBleHBsYW5hdGlvbiBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgdGhvdWdoDQotIHdp
bGwgcmVtZW1iZXIgZm9yIG5leHQgdGltZS4NCg0KPiANCj4gVGhlIGNvbnN0IGNoYXIgKiB0byBj
aGFyICogQVBJIGJyZWFrYWdlIGlzc3VlIHN0aWxsIHJlbWFpbnMgYnV0DQo+IHRoZXJlJ3MNCj4g
YSBwcmV0dHkgZ29vZCBjaGFuY2UgdGhhdCByZWFsIGFwcGxpY2F0aW9ucyBhbHJlYWR5IHBhc3Mg
aW4gY2hhciAqLg0KDQpJZiBhbiBhcHBsaWNhdGlvbiB3YXMgcGFzc2luZyBhIGNvbnN0IHBvaW50
ZXIsIGl0IGlzIHByb2JhYmx5DQpwcmVmZXJyYWJsZSB0byBnZXQgYSBjb21waWxhdGlvbiBlcnJv
ciBoZXJlIC0gYXMgdGhpcyB3b3VsZCBvdGhlcndpc2UNCmxlYWQgdG8gYnVncyAoc2luY2UgaXQg
aXMgdmVyeSBtdWNoIHRyZWF0ZWQgYXMgbm9uLWNvbnN0KS4NCg0KDQo=
