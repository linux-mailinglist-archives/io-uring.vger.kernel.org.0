Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033195358E7
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 07:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243510AbiE0Fys (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 01:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbiE0Fyr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 01:54:47 -0400
Received: from pv50p00im-tydg10011801.me.com (pv50p00im-tydg10011801.me.com [17.58.6.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049E3E64EB
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 22:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653630885;
        bh=1f0ThiJdO9jpD2mLNITPkhesU6gknwaQTgPyiL7rnes=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=0Q/xxBRV4NtSgOkHovCK3AwNs0r9EqDE0t+XJfKVTxb5is+hkOtRN5UAM9BHpfNGn
         4HrRE5DQo2UN+sFCRO1kaYNe+JjywFYxlwQQK1Wnwwp+9Z2mBmyzmz+MqZXc1Ud8HP
         yxClAvCyAJbjPnUZU0qJwNxVJQQ/XqsaXaD3L2hI6MGtVOQvp94p0U1XCWpIumKZTc
         WZs+ctCS0ua7jfqI9+6TaxlvjiZqDPyKPInqMDvGHfmbXSy1hvFH+IPfJ1+U0B+R7B
         nMmkGl6Qp+v0FLAVIzmU8G//9VENAo/exOFbkdD6b74NOA22tTV/dei4mxPb6NOTpR
         hJgY46AzbgqQg==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10011801.me.com (Postfix) with ESMTPSA id C46E4800211;
        Fri, 27 May 2022 05:54:42 +0000 (UTC)
Message-ID: <aff94898-3642-99c4-e640-39139214dbc7@icloud.com>
Date:   Fri, 27 May 2022 13:54:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slot
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-27_01:2022-05-25,2022-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205270029
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Xiaoguang,

On 5/26/22 20:38, Xiaoguang Wang wrote:
> One big issue with file registration feature is that it needs user
> space apps to maintain free slot info about io_uring's fixed file
> table, which really is a burden for development. Now since io_uring
> starts to choose free file slot for user space apps by using
> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
> need app to uses direct accept or direct open, which as far as I know,
> some apps are not prepared to use direct accept or open yet.
> 
> To support apps, who still need real fds, use registration feature
> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slot,
> which will return free file slot in cqe->res.
> 
> TODO list:
>      Need to prepare liburing corresponding helpers.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   fs/io_uring.c                 | 50 ++++++++++++++++++++++++++++++++++---------
>   include/uapi/linux/io_uring.h |  1 +
>   2 files changed, 41 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9f1c682d7caf..d77e6bbec81c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -680,6 +680,7 @@ struct io_rsrc_update {
>   	u64				arg;
>   	u32				nr_args;
>   	u32				offset;
> +	u32				flags;
>   };
>   
>   struct io_fadvise {
> @@ -7970,14 +7971,23 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>   	return 0;
>   }
>   
> +#define IORING_FILES_UPDATE_INDEX_ALLOC 1
> +
>   static int io_rsrc_update_prep(struct io_kiocb *req,
>   				const struct io_uring_sqe *sqe)
>   {
> +	u32 flags = READ_ONCE(sqe->files_update_flags);
> +
>   	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>   		return -EINVAL;
> -	if (sqe->rw_flags || sqe->splice_fd_in)
> +	if (sqe->splice_fd_in)
> +		return -EINVAL;
> +	if (flags & ~IORING_FILES_UPDATE_INDEX_ALLOC)
> +		return -EINVAL;
> +	if ((flags & IORING_FILES_UPDATE_INDEX_ALLOC) && READ_ONCE(sqe->len) != 1)

How about allowing multiple fd update in IORING_FILES_UPDATE_INDEX_ALLOC
case? For example, using the sqe->addr(the fd array) to store the slots 
we allocated, and let cqe return the number of slots allocated.
By the way, another way, we can levarage up->offset == 
IORING_FILE_INDEX_ALLOC
to do the mode check since seems it is not used in this mode. Though
I'm not sure that is better..

>   		return -EINVAL;
>   
> +	req->rsrc_update.flags = flags;
>   	req->rsrc_update.offset = READ_ONCE(sqe->off);
>   	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
>   	if (!req->rsrc_update.nr_args)
> @@ -7990,18 +8000,38 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_uring_rsrc_update2 up;
> +	struct file *file;
>   	int ret;
>   
> -	up.offset = req->rsrc_update.offset;
> -	up.data = req->rsrc_update.arg;
> -	up.nr = 0;
> -	up.tags = 0;
> -	up.resv = 0;
> -	up.resv2 = 0;
> +	if (req->rsrc_update.flags & IORING_FILES_UPDATE_INDEX_ALLOC) {
> +		int fd;
>   
> -	io_ring_submit_lock(ctx, issue_flags);
> -	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
> -					&up, req->rsrc_update.nr_args);
> +		if (copy_from_user(&fd, (int *)req->rsrc_update.arg, sizeof(fd))) {

                                           ^ (void __user *) ?

Regards,
Hao
