Return-Path: <io-uring+bounces-2708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A381794F2C0
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 599A12841D1
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F241187868;
	Mon, 12 Aug 2024 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBsR+ALk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F48183CD9;
	Mon, 12 Aug 2024 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478989; cv=none; b=XWpcQQM5wCRlIHCcyXFaH4vBgwUT+LdsQx+55HrgkjV1U87vVAGSxbz3OjIma9YQwnKPrxPUD6Yzm0w0kd5rq4I2Rtrw3meyaF8zDezEERcw2Y4BZ5998dZMV3DPA1yI1H7bqrm1nDm+q5WSPBwv+yxu9Zoq68+MM3u1nOz3jAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478989; c=relaxed/simple;
	bh=ut5DmSRgn8IW5cOwBXMiR/c9TCpft2wgIvB4TExnP50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YMZgOufHu+MgIwK/yoIqCP7qjIgSZE0YNEra2PpiiE9+8Ne6me069WYOTiSnaXNfBvp1o/auYwqOb7D9Xqn2qPiX1QExpddGmsrZeBISMnKnW04/y3bhdlEvVTh+rkwj2FIQmHlxlToUqtpkpl41C7ESs3xi8hV0Cz0GkwTm6dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PBsR+ALk; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-367963ea053so3649711f8f.2;
        Mon, 12 Aug 2024 09:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723478986; x=1724083786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=16t22AwkHYNEJgL3fcr7IKMkktwOOFydnTxHebQT2BM=;
        b=PBsR+ALk9SjGgBpl7QjL7pPcsfb0V2clXPj+cLlIX1n1yLXJXORVrxO4GHfCR8l+se
         u5eQrPDLcfEfY3jIeVuQGwLWXr12KbXr6mUirg2AD3KUn7Ycb7zQMvw6i/eCd+Qo2MOT
         wFqvOajUqKkm2Ur9V8yhcjy/W9BZxgqcg72yxbKkPX0WCW/cXovCHYL8xOmuEhietwlT
         rW4wy9nAqyo48vaAgwUdRy4Udu7tn8oH2aiItcL8aHJQXZ+PROiV9jVUXFDF8A0Xqiix
         V+/eH14ysAL0tssnKF4bP/wnXqzR6kVj8ScI659Xm8IX8zrZcTfRkABKAuoOrtQ8BfX8
         10iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723478986; x=1724083786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16t22AwkHYNEJgL3fcr7IKMkktwOOFydnTxHebQT2BM=;
        b=PRsV/paJ0z16vJlVZRiK5f3dkn6mPZYbPUWO1phJtJl6VPDOcMICMkhGO15RcZRAoe
         RYizRlHxRCGiTUl0m9kS/HueLQeU5yO4dtjkEnc1uJ7vY8ONW79TgXoIpWMMpY1i4r4y
         K5bI1YQPbbqlY8UEtsKCCypRXlVeXjyeHFq/tXmY8jReD2S+IrDBF8iY2eJo7QZ4/5zY
         5cFsEodPuy/roLOKVEqKeo0iXtGkGNJwpLV2hqqMeB8FdOcgFiQEVDlKoO3ybgLjNJAj
         UkEwnm2IWiLymjwC/sXC+qZu5LrrGtSjxGikesVgfIbKuXk5cb+xUnpBdtkhvqzkvGT7
         syEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp5F4F+BinTVgAdx878GDPEbJlqbBNZBN8c4f/yav9LHVYXLXEszILQIDjldS5MwsQ/gP0D7/AUtR8xp4jEGcEe6y/I/Vx78w=
X-Gm-Message-State: AOJu0Yw+ol+qdMihY6qQVVvqYr7J2WUM4lc9sA8rRd0fNDIpM2z7hKol
	sXoaKU9JpHOT/MUbVkSIATt+Pm/Kp7Hpe73LeP2dUDDNY7Ilk2PGATFNihsd
X-Google-Smtp-Source: AGHT+IHDuItFWdP44VZ/nxzDmqc54XdKl5EJYlCUOgpmJmkZh9BMVsPJL8wf0Z5Yd4OLxkEP3Spy6g==
X-Received: by 2002:a05:6000:bc6:b0:368:3f6a:1dea with SMTP id ffacd0b85a97d-3716ccd746cmr899723f8f.6.1723478985624;
        Mon, 12 Aug 2024 09:09:45 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4e51e966sm7890640f8f.75.2024.08.12.09.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 09:09:45 -0700 (PDT)
