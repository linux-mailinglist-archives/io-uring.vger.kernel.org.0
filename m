Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003025B2563
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIHSM4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIHSMz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:12:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE5ECCD56;
        Thu,  8 Sep 2022 11:12:54 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288HWJiQ003232;
        Thu, 8 Sep 2022 11:12:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=TJVSzpJUb5hgM5H65lC7V172r3ahOAKbcXIMch0KJN4=;
 b=DuSQz+N8q7PU45jklA0KuqoPkViO8Z1U08exa2P3VQejbNusHsrYJHcPArXiz4cYbQyz
 xYVdrjN6XzIQ1r6jap0HG54rKRfXtPTLh+Pirk4oyB65+C2ZOe5kn8RSb4/TAPPb7hMQ
 3coE1iKO+SISKCnLR5NU1zQgWswrR3RgloY= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jf33npmqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:12:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1vFPGm5Hb/klf/SJfOxv0UO99x88N/cN1NdYhJefPNrDAY3AiunLAcBUwcEigts0RY8cbmFVsW1VLD3+DYnoNUvrw9s6SiUduw/iyQAZEjVqjSG1trlaTJ9rfo5nW/b3KMngzeYKP3hSl98682c9/fiIROdxGotJsSKfiAf32niaK2rO3FXYdgg5/ve2szQrK5T+9q+zLl0sbaSvK3rSD46WmetDw09PejbhmmkjEH3qscGp185EBJrVdpH3xCRCGar57KgedceO/sK9pWH9dhUJHHMLZv+QyjBEGJCK25bAfjJaAAG5omxNONmDevDGk0Ob++Tl2xpAQYMwp/n+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZcNL8gBrYtG/51QNJwoFrL6NBgkIEgp241Dqs4n5JM=;
 b=DWyEyKI5TNYfZJ8LXnx4y91up4QIVpuC7ZlbxwBwS6u+rfKzuRpSrvnJemIyXympNMvGASIM/PpMQM6xULdtKz4IoyZGSge4ulbCSOzCGQVID9SDj1Hn2nRg9qfpkZZvMx/5vstvLzLoDH67+4YjS1Q5KKL1Zo4E7wPi4WHG7jMn8pHWBThBt4C2AjNVUMmCbL2ilFGK48iH1X7bsqwKF9AAX9Q/CuLa77dgteixcNom0n+LVg42Gx6LczQ/OQHZMdQILVSJMARwF83wr2obmx6u4egz0NGokWUyaUYMUNhzv+hw7DyW+6FCcVa6cIF2LqAsheBcj/x7uMqIy9McYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 SN6PR15MB2287.namprd15.prod.outlook.com (2603:10b6:805:23::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.16; Thu, 8 Sep 2022 18:12:48 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:12:48 +0000
Message-ID: <e2ca0793-8795-acf4-f4b0-cc98d98acd5a@fb.com>
Date:   Thu, 8 Sep 2022 11:12:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 05/12] btrfs: add btrfs_try_lock_ordered_range
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-6-shr@fb.com>
 <CAL3q7H7pRTH7YFnSmeQ1iZcp2Hr2ddkW-qBEBp31n9a50KJ-9w@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H7pRTH7YFnSmeQ1iZcp2Hr2ddkW-qBEBp31n9a50KJ-9w@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0124.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::9) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|SN6PR15MB2287:EE_
