Return-Path: <io-uring+bounces-270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A9380AEF6
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 22:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A97C61C20A17
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 21:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569695788B;
	Fri,  8 Dec 2023 21:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="254P9h9U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6389F
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 13:49:40 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-286bbaa517eso625705a91.0
        for <io-uring@vger.kernel.org>; Fri, 08 Dec 2023 13:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702072179; x=1702676979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0R+Ym4EmTPiOAouNW0D5FpTMr02Y5v/PujyL/9Ga9PY=;
        b=254P9h9UqshjhouRYTkg0Ti34naaQfDMg2lpw44VEbgWQct0f6HumuNT+I7lPh0XGB
         B6aB2plZcHcbgfJm8RpCPIeeFInykLjvAOpCYANkha+Ue/k6Xf589E4XYAs+IL/nrd3g
         jgRWsjnlGpfNtVFno7pEsCXntFPGIXeI+7vbYtzhwxv1eM9GD533DKpk8P4pykaIKQ8l
         CWw/7h2GzakFuxNGBn8Xtj6Ms90a260q/CsE8QitmwmZD8koAURPFT1WKseopTFipFxR
         qvqLVtJP0Xhc026tI9bahnw0uiDblBlZQ4WWwRNABBCgYqvnuPVlqc8e/8IUaU2XkDUR
         vISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702072179; x=1702676979;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0R+Ym4EmTPiOAouNW0D5FpTMr02Y5v/PujyL/9Ga9PY=;
        b=gHxiESRQZ2WjOaqQyLaOLRlvRujhODoPnQISBkdUC7uZv8uToJqlps3H2irH6CHZQP
         1BAB3+sKo+cWnCZJ3GWcEGqlzBstqwecrzlpKr02EwVOXQ/9p69RwBEET+5xKp26G+Os
         ajZTsjNhFgA4fJ6+FieRlJceWpA9VTkMCKgqkdMMWPizg/JajX3KmxojbmHXOeKLlvtc
         dtLaHwecHyN/M/4gaEo9jZAkNdsvFG+5tLykV5aS+Mx/E8vUQXRTW58wzKf+T88i+h3S
         rmWLstEXRzR7WTTGLmHNqbmU378SX13JRNABGCeDhQEWRLyOEs/i3+ucOrvInxsht4f/
         DiSQ==
X-Gm-Message-State: AOJu0YzzDgU2jFoc0auRipjhBU6kWC+ZxHp0wbDF1qNNzyaONOe4jajW
	xM4Wm5siC9eCewWEDjjzSpmQD3P30uYHcjNv/r31Ag==
X-Google-Smtp-Source: AGHT+IGNW0eTsYKETAeYZXkdXhmmzsc3LEIb18K2lKuiZ2KjGQp0yZTM3btQtm8l3lzh89Ftan7Fng==
X-Received: by 2002:a17:90a:9905:b0:286:7cc2:4c15 with SMTP id b5-20020a17090a990500b002867cc24c15mr1487932pjp.0.1702072179286;
        Fri, 08 Dec 2023 13:49:39 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id me17-20020a17090b17d100b0028a01156d24sm2265638pjb.49.2023.12.08.13.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 13:49:38 -0800 (PST)
Message-ID: <0fb8b75c-e4cf-427b-bc30-a35d95585e1f@kernel.dk>
Date: Fri, 8 Dec 2023 14:49:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/openclose: add support for
 IORING_OP_FIXED_FD_INSTALL
Content-Language: en-US
To: Christian Brauner <brauner@kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>
 <20231208-leihwagen-losen-e751332ab864@brauner>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231208-leihwagen-losen-e751332ab864@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/8/23 2:14 PM, Christian Brauner wrote:
> On Thu, Dec 07, 2023 at 08:11:45PM -0700, Jens Axboe wrote:
>> io_uring can currently open/close regular files or fixed/direct
>> descriptors. Or you can instantiate a fixed descriptor from a regular
>> one, and then close the regular descriptor. But you currently can't turn
>> a purely fixed/direct descriptor into a regular file descriptor.
>>
>> IORING_OP_FIXED_FD_INSTALL adds support for installing a direct
>> descriptor into the normal file table, just like receiving a file
>> descriptor or opening a new file would do. This is all nicely abstracted
>> into receive_fd(), and hence adding support for this is truly trivial.
>>
>> Since direct descriptors are only usable within io_uring itself, it can
>> be useful to turn them into real file descriptors if they ever need to
>> be accessed via normal syscalls. This can either be a transitory thing,
>> or just a permanent transition for a given direct descriptor.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> 
> Would you mind giving me a Suggested-by?

