Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9C5B260F
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiIHSpZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiIHSpQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:45:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0DD558EF;
        Thu,  8 Sep 2022 11:45:07 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288IJA8x019422;
        Thu, 8 Sep 2022 11:45:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=Erlyp9m2QnCtoI8u0/2dlW7vmdEQp2DFzhCJEWh3Dd0=;
 b=CRZeRtFD+GwVQ/beJVG0waRTgj1TY3e9M8wEoStTkMO0EUcs1jKAUblgMttZ9E849POf
 90MeNaO2dBH/eV6ZxePdxlB9LSzyYjEJqsWwXbShHlxU5TsVTrKpwnBV18Yg8YR1zUfq
 X2fYf2Vlbth5y0h1G3jFdXYIqbqHIT6eqfY= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jeeecp1tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:45:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k33eTtbOzWFKYwtiOrK1TRfIZkMCmm8hGTA3J3jddm02p8273fJq+r6Bt9zbEOywxc7sTwUdyWyHDR1e+j4JKukTNJF9AagVcpgpVP5n73gawp5oguXmiXSdZhdUEfKd02XNjZ3ilZ+bLdaNHu4ItP6cleT28yIC7iAOcocEM8cty7SffdFqFaigk2cZSAi7RVAwZSJ6vfO5zbb3DkRjcTF27utd/SG9+ZHEyOY7aUZeKePhmSoCUtfSVal2HLJA7kuNqqlh27t2S5Rs8PkyrrIl2t/BwC0ju/wh9IUbBisJB2kIvh7lql9zRyc50QHSh3fjBbBwKEfuRxceiM6AkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2GqwED6kdhRAYGG6KG1NZVadJ/iUrG8aWUWrxoS0B8=;
 b=cUHd3d2zFZNwqfV3qJvLayp2A2dC0SiWS4gBG8P5BlOVJAm7lsqJ6h34JaWmqBrGarelfRTLEvPJy7EmteGnni0dbebKQx1AefWWpI3C/biYT0oPdKCRRkycEWEvYSJ8EAF57Hqu9uEb6tB7WpbEMKcKJjE7cy8+8d6sdL9t5c8M6DJl+YQLWDNcMHNbiYfAjoc2NfybZsDOarYMUfRWzuClb1JQz8NiYsZR8y/Xxudnl4yd3II6/Az+46BFV/Dvy2NWXsCuxN4S4hz0xQSSp4ur6FLWFMmma/00dc+fyvkL8w93H0zQUNC0WZHoFNS94Ql+6wydjfRXJzDFDauEwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 SA0PR15MB4013.namprd15.prod.outlook.com (2603:10b6:806:8b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.15; Thu, 8 Sep 2022 18:45:01 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:45:00 +0000
Message-ID: <6c00b36c-9bb5-8186-d4c2-16c92b44df48@fb.com>
Date:   Thu, 8 Sep 2022 11:44:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 09/12] btrfs: btrfs: plumb NOWAIT through the write
 path
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-10-shr@fb.com>
 <CAL3q7H5Pij0A5G9vEFHKrgUSQuhUA8U6Eh9oAhKRcjeex19U=Q@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H5Pij0A5G9vEFHKrgUSQuhUA8U6Eh9oAhKRcjeex19U=Q@mail.gmail.com>
