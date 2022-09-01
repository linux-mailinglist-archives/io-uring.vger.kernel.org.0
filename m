Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DAC5A9770
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 14:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiIAMyo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiIAMyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 08:54:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEFB40BFD
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 05:54:39 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2819eGPM020931
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 05:54:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8ojAN3jTt1UV5hYnY49yuUPNyvFwtTzM1NfpY4TkJpo=;
 b=LdTFsUN5cFxV7RtkvHi6amarR1ndUEwlAGOhX1UW3iUCMApQqTHmt9u/qSPK1N0A2Gv2
 +SM4bpx+9u7HbyEgDRfl0wYOzmY5hAO27t8bNKy3rjwrRzaOJ+2IjLMAL6gOZAK2OQDW
 885QSdInJRlwldta19ehrfRuIfN7zzs8zUE= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jat6s0xfk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 05:54:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARd4w9d5BdXB5/aB/hzX1NRWZH6+6WmPlD8SFhNJM5oXnDob9XMcQTlCEN2e8RW6nkMItB2i8O6Rso7S1R34WK1tghEs0fRHILFjiGMUdUv+gr5wO56yJRImVV3qdWIcyHp+8RdY+YyRuNHpWNBQK7xLrMJytj88ieJwJWwsZI0v7CEpCQiUsEWZNlaWF57dtcpd2tPjX1uxbdgubkiwr1mlImX5K89A/T/GLz1WaRsYWC8/gHRTY44e94UfiEdamYotZWBIoim6y/lvYLT68QSmptBSspdE2NCjXNoAllaGZgrktZavShLGUr455SkprTEcCXxY2ompMf5W8nz6aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ojAN3jTt1UV5hYnY49yuUPNyvFwtTzM1NfpY4TkJpo=;
 b=CamH8pIODSyxiIO8Fvj9Y1D5G6m4G/nkn6ErdEHK7wlin2p+EZ1qR6F8RATsqE+Ji0NW31n0ChlFUE9Yn0q/zkaVlFl8Ks5zRw/0MYAgpx1pwPMNALHTelKXSBFeKVOk6caOSRcYs/A24y6KiJCxfGSXT/UFsFULcHSn3nvftJS3yrX9atWej4WB6EZzOWz+OuPsYx1WCfoCJ0Zw4W0uQf+3q+QCFpCZRsxWofbXZpxUSbzWsNv+Z4+Em+TlAGFfCnpm5u9oO7Ww+1dsLW9Ya6qDOhnaZjJqObiyvZc5DRq08EYK1ax61QdupcSnzeqy+XZFb81cZph+Ot/dCx+1cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW3PR15MB4025.namprd15.prod.outlook.com (2603:10b6:303:46::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 1 Sep
 2022 12:54:34 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%5]) with mapi id 15.20.5588.011; Thu, 1 Sep 2022
 12:54:34 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 12/12] shutdown test: bind to ephemeral port
Thread-Topic: [PATCH liburing v2 12/12] shutdown test: bind to ephemeral port
Thread-Index: AQHYveXqayNB2mz//kuClnaabmo7oq3KdLuAgAATbgA=
Date:   Thu, 1 Sep 2022 12:54:34 +0000
Message-ID: <cef8b64ee7b73ba5899da67eff6e395547d88ddd.camel@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
         <20220901093303.1974274-13-dylany@fb.com>
         <918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org>
