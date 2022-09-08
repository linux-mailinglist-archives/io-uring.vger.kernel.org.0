Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0825B1126
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiIHAaJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiIHAaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:30:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2736E51A0C;
        Wed,  7 Sep 2022 17:29:44 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287Hne1F022032;
        Wed, 7 Sep 2022 17:29:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=c/kb0iYCEo3RCnKgbeCRVHgEQJObrf4JeHZGjmLFP/0=;
 b=Zb94k/Rbs9UhMcm4tnmPoBax7qeHis2g4wkz6xbcDVnC6kICpvcTtr4XOqv8zBUjMgyk
 9pLTLM1G7kKJXSn7y3+VPo4qGlquoZOW8QUHYHEebUCZ23kTLdQokYwXDFh4cZgDeAXn
 s3au87OnFL1bGrbnmOiGgBhs11n2R82uTE4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3je87guhwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 17:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=an8ky5oCDORJQbvx0rIwE2LSGLMaMQHI8xnzJRFE2L8H20G4V4DAueLwU+8BmdF6+KyyybB18a9YgdQfEYvZQIuBDvuIje+S7pF5smcrUmwQaRP9/COXWlGLWwCAS5Hm+ytj4VnBOtXh+rIhbT7LFBsKSzNTxpYG/VMYwb0cjvwDhwJLnyUG9bpssR1Hzvo97HocOWIdbD3XeL1y2nPHX5ZeazEr3D7tng5wzfVHJimpzAMh+ITdakZImSB3ZhGhkJ7ZYKXJPhh0yfCB1Hpc2jX4RZFodHob3R8m0VrBdKkEcezyunJARYifNtZVFSzpS3OzGIqIySZTkkvNl0lZrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tt6V3BlduBd7gL4V3ZEXtzcVxyr5jX/eLc3M334lYkA=;
 b=h4vkEj5ZHKtUjGbieLEhyOvKK1Xa/dimBIDV+RRuUycedzyUr+mZEnvvueyoR8raWqv9mJef1AMXog1KcCsR23un+4mb97t2TXCrj3Lte3WgHUV18lknlOTCwT1UY3KLE0wvPzWW2X8m9CW51eSpQcq8SiH4Q9XS8lemm2fzw39xHoMaeEH3MZeU7d1Su/CnEDkRYFi6Wb7OwACQ3i2FSE6xcD5PtFJd9fSWDZHYk4Bsr0Q2esPwOXV1/RA/Wy6u73AZ03f1Y+mPbG6Rav+CD5cUg8GTwBXp42VuZssAUkUbFvn+84cpWV8c3EGrQTwaT5NeBjo5jzOiK6VPMG3+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DM6PR15MB3099.namprd15.prod.outlook.com (2603:10b6:5:145::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.17; Thu, 8 Sep 2022 00:29:27 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 00:29:27 +0000
Message-ID: <05400f80-094b-1149-65eb-88458c7a43ce@fb.com>
Date:   Wed, 7 Sep 2022 17:29:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v1 01/10] btrfs: implement a nowait option for tree
 searches
Content-Language: en-US
To:     fdmanana@gmail.com, Jens Axboe <axboe@kernel.dk>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
References: <20220901225849.42898-1-shr@fb.com>
 <20220901225849.42898-2-shr@fb.com>
 <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com>
 <d42ec471-b67f-6504-72bf-8bbc761ac3e7@kernel.dk>
 <CAL3q7H6GLm+hbcJP5Mc0mjyFcWX-8wGD9LVJeYUE6HmgoZK1Vg@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H6GLm+hbcJP5Mc0mjyFcWX-8wGD9LVJeYUE6HmgoZK1Vg@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0114.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::29) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DM6PR15MB3099:EE_
