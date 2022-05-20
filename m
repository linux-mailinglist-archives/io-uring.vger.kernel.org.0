Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8052F297
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352597AbiETS0j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETS0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:26:38 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89B1F7480;
        Fri, 20 May 2022 11:26:37 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHT1fC021364;
        Fri, 20 May 2022 11:26:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=60Zp57JHX40fDvhokqqfdCYBv9Lo5lbWMUK8HEWDpnI=;
 b=H4GhU3ni8RvL77uMwlzfxE3CQaRnR5vTlxkArzvQ1xIdBmdpkjdggihwgFmGaqEKk0lr
 nrQjBJzLELXeB4C787o5iezLuwa5F354oSmitCUOwC6bNM2SdQdUSfLQBtsumXZHQcIM
 lOT4h9U+2Hkx6ci0F4KT9UP+OfWdRhwlJyo= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5rgj8tbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 11:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGytmev8i/3Bh8Fnb1qaF4hiVDP/B779xM+mDVgjKoLVAY7LWu60UYFY0nYbcuK7HpjWUTS6dkoC/pxJNy9d5JAhR3lRUfol76FB0dEpmPx5zJwq5N8+sN/1KKBt1WSaEx35ME16H+h3cKZ6iwEqo2m4x6P0Fa2sxgp4OnW843wVmZaRNQ8cn2xqapHwVAq7RNRPjbtWvSjFaZTkos8nQW99DXSVRuL32H72eV7xIHdijDuLheNnds6jUEkAzSfj5PqZP+L1PKRrTGTLtCyZcaEuGkOA7nUoXxOMMb4vs9AhX3kO4gkJohdQ/ISkdVSggEDqFV0dNuzfnsamAiHiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60Zp57JHX40fDvhokqqfdCYBv9Lo5lbWMUK8HEWDpnI=;
 b=bHkTkC0BKtGPf5T7gPnX82n4AOZC5Jc+fpGYNtO+wJsZpmLJ3PB6DVxtP4lCAUw0tePa6YhbySNNDolM0ElMMybNKP1+ZoHcWx17aWG5oWVwfoTrDUBxfrU8S7HVlXLDLZCBPLVSUvXhTQ5LMmMRHqzHHn046Q2E5z0feA+dJYEz3vSs1B635wyq1Y9HBKbQESI70D1QpxMPBi2CaiC8fEyIGD4NlWsZ7Q0eiXom3WaY1+TzcmswnM6EzjNMmXsIg48VXs1c63+HPu+KfBROyG294qv8+u46XHGCmA15Xf3Yt8r0XAKkuNq6T8Tj6TPAjWo71mMBSI3LthKTEhgUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BN7PR15MB4099.namprd15.prod.outlook.com (2603:10b6:406:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 18:26:26 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::606b:25cf:e181:9f99%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:26:25 +0000
Message-ID: <204e0cf6-1228-b9d8-c416-30d479981677@fb.com>
Date:   Fri, 20 May 2022 11:26:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v3 03/18] iomap: Use iomap_page_create_gfp() in
 __iomap_write_begin
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-4-shr@fb.com> <YoX9neh8SEOBDNkT@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoX9neh8SEOBDNkT@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:a03:331::20) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22344042-f376-4fa7-085f-08da3a8e3fae
X-MS-TrafficTypeDiagnostic: BN7PR15MB4099:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB40991828078D9B3935312FA9D8D39@BN7PR15MB4099.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: shWX+1r6s9hqUGDLwNsGb6dOrWkBArTfQ+ez9fPF+w9a5ATnyDEqqn8JoMgxKZ8wFcL1yB6iALlc+5jEumaeV13KlSjm2aqs2RH2gbELp6RvNYG4z0YirSxoQojqwAM0ycnJ9olz69swDK/QUf7eX0KqkdfCvSBJOGA7j90xqclHkSa75FXB7rEELqBHooKYbmeZHQ6xOlK1gHtB6y4sdI+gbKO6Nl6/IUw0bv0wIfldi3jJo0nERAqYHievJkQK81E7AkwL9XO1uMXekYwmEAuB8iTWc/uls03ehCJpYS+9mfiCe4HQhLteUfp2QvkKTqinZq8nC0nVKFu//MaYNlShgGUAZkkeIBpTJK5z8ltMzzdc+70LEvJ37p3DU21qdmsKU7PNqYcVs45LDDaFCHtnofD2ZW2f3/4D2+J8wvE8mNflY3CPWPpp5V/inXZC4GS+TtEcPOcrkggLunI0gm5AmjToUMRhKjg0QS4DfO839G3SEQa7eJ1OBLACKlRkA0r9ZNXEfEUaflIo7bSaboMonxA/ux3+n/Y9Hwp/w+VbU/fwX8hsTJgsEijqvBN1854JYRYdMdPPS1nRbEHCDOyKlJTIojgNAPlBpSIdDpe2PC6BStvVZZQePUVW/i57iy7mvJAAHVyhnSsdwHzh1P7lINK5vwccPiPWRETDwdFmbjUAHKT+IBhwJ1i3+vDsB1fPKANdrts186QF7Mdm0YVk+WLE1076qQRa0fnFrcROU++0NarIIxCIAGSAIf4r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(31686004)(36756003)(31696002)(6512007)(508600001)(186003)(2616005)(2906002)(316002)(6916009)(6506007)(53546011)(6486002)(5660300002)(8676002)(38100700002)(4744005)(66556008)(8936002)(66946007)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmliWDFQZG9PWVYwRVErRXE4ZkIrdExWZ0lLa0NaanRENkJkMGNWVkxOdU5H?=
 =?utf-8?B?OTlQTzlxRnZvSDlkRzliY1NtSHIvTjRTVllkUE1ZTUF0MmNaMHpOcDlERk0z?=
 =?utf-8?B?N1ZUQk9PYnpHd2pWOXUxUmJ5aFc2MEs1UTlISlBFUEpkc09pbFdDOUdKYzR5?=
 =?utf-8?B?V2VGTVlKZnkrcTVIS0FtdjU1emx2M2Q1RHY2R0tDZWpRRDlFWExMaWRVVG5M?=
 =?utf-8?B?bFl2Z1pNNEQvZzZ6Q1NIZWFGWGNrVWx4anlhK25yUzVyYXVsaEY2SU5uUjhi?=
 =?utf-8?B?RVJiWkdJZFlqNS9qeTNxSzE5czVpNlJOU1JjZnZGQzJsYzJUeTdqaEtSTFJP?=
 =?utf-8?B?cHJ0RFczUHhodncyZW5tOXlxOFZ0TXBtSG8ra0RLMndjN0xDMTJjZ2dRMTcv?=
 =?utf-8?B?Mmhqdi9SWm9Rajh0aCtBSUwyMllGWkN3bFRlaFk3WXQ2YXdSUDRTbGZJanV5?=
 =?utf-8?B?VUZKMy9oandzYnhPdzdxYndERFd6dHZKeG5BTm52bysxdjI3YlVCazhsSE9u?=
 =?utf-8?B?SDhsRC9hSmlhYTRUNklzVWJGbVYxK1NqS1BwNTlHS29SYU5TbnR6VUJFOWlS?=
 =?utf-8?B?SWJkUEpYZ2hhNVNNWDQ3R0Vna3J4K3ZHZUtwNkovNXVFK3Y2Q0FkSVhObmhn?=
 =?utf-8?B?UnEvWENrNUJCT2luSFRxNmxLN0YrTUpxTkcrbll3eTF2cE9sTVg3ZjhDVnR0?=
 =?utf-8?B?TWQ1V2ltTHc4d0ZLaG5xa0lJQ3F0c0RKSEk2TTlndU4yaXhyTGx4MkZPajRR?=
 =?utf-8?B?NVBwSjJnNU9yU1h4UVNueitJSzNqaVVPaVhwbk1TV1RzSmExazB5TmRNeTJR?=
 =?utf-8?B?ZDdlVitxUEw4NFhRc2lFZ0prVVFEOVpITzJraDdEN29KNDdlOTAvaGdUUlBr?=
 =?utf-8?B?V2NYdktmZm9lcEpMb1NUNEhBUnZrOGdIc3g1T3REM3U2TUtiWnRaZk9LRlNV?=
 =?utf-8?B?NDM2NDAzUTEySkNpaWhFWEpOcnNwdEYxUVBzamU4cnZ0andISi9wTnJnTlpW?=
 =?utf-8?B?STQ1UVM4R1B4bXd3akVINzR4bHBySVdZVDBkL0todklEZys5RXQ4R1pVcXQ2?=
 =?utf-8?B?UURSMTIwMXpqVXBNZmJNc2NiYWN3dWJJbXlnRlhpaFQwSExVd0JqWnQ4Rnht?=
 =?utf-8?B?aWh4dG9zRS9SYjA4NEVDc1d4ZFFNUHBQNExEVTVjdjRDYlVUbDV5TzNDaGx0?=
 =?utf-8?B?WW9zTEJoQXhvU29HY0N4eUlzMS94dEZiTGlnbTRuRHZPNFpYaHRnaldIWWxG?=
 =?utf-8?B?azBXVW4wK3BNaklxcHJocCtjTWE4K3V2NzdFMlRkNEtiWVA0YzVzbW9SOUN1?=
 =?utf-8?B?YkVUN3NrZkNUUWZJd0hNTitzaXpyRU1yQjU2dVJNQlRZM1RQQit2bWhtSGNY?=
 =?utf-8?B?N0FsdE5SZmlkTk1BaHp6dmRQSzQyNzhPQUVDRldueGxFNE5GRFV4NW5jMlk5?=
 =?utf-8?B?WnYwVVZseldNclBhKzJxTWhWU3lqbHpSUFFCWklXZCtsUnVLam1GbTZjekMy?=
 =?utf-8?B?dWZXUkdRdzNhRHd4WmhsYU1IcXpBQ1pGZStqVTZFNmFIc2FwTHVWL0lWdnUx?=
 =?utf-8?B?a0lXYlZWWGFaUGZZa0x5REhwZWdsc2UxVDlmdS9IYXB1WjNSNlN1cmplaWhP?=
 =?utf-8?B?N1k0NVZMRHBpSGlYK2ZNaGZiVWRTOUtET0drQlMxNXl0eVFackUvays2cEQy?=
 =?utf-8?B?dFNTdjVHbWNLL0N5ay9OaDNGakVvM3ZqcXZ2b2wxNmlBRHl3NnRYU1NmeDMz?=
 =?utf-8?B?Q2dha09SVHN3aEh6TVFVMnc4ZkxmUkRpYTBHTWVDVzJNSzhMd1RUV3NxdVV4?=
 =?utf-8?B?c3kzclkzZ3lrczFra3N1R25IcG1zc3kya0pNVjdISFF2YktmVmdKYXUvc3Er?=
 =?utf-8?B?czVkV1Z3QTdCR2hELzlLaitTSXFnUlFJajMxcXhDanFFTTM2KzVQdUJxaWZJ?=
 =?utf-8?B?ODV3VWV5RWF1TWJQWHVNYVN1eEJpcGRGSzQvOCtrMUdXWEsrdUN5eS9PUHlj?=
 =?utf-8?B?d21nVFpnNi92Szdhc3JFaHJXWWc3Z2l3VndwemVtdkd4eFdBNHZMWmJLc0NP?=
 =?utf-8?B?SzN3REhBL0pxRUYzd2JlUzlQdzNEOGZuc0llRjNFZVVacHhKZzBzUm0xYmg5?=
 =?utf-8?B?ZlE0N2w5VG5LMzI3QTR2QjNXeTZPUTJYckIyZW84K2d3Qk5acllONDlScFFp?=
 =?utf-8?B?cWZJVmRDbkRrVG9ja3lHaWJTbWNOK1dZckoxN3RLazZ1YTArb2RBNkpPZTk3?=
 =?utf-8?B?TFU4cDNWaks4M0tMNlB4UTVocHRWUU55QWl0N1JQWHNPM0FOK0xpdFZ6WkJG?=
 =?utf-8?B?aEYvVkRkRVd2Wmk0Z2NlK0ZFS1hPYVZRaFRoUmZpT2xhZXNENW1lQk8yMkgv?=
 =?utf-8?Q?CKh3P7n5t12ay25c=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22344042-f376-4fa7-085f-08da3a8e3fae
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:26:25.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dd9zzZwxfaZYV8T0TlnLgsyRk73NsFuh33ao+TV5TDNGg+QSqbEMUrpBx7dTb5fQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB4099
X-Proofpoint-GUID: jgdyOWMEyXcqnEFRrSDJGvJY9Z39bfaO
X-Proofpoint-ORIG-GUID: jgdyOWMEyXcqnEFRrSDJGvJY9Z39bfaO
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



On 5/19/22 1:19 AM, Christoph Hellwig wrote:
> On Wed, May 18, 2022 at 04:36:54PM -0700, Stefan Roesch wrote:
>> This change uses the new iomap_page_create_gfp() function in the
>> function __iomap_write_begin().
> 
> .. and this now loses the check if we actually need the creation,
> see my previous comment.

The new version avoids this problem by removing iomap_page_create_gfp()
and adding a gfp flag to iomap_page_create().
