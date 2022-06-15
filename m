Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FEF54C73A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiFOLQV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343570AbiFOLQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:16:19 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36CC49C9A
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:16:18 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25F9irvC027967
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:16:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3il8DKGpxZwB7ytjL5D4Ph3D12yPCbSbgcTn9pxJMVM=;
 b=Bu8J/lp/vEVigB9fZ/BMyzIr1zItTxRv3Gx6SMVymoCQ+o5VvqyPzD9lHp8Y+MYtns4o
 8SYgNEZSt836qMMARnH2mmVZiCCw6zEWLAmBiwQvXa+KcqqncwtQCKDXYG3tyQ+7LOA3
 uVq6/rOogZQ9ECQch4ej0dpq7zqeSC7bjlE= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqd2d8ced-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:16:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpH860SGN63WCoZqBdqCajZ5sRoTEUFqSnnJe+1W0tGviiWM158UDZvRgcr8Wwfb+mOcuxGQmgkn9nwSW4wDnhpVTMOgPAvnXGcI+s05TQBAMjzxEkyJXgNNLsDFgITW8r7/tIDq+TDOr23IK5Qq/TO8IP34oxfQImwf0C+XOj+TM8FUoZLOQAB6RuvsqjoZaFnCW9DMkdfvxzFj+U/NgEO6TpqLvYt7WIlXAngeRYpx6NmZkAlPd6TgRp0xoBdurTeFvQwh6wJ/WzIOakgBTIxwX5iy1H4igoG4Rq570dyFyMuUkhO2y3r61xZ68KV+tjFLX6Z5EgRC/ioHq9ztEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3il8DKGpxZwB7ytjL5D4Ph3D12yPCbSbgcTn9pxJMVM=;
 b=PSxw6dp7nTSOuYJi1AkZcCvc7J8MSvb53atTVqcQqrq0RC75sufY+XEIRQtzUauoRtwEcSc1xwj02S/dDeeFyNyULBLTEaRtXMZY/3Gp8bU5S4c/hSW6RM7R7LVltijpJbJ5KcGV9eHD95ZgiBLz+nsXwNwN1KcoWayb4egwVwbQXpHN2A2BEDUgkMbcXD9A2DY/m75G8Pyzm57h7Pb9be066hm6zFrWncgoVPJ1TuoP93utAooKgs8+9K9EiJbTbx+bEd/qpdzZP4VuDpH9Ah3Nh2BTLNSVAaxN8KiJMxnd74dAeRhW6JrF3ZrXYR50qxHAX42NKU9kE5Xd0SA0Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB4353.namprd15.prod.outlook.com (2603:10b6:806:1ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 11:16:14 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::8198:e29e:552e:5b11]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::8198:e29e:552e:5b11%2]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 11:16:14 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/2] revert buf-ring test