X-MS-Office365-Filtering-Correlation-Id: d40c682d-dc1f-4796-91ee-08da91313049
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WeJku5XJO6W3aGOU9idkxdM9RWcwQoDf/K7hlgxtC/6MBjJJpA4ehUDsd1f00KbzOuKFXuIIFFPi+seBVcRnYoBfPbz2G4JTrb2vZbd7qDX21XQM2lOwm59UuagcvbXsMZJVvL/e3JONXQFNEj7t9v8L2ryjogSoAD5HRS1/Db1e8U8bE0r/6jNyp+dejItt35cjMtmGdu9MY9JLFMf2en3fiU+ql+KBfwoQgk2t7+Fu6ENxl7kCQg9lqlGz24wVZHyvfqngTo88CvG40GhLC/27TZq9y4/2xq/2I2Qk59662QBBk+4RhcK/a8WaUIUtt80PU99h2VVmNMf1zd78QmDDJdL99rsZUWQnLFQtdQ7MmYobKiq08nkEnaSbfwNMQ5QXLZyh8mBfFSqdvFbAHM6jeVsR2WGuzQG49cCfokIWwTiev9/bEYgD1HbKL5mEPysNH145+RKr4Z6ZUesoa2VfA659sY5PRxQX7OxQwpey3pMZjUfC28sUY2B8VdWnKfChJyaHbahS8r38cEhRu2bVNMZP0cqnsXXyUXHWcP5EbNOpOhZAlxNYwbjWoVeKdWaM8cyoSRx4rBx1GM1FnZM/PG/S0OwaTxLAUmNX8lZGt2kq7hOlUxnij3nl/yuyeGUufHqwNe+bvlKkvAOKsWp/gckpbYEDuSG/vE0F8rpnO7gHnzBBjKFhofgsSVWGDn2CemcwyrEupGiKTlAo5s2icuYJRo8DhjxGG+EIwzUIqU39ENpbiSjdJ//aDIRHo3V6opLipt3FkdMbcqklqgrXyv974TMOZ3CiJe8A2Zg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(38100700002)(6506007)(6512007)(5660300002)(53546011)(66946007)(66556008)(66476007)(36756003)(8936002)(83380400001)(8676002)(2616005)(86362001)(31686004)(6486002)(316002)(478600001)(2906002)(31696002)(186003)(4326008)(6916009)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0c4bFpPT1BEdFgyZzN4Qk9LLzNzTWpNK0pRUXlUWFVLUTJoRFhWWGl2UVE3?=
 =?utf-8?B?akxIK1JSQzdjRkxVdDQyaEY5amFhNUxEYXNhMUxxMnR5aEQ1MmFQWjBtNDVv?=
 =?utf-8?B?Z1RXb2VSeWIwUkplSTFkSjZVL21ZYWU4c29IZlZMcGFKWTlWTmdzYzNLUUNR?=
 =?utf-8?B?c0lTZE5yeTZwclNUdWhaek53bHNIMjNSSDNXY2ZsZWhNZHRiNjZQSzBuN1pj?=
 =?utf-8?B?OHdoL0psRXRVSXcxZ0Z1OURHYURoT1hLL1ljalUwdHlCMVV6c2lQVS9heW8y?=
 =?utf-8?B?TC9QOGl5YmxqZ0Q2SnFibFZxQWcrZHB5cHM5dEl5cmN6K0VGTk1Ed3pqTjRK?=
 =?utf-8?B?aGhmd0YvWkVsc2FzWkNHQWVlOW90MS9SMkx1OGxNRVRNZUd6bERFNk5URTJ3?=
 =?utf-8?B?KzR2SEZId1dmUlg1a3BHeW5iczBzL2pYZWFWQ00vcXQveVJOaVZTVzlQOG5r?=
 =?utf-8?B?WkNQSzNBM1Z4MGkveXpOSUxxSDZsYWZtZjNSVk5LeTBRSnozdlA0WXJrSU5V?=
 =?utf-8?B?VmUrMkFnT3VqdjRjbDJTdHJueHBVK2R0ZlNlUWlCR1dlTWYyQ1VuOUtKaW5O?=
 =?utf-8?B?SEZLbnNxNkN5a3B1aXFsSVZKbW5pYnF6RXQyL2FRSi9oR01NdlM5d1FmYS9R?=
 =?utf-8?B?djQrdGZqdVJSNHFTMk0yNE1LUkpKQ3czdkNkdFhZVmJsb2QrYlBPNmllOTRm?=
 =?utf-8?B?d05BOEVISUt5Nm56TW9QMG9RUmZ5N0gwaTNCVzNRU0Z4dWVyWW5ia1MyQkhM?=
 =?utf-8?B?SUd5V2VSS1FHellGSUgvRGRybUpZOEtYNFNqcFdKUXZQcU16SDF1eTJGODhS?=
 =?utf-8?B?blZqaGljRnY4bjZyam45eWFIL3JaalMxcUtleHVZQ2w3eUt5Y1gvSTR3ckwy?=
 =?utf-8?B?bUQzZnJKU053bHg1SmwwMnpvd3JpQ09nd3A4QU9pTlN4SmIxbHFpSWhCTGpR?=
 =?utf-8?B?UUlTOVh3eU9PdzVqcXdhZUpvZS9pRnB5Q0YzUUZ5bEJIK0t1SHI2Z3I5SlFh?=
 =?utf-8?B?N2RKTitoZ1pyMDFIaHc3cUN4amlIRUFEdDZEU0NzWjRGS2JPN2tveHZFMERr?=
 =?utf-8?B?WnM5a1E4cE1UN21XUWIyWHRnWUEwWmlkYk1OQkdIeWhYWUFZaDJ4dnBHZHJT?=
 =?utf-8?B?bXo1R2xsQ0FtM2tSQnRyd3EvZHlmdDdxVjVpd2RpR2hWMHlhT083akE5c2Vk?=
 =?utf-8?B?NndBTkZjRUtBSUFJenFwY1N0MjgzOGkvcGwwcDNuRS9TOVRHUjg4dW5FT1lj?=
 =?utf-8?B?aXQxVG1wYVhIUk9RdHBMS3Z5TUZYSmNoVTU5bk0vWUM0ZmRxVnRRSmJWYmgz?=
 =?utf-8?B?a1Voam41YTlzbGNFaUZxU1ZMTVdrQkpPOFI0cTJueExKSEIrK3IzREtKZ01I?=
 =?utf-8?B?OWg3TjAraXFXMWxVRlV3U2krM1lvYzY4NWxBajNFK2VuVFJOOFlHVTN1WENx?=
 =?utf-8?B?cTkxK0FFRi9DM3JtdmxkeEc3cFlVQUo0TisvelpoN3FvYm4va3REMisvSmhz?=
 =?utf-8?B?Y0xXdGlJYjFlZFJ0RzRjazFRMDR3UG90dmpGcy8zeVlTclJBL0tOZG5SNFVZ?=
 =?utf-8?B?MzVvUTdMUWUyeFQyU3EzWEFtYjVNQ1BQNlRTem9kUWt6YU93cTVEZkY3dXkz?=
 =?utf-8?B?WUVxK3BmZ3ZtL0V1S0Y3bUtzSTdKZTgvTnQvYVRrU1hSbUFaUXNSNjFvaG5H?=
 =?utf-8?B?NG91TlVqMWhibmw1ZjRSSjRRR2tiMGk1cCs5eThGSlZObWRPTjlSbHZHcHp2?=
 =?utf-8?B?S3VONURTaXRUMDR3cFdROE90SzJ4dERwTS9OcW5YZnlFVWU2ZVZjN2xoQWRO?=
 =?utf-8?B?QjNyb0xwOGl1WVBLMWNNSE92M0czMHBBcTBiYWZkQ1cvaWtyNFZ0ZFI2dmFE?=
 =?utf-8?B?L3A3aFY1cWdqaHpaMHJJc0hna09XWllXeFpYcElkNlJLVVU0WTRCOTBsSjFS?=
 =?utf-8?B?M1ZyM3c4M0FZNE5BOVJOU0tvd29xL09aNFVmK0x2M0szdEpUT0JNWGp6SkZu?=
 =?utf-8?B?VVVBNGF0QzROaVAvaFRuSnhkUnd0SjZETlZqU1loR0ExSkJzMFBGVExKcXpy?=
 =?utf-8?B?MXNtblFhUWF5NG9DTWtxV3EwQnJjeGtpeEhGVzRDdmh1TldLcno1Smp1MGJj?=
 =?utf-8?Q?HpPH7Dy3BlI1SmYZiBMlOAjFO?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40c682d-dc1f-4796-91ee-08da91313049
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 00:29:27.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VkhpCUfmiiL7RMm6elaZVqH3MqwWazapPAomv5W/YYFTI0S5kuHThWHHVxOaKsDs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3099
X-Proofpoint-ORIG-GUID: U1nawVCZenwyax_qOocMb_s0ukQz1L87
X-Proofpoint-GUID: U1nawVCZenwyax_qOocMb_s0ukQz1L87
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



