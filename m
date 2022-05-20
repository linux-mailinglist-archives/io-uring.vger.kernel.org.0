Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25CD52F2DC
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbiETSdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238380AbiETSc7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:32:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38691BE8E;
        Fri, 20 May 2022 11:32:58 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSOPd018095;
        Fri, 20 May 2022 11:32:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NMFzQMxspDjPAgVxiEolFz9LOhBHZ6+gNmt9dpaKwmo=;
 b=FZi3p1IYQ7HTNrBkT6Qsgvi2XAGU2zSRmFtImqkITN9Yut5p9L2HnMWR+KkGnBviaxfU
 Dg5TkCmNHm7m6rrDq8YKBmnHEwPOUWXkLWt8C/NQUgwdC+7neKiVKwh7gmSjkhVEkJTT
 x77eJ/o3p/kjuA9ENUhhUvy1NEYHH+nYsKY= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5xexdv19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:32:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/81uyOpVm6LMar5F4chMWWBrfUD9goMBne+3ckgRbMcqxuAK5HQ4JHkr0mZjunHRPEz2RP0aPqT4NUpGoI2hBoSG/yRIfFN9P6vgw4tLwfwwSkUPftzFivBvBJ8MEfo8eEnoVtWuxey8JD82iF/46wcL50bnnYIiX6a22yjdgE5ovczZMsxkRjVsYPeTXUoYZaG5vEXKCZhYSe0zOAZY4YOlTSEX9PhsGUlASr14RJPqCLi/dog6jVkcHy+7sr9n1DYc7hQsGx0CVIa15b3A2Z91u6+2m/Mj5nwCYsNvAKG4tsZlaD1m+SCUFBEfuH8eoJYnPUIIfRr8LpSg/rSuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMFzQMxspDjPAgVxiEolFz9LOhBHZ6+gNmt9dpaKwmo=;
 b=lo/zH26slzuoVMXDsLKyxSxDLQHmfOp1vE5CgvSq0G5Yu1ZRtpQtUgayZYz0pt3ed4LY9wkSdNT7A+/gcMW4vzrXqk6WItPOEP0lunDeVACzdQEbIi61UTgAyI4ABt2NzPmC8X4QcMo17AZFvH9lG6QhTzL2wRST7v9NxNsmcK/DYDr4tFfY1VCiNG8k0eR0MwhiZqMv+493r8z59+WfYZO3PHA0uLm97YNOP1RhtakN9u4CSoTw41xTFJCyzuCWMzxEc872+MTDDPi5mp7oYObSS2SUoNmSQMhi9hKuV4gB5eHX91sK5o9mAEOXsc4hSXyo35XsE9YI1d/epBvADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MN2PR15MB4799.namprd15.prod.outlook.com (2603:10b6:208:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 18:32:48 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:32:48 +0000
Message-ID: <6f6cfa39-395d-4117-359c-6ef82dcb6e89@fb.com>
Date:   Fri, 20 May 2022 11:32:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 15/18] mm: Add
 balance_dirty_pages_ratelimited_async() function
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-16-shr@fb.com> <YoX/4fwQOYyTL34a@infradead.org>
 <20220519085412.ngnnhsf6iy35vqn3@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220519085412.ngnnhsf6iy35vqn3@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:a03:54::17) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa5d2116-f6f9-4262-e186-08da3a8f23b3
