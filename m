Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A149252F29E
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352651AbiETSaZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETSaV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:30:21 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CA9170F28;
        Fri, 20 May 2022 11:30:19 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSICO010646;
        Fri, 20 May 2022 11:30:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=J41WGiXqO1y3NKt+0BdiDaD5IYhu6Cb4/GUZhZbmqqc=;
 b=TZa7uo6zKIINHuadSziQNrP40WylAVFXPuoo/kbS0RpjSuwxAkuM+LQ9WuFdmltYT85C
 vUhts2XlzIHLqxVdy2HAZHhsBonjXB6aacEIX3mtdRkAA8NFE6qB5MlkMOqhMG6BMCAV
 nYxMnBQbSRD8ZGqh1QZnJGoAgsn9qAh0ZPo= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6341cgsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:30:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3CuCklMn6WZBMA1A6Niv3UEYWScQzhvTkNd+0bmCrDjiEx5C2yb9A93ZhscqzWNZb6N92fJRGTa3frpT/2BywqE7Lg6QQMr08NcvS5lS0+OWMBJ/r1LZECjV7CmVINCZM6eDSi5zTocj8C5Tl1msP+wQBu6MKTwr4GmYsm3PCkuy4gJPO7a1Z6ECSjuOaLg//Bir3yGXs3h5lzFBiC7xW57KcGE9TnxqhEPjCxqGzxwS6YKTM8DgID9m6vhuPFmVnKl/V1a4TgxC0T3K//0IdFfBWSck2Mzpq8QVFKIzlYsitRvHdz93Gih8AO3o9wG5RKuLEzlt+p+Q5QzdiS25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J41WGiXqO1y3NKt+0BdiDaD5IYhu6Cb4/GUZhZbmqqc=;
 b=br+Bcw3RIJmzviZCmZbAlB+gbmZOpiHDMHGG4+IZQ0hsrhNWhMpY2C0wFKTG5oTg5TjtK2K2o5IwiEUpdrAZ89oD6RgRNh4g0mhO3ppASusfuZFeTmxvRRCxg6ioz+9KUkoLFEufJw/kK2eWbT60xlBJIaIW0fNZmcHttxs1NMjHDvKsTl3XJ3HBNErdK5UmgMYKe/xpBlgi5uCmU91gyb/Vqr6fxP4w3RPajLYmaDxF/dxnlhn4YaNn/Z2MRaUBgJL5NS4AJSeEa1T0ZozPl6YT4WOCrx97JjU6GOgMJK/pT4lxwWSJJHfHx7F6HnzbGtwj+v7AM6a1FzVl9jkLJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by CY4PR15MB1415.namprd15.prod.outlook.com (2603:10b6:903:f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 18:30:02 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:30:02 +0000
Message-ID: <55f152cf-735b-b4fb-c913-73d10c1c5872@fb.com>
Date:   Fri, 20 May 2022 11:29:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 15/18] mm: Add
 balance_dirty_pages_ratelimited_async() function
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-16-shr@fb.com> <YoX/4fwQOYyTL34a@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoX/4fwQOYyTL34a@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::38) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db3711fc-5951-4e64-cf3f-08da3a8ec029
X-MS-TrafficTypeDiagnostic: CY4PR15MB1415:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB1415884C186F73CBA1CDEAA7D8D39@CY4PR15MB1415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IuRFH6hhGmg6/Iwy3JuMEC0UyXNcmRg+mH6NmGtm7erlh8SESthIqTA1/5ZPlIvg7/RTbld35NsdwFSHMUOwUFxIX2HR9jrvAZaqWf7g+NY5Z5Jwv5XRxRpTE87VaZggYUO9Jpn23sCteNgnjHCATzm8FPB97Cv49OGKNcIOL8lLPwiukDCpSOLmCyWH92ZbSbRGWnfx/UNENnwJe2ucHsgBaHK2R1uFxKrFRpoXwkGMiiXSSt5gdC7Ieq3ufcd7OldUYaBiA36ptYC2s491bryr964afr2hl3p7dx3ej7EAjCM6KyZpaBU/nvPZPiHQo1Tu2i6ZDpVMQFPz2mpTt4skcCLR7yjYbHNv0bAv6ASHra5QdhKQbkDYXzk4viRTQo1FrFEwJRB7Nb5396cLI9ad2aw2j18EJ7V0bEGiRENan1cQ4wQYDtVZvbW6pMC55h/xPm9sR+lZzb7jFW66CA+O+s/CNvLsZnSMj6PWHklPhJ5OQ9q/OsgIpHKzryncQw58PuW7skLYGDOdlAA3jROKeN6UpRPoY3eQ2yXJALj5t/x7YrDPQ9GUCic7pd9KNrJ51raUB1UC0gNYjHpjspDlrCq2vIGbAO2nh00a3PoLsiFMX31S3J58+Yn8R7DyXrIqBYWjmFFo79wMx2uqDdc3HYtOWtGWFGKWuWGyyVXUlRf2aVckQ5nJajKmrgudYJgr2oFg9tc7oD3DGulBVAPPxR9ayl9mNroG76WhGmCmfx/hIzghGjmm1CIljSLFPI2KhuExResdd+//6YoZFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(508600001)(6512007)(31696002)(6486002)(6916009)(36756003)(8676002)(53546011)(38100700002)(6506007)(8936002)(31686004)(4326008)(316002)(5660300002)(86362001)(2906002)(186003)(83380400001)(66476007)(66556008)(2616005)(66946007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzFtRzJ6aXl0YzZJSHorWFZvMjRkRTZkWURwUWM1R255OFZxbEJ2bVdPbXNy?=
 =?utf-8?B?ZnhIdW9RQlNLMC95K29sZ3R0YXNGRjFXeEJmZnZEWStaVTl0RW1zSW53SHM1?=
 =?utf-8?B?WUo3NVQvZVF0ZlhjV2t6WHdNemZkeDd6M2RmVGZ3cXlER2cvV1lleUxXbk05?=
 =?utf-8?B?Z3JpM3dELzlGa1RlbjYrMUxpMUNmYnVOZE10RFl0ekFVYTVSWUlZQ2l1TURF?=
 =?utf-8?B?QTJqYkhPcC9zcnZLV0x1VDdrZ2s1L01zL2VROW9rMjJUMk5EUHdKQ2ZPRUdw?=
 =?utf-8?B?T2p6bTlYSDFELzE3SUpZdDN2b0YwdEVrUjZvd2lvUUhWMzFqVCtZR2NnMWZi?=
 =?utf-8?B?UkVmRGpaY1dyWWlHYzZ3akxOUUozZnV0aFBTZzhnWTUrcndtKzNocGowdTdR?=
 =?utf-8?B?ZXJ4SU5NZ2o5dTlROVBwdFlqdC9BdU5TUlFYZ3htWmNBV2MrQ3c2T2IxV1lH?=
 =?utf-8?B?YUJmUVFndjJLY01RWVhmMllzNUhkckd0NVpTWU1kdUlvQ0xXNkRGbCttN0Uy?=
 =?utf-8?B?azRtQ2VMMnBCZmd5R0ZZZFZtUTV0Qy9HbzI5M1lycXhoemZ2VDJLeWhMejZz?=
 =?utf-8?B?YkI5T3BQdUhKMlJGY3JVSG52QXR2S2V6TUd3cjAwOG8xVUplNjdJdnN5ZVM3?=
 =?utf-8?B?VUU0WFpZdVpGL2g2WU91cjJCVlpBWnNJYVlJTWJ3MTVSRENCM1Z1bUtSa2tp?=
 =?utf-8?B?MjkzYmxtVXBXMG92M2xUU2xVMHNIc0RtT2FsV2wxVkkzeXM0ZGl6Z0FHcW42?=
 =?utf-8?B?dG1DaXNNbHZsTFNuVGdyRnpkKzI1UmVBdDBHcWQ3aXRocmplWGlPQ3Z2Z3FJ?=
 =?utf-8?B?czAxSlM3TWh1MlJncE9JTGpxTG1vaXB0YmQrdDV3ajRNdTkrZEJia1p0cWJv?=
 =?utf-8?B?WWVVR2V2TWQxdjFoUXJWQjlGL000ZHhjQTUxK3RGQnk1SHFHM2x6aWY1K0lL?=
 =?utf-8?B?ZWI2TldJelJMZ3pGcEJSK1ZqaEtNQ3dRMHZDeUJSaDNpeXl4WUUyeCtVT0VN?=
 =?utf-8?B?c2d0YURaaGtnVVR0blNXeWhpTDZ5eXRIR1hUMkphQlhoWGFTVjVUWUNtK21z?=
 =?utf-8?B?WUhSY2xaR0FycjI5TFhtVFpQVHVXSVRRRmlWc3JIVXRQNXp1MldWRE4xdE5m?=
 =?utf-8?B?cWpiaXk5WnlFV09DcmhMUXN4WUJSQUlURVVzUEFBQlN3MFdPc21iWTV3bEhD?=
 =?utf-8?B?cHJCMkN5SVVPMFhFRk1xb1NUN0t6MW5LNlRUYjNOMlc2eFlMd01YL3c4Vm91?=
 =?utf-8?B?S05yaGJvdkEyMm5FR2V4dW52T1BpRUU4VUNoMlRVdWhVVndMcEN0cjhwRzlj?=
 =?utf-8?B?Vm5XVU9TRFN6SExmL0I1Q2hMc1NXTG9nek9pL2s2a1UrVVV6NWZmakVsaENW?=
 =?utf-8?B?MktOZFRwQllyS0FsMFY3SlVQMU5ja1JvRHdWRVByalZxcU8zY1JFUXAvTjVp?=
 =?utf-8?B?SWMrbGVDSy9VVmx2NC9MOFpHS3FvYlhVck9SN3hKeCtmS0RMbnVJYzc2VjVS?=
 =?utf-8?B?SGovZEVCeWRhZVh5ZUtKNkhkd2I1NzRLc1NhYitjWW1SWDZFZGx0bEN4Nmsx?=
 =?utf-8?B?Y3NsTWVFNDYxckFsUHZBbUVPNVl5bE8xL0drbkpFSDhEdGpvd1JBUzhSa1NG?=
 =?utf-8?B?STFBZExtYkhSY05HYTgwUGdVaXMyV1ZpOVB5WHZjaG9rckFMWUxMajBRMFZ6?=
 =?utf-8?B?R29BOERhZjgwUlMxM250SGJUQk1EcWtCbDV4NlNVSmhYUGxQTmFYWWI0dE1W?=
 =?utf-8?B?YWJtb0ExTExCSTVEOFkxbi9yaW51OThGdkFTNUFWQndqWHVrSndmclBPKzNy?=
 =?utf-8?B?clFmVHFKNE43bHBPWUpCYitMQTF0K09tU21GL1J6aTVNU1NlY2NSRnJWUVFJ?=
 =?utf-8?B?Z3dQSS9GbXVVbnJvK2pGREx5Y0VTazYzUmgwZG5rTHVpY1ZuR0lpbjczWHVi?=
 =?utf-8?B?Z3VaK2lsbWl6VGZqNlExYXNvYlRJNGZ5M21wNi92VUtmdjl0SDg4aWFEOWlC?=
 =?utf-8?B?TWt2SGd6Mi93cHppaTgxeERiTGMxRGdrVmJTem52aWdqVlpqTXN3aWNKYk1a?=
 =?utf-8?B?MlZ5RVlYWDBjZEFLOGZ0RzBhL2ZiRytvRng4Q1JNTFZPbU4ya0RrSkdzUG5w?=
 =?utf-8?B?RmJLYzZwTFVrVDZOdFBacEpKQWpUaldvK01EbFN4T2lUTDNYdG1hNldacVp3?=
 =?utf-8?B?ODUvdExVY05iT2JyWEtLUUZvZVhLZlpKZzJiNHlLdFRYa2p5SmoyamQ2SkRv?=
 =?utf-8?B?UW4yWVVqbm9qVGFTek9jSERkRjRyZXEvZmd2Nkp1NmthUllmRlRBV2FGUGJR?=
 =?utf-8?B?ZW9sQ0tvL1NQTndrdWJTczBrS3l1eTVueWR6ZWRtOGd2NWZJK1lhbTlyUU1D?=
 =?utf-8?Q?khTVMuFApTi1NcGs=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3711fc-5951-4e64-cf3f-08da3a8ec029
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:30:02.0091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pz4SMeUNUBwJftP2Ax2bpQpbNjsxdNp02p8vkOHjdQ8gJe+RdeBp1/nUZ2shtHop
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1415
X-Proofpoint-GUID: LRGLSAN5adKTRN3HYmQBxmPAZ0AStoEk
X-Proofpoint-ORIG-GUID: LRGLSAN5adKTRN3HYmQBxmPAZ0AStoEk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_05,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/19/22 1:29 AM, Christoph Hellwig wrote:
>> +static int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
>> +						bool no_wait)
>>  {
> 
> This doesn't actully take flags, but a single boolean argument.  So
> either it needs a new name, or we actually pass a descriptiv flag.
> 
>> +/**
>> + * balance_dirty_pages_ratelimited_async - balance dirty memory state
>> + * @mapping: address_space which was dirtied
>> + *
>> + * Processes which are dirtying memory should call in here once for each page
>> + * which was newly dirtied.  The function will periodically check the system's
>> + * dirty state and will initiate writeback if needed.
>> + *
>> + * Once we're over the dirty memory limit we decrease the ratelimiting
>> + * by a lot, to prevent individual processes from overshooting the limit
>> + * by (ratelimit_pages) each.
>> + *
>> + * This is the async version of the API. It only checks if it is required to
>> + * balance dirty pages. In case it needs to balance dirty pages, it returns
>> + * -EAGAIN.
>> + */
>> +int  balance_dirty_pages_ratelimited_async(struct address_space *mapping)
>> +{
>> +	return balance_dirty_pages_ratelimited_flags(mapping, true);
>> +}
>> +EXPORT_SYMBOL(balance_dirty_pages_ratelimited_async);
> 
> I'd much rather export the underlying
> balance_dirty_pages_ratelimited_flags helper than adding a pointless
> wrapper here.  And as long as only iomap is supported there is no need
> to export it at all.
> 

Thats what I originally had. I'm reverting back to it.

