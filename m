Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3587040CFB8
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 00:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhIOWo1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 18:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhIOWny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 18:43:54 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080E5C061764
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 15:42:35 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n128so5584097iod.5
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 15:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KEeGSA5MIkI1QwSWs+jO+mWKPSenOcunGF6JAGxHPQo=;
        b=VY0+ZTyRHjUjkMTUIO/eCc3CNuETDPL+wAIHGXscNnJmJRFhFcJENb/GhVnu5fP8j2
         jFkq20ceaG6jvbyXm+wEIiSSB0znrgs7bQK9Qxs3igGNlmBvIg3CZct5w678bvoQfsDa
         O1XkLmUvpzwB9iZHQbaBur3j03lIPUheni5iBcv6RePCxPrme9ToKDdNtS2p+UmVgDfb
         1RUvpRr/BL+B29YmiohQ11GDtMiHhdTAg8UosrbpHs9ll3ea9eQFbS1WOFMsh79yN3p6
         sFqcvgYS1IbWK8r0TEtr0xwdFXYb/m9CrMtCdXc21t7ycDin8RMAAd2SSthEy8sK3RPH
         cNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KEeGSA5MIkI1QwSWs+jO+mWKPSenOcunGF6JAGxHPQo=;
        b=NBr3CoegMf0ij+jvSMNT5Cjb69hOmPi2EbydX/1v+rQ9Cmr41FDtyOhNrQxl899i8a
         h5FcjiHJhCJP4db6OmQf2iVb+0JtpNPN7W0ff9EbhimA7K/4YfviMq8M5A3obYRQXAph
         fN4SJ3Iv50ZypthqFwfXeDcy+z8XBU8sf1SpISAmXQFmdgoXIQg8b+IEaOjPQ/9mukPa
         zChMjFhAk21VoN1+GbKQ5LMvgweBUL/5A8qRIap2gXpctfndxk0Sd/usY1V7y0OYD/Yw
         O/89IYxQmC41/yELkWMCjacV6tK/WvaqxkmnPyaNgEX8EziF5ioyjzxLR/Y+4NjO31Cn
         Fb7g==
X-Gm-Message-State: AOAM531j5sfF/HJibDM6wuf8i6cut/hvzUoYASQ5vXYocRhFq/hG9pVP
        WwZ4w7gQE7u0MQB4lc4zvjrYVw==
X-Google-Smtp-Source: ABdhPJwZeCbX1LRei6RrwXz2sfgKHhNe4SBTJ9unq6FaRhJ90crOnZuJOzChFYb4Q9496muL7mBmlA==
X-Received: by 2002:a02:90d0:: with SMTP id c16mr1987075jag.106.1631745754175;
        Wed, 15 Sep 2021 15:42:34 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f5sm715796ils.3.2021.09.15.15.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 15:42:33 -0700 (PDT)
Subject: Re: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210915162937.777002-1-axboe@kernel.dk>
 <CAHk-=wgtROzcks4cozeEYG33UU1Q3T4RM-k3kv-GqrdLKFMoLw@mail.gmail.com>
 <8c7c8aa0-9591-a50f-35ee-de0037df858a@kernel.dk>
 <CAHk-=wj3dsQMK4y-EeMD1Zyod7=Sv68UqrND-GYgHXx6wNRawA@mail.gmail.com>
 <6688d40c-b359-364b-cdff-1e0714eb6945@kernel.dk>
Message-ID: <f6349daf-2180-241d-54aa-adbfd955c5fa@kernel.dk>
Date:   Wed, 15 Sep 2021 16:42:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6688d40c-b359-364b-cdff-1e0714eb6945@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 1:40 PM, Jens Axboe wrote:
> On 9/15/21 1:26 PM, Linus Torvalds wrote:
>> On Wed, Sep 15, 2021 at 11:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>    The usual tests
>>> do end up hitting the -EAGAIN path quite easily for certain device
>>> types, but not the short read/write.
>>
>> No way to do something like "read in file to make sure it's cached,
>> then invalidate caches from position X with POSIX_FADV_DONTNEED, then
>> do a read that crosses that cached/uncached boundary"?
>>
>> To at least verify that "partly synchronous, but partly punted to
>> async" case?
>>
>> Or were you talking about some other situation?
> 
> No that covers some of it, and that happens naturally with buffered IO.
> The typical case is -EAGAIN on the first try, then you get a partial
> or all of it the next loop, and then done or continue. I tend to run
> fio verification workloads for that, as you get all the flexibility
> of fio with the data verification. And there are tests in there that run
> DONTNEED in parallel with buffered IO, exactly to catch some of these
> csaes. But they don't verify the data, generally.
> 
> In that sense buffered is a lot easier than O_DIRECT, as it's easier to
> provoke these cases. And that does hit all the save/restore parts and
> looping, and if you do it with registered buffers then you get to work
> with bvec iter as well. O_DIRECT may get you -EAGAIN for low queue depth
> devices, but it'll never do a short read/write after that. 
> 
> But that's not in the regressions tests. I'll write a test case
> that can go with the liburing regressions for it.

