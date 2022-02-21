Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97B04BEA04
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 19:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiBURzc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 12:55:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiBURw6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 12:52:58 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AB8BC16;
        Mon, 21 Feb 2022 09:48:43 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21LAFmRk026167;
        Mon, 21 Feb 2022 09:48:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=18olR5pdh2P+lELx+boXQv5yzCvVbI+E01kwfOHBkgY=;
 b=rHWVS3kaat7qfuSQVhv94ZanKtdf1Nf4gYpHHDgpCJJyxW6wgRG00BR5wQcXK4W2YRyK
 3rlzY8g5z5dUoNhkCykNDkRKvHqKgr52iRWpHCllkJiMxYJokcwSD4d7bktlJOVHIdqC
 UzmBtVsVx7t+5ZOrHqlsYSaAKRVkOlr6K1A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ec8tk2ce6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 21 Feb 2022 09:48:43 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 09:48:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHQrIaEdU1UP39k8N9OThROcbXDOtMFrWnW40CCIeaa4DYRPQOBLIJNnlDliNtBwjGTLfNEqtmCCgj4nV8wmpjl5SMFeZj4bzSIduzC4eUDyTB8lYksnH3OSvSrRIZhOxS6Yn6KdPYlMHbf/i+YPEd/NJGW6+7tRqWKV5+cQpU3RZyFvi/gXpzmzrIBQCwV9pscBl05L8M/MUsC7jcPmdDHG3edRAIIksRuoUforUcAHd8XqOXYCM+3EJgaoIscp6FApeJ7nGPXMuE213LhDKAwDtt7K1nUbo6PrgdhlC0vaiu9upcvuxGSnA7dOi/jtWuOoX5EUhaLFoQltaz1ALw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18olR5pdh2P+lELx+boXQv5yzCvVbI+E01kwfOHBkgY=;
 b=C9bIzbvl19RLi9V2B0PKMj6cIYWBBIpgPA3GIRrap5diGd4yCvybcIS4IQEVzd03CfD1fDf7EimHesUEGpTUN68QXkcPD+xmzmRoVoXErN8xcJcluxD2xelhx2b/klxxfNGxMMQaK2yk0NtxBnAP2ZiU04CrHiPURk5xt76R8/lSPpQHuyS312LL6nO3kiy+MBayPqTH61MuEr6rnoL1VM9gO9GyH5D6qQ/GaDcoZeG9TmqCuD1ZfYmcTSkwhTsfmDaxFBWRGFcT9xC0hXvwQmdC8pM/TxMZuyn9zBMDZL+URmFGn5R/cl72iCHNuP7+zIkTvQyUDFs3XmTyp8R6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM5PR15MB1145.namprd15.prod.outlook.com (2603:10b6:3:b5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.27; Mon, 21 Feb 2022 17:48:40 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595%3]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 17:48:40 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] io_uring: consistent behaviour with linked
 read/write
Thread-Topic: [PATCH v2 0/4] io_uring: consistent behaviour with linked
 read/write
Thread-Index: AQHYJy28mLUpwQhwJkmKLSk9xPhMLqyeMy+AgAAU+YA=
Date:   Mon, 21 Feb 2022 17:48:40 +0000
Message-ID: <19b394560ad8aea4d7154f8022c5804421e27ca3.camel@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
         <f8f591d7-09c8-c537-ea41-30e0b33e29a3@kernel.dk>
