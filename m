Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1A9513C8D
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 22:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbiD1UTr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 16:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351728AbiD1UTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 16:19:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083654E3B7;
        Thu, 28 Apr 2022 13:16:29 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJfju0011848;
        Thu, 28 Apr 2022 13:16:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0OXiKz1x5Re2dGO9Q6QQFqqrTqaRL52mjx9+n0SNEKA=;
 b=iXi32aLbAUfEHj6Q5MKhmhkp8J00yXDV8XmKrnh3a0Xn1ZhJwDW4gYaPJLsT2HG9/vQL
 gMikuTUvohYTGYWAKLFkyc9tpwbgLGDMXbgT9a/7VkdyUBSzLQN/4ubCayipSnKAXeLn
 XAFtXV28zkd70rQzXIvVNzx3nBpMfVu5koA= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fqkdjdrt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:16:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=St/j5FzGKXuAJyA6HGQZNKpROnX5F+7R9Nd0RoIB1DDlGVRfoKXpwNvOhPYg4j1lBR2spvVOnEnWy0aiyuLeXK7jSTut5uyGJz8PtU3vW6FGI1AmzqttWSnO+HDO0FaJoDp3nRvj2+gOc3AMrpGzXR+3jZsBynWkD23xj/bLXAdP3N8p7HSHFY8g06iwuMrhFpJSXJ7x/918RZaIJ3fVhuFNJPIGvqOhNC+G0miUn1mmSMIltqY/1FdXEGat6f4j/Lb/KggfkvHgTjILoF7zEJFvrRWL4JKadeRRnvGHBEO4cUrARsQ8C3kp4SGJKNAtlsQ89/8OqPIOUuLSB0Glqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OXiKz1x5Re2dGO9Q6QQFqqrTqaRL52mjx9+n0SNEKA=;
 b=Hufav0hRxfNbMFw6wCYjx3npvMIHhNix5/zXoWkFs7x9N58Ud5YD+byXRB67LY7GqvFbXcZVyLlca9TCOn4gTYxza4+E842kDcfSWMwucvKPUX1LPM/vyDAHKDcP5/4WulRIwqxlv/xc+jjk5ggOMO4fECPJ3l1Wc4ilMMYQo4dFnuOMGfgZGwe5v5uEekavyvZovBluk/2sTi7wBBf6KHuS44+DFMqesqsmlePfz/mLiRPzHuUvtyA3Y4LRCtQ8jSTL8M4VZRH3QplUFRFBDPlvEeS/ZTFrTSzr9q9HCGu5DQDBRULO05kM8q9vc26XVPeSQ4jjmZf4yjngKbTgCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by SA0PR15MB3773.namprd15.prod.outlook.com (2603:10b6:806:81::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Thu, 28 Apr
 2022 20:16:22 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::687a:3f7e:150b:1091%7]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 20:16:22 +0000
