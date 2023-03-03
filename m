Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F7D6A9DB3
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 18:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjCCR36 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Mar 2023 12:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCCR35 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Mar 2023 12:29:57 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A899658B51;
        Fri,  3 Mar 2023 09:29:56 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323Dvl4E025347;
        Fri, 3 Mar 2023 09:29:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=s2048-2021-q4;
 bh=g/W2AKTCoh2Hva/SdF4NrK3KkmqTG8MZNusMyHVuhXc=;
 b=m9mScv+ExyS6IHaWzZizXbF2kCUKfVwoX7G02iGdARwf7D0uaxxqI+2nn2NpUk6Ovu89
 fMadLdD707VYCPr1eynu7UPOC/R756ZgQT78KiVgBbzFoUbO/inzueCw0Ye0ZfxT7b1c
 p14Mjh40GbC6E7hzcMiYbgY60wBkW4ybeI+CpZY9JsxWo/Whg1/9oS2R++c934Vxzkf6
 jAGWHAsSxb99/b2NB+9cz7QwMHzgLerQuVWr7d1klj1iXi6Va+GNFQ/wcEYH7szgUv9S
 ihS7o5R0HsQM2IWxUB3q6bUGWmQil9Gw6ymPV/QwHJp9t84kuSNJU2hP81VbrScfLAyX wQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p3j85sc6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 09:29:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b75p+d8SXl7xqdk0pkCrZxVZgMP3SboPTo2k+W3Gs4/Gg3R7nw79yaxoQCAlA/sLF0dsETxVLbg4X3GCdZploC5gonFvUb61yEcyotJwdxqFsOUuL/I716jNT5bFHVeZYWtrimMKvXcB1BQr+G93ufaCav3UIGWyDfP6pCOGE8/llX4c+VUFtQ1FdozTDf1my3IKUKuNhA9wN+9JdBtpIyJRj/MfQwrWBOuWlL3uqTmGjEFzOcIx7Npw4NIo7yz5OiFPDzVVJnPLEoRv2dj+6MN553ozcFHNGfE9rEeZ3yvBYaVGMknc4dYnzQeQdlV/qyobXWB2HvRmls12WN/CiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGjSHxV0jXa7tEpaNR+Vk5v8nODaWMDBsLcUIejd2ew=;
 b=Y0xH43zY2PqNhBs+EwXhhn63Gfp0sM7jAL1WHKQ05NrgO4dSMVZE/guhS+bgERZ95wBrBrsqAqG8L2R+B557s9GGyKgHAkp8UkSjzjuM2pq9fQPIjlGOW6+IsxPqDXMyeJKNZH5XbDlIanma3ouvEBZGUOxkiJWLS+oOd/3iZMKle4zYj1Q5LFGp7syjBt8T7Xjf1hOaG0hskdf811uoHplVXSLbPW3jnGlLm1AAkyqVahpu5m7pFU/vUn+mjBnjKC6vT9SBtXnMxdn/cTLAZnpYuV8/2sbSiA3D1Xkh2Mo0DLFny1PqbWsqy3aB3t8ZP0hq1UWXk7PkmfOHmckIiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 DM4PR15MB5995.namprd15.prod.outlook.com (2603:10b6:8:185::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.22; Fri, 3 Mar 2023 17:29:33 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::8f86:e98d:1276:d0fe]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::8f86:e98d:1276:d0fe%3]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 17:29:33 +0000
Message-ID: <0d43e015-057f-2379-a0fb-d55539b803eb@meta.com>
Date:   Fri, 3 Mar 2023 09:29:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RESEND PATCH v9 04/14] iomap: Add flags parameter to
 iomap_page_create()
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        hch@infradead.org, axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-5-shr@fb.com> <ZAF8vk6Jns/40bc0@casper.infradead.org>
 <ZAIl7JfPXivtN8qm@magnolia>
