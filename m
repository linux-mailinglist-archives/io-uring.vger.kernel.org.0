Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8650F47E9C6
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbhLWXy4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:54:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240970AbhLWXyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:54:55 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BNMDq1f014565;
        Thu, 23 Dec 2021 15:54:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6F969cu/m27e7gdPhVLIfJKPLA1ZRVgfOpmes0WGA2g=;
 b=ZuZl2dGtInk+r84zdP32xpuXxOLujespXDQVL/n2QLyyGWhN/a/mczcVCa/4VwFUGqoC
 3PfwjPxgFzDG5TlP75yyCjtO/MduS8d+gZ7KqAvonMrkFKtlQ3/xQtV4rahKLkXI97Ll
 Eh+t7LjIEBRHih+hZeVzVkotzRK6xGsgjms= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d4n25ddsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 15:54:53 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 15:54:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+gEAaZUgMECd8UPetcLhQtWFmv/eQevwrxiJawEY4rx00Q9EG8YTb9rLesJxHlbVJWUJ6u+zi1CEcBgPqWwq3C2b1xMXRVhDVen3SoVsrXB78iM9yaII4ATxkQ69Tp7TwRGpBl6Di+WjhQQ76ahOw7K1LRtZRZn9KRP2tLWPeleIjOatKqwDopInbaOwviZC3dsFklUCH/bCsm2VAtmkVgwNUzyE2HUj9yEoGSu9wMasvfYOETt4ATFcpmIauvn3X9AVFzV8KHGGhS1Mtn9QfbBwiuF+wjodE0QahaE73OAyhZ8hKambgcnxBA94LNXdW0n11QrMZfoRKLJvTbu9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6F969cu/m27e7gdPhVLIfJKPLA1ZRVgfOpmes0WGA2g=;
 b=dr28cqSCrsSXL/9BbgHITP9Ao/K/0R7CFoUYWTPk2mroYUF6RufG50wxDs0sUV7JX6P2yx49QX2Qc/H2cj0t/hjheKNwsiYZ7brpIaME9Vh05gl6vmLHI9WI/ZhxjJJbc2qXhcDcZ+jmMp2LrIIyd4vT0j6N4jqhGNPMlUsICNbIIp+UR8mp2+DTJj6Ic1JzU9Cq4mlV3EUzh1LhjV9G8S2+nR8uDXQZNTYXwv5eHvOSoLP/pH60xrTgDOiFueKUfw41xIb0MNal9HoaUBC1U4MmQf6aQvnzZ4KeBZxKMIwi5g7b/JQnoI+BQGAjacd4yhGAn3ZL9BwYsr/FoW2YQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW3PR15MB4009.namprd15.prod.outlook.com (2603:10b6:303:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.18; Thu, 23 Dec
 2021 23:54:46 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::989e:71eb:eac8:1f72%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 23:54:46 +0000
Message-ID: <842ce905-bc07-70b0-6fb5-468598322ac8@fb.com>
Date:   Thu, 23 Dec 2021 15:54:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v7 2/5] fs: split off setxattr_copy and do_setxattr
 function from setxattr
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20211223195658.2805049-1-shr@fb.com>
 <20211223195658.2805049-3-shr@fb.com>
 <CAHk-=wjZ4YORKUBswiH5CZ5pukRju=k+Aby6pKwdgCbqXJP1Nw@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAHk-=wjZ4YORKUBswiH5CZ5pukRju=k+Aby6pKwdgCbqXJP1Nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:303:2b::20) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4df29d46-e80f-46b2-15bd-08d9c66f98ef
