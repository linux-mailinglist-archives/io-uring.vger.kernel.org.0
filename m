Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1968C50C379
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiDVWfF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiDVWe2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:34:28 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7491E5797
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:27:07 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23ML6tQc023325;
        Fri, 22 Apr 2022 14:27:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gxKKMooLjiTYOHnSmJL0m2yCK0cKjDIr1EnwPUMJs6I=;
 b=nIPegZMEYrv1iaDPIZ/O4Mpvu8xlbPV7V+qpV5UUwo4OJjHKexRUJIehs9ThWPlanwOP
 BqQYir45kAgwjqmbeVUglEsPxuYlo7EtmfXcD8B3N3lrmfDIXXEQCInO/SvsFXMgph0d
 utSMsUUqjz+TW1NAna3dvPApCrWpUxm4AXc= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkpcmne04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 14:27:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpS8n4VtQlCo17DNlWUIPyCwO4FIo5wHXjzMdnUA4twkjub38FCf7l8YmVCGTshySHJGZ3D5/uQ4y2ttc/Nr7j+jDV+QAOxRC5m2CDxPdxDKUAFC2+Fzw8M/4naUtiTnrTfFnc4/QC5/D66slczeG8m95jYh9+crFW0bzQu/YoII+uD4esttQPfosD3asTSPvcnG4nlgvzXG5Cidu3n8HCpiuwFpw6uuHaljFu48jwdDBwOERea7a5FzAN26cOv0sKqf89QEfTTkf+L7fwteEGjM44Tst2s3NSt0AlD1JPuRYRwLIat0dn8MPc+Ze/Gz6lEMEn01w9nx6FeghnAS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxKKMooLjiTYOHnSmJL0m2yCK0cKjDIr1EnwPUMJs6I=;
 b=SpsxVpM9hDK2B31UYKwNyrSlrUX0iutHEg1cJ7o356dDBNhXj3YwEG8BTh3xLWRYQzHCpCKkVILFYqiTsUWOX1ejCNYIIu9SXammAo8Rd94eei1061zaNDuDCESGf4qY6CY4lYQvFWyKaqma0/xnQxa8MsZp+Ed3SHUZ+Uc44JerWQBdWNbcHGogdxwQZYTEGEDNZxbiDsPOI7KEnAiOwe6KwvPcu9ZiOrhPKs8nfaKZLRKmyFrRa914RRfsJwbXph9f1TQOdY18SwdneUckaO7D8hRCW1TzDgGiCq8LcTZtqsJCd3agyCuaXHIqVk63d+7GqZVh0ImKwC9c0GOywA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB2920.namprd15.prod.outlook.com (2603:10b6:a03:b5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 21:27:03 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 21:27:03 +0000
Message-ID: <697c47a4-aa6c-a4e9-c2b5-5759399b9546@fb.com>
Date:   Fri, 22 Apr 2022 14:27:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2 08/12] io_uring: overflow processing for CQE32
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        Jens Axboe <axboe@kernel.dk>
References: <20220420191451.2904439-1-shr@fb.com>
 <20220420191451.2904439-9-shr@fb.com>
 <CA+1E3rJVJKEjmhLzdKYjKB3UgLs334hWXaDNUN2xp92E+XR=ag@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CA+1E3rJVJKEjmhLzdKYjKB3UgLs334hWXaDNUN2xp92E+XR=ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0117.namprd05.prod.outlook.com
 (2603:10b6:a03:334::32) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2704d871-5ff2-4769-c2c6-08da24a6d807
