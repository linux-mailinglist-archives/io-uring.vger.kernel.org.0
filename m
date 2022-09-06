Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0745AF287
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 19:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiIFRaP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 13:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbiIFR3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 13:29:47 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C028381B1D
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 10:22:36 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286F2mE4025887
        for <io-uring@vger.kernel.org>; Tue, 6 Sep 2022 10:22:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pV9zkOKz4lSDHSWcJx47oLBPM1DxagfM8jVpLAi0JpM=;
 b=PzyITQDg9RyYxlWmMqezjfyrgUoJllxD5JPgk9LvdlOElayaCW+dMRwSRsWAQwmeQvWN
 grtQ7TdyfPbIELgXXyMPRbzeaSMjKeu6lMvVlCNzOKFp+75YT8J7LYhT6bPVK7w08OlT
 QtD/PddgCuP1qkd92RZopvPAw2Jy/lE0OVo= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3je3hk2y9g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 10:22:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knY9V1zi2OUQ+LN9PqJPaJflfkHrJzeWwyK8U0AGZpr7lnXRlP/E5KA4TbtKmWDSYI/C6ohzO+4bNkj7oH8ovwcGP3oM/ZKpST504eBsyU4Elonr/5WHv4Jk2l/Z+86ziH1A3+e2c7Jp4oJzZo7rxHK1isxaTNnDGjExbYlLjkOg6QTud5YaH3sXktk+TlabWcjmuWuzF1O/ltRnOgcvSP+aczJIGI5MbiCuWNYBflPNQbRnFNyfOruPraxXeFN6fl/q6pGeFa5nSnF7bnso8sEHHNJXXUVFINN5hlkm6X99K/KT9caUd3ih/GhrATQnmXQNQUxi1iKij5K7TiCI+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pV9zkOKz4lSDHSWcJx47oLBPM1DxagfM8jVpLAi0JpM=;
 b=I0B5pc8Gk3eZXTkR7Eko9JKpykQH/qU3ArXBmmAuwvbcUNYDyYSudxKgsd7p3USuVjCBmMRQWsiy/hemRLVXpuW20bQU7vq3VpNU/KOWTVhHIVKvqYHr+/hat+Lb8PGD3BnSucT60UrQSTJQNOqIIODB9IZ9SlXj5fnipLCn7bnaS/Akyx5763Qv/FHB2dz0ko2mTEQ6vqsRMKqKPjqSctfmQxvKErhUjWy9oBb2o/ys9cgjmUYfeOdZE/Emk/RffPTYFaFKEt3q1Tpc3gyNb4b7X8NACL8lBX898IDI1p8FZCQnZ5TG7677VaI9hH6pDWueb0p6AgFIBRRWcINmJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB5046.namprd15.prod.outlook.com (2603:10b6:806:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 17:22:33 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%5]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 17:22:33 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] io_uring/kbuf: fix not advancing READV kbuf ring
Thread-Topic: [PATCH 1/2] io_uring/kbuf: fix not advancing READV kbuf ring
Thread-Index: AQHYwg8DR3KAOUf41Eizh7N/CQLo+q3SpmAA
Date:   Tue, 6 Sep 2022 17:22:33 +0000
Message-ID: <8ba31b131b0f47e91417009472df962185dec681.camel@fb.com>
References: <cover.1662480490.git.asml.silence@gmail.com>
         <a6d85e2611471bcb5d5dcd63a8342077ddc2d73d.1662480490.git.asml.silence@gmail.com>
