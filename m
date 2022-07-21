Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB057CA3D
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 14:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiGUMGA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 08:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiGUMF7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 08:05:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679C71838B;
        Thu, 21 Jul 2022 05:05:58 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26KNbDg5007617;
        Thu, 21 Jul 2022 05:05:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fFGdwL3bxdPZhWA46EkgxxN4pLDeIF7BmIP8Ez8JWjw=;
 b=cdApccJXS2NPimT5c5MjF6ZqUxBIZkVpQaiIfteF+FfYztdEhvI6l/kDRtsC7HIRu52Q
 VmnAjGYppeib1wK51UTq4ZhBT8qH8TPi7MShJEgfh98nvPqDFIWTb/OX+6G3PI/ikMDl
 GGlEVB8/gLG0AnLR7Zn6ezGNruABQnpzVH8= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hek9pphee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 05:05:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP+VToEeTcAKHFGRzdtM+ZrKihNJr78hzJPAWyqmRKpPPJIv7G2qIJNYNvbyJIP1GrlHP31UmjBvXdLeRgh/QjnfRIkTmR0s2xA0H2XjAT0a8N8ayRTP27MLkCx6c+Mqq+nwPui2V81e5xOAxdC3fGRHI28waet9EP891BewD/aRSeOXl7wM1iBCkubLbOG/jFa81v9b63BFMnUXLp47n+2beWfOzBGKkxnM7rB87Tpvu/jw2XS45nm0VCG7bzJGVt3GsoGzqTiWzip8JdFO5XBssb76nGp2kThQfkLuQVwg8n2boxzllfZFNAycYtPE7k8EDa1bagadSnc+oZOf+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFGdwL3bxdPZhWA46EkgxxN4pLDeIF7BmIP8Ez8JWjw=;
 b=cr4xi+TdvhGveMscWmbxltoIJkaYo8yO8TxsivoyoYPl/PouADG1VDoLAW1KOAawbRp3h6PTTQQ4kk7SN8M4T9w2ju7iTFIufcLqwhR/n1PC9srwRobFpaweKeIDmLnbJymzo5HrdGbVyjTIf/EVk+Syx58Mtp6sesC1jcBzx8hs+MZPgXXkvO65xuiebdHWbya1RXuYpkmV6cY5i+/O7xG87YfWY51Jg2nB2MdUHBEuJYvpG98dz05N/h7DO4CS2EOi+QIHjVfP7ea3WOVmTtOgIMNjjIx8ud/T1t7zyqCSStCwd02vf/1L4meKt615ag77srRuqFbWD03eCPcMdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by PH7PR15MB5426.namprd15.prod.outlook.com (2603:10b6:510:1fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Thu, 21 Jul
 2022 12:05:49 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::15b5:7935:b8c2:4504%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 12:05:49 +0000
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
Thread-Index: AQHYnI+FXh38kPC/ekCuYW7IUr0g+a2IlPEAgAAO6QCAABd0AA==
Date:   Thu, 21 Jul 2022 12:05:49 +0000
Message-ID: <e3987a2f55d154a7b217d86d805719043957db60.camel@fb.com>
References: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
         <3489ef4e810b822d6fdb0948ef7fdaeb5547eeba.camel@fb.com>
         <beae1b3b-eec3-1afb-cdf9-999a1d161db4@gnuweeb.org>
In-Reply-To: <beae1b3b-eec3-1afb-cdf9-999a1d161db4@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29c18f92-ed29-4d59-6a57-08da6b1159d0
x-ms-traffictypediagnostic: PH7PR15MB5426:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FgPFVtfLxUxMeRgx6PlZZucQiqauzeU5nHzctruaUwPwg6uvKn9fjuCG1G/R+FwhvntMvzeemiWzESKkjde8WjykJgEzAPlWXCJHdKR+rs8NFF0hEJFULEsv2fp0Fmmg6zTvndiEOBtDxqBROjqkqZlz69kIKpHMDL6vRGqPwp2rwYbaq9OUeTTdnYDpbX5LksccvNJkTZabJujvbNvhd+jukM14aAA4WlShqm2oicXJjDMAHBT6X/TRzoESEL3NDpFM1H15Lu8xyv8HgAuGaW3tXMZcUf0rUbQ/ouEw7YpTaAF2L09KS1MzIZby4NWm8hExDwPiRfTheyYKjzmOPI/ZMZctN/I8SNEh8OeSu8vUP3GBFaeeEZXqknQgxoPZj/ogwfa2AP2WnlEghoCdRjTYWnWm/J3r0UulRtMIQysZL/YYtVrO3XBlp5T2kGv4PXo6HZS7F4PcR79M59gMnUwGdHs/RdkESnBCa4QWq6CvPqEywxd9ps7zOH+MuSX9l8arr5pPg+Iki1FtFrKIBDIBNDXogZNAL4TwwUy3Mn5QNJgoq9e3W+8bcmrVJekZqIeRyDTy+v1i/Py+LvBBOqTYUv6TEJ8FL88Qp5oGmqDv/+FvMa2ooK0kTsPtahf3brEz2rMXQSZz3N8WTQdGs3naYRuVD/TO67YwfTN9P5C7xBEjmPfCDR1cnW+ozKKnD0HFSl6UFngs80FnRwYt3C7Uup5vBnMKFNoQHwk1uzdPSVGWZNqikCBd6oAEBovNpcKEKmVMQaN+zcotFZ8acSyW1+k4kMc2sAn876RJ8OJWveDCkcTUG9UK7MHaJ1w5UOC1/V8Sv63zIGOkAoYg5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(76116006)(38070700005)(66476007)(53546011)(64756008)(66446008)(66556008)(4326008)(91956017)(66946007)(8936002)(41300700001)(2906002)(6486002)(71200400001)(6512007)(6506007)(8676002)(122000001)(186003)(36756003)(478600001)(5660300002)(38100700002)(2616005)(86362001)(54906003)(110136005)(316002)(83380400001)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wnp5Z2tTeHNSbnZueFdDOCtvWlNhRjM0Z2FhQWczMjByYUtmQlBQUzI5Wjht?=
 =?utf-8?B?NldZaEJ3cEVqS1luNWVJeEZQNFpWUWJLOXdpTDh4WEFIUkdGMVU1bUhKOGZz?=
 =?utf-8?B?SnMzWHZ2cUtsb1ZNYjR5emd1WGN1ejVUNU5BQmdOdHl1VjNtMURodVhIKzlh?=
 =?utf-8?B?WUtXTlNyRTlKMnAzOU5sOTFNckFxaUh6Zy93WHpQb3lqNllMWEZCN1BnNTRh?=
 =?utf-8?B?Yi9GYllkczQzL2NrRW9qb0I5V3BySUdXb0xNNmNPNmlXQXZheDllVkZrbXQ2?=
 =?utf-8?B?WklVbmx1eXYyM3AxZC9NSE9XVXZrdUJPaU5WQVdDOU5pOGpNQk5CM3VOaGVs?=
 =?utf-8?B?Y1dHNVN1N1lMUk5WeWlhOHVzSDB6Q2paa1gvSzI3cnhyZ3BtRkl2N3BySEM0?=
 =?utf-8?B?RVBnRytxck9XWGg4dmFBbW4rS01GNWlqcGRuR2t0R3R2SlZKR0NQZ0lRSVRi?=
 =?utf-8?B?Mm8wc1VDOEdzSHo1REE1Vm40RXNWM09VT05zTDEwMkZmbUIyNk9NbzVzR2tC?=
 =?utf-8?B?VDBKckJFOWh5SkJnby9oOHptZ0hyd2lla3RUVFlzTzh0Z3pUby8rKytMM3d4?=
 =?utf-8?B?MER5RDdZakZidlN5WWdSNE1yTWRuYkhoai80UjNZZndaLzFpRGJTNHo5V0w4?=
 =?utf-8?B?ZFJ1TjY1dEloZkl2Q1djdkh0M1ZHT24rVk5reSsvRVVpTGdHVEYrNVAyM3Fw?=
 =?utf-8?B?N25zSWhBWUN5anBQb2xVSXhreTg5ejY5UTBzSUVKQVhiMjBRbHlvY1pmSDVE?=
 =?utf-8?B?ZXJYNGcvbXNRTzhYYVJMWm81QVZuR0ZWSzhCbWZtZitHT3U2eVNsT3JmUWx5?=
 =?utf-8?B?WkJLa0lPK3VTOFUyNHlkQi82UTcwVFVlRml0WFkzVnVCS0Zzam1DTFJvVzh5?=
 =?utf-8?B?N2hqRkwrVzV6WjhJYnB5NFY1Q0JQWGpIOUI2cE42eGJjbTBOVXRzRnIrSTBE?=
 =?utf-8?B?TDJXbS8wMTd4UVpvd0ZqbCtDWm81YXF4KzdITGdBcy9iSVBqR1QwczlCU1F6?=
 =?utf-8?B?djVHSyswTkFJQVNHcjJ1RDZsdkZhY2xnODhNY2h5c1JjTm4yMGtYSzRlRXBJ?=
 =?utf-8?B?TGh0dEFyNUFQS1ZxTlFMSm40Z0VBM0VMVzRuVXIwckQzY3dXOFJGN0ZLN1Fa?=
 =?utf-8?B?c3FDMDNkaDNMSzl1ZlZ3VVlKa2xvK0Q3dVJpTGd5OTNGdXQvZnBOMWJwK1cw?=
 =?utf-8?B?RS9ZL1BOMUgrYVU5TnpBUE5sUjVGdWFiRUhhMUs3dmZFbStMbXdWUkw1R0ZN?=
 =?utf-8?B?M1JzY0lHeFQyZE5TbXZRU211OURjNVl3dkxFMXNTRlVaZnZhS08vZi9QdGFm?=
 =?utf-8?B?dGl0TzQxWnY5LzkvenRUMDdmcjQ3ZUtJc2Z5eFJ1bWRGRE90anZMUzdTZGs0?=
 =?utf-8?B?WWY3OTVlcFZHNzI0MUxJNmprR1ZEWmFHVmc0QVZQOGpCTHErVTV2aG1ZT1ZJ?=
 =?utf-8?B?M2k3RWhjby9ldnFveWxwOEZWdzJvTDkxTmV2OEFlNi9OOCsxVXRiUHlaenNK?=
 =?utf-8?B?Tjh3RVJJM2FkRXR0UHBHZHFUMmJEcVhQL2luVHg5TlJuY210RlNOQTllcXZ5?=
 =?utf-8?B?a3FGRk5BalZ5WER6STFlUG1JVkMwcUp5UTZQQlVIMnNFN0dSb2g5UVNRMVB4?=
 =?utf-8?B?RGpnL3VYSlNpUlg5SXpuWVpuN1MxMGNacW0welV6YzBJZ0dtaFRvRUx6UGJh?=
 =?utf-8?B?Y29kbUhyWXVuMms3SFRja0RpWWVTN3VjK1hpcVNXRkFjMTFjZDllMFhvclhQ?=
 =?utf-8?B?NmFMd1pqNytFdnlWaEFMS0MwWmZwNkx1c2lQRG1RYnRhL3FKdWhBWEx2UkZn?=
 =?utf-8?B?ZTU1d3RoQ0ZlUU11NElPdlI4ZWNGY3pOcE9qck1VQ21ON3dha21ZNXJQTEMx?=
 =?utf-8?B?cEN3aWRqN29Mek5oUlZEVnNZU1RYTnZ3dHJRQXpQU0hva3B5eUJWaHFMNVk2?=
 =?utf-8?B?VDh5b1hENm01Ukh0ditTZi9jNGpIS0RENnowTHZJYnVQTXB2cVRvMHF4QlJU?=
 =?utf-8?B?R01FUC93RVRJUjRBaUtmK0FENXdhZTNEUkNOVkhSUWxSV01USHpESTh0bmZQ?=
 =?utf-8?B?SmFSd1RjTjRZWGszMlR6cC8zVmpydUU5bnNPOVYxY1lKZU91aTlYS2cwOWNv?=
 =?utf-8?B?V2ErZ3M0NzJ5dTNGYWhFTkYzTXZvYUM5NTd1Qmk3d01MSTU4R0tHTDJOcUZz?=
 =?utf-8?B?ZEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3256677931C1143ADA4E59777A717D6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c18f92-ed29-4d59-6a57-08da6b1159d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:05:49.1637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8bWXO943fVQj4+AiYTOfMRJPKyhcnrLUUrvxuYButE/kFz0u97v3NouPDb9zlEXf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5426
X-Proofpoint-GUID: bnSMO3DIzPwqhv2Cxd1OfFeSATDF_mG5
X-Proofpoint-ORIG-GUID: bnSMO3DIzPwqhv2Cxd1OfFeSATDF_mG5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_16,2022-07-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTIxIGF0IDE3OjQxICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToNCj4g
T24gNy8yMS8yMiA0OjQ4IFBNLCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IFdoYXQgZnMgYXJl
IHlvdSB1c2luZz8gdGVzdGluZyBvbiBhIGZyZXNoIFhGUyBmcyByZWFkLXdyaXRlLnQgd29ya3MN
Cj4gPiBmb3INCj4gPiBtZQ0KPiANCj4gSSBhbSB1c2luZyBidHJmcy4NCj4gDQo+IEFmdGVyIEkg
Z290IHlvdXIgZW1haWwsIEkgdHJpZWQgdG8gcnVuIHRoZSB0ZXN0IG9uIGFuIGV4dDQgZGlyZWN0
b3J5DQo+IGFuZA0KPiBpdCB3b3JrcyBmaW5lLiBCdXQgZmFpbHMgb24gYSBidHJmcyBkaXJlY3Rv
cnkuDQo+IA0KPiBBbnkgaWRlYSB3aHkgZG9lcyB0aGUgdGVzdCBmYWlsIG9uIGEgYnRyZnMgZnM/
DQo+IA0KDQpJdCBzZWVtcyB0byBiZSBhIHByb2JsZW0gd2l0aCBibG9ja2luZyByZWFkcywgYnVm
ZmVyIHNlbGVjdCBhbmQgUkVBRFYuDQpNeSBndWVzcyBpcyB0aGF0IGV4dDQveGZzIGFyZSBub3Qg
YmxvY2tpbmcuDQoNCmluIGI2NmU2NWY0MTQyNiAoImlvX3VyaW5nOiBuZXZlciBjYWxsIGlvX2J1
ZmZlcl9zZWxlY3QoKSBmb3IgYSBidWZmZXINCnJlLXNlbGVjdCIpLCB0aGlzIGxpbmUgd2FzIGFk
ZGVkIGluIF9faW9faW92X2J1ZmZlcl9zZWxlY3QNCg0KLSAgICAgICBpb3ZbMF0uaW92X2xlbiA9
IGxlbjsNCisgICAgICAgcmVxLT5ydy5sZW4gPSBpb3ZbMF0uaW92X2xlbiA9IGxlbjsNCg0KQmFz
aWNhbGx5IHN0YXNoaW5nIHRoZSBidWZmZXIgbGVuZ3RoIGluIHJ3Lmxlbi4gVGhlIHByb2JsZW0g
aXMgdGhhdCB0aGUNCm5leHQgdGltZSBhcm91bmQgdGhhdCBicmVha3MgYXQNCg0KICAgICAgICBp
ZiAocmVxLT5ydy5sZW4gIT0gMSkNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCg0K
DQpUaGUgYmVsb3cgZml4ZXMgaXQgYXMgYW4gZXhhbXBsZSwgYnV0IGl0J3Mgbm90IGdyZWF0LiBN
YXliZSBzb21lb25lIGNhbg0KZmlndXJlIG91dCBhIGJldHRlciBwYXRjaD8gT3RoZXJ3aXNlIEkg
Y2FuIHRyeSB0b21vcnJvdzoNCg0KZGlmZiAtLWdpdCBhL2ZzL2lvX3VyaW5nLmMgYi9mcy9pb191
cmluZy5jDQppbmRleCAyYjdiYjYyYzc4MDUuLmQ5ZmEyMjZmOGUzMCAxMDA2NDQNCi0tLSBhL2Zz
L2lvX3VyaW5nLmMNCisrKyBiL2ZzL2lvX3VyaW5nLmMNCkBAIC02NDcsNiArNjQ3LDggQEAgc3Ry
dWN0IGlvX3J3IHsNCiAgICAgICAgdTY0ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhZGRy
Ow0KICAgICAgICB1MzIgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxlbjsNCiAgICAgICAg
cndmX3QgICAgICAgICAgICAgICAgICAgICAgICAgICBmbGFnczsNCisgICAgICAgdTY0ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBidWZhZGRyOw0KKyAgICAgICB1MzIgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGJ1ZmxlbjsNCiB9Ow0KIA0KIHN0cnVjdCBpb19jb25uZWN0IHsNCkBA
IC0zODk5LDcgKzM5MDEsNyBAQCBzdGF0aWMgc3NpemVfdCBpb19jb21wYXRfaW1wb3J0KHN0cnVj
dCBpb19raW9jYg0KKnJlcSwgc3RydWN0IGlvdmVjICppb3YsDQogICAgICAgICAgICAgICAgcmV0
dXJuIC1FTk9CVUZTOw0KICAgICAgICByZXEtPnJ3LmFkZHIgPSAodW5zaWduZWQgbG9uZykgYnVm
Ow0KICAgICAgICBpb3ZbMF0uaW92X2Jhc2UgPSBidWY7DQotICAgICAgIHJlcS0+cncubGVuID0g
aW92WzBdLmlvdl9sZW4gPSAoY29tcGF0X3NpemVfdCkgbGVuOw0KKyAgICAgICByZXEtPnJ3LmJ1
ZmxlbiA9IGlvdlswXS5pb3ZfbGVuID0gKGNvbXBhdF9zaXplX3QpIGxlbjsNCiAgICAgICAgcmV0
dXJuIDA7DQogfQ0KICNlbmRpZg0KQEAgLTM5MjAsOSArMzkyMiw5IEBAIHN0YXRpYyBzc2l6ZV90
IF9faW9faW92X2J1ZmZlcl9zZWxlY3Qoc3RydWN0DQppb19raW9jYiAqcmVxLCBzdHJ1Y3QgaW92
ZWMgKmlvdiwNCiAgICAgICAgYnVmID0gaW9fYnVmZmVyX3NlbGVjdChyZXEsICZsZW4sIGlzc3Vl
X2ZsYWdzKTsNCiAgICAgICAgaWYgKCFidWYpDQogICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9C
VUZTOw0KLSAgICAgICByZXEtPnJ3LmFkZHIgPSAodW5zaWduZWQgbG9uZykgYnVmOw0KKyAgICAg
ICByZXEtPnJ3LmJ1ZmFkZHIgPSAodW5zaWduZWQgbG9uZykgYnVmOw0KICAgICAgICBpb3ZbMF0u
aW92X2Jhc2UgPSBidWY7DQotICAgICAgIHJlcS0+cncubGVuID0gaW92WzBdLmlvdl9sZW4gPSBs
ZW47DQorICAgICAgIHJlcS0+cncuYnVmbGVuID0gaW92WzBdLmlvdl9sZW4gPSBsZW47DQogICAg
ICAgIHJldHVybiAwOw0KIH0NCiANCkBAIC0zOTMwLDggKzM5MzIsOCBAQCBzdGF0aWMgc3NpemVf
dCBpb19pb3ZfYnVmZmVyX3NlbGVjdChzdHJ1Y3QNCmlvX2tpb2NiICpyZXEsIHN0cnVjdCBpb3Zl
YyAqaW92LA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgaW50
IGlzc3VlX2ZsYWdzKQ0KIHsNCiAgICAgICAgaWYgKHJlcS0+ZmxhZ3MgJiAoUkVRX0ZfQlVGRkVS
X1NFTEVDVEVEfFJFUV9GX0JVRkZFUl9SSU5HKSkgew0KLSAgICAgICAgICAgICAgIGlvdlswXS5p
b3ZfYmFzZSA9IHU2NF90b191c2VyX3B0cihyZXEtPnJ3LmFkZHIpOw0KLSAgICAgICAgICAgICAg
IGlvdlswXS5pb3ZfbGVuID0gcmVxLT5ydy5sZW47DQorICAgICAgICAgICAgICAgaW92WzBdLmlv
dl9iYXNlID0gdTY0X3RvX3VzZXJfcHRyKHJlcS0+cncuYnVmYWRkcik7DQorICAgICAgICAgICAg
ICAgaW92WzBdLmlvdl9sZW4gPSByZXEtPnJ3LmJ1ZmxlbjsNCiAgICAgICAgICAgICAgICByZXR1
cm4gMDsNCiAgICAgICAgfQ0KICAgICAgICBpZiAocmVxLT5ydy5sZW4gIT0gMSkNCg0K
