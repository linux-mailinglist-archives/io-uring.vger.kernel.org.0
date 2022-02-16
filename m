Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57164B9039
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 19:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbiBPSbK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 13:31:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiBPSbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 13:31:05 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4C4296900;
        Wed, 16 Feb 2022 10:30:53 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GFLGhO024119;
        Wed, 16 Feb 2022 10:30:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kOfO+8JXRldXan4OUB2grpp2vZx/GzI3qKtt7QhmxAc=;
 b=lontdH98Mx+YfGVaDXxNLadv6Szvo1wGfGINel5FVUGZIJBOyMLhl+Ak5ozUeZ7zJ9gn
 x6WuhcXA+UFqldLMsYy8q0D23/lzoZRp40WMT9SKqxY6hinUQ+oyUfDphp0GW2wM6QIp
 SJrOR46WGoTStmngHPRDbUJc4eQwLhtPIM8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n3u6hnu-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 10:30:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 10:30:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KU+YkFBm/TEKWZguWr5NLhR3hq324jTYex4Oc2+jUo/+nvOr/Xj+HsfmMc2Uc0kx1++1LOoSW6UOAhaQESgoB6W6xmBulGY2Wop3DOazUCzu2Q4I7FV1sg+wumB0JuieVDhKa9uoQxYOgur73CzRRtE0QlnqrAgXKML3lFa9hYOh5Ijaro2eM+h7LkxNMfCCzf4C+MSCacyHI7BwqRTEWSwyp6TOaEqz3lGd/6lCOm2ml4Sy0MW4FiHqzqOsXtdnS9M4gqfnGFWUK9v3wEpE9+E/qNtajv6ODNQvuZaTHyw8m8X+PyDrSuAEvQ4L5twhnDH/wNfhmJjCmRSgvxIvag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOfO+8JXRldXan4OUB2grpp2vZx/GzI3qKtt7QhmxAc=;
 b=BcmyeW2aY6i4U5omc3TqattjE0mDWgd7ou3z4/9TgfmjNoaBvM5tWAr3mxD2Myhmw2Z4cwaHK5YuGeN9MBAagow+SqC4pe60AJq2rSRt5xwo2A0XTZzNhRs8yxY7QrDnB59k/iGjbQQvO57awNOy6b/Yg4bQoyPWfG5qx8YmV59OVBB4fFG9ntQbBAlT4YCHBedmD1NtwomHiYqNuwYjd8NEQiCi28WbjUNyLj9j/lwzvaJdjMQcmjd5eV6lxlDH6hQcCz57KuHBDBeBu4l5L4GYfI5FGTUtCZPNa4CyV5BS4wx0JqP77s8KkfDoRbsheVmF1kjA0ij3LYG2+CRkbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BN8PR15MB3154.namprd15.prod.outlook.com (2603:10b6:408:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 16 Feb
 2022 18:30:36 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:30:35 +0000
Message-ID: <a577fac3-1ad8-fb91-6ded-a5f2ed1b62a7@fb.com>
Date:   Wed, 16 Feb 2022 10:30:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v1 07/14] fs: Add aop_flags parameter to
 create_page_buffers()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-8-shr@fb.com> <Ygqb7j8PUIg8dU2v@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Ygqb7j8PUIg8dU2v@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0186.namprd04.prod.outlook.com
 (2603:10b6:303:86::11) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b71a973-928f-4141-1ca3-08d9f17a6c6c
