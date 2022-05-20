Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC4552F291
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350444AbiETSYS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETSYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:24:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15F8190D13;
        Fri, 20 May 2022 11:24:15 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSacJ020010;
        Fri, 20 May 2022 11:23:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ej+vocW3o5XJLegJHhmA8oxjHroQJztkSu+OCJH8gKY=;
 b=JUc8k2n8HDIwdlFvy0PfA9yJMN7Ve36YZe2IBPW7iujcKWKAFUKCiUIpkz4FK2SVe3FK
 RQuw1Xd8COK6KKZouW559oim1GmbKislKgPq+W1Cir9pwYdIiL787UsBVUJsq8nEVN+E
 /F7bePzTz10hZDNRw/2/zatVV8KVaoaLQlM= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g60bnn6tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:23:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq4jxxN88gHT2ABYsrbBsYHmzNjwsPxaf+FLqiqeV6OqstKZqEDKgnzTjYo56GfUEZAGTuBp98VMa3EDTmuXiTuZ/JkcnZ45Kb4Gu/ZccnjH/UNM1f92zxPjVGFAY3GV0GBvGSOMLaF47KXmK4PP+kLmgApbi68JxxjYG8KeTXpd+c5e0p1LmeE3r5q0iS9v86TwvC/xZgBFnjE/ZKESflT7NXZ8F5q8nJ9McEN++s0Rmm+qK/EWR5PwZzqYj0bUY7KGYunHbmzOjZL2LPU41NIRS7L3dzo0CZOsPJAmvPBO8xomuuRkHj6BeuwEG8WIwVoOsgN491GVSuH+dDcN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ej+vocW3o5XJLegJHhmA8oxjHroQJztkSu+OCJH8gKY=;
 b=Fyk7BVZt8iQgt++xpwbxFuOBf/4MTlpTWCsmQQt0LF3mT2/wBpi4nGiPOxVb/c4TlQn+4q0J33Bv3kwsIJG4TyYD8Kgefu22HeWus+Fe8yzl1a4t0mTOgSroWHD+DOZf5NxyFHouMMVqgHD0/BcmFYqdc9AzlstrdUg/Y1jSA6kt9mlbeYS9nFftTJUW+E+HtcdTc9KeeI6H+E4Ipo5frpqHCYQoa4PfY0pnRPrsOvJ3jl13DpsljxliMJiHGHCRJyoO1ugGZ60W0hdBLBklRavwa715eYLlC1Ulje6DfUgTfRQye1B2ebCgacBsPqpnzA9ebmRoJdWR3P/yl2/Ryw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by DM6PR15MB3595.namprd15.prod.outlook.com (2603:10b6:5:1f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 18:23:57 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:23:57 +0000
Message-ID: <f75d47d5-b433-4356-5e69-1d5ceb5fdbc5@fb.com>
Date:   Fri, 20 May 2022 11:23:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 01/18] block: Add check for async buffered writes
 to generic_write_checks
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-2-shr@fb.com> <YoX9DVU5ds+GbKOK@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoX9DVU5ds+GbKOK@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef87cb81-a5bb-4da2-e763-08da3a8de713
X-MS-TrafficTypeDiagnostic: DM6PR15MB3595:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB359587237A470B2078DF667CD8D39@DM6PR15MB3595.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4t3Dy+0kMwRHn7O+E9YjOjD3/Yt2VEiaFJRsL/HMMkcZt7ERkvT9T3NMB+iisV29n3QtamPYmkzS0AH7ERDRoNNLeqLnNHhJj5w3ivR11VhQLf/KmGHG6OZBzesJ0m9r67+3eQCIpVpiKyEkCT6e4ZJnsfCPaXmYippDshgTX+/YdUNgKpIswZJTIo8zKFUdeINY8Jz6OOm5yO4oioQ8F1e766tgLCulj7nqoLgNk576HQXa+s+D0wxGwwHoi2/jUZJbP7fTPXKpQY/7apoo0oCzBeDXI6Lc1zMPLbnFryWb1nGIBG3yYnVqKzeI653Vjef67fACwPwq+nfROovnxFs6AcBhCkIxB56UTodI8jBobDkm5tMn80oXQ8DZLYPobcb38YtVu566Y24cw9fR8AFqTHToCVYOTIQFNvUZ6Png3qAb8zAyp/k/qkdr8UEQUu2bHFbPA5amOqCzF1iWFSMn47JdBXolSYeUA1t5SyIkIcNN014w013cQ5+rnjzMGG7OHLUVlDWVobYxaXOByMMrPUgisPqj2tJtrJEkOwIOfG7ARaOQB2eQ4zF3vNYHPbfgpUOa+HcCHG5elUj4qy8yMgZsC7U0HmM8ZlIBm8z/L78jqheaqd8JOm3cL0sJcno4hCS43aPrb+oCX3hS3+kocHYJuzezMCHNifMbKf16MzydF38kl1yt7k1BI9lJqb5hAl5fI3Hhzckx51Rk9UPfVItlDMFAO4Qu2dU7H2rtspzlOxKMf0h5yMt3mzMV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(66946007)(6916009)(86362001)(4326008)(31696002)(66476007)(66556008)(2906002)(8676002)(31686004)(36756003)(6506007)(6666004)(6512007)(53546011)(5660300002)(6486002)(8936002)(508600001)(38100700002)(186003)(2616005)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0dYYWxUOVpNWnova3kvbGtpeUM0ZVNsdTVBSUNYWGVpTU1lZTZwZU95aDNq?=
 =?utf-8?B?WlgxMWYvWHh6K1o4ZlZNUjlMcm1EVWFLSnpYNlVqYW5BaU81MzZ0dGRpYmpO?=
 =?utf-8?B?WG9US01UN3FacEsvSkxmYjJYaHpFeERBMzVHaC9GZnpJTlR1ZURxRDR2Ym5m?=
 =?utf-8?B?amZWWkxIYnh2VGFDaFFUMmJBalZVY3lqWjBURjhhc0ZEQk4rOCtYcmpxRVlJ?=
 =?utf-8?B?cDBIN1BseGFnZ2Juc0wyVzZnTEtTZUU1U1pCOHJYUzY4R3JvM2R0SDA5TW1l?=
 =?utf-8?B?SzZOaEs5UTU3WHIrZmp4ejhYU3dlVVRhdUtqeDhFZUsrbWQxY2FQTEdmMm1s?=
 =?utf-8?B?VUlrRWQvWDR1Z3BGNVB5Rk1sTEliRll5NEhwcVdnYUd1bTU1cWFSa0hBejJ5?=
 =?utf-8?B?cWlvTGoyN2NWSzFoZFo2RHNKOWh4VCt2ZW82Rm00WnltTko0YlNJN21VZGtH?=
 =?utf-8?B?Z3cvUWcvYld6RzhXYzVZTWhtczJwZGVyQkF3RGQzcEFCYmFiRWtMTVV0L0hQ?=
 =?utf-8?B?ZDY3SW1ZK3UrOEdWSXVqVGJFc3AwNE1sWmZIOUVsa3R0QWMyOEQwdU1hUXJR?=
 =?utf-8?B?c0VHMi82elBYejhDTlVBZmUzRTNKdnpWU05jejVIdmwzbXRmS1BrSzhvaEhu?=
 =?utf-8?B?VklwOFJIVnpYSVRobDJSdjI0R0grZEVGU2oxQm1VMElKbVhTbGZmT2hVZHJx?=
 =?utf-8?B?ZEJTbHpQSHgyNkpXWU12U2RITklLOFIxajZGaUtNTjBwcFJCQjRtL0M2Zk5o?=
 =?utf-8?B?WkxpM3BEclc0Z2EvVnZ4K21qS3g2TndBR1VyVnkwTlZPcmxPaGl5RGN1RWRi?=
 =?utf-8?B?bHZNSndPdk9lb0c0VnBlVmpaZ2NsTkZ1NlRLbjBWSVlkRTc3Tm5Hd2ZDZHdT?=
 =?utf-8?B?SDJ3cUFWWGtzSndQOG5yVHdnbWVzeG8zYXNhL1VpL3BKbnR1VVg4Y0tCR0c5?=
 =?utf-8?B?dkJtNlZnbGNFNE5RZzdxMkRpTWg1VjdhRG44YjNLOEhua0NzM1FUa2FNclNB?=
 =?utf-8?B?UzRnNVlWMGYyaWszUFczR05VUERoTEVCSUd5WnFDUXZIOGNCS0ovdzN5L2lV?=
 =?utf-8?B?NkhSeFZ5QlBrWEVxcUhqak5PeHNzNXFLdlBKb2NhQ2tJRGdRVEFoUHVOS1Vu?=
 =?utf-8?B?ZFVvSlpHWXVhRHpDS0dJVkdJenJsQzFOdzhIa2hDeWpXQVZaa01TcmE2cjdK?=
 =?utf-8?B?eXBpSGVqMnVJRlRQemhLb3hQaHovU3lXWW4yNXc0TkJRKzFXRkprcmZKcFhD?=
 =?utf-8?B?amM3aFBXbDI4cm40NjVPM1V4WWs5Q2xCd1I0RUJzZ3hyU252bnUxbXpQS29O?=
 =?utf-8?B?VXYrN0RHb2lHcEhDcFdkWG8wOHNmblA5eWFxV25LZVhvMnZJaGprN3ZXSnIr?=
 =?utf-8?B?K20wT01QMm5qN096d0o1NjZ2Y2dGbWhvNGhVTGVaOE1mQ1JmYkdNcmFobnBm?=
 =?utf-8?B?WWVDekdLNkxXNzk3VkZ4bVpjMmFYS1NFc3NmQ0VtMWRHRDZVWm05RTZOaXpS?=
 =?utf-8?B?bGNtdEp5bHBpNCtGcDkzMU55dWhKT0dzYVVpWStsczE1em5IaytqSTIrNjJ1?=
 =?utf-8?B?VTdraWZFOGUzREZ1Y2Q5dFJRcVBuMDRNSGREd2pYWmg1c0xGMjN0UFlkRDNv?=
 =?utf-8?B?TGVBMUxQUkdIcEx4MFdVWnA2OUVweVRSMER5MUsyTFEySVN3bmVvYThiQ1Rm?=
 =?utf-8?B?bzhlUkVqMDNxaXQvSExHd2kva09VREhud05hT3kzUXJtMUVjbFUzaXBwd1Ar?=
 =?utf-8?B?c0Z5LytsMVJlMHZMOGEzME9GY2VPWVFScUJuZ1ZqdUtiekpjUTExYzdrZzZ6?=
 =?utf-8?B?ajNPS1kwalUzZkF1VzhsVTlrYWptT200ZUlnSEx4UzRkcEEwS0p0V05lWU5K?=
 =?utf-8?B?dTBibFZNV0FTTkRtNDJMR3FWNmk3QWdPb3pIWCtIdXVLN2sycFAwUFVMOU53?=
 =?utf-8?B?b0ZqK0c2Yi9GMzRLazFtL3QyVmM4Z0hiblkyWFZ2QW5HRjB2VHlzcEpLNCtH?=
 =?utf-8?B?TXc0ZWJXaEJFNC9kQ3FvR3BodzVkTm5GQUxrTDhXU3RRdjdHR0VnU1JTRHUx?=
 =?utf-8?B?a2cyM29NY2RNYk0xZDhYbFo1SjBlZG0xOVY3TGozQktXcjU4eTlUVGhTSGI0?=
 =?utf-8?B?REVVK1krU1Z0cFpORkJQeHh6azJOZEVSRk5keVNmeUM1K2Zna1RqZW5pTnF0?=
 =?utf-8?B?UG5EaEh5a1lXbUxZVnNXbHJuTlR6U0RNK0h1VWdxWnFaT0RPbWdxRzVnejNo?=
 =?utf-8?B?dFZtNm9Kc2NHUTBuYmxXN01SVzdiVFlyMXByS3NZNUlQSzQ5M0VlNVpteGxm?=
 =?utf-8?B?RGl4M1pBZHpvY1FhYzhNODVHUkNhMDlUZ2dOVGpmQTZyODc4a2J2b1JJS2Jp?=
 =?utf-8?Q?qoohvIErY4qBPa+Y=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef87cb81-a5bb-4da2-e763-08da3a8de713
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:23:57.2062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPx0v+mkGBDIbMeTana6q6DnZXdCzOLnBN5JxdY/0Jv8qK6blr2rIbK1SA3UMvXo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3595
X-Proofpoint-ORIG-GUID: fg1OHbHM04F3xtwAbeMxVm3KWabxMPdR
X-Proofpoint-GUID: fg1OHbHM04F3xtwAbeMxVm3KWabxMPdR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_05,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/19/22 1:17 AM, Christoph Hellwig wrote:
> On Wed, May 18, 2022 at 04:36:52PM -0700, Stefan Roesch wrote:
>> @@ -1633,7 +1633,9 @@ int generic_write_checks_count(struct kiocb *iocb, loff_t *count)
>>  	if (iocb->ki_flags & IOCB_APPEND)
>>  		iocb->ki_pos = i_size_read(inode);
>>  
>> -	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
>> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
>> +		!((iocb->ki_flags & IOCB_DIRECT) ||
>> +		  (file->f_mode & FMODE_BUF_WASYNC)))
> 
> This is some really odd indentation.  I'd expect something like:
> 
> 	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> 	    !((iocb->ki_flags & IOCB_DIRECT) ||
> 	      (file->f_mode & FMODE_BUF_WASYNC)))
> 

I reformatted the above code for the next version.

>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index bbde95387a23..3b479d02e210 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -177,6 +177,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>>  /* File supports async buffered reads */
>>  #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
>>  
>> +/* File supports async nowait buffered writes */
>> +#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
> 
> This is the last available flag in fmode_t.
> 
> At some point we should probably move the static capabilities to
> a member of file_operations.
