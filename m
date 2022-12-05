Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966D1642B21
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 16:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiLEPNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Dec 2022 10:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiLEPMo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Dec 2022 10:12:44 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C32A33F
        for <io-uring@vger.kernel.org>; Mon,  5 Dec 2022 07:12:42 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B4MaVCU025048
        for <io-uring@vger.kernel.org>; Mon, 5 Dec 2022 07:12:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=TyohGtjr2SygXfOEilCODB/9xu45EMXCxzu7DwB4PK4=;
 b=fy7pMtVdvcSLISKdhc2ktqi2vwI7Uikk6uemtxM5h/qTpmQ60zXVH9c0LEjRgdsApfOP
 PeojRO7bXpFuppflMz1JWfJ/8TS59HbdxH8EXCKZpZc0nrgGLv/B2gykLTXnMC7LKDbJ
 lHpMg/W0EJ0Y/af3PqPnBCtHW83DOB38674y1nLYMb7eScRjXSWV2E2txNOrGwIDfG20
 pwEKUK2TrLTlHCM1JMVHzV02eUy32JluSxaeMBdixKvOfl6j4UiBwr26zPv5RY604J9D
 2MDEAOCCzfspWB6mJQJ4Zi5/IwzrglZge3a+Oa6QTm96VZT7OauRCYsOp0dG7HETLPLs lw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m84v5jyfw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Dec 2022 07:12:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCyWgQtQ1J4RNmaHoaMwb/6degPg8b2V/EqGioDhqkFeT6EAtcpE3Y7+NealKh0+PYBNZrwi2Qth74qGIbtGLxEiMPFMCDUr2vgUujw9pF0BibysQc6UspOg5m6On1SOsSXoSTIK3gcn6jQU/W/0oTPliTLkCtI68Fv8vcLeFc+k8rO9Vrk3FgZ04v9wBug6IzCDZdgXnrCTcOIL4va9nFu17T1S3obTp6i24YEClK+B0Jt3HSrIyKx/uGE7/ke5Lg8mttaD7hHOZhL9L+0YnEFVxV6ZJEADkkb8/ocmQAyJ77jzQrccIf4UsSvQU57pVUloS2PQab7jGB/OO/nuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TyohGtjr2SygXfOEilCODB/9xu45EMXCxzu7DwB4PK4=;
 b=XFJyHMzVDjNVCRTgSTsjCfxMmH+f62RnBAp5rqceEQqZeP2enZVQT3ICFcsXX/JWPC9CoPCHy8pqEPma7K4fFPbLcgButNYGwJW3vE2O72XF54hgAhM4OkfZQ3vCJrFwHuhlk207UY9fHehJRA872Q5ssCb/zD3Hp9R7LRYz9KS7IkJhD8fbHpAEO6k+BOJni9nglw0fkEzrEKAINCffozlTVRZVHFGZRYJVpkwgkh0POK6xW6r0udLM7aZBEPVDP1Q29/qr8+amgomiPxse/ZmG8Fc8yKZuBQkVyfXmW/3252h/fBALE0tnq00dMF+XlnmAsgAhdgHNkv4MPr/lAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA1PR15MB4872.namprd15.prod.outlook.com (2603:10b6:806:1d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 15:12:38 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5b6d:c9b7:796a:8300]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::5b6d:c9b7:796a:8300%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 15:12:38 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Thread-Topic: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Thread-Index: AQHZCFOv4Z05QaHJXUyhLxoMlZ1gQq5fL9MAgAA3ioA=
Date:   Mon, 5 Dec 2022 15:12:38 +0000
Message-ID: <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
         <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
         <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
