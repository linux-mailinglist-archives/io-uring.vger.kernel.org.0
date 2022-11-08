Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D954620D28
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 11:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiKHKXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 05:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiKHKXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 05:23:48 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D94515FF6
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 02:23:46 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A85qUJV019469
        for <io-uring@vger.kernel.org>; Tue, 8 Nov 2022 02:23:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=AzSebEzMrXuiPse942zqhtGdjiddZLojhnInDNREAAU=;
 b=JWTIQUQcaV2bKxFDvDldEu3ebi7A+wNCw6STGIvTMS2fjYgM+TaXWmJN0MIYPl3VLPNT
 ETDIvP5dnptndDZpsQmI1eZDvqZF82/EbgUxPqvorCTHGWIUPSkcHPKVUVI78YnC7BTT
 4HHgBUQgFlaUS94aOmzGG42G8y9zQCoj1e0XkdGvLFddwbOKU69YdbpmvBnh+wZ+xj04
 JL+0M9QbAK2NGD0b0j4fUTztV00icTSbJchWzRu+3zxQCvQr9wyMAHnKIrq7qBO1Hwot
 u4GjF57vAAisLdZIt/3qU7/uaf+HJE2D2w/vAtttS48DmfCnzS8bNemneLQuoBrSftw8 KA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqhba1dhd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 02:23:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bgkn5b1BAt6+0uYSwGT4uDL8U+ud75HmdRgZHxhK0VmcO2xHVfKeWR1j4wPmtFM1Isy0/1o25ssKb0CcqdbmyBWQw0tPNWE2ITImiw+9EEeyrYQWUkQLAJbW2IdYoo/ddiuoxyO4K1P/5hCMbA71o3D64C91OAVrxraVlWADT4VzLsmdKtq8idTyxzMxdo3H5W/TH4KQuWp4nMNHpByFyfz9wY2cQOrOGaGgJ+lfaSaenthsqFCTV01gY7NSXKJQ31sO/uLXGIhHAqUzrYZfSY1HLMyTEZWMdoOxH9jmVdJIXygQEDZzajnetOXcEDNwmnXYswtJ8Rxh3+EIxVOPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzSebEzMrXuiPse942zqhtGdjiddZLojhnInDNREAAU=;
 b=B6Geus+ni0w1WfqZ1gX+8ICHiHmLEkEQ2Dtl0118ATHRYHLw0QqxcyRY3GZ/qS5ngp0DPqixUwClBklaOekrOk7rFBKuknF+UNHT7uVQJyB59mYENckYJ1MZFR97ELZF+VHVC/QIWrif7+ksFZUaWv8UkqPtdxotLXdd3yClCLziQyeD/qIdx7WkhOoDlNtc41jLU2zFUWumC2F9KLeDCgLAXTa8NoLy2s40SpVykEhsFuiT4Z7PwwlQE89+TWjRFNMrgL5AP/ncy9Ujx40lXnIKcIaW/niwh6xv4N971z2R5h3jBoI0NjihMXj0dbHoice8bPoe4wbpmttUmT08AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by PH0PR15MB4607.namprd15.prod.outlook.com (2603:10b6:510:8b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 10:23:43 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 10:23:42 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2] test that unregister_files processes task
 work
Thread-Topic: [PATCH liburing v2] test that unregister_files processes task
 work
Thread-Index: AQHY81gJJSkeYqqLbUenU4kM1MVh+a40y/KAgAAFtwA=
Date:   Tue, 8 Nov 2022 10:23:42 +0000
Message-ID: <a09a79f619a7fd1d9919e4dca8ba53d48fe9c90f.camel@fb.com>
References: <20221108095347.3830634-1-dylany@meta.com>
         <ec9d2f60-5182-15f8-6648-8632d5b67698@gnuweeb.org>
