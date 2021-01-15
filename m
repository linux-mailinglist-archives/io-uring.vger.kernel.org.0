Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555762F847C
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbhAOSch (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 13:32:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbhAOSch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 13:32:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FITNIq018553;
        Fri, 15 Jan 2021 18:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JJOfHmyCgEPBhvsQQ8JdXKpwKCjKP1apDIw9+Y+Ls7E=;
 b=rO6LhkYEgIff6b+p2y5JZFxNkumzqoF+tndJ6JwiGKjIGTmrka4Wdj3eL0C5wMetmPAf
 GmbDTIotTnBaDPp0QqNaYNmhb7w2XKTfOLlfAUOvsbWDVJDkSQXgLqVAGMOlBwubgQF2
 PKL0X8IHkXw61qKNTHlQmEFAF3M6bb7OQ7Drzp7LGXI1tk119uMbY4EiCk2LXtbC7EYC
 +DhZAHCw9J22d4keurQ0n6UCRjFokXRZuLkPbuXDXg9Hfbm+W8QwkAaXlPBh9xmPC4nh
 6n+r1aC5Zcer8asfZ9WysLe++tasjUzJDiW0TE+3bD+IDqSyp6wB9XiwAqlJ0m3+DQy4 zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvke5kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:31:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10FIVoRA079291;
        Fri, 15 Jan 2021 18:31:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 360kebeupq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:31:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10FIOC1n029026;
        Fri, 15 Jan 2021 18:24:12 GMT
Received: from [10.154.100.45] (/10.154.100.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Jan 2021 10:24:12 -0800
Subject: Re: [PATCH 0/9] Bijan's rsrc generalisation + prep parts
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1610729502.git.asml.silence@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <4da98b8b-88cb-0d4a-4248-8e593926db2f@oracle.com>
Date:   Fri, 15 Jan 2021 10:24:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 210113-0, 01/12/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9865 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150111
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/2021 9:37 AM, Pavel Begunkov wrote:
> I guess we can agree that generic rsrc handling is a good thing to have,
> even if we have only files at the moment. This consists of related
> patches from the Bijan's longer series, doesn't include sharing and
> buffer bits. I suggest to merge it first. It's approx half of the all
> changes.
> 
> Based on 5.12 with a few pathes from 5.11 cherry-pick to reduce merge
> conflicts, because of merging/etc. may wait for a week or so for the
> next rc before potentially being merged. This also addressed tricky
> merge conflicts where it was applying and compiling well but still
> buggy.
> 
> Bijan, for the changed patches I also dropped your signed-off, so
> please reply if you're happy with the new versions so we can
> add it back. There are change logs (e.g. [did so]) in commit messages
> of those.

Looks good, thanks.  I'll wait for your review of the buffer sharing 
patch, and once this series is picked up, I'll resend the buffers 
patches set.

> 
> Mapping to the original v5 series:
> 1-5/9 (1-5/13 originally), mostly unchanged
> 6/9 -- my own prep
> 7/9 (7/13 originally), only file part
> 8/9 (10/13 originally), only file part
> 9/9 (11/13 before), unchanged
> 
> Bijan Mottahedeh (8):
>    io_uring: rename file related variables to rsrc
>    io_uring: generalize io_queue_rsrc_removal
>    io_uring: separate ref_list from fixed_rsrc_data
>    io_uring: add rsrc_ref locking routines
>    io_uring: split alloc_fixed_file_ref_node
>    io_uring: create common fixed_rsrc_ref_node handling routines
>    io_uring: create common fixed_rsrc_data allocation routines
>    io_uring: make percpu_ref_release names consistent
> 
> Pavel Begunkov (1):
>    io_uring: split ref_node alloc and init
> 
>   fs/io_uring.c                 | 355 ++++++++++++++++++++--------------
>   include/uapi/linux/io_uring.h |   7 +
>   2 files changed, 216 insertions(+), 146 deletions(-)
> 

