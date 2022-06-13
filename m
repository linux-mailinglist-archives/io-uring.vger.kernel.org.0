Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4B6549A52
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 19:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242039AbiFMRoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 13:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243478AbiFMRnt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 13:43:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2425165340
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:17:04 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25CNEMTs006429
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:17:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qJjDH0X4Tf+Wjpx3/7HItWLnGg1LcRkwShGcTxUETUc=;
 b=cXuqgv6Ijpp7OA+ZGwqfqF6yJ4SAjYbu6PtrVMlFdIC0jBAZyaCEoU6rgIeLqO0S0FrQ
 TtePe0aw6yPHaT4iSss/LfyycvJkJJZPqoCHaA0/9Qdf188xsK2yE1mu9kYzm9u2VkgM
 xX00Gd6rWgUqGXiaypNkg0udpkzJtPmlfmg= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmpcmgjhw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCuhcY3UN/0xPxiML6ay2nE1BEMdqwZzISfCOvSqVFgzspNXTfnrg9grZIUaiGeNHExl1TG1u67R1Ys/4MXLYr14wI1TWHSao+XAz1YuYnP1yTKsC7FamgfOab0wgzqW04M5JDp6m5I/HODs/86cezZ1LeqSJ6fguirSEao78iuyZcremgx4oI5agXCA/zWjFSY4y5f1O2/0viuYomw8Ln56VksKjOVO1Wfmyo5Y2DzVr+N3bgLcKgsMRuOtIVUM9dyWC4vGe7PZmGDeBNwfruONUAQsqy1mUm9YV86JzOE9UJ/M3QrftSr2yUXnPh+6+EYgdg74NXwv9GePLhBbMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJjDH0X4Tf+Wjpx3/7HItWLnGg1LcRkwShGcTxUETUc=;
 b=F3BcyOtLmQsLrCnqxHBqGkHxAmQwdbRjx7i+Oa6JbXpZr/eddNXTWnow/aG5U50W7HvdIYc+osR2Jdv08DSMVqBRgTRvax/mQbl5dBK3TagSdFDHOhzKoMdpXstySM302OZlZxZF5dAmRhN1IFdqFOqVW4OK9F2VTOp3qrW+Kheze6trXuN4bqaTgzeofPdvzsdaj42F+gU1OC95Boh7ncvraqrZBvj0Zw020sH52OCv+YzC9Ngu8PHOMojcGQkhFEgvaf+svsaUnb/TkBxh+tnvdR4edxqHUv4vzr+W6cbSMis5k6hwte39QpLL4SP+S4KwHDKimazbGiCZbCFl7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BYAPR15MB2264.namprd15.prod.outlook.com (2603:10b6:a02:8a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Mon, 13 Jun
 2022 13:16:23 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1e3:da4b:81f5:70b6]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1e3:da4b:81f5:70b6%6]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 13:16:23 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH 0/3] io_uring: fixes for provided buffer ring
Thread-Topic: [PATCH 0/3] io_uring: fixes for provided buffer ring
Thread-Index: AQHYfw4KoeGGp+e5PUSrO4cuRLXAbK1NLbwAgAAe5gCAAATPAA==
Date:   Mon, 13 Jun 2022 13:16:23 +0000
Message-ID: <265e0239ff5b6a8a4a6d91446c774549affb5191.camel@fb.com>
References: <20220613101157.3687-1-dylany@fb.com>
         <f2fddce1-bc25-183e-6095-bb5a70a57319@linux.dev>
         <de5e6f02-dcab-07df-7cc4-7f12885083e6@gmail.com>