Message-ID: <88879649-57db-5102-1bed-66f610d13317@fb.com>
Date:   Thu, 28 Apr 2022 13:16:19 -0700
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
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220428174736.mgadsxfuiwmoxrzx@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:a03:333::20) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cc96688-0f23-49a5-1590-08da2953f663
X-MS-TrafficTypeDiagnostic: SA0PR15MB3773:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3773F90A9501D8FC8AB77DC2D8FD9@SA0PR15MB3773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpmIvep5foLUYloDTKD8QSOurQ/a9/Ji/lOQiyBlBlRAVFEF8P+31Rawt6CTA+aMAgtEItthOE624rGs1L56vmzyHq3ftQvhGoJ68yO5FDayfzXLe96+eGVicOj1q7wDODUdZIjqGQCXhy5SdKMOvxcqnE5SxgJyUSLe9TVX1xksBxsmpmlb0jPP41jcMWxmQK/OFFGJAHgFmoA1/JlEQygjOTXjPcnvdyRUlz5/bzoOhx36HETxPDhyjttQm7SkNPGNGEuytJQabDtqEMtsYq/7OQFB2zfHE02EwdMJgA5QK1O0KQfpQt+//K8kno44TE1s2imndl4rNG8goev0FaD2BoImOq6MjxVxfDoxWvu0lI/IHJqr76D6G/JhnTifK6AdsNLNPC7OlYIXlwi1Z5w0CMDYlVaEexPEzoRV5dAWQ76v2O0XBtkgNmxkVkkqT48zBKZ/28RKqfColsd2R3plTSRx2r5Fz/z9nvtF4SeA25ePMcJojr02dStcXjNk5332BBuKQ5AaeMkw5WMOej7Jbvc1vTBIELFXMViriibZuGQNmHP1Bjb9YIRcET9Gdxr31xpmUXDjMSWi0NpAHE0lVb1euSUJ+uVyiowLFcZL1ui1pOmkVIDbMpTyKbCkVyL8j1KIm/fqxIx9wIrM4cBTb/nZvbPdFJO9w77UhRNNIqWp8q4pWl2/VtidBNm1BDrhnnlcndR1/kCBLjnnta13JYNDvYcG9UV3YTZz6QM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(6486002)(6666004)(508600001)(186003)(38100700002)(83380400001)(31696002)(53546011)(6916009)(86362001)(2906002)(2616005)(8936002)(36756003)(31686004)(66556008)(66476007)(8676002)(66946007)(4326008)(5660300002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkxpUktOMUQwbkxYWkNvUWVDTTZ5OWZCWnR3Y2xYRkIvYzg1Wm55S1ZML1Yx?=
 =?utf-8?B?Y3h3SENHaVBuTEJKOEpsUTlld3JZQU5yV21JVy9uTkpseXdLMDJlQXpQdVMw?=
 =?utf-8?B?Nkdsc1dzdFZrMktkYWNNUkRyUHY2ejV0TC8xV0xFRzB3MVF2clJTMzhoQUtI?=
 =?utf-8?B?Zy90WjQxYWhWNzNDSFJVSTdYRldSajduV005SWxIWmdZMk1nUE5ENEdvTmYy?=
 =?utf-8?B?akJkREh6NUU1STFzK3dqYkozalNVZW5qNzNNemtwcnpvRm12dXNnQkpDc2ht?=
 =?utf-8?B?UE1DeStzOTUyYkpjaDVwZmg5MW5xSDFiaWY2bW5Dc1JsbkF0dUx1TUE0UUFO?=
 =?utf-8?B?bUNENElDZU5kUXJCV2RIK2JwU05KQVkxU3NuUVE2RXpoc0graTF5QnFjL1lP?=
 =?utf-8?B?WnM3VlQ5Y2xrd1VqRzdLc04wM2NxUXQxajQrSXpnQnNWWFNWQ2QySHVsN2w3?=
 =?utf-8?B?bnNMODJ3WndRUmhwM2syWXZ4QWkzRTNRYklLMU00MmtVNmdLcndMYXU4czJs?=
 =?utf-8?B?NytkNkZwNkFFV3huVy9uUTZEMmlxVTdmUFh3bVJmRk05RFA2emhJbDJZRzk4?=
 =?utf-8?B?L2NkS05iQUdGRi83NnZvd2J2dDBCUXJINGpwekVTZmlXMmV2YzdSTGYzNWNH?=
 =?utf-8?B?ZnJ0VktPVG9vRjBxK0ZXK1lRVVVqNkZaNXppQ1lrVTlENzhUWFpkTnpHMmRD?=
 =?utf-8?B?aDBzUmJsd090dXVra3A0cThRZ1FSYm1SYmduTzQ0cTFaeks3TkJBdlJYdTBK?=
 =?utf-8?B?aGRSK0laRGJobkZqTVB1V3BPSDFWMy90ZHJJL1VQako2QWV6ZUMycEhuSzhH?=
 =?utf-8?B?YThJbUFQdmdEcHNtbjcvd1lRM05iNXVGS1RzNXp1bEFrWXE5QTR5TzFwSitl?=
 =?utf-8?B?MWJmRTRwWk85ZmhlL2R1YW1zZWR2cVU4dUZYbDMzU0RaZ2pNSTBWZW10bWZW?=
 =?utf-8?B?UGc4WUxZcWxRbXBhaytRTVNNVG55bkJXZDJtNk9Ib0xzbjlHbk9XMmxYVWN5?=
 =?utf-8?B?ZlFxL1lORHM0a24rTjlNWGRLNFR6OHNoQmdmSGQ3YUh0dUp2LzhIYkNCci96?=
 =?utf-8?B?ei9xYUw3SUpabUdmR3Q2OUxCQm9vSkZwbVBxZExxN2liVG81UzFVbERwVzFJ?=
 =?utf-8?B?TW01aHVUWFhPNGNuNWd0RDVpRUttaW92Y0laZWp1M3ZkZURWeHY4TU50YnRn?=
 =?utf-8?B?ZXFUWG9TMVFiTWNGNmtqaWk0WURMbUQrTWFyT1BzYUc0YVNaWjhQVEUySktY?=
 =?utf-8?B?anhXUmVRS3hHcGZPbWxlYUhHTStFSXhqRlJ2c0tudG80MzNEa1V5NUljSUFR?=
 =?utf-8?B?dU9GaHRlZ0grT3pFWnR4WDlqV1d0T1ZINy81YkxZcGZDbkxDV1lmRGNoUGQ3?=
 =?utf-8?B?S3BsUHg4ZkkzdjJQdlhOUEI4R0NpVXduTTYxQTRVRFFDNmlWR1JIY3k3cUhr?=
 =?utf-8?B?TW5rVEZ3bWVIdXU1aldpVWQ1OE5OK3dMVWwvWWVoR0l3eWdaSzFzUmM1WFlL?=
 =?utf-8?B?d2pjWFJ5aUNEODlhL2JCVE9DKzRxWm8vYVZDRWY1cEh3QXJWNWJvZVgyV0Ru?=
 =?utf-8?B?YWY1TzBFNktUbWkwb1FDR0NnYWtEOXI3OU9OK1JuQUFoSG5nYVZ5cUFGVU1N?=
 =?utf-8?B?eTlaSHR6UTRwam9DWjhCMFRnb0ZIYjNkUGZIckVzMDBRWnhZSmlSYzNDcFE4?=
 =?utf-8?B?aDFoMFZXd292WCtKY0VBNGNCREFDUi8rOGRmMnNvbmVsYzY4SUYwM2NpRWtu?=
 =?utf-8?B?SG5YSjFya2I3dUpENkk4UGE1ZURsTS91dzd2VXl3cUJ5KzQ2ZWlhczExWjNl?=
 =?utf-8?B?ZjBUOXNJS2VvK0hpN1RwbnE3OHVvODZTcTd5Njl6TlNMT3JwSHgyTEszbEx1?=
 =?utf-8?B?S0tHWVNEcEp6bGhoejY4Nmo4R1M1OVl1NDZrQ2t4alFjMzVVV3JBS0h3M04r?=
 =?utf-8?B?SnNOUTFLVy8ybGgycmIzSkxqSUlTckxLSHVvQjZYOVVZbTR0YnpLd1R3Rk45?=
 =?utf-8?B?RVZuSklkNC9uSVNGdGFaWDFuL1kyTGJLazFCMDRXc0VTM3JLTlJsUzMzanAy?=
 =?utf-8?B?YmRReVQ2cFBaNHVMcllHSHpYYmplU0FFNm4zUHVqb2hKU3lqb1UwMnpVeG5X?=
 =?utf-8?B?S2xFWXVzQ0NWZGlpUEV1WCtkRGFBUDJYRmxHSFBYZEtiUlhKMnk2N0ZNYTZZ?=
 =?utf-8?B?b0hjUlFSYW9qYzVjMUxSWmNaUkh5bWtIYUZ0Q280M0VBY1RxMnpIYjlpQXlC?=
 =?utf-8?B?ZjhTdThiWjFQZGRpSWhOL3JuNklSRmRzVlhZM2xSa0VGYnI4d0QvbWNMK2Rh?=
 =?utf-8?B?ai9pazhNVlBlS2hEc0pUM3pPbTZROEtzUUN0cG43SWVtWFBIV1dEcC8wRk9n?=
 =?utf-8?Q?hOyOC3xdElo4dDY8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc96688-0f23-49a5-1590-08da2953f663
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 20:16:22.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNOrVJK8HNVRCslc/wa0Ul92EidOScPf7EyyBbgv4vAEKeBJxuwxtZY3Z/ZQjR4L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3773
X-Proofpoint-ORIG-GUID: ynp508MhlQ9OVMKXBV6LXoVZZb0GHYkT
X-Proofpoint-GUID: ynp508MhlQ9OVMKXBV6LXoVZZb0GHYkT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_04,2022-04-28_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/28/22 10:47 AM, Jan Kara wrote:
> On Tue 26-04-22 10:43:32, Stefan Roesch wrote:
>> This change adds support for async write throttling in the function
>> balance_dirty_pages(). So far if throttling was required, the code was
>> waiting synchronously as long as the writes were throttled. This change
>> introduces asynchronous throttling. Instead of waiting in the function
>> balance_dirty_pages(), the timeout is set in the task_struct field
>> bdp_pause. Once the timeout has expired, the writes are no longer
>> throttled.
>>
>> - Add a new parameter to the balance_dirty_pages() function
>>   - This allows the caller to pass in the nowait flag
>>   - When the nowait flag is specified, the code does not wait in
>>     balance_dirty_pages(), but instead stores the wait expiration in the
>>     new task_struct field bdp_pause.
>>
>> - The function balance_dirty_pages_ratelimited() resets the new values
>>   in the task_struct, once the timeout has expired
>>
>> This change is required to support write throttling for the async
>> buffered writes. While the writes are throttled, io_uring still can make
>> progress with processing other requests.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
> 
> Maybe I miss something but I don't think this will throttle writers enough.
> For three reasons:
> 
> 1) The calculated throttling pauses should accumulate for the task so that
> if we compute that say it takes 0.1s to write 100 pages and the task writes
> 300 pages, the delay adds up to 0.3s properly. Otherwise the task would not
> be throttled as long as we expect the writeback to take.
> 
> 2) We must not allow the amount of dirty pages to exceed the dirty limit.
> That can easily lead to page reclaim getting into trouble reclaiming pages
> and thus machine stalls, oom kills etc. So if we are coming close to dirty
> limit and we cannot sleep, we must just fail the nowait write.
> 
> 3) Even with above two problems fixed I suspect results will be suboptimal
> because balance_dirty_pages() heuristics assume they get called reasonably
> often and throttle writes so if amount of dirty pages is coming close to
> dirty limit, they think we are overestimating writeback speed and update
> throttling parameters accordingly. So if io_uring code does not throttle
> writers often enough, I think dirty throttling parameters will be jumping
> wildly resulting in poor behavior.
> 
> So what I'd probably suggest is that if balance_dirty_pages() is called in
> "async" mode, we'd give tasks a pass until dirty_freerun_ceiling(). If
> balance_dirty_pages() decides the task needs to wait, we store the pause
> and bail all the way up into the place where we can sleep (io_uring code I
> assume), sleep there, and then continue doing write.
> 

Jan, thanks for the feedback. Are you suggesting to change the following check
in the function balance_dirty_pages():

                /*
                 * Throttle it only when the background writeback cannot
                 * catch-up. This avoids (excessively) small writeouts
                 * when the wb limits are ramping up in case of !strictlimit.
                 *
                 * In strictlimit case make decision based on the wb counters
                 * and limits. Small writeouts when the wb limits are ramping
                 * up are the price we consciously pay for strictlimit-ing.
                 *
                 * If memcg domain is in effect, @dirty should be under
                 * both global and memcg freerun ceilings.
                 */
                if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
                    (!mdtc ||
                     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
                        unsigned long intv;
                        unsigned long m_intv;

to include if we are in async mode?


There is no direct way to return that the process should sleep. Instead two new
fields are introduced in the proc structure. These two fields are then used in
io_uring to determine if the writes for a task need to be throttled.

In case the writes need to be throttled, the writes are not issued, but instead
inserted on a wait queue. We cannot sleep in the general io_uring code path as
we still want to process other requests which are affected by the throttling.


> 								Honza
> 
