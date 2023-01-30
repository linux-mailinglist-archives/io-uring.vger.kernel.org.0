Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC90680B27
	for <lists+io-uring@lfdr.de>; Mon, 30 Jan 2023 11:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbjA3Kp5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Jan 2023 05:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbjA3Kp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Jan 2023 05:45:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E48302BC
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 02:45:55 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30U48oBc021492
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 02:45:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=s2048-2021-q4;
 bh=S3dXXd/OvF3Tjx5+9yJn5NT2DU+mVPc8+SnjmSX1ipw=;
 b=F9cHpUAS4WP+askOc4l2pb4JX7jY5KQI5bvRP+HEmmO7BLf3sVqpSHaq5MlP03JYja24
 pOrlDLcGUNBeax5JmGC85T+Rjp/rYaRPGNgvm1A9gUGRZ0tI6BNv+hSTrBCODkkB62Sb
 n7/KYWe8+1D1fTxMlGmFyjpxt7HjF5C/5ZsGj1yP+jIHQct0cIz8QDPjd97skpQnTaHF
 ntlKevOOZu/1dtKwHewy/iR5qgs9KkSRDyEIGH8OXEIxLuWOQHtnfcOdQZ/bMBCSFqRn
 sO4hUjasGRbkKmUH6JYWLvn5B3eJl1LR2vvBgGAtr2ZEzhp1V2mktqyZlZ9LBakX7fVQ Qg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ndtfwkygv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 30 Jan 2023 02:45:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOvqdoWwJUN+yTk7gNlJBWiYnJzmccL/c5w+zUrF0NiTqztdZ5BZk/x6hHelLZ1Mcl9VRxhXOm9axF/qIznU6u3CZugXp2ehKQ9bmeVANu4ZWgNZ46k67/F40T6ZRc19BLmehxu7KlrqOrHSUgWQltIr6TZPvBQUVQrhZ0faRfuYxK330cWA1JWKYXzqtLG+55OrmjnrAFK8Q2woJK+++st8ExRQ9JpRcHSpOOGnVcvLSXZ2eg8v8dZlH9Xk6sYRxJCnHwBqsn8wqduE5GWyoWh53fb8V9tKH6FheWujwBb3sd/gV/s8FhyNP7TQrkhe3uVNQ7penbIM3Blp2MOeVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3dXXd/OvF3Tjx5+9yJn5NT2DU+mVPc8+SnjmSX1ipw=;
 b=mDJ5Z6AdJmBIhJTnhecvDBxgpQM9AMBIr1ErbuwtCdBKiSNZIh/G1csoehlrOtRqzDypQhDhQg5Jt0CNTIeqJwTlj4FoWuMjlIKM3oMP7UXiZlprYo9ymHQObxEBcR7UJR1LjGvhYs77/VebxPI6TqZnChzpezAbwnyGqU8icdMGSKcfxhW5f5to6NaxNJnTGZNCjbKM3VCkLIWP03CNS2WMO2S77yse3rHwc5S/ebTh9IqkDvADBMaTLzQ2g0GMPpTx4uhuvGKHhrFPKALGDEx5N2uiDyDj84pmXGe2qH2xDqyo9tsUz2xcXw9vCe67UNQjWw/wdBsLr2beNmqI1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW3PR15MB3900.namprd15.prod.outlook.com (2603:10b6:303:4f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 10:45:50 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::fb33:6145:8feb:8054]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::fb33:6145:8feb:8054%7]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 10:45:50 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <kernel-team@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 1/4] io_uring: if a linked request has
 REQ_F_FORCE_ASYNC then run it async
Thread-Topic: [PATCH for-next 1/4] io_uring: if a linked request has
 REQ_F_FORCE_ASYNC then run it async
Thread-Index: AQHZMlajOtotEM9ROkaqVWfUTcX3lq62BYYAgAAFdgCAAMBegA==
Date:   Mon, 30 Jan 2023 10:45:50 +0000
Message-ID: <e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8ec.camel@meta.com>
References: <20230127135227.3646353-1-dylany@meta.com>
         <20230127135227.3646353-2-dylany@meta.com>
         <297ad988-9537-c953-d49a-8b891204b0f0@kernel.dk>
         <aa6c75e2-5c39-713a-e5c2-8a50a4687b11@kernel.dk>
