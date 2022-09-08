Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15935B2597
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiIHSX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiIHSXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:23:22 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBECF1F32;
        Thu,  8 Sep 2022 11:23:17 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288IJALQ011702;
        Thu, 8 Sep 2022 11:23:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=yGlqh52njwjXfguCDwjY72b5BXXdEvVqbfe0uYijmTI=;
 b=JwtTJVdNAupMD02ZrR/8v3aqBbKa/Wo/9I2sEtdxG0Lm4xoSPoTfocg+hxZaV6BGWT+S
 tsBXuFpyCoPNb600iZcmbsNdDJqSM0O8uF/dxUDw6k9uXfdB4Jp7PRvqS4hjpFDUceOB
 09blocF42l0uvBauIv77jjTvTCwRDotD4LE= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfk74hcj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEPH52i5/h3fRm7QTpoklyg6KKHn/BfIkBtyE+L8v6oa2ZfYQXUJ/8j/Tv/Gv1+IkOkT0SGCQZfnOFABvb3q1pnw8qPlpcPRwMrfMalrUK08HZ+UepdQDkwNVQL7SXhN84+iRA0dXJT7fu9fptBgrjM/ruyE4j5TlL7IOIoTjvZAJCPlq1bSvQdzBQoFNIqgPVAfqZ95bmgADRbpj94H+cn9dxauZtRkWwgrXAo3trcTShzOYrMzHg2EzJfgQoY6VOVdI0PcWCxDQGEwHdrhRGMupzyJMNNbjJMjsvHGKizN0cqCnluJJzqN/81kypnm4sROHVtUMNcxKYQfz3I2wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCuojGH8PqCGtiORMLQ1VOabI9VfNErOGrgBasLsi1c=;
 b=Eo0tKFlh2cO8ekSfv7aIQ122Au1SVJZJ+67TJIUKP9JQ4aIFo9OmGTcFUSYvHeICh0Q8KvWCiJTHRNhb9efL4R0uzTN/C/VtiMp72Bt2Sl7wc8QinE59xZgo9BDyaCIIA2ByJoILu3qVQ3x0AFrUXRS7B+67FyU79806H73uH6zKg5zlUGf0AAF30seknYbRi6BdXaAjwtP9jl79uVJ1atXE7SvJA1hFGpAIMGefkcqJRslwUfvIa84QmPw5EDnZVfGddBZ9C3vMxPdI/mIwaCCvdTYOg6whnJhohVQ0WA6MZwhM8gWSqqK8HrApbSssbhJEXFJM6K16MjicXJI0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DM5PR15MB1897.namprd15.prod.outlook.com (2603:10b6:4:4f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Thu, 8 Sep 2022 18:23:10 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:23:10 +0000
Message-ID: <5b39b589-e7fa-c1c0-d4ce-a6daaf0a0c42@fb.com>
Date:   Thu, 8 Sep 2022 11:23:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 06/12] btrfs: make btrfs_check_nocow_lock nowait
 compatible
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-7-shr@fb.com>
 <CAL3q7H6mJEK=T78DF6o=xYmZht=x0jPVgDw3eVoHOKLyxfvdOA@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H6mJEK=T78DF6o=xYmZht=x0jPVgDw3eVoHOKLyxfvdOA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::24) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DM5PR15MB1897:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d8c46f-2f20-4b6e-d279-08da91c72f34
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBiEALlOoumdTucUPkydX65PBNDxJu7+01pd0tlNTLJUY9MEiB10GEMrTSXqQmWXBNvTSWsMNZcwpHPETK5ell0FifHL3ISyIoQ0aQQqwmL+jsHy2bf0ho/JxIfzWkW6YSiSQPxSxUsudWvKyW6XFpxhlSnVyFmG6YScFUc2c9ZL718SKKXX8wGKkuDLaqua9XSJiCTxnrwogSGuMUtvqif3LXAeBjhlUt++tNqAvsEV6sVg3/XYjQ6T2XhETZAC/Hm7mj5sUKdXLFRIHRmaH/oC9Qaed6h2FIUE96byEof1XFnUb7Olvy601NgiA29BVHn1nUEVN7C7qkRywu+6VU1Ue3JhsOOkTIo2nWbaFALfdDUg4BZ4vSVVkgFYLaHri7Ou1/tEEcP6SAVoS6R0NAmK/LBOlA5N6W7R1Wavr2LT93dQ3LeXSuWLe415pImF5M88x7rBUw8V7rFSCcEiDznolOUwmdwzioL42WngDxku1VyJWp+bOz9UeOupFLXpqYAE6JeL51VpKtVvxJVcHMzOBoMHUsYFo8H/tuhvmMxIlGjNpK3gZp3LQDKh27kjR1rFLQCQFPMQcEAwND8j6VQyaYQwMPdB105VkMJchF2Py0xc8IfccKaohm9kR6bO3XrQH4mIQljvbtKwTfnNCtq6juu7xHluSHeDTpG7wnqof2zK6MpqpTLUAa5cgIJ7fknDKy9jnXYVmP36of/CleuuQGLt/v/jivuQZ5s90xk8HLFt2hOLS2fTW3oe0STKK9eHJvyZDawbZzvuDhL1MjjzSiFcx8riK1KpFVze7Hw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(31686004)(478600001)(186003)(83380400001)(6486002)(6666004)(4326008)(38100700002)(8676002)(36756003)(2616005)(53546011)(41300700001)(6512007)(6506007)(86362001)(2906002)(316002)(31696002)(6916009)(66946007)(5660300002)(8936002)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTEvUnNLRHVYQ01tQ1AyOFd2aEVjSC9hYnFCbmpROXNQSzM0bVpJYkZIQXlZ?=
 =?utf-8?B?Nng0Zm12ajdRdlErK2IwUjJ2b1M2ZDlLbU1TUVNGZHBVODFzL1E0bjhDYk5h?=
 =?utf-8?B?eEhWRUJvam5mUkNmbVU3Wm9RVjkvZVVZdm1MNjE3RjkxNWJmbXVyZCtENXZT?=
 =?utf-8?B?MG5yWVJLa0xpQk5wQzJiL1NWSmh4Vi9NNDU5bTVEdWJkZGI4b0JuZFFlMVNh?=
 =?utf-8?B?VndFa3hYMDhLRjNYYnZpNk9TdGdTT3lDaHRDOGZ4SXRlY1poN3RnZjNRcGxa?=
 =?utf-8?B?YVF0UG5OeUpqVGgrNVZKd2t3dFA1MXdSSWRzVzNqZWVFcm9WMXlxNHVHT0d3?=
 =?utf-8?B?OVBoRlAyeVA1ci83Mk9wMytHM0hldWltSnFUYmtMQU43dk81Z3hCam5ES3or?=
 =?utf-8?B?Y0NjMmVkeCttYUQ2RXM5UTBybXc1TEpsOER4VlhrK0dmVDBLQlVYbE55RFhC?=
 =?utf-8?B?VjBYek5JNnQ0Y2ZxYzk1eGlvaHo2UCtJVkxHdkdzZDd1bXZJY3FEbTV6YTZl?=
 =?utf-8?B?aGlTSEhFbC9QcGVkV3p4aVpsMnZGRWlhbW9tNlVuVFZLTDV6RDdBM2toZDF5?=
 =?utf-8?B?ZzY4QUM2bnE2dzNuaFArbllxcEY4ajJzUXNFYW50RHN4MHpRMWd5K2lMRDNo?=
 =?utf-8?B?VTFMbUplL0FrMDgyTXVDdGRwUHplYU0xcGdXMTRmRGwycmFlbTJPUUh6Mi9I?=
 =?utf-8?B?MUZTOGZlYUludktxbkQ1amF2cDRFNlpqdmNiMWFBRVMzRzRoWFNDc3BIR2Vy?=
 =?utf-8?B?WnhRMFZZajR0aU5CS3pXTVNyeXdqeE42di9YaHhWaXhhcHlBUGxQL1FiN0Ns?=
 =?utf-8?B?dy8vRENBRjFNTk9QQjZCVm9aTXMrU3hmUVBncll3amFuNHFLYUtvSTFJUExG?=
 =?utf-8?B?dnRxbnN3R09vZ2poYk5nZUVvUktXUE8yZzVMSFdpWnhYTHN2c2k4NjdZU3Fl?=
 =?utf-8?B?QUltVnp5N3l1UnY1NFAzVE5NVko2QlFSZ3VNWjZqeUYzK2lueW4rdWlLVW1C?=
 =?utf-8?B?U0V6ZTVXMjF6aFZCb1NITitDN1RjZWYvWndGRWlsa2xiUTVSdDA5VGNlNXhr?=
 =?utf-8?B?dk4vU1Y3WXk0bzhLVEZJTHhwMjdqckpiR01CZklEWUVOZTZMeHVPYUFOeWJy?=
 =?utf-8?B?Wms2VllEdXpBTHJtczM5OGZvMGM2NGlNT1YwS0w2aFZpM3RjZzJ2OFhSTFVR?=
 =?utf-8?B?SWdDY01zY1hhS1lkSmlnTmVLUmUxM1V5bVRwbFFuakdjdFdlV25iUWdrS24r?=
 =?utf-8?B?ZTlsdkkzakNUa3RIZllLZit3VXlsUTJ0c1ZFT0l2RDhtUG9WSkU2ZUVpdUc1?=
 =?utf-8?B?ZDl6eWo0aGd3Tll2a1d1V2puRnVhQlA0VHdOWFZxWWt0RUtiMlF4YnFNQmtn?=
 =?utf-8?B?UDBnT2lUNE9sWktjSkRyNUREVS9SMXFpb0JaZW1Qc01GN25EcS9aVWg3aUp2?=
 =?utf-8?B?K3I5Q1BvQUhLMWF3SHZsZUhEdWRuMUs1WERVckI2MDBxRDlOTFhDQkkxN0dB?=
 =?utf-8?B?M2JWZmV3WUsveE1wL2hYRVI5K1lZSTVYbjJVYVYxY05FUWFWL2ROQjVKa2VB?=
 =?utf-8?B?VndsWTd4YVg0cEoyMGl2VlloVCtQN2FzN1BvYjB4a2Z4ZUxNSVI1UzhCUmVX?=
 =?utf-8?B?ZXE0d1M1Nm41T2RqOEZiQjFOYmRkSHZWeG5vTnNxWUVCQlh0TzNrUlQ4WUUx?=
 =?utf-8?B?ZXRTYjlyYUhUS2Z0SmQ4cHZNakhGLytmMUw2Q1AranBYUmZqWUxWd09raWt5?=
 =?utf-8?B?ZWdCYnFEbHk4eVlaVzlvcjN0OTVDZ0hzdFgzajU1TU9xdzR6Q2oyNS8wR1VC?=
 =?utf-8?B?OWQxckpjNFVRUHo5R29UOWcxdkJOMjU3eXZkZFh5bWVzNFJqM0l2YU9zcGZH?=
 =?utf-8?B?ZnFPVEdmWWl4SENoSnAwL3NYbVM3Mldmc2dEek55Z2RZcnRiUVRudTBpcTdE?=
 =?utf-8?B?YW5peHgwREROb081VjVaUkh5NElHR3NvSE1BZS91VlQ3dHlDQXdvOVphWnBl?=
 =?utf-8?B?TXo3TXNWVFJBYnBtcVE5c1hKd2xKeE9JaFBKZG1USDNNdHdHQjZJZ0tyTVZa?=
 =?utf-8?B?UTZqa21iM1N5ZmZjZHhBQThtUFJVdGxnNjJKaEFEaFdieXRoWE5ta0d1NWJK?=
 =?utf-8?Q?k7mcpYFtPB/xljhHw4aR/SPBw?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d8c46f-2f20-4b6e-d279-08da91c72f34
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:23:10.4887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzn9KLk0J+rlowEu0Oe273iSmsONuKFLI2zD4iJpjLUwOruYACamt2yHAfmnMZbL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1897
X-Proofpoint-ORIG-GUID: oGtW66cdOY2cBGi60CqBB4q46PTe9t3_
X-Proofpoint-GUID: oGtW66cdOY2cBGi60CqBB4q46PTe9t3_
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
>> Now all the helpers that btrfs_check_nocow_lock uses handle nowait, add
>> a nowait flag to btrfs_check_nocow_lock so it can be used by the write
>> path.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/ctree.h |  2 +-
>>  fs/btrfs/file.c  | 33 ++++++++++++++++++++++-----------
>>  fs/btrfs/inode.c |  2 +-
>>  3 files changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 536bbc8551fc..06cb25f2d3bd 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3482,7 +3482,7 @@ int btrfs_dirty_pages(struct btrfs_inode *inode, s=
truct page **pages,
>>                       struct extent_state **cached, bool noreserve);
>>  int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t en=
d);
>>  int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
>> -                          size_t *write_bytes);
>> +                          size_t *write_bytes, bool nowait);
>>  void btrfs_check_nocow_unlock(struct btrfs_inode *inode);
>>
>>  /* tree-defrag.c */
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 0f257205c63d..cf19d381ead6 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1481,7 +1481,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode=
 *inode, struct page **pages,
