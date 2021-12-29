Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DAF4816AF
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 21:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhL2UeZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 15:34:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229767AbhL2UeZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 15:34:25 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BTHDl5o011763;
        Wed, 29 Dec 2021 12:34:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fmUE2erI+uvWorIiGebChTfT+r36H7d8j9U6WRIBwkg=;
 b=Csbtd0EutcAKyQ+7VbfyD8C9GzhbRdfY87SW3dA7aRViGy99chXp/mHdhtHUXX4ElMsD
 MkeiDyWp+m87OgxNtxCiOZ1IAvjXXO9du7MwI/uQqzWlBVku2+J6DG/aF6RosQTaZiFR
 eVMHrKdaB6ryEwXyzS+JJ7KbyxbaBtsqNgU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d80p4h1kf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Dec 2021 12:34:22 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 12:34:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrhFsRAmTYn/dwqMkhMV9Cl4ZCnt3p+jZI9NMRe2XagZ3IVq0oKuczhWRoFb6KdwiEQIQ7gK2EooKE+6RJBFH4yZ+s16MMaHPyrWANZok8+IMHx3wz7v3NK8wytj2sAkxmHAn82JJ3jGN+xX0oFSeQrsl9QlwImmDRNOjqJ+eFyjntmyNgtL/FpR31cg7+kNcJNwJtWhIK/YcDb06JkuMceCXsUsM45Oq0SqWsDHrKNDCQ6akA7W0FGEhNtef9zptRDMMCHHwEYoIPvVBgBLPJWiqrmqnTl9rwWEk+ZDr95w8ds4EzNU7fVKFT7xzZxRoMRC42HA9aCPH8pvr0JV/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmUE2erI+uvWorIiGebChTfT+r36H7d8j9U6WRIBwkg=;
 b=e7vLCrFb3XkamCAf6sdASFOiVnhOOuG/xZnEO6IzYcS1EI/EbQpfpJ7RYEV+3UCyNqxkO23mhg/ns7rv2s9SsGvQ3BxhBWmGUANSMICK5iDMZzF86CSNc6Wz8ln9gtMTuurYmFJN/7YnhW/7osxBvhQSc0/0pkvRSilwvLjMue2TMEPHPVgTnLZXlYoD6Q1d+zTPmRXWJxZ56OBAVsGAzkR0HHXxgRRWR68jSpWdbzPIdl1UTYRaLl0h78B6P2ML8UBa0pdXz2TJIPHhPx4YidiDzf0kxa03JE8S82og4rP0drXcML5G8v7n0VCcBIyH3y06TRcfcX0gMZXMJpQM7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by PH0PR15MB4894.namprd15.prod.outlook.com (2603:10b6:510:c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 20:34:20 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab%7]) with mapi id 15.20.4823.023; Wed, 29 Dec 2021
 20:34:19 +0000
Message-ID: <5d0914fd-a16e-a4bb-05b8-8c10913fdd64@fb.com>
Date:   Wed, 29 Dec 2021 12:34:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v9 1/5] fs: split off do_user_path_at_empty from
 user_path_at_empty()
Content-Language: en-US
To:     Christian Brauner <christian.brauner@ubuntu.com>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>
References: <20211228184145.1131605-1-shr@fb.com>
 <20211228184145.1131605-2-shr@fb.com>
 <20211229143126.advkumqim7tztlmq@wittgenstein>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20211229143126.advkumqim7tztlmq@wittgenstein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0002.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::7) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf150bbe-da3a-4118-db56-08d9cb0a9731