In-Reply-To: <a6d85e2611471bcb5d5dcd63a8342077ddc2d73d.1662480490.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ad34a90-6264-49f2-dcb5-08da902c62eb
x-ms-traffictypediagnostic: SA1PR15MB5046:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vQCyK5dp2xBbcesdoLEGBoz3Huj7XdRdrrpkaAXrgBbQaL8/SFqHBQ4OFiYEYj2fXykfbKFR/tfcz1zECIng60d7LuMFrOmhv+Bvy0kq2lZOHCXoxVHCh0jorQt7HYX1eoZeS+y9AJhPjXdJclfvEs4kb7UOBIM74Zxm4IgThKafr95jDZIN5RMMyrslV4q2vnhZBLN487vOpNdq8Mn83kuDJ16hYC2AUKJAD+fcgAIxCJlSh1mnksYN/Yt4qV4Mycyhs9v4QqkKogZ2eBZNbfqYXxxE7xQ4Arr1+aaS82pupqpdAAAiUEr74nGl5YO4MgsBWmqDpM2ASdbJrss6NdFNeImQWL9yuBRgMvyUfTxMWrmbI1Iy6a+2EP3qvbLRSLJPBwqagVGLaA+O0RFikfns/v22uXu2eQmGgHuJMlEYdvRooL/JRM6R5IqVr4tL4zSHke4WQyJlLo3af+HFK+W72Nx3cLOibOpBmi7zsw7Cnn0zxPwkXBTGXSMTOfPIgqzUWxPOdAtjGkTW4jraNNbFtN0Q/Rmo6AcFQvabcwe9ACNeZSMcYBCO6GNmchnA9TTKU7WVExApOUgda/+b/6018yKwChYRtccjKA/xJwM5Gwvci4YhrwkdkSeQ+qk1tgpt9X61ckFjvvP48gD6HwpA322ZaG/5xa5GoPFhQb6VJZBFZPIKGj7v69vggfbFCIz27cy7wHI+pvzmjyuqoj3SvIi0Z3UqeVDcyNVY81jN1LBWZRS14lsz7aGlQrBHi4h0nxah7aVbTHxXwWlU+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(91956017)(66476007)(66946007)(8676002)(76116006)(66446008)(4326008)(66556008)(316002)(64756008)(110136005)(36756003)(86362001)(2616005)(26005)(6512007)(186003)(83380400001)(8936002)(38070700005)(2906002)(5660300002)(41300700001)(6506007)(38100700002)(478600001)(6486002)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUNDaG9LYVdPY214TXBKZ2grUUM4U2Y3QURyVXJqd0lHQ1lNQVJBdW56TXpK?=
 =?utf-8?B?VUx2QnN0UExMMFdITUJGaXpUWVN2endPRHpjMEI2OW4zL3BvaG9QMEExOXlW?=
 =?utf-8?B?L0NGd2pDK2x0YjJhMERjNUNGakVsQUZsUW1mMXVBYjVUd1pRQ0hTT09mOEl4?=
 =?utf-8?B?UEw2OFkxMWtSVW15SjFaWlc2WUhBUnkvdW1rMjROK2UxTFJzdEhTY2pVL0Vj?=
 =?utf-8?B?UWptTlJMQXR0QlV5L1MzVmdQTTRHRkVoRHBSc0VXdzVZdnFuUzRwK0VhQzM1?=
 =?utf-8?B?TjQ1VlEwRG9zYmlvZmNPUzlQWEc1bEpxUWFJNXpXM0JaY0dxZ1J2R0E0V2JL?=
 =?utf-8?B?ZkNsanVxeGN1MWZwdHB0emdMTDBocEpRSUhUZGNiTWFHQ1pXVmNQc0ZwQ3d0?=
 =?utf-8?B?QVhoM2MvcU0rd0ZDamQ1bW5EbHIzMDhmWXNVenVBTEdYQ1hYKzNUalRicVM5?=
 =?utf-8?B?YmRsYkd5RXl5ZXBkVTNTTU5IRmdLUmlmdjdYbnVpdlNpYTYydEQzdzBXbCsw?=
 =?utf-8?B?T3pxVEVWQkhzSWIyYitpdzNWc28zcHpsSjhBWU9zWTltWi9JeVRsN0xXU1dO?=
 =?utf-8?B?UzFZZitxWmRWWWNNaWVPMGlyVmM2NFFxRWZUR0pOVXlXdDEwOTFqZXJxM2JX?=
 =?utf-8?B?Y01id1d2azlKaHFyYXFScVRtWUU0Zzc5Z0pzdFJPN1lnSFFHQnJwcTRmcVdy?=
 =?utf-8?B?Z0FQblZQQy9kbzBqTnJSYVpzZi9YNEZsbDJIeXBZRWV5MExZQXZlVitDdDJC?=
 =?utf-8?B?TXhhVUp4bHlXNnlBcVJIUkZUV2tqNnF5UWc1a25RUFE2SERPc3dQNDNVdnJj?=
 =?utf-8?B?djRYNS9DT1pBckM1anpSblFFSGg0bmdEdnVDelBQTnJyUFF6SEFkRlozTksr?=
 =?utf-8?B?OFI4WTJGK1BKbXlTbmxQc25makxOZVVZOTFDVFZ3ZEVvcWVFQWFKdGZnMUFT?=
 =?utf-8?B?M2tVd3FaSjZRTW1zY3U1R1ZaTndGbFdmVVo3R2QzaTlXNVN5U3Z2S3U5cFhH?=
 =?utf-8?B?UlBzdWJybThUOFhEN2szOEpTZ0FYK1F0RTI0MlRXZjl0SUYrMkJ0MjJHcGZx?=
 =?utf-8?B?VFhhaWpIM1hkZ0d1YVUyU1NCVzNJMTcxNmQ1OWc3REIwOXQvaWwyMjVOaGFu?=
 =?utf-8?B?VXJIWVdyL3pYZDFoUlpZOE0rN2dad3Q4QSthNGpFVTM1QzRnRFFEMDdqbjd5?=
 =?utf-8?B?MXdKVVEzZzlEWlhEU0VteWN2aFQxSFhUM3hDWDR6dkp6Z1NOeWlWc2xFRzI2?=
 =?utf-8?B?cUJNS2I5clBTdDN3TkVLRTloc252dXJ3R3pYT0VGTnp5ZVE0VlpGbHdDR3l3?=
 =?utf-8?B?Y2o2TjZ2TEVLcmNQSS82ZmtRb2RLbUpvOWNCM29WVllhUW5TRGp5OG5sWW9a?=
 =?utf-8?B?dTR6M08yZGpHa21oZlY3Y2dlRjhFcStselBURWFHdWdEYzFkL2MraXNuQXQw?=
 =?utf-8?B?NXZPdWR0WGZYK0UzTFVMSVJLQjIrWUhRZ2M5UDNXQ0hLNUt5TWdOOWlLSVpX?=
 =?utf-8?B?VUUzTDFoQzdKbE1tQjhld2M1RnJqa2t4dlZFT0w4K0Ridy95SUxzdXY4L1F4?=
 =?utf-8?B?ckpGNTUzM3hGejRkT0V4dThoSWEwUGhqd0FzNU81eVFXZnN1cFJpTlRLZktL?=
 =?utf-8?B?aUxMbTd2ZnppcGg3RS9QOVhVVXE0d2R3MnpQYXVwMlQyUGo4WXF0TDNZcUFO?=
 =?utf-8?B?bzJSR1J0clhtMW1nRTZvTGRORmpkckFVb083ZWZNckRRQldGRVB0ZUVsdFRX?=
 =?utf-8?B?Vm9oY015dmtuek5lQVZJK3dSU0JKNUFDa1ZIQk9TRURXMjBjTjNiYmpuU1px?=
 =?utf-8?B?TCtNdXcrZ0ljRmJNa1J0b0NsaDMxOEFwU0FJbXA2Vzk3cGtMcms5T0hZVExB?=
 =?utf-8?B?MlkwV2FIMC9SeXNMcWErN2o5aEN2cnBDV21LK1FjdEZqWFo1TWl3OXY0ZS9V?=
 =?utf-8?B?Q0NqTVRDTHNuK2J2VE4yKzhwTnJORXlLbmJwT2FQeS9JR2hSTGlwNUtteG1S?=
 =?utf-8?B?QThBMGtiN1dvM2xtWWc0WWxyZ0p5Y0QxS0JCWWJRL1BPOEJpQUVKTituL3JH?=
 =?utf-8?B?L1U1b1BlTnIyWHRZaHFVSkJOclVWWnFRbDkwRjR3OCtZaGVnN2J5ckY2a0p1?=
 =?utf-8?Q?MV8bHyhwNlJLqOU+4OAWPjyjA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67FC93EF01654749944C08A05F1568EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad34a90-6264-49f2-dcb5-08da902c62eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 17:22:33.5192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yn0s4gJ86s5STcap2p2oeLh/oNgdZGrXglgXG5H4Bw+wMRcARvRS0newcjTTDNBV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5046
