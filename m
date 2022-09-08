Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DA85B23CE
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 18:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIHQoZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 12:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiIHQoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 12:44:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D934CF6
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 09:44:21 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288E3BTa010287
        for <io-uring@vger.kernel.org>; Thu, 8 Sep 2022 09:44:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fIvmJW0mOA/nB2fjQwRvTXeBCACGx0nCyDTIGEWHhJ8=;
 b=rcyOyIpFVNeJJutUIt+ALk6WQjsHgdZTKACSBcX6rvLb23yU25yectrxu+4MPR5KyVTP
 TRAPCC1rpdypAguwMgk0aKf5hXcOhVU2ivncKjELV0bBAwAuz2c+VYV1MgVWdVQJjPdI
 SOq2s4aHjRa+jUK7fI9/imh5zG7zI/VIlbw= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfhth97n8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 09:44:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4VewQmZrPMHcW/LUiJqg2VVuuOD+9YScQbPfZ8x2tWkYQ/KEq9RR6Btot/RgRzg1Q3wFxTwJxEHkv4lIBzPo6k3GkrkXj+PSqhX5Z0hT+ul+1DkjY1w/XjPJ4j02UJ6xY5mpQQdGHhBml0F9zETKql2RiSkrtcg3AXrbPCYHI9LguuOFcuPF8Txe76tj/XBn4pt+KUzxVchDXAGxxkrpMxg4THlvXFrn70gPIsFLpoE6XgFE5PefsNwe1Zuw4wUDFBbjnHJc4802/fcUPmPT5n3Oohtx1/na9yaiNRf7ahWDZq4MdyrfKEO2kKCt4yOddOEgSSpMXZ3C1A3loL25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIvmJW0mOA/nB2fjQwRvTXeBCACGx0nCyDTIGEWHhJ8=;
 b=AXj9QEkB7p+54bQG8KZvAmN4GvtVTysOua3ADLbuB72Lp5yMPZBB7USdmFJpSqIw8EiYFot4t1RnUglW6X5GCRoQUKo/Srkv0iAthzVavrif+j4xofCTJ1QBamIF7Z2Nf+yLbmohX26oAA132veO4U++HmX4f0f9Bal+d4Lmn0Jh3RADLkoPpeffj0924HLip3JJeoyLaAs445hNEUUVPyZ/9jRP/DjI6YfKMyUwo1jz5zD4QRWksZvDoO2cGg+PdoAgt1TrdTIOBULHJVzIT8VEOlrxQVtvHGxQvREvD0VWiZYvENHo+5EVOee8LB5KHcG3fFa0mdafdJ5c6w3C3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MN2PR15MB2686.namprd15.prod.outlook.com (2603:10b6:208:128::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 8 Sep
 2022 16:44:13 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%6]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 16:44:13 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 5/6] io_uring: add fast path for io_run_local_work()
Thread-Topic: [PATCH 5/6] io_uring: add fast path for io_run_local_work()
Thread-Index: AQHYw5vt3eAnhZHOE0yqZKkVkCE0z63VvToA
Date:   Thu, 8 Sep 2022 16:44:13 +0000
Message-ID: <43a4da0e823d9ad9e93618ae1a3ccf548ea315a0.camel@fb.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
         <f6a885f372bad2d77d9cd87341b0a86a4000c0ff.1662652536.git.asml.silence@gmail.com>
