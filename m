Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A6D4BBE44
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 18:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiBRRU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 12:20:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbiBRRU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 12:20:57 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104A22B5BA3
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 09:20:39 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21I6tE8r020351
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 09:20:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9Dkq6Ean1V82qZ7bRj/fuDRcR0E50BZ+dOP5VU3W7oI=;
 b=lG6ChxPZ0FBYJngtYKOgiPlXNJvhewcpR0J/LRePaRKMk8ZK21O5YntvW1G8m1GzbW15
 Sj4ou0feUblyHjoiFnptDMCiaKv9tf3WSaVAjNEqZeFfw1p3M45Z1Eyv8TEux6LANOiB
 P2bCun1jOslokdV3yn1Ge04AfRSYKROV52A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea6knu89b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 09:20:39 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 09:20:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSYT5/lEu6fXW2l6y4GbccBTiyRtUGhzfzxNX9e4LmtJmbkO7AQSODPRMndnqRpDxzj+pCqdgpTQm57WcrB+0tHa1romronKRMUjRAZje4UMZaocTu9TP84wYTGhIf1/N+zemzFlGPWN/qRwFyOQpZqsUVC/w/UettRAuYAkLMpctP9bnQ1CKw3N1oN7KlSarvIFIsxLmk2+xmCuiHXKi8DhBomgehpMoJM4da4TEK+l7hc4r0ss5XKrY2l1KcewKERTVRSBYRX78E1x42QomO/nSmyDQ81PnpKg7fgNM1GH7poE0xFusZHQxjXcMTOjN5SloQ2A7Ey5wvcTZJk1+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Dkq6Ean1V82qZ7bRj/fuDRcR0E50BZ+dOP5VU3W7oI=;
 b=Twf5T0Hts/7F0P4pMyOQZw+GSzerrzVVgAM3843zQtoxY/G30ajn73Pr/9Qywx6du6ubkmrgzhBnfYZWpFHOeYA0MVwzp+t2xg17GzfDrzvvEbmG5lI9zDbhZGDdCnx+fVgfDl3BGxjKCB182PlkxdfRKq34yxlfOieTY3jA33EvFKENLFPQvi2/EeXTS52yHB/6jQqvhGDWx70hBRMYH62o/sl2xr8av6BdeMBBZcqnhmnoss2r0XUvkZShkj6aup8eZvVqYCoZR6iE16sQyy7a1O4nC7b6iNAC23r1z60vlPqNiZIhSA5voERkpbJrD6/wMhadH2TwjKf5DQEu4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by SA0PR15MB3839.namprd15.prod.outlook.com (2603:10b6:806:83::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 17:20:32 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595%3]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 17:20:32 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 0/3] io_uring: consistent behaviour with linked read/write
Thread-Topic: [PATCH 0/3] io_uring: consistent behaviour with linked
 read/write
Thread-Index: AQHYJBdAygcfRWiAGU+nXcvSvzIX3ayYJb8AgAFpu4A=
Date:   Fri, 18 Feb 2022 17:20:32 +0000
Message-ID: <e2285f43a68c42fc1ed53b581304dce090ac29f4.camel@fb.com>
References: <20220217155815.2518717-1-dylany@fb.com>
         <264fb420-26eb-bc0f-b80e-539427093a17@kernel.dk>
