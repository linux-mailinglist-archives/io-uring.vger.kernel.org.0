Return-Path: <io-uring+bounces-272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4AC80AF5E
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 23:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 614F41C20A34
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 22:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF6D57891;
	Fri,  8 Dec 2023 22:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j3CizkzI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9874A1BD6
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 14:06:27 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6ce40061e99so413245b3a.0
        for <io-uring@vger.kernel.org>; Fri, 08 Dec 2023 14:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702073187; x=1702677987; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tMujdO0XLRqtk6bwbF/FTXyYRy7Zf/0WCx+iQnmnyIQ=;
        b=j3CizkzIhpTPMxSochR2tuYDZyPiGaWe3H4rB1N0YyHOKABMHuvAdsuOLaug2S0jp3
         g6ckukVbKusjI7hDwb1YYxPHNqRY+YGMWe62jalADnIIG/sLTDSq0qHPmtw7CNPHntmX
         apzCjOu98Capv6gbpwvYDZ5rPTOL3nxm70FBLjTikzSECpwchmK860x+RPz+XmXq9XVC
         +CzxDD6vblw7M/U18RFr5OWT/lJVOsbiwAkAEKNV/6Ye6loR+qn7Vad92Fx2gVW8WwE9
         9ND4r2Vq+nR/PbKquZIKG2kpClXotHogQqgDYbRPlX723LhR/VnO9OXzLJKn4KkSHm2A
         F96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702073187; x=1702677987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tMujdO0XLRqtk6bwbF/FTXyYRy7Zf/0WCx+iQnmnyIQ=;
        b=KInV7uttkMgyiR6W498w/A4i1igSQVXmMSSgy6SeZmFeFpoBBhJ/G4VhIiAZjlLj1G
         3tXjSYJbyN5MS5Mf8aADqv7dFJ9TagqvuQWaPbs53/FYf7gHpG66WNzgITFC9eg0ohhP
         YmXoQv0A1e6N/QWWHXuWhAjfCtkRTyGBxZZAW0C+nfx29Nvp126fK0XEecrIQC+SDyDK
         Zf3jxQAj3gOkHHu2kfuTRTH4V+VGbiLvCngk2isbx0Oils3VguC4KzWn08BpbyeA0qa8
         TjiPgyrVGU1yilgWxbmgbXCWg1dCVDdYj7eSpmyYX+9CNvmq3ecD4DohLkHYWxcIMt1A
         iEMQ==
X-Gm-Message-State: AOJu0YzINu9+A45MgU/rJfgRH/t8/HC7Y7IRhvrhVMSvtioBg4E93fY8
	xf8ZqT0rqeZjZfpkn6nse9q0MTv0WtKrqIC2S1DK5A==
X-Google-Smtp-Source: AGHT+IHfOMoRRnrlJFeB3v4scbEOkb7vqVuMIZaTyGBE0QFkYDxo2xPlFSj0gslizrv7LezXTxhJDA==
X-Received: by 2002:a05:6a21:789d:b0:18b:d26a:375c with SMTP id bf29-20020a056a21789d00b0018bd26a375cmr1517468pzc.1.1702073186795;
        Fri, 08 Dec 2023 14:06:26 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x20-20020a631714000000b0058988954686sm1969915pgl.90.2023.12.08.14.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 14:06:26 -0800 (PST)
Message-ID: <20e85938-21c6-4c93-a737-a3a4bfc75500@kernel.dk>
Date: Fri, 8 Dec 2023 15:06:25 -0700
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
 <0fb8b75c-e4cf-427b-bc30-a35d95585e1f@kernel.dk>
 <20231208-dreisatz-loyal-2db8f6e89158@brauner>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231208-dreisatz-loyal-2db8f6e89158@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/8/23 2:56 PM, Christian Brauner wrote:
