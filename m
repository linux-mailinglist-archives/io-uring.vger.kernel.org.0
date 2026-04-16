Return-Path: <io-uring+bounces-13059-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKCGKnQ14WkEqgAAu9opvQ
	(envelope-from <io-uring+bounces-13059-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 21:16:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DED8E41402F
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 21:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 358EF30036C4
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 19:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955B8332EBA;
	Thu, 16 Apr 2026 19:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b="IeQObM27"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22233101D8
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776366826; cv=none; b=Vh0uM4Opl0+68F9/nWrujcGoMEx/kItmLAYLh1j86Ni2me54HbNA+iUMOkQv/W7DfacD2eMz6g02cGFqtx8z3WE748wQ3quTVsrmxCwFN9vbe5imJOlEIpLzwVU6fkRYHDqh9ze4414qmSt1qPw0PVqBjc15zD0C4MynqJgEbmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776366826; c=relaxed/simple;
	bh=7Ryr0EbJzLMUU5S88vGtGENgrAciFzpXy5Rh+SxezsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EU1b94KaV/wTcv3AiVYZWcx7D5oLJBBSbC6WsVvNXFbRekHrF4+9RHo9MAT4AE90R0l9nZVP+mrE/4nBqi1ytd4lWpg2fFz1+YCCp7ZOQPvyNtZcT8owcUeWxX0hNOG5FS7py8Httox6k8uOcndaQ1a3m+MBQyIuQhD2A2I2WFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io; spf=none smtp.mailfrom=niova.io; dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b=IeQObM27; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=niova.io
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d64313c39so4970513f8f.3
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 12:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=niova.io; s=google; t=1776366823; x=1776971623; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i6TN1leRKVUDgjr8ZiyEfgP4Hfk4jw9C0F8qVnEJca8=;
        b=IeQObM27TuzTXdA7haUGjQZWkzrNoXRPpTZ1Byb+wOUtz2xBmBAng+xDjPDYLFQmws
         0ShwTQZLDssseqGt4E9VB5PLkKmGWdsJfTIuTHH9QSsM8lAcSmMaFQtC0QmS+SNByFRm
         oeYK3vHx+J87ITQ1GucRzkHK9NdkdZoTjJkjUCIkKZvp7DUnzRDeaOZmMaJNCQwv02IE
         fUaawN5ZOnhrfh4DrztiWGzIKX2YPbN0yc3sEBtUnNlSTf5d00xbd6MnzHsZPW0m5VjD
         sI845ZvhPlXVxxjh5seiEF2GrMzvYP2abJe7yqhmIxqNazudc/0Lg6Q6CSr4FV0mKYN1
         OUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776366823; x=1776971623;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6TN1leRKVUDgjr8ZiyEfgP4Hfk4jw9C0F8qVnEJca8=;
        b=TuOxGAohoV8xb77d9+T+iYHVISTt0MYXqSVvUFYhmkTV0MDpxTJNVSETB4Ox9TFY+T
         /yalBXwqCTb9my30J5y11hfKY8m7W3zNU2StH7VdQFxkuPyNnXNxac2+SLlWFRc3c/9W
         MgK47iR1RkrVB3FibWGApQHuwDQN+Q79EGa2HapRmdM7sUUGDBEQJoN1lBqI/mLgjw9V
         o7q/F4FRkzZoeZNcHdgttoIoLKftyMk3WazqqcoeGPPRgDg/hr3hpfH6PbE/WNyvhK26
         gGtbbpOIXZikyH7RhFtaUF3SW39rloE4NONGRXZpezhVbJ8e0wq/NV93hRWcUZ/oCr0E
         rPLA==
X-Forwarded-Encrypted: i=1; AFNElJ/+dRpEcI2Ghy+9OldYWlFMRmgb9219gRc3/na8hLbSgGMjlfeLTP8CuAc1zho/Q2tY0qNi4hsMOw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYWcKpeIEg6XkNeR4Kk0RKbhx9YLyLUFpd0gOwuisLlYODz4bO
	AlJtSWL/ftWPx4CFrzhQTjnS19uZqQfCQFvsdslc2qIBJ5VorVuDlNFQNEy5F4/HJP0=
X-Gm-Gg: AeBDieuwl78SalQY1pQWha73I+RuC66sLUOMpt62bp9SEW3gd9yQWo1Ajmuodi0OoV3
	0Il8rHVJBdgZjRJXJ/Ejh2M0NWcUsdg/vz8ZMd5vztTlnHb8AU35wM7QNslVHe70Le+7H/R79qe
	jhkPWDUuWyklGOqhbmDSjS+dlnIqu5ttZrjE4J6qIm+HH+G7Yc6St4EGvJlD0ykfHiGdYNKtUdq
	QmL4Y8dUMUnd5dvVij377lKOBjoSI5HULjooZzP1e0dU+HqPCkyRiMUvk4wluJEHxSxlGxWhrJJ
	1xQemPOiMavPJKvGzE/uYuKbv2wfLbSoOR2BxViq7Yp6zH9aMppGzSWq6JJbsIjZr1JCeWP/oWV
	W2VuJo/CsFVUVHGROclxDTdK4Av7C6g1MxU92Gc5nPsVPno1/QpV2FMxVTdfKowEOl6xK1KDR/C
	4B5s8Yl3EnN97UAF73L7XK19+rox1bPOJKzvX0KBN/RXbjDcpxiVzYeauTTs0wJfKfncgYk640s
	gKIZnDXTjGWQ7rOVN3OrhGvET0Di9l3/yptXTQn3nxGymnZppEKe50xYN/f4nPIXWE=
X-Received: by 2002:a5d:5d83:0:b0:43d:77e1:6a66 with SMTP id ffacd0b85a97d-43fe0eab61amr866986f8f.8.1776366822921;
        Thu, 16 Apr 2026 12:13:42 -0700 (PDT)
Received: from ?IPV6:2a01:cb00:1870:d900:94b2:a916:840e:ca2f? (2a01cb001870d90094b2a916840eca2f.ipv6.abo.wanadoo.fr. [2a01:cb00:1870:d900:94b2:a916:840e:ca2f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3553d7sm15793819f8f.9.2026.04.16.12.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 12:13:42 -0700 (PDT)
Message-ID: <55db9a65-4408-42d2-8958-3bf3aa79d554@niova.io>
Date: Thu, 16 Apr 2026 21:13:41 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, fuse-devel@lists.linux.dev,
 Joanne Koong <joannelkoong@gmail.com>, io-uring <io-uring@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
 <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io> <aeEE4FVGdi5RqKs_@fedora>
From: Bernd Schubert <bernd@niova.io>
Content-Language: en-US
In-Reply-To: <aeEE4FVGdi5RqKs_@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[niova.io:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13059-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,lists.linux.dev,gmail.com,vger.kernel.org,kernel.dk,szeredi.hu];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[niova.io];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[niova.io:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@niova.io,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DED8E41402F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 4/16/26 17:48, Ming Lei wrote:
> On Thu, Apr 16, 2026 at 04:46:01PM +0200, Bernd Schubert wrote:
>> Hi Ming,
>>
>> On 4/16/26 15:49, Ming Lei wrote:
>>> Hi Bernd,
>>>
>>> On Tue, Apr 14, 2026 at 5:33 AM Bernd Schubert <bernd@niova.io> wrote:
>>>>
>>>> Hi Joanne, et al,
>>>>
>>>> this is a bit of duplication of the discussion we had before, but I was
>>>> badly distracted with other work and also switching employer - didn't
>>>> manage to reply [1].
>>>>
>>>>
>>>> I'm still not too happy about kBuf and its restriction of locked-only
>>>> memory. Right now I'm reviewing your patches from the view of what needs
>>>> to be done for ublk (for my current employer) and also for fuse to
>>>> support different buffer sizes. Let's say fuse only support kBuf and its
>>>> restriction of pinned memory, I think we would be forced to add support
>>>> for different buffer sizes to the current ring-entry-provides-the-buffer
>>>> and the new kBuf interface - from my point of view code dup.
>>>> If we would allow pBuf for fuse, we could put the current
>>>> 'ring-entry-provides-the-buffer' interface into maintenance mode and
>>>> support new features with the new interface only. I know you disagree on
>>>> using pBuf [1] with the argument that userspace could free the buffer.
>>>> Well, if it does, it does something totally wrong and the same could
>>>> happen today over /dev/fuse and also the existing fuse-over-io-uring.
>>>> Just the window is smaller, as the pages are extracted from the buffer
>>>> during the copy.
>>>>
>>>> I was looking into what would be needed to support pBuf and I think
>>>> io-uring could extract pages from pBuf when the buffer is obtained - it
>>>> would limit the window when userspace can do something wrong in a
>>>> similar way current fuse and ublk works.
>>>>
>>>> Suggested changes:
>>>>
>>>> io_uring:
>>>>
>>>>   - io_pin_pages() gets a 'bool longterm' parameter.
>>>> The new pBuf path would pass false, every other exsting caller true.
>>>>
>>>>   - io_ring_buf_pin_user() / io_ring_buf_unpin_user()
>>>>   - io_ring_buf_get_pages()/io_ring_buf_put_pages() -> fills the
>>>> provided bvec
>>>>   - New struct io_ring_buf (in cmd.h)
>>>>
>>>> struct io_ring_buf {
>>>>        size_t                  len;
>>>>        unsigned int            buf_id;
>>>>        unsigned int            nr_bvecs;
>>>>
>>>>        /* private */
>>>>        u64                     addr;
>>>>        u8                      is_pinned;
>>>> };
>>>>
>>>>
>>>> Fuse changes:
>>>>
>>>>   - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_id
>>>>     replaced by io_ring_buf + pre-allocated bvec array.
>>>>   - Buffer selection under queue->lock removed.  The lock only protects
>>>>     request dequeue and entry state transitions.  Page access happens
>>>>     after the lock is dropped, in the context where the copy runs.
>>>>   - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
>>>>     iov_iter_bvec() and would continue to use iov_iter_get_pages2()
>>>>
>>>> What do you think?
>>>>
>>>> And my current primary goal is to let ublk to support multiple buffer
>>>> sizes - ublk would also need to get support for kBuf/pBuf and I'm
>>>
>>> Ublk server is just one liburing application, and it supports all generic
>>> io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
>>> in theory.
>>>
>>> It really depends on how your ublk server is implemented.
>>>
>>> Maybe you can share your motivation first before discussing kbuf/pbuf support.
>>> If it is for DMA,  there are other candidates too, such as hugepage,
>>> recent added
>>> UBLK_U_CMD_REG_BUF, ...
>> Joanne had actually removed kBuf and switched to pBuf alone and that
>> simiplifies things a bit.
>>
>> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
>> saturate streaming bandwidth, but still want to get smaller IOs through,
>> for these smaller IOs you don't want to assign the 1MB buffer for each
>> queue entry / tag.
> 
> Thanks for sharing the motivation.
> 
> Maybe you can pass UBLK_F_USER_COPY, and each IO buffer can be allocated
> dynamically completely from userspace, then pre-allocation can be avoided.

I had looked into, but that is still another syscall / roundtrip, will
have the same performance issue as UBLK_F_NEED_GET_DATA and probably
worse because compared to ring IO that is a syscall per IO.

> 
>> Zero copy is currently still out of question for us, although I will
>> look into your recent work for integration of eBPF and if erasure
>> coding, compression and checksums could be done with that (I guess
>> checksums is the easy part).
> 
> Got it, compression could be the hardest one, however, the recent added bpf
> iterator based buffer interface may simplify everything. I'd suggest you to look
> at it, and provide some feedback if possible.
> 
> Also if your client application uses direct IO, recent added UBLK_F_SHMEM_ZC
> could simplify implementation a lot, meantime with zero copy & user-mapped
> address.

Oh I see, that was just merged. Nice, thank you! I don't our users will
be DIO only, but nice to have that ZC option!


Thanks,
Bernd

