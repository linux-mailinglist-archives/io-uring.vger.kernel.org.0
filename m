Return-Path: <io-uring+bounces-7519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A67DDA91EFA
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 15:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 703FA19E6963
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 13:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96CC2505C6;
	Thu, 17 Apr 2025 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GVSAxTDu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F77124FBE2
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 13:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744898258; cv=none; b=pA+7Ix5WSCrBXYrS8r/4fVxkZh9ZEnWpXw5JFlRmG4HDFNBjZmk51GojYwd9MYiWQFIsrAIb89z95dYT5UA5j/AfPY99bIZvgSKu1C5K7PZ6isgg2JYslUxHpvWH8G1nNyJ5gFB61feKhKxHfZsucK6wB5xgRWvep8st7fawIdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744898258; c=relaxed/simple;
	bh=wcmljfYiaC7m7akAT/N5pZTiCbM2+PDi2OWQ7uBZ3KQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=K3Qx7AcX/Uy9AkLT/QyWznc6ohULtXXbxmRmeQjdsBs18efZwbwk+jTWw72nuhKVYNsiZAVyjh3hlfts+3YsU/YMpwkRJ38laOV5693FkpqlsCR2EOOCNCdzBzXIoyg3kDpB7iP8D03VRHFeNpnTRoRSClv+kUxfIh7fU1twScs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GVSAxTDu; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85b3f92c866so18405639f.3
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 06:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744898254; x=1745503054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uHossHBIHhiQtycnHHH1ZCKhWuMKOgNa3ZK+r4Hc4QU=;
        b=GVSAxTDu80w4ELtqnZmKB8EKMeHIciNH1P/nIcjG/DoF+HCW6LdSAjc9d5+0crTk7x
         iLaNshK/HuOeZVN09SdjZiaDlltZdI/tqaQhg1brM5MV7xoRSGd4GrCPIhin6hKqldtB
         kUFhyMenRN+d0XuePuzbbCGsCZ15TKviiJwrdUc8igX6PAfFVBfUGeS1Taz2pOIeSEhL
         Y6V+4FexkSmgFoENoaRhSla3OW7MDjvbz3JI7qb1iz00tuAN7Y5dB4KdfGzprdJmFskJ
         uBMg2E2E4FVmsVKESTEpMrYXvH7Gt9IeAwywA6jARIpkIMWNzqZSgdqyFlumHkTSlti8
         GLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744898254; x=1745503054;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uHossHBIHhiQtycnHHH1ZCKhWuMKOgNa3ZK+r4Hc4QU=;
        b=H8nUBFNfBlbLXTMwXQpm1h6t+4TF7lMNIVznhGG831XtVvRqrx9Nn/Z4m1QuzYQd0n
         Y9SvXKVNk6vZRDDgiCrIgKvZOXeAhosioZY3O1fymnTi7cx5szzU4IWH9Usr40H9AbQp
         rX7mFesWR1iqDBZRqK7I+Dp9HYiKtbzXhzsMiBmzNpV9OKgo0gJWg6LrorKyadMHbZrp
         b92D7ALn0xKhoFQ7dEDQ3w1dDt3m3ZNwLr2KPyG3JaeNjv7gMjvYCvrv4b7UbqwQbbhO
         G4ZJ2cs5GIikOYcRQHLcrODtA2uWIB1B39Q+YdNMVnTdlhAIIVU1zsg2ugq67/1/jIhT
         sM4g==
X-Gm-Message-State: AOJu0YzYPXIUwTu6HiPBEG+yS3CVHmdL8APELCvIWzHYcHONJpj1PggL
	bWVbrLLN0em0X0uu8tJI3uGiZCvk5KdtFeI/x18SlkKTTXGWG/z/qi9er/ZzITyjSyTGD9/vUzT
	l
X-Gm-Gg: ASbGncvtMJ/MoqBAnrHQ3yJy4rEQAo8ZFsX/9KUgnsaboOsebfQ7AIH4i3q76wGjUT8
	fpcNOqqI0ZaQEAyNW7T+QoPBwrRtTAhsRVwrGSxEvhgjOo0mBtRpHKpKK+JldQMX72dpAZ8YXhC
	DSeH0F+X7qmzrm3UCWBI5hZ9SrI258O/+xFgaMcZE+JdwG0cTdCkF0Sj7za59y99IE0yg18A0bb
	I92URUyR1RcJ/mtC3wmWUkzKumifaqJzftZ9YdfAOxjUqV6gXZR23sEmIdTpdIffjpp3ppBWtyo
	NTO0TD77H1HJZy1r6uH0CtEaPxeDDeS9jcJ3dA==
