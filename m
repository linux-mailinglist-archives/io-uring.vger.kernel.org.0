Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2DD69329E
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 17:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBKQxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 11:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBKQxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 11:53:02 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E16171F
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 08:53:00 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id b1so5470702pft.1
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 08:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676134380;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XWrRxIpQ/UpX0F1aAOlF1P39ut2lQ3qaVUCwXURScZg=;
        b=3pabTUy1xRwyqu5xBrGZxjCF1p6vJc+d3p3J2PDv9SmiMB1KhC0GtLGYM7+zpFYX3S
         0b23l77vlXPv+Azc4IJRGi/1GZD4cN7H8vBkgbIAOkNOSRlBxpax9Ige748T4/uoX+Z6
         /4JoAyESsjBCwhDiobMoTdjdKDdeDEZn0MOxqixI4HSnMbnIGlyfQv0i3riu3uowCUd2
         oNvQ8kw2z8H6NF1YLcGuv/jwMpubMHJ4KkX39ASLUCaqnzIxxL5oAb55F09on78xpBpY
         gkZNg4FS58GUJp6F4QG85WydcYcmmDBe+wRsaPolTd5IVClRDRdD7EeY3n/6zM/1tOdl
         xCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676134380;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWrRxIpQ/UpX0F1aAOlF1P39ut2lQ3qaVUCwXURScZg=;
        b=XfBj+vGMZH3+wFMcvOxUG3hEJQF1C4pNpEhnWCQ0SXu40e79T0CFdymMXzoV5NSYb9
         oE1IOUOHkalJZS8sA+o6/McUy62Q2tPHorR4DhFpGShWudMbhMl5y/USZg17kLhnRhJa
         97rOdOC+RjzIlIJUzpDohac0Tcc2yJchd1zNbm9ZBSxtXJoWhTBhPlJ3/xdfdlM0A0JW
         hE4YWjFjPcA4Ny22rQNQIlORMAadbSKHhOAfMYxL49QNcTEkhOVxirVzq5MuN80q7iXF
         /u2MsLMhIULaBe0g3umz36pQTEZuANUBD3Pm1tMCbDU5+EP4CotXearwW/If93lu4LCk
         LuBA==
X-Gm-Message-State: AO0yUKVXFpufgucv28kQf9gjdqs1+PKQR5Px9NsAEV1FQwEZR+hLwkUJ
        sOCPwpYNycJeYFDUvaew5JPNxQ==
X-Google-Smtp-Source: AK7set9lahtmNUsmH69E1u4cg4DfpX72V3xjUJ5my/jEj2Q+2WR1WFQhchakGbQ8mD+Ws6z+JMbImg==
X-Received: by 2002:a62:ce87:0:b0:5a8:9281:53a5 with SMTP id y129-20020a62ce87000000b005a8928153a5mr1387002pfg.2.1676134380044;
        Sat, 11 Feb 2023 08:53:00 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i21-20020aa78d95000000b0058119caa82csm5109769pfr.205.2023.02.11.08.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 08:52:59 -0800 (PST)
Message-ID: <22772531-bf55-f610-be93-3d53c9ce1c6d@kernel.dk>
Date:   Sat, 11 Feb 2023 09:52:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-4-ming.lei@redhat.com>
 <a487261c-cc0e-134b-cd8e-26460fe7cf59@kernel.dk> <Y+e+i5BXQHcqdDGo@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+e+i5BXQHcqdDGo@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/23 9:12?AM, Ming Lei wrote:
> On Sat, Feb 11, 2023 at 08:45:18AM -0700, Jens Axboe wrote:
>> On 2/10/23 8:32?AM, Ming Lei wrote:
>>> IORING_OP_READ_SPLICE_BUF: read to buffer which is built from
>>> ->read_splice() of specified fd, so user needs to provide (splice_fd, offset, len)
>>> for building buffer.
>>>
>>> IORING_OP_WRITE_SPLICE_BUF: write from buffer which is built from
>>> ->read_splice() of specified fd, so user needs to provide (splice_fd, offset, len)
>>> for building buffer.
>>>
>>> The typical use case is for supporting ublk/fuse io_uring zero copy,
>>> and READ/WRITE OP retrieves ublk/fuse request buffer via direct pipe
>>> from device->read_splice(), then READ/WRITE can be done to/from this
>>> buffer directly.
>>
>> Main question here - would this be better not plumbed up through the rw
>> path? Might be cleaner, even if it either requires a bit of helper
>> refactoring or accepting a bit of duplication. But would still be better
>> than polluting the rw fast path imho.
> 
> The buffer is actually IO buffer, which has to be plumbed up in IO path,
> and it can't be done like the registered buffer.
> 
> The only affect on fast path is :
> 
> 		if (io_rw_splice_buf(req))	//which just check opcode
>               return io_prep_rw_splice_buf(req, sqe);
> 
> and the cleanup code which is only done for the two new OPs.
> 
> Or maybe I misunderstand your point? Or any detailed suggestion?
> 
> Actually the code should be factored into generic helper, since net.c
> need to use them too. Probably it needs to move to rsrc.c?

