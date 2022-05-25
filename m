Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37E5345F8
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240895AbiEYVq0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiEYVqY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:46:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6117B326EA;
        Wed, 25 May 2022 14:46:22 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtZ3x017161;
        Wed, 25 May 2022 14:46:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KlMnZsAUL5PYN06naRFfK2uJ9dFn7fs640I0fsriMYg=;
 b=YHEmWaIsSDo94vrHhbkzwULOcrMnGUqdZa3UG5s6/tevEQxSTqlpva7inKYdbXuI9BrC
 ixaTr8vZtMpAUHpFWRljWoH48LeobluHQcpWEYV/F0vCLidjHNaxNcrHtRiAyK7aj+T3
 5+laUnZsqA5TI/yIJd0ofoQKBNc+bjq1SiI= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93vs9647-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYW0EGR2xm3MJaD51A6w5i1r+5/KAG+2NpO16qWQ1we0bN9mdPul++IFdJx/tdS8vxNwIOrD6Jtqur+KFuZW0W/8lAO4u+c+DoEVDoxah1U/1KY+JCKoFZ31JQrG7E3SaeDJu6xBbPn5WBlye5hXF8T3d6bpvM3pPvooRepzBR+y2d6Ldz0EdoCtyVMzMeaypV4KIqLVsm5iE6QT/Tdb53yyAibANrC1tlPze3+jGp0Jh6HWXFrOOIJHzt4PjOV/svaVPq0OIxAOP+fOuvZco3I1N6J8ltE/GFegMxSghUejmARNH0u8K7AcYiUJbTpm85Krs8uIQvoYW1i8zsKVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlMnZsAUL5PYN06naRFfK2uJ9dFn7fs640I0fsriMYg=;
 b=BwHZJKm+H8gEeL/lPHdNYlBcZENNJ+Ee0EZzyJzEOBD2i4HwelLoAPV9Q8uYzTQpdSu5G2xdaSczsN/GLZDrj7RRtVKbW3Ei3/t4sp2LVLjm0M9b2qhLS+maxj6a5GM3xWLHk/svGnbuNBCs6w4Ac+qlEOrDOJ9mPI58B/NnELP35eLbpTRgBcuwDntRn7uURfrK4hSEUVNut3q+A026RtuSXdCHNKi5esd1GWdCXOlPPqCpIXrUXawXNe0xfOP+5hdB3c1cbS0WuS3q939/qt296eJ1OYvkGwHWgFmsYAlukwpIvmQb35xRLvV1+IzIJHgIEUCugpmPfNoncknA8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB2606.namprd15.prod.outlook.com (2603:10b6:208:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 21:46:12 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:46:11 +0000
Message-ID: <e074d96b-0447-866b-1ade-73bbc5688577@fb.com>
Date:   Wed, 25 May 2022 14:46:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 12/17] fs: Optimization for concurrent file time
 updates.
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-13-shr@fb.com>
 <20220523105152.36hpyx7jd2fsy2i5@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220523105152.36hpyx7jd2fsy2i5@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:a03:167::35) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92eded03-7c83-49ca-5c50-08da3e97fc1f
