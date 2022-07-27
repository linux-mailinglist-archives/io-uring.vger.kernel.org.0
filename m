Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250025821A1
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 09:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiG0H5m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 03:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiG0H5l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 03:57:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F3522B2A
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 00:57:39 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QNDGu9032105
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 00:57:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jESS1b7/4SeQXF9MKzdS/JmC83ypeUDf8099qBK3B5M=;
 b=LPZufaE6cr/XfnRwOj/D/mMRtsdnnrbD0NU9tx+J3YUm9rDE5yldD2iS1DVyBsThuLN3
 lCXFPzStltvJNZeJcn8+LYtwV45yxC4bEjfIppQq2n/3rJq489cQhYtGn5r+XnVLnBeN
 N148e4j1hp+h1i2IdZlwlz1JUxSgYNsnHlc= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hj9jmfxs5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 00:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBrCAKMIve1ryMfx8ydSg7/sUgF8g/8uUhCID4KXLxKq7NeKGYTz05AMBtPJN9i9PvT7DUSjjLP9LUx36wAHGFVrTS3CQ4gbm+8yMUzWe7HIQXr3F6fPK11b3AKenMhmtPnZlMfm3UzjN1nsIJnndanDFuAsQNIvRvTDHqzzP46jmiS5vWi9+VA/W1mn60TeRo8l+DlOktKfRSmEe04+wDEsefLPqjvYGIUvFFJK+Dy1TStOvhGCrQVQxQNXh6gB0wbuakFW52Pwd1fv+fd/KnAiRtGcizBYQwxeiFqOrsqzkgkG1txaAqlVCcWaRELI6dIJdSZ7DCxONrhbAkiw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jESS1b7/4SeQXF9MKzdS/JmC83ypeUDf8099qBK3B5M=;
 b=Ic0Yv2UFhPw5lO2u9lV+sLO1dcMCbO4qvkNcuDM+/lrt3t7B6v0yoloeN23GvfI1QrcHy4R+5QjaaGbpTU6O0f/xzTIHug5TL8nRfmNr0u9J6mxCHc0J1YpSGcHAZe/o9YdbhqcNHGCvXyCpTHXRhgM39iLrTPS5jOlmKzt5DbhbxT++a84By0JmRghOozimR4KPa7xsJ/Sz3zh64pf5c1s4fSeJjhvL4Czh06aOUy/mOzHOq2QqBL/gDF4DwnGGMpWO1dnv4VzTZtp/0zVCu4Ps5Z+yBiCUensaVVNVgwzncjrLGpsCY4R41fV4WnUJHh9Jf7reTuxDGWA6QswLGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN8PR15MB3379.namprd15.prod.outlook.com (2603:10b6:408:a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 07:57:36 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%5]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 07:57:36 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     Kernel Team <Kernel-team@fb.com>,
        "ammarfaizi2@gmail.com" <ammarfaizi2@gmail.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Thread-Topic: [PATCH liburing 0/5] multishot recvmsg docs and example
Thread-Index: AQHYoOldpNPjrur0lkesGZqF2sIsrq2Q1jIAgAACrYCAAAI0AIAAAiIAgAAAbICAAP2dAA==
Date:   Wed, 27 Jul 2022 07:57:36 +0000
Message-ID: <30e8595a4570ff37eb04cb627f64b71a5f948fd5.camel@fb.com>
References: <20220726121502.1958288-1-dylany@fb.com>
         <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
         <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
         <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
         <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
         <e126981a-c4c1-ca53-b98e-63ba1322f675@kernel.dk>
