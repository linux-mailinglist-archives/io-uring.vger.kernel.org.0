Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A33535383
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiEZSnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 14:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbiEZSnV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 14:43:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A002E089;
        Thu, 26 May 2022 11:43:20 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QG4pJe029005;
        Thu, 26 May 2022 11:43:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PCCiPPlIUmnYd6BX6A4dtiArJiRkLdlXWLBD8z8T00M=;
 b=SWpPhJjSdg2QooEaY7gzGX4IijEAjaL9aSZGqDEsW9mK8t35Fkynsyh3rsm5JSsUmi8V
 qctt+PZgP6lImUdOe9FIBaVu4qEqTyQUGrnkiphIjD6jfNCqBe2SDJkqw7/w/SDc5FQX
 qtp8I1kK7bqKI5gax917NOSqvfaXaBM/xhI= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g9puas050-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 11:43:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEW5d6Yud2D+LLcHd83pvfUatisWSrIso2aXbbNDaLTRcoIPH7UxcFed/yBklFB3jDgcFncdY1RVE2PZ9guWHuRvamG9nbzgVWlRiWvsLupHFr/sEY2MIB3MVzuesblvooIg9XOcjpmOJ43k5nTH8Vc/L+XGKfVx3IqaCsjvBMbuf1WZhbo4ytx3f7zNUt7d+zize6EOAj5QMCLxBOt5Ayp1jZP0Mnl0Br+I8mhl4t7mxMHKa9c9/d8/pkX2/KolKavFXbx+QzGRXAuVf33RiRZDJe6nprVVKyIEFPJ54lqcUiThhfFcD3hwDbut6l9/4g7v1QqAORf0wguamL5+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCCiPPlIUmnYd6BX6A4dtiArJiRkLdlXWLBD8z8T00M=;
 b=oVvpUT1MpAMPBvxgYP9O/Vs/T2nZannz/znccoQp7a4mY+lWxCLG+sMyGRiNsXmKCjInGEbrEwLgPg+aBT2nUiACV+Phal5iFY5rJSrZdBe8ZqjtjENEJQN8S0rycbVMfBzVH0xF6xrFOUgC9pkimDlpqcSbMoeLr22jsSdnjaZtSlhlw/bQRapb1ynMCZV2FGlww1nIeY6J9sW8niDDBD2a5CFhCqs7+u2XAwKkMpak2FoQb3CH15ZfBfmC+moIH0m4mslCHc1IftoU/Ym/TCPPwDP9Q5dSQPv+z7C8lxmCH+8+Wy/A2DSR99ooZnljy6JjBe0CRR6IzvOxxvTMmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by CY4PR15MB1301.namprd15.prod.outlook.com (2603:10b6:903:114::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 18:43:03 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Thu, 26 May
 2022 18:43:03 +0000
Message-ID: <6c17c3dc-618d-14db-93cc-95a880a42225@fb.com>
Date:   Thu, 26 May 2022 11:43:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-5-shr@fb.com> <Yo/GIF1EoK7Acvmy@magnolia>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yo/GIF1EoK7Acvmy@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0051.prod.exchangelabs.com (2603:10b6:a03:94::28)
 To MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 993f4250-d0c3-4b09-3c48-08da3f4790f0
X-MS-TrafficTypeDiagnostic: CY4PR15MB1301:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB130100EEE954BCC340857FBED8D99@CY4PR15MB1301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Rp91izs3tdSQu6igF73RVU3Zj7iJ8FI8E4sc5PAg8s32cMzQe13LS6oq/aHCdfEqPwnwY4AyxZsnYlwaTHt99p3ssR+nd5Y+IFWusqfZVIY1BuH1Mz4jP1CREBeGZxXO0RbYQ1CNmScxKCgV+8tNx0EPkguJfQ20wbJ/mKJiuFVa5L/SIsudBi3z9mzymC3HlYyz/M0wuu0y+NP3cbUKuwKCIXLD/VEE4HXa2LtX0ooL+SiInk16dtxdnFtuw4DW/YcYE7+wLHcyEDe2ahzwFl7TjAh4h+zcVbnnOq1sYdig1YFlJwjcMUcidtFIJsL6Z9ta86WFotnsSMYf72fbNZ1fAdUUlFxY9efYVXtz9lQgl7Hs3YnI2CddXzoFQqN2xB1ba1HYe5iNkQ8MNgdU1qbNjkv9t0uea6KuY9Kj8eOKs6/SyAhKVWHFxXfyCxbmcwOITRgT1z3XzH4bkOw8xW248IQX3c4CKGQomlLuyidVZ/iWBh56R/JwEcSS7Dsf0jItb5ujq2w98dlGOEsksqrVwfBOI9XCo5gr8BtAW1+IXDgMcQ/eup6uwW/FhM+iZML9eFqYnXk/Hg9f8p2J/fkdqG8URHQzbr2nqT4GI5nXKiKHz8S4hV3QTr60kiRlekCn+YKZB3Wk1zSthepRnsEJ8CyAI1CEhgpkGe4bFrZSDJF3p2jEQMx9mH9dLpbBjBIcBZMISv5l4IrF+Nq1CJaWqV36lcsVJOwB3KXLIQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(4326008)(8676002)(83380400001)(31686004)(6486002)(31696002)(186003)(316002)(2906002)(508600001)(38100700002)(2616005)(36756003)(5660300002)(6512007)(6916009)(8936002)(66946007)(66476007)(66556008)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3ptSXM5SFZTUEs1UjlhdnZEdFpDZlJuYXU1NUxDc1VLVGRuc05OOWFJa21L?=
 =?utf-8?B?YlJaSlZLZGVKUUxVbjBGN2d0ak8zYXJDT1g4SG1BUXVMU0kvRGI3d1BPbTdu?=
 =?utf-8?B?NnBWN3cvT0ladWk0YjF4b2ZjQW9Sb0RGRXRRQzJZUjArWWc3bG5pbmtVTTNn?=
 =?utf-8?B?OWI1QlM3bVdEVTY3RUNzRk0rRTVrZURkbnZFUzFFYUpyd20wUkJVSSttUXVF?=
 =?utf-8?B?WlZEY0dwZThQUjlobGxVaS85eExPMzlxQkJyNXU5VHU4SWFSNVpJTzdLZXJr?=
 =?utf-8?B?c0tIRExoNzVtcU5YQVhOQWIyQW9WSWtEbDFHZXFIRTdkZkVkY0hFN3dYZ0xr?=
 =?utf-8?B?dnhmQi9HYXBPOHFlcnljNDhvOWhrZGFXeE9YaHVjajJUemtQYWk5cWE4ZURq?=
 =?utf-8?B?RDFNT2R3ZGJqS2tHWHpJYmsvUzBIRm1uTUltTHFSeXgvYUcyQWFuUHZxaCs5?=
 =?utf-8?B?eTRjSmNicnpCZThJaTllUEFIWDM3SWdaTmljZWJ2VjJFOExFUG9FVEtGTUdv?=
 =?utf-8?B?QmtUNUFwWUNHcFpKMjhOZGVIdW54WStnOXR4ZE9lcHUzOWdtV1ZCMlhmY0pK?=
 =?utf-8?B?UDFqS3pJTnE1TnZoOUtVZG9zMi9YTjNOTUFpNTZZUnlUVHZVWGlqNWxiMWxT?=
 =?utf-8?B?ZEZxRkpySzVJZEVXNnZMWWFIOG95R09ZTGV1bnJjYzlJWTAzeXhWdDRxWWNY?=
 =?utf-8?B?MUIyZlducU5KWUJ1c0NrNzRGekxiR0ZoTTVFWktMNTh1cWNQb1NMQVhzZERC?=
 =?utf-8?B?VHg1OWhWY3V3WDFwQSs2MG9yVExaYUh3Z0lBREg0R2ZMZEtwa3R6cWJ0Y0Zh?=
 =?utf-8?B?RFFSSURxMENlWXZWOWZDNjk2dGlXTkpMa1Y5TTVaaGNzNDVHRCtQNEx1V282?=
 =?utf-8?B?Q2Q4NnNuVVJvNXUrM0tma3V5YWZnZlFCUHA5U3VoTjRIZk1DUTNrYnJ6SWhu?=
 =?utf-8?B?Tnkva2JwYkttOWx6NVVBdHA1dmtmR2JWQjZta2VKenlreFptNjM4NkZuKzdo?=
 =?utf-8?B?c0J4Qko5d2h1emxBQXZKSFdEWStsVHEwa1NhWTIvWWVoWndrNnJMT0RjbFlz?=
 =?utf-8?B?d1BDR1krdlUzbU5TRU1vS0psMmRqS2tsSlU2c0s4QXZtU1k4U0hFbEtLQjhD?=
 =?utf-8?B?QjMrTWpoSHY5Nk56WVRpRTJHaE9xczNQU3FnQkNYTmJ5Si8xUlk2elZxa0JC?=
 =?utf-8?B?azVzczhuYkh6NHVaKzFBd1BKNnVSWHZ0aXFTKzlFRVhsZ3ZXeFYxRFArZi9Y?=
 =?utf-8?B?NnVPa3IwWkg3V1NiYzhpK3E1S2FDWW1CNVFtd2s0SVFRKzQzVEJjUWhoMUFQ?=
 =?utf-8?B?aXVkK2pSUmFGc1VxRUdqU1RweW9wTGlxN0d0M3VFZ1I4ODdOejl3UFg2dUg0?=
 =?utf-8?B?YWxRdlE1bmUzOEd6T0NMK0pkcFRCWjQ0cjdyOThkZ1VIMFlqd2R2empGeXEv?=
 =?utf-8?B?V0ZITkpJWHhSdVpqOUpSMG80azNFZlJNcjVLbnRKTWFlZDNsZWhEU2p3RThy?=
 =?utf-8?B?cVNuU2lPSHlPTWNZMlVNSU1kaUVtWm9rZFFBMnRhTTVaNmFPK1NlLzNJS1c5?=
 =?utf-8?B?R1VmZVlKdHI3VXhyRFBSWHpRQVl4OWFoL1lmTUp3THFUQjdQTkM5UUp0czVu?=
 =?utf-8?B?c3Z6QUxJcTFwNnFLTTVNd040MHNRSzhQbGV5OStBZUNOd0tRR3FCMWRFaDJl?=
 =?utf-8?B?bmlwcGlLc08yL3YvZ1RndnJ1OVhUSjYzN2V6YTR0ZnR6Vmp2Wkc0azhwUFc1?=
 =?utf-8?B?S0hKRVBEeXhRRTJORWRiSjBWbTYrcUl4dUthSGZTeU9YS3JqbkVPb3NNQ2tE?=
 =?utf-8?B?TzU0TmdiUThQRG5ST1dxcHFicHhpeUQ5dzR2WTBkUFp2R0M2aDAwVnNyMG9Q?=
 =?utf-8?B?S1A3NkhOVkJKK3gvT1ZZYUgwK3Z2dFBxand1NGdFd3JtaXcxZElpQnk5ZkRm?=
 =?utf-8?B?SzdML2t0eFFIWEY2M1Jwc2twak82aXd5ZFRQbktGOVdPeUF5dXU4UEVKNjFt?=
 =?utf-8?B?RmZQOEc3WHJacFJVZW00VzlwSktxUWNhd1IyS1JLczlDWjR4Mnl4Mm91VmU1?=
 =?utf-8?B?NDR6cFFlNmlBejZRV096Tk9Ib2syaFFsZlRKK2hIMmIwNjN5WmttYXVXNGE3?=
 =?utf-8?B?R0NPWmhOdlNvb0U2VWhNRXlFaTMwU1JhTXZqUG9DQ0ZZb1dhanE3YUtZWlZ5?=
 =?utf-8?B?UW1RVldSeUpPemZWaHFaeGF0UzlnREtVcGNzYlNKMm9CRnFyVjZ0SjFzaUw0?=
 =?utf-8?B?WkQvOVpwNHBNeSsyemNNbVQxaVdxY1BpbXdZdkJSRmYyUHBYL05LNWtQZ3Fi?=
 =?utf-8?B?MTBTSlpOT0hIQ1RCOGliNDhwTCtnNmRJNDZXY0FtbU02aGtKcTBJc0FzcXd6?=
 =?utf-8?Q?JK0yG3NrVVzGOFw8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993f4250-d0c3-4b09-3c48-08da3f4790f0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 18:43:03.4643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2b3tB/kJQLzNUBd2Op5EUc9B175QJydY0FP6nqYhlOLsUNoD/F73xLoKT4BJ3wr7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1301
X-Proofpoint-GUID: KvaIVsvxaERaVcIrDUrxBfMEzEFhDb67
X-Proofpoint-ORIG-GUID: KvaIVsvxaERaVcIrDUrxBfMEzEFhDb67
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_10,2022-05-25_02,2022-02-23_01
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



On 5/26/22 11:25 AM, Darrick J. Wong wrote:
> On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
>> Add the kiocb flags parameter to the function iomap_page_create().
>> Depending on the value of the flags parameter it enables different gfp
>> flags.
>>
>> No intended functional changes in this patch.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/iomap/buffered-io.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 8ce8720093b9..d6ddc54e190e 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -44,16 +44,21 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
>>  static struct bio_set iomap_ioend_bioset;
>>  
>>  static struct iomap_page *
>> -iomap_page_create(struct inode *inode, struct folio *folio)
>> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
>>  {
>>  	struct iomap_page *iop = to_iomap_page(folio);
>>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
>> +	gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
>>  
>>  	if (iop || nr_blocks <= 1)
>>  		return iop;
>>  
>> +	if (flags & IOMAP_NOWAIT)
>> +		gfp = GFP_NOWAIT;
> 
> Hmm.  GFP_NOWAIT means we don't wait for reclaim or IO or filesystem
> callbacks, and NOFAIL means we retry indefinitely.  What happens in the
> NOWAIT|NOFAIL case?  Does that imply that the kzalloc loops without
> triggering direct reclaim until someone else frees enough memory?
> 

Before this patch all requests allocate memory with the GFP_NOFS | __GFP_NOFAIL
flags. With this patch no_wait requests will be allocated with GFP_NOWAIT.
I don't see how allocations will happen with  GFP_NOWAIT| __GFP_NOFAIL.

If an allocation with GFP_NOWAIT fails. It will return -EAGAIN, for the write
code path. In io-uring, the write request will be punted to the io-worker.
The io-worker will process the write request, but nowait will not be specified.

> --D
> 
>> +
>>  	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
>> -			GFP_NOFS | __GFP_NOFAIL);
>> +		      gfp);
>> +
>>  	spin_lock_init(&iop->uptodate_lock);
>>  	if (folio_test_uptodate(folio))
>>  		bitmap_fill(iop->uptodate, nr_blocks);
>> @@ -226,7 +231,7 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
>>  	if (WARN_ON_ONCE(size > iomap->length))
>>  		return -EIO;
>>  	if (offset > 0)
>> -		iop = iomap_page_create(iter->inode, folio);
>> +		iop = iomap_page_create(iter->inode, folio, iter->flags);
>>  	else
>>  		iop = to_iomap_page(folio);
>>  
>> @@ -264,7 +269,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>>  		return iomap_read_inline_data(iter, folio);
>>  
>>  	/* zero post-eof blocks as the page may be mapped */
>> -	iop = iomap_page_create(iter->inode, folio);
>> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
>>  	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
>>  	if (plen == 0)
>>  		goto done;
>> @@ -550,7 +555,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>>  		size_t len, struct folio *folio)
>>  {
>>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
>> -	struct iomap_page *iop = iomap_page_create(iter->inode, folio);
>> +	struct iomap_page *iop;
>>  	loff_t block_size = i_blocksize(iter->inode);
>>  	loff_t block_start = round_down(pos, block_size);
>>  	loff_t block_end = round_up(pos + len, block_size);
>> @@ -561,6 +566,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>>  		return 0;
>>  	folio_clear_error(folio);
>>  
>> +	iop = iomap_page_create(iter->inode, folio, iter->flags);
>> +
>>  	do {
>>  		iomap_adjust_read_range(iter->inode, folio, &block_start,
>>  				block_end - block_start, &poff, &plen);
>> @@ -1332,7 +1339,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>>  		struct writeback_control *wbc, struct inode *inode,
>>  		struct folio *folio, u64 end_pos)
>>  {
>> -	struct iomap_page *iop = iomap_page_create(inode, folio);
>> +	struct iomap_page *iop = iomap_page_create(inode, folio, 0);
>>  	struct iomap_ioend *ioend, *next;
>>  	unsigned len = i_blocksize(inode);
>>  	unsigned nblocks = i_blocks_per_folio(inode, folio);
>> -- 
>> 2.30.2
>>
