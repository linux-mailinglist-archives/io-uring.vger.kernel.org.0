Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32BC53467C
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 00:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiEYWdO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 18:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiEYWdN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 18:33:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C575DEE6;
        Wed, 25 May 2022 15:33:09 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtdXQ023267;
        Wed, 25 May 2022 15:32:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NPAxKGO+OLS88PIoH1vcl+HlEBaWJG5xq8poHkLZY24=;
 b=cC7nDHovNOFqFkvSasYATHWorovKT+L+R7CUZccAwym8C7oU5kric6LNl83dMMhwn3cp
 0n7z0BcUCsiwbMqeVlDmFbiAMmx0IilZA0EbqMcGE65G1s9gLwEreiknhd4+Q8qZpm2y
 5OKVV/RyhB6pV5OY1KDvCQYRqq6+QwwwnLA= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93upsd05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 15:32:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl6QYHmREtRNZ5Du9z/lgl6agwsr1W2C15ZsDf43iRDKd9+qa1c7IvSxzwk5rdS+HRQ1DcrKSQlBdrvZMmX9LRWWB6FtjqmilyNjwaGJgs5FNrn/KjSSmaTqAy7fquO/GanYqqm57ptkPt2VdCURCGW9M7Y6CUTUzyexzEHnUqNyw+VHRAkysfsfLxr4sQwdnkqRpYODL8mgiM/IMv0pTT6R2r1/Jug5+gdYdcjNfDXYKmV/cQ//TjwgWWEposx/kEdGxyGyLVzbvVYhUa2eTufQaaiZcaxuAwCH4XyJSVzBpKfd+jPsccrOwB13EXoKYDyDmjN85T5zbJz+iew+cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPAxKGO+OLS88PIoH1vcl+HlEBaWJG5xq8poHkLZY24=;
 b=QqOSi9jT1EMuGi8oAZzTTvuv58UUl8EQNQDh0RXn86WZ7gtJ8jddDBCraznbNJ4Rlbh3fK24B6U5B2ldZeDegAGkuL9Gf5k++z2xilappTYG/rIIAS02QK71uRETh+sWQGyKV5YC5CMJ3uZQ5lob4LuKf24UulhVpgnHCBtEHk4HECS7jOCykb904cntwW82eJbloO6i+h5odMfAepy7w4ndRsuo/jXP+To+gcrFJt0wey1Qrvbo2s7BjBdyYWyrd8ElZTNUYS9nNvb/9tavUKqSiSt+Xb8I7E4VX8iEu8zwKz5CQuLyXFDSBH8UzVJaZi0sf7w9n6uat6ms3j+dCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB3261.namprd15.prod.outlook.com (2603:10b6:208:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 22:32:56 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 22:32:56 +0000
Message-ID: <29c47ff8-61aa-5357-9189-a0664dc88c84@fb.com>
Date:   Wed, 25 May 2022 15:32:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 10/17] fs: Split off file_needs_update_time and
 __file_update_time
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-11-shr@fb.com> <YonmadckyAqakY7d@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonmadckyAqakY7d@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::19) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1ab2157-6bd8-40dc-ccd6-08da3e9e83b8
X-MS-TrafficTypeDiagnostic: MN2PR15MB3261:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3261FB02519DB312DEB7DEBFD8D69@MN2PR15MB3261.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nnfg51CmAv5yN4RLD/njCyHQbl5ZpWh8Rhy5vZllvaCf07vi6dJhhTXkQy8mMi1Wh/GdrVHNvcK9uzAtukePDozEf1z/80SVJETOgO3Kk16z8bWpSLRh5LwpHRsgIWrUkooBBGrueCXmz7orZJmu83/hYnwLp9WsgjUopAh0AI+KjDkEFP7hZc+lXM42dsleBc0DX2WgCZnI9ycYWjMs7A92bHsPhFJRMmaoaiDBBwRXsnP7KIVzvSBn9scd/yO/ArDBjUbu+6kT9n3GsCn7FT5pOlOLG1d7drPxYrPGULMZn1fLHbIjphZRz5LF71pQy9zccN1BJERo+8zD5UmERK2/P+3yTkRTQo9Vi7L++PwoKnSNbz40yD3sceJo71DN0WtzxAlGtqmY1Z5eBTQpHFnlq77+TANr7G/MHXG7OrULTbpRYZXcIUJNRSgQbat9axpXVajni2n0R4J9IQbEcBDWcO/WPFvWtj5O+yV8T8ipszR1iKrt3iDKNHg0Iap4GbnLOgRLhbksi2h3DZAQTPDeAbn1Jukf2i5h+6NU+0rWfkgllykzDDA7tuqO00yIkfNwfDpU640GKoPRWFVHYDD9qlw+ULtb2da0ic7nfIX7FBmn8nvFLDDNHuMSsEjeZOma+I30Zyoorz/ws6RRXn8yO6N+ROH8qdnC0c0A0f9RyLag8ycpmLpcbpW8sX3vRCfvSnwdiMuq1KaMcP2FuBKxgA12rRVJExnHoXuVSmS7SQrRZd351T1rJVO0mmf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(8936002)(6486002)(186003)(83380400001)(5660300002)(6666004)(2906002)(53546011)(6916009)(316002)(6512007)(2616005)(36756003)(4326008)(8676002)(66556008)(38100700002)(66476007)(66946007)(86362001)(6506007)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2p1NE94bHhEVW4yRmNYYWlDandQdnVwMGRwL1hHQWRBTFd5cXptWExwTjFn?=
 =?utf-8?B?aDF4bmYvSDJhVERnNlZ0TVF6ajhjMWo4ZjR5WGUvTWRmdGozLzZId3htK1pR?=
 =?utf-8?B?M01UbW1hd2xOMXZyWGdLTGJLTlRiVmxIdFY2NXVDRDJrSXJ3bnZoNm1rNHVR?=
 =?utf-8?B?bjZMN013cUVVMy9tY0ZobmNhcng0eVh4RUp3ZWREVXpIUzZZMmlYbm5oOHJE?=
 =?utf-8?B?WHVja00rWW9oYTR2RHpkR0pMWEkxRk14Zkw0aEZ1TWdqZGZWWlJQc2pLUWx2?=
 =?utf-8?B?RTRUUk40RkJOcnU5aDBjbmVNSVl5WWg3cU1ybk1tbmUxRHFZOVlnTUF6RVB5?=
 =?utf-8?B?Slh2N0QvZmw4eTRBc0QzL1ZoTFk2SGhzN21qRERma0JnS0lLMjFZU0hwMCtG?=
 =?utf-8?B?ZXMwd215UUphRmQvNUFORkNrWkRIQkdSWno1MmdJWUJGUHFyQVFGTHQvYnV3?=
 =?utf-8?B?YTM2UFhzUVFsaFRheEtyVExpSWhRQUVJU2xadnpQT2lkL1VaNS9abGxGUFhS?=
 =?utf-8?B?T3BHa00yZldLdzBKV29xR1hpY0E5M1FnMW9McU8zalpiL1NCeHdnL2REenBv?=
 =?utf-8?B?Y1BXTnprUDRVS25YVEJRUHhwdXVudi9uK2w5di9RWXZSSWkvMGl2VjU2SkN4?=
 =?utf-8?B?NTlEUVJxNVAwbmx3eEhvM285SWhNOS9iYzFJQ1JpRzhxK0srNkRmTncza2dz?=
 =?utf-8?B?Vi9TcTZSYmJYR2xXSmVBdExvam43dWd1eWZLN2dGSXNvM0lsYzVrbjJHeFVp?=
 =?utf-8?B?TE9ITTQ5SEFUTk53SkIwQXRVKzhuMUQyazZzN0tvQUV6OWNKanJWVFc4TDc4?=
 =?utf-8?B?aUZwTkltZTFSNmhLelF3dm9PRTJIcndUWDZYa0hkdFBCcEFGcFhMOGZIbFZl?=
 =?utf-8?B?YSs3dFJlWU45SjVJaURXTnBKeWE2b1l0UWQ3VDF1amptMjhQL1ZCdHVCNXN0?=
 =?utf-8?B?UGJSNHR0MkNVcXNjZnNDbVh5OU9YbkplbFJVYkNWYzcybjI3MWhMT2JJcnRU?=
 =?utf-8?B?dS9zY3JQREtEeExkZFd4VWZsOUZQeGJDVWExdmVuakNqTndNaktLMFRrYS9u?=
 =?utf-8?B?Ky9meUxMcE5IZVRjaUJiV3huenNHYUpiQ25JUEkrZjlSb2xWNnhScytYM1pv?=
 =?utf-8?B?cFczTFZzVjdKQlNwa3hJeHNCODEvUjIzalpsTURYSjFTUzVuT2xGdFN6U0tj?=
 =?utf-8?B?L2t3MkcvaEI4dnpJSklnQzVaZDNhOUhZTG03WlhmaS9MbFVESVVGTTdaRlRJ?=
 =?utf-8?B?OUZseGhnRWlJaUxybm1pRUw1ZzNzMVFOcmkvWG9SY1ZXdUliTzY4RUlHQWlX?=
 =?utf-8?B?NUIrKzZwRzRLek1lRE5zTGFtZm50clBFY0NPWlVnMXpSYld0MmNjb3M5NjVR?=
 =?utf-8?B?VFo0ekFtRGNXdHg1M1VjODc4OFIyc1MxYlFjcjVMZkU2OEFIL3R2YnpRNGpR?=
 =?utf-8?B?VmExQ3ZNS05tZm9KSXZTQUlGanlCZVFERS9WTkxma2pubVBXd0QrcVlzOW0x?=
 =?utf-8?B?anBGRFlEcG5jdkxhVkZFQzI2Y2duRUZaTDhKZUhja1oxWDFqRFhqT3NiZld0?=
 =?utf-8?B?Z2REdGg4aStEeFA2T0xNcUxMQUE5Nmo1cGZSRkFYK2h5VkpVTjF1Uit3Yjg1?=
 =?utf-8?B?OUVnbHNjaXdmZHVRNVovNk03UmZ5VEp1YTQ0UzJzc1RKYnVobHFtZzR2Y1NE?=
 =?utf-8?B?Vk1TdzZwaWFLNnJVRnl1WEdqQ2MrQnAxT2drR0dxRnVVby9pam5hdlFYOXZh?=
 =?utf-8?B?UThDS2hwSFoyckpHRjdPQUk3bUM0K2lJc0l5Q2dEaGdkeXNsNDlhUC9TcTEx?=
 =?utf-8?B?UE0rU3FrUlplTXV1ZTRPS01jY3o4MjZOM21Hc2hzL0ZFYks2dWlMVk1pWVJC?=
 =?utf-8?B?RUpRaXp0anhXeUxRa0NiamsxSkJvZkRGQ3FUcGRnUDIzd0hwUmdIeFpoaFZJ?=
 =?utf-8?B?M1owTW1rY09WdjdhOXRCWWJtQWpkRUdQOFIzdWhWVjF6WkJVdHdYNE4wTVVz?=
 =?utf-8?B?NmxlZFEwaUd5SDUrcGZkK1czNGpnOTJFRXJaSHNpbWo1bllFN01qRHlrc1JV?=
 =?utf-8?B?UkhZRnY5QXhjZkNFcHVRRE5vY3J3eUNQWW10bUljNlpkMkQ2QjRpeCtHSnRM?=
 =?utf-8?B?WlU2RisyN2xJSGR5bWcrL3pVekxhREtPdEFDVHdoVmhTMnhqeVM1LzVIWER5?=
 =?utf-8?B?MGdCcHcvWXppQkRpQVErMWJyR0dqeEI4RHl1V0RFZTRuQ0xmcC9DbS8wczRU?=
 =?utf-8?B?N0x5WUpvQlhIUlJuUVJnVWV3U0tUalBsN3RReWtndEpVQSsvUUZhc3hWaGhJ?=
 =?utf-8?B?QTFONW1aYkExQTBTY2FIR0pENXBNenYyZWtXZlp3SUZYYXlkZjZpT2tPZXdQ?=
 =?utf-8?Q?ZLLgDaTaBauPnkmY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ab2157-6bd8-40dc-ccd6-08da3e9e83b8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 22:32:56.3746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgaUj51/uX2V9z8zcf13yW55xXefkYuN6B5gEMLuvzg6P+fQ2duURGgtFLpAQ1EY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3261
