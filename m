Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C7D5352C4
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344922AbiEZRjl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347294AbiEZRjf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:39:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5609A980;
        Thu, 26 May 2022 10:39:33 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QDTSFI028650;
        Thu, 26 May 2022 10:39:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ETM3iagzX9Gfi7Iz85kbdmIzITvAbwJR4Ru1V3lhVcA=;
 b=kdmwc9X8WiO6ba2YacYWnuepxaGq09LD03vW/iY6uya4NUqiZGrfPRKhDUGpSLYCx8no
 x9XTdznMBoHDCYjYY17KhSL7386sWA2SCXkCcbZbNUPA+hLpCQ2sQ6SKLECsqV/GAWVB
 ORC9+E2foumt+HtCP5hL7c8e0FbjY0Ip0w8= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gaafu1suy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 10:39:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRHSpbiA/OYxEJ9+0nUlPDOcCo5xnMSiVewKdVlkWkDeV5SqSLYawuyEU3reVjm/exQ+3gUpxAO2DW+h6goMJoUKALAjHNgi3vPtcKo7+1VTsXF8R9enO1llNU8f0NFExhJebA4VacJ7CyWH/Vh9dywNcmNi9+clQoR8Qf6UjOIQcEv3T68XNi9YgIIFDA+N/FH2KQ50k5bAOGXYnSeJOe42i4+cQ6K57N7DRr/XknZWJ/zIWxaFnFVA7Et3G+gpmB8CBazl537bCcTHOxyYqcDZWIcPN6KKyTMEy1rUFxPDGue1baWOZS8zrB96+i4upp50qu61OCCj6QwsjjN27Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETM3iagzX9Gfi7Iz85kbdmIzITvAbwJR4Ru1V3lhVcA=;
 b=EU/+QdrwZZ8vPi6ImMCMcEOGAPUl6QFPAk50dM+YaPj26DJNT/lS4TIDa+vxIy4Vy+iOb+cJZkhelwoPYGXeXEUD5SAyWytJ+AQ80vMiZl/TdzlFxxm3z/b/WSYFwW0obUnWX3W0hUChJheearkw7u+PermUMeEjA8P0qrIgypzMomUZ/yo5ftoLRoOak7D+IMAVgCb5gE74V76hBNcwiDAsSEqq4obbleW9k7C+fntqxKtWqYFfEVTCHvm25mHIYIrNTbkA0COeYN+wN3oyqvoETqjvWV7fgbs+o8wqylrVdKDeekHDIIuBlotku8iw8Au+QhVjXmiD3RL1myWrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BLAPR15MB3810.namprd15.prod.outlook.com (2603:10b6:208:275::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 17:39:25 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Thu, 26 May
 2022 17:39:25 +0000
Message-ID: <7b84bd69-7dc1-a597-5e2c-ad92e90a22d4@fb.com>
Date:   Thu, 26 May 2022 10:39:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v5 04/16] iomap: Add flags parameter to
 iomap_page_create()
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
References: <20220525223432.205676-1-shr@fb.com>
 <20220525223432.205676-5-shr@fb.com>
 <20220526134356.volr3q5ysewszfwo@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220526134356.volr3q5ysewszfwo@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::16) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59d08185-eccf-4b40-0417-08da3f3eacf1
