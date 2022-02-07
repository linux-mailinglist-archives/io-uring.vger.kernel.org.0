Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F1E4AC1B4
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 15:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiBGOpo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 09:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391529AbiBGOVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 09:21:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8553AC0401EF;
        Mon,  7 Feb 2022 06:21:28 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217De0PI031119;
        Mon, 7 Feb 2022 14:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=qhV03sglIVR9gbnhc/NL09l0gVHM+WSkZnqgkpLIv5o=;
 b=OblQnzIrYl3MDyRIjHcou1PV0pBF6O8ZBoD5z63vf+jZBPAao9oshaPaZACtSeNxgSWj
 2ke2J8xBVueTRIHkKLNZJtVtxrvnn6VUrrwxZInQpceEeN5wNDxmyorSpDf+PhjoUhvi
 pnmJiu34lOopJkyC88qf+JoDPbsHS/EQCnbe1OIiSEgFDvu0R0v9ECoYE68CdNjEaCVP
 yCaKfbhT4JnD5yrGg5HQuD2CmN6i/XS1FWZ9mndNUmU/Z2F3tWQA3k3Ete5IPsFSxpY7
 Kcp8KQuMvnrswAi4l2A5uMd7/yiilIqqEaKYqi8xKH0PXUrDXmOVdb9gs/AUTPEF0wwN HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1h4b5xwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 14:21:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 217EBiog101664;
        Mon, 7 Feb 2022 14:21:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 3e1ebx59yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 14:21:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jI2g2R7yPc1lADt5g1yyjNJUMphc1Sknm/Ikdj//yIRQf3G8fXNIf60R2sIo/1eWQanQ60E0TFHw7q7d8TozghZoveOStz7zmC34mln6QZ2lt9lTqSXIs9HWo178iOFAdVvYd5mFfvaUjoYQ35Id/gJO+upNEyAj0Pd1klUvG0rQq5UcWVeo7w1FE4Ok8oMCC1PFprrESACTnIzZSC5Ye2If6lWR6LaMGs+L00wxU/9s1WKqeXc/c9PJ3++ytzDrq36q7UcSnGOxM8goVc74CmMW5lMPhN2zP0JB/E3qKMR4sYalxhFwYtFFP/JMymy0rsfgehBUcChMJFp9ywL6EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhV03sglIVR9gbnhc/NL09l0gVHM+WSkZnqgkpLIv5o=;
 b=bnUMF2WU1fbKdkRKiChKTieB4OBikurC0zuORtTNcx1Ki39skG3p/9Z76zxx2KDfYH/i0frLBrss1tLxDzdnSxsXFpHBCQDxjl7cGaG/b8JRrz6+c2F9ZYTAAkDEUTj7MjAtew4xAWR7AZ0oqIX9nluyUKR9zLL98pwbSQ294rzLgmBoA8TSSMiOcEri+irbybCIMnWxgkmpXNYTRraUWjjhaHPvCB/QNkl6lCSNoVG8qbJqeyWy+rdjAbMakNeCYSl2iZE4WqAtd5ICr+h9CBLra8zSwMW8J8Z+t9pZqJywXYOfo0H7JELOkjrEGwtjuAUmRxk6wUfcW6qxMSMYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhV03sglIVR9gbnhc/NL09l0gVHM+WSkZnqgkpLIv5o=;
 b=RT/AGRil4eVsmCeWNDJE7+iYURxhyDoPvcILOYv+BRv8nkslZcuxOP+H3vBC5HsC1Eaom7myUyqtKe2t0MljYBcUkf0TwkPAj1CA1UZKymb7R1JeBkmJW/sKeXqJ1W+VXqDcgEYKd4V+xkaLR+h3V6QMi+qwOAJwNhMEmIR7sWc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1713.namprd10.prod.outlook.com
 (2603:10b6:405:9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 14:21:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 14:21:20 +0000
Date:   Mon, 7 Feb 2022 17:20:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        kernel test robot <lkp@intel.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-5.17] io_uring: Fix build error potential
 reading uninitialized value
Message-ID: <20220207142046.GP1978@kadam>
References: <d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com>
 <20220207114315.555413-1-ammarfaizi2@gnuweeb.org>
 <91e8ca64-0670-d998-73d8-f75ec5264cb0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91e8ca64-0670-d998-73d8-f75ec5264cb0@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd15d318-6fd0-48bd-3554-08d9ea451bba
