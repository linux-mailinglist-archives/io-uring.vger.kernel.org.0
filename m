Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F4C4BC10F
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbiBRUPQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:15:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiBRUPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:15:15 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C34424637E;
        Fri, 18 Feb 2022 12:14:58 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IBLO98008001;
        Fri, 18 Feb 2022 12:14:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Hlsxv59/Dq7DMyMlVAR8XDL9vdvdolU7uguKh2/56AI=;
 b=gv7LlWFtsCSFqoFMjcF3Zf681gGbWfePeRoPbUbhRTOEhvDXsis5Rbc+FOwEhNufrpGQ
 a6a+FxChwEeRmqtD6iuGOHoOhZQH7vMQFniGHpCCthvQqVAc0hSRsh9/KSvmogyK60Iu
 eOcdNLjDNQvHKAcAbVIvmX2/yS7hZydvtwo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9yf2xgm8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Feb 2022 12:14:55 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 12:14:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzknvmUujNmFmT+GtuMEwrVzzEgvq0ybGCrrGhUNDmgq/EeKJiukNAODFMKPJsIXPGTi6zyC1meBkOtF9OYluLiconLpJbhvtxtIZBufQ0uE5ZwGNDKTMHi4gvN06YANj5//C/5NqJGTrSOZMTLU5SW10XJ6JsuppzuESJexkx6FuAKDn8uZ3r3P/7bt5r+4cfxJDNzTOY25mrrT6XvO57owvOFy76/RO2y53eRX/EK9L4ay+z8dDQgWEdY212DvR/Hq6x7Gk1ANF/WrRPKSJc6Lvob2twQTCtZUVxvf18xOSjY/GrZha0Shn+NPbSxD0W7Ab02syFjLDcwCQLuKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hlsxv59/Dq7DMyMlVAR8XDL9vdvdolU7uguKh2/56AI=;
 b=AS+BbRlnUiR5tc1NDvDHZrT4Hd6Gb+E2iY1rQ2M5h5FuHOqOKBp2+PxXWu8by+bRvX7vJuyhEtDsI7qbioY7xbOJOeqInTlRIYg1uw74Vqe+Ts5B9hj1zW6Buflh+z0AJ/zL+5fyefk4FOjuerHeN+gjguHAyUc/D4hH1j/npCM0sdqrg1nvCQauEi1RolCXgB4/dfs//bSLkyowjnMEX10LN0vRLfwD/PuZSEzkq7x0Tn6vUKUGQzIHiF5pF1DD4fN3/lQPl9GQg1US7y3kTIq/uxn+0En9RxxNQ7OjXf5crWP4OX8+7YtP5C+Kzdc1OEkVpRzb3/PqpaOKtiqPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB3141.namprd15.prod.outlook.com (2603:10b6:a03:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.23; Fri, 18 Feb
 2022 20:14:53 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Fri, 18 Feb 2022
 20:14:53 +0000
Message-ID: <5ac7e88d-76a9-9d8e-e3e5-58a89f48b0d5@fb.com>
Date:   Fri, 18 Feb 2022 12:14:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 01/13] fs: Add flags parameter to
 __block_write_begin_int
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-2-shr@fb.com> <Yg/6qDCDuCLGkYux@casper.infradead.org>
 <d6a89358-c43c-9576-91bd-d90db4d2aa42@fb.com>
 <Yg/9zKvlwkVJqj+p@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yg/9zKvlwkVJqj+p@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::23) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 381277e1-e220-442e-cdf0-08d9f31b52c3