In-Reply-To: <e126981a-c4c1-ca53-b98e-63ba1322f675@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7b2e362-ceb3-4f00-cbc4-08da6fa5abb4
x-ms-traffictypediagnostic: BN8PR15MB3379:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3aQZqZo8Sss8bg1TqWwpmTKitaQQ10BbB+w4DxwEzdVFHm1ysTgfRzhzbQcjnH3f54ZapUxt9JEDExIX/w1uLhKOuXZ9S+b+ra6VP7yNupfuhuZHBhJN7N6bs6GEUQRqZdWMs4ed3A0TYXRiXEW4jFWwiYzHMXnS8hkm0cBNbJdijhT5Z4RxQmbNCqtHd+QUD0nxVWZSNaXppYP3HO6iNoFyZ5JvHBvh6LcQYTM4fTzykLyLoh0SEBi8Z7pJ8ENzxleP/NdLMebSeyLfYWPrJ0uFIiPvBJY2euKptjypsHPupp43gtrp7umMnxpud/9wuGa7O7Hs8VEs27Sa2w9WNRC9TTFfW5sIYi8KaYkEczWUjKMZGC7Wz7GkgbHBDvATVK1Hmli/Ctax/+0PRD057KvRsqevy6ps8jnroDKw0W3H+i0snS8kB3WRBk8i/Aylez+ortBPmY4fAUJR07KEr+asxrECrphtrDJl+YMjLO1lLEFFGNh8NTYDUU8Qhm0uVhIIDlrvayRkiQxNLvsBcryI288/TgOORvBRld9NMnlfrIOgnmckOx1ZdJtyTJLleT4sPkXiaI+nziGC4CBSHAZzOPGaTmQ3saRH5Jg0WsFDXnU+m+6R8ddowKxJ5w7houmGLyu3zMOZK5xah8T0EytFLyVJqw/bAwpjSIMCmhS7b4/R8dcPL28Hn13LPAs74vkueTKCRrcO6I7kpD0F9yRYCk5jYx3JfMlv9ori+MI9Bcre8RQkqd+gWfW/2/iIsY7IO3oYzOFr/IL1WeGVKJQ91k/8yJ32Pn6TELMF3WJlsHqDdpVrTKXQCmV6V3T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(6486002)(2616005)(478600001)(6512007)(8936002)(41300700001)(86362001)(2906002)(53546011)(5660300002)(186003)(316002)(6506007)(38100700002)(36756003)(54906003)(122000001)(110136005)(8676002)(4326008)(71200400001)(66446008)(66476007)(66946007)(91956017)(76116006)(66556008)(64756008)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0RHT0NLYWMydnBKRnN0YkFsSUdidGF2UzBCSjM3Nk1IZ0p0VzVpWmRDMUFE?=
 =?utf-8?B?dW1TUHhTTklNMTkzV2RIY0VFRHp6cEM2aVNFeHNQd2duamsxQWxsZjg5V1NR?=
 =?utf-8?B?blNEUjNvWTFzRjdESUJwZ2kySXA2aFBrdFBMTi9UOWZNV3VPU3M3TkhXUHNv?=
 =?utf-8?B?UWkwUUJEelUvYjB6R05VeDl1R3FTVCtBdVVmdWRzT3JObHZVdmdXU0dSV1Ey?=
 =?utf-8?B?S0d3ZTJqSU5waHpaVGdPS29pejR2Z0Jja0FUemNvcDVSb1F4SUFkZXlvbW94?=
 =?utf-8?B?UUpoQTA0Yy9JR0svak1RZEVZeE14QnZQREJtUWx5MWhZNWdwTHlkaS90RUJ3?=
 =?utf-8?B?RTFxTTIrYmtmWnFHd3UwRmhYVGYva1czdUJ3ZlZSSmtSNGFaUTd6OE1JcmRL?=
 =?utf-8?B?QVRZenA0MTNrTUxiOEJNSEFPb21ybXpmeE9qWW9FZWJhM3YzZWdnajNCMFB1?=
 =?utf-8?B?TE0zRDlwL0JRbHUzK3hCNlducmRFS3Mxd0JUWVN0K0RERmcwSUFBV1NYam5G?=
 =?utf-8?B?Y3JlZFljeWV2UXZLTW9TejFsbFdmcnVRcS9XalRmcVRqRmptVnBleTJwVlUw?=
 =?utf-8?B?b01YdXZ5dVJsRC9TMFVNOEt5SzNWY0Nob21PSEsxR2NPRjhPN2tET25xTHhF?=
 =?utf-8?B?WG5hNlUwSi9yVlhvUHNhY05HUEhPcGxqblZIUWh0UUtkZ1MvWnZvWSs0dVFW?=
 =?utf-8?B?YVpTcS9VeEh4dEJoNVhqS0RWNjdJUkFINmpTbE9lN0Q0M3h6YTVjRUVnck45?=
 =?utf-8?B?VDVmTDlSbk5kaXBhVTcwVTBVdXZZd1kwL2czZlZRcEk0LzZRQUVoWU9Ta0RX?=
 =?utf-8?B?b1VSVEhwNHJVcXZMTktrNGQ0SlRmKzVXR2JLU216VlVPdUx2SFk5ZWhTZG1I?=
 =?utf-8?B?TXNxUVdNN2VwWHU1SjAyMWpNNjZNQlgwUStUallJdm9GS1hqUnNTcE5xSmJH?=
 =?utf-8?B?dUNTNFd5eWh5NmtnU29GbXBOVDJQSUxhTjdYazFWZy9ldWtYakJpSS9lbmg1?=
 =?utf-8?B?ZGVqSTdzRFBHZG16cFVaWi8vQ21sM3QrelVkRnNQSS96QXZPdDJMdGJMcmhN?=
 =?utf-8?B?YzdOQk0wU3RYQzJ4QnFiMzF6T0xReC9valZyb3dTd2ZkZC9ySUJEUVFrcHlp?=
 =?utf-8?B?bWNvYWZ1ZGxIYnpmNEVUeVc4OWEvOVdTNjltbmZyMFdKTS9sMGJIeWw5U0o2?=
 =?utf-8?B?OVRkcVVUT2ZDdFFwL0g0NS9VTVk2N0czSDRXbktQdzlEZFA1MDhTc3hpWmhY?=
 =?utf-8?B?YkdhTXZoTDVMWVFaQlpmSW9HSFFvUVE5Z25qbEhXVTkvM2tNVUJ2UjQ1UGFT?=
 =?utf-8?B?WUtvVnpVVmZVZlFwQ2JWS1hMQWd6TUlrZGxlSmdsVEwxT3Z2endVc3YySHlO?=
 =?utf-8?B?STkvRkxWUVFFMS9XWmVudEMxZ1RZVm5TdGRFOWwvZk9hYkpvNmlSV0wzNWRJ?=
 =?utf-8?B?NXJzWTdXMUV4S1IzWGhmWDNNSlgrSDZ3Q25NM1k1M0VJNmhSaXowcjN6M1Z1?=
 =?utf-8?B?Wk4yaFJXVFFGWSt4N1ZPNUU4dlA4MW5Jc3UydVhxNW1MaVU0RFpRRUFzbWpI?=
 =?utf-8?B?Q1ArWUw1RFp0QmtuR0FQbVlSTzZlV1dnNnQvMFFlNS9nQ01qYksweVlYOXE0?=
 =?utf-8?B?VTN0T2xuL0VWVEw1QjZqTkt1ZHRGRkNsWVZ4Y3kvWUl3YWFqZ3VnNkVpT2tJ?=
 =?utf-8?B?NTZuSVJkeVRKc1dMbDYwODlIc1R0RW5IWGlIb0d6U2hzWFkyN21zSVNoWDAz?=
 =?utf-8?B?VTRzeDBjYy9idWIyT1QvTjdpMFI4ZXpaMkVYaXRjc2dxbUc3UE5xaklLZWlG?=
 =?utf-8?B?Z3QxazNTaFZVV20zUDFocWxHRUkxWG1iN2lWWDc1dlE1UXBIYmZKVHlUQnpq?=
 =?utf-8?B?RDZIeXVaY0pNdGNUbFAzbEFWVnN6TnlxamJpeWJJUTdaZ2w2MXhINmdJZDdv?=
 =?utf-8?B?YXcvRzFQTnlYREVIU2FZanBIdG5lREJlRDJpcnVsOG50eUNLbU1VMDFEMG1s?=
 =?utf-8?B?QVRIcGl3QkFDdTRSaXNBdkhybGxIdDNxdEluR3VVMHBTN3o2NEhJOFUwQ3VG?=
 =?utf-8?B?OGkzZENYM2lLOUx1MlpwWEdJRnp0UzZaYkE0aVI3Yng3dlljZzZRbi9heDdh?=
 =?utf-8?B?QVRveWYwTndhcWJLVUhnMDRJVk5vZFlOVW1FbE1FajFiWDMvWXNZeVNPSkVM?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B24ED2E48077347A2C7E8C54629943E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b2e362-ceb3-4f00-cbc4-08da6fa5abb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 07:57:36.7229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vm+0N0NMO9u6H5QDy6dwIwqbhyqrc7CI8fLXy9xRzJm1u6lm7VH+00Nc9utZgaHj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3379
