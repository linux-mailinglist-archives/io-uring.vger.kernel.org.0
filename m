Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11953BD03
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiFBRI6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 13:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbiFBRI5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 13:08:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBFF64BD6;
        Thu,  2 Jun 2022 10:08:54 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 252GC6wA005989;
        Thu, 2 Jun 2022 10:08:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0FnsIYp+/Y6Ab2dRXTTyX40GpEhQmEG1ZAIQbCMUDfc=;
 b=hZSU4Nz5KnZzImfXy4RRYrNM4MTvCZuOc2IMq3nfigjijL0yWtVx2OrrzVcNvuSVIWcy
 +jh6oixbGvlA51MORRFHFeIvP8DScmQ0sGtgQnwc+PvbcLr8/+p5izdGprWNzDm2H4tU
 z/086v3Zqnbx8elvascTNR0clsEDh0sK7OM= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ge5au21q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 10:08:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqOfUB2LvpOAzXK6w8VyxXUvhs/SR9v5RANB3YhgkXlqN7CGcWXONEHvS9QHGGIdDtsOHKiutJkBDMGBibAuxIlaxLxnUw0cEAF87YTDvZxjy0cUNUvVj6vT/jFOlerf4poLKQUmZv3LEbx1cSmIMz14FPvFA722G+nbEFjq9KReWWZoza+/T1DlCQJ2ab2b9to0VTmZio4+ibRMMrs0OcCYrDPG/oNC8vSBU8b2GLLzb3FbXvON0fuQjdLsD9C1EbzZWGX0SF0C2fSKigww0m6Iyl3IzSTvUY8hpjS3yxbVyjZNGG7EkQAqg6wEG+eYkvaKym/K/4T6NrfPd3U3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FnsIYp+/Y6Ab2dRXTTyX40GpEhQmEG1ZAIQbCMUDfc=;
 b=X3DiLIIsQEwRuGjw0oh00XIFvNSz7QHDtxIhfP4M1dUZY40r74+3Q54uxlV6FPUGj4olncm9AtGLa4hGrq9uutxXK+ncUEbyw85ahyVp+reT+GKcseUgZLEZ2U9mmorothOw3Kw1hU7urJrkp5Jym1rVdhtPD396iP19Ic9dtr6m8NX5/RrOS5+NOosRasBeNNfg+z36TOXvj1ZNFw9IqhtlX0MnwTPU9yCggM8ojzrKM6jCbtBQZd5MuBoYXXhRbqPrC2b4hWBVHCknHpJM2d0V7xJEh/fzaxtgCjOd/OMJ/D+Pu3V4FKQTwdhteGwS84XGiA/TbDXVpI4vF95HcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by DM5PR15MB1403.namprd15.prod.outlook.com (2603:10b6:3:d2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 2 Jun 2022 17:08:22 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 17:08:22 +0000
Message-ID: <14e8decd-f0e3-f97d-2447-eec67416acbb@fb.com>
Date:   Thu, 2 Jun 2022 10:08:20 -0700
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
X-ClientProxiedBy: SJ0PR03CA0367.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::12) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 719aafb8-0dda-4b7d-f89f-08da44ba7fb4
X-MS-TrafficTypeDiagnostic: DM5PR15MB1403:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB14031827A806C525E3D748B4D8DE9@DM5PR15MB1403.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PeaqMmalFYT0qqsL4Eyre9c56ctgunDo0fZPTQcsr7O8t9J3Pq/cT04TBHQeC6UA7mFAaSmb2b2UNf6scUyCx2a+dG5VP7fgHEhYihK2V/CrNBUIrIfqS72awygvU133MLrvWCV5H7D3NvcONg1LnXx5/eRgMW+tPjsviy0nIAg5cbb8Swbz2IUpYDbc3jC2zsxHENH6Qt/8QlJNgoQDebQbP+SddYK4WaoPgTsAHFFjG2bDOaFCx1AdPWSCdkoOINWGE4CNIoROdYZjrhddE5zjnKpfZCzxroSSsyBL1qOw0+rnzoZcep1feV/g1QHgC9vMhjlhxHEpNbrdNIecbQo4IyNLYN5xNfo+KYc5yKFYnjBIOZUFzENLxCyjnmdtfcqKBUap1JYtb/HJR3EdYOILUL0r1lJDLmavEtFSxdjGXbx1uISBttiMjlVxO2g3B7gHYqELoOfR7XqdnSQJZkkAxawOx6oL4xZBm97ZOexXeDboY4hr6lZxNDoF9EUMGGoM/BFGmXnOD1Gg6zcGBJfKRS4X4bkiDgNqnt7t7jKyz7zggfDDioTpDYppuLdCl64J3BRxJM7xDH+4b1ytp1HylfHmYLTuPgf0Xe4P+Z8PkYCPp5ilcGLwBE8yoItsjCoqXo7oGVswsrToFYRuESEaJIXTERZI0VueJxGSeC+kmWJi5Gkzh47MmPGmHHz/TIDK12QMXXHwHbG2OCz0gjrL5CU/xoT8cbm8M4NQh8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(31696002)(66476007)(66556008)(66946007)(86362001)(5660300002)(6486002)(6916009)(38100700002)(508600001)(316002)(186003)(2616005)(53546011)(6506007)(6512007)(2906002)(8936002)(36756003)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmRlMTlqMDhBdk5EdXNLaW91dnJhbjg4RVhFOGM0Qzc2Y3hsZmRTakRPbTNV?=
 =?utf-8?B?OXphSWVrbUdiRVpFdW9sdHd5Z3ZpQkF0V3Jod1N0c0EwdVRNbTNjVVFOYWlH?=
 =?utf-8?B?dVJTQlA0VXJsdExDZ1NtQS9YYjdoY1M0bng2ODB1RUw1OFRLaTB6UWRHTjRx?=
 =?utf-8?B?L2VUamU0azFLd2YzWG4xbXNhckVjcmRUQUw1WmZkT01SQjhQa1VYZWtnK2JK?=
 =?utf-8?B?amxkcWtWRzV0L0N3ak13UTZ5aFBEcmp3SDQzQ1JkSVhlQzJMRnllMktSZjZD?=
 =?utf-8?B?UjJZTVIrTFhyT3hRQkFmQW5XSTZZVWlndjlEd3cvbjNPSGwrakNkUG9HY1ly?=
 =?utf-8?B?R0t0TlRqWVRnQTlRMDFDSEg1eCtUZ1h2Mk45ZmdpZFVWNVlMb3N1QTM4ZE1S?=
 =?utf-8?B?OVBTWGpIOHBkT0x1MWxlaDJqdWRlc1dJQjA2OEwrMkFRWW1pREJGQXprRHp5?=
 =?utf-8?B?N0ZnUTVZaXFRckNzSThUaWpNOW9DLzZJNTJCbVJjUFlUVExIekRIbkNnZXlY?=
 =?utf-8?B?eEJEQWdFS2VCbXZNNDVEVTV6aWRjVDhBV2FBQ2tWZWprbFo5UWszdlZ3QVAr?=
 =?utf-8?B?Z0t3SkVQOXlUc0wxSjI0bE1zUUFRaldkWEhxd2ppOTRqcUlISWw3aHViOTl2?=
 =?utf-8?B?QU1YSDAzVzJOTlY5OTJLTjViTTVTODJMWjFzRTQyR0oxRkthem1BMUh0OERZ?=
 =?utf-8?B?cXFhdDVQaU55emUyUnZlamEzRG00R0pWVXp1bmN4cVBxdjkrYlVlTXZseWJi?=
 =?utf-8?B?Y0ZmL3R4WGJRKytzOUdaOEFxUUNSSGhPQmpiOTV4TzQ5UndzWDJadWczdmZr?=
 =?utf-8?B?a1pHVFMvYWhtUUc5QmxBdHMvcG9FbU1jUk01aTVyb0NkZnB5c1ZSTVJyWkR6?=
 =?utf-8?B?aDBjQnlrNmhnd25iNUlyTVZWQkxZd3V0U2lhTDlya0haQzNPcmcvblVtc0tt?=
 =?utf-8?B?Mzg2alBscmhGUmJteDY3Q2thaStzR3RDaXl6b1VIeC9Oa21YcnlwQnNNMisy?=
 =?utf-8?B?VjMxWG53Y3dQVFhMcDZleGN3Z2N3WWtjSU1rRnBzVFo1SXpqZGxybFUyZWtH?=
 =?utf-8?B?NW9kOHR1YjRxUlg1Z3p6WWV6UUd3QzBJTzRjb21kd0kzR3BZcjAvcEdJWndU?=
 =?utf-8?B?OGp3UTJuak9iZUVOSzR3M2svNi96dzZuODFDS3QvZTdUMXQzeGJDaFkyL3Mz?=
 =?utf-8?B?cHN0eExmajE3cEF5enp6UjFNUmM0UVVaZ0h3VE5wTnVKUkxoSjN0elMxZHhh?=
 =?utf-8?B?S01mV3QvNEVJQlViVmFvWmRIVVZJcWcveVVReTFrbHhTTUFsT3lFRWVwSVpq?=
 =?utf-8?B?UUtTcmphdytOOC9neUtJTnZ1QlN3anM1R3FNZ0xudm1EMHdFOTd2R1lqdDEx?=
 =?utf-8?B?ZjQvZWlQcFFtY2YwanQxbmdWNVUyQXN1SmQzeEc4NDREUFhBQUFtYWwwOWdo?=
 =?utf-8?B?bnQ4OXBHZmNqM0laWXRldlVNZ1N2OEI3SUEraG1tYVBSOEFjcHdyNUVjUjFa?=
 =?utf-8?B?SFNGMXYwMU94T2hvRVVLSXFlTTBwcm80Q3k0TWxidXdXZi85c3h0aE1kVGFW?=
 =?utf-8?B?WEVTZlR0cWdSYXVjTEtuQWdCZ3JjZkk3OU45ckZ6MDhnSkkwTmQzQ3RwdER3?=
 =?utf-8?B?T2JPUkhjVGMydkN0a2JZb3M0ZDJrTjZnY0dTOVN2Y3lvVUV6L1F6U3J6U1Nw?=
 =?utf-8?B?ZGhBZldseS9nUmlsN1VySVh5QUtINkJ6QUNoUk44bUZML2VRd2hvdjMrKzZU?=
 =?utf-8?B?UlVBUHFXV05tRUw1YkR0aFQyUWFNaHhmSW10NHdwd2llV1hsOGlPUS9JRS91?=
 =?utf-8?B?L3p1ZTFYVko5WU8wYWF3VndxNjh3alBMRnoyVW1Wbmc2azZQTnRlbDNHelR5?=
 =?utf-8?B?MDFRZG9UZHJHeXV2bnRRd3ZwNG9EQ0dWNUlVNW5OMVZvbkZaeFVOWE1wQndj?=
 =?utf-8?B?K2lyUitkeFE3RktJcUVYTFE1U0VHbFNsUHJiMUh4SW9UNzZoS1A4OWFLS3BW?=
 =?utf-8?B?VXFpSWpUQS9HUVBLQkwvRmZVN1V0eVl6Z01GczhtWGFULzRQQUxZd0I5Z2pK?=
 =?utf-8?B?RHl3dHNVSVloT0Nwb2RwWFQzcEY0QUF5T0VxUE9kejc0MGd4QU9UOC9md3Ft?=
 =?utf-8?B?aXgydWhLVi9MWTIzcENLWDQ2Y2VCb21VQnFVckpJRFJpSGxEYXRxeEhRYkdm?=
 =?utf-8?B?eVBOd0I3eU5jdzRrNWdLamh4TEdEWGQwVXJYcEJzL0JJTnN5VlNFdWVIWUh3?=
 =?utf-8?B?WXRZSjJBSGJPL3pJc013eGprRXRmb21rRjZ4SGtnSG1oS1VqYXNHTzI3cEZE?=
 =?utf-8?B?ckRYUW9kb1haODM1cWxTUE50a0dZRm9rQkVGUkFYcER0bjFzL3RhSHdZM1NV?=
 =?utf-8?Q?RQ5vnGiygadyDF+0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719aafb8-0dda-4b7d-f89f-08da44ba7fb4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 17:08:22.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Eog/u0qsXFXrpPj1W73er1xIWoYMikvMi5qG9GoFuYhao/pUuMkzwmo8jo4mg4n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1403
X-Proofpoint-GUID: tfqHdjOBBcXhBNXehd4PdwoAkCxLX16X
X-Proofpoint-ORIG-GUID: tfqHdjOBBcXhBNXehd4PdwoAkCxLX16X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Correct, I made the above change.

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
