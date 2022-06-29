Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFE55F59A
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 07:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiF2FOe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 01:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiF2FOd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 01:14:33 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6E063056D
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 22:14:31 -0700 (PDT)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 160F920D6C
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 14:14:31 +0900 (JST)
Received: by mail-pg1-f200.google.com with SMTP id 15-20020a63020f000000b003fca9ebc5cbso7720000pgc.22
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 22:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rqJ4wX0X9NVLCjRuQgHYT53uN4CofDJ3/F7AFgHbeQo=;
        b=fpnNX/J0CIV0i4G/dBRjysL+0IVX9k17DDZ+CVQcm0YOyLT3MdhegtM/3FR26DsTca
         sZwvaE8XpiQPLySKty9S/YCR5Pljm9ZaJwRCxicNOE4Hg/QfxC/sPATJClLmG3sskEFR
         L8TrpeLX37Ew0pdIDfHK5g46Vs/XqQaV6exoREiaLDXMw0+y9G24ieLI8iIGuhy9d+eN
         BB8ZQBiijmEdZFV9WkfLxQ9FKZl5HK8t8fjARqyRpLqX2t4WNCujw8lzVuEvl0aDizJt
         DQ4qV7Ze34Hr4f/dj1Fp5/sfxgnzijazyC74uY5PlL5YG4hr186n1jXIx//2q2c++AYh
         3KSQ==
X-Gm-Message-State: AJIora8fCt4UU4O//SoHITTMkUWIAyZabDqTDo46jX+UuRt+k1z8RE4Z
        b6hUTCGsOtczCjzPFWwIxeMd6mBAMB62xoO3zG37v2PsXUFWNDlQoAZPFtUMfCf18oC3KX0gp7W
        6Xp48/2moNI/ZgpgbZlJh
X-Received: by 2002:a17:902:b286:b0:16b:89b2:4e34 with SMTP id u6-20020a170902b28600b0016b89b24e34mr8890243plr.108.1656479670188;
        Tue, 28 Jun 2022 22:14:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v5V6xakna2d+0FmIvn3rxCZhPBVsvez6hVSwKqY/M8rUtap5hEfgha6j3yxUH8zNpF5bbx2g==
X-Received: by 2002:a17:902:b286:b0:16b:89b2:4e34 with SMTP id u6-20020a170902b28600b0016b89b24e34mr8890229plr.108.1656479669922;
        Tue, 28 Jun 2022 22:14:29 -0700 (PDT)
Received: from pc-zest.atmarktech (35.112.198.104.bc.googleusercontent.com. [104.198.112.35])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b0016a2a8cc4b4sm10332402plb.140.2022.06.28.22.14.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 22:14:29 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o6Q20-008RKR-E9;
        Wed, 29 Jun 2022 14:14:28 +0900
Date:   Wed, 29 Jun 2022 14:14:18 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <Yrvfqh0eqN0J5T6V@atmark-techno.com>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JhLc3GVtZjzlGtxc"
Content-Disposition: inline
In-Reply-To: <YrueYDXqppHZzOsy@atmark-techno.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--JhLc3GVtZjzlGtxc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Dominique MARTINET wrote on Wed, Jun 29, 2022 at 09:35:44AM +0900:
> I also agree writing a simple program like the io_uring test in the
> above commit that'd sort of do it like qemu and compare contents would
> be ideal.
> I'll have a stab at this today.

Okay, after half a day failing to reproduce I had a closer look at qemu
and... it's a qemu bug.

Well, there probably are two bugs, but one should be benign:

 - qemu short read handling was... rather disappointing.
Patch should appear here[1] eventually, but as it seems moderated?
I'm reposting it here:
-----
diff --git a/block/io_uring.c b/block/io_uring.c
index d48e472e74cb..d58aff9615ce 100644
--- a/block/io_uring.c
+++ b/block/io_uring.c
@@ -103,7 +103,7 @@ static void luring_resubmit_short_read(LuringState *s, LuringAIOCB *luringcb,
                       remaining);
 
     /* Update sqe */
-    luringcb->sqeq.off = nread;
+    luringcb->sqeq.off += nread;
     luringcb->sqeq.addr = (__u64)(uintptr_t)luringcb->resubmit_qiov.iov;
     luringcb->sqeq.len = luringcb->resubmit_qiov.niov;
 
-----
 (basically "just" a typo, but that must have never been tested!)
[1] https://lore.kernel.org/qemu-devel/20220629044957.1998430-1-dominique.martinet@atmark-techno.com


 - comments there also say short reads should never happen on newer
kernels (assuming local filesystems?) -- how true is that? If we're
doing our best kernel side to avoid short reads I guess we probably
ought to have a look at this.

It can easily be reproduced with a simple io_uring program -- see
example attached that eventually fails with the following error on
btrfs:
bad read result for io 8, offset 792227840: 266240 should be 1466368