Yep, just refactoring out those bits as a prep thing. rsrc could work,
or perhaps a new file for that.

>> Also seems like this should be separately testable. We can't add new
>> opcodes that don't have a feature test at least, and should also have
>> various corner case tests. A bit of commenting outside of this below.
> 
> OK, I will write/add one very simple ublk userspace to liburing for
> test purpose.

Thanks!

>>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>>> index 5238ecd7af6a..91e8d8f96134 100644
>>> --- a/io_uring/opdef.c
>>> +++ b/io_uring/opdef.c
>>> @@ -427,6 +427,31 @@ const struct io_issue_def io_issue_defs[] = {
>>>  		.prep			= io_eopnotsupp_prep,
>>>  #endif
>>>  	},
>>> +	[IORING_OP_READ_SPLICE_BUF] = {
>>> +		.needs_file		= 1,
>>> +		.unbound_nonreg_file	= 1,
>>> +		.pollin			= 1,
>>> +		.plug			= 1,
>>> +		.audit_skip		= 1,
>>> +		.ioprio			= 1,
>>> +		.iopoll			= 1,
>>> +		.iopoll_queue		= 1,
>>> +		.prep			= io_prep_rw,
>>> +		.issue			= io_read,
>>> +	},
>>> +	[IORING_OP_WRITE_SPLICE_BUF] = {
>>> +		.needs_file		= 1,
>>> +		.hash_reg_file		= 1,
>>> +		.unbound_nonreg_file	= 1,
>>> +		.pollout		= 1,
>>> +		.plug			= 1,
>>> +		.audit_skip		= 1,
>>> +		.ioprio			= 1,
>>> +		.iopoll			= 1,
>>> +		.iopoll_queue		= 1,
>>> +		.prep			= io_prep_rw,
>>> +		.issue			= io_write,
>>> +	},
>>
>> Are these really safe with iopoll?
> 
> Yeah, after the buffer is built, the handling is basically
> same with IORING_OP_WRITE_FIXED, so I think it is safe.

Yeah, on a second look, as these are just using the normal read/write
path after that should be fine indeed.

>>
>>> +static int io_prep_rw_splice_buf(struct io_kiocb *req,
>>> +				 const struct io_uring_sqe *sqe)
>>> +{
>>> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>>> +	unsigned nr_pages = io_rw_splice_buf_nr_bvecs(rw->len);
>>> +	loff_t splice_off = READ_ONCE(sqe->splice_off_in);
>>> +	struct io_rw_splice_buf_data data;
>>> +	struct io_mapped_ubuf *imu;
>>> +	struct fd splice_fd;
>>> +	int ret;
>>> +
>>> +	splice_fd = fdget(READ_ONCE(sqe->splice_fd_in));
>>> +	if (!splice_fd.file)
>>> +		return -EBADF;
>>
>> Seems like this should check for SPLICE_F_FD_IN_FIXED, and also use
>> io_file_get_normal() for the non-fixed case in case someone passed in an
>> io_uring fd.
> 
> SPLICE_F_FD_IN_FIXED needs one extra word for holding splice flags, if
> we can use sqe->addr3, I think it is doable.

I haven't checked the rest, but you can't just use ->splice_flags for
this?

In any case, the get path needs to look like io_tee() here, and:

>>> +out_put_fd:
>>> +	if (splice_fd.file)
>>> +		fdput(splice_fd);

this put needs to be gated on whether it's a fixed file or not.

>> If the operation is done, clear NEED_CLEANUP and do the cleanup here?
>> That'll be faster.
> 
> The buffer has to be cleaned up after req is completed, since bvec
> table is needed for bio, and page reference need to be dropped after
> IO is done too.

I mean when you clear that flag, call the cleanup bits you otherwise
would've called on later cleanup.

-- 
Jens Axboe

