Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50D353E612
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiFFQjf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 12:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241778AbiFFQjd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 12:39:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6631447A0;
        Mon,  6 Jun 2022 09:39:23 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256GKJgB012088;
        Mon, 6 Jun 2022 09:39:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mZZXFuBxK+9vemOSYznqcI91x9aVSgrOd2Y1n5oFpME=;
 b=BDgWtxnw4wUebGlSX29MmP3h9LeNY5ghaePLXhh7v4ivUJgw8yWnOAyGsi7eKb1XbKio
 VOAPUXuAz59/3WrMPb7fHkH+2DeBjNPQv/lOh4S64Q+0S3a5qI8UB4tZvQxFB4WHKAKx
 9BEo5iO7ChWxv9OhKLVWYy0D9HDXO54RqGo= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gg3ejhhaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 09:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sd+D+HLd/iBhx7aNuZ8tbpWFKil+68+ewXM5Sxn7KtN6P6fdkPM+xGyhBU9eXr2/5kcitKnf5Fd8GEV/S921GdNIZOrkqvH0FRZjrcsqNhr61ewGkR+KPr+u0HnK/1LmchHJr2JN4jNE8E6aiS6KWNrfyny3p9ihzg2RXw1xlN0ogfloOqESOOqGpNGLoGK77HIR+cAyV4QIZnYxUmYLzWiWiDKkySjQ3H6iaSPWQ6dGCzzWjYk9xbPBrhs+PzvvbOFYAIevHt0aFiKDVBNks1rtwxPIbdNtpmoAKDz9h3IOuD6Y94mTBhJG8iYtpz7yQf16xO1oG2juMQpiNBxBgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZZXFuBxK+9vemOSYznqcI91x9aVSgrOd2Y1n5oFpME=;
 b=Q0DfmQH9DjLBZ6tZfuRWXOPRnX9z5GrPv/u6rGYOUxAeQpwavK2rPGRG+gMkxzkRXlzAZJT2/yh7vNvrI7dPjY+9gbf1k632kkiSP7AnFARf563HeXR+uGnjh5qgX9Limcw2Zx+MLFW/rUc2IpPMteNfKq3FT37oUP61IQZvFeGMveEscTJ7YTFH7/zYLabxHMMPLlV0hYOO/38CMvJvhnbdfk6EpseXXGSQCwlw7p0aq+pNfoSw7OFsqjCPDzaMwKmfQlsiNjDKBRfijSfqW1A4XOyV+gSWAiHyz1zakwuxaYbgmMUyXF08FCjnmTWAzTFIVXeF2PjhOzW5yqYkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BL0PR1501MB2035.namprd15.prod.outlook.com (2603:10b6:207:32::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 16:39:07 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 16:39:07 +0000
Message-ID: <0f83316c-3aa2-3cb6-ede1-c2dd2dd3ab31@fb.com>
Date:   Mon, 6 Jun 2022 09:39:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v7 06/15] iomap: Return error code from iomap_write_iter()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-7-shr@fb.com> <YpivQhqhZxwvdDUm@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YpivQhqhZxwvdDUm@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::32) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1bec282-a35d-4c98-a14a-08da47db12fb
X-MS-TrafficTypeDiagnostic: BL0PR1501MB2035:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB203524AD77CEFD319C61427BD8A29@BL0PR1501MB2035.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufS+D0Jc416eO7RVQnw4FgDqC1L2mpYw+4NBitkebnrfCbx7fAgQO75U5kooGZAuUDTvevr667vDxHuZvOTWvFo5keJkSCYiEWnf1PDwT2Ti3VYYq/NoLCDQ8n7SRF+TScQqCPj3cnlYSEUhcnpnm7+Nz2cXDmpBZTMXFoMpUjb9yan+58bZiqZviixxOcOYd+UZWUfvKKlgfbLSvj/C+e7ItShlEDjQWY7WeUfVkQYbh5mQOFU5tnWCSJABrOBy86qqQVGfJreDJLt2geeSLY999uYhjxspcwGmiWjfcyobQyjXHnarOlbxjuyfCtp7Fd3JT0qomXP5dKfR7vysJitIuY9bVn8ng843TidtSxcXny2GOgtKS0mJ9cKX9WFL4pfA4ezGbrOdf56kSDakLGlDBchFXfmPZ1pLhwCAXtz7TC/8nLJvjfhjuWkLnQGWvPkClxPRqKHEbHMp2mF9MCLZjgkkniBrY3bat0oap1RauVustE6QQzuJNImq1SeDXDf8jPy9jTFlOG/Wha78TM54O71zH/UsruxPAtYIZpkD+laq+rWGHU33kD0i3A0/Rqo+tYZMgydiwNMmDmou5wVZGqVWtpToTQiquzWtmJdGwBHje+ffrr7FjDTohe2yXzsZXQzOD3+UffY+gG+KLzs3N1g1UKxlJAltJ9IIQQ7CfCZngU9PdykrZM1w2osQlNdM65B3bDlZxoX4Y72h6c0aVMRFP5WGDfV9x6p87EM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(83380400001)(31696002)(6666004)(508600001)(6486002)(2906002)(38100700002)(316002)(186003)(2616005)(6512007)(6916009)(53546011)(6506007)(5660300002)(36756003)(4326008)(8676002)(8936002)(66556008)(66946007)(66476007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWE2djRobHI0djg4YlFMTzhXVmUwYjNWQjlBaVFVVFVQNi94enJGeG15Qzdm?=
 =?utf-8?B?NUVwMTQ1VVZYb0JORkg2UFhIM3oxYldYeFM2NHltdDVEUjYwMXhwVWpvb1BS?=
 =?utf-8?B?V084dGRQRFZBdVVkbGtQQUlwRlF3d2tGTzRNTjlGaU03MmQ1WEVONnNLa2xW?=
 =?utf-8?B?VmVYUEh3SnJrUkY1cUJ5alJFa2RRUmY5NUZQcTA1UTJLeHZkL25QM3JqNys5?=
 =?utf-8?B?dFc4TnQ4YlUzT09IQ2ZHdWtlT2FFYTYxQUZ5cndhRmNTQ1QwakJoNW82ejh4?=
 =?utf-8?B?Z21lUWFrNVhaeFVTcklDUU0vTWQxRUZlQmRFVnhkQ1JwVCtsZWVWTU5Ia2VW?=
 =?utf-8?B?dE05bU5TSThGTHlUZ0lrcUx3QUpIWVlqNDNsQVY4bVFMV3QxMk1wcDBYMVpG?=
 =?utf-8?B?VE9NTlJjaGRXNGxleGtrUXJpSENtQUZ1Nit6c2hlalJTS1N2UTIwcjZ1dWFz?=
 =?utf-8?B?N3R4ck11NnRzNktBdUQ4Mk1RRWo1Wm9LclNJWFkvUmhVL04wcFFaQmNyMTho?=
 =?utf-8?B?NENZSWhhd1V5S2ZqcmZxTEh1L3IzcWhVYWtCNVdJQWduenhwWXRaNE93d1Fn?=
 =?utf-8?B?WC9WRGllWjNYZXhLOGpOajF6TGpHNlRsS3lmMEhpVW5rcWFHQjBpdjljSktV?=
 =?utf-8?B?dmpacXNzbVdacHo0bDArMVJhcUErRDAvN0o1bEV6cWtTdXVObkdpR3MyL0hJ?=
 =?utf-8?B?WEhwSVJCU2JVYzJoUEYxRCtoMUsrRXRkT3M3cThlR0tGeEdhMEJHSCtOUEoy?=
 =?utf-8?B?VHBtNXAxZUROTzZOTEJiRThVN0x0ekZnUVRoK0tZNU9jUGl6MTBTZTQzQ2d6?=
 =?utf-8?B?bVNJTHpqb2NVc1VzNkp3dWRLdmd3RU5DRitySUFmMmZYRERTeHRMOXJ2cjJC?=
 =?utf-8?B?NmcwRDYvbTUyS3VvREx1QUorUGN1b01lRW05UCtDZVFmVllQbzMzc0dpT01t?=
 =?utf-8?B?ZVlMMFRld0t5amVuY3hUMlRxRFlvV2xmWFRRdzFZMHdJT1hWRG0zQXFsamF0?=
 =?utf-8?B?T2IxOEQ3T1BpbE1ETDJHalJPU28rZzFTL05XTmw0VHBoLzBjK1d2Qkc0ejBh?=
 =?utf-8?B?NlpTMTR4U0YyR2V6cEhDaHRleTA2aVpUT1V4UTJ2OVZ6SzNXdjlTWU42SFlH?=
 =?utf-8?B?c3RZc0FlOHhCTzY0bjVTalpjMjFzZWJiWmVIZTlWY3Y4TTAzTVhlWmswcVZz?=
 =?utf-8?B?S05Md21hWFVBU3dHYWZIWm1kUTdKQmVjWXNhbnVxS0U2ak9udVJFUHJiVFZa?=
 =?utf-8?B?QlUyWldyb0l0SUxwK3dVdnpwVEZjS2dIeDdydVZWZk9EZ2tSRUp3U1NNYVJy?=
 =?utf-8?B?ZEl1M20wLzNFRlR2UWpJVW5sVk5QMTkzajNIREcxUG5FOEJ0NWpYT1M3K09P?=
 =?utf-8?B?SzB4MWtsMGNCTytoTk1USnJ6em0xQTB6K1MxRDdjdnV4bW5EN21oWFBPTHgz?=
 =?utf-8?B?SHhTSDJRS1c2Zm9OWnB5RmVMRFhmR1FzSHdkTS95MkJIcGxYVTRRemZRNEJJ?=
 =?utf-8?B?Wkt3dnZwMGFobDVzOHl0NFBpK3d6Rml5d2NZVWw1UWdaNXF4WTRLbGV3aExY?=
 =?utf-8?B?N2E5OFUzZDBBVHdYTDVmNU5jNHNYRllxYjViWFBnNTVzeGlsQzRWNG9lUmJS?=
 =?utf-8?B?V2FrL1VLQzd1M2tYSm1JYVBGODRmUW9lS0dEY3orYituanlYeGNUQ3FkQk1K?=
 =?utf-8?B?VWNsS2dvVnBjdGZrV3RlRWIrMys4RXJzZ1pyNzUwR3cyUlBpVG1MeVlCYXJW?=
 =?utf-8?B?ekZKbS8xMjdKTUlicEpMNWtyUElUWDNRTDJkSEN3dGxNejZKdHdQUXQzTC9k?=
 =?utf-8?B?a1NpN1RXQXJNTTQvbTJmQU9pcWtHUXpHakRkUkJJOW9Nc1pzK0RwendpbGx3?=
 =?utf-8?B?R2pOZzRxWUwzRFdWQk52VGU2S1VaUXJDdS9NZHpWRHptcWVCM1R5SzVCcjUv?=
 =?utf-8?B?VkRSS004Rnk1dzI3b0owU1Exa3hCb1h5VmZaUk5ndytZNnNNeDIxcEFlU2tS?=
 =?utf-8?B?OEd1cnlyNCt2Y0xFZUJHMXBCUkpRT3V5YXZFbUQrL1FkRGluVFVVQ3ZQYjlY?=
 =?utf-8?B?MlFzRlBYa1RlNituN20ydnAzYzZZVWN5clFROTFYSlZYM25laWRhaGpxU2VD?=
 =?utf-8?B?VlVrVmZMRCs5QkdtbE14aHZYbmVlQWJUWkxRcFg1aDNSRkVGR1ZJYUJwckFP?=
 =?utf-8?B?T0Erc0hMcFUwd1lVV3FXbXNSMHFBU3BaMlB5U056N29LMlNCaC93bHVyU09t?=
 =?utf-8?B?MWZVUTFGS2twRWhVN25MS2RPbmF5RkJrRUxOb3pqdjdYd1lZVXZVbWV3czJK?=
 =?utf-8?B?cGJjQ1dsN1dGOHJNR0JsOWN5T0t4ek1YN251dklkWVUzQXJvcHY1UWxKRlB3?=
 =?utf-8?Q?1a+nBDjd9s6sISD4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bec282-a35d-4c98-a14a-08da47db12fb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 16:39:07.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PyDixXdyjQ8auiGWydCBVb255z/AG2+xpG3H+nlttSMTO7OEQzAS91wfCL8eBIn4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2035
X-Proofpoint-ORIG-GUID: c7JY0PQrhR30P-asHHMGne91_SWxbaMe
X-Proofpoint-GUID: c7JY0PQrhR30P-asHHMGne91_SWxbaMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_04,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/2/22 5:38 AM, Matthew Wilcox wrote:
> On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
>> Change the signature of iomap_write_iter() to return an error code. In
>> case we cannot allocate a page in iomap_write_begin(), we will not retry
>> the memory alloction in iomap_write_begin().
> 
> loff_t can already represent an error code.  And it's already used like
> that.
> 
>> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>  		length -= status;
>>  	} while (iov_iter_count(i) && length);
>>  
>> -	return written ? written : status;
>> +	*processed = written ? written : error;
>> +	return error;
> 
> I think the change you really want is:
> 
> 	if (status == -EAGAIN)
> 		return -EAGAIN;
> 	if (written)
> 		return written;
> 	return status;
> 

I think the change needs to be:

-    return written ? written : status;
+    if (status == -EAGAIN) {
+        iov_iter_revert(i, written);
+        return -EAGAIN;
+    }
+    if (written)
+        return written;
+    return status;

>> @@ -843,12 +845,15 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>>  		.flags		= IOMAP_WRITE,
>>  	};
>>  	int ret;
>> +	int error = 0;
>>  
>>  	if (iocb->ki_flags & IOCB_NOWAIT)
>>  		iter.flags |= IOMAP_NOWAIT;
>>  
>> -	while ((ret = iomap_iter(&iter, ops)) > 0)
>> -		iter.processed = iomap_write_iter(&iter, i);
>> +	while ((ret = iomap_iter(&iter, ops)) > 0) {
>> +		if (error != -EAGAIN)
>> +			error = iomap_write_iter(&iter, i, &iter.processed);
>> +	}
> 
> You don't need to change any of this.  Look at how iomap_iter_advance()
> works.
> 
