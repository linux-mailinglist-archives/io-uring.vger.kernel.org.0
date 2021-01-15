Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A332F8170
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbhAORCy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbhAORCy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:02:54 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED62C061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:02:14 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id w18so19461236iot.0
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8LOlWUeLUBDB6RiKlP5UStWt6QlHYiEMhjVHGsbCwps=;
        b=PWz9kJ32pY4sLSCA9FUpl/Kcqf2I1Z6zgBVPgl9Q3nd4+jwy2FuhsSAEK58/U4EBjX
         oSgj/aF0pT7vxsTe6Jw+ioRAqoKAF2yKJp8NdSt6PF/wiQW11IYHKVpxpB8D69Tx1b+2
         R8MToSUJCX8hnGeS9rQf8AbBo/UNh6KxHcHV0eq1lOag6Fru/2VFpwmMdgFOmKChw6UA
         js7T2boosO3ZsbOKG9KNZCL9itGvOZrm10WAmt2khfY14WDQy/bztzmNuM48npvIv8PX
         TQPFys24lkOD0/Z950doTN28+UZrmnYexucy77UR1M4qx9MJ2OnVxgXHceImqXzK/luY
         pwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8LOlWUeLUBDB6RiKlP5UStWt6QlHYiEMhjVHGsbCwps=;
        b=NGeGc+I+oahnti/s2UNcJq2crUDYY9tKpIkFmBzvPBZsLzmRAcqbV5i4JtqK1dUP13
         HYMHeTvH3MFn/GSamQPgZGbvJ/9ZJZPIBkGO/LmgNGTKoc16RPN/RWurDR/Ugtfx1Dn2
         5ShLlqz7BCbXLqVrIGySbVd+BUY5HkK20j9Q+oFAxtK8P0LRtS9N3c0b0PNfKGL2tGUQ
         i2F4ZjrJKwR8KS1xtV6WTfNBbkd6x5GIFgsFGetkiqbkwuBEjJzY2kqNZesOYu80VRQV
         fiwSRMOFBOJ/a+7EeN7j2yP5HOJPoxeTgwuvCcGw02O19ozcEPl5cxU/8GlStzZUp4aZ
         f/tg==
X-Gm-Message-State: AOAM533K16GPA9edsqIGKsZKcMiL3rXgHl4oAG1BJ+RgKrGLonnFr9VE
        X1wZoI9kdACPmUykdwLSpIXSKAJfMce/EQ==
X-Google-Smtp-Source: ABdhPJyHXtUgDquTA3CH0kE0+2fk/slXO1dCSCKjop2fTeQbWww8kgzCt2KzDpfnFhkTaiMPdOFVOQ==
X-Received: by 2002:a05:6e02:11a6:: with SMTP id 6mr9852672ilj.87.1610730133199;
        Fri, 15 Jan 2021 09:02:13 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm1743457ilh.23.2021.01.15.09.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 09:02:12 -0800 (PST)
Subject: Re: [PATCH v4 0/1] io_uring: fix skipping of old timeout events
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org
References: <20210115165440.12170-1-marcelo827@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7b70938a-3726-ccc0-049d-4a617c9d2298@kernel.dk>
Date:   Fri, 15 Jan 2021 10:02:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210115165440.12170-1-marcelo827@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/21 9:54 AM, Marcelo Diop-Gonzalez wrote:
> This patch tries to fix a problem with IORING_OP_TIMEOUT events
> not being flushed if they should already have expired. The test below
> hangs before this change (unless you run with $ ./a.out ~/somefile 1):
> 
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> 
> #include <liburing.h>
> 
> int main(int argc, char **argv) {
> 	if (argc < 2)
> 		return 1;
> 
> 	int fd = open(argv[1], O_RDONLY);
> 	if (fd < 0) {
> 		perror("open");
> 		return 1;
> 	}
> 
> 	struct io_uring ring;
> 	io_uring_queue_init(4, &ring, 0);
> 
> 	struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
> 
> 	struct __kernel_timespec ts = { .tv_sec = 9999999 };
> 	io_uring_prep_timeout(sqe, &ts, 1, 0);
> 	sqe->user_data = 123;
> 	int ret = io_uring_submit(&ring);
> 	if (ret < 0) {
> 		fprintf(stderr, "submit(timeout_sqe): %d\n", ret);
> 		return 1;
> 	}
> 
> 	int n = 2;
> 	if (argc > 2)
> 		n = atoi(argv[2]);
> 
> 	char buf;
> 	for (int i = 0; i < n; i++) {
> 		sqe = io_uring_get_sqe(&ring);
> 		if (!sqe) {
> 			fprintf(stderr, "too many\n");
> 			exit(1);
> 		}
> 		io_uring_prep_read(sqe, fd, &buf, 1, 0);
> 	}
> 	ret = io_uring_submit(&ring);
> 	if (ret < 0) {
> 		fprintf(stderr, "submit(read_sqe): %d\n", ret);
> 		exit(1);
> 	}
> 
> 	struct io_uring_cqe *cqe;
> 	for (int i = 0; i < n+1; i++) {
> 		struct io_uring_cqe *cqe;
> 		int ret = io_uring_wait_cqe(&ring, &cqe);
> 		if (ret < 0) {
> 			fprintf(stderr, "wait_cqe(): %d\n", ret);
> 			return 1;
> 		}
> 		if (cqe->user_data == 123)
> 			printf("timeout found\n");
> 		io_uring_cqe_seen(&ring, cqe);
> 	}
> }

Can you turn this into a test case for liburing? I'll apply the
associated patch, thanks (and to Pavel for review as well).

-- 
Jens Axboe