X-MS-TrafficTypeDiagnostic: PH0PR15MB4894:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4894DBED58D51F53A44AE2EBD8449@PH0PR15MB4894.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fS8JRdcFosw41bYPwaUU2i0BgfWId6iKIJZ5ESDGDLTisNex8IGQ86LmZT7dU6jrJJLx8HJwY3fgVMtKrOZvyesnYc7quEd//J4SE+h41dG0vixGxXbE14FIygFYPCdSbnGi/ghqeJJm40/W1FhmCpOUABHE9SRPc2m0egZS730Br7gViKf0Csaq7QgawvNkej8usdrRfLGF926wXsHWDG3fumMfuT/6RSyRr8O46b0DT6NFYaIeD7HNJrHmpz1styjWD1wD36npO1l979TT0UiE5ur6ZQsCnFm65FzqN3wKX/KOe++2zVdZN5+4zxISUTOw8uaX+EQF64ysdY7xBJlG/MO9TeGVkwN7HbBmdTAPvRnJQ4mCa3JZR3Mg8EVtfVYeut8N5h4YnZB4U3pq00DOZc1ccrUOn3FtiE9RrDUTTMdTtpDUOUNXfO4jU5n9CQPntfnWcNlHNiKavSEV6Ub80yD4NFoHeb0+JtfP1qBXkDRmlGtOxqRn3Vk2KfZAW1lBxPm5xwzwO2iB75dWa634mHIUMcoWkrXcH9h5v4Qqjou9plsnDWWQuX4Gm6nC3CFav8S2nRJX2zXy/fSK+k14hbUwehOo+RgiKeMJq/6o+vWwIrcpEm0UIiZMVlPIstr++cV0iie8hXMPgAw/8g03oDbF9cCG0d4l9jNAeWGgIcDHDHOJFnALmzyD5OgkF6AA/efPR0htiPlxp/z53movV+TbvIxyW/W3LnpTflY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6666004)(6486002)(316002)(8676002)(38100700002)(5660300002)(31696002)(186003)(6916009)(6512007)(86362001)(8936002)(66946007)(6506007)(508600001)(4326008)(31686004)(36756003)(2906002)(83380400001)(2616005)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHVMVmxJdVhMV2NPZFN2THR4OW4yVGpHTDJNRWZkc3RNdXlIU2xTbTZvc1kz?=
 =?utf-8?B?dVUzUUVLdnlQV2xwWkt6dE1qSXF1aWRFaERwUFN0bjBWUkp5R0E5V0x4QTUw?=
 =?utf-8?B?aXZsN1N1OFlPNENvL3R6WU5jS055MmJDZEZIaTUxeEtNRlU4UXhIQjZoMW4z?=
 =?utf-8?B?VFAvcEJsak4wQlpFM0xvVmNDZ1p2WlgwMEVMdmM1dm1Db04vZTEwUDdVODUx?=
 =?utf-8?B?bUQ4SVN1R1ZNcVlxN0doNm0xcmZMWmxNQ29VMEtudHJkUVY0eUFseFpBeGEr?=
 =?utf-8?B?S1RTM2JDRnBNYUorMjdpaFd2UGNkK1Rab1JRVUErWUg5Wi9DUDdDdXl5dlFz?=
 =?utf-8?B?alFjYU0zWHpWZXBVR0tUN2EzMlJYWUhqRUUyTU9KTGtiT2lHbzgvZnk4TFd4?=
 =?utf-8?B?MWFqSGpEVXVCMDdxbzBmNlVaOXhPZjZzY0t4NEdTOTcvTkQxR2dmcE8xNUtu?=
 =?utf-8?B?QjZpUjNubUdGVGI3WStWdTZXVEZxaFZYcVU1cGdlSTdVV0dlZy90OUN1Y1NU?=
 =?utf-8?B?SmY3ZVBUL0dwWjMwRmQwWlJPV2IrMi9pTnplYVM0TE1LdTlVV0hIN285MXhH?=
 =?utf-8?B?KysxUnVHZkZBQjB5aVJxenk5bGpuU01YTFVPNGk3M0h6SzdkQlFjS24rQWJX?=
 =?utf-8?B?V2V1QTRwR0NkbzV2UmE1T010cTIyN2l6bTFXTzVFUGJGS3ltQS9iS3N3bEJ1?=
 =?utf-8?B?Wm5reUI0RmZRWkl5QmphVHRUb3hFM1c3QkdkY3pEVGlsa1d1QmFHMXE2NU94?=
 =?utf-8?B?YU5VWWtMTkc5by96OEk4UGIrUzc2Q3hZOStza0dYeG8vNmZCZ1FLRGRONnBj?=
 =?utf-8?B?OXBsMFRRMmJLSlJ5a2k4aXNFMzdQU3NidFNoMk1pOG9RWVRTcmh3VHBHTUg2?=
 =?utf-8?B?Y1llZEt6Z0JUdXVKZjU1NGcwZWIrSnhTUXJrWVVqL1dYdHRJWHJhRFlxUWQ2?=
 =?utf-8?B?WDdubXM1aVBxeGNwaEVrNUJGd3hWdEg2L0dHZDFNb2JYdUxCeVZWNUFnMmd3?=
 =?utf-8?B?aDFUV0lDRy91SGtmSXFXZ1F2MlgwUTBQY3hxWWxJUzNranptZG5sR2ZsQ2Iv?=
 =?utf-8?B?eEt4blFzVFJ5UWluVWNtclo3TGN3eC9tRU5HMjdLdkRXN3RaeUlHSzJ3NHo1?=
 =?utf-8?B?L1NMV3piNzFWc08rcERweVh1NmNkMGFjakF6TlhoL2V1N21aeUcwQ000YVVH?=
 =?utf-8?B?T01hMWI0bWtjZXQzKzNZanZqM3dYUjdQUHFOS1pBTW1QRWk2b2EwdGw2M2Ri?=
 =?utf-8?B?YlAvOU8yMTVyTkRweEUxNmh3OFE0Ymk5NkpsS2Nnd0xUWUxxWC8zS2NmWnZh?=
 =?utf-8?B?Z0kvOUN4ek1oZXRLQ25UWkJ4VldwOUFoN2ZUWnVDeG9lVGlBdmxVZ3M2bHI2?=
 =?utf-8?B?VGZiWVp4OTZ4aFZDUUFQbjh0bTdwWXNITlQzdTlaMXAzT0JudkMyMW9QSXlr?=
 =?utf-8?B?VWdZaXBEMktxMHNGbGFhTjB5Y0ZhTWlseGI3b0ROd3k0bFQ0cFNtUjh4dTg0?=
 =?utf-8?B?UHNGWmJBTFNXTElUMEc2UTJmNUZJbmh6QnB5SXFmZDlKd3BtQmNtYk1yZmsx?=
 =?utf-8?B?Z2ZqREx6OG9RQ1N3amdlY3JITDJlM1VLd2ZLb0U5UVNpYVNhU3BRanFYb2VG?=
 =?utf-8?B?Qmx0Rjc4bTJzMGxZU1AxbGJXT3pSaUVIU0hwYzJWdVdGVDF4V3drYmdDRUcz?=
 =?utf-8?B?SE9DYWxScXQ2T3dQMHN2MzBpR2FsNXY5V2o1bmRKMUFZU0lRbWhHNjRMWWE5?=
 =?utf-8?B?UVFFVHV2OFBsMjlXbnJOT0tTbXRRQUo5S0lvRlF6anZRMkQ2dkloM3dZV2Q5?=
 =?utf-8?B?alZoWC9tTU5xVmxrdWlQd0h4MjFHYW9MUjQ0MHpVUDZlOFdaaUE0QWwwQVZQ?=
 =?utf-8?B?L0dRNTl0K2lhcExtdEg5YUtzMlZnVFpXbHZJWUJEMnpwcGpXVUZLVXRyUSsz?=
 =?utf-8?B?U1g2NkhCZnA5UEJoZFN6ajdiNm56Z2V0SmlTY3dQUkorRWd5QzFvcjFzbnpa?=
 =?utf-8?B?K2N0YmxJZnV3eldFZmZ5UkRTVWhkRGorMWVnbTFtbytobGYwWXdURXRjZU5v?=
 =?utf-8?B?OFdxWFplaXpockdnWjJDQ25SNkVRWEJsREt4MERGcjU5Y25wK1NNVHhPUFBk?=
 =?utf-8?Q?OyDWqB8xezShgpa5z3dUBSnMT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf150bbe-da3a-4118-db56-08d9cb0a9731
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 20:34:19.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFkthoscBQsH2zTGQmMmhjr9/iep1evSvQNRlOC/3lLbxc/jPIHvGM/6OTyWPDe6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4894
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Q0mPa7Qo8Gt3NGch0zrVCF1dmuU0SDan
X-Proofpoint-ORIG-GUID: Q0mPa7Qo8Gt3NGch0zrVCF1dmuU0SDan
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=947 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/29/21 6:31 AM, Christian Brauner wrote:
> On Tue, Dec 28, 2021 at 10:41:41AM -0800, Stefan Roesch wrote:
>> This splits off a do_user_path_at_empty function from the
>> user_path_at_empty_function. This is required so it can be
>> called from io_uring.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
>> ---
>>  fs/namei.c            | 10 ++++++++--
>>  include/linux/namei.h |  2 ++
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 1f9d2187c765..d988e241b32c 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -2794,12 +2794,18 @@ int path_pts(struct path *path)
>>  }
>>  #endif
>>  
>> +int do_user_path_at_empty(int dfd, struct filename *filename, unsigned int flags,
>> +		       struct path *path)
>> +{
>> +	return filename_lookup(dfd, filename, flags, path, NULL);
>> +}
>> +
>>  int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
>> -		 struct path *path, int *empty)
>> +		struct path *path, int *empty)
>>  {
>>  	struct filename *filename = getname_flags(name, flags, empty);
>> -	int ret = filename_lookup(dfd, filename, flags, path, NULL);
>>  
>> +	int ret = do_user_path_at_empty(dfd, filename, flags, path);
>>  	putname(filename);
>>  	return ret;
>>  }
>> diff --git a/include/linux/namei.h b/include/linux/namei.h
>> index e89329bb3134..8f3ef38c057b 100644
>> --- a/include/linux/namei.h
>> +++ b/include/linux/namei.h
>> @@ -49,6 +49,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
>>  
>>  extern int path_pts(struct path *path);
>>  
>> +extern int do_user_path_at_empty(int dfd, struct filename *filename,
>> +				unsigned int flags, struct path *path);
> 
> Sorry, just seeing this now but this wants to live in internal.h not in
> namei.h similar to all the other io_uring specific exports we added over
> the last releases. There's no need to make this a kernel-wide thing if
> we can avoid it, imho. With that changed:
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

I moved the declaration to fs/internal.h.

> 
