Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2BD5B077F
	for <lists+io-uring@lfdr.de>; Wed,  7 Sep 2022 16:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIGOvg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 10:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiIGOve (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 10:51:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEAFA7AAC;
        Wed,  7 Sep 2022 07:51:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoTxwUELPaHPNIAS1RC8cxo+b1bJb51Inv9a3Bpet+1+UPnH9fWbhTLrWcLtSM+RULBvJq8YxWq3ahpKIV8H9/uNAUQ37+RNhT7IlgHC+O5S/xkX7BCKaytuYhob9UpKn2Ej9Xt2vgmJBMVmUa1xq/9uT1c/lhBSUCfz1JdtEqSaO9WiHuh7eNEW/MgDeRUOtlNPIwv4eHaRE/WSzdMkYaJCPu7bhx1uQy6sj0CcKAFwCzG/WevH2ocfTBeRmpHs/h5SaKKEYgp52uPqTBiYc3Vnvm/n7fRQskq72A3SEZPz+lT/rIvXKLza8f42fFDTiU2+1bSli6+hVs3tvBEq9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5GWK65FSq/YvJXyiFKhf5xcD3HrDAWwS4NYGYPBDbM=;
 b=koIZKfSfaputaiLz9a0xRWQRWqmG1b8UwofXT7myBArWzWjuVlbNQM0j0jdoZSd6MlpbI/uvk3qqZCBrMNiZ9Mn8Gkp/jrszYEdm5jmeHEXPKYdn+fUEfSYlNLbIFk28/QI9rfB6pVvol7wYPQ1r5poNDPmr4ZruOzSFWkoXrvXXrpSocypjXMBSJbscfrtYeLfqSVkRPnjCkkPoKa5qY9gJzaoYf0m7cI2wGjeifk3GE2jUhvm+xO3zs25Qb3QOOcB1ZyDZ7sv81hOMM7OF9jWOto7Rv0rqg9PDwjBev2B2napssyldW3PO92POvUb+Bk1AnyLnDNzuBXWy6PJqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5GWK65FSq/YvJXyiFKhf5xcD3HrDAWwS4NYGYPBDbM=;
 b=TBkXr76bY9gVcuqbCn49Xe2uhAZL9ylmy/hAV8R1CLJskgSfOIcIZTwhEiUZvOb//ym6eY5hG5RCOulfuLIncX6OsRyOdII08cHffn91yEOI6iLWsAYBmdWlSuXLs/tklk6M8M/SkCHGIC0WYceq5hGWWVTI8ui3ZwnevWNGZkD31RdTnXflWSDsZ5IhfU1be9gusUVUKQl0XnloARZiTE73qWgNPzf8vGUGXbcB4ect0CAPwFATf8Jvr1Qg4iO+a9ovM9OxOQam6lmkT0Uk8OQzOB/rgFnAHflvOrPnnaWwiml2GFyP3eHIarWltM7H8ML5PCUOABJvIT5e38RnkA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 14:51:31 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c04:1bde:6484:efd2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c04:1bde:6484:efd2%4]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 14:51:31 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH for-next v5 4/4] nvme: wire up fixed buffer support for
 nvme passthrough
Thread-Topic: [PATCH for-next v5 4/4] nvme: wire up fixed buffer support for
 nvme passthrough
Thread-Index: AQHYwbstqr+om5ZRjUKbK0JsRYyCI63UDyuA
Date:   Wed, 7 Sep 2022 14:51:31 +0000
Message-ID: <26490329-5b51-7334-1e2a-44edfe75d8fa@nvidia.com>
References: <20220906062721.62630-1-joshi.k@samsung.com>
 <CGME20220906063733epcas5p22984174bd6dbb2571152fea18af90924@epcas5p2.samsung.com>
 <20220906062721.62630-5-joshi.k@samsung.com>
In-Reply-To: <20220906062721.62630-5-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MN2PR12MB4223:EE_
x-ms-office365-filtering-correlation-id: abc58142-4b9f-4f87-a2ea-08da90e073cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: czwMfLImdPN0q02z/yqyqYmOOivNGCQfpC6Aa2rVc8j5v2+mBp7XAMkYKqV7aglO/rmnDXj5dvD2BQIZHFpiwP5iGRIPp8WoLxbExX9Td6l5Vi5eWqn4udKDTXiUkqHDR4/yDNLYbGVRYGaJTHjuGhj7W7Nmjr4jVJ/aieCJIsLwD/OTuxX4vF+FgejXEjtAety8v1/7EQSwGWQbGBL0xd/I8wvnmZvTvm3SL/xw9xfMZILS/nqQ1E1E2rwHD1VkwUqSG0VgfTY6Zbywhycj2a6FWPqY0eB4mM8E2rQYUFFWaXx24FzfDvsMtMeBvFyMxQD0ykl91u3VuPd9bdT77/LqxjEmYe8l0QAIjWw5G0oCr5TdMnr6LO92V78sgb9n0EzuLh9fM6NNTlLFkgs/dEROdNChN2sHnhc+8PYNDLiXmo8Ldb9LX+ncm7sYbaYfVRYhJHGPphOFh/mf2k+fYIETtDnndN1NqlXnr9Q+qpER/88fQ7QBGwQKhjt6Q5qILtR9XUOmx+LwujiUZSKUfpclosGf16tDDGnm+RyOP42nBrWEZfqq0MbnPE1TZ2JaoEfYSU8+viDEe/mQ209hCvth6HpFj2Z/7K0GILb4pevwwvhzXAs7EU3pI6sKMtBjziYThmGjIJsADYZqp7RqRyUyS7/n4XJots34OUYxZ532dLI6FumHZFV+6jGhT2z0xBIFD5USlstzXcehR+lPSQdO/ydz9iPcBUNMRGevDNHp4SuRcH/d6BysV4JWKtvrebqsyPO654/AFjp/3VHEhWt6NYd6yPGK+CiClDHYtTq/CU0putyu8lpDhty42fgYwk7nGD2Sfw5d+eoe+c4hgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(91956017)(6512007)(8676002)(6506007)(83380400001)(86362001)(4326008)(66556008)(66446008)(64756008)(66946007)(31696002)(6486002)(76116006)(38070700005)(478600001)(4744005)(5660300002)(8936002)(2616005)(41300700001)(2906002)(316002)(31686004)(66476007)(71200400001)(122000001)(110136005)(54906003)(36756003)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dyszcEVIYUlmcWhKVFVGdW1BclBRSTZRQXlvWUFKbWcwdzNVaEQ3aFcza2p6?=
 =?utf-8?B?elJyWVlkeWc1VTFtdWtrdEdJa2xNWDRiQUlCZ3k1R0hUZExQV0k2VlRnQ3o5?=
 =?utf-8?B?cVU1ZDFWc3oxMjB4eFIwS3hEOFMybTB0aEJFcjVHZnUyS3MzY2VNVndvb0NM?=
 =?utf-8?B?S01hQlpaTUFWY3oyVklEajNlMkVYSDBHY1NDelF6eW9ZNHFUMTRKam1tTUdD?=
 =?utf-8?B?eDRFVUR4cFZvMXdtY1NKWis5MElVajIzWTRxSGJ6WEd1QkZ5QWFMekpjcFBY?=
 =?utf-8?B?QTNIL0ZMdkU1bURPUEhrajY5bnc2T3dDVkdGRDJsMUFiT3V6K1VCY2Qxdkc3?=
 =?utf-8?B?WEVQSDlLMEQ5WE9lVFpLOW10V3I0Znphc3BEZWtTb2Q0UXBuQy9nQkEvemZ5?=
 =?utf-8?B?WitRSUV2by96TTF3UHRBWGt3WUtHZXNSMFNRRXRCbzdhM1ZXWHNzNGFsb2Vo?=
 =?utf-8?B?Nk1ZeU14bnVoNXpOQjRmMUgwYnhNNVYxN2Z1OFUzeW9lZGpyR2ZXY1ZJK0xC?=
 =?utf-8?B?VWtGclNKZytVaGsyZy80bUZLN1Btc0Vza2FyeEtuMURyUmF1Y0VZNTdPQ09K?=
 =?utf-8?B?RzVsemxyUy9zZlZCNlp4cnFROEZBcGZJUmwwdnR6cjJDQk9Ub0wyMWxNWlBX?=
 =?utf-8?B?eUZYSUxVWGlMQ1F3aHZjZFVLYnB6dWVZMU5HTUtrc2NKc2ZSTTZ3cjBSQms3?=
 =?utf-8?B?K0NKOGYwbHhtZmhLWEFRMVFRb0tSQlBQcWgyeVFSMHExZTZ5bFVJZXZoME9Q?=
 =?utf-8?B?NVRuOUlOU1VlQWo2QXNsc0RDczZpUE5lMC92dkM2dENsbkRzWkxZRVBLRnVm?=
 =?utf-8?B?UlMrK1B6Mi9id2JnYWJmVEFMdHN5RDJCd25RdEZXdWZ4V3VvQ3FaMk44cE5D?=
 =?utf-8?B?K0ZlellmWDEwV1owdzBSZGY2WWhHRlVXNFhUcHB6WU04SXVldWtVTGh3YjBh?=
 =?utf-8?B?elNITGt6VUlYQW5aNnZ4Ympvb24vamlEUnF0NG92VkRqWkd3MExYcWZKRXNZ?=
 =?utf-8?B?N1plWG5aRDVoZVh6NUVqNFpNbmpiOThEa1hMK2dadDFxemxSNUlDS3Rla0d4?=
 =?utf-8?B?THVxZy84YkZodElpaUExQWY2cWxUdUQraldQS3NoU0kxSm1HMTNZb1RnQyts?=
 =?utf-8?B?NXZKUUxiZHkxTE1QdkJYZ1FMRlYyTXI2STJLUElYeFFwVHJKc2dqV05qUDFL?=
 =?utf-8?B?dXlMd21ueWFHV0tZMVQ4YlJDYnk5RG1QZWU5VE91WWVoQmVzaUdBOW1CTWRj?=
 =?utf-8?B?MkQzb1BIWXNOeGEzZW12UGNRck5WcXFqM0hqV3hpd2swcXRJM280RXhPMGVn?=
 =?utf-8?B?S3JINnpNZ2toWGxtLzJFditlSVBwYXZMaDhYQldnb3hlZzZ2K0dCNWpkL3hh?=
 =?utf-8?B?U2pNQ05ISmptTDV0WkZtT1I1VnVUR1pPL3V6L2xVWi9Id1hQMlZIYkRyUnBE?=
 =?utf-8?B?V2tLZVNRQjE4bHBEajFheFhDTzRldEgzQXdTbUhMbldSTGFOVVoxRWdmZ01D?=
 =?utf-8?B?TERFTHRIRzlHQkRuUEYxaEExTkVrUnlpT0tCd0JsVzJFbkYvUXMxblU0dmRR?=
 =?utf-8?B?d1R6Zi92VGl2QjBlWXR2YzFtZnJWRkZPNUFnRDAwUWxjR29XYUVmRG9SSm1p?=
 =?utf-8?B?Z2JKTTBtOUdjckpxc1FINlBhbXVnS28ybVhrSWh6SmtJQVk1T2Q0OHduUFIx?=
 =?utf-8?B?QVBMNm55bkVndEdVb2dTYUczc1N4bmxjdkw2bjVYSHhGNnIza3B2WEdUaDBC?=
 =?utf-8?B?VURjN1lvOGwyam94aTNMYnF3SzdiZUJHR1RUbWdIbDFvNWRvT1Fvb1VWV3ps?=
 =?utf-8?B?bVU2VDVXOUdSa2U2WlZoZXg4NElCSXRyUVJLRzdCWUEwU1V4RnNxdTBHSjBp?=
 =?utf-8?B?UUtIZmZTREd5Mlp6WXAwZ3JTOVFsckp2OVZZVHlxSVdzMDlDZ3pYQjc2ekJJ?=
 =?utf-8?B?TUx1MS91M2FxRUlUSjNjY3VHVmhaalVjWllLUU5rMWthT0d6SVk2V2N3bjF2?=
 =?utf-8?B?eEI4MXI0MEZZWnhUUWVUZm5yODdzUFdUNnN6a3VwSHBFSVVMWU5hQXJsUmJm?=
 =?utf-8?B?ZjRHZGpxRUZFemxZL2pkaHRKdCt0Z0lHc1htbWxNODBoZEdKY2FrYUg4Ri9n?=
 =?utf-8?B?UG5qV3M0RTNicVhpaUE4YStUek93VnRGWWM2OWV4MWRaSVVTcE5najJiZE1E?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A3065CBF845B349BC9D3E91CDE21312@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc58142-4b9f-4f87-a2ea-08da90e073cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 14:51:31.5833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cyORcOlg2JPo95i6boMYpJ+ZhUgyyRRzzeg4oXxMhcI299T/e2snsokOYeTK0SDxwifOcPlhGNlDjBfTtOw3Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

DQo+ICAgCXJlcSA9IG52bWVfYWxsb2NfdXNlcl9yZXF1ZXN0KHEsIGNtZCwgdWJ1ZmZlciwgYnVm
ZmxlbiwgbWV0YV9idWZmZXIsDQo+IC0JCQltZXRhX2xlbiwgbWV0YV9zZWVkLCAmbWV0YSwgdGlt
ZW91dCwgdmVjLCAwLCAwKTsNCj4gKwkJCW1ldGFfbGVuLCBtZXRhX3NlZWQsICZtZXRhLCB0aW1l
b3V0LCB2ZWMsIDAsIDAsIE5VTEwsIDApOw0KPiAgIAlpZiAoSVNfRVJSKHJlcSkpDQo+ICAgCQly
ZXR1cm4gUFRSX0VSUihyZXEpOw0KDQoxNCBBcmd1bWVudHMgdG8gdGhlIGZ1bmN0aW9uIQ0KDQpL
YW5jaGFuLCBJJ20gbm90IHBvaW50aW5nIG91dCB0byB0aGlzIHBhdGNoIGl0IGhhcyBoYXBwZW5l
ZCBvdmVyDQp0aGUgeWVhcnMsIEkgdGhpbmsgaXQgaXMgaGlnaCB0aW1lIHdlIGZpbmQgYSB3YXkg
dG8gdHJpbSB0aGlzDQpkb3duLg0KDQpMZWFzdCB3ZSBjYW4gZG8gaXMgdG8gcGFzcyBhIHN0cnVj
dHVyZSBtZW1iZXIgdGhhbiAxNCBkaWZmZXJlbnQNCmFyZ3VtZW50cywgaXMgZXZlcnlvbmUgb2th
eSB3aXRoIGl0ID8NCg0KLWNrDQoNCg==