but doesn't fail on tmpfs or without O_DIRECT.
feel free to butcher it, it's already a quickly hacked downversion of my
original test that had hash computation etc so the flow might feel a bit
weird.
Just compile with `gcc -o shortreads uring_shortreads.c -luring` and run
with file to read in argument.


Thanks!
-- 
Dominique

--JhLc3GVtZjzlGtxc
Content-Type: text/x-csrc; charset=utf-8
Content-Description: uring_shortreads.c
Content-Disposition: attachment; filename="repro-simple.c"

/* Get O_DIRECT */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <liburing.h>
#include <sys/random.h>
#include <sys/stat.h>

long pagesize;
size_t n_blocks;
#define QUEUE_SIZE 10
char *buffers[QUEUE_SIZE];
int bufsize[QUEUE_SIZE];
struct iovec iovec[QUEUE_SIZE];
long int offsets[QUEUE_SIZE];

void breakme(void) {
}

int submit_read(struct io_uring *ring, int fd, int i) {
	struct io_uring_sqe *sqe;
	int ret;

	sqe = io_uring_get_sqe(ring);
	if (!sqe) {
		fprintf(stderr, "Failed to get io_uring sqe\n");
		return 1;
	}
	if (i == 0 || rand() % 2 == 0 || offsets[i-1] > n_blocks - bufsize[i]) {
		offsets[i] = rand() % (n_blocks - bufsize[i] + 1);
	} else {
		offsets[i] = offsets[i - 1];
	}
	io_uring_prep_readv(sqe, fd, iovec + i, 1, offsets[i] * pagesize);
	io_uring_sqe_set_data(sqe, (void*)(uintptr_t)i);
	ret = io_uring_submit(ring);
	if (ret != 1) {
		fprintf(stderr,	"submit failed\n");
		return 1;
	}
	return 0;
}

int getsize(int fd) {
	struct stat sb;
	if (fstat(fd, &sb)) {
		fprintf(stderr, "fstat: %m\n");
		return 1;
	}
	n_blocks = sb.st_size / pagesize;
	return 0;
}

int main(int argc, char *argv[])
{
	char *file, *mapfile;
	unsigned int seed;
	struct io_uring ring;
	struct io_uring_cqe *cqe;
	int fd, i;
	ssize_t ret;
	size_t total = 0;

	if (argc < 2 || argc > 3) {
		fprintf(stderr, "Use: %s <file> [<seed>]\n", argv[0]);
		return 1;
	}
	file = argv[1];
	if (argc == 3) {
		seed = atol(argv[2]);
	} else {
		getrandom(&seed, sizeof(seed), 0);
	}
	printf("random seed %u\n", seed);
	srand(seed);
	pagesize = sysconf(_SC_PAGE_SIZE);
	if (asprintf(&mapfile, "%s.map", file) < 0) {
		fprintf(stderr, "asprintf map %d\n", errno);
		return 1;
	}

	fd = open(file, O_RDONLY | O_DIRECT);
	if (fd == -1) {
		fprintf(stderr,
				"Failed to open file '%s': %s (errno %d)\n",
				file, strerror(errno), errno);
		return 1;
	}
	if (getsize(fd))
		return 1;

	for (i = 0 ; i < QUEUE_SIZE; i++) {
		bufsize[i] = (rand() % 1024) + 1;
		ret = posix_memalign((void**)&buffers[i], pagesize, bufsize[i] * pagesize);
		if (ret) {
			fprintf(stderr, "Failed to allocate read buffer\n");
			return 1;
		}
	}


	printf("Starting io_uring reads...\n");


	ret = io_uring_queue_init(QUEUE_SIZE, &ring, 0);
	if (ret != 0) {
		fprintf(stderr, "Failed to create io_uring queue\n");
		return 1;
	}


	for (i = 0 ; i < QUEUE_SIZE; i++) {
		iovec[i].iov_base = buffers[i];
		iovec[i].iov_len = bufsize[i] * pagesize;
		if (submit_read(&ring, fd, i))
			return 1;
	}

	while (total++ < 10000000) {
		if (total % 1000 == 0)
			printf("%zd\n", total);
		ret = io_uring_wait_cqe(&ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "Failed at io_uring_wait_cqe()\n");
			return 1;
		}
		i = (intptr_t)io_uring_cqe_get_data(cqe);
		if (cqe->res < 0) {
			fprintf(stderr, "bad read result for io %d, offset %zd: %d\n",
				i, offsets[i] * pagesize, cqe->res);
			breakme();
			return 1;
		}
		if (cqe->res != bufsize[i] * pagesize) {
			fprintf(stderr, "bad read result for io %d, offset %zd: %d should be %zd\n",
				i, offsets[i] * pagesize, cqe->res, bufsize[i] * pagesize);
			breakme();
			return 1;
		}
		io_uring_cqe_seen(&ring, cqe);

		// resubmit
		if (submit_read(&ring, fd, i))
			return 1;
	}
	io_uring_queue_exit(&ring);

	return 0;
}

--JhLc3GVtZjzlGtxc--
