Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6D69E8A3
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 20:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjBUT4W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 14:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBUT4V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 14:56:21 -0500
Received: from cmx-mtlrgo001.bell.net (mta-mtl-005.bell.net [209.71.208.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B585A2E0F7;
        Tue, 21 Feb 2023 11:55:55 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.104]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35DF70165B4D4
X-CM-Envelope: MS4xfKLify6GlGaWNdUS4n+aaa4q8slEddb/v0x7uYoAtSjZjT8Erud2yI/0u3itKqfqoTpMZzsgbdCVpGSsW6cvmTshGYdjqrUngJeKP5dFnCXf/1k+yIbn
 DtJnxRIY2QsY6w65trIVAANhnJe4hf4vLn7PRTe5CDXzSxvyG4WJOzh+9QuQ71h85QMxY0yWc6XDB3K2ebfAynAMddGFNtSA0dyjll/FMUFo9GnX7phTTLEk
 gHqwiPqHeq1lCw9/KGD2P8h6V/y+pT0tuNLFF3CayaRmu6IcG5pmnxdlRNQ82kGO6h3qPSnhxBnbwSga41X4HEhlBdwOCbpfs8NBh62WNYc=
X-CM-Analysis: v=2.4 cv=AuWNYMxP c=1 sm=1 tr=0 ts=63f521c8
 a=jp24WXWxBM5iMX8AJ3NPbw==:117 a=jp24WXWxBM5iMX8AJ3NPbw==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=ntG9WA4U48cCQLUU1awA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.104) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35DF70165B4D4; Tue, 21 Feb 2023 14:55:52 -0500
Message-ID: <3b65e748-45b2-3875-fef3-b6ca6f87163f@bell.net>
Date:   Tue, 21 Feb 2023 14:55:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: liburing test results on hppa
Content-Language: en-US
From:   John David Anglin <dave.anglin@bell.net>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-parisc <linux-parisc@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, Helge Deller <deller@gmx.de>
References: <64ff4872-cc6f-1e6a-46e5-573c7e64e4c9@bell.net>
 <c198a68c-c80e-e554-c33e-f4448e89764a@kernel.dk>
 <b0ad2098-979e-f256-a553-401bad9921e0@bell.net>
 <6eddaf2b-991f-f848-4832-7005eccdeffa@kernel.dk>
 <ee1ef3d0-9854-87bc-0c45-f073710f9ef5@kernel.dk>
 <b9c3abb9-b8e1-a0f3-51c8-d47c7410d3c5@bell.net>
In-Reply-To: <b9c3abb9-b8e1-a0f3-51c8-d47c7410d3c5@bell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-16 9:59 p.m., John David Anglin wrote:
>>>>> As mentioned previously, this one and the other -233 I suspect are due
>>>>> to the same coloring issue as was fixed by Helge's patch for the ring
>>>>> mmaps, as the provided buffer rings work kinda the same way. The
>>>>> application allocates some aligned memory, and registers it and the
>>>>> kernel then maps it.
>>>>>
>>>>> I wonder if these would work properly if the address was aligned to
>>>>> 0x400000? Should be easy to verify, just modify the alignment for the
>>>>> posix_memalign() calls in test/buf-ring.c.
>>>> Doesn't help.  Same error.  Can you point to where the kernel maps it?
>>> Yep, it goes io_uring.c:io_uring_register() ->
>>> kbuf.c:io_register_pbuf_ring() -> rsrc.c:io_pin_pages() which ultimately
>>> calls pin_user_pages() to map the memory.
>> Followup - a few of the provided buffer ring cases failed to properly
>> initialize the ring, poll-mshot-race was one of them... I've pushed out
>> fixes for this. Not sure if it fixes your particular issue, but worth
>> giving it another run.
> Results are still the same:
> Running test file-verify.t Found 163840, wanted 688128
> Buffered novec reg test failed
> Test file-verify.t failed with ret 1
>
> Tests timed out (2): <a4c0b3decb33.t> <send-zerocopy.t>
> Tests failed (4): <buf-ring.t> <file-verify.t> <ringbuf-read.t> <send_recvmsg.t>
>
> poll-mshot-race still causes HPMC.

The timeouts are not a problem.  The following change fixed <a4c0b3decb33.t> <send-zerocopy.t>:

diff --git a/test/a4c0b3decb33.c b/test/a4c0b3decb33.c
index f282d1b..6be73b6 100644
--- a/test/a4c0b3decb33.c
+++ b/test/a4c0b3decb33.c
@@ -124,7 +124,7 @@ static void loop(void)
              if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
                  break;
              sleep_ms(1);
-            if (current_time_ms() - start < 5 * 1000)
+            if (current_time_ms() - start < 100 * 1000)
                  continue;
              kill_and_wait(pid, &status);
              break;
diff --git a/test/runtests.sh b/test/runtests.sh
index 924fdce..8c3a4bf 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -1,7 +1,7 @@
  #!/usr/bin/env bash

  TESTS=("$@")
-TIMEOUT=60
+TIMEOUT=300
  DMESG_FILTER="cat"
  TEST_DIR=$(dirname "$0")
  FAILED=()

I believe you are correct about the colouring issue being the problem with the other tests.
I've been playing with the send_recvmsg.t test as it seems the simplest.

On parisc, caches are required to detect that the same physical memory is being accessed by
two virtual addresses if offset bits 42 through 63 are the same in both virtual addresses (i.e.,
the addresses must be equal modulo 0x400000).  There is also a constraint on space bits but
space register hashing is disabled, so it doesn't come into play.

We have a linear offset between kernel and physical addresses in linux.  So, the user virtual
address must be equivalent to the physical address of a page for user and kernel accesses to
be detected by the caches.

For io_uring to work, I believe the user and kernel addresses used to access the buffers must
be equivalent.  However, as far as I can see, we only setup equivalent aliases for file backed
mappings with MAP_SHARED.  There doesn't appear to be any connection between the kernel
page addresses allocated for a mapping and the assigned user virtual addresses.  Thus, it doesn't
help to align the user virtual address to 0x400000.  The kernel virtual address still has the wrong
colour.

Maybe something could by done with anonymous MAP_SHARED mappings to make them equivalent?
The mmap man page says "Support for MAP_ANONYMOUS in conjunction with MAP_SHARED was added
in Linux 2.4."

I tried to use a file based mapping in the send_recvmsg.t (tried both ring.ring_fd and a temporary
file).  At first, I thought this worked.  But it turns out that pin_user_pages fails and returns -EFAULT.

                        reg.ring_addr = (unsigned long) ptr;
                         reg.ring_entries = 1;
                         reg.bgid = BUF_BGID;
                         if (io_uring_register_buf_ring(&ring, &reg, 0)) {
                                 no_pbuf_ring = 1;
                                 goto out;
                         }

So, the io_uring_register_buf_ring call fails and the code bails with no error message.

I'm not sure why pin_user_pages fails.  Today, I've been wondering if a mlock call would
lock the mmap'd buffer into RAM and fix pin_user_pages?

Dave

-- 
John David Anglin  dave.anglin@bell.net

