Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29ED69858B
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 21:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBOU2C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 15:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBOU2C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 15:28:02 -0500
Received: from cmx-torrgo001.bell.net (mta-tor-002.bell.net [209.71.212.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8913803F;
        Wed, 15 Feb 2023 12:27:58 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63EA076D004969AF
X-CM-Envelope: MS4xfA9BiB1NbR/q2cKniMlxVecT1eNnYOYg+226wRCNt4Nnw7cRbb5q/ZI7F94clHvroDLaPGTmdouk/JWY39cP709vNw7HS0Y+bPPLVa5l7wWOBiA9Y/dq
 3qzU5/jhL3r2dFRTIeXa3MVKECIraLIxeIoRqd69rK2H0N2SWj6+avFSE4QpUUAMb01q59HVSSqt5RengfVzTaHzkjGm9NcRlLG56Z+4mV2Tu1cToUX5WWfp
 LLVfHUqefYkdOKM4Pi3sXI8hh0RLa3oqR5O4DwimP6ZWno3yIv4JiSR72msQO4/reCGJXbY5n7Uf9ZrpupMWuabHjw+UVmBMmEM1fpN1QZBmMaLDvVR4cLou
 KhLLGsZW3wKwAkndHsXSCgkza6L437Sun46Kw1GNe31ZnqHECAg=
X-CM-Analysis: v=2.4 cv=M8Iulw8s c=1 sm=1 tr=0 ts=63ed404a
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=9pz9FOdkCKetEUiEys8A:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63EA076D004969AF; Wed, 15 Feb 2023 15:27:54 -0500
Message-ID: <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
Date:   Wed, 15 Feb 2023 15:27:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Helge Deller <deller@gmx.de>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
 <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-15 2:16 p.m., Jens Axboe wrote:
> In any case, with the silly syzbot mmap stuff fixed up, I'm not seeing
> anything odd. A few tests will time out as they simply run too slowly
> emulated for me, but apart from that, seems fine. This is running with
> Helge's patch, though not sure if that is required running emulated.
I'm seeing two problematic tests:

test buf-ring.t generates on console:
TCP: request_sock_TCP: Possible SYN flooding on port 8495. Sending cookies.  Check SNMP counters.

System crashes running test buf-ring.t.

dave@mx3210:~/gnu/liburing/liburing$ make runtests
make[1]: Entering directory '/home/dave/gnu/liburing/liburing/src'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/dave/gnu/liburing/liburing/src'
make[1]: Entering directory '/home/dave/gnu/liburing/liburing/test'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/dave/gnu/liburing/liburing/test'
make[1]: Entering directory '/home/dave/gnu/liburing/liburing/examples'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/dave/gnu/liburing/liburing/examples'
make[1]: Entering directory '/home/dave/gnu/liburing/liburing/test'
Running test 232c93d07b74.t 5 sec [5]
Running test 35fa71a030ca.t 5 sec [5]
Running test 500f9fbadef8.t 25 sec [25]
Running test 7ad0e4b2f83c.t 1 sec [1]
Running test 8a9973408177.t 1 sec [0]
Running test 917257daa0fe.t 0 sec [0]
Running test a0908ae19763.t 0 sec [0]
Running test a4c0b3decb33.t Test a4c0b3decb33.t timed out (may not be a failure)
Running test accept.t 1 sec [1]
Running test accept-link.t 1 sec [1]
Running test accept-reuse.t 0 sec [0]
Running test accept-test.t 0 sec [0]
Running test across-fork.t 0 sec [0]
Running test b19062a56726.t 0 sec [0]
Running test b5837bd5311d.t 0 sec [0]
Running test buf-ring.t bad run 0/0 = -233
test_running(1) failed
Test buf-ring.t failed with ret 1
Running test ce593a6c480a.t 1 sec [1]
Running test close-opath.t 0 sec [0]
Running test connect.t 0 sec [0]
Running test cq-full.t 0 sec [0]
Running test cq-overflow.t 12 sec [11]
Running test cq-peek-batch.t 0 sec [0]
Running test cq-ready.t 0 sec [0]
Running test cq-size.t 0 sec [0]
Running test d4ae271dfaae.t 0 sec [1]
Running test d77a67ed5f27.t 0 sec [0]
Running test defer.t 4 sec [3]
Running test defer-taskrun.t 0 sec [0]
Running test double-poll-crash.t Skipped
Running test drop-submit.t 0 sec [0]
Running test eeed8b54e0df.t 0 sec [0]
Running test empty-eownerdead.t 0 sec [0]
Running test eploop.t 0 sec [0]
Running test eventfd.t 0 sec [0]
Running test eventfd-disable.t 0 sec [0]
Running test eventfd-reg.t 0 sec [0]
Running test eventfd-ring.t 1 sec [0]
Running test evloop.t 0 sec [0]
Running test exec-target.t 0 sec [0]
Running test exit-no-cleanup.t 0 sec [0]
Running test fadvise.t 0 sec [1]
Running test fallocate.t 0 sec [0]
Running test fc2a85cb02ef.t Test needs failslab/fail_futex/fail_page_alloc enabled, skipped
Skipped
Running test fd-pass.t 0 sec [0]
Running test file-register.t 4 sec [4]
Running test files-exit-hang-poll.t 1 sec [1]
Running test files-exit-hang-timeout.t 1 sec [2]
Running test file-update.t 0 sec [0]
Running test file-verify.t Found 262144, wanted 786432
Buffered novec reg test failed
Test file-verify.t failed with ret 1
Running test fixed-buf-iter.t 0 sec [0]
Running test fixed-link.t 0 sec [0]
Running test fixed-reuse.t 0 sec [0]
Running test fpos.t 0 sec [1]
Running test fsnotify.t Skipped
Running test fsync.t 0 sec [0]
Running test hardlink.t 0 sec [0]
Running test io-cancel.t 3 sec [4]
Running test iopoll.t 2 sec [2]
Running test iopoll-leak.t 0 sec [0]
Running test iopoll-overflow.t 1 sec [1]
Running test io_uring_enter.t 0 sec [1]
Running test io_uring_passthrough.t Skipped
Running test io_uring_register.t Unable to map a huge page.  Try increasing /proc/sys/vm/nr_hugepages by at least 1.
Skipping the hugepage test
0 sec [0]
Running test io_uring_setup.t 0 sec [0]
Running test lfs-openat.t 0 sec [0]
Running test lfs-openat-write.t 0 sec [0]
Running test link.t 0 sec [0]
Running test link_drain.t 3 sec [3]
Running test link-timeout.t 1 sec [1]
Running test madvise.t 0 sec [1]
Running test mkdir.t 0 sec [0]
Running test msg-ring.t 0 sec [0]
Running test msg-ring-flags.t Skipped
Running test msg-ring-overflow.t 0 sec [0]
Running test multicqes_drain.t 26 sec [26]
Running test nolibc.t Skipped
Running test nop-all-sizes.t 0 sec [0]
Running test nop.t 0 sec [1]
Running test openat2.t 0 sec [0]
Running test open-close.t 0 sec [0]
Running test open-direct-link.t 0 sec [0]
Running test open-direct-pick.t 0 sec [0]
Running test personality.t Not root, skipping
0 sec [0]
Running test pipe-bug.t 6 sec [6]
Running test pipe-eof.t 0 sec [1]
Running test pipe-reuse.t 0 sec [0]
Running test poll.t 1 sec [0]
Running test poll-cancel.t 0 sec [0]
Running test poll-cancel-all.t 0 sec [0]
Running test poll-cancel-ton.t 0 sec [1]
Running test poll-link.t 1 sec [0]
Running test poll-many.t 18 sec [19]
Running test poll-mshot-overflow.t 0 sec [0]
Running test poll-mshot-update.t 21 sec
Running test poll-race.t 2 sec
Running test poll-race-mshot.t Bad cqe res -233
Bad cqe res -233
Bad cqe res -233
Bad cqe res -233
...

This run was on ext4 file system.

-- 
John David Anglin  dave.anglin@bell.net

