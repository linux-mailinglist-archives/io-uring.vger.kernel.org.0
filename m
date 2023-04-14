Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6F26E2920
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjDNRRO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 13:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjDNRRM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 13:17:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A89759C5
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 10:17:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EGeTXG029501;
        Fri, 14 Apr 2023 10:17:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=s2048-2021-q4;
 bh=J/AGGravezRezpN2VjcBedyN1iantN07ATOr+A/m2Xk=;
 b=RuxogOmsq4qh4UT3eYjCszSLC7qNRO8CgrHsudLmexyaMOnUxMUyT7C3djHw2yAtXShf
 A+llCzxc52gwg4yb09sf77q0UEZy0RYzWsJbU7nOjzIS0nxpDSmG5/D3QKKvnupQoVMh
 oFrP0Oifsdt7Nmn9KL3aVxm8oIXx6dfsE5MsnyhcDdhqsBteOIMW7qMgoOvbDsGdEpWE
 KbwWjYQZLRU0W7ERMU5GVaX11IKGYaUMAcqkmPLUmjMmjoPKQRA+qJiUZCAuJqf8kI0V
 66JOtRs8K9bZ1HLGOAClzxp8XNga0Kk8XYRCE04Cr5hACtliQvSE2LG2taMGr4E9WlcB Sw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pxx8ac5nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:17:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iI6eomBmx9oKPo2tUmpeEBzhi0ch09cI4b708xekvfu4P1+N7joKWv8nuPEzrXPErr4gxNIia5E0nrwE0ntV1RxqeKHEM/Psl7GgZtBJUH5yiIeqTc1MM0qfCAoi3AYLpwfic3CrpHMaogyMoO2X/L4CQ/yAur8qy1oI3YkYBv7asqwl/qKnUGBl/1d7BDVH6OxTRn6QoB1XBTmEEBpFCKIuX4NdzmQ0u5MK/7cNc3QLAOee1pMcdOXZYL1nI/CpyCw4TckW1bgYCRx5QJYIsCPJRkGhBpTiAGUc/ptHmHTVVeCwvqN/hWj5WpaWiYD7FAxyWPdD4zUCr7I8DMGbgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNANK44QSPHl3NJJr7dcedcmVwbT6UCzMCBYPaopG3E=;
 b=W+4j4q0vUa+GYprWkkIgNwf5WQKVLdW5BrWValBn94JQLH7x5jxYzLRDeSLGeLlzkBjCBoYwGDwW842NpnBaBZoocF7SQGtwsmZ0dRaS46XppIeXC5oplzCMlPBqIX79K0sSMN0D0x/SAvi0G26KbZUxUfHtXAYieOd3FWQfuZ0QTxZt7JuWtYeRsve0v5z8K2gDjAhnspV7qyuudCzdvmeS3CzPF9+l9+VhZEfGxqd4OiAN8DOrBAHv7ro+rUmLdXkZJx2iSqMijmKcvoeUBQLGoC0Tf+6OsJuxNh7xsOuSOQw8Ole/CNLjUoywJUKYD15I30datQwSLM90+8Y2Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB3098.namprd15.prod.outlook.com (2603:10b6:5:13b::31)
 by DS0PR15MB6278.namprd15.prod.outlook.com (2603:10b6:8:168::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.47; Fri, 14 Apr
 2023 17:17:06 +0000
Received: from DM6PR15MB3098.namprd15.prod.outlook.com
 ([fe80::ef62:110a:a3be:a01e]) by DM6PR15MB3098.namprd15.prod.outlook.com
 ([fe80::ef62:110a:a3be:a01e%6]) with mapi id 15.20.6277.038; Fri, 14 Apr 2023
 17:17:06 +0000
Message-ID: <41f1f52a-6ec0-35ec-21fc-f424ce7c3215@meta.com>
Date:   Fri, 14 Apr 2023 10:17:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2] io_uring: add support for multishot timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20230412222732.1623901-1-davidhwei@meta.com>
 <29f2da64-1dd7-0ed0-16a6-f8295de05a88@gmail.com>
