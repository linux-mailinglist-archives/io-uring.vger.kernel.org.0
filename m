Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0125B52055A
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 21:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbiEIThE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 15:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240590AbiEIThB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 15:37:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DDF2B4C8C;
        Mon,  9 May 2022 12:33:05 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 249ILcHI030394;
        Mon, 9 May 2022 12:33:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Nm1M0uP3vnvdI2rbyuwj3Vj7WctQnuSUBxq7YwwkY6E=;
 b=rY552W37wce5OG3ciH7Wmwj8K0NNpF/yhHV8JCVVaEdZxc1291HfjYvzGWnqmRuGNgBa
 an7e6XLycJhO0g82Rswdr2Slyi951MUWJRJEd/DYhYq2hmeUna7YJ8UgG+KuNBRHi05/
 +M7zMHuYg+bvHw72TKQf1Ksjmhg/pUA2kec= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fxhwwxc8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:33:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gllD8UGw8kwGEz/17IgR+NbGyTvgK/jdgD8zgAZBTzW8Sk2XeQsrzuOBwmZOnM24YRID98plQfAJmz9CfFW9VTJ65A+75x6tWXS7zJJKHK/IJLJbIEfUISWbcwa2XxADPH7nH6+nfdL6EhtAdbVLxxZ1KW3fQwSTjMUNCHldqdIz3hvU15SHHV6y15WhQ/bKTsZI/75eqDI7QLVje/BDXmU6SYVkgS+mbAoeBjj0DL1oC8PVPYyY19l5dbvhg8vXAiZYcWNMH/46C1J1LmSmE9MfSWyIRTVUmfU8NnUdSnK222jn7NE2/7Hci6+S+6d3uAeykt+IYOsORWd/850ZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm1M0uP3vnvdI2rbyuwj3Vj7WctQnuSUBxq7YwwkY6E=;
 b=lQMWM4txTU1Okk3PyB90kmIVE4U80ow+WZlPtI/5aazJGaDdA48jycC1y3GOji/00a6VDcmmqKNX1sw/UJonJ1Ve3liRkls2FjGcO+u1Uu57hEtwa+Cnuc8vVZs+/sUFx46Uv6lCNfhGsqyYoPrxGCctCKCGBBxBbgLwnIggoSjoMrDVUpD4bzqM7dtmgM3CEHjTZTeB9Gv4KyBQ/u1xI1UR03Gz4IPGqnYPv8ujJooAWWl0FLyeStqiNYh6qHaaohcSlgM8W5p0DzoqDhl1jN7zxUPkqT7qEZDtWI1+ePsuyorbfuCtxW3OYnuADoz6MUl5EcB6EfjTRLfRmSSRVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by DM6PR15MB3829.namprd15.prod.outlook.com (2603:10b6:5:2bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 19:33:01 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%9]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 19:33:01 +0000
Message-ID: <31f09969-2277-6692-b204-f884dc65348f@fb.com>
Date:   Mon, 9 May 2022 12:32:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
 <20220506092915.GI1098723@dread.disaster.area>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220506092915.GI1098723@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:303:b8::27) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e719a17-ed89-4089-6f75-08da31f2bae9
