Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085937590B9
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 10:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjGSI4k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 04:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjGSI4k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 04:56:40 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E979136
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 01:56:38 -0700 (PDT)
Message-ID: <f54d62e4-2ae4-5882-6107-71578a7f5c8f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689756996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSA3F0uwCrJT24jM27htYOUi2fwt3Zqxz5cpMu6P9FE=;
        b=KHc2qGBnqraA9xOqe1F0GHjOD9gaH9DFfKkdAMfHD/xTx1WWzqu/8cWe6sWA9B1RXnJa+K
        9s4avczldHqJua1j4wnpmlmuuK43rwg0KOpW98ciJmu+fPPMo3orAqMNCYTR5PWrQd4vo8
        cnacSJTQ5ecvneJ144Jatnjzby0HWqw=
Date:   Wed, 19 Jul 2023 16:56:25 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
In-Reply-To: <20230718132112.461218-4-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/23 21:21, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This add support for getdents64 to io_uring, acting exactly like the
> syscall: the directory is iterated from it's current's position as
> stored in the file struct, and the file's position is updated exactly as
> if getdents64 had been called.
> 
> For filesystems that support NOWAIT in iterate_shared(), try to use it
> first; if a user already knows the filesystem they use do not support
> nowait they can force async through IOSQE_ASYNC in the sqe flags,
> avoiding the need to bounce back through a useless EAGAIN return.
> 
> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   include/uapi/linux/io_uring.h |  7 +++++
>   io_uring/fs.c                 | 55 +++++++++++++++++++++++++++++++++++
>   io_uring/fs.h                 |  3 ++
>   io_uring/opdef.c              |  8 +++++
>   4 files changed, 73 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 36f9c73082de..b200b2600622 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -65,6 +65,7 @@ struct io_uring_sqe {
>   		__u32		xattr_flags;
>   		__u32		msg_ring_flags;
>   		__u32		uring_cmd_flags;
> +		__u32		getdents_flags;

Looks this is not needed anymore, I'll remove this in next version.

>   	};
>   	__u64	user_data;	/* data to be passed back at completion time */
>   	/* pack this to avoid bogus arm OABI complaints */
> @@ -235,6 +236,7 @@ enum io_uring_op {
>   	IORING_OP_URING_CMD,
>   	IORING_OP_SEND_ZC,
>   	IORING_OP_SENDMSG_ZC,
> +	IORING_OP_GETDENTS,
>   
>   	/* this goes last, obviously */
>   	IORING_OP_LAST,
> @@ -273,6 +275,11 @@ enum io_uring_op {
>    */
>   #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
>   
> +/*
> + * sqe->getdents_flags
> + */
> +#define IORING_GETDENTS_REWIND	(1U << 0)

ditto

> +
>   /*
>    * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
>    * command flags for POLL_ADD are stored in sqe->len.
> diff --git a/io_uring/fs.c b/io_uring/fs.c
> index f6a69a549fd4..480f25677fed 100644
> --- a/io_uring/fs.c
> +++ b/io_uring/fs.c
> @@ -47,6 +47,13 @@ struct io_link {
>   	int				flags;
>   };
>   
> +struct io_getdents {
> +	struct file			*file;
> +	struct linux_dirent64 __user	*dirent;
> +	unsigned int			count;
> +	int				flags;

ditto