>>   * NOTE: Callers need to call btrfs_check_nocow_unlock() if we return >=
 0.
>>   */
>>  int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
>> -                          size_t *write_bytes)
>> +                          size_t *write_bytes, bool nowait)
>>  {
>>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>>         struct btrfs_root *root =3D inode->root;
>> @@ -1500,16 +1500,21 @@ int btrfs_check_nocow_lock(struct btrfs_inode *i=
node, loff_t pos,
>>                            fs_info->sectorsize) - 1;
>>         num_bytes =3D lockend - lockstart + 1;
>>
>> -       btrfs_lock_and_flush_ordered_range(inode, lockstart, lockend, NU=
LL);
>> +       if (nowait) {
>> +               if (!btrfs_try_lock_ordered_range(inode, lockstart, lock=
end)) {
>> +                       btrfs_drew_write_unlock(&root->snapshot_lock);
>> +                       return -EAGAIN;
>> +               }
>> +       } else {
>> +               btrfs_lock_and_flush_ordered_range(inode, lockstart, loc=
kend, NULL);
>> +       }
>>         ret =3D can_nocow_extent(&inode->vfs_inode, lockstart, &num_byte=
s,
>> -                       NULL, NULL, NULL, false, false);
>> -       if (ret <=3D 0) {
>> -               ret =3D 0;
>> +                       NULL, NULL, NULL, nowait, false);
>> +       if (ret <=3D 0)
>>                 btrfs_drew_write_unlock(&root->snapshot_lock);
>> -       } else {
>> +       else
>>                 *write_bytes =3D min_t(size_t, *write_bytes ,
>>                                      num_bytes - pos + lockstart);
>> -       }
>>         unlock_extent(&inode->io_tree, lockstart, lockend);
>>
>>         return ret;
>> @@ -1666,16 +1671,22 @@ static noinline ssize_t btrfs_buffered_write(str=
uct kiocb *iocb,
>>                                                   &data_reserved, pos,
>>                                                   write_bytes, false);
>>                 if (ret < 0) {
>> +                       int tmp;
>> +
>>                         /*
>>                          * If we don't have to COW at the offset, reserve
>>                          * metadata only. write_bytes may get smaller th=
an
>>                          * requested here.
>>                          */
>> -                       if (btrfs_check_nocow_lock(BTRFS_I(inode), pos,
>> -                                                  &write_bytes) > 0)
>> -                               only_release_metadata =3D true;
>> -                       else
>> +                       tmp =3D btrfs_check_nocow_lock(BTRFS_I(inode), p=
os,
>> +                                                    &write_bytes, false=
);
>> +                       if (tmp < 0)
>> +                               ret =3D tmp;
>> +                       if (tmp > 0)
>> +                               ret =3D 0;
>> +                       if (ret)
>=20
> A variable named tmp is not a great name, something like "can_nocow'
> would be a lot more clear.
>=20

I renamed the variable tmp to can_nocow.

> Thanks.
>=20
>=20
>>                                 break;
>> +                       only_release_metadata =3D true;
>>                 }
>>
>>                 num_pages =3D DIV_ROUND_UP(write_bytes + offset, PAGE_SI=
ZE);
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 36e755f73764..5426d4f4ac23 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4884,7 +4884,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode=
, loff_t from, loff_t len,
>>         ret =3D btrfs_check_data_free_space(inode, &data_reserved, block=
_start,
>>                                           blocksize, false);
>>         if (ret < 0) {
>> -               if (btrfs_check_nocow_lock(inode, block_start, &write_by=
tes) > 0) {
>> +               if (btrfs_check_nocow_lock(inode, block_start, &write_by=
tes, false) > 0) {
>>                         /* For nocow case, no need to reserve data space=
 */
>>                         only_release_metadata =3D true;
>>                 } else {
>> --
>> 2.30.2
>>