X-MS-TrafficTypeDiagnostic: BN8PR15MB3154:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB31546CB03BA7CC29E0BC31A3D8359@BN8PR15MB3154.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSjw06I2z0mdSlYvxsjEljT1oX9OIf/AYVWXj5Pkv2zXjxF4FkEqCzOYtNUduw7n1sHAacSzxtqKJqKrM8nzwJMQI4bOFIbNez5lK+V0FGMVGdwxPrYzLbrmJuQPZVKl47KvGSeI7+rEp2jGaIflyeoS/gW4zQNLaSEWFLiwOzkwM7HBKO4xretEcCiwbTIeqThcXaDuE18ICpWbr6OrfC4XWCx3LSIEqy29HDYY3r5fhPim8tPhjR+Afi62Rh6MkteetkuPamaJ7rbFt19hMXsiAjBgvrcPf8RQDfRAKWJj/sL/i2iLKhum8ceroyCXAd2Z9UhpUnCL/BJiZ3dKsllWL+fLAeDbkM9z8Ex1BVHrbieI3VWFWmceHz+fW0bwdbi1+f3VoKccjAIFVUNtCplBEuRdy770pPo70XAyg9JqpXqbzA2WP3fP16i+cPN5rGjvcv5F3e9nqXGfHwkDHJD0o15jwoCCby/4nX5SQLyPg7qFjV54FAbmF/sm+VuqTFqNy1ZJ/fPKZ0QsG3C3WWn7q5S/s7ScHFYEhqPWWVBPRZ5cQQjy0fM/D4Ec9d6oTW5AhUj2q7j30CyY25y8Hb0D9epskcgr9R6QhVl9jGxp0BWj6+lm0wrl+GHwLrxVcSZpJDvqKYGc2lL9J+dUDM4ADDjyUEO67YOyTpFcIYS5tWwpXurn+0veKugfCEsr9MYAa1dIiLYaRr+uWBAFfuorJ3s/a4LNTXk4yeYZ6s39jcoFpy1farV5MU2VjP5u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(31686004)(6512007)(2616005)(83380400001)(66946007)(66476007)(66556008)(6506007)(53546011)(6486002)(36756003)(4326008)(186003)(8676002)(86362001)(2906002)(31696002)(508600001)(8936002)(316002)(6916009)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVFCcko2eURoWXhkNVhVdjVYSVVoVXVBSnlPamZCTWpBV1JQOGxtOVY3VTNm?=
 =?utf-8?B?a3EyOTVQQ0JBNlpBeWptWmNCYS9YY2JJOUNiS2dNK0NGYTZlTVpsbUMvQ2R0?=
 =?utf-8?B?QWVIRVViaDlwNWZCaldINjZFRFJSRmZoMzNWNk5NeHJGcmhKSnV1ZGp4UmxU?=
 =?utf-8?B?Ky8zRGJOTmNTN3Npd2ZqZFpBdHBuM1RDSDFjQ3dTZDNOc25IbDBmM3J2Ykk2?=
 =?utf-8?B?a29maU9TTUcwZktmUElOa0szL3preUlZZnRJV3diZHpPdFIwS0IwVkd6VzZH?=
 =?utf-8?B?UFZJdk1LRDJxcit1d1pQaUowNXQrdi8ySnJ1c21HVkNWSllUSkMyeS92aWJT?=
 =?utf-8?B?Vkpzb2NrNWx1NGxMeGYxMjVRZmFlb1JaWjlaRyt2WlZ1cDVQRC85c01tTGtF?=
 =?utf-8?B?Yzc3QXVybnlZQ3NKZFVmOEovMmo4QzR1Y0MyaWs3OVlNOSs3Yjg2eDFVODV0?=
 =?utf-8?B?T1B6Nk02VXpjQzRtcTVQR0lFeHVpbE8rdSs2emFVRllyRGFPUVlud0Z5VW0w?=
 =?utf-8?B?d0VwbENMVmNIUTdjYmFBV0JqL25BRmUyb3B4T3BDVHROZVdVQSs0bVl0N08w?=
 =?utf-8?B?OUJabUtTTDJHVFQvbTBneFNOOUJnNUV1NUNtZDZRdnBsZWk1aDBHYXZyWlBI?=
 =?utf-8?B?RUtzYVA2dmROdzZvL1RJL0tPQlJkVGZTR3QzUzhKMXhLRHFoS3RLTGs3bGxG?=
 =?utf-8?B?SWRseW9obVVtcUl5cHdrWEluWGN4a2M0QWFaVU5zMGxNbUtMSVNlTS8vcFhu?=
 =?utf-8?B?Ky9iSGoyZmFuMHlKZmFMdGlXYXRML2dLaEZmSEFxQUhNZHg4aXphQTNuSDhH?=
 =?utf-8?B?QTM0MkpLQVlnMHJ1YjM1dnZxNmpwNDdRaEd3WmpjSHltZ2czRHdYNUlpL2lP?=
 =?utf-8?B?NzZ4Yk9BQ21YemIxb01maUF3ZVRmMUE2SUZDWlNhT0dvdFN5MlM4dTdRTENB?=
 =?utf-8?B?SlliY200S3lpVmdFZEJsT0o3Uit4SmJIeG1YMkR2b0YrTlNoUjNMWVBHNUN0?=
 =?utf-8?B?NVdrTDNqR2Vlek5JTFpaZGx1Z0I3Z2hoWnZzcVBDQWdaTDN2Qk8xTVJnUkQy?=
 =?utf-8?B?SXZ2cGYvUnlKUHk1VjZEamRnRFcrc0gyaFBJejdhSkFqYnVNQ3BDYTVnb2V6?=
 =?utf-8?B?aTNVRHh0eTNOTVB1c0JycHBCckZxRWpUdzIxekhBR1oyUUowVElQSlJjelph?=
 =?utf-8?B?ck9EOW94U3FaZStNNGlJL2ZRK0J2bXlPaFdlK1Y5Rmg0UTY1Tnk3amFHYTNH?=
 =?utf-8?B?S2xUWkNsTDcwSjE5TTB2NUpuSDA2Q2tIMVZWUkZWRkJPcDVQa0hJRmtyMDEv?=
 =?utf-8?B?eEI3N25lQUNJaGI5WTBtR3VBUEY0L3d5VDEvMUpFYzN5UjUvbXBLODFpMVFK?=
 =?utf-8?B?dUFobW14S1I5NUxqU2grSFg4ZGxUMEp1UnFMTDdCV055Zi8xb3FHeWxUVkVx?=
 =?utf-8?B?QnlXRHk2Q2FCL1Iyc0d6aThDWHNIUE1JelRHNHl2SnoxRDRkczBHNVRlWjl1?=
 =?utf-8?B?enB2MVowc3E1d092MWRjSGxlS3JnZzljT04yTkNIcVF3TkZJK084VFkxd3BI?=
 =?utf-8?B?Wjc5SEwyNk5SL1Nydi9UWEJUVm5aS3ozK1krL2tDZXR4T3pxWE5YYkZSKzRz?=
 =?utf-8?B?S2UvQkdpcVNUUi9KcFhXTjZuS1FqdC9VZ1VMaklrbzZPcDFXc3phWG53ZHRY?=
 =?utf-8?B?K0o0VUxrYmRMcW5YSzBnVExDbFZjSkhxdmNZQWxFM1pUeGZNN0dFNTJTMVYy?=
 =?utf-8?B?Und3ek5YL1hva3VVL1VSQXhWNi9XWXJ5dWVrbG9tdTZZNHprQ3NnSTA4QVlC?=
 =?utf-8?B?a1gzTmdydGU1ZDc1TjhnSXBHc0t4ZGhjNnRrNFZuUzVQMmJvMEFubk5WSksz?=
 =?utf-8?B?eVh1eUwrZEI3dlR0bk9zRTRPWkZMUzROY1o5cjdxSmNWMXZyVVlkRjY3RUto?=
 =?utf-8?B?VVFBREVUdmpCTk1QaEhCc2NsSzZZazhzN1RTNk5CRFVkRUJYZ1lmRzMrekZU?=
 =?utf-8?B?ajNqaGVNTVhKdGhlMjJXdVd5MVNmcko1aEcraUxvMTR1MXVtZFV3T29MT3Vy?=
 =?utf-8?B?Z1JUdmQwTlhUdUpOUjdwQjIwZ1dUUmk3ZXNMRzRFSjRRN1RQOFRwNVBVSUt1?=
 =?utf-8?B?b2pmamsrSXM0UDlJU1k2UVVRU1dtVys0V2tNNjlSOS9ERVpQUDMzQ2lqUHJk?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b71a973-928f-4141-1ca3-08d9f17a6c6c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:30:35.9151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDY6OyU7YyldrUgyS5HaInRzpmkO5SOjTL4ecZSiQzA/jDH80i2l9A1gomQhm8E1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3154
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: OhwDniUe6UMcENgv3AFKR5C71cI8m54C
X-Proofpoint-GUID: OhwDniUe6UMcENgv3AFKR5C71cI8m54C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_08,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxlogscore=964 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160104
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



