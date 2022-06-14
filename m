Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369E454B880
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbiFNSYA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 14:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347266AbiFNSX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 14:23:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B54A1CFE3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:23:58 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EIGRkn003269
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:23:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=R0rUP1TzXJUamSGG0f5cxjMgKsS2zJJsk4I612jDpDw=;
 b=XU5emMDMWB9fZr3Ygq2DkFgHMJrAIAcxjbURZrAFqSrBP3N1tq+o29OcIQ5bmDSAqsOw
 4oR282nUCEzOceemmjUQSA/xuY5nQ7f8Kr2jHazWIeGDmdI1aJctuIAVX2SM8146pOGq
 UHEZ6qiX7DANoib+Vpr/3hh/+rlaUQa5yDU= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gpqw238sd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:23:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3mj6TYchcX5pl+XJtLJ2T5CnB3svoku9GWPVrMzOx6CxaolNmakKDz1mzqp/1HJNvQNehTHdahf5wdoQMq5drwhR9OC5l2l0yQ32QDwM4dsuwv3qLst9B3qOBuvv/2GrbVxs6TEa+sJJvuYkXKxfmO8XgFHCfTDjvZSp/Ndt/K6XpH/gczu5oUkUCF+8F6eRerQFxOiOSMprp8a/ezeGEXDpi5om9fZ8dsA0EArC/zhFBwYe/HELoQS7BqeqNTxUqRhPd+JXVR5ETxyTD/LGx0jNHyQw8uBJr6ceMTyMWctMyyfTxKZCe+k761IPpGPutosO7P0Ys4rc1QG0sO6xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0rUP1TzXJUamSGG0f5cxjMgKsS2zJJsk4I612jDpDw=;
 b=CHicZ8lSzqqlcrfn7O+9IIaxiEkvKU6+0FJ9aYzVVZtVZfPerINS5z/k5oTFIB/q8ujvw6oR1AHpzBrs1oACB3rVwNCcXWufe9OM5gUTSKIIHVFcAojm/p9HYldHemANtxGSDc2alhiZJRHq9+NM0PQn4h1BO0gEJ/V71z4OKG2Je4jPfOC5OzN3QeiaZ73JOMUxtozRgke/NpsbeVQALv4EUypxnGvzHuMkCF1OYoz6L7HgoywciajFzVaeKN59oaPt2PGMm2rufIyVVgQ+UH2wOPkpt1vq3H07uepI3b0h/yIz35nj4TAUIjVlvns8xDwuduW4JKY5AQu0DqWuWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN7PR15MB2196.namprd15.prod.outlook.com (2603:10b6:406:84::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 18:23:55 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5062:4f9f:83f3:1100]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5062:4f9f:83f3:1100%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 18:23:55 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Thread-Topic: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Thread-Index: AQHYgAN/bErHLAW5OU6iVu6XV1D2xK1PB1qAgAAFGYCAAACrgIAAKqiA
Date:   Tue, 14 Jun 2022 18:23:55 +0000
Message-ID: <9f85b4b2bddf00b3e2962679a4b3e07f5b6b0e7b.camel@fb.com>
References: <cover.1655219150.git.asml.silence@gmail.com>
         <9b2daabd-3412-7cd8-79d8-8a9dfe4b27d2@kernel.dk>
         <da4c0717-be10-c298-9074-b237ea613ba5@gmail.com>
         <bd18039b-2a06-62c8-77e2-6b86ba3c2d73@kernel.dk>
