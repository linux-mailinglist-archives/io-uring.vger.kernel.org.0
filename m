Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C3D342921
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 00:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCSX1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 19:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCSX1l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 19:27:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE90C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 16:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=VW8GoxzzUXv77dIyAQVjSrzgRJLeFnd+djubsH2WGbA=; b=OJZ9SMN1ZTm3CvA1We2Z2MKdI4
        UOkmjtypU2U7g2dBqbPJOcsmnFDleOt1vY0w7S2o9qlkFatGaNv69hVXB021V0vsBbfTwTtcNlLxW
        AM0QwORU+s3tJobcaFFZ2xftB1idzR7FOIKczM2GOm8tMGgD/U6rUMROugTmxTIVH7P5AgqTrdfVL
        yeKJ4YV1VS4CYX2N0hTyfB4N1+WK/IJlPhve/4LnMflZy5CIwpO11Axbe7V3u7//omZWEZSVFBMMb
        KS+vj/Y9lw3fu/YXaOs3dBP0jn3xXhYm6FGor6FIy8n3BM/VyWHXgrtk41xmF9qjDcZ+BefdjtCms
        syPthCqpOluRyHXaZJCzeBh5GM8iZsXH1kYcvwcWCBTK26c5YffuixYPl4j4ZWOSdjyLc7O75SJdy
        sOfLRt7ecQYwhH/2Gn0qQ107fgFH+RX5CJ5Lg0LY0n25l0S9FF5WEYKnm6Cf6PZ//FO6DSBlEOIR/
        mbPaFnk+epQialmJZ9Gr23al;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNOWj-0007Lx-Gl; Fri, 19 Mar 2021 23:27:33 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Problems with io_threads
Message-ID: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
Date:   Sat, 20 Mar 2021 00:27:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

as said before I found some problems related to
the new io_threads together with signals.

I applied the diff (at the end) to examples/io_uring-cp.c
in order to run endless in order to give me time to
look at /proc/...

Trying to attach gdb --pid to the pid of the main process (thread group)
it goes into an endless loop because it can't attach to the io_threads.

Sending kill -STOP to the main pid causes the io_threads to spin cpu
at 100%.

Can you try to reproduce and fix it? Maybe same_thread_group() should not match?

Thanks!
metze

--- a/examples/io_uring-cp.c
+++ b/examples/io_uring-cp.c
@@ -116,17 +116,18 @@ static void queue_write(struct io_uring *ring, struct io_data *data)
        io_uring_submit(ring);
 }

-static int copy_file(struct io_uring *ring, off_t insize)
+static int copy_file(struct io_uring *ring, off_t _insize)
 {
        unsigned long reads, writes;
        struct io_uring_cqe *cqe;
        off_t write_left, offset;
        int ret;

-       write_left = insize;
+       write_left = _insize;
        writes = reads = offset = 0;

-       while (insize || write_left) {
+       while (_insize || write_left) {
+               off_t insize = _insize;
                int had_reads, got_comp;

                /*
@@ -219,6 +220,10 @@ static int copy_file(struct io_uring *ring, off_t insize)
                        }
                        io_uring_cqe_seen(ring, cqe);
                }
+
+               sleep(1);
+               write_left = _insize;
+               writes = reads = offset = 0;
        }

        return 0;
