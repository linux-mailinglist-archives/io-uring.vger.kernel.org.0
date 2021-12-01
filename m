Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E23464706
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 07:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346844AbhLAGLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 01:11:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47308 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232327AbhLAGLW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 01:11:22 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B10XJIx025855;
        Tue, 30 Nov 2021 22:07:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H4k79Ei26Kia1ENB0lT1/cPs10bAwg1+vjVhtje0rSI=;
 b=aHcqSyMbXEnn2avtREiqbaM6vgMqfVN1syO+7OFao7bs3hXhyLr8tEG/XVHwb1kJhC7v
 C8TZC7B+uu+X+HdbXgbnPxvZ1i5HHXezBlefvNV4QEqQ/yv2Lw7N2wE+fSSOx0wUg6sD
 93AslbX1/YrMGwTrmWskJ6I98NGfOggpqx4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cnmccemd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Nov 2021 22:07:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 22:07:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPf+QcVQ37nqjCd/hbku3JMVgSAH1Pqwj1y49d6nW6qmHnH0V8hF8JiZdPqX2UTGWbhZEQHYMOk/A2DSbMJG/tSf5OGWDMLIWaIsuxbsM1DWDPKFXsaa+uHprJjkrjiuFSqT2TtoI2A7zXpRAyrfzt5rbRCb0Agmf0P8BksFRoNKPbfcUVRofdAVvr3J/PB8IgJF1JMyE2YU/y2ixgWm7B0WLhuFC2NXuitctO66Cm9DToTwL9HC+V5cOcKQAAYt//TlnZmtjCVuZY+BNSvj2z/HBATB+qSmT+rAQvYeDtziPdIEG3XKmt83X34CtlPYFseuz6NFLXIT5IshCjyj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4k79Ei26Kia1ENB0lT1/cPs10bAwg1+vjVhtje0rSI=;
 b=ESXqXHknfYsOjz1N7rg1aXQOD4jm6I2jfQAFvYaY7MzBTcQ9dPyTPbx7hv9gY5Zx8a5kmAcs5gpIozDU92xBRznNSE4gMA5HKq0O2CdH9oGArdln9IWrqjJdPp8gQABvq+eKHbq2MhXW0Xuu6FkBuBENUsw2B3LNfV199q6tJAalH0ezS7NrzldG7aei3vZ/P+Tk8WanBkjbabMg4QVOZw36ShYbD6c6X0vcBen9EdO4N1IPxuAOngBo4liyMPKg7w9MPiziU8bPlZbgBQXTqY6tbcgtgtMhVbdCY28AjNaV1iBDkDEhLfSlT5hY/OYo4V590F3GEY1yW3K3Bz/7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by CO6PR15MB4196.namprd15.prod.outlook.com (2603:10b6:5:350::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 06:07:50 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%8]) with mapi id 15.20.4713.025; Wed, 1 Dec 2021
 06:07:49 +0000
