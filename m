Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2B4BF6AE
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 11:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiBVKws (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 05:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiBVKwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 05:52:47 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5AC5B88C;
        Tue, 22 Feb 2022 02:52:22 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21LIBS5i008684;
        Tue, 22 Feb 2022 02:52:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rukg1FhKjX3y91xVo+w05RPCIVBGGMI6bMrgZLDc1h0=;
 b=XT0ruiiLTrmCsaosgAF4QSOZOzKlWcNY45hrHqhKxewNJ6ViyDm25kBJLiJfJjDQvwvS
 vt+RJnoIYFHlRvL27vaBBRC2QwYKzo4hZcvRc+lk+l5R8lbcOhoFD12ZN5B23xS+oLVG
 3dqjtCACgVk+TVXiCZSImCzRUYXXN4cb/UY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ecfsmufau-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Feb 2022 02:52:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 02:52:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdGlURtULUYAolFZ7IxYfLfa/SKYwT6wUyOVSj1yMlOjHOk03guJ4gmnqZcdFSnB6g8BqHvMI/pmelfR4tgAwKDrlI9Luqekwyqi2CUD05E+IOmKnmp4LKfvw/4L+slfRdYDfSF5d6+I2eoZzL6Vq3cm8dF1elS8T/LKA9MqA80q0YaSIMlp8r+42bXUQYL0P4JkOBVo54BvAXxC+GaoN06nWivQBL7kYaGIwH+Y5R06veHsZijZVnumI2Gp9s9TdjRzpCqewSb+cCA/eHcHedfN7BMO8gPGYLTcc2V3NvbK75RYPlCjBFGAqbaqe4EQVCwA+3QFVlA0SkiBQDEFRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rukg1FhKjX3y91xVo+w05RPCIVBGGMI6bMrgZLDc1h0=;
 b=dHX9r6j0x9ODR2P6Eqq4KjGxMy6vH5+kPsNFayeZTp6OsTlBGFHtJ+nGk+gW/eBDUmZm3Ph2BN8Ysxta1RgtANVao2hNfK9xV/AZG5TVByY+wXyrnuipPJbWcOvV3Ec0DQr83bBE2RgYqd2ymgFpzAuyxQ9wOCn1/pt5layMwC+6ayy0SA7Z4HqHG85UgkexyyISPhH8iYNkz2c0H7XSxXCHS0rK65j/MZwnfBRUqpat9QL0qwcUZ86PCiG7Y3nRWiuIl+l924UcF4Klt4YUHwNy3FvyXeaU4bhN7NNP32R5Q98u+AIP5stV3wMeLNqnKvxxC10QqrE1qwC48XAnew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by DM6PR15MB4056.namprd15.prod.outlook.com (2603:10b6:5:2b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 10:52:17 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::90df:a984:98b:d595%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 10:52:17 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "haoxu@linux.alibaba.com" <haoxu@linux.alibaba.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Thread-Topic: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Thread-Index: AQHYJy3DKkNH7lIuQ0i9mEbODtcbvayfLvEAgAA3NIA=
Date:   Tue, 22 Feb 2022 10:52:17 +0000
Message-ID: <fdcf70aaf53b4d3040bed95535846edc0120bfea.camel@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
         <20220221141649.624233-5-dylany@fb.com>
         <9cd3cc84-a2a0-a827-3fb8-bd2928eabd28@linux.alibaba.com>
In-Reply-To: <9cd3cc84-a2a0-a827-3fb8-bd2928eabd28@linux.alibaba.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2793be5a-3510-4c49-438d-08d9f5f164a7
x-ms-traffictypediagnostic: DM6PR15MB4056:EE_
x-microsoft-antispam-prvs: <DM6PR15MB40567E54AC362E0677F134FFB63B9@DM6PR15MB4056.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H85eDpYFhIhqtpDmKTx+hjILcKBQUEITMU+fsnUoHRkJKWhM/XhzUBsz+QxVmfShYCZpjXJs0XNeTgh9ukIiV+SmcVlM3/5YejC/IbX6KeMqEyfcbHVqiXcpJoAIVXNrDlPcoLzQyeOE0xQ+2hYLfFrhytGrJeWjwkcd8HIvc9dkYgWRSxOyR0eSd60U6CYFcSIxxiq/si45Aec8sd32DHUmyfR9OBy4pNr8o+9OxmqNYpzTP5VZCWjv2/9geNOQtqbRZ1EyytL8PKMDIpLa5OmfjtL5lNKFqoKQp5FahT94+OXuXesOlt389ZeZCNGA2VTT7Y9FusY5hmckCuyVi5fIjBmObSkJh1VKeEKtV9u0oi3rmIOvcuZQn4DzfiA6J7vV94YMW/cHsoImKGD5bm+/lZz5qLOgFtj5bjSHix5YQRE8GlM1Cw/KNi4B3xl7GoevSxANODGVTpceYxXRL5IaROyCrf56ysNW7oUr6i7HQLbiOgwIcUAgG7vMOmsErI0UdgMPq1pb07EVvfPNhXixLfy/y/KxwvzHlKHYRItNpUjcEfX01MFt+IxZ4nTABHGUQfay3hLc79shwRq1a26DIsmhKlUP5vOMFaXgZTuLoV8GkHc62SFRNwShA8RZMeM4iS0UiVpWOoP51BEUcebX0q0HUJ0WIkq6zLNMzUg8UaUiFNRKH5wFOkVhmIvePKptQNYbYJ2QSYsMVyYamA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(66556008)(71200400001)(83380400001)(2616005)(8676002)(4326008)(53546011)(86362001)(6506007)(66476007)(8936002)(91956017)(66946007)(64756008)(2906002)(6512007)(122000001)(508600001)(316002)(186003)(36756003)(38070700005)(54906003)(6486002)(5660300002)(76116006)(66446008)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlJHdllOYWdzUkdBRG9xKy9vZzFCaVBsQzJXT1FjMk9YV242MmVsdUhmME9G?=
 =?utf-8?B?Y3dQd251U1FtckxJdTB3MmpyOVhKcG5NTG5oeEZPL3dYZDN0ZUl1NzRaT0R5?=
 =?utf-8?B?RUlJZnRqWlJzbkl5L3h1ai9IbForTHRwU010bkIveTVTQ0tHNXVKNFpUZVdR?=
 =?utf-8?B?ay9Ed3RJYnFhZmFRaXAybTY0Yjl1a0FuUFdUZHd0Y1BlaStnbEFBaTVtQ0xm?=
 =?utf-8?B?ZEtjTWZDY29aUFkzdjhQcUJkNWN5OUlKNWRXWnl6WWtweHVENTdOb2ZJNXFH?=
 =?utf-8?B?UTZrRDUwYlJnUUxDdXFwSWFNNXkvaHVQcVpwRFlXaGdDWDZVbE9Uc003V0dY?=
 =?utf-8?B?K0dicEVuU2ExYmFyMHJ3NHRpVktvUVdEU20veklDblI0ZkVzZXNzTGQ2d0lj?=
 =?utf-8?B?ZC8zaS9OaEV0UHEzNFIrRGRtdzhodlZJTjF3eU9KNkd1TFpCSWFJdXZKVUxB?=
 =?utf-8?B?bWlzanE4WFdaak9TTjZKTzY0bXErcUJiSllhenkyQ2ZhV0tzWFZMcDdob0Y3?=
 =?utf-8?B?SEFkSzR5ZzZlNjBua0l1b0NWcjZOUzBoUS9lVzl3UU1JUzZKdXpYMExkMk1s?=
 =?utf-8?B?cUlZZEhIRnRrdy9SUjF4am56bmlVbUhKYlFvQzhkU3BvRGUrRmRKMWowMGxk?=
 =?utf-8?B?M2ZSS2Fad2M1Wkc0SExaZFJNNGZzQVA3TG03cW1VclBWc285cno2Qml6bjNL?=
 =?utf-8?B?Yy9MRDVnWnRteENzMktKNDQxczJZOHBNQjFkSUdkWlNhcFhJcDVkS0Qycjc5?=
 =?utf-8?B?YVdmYXBobkxSR1pneFdYZlJ5SCtLanFoLzJwMUd5bVQyVzE5akordWpZcytR?=
 =?utf-8?B?U2hYa2kzN1R2NUtldlg3Y3d4bElJRFpkQTRtaUdmcWpvVGc2bUVuNlFQSWRC?=
 =?utf-8?B?OGd5dG1FM1BURTlqbEdoZDg4WGY0SkdNN2JWMXpyQXdUYzJsQS9hUmxWNnJw?=
 =?utf-8?B?bUJ2ZjJhd0J6TnpUUDJ1Z0RZbllkRHlZV041dmtTRnRVczF3c2UwTFhIK0Ni?=
 =?utf-8?B?OUNrWTUvcjBaNWlmU2Zqa2RDbmNORFk3VGVXWjN6dzdPSWF0Yi9rbTJLZ1Vh?=
 =?utf-8?B?VW1pN28wc3JOVWt5SitPT3RIdkJieUhJWmFBNkF4VnBtakhERFlvYlpBbk1t?=
 =?utf-8?B?S0VEVUlxb3B1SzlXeU5qQVVKbzJwWHpPYjF6eUtueFVLNmE0dDNnZnFjNmlr?=
 =?utf-8?B?Tks2Q3lQUEcvZXVQTVBVMy93ZW1seGpNZGdkMWRjbUdKWXdmcGVGeUFLRFha?=
 =?utf-8?B?V2VTVkFEUEI3TGJnZ1ZLQVdGeW41b0FTa2thL2dzWFFQWjNEcTNWTk5ySXJO?=
 =?utf-8?B?R1hwVytzVUk4U2dYKyt3WmNsQzZSQU0vZlltVWlQZlIvYzVTTmQyM01IalV5?=
 =?utf-8?B?d3BIWG5nQk81NlZGL2xMR1JweUM2b0lZbTI4blZSTXR5RzFGcnJXb2tmck83?=
 =?utf-8?B?Tk5iQnh3VXZhYXF5bDVIdlRQaFUwcWU5ZWZvYXI4NEZHQzd1akQ5bTZqU2Nl?=
 =?utf-8?B?L04zS014RHBGdm5HR2lRa3NIRFRCK0ZwYWY2Q0d6WGRTNWR2WVl2T3lyYkxx?=
 =?utf-8?B?NnpTWERHVTdUWnhjdzJyc28reTBzU0l6SS93QWF2MVVoRUp4dkNZZGNSWmY2?=
 =?utf-8?B?Wjk3RmU0SmNCSDArNXpkbWlkbmZ2dGRDeTlBdDhOZnY4RU9TQ1NNY3ZlY0Zx?=
 =?utf-8?B?U1FzdkVzSGNxQ2hTWERhNGx5aVlXdHFYZmdNODJDei96UnNvRVIyUHBRWnQ5?=
 =?utf-8?B?ODhHbUEvOVVQbEcxYmhZK2NZdkprLzhUNGkwTU80VFJiUlVPZnF6dUxEYnhl?=
 =?utf-8?B?R2Z4aXh0anBpQW9jZzJKL2NrRlhSZWtOckRpUjY4aHQrRjdZUXFoL0FUM1R0?=
 =?utf-8?B?SGk2emlYZUR4b2R6Y3J4Mkd5SkkyeEVqeGRlUTRTUFNmQzRpNHJyM3lhcmN0?=
 =?utf-8?B?TmhkclRyWlp5ejNZTHZVTlkvRzBOcmRjZElnT09ZMS8zVFpXejRaZGNQNHJN?=
 =?utf-8?B?NzhaZURwT3pPTnlKSTI2YnIzS084dExtVFU5ZUdkaExLREJoK2pEbEppV1hU?=
 =?utf-8?B?Mzd2cEdhVXpReGZxZGROTVV6MDBQYnQ4M2VOTzluTy9QaE5xN0JBaE45aWRI?=
 =?utf-8?B?Z01TZ2psbmpZYS9aQkgyTXgramRUa20vc3hxWlB1M1A5OERXeDZQMkhRQlhE?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C5BD3CE4CA49C43BE63FD8F2166A172@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2793be5a-3510-4c49-438d-08d9f5f164a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 10:52:17.3617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HiDzMwHR+BYWAg8zd5YCi+oTIMgX9gQigg0XKeBYA2Tx5Mr94YNLuUT8IWCai7Uf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4056
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: WV-JBpZbkL7ouSta9bOBMf_RNGDBk9wU
X-Proofpoint-ORIG-GUID: WV-JBpZbkL7ouSta9bOBMf_RNGDBk9wU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=717 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220063
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

T24gVHVlLCAyMDIyLTAyLTIyIGF0IDE1OjM0ICswODAwLCBIYW8gWHUgd3JvdGU6DQo+IA0KPiBP
biAyLzIxLzIyIDIyOjE2LCBEeWxhbiBZdWRha2VuIHdyb3RlOg0KPiA+IEluIHJlYWQvd3JpdGUg
b3BzLCBwcmVpbmNyZW1lbnQgZl9wb3Mgd2hlbiBubyBvZmZzZXQgaXMgc3BlY2lmaWVkLA0KPiA+
IGFuZA0KPiA+IHRoZW4gYXR0ZW1wdCBmaXggdXAgdGhlIHBvc2l0aW9uIGFmdGVyIElPIGNvbXBs
ZXRlcyBpZiBpdCBjb21wbGV0ZWQNCj4gPiBsZXNzDQo+ID4gdGhhbiBleHBlY3RlZC4gVGhpcyBm
aXhlcyB0aGUgcHJvYmxlbSB3aGVyZSBtdWx0aXBsZSBxdWV1ZWQgdXAgSU8NCj4gPiB3aWxsIGFs
bA0KPiA+IG9idGFpbiB0aGUgc2FtZSBmX3BvcywgYW5kIHNvIHBlcmZvcm0gdGhlIHNhbWUgcmVh
ZC93cml0ZS4NCj4gPiANCj4gPiBUaGlzIGlzIHN0aWxsIG5vdCBhcyBjb25zaXN0ZW50IGFzIHN5
bmMgci93LCBhcyBpdCBpcyBhYmxlIHRvDQo+ID4gYWR2YW5jZSB0aGUNCj4gPiBmaWxlIG9mZnNl
dCBwYXN0IHRoZSBlbmQgb2YgdGhlIGZpbGUuIEl0IHNlZW1zIGl0IHdvdWxkIGJlIHF1aXRlIGEN
Cj4gPiBwZXJmb3JtYW5jZSBoaXQgdG8gd29yayBhcm91bmQgdGhpcyBsaW1pdGF0aW9uIC0gc3Vj
aCBhcyBieSBrZWVwaW5nDQo+ID4gdHJhY2sNCj4gPiBvZiBjb25jdXJyZW50IG9wZXJhdGlvbnMg
LSBhbmQgdGhlIGRvd25zaWRlIGRvZXMgbm90IHNlZW0gdG8gYmUgdG9vDQo+ID4gcHJvYmxlbWF0
aWMuDQo+ID4gDQo+ID4gVGhlIGF0dGVtcHQgdG8gZml4IHVwIHRoZSBmX3BvcyBhZnRlciB3aWxs
IGF0IGxlYXN0IG1lYW4gdGhhdCBpbg0KPiA+IHNpdHVhdGlvbnMNCj4gPiB3aGVyZSBhIHNpbmds
ZSBvcGVyYXRpb24gaXMgcnVuLCB0aGVuIHRoZSBwb3NpdGlvbiB3aWxsIGJlDQo+ID4gY29uc2lz
dGVudC4NCj4gPiANCj4gSXQncyBhIGxpdHRsZSBiaXQgd2VpcmQsIHdoZW4gYSByZWFkIHJlcSBy
ZXR1cm5zIHggYnl0ZXMgcmVhZCB3aGlsZQ0KPiBmX3Bvcw0KPiANCj4gbW92ZXMgYWhlYWQgeSBi
eXRlcyB3aGVyZSB4IGlzbid0IGVxdWFsIHRvIHkuIERvbid0IGtub3cgaWYgdGhpcw0KPiBjYXVz
ZXMNCj4gDQo+IHByb2JsZW1zLi4NCj4gDQoNCkl0IHNlZW1zIHRvIGJlIG9rIC0gYXMgaW4gbm90
aGluZyBjcmFzaGVzIHdoZW4gZl9wb3MgaXMgcGFzdCB0aGUgZW5kIG9mDQp0aGUgZmlsZSAtIGJ1
dCBJIHJlYWxseSBhbSBub3QgYW4gZXhwZXJ0IG9uIHRoZXNlIHRoaW5ncyBzbyBhbSBoYXBweSB0
bw0KcmVjZWl2ZSBmZWVkYmFjayBvbiB0aGlzLiANCg==
