Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2950B2F8497
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 19:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbhAOSj1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 13:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbhAOSj1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 13:39:27 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A4C061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 10:38:46 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e22so19997173iom.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 10:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dOrwP/h5wYmEPWUt1Yol5cZe4Xf1qntkwxtO50gj+Zs=;
        b=ZZYXeKo0vqFzQlcKB0Am7YEU+Nj02yu4NUB2Yi7439bAtcDNIaqiN9ZiZaoaJW+SIP
         HCpMeRg0zG0YDKor4iEZ+Yiw29o0eF64JTwbiopC1ddFy1t8+0tOmgTd5zUfQSvS+GUS
         2atyuQJQOW3OCQUq/zY1uphWpteTEJ0HBsa3Q+IvWBu/UwlE77rzPmU5X+1L02wT0whD
         jFjpFGV9WFmpZYff8ar+C2v1CdbAsJD4TdKYET4SjarVTm3eFWamXYRPBCG3dMTGW0Ln
         +0lXjrKIzCCCPhBWz5x3NynS1y+jCrpHoHe1FA9P/ePzDMMfNE3Q6+lpt0GwKVafU8L7
         OCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dOrwP/h5wYmEPWUt1Yol5cZe4Xf1qntkwxtO50gj+Zs=;
        b=gwOW59EUUdPCBnaBQ5jl4/vVpIM1zFsov9PDQ4yFJFfOGmHx69c6yO0nCjXR3kWoMP
         clg0jhlt4vjoujcEcWe2qVjmnMtA87WfmS5x6758iFLOJYaEfcawgjq0Qwa+HBPJmmAl
         jfcCKOAUUi2MVh6KasSBlkA+LJ8JLLPuZnX5VHF7g96ikRJrvws4JZniHhSuiZuoYxaB
         SHXkvzyPIXNWnmMN6KAd4GQ64CzjJtuEzsSL+rerldcHUkhgRF6Ga9J438h1m4Taahk2
         STv9nVxYmqgC0oeEgyZaNROkdhEy+ql7jy1mXczTcuHmeqa/eB0VtHAXdoPgbUrSR3i7
         NQFw==
X-Gm-Message-State: AOAM533zD1tQ763H1RcbdTxltOULz7MWr8sDPOez8NltRmTXU8kFgLap
        IbxuuAaZq+L885wJuyhqTJLCVlIADMqNcg==
X-Google-Smtp-Source: ABdhPJx1GJAKcsVbvzmCwzrAy6Cz1rBYyyP9OfcAe/9ZGNPpGlAejAk5d4gvq3h+ZOeB3zCCyyUxxQ==
X-Received: by 2002:a6b:b5d2:: with SMTP id e201mr9319995iof.111.1610735925983;
        Fri, 15 Jan 2021 10:38:45 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b22sm4264305ioa.10.2021.01.15.10.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 10:38:45 -0800 (PST)
Subject: Re: [PATCH v4 0/1] io_uring: fix skipping of old timeout events
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
References: <20210115165440.12170-1-marcelo827@gmail.com>
 <7b70938a-3726-ccc0-049d-4a617c9d2298@kernel.dk>
 <20210115183148.GA14438@marcelo-debian.domain>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3da76f2e-4941-206d-8881-9452bfce5980@kernel.dk>
Date:   Fri, 15 Jan 2021 11:38:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210115183148.GA14438@marcelo-debian.domain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/15/21 11:31 AM, Marcelo Diop-Gonzalez wrote:
> On Fri, Jan 15, 2021 at 10:02:12AM -0700, Jens Axboe wrote:
>> On 1/15/21 9:54 AM, Marcelo Diop-Gonzalez wrote:
>>> This patch tries to fix a problem with IORING_OP_TIMEOUT events
>>> not being flushed if they should already have expired. The test below
>>> hangs before this change (unless you run with $ ./a.out ~/somefile 1):
>>>
>>> #include <fcntl.h>
>>> #include <stdio.h>
>>> #include <stdlib.h>
>>> #include <string.h>
>>> #include <unistd.h>
>>>
>>> #include <liburing.h>
>>>
>>> int main(int argc, char **argv) {
>>> 	if (argc < 2)
>>> 		return 1;
>>>
>>> 	int fd = open(argv[1], O_RDONLY);
>>> 	if (fd < 0) {
>>> 		perror("open");
>>> 		return 1;
>>> 	}
>>>
>>> 	struct io_uring ring;
>>> 	io_uring_queue_init(4, &ring, 0);
>>>
>>> 	struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
>>>
>>> 	struct __kernel_timespec ts = { .tv_sec = 9999999 };
>>> 	io_uring_prep_timeout(sqe, &ts, 1, 0);
>>> 	sqe->user_data = 123;
>>> 	int ret = io_uring_submit(&ring);
>>> 	if (ret < 0) {
>>> 		fprintf(stderr, "submit(timeout_sqe): %d\n", ret);
>>> 		return 1;
>>> 	}
>>>
>>> 	int n = 2;
>>> 	if (argc > 2)
>>> 		n = atoi(argv[2]);
>>>
>>> 	char buf;
>>> 	for (int i = 0; i < n; i++) {
>>> 		sqe = io_uring_get_sqe(&ring);
>>> 		if (!sqe) {
>>> 			fprintf(stderr, "too many\n");
>>> 			exit(1);
>>> 		}
>>> 		io_uring_prep_read(sqe, fd, &buf, 1, 0);
>>> 	}
>>> 	ret = io_uring_submit(&ring);
>>> 	if (ret < 0) {
>>> 		fprintf(stderr, "submit(read_sqe): %d\n", ret);
>>> 		exit(1);
>>> 	}
>>>
>>> 	struct io_uring_cqe *cqe;
>>> 	for (int i = 0; i < n+1; i++) {
>>> 		struct io_uring_cqe *cqe;
>>> 		int ret = io_uring_wait_cqe(&ring, &cqe);
>>> 		if (ret < 0) {
>>> 			fprintf(stderr, "wait_cqe(): %d\n", ret);
>>> 			return 1;
>>> 		}
>>> 		if (cqe->user_data == 123)
>>> 			printf("timeout found\n");
>>> 		io_uring_cqe_seen(&ring, cqe);
>>> 	}
>>> }
>>
>> Can you turn this into a test case for liburing? I'll apply the
>> associated patch, thanks (and to Pavel for review as well).
> 
> Yup, can do. I'll try to clean it up some first (especially so it
> doesn't just hang when it fails :/)

That'd of course be nice, but not a hard requirement. A lot of the
regressions tests will crash a broken kernel, so...

-- 
Jens Axboe

