Return-Path: <io-uring+bounces-8351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B738ADA33B
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 21:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9200B188F9A0
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 19:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9361E48A;
	Sun, 15 Jun 2025 19:56:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from fx.arvanta.net (93-87-244-166.static.isp.telekom.rs [93.87.244.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3670327A115
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 19:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.87.244.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750017413; cv=none; b=U//vobWikLGc1XD5IKFAV5Ys3n04+9BgpFEwQbBEh0y90O76384NrfsITDpTZjILoFVDfp+Saov2q9A9e5aa2+b0muK6BU8RUF7OtN1GjdB1nbn8RVSqHfMcPtfLFrp0S4cFoqTUsKdk5/90b+o4zXNrvFgYAc1KE02XTwB3xDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750017413; c=relaxed/simple;
	bh=iiYXqwAKGy1glCrgJDPxW9T2JGzkuyhFU2nX9vwd8PU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRO464RfPy4Dsz1HQ0k8c2AX50v8Zsb/1EPhRA0m/aweIgDj4vtTWp/zWhIv//grlCRuct9j0fmUWWnKk8EzRZSdphYrbMFrXxzLGIv5emGH/37rb8dlrPJ9Vp9DaBln4aZq8r9m09it2aLahE2H17fsOIfB7shOyC4pzUo88zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net; spf=pass smtp.mailfrom=arvanta.net; arc=none smtp.client-ip=93.87.244.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arvanta.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arvanta.net
Received: from m1pro.arvanta.net (m1pro.arvanta.net [10.5.1.11])
	by fx.arvanta.net (Postfix) with ESMTP id A044E10A1F;
	Sun, 15 Jun 2025 21:56:49 +0200 (CEST)
Date: Sun, 15 Jun 2025 21:56:17 +0200
From: Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: Building liburing on musl libc gives error that errno.h not found
Message-ID: <20250615195617.GA15397@m1pro.arvanta.net>
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1zKi4YPGXtrRaH/r"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>


--1zKi4YPGXtrRaH/r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
> On 6/15/25 11:16 AM, Milan P. Stanić wrote:
> > Hi,
> > 
> > Trying to build liburing 2.10 on Alpine Linux with musl libc got error
> > that errno.h is not found when building examples/zcrx.c
> > 
> > Temporary I disabled build zcrx.c, merge request with patch for Alpine
> > is here:
> > https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
> > I commented in merge request that error.h is glibc specific.
> 
> I killed it, it's not needed and should've been caught during review.
> We should probably have alpine/musl as part of the CI...

Fine.

> > Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
> > should I post full log here.
> 
> Either that or file an issue on GH. Sounds like something is very wrong
> on the setup if you get failing tests, test suite should generally
> pass on the current kernel, or any -stable kernel.
> 
I'm attaching log here to this mail. Actually it is one bug but repeated
in different tests, segfaults

-- 
Kind regards.

> -- 
> Jens Axboe
> 

--1zKi4YPGXtrRaH/r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=liburing-build.log

make[1]: Entering directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/src'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/src'
make[1]: Entering directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/test'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/test'
make[1]: Entering directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/examples'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/examples'
make[1]: Entering directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/test'
Running test 232c93d07b74.t                                         5 sec
Running test 35fa71a030ca.t                                         5 sec
Running test 500f9fbadef8.t                                         ./runtests.sh: line 66:  8980 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test 500f9fbadef8.t failed with ret 139
Running test 7ad0e4b2f83c.t                                         1 sec
Running test 8a9973408177.t                                         0 sec
Running test 917257daa0fe.t                                         0 sec
Running test a0908ae19763.t                                         0 sec
Running test a4c0b3decb33.t                                         0 sec
Running test accept.t                                               Broken overflow handling
test_multishot_accept(1, false, true) failed
Test accept.t failed with ret 1
Running test accept-link.t                                          0 sec
Running test accept-non-empty.t                                     Skipped
Running test accept-reuse.t                                         0 sec
Running test accept-test.t                                          0 sec
Running test across-fork.t                                          0 sec
Running test b19062a56726.t                                         0 sec
Running test b5837bd5311d.t                                         0 sec
Running test bind-listen.t                                          Skipped
Running test buf-ring.t                                             ./runtests.sh: line 66:  9194 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test buf-ring.t failed with ret 139
Running test buf-ring-nommap.t                                      ./runtests.sh: line 66:  9201 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test buf-ring-nommap.t failed with ret 139
Running test buf-ring-put.t                                         1 sec
Running test ce593a6c480a.t                                         1 sec
Running test close-opath.t                                          0 sec
Running test connect.t                                              0 sec
Running test connect-rep.t                                          0 sec
Running test coredump.t                                             0 sec
Running test cmd-discard.t                                          Skipped
Running test cq-full.t                                              0 sec
Running test cq-overflow.t                                          ./runtests.sh: line 66:  9271 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test cq-overflow.t failed with ret 139
Running test cq-peek-batch.t                                        0 sec
Running test cq-ready.t                                             0 sec
Running test cq-size.t                                              0 sec
Running test d4ae271dfaae.t                                         ./runtests.sh: line 66:  9299 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test d4ae271dfaae.t failed with ret 139
Running test d77a67ed5f27.t                                         1 sec
Running test defer.t                                                3 sec
Running test defer-taskrun.t                                        child failed 0
0 sec
Running test defer-tw-timeout.t                                     ./runtests.sh: line 66:  9334 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test defer-tw-timeout.t failed with ret 139
Running test double-poll-crash.t                                    0 sec
Running test drop-submit.t                                          0 sec
Running test eeed8b54e0df.t                                         0 sec
Running test empty-eownerdead.t                                     0 sec
Running test eploop.t                                               0 sec
Running test epwait.t                                               Skipped
Running test eventfd.t                                              0 sec
Running test eventfd-disable.t                                      0 sec
Running test eventfd-reg.t                                          0 sec
Running test eventfd-ring.t                                         0 sec
Running test evloop.t                                               0 sec
Running test exec-target.t                                          0 sec
Running test exit-no-cleanup.t                                      0 sec
Running test fadvise.t                                              0 sec
Running test fallocate.t                                            0 sec
Running test fc2a85cb02ef.t                                         Test needs failslab/fail_futex/fail_page_alloc enabled, skipped
Skipped
Running test fd-install.t                                           Skipped
Running test fd-pass.t                                              0 sec
Running test fdinfo.t                                               ./runtests.sh: line 66:  9518 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test fdinfo.t failed with ret 139
Running test fifo-nonblock-read.t                                   0 sec
Running test file-exit-unreg.t                                      1 sec
Running test file-register.t                                        test_huge: No huge file set support, skipping
3 sec
Running test files-exit-hang-poll.t                                 1 sec
Running test files-exit-hang-timeout.t                              1 sec
Running test file-update.t                                          0 sec
Running test file-verify.t                                          ./runtests.sh: line 66:  9568 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test file-verify.t failed with ret 139
Running test fixed-buf-iter.t                                       0 sec
Running test fixed-buf-merge.t                                      ./runtests.sh: line 66:  9582 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test fixed-buf-merge.t failed with ret 139
Running test fixed-hugepage.t                                       Unable to map hugetlb page. Try increasing the value in /proc/sys/vm/nr_hugepages
Skipped
Running test fixed-link.t                                           0 sec
Running test fixed-reuse.t                                          0 sec
Running test fixed-seg.t                                            ./runtests.sh: line 66:  9610 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test fixed-seg.t failed with ret 139
Running test fpos.t                                                 0 sec
Running test fsnotify.t                                             Skipped
Running test fsync.t                                                0 sec
Running test futex.t                                                Skipped
Running test hardlink.t                                             not root, skipping AT_EMPTY_PATH test
0 sec
Running test ignore-single-mmap.t                                   0 sec
Running test init-mem.t                                             ./runtests.sh: line 66:  9665 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test init-mem.t failed with ret 139
Running test io-cancel.t                                            ./runtests.sh: line 66:  9672 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test io-cancel.t failed with ret 139
Running test iopoll.t                                               ./runtests.sh: line 66:  9684 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test iopoll.t failed with ret 139
Running test iopoll-leak.t                                          0 sec
Running test iopoll-overflow.t                                      ./runtests.sh: line 66:  9714 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test iopoll-overflow.t failed with ret 139
Running test io_uring_enter.t                                       0 sec
Running test io_uring_passthrough.t                                 Skipped
Running test io_uring_register.t                                    Unable to map a huge page.  Try increasing /proc/sys/vm/nr_hugepages by at least 1.
Skipping the hugepage test
0 sec
Running test io_uring_setup.t                                       0 sec
Running test iowait.t                                               Skipped
Running test kallsyms.t                                             ./runtests.sh: line 66:  9757 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test kallsyms.t failed with ret 139
Running test lfs-openat.t                                           0 sec
Running test lfs-openat-write.t                                     0 sec
Running test link.t                                                 0 sec
Running test link_drain.t                                           1 sec
Running test link-timeout.t                                         2 sec
Running test linked-defer-close.t                                   0 sec
Running test madvise.t                                              0 sec
Running test min-timeout.t                                          Skipped
Running test min-timeout-wait.t                                     Skipped
Running test mkdir.t                                                0 sec
Running test msg-ring.t                                             0 sec
Running test msg-ring-fd.t                                          0 sec
Running test msg-ring-flags.t                                       0 sec
Running test msg-ring-overflow.t                                    0 sec
Running test multicqes_drain.t                                      20 sec
Running test napi-test.t                                            NAPI test requires root
Skipped
Running test no-mmap-inval.t                                        ./runtests.sh: line 66: 10009 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test no-mmap-inval.t failed with ret 139
Running test nop-all-sizes.t                                        0 sec
Running test nop.t                                                  expected injected result, got 0
test_nop_inject failed
Normal ring test failed: default
Test nop.t failed with ret 1
Running test ooo-file-unreg.t                                       1 sec
Running test openat2.t                                              0 sec
Running test open-close.t                                           0 sec
Running test open-direct-link.t                                     0 sec
Running test open-direct-pick.t                                     0 sec
Running test personality.t                                          Not root, skipping
0 sec
Running test pipe-bug.t                                             1 sec
Running test pipe-eof.t                                             0 sec
Running test pipe-reuse.t                                           0 sec
Running test poll.t                                                 0 sec
Running test poll-cancel.t                                          0 sec
Running test poll-cancel-all.t                                      0 sec
Running test poll-cancel-ton.t                                      0 sec
Running test poll-link.t                                            0 sec
Running test poll-many.t                                            2 sec
Running test poll-mshot-overflow.t                                  0 sec
Running test poll-mshot-update.t                                    3 sec
Running test poll-race.t                                            0 sec
Running test poll-race-mshot.t                                      ./runtests.sh: line 66: 13170 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test poll-race-mshot.t failed with ret 139
Running test poll-ring.t                                            0 sec
Running test poll-v-poll.t                                          0 sec
Running test pollfree.t                                             10 sec
Running test probe.t                                                0 sec
Running test read-before-exit.t                                     1 sec
Running test read-inc-file.t                                        ./runtests.sh: line 66: 33891 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test read-inc-file.t failed with ret 139
Running test read-mshot.t                                           skip
Skipped
Running test read-mshot-empty.t                                     Skipped
Running test read-mshot-stdin.t                                     Skipped
Running test read-write.t                                           ./runtests.sh: line 66: 33919 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test read-write.t failed with ret 139
Running test recv-bundle-short-ooo.t                                Skipped
Running test recv-msgall.t                                          0 sec
Running test recv-msgall-stream.t                                   0 sec
Running test recv-multishot.t                                       0 sec
Running test reg-fd-only.t                                          Enable huge pages to test big rings
Skipped
Running test reg-hint.t                                             0 sec
Running test reg-reg-ring.t                                         0 sec
Running test reg-wait.t                                             ./runtests.sh: line 66: 33981 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test reg-wait.t failed with ret 139
Running test regbuf-clone.t                                         Skipped
Running test regbuf-merge.t                                         0 sec
Running test register-restrictions.t                                0 sec
Running test rename.t                                               0 sec
Running test resize-rings.t                                         0 sec
Running test ringbuf-read.t                                         ./runtests.sh: line 66: 34025 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test ringbuf-read.t failed with ret 139
Running test ringbuf-status.t                                       ./runtests.sh: line 66: 34032 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test ringbuf-status.t failed with ret 139
Running test ring-leak2.t                                           1 sec
Running test ring-leak.t                                            Skipped
Running test rsrc_tags.t                                            0 sec
Running test rw_merge_test.t                                        0 sec
Running test self.t                                                 0 sec
Running test recvsend_bundle.t                                      ./runtests.sh: line 66: 34081 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test recvsend_bundle.t failed with ret 139
Running test recvsend_bundle-inc.t                                  ./runtests.sh: line 66: 34089 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test recvsend_bundle-inc.t failed with ret 139
Running test send_recv.t                                            0 sec
Running test send_recvmsg.t                                         0 sec
Running test send-zerocopy.t                                        ./runtests.sh: line 66: 34157 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test send-zerocopy.t failed with ret 139
Running test sendmsg_iov_clean.t                                    1 sec
Running test shared-wq.t                                            0 sec
Running test short-read.t                                           0 sec
Running test shutdown.t                                             0 sec
Running test sigfd-deadlock.t                                       0 sec
Running test single-issuer.t                                        0 sec
Running test skip-cqe.t                                             0 sec
Running test socket.t                                               0 sec
Running test socket-io-cmd.t                                        Not able to create a raw socket: Operation not permitted
Skipped
Running test socket-getsetsock-cmd.t                                Skipping tests.
Skipped
Running test socket-nb.t                                            0 sec
Running test socket-rw.t                                            0 sec
Running test socket-rw-eagain.t                                     0 sec
Running test socket-rw-offset.t                                     0 sec
Running test splice.t                                               0 sec
Running test sq-full.t                                              0 sec
Running test sq-full-cpp.t                                          0 sec
Running test sqpoll-disable-exit.t                                  0 sec
Running test sqpoll-exec.t                                          0 sec
Running test sq-poll-dup.t                                          ./runtests.sh: line 66: 34540 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test sq-poll-dup.t failed with ret 139
Running test sqpoll-exit-hang.t                                     1 sec
Running test sq-poll-kthread.t                                      2 sec
Running test sq-poll-share.t                                        ./runtests.sh: line 66: 34572 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test sq-poll-share.t failed with ret 139
Running test sqpoll-sleep.t                                         0 sec
Running test sq-space_left.t                                        0 sec
Running test sqwait.t                                               ./runtests.sh: line 66: 34594 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test sqwait.t failed with ret 139
Running test stdout.t                                               This is a pipe test
./runtests.sh: line 66: 34601 Segmentation fault      timeout -s INT -k $TIMEOUT $TIMEOUT "${test_exec[@]}"
Test stdout.t failed with ret 139
Running test submit-and-wait.t                                      1 sec
Running test submit-link-fail.t                                     0 sec
Running test submit-reuse.t                                         2 sec
Running test symlink.t                                              0 sec
Running test sync-cancel.t                                          0 sec
Running test teardowns.t                                            0 sec
Running test thread-exit.t                                          0 sec
Running test timeout.t                                              too long, timeout wasn't updated (expired after 10000 instead of 200)
test_update_multishot_timeouts linked failed
Test timeout.t failed with ret 1
Running test timeout-new.t                                          2 sec
Running test truncate.t                                             Ftruncate not supported, skipping
0 sec
Running test tty-write-dpoll.t                                      0 sec
Running test unlink.t                                               0 sec
Running test uring_cmd_ublk.t                                       Skipped
Running test version.t                                              0 sec
Running test waitid.t                                               Skipped
Running test wait-timeout.t                                         Skipped
Running test wakeup-hang.t                                          2 sec
Running test wq-aff.t                                               Skipped
Running test xattr.t                                                0 sec
Running test zcrx.t                                                 Skipped
Running test vec-regbuf.t                                           doesn't support registered vector ops, skip
Skipped
Running test statx.t                                                0 sec
Running test sq-full-cpp.t                                          0 sec [0]
Test run complete, kernel: 6.6.14-0-lts #1-Alpine SMP PREEMPT_DYNAMIC Fri, 26 Jan 2024 11:08:07 +0000
Tests failed (32): <500f9fbadef8.t> <accept.t> <buf-ring.t> <buf-ring-nommap.t> <cq-overflow.t> <d4ae271dfaae.t> <defer-tw-timeout.t> <fdinfo.t> <file-verify.t> <fixed-buf-merge.t> <fixed-seg.t> <init-mem.t> <io-cancel.t> <iopoll.t> <iopoll-overflow.t> <kallsyms.t> <no-mmap-inval.t> <nop.t> <poll-race-mshot.t> <read-inc-file.t> <read-write.t> <reg-wait.t> <ringbuf-read.t> <ringbuf-status.t> <recvsend_bundle.t> <recvsend_bundle-inc.t> <send-zerocopy.t> <sq-poll-dup.t> <sq-poll-share.t> <sqwait.t> <stdout.t> <timeout.t>
make[1]: *** [Makefile:329: runtests] Error 1
make[1]: Leaving directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.10/test'
make: *** [Makefile:21: runtests] Error 2
>>> ERROR: liburing: check failed

--1zKi4YPGXtrRaH/r--