X-Google-Smtp-Source: AGHT+IEY4CybTvkpHB7KDlFAIxSgGNIIV9FEgzjNf2Krs3hJdoQ3YQDp9yCneQePaeFgstEFPvNjOg==
X-Received: by 2002:a05:6602:4887:b0:85b:3407:c8c with SMTP id ca18e2360f4ac-861c57bc9c5mr610161539f.11.1744898254426;
        Thu, 17 Apr 2025 06:57:34 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8616522c958sm333445939f.6.2025.04.17.06.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 06:57:33 -0700 (PDT)
Message-ID: <f8e4d7d9-fb06-4a1b-9cba-0a42982bce48@kernel.dk>
Date: Thu, 17 Apr 2025 07:57:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org
References: <cover.1744882081.git.asml.silence@gmail.com>
 <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
 <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
 <CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>
 <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
 <20250417115016.d7kw4gch7mig6bje@ubuntu>
 <ca357dbb-cc51-487c-919e-c71d3856f915@gmail.com>
 <603628d3-78ec-47a3-804a-ee6dc93639fd@kernel.dk>
Content-Language: en-US
In-Reply-To: <603628d3-78ec-47a3-804a-ee6dc93639fd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/25 7:41 AM, Jens Axboe wrote:
> I'll turn the test case into something we can add to liburing, and fold
> in that change.

Here's what I tested, fwiw, and it reliably blows up pre the fixup. I'll
turn it into a normal test case, and then folks can add more invariants
to this one if they wish.


#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <liburing.h>

static struct iovec vec;

static int read_it(struct io_uring *ring, int fd, int len, int off)
{
	struct io_uring_sqe *sqe;
	struct io_uring_cqe *cqe;
	int ret;

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_read_fixed(sqe, fd, vec.iov_base + off, len, 0, 0);
	sqe->user_data = 1;

	io_uring_submit(ring);

	ret = io_uring_wait_cqe(ring, &cqe);
	if (ret) {
		fprintf(stderr, "wait %d\n", ret);
		return 1;
	}
	if (cqe->res < 0) {
		fprintf(stderr, "cqe res %s\n", strerror(-cqe->res));
		return 1;
	}
	if (cqe->res != len) {
		fprintf(stderr, "Bad read amount: %d\n", cqe->res);
		return 1;
	}
	io_uring_cqe_seen(ring, cqe);
	return 0;
}

static int test(struct io_uring *ring, int fd, int vec_off)
{
	struct iovec v = vec;
	int ret;

	v.iov_base += vec_off;
	v.iov_len -= vec_off;
	ret = io_uring_register_buffers(ring, &v, 1);
	if (ret) {
		fprintf(stderr, "Vec register: %d\n", ret);
		return 1;
	}

	ret = read_it(ring, fd, 4096, vec_off);
	if (ret) {
		fprintf(stderr, "4096 0 failed\n");
		return 1;
	}
	ret = read_it(ring, fd, 8192, 4096);
	if (ret) {
		fprintf(stderr, "8192 4096 failed\n");
		return 1;
	}
	ret = read_it(ring, fd, 4096, 4096);
	if (ret) {
		fprintf(stderr, "4096 4096 failed\n");
		return 1;
	}
	
	io_uring_unregister_buffers(ring);
	return 0;
}

int main(int argc, char *argv[])
{
	struct io_uring ring;
	int fd, ret;

	if (argc == 1) {
		printf("%s: <file>\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDONLY | O_DIRECT);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	posix_memalign(&vec.iov_base, 4096, 512*1024);
	vec.iov_len = 512*1024;

	io_uring_queue_init(32, &ring, 0);

	ret = test(&ring, fd, 0);
	if (ret) {
		fprintf(stderr, "test 0 failed\n");
		return 1;
	}

	ret = test(&ring, fd, 512);
	if (ret) {
		fprintf(stderr, "test 512 failed\n");
		return 1;
	}

	close(fd);
	io_uring_queue_exit(&ring);
	return 0;
}

-- 
Jens Axboe

