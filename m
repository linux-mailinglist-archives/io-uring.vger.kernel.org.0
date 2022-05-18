Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6DC52C780
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiERX3i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiERX3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:29:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E018A453;
        Wed, 18 May 2022 16:29:36 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24INKb7i016619;
        Wed, 18 May 2022 16:29:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=c2+qzhZJZi2cvSRoGHhhSfzOACg0TZwoyMHiFbunewg=;
 b=pCHxZljnrPyDub7eiaOsIUwkhEom7GSMeEMHM9dFBNrvPUwkgrk5t1la0Vkb2yJCagDt
 nJgVl4pbyQ4YBbKThFoEpay/PEEQVA2pIKOpB0ow5JcH+p2hxW5GfnhY6u+yV/QmXww0
 u9FsNSony2WASabqeRBrIEQ1E/G2SBUfyZA= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g5acy01ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:29:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeAwCVKDsU1vICburYAEln1SW8HsAIEw7+GV/LPZ79dXmrKyqzWZFXiHPRvnENKtqD7YVsEM17rXC8xGAWXeclKvrLd3HNjtISM5usQDjQLkwk3o9wklwqzwbE14pdPiB8/XzeOhayR4RGwttJRO7vT6PIIq59A+VlGoYmHkSXTmEbXPcA4pd37qHmAnkHrBpVe+eyOa/Zd5pJQVx4hJjcFc4DQA9O2RnkDMDOpb7UNSa+ykExtOdcFjrMnFqiDts81C343MJVhfx4QzonuZgjLmZQdu6UE8wb9QSI+NlnDt29TDEBHPTTz2rVEh4Qlouk96dMWRdn352lblx4WVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2+qzhZJZi2cvSRoGHhhSfzOACg0TZwoyMHiFbunewg=;
 b=mlWv3xL17OvmLr6dCMtS5Bst+Ehk5Ksv0zsKHhbpGG/oVQ/3URNSPornksRQQbC3pBASVUY8gEf1vdpOeQy2WtF2I7kHYLjC0UKMFG1Si3nD0J7kb+Oyw7QYBCCDiX0wtagL+VXIZ+CLSClCB3XVeTX0XJ4T4okDStqErFO5Xsuq/HFdS7CAjikHrWTrPZWDMDFTARos/MbaBUNsdUbgxiwNERcmgkF58D+4iYllBf55sWnYYrXnOi+YUYv5SizyKIigZkvo3NxD0ooRZsChQnE/vhUi0U+Nz4oUO6DtdYJHg2hCKwfjt1A/x7rVkwFNtpZUqRdk3b47RzjB7+M2FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by DM6PR15MB3227.namprd15.prod.outlook.com (2603:10b6:5:170::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 23:29:30 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:29:29 +0000
Message-ID: <9e26163a-b906-6667-962f-9c3a0e916d4b@fb.com>
Date:   Wed, 18 May 2022 16:29:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 13/16] mm: add
 balance_dirty_pages_ratelimited_flags() function
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-14-shr@fb.com>
 <20220517201217.sr2sojdeas5k5cim@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220517201217.sr2sojdeas5k5cim@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:217::28) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85d125c7-022f-4bb3-1ceb-08da39264158