X-MS-TrafficTypeDiagnostic: MN2PR15MB4799:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB47991812950DB65B90766A86D8D39@MN2PR15MB4799.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UPpzULaA7LceekCRXh+qKlKaJMzVh4ZTeSb4csuLIvWMyFNMHM4hqk8D/P3nwk3rxxlnE4mSdIGqsDn7w8M5MzoEubZBo5EI8BkKXrgzrjk92G9wwb5NG3OiqQoBrGaXFc4yhiDzNcpjb3Pa6QjaozB/53vfeNmb53eZ6BFCXKrrV19Vcvetv+WAf/a0Z/tzt1Yhrj6iOPpzvZ8A5Y0KFgjwUnkipB0XuQThT5jzeN4l1KkTb9Cuf/t8+aE+Ln4wuTZgkFyG7xotvN0BCGkbyD0wq1I3BbS/veCOFjXql76JMZt58wYI8KoCxp1YdcsHUEgEmpydgIBl6+ffRPXgye+1IgSfGeY8B9/omp9IUiGljBrc3IeI4hNkqoxpMkbVmwfpf1Z7rJYM7sYiV4ZmRQwxjLe/MgPzU/D3RZFrRsi2W0X7EsZczF8WbaViU8XcBxOfXsFwb5+yqbDton1HlE6cWE5FWWq6z4J/g7vgAg7stdWTRKofAdpZL+ZG8vKngZYl2Xkc3N0UAimZip7Sh4bpMkBnN2kLLM1Kic2qBFydUZ3gQQLmUGj9jdyE+csXIcKhWPjaAc3QXdBs17EemXXYzkJRIU7ES+tQErw0iSrdpwN0rYKKyTY5Jm7gQpF8YA/o1Y0pK0U5wNj7WIXaA485bqk9PXdwxBIgK0qXoB4HUFjkWJbCIJTXENsyZ/I++xLAXpEkjDcGk4XwR0FhMEACDRea2QJEpEvPlVn/fwBOzBk9QeRFI113Yg4BpOuc4/5pWqkCx3cuDtfrBpyPEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6486002)(2616005)(5660300002)(2906002)(83380400001)(8936002)(36756003)(508600001)(31686004)(66556008)(66946007)(4326008)(8676002)(110136005)(38100700002)(66476007)(31696002)(86362001)(6666004)(6512007)(6506007)(53546011)(316002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW1VZ01CbSt0NWlrSHF6Rmo3dTllYkxaWXpjSkpUeXFrUlMwOEg3U2tNUGNw?=
 =?utf-8?B?b0JoQXkxK3Y2STVONkhHU3RYbjNaSEtQQ29tbVdqaUtMcWZ0SlFLVTkyYnNt?=
 =?utf-8?B?aFlVclg0SUVyZ0IzK291ODh5OWpZdnkvYkNGbWQ1YW9ubWlRUjhQVktrZ0hG?=
 =?utf-8?B?S2NVLzNUK3F4c1QwWDdzMVhLeS9HSVl1S3l6RDR5ZklRSXdSMU91NWZSSkVH?=
 =?utf-8?B?cXhwaUQ1TjhDVE1JTHlUOTJ3S2plbTlGTUljOTl3cExJczgvekdrTGJHdHZm?=
 =?utf-8?B?ODliVWRpWjY3TDU1WXptNGtIalMwdTNpV2hxMVVUL0x0b3RwMFU3S05oaVJq?=
 =?utf-8?B?VWhZN2VVb29jMVl3WWlaS1JMQ2xFMUFOSWdxbmVJOEpscVhTRFlLeCs5VVQy?=
 =?utf-8?B?Y09KNTJySkxEUjlUWEF6anZlNW5CWTYxZ3RMOWdRMGtPK1FseDJZcFpmYmJB?=
 =?utf-8?B?bGNqbkhQZ2llZDYxNEVMdStKNTdURjBGRUFKeGRKcnVuaUlkbTNoeHg4ZDYz?=
 =?utf-8?B?VW9aKzFBYkFVYUdDOFlEaTRxbDU0RnpDSVdhemVUMzBLY3NnYmdkdC96QkFh?=
 =?utf-8?B?dEVxRmNnNkMrdy9KZTNVRWVVREcvR3E3L20wZnBrZGYxeTh4UTJZbm96MUFh?=
 =?utf-8?B?MVpmWmo5dVdSdVo3YjdJT1MyUlNxVEVDQzA1UUtzS2lhMDdkVWhTMW5qRGY3?=
 =?utf-8?B?V09vbmdWT3FFUGx0Y096MzhoY0FldUVuSGJhaE9YZjk5VU1sVm8wVXNnNWdm?=
 =?utf-8?B?N0Y5ZlZ1QVRrNnJsaTl0N2RadDhuMmNheU1WU25RUGVsdmtmMkZpWlU4ZG1i?=
 =?utf-8?B?TU0vVjd0MWZTSlladWZxaWh1Yyt6N3BvYmhzQ0R0RDlGZ0cwWEwxZkM0aUJW?=
 =?utf-8?B?Tk5oTU1wNmpHZXFVdlBmdWw3cnhaWDV1S0wzYko2ZGVNeEEva0k5VTN5djRo?=
 =?utf-8?B?dDdJMzloaUxlOTMzQmNVeE52ZzZRT1ZZTE9xc285N01MM2YxenhzMnFxVUNi?=
 =?utf-8?B?TGMzaWZvNE5mN0JrSGtENjFzSytVK08xODdEQjU4bjNZSUU5M2F1cXdha2ly?=
 =?utf-8?B?dGx1RzFOS3JmVlNSVHM4WHUyRmRIVTRaYmMrTWszblJ4dGFYdTJPa0M3RklF?=
 =?utf-8?B?d2dBUk9iQm1ncVBuRTFKREl4UDdWQ2VsV3JCcWg1QXltMWxPY2wwVDN1MURJ?=
 =?utf-8?B?Y3UvMWVqc2cwbGRZOVhnU0diK0pseTBjNFBxd2NXUWJaVHArdEduaEU4WklK?=
 =?utf-8?B?QlBuZFB2M2g2UWp0ZnRKTGV0QW5VVVVvTlF5MEVjckZraEFoVVdWdmVzUW43?=
 =?utf-8?B?TlJCY25tTDdtQTN1d05hUHBWK3FhQ1NacXc2bElnNm5SeFZVUjRnOEpTNzkx?=
 =?utf-8?B?Wkx6NXhQdExLbHNuRXZ6SzhDaVYxTzVGK3FCWmFDK1M5Y3c0NlBkaTN2MWlD?=
 =?utf-8?B?azA0WDQ4cWMzUk5EQTJCbkxORk1xWm90VlI1U3pzT0RHcFBzdXJpRmV2QWVv?=
 =?utf-8?B?Qythc3FTK3ZWeGRHajVZK2FEbXA2UW5qdEd2YXZlZHBIWlVWdGFzbk9hclUv?=
 =?utf-8?B?Y3V1ZTlrelczb1dUeXBiQVhxeXl5YlBtb0R0ZXNVanV4eC9ZL3VUd3Y5VlZw?=
 =?utf-8?B?K3F6VXFhQkVVNTlhU25sWGJ4T2NldFhHQTl5eE5ETnA5Sk1MOFJhSkxYclAw?=
 =?utf-8?B?SHplRkZuTlB5Z3BFUUZESmtMVlZUR2FwWklCbUFBbEptTjBEcmlUMHNoZEhY?=
 =?utf-8?B?M0tqU0V4c2lLRXVlWGZZN3EzMFpEdjI4NTJSaHEvY0hUeGtmS29SRzlkQkk1?=
 =?utf-8?B?dTZrRVVUOUZzYk1sTXdaaUhyMlJJZ0F4NmlyMTlVZWFUODVNcjNBbkZpL1RT?=
 =?utf-8?B?QXhVbS9sQjlKMUFCRk8vUGJBYmdEUTJ6KzU4SVRueUhpZTZ0bHEwZkRLWUZP?=
 =?utf-8?B?RUhJcDJGajROd0Q1dFZZaVlsN0xGN01zR3h2WC92dkZ4ODBWaDJBZzZ1RGJE?=
 =?utf-8?B?cXFFdmNCRlNUK0ZwdDU1YytSaW9MSXdrQU5iTXpsVm1YcWJRL3dOZmxvWm1Q?=
 =?utf-8?B?NnYvU0JqWERsZkxDK0k1VmNRQlpSRnB0bE1LMW80dXZBN2pYbis1KzJnbTFS?=
 =?utf-8?B?NkVMTmN1MloxNm5GTjV6Z2lndXpKbkgxOW1EOHZkdzBTandhQUVQam9rRjVR?=
 =?utf-8?B?NzE2cVpxOUI0WitzNnVZWlV5dzltbTJxb2duVDFzQVRvWmI1aC9UdERqZ09r?=
 =?utf-8?B?WEdsY1pzK2lCcnhJQXA0MXdRU0dKT3dRZmhDR3BXUkRTOFpsMkFUTTNkZXZG?=
 =?utf-8?B?dGl2Y1hrdk9iem5LZGhtSjlKNWQ1WlQ2elJZSGx4d0lQRW9kcUVVbk5ncXM0?=
 =?utf-8?Q?oueVOBqmvI22UNrI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5d2116-f6f9-4262-e186-08da3a8f23b3
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:32:48.1009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnJWgW/QmCzkhXlz4pGwWDZK4wGyENhp64s4U1pAKC9+ZE6J/On9DddNWym+MmkJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB4799
X-Proofpoint-ORIG-GUID: 7AiBMDf-W4-OB8eIiJo4ZKIMLV79l0sF
X-Proofpoint-GUID: 7AiBMDf-W4-OB8eIiJo4ZKIMLV79l0sF
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



On 5/19/22 1:54 AM, Jan Kara wrote:
> On Thu 19-05-22 01:29:21, Christoph Hellwig wrote:
>>> +static int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
>>> +						bool no_wait)
>>>  {
>>
>> This doesn't actully take flags, but a single boolean argument.  So
>> either it needs a new name, or we actually pass a descriptiv flag.
>>
>>> +/**
>>> + * balance_dirty_pages_ratelimited_async - balance dirty memory state
>>> + * @mapping: address_space which was dirtied
>>> + *
>>> + * Processes which are dirtying memory should call in here once for each page
>>> + * which was newly dirtied.  The function will periodically check the system's
>>> + * dirty state and will initiate writeback if needed.
>>> + *
>>> + * Once we're over the dirty memory limit we decrease the ratelimiting
>>> + * by a lot, to prevent individual processes from overshooting the limit
>>> + * by (ratelimit_pages) each.
>>> + *
>>> + * This is the async version of the API. It only checks if it is required to
>>> + * balance dirty pages. In case it needs to balance dirty pages, it returns
>>> + * -EAGAIN.
>>> + */
>>> +int  balance_dirty_pages_ratelimited_async(struct address_space *mapping)
>>> +{
>>> +	return balance_dirty_pages_ratelimited_flags(mapping, true);
>>> +}
>>> +EXPORT_SYMBOL(balance_dirty_pages_ratelimited_async);
>>
>> I'd much rather export the underlying
>> balance_dirty_pages_ratelimited_flags helper than adding a pointless
>> wrapper here.  And as long as only iomap is supported there is no need
>> to export it at all.
> 
> This was actually my suggestion so I take the blame ;) I have suggested
> this because I don't like non-static functions with bool arguments (it is
> unnecessarily complicated to understand what the argument means or grep for
> it etc.). If you don't like the wrapper, creating
> 
> int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
> 					  unsigned int flags)
> 
> and have something like:
> 
> #define BDP_NOWAIT 0x0001
> 

I defined a BDP_ASYNC flag.

> is fine with me as well.
> 
> 								Honza
