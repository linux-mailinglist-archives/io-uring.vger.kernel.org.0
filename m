Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32455E827
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiF1QVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 12:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiF1QUo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 12:20:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1BD1D5
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 09:12:53 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25SEoodO009892
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 09:12:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=05gmyTmrY7ey16TnP07F2Dg1V9Sfw/4TjUmy5cpTT44=;
 b=rgIVp6lVyUcPtBwZqsfIKRQpoRWH6Fh2Z1LZJTi3SuFG9YLFuFOxseFvwoIz1sPU5A7h
 O3sY4zUcjYya95dgBPq1MUQ3BTfOZ+PrZAyO8us1ZaokapPu7eirCJFlP8oPeLAykBWo
 VRXFcXHRakLpn938t8E3Ic5dPs2Y1HPnpI4= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by m0001303.ppops.net (PPS) with ESMTPS id 3h03ru0q5k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 09:12:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYrndjLJYbB71z51tFTmYyKHw/2aF41lYLG3+U6xoThbzBYzqcN4YNaC1wehmNqakvV9j1Ek9KMvHXmF8aCUYZNQyIg1Fa/DuP89vzAo7TJ5PRcgK6iOoENRsDedlfjHEllUGdBl7pLE0TUjnZMMmaeBMDPlv380tX3y1GQ/7w5tDWjX0QXzYc7TBLGRrgV5ek498rxQuB7GzfmEYZ2cuZZLvlomZM8mOBIrQDRFY7jtoee1O5Fv4v7OxFXUbzfhZhdx4jvpJH2GdvrvKUdCHKTWmqaw4bfglg32jiG5GEPrTh84jFg2LpuF68Y6CRlFZgCj09v0XgbKw0DUaaLPjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05gmyTmrY7ey16TnP07F2Dg1V9Sfw/4TjUmy5cpTT44=;
 b=mGDcTWFjz/MYTvswM2ZX7EFF18h6f4G9F1jpuUsLQ06Kf06sInWmwZKqkCvgdh3rTcoJwpn/ajRuN8eyUREHMmmoxeRWYT2NdylTBAG2PSFHDgQ8Dqllxti9JGABEbmLUpUrrowW+Gv9sHBkLk80lAmXaiJVlMTJsCJsbwaVLJURRe/D34wxF6x8Dn0EoVEgPWog7SeEZM6gcJOmmOqFBe6GULppnFwgv/4IPHoC9dYuK1RbXMkwORmV3VwYLl6AwpibsKN8AYRmFbkkxSCN/w11hR4gC/acT+eMI7ZtY9zUmd1Ry4eiPsq6b+n8jKlC94ZKFcOjk5O8cS8GeVPD4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by CY4PR15MB1624.namprd15.prod.outlook.com (2603:10b6:903:136::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 16:12:50 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9cb0:7576:f093:4631]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9cb0:7576:f093:4631%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 16:12:50 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     Kernel Team <Kernel-team@fb.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing 2/4] add IORING_RECV_MULTISHOT to io_uring.h
Thread-Topic: [PATCH liburing 2/4] add IORING_RECV_MULTISHOT to io_uring.h
Thread-Index: AQHYiwBo2XAK58s2WUqaYnJSSFXNQK1k/QmAgAAAyIA=
Date:   Tue, 28 Jun 2022 16:12:50 +0000
Message-ID: <a015d366fbd061e158b8829c29f9e101e54cb1ff.camel@fb.com>
References: <20220628150414.1386435-1-dylany@fb.com>
         <20220628150414.1386435-3-dylany@fb.com>
         <684dc062-b152-db2b-1fb9-fbd52e0b21e5@gnuweeb.org>
