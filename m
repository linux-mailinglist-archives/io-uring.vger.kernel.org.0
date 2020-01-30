Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B47114D539
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 03:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgA3C3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 21:29:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37579 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgA3C3A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 21:29:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so678802pfn.4
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 18:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language;
        bh=5uJB6AV6+z+5PTsRkoHDP27EiriIwQeYXgr7GpoWKYE=;
        b=gLiVZ377lS3oVKslf6SuFmrRfxvZCONYC4p1gVvGRllrOiihDbILYTsm/3SrDT+0yq
         baNksJ0/gnB5LJ8Tot76vkh+nSucA3VmGeLoIoGYwvuvBu2K0Txz/fI8MJqa+V4lQczw
         0K0cYUZhRvX5C/H+Dzrmd2/pMRineOriK3eSvwx/uw7a2gYRRjWdPFKm5NtFv8G0ml69
         jefn0+LCTtbautsfPAQl5xGcdDfFGZ5Q0zWsmTDX24q2mQwF5vrq2v0IqPuh9YARVoYS
         iO9XLXQPRwdhQYaf+TMDUFMpU4CslJ1+T2rXPQg+/tTyYjECi36j9ugkV4kyRRsy+I1T
         T7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language;
        bh=5uJB6AV6+z+5PTsRkoHDP27EiriIwQeYXgr7GpoWKYE=;
        b=nl2ZLSIkd6p3edIfwoqbDT8Q88Rv1tyXNM5FwMsl/jxTIBprqIP8WE98ZhT9wIcZGZ
         xYJ4+MNXsx1kLbaK0h0c1wxu9lPqhI+Sbx3zi5mv05I8m0AdcXp1BFK+pUg3+Q2EHqN3
         cX6Mr47vd+0NKVPxOqkjcFlE6J9rO+cI+Ej07ZyNm9MjuOi9c/2g2NQ7FW5r3F5wz8Is
         7J7gSdL0PHZGwy6/eJlA/FR3LfnBEcPN8BDcdMwKgYxZ5Z6kbiDIuogBuXps58j/OALr
         3m4TTstG4qWMKSKVBX+S8sTuClf6b1p33/L0UbOSZmm1kDCVsvUa0IWl6WG0HGjVWcKy
         dw6w==
X-Gm-Message-State: APjAAAUrA6B4Gqd5glO2EFuwD3WNycMeqh3JNnKCxJvR/2iQ3KbBJPZD
        bXacU+G+x7mwGCkSHtndZbX+0g==
X-Google-Smtp-Source: APXvYqyxJh/K94+dGJ9Dt3F06gYMATw56SFFy8qAIq5HDN5T9BaBaFMsKgwmW0ymm0rDZg+rRUiMnw==
X-Received: by 2002:a63:ce55:: with SMTP id r21mr2218869pgi.156.1580351339805;
        Wed, 29 Jan 2020 18:28:59 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b3sm3971577pft.73.2020.01.29.18.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 18:28:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL v2] io_uring changes for 5.6-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <aec14346-02cf-2c10-2fde-0c4d1edf5669@kernel.dk>
Date:   Wed, 29 Jan 2020 19:28:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4A1EE48111BE6E0FEC3C79E5"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------4A1EE48111BE6E0FEC3C79E5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring changes for 5.6, once more, since Al's branch
has been merged. The delay ended up working out well on the io_uring
side, as we had a few mon/tue shuffles and a last minute fix, and I
forgot about the epoll separate branch that I hadn't pulled in yet.

So here's the pull request for this merge window. This pull request
contains:

- Support for various new opcodes (fallocate, openat, close, statx,
  fadvise, madvise, openat2, non-vectored read/write, send/recv, and
  epoll_ctl)

- Faster ring quiesce for fileset updates

- Optimizations for overflow condition checking

- Support for max-sized clamping

- Support for probing what opcodes are supported

- Support for io-wq backend sharing between "sibling" rings

- Support for registering personalities

- Lots of little fixes and improvements

The pull will throw a small merge conflict, due to the last minute
revert we had before 5.5. Trivial to resolve, attaching my resolution
just for reference.

Please pull!


  git://git.kernel.dk/linux-block.git tags/for-5.6/io_uring-vfs-2020-01-29


