Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66AE2F847D
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbhAOScv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 13:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733221AbhAOScu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 13:32:50 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B966DC061798
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 10:31:51 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id h19so6683830qtq.13
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 10:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LezlRw2SQR4SFLFUo8fzxWE8/U57ZdzoN5fZmOd6aqE=;
        b=Wa0mINrXvXXPnB2KVfqYNqNRbQnSv0XbjFDfNbEqweyEI6W2S9Ejo5Ben7widaGDod
         m/4KrdvjVFzC9+UlPGWVP/rsw7JEyIbdcmteXL37SRuAbt/XvDiOzZa3q6jXOyMaxsYo
         iePSWBFP0mJQS1lRrSQBCmGRsIOlYyBQ3XzlFwNyLAsiEDFr86vV72WSXsfsklrRiW5u
         hqYMCnINneYkA3jlTmt3tht9WrYlo3ShqNwjopEWaGu1YehSOIT58nAEiUnXKX1/O/oL
         miIgehmAX5xu+jQo7fKJFYekZopMSsZoXm/W6lmx/gShnzjPFVXltZdpfGuWb1DcL0OT
         J7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LezlRw2SQR4SFLFUo8fzxWE8/U57ZdzoN5fZmOd6aqE=;
        b=aN9Hbne6749SsBvXvpFkPregD3+KEls+OBAhv/7qW6C0oVlQIbQO7hfhkrgYSB2Ug5
         p+UpuPFRlNvW/peSy+H2WsFh9jLisX1emEiM3jY11fND/mqVZrcUkq7hFwcq9ORvSgx3
         rQBQseYtvDC8hqvrFYTp10Bi/k4sVAOq5NITVHg2v/z6rI4yNWXZ6Teyv52hLOOu527W
         GcqwLkthjJa1O8HXwaL80JHCZK3gRsEbNpf5SsE+tm20zXsKdjcN9El1QA6PTjxYVnN0
         REKjpG8eimkps90mhmEQ4H9SvYDhd1KH+A+ooOdIeGVgxw/0Nx9hVsugEK460c7Su+rP
         uNXw==
X-Gm-Message-State: AOAM531EbHslKNtGkIj9rEm7HjTAOSs2QyEZ1JlByexe5NuFAc4nFGw/
        fFH6vjhWnuxvRw6xvnE4pLvS0a1KdROMtQ==
X-Google-Smtp-Source: ABdhPJzbIutBv6yHrqa126iFzjqjdko/w8MqPSYp1s1LoHPQPEfc/tp60+NiNZ6GN4PXZdvzia7/tA==
X-Received: by 2002:ac8:1348:: with SMTP id f8mr12953167qtj.54.1610735511015;
        Fri, 15 Jan 2021 10:31:51 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id a203sm5562612qkb.31.2021.01.15.10.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:31:50 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:31:48 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/1] io_uring: fix skipping of old timeout events
Message-ID: <20210115183148.GA14438@marcelo-debian.domain>
References: <20210115165440.12170-1-marcelo827@gmail.com>
 <7b70938a-3726-ccc0-049d-4a617c9d2298@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b70938a-3726-ccc0-049d-4a617c9d2298@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 15, 2021 at 10:02:12AM -0700, Jens Axboe wrote:
> On 1/15/21 9:54 AM, Marcelo Diop-Gonzalez wrote:
> > This patch tries to fix a problem with IORING_OP_TIMEOUT events
> > not being flushed if they should already have expired. The test below
> > hangs before this change (unless you run with $ ./a.out ~/somefile 1):
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
> 
> Can you turn this into a test case for liburing? I'll apply the
> associated patch, thanks (and to Pavel for review as well).

Yup, can do. I'll try to clean it up some first (especially so it
doesn't just hang when it fails :/)

> 
> -- 
> Jens Axboe
> 