> On Fri, Dec 08, 2023 at 02:49:37PM -0700, Jens Axboe wrote:
>> On 12/8/23 2:14 PM, Christian Brauner wrote:
>>> On Thu, Dec 07, 2023 at 08:11:45PM -0700, Jens Axboe wrote:
>>>> io_uring can currently open/close regular files or fixed/direct
>>>> descriptors. Or you can instantiate a fixed descriptor from a regular
>>>> one, and then close the regular descriptor. But you currently can't turn
>>>> a purely fixed/direct descriptor into a regular file descriptor.
>>>>
>>>> IORING_OP_FIXED_FD_INSTALL adds support for installing a direct
>>>> descriptor into the normal file table, just like receiving a file
>>>> descriptor or opening a new file would do. This is all nicely abstracted
>>>> into receive_fd(), and hence adding support for this is truly trivial.
>>>>
>>>> Since direct descriptors are only usable within io_uring itself, it can
>>>> be useful to turn them into real file descriptors if they ever need to
>>>> be accessed via normal syscalls. This can either be a transitory thing,
>>>> or just a permanent transition for a given direct descriptor.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>
>>> Would you mind giving me a Suggested-by?
>>
>> Sure, I can do that. I'll send out a v2, added a few comments and also
>> changed the flags location. But no real changes otherwise.
>>
>>> So this interesting. Usually we allow to receive fds if the task we're
>>> taking a reference to a file from:
>>>
>>> (1) is cooperating: SCM_RIGHTS
>>> (2) is the same task that's taking an addition reference: dup*(),
>>>     seccomp notify addfd
>>>
>>> Both cases ensure that the file->f_count == and fdtable->count == 1
>>> optimizations continue to work correctly in the regular system call
>>> fdget*() routines.
>>>
>>> I guess that this is a variant of (2). Effectively a dup*() from a
>>> private file table into the regular fdtable.
>>
>> Right.
>>
>>> So I just want to make sure we don't break this here because we broke
>>> that on accident before (pidfd_getfd()):
>>>
>>> A fixed file always has file->f_count == 1. The private io_uring fdtable
>>> is:
>>
>> It doesn't necessarily always have f_count of 1. One way to instantiate
>> a direct descriptor is to open the file normally, then register it. If
>> the task doesn't close the normal file descriptor, then it'd have an
>> elevated count of 2. But normally you'd expect the normal file to be
>> closed, or the file opened/instantiated as a direct descriptor upfront.
>> In that case, it should have a ref of 1.
> 
> Yes, of course. I was thinking of the two common cases:
> 
> (1) direct-to-fixed
> (2) open-regular-fd + egister-as-fixed + close-fd
> 
>>
>>> * shared between all io workers?
>>
>> Yep, they are just like threads in that sense and share the file table.
>>
>>> * accessible to all processes that have mapped the io_uring ring?
>>
>> The direct descriptors are just like a file_table, except it's private
>> to the ring itself. If you can invoke io_uring_enter(2) on that ring,
>> then you have access to that direct descriptor table.
>>
>>> And fixed files can only be used from within io_uring itself.
>>
>> Correct, the index only makes sense within a specific ring.
>>
>>> So multiple caller might issue fixed file rquests to different io
>>> workers for concurrent operations. The file->f_count stays at 1 for all
>>> of them. Someone now requests a regular fd for that fixed file.
>>>
>>> So now an fixed-to-fd requests comes in. The file->f_count is bumped > 1
>>> and that fd is installed into the fdtable of the caller through one of
>>> the io worker threads spawned for that caller?
>>
>> No worker thread is involved for this, unless you asked for that by eg
>> setting IOSQE_ASYNC in the sqe before it is submitted. The default would
> 
> But it is possible, that's what I wondered. But that's ok because the io
> worker is just like a regular thread of that process.

It's certainly possible, you are correct. It's just not the default.

>>>> +int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>> +{
>>>> +	struct io_fixed_install *ifi;
>>>> +
>>>> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index ||
>>>> +	    sqe->splice_fd_in || sqe->addr3)
>>>> +		return -EINVAL;
>>>> +
>>>> +	/* must be a fixed file */
>>>> +	if (!(req->flags & REQ_F_FIXED_FILE))
>>>> +		return -EBADF;
>>>> +
>>>> +	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
>>>> +
>>>> +	/* really just O_CLOEXEC or not */
>>>> +	ifi->flags = READ_ONCE(sqe->install_fd_flags);
>>>
>>> I'm a big big fan of having all new fd returning apis return their fds
>>> O_CLOEXEC by default and forcing userspace to explicitly turn this off
>>> via fcntl(). pidfds are cloexec by default, so are seccomp notifier fds.
>>
>> io_uring fd itself is also O_CLOEXEC by default. We can certainly make
>> this tweak here, but it is directly configurable by the task that issues
>> the sqe. If you want O_CLOEXEC, then you should set it.
>>
>> That said, not opposed to making this the default. But it does mean I'd
>> have to define a private opcode flag for this, so it can be turned off.
>> At least that seems saner than needing to do fcntl() after the fact.
>> This isn't a huge issue and we can certainly do that. Let me know what
>> you prefer!
> 
> Meh, new opcode would suck. Don't deviate from the standard apis then.

Not a new opcode, it'd just be a flag for that opcode. We default to
O_CLOEXEC is nothing is given, and you can do:

io_uring_prep_fixed_fd_install(sqe, fixed_index, IORING_FIXED_FD_NO_CLOEXEC);

to simply set that flag to turn it off. Only reason I bring it up as a
bit annoying is that it'd be cleaner to have it be part of the O_*
namespace as O_NOCLOEXEC, but it's not a huge deal.

It retains the part you cared about, which is making O_CLOEXEC the
default, but retains the option of turning it off rather than needing to
do an fcntl() to retrieve flags, mask it, then another fcntl().

-- 
Jens Axboe


