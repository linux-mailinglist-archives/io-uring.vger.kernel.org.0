Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799C15F8675
	for <lists+io-uring@lfdr.de>; Sat,  8 Oct 2022 20:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiJHSMH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Oct 2022 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJHSMF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Oct 2022 14:12:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D83A14D
        for <io-uring@vger.kernel.org>; Sat,  8 Oct 2022 11:12:04 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 298Cv2ax002894
        for <io-uring@vger.kernel.org>; Sat, 8 Oct 2022 11:12:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=iOVYge362aew0y0XqBZ+tqrR3+2YZmQTWkomxpFcm94=;
 b=dXsxUkYTRfNA6SAnXLTCt6EU3E66d0lQTjOJc/k+UjoIxUrBsbt+2yck7Pr3kK3HHLP+
 ClOcMMl4vRKf1hTd4/I9VJmMnIVbgJmETkv99/ud0DamgtiTXlF+pD1FK9T9kYp9EHOl
 IRP96ngjPgui2at0Ilnzju4UnPpqNb51x1D8yl/5t7cSqDWmOtLwVLXGVsmDmOvkP3M4
 6t2mo9tpFjKdGMABpBdKd7zShUyWaC4q5GRUUGvDeyHh31IVl2h/a9nm8fVmOtPGJ3dd
 Q6GvQh9Q+xbBG4X5oyWZOlRPObSGdaEsfFsp7FR/ODscMPDvXz91Wket/ckvvWtkqGM+ gg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k36ws1hkj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Sat, 08 Oct 2022 11:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMBkI2aWGENAJ4VuxydoZ8ZyGRKEcMCaFXL7npVSAVOYwuzKrvx74ve5i6qKEqv08Cj8eezi3gKX6XYvm/V0GBsiGS2boKtcSaU3900jrSKdqED6MR6g8tWYQCg2sNUlqUc0QaugW3b9eoiqYlOtvUN5oMujU//ffJ4c3DkfbwbihbCVEG9wETWpbPuTrJC3C8uDzyulgWu1JL/glOx93cvqW0W0prBI0fWaujf9ofpxBYYeognfpCK3yTfecRUBrzL5f97ZzMgUtSOE+Ajv3Tkg7rKX4mBoBsayzfBweM9GwHAvtuDDvxpfBp7zPoOH9zJedRdxHYHt5grKcWkAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOVYge362aew0y0XqBZ+tqrR3+2YZmQTWkomxpFcm94=;
 b=Uey+BF4vmkrJI8GK4U6mZ1lnWWOqkvYLq+j/Ot/5+Gnt5TmDWrjxDZIWMAcDG8ZCoymZMr9dMDX+RNEYftZeg1Zw81UGvNmz7k/e6zMXYVFXuJJCRxpJKy6PPW67LZf2zWfOYs6+KbnHUVz12l2xOdkiyjATk75qcwZgcz39MoHRIGd5pwr6pxrA4V9coUogdva8lqiZVaIFfQXgG25NCNj2ObWw8F/uM0u8dR68JzK39MMCkoP0MZUmfontUu1+uEnYSm4mNbNkR9yQAp24bdHiugkbNz1FdLzuoAXrm+Qdi+ZOXz+EmQ83ZBnpdItr5Pspakt9Fvx8QNKB3UlLtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BYAPR15MB4103.namprd15.prod.outlook.com (2603:10b6:a02:be::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Sat, 8 Oct
 2022 18:12:01 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::411e:21ef:d04f:9c68]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::411e:21ef:d04f:9c68%9]) with mapi id 15.20.5709.015; Sat, 8 Oct 2022
 18:12:01 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring updates for 6.1-rc1
