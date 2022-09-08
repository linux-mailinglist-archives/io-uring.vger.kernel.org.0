Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE715B2622
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiIHSsk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiIHSsj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:48:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5407C1E0;
        Thu,  8 Sep 2022 11:48:38 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288IJ8SR016940;
        Thu, 8 Sep 2022 11:48:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=pnxkAlMtLgST1O3GMgGeo1QhSfD/VbW6DOaAdYQ3AoI=;
 b=GYHmG1OYjsSynBnPCeKL4G4fCg+lAfdiyBM0gMGKoudWXvBWYw03JJ1JA13Dr1gXpC1d
 YivVHKBUmRIBOV7FzHNJIoLo7wK/5Dhpgcbcgu6KcbXd7J6cM4suxVDpfL6I/W8Sx2x2
 59smzA2Nj2v+WoAx+2ir9fxo1LLFbShJfOY= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfb17ckbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:48:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxmQBYdzqlMSQhAfXBEOsCGrQPalvnXdOGGaN+GpklAejEIgpil1ZaLpM0+kgQDedo2O7x0Nr9OX6H+3c1CbqZLDRJpCMiCbJGJGbI+GrffY/h+WHpO/3+I1i7RM/FStX9qSY5vxK22KZkVErWbo8hN7InFJ1loXtY4p2lMZgkJ+sFSphzyitlQdA7feoR7dOtF+7x+zmvs77J+IfFicNVYPFjpfhLw7Cl+rKekJfFuJfYqUNDMAwXy4WsSpBHRdV4NqPR0M9JT2LHP7Mn4DJNeb837sppagX45OEy0Aiky2ic7z5VCZjv7aObsqGuWD/TxO4IwDP3KiC/XDzf7zJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14ISxjT+Uk9TU+XfoIvRG9Uw/j0mlhLDsoqZCmD7zO0=;
 b=GY5Gr1nN+/Oa5mO3R/82sTXSmgdUYjxIo5/ORyh/29OpmuukaBJSMNzkMUGC/Au6jSgtRuob1JBgcroKzGze7Xc/RzbUx6EIYMMwaH4RkLEvf0vS8d0A/xTY/RC9lfABY6WzGMTuqfsCqeqNoCzv9N02bbDDrvWPBE9cJbyQ4hRR4kR1LTLv1wTRPUzn7yljRtC5SWIHs6vM6ulb1Mf2EAbsKHrGzXPX94mqAYrLzknzSdfBgc1sSjbTM1uKwIRhT0euNZw42MOW0UkiqtN74/CLLTPqjisXcvHEwzqMPomttJOVBOStCikeEzWQMCff2wwCuFDrt1ZVya5h6xa47Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DM5PR15MB1785.namprd15.prod.outlook.com (2603:10b6:4:4d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Thu, 8 Sep 2022 18:48:32 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:48:32 +0000
Message-ID: <adbc05a6-2f53-c2bd-9a09-934c0948286d@fb.com>
Date:   Thu, 8 Sep 2022 11:48:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 10/12] btrfs: make balance_dirty_pages nowait
 compatible
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-11-shr@fb.com>
 <CAL3q7H7Zh0VzPG_F2cM5e37QzpOEkRNaCjPrzicKtm=muidR9A@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H7Zh0VzPG_F2cM5e37QzpOEkRNaCjPrzicKtm=muidR9A@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::32) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DM5PR15MB1785:EE_
