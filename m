Return-Path: <io-uring+bounces-13032-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 7kzNL7Ri3WnmdQkAu9opvQ
	(envelope-from <io-uring+bounces-13032-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 23:40:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA413F395A
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 23:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F92C302BDCB
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2026 21:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA49039527C;
	Mon, 13 Apr 2026 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b="XPESXSFI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0FF395256
	for <io-uring@vger.kernel.org>; Mon, 13 Apr 2026 21:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776116033; cv=none; b=Am5WTjxO+gkKIioIQ/i759IlsQZ9SHbLOo7AI4Gxj0bG/iYyNt9X8MG2CSJGGevs6c9oLwQpGrcibJ71e+WleGyhxbod1DbZJ8gLRCklgxfbw7y2T+LgC25pRLfOyY4OsfYBeW/eWkbDvBaQW2S5ur4PscWkz9PN1DR/opKtwFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776116033; c=relaxed/simple;
	bh=E/RZF3fthkTE+ZcEUowB9eO2oQsp/Kexn7L4bb4z1uc=;
	h=Message-ID:Date:MIME-Version:To:From:Cc:Subject:Content-Type; b=eYQQgrhmTmuw3nIyvV7VEemZD6PH3lZlr0WQ9wpXi2n2Pe43QDf/nAGyhKRj5gJ63gfXH2wYytfOfobrmDjAe7iq93R+p79VIfHkvMoRDRtEiqx/y+gdLkAVHQXC2KVe1D+3NJQURBJAF4rMZkiz+7RpTvihR4dHoSMXX8aUPi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io; spf=none smtp.mailfrom=niova.io; dkim=pass (2048-bit key) header.d=niova.io header.i=@niova.io header.b=XPESXSFI; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=niova.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=niova.io
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d77f6092eso1105042f8f.2
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2026 14:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=niova.io; s=google; t=1776116030; x=1776720830; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:cc:from:to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vzv1DWYUygqhcbUAlLqvn4fRhhrF9M7ub6xcGkeJWuo=;
        b=XPESXSFIUiWyD4LtZDICMUe9Xuo5I7hJgqdc+4BBs80+c+hzFTBClaYqTyn5iQGq6p
         nkKhi9oaJKvj6c+DIdj5UZL0f7B/C3fTcs6+3yNXO+UEU74dMxWnsYsuDQ1jj0aFnpEP
         f50VK/1vhHwFwTuaNr8N+xZZ2CgKSIlatnV89iIb1ZnDVx0d+pzLmYQbRHY4JDROwYCR
         aK7YimzuVyzMPBsSy+jhRmZm75ity1bLtfSb9gq20jp/wnP24kYJUtlW5rIatjWS9kb0
         fX1HsVlpAwycEq5rD5gP8jjQM1G4Uz4s7WCBihOK2qfHQvgfZj1WFH+jM1rcJnvPaaZE
         8kWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776116030; x=1776720830;
        h=content-transfer-encoding:subject:cc:from:to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vzv1DWYUygqhcbUAlLqvn4fRhhrF9M7ub6xcGkeJWuo=;
        b=VHwMioZKrCTK8Ev4v7ryWD0VNP51vdUWNE2kY8aIIWYC+Vij+Nz3lBn8X52yBEGlga
         Aguvqkyh4TInI1w7WobeILCXMH0PAJVvU1zbAPhGcfJvduwwWgNmztAj/nfdWgpcYlDD
         Hzueu40y0sTWTX25+d+QdfreYOFhKp1VPHLy8L/vDxSd0VHXtUwvJzl1vpurzz6epx0X
         yFWBxMcEiagaEtTAsjVQ6+C0s2OTr6tPzlYrj/g2F9bfoa2LeqYc8eEOCXXsu8fAaIoq
         IpOcRoy6tew1G+BjFkuQTSFQ+UPxswHcXQSBfqNn6K9tnNZS+zbw6WhzlXQxB71SbIv/
         WAZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+qTOpA8TBHxv3GUZVtGErC5lNHdv2R8uQuabH9X4fk89PfVjGxXvtMSuNpBW6cJf8M3mkvRybLA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu1WF+MXxvyyF0Ku6LlB27kWfXolBa0U+cnkUDUulxXYIHRBH/
	IFoBwWOHFGmly5mk2fpZg3afr5Umf4SbAiBSxeDIfWJgQyNaiuFAfdT7NyWZ0pL9CTBT7spG7jr
	4LeT6
X-Gm-Gg: AeBDiesK9tpEZU7Ic7x/MkW9gTqOPdhF3zyIJ7SW/Z4eVpZ3O67NfAB/W97FXfoYOhg
	UNB2N7au9CTlu54QHir0NoBnXyZGhPY2dgnqqQ+/Psw1vCfD0xPPl/VSvFbw7m4AB3m0qwbhqZm
	NJaaUVOzxMRjjOeRbBU57lvmt+TzSlTU2h/vcPACNeNXqPleRbgqKzikkIRLcfPMrh7XMjYvUYW
	/v17j9XsaFYooQBlpPXgezIROk2HMnBVBG6KYn1UNn/j+/hzo+M8/cOaA0gLd47PKM/3dZ/QFWA
	NE6Vk33IoOKTGYP8e7aMjfdZRSW44/kBuwuUyjT9lyw4ZiSXw7MvLr9R6p0oOsu//EYn8zTuyH4
	UBryV5RJXpyXI1hEzRCFeliA4NHgz9qObMMzu0orYdsoAxCxgQR2erPh+Wiwoi1c1UQXUQfp3h8
	wB1mrZlrF4/amX52ULqh89ShZ7NthvehHeL0l0u7lh+mdLOhjFZkDyjZ2QiM7kmn1sckw7Mc73i
	moaluqcZdeOlBTvvP8ZjZ/0/4Eaimv59YMr5v8HiZZUPeeGg5mBYcPB
X-Received: by 2002:a05:6000:1ac5:b0:43c:fa96:d939 with SMTP id ffacd0b85a97d-43d6429c737mr22577854f8f.22.1776116030111;
        Mon, 13 Apr 2026 14:33:50 -0700 (PDT)
Received: from ?IPV6:2a01:cb00:1870:d900:6453:5464:a83f:ca58? (2a01cb001870d90064535464a83fca58.ipv6.abo.wanadoo.fr. [2a01:cb00:1870:d900:6453:5464:a83f:ca58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7b543057sm8725777f8f.6.2026.04.13.14.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 14:33:49 -0700 (PDT)
Message-ID: <18936160-308a-4817-a295-54eef43707a3@niova.io>
Date: Mon, 13 Apr 2026 23:33:48 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: fuse-devel@lists.linux.dev
From: Bernd Schubert <bernd@niova.io>
Cc: Joanne Koong <joannelkoong@gmail.com>, io-uring
 <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>
Subject: fuse/io-uring: Proposal to support pBuf in additon to kBuf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[niova.io:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk,redhat.com,szeredi.hu];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13032-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[niova.io];
	DKIM_TRACE(0.00)[niova.io:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@niova.io,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,niova.io:dkim,niova.io:mid]
X-Rspamd-Queue-Id: 1DA413F395A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Joanne, et al,

this is a bit of duplication of the discussion we had before, but I was
badly distracted with other work and also switching employer - didn't
manage to reply [1].


I'm still not too happy about kBuf and its restriction of locked-only
memory. Right now I'm reviewing your patches from the view of what needs
to be done for ublk (for my current employer) and also for fuse to
support different buffer sizes. Let's say fuse only support kBuf and its
restriction of pinned memory, I think we would be forced to add support
for different buffer sizes to the current ring-entry-provides-the-buffer
and the new kBuf interface - from my point of view code dup.
If we would allow pBuf for fuse, we could put the current
'ring-entry-provides-the-buffer' interface into maintenance mode and
support new features with the new interface only. I know you disagree on
using pBuf [1] with the argument that userspace could free the buffer.
Well, if it does, it does something totally wrong and the same could
happen today over /dev/fuse and also the existing fuse-over-io-uring.
Just the window is smaller, as the pages are extracted from the buffer
during the copy.

I was looking into what would be needed to support pBuf and I think
io-uring could extract pages from pBuf when the buffer is obtained - it
would limit the window when userspace can do something wrong in a
similar way current fuse and ublk works.

Suggested changes:

io_uring:

  - io_pin_pages() gets a 'bool longterm' parameter.
The new pBuf path would pass false, every other exsting caller true.

  - io_ring_buf_pin_user() / io_ring_buf_unpin_user()
  - io_ring_buf_get_pages()/io_ring_buf_put_pages() -> fills the
provided bvec
  - New struct io_ring_buf (in cmd.h)

struct io_ring_buf {
       size_t                  len;
       unsigned int            buf_id;
       unsigned int            nr_bvecs;

       /* private */
       u64                     addr;
       u8                      is_pinned;
};


Fuse changes:

  - fuse_ring_ent (bufring union side): payload_kvec and ringbuf_buf_id
    replaced by io_ring_buf + pre-allocated bvec array.
  - Buffer selection under queue->lock removed.  The lock only protects
    request dequeue and entry state transitions.  Page access happens
    after the lock is dropped, in the context where the copy runs.
  - setup_fuse_copy_state bufring branch: is_kaddr/kaddr replaced by
    iov_iter_bvec() and would continue to use iov_iter_get_pages2()

What do you think?

And my current primary goal is to let ublk to support multiple buffer
sizes - ublk would also need to get support for kBuf/pBuf and I'm
current assuming that fuse and ublk rings should just get multiple
kBufs/pBufs and a config options that mapps bufs to io-size. I'm still
looking into details for that.


Thanks,
Bernd


[1]
https://lore.kernel.org/r/CAJnrk1armV9VzBqrrdfr15K5ySBx2YJRk_P0okGnkzyMx_eDOw@mail.gmail.com