X-MS-TrafficTypeDiagnostic: BLAPR15MB3810:EE_
X-Microsoft-Antispam-PRVS: <BLAPR15MB38108E86D156CE0D603B30B6D8D99@BLAPR15MB3810.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UzV71xRjgHcmU+c7wPyqURiJ3Hj4Lz3z3jnNE8bgfwuBJKdkprIpFVLcuJEGsHzP+ihFVowwAW8rVsUZs5iobL252vzLS7jahRMbGRugW69zymOC8eiHebXcBM95OP6YlXgSCERdqMpQiD9lsC3qjLpTFWNreiyTn+UWMxDjejJGBOceajSB/k54UoUOEqYbiAmX1Q9aoiM1Ug/0DtLRIjWd59s70tilKK/WGiVK9GbitW2ViXE15VhZILfLQ/lnYSgNJ5uz3fHX9X8wBhaafkJNFVPLW/XRTrlydn3xVm5zJ1DU4EDd+L7YACGZZfiulqCZY74TmIoytx5jtt8u4cc8s/Iix4wcysFoiQ1XazEmlCitgPUoOyTWkxfsqxr/NSB8VR1E8pEO5/ZgRdUVFFngYMMAIJlo6pfX6c/wKVYrTiOJNzaCR2+ftPGNtWY1am+QD+wxU5NNP+g/SKP85IVTWJrajqfqKGslpRybZBDZw5zoo/hiNhT/R0jAmMf4if3lnVH6vyCJSR/OVjGgODwmKaaF8cADMk1NtI1PN6ZDUNRW0M7plFm2EVvCcmo1+Z4QM3zOJfCAzyPcG8reBAX2zlMr176FuDApv1mhQTYEGOTQ4NjbqkDMs/GnciUiKb7p6WM8D1PDnWlBT0uE6bY4wjpw8zLhziwV9F2lJJDy9WR0e+9OD8xBXyOQXDF8WBUXG3wsm3iWr477jajdwgLfGxJ0plby9kQ0enB+rww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(53546011)(6916009)(6506007)(31696002)(86362001)(38100700002)(6512007)(2616005)(66556008)(66946007)(8676002)(4326008)(66476007)(6486002)(8936002)(508600001)(6666004)(5660300002)(31686004)(83380400001)(186003)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjZlTWx6NElqWDh6Q1VQa0RUZzlFNjMxQml0dCtBN3lrVmZTUVF4b0ZkOUoy?=
 =?utf-8?B?empmcXcxbG0wS1g5QjgvWk81VC9VVTVvZVByREU5bUJwcXdrVXkra1gyeDc3?=
 =?utf-8?B?VzFidTVPL2VoSXhPTHRvcVpnekh5cFZ0QTZkdWNRR0pJQ3hmOGR2Skw5Q2ow?=
 =?utf-8?B?MzVidzBKcEx3THFyNUNpazA1d3U3MFdxWFJVSXVCRzY1V2s3RWxBVkd4b1ly?=
 =?utf-8?B?elNvMmpaeE9sU3QzNWJMNndRSlkya2FUR3dBK2VPTzJFUng1eVNrQTl1bDdC?=
 =?utf-8?B?MWxtclRheXg4cExZLzQwc1YwV016T3lOblQ4S2dWYlB0Q2pRQUNLOVN1c0p4?=
 =?utf-8?B?L05ha1dlQTR0ZkhLb1kxaE9IR21RTjVKU2YzalpMbUUybGk2MGNDZGo0cGZH?=
 =?utf-8?B?aUs1THFPQlR1K2cyVXI5elV2cHRYbWxteCtMSHVvNndVVmxBSVU5N2dQaGxh?=
 =?utf-8?B?NEpYR3pFdzVoaVBDdlpEOW5ySUJnVVpPZjRJaGliM0I4aWxJWWp2THh5Qmht?=
 =?utf-8?B?TDc2ZXJ4OUt4OXoxaEk0eldEVFI2eCt4RkRjSWVKZFVZYW92ZWRoUDUwaERm?=
 =?utf-8?B?VWkwM0MzbVNib3NVaGYvdVIvN0FpM0VsZHdyVmRYMHhkVWpuTFp5azdMNGN3?=
 =?utf-8?B?VjJEbjVOY0V0SXNoK0p1cXpmOU16NXMyeTBTRUovRWt3UE1STE5zZDZEWUxD?=
 =?utf-8?B?R1NhRnBzZ3NuVzdLK2xUdFBZNGdiRWR1aUNwaldBRGFBSGRIVkNRbmlvNW9l?=
 =?utf-8?B?eXhUd082eTQ2SlZIK2lLVko4ZXlEQ0RvWlRFUndWejRaZDVnNDlnZ1cxLzZK?=
 =?utf-8?B?SVRlRm5XY0RTb1ZMNUI0S3pNMmg5YTg1U1NmdTRGVE9XY1dmZGZoSC9BVVlW?=
 =?utf-8?B?Mm9seHpabC9kd29GdlF3VndIbWlPZDRqVTMvTXlPTTlIaStIY1VsTXM2RU1G?=
 =?utf-8?B?ZmhyVnZkYUNTNGdjcnN1bm42L3UwR1V6SlozUm5iR1dMQ2x5aUFOVFJoMXNB?=
 =?utf-8?B?N1MzUGdaeHJESUFLUmVVcnR2ZTdkOWVDTGptS3VKSytwbGZBa0UrR3FiS08z?=
 =?utf-8?B?THVTS2JzbENXanZvTDJkTkdDdllqbVRhYXN0RE4xT3dkbkt3VTdHZ0VxRmwz?=
 =?utf-8?B?Qnc0WnI1MUlFTnR3L2dZMnlaTjhZc01aNVFwcXJDTkMwckRUbWxkZ250WkM5?=
 =?utf-8?B?dkNvVHdXdnNyeGRlak1qeDFETlFWMVZ3SXUra1RLb2Z5WUhJUGQ4MVlsTFYw?=
 =?utf-8?B?V1pvWEhHUms5bEpSWURoVFZjYitiRDFPcnlNUFNDN2Vua2VNekQ4TGJkMDM4?=
 =?utf-8?B?Z0tUVUJNemtyOHh5VzJaNXJYYnpGS0lpMjhPYmwwdHNKSVBhN3pYNUp2MmZ2?=
 =?utf-8?B?NDJlK1E4SjFKeFM2bHVMTnVkYmIrMkVHT0JsYmpTN0VMNUhDUldiZjRyY2dT?=
 =?utf-8?B?czhqalZEb1pzSUsycndoUWhBcEphR2tPYkplK3UxUW1ZSnRsR20vRlpnRERx?=
 =?utf-8?B?cFNkQzVFYjZZN3g2YzdzeFNuK1FmLzRnQyswbWpJNDVTMkpNNzdlSGlaMXVi?=
 =?utf-8?B?MHF4Tnk1dzFXb1ZnL0JLWVE2SDRtTlZ5YlMzd0xwbHJCU0ZCRzQ2MGFRcFly?=
 =?utf-8?B?MW43THNEQlY3cWdDRFZTUTMzTDV6ZnMrZ0Ntdi9pSnpwWUhsMUdpWkRJY0Zs?=
 =?utf-8?B?WnhwRG1sU0ZiNjl2cHNhM1Vya1hoT0grUzh6NUFrOEl0UWVKWHZsRzNJajds?=
 =?utf-8?B?RTFnR0VLV09QaVlPcFJOOEJIR0JBcDlYWFgwRGpscXRLU2Y5M2dFTHZDWVdp?=
 =?utf-8?B?UWNiRFJwOWZTWnhlRnhoWnI0cWFSdjJ3MmgwNGJsVzBtMUZGb0VGWjdaR2JN?=
 =?utf-8?B?NkNJdCtUMk9mU3R1NjRsNUk3RDVRdjdPWFlMV2pjTFhPNnVHZFFkcCtVZDJG?=
 =?utf-8?B?aFJIcUJldTZKWmpJZXM2UzB6VFZud1owT0pZeFVmZmx0S3RHb0lFR3g5SXho?=
 =?utf-8?B?VXA0WVNieXR6KzFsaEZUSURUbnRaejZoakFRWTcyYmErVzNTVGJZSnl6VUpP?=
 =?utf-8?B?cHhaeDhaZ1RDbUtLbzlUVW9IdVpIZTRpRFUvcDVNUWNrVjhKNS9CcWpmaUk5?=
 =?utf-8?B?YldkSnJIcTd1SDNIY2toOGJGVEZhaHE5OEtYRnIwa0krYlg2NWp0clRTNVZR?=
 =?utf-8?B?OUhaSkdxVXY5OUc2SHpIOUZWWmIwK1lsNEpGSk5iMXJicmoraGVZbElyQWkx?=
 =?utf-8?B?MHhQanFTdVlGekFrazdDcGk4aFNGdjBLR2JCYXduU3huOTJUMTFhSHRDMjlv?=
 =?utf-8?B?R3pVQ3ozNlY3ZUI4eSt0QUQ1ekxzRklQaUlaQU50WTIrdytvUjNKRkJxd3Fh?=
 =?utf-8?Q?R4TtuoZe9zdy/0Gw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d08185-eccf-4b40-0417-08da3f3eacf1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 17:39:25.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JR6Snw7QFV/h/dKpx94/ZbzfWn3xqlXbURQLKB6Yie+9zwkmv69XBas7bYstgdhQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3810
