Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5130E306AA6
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 02:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhA1Bqc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 20:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhA1BqW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 20:46:22 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9835BC061573
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 17:45:40 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g3so2444440plp.2
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 17:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZUKE5h/tzH/UXOkyUovyh3N4NlWWWCrOadJwbQvpglY=;
        b=dO+bv3XsdFXvNGrWWZREK8hZUFfRjAhpGXbM/MFRY8jthUMLmzW8o6dkgfpbcyuI5m
         5nQTz8c9vPRkg2xCM+tyQ0fFRjuOGA2gqcLOO18GfLPmf/ovgnhSxiAV3FiGxtgk2GsH
         GYBr3KOaMjWz3haXDYQdEov4vZ9kv0UGTWMqDZiNhHDqW/Y5ts0lKJolKVIHmanhRdFI
         tgwwemkFtA7nzvr6SO1Q8Np8DFYw6nxIIOMPh/EqFRi5JnoADNKQDphpiftOk1+2YEFk
         y+PKZqzc6vIvq05C16Oh4pzyYYSFzkWNfaXmj+1NlgfmTLmPWSpIQFisxoXmUYGC9fXp
         hB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZUKE5h/tzH/UXOkyUovyh3N4NlWWWCrOadJwbQvpglY=;
        b=lXAGh5zDnh2O0F/XWFTm6B2bz07zRV0cK7qy1udz+gzxq13EqIhsLhkWkgkspKVsbm
         jED0zcsL9zupEEEwZezq3tVO6M9JU6zJ0dWxfTHwFHpXHlaixhgWaB+sr5OlzKrQfHFP
         ltvKMBM5AUjogLMP69wtbqkXsiI3xeJ5YuAwGlo7low8cFtFUYiSNGJQDnAntK600ndO
         EWgeQYmq0dZWADrT9cg5aS9e4+h2yqUljYXmUSKoDzRKr23KXsh3bM8rQenqSavH087d
         MgCOzGv58CqNoVBZIiyN9u/GiUx9MW7rERGUscHzitccrWj5pUduZ67BN3R8Po+OAFJc
         4Wxw==
X-Gm-Message-State: AOAM530zi2fWJCmiXvRi+2AS5xnVRwn080rb5VlsL5Wc1/rmwW/67brf
        2jbApLgvGXWHtubmNSVjgc5XfjlUj1xKWA==