Thread-Topic: [GIT PULL] io_uring updates for 6.1-rc1
Thread-Index: AQHY1zMIj1GnBEgqzka5tOl8MNNy2q4DH3mAgAAGfACAAa6QAA==
Date:   Sat, 8 Oct 2022 18:12:00 +0000
Message-ID: <38378ac08073991ab3a7d4c4695382975f808d11.camel@fb.com>
References: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
         <CAHk-=wg1RzrA5dq_9RTz-mhxOPmy7nFap2NiS-Kz6KwpUuDMmg@mail.gmail.com>
         <96dc6533-a3af-a98c-9b6e-cda47c4f3379@kernel.dk>
In-Reply-To: <96dc6533-a3af-a98c-9b6e-cda47c4f3379@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|BYAPR15MB4103:EE_
x-ms-office365-filtering-correlation-id: 0bbb97e2-0a71-46b6-7f8d-08daa95898c3
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TpiwnFewr+zmODDE4CzfM7qsLQXpJAgrNaSxemPS/HNFaFE+iSjdiEp8qV4lHZQxRA/0xZiZfba8MjaDPg5EwbfETZ/u5xxSSm9gC7aZV2QAhtiwTC7rUc3UGyS7tW+DHRnoYJaWfT/nHTbHoPvqLxTc+G2mOk2yYm1MjRoUMTFAHmjqwK+r/01Cnp5Yt/MOVk8MfcDnleek2eS8AwQ7x/+X0CJyiyIezTjijoTrbW654SVyjDWm6gRuSt+VjLqKx0W8iHvmYVOSwI9bz82jhcIfO8dMs9p2of2FAbGAipVeib11NopdCpCh42Z6fwgQ6l3NfUNEHjBXeMv0tJ+RFUC5D25MKaD+biql8SobSd3hRZo93WfWTvxEy0v2RIs315eKKCVnq0M0Fea7nP8iIOzNj78GPiMk6xbtYHZyt8cKZBKV0uPOGcLVe1lBAMlOho2yduQdM6Akt3TfHNKdZqeIqTGeqMCOvpJRVWyriOwx8SkexNo1X5PZ3jWdDhho0rEKlD9/Ei4ucNWqQAKYVDfswNw9cv/lDEW5esQKs6aEWJCU81+1vyMKJYYsAaeNkHXsWZLZbDaBUBqYAOY/uDV2e3+siDeifkmxQtsJiwbdOmeDXzQ+xftKf6kD/n4HGO898a3eJ5zmMWrcp0SX812x4oZ4wS1qas4YGj29AwfIBit4oOUADjC6CyqQn82sHIkqlTs8J/Rhb2dLcM8sdAkPG3McKFDNMLSzTb71+sdchTU3ZdLINs5hFxN4xHLwodNqew9nxF7PsLlmmeYAKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(6486002)(71200400001)(6506007)(9686003)(26005)(478600001)(110136005)(36756003)(38100700002)(6512007)(86362001)(83380400001)(186003)(38070700005)(8936002)(122000001)(2906002)(15650500001)(91956017)(53546011)(66476007)(76116006)(66446008)(64756008)(66556008)(66946007)(8676002)(4326008)(316002)(5660300002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0FGeUZ4eFNGMy90YkVLME1aMFkrVHY0YWN1ZlhBWnhCSUhESUNreG1iQmxZ?=
 =?utf-8?B?N3dvT1FseWY4ZFJtNDZFZVJVWnlxeUNxRDEwTGpFTnBPNFJ5MDhDRWV2bzYv?=
 =?utf-8?B?U2lSVG10RExETDFkSXNkaHNrMk4rZlpXUk9nMWc1L01OQUY4TlVobTBtc0tD?=
 =?utf-8?B?ak14Wm5QZGlKS0ZmRGdweEVueGh6blVZL3dBaWI2b2xjUHhWQlJRRUdmTUpk?=
 =?utf-8?B?VmdvYlFiN3NiNlc5empJT3hQM0lCcHA1c1lNYnVabjJrUTVmcktlQ2laTnJZ?=
 =?utf-8?B?M0FiOTdZWlJ6NzBHekMzWTVQOTBvbWlMN20zaHg2aGpRaWp1aytxNmc1anYv?=
 =?utf-8?B?ZVNKQXIwc1BjTmtWRlo2ZXZWdGNEV1RzMmZ0OUt4aGFKM0JibTR2RTIyS3Ja?=
 =?utf-8?B?d0dkNkJXcFcyVUVuclE4K3FDV05PdGRudHJCcHhKeEkrNzRMamwybU5oaTJw?=
 =?utf-8?B?RnJienY5TTRwNGsvT2pWMGZXNktuTllZLzNuZklnWFFraHZ2SlJPeWhTZEIx?=
 =?utf-8?B?ejY3eWdjZmltcS9GTEJsUXVzVTdzclRBYmZTdzkzai9uYWx1UlJEc1A3VlJN?=
 =?utf-8?B?QlVJQ2syVFBQd0I0bGZWK3VMa3VZNjJ5bXI0b2MrWE9EOWpmb1BCOEIwUmZC?=
 =?utf-8?B?MkF1Q0JtbUJyZzRSOWtURkJVQXM3UEE0NmdHcmZqYUM4MExTMlI2WkdZbWRw?=
 =?utf-8?B?Qk81UEErbHhndTBQdi9WK2JhaUVqd204NTRUSWdYNEVEQ3VlWEh0TXZmR0dJ?=
 =?utf-8?B?cXczTEp2ci9OOXZHczlLN0NpdXVrdVViOFFUSEx1a3FQWG4vZ0Z5bHhGZytV?=
 =?utf-8?B?VmZyQ2MyZzRQeE9NdDAyOGZCa1JDdEppWGxKd1JnQmplMnRrS1JMdUVNU3hn?=
 =?utf-8?B?MzcwZ0dwV212WkcxcExFYlBnR2EzYnhtV2NwamhoeU1tTFc4UllCZCsyWmJN?=
 =?utf-8?B?eHJFRUgyZFZiS242Sy80dTRFL205bGhBYk9vZFB2NThPUUhPbGQzMU52WEJ1?=
 =?utf-8?B?L1VsTC9sOWtlMHJyWjNRTHhXUnZ1Nm1XRmMwcHVRazc2MitMLzlMM1dCVUxK?=
 =?utf-8?B?RmxrK1ExV3VoUmJNTlJKNU84cnlxKy84b21FbW5UMDdIRkJGWmNTS283cE1o?=
 =?utf-8?B?T0I1bkczOU16M0NWUFNwUElzUUF3RkRHWkZvZi9SWno5ZWJoUDdIYmRONmFV?=
 =?utf-8?B?RC9wdk1xSy9MSTFPN293a0phUE5JaGJlZU5JVzVOZ21jdlVZR2wwd3J2NzVO?=
 =?utf-8?B?TWxTektiMFlaZlhLNnBZM0lpcGgxTEZjSlltQ0RKeHBjQUNmeXVYQnR6WCtt?=
 =?utf-8?B?a1k5TlcybGpEV1RHTUJWZkVEVE5xelJ2U09IRk56aUUrNzZOc0hHaWRzcXEz?=
 =?utf-8?B?QU0wcXJackt2WDVSbW40ejJQbXVuRmNXemZnU3AyM0ZNR1RKbVJYNEN1anJI?=
 =?utf-8?B?R2JpZHhjTVZxblh2dFp4dTd6K3FKclpkb29QaFc2NTZnU1A0dlE4VGc0amEy?=
 =?utf-8?B?Q1IxNWtPVE5pYkEvdGhzU3h3aU05dktXb2VCbmEvTnA2QWRVUXlRM0xWc0k1?=
 =?utf-8?B?Umx1cHRaSkMrdEg5NWtxSEltZEZoVjZhNzNrejBTbDZrMlBmckdhNTVmK1p4?=
 =?utf-8?B?YS9KNlQ1UHJTeTVqZi9UK0ZpWHV3TFFjZEEyekNYQTZ1bG85WWhvdDgya1NY?=
 =?utf-8?B?WU9lVTEwWTJRb1l5QnFWeUIvR0RhRlNKZDJwaEtVRzF6SEFaNUdINXhLb0Fp?=
 =?utf-8?B?VnlMd1RkZzZ0Uk5WRTdPb3ZpMnNtVjk0ZXZvM0V4Sjd2RWw5OXAvM3NKWkE5?=
 =?utf-8?B?VGExcEtlQzloeTVTUCsyL290RE04Tm1heFZoMlYrRXFySm5IcldoL1Y4SE40?=
 =?utf-8?B?Z2F4dUVxWmRmb2JibjcwbTFsRkdDS00yZUFBeVdWR0NCWlVKQ0JzQmpBazhy?=
 =?utf-8?B?djRUeTZuOWIweUszc0UvZ0JlbzRremF3RVVueXB2NXJ0RVZjTWNIVXJKVTFo?=
 =?utf-8?B?MG9qVWMzaHhZc1lLQ282ZmVzU2lxa3F3RnlVdHJONUZQRjBhektGL1VaTjVn?=
 =?utf-8?B?SWFwQTJJb2NsajhDL3BFZzNGdUFxVmNOTEVqVytVQi9OQjBzbUFjT2U0c3NX?=
 =?utf-8?Q?ntzHReLlavlCeVJQ6gn8Ojrjw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <973D4AF78FE69443A084B6284CD9EC33@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbb97e2-0a71-46b6-7f8d-08daa95898c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2022 18:12:01.1355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CqThzLfdzgQbatmi7fURZtBtQDYp4vpnEGn0yIQDM2Ac38Y2JuIKEfrAyKyRK2ia
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4103
X-Proofpoint-ORIG-GUID: qTexpgMenF2mobY9jY4y1r0IkDUzkPUo
X-Proofpoint-GUID: qTexpgMenF2mobY9jY4y1r0IkDUzkPUo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTA3IGF0IDEwOjMwIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMC83LzIyIDEwOjA3IEFNLCBMaW51cyBUb3J2YWxkcyB3cm90ZToNCj4gPiBPbiBNb24sIE9j
dCAzLCAyMDIyIGF0IDc6MTggQU0gSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPiB3cm90ZToN
Cj4gPiA+IA0KPiA+ID4gLSBTZXJpZXMgdGhhdCBhZGRzIHN1cHBvcnRlZCBmb3IgbW9yZSBkaXJl
Y3RseSBtYW5hZ2VkIHRhc2tfd29yaw0KPiA+ID4gwqAgcnVubmluZy4gVGhpcyBpcyBiZW5lZmlj
aWFsIGZvciByZWFsIHdvcmxkIGFwcGxpY2F0aW9ucyB0aGF0DQo+ID4gPiBlbmQgdXANCj4gPiA+
IMKgIGlzc3VpbmcgbG90cyBvZiBzeXN0ZW0gY2FsbHMgYXMgcGFydCBvZiBoYW5kbGluZyB3b3Jr
Lg0KPiA+IA0KPiA+IFdoaWxlIEkgYWdyZWUgd2l0aCB0aGUgY29uY2VwdCwgSSdtIG5vdCBjb252
aW5jZWQgdGhpcyBpcyBkb25lIHRoZQ0KPiA+IHJpZ2h0IHdheS4NCj4gPiANCj4gPiBJdCBsb29r
cyB2ZXJ5IG11Y2ggbGlrZSBpdCB3YXMgZG9uZSBpbiBhICJ0aGlzIGlzIHBlcmZlY3QgZm9yDQo+
ID4gYmVuY2htYXJrcyIgbW9kZS4NCj4gPiANCj4gPiBJIHRoaW5rIHlvdSBzaG91bGQgY29uc2lk
ZXIgaXQgbXVjaCBtb3JlIHNpbWlsYXIgdG8gcGx1Z2dpbmcgKGJvdGgNCj4gPiBuZXR3b3JrIGFu
ZCBkaXNrIElPKS4gSW4gcGFydGljdWxhciwgSSB0aGluayB0aGF0IHlvdSdsbCBmaW5kIHRoYXQN
Cj4gPiBvbmNlIHlvdSBoYXZlIHJhbmRvbSBldmVudHMgbGlrZSBtZW1vcnkgYWxsb2NhdGlvbnMg
YmxvY2tpbmcgaW4NCj4gPiBvdGhlcg0KPiA+IHBsYWNlcywgeW91IGFjdHVhbGx5IHdpbGwgd2Fu
dCB0byB1bnBsdWcgZWFybHksIHNvIHRoYXQgeW91IGRvbid0DQo+ID4gZW5kDQo+ID4gdXAgc2xl
ZXBpbmcgd2l0aCB1bnN0YXJ0ZWQgd29yayB0byBkby4NCj4gPiANCj4gPiBBbmQgdGhlIHJlYXNv
biBJIHNheSB0aGlzIGNvZGUgbG9va3MgbGlrZSAibWFkZSBmb3IgYmVuY2htYXJrcyIgaXMNCj4g
PiB0aGF0IHlvdSdsbCBiYXNpY2FsbHkgbmV2ZXIgc2VlIHRob3NlIGtpbmRzIG9mIGlzc3VlcyB3
aGVuIHlvdSBqdXN0DQo+ID4gcnVuIHNvbWUgYmVuY2htYXJrIHRoYXQgaXMgdHVuZWQgZm9yIHRo
aXMuwqAgRm9yIHRoZSBiZW5jaG1hcmssIHlvdQ0KPiA+IGp1c3Qgd2FudCB0aGUgdXNlciB0byBj
b250cm9sIGV4YWN0bHkgd2hlbiB0byBzdGFydCB0aGUgbG9hZCwNCj4gPiBiZWNhdXNlDQo+ID4g
eW91IGNvbnRyb2wgcHJldHR5IG11Y2ggZXZlcnl0aGluZy4NCj4gPiANCj4gPiBBbmQgdGhlbiBy
ZWFsIGxpZmUgaGFwcGVucywgYW5kIHlvdSBoYXZlIHNpdHVhdGlvbnMgd2hlcmUgeW91IGdldA0K
PiA+IHRob3NlIG9kZCBoaWNjdXBzIGZyb20gb3RoZXIgdGhpbmdzIGdvaW5nIG9uLCBhbmQgeW91
IHdvbmRlciAid2h5DQo+ID4gd2FzDQo+ID4gbm8gSU8gdGFraW5nIHBsYWNlPyINCj4gPiANCj4g
PiBNYXliZSBJJ20gbWlzcmVhZGluZyB0aGUgY29kZSwgYnV0IGl0IGxvb2tzIHRvIG1lIHRoYXQg
dGhlIGRlZmVycmVkDQo+ID4gaW9fdXJpbmcgd29yayBpcyBiYXNpY2FsbHkgZGVmZXJyZWQgY29t
cGxldGVseSBzeW5jaHJvbm91c2x5Lg0KPiA+IA0KPiA+IEkndmUgcHVsbGVkIHRoaXMsIGFuZCBt
YXliZSBJJ20gbWlzcmVhZGluZyBpdC4gT3IgbWF5YmUgdGhlcmUncw0KPiA+IHNvbWUNCj4gPiBy
ZWFzb24gd2h5IGlvX3VyaW5nIGlzIGNvbXBsZXRlbHkgZGlmZmVyZW50IGZyb20gYWxsIHRoZSBv
dGhlcg0KPiA+IHNpdHVhdGlvbnMgd2hlcmUgd2UndmUgZXZlciB3YW50ZWQgdG8gZG8gdGhpcyBr
aW5kIG9mIHBsdWdnaW5nIGZvcg0KPiA+IGJhdGNoaW5nLCBidXQgSSByZWFsbHkgZG91YnQgdGhh
dCBpb191cmluZyBpcyBtYWdpY2FsbHkNCj4gPiBkaWZmZXJlbnQuLi4NCj4gDQo+IEknbGwgdHJ5
IGFuZCBhZGRyZXNzIHRoZXNlIHNlcGFyYXRlbHkuDQo+IA0KPiBJdCdzIGludGVyZXN0aW5nIHRo
YXQgeW91IHN1c3BlY3QgaXQncyBtYWRlIGZvciBiZW5jaG1hcmtzLiBJbg0KPiBwcmFjdGljZSwN
Cj4gdGhpcyBjYW1lIGFib3V0IGZyb20gdmVyeSBtdWNoIHRoZSBvcHBvc2l0ZSBhbmdsZSAtIGJl
bmNobWFya3Mgd2VyZQ0KPiBmaW5lLCBidXQgcHJvZHVjdGlvbiBjb2RlIGZvciBUaHJpZnQgd2Fz
IHNob3dpbmcgY2FzZXMgd2hlcmUgdGhlDQo+IGlvX3VyaW5nIGJhY2tlbmQgZGlkbid0IHBlcmZv
cm0gYXMgd2VsbCBhcyB0aGUgZXBvbGwgb25lLiBEeWxhbiBkaWQgYQ0KPiBsb3Qgb2YgZGVidWdn
aW5nIGFuZCBoZWFkIHNjcmF0Y2hpbmcgaGVyZSwgYmVjYXVzZSBpdCB3YXNuJ3Qgb25lIG9mDQo+
IHRob3NlICJsZXQncyBwcm9maWxlIGFuZCBzZWUgd2hhdCBpdCBpcyAtIG9oIHllcCwgdGhpcyBu
ZWVkcyB0byBiZQ0KPiBpbXByb3ZlZCIga2luZCBvZiBjYXNlcy4gQmVuY2htYXJrIGFyZSBlYXN5
IGJlY2F1c2UgdGhleSBhcmUgdmVyeQ0KPiBtdWNoDQo+IHRhcmdldGVkIC0gaWYgeW91IHdyaXRl
IHNvbWV0aGluZyB0aGF0IHRyaWVzIHRvIGJlaGF2ZSBsaWtlIHRocmlmdCwNCj4gdGhlbg0KPiBp
dCB0b28gd2lsbCBwZXJmb3JtIGZpbmUuIE9uZSBvZiB0aGUga2V5IGRpZmZlcmVuY2VzIGlzIHRo
YXQNCj4gcHJvZHVjdGlvbiBjb2RlIGFjdHVhbGx5IGRvZXMgYSBidW5jaCBvZiB0aGluZ3Mgd2hl
biBwcm9jZXNzaW5nIGENCj4gcmVxdWVzdCwgaXNzdWluZyBvdGhlciBzeXN0ZW0gY2FsbHMuIEEg
YmVuY2htYXJrIGRvZXMgbm90Lg0KPiANCj4gV2hlbiB0aGUgYmFja2VuZCBpc3N1ZXMgYSByZWNl
aXZlIGFuZCBubyBkYXRhIGlzIGF2YWlsYWJsZSwgYW4NCj4gaW50ZXJuYWwNCj4gcG9sbCB0cmln
Z2VyIGlzIHVzZWQgdG8ga25vdyB3aGVuIHdlIGNhbiBhY3R1YWxseSByZWNlaXZlIGRhdGEuIFdo
ZW4NCj4gdGhhdCB0cmlnZ2VycywgdGFza193b3JrIGlzIHF1ZXVlZCB0byBkbyB0aGUgYWN0dWFs
IHJlY2VpdmUuIFRoYXQncw0KPiBjb25zaWRlcmVkIHRoZSBmYXN0IHBhcnQsIGJlY2F1c2UgaXQn
cyBiYXNpY2FsbHkganVzdCBjb3B5aW5nIHRoZQ0KPiBkYXRhLg0KDQpKdXN0IHdhbnQgdG8gcG9p
bnQgb3V0IHRoYXQgImp1c3QgY29weWluZyB0aGUgZGF0YSIgaXMgbm90IGFjdHVhbGx5IGFsbA0K
dGhhdCBmYXN0IGZvciBzb21lIHdvcmtsb2FkcyAoZWcgYSBidXJzdCBvZiB2ZXJ5IGxhcmdlIHNv
Y2tldCByZWNlaXZlcw0KYXJyaXZlcykuwqANCg0KVGhpcyBhY3R1YWxseSBjb21wb3VuZHMgdGhl
IHByb2JsZW0sIGFzIHdoaWxlIHByb2Nlc3NpbmcgdGhlIGJpZw0KcmVjZWl2ZXMsIG1vcmUgcGFj
a2V0cyBtaWdodCBhcnJpdmUgbmVlZGluZyB0byBiZSBwcm9jZXNzZWQsIHdoaWNoDQpmdXJ0aGVy
IGRlbGF5cyB0aGluZ3MuDQoNClRoaXMgd2FzIGFjdHVhbGx5IHRoZSBzY2VuYXJpbyB0aGF0IHdh
cyBicmVha2luZzogc29ja2V0IHNlbmRzIHdlcmUNCndhaXRpbmcgdG8gYmUgcHVzaGVkIG91dCwg
YnV0IGdvdCBxdWV1ZWQgYmVoaW5kIGEgYnVyc3Qgb2YgcmVjZWl2ZXMNCndoaWNoIGFkZGVkIG5v
dGljZWFibGUgcmVzcG9uc2UgbGF0ZW5jeSBhdCBoaWdoIGxvYWQuIEJ1dCBzaW5jZQ0KaW9fdXJp
bmcgaGFzIGEgcHJldHR5IGdvb2QgaWRlYSBvZiB3aGVuIHRoZSB1c2VyIHdpbGwgd2FudCB0byBw
cm9jZXNzDQpjb21wbGV0aW9ucyBpdCBtYWRlIHNlbnNlIHRvIG1lIHRvIGRlZmVyIHRoZSBheW5j
IHdvcmsgdW50aWwganVzdA0KYmVmb3JlIHRoYXQgcG9pbnQsIHJhdGhlciB0aGFuIHBpZWNlbWVh
bCBkb2luZyBiaXQgb2YgaXQuwqANCg0KPiB0YXNrX3dvcmsgaXMgdGllZCB0byBleGl0aW5nIHRv
IHVzZXJzcGFjZSwgd2hpY2ggbWVhbnMgdGhhdCBiYXNpY2FsbHkNCj4gYW55dGhpbmcgdGhlIGJh
Y2tlbmQgZG9lcyB0aGF0IGlzbid0IHN0cmljdCBDUFUgcHJvY2Vzc2luZyB3aWxsIGVuZA0KPiB1
cA0KPiBmbHVzaGluZyB0aGUgdGFza193b3JrLiBUaGlzIHJlYWxseSBodXJ0cyBlZmZpY2llbmNp
ZXMgYXQgY2VydGFpbg0KPiByYXRlcw0KPiBvZiBsb2FkLiBUaGUgcHJvYmxlbSB3YXMgd29yc2Ug
d2hlbiB0YXNrX3dvcmsgYWN0dWFsbHkgdHJpZ2dlcmVkIGENCj4gZm9yY2VkIGtlcm5lbCBlbnRl
ci9leGl0IHZpYSBUV0FfU0lHTkFMIGRvaW5nIGFuIElQSSB0byByZXNjaGVkdWxlIGlmDQo+IGl0
DQo+IHdhcyBydW5uaW5nIGluIHVzZXJzcGFjZSwgYnV0IGl0IHdhcyBzdGlsbCBhbiBpc3N1ZSBl
dmVuIHdpdGgganVzdA0KPiBkZWZlcnJpbmcgaXQgdG8gYmUgcnVuIHdoZW5ldmVyIGEgdHJhbnNp
dGlvbiBoYXBwZW5lZCBhbnl3YXkuDQo+IA0KPiBJIGRvIGFncmVlIHRoYXQgeW91IGhhdmUgYSBw
b2ludCBvbiBpdCBiZWluZyBzb21ld2hhdCBzaW1pbGFyIHRvDQo+IHBsdWdnaW5nIGluIHRoZSBz
ZW5zZSB0aGF0IHlvdSB3b3VsZCBwcm9iYWJseSB3YW50IHRoaXMgZmx1c2hlZCBpZg0KPiB5b3UN
Cj4gZ2V0IHNjaGVkdWxlZCBvdXQgYW55d2F5LiBGb3IgcHJvZHVjdGlvbiBsb2FkcyB3aGVyZSB5
b3UgZW5kIHVwIGJlaW5nDQo+IHJlc291cmNlIGNvbnN0cmFpbmVkIChub3QgYSByYXJlIG9jY3Vy
ZW5jZS4uLiksIHdlIHdhbnQgdGhlbSBydW4NCj4gYmVmb3JlDQo+IHB1dHRpbmcgdGhlIHRhc2sg
dG8gc2xlZXAuIFdlJ2xsIGxvb2sgaW50byBtYWtpbmcgYSB0d2VhayBsaWtlIHRoYXQsDQo+IGl0
DQo+IHNlZW1zIGxpa2UgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvLg0KDQpJIGhhZG4ndCBjb25zaWRl
cmVkIHRoaXMgc3Ryb25nbHkgZW5vdWdoIGJ1dCBpdCBtYWtlcyB0b3RhbCBzZW5zZSBJDQp0aGlu
ay4NCg0KVGhlIGRlZmVyZWQgd29yayBpcyBtYWlubHkgYSBsYXRlbmN5IHdpbiwgYW5kIGlmIHRo
ZSB0YXNrIGlzIHB1dCB0bw0Kc2xlZXAgdGhhdCB3aW4gaGFzIGdvbmUgYW55d2F5LCBpdCBtYXkg
YXMgd2VsbCBwcm9jZXNzIElPLiBFc3BlY2lhbGx5DQpzaW5jZSB0aGVyZSBtaWdodCBiZSB3cml0
ZS9zZW5kIG9wcyB3aGVyZSB0aGUgQ1FFIGxhdGVuY3kgaXMgbGVzcw0KaW1wb3J0YW50IHRoYW4g
anVzdCBnZXR0aW5nIHRoZSBJTyBkb25lLiBNeSBhc3N1bXB0aW9uIHVzaW5nIGRlZmVycmVkDQp3
b3JrIGZvciBzZW5kcyBpcyByYXJlIGVub3VnaCAoYXMgaXQgd291bGQgcmVxdWlyZSB0aGUgc2Vu
ZCBidWZmZXIgdG8NCmJlIGZ1bGwgYW5kIHBvbGwgdG8gYmUgYXJtZWQpLCB0aGF0IEkgaGFkbid0
IG5vdGljZWQgaXQuDQoNCkknbGwgdGFrZSBhIGxvb2sgaW50byBnZXR0aW5nIGEgcGF0Y2ggZm9y
IHRoaXMgZG9uZS4NCg0KPiANCj4gSSdtIHN1cmUgRHlsYW4gY2FuIGNoaW1lIGluIG9uIHRoZSBh
Ym92ZSB0b28gb25jZSBoZSdzIGJhY2ssIHRvIGFkZA0KPiBzb21lDQo+IG1vcmUgZGF0YSB0byB0
aGlzIGNoYW5nZS4NCj4gDQoNClRoYW5rcywNCkR5bGFuDQo=
