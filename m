Return-Path: <io-uring+bounces-6003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC48A16274
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 16:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D61D77A1764
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 15:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C551DE8BA;
	Sun, 19 Jan 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2mwqHq/x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A2EBE40
	for <io-uring@vger.kernel.org>; Sun, 19 Jan 2025 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737299134; cv=none; b=pj485IjBv/nJvDUVJ526KLZVVvWSw++PmEj633B1qVUr7+nXzTr9U7Zn+FPhr9X+k/CIZ5CbEEDYkGXZy4O5uGzcEqEaGErsYBLJBYfpq/T0WwoAMEbN9V3FCeFeHzLNrT7BgC2M5zooigWHvkdxKN++UXYXUm1FltcpDm9E3yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737299134; c=relaxed/simple;
	bh=nw4nOySZCLG6nNgTqgR8mJT+GoEiiuKbpgFewhHoM0I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=A+CVQsPxrYZEx9LEIT2KJ34qUA6KiPdmU3n1B1GtCZV73v2sMirik8acDK9+1oWlfEAeVwtVTkF85HdjXriTf0KtstrxCJ+A5HQWD6kxAuaO+isWDPtWzRfWTSS5TUI/q5sQ/fCCo/MWDxSS6A6JerOks6esLMWywJ1p0ZRYhiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2mwqHq/x; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21670dce0a7so79587505ad.1
        for <io-uring@vger.kernel.org>; Sun, 19 Jan 2025 07:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737299129; x=1737903929; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzM7b7WFB5w1IEFKpsehzOCh1mcYooHig014PllTVeU=;
        b=2mwqHq/xaY3fk1eiPL6SJJ5aufg5iiJleMir/PYm4bvbYOnwRJEZVZtTZAZN5SQ3r3
         beRUHdXT9EjLt68MJwSFJlXSOGUu6wEYq+DKmijYmYzHqLfGLUNcEB++sjhc8TMYRViL
         MgcGevT7iX2Fc9CjzO0lwszllINuaZIXp+yjVPTJP0jgRM3ynJPg2FJZZzo/F+b/6MQT
         YabSGcWtZhmi94fTdEPF7H7eIPWZ5Pfas++beYqdwmNTafKrDnrxkKyNrH7cVHI9Hpx0
         W5mqtlpdgVIScfgR5+eiuw1MxJN4VWNSzDhB1X7X2lT1XH5ewYA6rM4Xx8WkF5JTA3ZC
         uWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737299129; x=1737903929;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uzM7b7WFB5w1IEFKpsehzOCh1mcYooHig014PllTVeU=;
        b=lripituRJEX1F1abDo3HLYMlJOO7kj3eLHFnld9zRPtQF+UIco3mNcv9KxF/tIFjT1
         IgKBXxzx4dOiGXUqwOxLFjkSib6lR62zevaZ5IBa987GfM16LDHlJ1n3q5/hXIrUBniX
         Pt1oSBM3p6ypmGcd2dkRbuabqzjmuZ659//O+5L2hETIpstm/tYnqz8KZuMOBUkjlGKb
         orqsicgVQf7pB2qPbbSpFyQyRZSSCXk/W8af1zQTlck6OmOCYy4o+lOOx7nFUCq9utLa
         iKLs4i22XxTXwBC1FoiQa/EqMdEwXvBKetPjWmdsEEJfYrvs0VZyhnGPjXK1l1zs8+k4
         B3ZA==
X-Gm-Message-State: AOJu0YwKtxTw9RWy20EqWJlLPmoo9oBtQ07+XYaqsqfeAHM039SE6NrB
	UtLxxpsIxsuB+3fA1KiwYnO3lkSCF/KhRl7WM1VQ1cMOApoaWwub+7balOVAtcgawZKB9pfFPNw
	q
X-Gm-Gg: ASbGncsFZfszyGbylGMyh6tia8yBLikCnFBrbywt3nOaHvaRaf+ysg8JAk7RRZ6+ems
	3sqAj6szl0DuXRUEoghpDekP6nQDkJ+Rj1AN4YQo4vMia/eUkTMAeXd6VNAwRMIfOoY4H/bY+gr
	hQ2FPpkzmGR4Fwc2LCivfvemoOabouzN/6AEyDpWSKjPIQsanclXdSEi7HzwCt9M7ai46sWQkiQ
	vA/Y+OBKZTzRZOsMZhjHrJgkN+Kr2bST18NtKyWB+nZSynQTECEmcR66hj3owb06USM2N4tglBM
	3FkFqX3+jDmKjllzzA7kHVqQxntT0rFOaSH3
