Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DABE239C3E
	for <lists+io-uring@lfdr.de>; Sun,  2 Aug 2020 23:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgHBVlY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Aug 2020 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHBVlX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Aug 2020 17:41:23 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3A8C06174A
        for <io-uring@vger.kernel.org>; Sun,  2 Aug 2020 14:41:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so9869792pjb.4
        for <io-uring@vger.kernel.org>; Sun, 02 Aug 2020 14:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language;
        bh=jjzFsgBNBTJu+mfAEocjRiA+FwdzKLcevsvi/MIo3mo=;
        b=smIEslfGAVb+g8XQJgFPOdr3VajNlWGPN9mOI12gCqD4lW5kP5fjVmBN47BtTngCbz
         7+fTbEf7p8oDGC96aOJNraNBkilkifwXnZgIrcCEx0uodGE90vcbvthBwvhmMZ7DRTRm
         CtSYR3gmZgRWyaYKeFPkotYb6/+PBmcZZYIFxoX54caBXSKt0z0J1F6/YPlhOZE5W83j
         UNOtsJol8ho5HOVCbq9xvqjsRCHY7xMy1rvBbfoKvtyvT/eQrCGet0pSNqZjyxeh4RHh
         dOcQ9s9ORFvYNYVzlDBgAIkACdok+GhTgGHWEQ3DJgVUXxAkfoqZ7GwYgpRag8dzYGZ3
         UOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language;
        bh=jjzFsgBNBTJu+mfAEocjRiA+FwdzKLcevsvi/MIo3mo=;
        b=UbyGB0FLDQKUwNSf5IkEopyhhD6FiGUHOiqfc65MdAODE8GgWOUPV8OYOp9ayP4nw8
         or9zKmBhzn314dISE9IgGsVDkBkPCV70vXN51KNHjDtNZnfv9A2scLQXdxGDus9KlR9B
         stfj9LC8eYQUldmx712fEIPVVtjVtbkQFCQm+7S4CeCd/J4rzhrvHV5UTPeIoHZGLGke
         NyBAFMi/rk2W/l1y3GkKwBvqneP/MmyNMI7C7h1Up52G4ggyGNfGnQlBOSgoTtT6RBoH
         Kt3Yg9BkAR5VgIYhIjm9LxOCLegL6lVV1QtH1FBlKnrc7NvlCiEembcXMOyA+rrRRmhV
         p4xg==
X-Gm-Message-State: AOAM532UeVmwit2fMtQijBCyf0WfaNW4EyDMYJ5V6MZ2CNxRoI7QGJGv
        JAIvTxxrUb+dXGdSWSqYvMldCg==
X-Google-Smtp-Source: ABdhPJxygj+w9Y5Sg5kwNhp+04F5sD9/+w40fIXg/HNyMPvKBJEN0qVuBMsL29xwtTIe/dbNHF8d1g==
X-Received: by 2002:a17:90a:4b8c:: with SMTP id i12mr6943219pjh.83.1596404482621;
        Sun, 02 Aug 2020 14:41:22 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q4sm16756094pjq.36.2020.08.02.14.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 14:41:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring changes for 5.9-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
Date:   Sun, 2 Aug 2020 15:41:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------28D03CF0E51EE30542D85A6D"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------28D03CF0E51EE30542D85A6D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Lots of cleanups in here, hardening the code and/or making it easier to
read and fixing buts, but a core feature/change too adding support for
real async buffered reads. With the latter in place, we just need
buffered write async support and we're done relying on kthreads for the
fast path. In detail:

- Cleanup how memory accounting is done on ring setup/free (Bijan)

- sq array offset calculation fixup (Dmitry)

- Consistently handle blocking off O_DIRECT submission path (me)

- Support proper async buffered reads, instead of relying on kthread
  offload for that. This uses the page waitqueue to drive retries from
  task_work, like we handle poll based retry. (me)

- IO completion optimizations (me)

- Fix race with accounting and ring fd install (me)

- Support EPOLLEXCLUSIVE (Jiufei)

