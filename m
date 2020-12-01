Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808572CAE50
	for <lists+io-uring@lfdr.de>; Tue,  1 Dec 2020 22:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgLAVXZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Dec 2020 16:23:25 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34664 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgLAVXY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Dec 2020 16:23:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1L8vne083804;
        Tue, 1 Dec 2020 21:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TIFf7NKiuU3OZjiAan48G8yrjlMulOwktkWk+2AccTQ=;
 b=Rny8YjzFKeVSAn70XhcdP2BTbf1+QZZaSwX8Z9kgwIcuhXwzMixxnq2eGfuDipRGW8le
 cs/e2VabfipoYEZrYLjXedgJMrY5WmzG7ZekKsavwn+zlV47SKcqFW2khq7VbeJiwJcK
 NtyFsCujzu89ANMa53PI7lwTqyIfyuGOMRi7JrburKEh46NFQ93LvmWSxNx/HwtAhWry
 /f4vJWNAT8T6xNsRCbK0V1Pcd93yJJnwsBA/pBPvwWtTyvn+JaXjD6BGb8I9AdYjARUN
 FGs8vVYsi+N8ikyjNnwDhanFGdTgoUYgPXxhEz/kvILl9+PKIkCvj74RLJom+GJhrLXg eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2aw1qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:22:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LBKsq163826;
        Tue, 1 Dec 2020 21:22:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540fxknej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:22:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1LMYVl018071;
        Tue, 1 Dec 2020 21:22:35 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:22:34 -0800
Subject: Re: [RFC PATCH 01/13] fs/userfaultfd: fix wrong error code on WP &
 !VM_MAYWRITE
To:     Nadav Amit <nadav.amit@gmail.com>, linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-2-namit@vmware.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <3af643ec-b392-617c-cd4e-77db0cba24bd@oracle.com>
Date:   Tue, 1 Dec 2020 13:22:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20201129004548.1619714-2-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010129
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/28/20 4:45 PM, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> It is possible to get an EINVAL error instead of EPERM if the following
> test vm_flags have VM_UFFD_WP but do not have VM_MAYWRITE, as "ret" is
> overwritten since commit cab350afcbc9 ("userfaultfd: hugetlbfs: allow
> registration of ranges containing huge pages").
> 
> Fix it.
> 
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: io-uring@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  fs/userfaultfd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 000b457ad087..c8ed4320370e 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1364,6 +1364,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  			if (end & (vma_hpagesize - 1))
>  				goto out_unlock;
>  		}
> +		ret = -EPERM;
>  		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
>  			goto out_unlock;
>  

Thanks!  We should return EPERM in that case.

However, the check for VM_UFFD_WP && !VM_MAYWRITE went in after commit
cab350afcbc9.  I think it is more accurate to say that the issue was
introduced with commit 63b2d4174c4a ("Introduce the new uffd-wp APIs
for userspace.").  The convention in userfaultfd_register() is that the
return code is set before testing condition which could cause return.
Therefore, when 63b2d4174c4a added the VM_UFFD_WP && !VM_MAYWRITE check,
it should have also added the 'ret = -EPERM;' statement.

With changes to commit message and Fixes tag,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz
