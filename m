Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB735B25F7
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiIHSjJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiIHSjH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:39:07 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B16FDB9F;
        Thu,  8 Sep 2022 11:39:03 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288IJB2Y011731;
        Thu, 8 Sep 2022 11:38:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=M9YFLPpbP1L3xMQ7ZwhgAJUyJmxGwoQ0OeAyPMYUen0=;
 b=EE0IY/fx/B0pDggcOLG1cLJkqqYj56nTgpsE5OA+Eijor8deI1kS8zrSdyUzsXf3oSL4
 caS3wHQaJ9QZp375OFQQ42cL31UsN00ua4hU9M/+SX1j47VlHGfuDRZTkY/hL6b6AEuh
 7cZ48f9wS15kpYGHusZExrJ+ZAVtbiEkyyc= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfk74hg06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:38:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F49+U44cMM/q3Iq5apO6QT98HBh+w3H2bLTuQ4ZiY/l7NOnGGsCYOceuxm/uxImrBOxtPC3L2zw8JbwRGWdFBLx9A9K11tW8q6NKszUjY+8leO9cAyn3hVFRbtAVpyWhdD13j7RdwDL4UHeYY8qapG0Yr0ao6HgVU2PbnvjR74Kp5ZZAWjgdhwRXMQe+swKWxldQnDX0q4yxtE3BgR4GhVPw74h5bUA1Qb0T4WEuTbPKNpZv/ge2LosalQto3u8s0M4ApqoKJGm++3Aw0h/1u9Zi+wmW6HttvFMWJyCFe59Rvs1YRXGW4D1DdHixX/nIADrU/unvAWjv0m2EF+PGeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtBvPZg6hZfMBZ2ULyyA23We1lPaAf3APqScxfXEbXU=;
 b=h4t0h+SQSwh1Go2U18Hx5YsjCnlk/1x2af4Lqt5O5WAX+5yoq8goHuMx4cuyZKfxKYyhqWP63yba8H6qvjTzJlgR7DLK1Hlemkpo/frY2ASk+dRgbTFN+Mn0GslRFo/aABrRMJpCKj1mOGBx63QZNdJ+qbnNnSP+F9N5pMdekZ5in1iWczOpgJtNrx08BL0SG6RA/gbPQ1xERYUBsx0SY+7Q5tTBYwAYHSktjAvKKi7w5GtoLpXDqS4jeZgSkbI21ylRdyG62ucYh23z/sg5VMluhXiv2y7DVPO5QC+DT0ANqkbGQJgOk0nXrfOO3L7xbg4rcjddKlLC5eUk0zHMLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 BLAPR15MB4018.namprd15.prod.outlook.com (2603:10b6:208:255::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 18:38:55 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:38:55 +0000
Message-ID: <517ab3b8-da36-41b9-a635-d328e506a377@fb.com>
Date:   Thu, 8 Sep 2022 11:38:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 08/12] btrfs: make lock_and_cleanup_extent_if_need
 nowait compatible
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-9-shr@fb.com>
 <CAL3q7H5QnvPNtNq-uvXBsFNT=URXU4pKDaUqZGrf3MPt7VgBSA@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H5QnvPNtNq-uvXBsFNT=URXU4pKDaUqZGrf3MPt7VgBSA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::34) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|BLAPR15MB4018:EE_