X-MS-TrafficTypeDiagnostic: BYAPR15MB3141:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3141C8EE7E1F026DBA5D2348D8379@BYAPR15MB3141.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MPgieUsV7rZIN3OYk/IJkmWnIjnwT0Tk5iHokcMPpNr0dIKNei+qFTXBLaewfaBb+iHF8J9dw8kC68bHBfL9OFHdm93xyZ9iF+/KbF/vvVfDHf21FKTRHW2FRzWqokCKLM8GiKEmVZmX0Y5YnvmshqW1PeSN5Pv0lLQh49AOPVpzJMbwcBsimUgdBwWkwVXB0oMwJmQFPX9drIMlAm/fyGmHpHr8x+zVosdIpJmGe3gumEJfoQ8TVNBj5NPCm9MdzdgnvtOtIxDeSsq1aFUSzFhm7Q68KhK7JuzaxJ/dnqbXzLjIZpIn6NiXjDcr1UhTiMgVlEJJJtcQegG8cU7EzNR6clZviEoeK/ATA8bPonjigNLm/PvQGv+YVmmHC5nxYvxCNBMZmHBYRfxsQVx1XrxArBownaAAUVWZ2QfAovDJH/AND+Sg1eA9rFnZEdFB2/0uJNjlXt4AB82wjmiRBO3vFOXJELvlAyZxIMCnDeYYjoDmO+TVMnFq1/YyuCDbpOJRIrrK7sv9f9AwDMCAOuf48uZ2g3M7UV0IJcc2oDqDJYN2HcSq2OsR5iJaYWc8RX1Y8HvASM9H/getbIn/xx5lc03sQNdWxzbUuTnnpiqM2cJT8Tr6oH0oLD/BohK5/dwmp1FGWzJ9Br12wmuv+oV4cMqolwof8ruLb+nKdLNN2Vumytbs5smIyEADXp4FtDB0ri3frl96MZ8CO6JvcbJp060FG+F0f6Zoh7woa/9OJDHDWtIwNdyLYrGXsb5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4744005)(186003)(6512007)(31696002)(6916009)(86362001)(38100700002)(31686004)(8936002)(36756003)(2616005)(66476007)(66556008)(66946007)(8676002)(53546011)(508600001)(83380400001)(5660300002)(316002)(6486002)(6506007)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0VhL0diY3JpUGVkcmttbkxGUXVLUTkzUjJrT0Z4Q1YxMm5ScUdFYW5VY2x2?=
 =?utf-8?B?RVdoeDZIQzlNT2pacGxoQ3UwTkVsVHprbzYxUWVMRTd4OEFUMzU2RDNRQmNV?=
 =?utf-8?B?TEQ3emw0UHpsT0ljWTQ2QnloaXd4L0NGZ3FsSzc0NzhrMGpKb1cxUVMra05q?=
 =?utf-8?B?WktDTWNHR2UvcjdPdWxFYmw2WHV6aStOQWFvM0laZUNzWHYzcm9uK3pCU1JK?=
 =?utf-8?B?YjQrSmY5THpmRXZVZnNRMEZxeW9aYVIvNk5JWUh4dzlVaWFOQjQwZ0xwYjJL?=
 =?utf-8?B?MHJVWGNZYVdYbXN5QnNNYklrS0xGTjd3U1N1SmNkUWJqVGpjVTZ2bDZnekNn?=
 =?utf-8?B?aVJMSXNpYzBJM1FGN2dKMnRPYmVUQVhXQkR6c2R6ZzFvZUxSZHQySkpSelZo?=
 =?utf-8?B?TkpISHAzSmRVQWY2Q3BDazdtcEtFM0lOQ0sram5mY05uZThwMTV5eGE4OU45?=
 =?utf-8?B?dmRueFcvcjZBUmttZDFPa3pCaWNPRDcvQ1Z2dW5JTTByZE10MGxXWlp6QTdG?=
 =?utf-8?B?MmpPc2F2M0I1TTlOdzhlb0tobnRtYUhiQlM3M0I0RkwyOWg4Y0ZYZjdPTUcr?=
 =?utf-8?B?KzhaTnVVTTNoZ0NxaGxPZDB2eDR4WEN6WGdiMC9QUWkwZlRRbUtOSFQ4cGYv?=
 =?utf-8?B?RzNXOTVOYkpYRDVzT0NkTTJFclBDZ3Nib1JLR1hnNGZjMnpwNTdOaGUvR1RM?=
 =?utf-8?B?NTF1V3hmV3NNOVBzSU5seFRzU3ZrcVZyR2pCY2xNQkdPUTgwNzg2OU9nYmVx?=
 =?utf-8?B?YWs5bW1zYVV4NjN0amZMbUFZbkllT0g1cWJKQ1ViaCtDZ3pnaUI4VkNoNFRt?=
 =?utf-8?B?YW1zR2lYQ1ZlQ1pmbjRzY0Z3aVdHWGxZbkZnRWRoaDFZWk5WcDdhYXk0K2Rj?=
 =?utf-8?B?bll5VUc5WUdvTDMrakJUM0NzalFSb3pjVUtkV2dEU2ZobUhPR0pKSnNZWWtW?=
 =?utf-8?B?bEZiUmZlblhCaG5JOGRBRHA1UlhnOHFTMUQ1VHcxR3NpTmFBT3ovb1V4ekY1?=
 =?utf-8?B?eE1SZUJ3T3N4aHNPNkE0QUZ0ZjJPMVo5bWZpcFFpK0cvUFRzREV4c2UvVFcw?=
 =?utf-8?B?ZGloWEpYOVBXcnJzR3V0aHNHZFJSbkpLdGZSUHBqS0JYTjVORGZaSC8rRXNP?=
 =?utf-8?B?eFBLdWh3UUxEclp3WWhnelU3ejNRSHlhaEVOYVIzR1hqcXREbGNKRTk1TFZJ?=
 =?utf-8?B?dEpuOVg0c2ZtQ2JkdWhINWpweEQ2dm5teVFBN3NQUFJCbE9mMUk0UGphbWdY?=
 =?utf-8?B?TTNGcXdUS0JOcGhhcVZFS01oM1poeklIT0NTQlFiaUVFRTlzT2xQKzVJMVpy?=
 =?utf-8?B?Wk9jVUVHT3ZpZC9WMlRUNzB1TVQzZDNlZURkSG02Qm1KUnArTHF2ZW5DY3I2?=
 =?utf-8?B?S2tMZmczU0kzaHFKUktuWE9xQUY2eFBhK3d1ZldaczlaV0p5Z01DV1FPaGNY?=
 =?utf-8?B?a1JQQm51UmFJdVg4M1ZuOUN4N005UXJ2VHlMMVVVSmpnY3ZIZ24zTS9oaWhP?=
 =?utf-8?B?T0dXNjFUekpYK1BaN2FwUVcvMUF1b2I1Y2tXQkROSGtWdTlNMWhMVE9HbEVK?=
 =?utf-8?B?RHI4QXlVMDRHdk5NMy84VWFrWVRmSldnbUV2d1BXSnBuL1VvWjkxdzBWRXB6?=
 =?utf-8?B?aEFoTlUyNzF4UlRCVTJCemtzU2NnQ2hHZXJhbmFjcXE4M0NDa0U4Vzl0bG5p?=
 =?utf-8?B?RzNicXFiR3FRSm5wRms4SXdRWGdOeXNlMnV4U0F2UkJMSVhUTzRHdjFsN09N?=
 =?utf-8?B?eVlxRkxMTjAvMXltMStUdGNwL2hSeTlGWEVucDNQbFVSZDVFdWU4b0dhcTkw?=
 =?utf-8?B?Sk9maEttYjFHdnlySzQyMzFEU052UWppMHNvSUFTZ3BkVVJzc2xoTWtYSG5p?=
 =?utf-8?B?NjBJdkZ3NkRDTXBXWmxkYi9tT0RVdXZPZzdEcm9QbFNPNkdhSEJBTTBlR3ZW?=
 =?utf-8?B?YUZGNlFPZHFsU213eHJNSk5JQ1FOWXJxYjV1MmNZNU5vd0lHMzRSZ0xWOWpu?=
 =?utf-8?B?Mmx1WkZPVmVYak56VzR1NzI2K3NjS25FaVpSWUlMcmFZTUNFeUJadWhsN2Nm?=
 =?utf-8?B?dExpYWdmWjYzd2xWZlZNWGFtcjloL1FVNHRYNG5EalNJYWRJK0lBVmFwSURT?=
 =?utf-8?B?K2tnRktKNWVLVktBUFZSRENxMG1Ia2wvMVFTMWxQOVpxYllFMVF5OGxIL1dp?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 381277e1-e220-442e-cdf0-08d9f31b52c3
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:14:52.9272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJhvcEeYHJ6uj3UvDaLdg2F6unlwo7Kb/caTdUFflIeX8sfgQeSgZ4ywBb34D4nG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3141
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: yb7M0qkQMT3euQ52wEn-QquHrdRx0bOR
X-Proofpoint-ORIG-GUID: yb7M0qkQMT3euQ52wEn-QquHrdRx0bOR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=555 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180124
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/18/22 12:13 PM, Matthew Wilcox wrote:
> On Fri, Feb 18, 2022 at 12:08:27PM -0800, Stefan Roesch wrote:
>>
>>
>> On 2/18/22 11:59 AM, Matthew Wilcox wrote:
>>> On Fri, Feb 18, 2022 at 11:57:27AM -0800, Stefan Roesch wrote:
>>>> This adds a flags parameter to the __begin_write_begin_int() function.
>>>> This allows to pass flags down the stack.
>>>
>>> Still no.
>>
>> Currently block_begin_write_cache is expecting an aop_flag. Are you asking to
> 
> There is no function by that name in Linus' tree.
> 
>> first have a patch that replaces the existing aop_flag parameter with the gfp_t?
>> and then modify this patch to directly use gfp flags?

s/block_begin_write_cache/block_write_begin/