OK I wrote one, quick'n dirty. It's written as a liburing test, which
means it can take no arguments (in which case it creates a 128MB file),
or it can take an argument and it'll use that argument as the file. We
fill the first 128MB of the file with known data, basically the offset
of the file. Then we read it back in any of the following ways:

1) Using non-vectored read
2) Using vectored read, segments that fit in UIO_FASTIOV
3) Using vectored read, segments larger than UIO_FASTIOV

This catches all the different cases for a read.

We do that with both buffered and O_DIRECT, and before each pass, we
randomly DONTNEED either the first, middle, or end part of each segment
in the read size.

I ran this on my laptop, and I found this:
axboe@p1 ~/gi/liburing (master)> test/file-verify                                0.100s
bad read 229376, read 3
Buffered novec test failed
axboe@p1 ~/gi/liburing (master)> test/file-verify                                0.213s
bad read 294912, read 0
Buffered novec test failed

which is because I'm running the iov_iter.2 stuff, and we're hitting
that double accounting issue that I mentioned in the cover letter for
this series. That's why the read return is larger than we ask for
(128K). Running it on the current branch passes:

[root@archlinux liburing]# for i in $(seq 10); do test/file-verify; done
[root@archlinux liburing]# 

(this is in my test vm that I run on the laptop for kernel testing,
hence the root and different hostname).

I will add this as a liburing regression test case. Probably needs a bit
of cleaning up first, it was just a quick prototype as I thought your
suggestion was a good one. Will probably change it to run at a higher
queue depth than just the 1 it does now.


/* SPDX-License-Identifier: MIT */
/*
 * Description: run various read verify tests
 *
 */
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>

#include "helpers.h"
#include "liburing.h"

#define FSIZE		128*1024*1024
#define CHUNK_SIZE	131072
#define PUNCH_SIZE	32768

static int verify_buf(void *buf, size_t size, off_t off)
{
	int i, u_in_buf = size / sizeof(unsigned int);
	unsigned int *ptr;

	off /= sizeof(unsigned int);
	ptr = buf;
	for (i = 0; i < u_in_buf; i++) {
		if (off != *ptr) {
			fprintf(stderr, "Found %u, wanted %lu\n", *ptr, off);
			return 1;
		}
		ptr++;
		off++;
	}

	return 0;
}

enum {
	PUNCH_NONE,
	PUNCH_FRONT,
	PUNCH_MIDDLE,
	PUNCH_END,
};

/*
 * For each chunk in file, DONTNEED a start, end, or middle segment of it.
 * We enter here with the file fully cached every time, either freshly
 * written or after other reads.
 */
static int do_punch(int fd)
{
	off_t offset = 0;
	int punch_type;

	while (offset + CHUNK_SIZE <= FSIZE) {
		off_t punch_off;

		punch_type = rand() % (PUNCH_END + 1);
		switch (punch_type) {
		default:
		case PUNCH_NONE:
			punch_off = -1; /* gcc... */
			break;
		case PUNCH_FRONT:
			punch_off = offset;
			break;
		case PUNCH_MIDDLE:
			punch_off = offset + PUNCH_SIZE;
			break;
		case PUNCH_END:
			punch_off = offset + CHUNK_SIZE - PUNCH_SIZE;
			break;
		}

		offset += CHUNK_SIZE;
		if (punch_type == PUNCH_NONE)
			continue;
		if (posix_fadvise(fd, punch_off, PUNCH_SIZE, POSIX_FADV_DONTNEED) < 0) {
			perror("posix_fadivse");
			return 1;
		}
	}

	return 0;
}