----------------------------------------------------------------
Jens Axboe (45):
      Merge branch 'work.openat2' of git://git.kernel.org/.../viro/vfs into for-5.6/io_uring-vfs
      Merge branch 'io_uring-5.5' into for-5.6/io_uring-vfs
      io_uring: add support for fallocate()
      fs: make build_open_flags() available internally
      io_uring: add support for IORING_OP_OPENAT
      fs: move filp_close() outside of __close_fd_get_file()
      io-wq: add support for uncancellable work
      io_uring: add support for IORING_OP_CLOSE
      io_uring: avoid ring quiesce for fixed file set unregister and update
      fs: make two stat prep helpers available
      io_uring: add support for IORING_OP_STATX
      io-wq: support concurrent non-blocking work
      io_uring: add IOSQE_ASYNC
      io_uring: remove two unnecessary function declarations
      io_uring: add lookup table for various opcode needs
      io_uring: split overflow state into SQ and CQ side
      io_uring: improve poll completion performance
      io_uring: add non-vectored read/write commands
      io_uring: allow use of offset == -1 to mean file position
      io_uring: add IORING_OP_FADVISE
      mm: make do_madvise() available internally
      io_uring: add IORING_OP_MADVISE
      io_uring: wrap multi-req freeing in struct req_batch
      io_uring: extend batch freeing to cover more cases
      io_uring: add support for IORING_SETUP_CLAMP
      io_uring: add support for send(2) and recv(2)
      io_uring: file set registration should use interruptible waits
      io_uring: change io_ring_ctx bool fields into bit fields
      io_uring: enable option to only trigger eventfd for async completions
      io_uring: add 'struct open_how' to the openat request context
      io_uring: remove 'fname' from io_open structure
      io_uring: add support for IORING_OP_OPENAT2
      io_uring: add opcode to issue trace event
      io_uring: account fixed file references correctly in batch
      io_uring: add support for probing opcodes
      io_uring: file switch work needs to get flushed on exit
      io_uring: don't attempt to copy iovec for READ/WRITE
      io-wq: make the io_wq ref counted
      io_uring/io-wq: don't use static creds/mm assignments
      io_uring: allow registering credentials
      io_uring: support using a registered personality for commands
      io_uring: fix linked command file table usage
      eventpoll: abstract out epoll_ctl() handler
      eventpoll: support non-blocking do_epoll_ctl() calls
      io_uring: add support for epoll_ctl(2)

Pavel Begunkov (20):
      io_uring: rename prev to head
      io_uring: move *queue_link_head() from common path
      pcpu_ref: add percpu_ref_tryget_many()
      io_uring: batch getting pcpu references
      io_uring: clamp to_submit in io_submit_sqes()
      io_uring: optimise head checks in io_get_sqring()
      io_uring: optimise commit_sqring() for common case
      io_uring: remove extra io_wq_current_is_worker()
      io_uring: optimise use of ctx->drain_next
      io_uring: remove extra check in __io_commit_cqring
      io_uring: hide uring_fd in ctx
      io_uring: remove REQ_F_IO_DRAINED
      io_uring: optimise sqe-to-req flags translation
      io_uring: use labeled array init in io_op_defs
      io_uring: prep req when do IOSQE_ASYNC
      io_uring: honor IOSQE_ASYNC for linked reqs
      io_uring: add comment for drain_next
      io_uring: fix refcounting with batched allocations at OOM
      io-wq: allow grabbing existing io-wq
      io_uring: add io-wq workqueue sharing

YueHaibing (1):
      io_uring: Remove unnecessary null check

 drivers/android/binder.c        |    6 +-
 fs/eventpoll.c                  |   87 +-
 fs/file.c                       |    6 +-
 fs/internal.h                   |    8 +
 fs/io-wq.c                      |  103 +-
 fs/io-wq.h                      |   11 +-
 fs/io_uring.c                   | 2412 +++++++++++++++++++++++++++++++--------
 fs/open.c                       |    5 +-
 fs/stat.c                       |   34 +-
 include/linux/eventpoll.h       |    9 +
 include/linux/mm.h              |    1 +
 include/linux/percpu-refcount.h |   26 +-
 include/trace/events/io_uring.h |   13 +-
 include/uapi/linux/io_uring.h   |   73 +-
 mm/madvise.c                    |    7 +-
 15 files changed, 2218 insertions(+), 583 deletions(-)

-- 
Jens Axboe





--------------4A1EE48111BE6E0FEC3C79E5
Content-Type: text/plain; charset=UTF-8;
 name="merge-fixup"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="merge-fixup"

