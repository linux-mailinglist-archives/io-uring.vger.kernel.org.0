Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9650B5B2688
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 21:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiIHTLD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 15:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiIHTLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 15:11:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6E2EC756;
        Thu,  8 Sep 2022 12:10:58 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 288IJ89O019888;
        Thu, 8 Sep 2022 12:10:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=NVWkN3Q88VbQmqmGztSlCIKaFwCTtcHFO7oOONS2pFc=;
 b=gEn5ROM0Kjrj6oKLq0RXahWCsdOna4Jy9/dhu2YhO+zDgNkazOU2vR3SoWQ5N+tTVVPl
 JF5x19vZu0VfyskF8okHvWYCwQsHNJGfZoVCCPvnyVKJ0LZSf8W46h1GTsBbBTPqqo20
 GcfAVOo9d2p8JWChqCLq02FD1kfCDMWYJ74= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jevdaj8yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 12:10:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YijROsPfssiAVOC9yPdGuD7D3xYBXDkPZ6wHZtzuTlmo9IYUNBnNO3sk8IjDvydJYfUKkA0+7oexqUceewVUtWZmDLer9gcOdHeKXho/vbQxmQw6hotXvZ2FPZ/WfARnJLrJ2ZcDGfY5ZshJs5Eu4cAysdLKWcQufplmGKsH/CJ4Glvpr7XFDZTgL/kLg9Iniy2LI+ODwma81moxPWjWGDLJ0q0ABWARPuySfsll7dY9tfV1KPx6jnGH+1Clh/jUMjmUMrM2Q/A59Yd4Tga9lQ1dIz0nDnn5saUgTsKPvi6Ks+0DLO+Biv2uX5VbaY+Vxn0vrXQaOhkUaHHC/Y9/lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRHh5/4GzrX+NyVo8at6wMLOuOXNSk4QHZgYQPhLzEI=;
 b=IxlbA2A/fBxfb3G8T95wpkSg3c4TB4rkFJrmxYJjgC9WTgLeaGrQBYHCZ04tGh5uquZkoA61QSBAf/C3TtOpRTVmZLteCBijebyYSjtDdQ/qidbX7c4/KuWYbvRisPj09uyiVo8YDnL6fOa35jHczRQYZbtrqmkjL89qOfF7WOXtlVmS04bkjO2oCRc58P+lR9xIXoFiGhqXv9ERhYnRuAGusETt6GmkaYK9poJPjZIWhipbCyDRTfsH84fZWQGaKE5LqfYWs4lJexndObs53C2ARlyx6G44chE1TARQI/FJFRyIZiZPjRureCeVXZot3V2xoioZgcxQDV55Ou07HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 SN6PR1501MB4125.namprd15.prod.outlook.com (2603:10b6:805:5f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 19:10:52 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 19:10:52 +0000
Message-ID: <8c90b8d1-11f3-316f-7ea3-3a000afb233e@fb.com>
Date:   Thu, 8 Sep 2022 12:10:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 11/12] btrfs: add assert to search functions
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-12-shr@fb.com>
 <CAL3q7H56dfcQP+vMK0T22nJwZQ=Qq217wT=idkHZdW4J4ar9fQ@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H56dfcQP+vMK0T22nJwZQ=Qq217wT=idkHZdW4J4ar9fQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::38) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|SN6PR1501MB4125:EE_
