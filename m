Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C525751CB5
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 11:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjGMJH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 05:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbjGMJGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 05:06:49 -0400
Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [IPv6:2001:41d0:203:375::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B112693
        for <io-uring@vger.kernel.org>; Thu, 13 Jul 2023 02:06:43 -0700 (PDT)
Message-ID: <da88054b-c972-f4d1-fbdc-c6e10a9c559b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689239201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aaPhNRTyydBFg3hL/0F5pvYqs2vxwP8RtS14i9gAUPw=;
        b=A65QKcAY6UJkxtMgdI2WOQWFgb2obSKda1INPBPXEKVAf00ho9J5h37Wj8cdxPFarpyDGP
        lQna/5RxfsDeI7wHrxC5WMRYD9qqyiqJGWhEh/DCDjQukJEWFJowzRBKt+Da9Up2U00zfh
        Xgd/fZFbvyYDjQamzNNs+THKxEPzqmg=
Date:   Thu, 13 Jul 2023 17:06:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-4-hao.xu@linux.dev>
 <20230712-alltag-abberufen-67a615152bee@brauner>
 <bb2aa872-c3fb-93f0-c0da-3a897f39347d@linux.dev>
 <20230713-sitzt-zudem-67bc5d860cb4@brauner>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20230713-sitzt-zudem-67bc5d860cb4@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Christian,

On 7/13/23 15:10, Christian Brauner wrote:
> On Thu, Jul 13, 2023 at 12:35:07PM +0800, Hao Xu wrote:
>> On 7/12/23 23:27, Christian Brauner wrote:
>>> On Tue, Jul 11, 2023 at 07:40:27PM +0800, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> This add support for getdents64 to io_uring, acting exactly like the
>>>> syscall: the directory is iterated from it's current's position as
>>>> stored in the file struct, and the file's position is updated exactly as
>>>> if getdents64 had been called.
>>>>
>>>> For filesystems that support NOWAIT in iterate_shared(), try to use it
>>>> first; if a user already knows the filesystem they use do not support
>>>> nowait they can force async through IOSQE_ASYNC in the sqe flags,
>>>> avoiding the need to bounce back through a useless EAGAIN return.
>>>>
>>>> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
>>>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>> ---
>>>>    include/uapi/linux/io_uring.h |  7 ++++
>>>>    io_uring/fs.c                 | 60 +++++++++++++++++++++++++++++++++++
>>>>    io_uring/fs.h                 |  3 ++
>>>>    io_uring/opdef.c              |  8 +++++
>>>>    4 files changed, 78 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 08720c7bd92f..6c0d521135a6 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -65,6 +65,7 @@ struct io_uring_sqe {
>>>>    		__u32		xattr_flags;
>>>>    		__u32		msg_ring_flags;
>>>>    		__u32		uring_cmd_flags;
>>>> +		__u32		getdents_flags;
>>>>    	};
>>>>    	__u64	user_data;	/* data to be passed back at completion time */
>>>>    	/* pack this to avoid bogus arm OABI complaints */
>>>> @@ -235,6 +236,7 @@ enum io_uring_op {
>>>>    	IORING_OP_URING_CMD,
>>>>    	IORING_OP_SEND_ZC,
>>>>    	IORING_OP_SENDMSG_ZC,
>>>> +	IORING_OP_GETDENTS,
>>>>    	/* this goes last, obviously */
>>>>    	IORING_OP_LAST,
>>>> @@ -273,6 +275,11 @@ enum io_uring_op {
>>>>     */
>>>>    #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
>>>> +/*
>>>> + * sqe->getdents_flags
>>>> + */
>>>> +#define IORING_GETDENTS_REWIND	(1U << 0)
>>>> +
>>>>    /*
>>>>     * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
>>>>     * command flags for POLL_ADD are stored in sqe->len.
>>>> diff --git a/io_uring/fs.c b/io_uring/fs.c
>>>> index f6a69a549fd4..77f00577e09c 100644
>>>> --- a/io_uring/fs.c
>>>> +++ b/io_uring/fs.c
>>>> @@ -47,6 +47,13 @@ struct io_link {
>>>>    	int				flags;
>>>>    };
>>>> +struct io_getdents {
>>>> +	struct file			*file;
>>>> +	struct linux_dirent64 __user	*dirent;
>>>> +	unsigned int			count;
>>>> +	int				flags;
>>>> +};
>>>> +
>>>>    int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>    {
>>>>    	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
>>>> @@ -291,3 +298,56 @@ void io_link_cleanup(struct io_kiocb *req)
>>>>    	putname(sl->oldpath);
>>>>    	putname(sl->newpath);
>>>>    }
>>>> +
>>>> +int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>> +{
>>>> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>>>> +
>>>> +	if (READ_ONCE(sqe->off) != 0)
>>>> +		return -EINVAL;
>>>> +
>>>> +	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>>> +	gd->count = READ_ONCE(sqe->len);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
>>>> +{
>>>> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>>>> +	struct file *file;
>>>> +	unsigned long getdents_flags = 0;
>>>> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>> +	bool should_lock = false;
>>>> +	int ret;
>>>> +
>>>> +	if (force_nonblock) {
>>>> +		if (!(req->file->f_mode & FMODE_NOWAIT))
>>>> +			return -EAGAIN;
>>>> +
>>>> +		getdents_flags = DIR_CONTEXT_F_NOWAIT;
>>>
>>> I mentioned this on the other patch but it seems really pointless to
>>> have that extra flag. I would really like to hear a good reason for
>>> this.
>>>
>>>> +	}
>>>> +
>>>> +	file = req->file;
>>>> +	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
>>>> +		if (file_count(file) > 1)
>>>
>>> Assume we have a regular non-threaded process that just opens an fd to a
>>> file. The process registers an async readdir request via that fd for the
>>> file with io_uring and goes to do other stuff while waiting for the
>>> result.
>>>
>>> Some time later, io_uring gets to io_getdents() and the task is still
>>> single threaded and the file hasn't been shared in the meantime. So
>>> io_getdents() doesn't take the lock and starts the readdir() call.
>>>
>>> Concurrently, the process that registered the io_uring request was free
>>> to do other stuff and issued a synchronous readdir() system call which
>>> calls fdget_pos(). Since the fdtable still isn't shared it doesn't
>>> increment f_count and doesn't acquire the mutex. Now there's another
>>> concurrent readdir() going on.
>>>
>>> (Similar thing can happen if the process creates a thread for example.)
>>>
>>> Two readdir() requests now proceed concurrently which is not intended.
>>> Now to verify that this race can't happen with io_uring:
>>>
>>> * regular fds:
>>>     It seems that io_uring calls fget() on each regular file descriptor
>>>     when an async request is registered. So that means that io_uring
>>>     always hold its own explicit reference here.
>>>     So as long as the original task is alive or another thread is alive
>>>     f_count is guaranteed to be > 1 and so the mutex would always be
>>>     acquired.
>>>
>>>     If the registering process dies right before io_uring gets to the
>>>     io_getdents() request no other process can steal the fd anymore and in
>>>     that case the readdir call would not lock. But that's fine.
>>>
>>> * fixed fds:
>>>     I don't know the reference counting rules here. io_uring would need to
>>>     ensure that it's impossible for two async readdir requests via a fixed
>>>     fd to race because f_count is == 1.
>>>
>>>     Iiuc, if a process registers a file it opened as a fixed file and
>>>     immediately closes the fd afterwards - without anyone else holding a
>>>     reference to that file - and only uses the fixed fd going forward, the
>>>     f_count of that file in io_uring's fixed file table is always 1.
>>>
>>>     So one could issue any number of concurrent readdir requests with no
>>>     mutual exclusion. So for fixed files there definitely is a race, no?
>>
>> Hi Christian,
>> The ref logic for fixed file is that it does fdget() when registering
> 
> It absolutely can't be the case that io_uring uses fdget()/fdput() for
> long-term file references. fdget() internally use __fget_light() which
> avoids taking a reference on the file if the file table isn't shared. So
> should that file be stashed anywhere for async work its a UAF waiting to
> happen.
> 

Yes, I typed the wrong name, should be fget() not fdget().

>> the file, and fdput() when unregistering it. So the ref in between is
>> always > 1. The fixed file feature is to reduce frequent fdget/fdput,
>> but it does call them at the register/unregister time.
> 
> So consider:
> 
> // Caller opens some file.
> fd_register = open("/some/file", ...); // f_count == 1
> 
> // Caller registers that file as a fixed file
> IORING_REGISTER_FILES
> -> io_sqe_files_register()
>     -> fget(fd_register) // f_count == 2
>     -> io_fixed_file_set()
> 
> // Caller trades regular fd reference for fixed file reference completely.
> close(fd_register);
> -> close_fd(fd_register)
>     -> file = pick_file()
>     -> filp_close(file)
>        -> fput(file)    // f_count == 1
> 
> 
> // Caller spawns a second thread. Both treads issue async getdents via
> // fixed file.
> T1                                              T2
> IORING_OP_GETDENTS                              IORING_OP_GETDENTS
> 
> // At some point io_assign_file() must be called which has:
> 
>            if (req->flags & REQ_F_FIXED_FILE)
>                    req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
>            else
>                    req->file = io_file_get_normal(req, req->cqe.fd);
> 
> // Since this is REQ_F_FIXED_FILE f_count == 1
> 
> if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
>          if (file_count(file) > 1)
> 
> // No lock is taken; T1 and T2 issue getdents concurrently without any
> // locking. -> race on f_pos
> 
> I'm happy to be convinced that this is safe, but please someone explain
> in detail why this can't happen and where that extra f_count reference
> for fixed files that this code wants to rely on is coming from.
> 
> Afaik, the whole point is that fixed files don't ever call fget()/fput()
> after having been registered anymore. Consequently, f_count should be 1
> once io_uring has taken full ownership of the file and the file can only
> be addressed via a fixed file reference.

Thanks for explanation, I now realize it's an issue, even for non-fixed 
files when io_uring takes full ownership. for example:

io_uring submit a getdents          --> f_count == 2, get the lock
nowait submission fails             --> f_count == 2, release the lock
punt it to io-wq thread and return to userspace
close(fd)                           --> f_count == 1
call sync getdents64                --> doing getdents without lock
the io-wq thread begins to run      --> f_count == 1, doing getdents
                                         without lock.

Though this looks like a silly use case but users can do that anyway.

How about remove this f_count > 1 small optimization in io_uring and 
always get the lock, looks like it makes big trouble for async
situation. and there may often be parallel io_uring getdents in the
same time for a file [1], it may be not very meaningful to do this
file count optimization.

[1] I believe users will issue multiple async getdents at same time 
rather than issue them one by one to get better performance.

Thanks,
Hao

> 
>>
>>
>>>
>>> All of that could ofc be simplified if we could just always acquire the
>>> mutex in fdget_pos() and other places and drop that file_count(file) > 1
>>> optimization everywhere. But I have no idea if the optimization for not
>>> acquiring the mutex if f_count == 1 is worth it?
>>>
>>> I hope I didn't confuse myself here.
>>>
>>> Jens, do yo have any input here?
>>>
>>>> +			should_lock = true;
>>>> +	}
>>>> +	if (should_lock) {
>>>> +		if (!force_nonblock)
>>>> +			mutex_lock(&file->f_pos_lock);
>>>> +		else if (!mutex_trylock(&file->f_pos_lock))
>>>> +			return -EAGAIN;
>>>> +	}
>>>
>>> Open-coding this seems extremely brittle with an invitation for subtle
>>> bugs.
>>
>> Could you elaborate on this, I'm not sure that I understand it quite
>> well. Sorry for my poor English.
> 
> No need to apologize. I'm wondering whether this should be moved into a
> tiny helper and actually be exposed via a vfs header if we go this
> route is all.


