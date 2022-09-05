Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A15ACDA8
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 10:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiIEIcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 04:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiIEIcG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 04:32:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29DF4B4B4
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 01:31:09 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 284Jurdq021176
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 01:31:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3Yc+vBGQRz3my7DPfdDT97/9tSV+cP6gUivFjiGDR/o=;
 b=HnlOB145r82TiXGKQgszeUHQdaPJ8cmEMbz4Bp+9ZPjhimiHByl8QBXgVnhy/5wlsM0K
 c6C72lanlMu4AGo+RurFLuO6PnZ9a4SqRudHd+PmMJU9pk5tW2B3bRUAHoczwH51RGq/
 7il6qnA5QX/HiXdXgKtrR/lzcxIh7VTwTHI= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jc684pwnu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 01:31:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4eD73sZGV5dO9WtucCqGvYaD5/w14o4xsjvhNGGsx2RxIv8wByZmEmAlesCspOnsCfHXEW0n6r/tDSYJjlHCL6IlzT/kqLXfmjX2Dfp+Asy6NhLqP8p3WdEJdvEgiJGziInq8s+AHMjWijr8/GiQe6fzGtfMmvY8O4O/Gsy1JCDyjSc7A5bWWQSBl4CU4lesT/6lYYXxmXJWFFIrpc+hgSdaHMdmUvi06rAjDKGa0tO9JwuQSaw9Lr4n93t/HjVm/wqLILtl2V/MvGURHjoXC7sIGnt3AP+6/3i0ufgXOdqaGbWVkjkbY3AaoDWofZTsxz7HI9YIW7pzASzeJu5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Yc+vBGQRz3my7DPfdDT97/9tSV+cP6gUivFjiGDR/o=;
 b=g0CIsrtYrc+cq1pKAVn6DLh1VMDd2oPeO4ieYzpHy8/keHbH6XB7jcgX+hemp/DOgsvylkAOWoWrUAR6aj2MkBid8x6OwVzEjMOqlLh1N9UBd/oNeVvAgEdcIR0T1Pkj5W7vrj57VemeyV6DQAhKr5q597hwaFG1ned7HOlsPoRo0A8rtNO+hx8t3O1rds6RpAqeCWwYC500litXoUpwQa2I6S/gP2Y//0JxCo1G82eA9/D1HfN1f39tGzofqwe5RYh101/XaNplDPa8Z4UEeD1trmpc4tvspYRLUjNJmIEprAUaSFczA/HaKwERQav4t6iMVNUxJTVc3jOUfwZ6ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN6PR15MB1891.namprd15.prod.outlook.com (2603:10b6:405:5a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Mon, 5 Sep
 2022 08:31:06 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%5]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 08:31:06 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH liburing v2 03/12] add io_uring_submit_and_get_events and
 io_uring_get_events
Thread-Topic: [PATCH liburing v2 03/12] add io_uring_submit_and_get_events and
 io_uring_get_events
Thread-Index: AQHYveXe1HDyV3RMd0CWocXJ1abCFq3K57GAgAWgMIA=
Date:   Mon, 5 Sep 2022 08:31:06 +0000
Message-ID: <32f2a5fae4aefcb8467f16685487da83ff8fec5b.camel@fb.com>
References: <20220901093303.1974274-1-dylany@fb.com>
         <20220901093303.1974274-4-dylany@fb.com>
         <99ee9e0a-4bf2-10a3-b31c-0a58355dece8@kernel.dk>
