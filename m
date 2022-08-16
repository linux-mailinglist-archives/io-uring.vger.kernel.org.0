Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F406B595F05
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 17:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiHPP3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 11:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbiHPP2n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 11:28:43 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F8A2558E
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:28:34 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GAFpan010177
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:28:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=z0Z5q1wHZPMBgIZWGwHCnzWQu6py7qFKQFZpQeDG/j4=;
 b=RgYPoqsGfsgZ4aMXKwVCOrhsE1/YDYIr8ZKKAwYxuEiLPgqYr/M5dgvpO9sA9QrMo4DA
 rq1DoDE+EqTyOKieuOVJn+pUP4rhVol1oSWBrpNgLwZLgWH+XFYVzr/QAwvf80j3bUue
 rPTOGKW1FkXOgxdt6Qz1pY0d0Rygx6aMgso= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j09b01vr3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:28:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7IOKQvRrP1wYBH6QGr2/rXZTDa/E48c/ft1Z79dD/g/hPyfRfS/mnkmzNaWmuIXzS6wC+x1LwjsaG+WtNsRB5eEn+4iXyU1BBMke2ZLLc2SUmGxfIAlqND/JD8CouNXJX7JVtDGxCf2EH4YKIGM9FO8M8wdWqLHbmpA3CtSBm0wgy7Paa2O/H9caa26XdyWGrWXPix/LbNBR7dEtuvln9iK5EmXQSJM3qHzfv/HeMTKiW810LbPuPCHqcLIcXWkf+kTtyvBdlSKWwDU9ez9J9VkivFmsT7zdW/q1h/UeafxOcFPkb+jlIeNgDvO99dLiuUFBAhYfG2itYUdAPEidg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0Z5q1wHZPMBgIZWGwHCnzWQu6py7qFKQFZpQeDG/j4=;
 b=m14ckHgpdO2QlLWE7gj/z68FbpbMRbtkqXSDtrEcVJi9vZacMESO6D0+fNPRUw3fgdhZlmykSHhfnxX9vW5FNTxXsOj3rMzLPQ/eeAkYtXpRKWuITEADBs+uWccJgBgc1zD2jYQMEJuvcOChG5//9qh/umWn1h6bO2o4j7BHBbIOWTjEigeRE2jGjguVj+FmFmoBuAEZwqJ9DaeZZIjykvXf/TuegETqdyp6ArNyX9gat8ILFg/HTKCNMn38jv7XXLJBayMjKtgBzIUyny8Nm2sCAAQu8G5AdcT3OUdpn29yC19jAM1/OAC8HpOaJ+oJjufJG6tpAdAFmrvQzAsJXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MWHPR15MB1806.namprd15.prod.outlook.com (2603:10b6:301:4e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 15:28:30 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::b916:6bc5:47d:c7ac]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::b916:6bc5:47d:c7ac%4]) with mapi id 15.20.5525.018; Tue, 16 Aug 2022
 15:28:30 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH for-next 5/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Thread-Topic: [PATCH for-next 5/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Thread-Index: AQHYsKirVY7XaSKPw0ikdYHf+v7Tqq2v/d2AgAGqfYA=
Date:   Tue, 16 Aug 2022 15:28:30 +0000
Message-ID: <866790729dafdc4bf57be2e537ad56660feb142c.camel@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
         <20220815130911.988014-6-dylany@fb.com>
         <d86f4994-cc30-720f-8fa7-3a5a11508a57@gmail.com>
In-Reply-To: <d86f4994-cc30-720f-8fa7-3a5a11508a57@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da1f88de-f020-430a-af3e-08da7f9bf958
x-ms-traffictypediagnostic: MWHPR15MB1806:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1q4sKfga/XV1axHRoYMqpmaBDPiIkzxnJ1We7hGsnYrqD5G0wmt/DCHjgkf/5d15aywwcvsnnbF5GyamG8tpMa0aDV2yOo+QpMfnF0N4kMceIRX1qHfms1zyr61sg6haFFTt7n9MXXl9SfZBSIdSD2ObrsfBQWi6m+ukJw2TY1+RzJw9GOTfawgQickcB0KbXjFKqhDHrc1KtjPDMAEVna4t+W4tkpJ2cgU+mKikGRUo+PdlQRG4gznrHNTbg2+kzvlUCjWmDTrG6mfMTRAVeu5p9nZvPwfp/LjU3DCTNQGUXcC80gEkB4s8klAAa3csXjr6aWF2NqhhE+iLrKtrJ9PjCiMS42wmcxQzT33cZufgWZ98LItjWBEEMCs3pKlirPyOlBa0ggz1CLGFjtYxWWu5RHxI/qeTfq+5vDmg4PpSkbWloGN9RHm/qKypVXPbhNq1rtKN+NY4PFtvvpFIZ7B+utkq9sFBZCf/81Cpu3Sn5nSCo1MUnB4rseROxNvVeQiimF/TwVbHCoYBye7oavUPGUJrrlpR0xvl/l9I7ZgLy50S74LM+8SxidcQpiZjyZwK1sr0rKUZELirx5pVhhWzbV9TteODj/QaQfnVFcGgYyLJY3lfy8PR5DeWuBQ+J/bwEfBhbSnLq14jsUKJtn72yxthoyUYC1q5DjdqQTPT4fMI4GHhuHnIpF/BCxGnSp5P/nsCPPcGDt5BhyOQRTnL8fkq9LKocUT6wMWr+L90J+MOPwvl7phravv+OIamajwSS7HWeuMkBX6J3YLeemhpCsgRqRo6pJEXK3SZ/fydD2tXmM2stxxvd9vRqQx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(186003)(64756008)(83380400001)(38070700005)(122000001)(66476007)(38100700002)(5660300002)(4744005)(8676002)(66946007)(66446008)(76116006)(316002)(66556008)(91956017)(26005)(6512007)(8936002)(2906002)(2616005)(4326008)(86362001)(71200400001)(41300700001)(478600001)(6506007)(6486002)(110136005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2gzTjYvT01jTGZINmhnZ2JJZTRBa253N0VhVTdlQmxyRTRRL010RkhQSS9h?=
 =?utf-8?B?cnFzZyt2UW5KVm9iNWJBZmYwb0hMMnp4NmxROXFDbEpHcGM4QlZtOFQ5ZHRD?=
 =?utf-8?B?ajJPdXl2Q09EWnJrR3R2OEpRcVdwQTNJSU1WbkFSK0hkbCs5OHR2dkF4d3dB?=
 =?utf-8?B?N0c3MjZ6UWpEYkd5KzJOQ096N1dtS2RUUklXVUtLTzF4NWV0Wm5TdVI3Q3A5?=
 =?utf-8?B?OTlmRjZHb013QldNcUZsZlVmUTBVbUkwSnVKZjBlWnZHVzJnNEJ2Q1E0VWY1?=
 =?utf-8?B?aWFJTVBDN0FIQ21jdUFGZ2ZHbzVzVDBjbzJHc251YlpJejh5K0FJdkZtcHVZ?=
 =?utf-8?B?aDMxMFYxQlpWeFpRYjJBL21MY3pzVUU4bEplWTF4R2NjS1RBMTQvN3JWYmRk?=
 =?utf-8?B?a0Nrd3hsYXdTdWowVGxjeXJEd2ZpM0VMWGR6Q2xOQTlLTm9mQ0NwMDBONHd2?=
 =?utf-8?B?MmZLQkFUR0NLVTZ6ZzVVTytkdUo0YkYzWDlPTGdEUmpnVjB0WHB5TWF4Q3NI?=
 =?utf-8?B?akpPa2tudWxNbHVtbjZKQjBFdDQvTCtPOWRVWHRlcTQ4VzBVMkdyWHFhaFlU?=
 =?utf-8?B?OXZJeUNRU1NacEl1QlR4azliQk1NakNYeWxWWXNsUkdWdXRUYm93d0wwOVh2?=
 =?utf-8?B?MG9UY1I0YU5IZU83WkVOVVJhczdKdHNjQThEQ2k2TGZFNFQwRnpSYUxNTTJM?=
 =?utf-8?B?QmdXQVlQVWpCd3g1VzlpK2RJOGQwYnNXaVJRWWh1aU1kRkZwV3lRSjE1VE5P?=
 =?utf-8?B?bjVlTkc5WUNCQXZlUlc0bnNyc0kxbFo0ZW1naFhCWExGc2tEVTJyaTY0YUhV?=
 =?utf-8?B?bkZPRUEzTTZtZDFTQUpMSWVSNm0rZ3RlOVZ2RkhRYzNQaW9ZZmZoV0tINHls?=
 =?utf-8?B?Q3ltQkowanpNdlV4UTFNSiszMzlGbG84Z1hQd2w0TmE1dVptZWhGaloxQ2Nz?=
 =?utf-8?B?b3dhZmIvYXY0VXNiaGFMS0JZWUhqc0szU1pIRmxHZE4zekM0c1RmdFlpWkhh?=
 =?utf-8?B?TFUvUjFmTW1UdlBzeHFDYmtSU2c0NHRVcXNuSFJFYnl5Rm54S2N6RkRab0Q1?=
 =?utf-8?B?ejRPd05BK2NUOFN4TTRLUDdRMFc3bnBHckRDYTZhclpoK1lnVU5tOUJCdVV0?=
 =?utf-8?B?eEZwNng1NzJSS284bUo5RWlXWVZoTDVueXlvSFJJMVprNWRaVlJPSUlUZkFy?=
 =?utf-8?B?TS9PTjlTdWY0dm5kZFg4cFJsTWx4UGl0WWVpWjVucUpmOTQrUDFZR0tXR2dP?=
 =?utf-8?B?SXJidnNjL2ZRaFBQK1Uyc21Oa2U3cUVucjFWOEluN2hJQjYweUYyd0crdnJJ?=
 =?utf-8?B?WWQwZXIyZHBqQ01KUGNyLzl6T1A3SXAvdk5zTGZ4Z2pSL3lMblFTUGhFTXph?=
 =?utf-8?B?VDNkcFdZZ1JQQ1RsMmFaamVBVlhibzMyMmsyS1VYWGloWDNZa2JtSWs0aFRt?=
 =?utf-8?B?VFpmMTFRMzA1NldUeE5IcFdrMXVoeWRRaE5WM01FaXUwcTZxRTY4Y2J1ZGF0?=
 =?utf-8?B?dHV1YTdRRVBUcUtwMW5DVGxDc29YTVMxMnhZTm1hcCtHZm9yR1ZVbk1QblZD?=
 =?utf-8?B?ZVdOSlNVWkdPSjJzOS9PekNFZ3FJYTkrWCsvT1EyMEtPRFEwZVNTNjRMbVlN?=
 =?utf-8?B?WEtjQ3NhRW1UZGJ4ZVhDNnZ5L2lOREJCUHhHZ1ZZK09kc1pacHFGTU5kNjdI?=
 =?utf-8?B?MzNKWGZ1WlE1RlZkWDQ5UWhacFJoTFI2N0FwWWpDT1NEN1YyVjdEYXpBenZv?=
 =?utf-8?B?ZWJIUDJQdDVxVWdjalQ5NDhtNXVjYnpWOXJDS3lyV1hPWlB5SUt0Y2JRQmNM?=
 =?utf-8?B?V2xEYVhnUzJPUHdnU3g5eGpzazVKRDRLM1RoQXFDRXBVcHRVZ1ZCZ2cvNFJU?=
 =?utf-8?B?bW10Q1JoLzAvcDd0bmRzaFkzVTl2L3AvdWpNL1RVdUZ0UFBlZm9zbHpIY3d6?=
 =?utf-8?B?bDNmUkV6QmtJQ1pQSFRWRTRUTENRSDFEV2I4ZFNtUXVDdU93a1BZREZudkJG?=
 =?utf-8?B?OW5vUU03MERSTCtYY1g3YzB0L1NKWWhhVWlyUU8zRENpSXdkUDZiWXFrTHoy?=
 =?utf-8?B?OGpPWDFROUphY0cwcDJLSnUwTmpFSjlLWHlmYkdWUzZrMmZwZXI4bExEa0FX?=
 =?utf-8?Q?uHm6OHvSKT2lJ4f9ZeLAzqVrd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB2B573C1759D94DB1462A1D1DFC1447@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1f88de-f020-430a-af3e-08da7f9bf958
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 15:28:30.6187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyQS0S6hVaN1CKWuSMYDKnTKr2rE2D3Opr6CZibIHGVkl83bQ80ZAhGPIubLY6OV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1806
X-Proofpoint-GUID: hAzoDAsIimOSYu0YQlY8jlJ9IF3u50Mw
X-Proofpoint-ORIG-GUID: hAzoDAsIimOSYu0YQlY8jlJ9IF3u50Mw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTE1IGF0IDE1OjAyICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToK
PiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoKGZsYWdzICYgSU9SSU5HX0VO
VEVSX0dFVEVWRU5UUykgJiYgY3R4LQo+ID4gPnN5c2NhbGxfaW9wb2xsKQo+ID4gKwo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghKGZsYWdzICYgSU9SSU5HX0VOVEVSX0dF
VEVWRU5UUykpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoG11dGV4X3VubG9jaygmY3R4LT51cmluZ19sb2NrKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBlbHNlIGlmIChjdHgtPnN5c2NhbGxfaW9wb2xsKQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBpb3BvbGxfbG9ja2Vk
Owo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG11dGV4X3VubG9jaygmY3R4LT51
cmluZ19sb2NrKTsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpb19ydW5fdGFz
a193b3JrKCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWxzZQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpb19ydW5fdGFza193
b3JrX3VubG9ja19jdHgoY3R4KTsKPiAKPiBMZXQncyB1bnJvbGwgdGhpcyBmdW5jdGlvbiBhbmQg
Z2V0IHJpZCBvZiBjb25kaXRpb25hbAo+IGxvY2tpbmcsIGVzcGVjaWFsbHkgc2luY2UgeW91IGRv
bid0IG5lZWQgdGhlIGlvX3J1bl90YXNrX3dvcmsoKQo+IHBhcnQgaGVyZS4KCkkgYW0gc3RydWdn
bGluZyB0byBmaWd1cmUgb3V0IGhvdyB0byBkbyB0aGlzIGNsZWFubHkgaW4gdjIgYXMgSSBkb24n
dAp3YW50IHRvIGJyZWFrIHRoZSBleGlzdGluZyBjb2RlcGF0aCB0aGF0IHNraXBzIHRoZSB1bmxv
Y2svbG9jayBmb3IKaW9wb2xsLgoKSSdsbCBwb3N0IHYyIGFueXdheSAtIGJ1dCBwbGVhc2UgbGV0
IG1lIGtub3cgaWYgbXkgc29sdXRpb24gaXNuJ3Qgd2hhdAp5b3Ugd2VyZSB0aGlua2luZwoKRHls
YW4K
