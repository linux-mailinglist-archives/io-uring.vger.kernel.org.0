Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E586EB029
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjDURHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 13:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbjDURHE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 13:07:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C045611D
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 10:06:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b9f00640eso503779b3a.0
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 10:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682096803; x=1684688803;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K0i2kT1CCWSBt8Nt5uv/qO8O5HOGdfM9apX9ZM+3yvg=;
        b=Kzsp541fOCwjYzlEh/BN0zGB9m+FJWe8wbMlvy7WofRvKLRjyOlrbVETA7r/0JUNj8
         WRBONhJMC0UldREFHu/LqXOkdThUOuFg92nLhgRCH/8DlFWuVgmT/H+R8cSuEHCbT8s/
         SS6TZlPrDeiGk1YGd5MY45UBtZ33x01s157MLk9qXCrgROIDpAE4TiEcJrg0OvC+KUPq
         5utaxQdvSSGtlSOHDwljEpd9LGacfmN1QzJVN6qomDL6IbwnThjxhXWVHerCGWhgN1pf
         H0wUhupa3FWsaudrC0vXhKiD0xjX4vnbHDZ9vTPcYOryB+TyiGmjQTz65CuJe3O0neEY
         GMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096803; x=1684688803;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K0i2kT1CCWSBt8Nt5uv/qO8O5HOGdfM9apX9ZM+3yvg=;
        b=A4gEg6Gx8jxkmC8xi7hOOsHu090WgLHfLiY39Z4tEyKjKv6VvoZJay7B6q7/rnTrET
         lNW4zkl8wP2WgcNTg/IODx3RdaOzLPCsurRiMrATMlsgKbnaqMUZRjcu8EQbG6mlaZxv
         mDOCRTYd5EjSgajApFEMuyCHSBRKFi452Ej8Kpzo2jPO5t5icNTLBmjySTSWW79bzGx0
         B9wjUJ3hBKd09CnsaNgxfEWI6WDwgcvi6ttVAhz/yB5mIlAyvO2gHB+jLGrortZDU1v/
         zJ2xg+rDL92+hUbAx8mB9t6+tTM544lHdoYMh+r6DgD5Xv2bZ0ZVWSHx+nIFcNnWwyDS
         TqdA==
X-Gm-Message-State: AAQBX9eT9c4VctcDhxz/NA9DV2ymBGhYLGS8fLcOIyLLGn+SSxlzcafU
        lLLpv+boV0xJGdHYT9wmJX87hu0LEpVjtqLh/Eo=
X-Google-Smtp-Source: AKy350ae0KNAwRn1VlvHMWy7ezaYOPIeu6u3HC2kRsIZ5bEuPWYbjukgE5OUCEFzSXC9b06e2lJHyg==
X-Received: by 2002:a05:6a20:440d:b0:dd:dfe4:f06a with SMTP id ce13-20020a056a20440d00b000dddfe4f06amr6506881pzb.3.1682096803037;
        Fri, 21 Apr 2023 10:06:43 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g9-20020a62f949000000b006334699ee51sm3192208pfm.47.2023.04.21.10.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 10:06:42 -0700 (PDT)
Message-ID: <c674cf90-e193-3fb7-a59f-b427ad6f3f99@kernel.dk>
Date:   Fri, 21 Apr 2023 11:06:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 6.4-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

This is the set of io_uring updates and fixes for the 6.4 merge window.
Nothing major in this one, details below:

- Cleanup of the io-wq per-node mapping, notably getting rid of it so we
  just have a single io_wq entry per ring (Breno)

- Followup to the above, move accounting to io_wq as well and completely
  drop struct io_wqe (Gabriel)

- Enable KASAN for the internal io_uring caches (Breno)

- Add support for multishot timeouts. Some applications use timeouts to
  wake someone waiting on completion entries, and this makes it a bit
  easier to just have a recurring timer rather than needing to rearm it
  every time (David)

- Support archs that have shared cache coloring between userspace and
  the kernel, and hence have strict address requirements for mmap'ing
  the ring into userspace. This should only be parisc/hppa. (Helge, me)

- XFS has supported O_DIRECT writes without needing to lock the inode
  exclusively for a long time, and ext4 now supports it as well. This is
  true for the common cases of not extending the file size. Flag the fs
  as having that feature, and utilize that to avoid serializing those
  writes in io_uring (me)

- Enable completion batching for uring commands (me)

- Revert patch adding io_uring restriction to what can be GUP mapped or
  not. This does not belong in io_uring, as io_uring isn't really
  special in this regard. Since this is also getting in the way of
  cleanups and improvements to the GUP code, get rid of if (me)

- A few series greatly reducing the complexity of registered resources,
  like buffers or files. Not only does this clean up the code a lot, the
  simplified code is also a LOT more efficient (Pavel)

- Series optimizing how we wait for events and run task_work related to
  it (Pavel)

- Fixes for file/buffer unregistration with DEFER_TASKRUN (Pavel)

- Misc cleanups and improvements (Pavel, me)

Please pull for 6.4-rc1!