In-Reply-To: <de5e6f02-dcab-07df-7cc4-7f12885083e6@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 108a18fd-109d-47bd-b475-08da4d3ee9e6
x-ms-traffictypediagnostic: BYAPR15MB2264:EE_
x-microsoft-antispam-prvs: <BYAPR15MB226400384ADA0410D9382012B6AB9@BYAPR15MB2264.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mUNuDUA32GCTzMgY7CnD0TgdaeqyT4wDkvHxe8b2E3/5n3WN6NKuHSiHrO5kb5sDcQ1MMI0qRFxG0g1jittvaSp3IIm6gjjKRPGKSghGlDb7gsYixgZO5ZGWHQSXlE5ZDv9rKFS++0lERzo50+VpPyTdDC+M3GP43tIse1gxRM4PA1oYbEzOsrAa3GlmnOEjCrbOpdctoyaAGX5MX/TQxHRmTGbrPmfikEjgMqrRfhz3VfdD18q5dbhCwbUIkKeAqu6PEVFNZ4NRHi+WyhmRb683pI96jSSdLFkoCNvWGpOYEkLoEQJyu6JQgA+x6DtzgjGNX1uQWkHkHn7jmUsnNdXovswAJUUjLPW+/FN3VQYn4UxWw82oW7G+TtLvIwUeNDxYMC8FpLact/5SRqihb7bCo4XqSDHtY0/w7oSrdlscNiUC4rOCK8KJxZRyomorLl9cqkqzXaQ+nR9n5kJYg6S1JwBS1wjKX8GCuoJ1P9ucEPnv5vP3QpqwUknHPVzCoOTg17uAmg6u6OUUce0ee89gle6/c6VFbK2NtgenWoIo6NgZCb40QiY6VM6IE9xtSUyAHOM1qIIfpjYoiKkwvWHbMbI1N72stxQocc2DrT010N4aaB9SuoeOLrr+VYpGZJ/kN8YKhaxR6aqdIhjitkgWgu7fJ5LWBvl3lFDL7UsYeOeYgcIj1e9WIwtrI59DsVL99Vz2l2i4cnWa0W5c7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(6512007)(186003)(6506007)(53546011)(316002)(2906002)(36756003)(5660300002)(91956017)(8676002)(66446008)(64756008)(86362001)(8936002)(76116006)(4326008)(508600001)(122000001)(6486002)(71200400001)(38070700005)(66946007)(38100700002)(66556008)(2616005)(66476007)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjZUd2xVeXVqaFlPbHZVWUh6a096b1RUTnBMamZzemhwa0prZE1Zb21wSTBa?=
 =?utf-8?B?TGRGWVVyOTI1MktJdnNrZ2RzTHYwclEyNnFQM1Q2RkxUK3JCcFp4YkVVaUxR?=
 =?utf-8?B?b0Z6dVAyZkE5anl6UENJRGFodmwwWmRNUzhCci9QTXVQVlZSbzlPQU9uL2c2?=
 =?utf-8?B?eTE2bG5BWU81eEZRTW9JQjhjYnJLdzVIK0NtS2tPMzZYSERLa3h3RHZwdGV3?=
 =?utf-8?B?dGhVRG1hM2k4V1dlSXgwMEI3MGJRWlVFekhJeGYxaytGMVNVbTBNL1ZpMjhP?=
 =?utf-8?B?bmtBc2lYMGJPUFJpWGhnMnVzaURSQlhYYjVkbE1lSXJpM20rZUh6QThvcDFT?=
 =?utf-8?B?QkxTSVltZUZjTHM0UndKOGVpQ0NqQzdZV0dSaHJLN2l4MkgxLy9YajArMXdZ?=
 =?utf-8?B?V2ZMbUhRblpoaVZSSHovWFR0eUxSN05KTWpITjZoYVVtdFQ5RWV2dk5JNk9N?=
 =?utf-8?B?RTZQSnd0cFcxMjA3K1ZFZzdXU1ZGa0tmU3oyQ2RXVlo0NVpxZzhGcFRVRTFP?=
 =?utf-8?B?MjVRK21obHVwajR1Qmd2aWJqdThBVDFHZEx2eUJVWTlzWFFWWGVObkZHcWhW?=
 =?utf-8?B?b3lhS0pCbExkTlZjbHdXbTdEU21sWWdndHk2NkhkeGFkL1psRDFyaDYxTWUz?=
 =?utf-8?B?NEVaRG5JYXlpWHgvRHgwOUV3a3hHcmRZaCtVTjNXdkFyMGhXSHhjQW5QNksx?=
 =?utf-8?B?OFZXU09zcDVvRlFkdU9oVTZ0TlJYbkJEbkFSSFo2dWVzd2dYdENRK2NpZ3FP?=
 =?utf-8?B?N2NSak5lWlBHbGI0dW9NYUN1TXAvSm45all4bUY0a28weWNqbkhlYXdwa3lx?=
 =?utf-8?B?Rmd4SWxsWEUvWWdZL0s4dWJGMUlnNHdHWTUwYVR4dEtlNnJJT2RzVFFHa2V2?=
 =?utf-8?B?QWdEaHowcUlUa0xJaUlJZUl4Ky96dHE0bWk0VVlMeHNFSHRJQUxwSHJHdytp?=
 =?utf-8?B?dDVnWmJOOXhpbWdWdHFqNk44SVowWG9wL2xNUzQ0R1BRSzdIQ3NqWWlSZVFE?=
 =?utf-8?B?MnZkUjVtV0dmenVvWjFYaXROcVNqdk9vWSs1MHlOTmhuaGdscU5VTHRpNkps?=
 =?utf-8?B?TGxuSjcrYjQzTUZWVk9vMkEvNXpUY2xpMFhUeDV1aWZWWU9taUt2ZVlpVnhN?=
 =?utf-8?B?aTJINFpWWmp5YngyaFBtNUhmMHZhVGNYWFh5UDdHZzNqaW41NXAwY3p5NWhS?=
 =?utf-8?B?a0dzZzBlRnZPa285d3VESG10YXpjVEVTSzU3ZGRMNUxudjBRblRmREQ2VUp1?=
 =?utf-8?B?bDVSTm8yOUNNTGlRTEhaR2VWM0pZV0Npa2c0dGxkUXdOYm4zb2hXWmFtWFRj?=
 =?utf-8?B?cG95bWFNRjZRalNBRFRBdkdrQ3JjdHZoUkxGME9IajFqdTBCaTR5bnB4SjlW?=
 =?utf-8?B?YVNnS2g0cnpIYW4va0tJQjgwZCtzYWthTDFIeUJCcXpPeGYvZVhlb0hPb0dj?=
 =?utf-8?B?dEwxMVNLT2VBZnFrcytwVWxlMVcrYnVZeUY5TE1mVW5nVGtPWlFKY2RUR0NT?=
 =?utf-8?B?YTR3bkhsZGMzcVFOUm95UWZpS1l1TktSeGxKcDk4WnJRK3I2S3pjWW5NajRq?=
 =?utf-8?B?alFNcDgyOGJPQnZLZ0dBemNFNUo3ZG5pRUxLVHdxRzFjSHRETnBLcDZPMFBZ?=
 =?utf-8?B?eFpXbnVleEU2c0ZwQUhsbUpydmR1TGZKaGVOazVuWGMvRDJRRnBJWWhwRzVa?=
 =?utf-8?B?dmE1Y3RQOWc4S1JvRE9vaWoxaW9rQTZFSmwzUkdTMG1pakVTak83ZE85aFgz?=
 =?utf-8?B?VzJZdUFVN1FuWVVlOGNWVmFMV3kwUzNRZDdzMUlqN21ZTHYzNUsvT3d5Y1M2?=
 =?utf-8?B?bHpxRFdJY2FUa0RCd21XUG9yUDl5cUJ1N2swc09Gb0x4a1BPRG9uMnVpRWxS?=
 =?utf-8?B?dlcrRXo2V1FDYjl3NlVXeDN5TnpKV0dmM1JFd3NhSVlQcGxHUVg4L1RDbXJV?=
 =?utf-8?B?WktaRGtuanVHZ1ZLOEYzSlgvMWRuMmU4ZXhQSkM1TFpTQ2xEMTc1bm9PZzY5?=
 =?utf-8?B?VElCM1JGeWdlU1VSbENzc01SOTRBQ0R4WmVCQW1IYUN2Yi84K0dtZEY2K2JM?=
 =?utf-8?B?SGh3bnJxN2lTbnNpWmNHeEwyaHNwS09DeHEyUWp2WmpzSWszMS9rNGRBOUF0?=
 =?utf-8?B?WjgvMlFoZHNTYndYUlRRanp3UityeHNDNjhNS0krYnF1R05MWWZFa2VzSjd3?=
 =?utf-8?B?TlVHVCsvZTBZMUNsNWlzWlJhVDNHV2M3RjlSOVBpbE1OdHlGTUNoL2ltNDJQ?=
 =?utf-8?B?S3ZaMHFaRXVPaDR2SlBhZ2Q0L1AwN21TcDh6aUExUEFPdnMzWW9pOVcvVDEr?=
 =?utf-8?B?OVBNc0c1T3FUV1VNaEpWSVQ1WXJXSi80dlJwR0xFdXlQWHFWaDQ1VDl6dW8z?=
 =?utf-8?Q?VhGz1OKGoC3tdXjw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDF27AE82F00D442BD9F05A9D764FC65@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108a18fd-109d-47bd-b475-08da4d3ee9e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 13:16:23.3712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vrMvMwcPmxgjjy1aUmngm4mIzYfmWZEmWbSsOrD+y8AJi5CPdaxnFhh9B0xRGPW2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2264
