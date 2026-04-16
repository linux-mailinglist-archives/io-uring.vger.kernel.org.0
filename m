Return-Path: <io-uring+bounces-13056-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LLTITH24GmInwAAu9opvQ
	(envelope-from <io-uring+bounces-13056-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 16:46:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F189140FBAF
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 16:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1906B3012200
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2026 14:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4943E0258;
	Thu, 16 Apr 2026 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b="Q3wgIxTO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8C3E1201
	for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776350767; cv=none; b=tT5Li8Oy6ExuJvN/PQQYRQYfSzRzxlDRAppWnZrtteF1maOHKWogH/QJSWBTis9W3Q44oMTppw0zIQCCP/RaiiI0M+8LTwRGtn5yXiQkajPLrZ1azC0le+c3nm4EjU+Ues8eFWKF/olYhIW9eSdHseXzepCTmELTyEx/LO2Wb+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776350767; c=relaxed/simple;
	bh=Iu7rAszW8gcKPt7u1RgikFfxCkU1PRfHvp/MYxC7Lsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OiSKOL0XEWo9dQH/zASq2h6kTRAmleBoKsbria1a7zyt1j2p30QjeQjJMqrSgHOKjXstqoC3LVYEIo/tQpcpsLtHSXPzu7h6i1GCAYLyyg74UF1D7Yv4+OFm0o8IE6rF6fOnqcozyzkXAfu1ybilNhL5OgiKQ+3npL1e9QqB0zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io; spf=none smtp.mailfrom=niova.io; dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b=Q3wgIxTO; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=niova.io
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso78967435e9.1
        for <io-uring@vger.kernel.org>; Thu, 16 Apr 2026 07:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=niova.io; s=google; t=1776350763; x=1776955563; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V9G3FogfRLO8BFZzW+KCpfW+F3MEqtQk/jwa+aFkW/I=;
        b=Q3wgIxTOzuN4Yq81sqcZq7eIrZWaovVJW5Wi/ZNx9QbhM5lLpuH9stJdcg2kY0Jrnc
         NYuqcysInB29frt7CJJs2i25+fCGp7+bWWa/b9NNxv/32NszfN7CTre0nO1BvlRnryBI
         DtfwBb3sQMu0i8ZBtCtItDN7qI/LauA45hZX7Kt4eGeJGEHDpLDP2kbM+vZp316V2uNw
         J+1KpoU2zoPjThIgkOYeKnswgqxTNmnRjT7IOdDZ6VqRukMIrwn2NR8ygEY1eSoWfzb2
         NAF68OmmA8w8rQx4BmyxRphm3+iu8rJEvFTxhXdvMc2dMygaNuGOqrT4nBEVXcNeW1ey
         4Gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776350763; x=1776955563;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V9G3FogfRLO8BFZzW+KCpfW+F3MEqtQk/jwa+aFkW/I=;
        b=YwIpuisq2+HOzMrN7Zg1xy7KSUKcScLXvDVW00BC7J5U0rPph71cz1V4AyW8QJXEP8
         /pXul9rFeoqKO8/jSAZl5Z04pbr9Hx9CUB9fF40XHVOH51BxoJuiylAg14FredBkFp4Y
         a6zjsepAS26KNvX7+E396OQEc0dp/mBW3Pnq5meo87TX+GBk4pCFx4Z7+jRwd+ZkF7h0
         9xdQ12XpEqkPSUfhFEZ1S5PJWTBj5fkKe/ALDXx6Le3olha7aR2ASiUDfzobxfpDkPJd
         0vfvYeud/yxIjx1q/pqwgHOFeiA8AjZODj6Y7aHCFumBM7KjIdXIhe8zw5JukYCj8ioI
         K7+g==
X-Forwarded-Encrypted: i=1; AFNElJ9FtmIHYs752ZKyh4zy35RzQ4d3llA1LigbrbzywYiyzPthZ4WhJaYpbIUOMTfPjABMGhpOKqpZtg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxiC+gv8BBt9sUAXpzW0KEk8JxPOwzqBI7B27aGHRkrgAoNyod4
	Dp8ElXNiJ0OaPdOeZxx+1me6jtNRZB5BfhYWzRDRyfnXKQlxpmoGAmeyRoG0vNywuSM=
X-Gm-Gg: AeBDievXmEu5rX4ihOznyseKDqITiGbDAr/0WZSIRadQz2ZQ4z/wTDFolMWOvXUWm+5
	tg+sHHQC7PSKXCG57RUkMAA0EZ7ChErM7H8t2FoXYN7rOcQBWezaxz/4zb92OhfR6JCZHMeZ+Ts
	FXeO8Q8IEKKcJ8Y3wC6zP2e3ozIxdQoxRSnvy2+gu0cSomcxDNeq74U2HZaVsg6NUmPR89IKY3v
	VUBU4jSH8YBRxig0xl0eVi1M1SP6W8Y0X2zF/KMQihiV3LsofSVJ2GOMSI7xDK5Ta3QCHMUJ4sp
	Frfb41mB6noLrgaNHP2IyTeRozwlFdDN0T0zeKzJUzS7W1EZMl1Bilp1JFdxespa99zhDLqVl7h
	4erXAdCn4aUQfCpHSl52oLsp01NcqVqUAb2p2HwrVyxszkKMLcWA2+WGXB6+3ptCqWRiE/ufkd9
	u9vKqxsi05+J5zBl5dr6BE8YoRN+uLH5w5YFqsFU4viyrtZvL97FDeuMvBYjiBVd3qF+PQKm/Tt
	/7VZSPVaMVPIJWE+mD2IChTLSaWtmQOIz0BBTqlO6c3XysFHX/aoT2C
X-Received: by 2002:a05:600d:4:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-488d68ab2bfmr302390335e9.24.1776350763159;
        Thu, 16 Apr 2026 07:46:03 -0700 (PDT)
Received: from ?IPV6:2a01:cb00:1870:d900:94b2:a916:840e:ca2f? (2a01cb001870d90094b2a916840eca2f.ipv6.abo.wanadoo.fr. [2a01:cb00:1870:d900:94b2:a916:840e:ca2f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead33d6d3sm14507663f8f.8.2026.04.16.07.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 07:46:02 -0700 (PDT)
Message-ID: <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
Date: Thu, 16 Apr 2026 16:46:01 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Ming Lei <ming.lei@redhat.com>
Cc: fuse-devel@lists.linux.dev, Joanne Koong <joannelkoong@gmail.com>,
 io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
 "Lei, Ming" <tom.leiming@gmail.com>
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
From: Bernd Schubert <bernd@niova.io>
Content-Language: fr
In-Reply-To: <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[niova.io:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,gmail.com,vger.kernel.org,kernel.dk,szeredi.hu];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13056-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[niova.io];
	DKIM_TRACE(0.00)[niova.io:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@niova.io,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F189140FBAF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Ming,

On 4/16/26 15:49, Ming Lei wrote:
> Hi Bernd,
> 
> On Tue, Apr 14, 2026 at 5:33 AM Bernd Schubert <bernd@niova.io> wrote:
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
> 
> Ublk server is just one liburing application, and it supports all generic
> io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
> in theory.
> 
> It really depends on how your ublk server is implemented.
> 
> Maybe you can share your motivation first before discussing kbuf/pbuf support.
> If it is for DMA,  there are other candidates too, such as hugepage,
> recent added
> UBLK_U_CMD_REG_BUF, ...
Joanne had actually removed kBuf and switched to pBuf alone and that
simiplifies things a bit.

Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
saturate streaming bandwidth, but still want to get smaller IOs through,
for these smaller IOs you don't want to assign the 1MB buffer for each
queue entry / tag.
Zero copy is currently still out of question for us, although I will
look into your recent work for integration of eBPF and if erasure
coding, compression and checksums could be done with that (I guess
checksums is the easy part).

Ublk already has UBLK_F_NEED_GET_DATA, but that has two issues
- needs another round trip (testing on my laptop shows a perf loss of 10
to 15% per queue)
- It does not release the application buffer on read. I have an idea how
to fix that, but here at Niova we would like to go the dynamic memory
appraoch with pBufs to avoid additional round trip overhead.

Idea with pBufs: Several pBufs registered per queue at registration
time. Every pBuf represents a different IO size. Optionally as with
Joannes patches [1] the buffers can get pinned to avoid mapping to pages
for every access.
I'm currently working on a patch series with some luck will sent an RFC
tomorrow. The harder part compared to fuse is that ublk_drv does not
have its own queues/lists so far. This is my first work on block layer -
I'm not sure if internal struct request queuing is allowed at all.
Testing will show in a bit :)


Thanks,
Bernd


[1]
https://lore.kernel.org/linux-fsdevel/20260402162840.2989717-1-joannelkoong@gmail.com/T/#mb8f96895aa2773424005ee06bb62ae980e95e604