In-Reply-To: <918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed5a5407-87b8-4864-3130-08da8c191ee1
x-ms-traffictypediagnostic: MW3PR15MB4025:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TSWD1iJ4GE0mKRuCoWNatBoWb7FQP8/d6wK8o1jLqi34OUaqNsq0WESA7ET9qO22PpgynNgx8/wi5nzKx73Q4Z0OT4qzSgr1ivYtWBpL/Rno67WZWRUKEsyqjh33N3P1GPJ4AytfxoBLmFpWJa28gFEY56IfbZgUNF65EFkNJkt9AwGEkGN4LMs0UBexiiwjkBnymbGpF8lv2FpaDd/pyYWCBVRbG2acna06+mPX3OqvkT2yxLy0KmA1eEzH6gH1CbY1gtLN1MS4FhiuI+UZ04efotz69G/THNfUu3grFM91r5Ss5OfJ48KyGdMI1QkaS88NckySrV6zTy4hn3MKAq4VmAE9vW3yEkJXwV0Pau5QoltuTRiJrCiCstcTOTQOKa5aJXOk4BrUaeXic62iT8AxqKcFqa9d8M7Fw0mUhilVkFGw/nrmmzyh9zOWOx8OaWC+jhuzmDZLTVcotDHg2szMYYAHdXQeVTbtUaaZP0DsYAcYivece1p/XceQ/dF+ziA9+TAc6Nw7itQ+NCWKMgTcktW1wF39Tk5Ie0hIy28JL5YSGEJemZ3G+PwTY9i2e6zXC12d3lw8sBMTw8+t2tOr9Eyg1zaLdkhz1jm/Bc01DCy6jg9Ai65esbAT+qAh123mA3pLofAx4cwgofaa8jeOeKPcEEkkvCtlITFa5J0a6Zb38I5R8tQYJt703wmzwmDybze8AiUPvD7bP8yAeLPKwpMSyjO4Pmbc3JLu4z942ro41KO9+LNtg6C6EPFPf7gLAELOfi7gwqRBmtmpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(6512007)(53546011)(71200400001)(186003)(2616005)(6506007)(5660300002)(8936002)(41300700001)(36756003)(86362001)(6486002)(478600001)(83380400001)(38070700005)(316002)(110136005)(54906003)(2906002)(38100700002)(122000001)(76116006)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZU9tWUlOc3dFOVNwMnU4Y1JJR1RjRHNqT0hrK1BVZWl4Wm9teE9HNDM4VVAw?=
 =?utf-8?B?dlpUSnMxOVhBN0kzTU1YNlFZTFB5SFlVTkp6UGIzbzFSbnVYK1RTckhUUWpP?=
 =?utf-8?B?MVIwZkNWd0VzMWpBWjkwM0ZiNEdVeGdiSGVSV0tEcTNDdlZOYXlPbm1PSmlK?=
 =?utf-8?B?ZFc2ZUhzRFA2Yyt2dUJUcFR6ZlZCOEJQSEZBQW1rQWZXLzdvTElqd0YwU2Fs?=
 =?utf-8?B?QXZ0M3o1cVUyL3ZKc3BCM0VzOXhEZ0JHMElRWlh5ZTYvaUsxM2RBUktpV2FJ?=
 =?utf-8?B?a0ZWR0ZMTUQyVWNFbTdUTGo4c2JoSTBqZWExM1dFVnlNUWF0MVlYWVBSZzQy?=
 =?utf-8?B?QkpueHA0eHQrSHNWL3gwa25RQ1FsZlRNb0RqMzJUNG1aNFhvSkxQM2pmcVhI?=
 =?utf-8?B?S0l4REV2enhzRmxZa2tyY3pnR0dpTjBVZlJ5U0ZJVktMRjlkWTRsVlZUeC9W?=
 =?utf-8?B?Q050ZE5tT2pobXZRVW54Z216Ukd0UFpJQi82emdZdU4yUlcyVDMwNjgxMlFL?=
 =?utf-8?B?WldWTDcrWjc3SnBNYnZ2VHpYL0RtZ0lNcVp6L3NoY1hEU3Z2aFlINjQ2VmJG?=
 =?utf-8?B?WWtWQnEvMlEyOEtXSXNEK2F5a09abUdGazY3bmYzdzhSK1pEYVFKMk1Dakg3?=
 =?utf-8?B?S1ozMTVNNWNVZkU2TEhMa3NMNFhwWkNidm9seWJCb09CS1hCUjRWQlpPS1No?=
 =?utf-8?B?OXRIclBJeW1nOXd6VkNsVFdtdGFCbUE0K3BhSkFTOEdDdnZsMTVBaHIzSTJy?=
 =?utf-8?B?ek42WFR0SHpVUzZyQlhFK0FEVW5nVFZrUzJKWnd6SDRHRXR3QldPVjNZczYw?=
 =?utf-8?B?ZGNnRUJMS2VuWFhKSjJ4VXFObEo5MVU2R2ZNa2xpa3dkZmtqZDdGZjRMSmNi?=
 =?utf-8?B?QmNtRDhRckpPNUFsOFJsb000Q2tVckRrdHYreUlWRVNrU0JBL2pESUlITUpi?=
 =?utf-8?B?ODNZMGNMbXdxS2VNVngwQzQyMGlXcmZrRFZaTTJvelI1aHM1YzU5L3ltcG5w?=
 =?utf-8?B?cE91T0ZOcm5wY2RkTzVZUyt5YjdYakd4V1BHWm16UDNTb3R2SGJQRWgzMnk2?=
 =?utf-8?B?eVc4U0hHRmQwVFYzSUlwOUVocTB2MnpWOFBYWldqNzkwbzFUelpDMThLN3Fi?=
 =?utf-8?B?YXRjRmNQdTNmQURVWTZOdjZDZ1A3Tmwza1hkWE5ueTg1QjRKZlpQTFg1ZmNU?=
 =?utf-8?B?MlFGQXo4VUk4ZmlhQUFnRVF6SlNUQzd5ZHZkNW9VNUVodllvWnZ4N3NiUHJw?=
 =?utf-8?B?Rmtxa3pMMkdkWitMVnpGem1RZkh2c1RTcVVBQ1VJdkp2MHU3YVdRcTQzMnh1?=
 =?utf-8?B?SjBTNG1rWHJLYTVheTJUdHZ3bVlCNjNYRmMwR0RWU0p5S3RlN295ZWdabHk1?=
 =?utf-8?B?VXI2QUMyeXJsUTJsZkhkVkxTVG5DRmg3aTVmeFYxckxjbXpzdGp3Y1d6anJB?=
 =?utf-8?B?VHBTeDl4N1RqRStSa2xwN0JCQmFBdy9zYXhONUVJd3E4ZlR1MGd2RzFBWFc0?=
 =?utf-8?B?c3MzNEMrWjBmQmNYcDU0aUhvWGRvbEpONFQyRnJjUTNKcWEybDZXRjlpc0Y2?=
 =?utf-8?B?VHBkWWtzYWpiWndGckpPUmowaTJvQUZsVDJzUGVpSWp2SVF5TlhRdXdaRW1s?=
 =?utf-8?B?ZmZBTytPaXZDZjJST3BHWDFQNkx6YTdUeUpvZmRadlFQejFrcjFFR0l0Ukhz?=
 =?utf-8?B?WDJzVW5Pa2J3V3Bsa0Q2dUxIQXRKS1F0aEg0bXY5WHR0Q2hNZGNabzA3QkZ3?=
 =?utf-8?B?RW1HaWdiVVZBd2lQZTJVK3BGM1RHY1plL1dock5NdTloejFIM3ovd3lablJl?=
 =?utf-8?B?UlF3MlNVUlljTzVyYzJaN1cxQmQ4bDZxbEhSNVU1Nm5hNEdWbGZGRVRpb1lM?=
 =?utf-8?B?ZXVUcFQxb3VaUUdydFNQVS9vM09mOUNqVkFYanZRTDBiejVXL3J1K0FhYUFH?=
 =?utf-8?B?cXdCTFJwU095ZWNjbkh4MXlOVG44RXoxODk3T1hMN2RZcjNPUFJFS2dhWTYv?=
 =?utf-8?B?VCtlRllKeEMrMk93MUNZQzEvZlo3MEYxaGg4QjQ4ODRPTkpUWnZhblZsODh6?=
 =?utf-8?B?Z2pVT2crakJGbHdVVHhkbCtVKzRZM3ArNXpjQURFZ3BSN2RSaFZ0NHh0UE1Y?=
 =?utf-8?B?V1lOK1VlR05HcWtzaDM5R2RhOTNJMTZ4Zkd4QzZyU25nY0JIUDJaZHMzd1dN?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F27B2D391222E94A86E9602445CACA7D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5a5407-87b8-4864-3130-08da8c191ee1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 12:54:34.6179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjuguRSsXtnaY4QuEO1JxC8Y0ZM58FPJCyNcTLEUfg1uINWa9iU+YgWvK23vw5MZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4025
