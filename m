Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A582F6D78
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 22:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbhANVqy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbhANVqx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 16:46:53 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C403C061757
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 13:46:13 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m4so7286948wrx.9
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 13:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GNupYOiEwRww3uPPTSuK0ThELzT/hWTENG3gE9XHPEs=;
        b=WTMwkATH96zG92ZBsrnYlrAsTythi2fC3VvA41eJU2P5ecC2OoAYJlky144lnBLQKN
         1KNrAWUyWTQkILyKgApUyWRM/bcrk6CK6XPiTvs0SR0QYioFfs8FzuhABjWyGnsWIu1P
         Pasm/2Yg0CisljxZkZfs/VUqUHYxEBU7fkccxd8k6l59IWpywCJdJMdnOgNotqlTGgg3
         6yv3kUEYNtU1bQVbG4VC8cu6eh4j0NZMGiHybvjM+67th6A/dO+PcYw16o7AwTF93tNN
         aJtWmAW4xcWNXtrVqUZTgB/DT4bV0Hrwi2IbrDfwyppCtZhT/7PqcIzEU+tXLmNreBQA
         dyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GNupYOiEwRww3uPPTSuK0ThELzT/hWTENG3gE9XHPEs=;
        b=iu2ZaaZSnQXFFRzldmThmMyaIphWia8dlduYwSAo9UsZxfTuud/G/S7kluMXOyoepJ
         FCLKujvpRvFfFDWhrhtM0/RR6qpqdlb18IYDhH+Nf/ykLn+NQilNVk5gY/RPiybx689I
         FE5PgazkcoqthHABUNObry0EQY9vzPxoHBKhZHHpvdyQi/3+yCYBG3PpocT/+fT4zeWF
         E7nkFV+YLNJm9CblQ+w8W3ODNqGwew5MmeRAoGfcjewTZpD02SkPSzDb4sXWwI1qx0Lc
         aD1FLAWEv9vMFzgVwPOgJKNQ+xQhSSdbKEyC8vQAz8EngyiyLtKVEB0czSrRJpUyl1rj
         TsEg==
X-Gm-Message-State: AOAM532CGPdJxlEY6YqkTWcDA96QE2rFYHHUDnNFiqBSM11FpfO3vrq+
        pqh0IlVARTvZ9SqIu7+hEy4VRqhu1euMTw==
X-Google-Smtp-Source: ABdhPJwgjHCjdiL0tgfyRNbCBviZ7eWpPWhI+90sp63P/HffIbGjmY/K/+IAPSEtaX1x6MXmynV7Cw==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr10058305wrn.245.1610660771694;
        Thu, 14 Jan 2021 13:46:11 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id e15sm12435756wrx.86.2021.01.14.13.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:46:11 -0800 (PST)
Subject: Re: [PATCH v3 0/1] io_uring: fix skipping of old timeout events
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <20210114155007.13330-1-marcelo827@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <26e81241-f84c-72be-ca4a-452090db20a5@gmail.com>
Date:   Thu, 14 Jan 2021 21:42:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210114155007.13330-1-marcelo827@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 15:50, Marcelo Diop-Gonzalez wrote:
> This patch tries to fix a problem with IORING_OP_TIMEOUT events
> not being flushed if they should already have expired. The test below
> hangs before this change (unless you run with $ ./a.out ~/somefile 1):

How sending it as a liburing test?

BTW, there was a test before triggering this issue but was shut off
with "return 0" at some point, but that's not for sure.

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
> 
> v3: Add ->last_flush member to handle more overflow issues
> v2: Properly handle u32 overflow issues
> 
> Marcelo Diop-Gonzalez (1):
>   io_uring: flush timeouts that should already have expired
> 
>  fs/io_uring.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 

-- 
Pavel Begunkov