X-Proofpoint-GUID: Q4lITdpN7vCSdoyuaBcKApWYrReD9suB
X-Proofpoint-ORIG-GUID: Q4lITdpN7vCSdoyuaBcKApWYrReD9suB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_09,2022-09-06_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA5LTA2IGF0IDE3OjExICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToK
PiBXaGVuIHdlIGRvbid0IHJlY3ljbGUgYSBzZWxlY3RlZCByaW5nIGJ1ZmZlciB3ZSBzaG91bGQg
YWR2YW5jZSB0aGUKPiBoZWFkCj4gb2YgdGhlIHJpbmcsIHNvIGRvbid0IGp1c3Qgc2tpcCBpb19r
YnVmX3JlY3ljbGUoKSBmb3IgSU9SSU5HX09QX1JFQURWCj4gYnV0IGFkanVzdCB0aGUgcmluZy4K
PiAKPiBGaXhlczogOTM0NDQ3YTYwM2IyMiAoImlvX3VyaW5nOiBkbyBub3QgcmVjeWNsZSBidWZm
ZXIgaW4gUkVBRFYiKQo+IFNpZ25lZC1vZmYtYnk6IFBhdmVsIEJlZ3Vua292IDxhc21sLnNpbGVu
Y2VAZ21haWwuY29tPgo+IC0tLQo+IMKgaW9fdXJpbmcva2J1Zi5oIHwgOCArKysrKystLQo+IMKg
MSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZm
IC0tZ2l0IGEvaW9fdXJpbmcva2J1Zi5oIGIvaW9fdXJpbmcva2J1Zi5oCj4gaW5kZXggZDZhZjIw
OGQxMDlmLi43NDZmYmYzMWE3MDMgMTAwNjQ0Cj4gLS0tIGEvaW9fdXJpbmcva2J1Zi5oCj4gKysr
IGIvaW9fdXJpbmcva2J1Zi5oCj4gQEAgLTkxLDkgKzkxLDEzIEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCBpb19rYnVmX3JlY3ljbGUoc3RydWN0IGlvX2tpb2NiCj4gKnJlcSwgdW5zaWduZWQgaXNzdWVf
ZmxhZ3MpCj4gwqDCoMKgwqDCoMKgwqDCoCAqIGJ1ZmZlciBkYXRhLiBIb3dldmVyIGlmIHRoYXQg
YnVmZmVyIGlzIHJlY3ljbGVkIHRoZQo+IG9yaWdpbmFsIHJlcXVlc3QKPiDCoMKgwqDCoMKgwqDC
oMKgICogZGF0YSBzdG9yZWQgaW4gYWRkciBpcyBsb3N0LiBUaGVyZWZvcmUgZm9yYmlkIHJlY3lj
bGluZwo+IGZvciBub3cuCj4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDCoMKgwqDCoGlm
IChyZXEtPm9wY29kZSA9PSBJT1JJTkdfT1BfUkVBRFYpCj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJl
cS0+b3Bjb2RlID09IElPUklOR19PUF9SRUFEVikgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpZiAoKHJlcS0+ZmxhZ3MgJiBSRVFfRl9CVUZGRVJfUklORykgJiYgcmVxLQo+ID5i
dWZfbGlzdCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmVxLT5idWZfbGlzdC0+aGVhZCsrOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmVxLT5idWZfbGlzdCA9IE5VTEw7Cj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
bjsKPiAtCj4gK8KgwqDCoMKgwqDCoMKgfQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocmVxLT5mbGFn
cyAmIFJFUV9GX0JVRkZFUl9TRUxFQ1RFRCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGlvX2tidWZfcmVjeWNsZV9sZWdhY3kocmVxLCBpc3N1ZV9mbGFncyk7Cj4gwqDCoMKgwqDC
oMKgwqDCoGlmIChyZXEtPmZsYWdzICYgUkVRX0ZfQlVGRkVSX1JJTkcpCgoKSSBkbyBub3Qga25v
dyBhIGdvb2Qgd2F5IHRvIHRlc3QgdGhpcywgYnV0IGl0IHJlYWRzIHRvIG1lIGxpa2VpdCBpcwpj
b3JyZWN0LiBJdCBzaG91bGQgcHJvYmFibHkgYmUgYXBwbGllZCBiZWZvcmUgdGhlIHBhdGNoIEkg
c2VudCBlYXJsaWVyCnRvZGF5IHRvIHJlbW92ZSB0aGlzIGNvZGUgc28gdGhhdCBiYWNrcG9ydGlu
ZyBpcyBlYXNpZXIuCgpSZXZpZXdlZC1ieTogRHlsYW4gWXVkYWtlbiA8ZHlsYW55QGZiLmNvbT4K
Cg==