In-Reply-To: <264fb420-26eb-bc0f-b80e-539427093a17@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f239379-cd67-48d4-ff21-08d9f302f7ba
x-ms-traffictypediagnostic: SA0PR15MB3839:EE_
x-microsoft-antispam-prvs: <SA0PR15MB3839189367048D3D58F95417B6379@SA0PR15MB3839.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9JrApd78iHDzBN2GbgiEHUu4A377NxgeJIGApLcmsUbJBkkiwmmpD76BdcP2y0ovtIPcO+/j0ryL41Eg6qaECRu3vrb3zken0o8EmLcddiSDVvU1jetzIAh+Xejja45ajIDbjC+/wMIvtjNm7a1gOU4ky0GLf7GNKCzUMMG9RiCYcXhpt3mmCscz1XaAzRIQt0+eQFOGgcP1bn1MgRuvEp/WseDjF4701bkX7wuJJfn2wpADQ2pHmMfF3zR1tsm6Zilpta32pZAOt6E22yHz82/RBD8/qtQS2F7jgZgU90zIn4ibRhs7m4zSRGL4/qnEkKCSUV0BNF5DL8tdG4q8qPxI1/vzvmbd66a3Tp1Nmda58Pa69YqcqaQst02nwqCyIYMciUzxZu08wuXNLtZHgH2mAsIECDz35mnf1kK3mSGC5mr/vEGGkkFfj+3YyDS7dHX6nSkJrZwliFP8xHXKtDuIgpaP9qD6M59moTI8S0aqKs+ny0vz3iUV4us8/X9tXMqFy4d/ybQJwQriz6m7Y06tXHTc7vAtHrTZb6DBWqdSqANDEq0iTKux1vpgr9DN1HDg1W/lHhv12b6UaWU/lrzTgNMG6oYK3x5evnuNPgUt2zdph7HP9b9EAHYtkDwSosPmdTJRJcD8Yg01tt9OPLCe5bJOc95pEunT1ItSIkJ59RcdEr1nV7e+dFKZFTahr0wk8YgJJLfeJcbq6l3iRONR4RUH1tD0Jx6ql9Mvp5NwIDNTemwB3tTvUVrcSW3nnueFn8tNxOgb10JcTffbk1QXjcIC+bd/o5ekSpfDblQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(5660300002)(38100700002)(6512007)(83380400001)(2906002)(38070700005)(122000001)(966005)(6506007)(76116006)(36756003)(8676002)(66556008)(6486002)(64756008)(316002)(66476007)(66446008)(71200400001)(91956017)(110136005)(8936002)(186003)(2616005)(86362001)(508600001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmFhVnBBM0ZhVHdmNlh2NGl1cTdpN2pPRW1zcjMzWkFGTmlYRnpPOUVraDk0?=
 =?utf-8?B?ekNrMUY2NFplQnVZUlNvYi9PVndsRGhXS0k3SmhybnhQc21VT1FYRy90NnJn?=
 =?utf-8?B?Mm03Q2tKM1BCVmFoYzRwd1ZOSldZMUZPRlNNa0k5eTJtREczaHpOWFlhdERP?=
 =?utf-8?B?SHlCWEp3YkVtQmdEdkpkSU5OK1hQUVZxK2hxM05MRUVzeGhYMDU3OEhreW1z?=
 =?utf-8?B?TGdTbDNZOEczRDAzK3F0S29rR204TlZ1UE54cXJiUEpKOWhBNVppV01Ba3pm?=
 =?utf-8?B?cjhhTjFudUVvZnRxbjU2cHhBQ2FIWi9WbC9RY0dob1FnYzRiV1lQNGdwR0dT?=
 =?utf-8?B?c09sVCtqYVFtYU94SU9sZjVzL09SSzNlNGd6YW1SS0tEWG9ldEtqZ1RXUnBX?=
 =?utf-8?B?bWdmdUdNcmtQSG5mVnNyY3lYQWVJQlJXTVlYVnNJZ2pYV2NpcHBmY0I2SGdi?=
 =?utf-8?B?ZXhqeVNYUlFJVUxmd24zVWRxL0JnS2JYR3BINjNra2Z6K09maDEyZmx2ZXlR?=
 =?utf-8?B?aTVsNzJiRWVrTEJYMksrWG9sT1FtYTV6VnlUbGtSMU9mS282WGRlK2Y0Q3I0?=
 =?utf-8?B?cW1VSFdvaE9DOXFJc1BYclYwbTQzUlRzV0toN2JmRWlEcTQxdDVjbCtqajl6?=
 =?utf-8?B?Tjl5M1plOG12ZEVHd1E5QUJaNXhKL1BVREEvRkFiNkxCbHB2NnlFaVcrckd5?=
 =?utf-8?B?eDdFWU9VbmhCNnc5V1Q5MVZFanJSVVEzL0krZVBWTlAyT2Q0T2o2SUJFcytm?=
 =?utf-8?B?Ky9rYmg0OEtzRkl4aWxUZVFxb1dWK0xHakZKNG4yK2l5VFdRS3VYN1RyMXl4?=
 =?utf-8?B?cDVpNUZYVW9FdWJHNldBZ0ZVOTFrSGg1MzJNVFM1aXNSdkNUTE1iV0NmZHVq?=
 =?utf-8?B?VmVrNjE2Y2JvUVk2RjBPajY5ZHBjWXhJOGVWWVU5N1Z1aUlCanNBR0pza1BK?=
 =?utf-8?B?QnlHdVk4aVNsd0V5empvNnR5ZGhHYURYVXhtZTA4MWh3VlEwS3FGenUyMHlL?=
 =?utf-8?B?WVE0RVJuOXJMemZjNG5XZkF4V0haQUY3SThBb0lFT09PbS9jQUI5YXNvdGxD?=
 =?utf-8?B?N2x2TWRKaHlYaEhJUGVPNytrVDJFdk1NM0RZcXVyN3kyaFluMGZxLzM5blhx?=
 =?utf-8?B?S0w0ZHliNUxjazB4RTFrT3U4WkdWejJ0Sld2ZkhBaHVqZFhMZmRYdGJtS1Ez?=
 =?utf-8?B?d3JBOCszWXNHb3Rvdi9Qcit4MDEzSCtMbS9OMG45cE1jb1NPUHJTeUpUTVlV?=
 =?utf-8?B?S3Z3M3JBRld1OUlKbzhPQS9YTVIyNUc2T1JzbW1qMHlwUmt6VkJkZDdsRi9Q?=
 =?utf-8?B?bmJLZk1ERXUwNmtubFVaQXoxRE9CaXdoWC9rczhmYmhjWDhZc2FGL1htREd3?=
 =?utf-8?B?bGFrMlgrNmkxalRwZlZhOWh4T2RSckRGVlBtc3poUHFQZU5yOUdJOFF2UENq?=
 =?utf-8?B?UFlOOXNIQ21qN0xWU2NsaGkybUhJbE1yRFFWSzIyYTNXTlNCNDNuTUppcWtD?=
 =?utf-8?B?ays4UHFJaUZzdmk4cHp0UEliWk41V1BlVXd6YUhWSys4cmt3Q3Z2aTBkemhh?=
 =?utf-8?B?LzBwSkRiVVNibXppTTVhcUlEMFZDbkJ1YTlrQmtKYUYwd2ZMUHVqV3dXTFVY?=
 =?utf-8?B?dUlDVEk5UmR2aE5xV3BocklvbEpPS2I4TThvN0xqcXVZSlE5czA0UVljcW96?=
 =?utf-8?B?Z0d2TXRHRS9hWDd0aW9pQ3pXMERvYUllWHdLYThwWndzMDZlbHg2ZFU2MCti?=
 =?utf-8?B?WTk1YVlYNk5wc0JKQzdWdG9reWlIaXBzN2x6RWFCMTZWWkxlVmF0NXJON3hD?=
 =?utf-8?B?OG1lN1FwMExDVUZnZmlrdzdFSy82VkVpZzRFTEozRFVPZnFsZ1FLaDlhcnhr?=
 =?utf-8?B?RGdHb0hzSTkvb0ovWlBmbWxpcUpOcThQdjJwb3poV2kvTjVlUFBoaE5OZ0NN?=
 =?utf-8?B?dkpPcTRmUnM4bG1KQStGUjZWOEQvQUw4RGhwdVFEZCtLWDVGVFo1Y00zSjFu?=
 =?utf-8?B?UTFZMktPaVRKc0JSZzNuODlNZGJOeEFlZnBQQkhCYWJIb3k3aDBSOXZMWWxZ?=
 =?utf-8?B?WmVZbzJEVE5mZ0djSUgyUmhKaFQyWTFpYmpmbEJ0ZGxhUWtNZXJsR2hsd0Fw?=
 =?utf-8?B?OFFUb0V0eVgxY3JkU1VzL2tEaFNOZi9hRFBxM0E2Q3ZlNGY4U1RSdHFCVVlJ?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3C6A8D5B1503D49A5A27FFD7BBF89AE@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f239379-cd67-48d4-ff21-08d9f302f7ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 17:20:32.0878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DH2CF4MMtMtzT6qyxwYu2oPVBNFQMeKJe19LDjIUkVcoiK140KHiH5VAK34GdtZQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3839
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: NJLEGCzrIAOS_kiUR5OjukkplBl6td-v
X-Proofpoint-GUID: NJLEGCzrIAOS_kiUR5OjukkplBl6td-v
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_07,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0
 mlxlogscore=765 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180110
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTAyLTE3IGF0IDEyOjQ1IC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAyLzE3LzIyIDg6NTggQU0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gQ3VycmVudGx5IHN1
Ym1pdHRpbmcgbXVsdGlwbGUgcmVhZC93cml0ZSBmb3Igb25lIGZpbGUgd2l0aA0KPiA+IElPU1FF
X0lPX0xJTksNCj4gPiBhbmQgb2Zmc2V0ID0gLTEgd2lsbCBub3QgYmVoYXZlIGFzIGlmIGNhbGxp
bmcgcmVhZCgyKS93cml0ZSgyKQ0KPiA+IG11bHRpcGxlDQo+ID4gdGltZXMuIFRoZSBvZmZzZXQg
bWF5IGJlIHBpbm5lZCB0byB0aGUgc2FtZSB2YWx1ZSBmb3IgZWFjaA0KPiA+IHN1Ym1pc3Npb24g
KGZvcg0KPiA+IGV4YW1wbGUgaWYgdGhleSBhcmUgcHVudGVkIHRvIHRoZSBhc3luYyB3b3JrZXIp
IGFuZCBzbyBlYWNoDQo+ID4gcmVhZC93cml0ZSB3aWxsDQo+ID4gaGF2ZSB0aGUgc2FtZSBvZmZz
ZXQuDQo+ID4gDQo+ID4gVGhpcyBwYXRjaHNldCBmaXhlcyB0aGlzIGJ5IGdyYWJiaW5nIHRoZSBm
aWxlIHBvc2l0aW9uIGF0IGV4ZWN1dGlvbg0KPiA+IHRpbWUsDQo+ID4gcmF0aGVyIHRoYW4gd2hl
biB0aGUgam9iIGlzIHF1ZXVlZCB0byBiZSBydW4uDQo+ID4gDQo+ID4gQSB0ZXN0IGZvciB0aGlz
IHdpbGwgYmUgc3VibWl0dGVkIHRvIGxpYnVyaW5nIHNlcGFyYXRlbHkuDQo+ID4gDQo+ID4gV29y
dGggbm90aW5nIHRoYXQgdGhpcyBkb2VzIG5vdCBwdXJwb3NlZnVsbHkgY2hhbmdlIHRoZSByZXN1
bHQgb2YNCj4gPiBzdWJtaXR0aW5nIG11bHRpcGxlIHJlYWQvd3JpdGUgd2l0aG91dCBJT1NRRV9J
T19MSU5LIChmb3IgZXhhbXBsZQ0KPiA+IGFzIGluDQo+ID4gWzFdKS4gQnV0IHRoZW4gSSBkbyBu
b3Qga25vdyB3aGF0IHRoZSBjb3JyZWN0IGFwcHJvYWNoIHNob3VsZCBiZQ0KPiA+IHdoZW4NCj4g
PiBzdWJtaXR0aW5nIG11bHRpcGxlIHIvdyB3aXRob3V0IGFueSBleHBsaWNpdCBvcmRlcmluZy4N
Cj4gPiANCj4gPiBbMV06DQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvaW8tdXJpbmcvOGE5
ZTU1YmYtMzE5NS01MjgyLTI5MDctNDFiMmYyYjIzY2M4QGtlcm5lbC5kay8NCj4gDQo+IEkgdGhp
bmsgdGhpcyBzZXJpZXMgbG9va3MgZ3JlYXQsIGNsZWFuIGFuZCB0byB0aGUgcG9pbnQuIE15IG9u
bHkgcmVhbA0KPiBxdWVzdGlvbiBpcyBvbmUgeW91IHJlZmVyZW5jZSBoZXJlIGFscmVhZHksIHdo
aWNoIGlzIHRoZSBmcG9zIGxvY2tpbmcNCj4gdGhhdCB3ZSByZWFsbHkgc2hvdWxkIGdldCBkb25l
LiBDYXJlIHRvIHJlc3BpbiB0aGUgcmVmZXJlbmNlZCBwYXRjaA0KPiBvbg0KPiB0b3Agb2YgdGhp
cyBzZXJpZXM/IFdvdWxkIGhhdGUgdG8gbWFrZSB0aGF0IHBhcnQgaGFyZGVyLi4uDQo+IA0KDQpT
dXJlLCBJIHdpbGwgdHJ5IGFuZCBmaWd1cmUgdGhhdCBvdXQgYW5kIGFkZCBpdCB0byB0aGUgc2Vy
aWVzLg0KDQo=
