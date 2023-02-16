Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5885169A205
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 00:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBPXAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 18:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPXAj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 18:00:39 -0500
Received: from cmx-mtlrgo002.bell.net (mta-mtl-001.bell.net [209.71.208.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E7B6A73;
        Thu, 16 Feb 2023 15:00:36 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35FA800E20B4A
X-CM-Envelope: MS4xfE/HGTkyVCUaSoymjwE8YD41LuO3nqRj8ioKWwT1OkI2/WCrXc2BVrM8OKG8OwLInOHIFVZfBY5MSUMiNCO0jYXzglWiDlKoQ2fkiKYFj1wm/WALdrD8
 pJUFuanFiNax2/Ru5+pJ48+T9bvhfpLYGTL0x+lP8zeHVPnqWPDWw5nU15QBFOsBzioGUyI5OyPWIz8xUacCpJ8kJOHeJ72w96VKn9tDMgrvN/UHxY46t4W9
 wb1brRYyC1Gn2DsDyjoX5ruYWzdo63PRvGXQrLne9auDiZ0Y0o7ivKD++s49x02uMFD2HXrRodMR1mrJU5gkA+9CA5za7MPSOLpfYufOg+w=
X-CM-Analysis: v=2.4 cv=GcB0ISbL c=1 sm=1 tr=0 ts=63eeb593
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=YEEYbGNX1nJM0OX3qEIA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35FA800E20B4A; Thu, 16 Feb 2023 18:00:35 -0500
Message-ID: <64ff4872-cc6f-1e6a-46e5-573c7e64e4c9@bell.net>
Date:   Thu, 16 Feb 2023 18:00:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US
To:     linux-parisc <linux-parisc@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Helge Deller <deller@gmx.de>
From:   John David Anglin <dave.anglin@bell.net>
Subject: liburing test results on hppa
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Here are liburing test results on hppa:

Running test 232c93d07b74.t 5 sec [5]
Running test 35fa71a030ca.t 5 sec [5]
Running test 500f9fbadef8.t 25 sec [25]
Running test 7ad0e4b2f83c.t 1 sec [1]
Running test 8a9973408177.t 0 sec [0]
Running test 917257daa0fe.t 0 sec [0]
Running test a0908ae19763.t 0 sec [0]
Running test a4c0b3decb33.t Test a4c0b3decb33.t timed out (may not be a failure)
Running test accept.t 2 sec [2]
Running test accept-link.t 0 sec [0]
Running test accept-reuse.t 0 sec [0]
Running test accept-test.t 0 sec [0]
Running test across-fork.t 0 sec [0]
Running test b19062a56726.t 0 sec [1]
Running test b5837bd5311d.t 0 sec [0]
Running test buf-ring.t bad run 0/0 = -233
test_running(1) failed
Test buf-ring.t failed with ret 1
Running test ce593a6c480a.t 1 sec [1]
Running test close-opath.t 0 sec [0]
Running test connect.t 0 sec [0]
Running test cq-full.t 0 sec [0]
Running test cq-overflow.t 12 sec [12]
Running test cq-peek-batch.t 0 sec [0]
Running test cq-ready.t 0 sec [0]
Running test cq-size.t 0 sec [0]
Running test d4ae271dfaae.t 0 sec [0]
Running test d77a67ed5f27.t 0 sec [0]
Running test defer.t 3 sec [3]
Running test defer-taskrun.t 1 sec [0]
Running test double-poll-crash.t Skipped
Running test drop-submit.t 0 sec [0]
Running test eeed8b54e0df.t 0 sec [0]
Running test empty-eownerdead.t 0 sec [0]
Running test eploop.t 0 sec [0]
Running test eventfd.t 0 sec [0]
Running test eventfd-disable.t 0 sec [0]
Running test eventfd-reg.t 0 sec [0]
Running test eventfd-ring.t 0 sec [0]
Running test evloop.t 0 sec [0]
Running test exec-target.t 0 sec [0]
Running test exit-no-cleanup.t 0 sec [0]
Running test fadvise.t 0 sec [0]
Running test fallocate.t 0 sec [0]
Running test fc2a85cb02ef.t Test needs failslab/fail_futex/fail_page_alloc enabled, skipped
Skipped
Running test fd-pass.t 1 sec [0]
Running test file-register.t 4 sec [4]
Running test files-exit-hang-poll.t 1 sec [1]
Running test files-exit-hang-timeout.t 1 sec [1]
Running test file-update.t 0 sec [0]
Running test file-verify.t Found 98528, wanted 622816
Buffered novec reg test failed
Test file-verify.t failed with ret 1
Running test fixed-buf-iter.t 0 sec [0]
Running test fixed-link.t 0 sec [0]
Running test fixed-reuse.t 0 sec [0]
Running test fpos.t 1 sec [0]
Running test fsnotify.t Skipped
Running test fsync.t 0 sec [0]
Running test hardlink.t 0 sec [1]
Running test io-cancel.t 4 sec [3]
Running test iopoll.t 2 sec [2]
Running test iopoll-leak.t 0 sec [0]
Running test iopoll-overflow.t 1 sec [1]
Running test io_uring_enter.t 1 sec [0]
Running test io_uring_passthrough.t Skipped
Running test io_uring_register.t Unable to map a huge page.  Try increasing /proc/sys/vm/nr_hugepages by at least 1.
Skipping the hugepage test
0 sec [0]
Running test io_uring_setup.t 0 sec [0]
Running test lfs-openat.t 0 sec [0]
Running test lfs-openat-write.t 0 sec [0]
Running test link.t 0 sec [0]
Running test link_drain.t 3 sec [2]
Running test link-timeout.t 1 sec [2]
Running test madvise.t 1 sec [0]
Running test mkdir.t 0 sec [0]
Running test msg-ring.t 0 sec [1]
Running test msg-ring-flags.t Skipped
Running test msg-ring-overflow.t 0 sec [0]
Running test multicqes_drain.t 26 sec [25]
Running test nolibc.t Skipped
Running test nop-all-sizes.t 0 sec [1]
Running test nop.t 1 sec [0]
Running test openat2.t 0 sec [0]
Running test open-close.t 0 sec [0]
Running test open-direct-link.t 0 sec [0]
Running test open-direct-pick.t 0 sec [0]
Running test personality.t Not root, skipping
0 sec [0]
Running test pipe-bug.t 6 sec [5]
Running test pipe-eof.t 0 sec [0]
Running test pipe-reuse.t 0 sec [0]
Running test poll.t 1 sec [1]
Running test poll-cancel.t 0 sec [0]
Running test poll-cancel-all.t 0 sec [0]
Running test poll-cancel-ton.t 0 sec [0]
Running test poll-link.t 1 sec [1]
Running test poll-many.t 19 sec [19]
Running test poll-mshot-overflow.t 0 sec [0]
Running test poll-mshot-update.t 21 sec [21]
Running test poll-race.t 2 sec [2]
Running test poll-race-mshot.t Skipped
Running test poll-ring.t 0 sec [0]
Running test poll-v-poll.t 0 sec [0]
Running test pollfree.t 0 sec [0]
Running test probe.t 0 sec [0]
Running test read-before-exit.t 3 sec [5]
Running test read-write.t Not root, skipping test_write_efbig
8 sec [8]
Running test recv-msgall.t 1 sec [0]
Running test recv-msgall-stream.t 0 sec [0]
Running test recv-multishot.t 3 sec [3]
Running test register-restrictions.t 0 sec [0]
Running test rename.t 0 sec [0]
Running test ringbuf-read.t cqe res -233
dio test failed
Test ringbuf-read.t failed with ret 1
Running test ring-leak2.t 1 sec [1]
Running test ring-leak.t 0 sec [0]
Running test rsrc_tags.t 16 sec [16]
Running test rw_merge_test.t 0 sec [0]
Running test self.t 0 sec [0]
Running test sendmsg_fs_cve.t chroot not allowed, skip
0 sec [0]
Running test send_recv.t 0 sec [0]
Running test send_recvmsg.t do_recvmsg: failed cqe: -233
send_recvmsg 0 1 0 1 0 failed
Test send_recvmsg.t failed with ret 1
Running test send-zerocopy.t Test send-zerocopy.t timed out (may not be a failure)
Running test shared-wq.t 0 sec [0]
Running test short-read.t 0 sec [0]
Running test shutdown.t 0 sec [0]
Running test sigfd-deadlock.t 0 sec [0]
Running test single-issuer.t 0 sec [0]
Running test skip-cqe.t 0 sec [0]
Running test socket.t 0 sec [0]
Running test socket-rw.t 0 sec [0]
Running test socket-rw-eagain.t 0 sec [0]
Running test socket-rw-offset.t 0 sec [0]
Running test splice.t 0 sec [0]
Running test sq-full.t 0 sec [1]
Running test sq-full-cpp.t 0 sec [0]
Running test sqpoll-cancel-hang.t Skipped
Running test sqpoll-disable-exit.t 2 sec [2]
Running test sq-poll-dup.t 6 sec [5]
Running test sqpoll-exit-hang.t 1 sec [1]
Running test sq-poll-kthread.t 2 sec [3]
Running test sq-poll-share.t 13 sec [11]
Running test sqpoll-sleep.t 0 sec [0]
Running test sq-space_left.t 0 sec [0]
Running test stdout.t This is a pipe test
This is a fixed pipe test
0 sec [1]
Running test submit-and-wait.t 1 sec [1]
Running test submit-link-fail.t 0 sec [0]
Running test submit-reuse.t 1 sec [1]
Running test symlink.t 0 sec [0]
Running test sync-cancel.t 1 sec [0]
Running test teardowns.t 0 sec [0]
Running test thread-exit.t 0 sec [1]
Running test timeout.t 6 sec [6]
Running test timeout-new.t 3 sec [2]
Running test timeout-overflow.t Skipped
Running test tty-write-dpoll.t 0 sec [0]
Running test unlink.t 0 sec [0]
Running test version.t 0 sec [0]
Running test wakeup-hang.t 2 sec [2]
Running test xattr.t 0 sec [0]
Running test statx.t 0 sec [0]
Running test sq-full-cpp.t 1 sec [0]
Tests timed out (2): <a4c0b3decb33.t> <send-zerocopy.t>
Tests failed (4): <buf-ring.t> <file-verify.t> <ringbuf-read.t> <send_recvmsg.t>
make[1]: *** [Makefile:250: runtests] Error 1
make[1]: Leaving directory '/home/dave/gnu/liburing/liburing/test'
make: *** [Makefile:21: runtests] Error 2

I modified poll-race-mshot.t to skip on hppa.  Added handle_tw_list and io_uring_try_cancel_requests fixes.
This appears to have fixed stalls.

Dave

-- 
John David Anglin  dave.anglin@bell.net