Sure, I can do that. I'll send out a v2, added a few comments and also
changed the flags location. But no real changes otherwise.

> So this interesting. Usually we allow to receive fds if the task we're
> taking a reference to a file from:
> 
> (1) is cooperating: SCM_RIGHTS
> (2) is the same task that's taking an addition reference: dup*(),
>     seccomp notify addfd
> 
> Both cases ensure that the file->f_count == and fdtable->count == 1
> optimizations continue to work correctly in the regular system call
> fdget*() routines.
> 
> I guess that this is a variant of (2). Effectively a dup*() from a
> private file table into the regular fdtable.

Right.

> So I just want to make sure we don't break this here because we broke
> that on accident before (pidfd_getfd()):
> 
> A fixed file always has file->f_count == 1. The private io_uring fdtable
> is:

It doesn't necessarily always have f_count of 1. One way to instantiate
a direct descriptor is to open the file normally, then register it. If
the task doesn't close the normal file descriptor, then it'd have an
elevated count of 2. But normally you'd expect the normal file to be
closed, or the file opened/instantiated as a direct descriptor upfront.
In that case, it should have a ref of 1.

> * shared between all io workers?

Yep, they are just like threads in that sense and share the file table.

> * accessible to all processes that have mapped the io_uring ring?

The direct descriptors are just like a file_table, except it's private
to the ring itself. If you can invoke io_uring_enter(2) on that ring,
then you have access to that direct descriptor table.

> And fixed files can only be used from within io_uring itself.

Correct, the index only makes sense within a specific ring.

> So multiple caller might issue fixed file rquests to different io
> workers for concurrent operations. The file->f_count stays at 1 for all
> of them. Someone now requests a regular fd for that fixed file.
> 
> So now an fixed-to-fd requests comes in. The file->f_count is bumped > 1
> and that fd is installed into the fdtable of the caller through one of
> the io worker threads spawned for that caller?

No worker thread is involved for this, unless you asked for that by eg
setting IOSQE_ASYNC in the sqe before it is submitted. The default would
be that the task that does io_uring_enter(2) and submits that sqe would
be the one that installs the file X with direct descriptor Y into its
normal file table.

> Assume caller now issues a readdir() operation on that fd. file->f_count
> will be > 1 for as long as it's used as a fixed file. So regular system
> call fdget*() locking rules should work even with that new extension
> added.
> 
> I think that's sound.

Right, I don't think this changes fget/fdget rules.

> But I want to share some doubts as well. I think the concept of fixed
> files is pretty neat. But it poses a new semantic challenge to
> userspace.
> 
> io_uring_setup() gives you an fd back that you use to mmap() the
> io_uring. You make that io_uring_setup() fd a fixed file. You close the
> regular fd but now the io_uring instance stays around. You create and
> register a bunch of fixed files.
> 
> So now you've set up an io_uring instance that is completely made up of
> fixed files including the io_uring file itself.
> 
> So a process that assumes that once it has closed all fds in its fdtable
> of all threads that all resources have been released.
> 
> But that's not true now. At least for some pretty obvious cases such as
> filesystems. For example, io_uring could just pin random filesystems in
> there. Say it holds open a file in a btrfs mount and the service
> manager having closed all fds now tries unmount it and fails
> inexplicably.
> 
> So effectively, fixed files let you completely hide files and that's
> potentially a problem. So cool idea but this might cause us some trouble
> later down the road.

That is true, you'd have to explicitly or implicitly cancel (this
happens at exec time too, for example) requests and then unregister the
fixed files to release those resources. Or teardown the ring, which
would do both. Or just not close the ring fd itself even if it's
registered, then it would continue to reside in the normal file table as
well.

> Reviewed-by: Christian Brauner <brauner@kernel.org>

Thanks!

