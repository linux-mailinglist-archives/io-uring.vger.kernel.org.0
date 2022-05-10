Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51494522553
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 22:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiEJUQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 16:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiEJUQl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 16:16:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CD34F459;
        Tue, 10 May 2022 13:16:39 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFLPWN024968;
        Tue, 10 May 2022 13:16:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Yy9DQeYvKGVUXNLS397rl0O4bbYVCu6qdhqPXA1NnRc=;
 b=loMbCc1v7sa+klrDdLk9Z0m5bW3ryW/FS0YvN6NMOEAqApuJCUL+JG8DpfRWMFFFS7e+
 GNNESNug2DtnsFkUBYk/7ionn0QNEs8veZus94+g2+Oyvozey+Uyt7hsTMC3aJl6nLro
 nNtIfJtLT9ecEUQsPYwgO8CX5eIsNFBKdB8= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyn47vgtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:16:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA3uhZno0UnEJo0JSSb3FdZsDSgKJwgTwIeXNeAH99+tjgrRL8tLuNigC4SO9fTZaPLlbHmwUJiNHUXE3RxYqNnXUwPKoAX90XltpoG13YI4x+0ZMxcXTxKzAwQmDjZ39G8TXxMYSnpQNPrIYje37LPtZ6B8eSV+YBQEYmMGsneDK08CdjaoJJpE3p4kZKKulTEr3zziwVovHvTk3oPLdib0WQridej+/htg/nXst9bQBSsfXXzFSqBbLv5uVkW5r2T8vUii2krvhDuWfESQKKzXvMnZRXaqoRjyf3w2AmsI7mZj2q12HHMgrFviubF+BkC7BkIlD9vL/1D3ZCWgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yy9DQeYvKGVUXNLS397rl0O4bbYVCu6qdhqPXA1NnRc=;
 b=SUg6lCh3v5KPxQArHInNdRnf8NnsGkyhidIn0UsUQCeI4iOIi/TFJ9GRFtqLkJNvqi9OBYOzHtTxj/gyYaFqvxjyACV5PNIdESC2hHrvVjJEgePaC2dSb686EC8qYCtJrllxW2FoEDMGHHCGdS8+FCXtDy8e4lnv+jBun85elUOjICbgVlBRfBapBqfLJQvzPqOZkt4HcK3d4qZ5Da8ogUr7VtZ0b5Rm3cmvioC1QtqKYSBSxaHZhSYyM//ovXt+/5h5MMKQ1nAym6wZrrUt/m7v4ZlHdW8J8IHZK9sugYz7jBtz92aRqj2akpnLP09ipc2VVZokxAB2mZNWKwi55w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by PH0PR15MB5103.namprd15.prod.outlook.com (2603:10b6:510:c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 20:16:33 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%9]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 20:16:32 +0000
Message-ID: <84f8da94-1227-a351-56ba-eabdba91027b@fb.com>
Date:   Tue, 10 May 2022 13:16:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v1 15/18] mm: support write throttling for async
 buffered writes
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-16-shr@fb.com>
 <20220428174736.mgadsxfuiwmoxrzx@quack3.lan>
 <88879649-57db-5102-1bed-66f610d13317@fb.com>
 <20220510095036.6tbbwwf5hxcevzkh@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220510095036.6tbbwwf5hxcevzkh@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0347.namprd03.prod.outlook.com
 (2603:10b6:303:dc::22) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5bec4a3-bcf2-49ae-7627-08da32c1f9bf
