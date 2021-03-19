Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129D0341B4A
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 12:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhCSLUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 07:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCSLUS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 07:20:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F36C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 04:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=Lzr/N/+iyNlyil+T7dqZ5scxU+ivRXShyGSjn8XoivA=; b=D2TL8zIJbiPAK4OfqP/ZGZUewL
        wudLdkMRDDxmlfEulTy8QkPFGkNvch98ao5pQbw8TYy2795GsPc9CqDInmN1Z5zB3RNldS/kj6t/A
        SI30kcdPM53btr5cX3nx7oa+F/7dpiCBY4A6nm4XjkfGm2RoU3DxSyoyM0OvF+QUMPjHjSXK8Z0eK
        SojnRmrQXJGot7HR5BLAjvs/YGpNMGn3J9gAyx0f+lJhMTVK4YG5MY/hq7uG+eC7KJ6pQBvGUjVWF
        QDAtXdaOHW73lwzBaGhn4OooOzshyYNNlqCEc/oxW6fD3tFytaj4+69dQjqfqPxCzp9x/7UEFLA1w
        Zc+rwJIqmVpbZ4i4Ar3Cs0zQMDJjwd2pqyFBJnKiyoutkQAhdQL39FIUmwyKiDRWGd9RDhnHb10IC
        NdxnIPaDWwWV57xMLr2pIl9t2/nFri2NcKQ2o6AvJprI9ILBvxaOYhUWkf7gD54zqLGZ9EJgZyeBQ
        /UZya9Ymo6ekzHvrptUwmJEU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNDAj-0001iz-I5; Fri, 19 Mar 2021 11:20:05 +0000
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-2-axboe@kernel.dk> <20210318053454.GA28063@lst.de>
 <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 1/8] io_uring: split up io_uring_sqe into hdr + main