X-MS-Office365-Filtering-Correlation-Id: bee54079-5a1e-4f5f-02d6-08da91c9627f
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlP5p2RpobHnry6OIa15F4ATUUFYxeoCqdyHTGd50tcCdaD7hdH9VSHEqNDnlXYSD68YL0LW4EogdnqmGb3ujzeeEoweZV/9Zo+eNE/eG3Q9hmL6XohAmTKwwkQibsPQLSqD47KS6KqUph7Sd3iNgHrIZc5QKCXpzOEJaAHTyj2UCTfEs5HnNfV41VTFAl8Qg/YeSeXEEim5P6X8YoRpgbvDiZlxo/jM4KDtiAjz95siXw0SifLe4qdHdtWAPATozKrLzSDUFH9BHH1B/RSlUBiDph4cDdV7OOe4jgl9pAHz7AQUNDdq4e9ugbbDG4HI/yy3wRHpIDP/5hQV1IWR8ffAEarRogApySxz7FYQf7RvfuWFLW53M2X167x9Dgm4eDmgCe0qQSuQ1nqL1XkL9pUk07W/S1HKrEi8TegwVGhlSZwjnrLi1weh7c2Fyw5DPTsZD+Swc82eTjBhK4qUMbKddjxHZY//YPKpLJvmERk5sDQQiz88krF9BqikLRWiERYhuT9dgv2TmNJecj0pcLw0r0KjIFA305MSrEKPbhtjCUmuimvkimxIPMfXcuoqklQw44mbZoalF7oU+2sw8YGRxQoLOsVqQVWer7zb4dLjkkUX1ZdGN/rPC3YropuX02GQI29kgKKOkquvnYJm3gptYYhoqD6sDjfNPpDYbEoJMe6Jo1c0INie9C7v+3a6icz0hcUdOz0yTE0KA+ZNGgP+zu6ZkxJOUPglV+H2q+7j4+mjnA1D5RUNIxeAB2kTyZ9rn8PCeTz0AQDTxGaFarBlf6e5LCQtfCi1r5Dz5FM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(66946007)(66476007)(8676002)(478600001)(41300700001)(4326008)(6486002)(5660300002)(8936002)(2906002)(66556008)(6512007)(31696002)(6506007)(53546011)(38100700002)(2616005)(86362001)(83380400001)(31686004)(186003)(36756003)(316002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzgvS0Zia2FQT29lRnhKdnJLdHNQbkVCa3NqNkxaUmpCU2lWL3VCbmowc2k1?=
 =?utf-8?B?MEkwWXRKSFc5cis5b3IzTHFaOFpmRytwU2dLOC9Sa0sxZFNSanZ1R0szcHdE?=
 =?utf-8?B?R014NmR6ZS8reFp6TVlkZlRxRFA1dk13WUpXUEMyWjNvcmdkQ3N2MmpXNkZY?=
 =?utf-8?B?K29VNmdxemYya3JTa29BYnRjeVhSdDMvM1hGSEMzM0xhVmVHak1BTUIxK1hS?=
 =?utf-8?B?T3kzeExwQ0luQXZ4SGZFQVdYcDA3RmZnZWswNmYxZ21SbDZ2eWtmSkdtZFJH?=
 =?utf-8?B?RllmNEFVMnJpOW9vdDV4a3ZkQ2FiN29KZHNJbDJTQmEvOThpSlJSZVBSZ3gv?=
 =?utf-8?B?QUZsZVNVTmxKN01Gcm5JOEdiWU9UUktwZkJGVE5Hd1luYjNURnZoZ2tTS2k4?=
 =?utf-8?B?N09URng5S21QclRzdWg4SEo1NkJtZk40OWF6OFBTczl4VnYwZWg5OUFkSTdH?=
 =?utf-8?B?VjJpVitVdXg2Mk9HemU2aXpmRzUrZ2NqaVhLYnlFRS9oQ3RDRVZTUlhaU3E0?=
 =?utf-8?B?SnhoOXpTQjhZekdyaUVRTUhWK0JocVZvTzVHM1JhVHBVUUQ3djBmZUxkOUxr?=
 =?utf-8?B?YjBsM3BkSldYbCsvQnNqMXY2VE03OXprS2VFWFl3VHN6bkJKSktOTEkvZnZp?=
 =?utf-8?B?ank5SllxZkgwNUFLeStHUEVqTkdQblpDQ3ZQUk04Y2JRbE5NZHZqcWFSL1Jl?=
 =?utf-8?B?MEpqUGN3Sm8zSlQ3YkNKb0VVUUpXWUc4dnNteU5FZ3IwYmtDaGllTGlkQ2dq?=
 =?utf-8?B?R1R5ajhTWmI3dXRkUWZCVWNGaTNELyt6amxwekNualdpbXdUNnllQ3BqOEFn?=
 =?utf-8?B?YzdnM1BlVENlSDdxc0V1UjREcWo0ZTRFNGpUTE44V21WaW5UMjYzaytqZTdE?=
 =?utf-8?B?bnFZa3BBSmwyQVdwSTUvb0ZEMm80L0JWWEw4em5sTlpqc3VCOGJ3Y0t4Y1I2?=
 =?utf-8?B?UTdUL0NBMUU1Wks5dHR0a084YndVQndGaEFpdzhkVmhzNk50Qm80dThUbXpW?=
 =?utf-8?B?YVNObStVbnVZZGJMek56VnJvRURtT3crTldnd1VaV01VTXF6TFRSTmxldllh?=
 =?utf-8?B?N2l4c0ZZaHFHMXNZaTVmd21OTldjZTgxR2ZOaWx2amVVL1dxcG5JK2lHQlNa?=
 =?utf-8?B?TkFmN0JJR3dmNk5lWkpCNlFwaEZlaFVNZ0dwdm80cWdRMzRzYzd1YXhLNlFW?=
 =?utf-8?B?K1pTUVJmcGMrS3BmMkcwMkVLNEpWSFZMMHMzZjJabXhHTjByQnFXQnNocnh3?=
 =?utf-8?B?WThOWk5QNE53Y0h5NnhSQ1R6YXdJcENseXFSd1B2USt2ZlRudlJxUWZXcmdV?=
 =?utf-8?B?Ty9XTW9TRnFzd2ZpY1ZCNXNFbXIySWZ3VUE3Myt0VXpISnN3ZjBNQ0paa3Jw?=
 =?utf-8?B?bUpoQUNNRjE5TWl6U01ldkpaSklxWVhLMmZlWTQwcEpOejNseVkyaENSVFVa?=
 =?utf-8?B?MlQreVkvNnVuczQ1K1BIWE1IZXN3RFM5S2lURmFSdjBEOC93VjlhMFBpOGk5?=
 =?utf-8?B?bTBBTVBDN3VoRUtob09LSVNwbFVzeXNQMWt0OU04RGNNSWZVekFneEM3bEp5?=
 =?utf-8?B?aDBOZS9QQ2JOa2FzYnNzcjBNU1F4VnZPaXNaUS9vWmhEZldrZFBiVkJPVjNs?=
 =?utf-8?B?dFFWcEdOT3NwdjRENFg0VkdsMU13RWc5RHVqZ0JtcUxsR0VPcHlZdk4xc0lG?=
 =?utf-8?B?T1lBWThsR3R2SS9yUG5Vc2JUOTZaYTZmRDRTbzJWbU5obkYrWHZRelJLTXZt?=
 =?utf-8?B?a0wwekpSUEQ4cy9UdnhjZlhxWS9Pd2l2ZE0zMW9PQnZ2UG9xYm5iMGtHK1dF?=
 =?utf-8?B?QnBTYXRrVmwrWng5cWJkVFIzMnNXMTNYbTJqRjJ0ZUFCZVRKRUUyZFpMT3Jv?=
 =?utf-8?B?NUxvaFdLUHRHWi9uSWRlUmhxa1ZqWFF2elBOWnpkRVp3b2g2eFhrci9vS2s4?=
 =?utf-8?B?aDlHZm12eEVWZ2xQeXhWbDU0N1VnOXdGZkFOdnRnVjJnS0pqQ1RtUHkvL21K?=
 =?utf-8?B?NHNNRlRxRWxNVW5OMC8wekF3YzBza25ySWpxVlFtSEhCRnAxTVYyc3BLZnBK?=
 =?utf-8?B?bmY2OE9yOEkzZUg5SmlhTXRzMTZqMGdzYTl1KzU2QTAySndQMFNzcklUMXRr?=
 =?utf-8?B?NldNdk1XUm1yYWlYeUxQeGlWWDc0VE9sUTVuZSttNktaN2d4Qm5qQWo0aDJT?=
 =?utf-8?B?cVE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bee54079-5a1e-4f5f-02d6-08da91c9627f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:38:55.4385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voK9i//Qwrj5k/o3D1hB8H/WjKndCcqJv1fOuNUTwRoswoRCbKIrMPiSmyEVuRV/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB4018
