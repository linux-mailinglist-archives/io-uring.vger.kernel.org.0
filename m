Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58706456272
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 19:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhKRSge (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 13:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbhKRSge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 13:36:34 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19E9C061574;
        Thu, 18 Nov 2021 10:33:33 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so8934964pju.3;
        Thu, 18 Nov 2021 10:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=adMBqCevpwBc5BDiVMJu2FOYt3bHTHPYAnEIN6Yepls=;
        b=Kqyb8TX+kWcJBURDlkI6mnQl4QTRJLw7r8dqzpMXokeJfMlDF0ZrcbTKIo0uCbDVNx
         w0LgjPHdsgqqqs0Y8IOyVPuA0UE5ufKs3UPPTR4W/mdgCj9Xh6mQTGb6m2knOHGhil9c
         lVAK8F3ofc4mjUvAfCPD1ajqdmi8jYhRzNYnEQaE+BeaRm737c8IteNDqFcRAYPU0yBu
         yvyTL5r0yCMICWBT3L6OhOZnpokQYnP2kuzhOn8tSsUVPEQdB2oRdiXnwV2e9alwuMMN
         vRC78Fg1W7AX1bkM5FGcSKrWcnNVBidHmczLiMXZcvug0dwspmZtQ9A1BzYK0lFov2C7
         GofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=adMBqCevpwBc5BDiVMJu2FOYt3bHTHPYAnEIN6Yepls=;
        b=TK7U0jD0uaIo/C36dGT9fK+FstCp2C2jCBpOLg7Y7rch1cqGirqDQcaek9gnqEELqY
         /DYh+65k0vcF5TkkGnnM1sI1aL/rO+QK+BN1NC0ilpT+/mJ3Sou4uEQYTQxEvKsSRv3+
         fi6JFxUEbkkt8a9YH+EF9L1clG0mTd72kSwUZzUkKXNXeQFhmugLAuf0F5PX/++ChUgT
         vPJIgiqM7QwDtz8naBJOpiWKQUrz2XvHrCORe3zHE0VyX60iekun5hU6Co7Q4y+1c9sU
         KQVUQqE1GBpUNhXZRwSMx/HWYgrr+Q3wIMdTxmavIFbHF5JZpK4SBB0B4/d98okU52ui
         JlSQ==
X-Gm-Message-State: AOAM531jxj8qvBUUZvJLO9owMnTiOhGRfP0rxIVbTt4OgJw0n0zPmoUu
        3wkanuHvXoenZYwUm+ZM6FObmGFFmjU=
X-Google-Smtp-Source: ABdhPJwq37IloI7eZXZ3D5cZoEFQUZZaW4rjM9pOz1VM9dj11GQRdn2jeq9uzFoef8LkgGRHWFy68Q==
X-Received: by 2002:a17:90b:4d0e:: with SMTP id mw14mr12945597pjb.43.1637260413373;
        Thu, 18 Nov 2021 10:33:33 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id f130sm327689pfa.81.2021.11.18.10.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:33:33 -0800 (PST)
Date:   Fri, 19 Nov 2021 00:03:30 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 5/8] selftests/bpf: Add test for io_uring BPF
 iterators
Message-ID: <20211118183330.c2wnjgciv34mitlv@apollo.localdomain>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-6-memxor@gmail.com>
 <92be1024-971f-0ae3-11b7-2988f3b37100@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92be1024-971f-0ae3-11b7-2988f3b37100@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 18, 2021 at 11:24:19PM IST, Yonghong Song wrote:
>
>
> On 11/15/21 9:42 PM, Kumar Kartikeya Dwivedi wrote:
> > This exercises the io_uring_buf and io_uring_file iterators, and tests
> > sparse file sets as well.
> >
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: io-uring@vger.kernel.org
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >   .../selftests/bpf/prog_tests/bpf_iter.c       | 226 ++++++++++++++++++
> >   .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++++
> >   2 files changed, 276 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > index 3e10abce3e5a..baf11fe2f88d 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> > @@ -1,6 +1,9 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   /* Copyright (c) 2020 Facebook */
> > +#include <sys/mman.h>
> >   #include <test_progs.h>
> > +#include <linux/io_uring.h>
> > +
> >   #include "bpf_iter_ipv6_route.skel.h"
> >   #include "bpf_iter_netlink.skel.h"
> >   #include "bpf_iter_bpf_map.skel.h"
> > @@ -26,6 +29,7 @@
> >   #include "bpf_iter_bpf_sk_storage_map.skel.h"
> >   #include "bpf_iter_test_kern5.skel.h"
> >   #include "bpf_iter_test_kern6.skel.h"
> > +#include "bpf_iter_io_uring.skel.h"
> >   static int duration;
> > @@ -1239,6 +1243,224 @@ static void test_task_vma(void)
> >   	bpf_iter_task_vma__destroy(skel);
> >   }
> > +static int sys_io_uring_setup(u32 entries, struct io_uring_params *p)
> > +{
> > +	return syscall(__NR_io_uring_setup, entries, p);
> > +}
> > +
> > +static int io_uring_register_bufs(int io_uring_fd, struct iovec *iovs, unsigned int nr)
> > +{
> > +	return syscall(__NR_io_uring_register, io_uring_fd,
> > +		       IORING_REGISTER_BUFFERS, iovs, nr);
> > +}
> > +
> > +static int io_uring_register_files(int io_uring_fd, int *fds, unsigned int nr)
> > +{
> > +	return syscall(__NR_io_uring_register, io_uring_fd,
> > +		       IORING_REGISTER_FILES, fds, nr);
> > +}
> > +
> > +static unsigned long long page_addr_to_pfn(unsigned long addr)
> > +{
> > +	int page_size = sysconf(_SC_PAGE_SIZE), fd, ret;
> > +	unsigned long long pfn;
> > +
> > +	if (page_size < 0)
> > +		return 0;
> > +	fd = open("/proc/self/pagemap", O_RDONLY);
> > +	if (fd < 0)
> > +		return 0;
> > +
> > +	ret = pread(fd, &pfn, sizeof(pfn), (addr / page_size) * 8);
> > +	close(fd);
> > +	if (ret < 0)
> > +		return 0;
> > +	/* Bits 0-54 have PFN for non-swapped page */
> > +	return pfn & 0x7fffffffffffff;
> > +}
> > +
> > +void test_io_uring_buf(void)
> > +{
> > +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> > +	char rbuf[4096], buf[4096] = "B\n";
> > +	union bpf_iter_link_info linfo;
> > +	struct bpf_iter_io_uring *skel;
> > +	int ret, fd, i, len = 128;
> > +	struct io_uring_params p;
> > +	struct iovec iovs[8];
> > +	int iter_fd;
> > +	char *str;
> > +
> > +	opts.link_info = &linfo;
> > +	opts.link_info_len = sizeof(linfo);
> > +
> > +	skel = bpf_iter_io_uring__open_and_load();
> > +	if (!ASSERT_OK_PTR(skel, "bpf_iter_io_uring__open_and_load"))
> > +		return;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(iovs); i++) {
> > +		iovs[i].iov_len	 = len;
> > +		iovs[i].iov_base = mmap(NULL, len, PROT_READ | PROT_WRITE,
> > +					MAP_ANONYMOUS | MAP_SHARED, -1, 0);
> > +		if (iovs[i].iov_base == MAP_FAILED)
> > +			goto end;
> > +		len *= 2;
> > +	}
> > +
> > +	memset(&p, 0, sizeof(p));
> > +	fd = sys_io_uring_setup(1, &p);
> > +	if (!ASSERT_GE(fd, 0, "io_uring_setup"))
> > +		goto end;
> > +
> > +	linfo.io_uring.io_uring_fd = fd;
> > +	skel->links.dump_io_uring_buf = bpf_program__attach_iter(skel->progs.dump_io_uring_buf,
> > +								 &opts);
> > +	if (!ASSERT_OK_PTR(skel->links.dump_io_uring_buf, "bpf_program__attach_iter"))
> > +		goto end_close_fd;
> > +
> > +	ret = io_uring_register_bufs(fd, iovs, ARRAY_SIZE(iovs));
> > +	if (!ASSERT_OK(ret, "io_uring_register_bufs"))
> > +		goto end_close_fd;
> > +
> > +	/* "B\n" */
> > +	len = 2;
> > +	str = buf + len;
> > +	for (int j = 0; j < ARRAY_SIZE(iovs); j++) {
> > +		ret = snprintf(str, sizeof(buf) - len, "%d:0x%lx:%zu\n", j,
> > +			       (unsigned long)iovs[j].iov_base,
> > +			       iovs[j].iov_len);
> > +		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> > +			goto end_close_fd;
> > +		len += ret;
> > +		str += ret;
> > +
> > +		ret = snprintf(str, sizeof(buf) - len, "`-PFN for bvec[0]=%llu\n",
> > +			       page_addr_to_pfn((unsigned long)iovs[j].iov_base));
> > +		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> > +			goto end_close_fd;
> > +		len += ret;
> > +		str += ret;
> > +	}
> > +
> > +	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(iovs));
> > +	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> > +		goto end_close_fd;
> > +
> > +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_buf));
> > +	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
> > +		goto end_close_fd;
> > +
> > +	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
> > +	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer"))
> > +		goto end_close_iter;
> > +
> > +	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
> > +
> > +	puts("=== Expected Output ===");
> > +	printf("%s", buf);
> > +	puts("==== Actual Output ====");
> > +	printf("%s", rbuf);
> > +	puts("=======================");
>
> Maybe you can do an actual comparison and use ASSERT_* macros to check
> result?
>