X-MS-Office365-Filtering-Correlation-Id: a1990a1f-c847-4315-5bfb-08da91caba53
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q1kelGvMnNuUN4boCAy3ZGTC/m5Mu9YMt+5c07zeUUEGwZtp3I8lPwcZKdFkd4AWHJfsxPJyNtMDydTQVAi3MK+8uNGYaMcaOJlcoRJSYT4iNrjKVjvMJOn3qy0SbISiAMK8qYZ1DeEMAJmtN1aQZosuP21jkzKUDwJ+Vtk9jIhEWLZjYL5CUK+fQfncUPlWHeHwVsTHy7nlm+KoAokhc4uvI6b/vZk8mZE/BZf6ZF6uOG2z/0aHWgkzwGTUsST+dlosjCXSuvdOEnqdFpZ6DQ8ylWHP72W+005JaUBYjbJIxUafpXcvDiTPh4j+ySoC6fikDNYYM1wya4zf8FsP8EDZVjhYU+d0tDpbtKpvcdCvphvxCTnA+4KMxMwBDpKSFuZgQo5wIHc1bbn9bO8QI0dI0sAfu5ueUkRsHtoHt+uXaUk+A9I67LBK2IvxgMNNhV6xMEuIjaaGnCEgOgWM/5GDVaAwzjJbThgJ23MXHxMeuQUhQ72fSNKZJhDeGeEK6jMMbFVxu3speqbJ7KZYHXNVeZrDvkJZpmPI+6Yc7G19rXZloSWHhTw6Nxn560bxif/EBPB7v6iM6PsG7XdvtsXI+pHha7jQnM+5rweWQc64KSKLawiuS2S/VljlX42nAQR5TKQMUGd7IcYv2KHRkwn7zl4Qq6dO1Tvhd4frG+XwZOH7p4D04z6cxiRzl331s9q3q6g/pP1MCvnhQOtGVUJ0ueZty11bQaIP6afh91lkkzUcD+IF88Gxy08N9YN0eRaDHETlCXujTuduXDUiQzRypRa5E1cmCm9LFApiiwLodJoTi0NPFy4U+LEXmxVt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(66556008)(2906002)(31686004)(5660300002)(8936002)(6506007)(38100700002)(6512007)(53546011)(41300700001)(4326008)(66946007)(66476007)(8676002)(36756003)(31696002)(86362001)(6486002)(6916009)(316002)(186003)(478600001)(2616005)(83380400001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm4zNE9BRnoyVnhoUFpjU3E4TTRlUFc3SVV3ZHQ1cUU1L09tN2YrZm5oMzhu?=
 =?utf-8?B?Slg0VURrQkE5QVNUTWU0aXNKSWxiK3ZyVlBQZ2NYcS9wWHlFTXByRFhuQjlT?=
 =?utf-8?B?eFNVQ2M0b3hBeVJaTnlybVY0Zjk0WFQ1aE42WjE5TTBETjVtUGZvb21XeGhI?=
 =?utf-8?B?L0swcmxYb2tWYXNRSTJzVWlGQU5pQlFLSnBzcW1laVVFV2RNZWZPVVViYThv?=
 =?utf-8?B?bWhmYzh3QmpIdzhuMEtvMDZocUg2ZTF4S2tEMXFiRmpxZUNDMWtWZkJLRTBC?=
 =?utf-8?B?WlVjbHcvQmZlRlc4UXZ2NldyVytDVnU4dFlhanZjZ3dsbFRwbm10Zk5XVFlj?=
 =?utf-8?B?dG5nMm9LaENRZzh0Nk9uaWxNVE9lNTRMNHFCa2FLQ2VXa1VYbnR1NDZqdDdE?=
 =?utf-8?B?K0ZhK1h5UElQbGJxTFU0U2VXb2hZdklxK1ZvUGR5UThlVGhMNXd4dzh1U09E?=
 =?utf-8?B?WFBPZG1reUo0ZWl2MzI1bnRLZDkzUGZvK2tMZk4wT2lXWFF3YjFDR0ZMYTlI?=
 =?utf-8?B?SVp4bkl4czVsVnFGenMyUS9xejhjV0NKVXNZTnV4N09vSW8yZHQzSzNpekNP?=
 =?utf-8?B?ZUlCNng3bWg4Wnl2aXhqVkpwczBLWVBuSkhpQXJMeU94L1dteXZsS0Y5OU5s?=
 =?utf-8?B?L09TYnRLZTN4VE5OYzJwVFJNbmRIYm8zeEIrTmJkTnJQcWZKQ3pMSHlmYkFl?=
 =?utf-8?B?YytDSWd1aXdiWGw2c0NFbm1zY2hDeDRLMFhRakxkc1YyRU5oTUdRRjIzUEVI?=
 =?utf-8?B?MU93Q0psQS9CSDc3WUxXYjdlaUxoMHZ4UlpnbEpMZ3Jjb204aFI3NkVYNm5Z?=
 =?utf-8?B?b2JkcEFramNuZmxHRXV0S0JTYjRnRldNb0tSb29oYmVhbklaQXpFa1lRNTZz?=
 =?utf-8?B?YWV2Sy93SEh0ZkRBc1Q5dWNsc0xXUXhNejNxVzU4a05mM3ozUmpwMGxZNkh4?=
 =?utf-8?B?a2FZK1d0S1NVdE5GeTVkL3VUL05MQUdEME5oYnZRQyt6RnZnVTZRdVJSL3Iz?=
 =?utf-8?B?ZjBzck5wM3F4dCt4WGU3NmFNdjdMdklON013OS81enFuVXY0TlNsWHBXSTNx?=
 =?utf-8?B?TFRoZE12VlhVcCtvNStzMHdRN2NwSlRhekZmV2JzTE5FYkYyVXBkbTdDaVRU?=
 =?utf-8?B?dTQ0TVFIdFd1YVhEWHhwaUwxa1JPQjB3eE9lSVM0eEVSQ3o0RDFWOFhVOEZh?=
 =?utf-8?B?czBwUmE3R3d0TWVhY0FFUWgxVkR6b2RPVDBFNkxCSnMxdGlsY2srdGRPNjF5?=
 =?utf-8?B?YkpqeDcrcE1LclFTVVY2alhuVjlYOUt5MXZMdkorVGRvbzNucWZEbnN6NUU0?=
 =?utf-8?B?eWxleUttSzZoMEI0RmR1N0I3VTVxa3U0ZTdVdy9xaTFrSmJhL0hONmdjSUJi?=
 =?utf-8?B?RWdtVzIwYUNCTTRyaGd2bUVvNHFSS2VmbnVhM0RkZXlNZlp5Qk95bm1LZ2Ux?=
 =?utf-8?B?QUs0OXVTa3JlcEpKY2VHM09HR1lrM2hheEMwTGd5YWlrdWczNHNMV2xtRStN?=
 =?utf-8?B?STVlQ2IzK2VjRk1NM2NBOGkzTnBZYkQ0TUFPeTNPNVlUek9vUkUrUjdCVVNN?=
 =?utf-8?B?MHZFcko5WWxuU3dueWVVZjRyN1c2ak1lZFVFVWU2MU15SHY1eEFGOVNLUGxX?=
 =?utf-8?B?TERtNlBDQWRQMFlkUWVEamViR056TUNRUzUvd05EVW1oTjRuR2Z3WXd1M0FD?=
 =?utf-8?B?d3hFdXNYcDRDNUU2bHB6VE8wWEtyMU1XM29YbzY1TjFTNC8wblhRanlFNGdK?=
 =?utf-8?B?LzN0OG1jYjhRbXR3M1ZLZ050dS9tTXdDYUszK1dsZ1NKNWlmMlFPdERxSzNE?=
 =?utf-8?B?dUFHRlJxaEd4TkpQNk9VT1MxRVdJK3BjM0FhbmVrcXcvcE1TYzhqQXl0cysy?=
 =?utf-8?B?TmNycWJYa3JaVWp4L2p5QUZ0UW5tNE51aDdRU0R1VnZsNFVHamlmd2tUM2tw?=
 =?utf-8?B?ZXk3YWlKdE1lcW41NG0yeVRpRGJBVGNVNHkvMkhqTHZKL0M2c1NKaU9qTzRV?=
 =?utf-8?B?MHFYNUlXVlZSbjFlaTNnNzk2dzh5MDlkckJQTWx3Q1k0Mi9oRnl3MjZLOEQ1?=
 =?utf-8?B?STJFbGhTakJJVXI1cjB4czNIcVh0bFR2bll0SXA5ZGtPSmwrOHI5R2FzTE5F?=
 =?utf-8?B?OE1WS1l6M0dqMGxSZDFpcWhkUTFXNUdPQmVEZ04wN3IyWHh3aENYSXRrVUY3?=
 =?utf-8?B?b0E9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1990a1f-c847-4315-5bfb-08da91caba53
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:48:32.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oI0Fz/Vluayteh9OnOToOVX2WuiWMA2CB8a4PuAqeCCEFQAM92qwILHoAhmmV091
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1785
X-Proofpoint-ORIG-GUID: F2NLha-8IYoJP73w5zFBYQqi8CdGLfn8
X-Proofpoint-GUID: F2NLha-8IYoJP73w5zFBYQqi8CdGLfn8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 9/8/22 3:16 AM, Filipe Manana wrote:
> >=20
> On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> This replaces the call to function balance_dirty_pages_ratelimited() in
>> the function btrfs_buffered_write() with a call to
>> balance_dirty_pages_ratelimited_flags().
>>
>> It also moves the function after the again label. This can cause the
>> function to be called a bit later, but this should have no impact in the
>> real world.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/file.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 6e191e353b22..fd42ba9de7a7 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1654,6 +1654,7 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
>>         loff_t old_isize =3D i_size_read(inode);
>>         unsigned int ilock_flags =3D 0;
>>         bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
>> +       unsigned int bdp_flags =3D nowait ? BDP_ASYNC : 0;
>>
>>         if (nowait)
>>                 ilock_flags |=3D BTRFS_ILOCK_TRY;
>> @@ -1756,6 +1757,10 @@ static noinline ssize_t btrfs_buffered_write(stru=
ct kiocb *iocb,
>>
>>                 release_bytes =3D reserve_bytes;
>>  again:
>> +               ret =3D balance_dirty_pages_ratelimited_flags(inode->i_m=
apping, bdp_flags);
>> +               if (unlikely(ret))
>=20
> We normally only use likely or unlikely in contextes where we observe
> that it makes a significant difference.
> What's the motivation here, have you verified that in this case it has
> a significant impact?
>=20

I removed it.

> Thanks.
>=20
>> +                       break;
>> +
>>                 /*
>>                  * This is going to setup the pages array with the numbe=
r of
>>                  * pages we want, so we don't really need to worry about=
 the
>> @@ -1860,8 +1865,6 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
>>
>>                 cond_resched();
>>
>> -               balance_dirty_pages_ratelimited(inode->i_mapping);
>> -
>>                 pos +=3D copied;
>>                 num_written +=3D copied;
>>         }
>> --
>> 2.30.2
>>