X-MS-TrafficTypeDiagnostic: DM6PR15MB3227:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3227AA39091BD4AF61FC1FDBD8D19@DM6PR15MB3227.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aU24AHRHhzg+O4czBXrf4URBzgw13Y2jR9lnfFauzHIMXoIx776dp5/LHazIJtz8d9+rI+zQdUsT5nm67GAeYm9LxDfQYuPWbkQnsAMAL9VUzV/BNrhmCjoM41LYH2xXsmHWFk6HUJ/ozCjI3bt0nWwlH3enC/nwYAPaajlR5t7KsgcUs08udHA4O+qDResdcYbfOx8eb7h5d3/k/mRdgmNf3l9+QmNMzLScpMLbJc76WHeltd9cP33QsjcXq2oetcLp0bQ3f1gcFIVp9d4WUejkiExk9y13umxBvD/2PTJ9nflAitofuATXqvjqua0WjxxACow0+Jh8+B9ZqbEGn1G6Fpgn51MinxX5SQftK/N3PKJDJgngPu5hvy06vXD+gob75mhP3lez1q6N4mUr9RPvLG1uDDBjjw/vgDCHu4aDhyGCR1wyJFRwMO3GLavCnrfHo8LLO3SwsNkZLnr/ykBxFw9VQk0ZlGT7GHWp6KuPS6YOTQqTQGtO/OMxwO8UUSR6CWHdYr9jO7XkDQtku+m8491AUO4DgkO6hMMQKwqgTMiLNa77LsXa5kftiRGYsSjIqzyAldyFOBRycVobESBlEquEFMu4flyNObR4a+egWsyYYkMiuk5IYMlD40uoRj6uAlbUvQYbB8BriRbdWsWe1+8qTYSOjJn1X+m2eb9eHOMz8uy1mMUxk7rwUwpZK4r29MAuWd51FtodyOCmRCriFjriFszuigjsb1jaxBRX2OuY4eS/9E2i8xKkLZXfQ3ZyKpvhI0SD/M9dGEFVsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8676002)(4326008)(66556008)(66476007)(53546011)(86362001)(6666004)(2616005)(83380400001)(316002)(5660300002)(8936002)(186003)(36756003)(31686004)(6506007)(6486002)(6512007)(6916009)(2906002)(31696002)(38100700002)(508600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sng1bGZQOHFTekkxOSt4WW8wTXhnNW1hamhMdmQycFFZWm41NlZtMmhoY2JK?=
 =?utf-8?B?WDU3a0p3WGVlYkt0YjdCa0FYa3RnY2N3ZncvV3N2bDRYVCtwQ1pMSDFYQ2Uz?=
 =?utf-8?B?aDhiUk5sZ0VPUHBwUUdHZVMxd3BVTDljOU1tcVpLOFhyR2pyc3gwNkNwNTE5?=
 =?utf-8?B?d291RTZkbjBxYW9sdkdPUlI2YWFLUkNmSlVFUngzMWQzd3h5RllQRFNHVXRx?=
 =?utf-8?B?VmMxQUd2OVVSc1J4T3JkNzhlWlRUU05KKzhLRGxwT2FPQWUrdStlUHh3R2wz?=
 =?utf-8?B?aTREOEZqNW1rRDhJNWRPQ3lYUWdPY1lhTWFmTnpsZTgzcmxIcThieWVEdlNp?=
 =?utf-8?B?TkJTcE1aL3MxL3RKS0dpL1pIVERWUGsxcVBZR2V0a1BMQ3pZd0gvMTgxakpo?=
 =?utf-8?B?eGVCanNtaEZ4OWlqcnQxWEhFQzFQdVBOR2JEQjJuN1gxQzRnV0VVVWQ5TDFy?=
 =?utf-8?B?d1Fhc2NMazRiZ3BjL2F4NEVtUkQxQTh0VE1jbk1jVUgzU2JidVJtSHhpVVZS?=
 =?utf-8?B?QlBnUkxNeGJ4VWlzeGxhYkVCTnNQd2VFYXZPZEVidERnbUxHcUJBTitkVDlE?=
 =?utf-8?B?TnJ5WDhaMlRBUWR5dTdNTnYyOTczcHArTnBBNHBrRlVwU240ZXV1K25scmlP?=
 =?utf-8?B?b3Mwb1JnSmtKc1JQSko5RndmUnExTFhRZHQvaHh6RWRWb3lqYTBNVktUTHd4?=
 =?utf-8?B?S2k1ZG0zcjUrUHZTaU5JTjY3TEIyQ3BIUmxpTXhBR1lFeDI3TVNMbUlWQXU1?=
 =?utf-8?B?R1JQVzA4cmt6b0d4a3EzSEZkd0Nuckhickc5NzlUT1I0dFB6QnVJWllaa0wv?=
 =?utf-8?B?QUtPMHRyeER3V204ODk0NEl1VEUvbXJ4eEl4VGs2cUdrR3JRb2k2d0V1OWo4?=
 =?utf-8?B?RG1vUHhyOVhFbFJQOURmZlVtMEQyQXVwcDQ4Z3RCZzZ4dkp3aEZsNTZWSjJo?=
 =?utf-8?B?eW1BamJTQ0pjY2J5dGxpSWlGOFhsb0RTdVJLNFBTcW5Ccm9GQ2FjVlVJdFhs?=
 =?utf-8?B?cXdUazRkaHNBNERMVzlYOTN3d3lGTkNzRzAxS1d3c2d1WUZweDhCS2FCUzI2?=
 =?utf-8?B?Z2NpZXNUSVkzeld1SXRYNXpLZHErKyttT3Q5cnZYWW5Mc0gxNTBRZklCaThi?=
 =?utf-8?B?d2duNnBSckdOK2k2Q1N2ZGZwSHpjelpQb0ZMN1hYVzFDVm5NcHEwNGtxcnNQ?=
 =?utf-8?B?eW45enZic2ZzejBMOTArLys4MXFCeVdDVlRmVi9HTjRjM3pTU0p1MEpYamdr?=
 =?utf-8?B?bzBqZ2EwNUpMcHJ0UU5mbHhkTVh4UXlRSGYwQmtrcS9qa0ZmcmducDlwdnJH?=
 =?utf-8?B?VUpWdUhTeUMyZzAyYUM3UTdGOVhSRWRSc3YwdTRuMGNUVmxaY2c4YmJ1SklB?=
 =?utf-8?B?emszVU1EbzFpOU9hZklHMlBlUjVYWWpON291UnpOd0JJVzR1VVhRQysyc2JB?=
 =?utf-8?B?bmVkTTR0TEF0TW9SYzhad2oybmJjZk83VG5hTEp4eUJnQXJwZU9sTEordFBu?=
 =?utf-8?B?V0kybDZZM3J4U29wY0JwejMvZmYxdHFZYzNvdXNOT2o5WXp4RWc5Sml1NWpy?=
 =?utf-8?B?RW9iOVNqcmR6S1RaalJsY0FUQVdXR0JxUEF3cnozZ0FEa1FwVkhjZlFZTDh4?=
 =?utf-8?B?R3MwQ1YvaWFYN2ZPblNFN2thTjIwSGhYQ2gvOWsvZnZOZ203cElYdFlrT0lj?=
 =?utf-8?B?VFFzSHpCUVpUb0VOVytaQjJCMDBTcVFyOFJTd2tveGdGVk1sWllNTW8vUEpQ?=
 =?utf-8?B?YW55a0pycmp2YlhXSEJORGp6c21JZEVLbVJpNmlqbjl5VTQ2NUxzdWhOR0g0?=
 =?utf-8?B?R0x1QW5jRmxoNE1SS0V3Skh0RWdJeWwwdUNGcWhuVlJLblA0UTFHTXZSMU11?=
 =?utf-8?B?NDhISERXOEk0T1o2RzR6cGJGUG5ZQ1NhZzAzcHkwYVo0S0E5ZDloZTRDRXMv?=
 =?utf-8?B?ZGRDNk96UGUzNFZUNDdFcWFyVEhoaWxxNm51Z1RSdlhCVU83VXdRVGFZSkxh?=
 =?utf-8?B?R1FKdmhZY1dSMkZuSW5GaVNuY3dQYWw2MUpNeHVWL0RpSlM0SmwxaHl4UFp1?=
 =?utf-8?B?ZFM1Rm43cGlVbS92WlRpMTdyNjdPdEdYT1Y2SUQ1b3ZjQlJxbXFocW0wU3Mz?=
 =?utf-8?B?ZVI1UnU2WWdNNmMvZ3Z4WWJmNHRrUG5qV3A4ZVRLdUVCa2pRQXJzamZhV2Zi?=
 =?utf-8?B?dWxiazYzeHJWRjFXR2taVTZZZVdhMHhOZDdLYVZVN1k1bGlyeHZYdjZpOW9t?=
 =?utf-8?B?TEIzcEVLM0xVd3NpWFZjbnBrMC91Smg0WWo0dnlzMStwYlFqbzMzSHBKSFVt?=
 =?utf-8?B?QXYrWWJxTUFuZFgyaXZ3amhaQzlBOGtBcTZsYkhlRGJGd3N5VGIzeFZuVmRS?=
 =?utf-8?Q?rBJ4D4nWI9+WSUNI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d125c7-022f-4bb3-1ceb-08da39264158
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:29:29.5274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/b93I4VYSCoSrKdTpkmz6pIHbFWkhTHHGyM7Y1DrRWI61LsEfiQp9TNSKaZasT1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3227
X-Proofpoint-ORIG-GUID: VU1kDQVn_6XKkNb1g01Uf0gTCb0wRazT
X-Proofpoint-GUID: VU1kDQVn_6XKkNb1g01Uf0gTCb0wRazT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/17/22 1:12 PM, Jan Kara wrote:
> On Mon 16-05-22 09:47:15, Stefan Roesch wrote:
>> This adds the function balance_dirty_pages_ratelimited_flags(). It adds
>> the parameter is_async to balance_dirty_pages_ratelimited(). In case
>> this is an async write, it will call _balance_diirty_pages() to
>> determine if write throttling needs to be enabled. If write throttling
>> is enabled, it retuns -EAGAIN, so the write request can be punted to
>> the io-uring worker.
>>
>> The new function is changed to return the sleep time, so callers can
>> observe if the write has been punted.
>>
>> For non-async writes the current behavior is maintained.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  include/linux/writeback.h |  1 +
>>  mm/page-writeback.c       | 48 ++++++++++++++++++++++++++-------------
>>  2 files changed, 33 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>> index fec248ab1fec..d589804bb3be 100644
>> --- a/include/linux/writeback.h
>> +++ b/include/linux/writeback.h
>> @@ -373,6 +373,7 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
>>  
>>  void wb_update_bandwidth(struct bdi_writeback *wb);
>>  void balance_dirty_pages_ratelimited(struct address_space *mapping);
>> +int  balance_dirty_pages_ratelimited_flags(struct address_space *mapping, bool is_async);
>>  bool wb_over_bg_thresh(struct bdi_writeback *wb);
>>  
>>  typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index cbb74c0666c6..78f1326f3f20 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1877,28 +1877,17 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
>>   */
>>  DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
>>  
>> -/**
>> - * balance_dirty_pages_ratelimited - balance dirty memory state
>> - * @mapping: address_space which was dirtied
>> - *
>> - * Processes which are dirtying memory should call in here once for each page
>> - * which was newly dirtied.  The function will periodically check the system's
>> - * dirty state and will initiate writeback if needed.
>> - *
>> - * Once we're over the dirty memory limit we decrease the ratelimiting
>> - * by a lot, to prevent individual processes from overshooting the limit
>> - * by (ratelimit_pages) each.
>> - */
>> -void balance_dirty_pages_ratelimited(struct address_space *mapping)
>> +int balance_dirty_pages_ratelimited_flags(struct address_space *mapping, bool is_async)
> 
> Perhaps I'd call the other function balance_dirty_pages_ratelimited_async()
> and then keep balance_dirty_pages_ratelimited_flags() as an internal
> function. It is then more obvious at the external call sites what the call
> is about (unlike the true/false argument).
> 

I added a new function balance_dirty_pages_ratelimited_async() and made the function
balance_dirty_pages_ratelimited_flags an internal function.

> 								Honza
> 
>>  {
>>  	struct inode *inode = mapping->host;
>>  	struct backing_dev_info *bdi = inode_to_bdi(inode);
>>  	struct bdi_writeback *wb = NULL;
>>  	int ratelimit;
>> +	int ret = 0;
>>  	int *p;
>>  
>>  	if (!(bdi->capabilities & BDI_CAP_WRITEBACK))
>> -		return;
>> +		return ret;
>>  
>>  	if (inode_cgwb_enabled(inode))
>>  		wb = wb_get_create_current(bdi, GFP_KERNEL);
>> @@ -1937,10 +1926,37 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
>>  	}
>>  	preempt_enable();
>>  
>> -	if (unlikely(current->nr_dirtied >= ratelimit))
>> -		balance_dirty_pages(wb, current->nr_dirtied);
>> +	if (unlikely(current->nr_dirtied >= ratelimit)) {
>> +		if (is_async) {
>> +			struct bdp_ctx ctx = { BDP_CTX_INIT(ctx, wb) };
>> +
>> +			ret = _balance_dirty_pages(wb, current->nr_dirtied, &ctx);
>> +			if (ret)
>> +				ret = -EAGAIN;
>> +		} else {
>> +			balance_dirty_pages(wb, current->nr_dirtied);
>> +		}
>> +	}
>>  
>>  	wb_put(wb);
>> +	return ret;
>> +}
>> +
>> +/**
>> + * balance_dirty_pages_ratelimited - balance dirty memory state
>> + * @mapping: address_space which was dirtied
>> + *
>> + * Processes which are dirtying memory should call in here once for each page
>> + * which was newly dirtied.  The function will periodically check the system's
>> + * dirty state and will initiate writeback if needed.
>> + *
>> + * Once we're over the dirty memory limit we decrease the ratelimiting
>> + * by a lot, to prevent individual processes from overshooting the limit
>> + * by (ratelimit_pages) each.
>> + */
>> +void balance_dirty_pages_ratelimited(struct address_space *mapping)
>> +{
>> +	balance_dirty_pages_ratelimited_flags(mapping, false);
>>  }
>>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
>>  
>> -- 
>> 2.30.2
>>