In-Reply-To: <684dc062-b152-db2b-1fb9-fbd52e0b21e5@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5061ffa4-d334-4570-2e7b-08da59210c60
x-ms-traffictypediagnostic: CY4PR15MB1624:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OpCzd5AKOHjqMxHlFKbBG6ZjZRxLucW35f5lgWFc3CEDU0zVuPTR1ewA2dYUlSx/A9DDRE5GYkoHCEMWlu+zKRHs/Bx3whhSqQ28MpRATygOBF6MxpG/wr2wIUOKaRQGxacpxClSYBQhskxbrQM8mJqpMGtygz1cxdIQeuNsaAKJ73g68tnDO2Br5flDAVgvp2ZHxKbGQqMqlzi4hSLpelT6mJsqCd4+NRcVZboNLLIMwwJPkCdcCnAzaAYtk98B73cbDNfqKeYdyOATZwpbpIgUogKI2RgjMwdaM5+fxgBgZikPpH2PFWjkefdeWlMUyTEuvAynTatsks4qvQsrSqTUnGK01U/ITQetFjLkKpzmUYrQ0CzKd8SplUwHuNTAwwO6zozVKhte8PK1khvAISSS/guUOKpREq4T1FVsnF7c6UORx9R2IUkiyDFGetAmjowc760AEdAimuyMfQ4KbBxF6bSOp/8QfZRxkJX40ZhkWAVaBFt6w0jKJ61V2SJ16zvae5ku9iQzig2rQ2B/6kUXSDXi1VbhbVzijHfzp0RHWP4oWbNMCnTfYUZC0XWezT3cXE/8ylfcvd9Mt0GhWeTsZEoLlXTZ8JFm1c89ROEjvR1zqIBRHoRVaLyle7RdMsM/9/b1GvULu4soJg7uKrhhDVO/lD6INp6TyRoDcn4NA7ho/gk4JrBmUsU0cihFd5K2HItO6hUtxlnSyhk6Ss1X9tyWeVxXBcjBGTx2wCdRZn6rY5yUzPUQi5jkenjcNNWr7FwXqXUQzpvE9jup4qQZMRhhRItF+3B2cdOba6g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(64756008)(91956017)(66476007)(122000001)(76116006)(66556008)(6486002)(38070700005)(66946007)(316002)(83380400001)(6512007)(53546011)(4326008)(66446008)(8676002)(54906003)(110136005)(71200400001)(41300700001)(6506007)(2616005)(2906002)(86362001)(478600001)(186003)(36756003)(38100700002)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3h2SGZ0MWpxYnZlYjF3bFdNWGF2RjJkZDRUbnVEaU05UE42aWZuRjBLVEtr?=
 =?utf-8?B?VVJOZHlBbnVIVFg5MUl5NC9MKzhhVElpcUtiUXB1TzRUbkxaS2VodkNXQkZk?=
 =?utf-8?B?UFZhbzZUWjR2Zktodm4yYlhTL3ZhVjk2RnI5bDBDOGMxeWpyakVsd1hUa1NU?=
 =?utf-8?B?S3dkaXFlSlFYT0VmV3YyempHeGovWnJTVWNtSkJaUno3ZGpRRkpMa2VsSnhO?=
 =?utf-8?B?ckQ2QmFpNWdTNHUrem9TNjQrTEg2V2JBWWhFbzBXL20rTVVhNnp5elBVOGcw?=
 =?utf-8?B?SWNzNlQ2U2VONE5JTjZnUlREM1cwREFGL1BxanhNSFBGT0JBRGl0K2F6ayta?=
 =?utf-8?B?T0ZpKzVqTDZSQThVNXRReG5JMEd1K1psSVJIU0hLc1NOSjdtdUJPOWdWYjY3?=
 =?utf-8?B?YlRxVCtuQ05GVEJiMC94Tjd5VkYrQ2RWanN4Ly9DOTZldjJWcUlTYzVoWVNq?=
 =?utf-8?B?N1hJb3IvQzZLd1NRS2J3OWZaTGpWL2RETmRFWVFJRTJqODAvUkgwcll0Z0Rn?=
 =?utf-8?B?aTRBa0xYTGFyZ0g0U2hSS1E1RitGVS9sazJmWjNzTEdzd2VKVTJYK0JRZ2t2?=
 =?utf-8?B?b2gvTWprS0NrdjhkcmZSZjhpd3RFMldJRE42VDdjd2tqZlB5MlcyeEpQSklo?=
 =?utf-8?B?SDlGV0NYa3hSM1FBS0E4WWVTY25icm10bEZYUlIweVh1NzJGSmlUTU10U0Q5?=
 =?utf-8?B?MU9GbTZWMWlsZ2UxcGp3Tkp1eWNyYUZ0OW5RVEI0SnRRdGRucXlYeWhnT0hi?=
 =?utf-8?B?SnZyd0s1TW1QbEQrV3Fac0tST3BKTm50VENUbG0vQnQ3Y3ZodmEwanpNb2hL?=
 =?utf-8?B?dGkzTmRqYUV4TXNWWjhzdi9BcThXcVc5NHFFbU00ZGdLSG82NUMyaXVXbHAy?=
 =?utf-8?B?NXgxMnh3clVpbHI5WDgvY29GOEVZNmFZT21xQzc1bjkyTWRJSWpnOFc1djNG?=
 =?utf-8?B?S28xQUdxaUtjK0JTdXdRb3ZOdVZCN2V5QmpHK3pLbm9TRFV1cVFxWFA2T0ts?=
 =?utf-8?B?YisvQjZjZTBNc1k4Z0pDVWJQWnFVRzYvd3c5VS9xOHVXekszVXRYdDVlaVp2?=
 =?utf-8?B?Qzg3eUhxNjE3cGFXVUdkOG4zR0dlM3J1aCs2Ky9EdHVaa1pJU0ZkbG5HWGNo?=
 =?utf-8?B?S2E0QmV5UkN5UlZFWnlYUU53Tys5TXpQdGxpZFZkTWJBWW9qVXJKd09hcEY0?=
 =?utf-8?B?aGpoTE5sVHVuY01PbThZd2JtTVdjQWtDcVI2VWtnTFFxbTQ1VTViVit5RkJG?=
 =?utf-8?B?cUZ1eWRNZlNCQzQ2RWZXVWtETlA4b3pSY2J1Qk1jUWswQndVL3RTRWt6ZjRC?=
 =?utf-8?B?TEZZU2xIVWxzM0tmKzJlclUwa0kvbmlWOGRDM1BlY1o1ZC9LYWFocGxPR01O?=
 =?utf-8?B?OUJ0cmtweTMra29FSVpxS3VMbUxqVGROcExOSG42V0FFSVY4UW5CTFNLcExi?=
 =?utf-8?B?eWFyUlJrc1lKSm5IbjlQS2hpVk9SVWxKZklEZGZWSnQzZ3Q0a2d5RDZlNEFn?=
 =?utf-8?B?NmY4emlRMm5wTHNGTVBJQ0dGelZCb21nVGIzYWl6Z0RTMmFUVlRidEJTRnBy?=
 =?utf-8?B?eEtVOEJGcTBEMDVST0lRdzBEVE5kZHdobFJsRnBBbFd1eUJmTEMrTmtTUzBQ?=
 =?utf-8?B?TThZT2dLYmhBZWQ2K2hLUTBEaUN0akZaSDZSazEzcUZJZURKQXJRNVpkeGJR?=
 =?utf-8?B?WEJPNzU0WXdvRDc1ZWlaYmdhVDExOTRicTJRNld5NzhGWVEwMDBLWlRQTTY5?=
 =?utf-8?B?YXlSdXQrdlFNS2pNRXczeXlFaUUyVTZpOUZCR2daZlVoTTVQWmsrQTFXT2hj?=
 =?utf-8?B?a1lqbXJkak5SNkxXZDVWUUwvb3dvNy8xd2kwMktFN01UdTQyR1VmWnBxSDF0?=
 =?utf-8?B?VnJRbFlTM0ltZytwU3U1SmhWcjNGU1RGSXdOWmphekNkZTRPbHJFZ1NKV3VF?=
 =?utf-8?B?c0s4MmtpRXUrbXd3OERQOHltblFYMGEyaGNRMy82anJuMUtZdk84U1JEdTds?=
 =?utf-8?B?L3FxRHQxcE53S2lRNGx5WWhUZzl6WFR6ZG1yQm8xRHFkeGZtSXNrNXBiTWh4?=
 =?utf-8?B?SGJhWkpGM2ZhdkJQcG1lNE56WHY0MkhQRURmVkd2cHBkb09uQ1pIMzBMNWhD?=
 =?utf-8?B?NlFQNkpwQWU3NHliRXhNR1dlcGJoM25keWdQbkk1NURHM2tGYnU4a2hqZ25Q?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06731CAD48CB604C800275C53D62E7BD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5061ffa4-d334-4570-2e7b-08da59210c60
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 16:12:50.2300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CZWHOHy2SUtZOt2Ur+AbCrnTZdI77BVUHC+yKe4OSEegN0iEq+HGRUq2JLNHLskO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1624
X-Proofpoint-ORIG-GUID: LBqN88pebqETOR_YcOq1cn5hQH9VUeNy
X-Proofpoint-GUID: LBqN88pebqETOR_YcOq1cn5hQH9VUeNy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_09,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTI4IGF0IDIzOjEwICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
T24gNi8yOC8yMiAxMDowNCBQTSwgRHlsYW4gWXVkYWtlbiB3cm90ZToNCj4gPiBjb3B5IGZyb20g
aW5jbHVkZS91YXBpL2xpbnV4L2lvX3VyaW5nLmgNCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBE
eWxhbiBZdWRha2VuIDxkeWxhbnlAZmIuY29tPg0KPiA+IC0tLQ0KPiA+IMKgIHNyYy9pbmNsdWRl
L2xpYnVyaW5nL2lvX3VyaW5nLmggfCA1MyArKysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+
ID4gLS0tLS0NCj4gPiDCoCAxIGZpbGUgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgMTQgZGVs
ZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL3NyYy9pbmNsdWRlL2xpYnVyaW5nL2lv
X3VyaW5nLmgNCj4gPiBiL3NyYy9pbmNsdWRlL2xpYnVyaW5nL2lvX3VyaW5nLmgNCj4gPiBpbmRl
eCAyZjM5MWM5Li4xZTViZGIzIDEwMDY0NA0KPiA+IC0tLSBhL3NyYy9pbmNsdWRlL2xpYnVyaW5n
L2lvX3VyaW5nLmgNCj4gPiArKysgYi9zcmMvaW5jbHVkZS9saWJ1cmluZy9pb191cmluZy5oDQo+
ID4gQEAgLTEwLDEwICsxMCw3IEBADQo+ID4gwqAgDQo+ID4gwqAgI2luY2x1ZGUgPGxpbnV4L2Zz
Lmg+DQo+ID4gwqAgI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQo+ID4gLQ0KPiA+IC0jaWZkZWYg
X19jcGx1c3BsdXMNCj4gPiAtZXh0ZXJuICJDIiB7DQo+ID4gLSNlbmRpZg0KPiANCj4gRHlsYW4s
DQo+IA0KPiBUaGF0IGBleHRlcm4gIkMiYCB0aGluZyBpcyBmb3IgQysrLCB3ZSBzaG91bGRuJ3Qg
b21pdCBpdC4NCj4gDQo+IE9yIGJldHRlciBhZGQgdGhhdCB0byB0aGUga2VybmVsIHRyZWUgYXMg
d2VsbCwgaXQgd29uJ3QgYnJlYWsNCj4gdGhlIGtlcm5lbCBiZWNhdXNlIHdlIGhhdmUgYSBfX2Nw
bHVzcGx1cyBndWFyZCBoZXJlLg0KPiANCj4gSmVucyB3aGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+
IEp1c3QgZm9yIHJlZmVyZW5jZSwgdGhhdCBsaW5lIGlzIGludHJvZHVjZWQgaW4gY29tbWl0Og0K
PiANCj4gwqDCoCBjb21taXQgM2Q3NGM2NzdjNDVlY2NmMzZiOTJmN2FkNGIzMzE3YWRjMWVkMDZi
Yg0KPiDCoMKgIEF1dGhvcjogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+
IMKgwqAgRGF0ZTrCoMKgIFN1biBKdW4gMjggMTI6NTg6MTkgMjAyMCAtMDcwMA0KPiANCj4gwqDC
oMKgwqDCoMKgIE1ha2UgdGhlIGxpYnVyaW5nIGhlYWRlciBmaWxlcyBhZ2FpbiBjb21wYXRpYmxl
IHdpdGggQysrDQo+IA0KPiDCoMKgwqDCoMKgwqAgSW5jbHVkZSA8YXRvbWljPiBpbnN0ZWFkIG9m
IDxzdGRhdG9taWMuaD4gaWYgYnVpbHQgd2l0aCBhIEMrKw0KPiBjb21waWxlci4NCj4gDQo+IMKg
wqDCoMKgwqDCoCBGaXhlczogYjljMGJmNzlhYTg3ICgic3JjL2luY2x1ZGUvbGlidXJpbmcvYmFy
cmllci5oOiBVc2UgQzExDQo+IGF0b21pY3MiKQ0KPiDCoMKgwqDCoMKgwqAgU2lnbmVkLW9mZi1i
eTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IMKgwqDCoMKgwqDCoCBT
aWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IA0KPiDCoCBzcmMv
aW5jbHVkZS9saWJ1cmluZy5owqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA4ICsrKystLS0tDQo+IMKg
IHNyYy9pbmNsdWRlL2xpYnVyaW5nL2JhcnJpZXIuaMKgIHwgMzcNCj4gKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLQ0KPiDCoCBzcmMvaW5jbHVkZS9saWJ1cmluZy9pb191cmlu
Zy5oIHzCoCA4ICsrKysrKysrDQo+IMKgIDMgZmlsZXMgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygr
KSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IEFkZGluZyB0aGUgYXV0aG9yIHRvIHRoZSBDQyBsaXN0
Lg0KPiANCg0KWWVhaCB0aGlzIG1ha2VzIHNlbnNlLiBJIHRoaW5rIEkganVzdCBhc3N1bWVkIHRo
ZSBmaWxlIHdhcyBhIG1hbnVhbA0KY29weSBvZiB0aGUgbGF0ZXN0IGtlcm5lbCBvbmUgd2hpY2gg
aXQgY2xlYXJseSBpcyBub3QuDQoNCkknbGwgZml4IGl0IHVwIGluIHYyDQo=
