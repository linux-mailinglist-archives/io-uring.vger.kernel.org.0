Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A044053EE97
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 21:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiFFT2b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 15:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiFFT21 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 15:28:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE6B6578;
        Mon,  6 Jun 2022 12:28:26 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256GgPAk012612;
        Mon, 6 Jun 2022 12:28:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oVgCsUsov0GciScjbjx0y5nNFB+1qbFFXFLHzdg7Tt0=;
 b=Acvco+jgPhTPlD0oqaWN/2pD79SvCoMDJMDhGbRi7LjeO6p/AaH2vodN5IwD3i0+s9Fd
 e6OTHvVo/Gquv9ZC5nMdJu4ehR0tKtl3K/OQIPP1js8d7z3tiNYr6HRgytqTvsmzyrFw
 ECwKpKa/+ud+IeSX29nPoUFCtpKSAm+K0rg= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gg3ejjp5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 12:28:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njiIM05qBsW6jtBKdrejb1Ud8cX5021e1X1/9AGf8Zdmcuh3ZRD3ZlmR6g4kYnWE7TTznItH+ecP4BHHpahUQY/dpwom6NNMJlRKPqp08IJqyJ8vXgcynQU+julGiMYrDRpDRHLmzmZ1llefYKjMd1ZY4+U1g9bkNVsnhox+aFG/xIIOMoOTbfUIRKR0iU/qUz75h/CwLWbxVH3W4QwnnSqIxNeaBgp9s+h5ir/1h9GGSYcjmuJ3Prh+wPWPyua689oKL8Sc9UvCR1qKMDHx1+ByH64AHVEf/e4vKQbiVblkGlLWNU/6cfacryr7oNvlC8w2ZeaFHQghmisTzYxwgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVgCsUsov0GciScjbjx0y5nNFB+1qbFFXFLHzdg7Tt0=;
 b=cojCDGgEfd9iEEWH7AdFWnlGgQTrTRIodYhiOhixSN6xI492olLDOf1EDj5tu+OhyCUxjcTHiXa+EjFsJ+wLq3Ienip6lERx83dee8/w+VumWuGBOi6vqN1LrAC4vUAQeTxdTGlKFBvhvojP11mGrNM8eQPG3tZbcNwCzu8KKV13I3M0DXwq3uta8y9F2s2P+p8smrAmwYNuvU7ZJpJdTg5Aus2zBG3uPqLi3nyjiN62mgdzQZOVmLk3U6AkYLoH3VP32EPIoktEwZwMTkUzHweaoWigjzVUl2et1MPDBkCxEYElhW7+4ZdLM/zBgoMwPIzXxcD9PzCl5QA9vNrWZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by SJ0PR15MB4454.namprd15.prod.outlook.com (2603:10b6:a03:373::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 19:28:13 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 19:28:13 +0000
Message-ID: <8a7c76d2-3cb4-0162-584a-69b130831c3e@fb.com>
Date:   Mon, 6 Jun 2022 12:28:04 -0700
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
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yp5Uw65VFcTaSyfi@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9ef81ff-480d-419d-0674-08da47f2b280
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4454:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB44545CB9AD3360DE77E3E5A9D8A29@SJ0PR15MB4454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLhifkQG8GARWoZfyP9ukJ9oG9IcjJznaoNQJjQOiJc8KeHJwu8PHkQpqreXM2douy+AlMw8ntJiXiDg86l8j4XvvIK69Xbz9b2y+3to6SV6g3+Q45yA315jOfFa5uO9HpD1M/7gzF697hxKEpjhjc5ls+eI66boENKYdPt26c1UpiCS/ohMdZrP0tH1cXu44oiktuNck8X0M1balpSxeXvxop/bTLPzWAZH7B5Iado/EQepb39YNEnk/yxJa5HwfpDGOh/fQeADmevRacSGHJaMYwBdkSJkJ/siHiACxO1RaBaEq0vuwECS+JIpTGdicSc6RK6wfyQm2wsRG8R666R47iux0PYJPjLFzAK4riaBOV2wdbI5EYDzuqinIfxBciatWZLDM05kaMPmPJqDuWwmVphmEvJGePhsGxey6UWm17XXJiQo1fk2O2UxoDLAUn5PcXemULuj/5/EcSpVM9KH9qTLO6B2E59QCI1gsMBeOi0tG8P3Z5LrXILmYbFtZAkikPC6jY/R5NVaA6Sz3ik38Xtc2Q+eTT6ZrkOOWOChPpfP3pGKC1qUBw8qUTWFGn/N9k/hFZOxErXa31OHX/hXr171YtlVwdNrACwSzVJz0O5EnJBmy0w1kHpxxmwtDRWM38V3oO4N+xkSsjeTqjsrPUL6LnVLgx9sbYwiX5+KulwfYWxS+hN1f5ES4Bu3apMJE4ahkJBR+o8d3nGxD46dMNFyz1Z7fXaySqFUgkG8keTJhWf5FId8JVXUZOC+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(8936002)(38100700002)(8676002)(4326008)(5660300002)(66476007)(66946007)(66556008)(31686004)(6506007)(316002)(6916009)(6666004)(53546011)(186003)(6486002)(36756003)(2906002)(508600001)(31696002)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGFPNjkzL08yVFFMSXpoNlhORHdXaDA3OVdkQkRHMi95U1dsWGNnZkRmRUVS?=
 =?utf-8?B?YTBxY1hUZ3JzakMvR3IxWndTNFhlQ2ZIb2VBUGRObm41ZE55UDM2RlZNbmFG?=
 =?utf-8?B?SnJkckRScXV5M3pOc293alFiSEs1bjlncngySDhqMG16RlJYdFBQQWF4eURq?=
 =?utf-8?B?YlBWUFd3NFFKc0xuMEpnL1NjbXpEZzdsckdiejRYSkVidWk4MVRIR1hsV3E1?=
 =?utf-8?B?S05yVUdYY1piNFV6aTJFNVpGVUVKVGdTRGxwNUlJUW14SytUMDBacTh6eDZv?=
 =?utf-8?B?RG02MUNvam4rc1RGUlg3bEVWZitIRWNoakcxeXlIVmVGdmpxL1JuZzZPQnRK?=
 =?utf-8?B?d1RTYmpMWDZLU3NIRmdJeGt5em9NMHhlUW9wVXRGaTAxSm92RXJQNGZaZC8w?=
 =?utf-8?B?bXRUS0VydFhMWlJOc0lTa2NyQ0RYS3B0TncycjhRZHBQS0l0Mmp4YUthTldh?=
 =?utf-8?B?UUlLbCtOMVhhZzE3c2VHa2w0dkw1VlM1YlRmcFBZWGlveWkrWThLWjAxQTE3?=
 =?utf-8?B?R1NRcnJBb3hOV0hUOFMrdVdrWjVGdExZTnRaaTU3YittVFFQbEF0S2Zmbmg4?=
 =?utf-8?B?aUFiWDkzTGh3Wm1tZXlkTnZLVUpnWk53cVZLOGN0NE9UWG8zWGlGMHI5OWRR?=
 =?utf-8?B?WUxqMjltb01FWllPV1prMDN3blR0R29wbHljL2RUVElobks3QmFnQ3FwSk15?=
 =?utf-8?B?YjFja3ZKYjhZalRyOE9LeVhNOWdITUJCbG1iZnZJZ2xqY3hWdmZSekJNbmt6?=
 =?utf-8?B?c2VVTEUzYk1JWUgyWENsYmQ2Y2M5cGdzZUM2V3JEZDhNQnlJSW44b3JtMkdE?=
 =?utf-8?B?NVBvUFJzbll4dVZ1UThJeWVFSWYyclRvSTFaTjBkNnNHT2hKd21LYldsK2Rz?=
 =?utf-8?B?emdndU1pZ0MzTUgyRzRtbmxkcTF2TEo3ZHRnQ1U4dDFRT0QwakRxTUFNUjVx?=
 =?utf-8?B?WHZuUGdRdzdyNkNjeGo2eUNjUGJQYUZrSVZseUw5Y1QwQXdHTE5xd3VxeG9G?=
 =?utf-8?B?R0V3WUxDZytQUGV5TDBWUnhKZ0lDMm5RL2VXSUlkeEc2UnU5ZVNNcFEvYlNH?=
 =?utf-8?B?MUF4QU9YMTBHQnUrOFdTTjdoclpjZ0NLbFIwaXUvRE4xa2Joc2hOWlptYjNS?=
 =?utf-8?B?TTBXSXAzK1NXZTRmaUl2VTh6c1NiZE9sM01HZEUwcnVRMHVLZENTVUU2emFN?=
 =?utf-8?B?Y3hhejZYcENBTWtJWWZvUXFpclJDbU55MGpRV2xnREt4V3pzK3lKZmhLZ0VK?=
 =?utf-8?B?WVRWdmtHbFR6RkdieTBJSFcyL1NjaDMybTV6ZUNsekxRSXc2UGU5L0hPMjRS?=
 =?utf-8?B?SzI1S0JodUQ2N2FjeG1BSUJKRnhvRDBaaFJlOC9FanJHVElnRkNJNThXUVJE?=
 =?utf-8?B?WWhCN2dyaEpPNlJwYmFZZGRuS0hPRm16Z3VJMlZab0EydktGYmtRZVlObmNY?=
 =?utf-8?B?RmppcTFTRnVkRWJ0bm9rNit4Q0poT3Y1UEpwRk9keThVbTU1cnRKK0M1amZO?=
 =?utf-8?B?UFZsOXdOMmVDU1N1TjVMUWVzeFIvRDBTbjIwLytldy9uSmNtUmROMU45SEZ1?=
 =?utf-8?B?Q3IvRkdFVnBRZ245bDY0eGVnUkVWenAxSXA5RjlJNGxldHhXeVZWcUdaZytD?=
 =?utf-8?B?ZW5xZTFwNDY4MEFLMXVTYVJ3Z1E4M1g2QlMxdjhoUnVXN2cyTmNObXBsTEUy?=
 =?utf-8?B?NW5pVGR3c1djUE5KM3NvWEQ3bEwvSXhNR2hkVEZuWW9SdUtvL2ZZSFNyZ1Q2?=
 =?utf-8?B?OTlOYXJTZU5jSitoN3VmdCtFb0pZUmt6RmU5dkxTcEM0Q1BIa3FQWFpROVpV?=
 =?utf-8?B?NTV0STZ4WkFXcytCaTRzdVJOVmE3dThPTmhLdEljMkJkVzVGOWpST2F2T0Fs?=
 =?utf-8?B?UCsweVZhcTQ1VmM2aWtjUk1uU2hQZncyZnFYcUJOSVgwL0dMNlc0ckcvNFBQ?=
 =?utf-8?B?Wml1c2RlazJ4dVo1bjJ4bTVFT0QvOHFyNEs4RmIrc2NscUZ5YURyM000VExF?=
 =?utf-8?B?ZU1tdUNSeUxLbXltSzlFRW1HK1JJeDc2QVRsZTVlcFpIeStGTjB2bGdldWc5?=
 =?utf-8?B?bFVGN1hNd2IzelFHMys5V3hvZ04zYW1xcmdXUW1tNVlUdmZjalRBa0Q2RmNr?=
 =?utf-8?B?a2hvZWZzdC9VMzF6OVNJWjJyeW0vbWxLVWZDU3ovTEdCMmZzVklSV1lWSU0y?=
 =?utf-8?B?dzlyRThMYk1IKzlLZjdhdUhjZDdUQ3d4MnNmeUFVaHBKWUxCeEtaRWxZRjlZ?=
 =?utf-8?B?TXJESUgxQ0NORkNFRFM4ZEJ5Q25DVm8wVUR2NkMzdDg1Mk5YLzV4MUpwd0RJ?=
 =?utf-8?B?WFcrWTNMRWIzRkgzT1d6b2Qra1NJK04vaDhRQ0tJb3pxYUt3SjVCVjdpQ0I3?=
 =?utf-8?Q?BPOGYmzp7xR6A8ig=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ef81ff-480d-419d-0674-08da47f2b280
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 19:28:13.0145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyAUBaPQBNGKSGxUgXVFHc/NvbNwmfYOzuPfprMPo7AbGSlupaiZgIQ+/UE+H3Ql
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4454
X-Proofpoint-ORIG-GUID: 2_fIjywIc0wHPImSh5DfmbLf7AhrC8NJ
X-Proofpoint-GUID: 2_fIjywIc0wHPImSh5DfmbLf7AhrC8NJ
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



On 6/6/22 12:25 PM, Matthew Wilcox wrote:
> On Mon, Jun 06, 2022 at 12:21:28PM -0700, Stefan Roesch wrote:
>>
>>
>> On 6/6/22 12:18 PM, Matthew Wilcox wrote:
>>> On Mon, Jun 06, 2022 at 09:39:03AM -0700, Stefan Roesch wrote:
>>>>
>>>>
>>>> On 6/2/22 5:38 AM, Matthew Wilcox wrote:
>>>>> On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
>>>>>> Change the signature of iomap_write_iter() to return an error code. In
>>>>>> case we cannot allocate a page in iomap_write_begin(), we will not retry
>>>>>> the memory alloction in iomap_write_begin().
>>>>>
>>>>> loff_t can already represent an error code.  And it's already used like
>>>>> that.
>>>>>
>>>>>> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>>>>>  		length -= status;
>>>>>>  	} while (iov_iter_count(i) && length);
>>>>>>  
>>>>>> -	return written ? written : status;
>>>>>> +	*processed = written ? written : error;
>>>>>> +	return error;
>>>>>
>>>>> I think the change you really want is:
>>>>>
>>>>> 	if (status == -EAGAIN)
>>>>> 		return -EAGAIN;
>>>>> 	if (written)
>>>>> 		return written;
>>>>> 	return status;
>>>>>
>>>>
>>>> I think the change needs to be:
>>>>
>>>> -    return written ? written : status;
>>>> +    if (status == -EAGAIN) {
>>>> +        iov_iter_revert(i, written);
>>>> +        return -EAGAIN;
>>>> +    }
>>>> +    if (written)
>>>> +        return written;
>>>> +    return status;
>>>
>>> Ah yes, I think you're right.
>>>
>>> Does it work to leave everything the way it is, call back into the
>>> iomap_write_iter() after having done a short write, get the -EAGAIN at
>>> that point and pass the already-advanced iterator to the worker thread?
>>> I haven't looked into the details of how that works, so maybe you just
>>> can't do that.
>>
>> With the above change, short writes are handled correctly.
> 
> Are they though?  What about a write that crosses an extent boundary?
> iomap_write_iter() gets called once per extent and I have a feeling that
> you really need to revert the entire write, rather than just the part
> of the write that was to that extent.
> 
> Anyway, my question was whether we need to revert or whether the worker
> thread can continue from where we left off.

Without iov_iter_revert() fsx fails with errors in short writes and also my test
program which issues short writes fails.