X-MS-TrafficTypeDiagnostic: BYAPR15MB2920:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2920EBAF43B2D8E18529A7CAD8F79@BYAPR15MB2920.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soIcd7RiNGzElouJGYPQw1nhQrs4ncjTnXRtVPIVPPuiXeqNvaZtICF2SzQ3ltZKo/3Nz+gj0HlKWagt9mmlXVDj3LVHnGpllRZaxLEJBgt2uF3D3BhHsCW7KgJAP48fbLPnRZ4iV4ZT58c67WW4DV5/5xeem9eD2lmuzQv5PSSgYflZ/xXXZG8+WNoWvCi3ELHgw/8fLZaVB2q+RIIiwCFF7unNyXxw86CkNa8eSHVyMXzYz/JdidH18miaLeFcoTWceKBGU/cW8R6Qm6TiTn9pZ4WhveLj1l6kHXGNwvrqhb47Xs+SCxPa+hNRSQQ78TbyrHzCEYDCuwlWY8vVEW0JiAeUp84mjX9FqQfTM9S5Kz+h47Cltqiipd/c0CHxuchJZ8URV6Ozaerhz07FCV19NUDdlSOQLwNE/7S44LxfkTjy0KhmfWcUZwPCYfoClDKSysvakubisOlWWnWx6/bUHYULgupOhBEPP3tu8pEdaM8q0AHht1rzOlwl/edfl7PyD0/ovcBpcVaIPZVZLx0ii3EXF+ahbGFgrLEmUJEpO9bcIP/mhwWvWqRohepJz/Lg25kFEbylvtHLPX5wuVyeQExzWhQbNQYH58I0giS0yKxkPxzWxblY/78T6pD/TGfYiTvsj1jioeEONJwTtkrtGMgOieYrYOzJ1C18VreroS1sFRv4qyko9rR0JPcNx/Cs/y1v0UDCICGUQj3HL5Bi5ZewyCDLJs2vaW+rzAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(66556008)(83380400001)(66476007)(6486002)(36756003)(2906002)(316002)(6916009)(508600001)(31686004)(38100700002)(86362001)(4326008)(8936002)(8676002)(186003)(6506007)(2616005)(66946007)(6512007)(53546011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXNPWUo0MXVHYzNrOWxVcEVsdEdXQnoyaUMvQ0F1T3B3Wkh1bkNzUmhVdDRR?=
 =?utf-8?B?eTMrQWJCUFRHK2xnV29HSDRjYVNLWjRBdTlSWDdaQi90OWJ5V2p1M3VsSWt3?=
 =?utf-8?B?QkZkZmp6OTF4d0RPWFhoUmM5czYvS3lmSklOQnBlUzdpamdMMEZjVHhNZXZ6?=
 =?utf-8?B?UjdFQ24wWXhKY0FHZW9WemhQYkFNbVFqTkRiaExRNk9ibjFBRkZKdS9iSFlp?=
 =?utf-8?B?SHhpSjRtTmVVTTc1Nm10czNBZU9UKzJkQUphZzNlTG8vWkMyaVM0clliRGFJ?=
 =?utf-8?B?RDlyRjVORk1oNDlRbjVSd1p2QzBxUmt5VUNwamt0ZE1wY1hrSXc0cjZlVXQ4?=
 =?utf-8?B?WEpMa3FtMWE3dHE2VElUdXVjM3ZVb2pKSkhnbzA3dTk2WEhVV3NkNit0S2J6?=
 =?utf-8?B?Yy9GWmJpbTJJM0thZktEVENzY0RMdkxKcWpjSkpKaHNzT21ucmMzR1FvQU1m?=
 =?utf-8?B?dS9Cc1Q0N05mNHFacmJOSXFKMUFxS1ppU3prbU9EQzBQMDdtV3d2cWNpVm10?=
 =?utf-8?B?U09JMlJ5ZXJDUkRndmoybmFTTi84bW1JdkMxeTh3ZTg1cjdDM1ZQZHFCenEv?=
 =?utf-8?B?ZnJObnBiSWtnRHZiOStFS0E4YzErWjVuZFlVK2xCRDJUVUpIcmU5RDZGeXBq?=
 =?utf-8?B?dDhINENiOHE2V2hCZGdCVlJHVFN0OUxXMFZ6em9hYWlreHdEc2VrOFFKNFk4?=
 =?utf-8?B?dlozWHgxaG95RmVvc3UwejV2WG1xV2g1a1hSaFdXaGhYM2JsdnovUzQxVE42?=
 =?utf-8?B?d1k1WDNOcDRDRGNZYXIzNS94bDNYVzBndFdxL25nSXJIb1hkRWVMQnpaZlJI?=
 =?utf-8?B?TE9wcjZnSldTeUdlTjQ5ZTdIcnkwWGlZd2M0NkoxaDJKQTF1bXFhQkNVYW9F?=
 =?utf-8?B?U1grTGFzSWIraCt2TnZQem8yZlppTnlMeCt0SnFMZSs4V1RzeVdYT3p0VVpV?=
 =?utf-8?B?NTJhK05aZk15ZWZLTm9VcUJXR0w1QjlUdDludkwwVFg4OUYxdkpTbVZITUZE?=
 =?utf-8?B?YnVBTHNzSDlYdktEcE5mTmNwUlZiVHNhSEx4WU9zeDJiSW0wMUFwaE4yOUs5?=
 =?utf-8?B?RUJ6MXRWQXc5V2txZi9za2VaU2pxcW1neXRKYUJWYmY3NlM5bE1zQ2h3WTFw?=
 =?utf-8?B?ZlZwTCtGaS9ZRVBtaU9BSmlMM3lDVGNaN1ZkYklCNURQa1Bnb2o5UmM1YmJw?=
 =?utf-8?B?QVJiTGdSWERNWG9rNnVlNm1IWU1Ob2xpTzVad1phUklUSnZDUWZHYUE0OU12?=
 =?utf-8?B?Zi83KzhiRjYydUFSR2R0TWpiS1RoblRyTFBnNzQ2bndrSkJvNFRqTHNrSXMw?=
 =?utf-8?B?aXdyOVo4bnUrQ21lTElwbkpVdSt6bEZ1S204Q2NJNWE0SHBMaVY2NDhmWGNE?=
 =?utf-8?B?OUFiR2xSbm1BVG9nOUswT3VrN3FydUdrdzRETnh6Z2s2RTBhTnlmUGxIZ0E3?=
 =?utf-8?B?VVl5ajNmb0dtM3FuWEVlSmx6cm1nc2ZhWWlLK0JhamZBRlA4Wk5ZdlpyOUJa?=
 =?utf-8?B?NU9iRnV5QmlrWDYrc1NjRjVmZTFWenYzYm5kM09MdlduNWF0YkVlZUZPQUpY?=
 =?utf-8?B?RFFXcU43SjMvM250WkxuV0JqSzRSaCtYZXJGWW0rV3FkbVhXY0dmRTMzc3o5?=
 =?utf-8?B?WGFENDZpMTZGbUJqSkFCL2d0MmdOWEo5MjdSc2RpM2M2S3JoazRsWUlteWUw?=
 =?utf-8?B?b0h1R21qQURKbC9aUkFRR3ROK1B3SCtWL0VQZ0NTM0hlaGJKWVhSYWtNcE1m?=
 =?utf-8?B?QXI4enVJS3RwNXhRVi85MWZQK3ZmaWNnYTRNM0hCUHZSb0tBbXE4eVNYQ1l2?=
 =?utf-8?B?MXU1MVh6TkZyZEZzLzg3WTJ0amEwUENuYVFtSzE3NnVBYVlJVzJQYjhSQThu?=
 =?utf-8?B?ZVdwdEtnZVY4QkdzVTVVQ2lZcHFGeno2QnpSb1FBbmVhTDMxczhyUFBCekhI?=
 =?utf-8?B?SHM0TU14SkIvdjFCTXdPeU95c0RWaDMyVWJtV3pSOVF1Rkg0K3ZaYWZBK1l0?=
 =?utf-8?B?dnhrNGpwa1lIUkRDamVaNGpiVU1iZ3VIOTNpUGNOMU9UeFBHaXJsWkVPV1d3?=
 =?utf-8?B?ak9FaDU5eWMwa3gybFNGWEVJUmloZ2s5VFpKeUFTRGtzWEVLV2FpYkhQQmVL?=
 =?utf-8?B?UlpTUkVkU0pKUzAwWEhzUDM0MC9LQjFJSFk5K001R0xVYW1LZDN5UkpFaEN6?=
 =?utf-8?B?dWdMWVgvU2E2aWtnUW9SRDh0TmFicnVzNUdsU2RVVXB0SXB4V053K3ZpTDVQ?=
 =?utf-8?B?T3c2YlVubTVtaGlGLzl5NzdVd1FTd285bERseEpMZVRjK0lzMFM4NGNBdXM1?=
 =?utf-8?B?dnlKUmw3UVBDcDlST2Uwc29RS2hlc1ZaU2JGaVJTc2N5enpIS3Y3c1VHMS9w?=
 =?utf-8?Q?OxsBARtc6yLzae+E=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2704d871-5ff2-4769-c2c6-08da24a6d807
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 21:27:03.5154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfpDsnNPllKNUsxFIyfTonkFe7RCvy3Yt91n9HPPXwultiY6TC/USzbXXtBbzbGu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2920
X-Proofpoint-ORIG-GUID: tpv14JVdH_21sBhcWgACAT5hjs3sxWp6
X-Proofpoint-GUID: tpv14JVdH_21sBhcWgACAT5hjs3sxWp6
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



On 4/21/22 7:15 PM, Kanchan Joshi wrote:
> On Thu, Apr 21, 2022 at 1:37 PM Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds the overflow processing for large CQE's.
>>
>> This adds two parameters to the io_cqring_event_overflow function and
>> uses these fields to initialize the large CQE fields.
>>
>> Allocate enough space for large CQE's in the overflow structue. If no
>> large CQE's are used, the size of the allocation is unchanged.
>>
>> The cqe field can have a different size depending if its a large
>> CQE or not. To be able to allocate different sizes, the two fields
>> in the structure are re-ordered.
>>
>> Co-developed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 26 +++++++++++++++++++-------
>>  1 file changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ff6229b6df16..50efced63ec9 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -220,8 +220,8 @@ struct io_mapped_ubuf {
>>  struct io_ring_ctx;
>>
>>  struct io_overflow_cqe {
>> -       struct io_uring_cqe cqe;
>>         struct list_head list;
>> +       struct io_uring_cqe cqe;
>>  };
>>
>>  struct io_fixed_file {
>> @@ -2016,13 +2016,17 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>         while (!list_empty(&ctx->cq_overflow_list)) {
>>                 struct io_uring_cqe *cqe = io_get_cqe(ctx);
>>                 struct io_overflow_cqe *ocqe;
>> +               size_t cqe_size = sizeof(struct io_uring_cqe);
>> +
>> +               if (ctx->flags & IORING_SETUP_CQE32)
>> +                       cqe_size <<= 1;
>>
>>                 if (!cqe && !force)
>>                         break;
>>                 ocqe = list_first_entry(&ctx->cq_overflow_list,
>>                                         struct io_overflow_cqe, list);
>>                 if (cqe)
>> -                       memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
>> +                       memcpy(cqe, &ocqe->cqe, cqe_size);
>>                 else
>>                         io_account_cq_overflow(ctx);
>>
>> @@ -2111,11 +2115,15 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
>>  }
>>
>>  static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
>> -                                    s32 res, u32 cflags)
>> +                                    s32 res, u32 cflags, u64 extra1, u64 extra2)
>>  {
>>         struct io_overflow_cqe *ocqe;
>> +       size_t ocq_size = sizeof(struct io_overflow_cqe);
>>
>> -       ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
>> +       if (ctx->flags & IORING_SETUP_CQE32)
> 
> This can go inside in a bool variable, as this check is repeated in
> this function.

V3 will have this change.
