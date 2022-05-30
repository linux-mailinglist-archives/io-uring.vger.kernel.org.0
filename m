Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D729537ADA
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 14:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiE3M4W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 08:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiE3M4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 08:56:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53939814AC
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:56:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so10657017pjf.5
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K6VzgG1AJe4Xd+5hJRY/oqKoGn5IvIO2rEcozSWX0Ic=;
        b=xvfJ92XLHM6Kg7CsqAs7zGoeKKLABjxDJXoxDnnWHT0HchU+Cq+Ln9U/F2AlaeXFJI
         Tx8bdbmnq2DRdQOZ2hwpVKyPVzUO16qDDmhWgAByCtiZnxwhUrNPPZo4SRsCJFE2uHwP
         Sn70UTSteOA1xdgS5UVN9gBQH8O0//3h/Wu+cOYVTWOrOKoY0KXxD7CLS1Prhg/LrLz1
         CfkOZ+HSiVbLm70gG6o6cezO0dYmf+u9bEETIMwmjuDd0aMK2YjsNYQsGyvdCtn9CMUm
         RsnrWvJbskAcd/9QOXYBiM7xPYVTjbXxP1QX6FnacTMhKgyeDrPjX3KP22xR1cqqZIaP
         qsnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K6VzgG1AJe4Xd+5hJRY/oqKoGn5IvIO2rEcozSWX0Ic=;
        b=8Qt5b/KAEzUNTcvmEWEwOtDfu0KQGGN5tSlnW8yNDXSHNR2Jd3yxAqtECXfJXJPqyR
         3NkuEL2i2GHD8wlCRvMjiNZ/1+er6SJRZ0/4vzMhAmdp7RueBQXiA979wbgRqhh5BUhz
         kme1o3a/Fg5eXd76PcNn2LJgHtFpbmjtY0uE6zPdz3wW/uwn9FoKdd6HKjHQQ3NJy03v
         aUeZcRcpBHjzQKTL8yQuHSThT8yqYsWXz08D6N8yyXGQQfRSjaJ0hGyODKQ0AMnfcTjo
         mgdLsrsSITzeDNvTniYH/faCrNsQXPR6N6++Tyh9kwWoSP/qZ8tNBN4aIA/kaYlvPWsm
         nzJg==
X-Gm-Message-State: AOAM531fSCEkFMo0psP479ayxKVXwroKteTF+iIP64IM5ULtd+2jQk/X
        1ewvKeI3/q9C7N+ImPKlTwjUFg==
X-Google-Smtp-Source: ABdhPJzlp4QcUl2poIbkjGWdEicdK/5zLzaGFZkQpMTFKI5iFd9nmULRN7AQyyqpCN1AeR+BDJv+0Q==
X-Received: by 2002:a17:902:b107:b0:161:db34:61ea with SMTP id q7-20020a170902b10700b00161db3461eamr54746022plr.27.1653915379769;
        Mon, 30 May 2022 05:56:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090aec0800b001e30207ae98sm1902200pjy.7.2022.05.30.05.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 05:56:19 -0700 (PDT)
Message-ID: <0a27cbbb-2d14-132b-2892-885389f1da5b@kernel.dk>
Date:   Mon, 30 May 2022 06:56:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [LIBURING PATCH] Let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530124827.23756-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220530124827.23756-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 6:48 AM, Xiaoguang Wang wrote:
> Allocate available direct descriptors instead of having the
> application pass free fixed file slots. To use it, pass
> IORING_FILE_INDEX_ALLOC to io_uring_prep_files_update(), then
> io_uring in kernel will store picked fixed file slots in fd
> array and let cqe return the number of slots allocated.

Ah thanks, didn't see this before replying. A few minor comments:

> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 6429dff..9b95ad5 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -614,6 +614,14 @@ static inline void io_uring_prep_close_direct(struct io_uring_sqe *sqe,
>  	__io_uring_set_target_fixed_file(sqe, file_index);
>  }
>  
> +static inline void io_uring_prep_close_all(struct io_uring_sqe *sqe,
> +					   int fd, unsigned file_index)
> +{
> +	io_uring_prep_close(sqe, fd);
> +	__io_uring_set_target_fixed_file(sqe, file_index);
> +	sqe->close_flags = 1;
> +}

This needs a man page addition as well to io_uring_prep_close.3.

> diff --git a/test/file-update-index-alloc.c b/test/file-update-index-alloc.c
> new file mode 100644
> index 0000000..774cbb5
> --- /dev/null
> +++ b/test/file-update-index-alloc.c
> @@ -0,0 +1,129 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: test IORING_OP_FILES_UPDATE can support io_uring
> + * allocates an available direct descriptor instead of having the
> + * application pass one.
> + */
> +
> +#include <errno.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <sys/uio.h>
> +
> +#include "helpers.h"
> +#include "liburing.h"
> +
> +int main(int argc, char *argv[])
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	char wbuf[1] = { 0xef }, rbuf[1] = {0x0};
> +	struct io_uring ring;
> +	int i, ret, pipe_fds[2], fds[2] = { -1, -1};
> +
> +	ret = io_uring_queue_init(8, &ring, 0);
> +	if (ret) {
> +		fprintf(stderr, "ring setup failed\n");
> +		return -1;
> +	}
> +
> +	ret = io_uring_register_files(&ring, fds, 2);
> +	if (ret) {
> +		fprintf(stderr, "%s: register ret=%d\n", __func__, ret);
> +		return -1;
> +	}
> +
> +	if (pipe2(pipe_fds, O_NONBLOCK)) {
> +		fprintf(stderr, "pipe() failed\n");
> +		return -1;
> +	}
> +
> +	/*
> +	 * Pass IORING_FILE_INDEX_ALLOC, so io_uring in kernel will allocate
> +	 * available direct descriptors.
> +	 */
> +	fds[0] = pipe_fds[0];
> +	fds[1] = pipe_fds[1];
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_files_update(sqe, fds, 2, IORING_FILE_INDEX_ALLOC);
> +	ret = io_uring_submit(&ring);
> +	if (ret != 1) {
> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
> +		return -1;
> +	}
> +	ret = io_uring_wait_cqe(&ring, &cqe);
> +	if (ret < 0 || cqe->res < 0) {
> +		fprintf(stderr, "io_uring_prep_files_update failed: %d\n", ret);
> +		return ret;
> +	}

If cqe->res == -EINVAL, then the feature isn't supported. We should not
fail the test for that, we should just skip it and return 0. Otherwise
this test case will fail on older kernels, which is annoying noise.

Apart from that, test case looks good, and it's nice that it also uses
the fd post updating to ensure everything is sane.

-- 
Jens Axboe

