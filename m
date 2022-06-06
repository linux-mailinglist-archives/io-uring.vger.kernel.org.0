Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5278153EFBD
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiFFUfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 16:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbiFFUfE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 16:35:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422CAAEE3E;
        Mon,  6 Jun 2022 13:34:34 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256Gg39w030358;
        Mon, 6 Jun 2022 13:34:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wqia4cFWU7MiWeSV68qb33DY6RBTvzrDbiijaIM2pSU=;
 b=n9XVyeHtbR+ZG7Pe/0Y0tz8Xg1mWug+1R9PYHPVcgHGUbOxpIlKz72AsObdME2jdGM16
 CPFJDog/ctic9kvRtdo/rz3feNb4eoZd7AVjKf4opNeTBSVcXm9suj4BviqXushYaG9t
 BQhJEGwY+IhxOb0WZQqG574K3dTZ8kWY/bI= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gg2qkk4xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 13:34:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5knZ9ZupzmXfSVTenrSgmXIn208vBnuiLLrR/gDi5r+TQNmpDQFF9RaRPjmovZ1lYrAh9A8gtwufX8PMo0mQTqiSri7yISSJflgehgZ34drj0w6m+0NOqd4Q+Cjpn/4hVRlDhuSMBnLrnGIhi9l4WFsSrFGqu+c2diwa6KHPM/dPcgoY9NxJHv/58uwcKMp96eNymh/wqeidgn32OFI9djbdvsltxBSLoHh7q/DTLKAf4MPf06o9sOVbfhTspLfQUu7H2nCaPQsJj0S5TKrM8EYq3fEfaqb5GTxbG7R+gy8yqbwGmTIAd6D/3L6rziczXi4Isofx4HVhHcYaKHusA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqia4cFWU7MiWeSV68qb33DY6RBTvzrDbiijaIM2pSU=;
 b=kEFUnxT5edla1Wen7rdZFNQp3xLE0+NYhITzyJHP9e2sHa5PV4pxuzW8KIBsxMV2TlBa6YUwDEo61MN4zqMScnbswtyPDi4Kr6beE85cNIjn9Rke5nyi+1Y6gJGhx0zU1DFxenNykHHpTS/kHzni7JRFu+uHehxc65/xoZ5qcmf2UmjPO9HeH9LPULrTzh6MXO/PHxCClubcsMugMUMur2imcyuHMVdi5omKyZP+WqvUArd0iHvXzEouMmeJAtqjqsThfv2lWz4zpLo7xeLzYvYID2dhyrExdcQLB3o8yGKnBU9oz2Uoc5SDUqvk47z8kEgan2lSe2YUQjMSUuMaDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by SA1PR15MB4372.namprd15.prod.outlook.com (2603:10b6:806:193::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 20:34:21 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 20:34:21 +0000
Message-ID: <6a21584a-34d6-9691-138c-90df23fa727b@fb.com>
Date:   Mon, 6 Jun 2022 13:34:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v7 06/15] iomap: Return error code from iomap_write_iter()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-7-shr@fb.com> <YpivQhqhZxwvdDUm@casper.infradead.org>
 <0f83316c-3aa2-3cb6-ede1-c2dd2dd3ab31@fb.com>
 <Yp5S9pRPKHbAgcsU@casper.infradead.org>
 <4c15cc6f-97a6-ab53-6b1c-871058608419@fb.com>
 <Yp5Uw65VFcTaSyfi@casper.infradead.org>
 <8a7c76d2-3cb4-0162-584a-69b130831c3e@fb.com>
 <Yp5j3Yr7gnT/zbEv@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yp5j3Yr7gnT/zbEv@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:a03:331::35) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df02ba05-fa00-4e36-0c7d-08da47fbefc6
