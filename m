Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF4A52F2D1
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348676AbiETScX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352789AbiETScS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:32:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFCF4BB85;
        Fri, 20 May 2022 11:32:15 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSGlk010556;
        Fri, 20 May 2022 11:32:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=olFCmf/mHp2MDioL4FotCOCxvhjAKo2dc6T2hmhciJ4=;
 b=Zebdtxb+YPE65cDXccq0eOGsJyxgy9TqBcxSIAod1iDetR7kotSZV8aHzW5GQ35ZGCfS
 Xe1uYNC1WL3b9fW9shfI2ffeJttlByTKL4YwfZj7YTGHPzWNMphBfabPknTjq2wQf/M2
 8/wV9gUg/u8tqw5Xiz6SvnJNT4OQjReLAAc= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6341ch9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:32:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHOHvt5nOzF6T/d3BgwpNxc0Kp00rVQQBxD3FJy6OTSF+WA6momz3Wi9DEP74qMzP5ISw+ic0LgwpySvKtjh52ZpDu24TsPPeug/N1o5GcdCuTtmpQiXzGz3QKKp83wLXPj2EikHzAYBHFw8g8Bfn0tRX/ud+8KRWFu7y36LM3H9j4p5oLCINxI9kpfHt1hEbPiINXQsCGdoq41RjiRH/K8G8Tz/PpowrQklBHR5AvP8iaFFWjrcnc6NL0Uam+mylxXrG1+xzsriiZaab7vYnbKyTACXwVW75JN3iBVfrjnPYsBrPzblb4Z8kBUvYp9svJbxnc8P8dwgGVNVcBbDLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olFCmf/mHp2MDioL4FotCOCxvhjAKo2dc6T2hmhciJ4=;
 b=ns2g+5eDUGwUhy7MI3GGSXG1lRj5hiGUH+HdRT25PRbOfeSfTa87+RfNaUALITiqvGcH35+7QqcRiJ6PViQWAoKLuSJgJUzS6D75t7XatuiTJRief2PMF/JaziHWHDNKTMmyvZTc+9ISt0aJ2YuAoa/QKEB6XtQX+VmidSxUjskkHExZV4i2o2f/HVNrQThyrnzi+cZN68Tg8jt2+iR9kgXlQOjVBRYIbj4/YLbhkvnZtPQra88VrOXUOx4QA9AziYzsaA/f7YOc89jrKQUrpnP3fz6bCP2eC5A7dCTwrPmX8msAc4j35g1UzgIqrJ/VAUmrvrfEyhMMmFSFo++Itw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 18:32:07 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:32:07 +0000