static int test(struct io_uring *ring, const char *fname, int buffered,
		int vectored, int small_vecs)
{
	struct io_uring_cqe *cqe;
	struct io_uring_sqe *sqe;
	struct iovec *vecs;
	int ret, fd, flags;
	void *buf;
	size_t left;
	off_t off, voff;
	int i, nr_vecs;

	flags = O_RDONLY;
	if (!buffered)
		flags |= O_DIRECT;
	fd = open(fname, flags);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (do_punch(fd))
		return 1;

	if (vectored) {
		int vec_size;

		if (small_vecs)
			nr_vecs = 8;
		else
			nr_vecs = 16;
		vecs = t_malloc(nr_vecs * sizeof(struct iovec));
		vec_size = CHUNK_SIZE / nr_vecs;
		for (i = 0; i < nr_vecs; i++) {
			t_posix_memalign(&buf, 4096, vec_size);
			vecs[i].iov_base = buf;
			vecs[i].iov_len = vec_size;
		}
	} else {
		t_posix_memalign(&buf, 4096, CHUNK_SIZE);
		nr_vecs = 0;
		vecs = NULL;
	}

	i = 0;
	left = FSIZE;
	off = 0;
	while (left) {
		size_t this = left;

		if (this > CHUNK_SIZE)
			this = CHUNK_SIZE;

		sqe = io_uring_get_sqe(ring);
		if (!sqe) {
			fprintf(stderr, "get sqe failed\n");
			goto err;
		}

		if (vectored)
			io_uring_prep_readv(sqe, fd, vecs, nr_vecs, off);
		else
			io_uring_prep_read(sqe, fd, buf, this, off);
		sqe->user_data = off;
		off += this;

		ret = io_uring_submit(ring);
		if (ret <= 0) {
			fprintf(stderr, "sqe submit failed: %d\n", ret);
			goto err;
		}

		ret = io_uring_wait_cqe(ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "wait completion %d\n", ret);
			goto err;
		}
		if (cqe->res != this) {
			fprintf(stderr, "bad read %d, read %d\n", cqe->res, i);
			goto err;
		}
		if (vectored) {
			voff = cqe->user_data;
			for (i = 0; i < nr_vecs; i++) {
				if (verify_buf(vecs[i].iov_base, vecs[i].iov_len,
						voff)) {
					fprintf(stderr, "failed at off %lu\n", (unsigned long) voff);
					goto err;
				}
				voff += vecs[i].iov_len;
			}
		} else {
			if (verify_buf(buf, CHUNK_SIZE, cqe->user_data)) {
				fprintf(stderr, "failed at off %lu\n", (unsigned long) cqe->user_data);
				goto err;
			}
		}
		io_uring_cqe_seen(ring, cqe);
		i++;
		left -= CHUNK_SIZE;
	}

	ret = 0;
done:
	if (vectored) {
		for (i = 0; i < nr_vecs; i++)
			free(vecs[i].iov_base);
	} else {
		free(buf);
	}
	close(fd);
	return ret;
err:
	ret = 1;
	goto done;
}

static int fill_pattern(const char *fname)
{
	size_t left = FSIZE;
	unsigned int val, *ptr;
	void *buf;
	int fd, i;

	fd = open(fname, O_WRONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	val = 0;
	buf = t_malloc(4096);
	while (left) {
		int u_in_buf = 4096 / sizeof(val);
		size_t this = left;

		if (this > 4096)
			this = 4096;
		ptr = buf;
		for (i = 0; i < u_in_buf; i++) {
			*ptr = val;
			val++;
			ptr++;
		}
		if (write(fd, buf, 4096) != 4096)
			return 1;
		left -= 4096;
	}

	fsync(fd);
	close(fd);
	free(buf);
	return 0;
}

int main(int argc, char *argv[])
{
	struct io_uring ring;
	const char *fname;
	char buf[32];
	int ret;

	srand(getpid());

	if (argc > 1) {
		fname = argv[1];
	} else {
		sprintf(buf, ".%d", getpid());
		fname = buf;
		t_create_file(fname, FSIZE);
	}

	ret = io_uring_queue_init(64, &ring, 0);
	if (ret) {
		fprintf(stderr, "ring setup failed: %d\n", ret);
		goto err;
	}

	if (fill_pattern(fname))
		goto err;

	ret = test(&ring, fname, 1, 0, 0);
	if (ret) {
		fprintf(stderr, "Buffered novec test failed\n");
		goto err;
	}
	ret = test(&ring, fname, 1, 1, 0);
	if (ret) {
		fprintf(stderr, "Buffered vec test failed\n");
		goto err;
	}
	ret = test(&ring, fname, 1, 1, 1);
	if (ret) {
		fprintf(stderr, "Buffered small vec test failed\n");
		goto err;
	}

	ret = test(&ring, fname, 0, 0, 0);
	if (ret) {
		fprintf(stderr, "O_DIRECt novec test failed\n");
		goto err;
	}
	ret = test(&ring, fname, 0, 1, 0);
	if (ret) {
		fprintf(stderr, "O_DIRECt vec test failed\n");
		goto err;
	}
	ret = test(&ring, fname, 0, 1, 1);
	if (ret) {
		fprintf(stderr, "O_DIRECt small vec test failed\n");
		goto err;
	}

	if (buf == fname)
		unlink(fname);
	return 0;
err:
	if (buf == fname)
		unlink(fname);
	return 1;
}

-- 
Jens Axboe

