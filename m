Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5970B52C787
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiERXb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiERXb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:31:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A863A34669;
        Wed, 18 May 2022 16:31:24 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6EYY013814;
        Wed, 18 May 2022 16:31:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=COMteG0OczIbEDCh+7J4DlktoYCDwv0gQXwggtUl61w=;
 b=GeZX0MxZtV+3tpGaHZRyXxu8vEbLTa3WSbLUgwKNiJ5+1wiTYTBOchergPORD57rrtc/
 TD4lflC1VfDIKiDVghxANXbOh1ExwVs/jQxFkVrZRsd6kfQlj5Sh3jJpcg8DyVSWrEDD
 avjTV4lx1Oi0HsiTaH/XI1z15EV7T9HyKUk= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4d823wkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:31:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYW/cEeH9TKvv17UQ6MHqcAxGlWCzl5UUJfQecJt+/eB+fhNnagpSyV1iYuJkuWG9L325Jqbg8XOtlT66TzmNkdx1PR/2NBTQXXFSr16Qd/a2E4xCVaJZPTklawJl7iW0n0iWE1LBK4WqSTHTm2T3NjsemQ6LMPd/6znkXA3hphGyda8oX3CiOh31S5/3s0uMnmWYFkdw0p7WKa92rB/mvPpQwNmo6u9369Qn6B9Ogoxp856WNBX468H+Kl9M00SuBCEX31YvL8K1klubIqbmA6pmyX5QVgwXpZUER7mprcr2F58IbjyrZSdCk17uQZK99N0kAdBh7kg6yMaDqUu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COMteG0OczIbEDCh+7J4DlktoYCDwv0gQXwggtUl61w=;
 b=m7mVskqYNZQBIxTz15n/w9JY4Y4M1E4l04aBOc6rs/kdKHrTZQwfG/Fu7bboDSDwAj2xr95OLbsY8sC4pkatGnJDGHzWyYoQE/jwKYm0tYAdyN0dAp9cyy/WD/8mTlhQGrkX7PD6a14BV8BsD0AoLYdsbdDkjgPo4d+A0OukrEYBogIGkYDP6Q0eESaLynoZJK6spt5WmfABMcGGhUxH4N4XWkxkr16+FTc/op4QohbiGO8zVc0vk5C89uDrToXJI+Ia9SzFXedLAdk3TcIs5EwfzSKa9DIb9w1XU31W3nRRG1Bcnc4D2xsKAKhnKXJe3YiI+Nlj7jr+L7G8wxfvzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by DM6PR15MB3227.namprd15.prod.outlook.com (2603:10b6:5:170::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 23:31:15 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:31:15 +0000
Message-ID: <09a2b639-0b60-2aa1-d1c8-362fc71f26ff@fb.com>
Date:   Wed, 18 May 2022 16:31:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 12/16] mm: factor out _balance_dirty_pages() from
 balance_dirty_pages()
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-13-shr@fb.com>
 <20220518110737.4fzi45htbwbtouve@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220518110737.4fzi45htbwbtouve@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::20) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77e55ddd-87f1-4470-054b-08da39268041