X-ClientProxiedBy: BY3PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::32) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|SA0PR15MB4013:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b9d150-b162-4514-734b-08da91ca3c4c
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8P71kt+MXJxi/rheRgaGCVLNqevS8V+QPWFLKM3i7UTFfIIe8XldDm+HsYEA8DYl6OvDsRVARCba3IZj89PGONBEKaIw80pm5Qyc88kvKc/SjzzVUxc6MgU5rOoZKpCEtvdBQiu+SRyBGMFME624Cm6m6NrchgjGQKOMMNNKNuevcIogjEgOgAMl+Y0s7eoLKI8CYn88YHopEJIscXnkXp83PKfXgcO1SGqehWU5MGGVUCGEw8qcxWqgvYOaA7duKEF6Ex5Fihq3VgEA4XawMp8PhH3K5axJddv0y3lszlzl7C5QrQlG6UUgfOHZK5gkqfni2TEbv6dTc1Qq5fsZN76y4xLXgY6GxgGgUMXHtdHISHbwzifya79lHBD14rOZNNeKJyrJILMOvPctCo2myD/69tbHEmT9ppxs+/9HSahz2XOhjgLJ7q4IKC+O+4ATRzUXyNu0QNDr+ZuePD0vGhVaFF8kayTrTpLMu5KAYvQobfNlajM/xjIEkYxyx41DUeejuRPCLEgIB3XXQexzN4M5cQk1YzcJTOu/SzymHjEKNiMFLB/ZYfXHOoKT9EPuqLYAlt3ZlDgrdsQpf36nZpFze0LIR9cPpcLa5V13Mj0UO6WIoCd+zTWMBNM6k+vX9efR3g25PGOggDuF65joxSwYGBqaTs3ewrN5XANR7grY/KhXGC3Td1va1j5ddIVeTZS+h+4kJ1J4Nuq5EnMLidhxvmqz/bnJIQMRwAPVf1Hq/Av6F2LUHb+gQ3+73lsGmgaUc5MuReZBOmLP6CMXrIhrp3b1/NriwYwlq48F/sc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(36756003)(53546011)(6916009)(4326008)(66476007)(38100700002)(66556008)(8676002)(66946007)(316002)(5660300002)(2906002)(186003)(83380400001)(2616005)(8936002)(41300700001)(6512007)(6486002)(6666004)(6506007)(31686004)(478600001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE4xYXIzVStnTCs3RzF2ZFlrVWNSUVA4OEFHeUUrVjBQUFd4Tjl3SWp1WmZ2?=
 =?utf-8?B?dEFYZjg2cndCd1VsUXVhVGpyOTFhTlMyYmcwc1BkTHFVRWFzWHJMbURyNmdU?=
 =?utf-8?B?V2NScFllWEhVYmlqSldJUDVwV2t2OVM3Z1NxUkFkRTdxSk9LeTZlSGlsQUhD?=
 =?utf-8?B?UW9JWStVTHEwUXlaQ0lLUXhubFpsVUsraG5wYlZUUnA1ZTF2TVNWcitLZGFU?=
 =?utf-8?B?Y3Z2c3dBcEgwQXZwdk1aRytuN0RqZlFWaTVLV0FuWWRDNlBYL2xjTC8vM2dV?=
 =?utf-8?B?WUVVakNRZGQ1cFlnRnRtNC9nNDdVaEZGTng1R3pXMnFrNDg2Zk94S2haZ0Qy?=
 =?utf-8?B?bFhIQ2YxVEx2OUtkOXlNYXkzenlVdlNpMFYwaDRoMW9DbW1RRzA0RU9ES1Ew?=
 =?utf-8?B?ZmJzSHhzRjFYTTVFbzVvRUg3WTV4TTk2aFp2Ui9GcE1Sb0RsT0tNenVRY0Vn?=
 =?utf-8?B?VDlBTWxtWjN2MW5lMTdIVGJQZ2xxOW5YTmlidEExK3MwUGx1Y3J0SUNLUVhK?=
 =?utf-8?B?a0FnMDducXBEMHdrU3Q5SmcxYlptLzdGUjZ2WktpdmlicjJ3RUVuM2VxeURv?=
 =?utf-8?B?SFU4NHFVK1hxTmxkU29jOWVubUNiS3NDRlhHNUNFdC9CQXpsNGpPRUlmZXVE?=
 =?utf-8?B?VHBXQ3ptVk9SSEQyN2lSem5NNFpKTVN1Q3Z2RHVhR1RjTmdTTDdQWkpEMERH?=
 =?utf-8?B?b0w5T1ZzR3dLT2JZb3JvMk1ST3NNb0N2c0Z3aXRZSm5IaXhQK3M3QTgzSkVJ?=
 =?utf-8?B?d1NQVlp6VkZvYmw2cXlqYm5HYTdJaVJhUXlXamJKejQrMHlVMUhiNTRmRFBW?=
 =?utf-8?B?OXovaHJpZ2EvYVhsUzJUQ0FoelBwR3FJRDRXdnhKWjFFYlp0bElKMDUzRzFw?=
 =?utf-8?B?bzdJS00ydVZvU0hxeEh2NTBJYTRaMURGTm9Bclc1WXNpc3hCM2UvbC9YNjhv?=
 =?utf-8?B?ejRDSGw5a3dyYkk0UGlpSzFZai92eUdpWFVjci9MQUhCNGFYUURzakdJMEU0?=
 =?utf-8?B?UldqRTA4ems2Y25KTWcvZW9CUFo3ME1HKy9vTEQ2YnZnTWdKMVU4Wlk4V3dj?=
 =?utf-8?B?ZkFBZDB4Mk50b21RNFJERnBlTXpBQXF2b28rdUZTODZwNUJWNENPS1N6SDVM?=
 =?utf-8?B?T1MvRlJSOGRLeklyUWVYdTV2MDQ3Uk4ram5QQTF2aU9kTGJtYjBOSGpXSXZG?=
 =?utf-8?B?Tm9raVU1MU51NUovQnlTK1NSRHpBejBzNlJMc0lyNDVhcWJRQXJiYzFEb3dE?=
 =?utf-8?B?ZTBiZ3VkZUh6cmNtRE42V2FHTktYa216QjE1WkNFNjBDQlpnaFNvZlo2MVVi?=
 =?utf-8?B?bTNTTEtGejZTWHdVRFRsU2ZZNUFOU1cvYWtrUFNoNXFQK3I1dTJxMEI0NDc1?=
 =?utf-8?B?REZMQWR6VDZmK0U4STlRRm5zYnRFcnI5TDB0anBLVzRNRTRjaDlhMUFUK0t0?=
 =?utf-8?B?dWtFM01wckl4RWlTZForVUE4RUN1VEJXRCtyQ2JablMrQUNhaGpFajNuLzl3?=
 =?utf-8?B?bmdwSGRpQkVmblI2UDBVRWtEYTFCZXRJdGo2U3VGbEtQLzRSOXZEY0ZHbEo2?=
 =?utf-8?B?RVYrT0g0R2thWklrbUI1S3d4a2FKbkQraTdYM3c5RVF4cHJRS2N1ajdrMWJr?=
 =?utf-8?B?blRSMGdmdWUyZG11NlQyeFB2UnhhcStxUnNvOS9IMVllWnNmUjh2MzlhQW9T?=
 =?utf-8?B?S3dFT2RubGlFQXVQNDB4cDFaSlhUKzFheWpHNk1ZdEZiMzMwWU1YanB0UkEz?=
 =?utf-8?B?L0gyNmZia25PQ0dyb3BNUlhXRmtIVmpqdUhIVjZ3OVdDSEJMN0V5UFZmTURq?=
 =?utf-8?B?aGQvVDlOOUNBTHpueGJFRlVhcGF5YWtLMXJQNEplTVdTZkFhNUxTeVg0QklR?=
 =?utf-8?B?SS8vU3hNdU5zWG4vM3ZSRUlLeTNvRDh0bm8veVd1VlBCUXo4TmF6Q2NFazFv?=
 =?utf-8?B?UUl6T0E4NUdDUWVwb0Z6RzMvYUpTVkh6aC9ySThiOG12ODNzajkzMTQvMG5W?=
 =?utf-8?B?c1B5YUppS1lhVWFqd3kyQzRSOUk0elZ3UCtiZWxydUliR2tUUkM4ZEFMM2Qw?=
 =?utf-8?B?Skh4QVlnRVlMbjF4MExhUjA3UXZQUmpEU0V5TkJiUkFFUW9OdTh4b2cwTDh1?=
 =?utf-8?B?WHBDMmh1UkhFbHFJRE05T0lEKzNteFVuR2o3YklmbXRiRW1TWEdHQnhuQTFz?=
 =?utf-8?B?Q0E9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b9d150-b162-4514-734b-08da91ca3c4c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:45:00.8973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mkr/lzJvZKTouGt8EB2d+lYjbX4Z+Zqhltu4K7y/3PMFbMuIvnNKYj6vBqGZEceh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4013
X-Proofpoint-ORIG-GUID: 8QfqQ5zxYnBjwyqT_XahRi5LsjWrzycD
X-Proofpoint-GUID: 8QfqQ5zxYnBjwyqT_XahRi5LsjWrzycD
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
>> We have everywhere setup for nowait, plumb NOWAIT through the write path.
>=20
> Note, there's a double "btrfs: " prefix in the subject line.
>=20

Fixed, thanks for catching it.

>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/file.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 4e1745e585cb..6e191e353b22 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1653,8 +1653,9 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
>>         bool force_page_uptodate =3D false;
>>         loff_t old_isize =3D i_size_read(inode);
>>         unsigned int ilock_flags =3D 0;
>> +       bool nowait =3D iocb->ki_flags & IOCB_NOWAIT;
>=20
> Can be made const.
>=20

In the next version of the patch series it will be const.

> Thanks.
>=20
>>
>> -       if (iocb->ki_flags & IOCB_NOWAIT)
>> +       if (nowait)
>>                 ilock_flags |=3D BTRFS_ILOCK_TRY;
>>
>>         ret =3D btrfs_inode_lock(inode, ilock_flags);
>> @@ -1710,17 +1711,22 @@ static noinline ssize_t btrfs_buffered_write(str=
uct kiocb *iocb,
>>                 extent_changeset_release(data_reserved);
>>                 ret =3D btrfs_check_data_free_space(BTRFS_I(inode),
>>                                                   &data_reserved, pos,
>> -                                                 write_bytes, false);
>> +                                                 write_bytes, nowait);
>>                 if (ret < 0) {
>>                         int tmp;
>>
>> +                       if (nowait && (ret =3D=3D -ENOSPC || ret =3D=3D =
-EAGAIN)) {
>> +                               ret =3D -EAGAIN;
>> +                               break;
>> +                       }
>> +
>>                         /*
>>                          * If we don't have to COW at the offset, reserve
>>                          * metadata only. write_bytes may get smaller th=
an
>>                          * requested here.
>>                          */
>>                         tmp =3D btrfs_check_nocow_lock(BTRFS_I(inode), p=
os,
>> -                                                    &write_bytes, false=
);
>> +                                                    &write_bytes, nowai=
t);
>>                         if (tmp < 0)
>>                                 ret =3D tmp;
>>                         if (tmp > 0)
>> @@ -1737,7 +1743,7 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
>>                 WARN_ON(reserve_bytes =3D=3D 0);
>>                 ret =3D btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
>>                                                       reserve_bytes,
>> -                                                     reserve_bytes, fal=
se);
>> +                                                     reserve_bytes, now=
ait);
>>                 if (ret) {
>>                         if (!only_release_metadata)
>>                                 btrfs_free_reserved_data_space(BTRFS_I(i=
node),
>> @@ -1767,10 +1773,11 @@ static noinline ssize_t btrfs_buffered_write(str=
uct kiocb *iocb,
>>                 extents_locked =3D lock_and_cleanup_extent_if_need(
>>                                 BTRFS_I(inode), pages,
>>                                 num_pages, pos, write_bytes, &lockstart,
>> -                               &lockend, false, &cached_state);
>> +                               &lockend, nowait, &cached_state);
>>                 if (extents_locked < 0) {
>> -                       if (extents_locked =3D=3D -EAGAIN)
>> +                       if (!nowait && extents_locked =3D=3D -EAGAIN)
>>                                 goto again;
>> +
>>                         btrfs_delalloc_release_extents(BTRFS_I(inode),
>>                                                        reserve_bytes);
>>                         ret =3D extents_locked;
>> --
>> 2.30.2
>>