Message-ID: <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
Date:   Tue, 30 Nov 2021 22:07:47 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Content-Language: en-US
To:     Clay Harris <bugs@claycon.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0146.namprd04.prod.outlook.com (2603:10b6:104::24)
 To MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c8::14c4] (2620:10d:c090:400::5:8065) by CO2PR04CA0146.namprd04.prod.outlook.com (2603:10b6:104::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 06:07:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 442dd502-40d9-4820-9332-08d9b490e73e
X-MS-TrafficTypeDiagnostic: CO6PR15MB4196:
X-Microsoft-Antispam-PRVS: <CO6PR15MB4196426E6B36C3D12D1AF6C5D8689@CO6PR15MB4196.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAvMJ0gopk7J2dLuEPYfz5oVqwLvwyOGzV2m/21YpTvUzrSFVtSFhCFpV3ojWARF72yfIXNazQ7zXgzKIcEL5ADyXqYs/i5dyktzirGpYSNv2K5KoOo5L3XyOnEWbRtmPiqnpdCDPFM/KisQJRg7WWIJMMm0ZMWdQnX2n6jfKZHQbSN270eWueW91m+wHLdiKJVdYu40pE4YCEmIy0SADwxD+2Zo6JREbjZz2xfi4eWRYgxTjb3qSP4uSgYMkDtg2kqaDHapmxMjthsrVywv6mU3n/QKC+dJkbIkV/HSmtGAASsOuCMJ4aXhCN5HLtuxyuTYSN7H8o3HqLwljTqR2nijHmXOWrJCIC3d01S0MES1W37L+BtV7PcjSrJwmS3/VarzE4CzGFUZdFY8dn1S1isXX4Az35YvHmpHI/xkvDK+8izIkTttcH3bCDWMKY08wg3R3y8gqq38LwHRdWFkQLnoB43tGiJMbii4Nj9BFDr23eAKDzELs7n6Qf+ywbtgvW1nrJLoZowVvAkWaurkTm2VPgow3S1snMarX4TH8kt1ClvF1ojNNANeEuuRotfmYopOvFf7aqlrGYLGnQXa2k2Eo3CuKkym9bajB8m3bVwB/1cgjOxTkF2Jxfw5zzXpB6YOWim+tLbuiaYb8P+jXsRFWgZaLWf64P5rw2c8RVUz3HFOAr1P+yOZfhDbEybaQmRJRk7+vQiQF/PQp6KoTYx7+4ReEl0wkT7B/sLXwio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2616005)(8676002)(36756003)(186003)(31696002)(316002)(8936002)(86362001)(5660300002)(508600001)(31686004)(6486002)(6916009)(53546011)(66476007)(66556008)(66946007)(2906002)(38100700002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d01CeDMyWDJOZkd2S2w0N1Z2dHVaZFZzZlozTjZudDFLZTlFQjdRYWVlTkxM?=
 =?utf-8?B?QnByOFJhNk9sRXpxaE1qZzV3UnphNlBSK05tNEp0MHpLQ082Uy9GMjNQMTFV?=
 =?utf-8?B?aGI0TCtWa3NkaVZjZnRGRVZ2SENmWVMvN3F5TzZSMEtlNjBPUmpSZFJBVmR3?=
 =?utf-8?B?RGhSd29wU3ZZRWliTDFtNENhZjhTaGtXVXJ2bVltSFhiaTdSZU1HMUNwalFw?=
 =?utf-8?B?Rkd5ZE9zRjZNbExCLys0ejQyK2ljOHJRVEF4TEtJMlJFVG5MVHNnU3NSZUUv?=
 =?utf-8?B?SGNjRUJaM29SaXh6S1o0S3VhTkhwYXpFQmw0S1dkSHR3NjJ2MnBFaHkrT1Nk?=
 =?utf-8?B?VGRMU0NNTkxtT0I0NENndHFvbk90b0YrMTVJN3I0eklHcURJS201a3FGSTNz?=
 =?utf-8?B?blM0SkZocTkxMlN0blhrVWhkZkZnOHhpaHRnUUpEQ0VubnJNaGxDWk01TFdn?=
 =?utf-8?B?Qm1OOEN6bVlmTzFTS3NZYi9rK0ZRUWdjY0RvcnphWlJudndla1RueE9CeWx0?=
 =?utf-8?B?b0VUWEhWekpEd3k5eDVkSUlOSjZFemQzYUEyRnhyQnBCT0JWeXpGZTdNb3lw?=
 =?utf-8?B?QkNxN3JJSVNXVkFsMGlQbE9Sb0VaUTVreFFhTno5UHJ0a0x0UnJwMmMzWE9E?=
 =?utf-8?B?SHB5TENIMmF2OXdoa0pHOW8vQitONkFrNXlucjByUzdZODlITG45SmRrM2xQ?=
 =?utf-8?B?TEJ6ajNqTjBZL1Q0bEFRWnhFekxpckdqYlEySUh1OHBHamxYM1dZby9kZmhq?=
 =?utf-8?B?aEs4dmhvLzZncUdZbzBvRElsSU4vMXBJcm9NbHRtVVlscjRTcXBGTEN0b3ND?=
 =?utf-8?B?TW5Ja3NDaTZFbXJBUUtJSm1xVU5DcVBQQU1KMmFGMjVKL1pTb1FwSk5kTGU1?=
 =?utf-8?B?ZmxRR3RsZXhPWngrUHZGelhSRFE5WnpvdE9QdmxhWDloQi9kREpsZUtvYjFa?=
 =?utf-8?B?ai9KKzEvdUxkK2hVcU9vN2d5Rk1DZ1hyZXVOSk80Wmgrc3FiZ0Q4b1dTNjJD?=
 =?utf-8?B?Z2M3RmpPWGoyWGY3TWpqa0VYaVRlMzJqYm9iQ1dPLzRBbzZUQTFrRzNDMmw4?=
 =?utf-8?B?ZnA5NXBQbzM2b0hJZmRobkRVZGd0UElESVJiQWdMWnQ1TXpKVEFLOElDVXl4?=
 =?utf-8?B?NFpGQXVDdXVEV0t4Y21weU9HdjNTa043NkR6QVlDMkFIcUw4cnJTYjh4UmRX?=
 =?utf-8?B?Zmx4UTJCWFdsMTNXeGNnTGs4Mkh2bERWbHRlRCtyOXlsUUpaR2JlUUJSTU43?=
 =?utf-8?B?dkpCa2RicmtyMi9QYlhaSjFPT3VUYmpVUE9NREpkUzA1dlVTNUVkNUJXTFJP?=
 =?utf-8?B?ejhLMncwV2xzenBoMlZadmJqdmJ3eE5CZ2hLeVZwUXBOeXFmeVNCNzZFdG91?=
 =?utf-8?B?bGRzZmJScnFGbFlhVWZmRWpjTzJwR0RWQmtMRmdPU3pLVFZVV0xWWWtOb2xu?=
 =?utf-8?B?VFBGU3JQeTdkRHFqMmZhZnBoekhOeDZ4Z2xxOGRXWnBDZ2RyUUNnWEpmaHdR?=
 =?utf-8?B?S1ZQL0lrTkEzM0dqUjJMT3pCNG1uQThPdjhXN0g2R1RjR0U2YjRuVVVaeVFp?=
 =?utf-8?B?SGdyMVJNSjMwWGR4SVBZUHNsMXJOK253NC9ENmRwdVplbHNqVGxnc1dVMFBB?=
 =?utf-8?B?NDVCalU0WUowbmVRYS9BamkyZ28vSmR5eWhiRmhqTW9xMTU2N0RCLysycG5i?=
 =?utf-8?B?WXlBOEtjYmJURWIrTlYveHhiQmlzMkFodWs5ZHNqTEVuUnBnQm85K0NZTXVx?=
 =?utf-8?B?SUNtazFOSHBiSEhKdTJTUk1oTVpFZEdFbFlXZ2h3Q1h1WjErZ1BQSm1WRmdD?=
 =?utf-8?B?LzZvQXRTUkQvWXo1dlRGd0JuMVh4ZUtadmljQ2c0V2hyZDE5YnUxaVAvMnV3?=
 =?utf-8?B?NTVLSGpjdVZ2SHdnTHJqalhsNXdhdkVzV29NNFVkZkhnRThWOVEyOEpJRzlE?=
 =?utf-8?B?aWVlc2lUbkhJSFpiRytXZVNGNUU1Q01CRWE3UUM5N3d6TEJlWjk5VGVTb09i?=
 =?utf-8?B?cHJzQ2NySzlqNVNmWko0R2p3QjUzckZNaCszQ0NVdXRHZ2pLU05OeXF2Z3Fw?=
 =?utf-8?B?NndGTlNsd0Rhb0Z5RXVLcGVqcklXM0V2MnNMUHgwYmhzZk5LdldFSW1BTTQ1?=
 =?utf-8?Q?Prq9oyPxPMpYe1cGsCpA/fouv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 442dd502-40d9-4820-9332-08d9b490e73e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 06:07:49.8798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJpH4kEiLr8p59DkJBDiw81BlF34umJK7vIldd8Y0QqHakfrxKNI24AVKc3U8sJk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4196
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jaemjCB_htP8G54g8cq1Y6tkToDMSqik
X-Proofpoint-ORIG-GUID: jaemjCB_htP8G54g8cq1Y6tkToDMSqik
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 impostorscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112010034
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/29/21 5:08 PM, Clay Harris wrote:
> On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
> 
>> This adds the xattr support to io_uring. The intent is to have a more
>> complete support for file operations in io_uring.
>>
>> This change adds support for the following functions to io_uring:
>> - fgetxattr
>> - fsetxattr
>> - getxattr
>> - setxattr
> 
> You may wish to consider the following.
> 
> Patching for these functions makes for an excellent opportunity
> to provide a better interface.  Rather than implement fXetattr
> at all, you could enable io_uring to use functions like:
> 
> int Xetxattr(int dfd, const char *path, const char *name,
> 	[const] void *value, size_t size, int flags);
> 
> Not only does this simplify the io_uring interface down to two
> functions, but modernizes and fixes a deficit in usability.
> In terms of io_uring, this is just changing internal interfaces.
> 
> Although unnecessary for io_uring, it would be nice to at least
> consider what parts of this code could be leveraged for future
> Xetxattr2 syscalls.

Clay, 

while we can reduce the number of calls to 2, providing 4 calls will
ease the adoption of the interface. 

If you look at the userspace interface in liburing, you can see the
following function signature:

static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
		                           int         fd,
					   const char *name,
					   const char *value,
					   size_t      len)

