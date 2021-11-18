Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0EB4561CC
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 18:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhKRRyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 12:54:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20094 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234205AbhKRRyf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 12:54:35 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AI72Xhn014659;
        Thu, 18 Nov 2021 09:51:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RQxWERrTof2oJjqI9C+YU2W6IOsa6kH+dAAvfCZKyEk=;
 b=mx8ZoHA04Wg3DZ9+FSPt68st9J78sVIZRYuQb0wgWG+DxW9I5/L/Xvxe0JDnIrXvOEm9
 qk3lWJGwwaVh+yTlv4CUGBsWtuporWc71Sd22uPv4cuKtn0ZKhlgsYEiDV+SwedMTLwv
 Y9Rjku02AT90MvhDQAvCSx7fmuVFr2OSRVk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3cdj39c5nn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 09:51:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 09:50:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbqQSddpzwasCgh6E7Uj3yiMoT6OuH8E0Y4iFJnhRYANCWOlwoDeL0u/YUMTtmq815jV67nMEMKZxnsfJ6zvd9rbxutZVx5RK0hAjDM8+hXg1V2Fe3WoDVM5D9ACTbj9fWXdT2YmIB5ifbZdfwhDLluk6eDU8TQ39Tii2P9omv7BS+vz5N9tAbMvQXUML4FWDg1bNMKr/l9XLfgmyhQkoM+Gff6FlTgrFhwYVZ+0M+D/Bt7S2h3a7CEyt9MaNnLMfOY2LOD90mnsO/W1VNM42WFRdj+6plZUp4ie03ASkSd10aGh1xVWCiGlAM7GLcBV+XV85fkw1kMyQ022ALixDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQxWERrTof2oJjqI9C+YU2W6IOsa6kH+dAAvfCZKyEk=;
 b=TPlli6D8b4tFAIto8SnFBsnqVmDAGNA66N5w1QX5D+ps9om0+isupdZKYb4KYrAgexJcz2+Px4QkPWrVNQCi1RtZgZKlcHp+XxTxStYNfW8PtYJ0oGkikzvEC/hx7ckObX5C+03HrqTjHxeGWTvU19ytVhPMQ760BQZZoECXwJ/ofTxFxO0X9ozoW8cKm/poOWUOwRzKCEA9dc4oit8xe13c5wHUFmaIBGZ0Zrgo0V0kuvuZhM8jAD5Cwi3XbUCqMnnfZvq2svC4JRboRe3vfdaGDKqZpDSzhKRW9iZW1RmIWlHNf19OjiIYd+jhgenaEEnCY6ZdbVhpLYJkAvrH+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2333.namprd15.prod.outlook.com (2603:10b6:805:19::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 17:50:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 17:50:32 +0000
Message-ID: <887b81fd-fd08-f214-6920-07f38346a677@fb.com>
Date:   Thu, 18 Nov 2021 09:50:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v1 4/8] epoll: Implement eBPF iterator for
 registered items
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, <criu@openvz.org>,
        <io-uring@vger.kernel.org>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-5-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211116054237.100814-5-memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR13CA0038.namprd13.prod.outlook.com
 (2603:10b6:300:95::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::1798] (2620:10d:c090:400::5:184a) by MWHPR13CA0038.namprd13.prod.outlook.com (2603:10b6:300:95::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.16 via Frontend Transport; Thu, 18 Nov 2021 17:50:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca04df50-cdd2-4ee2-2542-08d9aabbea82
X-MS-TrafficTypeDiagnostic: SN6PR15MB2333:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2333B9AE9D776D50E6228EE0D39B9@SN6PR15MB2333.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJnc5v56Qm8ww2I8XlS/29AQHgOg6bDi+gU3LN2koOiDJKzO4xPlEgeGFlMMlHA8kjk/sjqiHZ6i9gTow85sEtM5RhFeJ3E0v62rd9estdwmh/LwsGhtHlcfLZbTWR/xYIfROBZdFeWirCWYewVPfeE5fKt1PUpu82mPhQW3C725Uw3VRZ+0oj/AOJmbIP1eqDDZX084xV/g2Cy+wEnmERi/8QzfkvxOlKQLk7NgTNMAw/H9eVStwsr/7Tt1nbUKj8lJui+c0pSOjZgRHlWBR5M+EZgN100gNyJwYaxGzd3jNY2ymK9gWFFU8dYgv8PUZcyu8zhSgoeX3DM9SpWUNlQ006BpLumZkC48MvTN3jQ7ve0IgBF4bv8wGhn1Yc7wVddPamQgQBKdxQHf9xlqO8RK/Isb2krMXabpySU/kAIxN0gtxLAonbjofor9RGwcxPHlcLWlTLN+6xWfZn/mSuYn1WbZEqpQKbLY/yxOnrrhvYBwIPwFHsAsb2FdDmj5UczarouEfdC+LGTbJIhIYaQNT69o2NubIlDj5yVCm6+2lsP2G+oa1XjEG5duLmCLKJZyU5D+mknJjT7Xhy+QR6s27RvEVAgDf2zvaMw233DJL9YCm8v3VFNg4Q3Fl0BfHWSWGTkQQAJJWaZ3VSW3JeQX3G1v8O5pfUvxnS3aKikliX+7oWlEnRD8yitPFIjHrjk6R1wR+YHcP5ntBuz4CdArLwaGmaznO/t3C9jHezMHMC/W5rWgxJvDNswhyUyaZ03aXgLGYDjpKXrAZAUNyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(53546011)(86362001)(66556008)(66946007)(66476007)(8676002)(6486002)(2906002)(52116002)(5660300002)(31686004)(316002)(186003)(2616005)(38100700002)(4326008)(8936002)(31696002)(508600001)(7416002)(36756003)(54906003)(43860200002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEY1M0I1RmNJVTlCSk1mM2lZai95WVBwNVl5T1lKQUcwUHhCT3BLdHl0K2hl?=
 =?utf-8?B?dGlhYkJVVFFuck9WTlFjbDZwcnI4cjJmVW1TTTVqS2NISGtWd1M0bGVITHhU?=
 =?utf-8?B?YTc3elgyVytoTEpLSi9GZTEwV2ovYUd3NFdBaWFyUkVJbzdJYm9hOVcxUXdD?=
 =?utf-8?B?VVV4U2VWK0Vtc2c4R2RiUGw4c01RM2JaLys0NjRGRnl1VnRrNmRHdHcxeFFr?=
 =?utf-8?B?dXdueCtDSldoRjc0Nm4yWGRiNmpQL1hLY3dwbmo0VmwwWWxrejVZODU3OWtk?=
 =?utf-8?B?SlcwM2cyUG1IMVFuRXY1SVNsWUgzTmRJV3JpZVE5dERYQUp4NFZIQUZjdWN5?=
 =?utf-8?B?cmtSVmNEVWhlMTZqT0RrTXRQNHV4ZHRLc2dKTG5IMFBMUmp4QXFaem8xREYw?=
 =?utf-8?B?dUNYRnlBSzNvaDJOdU5FNW13Yms4OG5YTGlMbXR2THozZExBU3FOY3lBTER1?=
 =?utf-8?B?a3JVYy9Ia0NDVVVFWmFDU2JnejlUcHdSaEIrd3VKandkYXBLblZiN0hkOTgx?=
 =?utf-8?B?NXQ5dWdCa3BVUnlLbGNsSHdjZUVJUUlGSDhESk5DOUd3ejZ1dVV5QmtwL1ZG?=
 =?utf-8?B?Z3pLa0ZwU3N3cWhkVlJUb3hkeWs4S0I3Slk1K3ZZTWxwcWpqbm1EUDNJdUZz?=
 =?utf-8?B?WGNVdEVwYy90MzRBYWZOM3phQUxtRWZoOC84QXZ4QWY1L0N6STB6NFQ1dHdL?=
 =?utf-8?B?MUN3VUJFaXR0NFVBZUVUd0FQSEY0aDZjZlJEYjVOd1NrOUxsUUgzOHpvbUNG?=
 =?utf-8?B?bDJyWmRFMmxNVjlJTVk2VlhVSDlnTTZVQTAxeUxBeXlNNTliRElZYVJ6VW5u?=
 =?utf-8?B?VFJWSzF4Z2NHcjF3ZW9sTnFGZjBVWUJKRHNHMHA0Sm5DNjdRcUdDOHVZL0Mx?=
 =?utf-8?B?V1JTeElYZ2EyUzJpT1hNZlptdmpSY2wwTTdCb056ZjNHczdpR3k0eWxoaWla?=
 =?utf-8?B?K1dwYUxpYVdwWDlOYmhIYjBQamN2YndtdEpJVnFONjNUc3ppcmpLcXVmeWFK?=
 =?utf-8?B?S2VKdlpxSTFyNW8yVkpGSVVNMHEvYml5R0lOMWxENzZsZ0loNzN5S3NTR21R?=
 =?utf-8?B?TDl2MEVVYWRmcFJySm4yYzRnUFNROWYxZEh5V21mSHdjYlV4dFAxRHZib0Rp?=
 =?utf-8?B?TXhFSVBYTVBHMFZTSkUxdlRpNnJMU05CaXAxUm1KaG1pMkpmclRZNjJYQ0s3?=
 =?utf-8?B?NlVQVVRHNld5MzJJYXM3NjVwR2FZQXlyK2w3ZnRCeUdWeUR1d1BiYzA3d3Y0?=
 =?utf-8?B?UHFsck9EcWVESURXblVqZ2xtU0RtNkFuUUhrallVUE0wTFcvTEFGYVJMYXFP?=
 =?utf-8?B?QjFJS1JFYXFGUkFPR2x2RlduRmNpSkFKNFB1S1l3VGs2SDg1YTJjZENFV2dh?=
 =?utf-8?B?TUtlVmpqdDI2VWxIZ0trZXRVTE9rZ1pSM29VelNUSmUzSU1tNW1kQ1JwQ2lp?=
 =?utf-8?B?eWUreHZPQVY1VUs1TEMvdWFwaGQ5Q2tRUkxKUFNROS9OK2ErR0JPdFBkQitH?=
 =?utf-8?B?a2t5SWdSb0JLUUowQmlNQ3lCc1IwSVkxQVBORGRaL09YZllkTzhwOVYxUU80?=
 =?utf-8?B?UG9oU2kra1NmckxxdDg5NmRHUU9qVFBQMG9KM3BEaFlCZTBaRVdId1pzZkJm?=
 =?utf-8?B?VzZ4bWlSNEZpci95OEtybXBRbW93Z0ZkNnRVd3poOHVwaXlWWEJMdjBEcXk3?=
 =?utf-8?B?OGxMOU9FaXBKelNNTW53Uit2REFaOWVDbEg3VmV2TUMydjA5ak5VSG8vd28w?=
 =?utf-8?B?THhBbTloQXN0dWo1cWNPWkJTa2tORzFtL2MwTmF5WjhFYzk1UXVDTWg2b3cy?=
 =?utf-8?B?Q1NyM25lZ1Q3K09rNDZwSHNvcFNRVFczSndvVUpucHRYTVBIRzhLYlhNYWJC?=
 =?utf-8?B?QVNQZGY0Q25VTGNzeEZrNE1YQnNyQnUxL1l3K2IxZ1hwelZvUzlGbDQxd282?=
 =?utf-8?B?d0J0SENveTNlTC9rSFU2eXU4SGg1azBqNVJINTdKc01wWTB0VHViMkdxWC8v?=
 =?utf-8?B?bWxKVGRQRFdqdXYrejQvZHJwQW5oQTU1YnZxdjhWY25kZGxGam1OOFBTVWhv?=
 =?utf-8?B?YUpmNU1LZ2wzQmphbHBuNXhUSW1tSXJVMmpDVFFqYzR3blAvcVJ0eVR2QU9N?=
 =?utf-8?B?UmFaekJ4SHd4aGE4eU8zTU52V25EcktMdVlRZmk4dVhBdjk1Smsya3RKaGQ3?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca04df50-cdd2-4ee2-2542-08d9aabbea82
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 17:50:32.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /u7PY/iRvos74AmpKoMaekedM95MK7nZ47gX9I4jYpZyhujXlgrE/iEXWo0YEOGK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2333
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: b9vlnUZ9HSU6IgbUTwRuaIf-MwybTKTG
X-Proofpoint-ORIG-GUID: b9vlnUZ9HSU6IgbUTwRuaIf-MwybTKTG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> This patch adds eBPF iterator for epoll items (epitems) registered in an
> epoll instance. It gives access to the eventpoll ctx, and the registered
> epoll item (struct epitem). This allows the iterator to inspect the
> registered file and be able to use others iterators to associate it with
> a task's fdtable.
> 
> The primary usecase this is enabling is expediting existing eventpoll
> checkpoint/restore support in the CRIU project. This iterator allows us
> to switch from a worst case O(n^2) algorithm to a single O(n) pass over
> task and epoll registered descriptors.
> 
> We also make sure we're iterating over a live file, one that is not
> going away. The case we're concerned about is a file that has its
> f_count as zero, but is waiting for iterator bpf_seq_read to release
> ep->mtx, so that it can remove its epitem. Since such a file will
> disappear once iteration is done, and it is being destructed, we use
> get_file_rcu to ensure it is alive when invoking the BPF program.
> 
> Getting access to a file that is going to disappear after iteration
> is not useful anyway. This does have a performance overhead however
> (since file reference will be raised and dropped for each file).
> 
> The rcu_read_lock around get_file_rcu isn't strictly required for
> lifetime management since fput path is serialized on ep->mtx to call
> ep_remove, hence the epi->ffd.file pointer remains stable during our
> seq_start/seq_stop bracketing.
> 
> To be able to continue back from the position we were iterating, we
> store the epi->ffi.fd and use ep_find_tfd to find the target file again.
> It would be more appropriate to use both struct file pointer and fd
> number to find the last file, but see below for why that cannot be done.
> 
> Taking reference to struct file and walking RB-Tree to find it again
> will lead to reference cycle issue if the iterator after partial read
> takes reference to socket which later is used in creating a descriptor
> cycle using SCM_RIGHTS. An example that was encountered when working on
> this is mentioned below.
> 
>    Let there be Unix sockets SK1, SK2, epoll fd EP, and epoll iterator
>    ITER.
>    Let SK1 be registered in EP, then on a partial read it is possible
>    that ITER returns from read and takes reference to SK1 to be able to
>    find it later in RB-Tree and continue the iteration.  If SK1 sends
>    ITER over to SK2 using SCM_RIGHTS, and SK2 sends SK2 over to SK1 using
>    SCM_RIGHTS, and both fds are not consumed on the corresponding receive
>    ends, a cycle is created.  When all of SK1, SK2, EP, and ITER are
>    closed, SK1's receive queue holds reference to SK2, and SK2's receive
>    queue holds reference to ITER, which holds a reference to SK1.
>    All file descriptors except EP leak.
> 
> To resolve it, we would need to hook into the Unix Socket GC mechanism,
> but the alternative of using ep_find_tfd is much more simpler. The
> finding of the last position in face of concurrent modification of the
> epoll set is at best an approximation anyway. For the case of CRIU, the
> epoll set remains stable.
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   fs/eventpoll.c                 | 196 ++++++++++++++++++++++++++++++++-
>   include/linux/bpf.h            |   5 +-
>   include/uapi/linux/bpf.h       |   3 +
>   tools/include/uapi/linux/bpf.h |   3 +
>   4 files changed, 205 insertions(+), 2 deletions(-)
> 
[...]
> +
> +static const struct bpf_iter_seq_info bpf_epoll_seq_info = {
> +	.seq_ops          = &bpf_epoll_seq_ops,
> +	.init_seq_private = bpf_epoll_init_seq,
> +	.seq_priv_size    = sizeof(struct bpf_epoll_iter_seq_info),
> +};
> +
> +static struct bpf_iter_reg epoll_reg_info = {
> +	.target            = "epoll",
> +	.feature           = BPF_ITER_RESCHED,
> +	.attach_target     = bpf_epoll_iter_attach,
> +	.detach_target     = bpf_epoll_iter_detach,

implement show_fdinfo and fill_link_info?

There are some bpftool work needed as well to show the information
in user space. An example is e60495eafdba ("bpftool: Implement 
link_query for bpf iterators").


> +	.ctx_arg_info_size = 2,
> +	.ctx_arg_info = {
> +		{ offsetof(struct bpf_iter__epoll, ep),
> +		  PTR_TO_BTF_ID },
> +		{ offsetof(struct bpf_iter__epoll, epi),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +	},
> +	.seq_info	   = &bpf_epoll_seq_info,
> +};
> +
> +static int __init epoll_iter_init(void)
> +{
> +	epoll_reg_info.ctx_arg_info[0].btf_id = btf_epoll_ids[0];
> +	epoll_reg_info.ctx_arg_info[1].btf_id = btf_epoll_ids[1];
> +	return bpf_iter_reg_target(&epoll_reg_info);
> +}
> +late_initcall(epoll_iter_init);
> +
> +#endif
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fe7b499da781..eb1c9acdc40b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1512,7 +1512,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   struct io_ring_ctx;
>   struct bpf_iter_aux_info {
>   	struct bpf_map *map;
> -	struct io_ring_ctx *ctx;
> +	union {
> +		struct io_ring_ctx *ctx;
> +		struct file *ep;
> +	};

You changed to union here. I think we can change
"struct bpf_iter_aux_info" to "union bpf_iter_aux_info".
This should make code simpler and easy to understand.

>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b70e9da3d722..64e18c1dcfca 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -94,6 +94,9 @@ union bpf_iter_link_info {
>   	struct {
>   		__u32   io_uring_fd;
>   	} io_uring;
> +	struct {
> +		__u32   epoll_fd;
> +	} epoll;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index b70e9da3d722..64e18c1dcfca 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -94,6 +94,9 @@ union bpf_iter_link_info {
>   	struct {
>   		__u32   io_uring_fd;
>   	} io_uring;
> +	struct {
> +		__u32   epoll_fd;
> +	} epoll;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> 
