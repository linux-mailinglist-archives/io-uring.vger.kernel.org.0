Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6472C5115D8
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiD0K7p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Apr 2022 06:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbiD0K7R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Apr 2022 06:59:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22933DAD2E
        for <io-uring@vger.kernel.org>; Wed, 27 Apr 2022 03:36:42 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0] helo=igor.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <s.trumtrar@pengutronix.de>)
        id 1njeZV-000870-Dz; Wed, 27 Apr 2022 12:06:57 +0200
User-agent: mu4e 1.4.13; emacs 29.0.50
From:   Steffen Trumtrar <s.trumtrar@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: [BUG] Layerscape CAAM+kTLS+io_uring
Date:   Wed, 27 Apr 2022 10:20:40 +0200
Message-ID: <878rrqrgaj.fsf@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: s.trumtrar@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi all,

I have a Layerscape-1046a based board where I'm trying to use a
combination of liburing (v2.0) with splice, kTLS and CAAM (kernel
v5.17). The problem I see is that on shutdown the last bytes are
missing. It looks like io_uring is not waiting for all completions
from the CAAM driver.

With ARM-ASM instead of the CAAM, the setup works fine.

I tried to debug with ftrace and see where it goes wrong. Here is what
seems to be (at least to me) some of the last bytes:

 webserver-612     [002] .....   135.300350: io_uring_file_get: ring 0000000078f4a859, fd 6 00078f4a859, fd 7
       webserver-612     [002] .....   135.300352: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000fbb9b849, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300353: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000ff858bdf, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300353: io_uring_link: ring 0000000078f4a859, request 00000000ff858bdf linked after 00000000fbb9b849
       webserver-612     [002] .....   135.300354: io_uring_queue_async_work: ring 0000000078f4a859, request 00000000fbb9b849, flags 798724, normal queue, work 0000000060cd323f
       webserver-612     [002] .....   135.300358: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300375: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4352, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300379: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300388: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300389: io_uring_file_get: ring 0000000078f4a859, fd 7 0000078f4a859, req 000000008c2bf2be, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300390: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000fe4e50d1, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300391: io_uring_link: ring 0000000078f4a859, request 00000000fe4e50d1 linked after 000000008c2bf2be
       webserver-612     [002] .....   135.300392: io_uring_queue_async_work: ring 0000000078f4a859, request 000000008c2bf2be, flags 798724, normal queue, work 00000000f2b434fc
       webserver-612     [002] .....   135.300396: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300410: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4352, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300414: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300423: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300424: io_uring_file_get: ring 0000000078f4a859, fd 7
       webserver-612     [002] .....   135.300424: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000e48f3098, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300426: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000ec67d53c, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300426: io_uring_link: ring 0000000078f4a859, request 00000000ec67d53c linked after 00000000e48f3098
       webserver-612     [002] .....   135.300427: io_uring_queue_async_work: ring 0000000078f4a859, request 00000000e48f3098, flags 798724, normal queue, work 000000009e3701da
       webserver-612     [002] .....   135.300431: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300447: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4352, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300452: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300461: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300462: io_uring_file_get: ring 0000000078f4a859, fd 7
       webserver-612     [002] .....   135.300462: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000f658f96f, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0, sq_thread 0
       webserver-612     [002] .....   135.300464: io_uring_link: ring 0000000078f4a859, request 000000006c29e721 linked after 00000000f658f96f
       webserver-612     [002] .....   135.300465: io_uring_queue_async_work: ring 0000000078f4a859, request 00000000f658f96f, flags 798724, normal queue, work 000000007434c68b
       webserver-612     [002] .....   135.300469: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300479: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4608, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300483: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300492: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300493: io_uring_file_get: ring 0000000078f4a859, fd 7
       webserver-612     [002] .....   135.300494: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000757ef148, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300495: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000e5c82137, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0 8f4a859, request 00000000e5c82137 linked after 00000000757ef148
       webserver-612     [002] .....   135.300496: io_uring_queue_async_work: ring 0000000078f4a859, request 00000000757ef148, flags 798724, normal queue, work 00000000b55630dd
       webserver-612     [002] .....   135.300500: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300516: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4608, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300520: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300529: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300530: io_uring_file_get: ring 0000000078f4a859, fd 7
       webserver-612     [002] .....   135.300531: io_uring_submit_sqe: ring 0000000078f4a859, req 0000000085e5cac4, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300532: io_uring_submit_sqe: ring 0000000078f4a859, req 0000000008e6a863, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300532: io_uring_link: ring 0000000078f4a859, request 0000000008e6a863 linked after 0000000085e5cac4 ng 0000000078f4a859, request 0000000085e5cac4, flags 798724, normal queue, work 0000000036c4ff52
       webserver-612     [002] .....   135.300537: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300553: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4608, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300557: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300566: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300567: io_uring_file_get: ring 0000000078f4a859, fd 7
       webserver-612     [002] .....   135.300567: io_uring_submit_sqe: ring 0000000078f4a859, req 000000000f7fdd39, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300568: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000741c64e1, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300569: io_uring_link: ring 0000000078f4a859, request 00000000741c64e1 linked after 000000000f7fdd39
       webserver-612     [002] .....   135.300570: io_uring_queue_async_work: ring 0000000078f4a859, request 000000000f7fdd39, flags 798724, normal queue, work 00000000fc4accf1
       webserver-612     [002] .....   135.300574: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300594: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 4352, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300598: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.300607: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.300608: io_uring_file_get: ring 0000000078f4a859, fd 7
       webserver-612     [002] .....   135.300608: io_uring_submit_sqe: ring 0000000078f4a859, req 0000000052b47765, op 30, data 0xf3e096f0, flags 8196, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300610: io_uring_submit_sqe: ring 0000000078f4a859, req 000000003904ded9, op 15, data 0x0, flags 2097152, non block 1, sq_thread 0
       webserver-612     [002] .....   135.300611: io_uring_link: ring 0000000078f4a859, request 000000003904ded9 linked after 0000000052b47765
       webserver-612     [002] .....   135.300612: io_uring_queue_async_work: ring 0000000078f4a859, request 0000000052b47765, flags 798724, normal queue, work 00000000e11c8599
       webserver-612     [002] .....   135.300615: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-647     [003] ...1.   135.300631: io_uring_complete: ring 0000000078f4a859, user_data 0xf3e096f0, result 768, cflags 0
     iou-wrk-612-647     [003] d..2.   135.300634: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result -125, cflags 0
       webserver-612     [002] .....   135.301668: io_uring_file_get: ring 0000000078f4a859, fd 6
       webserver-612     [002] .....   135.301669: io_uring_submit_sqe: ring 0000000078f4a859, req 0000000012863980, op 34, data 0x0, flags 8, non block 1, sq_thread 0
       webserver-612     [002] .....   135.301670: io_uring_submit_sqe: ring 0000000078f4a859, req 00000000f4b07ff9, op 19, data 0x0, flags 0, non block 1, sq_thread 0
       webserver-612     [002] .....   135.301671: io_uring_link: ring 0000000078f4a859, request 00000000f4b07ff9 linked after 0000000012863980
       webserver-612     [002] .....   135.301672: io_uring_queue_async_work: ring 0000000078f4a859, request 0000000012863980, flags 262152, normal queue, work 00000000102270ed
       webserver-612     [002] .....   135.301740: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1
     iou-wrk-612-648     [000] ...1.   135.301757: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result 0, cflags 0
     iou-wrk-612-648     [000] ...1.   135.301767: io_uring_complete: ring 0000000078f4a859, user_data 0x0, result 0, cflags 0
       webserver-612     [002] .....   135.301769: io_uring_cqring_wait: ring 0000000078f4a859, min_events 1


Userspace said that 768 bytes where missing.

Any ideas for how to debug this or why the async work queue doesn't work with
the CAMM but does with ARM-ASM?
If I can provide more info that might help, I'll try to produce and
provide it. As there are multiple components involved, I'm not sure
where to start or what information is useful. Currently looks like CAAM
is the culprit.


Thanks,
Steffen Trumtrar

--
Pengutronix e.K.                | Dipl.-Inform. Steffen Trumtrar |
Steuerwalder Str. 21            | https://www.pengutronix.de/    |
31137 Hildesheim, Germany       | Phone: +49-5121-206917-0       |
Amtsgericht Hildesheim, HRA 2686| Fax:   +49-5121-206917-5555    |
