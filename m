Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A455714AB
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiGLIcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 04:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiGLIcg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 04:32:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6666A43B8
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 01:32:23 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BNCL5K004093
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 01:32:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x34IgM57LRy2o++l0Bjupdht5cDrlG5AohQSE5R0HEk=;
 b=GMmCN+aolNNgq+Uoui3RYnrWQXku+6PKusUxPiLZhTQ3Sitq710A61iQWpl661DDEXfg
 RC2vyZpCe8VE8AyeCZuYuLJVslQFx8MaeMFWIAjQbaMUn0LfZNsI4GMKri2ebq1C5h4v
 u6+JnhCfKVAcIPugb/pAXsYEE45OTG00S0w= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h8w4na17m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 01:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGGSkphEJSafUX53lf7cdy1f23TbkwIEgOpPmDKCUvotmIG8WJessnE0gH6hIbA11ilWzC7kpNKq0IJcnVgb29Rm/U2t1yT0Hi0gEN2zqvJW3p6osL+0cZWsTzsFiYNus0AeDs95VMFkA386L4P/vsuKkAwCSS0iKam5eFTKvBMTl+BhtN7QSG4X+6RuWFSX8fkCRXYqplc2DUYUQUmew8L+rXpw/x+B5qIFOizpgZjNkwkH2HkR9HTp962pAee49bbgMfKCqsJSzIznoTVQ1jFR8G/JdxawwwRFSdU2gbI42dIeC8Ty6cjwfgIMwZdnVOkXFQJ+AeOm2I76qt/8Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x34IgM57LRy2o++l0Bjupdht5cDrlG5AohQSE5R0HEk=;
 b=D/kL1GIATZBlfnLNK0uFMBEiTIJoyqYWCohfZd3bOoRgb4UBhizVW0LjuSMSkX/YhwAx7LsFv7tejyIL8HainO5lSvxks3BERhGfXmDNVcUiZ/3AZur/pH378Tq23I5zDc1paifX/EuTs0FHGJsXD3KG+kphbFMybrfmdB6CldndN3IcTkWXwcP97k4dHuFZcL0XoqeRuulruSg5BmAoSQe9p8BZCVKHRsrwjnFkpGsPzmWsMX1wyIUHhI8uykTOXdlnoeU17X/8F8ZqAVMSxBQQA/Flk+w9KYo86Fc4H+4exQnIEK+ShkG3Skg9s7JZ6LyGsriOgkmV1Mex1P5uOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN6PR15MB1604.namprd15.prod.outlook.com (2603:10b6:404:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 08:32:18 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%5]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 08:32:18 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH for-next 0/4] io_uring: multishot recv cleanups
Thread-Topic: [PATCH for-next 0/4] io_uring: multishot recv cleanups
Thread-Index: AQHYkvcsxKQaaBnJ7Ei6UwX3/tbqlK15q1CAgADCi4A=
Date:   Tue, 12 Jul 2022 08:32:18 +0000
Message-ID: <387d08905f5fea373ea50925b2d7a2b1a06f1406.camel@fb.com>
References: <20220708181838.1495428-1-dylany@fb.com>
         <e973e70e-0802-0358-95da-8998cdd29281@kernel.dk>