X-MS-Office365-Filtering-Correlation-Id: 3de501ca-30e7-4423-c19f-08da91c5bc5e
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtfxhUml3t4TYLnowapgRJIW5UCk4HCwil94iPLFIKe3RtsSqmgo9wvpl/3H8OoNJ+ofFn70O9zUKVXhNeLodCoftJJ7NiKKgiKBRkD2hQUCZYiYuVL4Zl/jPqyV3KgM8ddOo75OBWFdbtgKlqjMDja3svKhZ6wyVWAsj7SnqwWVa9OolwvWJ5eKHVfwzvkwb6ey+P1oYDJfycgtARLnPaMVgGMljwcLI/mpQTrlp+ujzHS2ZzDYfwsBqCdKA9E1yLQ/eevdkh/qTfnt/E/ZNrJGw8tJEwaVMAs/ymSe6kJ2gIK05fxyJiZURM+Kktxt9y5vlF7kMobI4uuBRfNRFwC9nbcNouaTebpovWKVt03OdVcqo+B3VaGMJb9DTRu5q1YuZwa0wd2XL+WnPy5UjCqdgiw48izVrw+dRtSHESHreVgyiYg1ZBraG8Jlg1fv5HXnusWKsJj2kKBBlQ3cNiuYGW2oz88paiXRVV+Zdv0v/OhtcgBG4heUZY0orR08YsS2Q29AQXmKxl2ojNXP0MCcsaefNE0W20yjiZYLjorhSXHqEs3ESpuzvg5KMXyX+rwS3c96IBTS/gUu+KTwdhiKVgPv5XjTnr4K633mHHhIoXmg6kieA3hclluBSmzF+pnKoMwGFRwc7QT88UKWrhnaN6R6YZzLsnmBrpys+jksbDd3ggHYmztIpAQgvNCocXtacKOSRfYPwMMPJIEkv3dRLe6N0vjZv/kgud0dpRYuBtUDbLrEhR63bZqywVf9uOtjT/ljxdOoFQy9VmYj+kwqSwSAX1Ae5h6KooYzG7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(6506007)(6512007)(53546011)(86362001)(6666004)(41300700001)(478600001)(6486002)(186003)(2616005)(83380400001)(36756003)(31686004)(38100700002)(4326008)(8676002)(8936002)(6916009)(5660300002)(31696002)(316002)(66946007)(66556008)(2906002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTU1R0NuMEx5RWNLdm03NzFUYnNNQzFSY2syaVBrUzJHYnFCdG83dVRyTXVU?=
 =?utf-8?B?ZzBwTW9hUHQyQ2NzdVRjRnNCd0tWanU3NjJKcG1HNlJKUnJyU3hiZytqQWhv?=
 =?utf-8?B?OW5pVm43TTVNQWFuK3kzaUlCczBtTlIvUFNxYU42V1lDSXczVWRzeXZJQU9G?=
 =?utf-8?B?UkVVdXZqc0VFaFZZRWc0SHJvSWlTc1gveDZRUG0reTV2TWE1YlVDODl6NHJL?=
 =?utf-8?B?bXl2eWlzWkFOVkJ4T0E2a0JLbE1McVlrNWxZdjJUNEg5a2hmMkdJU2hHdlM2?=
 =?utf-8?B?OVZyRTlvcWk5cldyTEFjYmh6bUpHY2xnd1R0eDU1ZDdDT0pPY2x0RWVxWTFR?=
 =?utf-8?B?NHJ1R0tXU1hwVmdWN1hvRGxGK3hMSGFHUDdMVndXeXBpQVNlaHFpL3VvSjJO?=
 =?utf-8?B?TWRZVEhld0JaQWVhN1NFR3Jod1Qxclowdy85ZHBUb051WTZWZS9vWExHSTBO?=
 =?utf-8?B?Y003Nm9LVXd4eTgxWkpZWUtnL2ZFclg4ak0ybDQ4b0xGSzBYUEFQYTgrUkkr?=
 =?utf-8?B?U0g5b1RkbkR1WUNoVHlrUXFNWUFFd21EVHRwWXRUcStMVWltS1lGeXBTVVpG?=
 =?utf-8?B?ZWp6MEI0NlBrSG5SR0tBNlNkeE9lR1JBWjQ1N2YzWVNOZlNXYUsrTEdvWjEy?=
 =?utf-8?B?c3F1amF3YUdpZzJTa1M0RmRhc2hHdW5EcmdxRm9MV1phZFkvdTlCbzRCcTF0?=
 =?utf-8?B?NUwwcFBJbnVyWHRaSUd3OXJNZ2VBcVJCQlpTMEMyQkRqck9qNmE1ZjcyTjZM?=
 =?utf-8?B?UE9vazY1eDF4dCsyOXA2OVVZTUNiQitISlluSVRsTENQUlRwYTYwRW03NTUx?=
 =?utf-8?B?MEVML2FCeS8vS3Y5Q0lhRkhreDkzaUt3VFd2eUFRVXBSOVIxQlZMdXZ6Ymxx?=
 =?utf-8?B?REgxZ01SWmJsb2dGbkRkUis2QU0rbGs1RWFKMUpxUVA2NmZTK3hITDA4YThM?=
 =?utf-8?B?OXdnK01qWkM2ZDNEVExrdmR1cGdCdW5DYWVJbnFMdVBEeGZGUitOVHU4Sm1l?=
 =?utf-8?B?TWdRNWJ5V1RTUjJjNDhoQVJNUFZ5NzZmWFhzVEJVMldSeC9nYXY1ZkhxanRB?=
 =?utf-8?B?bzhMNHl1VVo2NU5Qb1h0UXhWWkI3TmVwcFY0OSsrVjUwRWhjRHMzVjYzbmtJ?=
 =?utf-8?B?UisxMFNhOE5Cd2RoNUlzM3NFQjh4L2J1bTJ5MEw3Mi9xQzA2QXd2Z3pUYVFo?=
 =?utf-8?B?eG1SQTZVMzMzZnZQTnZxZElyZVRKd0w3eGNUL0wvOExhWDk3Z1ZrTkZFdDJT?=
 =?utf-8?B?cHdteGhmNWNiSG0zdXZNTWtOZzFnWTc1T1JFckFzTHFqWU4wVnNYWHZQZUdR?=
 =?utf-8?B?c0F6VTFsd2xTSE85bEd4ZGVhc0YyQ2UzSW9KMzRlTDJ1SVdMU1pibStSOEVW?=
 =?utf-8?B?d1hzRTNVWTVXcEE1Z0NJOFB5THpJOURDL0ZWNFhwTFkwWnBTUElyVE91SkFy?=
 =?utf-8?B?OTlVZDdtRjNrZnJGNUFiNzVFUGVRdHhFRGk4V3RsL0NHUjdnTmYrOVVPTjU0?=
 =?utf-8?B?d1E0TGwyQ3BXcWY3d05rUmFFMjljRVM3SWZ3em4vMkxBZVJzQ3RCUytySXRn?=
 =?utf-8?B?VG5xbEdmK2NNWjdKOGlJdXpwQmhuVzNRTDRGamlITXJGUlYweHcwK1RpV0pB?=
 =?utf-8?B?V1lHY3J2ckhpRndpRWIyYXhFQkFGc3VEdXVoVnlScFZDSmFUTnl1cUJDKzdR?=
 =?utf-8?B?R29OdG1BY3pLdThLa3VyZGNHVUVPUlJ0aUxNd1FHZ2RWUTZhWjdYZFhVNHFR?=
 =?utf-8?B?M3ZZRy9hMUJWTjJsR2dHRytWZ3Arekc1UHpRSVFQYUNqVU5aaHlweEFqdWZN?=
 =?utf-8?B?OHZPRmxnanU3ODdEOTRocS9JeUZtcUozNUFMYWV0UXorbmpobzl1VHNYbUZk?=
 =?utf-8?B?OWJ2ZWlQSW1ZMnAvdGEvempnRlhwTVlIQlUyc0tiUVgySGpDV1NaWEpGdzJ6?=
 =?utf-8?B?RHZkWm9wVzNlS2U1WHZxU21xNFhoTEEwVDdUYmh5RzNITUZQaEs5a1NXUEpZ?=
 =?utf-8?B?MGtQU0ppNzZJQzBGMEdHK3V2d1FaQ2VRRTJ0eHJZSUVxY3dnTDhaTWkxWkhh?=
 =?utf-8?B?R0lidEYvb3hEblVzRjZXS2dMbXVWbkF0SnBzWEJuUVFkWEM0b2ZXbklnVmhC?=
 =?utf-8?Q?33tRZMGQCvQUuAuXQpCHdAbyo?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de501ca-30e7-4423-c19f-08da91c5bc5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:12:48.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJM6utcack4CBoeWajx5T0RHhqhkf4oT4HmDCenFzHbSgVoatljdDXdxNPdYsE6l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2287
X-Proofpoint-GUID: zAuJUeH2WmBu26CTFIAl1MLmRev4MEb1
X-Proofpoint-ORIG-GUID: zAuJUeH2WmBu26CTFIAl1MLmRev4MEb1
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



On 9/8/22 3:18 AM, Filipe Manana wrote:
> >=20
> On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> For IOCB_NOWAIT we're going to want to use try lock on the extent lock,
>> and simply bail if there's an ordered extent in the range because the
>> only choice there is to wait for the ordered extent to complete.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/ordered-data.c | 28 ++++++++++++++++++++++++++++
>>  fs/btrfs/ordered-data.h |  1 +
>>  2 files changed, 29 insertions(+)
>>
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index 1952ac85222c..3cdfdcedb088 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -1041,6 +1041,34 @@ void btrfs_lock_and_flush_ordered_range(struct bt=
rfs_inode *inode, u64 start,
>>         }
>>  }
>>
>> +/*
>> + * btrfs_try_lock_ordered_range - lock the passed range and ensure all =
pending
>> + * ordered extents in it are run to completion in nowait mode.
>> + *
>> + * @inode:        Inode whose ordered tree is to be searched
>> + * @start:        Beginning of range to flush
>> + * @end:          Last byte of range to lock
>> + *
>> + * This function returns 1 if btrfs_lock_ordered_range does not return =
any
>> + * extents, otherwise 0.
>=20
> Why not a bool, true/false? That's all that is needed, and it's clear.
>=20
> Thanks.
>

The next version of the patch series will return bool instead of int.
=20
>> + */
>> +int btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, =
u64 end)
>> +{
>> +       struct btrfs_ordered_extent *ordered;
>> +
>> +       if (!try_lock_extent(&inode->io_tree, start, end))
>> +               return 0;
>> +
>> +       ordered =3D btrfs_lookup_ordered_range(inode, start, end - start=
 + 1);
>> +       if (!ordered)
>> +               return 1;
>> +
>> +       btrfs_put_ordered_extent(ordered);
>> +       unlock_extent(&inode->io_tree, start, end);
>> +       return 0;
>> +}
>> +
>> +
>>  static int clone_ordered_extent(struct btrfs_ordered_extent *ordered, u=
64 pos,
>>                                 u64 len)
>>  {
>> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
>> index 87792f85e2c4..ec27ebf0af4b 100644
>> --- a/fs/btrfs/ordered-data.h
>> +++ b/fs/btrfs/ordered-data.h
>> @@ -218,6 +218,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *=
fs_info, u64 nr,
>>  void btrfs_lock_and_flush_ordered_range(struct btrfs_inode *inode, u64 =
start,
>>                                         u64 end,
>>                                         struct extent_state **cached_sta=
te);
>> +int btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, =
u64 end);
>>  int btrfs_split_ordered_extent(struct btrfs_ordered_extent *ordered, u6=
4 pre,
>>                                u64 post);
>>  int __init ordered_data_init(void);
>> --
>> 2.30.2
>>