X-Google-Smtp-Source: AGHT+IFLy4NrlH1qQeaCOJ1g85RhMDS+6r8wAgt9EdxOCDjn5+RxyxCjfF9ae2zzuwbDXtXAitcpeQ==
X-Received: by 2002:a05:6a20:3d89:b0:1e1:b727:181a with SMTP id adf61e73a8af0-1eb214f0747mr15731825637.24.1737299129352;
        Sun, 19 Jan 2025 07:05:29 -0800 (PST)
Received: from ?IPV6:2600:380:6c18:e44c:3622:e9ea:5693:cb1d? ([2600:380:6c18:e44c:3622:e9ea:5693:cb1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bdd30cbf4sm4308261a12.47.2025.01.19.07.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2025 07:05:28 -0800 (PST)
Message-ID: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
Date: Sun, 19 Jan 2025 08:05:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.14-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring updates for 6.14. Not a lot in terms of features
this time around, mostly just cleanups and code consolidation. In
detail, this pull request contains:

- Support for PI meta data read/write via io_uring, with NVMe and SCSI
  covered.

- Cleanup the per-op structure caching, making it consistent across
  various command types.

- Consolidate the various user mapped features into a concept called
  regions, making the various users of that consistent.

- Various cleanups and fixes.

Note that this will throw a merge conflict, as there's a conflict
between a fix that went into mainline after 6.13-rc4. The
io_uring/register.c one is trivial, the io_uring/uring_cmd.c requires a
small addition. Here's my resolution, while merging it into my for-next
branch:

commit 3761b21b00320fc676aa8f5df8c9158046372b73
Merge: 65a64ecb3357 bab4b2cca027
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Jan 15 08:52:03 2025 -0700

    Merge branch 'for-6.14/io_uring' into for-next
    
    * for-6.14/io_uring: (55 commits)
      io_uring: reuse io_should_terminate_tw() for cmds
      io_uring: Factor out a function to parse restrictions
      io_uring/rsrc: require cloned buffers to share accounting contexts
      io_uring: simplify the SQPOLL thread check when cancelling requests
      io_uring: expose read/write attribute capability
      io_uring/rw: don't gate retry on completion context
      io_uring/rw: handle -EAGAIN retry at IO completion time
      io_uring/rw: use io_rw_recycle() from cleanup path
      io_uring/rsrc: simplify the bvec iter count calculation
      io_uring: ensure io_queue_deferred() is out-of-line
      io_uring/rw: always clear ->bytes_done on io_async_rw setup
      io_uring/rw: use NULL for rw->free_iovec assigment
      io_uring/rw: don't mask in f_iocb_flags
      io_uring/msg_ring: Drop custom destructor
      io_uring: Move old async data allocation helper to header
      io_uring/rw: Allocate async data through helper
      io_uring/net: Allocate msghdr async data through helper
      io_uring/uring_cmd: Allocate async data through generic helper
      io_uring/poll: Allocate apoll with generic alloc_cache helper
      io_uring/futex: Allocate ifd with generic alloc_cache helper
      ...
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --cc io_uring/register.c
index 371aec87e078,4d507a0390e8..6efbeee734a9
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@@ -403,11 -396,11 +396,11 @@@ static void io_register_free_rings(stru
  
  static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
  {
+ 	struct io_uring_region_desc rd;
  	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
  	size_t size, sq_array_offset;
 +	unsigned i, tail, old_head;
  	struct io_uring_params p;
- 	void *ptr;
 -	unsigned i, tail;
  	int ret;
  
  	/* for single issuer, must be owner resizing */
@@@ -441,29 -434,26 +434,34 @@@
  	if (size == SIZE_MAX)
  		return -EOVERFLOW;
  
- 	if (!(p.flags & IORING_SETUP_NO_MMAP))
- 		n.rings = io_pages_map(&n.ring_pages, &n.n_ring_pages, size);
- 	else
- 		n.rings = __io_uaddr_map(&n.ring_pages, &n.n_ring_pages,
- 						p.cq_off.user_addr, size);
- 	if (IS_ERR(n.rings))
- 		return PTR_ERR(n.rings);
+ 	memset(&rd, 0, sizeof(rd));
+ 	rd.size = PAGE_ALIGN(size);
+ 	if (p.flags & IORING_SETUP_NO_MMAP) {
+ 		rd.user_addr = p.cq_off.user_addr;
+ 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+ 	}
+ 	ret = io_create_region_mmap_safe(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
+ 	if (ret) {
+ 		io_register_free_rings(ctx, &p, &n);
+ 		return ret;
+ 	}
+ 	n.rings = io_region_get_ptr(&n.ring_region);
  
 -	n.rings->sq_ring_mask = p.sq_entries - 1;
 -	n.rings->cq_ring_mask = p.cq_entries - 1;
 -	n.rings->sq_ring_entries = p.sq_entries;
 -	n.rings->cq_ring_entries = p.cq_entries;
 +	/*
 +	 * At this point n.rings is shared with userspace, just like o.rings
 +	 * is as well. While we don't expect userspace to modify it while
 +	 * a resize is in progress, and it's most likely that userspace will
 +	 * shoot itself in the foot if it does, we can't always assume good
 +	 * intent... Use read/write once helpers from here on to indicate the
 +	 * shared nature of it.
 +	 */
 +	WRITE_ONCE(n.rings->sq_ring_mask, p.sq_entries - 1);
 +	WRITE_ONCE(n.rings->cq_ring_mask, p.cq_entries - 1);
 +	WRITE_ONCE(n.rings->sq_ring_entries, p.sq_entries);
 +	WRITE_ONCE(n.rings->cq_ring_entries, p.cq_entries);
  
  	if (copy_to_user(arg, &p, sizeof(p))) {
- 		io_register_free_rings(&p, &n);
+ 		io_register_free_rings(ctx, &p, &n);
  		return -EFAULT;
  	}
  
@@@ -516,14 -508,12 +516,13 @@@
  	 * Now copy SQ and CQ entries, if any. If either of the destination
  	 * rings can't hold what is already there, then fail the operation.
  	 */
- 	n.sq_sqes = ptr;
- 	tail = READ_ONCE(o.rings->sq.tail);
+ 	tail = o.rings->sq.tail;
 -	if (tail - o.rings->sq.head > p.sq_entries)
 +	old_head = READ_ONCE(o.rings->sq.head);
 +	if (tail - old_head > p.sq_entries)
  		goto overflow;
 -	for (i = o.rings->sq.head; i < tail; i++) {
 +	for (i = old_head; i < tail; i++) {
  		unsigned src_head = i & (ctx->sq_entries - 1);
 -		unsigned dst_head = i & n.rings->sq_ring_mask;
 +		unsigned dst_head = i & (p.sq_entries - 1);
  
  		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
  	}
diff --cc io_uring/uring_cmd.c
index ce7726a04883,d235043db21e..7fb7c0a08996
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@@ -188,14 -163,14 +168,22 @@@ void io_uring_cmd_done(struct io_uring_
  }
  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
  
++static void io_uring_cmd_init_once(void *obj)
++{
++	struct io_uring_cmd_data *data = obj;
++
++	data->op_data = NULL;
++}
++
  static int io_uring_cmd_prep_setup(struct io_kiocb *req,
  				   const struct io_uring_sqe *sqe)
  {
  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 -	struct uring_cache *cache;
 +	struct io_uring_cmd_data *cache;
  
- 	cache = io_uring_async_get(req);
- 	if (unlikely(!cache))
 -	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req, NULL);
++	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req,
++						io_uring_cmd_init_once);
+ 	if (!cache)
  		return -ENOMEM;
  
  	if (!(req->flags & REQ_F_FORCE_ASYNC)) {


Please pull!


The following changes since commit 4bbf9020becbfd8fc2c3da790855b7042fad455b:

  Linux 6.13-rc4 (2024-12-22 13:22:21 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.14/io_uring-20250119

for you to fetch changes up to 561e3a0c40dc7e3ab7b0b3647a2b89eca16215d9:

  io_uring/fdinfo: fix io_uring_show_fdinfo() misuse of ->d_iname (2025-01-19 07:28:37 -0700)

----------------------------------------------------------------
for-6.14/io_uring-20250119

----------------------------------------------------------------
Al Viro (1):
      io_uring/fdinfo: fix io_uring_show_fdinfo() misuse of ->d_iname

Anuj Gupta (8):
      block: define set of integrity flags to be inherited by cloned bip
      block: modify bio_integrity_map_user to accept iov_iter as argument
      fs, iov_iter: define meta io descriptor
      fs: introduce IOCB_HAS_METADATA for metadata
      io_uring: introduce attributes for read/write and PI support
      block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
      scsi: add support for user-meta interface
      io_uring: expose read/write attribute capability

Bui Quang Minh (2):
      io_uring/rsrc: simplify the bvec iter count calculation
      io_uring: simplify the SQPOLL thread check when cancelling requests

Christoph Hellwig (1):
      block: copy back bounce buffer to user-space correctly in case of split

Colin Ian King (1):
      io_uring/kbuf: fix unintentional sign extension on shift of reg.bgid

David Wei (1):
      io_uring: clean up io_prep_rw_setup()

Gabriel Krisman Bertazi (9):
      io_uring: Fold allocation into alloc_cache helper
      io_uring: Add generic helper to allocate async data
      io_uring/futex: Allocate ifd with generic alloc_cache helper
      io_uring/poll: Allocate apoll with generic alloc_cache helper
      io_uring/uring_cmd: Allocate async data through generic helper
      io_uring/net: Allocate msghdr async data through helper
      io_uring/rw: Allocate async data through helper
      io_uring: Move old async data allocation helper to header
      io_uring/msg_ring: Drop custom destructor

Jann Horn (1):
      io_uring/rsrc: require cloned buffers to share accounting contexts

Jens Axboe (8):
      block: make bio_integrity_map_user() static inline
      io_uring/rw: don't mask in f_iocb_flags
      io_uring/rw: use NULL for rw->free_iovec assigment
      io_uring/rw: always clear ->bytes_done on io_async_rw setup
      io_uring: ensure io_queue_deferred() is out-of-line
      io_uring/rw: use io_rw_recycle() from cleanup path
      io_uring/rw: handle -EAGAIN retry at IO completion time
      io_uring/rw: don't gate retry on completion context

Josh Triplett (1):
      io_uring: Factor out a function to parse restrictions

Kanchan Joshi (2):
      nvme: add support for passing on the application tag
      block: add support to pass user meta buffer

Pavel Begunkov (21):
      io_uring: rename ->resize_lock
      io_uring/rsrc: export io_check_coalesce_buffer
      io_uring/memmap: flag vmap'ed regions
      io_uring/memmap: flag regions with user pages
      io_uring/memmap: account memory before pinning
      io_uring/memmap: reuse io_free_region for failure path
      io_uring/memmap: optimise single folio regions
      io_uring/memmap: helper for pinning region pages
      io_uring/memmap: add IO_REGION_F_SINGLE_REF
      io_uring/memmap: implement kernel allocated regions
      io_uring/memmap: implement mmap for regions
      io_uring: pass ctx to io_register_free_rings
      io_uring: use region api for SQ
      io_uring: use region api for CQ
      io_uring/kbuf: use mmap_lock to sync with mmap
      io_uring/kbuf: remove pbuf ring refcounting
      io_uring/kbuf: use region api for pbuf rings
      io_uring/memmap: unify io_uring mmap'ing code
      io_uring: don't vmap single page regions
      io_uring: prevent reg-wait speculations
      io_uring: reuse io_should_terminate_tw() for cmds

 block/bio-integrity.c          |  84 +++++++--
 block/blk-integrity.c          |  10 +-
 block/fops.c                   |  45 +++--
 drivers/nvme/host/core.c       |  21 ++-
 drivers/scsi/sd.c              |   4 +-
 include/linux/bio-integrity.h  |  25 ++-
 include/linux/fs.h             |   1 +
 include/linux/io_uring_types.h |  26 +--
 include/linux/uio.h            |   9 +
 include/uapi/linux/fs.h        |   9 +
 include/uapi/linux/io_uring.h  |  17 ++
 io_uring/alloc_cache.h         |  13 ++
 io_uring/fdinfo.c              |   9 +-
 io_uring/futex.c               |  13 +-
 io_uring/io_uring.c            | 136 +++++++--------
 io_uring/io_uring.h            |  23 +++
 io_uring/kbuf.c                | 226 ++++++++-----------------
 io_uring/kbuf.h                |  20 +--
 io_uring/memmap.c              | 375 ++++++++++++++++++++---------------------
 io_uring/memmap.h              |  23 ++-
 io_uring/msg_ring.c            |   7 -
 io_uring/msg_ring.h            |   1 -
 io_uring/net.c                 |  35 ++--
 io_uring/poll.c                |  13 +-
 io_uring/register.c            | 155 +++++++++--------
 io_uring/rsrc.c                |  40 +++--
 io_uring/rsrc.h                |   4 +
 io_uring/rw.c                  | 212 +++++++++++++----------
 io_uring/rw.h                  |  14 +-
 io_uring/timeout.c             |   5 +-
 io_uring/uring_cmd.c           |  22 +--
 io_uring/waitid.c              |   4 +-
 32 files changed, 833 insertions(+), 768 deletions(-)

-- 
Jens Axboe