The following changes since commit 7e364e56293bb98cae1b55fd835f5991c4e96e7d:

  Linux 6.3-rc5 (2023-04-02 14:29:29 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-04-21

for you to fetch changes up to 3c85cc43c8e7855d202da184baf00c7b8eeacf71:

  Revert "io_uring/rsrc: disallow multi-source reg buffers" (2023-04-20 06:51:48 -0600)

----------------------------------------------------------------
for-6.4/io_uring-2023-04-21

----------------------------------------------------------------
Breno Leitao (3):
      io_uring: One wqe per wq
      io_uring: Move from hlist to io_wq_work_node
      io_uring: Add KASAN support for alloc_caches

David Wei (1):
      io_uring: add support for multishot timeouts

Gabriel Krisman Bertazi (2):
      io-wq: Move wq accounting to io_wq
      io-wq: Drop struct io_wqe

Helge Deller (1):
      io_uring: Adjust mapping wrt architecture aliasing requirements

Jens Axboe (13):
      fs: add FMODE_DIO_PARALLEL_WRITE flag
      io_uring: avoid hashing O_DIRECT writes if the filesystem doesn't need it
      io_uring/kbuf: move pinning of provided buffer ring into helper
      io_uring/kbuf: add buffer_list->is_mapped member
      io_uring/kbuf: rename struct io_uring_buf_reg 'pad' to'flags'
      io_uring: add support for user mapped provided buffer ring
      io_uring/kbuf: disallow mapping a badly aligned provided ring buffer
      io_uring/io-wq: drop outdated comment
      io_uring: rename trace_io_uring_submit_sqe() tracepoint
      io_uring: cap io_sqring_entries() at SQ ring size
      io_uring/uring_cmd: assign ioucmd->cmd at async prep time
      io_uring/uring_cmd: take advantage of completion batching
      Revert "io_uring/rsrc: disallow multi-source reg buffers"

Pavel Begunkov (51):
      io_uring: kill unused notif declarations
      io_uring: remove extra tw trylocks
      io_uring: encapsulate task_work state
      io_uring/rsrc: use non-pcpu refcounts for nodes
      io_uring/rsrc: keep cached refs per node
      io_uring: don't put nodes under spinlocks
      io_uring: io_free_req() via tw
      io_uring/rsrc: protect node refs with uring_lock
      io_uring/rsrc: kill rsrc_ref_lock
      io_uring/rsrc: rename rsrc_list
      io_uring/rsrc: optimise io_rsrc_put allocation
      io_uring/rsrc: don't offload node free
      io_uring/rsrc: cache struct io_rsrc_node
      io_uring/rsrc: add lockdep sanity checks
      io_uring/rsrc: optimise io_rsrc_data refcounting
      io_uring/rsrc: add custom limit for node caching
      io_uring: move pinning out of io_req_local_work_add
      io_uring: optimize local tw add ctx pinning
      io_uring: refactor io_cqring_wake()
      io_uring: add tw add flags
      io_uring: inline llist_add()
      io_uring: reduce scheduling due to tw
      io_uring: refactor __io_cq_unlock_post_flush()
      io_uring: optimise io_req_local_work_add
      io_uring: shut io_prep_async_work warning
      io_uring/kbuf: remove extra ->buf_ring null check
      io_uring: add irq lockdep checks
      io_uring/rsrc: add lockdep checks
      io_uring/rsrc: consolidate node caching
      io_uring/rsrc: zero node's rsrc data on alloc
      io_uring/rsrc: refactor io_rsrc_node_switch
      io_uring/rsrc: extract SCM file put helper
      io_uring/notif: add constant for ubuf_info flags
      io_uring/rsrc: use nospec'ed indexes
      io_uring/rsrc: remove io_rsrc_node::done
      io_uring/rsrc: refactor io_rsrc_ref_quiesce
      io_uring/rsrc: use wq for quiescing
      io_uring/rsrc: fix DEFER_TASKRUN rsrc quiesce
      io_uring/rsrc: remove rsrc_data refs
      io_uring/rsrc: inline switch_start fast path
      io_uring/rsrc: clean up __io_sqe_buffers_update()
      io_uring/rsrc: simplify single file node switching
      io_uring/rsrc: refactor io_queue_rsrc_removal
      io_uring/rsrc: remove unused io_rsrc_node::llist
      io_uring/rsrc: infer node from ctx on io_queue_rsrc_removal
      io_uring/rsrc: merge nodes and io_rsrc_put
      io_uring/rsrc: add empty flag in rsrc_node
      io_uring/rsrc: inline io_rsrc_put_work()
      io_uring/rsrc: pass node to io_rsrc_put_work()
      io_uring/rsrc: devirtualise rsrc put callbacks
      io_uring/rsrc: disassociate nodes and rsrc_data

 fs/ext4/file.c                  |   3 +-
 fs/xfs/xfs_file.c               |   3 +-
 include/linux/fs.h              |   3 +
 include/linux/io_uring_types.h  |  24 +-
 include/trace/events/io_uring.h |  15 +-
 include/uapi/linux/io_uring.h   |  33 +--
 io_uring/alloc_cache.h          |  39 ++-
 io_uring/filetable.c            |  21 +-
 io_uring/io-wq.c                | 524 +++++++++++++++++-----------------------
 io_uring/io_uring.c             | 348 +++++++++++++++++---------
 io_uring/io_uring.h             |  49 ++--
 io_uring/kbuf.c                 | 160 +++++++++---
 io_uring/kbuf.h                 |   7 +
 io_uring/net.h                  |   5 +-
 io_uring/notif.c                |   8 +-
 io_uring/notif.h                |   3 +-
 io_uring/poll.c                 |  32 +--
 io_uring/rsrc.c                 | 350 +++++++++------------------
 io_uring/rsrc.h                 |  72 +++---
 io_uring/rw.c                   |   8 +-
 io_uring/timeout.c              |  71 +++++-
 io_uring/uring_cmd.c            |  18 +-
 22 files changed, 949 insertions(+), 847 deletions(-)

-- 
Jens Axboe

