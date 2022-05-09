Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCD351FD2D
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiEIMrN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiEIMrL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:47:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7522272C6
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:43:18 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2494x8L6002210
        for <io-uring@vger.kernel.org>; Mon, 9 May 2022 05:43:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Jfdz2b5rkDTMq9jInttaSSiNkl9k82lXqErNsM1Lirk=;
 b=jLc+XstzK4HIBAPMlfOohhM4h9NEVTw+74El9/0HP2bvRoDzcZuXp2uu27oXlrOFxhax
 KZUiABpEGXr2AkPi0TBfxLZPinVZK/LE0m/oKw6n6952SU1vzmSyBWEvTHaGF/aXFBt8
 fLEKKZJ1nPAABjmDsT/1iZPN0mN2qoUeuE4= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpfmr79j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:43:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMnGUPLEsJWPAdnUpHh9bIw8AZRieylxWYiCH58V6QQKd+Q2NOef6rT4UhPijnfNX6lNDI2T7h6TM0Nsji0rONRDIGcR12kB6w7QVUH4zAzdCr5tsdGbxC05ZizFjSTaY7FMIqNPte3My9liUNOZcKNzUMVqCrCEqTfbyK+uB/Fd0hiKjKBP6T2goaZph+E8XvDu5gWoPI6FbTWqPCX1FKWp4laVQR70jr7UFIpxTl3s/Om7p41wZF4etrLxH4pqksOF1zRO7yoHoVmoyo98O4WM1EUciQYP1OGl9ja0Eo5XKtFWLiAdBIA/P1qYtJqZ4QF1joMeGdgga/EiAtoh3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jfdz2b5rkDTMq9jInttaSSiNkl9k82lXqErNsM1Lirk=;
 b=KzIPgHrJc7czh9H+gDMNgNcB6GBvHalB63vSIjGuFmWKUP3QWlws1RAZqyrbjzIzIh9O08e2nHaWJMZcsEIePUizG8QY2qg+Xz9WyGh5nByrRZjY7SDfYPB1P0rzCETfS4BoeC92eKLKVWzwCp1Y5LE0qi+ElymMEaTN1CmPw2EbXh1OMupzX1B8p/ALATEtWC3Ly2veXezITfaPc9I1ViOqjFcO1R/tBPJpIIWy3K5n9c5W1PG+dxi80FBCiDdBhoODro70bg0jpAJN06AkFaj3FFWxHWAeHWjyvQ6mF7EZutVmy/ElghHc4x4/7tcKyJc7vuHfSzCAo6t2VXRmDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB2954.namprd15.prod.outlook.com (2603:10b6:5:13c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 12:43:15 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 12:43:15 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Thread-Topic: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Thread-Index: AQHYXZ4E/YKtPTC2Xke82fW2vRIHv60WfyGAgAABwoCAAASVgIAAA/4A
Date:   Mon, 9 May 2022 12:43:14 +0000
Message-ID: <3b740d592d850593b5344b35bdc2e52399a008c3.camel@fb.com>
References: <20220501205653.15775-1-axboe@kernel.dk>
         <20220501205653.15775-4-axboe@kernel.dk>
         <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
         <e5f792aaca511e477ceb25115c30b6b53abf5063.camel@fb.com>
         <2c63a534-d728-205a-9812-d12eb62c6d75@kernel.dk>
In-Reply-To: <2c63a534-d728-205a-9812-d12eb62c6d75@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1163707-53e2-45b8-1407-08da31b97c4c
x-ms-traffictypediagnostic: DM6PR15MB2954:EE_
x-microsoft-antispam-prvs: <DM6PR15MB29546E145A914F2A8BB23E9DB6C69@DM6PR15MB2954.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /02PeXdteo2cp4aBs/v9gdSzaMznWGzvHRRSz6N/OuLL50j2GOMv9D02CqcXlSrvcoYa6E8+CckbRSzat9Af0nXth5FauK1n++4E+GHCRg+wI8hJqHYzxFyqYo3M7K6DubvaVneohYD2eKPW+3/wc6emZb4aixuqHT98j8aupA2HG1v+fnT+bkAcSfVekDcrII7muo4iCZBGcvsc5zGjSC93sYPA/qnQwl1U+NR3/BA7d1qOXtraPFqoQ/XitXAW6mLUXRaAHCP05OxmYI1gFK1pmStleOMaUe0WDgc+VPsmV3qJinVHmo6CCdGtOxNkOMPT64gDLb+IeLzgOoTHcIica6ggIFKrBxD0+5zeEf9RgiH3HjjHa5GWdvZLALds8sxcvZCm4sbFMedLS1r3dgE5pATAB9WK9Bpkfoia7WCTZGsEZd1YsJGU9xdGjFskE5MxpB2gBxTSJnNh0AIKBWazm6mUcxybUW99/xWT9PQAU7Jw9CGevj27DCPBGzT5Gvna3h6kdwhgz4d/n6kHA+rYk+E/xAd66imfzFbi0uF2uNvfOj1IeTEFqwYdxoVp5KlvdOWTloxsCT3Vi/hGNLfv9EM/v+TummHSLhLu67bsmRCkG1n7BMwrkfypDsKyMotIsVwasuadLcyBxc0hTPAJslCBteIxQ3Cwdu+RDCwUjAPUdG/PA3obtl45OB+RMaV8kuVFoD89fz+cHxvkJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(38100700002)(122000001)(91956017)(36756003)(86362001)(5660300002)(53546011)(83380400001)(8936002)(38070700005)(6506007)(66476007)(6486002)(66946007)(64756008)(508600001)(6512007)(66446008)(66556008)(76116006)(316002)(4326008)(8676002)(71200400001)(186003)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWJkMWxDV3RnU0xjZ0lQSWtFblN5RVZxa1VScGx0ZmJGOGxmVG1jcWxsNmEv?=
 =?utf-8?B?SFpUc29HNVVZeXd3ajlOVVJ6UVpwdWtieXZwUVBsLzB4R1g4OVpGa3FzQWFn?=
 =?utf-8?B?QldhOVFpSW5vc2JMSFFxVU5MQUd2Z0VEVFE1SW82NWxMSC9pZGo2Ky9sWlB3?=
 =?utf-8?B?QW5leU9kYjhyVEkzMElodjFkTC9lTFN5eWRrdzNnUmpRYXF3YncvbTZRbHo4?=
 =?utf-8?B?TWZYTXpoeHpiZlVqSnFHcmhtNE52YmJOMEJBWFJHcVFZbVZRaTltMVc3Vkg5?=
 =?utf-8?B?OFdvR0hxWU10MldJWE5aUVJnZ3lJRDZHV210aWVETkZNVWZ5bGZCVEVPUHph?=
 =?utf-8?B?WHYveWFQR1d5YnBwWlg0cHlOQmhnc0NaTDBkc0dkU21ENTJXdWZXZjg4MDR4?=
 =?utf-8?B?T3hYSE4zZGRZQTZ1aUJ0S1dQakM2TEVUZGkrcU5hTE9GMHg0M1A2S3FqRnk0?=
 =?utf-8?B?YWZzNFdxYzB4a0NlRVJJQ0FYK0k0a0dtaGR3U3o4L0FvV0ErQ3NSaGV5TzF3?=
 =?utf-8?B?aDUwenhzZnNUMndqYThpb1VsbVpmaXJSdFZCOWFHRnR6dUVYaWJJUmkwekZr?=
 =?utf-8?B?c1VHYlk1T3R1dFdZdDJ3TU03T3A4dW1tRXlja0NQN3JvSVYrV2VsV2VFc003?=
 =?utf-8?B?bU1Scy94VmZmYU54bHNBU0lnOW9VVXFpRWVHUDNoa3F2OHJ5Rk50L1NPWENP?=
 =?utf-8?B?KzBhazNEQ29vcjhIbEU3aHdBQ1JxaGYrQ2l6UkpkMDc2ZG5KZ2QyNUtoWnRB?=
 =?utf-8?B?cXFaSGVQci8vRGhOVzFSYzdFMUNWTEg1TURzRDlZT1B6TmF0QVZrdnE0L2JD?=
 =?utf-8?B?TUFaOUFTWHdINjJTYkRvMWlLT2NOb2pTa25xSndnMTBqbHZHTE9GaUdHdVhV?=
 =?utf-8?B?clRabDBod1JMWUtHSDZvNVpYcGFHR3ZPTGs0cXBHUlJoVitKL1RuL2kxSUoz?=
 =?utf-8?B?WlN2QUhibGcvaS8vVjByNTV0Wklxa1MzMXZKNGhMbSs4NG00Smd2blliM2sx?=
 =?utf-8?B?R2NrazNqeUJ0VDl4MVJybFF4Z2VJL244K0J4S1kwQ3BkQ090VTFaWlpNc1ZX?=
 =?utf-8?B?d2ZqYTA2KzVNRCtsZGxES2JwVTYwWnYySmNtN3c5UGZVdlllK1dZYmZUbS9v?=
 =?utf-8?B?cCthbldOZjB6STdlbVFqS1NYYkJJSVNpOHQxVWI0RENHWEdtZFZWOE9aaG1I?=
 =?utf-8?B?cGsxNHVDeTVTdUJ3SDJ3SnNGUFE3aFdwU3Nad1crVys4MXBWT0RLUmg1ME4v?=
 =?utf-8?B?VytXdlcwb2xWc1FFT05yakszaFpZM1RuaDhwTVNhY1ArY3dldFlieG5zdUkx?=
 =?utf-8?B?QUxMRjRBZkJCVGcrWXlFMlFqR01Wd29tNUkzZkNQWDZ1QjNaV3BpMXFEOXdv?=
 =?utf-8?B?MitrSGJEUjFsOEhJWTJhZFUyOWFEUkNmMlIzQnpTOG5nTDErR0g0L0NLMW1F?=
 =?utf-8?B?OXFPQ0g1VmltaHBNQ1JyMFFRdGZaTmcyS1E4VzhUWXROVS9wYmtLdit1ZEZj?=
 =?utf-8?B?L0JBRGxwaTJsbEhucE8wSDNpYkJCQmZ3REJHR04wMU5DYyt4TGlqWExrR3Yr?=
 =?utf-8?B?TXU5VEhhNVpPdDVGeGV6V3ZzR2I4cC82cy9DRG1vM3d1WE9SWE1Cb2pDSHZ4?=
 =?utf-8?B?aGJWMkp6MmE0MGxsMEJOMGc5T1BTSktQZXR4SVZxWWxSaVg1SHFvcFo1U2E2?=
 =?utf-8?B?NUZwQnpra1NLWlhQaGtSYjJHWnA3bGFJRWNLTjRPbW0vYUM2R09sd0pnSUpk?=
 =?utf-8?B?bUpxa1EzeStzTEloK2FHOWQxaWdNOGxDZ0gxaWRCU3Y4bXV5dW9WUE1YSjg2?=
 =?utf-8?B?TDh5N0htNGJpQ3JuZWFtUHNOeDR6aTI5V3lBNGdxSU5oYUxLdnhhdTVYWUUz?=
 =?utf-8?B?N0VncWlIN1FjencraENYdnFIOUx5NGFQa2ZOSzE2SzAyOHp0TmJGOVNpb1du?=
 =?utf-8?B?ai96WmxIVE9yVUNCK2FvNTRGUC9UWTg5dVR3NnR0OVo0TnhKTGREMktJRHdp?=
 =?utf-8?B?R2dMWHRRS3dCcVJ5UkFUMDJTWlJudDUxOEF3dDdXS2tYakdOOUpFQnZFV3BL?=
 =?utf-8?B?QnF0Vm80OS9UVFJSKy9leFVWSWdNdmJUd3NGVVpNajFDa1ZDcjJUL0NPdVdx?=
 =?utf-8?B?K2Ewc0hDRGw5WUhhY3hhNnh3SzdUb2ZRVmV5WHpqY3g5bzhGbEd0MSszTXl5?=
 =?utf-8?B?TkhPbzJId0NXdDBMUEJNUkowdG9lL0ZEVTcrRWNjbmd6dzRkazZEL1VPc0tK?=
 =?utf-8?B?MGRHQTF6UFkzNGtoU3V5NERveEthRjJ2cFNranBrdnR2ME93RjRiMmk4NDFr?=
 =?utf-8?B?TVUzTitObWVpOU1KeVZGWDZURkJlUGdmN1kvZWl5ZkhEN2ZJdFIzd3YzVXo3?=
 =?utf-8?Q?/s1/eQ0aHIIP6BeY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1E125F08C6D8F4CAD23746FD4168FE9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1163707-53e2-45b8-1407-08da31b97c4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 12:43:15.0105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZavNMUYCj/TZXqWlLj9X24u19j1z3IuT70q1sfWuxa/mUmb4s7IeiQ2eQBNJPUie
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2954
X-Proofpoint-ORIG-GUID: SA5PdkpmuZ0ImIkDBu_YNXGx0Iiz2Agn
X-Proofpoint-GUID: SA5PdkpmuZ0ImIkDBu_YNXGx0Iiz2Agn
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

T24gTW9uLCAyMDIyLTA1LTA5IGF0IDA2OjI4IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDUvOS8yMiA2OjEyIEFNLCBEeWxhbiBZdWRha2VuIHdyb3RlOgo+ID4gT24gTW9uLCAyMDIyLTA1
LTA5IGF0IDEyOjA2ICswMDAwLCBEeWxhbiBZdWRha2VuIHdyb3RlOgo+ID4gPiBPbiBTdW4sIDIw
MjItMDUtMDEgYXQgMTQ6NTYgLTA2MDAsIEplbnMgQXhib2Ugd3JvdGU6Cj4gPiA+ID4gVGhlcmUn
cyBubyBwb2ludCBpbiBoYXZpbmcgY2FsbGVycyBwcm92aWRlIGEga2J1Ziwgd2UncmUganVzdAo+
ID4gPiA+IHJldHVybmluZwo+ID4gPiA+IHRoZSBhZGRyZXNzIGFueXdheS4KPiA+ID4gPiAKPiA+
ID4gPiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Cj4gPiA+ID4g
LS0tCj4gPiA+ID4gwqBmcy9pb191cmluZy5jIHwgNDIgKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCj4gPiA+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9u
cygrKSwgMjQgZGVsZXRpb25zKC0pCj4gPiA+ID4gCj4gPiA+IAo+ID4gPiAuLi4KPiA+ID4gCj4g
PiA+ID4gQEAgLTYwMTMsMTAgKzYwMDYsMTEgQEAgc3RhdGljIGludCBpb19yZWN2KHN0cnVjdCBp
b19raW9jYgo+ID4gPiA+ICpyZXEsCj4gPiA+ID4gdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQo+
ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT1RTT0NLOwo+
ID4gPiA+IMKgCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqAgaWYgKHJlcS0+ZmxhZ3MgJiBSRVFfRl9C
VUZGRVJfU0VMRUNUKSB7Cj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga2J1
ZiA9IGlvX2J1ZmZlcl9zZWxlY3QocmVxLCAmc3ItPmxlbiwgc3ItCj4gPiA+ID4gPmJnaWQsCj4g
PiA+ID4gaXNzdWVfZmxhZ3MpOwo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGlmIChJU19FUlIoa2J1ZikpCj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiBQVFJfRVJSKGtidWYpOwo+ID4gPiA+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGJ1ZiA9IHU2NF90b191c2VyX3B0cihrYnVmLT5hZGRyKTsKPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2b2lkIF9fdXNlciAqYnVmOwo+ID4g
PiAKPiA+ID4gdGhpcyBub3cgc2hhZG93cyB0aGUgb3V0ZXIgYnVmLCBhbmQgc28gZG9lcyBub3Qg
d29yayBhdCBhbGwgYXMKPiA+ID4gdGhlIGJ1Zgo+ID4gPiB2YWx1ZSBpcyBsb3N0Lgo+ID4gPiBB
IGJpdCBzdXJwcmlzZWQgdGhpcyBkaWQgbm90IHNob3cgdXAgaW4gYW55IHRlc3RzLgo+ID4gPiAK
PiA+ID4gPiArCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnVmID0gaW9f
YnVmZmVyX3NlbGVjdChyZXEsICZzci0+bGVuLCBzci0+YmdpZCwKPiA+ID4gPiBpc3N1ZV9mbGFn
cyk7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKElTX0VSUihidWYp
KQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gUFRSX0VSUihidWYpOwo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgIH0KPiA+ID4gPiDCoAo+
ID4gPiA+IMKgwqDCoMKgwqDCoMKgIHJldCA9IGltcG9ydF9zaW5nbGVfcmFuZ2UoUkVBRCwgYnVm
LCBzci0+bGVuLCAmaW92LAo+ID4gPiA+ICZtc2cubXNnX2l0ZXIpOwo+ID4gPiAKPiA+IAo+ID4g
VGhlIGZvbGxvd2luZyBzZWVtcyB0byBmaXggaXQgZm9yIG1lLiBJIGNhbiBzdWJtaXQgaXQgc2Vw
YXJhdGVseSBpZgo+ID4geW91Cj4gPiBsaWtlLgo+IAo+IEkgdGhpbmsgeW91IHdhbnQgc29tZXRo
aW5nIGxpa2UgdGhpczoKPiAKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvaW9fdXJpbmcuYyBiL2ZzL2lv
X3VyaW5nLmMKPiBpbmRleCAxOWRkM2JhOTI0ODYuLjJiODdjODlkMjM3NSAxMDA2NDQKPiAtLS0g
YS9mcy9pb191cmluZy5jCj4gKysrIGIvZnMvaW9fdXJpbmcuYwo+IEBAIC01NTk5LDcgKzU1OTks
NiBAQCBzdGF0aWMgaW50IGlvX3JlY3Yoc3RydWN0IGlvX2tpb2NiICpyZXEsCj4gdW5zaWduZWQg
aW50IGlzc3VlX2ZsYWdzKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW9fc3JfbXNn
ICpzciA9ICZyZXEtPnNyX21zZzsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IG1zZ2hkciBtc2c7
Cj4gLcKgwqDCoMKgwqDCoMKgdm9pZCBfX3VzZXIgKmJ1ZiA9IHNyLT5idWY7Cj4gwqDCoMKgwqDC
oMKgwqDCoHN0cnVjdCBzb2NrZXQgKnNvY2s7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpb3Zl
YyBpb3Y7Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGZsYWdzOwo+IEBAIC01NjIwLDkgKzU2
MTksMTAgQEAgc3RhdGljIGludCBpb19yZWN2KHN0cnVjdCBpb19raW9jYiAqcmVxLAo+IHVuc2ln
bmVkIGludCBpc3N1ZV9mbGFncykKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ1
ZiA9IGlvX2J1ZmZlcl9zZWxlY3QocmVxLCAmc3ItPmxlbiwgc3ItPmJnaWQsCj4gaXNzdWVfZmxh
Z3MpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKElTX0VSUihidWYpKQo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBQ
VFJfRVJSKGJ1Zik7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNyLT5idWYgPSBi
dWY7Cgp0aGlzIGxpbmUgSSB0aGluayB3YXMgYWRkZWQgbGF0ZXIgb24gYW55d2F5IGluICJpb191
cmluZzogbmV2ZXIgY2FsbAppb19idWZmZXJfc2VsZWN0KCkgZm9yIGEgYnVmZmVyIHJlLXNlbGVj
dCIKCj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHJldCA9IGltcG9y
dF9zaW5nbGVfcmFuZ2UoUkVBRCwgYnVmLCBzci0+bGVuLCAmaW92LAo+ICZtc2cubXNnX2l0ZXIp
Owo+ICvCoMKgwqDCoMKgwqDCoHJldCA9IGltcG9ydF9zaW5nbGVfcmFuZ2UoUkVBRCwgc3ItPmJ1
Ziwgc3ItPmxlbiwgJmlvdiwKPiAmbXNnLm1zZ19pdGVyKTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYg
KHVubGlrZWx5KHJldCkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91
dF9mcmVlOwo+IMKgCj4gCgpJJ2xsIHNlbmQgYSBwYXRjaCBub3cuCgo=
