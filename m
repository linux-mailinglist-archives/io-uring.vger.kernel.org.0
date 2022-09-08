Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D865B1119
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIHA2u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIHA2t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:28:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6108D022D;
        Wed,  7 Sep 2022 17:28:47 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287Hne4t002243;
        Wed, 7 Sep 2022 17:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=n1U+qFYZB5iN8Guc86efXhmzqLGG7tSQUIH76fOzjcg=;
 b=jUA5aqMVf517q1EQrml1v2aK/7cShJL7oO+hHS4YZZZZMfV37JCzuVztDsPTGvs1fnCW
 1NQfK1eu1d89aVN5jI9hpyeaBRpGyW12A1EChgF0LKZ3O+BjC9b3yiEDKAKGIIzuyd5t
 Bvc4IUIywiNo6cv7DIQJ6QWJzqZgcW3qdvU= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jeeecga8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 17:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWHjBXC+Qmu2lAoiqGrdUOxLDTP23F2Wv/MrIizdAiXDdKuXR+Np+bK55grt6P4HPW/y41aLMxrDqDYM508doih9RDwySJNlAVi+s4uIWwNcJ6scVYQd0srWifBgMx5tDv5gPqYTFIRHn66l7aX6w/3AbTMuezM7Z9xdjKwW7YlBCqhwmCrvrrSiS9klZic/l232RONjDROr1nOeOJnsgn/dTE4Ff3EgS6bSyA5gWisv4B3xTrIH8KXhxSVgQNPLi4m1DQkc1w7MrV+PF/ByeDaDVRW8xqbTO0ilQySze7nQ0G2jJDwfmTFz0On3BOlozbCo9JoGYAw8sp5tmILUsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SleCkK4++eTEcvNYM1bXsWjp2d8lIHUGsbsh8rhWyiY=;
 b=jqmSWUEmsYbfXB9VpOfZRsHV8Q6WEI5KEg6ZXNBUiDXOwCs0lBKceHQyyD3AlXMSC2KwWliZfrmrhXged5RuRC+hoqJgTttPHgLQJc+m3jHXpvVTc7O0VEXyOdtUW1IPGhM7EO0xLUCNPgZ2yUwXJdV/2v6l5I91Bp9W3glP44soYHYSTxjGcIXVq/XgrujZlMGZ5vYs5YKOjQ5hT3K8egnVcA7xYxsF4GDcgh6jpA++WeJXAZCzZGRtBr2e3tIq1EdZfLnZFXSwrlaZsip9YLIsHRWPM3dByg5v0S2SPouGBLEbNSePUSeF08S07sLbC4OTE202vWTlt/+C5H22UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DM6PR15MB3992.namprd15.prod.outlook.com (2603:10b6:5:2be::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.16; Thu, 8 Sep 2022 00:28:42 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 00:28:42 +0000
Message-ID: <e6b32187-1630-fc47-4c0b-2f6d595cbc89@fb.com>
Date:   Wed, 7 Sep 2022 17:28:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v1 01/10] btrfs: implement a nowait option for tree
 searches
