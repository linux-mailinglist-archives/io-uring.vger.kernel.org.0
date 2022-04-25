Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B950E3A0
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiDYOvg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242571AbiDYOvf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:51:35 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58056DCF
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:48:30 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.16.1.2) with ESMTP id 23PDYPbB011683
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:48:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QLfH8TqQixGlLcclw6f3tZFZt2I+1AD0CUmEUVFkbks=;
 b=G8PYZgH8YkOpKIuI+y60/y/CqWbYUFLWROvM/GA6chBoNKkbxpmOYm0CIrlzVIzk0x+2
 rgBvjgzBPbi2nxkk4GmYg0IzJECzf1iWP38X1Uc9K6z46cXbaC1oh/Zbw1NSPAGUXNG0
 eCvnvJW4YXeWZ/oiYUP3KQ/HVeC8MhV9tnE= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmf6v27xg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:48:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5L9yCTamQ/xwA0/fipP5EL3+QwpobVY+Ia73PlFH7LjT3mamgVY/EfHJ2x8LHrW2ByprWzZPtXGvobuANCMSMst8Jfz9IMY8OcCQJpJW/3cM766fV5IVO/cWx5h+wczvxiLUOPaPi1S3MJBV3RJhuoqk8K2WYw4t4stO2eeXOhtQcbd54oCZO2FqizvdnSPQXP88dzcSZEEDr+bpTsFbXzU41VbSRNUQcZsxtaCX4SHhr3P7v+NaBxbDtWqVAfyuyaXdNE/Tp0flwcdwFN+f1v6nkG3cDPdKivZ9anleSScRtg/Ybie+bZpo95gM8xi3NjyUAaitph2miPs1ZF3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLfH8TqQixGlLcclw6f3tZFZt2I+1AD0CUmEUVFkbks=;
 b=B+9e5T89aJF+76PGA4ctgngT0XNOmuJvAojRrOP6z/hQPcSBFF1BUVQ+Pg3vFsWHjIE0aO1vuR0kUF2/1RdilfdPBIIOxm8xzWxTEirijPzWtVDt9OS1edWVGh+CKNrRWx9gS+Dkk6iKCzwfG2NAC9CFJ+IqyIuyw8RKi+DUiwMerepDJqFLkjeAVXsLqP/3iUPvyaqyMsxL7x+9tPRS1bI2S8fwyM45AJOg6I3qsjGFnlnI9s3NfoH2h4FarpccQpnGPnWfxuu01/W2g8vBfPBisI3v4IqcHI5/KSvXGtUiMlq9I3tJxQzyNQS4k7c3EG4MTCF/kR6MQN+lCyJ5Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Mon, 25 Apr
 2022 14:48:26 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::787e:eb9b:380a:2f0d%2]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 14:48:25 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: add io_uring_get_opcode
Thread-Topic: [PATCH 1/3] io_uring: add io_uring_get_opcode
Thread-Index: AQHYWIf2TU2fqKFuJ0iNrCitkEU7Xq0AkbSAgAAL7QCAABL6gIAABV2A
Date:   Mon, 25 Apr 2022 14:48:25 +0000
Message-ID: <6db369b4e8e0c598ff38d4b91b65004c59637b79.camel@fb.com>
References: <20220425093613.669493-1-dylany@fb.com>
         <20220425093613.669493-2-dylany@fb.com>
         <5e09c3ea-8d72-5984-8c9e-9eec14567393@kernel.dk>
         <911a8804fbaa3a564214971e9a3e5b19ddd227db.camel@fb.com>
         <09b305e7-ff07-ee4e-8603-fddf7931e0a8@kernel.dk>
