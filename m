Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8B562099
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbiF3QxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbiF3QxR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:53:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546CE2AE03
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:53:16 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25U9NQd8005231
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:53:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=65EOrNpunZ6EKHuCdpnH01yRp8ekQGL6Td2WvcSN0vw=;
 b=YYRjBiGooylH7Z7r/tH8InMeel9WBdeIyiK9N114dO1P4VwXcBBIv8lIb1n2XoN7UJQA
 3xhD6ZqLnXp7Rtn9tYAtGKQpofspTQVycMZe5XO13ZuR5qKt+MhCh/89XlUxm4hVTfE1
 ogPY2enJ2QhOdKFB3hg1JvkcW6wEIprc9rA= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by m0089730.ppops.net (PPS) with ESMTPS id 3h195a2x16-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:53:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqFDTbCpOe4ZqgPqpggRmFPeYMsWt1kMwySMGLU1DTUrGtgg7kp1yqPFgahsfkSW/8ISZX8Qut63ZCfc8acixJ/DGP0s+DxsRygwXIQclAI33jgXn23bCkAI3lAa9upbX4PYYURYfdvvqFfK6DKvdvR5SYfVEmjWcChcn6TIsdfRcHZlZ4XY3JOZ5RUlyrED3mhRjXuLMl8SfSrEpz31AN2pd1OsOy0nAkbG7AQOXF0p1uzuZjmi/5X/IQ8crXP8wrQhx0bpyN11y5w7Ze2mHSy2DL2jy/zkupxnNqHymsYCiTTtJpDSNWTm2TwKZczfwOWc0zoloMUjZGjGSrgqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65EOrNpunZ6EKHuCdpnH01yRp8ekQGL6Td2WvcSN0vw=;
 b=jVTxn2VZJpIxjSdqcF2iQrfzaj+x3Sl8BovoT3iXSdm7zcl6I5mHIQ1KRbJDNQuqdW2XZWIVp7PxD4wf+1kH1waXTdNCJhSsqiLu5TcuJBlu1K2ZfTkOjVgKKiKh2cKoClEqD1Uby+fA82wChf45zE8LavVq8r663MxqQULo+ZWvPXXVJMZMzFpsCOF2amTlQZIsziZNmIOcS0uB5GpfB4+1spKmrJtiONnlbk6dEDMhIdgyTT1HSVQFRWhYQb/ixKadq7+zYTg5qWr14Mzaz4pe+st+xolp99jeS9OTC1wA3qT4XjFWzKCvEe8V7DBH8EWsRFhtcaku3twQfoXPcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by CO6PR15MB4178.namprd15.prod.outlook.com (2603:10b6:5:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 16:53:13 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9cb0:7576:f093:4631]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::9cb0:7576:f093:4631%8]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 16:53:13 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2 liburing 5/7] add recv-multishot test
Thread-Topic: [PATCH v2 liburing 5/7] add recv-multishot test
Thread-Index: AQHYjGIzCLXKRRtRO0SIIy/hJ6x8uK1nz0oAgABbtQA=
Date:   Thu, 30 Jun 2022 16:53:13 +0000
Message-ID: <6111225a7715d466782755cdb67f0cf4fc5e97b5.camel@fb.com>
References: <20220630091422.1463570-1-dylany@fb.com>
         <20220630091422.1463570-6-dylany@fb.com>
         <CAFBCWQJqVZNQw8rxU1LihhVj5jkfTPqhHbHiPjh=Z6WiF+vODg@mail.gmail.com>