X-Proofpoint-ORIG-GUID: -eNlRmvRQeMt34LKi24vUdcLhZCu2glr
X-Proofpoint-GUID: -eNlRmvRQeMt34LKi24vUdcLhZCu2glr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_06,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA2LTEzIGF0IDEzOjU5ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gT24gNi8xMy8yMiAxMjowOCwgSGFvIFh1IHdyb3RlOg0KPiA+IE9uIDYvMTMvMjIgMTg6MTEs
IER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gPiBUaGlzIGZpeGVzIHR3byBwcm9ibGVtcyBpbiB0
aGUgbmV3IHByb3ZpZGVkIGJ1ZmZlciByaW5nIGZlYXR1cmUuDQo+ID4gPiBPbmUNCj4gPiA+IGlz
IGEgc2ltcGxlIGFyaXRobWV0aWMgYnVnIChJIHRoaW5rIHRoaXMgY2FtZSBvdXQgZnJvbSBhDQo+
ID4gPiByZWZhY3RvcikuDQo+ID4gPiBUaGUgb3RoZXIgaXMgZHVlIHRvIHR5cGUgZGlmZmVyZW5j
ZXMgYmV0d2VlbiBoZWFkICYgdGFpbCwgd2hpY2gNCj4gPiA+IGNhdXNlcw0KPiA+ID4gaXQgdG8g
c29tZXRpbWVzIHJldXNlIGFuIG9sZCBidWZmZXIgaW5jb3JyZWN0bHkuDQo+ID4gPiANCj4gPiA+
IFBhdGNoIDEmMiBmaXggYnVncw0KPiA+ID4gUGF0Y2ggMyBsaW1pdHMgdGhlIHNpemUgb2YgdGhl
IHJpbmcgYXMgaXQncyBub3QNCj4gPiA+IHBvc3NpYmxlIHRvIGFkZHJlc3MgbW9yZSBlbnRyaWVz
IHdpdGggMTYgYml0IGhlYWQvdGFpbA0KPiA+IA0KPiA+IFJldmlld2VkLWJ5OiBIYW8gWHUgPGhv
d2V5eHVAdGVuY2VudC5jb20+DQo+ID4gDQo+ID4gPiANCj4gPiA+IEkgd2lsbCBzZW5kIHRlc3Qg
Y2FzZXMgZm9yIGxpYnVyaW5nIHNob3J0bHkuDQo+ID4gPiANCj4gPiA+IE9uZSBxdWVzdGlvbiBt
aWdodCBiZSBpZiB3ZSBzaG91bGQgY2hhbmdlIHRoZSB0eXBlIG9mDQo+ID4gPiByaW5nX2VudHJp
ZXMNCj4gPiA+IHRvIHVpbnQxNl90IGluIHN0cnVjdCBpb191cmluZ19idWZfcmVnPw0KPiA+IA0K
PiA+IFdoeSBub3Q/IDUuMTkgaXMganVzdCByYzIgbm93LiBTbyB3ZSBjYW4gYXNzdW1lIHRoZXJl
IGlzIG5vIHVzZXJzDQo+ID4gdXNpbmcNCj4gPiBpdCByaWdodCBub3cgSSB0aGluaz8NCj4gDQo+
IEl0J3MgZmluZSB0byBjaGFuZ2UsIGJ1dCBtaWdodCBiZSBiZXR0ZXIgaWYgd2Ugd2FudCB0byBl
eHRlbmQgaXQNCj4gaW4gdGhlIGZ1dHVyZS4gRG8gb3RoZXIgcGJ1ZiBiaXRzIGFsbG93IG1vcmUg
dGhhbiAyXjE2IGJ1ZmZlcnM/DQo+IA0KDQpJIGd1ZXNzIHdpdGgNCg0KKwlpZiAocmVnLnJpbmdf
ZW50cmllcyA+PSA2NTUzNikNCisJCXJldHVybiAtRUlOVkFMOw0KDQppdCBkb2Vzbid0IG1hdHRl
ciBlaXRoZXIgd2F5LiB3ZSBjYW4gYWx3YXlzIHVzZSB0aG9zZSBiaXRzIGxhdGVyIGlmIHdlDQpu
ZWVkPw0KDQo=
