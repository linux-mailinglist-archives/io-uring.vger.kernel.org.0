Return-Path: <io-uring+bounces-448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 703BB83739F
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 21:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEF27B21619
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776B440BE2;
	Mon, 22 Jan 2024 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ma4MuC2G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E741201
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 20:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954868; cv=none; b=qGjmBj6ES9e8l0n/gSVy0zw45xRiTWA89RY3ueHVIzK8/EST6U6KGXoaDHXabkwHmhA7uxt2kXcyqSxF64s8c8u/EWmVLhYcnifgUXR3w65CNBv5G9xqT3lqwKZp8y2Qn/P4bBqcFheif8XXAclmwM5vItgUH2jLXIwQXFdaMfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954868; c=relaxed/simple;
	bh=Ke2vxkzR3m4ybKY+R1vpjfuzjA+GUZLZQ1TvDOsctVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kxGnYrzC3DlWaLIGMr35aODi3n0eDIkiR0PaJsA5g/WxeF7n26WIZnUH93VTE8ukxATug64c2LEi0+AltqODGSUOt9aju7FZTozB3iGKEKVyScargKAnp9vKAoR80+PyzI5ckshHlO+/H/S/7m6AhO8Xo4BqI+3t1o+jf2Y0taM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ma4MuC2G; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bb06f56fe9so38513139f.0
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 12:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705954865; x=1706559665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kNYubedvkdq6sKW49/D3tq/woU5vMdPsJs1Feq3LxTM=;
        b=ma4MuC2Gjppe1X5eV5ZpGG5WEtWAEapPyk//qUji55KD0EowB9oI5vJXTKM9IM7FYB
         G9ag3HVYKkxCQwytb6nAiSK9imqWj38GOn1P4inu2nJ50y0pFL5uhdmihDLTnoUWrgJz
         zf90dyb3dvMsTh0W/GmNpUolumY3OTN5uusX7gxqUKXfi2xlC2HelE8DWL+o9oF4WlI4
         cDnpmgWKKrfZn2kJYuuR2KXNOPCI/ppBxVHgyb28WQt9o2kNcSJB5Wa5GTqiM9iToWLC
         xLlpRPY1afA15/crXImTwPqSvm2YsZXgWHnJWyVjkeBmWgKiabIMX2vo4YJeqrHTPClf
         McbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705954865; x=1706559665;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kNYubedvkdq6sKW49/D3tq/woU5vMdPsJs1Feq3LxTM=;
        b=jXqDip4IqMbHyTdmbTnNkSwwvsKBNhkxsUKGGIzA8RDVpJHARbaqoQAcX+zFsYkDBh
         JSB5BfYwibVq6DNbtagLzp7egBNblZjYymTVx3mUFgi6FOIzD9sKsn6VMvwsZDzWraMM
         PYISkvIdFBgo6PT301WRyDBRh8b798FQ0dSiR0APLcIQFo3Bdt+VwUXgD7vzW2wMG9sh
         nKa373/GDwI+0vNMOeohMQYSzY5VB5FTdH0GDTbHHHGhR8malWNS9iueFVoy67w2EkXk
         +3RWo4n0bjsnB0SKaHruiBea6m3vOaGUkFrXWXxmqVh7bCFoptzq/CgzESKF/pT5YcwM
         UcAA==
X-Gm-Message-State: AOJu0YxTIZIfNs9Ag5lUekg0s8Vo6UuN4N9w3PaHDYT5wQnNM5eI/A5i
	TEuzeLdKKbVIjL85C3JC1ApgqXDTDzg1/QZUapqhwmXHj6fIXN4q3EfQq1R8OPwAH8Ow2/ycKu5
	4UyA=
X-Google-Smtp-Source: AGHT+IFuGRwRnQIcWx6Cpn9KxCRDeayMv8DbTlD7ZT0T201zQkIF4rtSOTaQR3i+ipZRe1K5fWHAlA==
X-Received: by 2002:a5d:93d5:0:b0:7bf:356b:7a96 with SMTP id j21-20020a5d93d5000000b007bf356b7a96mr7615326ioo.2.1705954865344;
        Mon, 22 Jan 2024 12:21:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r5-20020a056638130500b0046e8d86f2a7sm3220074jad.57.2024.01.22.12.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 12:21:04 -0800 (PST)
Message-ID: <5eb0f1cf-afe4-4322-bbaa-3c0452f6255b@kernel.dk>
Date: Mon, 22 Jan 2024 13:21:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: add support for truncate
Content-Language: en-US
To: Tony Solomonik <tony.solomonik@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240122193732.23217-1-tony.solomonik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

One more thing on this one...

> +int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
> +
> +	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	tr->pathname = u64_to_user_ptr(READ_ONCE(sqe->addr));

io_uring generally guarantees that any data passed in is stable past
submit returns, but that's not the case here. Imagine you had code ala:

prep_truncate(ring, dir, filename)
{
	char path[PATH_MAX];

	sprintf(path, "%s/%s", dir, filename);
	sqe = io_uring_get_seq(ring);
	io_uring_prep_truncate(sqe, path, -1, 0);
	/* your io_truncate_prep() will be run here */
	io_uring_submit(ring);
}

io_loop()
{
	...
	prep_truncate(ring, dir, filename);
	/* path was on stack and now out-of-scope, and there's nothing
	   preventing io_truncate() from running post that. */
}

which implies you'd want some refactoring done here as well, so you can
pass in a path for do_sys_truncate(). And then you would certainly need
the cleanup flag set, but also provide a ->cleanup() helper. See some of
the other fs handling code, like xattr, for how that should be done.

This problem obviously doesn't exist for the fd ftruncate variant, as
there's no path resolution to do there.

-- 
Jens Axboe


