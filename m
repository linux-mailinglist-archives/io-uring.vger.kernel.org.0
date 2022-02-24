Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175784C29D2
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 11:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiBXKqH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 05:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiBXKqG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 05:46:06 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB5928F46C
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:45:37 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21O7h1va031826
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:45:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JBSBkcwC5sMbsJV3ocXPciihFp16eObFYJYdwPBXdSs=;
 b=H3j8DmWSccikbyP4n/Smz4lBvs6+pWcIf7OzbZifkOm0dCY1AyIpPY9akv8mx9pzw0Vc
 hSugfel4t/jzT8let35lada5Pe8KcY4MO3CgO2MvICpWUJHaUT1KDnc5MQc5j6E2Ow98
 igvu2SsaRB69lDU7xFSTAxRiAv0t1U4LnUk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ee5v5grdh-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 02:45:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 02:45:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYsytmUfS3R8XlhvDL4T2IxkIhMFhfX2IJhgCbIsJOWjyZgptLLfHk8oadJZgYSrsp60N936/58X7+5yhlwDmSr1pleitJ8mtk1xL2B7hRwMEqHzoQxgFjrMasyHD8vDq2VVDLkjp5frDAIGG++lLDx+Bq1FlASgTsC3HwI9EDpv/p5ecIjIMQJXly4Kx4NLxDtsJ20FxhqIA3SMHIJU5vX/oMFKegQkCTIJaiJpLZc8NnR6O60o42QEo7jJsWrpjRZtcw93iaccyT9S54BPsaUp+QEjMaJtJjsQw2wGMPQI7FFya3Mvzxlwi1q/0qWLKPQP6Hr6a2Ye0K3QllMPhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBSBkcwC5sMbsJV3ocXPciihFp16eObFYJYdwPBXdSs=;
 b=Z+SgLPl5nFKIJ5N3p9u+j7gk+/PyKvbmPSX2/TqwqwvorF9vX9D1oxy25OWS7WJrpGIxP/20VtypG+ghxGeifZRvjURh9pSvRvLQvdn2gQPe688IcmpBAUBAhNAWyI2mL0YlhuE6MQRBg8J3xBKp9zTB3W8hXXIHfSSIGJIx0WRF+Men4OZyDjy+wUJCo/DEDXKB3eND7khuSzieIpgUFSS7mB28BJVDSoFDz4gO8sq5FHvHMoRQaKC2OsZ5KGmtKEN+UrMSux7Ru7jCuB7WgevRGGUIOM6y6SSM6uIPiJv2Q1D66Prg5h5x2XT/CqPl+eteR7ihXtJH8YKFBMONqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MN2PR15MB3598.namprd15.prod.outlook.com (2603:10b6:208:181::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 24 Feb
 2022 10:45:32 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595%3]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 10:45:32 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 0/4] io_uring: consistent behaviour with linked
 read/write
Thread-Topic: [PATCH v3 0/4] io_uring: consistent behaviour with linked
 read/write
Thread-Index: AQHYJ9qwgGBsX0kKO0qNeurv4g0rPayh0MSAgAC20QA=
Date:   Thu, 24 Feb 2022 10:45:32 +0000
Message-ID: <8fc451a0225ef78a1bd6322f121843fb98523809.camel@fb.com>
References: <20220222105504.3331010-1-dylany@fb.com>
         <568473ab-8cf7-8488-8252-e8a2c0ec586f@kernel.dk>
