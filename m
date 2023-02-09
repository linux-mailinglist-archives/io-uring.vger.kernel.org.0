Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA8C690B11
	for <lists+io-uring@lfdr.de>; Thu,  9 Feb 2023 14:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjBIN4L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 08:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjBIN4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 08:56:10 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80B15BA75;
        Thu,  9 Feb 2023 05:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:From:To:Date:Message-ID;
        bh=dKtYu+JDvoYPo88QxjhqydMNl2n2n4GvLT2+LdSLEZE=; b=RSJ/HI3WV2J0cJ04J79ShIlxbS
        CSkr+mcyNOLK0gj3CsBY+ygHhIGc23/ca63ckazjFkBcuXhRxoah8M8UBQdeAmQKKZ+28b/3/+QjJ
        M89tanyKc2WD9Qj9VrF+13gBSfEf2LEFArQlvp9lqajdjBZH70XK8Nyi5rgREufnn4RcEMJ2V1b+9
        rbF630HSORVyZlLfvftWN7+QTaSRNz3Nf0jt9Zgzo5+fPYwpPZZe6JAQB+sendYRYFWqOMoD4md2r
        LesyeMZK81AfOvoo8BnwooncaFxkDqexx+nQ5eaLpzJ1b1sDBEN2mJ+imhWKQEX0rF/jjd8NrHWDG
        pVLSuF2upXe+idrWJbIFHPboVpDYmynYVTgxQiApWGow5oWA/UxiMh5g0CMHzmDGgHDYGnzWn6Ktj
        xHSykF8JENccQsFA87iOB3mdE4sxshmdL9ECTdDvIL0e36k6J3EwCdxiEIUF/ZWMfG7gEs+deKEAe
        IYdtGfEWpFK/pCFg3kfYxGTl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQ7P7-00Cops-4s; Thu, 09 Feb 2023 13:56:01 +0000
Message-ID: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
Date:   Thu, 9 Feb 2023 14:55:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
From:   Stefan Metzmacher <metze@samba.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: copy on write for splice() from file to pipe?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus and others,

as written in a private mail before, I'm currently trying to
make use of IORING_OP_SPLICE in order to get zero copy support
in Samba.

The most important use cases are 8 Mbytes reads and writes to
files. where "memcpy" (at the lowest end copy_user_enhanced_fast_string())
is the obvious performance killer.

I have a prototype that offers really great performance
avoiding "memcpy" by using splice() (in order to get async IORING_OP_SPLICE).

So we have two cases:

1. network -> socket -> splice -> pipe -> splice -> file -> storage

2. storage -> file -> splice -> pipe -> splice -> socket -> network

With 1. I guess everything can work reliable, once
the pages are created/filled in the socket receive buffer
they are used exclusively and they won't be shared on
the way to the file. Which means we can be sure that
data arrives unmodified in the file(system).

But with 2. there's a problem, as the pages from the file,
which are spliced into the pipe are still shared without
copy on write with the file(system). It means writes to the file
after the first splice modify the content of the spliced pages!
So the content may change uncontrolled before it reaches the network!
I created a little example that demonstrates the problem (see below),
it gives the following output:

> open(O_TMPFILE) => ffd[3]
> pwrite(count=PIPE_BUF,ofs=PIPE_BUF) 0x1f sret[4096]
> pipe() => ret[0]
> splice(count=PIPE_BUF*2,ofs=0) sret[8192]
> pwrite(count=PIPE_BUF,ofs=0) 0xf0 sret[4096]
> pwrite(count=PIPE_BUF,ofs=PIPE_BUF) 0xf0 sret[4096]
> read(from_pipe, count=PIPE_BUF) sret[4096]
> memcmp() at ofs=0, expecting 0x00 => ret[240]
> memcmp() at ofs=0, checking for 0xf0 => ret[0]
> read(from_pipe, count=PIPE_BUF) sret[4096]
> memcmp() at ofs=PIPE_BUF, expecting 0x1f => ret[209]
> memcmp() at ofs=PIPE_BUF, checking for 0xf0 => ret[0]