I already did that in the line above first "puts". The printing is just for
better debugging, to show the incorrect output in case test fails. Also in epoll
test in the next patch the order of entries is not fixed, since they are sorted
using struct file pointer.

> > +
> > +end_close_iter:
> > +	close(iter_fd);
> > +end_close_fd:
> > +	close(fd);
> > +end:
> > +	while (i--)
> > +		munmap(iovs[i].iov_base, iovs[i].iov_len);
> > +	bpf_iter_io_uring__destroy(skel);
> > +}
> > +
> > +void test_io_uring_file(void)
> > +{
> > +	int reg_files[] = { [0 ... 7] = -1 };
> > +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> > +	char buf[4096] = "B\n", rbuf[4096] = {}, *str;
> > +	union bpf_iter_link_info linfo = {};
> > +	struct bpf_iter_io_uring *skel;
> > +	int iter_fd, fd, len = 0, ret;
> > +	struct io_uring_params p;
> > +
> > +	opts.link_info = &linfo;
> > +	opts.link_info_len = sizeof(linfo);
> > +
> > +	skel = bpf_iter_io_uring__open_and_load();
> > +	if (!ASSERT_OK_PTR(skel, "bpf_iter_io_uring__open_and_load"))
> > +		return;
> > +
> > +	/* "B\n" */
> > +	len = 2;
> > +	str = buf + len;
> > +	ret = snprintf(str, sizeof(buf) - len, "B\n");
> > +	for (int i = 0; i < ARRAY_SIZE(reg_files); i++) {
> > +		char templ[] = "/tmp/io_uringXXXXXX";
> > +		const char *name, *def = "<none>";
> > +
> > +		/* create sparse set */
> > +		if (i & 1) {
> > +			name = def;
> > +		} else {
> > +			reg_files[i] = mkstemp(templ);
> > +			if (!ASSERT_GE(reg_files[i], 0, templ))
> > +				goto end_close_reg_files;
> > +			name = templ;
> > +			ASSERT_OK(unlink(name), "unlink");
> > +		}
> > +		ret = snprintf(str, sizeof(buf) - len, "%d:%s%s\n", i, name, name != def ? " (deleted)" : "");
> > +		if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> > +			goto end_close_reg_files;
> > +		len += ret;
> > +		str += ret;
> > +	}
> > +
> > +	ret = snprintf(str, sizeof(buf) - len, "E:%zu\n", ARRAY_SIZE(reg_files));
> > +	if (!ASSERT_GE(ret, 0, "snprintf") || !ASSERT_LT(ret, sizeof(buf) - len, "snprintf"))
> > +		goto end_close_reg_files;
> > +
> > +	memset(&p, 0, sizeof(p));
> > +	fd = sys_io_uring_setup(1, &p);
> > +	if (!ASSERT_GE(fd, 0, "io_uring_setup"))
> > +		goto end_close_reg_files;
> > +
> > +	linfo.io_uring.io_uring_fd = fd;
> > +	skel->links.dump_io_uring_file = bpf_program__attach_iter(skel->progs.dump_io_uring_file,
> > +								  &opts);
> > +	if (!ASSERT_OK_PTR(skel->links.dump_io_uring_file, "bpf_program__attach_iter"))
> > +		goto end_close_fd;
> > +
> > +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_file));
> > +	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
> > +		goto end;
> > +
> > +	ret = io_uring_register_files(fd, reg_files, ARRAY_SIZE(reg_files));
> > +	if (!ASSERT_OK(ret, "io_uring_register_files"))
> > +		goto end_iter_fd;
> > +
> > +	ret = read_fd_into_buffer(iter_fd, rbuf, sizeof(rbuf));
> > +	if (!ASSERT_GT(ret, 0, "read_fd_into_buffer(iterator_fd, buf)"))
> > +		goto end_iter_fd;
> > +
> > +	ASSERT_OK(strcmp(rbuf, buf), "compare iterator output");
> > +
> > +	puts("=== Expected Output ===");
> > +	printf("%s", buf);
> > +	puts("==== Actual Output ====");
> > +	printf("%s", rbuf);
> > +	puts("=======================");
>
> The same as above.
>
> > +end_iter_fd:
> > +	close(iter_fd);
> > +end_close_fd:
> > +	close(fd);
> > +end_close_reg_files:
> > +	for (int i = 0; i < ARRAY_SIZE(reg_files); i++) {
> > +		if (reg_files[i] != -1)
> > +			close(reg_files[i]);
> > +	}
> > +end:
> > +	bpf_iter_io_uring__destroy(skel);
> > +}
> [...]

--
Kartikeya