Message-ID: <02f5e194-ddd7-539f-9a6b-886ddf5c1144@samba.org>
Date:   Fri, 19 Mar 2021 12:20:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 18.03.21 um 19:40 schrieb Jens Axboe:
> On 3/17/21 11:34 PM, Christoph Hellwig wrote:
>>> @@ -14,11 +14,22 @@
>>>  /*
>>>   * IO submission data structure (Submission Queue Entry)
>>>   */
>>> +struct io_uring_sqe_hdr {
>>> +	__u8	opcode;		/* type of operation for this sqe */
>>> +	__u8	flags;		/* IOSQE_ flags */
>>> +	__u16	ioprio;		/* ioprio for the request */
>>> +	__s32	fd;		/* file descriptor to do IO on */
>>> +};
>>> +
>>>  struct io_uring_sqe {
>>> +#ifdef __KERNEL__
>>> +	struct io_uring_sqe_hdr	hdr;
>>> +#else
>>>  	__u8	opcode;		/* type of operation for this sqe */
>>>  	__u8	flags;		/* IOSQE_ flags */
>>>  	__u16	ioprio;		/* ioprio for the request */
>>>  	__s32	fd;		/* file descriptor to do IO on */
>>> +#endif
>>>  	union {
>>>  		__u64	off;	/* offset into file */
>>>  		__u64	addr2;
>>
>> Please don't do that ifdef __KERNEL__ mess.  We never guaranteed
>> userspace API compatbility, just ABI compatibility.
> 
> Right, but I'm the one that has to deal with the fallout. For the
> in-kernel one I can skip the __KERNEL__ part, and the layout is the
> same anyway.
> 
>> But we really do have a biger problem here, and that is ioprio is
>> a field that is specific to the read and write commands and thus
>> should not be in the generic header.  On the other hand the
>> personality is.
>>
>> So I'm not sure trying to retrofit this even makes all that much sense.
>>
>> Maybe we should just define io_uring_sqe_hdr the way it makes
>> sense:
>>
>> struct io_uring_sqe_hdr {
>> 	__u8	opcode;	
>> 	__u8	flags;
>> 	__u16	personality;
>> 	__s32	fd;
>> 	__u64	user_data;
>> };
>>
>> and use that for all new commands going forward while marking the
>> old ones as legacy.
>>
>> io_uring_cmd_sqe would then be:
>>
>> struct io_uring_cmd_sqe {
>>         struct io_uring_sqe_hdr	hdr;
>> 	__u33			ioc;
>> 	__u32 			len;
>> 	__u8			data[40];
>> };
>>
>> for example.  Note the 32-bit opcode just like ioctl to avoid
>> getting into too much trouble due to collisions.
> 
> I was debating that with myself too, it's essentially making
> the existing io_uring_sqe into io_uring_sqe_v1 and then making a new
> v2 one. That would impact _all_ commands, and we'd need some trickery
> to have newly compiled stuff use v2 and have existing applications
> continue to work with the v1 format. That's very different from having
> a single (or new) opcodes use a v2 format, effectively.

I think we should use v0 and v1.

I think io_init_req and io_prep_req could be merged into an io_init_prep_req()
which could then do:

switch (ctx->sqe_version)
case 0:
      return io_init_prep_req_v0();
case 1:
      return io_init_prep_req_v1();
default:
      return -EINVAL;

The kernel would return IORING_FEAT_SQE_V1
and set ctx->sqe_version = 1 if IORING_SETUP_SQE_V1 was passed from
the caller.

liburing whould then need to pass struct io_uring *ring to
io_uring_prep_*(), io_uring_sqe_set_flags() and io_uring_sqe_set_data().
in order to use struct io_uring->sq.sqe_version to alter the behavior.
(I think we should also have a io_uring_sqe_set_personality() helper).

static inline void io_uring_prep_nop(struct io_uring *ring, struct io_uring_sqe *sqe)
{
	struct io_uring_sqe_common *nop = &sqe->common;
	if (ring->sq.sqe_version == 0)
        	io_uring_prep_rw_v0(IORING_OP_NOP, sqe, -1, NULL, 0, 0);
	else
		*nop = (struct io_uring_sqe_common) {
			.hdr = {
				.opcode = IORING_OP_NOP,
			},
		};
}

For new features the prep functions would return a pointer to
the specific structure (see also below).

static inline struct io_uring_sqe_file_cmd *
io_uring_prep_file_cmd(struct io_uring *ring, struct io_uring_sqe *sqe, int fd, uint32_t cmd_opcode)
{
	struct io_uring_sqe_file_cmd *file_cmd = &sqe->file_cmd;

	*file_cmd = (struct io_uring_sqe_file_cmd) {
		.hdr = {
			.opcode = IORING_OP_FILE_CMD,
		},
		.fd = fd,
		.cmd_opcode = cmd_opcode,
	}

	return file_cmd;
}

The application could then also check for a n
In order to test v1 it should have a way to skip IORING_FEAT_SQE_V2
and all existing tests could have a helper function to toggle that
based on an environment variable, so that make runtests could run
each test in both modes.

> Looking into the feasibility of this. But if that is done, there are
> other things that need to be factored in, as I'm not at all interested
> in having a v3 down the line as well. And I'd need to be able to do this
> seamlessly, both from an application point of view, and a performance
> point of view (no stupid conversions inline).


> Things that come up when something like this is on the table
> 
> - Should flags be extended? We're almost out... It hasn't been an
>   issue so far, but seems a bit silly to go v2 and not at least leave
>   a bit of room there. But obviously comes at a cost of losing eg 8
>   bits somewhere else.
> 
> - Is u8 enough for the opcode? Again, we're nowhere near the limits
>   here, but eventually multiplexing might be necessary.
> 
> That's just off the top of my head, probably other things to consider
> too.

What about using something like this:

struct io_uring_sqe_hdr {
 	__u64	user_data;
 	__u16	personality;
 	__u16	opcode;
        __u32   flags;
};

I moved __s32 fd out of it as not all commands need it and some need more than
one. So I guess it's easier to have them in the per opcode structure.
and the io_file_get() should better be done in the per opcode prep_vX function.

struct io_uring_sqe_common {
	struct io_uring_sqe_hdr hdr;
	__u8 __reserved[48];
};

struct io_uring_sqe_rw_common {
	struct io_uring_sqe_hdr hdr;
	__s32 fd;        /* file descriptor to do IO on */
	__u32 len;       /* buffer size or number of iovecs */
	__u64 off;       /* offset into file */
	__u64 addr;      /* pointer to buffer or iovecs */
	__kernel_rwf_t   rw_flags;
	__u16 ioprio;    /* ioprio for the request */
	__u16 buf_index; /* index into fixed buffers, if used */
	__u8 __reserved[16];
};

struct io_uring_sqe_file_cmd {
	struct io_uring_sqe_hdr	hdr;
	__s32 fd;           /* file descriptor to do IO on */
	__u32 cmd_opcode;   /* file specific command */
 	__u8  cmd_data[40]; /* command spefic data */
};

struct io_uring_sqe {
	union {
		struct io_uring_sqe_common common;
		struct io_uring_sqe_common nop;
		struct io_uring_sqe_rw_common readv;
		struct io_uring_sqe_rw_common writev;
		struct io_uring_sqe_rw_common read_fixed;
		struct io_uring_sqe_rw_common write_fixed;
		struct io_uring_sqe_file_cmd file_cmd;
        };
};

Each _opcode_prep() function would then check hdr.flags for unsupported flags
and __reserved for zeros. Instead of having a global io_op_defs[] array
the _opcode_prep() function would have a static const definition for the opcode
and lease req->op_def (which would be const struct io_op_def *op_def);

Does that sound useful in anyway?

metze
