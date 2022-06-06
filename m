Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5953EE7A
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiFFTWA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 15:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiFFTVv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 15:21:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6206FA3A;
        Mon,  6 Jun 2022 12:21:43 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256GfvRI030170;
        Mon, 6 Jun 2022 12:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oKvOMznT9j8Jptl5AhjM5A3K3VNQhB7ygw6vCKllisg=;
 b=pMRaRugjgikIovokwYl1FOsVnpaYNF/lBFS27asY+Ad1qdn6rpYkdEhBxTrHjmY3BSf/
 v8vCjlJNzIYxG2CS5krM9tTsodpNrhSmaHqehGoFl2Li9NhJjcjehfeKBtTrL/muesP1
 MVLM1BNIeyXM33Yjs431zQiqHk3A8myUK58= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gg57u2cr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 12:21:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFKrrVCsbfjjfpaqcIZqR0XfvyUnQeBrI0w7N6FiRBvOAYjOrpVnCyLh5E8veD9AUYaW4i7EPeIZ89LpYFtPUhKlOMS3//4YJ/YT/U9Yj4YHEY4Hpq68THfD6oFmEumjYG89wVGF1FfjKn/XykMV8mONz3+g7k1hcb+bTpNnLhJotfCXj0VuxxfvZUim6RTkZYyoh1/HC2OoEP5uYqr78p/TYFQHxxVovmTeRWuk4COLOUWQ5AuSepH6kJvSUmrf9TCmdFTjnBA4TgV2TsU5LtxzaKDLLtgFE22nl7H2zPDyHp7V2RH9Z0fl98nsNAET9n/lRUoUq13rn8Kv4qD/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKvOMznT9j8Jptl5AhjM5A3K3VNQhB7ygw6vCKllisg=;
 b=C17VJZxPlFD2kijrcDkqlKwMgI2aLTpT3/lrLzkoSW2BjqAOkU2Eviq1H7o6C5ITnHQbLRm5/Kx7XJI97PeYWZyEL9EBJzfO4PDHJLAkDDd8DHSmEE1KhvvPnIwbstft2nUn9d9TRX1byDMyRRTl1nI9/Spuv+unK7cgtSRZCyIHLQwoCc49+ne2OccvvP0LKz6OV+g3W5J6pQM5huotD1qB9ZnMwbdCoPPWnM4lGeYOBGFMJrUTY7NiEn5ZrBgZPiCW64nWoy2jvNomv4LBiCxuVs/1vxtuggav9z8xSK0rgwPODtxmlnJ44rzfe8BXzAO+x4tCKLKie0NkSpHjTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN8PR15MB2915.namprd15.prod.outlook.com (2603:10b6:408:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 19:21:31 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 19:21:31 +0000
Message-ID: <4c15cc6f-97a6-ab53-6b1c-871058608419@fb.com>
Date:   Mon, 6 Jun 2022 12:21:28 -0700
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
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yp5S9pRPKHbAgcsU@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::31) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd73ce9c-c6df-4db9-6c49-08da47f1c31a
X-MS-TrafficTypeDiagnostic: BN8PR15MB2915:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB29151A41257AADC84E9E7EE8D8A29@BN8PR15MB2915.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7uLoCiYSJLxocjPuUIIz9iwu32T2+VUPGPE8r79E1Sx/AdeHjyMkuRJy/RPnJ5HJaMCP32jKYuhUW1MaXPNAuLKY38PZM1NWgJxh+msNJsb71Ldni8DvzSmZLi0KTV4slkzjGSUsSj3uuhvQ3U8+K/Ct5+Jn+1QvOvjBmKNT5y2B5uMFUG1r89j16Vo3tgUGywSpdKJImQdkHRQkqWOa6yG5FPy2AdipdUUsvCIQBIxbB3Hh48j7CxRCFFK+75vgSdn+yKY/bNYRaxw3s/UeEItt1FL49Uyx2qSEiZ/tj5059dMc2Cm+d8VlQZeIEtAMaCOnzWiUPNM0YzNxzcRnt+T45N3bCV6x2cILcLmijfGFv6Pgbmnf7PJQ2Mu9q+hx0qnMHMj1/CWHRf04ebtlBcbk3stn5CbikTJsguJZoyd+FsBRqXUkUkyyOaDVZX6HHyI+Rj5whkdqXM3wL6Qj53lviG5NlB2CWMbiWlXpXLCe2zfsRAY0znl8u37hJcPIOyLwecK+s9TICnqMN/Ag53WCKxmd9gMu7f+9x+pNDMRsP8rB4SpwBHM9hzD8a9yQMptEWiZ1xxbhiwMzJ9iZrxF+/uCw4WsDfpD7Z48+NlJ+VlB23A4QPJ6Gs+igBbEI72is2Cu/K2hqOi4EF9kZKtzPl84ebLWumCr9sGbfVPPz4V/UF6KPkIfBbIT1EQERSAAMfXy54RlkkOQZZa/6YALzHo1YO5fvGmeJryGDOq/VCJt9zuq6aM+jF2HqyhH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6486002)(316002)(31696002)(2616005)(5660300002)(86362001)(2906002)(186003)(6506007)(38100700002)(53546011)(8676002)(66556008)(4326008)(36756003)(6666004)(66476007)(66946007)(31686004)(6916009)(508600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzFFRldkTFZ3OS9JdjVFRkhyWkZrMGRqTHFoYnVPSi9QeitTdmU5NWFGbC9w?=
 =?utf-8?B?bmkwWUxFVkp5VGd4eTBHeUd5RkxKS3NqQkd2N1Y2YlVMNksxVUtSZVEyRkhL?=
 =?utf-8?B?NXZzWEpET2R3Mkg3bFptTzEyMllzZFd6SlQxc0xJdEx5ZU9CZzA2czBiSGF0?=
 =?utf-8?B?Y2l6TlNCc1pzSDJUSU45SnEwRzMveE9ma2Z0cm8zV1paZXlxaDNaOGw1VVNh?=
 =?utf-8?B?cTNyb2x6NlpQa0lzUmpSNnMrWlY2cVJ1Mkg2U0NtU0MvWTBGbnJpZXY5czlu?=
 =?utf-8?B?N2NCcDF2clZFMGRTMzA4TnB3d2lNeG5samRTUHFaMmhOTzZpUTdQcHVqT05Y?=
 =?utf-8?B?RTBzcFl4TE1XV2lEU1pMcGIwbWJGNkdUSlB2SXlzWGRRZGs0SWNzZVJOclR6?=
 =?utf-8?B?NGtLa1NYdi9COXpLbGZhREkreXJ4b2ZjMXVMekRna1R4aTE3QTZpamRhNnd6?=
 =?utf-8?B?akpsc0RBU3c4blpsMkNNalRqZ1FvV1R4YndGOFdhaDIwOHRoZmRuNEpvZXZC?=
 =?utf-8?B?NG16Mng1ZGU4eFVUdDN5dFd5bytQbGdSQmRZeVVseGlSOE1vblY5MjBveWUy?=
 =?utf-8?B?bDhXL21Qa2ZBVEZaOWFoYXRYdDU0Y2pwOEdHRXJwcDNHZVFRUjBZUHdwaDBy?=
 =?utf-8?B?aDBrWmpoSmNuK2RjVXVTQkJTSDhrc2V5THZyRWhsb3hFR0xXMkRrR1NPZ2hO?=
 =?utf-8?B?Q3Y2cjV3T3NlazY0QzJ1aFBSWjBBeXQ2R2EwWjZpbnVndkNGNXZ0c1c4Mi92?=
 =?utf-8?B?MGpudFJpUWdPUUdYQU5HQy9pcFVhT05JOXJOcjdUallmb3BVaWl0OFBuU2ZL?=
 =?utf-8?B?aFFxYURObEFKaGFtTUJZNnNkS1NUVk9OOS8vL0tRc2h0VFo0eWlEYkFZMGoz?=
 =?utf-8?B?T2YvRkJFR2xnVThiMDFhdVBqNkZ3YTZzdExtS3RUSC8xNEpJSzRFNll4OUNR?=
 =?utf-8?B?dzkrdkNjQWZHckVZbVNmRnlPL2N2MVlCVThlK1NLWXRGUzBHdFBnS1h2YWpv?=
 =?utf-8?B?bi9OR0wvbnlJWkJuemo2VTd1UnRyM044eDA3SVlCZHhDVFllaHh2ZzNpNUg1?=
 =?utf-8?B?S3l0N2JCOHk4KzEyRzR0ZGlKYlBHaVNtSFFacGFiUHVCNC9jdDVBNk54d1BP?=
 =?utf-8?B?UWhKMmJkaDlHQnU2Tnk1R3ZJZ0ZmWG9ublhvSG0zdXVBSDhiV21mTEIyTzdX?=
 =?utf-8?B?QTBVUnkyOG5lRzl5NHdHQ3hpdFJtVzI3RmdobGx3TGVJOWxaWnVwN3R0eTZF?=
 =?utf-8?B?UU1PWW1XaDdQL1FNUHQ1ZVM5U2w5Z2hhb3poN09TUERqeTlKM0hQS05TaDAy?=
 =?utf-8?B?ZmhjS01BWnhyTEtzVmJDMzkxQ3pnbng4MzF5Q0xDUGp1b09rbys0WjBYdjJx?=
 =?utf-8?B?cE5vaFp3WUl5ZE9WVVZkZk8ra2lQNkZCck9uQlg5REsxa2pKSWM1UzUwRDNW?=
 =?utf-8?B?N1d3ajFEWjhNNkNNT2pGWVUzOUNsS3R0aXhNVDVoVWtIeXVrcGtXRnFNZElL?=
 =?utf-8?B?SGFmak1kbEY3WExWWE1EQzF0RVZrUUFPRkZlcWhmdnhzNXo5ckVnYWwyOFF2?=
 =?utf-8?B?cjBOVHRReFVLU0c2Qmk1YnlVdS9SakNwdzl0Ym00cEY5TWtRZVBxVEZuV1Js?=
 =?utf-8?B?MlNxNXlkM3R0d2JYNnNZcWF2MjNtQldJZHVKTUtmVHBWYzBCQUUwbi9JRHpX?=
 =?utf-8?B?ZkNscENnN05sQkFLSjdzdmdoOXdzSHRBZEhDQWdxbThKQyt3Y1hHVk1oazdK?=
 =?utf-8?B?U09pbTdSTWpVekIxdFZ5Ri9xT3NCK0tpVlNZRW95YWdJZ1kvZ0gzSTRzRm1a?=
 =?utf-8?B?aHhndXRiM1U2L1dGTGN2WVNBSVI5UWRjOEQ3RlErUVNpUDFJOTdhU1NQUUNQ?=
 =?utf-8?B?TUY5cVhYMUpWL2Mvc0xnWkhiSGZPR25rbXlCZVVnNWNXOVBzcStzRmptcHd1?=
 =?utf-8?B?Y3IxcDB5K2IzZEl6QmdWSUdkcEZDdVF0ZTRMdDNHTE5Sa1YyK3JpRWJvZE1i?=
 =?utf-8?B?b3FjbytFWmQ1MVQzNHNDMnBrckZSd3dnNFlCeW55UWVxTlJWY1BtcmpKY29w?=
 =?utf-8?B?eDllMUZjTXFCTTJKZnNYLysyU205V0g2Q0h2aVpmOUhzOTBORTJGblh4eWdv?=
 =?utf-8?B?WlRPTFNHcStUZGJ3ak9MUDhFV1gvQ0pDTXduNzBTdWg3NDZvWWd1ZFlwVkw0?=
 =?utf-8?B?NUtOZFJFd3I1MjkwYXVIL2xWMHFQc2xBM1VGZ2VxS0tMM3Z1RzVJZkFXcTNl?=
 =?utf-8?B?Wjlacnpma1pubnBUU3BTOExkd3EzV29DbzNRYTJUWkdWbXlQaWwwVHlOaUha?=
 =?utf-8?B?ZkhOT2hGSVIxVmpmWFZyaExkdzQzVXk5aFIwZ3JqcGxPTkpEY2xGcFZ3MWRk?=
 =?utf-8?Q?uwD5LOTec72LU4D4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd73ce9c-c6df-4db9-6c49-08da47f1c31a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 19:21:31.3731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8RwybcFXvZXYuJtJ9gYsGO9o1FBhxIvkt+YoOl7wFU5JuP0XHTAz+BVF5Irp5o0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2915
X-Proofpoint-GUID: L8MmTm5D6XFgoG9KJaCcacaD5T719LRb
X-Proofpoint-ORIG-GUID: L8MmTm5D6XFgoG9KJaCcacaD5T719LRb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_05,2022-06-03_01,2022-02-23_01
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



On 6/6/22 12:18 PM, Matthew Wilcox wrote:
> On Mon, Jun 06, 2022 at 09:39:03AM -0700, Stefan Roesch wrote:
>>
>>
>> On 6/2/22 5:38 AM, Matthew Wilcox wrote:
>>> On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
>>>> Change the signature of iomap_write_iter() to return an error code. In
>>>> case we cannot allocate a page in iomap_write_begin(), we will not retry
>>>> the memory alloction in iomap_write_begin().
>>>
>>> loff_t can already represent an error code.  And it's already used like
>>> that.
>>>
>>>> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>>>  		length -= status;
>>>>  	} while (iov_iter_count(i) && length);
>>>>  
>>>> -	return written ? written : status;
>>>> +	*processed = written ? written : error;
>>>> +	return error;
>>>
>>> I think the change you really want is:
>>>
>>> 	if (status == -EAGAIN)
>>> 		return -EAGAIN;
>>> 	if (written)
>>> 		return written;
>>> 	return status;
>>>
>>
>> I think the change needs to be:
>>
>> -    return written ? written : status;
>> +    if (status == -EAGAIN) {
>> +        iov_iter_revert(i, written);
>> +        return -EAGAIN;
>> +    }
>> +    if (written)
>> +        return written;
>> +    return status;
> 
> Ah yes, I think you're right.
> 
> Does it work to leave everything the way it is, call back into the
> iomap_write_iter() after having done a short write, get the -EAGAIN at
> that point and pass the already-advanced iterator to the worker thread?
> I haven't looked into the details of how that works, so maybe you just
> can't do that.

With the above change, short writes are handled correctly.