X-MS-TrafficTypeDiagnostic: DM6PR15MB3829:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3829F94674C244E1CDE0FE29D8C69@DM6PR15MB3829.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VFD5Ax6Zag4n5IxOoqVtIpKw7hGUM4GdjZFDkse8SlKomMIYh9xqSBEHTPq2KWPDGTVndeU3DV35+lSNcC3YpJP0LlDYjJDtloOcp8uvMaRwhOCfCpaT9K9mX3zjJ/bwnUHVItKv9eLIc+orhLUK0Mvep3BepKxEOPRAseqOMb+ggJYrUJ7uirCgIbvMr9O/txREfO4Fr5VtSMVq/f58WrdDSq0/7HrEPzhadCBZ1D1ZdZBIML6rxyYJjBygCMpj+2lwQKUCvJBxRtGHeI4y83tLr1w+NCpRddeQ83GIfmiZZe6Z5gpWsP3DamUe3+jqbOLsweKIBNzAYtGdFz9BBL+ePC9s4Fh7zJNMjWJUURyxCbkdv+7W2ucSgRAmFHTJmBKWR9OhDfK05tYo0Gb5sdnOUoMYluWWUYEiSa2RD4/O/OQ5o7yZtoIkfUrpeUyRxpyp0KXpzwxUMmrt0lDqYJuYfN6H9XXK96o4RpKxLW+epqgZffuOe+g6Dvo/j7/RovV2/QzjL5n19i3ebicRm2G7CfVkGcYC+suWiTJN5oMmtyfzQB8JDeZsKnC4HNCZCuczb8nPBDga/eXo/MKlgwvL+jYBK5Ae4rBDpm5Xpxas967z3pi2GWhM61/j+Zw8EF86F9dPM6t1Q5KUvGHrd5AbwMhr3oULPb7kUYc/I+HLE8PzLF5Kqoo9eW+nAlkPsAmwmjIok9dE6qhLYPTSLjBxiXDtB4CgI4zL5sfQi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(38100700002)(66946007)(186003)(8936002)(66556008)(31696002)(66476007)(83380400001)(5660300002)(2616005)(6512007)(4326008)(8676002)(53546011)(31686004)(6916009)(86362001)(6506007)(508600001)(6486002)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEN6UzZwcGF5MVlXZHdKZVNIRk9YQ2xTY0pjaWFGaEE3U29ucTE0VnZaQkln?=
 =?utf-8?B?SjZYQ1VXdG1MNDFMK0JydVBjdkdOdmxuOHdUQ3lzMERwZFZWSkN5SmpZNFFx?=
 =?utf-8?B?Zjk4dktqZko2eUdnWFBmdENTNkN0anlBdERUcWVxT3o3ekFZOENZTkR1NkN4?=
 =?utf-8?B?TlU1S3FQMmM3WHBOdGhISncwQmRyYVkrelhlNUo0YmsrZW9ub21VUzRRMUJv?=
 =?utf-8?B?bTJZVmpDSUxtVWs1R0lWWTFTak9lU3Jmb0pBeGdXZi90VzRzR1Y1RlNMdzV2?=
 =?utf-8?B?K3poYUo2eTFWVGF5TTZieFlYQjhPQkRlMWR0V2xPOWJCTkN0bzBzeStYZmx5?=
 =?utf-8?B?a1cxOW43dWRjVElpUnBBamxYYUx3ek1RM3NkYlZMOEducXM3U0VMOWNIaEUy?=
 =?utf-8?B?bDBySTBRMUFYY0xpU2laaDBYRzluZTVoUWk1Q0Z2WVpPMVJZbnNYS1gwZ1lS?=
 =?utf-8?B?dEFhcmdqeE1RaDlVVUI0eCtKa1hIQ2tXT3J6eXZiS2ZQMURHM0pLZ1BFREhB?=
 =?utf-8?B?ZnkzdHRYZmxYbThEeFh4RURyeWs2YUU5Mit3djFoTDZmMjJVcGVFR1hmbFlE?=
 =?utf-8?B?KzYyRjM5RkljaVVWMnhQR3N2b1ZBRXZRV1NpcDBpSGZXNUZKdzIxZUYrSmgw?=
 =?utf-8?B?ZlYyamFqY25ubGxLN2QyRDUyT2NSSi9pZ3d0RHRxcjJaazhuYlRuMm9odFIy?=
 =?utf-8?B?MDVxTTVLY3QrUTN4c0RaYTljUE1Mblg5WDJwWVJqTldtNEN2cEtZdi9XeWJG?=
 =?utf-8?B?NkU0dmkyeStITXoxdXdEM2lVeXM1aWJRVTVzekpOWm10L1I0LzF4UVVtSVJN?=
 =?utf-8?B?RXUxaEllam5wZk8wVTUrNzErVXU2YmVWQzM5UVB4b0w1Y24wV0p6Q0pTSEtW?=
 =?utf-8?B?OS9lQUFpTlREa0lYVzFOVUpDaVEybEx5VmlUbGs0QVBHT1d0Q3crYVNUZVpE?=
 =?utf-8?B?bnhSbG1SV3VhQldqTjhuKzQvdTdyM09XQmY4NUpRZ2N5cmlsK2ZhVU52ejIv?=
 =?utf-8?B?WFZwbjFnb2FJL1RpbFN5c3JpelZrL2RnT2VnUmw3UkZXajl4NlhzemY1bTVu?=
 =?utf-8?B?ZHZCMktGZUVGVEk0czFDRFJTZkgycWlNWUVQeEsyWS8wTC9pUkQycnhCTStw?=
 =?utf-8?B?MWVRMGpLTzE0RUxqV2QxYjNDNk8wbVJ3NkNqazFoNzZ1Sm5NV3BVNCtCS3lx?=
 =?utf-8?B?aHkrTXZKTGcyL2VCQzg0ZTR1bzZlSGE1YzI1dUNkOGwvNHp0RjZTWWNIR2U5?=
 =?utf-8?B?eTU4WWlkWDlFZ0Rva1IzY1RRb0Z4N1NLeHI2dStUTnJvdGtGTGtFVWtoVEZl?=
 =?utf-8?B?NVNlWldUeXZNeStvcWVMRDhDdEtOczRMQm5ycGk3VWVab2VXMEVsbUhKN2FK?=
 =?utf-8?B?bkFJMmZyUEtPbTBRUHluMUhMdU9tVDJranVxWmRJeTE1N1IvTzYzVHBvQVRk?=
 =?utf-8?B?QXFwS1FxN3VxWmlXVnRHYW5zdnI4Q2RsbStoMkRZOWdZUkhUeFE4TGJ2RGFW?=
 =?utf-8?B?djVwWWpxT3ZkRmFkS3BGek00VnB0UW9QUWlUTzcvRFMyUllOdjhMWUszQ0pX?=
 =?utf-8?B?eDgxcG9VSmEwaHB2Vzh3QlovcTgzeXFPZGMrQlpEVEFYWWx6SkdpMlY3TUZ4?=
 =?utf-8?B?OVhaTndNVDdEV0tuM2Z5ZXovUUlHTjNKQkoyY25QaHkrUTh3eGVvZmJDY3NJ?=
 =?utf-8?B?QjVaY2h6L3g3UXhRTjIyOHpTRXE4TXVLZVZJR3RKVS9zWTJyOWV2WlhDVmdw?=
 =?utf-8?B?SkFFUTIxOWhRUDVSRVFsRCtweHNzczdnS1FtUjBZUW9BOXhlUGVnSTIwZ1ox?=
 =?utf-8?B?ejBTR1BhSDF1OUJRQURJV3BYK2JselROZWJqdXJwV21lcWY5c2F3RHdDcGVl?=
 =?utf-8?B?VzU2c1Z2QnNOWk5yaWdlV2swQ2w1UjVpdXNYOUhpWUZnT25PODc2RDF0S3lz?=
 =?utf-8?B?WVdQY0U5REJlZ2xuc2xSbWlBZG5wb3haRXZPQzNMVUl4OFhBdytnT1ZLNXNJ?=
 =?utf-8?B?eEFheWIzbmZwV1FoSEh3MDFQQWRtMzA1NVU0NjZhVElMSmNPektwdElXZ1h4?=
 =?utf-8?B?YzUwUVdOUXorRWxZNDNLVDA4ZTV2dmUxck44MWQ4YTRGQXRYVFYzSHdYV09s?=
 =?utf-8?B?THdITjNwQ3E1dW9ueEt5TUNHNThMQU5sbklwWHJyZjdieER2RitCSWU2UStU?=
 =?utf-8?B?OTh3cW5tZ3plMnpJa1dyelZHcWRkYU40NHZKN1Q2Z1RMZ2tPdnVzcEFNaXRF?=
 =?utf-8?B?ODFDZlNjV0pST2ljY3I3VXI2ajhieFkxRjhDTGNKRXNSdjlWV1RTa3VmTnBU?=
 =?utf-8?B?WVg3amJQbUFoTHAxeExxUVhNRVU1WUczY3h6TTI3bjBGRm1sYy9VUG1jYTVD?=
 =?utf-8?Q?djC7p62MtG5G0wD0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e719a17-ed89-4089-6f75-08da31f2bae9
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 19:33:01.5459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEP8yeOwuMhZIPVNK+hb6SG9gBPt2qepM+y0CaWCRDZ6QRubUPFYkrVWIkj0mS2Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3829
X-Proofpoint-GUID: Zyh-2hR63UQBr7CrUByCfGuhXRVR9y-E
X-Proofpoint-ORIG-GUID: Zyh-2hR63UQBr7CrUByCfGuhXRVR9y-E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/6/22 2:29 AM, Dave Chinner wrote:
> On Mon, May 02, 2022 at 02:21:17PM -0700, Stefan Roesch wrote:
>>
>>
>> On 4/28/22 2:54 PM, Dave Chinner wrote:
>>> On Thu, Apr 28, 2022 at 12:58:59PM -0700, Stefan Roesch wrote:
>>>>
>>>>
>>>> On 4/26/22 3:56 PM, Dave Chinner wrote:
>>>>> On Tue, Apr 26, 2022 at 10:43:28AM -0700, Stefan Roesch wrote:
>>>>>> This adds the async buffered write support to XFS. For async buffered
>>>>>> write requests, the request will return -EAGAIN if the ilock cannot be
>>>>>> obtained immediately.
>>>>>>
>>>>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>>>>> ---
>>>>>>  fs/xfs/xfs_file.c | 10 ++++++----
>>>>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>>>>>> index 6f9da1059e8b..49d54b939502 100644
>>>>>> --- a/fs/xfs/xfs_file.c
>>>>>> +++ b/fs/xfs/xfs_file.c
>>>>>> @@ -739,12 +739,14 @@ xfs_file_buffered_write(
>>>>>>  	bool			cleared_space = false;
>>>>>>  	int			iolock;
>>>>>>  
>>>>>> -	if (iocb->ki_flags & IOCB_NOWAIT)
>>>>>> -		return -EOPNOTSUPP;
>>>>>> -
>>>>>>  write_retry:
>>>>>>  	iolock = XFS_IOLOCK_EXCL;
>>>>>> -	xfs_ilock(ip, iolock);
>>>>>> +	if (iocb->ki_flags & IOCB_NOWAIT) {
>>>>>> +		if (!xfs_ilock_nowait(ip, iolock))
>>>>>> +			return -EAGAIN;
>>>>>> +	} else {
>>>>>> +		xfs_ilock(ip, iolock);
>>>>>> +	}
>>>>>
>>>>> xfs_ilock_iocb().
>>>>>
>>>>
>>>> The helper xfs_ilock_iocb cannot be used as it hardcoded to use iocb->ki_filp to
>>>> get a pointer to the xfs_inode.
>>>
>>> And the problem with that is?
>>>
>>> I mean, look at what xfs_file_buffered_write() does to get the
>>> xfs_inode 10 lines about that change:
>>>
>>> xfs_file_buffered_write(
>>>         struct kiocb            *iocb,
>>>         struct iov_iter         *from)
>>> {
>>>         struct file             *file = iocb->ki_filp;
>>>         struct address_space    *mapping = file->f_mapping;
>>>         struct inode            *inode = mapping->host;
>>>         struct xfs_inode        *ip = XFS_I(inode);
>>>
>>> In what cases does file_inode(iocb->ki_filp) point to a different
>>> inode than iocb->ki_filp->f_mapping->host? The dio write path assumes
>>> that file_inode(iocb->ki_filp) is correct, as do both the buffered
>>> and dio read paths.
>>>
>>> What makes the buffered write path special in that
>>> file_inode(iocb->ki_filp) is not correctly set whilst
>>> iocb->ki_filp->f_mapping->host is?
>>>
>>
>> In the function xfs_file_buffered_write() the code calls the function 
>> xfs_ilock(). The xfs_inode pointer that is passed in is iocb->ki_filp->f_mapping->host.
>> The one used in xfs_ilock_iocb is ki_filp->f_inode.
>>
>> After getting the lock, the code in xfs_file_buffered_write calls the
>> function xfs_buffered_write_iomap_begin(). In this function the code
>> calls xfs_ilock() for ki_filp->f_inode in exclusive mode.
>>
>> If I replace the first xfs_ilock() call with xfs_ilock_iocb(), then it looks
>> like I get a deadlock.
>>
>> Am I missing something?
> 
> Yes. They take different locks. xfs_file_buffered_write() takes the
> IOLOCK, xfs_buffered_write_iomap_begin() takes the ILOCK....
> 

Thanks for the clarification.

>> I can:
>> - replace the pointer to iocb with pointer to xfs_inode in the function xfs_ilock_iocb()
>>   and also pass in the flags value as a parameter.
>> or
>> - create function xfs_ilock_inode(), which xfs_ilock_iocb() calls. The existing
>>   calls will not need to change, only the xfs_ilock in xfs_file_buffered_write()
>>   will use xfs_ilock_inode().
> 
> You're making this way more complex than it needs to be. As I said:
> 
>>> Regardless, if this is a problem, then just pass the XFS inode to
>>> xfs_ilock_iocb() and this is a moot point.
> 

The function xfs_ilock_iocb() is expecting a pointer to the data structure kiocb, not
a pointer to xfs_inode. I don't see how that's possible without changing the signature
of xfs_ilock_iocb().

Do you want to invoke xfs_ilock_nowait() directly()?


> Cheers,
> 
> Dave.