Content-Language: en-US
To:     fdmanana@gmail.com
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220901225849.42898-1-shr@fb.com>
 <20220901225849.42898-2-shr@fb.com>
 <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::30) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DM6PR15MB3992:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0c78d2-d103-4f9e-0e7e-08da9131158d
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DOS4cGPeoxuWnNcxb0PtBifH0MB9riHtKG1M162+kr2syWLAgKw+Y22rfpVIrcC9gsDOWWnfr7/FvYcha7aP/jn2TazVgIlJgW0m4v9fzzjPd/LHif0nEN6k3Uj7h6WWwOBu+2zjBXQ4h+gU6pe+awojyNlTNKgsu2T4T+z/fMKCF6fNLnSHJKGP9x15NqI1qz0UlRE3mTkDII4s7GeUUxdOiCdVsP9MUK2ROzL1DPdp0mLhbYv9GHaP+d0/k3BXlMBJv3cESgAdB7vceXzWOPGMwYxrWC4GGZ/tgfhwdnytsDLgdFe1m+DfivOZQQsTH8dnfS6GlQDpbd6MbeINqXtU6XAe4kkJUiVCeTUHtpM24vCFDvjjufHeI6xs6Rz39KFfPc4WBHDDTCJ5St0bXynpDeHEz+ZiN5oSxqJud2acsXDbbGFa7Aq5nu2i45uqtmB85gEHxAQWULKLF1lZ5bJrDZG3mVR+JFeR78UyBUAqyK3WbTrd9dOPoKFVYXt63/j54UYQ2sxZ9xwxu1uQ4+06+1KEVlcyhpzVkrCW4QmdcKW7S7nNZMIF5Erzqvlxuz/Z2o5mU9Z38FuyZHR1YGKfKlOC9N8xmBqu4YypnVQ8gCphyLX31ievYPzibhNCNLsdOqK3A1fddmoMxqK0VI1/bWgMHvKswLTqZcTIVcNhHnchUhiapK6aKrFlD7GYXw3GnrCcVc2gFsDi9ExJZb8ZS7+vLfP3yeyCoZwr5DCQu9XhG7h0xFrw4poErMhoqE4KyvPBBjMrSf1f5sqV65syzLdtoXjMG+J8wFgLpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(186003)(478600001)(53546011)(6506007)(6512007)(41300700001)(83380400001)(38100700002)(2616005)(8936002)(5660300002)(8676002)(86362001)(31696002)(31686004)(4326008)(66946007)(66476007)(66556008)(36756003)(2906002)(6916009)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enpkSkZUVjJlOXZjekJSTW1mdkJCVmhRSkszYzZPVkRybVEzbDRwd0dZMlNp?=
 =?utf-8?B?cU9QUkRwSS9nQW0zTEkxUU1YRzVQL3ZGQTNlVjdodS9FdEEwam9UMTMxalRx?=
 =?utf-8?B?bFpidTJ4andpK1h4SUl1TXkxMG1kUkx1U01KYzVKWEEzTEhLc3NRTkhBMHQx?=
 =?utf-8?B?NDhsMzFxR2g5WlRzWnBuMzhQZW56THJqaittaVJlMkVEZzlPOG5hcFVqdkpy?=
 =?utf-8?B?alltSHVpeG9Zemx0c3h6Z0JzYnlzT0RjaDk3WUVqOWxRd3hEQVU1bDJFeWtF?=
 =?utf-8?B?WDI1b3NRVGErN21ZeVlNRklWSGtsSEY4SUMvRmlBNUp5aUZpbFEyOE81eUNk?=
 =?utf-8?B?MzdXMy8vV1UvNURuNjBaRmJkRDdWc2FuaVB0dTdHSVZXV2RuSEZPOU1DTjVu?=
 =?utf-8?B?SnozVDJpUDhIZ3J5aWNXeGo2ZVROQ2FUVVJJc29Cbks0VHdHTG5VRmN5OXJx?=
 =?utf-8?B?NWY1dTZyRm5aU2xSay93eHRFZysra3gxREdQc3dIdFNlZU5XbFpna0dDN09x?=
 =?utf-8?B?NkhUM2tKYnl6a2tCQ0tKZEVyeUtxalRrOEk5UXJ6dU9wdHBWUWZwODUxclZa?=
 =?utf-8?B?UkVIelpOc3FabHJSa3RKdGF3Z09YbHFBRk93bzNIYlNnUnlQUWtUd2pmM0c3?=
 =?utf-8?B?ZDJEY0NocVkvU2JYUzBHWGl5MG8xcDEwWkJaclhlRkF0d1lDZHpqWDJlQkpU?=
 =?utf-8?B?OU5jL2tMVGc3VE84SUZZdnJmeGFPUGNha1JWOWVHMnUyNjUzc0gxaDlYNzZy?=
 =?utf-8?B?Q3A3R1hNQXY0MENrQjNyWXNKS3ZoTmdNKzNIUDFRczdMU005VDRFMmZhS0tI?=
 =?utf-8?B?SG9CTUczdy85SlJVd2c4b2tlVnkwTTRkWGI4bWlwb3pCWWNWS2ZDUmkwYkts?=
 =?utf-8?B?dVZwMXFNL0tzRVlwNndmeXhUeUdHS1hCVVJRT0toY0poMXJWNEsxaTh4Sko3?=
 =?utf-8?B?WERMeHJqLzE4aEdPRUdodjlMUFVkS2ZnbjdRVU9jYXB1TEdCTFk3eGxGT2pM?=
 =?utf-8?B?V1Q2NnUybERPUWRGYk1VMjJES0N0ckN6UFViSFQxUk9CM2d5c2FaZFhJQmJY?=
 =?utf-8?B?UWRrL2hOdzE5R09MNnk1bVhJS2NId0kzRFVYa2ltM0RNYzF1WGNiSG1nUFA4?=
 =?utf-8?B?bEZWU1hzSmMvSzN1T1hDMzgvcEM2NUN5V2pOKzZhNlJsZU1IbjdhN1JsbEJK?=
 =?utf-8?B?SmNlWTBCSG1oQ1N1VGZvK2JoRlhOWjg3S1R4cE9uLzFjdDFISGhGLyswTHFI?=
 =?utf-8?B?bVl1UFNaNnI2bW1aei94eVh6aXg0NlZJamEyTmF3SnYvK05GWloveGNudDFK?=
 =?utf-8?B?ZTNKaStrWjllY1pNSFB2ckJaOXdoMnlzU2Y1ZUE0ZC9DaDJuN25IYU1JMGMw?=
 =?utf-8?B?dGxvOFcyQ2krSGJaeGhmU082ZjhVd1dXOFpER2ExUWUvN2crZnoxaUtRdHVz?=
 =?utf-8?B?K1p1Sk5mZ3IzZ0hhVGM2WnFIV0w1SEJ2dkJuSTNUMDF0WGxxTEg5eHFIcEZP?=
 =?utf-8?B?MVFTMHp1T3BKVUkxNHRRTGhDUFEwQVVNa0xCVzhMRTdpd2s3bC94anJnSE5F?=
 =?utf-8?B?cWxvdmVSWHRwNFJRWjJpcDlmU041MkdnMzRzMXJaaUR4U0I3NFdvOEREUFRM?=
 =?utf-8?B?QWJNNk5ienNuYVZLbVBkRGZoUm9yZkZIK3FPdlI4aFZZRm14K05mUGJ2TS8y?=
 =?utf-8?B?NHpWQmtUZUpyWXV0SklzdlNlZDFjWGtrb1RKN2hidUsvdm03TU5DWC9mL3o3?=
 =?utf-8?B?Wno3S1BNZWh6S2hKNlBuZjMwK01INERlOFh1SGpJaUZwcmZWTVdpU2dXcHZ4?=
 =?utf-8?B?K2FXdWYrQ0hjNSsrd3pUM3JhSTZObVBUcHJBVTZlTHgrc3V3Y1hSRDlvamk5?=
 =?utf-8?B?QlNpbk5UZ3VKWUI4dGhYajd4Tm1HbFRDV0Y4N1lyTllNUG9oSVFJVXp3WlRh?=
 =?utf-8?B?RTBBZHdHU3ZDWUtQcWxCV21LUzdjR2sxcndqdXlXSjZBajV2OUh4bmF6NWY3?=
 =?utf-8?B?enFML0lQc2VCZVhBNnFETkVnTkh5OXhhcTZuQzg3R0xKZXV1SVZEd0t1S0RC?=
 =?utf-8?B?dnpybDhlVS9KcEYxamhGem1ZV0JpRjdjaHdxUVBzSkExWUhsTHNWVmFnK1VW?=
 =?utf-8?B?RmIxVWE5US9zMGNqQUMrWUVuSFRwbVhWRWNqTlN2SS9NeHFZWm9UcHY4MEx5?=
 =?utf-8?B?UFE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0c78d2-d103-4f9e-0e7e-08da9131158d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 00:28:42.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HaBqe1FMR0IOryyd4jocbaYDXr9lIyQGcTfSvT7jcbiney8aSEVp/vyU4d7Dcux8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3992
