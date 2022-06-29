Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957155604C2
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiF2PhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 11:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiF2PhQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 11:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D614369FF;
        Wed, 29 Jun 2022 08:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AD9CB821C5;
        Wed, 29 Jun 2022 15:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97F7C34114;
        Wed, 29 Jun 2022 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656517033;
        bh=zrM9hvGXNUHb6De0C1dbsf6P5ZqnvXnbcjjRTxZFJPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h9VUCR3XwunEtLmYD+sWzPPXxFdgeCnzU4sTHPRzi3mOK7nhYSgFFpskmqpg04uN/
         dCyWKAoxUn/BrtZlkmkP4E8E+aX90FkRrV6gW0QvAmlzkEcFiiSBvG0zLJ4iAMR3Pd
         vcMsNKj+aYz/AfQZhfGPRr6K4qZB4ODNmc7JY42BlY3BaNmHmhl7TVo7/B/yhX6/9E
         +lOeNRBSVOuOTIxg5LaPLxV3YoiM6S+1pGERMLY/rNuK+dlReJ7OGCzOQFbDFxBayy
         cSDwv0jYorMivhKMZBPYgFDUW0empOyk2AB1nM9yEQHvdk3+lG9hLUB7pv+jqQidwv
         TZ0UjqIJMgpsg==
Date:   Wed, 29 Jun 2022 16:37:10 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <20220629153710.GA379981@falcondesktop>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrvfqh0eqN0J5T6V@atmark-techno.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 29, 2022 at 02:14:18PM +0900, Dominique MARTINET wrote:
> Dominique MARTINET wrote on Wed, Jun 29, 2022 at 09:35:44AM +0900:
> > I also agree writing a simple program like the io_uring test in the
> > above commit that'd sort of do it like qemu and compare contents would
> > be ideal.
> > I'll have a stab at this today.
> 
> Okay, after half a day failing to reproduce I had a closer look at qemu
> and... it's a qemu bug.
> 
> Well, there probably are two bugs, but one should be benign:
> 
>  - qemu short read handling was... rather disappointing.
> Patch should appear here[1] eventually, but as it seems moderated?
> I'm reposting it here:
> -----
> diff --git a/block/io_uring.c b/block/io_uring.c
> index d48e472e74cb..d58aff9615ce 100644
> --- a/block/io_uring.c
> +++ b/block/io_uring.c
> @@ -103,7 +103,7 @@ static void luring_resubmit_short_read(LuringState *s, LuringAIOCB *luringcb,
>                        remaining);
>  
>      /* Update sqe */
> -    luringcb->sqeq.off = nread;
> +    luringcb->sqeq.off += nread;
>      luringcb->sqeq.addr = (__u64)(uintptr_t)luringcb->resubmit_qiov.iov;
>      luringcb->sqeq.len = luringcb->resubmit_qiov.niov;
>  
> -----
>  (basically "just" a typo, but that must have never been tested!)
> [1] https://lore.kernel.org/qemu-devel/20220629044957.1998430-1-dominique.martinet@atmark-techno.com

Btw, the link doesn't work (at least at the moment):

"Message-ID <20220629044957.1998430-1-dominique.martinet@atmark-techno.com> not found"
> 
> 
>  - comments there also say short reads should never happen on newer
> kernels (assuming local filesystems?) -- how true is that? If we're
> doing our best kernel side to avoid short reads I guess we probably
> ought to have a look at this.

Short reads can happen, and an application should deal with it.
If we look at the man page for read(2):

"
       On success, the number of bytes read is returned (zero indicates
       end of file), and the file position is advanced by this number.
       It is not an error if this number is smaller than the number of
       bytes requested; this may happen for example because fewer bytes
       are actually available right now (maybe because we were close to
       end-of-file, or because we are reading from a pipe, or from a
       terminal), or because read() was interrupted by a signal.  See
       also NOTES.
"

