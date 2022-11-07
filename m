Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB3161F47A
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiKGNhS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 08:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiKGNhR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 08:37:17 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B714032
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 05:37:16 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wJ20029618
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 05:37:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=NAWz49RpDCUyF90g5bSEFqrjq9EtBf8IXraqzILPpyQ=;
 b=XxRvH38FAYNRM8LKtgJReie2AKagyqxT8amQGxkUmwTa739lQuSoiI4aAZ19uEcFEjvv
 scNJiI2sAIy4FPNBeHcHExChHlcGElZ2BTiPdFrJ7z/8Cf6mIn8tIyY3epmj7sqySbWv
 swms2YP4GCgqouKFoZWjvH7ixGl3RVTKot6TgwlgDtec9BrQ+FqwXWlUWztA+DrDNQbz
 oqAicK6X8Hi8skZUjij7Op7TeAx0w5X/naRV6MVX0VraD/VE3TA3ck1702BE67eY//8a
 NhPiLJ07EZntTSIWedb6fV2YBt4UQXksW17lkVHMmbWIguDNVPaa34s9fcyPWl6yP+pp zA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knmxspbtn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 05:37:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3XdLnhrs6tGdLki3Ty+6PHHkR7yS66ko7xJPWbw96dgNkxsyQ8EdecPoiO9xBdUFIWM5FxLF+RaSLsT8jA7daMgiBuwPWlEqnR44BwhVD/Grgu36+njwopn07Qgu34hOsU3jNSYhHBaFEDZgy3N3mktJrPtw4S+Ej8H6zbNl0LEZmLSnGouk+BuUum49zIIM08KBz/ogNOgdlWB+zk1FFVk3L+lyBpNeguzGW19gR3SYvPTGas6lCGy5qkHw01DH6QdMisY/Nh+3BZIE91Kbxa6esd+51l2dM1pcuLaKd9V8BCZyXNEW91zLsvLUJmFeos4esMITOHHvaiCXDbPHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAWz49RpDCUyF90g5bSEFqrjq9EtBf8IXraqzILPpyQ=;
 b=RKvgIU0AMbPk2b/eyf914ThfCTZPNvgpWdW//CaluCjDg4r+DQC3Ia777qMZrALdgpMFLwCOdhsjjxL0hHFxJBCOfryWiTdW28p35tbM0LHm0ss0XJlsqdqJjzgrql8EnyILlOr9RCJqhchZSuxy58CgWoRTpBQTVBs6u9MtFXzg4huz1V2PTQW3Xqtzl4cGzMHVMRMww7K7EcskUFL+gPRe/26veQSp4+PhLzFlu/aCFKI1bB9o/UZmxQ+VyutdG0gXfNQuGga7zSh1W/adE+3MM4tA19RVfoSMrTmWR+BtrYmyVskhSnl9Re0xwPNsgU66E1RQ6Ng1wH0KK08uBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by BN6PR15MB1763.namprd15.prod.outlook.com (2603:10b6:405:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 13:37:14 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::1b85:7a88:90a4:572a%6]) with mapi id 15.20.5791.027; Mon, 7 Nov 2022
 13:37:13 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     Dylan Yudaken <dylany@meta.com>,
        "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing] test that unregister_files processes task work
Thread-Topic: [PATCH liburing] test that unregister_files processes task work
Thread-Index: AQHY8qVpf++NfvlcakSbdYwJSdsSNK4zbYSAgAAJRQA=
Date:   Mon, 7 Nov 2022 13:37:13 +0000
Message-ID: <b0ce80cf1aa966bcdff46fbbc008b97249e25111.camel@fb.com>
References: <20221107123515.4117456-1-dylany@meta.com>
         <e6406e00-6b3f-02a4-7dab-f7e5cd07b82d@gnuweeb.org>
