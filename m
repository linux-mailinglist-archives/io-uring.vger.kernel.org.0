Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE6B5345E5
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiEYVkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345419AbiEYVkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:40:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE869AFAD2;
        Wed, 25 May 2022 14:40:05 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24PGtatk012054;
        Wed, 25 May 2022 14:39:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UertANiM157dTD9zwjC+X3lJ8O/ZaAxGdlAIljyA4XE=;
 b=I20F32UHm1OlWc10HK0L5y+QIpHORoCjl1IUs0X8bCAVryUz90RSKGgWe5xFe43iw43+
 h2VdnmdaIVQ6BsKK2Ejy+kUDJH5rYPrA9pOpPw/WQBkJWzJd3CHvMuJ0kc60z8ra19lV
 ri2tG3jGXpXD0FpRQyJA9JOQ4X3WZDa5FjM= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g9qtua6gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:39:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRpFEvnvfhnTyKYKYEZw45NDwOlc5RADXIYlh8Fz5lCYJQ226MP5aIp5zX2KUpsabahgyB2riYaDfI7N1NvIcBxhLAi6uiRYilTZUUecqFlhHmvH8SR3fyC/nxC5n5yS7cHKYhxgD/f1U3Gy326B3g5UEsxTS8qfI6U7a0gqVy461S6SzhuZ/DusdgIkSvOE2YV8VBF8fJ/oqjVCsgFkA9lFBHUeLjrCsGh+w5k+uZAcHa1VRJwnfMNG2iuoIcu5wz45txrJtO6oHM4yt4boNlTC69iJ2koFgF/PpyrQJCjfjuTcF8X/kZCIKrqxE+8DuK0mlaCX9GQZV+Mn/CeLIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UertANiM157dTD9zwjC+X3lJ8O/ZaAxGdlAIljyA4XE=;
 b=BDfqcHU86Ha7v+ribPfrbOq0ifWOj30kuY5gN+n7J8AN4Psi5+FbI4SgURTRWfWo1rNotkfK3fJNQw3azlj4GeuC/vQWgWmdIJR6fItjwG8SwsHjig/6mRjkHdkpMj9dt9KQXXFA+yegbdOW6iGyI/XWEfI+2zrMwkl7mVZBf9yJnCd8Eu1loAj9/lcAoig3ixjMtWC8KhU4U4CtkqFsHspOan6q3ZK9WQKftXKBfTRRrPOvAyZDDSCz1W2tq4oyeTrWKapVl/L9Qcc2PMbw7tKCR7gEfVOm1eAsudOs0sdK8GrS1MNJsRAN1wGqcM5pBXNaJHR9fJAHWQ/Jq+nU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN7PR15MB2260.namprd15.prod.outlook.com (2603:10b6:406:8a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 21:39:57 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:39:57 +0000
Message-ID: <18ce1ff4-caaf-a4b6-de2d-c82bf2ec33fa@fb.com>
Date:   Wed, 25 May 2022 14:39:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 11/17] fs: Add async write file modification
 handling.
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-12-shr@fb.com> <YonlE9w2VhSa0jcq@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonlE9w2VhSa0jcq@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::30) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6748888e-b2cb-4e9c-3f00-08da3e971ca4
X-MS-TrafficTypeDiagnostic: BN7PR15MB2260:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB22609535E269DCD5E4FD1F97D8D69@BN7PR15MB2260.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knpZq4r9bzBUVEiseJ7SiFlDXjjsHe+ztz7OPDDL55GRvZ1ebjHiiYDPq7/hHFn4XBRstmz1oebNOOsIHGyIqA6nwxFpkdnc2hbrbRvM8e+0lXZbTGwNbp5zvFW4kvQXqUIel9qsQ2f8rOIvCH4yhimxvG0mu5UcGd2RAV6bCUCXgqYjPS8lPDld5Ly18OKzraD1I72W0ABdfC0cQQ90JvKlAwmUxz4+k9IRsJ9FuSU/Pcm/N4B73lIQlQDM9kYF/rA3wkTBmsSk7rJJtuvBd2aMqxcRXUbzDrtkqedLwzGV3e3cbgRX3voBsINgDrn3SHXE8fyxfTwW31BZcx3IbU2Bb1iUcNqu5+gwWHMtSDoUOLiJ4GHeaQwNCognXH/zaw7RwG+XbcCOwgEVvtFuHJc2tu5U0P87/a08iZThwjPMtnpyYrlvrdVQSMCBg6ILjIhdBoG2NZ+lquLUZAcZjXE5i+BLVDZDKsQmya2XbcDZpi5MFgZUtjyZcmiAWjX11w4p36Ec3Y3xpDtAbLIYjo74JB5NfZcZBmRHgxlgg8BxtJ7o4sQ9CQv3SeKNtSdcVYzZsMmEbUqc1Y9CdMZb6QMjHZkmNG6w5cx0Gev9em1LBk8Pt5VoY5f+PAIQsIrECspss+9CENQDHf5r1FcuPr82af30CFxBOQjOnhiz4T66FEHAnaFHcypB/PesXB07CQyVh19yXxXvzlQkqLetLuBP1wETtv6mHZHvY9PHXXdrGj//alX3X2d6FNDAfqeN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6506007)(53546011)(31696002)(2906002)(86362001)(6512007)(6486002)(508600001)(8936002)(4744005)(31686004)(38100700002)(6916009)(316002)(2616005)(186003)(36756003)(4326008)(8676002)(66556008)(66476007)(66946007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzVoVm1ubXZLMXl6RmprdWI3UTBRKzVEZmo4UFhHMGZ1UC9tb28rZUVQYmsw?=
 =?utf-8?B?aUV3MVFTalNxWk9DWjZ5cWxnbUY5ZzdDVlp0a1pYK1pLZjZad2xLOWo3cTNk?=
 =?utf-8?B?cU45cHBUNXZ3ZmNFVTVSRXNiQ3d4MEU4eVQ2Zkp6aGJnZDFRajRRMUpQTW9t?=
 =?utf-8?B?RjQvUTVKa1d2WW1vcG1XUkpRZ1ZZc3BCNWowdk0rUVRlcHFVeFNPVmIzajhh?=
 =?utf-8?B?R3UxUks3R3dOOTQ3K0UrcGY4YU40Z29vUmgvR1YzM0llMS8zLzVVMTVzTHVk?=
 =?utf-8?B?Y3o5LzBjdElWeEpqNXBFUVJpTG9MYmM5eXZaTmVkWkZOUTBLZFQxei9hZUda?=
 =?utf-8?B?dGZhd2FHeWl4Wk5kWUtqUDdjeHBRdnFoM3EyUndyT3NrQitONTh2aURrNklq?=
 =?utf-8?B?c00wUGdwS281SUFIWXgvN0N2TlM4Y25JOWlZWStsdkQ3ek5VUlhLVmhBT0JM?=
 =?utf-8?B?L2MxcG1ndkxsYUQ4MkJFb05ETXI4VXFVN29FRjVpUndxY3dNaThBd3FCZlB6?=
 =?utf-8?B?eGNCV1BZQ1N4RGlydVZydnBxNGJBdEJHTVBUVUIzQ0hTU0h6MjZKWkhQaEN0?=
 =?utf-8?B?V3FSSnpWaDMvV0NPVjVWTXBYdk5YaFp2S09obmFNeVZCWjZJOHN1R0NSNG5s?=
 =?utf-8?B?SVZsWDk1cGZ5Y1BpZGxmY3Y5VWtlQ2d3Z0RpM0NkeWRSVXNrU2Y5REtGcGxF?=
 =?utf-8?B?clNGUnoxN1BNSmFvbHpyS2xCR2l0RTQzdnNPYWp5NjNEL25Vb0J0SkxaanhI?=
 =?utf-8?B?MmcxQkh6OTR3QzhVSHpPUzFXcTE3eU9jZzlJVlp2enpmZjhZRElJK090SkJG?=
 =?utf-8?B?SGM2ZTB0d1BtWHBacTNGaFpNbllTdE15NVJySnJ1b2R3SHlDS0dnREcrSy9U?=
 =?utf-8?B?UWlDZG92bGVnZnlWY3IwVkIrQWwxQ2EzRG9XRGkvMmRKbWpWWGZrQ2FGRVZ3?=
 =?utf-8?B?cmEvVGV2TC90UUZxZHVqa1R0THViU3Z4VHhUOGppb29nMEUwc2NiN04rWVhh?=
 =?utf-8?B?bm5hNFNpYnlSWFlzVkdZYU4zNDJnUTh6NEozVllaQjYrSkplWmdHVGdjcUNF?=
 =?utf-8?B?M3hIRU1wT1NkZWg2Y2hPNU92bGtNNDlibW1OZUU5TitBRCtuL1R3SXNaVHZn?=
 =?utf-8?B?aGpGNUNoRFNqUUs4bkp3dktFSkRERURFaWJNU2ttRTdCVGtQOXEwNDZzaHh5?=
 =?utf-8?B?bXB2akJ3dWlWdGZyRUNuZjRKdFhZZElxYkRMOVJab1FBSWhjZ295S0c4MzJR?=
 =?utf-8?B?YnF6VVZodi9qOWVTTDdVbUtLQmJ1K0RxMGhKUzFlZlA0THBJMm5kdEJCS2tx?=
 =?utf-8?B?REVPeDIvbXNLT1ZqenJma0NvQU5oemZ5dkIrbGZQbTlZMzlWSHo4K2FsTEVu?=
 =?utf-8?B?R3NMcE1NTFhqRUZGNFk4eEFoMzFlckh3VUEwZjV4aStuQWdCOFpkUnU3aUI0?=
 =?utf-8?B?Nkc2Q3hRL3NtOXQ1Rys3bzc4Y0hvVThDZ2R5TU5DbnlzUGE1MXVDYkxpdVgz?=
 =?utf-8?B?RWZUS0VtVTd5ZThlVDVybnpkT2V3UzdiNFVwQnNJQmoxcHlvR1FlcENqQnF2?=
 =?utf-8?B?OUFmOUZ6VjZwVUlnNFNPdXdnYUpNVHpJOWdXQlRZN0R0Wnhkb3FBYjRDZHJ0?=
 =?utf-8?B?Z3JMRU1wTWxkcXYzL0JiMnREcFFMeG1uc3NndFNkTHJOYU01ZWFvSXpId1N3?=
 =?utf-8?B?citObnRrTC90bEVFQ0ZMdUdMeEh1MTN2UWRBK3F1YUFlZkxENHJZb3NFcDgx?=
 =?utf-8?B?dEJhY2tOMDJLYnRLZTVqQXVOK1JkY2dLVU8yNGRsVlZnYnlJalR4bUFxdTUw?=
 =?utf-8?B?T21NRVdxNWZaRDN0QVEyWk9KKzh0UnQyVUNsc3I3elV1NmxCZjRGUlJ6b3FH?=
 =?utf-8?B?WmZXSk5ROE9lUW9sRVBOemlqRmJiVkdENU1mUDM1ZEJCUExNWm05R25yaFJp?=
 =?utf-8?B?T0pGSmpWQnpVOHM1TlFTRjhIMjN4a1VOVjVOM0Ewa3lTSjZnbkdzOUg4emxT?=
 =?utf-8?B?UjV0a2EvZXNzTUxXWE0zOFRTZUhjdVBiTUUyRTlyL1FwTmtnd0hXRHIzeVpz?=
 =?utf-8?B?M0hSRmRMOXgya2VKZDZoQXdsb2d4SFVWMEpyMnBOeG5QK0RUck4yOXhOMzVE?=
 =?utf-8?B?MGRhVzVPdVBUeVN4WDhPQWtscDJjRngyclc4Mkk4NTdJTXNtcS9pMWsrZWMv?=
 =?utf-8?B?V2o4a2krOXpGYSt6Ym42MlNKWUlieXUrbUw0d3hHNk5EWnJHZ2hCYkRmakhG?=
 =?utf-8?B?N0RkYUhmdlNsTm1HWVZrODlxaWRNd1VNa0dReGdHcC81UWNwMzIwd2dTS2ZV?=
 =?utf-8?B?bUF0SnBOaXNkbXFUT0FuMTJJdzFQd2o3V2NoaUZ5cTlPSk4yNVJXM2lOTDNP?=
 =?utf-8?Q?Ty5jXcmrSDSXjVH8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6748888e-b2cb-4e9c-3f00-08da3e971ca4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:39:56.9574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBNCpxwvlOrgJ1Qe4ZDe+MWz4jvTnTf0OgIwv8VkcuwBPqn1K6YPErYmIPTqtwUP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2260
X-Proofpoint-GUID: DOhWONi7jUWn2ojWb1mwCoWrvxtF8dkU
X-Proofpoint-ORIG-GUID: DOhWONi7jUWn2ojWb1mwCoWrvxtF8dkU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/22/22 12:24 AM, Christoph Hellwig wrote:
>> +int file_modified_async(struct file *file, int flags)
> 
> file_modified_flags?  Or even bette kiocb_modified and pass the
> kiocb as that makes is very clear which flags we use by making that
> implicit.
> 

  - Renamed file_modified_async() to file_modified_flags()
  - Made file_modified_flags() an internal function
  - Add kiocb_modified function.

>> +EXPORT_SYMBOL(file_modified_async);
> 
> EXPORT_SYMBOL_GPL, please.

Done.
> 
>> -	return file_modified(file);
>> +	return file_modified_async(file, iocb->ki_flags);
> 
> And this should go into the XFS enablemnt patch.
> 
>>  extern int file_modified(struct file *file);
>> +extern int file_modified_async(struct file *file, int flags);
> 
> No need for the extern here, or any function declarations for that
> matter.
  - Removed extern keyword in file_modified_async definition