In-Reply-To: <09b305e7-ff07-ee4e-8603-fddf7931e0a8@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf4d554f-3063-4ff1-c1a6-08da26caa756
x-ms-traffictypediagnostic: BYAPR15MB3032:EE_
x-microsoft-antispam-prvs: <BYAPR15MB303253C02A527788DE12690DB6F89@BYAPR15MB3032.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Jcw1Bj6NAvlOIdwusqbjGV62a7AoMekP23t4jBMrCNFFYTP3j1hNAqDalAhPKwUWmrdLsdf6IQ4CGDDY0VxsiIqSiS8TYwep/MQKunzQknnVg3Qnb7lcCJ0YWaSE4ECrP/VZiPXDyiJKCw0oJWkcxTA7fKVQ/7fefEFCP5t+ctndlG6OrDvTOIQ6WIZ804obZDKAWCdqXFv0KFlAuxliTCW/mMGbyjuX1UsBgfzISXbPfNgQgmwRRoMgJzvUgwy9PGUWIEq9oQfCu5V6Y3OIMA3z4kAEQDXLeGHUKrj8cJtXWr0FrLho0dlYn6VETGuU4W3kWMYPVdP10pfLDp4O/YdpRmctq1433MmngZfTFwkrIUkNJ+DkNAJWNyLJuDOnW61SI/J9eTdWQhwfETi9Q2oB0LcpH5nIL6X9I41/VzzhxcEDzMJ8xYRXh61sBep8mX/PEUlC4lpdliskt+Uml+ml8FJD8vQgejLg7x9EpOyt16h8osrEyz1dWhaipmBTjfn+ZVW0p283dBbvO8vznENk4lbXneQe+Kq8foC+RKhmZ7812a1JzDVfR01bzofJYjkuLpEiJZ2lGf6FMZFC12xP3hnn/XXtXaCKU5BNiZIibPqlgw0AQNwsQj+rFH5TIo1VrpwU716a0GjMCalJgKyYMgFDChSRv3sEK99cpb3Ah93OxVeOVCsLUV5HHiSLqrFJfK9Em7/m8giioA2Xw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(2616005)(508600001)(8936002)(86362001)(6506007)(53546011)(6512007)(2906002)(122000001)(38070700005)(38100700002)(6486002)(186003)(83380400001)(66476007)(110136005)(66556008)(64756008)(66446008)(8676002)(76116006)(54906003)(66946007)(71200400001)(316002)(91956017)(36756003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWZETERIcitseU9iMFBXV1U3TFhoMVYyVENOek9FZlNDMWRlNTZPUmtwdi9k?=
 =?utf-8?B?cWt6Y21kN0NrY1RORDAyZmVibFBTRlNaRTdGLzNOTnRXUkF1YmY2SVZ4T1RV?=
 =?utf-8?B?ZUFDcnppTTFVazRsaS9OZnc0Mk9tU0d4NHBnakdOUm55VWtTYTFoaWZMdUpF?=
 =?utf-8?B?WnVEQ0k1NnduZlFvdzlIa3NyczA5NmUvRkxHU0UybnlRZ2tObVNxYjc1ZVVP?=
 =?utf-8?B?OGJYVExaQUNLSDl2aGxpQ3htZ2JpT3NmT1R2Uk85RFJGVzlCZ1ZJenRHOEFh?=
 =?utf-8?B?L2hWRU1FdkxDdDhiZnVnUGF6NU10bTFoL0syUnJSZFhzZFRVNldVL2orRmhp?=
 =?utf-8?B?cTYrS09ZMjBpVWJIaGgzVlRGNUppN0VFUmRBcWxzTmJjcHRVZEVVbTVZWDRQ?=
 =?utf-8?B?a043bHF3M1Jub1JjNzlnSnMzUnNGOWxkbkFkaDB1NHpJZU0vcDVqNFZTSjRn?=
 =?utf-8?B?WGFDZGg5cDBVSURDa2E2enVNdmdBT2NBNVlSaE5BMDk0UHZOU1EyeHZoNW1S?=
 =?utf-8?B?eU8xYlN1M1B2Vi8wUUNOMDkwRHlOb0ZWZkdSRk9XQTR5V2dtVHp6Rm1vZjYv?=
 =?utf-8?B?bForanZ6UHpucTBLQXUvaXhWYk5FQmFxU2Fkb0J3RjZlWklNRGllai9Bcmp0?=
 =?utf-8?B?ZllOUHJvK0JQeExmMXBJazYvOUdYUllTQUxrUjJqRW9JTVRjc21BOWlHS3Mw?=
 =?utf-8?B?SFE3eEYvUk9SeFJoQWk1a0FGWkRRNUxFL21ORWwzSHpQbVIzNnpuUmRad1o5?=
 =?utf-8?B?TVlKc0FMaUg2bE5qcjJZTVR4NGxmY1gvdHpuNCtUdVQyY2k1MnBBMlNWNXdS?=
 =?utf-8?B?RzBIOWYwcVNOb3M3UnJLc2xTTk9jSEhReDBNNWc5M0xBR1NFRm5IWkZYT1N3?=
 =?utf-8?B?bjZ1eWxCaGJ2eC9TSmE2WkVUZ2JZcnZlR0NvcVJpb1FjRGlUVGRtT0V5NGVC?=
 =?utf-8?B?RnRiMmR4TVJkclVYNTBnUUlaTHh0SVFPNTQ3SHdaU1RlNzhucXZxMlRtSWNY?=
 =?utf-8?B?R3lCcVJjMUt3ZlQ2ajVrdzgxNUdTU2N6WGNiTzB4N2V5akQyNkRjZnNFUmVk?=
 =?utf-8?B?WXZnZE5WQ0loYUlBbURZV0tYOEo3Y2VNWG15MkdHYlV5Z25sK1F6QTUweldk?=
 =?utf-8?B?VHRpQ1Fzd2R6NXNHNVdoeXVDN3RZaWUvYUEzNTk2bmhNR1ozL2diRnJWbkM4?=
 =?utf-8?B?eVVXNkhPS1BvOGJESVE1eE1JZFJ2aWlQN05uVlU2NkZYaUtaSjVmL0QzZmR1?=
 =?utf-8?B?emtNVy9BWk9NODVhVC9qL3JTZDQvOThQWEJnQWFTOWRnYmx0NjFxZDF0S1Rl?=
 =?utf-8?B?L3VGVnVmLzA5WC9yK0VMUDJBTysvN1JLaXJFUlI2OVlzVDRGWGxVMVpIdXpr?=
 =?utf-8?B?UGlqZWlBV1dNZXFoT1EyQk85c0lHaTdTa0c1MzFXOG1UN25YSG1jTGVsZHF2?=
 =?utf-8?B?TVJSc2lwR0RpQ1hyRUdLMlpTa3IyZEx0cXkrQUJyeUtIai84LzJDWkVmbm5r?=
 =?utf-8?B?R3k4MUkyQjR2TWZLNVlZM3UxM0d3UVQyTy9WZXpSUU0wU0ErT3JCUm40eXFh?=
 =?utf-8?B?eCtKcWVhSHVhN09hRUk3Tmc4N3BvUm9VYW1ISUYvMjlUZk5kSktsZzEzb3E2?=
 =?utf-8?B?N2UxbE5WczQ1NXFBUjFEZmNvTE5ZdEgyMDJEU1Juc2dQcWh4cFJFUWxUdHY0?=
 =?utf-8?B?WXFXYzRNZFFURW0wZmxRajUwcWRMVGtNM2Z3NVhSS1pSbE5iSElLcGRkY2h1?=
 =?utf-8?B?ZmYrVEtXVUY5OHpMQ2EyYWJsYWJFTmRkY2p3WldaVERTc3JtRlFxTEZEQWRh?=
 =?utf-8?B?ZE1FcnJVTXRVTVAvY2RUbFFnZWlGNTRpa3BqZU1JZEhUTGFTbnRPUlpjTERI?=
 =?utf-8?B?Y0JiSEVCaks5WkhMb0s5eXdiQXVyajdLUUJsdmsrVFBuZ2x3KzBwL2k5eUpP?=
 =?utf-8?B?c2RITno4MXdGRjhROFgrT0EzNFhSZUllMGVwNDh2bmM4VExsTHRzTTViK25t?=
 =?utf-8?B?eFM1ajV6WjA3RXhYTnV1OEh1WjVVdlNneDFOVTRFK0NzUGdJRVFaVFRSSTYz?=
 =?utf-8?B?aEJyaC93cWphN3hVQTU2VG1BaVRuY3prTlV2SFVXZDZjd0l0Y0hzSjlJWC9k?=
 =?utf-8?B?T21jUmc2ZUloTlNIRVBTYVJlUTZGU2U1NVBZbEZuLy9uQ2dNd2UzL1VoY0N6?=
 =?utf-8?B?dUJzRUpHYVl5bHdzUTJLdkZEa1dIT1pDL2QxM1FiZUw5SjRnSWVPbm80UzZh?=
 =?utf-8?B?dzZEMjZ1YzFFSjhpZWo3Q2p1ZWlNMkNBbG40emUrRmlVSFJhK296d3hwNktW?=
 =?utf-8?B?WVJoeUtWS0NrZmNQV1dIMW51eU9NVERwVEdIU2d4OExZOEd1Qzc1Sjloa3hi?=
 =?utf-8?Q?Saqdx4icSpwqPeQs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA71AE8EA74AE14FBDB5D3938B0086EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4d554f-3063-4ff1-c1a6-08da26caa756
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 14:48:25.8607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mwZIa4hbwuGulOXUwuc3krZ02FWB5V1RgAx3INZ6RiL0vqGNPS8Ip1V8VwMMLbu4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3032
X-Proofpoint-GUID: cNy-i4v8UuNPGLIYhI-TXZ9QMzo0I5M5
X-Proofpoint-ORIG-GUID: cNy-i4v8UuNPGLIYhI-TXZ9QMzo0I5M5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTA0LTI1IGF0IDA4OjI5IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+IE9u
IDQvMjUvMjIgNzoyMSBBTSwgRHlsYW4gWXVkYWtlbiB3cm90ZToKPiA+IE9uIE1vbiwgMjAyMi0w
NC0yNSBhdCAwNjozOCAtMDYwMCwgSmVucyBBeGJvZSB3cm90ZToKPiA+ID4gT24gNC8yNS8yMiAz
OjM2IEFNLCBEeWxhbiBZdWRha2VuIHdyb3RlOgo+ID4gPiA+IEluIHNvbWUgZGVidWcgc2NlbmFy
aW9zIGl0IGlzIHVzZWZ1bCB0byBoYXZlIHRoZSB0ZXh0Cj4gPiA+ID4gcmVwcmVzZW50YXRpb24K
PiA+ID4gPiBvZgo+ID4gPiA+IHRoZSBvcGNvZGUuIEFkZCB0aGlzIGZ1bmN0aW9uIGluIHByZXBh
cmF0aW9uLgo+ID4gPiA+IAo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIFl1ZGFrZW4gPGR5
bGFueUBmYi5jb20+Cj4gPiA+ID4gLS0tCj4gPiA+ID4gwqBmcy9pb191cmluZy5jwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB8IDkxCj4gPiA+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwo+ID4gPiA+IMKgaW5jbHVkZS9saW51eC9pb191cmluZy5oIHzCoCA1ICsrKwo+
ID4gPiA+IMKgMiBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRpb25zKCspCj4gPiA+ID4gCj4gPiA+
ID4gZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9mcy9pb191cmluZy5jCj4gPiA+ID4gaW5k
ZXggZTU3ZDQ3YTIzNjgyLi4zMjY2OTVmNzRiOTMgMTAwNjQ0Cj4gPiA+ID4gLS0tIGEvZnMvaW9f
dXJpbmcuYwo+ID4gPiA+ICsrKyBiL2ZzL2lvX3VyaW5nLmMKPiA+ID4gPiBAQCAtMTI1NSw2ICsx
MjU1LDk3IEBAIHN0YXRpYyBzdHJ1Y3Qga21lbV9jYWNoZSAqcmVxX2NhY2hlcDsKPiA+ID4gPiDC
oAo+ID4gPiA+IMKgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgaW9fdXJpbmdf
Zm9wczsKPiA+ID4gPiDCoAo+ID4gPiA+ICtjb25zdCBjaGFyICppb191cmluZ19nZXRfb3Bjb2Rl
KHU4IG9wY29kZSkKPiA+ID4gPiArewo+ID4gPiA+ICvCoMKgwqDCoMKgwqAgc3dpdGNoIChvcGNv
ZGUpIHsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX05PUDoKPiA+ID4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gIk5PUCI7Cj4gPiA+ID4gK8KgwqDC
oMKgwqDCoCBjYXNlIElPUklOR19PUF9SRUFEVjoKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gIlJFQURWIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9S
SU5HX09QX1dSSVRFVjoKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gIldSSVRFViI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9GU1lOQzoK
PiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gIkZTWU5DIjsKPiA+
ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX1JFQURfRklYRUQ6Cj4gPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJSRUFEX0ZJWEVEIjsKPiA+ID4gPiAr
wqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX1dSSVRFX0ZJWEVEOgo+ID4gPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAiV1JJVEVfRklYRUQiOwo+ID4gPiA+ICvCoMKg
wqDCoMKgwqAgY2FzZSBJT1JJTkdfT1BfUE9MTF9BREQ6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuICJQT0xMX0FERCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBj
YXNlIElPUklOR19PUF9QT0xMX1JFTU9WRToKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gIlBPTExfUkVNT1ZFIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2Ug
SU9SSU5HX09QX1NZTkNfRklMRV9SQU5HRToKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gIlNZTkNfRklMRV9SQU5HRSI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBj
YXNlIElPUklOR19PUF9TRU5ETVNHOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiAiU0VORE1TRyI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19P
UF9SRUNWTVNHOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAi
UkVDVk1TRyI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9USU1FT1VUOgo+
ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAiVElNRU9VVCI7Cj4g
PiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9USU1FT1VUX1JFTU9WRToKPiA+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gIlRJTUVPVVRfUkVNT1ZFIjsK
PiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX0FDQ0VQVDoKPiA+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gIkFDQ0VQVCI7Cj4gPiA+ID4gK8KgwqDC
oMKgwqDCoCBjYXNlIElPUklOR19PUF9BU1lOQ19DQU5DRUw6Cj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJBU1lOQ19DQU5DRUwiOwo+ID4gPiA+ICvCoMKgwqDC
oMKgwqAgY2FzZSBJT1JJTkdfT1BfTElOS19USU1FT1VUOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiAiTElOS19USU1FT1VUIjsKPiA+ID4gPiArwqDCoMKgwqDC
oMKgIGNhc2UgSU9SSU5HX09QX0NPTk5FQ1Q6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuICJDT05ORUNUIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9S
SU5HX09QX0ZBTExPQ0FURToKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gIkZBTExPQ0FURSI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9P
UEVOQVQ6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJPUEVO
QVQiOwo+ID4gPiA+ICvCoMKgwqDCoMKgwqAgY2FzZSBJT1JJTkdfT1BfQ0xPU0U6Cj4gPiA+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJDTE9TRSI7Cj4gPiA+ID4gK8Kg
wqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9GSUxFU19VUERBVEU6Cj4gPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJGSUxFU19VUERBVEUiOwo+ID4gPiA+ICvCoMKg
wqDCoMKgwqAgY2FzZSBJT1JJTkdfT1BfU1RBVFg6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuICJTVEFUWCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElP
UklOR19PUF9SRUFEOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biAiUkVBRCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9XUklURToKPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gIldSSVRFIjsKPiA+ID4g
PiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX0ZBRFZJU0U6Cj4gPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJGQURWSVNFIjsKPiA+ID4gPiArwqDCoMKgwqDC
oMKgIGNhc2UgSU9SSU5HX09QX01BRFZJU0U6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuICJNQURWSVNFIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9S
SU5HX09QX1NFTkQ6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJu
ICJTRU5EIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX1JFQ1Y6Cj4gPiA+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJSRUNWIjsKPiA+ID4gPiAr
wqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX09QRU5BVDI6Cj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJPUEVOQVQyIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKg
IGNhc2UgSU9SSU5HX09QX0VQT0xMX0NUTDoKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gIkVQT0xMX0NUTCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElP
UklOR19PUF9TUExJQ0U6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuICJTUExJQ0UiOwo+ID4gPiA+ICvCoMKgwqDCoMKgwqAgY2FzZSBJT1JJTkdfT1BfUFJPVklE
RV9CVUZGRVJTOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAi
UFJPVklERV9CVUZGRVJTIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX1JF
TU9WRV9CVUZGRVJTOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biAiUkVNT1ZFX0JVRkZFUlMiOwo+ID4gPiA+ICvCoMKgwqDCoMKgwqAgY2FzZSBJT1JJTkdfT1Bf
VEVFOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAiVEVFIjsK
PiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX1NIVVRET1dOOgo+ID4gPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAiU0hVVERPV04iOwo+ID4gPiA+ICvC
oMKgwqDCoMKgwqAgY2FzZSBJT1JJTkdfT1BfUkVOQU1FQVQ6Cj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJSRU5BTUVBVCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDC
oCBjYXNlIElPUklOR19PUF9VTkxJTktBVDoKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gIlVOTElOS0FUIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9S
SU5HX09QX01LRElSQVQ6Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuICJNS0RJUkFUIjsKPiA+ID4gPiArwqDCoMKgwqDCoMKgIGNhc2UgSU9SSU5HX09QX1NZTUxJ
TktBVDoKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gIlNZTUxJ
TktBVCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIElPUklOR19PUF9MSU5LQVQ6Cj4gPiA+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJMSU5LQVQiOwo+ID4gPiA+
ICvCoMKgwqDCoMKgwqAgY2FzZSBJT1JJTkdfT1BfTVNHX1JJTkc6Cj4gPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuICJNU0dfUklORyI7Cj4gPiA+ID4gK8KgwqDCoMKg
wqDCoCBjYXNlIElPUklOR19PUF9MQVNUOgo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiAiTEFTVCI7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoCB9Cj4gPiA+ID4gK8Kg
wqDCoMKgwqDCoCByZXR1cm4gIlVOS05PV04iOwo+ID4gPiA+ICt9Cj4gPiA+IAo+ID4gPiBNeSBv
bmx5IHdvcnJ5IGhlcmUgaXMgdGhhdCBpdCdzIGFub3RoZXIgcGxhY2UgdG8gdG91Y2ggd2hlbgo+
ID4gPiBhZGRpbmcgYW4KPiA+ID4gb3Bjb2RlLiBJJ20gYXNzdW1pbmcgdGhlIGNvbXBpbGVyIGRv
ZXNuJ3Qgd2FybiBpZiB5b3UncmUgbWlzc2luZwo+ID4gPiBvbmUKPiA+ID4gc2luY2UgaXQncyBu
b3Qgc3Ryb25nbHkgdHlwZWQ/Cj4gPiAKPiA+IEl0IGRvZXNuJ3QgY29tcGxhaW4sIGJ1dCB3ZSBj
b3VsZCBzdHJvbmdseSB0eXBlIGl0IHRvIGdldCBpdCB0bz8gSQo+ID4gZG9uJ3QgdGhpbmsgaXQg
d2lsbCBicmVhayBhbnl0aGluZyAoY2VydGFpbmx5IGRvZXMgbm90IGxvY2FsbHkpLgo+ID4gV2hh
dAo+ID4gYWJvdXQgc29tZXRoaW5nIGxpa2UgdGhpczoKPiAKPiBJIHRoaW5rIHRoaXMgd291bGQg
YmUgZmluZS4gV291bGQgcHJvYmFibHkgYmUgY2xlYW5lciBpZiB5b3UganVzdAo+IG1ha2UKPiBp
b191cmluZ19nZXRfb3Bjb2RlKCkgdGFrZSBhbiBlbnVtIGlvX3VyaW5nX29wIGFuZCBqdXN0IGZ3
ZCBkZWNsYXJlCj4gaXQKPiBpbiBpb191cmluZy5oPwoKSSBjYW5ub3QgZG8gdGhhdCBiaXQsIGFz
IHRoZXJlIGlzIGEgc2VwYXJhdGUgZnVuY3Rpb24gZm9yCkNPTkZJR19JT19VUklORz1uLiBUaGF0
IHdvdWxkIGVpdGhlciByZXF1aXJlIGRpZmZlcmVudCBzaWduYXR1cmVzICh1OAp2cyBlbnVtIGlv
X3VyaW5nX29wKSBvciBpbmNsdWRpbmcgdGhlIGVudW0gZXZlbiB3aGVuIG5vdCBlbmFibGVkIGlu
CmNvbmZpZy4gQm90aCBvZiB0aGVzZSBmZWVsIHVnbHkuCgpJJ2xsIHNlbmQgYSBuZXcgc2VyaWVz
IGdpdmluZyB0aGUgZW51bSBhIHR5cGUuCgpEeWxhbgoKCg==