pread(2) refers to read(2)'s documention about short reads as well.
I don't think reading with io_uring is an exception, I'm not aware of
any rules that forbided short reads from happening (even if the offset
and length don't cross the EOF boundary).

As mentioned in the commit pointed before, we recently had a similar
report with MariaDB, which wasn't dealing with short reads properly
and got fixed shortly after:

https://jira.mariadb.org/browse/MDEV-27900?focusedCommentId=216582&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-216582

In fact not dealing with short reads at all, is not that uncommon
in applications. In that particular case we could avoid doing the
short read in btrfs, by returning -EAGAIN and making io_uring use
a blocking context to do a blocking direct IO read.
> 
> It can easily be reproduced with a simple io_uring program -- see
> example attached that eventually fails with the following error on
> btrfs:
> bad read result for io 8, offset 792227840: 266240 should be 1466368
> 
> but doesn't fail on tmpfs or without O_DIRECT.
> feel free to butcher it, it's already a quickly hacked downversion of my
> original test that had hash computation etc so the flow might feel a bit
> weird.
> Just compile with `gcc -o shortreads uring_shortreads.c -luring` and run
> with file to read in argument.

I just tried your program, against the qemu/vmdk image you mentioned in the
first message, and after over an hour running I couldn't trigger any short
reads - this was on the integration misc-next branch.

It's possible that to trigger the issue, one needs a particular file extent
layout, which will not be the same as yours after downloading and converting
the file.

Are you able to apply kernel patches and test? If so I may provide you with
a patch to try and see if it fixes the problem for you.

Thanks.


> 
> 
> Thanks!
> -- 
> Dominique

> /* Get O_DIRECT */
> #ifndef _GNU_SOURCE
> #define _GNU_SOURCE
> #endif
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <string.h>
> #include <liburing.h>
> #include <sys/random.h>
> #include <sys/stat.h>
> 
> long pagesize;
> size_t n_blocks;
> #define QUEUE_SIZE 10
> char *buffers[QUEUE_SIZE];
> int bufsize[QUEUE_SIZE];
> struct iovec iovec[QUEUE_SIZE];
> long int offsets[QUEUE_SIZE];
> 
> void breakme(void) {
> }
> 
> int submit_read(struct io_uring *ring, int fd, int i) {
> 	struct io_uring_sqe *sqe;
> 	int ret;
> 
> 	sqe = io_uring_get_sqe(ring);
> 	if (!sqe) {
> 		fprintf(stderr, "Failed to get io_uring sqe\n");
> 		return 1;
> 	}
> 	if (i == 0 || rand() % 2 == 0 || offsets[i-1] > n_blocks - bufsize[i]) {
> 		offsets[i] = rand() % (n_blocks - bufsize[i] + 1);
> 	} else {
> 		offsets[i] = offsets[i - 1];
> 	}
> 	io_uring_prep_readv(sqe, fd, iovec + i, 1, offsets[i] * pagesize);
> 	io_uring_sqe_set_data(sqe, (void*)(uintptr_t)i);
> 	ret = io_uring_submit(ring);
> 	if (ret != 1) {
> 		fprintf(stderr,	"submit failed\n");
> 		return 1;
> 	}
> 	return 0;
> }
> 
> int getsize(int fd) {
> 	struct stat sb;
> 	if (fstat(fd, &sb)) {
> 		fprintf(stderr, "fstat: %m\n");
> 		return 1;
> 	}
> 	n_blocks = sb.st_size / pagesize;
> 	return 0;
> }
> 
> int main(int argc, char *argv[])
> {
> 	char *file, *mapfile;
> 	unsigned int seed;
> 	struct io_uring ring;
> 	struct io_uring_cqe *cqe;
> 	int fd, i;
> 	ssize_t ret;
> 	size_t total = 0;
> 
> 	if (argc < 2 || argc > 3) {
> 		fprintf(stderr, "Use: %s <file> [<seed>]\n", argv[0]);
> 		return 1;
> 	}
> 	file = argv[1];
> 	if (argc == 3) {
> 		seed = atol(argv[2]);
> 	} else {
> 		getrandom(&seed, sizeof(seed), 0);
> 	}
> 	printf("random seed %u\n", seed);
> 	srand(seed);
> 	pagesize = sysconf(_SC_PAGE_SIZE);
> 	if (asprintf(&mapfile, "%s.map", file) < 0) {
> 		fprintf(stderr, "asprintf map %d\n", errno);
> 		return 1;
> 	}
> 
> 	fd = open(file, O_RDONLY | O_DIRECT);
> 	if (fd == -1) {
> 		fprintf(stderr,
> 				"Failed to open file '%s': %s (errno %d)\n",
> 				file, strerror(errno), errno);
> 		return 1;
> 	}
> 	if (getsize(fd))
> 		return 1;
> 
> 	for (i = 0 ; i < QUEUE_SIZE; i++) {
> 		bufsize[i] = (rand() % 1024) + 1;
> 		ret = posix_memalign((void**)&buffers[i], pagesize, bufsize[i] * pagesize);
> 		if (ret) {
> 			fprintf(stderr, "Failed to allocate read buffer\n");
> 			return 1;
> 		}
> 	}
> 
> 
> 	printf("Starting io_uring reads...\n");
> 
> 
> 	ret = io_uring_queue_init(QUEUE_SIZE, &ring, 0);
> 	if (ret != 0) {
> 		fprintf(stderr, "Failed to create io_uring queue\n");
> 		return 1;
> 	}
> 
> 
> 	for (i = 0 ; i < QUEUE_SIZE; i++) {
> 		iovec[i].iov_base = buffers[i];
> 		iovec[i].iov_len = bufsize[i] * pagesize;
> 		if (submit_read(&ring, fd, i))
> 			return 1;
> 	}
> 
> 	while (total++ < 10000000) {
> 		if (total % 1000 == 0)
> 			printf("%zd\n", total);
> 		ret = io_uring_wait_cqe(&ring, &cqe);
> 		if (ret < 0) {
> 			fprintf(stderr, "Failed at io_uring_wait_cqe()\n");
> 			return 1;
> 		}
> 		i = (intptr_t)io_uring_cqe_get_data(cqe);
> 		if (cqe->res < 0) {
> 			fprintf(stderr, "bad read result for io %d, offset %zd: %d\n",
> 				i, offsets[i] * pagesize, cqe->res);
> 			breakme();
> 			return 1;
> 		}
> 		if (cqe->res != bufsize[i] * pagesize) {
> 			fprintf(stderr, "bad read result for io %d, offset %zd: %d should be %zd\n",
> 				i, offsets[i] * pagesize, cqe->res, bufsize[i] * pagesize);
> 			breakme();
> 			return 1;
> 		}
> 		io_uring_cqe_seen(&ring, cqe);
> 
> 		// resubmit
> 		if (submit_read(&ring, fd, i))
> 			return 1;
> 	}
> 	io_uring_queue_exit(&ring);
> 
> 	return 0;
> }