On 2/14/22 10:14 AM, Matthew Wilcox wrote:
> On Mon, Feb 14, 2022 at 09:43:56AM -0800, Stefan Roesch wrote:
>> This adds the aop_flags parameter to the create_page_buffers function.
>> When AOP_FLAGS_NOWAIT parameter is set, the atomic allocation flag is
>> set. The AOP_FLAGS_NOWAIT flag is set, when async buffered writes are
>> enabled.
> 
> Why is this better than passing in gfp flags directly?
> 

I don't think that gfp flags are a great fit here. We only want to pass in
a nowait flag and this does not map nicely to a gfp flag. 

Instead of passing in a flag parameter we can also pass in a bool parameter,
however that has its limitations as it can't be extended in the future.

>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/buffer.c | 28 +++++++++++++++++++++-------
>>  1 file changed, 21 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 948505480b43..5e3067173580 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1682,13 +1682,27 @@ static inline int block_size_bits(unsigned int blocksize)
>>  	return ilog2(blocksize);
>>  }
>>  
>> -static struct buffer_head *create_page_buffers(struct page *page, struct inode *inode, unsigned int b_state)
>> +static struct buffer_head *create_page_buffers(struct page *page,
>> +					struct inode *inode,
>> +					unsigned int b_state,
>> +					unsigned int aop_flags)
>>  {
>>  	BUG_ON(!PageLocked(page));
>>  
>> -	if (!page_has_buffers(page))
>> -		create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
>> -				     b_state);
>> +	if (!page_has_buffers(page)) {
>> +		gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
>> +
>> +		if (aop_flags & AOP_FLAGS_NOWAIT) {
>> +			gfp |= GFP_ATOMIC | __GFP_NOWARN;
>> +			gfp &= ~__GFP_DIRECT_RECLAIM;
>> +		} else {
>> +			gfp |= __GFP_NOFAIL;
>> +		}
>> +
>> +		__create_empty_buffers(page, 1 << READ_ONCE(inode->i_blkbits),
>> +				     b_state, gfp);
>> +	}
>> +
>>  	return page_buffers(page);
>>  }
>>  
>> @@ -1734,7 +1748,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
>>  	int write_flags = wbc_to_write_flags(wbc);
>>  
>>  	head = create_page_buffers(page, inode,
>> -					(1 << BH_Dirty)|(1 << BH_Uptodate));
>> +					(1 << BH_Dirty)|(1 << BH_Uptodate), 0);
>>  
>>  	/*
>>  	 * Be very careful.  We have no exclusion from __set_page_dirty_buffers
>> @@ -2000,7 +2014,7 @@ int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
>>  	BUG_ON(to > PAGE_SIZE);
>>  	BUG_ON(from > to);
>>  
>> -	head = create_page_buffers(&folio->page, inode, 0);
>> +	head = create_page_buffers(&folio->page, inode, 0, flags);
>>  	blocksize = head->b_size;
>>  	bbits = block_size_bits(blocksize);
>>  
>> @@ -2280,7 +2294,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
>>  	int nr, i;
>>  	int fully_mapped = 1;
>>  
>> -	head = create_page_buffers(page, inode, 0);
>> +	head = create_page_buffers(page, inode, 0, 0);
>>  	blocksize = head->b_size;
>>  	bbits = block_size_bits(blocksize);
>>  
>> -- 
>> 2.30.2
>>