In-Reply-To: <bd18039b-2a06-62c8-77e2-6b86ba3c2d73@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8d830b1-bbf9-4a66-00de-08da4e330a5f
x-ms-traffictypediagnostic: BN7PR15MB2196:EE_
x-microsoft-antispam-prvs: <BN7PR15MB2196F8072DC1594AFD1883B5B6AA9@BN7PR15MB2196.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ix56xj4Gn2OjdmmNQqyx7bFotlj/CbFwbbix/xzw85GyWolMdK3bmnjGs4V+LVUMTk6yE5uq+DzzF3QUBJ+oAO4MGhT6ILtrrEQMh+/YXka5sgu8jQxmdBt100LCZqkGMoDzRe72pYQADxlZxoekIHd7xApcVJFn1+HyoFWXPudDCEuKVdzcKXlT2yuRvHu11BaOqRT3zvsPlM7KLxSZAwwDEmKX4J0jkoIJvCwc9JO3DzcDFzJMCI/p41OF67+X7/bCNw4YdFrAxK+DHnAs77Q7C0d6lFFpuaG5DRmd6dco3bLKa3cQvhJC9j2iKK4j1exIprPDarm64kAKAeUMnmimWCSgve2brJRVFYAYT5Cq81EVBWgSPYseVLIE9/u6ict5u2jXQXEp8ZGBbC6q+rrOp3yL7aONIlqWjXlr/L+OCAbbD//LHCLUqgI59cHlAreVU9NK7KtFe87XpIDj8s5XNnXJME4Gg/DMiaNDV8xwY/qABeh6XEJXxH50G9PQ9+Ty14ZGEd8bcjYBn1lreGtyETz1CqQln+iUWTibAvKGJJ8YqO6vHbNxuB1lEiIjeFPRMJvpOGheOsZ8jwMLlPEnV9bhlMPFGy7lXYXMv3co6DUyNiNW6s+J1h79XmtgyKdC/tD1ColL4L44FYe9uqr7esNTyH4f4S862ZnJ1OJpwUn3z35BbgKdxHIHYEII/CwvnLxT7jkmMdzR99a1VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(186003)(83380400001)(508600001)(6512007)(66446008)(66476007)(66556008)(71200400001)(8676002)(66946007)(64756008)(38100700002)(8936002)(76116006)(5660300002)(91956017)(122000001)(6486002)(6506007)(2906002)(36756003)(110136005)(316002)(38070700005)(86362001)(2616005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkU3NjBpT2VXdWwyU3FYNWNOcTJmQ2dsU2xYS2JBQ3lHR1JDK0VtYko3aXlX?=
 =?utf-8?B?SXFuYXlTZWJsNkFPY1JrTEdsR0JXamtYT0hmWDNuUG5reGVXTWFSM0NUbDlV?=
 =?utf-8?B?ZzI5QUIza21wRzIyK3ZXcnNtQkVwOHdXbHZYYkpHN0NrZnQxcWVLT3ZoeTR0?=
 =?utf-8?B?Qzl2VG55UEI5bTFzWmpURjcyYjljeldjYkxpWHh2eVFHbzFXcTJzTm9jZ2xI?=
 =?utf-8?B?MUZzK2FqWm85UGpXWHlyajNEaGs1L1R6WGQwR2ZEdnFva0lhdHNTVFVPdXo1?=
 =?utf-8?B?VDl6SGphT0ZTQXpTaXR5ZElmTzNZelgzdFBDZHEyMkU1ZVlkM3o2R1JydHM2?=
 =?utf-8?B?akZKQ0V0NWUzOUdLL0tXM2lsWmxOZnNsbFBaZStVeDBsQk92R1cxTUdDYmw2?=
 =?utf-8?B?TGZraGp3WlJOd2tSSUtETXlzSU1iMUVYVE1yN0RZZ0F5ZWlob05tVkEvN0R5?=
 =?utf-8?B?WENaZitzM3J1UzJ0S3h4QzFDMlp2TGRrcjViL3JwbjZpbWFNVDFxSDlkc3FP?=
 =?utf-8?B?Z3lyUjhGaVZFalBaSDYwZzFXaEZDeElQaVArWmlJdEV5YUxGQnFXczFnM2Js?=
 =?utf-8?B?Nmo1U25xY2lwZHJkNUJ0UmxwcmRqd3Y3a0NzTjJEeHZZTUdwWkdhODQ3Q0hW?=
 =?utf-8?B?NVBtSVUxZ3BYOXVQUVRqNjdiTS9GNHQzSS9qODZLMHhmODZIRmx3eFV6YWxa?=
 =?utf-8?B?NTUzQ1Z3MDE0OEdOVUlvODJMcERSczZOalFvZGszTzZuOW93TGw2WFFnekpj?=
 =?utf-8?B?MnVZK1lzZmNwSG1uMkpObHBSUC90bEt6UkdOVzBmS2g5aFZCbVltbWNLbklB?=
 =?utf-8?B?cDdSY0Zpb293MUZvQVI2TmpIMloxN2R2VTVHa2VnNldPNWJBUURacXI1TW54?=
 =?utf-8?B?UjNRYjZFeHdmR00vSFI3aGJkdkNnK01qM1dHaE02c21jWkZXMDR1Znh1RW5s?=
 =?utf-8?B?aU85S3IvS3ZDU285MTdmS2p1aVk3TGxEWENSODh2MFdiUy9nU2h5UWJMZ2Nw?=
 =?utf-8?B?b05zRHNjUzE1SDU3ZEtoU1ZiSW5QVC93VFY5a08wUlNKaDQySlBkS2FFWm95?=
 =?utf-8?B?S2RxSkxzS1cwcHl0Z0M4UGVMbHJyRmVaZWVtc04wRkVUcnk5by93QlUvekZ0?=
 =?utf-8?B?b2FSaVlxWGZTNVJ1M2JMYVVVbGNxQkRGMVdmNDFMWVhibVlzMkY4RGR1L3Nt?=
 =?utf-8?B?d252WTljYTZnQURjWFhtZFMxOStlOUtsbkUxSE5ZSW1rTm9OdnlMR0NOZXpx?=
 =?utf-8?B?YStmRzFwR2QzNm93enNFaVo1WFRwMjUvOTdhSE5yTWJVRFNYS2dqdW1aUVJJ?=
 =?utf-8?B?Rlh1RTNjeXlkUlZhYW5BMUh1SWFqSWZuZFNsa3RKU0Z0ZVB1eHBmK0orZGd4?=
 =?utf-8?B?dHZKMXRtbzlmUEZTVzBoODN0Uk5qUVYvTnY0M1NZQlM0QWF1RlBKUHZTNk95?=
 =?utf-8?B?RkdqelBRNXQ4YVc5VXRnTU8rQWV1dFB2Mk5rcjhyODZnZElPL1FFUTRwTmw2?=
 =?utf-8?B?K0VhSVBtNDZkbms1VHVUYjk0Z1Y0cVFkZ2dKbVJhcXptZTQ4R0Vyd3VWZnZ0?=
 =?utf-8?B?blkySjU4RHZBaHl3T051T0FYUnREZ2VlOWRiZkNiMFIrazcxNnpyUW9UZFpB?=
 =?utf-8?B?WjhBS000aFdsTS90VFA3ZXhLMEhxVVZlTGYwOW9uR0EwSUdwd295SWRLaE1S?=
 =?utf-8?B?V2NtaCsySUpBU2NrK09OTUxPSElmd1JuOGJyNkxvVFgyTlkzZ0FadElwL0ZC?=
 =?utf-8?B?elE0eHpzYi9qU0lzaW5xS3RsVlJabm95NklpZm9tUEJyQzNaVHBGQkJaejdt?=
 =?utf-8?B?MERxZ1IxdHF0N0puTm5LemR4Y2pLRjlkTGdKTTdTb2tKZGdNdUR2Mjg0cmJt?=
 =?utf-8?B?OERVb2pVb1RhRFd0Y29YclZWMUY0QnlXOUxONStzeUZPN3hLMmdadmxDTHFI?=
 =?utf-8?B?d1BVR2RpbXVpcEtMMk5Ray8yejRScTdXWEdjUGZGVXhmK01XM0NrNWo0MHQz?=
 =?utf-8?B?TEV3bGNyWnBuNkpoVGIyZGlOanJRMmsvcUhXSXl2Nm8vaWVyaWU4UVpLbXFP?=
 =?utf-8?B?WExhcnNIZEV4ODBaSE5Ea3lKK1JXL25vbXlVZ2N1Njg2RHFSZURoTmN4endm?=
 =?utf-8?B?VFNkVXJES0E3eFp5emo3VmNzNDRsL1RmbDAwbUhqVHFhY1BuWFR3QUZna1kw?=
 =?utf-8?B?MlZ4d01WSmd2SjRjVVdtU0tGcjIvbUdiT3ExSDQ1VXVNZDJSdmNYUDN3eWI5?=
 =?utf-8?B?aHVOeVRFbkxqVjAvdW13RlhsekNDRysweS9SRXBiSHV6K2pCcjA1cDRaWGlq?=
 =?utf-8?B?bTgrc0doYUp2YjVuWTF6amc2VGJFY1JMSE16am50MTRQSGtJT2t6S1JWeTRn?=
 =?utf-8?Q?Eo6t1KeShp2HbnkE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ACCF50F6BC9744E87FBDC28D65A3215@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d830b1-bbf9-4a66-00de-08da4e330a5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 18:23:55.0487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4R4JeMKp0jwvvrxWZV73ht9tq8x5vF5lFa90gg0DCM5zrt6xkeMXmD/zQEW9zuxE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2196