In-Reply-To: <ec9d2f60-5182-15f8-6648-8632d5b67698@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|PH0PR15MB4607:EE_
x-ms-office365-filtering-correlation-id: a106435f-a273-4260-1154-08dac1734fb7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4M+4kh/HuLYfaHwR5SruEkE4ZQWplXvnciqRWS5nNtYcamK4awyp9YSG1yyqp0hq+iPgDmLd0WvfXGX0P0eTnwR3OvWWiGXz6egj5MdJB/IOogxYP04qomR0E2SfZwhMH/k7ZR31Gehvsso56IY54fxHaWlldGvA45J+Cmc4FgqKw9VgJXAwfoiH8Alvrfn8irxENgvnMDNTmEW45fyn56Xb9lg9/E+TKulgORYalUcCqdnIM56zc4pCY4lUkK46zS5ASy+3sI4DO2c4ujRl3IfZGyGjv/Bac4O7zJzkgzU8E61XmbSsMm6fJWBMyRhsiZ764GFrOmhzHPNU/T1KRhp5qI7qaKTi8xy8JsUfxuvMQ6AmzLr/O6R4vGbqhYpV63JW/xDhoFTqMWhWmmkDYKUl28c5pfq8G15C+FklBsNy56cQl5U35VKcyyZtu/QachBI0F9CPplufj3lxXHVI64d1TXvXRmBbF8ozb+hrsf+K0ySPHxYagjI6VB2AUhD4+xv+M5XUwIVzbtofdK/7yBwSUYi/6rBWIrApnONtqDqRmzQu64oMihRR3FbcF7EPJgBdCi3xU1eSJYwS45VRHn2W2QL5V+ZXKAXymbwC0WeEyai0fe06FELuTJZ5nBNhV+CdLU7HrF/sh7IITucJWYecRbXuEIaWtrIbT4I4hIWDB430IZUL6aPTzHaMPpUt0Vk2aXn+eD82h21APHdyMuT4KgVvuKbv0/aFsgp4Uu9bLIFFV13mRd4RwFm20Ad+xCuDY6gkP/dHoby5aiOQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(36756003)(6506007)(38070700005)(86362001)(122000001)(38100700002)(316002)(66556008)(76116006)(91956017)(53546011)(71200400001)(478600001)(5660300002)(110136005)(6486002)(54906003)(66476007)(6512007)(8936002)(2906002)(4326008)(4744005)(186003)(64756008)(8676002)(66946007)(9686003)(66446008)(26005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?US8vM1pOOFpmcWgvMXdyRy9mbEI3Q0xKZTFvYnd4OFR6R1p2emJIckMxQkxo?=
 =?utf-8?B?LzVSeUQwQWxzLzRxZ3VlSUZwbXF5TWR6akE2MXpNSU1pNGVodU9HMUhIb0V5?=
 =?utf-8?B?dzJYNmorMXoxazd4WmVKeTI4Wm5IdXNLcWtMRnZiUmRxUUpjYUwweUpiTGpm?=
 =?utf-8?B?QXA0UzdGQlZjWE56UjdSV3dsTVQzOFhscmsxd0pLNkgwL29zNnJ4LzA5S0gx?=
 =?utf-8?B?QnRsTlUyeTNlNTlsSURiY2hUOUVqK0RYMDcwdnN1SzR3cXJiY3JCelRCbEkz?=
 =?utf-8?B?djJkSFhHTFhuYWlxMVFkUzBteW9ZaG9Lb3A2ZjZsdGRIaGxFQmFyak5rWm1F?=
 =?utf-8?B?bGhHVmMxazBUUzlaODJSZTV3azlaZTc0SHJJdHBpdFdnT2gybCszYUxNZTI4?=
 =?utf-8?B?VmVIODA2VHlHcWFMVEsrUzZORDJ5OGRNOEZJUWNISjdjS0tLYWNTM0gwTHg4?=
 =?utf-8?B?Q3pIT21DYkR2Y2VITTA2MWZTeUdyNXZJVDhvbitEMjN0Uy9FRjFlYTRmMHJ0?=
 =?utf-8?B?ck9MVVVacisvanY4OVdFM2t6eDNpUC9UTUJXZXlFamFPWUt3aHlSZjB6aHV5?=
 =?utf-8?B?MFhGUkFmcWd0Qy9aZ1dMZ3hCdVJHb3B0Y0EzUDNlY2dKSEx1N3NGSEdOZ3Y3?=
 =?utf-8?B?TkNGYW1XYmNMSzhTN1ZOUUptS25INzRITW15dGM5aHY3OG9RUThUNTNKWjZW?=
 =?utf-8?B?S3JNWjFRQ0ZHNTJNcjh4ekphMXZwaWVNUU1ubEJ3V0ljMzc5akhpZFJHbDJD?=
 =?utf-8?B?L21TVGRPTHM0blJrZUU3TGgrQ3puc3JYMXBGTmRkZktkKzY2MyswN0tuRjBB?=
 =?utf-8?B?YWJYZGZPOU9ZcjB1VjBPUEh6aFdmeU5GcnBmRE9teGpBajRpejJWVnBiUyta?=
 =?utf-8?B?SjR3eXFRT3lneWhFdGdtVENSajJwQVdScXExSUpCVC93R1FCUXBEV1llcjFH?=
 =?utf-8?B?THNYOW53aW1OQlhIS1NFVTREMy9ON2pxSDhGTUJ4YjhSUkVtejBJM3RIVUFY?=
 =?utf-8?B?ZGJPWUJibVdSYThrcm9nLzM3QWxHNHhCeFlwS1pIY0lnYVUzeFFsNXRDakow?=
 =?utf-8?B?eFcxMVowbzlreXJwcEpiRzRPUlRxUGFqTHpubXRYTStjOFpENm5Sa1NOaDBD?=
 =?utf-8?B?NW5sckFyc2g1c2xkM0pzbnJkdVRkTVR2Z3FXRHV5NmhacWkrZDNzVjRURnli?=
 =?utf-8?B?R1doV2M0ZFV4dk45WHlMa1gxZmlZYTkxWlhOMkxHKzJrbGIrVkFNOCtXd2U0?=
 =?utf-8?B?dktUTlJ1cXFTZGE4TjhBc25ySXhxL3RTeUY3OHNVV0YrTnIxeVAzK1F0U21K?=
 =?utf-8?B?N3Q1Tk1nWDEvYWxjTTQ3L09xd1FHZE1nNkxlalVBMHdqV1k4eW9ZNk8zNmxQ?=
 =?utf-8?B?YUVVT1AwZ3pEVmoxT2IxNVFLWjY1VU1rRmxsSEErTFcvdUtpMnl6MlF0Z1Jk?=
 =?utf-8?B?S2hxU1hiN0I0bWJMSG1DMmZuZUIwVmRUTmVJcUNmb1pIcjdjNGgzYURJSlVJ?=
 =?utf-8?B?Zjh3ZFN1UHNPcHh1aXdqbUlicWNRWncwWnk5d1hGN0tyWFdwOGZiZHpmVTVD?=
 =?utf-8?B?N1ZKdnRoNWIxOG1qZTNuYzNWWWhMd3FMRERMSkxVODZpZ3pjM2d0RDJ6cExW?=
 =?utf-8?B?cFlQSDdZN3YyWFRHUVYxSTh0OStuR2tMY2doeUJjT1d5cm52RVEzS3NZWVBz?=
 =?utf-8?B?RDdoeHVrQ2JyOVBXL2NkN3NQNjhjK0RmdWRnanFVYkxRSkVpT1E2dEROdUlF?=
 =?utf-8?B?RTcxbkVqSmlwSXQ1VVE5TTdEVlVtanArVm43VHpGNHZwV1ZUY0hQbGw0Q05D?=
 =?utf-8?B?R0JzYlBNZ0RZL21qNmsyVTArVjkzQTlldFlsR0JVUk1JbVhPOUNnbGRlNlZa?=
 =?utf-8?B?ZFE2WHdIbzFrN09xcnVPc3lnckQ3Kzd3dWs5MUh0SnpZRHF1N1dRQ1ZGVFVj?=
 =?utf-8?B?YzR0MS9ZQXFyZWlxci9qUGhMWjIySWlEYlhSZWtrd3J4OVRFVEhLdE44eDFi?=
 =?utf-8?B?ZTJwY1hEL21zNmF6WDZOOFRlY1g0VUo3UmJXQ3g2SFNLMWZqZ0FjaHJncnp6?=
 =?utf-8?B?ZFZBbDN2VDUwUHJQcXZGbFN1ZUJGdlVESWdtVzdVWXo1TENvdHRQNmNlcWZ3?=
 =?utf-8?Q?12EsUROq3afEzEOrrDqaZITw2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E2569C8071D694BBA87C8465253ECA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a106435f-a273-4260-1154-08dac1734fb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 10:23:42.8831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dMn10aiRwaSdOQHJs6+Z0+xOACTrMdfs9K5r5neUAlV3Vu0qNAF+7IGyJ+wPxigs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4607
X-Proofpoint-ORIG-GUID: eEF4ulS1iKMxUiUeMqLn0h7HAvco7fpa
X-Proofpoint-GUID: eEF4ulS1iKMxUiUeMqLn0h7HAvco7fpa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTA4IGF0IDE3OjAzICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToKPiBP
biAxMS84LzIyIDQ6NTMgUE0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6Cj4gPiArwqDCoMKgwqDCoMKg
wqByZXQgPSBpb191cmluZ19yZWdpc3Rlcl9maWxlcygmcmluZywgJmZkc1swXSwgMik7Cj4gPiAr
Cj4gPiArwqDCoMKgwqDCoMKgwqBzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsKPiA+ICvC
oMKgwqDCoMKgwqDCoGlvX3VyaW5nX3ByZXBfcmVhZChzcWUsIDAsICZidWZmLCAxLCAwKTsKPiA+
ICvCoMKgwqDCoMKgwqDCoHNxZS0+ZmxhZ3MgfD0gSU9TUUVfRklYRURfRklMRTsKPiA+ICvCoMKg
wqDCoMKgwqDCoHJldCA9IGlvX3VyaW5nX3N1Ym1pdCgmcmluZyk7Cj4gPiArwqDCoMKgwqDCoMKg
wqBpZiAocmV0ICE9IDEpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmcHJp
bnRmKHN0ZGVyciwgImJhZCBzdWJtaXRcbiIpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHJldHVybiAxOwo+ID4gK8KgwqDCoMKgwqDCoMKgfQo+IAo+IFRoaXMgYXNzaWdubWVu
dCBpcyBtZWFuaW5nbGVzczoKPiAKPiDCoMKgwqAgcmV0ID0gaW9fdXJpbmdfcmVnaXN0ZXJfZmls
ZXMoKS4KPiAKPiBJdCdzIG92ZXJ3cml0dGVuIGJ5IHJldCA9IGlvX3VyaW5nX3N1Ym1pdCgpIGFu
eXdheS4gSSBzdXBwb3NlIHdlCj4gc2hvdWxkIGhhdmUgYW4gZXJyb3IgaGFuZGxlciByaWdodCBh
ZnRlciByZWdpc3Rlcl9maWxlcygpLgo+IAoKcmlnaHQgLSBub3QgbXkgYmVzdCB0ZXN0IGNhc2Ug
OikKSSdsbCBhZGQgYW4gZXJyb3IgaGFuZGxlcgoKCg==