In-Reply-To: <f6a885f372bad2d77d9cd87341b0a86a4000c0ff.1662652536.git.asml.silence@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|MN2PR15MB2686:EE_
x-ms-office365-filtering-correlation-id: 1fdc097d-4bd0-46ab-6553-08da91b95c56
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v9S6A8EQTsgdnLm6SZQ2/62DJ+Wj6+jpNL2qMR8/OriPYhLbh16N28xRgHuv4+MhU4yZcYRXL5JpYQB7eon61tQtgYxrpzXljU6sReZ6wErYYBywrQMxG9ScZ36Lzx8si+D9BloB+m8bE3V3/mNukF33oQIj365W4OczYlN/o7hpX7GSu/GPrHpTewkcNQkx+TNLOY4Xjai+t7ov05MVNu/RJXYQW6CjM5ZBXKGGiFr3rpb8V+bydkO6P2f2x4mcEHruVJ79V16PMq0SQ+iU81Cg24U21xMegYCXWvIPXWw+rvjSMpaJpUbQmfOkZLh4yndcsrg7N5DnXKj2sFWiFm42C8sy47lav8rRnaqPWli0QZGQGX4+G8pMsMs6VhWN7asHKzV77z5yKaXI6Af8JR815zdSrDjXPxanbrsZ5oAD1fFn7nEXt9ezhl4mZuXJ1yxodgdOGV7ywbUZiMVPwBwm0ypn41rlm6v3nWWvPQPmfscZxNwesjHZyCgRYanwQFIpTkVb+QFuWbTG4Q5AiIaRyBvTtjD1QeU0vixI8smWU+JNk/ggSsoP/e+gFK6L0Irbsd+TkKCvSZVPX+kWPC0Wop9ud+90IT2mJzlJHcxYXPJsB+P/up9JvQ1MZvEFI4anOmAO2s5IBpYjfiFLERpl7sJzpAWr2sW2C0b0H2cDDgDxKD89ElyVFWNRyjPJxzLbiyiYwGYtUxybaix5hjCV1pHv/Kra5ex8PIyf/Mprq12GEmBPtqvJgdxa6kgBMVYstt8M7D4x5lR1ZZyi+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(2616005)(186003)(86362001)(83380400001)(38070700005)(122000001)(38100700002)(71200400001)(316002)(8676002)(36756003)(66446008)(64756008)(66476007)(66556008)(66946007)(76116006)(4326008)(91956017)(110136005)(6486002)(26005)(6512007)(6506007)(2906002)(8936002)(5660300002)(478600001)(41300700001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDI0NEROTm53bWdadlpIZjUzZU1tYk5ubzJLVFI0UndtaUt5anZvckZXS280?=
 =?utf-8?B?L3NVcEdGZVo4SmNuQTNBdVpmZ0l2VEt2azlaUUowQ1RDQlBtNWcxelM2djlK?=
 =?utf-8?B?N0M4TnlpY0hjVnVoTG1mdjJrMHNEd2J1aUVSZnJFdXNHUWNTMXdRenZld09K?=
 =?utf-8?B?NzlOYW1FbE1lY3hrT3FkOElUYUFNcjRqWlcrMHZsR2RzTFhiVzNDWkJaaHo5?=
 =?utf-8?B?L1AyYStkcTdjOERmU3U3VXhCOEhvMjhEeW9YUlVQQVdtaHlYbml0ZFU2bWlD?=
 =?utf-8?B?d1Buck1zN1NZQnlHcEZNeFhyM3FHS1ZVOW05Nm9XWkNqTHVBN1ZGaHZxMU92?=
 =?utf-8?B?ekF0ZnZQakJ1VWNuNlNXMmRRYW9RV0laTUUxL05FUmIra2tDVkREVGd6cjZo?=
 =?utf-8?B?RUw2Q3k4MUpXMnBDb0IwVVJsK1JHazdXSURsdS9maTJQS0FxTG50U0FXeFF1?=
 =?utf-8?B?ZFNCUWJnVFB6L1hLcVF0V3FsTENKcVdGKzVkb1hPeE5QeFVMaDhQRHpTcVN2?=
 =?utf-8?B?UWFlZVVIQVp4S3F5TFozL1B6Z3h4eGFCUHRQU0RCK0MveU9abXhtWWh6Lzcr?=
 =?utf-8?B?eVEwK1NHODNacTJiUzFlbUEyMzhGeStYR0hha3pTNUVkMGFZclUvVUlSTHJV?=
 =?utf-8?B?UENrMjJWVW9DQWMwTHZydU1CUXhrbDg5WjJWTUtNL1FlRWljVGZyNFlrNFh3?=
 =?utf-8?B?eDNDOThYS2dRUmJmam5NVUQ4V0Q1aDdyRStnT1ZYQVdCRGpVUytSSEhmWXd5?=
 =?utf-8?B?QU5lZWJkVGdxVG1yNzhtSXBZOXhjUzQ3cDR6SHpTZHJ6ZmQydWJrWWxIRVdS?=
 =?utf-8?B?OE1YZU9lQWJKS096cElxZlpFSzhybWtCZmxhRzJ2Y3BZVDdNU1pJQ0JseWgw?=
 =?utf-8?B?VUFJdituZHlaUFlBRU9PeXBKMnRWdVM2Z2JGZWVYTkFTZW9qeWo0OGQxek4w?=
 =?utf-8?B?ZW5RdUxkd25LelFNNC9XUTNGcHYvaFgvSFNCUlg1MjVJbmNXQkZIUzYybXJh?=
 =?utf-8?B?b1hTNjFlTGoxOUdmQkU0aGsvWVZKUThGVVAvUWJnNko5QUt4bEV1TEZWVjRO?=
 =?utf-8?B?cVZxWS96V1lldHFBNG5XMGN5clRoQm5nNUd0ZFZ0TWxsQnVlTVVkMUZXeWFC?=
 =?utf-8?B?aDcwdW9TSFlLaXZuZ0d1emV5V2RwbzQxRUZxdjlxWEpyaWV2cUJhOS9EaTJM?=
 =?utf-8?B?UUVuVWRJL1FtZjRIRE41Q2o0UDNUT1lTMUFGcTdEaGpZeHp4S3ZrRkduWUE2?=
 =?utf-8?B?U0d3S2RXdXEwTmpOdEdjSlRubytKNFRiZnpmMDZLTW1RM2JDajkxVEo2SU0w?=
 =?utf-8?B?bTBWNWkrUDVHa1kwNnpkK1J6Y095TS9aM1R1czRTbUthREc3Q1lpY3BVWjJU?=
 =?utf-8?B?VnIrQlMrcDdPQlpzYXhNUXZ1QlNwdTFsSkZ0aGFZOUx4S2dLdEliT0E3OWRK?=
 =?utf-8?B?R2VyVkl1ajJYckdEWkI5UXFYeEkvcDFrb3crTy9ta2VlYUs5aWtOUExLR0l0?=
 =?utf-8?B?cG1qQUo5am9UUmpQWW9SaGFaTWhaYU5iUDBzRDVTZGVhSmRwUEpDNEFTZDhu?=
 =?utf-8?B?MCszVGR0SW9IbjN5YlJZWk1PNC9DTzBPY1k1NXBkY1grcVRMSEJnOHlQR0hP?=
 =?utf-8?B?bW4rRzQ0L0dLY1pOQjAxRE5hVHRoeDVQS29VNjhELzdIaGlzNWU0WU9VOUFU?=
 =?utf-8?B?ZnZzZjIzaWhFY0crbHVDd3VaUEFBR21DUTBKeGJGTVpmWEdjUmUwcXhEQ09w?=
 =?utf-8?B?YnZIcHhUNXFaWVF3YVB6WU14ajhXbEJRMjVsdlNiWmllS3JEaStnenJ1aHFI?=
 =?utf-8?B?VExaZitsSWpGQVZhRW8yM010eWtyRzI3ajd2bFZrMWtjZlF5MklXYXA0NnVj?=
 =?utf-8?B?MmZBdTdwM0pOdnFMVmNlMGJhTTRYbHAwTXdtZm1XRTFLNXZzT3J0MThtWlI1?=
 =?utf-8?B?dEVnenM3QWE5RSsyaWVzV0k4djBNUURHazRsWkRIWTJtVmt0WmhRTGhJTHFT?=
 =?utf-8?B?eVlwSHd3WDdHdXpIODFtdG94d1J5Z3I0Z0FFWFJxRjBqaXZKbVdkSGJPUzhI?=
 =?utf-8?B?aDM3RHVRVThZM3NUSXdoenZUbUd4azI3Q3R3d3RqbEhyRlNKdnFiM3BmZ2l6?=
 =?utf-8?Q?jKSkRih3ziYBEh5zjLdjHK6f8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1978CEE49A01C1498EB648EE0C766F85@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdc097d-4bd0-46ab-6553-08da91b95c56
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 16:44:13.0333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J5vTLdzF1gu0jcZV6Wh51eaoP1sOzyr/88CpJY4jc5i9PgcFchiwwjr2UwXkyY3S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2686
X-Proofpoint-GUID: 3e8D6h3G4-qS4RzqXX2_jIzYDkT81bf_
X-Proofpoint-ORIG-GUID: 3e8D6h3G4-qS4RzqXX2_jIzYDkT81bf_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVGh1LCAyMDIyLTA5LTA4IGF0IDE2OjU2ICswMTAwLCBQYXZlbCBCZWd1bmtvdiB3cm90ZToN
Cj4gV2UnbGwgZ3JhYiB1cmluZ19sb2NrIGFuZCBjYWxsIF9faW9fcnVuX2xvY2FsX3dvcmsoKSB3
aXRoIHNldmVyYWwNCj4gYXRvbWljcyBpbnNpZGUgZXZlbiBpZiB0aGVyZSBhcmUgbm8gdGFzayB3
b3Jrcy4gU2tpcCBpdCBpZiAtDQo+ID53b3JrX2xsaXN0DQo+IGlzIGVtcHR5Lg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+DQo+IC0t
LQ0KPiDCoGlvX3VyaW5nL2lvX3VyaW5nLmMgfCAzICsrKw0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKykNCg0KUmV2aWV3ZWQtYnk6IER5bGFuIFl1ZGFrZW4gPGR5bGFueUBmYi5j
b20+DQo=