X-Proofpoint-GUID: _aK9npRBUk1FRuWPiKKYFCR0vv7Krpy_
X-Proofpoint-ORIG-GUID: _aK9npRBUk1FRuWPiKKYFCR0vv7Krpy_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_07,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTE0IGF0IDA5OjUxIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA2LzE0LzIyIDk6NDggQU0sIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiA+IE9uIDYvMTQvMjIg
MTY6MzAsIEplbnMgQXhib2Ugd3JvdGU6DQo+ID4gPiBPbiA2LzE0LzIyIDk6MjcgQU0sIFBhdmVs
IEJlZ3Vua292IHdyb3RlOg0KPiA+ID4gPiBBZGQgc29tZSB0ZXN0cyB0byBjaGVjayB0aGUga2Vy
bmVsIGVuZm9yY2luZyBzaW5nbGUtaXNzdWVyDQo+ID4gPiA+IHJpZ2h0LCBhbmQNCj4gPiA+ID4g
YWRkIGEgc2ltcGxlIHBvbGwgYmVuY2htYXJrLCBtaWdodCBiZSB1c2VmdWwgaWYgd2UgZG8gcG9s
bA0KPiA+ID4gPiBjaGFuZ2VzLg0KPiA+ID4gDQo+ID4gPiBTaG91bGQgd2UgYWRkIGEgYmVuY2ht
YXJrLyBvciBzb21ldGhpbmcgZGlyZWN0b3J5IHJhdGhlciB0aGFuIHVzZQ0KPiA+ID4gZXhhbXBs
ZXMvID8NCj4gPiA+IA0KPiA+ID4gSSBrbm93IER5bGFuIHdhcyBsb29raW5nIGF0IHRoYXQgYXQg
b25lIHBvaW50LiBJIGRvbid0IGZlZWwgdG9vDQo+ID4gPiBzdHJvbmdseSwgYXMgbG9uZyBhcyBp
dCBkb2Vzbid0IGdvIGludG8gdGVzdC8uDQo+ID4gDQo+ID4gSSBkb24ndCBjYXJlIG11Y2ggbXlz
ZWxmLCBJIGNhbiByZXNwaW4gaXQgb25jZSAoaWYpIHRoZSBrZXJuZWwNCj4gPiBzaWRlIGlzIHF1
ZXVlZC4NCj4gDQo+IEknbSBsZWFuaW5nIHRvd2FyZHMganVzdCB1c2luZyBleGFtcGxlcy8gLSBi
dXQgbWF5YmUgRHlsYW4gaGFkIHNvbWUNCj4gcmVhc29uaW5nIGZvciB0aGUgbmV3IGRpcmVjdG9y
eS4gQ0MnZWQuDQo+IA0KDQpJIHdhbnRlZCB0byBoYXZlIHNvbWUgY29tbW9uIGZyYW1ld29yayBm
b3IgYmVuY2htYXJrcyB0byBtYWtlIGl0IGVhc3kNCnRvIHdyaXRlIG5ldyBvbmVzIGFuZCBnZXQg
c29tZSBuaWNlIG51bWJlcnMuIEluIHRoYXQgY2FzZSBpdCB3b3VsZCBtYWtlDQpzZW5zZSBmb3Ig
dGhlbSB0byBiZSBpbiBvbmUgcGxhY2UuDQoNCkJ1dCBJIGhhdmVuJ3QgZmluaXNoZWQgaXQgeWV0
LCBzbyBwcm9iYWJseSBmb3Igbm93IGV4YW1wbGVzLyBpcyBiZXN0DQphbmQgaWYvd2hlbiBJIGZp
bmlzaCBpdCBJIGNhbiBwb3J0IHRoZXNlIG92ZXIuDQoNCg==
