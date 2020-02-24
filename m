Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410E516AE9E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgBXSXI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:23:08 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33351 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBXSXH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:23:07 -0500
Received: by mail-il1-f194.google.com with SMTP id s18so8550703iln.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=47qC7CrzrupYhCIvTz5G/hV/3kA77m50Bt4nWl2XzvM=;
        b=xUhRzezabDfkxJWH4K5f7XUXyWGhh38i+5Nydfuh5UIeCt1LMt1GdClHUsHyPB0HaC
         6JNFUZVtC6vj0j41AUBN7VukWyhHKx//lbaM7dX4s7aZE97Pm68aAhrHF59TbhqYDc5C
         TZ830hz7+vCffQ89yxsGXQNIDRxyqH+ctev1/+3hGz9VfSa6pwfWp+ISmDck4ii9bD4w
         cf+tDwaX0+xdi+3+GU/5HwtiiCYAnBbX07avKpj7f0kJoEDUhSKwc9RcUnsfF8juFcRZ
         qxHAIx6GmGvKaM4OZXfANJ75K8sA2Rz2ywJHcgq5CTVxNd+TvyITuPzWk/x1P8cpDEIk
         9/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=47qC7CrzrupYhCIvTz5G/hV/3kA77m50Bt4nWl2XzvM=;
        b=HX8klnyipguBipevVMNH/jvrtUVrcHVKC2qpgkW7J8+O2o/MaBjBBWvf1J3a6e1gJv
         jeW8aMCT/iEPnvnDhH4m25RLx/mbAnNSVijhCVARo1KmyaO1jCzJG6GnC3rGAYH4HNxa
         ER3knxJu8T85WQKG3ar3RhDI7s95LbBs/BKqYB7i09WPrGLoIBAjyvjdphwL6BLAMzWw
         M6p+KIZ1hgloJpo/6DyZtBAYuwXTEb6/JmQBOw5cgewEZJcSQjP85fNMEhDXycygs7Tl
         qYcON2xPgquBSZRr8GKvwiGoYCwE2WRJDRuxg2kKiUcOtfAcsXLCg2W7uJCkrBH2j0HD
         IhMA==
X-Gm-Message-State: APjAAAXkPwTOnyunrW8N5MRMPM8ZNDudVEMczpe1P0rEG1uXGlSilV7g
        ugsww+KUiCJrUdPCpCee8sQxpXZTVsI=
X-Google-Smtp-Source: APXvYqyulbjHQHciX0/sug7vFVs8f+OIfRa7MJQWNtwMX3Qs7WNjkYK04bXVZ86MUdcW4XWBSv5RUg==
X-Received: by 2002:a92:9507:: with SMTP id y7mr62104129ilh.243.1582568586908;
        Mon, 24 Feb 2020 10:23:06 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 75sm4561489ila.61.2020.02.24.10.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:23:06 -0800 (PST)
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
Date:   Mon, 24 Feb 2020 11:23:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 10:55 AM, Pavel Begunkov wrote:
> +static int copy_single(struct io_uring *ring,
> +			int fd_in, loff_t off_in,
> +			int fd_out, loff_t off_out,
> +			int pipe_fds[2],
> +			unsigned int len,
> +			unsigned flags1, unsigned flags2)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	int i, ret = -1;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	if (!sqe) {
> +		fprintf(stderr, "get sqe failed\n");
> +		return -1;
> +	}
> +	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
> +			     len, flags1);
> +	sqe->flags = IOSQE_IO_LINK;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	if (!sqe) {
> +		fprintf(stderr, "get sqe failed\n");
> +		return -1;
> +	}
> +	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
> +			     len, flags2);
> +
> +	ret = io_uring_submit(ring);
> +	if (ret <= 1) {
> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
> +		return -1;
> +	}

This seems wrong, you prep one and submit, the right return value would
be 1. This check should be < 1, not <= 1. I'll make the change, rest
looks good to me. Thanks!

-- 
Jens Axboe