Content-Language: en-US
From:   Stefan Roesch <shr@meta.com>
In-Reply-To: <ZAIl7JfPXivtN8qm@magnolia>
X-ClientProxiedBy: BYAPR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:a03:114::13) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|DM4PR15MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: ca56a5f7-5d8d-4d55-2134-08db1c0cda65
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6iyiAH+0ZlcTS+c1q6Ca8z0LCus370LDRKM9bdaLiUaq2wiqNMl8Xr6M2az1r4uJSz1bEBgUInBzDJwYCPk8HhIni1+GWUsjjzCnN7qHHaE4MJAjyiVyxzuWkVW31GvpD/o/0b3cqAvqQDxsgkuKTEmxn0MXSUyrgcGxDSueFcTPtGTwMFd1j/jJ7bbp8iOchVHhpQISaoBpfvmCE13nkFPdefprKQaaS6n1ifiVIfZvYR33Pm7a5LiFyWgQIr9GT5QYzktfzdpnPfQfVp6lHUxm+PypHrqY1L5Y99WekccupwiFFDKoxlLMHOvyaqaQWIak73uyGdQ50ei39dN2jkI4FVPNsDaSEx8sIx5fzz3MuNwuAMHCqhPCLGnRxOF+4TOYXccbCVLEwSRLJdX8SqRgzKliWbaTMcpsRsME3FvimOaEDwTIqndEVho8WvMrfrYRAFdLeGm9qNimAUqacrMHp/j7WlNySzJhB6g8AXYwEFZYqWJF9PwKY/21SFs6OrR7tFnS+wU8t7cumS3JPDj5OueKMud/ItPSisGELxPM47bvesNYKHo9/JtWJU6rhDvaM9NeTCbj4cqRUuuHZVYIhtfyRvXvUd7nNKyJcKSxVHL0rIAVBXyvcORBsvCoLSn7ONVGmW9UHk2ZFghWuhLmvLlbMFLBzfRlIJ3Y/mw1RDF7Y038IX5tRRFHqsEXLIT1RMH0pu6keV1mdlbkUZo2sdH9shjSPMU1xDFSdo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199018)(7416002)(2906002)(38100700002)(31686004)(31696002)(86362001)(478600001)(6486002)(53546011)(6512007)(186003)(6506007)(36756003)(66946007)(66476007)(66556008)(4326008)(8676002)(83380400001)(54906003)(110136005)(5660300002)(2616005)(8936002)(316002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHdSbVVUeTZuQ2RqWU5aSGtIVzE5V0o3RjFNcXE5dHI4bmlHSjlTWHBjbWhi?=
 =?utf-8?B?bzV0L1kzeC8wTFFnWHcxMlFXTlVNNWRNZnhSYlZqMExUOFh1U2FHVm8wUll2?=
 =?utf-8?B?VjY2QWNEdlVKcGhlRnFUWVIwQjgzSDJBaTFsOGVnYmphODdMdjU5elhwRkhE?=
 =?utf-8?B?SkNycjlTQmwwR3Y4d2NtSTRJZ3UrUGdBbjFmZ1BhQXJNUFljSUQ4TWc4eGJx?=
 =?utf-8?B?MWE2aXF2TXZUODlyVExkQUlmazQ3VS91Zlp5V1ZsdGxiRENld3lBMSt3K3dk?=
 =?utf-8?B?clZrcmdZNVI3MXppRXgydjdFd043NEpyb2twbEE4UzByQTlOWHpMc3RBOElQ?=
 =?utf-8?B?VmZMU3RINWYvNFV4VmlnZ1p5bkorRzBiOU54ZWtYWnI3b0JzMzB0cEV0aXNV?=
 =?utf-8?B?WlFUUG5uUHFoVEd4ZXRaYmh0V1U5TFQ3K2FDSWFDUVo3OXZiSXluOWRYRnlF?=
 =?utf-8?B?OTkwZ3NTSUd6eVJkTFJaZXIzbUJ0TWpCUzdpNnBtY0VFS0RPYnZTSlJSejJw?=
 =?utf-8?B?S3RPYW80TXo0dVhEbGZnL04wMzNxU2RndXRHbEFZOHE3OHVLdEFHSnRoaU50?=
 =?utf-8?B?cUpnaWNFTHNkU1hKdk4va2ovbDFLb1M1ZjhTaWtYdHRKY0MvZGFxQUFDRWhw?=
 =?utf-8?B?Z203T3hNMjhmRWxoY096b2VLZTlPNFB2QzlXSnpsZmJyMWkxd3Bzd3QwYWpv?=
 =?utf-8?B?VldFdDUxc0JtdnlLRGRjNVBSc1lBU1J1MWRsblZrSThFZkkxNXNrNHBIYllS?=
 =?utf-8?B?dm8zR3M2WHhsOUpWd3NlOUgyeVJYR1lMSlFuR1RCdHZ4RUl2Y3F6K3AvYWZz?=
 =?utf-8?B?YW80Vm83clcwVVIzWHltVXJ6dFc2WDZLSU9mMlQyWXlSOEtTYVozUTVHRVpH?=
 =?utf-8?B?NnRJOTVRSXoyZGRSMXhKMEV0dVlmYll1aE5QTEtqSGRCVXp6VjdPQlZXdTNK?=
 =?utf-8?B?UEtGa0JyeGYyYitYVmxnaHJNTHBOdGx3QU1ydFdNdVpEN0JHSUlDVldBTWFO?=
 =?utf-8?B?bmREcUFrcjArM3M1WW53Sm44MTJQOG9MU29jNWpyYkJBT1BoYVNsSWtGR2Q1?=
 =?utf-8?B?TG11YlpNL2NGZGJLeDJlTS9VeUE5c1Z5S3VvQ1NOZFozSHFtMlJaY1puMHlv?=
 =?utf-8?B?RlZjTGhYOFJ1K3hwU09VM2ZGRjFCaUEyRWpDZkErY2VQOFZiV1hlZzlzcFRU?=
 =?utf-8?B?TGRTaWJTZVdGNXFxSUFwTnFNNHV2VUhuakdWWllvYmJ5TzN2eTZseEVEUStv?=
 =?utf-8?B?c1hZL2RaL1A0ZmJHR3FIYStlekZDbjN6c01OSFdzYnhOUmY4SW1mYW5oOFNE?=
 =?utf-8?B?ZXRCK1YweUpFQUxJSTc5ZmxaRi9MZU1sWkpQWUttTzVLSk1QMEl4MzFDakpz?=
 =?utf-8?B?ZURXaDVMOUpTTlU5eUFlYVNuVFFCYVJkOXZMdlBPL2pXeTBtVldDVkZENGJi?=
 =?utf-8?B?VENqOTh1ckcycWdHcUlkeXZ0bS9xV3pGWDU4SDl0YnZOSzJ6SnNyaWRySzdy?=
 =?utf-8?B?UzhEbitEb2R4cVdsK1FHOGQxeVAvRWpBNTJ4VU5IT2JFNXRVYnFrZzMrWGJT?=
 =?utf-8?B?VUphWjZhd1cwVTRlRXp1UllkOVFBWEN2UTJMbnJnU1RMb2ZNUkF0MnpMUDRC?=
 =?utf-8?B?c2tCMy95aEhsc3Z5S3VuMzdxaG8xNVFZZkkxVFdCcnBFazR1K2hhSWNCSDNG?=
 =?utf-8?B?Tjk2TWY4eE94UDdZZG9pdk5CaTQvcUpBZmwzMS9kSWxJSlN4WUI3RVVnU21C?=
 =?utf-8?B?SEtyUHY5MUpoY3pMUXRGK241c2NDVVVvaWEzeFQxeXZnU1gyZVRSZi8waXc3?=
 =?utf-8?B?MW1IR1BQTXAweWpJSUVyWGlKYkFXRnVWd0NOdlpXRnNHRUN1OE54SEZnQUJR?=
 =?utf-8?B?OTJYWWM4aE02amdGUkpzWDJIdGlDVmJEa280eVp4cDZlQm94R0t4Ykg5c0cy?=
 =?utf-8?B?SmZBeFgwUXR0THF5TmJzSEd6VEV5NU9WUFJuZ1dBYXpnZzdnT1haamtJRUJH?=
 =?utf-8?B?MkxwZ1cwNHdRSllXOU1mKzY0Nm5ObTRPR1h2cDhabXJOZXVIbE92S05jMkVr?=
 =?utf-8?B?bWxVclVlbUs5YXpIU3VjWU1ZOHFxOVIzRS9nK1BuMzFweDNiUlFPMjJFK3JD?=
 =?utf-8?B?R3RvMEFCY1NtQnhzRnU2VFlQbFZxL0JOaGpNSlhBbGNUcHVFOHg0VXl3eHJQ?=
 =?utf-8?B?REE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca56a5f7-5d8d-4d55-2134-08db1c0cda65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 17:29:33.4802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VSQb+65d3PX7eMTwjikm1mKmhtZvM6kufmrUwDcubaA+a8vWrohlZIcF5eIvD3sf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5995
X-Proofpoint-ORIG-GUID: UKmQFgs-t4jG7lx1Aqpb3qaPhQrltXYK
X-Proofpoint-GUID: UKmQFgs-t4jG7lx1Aqpb3qaPhQrltXYK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_03,2023-03-03_01,2023-02-09_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/3/23 8:53 AM, Darrick J. Wong wrote:
> >=20
> On Fri, Mar 03, 2023 at 04:51:10AM +0000, Matthew Wilcox wrote:
>> On Thu, Jun 23, 2022 at 10:51:47AM -0700, Stefan Roesch wrote:
>>> Add the kiocb flags parameter to the function iomap_page_create().
>>> Depending on the value of the flags parameter it enables different gfp
>>> flags.
>>>
>>> No intended functional changes in this patch.
>>
>> [...]
>>
>>> @@ -226,7 +234,7 @@ static int iomap_read_inline_data(const struct ioma=
p_iter *iter,
>>>  	if (WARN_ON_ONCE(size > iomap->length))
>>>  		return -EIO;
>>>  	if (offset > 0)
>>> -		iop =3D iomap_page_create(iter->inode, folio);
>>> +		iop =3D iomap_page_create(iter->inode, folio, iter->flags);
>>>  	else
>>>  		iop =3D to_iomap_page(folio);
>>
>> I really don't like what this change has done to this file.  I'm
>> modifying this function, and I start thinking "Well, hang on, if
>> flags has IOMAP_NOWAIT set, then GFP_NOWAIT can fail, and iop
>> will be NULL, so we'll end up marking the entire folio uptodate
>> when really we should only be marking some blocks uptodate, so
>> we should really be failing the entire read if the allocation
>> failed, but maybe it's OK because IOMAP_NOWAIT is never set in
>> this path".
>>
>> I don't know how we fix this.  Maybe return ERR_PTR(-ENOMEM) or
>> -EAGAIN if the memory allocation fails (leaving the NULL return
>> for "we don't need an iop").  Thoughts?
>=20
> I don't see any problem with that, aside from being pre-coffee and on
> vacation for the rest of today. ;)
>=20
> --D

If IOMAP_NOWAIT is set, and the allocation fails, we should return
-EAGAIN, so the write request is retried in the slow path.

--Stefan