X-MS-TrafficTypeDiagnostic: BN6PR10MB1713:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1713F823B051DE46876816508E2C9@BN6PR10MB1713.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCPi9GhgEWLIwD9hxFvbw+Y6kLo9/BgZBHUBaxkNPuT50722dQSo6l9Na3FSb/glYYDQwONla7uQxCodem7w4UknnyRRhADAZh2/QU1xTdvQs+Vu0Zn5BuxtMGqS0v6DKeihWyGCnQZ7yglxD0ImyPwYL/XbqOHBBfFnpoe4r/rbWn21zM/TdMumN4j2muZCAbulTh3yU283QSnvfNK1ClHsOQlyG9DPQLX9hroQ7OVkhWsHQtu2S7cok2MNKfba66lvHXvX+LNMWRvUUNoQp6BWBq43hf0aB99whfyACMf5ShDZBhdjcSwkRD+nwRkgHDjcbML4jUQr6L4RBumSmBsXc38/DQIxXyNfWnWv+yBwzefhWjm18UpQ92doGJT47sz/moTzcD8zrpHkDg/kgplNu7Lkx45YDO43jz5beU6k45Vpn2pqJbEipK9+TMlOCos95+ngOaqJT+xZaihren4wDCWcK2JQd2ZZLA1N5HIO8AUiHiENXm+6GRwdGJvY9yD+TpYaEkJ3fWoIvP0ww99fSq8ZLtkRJkcrF+MYPzJUEANYeh59664fqKFo8IfdFBbEBMAQzhLCpIvXDjGsXPccQDdTS4+/PcMxnH33154ZCHz7N7x1+QRvokpVkI2lX6dP7poAX5e5fh5rnYZV+U5QqIdcV6iIiZAbpUxhCa1z9vVzRv1/GcxzUBe3G1LB//Fhb3hfjhMgr1jRxf7hsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(1076003)(66946007)(66556008)(66476007)(8936002)(8676002)(186003)(26005)(6486002)(4326008)(86362001)(33656002)(33716001)(38350700002)(38100700002)(6916009)(316002)(54906003)(52116002)(53546011)(508600001)(9686003)(6666004)(6512007)(6506007)(2906002)(7416002)(44832011)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2RzSmhhNmtzSEdySUprQ1ZxRE4yUXczSHN5Ym1HaHlNRkN5TlFmMC9JMnU1?=
 =?utf-8?B?eXRkOFFQbnFURVFXN0tNcUFPd0t2eXlobHA4L1VwdUdPMWI5Zi92Z1JLakZP?=
 =?utf-8?B?L1F4MThhSEw4WXp2TG5rRzdIZ3JvVFB3c3BoelY5MCtTckNqRlFzcVJFb2J0?=
 =?utf-8?B?R3BFdHMrcHV5ays2QkZKRjZEZ0Y0eXlDNHRYWEp3SFpWWnJJV3VXaytLamVC?=
 =?utf-8?B?R0VkOW05TVFvZUNETlByckF5UTRyUlpKakFTRzZ6WWJ6RkFUb3NDRXB4aTdi?=
 =?utf-8?B?NFB1UDU4dGxJaE1QY0ZoTktjRXorci85djlHcVpFUnp3eWQ3WDI2eUNLZzNO?=
 =?utf-8?B?NW9GaVhvWmR1cnI2TFpKR3FLMnNIejRCQmp2MllwWWtNaVo1SHJucWRqTGk4?=
 =?utf-8?B?ZDRKT2pWRGVNcmtoWnNzYms4eURPYVNXcE14VFBwd003ZUV3dmxiZllJcmFk?=
 =?utf-8?B?TWFYd0xUb3lFUDlWQVlRaE1vaG1YMFloNWdVNzhrdFlzbWpQYnNObHJkdXpt?=
 =?utf-8?B?Z0M2NDNFTzJhNVVEK2VQcWZNVWJtb0JMVW5PRk1GbHozOGc2Y1FzT3Z4Tnoz?=
 =?utf-8?B?Q01mTTJwTUFBMFM1Yi9MN08xbTU0SStZS01KcDZyeUdCRyt1cGJMVGVDVzhH?=
 =?utf-8?B?MXZUQjFYU0tTdEMyN3YyMXNGajBtaW12Rk90Y1h0QzkvTXV5TVVGMWN4enZT?=
 =?utf-8?B?VjlEaEFIZEVjeHBPL2ppRm9kTE12VkViUlZOaFVsMG94T1FCYWhZMUNUVSs5?=
 =?utf-8?B?ZEhIbGpHdGppZFB6U1NqTlVxL2FzNnV2RXNmTy9kMVl1STJyYVgvQ2V3TVNz?=
 =?utf-8?B?eXNBRWEwYU5VdmlvS1RpZEtxOU95MDY1a3RGSVJ5UWd2dkNnMWRPMnFrekRk?=
 =?utf-8?B?MklvMFdBVStPellpVFdHMElDQ3FaZWR3MFF2M3Bhc0tTWW0ydHM3Q2RjYnlV?=
 =?utf-8?B?RXBibGJmMW1Jd2JsOXJpVWFuaUpLbHFIZnhMTjl4ZzNZbHcySWpiZVp0MFNH?=
 =?utf-8?B?ZGtYdml0dExMeVhqNXBSc0FrRTRtTW9UdzkrejNFYnlnYWM2alI1Tk1oYm5h?=
 =?utf-8?B?dE1QNTNQallZM2F3a2R2NGZPOUlXdTFlQVROSmtPd3U4UjFOeTFiWTN3SkVq?=
 =?utf-8?B?L01UTHFnUGRFU3NNVVVhc0J5RXowTFVIZVI0cCtiUXM5UnBLVWxtMGxNL1BP?=
 =?utf-8?B?UUw5QlZ6ck5qenVnR2hXWC9Sdjh0V09JNEtZWnhaOVp4QldhUENCbWFzRVlL?=
 =?utf-8?B?UVREcXVtYnBPOFFGUEhYOS9URkZNWkpoTnZyWmI1cWltRjVvSjFYK3c0MmZQ?=
 =?utf-8?B?UkN0MnB0U1hSbUg4RmZ0T1E2VGpZR2Q2aVVvYkgwNFMwZHVLZ3VhNGVocFFI?=
 =?utf-8?B?TFRnQVNKTWd5MnpZTTJtdXFCcjByRjFKWk5Cb3FGOEtCQk9QOFBGYk5NdkpB?=
 =?utf-8?B?WUNUYnNwcTFiK0tHRWpac0JpMTBiYUhtSFY1bHJQWHNhZTlsMzBrVVk3NWp6?=
 =?utf-8?B?UFh5NTVjck1ybFdmRStwb2pidytWcGQxV1hKWS8wU0p1QVVlNTRPdmJsb0w3?=
 =?utf-8?B?bXpUSFg5U0ZoNlVRZ0gvc0FFbytLc0FjT2pwamdUeHcrK254ck1OOHFNeTFM?=
 =?utf-8?B?REdkdy8xcVVLMTZDQVNoTkNxVE4xZEtoOVJJQ29udVF5WXZLbzBBNWxRY1Qw?=
 =?utf-8?B?UEJ4QkZLWHBUbDQxbFovcDNaWEdnRGJXOVV4NFdqTzY5eDg2am15aXJBd2dU?=
 =?utf-8?B?emFLc2c3Mkh5RThmVE53T2ZFMnFZOEpmd3N4QkV1cEFlVjltRDJyKzdGaVlQ?=
 =?utf-8?B?cHllMFJpbXlxR1pOenUvWWp1MnR3SS9WN2RXU04vMjZPeThQZC9tRUo0cjA1?=
 =?utf-8?B?ZFhtR1UzNUhvb0ZRUVdCazhNSTVPeXpqN3FsSzdadTgzMCtiYjEwUnNMWnRh?=
 =?utf-8?B?WWlkT2MvREkzNUtwK0NVV0lqVERWOURMVnJWWFJnOGIyNVhvSnZrTHp6SFdy?=
 =?utf-8?B?Skt5MExqVEpBWmI0OWxwcEtqSmhZYko2YlhIRkxIOUowY0FZNTI5YnZrb084?=
 =?utf-8?B?L2JNdkdBMXA3dG1LQlF6TWFFNVlmTWVGYjR6OXRhQm5HMjJ6emExNG9ZZW1H?=
 =?utf-8?B?QjZWbjEvZE9aZUVBTGxBWXFvYW5SRUxIOXV4ZDhOUFQrQXUvYmg4ZFRzQ2hZ?=
 =?utf-8?B?emRTZkJHc2lSTlhPbi9PaUpXamZJS1M1WGJiajlqZk80VVZTODE2elQzcHZO?=
 =?utf-8?B?MVM4QTJsZ1dHYnBDRlFOV0pBdFlnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd15d318-6fd0-48bd-3554-08d9ea451bba
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 14:21:20.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgNIIlVBwEw8yfsxDo0KayxEsVEoixgZKGOZmHdgAC5swncP9oXcv8JEGp9cs4IYTXbs8zMFZNopxqdXP5juSM0zCO83cEKdqbabZlUSTCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1713
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070092
X-Proofpoint-GUID: F5Yz0NP2GlULOIL5vHq-nbLD4Wt9Xizr
X-Proofpoint-ORIG-GUID: F5Yz0NP2GlULOIL5vHq-nbLD4Wt9Xizr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 07, 2022 at 06:45:57AM -0700, Jens Axboe wrote:
> On 2/7/22 4:43 AM, Ammar Faizi wrote:
> > From: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
> > 
> > In io_recv() if import_single_range() fails, the @flags variable is
> > uninitialized, then it will goto out_free.
> > 
> > After the goto, the compiler doesn't know that (ret < min_ret) is
> > always true, so it thinks the "if ((flags & MSG_WAITALL) ..."  path
> > could be taken.
> > 
> > The complaint comes from gcc-9 (Debian 9.3.0-22) 9.3.0:
> > ```
> >   fs/io_uring.c:5238 io_recvfrom() error: uninitialized symbol 'flags'
> > ```
> > Fix this by bypassing the @ret and @flags check when
> > import_single_range() fails.
> 
> The compiler should be able to deduce this, and I guess newer compilers
> do which is why we haven't seen this warning before.

No, we disabled GCC's uninitialized variable checking a couple years
back.  Linus got sick of the false positives.  You can still see it if
you enable W=2

fs/io_uring.c: In function ‘io_recv’:
fs/io_uring.c:5252:20: warning: ‘flags’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  } else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
             ~~~~~~~^~~~~~~~~~~~~~

If you introduce an uninitialized variable bug then likelyhood is the
kbuild-bot will send you a Clang warning or a Smatch warning or both.
I don't think anyone looks at GCC W=2 warnings.

regards,
dan carpenter