In-Reply-To: <e6406e00-6b3f-02a4-7dab-f7e5cd07b82d@gnuweeb.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|BN6PR15MB1763:EE_
x-ms-office365-filtering-correlation-id: 11149e0e-d391-4f36-30a9-08dac0c52dfd
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 71aMTW2Rn4BFH36dt67PEPOdjWbtvOBBFur2SAR88djYd4Gzh/ncd9veny7pUjwKQvFlQACc3SlFX5eDk7XJLJ3dRU2uXMUF2B2ftNOpD7lQmMw/jW4mbOWGDxoT4b6Qg8QNIlebMHRhYn77jeZY5LEoztl17bssdM5VAuNT8hdW1ugEHxUHTDR45dX0OunLtptJbYj7qLtyttu+pyo/ep2zDA78Yt52WHN/Xki/zwYRRLmLacOQlGXL4vCp0YnS+J/ztEZg3K9PrcEynbTIpcWVviGgchYs4HsCKIREexm//TRY0xDmbgaICK9hY8MFPvbYpBMzOhNxnDiso+kdc0QRjrYXJe8MpEu4tdZaNhLCGdybgHAxnbIG9rnLcLWaUkvSVVEBKkcV0qU9tcBaLABC8SSg2XO0Scz9Uaj2XP41S0qyJW5bJ2uHP8tJQxYbm5Iqk/V6McM7gCRaZMkD9BCbmyS5aA3+NqY8h0kcc+f2pwsKYGBrJFP8xFK89lxd2wcnWxW6XmVNG7dmDRvgb0lLzM5+FRqRIon8BKAUqsvjIzVTQ36+w0VYoeTcn3ntv4zKhIILcPNRvqrV4821ZHvdlslUIe9MSoe9j5XUYAdgbCQhKAx3zBXJGNvOBG4OOUo37P0YEHI4u0GQ06HH7AD3L/Y6XVqtP6lPpsti9ER1fENiYSirAHJerCe8QHmhcKdonZcyQqDZtQOSXvNa2OB+VOUN0R3v1U4BAgS0X9dOKgT7+/OnGLlcwQrG41XTj7SNUGxqlYGoLTV8gK1Uww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(91956017)(8676002)(66476007)(76116006)(4744005)(66946007)(71200400001)(66556008)(66446008)(6486002)(4326008)(54906003)(110136005)(64756008)(316002)(122000001)(2906002)(38100700002)(8936002)(6506007)(5660300002)(186003)(41300700001)(83380400001)(53546011)(9686003)(6512007)(478600001)(86362001)(38070700005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVd6dnZzVnZmNWhDTU5KUElYaTk2S3dLUmRoRlVOQlNOcWc4blBLVWNVaWNa?=
 =?utf-8?B?NFdnWmdqVkl2VkVWNEVFaTQxYU9Yb3FoQ0hGaURla3hnK0F2YU9iZ0tTaDha?=
 =?utf-8?B?UHhZUDE4dnRKVWhxek1xZU45WWJudnBtdFdqTTdxa2s5VzdRR0hpWjZlbVZ2?=
 =?utf-8?B?ZmIzanlaMWh5K0RXNFJIMjdOVGhpUmZraElBbXFTS0RQbll4VzJMemtOUFFm?=
 =?utf-8?B?QWNGK1FFUWs3OWcwWmpqME82a1JXZm94VmcyREp3WjVYUVVwYm0wY3lFNXJl?=
 =?utf-8?B?cFVlcy80YnVpbSs1Skl6RU8wTE1oamtLbUJVNEkvaDV6UWU0ODdORVpVN3o0?=
 =?utf-8?B?bUtHek5GRzVWVG1Qb1ZhQTdyY1FJejBON0xVNk5xb1QyekxhamllU0EzMFh3?=
 =?utf-8?B?QmpmNTJPajBMTzJtME9HdnkrUnZTRGtHV0h6NEJKU0lwVzBodFpESW9RNFly?=
 =?utf-8?B?SFNnckpFcWlQbHd6UHJkRFh5VUhZNFFyOG9pNTRPVkdZdU9LUy91NHNwcStx?=
 =?utf-8?B?Zk1hSWtGaGFTRVdQTWY4bWJNaGJ6dnpEdVIvZ3BNelJwRUYzNEczUkZ5MEpn?=
 =?utf-8?B?SzVZVFliMktYQmVLeGRXd3RYbmdxTzR4Ykk1UlJQbFNhejRUYWVSYWVwekNU?=
 =?utf-8?B?STludVhrVmpRTHgyY0o4WU5PUnFGaWFla3hVUXJ2anVvSjVQTlY0MmFDRTI3?=
 =?utf-8?B?bnJ2dTduR2FOZmc3M3N4TTBsbW5LVFdLVUs5RnFsUit3MElLekp2RDVTd2E2?=
 =?utf-8?B?djJlVlB2M1hBU1ZSNEVIZFVRNnNnQ1JTV2dabVBQV2hSbXJORUt5WkdsMjZP?=
 =?utf-8?B?bjRuUVYvOFgvYkJ6a1krSjJKNHJVN0VybDFuUStHKzVJdmZjUWszNnFwM0Js?=
 =?utf-8?B?L2VHY253cXlUbnpUVDZEdFJBOUpaSk9LS2crYStXVHRnZlloVHpEaDg0Qlhv?=
 =?utf-8?B?Z0FDd095dGhCWWNnVE02VzM3b0hVVkUrL2dDS0cxWStGbXVBLzV5RnNMUEtL?=
 =?utf-8?B?Nzg4NUdRaFlGL1laQ0VtekFBVDZMQktOYnp6aVkvbktEQm51N0JPOTgzZDhJ?=
 =?utf-8?B?bDh4R2hYby9pdW9xMmQ5cWFudVhlUk5qSXZZWTZNdTQwMVc0K3JzaER5dzd3?=
 =?utf-8?B?S3dwdWJVNGVqUnRWdWxHV2dIUmN2YUpwWHJwbnhZU1lVVVplTmlhaXlXbG5n?=
 =?utf-8?B?ckErZUNnL2lnc0Y1RDVBOE9YNUVsMFVFcTVXVEYySVVpQnZlYVNtQzV1WVc0?=
 =?utf-8?B?aktnOE9UbFpLc0tUTVpNRXJtNzRORVNaRFEzQmcyakxlN0ZNdlBqL3IzY3Rl?=
 =?utf-8?B?ZEpPWkZxbCtNK2Z4ZDBzUUVxdFVDYm1kVlpaeE1kbDV1NXVSalBGVDdVdDFS?=
 =?utf-8?B?Tit6REJ3dEVaOVZSTjRicmxlN2lNRytNYThUKzNkSHNKTitwa3FnVlVpSXNN?=
 =?utf-8?B?MEd0dDh1RE5FeUx1cHduOEVsZStFR0xlY0F6M21zQW5SdXRBcWxXVGx2OTgx?=
 =?utf-8?B?K1AvTW1sWFYzb3BoZ1N0aXFCeG11N1EvQzJGY29kbW9CdlUveEYrb1pRcCtl?=
 =?utf-8?B?UUxVajNwL3owN1VBOVlVZVBUdjB0K0pFWHNVb0hUdS9JOWJEekFGSGNyRGlr?=
 =?utf-8?B?UTJFaGZ0a1owV08xT1hqanRzeGVuN2FCc1ZYc0RUVzFkcytGK2JwN0s0TEwy?=
 =?utf-8?B?TFp0VzZGdzlyREIxTVZFVlo5aXFnNUdQdWt2bkxIdW51OEZlL3hjMEJQbGpa?=
 =?utf-8?B?MU81OGdnY1BIYVgzeHhJcGFRK1Q1S3lMNWtJeGptcUFhc1NVOW1ya3pxd3hi?=
 =?utf-8?B?aG5kaUUrdWRuMTNLVi9kNFUzc01ieFBlUWU2UjZLSVVYTTZiWEp2TEFpVUo5?=
 =?utf-8?B?VWxPVjk5THg1Ylptd21IY2dUTTNWOVdPcEtPYWdSQmhCcGdaSjYxYVZRT0kx?=
 =?utf-8?B?SENTdjVMRFFPK2tESllER0dmNnJkQiszdlZZcGFsSENwVHJETFVDRUNyUXd4?=
 =?utf-8?B?M29iV3VJTEhjWndUdE1ybWlaUVNpZ0FsTUt6SERTNGs0dTBiUHk0ZWw0YXVa?=
 =?utf-8?B?ZlBLeFBvQVcyMWg4N3lNVTI1L01QTWViNmNGMnQvMmNudFpJeEVhc1hReHJF?=
 =?utf-8?B?bXBGSUVabDRac01GdGdIRWlVSStybDhUVWUySEh6dXVqWVBJUUYwaG50OTUy?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4363BB0FCDF12143A488CA0E5E4C057D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11149e0e-d391-4f36-30a9-08dac0c52dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 13:37:13.8535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: phRvznw/86q6ebfUyJEAjxOMxJEBVrDQ1kRqisjdtycjvakJmig4apbZw9wWA7Og
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1763
X-Proofpoint-ORIG-GUID: VcFCcv7lzbtfgEC6BlU1pRS14LWjYVTW
X-Proofpoint-GUID: VcFCcv7lzbtfgEC6BlU1pRS14LWjYVTW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_06,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTA3IGF0IDIwOjA0ICswNzAwLCBBbW1hciBGYWl6aSB3cm90ZToKPiBP
biAxMS83LzIyIDc6MzUgUE0sIER5bGFuIFl1ZGFrZW4gd3JvdGU6Cj4gPiArc3RhdGljIGludCB0
ZXN0X2RlZmVyX3Rhc2tydW4odm9pZCkKPiA+ICt7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
aW9fdXJpbmdfc3FlICpzcWU7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW9fdXJpbmcgcmlu
ZzsKPiA+ICvCoMKgwqDCoMKgwqDCoGludCByZXQsIGZkc1syXTsKPiA+ICvCoMKgwqDCoMKgwqDC
oGNoYXIgYnVmZiA9ICd4JzsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoHJldCA9IGlvX3VyaW5n
X3F1ZXVlX2luaXQoOCwgJnJpbmcsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBJT1JJTkdfU0VUVVBfREVGRVJfVEFT
S1JVTiB8Cj4gPiBJT1JJTkdfU0VUVVBfU0lOR0xFX0lTU1VFUik7Cj4gPiArwqDCoMKgwqDCoMKg
wqBpZiAocmV0KQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBUX0VY
SVRfU0tJUDsKPiAKPiBZb3UgcmV0dXJuIFRfRVhJVF9TS0lQIGZyb20gdGVzdF9kZWZlcl90YXNr
cnVuKCkuIEJ1dCB0aGUKPiBjYWxsIHNpdGUgaXM6Cj4gCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAo
dF9wcm9iZV9kZWZlcl90YXNrcnVuKCkpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXQgPSB0ZXN0X2RlZmVyX3Rhc2tydW4oKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBpZiAocmV0KSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGZwcmludGYoc3RkZXJyLCAidGVzdF9kZWZlciBmYWlsZWRcbiIpOwo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
VF9FWElUX0ZBSUw7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gK8Kg
wqDCoMKgwqDCoMKgfQo+IAo+IFRfRVhJVF9TS0lQIGlzIDc3LiBTbyB0aGUgYmxvY2sgaW5zaWRl
IHRoZSAiaWYiIGlzIHRha2VuLgo+IEVuZCByZXN1bHQgeW91IGdldCBUX0VYSVRfRkFJTC4KPiAK
PiBUX0VYSVRfU0tJUCBpbiB5b3VyIGNvZGUgZG9lc24ndCByZWFsbHkgbWVhbiBza2lwLgo+IAoK
QWggeWVzIC0gSSBhZGRlZCB0aGUgcHJvYmUgYW5kIHRoZW4gZm9yZ290IHRvIHRha2Ugb3V0IHRo
ZSBza2lwLgpUaGFua3MgZm9yIHNwb3R0aW5nLgoKRHlsYW4KCg==