On 9/2/22 8:04 AM, Filipe Manana wrote:
> >=20
> On Fri, Sep 2, 2022 at 3:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/2/22 8:48 AM, Filipe Manana wrote:
>>> On Fri, Sep 2, 2022 at 12:01 AM Stefan Roesch <shr@fb.com> wrote:
>>>>
>>>> From: Josef Bacik <josef@toxicpanda.com>
>>>>
>>>> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
>>>> or anything.  Accomplish this by adding a path->nowait flag that will
>>>> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
>>>> either of these cases.  For now we only need this for reads, so only t=
he
>>>> read side is handled.  Add an ASSERT() to catch anybody trying to use
>>>> this for writes so they know they'll have to implement the write side.
>>>>
>>>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>>> ---
>>>>  fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
>>>>  fs/btrfs/ctree.h   |  1 +
>>>>  fs/btrfs/locking.c | 23 +++++++++++++++++++++++
>>>>  fs/btrfs/locking.h |  1 +
>>>>  4 files changed, 61 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>>> index ebfa35fe1c38..052c768b2297 100644
>>>> --- a/fs/btrfs/ctree.c
>>>> +++ b/fs/btrfs/ctree.c
>>>> @@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, =
struct btrfs_path *p,
>>>>                         return 0;
>>>>                 }
>>>>
>>>> +               if (p->nowait) {
>>>> +                       free_extent_buffer(tmp);
>>>> +                       return -EWOULDBLOCK;
>>>> +               }
>>>> +
>>>>                 if (unlock_up)
>>>>                         btrfs_unlock_up_safe(p, level + 1);
>>>>
>>>> @@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, s=
truct btrfs_path *p,
>>>>                         ret =3D -EAGAIN;
>>>>
>>>>                 goto out;
>>>> +       } else if (p->nowait) {
>>>> +               return -EWOULDBLOCK;
>>>>         }
>>>>
>>>>         if (unlock_up) {
>>>> @@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_=
get_root(struct btrfs_root *root,
>>>>                  * We don't know the level of the root node until we a=
ctually
>>>>                  * have it read locked
>>>>                  */
>>>> -               b =3D btrfs_read_lock_root_node(root);
>>>> +               if (p->nowait) {
>>>> +                       b =3D btrfs_try_read_lock_root_node(root);
>>>> +                       if (IS_ERR(b))
>>>> +                               return b;
>>>> +               } else {
>>>> +                       b =3D btrfs_read_lock_root_node(root);
>>>> +               }
>>>>                 level =3D btrfs_header_level(b);
>>>>                 if (level > write_lock_level)
>>>>                         goto out;
>>>> @@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle=
 *trans, struct btrfs_root *root,
>>>>         WARN_ON(p->nodes[0] !=3D NULL);
>>>>         BUG_ON(!cow && ins_len);
>>>>
>>>> +       /*
>>>> +        * For now only allow nowait for read only operations.  There'=
s no
>>>> +        * strict reason why we can't, we just only need it for reads =
so I'm
>>>> +        * only implementing it for reads right now.
>>>> +        */
>>>> +       ASSERT(!p->nowait || !cow);
>>>> +
>>>>         if (ins_len < 0) {
>>>>                 lowest_unlock =3D 2;
>>>>
>>>> @@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle=
 *trans, struct btrfs_root *root,
>>>>
>>>>         if (p->need_commit_sem) {
>>>>                 ASSERT(p->search_commit_root);
>>>> -               down_read(&fs_info->commit_root_sem);
>>>> +               if (p->nowait) {
>>>> +                       if (!down_read_trylock(&fs_info->commit_root_s=
em))
>>>> +                               return -EAGAIN;
>>>
>>> Why EAGAIN here and everywhere else EWOULDBLOCK? See below.
>>
>> Is EWOULDBLOCK ever different from EAGAIN? But it should be used
>> consistently, EAGAIN would be the return of choice for that.
>=20
> Oh right, EWOULDBLOCK is defined as EAGAIN, same values.
> It would be best to use the same everywhere, avoiding confusion...
>=20

I changed it to EAGAIN in the patch series.
>>
>> --
>> Jens Axboe
>=20
>=20
>=20