In-Reply-To: <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|SA1PR15MB4872:EE_
x-ms-office365-filtering-correlation-id: d7019fa1-09c6-439e-07bd-08dad6d32591
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LFJXmCvsuKGMOix+6e3njO6DgFeNbqJzkhGDZrihYfuaS3+ir5Tl3eQ3F2EHFeo0lE58cxaI144FB2cYeyUXYbAbSXeaP8yQPX3LJF4cub3z55jp7HzY4aqbAz3Da9KZvbREQwCD9xgMayuwpXZvoPrdPYdlocrt3pin99xeehb8A1QKktWQcFTn7vT9a9Wo64vq76P0baO4FCfj32NeWIEOYDjbM+t8oiu1GQ8zxoVw2omSQi1zHNXI22zs7qTlLhn3BXJUhbnqiZw4ssLBoQVEGOCRt0dWM0CL/uip7HJjdxjValFS66k9eW9WnzqxekouYQHyW8r9JQK8xqxVdrm1hqC3YH21GniDaV2oHU7/Uj5zT44GUZ5/mZTd3ZyWevEmTx8u+DyEOfKE5CVq4s91YnAXPAfNVyKeBxnhiOKmqHN2c9UxTunCUGUHouqX9nb9tVmvFzwkqS3Bkqd48eQuN8SKK4xsaY5PYuWfqUmQ+vundEBqAu+sMDqeiPjCnQKZ4Lx3gYMKBZFfJS9F1jukOpaUNS+jdQkTiq97t/Z3f6KbatyKGuTl3lWEVGIFGLM6cLGpXFO1VhdvyGyDasNi6ntM5i9ZZp6RFQafETMBMxOL6ZZa8HkncvRuEfhyb+u6zhSPa4LPOYoXYJC/QTPd9/kj4NoeJaeun3Xjsrk041i3C3COZVhzeioP48Cp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(83380400001)(6512007)(9686003)(186003)(6506007)(478600001)(6486002)(38100700002)(8936002)(122000001)(41300700001)(2906002)(110136005)(71200400001)(316002)(66946007)(66446008)(66556008)(64756008)(8676002)(66476007)(91956017)(76116006)(36756003)(86362001)(5660300002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzJDUFlpdDhnUE1sR1VIUVI3K0J4ZVdoaW9xdlV0TXluZzJMamlnNktZd0Yx?=
 =?utf-8?B?dXdES2FVdkQzb251TUgxZkNqeG5Rbk5KY0krWjl6TWZycXdmeTFEN0pySXZz?=
 =?utf-8?B?dmI2MjR4K25zd0tRWWVEbGxZWWh4dnptb0h4cVpmeGFHSXIyU242aFBDTzVk?=
 =?utf-8?B?MTQrYW9iZ0lTRm96REdzRHJaTS9HQzRCSEZrWC9tRFQxV0Z5b1RmeGIzVlU5?=
 =?utf-8?B?YUtGVzRON3ZLMmFCSUVrTXN4cWM0QVpPNHlqTm9hY0ZsenJCb3RzODVRdkJ4?=
 =?utf-8?B?Qnh3L1J4ZGFuc1U3ajNqVDViQXdrWjBua0NwMFVUTUsweW44NGRJUTZhQWpk?=
 =?utf-8?B?Z0Q4Y0FpMDVmRWcwR0VEeVBNaWMzQlBNZUtKdGhRSS9Fcm8xUmhRYURKRDQ2?=
 =?utf-8?B?K3Y0TThubU5NM1FzL0psMnYrYkoxMFZPaVdvVC80R1NYVUFzeG8vcytBVEpT?=
 =?utf-8?B?L0x1ZXliOC94V1pDYzlPZkJabVVIZTBjZFBqUi80aDdRcG5pOGtYZkVQejQw?=
 =?utf-8?B?d0o2UnJLUU16RUp3NUxPazhqNHRiZTM2L3d6aURMOVFUOC9ZZGxxMnEzRzQz?=
 =?utf-8?B?UzFyM0FNcTY5V01UMkVkV21aUktJOGxDaW15SkFiUFlYZ2NTR2xaQVhiL2Zn?=
 =?utf-8?B?U29IVUlldERMS0FXK2dDOVV3R2Fvd0wySGhCdGVNbXBkZjd3V1NDbERPK2p2?=
 =?utf-8?B?Q0xGRDh2M1hsUG94eWtILy9iSXhORFp3bm8ySGVIRVhoWXViYVloZmtyakJW?=
 =?utf-8?B?SVFjcVNoejRLSndhbkp0SjFLZ1RUOHBaMTZ4UW83b2wwajhMTEhNTjA1L25L?=
 =?utf-8?B?SnhTWjB3N3RYRlFBQ1VZdDhVb084THhYcVd1azlWQlVwdEhRbWxLeG1GL0ov?=
 =?utf-8?B?aDJDQXExRFlma0tRelo1YXlvR2ZZS05Mck5PazR4Q2JDRld4a29DcVYvZDdV?=
 =?utf-8?B?aXQvREd4WmNNNWd4eDJrUUYxWUpVV09idFA2T1NZOW1pVUVIOHhJYnlpemdj?=
 =?utf-8?B?VlFQci8yQjNzTlNZazZ1bSt0THdmOHBQVERUZGc2NjJ6Z0lsOVAzY0Q1Rm5U?=
 =?utf-8?B?Q2liUTQvUlpJNk5NYkxzaUR2b0JzUUhBVWZSOE1xeDRodzdsdWdaa2lZVHhz?=
 =?utf-8?B?a3huMCtsR0xpWHVNRmlkY2xrSkt2aUdQSTg0VkVXVmI1NUJBZDhZdzJxa2FE?=
 =?utf-8?B?eU5KNnpObWM5ZlR1eTVyeHN0RE8zMDY3UEpUSjlZQ2RheWlqMWZoWGxBU2dF?=
 =?utf-8?B?OHhjV2NUdHRaOUFGNXVDMWI2bFJXOURNcFNmcldSQmNaa0JGU0J3bzlnUTlH?=
 =?utf-8?B?NEZXMzQ4VWhTcG1tUGZuZG5iejJyellLZnFUeVFJeWp4NUVBUDZQZFF6WklV?=
 =?utf-8?B?eXYvaFJkRm9YTEdQT3ZVdmt3am44WlNuVFA3UlBkMEIyU3F2UUprcFNNaklm?=
 =?utf-8?B?RS9SU0JndXFBWGVCcDAwWW9FOXNtd1JPQW51NGZFK3poOElmb1JpUUxPcGs3?=
 =?utf-8?B?K2s0eUpmMHBRQ1pLeG1uZURRR2RiQTNHV3lKZlNGcE5ZZk1TRSt0OTNnblNk?=
 =?utf-8?B?TmVVQ2E4TW5jYUswRkNlKzd2ZXJPam1SMUNtbXZMY3JBaXFvYXQxSVZXUkd6?=
 =?utf-8?B?QzNYY05HTFZPT1l6Rm0wNEVSeDlBYXc3ZWhGTE9xWmtZby8yeStxT0FDOVVr?=
 =?utf-8?B?dmxCazNHQlQ3SUswTUEyckE4SENVb2RwbTVrb2pEckl1K3ZUVHBnMXlGNE5p?=
 =?utf-8?B?NEFwdncycGNZRTgwL1FrV3hpWkR4RHZCdUwrWjVxdXlIS05ra2svcENxdXdm?=
 =?utf-8?B?Y3NqRnk1aW9WSFVlU2JrUHZxNkZLWU1yUEVvTzhqblRSMnk4cDQ4d0ZrSmx3?=
 =?utf-8?B?ZkE2S050RUFpU2V0QTB0WktGSkpVNktVaEd1V2g0QzIwSmtyL3lySTdaYnFJ?=
 =?utf-8?B?TU9HRUJKMGpqdkpTNHQyN294L01MUG1od1MrWjVSUkNEL2dSZGpmOWMzZTJz?=
 =?utf-8?B?YmNndzZaUldZYU9nWkhWU2hKRWx1MFVJdnowY1loRTFJcnRJdGlLSHpGTnVo?=
 =?utf-8?B?c3Nhd0prMm02VStQQ1pZOHlvRm5MUHlpbEtaNGhLNmp2eTlJb2dLeXh3NkhX?=
 =?utf-8?B?dFZNNDlVcUhzelowc1d5cnZEOUpGMzNIODlwcmNRdVM4WmRqYVNldDh5NTVs?=
 =?utf-8?B?V0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46BD8250D8E1034387E3239D8A6D58B6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7019fa1-09c6-439e-07bd-08dad6d32591
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 15:12:38.2896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FOF1jMYXSMBZsxxrXpGrMs0yNd5owur0jeO4xyJNqeYrwc2yxX/VMCv2aohDk1/A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4872
X-Proofpoint-ORIG-GUID: xRLDV861_CXteA5vFxUjLOZuN-0yLHd_
X-Proofpoint-GUID: xRLDV861_CXteA5vFxUjLOZuN-0yLHd_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTEyLTA1IGF0IDA0OjUzIC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMi80LzIyIDc6NDQ/UE0sIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiA+IFdlIHdhbnQgdG8g
bGltaXQgcG9zdF9hdXhfY3FlKCkgdG8gdGhlIHRhc2sgY29udGV4dCB3aGVuIC0NCj4gPiA+dGFz
a19jb21wbGV0ZQ0KPiA+IGlzIHNldCwgYW5kIHNvIHdlIGNhbid0IGp1c3QgZGVsaXZlciBhIElP
UklOR19PUF9NU0dfUklORyBDUUUgdG8NCj4gPiBhbm90aGVyDQo+ID4gdGhyZWFkLiBJbnN0ZWFk
IG9mIHRyeWluZyB0byBpbnZlbnQgYSBuZXcgZGVsYXllZCBDUUUgcG9zdGluZw0KPiA+IG1lY2hh
bmlzbQ0KPiA+IHB1c2ggdGhlbSBpbnRvIHRoZSBvdmVyZmxvdyBsaXN0Lg0KPiANCj4gVGhpcyBp
cyByZWFsbHkgdGhlIG9ubHkgb25lIG91dCBvZiB0aGUgc2VyaWVzIHRoYXQgSSdtIG5vdCBhIGJp
ZyBmYW4NCj4gb2YuDQo+IElmIHdlIGFsd2F5cyByZWx5IG9uIG92ZXJmbG93IGZvciBtc2dfcmlu
ZywgdGhlbiB0aGF0IGJhc2ljYWxseQ0KPiByZW1vdmVzDQo+IGl0IGZyb20gYmVpbmcgdXNhYmxl
IGluIGEgaGlnaGVyIHBlcmZvcm1hbmNlIHNldHRpbmcuDQo+IA0KPiBUaGUgbmF0dXJhbCB3YXkg
dG8gZG8gdGhpcyB3b3VsZCBiZSB0byBwb3N0IHRoZSBjcWUgdmlhIHRhc2tfd29yayBmb3INCj4g
dGhlIHRhcmdldCwgcmluZywgYnV0IHdlIGFsc28gZG9uJ3QgYW55IHN0b3JhZ2UgYXZhaWxhYmxl
IGZvciB0aGF0Lg0KPiBNaWdodCBzdGlsbCBiZSBiZXR0ZXIgdG8gYWxsb2Mgc29tZXRoaW5nIGFs
YQ0KPiANCj4gc3RydWN0IHR3X2NxZV9wb3N0IHsNCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB0
YXNrX3dvcmsgd29yazsNCj4gwqDCoMKgwqDCoMKgwqDCoHMzMiByZXM7DQo+IMKgwqDCoMKgwqDC
oMKgwqB1MzIgZmxhZ3M7DQo+IMKgwqDCoMKgwqDCoMKgwqB1NjQgdXNlcl9kYXRhOw0KPiB9DQo+
IA0KPiBhbmQgcG9zdCBpdCB3aXRoIHRoYXQ/DQo+IA0KDQpJdCBtaWdodCB3b3JrIHRvIHBvc3Qg
dGhlIHdob2xlIHJlcXVlc3QgdG8gdGhlIHRhcmdldCwgcG9zdCB0aGUgY3FlLA0KYW5kIHRoZW4g
cmV0dXJuIHRoZSByZXF1ZXN0IGJhY2sgdG8gdGhlIG9yaWdpbmF0aW5nIHJpbmcgdmlhIHR3IGZv
ciB0aGUNCm1zZ19yaW5nIENRRSBhbmQgY2xlYW51cC4NCg0K