Message-ID: <fd2c930e-1ca8-eb98-9dec-897584e8ae09@fb.com>
Date:   Fri, 20 May 2022 11:32:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 18/18] xfs: Enable async buffered write support
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-19-shr@fb.com> <YoYAuaT2y7dleHRZ@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoYAuaT2y7dleHRZ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37907962-d6ea-4b30-9783-08da3a8f0b43
X-MS-TrafficTypeDiagnostic: PH0PR15MB5117:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB511700FD502053FF05242CB2D8D39@PH0PR15MB5117.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IT9GLyiqN+ATA5g5bmcr5wVOKF4ZoV2GT/jnG+KmGjCokbag5nRZ9Ey0FftUJj9tpbtZw7juUfZ6SoN8hadj8c+dW0f2dXPj+hhtHYIOE30ChlWPqH9P18H40GlUIIyo96ITuOMiK7t8L5+fNUhQKuYhi1N3ASa71TDAUM33JdftFN/V1zfN/6KMXploJWXame2Gpii6QHp32mrSOBmUqjF+Y3VuviRhhg3sWE43OJNza7UM9hUJK7/ZAvfL+NXdIYGsQlEeTXS9UJT4l9DmZLWkzWMG/J+sYkUZCOVPsmNPQv9/68Lpt6qM/YkXAoLa2eixss5b0zdiBgg+aRda4XZ1QDrrhsC1K9kqQlr9eE/sczvv9wMoaUUCvYq4lj+3+iufNU9Mc9tpyLYHyigkGxVNq/QCRqw4NGBOLD4KYMgnC8lyL++FW34xV006OPXPeFM99ufK92QMMIOLaGuMwz2tZhUSpjcApgGRr8PMGP8j6hrLbOasRbgoHrjhsHINmyHA/FAXRCmh3t6EezXuRjYh14AK1uWHPZ7R3kEUQYbxOdF+fgrSkcovMTVkuHvB+mv0HuVkq2tFs8fsJGmssZsCRGDxGSJWsL8VQ5l2TCJdwOkRCVpSsoCx6Vbo81z7c9wmPOIQ6zRbYO1YWXm10x2JjCrP7j2NVoKkf/IMQ3k9cJCldeDWzcnsCPQuBNZuJPL41lAB/8/Ugq/5ckKUH6d63aQH6yvpN3BFqyPE3o2eKdNrOadwq8+NJxRIwVwF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(8676002)(66946007)(31686004)(2616005)(186003)(66556008)(83380400001)(53546011)(5660300002)(8936002)(86362001)(66476007)(316002)(6486002)(38100700002)(6506007)(6512007)(31696002)(4744005)(2906002)(4326008)(508600001)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnpZWnhHZHNhTTdJdWFmRWY5WmN6RWlHK2pPUWRnVXhydzdoWDAzOExmR3F5?=
 =?utf-8?B?UEhKeHl4R09ET2NSbTRua1ZQRlZLN1RvRC95TUZNUERmeWNSRHd3TmcwTGJU?=
 =?utf-8?B?ZlV5cEVWS3E0RFlZMHUvb1JNMnF1RDNMTmd0ZDU5V0hpc3drT2s0UUd4UXV3?=
 =?utf-8?B?N0dMb2JVYWUwTW41VjZVeG1LdXVYMTZyU0gyVGJuZlBWK1ZjYnhsUG9lR2FV?=
 =?utf-8?B?bkxab1c0U3ZyWGVVMnJwWWUwYXo3ZFFnejRvbjhFcnpXOUZqYkxJRCtsL0Rm?=
 =?utf-8?B?NngyRHplaUl6dEljVW1xVDNRWmJXSmZZNFp5Nmh6L0pqbHlwbFhsWG94WmhN?=
 =?utf-8?B?MTE1UmpkZHN2dVc4aTY1bk00cCtqZ1hQWDdiUnd0cnBrSTZVNUNXUVNsb2Zt?=
 =?utf-8?B?UEY0dCs4V2grKzRqRFNzbXZVbitsMkd4SmFPcWZZUDNRVWVNVmRkUWdkS3hF?=
 =?utf-8?B?cXM3SURKbE5VLzErWnRTVlFjdGRHM0tpeEVzU2tRMHlLTm9VUWNwSFBhNUEx?=
 =?utf-8?B?WXRibnAzNEQ0c2t4SVZtZFg4aUZqY0VwMDIzSE51RFArZjcyYWJkZjdBNWZa?=
 =?utf-8?B?SUsxRnJGc1VIcmtjSHBiMGNsTUlKUXEvMG50eU83N0kwVjFTdTVRRktnblpD?=
 =?utf-8?B?eHp2cG14OTAwR0ZGLzArUXVVVEIyVXliNVcyYk8wUyt5Y2NBSndvaThHQ1VC?=
 =?utf-8?B?RldIbm90NHNQM214TWRpbzhQeWRzMTRXTVB4TUtQaDdraUNiRFBIandwT3Yz?=
 =?utf-8?B?L0I2NGhtaHVabmt5TzNxd0VnSHVFM3FDRGdmT3JKdUhmYVA5R3hmUlpzMzA3?=
 =?utf-8?B?MWd4VjhwbFFyUlhNYTIzNWNmRHJGbjhXTytlQk83d1pZTmZjVkZWazRGWmNL?=
 =?utf-8?B?cWxkU3Mwc2tEQzhJemdvZUlUdmVTOFdiQzN0dUtWUGNSTFk0NEdiN2o4TmdY?=
 =?utf-8?B?dnpXMVBvMWFPRjZFQ3dWV3V6QmdRd201a1NubFFiQk8wVGFjaC9vNkFzcVc0?=
 =?utf-8?B?K0R6UmlGWGI0dHk2VFZjeDhNdmJFN3M1RFkrM3VFd2lKOGFMdzRjaEVrVlpI?=
 =?utf-8?B?ZklWcHc4RFY2N0FTMnRwNFBLWTQ2WWtlZTZvMEl2S0hSSDF3YmtDWERhb25D?=
 =?utf-8?B?U1RmbGxDTm9CVWR1QTB6cEsvT3hrZE5XK2UzOCtzb2ZmenNBejJIeVNYMkxx?=
 =?utf-8?B?SFd0OHpCdUx5MFkvYnBmOTF6dVE4dGNqdmI3dzBzc3E1Nkp6VkRPa3ZoZkIx?=
 =?utf-8?B?cWNrWGZYRksvLzROTmZqVlRpa3VwR0J6QXdKdnR1cS9qeHZXUVlWelJtdVVL?=
 =?utf-8?B?OTZjeWJnM0pueEJyOG95RVRpYzdyS0xGZmRCNm4wRDBWeWVFZ2NCY3hHWlRs?=
 =?utf-8?B?SEJUMVdKSXVGQndFTFU2eHJwZlVidmg4TytWOC9rcy9Dd0FBSG1GeFk4bDdP?=
 =?utf-8?B?WG1YNnVpSkFRKy9TNzBzWmxkQXBKMTl0NzBGNnVQU213b2VidUpBWGVKc2p2?=
 =?utf-8?B?QmlYRng5V1RKc2VmUEtrNGdNT2d6b2xUdDNOYnUyWjRRa3lrdG5SemNGVGk1?=
 =?utf-8?B?Vm0xQldWQ3Q1YUxpbFhtQ1BiSGVOMkp0MkttSGp3ekNzWG5UbVo3NWxtOG83?=
 =?utf-8?B?NUFoTXZWRlFFc0V3M1JrN3lvWlB4RUI3ejZzTFdPTjZIYnJNTWdnLzhGR2E5?=
 =?utf-8?B?Y1hiRklIR2kxU2E3VTFOeFVYdE1KQmd1WTYvY1RsRjdUR2xrMUpId0dHL2t2?=
 =?utf-8?B?T2NRNnQvTFUvL25VL2VSTTUvb1F0dEV1MGRESlptVXdwbmhveCtYdVF4WTR1?=
 =?utf-8?B?TVdWUkZjQjNwTGFHS0l1c1YyRUZLTEhlR0FtSGFQQ3JPYzBBaXVPN2JmZkJ6?=
 =?utf-8?B?ZVpyS3pGYU4vckpnUlUxTVp2WGNCeWx3N1JXNXNGbHJqV285YWxmODBTK3hh?=
 =?utf-8?B?a1M0VkxURVFGYm9rU3oyUXlndms5TFY2ZW9HL2cvL29vRWFXRVJ5L3lPLy9V?=
 =?utf-8?B?ZTdJckZRSVFnYWk4b2s4THlHbGQ0cThCcjd4a1U4YWtyMEp0b2YrdTg3WmVH?=
 =?utf-8?B?VlZmVHVKQWNBVjJlOGQ0MmZhL29VMU8yQ0N4b0ZxR2Nmblc4d3RjdHJHQ3lF?=
 =?utf-8?B?WmsxUDhGdzBreVRiSGVtSHJzVGFGcWFqQ2dvL2tQYkwxWXU5cnZlZmlPc1l3?=
 =?utf-8?B?RjdEaU9pbWlZNUZKdVRhTTlpRHhIdVZvSDRQZXY5T2pwTDdZVVcyT2hadUQ3?=
 =?utf-8?B?R2V1UEdwa1VGdDNJeXlrVlRFaGIzbUxhMkZ1dmVoWnpZVnFnZ0FTRzZiZ2dZ?=
 =?utf-8?B?dFFyN3FiRWV4QXhvOGFnanU1bTVmRnpQZnFHb3hIS0lTR2Q5Q0c2U1ZPcTIz?=
 =?utf-8?Q?Qz0aX0TkmLI54QZw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37907962-d6ea-4b30-9783-08da3a8f0b43
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:32:07.1778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXsHdEGXS2xda2ll30QiCrWfGE0HB2gABWSZdQfq+gq2gmoMbNdUf8sPqMjP6ukx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5117
X-Proofpoint-GUID: vha8dnD_GvGh3N2MSPaX9R1SB8y7TIaS
X-Proofpoint-ORIG-GUID: vha8dnD_GvGh3N2MSPaX9R1SB8y7TIaS
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



On 5/19/22 1:32 AM, Christoph Hellwig wrote:
> On Wed, May 18, 2022 at 04:37:09PM -0700, Stefan Roesch wrote:
>> This turns on the async buffered write support for XFS.
> 
> Can you group the patches by code they are touching, i.e, first
> VFS enablement, the MM, then iomap, then xfs?  That shoud make
> things a bit easier to review sequentially.

I reordered the patches.
