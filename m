Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2462D4568FA
	for <lists+io-uring@lfdr.de>; Fri, 19 Nov 2021 05:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhKSES3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 23:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbhKSES2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 23:18:28 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2106C061574;
        Thu, 18 Nov 2021 20:15:27 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id n26so8246065pff.3;
        Thu, 18 Nov 2021 20:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+LyeVLReCXhOkCg9StyRIKEvqQSOt6DNYKzR7HZ5mCg=;
        b=iCJO/iz/rDyVbJPs/seRcT6ZmQ/Tb1jbxmUqpeOCKS9csioYKAK/rBqp+0sNbQ9nMb
         aLvyNs7lbRLBuW0x+hFOrIkMwZWLZvxbm6jQbfcXRZVGiwRhleuIP7eXTQH4zfkY6N7y
         ictgFn6nYwvpheGTiguS8oF+xyaTIfzJjyXDd6pYtk0+Q4PNWb7rv5LOCtfGBoyVhG3s
         U8wFP9w5Zdt3w3q0nTxcndv+HhXERbHwYv+Dbg8uEJnIRhetIQHZFTC4s8uV3XWRR8Oj
         aZQ5XmzFB6RbJdESC2ya7wCwlfHvI6HnoU3NQpH2ILxFCJ3or9oMzZcCUwd3Z4OzM2Bc
         i6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+LyeVLReCXhOkCg9StyRIKEvqQSOt6DNYKzR7HZ5mCg=;
        b=BYEEq+IyGIiOT8MlI7pf5caei5JIxCWi6N7H2uViecl/eA36G4oirOSgBAyynY4Yuy
         WYp8FFL95mDFkUJPsiHcAN0oToTjZvJt5MKMi5EqAq3WnxUxznpy7XqxE7USH4i8ywiN
         YJZPqpeO67VnjIKycON/qoet8stXwnvLHnkV+fC/wBk59AWolE9nk1LYzqVHv0lk06+V
         HX+DSIJJaaDBFsUV/ADl6mGISQ4RUyqcJYQbDl9Bkgp4TMIdYWA61fIGJgKpkBX32IZe
         RtunrXTPm4VBJ9QzYafQMoNc7JNna55lTXfmBNh57OmD9CLBcqeL09aXB6+pxTMsxqIk
         mCug==
X-Gm-Message-State: AOAM533XmdyZqTLgPqFzjM9Gn/THt0qmmAw40FLbMi8xgyaBZhaI9b+w
        xVUqm3osfl65FhBGBobxVfk=
X-Google-Smtp-Source: ABdhPJzhurUP8Eg2zT+C/ZkePeYGNkk15ElzCLiHH124JYg1DvJU7WfZwpPFwxh5/LycdQIJiyJwiQ==
X-Received: by 2002:a63:2317:: with SMTP id j23mr14906844pgj.41.1637295327027;
        Thu, 18 Nov 2021 20:15:27 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id h128sm1058174pfg.212.2021.11.18.20.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 20:15:26 -0800 (PST)
Date:   Fri, 19 Nov 2021 09:45:23 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211119041523.cf427s3hzj75f7jr@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
 <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 19, 2021 at 03:32:26AM IST, Alexei Starovoitov wrote:
