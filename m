Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671EB50C2D6
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiDVWd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiDVWdB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:33:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AB42C0A6E
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:26:20 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23ML6kQU029289;
        Fri, 22 Apr 2022 14:26:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lnbMILS4EHyx+LerKkpNmNZx2rAZYKuOY913N/bh+j4=;
 b=GkAii6PrcUmauk+QgNDBbMFoQch6fyUG/WNeT9TzoFxVigaqz22/Vguf5vqxMGnWOGdl
 wfr+3KlrOJONDw1j0PJuknhTtOEdr7DnC1RsN7jwQpEPwgcoMQ1NUAOmL16uFnEs1OIc
 Kq/G7ZW9NPzNVEO3ePLVlAoKqVD1mqtnbTU= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkd7s0awm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 14:26:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bkx455jqOZQSDh3tamDycaDfT6XFPU6SAJ5FoWn81yvRZuZmwH6kdf+VkKEEm8vv+BcCpLn2srzZlLG5rAXVZSLZK3tt8HlP4uzIDecr8s2+nsh0MNhf57PsnB742RfEN4Zw+9LBfoxXJK8JRL2HqfE6VDKCwC+Ph8OfK5Ef4nYI/EUbh1DS2NIAc83LfZP/MfMFHQmAg4tptvvmRr4Kzwy0Bw7NFJbx+jboddEcqu+55ldnfyvj/2XuERsWMPstrZjAhP323YOnQo5eketyH4RtY/ZRoWSYBAiL4jCR3+EGUeeyuJ409B2TVQvCUHiVj1bIRnjnFkqEtYIl1cqRtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnbMILS4EHyx+LerKkpNmNZx2rAZYKuOY913N/bh+j4=;
 b=QMCeIx2YOekNJr/4tugV4t5CURAdshzVXQC694KsH3N/PWWKD4X1hhBty4u0kdwoAFC8krSp6IsbImFlBs59WUok7ePlfly6/GGiExxva+EAnRmpr6zX4pKzF/qRU9KgHNpbx5PYLsJvni3P2/FYmS3/rcjGEOBogwnqAbDTHkayJxt3tCA+k/CjkWtJsQCM5tNVmh7oLZkpjXnS+EjZs62LkpzU49HVZ1K3WPwo2JyhrmyGWLj2JAz9lSlEAoyG8IIgQJ7DVqC73PJZqCU8msFRj7hOx+S9JbeqfvQrcX+IiuUkERf9na4JWk8IJgAiAyifMLvXqr22X52shDqnBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB2920.namprd15.prod.outlook.com (2603:10b6:a03:b5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 21:26:16 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 21:26:16 +0000
Message-ID: <366b7f53-2cbe-5d35-0aaf-e83a0e4d415e@fb.com>
Date:   Fri, 22 Apr 2022 14:26:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v1 01/11] io_uring: support CQE32 in io_uring_cqe
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        Jens Axboe <axboe@kernel.dk>
References: <20220419205624.1546079-1-shr@fb.com>
 <20220419205624.1546079-2-shr@fb.com>
 <CA+1E3rLem2p+FMhni3DLek5Bcwt_HtYRFmfuQirdRhBEz=Qabg@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CA+1E3rLem2p+FMhni3DLek5Bcwt_HtYRFmfuQirdRhBEz=Qabg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:334::22) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83b97626-0ac1-4e72-39e8-08da24a6bc07