X-MS-TrafficTypeDiagnostic: SA1PR15MB4372:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4372D6A8D95F139FEE521022D8A29@SA1PR15MB4372.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CCMS4H7r4HovFRY6lwlosHH9Y3VM67pjjw3uqMbRvk7K2sDK70Mqxukez26s1HQrzlsJ0uWybVUpJMIsdRKaqlKg1EX2yMoIOq8X9C5mvbtB7CI6uQ7imnliC6w/kU3E3gbEKJdehaUTVEiSnYld/UhkbsMoGEbZXgy3g36Rqf6KCypK6PJ3o79o6tcixml3ipV13hV9suy4rg///uFNOtfx7Nm+jDN+aK5o++KK+xdlZW2VXZSqY8NCa0xZxg9ot4IhZ5HH5VFwbRFge2Je/95Ami165G9cOr4xs/KyftlenFmY1f9Pju2NAmO4Ngu0bCx4c0F1hb8GMHe3Y/1JUe1OXE1B0ZUAOdbp/uV+gcpGvWE86yFh0JfwByI1Wz5U9KgevnSORoY/lGH7VwZwoTQU9n9c2ijANOO+Z8GJVNucZJeKUI3jjgqBHd/Efn/Ug8G4Nn7H4ZQXY9YP+C4efZoslRxYbK9zgBQkZZ6o5JFIC7p9ctLVlCyac14Na7+oMb3KHpy2YFCZdP9bi7vxV1x/Gs1RiUgRrGX8TTcGapacxw2QMlySkVnTaOOj4t69RuAT0DPImimS8D1H/6gvNn+Xx9AWOlqRtlPvgv/efpLaWG2Q2bx43YWRVs1QoytkHlSuQtJRvQ6PFdAztSASKz7QS+TXwIWcxxjyBtl3YEBuZnzisEvdwRJs/McXs6N9WbwUGe9elM4KHCR0UoYFDndBg7sDUVMQLoCUVzffQsDcojvto1eYD+ouACr1JYB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(6486002)(31686004)(66556008)(8936002)(186003)(508600001)(5660300002)(66476007)(4326008)(2616005)(8676002)(66946007)(6506007)(38100700002)(6916009)(6666004)(2906002)(316002)(6512007)(36756003)(86362001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cldLK0NEMWJQNnFyU2dhS3YrSkFyd2g5c3V3enFUT2RQSi9Rb3gyaW9kaUtT?=
 =?utf-8?B?azhaY2MvWExMYW9QQzQ1ZDJDSzRTSnNyRTZMWGo4RU5sbDlQazc3OFVmWG4y?=
 =?utf-8?B?dkdoQVlRREhaVUtJS1BZNnhPUFEwWThWRTZwckFNZ1huUEJiVjRMNk1rbHVU?=
 =?utf-8?B?TjNtVm9aR2xTQVZNL3p1WlViWjhMRDNBZjVyeENuVG9YalRwbTZzQ3lOWm0x?=
 =?utf-8?B?LzJoZ3FQSUVwVDdTU2xxUC9DNmtVekM5WW5CcllLUVgrVkV1ZjJtYVA4YkUv?=
 =?utf-8?B?YUxmeEU2Zk1oNTRXQXJVNTJLWGhaVlVGbE94QXhXTk1WaFh4NkhTTUpOMlA3?=
 =?utf-8?B?MjRNY1d0b3hzUWF0NFMwMmo0VFNGK0hIWTlBemZwN0ovWC9NalJuYnRNaE9M?=
 =?utf-8?B?TDY0aERnSG5YajFrc2NYT3pKZmQvbFdWU0owQ3Jud2RlYyt4NXZ2MVE5b2VK?=
 =?utf-8?B?T1dUNFZjWlJuemY4b0Z2alg4Mk9xeGZscEtweHI4YWFvZDZmeTI0OWt6dHNv?=
 =?utf-8?B?a1RPNGw5MlJNM1VLWUdVUGxXZ3hnaFhhM0ppWGIrcHF3VGhMT09JOXMvdlZD?=
 =?utf-8?B?NE1qTis3UzBaZ1licVVDZW5JK3krLzl4RDJPTjNNL3ErWkR3cUZxeWJNQVAr?=
 =?utf-8?B?bEdCRlo5SFZacWtxUkp4YWhGUEVBSWNabVdiUGoyNkErS0Npa2RScGdwdWRX?=
 =?utf-8?B?TFNRYWd2dHJDYXEvZW5NclcraDAzc0Vnd2JoYmRtZjdIQXppcjBsaDZiOEFZ?=
 =?utf-8?B?TkZpT0xha1ByY0dvUlZlb3RqOFZwdlUwa3ExQXJBcGJoVTMxYnFsajdsa0Rm?=
 =?utf-8?B?SEpVQmRXOUtGdXdaYnFQQ0E4Qnc0TGVVd3JCZ0loKzdiQWM2NmMxMVR4YWJC?=
 =?utf-8?B?MUcyUG1vT2UwdWZpaXgvNmhqdXlBSWV2Y2RtMmlMOW12bjZIL2NpdVRhakJD?=
 =?utf-8?B?L253MUxkdHlZRXVSamxzUFhwWEw0eTJQcFFNSURMK0xXR1Y4endqQnZIZCtX?=
 =?utf-8?B?RWVYZklpclc5M2lLUHRmQzMxMFhlSm90ejJqQnkwdkdGMG5pSVVoY25kaUZL?=
 =?utf-8?B?ZWhxT1FzU0JDZjNTK2JScUlrcExUdzhXLzdST2x2YmZiUit2Q0YzUWRQS1hq?=
 =?utf-8?B?bkhydTRjek9EdCtnYnJ3OWxaRzU3SWpaL0ROenErV0srMDIvYzd0QzhSeHZx?=
 =?utf-8?B?WU51TVFkVjRCK0xvcC9rZ2pVTUZ4d25iQ2V5aUdwRzVialFnWklVY2QralBW?=
 =?utf-8?B?Q3ZMQ3lmOFBHNEVVUDNRd0RWNzlZRHFNYTN1bWRrejB5cFBqV3VoNTJLZ0pu?=
 =?utf-8?B?V3N0VVB3OTYvbG85YzB4Z2FmdWRNYTJJWnJ3bTA5d09aRXhJakNpN0JMaHJS?=
 =?utf-8?B?VzRrazRBd0V6NXRWRnNWV3VqZUFtbzRvWUk2ZXMvamY5MjErZGFNTXR1ZUo3?=
 =?utf-8?B?R3Rsb3U2dmNMbkpPYjRCbXJEUHB4R0pZbUdveTNCRjdQQjQ2REt2YTc2MzJ2?=
 =?utf-8?B?bW8yUEwyVnFPbjNHZkdhOW9hTnlZU3E2NGhnQzM0Z3hIL3hyUWxBT0JiOHZt?=
 =?utf-8?B?dzBCUVlSNzhHRzQ4M254YkJ5cVdYeW5CNkdrY1pVc2V4VTRqZjh5TXBueWda?=
 =?utf-8?B?SEVQOGtJWTI2a3V6Y3NndDlqdE9PUi8yUDdZaXdXRHZSMUFNTVhiMTZRaVI2?=
 =?utf-8?B?TERHQlh0dzBJU2pYaWhxSk1ZcVpwRStPaVZYWG5tZ05MWjlnUktFZ0IyTXZ6?=
 =?utf-8?B?b2t2Y2tnZEZ1L0tWRmk0UU1ydTcxRW0xYUkxVGxlVkRCazVZMUEyZVMzYnQz?=
 =?utf-8?B?SmhydCtGNWM0ZHc4cTJIUEg4M3JKZlIvT2RrSWRxcis5bzVUNmwyTTBQdWxZ?=
 =?utf-8?B?WUlTSitpYkh3bnQvMjNGd096WnNzUnpaUkdRYXFNalRJcStCWVFZQmplSDNq?=
 =?utf-8?B?eTNXWG9MVTJxUnhuakpEQ2ZGc2lwZDlLMUZGTkUrSmYyRE91SVdDd1hKU1Bq?=
 =?utf-8?B?VnVOSDI1MEl5ZEpVRWFDa2RKSk81QlRaQlkrekxrMHkxaDVJeWFjZU00NDY5?=
 =?utf-8?B?QlpyNDlHZFlsUG5lQmJha0VjMDcvQmU2VkVqN3o0SW1lcmcxc2p2VnVlR3Vr?=
 =?utf-8?B?bk9HOXAvb3Z0RGxJank4cTZmWk4veHZBczFyOVlzVkwxRDV1Q1Q3N2hoVXYw?=
 =?utf-8?B?RGlvKzFVNmQ1NnM0Ly9qMFd6VzVyMEtQdlZXQUQ1SHNONmZBdGdQU1lhQ1No?=
 =?utf-8?B?RG1Pa2RNdExjRFBOanJ6bXp4RFJxR2ovY0R4OEx6ZVNJU2Y1SHlnUWJEbC9I?=
 =?utf-8?B?dTNuVUdFaFNtSVdlemJSV0J2VlltdjZwYVgwYlYydkhCVkh1bE4rbS83V3Z6?=
 =?utf-8?Q?YDHJixI5cdrXTsWY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df02ba05-fa00-4e36-0c7d-08da47fbefc6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 20:34:21.3162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xh6ozY7X8ElOonsq7s1pdWnr5WcFZQhwbPw7xqbimqv+pXem4R0joImN6zOY6A5+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4372