X-MS-TrafficTypeDiagnostic: MW3PR15MB4009:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB4009C1817602062569937CF9D87E9@MW3PR15MB4009.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wVKQgAgwINS+ARDJSK0DV4gDxTf0spQWl4rhyAywFeLdTG1bnwB22FoqmhXufNBfXvr40SwWenlEQu/kQFv5El4nWMhHxkNubweDXSRsJZ/1Hi5dnVld8VR82X5kpsmLS5yDfC4L0i/dyoSru2snpJ+kUbjFWO6E63kZAHUaxBb8gRO0y7XPsmT8HP007LzZU92a8f63X2QTjSFIMFhmpOeextqrzB9d5HoWuKhQLAxdQFsmsBIkbsoYEwjjUaBqmb7UD8kc7NGcbeVPQzkbNNmRXhb7Ra3kwsbdi0u2rxOx2o/d4GRKytZtHmWfhtg3BZvnR9jpqvFl/UX0PDLM2dXxp7cMv059kCosRKQ87tS/SUEmW12L3KU3TQDmoQpLGZzvEt9QiSaXF8A8HLezDv+eUFzXI6gh49oeWIor9WRjyPrbhXLMAREQ/QDmjPW5n+2I7DbzA1y/ms3+LGilw6Cb9iJ4Bktr1LRrF3ZXLn3s5BHan6xv51bRUgEJmPeTazG2qkfs4rtXLQ3g9ocMlTw6T2berCyqWnrbL4y4ekc9DaK5f8ZO0APUnNwIg7rW4uvVeSHrQPk1pRaa5Deg3Pp6S9aiFKhzvyIM3HNM90LMC9COLCgn3YrYJkke5UZBSJXzQyDyTd77ibVyYzF0pblRnGHRs2kYhw8ZfBgiq09Yr9Aao0Otq19lZcVihIcLAJsYS4jBNGVLXcvBsTT520pWxfNjVzRrcKEYqyR19ZM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(31686004)(53546011)(6666004)(6916009)(6506007)(66946007)(6512007)(66556008)(2616005)(4326008)(2906002)(316002)(36756003)(5660300002)(66476007)(54906003)(31696002)(8676002)(508600001)(86362001)(38100700002)(6486002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWd5ZUhMemc1clhaQk9hNmpsRlAxTis1VzJudWQ3Q3VTQ0ZaVmdCcEJXbDJ2?=
 =?utf-8?B?OVZiTEhQd0w4SFBnWlJZa0tNT0xzMXhrblNmMUZRdk1KUVUxb3lTZnp6QllL?=
 =?utf-8?B?QUpaeis5UFR1WWFrQ3BPU2hNTkQwRVlhSDQ5cnBqZjVvNjNlS1hLUmsxMU5w?=
 =?utf-8?B?SDBaVFZyTytNNGxjTERKOHh0em5nbXdoM1BMVnIxRmpUbFJQeENPZ3dnRXJy?=
 =?utf-8?B?TFJidTJrbHFRSDFLY3hOcEJHbWppNTl5MTgrK2pVRGF3cGE3bWd4MnZIdm5U?=
 =?utf-8?B?VGFGN1pDeldtVHY2Q0JMRlJldkM2aHBCVU1hR245TTlYd1lCOWl0SlViUW5E?=
 =?utf-8?B?UGFpclA0WVEzdkxYS3A3TThjeUY0QkNneXJIeHNXVVkyNXVuS3hVclNSdzBo?=
 =?utf-8?B?REFGbFkvM214c3k4ZmhXT215TjlwbVRPVWlvSEU4dTZPdTE5K3N2V1N5aEhH?=
 =?utf-8?B?MVNjMnZwNE00Q2hPWU9Fd0JrVHFhdk9keExoRXBYK2dXUzM3MlJMbFNHTTVH?=
 =?utf-8?B?akhIV3NlN21NVmFUUEIxVUM1cjEzVDc1OEo5MC9JZVpIelJha2VLWUtUU0Y0?=
 =?utf-8?B?VFViM3hHVnpkOWcvZmRmR1gxeWhGUk0yUG5ZWTdheVhGR0NJc3ZoMmdJUDk3?=
 =?utf-8?B?d1d0Z0xCQy9ZT0doV3JhdzcrYVVRTGdkSjJraTQweVIxNzExMXV1elRMdUtV?=
 =?utf-8?B?ZXhJNnljRTRPaUxKekVoc2lPMFRDNGpWZnhIWTBXeFBTbWFXalpNQWVDejZl?=
 =?utf-8?B?dTlVd1hFcmxGV1R3a1pKSHpPSGtzTUQxS0toNnFvUE9KZHJrZU9rSXFvN0dL?=
 =?utf-8?B?eG9oZWhtT2lOWjhUdnFkNEora1NuN3o5V0FWc1dvQ1dXQ0VsN3RwUWs4MXJM?=
 =?utf-8?B?bGhrVDQyUW0vY1N5T3N0U09NTkQyeURnTnV3ZjUxUUJnZzg4SFRvSUcvZHoz?=
 =?utf-8?B?dXNmc1RkWkYxTHd2UEJRTE5iWHdIODlBQXJGaEZOYjJndk40YUI4d1VZaUlk?=
 =?utf-8?B?T1N0NCtZM3pZWkFBU2YvZE15TmV0bUEra1RlTzVmTTcyWjA4UERJUWF2VXpw?=
 =?utf-8?B?WTU4WlZvYTFaM1FMR09uak1pRUppT28zTEFZMGd1R21sVFBiR3EyaTdZa3BB?=
 =?utf-8?B?WjIzWHViTTF0VjBGZnlCSUd0b2tzZklybW90MHlYWHd0K3hGNDBBTlpmUmJO?=
 =?utf-8?B?bWZoRklhQUROd1FFWlk4Tzcvd2FDS0RPSzdxV1VFclJyR2NHbTJXbUYxakJZ?=
 =?utf-8?B?eTgrTkZiMjNOVDFieEUySWZiT0k1aVVLZUtPbzl1Q2pPRng0NThHMzV6NVB0?=
 =?utf-8?B?d093a3FmRjhZYUltWlV2SHcyaEVMbHM0UGI3czdzWFRxTWZqUVBZK2dOaVNv?=
 =?utf-8?B?TDFxSVhrWkM5T0RFY2RXaTJQS04zSFltbGoybk5RR3hGUkJGUzdUL0d1cG9S?=
 =?utf-8?B?bW5LREJOQm9QTjZ5TkxuMjNwa3QrWnRnbkZ0TDVYaU8xM2FZMmFpRzRlS1A3?=
 =?utf-8?B?alp6dnE3TmplbXlNcm1JcmVZdk9NNmJHNmdUTVNsbjJBamY1UjVkaGNCUkds?=
 =?utf-8?B?RmVJakdMdWkzTU13OFdQSUZZQW5GMll4allpYk1NOVE2TktwbUdwQnl5Yk9U?=
 =?utf-8?B?b2RHbTI4dWdVb1FOZjRhcVFxOEJHTmRKaGRJQjNMTFZkV1VFV0dDU2YvcWFT?=
 =?utf-8?B?R0taQjArekFFSWFSWERRYmxCRklxZXZjbG56UUtUVmF6SitMNFlPS2o5UG9v?=
 =?utf-8?B?b0Q2MUx6aDZiVURWTmh2MTB2L29FUW9vMW1mSmpmU2cxeGFLRy9aTjJ1bWQw?=
 =?utf-8?B?UkRtbnZSUm1td0tNZzE2b3dUVlJjNTU0bWR4R2VtY1laNGM0b3RBbHZrTExk?=
 =?utf-8?B?M1Vnb1V3R04xbFpjWjV1UVZaVm8zUXdENnJ1T3JPYk9CVGtVSUlyWE1pRnFw?=
 =?utf-8?B?cFByQncyeW9xKzRReHRIclFkVHpBK01VQkdBVVBNSHBGTjA2ZFFJeDRVVGRH?=
 =?utf-8?B?anZ6ZTVYWnlFc3NycHRESEcyVFN4Zk44VGp1K01zMEZiS1NVcFREQVdhcFRt?=
 =?utf-8?B?WjdoeU1XMXBQdDNuLzllVGhWWVh1MnlEck9nYXhMbWFORUJ3Sm42ZkFMSjBk?=
 =?utf-8?Q?5hxQO4Jig2G6rdP4vBxfVl2ao?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df29d46-e80f-46b2-15bd-08d9c66f98ef
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 23:54:46.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9htIdGoKSnkeE0tUwHRzJdweevYc5ZfoffpkE9/VgHAS3Nvp1MeO309jThkVhfZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4009
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OI2ddPTAZlErQvKsKBR2nfxeUlxzT5Ph
X-Proofpoint-ORIG-GUID: OI2ddPTAZlErQvKsKBR2nfxeUlxzT5Ph
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/23/21 12:11 PM, Linus Torvalds wrote:
> On Thu, Dec 23, 2021 at 11:57 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> +       /* Attribute name */
>> +       char *kname;
>> +       int kname_sz;
> 
> I still don't like this.
> 
> Clearly the "just embed the kname in the context" didn't work, but I
> hate how this adds that "pointer and size", when the size really
> should be part of the type.
> 
> The patch takes what used to be a fixed size, and turns it into
> something we pass along as an argument - for no actual good reason.
> The 'size' isn't even the size of the name, it's literally the size of
> the allocation that has a fixed definition.
> 
> Can we perhaps do it another way, by just encoding the size in the
> type itself - but keeping it as a pointer.
> 
> We have a fixed size for attribute names, so maybe we can do
> 
>         struct xattr_name {
>                 char name[XATTR_NAME_MAX + 1];
>         };
> 
> and actually use that.
> 
> Because I don't see that kname_sz is ever validly anything else, and
> ever has any actual value to be passed around?
> 
> Maybe some day we'd actually make that "xattr_name" structure also
> have the actual length of the name in it, but that would still *not*
> be the size of the allocation.
> 
> I think it's actively misleading to have "kname_sz' that isn't
> actually the size of the name, but I also think it's stupid to have a
> variable for what is a constant value.
> 
>              Linus
> 

Linus, I added the xattr_name struct and removed the kname_sz field from
the xattr_ctx struct. In addition the xattr_name struct is used in xattr.c
and io_uring.c.