> On Tue, Nov 16, 2021 at 11:12:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> > This change adds eBPF iterator for buffers registered in io_uring ctx.
> > It gives access to the ctx, the index of the registered buffer, and a
> > pointer to the io_uring_ubuf itself. This allows the iterator to save
> > info related to buffers added to an io_uring instance, that isn't easy
> > to export using the fdinfo interface (like exact struct page composing
> > the registered buffer).
> >
> > The primary usecase this is enabling is checkpoint/restore support.
> >
> > Note that we need to use mutex_trylock when the file is read from, in
> > seq_start functions, as the order of lock taken is opposite of what it
> > would be when io_uring operation reads the same file.  We take
> > seq_file->lock, then ctx->uring_lock, while io_uring would first take
> > ctx->uring_lock and then seq_file->lock for the same ctx.
> >
> > This can lead to a deadlock scenario described below:
> >
> >       CPU 0				CPU 1
> >
> >       vfs_read
> >       mutex_lock(&seq_file->lock)	io_read
> > 					mutex_lock(&ctx->uring_lock)
> >       mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
> > 					mutex_lock(&seq_file->lock)
> >
> > The trylock also protects the case where io_uring tries to read from
> > iterator attached to itself (same ctx), where the order of locks would
> > be:
> >  io_uring_enter
> >   mutex_lock(&ctx->uring_lock) <-----------.
> >   io_read				    \
> >    seq_read				     \
> >     mutex_lock(&seq_file->lock)		     /
> >     mutex_lock(&ctx->uring_lock) # deadlock-`
> >
> > In both these cases (recursive read and contended uring_lock), -EDEADLK
> > is returned to userspace.
> >
> > In the future, this iterator will be extended to directly support
> > iteration of bvec Flexible Array Member, so that when there is no
> > corresponding VMA that maps to the registered buffer (e.g. if VMA is
> > destroyed after pinning pages), we are able to reconstruct the
> > registration on restore by dumping the page contents and then replaying
> > them into a temporary mapping used for registration later. All this is
> > out of scope for the current series however, but builds upon this
> > iterator.
>
> From BPF infra perspective these new iterators fit very well and
> I don't see any issues maintaining this interface while kernel keeps
> changing, but this commit log and shallowness of the selftests
> makes me question feasibility of this approach in particular with io_uring.
> Is it even possible to scan all internal bits of io_uring and reconstruct
> it later? The bpf iter is only the read part. Don't you need the write part
> for CRIU ? Even for reads only... io_uring has complex inner state.

Yes, the inner state is complex and often entangled with other task attributes,
like credentials, mm, file descriptors, other io_uring fds (wq_fd, etc.) but for
now these iterators are a good starting point to implement the majority of the
missing features in CRIU userspace. These iterators (including task* ones), and
procfs allow us to collect enough state to correlate various resources and form
relationships (e.g. which fd or buffer of which task(s) is registered, which
io_uring was used for wq_fd registration, or which eventfd was registered,
etc.). Thanks to access to io_ring_ctx, and iter being a tracing prog, we can
do usual pointer access to read some of that data.

> Like bpf itself which cannot be realistically CRIU-ed.
> I don't think we can merge this in pieces. We need to wait until there is
> full working CRIU framework that uses these new iterators.

I don't intend to add a 'write' framework. The usual process with CRIU is to
gather enough state to reconstruct the kernel resource by repeating steps
similar to what it might have performed during it's lifetime, e.g. approximating
a trace of execution leading to the same task state and then repeating that on
restore.

While a 'write' framework with first class kernel support for checkpoint/restore
would actually make CRIU's life a lot more simpler, there usually has been a lot
of pushback against interfaces like that, hence the approach has been to add
features that can extract the relevant information out of the kernel, and do the
rest of the work in userspace.

E.g. if we find that fd 1 and 2 are registered in the io_uring, and buffer at
0xabcd with len 128, then we first restore fd 1 and 2 (which can be anything)
at restore time, then after this restore is complete, continue restoration of
io_uring by executing file registration step for both [0], and depending on if
the mapping existed for 0xabcd in task mm, restore buffer once the mm of the
task has been restored, or otherwise map a temporary buffer, replay data, and
register it and destroy mappings. This would be similar to what might have
happened in the task itself. The correct order of events to do the restore
will be managed by CRIU itself.

It doesn't have to be exactly the same stpes, just enough for the task to not
notice a difference and not break its assumptions, and lead to the same end
result of task and resource state.

Even the task of determining whether fd 1 and 2 belong to which fdtable is
non-trivial and ineffecient rn. You can look at [0] for a similar case that was
solved for epoll, which works but we can do better (BPF didn't exist at that
time so it was the best we could do back then).

Also, this work is part of GSoC. There is already code that is waiting for this
to fill in the missing pieces [0]. If you want me to add a sample/selftest that
demonstrates/tests how this can be used to reconstruct a task's io_uring, I can
certainly do that. We've already spent a few months contemplating on a few
approaches and this turned out to be the best/most powerful. At one point I had
to scrap some my earlier patches completely because they couldn't work with
descriptorless io_uring. Iterator seem like the best solution so far that can
adapt gracefully to feature additions in something seeing as heavy development
as io_uring.

  [0]: https://github.com/checkpoint-restore/criu/commit/cfa3f405d522334076fc4d687bd077bee3186ccf#diff-d2cfa5a05213c854d539de003a23a286311ae81431026d3d50b0068c0cb5a852
  [1]: https://github.com/checkpoint-restore/criu/pull/1597

--
Kartikeya
