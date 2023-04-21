Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544D16EB472
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 00:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjDUWJk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 18:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDUWJj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 18:09:39 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE601726
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 15:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZqrd2Mnoqw61bDJjbJp+JeZtR434J5n9ZqxxnAWAL//aS7l5RVxjEsZN/yNRjlOkKwvGesvHpJgiLPmOv3zG+KURS1nUZlTaTA6NNgy+3v+KwyGHDdCDl0+EvQwd7Mkt2j655PuLNiaXLsnCOhiEWi7Eta/cjBKOoh3SBgYhcIi03YLw50BIdiqeDRDmVsJK61bNK8iymHit3P2MtRnvwy6Pxt0BgXRq1xx6RiPGuDQl/8kALA0ydL3oJ5uNDds2GGgHLKpTn8OgF18/hruacUsb4NBfHvYBuTZMP9ce2LaFOGGTT+E5Mndov0ULRuS1WaYxNQoBFVZqX7xau7w7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FT5E45HtQ5fYy8XiCbEzoBVnuKQTrtG9xz3ioYODjB4=;
 b=RoGO/4SgNmS2mcsbSsTwVsXSS9uFbZMnoQVaGYhpQh5xiLmSkpo0sdN2vCnu6X8UX0siu0fpwwqECCWWmLCwO/mDgC+UeMbDqxBCKptmlCRXcXwEpMp+50pNfLByMVCddhJ0MuRWFZEDHfsFZDyVRAWEQf33e0NW76VAEfFCykxfNnNug+K4zelPoA42wh3z02FbmHDpheg2D6tMwk5VZU46cfWlFoavimJe3lVwDnQ+b5cqiU7ReCWRGaf605BAnu8sm4AZ9tnQxyBVlnioxIuc1Z7V8kIN98aqcMnapAFnnofvt5x3rqfxq6nCvQZmPp0B8f1d6Byjhy+2MwHozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FT5E45HtQ5fYy8XiCbEzoBVnuKQTrtG9xz3ioYODjB4=;
 b=xmvFEqyhAB3YqCpGdgN0hFzg3BRPYmBvkLa7JkHzbHGFam3vqUmfku6rOUpMOtp+H04eP+pwi7DnGqZjxWCJ8gvI5rSJRqxLjB3qNgFWNUkH8E7Mhhm2LAP5mKSJ0iWr9Sk2qkOQOKPgfGGiHfh72gTqdK0qn704Ao60mZ2nmP8=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by DS7PR19MB5904.namprd19.prod.outlook.com (2603:10b6:8:7f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Fri, 21 Apr
 2023 22:09:36 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 22:09:36 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: SQPOLL / uring_cmd_iopoll
Thread-Topic: SQPOLL / uring_cmd_iopoll
Thread-Index: AQHZdJ31wZsZ1L2NcUyTVFglsdUPqA==
Date:   Fri, 21 Apr 2023 22:09:36 +0000
Message-ID: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|DS7PR19MB5904:EE_
x-ms-office365-filtering-correlation-id: bbeb1828-5478-4e44-d64d-08db42b517e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ICQL580k9OguEbvFUVnOBA3xnHAlNcIix6iXB8wKgr/lvvqMAZAWUn9cKqglV+RCNLbC5OPTmHR+20DEDjePiWBBNLTAUYWdkUzwp0mn2DjsPtI7ZhBrVdwYgkIcBOU/ne0u0Lj0VCOx4mTtoXria+EMrqcE9XGVXbzMWqKY6JE1SQPlR8YL0OqCMdLiWBdetv6pRse16VceYi/fYHqNocWOzkPfn2U/wKZLqQ36QDtHhvO9sK1k6jkLJDNVLqUI/TfTweUh1tj0b5LcpMLCB9hVRbxfw8XZOQpqAhQOts1zSlAimVxKTO6AAvtscjBFjHv5KSwxLTyh6kB5XmK8Dfi0+s3Bvx7YDyho3ZEWOl5xG0mFvvD+tQuazFfiPUpnIRLUkXYtkcNbPJvXPvYJ+NzgysBhAbCS2ZcPl/ePPxdZlNXVpNpC9Sbs9t6SzWQTtfK/Ub1NmQPwCzWakjJ58oNXpOzsEFeSfmE8+SpjEsHAxEPhxKmPSYurKAi9UUfC0X2Kt80vB4ueqhYZ4o/261Q5zNkEo2/mZTijf9yQkpJbi23zNAEI+poLWJiN43VuMr1iBMMqXCmz5OlghcmCx6yrSGb+a3cOideORNBKPTn5AoZ8NrNGZF/LRzK8nGYpdHZdq7F2o6TutsGYMyt02dfvjQXSCymh6NFhvd+FVFBmwDvqQZed5TBI+K9CG7CN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39850400004)(136003)(451199021)(31686004)(6506007)(122000001)(31696002)(38070700005)(38100700002)(86362001)(8936002)(6512007)(5660300002)(66556008)(478600001)(41300700001)(316002)(2906002)(76116006)(186003)(66446008)(36756003)(6916009)(66476007)(64756008)(54906003)(8676002)(71200400001)(4326008)(2616005)(83380400001)(66946007)(91956017)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akFDMFdGdGlrQkRzMmtQWWFtRnIyZkRISnh0Mk5lQ2JTNG9zZHBuVnRvVHFu?=
 =?utf-8?B?d0Z4RlQyMXZLQ1FJZVF4eW5MQkhqTFFoNmlWanUzMFBnTzQzeHJ4bmFSNGc4?=
 =?utf-8?B?WEQxdjJtYVlHS1dONlM1S3ZpVlMvbDB3OXp5dElGRHBGcHZOZGlUZ3AvNlA3?=
 =?utf-8?B?UGI3ZzVOUUVaR21TU2NDNENJbmZaY1BSYUFtNHI0dExlMVhodXMxWHF6aHlB?=
 =?utf-8?B?MmdqdTNVMU53enJBRjFrQ0hHTkt1QWdsLy9SWjhvWTArZmw1R2JDUVYwZXdE?=
 =?utf-8?B?Um5mL1RKWVRTZktVYUdzdnpoNVhlQUlldzMrZXRBdDRHSnhIWU1JVFgxVm9z?=
 =?utf-8?B?aVVHUEgwZzBNV1JzK1FlVVpqMkF0ZGxoVXFveUQ3WnZNRG90M2xjRkRYTS9I?=
 =?utf-8?B?aUJ3V29HczFjWXlYeWpINzAyY0NGaVEyTU1tSzkwdnd4dlhhdDFPZ1M3TXZQ?=
 =?utf-8?B?blhVM3RhZE1DSDA2TDgvY0NnL2JSTEhTcjRBZWJaUytseWtIYmN3OHVWNFV1?=
 =?utf-8?B?Q0kxa0JhM29CcmxRaTFrUiswYTdkNXpBVGwvMDJLUmVVUExHbXI4emg5YThN?=
 =?utf-8?B?L1NmbDdqWFg0di9CZ2p1RElwYStwR3dyYTVHY3JFWXdHVGxUOGpYcW5WQVNj?=
 =?utf-8?B?MjFlUFFDUUt0bTU2RnowRHVjL25FM0pJRC90aDNUL0xjc0VBZTNKQVpvVGxF?=
 =?utf-8?B?MmpONzh2eFZLQXhUWlFLNzhhcDRHN0pNd0RYLzI1c29QV1dPSUw3a01UZjlp?=
 =?utf-8?B?dDZ4L0g2eFhtSVpqeGwrZXM0RFViT1BaRm1rdnZBaDZ5RWcwZnpvWTJwUTRQ?=
 =?utf-8?B?cDdFdnQrOTN6RThCOXhRWVgrbEl4V2FrTExtYmUwSWNuZjBrQ2c1NkdNZ3Mv?=
 =?utf-8?B?Z2xhT3BnMnI4Vm83OW5vZlBEVVdDWjh6bTlHaXFTVXloTG04V3VxSjgvdG1K?=
 =?utf-8?B?QUgyMXFrWldUVnJBRW90OXFFcGt4NE4ycnJuK3hDamo1SGRZYnhzMTFlOWJl?=
 =?utf-8?B?Z3pjVnFGMWZMeUJudHYzRlAvRmRuUHFvR284U054ZDVqSTcxUVd6eWFtMld2?=
 =?utf-8?B?d0FNKzZ5alVzQU43ZzVld1o5VmkveFVIOWdkeXpKLytvUWhkM0t3UjlEWGxX?=
 =?utf-8?B?YzRmQ0UwdGJsVUVnMmIvMWFrcFpDZk9hdEFpS2NHc3RnN0QxdVcxa3luOThu?=
 =?utf-8?B?c2NDejBZR29LNHhSTDFmaW5BWExNM1VIREJTbnkrTkNaM3VqM2liV3pZazNN?=
 =?utf-8?B?d0piMHQrS2t4NVZmdk1WNC9PcW8yckdlRGhtL01LVm54bFpMUjhtdThqd1E0?=
 =?utf-8?B?SWFja1JGdk83NU91ZTZ4NzBkRkhuMkxvM2x1RVh4bXkrRHA1Y3hlZlRZU0Zt?=
 =?utf-8?B?WVo4VjQ4VXdyRHNPdURlOWZnUkVhSWNNalRTOU45cER4UC83b1A0K1d2Z0sz?=
 =?utf-8?B?ZFFQQlF1RDF3TlVKVkxrb2djQTBmQzdiSlR1c085SUdtRFNVa3FLVjZkUW55?=
 =?utf-8?B?YWt2cnp1MTdqc1NpY0lHM0c4am5jeldJTmNlWnB2TmZmTzZHVUpudWFWQW9M?=
 =?utf-8?B?TVRHN1A1YWszQ2p2d0Y3SWg5VTVZN2xuK0YxZE9QRFRjRzFybjJJNEpqblc3?=
 =?utf-8?B?T1Bhamtoa0trdTMwSHQ3V1dPNWI2di9sMmJtczhOUEtMZ1dVVTYrUHpPalMw?=
 =?utf-8?B?UVNIbTR6RXZRQURkZ2FubksySW4rWk9Pc1JGVFo3cWUzWE5EN0M1SUE2QmF6?=
 =?utf-8?B?bjBpcmxndmdQNnRrSXV1azlPaDYrNUNJeTFISUxuVTZ6SGl5TWRQdURXayt1?=
 =?utf-8?B?K0l4UVl0M250UHZhQjJiakxRNWFjS0ZRczcrM1hZRkFEaWxSUUJJVElFb21N?=
 =?utf-8?B?MzAyMkxUNHl1enc4UFl4ZWIwbmVjVEcvTjVsUHFmSnBtUGYzeU9DcHlQdnlm?=
 =?utf-8?B?R28wSEplL2pZWmJsSGVZWmJURjdVNU1tYnJTV2F5SG51SDltU0FUWjM0dW16?=
 =?utf-8?B?SUJEaUxNb01Tc0NTSXBDa1RuN3I1KzhZK3B5a3A5enFYQ1YzVmh5Vm1NcS9P?=
 =?utf-8?B?d1UraEZSa0VnZEJGdjJXeDlSWGxsRkl5WlFpaEZDaExEWDU4RDNnS1pXZWJk?=
 =?utf-8?B?MWNMNnZWZks0ZVowNDdDY0d5MDJVby9iM0k0YkNoTHRidmN5Q3Q5Tmo1SzYy?=
 =?utf-8?Q?1yAlOCTFaLYFKC6N60SZFKU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18B61D3F5629EC4CBA957CC4E4004B31@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbeb1828-5478-4e44-d64d-08db42b517e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 22:09:36.0459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqPreZUOc7xGm0oig92GjtDII2WT8RCXhVXVde9sLTzEZy67v69iOhrvaTC0x9X7A/RorJ4wQlkecbQaw3Virg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB5904
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SGVsbG8sDQoNCkkgd2FzIHdvbmRlcmluZyBpZiBJIGNvdWxkIHNldCB1cCBTUVBPTEwgZm9yIGZ1
c2UvSU9SSU5HX09QX1VSSU5HX0NNRCANCmFuZCB3aGF0IHdvdWxkIGJlIHRoZSBsYXRlbmN5IHdp
bi4gTm93IEkgZ2V0IGEgYml0IGNvbmZ1c2VkIHdoYXQgdGhlIA0KZl9vcC0+dXJpbmdfY21kX2lv
cG9sbCgpIGZ1bmN0aW9uIGlzIHN1cHBvc2VkIHRvIGRvLg0KDQpJcyBpdCBqdXN0IHRoZXJlIHRv
IGNoZWNrIGlmIFNRRXMgYXJlIGNhbiBiZSBjb21wbGV0ZWQgYXMgQ1FFPyBJbiBydy5jIA0KaW9f
ZG9faW9wb2xsKCkgaXQgbG9va3MgbGlrZSB0aGlzLiBJIGRvbid0IGZvbGxvdyBhbGwgY29kZSBw
YXRocyBpbiANCl9faW9fc3FfdGhyZWFkIHlldCwgYnV0IGl0IGxvb2tzIGEgbGlrZSBpdCBhbHJl
YWR5IGNoZWNrcyBpZiB0aGUgcmluZyANCmhhcyBuZXcgZW50cmllcw0KDQp0b19zdWJtaXQgPSBp
b19zcXJpbmdfZW50cmllcyhjdHgpOw0KLi4uDQpyZXQgPSBpb19zdWJtaXRfc3FlcyhjdHgsIHRv
X3N1Ym1pdCk7DQoNCiAgIC0tPiBpdCB3aWxsIGV2ZW50dWFsbHkgY2FsbCBpbnRvIC0+dXJpbmdf
Y21kKCkgPw0KDQpBbmQgdGhlbiBpb19kb19pb3BvbGwgLT4gIGZpbGUtPmZfb3AtPnVyaW5nX2Nt
ZF9pb3BvbGwgaXMgc3VwcG9zZWQgdG8gDQpjaGVjayBmb3IgYXZhaWxhYmxlIGNxIGVudHJpZXMg
YW5kIHdpbGwgc3VibWl0IHRoZXNlPyBJLmUuIEkganVzdCByZXR1cm4gDQoxIGlmIHdoZW4gdGhl
IHJlcXVlc3QgaXMgcmVhZHk/IEFuZCBhbHNvIGVuc3VyZSB0aGF0IA0KcmVxLT5pb3BvbGxfY29t
cGxldGVkIGlzIHNldD8NCg0KDQpJJ20gYWxzbyBub3Qgc3VyZSB3aGF0IEkgc2hvdWxkIGRvIHdp
dGggc3RydWN0IGlvX2NvbXBfYmF0Y2ggKiAtIEkgZG9uJ3QgDQpoYXZlIHN0cnVjdCByZXF1ZXN0
ICpyZXFfbGlzdCBhbnl3aGVyZSBpbiBteSBmdXNlLXVyaW5nIGNoYW5nZXMsIHNlZW1zIA0KdG8g
YmUgYmxrLW1xIHNwZWNpZmljPyBTbyBJIHNob3VsZCBqdXN0IGlnbm9yZSB0aGF0IHBhcmFtZXRl
cj8NCg0KDQpCdHcsIHRoaXMgbWlnaHQgYmUgdXNlZnVsIGZvciB1YmxrIGFzIHdlbGw/DQoNClRo
YW5rcywNCkJlcm5kDQoNCg0K