Thread-Topic: [PATCH liburing 0/2] revert buf-ring test
Thread-Index: AQHYgIs0YXCNYFqU5EO576y9WGLqlK1QUY8A
Date:   Wed, 15 Jun 2022 11:16:14 +0000
Message-ID: <46cdcceed6e006e45defb42e5f809c7de5efefa8.camel@fb.com>
References: <20220615074025.124322-1-dylany@fb.com>
In-Reply-To: <20220615074025.124322-1-dylany@fb.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c01c42b4-1ae2-4295-656e-08da4ec07614
x-ms-traffictypediagnostic: SA1PR15MB4353:EE_
x-microsoft-antispam-prvs: <SA1PR15MB435356963A25ECE665E2C2A4B6AD9@SA1PR15MB4353.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: horQ388faEcNqIc6zsOtE++JvmCC1O3fAEbuXvf2hFW4ZQ3C9RAzw4pkE3XvK47bL2L1MHdIul3GVVsA6IB+swElC2kAtv4H0XwYb8q1+TqcqBeZu5T4sKipCzgH+JYBjDAcomnMtPqlYwtdFt6TUTifHgs6XwCnLK1qieP1ztkjazm0UqGoafG2G/AVkpWfV5SzHKvivjoLb2VGYHjGDs0th1gAz0ify8yzA5DwWjcxL0HqpDt9FpusdLza/kW7gSknO7VyT0ThoGN7XkPtAVK2gqlAPMxeffPP4YjSTxUu1InEwY+bg26Glfnjp+mcy+2E/J8/SwvtQwcxCw+jNxIag1mN5Up/K4P65xkEcqskFAAwTXBOdBeDZK782aKtHzpMAf9+u1cy7LQLPpRZ7NiGEvFhu5sZdxch9uiiPxjx663M1OcFo8Op/rDkV6FtWKlqxO1MNzRDY0ruv9yZ0WQkPHyRFV1PAAPsqbl700xlnDtyKNfvkAr/0xdYjYsj8nI22ZZHgzRyzqxlulWCWou8JPMkJAdugqNgHVBbM8eB604sh7l2fJYeJm33s+JxGE8mTUkAvjN/riUe32C6bHmroazRjw8fjbnoNBErrKUj/EntjUIGC6rEjQY8/OCtOcDmaGzhqR4y7c3h0wUUbA3CMj26qMkY54Eo9p58n+QPAE4PAMgKDieerVjGIIl3IdObgJWfSO6p9DON1rHjJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(4326008)(91956017)(76116006)(2906002)(122000001)(38070700005)(86362001)(5660300002)(8936002)(38100700002)(4744005)(6512007)(186003)(6486002)(508600001)(71200400001)(2616005)(6506007)(316002)(83380400001)(54906003)(6916009)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnpaRUJGMTVPV3FxY01QWXFsbWhPdm42dXJrcHlUT25ySE5mMmpnaGhFSnBi?=
 =?utf-8?B?UUNsQ2oyWUVBNHVVNW1rVUpFMU9VcUpIbGY2WkxwSmlyNTBFcHc5WGkzRUFI?=
 =?utf-8?B?L290dzRYYldMVzcrNzBHTWlnWkdqeDE5L3k2OGxmZVBVOTVROG1OQWd1OHJo?=
 =?utf-8?B?NVgxZlMxaHN3SVg0OEpITUg1cVdwek9STlVRcHpQOWp3Y0JGT29YZEJ5dTNk?=
 =?utf-8?B?UXgybWViVXhCalB1WTRPd1NrWUtNRXY2ZXpqVzVkWEJFeWtZcFJtdUEvWnFL?=
 =?utf-8?B?MVRWZXl0bUdnLzZLa3JLZUhGM3J1QzhUVDJhRWFpUkZaTFBLaXVpYXNGUWtQ?=
 =?utf-8?B?SUk0YWkvRS9GY1hOaGY1ZENyTDAyekRGODB3VUFDajRIZjhKckZITXF0aWU3?=
 =?utf-8?B?dWJ5aE5CMFd4RStvQzZJYi9hUWdqVHZ5Z0RhbFlkWnhEUEw0NU5HUVIwNjF2?=
 =?utf-8?B?WDNFN01kV0wzRW1BU0orQ0UyaEJJZ29QSWZWY1FEN3JXUFBVeWU2Y3pyZFcy?=
 =?utf-8?B?REp6Tm1PS2E0RjBkYkpxbkFLeGZBT2VLcFE4TmY3a1hCWGlXVWZNbjZScFJn?=
 =?utf-8?B?TWdRNlJqVWgvdklSd24va2ovajhKOHR5TW5EU3J1a3BsZjN3UUNHaVF5aEd1?=
 =?utf-8?B?U2ljTDUzbllQQ1RXbWlUTUwzcFV2dUd2WDFMeExSR2pwdmhOR05semxJMFRr?=
 =?utf-8?B?ME5kTDdNaTI2c1BuNEJBUGdnVWxXNUZZSGNNWkIydzF1RWhITmRTR3ZQZTRa?=
 =?utf-8?B?SDliSnJZMmdOWUwyallDMGVTM3IweEM4N09mc05QeHBoQ1pqYnpaMDdjeUlH?=
 =?utf-8?B?T0o3SjNPV2NsTmpjZzU2T3doUmxjYmlraEJqYWRmTEpKYlkxbTNZZndqZks1?=
 =?utf-8?B?NDBFVTlqUzg0ZzBLMTJHZ2pKQkJjRnZTVFlWK2tWU1pPaEsvdlpDUnVlbHZm?=
 =?utf-8?B?VVQwUjVDWEdIZWw3dHdnQlFaRjhmTk5Ld3dKb0o2U1l0V1JWeDlNYnhXeUc1?=
 =?utf-8?B?bEVBVGZwSk4rWmltNm1rWUJVbkp1ZjBqUG8yUHhzNU9CQmRCbHdKVDdEUExM?=
 =?utf-8?B?aFo0d1crQlZhMGhSWFE1amcyRk92YWs4YllaMVlRQTRZNzVqSzcwcWcraFV6?=
 =?utf-8?B?MFA0RjFHSHk3TGJVQXhBUWFzVUd0d1BVWGJoUEpNVjlJSDQ4NUZRYXkyN3dN?=
 =?utf-8?B?TGM2Y2E2WEYyUFViR1RRODY4KzZiQXQ1R09EWVdvdDh6eElQdjNNNnk0dTlP?=
 =?utf-8?B?dGRZQWc4S0xjQzZCak45Q3lkOHhQWEtEVU80elMweVF2d3dYTERaK0VDcnA3?=
 =?utf-8?B?Y08ySWdzR1hqRzlzeDlFZEViRzVoOVFkQ3djZXlEL296cjc5Mmhab0hiY0Zv?=
 =?utf-8?B?ZUJFZFloQmU1cWlWNlM0cG9uaVkxTkljTGp0NW5lRHUrUVhpRURwbmVOVHcy?=
 =?utf-8?B?bnU5Y1ZWd0RGbUZhNXB2R0FIZ1hDbExsWkVTRGRLZUdraXhOWFNHK3lSZUhS?=
 =?utf-8?B?RFRPTUxCdEhWcytVcVpIYWcwd3VtZG5GOEpwR2ZjVU05TnNCdFUyakRFa3li?=
 =?utf-8?B?eHFQTXdVNjhYVGRtR0FEaFh5WkNvcWJyMjNQR2xhdGtjZnpWb3hHYXFuNWFk?=
 =?utf-8?B?OGFBMS9kcUZPVGlRVStxNVI4d3RKQmd2dWJTaXN1Tk5PNk9rdDAxU2lPS2Nm?=
 =?utf-8?B?WHlGZDlLOTRDN0JFVTBwenQxSy8yMFdCbDExSGNLS1R6ckxCcnFNd082MTQy?=
 =?utf-8?B?K0EzUlZ4ck9hTFljcW9HQXdwQjBCcldwbkxiN245ZWs2NmQyTmZZZnpFa1cx?=
 =?utf-8?B?MkJpbW5zZjJ5UmpuU29SeGxSbUMrWmg0RVkrUjFDLzJNT3J1TStsVnYzYWFu?=
 =?utf-8?B?dHYxbjdMUUllWGNPdVl5bTNmMmRjWFdEeEVqWUw2aEN0TXBFQ0FLa0VxYU9E?=
 =?utf-8?B?MFpSU29DMEdTdmsrdWJibGNKNC90NHV0elVmU09EUVJyMkdubFdILzBRaWJr?=
 =?utf-8?B?OHI3eTROa3hQelJkMnlXN0RGTHp1VDdIU2g0K1hZUUVnZnh3cC9RZzZNVWZE?=
 =?utf-8?B?VENNVm42U0VRendEa3VtVUNIT3EvUm1MSS9oVVVnTlRxc242VW12V295RHVy?=
 =?utf-8?B?VlNXeHNMcEY5NWtOekMrbTVTYUwvOEZzM3lxekYzWU1vNXZVRGYzeVhBOE5W?=
 =?utf-8?B?cEFTdlRoNHBKcXJxbmdTK3JaU3hVdUxEcklmWlhjZ0tXUHprVk1VOUk1RTZW?=
 =?utf-8?B?NjFsa1Z3b1YxWUxTSWRNYWxDeVB4TlpoL096eWxneW1qSlAzQkJoblRIWFZh?=
 =?utf-8?B?cnJ5VVIrZzlNSDQ2c2txSFpEWE1KVUhJMC8vVFlOcXErdUZud1I2OFVrWUVy?=
 =?utf-8?Q?WBKQQb8R3rWi7v5M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FA0531578F02844B09E389C4A648BB0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01c42b4-1ae2-4295-656e-08da4ec07614
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 11:16:14.7457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IppZMHHijupxC6i5InD6HMAFv1PVL6qLtZSZ0XZQRrzZqGL/L8hnkrTHlTT+GrXd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4353
X-Proofpoint-GUID: qOGNDtGdTXEUPrLR3yizUIRYND3lM_uP
X-Proofpoint-ORIG-GUID: qOGNDtGdTXEUPrLR3yizUIRYND3lM_uP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gV2VkLCAyMDIyLTA2LTE1IGF0IDAwOjQwIC0wNzAwLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0K
PiBSZXZlcnQgdGhlIHR3byBwYXRjaGVzIGZvciB0aGUgYnVmLXJpbmcgdGVzdCBhcyB0aGUgTk9Q
IHN1cHBvcnQgaXMNCj4gYmVpbmcNCj4gcmVtb3ZlZCBmcm9tIDUuMTkNCj4gDQo+IER5bGFuIFl1
ZGFrZW4gKDIpOg0KPiDCoCBSZXZlcnQgInRlc3QvYnVmLXJpbmc6IGVuc3VyZSBjcWUgaXNuJ3Qg
dXNlZCB1bmluaXRpYWxpemVkIg0KPiDCoCBSZXZlcnQgImJ1Zi1yaW5nOiBhZGQgdGVzdHMgdGhh
dCBjeWNsZSB0aHJvdWdoIHRoZSBwcm92aWRlZCBidWZmZXINCj4gwqDCoMKgIHJpbmciDQo+IA0K
PiDCoHRlc3QvYnVmLXJpbmcuYyB8IDEzMCAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+IC0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEzMCBkZWxldGlvbnMo
LSkNCj4gDQo+IA0KPiBiYXNlLWNvbW1pdDogZDZmOWUwMmY5YzZhNzc3MDEwODI0MzQxZjE0Yzk5
NGIxMWRmYzhiMQ0KDQpJdCdzIGFjdHVhbGx5IHRyaXZpYWwgdG8gY29udmVydCB0aGlzIHRvIHJl
YWRzIG9mIC9kZXYvemVybywgc28gSSdsbCBkbw0KdGhhdCBpbnN0ZWFkIHJhdGhlciB0aGFuIHJl
dmVydCB0aGUgdGVzdA0K