X-MS-TrafficTypeDiagnostic: MN2PR15MB2606:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB26061E64E9ACEF7E1DB6EC55D8D69@MN2PR15MB2606.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Es+qB0C09BIW/VV/nLc6R9lVmoYLgHLHdwTWNewOLP1/6NtkUQnlyV7M101aXLXkEI9AnLs9xZNVdZ4ZgktBAZbLvtTf3vCpbLeAzygSdtHGfjN12orZO+6iuJU4ltJEV2Vyl0JN8EMHTxuS8kDr3L0exx01lIJw3zjIXpG0RnMtg7eyejFnyDky29Oq+OxFA9Z4FwnWwe56n5qlimGQbBYxXtjD9tnPrHesVVb3i1+olxNuake+DyadQtfUgmecAYh05gvDGkP/4ojKP6ckcLBGErPCv1ui6nnaPAXSvetR1LYa+/okPOXyCg+xoJVyAerZucwuU9PpbaM3IuhieqtN5ymCR4tdQlUlat1gsejwcl5DD/FtyKcuvAr/TMPpwp9e/ntwyZEPxznS0p/WzxWJsKbQ9A0TlMwupNrhUnXw2KKvoWtona7KdUiWzM/16CJnYIFZPWzP3nYIRJ8U6fWwzoLTC9VcZmSuMdV/bh941sLDdSgG8i0ZshcvH2NRJMOP+hzvyAZa4huWSn9EQrN2zv1rIwc00TncYOIXBqvQtgi3HKLltoU5WsIP6FXQDisIH+bbRpEUm9L+2Ow6svQT6ATCeol0qTHkXyqxI72qXpL9dRbnjWcTq4LZnxDiG9LBq4tG4BncTrj2kx7n7MA1E4rZHtFk+oalCIdM50WwAB0fKKRKWsr33yzG/UP8RDIuwd9vJEhmZMOhwV1uVeShDU7h3zEAONW54nGqzf5TixFlaMGPhj7qGRv1I0qL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(186003)(8936002)(36756003)(316002)(38100700002)(31686004)(83380400001)(2906002)(2616005)(6512007)(4326008)(66946007)(66556008)(15650500001)(66476007)(5660300002)(8676002)(6506007)(6486002)(53546011)(86362001)(508600001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VElKeEg5bUR1SFEwRThhZkVLT05zT1lvMnBYN3RKd1R0ZFd2TlZqeEx1UGdT?=
 =?utf-8?B?WUhjWXFEbGYzVFZwZ0hBNG1rVDE5dnhwUnE1Wk95SVV6NlpBNWNTclE4YWt0?=
 =?utf-8?B?MVNmeVl0cVlMdXpNTXFZZlVyM01mMW1rSmVtNDljVjZyM0l0QWVoNU5oeWVh?=
 =?utf-8?B?blFSNExCZTFjTUh3UHlKREpTaUFKNk84bDYyVEQ1VWlXQmdYK1lYZ1pSY0pS?=
 =?utf-8?B?V2lMbEw3M1EvTTY5SlFJNzczVW9wd1ZhZlQvZHNIczUxY1NEcFpsSnJyaFdj?=
 =?utf-8?B?N1YvelR0NENpSzU3UDBOZW5ENUFVMFBLSk94UUdjTGpzMERWdjBYS3J5ZXRW?=
 =?utf-8?B?amFsME5EMDlZdWdlTU9Da1ZGd3dEdHlSTlUxR1A1eWU3cjc5S29iWkZQcTdC?=
 =?utf-8?B?dGdoNVVzdTF1UVcwbVJXbk5GeDVHYk43ZTdFQ0Y1VDFwL3FoRUtuTU9namsz?=
 =?utf-8?B?ZEdlWFNmaXR0VW84Ni90aTFBem9oejRxVUkveC8wbkh5SGJJWTM3ZGhGY1Zn?=
 =?utf-8?B?QmpxY1JEaGZiWXp3d3kyaytiTjZSYVh2Z2RGaHhiK0dQbXZiTVE3VDJweGJS?=
 =?utf-8?B?cGp0ZG8wN2ZCQ1N3Vnc3MitzUlUwZWdiRWh6L21qY2ZMdkFNZ0xramZtRlAr?=
 =?utf-8?B?bk80TndVS3R3ajByckFjWDZON1o0WFhIVHU3MUZzbDlFMzdNYk5HVWdnTjJY?=
 =?utf-8?B?VlpVWXJqelRXTE5Wb3NhVncwOGdwRnViclFJM0IxdjBpdi8rMWlqUDRnRkJl?=
 =?utf-8?B?bFlPVlA2ZUo5bGY4VWQrMnE4MnZEZjl0VzZOZEpOVmwwWkFmRWNDQVVPdG1W?=
 =?utf-8?B?STVqWXZnRDJIWDc0Vi96TmRqblVtdno4Y3VWdVFaUHlZekdzTWxHM1pGUEN3?=
 =?utf-8?B?UExma0RPTzhJSHByVWlpL0NkTGovWm1aWmhReGVjczNlalQ3ZVVDSkFoNDQw?=
 =?utf-8?B?dWEvQ1BHbmhvYmcraWVpdStHM1dDMG51RUZXT0ExK3BXOVJhWmxvVmdKTlpK?=
 =?utf-8?B?bHg3NFJSVkRrUWh0OCtNcHlVQjF2ZStHSjdJdjlFYWw2Sk5GblhJL3IwWW5L?=
 =?utf-8?B?VXNLait2S1BzSXp0R0dCMHdOR2lnTmsrdkY4M2Z6T0VLZlh2Q1lLYkd5b25U?=
 =?utf-8?B?NDhySmRlOTdRN0dWRWRjTmZZYTg4VUNIUTRpaEorOEZNcmdxRUJNNjloM3Vu?=
 =?utf-8?B?QnNaWi9jUDhoZklEWXZJV2VzdUNlWGxwdzQvRzZBcTQvcXNUR3ZxSVlnQ1Q1?=
 =?utf-8?B?NUFUNjNNTjBrdzNxblRYZ24xb0g0cGlqQnFrRmJhVDE5M2U0Mk5wMENkSUdH?=
 =?utf-8?B?bXphVkRQYlJSU2d3NGU0TjZEZ1U0QkN5N2NycmpVYThpd3pUdVBrcmFXVll5?=
 =?utf-8?B?N3VnQzBvR3BsN3QwaVJVRHQ1RnlzWWhXeVZUWW9FZkNCWVBiQzlaQ1Z3TjFa?=
 =?utf-8?B?ZTc4L3U3REZ3MXA2eElLeXlYdDBnR3BFUS93YlRZRnM0UTIya21Hc3hmTzBs?=
 =?utf-8?B?U2NJRzR5dXFLVkkva0s4ZVFKN2dMckJCQmllSnNDc0hpS0VCN3JEUHJHYXNB?=
 =?utf-8?B?N2oySlhLSGNPOHJXdnpsZnpsaEJDc3lvTWs4S3NUR1E1S0k2cHdsWEZDVkhT?=
 =?utf-8?B?cVA1MlNXUEhrR2Vtc2lEeDdxQTRXWDF0WnFSR3VrU0Z6Rk1FTXQ5Mklxb3Vm?=
 =?utf-8?B?Y1U2QzJXOXFRMzFNT2pYcXl2M21GWHlRcjJZS1pxbWVUaDJxL3l4NmVXMWZC?=
 =?utf-8?B?aTg3TjFkalR6YnhRRkhyNGtSOTBpRko1N0pVRG82MVMrdmk4UzNlS2dYTXpO?=
 =?utf-8?B?OGU3NkxTQWNGZUNXOTJ2Z2dYMDlGc3g0WEFKRWtnVFhoNkFZQlpqUHpjK0xr?=
 =?utf-8?B?TFVVVTdqWmxLQjhhRWhOVzBqOXhYdnBUeTZ5SkxSMW84czJmRFpzZTlDeXE0?=
 =?utf-8?B?L3A3eFhkdXE2MVpJeCtsM3oyMm9XdVNaMTFsbEl2TEVhdUlRS2h6Nk05QWRO?=
 =?utf-8?B?b1BYTHJDZWpqQml0bVNNcWFqSkxsK2ZFRm45UENUbTJ5aDMzYWQ3b2FFS0N5?=
 =?utf-8?B?aTlwSkxHdU1uM1M4S2ZnMVNVMXlPdlVpY01uU296Rmo5aW5HK0JCZTQ4aXlr?=
 =?utf-8?B?RWZvMW15Y2I2VS84ODJiNDRma1dBbHk2M2pKdnk5L3c1YUpBVm14L2IxekJ6?=
 =?utf-8?B?cnhxMi9TbXNBOEp0ZmRZYVhiVWRkK1Q0WkV2clAvdGtkeHQ4N0Vjd0g5a25I?=
 =?utf-8?B?OWozUzRYQjlvLzMxMGk0bHI0NGJlNmN0MTU0VTNKNlBQY0JSeW5wb1hNdm5N?=
 =?utf-8?B?VW9hVHY1dHllRnFDMlRiU3R4WUUrcVdSNExkTjk1Z0dOdHJoYWFBYlB1azZw?=
 =?utf-8?Q?MBOLx4T6sGUzL5g4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92eded03-7c83-49ca-5c50-08da3e97fc1f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:46:11.8493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMC5G8MX5FApzyP0k43xKFgADb1Z8bUyPr8rBlnxN+fnXuruUM0nsMXnJ/VKVSL+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2606
X-Proofpoint-ORIG-GUID: BYQBH03n3PIKdubF5x6PyzLqgqV5E_Sc
X-Proofpoint-GUID: BYQBH03n3PIKdubF5x6PyzLqgqV5E_Sc
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



On 5/23/22 3:51 AM, Jan Kara wrote:
> On Fri 20-05-22 11:36:41, Stefan Roesch wrote:
>> This introduces the S_PENDING_TIME flag. If an async buffered write
>> needs to update the time, it cannot be processed in the fast path of
>> io-uring. When a time update is pending this flag is set for async
>> buffered writes. Other concurrent async buffered writes for the same
>> file do not need to wait while this time update is pending.
>>
>> This reduces the number of async buffered writes that need to get punted
>> to the io-workers in io-uring.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
> 
> ...
> 
>> @@ -2184,10 +2184,17 @@ int file_modified_async(struct file *file, int flags)
>>  	ret = file_needs_update_time(inode, file, &now);
>>  	if (ret <= 0)
>>  		return ret;
>> -	if (flags & IOCB_NOWAIT)
>> +	if (flags & IOCB_NOWAIT) {
>> +		if (IS_PENDING_TIME(inode))
>> +			return 0;
>> +
>> +		inode->i_flags |= S_PENDING_TIME;
>>  		return -EAGAIN;
>> +	}
>>  
>> -	return __file_update_time(inode, file, &now, ret);
>> +	ret = __file_update_time(inode, file, &now, ret);
>> +	inode->i_flags &= ~S_PENDING_TIME;
>> +	return ret;
>>  }
>>  EXPORT_SYMBOL(file_modified_async);
> 
> You still didn't address my concern that i_flags is modified without the
> protection of i_rwsem here. That can lead to corruption of i_flags value
> and rather nasty (and hard to debug) consequences. You can use
> inode_set_flags() here to make things kinda safe. The whole inode->i_flags
> handling is a mess but not yours to resolve ;)
> 

Replaced directly manipulating the inode flags with calls to the function
inode_set_flags().

> 								Honza