- Get rid of the io_kiocb unionizing, made possible by shrinking other
  bits (Pavel)

- Completion side cleanups (Pavel)

- Cleanup REQ_F_ flags handling, and kill off many of them (Pavel)

- Request environment grabbing cleanups (Pavel)

- File and socket read/write cleanups (Pavel)

- Improve kiocb_set_rw_flags() (Pavel)

- Tons of fixes and cleanups (Pavel)

- IORING_SQ_NEED_WAKEUP clear fix (Xiaoguang)

This will throw a few merge conflicts. One is due to the IOCB_NOIO
addition that happened late in 5.8-rc, the other is due to a change in
for-5.9/block. Both are trivial to fixup, I'm attaching my merge
resolution when I pulled it in locally.

Please pull!


The following changes since commit 4ae6dbd683860b9edc254ea8acf5e04b5ae242e5:

  io_uring: fix lockup in io_fail_links() (2020-07-24 12:51:33 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.9/io_uring-20200802

for you to fetch changes up to fa15bafb71fd7a4d6018dae87cfaf890fd4ab47f:

  io_uring: flip if handling after io_setup_async_rw (2020-08-01 11:02:57 -0600)

----------------------------------------------------------------
for-5.9/io_uring-20200802

----------------------------------------------------------------
Bijan Mottahedeh (4):
      io_uring: add wrappers for memory accounting
      io_uring: rename ctx->account_mem field
      io_uring: report pinned memory usage
      io_uring: separate reporting of ring pages from registered pages

Dan Carpenter (1):
      io_uring: fix a use after free in io_async_task_func()

Dmitry Vyukov (1):
      io_uring: fix sq array offset calculation

Jens Axboe (31):
      block: provide plug based way of signaling forced no-wait semantics
      io_uring: always plug for any number of IOs
      io_uring: catch -EIO from buffered issue request failure
      io_uring: re-issue block requests that failed because of resources
      mm: allow read-ahead with IOCB_NOWAIT set
      mm: abstract out wake_page_match() from wake_page_function()
      mm: add support for async page locking
      mm: support async buffered reads in generic_file_buffered_read()
      fs: add FMODE_BUF_RASYNC
      block: flag block devices as supporting IOCB_WAITQ
      xfs: flag files as supporting buffered async reads
      btrfs: flag files as supporting buffered async reads
      mm: add kiocb_wait_page_queue_init() helper
      io_uring: support true async buffered reads, if file provides it
      Merge branch 'async-buffered.8' into for-5.9/io_uring
      io_uring: provide generic io_req_complete() helper
      io_uring: add 'io_comp_state' to struct io_submit_state
      io_uring: pass down completion state on the issue side
      io_uring: pass in completion state to appropriate issue side handlers
      io_uring: enable READ/WRITE to use deferred completions
      io_uring: use task_work for links if possible
      Merge branch 'io_uring-5.8' into for-5.9/io_uring
      io_uring: clean up io_kill_linked_timeout() locking
      Merge branch 'io_uring-5.8' into for-5.9/io_uring
      io_uring: abstract out task work running
      io_uring: use new io_req_task_work_add() helper throughout
      io_uring: only call kfree() for a non-zero pointer
      io_uring: get rid of __req_need_defer()
      io_uring: remove dead 'ctx' argument and move forward declaration
      Merge branch 'io_uring-5.8' into for-5.9/io_uring
      io_uring: don't touch 'ctx' after installing file descriptor

Jiufei Xue (2):
      io_uring: change the poll type to be 32-bits
      io_uring: use EPOLLEXCLUSIVE flag to aoid thundering herd type behavior

Pavel Begunkov (90):
      io_uring: remove setting REQ_F_MUST_PUNT in rw
      io_uring: remove REQ_F_MUST_PUNT
      io_uring: set @poll->file after @poll init
      io_uring: kill NULL checks for submit state
      io_uring: fix NULL-mm for linked reqs
      io-wq: compact io-wq flags numbers
      io-wq: return next work from ->do_work() directly
      io_uring: fix req->work corruption
      io_uring: fix punting req w/o grabbed env
      io_uring: fix feeding io-wq with uninit reqs
      io_uring: don't mark link's head for_async
      io_uring: fix missing io_grab_files()
      io_uring: fix refs underflow in io_iopoll_queue()
      io_uring: remove inflight batching in free_many()
      io_uring: dismantle req early and remove need_iter
      io_uring: batch-free linked requests as well
      io_uring: cosmetic changes for batch free
      io_uring: kill REQ_F_LINK_NEXT
      io_uring: clean up req->result setting by rw
      io_uring: do task_work_run() during iopoll
      io_uring: fix iopoll -EAGAIN handling
      io_uring: fix missing wake_up io_rw_reissue()
      io_uring: deduplicate freeing linked timeouts
      io_uring: replace find_next() out param with ret
      io_uring: kill REQ_F_TIMEOUT
      io_uring: kill REQ_F_TIMEOUT_NOSEQ
      io_uring: fix potential use after free on fallback request free
      io_uring: don't pass def into io_req_work_grab_env
      io_uring: do init work in grab_env()
      io_uring: factor out grab_env() from defer_prep()
      io_uring: do grab_env() just before punting
      io_uring: don't fail iopoll requeue without ->mm
      io_uring: fix NULL mm in io_poll_task_func()
      io_uring: simplify io_async_task_func()
      io_uring: optimise io_req_find_next() fast check
      io_uring: fix missing ->mm on exit
      io_uring: fix mis-refcounting linked timeouts
      io_uring: keep queue_sqe()'s fail path separately
      io_uring: fix lost cqe->flags
      io_uring: don't delay iopoll'ed req completion
      io_uring: fix stopping iopoll'ing too early
      io_uring: briefly loose locks while reaping events
      io_uring: partially inline io_iopoll_getevents()
      io_uring: remove nr_events arg from iopoll_check()
      io_uring: don't burn CPU for iopoll on exit
      io_uring: rename sr->msg into umsg
      io_uring: use more specific type in rcv/snd msg cp
      io_uring: extract io_sendmsg_copy_hdr()
      io_uring: replace rw->task_work with rq->task_work
      io_uring: simplify io_req_map_rw()
      io_uring: add a helper for async rw iovec prep
      io_uring: follow **iovec idiom in io_import_iovec
      io_uring: share completion list w/ per-op space
      io_uring: rename ctx->poll into ctx->iopoll
      io_uring: use inflight_entry list for iopoll'ing
      io_uring: use completion list for CQ overflow
      io_uring: add req->timeout.list
      io_uring: remove init for unused list
      io_uring: use non-intrusive list for defer
      io_uring: remove sequence from io_kiocb
      io_uring: place cflags into completion data
      io_uring: inline io_req_work_grab_env()
      io_uring: remove empty cleanup of OP_OPEN* reqs
      io_uring: alloc ->io in io_req_defer_prep()
      io_uring/io-wq: move RLIMIT_FSIZE to io-wq
      io_uring: simplify file ref tracking in submission state
      io_uring: indent left {send,recv}[msg]()
      io_uring: remove extra checks in send/recv
      io_uring: don't forget cflags in io_recv()
      io_uring: free selected-bufs if error'ed
      io_uring: move BUFFER_SELECT check into *recv[msg]
      io_uring: extract io_put_kbuf() helper
      io_uring: don't open-code recv kbuf managment
      io_uring: don't miscount pinned memory
      io_uring: return locked and pinned page accounting
      tasks: add put_task_struct_many()
      io_uring: batch put_task_struct()
      io_uring: don't do opcode prep twice
      io_uring: deduplicate io_grab_files() calls
      io_uring: mark ->work uninitialised after cleanup
      io_uring: fix missing io_queue_linked_timeout()
      io-wq: update hash bits
      io_uring: de-unionise io_kiocb
      io_uring: deduplicate __io_complete_rw()
      io_uring: fix racy overflow count reporting
      io_uring: fix stalled deferred requests
      io_uring: consolidate *_check_overflow accounting
      io_uring: get rid of atomic FAA for cq_timeouts
      fs: optimise kiocb_set_rw_flags()
      io_uring: flip if handling after io_setup_async_rw

Randy Dunlap (1):
      io_uring: fix function args for !CONFIG_NET

Xiaoguang Wang (1):
      io_uring: clear IORING_SQ_NEED_WAKEUP after executing task works

 block/blk-core.c              |    6 +
 fs/block_dev.c                |    2 +-
 fs/btrfs/file.c               |    2 +-
 fs/io-wq.c                    |   14 +-
 fs/io-wq.h                    |   11 +-
 fs/io_uring.c                 | 2588 +++++++++++++++++++++++------------------
 fs/xfs/xfs_file.c             |    2 +-
 include/linux/blkdev.h        |    1 +
 include/linux/fs.h            |   26 +-
 include/linux/pagemap.h       |   75 ++
 include/linux/sched/task.h    |    6 +
 include/uapi/linux/io_uring.h |    4 +-
 mm/filemap.c                  |  110 +-
 tools/io_uring/liburing.h     |    6 +-
 14 files changed, 1658 insertions(+), 1195 deletions(-)

-- 
Jens Axboe




--------------28D03CF0E51EE30542D85A6D
Content-Type: text/plain; charset=UTF-8;
 name="merge.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="merge.txt"

Y29tbWl0IDMyYTUxNjlhNTU2MmRiNmEwOWEyZDg1MTY0ZTAwNzk5MTNlY2MyMjcKTWVyZ2U6
IDVmYjAyM2ZiNDE0YSBmYTE1YmFmYjcxZmQKQXV0aG9yOiBKZW5zIEF4Ym9lIDxheGJvZUBr
ZXJuZWwuZGs+CkRhdGU6ICAgU3VuIEF1ZyAyIDEwOjQzOjM1IDIwMjAgLTA2MDAKCiAgICBN
ZXJnZSBicmFuY2ggJ2Zvci01LjkvaW9fdXJpbmcnIGludG8gdGVzdAogICAgCiAgICAqIGZv
ci01LjkvaW9fdXJpbmc6ICgxMjcgY29tbWl0cykKICAgICAgaW9fdXJpbmc6IGZsaXAgaWYg
aGFuZGxpbmcgYWZ0ZXIgaW9fc2V0dXBfYXN5bmNfcncKICAgICAgZnM6IG9wdGltaXNlIGtp
b2NiX3NldF9yd19mbGFncygpCiAgICAgIGlvX3VyaW5nOiBkb24ndCB0b3VjaCAnY3R4JyBh
ZnRlciBpbnN0YWxsaW5nIGZpbGUgZGVzY3JpcHRvcgogICAgICBpb191cmluZzogZ2V0IHJp
ZCBvZiBhdG9taWMgRkFBIGZvciBjcV90aW1lb3V0cwogICAgICBpb191cmluZzogY29uc29s
aWRhdGUgKl9jaGVja19vdmVyZmxvdyBhY2NvdW50aW5nCiAgICAgIGlvX3VyaW5nOiBmaXgg
c3RhbGxlZCBkZWZlcnJlZCByZXF1ZXN0cwogICAgICBpb191cmluZzogZml4IHJhY3kgb3Zl
cmZsb3cgY291bnQgcmVwb3J0aW5nCiAgICAgIGlvX3VyaW5nOiBkZWR1cGxpY2F0ZSBfX2lv
X2NvbXBsZXRlX3J3KCkKICAgICAgaW9fdXJpbmc6IGRlLXVuaW9uaXNlIGlvX2tpb2NiCiAg
ICAgIGlvLXdxOiB1cGRhdGUgaGFzaCBiaXRzCiAgICAgIGlvX3VyaW5nOiBmaXggbWlzc2lu
ZyBpb19xdWV1ZV9saW5rZWRfdGltZW91dCgpCiAgICAgIGlvX3VyaW5nOiBtYXJrIC0+d29y
ayB1bmluaXRpYWxpc2VkIGFmdGVyIGNsZWFudXAKICAgICAgaW9fdXJpbmc6IGRlZHVwbGlj
YXRlIGlvX2dyYWJfZmlsZXMoKSBjYWxscwogICAgICBpb191cmluZzogZG9uJ3QgZG8gb3Bj
b2RlIHByZXAgdHdpY2UKICAgICAgaW9fdXJpbmc6IGNsZWFyIElPUklOR19TUV9ORUVEX1dB
S0VVUCBhZnRlciBleGVjdXRpbmcgdGFzayB3b3JrcwogICAgICBpb191cmluZzogYmF0Y2gg
cHV0X3Rhc2tfc3RydWN0KCkKICAgICAgdGFza3M6IGFkZCBwdXRfdGFza19zdHJ1Y3RfbWFu
eSgpCiAgICAgIGlvX3VyaW5nOiByZXR1cm4gbG9ja2VkIGFuZCBwaW5uZWQgcGFnZSBhY2Nv
dW50aW5nCiAgICAgIGlvX3VyaW5nOiBkb24ndCBtaXNjb3VudCBwaW5uZWQgbWVtb3J5CiAg
ICAgIGlvX3VyaW5nOiBkb24ndCBvcGVuLWNvZGUgcmVjdiBrYnVmIG1hbmFnbWVudAogICAg
ICAuLi4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVs
LmRrPgoKZGlmZiAtLWNjIGJsb2NrL2Jsay1jb3JlLmMKaW5kZXggOTMxMDRjNzQ3MGU4LDYy
YTQ5MDRkYjkyMS4uZDlkNjMyNjM5YmQxCi0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMKKysrIGIv
YmxvY2svYmxrLWNvcmUuYwpAQEAgLTk1NiwxMyAtOTUyLDMwICs5NTYsMTggQEBAIHN0YXRp
YyBpbmxpbmUgYmxrX3N0YXR1c190IGJsa19jaGVja196bwogIAlyZXR1cm4gQkxLX1NUU19P
SzsKICB9CiAgCiAtc3RhdGljIG5vaW5saW5lX2Zvcl9zdGFjayBib29sCiAtZ2VuZXJpY19t
YWtlX3JlcXVlc3RfY2hlY2tzKHN0cnVjdCBiaW8gKmJpbykKICtzdGF0aWMgbm9pbmxpbmVf
Zm9yX3N0YWNrIGJvb2wgc3VibWl0X2Jpb19jaGVja3Moc3RydWN0IGJpbyAqYmlvKQogIHsK
IC0Jc3RydWN0IHJlcXVlc3RfcXVldWUgKnE7CiAtCWludCBucl9zZWN0b3JzID0gYmlvX3Nl
Y3RvcnMoYmlvKTsKICsJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBiaW8tPmJpX2Rpc2st
PnF1ZXVlOwogIAlibGtfc3RhdHVzX3Qgc3RhdHVzID0gQkxLX1NUU19JT0VSUjsKKyAJc3Ry
dWN0IGJsa19wbHVnICpwbHVnOwogLQljaGFyIGJbQkRFVk5BTUVfU0laRV07CiAgCiAgCW1p
Z2h0X3NsZWVwKCk7CiAgCiAtCXEgPSBiaW8tPmJpX2Rpc2stPnF1ZXVlOwogLQlpZiAodW5s
aWtlbHkoIXEpKSB7CiAtCQlwcmludGsoS0VSTl9FUlIKIC0JCSAgICAgICAiZ2VuZXJpY19t
YWtlX3JlcXVlc3Q6IFRyeWluZyB0byBhY2Nlc3MgIgogLQkJCSJub25leGlzdGVudCBibG9j
ay1kZXZpY2UgJXMgKCVMdSlcbiIsCiAtCQkJYmlvX2Rldm5hbWUoYmlvLCBiKSwgKGxvbmcg
bG9uZyliaW8tPmJpX2l0ZXIuYmlfc2VjdG9yKTsKIC0JCWdvdG8gZW5kX2lvOwogLQl9CiAt
CisgCXBsdWcgPSBibGtfbXFfcGx1ZyhxLCBiaW8pOworIAlpZiAocGx1ZyAmJiBwbHVnLT5u
b3dhaXQpCisgCQliaW8tPmJpX29wZiB8PSBSRVFfTk9XQUlUOworIAogIAkvKgogIAkgKiBG
b3IgYSBSRVFfTk9XQUlUIGJhc2VkIHJlcXVlc3QsIHJldHVybiAtRU9QTk9UU1VQUAogIAkg
KiBpZiBxdWV1ZSBpcyBub3QgYSByZXF1ZXN0IGJhc2VkIHF1ZXVlLgpkaWZmIC0tY2MgaW5j
bHVkZS9saW51eC9mcy5oCmluZGV4IDQxY2Q5OTNlYzBmNixlNTM1NTQzZDMxZDkuLmI3ZjFm
MWI3ZDY5MQotLS0gYS9pbmNsdWRlL2xpbnV4L2ZzLmgKKysrIGIvaW5jbHVkZS9saW51eC9m
cy5oCkBAQCAtMzE1LDcgLTMxOCw4ICszMTgsOSBAQEAgZW51bSByd19oaW50IAogICNkZWZp
bmUgSU9DQl9TWU5DCQkoMSA8PCA1KQogICNkZWZpbmUgSU9DQl9XUklURQkJKDEgPDwgNikK
ICAjZGVmaW5lIElPQ0JfTk9XQUlUCQkoMSA8PCA3KQorIC8qIGlvY2ItPmtpX3dhaXRxIGlz
IHZhbGlkICovCisgI2RlZmluZSBJT0NCX1dBSVRRCQkoMSA8PCA4KQogKyNkZWZpbmUgSU9D
Ql9OT0lPCQkoMSA8PCA5KQogIAogIHN0cnVjdCBraW9jYiB7CiAgCXN0cnVjdCBmaWxlCQkq
a2lfZmlscDsKZGlmZiAtLWNjIG1tL2ZpbGVtYXAuYwppbmRleCAzODU3NTljNGNlNGIsYTVi
MWZhOGY3Y2U0Li40ZTM5YzFmNGM3ZDkKLS0tIGEvbW0vZmlsZW1hcC5jCisrKyBiL21tL2Zp
bGVtYXAuYwpAQEAgLTIwMjgsOCAtMjA0NCw2ICsyMDQ0LDggQEBAIGZpbmRfcGFnZQogIAog
IAkJcGFnZSA9IGZpbmRfZ2V0X3BhZ2UobWFwcGluZywgaW5kZXgpOwogIAkJaWYgKCFwYWdl
KSB7Ci0gCQkJaWYgKGlvY2ItPmtpX2ZsYWdzICYgKElPQ0JfTk9XQUlUIHwgSU9DQl9OT0lP
KSkKKysJCQlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX05PSU8pCiArCQkJCWdvdG8gd291
bGRfYmxvY2s7CiAgCQkJcGFnZV9jYWNoZV9zeW5jX3JlYWRhaGVhZChtYXBwaW5nLAogIAkJ
CQkJcmEsIGZpbHAsCiAgCQkJCQlpbmRleCwgbGFzdF9pbmRleCAtIGluZGV4KTsKQEBAIC0y
MTY0LDcgLTIxODUsNyArMjE5MSw3IEBAQCBwYWdlX25vdF91cF90b19kYXRlX2xvY2tlZAog
IAkJfQogIAogIHJlYWRwYWdlOgotIAkJaWYgKGlvY2ItPmtpX2ZsYWdzICYgSU9DQl9OT0lP
KSB7CiAtCQlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX05PV0FJVCkgeworKwkJaWYgKGlv
Y2ItPmtpX2ZsYWdzICYgKElPQ0JfTk9XQUlUIHwgSU9DQl9OT0lPKSkgewogIAkJCXVubG9j
a19wYWdlKHBhZ2UpOwogIAkJCXB1dF9wYWdlKHBhZ2UpOwogIAkJCWdvdG8gd291bGRfYmxv
Y2s7Cg==
--------------28D03CF0E51EE30542D85A6D--