Message-ID: <1f5f4194-8981-46d4-aa7d-819cbdf653b9@gmail.com>
Date: Mon, 12 Aug 2024 17:10:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
To: Christoph Hellwig <hch@infradead.org>, Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zrnxgu7vkVDgI6VU@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 12:26, Christoph Hellwig wrote:
> On Fri, Aug 09, 2024 at 06:35:27PM +0100, Mark Harmstone wrote:

Mark, please CC io_uring for next versions, I've only found out
about the patch because Christoph added us.

>> Adds an io_uring interface for asynchronous encoded reads, using the
>> same interface as for the ioctl. To use this you would use an SQE opcode
>> of IORING_OP_URING_CMD, the cmd_op would be BTRFS_IOC_ENCODED_READ, and
>> addr would point to the userspace address of the
>> btrfs_ioctl_encoded_io_args struct. As with the ioctl, you need to have
>> CAP_SYS_ADMIN for this to work.
> 
> What is the point if this doesn't actually do anything but returning
> -EIOCBQUEUED?
> 
> Note that that the internals of the btrfs encoded read is built
> around kiocbs anyway, so you might as well turn things upside down,
> implement a real async io_uring cmd and just wait for it to complete
> to implement the existing synchronous ioctl.
> 
>>
>> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
>> ---
...
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 0493272a7668..8f5cc7d1429c 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
...
>> +static void btrfs_uring_encoded_read_compat_cb(struct io_uring_cmd *cmd,
>> +					       unsigned int issue_flags)
>> +{
>> +	int ret;
>> +
>> +	ret = btrfs_ioctl_encoded_read(cmd->file, (void __user *)cmd->sqe->addr,
>> +				       true);
>> +
>> +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
>> +}
>> +
>> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
>> +				    unsigned int issue_flags)
>> +{
>> +	if (issue_flags & IO_URING_F_COMPAT)

Instead of two different callbacks we can add a helper

# include/linux/io_uring/cmd.h

static inline bool io_uring_cmd_is_compat(struct io_uring_cmd *cmd)
{
#ifdef COMPAT
	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);

	return req->ctx->compat;
#else
	return false;
#endif
}

But then we pass the flag in btrfs_ioctl_encoded_read() and use to
interpret struct btrfs_ioctl_encoded_io_args, but next just call
import_iovec(), which derives compat differently. Since io_uring worker
threads are now forks of the original thread, ctx->compat vs
in_compat_syscall() are only marginally different, e.g. when we pass a
ring to another process with a different compat'ness, but I don't think
that something we care about much. Let's just make it consistent.

And the last point, I'm surprised there are two versions of
btrfs_ioctl_encoded_io_args. Maybe, it's a good moment to fix it if
we're creating a new interface.

E.g. by adding a new structure defined right with u64 and such, use it
in io_uring, and cast to it in the ioctl code when it's x64 (with
a good set of BUILD_BUG_ON sprinkled) and convert structures otherwise?

>> +		io_uring_cmd_complete_in_task(cmd, btrfs_uring_encoded_read_compat_cb);
>> +	else
>> +		io_uring_cmd_complete_in_task(cmd, btrfs_uring_encoded_read_cb);

As mentioned, the callback will be executed by the submitter task.
You mentioned offloading to a thread/iowq, that would look like:

btrfs_uring_encoded_read() {
	if (issue_flags & IO_URING_F_NONBLOCK)
		return -EAGAIN;
	// it's a worker thread, block is allowed
}

It's a bad pattern though for anything requiring good performance.
At minimum it should try to execute with a nowait flag set first

nowait = issue_flags & IO_URING_F_NONBLOCK;
btrfs_ioctl_encoded_read(..., nowait);

If needs to block it would return -EAGAIN, so that the core
io_uring would spin up a worker thread for it. Even better
if it does it asynchronously as Christoph mentioned.

>> +
>> +	return -EIOCBQUEUED;
>> +}
>> +
>> +int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> +{
>> +	switch (cmd->cmd_op) {
>> +	case BTRFS_IOC_ENCODED_READ:
>> +#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
>> +	case BTRFS_IOC_ENCODED_READ_32:
>> +#endif
>> +		return btrfs_uring_encoded_read(cmd, issue_flags);
>> +	}
>> +
>> +	io_uring_cmd_done(cmd, -EINVAL, 0, issue_flags);
>> +	return -EIOCBQUEUED;
>> +}
>> +
>>   long btrfs_ioctl(struct file *file, unsigned int

-- 
Pavel Begunkov