Y29tbWl0IDlkOGJkNmZjZjBlYmZjY2YzOWU2YWM0NGRmM2M0MTE1NTQ4MTAzMGUKTWVyZ2U6
IGMwMDA3YzRmMzZhNyA2MWNkODNkM2FkZTYKQXV0aG9yOiBKZW5zIEF4Ym9lIDxheGJvZUBr
ZXJuZWwuZGs+CkRhdGU6ICAgTW9uIEphbiAyNyAxMjo1MDoyMCAyMDIwIC0wNzAwCgogICAg
TWVyZ2UgYnJhbmNoICdmb3ItNS42L2lvX3VyaW5nLXZmcycgaW50byBsbAogICAgCiAgICAq
IGZvci01LjYvaW9fdXJpbmctdmZzOiAoNTggY29tbWl0cykKICAgICAgaW9fdXJpbmc6IGZp
eCByZWZjb3VudGluZyB3aXRoIGJhdGNoZWQgYWxsb2NhdGlvbnMgYXQgT09NCiAgICAgIGlv
X3VyaW5nOiBhZGQgY29tbWVudCBmb3IgZHJhaW5fbmV4dAogICAgICBpb191cmluZzogZG9u
J3QgYXR0ZW1wdCB0byBjb3B5IGlvdmVjIGZvciBSRUFEL1dSSVRFCiAgICAgIGlvX3VyaW5n
OiBhZGQgc3VwcG9ydCBmb3Igc2hhcmluZyBrZXJuZWwgaW8td3Egd29ya3F1ZXVlCiAgICAg
IGlvLXdxOiBhbGxvdyBsb29rdXAgb2YgZXhpc3RpbmcgaW9fd3Egd2l0aCBnaXZlbiBpZAog
ICAgICBpby13cTogYWRkICdpZCcgdG8gaW9fd3EKICAgICAgaW8td3E6IG1ha2UgdGhlIGlv
X3dxIHJlZiBjb3VudGVkCiAgICAgIGlvX3VyaW5nOiBob25vciBJT1NRRV9BU1lOQyBmb3Ig
bGlua2VkIHJlcXMKICAgICAgaW9fdXJpbmc6IHByZXAgcmVxIHdoZW4gZG8gSU9TUUVfQVNZ
TkMKICAgICAgaW9fdXJpbmc6IHVzZSBsYWJlbGVkIGFycmF5IGluaXQgaW4gaW9fb3BfZGVm
cwogICAgICBpb191cmluZzogb3B0aW1pc2Ugc3FlLXRvLXJlcSBmbGFncyB0cmFuc2xhdGlv
bgogICAgICBpb191cmluZzogcmVtb3ZlIFJFUV9GX0lPX0RSQUlORUQKICAgICAgaW9fdXJp
bmc6IGZpbGUgc3dpdGNoIHdvcmsgbmVlZHMgdG8gZ2V0IGZsdXNoZWQgb24gZXhpdAogICAg
ICBpb191cmluZzogaGlkZSB1cmluZ19mZCBpbiBjdHgKICAgICAgaW9fdXJpbmc6IHJlbW92
ZSBleHRyYSBjaGVjayBpbiBfX2lvX2NvbW1pdF9jcXJpbmcKICAgICAgaW9fdXJpbmc6IG9w
dGltaXNlIHVzZSBvZiBjdHgtPmRyYWluX25leHQKICAgICAgaW9fdXJpbmc6IGFkZCBzdXBw
b3J0IGZvciBwcm9iaW5nIG9wY29kZXMKICAgICAgaW9fdXJpbmc6IGFjY291bnQgZml4ZWQg
ZmlsZSByZWZlcmVuY2VzIGNvcnJlY3RseSBpbiBiYXRjaAogICAgICBpb191cmluZzogYWRk
IG9wY29kZSB0byBpc3N1ZSB0cmFjZSBldmVudAogICAgICBpb191cmluZzogYWRkIHN1cHBv
cnQgZm9yIElPUklOR19PUF9PUEVOQVQyCiAgICAgIC4uLgogICAgCiAgICBTaWduZWQtb2Zm
LWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CgpkaWZmIC0tY2MgZnMvaW9fdXJp
bmcuYwppbmRleCBlNTQ1NTZiMGZjYzYsNjVmZTE2YTc5NWMxLi5lZWFhZmJkNzQyNTkKLS0t
IGEvZnMvaW9fdXJpbmcuYworKysgYi9mcy9pb191cmluZy5jCkBAQCAtNTE1Nyw3IC02MzEy
LDEyICs2MzA4LDYgQEBAIFNZU0NBTExfREVGSU5FNihpb191cmluZ19lbnRlciwgdW5zaWdu
ZQogIAl9IGVsc2UgaWYgKHRvX3N1Ym1pdCkgewogIAkJc3RydWN0IG1tX3N0cnVjdCAqY3Vy
X21tOwogIAotIAkJdG9fc3VibWl0ID0gbWluKHRvX3N1Ym1pdCwgY3R4LT5zcV9lbnRyaWVz
KTsKIC0JCWlmIChjdXJyZW50LT5tbSAhPSBjdHgtPnNxb19tbSB8fAogLQkJICAgIGN1cnJl
bnRfY3JlZCgpICE9IGN0eC0+Y3JlZHMpIHsKIC0JCQlyZXQgPSAtRVBFUk07CiAtCQkJZ290
byBvdXQ7CiAtCQl9CiAtCiAgCQltdXRleF9sb2NrKCZjdHgtPnVyaW5nX2xvY2spOwogIAkJ
LyogYWxyZWFkeSBoYXZlIG1tLCBzbyBpb19zdWJtaXRfc3FlcygpIHdvbid0IHRyeSB0byBn
cmFiIGl0ICovCiAgCQljdXJfbW0gPSBjdHgtPnNxb19tbTsK
--------------4A1EE48111BE6E0FEC3C79E5--
