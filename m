Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7415269B5
	for <lists+io-uring@lfdr.de>; Fri, 13 May 2022 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383479AbiEMS6G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 May 2022 14:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383480AbiEMS6D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 May 2022 14:58:03 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AAB6B7EE;
        Fri, 13 May 2022 11:58:02 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DEl6BS013727;
        Fri, 13 May 2022 11:57:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PRyErqwFMSIzXlQZdVC8rmovlu8CnauQNYtEPUsWVmM=;
 b=TqJomiKXKeZUJ+xosNs/Ig1GvHqsgR3yDSLHCtoSSIWP6kcGMoBad7OAwnhD2Qgm0aRh
 yrOjJQZtwtR0lWrrYY96gQI9r94MgrZ4/HcF5V/SujMOD5OW4luUbtW/R2P7vSEG4H1L
 91PTn3+ScsiAh0TVILKVLOCXVKR+gcGFDjA= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g19w9xvxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 11:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJfZ6VqxrifN84c3tAY+ppCkBa5FePWzB6HKuGFVlnteSk4tKqFI/4qro/vGY2DVM2BFwVwc771avZuq8sgjiraAt1ffHK80cwFhKFQQhigARSmwn/QvHOSGHHs5wliHSIn5CwyPVBkPU3ZiM+tWGHN8U7HJ/kZ+RRlkKd6btqVGVWIRxzioNJb/anqZxmemiioEGsbRmWdQbgCNI8H5nwsrhuqqBsvXXxlGPVP0E0h99tYmckBvo0cn/ym20M1znAweauzLxQpsplx8IMawSTdtYeEAGnmZaB+oTsICAWc4BMtA+NPpLyJj9RmyDYTahsDM1yUX76sDc4gsp7KkeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRyErqwFMSIzXlQZdVC8rmovlu8CnauQNYtEPUsWVmM=;
 b=VylriMfKI63ZOCI0rXk8YoGPm9VDJIsUtNYn7kREwjc1h0CxEiTp2+hrI5orlhUZaQCIAkVfVgcMHe7UGD/AnKcmLdZCa2rJDbGX7gF2xITUKcUJeNDkJfv9OlD1Z9ih41HTWekW2FPxnkCuYJRuwnq0e/YH9i2cGR1pGxk2xJQJkIv1GYX3zXLVdYPGzMXhEkqtsz3z647pP/7CBrKcZcbPZ1De16ZKAp/fYpuRyNUlsTqTFbbkf4NGH7LVCEgVMVTUuXjugA1GPpGvmbwsYdLdh5AVUvSN37FYEnhC2d3nn2rwN9PfN8/mIkILvlmoYI7owCBr4WCL8VtKI6SjgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BN7PR15MB2292.namprd15.prod.outlook.com (2603:10b6:406:8b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Fri, 13 May
 2022 18:57:54 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::9c16:7e77:808b:ffcf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::9c16:7e77:808b:ffcf%7]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 18:57:54 +0000
Message-ID: <7b021526-d6bf-cb23-0864-689dd83d6d78@fb.com>
Date:   Fri, 13 May 2022 11:57:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v1 15/18] mm: support write throttling for async
 buffered writes
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-16-shr@fb.com>
 <20220428174736.mgadsxfuiwmoxrzx@quack3.lan>
 <88879649-57db-5102-1bed-66f610d13317@fb.com>
 <20220510095036.6tbbwwf5hxcevzkh@quack3.lan>
 <84f8da94-1227-a351-56ba-eabdba91027b@fb.com>
 <20220511103819.e2irxxm2tvb3k7cc@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220511103819.e2irxxm2tvb3k7cc@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5fc84dd-696d-471d-536f-08da35127cac
