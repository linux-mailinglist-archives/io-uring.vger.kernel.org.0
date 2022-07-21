Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD42257C809
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 11:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiGUJsh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 05:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbiGUJsg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 05:48:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11A4814B3;
        Thu, 21 Jul 2022 02:48:35 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26KNtFbo015305;
        Thu, 21 Jul 2022 02:48:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Tz3WkHUX+a6PON7aNRbQJ4kWHMzQhyYEh/w2Cs2+Vbs=;
 b=CJU+9hy/XUjsZRMr+ayJza5Vv2iU6MRvdTpnocZUkzA7NZRdG2OIJnDEBxfOTdMIge6Q
 DC37Mck3Bl8fGpgQ3MdKKJXe4nOE+s+ygRR6p7tijfxO/xkpx9sm+vg+/XvNLvMCIpde
 ReP1wac2Ic8VvjD9SLjHWdlYJfRXYe2cMro= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by m0089730.ppops.net (PPS) with ESMTPS id 3heut3a7ak-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 02:48:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUTlk4S2JIs6HnF+u1fdPcFAE68YzKmrRvUmOo0FIfOQGAHbyAiILf4EyQ8jcYItTMbbZameVCAbYBJFBqpudubAdeanjpeDtGYZHvEldwHNJxzOQL97SYV2rxfmSE0OuoLi9ENceGGIf/bAgfY60JL17krJ9JyN0DW6A3GfKqsEoyzXD+5xLa6aNIiTRHFyVzX7DC9kISohvgVbCWFO48+YMY1iGQfKQEuVk0yEfT36aE9sbunGmAtxL/kJkqExZv5cSxaCmo9Zh8yV+3HPMPj0QSmrbIaqIKibm87AyGbQLvz7V4hgh324UfQkuz9fxuOnvJgKgcmWrlvf0/gHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tz3WkHUX+a6PON7aNRbQJ4kWHMzQhyYEh/w2Cs2+Vbs=;
 b=iUMWEJsj8K9qQ0495Ck7K6Gl/JNxmzyz92RfCwzQIEK72aEBgm24QaSZvos7hP+yN5WvY7ElNouymiVDnv53wNfxNEzp7CDNWYgJrMWPc4kaa5Op7hM4xPY3X6vTHkE2KkxABrC+HbOG2sucsikBUs9MfS/9QLu3X1jy0ktiEsZJ3jb6cVBSgC0g/ID+1tIzPt0aW1X3xmrOgLbit4d7WXDfnNO9TaVkMvmEzLBdnPSFoXqJTOKzfWX+9opkuNTcFQZeqBwZoov3mlKOKNGHdd2pJ58FcEJzd1v+uCz0XOGutwAZOl0VMLFxW4kRB7deOrQ3Y5bbG0ScKCVkYlT7Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SN6PR1501MB1965.namprd15.prod.outlook.com (2603:10b6:805:3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 09:48:31 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 09:48:31 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "gwml@vger.gnuweeb.org" <gwml@vger.gnuweeb.org>,
        "fernandafmr12@gnuweeb.org" <fernandafmr12@gnuweeb.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Thread-Topic: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Thread-Index: AQHYnI+FXh38kPC/ekCuYW7IUr0g+a2IlPEA
Date:   Thu, 21 Jul 2022 09:48:31 +0000
Message-ID: <3489ef4e810b822d6fdb0948ef7fdaeb5547eeba.camel@fb.com>
References: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
In-Reply-To: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f71f948-1339-461a-2203-08da6afe2bfb
x-ms-traffictypediagnostic: SN6PR1501MB1965:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+OJtiZcPf5MCg/X2pmsSdUaZQkZnCBFTmGSlCtUbtKKNtYG2B0Va/kbfFlvXvxRcCnh6PsAMqKCpzVZpdLRnQLr4HAQjfgBoikcvLdEwOe0E0wYzIr4rUVbhP5GTwNnTHKS8t816moeZZ9KUkVqUShqC2Z68FjTEZjXdE5u0xBNbVvq7JA6qWX37hmIIrC2Z5dRq3v521mv8FKfy23SpxAGfgF9vAKLyfDq0Qx8qCwchF6IZdeJn91j/gxcwWIsOJvxq3VtRLug3AdhYIZTVbupDjy9jtmtXtON8c0yocvpTtbhiF0rM17j4JyrKXL7NArC18Lxf4paj/QQYl8BvKbao5zTQ4/XNFLsAW/AY7xcmGv0ABaS5gF249LWX4NzYL4Q/19OWp1mUlOGE/AXf4Nn0SIwLdV2XGvVNWheP+lVf3IIEPXHr6dhUhP4eRkokw1MimNQIxywFP1TNSMoxvX64CWOg13fyc+3Pzc/+xI+ATjivWV79ol4zPAxceWHEw+/jU2ucHHKAdKIJ8/IIugQh284/tILg222rv0e84D8qw41tuFYKLuttFsgWHNs2c+Vfs9+prQN3Qc1LHq9aarKca1pQ+csS/8auPJQuZdd16yAcinLhigvuiNZkLMPrvHEey5tj22P8fUwm+5tiqC8VeCHBYr/XBzMAMNh0G+smoN4fq9sV9l7z9vBQdYPrkiHfp9j0D0j3q16NRkzI/Lva1+cz4hnrwutzq+Duj+DuXdrJeUU/bX1J7TPWG1Uusqppgs+tpO4j3CTjzevSWLlvLq33y+uXNlGpUmnuAbpgW69Civ8KLACBoXfx/0EFiSahfrkPggF+xZEnqsm5fXJlqxkWILg5z9ghhegoZw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(71200400001)(6486002)(38070700005)(478600001)(6512007)(966005)(86362001)(83380400001)(41300700001)(316002)(54906003)(186003)(6506007)(91956017)(66946007)(8676002)(66446008)(5660300002)(66556008)(66476007)(76116006)(8936002)(64756008)(4326008)(122000001)(36756003)(2616005)(110136005)(2906002)(38100700002)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3dMa0tjTTU3RllFdU5hSWNXT29IeEZEdXZiYkczRkhYUHZnblh3VlFWQmM0?=
 =?utf-8?B?M0h3Y1NnM3Fac0RtWlNCQkdNRlo5cnphMHBDdGQ1WjBETGJGTXBIQWRLZG5u?=
 =?utf-8?B?MFJjRWlLZDIvSmpUWnFKL3FaQXJFSHVVT290OUNmYzdOVHVZZkJ0ODB6bmE5?=
 =?utf-8?B?VVE4eGxsZXlRR3haU3Ftck5maW9KN1VpSG95a3FHWWtKWjdGYzcvWElvVXpL?=
 =?utf-8?B?VG9QaVM5dUROY25xVjBzY05LV2RrVWZSTHFPc3pEc0h4eXhmaVdHTTNoMGtX?=
 =?utf-8?B?RkRqSUtMMzRxTHJUSVJqek5Jcmx5dU1SRDRuVHB4RVUvVERVdFBaWkFGMks2?=
 =?utf-8?B?bFRxVTFqOTI0VjVYd1VjZGpLRmJvcjkydXlmbWdoNER3OS9INFV2OTNkemR6?=
 =?utf-8?B?a1JzWjNhdVVlcFNZN1ZKMzZaWVkyVzVtNzhvNmlWODNGWkxnOVlURU14blc2?=
 =?utf-8?B?eWhZOEk1SnE0QTRkdWlhb2l1bVd2eDFKMEpNaUMrSnFmR1FRdFpoM0FtSk5F?=
 =?utf-8?B?cG0wdmVUMi9FcDA2NFhqNjU2TUtRSGlsUTlwc3hQZk9QKzVNcHVqVnJtU0Uz?=
 =?utf-8?B?blhSWE5JN095NXllKzNQYzhmTkJKWmI3T3lieitwWHl5VEQ5Q3hmM2xHK0ZJ?=
 =?utf-8?B?REw3VEFFVG45SlUrNk1UcnNtSEs1bE5LMTJ2SlVyZDdhcHN1aWlQa1FxcmlL?=
 =?utf-8?B?ZGFreStNTXVrNDRYd2g4blRBVmJ1OEpiNjhqeHZIR0V3SEdOZllYOGJkeE9n?=
 =?utf-8?B?L0ZVODRwU25JTDM0VjNXaTFsbDhraEE1VWlUNllQV1dRUGJxWkoxVVk0elhi?=
 =?utf-8?B?RzAvMHRxUlBLZFNGd29ubENmUFRuSE92cGRIMUhxTVRJLzJqS2J2ZG00bTU0?=
 =?utf-8?B?bDNZSk9kdVNtV3BCNENmaXdzZUFlVGhyZU11ZjJlWHJPVmpYSzRhVWhtRi9T?=
 =?utf-8?B?ZjlFZG55SUx0ejB1WGtEMlh6NFlrLzJlanVyMnZySjBHaXhoRjNsRmRYY255?=
 =?utf-8?B?LzVWSFhhV3ppQjZTZ2F5YlNSbkJQWFZNZUhGQXpwMFFPemJyUXAwdWdQcE1H?=
 =?utf-8?B?bXQ3QUlEd3RZLzFKaENRMjlJMVhmV0F3czdTdjhqVUpaMGhKZFUvdGE1ZnNY?=
 =?utf-8?B?Q3NJb3VEN25UU0pKNDI5M3kxcXZMVDkwVXNTUHZSVkgxVkMrQ3Y4N2pYdG5O?=
 =?utf-8?B?aU5ad1pXSC9yQjNaTEROZit5RWdEb3NwWHlzSWdrMzg4alNleWhSUlB0U3hq?=
 =?utf-8?B?L2VRR1NLRWpna1piVEErYURoVXJWd2M2bVZuM0U0bEZWRjlnMUN5aTJIUjI1?=
 =?utf-8?B?d1FLcnpzN1BBVjVrRVV4d1hkd0JiVStJaGs1LzhnL01YNTlNSmRiMzZSbWJj?=
 =?utf-8?B?c2k1NkR0YlRmekVMMUgwTmhhN25UWG51R0R0WnprVDVXSVN0UklsTGorckFZ?=
 =?utf-8?B?KzVZY3ZadlB3UlVUY1pKNUtTbTNzcUNMVG42Y2lic3Y1aUZBU09NNU4xeWJB?=
 =?utf-8?B?bGtmQjB0YmVWaTF5bDcwOGNESStJODJ4MnN4cFcwQTVnZmNCUHAzNWk0QUlH?=
 =?utf-8?B?dGlTZHZ1ZklOQVFQWHE4cW1yUURSL2p5VnFqMTVyT09sRkdpQ3F0dWNkUjBy?=
 =?utf-8?B?RVVGdlZXaS9YRGtubjNIemZkeDRMcWFkR0lLUURPRy9DTkNvRnJiWjUxWC9j?=
 =?utf-8?B?blRrbnZVU3E5SXc4NFhEZytqbFNjVlNWRkI1cmt2Q1pPZEhwMFBOSjNqNnRt?=
 =?utf-8?B?Y0pXa05xM3pROUVGZThtakE4cDhsRmd4dlpwYlJ1UExYVG04SXlZall3ek0v?=
 =?utf-8?B?dHdHTEtqRmkxNlNSL1VuUEIrVUtqakhsRGVOQnR3Tk5NU0dZOVdWcWVPckZS?=
 =?utf-8?B?S1FReitUVk5ZaHRhTU04dUdPZ1k4YlFYTWhMNzZ1VE8ydElNZFN6S0VFZzJp?=
 =?utf-8?B?TFM3SFJSekJJeHM3YXZNdE5BcUQ0UDBkTVczd3ZBZkNLajFIcWIzR09TRytu?=
 =?utf-8?B?N3N3aFJoL09MNUNsSmZsZHVDRHlxK0FyWEdQR1ZpRis2RXVTUzQzYkoycEJU?=
 =?utf-8?B?Q09EUFgyZnNVU1dya0dWVmdlNmFNb3I0REZiUUVFNHRDMWJGYUE0Y3gyMTVh?=
 =?utf-8?B?b080MjVnUStVZkhtTmNWZkkrelhUMXJMYkEvQTd6Q2owaTZIQkhnU0UreUlK?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F15BAA4FC22B1547943E7CFDEC37762C@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f71f948-1339-461a-2203-08da6afe2bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 09:48:31.8306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mv8uTLBgXMFVFM9jOHzq09KuwOCq/EN6uHzcuXBlgN0fdwouKo24FMTxluyKcT0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB1965
X-Proofpoint-GUID: YMtfe1mKmdUWAqwJA1ULtQkdYeyttVAu
X-Proofpoint-ORIG-GUID: YMtfe1mKmdUWAqwJA1ULtQkdYeyttVAu
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_13,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTIxIGF0IDA2OjIxICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
SGVsbG8gSmVucywNCj4gDQo+IEtlcm5lbCB2ZXJzaW9uOg0KPiANCj4gwqDCoCBjb21taXQgZmY2
OTkyNzM1YWRlNzVhYWUzZTM1ZDE2YjE3ZGExMDA4ZDc1M2QyOA0KPiDCoMKgIEF1dGhvcjogTGlu
dXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiDCoMKgIERhdGU6
wqDCoCBTdW4gSnVsIDE3IDEzOjMwOjIyIDIwMjIgLTA3MDANCj4gDQo+IMKgwqDCoMKgwqDCoCBM
aW51eCA1LjE5LXJjNw0KPiANCj4gbGlidXJpbmcgdmVyc2lvbjoNCj4gDQo+IMKgwqAgY29tbWl0
IDRlNmVlYzhiZGVhOTA2ZmU1MzQxYzk3YWVmOTY5ODZkNjA1MDA0ZTkgKEhFQUQsDQo+IG9yaWdp
bi9tYXN0ZXIsIG9yaWdpbi9IRUFEKQ0KPiDCoMKgIEF1dGhvcjogRHlsYW4gWXVkYWtlbiA8ZHls
YW55QGZiLmNvbT4NCj4gwqDCoCBEYXRlOsKgwqAgTW9uIEp1bCAxOCAwNjozNDoyOSAyMDIyIC0w
NzAwDQo+IA0KPiDCoMKgwqDCoMKgwqAgZml4IGlvX3VyaW5nX3JlY3Ztc2dfY21zZ19uZXh0aGRy
IGxvZ2ljDQo+IMKgwqDCoMKgwqDCoCANCj4gwqDCoMKgwqDCoMKgIGlvX3VyaW5nX3JlY3Ztc2df
Y21zZ19uZXh0aGRyIHdhcyB1c2luZyB0aGUgcGF5bG9hZCB0bw0KPiBkZWxpbmVhdGUgdGhlIGVu
ZA0KPiDCoMKgwqDCoMKgwqAgb2YgdGhlIGNtc2cgbGlzdCwgYnV0IHJlYWxseSBpdCBuZWVkcyB0
byB1c2Ugd2hhdGV2ZXIgd2FzDQo+IHJldHVybmVkIGJ5IHRoZQ0KPiDCoMKgwqDCoMKgwqAga2Vy
bmVsLg0KPiDCoMKgwqDCoMKgwqAgDQo+IMKgwqDCoMKgwqDCoCBSZXBvcnRlZC1hbmQtdGVzdGVk
LWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IMKgwqDCoMKgwqDCoCBGaXhlczog
ODc0NDA2ZjdmYjA5ICgiYWRkIG11bHRpc2hvdCByZWN2bXNnIEFQSSIpDQo+IMKgwqDCoMKgwqDC
oCBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBZdWRha2VuIDxkeWxhbnlAZmIuY29tPg0KPiDCoMKgwqDC
oMKgwqAgTGluazoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMDcxODEzMzQyOS43
MjY2MjgtMS1keWxhbnlAZmIuY29tDQo+IMKgwqDCoMKgwqDCoCBTaWduZWQtb2ZmLWJ5OiBKZW5z
IEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+IA0KPiBUd28gbGlidXJpbmcgdGVzdHMgZmFpbDoN
Cj4gDQo+IMKgwqAgVGVzdHMgZmFpbGVkOsKgIDxwb2xsLW1zaG90LW92ZXJmbG93LnQ+IDxyZWFk
LXdyaXRlLnQ+DQo+IMKgwqAgbWFrZVsxXTogKioqIFtNYWtlZmlsZToyMzc6IHJ1bnRlc3RzXSBF
cnJvciAxDQo+IMKgwqAgbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgJy9ob21lL2FtbWFyZmFp
emkyL2FwcC9saWJ1cmluZy90ZXN0Jw0KPiDCoMKgIG1ha2U6ICoqKiBbTWFrZWZpbGU6MjE6IHJ1
bnRlc3RzXSBFcnJvciAyDQo+IA0KPiANCj4gwqDCoCBhbW1hcmZhaXppMkBpbnRlZ3JhbDI6fi9h
cHAvbGlidXJpbmckIHVuYW1lIC1hDQo+IMKgwqAgTGludXggaW50ZWdyYWwyIDUuMTkuMC1yYzct
MjAyMi0wNy0xOCAjMSBTTVAgUFJFRU1QVF9EWU5BTUlDIE1vbg0KPiBKdWwgMTggMTU6NDI6Mjcg
V0lCIDIwMjIgeDg2XzY0IHg4Nl82NCB4ODZfNjQgR05VL0xpbnV4DQo+IMKgwqAgYW1tYXJmYWl6
aTJAaW50ZWdyYWwyOn4vYXBwL2xpYnVyaW5nJCB0ZXN0L3JlYWQtd3JpdGUudA0KPiDCoMKgIGNx
ZSByZXMgLTIyLCB3YW50ZWQgODE5Mg0KPiDCoMKgIHRlc3RfYnVmX3NlbGVjdCB2ZWMgZmFpbGVk
DQoNCldoYXQgZnMgYXJlIHlvdSB1c2luZz8gdGVzdGluZyBvbiBhIGZyZXNoIFhGUyBmcyByZWFk
LXdyaXRlLnQgd29ya3MgZm9yDQptZQ0KDQo+IMKgwqAgYW1tYXJmYWl6aTJAaW50ZWdyYWwyOn4v
YXBwL2xpYnVyaW5nJCB0ZXN0L3BvbGwtbXNob3Qtb3ZlcmZsb3cudA0KPiDCoMKgIHNpZ25hbGxl
ZCBubyBtb3JlIQ0KPiDCoMKgIGFtbWFyZmFpemkyQGludGVncmFsMjp+L2FwcC9saWJ1cmluZyQN
Cj4gDQo+IEpGWUksIC0yMiBpcyAtRUlOVkFMLg0KPiANCj4gcmVhZC13cml0ZS50IGNhbGwgdHJh
Y2Ugd2hlbiBjYWxsaW5nIGZwcmludGYoLi4uLCAiY3FlIHJlcyAlZCwgd2FudGVkDQo+ICVkXG4i
LCAuLi4pOg0KPiANCj4gwqDCoCAjMMKgIF9fX2ZwcmludGZfY2hrICguL2RlYnVnL2ZwcmludGZf
Y2hrLmM6MjUpDQo+IMKgwqAgIzHCoCBmcHJpbnRmICgvdXNyL2luY2x1ZGUveDg2XzY0LWxpbnV4
LWdudS9iaXRzL3N0ZGlvMi5oOjEwNSkNCj4gwqDCoCAjMsKgIF9fdGVzdF9pbyAocmVhZC13cml0
ZS5jOjE4MSkNCj4gwqDCoCAjM8KgIHRlc3RfYnVmX3NlbGVjdCAocmVhZC13cml0ZS5jOjU3NykN
Cj4gwqDCoCAjNMKgIG1haW4gKHJlYWQtd3JpdGUuYzo4NDkpDQo+IA0KPiBwb2xsLW1zaG90LW92
ZXJmbG93LnQgY2FsbCB0cmFjZSBzaG91bGQgYmUgdHJpdmlhbC4NCj4gDQoNCg0KcG9sbC1tc2hv
dC1vdmVyZmxvdy50IHRlc3RzIHNvbWV0aGluZyB0aGF0IEkgY2hhbmdlZCBpbiA1LjIwLCBidXQN
CmFjdHVhbGx5IEkgZG8gbm90IGtub3cgaWYgdGhlIGZpeCBzaG91bGQgYmUgYmFja3BvcnRlZC4g
RG8gcGVvcGxlIGhhdmUNCmFuIG9waW5pb24gaGVyZT8gVGhlIGJhY2twb3J0IHVuZm9ydHVuYXRl
bHkgbG9va3MgbGlrZSBpdCBtaWdodCBiZQ0KY29tcGxleC4NCg0KVGhlIHRlc3QgdGVzdHMgYW4g
ZWRnZSBjb25kaXRpb24gd2l0aCBvdmVyZmxvdyBhbmQgbXVsdGlzaG90IHBvbGxzLg0KT3ZlcmZs
b3cgd2lsbCBhY3R1YWxseSBjaGFuZ2UgdGhlIG9yZGVyaW5nIG9mIENRRXMsIHN1Y2ggdGhhdCB5
b3UgbWlnaHQNCmdldCBhIENRRSB3aXRob3V0IElPUklOR19DUUVfRl9NT1JFIGFuZCB0aGVuIGxh
dGVyIHJlY2VpdmUgb25lIHdpdGgNCklPUklOR19DUUVfRl9NT1JFIHNldC4NCg0KVGhpcyBpcyBh
IHJlYWwgcHJvYmxlbSBmb3Igc3RyaWN0IG9yZGVyZWQgQVBJJ3MgbGlrZSByZWN2ICh3aGljaCBp
cyB3aHkNCkkgZml4ZWQgaXQpLCBidXQgZm9yIHBvbGwgaXQncyB1bmNsZWFyIHRvIG1lIGlmIGl0
IGlzIGEgYmlnIGVub3VnaA0KcHJvYmxlbSBhbmQgbmVlZHMgYmFja3BvcnRpbmcuIENlcnRhaW5s
eSBJIHRoaW5rIGl0IGhhcyBiZWVuIHRoaXMgd2F5DQpmb3IgYSBsb25nIHRpbWUgYW5kIG5vIG9u
ZSBoYXMgY29tcGxhaW5lZD8NCg0KDQo=