X-MS-TrafficTypeDiagnostic: BYAPR15MB2920:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB29204BD4540296E59D0D561FD8F79@BYAPR15MB2920.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxGlezG5n4H2QGe4ZqbYRPdxoxY3dFdcJWTAJ5I/PYC4qgKZGsPu4kqMUDsEh1uiJcMOwYsYYkGgjmWZIM9bTG+YJso2m3cLTXro/VWyXPAMziAiB0p5TlnH4heHrRr0f5ITsks0/ore0FTaTcp0Ns8OOn6oQDWoIyVLIReb0L8SSXGaNy5ffBKBvOz5smh1nRC4mXwATDp+dy0srg45OTuQO3dGn5A0uXKCOfHzGed1PSY/1RuAZ0Wx/0/HltsqbTDOmIpEdYd+liB4vpQVpYECt1aR9thsuA2v//ojp0ZxKcJDFoVOvHdYn/L1h+i5DLL4shsp3Ta2GHZabDJf0QOmYYpXZWXVOWBwtdj1HwB8vPRTgT6P3B66SKbuh7Diov4+sUMQAnZ3ZiHglaAh90V9NguFMEZh+sGuxm+j2DLfWPEkLbAAZEjccbXGwdh2JxROJhU82MHG0EzmzpNeNs38beaZBzVfCGGuoi+HAMhPgFnA53WMwGetFD+XNCwNWT/hwQZdzUNyiUckvDaPWRp8vx0uX6bNtLa/g76gYi2W89Fms3Ph5x58KdbCIXoZqHVQHbaMf0ZOJ3rD0Edp+PdhvsO4bXds4YHohON1+jhwDq6LOFY63hVenLWZY7LsErx/qBbIwplcIe2/yrDbXdpcBz1DwFH3wqlVHB4O8doCfx8DAvhNpUkZSAo3K2BatXeGd/euL4PVgulc7jmHbsR37jTjuu7bD092AgvYiHQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(66556008)(83380400001)(66476007)(6486002)(36756003)(2906002)(316002)(6916009)(508600001)(31686004)(38100700002)(86362001)(4326008)(8936002)(8676002)(186003)(6506007)(2616005)(66946007)(6512007)(53546011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXEvSmNSTklOZnEvTm5HMG5odXlVRytaVGlkYXRlUEs0L0wxT0tyM2JwQXUv?=
 =?utf-8?B?Sk5vb29nYlF3VU9FMjlWdzd1VHdRRy9HSWNNOTdnbnUzbGRZZDc5RTc3WEly?=
 =?utf-8?B?QVRDL3V2TEluZDdoa1AxSEwzNTdydFpnS2VFb0RRamZHbENWOWdWSXdZRjRB?=
 =?utf-8?B?WllDK242L3ZoQUUxY21rOHVHc25jaTZ2YUNMNktTWFdjamRKY1NYUzVPclpo?=
 =?utf-8?B?OTN1ei9nR1JHYVpMb3ZRVXRGdk1OY2NJZHN5NWpUcXhIayt3ZmJnSTNESExj?=
 =?utf-8?B?a0cwUXgvMXQ0WlkxdDlVSUVoSytodldySDNGMzZubmczZ2xMMmVzYlRMUEox?=
 =?utf-8?B?OEx2OHBSZ3p2RCtEM2dBWDV5TFBSZ0ZteXcrcDV3UnF4eUF0S0lHeVp0LzN6?=
 =?utf-8?B?bms5M3pqVHFyQVVtUjBkcVFpM0FrbFgwNWppOUpXdk1qaWc1b3VWNDJTcUFM?=
 =?utf-8?B?TlRNNVlzSC9pRHdXMFA4c0NOTG93U1BvQTYrRWlXek5pNlZMd0xUc21aZjZT?=
 =?utf-8?B?L21LUkRwUXNiblN0bTFPNjJSSTJPd1h0clUxdXJZVG1LQU5GYXBNQzF4OVZV?=
 =?utf-8?B?UXdPcXlCaUZMdWtvRVkvQ1B6U2o2a1l4RnpCRUpxdEUxbUJQeFAvN2tnVW1C?=
 =?utf-8?B?SmVOOEtXNytYWWlDV0tKOTJQU2FyR0FZRTFpdStTZGJ3ajJJRUo1cmJ0MlJh?=
 =?utf-8?B?cHh6QjVtRTdjRmd0RDYxT2tzR2NSMnBWd1FpYkk1c3RnQzFFckFyOVgrWDIw?=
 =?utf-8?B?UkEvbTJSZUxlaENqYkw5dnZQMjlmNG5zT3FPSzRSUDZ5Vmd3UGhvZUJpNVQy?=
 =?utf-8?B?aW5Fd0dlbUtub2kzZ1FLU0d5M0JsTWlWRmliNEMxeDR3NGx1OGNUNnlLTWg4?=
 =?utf-8?B?MWpvcEVLa0Z0UDhNbENHUGwrcm1yQXZzaDAwbUNFK29JNVFCQ1dZTzVNTW9a?=
 =?utf-8?B?YktVenAyL3JYRkhyaDBwd0czYVpZeGtRR2FhZTdWVHhrSnllVXBJbktlKzl1?=
 =?utf-8?B?MzVGUi9yMzMwK0dlSGhkSzg1RE1CbGpkMGpwNGJwRWdCL2NsQklLekd6MTV4?=
 =?utf-8?B?NFhjSnlKVzhtenBVcC8wNUROMVJJL0xVeHhYQTN1TVRZWlkyeERpTE82Qlps?=
 =?utf-8?B?ekJidFlsZzdIR3diUUhVOXAxYVZPMGsxNlhMSzhYN2ZxNEw2VFNheXV0ZVBV?=
 =?utf-8?B?dG9aOXZCa0s3Z3YzZUhhNmhkVlpRMkZnVGR4UjA2aW1JMlVyMVFZcTBINmdD?=
 =?utf-8?B?eWZBZVdiczlqVHdIbDRzNDhNWUZCVFJYUklDbHc0Vk4rajRLUGFXMUlzb0Ex?=
 =?utf-8?B?M0RCWFFsSUk2cjJaQ05vbDZFR3ArODg4dFdPSmZRVWYya1NlblhUQU1RZ3Jk?=
 =?utf-8?B?SzAwaXZWODg3REprTzRCSUdobU9yTVdUMlRQU2YrZFNqTE4wd3VOdGhaaTBm?=
 =?utf-8?B?SlhVY0tmV0FWQTVhRDZKSFpYSmMvM2MrSm5wWE5UQVJvWnlVRlVaMXVTM3JD?=
 =?utf-8?B?SGpyVll6bEVtNHo1S3o3ck82M2Y1dGQ4dGNEeXpZR3VGWDlBUEl0WlEzVFdq?=
 =?utf-8?B?Y2lHRXk5SmY0dDlpTkJ2RTVYZW15Vm1TbWtPWkY1bC92OHNxMGRiemYyWWlJ?=
 =?utf-8?B?UnJqMVhnaCtqNXFIWlVSdmZYUEVVR0VlT0ZreE4xMkpqd0toY1FoS0cwQlI5?=
 =?utf-8?B?cDJPQkxETWpxNU83RGJOcTJadnNycVlmTDAxZHRjWGkxT1ZqWTZHS0cxUjlM?=
 =?utf-8?B?R3I0dWhLR05BVkVmWnczQUw0Rk9vMU9wcmZyZ0t6RXBObVBaaXl4ZU5wK2U3?=
 =?utf-8?B?WVFxSlFFcEM4aklWdFhoU2NuaDJ2dDdoTW9tNE1aNkpPN09MNjZIejlJL0Ir?=
 =?utf-8?B?VEVjQkIxYkRua2hxVEhCTGpteUVVQzFCM1dFdDRGU0hsTFVGZW53OHlVbUV3?=
 =?utf-8?B?K29qTHRjcGVmQ1orVUp4d2x0TFQ1dWZsOURLN2lWbERmTUg2c2YxMjgvWDBH?=
 =?utf-8?B?Vm9ESnhVc3FnditTcUFzZHhMUmcyUlBhM3VPQ0o4cnBCZEpCa0RVSXVkNERC?=
 =?utf-8?B?MC9NM1ZVbmx2NlRUNUowY3BISWt1MHpMMCswcGIzQ3VmaHdzRkZkVjM5Q3V3?=
 =?utf-8?B?SmtCdSt1QmNBTnJQaGxjYitsWkdyMUV6UG5SL2VBRzFpcm1UckhXQmlsdjJM?=
 =?utf-8?B?Y0Qrb3FSUUh4emMwQzJ1cFlSR3BoUzR0R1ZVaHZhekljK051WVQrZklrMm80?=
 =?utf-8?B?bnBtSGFwZGJjTFd5VFhabGlDUmpGQnJLczlzTEVPN0c3YlRSNzR5eFNDY3lU?=
 =?utf-8?B?OXdtc1VsWHlRUDcvNlR0aDJHdFlWcXp2THNHUVVFaGJQMFh1dzhaM0toaTky?=
 =?utf-8?Q?IZuVKzIgaQmanvW0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b97626-0ac1-4e72-39e8-08da24a6bc07
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 21:26:16.5681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QkX/10hrcnBdHefGjCFYCPk9TqAfLENTyK+8V2xpZ1i+R32OU6l1VawRShOHFSJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2920
X-Proofpoint-GUID: wKYhSPLuwYft0te20rfq5EglWVvEF9vh
X-Proofpoint-ORIG-GUID: wKYhSPLuwYft0te20rfq5EglWVvEF9vh
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