X-MS-TrafficTypeDiagnostic: BN7PR15MB2292:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB2292374A2F6FE87C030D0A46D8CA9@BN7PR15MB2292.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y42pNzTDNUXG+0CzUYHFyiE4BKWCyelmzmvHU/CFic0xGZiW+orwxQQ2B5IumHDGgNhL9JtrfdzmnEcJ0bulYQlL1zGuwrEqyCXG9HWHq+Awz/4A79kJGa39Z47hyYScl62TGjVX8PQV81B6X+zs8MnxtByrFQiPzLFcPbfamK4WV/PdwdneXaUYJfOpGAORPvWJZMY8VQHlS3B1Xtou9IF+6NkepbGKDEQfGM6qXk4aHK5eq2EpupGnbYFLO/5rcqcA1Hhawwhs4cORHRCS5diz1jgT4AkDnXeiF2xHW4ey4aJBmlzZfy5QRUNVodP/wjW7yqrLzIkQbUc67UvaiB9KPETRVpckEHGuqeIP0kPvK1uwS1QdkGep7XL3/gWIpqmXB88SkGeVaMi4p88ankK3dgEKkbI4IHtU0nCRMuDUAZojqLWaA2jkUYYKxNXsHyk+NFhFL4ckfsWYhBXgFS1p6hqUPFPm/IO7H5f5e+gk8+m/lcgQCzEyMlRDtz+w5/pMwqzOMuMqcdCLqppjfNhNZIbha9UGGqOBtWcw8gRMvJit3o7BY+XoEDPKsHX50krotWwoFNYE3E69CByhEEq1hhlQYmqwBDBuA7Pv7/XHT+Z/15Q4Czir7QC4J2cuBFFyrsm8zzRSZyrf6v/4QC0zlI1AijUOpuzYbE9p2nrmtHm7G9yPRQZ3PRwkmh/64mSTIEWnCMmBdJQDvluGhtfA6M+/dHGtFNn05tfVbRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(53546011)(6506007)(2616005)(83380400001)(5660300002)(8936002)(6486002)(31686004)(2906002)(36756003)(4326008)(508600001)(8676002)(31696002)(66946007)(66476007)(66556008)(86362001)(186003)(6916009)(38100700002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmVrZDRsbmhycDA3eUV3alNGNm93L2IwcFR1TU1WVXJ6MENFU2R0TUNDYVBD?=
 =?utf-8?B?ZkRHYWFTUm1yMmpFRVp0bzhzUVRDVWFVWXZxYjU0TzQzZ0FtdFRNY05Ndkc3?=
 =?utf-8?B?cEVHd3RjUlI1NklqM3o4UW5YK0tqZGdYcUZPVlAzTVBOYTB2dzFNWmdPM0tS?=
 =?utf-8?B?ZVphVkl2WlZTcVl5U1dyYVlicWgvQzdGMERnaVVsdW45UWJiUHBTTkZJdmVm?=
 =?utf-8?B?RGFRaWhCdGh4MkdSdDZvMHdqSk9hUTYxV2VLQjZDMUZFN1VvZWNLbjhwSHBD?=
 =?utf-8?B?YmVYRzZvUnJRNkdrejBUMWFjK29WWW1kajQ4cjNEa3FUTElDdmhhOWl1S1dT?=
 =?utf-8?B?WmNOTS9ReEFuY1hXTThLek1Tb0dSc3Z6b3BWNzI4bm1nRk5MT0I1OHZDN2FN?=
 =?utf-8?B?WWVCcjFtRkNqOEM4eFhSMHpGeDYxeVo4c25ibXVORlgxMllNeTI2bFUzdC90?=
 =?utf-8?B?QlIwTk8zUWQyNm9TZnhXN2VnZnNkOWNnTVM5L0RldmFqUHhWWWRqWCttbmUv?=
 =?utf-8?B?T21tbXZtUU1McHVJOW5NeU9xV3pIUU9YaFplc21kTW9jeER0eTBDS3JiQXNS?=
 =?utf-8?B?bTh4bkNObjF0cHpxbVIydjMvNjNtaGNqWEwzNjNqcjdiUXN4VkY5WThHbitJ?=
 =?utf-8?B?NW96MEp5b3JrQ2NsbnJTbXc2dGFzMmhEUHVGeGlKbSsrRVU3UVpsU254V0I2?=
 =?utf-8?B?bHozZ1kwZUYwQ1E2Sktqa3owTWw0QkxWRmR5a3RjVVVHV2FWSmxvc3FXaVNx?=
 =?utf-8?B?WDlkb3h6MnJ2WlNpdXZsUDBiZVVtdExlOHNHeU8yQkpiQWdqclExOGw2bzB2?=
 =?utf-8?B?S2F6aC9teUcxMWRVU2hjRWdXKzZ3bldaVGE0NzBjZi8wWElQS204enJBc1BI?=
 =?utf-8?B?UHd2YlhxR3NVeFVRMFhNVEdFSWxHOFcrc0p4R2VWYlBYdHFrdGpEazVDbGpj?=
 =?utf-8?B?MVlqRXBOMlJKaWNUSlk5SVFZNUZ5RE85R3FqSDlsRWVZdHpnOWpZL1R5OS9L?=
 =?utf-8?B?dmNjTlNZL2lnbTVicGhsNmY4bUc1QnFwYVU3Ni81dkJrTjJvTVYyWEZOaFhh?=
 =?utf-8?B?cFpEYTFIWXA4NXViVlJ0cmUyTHBvS1J5czhkS2ZSUUs2QmZudmkvRS9sMlNE?=
 =?utf-8?B?cWRWWnhSZ0dHS29qZ3ZTT0FFZ08rVFhZWEZSNGw1ZkJibkk5RHN1SloxVXNU?=
 =?utf-8?B?bG10c3gwM0ZZRWl2Z2R3Um9xZzE4RHdXQlAveHRmdnNQdUpiODBUajV1dERn?=
 =?utf-8?B?VXBBZmYrbllBd0Q2eXM5azIxSXA1MkN2bjBlL1lLdlBUL0E5TTJsbjc0L1dq?=
 =?utf-8?B?UVljMGhVTnVGQW9BN0dNR04zUXBYSlhnUnJCTk1KdXVObXgxVWYzZlduaS9P?=
 =?utf-8?B?eVgwb2VLdmNUUTJrL3RHeDJESU5VbytCNFhlTWswWWNQcFRDditucC9vNVFY?=
 =?utf-8?B?MStpWGdTT2d5a2xyK1lnamJoUEtTaDlCT2phN244WFJWYWljcVpzdlFyM3Jq?=
 =?utf-8?B?L0tvakpSbnlBQVF5Y0t5UG5EYzdQbmNnczdOWFdVa3Y2Y2tnSW1mSmdYSjNI?=
 =?utf-8?B?MkgvRllNLzFFZGJXRW5YN0hJT2s4MDhCMlNrUGpCZi9zeVY4djZGa1lSL0Ns?=
 =?utf-8?B?VFVyeVBRd0N0azFWVGNpTG9SRGx5WDAzL0NxakQ0dm1kVEkwczlDR1VYclcz?=
 =?utf-8?B?MEJ4aTAwbm5uTXJnUXZYMG9LaGJ5TVF4OFRIQkNnTEg3YU8vVTQrUzJOL2lR?=
 =?utf-8?B?OW91MXZZRkVkU3ZDejJYTDFXZzVuOWovSHhlWHpXa0pScTA1TzNPM3FaV08y?=
 =?utf-8?B?MGVFMldjYXVvOFF5YVA1Y2VRWS9UdkF3NUdNSmp6cXZobFF1dU03TERCcWFy?=
 =?utf-8?B?aTNjWkJ6MHdGRWpsTUNCV1MwNmd5ZGtONEg4YUJyd3VqQmRpMDYyV0JLcGtq?=
 =?utf-8?B?M3g2cTQ4YzF1TlZzZlUvbi9NN2k4dytlZzV4VzhjaFBFbWVZd3M5T0RFNmJv?=
 =?utf-8?B?ZDZlcS9jVTFBRXZQZ3VUZ2RFTDFlQlJnTVJ6cnBoWDZYSTdXQktwcXFaVVBR?=
 =?utf-8?B?VjIwZjQ2cXUwUjZVTUlETmR6bWZxY1o0cWxhZmNIcTkzMzN0OWJpVy8vT0ZD?=
 =?utf-8?B?U3RHcG5hMllWeXdKelRHT2dKcFNjZXNBNWF4QWR4clJ5R3ViM0xlRG0ydG1T?=
 =?utf-8?B?dDNLd1BzMHRKODdMVGl0NnBuYmpueFpGM2RLS20xZUxXK3lXN1FIRVowVWVV?=
 =?utf-8?B?a3daK2xaMFArTGd3d3JMclZQZFg4bEFwblpGRjZPUjQ2d0tXV0R3WVRodEFQ?=
 =?utf-8?B?WklyZEdDNTZVdU9SdnQ5U1JHYVdCOGJGaHlxaE9RcjFCQk8wcGt3TThPWlJF?=
 =?utf-8?Q?McdX7ezOCQdM5slM=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fc84dd-696d-471d-536f-08da35127cac
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 18:57:54.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3vnkpOf2fvXCTBPTgfcxZ6oGvsVHNEQnTg+rKojen5UgAl+Uo2Kr5Y/NhBzXgmg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2292
X-Proofpoint-ORIG-GUID: cYKR3KLEakBkmWBNPAZFezBDRpU9DOfC
X-Proofpoint-GUID: cYKR3KLEakBkmWBNPAZFezBDRpU9DOfC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/11/22 3:38 AM, Jan Kara wrote:
> On Tue 10-05-22 13:16:30, Stefan Roesch wrote:
>> On 5/10/22 2:50 AM, Jan Kara wrote:
>>> I know that you're using fields in task_struct to propagate the delay info.
>>> But IMHO that is unnecessary (although I don't care too much). Instead we
>>> could factor out a variant of balance_dirty_pages() that returns 'pause' to
>>> sleep, 0 if no sleeping needed. Normal balance_dirty_pages() would use this
>>> for pause calculation, places wanting async throttling would only get the
>>> pause to sleep. So e.g. iomap_write_iter() would then check and if returned
>>> pause is > 0, it would abort the loop similary as we'd abort it for any
>>> other reason when NOWAIT write is aborted because we need to sleep. Iouring
>>> code then detects short write / EAGAIN and offloads the write to the
>>> workqueue where normal balance_dirty_pages() can sleep as needed.
>>>
>>> This will make sure dirty limits are properly observed and we don't need
>>> that much special handling for it.
>>>
>>
>> I like the idea of factoring out a function out balance_dirty_pages(), however
>>
>> I see two challenges:
>> - the write operation has already completed at this point,
>> - so we can't really sleep on its completion in the io-worker in io-uring
>> - we don't know how long to sleep in io-uring
>>
>> Currently balance_dirty_pages_ratelimited() is called at the end of the
>> function iomap_write_iter(). If the function
>> balance_dirty_pages_ratelimited() would instead be called at the
>> beginning of the function iomap_write_iter() we could return -EAGAIN and
>> then complete it in the io-worker.
> 
> Well, we call balance_dirty_pages_ratelimited() after each page. So it does
> not really matter much if the sleep is pushed to happen one page later.
> balance_dirty_pages_ratelimited() does ratelimiting of when
> balance_dirty_pages() are called so we have to make sure
> current->nr_dirtied is not zeroed out before we really do wait (because
> that is what determines whether we enter balance_dirty_pages() and how long
> we sleep there) but looking at the code that should work out just fine.
> 

I'll make the changes to balance_dirty_pages() for the next version of the
patch series.

> 								Honza
