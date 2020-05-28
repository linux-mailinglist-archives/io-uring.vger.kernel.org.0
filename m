Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6010C1E696A
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 20:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405887AbgE1SfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 14:35:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45683 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405871AbgE1SfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 14:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590690910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tEeJkgIl+i/wOSpCX7S5YeVQHzB++kNLUyoQEw/srww=;
        b=DnjVkJX1O+eCYc9wXgDcQw2y+Fr+kYe9DpFJfv9OPEf6+8qSw5FjUFOxnr1x9wk18oZy37
        BOYED3YpnznTOJNO2QT+6G6JqLr39G0XHaUYu5GghTPyxwry03WsGj/HeYhlKpINjOe3Xk
        ztUA7LTkAuznpWuA1hWOfmPlIP+m0V4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-G3cr1F5aPtuCjIC49KnOlA-1; Thu, 28 May 2020 14:35:08 -0400
X-MC-Unique: G3cr1F5aPtuCjIC49KnOlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D9348014D4;
        Thu, 28 May 2020 18:35:07 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 089AE179C7;
        Thu, 28 May 2020 18:35:06 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     axboe@kernel.dk, Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as unspported
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
        <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 28 May 2020 14:35:05 -0400
In-Reply-To: <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
        (Bijan Mottahedeh's message of "Tue, 19 May 2020 14:52:50 -0700")
Message-ID: <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Bijan Mottahedeh <bijan.mottahedeh@oracle.com> writes:

> Mark a REQ_NOWAIT request for a non-mq queue as unspported instead of
> retryable since otherwise the io_uring layer will keep resubmitting
> the request.

Getting back to this...

Jens, right now (using your io_uring-5.7 or linus' tree) fio's
t/io_uring will never get io completions when run against a file on a
file system that is backed by lvm.  The system will have one workqueue
per sqe submitted, all spinning, eating up CPU time.

# ./t/io_uring /mnt/test/poo 
Added file /mnt/test/poo
sq_ring ptr = 0x0x7fbed40ae000
sqes ptr    = 0x0x7fbed40ac000
cq_ring ptr = 0x0x7fbed40aa000
polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=3851
IOPS=128, IOS/call=6/0, inflight=128 (128)
IOPS=0, IOS/call=0/0, inflight=128 (128)
IOPS=0, IOS/call=0/0, inflight=128 (128)
IOPS=0, IOS/call=0/0, inflight=128 (128)
IOPS=0, IOS/call=0/0, inflight=128 (128)
IOPS=0, IOS/call=0/0, inflight=128 (128)
...

# ps auxw | grep io_wqe
root      3849 80.1  0.0      0     0 ?        R    14:32   0:40 [io_wqe_worker-0]
root      3850  0.0  0.0      0     0 ?        S    14:32   0:00 [io_wqe_worker-0]
root      3853 72.8  0.0      0     0 ?        R    14:32   0:36 [io_wqe_worker-0]
root      3854 81.4  0.0      0     0 ?        R    14:32   0:40 [io_wqe_worker-1]
root      3855 74.8  0.0      0     0 ?        R    14:32   0:37 [io_wqe_worker-0]
root      3856 74.8  0.0      0     0 ?        R    14:32   0:37 [io_wqe_worker-1]
...

# ps auxw | grep io_wqe | grep -v grep | wc -l
129

With this patch applied, the test program will exit without doing I/O
(which I don't think is the right behavior either, right?):

# t/io_uring /mnt/test/poo
Added file /mnt/test/poo
sq_ring ptr = 0x0x7fdb98f00000
sqes ptr    = 0x0x7fdb98efe000
cq_ring ptr = 0x0x7fdb98efc000
polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=33233
io: unexpected ret=-95
Your filesystem/driver/kernel doesn't support polled IO
IOPS=128, IOS/call=32/0, inflight=128 (127)

/mnt/test is an xfs file system on top of a linear LVM volume on an nvme
device (with 8 poll queues configured).

-Jeff

>
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  block/blk-core.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5847993..3807140 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -962,14 +962,10 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  	}
>  
>  	/*
> -	 * Non-mq queues do not honor REQ_NOWAIT, so complete a bio
> -	 * with BLK_STS_AGAIN status in order to catch -EAGAIN and
> -	 * to give a chance to the caller to repeat request gracefully.
> +	 * Non-mq queues do not honor REQ_NOWAIT, return -EOPNOTSUPP.
>  	 */
> -	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q)) {
> -		status = BLK_STS_AGAIN;
> -		goto end_io;
> -	}
> +	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
> +		goto not_supported;
>  
>  	if (should_fail_bio(bio))
>  		goto end_io;

