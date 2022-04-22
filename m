Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365F250C36A
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbiDVWpR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiDVWpJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:45:09 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56AA303838
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:39:10 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23ML6spX006159;
        Fri, 22 Apr 2022 14:39:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fViJuKz1oZUqU0bvaA7b8oQh2WIsje487OxCPtW7hfw=;
 b=OHC9cUtt1Hau5xkFhSr+zvLvmhZBMMfwV08hRufyjFKRs9kvwaCKPTajvzeqesIvIeAs
 eCna5ahfqGsBmAq7ihHkz0XHI1Itj0g9lclGYxYz2DYqkhL9odQW2JSWV1vznzAE1/YS
 SmwBse+9vyrEcUYA4gw62/hWe2IUxNzN8QU= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fjnsxhd76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 14:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPo3ojr9o+bGdSZV5eFbr8HFyjHbDmDOKZahe+As7+PKyyf8zWQRYBt5sBnrH5p0t2PBtLbgFyYVm2sqrhDDTqgPUAw5bgObNNsPGxCEYyQw+xvyKXjevxjklGyEInG9RKI5vSz7O6rogePrgfDauFXMInIf+mbfEgyIpRJubwuK03dr8vTprEywDIg+eKlPWslAz/OV1fTH8vg+jQh/r59m1psPxP5gqjZwnVnf5Af6ZZ7ydLFX25qS3okvkvkrEPTjMO58GIuiGKJEp3zTE5fEsicmJuc2P+6UY7/Tz5si57O1swA7cG2GbTTArPimJpXEDYHmMYuKRp4rK0nvZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fViJuKz1oZUqU0bvaA7b8oQh2WIsje487OxCPtW7hfw=;
 b=kT8WPve3Zw1XaOpCsPr6FAdMnf9Uwk5qsWio+4gGPHdmKTsSmbldj1gkwt1diW5ZUxxvzQBzCeqlv8iFtaz0zAaNTNzKRJUM5/RuyQVnxoFi6x8XKUu9Gabzh7nIgu9YTMCFGfh3rsmGjwJ9N2vGSnk2zUB9iGmEuZyijOxmeCiBkASbdfS7RruIs/V2Lfq4aWpzef+VTSCf7ClhcMuj1TGPa8GnwraOR4LiyK1KTW0uKM9KQruQJU3RCBCyZRmYlgpPT4A6X0AUIspNL+Yv+IMIaPd4eljnq8JH9HCG+FWiOkYW10rR4S81BzlNH04lTnsIculzC+xDHnxHpXqADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by SN6PR1501MB4095.namprd15.prod.outlook.com (2603:10b6:805:56::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 21:39:07 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 21:39:07 +0000
Message-ID: <655a0bc2-2999-09a8-5980-aa6378b9ac93@fb.com>
Date:   Fri, 22 Apr 2022 14:39:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2 05/12] io_uring: add CQE32 completion processing
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        Jens Axboe <axboe@kernel.dk>
References: <20220420191451.2904439-1-shr@fb.com>
 <20220420191451.2904439-6-shr@fb.com>
 <CA+1E3rLpz3FE76++pQK4rhHKN6xdhcF8YoUV_g+75rEwwj4OyA@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CA+1E3rLpz3FE76++pQK4rhHKN6xdhcF8YoUV_g+75rEwwj4OyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0064.namprd08.prod.outlook.com
 (2603:10b6:a03:117::41) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 056e5a72-1a5d-4dc7-d409-08da24a88797
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4095:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB4095CFA2815E92350F23C379D8F79@SN6PR1501MB4095.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZK11ivtMM3/u94dl0N69JeV5qVvltyuEeFptswPBHsiiSp30VGOc0J+moblDh76mqJrxLRAY//KVLQ2HbcWmOAF2yMMgYDAOirPrOK0iFAviOR9k9xjbgYwRpkzV+tF/TzKzYbYyD0t1VWzU/QGEHNOay45uXrNDzyQLOl0HPjPSzakp3jYaQVwng4MrmF90fmACCbRk6SCg36SMS/rVF2UplvGaeWi2LaoZzm8/IUS/vf920K6QZx6K4P7I0OUHzkM+NAwnbHmp+VaAX+fkuzGLE8T9sjx8UvYHYGeTYFqVEmfyymyWlahYlO71PaYTFpKJCzwQq/OX4AArjYfsuB72dV2L8KgRZu9GSaBbUTicBzq1SsQZjSbDLJ8TLLAb+RU3+UnnBLPCTvxes+ZJtNiM/vX7MALUxncMwST/UbKxHSvuzIId364N52OK7yzYOd3sBvwdsZ1RGH1Wf3Ygsm4KmsB5DoIAexXLffI5V/AaBc91+Yp3LC8O/05Eu2NGbrgiFD3h1PrF9SJ+j1mcjnf48PLSMsNUWVej5oR9YSEvVX8HaNI1ExW96uVNbMltAVnnNHHqYL2rEMJV/8PjQn+rl+N6MZMZ/GH5TAUpnZ4kr0UeWb70rGEtXWvaZAJNF+Y0eDug1N1rfY74F+KJrJpwTdOCEnj4wS9FReGgwVpdL9+xMrsjeAUgmnn5Gk/awx80PzaUVtwN3GaCE3WyGhn10wR4ijr6ybZf+IhQ78k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(2906002)(31696002)(6506007)(6512007)(86362001)(2616005)(83380400001)(38100700002)(186003)(36756003)(5660300002)(66556008)(66946007)(6916009)(66476007)(316002)(4326008)(8676002)(6486002)(31686004)(508600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWxWTElCMUkvYXpRYzFpZUJRbmE3TGxHRDJyQ285bHNLcklCcGZsK3kxVXRr?=
 =?utf-8?B?bVIvWGFPVGo2aDV0UzR2bXZsajVvTjFBL1dscGpJSXR5aXd2aVFTR0ZHNngz?=
 =?utf-8?B?Q3RkRnQ4Z1B4cmNML1hET2JGeUlwYnhMdXZQbTR3aElFVnhaZ21Deld4dkx5?=
 =?utf-8?B?cW95cDJMRFc5aHVzS0h1Y1lXcnBtVlNOZ1g2di9UcHhSWGpqV1FpYjVPQWl1?=
 =?utf-8?B?Z3RMVy8wR0lRa2szVFFJZ05Sb3hmalFXMlhiTWF2eHJlOUl6N0ZBVnl6L0ZZ?=
 =?utf-8?B?dTB0OXVIc3R3UFRScjA3aENYWEVWR2dRMWlNTE1SSkRrTFk3eU9mdFZzUGUr?=
 =?utf-8?B?dnpKb0x6bDUwcVlEdFNUbzJCSzVCWHY4U1ZnejBtWWhHTWgzald5bk8zcXp1?=
 =?utf-8?B?K3hueUtIb1pYeXViT2FOdVVId2lmTG1ET2hXV0dPWXJtTXZ5NlpmdGJNR0Yy?=
 =?utf-8?B?VHBUVHlERGdDcnRRQUwrUmdGMEFVYkFKZjVSejhQb0hjWm14QUJpYlI4bnFW?=
 =?utf-8?B?RGhxaUpPNWdOeXgzNUxVZGJsZ3BxdVU5QWlVOVR6UDBkZURHTjFINVpaOGla?=
 =?utf-8?B?VXZsQ0RyUGxMQlZ1MkpJMWRLNEt1U0lFWlN6aDE5cVRQVjRnZENyYjY1aFBE?=
 =?utf-8?B?ektMb25hcTdUUmRLWHI5RXRpQVNnd2ZlaVo5eDZNR3JEYnBwQ1BiQzRFRHpp?=
 =?utf-8?B?SU5VbXROYVVtNnJTem5RZldGQ05Yd3gzOUM5aEl4N3JLeVhmM2IrUWxrVHRO?=
 =?utf-8?B?SVB3Q0JEQ3hlQWFyaE1SVk9abGkzZjRXT1dUdHI2aTRhSENqb3Y0TWQvK0d3?=
 =?utf-8?B?eEZoL1lQeHBpVHY1TWx1cFhiTlEyT0o4eEF4eTRFcjNmcFVYcmYrR255RXVj?=
 =?utf-8?B?RnhLdnQ1ZGdQVENiV2xTNWRoZ2U4T2dRUFRkQnA1bFJOQnJLMmhsSFlHZjdN?=
 =?utf-8?B?MGoxOUVhUVB2cWQ4ekFrVGN2U3hyc1RvWjlOYWhLaUFNdlRiOGRuRHZHTS9p?=
 =?utf-8?B?Nk0zKzF0NHZNRmdpVXJPYXNGSzlUTXJtMk5YN0pYSFpXM1ZEdUNnY25UQTlw?=
 =?utf-8?B?R1ZyNzdXbExVVGhyVFpyYkp6a3U2alM2d29JSkp0ekVMN2hpWGdGWnBGZEJI?=
 =?utf-8?B?Vkt1b1FjU09ENFBGK3VPUHhJM3pFcHQzY2VqdUJmV3E3cU9xLzhQd2wrMTc1?=
 =?utf-8?B?Q1Q4a0Q2a1FVY1c5ZldTK2g1RjZyenNmamhiTW4zQ2VnMjVWb3JEYmVXZU8r?=
 =?utf-8?B?TlJicXZzV2tMbERxOWlHemFZclBoOGNvdEY2T1g2ZzdJdmcyMU1SWnZqY0dh?=
 =?utf-8?B?ajAwU1NmcVRHS3FrRURyclVpRXdzaVl3N0ZUQWUvS1RDYkU5aFZoSy9lM1JK?=
 =?utf-8?B?QWNwc2oxclVETHIrZm41NEQvd1ltYWtld0VUdHd1TGhtWWVUamNmTzFpMk9H?=
 =?utf-8?B?VlJSOFd4M29jTm9KNDZSY0s2TUtCc2lGeWZSMlQ5eU1MTm5oL2RwUWJjVSto?=
 =?utf-8?B?VG9RYXo4SExZQVNZSFN5V05IZWJnNkgzUUpBR3ZtakFNOGdHU0doay9iSkds?=
 =?utf-8?B?N0JJUW9kbWNpZ2Y1R3JJYWxvOGJyNExtMW90alE2S1BzdnBFeVBHcFhHMVEz?=
 =?utf-8?B?eWk5SkVUaUJFQjQ1SVAxV0oyTlpBRmxsMDZMMUJ4Y2VLdEIweTYyZVlVNy9T?=
 =?utf-8?B?eC9jdnlBcGEvQ1RhZ3NBK1Judk11dTV1NW1YY2VRSVZ0b0RRU3N5NTBUQStn?=
 =?utf-8?B?VVU0Wi9rTHBPWDdWVjlVdTVjeWhiaktXd3cwbUNocEQ3VUtBUFpIWXJVQU8w?=
 =?utf-8?B?YlBIMnp0bWYyQVkxYThTd2VHcFZ3a3RqUEFKMHpYSmxobnFHRENNSmhxM3g2?=
 =?utf-8?B?OCt0ckFpYXl3UWFUbGsrK2I2WlFRU2JScDJVS0VKeVFabEZGU3krOXkzMVBR?=
 =?utf-8?B?NG1IODd3TWhtUjRVNWxxNFFzQXJLdDdwL0JMMkpjZ3BBVDlGNVF3ZGJ0ZVJL?=
 =?utf-8?B?MVJ4dGlXa3h1NHNYZ3dncXlBTG1veCs5WGQzNUtFeXdBZys5QnJ4VHdvUGVL?=
 =?utf-8?B?dWtuSHkrUnhEWTdBbmszVlIrOHBNQWV4WVF3eUJ0bWdmRzdXNjRlbjlQOTBH?=
 =?utf-8?B?cUVqcUVVZXBKbmNqVUNkeEVhekhQaGFYdERSVkhqcDVIbDBrajJ3a2tQOUJU?=
 =?utf-8?B?QkZkT0JNdzBJQUh6UjJ1bWVXK3dYMFliMU1PMXpZaE5QMTJmSzdYVjZYYjRX?=
 =?utf-8?B?TzJmdFlrY2JFaWhINWVpaXZjRzB1amQ1cTNPNkMyMFVPSEtqcW50ejRJWklV?=
 =?utf-8?B?MjdybEI0bTZGMXA4YzN6Y0E0MzFMaDFHYmRwV3Avdmd3RDl4aVB6aTY4WThn?=
 =?utf-8?Q?wQZq8sQctUpeOX6g=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056e5a72-1a5d-4dc7-d409-08da24a88797
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 21:39:07.5732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkiQd5530znJrHPQFEvfv+5uAGzwr0LQhOkGn4cDxP8q6V2MYd84HMVd/7k+7JC+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4095
X-Proofpoint-GUID: n8VgLRJ4MucuC2AGlUnvtDxBfCnRrFvq
X-Proofpoint-ORIG-GUID: n8VgLRJ4MucuC2AGlUnvtDxBfCnRrFvq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_06,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/21/22 6:34 PM, Kanchan Joshi wrote:
> On Thu, Apr 21, 2022 at 10:44 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds the completion processing for the large CQE's and makes sure
>> that the extra1 and extra2 fields are passed through.
>>
>> Co-developed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 55 +++++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 47 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index abbd2efbe255..c93a9353c88d 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2247,18 +2247,15 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
>>         return __io_fill_cqe(ctx, user_data, res, cflags);
>>  }
>>
>> -static void __io_req_complete_post(struct io_kiocb *req, s32 res,
>> -                                  u32 cflags)
>> +static void __io_req_complete_put(struct io_kiocb *req)
>>  {
>> -       struct io_ring_ctx *ctx = req->ctx;
>> -
>> -       if (!(req->flags & REQ_F_CQE_SKIP))
>> -               __io_fill_cqe_req(req, res, cflags);
>>         /*
>>          * If we're the last reference to this request, add to our locked
>>          * free_list cache.
>>          */
>>         if (req_ref_put_and_test(req)) {
>> +               struct io_ring_ctx *ctx = req->ctx;
>> +
>>                 if (req->flags & IO_REQ_LINK_FLAGS) {
>>                         if (req->flags & IO_DISARM_MASK)
>>                                 io_disarm_next(req);
>> @@ -2281,8 +2278,23 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
>>         }
>>  }
>>
>> -static void io_req_complete_post(struct io_kiocb *req, s32 res,
>> -                                u32 cflags)
>> +static void __io_req_complete_post(struct io_kiocb *req, s32 res,
>> +                                  u32 cflags)
>> +{
>> +       if (!(req->flags & REQ_F_CQE_SKIP))
>> +               __io_fill_cqe_req(req, res, cflags);
>> +       __io_req_complete_put(req);
>> +}
>> +
>> +static void __io_req_complete_post32(struct io_kiocb *req, s32 res,
>> +                                  u32 cflags, u64 extra1, u64 extra2)
>> +{
>> +       if (!(req->flags & REQ_F_CQE_SKIP))
>> +               __io_fill_cqe32_req(req, res, cflags, extra1, extra2);
>> +       __io_req_complete_put(req);
>> +}
>> +
>> +static void io_req_complete_post(struct io_kiocb *req, s32 res, u32 cflags)
>>  {
>>         struct io_ring_ctx *ctx = req->ctx;
>>
>> @@ -2293,6 +2305,18 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
>>         io_cqring_ev_posted(ctx);
>>  }
>>
>> +static void io_req_complete_post32(struct io_kiocb *req, s32 res,
>> +                                  u32 cflags, u64 extra1, u64 extra2)
>> +{
>> +       struct io_ring_ctx *ctx = req->ctx;
>> +
>> +       spin_lock(&ctx->completion_lock);
>> +       __io_req_complete_post32(req, res, cflags, extra1, extra2);
>> +       io_commit_cqring(ctx);
>> +       spin_unlock(&ctx->completion_lock);
>> +       io_cqring_ev_posted(ctx);
>> +}
>> +
>>  static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
>>                                          u32 cflags)
>>  {
>> @@ -2310,6 +2334,21 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
>>                 io_req_complete_post(req, res, cflags);
>>  }
>>
>> +static inline void __io_req_complete32(struct io_kiocb *req,
>> +                                      unsigned int issue_flags, s32 res,
>> +                                      u32 cflags, u64 extra1, u64 extra2)
>> +{
>> +       if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>> +               req->cqe.res = res;
>> +               req->cqe.flags = cflags;
>> +               req->extra1 = extra1;
>> +               req->extra2 = extra2;
>> +               req->flags |= REQ_F_COMPLETE_INLINE;
> 
> nit: we can use the existing helper (io_req_complete_state) to
> populate these fields rather than open-coding.

V3 will have that change.

