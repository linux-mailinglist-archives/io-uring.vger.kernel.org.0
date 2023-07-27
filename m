Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76C87652EC
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 13:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbjG0Lvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 07:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjG0Lvb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 07:51:31 -0400
Received: from out-112.mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084D3F0
        for <io-uring@vger.kernel.org>; Thu, 27 Jul 2023 04:51:29 -0700 (PDT)
Message-ID: <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690458688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Yni0EJj+zEaJeDTghJbjRODqO2gNsRTL+MQ6cAOYB0=;
        b=avGJ1mJpFDglbYecvlpqojv2Q2lOfcEVaU403Hyqg7hYe4g/Q8V+T1oJ0p9+nTe8xaLrnK
        wdsxvj16DRLEgO2Vj6fZQBkuMb0cOOcF8bpVOxBLZ1gWfuzPl9skadto2o7sbzlFC9GYlc
        gXmrLxUVJtYUNSFXbDBfTL9HQ/hpLtw=
Date:   Thu, 27 Jul 2023 19:51:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20230726-leinen-basisarbeit-13ae322690ff@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/23 23:00, Christian Brauner wrote:
> On Tue, Jul 18, 2023 at 09:21:10PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> This add support for getdents64 to io_uring, acting exactly like the
>> syscall: the directory is iterated from it's current's position as
>> stored in the file struct, and the file's position is updated exactly as
>> if getdents64 had been called.
>>
>> For filesystems that support NOWAIT in iterate_shared(), try to use it
>> first; if a user already knows the filesystem they use do not support
>> nowait they can force async through IOSQE_ASYNC in the sqe flags,
>> avoiding the need to bounce back through a useless EAGAIN return.
>>
>> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   include/uapi/linux/io_uring.h |  7 +++++
>>   io_uring/fs.c                 | 55 +++++++++++++++++++++++++++++++++++
>>   io_uring/fs.h                 |  3 ++
>>   io_uring/opdef.c              |  8 +++++
>>   4 files changed, 73 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 36f9c73082de..b200b2600622 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -65,6 +65,7 @@ struct io_uring_sqe {
>>   		__u32		xattr_flags;
>>   		__u32		msg_ring_flags;
>>   		__u32		uring_cmd_flags;
>> +		__u32		getdents_flags;
>>   	};
>>   	__u64	user_data;	/* data to be passed back at completion time */
>>   	/* pack this to avoid bogus arm OABI complaints */
>> @@ -235,6 +236,7 @@ enum io_uring_op {
>>   	IORING_OP_URING_CMD,
>>   	IORING_OP_SEND_ZC,
>>   	IORING_OP_SENDMSG_ZC,
>> +	IORING_OP_GETDENTS,
>>   
>>   	/* this goes last, obviously */
>>   	IORING_OP_LAST,
>> @@ -273,6 +275,11 @@ enum io_uring_op {
>>    */
>>   #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
>>   
>> +/*
>> + * sqe->getdents_flags
>> + */
>> +#define IORING_GETDENTS_REWIND	(1U << 0)
>> +
>>   /*
>>    * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
>>    * command flags for POLL_ADD are stored in sqe->len.
>> diff --git a/io_uring/fs.c b/io_uring/fs.c
>> index f6a69a549fd4..480f25677fed 100644
>> --- a/io_uring/fs.c
>> +++ b/io_uring/fs.c
>> @@ -47,6 +47,13 @@ struct io_link {
>>   	int				flags;
>>   };
>>   
>> +struct io_getdents {
>> +	struct file			*file;
>> +	struct linux_dirent64 __user	*dirent;
>> +	unsigned int			count;
>> +	int				flags;
>> +};
>> +
>>   int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   {
>>   	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
>> @@ -291,3 +298,51 @@ void io_link_cleanup(struct io_kiocb *req)
>>   	putname(sl->oldpath);
>>   	putname(sl->newpath);
>>   }
>> +
>> +int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>> +
>> +	if (READ_ONCE(sqe->off) != 0)
>> +		return -EINVAL;
>> +
>> +	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	gd->count = READ_ONCE(sqe->len);
>> +
>> +	return 0;
>> +}
>> +
>> +int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>> +	struct file *file = req->file;
>> +	unsigned long getdents_flags = 0;
>> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> 
> Hm, I'm not sure what exactly the rules are for IO_URING_F_NONBLOCK.
> But to point this out:
> 
> vfs_getdents()
> -> iterate_dir()
>     {
>          if (shared)
>                  res = down_read_killable(&inode->i_rwsem);
>          else
>                  res = down_write_killable(&inode->i_rwsem);
>     }
> 
> which means you can still end up sleeping here before you go into a
> filesystem that does actually support non-waiting getdents. So if you
> have concurrent operations that grab inode lock (touch, mkdir etc) you
> can end up sleeping here.
> 
> Is that intentional or an oversight? If the former can someone please
> explain the rules and why it's fine in this case?

I actually saw this semaphore, and there is another xfs lock in
file_accessed
   --> touch_atime
     --> inode_update_time
       --> inode->i_op->update_time == xfs_vn_update_time

Forgot to point them out in the cover-letter..., I didn't modify them
since I'm not very sure about if we should do so, and I saw Stefan's
patchset didn't modify them too.

My personnal thinking is we should apply trylock logic for this
inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
doesn't make sense to rollback all the stuff while we are almost at the
end of getdents because of a lock.


> 
>> +	bool should_lock = file->f_mode & FMODE_ATOMIC_POS;
>> +	int ret;
>> +
>> +	if (force_nonblock) {
>> +		if (!(req->file->f_mode & FMODE_NOWAIT))
>> +			return -EAGAIN;
>> +
>> +		getdents_flags = DIR_CONTEXT_F_NOWAIT;
>> +	}
>> +
>> +	if (should_lock) {
>> +		if (!force_nonblock)
>> +			mutex_lock(&file->f_pos_lock);
>> +		else if (!mutex_trylock(&file->f_pos_lock))
>> +			return -EAGAIN;
>> +	}
> 
> That now looks like it works.
> 
>> +
>> +	ret = vfs_getdents(file, gd->dirent, gd->count, getdents_flags);
>> +	if (should_lock)
>> +		mutex_unlock(&file->f_pos_lock);

