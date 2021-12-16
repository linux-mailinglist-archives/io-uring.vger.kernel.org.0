Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412764772E4
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbhLPNPQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 08:15:16 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29136 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbhLPNPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 08:15:15 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JFCFS3Sprz1DJv2;
        Thu, 16 Dec 2021 21:12:12 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 21:15:13 +0800
Subject: Re: [PATCH -next] io_uring: use timespec64_valid() to verify time
 value
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211202064946.1424490-1-yebin10@huawei.com>
From:   yebin <yebin10@huawei.com>
Message-ID: <61BB3BE0.8080405@huawei.com>
Date:   Thu, 16 Dec 2021 21:15:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20211202064946.1424490-1-yebin10@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ping...

On 2021/12/2 14:49, Ye Bin wrote:
> It's better to use timespec64_valid() to verify time value.
>
> Fixes: 2087009c74d4("io_uring: validate timespec for timeout removals")
> Fixes: f6223ff79966("io_uring: Fix undefined-behaviour in io_issue_sqe")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   fs/io_uring.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 568729677e25..929ff732d6dc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6151,7 +6151,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
>   			return -EINVAL;
>   		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
>   			return -EFAULT;
> -		if (tr->ts.tv_sec < 0 || tr->ts.tv_nsec < 0)
> +		if (!timespec64_valid(&tr->ts))
>   			return -EINVAL;
>   	} else if (tr->flags) {
>   		/* timeout removal doesn't support flags */
> @@ -6238,7 +6238,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>   	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
>   		return -EFAULT;
>   
> -	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
> +	if (!timespec64_valid(&data->ts))
>   		return -EINVAL;
>   
>   	data->mode = io_translate_timeout_mode(flags);