X-Google-Smtp-Source: ABdhPJygJ+Rj/51Ry1bqOnxbuPCGc91Phwrtg9QqVu6jdiMOWfrUkVvW7hU6MArZ/ig6pzRmXb1XRQ==
X-Received: by 2002:a17:90a:4897:: with SMTP id b23mr8818460pjh.193.1611798339772;
        Wed, 27 Jan 2021 17:45:39 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id o10sm3675339pfp.87.2021.01.27.17.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:45:39 -0800 (PST)
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
Date:   Wed, 27 Jan 2021 18:45:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128003831.GE7695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/21 5:38 PM, Darrick J. Wong wrote:
> On Wed, Jan 27, 2021 at 02:25:38PM -0700, Jens Axboe wrote:
>> This is a file private kind of request. io_uring doesn't know what's
>> in this command type, it's for the file_operations->uring_cmd()
>> handler to deal with.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c                 | 59 +++++++++++++++++++++++++++++++++++
>>  include/linux/io_uring.h      | 12 +++++++
>>  include/uapi/linux/io_uring.h |  1 +
>>  3 files changed, 72 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 03748faa5295..55c2714a591e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -712,6 +712,7 @@ struct io_kiocb {
>>  		struct io_shutdown	shutdown;
>>  		struct io_rename	rename;
>>  		struct io_unlink	unlink;
>> +		struct io_uring_cmd	uring_cmd;
>>  		/* use only after cleaning per-op data, see io_clean_op() */
>>  		struct io_completion	compl;
>>  	};
>> @@ -805,6 +806,8 @@ struct io_op_def {
>>  	unsigned		needs_async_data : 1;
>>  	/* should block plug */
>>  	unsigned		plug : 1;
>> +	/* doesn't support personality */
>> +	unsigned		no_personality : 1;
>>  	/* size of async data needed, if any */
>>  	unsigned short		async_size;
>>  	unsigned		work_flags;
>> @@ -998,6 +1001,11 @@ static const struct io_op_def io_op_defs[] = {
>>  		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
>>  						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
>>  	},
>> +	[IORING_OP_URING_CMD] = {
>> +		.needs_file		= 1,
>> +		.no_personality		= 1,
>> +		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
>> +	},
>>  };
>>  
>>  enum io_mem_account {
>> @@ -3797,6 +3805,47 @@ static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
>>  	return 0;
>>  }
>>  
>> +static void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
>> +{
>> +	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
>> +
>> +	if (ret < 0)
>> +		req_set_fail_links(req);
>> +	io_req_complete(req, ret);
>> +}
>> +
>> +static int io_uring_cmd_prep(struct io_kiocb *req,
>> +			     const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_uring_cmd *cmd = &req->uring_cmd;
>> +
>> +	if (!req->file->f_op->uring_cmd)
>> +		return -EOPNOTSUPP;
>> +
>> +	memcpy(&cmd->pdu, (void *) &sqe->off, sizeof(cmd->pdu));
> 
> Hmmm.  struct io_uring_pdu is (by my count) 6x uint64_t (==48 bytes) in
> size.  This starts copying the pdu from byte 8 in struct io_uring_sqe,
> and the sqe is 64 bytes in size.

Correct

> I guess (having not played much with io_uring) that the stuff in the
> first eight bytes of the sqe are header info that's common to all
> io_uring operations, and hence not passed to io_uring_cmd*.

Exactly

> Assuming that I got that right, that means that the pdu information
> doesn't actually go all the way to the end of the sqe, which currently
> is just a bunch of padding.  Was that intentional, or does this mean
> that io_uring_pdu could actually be 8 bytes longer?

Also correct. The reason is actually kind of stupid, and I think we
should just fix that up. struct io_uring_cmd should fit within the first
cacheline of io_kiocb, to avoid bloating that one. But with the members
in there, it ends up being 8 bytes too big, if we grab those 8 bytes.
What I think we should do is get rid of ->done, and just have drivers
call io_uring_cmd_done() instead. We can provide an empty hook for that.
Then we can reclaim the 8 bytes, and grow the io_uring_cmd to 56 bytes.

> Also, I thought io_uring_seq.user_data was supposed to coincide with
> io_uring_pdu.reserved?  They don't seem to...?
>
> (I could be totally off here, fwiw.)

I think you are, I even added a BUILD check for that:

BUILD_BUG_ON(offsetof(struct io_uring_sqe, user_data) !=
	     offsetof(struct io_uring_pdu, reserved));

to ensure that that is the case.

> The reason why I'm counting bytes so stingily is that xfs_scrub issues
> millions upon millions of ioctl calls to scrub an XFS.  Wouldn't it be
> nice if there was a way to submit a single userspace buffer to the
> kernel and let it run every scrubber for that fs object in order?  I
> could cram all that data into the pdu struct ... if it had 56 bytes of
> space.

For other purposes too, the bigger we can make the inline data, the more
likely we are that we can fit everything we need in there. I'm going to
make the change to bump it to 56 bytes.

> If not, it wouldn't be a big deal to use one of the data[4] fields as a
> pointer to a larger struct, but where's the fun in that? :)

Agree :-)

> Granted I'm programming speculatively in my head, not building an actual
> prototype.  There are all kinds of other questions I have, like, can a
> uring command handler access the task struct or the userspace memory of
> the process it was called from?  What happens when the user is madly
> pounding on ^C while uring commands are running?  I should probably
> figure out the answers to those questions and maybe even write/crib a
> program first... 

Well, either the program would exit if it had no SIGINT handler, and
that would signal the async task handling it and cancel it. Or you
handle it, and then you need to cancel on your own.

-- 
Jens Axboe

