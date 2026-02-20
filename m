Return-Path: <io-uring+bounces-12346-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id DX23OUJZmGnLGgMAu9opvQ
	(envelope-from <io-uring+bounces-12346-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 13:53:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DEA1679F7
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 13:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8304D3014A08
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 12:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CC4342177;
	Fri, 20 Feb 2026 12:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxrjDOwU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A915A30DD3B
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591996; cv=none; b=a5JFzNf0TdgisSrz1wTyuCU3zSA3h9E96vg27j3bZTzHOC3m4dn6ppdm9XwvCUA0pUbxPR9j0B5rjik3ZrlueeXk5+9os6UDBFjt5HAJMmnRJhklltSqvPIknwyqMo9jo80mq1HXXavVQp1wNr0KYPKEjCMtY6FHqFoOtNU1pzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591996; c=relaxed/simple;
	bh=EofTQyMJ9Re5uG6wY+3NnKmWQD+eONA9pJ3YVyucemo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=cndxrVrOU9QbZeUlbonhT5QWu9CMfOEbuBiLW/e1lgbRBzShFAbcdqRvfGD7no1Vc9elymjvTLHWzaa27IiClLtClzdJwh3gd4frN37SXZcKSh/UDBi6whNZtLBYzu4pLknqy6jV2p+T+8/N5N/BS20omIdRGdm+WP8DxMDX04Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxrjDOwU; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43767807cf3so1534943f8f.1
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 04:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771591993; x=1772196793; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2OR3Y3zmwO62rrO796J5qo5wqKFk0HZtJ3M6GC9gVw8=;
        b=BxrjDOwUg2lT4zusKZ0XoV45YeNsoEe602HkVxVzFO1Zjjbeq7gZ88HIqMhwPCOYkL
         npLTgOzyAPsAplt3I4eGsCPvrRpdShl8wBo+dLuhNMCQEyJFdZ8VPS9Ns7e378tycfBL
         fngoOJazUV1/yltSTkhhgMPHjSLZF7d93J+MfmBpO6dlwM66XutwSVh33lIKpEhwWIji
         RzIeI16JAgiTnAgZkWHdbrvCHN52NOwEycLZbxftkbaktDH6LNxo8BbOESR7JzZ0XoNM
         fMJwykhMERa6529jFIp38euVv2lZlPY/X3SukUMKhw6GolTGHdcJ6kPLnXaFfvYXOP8l
         ttgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771591993; x=1772196793;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2OR3Y3zmwO62rrO796J5qo5wqKFk0HZtJ3M6GC9gVw8=;
        b=fQXljPeGj5UpDQcFviKuM3bs3q8PIwgl9HiC4l5rnKex48O2L9CoUKDRABOPzXY8M/
         nWW2CCBw4Orq758p4QPP1vvrDmIGEWW25U3pgyHVGi8Ioa8dO9CmB+YqHEQ2IRhHoGBw
         87xpEg666TquEvmFHo2zDl4xtRvUgfBSqAI6KBkGacgQxt8irOdJEH5mXAQK9SETj5pb
         BikYCqropQVFPWKaIis/N9vdAfIAR1/w2cGgE9WNhvvRVd0tzdTHOnEKn+kF4Eha6H6M
         mJi4Cw9Nkr5u+ZXjopPRxI+myqlqflrR8ro9uUohcW1K82cH4hdaGfd6//iP6Cl1Q9wn
         Vthg==
X-Forwarded-Encrypted: i=1; AJvYcCXkCE4fGnc+h3bm8bCH4LA8OejPFedvDUfaxFCc6EKBxJ02P9nukkU3WM2ONhmPUHJPd0wsd63JIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfpODgIwNK6GJNmgtvmmYOYC/Xjif2cMuB0CQZovQQH0Z1jn2J
	e+lnpO7M8ojf9ifSxZsOMkPjwDeztHg1emV2J0h1JDQQCFMdZ4cfBrXE
X-Gm-Gg: AZuq6aKxLac8GOBPhJmZM0G368tJpJe4BeEdZ5vqRzR2tvdvbY3geqS2zHX9MZATIxP
	xFsddVQguf5A8El/EEnFEjUYnsbG35yUVadsp4qh+7wqEm+9UJLropSb7Yw8K1iwagQ7tLg6Zt6
	7wQ8PjVUwyY9GIsUK1kNAZ3gloVrJUzHCnvb4xmYKhg4zwNqTan1C2+GOlE69BBui3jfJjLGHtN
	Likt3oaX5XAbdKCY8KZC3l/qvNGgt1TJIFpjsnk0dTEgKi3RzGmdmGqF7eV136C4r4Zo7uBzuH6
	EK/LkLVWa6zc8HIwRCC6t+HPlNG5XN0XatHLVmLmqgwg0aL8AWKyAN8XRXfuomPAcfg0rR2IhyV
	UPPKonr0mqlCk1q3zJuK8+jkZ3/8exwei11LBONMvDq/ivyyvbRTFYwMpJBmnddD3E9XGzNZYJe
	ReWg9kB5yHpxZLoDHoSUYgc7TjUmZZVw6bT0MK2MXNZgGQelqW9exsajpNqK79I1Fvr9UNQdabn
	OjQp5k7tkvjEaCBla19w5usBBgnzQulcmm0M69AJ39a0/3P51fT2nQKZZc=
X-Received: by 2002:a05:6000:3104:b0:430:f742:fbc7 with SMTP id ffacd0b85a97d-4379db34135mr38510688f8f.14.1771591992624;
        Fri, 20 Feb 2026 04:53:12 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796acffcesm53093237f8f.37.2026.02.20.04.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 04:53:12 -0800 (PST)
Message-ID: <11869d3d-1c40-4d49-a6c2-607fd621bf91@gmail.com>
Date: Fri, 20 Feb 2026 12:53:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
 io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
 bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org>
 <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
 <aY7QX-BIW-SMJ3h_@infradead.org>
 <34cf24a3-f7f3-46ed-96be-bf716b2db060@gmail.com>
 <CAJnrk1a+YuPpoLghA01uJhEKrhmrLhQ+5bw2OeeuLG3tG8p6Ew@mail.gmail.com>
 <7a62c5a9-1ac2-4cc2-a22f-e5b0c52dabea@gmail.com>
 <CAJnrk1Y5iTOhj4_RbnR7RJPkr7fFcCdh1gY=3Hm72M91D-SnyQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAJnrk1Y5iTOhj4_RbnR7RJPkr7fFcCdh1gY=3Hm72M91D-SnyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12346-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05DEA1679F7
X-Rspamd-Action: no action

On 2/18/26 21:43, Joanne Koong wrote:
> On Wed, Feb 18, 2026 at 4:36 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/13/26 22:04, Joanne Koong wrote:
>>> On Fri, Feb 13, 2026 at 4:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> ...
>>>> Fuse is doing both adding (kernel) buffers to the ring and consuming
>>>> them. At which point it's not clear:
>>>>
>>>> 1. Why it even needs io_uring provided buffer rings, it can be all
>>>>       contained in fuse. Maybe it's trying to reuse pbuf ring code as
>>>>       basically an internal memory allocator, but then why expose buffer
>>>>       rings as an io_uring uapi instead of keeping it internally.
>>>>
>>>>       That's also why I mentioned whether those buffers are supposed to
>>>>       be used with other types of io_uring requests like recv, etc.
>>>
>>> On the userspace/server side, it uses the buffers for other io-uring
>>> operations (eg reading or writing the contents from/to a
>>> locally-backed file).
>>
> 
> Sorry, I submitted v2 last night thinking the conversation on this
> thread had died. After reading through your reply, I'll modify v2.

No worries at all, and sorry I'm a bit slow to reply

>> Oops, typo. I was asking whether the buffer rings (not buffers) are
>> supposed to be used with other requests. E.g. submitting a
>> IORING_OP_RECV with IOSQE_BUFFER_SELECT set and the bgid specifying
>> your kernel-managed buffer ring.
> 
> Yes the buffer rings are intended to be used with other io-uring
> requests. The ideal scenario is that the user can then do the
> equivalent of IORING_OP_READ/WRITE_FIXED operations on the
> kernel-managed buffers and avoid the per-i/o page pinning overhead
> costs.

You mention OP_READ_FIXED and below agreed not exposing km rings
an io_uring uapi, which makes me believe we're still talking about
different things.

Correct me if I'm wrong. Currently, only fuse cmds use the buffer
ring itself, I'm not talking about buffer, i.e. fuse cmds consume
entries from the ring (!!! that's the part I'm interested in), then
process them and tell the server "this offset in the region has user
data to process or should be populated with data".

Naturally, the server should be able to use the buffers to issue
some I/O and process it in other ways, whether it's a normal
OP_READ to which you pass the user space address (you can since
it's mmap()'ed by the server) or something else is important but
a separate question than the one I'm trying to understand.

So I'm asking whether you expect that a server or other user space
program should be able to issue a READ_OP_RECV, READ_OP_READ or any
other similar request, which would consume buffers/entries from the
km ring without any fuse kernel code involved? Do you have some
use case for that in mind?

Understanding that is the key in deciding whether km rings should
be exposed as io_uring uapi or not, regardless of where buffers
to populate the ring come from.

...
> With it going through a mem region, I don't think it should even go
> through the "pbuf ring" interface then if it's not going to specify
> the number of entries and buffer sizes upfront, if support is added
> for io-uring normal requests (eg IORING_OP_READ/WRITE) to use the
> backing pages from a memory region and if we're able to guarantee that
> the registered memory region will never be able to be unregistered by
> the user. I think if we repurpose the
> 
> union {
>    __u64 addr; /* pointer to buffer or iovecs */
>    __u64 splice_off_in;
> };
> 
> fields in the struct io_uring_sqe to
> 
> union {
>    __u64 addr; /* pointer to buffer or iovecs */
>    __u64 splice_off_in;
>    __u64 offset; /* offset into registered mem region */
> };
> 
> and add some IOSQE_ flag to indicate it should find the pages from the
> registered mem region, then that should work for normal requests.
> Where on the kernel side, it looks up the associated pages stored in
> the io_mapped_region's pages array for the offset passed in.

So you already can do all that using the mmap()'ed region user
pointer, and you just want it to be more efficient, right?
For that let's just reuse registered buffers, we don't need a
new mechanism that needs to be propagated to all request types.
And registered buffer are already optimised for I/O in a bunch
of ways. And as a bonus, it'll be similar to the zero-copy
internally registered buffers if you still plan to add them.

The simplest way to do that is to create a registered buffer out
of the mmap'ed region pointer. Pseudo code:

// mmap'ed if it's kernel allocated.
{region_ptr, region_size} = create_region();

struct iovec iov;
iov.iov_base = region_ptr;
iov.iov_len = region_size;
io_uring_register_buffers(ring, &iov, 1);

// later instead of this:
ptr = region_ptr + off;
io_uring_prep_read(sqe, fd, ptr, ...);

// you use registered buffers as usual:
io_uring_prep_read_fixed(sqe, fd, off, regbuf_idx, ...);


IIRC the registration would fail because it doesn't allow file
backed pages, but it should be fine if we know it's io_uring
region memory, so that would need to be patched.

There might be a bunch of other ways you can do that like
create a kernel allocated registered buffer like what Cristoph
wants, and then register it as a region. Or allow creating
registered buffers out of a region. etc.

I wanted to unify registered buffers and regions internally
at some point, but then drifted away from active io_uring core
infrastructure development, so I guess that could've been useful.

> Right now there's only a uapi to register a memory region and none to
> unregister one. Is it guaranteed that io-uring will never add
> something in the future that will let userspace unregister the memory
> region or at least unregister it while it's being used (eg if we add
> future refcounting to it to track active uses of it)?

Let's talk about it when it's needed or something changes, but if
you do registered buffers instead as per above, they'll be holding
page references and or have to pin the region in some other way.

> If so, then end-to-end, with it going through the mem region, it would
> be something like:
> * user creates a mem region for the io-uring
> * user mmaps the mem region

FWIW, we should just add a liburing helper, so that fuse server
doesn't need to deal with mmap'ing.

> * user passes in offset into region, length of each buffer, and number
> of entries in the ring to the subsystem
> * subsystem creates a locally managed bufring and adds buffers to that
> ring from the mem region

That's sounds clean to me _if_ it allows you to achieve all
(fast path) optimisations you want to have. I hope it does?

-- 
Pavel Begunkov


