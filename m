Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941C752F29D
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352619AbiETS3u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETS3t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:29:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BE4F7480;
        Fri, 20 May 2022 11:29:47 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24KHSTtR022572;
        Fri, 20 May 2022 11:29:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XV/7Z3Fm/008703ykcUPEt0acHdaQT/j5x+oZbVFYxU=;
 b=fwn46j7FPH10YDPMy8tesKnJO1eQn2Ld75MPwhoDccxtojDfIY/O8T5Fgq1nO2+NMcjk
 2JJVS/Q4MIWncK29Y1dl4ysHRf4CytEgUR1KCmqqKTHKVtcs1xHPf+N4HDb4mXwTlpuK
 qjTcn6Q8ockIkcpJyK4s0ex7MKtZNpS9VJE= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g6bja295n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:29:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfEsPsORtkok3eVzk9EYlbT2cNdqHyUmVh/uJoA+96rhziOpMDRnjBoI2P01twadXk/SxYDp/sVLVFyEdXmYLOkluO8jEn7ay6qIurMOzT+RBvpsPTYQ6ccJCMJqtDyoalzqcZ61Z5YbKqQFL/VXs1w7PDOJA8OAI1/GXrdL9T8dsS9TdV/LlRtmLSVtY/NFCqIXpPwWRO+0DYOZWfVS0DaRJAT+XRwKGWOehISqTWxMT0tRu9Agp5oO0/QT2R5aEc9x6unfkaWiAiHpenKCL4oMbppL9EMLAtMUT3tL/l6Peq4ZOnsp1F8Vz4TLDLj/vgwPyn54vnPVUDrSpBHUrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XV/7Z3Fm/008703ykcUPEt0acHdaQT/j5x+oZbVFYxU=;
 b=G43txWY+rzMllM+DUxz7spTLgmo8fIrsi8iUrD34Kh9nTFLbGSDrpu6T9NMdR0nAhgu/LvNc0FDmpztutGbflobhiwCLipKLlv1D0qP/gwMk1aoHR3qyT/7D/d4nr17b7kxIZ7UsQlEk4jdDjOVimPP9GYs40xU/1nWbzZnuRR+HqTptyUck5aIp6F5C1VlmfX8ISYv+y0sYHugYDA4LuR8R5/RciZmX7YUcHY44VUKhT1bvpXaea5mwPuW8e3RvBbXfsF4FKQElRxI8ngbtADNp+idHdG9bxHclQrkb83iy7egSf0IkS7wWnclfxcxKDJPRhESLXbjfEOof8rotHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB3477.namprd15.prod.outlook.com (2603:10b6:a03:10e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Fri, 20 May
 2022 18:29:21 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:29:21 +0000
Message-ID: <bef6d6d9-e5d2-22a5-d2a4-cf0ea8d1e724@fb.com>
Date:   Fri, 20 May 2022 11:29:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 04/18] iomap: Add async buffered write support
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-5-shr@fb.com> <YoX++EWdgyNVOQAI@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoX++EWdgyNVOQAI@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab4a5d8a-a429-4b9d-89c1-08da3a8ea88f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3477:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3477577A1D63CA0B3B36D6EDD8D39@BYAPR15MB3477.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Le9zk5PuRzRTUQqzxvjoLwlIMQtXbJjlkETFNH7h48DKUg9+ScAA0ZPiYtsJwfmtkHeWCn27Tqqv9bWmSR4AZqVu19cUh4+3ascnA2BLbNibNPQUxiPq2rQANbpJvLVdqYJLd8JdLHJyaIR3IRMiV2kZDftmkqZCP3+POJjLL7dB2V0gTZo/TyAvuJ/0bvRT/IUBlPDoSZBop3Vg+mSkLqUki/KdMbXUUh4PxulRtVMxghQP28XbP1G+LX2HyPjHbcWpiAt2iC7fDHLuA9nR1JG+7mqA61RSBNbf+n4Y9F91w7hjgqRA/BWeJyoLkvQ7x3XC8eNjnjmhx/vonjLUypUya9yv0kEtnLDQdptH+tiYPk+s27heoI0WjHc29yM05zihs4jgdggL8cnrvk+OkVeoqPc3wcIhlne5CU+pZxJWRj0pM9zJLFzgeVecprfZHXtaiUUzlfWCIMgtxmDhLV3Q8scL4eLFQKnxbPN1HyOX/VqdjG3LiV9hpKw5sSU/e0R/vPWIfO7HYbdbG2h/8Fe2X4Fi0les0TBvk8qe0KiIztHesejlO5BI94GVETntb1S6HWV7/l8SimT8SfBYKHAEQIFQlm0bUk/YI+8fB8gVFBA8hcSy7q8CLUAQjBJgWCxjQYhWFU/qInlpvjvd+RHLUtk42hB72NOJS9tNT4cJvKm2OTZxdiSrm9m4Own5zhICkB6sPuk5NuJ4WLwsmPyzNDP4KVu3ark67rcHA1VE5sJ27Vl5hc5yFsGNdGZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(2616005)(6666004)(2906002)(31696002)(6512007)(6486002)(53546011)(86362001)(6506007)(66946007)(66556008)(5660300002)(186003)(38100700002)(31686004)(36756003)(66476007)(8936002)(6916009)(4326008)(8676002)(508600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFMrUHhpQWlWUm9MeXd1ekRtcUlCRjFrVEJDcDBSdUk5d0NtbWJLWUFVVTJC?=
 =?utf-8?B?dGZDMHF6anlsdlZKSzV1WDRFdlpaZUJaRytRQS9uZHpkQmRlTklzaG15TjJP?=
 =?utf-8?B?bkhybER0S1lFSHU4MGFjdnVoejJpUVJmdG9sVC9DUSsvSlU2d0x1em5McnJt?=
 =?utf-8?B?RExCcU40OEd0WTlvSjVGNVRwZFUyMFR1ZkdnRHpDT3lQME5OTk1JQXMrcGsv?=
 =?utf-8?B?aVFBNWRtSEtjTlMvUHVJRGx3SFFubkFnN292ZnBrVXhrSDJEeTk1NFVzdUdv?=
 =?utf-8?B?a0Iybk9MUnhCVEpZY0pmeUNQNjVYUFFpZ2xPMWQ5SncyYTRhdm5XUTc5Umpm?=
 =?utf-8?B?VzVkU2o4MmFIdE5lYlFRQm5rcG51SXJ0RGhiU2ljL3VTYkdjdE1Vc0JQVHNo?=
 =?utf-8?B?QXpDM1VWZmVJdXNMRVYzUUZEZWZvUWVMaWVlaElkMG5aM3hKK1Z5YVhXNktM?=
 =?utf-8?B?RkRlL0lhQlBXSTJNUkI2WWpqS3NXeUxWalQ4blBZZGNxb0VQZmR6NzcxaXlG?=
 =?utf-8?B?bFhmTnZQSkF3d0Y4SUxrbGFVQ2N6RTJYQy9kclQzaTNzelNnankwMWUwZUVT?=
 =?utf-8?B?RSs2UFJSRFRUeHdYVjQvNTcxR21XY1Qva3JpQVBiSzRzdTR3Q2t4YUEvWjhR?=
 =?utf-8?B?RjFqNEx0R000OWl3eGJNam80SE1ZNlowMVZpbTRQd1VhMnhGdEtwZGEvVUVI?=
 =?utf-8?B?L1dGeEVySmptaGYzS3J5L1F4N0lVTGZWOHZaczlFTUhmTEtqM01SZTFsWmQ2?=
 =?utf-8?B?UXZOV2xGQzBpZW9PU1dxSnRUT1djemZGaGZyMTkvTVdyU3RiaGpCTkFya2V3?=
 =?utf-8?B?aUIzTHpER3lCd3I1eTF5aWFjcllMN1E3NTlHcm5MOFgrQktPQVEvT1VrZE9N?=
 =?utf-8?B?Rm8wYzI5cTdobHdienJJUlZVc0hEZDE1T2xYM2pDbXZiTWhqSWw2SjNwNzd3?=
 =?utf-8?B?bTlqL0ZSOXY0S2djV0haQklJVW8zZGVYSmZlMVYxNERsUktOcDd0eUJxNXl0?=
 =?utf-8?B?WmdMNytKaG1Hd0NYVTd3ZTRpemlLS3dBRFBjOFFJVkQrbkhkYldOSXNTUldt?=
 =?utf-8?B?YUhERXphNEhaSU9lRzFFei9KRWREd1E1RlBVSlRMK2Ezak5IN0JWdjd6THkv?=
 =?utf-8?B?dFp1RUlBbHM1L1ZFejVPeHRqY0FJM3JkVWNBTlhKZXRRNlltN0RZR0t1cTNT?=
 =?utf-8?B?eWcxZVU2UTI2em92WFlGdEl3UXlXWDZTOGtwYjd0YlJreEk1NGZjN2JhK2tt?=
 =?utf-8?B?L0NmSWdkZm0vTGV4akpIaUFrTkw4Z3VvbndJNGRidVA5Ums3dFgyRTY0TWZl?=
 =?utf-8?B?eGRtUFRWTjR5K01rZGgwWEFGZ3Y0Q3UzbVl3SW4wNVluMkpzNzBkRzVSQlhs?=
 =?utf-8?B?TFFzZDRUQUNLUHgxTEk5K0RrL01Bcy9QMXVhV3BUazMyaUdSYTYxdkR2T1ll?=
 =?utf-8?B?dFk5L0sySFNqREFKTTNjaXNnL3BJY0xsVEtzWVZkckltOU5CRXg2ZCtJemJm?=
 =?utf-8?B?RlplU2xUbVcvOW9JeW9TM0hUK3NabWUvZklOd3FqUGFURmJnZEpncUJQcVZR?=
 =?utf-8?B?b0ZiVGNqejhGWlJXd3o4YjhpMTRibEFEOTdrbmFyNDNlQUpOVjBqUVRWV0F0?=
 =?utf-8?B?VjRTRlVPUWNDQ0t3VUduMlFDWHcwNzBEWUhqQS9BUGpqVThuYjJDUzJMZVJu?=
 =?utf-8?B?S0hkV3NmNlZLd21YWDdwWFVONkIwcU1wQzNOZUJvYmN4cFpQK2dmMHhwdGRn?=
 =?utf-8?B?RHd0cStaTUIrWDZXRmgxejFqcytHT3dSTXFFMVBZMUN6NHVUVW9CV0I1YzU3?=
 =?utf-8?B?SlVjNFRHTDlTSXlXY3VkWXB2bmJnc010OVAzV3VxdWJJL0hqRnpidXJMS1p6?=
 =?utf-8?B?c3pSWm16N2pQM1kza0E5M0VpQXgzb0MwNE9QZHZTdGl3OU9FSDBIZk5HcE5Z?=
 =?utf-8?B?THE4bEdqdnFYZmxPTGN6WUNVazN2SmtkUDREUk15S25KVjNCNmFWd29nQkJK?=
 =?utf-8?B?VHRVNzJKNHNhbFlDOGpPNkZOM0dJREZPQ3V0ck9QSFlDSityYkQ0NmRScWJW?=
 =?utf-8?B?emxjd3RNSEJma1I1WS9iMXRsTjRObk1sMXF2d1dodDdjSGp5Slo2RkQ2N1VR?=
 =?utf-8?B?RzJXbW11NnMvakE5WHBZUXpEbHRyRVZnM2FXdklONFJmRTFGZmF0d2tIMlV5?=
 =?utf-8?B?TVU4b3gweEErNU1XL0ZVZkhwNFE1K05hLzM5cmN0UitnUnlKanMxRStoZ1RU?=
 =?utf-8?B?bHo4UkFuTG9LbU13VmRjM3FBOVNPU09xRGRmNStFcmxhMVVjek5rL0Vna3FW?=
 =?utf-8?B?RmdvNlVYRW9wbThCdTd5OFQ1RWx2RlZBWm1aTFJldnd4V1dOTlhtaWlzb3Bh?=
 =?utf-8?Q?hNiTFEQWhZpkbpv0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4a5d8a-a429-4b9d-89c1-08da3a8ea88f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:29:21.5342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlZ6PsxTMWMLNud3meqBVu5lHg2bNM0sKPE6tEJRPEt4oGHov6pfAFLBlvl8LkLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3477
X-Proofpoint-GUID: KS-htsWDj9XszxLeiW_S7k42wFyiRday
X-Proofpoint-ORIG-GUID: KS-htsWDj9XszxLeiW_S7k42wFyiRday
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



On 5/19/22 1:25 AM, Christoph Hellwig wrote:
> On Wed, May 18, 2022 at 04:36:55PM -0700, Stefan Roesch wrote:
>> This adds async buffered write support to iomap. The support is focused
>> on the changes necessary to support XFS with iomap.
>>
>> Support for other filesystems might require additional changes.
> 
> What would those other changes be?  Inline data support should not
> matter here, so I guess it is buffer_head support?  Please spell out
> the actual limitations instead of the use case.  Preferably including
> asserts in the code to catch the case of a file system trying to use
> the now supported cases.
> 

I was only trying to make the point that I haven't enabled this on other
filesystems than XFS. Removing the statement as it causes confusion.

>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/iomap/buffered-io.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 6b06fd358958..b029e2b10e07 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -580,12 +580,18 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>>  	size_t poff, plen;
>>  	gfp_t  gfp = GFP_NOFS | __GFP_NOFAIL;
>> +	bool no_wait = (iter->flags & IOMAP_NOWAIT);
>> +
>> +	if (no_wait)
> 
> Does thi flag really buy us anything?  My preference woud be to see
> the IOMAP_NOWAIT directy as that is easier for me to read than trying to
> figure out what no_wait actually means.
>

Removed the no_wait variable and instead used the flag check directly in the code.
 
>> +		gfp = GFP_NOWAIT;
>>  
>>  	if (folio_test_uptodate(folio))
>>  		return 0;
>>  	folio_clear_error(folio);
>>  
>>  	iop = iomap_page_create_gfp(iter->inode, folio, nr_blocks, gfp);
> 
> And maybe the btter iomap_page_create inteface would be one that passes
> the flags so that we can centralize the gfp_t selection.
> 
>> @@ -602,6 +608,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>>  			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
>>  				return -EIO;
>>  			folio_zero_segments(folio, poff, from, to, poff + plen);
>> +		} else if (no_wait) {
>> +			return -EAGAIN;
>>  		} else {
>>  			int status = iomap_read_folio_sync(block_start, folio,
>>  					poff, plen, srcmap);
> 
> That's a somewhat unnatural code flow.  I'd much prefer:
> 

I made the below change.

> 		} else {
> 			int status;
> 
> 			if (iter->flags & IOMAP_NOWAIT)
> 				return -EAGAIN;
> 			iomap_read_folio_sync(block_start, folio,
> 					poff, plen, srcmap);
> 
> Or maybe even pass the iter to iomap_read_folio_sync and just do the
> IOMAP_NOWAIT check there.
