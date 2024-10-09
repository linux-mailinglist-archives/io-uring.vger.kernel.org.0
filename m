Return-Path: <io-uring+bounces-3480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DAB9996D94
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAC241C21D4D
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 14:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69D119885F;
	Wed,  9 Oct 2024 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iktuugrn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20B645948;
	Wed,  9 Oct 2024 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728483894; cv=none; b=EtujmK6r0IufAltniIJVtQAuMiXfXDarBB9TdJaTJNTexaJ9LgmnAQIeUZs0mkevhofJgyIUO45n390yW8Y7oIOoLoawCUc7uGL7/XqXD5JnmbnvRBapMOLGq6/8JqskTDUxCkvfp8Yr2oQ+iLj6bV3TcdUl4LHFPFhVFFj1GtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728483894; c=relaxed/simple;
	bh=HJ2bixh+Ee4OeXO8vuFvdatyZYd6Qcf4Ndo0jD1CxJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eofk35y7NKtU7MGVXnGCn+fNuZYIbn6Kjoh6pUF4ZuwufbnPAqPVqGxe/T023FBQ97I/e49nTTr9yqiyvLEVljerXbxk9sMnskXmrbH+BVmoLW79KNJs/AX0SoQ5zvePfzgHjy6IPP1lh50fEoLQDX/SNO3b3MqVZt65ceSRpj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iktuugrn; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c5cf26b95aso8899182a12.3;
        Wed, 09 Oct 2024 07:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728483891; x=1729088691; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2CveWTw4xZdmc68NlKEXLKlswQBMPwFFUT5zL7TexwE=;
        b=Iktuugrn5qmwHcnXqIiGjIVMxX1QfOERzB28HnJ7U61SR7Vw6KjMp3E2tC0ZFIYJP/
         Ccv5R/Q2mvRyX0jicH6vXgA+vlbOp8DJqI/eSSMN5jDO2Jx3qhLb4iJ9+EIXKvUPQZak
         EIvhFYWT8HgpPfMOubtXKBNVeyBL1VK6t+Q8HyeOW/NQO4K/bFMs6/jVxNWtYkplTrP/
         skH9zvBRln0O1ES+2wXcir+S1knZd9HbTIMWrO1t1J1nAWjTyo6CjsT5bVkGMHruLd0v
         0ZWv58sMMUBHw/0g1we1UxKJ0E9iT0GnRf4cEvqV7+cp6y/ivswYTlS4NY2jBSgEu/ed
         auxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728483891; x=1729088691;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CveWTw4xZdmc68NlKEXLKlswQBMPwFFUT5zL7TexwE=;
        b=U4Xjjh4Dr2fWI9Bhzxwg+MaZ3ykQm3J21dlWojtx5r8CBC417LDfXT+6oeriPrwcRJ
         Qn1U7pyUl31RLnn0cT54NzJ7kEu3CG6SdkdDNtEYfX5ToVZ+3oGC6GUpnw0nn7QALXPc
         vztgUwm5gNrhsTcfAZLvchVGhV8+aB47RlPWvWKd8e9dVm/YBZOw/46emnGOxP2brK/6
         UTp32eKu8ocLVBjmSNiKczcUF3JD1RjmpHyNXif3Al2pLWMiciC3XEiLzgzRpcIXyGj/
         0kD2IJ8D5mk/Awfwh+EC6b79015s/zx5IobbLD/CXXvWUGCJuL9DNJaGamkt7bzCMVyT
         hIiA==
X-Forwarded-Encrypted: i=1; AJvYcCXPcx95h3zCWTK1yLGrYR46qiG2OxJq3je79swku848LkftacWYVxuNHtMsBe6G8LiKZ1ZbEhZKyrBS2Yk=@vger.kernel.org, AJvYcCXlLh8YfQJ2YfCdBJN71xbBv6ALOSmQTVmr8mrehCbd8sPurusEQanQ2V7ktZoK0fUZUMBhN4x62g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy72y1uGvV7CJ3cJvy3qCh+MzT1GbR1QrnORj3Bik9KTqu+rfUA
	3X8TuGQdfhUwfzibeOMu461b/CkBuQBDlOkE0fYWLBd2yEIGj2cY
X-Google-Smtp-Source: AGHT+IFiXqxQJgykZtdtsnjGXb6lMnaNdYZIPHROMmSVm4CM8RNrxowiOgh4unQkSZbkE7Hp9feSug==
X-Received: by 2002:a05:6402:26cf:b0:5c8:ae9e:baba with SMTP id 4fb4d7f45d1cf-5c91d5363ecmr2375473a12.2.1728483890806;
        Wed, 09 Oct 2024 07:24:50 -0700 (PDT)