In-Reply-To: <aa6c75e2-5c39-713a-e5c2-8a50a4687b11@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|MW3PR15MB3900:EE_
x-ms-office365-filtering-correlation-id: 31e954c5-0fdd-485d-b566-08db02af2761
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HeXY0OvGUgkrVvmA71IfM62nu9Gbh7+dinDw3jzUj4pk1xkRx9sO6aLjfmIoYK7FFpBIK2jwmx2u2TpXwI6kFNsZM0tuik+pp38c1tA50kE98N2tvYtrAoCTYO4oyxIbndbgPU23elUWAqFg38wzdVlmyv7ZeO8HhWFIOSj8KUCYVhPJgP12KZ14kR6Ti8YIwd/8ba0B57oU+tgRXtyUCrV5tdsFAOXLDrePo4S/0HHUEbOc0zJlFiY1TwKHJ91ENLZ4BrZe+YXhjSD7omonVuWT3W9YjtJoILkhPLVlR5zGMAcMOuq/Qh1ZXU5i1s31EvBOAZL87jQvGXSWumdO6ek03HXBhRXJbJka3qKvdoB1GjPGDqEIMQMjTOTBlwYQYLIpUGIfidDjzX/1gHVAywicr8L/1uYleoivzPv/mQntxWzJNuJE9uNFuJk8TYSxhshzLAWlBsJogInDMKDjswPEWxOv3UCsBN7jfiaFqNvcbnlJQtpI77KbYWJTuAqOLuBoBszdD+GGkNHypcN+BeN/efnYm5MdYpTcT1SuczFpnEmFJJ+4dArwHvyFtW8huyhrPPQHofz3F9c1IMqBFFeoMA326F5ShNV9mcgHUzoCBeJAAUVM//uWQwCAqmXBtnfzFqJdDXv5aurlNVrGwdzq4an/VbabOBAVgNouTG3JJ72coeYiuFzYzorYUUatmHREYqivqjX+9geh9rGMxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199018)(2906002)(99936003)(6512007)(186003)(478600001)(6486002)(316002)(54906003)(110136005)(38070700005)(36756003)(86362001)(122000001)(38100700002)(41300700001)(8936002)(76116006)(2616005)(4326008)(66446008)(66556008)(66476007)(64756008)(91956017)(66946007)(8676002)(53546011)(6506007)(71200400001)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTZkeFUxekpFZE5NYUxiMEI3ZVc0ZHlqTHlDZG9sRVFZSklKQ3hPQndFQ1hP?=
 =?utf-8?B?WTc4VVYzWEt1bm0vRldKczNVMFJhY3ZmbEgwY3lMKytYcWJLbnplRStPVFkz?=
 =?utf-8?B?TjQycW9Bem8ycHFqd3B1YlF1TjFldkJvemRhNHNKeUEySUtmc2Y4UTEwZGcr?=
 =?utf-8?B?SnlzRXY2TlQ2RzNpazQxVC83SnQvdXF2YmxWc2w0emxhYVF5a3dJWGFiVFpY?=
 =?utf-8?B?K2I4WTZOWTFRZ2NGS0tPckE5ZGdiOUx4YWUwMFRxalZmbWJBOHB4WnA4OTEx?=
 =?utf-8?B?NjRSbEU5Ukh1UE5yanJnZU1rWW4rWG1WalZDVmNjWEtOWDBjNEVkMUNhRElJ?=
 =?utf-8?B?NTNmT3kvWDJOQzBzMnFoZm5SV3UxN1BpY0xkc1g5V0JUMnlSam1Fb1MwVWhL?=
 =?utf-8?B?Y0FUbFQ2SVR0eTZJMUppQWwzNEhvWUY5T1BadEhiRXBrQmtmQy9KcUJlNGs1?=
 =?utf-8?B?N1k2eUxBYm5rUDBIYzZhZlhqQ3ZDSVJJSTlabVJIY3NwcXhjYUZMbjk4OElv?=
 =?utf-8?B?c0dWYXIwQ1VvQ0QwUU84RGI3NzRiVmEyY09ZOTdFVm9BbXB3N09ZeEY5Yyt5?=
 =?utf-8?B?T0RIeVdEdkozUGZFSWEvd0NlSzd4eDB3Y3dGTXRWRVdCYkFEYThUMFdhNm5T?=
 =?utf-8?B?Tmsxc24zeDBEaUI2SnJoa0wrNHRyVHJRMCt5cTFmQjRpOW1qVDY5UmZRaldx?=
 =?utf-8?B?NXZibHRhU1hoVVhGdVh3OWVoZ201TzlKOU90SXI1aG1XVmFsRWVwTUhNRWlN?=
 =?utf-8?B?SUlsYVZvbGJHdW9YTG5ZSHBKQmMrWHdTVGduVmpJU0hHTlFCOVpwRURNSXBQ?=
 =?utf-8?B?K0ZSMXJocXVZbWtNeDF5ZUFwNDc2RnNTZUJjMktyR1dHSHk4aVExYnYveTdq?=
 =?utf-8?B?YnRjMUZJTG8wRUlnS1FlNXVWWkkyMlFnWlFJWm9HVEhDOWhzQU10SFVHMldG?=
 =?utf-8?B?Nzc3V2t5cDMyWExTTmVNZ3J2VGdnUVBFTXBZOWd2cmNhSVlIWE1sOHJVai8w?=
 =?utf-8?B?TTQyb2xickRlcFV5dytCR2hZK0JRWlR2Vy83bERuYXlTeXlOTzhobGo1ZGZD?=
 =?utf-8?B?ZWRQVVNyVXk1WmwydlloeWpobW1lS09NMlVPSWtQNmxuWlU5TzBSblBWczR1?=
 =?utf-8?B?MzEzM2s1RnY2SG9WaXFrT2J0dUE4TmdCMGNsdndsZHR5RWh4TVIyckpvSExL?=
 =?utf-8?B?NnRKK296S0lIaWtFVml1K055NUE3TlB2d0N0NmNBaDZlNGNSZUdlMDdmaDhZ?=
 =?utf-8?B?RHg3WUVKVFNrMXcyMHRlMDhHMGt5OWlGblpoblNBbkZsQzNSNm52bzlOQTA0?=
 =?utf-8?B?UE1LeGE0M1BvMUJBR0tHQmdBeDg2aktwU01rNlVHblE2T0VKSmNydU0zMkor?=
 =?utf-8?B?dE4zRVFuNG8za3czV0FQdDRxUElvbWtvbk9leWtCWGE0dFJnVTJJQUNlOGFK?=
 =?utf-8?B?dVd2b1B0Wk91N25OVnJpVUxSYzhjQXAzVGQzUDF3c05GbWNTZ2xwd1ZSOE8z?=
 =?utf-8?B?WTZ3MTB0UktVL2JoM0E3VG5mMDUybHpmNkk2VmNSbG9QUWZWTUpmT3R6dkJ1?=
 =?utf-8?B?ZXMwMFhXS3RGd3BMNEl0UUpUbVFvVGsyZmNyR3NTdk1DSXhsRnROZkpCS0Iy?=
 =?utf-8?B?amxPYkJ4MWpBbEJRcE4xOHFPbWNlbVZXWlV0VkFValJ5YVJ1YlBpT1NVMVlU?=
 =?utf-8?B?NkFRNStGVVk2K2NRbklvQVJPOVhDSzB1aktXcVpWV0JzRXI1RVYrYjZ2TTJM?=
 =?utf-8?B?Y2hMNHF0TTBEUFRuMW05VjY5L0MyRlZOOFBzTG5PczdSQzkyakxrMHFaZHN0?=
 =?utf-8?B?WXN2NzFueitVSGV6L0NCTmlZSG9lSmhSTmlKaDBLRk1JN0pQZ1dkNGxtSFM4?=
 =?utf-8?B?YlVaR29mUkVtTUsrTFNTcW4zMjBQK3hxZk5JTzFaNlljUjN1ZW5kY1FVeml2?=
 =?utf-8?B?L3EvNytFZ21IUVZyY2tTVmpJZnZYVDhhTzNHZ2dILzUyV2xjL3cwL0NDMC9X?=
 =?utf-8?B?NVgrelNEMExCL0lmQkNsU1pMMVB3L0Zia3pzOU1wbm9QMnZDUjRlaVJ2SE1z?=
 =?utf-8?B?cUs5ZURKa1g4SFU0S2pLaHd5TUlmdUc0NkwwYzVoZ293NVEyTitqcFl3SWdp?=
 =?utf-8?B?T1VSdlFzdVYvS2drN1p6ZXlia3ljdjkyai9IUUt4UHhsTjE5Z1Z0OXBidnQ4?=
 =?utf-8?Q?jNZ6Rr3oBtZX4JS1mfqQ9UU=3D?=
