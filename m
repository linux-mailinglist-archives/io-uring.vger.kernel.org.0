Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B59759587A
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 12:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiHPKf7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 06:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiHPKff (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 06:35:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799C1EEC5B
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 01:37:41 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27FIbxC3004421
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 01:37:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/GxnWQEpqu4V+kDQYy5quH+sKLzag9JH+biYoBMbmrQ=;
 b=IjwQxHOHNjhySbXjhjLIr9wtLsG+BBZUe1Q27lQ5d44D0YSOqwNizDlyUdL0mD/WBLiX
 6KVk4XJajczModQJir//7uujT0JF4wvxh5AuS8MnPhxNTDw4UDvGYAPh3t4Zw0q7efxy
 sKlyqUtGnYyw3voUoNfJxtKtmvdwkjU4Mhw= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hx7mx8sgt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 01:37:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9p1ruAPuqaFufoHqJaKRkp/CKUaxZZZzcLw9zJvuZcrBD7VE1HcDUmk7/kRaVbgohpMXNoYJ5u3Dos0gvSRKY5nKYO3Yq0PqLLUrrhPk7JTsPEG4E5F2NbF9ZzYkDksjOg3sg9ZQWYOSswYqvpjQmwsJDtfRgydMcBfhAP+ZPBncAx6ZXFeXw+KTgFEa7yYIvdcrKBOtud2XB+RNSHjAMKD4nc9vYfaJJAutofpW2lJtoM9X4LXv5wZO2skTfuvjsPVSlNY75qP7/IYmMU3CSs7Rs1hOUUuN67b8Yu1ZLiZip247BJ9o3441OnsE8eLbS/nLi6qb2Ks5jmhc9kyyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GxnWQEpqu4V+kDQYy5quH+sKLzag9JH+biYoBMbmrQ=;
 b=LquaWiD8bWgnuctJzz101F+kz3lQmsY2NBQ3t0yn5K/4kdq2+/sWxuYpvVLaDrt4+p3/omhBv38yzOjUefNEXmcl4qvSb01+LxPBaSulz4MGVA3duwJ600NdZcidlpyRxnYqss2PAgVttEPomcqiWwO697u6Eode8gZWqi5VREHmzZpfDuFaW1het9OCVOrXTGAwj/9SK8Kqkhh4cQMMdkSubE+RfZW8PDkt3zeWkPxtAzR7QuNxxrax/9DK8ifrGnZ1yURrNDZRRIJ883wGrc6idE0KFpPhD3+C2mMHZUtwkb4N7q5Kicmkw5WEZCJ+3ghe2WS2scCtogsdqnvbLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4861.namprd15.prod.outlook.com (2603:10b6:510:a6::5)
 by BN6PR15MB1906.namprd15.prod.outlook.com (2603:10b6:405:5b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 08:37:37 +0000
Received: from PH0PR15MB4861.namprd15.prod.outlook.com
 ([fe80::138:6569:4c27:db6f]) by PH0PR15MB4861.namprd15.prod.outlook.com
 ([fe80::138:6569:4c27:db6f%6]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 08:37:37 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "metze@samba.org" <metze@samba.org>
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
Thread-Topic: [RFC 2/2] io_uring/net: allow to override notification tag
Thread-Index: AQHYsUPejHDhGmwbL06/vh5zIpHdCa2xNFcA
Date:   Tue, 16 Aug 2022 08:37:37 +0000
Message-ID: <4d344ba991c604f0ae28511143c26b3c9af75a2a.camel@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
         <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
In-Reply-To: <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9625315b-5f43-44ff-d071-08da7f6292dd
x-ms-traffictypediagnostic: BN6PR15MB1906:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zLG3gRAsF7ZKZ0pQ4bYqBIDBnVnzBygKqZE0FBwUVCRF10E9lYMO6wBpQ0Gmkh/7L7TyUFqmeZa3+YcRIKDyw9kvOmK8POGQgq7SnVxInvGZUtvME6H5UmpE+1bkjbBZIdwsNVMkhhXw/TO8xCgEf/2cxOqmW3Pi5mvv3xtMw2P9QJgvzl7wF4hH0lCYUgLl7Zp08UB5KWl3Bkq+NAOicJVFfm9ugunzDtwLxJkrGgcKNgVYdPnlr5F5HqiHHl9v5rXiMPE+6Ajhrelm6tIB7M9gTtlGHfIs0RcfZjeGvfu+oDBCExR4u2QWpC6PkyOwojGF0bfeWw99kwweKcdVYzy9eyxm6VlLsWvKrL02b4MuoulVnFt+EEp0mTi1rden17XFPeONADFF4WNce3tEOrXXiMHh+AggN8n304Fgd3c/P0K3R1lFdEc7IfLlU1OSn1XmGzYrJH4XzkYIjK2q1RBgC4alNPC9Dude8Ql0V4cJ1Q+6WJN8oDhPYvJ+65gvQ6ISJP0U9aGhoy153qSQZ19dFVo0XAnGndf0/20dL3Ni4YI1Uvrsd62se3Tu9sHfMxOZ240kIiRhYB7621XNCyTrq3wwRRlYLFJfbtlwfGnElwHRhcYqCFgxf/NrXl7+XnJFKplRdk9SPh5cUpLlhBDYQxN9MWQCnmSL1O1L6FZh0HLHe0RyXj5t6hH7/9cco/7f/i8nxRDKiUVyox1q4VMynfhpMQdScCQH86xYMu5goKE5RbGj8jGoyI1yBYzRvqr5m9jzsfOdzpXW9zkt3Mvlvu19cGB0nssS8KFfhik=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4861.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(4744005)(6486002)(5660300002)(38070700005)(15650500001)(66476007)(66946007)(66446008)(64756008)(8936002)(122000001)(2906002)(478600001)(8676002)(66556008)(38100700002)(6512007)(36756003)(186003)(86362001)(71200400001)(2616005)(4326008)(54906003)(76116006)(316002)(26005)(83380400001)(110136005)(41300700001)(6506007)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2FJMkx5Q3J1cmJCVExmbm5aVXVuM1pFRDBWcWhGWkdtbE5NZnFYQjEvMksy?=
 =?utf-8?B?UXhpWGVERS8wZitJWWZVQnFIbFFYU1E1U0hhTWtVWFlGSHpCcndJNFJiaGpV?=
 =?utf-8?B?STl2bTdabnBxSjBheStwNksyNks3UlNRSDJBOFlMZnZZU2N3RklQNHhPRU4v?=
 =?utf-8?B?cmJMb3VKd3BqRE92cVN2UFltU1NsMHpQYXpEaVl1RzJGOFRJL09qbXlPd1RJ?=
 =?utf-8?B?MHVRTis3bExES0xNV0RremZhREtEOE1HTThoMkMwNDAwakE3aFVpYUtNd2xz?=
 =?utf-8?B?dGtuU244MTEyOEtEam43T3BrOVdOTklCT3ZtaDd1aFZoK0FXZU4rYjJCb3Ay?=
 =?utf-8?B?RzBPQ3FpZ0Q2Q0RER0pwQWNrMlo1M1NNM1RVV2xJTkVrRmkvZ2o1eGM2WFlk?=
 =?utf-8?B?QTEyY0ZPZjQ1NE14Sks2bXNCb3ZGQ2djM2xoRnZ2RytZMG9pL2dQQW5jOVA1?=
 =?utf-8?B?RXV5WXJTaWRTZVcxMitQTVJkRnMwcHZGTUp6cHY4emVHcE1Vdk5aZGg0MHh0?=
 =?utf-8?B?OU1HaW1nU3dTOXZ6dU5ORkIrUVhtOE1oSG1NNXdRcjZaVzhhM0Rvcmg0Rmla?=
 =?utf-8?B?bFpENHRNbTNlUkt3blNYR1o1anJXK20yUmlHSTNWVzE0YjVDNlZocE4vVmt0?=
 =?utf-8?B?QXNpNkY5K1RIdWV1WmhWV0Y2dHIwckMwc0ExREhoN3FMYVcxanFUcFNWNlZH?=
 =?utf-8?B?NWp1Z1JadGg1ZUR0SDd6aUVzV1JsVEdOVmJWSDkxdG1SZ3RtMFhUT3kyV3JR?=
 =?utf-8?B?MDYyTXhVVUlSc3NYUEU2WkptZ1pweDVwTEhVcHFZTEJlM0tRVkRIdTZLQ2Vj?=
 =?utf-8?B?cnpVNU5vcGtmdnllOUdXQWZmMHhDcUc4cjNLZHZ3UU1CcXJRL0loeU9Kclor?=
 =?utf-8?B?Tlh2bzVXcmVKRDcyciszUi93UnZ1VW9mdXBEdEVsanV0Vm9hcWJpV0lHbDFu?=
 =?utf-8?B?MnhFMmlXL0JnaTdkUjFqb3NLeHRtOWUxNTVaNGpYbFc2LzJmdkNQRUhJTUhx?=
 =?utf-8?B?OVBhZVRZYWpnbVdQUGhtanJKQ2wxbmoraVB4SHU2NE1OYzlkRTQxeE9Ka3lS?=
 =?utf-8?B?SGtxQkhLMXhObWxJWDZiWUFMSTdmOWg2K09xUHlXN3RhNUV1Nk9QbzlpZGVJ?=
 =?utf-8?B?RloxdTRxbStvMkhjOE9ONHI2YU0zcVJybFZ4VmJKdEU0ZllvendFOFZ4ZDZa?=
 =?utf-8?B?eTV4bWI2YTdqOHFEYTVSSHBSRUE4bVVnWXMra3ZjSktpY0hHR1FPTFR5UWFl?=
 =?utf-8?B?MkVjT2QzMFpYRkI3WnltVVppcTVMcXBpZW1QUlNZOStMNkpOZURSK2Z6N044?=
 =?utf-8?B?N092RmppcG5LREdqK3BMTHlyaUErT01MUTduWXV1VnpmN2xLcHZ3Yy92NzhP?=
 =?utf-8?B?aEhRR0I1TEExY01jVUhVYVRqQkJUTlRZdE9nYUNBaVVlSUJDNC9mODM1N2hv?=
 =?utf-8?B?R0tsRWNnd2tqUGdDZmNlUU5FcHl5RGFLeVdOS1o0dHNtU1UrL290V1E2Q2Np?=
 =?utf-8?B?VHJCVExNQkhybnl4b3dzOVJ4TnZTWDhiY21TMXl0UHNISSs0U3V2WVBKOXkv?=
 =?utf-8?B?S0ErSmRLeHY3ZDhJelNrU1FTdk81SmpKUjlXQTJJNzNRY2JLWU5HV2VOZStz?=
 =?utf-8?B?TDdsWTEwSWdVTGJPNEloL3JqaDJpeVVnRWFFb2w2dC9YZ0hBWjd5VTIwY05z?=
 =?utf-8?B?RlBrK2crdlp2UXdTUXpGVUJmcEVudGlsSERjelNQMWd4WHhhZUU4S05sdGdI?=
 =?utf-8?B?ZzlPQXlBQnlRNHliZkE4aE10Ly9kemhidFZQa3NVQnJ6Ylh4ZFpIYzV6SnFJ?=
 =?utf-8?B?a0xUaGdnNnR2dktMTmdJcTZ2SXE4NmZIR1NGZHlmbC9wWTh2b2kzL0JDWmdO?=
 =?utf-8?B?L0pOQjR4ZXQ0OUZRam9LR3V2ai8wd2FmV2J0MGEydUpQYjN2M09VZGd0QVcr?=
 =?utf-8?B?L3dETkZGeFVKZzBxUnl0SFZjRzNpNWdzbXczY0c4NjI0YlIvN1JWKzRKbjZl?=
 =?utf-8?B?Ky94R0RJdElCTmlWbGk4NjAyU2VMRlBjZjJaS3c3RmNudnBnTVJRMkw2aU8v?=
 =?utf-8?B?bEhlRFpSeDhEdnVvTkM3Ym5ZUURUam5qVnVZS2tLOWFGckdQaXZGSkxMZWNj?=
 =?utf-8?Q?eqB1k+CMPSbm4ywkXFWZvjK5a?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE5C2D2F09F8DB49A48DE685D2B4809E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4861.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9625315b-5f43-44ff-d071-08da7f6292dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 08:37:37.3566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8Wa7m5XT6wi57cejix4TPPhLd9NBzyY/arnohLeNyYFYFfP+axtaycAdj6Q9Ynu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1906
X-Proofpoint-ORIG-GUID: XrAIarb52Kx-uL8lWQZft5RXRxzYFx9s
X-Proofpoint-GUID: XrAIarb52Kx-uL8lWQZft5RXRxzYFx9s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_07,2022-08-16_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTE2IGF0IDA4OjQyICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gQ29uc2lkZXJpbmcgbGltaXRlZCBhbW91bnQgb2Ygc2xvdHMgc29tZSB1c2VycyBzdHJ1Z2ds
ZSB3aXRoDQo+IHJlZ2lzdHJhdGlvbiB0aW1lIG5vdGlmaWNhdGlvbiB0YWcgYXNzaWdubWVudCBh
cyBpdCdzIGhhcmQgdG8gbWFuYWdlDQo+IG5vdGlmaWNhdGlvbnMgdXNpbmcgc2VxdWVuY2UgbnVt
YmVycy4gQWRkIGEgc2ltcGxlIGZlYXR1cmUgdGhhdA0KPiBjb3BpZXMNCj4gc3FlLT51c2VyX2Rh
dGEgb2YgYSBzZW5kKCtmbHVzaCkgcmVxdWVzdCBpbnRvIHRoZSBub3RpZmljYXRpb24gQ1FFIGl0
DQo+IGZsdXNoZXMgKGFuZCBvbmx5IHdoZW4gaXQncyBmbHVzaGVzKS4NCg0KSSB0aGluayBmb3Ig
dGhpcyB0byBiZSB1c2VmdWwgSSB0aGluayBpdCB3b3VsZCBhbHNvIGJlIG5lZWRlZCB0byBoYXZl
DQpmbGFncyBvbiB0aGUgZ2VuZXJhdGVkIENRRS4NCg0KSWYgdGhlcmUgYXJlIG1vcmUgQ1FFcyBj
b21pbmcgZm9yIHRoZSBzYW1lIHJlcXVlc3QgaXQgc2hvdWxkIGhhdmUNCklPUklOR19DUUVfRl9N
T1JFIHNldC4gT3RoZXJ3aXNlIHVzZXIgc3BhY2Ugd291bGQgbm90IGJlIGFibGUgdG8ga25vdw0K
aWYgaXQgaXMgYWJsZSB0byByZXVzZSBsb2NhbCBkYXRhLg0KDQpBZGRpdGlvbmFsbHkgaXQgd291
bGQgbmVlZCB0byBwcm92aWRlIGEgd2F5IG9mIGRpc2FtYmlndWF0aW5nIHRoZSBzZW5kDQpDUUUg
d2l0aCB0aGUgZmx1c2ggQ1FFLg0KDQpEeWxhbg0K
