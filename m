Return-Path: <io-uring+bounces-2535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCBB93862A
	for <lists+io-uring@lfdr.de>; Sun, 21 Jul 2024 23:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1871B280FFB
	for <lists+io-uring@lfdr.de>; Sun, 21 Jul 2024 21:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83760D268;
	Sun, 21 Jul 2024 21:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q4fZxlU+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6B42C95
	for <io-uring@vger.kernel.org>; Sun, 21 Jul 2024 21:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721596883; cv=none; b=jTop6E7cIjYIt1IbwapIa+RoOVr9ZkB4f8K9DyUllYqMsn13fkKeMIirnkIAtuDSkdc681Fh6r1tl+HAvAOxFDZ7oiyDUSakiZMX+InXdp/qKhzo7rHVh5NjjGXewiFD3jHN4nySvhZ97yMXtVsw8VSdrHO6GZaQfgBBHvupx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721596883; c=relaxed/simple;
	bh=UoynDLM2LbDe0X1r4BpWtwV7Plhb+O1ewVITw9MDdAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AqSgLBDY8u3FBVRM3WawrvVvXTiCj3UxGfHYektstnrBmQy2tt3FjLCNA48ptR2DY6Yk40q93sKxG3AWqj636ENKm9oFhtFBmyHo0FjnUvgpGzDg2bAvuDQianbcPK7U8nEz+yjlktGfiglkEhpvIEio+ESg9IBqTopOv92tgEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q4fZxlU+; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2cb4c2d13a0so565344a91.0
        for <io-uring@vger.kernel.org>; Sun, 21 Jul 2024 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721596880; x=1722201680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hwoi+xnqOza0tGjPU6DkYcikvADWlzsV5Kz6p1lQE7M=;
        b=Q4fZxlU+oD9nLfqj+vEKf5njE8VSofxCvrvXNsL/BMJtUHU0rrZTLUA6aTzCwyu1YC
         GWFZg+y3bhLPZLFRsDMddVNUWZO2m6CzmjUzpNdxxCli+q2lk1H6u+HDr0ibnM7wgMFt
         cXVtk07uljnKgpxPrX42IuPiGNoM4rjAVJUcvhgOt+M1Qzi99frvb3yQl3pnx/QSc1zf
         y6y8e+qqAyt/5o4AnCxlcNABKoyfmC4mp4pJRI80n2aL5DJyhOqzD6o1IY9Rg0wqVt9u
         tX1y8KNUwZIX+bu/AtMw2pWAh+WbziZlabWeDGEq3/p1Acx3aGJDgpzaB62aTG/FNj1b
         mVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721596880; x=1722201680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hwoi+xnqOza0tGjPU6DkYcikvADWlzsV5Kz6p1lQE7M=;
        b=xSq+cFc5daq1VYc5S4Tm1vsH8YZAVEtOhoeqwL+K1WBkaT8xBnTX473xLuX/gZnI1t
         feAiWSEoxL3WR8vl8KeU4oL1gXi8rqquZ8BTJGdZw9FWmjoMaFhHO8sLDdSXN7mXgwOl
         nlrb1MydEutVwpA+VELo99/xyK3YlHtrT8ZNrWCRethwtW2E4mESKeM55buK7zrxPMe8
         wKhNOYWUQmsjP6M5moEPoVvonAxpjg/C3V+0QAk8ZrPrAuzs1uWsTf9G+1GgiDWDJyoB
         MpEQh9vScA399Kgal5munDcvs8PWals/7qTkObhHzN2Dtjvm1mgDcBSgXSQ/UsreMQ1p
         7o4g==
X-Gm-Message-State: AOJu0YzE4aOIDMrhJnsym7LfO4xJiRiLFoKx/XGKSVZ1T+lzKbVRTFl1
	Dll30OgG2ctFPDIQb0o1SyWWBDgzTCEWvphS2Eg8KGuzWNw4MRPdenJ+rQeXpK/Evsui9umCN1L
	cvlM=
X-Google-Smtp-Source: AGHT+IFgaz/TYVXfr9KJ6WL8UbcjGJLPCMLdVw+skoW6wIXNGCCTqghUUAsp/+MNcW2Cxsxi6V6gOg==
X-Received: by 2002:a17:903:1ca:b0:1fc:5b41:bb1b with SMTP id d9443c01a7336-1fd74560aa8mr50182645ad.4.1721596879718;
        Sun, 21 Jul 2024 14:21:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f3181ffsm40884015ad.155.2024.07.21.14.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 14:21:19 -0700 (PDT)