X-Proofpoint-ORIG-GUID: o5t0jI4rNjdtpORhOrzP19KGF-ueCyzi
X-Proofpoint-GUID: o5t0jI4rNjdtpORhOrzP19KGF-ueCyzi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_07,2022-05-25_02,2022-02-23_01
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



On 5/22/22 12:29 AM, Christoph Hellwig wrote:
> On Fri, May 20, 2022 at 11:36:39AM -0700, Stefan Roesch wrote:
>> +static int file_needs_update_time(struct inode *inode, struct file *file,
>> +				struct timespec64 *now)
>>  {
>>  	int sync_it = 0;
> 
> No need to pass both and inode and a file as the former can be trivially
> derived from the latter.  But if I'm not misreading the patch, file is
> entirely unused here anyway, so can't we just drop it and rename the
> function to inode_needs_update_time?
> 

I renamed the function to inode_needs_update_time and only pass the inode
pointer.

>> +static int __file_update_time(struct inode *inode, struct file *file,
>> +			struct timespec64 *now, int sync_mode)
>> +{
>> +	int ret = 0;
>>  
>> +	/* try to update time settings */
>> +	if (!__mnt_want_write_file(file)) {
>> +		ret = inode_update_time(inode, now, sync_mode);
>> +		__mnt_drop_write_file(file);
>> +	}
> 
> I'd be tempted to just open code this in the two callers, but either
> way works for me.  If we keep the function please don't pass the
> inode separately.

The inode is no longer passed in.
