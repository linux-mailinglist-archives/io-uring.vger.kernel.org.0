Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DA84B902D
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbiBPS1i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:27:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiBPS1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:27:37 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2788C114A;
        Wed, 16 Feb 2022 10:27:24 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GFaHk0009958;
        Wed, 16 Feb 2022 10:27:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KR7HMjth/AbQBrdVyM8f7VkZPu3C89+raIDmiK+s+wA=;
 b=p5h1VbsTjc5N1Z9k36XhJhLG/4jBTDXZ0KL0XJigDZLACzOW0kT8mab80Rc020+nHnmh
 EZZanbNpRnfoZ9XfcDqEWsw78X4naVv7yITHeoRiXEziq0Ol+aTQUBDyw2FVlKRGqvuA
 HVmopz9EL92pvvhav8OoUE7IoDK8YY97Wy4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n4mpda1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 10:27:22 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 10:27:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLIuOXfhGsJATeDJtKEAmXChOfPIzK/BWmg7bicLZFVlwom8Uc/8pCdkmIMp+6ePhxF+1wfZIdZVbKDXjAHTz2tn0GRqJrOPQ+V0QzwzMVwHvvbtZZzcjgPtndV5FyuJLoqmY6ttMHnt6/N2oUwdvwjkeT0cRzfydAUWjI07OW34odS2fD12LocAO0c8zZJ1HUFLq2kPpajhBI0MUKD3JV/0JCKxDjgg0n6EDhQF1BKN+xGsoABl2joLeEWDhbrKEBPVzozJeH3heXejeQUvTrzEZ04ILwWErNQmiNmtnBdWmEf8DDnlyfV4nLhBSLxsgfemiAwxytImgrc99n5oPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KR7HMjth/AbQBrdVyM8f7VkZPu3C89+raIDmiK+s+wA=;
 b=e6oTW0EnaOXsG+WVn+17nU2Fzjv4SkfJgoo3osPU3PUgiyjhdOYog1IuTG+eC9jCFqViVwJskovxZTgWunFCOZgDOulr56pIyKm1dgUFxxC/xdvMM1djSkJG4CmQK2EnxCGjoVfKk0YIC0GanuEjfCQaIyUp+a8LM00Gg+w3nSLQgPE0eVG6J4QZ7E2TQY96dBo6S8Z8Rqwy8HLEwq88QmHHTFXeVnAqnzNVmclPwuKmZG6yaVSWWhbomqrKVlI1JlCwWlJz7YFh0uuh5W2Ma9UJxlG4JJqkkFwrWlWdi7cn1QN0KROoz5tthNVWw8gpezEICkUQbCEPW67w0AM9oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by DM6PR15MB3959.namprd15.prod.outlook.com (2603:10b6:5:295::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 18:27:19 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:27:19 +0000
Message-ID: <005821a8-6b6a-35e5-baf0-04bd0146250a@fb.com>
Date:   Wed, 16 Feb 2022 10:27:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v1 03/14] mm: add noio support in filemap_get_pages
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-4-shr@fb.com> <Ygqam9fgYXZeqK2H@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Ygqam9fgYXZeqK2H@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:300:6c::34) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 447a1064-d4e5-4197-5252-08d9f179f788
X-MS-TrafficTypeDiagnostic: DM6PR15MB3959:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3959822211A63E8E07E5990AD8359@DM6PR15MB3959.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pJxySMKOevreSfAvP3k3jIH8fnYyII657jczlWRAOeR9Ck4Sm7szic6icLBi4iipHWsdmDaABpwG2TWS7iFD1f7pSnuJ+ksAM13k2YXtp8znVm63kjmeYfm3brpIJf0VAHn/zlMYDGC0tVavn7ySWyzjMRvG/504FwuGO69scFRCOG6mBqZKML2WwY4wH5zzKuuJAUAgfljz83VAkSho99WBWzQnIvGln+/L9ArB77ORi7+2Cg2UcMoKvx8RoqQPk4TxEOTUlbylIC2o+1tT9o+jdpqWtrjU82j+lXaqrPN4xQXzYktLRIji4JBUZFXPsX/fGYtxrR9nVd9Mpkna7o+hcqsu3xHQsSKaPKTo+zWeiQPbFxdHMrv2Ee4C9XAP3qabvUbpQwCqYtl4h4akflQjkpJSnQOo5xcIMebKF0LeuhEvZreIi+HgD6VKJS+cgm7Lo5ecbOZe/qM6g5DLUjguFRWMf0yZWzUQYkNhNKBi+ZVgrk/dQ2APV9pVQDG+xzGAgSF5z0svK7t5NbsKYF7L0DRsTAq9IznbyhccMn9o5rTeq5VgWsfCswmsxygzchFCm7KOC0gVcXys/fpzs6w9Mdm9ql3T39PxJ9veKreIriY+YhP4pGw2UdpRuuXo42XwCP9zKlrGHul/sVXkwGF869ZrnWoE+LKn7xgz11SnmeEQR0wQO/K49iCyLPxfTsdR5HVk59pH/vSwv3DUy0Ui+d/XigdmVICI57xWEos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(8936002)(5660300002)(31686004)(36756003)(2616005)(186003)(31696002)(83380400001)(86362001)(316002)(6916009)(66946007)(66556008)(66476007)(4326008)(38100700002)(8676002)(53546011)(6512007)(6506007)(508600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0lVWkNNTWF1UHhMRnBvRGdMTTl1WEFZUmpJRzc5UTFQV0dLblRkNU9NOTlM?=
 =?utf-8?B?cnRwNHhwUHNBcUpxMGxOejFUeXlRWDJqeGtUKzcrVTZ3ZHpDN0pCckVmcktT?=
 =?utf-8?B?SFdxY3VOM1loQy9RN3RoSzVQZTZOZTJuc1g3SHBMNUllNUZJVkhheGFIZXEy?=
 =?utf-8?B?L2g0elkyQ0plM3JxemI5alRTb0l5RzFCY0RzV20zMFZUbDVOTzZTNlQvOURI?=
 =?utf-8?B?U2pZVGp2SUM3SGhoM2dWUkR1WFI5L044c2ozMS8yVVJmcVd0UTFMTGhQczkv?=
 =?utf-8?B?a3VLU2crOHk2ZVpWVzJFYVhXQ2tRR3Zyc2hWQjdHSmVZL1phRGpUVE1nMWcx?=
 =?utf-8?B?MllJTTJGSmJjWUVWcFFXWW1DU0RtamFZclhZWXg4Mm1oNStibW1kaTlHZzkw?=
 =?utf-8?B?R000ODR1cFJ1NGdoSWlGQ0VEZDFkWUQ4YUlNN3RRWTZMTE9mVUY0RlovQkRw?=
 =?utf-8?B?a1NiU3JuS0t2dHlNY0RhM0FtdmhncG1vbWY3c09ST1VWS3dHVHZwOGV0d2hz?=
 =?utf-8?B?MXVhaHJDRUtjL0NKNzBvb2F2MmFUNmNab3hKMjhTUG9RcHZERjB3dGVvWGE5?=
 =?utf-8?B?dFhRV1lOOG5Rd2hEcDJKL1JCZnczVnUxYUNyaDlGQ00yUnArV0RXK2lMYmZH?=
 =?utf-8?B?OFpwU2lzNktzN2xiMEVsa0pJdG15RmRsYVJVbjR6Smh5YzZwVmx1cDZEVGFG?=
 =?utf-8?B?WVE0Y0xKRUl1RFBFMFhSUzdRYVd4ZS9BRkRBeHVaczN3UGw4V1cxQW1EOGRV?=
 =?utf-8?B?L1FuVVpvcjJDVlF3ZjFMdEx1WWNSNVRwMTlZdm9FZXJQWjRyVjMxVGlMYTBB?=
 =?utf-8?B?dHFqTU5KWU0zeURzL3RkWCtYNzh4KzhDc3BYVHYvdWdXMHhzTzVSSXpUdjFO?=
 =?utf-8?B?NmNlRVN5eHVvN3hSdU5DQ1pkd3pTTHpTRWhxbkpyZkJ5c2ZadnF5YklYRjNq?=
 =?utf-8?B?ZVZZaDZPK1FrNVdNSktvUHRTM0FpZ1Q4R3k2YzdURDlFNXd3bmI5MnliN0g2?=
 =?utf-8?B?RHd4Tm4vSlJxaldaYlo2M1UyQWdQc25iUkg3SldzSVdNb1hnQnUxN0c4U0N1?=
 =?utf-8?B?cmlaWWlHeWs5NUR6MDdWalVIWnlTNTArYytvaUZtaHhtK05tQ3AwR0gvbzA4?=
 =?utf-8?B?d0VGQWt3bVpWNEE3M1BPbXMxbTQyNU14ZTllQkMzNlJTd0Z1Y1NRQUxhYWhm?=
 =?utf-8?B?SUN2ZkwvN083NHJGM0hMaFRqQjlYVmdVQ3FBQnRpWHpCUkltTGdFbFJQMFZF?=
 =?utf-8?B?Qno3SDBvZ250QXpnUGo5SWJSN0RKbWxTQk16N3N1RlJQZkZvUlRkTS9QaW1N?=
 =?utf-8?B?SWdXRnpCNXllZUllcnpsQU1YYmhMZHEzanduZkJodCthRmtMSkw5MGYvYWtG?=
 =?utf-8?B?aktjZXA3QnNnTGZoQzJSVkdBaGwvY1NoTW5yQ01aOU9IdTZPS1NtZ0QxQXNu?=
 =?utf-8?B?U1pFd0xDeVEyRnRRUWNWcFcxd2JTaUt2aVVNY3U5WW9ZM3NTYXcvRXE2VHkw?=
 =?utf-8?B?M3haTHIxckZMTWNMNUtnVEFWV1JENkY1L2ZuSXZveUh1aXQyK1g3NDBEbFBE?=
 =?utf-8?B?T24rYmpUSG9VbHZZVUdnY29XSmJ4eHJQZnlxOEdaTmYxWWl1WmFVUU9wbytR?=
 =?utf-8?B?aWoyc2Fyb01vaWsrb1BQcHJaUGFBNHEvRU1BNXljbEltdE9kL3B6Q0t6blZk?=
 =?utf-8?B?d1N5Uzk3NDFhdzdrSFhTM0Ntb2tMNnhlcTlrWGhMbWMxZi84aE1oZTNneitx?=
 =?utf-8?B?ZS9OSjEyN09vWHJzYVNtaHFjYmJhY2ZGVS9QOUFhZEFsT0tIYkFnbVdaN1hI?=
 =?utf-8?B?VUZwdEE5T2RoWCtacWFwck1WeCtWQXE3cmc0aUVSdmJZZTBPc09CYlRzRjJQ?=
 =?utf-8?B?elpKVHZ0c0daak9ZTzFFWnlsOGxVY2pqRm82NVh2dkh4ZGpwcmIzYkVYMnRw?=
 =?utf-8?B?QnFiSitYWU01Y3hhMU9FT09MRURjZnpzTzhmQnhTSndmMzErS3pkUDhjempl?=
 =?utf-8?B?S0dNVVBiYUxyNEQ5UUdHaUdxYVZIeSt3YW8yRUNhZnFMWjFRV2ZQcUpLYVdi?=
 =?utf-8?B?Wmx3UWVCTG93a3M2Q2tUMFBjeXlacHE3QTBEdXMrdUhNY3ZEQVNibndndGdu?=
 =?utf-8?Q?KRlDjgC2PhVWJtF21/hr/b93L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 447a1064-d4e5-4197-5252-08d9f179f788
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:27:19.7922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ik5Ig2TET/B9JTJD+hWxHbBliD8GufYj9WW5m+khu6AXt67y6tlOEfIwyHJ81bDN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3959
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: FrxGgZu4WmIzFB2HdpnEF8qS9hS8gGwb
X-Proofpoint-GUID: FrxGgZu4WmIzFB2HdpnEF8qS9hS8gGwb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_08,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202160103
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/14/22 10:08 AM, Matthew Wilcox wrote:
> On Mon, Feb 14, 2022 at 09:43:52AM -0800, Stefan Roesch wrote:
>> This adds noio support for async buffered writes in filemap_get_pages.
>> The idea is to handle the failure gracefully and return -EAGAIN if we
>> can't get the memory quickly.
> 
> But it doesn't return -EAGAIN?
> 
>         folio = filemap_alloc_folio(mapping_gfp_mask(mapping), 0);
>         if (!folio)
>                 return -ENOMEM;
> 
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  mm/filemap.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index d2fb817c0845..0ff4278c3961 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -2591,10 +2591,15 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
>>  		filemap_get_read_batch(mapping, index, last_index, fbatch);
>>  	}
>>  	if (!folio_batch_count(fbatch)) {
>> +		unsigned int pflags;
>> +
>>  		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
>> -			return -EAGAIN;
>> +			pflags = memalloc_noio_save();
>>  		err = filemap_create_folio(filp, mapping,
>>  				iocb->ki_pos >> PAGE_SHIFT, fbatch);
>> +		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
>> +			memalloc_noio_restore(pflags);
>> +
>>  		if (err == AOP_TRUNCATED_PAGE)
>>  			goto retry;
>>  		return err;
> 
> I would also not expect the memalloc_noio_save/restore calls to be
> here.  Surely they should be at the top of the call chain where
> IOCB_NOWAIT/IOCB_WAITQ are set?

This patch will be removed from the next version of the patch series.