Content-Type: multipart/mixed;
        boundary="_002_e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8eccamelmetacom_"
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e954c5-0fdd-485d-b566-08db02af2761
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 10:45:50.5991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nWbQcdwPer9R6DaGdJWueM6pRIjMx46BcrjAUdSaIPPCKrSQ9OSaqUnIwrIS4MJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3900
X-Proofpoint-ORIG-GUID: VXnZKa2dYe-qYBQon6rcVUEjUSKHjTBm
X-Proofpoint-GUID: VXnZKa2dYe-qYBQon6rcVUEjUSKHjTBm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_10,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--_002_e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8eccamelmetacom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <9371149964574C4BB506BF753CB5AAAE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gU3VuLCAyMDIzLTAxLTI5IGF0IDE2OjE3IC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxLzI5LzIzIDM6NTfigK9QTSwgSmVucyBBeGJvZSB3cm90ZToNCj4gPiBPbiAxLzI3LzIzIDY6
NTI/QU0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gPiBSRVFfRl9GT1JDRV9BU1lOQyB3YXMg
YmVpbmcgaWdub3JlZCBmb3IgcmUtcXVldWVpbmcgbGlua2VkDQo+ID4gPiByZXF1ZXN0cy4gSW5z
dGVhZCBvYmV5IHRoYXQgZmxhZy4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogRHlsYW4g
WXVkYWtlbiA8ZHlsYW55QG1ldGEuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiDCoGlvX3VyaW5nL2lv
X3VyaW5nLmMgfCA4ICsrKysrLS0tDQo+ID4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9pb191cmlu
Zy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYw0KPiA+ID4gaW5kZXggZGI2MjNiMzE4
NWM4Li45ODBiYTRmZGExMDEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pb191cmluZy9pb191cmluZy5j
DQo+ID4gPiArKysgYi9pb191cmluZy9pb191cmluZy5jDQo+ID4gPiBAQCAtMTM2NSwxMCArMTM2
NSwxMiBAQCB2b2lkIGlvX3JlcV90YXNrX3N1Ym1pdChzdHJ1Y3QgaW9fa2lvY2INCj4gPiA+ICpy
ZXEsIGJvb2wgKmxvY2tlZCkNCj4gPiA+IMKgew0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlvX3R3
X2xvY2socmVxLT5jdHgsIGxvY2tlZCk7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgLyogcmVxLT50
YXNrID09IGN1cnJlbnQgaGVyZSwgY2hlY2tpbmcgUEZfRVhJVElORyBpcyBzYWZlDQo+ID4gPiAq
Lw0KPiA+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKGxpa2VseSghKHJlcS0+dGFzay0+ZmxhZ3MgJiBQ
Rl9FWElUSU5HKSkpDQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW9fcXVl
dWVfc3FlKHJlcSk7DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqBlbHNlDQo+ID4gPiArwqDCoMKgwqDC
oMKgwqBpZiAodW5saWtlbHkocmVxLT50YXNrLT5mbGFncyAmIFBGX0VYSVRJTkcpKQ0KPiA+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpb19yZXFfZGVmZXJfZmFpbGVkKHJlcSwg
LUVGQVVMVCk7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqBlbHNlIGlmIChyZXEtPmZsYWdzICYgUkVR
X0ZfRk9SQ0VfQVNZTkMpDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW9f
cXVldWVfaW93cShyZXEsIGxvY2tlZCk7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqBlbHNlDQo+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW9fcXVldWVfc3FlKHJlcSk7DQo+ID4g
PiDCoH0NCj4gPiA+IMKgDQo+ID4gPiDCoHZvaWQgaW9fcmVxX3Rhc2tfcXVldWVfZmFpbChzdHJ1
Y3QgaW9fa2lvY2IgKnJlcSwgaW50IHJldCkNCj4gPiANCj4gPiBUaGlzIG9uZSBjYXVzZXMgYSBm
YWlsdXJlIGZvciBtZSB3aXRoIHRlc3QvbXVsdGljcWVzX2RyYWluLnQsIHdoaWNoDQo+ID4gZG9l
c24ndCBxdWl0ZSBtYWtlIHNlbnNlIHRvIG1lIChqdXN0IHlldCksIGJ1dCBpdCBpcyBhIHJlbGlh
YmxlDQo+ID4gdGltZW91dC4NCj4gDQo+IE9LLCBxdWljayBsb29rIGFuZCBJIHRoaW5rIHRoaXMg
aXMgYSBiYWQgYXNzdW1wdGlvbiBpbiB0aGUgdGVzdCBjYXNlLg0KPiBJdCdzIGFzc3VtaW5nIHRo
YXQgYSBQT0xMX0FERCBhbHJlYWR5IHN1Y2NlZWRlZCwgYW5kIGhlbmNlIHRoYXQgYQ0KPiBzdWJz
ZXF1ZW50IFBPTExfUkVNT1ZFIHdpbGwgc3VjY2VlZC4gQnV0IG5vdyBpdCdzIGdldHRpbmcgRU5P
RU5UIGFzDQo+IHdlIGNhbid0IGZpbmQgaXQganVzdCB5ZXQsIHdoaWNoIG1lYW5zIHRoZSBjYW5j
ZWxhdGlvbiBpdHNlbGYgaXNuJ3QNCj4gYmVpbmcgZG9uZS4gU28gd2UganVzdCBlbmQgdXAgd2Fp
dGluZyBmb3Igc29tZXRoaW5nIHRoYXQgZG9lc24ndA0KPiBoYXBwZW4uDQo+IA0KPiBPciBjb3Vs
ZCBiZSBhbiBpbnRlcm5hbCByYWNlIHdpdGggbG9va3VwL2lzc3VlLiBJbiBhbnkgY2FzZSwgaXQn
cw0KPiBkZWZpbml0ZWx5IGJlaW5nIGV4cG9zZWQgYnkgdGhpcyBwYXRjaC4NCj4gDQoNClRoYXQg
aXMgYSBiaXQgb2YgYW4gdW5wbGVhc2FzbnQgdGVzdC4NCkVzc2VudGlhbGx5IGl0IHRyaWdnZXJz
IGEgcGlwZSwgYW5kIHJlYWRzIGZyb20gdGhlIHBpcGUgaW1tZWRpYXRlbHkNCmFmdGVyLiBUaGUg
dGVzdCBleHBlY3RzIHRvIHNlZSBhIENRRSBmb3IgdGhhdCB0cmlnZ2VyLCBob3dldmVyIGlmDQph
bnl0aGluZyByYW4gYXN5bmNocm9ub3VzbHkgdGhlbiB0aGVyZSBpcyBhIHJhY2UgYmV0d2VlbiB0
aGUgcmVhZCBhbmQNCnRoZSBwb2xsIGxvZ2ljIHJ1bm5pbmcuDQoNClRoZSBhdHRhY2hlZCBwYXRj
aCBmaXhlcyB0aGUgdGVzdCwgYnV0IHRoZSByZWFzb24gbXkgcGF0Y2hlcyB0cmlnZ2VyIGl0DQpp
cyBhIGJpdCB3ZWlyZC4NCg0KVGhpcyBvY2N1cnMgb24gdGhlIHNlY29uZCBsb29wIG9mIHRoZSB0
ZXN0LCBhZnRlciB0aGUgaW5pdGlhbCBkcmFpbi4NCkVzc2VudGlhbGx5IGN0eC0+ZHJhaW5fYWN0
aXZlIGlzIHN0aWxsIHRydWUgd2hlbiB0aGUgc2Vjb25kIHNldCBvZg0KcG9sbHMgYXJlIGFkZGVk
LCBzaW5jZSBkcmFpbl9hY3RpdmUgaXMgb25seSBjbGVhcmVkIGluc2lkZSB0aGUgbmV4dA0KaW9f
ZHJhaW5fcmVxLiBTbyB0aGVuIHRoZSBmaXJzdCBwb2xsIHdpbGwgaGF2ZSBSRVFfRl9GT1JDRV9B
U1lOQyBzZXQuDQoNClByZXZpb3VzbHkgdGhvc2UgRk9SQ0VfQVNZTkMncyB3ZXJlIGJlaW5nIGln
bm9yZWQsIGJ1dCBub3cgd2l0aA0KImlvX3VyaW5nOiBpZiBhIGxpbmtlZCByZXF1ZXN0IGhhcyBS
RVFfRl9GT1JDRV9BU1lOQyB0aGVuIHJ1biBpdCBhc3luYyINCnRoZXkgZ2V0IHNlbnQgdG8gdGhl
IHdvcmsgdGhyZWFkLCB3aGljaCBjYXVzZXMgdGhlIHJhY2UuIA0KDQpJIHdvbmRlciBpZiBkcmFp
bl9hY3RpdmUgc2hvdWxkIGFjdHVhbGx5IGJlIGNsZWFyZWQgZWFybGllcj8gcGVyaGFwcw0KYmVm
b3JlIHNldHRpbmcgdGhlIFJFUV9GX0ZPUkNFX0FTWU5DIGZsYWc/DQpUaGUgZHJhaW4gbG9naWMg
aXMgcHJldHR5IGNvbXBsZXggdGhvdWdoLCBzbyBJIGFtIG5vdCB0ZXJyaWJseSBrZWVuIHRvDQpz
dGFydCBjaGFuZ2luZyBpdCBpZiBpdCdzIG5vdCBnZW5lcmFsbHkgdXNlZnVsLg0KDQoNCg==