In-Reply-To: <f8f591d7-09c8-c537-ea41-30e0b33e29a3@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8c8b11c-2d53-4d15-a466-08d9f562656d
x-ms-traffictypediagnostic: DM5PR15MB1145:EE_
x-microsoft-antispam-prvs: <DM5PR15MB1145B3945164950E30CC8513B63A9@DM5PR15MB1145.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m7PzdtetV4RTutOKY4H/C/DWv0FcezGz6T/NKV8M3+da1TsBJoJw8fe6nlclKIULkX8abrWApQQ8Cd7m4XlZBhDg4InBkMbXUdX1TaepiHzVs2sYlhXrPBjIse3gPPH07hNRHJrg34Mqnw97I9pX8AX/C0SfclsCGLpcP4cUzY/ZR1GRlSA+2Er5L9V5D5a61rg8tRWrFwuiyOO3bQhvjfAmbs0Ch2nlgeTv2mkWwZfmmPwsOImrzXN5UIbLvk/9xaM9782OTR24eUB0tZ84N4/Njcncj0EUrfazD0Dahl/ebkxp3Ti3YzT8zMgPj1gMCPZpPzTJEXVDvNwrysJE3EpdgQ7mJKEe8ja2tQvAV36kvLwez36k4GeAKquvpEyHnrZgHIfQZXRk7jyApKpowD+wyoO/lF3VIWIGwuEuK/dfcRKtUf/DQZBDwsz1jYwCcyl/kpuvB4MXfxwb2fhN6gy2bQiEvl+6IkBVBOsmWJYBTqA/LIa4loe4MnAS9xIkZ1bqikbPOWwFP4SJ4S7TiOWKtO++QqXD8/Lv5NoK4Vo63KeiChe25DR2Tn1paWPW3HoypQP3GyTUAYIuKiQVbdl1/XVDPyptLKzmhOTwT/9ogtdtue2oaFg43K+iGlI1XIRgBGTEZX+sITUIw2jCIPQBE7I4KoJMeAqdeBevXGuuI3qr0KV3imnQDBRoH7qLFudq/1wnp9gCvL78FMSEZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(2906002)(86362001)(186003)(6512007)(2616005)(4326008)(110136005)(8676002)(91956017)(76116006)(38070700005)(508600001)(66446008)(66476007)(66946007)(316002)(54906003)(6486002)(6506007)(71200400001)(8936002)(5660300002)(36756003)(38100700002)(66556008)(64756008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3N4eUV0MzhnQ1RWUzdhdWE1b0NPbDV5WEZrTm1pR2lQOW9TM1R6c3NEMUhD?=
 =?utf-8?B?TW4vbmthaGhkWDNMSTk2WFVsaDFYT1laa3A0ajNkV1BUYzQvdEExTndFaUww?=
 =?utf-8?B?SlhPRUdwekY4N3dUOWpOdGpZTVVDRGM2Y3hJTStpUS9zOVcrSms3UnlaYkFR?=
 =?utf-8?B?RWVqVFhOUjFlSWQ2QXdGMFVWTFg1YjFwY2dxdWo1R1RGWVNSdkl5VzV3ZWN6?=
 =?utf-8?B?SFZiSlRTMFRqcitDbk9vTTZmNHZ1UytJby9Hc0tONkhtaUZHTVMwS1JZZ0Fm?=
 =?utf-8?B?TUNjZDhsS2NxY3dOTnBVc2ovNStrY2h0dEdKMEd6cjhEeEovQ1JFT2RqejRi?=
 =?utf-8?B?Ym1nbmVqMFlJMDVNWXFkWkNMUTkrWTh4eHY3bDFIRGR4eDFzaUViWmNXaTdt?=
 =?utf-8?B?N3draCtMdnhYd3IwcURqdWlKbGxuVEk5bCthQ0JWZzNBZFlka2t6YjlTcTBD?=
 =?utf-8?B?ZFlRVnJSSVdUVjNMUmhWdjFvODdIRmVLUG9EM25GT0tjNDAzN1pEQmtGaHVi?=
 =?utf-8?B?dSsyVUd5WTRaemJyQUNIaXNkWGc3d0gwTVp3U1NtdmlHY3U4aGI3N0J6VlJx?=
 =?utf-8?B?VmIxOG1ZY1puTHd3UXlYN3dzZ3lYbWxMWmtoaU5GRjJiUXdMRm9ldVp0ZlRX?=
 =?utf-8?B?ZGUyQ2FNdUE2d2E4c3hPWldrODlwdzN6YWw3RlAyWmJZTkNGU0ZXd3A4Z1p3?=
 =?utf-8?B?U0VoSkJPeEticmNUT1p0ckpBYUVDS3pwMGNJdi90MFN5NGxneGV2VGRycGdY?=
 =?utf-8?B?UndaVXduL2R6YXlwc0lRbEdwRkxQUXpOYUhBeXQ0b0VCQ0I1aTFlSWh4QnVV?=
 =?utf-8?B?NFJDcjY4OVZyYkpmZkcwWTNqaXBRYU0wR1VoR1dnSjRDb2lVeFNUcFR5NlU2?=
 =?utf-8?B?N3dRb1d5cS91U1M2eXZyaDcyWlVqTHJtN1VpTTk5L3Q4WDQ3Z3U0VXhTQVBI?=
 =?utf-8?B?YVJkNWorLzBIRk93dXBxazJacU5WUlpRaWY5QXc0Y1pwSmpOOUNUZ0VHdUJE?=
 =?utf-8?B?Vk1XWHo2T09HenA2WVRuZFVDV2xZUi9hK3FaWFBvT2tRaDFUYlV2ZG9FOFJn?=
 =?utf-8?B?Wnk1YitmTnA0aENDWXBkRXBlRTVlNFBQNjVDcHFubHlaUzhJTGNVVXR6S3Nm?=
 =?utf-8?B?RFRtZVo2NUtJRmpuRXhsSDdqRkkvNW51NGhJcHUvaG96cmE4OHNzTk1mS25y?=
 =?utf-8?B?S1ZUS1lCZWk2V0p3VE9NV05wWUZUNWtlcGhLZE9XQ2EwWlN4dU1GbXVVRTI4?=
 =?utf-8?B?ZndNN1c2cXVDNm11dUdhdXh4NzZKd0ljWTlvcGFBMzVaZWpCYjlZZndmcCsv?=
 =?utf-8?B?N1NDQTlWY0l4UTNkbENiYzhHYXU1V244R0tFQnpYY3dZaGM4eDdmVGVVeG5W?=
 =?utf-8?B?UTlQRzdsMkp6K0FONWJmbEdQY3hGdThJNy9teGZzaURQYmkrV2gzWUNBRDhz?=
 =?utf-8?B?UXBvdmtzY3UyWEMydmtSYm9iMTdMeU1uUXpER2gvNlNGVlpWamF0U2J6Sm9V?=
 =?utf-8?B?YWJMY2ZaYTVkNFFlOGk1K0dJTVBPcHdDajQ2UWw1cVZvdFVpQjFTVzIycjN4?=
 =?utf-8?B?ZUR6Mko5Q29MNnhRWms0dTVPYW5mTDJpRmhZQW1GYlhtb3J3S0wrZE5HdXRm?=
 =?utf-8?B?MjJ2dkc0aHYxS1FsT21ROVRIVWxpV2hyY3QwSEZVd3lkMjBMZ2U1MmtuY2lx?=
 =?utf-8?B?aDF5c2lxODM0T0FNZk5ib0x6ZUFGU284Q0JRYW9Sbm1TYm9veWp2Vnc4bnhV?=
 =?utf-8?B?YTVmai9YZ0JPQmMxNDZ6eG1UelRuMGxqN0RZTTUxb2Z2L3VDaU9FQ3FsbDIy?=
 =?utf-8?B?cVp0OTNTeTlYcUJBSVNmSjFOWWpER1dVemk0UUdwMWpOWG8vRjFqREVXMFdy?=
 =?utf-8?B?bnB6UnArL2hLY0pZMUVsbmdBclQ0TTI1bzdST0ZzbXVkbEJwTTBqOVROMVI5?=
 =?utf-8?B?U3h3UEdPYlhNY3JOQW5LRmEyenJaaktYK2JacjVCaGtKTlN3YXhEa3pwQWZ6?=
 =?utf-8?B?ZFJCeTJoYnVJYmJBeUhyNDQ4NUtZclVFaXIxR2xvOUpBUUd5dUVHVzhwRktr?=
 =?utf-8?B?cks3L1VTYWhFTER0YXhiZHMwamN1OGpDQmtMMmhoK0luaTV1NWNXWDVuL2Rq?=
 =?utf-8?B?S0dZaDFHZEZNdTdkaDhjN1pSd09QQkZSVUlpZGs3eU02ai9oRGVLQm9UcC85?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A6E9371B5757348A4E08BC374CC1DCF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c8b11c-2d53-4d15-a466-08d9f562656d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 17:48:40.5983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xPPqt7CiRN5ZbkaSLpCE8rhuAGugdzhxKbdFcftI2RNEOQj/i8dDZh4BkhStq+He
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1145
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: dAc_D5pobZdklTdOE1RwSol1z8eYIMiA
X-Proofpoint-ORIG-GUID: dAc_D5pobZdklTdOE1RwSol1z8eYIMiA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_08,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 mlxlogscore=981 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210105
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTAyLTIxIGF0IDA5OjMzIC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAyLzIxLzIyIDc6MTYgQU0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gQ3VycmVudGx5IHN1
Ym1pdHRpbmcgbXVsdGlwbGUgcmVhZC93cml0ZSBmb3Igb25lIGZpbGUgd2l0aCBvZmZzZXQgPQ0K
PiA+IC0xIHdpbGwNCj4gPiBub3QgYmVoYXZlIGFzIGlmIGNhbGxpbmcgcmVhZCgyKS93cml0ZSgy
KSBtdWx0aXBsZSB0aW1lcy4gVGhlDQo+ID4gb2Zmc2V0IG1heSBiZQ0KPiA+IHBpbm5lZCB0byB0
aGUgc2FtZSB2YWx1ZSBmb3IgZWFjaCBzdWJtaXNzaW9uIChmb3IgZXhhbXBsZSBpZiB0aGV5DQo+
ID4gYXJlDQo+ID4gcHVudGVkIHRvIHRoZSBhc3luYyB3b3JrZXIpIGFuZCBzbyBlYWNoIHJlYWQv
d3JpdGUgd2lsbCBoYXZlIHRoZQ0KPiA+IHNhbWUNCj4gPiBvZmZzZXQuDQo+ID4gDQo+ID4gVGhp
cyBwYXRjaCBzZXJpZXMgZml4ZXMgdGhpcy4NCj4gPiANCj4gPiBQYXRjaCAxLDMgY2xlYW5zIHVw
IHRoZSBjb2RlIGEgYml0DQo+ID4gDQo+ID4gUGF0Y2ggMiBncmFicyB0aGUgZmlsZSBwb3NpdGlv
biBhdCBleGVjdXRpb24gdGltZSwgcmF0aGVyIHRoYW4gd2hlbg0KPiA+IHRoZSBqb2INCj4gPiBp
cyBxdWV1ZWQgdG8gYmUgcnVuIHdoaWNoIGZpeGVzIGluY29uc2lzdGluY2llcyB3aGVuIGpvYnMg
YXJlIHJ1bg0KPiA+IGFzeW5jaHJvbm91c2x5Lg0KPiA+IA0KPiA+IFBhdGNoIDQgaW5jcmVtZW50
cyB0aGUgZmlsZSdzIGZfcG9zIHdoZW4gcmVhZGluZyBpdCwgd2hpY2ggZml4ZXMNCj4gPiBpbmNv
bnNpc3RpbmNpZXMgd2l0aCBjb25jdXJyZW50IHJ1bnMuIA0KPiA+IA0KPiA+IEEgdGVzdCBmb3Ig
dGhpcyB3aWxsIGJlIHN1Ym1pdHRlZCB0byBsaWJ1cmluZyBzZXBhcmF0ZWx5Lg0KPiANCj4gTG9v
a3MgZ29vZCB0byBtZSwgYnV0IHRoZSBwYXRjaCAyIGNoYW5nZSB3aWxsIGJ1YmJsZSB0aHJvdWdo
IHRvIHBhdGNoDQo+IDMNCj4gYW5kIDQgYXMgd2VsbC4gQ2FyZSB0byByZXNwaW4gYSB2Mz8NCj4g
DQoNClllcyBzdXJlIC0gd2lsbCBkbyBpdCBjb21iaW5lZCB3aXRoIHRoZSB0ZXN0IHYzDQo=