X-Proofpoint-GUID: QdoRhcMeaup3-k6ZbO49hb4OD36XM7MO
X-Proofpoint-ORIG-GUID: QdoRhcMeaup3-k6ZbO49hb4OD36XM7MO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTI2IGF0IDEwOjQ5IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiAN
Cj4gT24gNy8yNi8yMiAxMDo0OCBBTSwgQW1tYXIgRmFpemkgd3JvdGU6DQo+ID4gT24gNy8yNi8y
MiAxMTo0MCBQTSwgSmVucyBBeGJvZSB3cm90ZToNCj4gPiA+IE9uIDcvMjYvMjIgMTA6MzIgQU0s
IEFtbWFyIEZhaXppIHdyb3RlOg0KPiA+ID4gPiBPbiA3LzI2LzIyIDExOjIzIFBNLCBKZW5zIEF4
Ym9lIHdyb3RlOg0KPiA+ID4gPiA+IFs1LzVdIGFkZCBhbiBleGFtcGxlIGZvciBhIFVEUCBzZXJ2
ZXINCj4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoCBjb21taXQ6IDYxZDQ3MmI1MWU3NjFlNjFjYmY0
NmNhZWE0MGFhZjQwZDhlZDE0ODQNCj4gPiA+ID4gDQo+ID4gPiA+IFRoaXMgb25lIGJyZWFrcyBj
bGFuZy0xMyBidWlsZCwgSSdsbCBzZW5kIGEgcGF0Y2guDQo+ID4gPiANCj4gPiA+IEhtbSwgYnVp
bHQgZmluZSB3aXRoIGNsYW5nLTEzLzE0IGhlcmU/DQo+ID4gDQo+ID4gTm90IHN1cmUgd2hhdCBp
cyBnb2luZyBvbiwgYnV0IGNsYW5nLTEzIG9uIG15IG1hY2hpbmUgaXMgbm90IGhhcHB5Og0KPiA+
IA0KPiA+IMKgwqDCoCBpb191cmluZy11ZHAuYzoxMzQ6MTg6IGVycm9yOiBpbmNvbXBhdGlibGUg
cG9pbnRlciB0eXBlcw0KPiA+IHBhc3NpbmcgXA0KPiA+IMKgwqDCoCAnc3RydWN0IHNvY2thZGRy
X2luNiAqJyB0byBwYXJhbWV0ZXIgb2YgdHlwZSAnY29uc3Qgc3RydWN0DQo+ID4gc29ja2FkZHIg
KicgXA0KPiA+IMKgwqDCoCBbLVdlcnJvciwtV2luY29tcGF0aWJsZS1wb2ludGVyLXR5cGVzDQo+
ID4gDQo+ID4gwqDCoMKgIGlvX3VyaW5nLXVkcC5jOjE0MjoxODogZXJyb3I6IGluY29tcGF0aWJs
ZSBwb2ludGVyIHR5cGVzDQo+ID4gcGFzc2luZyBcDQo+ID4gwqDCoMKgICdzdHJ1Y3Qgc29ja2Fk
ZHJfaW4gKicgdG8gcGFyYW1ldGVyIG9mIHR5cGUgJ2NvbnN0IHN0cnVjdA0KPiA+IHNvY2thZGRy
IConIFwNCj4gPiDCoMKgwqAgWy1XZXJyb3IsLVdpbmNvbXBhdGlibGUtcG9pbnRlci10eXBlc10N
Cj4gPiANCj4gPiBDaGFuZ2luZyB0aGUgY29tcGlsZXIgdG8gR0NDIGJ1aWxkcyBqdXN0IGZpbmUu
IEkgaGF2ZSBmaXhlZA0KPiA+IHNvbWV0aGluZyBsaWtlDQo+ID4gdGhpcyBtb3JlIHRoYW4gb25j
ZS4gU3RyYW5nZSBpbmRlZWQuDQoNCg0KSW50ZXJlc3RpbmdseSBpdCBkaWQgbm90IHNob3cgdXAg
b24gdGhlIEdpdGh1YiBDSSBlaXRoZXIuIFdoYXQgZmxhZ3MNCmFyZSB5b3Ugc2V0dGluZyBmb3Ig
dGhpcz8gTWF5YmUgdGhlIENJIGNhbiBiZSBleHBhbmRlZCB0byBpbmNsdWRlIHRob3NlDQpmbGFn
cy4NCkFzIHlvdSBzYXkgaXRzIG5vdCB0aGUgZmlyc3QgdGltZSB5b3UndmUgZml4ZWQgdGhpcywg
b3IgdGhhdCBJJ3ZlIGRvbmUNCnRoaXMuDQoNCkR5bGFuDQoNCg==