X-MS-TrafficTypeDiagnostic: DM6PR15MB3227:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3227C311355E2654CD6FDF1FD8D19@DM6PR15MB3227.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVBWYAFooe2q5ixGn+EZ50WQCz6x0LKYhWVJSLQ010B3kEjEGBUJ3o9A+uKPTCoHAOIeyt+fPwlbn++VTYCrxRYhyrdIE25gOnNIDiarPIgI2yMmQG9dsXpZlf49BoSDuYY/xwgiw61fq36BN+3Mz9l4tuZJFigj1skth+alUlkiOCJ1waeDdC/D9JAvSEIAIfVUg8QN+h0SsmrL/mrfePcSBV8wswt7J0iUxBlUZPU25c/tiGaFkj0lcJ1sWUmiGdSOPV86n4oLIsAXrXSM2QElgDPaiLvH3bEUnKCXeFF5kAhIt7g1/oGUJAPjyLDWOJk8IEUA0EwQRfg8JTLFWdYZg5E6NCqlQVWIqKGJpJnD4k0j7oX9ahJw9CaLKbiYGiTjmcIrfYT7nifSB47bjN2w3tfddoRpEME7RADo2Y12Pt3MQCKDSvJ9sXUFzHg34PtqeP94lz4+hfR0ZP6PfvgM78nLpAbqqWVLOwf6LKWEobmdR51+RhVNoaArWQu0VsX3OjoyoL5NQLpWB9wJk+oKoppPuAUr8HFkEaQoz0VLZqzft9XClz4d1A8YhumhU4aVpZao5Al4GTwOXxx/lMcqkwd0Ezr1Y7yA+gXk7JGuHd3k7NVQafcBPgBZ2uXai6P7ELtaEZvuMY/hUySKIr/GP3SAPxUsFlPbzM13YzaP6RYPL7EdSJP8aI0IGXg1x84PL24nBWEz2/pw4uzwpkvwBtebrg3b3M3cUo8UzPTgUj6mKEMPTH1pimmRM/dRBCC2h+26klG6hDbOGx4d2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8676002)(4326008)(66556008)(66476007)(53546011)(86362001)(2616005)(83380400001)(316002)(5660300002)(8936002)(30864003)(186003)(36756003)(31686004)(6506007)(6486002)(6512007)(6916009)(2906002)(31696002)(38100700002)(508600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ym4xV3JaV1NhNy9rVmNBWVpHWU5HWVBwazlpN0tYQlc3aGtXMjl2YXdSZzUw?=
 =?utf-8?B?WG12UVJUYlF4YU14K1czdXljZzlWVUZwWUl6NjYxMVIxTzRjd0Zsb1FXZUlw?=
 =?utf-8?B?Y0s1RUpwNVpkNVB2ZmRnZzVISEdIdWpEMEdQdzRxbzFiSno3YzFkVjUxcFhM?=
 =?utf-8?B?KzQ1RFpjNEpkSXZXanJZcmh2QlFKUzJrMTMzbGRJbWZOakM1SHhUeEJ5M1Iy?=
 =?utf-8?B?czA5TVZqdTJITzdFbnJVQkxwWXdFclZ6MmdyZXc0RTBmWko4d3NFQVdNdDJ4?=
 =?utf-8?B?cFZNbVVsMUk1UGJEYzhraXd1Q25yWDdYcmdnYVFOWVhKRU1Gb0RSc0xFOVVW?=
 =?utf-8?B?TXRJV01mV0o1elZsMitDN0t3WjRRMlNQM0lQMzN3YlR1bU9Lcm5oL2d0dmJ6?=
 =?utf-8?B?c3dtaktZREc5azFtV2pWQlR4N2cra0pobWZ1Y0JLVWhjTW1FRVFhWDhxSTdY?=
 =?utf-8?B?MDlNbHlvZXBybEg5SHFNblNCRk41SThyZ1RncTdwOW9Pamw5ek0xdThVVklM?=
 =?utf-8?B?MEl6MVhqTy8vQXkvaDBueWlMcE9wR2RlUlJWK0lrdVQ5aUtkL0c3d04ydWFO?=
 =?utf-8?B?Ry92c0FZVUFTcnhlbTRZSTFxOGVTd0YvUHhsOGFHaVVWSWRGdFAwYnc5YlFG?=
 =?utf-8?B?UHJHbEYxUytsREE5S3dNeXNpUng3N3lrWlF0WkN3UFVDbE1WMVk2Zm8xRzFi?=
 =?utf-8?B?WDA0N1FNbUtEYjNRQ0lVTS9sUWJZeldHRFZDS2E5aDdUbXkzQWF3RHJwUFlm?=
 =?utf-8?B?S280NjNOMHhJZTVtbXcydXNLU3dFdUFQSHhTV0o0U3M3NEEyWXl6WW1BRW5Y?=
 =?utf-8?B?UnhFaEVkQ1FVbDFlTStIQ254bFFoc2svVTJLOVlMenFJSUtMZHhkUFdLd1FI?=
 =?utf-8?B?T1Y4NTBmVC9CTWlDbTI3SHZ0Z0MyYUJWamVDYlczTDV2a0U4cnJtVEJtVTI5?=
 =?utf-8?B?bWVsNVZHNWFsa2VRd3IzRldBaFdEelBBRUlaa0t3TkFYMzIyZHd5TzJZS01x?=
 =?utf-8?B?dkJPY0RrRmF4ZEtycEh0d1RqalY3TFZwMWFuZVd1dWVPd2FFV1Y0ZlQrODM3?=
 =?utf-8?B?UnZaVkM3cHl5RXBGZkRxb0QxVmpZZHVwSFl6ejBjaXdvYm1ISGgxL3VsQzN2?=
 =?utf-8?B?aGxVN016WjBsem9pRnh6a04wcUlHQXkxMjFVSDh2YVZzRXRrenpuMXREc3R3?=
 =?utf-8?B?TStZK2dvNEJkRHMwbDdWcllPWXZzdU9HV1lVNnNIeUZuMmEveVJSZHVhS2Rv?=
 =?utf-8?B?ZXFKZWk2d0x6WmNkV2l3UE02UHltdlViaU5BOVA1OElwMGxyWHlLcDJ1OXlD?=
 =?utf-8?B?NUU1dVFoV3lPSkpGSlFDKzhsZDNjdyttSVFLU1FqUTRuOVNyYzFFR3lLRkR2?=
 =?utf-8?B?MUtadE8vQjhWWFEyVFIxZzVlNmgwa2gzWisyWisyNm9zZS9SdlJaN0JvdEtz?=
 =?utf-8?B?SDhXeFAvTEYvbTFTN281Tk0wT08xNkRIWHhzUTk2aC9tY2l3Nk90elh6TTdi?=
 =?utf-8?B?TWR4OW14WHVvUitiUVROdkRiVjlYdFgyWEg4ekhzeGhySkxRZVBXMWk4R2dn?=
 =?utf-8?B?bmozYnVXazE3VGpFZ2pDbERlL09PaWRhVHNaZ0pKZ1h6M0pTZWZaZ1dYTXNF?=
 =?utf-8?B?enFUTnlQeTJWMGNDMVdXaUVHcnpSTVR1VWltNnYyMGRXUEM2Z1RxUm1MQjZq?=
 =?utf-8?B?Uzc3M3Q2RXZoMzF3OWxUMy9rWGlFUVg1RVhiVlJ2czN3YW9oN0tnblEzQ1pM?=
 =?utf-8?B?Z3NUcktlb1l5YTFrRlczTTlPOU0zZGVMaXNsOWUza0ZBWE03eVVZaER5MEVH?=
 =?utf-8?B?ZXdxeWJXZmVCSnMrdUExTFBxb1RxL1ZsMTlZR1Z3KzYrME1aNFhJaDZOY2sy?=
 =?utf-8?B?ajE5bXhPeExGSVNWTzV1ZVlrMFVOb2xoaU0zeHJXVVhhdkk3em1QWDNoUUdp?=
 =?utf-8?B?VzJyVmxTM0MvQzVxZzNLd21Ja0piYWU3TnhCLzJ5YW9XdUdyRElrOWoxQVdO?=
 =?utf-8?B?MmJZTEd6NTVicWlyYzBSR2loSFVrU1cxalFaZjk5Q0E5QW84cm1xK0JrbmZN?=
 =?utf-8?B?N1ltb1RvRG5RbFd3RUQxZjNvWENzZVc5aDM4TFhhT3hvZ2thb2daaExsRGRX?=
 =?utf-8?B?QnN5amRwZ1pNMTFEWTg1M1ZVbXN5cnlkLysvd2JnVXR5aHl3cUxDbFNHVjEv?=
 =?utf-8?B?KzlBdXB6cjFsV0g2UnZ4eDlXcnlnVVNkbS9WQkFPbFVETVVMcTdFWEZWblpG?=
 =?utf-8?B?c25vQ3VxSlBiaWVJNmFjSGVzb1crL0xjdHRKajc4T1ZCcFJvdkRqdjVXUWtC?=
 =?utf-8?B?MFk4SE1mVWFsazFQZ3lNaEdmVjgyaHExNlB2WEhFOFpuaytNdFdnSUdPK1Nv?=
 =?utf-8?Q?hSfJnHAiRwKC+OE8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e55ddd-87f1-4470-054b-08da39268041
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:31:15.0412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zc5K+lrCc7jfVjb9s3ji3Uld3YCIHWRH8Ve3CDtQjxmv0cjhwiyIyIk3hg5h0Bo1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3227
X-Proofpoint-GUID: -2jp_DInhT--NpxV9kTIDAKhJ8reA3Uz
X-Proofpoint-ORIG-GUID: -2jp_DInhT--NpxV9kTIDAKhJ8reA3Uz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/18/22 4:07 AM, Jan Kara wrote:
> On Mon 16-05-22 09:47:14, Stefan Roesch wrote:
>> This factors out the for loop in balance_dirty_pages() into a new
>> function called _balance_dirty_pages(). By factoring out this function
>> the async write code can determine if it has to wait to throttle writes
>> or not. The function _balance_dirty_pages() returns the sleep time.
>> If the sleep time is greater 0, then the async write code needs to throttle.
>>
>> To maintain the context for consecutive calls of _balance_dirty_pages()
>> and maintain the current behavior a new data structure called bdp_ctx
>> has been introduced.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
> 
> ...
> 
>> ---
>>  mm/page-writeback.c | 452 +++++++++++++++++++++++---------------------
>>  1 file changed, 239 insertions(+), 213 deletions(-)
>>
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 7e2da284e427..cbb74c0666c6 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -140,6 +140,29 @@ struct dirty_throttle_control {
>>  	unsigned long		pos_ratio;
>>  };
>>  
>> +/* context for consecutive calls to _balance_dirty_pages() */
>> +struct bdp_ctx {
>> +	long			pause;
>> +	unsigned long		now;
>> +	unsigned long		start_time;
>> +	unsigned long		task_ratelimit;
>> +	unsigned long		dirty_ratelimit;
>> +	unsigned long		nr_reclaimable;
>> +	int			nr_dirtied_pause;
>> +	bool			dirty_exceeded;
>> +
>> +	struct dirty_throttle_control gdtc_stor;
>> +	struct dirty_throttle_control mdtc_stor;
>> +	struct dirty_throttle_control *sdtc;
>> +} bdp_ctx;
> 
> Looking at how much context you propagate into _balance_dirty_pages() I
> don't think this suggestion was as great as I've hoped. I'm sorry for that.
> We could actually significantly reduce the amount of context passed in/out
> but some things would be difficult to get rid of and some interactions of
> code in _balance_dirty_pages() and the caller are actually pretty subtle.
> 
> I think something like attached three patches should make things NOWAIT
> support in balance_dirty_pages() reasonably readable.
> 

Thanks a lot Jan for the three patches. I integrated them in the patch series
and changed the callers accordingly.

> 								Honza
> 
>> +
>> +/* initialize _balance_dirty_pages() context */
>> +#define BDP_CTX_INIT(ctx, wb)				\
>> +	.gdtc_stor = { GDTC_INIT(wb) },			\
>> +	.mdtc_stor = { MDTC_INIT(wb, &ctx.gdtc_stor) },	\
>> +	.start_time = jiffies,				\
>> +	.dirty_exceeded = false
>> +
>>  /*
>>   * Length of period for aging writeout fractions of bdis. This is an
>>   * arbitrarily chosen number. The longer the period, the slower fractions will
>> @@ -1538,261 +1561,264 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
>>  	}
>>  }
>>  
>> -/*
>> - * balance_dirty_pages() must be called by processes which are generating dirty
>> - * data.  It looks at the number of dirty pages in the machine and will force
>> - * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
>> - * If we're over `background_thresh' then the writeback threads are woken to
>> - * perform some writeout.
>> - */
>> -static void balance_dirty_pages(struct bdi_writeback *wb,
>> -				unsigned long pages_dirtied)
>> +static inline int _balance_dirty_pages(struct bdi_writeback *wb,
>> +					unsigned long pages_dirtied, struct bdp_ctx *ctx)
>>  {
>> -	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
>> -	struct dirty_throttle_control mdtc_stor = { MDTC_INIT(wb, &gdtc_stor) };
>> -	struct dirty_throttle_control * const gdtc = &gdtc_stor;
>> -	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
>> -						     &mdtc_stor : NULL;
>> -	struct dirty_throttle_control *sdtc;
>> -	unsigned long nr_reclaimable;	/* = file_dirty */
>> +	struct dirty_throttle_control * const gdtc = &ctx->gdtc_stor;
>> +	struct dirty_throttle_control * const mdtc = mdtc_valid(&ctx->mdtc_stor) ?
>> +						     &ctx->mdtc_stor : NULL;
>>  	long period;
>> -	long pause;
>>  	long max_pause;
>>  	long min_pause;
>> -	int nr_dirtied_pause;
>> -	bool dirty_exceeded = false;
>> -	unsigned long task_ratelimit;
>> -	unsigned long dirty_ratelimit;
>>  	struct backing_dev_info *bdi = wb->bdi;
>>  	bool strictlimit = bdi->capabilities & BDI_CAP_STRICTLIMIT;
>> -	unsigned long start_time = jiffies;
>>  
>> -	for (;;) {
>> -		unsigned long now = jiffies;
>> -		unsigned long dirty, thresh, bg_thresh;
>> -		unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
>> -		unsigned long m_thresh = 0;
>> -		unsigned long m_bg_thresh = 0;
>> -
>> -		nr_reclaimable = global_node_page_state(NR_FILE_DIRTY);
>> -		gdtc->avail = global_dirtyable_memory();
>> -		gdtc->dirty = nr_reclaimable + global_node_page_state(NR_WRITEBACK);
>> +	unsigned long dirty, thresh, bg_thresh;
>> +	unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
>> +	unsigned long m_thresh = 0;
>> +	unsigned long m_bg_thresh = 0;
>>  
>> -		domain_dirty_limits(gdtc);
>> +	ctx->now = jiffies;
>> +	ctx->nr_reclaimable = global_node_page_state(NR_FILE_DIRTY);
>> +	gdtc->avail = global_dirtyable_memory();
>> +	gdtc->dirty = ctx->nr_reclaimable + global_node_page_state(NR_WRITEBACK);
>>  
>> -		if (unlikely(strictlimit)) {
>> -			wb_dirty_limits(gdtc);
>> +	domain_dirty_limits(gdtc);
>>  
>> -			dirty = gdtc->wb_dirty;
>> -			thresh = gdtc->wb_thresh;
>> -			bg_thresh = gdtc->wb_bg_thresh;
>> -		} else {
>> -			dirty = gdtc->dirty;
>> -			thresh = gdtc->thresh;
>> -			bg_thresh = gdtc->bg_thresh;
>> -		}
>> +	if (unlikely(strictlimit)) {
>> +		wb_dirty_limits(gdtc);
>>  
>> -		if (mdtc) {
>> -			unsigned long filepages, headroom, writeback;
>> +		dirty = gdtc->wb_dirty;
>> +		thresh = gdtc->wb_thresh;
>> +		bg_thresh = gdtc->wb_bg_thresh;
>> +	} else {
>> +		dirty = gdtc->dirty;
>> +		thresh = gdtc->thresh;
>> +		bg_thresh = gdtc->bg_thresh;
>> +	}
>>  
>> -			/*
>> -			 * If @wb belongs to !root memcg, repeat the same
>> -			 * basic calculations for the memcg domain.
>> -			 */
>> -			mem_cgroup_wb_stats(wb, &filepages, &headroom,
>> -					    &mdtc->dirty, &writeback);
>> -			mdtc->dirty += writeback;
>> -			mdtc_calc_avail(mdtc, filepages, headroom);
>> -
>> -			domain_dirty_limits(mdtc);
>> -
>> -			if (unlikely(strictlimit)) {
>> -				wb_dirty_limits(mdtc);
>> -				m_dirty = mdtc->wb_dirty;
>> -				m_thresh = mdtc->wb_thresh;
>> -				m_bg_thresh = mdtc->wb_bg_thresh;
>> -			} else {
>> -				m_dirty = mdtc->dirty;
>> -				m_thresh = mdtc->thresh;
>> -				m_bg_thresh = mdtc->bg_thresh;
>> -			}
>> -		}
>> +	if (mdtc) {
>> +		unsigned long filepages, headroom, writeback;
>>  
>>  		/*
>> -		 * Throttle it only when the background writeback cannot
>> -		 * catch-up. This avoids (excessively) small writeouts
>> -		 * when the wb limits are ramping up in case of !strictlimit.
>> -		 *
>> -		 * In strictlimit case make decision based on the wb counters
>> -		 * and limits. Small writeouts when the wb limits are ramping
>> -		 * up are the price we consciously pay for strictlimit-ing.
>> -		 *
>> -		 * If memcg domain is in effect, @dirty should be under
>> -		 * both global and memcg freerun ceilings.
>> +		 * If @wb belongs to !root memcg, repeat the same
>> +		 * basic calculations for the memcg domain.
>>  		 */
>> -		if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
>> -		    (!mdtc ||
>> -		     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
>> -			unsigned long intv;
>> -			unsigned long m_intv;
>> +		mem_cgroup_wb_stats(wb, &filepages, &headroom,
>> +				    &mdtc->dirty, &writeback);
>> +		mdtc->dirty += writeback;
>> +		mdtc_calc_avail(mdtc, filepages, headroom);
>>  
>> -free_running:
>> -			intv = dirty_poll_interval(dirty, thresh);
>> -			m_intv = ULONG_MAX;
>> +		domain_dirty_limits(mdtc);
>>  
>> -			current->dirty_paused_when = now;
>> -			current->nr_dirtied = 0;
>> -			if (mdtc)
>> -				m_intv = dirty_poll_interval(m_dirty, m_thresh);
>> -			current->nr_dirtied_pause = min(intv, m_intv);
>> -			break;
>> +		if (unlikely(strictlimit)) {
>> +			wb_dirty_limits(mdtc);
>> +			m_dirty = mdtc->wb_dirty;
>> +			m_thresh = mdtc->wb_thresh;
>> +			m_bg_thresh = mdtc->wb_bg_thresh;
>> +		} else {
>> +			m_dirty = mdtc->dirty;
>> +			m_thresh = mdtc->thresh;
>> +			m_bg_thresh = mdtc->bg_thresh;
>>  		}
>> +	}
>>  
>> -		if (unlikely(!writeback_in_progress(wb)))
>> -			wb_start_background_writeback(wb);
>> +	/*
>> +	 * Throttle it only when the background writeback cannot
>> +	 * catch-up. This avoids (excessively) small writeouts
>> +	 * when the wb limits are ramping up in case of !strictlimit.
>> +	 *
>> +	 * In strictlimit case make decision based on the wb counters
>> +	 * and limits. Small writeouts when the wb limits are ramping
>> +	 * up are the price we consciously pay for strictlimit-ing.
>> +	 *
>> +	 * If memcg domain is in effect, @dirty should be under
>> +	 * both global and memcg freerun ceilings.
>> +	 */
>> +	if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
>> +	    (!mdtc ||
>> +	     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
>> +		unsigned long intv;
>> +		unsigned long m_intv;
>>  
>> -		mem_cgroup_flush_foreign(wb);
>> +free_running:
>> +		intv = dirty_poll_interval(dirty, thresh);
>> +		m_intv = ULONG_MAX;
>> +
>> +		current->dirty_paused_when = ctx->now;
>> +		current->nr_dirtied = 0;
>> +		if (mdtc)
>> +			m_intv = dirty_poll_interval(m_dirty, m_thresh);
>> +		current->nr_dirtied_pause = min(intv, m_intv);
>> +		return 0;
>> +	}
>> +
>> +	if (unlikely(!writeback_in_progress(wb)))
>> +		wb_start_background_writeback(wb);
>>  
>> +	mem_cgroup_flush_foreign(wb);
>> +
>> +	/*
>> +	 * Calculate global domain's pos_ratio and select the
>> +	 * global dtc by default.
>> +	 */
>> +	if (!strictlimit) {
>> +		wb_dirty_limits(gdtc);
>> +
>> +		if ((current->flags & PF_LOCAL_THROTTLE) &&
>> +		    gdtc->wb_dirty <
>> +		    dirty_freerun_ceiling(gdtc->wb_thresh,
>> +					  gdtc->wb_bg_thresh))
>> +			/*
>> +			 * LOCAL_THROTTLE tasks must not be throttled
>> +			 * when below the per-wb freerun ceiling.
>> +			 */
>> +			goto free_running;
>> +	}
>> +
>> +	ctx->dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
>> +		((gdtc->dirty > gdtc->thresh) || strictlimit);
>> +
>> +	wb_position_ratio(gdtc);
>> +	ctx->sdtc = gdtc;
>> +
>> +	if (mdtc) {
>>  		/*
>> -		 * Calculate global domain's pos_ratio and select the
>> -		 * global dtc by default.
>> +		 * If memcg domain is in effect, calculate its
>> +		 * pos_ratio.  @wb should satisfy constraints from
>> +		 * both global and memcg domains.  Choose the one
>> +		 * w/ lower pos_ratio.
>>  		 */
>>  		if (!strictlimit) {
>> -			wb_dirty_limits(gdtc);
>> +			wb_dirty_limits(mdtc);
>>  
>>  			if ((current->flags & PF_LOCAL_THROTTLE) &&
>> -			    gdtc->wb_dirty <
>> -			    dirty_freerun_ceiling(gdtc->wb_thresh,
>> -						  gdtc->wb_bg_thresh))
>> +			    mdtc->wb_dirty <
>> +			    dirty_freerun_ceiling(mdtc->wb_thresh,
>> +						  mdtc->wb_bg_thresh))
>>  				/*
>> -				 * LOCAL_THROTTLE tasks must not be throttled
>> -				 * when below the per-wb freerun ceiling.
>> +				 * LOCAL_THROTTLE tasks must not be
>> +				 * throttled when below the per-wb
>> +				 * freerun ceiling.
>>  				 */
>>  				goto free_running;
>>  		}
>> +		ctx->dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
>> +			((mdtc->dirty > mdtc->thresh) || strictlimit);
>>  
>> -		dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
>> -			((gdtc->dirty > gdtc->thresh) || strictlimit);
>> +		wb_position_ratio(mdtc);
>> +		if (mdtc->pos_ratio < gdtc->pos_ratio)
>> +			ctx->sdtc = mdtc;
>> +	}
>>  
>> -		wb_position_ratio(gdtc);
>> -		sdtc = gdtc;
>> +	if (ctx->dirty_exceeded && !wb->dirty_exceeded)
>> +		wb->dirty_exceeded = 1;
>>  
>> -		if (mdtc) {
>> -			/*
>> -			 * If memcg domain is in effect, calculate its
>> -			 * pos_ratio.  @wb should satisfy constraints from
>> -			 * both global and memcg domains.  Choose the one
>> -			 * w/ lower pos_ratio.
>> -			 */
>> -			if (!strictlimit) {
>> -				wb_dirty_limits(mdtc);
>> -
>> -				if ((current->flags & PF_LOCAL_THROTTLE) &&
>> -				    mdtc->wb_dirty <
>> -				    dirty_freerun_ceiling(mdtc->wb_thresh,
>> -							  mdtc->wb_bg_thresh))
>> -					/*
>> -					 * LOCAL_THROTTLE tasks must not be
>> -					 * throttled when below the per-wb
>> -					 * freerun ceiling.
>> -					 */
>> -					goto free_running;
>> -			}
>> -			dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
>> -				((mdtc->dirty > mdtc->thresh) || strictlimit);
>> +	if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
>> +				   BANDWIDTH_INTERVAL))
>> +		__wb_update_bandwidth(gdtc, mdtc, true);
>> +
>> +	/* throttle according to the chosen dtc */
>> +	ctx->dirty_ratelimit = READ_ONCE(wb->dirty_ratelimit);
>> +	ctx->task_ratelimit = ((u64)ctx->dirty_ratelimit * ctx->sdtc->pos_ratio) >>
>> +						RATELIMIT_CALC_SHIFT;
>> +	max_pause = wb_max_pause(wb, ctx->sdtc->wb_dirty);
>> +	min_pause = wb_min_pause(wb, max_pause,
>> +				 ctx->task_ratelimit, ctx->dirty_ratelimit,
>> +				 &ctx->nr_dirtied_pause);
>> +
>> +	if (unlikely(ctx->task_ratelimit == 0)) {
>> +		period = max_pause;
>> +		ctx->pause = max_pause;
>> +		goto pause;
>> +	}
>> +	period = HZ * pages_dirtied / ctx->task_ratelimit;
>> +	ctx->pause = period;
>> +	if (current->dirty_paused_when)
>> +		ctx->pause -= ctx->now - current->dirty_paused_when;
>> +	/*
>> +	 * For less than 1s think time (ext3/4 may block the dirtier
>> +	 * for up to 800ms from time to time on 1-HDD; so does xfs,
>> +	 * however at much less frequency), try to compensate it in
>> +	 * future periods by updating the virtual time; otherwise just
>> +	 * do a reset, as it may be a light dirtier.
>> +	 */
>> +	if (ctx->pause < min_pause) {
>> +		trace_balance_dirty_pages(wb,
>> +					  ctx->sdtc->thresh,
>> +					  ctx->sdtc->bg_thresh,
>> +					  ctx->sdtc->dirty,
>> +					  ctx->sdtc->wb_thresh,
>> +					  ctx->sdtc->wb_dirty,
>> +					  ctx->dirty_ratelimit,
>> +					  ctx->task_ratelimit,
>> +					  pages_dirtied,
>> +					  period,
>> +					  min(ctx->pause, 0L),
>> +					  ctx->start_time);
>> +		if (ctx->pause < -HZ) {
>> +			current->dirty_paused_when = ctx->now;
>> +			current->nr_dirtied = 0;
>> +		} else if (period) {
>> +			current->dirty_paused_when += period;
>> +			current->nr_dirtied = 0;
>> +		} else if (current->nr_dirtied_pause <= pages_dirtied)
>> +			current->nr_dirtied_pause += pages_dirtied;
>> +		return 0;
>> +	}
>> +	if (unlikely(ctx->pause > max_pause)) {
>> +		/* for occasional dropped task_ratelimit */
>> +		ctx->now += min(ctx->pause - max_pause, max_pause);
>> +		ctx->pause = max_pause;
>> +	}
>>  
>> -			wb_position_ratio(mdtc);
>> -			if (mdtc->pos_ratio < gdtc->pos_ratio)
>> -				sdtc = mdtc;
>> -		}
>> +pause:
>> +	trace_balance_dirty_pages(wb,
>> +				  ctx->sdtc->thresh,
>> +				  ctx->sdtc->bg_thresh,
>> +				  ctx->sdtc->dirty,
>> +				  ctx->sdtc->wb_thresh,
>> +				  ctx->sdtc->wb_dirty,
>> +				  ctx->dirty_ratelimit,
>> +				  ctx->task_ratelimit,
>> +				  pages_dirtied,
>> +				  period,
>> +				  ctx->pause,
>> +				  ctx->start_time);
>> +
>> +	return ctx->pause;
>> +}
>>  
>> -		if (dirty_exceeded && !wb->dirty_exceeded)
>> -			wb->dirty_exceeded = 1;
>> -
>> -		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
>> -					   BANDWIDTH_INTERVAL))
>> -			__wb_update_bandwidth(gdtc, mdtc, true);
>> -
>> -		/* throttle according to the chosen dtc */
>> -		dirty_ratelimit = READ_ONCE(wb->dirty_ratelimit);
>> -		task_ratelimit = ((u64)dirty_ratelimit * sdtc->pos_ratio) >>
>> -							RATELIMIT_CALC_SHIFT;
>> -		max_pause = wb_max_pause(wb, sdtc->wb_dirty);
>> -		min_pause = wb_min_pause(wb, max_pause,
>> -					 task_ratelimit, dirty_ratelimit,
>> -					 &nr_dirtied_pause);
>> -
>> -		if (unlikely(task_ratelimit == 0)) {
>> -			period = max_pause;
>> -			pause = max_pause;
>> -			goto pause;
>> -		}
>> -		period = HZ * pages_dirtied / task_ratelimit;
>> -		pause = period;
>> -		if (current->dirty_paused_when)
>> -			pause -= now - current->dirty_paused_when;
>> -		/*
>> -		 * For less than 1s think time (ext3/4 may block the dirtier
>> -		 * for up to 800ms from time to time on 1-HDD; so does xfs,
>> -		 * however at much less frequency), try to compensate it in
>> -		 * future periods by updating the virtual time; otherwise just
>> -		 * do a reset, as it may be a light dirtier.
>> -		 */
>> -		if (pause < min_pause) {
>> -			trace_balance_dirty_pages(wb,
>> -						  sdtc->thresh,
>> -						  sdtc->bg_thresh,
>> -						  sdtc->dirty,
>> -						  sdtc->wb_thresh,
>> -						  sdtc->wb_dirty,
>> -						  dirty_ratelimit,
>> -						  task_ratelimit,
>> -						  pages_dirtied,
>> -						  period,
>> -						  min(pause, 0L),
>> -						  start_time);
>> -			if (pause < -HZ) {
>> -				current->dirty_paused_when = now;
>> -				current->nr_dirtied = 0;
>> -			} else if (period) {
>> -				current->dirty_paused_when += period;
>> -				current->nr_dirtied = 0;
>> -			} else if (current->nr_dirtied_pause <= pages_dirtied)
>> -				current->nr_dirtied_pause += pages_dirtied;
>> +/*
>> + * balance_dirty_pages() must be called by processes which are generating dirty
>> + * data.  It looks at the number of dirty pages in the machine and will force
>> + * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
>> + * If we're over `background_thresh' then the writeback threads are woken to
>> + * perform some writeout.
>> + */
>> +static void balance_dirty_pages(struct bdi_writeback *wb, unsigned long pages_dirtied)
>> +{
>> +	int ret;
>> +	struct bdp_ctx ctx = { BDP_CTX_INIT(ctx, wb) };
>> +
>> +	for (;;) {
>> +		ret = _balance_dirty_pages(wb, current->nr_dirtied, &ctx);
>> +		if (!ret)
>>  			break;
>> -		}
>> -		if (unlikely(pause > max_pause)) {
>> -			/* for occasional dropped task_ratelimit */
>> -			now += min(pause - max_pause, max_pause);
>> -			pause = max_pause;
>> -		}
>>  
>> -pause:
>> -		trace_balance_dirty_pages(wb,
>> -					  sdtc->thresh,
>> -					  sdtc->bg_thresh,
>> -					  sdtc->dirty,
>> -					  sdtc->wb_thresh,
>> -					  sdtc->wb_dirty,
>> -					  dirty_ratelimit,
>> -					  task_ratelimit,
>> -					  pages_dirtied,
>> -					  period,
>> -					  pause,
>> -					  start_time);
>>  		__set_current_state(TASK_KILLABLE);
>> -		wb->dirty_sleep = now;
>> -		io_schedule_timeout(pause);
>> +		wb->dirty_sleep = ctx.now;
>> +		io_schedule_timeout(ctx.pause);
>>  
>> -		current->dirty_paused_when = now + pause;
>> +		current->dirty_paused_when = ctx.now + ctx.pause;
>>  		current->nr_dirtied = 0;
>> -		current->nr_dirtied_pause = nr_dirtied_pause;
>> +		current->nr_dirtied_pause = ctx.nr_dirtied_pause;
>>  
>>  		/*
>>  		 * This is typically equal to (dirty < thresh) and can also
>>  		 * keep "1000+ dd on a slow USB stick" under control.
>>  		 */
>> -		if (task_ratelimit)
>> +		if (ctx.task_ratelimit)
>>  			break;
>>  
>>  		/*
>> @@ -1805,14 +1831,14 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>>  		 * more page. However wb_dirty has accounting errors.  So use
>>  		 * the larger and more IO friendly wb_stat_error.
>>  		 */
>> -		if (sdtc->wb_dirty <= wb_stat_error())
>> +		if (ctx.sdtc->wb_dirty <= wb_stat_error())
>>  			break;
>>  
>>  		if (fatal_signal_pending(current))
>>  			break;
>>  	}
>>  
>> -	if (!dirty_exceeded && wb->dirty_exceeded)
>> +	if (!ctx.dirty_exceeded && wb->dirty_exceeded)
>>  		wb->dirty_exceeded = 0;
>>  
>>  	if (writeback_in_progress(wb))
>> @@ -1829,7 +1855,7 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>>  	if (laptop_mode)
>>  		return;
>>  
>> -	if (nr_reclaimable > gdtc->bg_thresh)
>> +	if (ctx.nr_reclaimable > ctx.gdtc_stor.bg_thresh)
>>  		wb_start_background_writeback(wb);
>>  }
>>  
>> -- 
>> 2.30.2
>>
