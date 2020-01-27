Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D1914AAC5
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 20:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgA0T7F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 14:59:05 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51976 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0T7F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 14:59:05 -0500
Received: by mail-pj1-f68.google.com with SMTP id fa20so416891pjb.1
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 11:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=vNVKZh1QehUiF04rRUhbD7mZRwORZ0ah/MehkkEKEOE=;
        b=NSBduqTQbGPwmBQSrgwgSE1vb+kBuzTLX8He9+y+uctREskr3jpFskkoiD/svs1VU5
         Hdz2Yv1e7w+jIYPIe4e2S0Q8fKyt66qNBdcaPcHV9sONBEQyeo3/74GvrnpmDIL0b2+M
         sZHX1zCXZLMQ2xeH4TXtaC8sGZqSNl5G8oBHudltgIMjBxPMiueWoihJW2WKLAqlfLcj
         wk595yBskP5KMeBXlldkk3sLtj/Eq342SV6TdoyJwkhQO36FJFi+Ffsz4qWlLmtnXZdN
         uawsHE4BiwRq2I/KdapVPwH/3Y27WLix73xcj3dxFVyZpKaMT6nzzz+ljTHZKTmVm2Af
         7INA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=vNVKZh1QehUiF04rRUhbD7mZRwORZ0ah/MehkkEKEOE=;
        b=ab8EKAF2qQ2IjvAjoPFn7y4SmP8Un9cWW1QqLi4GMcPKues8fpYfg9GUNfEmN+NFRe
         rWpA9Xt3vtvySKH/G6Ior3js4cnZ0zeOmM6MQE9HXZULL4scufyZyUrb2NdsJQjUhFBM
         j4AAO6MG/pPPBxvkEOG6yslkczprSxImWcDLarf+vkd1axwZXGaP+jZbKu6cJeSH3jco
         /Asljgj/Ak0BYGZ/KN39TwK5SOvOsP5k6vLVDP0Bn6/C1RSQzSaP8ma4unChSj0y46gu
         5PNHcqU8OVQFU2P7ztcqO+M52XCQMquTxWldD9VvaB9dDnoxmQfQ4i+6UkqH/Zu+jdBH
         SX/g==
X-Gm-Message-State: APjAAAWMtlP5t9GP3X18YikWbUlJAi4FQ5fmlwB9Lpuz6S2SHC/iAzGy
        ZJCM3TLt2HMV2Mg1SPl0b5RIz7Nwxc8=
X-Google-Smtp-Source: APXvYqy4hDv8RZ0FMXeJcKHhrwo2wsZHT6+jfPFhtNOAP0qJL2bDuvakUQlcG4LuD4zMNIn3+BwgPg==
X-Received: by 2002:a17:902:7e4b:: with SMTP id a11mr2850747pln.61.1580155144313;
        Mon, 27 Jan 2020 11:59:04 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c2? ([2620:10d:c090:180::dec1])
        by smtp.gmail.com with ESMTPSA id a13sm510894pfg.65.2020.01.27.11.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 11:59:03 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring changes for 5.6-rc
Message-ID: <edc14d52-b3d7-9860-097a-357164150e85@kernel.dk>
Date:   Mon, 27 Jan 2020 12:59:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------7024D63919CB9F577C9933C8"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------7024D63919CB9F577C9933C8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the io_uring changes for 5.6. Note that this is sitting on top
of Al's work.openat2 branch, and was rebased about a week ago as Al
rebased that. So consider this a pre-pull request, ready to go as soon
as you've pulled the work.openat2 stuff from Al.

This pull request contains:

- Support for various new opcodes (fallocate, openat, close, statx,
  fadvise, madvise, openat2, non-vectored read/write and send/recv)

- Faster ring quiesce for fileset updates

- Optimizations for overflow condition checking

- Support for max-sized clamping

- Support for probing what opcodes are supported

- Support for io-wq backend sharing between "sibling" rings

- Lots of little fixes and improvements

The pull will throw a small merge conflict, due to the last minute
revert we had before 5.5. Trivial to resolve, attaching my resolution
just for reference.

Please pull!


  git://git.kernel.dk/linux-block.git tags/for-5.6/io_uring-vfs-2020-01-27


----------------------------------------------------------------
Jens Axboe (40):
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
      io-wq: make the io_wq ref counted
      io-wq: add 'id' to io_wq
      io-wq: allow lookup of existing io_wq with given id
      io_uring: add support for sharing kernel io-wq workqueue
      io_uring: don't attempt to copy iovec for READ/WRITE

Pavel Begunkov (18):
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

YueHaibing (1):
      io_uring: Remove unnecessary null check

 drivers/android/binder.c        |    6 +-
 fs/file.c                       |    6 +-
 fs/internal.h                   |    8 +
 fs/io-wq.c                      |   84 +-
 fs/io-wq.h                      |   13 +-
 fs/io_uring.c                   | 2161 ++++++++++++++++++++++++++++++---------
 fs/open.c                       |    5 +-
 fs/stat.c                       |   34 +-
 include/linux/mm.h              |    1 +
 include/linux/percpu-refcount.h |   26 +-
 include/trace/events/io_uring.h |   13 +-
 include/uapi/linux/io_uring.h   |   62 +-
 mm/madvise.c                    |    7 +-
 13 files changed, 1923 insertions(+), 503 deletions(-)

-- 
Jens Axboe


--------------7024D63919CB9F577C9933C8
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
--------------7024D63919CB9F577C9933C8--