--_002_e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8eccamelmetacom_
Content-Type: text/x-patch; name="patch.diff"
Content-Description: patch.diff
Content-Disposition: attachment; filename="patch.diff"; size=1863;
	creation-date="Mon, 30 Jan 2023 10:45:50 GMT";
	modification-date="Mon, 30 Jan 2023 10:45:50 GMT"
Content-ID: <47FDF1B3FBBFB540830855F7B9ECB7A6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64

Y29tbWl0IGQzNjJmYjIzMTMxMGE1MmE3OWM4YjlmNzIxNjVhNzA4YmZkOGFhNDQKQXV0aG9yOiBE
eWxhbiBZdWRha2VuIDxkeWxhbnlAbWV0YS5jb20+CkRhdGU6ICAgTW9uIEphbiAzMCAwMTo0OTo1
NyAyMDIzIC0wODAwCgogICAgbXVsdGljcWVzX2RyYWluOiBtYWtlIHRyaWdnZXIgZXZlbnQgd2Fp
dCBiZWZvcmUgcmVhZGluZwogICAgCiAgICB0cmlnZ2VyX2V2ZW50IGlzIHVzZWQgdG8gZ2VuZXJh
dGUgQ1FFcyBvbiB0aGUgcG9sbCByZXF1ZXN0cy4gSG93ZXZlciB0aGVyZQogICAgaXMgYSByYWNl
IGlmIHRoYXQgcG9sbCByZXF1ZXN0IGlzIHJ1bm5pbmcgYXN5bmNocm9ub3VzbHksIHdoZXJlIHRo
ZQogICAgcmVhZF9waXBlIHdpbGwgY29tcGxldGUgYmVmb3JlIHRoZSBwb2xsIGlzIHJ1biwgYW5k
IHRoZSBwb2xsIHJlc3VsdCB3aWxsCiAgICBiZSB0aGF0IHRoZXJlIGlzIG5vIGRhdGEgcmVhZHku
CiAgICAKICAgIEluc3RlYWQgc2xlZXAgYW5kIGZvcmNlIGFuIGlvX3VyaW5nX2dldF9ldmVudHMg
aW4gb3JkZXIgdG8gZ2l2ZSB0aGUgcG9sbCBhCiAgICBjaGFuY2UgdG8gcnVuIGJlZm9yZSByZWFk
aW5nIGZyb20gdGhlIHBpcGUuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IER5bGFuIFl1ZGFrZW4g
PGR5bGFueUBtZXRhLmNvbT4KCmRpZmYgLS1naXQgYS90ZXN0L211bHRpY3Flc19kcmFpbi5jIGIv
dGVzdC9tdWx0aWNxZXNfZHJhaW4uYwppbmRleCAzNzU1YmVlYzQyYzcuLjZjNGQ1ZjJiYTg4NyAx
MDA2NDQKLS0tIGEvdGVzdC9tdWx0aWNxZXNfZHJhaW4uYworKysgYi90ZXN0L211bHRpY3Flc19k
cmFpbi5jCkBAIC03MSwxMyArNzEsMTUgQEAgc3RhdGljIHZvaWQgcmVhZF9waXBlKGludCBwaXBl
KQogCQlwZXJyb3IoInJlYWQiKTsKIH0KIAotc3RhdGljIGludCB0cmlnZ2VyX2V2ZW50KGludCBw
W10pCitzdGF0aWMgaW50IHRyaWdnZXJfZXZlbnQoc3RydWN0IGlvX3VyaW5nICpyaW5nLCBpbnQg
cFtdKQogewogCWludCByZXQ7CiAJaWYgKChyZXQgPSB3cml0ZV9waXBlKHBbMV0sICJmb28iKSkg
IT0gMykgewogCQlmcHJpbnRmKHN0ZGVyciwgImJhZCB3cml0ZSByZXR1cm4gJWRcbiIsIHJldCk7
CiAJCXJldHVybiAxOwogCX0KKwl1c2xlZXAoMTAwMCk7CisJaW9fdXJpbmdfZ2V0X2V2ZW50cyhy
aW5nKTsKIAlyZWFkX3BpcGUocFswXSk7CiAJcmV0dXJuIDA7CiB9CkBAIC0yMzYsMTAgKzIzOCw4
IEBAIHN0YXRpYyBpbnQgdGVzdF9nZW5lcmljX2RyYWluKHN0cnVjdCBpb191cmluZyAqcmluZykK
IAkJaWYgKHNpW2ldLm9wICE9IG11bHRpICYmIHNpW2ldLm9wICE9IHNpbmdsZSkKIAkJCWNvbnRp
bnVlOwogCi0JCWlmICh0cmlnZ2VyX2V2ZW50KHBpcGVzW2ldKSkKKwkJaWYgKHRyaWdnZXJfZXZl
bnQocmluZywgcGlwZXNbaV0pKQogCQkJZ290byBlcnI7Ci0KLQkJaW9fdXJpbmdfZ2V0X2V2ZW50
cyhyaW5nKTsKIAl9CiAJc2xlZXAoMSk7CiAJaSA9IDA7CkBAIC0zMTcsMTMgKzMxNywxMSBAQCBz
dGF0aWMgaW50IHRlc3Rfc2ltcGxlX2RyYWluKHN0cnVjdCBpb191cmluZyAqcmluZykKIAl9CiAK
IAlmb3IgKGkgPSAwOyBpIDwgMjsgaSsrKSB7Ci0JCWlmICh0cmlnZ2VyX2V2ZW50KHBpcGUxKSkK
KwkJaWYgKHRyaWdnZXJfZXZlbnQocmluZywgcGlwZTEpKQogCQkJZ290byBlcnI7Ci0JCWlvX3Vy
aW5nX2dldF9ldmVudHMocmluZyk7CiAJfQotCWlmICh0cmlnZ2VyX2V2ZW50KHBpcGUyKSkKLQkJ
CWdvdG8gZXJyOwotCWlvX3VyaW5nX2dldF9ldmVudHMocmluZyk7CisJaWYgKHRyaWdnZXJfZXZl
bnQocmluZywgcGlwZTIpKQorCQlnb3RvIGVycjsKIAogCWZvciAoaSA9IDA7IGkgPCAyOyBpKysp
IHsKIAkJc3FlW2ldID0gaW9fdXJpbmdfZ2V0X3NxZShyaW5nKTsK

--_002_e12d8f56e8ee14b70f6f5e7b1f08ce5baf06f8eccamelmetacom_--