X-Proofpoint-ORIG-GUID: HQfOtflN2dmbZSUd0N1ybtrHUfMoN-1B
X-Proofpoint-GUID: HQfOtflN2dmbZSUd0N1ybtrHUfMoN-1B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/6/22 1:30 PM, Matthew Wilcox wrote:
> On Mon, Jun 06, 2022 at 12:28:04PM -0700, Stefan Roesch wrote:
>> On 6/6/22 12:25 PM, Matthew Wilcox wrote:
>>> On Mon, Jun 06, 2022 at 12:21:28PM -0700, Stefan Roesch wrote:
>>>> On 6/6/22 12:18 PM, Matthew Wilcox wrote:
>>>>> On Mon, Jun 06, 2022 at 09:39:03AM -0700, Stefan Roesch wrote:
>>>>>> On 6/2/22 5:38 AM, Matthew Wilcox wrote:
>>>>>>> On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
>>>>>>>> Change the signature of iomap_write_iter() to return an error code. In
>>>>>>>> case we cannot allocate a page in iomap_write_begin(), we will not retry
>>>>>>>> the memory alloction in iomap_write_begin().
>>>>>>>
>>>>>>> loff_t can already represent an error code.  And it's already used like
>>>>>>> that.
>>>>>>>
>>>>>>>> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>>>>>>>  		length -= status;
>>>>>>>>  	} while (iov_iter_count(i) && length);
>>>>>>>>  
>>>>>>>> -	return written ? written : status;
>>>>>>>> +	*processed = written ? written : error;
>>>>>>>> +	return error;
>>>>>>>
>>>>>>> I think the change you really want is:
>>>>>>>
>>>>>>> 	if (status == -EAGAIN)
>>>>>>> 		return -EAGAIN;
>>>>>>> 	if (written)
>>>>>>> 		return written;
>>>>>>> 	return status;
>>>>>>>
>>>>>>
>>>>>> I think the change needs to be:
>>>>>>
>>>>>> -    return written ? written : status;
>>>>>> +    if (status == -EAGAIN) {
>>>>>> +        iov_iter_revert(i, written);
>>>>>> +        return -EAGAIN;
>>>>>> +    }
>>>>>> +    if (written)
>>>>>> +        return written;
>>>>>> +    return status;
>>>>>
>>>>> Ah yes, I think you're right.
>>>>>
>>>>> Does it work to leave everything the way it is, call back into the
>>>>> iomap_write_iter() after having done a short write, get the -EAGAIN at
>>>>> that point and pass the already-advanced iterator to the worker thread?
>>>>> I haven't looked into the details of how that works, so maybe you just
>>>>> can't do that.
>>>>
>>>> With the above change, short writes are handled correctly.
>>>
>>> Are they though?  What about a write that crosses an extent boundary?
>>> iomap_write_iter() gets called once per extent and I have a feeling that
>>> you really need to revert the entire write, rather than just the part
>>> of the write that was to that extent.
>>>
>>> Anyway, my question was whether we need to revert or whether the worker
>>> thread can continue from where we left off.
>>
>> Without iov_iter_revert() fsx fails with errors in short writes and also my test
>> program which issues short writes fails.
> 
> Does your test program include starting in one extent, completing the
> portion of the write which is in that extent successfully, and having
> the portion of the write which is in the second extent be short?

I do a 3k write, where the first 2k write is serviced from one extent and
the last 1k is served from another extent.

Does that answer the question?

