Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676A351FC5D
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiEIMQg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiEIMQf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:16:35 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14642B187
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:12:37 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2490wckx003523
        for <io-uring@vger.kernel.org>; Mon, 9 May 2022 05:12:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0OZBjTXOOcOWpTp9TRbkl5b1sFpamw+HZ/tFFfpp8/M=;
 b=GVdAvuoabdzo5L31eqEqUJKlHIL11tkOMICgeb854cVn0Sfp0DBxKDY2VdcwiCOfEv5N
 MWm3EXzMlq+yR0a5tKlcVY05zq2JrnqOY26EMaCYa6IGZHLoefh11HbrRdhEH3Rcmiyo
 F1Kj1/bl/HFkZej7WVHYXgigjI9FchFV58E= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpksfypp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:12:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrFCrsSWZSqMhD4vSXrJxJSu2dIzJ1XCOvztFn2uPUjwIm3i9tKRknJ8yFpn6DzChxxHz6UY2pzJofyU6vWYl5rcht8qvlz02slE+son10RzVZ+/5nCp/J4jRFRVrnuNB593ECTQ1HjCgkroakA8oIImVCbZjzoeE2XQcLhpGgBtfsYlRXK8kyshXU0J3IX9ZZ6c2COxWe7V1lafFO/vlggtVHOdUVxXx2ZO4a2DHnqZIRpM/whFfHUnaI6uA1BU62twzBKIIHYACn7T5KFfpcIqU1MPB7ZF2H7hNbf/Vfz8HQDWCebRkolGuzpG4kIbpyYNu/Bt5IVJNMlz74tItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OZBjTXOOcOWpTp9TRbkl5b1sFpamw+HZ/tFFfpp8/M=;
 b=i7bQfN6XF11gpgkHGJWyeRj+XeXgelN1FpYq73GFPMK0+qX/TVJS/zBLgBrS3b45zcsMtMjkuZUgsk521kqotffKYiNbYbRWrwNUrPtGEm+On6dCBmMRRWrlF8Pwj/j24pFBQMII10gqgxFcRDdLuLzuZcSu1Urgib+U4qlZl1ebVnlx84RAMJwxMhL6/DMr4Qs/9rhVyun9o2cqFsNlGFZwG6Wvo5j7FIGyuq9eUd5V2lLG9zw6PPJLdjCjNqQvoXIulHno8oTANWxBiUXaH1ZKie+SuAzM5vL8Sx1SEIW8rB80kMxip4iZ8vFg2AY5+L8/7LGwCz7LTrQEVwibTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN6PR15MB1362.namprd15.prod.outlook.com (2603:10b6:404:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 12:12:34 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 12:12:34 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Thread-Topic: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Thread-Index: AQHYXZ4E/YKtPTC2Xke82fW2vRIHv60WfyGAgAABwoA=
Date:   Mon, 9 May 2022 12:12:34 +0000
Message-ID: <e5f792aaca511e477ceb25115c30b6b53abf5063.camel@fb.com>
References: <20220501205653.15775-1-axboe@kernel.dk>
         <20220501205653.15775-4-axboe@kernel.dk>
         <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
In-Reply-To: <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77965679-302a-49e4-5cd0-08da31b53316
x-ms-traffictypediagnostic: BN6PR15MB1362:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1362858DBF2CD5C2B632AF37B6C69@BN6PR15MB1362.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oSvkkCOsJtou+rezMcGzqJetAPHd4f/hEqJSqg823qCGmaKDQWF2Ci9MhP7q4G13uxX4K50UmPHdUPObF04RAks/cJwiQKNw/3cZ83T1XCWJMX7tDgQ7KHDdMHXqp427wBPspodFmilnHU4tdeulbiyAln9a26Z25ROP/crpagTYOhoAf6/ppjStEJ3+Kw6UoCFsTnuofpuvnBwN2CRcfvd031jC7+QcK197qqhJeq898SDOHfbXOq76bC03yM1WYg8F3ag/HPbDRvNv0PdaI7b9WXxD8nMc3gzg1Eu0vvEpZKs8vVN8YHyrKrCzp3Q3OYV7PHkHydLMi8MhBB65UNbv5FxgGjpuz569YBYNgPy5+x5uOMV2IjYArARv4OMDGiRrVE3xAFYEwg1hakNInkhz7GHm1S7G1w1MlfQfKJT/lAlT2mIA+t1vsDWMCVYb2Q1emzLSp2JctBq+/TIQZPnhSv/7ntC23TCdLMuEfjlo871qXH5uLypnxfGB3BZz6uAv+ZC3KNFrbsrKM1W9j6x+XZHN3ButLYKXYIw4vN5Vhdi/832c7UmI9/4jlDmLnwiXNP8usj9XR/lp+L89VRCAuCD1bwB8Wvyghv81RVhPNeHZ+P3i51tAjJN3CeXLJsoHpWM/Q4MfUro0+xhqbrKL7aAQfQe10VZIRg3JOO6jem8STAOB4JE/sWTotT74z3EaDiNygJNvMRMcX+00jA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(6512007)(2616005)(2906002)(6506007)(4326008)(8676002)(76116006)(66476007)(66446008)(66556008)(64756008)(66946007)(36756003)(186003)(110136005)(91956017)(316002)(38100700002)(6486002)(71200400001)(86362001)(83380400001)(38070700005)(5660300002)(508600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXB1TXN3SnRjdzg5QU1sQ1BranJ0K3lUS0dtcnZVcjdtVGpJVG04Q3NFSnA1?=
 =?utf-8?B?c0ViVVdKZ0pHM21QbW1CSGFDT1l6R0RRV1plaENqckRJT2JSMFcwQlJ0Nmsr?=
 =?utf-8?B?eThRcHV4QlI1ZzQrbVFYNWh4Q2VLUTdzMXdham10NkFnQ09DRDVtbDNCUEZw?=
 =?utf-8?B?MWZ5RTVLeWJUZ2FDdzBlbHgxODFId1BlS0NBUHhpY203N3l0OFc3Tm9JUU1k?=
 =?utf-8?B?WWhseW44OFJKVlRnYkwzc2pCaDZtMUJyckJlcXZ0V1U3MmJNeGtndHFYTWFk?=
 =?utf-8?B?WDRoOVRaSFhXR0x5bEd1cHREWnRUS3RWbmNmU3h6cVY4ckQ3a3JiVWZ5S0Jm?=
 =?utf-8?B?YkRuSW1zbkZMY0U5UnY4QVF4N1ljVkpBZHJjNEExR290TXo4NWplcVVPbWR0?=
 =?utf-8?B?OVdMVXVQeU1IT2FGblErSkRMTlMyVm9IcExlSjFMajFxM0pPdjh5dEhGZmoz?=
 =?utf-8?B?NXN4QXZaY1J6ZHNTckVyQThoOTdnVzdrRFFaZVFYd0RGV0JqWStsTStQTU9G?=
 =?utf-8?B?TjhQdTg0Rm9tdmhDRHBtVkFxR3NUaUwvWDZYeDBVNmFacnhHTkt1eUZKM2dr?=
 =?utf-8?B?WE1kcTNvcGVHZlQwMmhVVUdnTTIyWHE2TTc2amZZSFJSaEx3RVdxaSt5bTN0?=
 =?utf-8?B?MTljcVZNN2FZTVovckxLdU9TRUpYWmRhSmh3dnJCSkJvOG5KZUw2TGtSZ2Yr?=
 =?utf-8?B?Y05KUVlOUk1DeTBpV3Y5MzNHc2ZQdC9aUzRQOFhlRytQVmI0d0VDcWJSbkZs?=
 =?utf-8?B?SzNYWHFFYVVORVA0TCsrN1B5RnZqa2toWFN6Q2RXUWNaQ0VjYUVmT1BOYmRI?=
 =?utf-8?B?VkNVZ0JabkJtbjVPSVJURE1KZkVSOHAwaXpQMXZvZ285ZHlFUnJrdjdoVEhL?=
 =?utf-8?B?eVdLekpSajNKOHRVNlVCZ1NOd1dTRGJPeWMwK1RKSWFVWHhpaWR5WU9MMjVF?=
 =?utf-8?B?YnJuYTBiR1o2aWJINCtLNjM3bFl1bVBUdjZNYUk1YjI3OXA5L1dReXc2RVY5?=
 =?utf-8?B?allqMktIT0E2ckpsQXQ5MENieTlwbGI0RTFvazRhSG1Qd2hPNGpBMmpRQlNq?=
 =?utf-8?B?aUU0TWZ3QzRmckdhQjlqR0ltUDhEM1huLzJrZ1Rpei8zZi9PNTZtdzRkbWdK?=
 =?utf-8?B?TTdIYUZESGxKQ3BCeDBUY0FkcDN0a3oyaHlxREJiYnc4cVdPSVNuc2RsaERW?=
 =?utf-8?B?aHYyYmk5dkVOMm9hR2cyclQ4bTkrSDNuZFlUV1o5ZzJsUnBJaGpQSWxtMTlO?=
 =?utf-8?B?eHQ3NVdaSVovZURwUVlSeEF2b2JMd0JtZnF2U1RCWE0rTDFNSTZEaE16Nktr?=
 =?utf-8?B?ZTJCM05UZFhYQVlxbTNzejc4dElzc1l2RzNCYU1yNnlZclZQblJZTFJ1Q3dm?=
 =?utf-8?B?dnl2TjVkc3l5Z1psbWs3UktZbGVIU2NsMkFqMnhNZFY5cXV5NEJQWUZxamRq?=
 =?utf-8?B?TzhEQUthYS9USUE2OTVQMzBwN1Q4UDdlUWEyZ3JYeUV2QU5HNXJQbjlZdm00?=
 =?utf-8?B?Zk1SRVM2ZkRYbTU1b0JCcDAxUGxndGpFaTdWS0Jhd3h6aHh3dWpwcDZXQ1Yv?=
 =?utf-8?B?UVFvQ2FwOThaU1F1MDByKzZNTU11TlkyN1dQR2w0Tm50M2R4a0R4TkJIRVpn?=
 =?utf-8?B?SUxGSnlPa0Y0cDNKM2htRk1XMW91YXBlQXFqL212L08rdFVhWlpBNW1QcDVK?=
 =?utf-8?B?VmpMRUxXV0lWVy9Ia2RoNktJMFFpUUtFUHVIZDlVSDEyZGJVOEMwSVdGRjlS?=
 =?utf-8?B?T2cwV09WYitOcElZOGlyd215L2RxS3dkVG5UVEd4c3RhWnlrOFBISTdzUnRp?=
 =?utf-8?B?eU1INDF3NUYxMTlDUHJBTTRSSVJ0a1hvdFhlaTRyTDRxaEJXbldkalpoVDk3?=
 =?utf-8?B?WnduVDdhTmtINmpWcTJ1OWtUc1E2b0JSbXFPdG9ZMkI5UGtHa0pTRlg2WjQv?=
 =?utf-8?B?SGJ0bDNPeW1XeldLL3NNNlY3ekJ5Ry90NVFNZmdWRURZR1VHYkVOdDBKNkMr?=
 =?utf-8?B?MW9LYk1HZWs2VlRiM1BiK3JpZXB6bGt3a2p1Tkx1OFpTL2FablNGZ3AybTVx?=
 =?utf-8?B?MU1leGYzSkFSQUFXbWJNUzFnV3F5dG1vVDh6MmFlODJXS3lMNnFMdHk3QS9z?=
 =?utf-8?B?QkFmdjRteCtNcEk3ZGtDOURleThsR0hqRENTdzJBQjgrK3FBcEgxeTFMRkVD?=
 =?utf-8?B?aExMSEZaRDJTOUNZb2VkRGNNMDh4bTdUMUx5WjI4OGhNRytocmdlNFNMeFdr?=
 =?utf-8?B?aWREOUJLbGR2ZW1pR2Z1eksyWkh3SDRmYm9uQWZqd09LaW0zMklscUJHU1p4?=
 =?utf-8?B?VEVITXhxSHlMZXR6WlNXb3hUQUc0R2MwbjhFNHc1aVFVMGNhWVczbU5DZTFn?=
 =?utf-8?Q?v/ObwlSjk3e0tBoc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7849C9FEA16B4B48B9E0E1E6BB19FFEC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77965679-302a-49e4-5cd0-08da31b53316
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 12:12:34.2135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w+gQZW70HK6LKedI3+SRL1S3iASgES802lt4npbcxgZpNTCfYhvcOjPqIO9L0S7F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1362
X-Proofpoint-GUID: 1HqUWQgPyA5qIUPPaIl43HUR4Ewrq9-d
X-Proofpoint-ORIG-GUID: 1HqUWQgPyA5qIUPPaIl43HUR4Ewrq9-d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA1LTA5IGF0IDEyOjA2ICswMDAwLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0K
PiBPbiBTdW4sIDIwMjItMDUtMDEgYXQgMTQ6NTYgLTA2MDAsIEplbnMgQXhib2Ugd3JvdGU6DQo+
ID4gVGhlcmUncyBubyBwb2ludCBpbiBoYXZpbmcgY2FsbGVycyBwcm92aWRlIGEga2J1Ziwgd2Un
cmUganVzdA0KPiA+IHJldHVybmluZw0KPiA+IHRoZSBhZGRyZXNzIGFueXdheS4NCj4gPiANCj4g
PiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQo+ID4gLS0tDQo+
ID4gwqBmcy9pb191cmluZy5jIHwgNDIgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMjQgZGVs
ZXRpb25zKC0pDQo+ID4gDQo+IA0KPiAuLi4NCj4gDQo+ID4gQEAgLTYwMTMsMTAgKzYwMDYsMTEg
QEAgc3RhdGljIGludCBpb19yZWN2KHN0cnVjdCBpb19raW9jYiAqcmVxLA0KPiA+IHVuc2lnbmVk
IGludCBpc3N1ZV9mbGFncykNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAtRU5PVFNPQ0s7DQo+ID4gwqANCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJlcS0+Zmxh
Z3MgJiBSRVFfRl9CVUZGRVJfU0VMRUNUKSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGtidWYgPSBpb19idWZmZXJfc2VsZWN0KHJlcSwgJnNyLT5sZW4sIHNyLT5iZ2lkLA0K
PiA+IGlzc3VlX2ZsYWdzKTsNCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYg
KElTX0VSUihrYnVmKSkNCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiBQVFJfRVJSKGtidWYpOw0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBidWYgPSB1NjRfdG9fdXNlcl9wdHIoa2J1Zi0+YWRkcik7DQo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZvaWQgX191c2VyICpidWY7DQo+IA0KPiB0aGlzIG5v
dyBzaGFkb3dzIHRoZSBvdXRlciBidWYsIGFuZCBzbyBkb2VzIG5vdCB3b3JrIGF0IGFsbCBhcyB0
aGUgYnVmDQo+IHZhbHVlIGlzIGxvc3QuDQo+IEEgYml0IHN1cnByaXNlZCB0aGlzIGRpZCBub3Qg
c2hvdyB1cCBpbiBhbnkgdGVzdHMuDQo+IA0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgYnVmID0gaW9fYnVmZmVyX3NlbGVjdChyZXEsICZzci0+bGVuLCBzci0+Ymdp
ZCwNCj4gPiBpc3N1ZV9mbGFncyk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGlmIChJU19FUlIoYnVmKSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiBQVFJfRVJSKGJ1Zik7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoH0N
Cj4gPiDCoA0KPiA+IMKgwqDCoMKgwqDCoMKgwqByZXQgPSBpbXBvcnRfc2luZ2xlX3JhbmdlKFJF
QUQsIGJ1Ziwgc3ItPmxlbiwgJmlvdiwNCj4gPiAmbXNnLm1zZ19pdGVyKTsNCj4gDQoNClRoZSBm
b2xsb3dpbmcgc2VlbXMgdG8gZml4IGl0IGZvciBtZS4gSSBjYW4gc3VibWl0IGl0IHNlcGFyYXRl
bHkgaWYgeW91DQpsaWtlLg0KDQpkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lvX3Vy
aW5nLmMNCmluZGV4IGI2ZDQ5MWM5YTI1Zi4uMjI2OTljYjM1OWU5IDEwMDY0NA0KLS0tIGEvZnMv
aW9fdXJpbmcuYw0KKysrIGIvZnMvaW9fdXJpbmcuYw0KQEAgLTU2MzAsNyArNTYzMCw2IEBAIHN0
YXRpYyBpbnQgaW9fcmVjdihzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQNCmludCBpc3N1
ZV9mbGFncykNCiB7DQogCXN0cnVjdCBpb19zcl9tc2cgKnNyID0gJnJlcS0+c3JfbXNnOw0KIAlz
dHJ1Y3QgbXNnaGRyIG1zZzsNCi0Jdm9pZCBfX3VzZXIgKmJ1ZiA9IHNyLT5idWY7DQogCXN0cnVj
dCBzb2NrZXQgKnNvY2s7DQogCXN0cnVjdCBpb3ZlYyBpb3Y7DQogCXVuc2lnbmVkIGZsYWdzOw0K
QEAgLTU2NTQsNyArNTY1Myw3IEBAIHN0YXRpYyBpbnQgaW9fcmVjdihzdHJ1Y3QgaW9fa2lvY2Ig
KnJlcSwgdW5zaWduZWQNCmludCBpc3N1ZV9mbGFncykNCiAJCXNyLT5idWYgPSBidWY7DQogCX0N
CiANCi0JcmV0ID0gaW1wb3J0X3NpbmdsZV9yYW5nZShSRUFELCBidWYsIHNyLT5sZW4sICZpb3Ys
DQombXNnLm1zZ19pdGVyKTsNCisJcmV0ID0gaW1wb3J0X3NpbmdsZV9yYW5nZShSRUFELCBzci0+
YnVmLCBzci0+bGVuLCAmaW92LA0KJm1zZy5tc2dfaXRlcik7DQogCWlmICh1bmxpa2VseShyZXQp
KQ0KIAkJZ290byBvdXRfZnJlZTsNCiANCg==