In-Reply-To: <99ee9e0a-4bf2-10a3-b31c-0a58355dece8@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a49a044-6811-4ec2-11bc-08da8f18fa02
x-ms-traffictypediagnostic: BN6PR15MB1891:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wDzqC/Fg5DW7/nooHJyKqBNiJpZ+o1XPMDSe2vZSWRiFzg9YK4xdJApB3ADkKcQJSfXvFeZpKfjLtB9LNsRAQTke+WgqRfqZdYxCHZcCZifNYTAJM4C5Vie+FJ3rSIj9MrgSoG0bKsw3z2pAdZcqkr2fTtW8eKeRS0soI+4kkAoI8W5bZJPcfwohg0246Aprq8mjdJgiXUaHXDyjXkjApfNOE0yE+vVC3BCh4AC2ZzGCp3BUlqKFTrvPrWildSmoNcZ2RLTLJu4HQvIt3N2S6WxCFUTgfNgvrPWXI6JWRCm7E/d88FYnKOGcohD9ae65EOqrnAi3HClBWJ88sp8cJZOf5z3ZU1dyN2/YhNUfkHPI5F87cKN3QNFW1f39k3z2yvP9kfJ+wVFFBK1GZuYwJWCQigbvVh+Pl2e5iqFXuWMxLjPHhGV0jI8itu5YNfzzeMEu/FJr98qB9tOyv+FBdfCAQDfaFrlLXejWuRgdg1zksvh6yMkPiMMxVBLH8RhW6Fv4DOeV9DBUmlvTDBGEsSwIxOoSXPMjvAPJXQk0j1ltVOY+YGE7hYUDIAbeh/Dvkm/arDUHx2hj2EsNohrIrfkFc72SEVKwq2jcnErbXXRzUOxJDN4AbhFfiUQJCwQ1AEb+qZyXgl1ZPqFkw8dmLXpal57YWQ8Ho9amsB8196GAYc6AXSlqN2JFrzsyYOWPYTx377KiE6A2pDRqy+r/m09CbrwMJS13UKwg4iKwKvn8k2qAEt4fQx9B33uh5jlLdCQN/J8qN5qwIIAYhqd/og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(8676002)(110136005)(71200400001)(6486002)(478600001)(316002)(36756003)(86362001)(38100700002)(122000001)(38070700005)(4326008)(6512007)(26005)(6506007)(2616005)(53546011)(41300700001)(4744005)(2906002)(91956017)(76116006)(66946007)(64756008)(66476007)(83380400001)(66556008)(186003)(8936002)(66446008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVpaaG1ScmxrYmhmcDQ0bklScVduRXNXRjY4aE1md3U0ZEQwaDhhbEtXeTE2?=
 =?utf-8?B?dFVERVNzb3AweTVNeXl4bTMrSk9BYjZGTzU3ZkVhSGlmbXBoOGIyYmY3aitC?=
 =?utf-8?B?V1RDdHlYZU5qNTVDNDlWUmhWMGlNdDcwRUs5Y0tBV1M0dnpOS09DTDhyeEJr?=
 =?utf-8?B?TzFDdTJselNnVmpGbmdQbzkwQ09CejBSenJBSEhoUjdyZ3Q2TVA4bHRMOE5q?=
 =?utf-8?B?c0tQaWpENks3dGI0M0tTdEgvYmNnUVFuaVl4aTRyNjRHcWI0MUxTR1BkbHAy?=
 =?utf-8?B?WTY1bXdmY0pEMEw1MzVqSVprbnYveGFyUGxiMmpMMklXanU1ODF5eFlrR09H?=
 =?utf-8?B?a3lOS2JXUnBDU3NoMUNqK2lLbDEzQUVkazlxbTFzTCt0VzZQWW5kdXA2dlJN?=
 =?utf-8?B?RFJoaHN1dzcrUzIxWlBQbGNyZDU1SWwxSXZ6bURRZWtpTHFCOE00NTk5Zklr?=
 =?utf-8?B?ZnpXT0V5dUxYWVNKOTc1RmFKZmVQMC9JdkxHM0hwVFlQTmNua3dUZTdlV1dn?=
 =?utf-8?B?N1JENGwvK1NzbkdxVHlHdGhtOTNWZlZjbnN6alZzYUJyRTA5dSttUnlZR3dC?=
 =?utf-8?B?U3IxczI3Z2luLyswQnBKeTlRRldTTWpLaHN2VkNOQWloL3ZhUEw5NlRpODhq?=
 =?utf-8?B?anIrdzNSWkZqM1Z0Wno0MEZqS29mRC9WQS9lMERQc3ZqRkRIeW1PeHgzMzFQ?=
 =?utf-8?B?NWR6OVRUOXNsSFo4RldHQ3JaeElOa0htTHRCSEVMZjYvOHVMR3JXM0Z0RFNF?=
 =?utf-8?B?eElaUjNmaXdXT3dsWVZrclYyNmh3Q2paUWM0TnRYUFpMUDNONnZaYU96S21Y?=
 =?utf-8?B?ZHgzN1JZeitLeHVTZytWd1VycnVNNHJJZXVFdkRnUnJhRUtPNVFGZWZ0ZGFy?=
 =?utf-8?B?SkgzSXg0aE05MTMva0lvZXBET1RLbGNDWVMvMjBqemppRTMwR1ZDa0wyOFFC?=
 =?utf-8?B?cWxFUzFpSFZhaDVxc0lZUllsSXZhQTZXTHpvaXVGUTRmODlIOW1KVXl2MExE?=
 =?utf-8?B?TFMxR2dER0pYYWNwZ1QrbmZlRTBtV0daS245RWJZcmZBd09wb2lwcStsN1lO?=
 =?utf-8?B?T1pkNHBlOVNQYUp4YUdHRVFlSmQ3cXp4dTdFY2FRTEQ5a1pSMU00NlY2c3Z3?=
 =?utf-8?B?NXFvNWlYVDZPUFYvYkNEVEhaVzA5V1dqbFI2VmE3K25heEZDcEpVZFhqNXg1?=
 =?utf-8?B?cHkxOHYwUEdJZXg3NUJETVVHTTZGczZPc294amRuc2J6SjNOZTk2Q0pWUEd4?=
 =?utf-8?B?bXB1MERzMUtiRUtXR1IyOXRuK0Y5T2Y2TlFMWE5SaUs0VUcwTjNVZ2ZGeElX?=
 =?utf-8?B?UFZjWWM0dWdsZmxiR2l3QWp6clZYeFJSTVpocHpjYkNjUFZrV3JUTnJHVUZl?=
 =?utf-8?B?YW9McGR6YTE3WU5KZHV1NjhKVVZFRjFmQmJubzNKSHRFTDhIZGNXb1pOQ2tD?=
 =?utf-8?B?MFJlVGJXZ21Wais1ZlcxUXRwM1J6S1pMSTg5MEhZMEpsSFZTeWw4TVpneW5w?=
 =?utf-8?B?SjNDWm9qSzRhMTJsVFlVazVtdVBIeU5yY1IvNG16UERZeGhvYXVlUjFmTXpT?=
 =?utf-8?B?dkxZd2lOOCttbHd4a0NkYWtNVGt0Wk1YMXN6UW5EbUlXODlYWmIramg3WS9v?=
 =?utf-8?B?R3JwQjNLWGsxcUZCVDZLSURTMFRBNFZJblRqZFRjV2Zmb3hoQlZqK05tSkVI?=
 =?utf-8?B?aC9BSEZ4U0tXQmFmK3lKdUZpSzZXWWJEUG00TE1RZnNkWlNONEM3NkpyQlJS?=
 =?utf-8?B?U0dnNXFNZnZJbktUcjllRndyZWZ3QWRoVlIrbnJNRktManZ2R3laTFNIRUlj?=
 =?utf-8?B?UTYyVE03emE3eHgwVEZLQnVFN1N1dmdQeFpKUnZpa29YVnl5NUE4K0duVk9n?=
 =?utf-8?B?ZG5hek5hU0ZaRzhndC8rcmo3QldsSTZWVHIzVGZjbWhQS1NESE12S2toemxz?=
 =?utf-8?B?OGFhOWVOV0NVbUFiRkFYQlpqNm1ZSStKZU5vTnovb0xveHM4ZytMNm9iK1pT?=
 =?utf-8?B?YXN1WlJUWjRMckxrcElTQmk1c0RNNldjQ3RMNjU1M0RDUUh2ZFZicW10VFNC?=
 =?utf-8?B?TFpSZHFub1RCTHJHUHlSZEhSS295b2FCTllMclZIVUtBWVpTNjh0SUYxOHJM?=
 =?utf-8?Q?zXF/EwVKVnB1kcc3wTD7xB8OJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <229E7A309FB72E43A767529710C4404B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a49a044-6811-4ec2-11bc-08da8f18fa02
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 08:31:06.2617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7KROeWPyb5ktTOssAI5ArHkqH+XHS3vyZ8ohH/LplqR+CZ7calWfKzuFZlruI4l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1891
X-Proofpoint-GUID: 3TNlwi4QVJOVLEEliam2_SM1tVREIf-9
X-Proofpoint-ORIG-GUID: 3TNlwi4QVJOVLEEliam2_SM1tVREIf-9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_05,2022-09-05_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA5LTAxIGF0IDEyOjM2IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA5LzEvMjIgMzozMiBBTSwgRHlsYW4gWXVkYWtlbiB3cm90ZToNCj4gPiBXaXRoIGRlZmVycmVk
IHRhc2sgcnVubmluZywgd2Ugd291bGQgbGlrZSB0byBiZSBhYmxlIHRvIGNvbWJpbmUNCj4gPiBz
dWJtaXQNCj4gPiB3aXRoIGdldCBldmVudHMgKHJlZ2FyZGxlc3Mgb2YgaWYgdGhlcmUgYXJlIENR
RSdzIGF2YWlsYWJsZSksIG9yIGlmDQo+ID4gdGhlcmUNCj4gPiBpcyBub3RoaW5nIHRvIHN1Ym1p
dCB0aGVuIHNpbXBseSBkbyBhbiBlbnRlciB3aXRoDQo+ID4gSU9SSU5HX0VOVEVSX0dFVEVWRU5U
Uw0KPiA+IHNldCwgaW4gb3JkZXIgdG8gcHJvY2VzcyBhbnkgYXZhaWxhYmxlIHdvcmsuDQo+ID4g
DQo+ID4gRXhwb3NlIHRoZXNlIEFQSXMNCj4gDQo+IE1heWJlIHRoaXMgaXMgYWRkZWQgbGF0ZXIs
IGJ1dCBtYW4gcGFnZSBlbnRyaWVzIGFyZSBtaXNzaW5nIGZvciB0aGVzZQ0KPiB0d28uDQo+IA0K
PiBXZSBhbHNvIG5lZWQgZ2V0IHRoZXNlIGFkZGVkIHRvIHRoZSBsaWJ1cmluZy5tYXAuDQo+IA0K
DQpPSyBJJ2xsIGRvIGJvdGggb2YgdGhlc2UgYW5kIGRvIGEgdjMNCg==
