Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEBD5345C2
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbiEYVaf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345360AbiEYVad (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:30:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98616814B4;
        Wed, 25 May 2022 14:30:31 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtbG0017303;
        Wed, 25 May 2022 14:30:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5CkFR14RHas5C1TnY2io3N5HEMt9fZ3uv2NR9G65jQs=;
 b=hxv15kNA9OQ12k34g1OWeKkdE7CJy4IVPqdp8NLo+AXd//ZSB1Rziliukk6a+eGUkdUB
 eGj2ozzLCOUnOXM3VpP4YjEDmbgn4DaH0A859C4pMEHsFRPCgugzHm6IDkp23FoMxwpy
 o3I22VVqdd3ejbWe2cgwaDkk08NSs3RNLzQ= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93vs93dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:30:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daBrBKkEG2hxMzWcCXRbEBlUmRFBzf3Pztvegvzwnbi3O4DuuBixBeZJnHuyFGtBJ9jtshqcnD/ORvVqJaSrhuIsHuUxz6qHd6IhbN8Klrsc0pLRZH8w/GyusGhmBZ6J1K3e2XIVDNBbLa1rzdLQJ9t2hoQHuwBhhy0KYw8i1V5geev2gg9NFI5vBC8Fla7bMJL6qiP4x2355NYFN413oO1WnM/V1e1OVBJIfcjxTzYod9TLxR+V+ugrum5lp16nD80UIGSMRgbRTbGrirSISyHvs8YuRWqVn4dOqtGan4WBuVY2j7MBXIv4VGlrPEniJ4hiWjFWfbZuKilxr+tugQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CkFR14RHas5C1TnY2io3N5HEMt9fZ3uv2NR9G65jQs=;
 b=QAiXD3hUjfnSHsCBX07MbGyishBwgBWkwvqpdsRj7B0wZkjPGnv/3FYQfEhmBWIBVfGHl/0yKxduDiMWz4SaQDGYtyKzkN4EdNsYwaQpwlX+2jJ/HlKckTZld2quDxdGUbsxok/IOd+D/NSRqS5WANfaOmn6U/tV7z4xvojj+3zr9Suh9jTbKob7Mg35m7KBpCUe3X2l6D6O/NSMLhOgZjus4OJ3kfSpohg940kCFXyMq6fxl2zTEv2hD9Fr2tz960GxE2Kz/szIXiIzS2w35v3kfH3lH+k7TuBcJ81Cq7RRWKkZ5pd8aLrGgNb9P2jj2omST/2uyQkeh7lsaxWcAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB3168.namprd15.prod.outlook.com (2603:10b6:208:a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Wed, 25 May
 2022 21:30:23 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:30:23 +0000
Message-ID: <649f4390-d7e5-960a-339a-7a780d9fb576@fb.com>
Date:   Wed, 25 May 2022 14:30:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 03/17] mm: Prepare balance_dirty_pages() for async
 buffered writes
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-4-shr@fb.com> <YonjnENVHY0/s1dg@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonjnENVHY0/s1dg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::6) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b14c36-2095-493f-4313-08da3e95c69f
X-MS-TrafficTypeDiagnostic: MN2PR15MB3168:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3168D7A3C30447B95A0A84E4D8D69@MN2PR15MB3168.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UH1w3JkEzsVMVT3unQVWhwG9bJa9ChtLUz5K2s6TKsA2L5T7MdkYqmyE/JJpuxJPirMeMvvHXBuJaXQCaJ2YyVOnoltBQZExb05LtBqEN1otNKvOh2KbvD17YCC8ugealC9vvffX6nnk/wl2Pl5u9pWIBO1xhtdeud6tkcyaB6vdLLKjSfkVDDZ99YxnqVholOCpza3odVfV47b5JG8dbcfWvEHB2lAAWoJ7qcQqoCLB4bolgkc8tmPWdsWT7SXJQwCMnnuJ6MnrqjiyhaMJO3ECjLWWzQypEnel/1bYD80VOI4BwLTmuqDB21jyAwEN+yL3eaoWNLM17ZZUTS/ieTjLf8391QYXfFUfJX1KfjwbgV+Sot6Ltffv82VTeN1+aUiiIt5VrviM77pb8G6nRXvrJiuq3AAOphBuO+gxUu5G/O/i4Do6iUzeHIwop3tFhHCFsPz0VgGKCOCMEDEfgEQWry5RYMz7/KeQQo6keIx2vvixB1hjx8QxD5D94k/5+JQdhJZ+18wRo73UHrVU7uJEIbyXI7WFoYHBI/9R5q0ZUkb1gpbngk/sSxx8yHerADONcUJJoCRQ6/tsiG99lD5yG2iO/Ohh/85cqCaGhLUHizU18wEksNLlbe4nsJ37iVnTePJDLpCvIMOWSlneFlY6sJWrkSUHv8Pwkh7a9FyUXAXZGKk4t+xcCk2IGIG4S40kEucbE6v4KGEMYSBs/wc/+h1OI6Y4mEKddfe3Nwjb4+4hUIOe9ZB8dKvCSQJObQbqr1kcVmZtSAD0mUWaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(6486002)(86362001)(66476007)(83380400001)(8676002)(8936002)(6512007)(6916009)(6506007)(53546011)(31686004)(316002)(38100700002)(31696002)(66556008)(5660300002)(4744005)(2906002)(36756003)(66946007)(4326008)(508600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2tjMHh6VzZ0TERQYzFnbTQ1VnlkL2dXNXZYVFhDbmw1d1pOdk1KbU5ublhy?=
 =?utf-8?B?SkdZc3pNbDZTSHFSMWI2Y1JHUURSSU92Tlo0MDlJUy9tbVRCcGtEbEJEVjVi?=
 =?utf-8?B?Ny9iM0x1NHBIWDJsVlZtQzhKLzVFeDR1aHVQWW5pRTlYWDE2Zys3d3phclRN?=
 =?utf-8?B?eWtlUE50TzgzQ1JRQW1WVXh0N2RHRTI2dC9HazErRkhndnNnTHdNc3BGcC9C?=
 =?utf-8?B?VGIxTW91czhlaTBSQnFhNXNsRVp3cEY0MWZscTlDMDJtdFVDaEJIRmNHbUJF?=
 =?utf-8?B?T1dRWTN6R1pFZkFxa0t6RWw3aTF1TUtJMWRHWjdYU2NoeEFiN2V0Mjh4RkZX?=
 =?utf-8?B?ZENySG8xWUZiN3FWUFo3eWNMS2xIOVZRdUlPQjNvODFiMmwvVW0ya1o1bUMy?=
 =?utf-8?B?aUtiTmx6SFhVTnR6NEt6NmxFbjhHOEVPbUMzUktDNlB5MWRJZy9UR1E1RXY2?=
 =?utf-8?B?eXY0aWNxZjVFYmlpMldPbFZEZGc1Y0tIWERtb2ZWbXFhTkFkdjR6M2RlTURV?=
 =?utf-8?B?cXp0d2NWaFdHV3IzWnIwRVZxVzVXZnJnVnBDanFZQ1cyWTBuejFZVDRrYjg4?=
 =?utf-8?B?QURmWEgrUjZWRG9UZGw3TElhYVZ5c3RoWjBGZkJ0ZzhCNk9KakxnSmQrR0Nt?=
 =?utf-8?B?R1prNjBXcUJDMUhrTXB4YnRXUk9NN29rWStIU2JuVzFmUEdmZE50VlR5RHJl?=
 =?utf-8?B?TTNwSjN6K0JiQklLTkVFZVZDL3UyL1RpOUZNNyttN0dTR2lqZHFHMFRzdi9Z?=
 =?utf-8?B?bUJLU2tuam5vSm9MSUhOUCsyU1RwMzh3YWttazNuQ1BzVlUvU2t5dEQ2ZmVB?=
 =?utf-8?B?Qm9aTGhYNDk5Mmp3WUdDTVVCTjJLbmVCazIzTlBpQzJXZjlFMFU3SGRLVWli?=
 =?utf-8?B?YnBqR0dUWnBReExFWm9Wb3ZSTkRxNk5aWWJyQ0VHQUh3aTZ5ZWgraThlSkVO?=
 =?utf-8?B?MUlCVjdmUGo5YkE1aEdVSEV2TFlwZTJRUVJsOXExbElmc3VLMXBKckhlYjNi?=
 =?utf-8?B?YS9sbXZOWkJWNzg1ZUZwSzhNVFZsM2RnT21jMGRsaWx1UnRQbVhrVThDL0wv?=
 =?utf-8?B?WTN6NW4vNDY4b2swa1Y0SnBxQjFDYUhzckR2YnZyemJSaVFoQnloYkZRZHF2?=
 =?utf-8?B?QWZwZnhkWm9zOE03LzgrSHFiRDl3WWFnejNmVE1kbjhxZlViT0ViR0xDMmE2?=
 =?utf-8?B?c01YMVV6UXdIUXlyaWxPbkZtMzg0NEl2NXdUQm9pZFlhVTBpOHRwTUtJa05K?=
 =?utf-8?B?VmROVXRNUHVmOENsd3FRVHRsblBKNFQ0YXpKZnVrMUdselRvNkp6S1QxeDlM?=
 =?utf-8?B?TUtVTUNuM0tQU2FJbGY5a1BRVGZXUUlLKzhMdlMxdmdOdFQ2Sy9QdXJWMXB0?=
 =?utf-8?B?eGh3WDJha0dTREFNUXRtUExEbi9HcW5BeHZmOFZabVB4bUEvd0tDZ2Z2WGF1?=
 =?utf-8?B?TTE2R3g5UnNPWE5IeXMzai9kUVJ0S3hSK3FTVk9IOEt0dU54cktuMGRSVTlu?=
 =?utf-8?B?SzR6WnI1MW9aRER1YWNSaHB1TmhuMS9xUTFMRG1yaC8rY1J6ditESS80QW1R?=
 =?utf-8?B?dElxTDVLOVVibDNYcGRkSWs0VEpQRWxyeDBVUFVCOWx0TVJJQ0Q5SWxZemtO?=
 =?utf-8?B?T2JlN0JHTTB2ZXdOVlJHaUhUa3NMZ05WaEhrbFNndy95RUJTUVE4dnhiOXMz?=
 =?utf-8?B?R2trcW1mTHVUSURpV3hULzh0L3lWSG9HK1FidXJiQkhZUUxrNDRrUDh2a2dx?=
 =?utf-8?B?SGIyNit0NWMvOTFVTVB5dDdibXBaaSt3eDlsMXNZejZNd0NHb013cG5tSFlT?=
 =?utf-8?B?dDNVKzBOWVVjTytNTzhPTjZxeUg0Ykxha3B5V1gxQk0ranNCUnM1VFZUTXNq?=
 =?utf-8?B?cThESEJyTW05cVdCTE02dzI1NUZIekxiVzVLL2JzUTJhTitjdS81NDdoVlpC?=
 =?utf-8?B?ZW1WVUZBdFUzQkFHWWV2UGVPRStoV1lYNjFnYVR0YjR3Wnl0OUNEbk5UZkYr?=
 =?utf-8?B?RjkwVkJNZHRCa095aTN1TmY3MDFyWGJQTnUwTjRKT25FSnVRWGdUN216NU1H?=
 =?utf-8?B?RGhlNkEwMXJJQ24rT0VPaDRvdHV2dkVDQ21HbnVDbkNYaHIyZk5sVkJUT3M5?=
 =?utf-8?B?T2VobW9xd2xpcnU0MWxMU0dBMGFWRWYyS1hoRVJnM2NFSnNJcmVUdGtobFJU?=
 =?utf-8?B?Ky9pSTZBalYyMUc2TS9sWGhrWm1ibHhoT1IyMmRYZ2l6TmpIQjFlRE5NdDhp?=
 =?utf-8?B?Y0lBakRMcDYrM1lQSWh2NnNJcm9VRVhHZVpFSUM3TVBTVzVQUDZPd1ZQcmlh?=
 =?utf-8?B?YVMrSjlhbmtnQnp5MHBEMEd4SGhtbjZ6dTFFVkFmOFdxdXdwdXl2bGFtWXJo?=
 =?utf-8?Q?Ejj9NLEA05rWk3Io=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b14c36-2095-493f-4313-08da3e95c69f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:30:23.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9eddgxtm/yThJZIkojIzlpPiApa6RBdjRJU7JgwUWP99QC/b3TpRgbXNIWkE0lC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3168
X-Proofpoint-ORIG-GUID: JIkUN0JrVpogLqKghfDuK_Sk1hX3Vi3_
X-Proofpoint-GUID: JIkUN0JrVpogLqKghfDuK_Sk1hX3Vi3_
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



On 5/22/22 12:17 AM, Christoph Hellwig wrote:
> On Fri, May 20, 2022 at 11:36:32AM -0700, Stefan Roesch wrote:
>> From: Jan Kara <jack@suse.cz>
>>
>> If balance_dirty_pages() gets called for async buffered write, we don't
>> want to wait. Instead we need to indicate to the caller that throttling
>> is needed so that it can stop writing and offload the rest of the write
>> to a context that can block.
> 
> I don't tink this really makes sense without the next patch, so I'd
> suggest to merge the two.

I merged the two patches.