On 4/21/22 6:51 PM, Kanchan Joshi wrote:
> On Thu, Apr 21, 2022 at 12:02 PM Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds the struct io_uring_cqe_extra in the structure io_uring_cqe to
>> support large CQE's.
>>
>> Co-developed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/uapi/linux/io_uring.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index ee677dbd6a6d..6f9f9b6a9d15 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -111,6 +111,7 @@ enum {
>>  #define IORING_SETUP_R_DISABLED        (1U << 6)       /* start with ring disabled */
>>  #define IORING_SETUP_SUBMIT_ALL        (1U << 7)       /* continue submit on error */
>>  #define IORING_SETUP_SQE128    (1U << 8)       /* SQEs are 128b */
>> +#define IORING_SETUP_CQE32     (1U << 9)       /* CQEs are 32b */
>>
>>  enum {
>>         IORING_OP_NOP,
>> @@ -201,6 +202,11 @@ enum {
>>  #define IORING_POLL_UPDATE_EVENTS      (1U << 1)
>>  #define IORING_POLL_UPDATE_USER_DATA   (1U << 2)
>>
>> +struct io_uring_cqe_extra {
>> +       __u64   extra1;
>> +       __u64   extra2;
>> +};
>> +
>>  /*
>>   * IO completion data structure (Completion Queue Entry)
>>   */
>> @@ -208,6 +214,12 @@ struct io_uring_cqe {
>>         __u64   user_data;      /* sqe->data submission passed back */
>>         __s32   res;            /* result code for this event */
>>         __u32   flags;
>> +
>> +       /*
>> +        * If the ring is initialized with IORING_SETUP_CQE32, then this field
>> +        * contains 16-bytes of padding, doubling the size of the CQE.
>> +        */
>> +       struct io_uring_cqe_extra       b[0];
>>  };
> Will it be any better to replace struct b[0]  with "u64 extra[ ]" ?
> With that new fields will be referred as cqe->extra[0] and cqe->extra[1].
> 
> And if we go that route, maybe "aux" sounds better than "extra".

Let's use __u64 big_cqe[];