X-Proofpoint-ORIG-GUID: hOJ9xLlK7rW_zSnxy8WzgTmx1k-NvQtl
X-Proofpoint-GUID: hOJ9xLlK7rW_zSnxy8WzgTmx1k-NvQtl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 9/2/22 7:48 AM, Filipe Manana wrote:
> >=20
> On Fri, Sep 2, 2022 at 12:01 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
>> or anything.  Accomplish this by adding a path->nowait flag that will
>> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
>> either of these cases.  For now we only need this for reads, so only the
>> read side is handled.  Add an ASSERT() to catch anybody trying to use
>> this for writes so they know they'll have to implement the write side.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
>>  fs/btrfs/ctree.h   |  1 +
>>  fs/btrfs/locking.c | 23 +++++++++++++++++++++++
>>  fs/btrfs/locking.h |  1 +
>>  4 files changed, 61 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index ebfa35fe1c38..052c768b2297 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, st=
ruct btrfs_path *p,
>>                         return 0;
>>                 }
>>
>> +               if (p->nowait) {
>> +                       free_extent_buffer(tmp);
>> +                       return -EWOULDBLOCK;
>> +               }
>> +
>>                 if (unlock_up)
>>                         btrfs_unlock_up_safe(p, level + 1);
>>
>> @@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, str=
uct btrfs_path *p,
>>                         ret =3D -EAGAIN;
>>
>>                 goto out;
>> +       } else if (p->nowait) {
>> +               return -EWOULDBLOCK;
>>         }
>>
>>         if (unlock_up) {
>> @@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_ge=
t_root(struct btrfs_root *root,
>>                  * We don't know the level of the root node until we act=
ually
>>                  * have it read locked
>>                  */
>> -               b =3D btrfs_read_lock_root_node(root);
>> +               if (p->nowait) {
>> +                       b =3D btrfs_try_read_lock_root_node(root);
>> +                       if (IS_ERR(b))
>> +                               return b;
>> +               } else {
>> +                       b =3D btrfs_read_lock_root_node(root);
>> +               }
>>                 level =3D btrfs_header_level(b);
>>                 if (level > write_lock_level)
>>                         goto out;
>> @@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle *=
trans, struct btrfs_root *root,
>>         WARN_ON(p->nodes[0] !=3D NULL);
>>         BUG_ON(!cow && ins_len);
>>
>> +       /*
>> +        * For now only allow nowait for read only operations.  There's =
no
>> +        * strict reason why we can't, we just only need it for reads so=
 I'm
>> +        * only implementing it for reads right now.
>> +        */
>> +       ASSERT(!p->nowait || !cow);
>> +
>>         if (ins_len < 0) {
>>                 lowest_unlock =3D 2;
>>
>> @@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle *=
trans, struct btrfs_root *root,
>>
>>         if (p->need_commit_sem) {
>>                 ASSERT(p->search_commit_root);
>> -               down_read(&fs_info->commit_root_sem);
>> +               if (p->nowait) {
>> +                       if (!down_read_trylock(&fs_info->commit_root_sem=
))
>> +                               return -EAGAIN;
>=20
> Why EAGAIN here and everywhere else EWOULDBLOCK? See below.
>=20
>> +               } else {
>> +                       down_read(&fs_info->commit_root_sem);
>> +               }
>>         }
>>
>>  again:
>> @@ -2082,7 +2107,15 @@ int btrfs_search_slot(struct btrfs_trans_handle *=
trans, struct btrfs_root *root,
>>                                 btrfs_tree_lock(b);
>>                                 p->locks[level] =3D BTRFS_WRITE_LOCK;
>>                         } else {
>> -                               btrfs_tree_read_lock(b);
>> +                               if (p->nowait) {
>> +                                       if (!btrfs_try_tree_read_lock(b)=
) {
>> +                                               free_extent_buffer(b);
>> +                                               ret =3D -EWOULDBLOCK;
>=20
> Like here, this try lock failed and we are returning EWOULDBLOCK
> instead of EAGAIN like above.
>=20
> I'm also confused because in the followup patches I don't see
> EWOULDBLOCK converted to EAGAIN to return to io_uring.
> Currently we return EAGAIN for direct IO with NOWAIT when we need to
> block or fallback to buffered IO. Does this means
> that EWOULDBLOCK is also valid, or that somehow it's special for
> buffered writes only?

EWOULDBLOCK and EAGAIN are the same. As per Jens recommendation I made it
consistent and used EAGAIN.

>=20
>> +                                               goto done;
>> +                                       }
>> +                               } else {
>> +                                       btrfs_tree_read_lock(b);
>> +                               }
>>                                 p->locks[level] =3D BTRFS_READ_LOCK;
>>                         }
>>                         p->nodes[level] =3D b;
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 9ef162dbd4bc..d6d05450198d 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -443,6 +443,7 @@ struct btrfs_path {
>>          * header (ie. sizeof(struct btrfs_item) is not included).
>>          */
>>         unsigned int search_for_extension:1;
>> +       unsigned int nowait:1;
>=20
> This misses several other places that relate to searches outside
> btrfs_search_slot().
> E.g. btrfs_search_old_slot(), btrfs_next_old_leaf() (used by
> btrfs_next_leaf()), btrfs_search_forward() - possibly others too.
>=20
> I understand those places were not changed because they're not needed
> in the buffered write path (nor direct IO).
>=20

I added warnings for these functions.

> For the sake of completeness, should we deal with them, or at least
> add an ASSERT in case path->nowait is set so that we don't forget
> about them
> in case in the future we get those other paths used in a NOWAIT
> context (and that would be easy to miss).
>=20
> Otherwise, it looks good to me.
>=20
> Thanks.
>=20
>>  };
>>  #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info=
) >> 4) - \
>>                                         sizeof(struct btrfs_item))
>> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
>> index 9063072b399b..acc6ffeb2cda 100644
>> --- a/fs/btrfs/locking.c
>> +++ b/fs/btrfs/locking.c
>> @@ -285,6 +285,29 @@ struct extent_buffer *btrfs_read_lock_root_node(str=
uct btrfs_root *root)
>>         return eb;
>>  }
>>
>> +/*
>> + * Loop around taking references on and locking the root node of the tr=
ee in
>> + * nowait mode until we end up with a lock on the root node or returnin=
g to
>> + * avoid blocking.
>> + *
>> + * Return: root extent buffer with read lock held or -EWOULDBLOCK.
>> + */
>> +struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *=
root)
>> +{
>> +       struct extent_buffer *eb;
>> +
>> +       while (1) {
>> +               eb =3D btrfs_root_node(root);
>> +               if (!btrfs_try_tree_read_lock(eb))
>> +                       return ERR_PTR(-EWOULDBLOCK);
>> +               if (eb =3D=3D root->node)
>> +                       break;
>> +               btrfs_tree_read_unlock(eb);
>> +               free_extent_buffer(eb);
>> +       }
>> +       return eb;
>> +}
>> +
>>  /*
>>   * DREW locks
>>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
>> index ab268be09bb5..490c7a79e995 100644
>> --- a/fs/btrfs/locking.h
>> +++ b/fs/btrfs/locking.h
>> @@ -94,6 +94,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb);
>>  int btrfs_try_tree_write_lock(struct extent_buffer *eb);
>>  struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
>>  struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root=
);
>> +struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *=
root);
>>
>>  #ifdef CONFIG_BTRFS_DEBUG
>>  static inline void btrfs_assert_tree_write_locked(struct extent_buffer =
*eb)
>> --
>> 2.30.2
>>
>=20
>=20