X-Proofpoint-GUID: gDawOR8b6zolHr6NSX5vP9yZOOEimmml
X-Proofpoint-ORIG-GUID: gDawOR8b6zolHr6NSX5vP9yZOOEimmml
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/26/22 6:43 AM, Jan Kara wrote:
> On Wed 25-05-22 15:34:20, Stefan Roesch wrote:
>> Add the kiocb flags parameter to the function iomap_page_create().
>> Depending on the value of the flags parameter it enables different gfp
>> flags.
>>
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
> 
> Just one nit below:
> 
>> @@ -226,7 +231,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
>>  	if (WARN_ON_ONCE(size > iomap->length))
>>  		return -EIO;
>>  	if (offset > 0)
>> -		iop = iomap_page_create(iter->inode, folio);
>> +		iop = iomap_page_create(iter->inode, folio, 0);
>>  	else
>>  		iop = to_iomap_page(folio);
>>  
>> @@ -264,7 +269,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>>  		return iomap_read_inline_data(iter, folio);
>>  
>>  	/* zero post-eof blocks as the page may be mapped */
>> -	iop = iomap_page_create(iter->inode, folio);
>> +	iop = iomap_page_create(iter->inode, folio, 0);
>>  	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
>>  	if (plen == 0)
>>  		goto done;
> 
> Shouldn't we pass iter->flags to iomap_page_create() in the above two call
> sites? I know functionally it is no different currently but in the future
> it might be less surprising...
> 

I made the change.

> With this fixed, feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