X-Proofpoint-GUID: UPWgh6R19q__-k3GZk1nYKaStWpoC559
X-Proofpoint-ORIG-GUID: UPWgh6R19q__-k3GZk1nYKaStWpoC559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_08,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA5LTAxIGF0IDE4OjQ0ICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
T24gOS8xLzIyIDQ6MzMgUE0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gVGhpcyB0ZXN0IHdv
dWxkIG9jY2FzaW9uYWxseSBmYWlsIGlmIHRoZSBjaG9zZW4gcG9ydCB3YXMgaW4gdXNlLg0KPiA+
IFJhdGhlcg0KPiA+IGJpbmQgdG8gYW4gZXBoZW1lcmFsIHBvcnQgd2hpY2ggd2lsbCBub3QgYmUg
aW4gdXNlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIFl1ZGFrZW48ZHlsYW55QGZi
LmNvbT4NCj4gPiAtLS0NCj4gPiDCoCB0ZXN0L3NodXRkb3duLmMgfCA3ICsrKysrKy0NCj4gPiDC
oCAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL3Rlc3Qvc2h1dGRvd24uYyBiL3Rlc3Qvc2h1dGRvd24uYw0KPiA+IGlu
ZGV4IDE0Yzc0MDdiNTQ5Mi4uYzU4NDg5M2JkZDI4IDEwMDY0NA0KPiA+IC0tLSBhL3Rlc3Qvc2h1
dGRvd24uYw0KPiA+ICsrKyBiL3Rlc3Qvc2h1dGRvd24uYw0KPiA+IEBAIC0zMCw2ICszMCw3IEBA
IGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlu
dDMyX3QgcmVjdl9zMDsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgaW50MzJfdCB2YWwgPSAxOw0KPiA+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc29ja2FkZHJfaW4gYWRkcjsNCj4gPiArwqDCoMKgwqDC
oMKgwqBzb2NrbGVuX3QgYWRkcmxlbjsNCj4gPiDCoCANCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYg
KGFyZ2MgPiAxKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7
DQo+ID4gQEAgLTQ0LDcgKzQ1LDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkN
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgYXNzZXJ0KHJldCAhPSAtMSk7DQo+ID4gwqAgDQo+ID4gwqDC
oMKgwqDCoMKgwqDCoGFkZHIuc2luX2ZhbWlseSA9IEFGX0lORVQ7DQo+ID4gLcKgwqDCoMKgwqDC
oMKgYWRkci5zaW5fcG9ydCA9IGh0b25zKChyYW5kKCkgJSA2MTQ0MCkgKyA0MDk2KTsNCj4gPiAr
wqDCoMKgwqDCoMKgwqBhZGRyLnNpbl9wb3J0ID0gMDsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgYWRk
ci5zaW5fYWRkci5zX2FkZHIgPSBpbmV0X2FkZHIoIjEyNy4wLjAuMSIpOw0KPiA+IMKgIA0KPiA+
IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBiaW5kKHJlY3ZfczAsIChzdHJ1Y3Qgc29ja2FkZHIqKSZh
ZGRyLCBzaXplb2YoYWRkcikpOw0KPiA+IEBAIC01Miw2ICs1MywxMCBAQCBpbnQgbWFpbihpbnQg
YXJnYywgY2hhciAqYXJndltdKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBsaXN0ZW4ocmVj
dl9zMCwgMTI4KTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgYXNzZXJ0KHJldCAhPSAtMSk7DQo+ID4g
wqAgDQo+ID4gK8KgwqDCoMKgwqDCoMKgYWRkcmxlbiA9IChzb2NrbGVuX3Qpc2l6ZW9mKGFkZHIp
Ow0KPiA+ICvCoMKgwqDCoMKgwqDCoGFzc2VydCghZ2V0c29ja25hbWUocmVjdl9zMCwgKHN0cnVj
dCBzb2NrYWRkciAqKSZhZGRyLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICZhZGRybGVuKSk7DQo+ID4gKw0KPiANCj4gSGkgSmVucywN
Cj4gSGkgRHlsYW4sDQo+IA0KPiBJIGxpa2UgdGhlIGlkZWEgb2YgdXNpbmcgYW4gZXBoZW1lcmFs
IHBvcnQuIFRoaXMgaXMgdGhlIG1vc3QNCj4gcmVsaWFibGUgd2F5IHRvIGdldCBhIHBvcnQgbnVt
YmVyIHRoYXQncyBub3QgaW4gdXNlLiBIb3dldmVyLA0KPiB3ZSBoYXZlIG1hbnkgcGxhY2VzIHRo
YXQgZG8gdGhpcyByYW5kKCkgbWVjaGFuaXNtIHRvIGdlbmVyYXRlDQo+IGEgcG9ydCBudW1iZXIu
IFRoaXMgcGF0Y2ggb25seSBmaXhlcyBzaHV0ZG93bi5jLg0KDQpHb29kIHBvaW50LiBJIG9ubHkg
Zml4ZWQgdGhhdCB0ZXN0IGFzIGl0IHNlZW1lZCB0byBiZSBicmVha2luZyBvZnRlbi4NCk1heWJl
IHNvbWV0aGluZyB1bmx1Y2t5IHdpdGggdGhlIHBvcnQgdGhhdCB3YXMgc2VsZWN0ZWQuDQoNCj4g
DQo+IFdoYXQgZG8geW91IHRoaW5rIG9mIGNyZWF0aW5nIGEgbmV3IGZ1bmN0aW9uIGhlbHBlciBs
aWtlIHRoaXM/DQo+IA0KPiBpbnQgdF9iaW5kX2VwaGVtZXJhbChpbnQgZmQsIHN0cnVjdCBzb2Nr
YWRkcl9pbiAqYWRkcikNCj4gew0KPiDCoMKgwqDCoMKgwqDCoMKgIHNvY2tsZW5fdCBhZGRybGVu
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgIGludCByZXQ7DQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgIGFk
ZHItPnNpbl9wb3J0ID0gMDsNCj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAoYmluZChmZCwgKHN0cnVj
dCBzb2NrYWRkciopYWRkciwgc2l6ZW9mKCphZGRyKSkpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiAtZXJybm87DQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgIGFkZHJs
ZW4gPSBzaXplb2YoKmFkZHIpOw0KPiDCoMKgwqDCoMKgwqDCoMKgIGFzc2VydCghZ2V0c29ja25h
bWUoZmQsIChzdHJ1Y3Qgc29ja2FkZHIgKikmYWRkciwNCj4gJmFkZHJsZW4pKTsNCj4gwqDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gMDsNCj4gfQ0KPiANCj4gV2UgY2FuIGF2b2lkIGNvZGUgZHVwbGlj
YXRpb24gYnkgZG9pbmcgdGhhdC4gSSBjYW4gZG8gdGhhdC4NCj4gSWYgZXZlcnlib2R5IGFncmVl
cywgbGV0J3MgZHJvcCB0aGlzIHBhdGNoIGFuZCBJIHdpbGwgd2lyZSB1cA0KPiB0X2JpbmRfZXBo
ZW1lcmFsKCkgZnVuY3Rpb24uDQo+IA0KPiBZZXM/IE5vPw0KPiANCg0KDQpJIHRoaW5rIHNvbWV0
aGluZyBsaWtlIHRoYXQgc291bmRzIHNlbnNpYmxlLg0KDQpUaGVyZSBpcyBhbHNvIHNvbWUgZHVw
bGljYXRpb24gd2l0aCB0X2NyZWF0ZV9zb2NrZXRfcGFpciwgYXMgSSBzdXNwZWN0DQptb3N0IHRl
c3RzIGNvdWxkIGp1c3QgYmUgcmV3cml0dGVuIHRvIHVzZSB0aGF0IGluc3RlYWQgLSBkZXBlbmRp
bmcgb24NCmhvdyBtdWNoIGVmZm9ydCB5b3UgYXJlIGxvb2tpbmcgdG8gcHV0IGludG8gdGhpcy4N
Cg0KRm9yIG5vdyBJIHRoaW5rIGRyb3BwaW5nIHRoZSBwYXRjaCBhbmQgZG9pbmcgaXQgcHJvcGVy
bHkgaW4gc29tZSBmb3JtDQptYWtlcyBhIGxvdCBvZiBzZW5zZS4NCg0KRHlsYW4NCg0K
