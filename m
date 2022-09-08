Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60545B2696
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 21:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiIHTPH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiIHTPF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 15:15:05 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046765B053;
        Thu,  8 Sep 2022 12:15:02 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288IJDUe020504;
        Thu, 8 Sep 2022 12:15:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vMTx7oTrRy6cRCCoh/zASNQJZVx1a83eRZUtjMzIfVc=;
 b=B6Cbb4iIWceIkIWN6m/T2MwYb9v9rnCYoOfKsN/PwO8oSiVS75yJtCn01lYIf8BJxzhR
 sfO4inTBnq/su7alSs4q5lNmNP1s+L8wj9y5Ccs/DMN6pMvLgS2g3BKVGKkQHoNL0Sdj
 nKy4w5uvFJ9JQNnyGcbUxp/hqDasygE6mNo= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jfbqx4j0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 12:15:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W38EwltoqyBB43oMO4CERACcUYkBvNcL/KjoHf894IA8c/A+s9R9uUoohA5dmyqOy2nCJ9QYDPsIAQjw/B/Xclp8/G8YT05CeybUr19CnmPcXc2R35MSfSN1habgRP8fVrsRXbmA/8KG8OPumNL8Np1Gypao2yja+9AAak6TbVw2DrUNH7+LOBTmuzo70r/VWgrmH8yYkzpgkItL1vtRdvFJIhwUY+mmssJ8MU/YL5+uxwABdci9XxxvvZEAyKO+Q76Pncy7el5Eu1At7UDd0Bv9B6XNtG7X0RKtjSSNnDKcUBXXRHXuJUKDd7LTBhZcEgu89GVPF50zr97ScXW5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMTx7oTrRy6cRCCoh/zASNQJZVx1a83eRZUtjMzIfVc=;
 b=k37tF0XKYH2zIz66bWnrnZBQl5rTdnSTKXuV/DtTy1ZBJ/vaFhN89t1p8oCRLEsZPx4sZLCTQ/GvQG6v2abnHNgFrt184XVrq6akumeD5iIjCdCchl+GTBnrMEws28T7fdysXvOtQ6gLizPPFK/6upx35DM9ILTKHuvF5AhkLOAHx2btMRW/FO178xckchTXR6H3AphRBUyH4/ksoK4gPJopn0ZeKCsJpQ1ehhfMqr8Cgt+PML+H49uCM36g3d+Pd0HQ/K2jh3XiLEh4LcQnfKAHKEgzpO+tcs3HI/6ZtJOwabLrABO/FnlA+NqcXSShBwX5BjUVinxFkrroccFIbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 SA1PR15MB5187.namprd15.prod.outlook.com (2603:10b6:806:237::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Thu, 8 Sep
 2022 19:14:59 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 19:14:59 +0000
Message-ID: <92f25d12-804e-f76a-c431-d9eca32c564b@fb.com>
Date:   Thu, 8 Sep 2022 12:14:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 12/12] btrfs: enable nowait async buffered writes
Content-Language: en-US
To:     fdmanana@gmail.com
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-13-shr@fb.com>
 <CAL3q7H7dM3tdbnLReyrX1Vm=43NdjTPXmRrhJF7nO=Uy3fyKDA@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H7dM3tdbnLReyrX1Vm=43NdjTPXmRrhJF7nO=Uy3fyKDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0099.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::14) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|SA1PR15MB5187:EE_