After reading from the pipe we get the values we have written to
the file instead of the values we had at the time of splice.

For things like web servers, which mostly serve static content, this
isn't a problem, but it is for Samba, when reads and writes may happen within
microseconds, before the content is pushed to the network.

I'm wondering if there's a possible way out of this, maybe triggered by a new
flag passed to splice.

I looked through the code and noticed the existence of IOMAP_F_SHARED.
Maybe the splice from the page cache to the pipe could set IOMAP_F_SHARED,
while incrementing the refcount and the network driver could remove it again
when the refcount reaches 1 again.

Is there any other way we could archive something like this?

In addition and/or as alternative I was thinking about a flag to
preadv2() (and IORING_OP_READV) to indicate the use of something
like async_memcpy(), instead of doing the copy via the cpu.
That in combination with IORING_OP_SENDMSG_ZC would avoid "memcpy"
on the cpu.

Any hints, remarks and prototype patches are highly welcome.

Thanks!
metze

#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <limits.h>

int main(void)
{
	int ffd;
	int pfds[2];
	char buf [PIPE_BUF] = {0, };
	char buf2 [PIPE_BUF] = {0, };
	ssize_t sret;
	int ret;
	off_t ofs;

	memset(buf, 0x1f, PIPE_BUF);

	ffd = open("/tmp/", O_RDWR | O_TMPFILE, S_IRUSR | S_IWUSR);
	printf("open(O_TMPFILE) => ffd[%d]\n", ffd);

	sret = pwrite(ffd, buf, PIPE_BUF, PIPE_BUF);
	printf("pwrite(count=PIPE_BUF,ofs=PIPE_BUF) 0x1f sret[%zd]\n", sret);

	ret = pipe(pfds);
	printf("pipe() => ret[%d]\n", ret);

	ofs = 0;
	sret = splice(ffd, &ofs, pfds[1], NULL, PIPE_BUF*2, 0);
	printf("splice(count=PIPE_BUF*2,ofs=0) sret[%zd]\n", sret);

	memset(buf, 0xf0, PIPE_BUF);

	sret = pwrite(ffd, buf, PIPE_BUF, 0);
	printf("pwrite(count=PIPE_BUF,ofs=0) 0xf0 sret[%zd]\n", sret);
	sret = pwrite(ffd, buf, PIPE_BUF, PIPE_BUF);
	printf("pwrite(count=PIPE_BUF,ofs=PIPE_BUF) 0xf0 sret[%zd]\n", sret);

	sret = read(pfds[0], buf, PIPE_BUF);
	printf("read(from_pipe, count=PIPE_BUF) sret[%zd]\n", sret);

	memset(buf2, 0x00, PIPE_BUF);
	ret = memcmp(buf, buf2, PIPE_BUF);
	printf("memcmp() at ofs=0, expecting 0x00 => ret[%d]\n", ret);
	memset(buf2, 0xf0, PIPE_BUF);
	ret = memcmp(buf, buf2, PIPE_BUF);
	printf("memcmp() at ofs=0, checking for 0xf0 => ret[%d]\n", ret);

	sret = read(pfds[0], buf, PIPE_BUF);
	printf("read(from_pipe, count=PIPE_BUF) sret[%zd]\n", sret);

	memset(buf2, 0x1f, PIPE_BUF);
	ret = memcmp(buf, buf2, PIPE_BUF);
	printf("memcmp() at ofs=PIPE_BUF, expecting 0x1f => ret[%d]\n", ret);
	memset(buf2, 0xf0, PIPE_BUF);
	ret = memcmp(buf, buf2, PIPE_BUF);
	printf("memcmp() at ofs=PIPE_BUF, checking for 0xf0 => ret[%d]\n", ret);
	return 0;
}
