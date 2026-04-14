Return-Path: <io-uring+bounces-13041-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yM3XBb173mkHEwAAu9opvQ
	(envelope-from <io-uring+bounces-13041-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 19:39:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA173FD29F
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 19:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C33A30BE3B3
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 17:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3BA3F074B;
	Tue, 14 Apr 2026 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b="c4De+SRM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9C277C9E
	for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188101; cv=none; b=LmamK5odPdpbdUROm/ADU7gYHcmeSuQnHEwZiocXi1v+xiZV+WCrA86YgaX8upBCnwe5PM80ii80pRKwZuZk5IMgXA5dPyG1SHdDDDoZT6Mruoz29rRKzBDImuJPujzc+/J4JWDHnngV9v8pl99KeHwJrPshJkDnc6QA4I4ezx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188101; c=relaxed/simple;
	bh=k/fx/XpDg9ef1SoW9Lke+j1dWtKF7jcBX0rGpjKTVsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uFW37dUvWn7LGwpVULOdRmryMca3ZzLM5ZBbKOg1g6jLQPahGIDlT/QSMyvJMoSHo6puqkgnUCc6BAC5tS5A3QiWmQvRpFcIhFzbVB7kFcGg7fZPXOIVR0LLFGSLCK0KxZbaYiNLxbLxMRSKjKQX/Px1ZWCqGHdzo2pchsLCT1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io; spf=none smtp.mailfrom=niova.io; dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b=c4De+SRM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=niova.io
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488c2690057so59036635e9.0
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 10:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=niova.io; s=google; t=1776188098; x=1776792898; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U1Z99hOsOR96yTjcxyCVUL0gm5Uf7E1lqAaY79IeWks=;
        b=c4De+SRMXb7os/BCBrpQJDgkDld3gVsBx7G8eHVeXYfzwYOnL7aNvUNl0o1ivAf2/M
         Kr51l6soqVc9FnrHgpA8Paj/Otuyy7KB6X/mM67KAygSl+CYVA1kBfxOdwcW1C/yrZ+k
         uRqH7+1WQJOsRyOLjH0SbVCvZpo5+iAPU9l7zPtyPutX6XDFH/PfEGZ9j3mR9ZAmeTmx
         BrdOH29pceQiKorhiZgQTdhUPZuHppChRIrD0JI9lJ5HZXGbiAJM8HjOcIPhbtdQGH4F
         NA7sxkd1rcUlHA6eOxrYO/Y4CaKBuaiv5THcxcT7kCYa7BgrSO1BYfV0C1yunlD+DVOE
         etOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188098; x=1776792898;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1Z99hOsOR96yTjcxyCVUL0gm5Uf7E1lqAaY79IeWks=;
        b=j8q0l8/jWUUuoZoVLL7Ltplh2Hi1KOXx8OdR84lyS7InyQkB+xYHgbcyn1uhGDz3T/
         2fUc0iwN0xv9BtItSTQR1E/uV74Xi3ii4d82hkFQuOQ4ItddTK7T0Sf1uwpiQNYdjWAS
         +0QaGWhZf1aBkmWbY2ZASLkGDmAm3YRQ4d/GN2aDkUteLP0t449vuhj9GOJMnJM2ADUN
         H2gPB0ATBnXlOEg16zXJ2bA9dwJlftWxa2j4PQUFSWBJt6BYPvFWOpj7krrUgk2N/xRh
         oozQ5EuuYW3FiF1ooHaRHQ+1OtDkR7TXa2OOk+gVAMIu9pZ2f6lPRJTgTlqn5pTC/6ZQ
         f0Pw==
X-Forwarded-Encrypted: i=1; AFNElJ9qvlpg4+6F+k80McXeNfd3QI0K+IbJq8Fquh9lNBNQGowoL9fX2fx0ZCgNxteCEnEEr5qM6uasbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYBk4FEClz/qoR/7aRVyYZifHu76XCXqwyKNFerhdYiw2ge2tA
	eZ+qwSGLY9CbK6hRfoIhafR9l772g1n4k8uvhmqWlPATfkmRzCqt4EuXGnW0ZW27wtk=
X-Gm-Gg: AeBDieuv2Skar5Bpoy4kfgNSNdUa92wwlo9RoWR+QKQAsFWrf5yr4tZ7jgaKtZ1l7UH
	crY/rctrQ0RX/Ak2/k4qU7QGGcuSbMu9W+B6rBfBjluDwmD06Zr59zqHu8tbL70eAL6iQwMrDsa
	dNSpcy8qJoVJGd8YoMem3uxRu5x8+L/SrSJd1aZPOz/OUJFg///OxK7xYIO7jGLpZ7hFnZIE9mR
	Th1RCqXhp8c3/f56imCxk/05Oqav8fosjG6xnSNsqSwBYirJua2U7cYaTpzjRnmGbZtSO+yE2D5
	8DpoguChOIgs+2FaoD/mTY4ukb0uQ1JQ/+TG5pggIy4siFe/andWy+epZgWIGTo5CgSueOGxCWV
	vYLwP7FggSLagAbBkhSs8vdaIv2a3il8lm70ICnE0YQ4zKqnVMs/8WorwtG2uxPN7DDsk/kRDwJ
	H5IYSrqvNkIi5OMHzSj4X0OyO0d4fOMKndEPBqywvnVycFEJ88aXgQRpZFRiiQjIiTl9rauCKuq
	PQy767JDDSLokQi6WmoS5pUF9GMBDabu1ZLjDskxBIp0VnX8hKV5NKU
X-Received: by 2002:a05:600c:4709:b0:488:caed:5ccf with SMTP id 5b1f17b1804b1-488d68af17bmr212020085e9.16.1776188098021;
        Tue, 14 Apr 2026 10:34:58 -0700 (PDT)
Received: from ?IPV6:2a01:cb00:1870:d900:3a0e:fdbe:4a0f:1455? (2a01cb001870d9003a0efdbe4a0f1455.ipv6.abo.wanadoo.fr. [2a01:cb00:1870:d900:3a0e:fdbe:4a0f:1455])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f093d7fdsm1574135e9.2.2026.04.14.10.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:34:57 -0700 (PDT)
Message-ID: <e5553fcf-04bc-49e2-9eb7-17f9007e7fad@niova.io>
Date: Tue, 14 Apr 2026 19:34:56 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Joanne Koong <joannelkoong@gmail.com>
Cc: fuse-devel@lists.linux.dev, io-uring <io-uring@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Ming Lei <ming.lei@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAJnrk1ZknZJQDdJwE5WBK-yZzocMCN_eiCUzxqfHss5ZKBZQ4Q@mail.gmail.com>
From: Bernd Schubert <bernd@niova.io>
Content-Language: en-US
In-Reply-To: <CAJnrk1ZknZJQDdJwE5WBK-yZzocMCN_eiCUzxqfHss5ZKBZQ4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[niova.io:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13041-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,redhat.com,szeredi.hu];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,niova.io:email,niova.io:dkim,niova.io:mid]
X-Rspamd-Queue-Id: 2DA173FD29F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 4/14/26 02:56, Joanne Koong wrote:
> On Mon, Apr 13, 2026 at 2:33 PM Bernd Schubert <bernd@niova.io> wrote:
>>
>> Hi Joanne, et al,
>>
>> this is a bit of duplication of the discussion we had before, but I was
>> badly distracted with other work and also switching employer - didn't
>> manage to reply [1].
>>
>>
>> I'm still not too happy about kBuf and its restriction of locked-only
>> memory. Right now I'm reviewing your patches from the view of what needs
>> to be done for ublk (for my current employer) and also for fuse to
>> support different buffer sizes. Let's say fuse only support kBuf and its
>> restriction of pinned memory, I think we would be forced to add support
>> for different buffer sizes to the current ring-entry-provides-the-buffer
>> and the new kBuf interface - from my point of view code dup.
>> If we would allow pBuf for fuse, we could put the current
>> 'ring-entry-provides-the-buffer' interface into maintenance mode and
>> support new features with the new interface only. I know you disagree on
>> using pBuf [1] with the argument that userspace could free the buffer.
>> Well, if it does, it does something totally wrong and the same could
>> happen today over /dev/fuse and also the existing fuse-over-io-uring.
>> Just the window is smaller, as the pages are extracted from the buffer
>> during the copy.
>>
>> I was looking into what would be needed to support pBuf and I think
>> io-uring could extract pages from pBuf when the buffer is obtained - it
>> would limit the window when userspace can do something wrong in a
>> similar way current fuse and ublk works.
>>
>> Suggested changes:
>>
>> io_uring:
>>
>>   - io_pin_pages() gets a 'bool longterm' parameter.
>> The new pBuf path would pass false, every other exsting caller true.
>>
>>   - io_ring_buf_pin_user() / io_ring_buf_unpin_user()
>>   - io_ring_buf_get_pages()/io_ring_buf_put_pages() -> fills the
>> provided bvec
>>   - New struct io_ring_buf (in cmd.h)
>>
>> struct io_ring_buf {
>>        size_t                  len;
>>        unsigned int            buf_id;
>>        unsigned int            nr_bvecs;
>>
>>        /* private */
>>        u64                     addr;
>>        u8                      is_pinned;
>> };
>>
>>
>> Fuse changes:
>>
>>   - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_id
>>     replaced by io_ring_buf + pre-allocated bvec array.
>>   - Buffer selection under queue->lock removed.  The lock only protects
>>     request dequeue and entry state transitions.  Page access happens
>>     after the lock is dropped, in the context where the copy runs.
>>   - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
>>     iov_iter_bvec() and would continue to use iov_iter_get_pages2()
>>
>> What do you think?
>>
>> And my current primary goal is to let ublk to support multiple buffer
>> sizes - ublk would also need to get support for kBuf/pBuf and I'm
>> current assuming that fuse and ublk rings should just get multiple
>> kBufs/pBufs and a config options that mapps bufs to io-size. I'm still
>> looking into details for that.
> 
> Hi Bernd,
> 
> Thanks for your email. There were some changes made from v1 -> v2, so
> please see the v2 "fuse: add io-uring buffer rings and zero-copy"
> patchset [1], as I think this will hopefully address your concerns
> about mlock. In short, what changed from v1 -> v2 is that I dropped
> the approach where kernel-managed buffers is an io-uring native
> infrastructure. I realized when trying to implement integration
> between the io-uring networking layer and kmbuf rings that kmbufs
> didn't tie in as nicely as I'd thought with io-uring native requests,
> and fuse has too many constraints for the kmbuf ring (locking
> semantics, request lifecycle, etc.) that it made the io-uring side
> less clean; this made me realize this logic would be better off not
> part of io-uring infrastructure and instead self-contained in fuse, as
> Pavel had suggested.
> 
> In v2, the fuse headers and payload buffers are passed as user
> allocations during registration time through the sqe iovs and
> server-side has control over whether to pin the headers or payload
> buffers or both (or pin neither), eg bufrings can be used without
> pinning (no mlock requirement) and pinning is an opt-in optimization.
> Zero-copy requires pinning both headers and payload buffers, as zero
> copy requires CAP_SYS_ADMIN privileges anyways. In this design, the
> buffers are only recyclable by the kernel (unlike pbufs). Unlike pbufs
> where the api contract is that any buffers not explicitly put into the
> ring by userspace are under the full control of userspace and not
> touched by the kernel, this design continues the existing-fuse-uring
> contract that any buffers passed in through sqe iovs during
> registration will be copied to/from the kernel as long as the fuse
> connection is alive. In the future, if the buffers need to be
> kernel-allocated for dma contiguity or other reasons, that could be
> added separately if/when it becomes necessary.
> 
> Does this address your concerns?

yes absolutely it does. I had actually thought that Jens had already
accepted the kBuf changes. I had seen the discussion with Pavel, but
then seen (at least I think) that Jens had accepted it. And with the
different versions, I didn't notice that v2 (in my counting that is v5,
I think), doesn't use kBuf anymore.

If I understand it right, the io-uring bvec changes are only needed for
zero-copy?

Thanks,
Bernd