Received: from [192.168.42.172] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e0594166sm5619885a12.7.2024.10.09.07.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 07:24:49 -0700 (PDT)
Message-ID: <8d93e1ba-0fdf-44d4-9189-199df57d0676@gmail.com>
Date: Wed, 9 Oct 2024 15:25:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com> <ZwJIWqPT_Ae9K2bp@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwJIWqPT_Ae9K2bp@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/24 09:20, Ming Lei wrote:
> On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
>> On 9/12/24 11:49, Ming Lei wrote:
>> ...
>>> It can help to implement generic zero copy between device and related
>>> operations, such as ublk, fuse, vdpa,
>>> even network receive or whatever.
>>
>> That's exactly the thing it can't sanely work with because
>> of this design.
> 
> The provide buffer design is absolutely generic, and basically
> 
> - group leader provides buffer for member OPs, and member OPs can borrow
> the buffer if leader allows by calling io_provide_group_kbuf()
> 
> - after member OPs consumes the buffer, the buffer is returned back by
> the callback implemented in group leader subsystem, so group leader can
> release related sources;
> 
> - and it is guaranteed that the buffer can be released always
> 
> The ublk implementation is pretty simple, it can be reused in device driver
> to share buffer with other kernel subsystems.
> 
> I don't see anything insane with the design.

There is nothing insane with the design, but the problem is cross
request error handling, same thing that makes links a pain to use.
It's good that with storage reads are reasonably idempotent and you
can be retried if needed. With sockets and streams, however, you
can't sanely borrow a buffer without consuming it, so if a member
request processing the buffer fails for any reason, the user data
will be dropped on the floor. I mentioned quite a while before,
if for example you stash the buffer somewhere you can access
across syscalls like the io_uring's registered buffer table, the
user at least would be able to find an error and then memcpy the
unprocessed data as a fallback.

>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    include/linux/io_uring_types.h | 33 +++++++++++++++++++
>>>    io_uring/io_uring.c            | 10 +++++-
>>>    io_uring/io_uring.h            | 10 ++++++
>>>    io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
>>>    io_uring/kbuf.h                | 13 ++++++++
>>>    io_uring/net.c                 | 23 ++++++++++++-
>>>    io_uring/opdef.c               |  4 +++
>>>    io_uring/opdef.h               |  2 ++
>>>    io_uring/rw.c                  | 20 +++++++++++-
>>>    9 files changed, 172 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index 793d5a26d9b8..445e5507565a 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
...
>>
>> And I don't think you need opdef::accept_group_kbuf since the
>> request handler should already know that and, importantly, you don't
>> imbue any semantics based on it.
> 
> Yeah, and it just follows logic of buffer_select. I guess def->buffer_select
> may be removed too?

->buffer_select helps to fail IOSQE_BUFFER_SELECT for requests
that don't support it, so we don't need to add the check every
time we add a new request opcode.

In your case requests just ignore ->accept_group_kbuf /
REQ_F_GROUP_KBUF if they don't expect to use the buffer, so
it's different in several aspects.

fwiw, I don't mind ->accept_group_kbuf, I just don't see
what purpose it serves. Would be nice to have a sturdier uAPI,
where the user sets a flag to each member that want to use
these provided buffers and then the kernel checks leader vs
that flag and fails misconfigurations, but likely we don't
have flags / sqe space for it.


>> FWIW, would be nice if during init figure we can verify that the leader
>> provides a buffer IFF there is someone consuming it, but I don't think
> 
> It isn't doable, same reason with IORING_OP_PROVIDE_BUFFERS, since buffer can
> only be provided in ->issue().

In theory we could, in practise it'd be too much of a pain, I agree.

IORING_OP_PROVIDE_BUFFERS is different as you just stash the buffer
in the io_uring instance, and it's used at an unspecified time later
by some request. In this sense the API is explicit, requests that don't
support it but marked with IOSQE_BUFFER_SELECT will be failed by the
kernel.