X-MS-TrafficTypeDiagnostic: PH0PR15MB5103:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB5103CC88EB4B892D4701C935D8C99@PH0PR15MB5103.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1OJwWGHJpsC9nTEnRWo6nZ7egS/JSUMNSDH+NB/BSOwGvNz7NuInczeypB0CdB4zgJItzWugy8THRlDhSyiI5zqm+slNsRuLylrJxgJuw2QMyVJjIkanXP7ZgeWrj2idtnrae/A3x8A1gnS8BAUNTw6tFiuD/oJmSyz3lIo6LM0xrg5yfLnfwiVKc/R9lq2fJSGloCAVWySvouqerM648dto0P+sfD+nvZ4c1q+LznicStVRdO+LDxfLGRrCWtEt9Xz8uDCCTItwtQBrdZXoVYbJEjFqWSGkGsytsmPs9oCwrPjbLPJr8bho2tFXvhf2OZ1UdlpUdWfDZXsYL4q8pJvMLOdqXiLqkNz7nxaJZKVbZSoC089jQdvSOiHDzJxGAMw06wbUNC1V5NIZUVBAfWC6v8zVsSPN8PuANGurx1G7NOhUGnD+VEDiGPctjPtRDNnVBs2aQRaIhrRqNKsLgn1t8N1i9RZjiXlH1/hBfhHk9AjIHyf+cWaiHA5PoV9bdJy3BChadlsWpbvbM/pErSzjg0DgjZWYCko5623chJWEV4/F6EWSyPZicGUpw97oX2+OhtP8JMM26VGGL576070S12LSVINM9s0RsmiloxBCPyOjMYcJobKl193gBMRYSy7TnuxtLQYciglYjSXREw9g4Ffoef1o2W/M9/ERSIYHJHUsQNe6utae3Q9TbSBYNTdP9/Fz5VJOXMoos1B4MOeeLhWSpqaZehJ6abQCQio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(2616005)(86362001)(66556008)(66476007)(66946007)(6916009)(8676002)(4326008)(31696002)(8936002)(6512007)(53546011)(38100700002)(6486002)(6506007)(508600001)(2906002)(36756003)(31686004)(83380400001)(186003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzJYaEVWcFEwclJDM0hBMC8rUkZmZDZYNmk1S3NVdVJuTG9xbno4WDhqL1Jk?=
 =?utf-8?B?emR1UzFFMnAyQTk1T0FmYlgrVUg5Y2hTUXYva1ZnVHVXNk1PckZLdzBDS1Rj?=
 =?utf-8?B?M0VrWS82c3VFeHU2SVp0TTkxaFRyVjdlQmZ1eEFJM1Q5a0ZhWkN4b2Z3Z0pk?=
 =?utf-8?B?bElpSzVRc054RVAyZUNET2ZYWGRObGgycEd5UkFZdXVacDQrQnlQYXZnQmw2?=
 =?utf-8?B?UUVJZEtaWEhtUEFMOElwN0U4NFpLWTlWZCtpUEV3MGd4YmpUZlVOenQyTXcr?=
 =?utf-8?B?bnhKbXBlRGhDWHBLbFNsS0ZybXRNV1NtS3BFRVFlM2ttQXZrYzMyblJ5R1F2?=
 =?utf-8?B?U0ZsTHhZY1Q3MVo2eVRDZEpsYnlaOGJ0d0VqcWRITTd2b3A4TlA4RXJuaE5G?=
 =?utf-8?B?cmpMaDJoaTRuc3hqTzZyclFIUTY1WlNaV2laMzhxSTZ4VVFOZDBtUkVxc0d6?=
 =?utf-8?B?R0cxUVJ3eEgxOWVkakgxMW16WlNMN0M2aWhtWlM2UzRpUUt6K3ZybXVVUWR6?=
 =?utf-8?B?WG8ydXNwUXBQVzJ6dUg2UCtRQUtHSG5xRmZnR25id3ZJcDNZUXlBZlNFUG54?=
 =?utf-8?B?MTAvaHdXMVQrS1NjRDJIaTNXRDY0ZHMrNGt5aHJZM29GdGRqeTVleVlaS0RG?=
 =?utf-8?B?dVBoQnBoRTZTTWdkNGlSdit4WTVlcEdKcUxPeENHWHdCRm9tL1poRWxCbkdS?=
 =?utf-8?B?cUFXRHVyRWJlVzRudmxZc3dIQi9nSDVEUklmbDkzQ3Fxem1VMjJyZW1uVWM5?=
 =?utf-8?B?WUNHV2dXUVoyQys5UVJFNXoreXF6a0ZLM1ZjblhjN3NDWldsUnZRSGFpWkRW?=
 =?utf-8?B?TE11TURvT1VRZW1zYmY5V29HOEw5VVhVbnNzUHlYaXRwZk5OOEVNVndod2xO?=
 =?utf-8?B?R2ZmSFpwSzhlMDJWMStmcjZMa0p5QkIwS1ZHb01waWJDM25CcXFqeCtLamZO?=
 =?utf-8?B?eHZ6Y2RUc3RpZG5QMmJ4NGFCdDBHY3dOR29MTWdLRGJsOXpXTmJyWmkyK29t?=
 =?utf-8?B?d2JaZmMxQ05WdWV2eldYWk8xRDFvQ0I2NmNtSDRpSncyUXFXeUNaZzV5NmQr?=
 =?utf-8?B?ZHJXY3hPb0xWZzFGL0JTSUVYdWxxRFRKbCt3cXJGVlY2QVJvK0huL1NodkZX?=
 =?utf-8?B?djUrSlJUYU00REl6OWczYkNpQjl6b3dBN0RMK0FIU0N6WVpMeFg1cXVneW1K?=
 =?utf-8?B?ZnlxVE9QeWViNmdCTitHVmpDTGcraDB0YzNwMUtzMmdvWmdZNUZSL2hVcnUx?=
 =?utf-8?B?V2xvWmJWV2VVaHNKOVJkZVloeHdibFlXZGdIdHF0SnVNZGxZUWJUUUJUV1pP?=
 =?utf-8?B?NWhsOS85WWNOelpHZlhOckIxMlF5ZkVGNExRSE1NcTZIUEJFYVREd213b3RZ?=
 =?utf-8?B?cjh2bndyV1ZPYzdOaXNEVHFZdzNRRFlPTUhHWldDSlpmWnB5RFZmT1FMcCtP?=
 =?utf-8?B?MWtLYlU5Nlg4aEk5L08zeFEzSXZidVlyNlIwbWR3Q0ZBZ0MxNEZtbWdjVmkz?=
 =?utf-8?B?K0lOVTIrNTY0U3cwUnFVTnJoRWJMbjBRQi8yTStmOGI2bHFSV1NhdXJ3NVZE?=
 =?utf-8?B?WmhDKzhXc0dWT0I4OHdKaWpFS2lXblV5dkcxNTg4bjNyRlIxVkJWM1MxQytz?=
 =?utf-8?B?NTVUeDFrd1plVnZNRSttREZuaXI1UHRjcGNJc3A3QjlTQ1hyeTZjVFJlVEVO?=
 =?utf-8?B?aHhDcmZQOUJpcFpBTU5DNmcvSk5sekpKeXRmZERPNk93ZFUrYjhiOGV3aVBx?=
 =?utf-8?B?Ti9KdXViWmJTVUhudXIzSk91QXVmdlJIMkx4ZCtuQzNna1d5Uk12dy8xUFRP?=
 =?utf-8?B?TnJUcmtMb2J5VitTWjdQZzNmcXRsOTJqNHVDN1hlTTZ0bmNMekdScFF6VWgz?=
 =?utf-8?B?N2tTNlRpTnAxQzg1OTh5U0x6bkdGd0tJUVNDNjNjL01YYUFtdUd3VGRvblV3?=
 =?utf-8?B?R1pXQUZ4UHBWUUdXcEpVUlJtazRUVm4rY24vTHpvcWw5RlZlRWJOMU1CUVZv?=
 =?utf-8?B?RzEvVXgxODZTMWVVaDc3eUNNQWUwbWhuZDZmNWRCUWhMam5yVk94TGNRcmdy?=
 =?utf-8?B?R3pXYVlneTFFQkJtWnhUNXJSVlI1cDcrTGRyUm9lRzZyMXl6VG1nRWJOMkJM?=
 =?utf-8?B?Mk93Zk01cmdPUWY4Vkh3MGw5RTYvY0J1L0xRTW9LTGhMQ09LcTJuZUpJdlBD?=
 =?utf-8?B?ZzdVYy9LOFlDb0JhMERoZnBuZGhYMFk5SGhrWFlZbytQOExwVHhubXBWdGpz?=
 =?utf-8?B?TExvY1ZvSDNUaTBiclpDQmVoTTNZZEIwMGJVRkRnUmlsT2UzTzNmekVVcUQy?=
 =?utf-8?B?UnhEeFV4VXRMQ0pDc1pXMzl2VXVoWVdBWWMyRWFmY055cHRtSXdUNWpmUUNv?=
 =?utf-8?Q?+XN1CuQUcByHTbgQ=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bec4a3-bcf2-49ae-7627-08da32c1f9bf
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 20:16:32.8385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIJX4p2sgrHwgydeTb1Qq9jKUDIi1zjNgWEweiFV1/MPQ3yapooVvIyRxXUqgqBa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5103
X-Proofpoint-ORIG-GUID: EAdu39KBfiW2aW9R7ABb8LJrtkMbiNW6
X-Proofpoint-GUID: EAdu39KBfiW2aW9R7ABb8LJrtkMbiNW6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_06,2022-05-10_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/10/22 2:50 AM, Jan Kara wrote:
> Sorry for delayed reply. This has fallen through the cracks...
> 
> On Thu 28-04-22 13:16:19, Stefan Roesch wrote:
>> On 4/28/22 10:47 AM, Jan Kara wrote:
>>> On Tue 26-04-22 10:43:32, Stefan Roesch wrote:
>>>> This change adds support for async write throttling in the function
>>>> balance_dirty_pages(). So far if throttling was required, the code was
>>>> waiting synchronously as long as the writes were throttled. This change
>>>> introduces asynchronous throttling. Instead of waiting in the function
>>>> balance_dirty_pages(), the timeout is set in the task_struct field
>>>> bdp_pause. Once the timeout has expired, the writes are no longer
>>>> throttled.
>>>>
>>>> - Add a new parameter to the balance_dirty_pages() function
>>>>   - This allows the caller to pass in the nowait flag
>>>>   - When the nowait flag is specified, the code does not wait in
>>>>     balance_dirty_pages(), but instead stores the wait expiration in the
>>>>     new task_struct field bdp_pause.
>>>>
>>>> - The function balance_dirty_pages_ratelimited() resets the new values
>>>>   in the task_struct, once the timeout has expired
>>>>
>>>> This change is required to support write throttling for the async
>>>> buffered writes. While the writes are throttled, io_uring still can make
>>>> progress with processing other requests.
>>>>
>>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>>
>>> Maybe I miss something but I don't think this will throttle writers enough.
>>> For three reasons:
>>>
>>> 1) The calculated throttling pauses should accumulate for the task so that
>>> if we compute that say it takes 0.1s to write 100 pages and the task writes
>>> 300 pages, the delay adds up to 0.3s properly. Otherwise the task would not
>>> be throttled as long as we expect the writeback to take.
>>>
>>> 2) We must not allow the amount of dirty pages to exceed the dirty limit.
>>> That can easily lead to page reclaim getting into trouble reclaiming pages
>>> and thus machine stalls, oom kills etc. So if we are coming close to dirty
>>> limit and we cannot sleep, we must just fail the nowait write.
>>>
>>> 3) Even with above two problems fixed I suspect results will be suboptimal
>>> because balance_dirty_pages() heuristics assume they get called reasonably
>>> often and throttle writes so if amount of dirty pages is coming close to
>>> dirty limit, they think we are overestimating writeback speed and update
>>> throttling parameters accordingly. So if io_uring code does not throttle
>>> writers often enough, I think dirty throttling parameters will be jumping
>>> wildly resulting in poor behavior.
>>>
>>> So what I'd probably suggest is that if balance_dirty_pages() is called in
>>> "async" mode, we'd give tasks a pass until dirty_freerun_ceiling(). If
>>> balance_dirty_pages() decides the task needs to wait, we store the pause
>>> and bail all the way up into the place where we can sleep (io_uring code I
>>> assume), sleep there, and then continue doing write.
>>>
>>
>> Jan, thanks for the feedback. Are you suggesting to change the following
>> check in the function balance_dirty_pages():
>>
>>                 /*
>>                  * Throttle it only when the background writeback cannot
>>                  * catch-up. This avoids (excessively) small writeouts
>>                  * when the wb limits are ramping up in case of !strictlimit.
>>                  *
>>                  * In strictlimit case make decision based on the wb counters
>>                  * and limits. Small writeouts when the wb limits are ramping
>>                  * up are the price we consciously pay for strictlimit-ing.
>>                  *
>>                  * If memcg domain is in effect, @dirty should be under
>>                  * both global and memcg freerun ceilings.
>>                  */
>>                 if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
>>                     (!mdtc ||
>>                      m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
>>                         unsigned long intv;
>>                         unsigned long m_intv;
>>
>> to include if we are in async mode?
> 
> Actually no. This condition is the one that gives any task a free pass
> until dirty_freerun_ceiling(). So there's no need to do any modification
> for that. Sorry, I've probably formulated my suggestion in a bit confusing
> way.
> 
>> There is no direct way to return that the process should sleep. Instead
>> two new fields are introduced in the proc structure. These two fields are
>> then used in io_uring to determine if the writes for a task need to be
>> throttled.
>>
>> In case the writes need to be throttled, the writes are not issued, but
>> instead inserted on a wait queue. We cannot sleep in the general io_uring
>> code path as we still want to process other requests which are affected
>> by the throttling.
> 
> Probably you wanted to say "are not affected by the throttling" in the
> above.
> 

Yes, that's correct.

> I know that you're using fields in task_struct to propagate the delay info.
> But IMHO that is unnecessary (although I don't care too much). Instead we
> could factor out a variant of balance_dirty_pages() that returns 'pause' to
> sleep, 0 if no sleeping needed. Normal balance_dirty_pages() would use this
> for pause calculation, places wanting async throttling would only get the
> pause to sleep. So e.g. iomap_write_iter() would then check and if returned
> pause is > 0, it would abort the loop similary as we'd abort it for any
> other reason when NOWAIT write is aborted because we need to sleep. Iouring
> code then detects short write / EAGAIN and offloads the write to the
> workqueue where normal balance_dirty_pages() can sleep as needed.
> 
> This will make sure dirty limits are properly observed and we don't need
> that much special handling for it.
>

I like the idea of factoring out a function out balance_dirty_pages(), however

I see two challenges:
- the write operation has already completed at this point,
- so we can't really sleep on its completion in the io-worker in io-uring
- we don't know how long to sleep in io-uring

Currently balance_dirty_pages_ratelimited() is called at the end of the function
iomap_write_iter(). If the function balance_dirty_pages_ratelimited() would instead
be called at the beginning of the function iomap_write_iter() we could return -EAGAIN
and then complete it in the io-worker.

I'm not sure what the implications are of moving the function call to the beginning of
the function iomap_write_iter().
 
> 								Honza