X-MS-Office365-Filtering-Correlation-Id: cedac2fc-54a2-4b8a-8bf6-08da91cdd93b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCZ+GVVppN3ZZ25IeoUdh6/SPtJX/rHLPKUnWxbia9w025kjzO/Fxf5YyB57tj/lACow2OU7FLf4cZIhzKfTWimb0B93RiCdakz5SXtfQg3Q6oa9O+c1zrVDCne62GVNw/QQbOVwvkUc2ecnZizFSUkotZoFPOwMqC2cdwfqWlnCg82+ouyL/mM9wIbGPxZr99PPuUkH6jMXCiT0dB7S9h1GqzUKO3pFA1eS9Zr6Fx7t5cNezDhBPeBB/37upMkxMZCSkwjRjdSUpykG4LvqCXlEH+dSwQK2lOjGuIa3iMYZ4peYUs0OWTYY7jQJ/Y9MQkPoWSj0POg2lEl46xBavR4kMkS2pePLGnej8xKMnL+EUex3d6KnfN40v9utjChDRCy4bEgEmsT6aEY6HZPKPoTUcWZ2arr4VqxHlFsl/S30fmkTf+qZgDwnBEsxfSL2xxv5ZSmYwbmR/l2iyAGMuHytFsu9hxdk93RzpWvqIUcmlWZ4zgaQwP+16/1FQtj1+POIl7fUUDFvHI5Qu/tFQYTNxn0q6PUuqVEGav8FJO19OPQRhpALWpAHvCIxXFPTtp1I/oSviOYDcU4KSGx/QneJ5H+IOAiXh6tBqFvsPhd5mIqamX1K2hLDO98X1bHosFAqd9iQQB35pHgIRNrtFb+F+7XkkMcabFtjKDcq9KiRuq+QSWASREQTdr7tK70lmX0xUD47QTThgArd2a++1tyjsroEpHM9GVvsf+ohJoSvlWTbT/BkF4NOYSDP/eS7av6mihNk2y6JYx3CziUGH1lYtiAQm0eMqQz1p+dEVic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(6506007)(53546011)(6916009)(6486002)(41300700001)(478600001)(31696002)(86362001)(38100700002)(6512007)(316002)(66556008)(2616005)(186003)(83380400001)(66476007)(31686004)(2906002)(4326008)(8936002)(5660300002)(36756003)(8676002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0YzUWQyTXNTei9tMEgzenVxamc1dTYzMGlzR0tLQlN4aDl2OThkY0JQNS9Z?=
 =?utf-8?B?TzZqMU5Ua01aZXNMcWVyR0J5VmVkcllzQ2NlS0F6dDlnOXNHLzlGRVlPRzhk?=
 =?utf-8?B?YXN0aGZ6WG91eDhidXNMemdwbDQ5b3lLN05ZbW1PMVBjTk45OTNTNVhKTGpq?=
 =?utf-8?B?VTFQVU5RL2oxQW9jekRzbjk0OG9uSzJmWGp0UlhMRFBIWDdTTitjWG9vNm41?=
 =?utf-8?B?T1VnbkhnNUFzNHZGSXlvNkwybTRGWHQ0VkFGZGtRdzNTUWlWWGRLV0pRSTNw?=
 =?utf-8?B?N25XVmVEMXJrWDlTWW91QUZhRjhreUh1ZE4wWElCMTJLbzVuSDBTeW1Bb1Fp?=
 =?utf-8?B?Z2VYMFo0b3ZyUXR1K3JRVzQwMWdHZWJvdmNxS0hTUU91eUxwZkIrdDhtY2Vm?=
 =?utf-8?B?dWtoTDdIY0ZVdzRrSmhEOVh0UGVZK2NBSU4yeUZjTm5zTFdiVlNYTDd1a1JH?=
 =?utf-8?B?bWZuYkIzekdzdFhFT1NJcjRoeUVDeDcvY1RSdS9ob0lCQkRlY05ja0JmSm1L?=
 =?utf-8?B?aXBwK0ZjVTlzOFE1dnJ4Tk9SVFBGUUdOZE5PWVBPdlZMUDVXcXEwajMzTTBD?=
 =?utf-8?B?TEFZM3FDckRQbTZ5cXFRd2R4WTVvcTZNQ1JSV216Q1hBd1hnNithdGtJQUFk?=
 =?utf-8?B?dVk1ejRkQjN3NkFMcERqS1VTRW9UbGJabWhaNHBXKzNvaENiSFllS2pkeXBX?=
 =?utf-8?B?Z0t1bnZhNmVIeXlXazFCMXZhUzV1cmQ5ZW51S245T0d1cGh5WTE0ZGlUcnkr?=
 =?utf-8?B?UmdpSjllZXVPUHNFTXdkMEU2NHlveVE1U1JxbnJZb3FPajA1am03NFNRd3My?=
 =?utf-8?B?WXAzNVhKSnZGbUNVNCtDMWphT2puMUJlMWNicUI4L2sxQklDVExKY3B2OVRT?=
 =?utf-8?B?VXk3YksxNHdjTFlkRStKNTBqeDdFTHlWOERKbU0yOHFIaktwSjZkVEM1a1Jy?=
 =?utf-8?B?bE9FN0lZZDI2VlpXeGQvMHByam5KeUx6TWVNcVpWM3d5K3BzekQ1eXhKUVdq?=
 =?utf-8?B?b010L2RZeU80ZXozL1pYSlhQYnY3Q3dROUtxbDZTOTRsVWprNzBlbjl0UStD?=
 =?utf-8?B?RTR0SWlOd1RUME44anVSdWxNVTdLaFhHVE1aUmJYaFp3NDQrWlFlajNiemR5?=
 =?utf-8?B?QzlkdFNLbnJIM241cGtmT1IzeitzSlZtWUl5WHprcjUvYUEvYkJ1bitwZVVL?=
 =?utf-8?B?OHhmVFA4VHE5bExsL3pUZ0lHM1NTTjl3MkZkTmQzbiszbGZOd3dqUW5ub1hY?=
 =?utf-8?B?dUZGRDUrWjRZTEpmN1ZHSm01a0xseDA2WHg5dnJ5cTdISGpoUzVEd0xlTUdu?=
 =?utf-8?B?VDhlNWR5UTZUeHpadzlPc2pvK0hrVmpDd3o4RzBvUnJaZlJ5MFRkd3g3RXkv?=
 =?utf-8?B?S3FLUTJQN3RTUUNzUm5ocVZiZHJsbjNaU2JmbG13UUVXanIxYlV4YU5POG9W?=
 =?utf-8?B?TWlaS0lXcm5IY0FDK2dQZ1ZjY1BPSHdEN0k4NnVRODZpNXhmTWk4VDZlQVhF?=
 =?utf-8?B?NjJFVGtINS8yaEtVakZOTGdFR0tub3Y5WmxOdmd1ekFSYjlCMDZNL3M2Y2R4?=
 =?utf-8?B?NTdaZHBOMzNBYnVXWWM1OEM5UXJPQUxUaWxwQXREeDBKL0M1SjlDczBuYi9F?=
 =?utf-8?B?ZFltK2EzeVNZM3V0VjRIMEIyalZ1UGszN0MwUkh6N2d0SjZBZ0Rzb3Rmd21a?=
 =?utf-8?B?V3VjWFhBNUc5Q0lBUUZPclBkd2tPUS9JWEhIcUpCcVRObzBqUm5kK0NyOXVI?=
 =?utf-8?B?bjBHNE9yMUI5bGIvUC8vNGZsT2lKNzlXdGlBbHdUaitJZGhVLzRHK3ZGSUxZ?=
 =?utf-8?B?b3l2ZDJ1Q0Q2MXY4cytWM0dVWVIrV1pPY04veUZIc1hvYVRTZzZYa05laHdh?=
 =?utf-8?B?U1Bsc3NXN1lKVlB6Mmc3cEFhQk53RmhlbFk3V1pwYlVUbWk4RzNDcW8vdlFQ?=
 =?utf-8?B?SGZBa09GamdjMDNhUVo0bi9wMWo0dTRwUHo4bFZhN0V5SFpmeVdvQnNpS1Fl?=
 =?utf-8?B?VFpMek8vcmlIWk4veFRBRWZEVEs0ZlE4ZDVyQ0dFaUlXd0cvNkdPU3VDcmdp?=
 =?utf-8?B?dXRNdVE2TTdlV0dCM1VzMDlXRmlZU0h6OU5QeTBzSjJ3UC9VVTViYjEyYjQy?=
 =?utf-8?B?MTg3dkJjYkZSTmdERG8vcnFSN0dXNStoOEF2enptQmI0OFFHbXFPK3BNVjA1?=
 =?utf-8?B?ekE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cedac2fc-54a2-4b8a-8bf6-08da91cdd93b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 19:10:52.7259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkDdqZCyJFmMlzvg+GUwUVVUAz+feHovjtl1kX48BQdGbM+4uWuQTghXJj6tR9oF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4125
X-Proofpoint-GUID: NBPLhL1NYEX4OCwc9SeQWkAjLB-ZlS-y
X-Proofpoint-ORIG-GUID: NBPLhL1NYEX4OCwc9SeQWkAjLB-ZlS-y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_11,2022-09-08_01,2022-06-22_01
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



On 9/8/22 3:15 AM, Filipe Manana wrote:
> >=20
> On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds warnings to search functions, which should not have the nowait
>> flag set when called.
>=20
> This could be more clear, by saying btree search functions which are
> not used for the buffered IO
> and direct IO paths, which are the only users of nowait btree searches.
>=20
> Also the subject: "btrfs: add assert to search functions"
>=20
> Mentions assert, but the code adds warnings, which are not the same.
> It could also be more clear like:   "btrfs: assert nowait mode is not
> used for some btree search functions''
>=20

I rephrased the commit message.

>=20
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/ctree.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 71b238364939..9caf0f87cbcb 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2165,6 +2165,9 @@ int btrfs_search_old_slot(struct btrfs_root *root,=
 const struct btrfs_key *key,
>>         lowest_level =3D p->lowest_level;
>>         WARN_ON(p->nodes[0] !=3D NULL);
>>
>> +       if (WARN_ON_ONCE(p->nowait =3D=3D 1))
>=20
> This doesn't follow the existing code style, which is to treat path
> members as booleans, and just do:
>=20
> WARN_ON_ONCE(p->nowait)
>=20
> I.e., no explicit " =3D=3D 1"
>=20
> As this is a developer thing, I would use ASSERT() instead.
>=20
> For release builds that typically have CONFIG_BTRFS_ASSERT not set
> (like Ubuntu and Debian), it would
> still allow the search to continue, which is fine from a functional
> perspective, since not respecting nowait
> semantics is just a performance thing.
>=20

The next version of the patch series will use ASSERT.

> Thanks.
>=20
>=20
>> +               return -EINVAL;
>> +
>>         if (p->search_commit_root) {
>>                 BUG_ON(time_seq);
>>                 return btrfs_search_slot(NULL, root, key, p, 0, 0);
>> @@ -4465,6 +4468,9 @@ int btrfs_search_forward(struct btrfs_root *root, =
struct btrfs_key *min_key,
>>         int ret =3D 1;
>>         int keep_locks =3D path->keep_locks;
>>
>> +       if (WARN_ON_ONCE(path->nowait =3D=3D 1))
>> +               return -EINVAL;
>> +
>>         path->keep_locks =3D 1;
>>  again:
>>         cur =3D btrfs_read_lock_root_node(root);
>> @@ -4645,6 +4651,9 @@ int btrfs_next_old_leaf(struct btrfs_root *root, s=
truct btrfs_path *path,
>>         int ret;
>>         int i;
>>
>> +       if (WARN_ON_ONCE(path->nowait =3D=3D 1))
>> +               return -EINVAL;
>> +
>>         nritems =3D btrfs_header_nritems(path->nodes[0]);
>>         if (nritems =3D=3D 0)
>>                 return 1;
>> --
>> 2.30.2
>>