>> the semantics is flexible enough to do it sanely. i.e. there are many
>> members in a group, some might want to use the buffer and some might not.
>>
...
>>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>>> index df2be7353414..8e111d24c02d 100644
>>> --- a/io_uring/io_uring.h
>>> +++ b/io_uring/io_uring.h
>>> @@ -349,6 +349,16 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
>>>    	return req->flags & REQ_F_SQE_GROUP_LEADER;
>>>    }
>> ...
>>> +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
>>> +		unsigned int len, int dir, struct iov_iter *iter)
>>> +{
>>> +	struct io_kiocb *lead = req->grp_link;
>>> +	const struct io_uring_kernel_buf *kbuf;
>>> +	unsigned long offset;
>>> +
>>> +	WARN_ON_ONCE(!(req->flags & REQ_F_GROUP_KBUF));
>>> +
>>> +	if (!req_is_group_member(req))
>>> +		return -EINVAL;
>>> +
>>> +	if (!lead || !req_support_group_dep(lead) || !lead->grp_kbuf)
>>> +		return -EINVAL;
>>> +
>>> +	/* req->fused_cmd_kbuf is immutable */
>>> +	kbuf = lead->grp_kbuf;
>>> +	offset = kbuf->offset;
>>> +
>>> +	if (!kbuf->bvec)
>>> +		return -EINVAL;
>>
>> How can this happen?
> 
> OK, we can run the check in uring_cmd API.

Not sure I follow, if a request providing a buffer can't set
a bvec it should just fail, without exposing half made
io_uring_kernel_buf to other requests.

Is it rather a WARN_ON_ONCE check?


>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index f10f5a22d66a..ad24dd5924d2 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -89,6 +89,13 @@ struct io_sr_msg {
>>>     */
>>>    #define MULTISHOT_MAX_RETRY	32
>>> +#define user_ptr_to_u64(x) (		\
>>> +{					\
>>> +	typecheck(void __user *, (x));	\
>>> +	(u64)(unsigned long)(x);	\
>>> +}					\
>>> +)
>>> +
>>>    int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>    {
>>>    	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
>>> @@ -375,7 +382,7 @@ static int io_send_setup(struct io_kiocb *req)
>>>    		kmsg->msg.msg_name = &kmsg->addr;
>>>    		kmsg->msg.msg_namelen = sr->addr_len;
>>>    	}
>>> -	if (!io_do_buffer_select(req)) {
>>> +	if (!io_do_buffer_select(req) && !(req->flags & REQ_F_GROUP_KBUF)) {
>>>    		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
>>>    				  &kmsg->msg.msg_iter);
>>>    		if (unlikely(ret < 0))
>>> @@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
>>>    	if (issue_flags & IO_URING_F_NONBLOCK)
>>>    		flags |= MSG_DONTWAIT;
>>> +	if (req->flags & REQ_F_GROUP_KBUF) {
>>
>> Does anything prevent the request to be marked by both
>> GROUP_KBUF and BUFFER_SELECT? In which case we'd set up
>> a group kbuf and then go to the io_do_buffer_select()
>> overriding all of that
> 
> It could be used in this way, and we can fail the member in
> io_queue_group_members().

That's where the opdef flag could actually be useful,

if (opdef[member]->accept_group_kbuf &&
     member->flags & SELECT_BUF)
	fail;


>>> +		ret = io_import_group_kbuf(req,
>>> +					user_ptr_to_u64(sr->buf),
>>> +					sr->len, ITER_SOURCE,
>>> +					&kmsg->msg.msg_iter);
>>> +		if (unlikely(ret))
>>> +			return ret;
>>> +	}
>>> +
>>>    retry_bundle:
>>>    	if (io_do_buffer_select(req)) {
>>>    		struct buf_sel_arg arg = {
>>> @@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>    			goto out_free;
>>>    		}
>>>    		sr->buf = NULL;
>>> +	} else if (req->flags & REQ_F_GROUP_KBUF) {
>>
>> What happens if we get a short read/recv?
> 
> For short read/recv, any progress is stored in iterator, nothing to do
> with the provide buffer, which is immutable.
> 
> One problem for read is reissue, but it can be handled by saving iter
> state after the group buffer is imported, I will fix it in next version.
> For net recv, offset/len of buffer is updated in case of short recv, so
> it works as expected.

That was one of my worries.

> Or any other issue with short read/recv? Can you explain in detail?

To sum up design wise, when members that are using the buffer as a
source, e.g. write/send, fail, the user is expected to usually reissue
both the write and the ublk cmd.

Let's say you have a ublk leader command providing a 4K buffer, and
you group it with a 4K send using the buffer. Let's assume the send
is short and does't only 2K of data. Then the user would normally
reissue:

ublk(4K, GROUP), send(off=2K)

That's fine assuming short IO is rare.

I worry more about the backward flow, ublk provides an "empty" buffer
to receive/read into. ublk wants to do something with the buffer in
the callback. What happens when read/recv is short (and cannot be
retried by io_uring)?

1. ublk(provide empty 4K buffer)
2. recv, ret=2K
3. ->grp_kbuf_ack: ublk should commit back only 2K
    of data and not assume it's 4K

Another option is to fail ->grp_kbuf_ack if any member fails, but
the API might be a bit too awkward and inconvenient .

-- 
Pavel Begunkov