In-Reply-To: <568473ab-8cf7-8488-8252-e8a2c0ec586f@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dae5771a-56fd-4e75-5129-08d9f782c859
x-ms-traffictypediagnostic: MN2PR15MB3598:EE_
x-microsoft-antispam-prvs: <MN2PR15MB3598E8C8F57863E43BF7B8C8B63D9@MN2PR15MB3598.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L4CuQgcDQIz44/+0cc0CA4HOiSKlSmLA453AShcp97gBt2FVxn2w88NUd86YQOVqTcLEVbXOqJkTfY5KLfQEDLddZ2jhD3jxIcdgCDt1MFWTPxnJmudO17wjCz3fUjhywozsTvXzGF8NTzOL0h4Y/vYnk8WuNcZ9EtnDEYSMonnVn1zZefrCAbl1HUSfMkhejpoXDqHIwoRMvrTnWldietjLRqKt5xE8rrvN8/j6wWROvVFiR+DQ7pFFtRTdHz+Blgu31Pa3yPxUKlrwwJSCvbX/sILkO1dX9eyzfv5sIpdbl1RgEadDKwn1TgLtwG+mZjkKvK/I+jvNzOW6oAn44aSJNTdvISxTgEx663ym9+O2VY6ZP4FrtKDmKflYJV7Xo2H0DOsY2Lpra/BbAQbuko4mc/HYLOSdsnF4zkxr9i7TvRTH0O87NSU5nbaj6C2oR4amesC5e6GbUv3gMawkZNz6jfWgdaJnRJ/RYaxOtrOI16xvyDbnlomIau6Ukv0NhemAc+YjgdAv4r5JYGFwXeJMqOgeDD5bDAYeT7ru0KBkmDo+sKiEzmAB+sCGc2rYX0mQGCESIkj1iiE+OZroja2sfqZeKsjY5jIqYbaMKSbO548k/qJXwDR0TlWTqnkE8VFdbLaycyuSmntMLJtNxLHHy3sCqf4g98HPCBy56LjRmdEDHnDfMjEOY1JTD6uw6xISmmnFdHnesiHK3g523g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(316002)(38100700002)(4326008)(122000001)(2616005)(91956017)(110136005)(64756008)(8936002)(76116006)(2906002)(8676002)(6486002)(6512007)(6506007)(508600001)(86362001)(36756003)(26005)(38070700005)(66556008)(186003)(53546011)(66476007)(66946007)(66446008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm9GUXVBM0MvTVZsL0I3aEgvRmt0aTJlaFVyajBkTW5kSHVIMlFpeS9SSVp1?=
 =?utf-8?B?QUpJSzZSRGQ3ZzhNSXd3MWdTZENqMit3clJoVWJTaFBuRTgweU42WGZJSEt6?=
 =?utf-8?B?OU9vbTd5Nlc3Z1h2c05VekF4OVNDWlYrQjJvVy9BcGJWVHNFcWs5Y29WZ2l4?=
 =?utf-8?B?Q3IvOGRya3dDdWo4K3poWmFLcE1rMlIyaFVxWi9paHkvNWRiM1lrbDFURFMy?=
 =?utf-8?B?bHdGUEZnb0JlaUxBMmljT0lCU3N2MmtGN2h0L3l2a0VZTzlBRllXSFFzNXJv?=
 =?utf-8?B?bDgrWG9jR3Z6M3dYRHh1YkllbDJaRDl6RjZRMlIyOHRvcTdzdStRL0t3Q1Jx?=
 =?utf-8?B?WWxvcDNDOTdTcERnL21OeWNhWU0vSmtLTFFjbVlybDFJOWRwdHc1aHEvYnVY?=
 =?utf-8?B?cHYrVUIzWVhWZkw0N3AzdFU2SiticjJaNWtEdkVHSVFXUDNCMTF2THBVUEVO?=
 =?utf-8?B?VzhUd1QzVHB0dDNrMjFERHZSaGNsTVJGejRNUHhKd1E4YzJwSW92ZUgwakxz?=
 =?utf-8?B?UlFrUzJBT2I0cDRLU0t4aDVHb0dLVVBDVmtPc2FJNWtJMGhPSVZBL3ZMblNq?=
 =?utf-8?B?UzdnaWRuRmtscTIwUUJSWGhuWmQzWkxvdmlFZVpqOWR6V0RBWk9SWXdzc1dn?=
 =?utf-8?B?N1dCWHl4Q3YxdzNTNG9DZXFaTzAyOEk5OXpITHpQTTlXOGJpT0diWVFpUTA1?=
 =?utf-8?B?YjNHdWl2K0pWNFZDdWJBR0diWnNtNmt6aWJlVysxWWM0RmVGUkxmQVViWXBH?=
 =?utf-8?B?Y09xUHZZc1QzdmhoR1NCRkg1eXh2OGZ3ODlqMCtlaXRvVlpHUkMwai9ZZmVt?=
 =?utf-8?B?ajlnYUpyTk80aDJ4RzQvS1NiYWpiT0duM2tkS2I2LzZocFJ1UDRrLzk1M0pV?=
 =?utf-8?B?M3RWNHpFY1lWQ00wM3RZZTREcUswQ0JMUE5Hb1V5QXUxL29lRy9FMjBhN2Fy?=
 =?utf-8?B?eXhWb05rbklaV1J6eGNXSmdrNjNBaG44RFE0VVdEQkJRU0NELy9LMitTYSts?=
 =?utf-8?B?MTlCNGE1d3g2cXJLZXRSdjkvb3U5ZjBsOHo0ZDF0NEhENFg3dDlzSVU3ZnZX?=
 =?utf-8?B?OXdFSzlBT2lYV2cyWmM0UnNvOXJyazZFZU1aYWw1Q1V2OGpReXkybFNuN092?=
 =?utf-8?B?dlVQMk5DQ05uTUlVMHArZ2h3UG1qbWw1bVE2M2gydlREbmxFeHFMMXpCbk1J?=
 =?utf-8?B?QmhYZGRILytDVHd3VTNPbDlDVTFLWjFzSUp6U09pTUphV0dnYmZDNU5RT3g1?=
 =?utf-8?B?VENCdCswWEFValVmVVJtbzZBVWQyUjRlQ004eDl1NkhYM2hFQlFlMTJmT053?=
 =?utf-8?B?S0djTC9jM3l2QktwTnNSMmR5dEJGNGZwdmJ4c1dpYzNhZjBkY1NrQUpXZ3Mv?=
 =?utf-8?B?LzcxTDlpc3AwRXhDNnFxWE16UnhFZjc0Y1V3bEQrbnFXR285cmtIdXNDYTBN?=
 =?utf-8?B?WW54MGU3UmlHdElNUElpbXVCaDRBNDBaK3pJRTdQR0JhL09BZ2xjelBtTERT?=
 =?utf-8?B?TnZsZlliSkFYZ3Vvb1VML05TM2c3OG9ocWxISWxsb3FmZ29TRUlrbTJ4WDly?=
 =?utf-8?B?OGNON2JNbDlqMUhuc0VMa3h3Rkh4RkNxN1VoTkJXTW8xcVdvandiSy9ZKzlr?=
 =?utf-8?B?SmFLQk1WYnR3UDVZMTVPcTBlRHVnREJFanA4aDhnR080aFpTMU9HRWZINkNL?=
 =?utf-8?B?SUVmelpHeXpWSTZvOVhDR1M2VG9Ld1B5SHdNa2RIempKQnRYWEp0Vk9MS1FJ?=
 =?utf-8?B?a0V3SlVGS0tUODRCRnhjT280UGk5VDUyRUhYMWloZUNqbVgvQTd1VW9zcFY4?=
 =?utf-8?B?TnZYZmhWMHdhYklyY3VqakFmZHErZXppMVNpZlBYdmVFdWFhd0dkaFlmYiti?=
 =?utf-8?B?dTZxZ1dVQ2VSVDlNa212UnNWRWRORlBaSWtXcmpFa253Nlc5c09uRXd5S05Y?=
 =?utf-8?B?VFRPT3dUbGhGZ05XdVZubDNlN0tCcHQ2YW03YTY4Q2tuWFVTLzlDTWtTMkZl?=
 =?utf-8?B?QzRjZG10QXBDK1dsd1IwdHZNaS9jN2dZbDFmS0pnU0NOZXlSTlFoekZsWGlw?=
 =?utf-8?B?V1o5UjFFNGF0QzFXWnJZamk3bXV2SE94MU1saUR1dTByOVlEOHJIRUZMcjVy?=
 =?utf-8?Q?+1iY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE7DDF0A55CF184AA755BBE19478E7A4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae5771a-56fd-4e75-5129-08d9f782c859
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2022 10:45:32.7804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OU3Fml8ftS4LB2Pbjb2kc/Vcmrq1RHo1V5Ozm4vvT6YBADR7j96Z7ef0Dz4v7EiX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3598
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ILREsEArc_gYQbY-NA4Stiq3WgqQrBtR
X-Proofpoint-GUID: ILREsEArc_gYQbY-NA4Stiq3WgqQrBtR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_01,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=947 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240063
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTAyLTIzIGF0IDE2OjUxIC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAyLzIyLzIyIDM6NTUgQU0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gQ3VycmVudGx5IHN1
Ym1pdHRpbmcgbXVsdGlwbGUgcmVhZC93cml0ZSBmb3Igb25lIGZpbGUgd2l0aCBvZmZzZXQgPQ0K
PiA+IC0xIHdpbGwNCj4gPiBub3QgYmVoYXZlIGFzIGlmIGNhbGxpbmcgcmVhZCgyKS93cml0ZSgy
KSBtdWx0aXBsZSB0aW1lcy4gVGhlDQo+ID4gb2Zmc2V0IG1heSBiZQ0KPiA+IHBpbm5lZCB0byB0
aGUgc2FtZSB2YWx1ZSBmb3IgZWFjaCBzdWJtaXNzaW9uIChmb3IgZXhhbXBsZSBpZiB0aGV5DQo+
ID4gYXJlDQo+ID4gcHVudGVkIHRvIHRoZSBhc3luYyB3b3JrZXIpIGFuZCBzbyBlYWNoIHJlYWQv
d3JpdGUgd2lsbCBoYXZlIHRoZQ0KPiA+IHNhbWUNCj4gPiBvZmZzZXQuDQo+ID4gDQo+ID4gVGhp
cyBwYXRjaCBzZXJpZXMgZml4ZXMgdGhpcy4NCj4gPiANCj4gPiBQYXRjaCAxLDMgY2xlYW5zIHVw
IHRoZSBjb2RlIGEgYml0DQo+ID4gDQo+ID4gUGF0Y2ggMiBncmFicyB0aGUgZmlsZSBwb3NpdGlv
biBhdCBleGVjdXRpb24gdGltZSwgcmF0aGVyIHRoYW4gd2hlbg0KPiA+IHRoZSBqb2INCj4gPiBp
cyBxdWV1ZWQgdG8gYmUgcnVuIHdoaWNoIGZpeGVzIGluY29uc2lzdGluY2llcyB3aGVuIGpvYnMg
YXJlIHJ1bg0KPiA+IGFzeW5jaHJvbm91c2x5Lg0KPiA+IA0KPiA+IFBhdGNoIDQgaW5jcmVtZW50
cyB0aGUgZmlsZSdzIGZfcG9zIHdoZW4gcmVhZGluZyBpdCwgd2hpY2ggZml4ZXMNCj4gPiBpbmNv
bnNpc3RpbmNpZXMgd2l0aCBjb25jdXJyZW50IHJ1bnMuIA0KPiA+IA0KPiA+IEEgdGVzdCBmb3Ig
dGhpcyB3aWxsIGJlIHN1Ym1pdHRlZCB0byBsaWJ1cmluZyBzZXBhcmF0ZWx5Lg0KPiANCj4gQXBw
bGllZCAxLTMgZm9yIG5vdywgYXMgdGhvc2UgYXJlIGNsZWFuIGZpeGVzIGFuZCAjNCBpcyBzdGls
bCBiZWluZw0KPiBkZWJhdGVkLiBUaGFua3MhDQo+IA0KDQpUaGFua3MhIEknbGwgc2VuZCBhIGZv
bGxvdy11cCBsaWJ1cmluZyB0ZXN0IHBhdGNoIHRvIHJlbW92ZSB0aGUgdGVzdHMNCnRoYXQgcmVs
eSBvbiAjNC4gQ2FuIGFsd2F5cyByZXZlcnQgaXQgaWYvd2hlbiAjNCBnZXRzIG1lcmdlZC4NCg0K