In-Reply-To: <e973e70e-0802-0358-95da-8998cdd29281@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39440756-529f-4f7d-e116-08da63e1083d
x-ms-traffictypediagnostic: BN6PR15MB1604:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hEplVLL7M/ELJcmi8E9FuRfIm29HIcPD5jM3Yh0eZJRdvgfs3LygtvsE8h5MmDDgHfTW86/yXRzBP62J/Fz+SrSGQlQ+wYiQaK1kraioFdP4Fm5PC2/c/3+lfQvm88ktbMi2X3aWbjIhoDD4vYpl+Hk2U7epf6Wxg3f0s/oXtXUbR4BccjAOfNiTcaNk7tsSAwx6ZJIFLD7Xub0fYcwm9VErySdFf6zG/ztvU0V6NyGlSk0i9AcsRueyevUCDgz+uAFujwq5S80+TPVbFbc7Aklq4Moo4lctqceqbFYGfHyj3VPn+XHxLNimHVMnlFJfJ1b2YlGppseBGfgfvVKNBCOIJwwLFDg2S60BVoK3OYTwsfyheULyUghdl1gRtiN4V2fquBVUP4i5iKC/SnLYzbR1ecpVCYAx0rzOt2FlcACmOujwwckVRxcQjcDo2iZN562CEzbMrPD/lJEpwGxgvMzQCuywyz5emNOaKNvlpFxJa3+MP3ou9ymdxtDh6At1zSU1ZVFXkbrOYnvc1hJcY86BF1CR8XjrZAspNmx8eIUAHS0WA8wFW/8MthCU4LI3rjzE9P35db9VOq98glmbhkyY9GdIYZhOsC6jhwuNCGnAFngOsPRTBUsA2eMX5SNvzNUAu6SAER7CPzVNnL+aoTBx2o22Y98wB7evouV58rJ+BvzS6InGO6KGtBXLZbqo0Rq0lilznpbthDaHYzbIlQW31pl4+L0mk/pq8e2wgS+925+VxwLDy8cnPQAMZ5b0+VbPVyH2dihuNVTnnsGdI26DQWUxz3Dvq0AgglcD5baUMSgBJYCWiLKkL6FSMmps
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(186003)(66946007)(53546011)(6512007)(2616005)(66476007)(66556008)(6506007)(86362001)(38070700005)(122000001)(71200400001)(64756008)(38100700002)(110136005)(478600001)(6486002)(4744005)(316002)(66446008)(76116006)(5660300002)(8936002)(83380400001)(41300700001)(36756003)(4326008)(2906002)(8676002)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1hRZTN0cTRQOW1tTitUb2NaTmkzUEl0aUdDdzFDYlNtMHZWRkY4dnI1d1dC?=
 =?utf-8?B?aGkyWDRZRzNVU3FxQlZFamtvcXNqVU90MUZLV0wwVDZld3pzMExIbEp5N1A1?=
 =?utf-8?B?NkhON01ZNW5LSzFRMVFLK1ZzaEJvSHpZdWZGbXltenQ0b1dQRVRrU2tKaWla?=
 =?utf-8?B?Nlh1NWlhU2F5aHRIKzY0aFZyYm9KdkhJNTVxUmRMS2Q4WVJXMG9DWU1IeW5i?=
 =?utf-8?B?ZjZHcHMzZzYxbHVCVFczc28xaE5rL1NTOEVreklISndzeWoxelcxVHhJNTV0?=
 =?utf-8?B?NG1NUitYbVd0b1c3c2NFaTZoa2lsREZIdVA5MW8rRzVaNmZKeWxhbHlTWEJs?=
 =?utf-8?B?Q1BYVWZjYkJkSDZTWnpsbEMxbEpJK3A1WTB4T2REZHZxTE9OTFU3Vm1UQzZJ?=
 =?utf-8?B?YlYvcDFpd2VEdmZxNHFvNmlJQjk1dVgvYmNjNDh1VmVCQzNoaVpVOUZsemJu?=
 =?utf-8?B?YzJoNndYT2RRNmZuME1RZnhqWi9oeXdaVVdNK1kvRzAyOHRlNTlWZmVaclgv?=
 =?utf-8?B?RjBVazRBMi9UZHdralprdUgrdko4Qm9sbXpRYlBxbVJ1dGtPSHFsY0kvTUlp?=
 =?utf-8?B?RWpkSEQ1TDhBUjdOSElZMDVodkRMRG1hSFRFSVNBdi9mTXdMYSsyLzRkVG5U?=
 =?utf-8?B?V0hYYWN1RXVaVEcwWVAwYUpwK0tiZ1R5RGdCRTg4eWxJQnlrQWhhTmdQZ3dW?=
 =?utf-8?B?L3ZYbndzbTJJMGZJMkIwTGt1WmcyRjMxU3ZzN1hXTHdCRGRNazJ1WDFDQU5o?=
 =?utf-8?B?M1hZZjYrTFJSZVpjTy9wdWVXQm9BRFVMRzdoT2NOTmFaSGJtYnlhU1FRWndu?=
 =?utf-8?B?OUNNNTdud3I4ODYxMExKM2ZOQks2VndIRnRyd1BXRlJxcmYyUG5xMitCM0xm?=
 =?utf-8?B?eENiK2RnMk5lYjlibDdCMUFISjc5cWgzTHVjNm02WXYwZDhCaVMzN3JjNyta?=
 =?utf-8?B?MndUNmtZeUN2MmhkTXFuRjhOY09MSS9rTU55SU90YnRDQVVLUVBRcVNMNlRL?=
 =?utf-8?B?MTJnOTZYbG5qTG9HMDJtRzU3TnVhTEpQUXp5Q01kV0FtSUc3VVpiaW0yeGdX?=
 =?utf-8?B?SFdTY2duRUpaRlBPZzVkMmN2VWY3STc2ZmNsUXp5Q1duUWM0RjIrS25ib2sv?=
 =?utf-8?B?eGN6Z0MyWmpWQzR3MzZlRmlaTEkvZCtMTjFudXRHM0srZzVlTXdkVWlqU2JV?=
 =?utf-8?B?UUNLZXMwOEFGZVNaMTV5UlVSdmRXQm1xMTRsRXl6Z2RwYXd0ZTV6UE1PUFFF?=
 =?utf-8?B?YWtZNTJsSVZyK2pSUWdoMTBSTncwcUk2VHFrRktYa2xNWFRub1piYzBtZ0NF?=
 =?utf-8?B?emVvcG44NjRwdXVqUmgyN1NsNXUrZUxhZXJ4WnhxZE8yUTJQNGsrcmMvL0Uw?=
 =?utf-8?B?UUluQUZBalJ2UlF2dDVZUEo4MjVrN1E1TmJsWnRKY3djSXYrMUx6cTBQT1JW?=
 =?utf-8?B?cjcrNFpCQytQcjU1MDhJeEtFamMweGhrYllSdUxEa0lBQUdyTElZTUVsYk5U?=
 =?utf-8?B?TE5ZWm9tUkdsL1BVY2wwWm84U2MzRVd3NWJzZlRJcjJXUDFPeHZHSmNBZTFa?=
 =?utf-8?B?RXF0NWszallvcWRucStVMExub054dWFRZjR0VFNKK3JSbHZhR0ZxaldmK3Iw?=
 =?utf-8?B?K2pKUXFKUm1hdU4zK2VLV01CdnZEeVBWeFR6M1hGZWtQWXlmYzQvVG1ZSFZP?=
 =?utf-8?B?M0NXTkgzRWVCWW16VFRZNVV1WUkzemtZZ3YyTDJEM29DeS8zZHAwd3MxczJD?=
 =?utf-8?B?T01kZkhFTkVwWGVnMUExYzdpb0dubCsyNTZRSmoxeTlyK3BYKzhBVjc2aGdD?=
 =?utf-8?B?VzFTdldEUTF5UU93cGVpbXlpYXZhRUh0eUZXUUlsVWJMZ0ZiM3Vtdld0UnFN?=
 =?utf-8?B?aktVOHBqZE83aGZ3NlZzUkJXaGo1UlV3RkFHcWtiamcrTmk0TWMrNklRcjJu?=
 =?utf-8?B?M0hlUDQraHRDNmg3Y0psaDFrWk93aVYrQ3lLckN4SHlFamhHRjZOSUwrOGtG?=
 =?utf-8?B?NFU5WWtWTUxPUU5CNng3b3ZRdklRbWIrK0szZlFjbW5qd3V5KzQ3S2RTcDhE?=
 =?utf-8?B?MzNiTWtQUnVjVVhjTzVuZktkbTBFa0wyL3BuckY2bHEySnd3WElIcHRhQ1Qz?=
 =?utf-8?B?UGtDQ0ZmS3A1Q2JqNkNXbFNVOEc4d2RjT3JHK21QbG1OOGF5RmJvOUhRWGpi?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCDACBD10921E6438E64A21FC25A6DCF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39440756-529f-4f7d-e116-08da63e1083d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 08:32:18.2941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJXfhGjVjNUL6IWQL5Y5OVmElKdo5ZJQW+B3nMQ1r45q69ABU9NPK+dYxl2k94Km
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1604
X-Proofpoint-ORIG-GUID: Wd_0BwC9_X_mKPXye1tuI27bS1j3-rRy
X-Proofpoint-GUID: Wd_0BwC9_X_mKPXye1tuI27bS1j3-rRy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA3LTExIGF0IDE0OjU1IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA3LzgvMjIgMTI6MTggUE0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gVGhlc2UgYXJlIHNv
bWUgcHJlcGFyYXRvcnkgY2xlYW51cHMgdGhhdCBhcmUgc2VwYXJhdGUgYnV0IHJlcXVpcmVkDQo+
ID4gZm9yIGENCj4gPiBsYXRlciBzZXJpZXMgZG9pbmcgbXVsdGlzaG90IHJlY3Ztc2cgKHdpbGwg
cG9zdCB0aGlzIHNob3J0bHkpLg0KPiA+IA0KPiA+IFBhdGNoZXM6DQo+ID4gMTogZml4ZXMgYSBi
dWcgd2hlcmUgYSBzb2NrZXQgbWF5IHJlY2VpdmUgZGF0YSBiZWZvcmUgcG9sbGluZw0KPiA+IDI6
IG1ha2VzIGEgc2ltaWxhciBjaGFuZ2UgdG8gY29tcGF0IGxvZ2ljIGZvciBwcm92aWRpbmcgbm8g
aW92cw0KPiA+IGZvciBidWZmZXJfc2VsZWN0DQo+ID4gMy80OiBtb3ZlIHRoZSByZWN5Y2xpbmcg
bG9naWMgaW50byB0aGUgaW9fdXJpbmcgbWFpbiBmcmFtZXdvcmsNCj4gPiB3aGljaCBtYWtlcw0K
PiA+IGl0IGEgYml0IGVhc2llciBmb3IgcmVjdm1zZyBtdWx0aXNob3QNCj4gDQo+IEFwcGxpZWQg
MS0yLCBiZWNhdXNlIEkgZG9uJ3QgdGhpbmsgdGhlIGNsZWFudXAgaXMgbmVjZXNzYXJpbHkNCj4g
Y29ycmVjdC4gRG8NCj4gd2UgYWx3YXlzIGhvbGQgY3R4LT51cmluZ19sb2NrIGZvciBpb19jbGVh
bl9vcCgpPyBJIGNhbiBzZWUgdHdvIHdheXMNCj4gaW4gdGhlcmUgLSBvbmUgd2UgZGVmaW5pdGVs
eSBkbywgYnV0IGZyb20gdGhlIF9faW9fcmVxX2NvbXBsZXRlX3B1dCgpDQo+IG9yDQo+IGlvX2Zy
ZWVfcmVxKCkgcGF0aCB0aGF0IGRvZXNuJ3Qgc2VlbSB0byBiZSB0aGUgY2FzZS4gSG1tPw0KPiAN
Cg0KWW91J3JlIHJpZ2h0LiBTb3JyeSBhYm91dCB0aGF0IC0gaSB3aWxsIHNlbmQgb3V0IHYyIG9m
IHRoZSByZWN2bXNnDQpwYXRjaCBzZXJpZXMgd2l0aG91dCBpdC4NCg==