X-MS-Office365-Filtering-Correlation-Id: 8223ffe5-cc42-4eb7-6fbd-08da91ce6c42
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MILcfQrt9fdEZho4rLOzhF9nRypVlIiYalZ5AoDK2ApWMy/8eKftLDUU5/vAkZG20h0frrpFQ/Dx4L5iMtSOXmN1SB8GcfipbgkZ5uqzDqfJkBLEFOAGcar1OBw3cQRaujnDLftIbEDntlC8k2w/naB/4R04xAmrUKTKKdlBl0qxcjgYi6Csc8AU4/i8IbMYANmGDpCFI59ok23uZsbwQc2VZ8uHJF2wNiA4fgxK5CwOgQtITeTO+10bQz/00qwgnNJ/ydjahfyk8bgdJjgwgSoZVBX3Xxv3ffI2CQSw7bBO6pM7nNOVD+wqRfZ5NLNOWFJxuj+XTg0nnaw3rDdwnUla82oOH0L7DtK/XeFD+2h9TFdtoC96CsUXPrPW6VUVikQRgk28U3SWlAdbEjgXcaidyp7QuJ44P9RaN9m0hdswbUhb5jDSFViwzmQpb3W5r9y/nhzaCtYELqPyM63BzOax0UfMFfRoZeBY2RuOS6SnHsb9Y/1TjiMQ7Nn0OGA63vhrwer8vIH/ihK1LgRlcnkIw5BHQfNFgyUuJLwesS9ELyXoSlUHioWyRLp++FADtKbUZOCWnWepB3pqnzCPQwhb3qlXAiB26EopUENdskGPGUI405UQuF62Lahmyg76jMoTdS7ziWf8+kWfPFukvI+mL2JzS0xwlqWkq6UW6L/T6nuLfNw6wSkfgUQAVZJmtr5064JmDrVcdhf4kQX5b1OUnobD4FTzqloYRiYrwLVhmOz7pvgzkDuW+Pj28jGxE93Icn5DTStwfMcfiW5cWQQ0tQK8yU7xH4CDBH23j8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(38100700002)(83380400001)(31696002)(4326008)(66476007)(8676002)(66556008)(66946007)(316002)(6916009)(2906002)(5660300002)(6506007)(53546011)(6512007)(2616005)(31686004)(41300700001)(478600001)(186003)(6666004)(6486002)(36756003)(86362001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2QzQ01tQ2htUmRJdHZReC9VdG5tT0YyNnhxR09tNVBRTXZIbFFDMk1pbm9K?=
 =?utf-8?B?UmhHQjMzUkJCQUlVc0FBbkJPQmJHcTF0QWNIbk83SjdDT2ZCS3Z1L0YyUDhV?=
 =?utf-8?B?ZDEzWTdIdHJCdEQxRCtYUktyeXIvZExCa2xUME5saTh0UUptaXViR1F6aEZ2?=
 =?utf-8?B?emNaWHJsVkROZGVhdHQxQjN4ZC9RdDhXR2FoRXVkME9ReFppdzJsOFVhTGZR?=
 =?utf-8?B?SDV5TEdWRU1icG04SlhQOEhDUnA1ZW5ROVZGUlRod3FUQjRkd2NBUHRqL3RT?=
 =?utf-8?B?L0JxZThTUDJNSzRNLzlRM1Avc3RkWHZCNVgzdDV3NzVhb0xTeEZicmMzOGVw?=
 =?utf-8?B?c1hhK3cyNmY0aFdoVkcrOXJpWUJHM1lvWEYranpqZXRxbmozb2kyM3cwMVNr?=
 =?utf-8?B?V0FwNElpcHZPN1dWV2U1ejJmSzR4NW9Ya2puNkxGYTdqSzVmNWZrT3FMalZo?=
 =?utf-8?B?eE5XbGVpWXNEMXg3SWkzdHZhR1VycUs3VC93Ui83Rll5RFFHRFJtS0pQZHBY?=
 =?utf-8?B?dEsyRm1xSnhxN3MvZjZSZisxQ25GZ2dWYVN3ZlRySFpYeG5oaXpDOUVqdVpN?=
 =?utf-8?B?K0hHRzB5SHNuOHZUQ1JPYjBXdFg1RTVyem5GcDVycWtMQWViTHJsSWI4UTB1?=
 =?utf-8?B?M0hRU0taSEpZeTQzM0g5cVkvMVlTNE5BVWpMUnlNOVcvbDF6WGU2ZW5DU3hj?=
 =?utf-8?B?MWhZSmcxeWExVWxEWUgxdVphajJkN2diRGZWQVNjUkJYbU9YVXVrbE9Ob3U5?=
 =?utf-8?B?NmpkSnBvOFhNRC9sVGVrVStpY0NhZnZvVGF5cUZ4QVp3NXY5VXBua09JSnA2?=
 =?utf-8?B?MFNORWY1N0pPY2JlUVhwcWMzb0JIM254RzVpbjJCekt0NE5MZjd1azJ6WkxN?=
 =?utf-8?B?MXQ4cVplR1piV1Q4anlqZlBEWkVoZE1hUk1jbGlBMnE1NjYzczJoanJ5L2JP?=
 =?utf-8?B?M0ozNnBGdkx4cFprWk5lQXk2bysrYm5Ic0tkcHhERXdKK2I1OHdOVDhpNi85?=
 =?utf-8?B?Z21YNnFCSG1GQnpjUk5hdis5YnFDeDVjYVhFR08wTTM0TW9tQTJPaS9lY1VE?=
 =?utf-8?B?RUd1RnNaM25BTXNCRVRlU1ZVeGIrd0tkRnhHVzhCQmZLN250ZW56VjltNFhH?=
 =?utf-8?B?N1oyLy9XQzBKS0x0aUhacWVERjdmdFJGMnB0Tzh2RmxqRXd5b1R5TVRMNkFU?=
 =?utf-8?B?WGZKTzN6cXNGOXdjTi9qRENFdHJhQmJjU2RQdmpqU0p5ak5GLzJXaFVuQ05u?=
 =?utf-8?B?V0ZjUkhISDFWU1REeXZ5SXZ1TEF1RHNDYzlWNzBwNGlkeUNsR2hXTUk5NEs0?=
 =?utf-8?B?elVhMzhVY2ZCRERrMHpYVnlWaVA3Qm5RYlVTSGY0TGpFbEJRSVZXdkVaNy9o?=
 =?utf-8?B?RFVHWC9LN1EyTkJST1gyam1ERHhzekdrdUM5bFp6ZXU2VFBOeHUrdmZ5YXNs?=
 =?utf-8?B?MEg4MVFLdEgxZGNHOXFoM3Z2QmhKNzRHdXpHVGp1VHNic2dZM0xLOW1jSDN5?=
 =?utf-8?B?SDdURHVJN094cXhiWHp5N0lRMTZHc2poT1VvSGdaTkwxYnlEYmhzZ2xKVTdD?=
 =?utf-8?B?T1R0Zi9SdnFVWGlnSFV6ZXlqaGtycE9USkczSkNpcU5EdFdHZUxKLzdHQ0dS?=
 =?utf-8?B?NW94bEo3d3pnK0kxOFV2SWtkRWRNWTVxTnBwd3BNaStldGRMUFVweWRpbm9j?=
 =?utf-8?B?UnJuQ1V4cnhFU0NZUksrcjhJckg5RmtFZGxtT3JSZVJwL1hKLzRSTUsyWlRo?=
 =?utf-8?B?aFVrdHZIS2VlZzRzQWFoeUFDazlHZzZXdDRlRlM1dHRtTkJDNWJtRFJsY1c4?=
 =?utf-8?B?dmFHVzJzb3RrekxSOCtMRjZuYzlnR3FhU0F5UXRreFIwc0doT1FGNFZvek0v?=
 =?utf-8?B?cG15M1lhZVgyTkdiK0QremZyRTc5Q1FucGtJVGhYaSsvaVdyZTBJcWd0VmpY?=
 =?utf-8?B?RFFZTTRPL1ZQMDhabzQwWnNKdFc2SkM0YnRRRHZCWnkraXRqbXE3RzVSTEU2?=
 =?utf-8?B?OVZaSXlkVi83dTdVbDJ5TTFlMEswVFUwWHFQSm1kWTBxT0NINHp1MVl6bUxs?=
 =?utf-8?B?Z0w1K1NMTGtSbDRHN2RXWXpZOUU3Y3FJQUlQNnJkeTNvUkVJRkozM2cxMGwr?=
 =?utf-8?B?NWpTbU5PNUMzTFVDRGJVVjBVSjBPcEtuNmhDYnF4OXUrWmRSUmRSWXpwK0lZ?=
 =?utf-8?B?aHc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8223ffe5-cc42-4eb7-6fbd-08da91ce6c42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 19:14:59.3180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8G6I9G8lM2HWpJH8XS8s4HM4I8yuwz6XpCuXdJFP56Vc7QWohl/C61hi4CYyfi7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5187
X-Proofpoint-GUID: PbVn1GfsybmylBk--aphgA7IEGfNwss3
X-Proofpoint-ORIG-GUID: PbVn1GfsybmylBk--aphgA7IEGfNwss3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_12,2022-09-08_01,2022-06-22_01
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



On 9/8/22 3:14 AM, Filipe Manana wrote:
> On Thu, Sep 8, 2022 at 1:29 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> Enable nowait async buffered writes in btrfs_do_write_iter() and
>> btrfs_file_open().
> 
> This is too terse, see below.
> 
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/file.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index fd42ba9de7a7..887497fd524f 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -2107,13 +2107,13 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, struct iov_iter *from,
>>         if (BTRFS_FS_ERROR(inode->root->fs_info))
>>                 return -EROFS;
>>
>> -       if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
>> -               return -EOPNOTSUPP;
>> -
>>         if (sync)
>>                 atomic_inc(&inode->sync_writers);
>>
>>         if (encoded) {
>> +               if (iocb->ki_flags & IOCB_NOWAIT)
>> +                       return -EOPNOTSUPP;
> 
> The changelog should provide some rationale about why encoded writes
> are not supported.
> 
> Thanks.

I added an explanation why encoded writes are not yet supported.

> 
>> +
>>                 num_written = btrfs_encoded_write(iocb, from, encoded);
>>                 num_sync = encoded->len;
>>         } else if (iocb->ki_flags & IOCB_DIRECT) {
>> @@ -3755,7 +3755,7 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
>>  {
>>         int ret;
>>
>> -       filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
>> +       filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
>>
>>         ret = fsverity_file_open(inode, filp);
>>         if (ret)
>> --
>> 2.30.2
>>
> 
> 
