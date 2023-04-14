Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EA26E2BCC
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 23:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDNViq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 17:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjDNVip (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 17:38:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A61180
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 14:38:44 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EKwWt8030218;
        Fri, 14 Apr 2023 14:38:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=s2048-2021-q4;
 bh=Apj4yRhubysvzpuHVUeTKlllbf4juxZd/k+nI4iEwjg=;
 b=gup2TNEFHxaj1GiGVa7UWVMLBBtAGf4g6Ht8mda7udI+qT/FKMjvKY5/7i0JCJP8PoSW
 CnabtbaMzPCCobCtSGMt3uUT6otMnYZOfhxFhLGBtUiCNmLcfP+iwK9XO4EexHMFb0e5
 BkYHMbQyEL4Nota9tkLGtb5MoFkgaGNojsumyIktpGUtnqOWyfjTwCCFHx/B2FnM9ggH
 GLC0m+lwSxPG3YZXOHikmeHl7cAt8NwnQsvt+3+opFG+nhCPrYyai2ojdIkSWhNqgB9z
 clK3uMZNFar53VYp+Wfnq6p1+B/dmr7HgAAeTYtW0bb+Ni2JrTX/S/lbyxuaFCyFr3Ex ow== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pxx92nnkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 14:38:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvrUa68FHGdGD2yXEy6BiCy/tuRFQuzI+1zbEgUmdbFRBF3C1N8Bc7BGyAfvrwWbMj2ovRZm/khBzGaB6JezKtm5oqpjvUs/H31XL4hRNp4HjT1gzv72g94ZOaLumRkxERCAvGtQWAC6VvJEdYoj7g8yOaw8L74DbgXTm+WHfXdfyP88aQ8IJQ1P1plqEySc+vSd5gd0YQFOyqrAf2Rgx1rTGRzZonyGLQ1aAedPxV4dsCFAzo7k/m0I9tX47BDElsjAoYIb1Cqb3zGkJvsQpvynX7vG3HeJY3/QPK0dRgO+pLtlrv9mEtOMMqomys4nUuewGQiaIMoqf+8ZeTysbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gr+tHsq2xxyDTKcXRvZHUFJHhI7KRaijFo16aJ0JxSQ=;
 b=Y983gvtI1ZF9APa/WD9GCqHdWqKOzHPYooBLQ7wtdPq0ojN8FPCwAJG9LZqYRSx4/ZcK4zSyqdm07vsVGW+Ubn0RTMs3fa4nKbAkQYTCjE4F2PdIt21GcJJM8c6BcnPF8GnCR1ukbSEarN28gNBGWwoHwzVoPcHWfpnul0Gv5CReEHl1dMw0N93iQCTfrT4BolTbo60gnwmAWZumKWz+VwbmTswmPLyNGqKDT/3f1Axi+1INxObFN9art1vmW3XfR1XJHBzxceuOPPHKwDWfOUbk1bpH4S+TfhwioJxwVpOZ/+ou44jnJYU/t2gYp2SiPhUyW/BAmMF8Tn4bkrH/rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB3098.namprd15.prod.outlook.com (2603:10b6:5:13b::31)
 by SA0PR15MB4029.namprd15.prod.outlook.com (2603:10b6:806:83::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 21:38:40 +0000
Received: from DM6PR15MB3098.namprd15.prod.outlook.com
 ([fe80::ef62:110a:a3be:a01e]) by DM6PR15MB3098.namprd15.prod.outlook.com
 ([fe80::ef62:110a:a3be:a01e%6]) with mapi id 15.20.6277.038; Fri, 14 Apr 2023
 21:38:40 +0000
Message-ID: <942e79e8-fc40-89d6-0651-a2f0eceb5e87@meta.com>
Date:   Fri, 14 Apr 2023 14:38:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v3] io_uring: add support for multishot timeouts
To:     Dylan Yudaken <dyudaken@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <20230414201326.2373944-1-davidhwei@meta.com>
 <CAO_YeojHXRtCBRuOOvzcyQ125E3w3hwkFHjS5Z2QhWUiZYqrTQ@mail.gmail.com>
From:   David Wei <davidhwei@meta.com>
In-Reply-To: <CAO_YeojHXRtCBRuOOvzcyQ125E3w3hwkFHjS5Z2QhWUiZYqrTQ@mail.gmail.com>
X-ClientProxiedBy: BY3PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::16) To DM6PR15MB3098.namprd15.prod.outlook.com
 (2603:10b6:5:13b::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB3098:EE_|SA0PR15MB4029:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b68d84e-30ee-40da-dcfa-08db3d309cd4
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DMdRhBLToVRyOGv/Fo5D2+cxyz8ZZFbc8ejTdhwvvvVFA7Rs9Qyr79AWAVRkeofAsT8Aaff87riAhFTImfpT55Nbg9vVVDWFEjg29SxtgR+TPhpQg0KG9Bmt95iSldhVgUP65hVLCdo01n0wt/xEwxUHDi4mld+na6PWFXOy/5lXGryabdfQuo+ZuAb6RAGHszpaoy3aDW4I+CvBci0GdapQXGN9UOg4RZTiORayz8LIm14Aw3v5Di/b37xgEQfFDZoSW4MVNbKksylb28B1CIOTk2oMaRrtdOWFz7CixUtf/jn6NpZ6WVzcdoGMaHcjPGOAAMANsCo4c+lsPfw2BeNxBu9EbV6E+crjUvsz5bnx0beDh0/TAUQOZYoz/28I9wjQS0DYC0rJ+KS1OUsKlxIVLhGNhI6924aalqxaLE2q0hXxNUVNGIE2InVMG/KfgeFRsJF83crpHiBe+UEhQNCdp+kBG3a85W5bjl7ptU2q8QKp8kNmMXrEsJojQeBK5Gi7jQ6tHs+o7XmNVF9qxRnuRCKWGPoqHi8Kx3Gq4frVnyKenG2gOUZg6krLCuEGuqISlRhhV/ORMpSsCR3HSG8iC+FncslR4ShU2hYZIVL3fWdHpN1TDF5iItwVyofr/FsXIeiZ7eDtq8FaADwkTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3098.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199021)(41300700001)(66476007)(31686004)(2906002)(66556008)(2616005)(8936002)(6916009)(66946007)(5660300002)(31696002)(8676002)(4326008)(36756003)(478600001)(316002)(6666004)(54906003)(6486002)(6512007)(6506007)(53546011)(83380400001)(186003)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUU1aXhRS24vQjVDWTdhbmVQbW9oVS9qSVJXNG1aV1plbnQwci82NmZVM1FC?=
 =?utf-8?B?RktUcGpPczlyY1hNNVZmU29Zb3Y5dDdHMC9mTlgvVFFIMXJFWW9lRDlLMnB4?=
 =?utf-8?B?aGcwZXhQNTYzMjJIb3JiTmg2QzFMRjVnaXU1cDV1VjFJb1VjMld3TU0wU21z?=
 =?utf-8?B?ajVkU3BaNnhSenJlc3VibXExdEhtSnVFOUlMZ3FCb2xENkt6M3lPamQrUkta?=
 =?utf-8?B?SkwvenJKSkhreTN5TVkyaEt3ZVZIcjl1R20zU21zcS91Vm9DcDZjQzBVaCtY?=
 =?utf-8?B?YkJKVGdMRTFURUdMWk00bHNXWGRtTjFRWERHUFlqckRvSmIwVHhid3huWHdG?=
 =?utf-8?B?d2p2SzQrdzZlUmFNdjZ3dll2OWN0QkwyNVN3UDlCbE5DclZBRTNqUElFejZB?=
 =?utf-8?B?dVpTbmRJczRKUzZFanNaNWRFOUErMk5ZQVlsYjRoVkN1enJDYkkrOXFRUGM0?=
 =?utf-8?B?TUFNQzRySDBVeUNUaUFQQnFOckQ4Z2FNOXUybzV0ZGNHa1NoQXhQQXpXTmRa?=
 =?utf-8?B?Zk1nVVU3UG1XZ1BTWW4rbnBSRXZ5empYSWczTFZpQzN6WmxCTW1TY0MrNGE5?=
 =?utf-8?B?OWpYUzA5dTJKR2dHUGtHUWJGVlJyYWg2RmMwcW42TXpZUUJrVGJkSnhOOTdh?=
 =?utf-8?B?UlVWRGU1WHlrcmR1SGpMRGZEb3V2MHpJVTB3S3JtT2N5NUNGRFpGeGNTQUNK?=
 =?utf-8?B?THU5MnRjWS82Z1lvSTJyZlV4K3R4bGw5STFudytZNmJFVitQZmM3R3B4VWhK?=
 =?utf-8?B?SUhUcTBhZUdXZ2Z4UG9EL1lqYVVTYkx6M0V1TExQV1ZkenpKU0lPZWJhdHhn?=
 =?utf-8?B?MWtubUk2Y0lROVdoTWRHSlA0Qm56VHpLWVpSZnFIK2Jybkd2VnBUdDRhUWpS?=
 =?utf-8?B?eWtrNy9EY0dxQ3IvZkRWNisxc3cwb2E5amNpcWthNXQ1STdIakNoS0J5VExF?=
 =?utf-8?B?dzJvaEVqS2RKOG1hbi8wT1VSck85RWM0MDJFZXVRdDVUeTUxQ0VDOFE2QTZC?=
 =?utf-8?B?NDhRR1Q4R05XNlA4UGc0VFZrTFBkc3VwVnJha041S2hnREhFSmpNMVhJdmJl?=
 =?utf-8?B?V3FJVUJsbFpQT2ZyaHQxRituNTY2UU5RQmhFRG9pUGRjNkp1WjdncDBjMTRq?=
 =?utf-8?B?WUdSWVhOcEVEL0Z2SXNUUFFNVnRldytBYnhzdnpIcE8zb2ZlNHZCUHh6UWdq?=
 =?utf-8?B?R1Y2MnFicVNMaEpCTjlJd2p6Y1Z4eG9NTWlFTzlMR0xIRG84WjFHYnpOS0xh?=
 =?utf-8?B?Vmw0MmpGOXhIeitCelZLcit2ZG9Gajh6a1BxNGhyazFFanRaTzRZaXNvZzdw?=
 =?utf-8?B?YW91VWFvS2V6MG5WbDlkY0pwMUlyREwxMk9KL1g2Y1dZeG42c1J0WCtobzlI?=
 =?utf-8?B?cms1V3U2YURDTGRDcm52bEcrRk41eXFrUXZ5M0dxN05JYWVSckRmdFZoS3I4?=
 =?utf-8?B?cEZleENZTk9LeE81TmRXaDFLbUg1ajM0WWV1VVl5TGJ3NmVDUzlpUlNGMkUv?=
 =?utf-8?B?clVLcWxIRlAxRkVrTEJaS2NJOXFNRVlTb1YwVllQeklPczVlbGo0VWFIdG5n?=
 =?utf-8?B?OUFqTzc1UlNJeWw5RXlOSHR0WStmWHNhVDA0T05MK3d5S0hEanB3SlRsNkMw?=
 =?utf-8?B?RXNrVzl6RjExSjBzeDdCU1A4ZW5ySWw3YjRRT1orRkh6SnF4ZXJsVzJCZXov?=
 =?utf-8?B?ejQ4NnhCbVFkV0RQYXJ4dENlUDlxRTkvUHJ1UWNnaVpwQWhaR0ZKK3g0SDVl?=
 =?utf-8?B?OHFYYzY0QkRXL3ZmM2tVZFBDNll6SmFVT04zYnhhV1hPR0V5UmZLSWxmSlB2?=
 =?utf-8?B?RXhCSUUvQWFWU3M4OHFGWkFZbjVNVkxMWDErRjY0cXVsNHJYZkt2RkpsOW5P?=
 =?utf-8?B?S2NtM0QwR2tMeG02KzB2VkRGN0ZJVlBGN2RRVTN6aGRkSFBlNTIyaG9JVmJT?=
 =?utf-8?B?UkxodW5pekNDOFJzOE1NTHUzZGdKdzlwQzVlWWRISHBoa1lTYUJUQ0owQW80?=
 =?utf-8?B?ZlF1V1Y2QXBleDI1dUluMDA0Ykk3NStxTjZNSGhrUGZKemw1dWQzR0wvSVVr?=
 =?utf-8?B?bEIxYTZ5Y240amRjQnBLdzF6TStxdmE4QjZHMDlBbG9ERVRsRTZKQ0lkeFlT?=
 =?utf-8?B?MzhwVXhHbFplU09hMndEYzl2NmZhSE9IblU0Q05qcjBwYXc4T0xkekk2Z1Uz?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b68d84e-30ee-40da-dcfa-08db3d309cd4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3098.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 21:38:40.4044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02vHlXJXP37qX3US2JQI+zhaK2qCC10iQKBDUwFN/reMKAYkv0rrDml0mzFJFKdVOoepRXyKvdt2zPUm9axxWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4029