X-Proofpoint-ORIG-GUID: Z9w6oPfafIZSqKB30Yh_reENCMQd0dVf
X-Proofpoint-GUID: Z9w6oPfafIZSqKB30Yh_reENCMQd0dVf
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



On 9/8/22 3:17 AM, Filipe Manana wrote:
> >=20
> On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds the nowait parameter to lock_and_cleanup_extent_if_need(). If
>> the nowait parameter is specified we try to lock the extent in nowait
>> mode.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/file.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index a154a3cec44b..4e1745e585cb 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1440,7 +1440,7 @@ static noinline int
>>  lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page =
**pages,
>>                                 size_t num_pages, loff_t pos,
>>                                 size_t write_bytes,
>> -                               u64 *lockstart, u64 *lockend,
>> +                               u64 *lockstart, u64 *lockend, bool nowai=
t,
>>                                 struct extent_state **cached_state)
>>  {
>>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>> @@ -1455,8 +1455,20 @@ lock_and_cleanup_extent_if_need(struct btrfs_inod=
e *inode, struct page **pages,
>>         if (start_pos < inode->vfs_inode.i_size) {
>>                 struct btrfs_ordered_extent *ordered;
>>
>> -               lock_extent_bits(&inode->io_tree, start_pos, last_pos,
>> +               if (nowait) {
>> +                       if (!try_lock_extent(&inode->io_tree, start_pos,=
 last_pos)) {
>> +                               for (i =3D 0; i < num_pages; i++) {
>> +                                       unlock_page(pages[i]);
>> +                                       put_page(pages[i]);
>=20
> Since this is a non-local array, I'd prefer if we also set pages[i] to NU=
LL.
> That may help prevent hard to debug bugs in the future.
>=20
> Thanks.
>=20
>=20

I set pages[i] to null in the next version of the patch series.

>> +                               }
>> +
>> +                               return -EAGAIN;
>> +                       }
>> +               } else {
>> +                       lock_extent_bits(&inode->io_tree, start_pos, las=
t_pos,
>>                                 cached_state);
>> +               }
>> +
>>                 ordered =3D btrfs_lookup_ordered_range(inode, start_pos,
>>                                                      last_pos - start_po=
s + 1);
>>                 if (ordered &&
>> @@ -1755,7 +1767,7 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
>>                 extents_locked =3D lock_and_cleanup_extent_if_need(
>>                                 BTRFS_I(inode), pages,
>>                                 num_pages, pos, write_bytes, &lockstart,
>> -                               &lockend, &cached_state);
>> +                               &lockend, false, &cached_state);
>>                 if (extents_locked < 0) {
>>                         if (extents_locked =3D=3D -EAGAIN)
>>                                 goto again;
>> --
>> 2.30.2
>>
