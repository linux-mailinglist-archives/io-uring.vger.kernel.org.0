Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF76E8190
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDSS4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjDSS4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:56:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA8D44A6
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 11:56:43 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JFhCrn002122;
        Wed, 19 Apr 2023 11:56:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=s2048-2021-q4;
 bh=TsFMaHsjs3IvyvnwCdqGyG4KaHZQo9LgD73NY1g+4pI=;
 b=QyjivooOqr3DUqtz8y55GUUuJUrHF9rvzaLZnsPzwSMyYhft0F+B48SSc003i4mW6UKQ
 fNAiPp41X7DeShQ8AoiUMU+VDVBWybGekRj4sbXCYxRcCtdqJdbMT0Hwx5rkKT7MCrqx
 uS9/eyUaKFtJDiLarUbWX4fTVvmVnVGEvCLCXjC+ZDxbrTTI98vzXgEcKPNKhSpYrCdz
 QBqOnEWjCxdLacZIP4wWvBhpnbK3XZpdSDL5gnIu0jlq/y37to5pdAKhz2uHzu3SGDW+
 UNsu0McT0IKnZRFvQzxXCwdmeZlNhcWOQ66ZZ2ABaIKR7cqXwCEZI1SdONeTQtGZlUXt QQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q296ymjst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 11:56:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDmIqRHAm06xcT7hjJ0NsEW0t7ay4tuZq4jzZhZ3d1Kd6t9LJInZzqukSm4IUI8iVoFzO0RseBVwYwAewUEp4R4TibjNBhmVlOsdDmTy1RqkLzz67osNNtGtq1cyH1Mt2G5pOqYtXUoPw1EZGNgAu1ovI2A3+VJF4+nipNi9MrfjD1fvTcY3rTOStOYrKhBUJ0o9Opy2JEx83LDzjEtT3tLXdbJHDt7Zv4u/TL87cZPMFQb6O5MZ2drlMrKnozk1zhErZzvK1khMnDpXmVzRWJh9gQYcY0cJvYu5yTIFOy9m0aNL+RLA5jxau9V4sFg6GfwQ/OmUEE2+0nSs4jCHgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8uELZcm4hUd3GQJn/PBpejfQsItincE0v8Xv4BOjWM=;
 b=eOjEgkmOlOCJH98Y5q/RWyhP1VWYKlsvjJeDu1vWl6gT4nQKyDOIXizi3cyRzMmkMwOueg88Hnzca4V5+ZUNhtPZV1Qr3df+A8YjgpzBZZtmBczOoa1ppEHFAKQp+10B2oAlc3BxPLIOyt9CrbrV9ExYES37H2imicxWA9zDPYt5i83kI1oZPiu3qCwd9HdNAZQxzg28w8Hll0hftAu6Mz5mZ1udz5PoJA1sByx1O7xYtlAQ5DcRVGoD34t32LG46oS2SbveTqoRJXoAsHKn4JzFr4/fxFWeCPq565KkO6GHj10Xgv99uChmY36ISKBcpbJcs98Xr02QkeQv5gdO/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB3098.namprd15.prod.outlook.com (2603:10b6:5:13b::31)
 by PH7PR15MB5668.namprd15.prod.outlook.com (2603:10b6:510:271::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 18:56:40 +0000
Received: from DM6PR15MB3098.namprd15.prod.outlook.com
 ([fe80::ef62:110a:a3be:a01e]) by DM6PR15MB3098.namprd15.prod.outlook.com
 ([fe80::ef62:110a:a3be:a01e%7]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 18:56:39 +0000
Message-ID: <52bb2aa5-162d-75da-fbfb-25fb37d1c473@meta.com>
Date:   Wed, 19 Apr 2023 11:56:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v3 0/2] liburing: multishot timeout support
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20230414225506.4108955-1-davidhwei@meta.com>
 <57046550-32ab-7b37-2ae9-50495061d6d0@kernel.dk>
From:   David Wei <davidhwei@meta.com>
In-Reply-To: <57046550-32ab-7b37-2ae9-50495061d6d0@kernel.dk>
X-ClientProxiedBy: MW4PR03CA0321.namprd03.prod.outlook.com
 (2603:10b6:303:dd::26) To DM6PR15MB3098.namprd15.prod.outlook.com
 (2603:10b6:5:13b::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB3098:EE_|PH7PR15MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: d9614cfc-9fd0-4019-ec18-08db4107cee1
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbWp9RYue7civrLTG3ttf8xxQ69Wm7HZ3DTwG0+h1w/qyqnj00X+Rj6o1QJdT2JyRkab2RHeZkQ/nm6LZAlWQM9pOlAYRgr0odF4ApvHNGYuH/fZFWe16bLzVQ4yCtL3kIctPITo9gWdKUoeuCGDghkYDhs7dgL1DZcdE4V8Zy5k1wmmyVPFBI4gYil54Ec3iit0rNbTf7/wSjIw+LWunQJj6BKVp+Cc3I9W4CaTaTJnTffYb001rbzf+TH9s2mlJxwqzqA+EM7cv6ZS0SOz4CDQMG09Yzo5x0vIPdvNAQqjIZDGl7Ak0UJE/IXMD1xhYTBXAc4+kXVe6QzSdJf+940VLDHDZCLIjFbK2MZkVitRBt1u6/Sqmn4NeZW4HJqt5pzIgK0iVqlBEZkaRqRylALtG7O3gZn2NyqazW1nc3OSCPoLunSKeJHs2AFWEayeVVOXCdir2fauQ8PLuAVQcbSDziW1HhOe/3zCQRB6ir0McbLEWOXr8jSoIiDUuc6TU13ZWx2Pt3vkwxUm9U+fHsgJXVBW0LCM3swJ8zzGyL4lLYoR6BObX4BF6KZUJrTGPJj9o7zwj6k/QRKwgSFW6yaDvP5qyAOJ+3c35Carod6siSDNDMlEDJp03CFM4Qhz3xtZnb2yPFiW6IsAk9M+wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3098.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199021)(36756003)(186003)(4326008)(110136005)(316002)(66556008)(66946007)(66476007)(6486002)(478600001)(6666004)(8936002)(8676002)(5660300002)(41300700001)(2906002)(86362001)(38100700002)(2616005)(26005)(6512007)(53546011)(6506007)(83380400001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFhjc2taZnZtT05WOTBhbHcrRVIwMTZjVENjeHFuOXZhb1E5Nk41SnM4SS9k?=
 =?utf-8?B?cXNwaWthZ053Y3NXNmh5aG9zU0dSa1IrTSthSGcyd1J1MHQzUm9CaXhJaEJk?=
 =?utf-8?B?b1FTRGZnMjJTcVZLT2hNMW55WXBob2RqM3VON1prdDgwYXZ1NVo5eERvZS9y?=
 =?utf-8?B?dURoVFJObUViNm9WMjlNQlB1RGR5MG5iZk9VWktGNjB2VkJmaks5TG9TTHVl?=
 =?utf-8?B?cHJ0T0szTmRqWmtEM3BlY04wQUx5cEhFZGNtdG5SeGlNdnB6bDVweDMwS2JE?=
 =?utf-8?B?THRYaWY1Q1FQaW9xRW5FMmN2aTdleEZWclNobmMydkF5dm1zNDJXNGRDTTZZ?=
 =?utf-8?B?STVnSUdjQkZtU0JJSTVvUEFIelJaa25oLzhCbkk0OTc5U1dmaU5pNXRZdnZ2?=
 =?utf-8?B?TE02M0gzb050TkJiOHpWWlhaMmwzNXFrckVVdkgrYWN5Z2FDcU5pdmdRSDla?=
 =?utf-8?B?ajRMOWdjNEliY1drUGdUNjZsN1cxTnVDZzhYUXFFZ2xOd3h5SXFhTEJSS1hk?=
 =?utf-8?B?QTdYMUxLcS96QXlBNVhiTDlLZ1A1ZmpHV1BNSXRpWjRPNC83MUM1T1VRTzVx?=
 =?utf-8?B?dHBBUHZ1VUxXS1ZqYS83aGUrN1dFMDVSNitETDNnTk9vZ0FQQTBXZlhvVWYw?=
 =?utf-8?B?ck00ellDdU9FaDYwVXVMbTFudGhqYy9LOUJUU3JVbkoySklGbU9ya3Zoek1Y?=
 =?utf-8?B?WDk2bEsxVzdJWEZrNmUwY1BqY2hmR0VQMlNPVHIyRlhjMTQ4MHY1dnZNcy8y?=
 =?utf-8?B?eDhjUi84cWRNSEhMemRWSWkxVFR1NFkvS0dDakdGSk5uQU5HdHduMWRBNXVi?=
 =?utf-8?B?ci8rSVB3NXF1L0hVQm5wTld1U01YTlRHZGMyTS9aNlFOekdnaVo3bTJLTzZo?=
 =?utf-8?B?QmtSMTd6UFJkUGVXaXd0bW1hNXVuYk1QS0xHN3BPdjM4NXZPTDN1bVFleG4y?=
 =?utf-8?B?aTkxVXg5M2FVbTZPSThoZXRXeHFUVmEyTHRsdFgvRGZ2Tk42ckd1UUxMcFpI?=
 =?utf-8?B?UmtNN0JQbStxWkNyMEE4YmxFUlcrK09uQ2NOc0w2UEtTMyt3ZFNKblB2b0s3?=
 =?utf-8?B?YTYzdlZ2elVqQm5YbVpIMHg4Nkt0YjRTcjJXbE1XcFMvaTI1eS9OS1pqblFX?=
 =?utf-8?B?SkFBRUtkMHZpdnF0U01MZUtVYzl0dUVRaDc3MEFqUnhPNWh0OGFRVW04blJO?=
 =?utf-8?B?MDdzdlJRbzBXUGlHQXQ0WVRZdHVUbm13VlF3VVViT25hcUV0Q1Vaekc2MU1Y?=
 =?utf-8?B?TkZiTjk1UTNNanh2cWRSYmloWllxZDlyV3FaaHlBUUpHUDBEZFN1ZkNKZzcx?=
 =?utf-8?B?RkVxWk1zYzc2VmZGd3Ivek9laG9Sc0EyM2s0U0tyWFZnUjdNWFo4Rk5KTTA0?=
 =?utf-8?B?QkNLMldCNlVkc2MvZm8yWEN4SmRnaStnbllOWGFIdE80c2tTNlR4TE8xdVBy?=
 =?utf-8?B?YWhyMGNsdDZXODBpNDZONzJRcXhnU0F2UHdXUVkvak1nLzhMUmNQb3F5cG1l?=
 =?utf-8?B?TXhma2pGWmRzVFAxZVR2TXNEYUdzcHJ4WitQcFJjRWNUb3R5b1gzc1FlaGIz?=
 =?utf-8?B?RFQ4bVl2dWlQSHI4M2tQRUJuQVkrM3hEdWVKV1FWclZWWDF4WllaUml4UlF1?=
 =?utf-8?B?TmY2U2E1YUZGenI4d0JFU2lLbXJQMEVYN1FtWVY2QjgySW8vbjNjYjVobWV0?=
 =?utf-8?B?MWo0ODdVMlZsNmFSdDRlOTlXRWtmTk9kR0pEWGtwQmxwWm5ObnlQdTFwSWVt?=
 =?utf-8?B?STQvMkNhZ1NaU3BOQlRJb2U0SmMxVTRSd3JkaDlOOHdsejQ4YjlOaEdIR2J3?=
 =?utf-8?B?N3BmeVdaU0NGRm9KNFRjbWtYYTl6RGwxSEJuak9WOCswRU1Td0NudnJTZ3d4?=
 =?utf-8?B?VFhaNVpWOHpMWS9SaVh0MERsMng1TmdZdGgrOHVMdVdBVXFYa1BIUFZWdmk0?=
 =?utf-8?B?RGNCeUpmNUI0cFRUQVBPdXk3amN0bCtZNlZqQUpnbE1IVW92QmtRUWZuMTR2?=
 =?utf-8?B?elcrSVp4ejZaWk5BaTY0SGI3ZkpYU3dLMVBpRloraG4xZXVFdWJMazJ1Sm0x?=
 =?utf-8?B?M3RRMktQdHVvZXI3MTlmT3A5V29Iek1KQytNbks0dFc0dzNsK25LS3JQWUxi?=
 =?utf-8?Q?EHi9BXVI2SL0qjaJ7qcDb8fLR?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9614cfc-9fd0-4019-ec18-08db4107cee1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3098.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 18:56:39.6112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IE3xB4CIeKf1PwxmkHO6Rav7EdgbfDwtysuGghz5LRcRi+R99XpRK0r4iCDzuSHYwEchZLpOO84TEB62AHHbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5668
X-Proofpoint-GUID: bDEDEtbcyr2Hw6B2rhpdptkB_S5jsX6P
X-Proofpoint-ORIG-GUID: bDEDEtbcyr2Hw6B2rhpdptkB_S5jsX6P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_13,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 18/04/2023 18:43, Jens Axboe wrote:
> >=20
> On 4/14/23 4:55?PM, David Wei wrote:
>> Changes on the liburing side to support multishot timeouts.
>>
>> Changes since v2:
>>
>> * Edited man page for io_uring_prep_timeout.3
>>
>> David Wei (2):
>>   liburing: add multishot timeout support
>>   liburing: update man page for multishot timeouts
>>
>>  man/io_uring_prep_timeout.3     |   7 +
>>  src/include/liburing/io_uring.h |   1 +
>>  test/timeout.c                  | 263 ++++++++++++++++++++++++++++++++
>>  3 files changed, 271 insertions(+)
>=20
> I applied this, but there's an issue in that the tests don't just skip
> if the kernel doesn't support multishot. Tests for liburing need to
> accept that the feature isn't available on older kernels. Generally this
> is done by the first test setting 'no_timeout_mshot =3D true' or something
> like that, and then subsequent ones just returning T_SETUP_SKIP if
> no_timeout_mshot =3D=3D true and whatever calls the test not failing if
> T_SETUP_SKIP is returned.
>=20
> Would be great if you could send a followup patch against the current
> liburing -git that does that. Thanks!

Ah I didn't realise, thanks. Will do this and submit a new version.
