Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421FD6936BE
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 10:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjBLJrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 04:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBLJrY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 04:47:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED756EC60;
        Sun, 12 Feb 2023 01:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676195239; bh=pYaetCeNFhD9jMHtNXjFKYku2v+SnTfT03mlMT6O1XM=;
        h=X-UI-Sender-Class:Date:To:Cc:From:Subject;
        b=rkm3trIofjMMTz4VgUiKJfVYFdOeP3jH1Q4nQiAh2Gx+ERChRGjWFrBBgRZ/+6Qc4
         DnrQHtXzWCcxbwvMF24RwC+5iHDpYvvSwe6kP5NamJ7m7VI//wBx7Lom6qgK2YDJ4f
         l0aJnEvwfFl8WC67/fUzzGwKtDh71Erd+lYkAwSWP+ZP6e8QWpuw4Cp5Ip6PO9wglO
         CRPki2b9Kb94zbHF8V5C2inH7WxlEnKiS8hx+ggE2nqfQGucjWVCAwyb8lnOwC/V/W
         2sizQZMP7LP9WJRgeruVIBqx/3N5bsael88SA7jc69/DwtFAa3DqjAmXouFKw5ZEn8
         Pk0RRoNIZPVww==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.190.155]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MZktZ-1p75G53anX-00WlRh; Sun, 12
 Feb 2023 10:47:18 +0100
Message-ID: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
Date:   Sun, 12 Feb 2023 10:47:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
From:   Helge Deller <deller@gmx.de>
Subject: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XjftiaIWbvhqrScc2lPC+tCpEJ159g3DK+f3C+ayWmzRzbvU0Kr
 6petg2N3hGobIAMrGXTO85gvDidJvU/CCyIW8cAZZsnHtHf+HyJyUAd2y+HwCNbG38ul0da
 kMc/kJh72AoZK5nG1IUTgMj8mKYZCogFBaq87AaZDOrKVQSpmFxEaykWq1OMh385yajMeEf
 FcdpvEdpIgMt7O9xmCsIg==
UI-OutboundReport: notjunk:1;M01:P0:uKxSYs4Sc88=;Rx8BxntJfFQq+LrJU2Gs1livdgs
 zA6eG/xp4qyle3bRd4P87A8vG9f7sndsgujPZqei1qy8avoQNs89P1X5iajuygEgvfrmLd1wb
 aW1Yxm/lzKzIkJAxQ+L8KZeOYhcU/sBkoKKwhFzTWca7sqDKLhzpSvrM6qMpCVVv/edc0L+pL
 8JWW2o1mVvEIVrm2SknjuqwamPlrVwqmxR5ifE4tQieIRBW/7dZVLjHrjAYYqy/3CvyoVq2gr
 kjz59OnazAK+MvYNYn9O4epYJJdFkE1OpMRFWBJ0lrcPBTN4JuL8ac7AAgKyGo4wX1MMiPnBd
 xgC7IbKluAHs5doactxB5GKmkXYGLiknXoToHh/e0yrmjhugRtlQUnxl6p+GRlrAPNAK1iMXw
 DuMIC/K2UpFbniTTAtfTKHDWSgz4xYSWQsRzjZNpJN1QfYtbgB+qg40WZZEjnYvdOp96Xg481
 AQIZBxBazUmfe9BRWLEbXW1alw9OUa4GVAKth5hX8QD0LqXgmqRwNwOOHxWzAR03MqJDAWk0H
 90mYm6jB4iRyRNdobGYSILaEDIuSdgO8ynqxLt+nxcbaxaXyqdPwrBwFF/I3hF0wZn3BtypQy
 vXicAN2Mwzda+T/8QX+gVSBP7IvaeXenwEB+0NLGoI8X21iMy0sY9xYh3quqVKrfMVfXflh+c
 kxWImAgqVeG3uRAqedRdFtY9MIHlcvNP/BggPpUOVoYZPtMHMMOjuuvQwbhsNkBUj+xoy2h37
 j2pGN04mWgcbcYsb5oR8QOteAHfew0xnRJNobtEZIsGO9R1PKSQeH8kgdel0Um1j8hC/b1kU6
 mJO2BWRecIYvANj9hrIJ2tSC4Kp6gMKo689r0UsVGzoa7ziWPiz9+OVOtW3unb5hmJVkJvEjJ
 22gMqYKD13RIL9zlVc74Zr2JAIVVx0cfaL3naurVS7BjhNBtqVM8Y6w4OxkC2/U+etKCtbgLP
 CdAiJMg5o/gh8d9YYp2k+Z1Xrdk=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

We see io-uring failures on the parisc architecture with this testcase:
https://github.com/axboe/liburing/blob/master/examples/io_uring-test.c

parisc is always big-endian 32-bit userspace, with either 32- or 64-bit kernel.

On a 64-bit kernel (6.1.11):
deller@parisc:~$ ./io_uring-test test.file
ret=0, wanted 4096
Submitted=4, completed=1, bytes=0
-> failure

strace shows:
io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf7522000
mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf6922000
openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT) = 4
statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=689308, ...}) = 0
getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) = 4
brk(NULL)                               = 0x4ae000
brk(0x4cf000)                           = 0x4cf000
io_uring_enter(3, 4, 0, 0, NULL, 8)     = 0


Running the same testcase on a 32-bit kernel (6.1.11) works:
root@debian:~# ./io_uring-test test.file
Submitted=4, completed=4, bytes=16384
-> ok.

strace:
io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf6d4c000
mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf694c000
openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) = 4
statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=1855488, ...}) = 0
getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) = 4
brk(NULL)                               = 0x15000
brk(0x36000)                            = 0x36000
io_uring_enter(3, 4, 0, 0, NULL, 8)     = 4

I'm happy to test any patch if someone has an idea....

Helge
