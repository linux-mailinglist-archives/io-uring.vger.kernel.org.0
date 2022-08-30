Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34155A64DC
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 15:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiH3NfA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 09:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiH3Ne7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 09:34:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC65112D
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 06:34:56 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27U3CWSJ023479
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 06:34:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GJPT/GHNFy0nwJireaDuw9FjEDTNUhcTG0hFjjpFYUk=;
 b=EKjMZIiYcYtkVEeCQiT6iEWGAX7gTKfHxQRW450q44NN8cek3sioFO8DI0OiCmGrErIb
 l8u+xJgjo2Q5JOemfOvxpZvNWbmxw5Z6maz3B+3I7Q9yEDY3RRQHJ1KKRmyggV+pAysW
 eslIYy1XrLW+WD7m+RDVEbeUDzKKG8MbFmA= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j9ae4agr5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 06:34:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOYSmYt5pxq/0fJf3VPDZwVdLP544TJXmAgP2Fa3zpINZb0oQh+WLhzxiXwdXobnnETbc2fgFMeL82pHbtVQE68X3hOnh1jEdg0rvr+pyN3VczG2botEuSt2RHX1YpvMwoIEpp5aEFzKjIOnWw5Z9WmRqTMQYYDyeWI5YLCxIqp5ZCfHAF15zXu7xLJmq35D70dzfd6NNt0CNYNEtCqx9dQtKpQ7dVIuFsaMYb/kRRjOoYz849YawY9clIfckLwdhQrtIWFzwrjs4Gz8tdqvW1l1gf8L96YF91E4l3Yu7RysAS7h5CRAJ7N9LaND1g3mkKOItxagBWE89fWscVPyyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJPT/GHNFy0nwJireaDuw9FjEDTNUhcTG0hFjjpFYUk=;
 b=iCO+g2feNZddqUf0TDmdzWORp57J3cUh0LMe8G9m1xvdEZ0wVUT2PrgMV08qNAYxBcdSAN9giRSQ628IQEWVildUT7zXidDRUZR0XfM8njm7tAipyxMsorpTkkjvq5SnYobffQ2dp25yvb2RDk7Bj5LKSYFWYUBgpZPKtyTOarpZLZSNTTLm1JKDVNJE4vGJ+UHagciuWS5dBECgDcqmU3X9SyWaRU5BFTbBGdztyHaeB+ePC/fhRQi5cYn/wE3Jf0b4J0CfXmHjMVFNW1ipimd2pSK9i6Ac+VWdskr5miEjrNJrocZwsjiiPoJ/JJMU2SfNuxns/DOBXp2ir5Ahpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW2PR1501MB2009.namprd15.prod.outlook.com (2603:10b6:302:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 13:34:42 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::18f5:8fea:fcb:5d5b%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 13:34:42 +0000
From:   Dylan Yudaken <dylany@fb.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "hao.xu@linux.dev" <hao.xu@linux.dev>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Thread-Topic: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Thread-Index: AQHYs8YZgYIjfx1FPk+KZcivvCe6gK3HftEAgAAEJoA=
Date:   Tue, 30 Aug 2022 13:34:41 +0000
Message-ID: <8ef2606d55d1097a17c24062fa64e39d43903755.camel@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
         <20220819121946.676065-5-dylany@fb.com>
         <3e328ad8-e06a-f6be-f6fb-1d9b2fbbe9ae@linux.dev>
In-Reply-To: <3e328ad8-e06a-f6be-f6fb-1d9b2fbbe9ae@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba8c15c7-f15e-49d8-3331-08da8a8c64ff
x-ms-traffictypediagnostic: MW2PR1501MB2009:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XkoWiGS2lFnVdSThFmwu3ySUp7GZqYJnajBie9p7KueOJ/M4hmHiC+mDYAaTpjkUKUMr3iWjeA8zstmEFjnPBm0imB+Ln8X5odhCztsCqYCwJm+mEBwzhIVMCrKcAxhdSWfw8pmiPHRzIKkfUvbpfoFJzSZqcABxie6gm2oyieAroqeP33GUvbEO0mhOumMSzWON+jlOuVKjzameRCUzUJtGo4To0BWiNKaylu9/cgEktg0SzhFq8n/CN5t8lkWbp5q4HUA9QwdrZUVfVj85h9o8ZjjCyVGxuN9UfRJuR0ySItpkWt2llnRQdn3L0UpRQ4BcF5t784w2tFtjqBqR/BdkTJE3w5AeNKtzf7oquLyiT57EvLGq3G9rs4eZ/gEudsnlKBYegA6hbxcJQZNH4gmgYLbHt9ZumbeW2/9rqg0jplZgZEBFB/epp4I+qWO1d8qFa+tsPXvyvglIT6kuEDp6twO2KxnPfvSUs3QIvsqhrUWQtelrD0f5a2Vzf3tgPET5BxP7yklZWny3Bn5W6rgrA0//vOWkmOOf+3RofOQfAegaIMfaqKDN/1zVluqeh1jlbykbGkrLAfPUdqjvGbz8fagid1ALw9iF9vFRPfJJVc9EadUkyBeSgdzg2dcFTFTX05GEoZeQL3mpyZbef5IlDW6d1aqW6/B0fSq5AgKGx0pixVydF5QiY4T9wLEn+fsu+WJgiFqygxpZpE7dZpWV8kd057G+BEUMklJVMs5JIkVDIseZlh4sZ/WuoqsEkDZEGE0k8VaZTJl436vSxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(122000001)(478600001)(38070700005)(86362001)(110136005)(66556008)(8676002)(66476007)(66446008)(64756008)(5660300002)(91956017)(41300700001)(6486002)(76116006)(66946007)(8936002)(4326008)(38100700002)(316002)(2616005)(71200400001)(6506007)(2906002)(83380400001)(6512007)(36756003)(186003)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHpkY1AwcXU0VEk0ZmZGODgwdWxZL200WncySjNwTGV6R2hGR2VjMEYvSEcr?=
 =?utf-8?B?aUFsWW5zYUxINFFVVVd5THlaRFpSSHg4dGM4dFphcVdUK1ArSG5VYmlveUZj?=
 =?utf-8?B?QytDaXdVcXZkNWVXUHJ2a1ZxREg3Wm1sbG9yVVNOOU05TlNUdFRZd0xPZ3NB?=
 =?utf-8?B?S3FWZEJLU1R4QlRlOEcvcGt0djJKV1ZUbWZkeUtDbXk4ZGJNbDdRcFMzaGFk?=
 =?utf-8?B?eWM0a0g5cU5BWW41MFBzZWFUTEhOWlU1VnR4bGdxVjA2UlcrK3g5MmwwM3Ro?=
 =?utf-8?B?bGlmZ3V4TVZ2anpvYTM2Uzh0SThkazhRQUJMOTE5THNMVnVKUjFtb3lTSW1R?=
 =?utf-8?B?c1BHNXRhbHRkUk5MWWdFWnFtaFUvcnpoQ2pJSmpXNkMrYzdEenhPK2lOYmpW?=
 =?utf-8?B?cURmYk5sdTJacURaZ3B6ekgyaUUrTWNrVnd4c3NxSzk1OWxZUWg5czdYNnNW?=
 =?utf-8?B?bkJRbEJkTGJVWjdab2Y4bHRydTl2enUwOTI5cVlWZjd4UEh5ak1DTHNjUll5?=
 =?utf-8?B?VEp4UU5xRWxDTTVCZXppTjdBOTc3cmVycjBuc3d6cEtDUVo5WTJmajZ5V2wr?=
 =?utf-8?B?TkkzdWNMWExxWWt1aXRIQXBrTVZxeEpRb1JaZkxidHA1RGRySkpodXZpa2FS?=
 =?utf-8?B?SmNuRW1GNVVQSHEyYlZvTEdaaGd0ckxYQ1NiRWpRMWU5NFo2TmZrdUdwclZn?=
 =?utf-8?B?OXJPdDRPaURWcWdhN0hmTk9Fc0ZSYXVPamZQbGtpQlVCZ3ZqSzZYbEZzaWNT?=
 =?utf-8?B?bml4bGdLY3JmWmN2OE43c0JlcWpVMGdPaWc2SG1Ma0N2aC9nUENpSVlmMDdK?=
 =?utf-8?B?OHNmaEdpaFp4bWMyMm5sTFVOcThpZVQrTEFiUTZEQysweVVtUlgzeFdXT04v?=
 =?utf-8?B?bUljN0YrcUxJT25kcldLYXRhckdPemUzUjRyc2ZPT0wxa21hRmx4UWl3VkVz?=
 =?utf-8?B?TmFLZmVwZWFXVy9iYTRkaXBXL1B1MnZ2ME9vOFVtNVo2d0RKT1k0OE1tdVkx?=
 =?utf-8?B?NnU1ajAvT1ZKSmJMYlU1eGpWTnkybURhM3U2QmxOM1ArenRDN0JsQXJQaWwr?=
 =?utf-8?B?RW1KZnpST1dpMys3eTFaZjFBTjh5VWpEQnFYV0tJVXMrNFZIYkRnNDFxajda?=
 =?utf-8?B?aVpLcGVMcVg5Y2RodC9mNk5DUzNPMGc5SkFKTGVxN1Z4VGhqSFQ0ZU1hRlJm?=
 =?utf-8?B?ZUc0OEZNNTY0VmN5eXBkVmtsVk9pSTBuQWE5U3lNUGRiRG05bWZWVnBQSWhF?=
 =?utf-8?B?czd6K3ZpZUtkalQwVjZKYXhMT0d6ekVDajRwNFM2SUwyU2doZHFZVlY0VCt6?=
 =?utf-8?B?eVFWS3I3dzlzbXZTb3ZoZFluNERWOGJ6MDFwT2Y0ZkNmZEFEMU9LeURwbm1Z?=
 =?utf-8?B?RTkrcTJ4S0J4ditzZ3JiL1FEZ0ZpUkVkaTViellZdnkraVNzdzkzVkJoWjBH?=
 =?utf-8?B?LzMvMHp4VUN5WWJhVmpYWVpIQXZ6ZnlZSzN2dTNaYVlsUzRtaDl0Nm1PNDNm?=
 =?utf-8?B?UUd0ckxGcjVtbkdiRFR1ZnZ2QjNuL3BLU080TC9hRlNMcHBTdGNWbzdNaWVm?=
 =?utf-8?B?WW15QUpQSG13REpnU09ndVZheXlWUXJoeWR4WTlsMHFEaWNieWxpNDRqNHBR?=
 =?utf-8?B?R0lHOE4wSnZ2M0Fvc2JUWHVTLzQ2UlNHRzBJeUVIR0ExaE9ndlcvT0d4NXU5?=
 =?utf-8?B?K1BGK1h2SGNUcXluUDAwL3R5TXpvWEEvUHR1QzhxcWFvdzlnYzEwMmU1cmNU?=
 =?utf-8?B?WTU1eVAzcm9UMWVpUEtRdjZGZW52YnJyV0JTZC9PKzF3NkdxY0RJcFVBd1Yx?=
 =?utf-8?B?bGFLRnR0N1RraWt0OE1XY1Y0UlJBQ0RoZ2w5T0grTFh2Q3dvdmd0OFBudkoz?=
 =?utf-8?B?L1I2Um1KMThzdVo4ZmkyZDlRWkhSem5HUi8yNVpZcFVLek9kYTBuemNaY3FO?=
 =?utf-8?B?ZGd5Rit4cno0a3RsS2NHNzJxTVcvVEdweDNlTkQ1T2hYYXhOZDhvbll4ekJi?=
 =?utf-8?B?WWRrdG9DSlNZeHVVZmdkb1p5amZPQUZpcGkvQmpBUXd1MWYxRWhHMDI5TEp4?=
 =?utf-8?B?NEtRYnpYTGRodGdhd3dhL3pxUEJqMjR6ck5DYUxBejM5Q05BcGhybHdDaERa?=
 =?utf-8?B?U2t1a1lROGp1Vy90OGs2Mi9UMmVBY1R3RkEwMXd3ekp2TFV2eEp6bjB6aTk1?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <252FE30DF6297D41862A10CA3B9DD26E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba8c15c7-f15e-49d8-3331-08da8a8c64ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 13:34:42.0691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dUg8XFEOHXn+ICl7gS2K7dp89TFbxEJz9wP36vDaeEYPN69ahsqPXH7oUDLzHXOf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2009
X-Proofpoint-ORIG-GUID: sxnHV1S-7KF-3NukF0VYlCXu23JVU8rj
X-Proofpoint-GUID: sxnHV1S-7KF-3NukF0VYlCXu23JVU8rj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_08,2022-08-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTMwIGF0IDIxOjE5ICswODAwLCBIYW8gWHUgd3JvdGU6DQo+IE9uIDgv
MTkvMjIgMjA6MTksIER5bGFuIFl1ZGFrZW4gd3JvdGU6DQo+ID4gQWxsb3cgZGVmZXJyaW5nIGFz
eW5jIHRhc2tzIHVudGlsIHRoZSB1c2VyIGNhbGxzIGlvX3VyaW5nX2VudGVyKDIpDQo+ID4gd2l0
aA0KPiA+IHRoZSBJT1JJTkdfRU5URVJfR0VURVZFTlRTIGZsYWcuIEVuYWJsZSB0aGlzIG1vZGUg
d2l0aCBhIGZsYWcgYXQNCj4gPiBpb191cmluZ19zZXR1cCB0aW1lLiBUaGlzIGZ1bmN0aW9uYWxp
dHkgcmVxdWlyZXMgdGhhdCB0aGUgbGF0ZXINCj4gPiBpb191cmluZ19lbnRlciB3aWxsIGJlIGNh
bGxlZCBmcm9tIHRoZSBzYW1lIHN1Ym1pc3Npb24gdGFzaywgYW5kDQo+ID4gdGhlcmVmb3JlDQo+
ID4gcmVzdHJpY3QgdGhpcyBmbGFnIHRvIHdvcmsgb25seSB3aGVuIElPUklOR19TRVRVUF9TSU5H
TEVfSVNTVUVSIGlzDQo+ID4gYWxzbw0KPiA+IHNldC4NCj4gPiANCj4gPiBCZWluZyBhYmxlIHRv
IGhhbmQgcGljayB3aGVuIHRhc2tzIGFyZSBydW4gcHJldmVudHMgdGhlIHByb2JsZW0NCj4gPiB3
aGVyZQ0KPiA+IHRoZXJlIGlzIGN1cnJlbnQgd29yayB0byBiZSBkb25lLCBob3dldmVyIHRhc2sg
d29yayBydW5zIGFueXdheS4NCj4gPiANCj4gPiBGb3IgZXhhbXBsZSwgYSBjb21tb24gd29ya2xv
YWQgd291bGQgb2J0YWluIGEgYmF0Y2ggb2YgQ1FFcywgYW5kDQo+ID4gcHJvY2Vzcw0KPiA+IGVh
Y2ggb25lLiBJbnRlcnJ1cHRpbmcgdGhpcyB0byBhZGRpdGlvbmFsIHRhc2t3b3JrIHdvdWxkIGFk
ZA0KPiA+IGxhdGVuY3kgYnV0DQo+ID4gbm90IGdhaW4gYW55dGhpbmcuIElmIGluc3RlYWQgdGFz
ayB3b3JrIGlzIGRlZmVycmVkIHRvIGp1c3QgYmVmb3JlDQo+ID4gbW9yZQ0KPiA+IENRRXMgYXJl
IG9idGFpbmVkIHRoZW4gbm8gYWRkaXRpb25hbCBsYXRlbmN5IGlzIGFkZGVkLg0KPiA+IA0KPiA+
IFRoZSB3YXkgdGhpcyBpcyBpbXBsZW1lbnRlZCBpcyBieSB0cnlpbmcgdG8ga2VlcCB0YXNrIHdv
cmsgbG9jYWwgdG8NCj4gPiBhDQo+ID4gaW9fcmluZ19jdHgsIHJhdGhlciB0aGFuIHRvIHRoZSBz
dWJtaXNzaW9uIHRhc2suIFRoaXMgaXMgcmVxdWlyZWQsDQo+ID4gYXMgdGhlDQo+ID4gYXBwbGlj
YXRpb24gd2lsbCB3YW50IHRvIHdha2UgdXAgb25seSBhIHNpbmdsZSBpb19yaW5nX2N0eCBhdCBh
DQo+ID4gdGltZSB0bw0KPiA+IHByb2Nlc3Mgd29yaywgYW5kIHNvIHRoZSBsaXN0cyBvZiB3b3Jr
IGhhdmUgdG8gYmUga2VwdCBzZXBhcmF0ZS4NCj4gPiANCj4gPiBUaGlzIGhhcyBzb21lIG90aGVy
IGJlbmVmaXRzIGxpa2Ugbm90IGhhdmluZyB0byBjaGVjayB0aGUgdGFzaw0KPiA+IGNvbnRpbnVh
bGx5DQo+ID4gaW4gaGFuZGxlX3R3X2xpc3QgKGFuZCBwb3RlbnRpYWxseSB1bmxvY2tpbmcvbG9j
a2luZyB0aG9zZSksIGFuZA0KPiA+IHJlZHVjaW5nDQo+ID4gbG9ja3MgaW4gdGhlIHN1Ym1pdCAm
IHByb2Nlc3MgY29tcGxldGlvbnMgcGF0aC4NCj4gPiANCj4gPiBUaGVyZSBhcmUgbmV0d29ya2lu
ZyBjYXNlcyB3aGVyZSB1c2luZyB0aGlzIG9wdGlvbiBjYW4gcmVkdWNlDQo+ID4gcmVxdWVzdA0K
PiA+IGxhdGVuY3kgYnkgNTAlLiBGb3IgZXhhbXBsZSBhIGNvbnRyaXZlZCBleGFtcGxlIHVzaW5n
IFsxXSB3aGVyZSB0aGUNCj4gPiBjbGllbnQNCj4gPiBzZW5kcyAyayBkYXRhIGFuZCByZWNlaXZl
cyB0aGUgc2FtZSBkYXRhIGJhY2sgd2hpbGUgZG9pbmcgc29tZQ0KPiA+IHN5c3RlbQ0KPiA+IGNh
bGxzICh0byB0cmlnZ2VyIHRhc2sgd29yaykgc2hvd3MgdGhpcyByZWR1Y3Rpb24uIFRoZSByZWFz
b24gZW5kcw0KPiA+IHVwDQo+ID4gYmVpbmcgdGhhdCBpZiBzZW5kaW5nIHJlc3BvbnNlcyBpcyBk
ZWxheWVkIGJ5IHByb2Nlc3NpbmcgdGFzayB3b3JrLA0KPiA+IHRoZW4NCj4gPiB0aGUgY2xpZW50
IHNpZGUgc2l0cyBpZGxlLiBXaGVyZWFzIHJlb3JkZXJpbmcgdGhlIHNlbmRzIGZpcnN0IG1lYW5z
DQo+ID4gdGhhdA0KPiA+IHRoZSBjbGllbnQgcnVucyBpdCdzIHdvcmtsb2FkIGluIHBhcmFsbGVs
IHdpdGggdGhlIGxvY2FsIHRhc2sgd29yay4NCj4gPiANCj4gDQo+IFNvcnJ5LCBzZWVtcyBJIG1p
c3VuZGVyc3Rvb2QgdGhlIHB1cnBvc2Ugb2YgdGhpcyBwYXRjaHNldC4gQWxsb3cgbWUNCj4gdG8N
Cj4gYXNrIGEgcXVlc3Rpb246ICJ3ZSBhbHdheXMgZmlyc3Qgc3VibWl0IHNxZXMgdGhlbiBoYW5k
bGUgdGFzayB3b3JrDQo+IChpbiBJT1JJTkdfU0VUVVBfQ09PUF9UQVNLUlVOIG1vZGUpLCBob3cg
Y291bGQgdGhlIHNlbmRpbmcgYmUNCj4gaW50ZXJydXB0ZWQgYnkgdGFzayB3b3Jrcz8iDQoNCklP
UklOR19TRVRVUF9DT09QX1RBU0tSVU4gY2F1c2VzIHRoZSB0YXNrIHRvIG5vdCBiZSBpbnRlcnJ1
cHRlZCBzaW1wbHkNCmZvciB0YXNrIHdvcmssIGhvd2V2ZXLCoGl0IHdpbGwgc3RpbGwgYmUgcnVu
IG9uIGV2ZXJ5IHN5c3RlbSBjYWxsIGV2ZW4NCmlmIGNvbXBsZXRpb25zIGFyZSBub3QgYWJvdXQg
dG8gYmUgcHJvY2Vzc2VkLsKgDQoNCklvVXJpbmcgdGFzayB3b3JrICh1bmxpa2Ugc2F5IGVwb2xs
IHdha2V1cHMpIGNhbiB0YWtlIGEgbm9uLXRyaXZpYWwNCmFtb3VudCBvZiB0aW1lLCBhbmQgc28g
cnVubmluZyB0aGVtIGNsb3NlciB0byB3aGVuIHRoZXkgYXJlIHVzZWQgY2FuDQpyZWR1Y2UgbGF0
ZW5jeSBvZiBvdGhlciB1bnJlbGF0ZWQgb3BlcmF0aW9ucyBieSBub3QgdW5uZWNlc3NhcmlseQ0K
c3RhbGxpbmcgdGhlbS4NCg0K