X-Proofpoint-GUID: xI6-NCvlu8ytEzPQ7m0TvaW3EXESPPII
X-Proofpoint-ORIG-GUID: xI6-NCvlu8ytEzPQ7m0TvaW3EXESPPII
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Dylan! Good to see you :D

On 14/04/2023 14:07, Dylan Yudaken wrote:
> >=20
> On Fri, Apr 14, 2023 at 9:14=E2=80=AFPM David Wei <davidhwei@meta.com> wr=
ote:
>>
>> A multishot timeout submission will repeatedly generate completions with
>> the IORING_CQE_F_MORE cflag set. Depending on the value of the `off'
>> field in the submission, these timeouts can either repeat indefinitely
>> until cancelled (`off' =3D 0) or for a fixed number of times (`off' > 0).
>>
>> Only noseq timeouts (i.e. not dependent on the number of I/O
>> completions) are supported.
>>
>> An indefinite timer will be cancelled with EOVERFLOW if the CQ ever
>> overflows.
>>
>> Signed-off-by: David Wei <davidhwei@meta.com>
>=20
> ...
>=20
>> +static void io_timeout_complete(struct io_kiocb *req, struct io_tw_stat=
e *ts)
>> +{
>> +       struct io_timeout *timeout =3D io_kiocb_to_cmd(req, struct io_ti=
meout);
>> +       struct io_timeout_data *data =3D req->async_data;
>> +       struct io_ring_ctx *ctx =3D req->ctx;
>> +
>> +       if (!io_timeout_finish(timeout, data)) {
>> +               bool filled;
>> +               filled =3D io_aux_cqe(ctx, false, req->cqe.user_data, -E=
TIME,
>> +                                   IORING_CQE_F_MORE, false);
>=20
> I think that the defer parameter (the first false) might want to be ts->l=
ocked.

Ah you're right, thanks, will change!