Message-ID: <3e1cdd67-22e2-4706-a581-2e05d174d2f2@kernel.dk>
Date: Sun, 21 Jul 2024 15:21:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/5] tests: Add test for bind/listen commands
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240604000417.16137-1-krisman@suse.de>
 <20240604000417.16137-4-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240604000417.16137-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/24 6:04 PM, Gabriel Krisman Bertazi wrote:
> +static void *do_server(void *data)
> +{
> +	struct srv_data *rd = data;
> +
> +	struct io_uring_params p = { };
> +	struct __kernel_timespec ts;
> +	struct io_uring_sqe *sqe;
> +	struct io_uring_cqe *cqe;
> +	struct io_uring ring;
> +	int ret, conn, sock_index;
> +	unsigned head;
> +	int fd, val;
> +	char buf[1024];
> +
> +	ret = t_create_ring_params(4, &ring, &p);
> +	if (ret < 0) {
> +		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
> +		goto err;
> +	}
> +
> +	ret = io_uring_register_files(&ring, &fd, 1);
> +	if (ret) {
> +		fprintf(stderr, "file register %d\n", ret);
> +		goto err;
> +	}
> +
> +	memset(&server_addr, 0, sizeof(struct sockaddr_in));
> +	server_addr.sin_family = AF_INET;
> +	server_addr.sin_port = htons(8000);
> +	server_addr.sin_addr.s_addr = htons(INADDR_ANY);
> +
> +	sock_index = 0;
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0,
> +				    sock_index, 0);
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	val = 1;
> +	io_uring_prep_cmd_sock(sqe, SOCKET_URING_OP_SETSOCKOPT, 0,
> +			       SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
> +	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_bind(sqe, sock_index, (struct sockaddr *) &server_addr,
> +			   sizeof(struct sockaddr_in));
> +	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_listen(sqe, sock_index, 1);
> +	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
> +
> +	ret = io_uring_submit(&ring);
> +	if (ret < 0) {
> +		printf("submission failed. %d\n", ret);
> +		goto err;
> +	}

Did you test this on older kernels? I suspect they will fail without
IORING_SETUP_SUBMIT_ALL set, and they will fail even if set for kernels
that don't support bind/listen.

We need to reliably return T_EXIT_SKIP for kernels that don't support
this feature.

> +static int do_client()
> +{
> +	struct io_uring_sqe *sqe;
> +	struct io_uring_cqe *cqe;
> +	struct sockaddr_in peer_addr;
> +	socklen_t addr_len = sizeof(peer_addr);
> +	struct io_uring ring;
> +	int ret, fd = -1, sock_index;
> +	int i;
> +
> +	ret = io_uring_queue_init(3, &ring, 0);
> +	if (ret < 0) {
> +		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
> +		return -1;
> +	}
> +
> +	ret = io_uring_register_files(&ring, &fd, 1);
> +	if (ret) {
> +		fprintf(stderr, "file register %d\n", ret);
> +		goto err;
> +	}
> +
> +
> +	peer_addr.sin_family = AF_INET;
> +	peer_addr.sin_port = server_addr.sin_port;
> +	peer_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> +
> +	sock_index = 0;
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0,
> +				    sock_index, 0);
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_connect(sqe, sock_index, (struct sockaddr*) &peer_addr, addr_len);
> +	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
> +
> +	sqe = io_uring_get_sqe(&ring);
> +
> +	io_uring_prep_send(sqe, sock_index, magic, strlen(magic), 0);
> +	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
> +
> +	io_uring_submit(&ring);
> +	io_uring_wait_cqe_nr(&ring, &cqe, 3);

Ditto for these, if socket/connect/send aren't supported.

> +
> +	io_uring_for_each_cqe(&ring, i, cqe) {
> +		if (cqe->res < 0) {
> +			printf("client cqe. idx=%d, %d\n", i, cqe->res);
> +		}
> +	}
> +	io_uring_cq_advance(&ring, 2);
> +
> +	return 0;
> +err:
> +	return -1;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	pthread_mutexattr_t attr;
> +	pthread_t srv_thread;
> +	struct srv_data srv_data;
> +	int ret;
> +	void *retval;
> +
> +	if (argc > 1)
> +		return 0;
> +
> +	pthread_mutexattr_init(&attr);
> +	pthread_mutexattr_setpshared(&attr, 1);
> +	pthread_mutex_init(&srv_data.mutex, &attr);
> +	pthread_mutex_lock(&srv_data.mutex);

Probably be better with a barrier rather than a mutex?

-- 
Jens Axboe


