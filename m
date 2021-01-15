Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743412F80EF
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 17:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbhAOQh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 11:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOQh6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 11:37:58 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B33FC061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 08:37:18 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id b64so12196787qkc.12
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 08:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B4EYjNvjE1g4jbkWbjZPom+yl9co2kCo95Jph3/kL6w=;
        b=McILCLcBGeEf/ZH6GqaxgJphmEHRSX86o1XDAxX6cK5XfM0MPVEnSM8p30gp69K2NF
         lBEkSHu9Yh9GH8K/CzD7uLjt8CbsetYP+tQgiKdFvmVeTfWmdftkGznyaZ908AZ+7yPs
         ycR/YrrN7MUIZeHNKAiaIu/1eGOkXf0x0hePvKkcAadcoHw+YMHh9Xx0RIpOUoQlkOs2
         /9BpBmZLVnrRCq7wz9AUsL6HwKFnVEFwxGhNWTckA++Gc5Bm5NtRYw7NX7Gie3TqX26S
         hzAdK/MMiVpeHCQnckxLTHSO+l8t14kI0yi3kvZLmmmN3xwkKI9F3yBeKUHehQz1YQ/o
         3srQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B4EYjNvjE1g4jbkWbjZPom+yl9co2kCo95Jph3/kL6w=;
        b=Ri9GMgLC8aRe4MzbvBSPlNl+q/jSoBTDMbi+xcJYId1XFLcsosu8To1OaJiQYtR07H
         F3QSKeueg0gRIQtnt2RCVhf7M2BH1cW66/5hwF0dCCStCWlxSWa0GJLszZGODt5R/5Im
         ZBuLZNwSSUJNt5AMLcanVh00wSi4o8VsgO0xL3mOq/iE+kMYCcsD2bYv16OUEKeH7w9M
         Eb/folWyYdmoV8iAdDu0VPjzh0aPIjDRlrRzstXqg7maNr0zADs42vaFjwxews870yfp
         c3U0GyBw31xWXT3khYFQ3rEj7Tq6Qxhj9GauEEcEXDLgOIfc1vgxCbqcK6mi77zwaSSi
         9u1w==
X-Gm-Message-State: AOAM533atGrBJVQJ1CH4vlJy/SvB1ZycowPBgBsdmCE9uIbtLCs8OTpp
        u96JG7z3XDaRnT8s8m+xOi4=
X-Google-Smtp-Source: ABdhPJwo0b9AjZdjHcKuE3G1dOzP1j1hC2YVWYhykoI+0SVsYrc9AQ1NNpfmkLjNk+MkfBy22VNpUg==
X-Received: by 2002:a37:a155:: with SMTP id k82mr12967702qke.290.1610728637805;
        Fri, 15 Jan 2021 08:37:17 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id h26sm5261999qtc.81.2021.01.15.08.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:37:17 -0800 (PST)
Date:   Fri, 15 Jan 2021 11:37:15 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/1] io_uring: fix skipping of old timeout events
Message-ID: <20210115163715.GA6400@marcelo-debian.domain>
References: <20210114155007.13330-1-marcelo827@gmail.com>
 <26e81241-f84c-72be-ca4a-452090db20a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26e81241-f84c-72be-ca4a-452090db20a5@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 14, 2021 at 09:42:36PM +0000, Pavel Begunkov wrote:
> On 14/01/2021 15:50, Marcelo Diop-Gonzalez wrote:
> > This patch tries to fix a problem with IORING_OP_TIMEOUT events
> > not being flushed if they should already have expired. The test below
> > hangs before this change (unless you run with $ ./a.out ~/somefile 1):
> 
> How sending it as a liburing test?

Oh yea I didn't even think of that. I can clean it up some and send a patch

-Marcelo

> 
> BTW, there was a test before triggering this issue but was shut off
> with "return 0" at some point, but that's not for sure.
> 
> > 
> > #include <fcntl.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <unistd.h>
> > 
> > #include <liburing.h>
> > 
> > int main(int argc, char **argv) {
> > 	if (argc < 2)
> > 		return 1;
> > 
> > 	int fd = open(argv[1], O_RDONLY);
> > 	if (fd < 0) {
> > 		perror("open");
> > 		return 1;
> > 	}
> > 
> > 	struct io_uring ring;
> > 	io_uring_queue_init(4, &ring, 0);
> > 
> > 	struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
> > 
> > 	struct __kernel_timespec ts = { .tv_sec = 9999999 };
> > 	io_uring_prep_timeout(sqe, &ts, 1, 0);
> > 	sqe->user_data = 123;
> > 	int ret = io_uring_submit(&ring);
> > 	if (ret < 0) {
> > 		fprintf(stderr, "submit(timeout_sqe): %d\n", ret);
> > 		return 1;
> > 	}
> > 
> > 	int n = 2;
> > 	if (argc > 2)
> > 		n = atoi(argv[2]);
> > 
> > 	char buf;
> > 	for (int i = 0; i < n; i++) {
> > 		sqe = io_uring_get_sqe(&ring);
> > 		if (!sqe) {
> > 			fprintf(stderr, "too many\n");
> > 			exit(1);
> > 		}
> > 		io_uring_prep_read(sqe, fd, &buf, 1, 0);
> > 	}
> > 	ret = io_uring_submit(&ring);
> > 	if (ret < 0) {
> > 		fprintf(stderr, "submit(read_sqe): %d\n", ret);
> > 		exit(1);
> > 	}
> > 
> > 	struct io_uring_cqe *cqe;
> > 	for (int i = 0; i < n+1; i++) {
> > 		struct io_uring_cqe *cqe;
> > 		int ret = io_uring_wait_cqe(&ring, &cqe);
> > 		if (ret < 0) {
> > 			fprintf(stderr, "wait_cqe(): %d\n", ret);
> > 			return 1;
> > 		}
> > 		if (cqe->user_data == 123)
> > 			printf("timeout found\n");
> > 		io_uring_cqe_seen(&ring, cqe);
> > 	}
> > }
> > 
> > v3: Add ->last_flush member to handle more overflow issues
> > v2: Properly handle u32 overflow issues
> > 
> > Marcelo Diop-Gonzalez (1):
> >   io_uring: flush timeouts that should already have expired
> > 
> >  fs/io_uring.c | 29 +++++++++++++++++++++++++----
> >  1 file changed, 25 insertions(+), 4 deletions(-)
> > 
> 
> -- 
> Pavel Begunkov