In-Reply-To: <CAFBCWQJqVZNQw8rxU1LihhVj5jkfTPqhHbHiPjh=Z6WiF+vODg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d6a9411-f1e0-4514-b92b-08da5ab90584
x-ms-traffictypediagnostic: CO6PR15MB4178:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OCD59JzEcfuhRgNj3AnZin/f0nEcN/8zpOVytaBAd74G2EhgkVFuIpwe4Dvz4zSAIRXZkUJFxUx120MrtorD2gMYm0+0Q0uQaD7ZoO+ID3J7VBfH9FzNFW6Evi/y8dVNA6LsXIyzZ9usj6BHIz96BC8ycfLPBspVSzaYFTt+40y7gZgAXBoDmgPRvESNWjXduimD6H6fEb1GQ9LLpil2QIfgzcA8sJCNfVpdaOOCijvm8YOE0LCtZqW8jMV6SOD/X5fURbWIKLGeBJOT751eSFkpIcGZQO+aqPB2SueSTWnrciS11uMeindGLOiztluUIXFC4cWnv+fvFPP0dc0DfAj4JVAIN9DE8QA0cspvZof3IeTrb5dsdT+P95zrdIK8kxG6mpXrMm/YFGHYLBjklG4fa+jWW4wwP+zcrmPGC3Cu/JnoMzjQyP7FcmMOs4MgsKVRruqhTD8MTsGRyal0ytlF4LVAO3sxKsE8DVsnze/Rm7vMEhCzvWAd8j1VuU21nNHHRtnU9mH5xxorGkRqGocfOczW/nzGgnvak3LclgoKPFDtheL0nTlyiWKul+YbiQEIBdapcBCCaIjhQeakXDQVkWtXwA7WDaDPSBUVpqw7AYjOJmbVv6C/BaKclCWdkTaM8d845I98X6K8T3X7kBFCyEq6b53Yo71u/3F8sSJt1KM7sX3fbKlGIRBwb2RlWhqSmkyNykoR+vx3MJikIKSDRzxWkIKa5hbHZ7mcTLc6ZcfWWFWzYvRi6hw7ThS8TtuF+5dPPg8vKSYRojK6roD+QC26bl+4IrZLGjAh3kgPArxE2sYg1Z6D6MC8brDV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(53546011)(6506007)(5660300002)(8936002)(4744005)(26005)(316002)(91956017)(86362001)(66946007)(76116006)(4326008)(38070700005)(64756008)(66476007)(8676002)(66556008)(66446008)(6512007)(6916009)(71200400001)(122000001)(6486002)(478600001)(54906003)(186003)(83380400001)(36756003)(38100700002)(2906002)(41300700001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFlXdWMrTXJ1amtZcnJvbGYvaHp5dmFlR2pTQUZxUG91UWxqMFNxVFBtd0Vh?=
 =?utf-8?B?a3hlN1Q3cEs3VUdLaGlrdVo1WU9IK1Q1cFBhL3Rxc1pDQTA3U3krQklFUFRU?=
 =?utf-8?B?Q1BxditoSWVXdlZuUFU4QVNXSkZ4WWx1Q2xrc2lXVThmemIxRkpJWndibHdq?=
 =?utf-8?B?ZTd5UnkyMjhCMC9xczd5Zi9YeDFMSHEyQ2x4dEFObnZmMmJRbWFxL0RkMCsy?=
 =?utf-8?B?Y3o1Z3dtcW96VVRRdHJvT3ErV0hYNEFOdVBoZGtXMlpKenRWNEJrd3pXNjVD?=
 =?utf-8?B?STNjSEx1MURmQVVxWFptenZXT0hXdnRYbzM5dHRCKzV1dEUzaDNXczJUOUE0?=
 =?utf-8?B?Tk9zQ3k3YW9NYklTWDRibUEvRWNDSjQ3dENFcEFWcUg3bnhJMk93Q1o4S3RC?=
 =?utf-8?B?S2M2a0hhTDVJcDhSR2RFaHRZbGlTS0wzaWdhYlI0NFRFdUR2Q2ZkejdFNU9R?=
 =?utf-8?B?dlA2a3VnOUo5Ui9Zd0RiSXVneUhGdVlyTVlBeFlIWHlxL2NGZDZ0dVlZYU9E?=
 =?utf-8?B?TzE0SXVscFpMaC9DT3JUWnZ6d25VMEtYYi8vZFNXcVl2UkdqbGtHanh4NTdP?=
 =?utf-8?B?V0laTjhjT3pWT1B3RFdUbnE0Y0dwZUtVTEo4anNld0dndlFXU2QxRzN5bXVw?=
 =?utf-8?B?QzdncHRhcnh5dnVIeWdCSlJVcUYwU0hGckhYUzZHYVhMZjdsUytva1NHelUr?=
 =?utf-8?B?NERYODVieTd5TVZTR0YxYWZMLzdoWTF1TERaSlpzNWJWMEJ3SE5SYzhsb0ln?=
 =?utf-8?B?ZWY5OEJiMWkwc3grV0dSSk9SQlR2ZmlUNlNRTmVkbEpQelA1MTh1QnRuMmZ5?=
 =?utf-8?B?YmU4ZVNsQmpjbExXQmg0QzA5NURSTDl4Vkl2c3FqcVpYa2Zkb1g1VmVYU3p1?=
 =?utf-8?B?K3RtT082dlV5aFJLQmY5MytNZHZqWG13RG8yNGZwcEp0dTk1RldGVmIwcU1H?=
 =?utf-8?B?cmpTTzFqQ3RrelRSMC9MNlZaZEUwOHFhQk9hQjBZSzNrTUpraEZaeGNseGJC?=
 =?utf-8?B?cnhRczcya2dPelNXZ2lrZ0dOQnpvaUdXZFhjOEFvR0JkY2hyNFJxYlhVa2tI?=
 =?utf-8?B?Y3hWUTg1QmNPcFZLWnZKbnNqNHJTL0NUcHJUekNBbjBiUUsreFBXam5SblJG?=
 =?utf-8?B?dmtiK2E3aDhKZ2NlYkZHWElXOGp3V2g0N3VlTndDeHpNQ0hKdHVnWE5sQUx2?=
 =?utf-8?B?T29TVjdDd0pmeG5XTE1qNXlQQ2hsRmhQRjhJYm1ZR20xVHNibmk3b2xRNW1K?=
 =?utf-8?B?M3REQ0gzR2cwVGVHSytjb2I2U0kzNVZNYTROL0YyL1lBSGt2MjlLRUhIejEr?=
 =?utf-8?B?c3RJUzcrTG8vV04xenp1Mmo1YlRBTE1iRE5Gdmtsa0Rwdi8rWlAxTkRFRHY5?=
 =?utf-8?B?MXo5LzRmbUJRVnAycTE2dUNYTnV4S0J2VWFTTjhieitwQVNzcGdNWCsrOEp0?=
 =?utf-8?B?aTFBU2RBOVQ5R2tXbFRiVnZXbXZiQlhxdXNsdE92R0c1TTdSRlBUWEIrQ1ZI?=
 =?utf-8?B?SytjVnBmam5xKzlkemVXNW9tUTR6Yi9TU1psY3NmTlluZVViNm5IbE1tMUNO?=
 =?utf-8?B?SEVuTEZ2L3RRMDJ6SkNoR2hSa1BEbHlNQk1NbkY2N0lBbjY0U3daSkVYVEFZ?=
 =?utf-8?B?QzQyWE1Jc2tEY2RyOTdSR01pREhTRUxiakJnRmU1MmdrMGlJWE8yZW9WNG11?=
 =?utf-8?B?SW9ya0FrNWF5V1NNNlIxVjFjcCtTUGpHYjNMbVRQRyszbU04T3NKdWNMbmNH?=
 =?utf-8?B?SlpNajdwVTFvVXNZL3lOWkRwaTFSbklrQnJQdWZ4aTZuZ3E2ZmxteUFqT0xZ?=
 =?utf-8?B?V2pnQ2dranZQVXNOa2NSWTVGa3dCd3hqS0k1Y1RSMTBhd05CclV4UFVKd0dH?=
 =?utf-8?B?VEQySCsyU042SHJJY0RKeWRCUTZFVEh1c1RvWEhhdXo0L2g4bjdMaFJqQWM3?=
 =?utf-8?B?NnA3b21WSURnYkFydmJpWlBOSzQ0bDRtS1l3S1YrYU9Kc253Ni9KY0l0Uno4?=
 =?utf-8?B?VklnWUxhNlB2TVB3M3ZzMXB4MGpTNnVzMjd3MEJYc0hqeDlIbDFJYkVqbWtT?=
 =?utf-8?B?aWdBZFpXa0w1ZXlNU2VaSnpxZDcwbEZvNFlHZHZWcWpVekdzUGZRMmtLdmtL?=
 =?utf-8?Q?Je5tWgFdKx+rwYf8tG0tDUhXE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <229A72D953589C49895F1AA603CBC303@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6a9411-f1e0-4514-b92b-08da5ab90584
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 16:53:13.4224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIVJNdzTzI01isKtVbavT0HxI2CGCXObilBgdFgeOskZOMVhhOJDphyn//f5wItS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4178
X-Proofpoint-GUID: XFFQAWH37UuqNChF5LLCjZlb3WOeFpvV
X-Proofpoint-ORIG-GUID: XFFQAWH37UuqNChF5LLCjZlb3WOeFpvV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTMwIGF0IDE4OjI0ICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
RHlsYW4sDQo+IA0KPiBPbiBUaHUsIEp1biAzMCwgMjAyMiBhdCA0OjE5IFBNIER5bGFuIFl1ZGFr
ZW4gd3JvdGU6DQo+ID4gYWRkIGEgdGVzdCBmb3IgbXVsdGlzaG90IHJlY2VpdmUgZnVuY3Rpb25h
bGl0eQ0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIFl1ZGFrZW4gPGR5bGFueUBmYi5j
b20+DQo+IA0KPiBTaW5jZSBjb21taXQgNjgxMDNiNzMxYzM0YTlmODNjMTgxY2IzM2ViNDI0ZjQ2
ZjNkY2I5NCAoIk1lcmdlIGJyYW5jaA0KPiAnZXhpdGNvZGUtcHJvdG9jb2wnIG9mIC4uLi4iKSwg
d2UgaGF2ZSBhIG5ldyBydWxlIGZvciBleGl0IGNvZGUuDQo+IA0KPiBUaGUgZXhpdCBjb2RlIHBy
b3RvY29sIHdlIGhhdmUgaGVyZSBpczoNCj4gLSBVc2UgVF9FWElUX1NLSVAgd2hlbiB5b3Ugc2tp
cCB0aGUgdGVzdC4NCj4gLSBVc2UgVF9FWElUX1BBU1Mgd2hlbiB0aGUgdGVzdCBwYXNzZXMuDQo+
IC0gVXNlIFRfRVhJVF9GQUlMIHdoZW4gdGhlIHRlc3QgZmFpbHMuDQo+IA0KDQpBaCBJIGRpZCBu
b3Qgbm90aWNlIHRoaXMgbmV3IHN0dWZmLg0KRml4ZWQgdGhpcyAoYW5kIHRoZSBvdGhlciBjb21t
ZW50KSBpbiB2My4NCg0KVGhhbmtzIQ0KDQo=
