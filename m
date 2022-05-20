Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA952F2CE
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352739AbiETScJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352791AbiETScD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:32:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101A65FF32;
        Fri, 20 May 2022 11:31:52 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSPfY006864;
        Fri, 20 May 2022 11:31:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qxQ3GB7JRUoiN35MRri/5zguNGQhImCCPTDeryS6EHc=;
 b=CrY6j+8XQwGq7mrtURJ7wKqtyldCxOayAuLx4ZSHoVsaP4GM/SX5+VSJLBe/JVNYmRhv
 B2EtCxnGwrJV2iVe69jQ7kWNdrIwDtFjR8tSZO++ThdQDS2APNTuejhnjBnYX0i7taGY
 oEIRlh1pMv8YRvluaNMqRTEn2Ez3TW8wXDo= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g60b0n925-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:31:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSkh26q153grOCOt7aMOAYUvbN2bruh5yBh3Jvo4s3Ek/VsqBf0S/UP32biEnbYUgjnAIvsLeOJFde2U1RUC5Bl2PrDWIlKlbkm4k/s8uKTqB189WDyNkSq5GwVgE32bwUEW8c7OIjRjHSBOMe1EANL4g4bW70Ji9VgbauVHisvyJ3n43BkkDTxlgy2kPymJGuOFW2rL0FTwXr+r80wJ9R1cPg4gsum8vIrztDtAmV4QdlXWjNu6AkNwNZYqkxSaoqtXub39KsxXZKBgbvWA5ENgrma0LrP90+OiYsy7PJw/xeMvhC4TW79WYJYOHfz1oad4ji8xwY5upmsD/nsHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxQ3GB7JRUoiN35MRri/5zguNGQhImCCPTDeryS6EHc=;
 b=ZqMva5zZc1SNj+h8WtV8stzxj73yDuTrvSP9JBTPTYBymG96LGFw7TZG4SY5KMQWB7YimmnjGhD7J3ZPIl5Tb28lq8w9qRkzcJDhQ50QK+l6O+yc+tdRxvQngn7ALEiiTE1MQEQFY8H+xJbc1fLB3ynlYmHhrAs9JR8g37GjEmrXem84UXPJU9DcMIM8VXrjsga2+yRyHUYRoahUuATdwXGZlTeygyRjzyF1gM3ZwXGHIEHAPPElkzrd8s8YSmpAhmVEd/RU2hZ0ex07MdhGt/Q2Nq1GlbRc133ppbg728Pf7gclvK/EBpsC9zYM8/1DhyMy/iwXF+MWef2VHfQKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 18:31:42 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:31:42 +0000