From:   David Wei <davidhwei@meta.com>
In-Reply-To: <29f2da64-1dd7-0ed0-16a6-f8295de05a88@gmail.com>
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To DM6PR15MB3098.namprd15.prod.outlook.com
 (2603:10b6:5:13b::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB3098:EE_|DS0PR15MB6278:EE_
X-MS-Office365-Filtering-Correlation-Id: b56ccdd1-e75d-4522-fe27-08db3d0c1247
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LS9b1EGxHdpJprm5Usz56fEfCmouX5zdiZs6AUlfK4xVsTqo9Xl33q4DEB5dYpzAPJ4PvzuABJz7QSuJiDF9crV8Xn83W/gnqbkHkS0EYhjXM2jlwowiTOjd4+B84/v/jhlx6qZ5WH9SWGE2oDqgQvZzSRhNV9lWDfH3CDTblPQYQdvEIYuwl1Ng2BauFLSyc1apiZGQWhA05nRhXCxbWj9RK3Mw1sTDT4yWAjtfqwDKaz/GJ6FgBsvWa7BJE49JVTMnhN/iPhqupThiDV96qH5WKdZZ3UamJO6G0ZZuYR9a7lk5C7CbroBvyQfLWQ+2Oal+B1ii39rK1ioHwYOQg+ta4Lo8EaAiC52sepOJ7YU6yy1ZlEDq9AeZc1z9FVhyQsHyUjxtGcHJLb8DWX6Xpysto60KCYKJthPaJjTIEhh+9Np8nZGADPugO216IyE0q6FCaF9v18q02RXytXAcf4RaB0qP93o/o+KP9hOOFskgdmWxQyVKVBo62fP/HT58VFsH9eVUJ2iN4J9BxubdybZLJgynyDSivli9VOzh3cILNrlRtukb5lYRyGp22Yj5cs/3bsHMquvC8O9Wic/hbmgUw73VoYcKBMBfQ8F7t+toyh/IaihI4CsmViuqHy3uPI/8Kas1kzH2Xa40Vqz78w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3098.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199021)(41300700001)(316002)(66556008)(66946007)(66476007)(4326008)(2906002)(38100700002)(8676002)(8936002)(5660300002)(6506007)(6512007)(53546011)(186003)(6486002)(86362001)(31696002)(2616005)(83380400001)(36756003)(31686004)(478600001)(6666004)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDVsVWlLRDUyZ2hiZ0pZWUZmOHpqQ3hnZVZGakpxMjZoRm1DOVBsSy9CSVhG?=
 =?utf-8?B?S2ZDQW1GS1haSzV4aWJDbCt4aUdHTW5mVHVXNW1Db3FOM1dWWHd3SUlVSy9o?=
 =?utf-8?B?bGZsdkRmVWMyak9MS3NZdktlTzU3amNiZE5XUzB1Y1I0ekU0UFRxekgyVnFy?=
 =?utf-8?B?aHBNczJFMTNLR3hmMkVrVkN1dXp2eGorbytuMVpaMy8wQi94WkZMUUlTTndw?=
 =?utf-8?B?Q3NHNXRFM01PdXRtZ2pDaXlUc2hmOXJuVi8yYlJzaVFiNXNyY2hwaWxYb0Ju?=
 =?utf-8?B?TU1PSkd1aUxiSlJyTjdud2R6V1pTOW9GbkdxZEFGUjRob3RuZjhwcmYwYXVK?=
 =?utf-8?B?TWxQTWFwRkd1NGlUZ2RKRjF6aGJ5ZWRBZXVXb2lTVzJhd0xsdHlYbHp3Nkcv?=
 =?utf-8?B?TDBGZitwYlg3TE5tRHpYeHNKVHZHV04weE05WUhxUE50MlR5ZllyNTVOVUVC?=
 =?utf-8?B?Y1dQbU9QN3dZYlFMU2k3Ym9uLytvTXpPdzVrQ2paYUJUSnpyMGQ4VGgvWmJH?=
 =?utf-8?B?OEExOUtYbWlNTlIwRjhPSWpLTk8wRlU3aDFIUjRQUGR4RWNaUHAxL3M5VWZs?=
 =?utf-8?B?cWRWT3dPM1pRaW5YZnpsQ2U3SWNwUDk1azF1VUFtb1lNWTgzdDl2NEZVTEVS?=
 =?utf-8?B?aEdQSDJ6WVVaSFo0SHNZTnlHSDRvNjR5WStaa2pZb3ZpUmU0RWhvMDZPR3Mr?=
 =?utf-8?B?eHZiTnhFaStnalRRc1ZaM0E2RmlXWWxvSEVteDZwR052dVQ3SEJGQXRXQmRL?=
 =?utf-8?B?YkoweU5UYkhTYk1UV0U3WklMQ1hqdHVDaUFrandaV1BiZklNSzVLYjk0TjRm?=
 =?utf-8?B?dzdOVHpoUWFIZThLdzJqYzE5K3d1TUF3ZkxSWm1xU3l5TXBPMmJ5aStTRWda?=
 =?utf-8?B?ZGJhSVFqR1B0aWNiOXl6VUtMSTZhd2dnNWpZbHJHMlRIRUpTTkU2RVIwUnZX?=
 =?utf-8?B?WmdzTU5TK1dDUE0weSt6dmFrRlRsVkN1N1E5Rk9nUGM3UnBKMG1RQXlCVms4?=
 =?utf-8?B?a3o5Q2p4bjFzSitIT3BtNFVpeStKeFh6d2x6emRHckZGUGd0WHk2ZzRkazls?=
 =?utf-8?B?VXJLTVVnZGlNMVoraTJ1Z3ZBNzg0OVA1a0RhMWpjajZZSUYxd1ZGMDljNG1L?=
 =?utf-8?B?TldnaUQ1L1BlaUlQSHJwclBrczNiNEtHSUEyNjdhWjJVQmNYWXAxQklueUFX?=
 =?utf-8?B?TEtZdGxzSlZkTDJmQVUvMGdqenFBTnltS0RreURueHhJZ2FEaGpuRDlzYjh1?=
 =?utf-8?B?V3IzRVVYK0J2L2dKSzZGODJHbUVJcVFZMXgvQXVWdmVXZnlPd0hIQm9ZQWhS?=
 =?utf-8?B?TzdXSWdCR1dtajdHaUlBQjNPMjR2R1ZEVDR4TFhiUEdpQ2UzVjZMWWRZYVB3?=
 =?utf-8?B?d1VHTVZFZk9oN2pTanV1RVIwY043QmFTN2pCbnVRcXFPZTNiNm4xMmUxbThj?=
 =?utf-8?B?U0liUjEvT3MrTU1nTTJmZ0JUNUplN09FRUpoTVp4ZkhjUCtMKzF5b3Qzd2Jx?=
 =?utf-8?B?cnA3c1lrd0ZwTFJXa05LTVFEaGpiVk1kdkZLcFU3ZDZ0UU81ZUdIOUI2MmpW?=
 =?utf-8?B?TEcwYnlJZTVITnQvRFJpcC9YK3pCMVhQdE1KeWtnYVRES3N0YzdicDhweFpq?=
 =?utf-8?B?dGdzSFdvNzZNMU1BWEg3SzNOejA1dm5TVWc0dmVQRGxsNUVQSUM4Tmc0SThL?=
 =?utf-8?B?WWluRkFSYkM3VnZhZXZJS1A5bHV1eU5BSS9wTC9MdTBKeVBVM3FjNHhxbW1D?=
 =?utf-8?B?UjMyN2VxcFJGZkNzQTF0YVZoOTFVMS9ZQUliWCtaeS9aWm9pU1FjdWpFU1lv?=
 =?utf-8?B?SHJsL3pxbFdONGpZTGhSYVkzWkl6ODltWEtDdW83S1d3TFZkTHlMdVdDcElK?=
 =?utf-8?B?aHB4SkI4bGNqUWpYTnE2M25tMWFSUzRUcDBvVS9xUHMrZS8vYktXYmRoc2Rj?=
 =?utf-8?B?bEN0VjVmOGxvajNxQjdqL3FkUnlyQVlJclBGVVdHRUhYUmJra2dkVnpkMnlj?=
 =?utf-8?B?dXM4TkpxVDRlUmJsaXpyaEkzU3ZUWG1mY3dmY3ZhVjhPK1dPL3ZQZW41ZHgy?=
 =?utf-8?B?dVhzSjJ0c0t6bjNNdEVmSFRuU2pXZ1laSVV6WkJnUzRhbGZuemdLS1d4MUJN?=
 =?utf-8?B?LzJYWHhIUkIyZ2t4UGlHRGZUU2FPSHpDSTZRM01sZjR1bUN0YVJxUTZkOVlv?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b56ccdd1-e75d-4522-fe27-08db3d0c1247
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3098.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 17:17:06.1798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKc5BIJQ/OMvtJrWWzzSeFG7Yq8x8cOXui2cSHOI/a06Q53PkOvV9R51es+JeH3jv+IqrXvByAZoHWOBb9GcLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6278
X-Proofpoint-GUID: b7HiSK5Yk18UYz7Fd5805AVY0sez17EU
X-Proofpoint-ORIG-GUID: b7HiSK5Yk18UYz7Fd5805AVY0sez17EU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_10,2023-04-14_01,2023-02-09_01
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 14/04/2023 07:10, Pavel Begunkov wrote:
> >=20
> On 4/12/23 23:27, David Wei wrote:
>> A multishot timeout submission will repeatedly generate completions with
>> the IORING_CQE_F_MORE cflag set. Depending on the value of the `off' fie=
ld
>> in the submission, these timeouts can either repeat indefinitely until
>> cancelled (`off' =3D 0) or for a fixed number of times (`off' > 0).
>>
>> Only noseq timeouts (i.e. not dependent on the number of I/O
>> completions) are supported.
>>
>> An indefinite timer will be cancelled with EOVERFLOW if the CQ ever
>> overflows.
>=20
> Seems mostly fine, two comments below
>=20
>=20
>> Signed-off-by: David Wei <davidhwei@meta.com>
>> ---
>> =C2=A0 include/uapi/linux/io_uring.h |=C2=A0 1 +
>> =C2=A0 io_uring/timeout.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 59 +++++++++++++++++++++++++++++++++--
>> =C2=A0 2 files changed, 57 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring=
.h
>> index f8d14d1c58d3..0716cb17e436 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -250,6 +250,7 @@ enum io_uring_op {
>> =C2=A0 #define IORING_TIMEOUT_REALTIME=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 (1U << 3)
>> =C2=A0 #define IORING_LINK_TIMEOUT_UPDATE=C2=A0=C2=A0=C2=A0 (1U << 4)
>> =C2=A0 #define IORING_TIMEOUT_ETIME_SUCCESS=C2=A0=C2=A0=C2=A0 (1U << 5)
>> +#define IORING_TIMEOUT_MULTISHOT=C2=A0=C2=A0=C2=A0 (1U << 6)
>> =C2=A0 #define IORING_TIMEOUT_CLOCK_MASK=C2=A0=C2=A0=C2=A0 (IORING_TIMEO=
UT_BOOTTIME | IORING_TIMEOUT_REALTIME)
>> =C2=A0 #define IORING_TIMEOUT_UPDATE_MASK=C2=A0=C2=A0=C2=A0 (IORING_TIME=
OUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
>> =C2=A0 /*
>> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
>> index 5c6c6f720809..61b8488565ce 100644
> ...
>> +static void io_timeout_complete(struct io_kiocb *req, struct io_tw_stat=
e *ts)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct io_timeout *timeout =3D io_kiocb_to_cmd(req, =
struct io_timeout);
>> +=C2=A0=C2=A0=C2=A0 struct io_timeout_data *data =3D req->async_data;
>> +=C2=A0=C2=A0=C2=A0 struct io_ring_ctx *ctx =3D req->ctx;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!io_timeout_finish(timeout, data)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool filled;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filled =3D io_aux_cqe(ctx, f=
alse, req->cqe.user_data, -ETIME,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IORING_CQE_F_MORE=
, false);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (filled) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* r=
e-arm timer */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin=
_lock_irq(&ctx->timeout_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list=
_add(&timeout->list, ctx->timeout_list.prev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data=
->timer.function =3D io_timeout_fn;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hrti=
mer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin=
_unlock_irq(&ctx->timeout_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_req_set_res(req, -EOVERFL=
OW, 0);
>=20
> Let's not change the return value. It's considered a normal completion
> and we don't change the code for them. And there is IORING_CQE_F_MORE
> for userspace to figure out that it has been terminated.

Makes sense. I'll keep the return value as-is.

>=20
>=20
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 io_req_task_complete(req, ts);
>> +}
>> +
>> =C2=A0 static bool io_kill_timeout(struct io_kiocb *req, int status)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __must_hold(&req->ctx->timeout_lock)
>> =C2=A0 {
>> @@ -212,7 +253,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrt=
imer *timer)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req_set_fail(req);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_req_set_res(req, -ETIME, 0);
>> -=C2=A0=C2=A0=C2=A0 req->io_task_work.func =3D io_req_task_complete;
>> +=C2=A0=C2=A0=C2=A0 req->io_task_work.func =3D io_timeout_complete;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_req_task_work_add(req);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return HRTIMER_NORESTART;
>> =C2=A0 }
>> @@ -470,16 +511,28 @@ static int __io_timeout_prep(struct io_kiocb *req,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags =3D READ_ONCE(sqe->timeout_flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (flags & ~(IORING_TIMEOUT_ABS | IORING=
_TIMEOUT_CLOCK_MASK |
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 IORING_TIMEOUT_ETIME_SUCCESS))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 IORING_TIMEOUT_ETIME_SUCCESS |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 IORING_TIMEOUT_MULTISHOT)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> +=C2=A0=C2=A0=C2=A0 }
>=20
> Please, don't add braces, they're not needed here.

Thanks, will remove.

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* more than one clock specified is inval=
id, obviously */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (hweight32(flags & IORING_TIMEOUT_CLOC=
K_MASK) > 1)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> +=C2=A0=C2=A0=C2=A0 /* multishot requests only make sense with rel value=
s */
>> +=C2=A0=C2=A0=C2=A0 if (!(~flags & (IORING_TIMEOUT_MULTISHOT | IORING_TI=
MEOUT_ABS)))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&timeout->list);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 timeout->off =3D off;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(off && !req->ctx->off_timeou=
t_used))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->ctx->off_tim=
eout_used =3D true;
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * for multishot reqs w/ fixed nr of repeats, t=
arget_seq tracks the
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * remaining nr
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 timeout->repeats =3D 0;
>> +=C2=A0=C2=A0=C2=A0 if ((flags & IORING_TIMEOUT_MULTISHOT) && off > 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 timeout->repeats =3D off;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(req_has_async_dat=
a(req)))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFAULT;
>=20
