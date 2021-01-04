Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F012E98F9
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 16:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbhADPim (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 10:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbhADPil (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 10:38:41 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8878BC061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 07:38:01 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id 2so25650379ilg.9
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 07:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jSwxP2rgl5F6hGGZY5XVxeI6ntSHWZK18HyuR+BlLSo=;
        b=xCvcgtkDd71Ef64oAkz3bu96gXFVJXUHDPjK9Xp1bc7k9gYFk39sOMnnbyHY25u9RM
         FmALdKjBGxlbbnTPtJNABRv7KsMq6RX19ns5IiaxI6MDWoFqzIVbAx0NH2882b7/Etvk
         i82lX7YaThIML5RT6VAn0zhsa7JI0SGKwW8tbfzoy4a0k/uGgQ+1gYza5ECpuNDtXXKM
         qPgeJnrFuAX+BYkh5/MxkD6lxlUx5bmlM2dlLDz48un48qKh+Asg39ATrs00MyBDsHxy
         DlvPkhir+0kiEfGpqeZe/37BKE/EFh8yrtEGEpbODlVnF3PuSR4wP3oYmxyWNoU6UPpW
         0+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jSwxP2rgl5F6hGGZY5XVxeI6ntSHWZK18HyuR+BlLSo=;
        b=iS5tc82m/nEqzM48Hh6qkfRYHQPI1M8sBVjj9xXXuN97XlLB3UapNWtUwyB0PT9Hrx
         KynLFWjsRZKIZ+Kz3lh83zPewF9NbQIQZ4FO60L/XB8xYAuLYjpUxL1bxDdff34A+M6G
         9rF1feGRruqpGHmwprk61G46prvdI6NS6/oAlEk+unPzy7tYjZPaiennKYhtN0dC0moJ
         7L9+g4LZjRIVAdeCahfZZ5mLIlRZmu0mDH2BDTDGk5KIetMAJp/RsH8OPQVnWNWJUv/s
         yNqf9EOcrP3R7oivoaXll6aU8KbHRJh/vzOi3wooQKW7l181KFUGEP8o1olmfK3L/Ix9
         g+wg==
X-Gm-Message-State: AOAM532ZXOBMOzzHRJO0HgwNL5cB/0XEAaRYQxUEU3Hv4mTQ5tett/GN
        8Upo19yMM6N7ynlmqTBbG6zFHU8/MaYdXg==
X-Google-Smtp-Source: ABdhPJz6Y5G8kebQK1am1sCM7mwb6tmQSf2iD6gwAh0eWcgAsbePKgY0xkbm37JqBa/BKvuis0yzwQ==
X-Received: by 2002:a05:6e02:ecc:: with SMTP id i12mr68539435ilk.0.1609774680662;
        Mon, 04 Jan 2021 07:38:00 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k5sm17380885ioa.27.2021.01.04.07.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 07:38:00 -0800 (PST)
Subject: Re: Questions regarding implementation of vmsplice in io_uring
From:   Jens Axboe <axboe@kernel.dk>
To:     arni@dagur.eu, io-uring@vger.kernel.org
Cc:     =?UTF-8?Q?=c3=81rni_Dagur?= <arnidg@protonmail.ch>
References: <20210103222117.905850-1-arni@dagur.eu>
 <76da2c1e-9f92-72c4-0303-8f4c38aa994b@kernel.dk>
Message-ID: <44a609bf-07cd-ac9f-3a38-fc1256428066@kernel.dk>
Date:   Mon, 4 Jan 2021 08:37:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <76da2c1e-9f92-72c4-0303-8f4c38aa994b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/21 8:21 AM, Jens Axboe wrote:
> On 1/3/21 3:22 PM, arni@dagur.eu wrote:
>> From: Árni Dagur <arnidg@protonmail.ch>
>>
>> Hello,
>>
>> For my first stab at kernel development, I wanted to try implementing
>> vmsplice for io_uring. I've attached the code I've written so far. I have two
>> questions to ask, sorry if this is not the right place.
>>
>> 1. Currently I use __import_iovec directly, instead of using
>> io_import_iovec. That's because I've created a new "kiocb" struct
>> called io_vmsplice, rather than using io_rw as io_import_iovec expects.
>> The reason I created a new struct is so that it can hold an unsigned int
>> for the flags argument -- which is not present in io_rw. Im guessing that I
>> should find a way to use io_import_iovec instead?
>>
>> One way I can think of is giving the io_vmsplice struct the same initial
>> fields as io_rw, and letting io_import_iovec access the union as io_rw rather
>> than io_vmsplice. Coming from a Rust background however, this solution
>> sounds like a bug waiting to happen (if one of the structs is changed
>> but the other is not).
>>
>> 2. Whenever I run the test program at
>> https://gist.githubusercontent.com/ArniDagur/07d87aefae93868ca1bf10766194599d/raw/dc14a63649d530e5e29f0d1288f41ed54bc6b810/main.c
>> I get a BADF result value. The debugger tells me that this occurs
>> because `file->f_op != &pipefifo_fops` in get_pipe_info() in fs/pipe.c
>> (neither pointer is NULL).
>>
>> I give the program the file descriptor "1". Shouldn't that always be a pipe?
>> Is there something obvious that I'm missing?
> 
> The change looks reasonable, some changes needed around not blocking.
> But you can't use the splice ops with a tty, you need to use an end of a
> pipe. That's why you get -EBADF in your test program. I'm assuming you
> didn't run the one you sent, because you're overwriting ->addr in that
> one by setting splice_off_in after having assigned ->addr using the prep
> function?
> 
>> @@ -967,6 +976,11 @@ static const struct io_op_def io_op_defs[] = {
>>  		.unbound_nonreg_file	= 1,
>>  		.work_flags		= IO_WQ_WORK_BLKCG,
>>  	},
>> +	[IORING_OP_VMSPLICE] = {
>> +		.needs_file = 1,
>> +		.hash_reg_file		= 1,
>> +		.unbound_nonreg_file	= 1,
>>
>> I couldn't find any information regarding what the work flags do, so
>> I've left them empty for now.
> 
> As a minimum, you'd need IO_WQ_WORK_MM I think for the async part of it,
> if we need to block.
> 
> Various style issues in here too, like lines that are too long and
> function braces need to go on a new line (and no braces for single
> lines). If you want to move further with this, also split it into two
> patches. The first should do the abstraction needed for splice.[ch] and
> the second should be the io_uring change.

With your test app fixed up, this one works for me and has the style
issues cleaned up too. Might need more work than this, but it's a
good starting point. One thing to note is that the pipe_lock()
means we probably have to always return -EAGAIN if force_nonblock
is set in io_vmsplice() for now.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed13642b56bc..349449202c6a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -531,6 +531,13 @@ struct io_splice {
 	unsigned int			flags;
 };
 
+struct io_vmsplice {
+	struct file			*file;
+	u64				addr;
+	u64				len;
+	unsigned int			flags;
+};
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -692,6 +699,7 @@ struct io_kiocb {
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
 		struct io_splice	splice;
+		struct io_vmsplice	vmsplice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
 		struct io_shutdown	shutdown;
@@ -967,6 +975,12 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_VMSPLICE] = {
+		.needs_file = 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
 	[IORING_OP_TEE] = {
@@ -3902,6 +3916,54 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+static int io_vmsplice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_vmsplice *sp = &req->vmsplice;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(READ_ONCE(sqe->off)))
+		return -EINVAL;
+
+	sp->addr = READ_ONCE(sqe->addr);
+	sp->len = READ_ONCE(sqe->len);
+	sp->flags = READ_ONCE(sqe->splice_flags);
+
+	if (sp->flags & ~SPLICE_F_ALL)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int io_vmsplice(struct io_kiocb *req, bool force_nonblock)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	void __user *buf = u64_to_user_ptr(sp->addr);
+	struct io_vmsplice *sp = &req->vmsplice;
+	struct iov_iter __iter, *iter = &__iter;
+	struct file *file = sp->file;
+	int type, ret, flags;
+
+	if (file->f_mode & FMODE_WRITE)
+		type = WRITE;
+	else if (file->f_mode & FMODE_READ)
+		type = READ;
+	else
+		return -EBADF;
+
+	ret = __import_iovec(type, buf, sp->len, UIO_FASTIOV, &iovec, iter,
+				req->ctx->compat);
+	if (ret < 0)
+		return ret;
+
+	flags = sp->flags;
+	if (force_nonblock)
+		flags |= SPLICE_F_NONBLOCK;
+	ret = do_vmsplice(file, iter, flags);
+	kfree(iovec);
+	return ret;
+}
+
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
@@ -6027,6 +6089,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_epoll_ctl_prep(req, sqe);
 	case IORING_OP_SPLICE:
 		return io_splice_prep(req, sqe);
+	case IORING_OP_VMSPLICE:
+		return io_vmsplice_prep(req, sqe);
 	case IORING_OP_PROVIDE_BUFFERS:
 		return io_provide_buffers_prep(req, sqe);
 	case IORING_OP_REMOVE_BUFFERS:
@@ -6280,6 +6344,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_SPLICE:
 		ret = io_splice(req, force_nonblock);
 		break;
+	case IORING_OP_VMSPLICE:
+		ret = io_vmsplice(req, force_nonblock);
+		break;
 	case IORING_OP_PROVIDE_BUFFERS:
 		ret = io_provide_buffers(req, force_nonblock, cs);
 		break;
diff --git a/fs/splice.c b/fs/splice.c
index 866d5c2367b2..2d653a20cced 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1270,6 +1270,20 @@ static int vmsplice_type(struct fd f, int *type)
 	return 0;
 }
 
+long do_vmsplice(struct file *file, struct iov_iter *iter, unsigned int flags)
+{
+	long error;
+
+	if (!iov_iter_count(iter))
+		error = 0;
+	else if (iov_iter_rw(iter) == WRITE)
+		error = vmsplice_to_pipe(file, iter, flags);
+	else
+		error = vmsplice_to_user(file, iter, flags);
+
+	return error;
+}
+
 /*
  * Note that vmsplice only really supports true splicing _from_ user memory
  * to a pipe, not the other way around. Splicing from user memory is a simple
@@ -1309,12 +1323,7 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 	if (error < 0)
 		goto out_fdput;
 
-	if (!iov_iter_count(&iter))
-		error = 0;
-	else if (iov_iter_rw(&iter) == WRITE)
-		error = vmsplice_to_pipe(f.file, &iter, flags);
-	else
-		error = vmsplice_to_user(f.file, &iter, flags);
+	error = do_vmsplice(f.file, &iter, flags);
 
 	kfree(iov);
 out_fdput:
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc..44c0e612f652 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -81,9 +81,9 @@ extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 extern long do_splice(struct file *in, loff_t *off_in,
 		      struct file *out, loff_t *off_out,
 		      size_t len, unsigned int flags);
-
 extern long do_tee(struct file *in, struct file *out, size_t len,
 		   unsigned int flags);
+extern long do_vmsplice(struct file *file, struct iov_iter *iter, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d31a2a1e8ef9..6bc79f9bb123 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_VMSPLICE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,

-- 
Jens Axboe