This is very similar to what you proposed.

> 
>> Patch 1: fs: make user_path_at_empty() take a struct filename
>>   The user_path_at_empty filename parameter has been changed
>>   from a const char user pointer to a filename struct. io_uring
>>   operates on filenames.
>>   In addition also the functions that call user_path_at_empty
>>   in namei.c and stat.c have been modified for this change.
>>
>> Patch 2: fs: split off setxattr_setup function from setxattr
>>   Split off the setup part of the setxattr function
>>
>> Patch 3: fs: split off the vfs_getxattr from getxattr
>>   Split of the vfs_getxattr part from getxattr. This will
>>   allow to invoke it from io_uring.
>>
>> Patch 4: io_uring: add fsetxattr and setxattr support
>>   This adds new functions to support the fsetxattr and setxattr
>>   functions.
>>
>> Patch 5: io_uring: add fgetxattr and getxattr support
>>   This adds new functions to support the fgetxattr and getxattr
>>   functions.
>>
>>
>> There are two additional patches:
>>   liburing: Add support for xattr api's.
>>             This also includes the tests for the new code.
>>   xfstests: Add support for io_uring xattr support.
>>
>>
>> Stefan Roesch (5):
>>   fs: make user_path_at_empty() take a struct filename
>>   fs: split off setxattr_setup function from setxattr
>>   fs: split off the vfs_getxattr from getxattr
>>   io_uring: add fsetxattr and setxattr support
>>   io_uring: add fgetxattr and getxattr support
>>
>>  fs/internal.h                 |  23 +++
>>  fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
>>  fs/namei.c                    |   5 +-
>>  fs/stat.c                     |   7 +-
>>  fs/xattr.c                    | 114 +++++++-----
>>  include/linux/namei.h         |   4 +-
>>  include/uapi/linux/io_uring.h |   8 +-
>>  7 files changed, 439 insertions(+), 47 deletions(-)
>>
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
>> -- 
>> 2.30.2