> Two comments below.
> 
>>  include/uapi/linux/io_uring.h |  2 ++
>>  io_uring/opdef.c              |  9 +++++++++
>>  io_uring/openclose.c          | 37 +++++++++++++++++++++++++++++++++++
>>  io_uring/openclose.h          |  3 +++
>>  4 files changed, 51 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index f1c16f817742..af82aab9e632 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -71,6 +71,7 @@ struct io_uring_sqe {
>>  		__u32		uring_cmd_flags;
>>  		__u32		waitid_flags;
>>  		__u32		futex_flags;
>> +		__u32		install_fd_flags;
>>  	};
>>  	__u64	user_data;	/* data to be passed back at completion time */
>>  	/* pack this to avoid bogus arm OABI complaints */
>> @@ -253,6 +254,7 @@ enum io_uring_op {
>>  	IORING_OP_FUTEX_WAIT,
>>  	IORING_OP_FUTEX_WAKE,
>>  	IORING_OP_FUTEX_WAITV,
>> +	IORING_OP_FIXED_FD_INSTALL,
>>  
>>  	/* this goes last, obviously */
>>  	IORING_OP_LAST,
>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>> index 799db44283c7..6705634e5f52 100644
>> --- a/io_uring/opdef.c
>> +++ b/io_uring/opdef.c
>> @@ -469,6 +469,12 @@ const struct io_issue_def io_issue_defs[] = {
>>  		.prep			= io_eopnotsupp_prep,
>>  #endif
>>  	},
>> +	[IORING_OP_FIXED_FD_INSTALL] = {
>> +		.needs_file		= 1,
>> +		.audit_skip		= 1,
>> +		.prep			= io_install_fixed_fd_prep,
>> +		.issue			= io_install_fixed_fd,
>> +	},
>>  };
>>  
>>  const struct io_cold_def io_cold_defs[] = {
>> @@ -704,6 +710,9 @@ const struct io_cold_def io_cold_defs[] = {
>>  	[IORING_OP_FUTEX_WAITV] = {
>>  		.name			= "FUTEX_WAITV",
>>  	},
>> +	[IORING_OP_FIXED_FD_INSTALL] = {
>> +		.name			= "FIXED_FD_INSTALL",
>> +	},
>>  };
>>  
>>  const char *io_uring_get_opcode(u8 opcode)
>> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
>> index fb73adb89067..5b8f79edef26 100644
>> --- a/io_uring/openclose.c
>> +++ b/io_uring/openclose.c
>> @@ -31,6 +31,11 @@ struct io_close {
>>  	u32				file_slot;
>>  };
>>  
>> +struct io_fixed_install {
>> +	struct file			*file;
>> +	int				flags;
>> +};
>> +
>>  static bool io_openat_force_async(struct io_open *open)
>>  {
>>  	/*
>> @@ -254,3 +259,35 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>  	io_req_set_res(req, ret, 0);
>>  	return IOU_OK;
>>  }
>> +
>> +int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_fixed_install *ifi;
>> +
>> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index ||
>> +	    sqe->splice_fd_in || sqe->addr3)
>> +		return -EINVAL;
>> +
>> +	/* must be a fixed file */
>> +	if (!(req->flags & REQ_F_FIXED_FILE))
>> +		return -EBADF;
>> +
>> +	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
>> +
>> +	/* really just O_CLOEXEC or not */
>> +	ifi->flags = READ_ONCE(sqe->install_fd_flags);
> 
> I'm a big big fan of having all new fd returning apis return their fds
> O_CLOEXEC by default and forcing userspace to explicitly turn this off
> via fcntl(). pidfds are cloexec by default, so are seccomp notifier fds.

io_uring fd itself is also O_CLOEXEC by default. We can certainly make
this tweak here, but it is directly configurable by the task that issues
the sqe. If you want O_CLOEXEC, then you should set it.

That said, not opposed to making this the default. But it does mean I'd
have to define a private opcode flag for this, so it can be turned off.
At least that seems saner than needing to do fcntl() after the fact.
This isn't a huge issue and we can certainly do that. Let me know what
you prefer!

>> +	return 0;
>> +}
>> +
>> +int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_fixed_install *ifi;
>> +	int ret;
>> +
>> +	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
>> +	ret = receive_fd(req->file, ifi->flags);
> 
> After changes currently in vfs.misc the helper is now:
> 
> receive_fd(req->file, NULL, ifi->flags)
> 
> So fyi, this will cause a build failure in -next.

Ah, I should probably pull that in first then. Thanks for the headsup.

-- 
Jens Axboe