Message-ID: <72501711-b6af-4815-3422-9821425d8edb@fb.com>
Date:   Fri, 20 May 2022 11:31:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 16/18] iomap: Use
 balance_dirty_pages_ratelimited_flags in iomap_write_iter
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-17-shr@fb.com> <YoYAivwbExCgWj1l@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoYAivwbExCgWj1l@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57756f0a-4bdb-45bf-26ef-08da3a8efc18
X-MS-TrafficTypeDiagnostic: PH0PR15MB5117:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB51177AFA8CCE365B06C4ABAFD8D39@PH0PR15MB5117.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgHvnwwzhM+nDZNU/Kyv6KNPKymC6WJRIzlj8Ok5EMLZNDbw3UHEDAxYiucb+rmFLehYYmP0veXuwHDtvdQbcBT5ae4kQz0T/x+XaO3mOJUpctm4EiSujLpUfZBh7f8IKznzb6VRDBrpvzAvCwbnrwNGWwSxL6ylxfV7nns+hBTn08q9FH+OXMcpoDZRW4LiqybTvxs/pgw2hAULjjA7Xf//oN4bxaU+DGkKPcYnKFss+byY3Hpxm/GQO/tCmGytlQ3HKv/9f3LENMUqk0glu8zUOLgH6pjsl3cAznAi07nP9Fk6eSzlh4y8CLZmSYCBJQM/OA92h9sjS6Wmo8ZHKkP6wFZrcpUwS9RSYxYb4EXYZVSYC5kDOuDZD1wvpa6nZ/DP8uJcmD4yZ2AlFKZxScGJmIW0cBTD2wZenxskQBgnY8sERkP9etgpQ51oBkSg+tm5Ke15gjK6WQtzFemarqRJo/A/qw9Lkr1oqFfROjIXlFofU3EUxtWkUO/+dUdXlzVZmJPkRoOKQmCPo2wUsIBa1SQ5XzaVeVQVl4FZueTYhDcUbe6xEtqDjXX9Z2pbh8limeh5uU+ynFBOADG/wxjR+6/GGJOQ1+nPcUmedMdPQpFytewa/kSIZlwW6H0z8JkgLqU3BSmVDzTMJocFOaWDePCT1o+SczeIxNC6GU2IEVAz/JA9rmCtxqVqfZ6UcrMEbC+gJy8kYOCfN2MjO7VBsP18yMTSRdXz3YJyaa8KEHKd8za469bntquLPwxW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(8676002)(66946007)(31686004)(2616005)(186003)(66556008)(83380400001)(53546011)(5660300002)(8936002)(86362001)(66476007)(316002)(6486002)(38100700002)(6506007)(6512007)(31696002)(6666004)(2906002)(4326008)(508600001)(6916009)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0RDdzZlWEtHa3ZWR0VIRTJQMVdVNDNkbzN5UmoxQmE5bFFXMy9TY0Rub2Nj?=
 =?utf-8?B?WXV5U0hSbFhxRmpseFA2UTQ3dmN2TjF4SVV3bUttaUlLSUtMMFVWMDA5SFVl?=
 =?utf-8?B?eHk4dFRMSVpaenI4WTdiUFNvck1wbUNkeldRbzhNVk9WRUZMWXgxSVlLejRF?=
 =?utf-8?B?TXJOWkRYQWdNQWR5V0dubHBLbXNmYlpsanpOMGZIdlNTcDhkVVFsZ1FvenVx?=
 =?utf-8?B?NGRMK3RiVVREM3lrbWFWZEtPN2VKa1pBRVAySDBUZ1Zlc1RzTDBkUzNOUWtV?=
 =?utf-8?B?bEU3cGpMSzFyK2l3dzZ0NDhadDNmNDRHWEw4dzFEN1JHTlFYQmQvRzF2SHJm?=
 =?utf-8?B?S2pBanB1b2d3QmpPSlNIcjNkZzZ0WExLRUpMa1M1VENBUHVZS1hGaVpvZks0?=
 =?utf-8?B?ZHdsakI0VFZnbVhtQ01oR2VpUmhPMWhaWDkwdTJtS0dqNHRRM1pqcmFjYkYx?=
 =?utf-8?B?cG1YKzJxOG5nVFY4L2EyTmp1MDg0b2pQOG8wOGFDZFNnOVBQQUFXMVA5YnUy?=
 =?utf-8?B?blByWWhwS2RrVnlycGlqSWl4eXkrRVgreDROZ0p1OGNaWXloeXlKejJWTUNE?=
 =?utf-8?B?MWErTW5jaGYwdjJDUmhzdW16Q05VWTdHN1B3T20xWmNyazI5UHYyeXFZRzA0?=
 =?utf-8?B?Wll5alNqQ0ovd3ZjNXhEK2JGQVJ3eGdvRWZrRFpKdEprQzNwdk0zUDd1NVpn?=
 =?utf-8?B?Uy9reUo5WXUxMjRzNkJjMVQzYVgvVElIMER4NkNLVXo4YWN5Nk41akZKMnZv?=
 =?utf-8?B?d0prcWF5TW82cW8wNkkreURsSGc2ZUVjUkNNbzV2M2JwMFV3TldsSkV1WEpv?=
 =?utf-8?B?NE9ZTkF0V1h2aHJQUnp1WTNGenBXZzVPaUxqV016d0dNRkVlSjZCVU5HQnF2?=
 =?utf-8?B?d0hIQWtiTmpFTjVlM2g0RkRYTm9kbmZNdGowL0VyclRMSEY1dmRWSll0Qk02?=
 =?utf-8?B?RXB1a2RCNVRwTW5ZTGhJYjQzUDJHbVQxc2pCcm9heVdOMllNRDBBaC9heGFD?=
 =?utf-8?B?cW9pMzlHc1dSMzdIUGgzUzJiRVNLZUFVYlc1NXQwSGUrZGFoaEdrME92OG1X?=
 =?utf-8?B?dWdrYWZrQ3B4YVhkSW8xTXpjU3pSd1lLT1VhdTZMVnFMWEwzV3dpWEEyMVZI?=
 =?utf-8?B?WjlQZGpJOWJRbXYzUEJiWEhiNnlMREphU2ozZXRQRU03bDdObS9MelNzbE9Z?=
 =?utf-8?B?MGdGUkxzUzU0Qlh3SlpSTEx2ZWRJTVlOWDdhTDVZMDZ3Um9NdzhWSnRKdzRG?=
 =?utf-8?B?YVVudWlOaENLODh6SUVIR0IrOEdWUVVBQndnVTZPZ3Z2ZkJRcWtsbWszd3FY?=
 =?utf-8?B?KzlUUEc4d2V6ODNBNER2M1pjRnc1Z2R1Y2oyTEJlYjZmSkozMWg0T0dXVHQ3?=
 =?utf-8?B?a1F4V3J4bnRvc2pBRjFNc1ZLMlBoQ29wWWdEaUg5aXMrN01nY1RKNFJvZmtN?=
 =?utf-8?B?Nm1qUFArZ29QVmxqdTVSM3VqWVRHUFh2VHRoNkptdzU4cnVEejYwd1dEVmN1?=
 =?utf-8?B?R3Vra29FbFMwaDJnUHdYK1BLY0Y4TVFWRWFlWnVBUEIxbzdQMWN0WjgrSWZh?=
 =?utf-8?B?OGU0Rm9YMDk0cTN6SEhRbFYydFlRaEFoeW1iL09Bay91UEN6RjdOWTA1cDEz?=
 =?utf-8?B?NkFWYzNOdkh6cnhEUHNXNzdwVVNYdkRRTE90ZStQMHpzMHdobllCd3JCdk1K?=
 =?utf-8?B?RG5RVkpkWnd4VUxpRTMxZjZOa25VRGF2dTF0eHgxcm9FZHJQWHNrbCsyVzda?=
 =?utf-8?B?RUJGSm13WXR3MEd3Y0hZYWdxUm1RRFlVVU5JWmlXTFRJVXBiemYzWHlOMCtK?=
 =?utf-8?B?U0V5TFV0ZW5pOGcvNStHNmZCYXNDWW1SZ09nOXFsaWtTU1NvNjBseHc3T1Jr?=
 =?utf-8?B?LzFmMlBZRk8vSlpmSlJONFV5a2drMnRyTFZzdkdldURyUE0xVk9wMEovYmFG?=
 =?utf-8?B?WWJoUUJoZE4xbTJ5ZFRlWHY5QXRiREYrcE14NVcrZWZrQzJvWjlrbm5EWjIv?=
 =?utf-8?B?THhqTnBXMEs4RHA0dGpXcEVxYW1IbFNZcFNwb3RBZDNrdkVwTFdJeWVjY0tV?=
 =?utf-8?B?YWNEcWlDYmIvaTJWVkRNSytaZVpuaUFoZXZzaCtkeGJnWXR0aUFLaER3N3o0?=
 =?utf-8?B?NnpKWFNBQklIcDk4SVpTeEtVTGI2TDFHUnJSV29pMnFlaXQzYU1KRkllQU5n?=
 =?utf-8?B?TXZTWGVDSnhvckhJOGcwNkx4TUlvNURmR0ZvNm9tYUI0dWlwejdQTXRlSG51?=
 =?utf-8?B?NzhrU1BtV2ZUUHkveTBGdURDRk8xL2VDWWdEbUJkTkpyT21vV0hyeG5HTHVK?=
 =?utf-8?B?R1IxZkJHZ3h6eXRCaWZXb05RajRobTAvUTFUd3RkZi9oUUJsaWVlcHFzWVZp?=
 =?utf-8?Q?6vuFLyY/YNh+ZesA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57756f0a-4bdb-45bf-26ef-08da3a8efc18
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:31:42.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eGI6oudssM0gKFtEnqgUMgeInJDeG7eOEsb6lZ/qJlrAUEWyrP81xKyC2fH+NvBz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5117
X-Proofpoint-ORIG-GUID: iWHPqLS8q7oBYm8a8EK5o6bl3ABiHCDr
X-Proofpoint-GUID: iWHPqLS8q7oBYm8a8EK5o6bl3ABiHCDr
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



On 5/19/22 1:32 AM, Christoph Hellwig wrote:
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -784,6 +784,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>  	do {
>>  		struct folio *folio;
>>  		struct page *page;
>> +		struct address_space *i_mapping = iter->inode->i_mapping;
> 
> We tend to call these variables just mapping without the i_ prefix.
> 

Will change the name to mapping.

>>  again:
>> +		if (iter->flags & IOMAP_NOWAIT) {
>> +			status = balance_dirty_pages_ratelimited_async(i_mapping);
> 
> Which also nicely avoids the overly long line here.
> 
>> +			if (unlikely(status))
>> +				break;
>> +		} else {
>> +			balance_dirty_pages_ratelimited(i_mapping);
>> +		}
> 
> Then again directly calling the underlying helper here would be simpler
> to start with.
> 
> 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> 
> 	...
> 
> 
> 		status = balance_dirty_pages_ratelimited_flags(mapping,
> 				bdp_flags);
> 		if (status)
> 			break;
> 

I introduced the BDP_ASYNC define and used the above code. I also wired it
accordingly in balance_dirty_pages().
