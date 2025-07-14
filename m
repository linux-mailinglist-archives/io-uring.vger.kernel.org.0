Return-Path: <io-uring+bounces-8665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CB4B04247
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 16:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D461A3A023B
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 14:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5742E413;
	Mon, 14 Jul 2025 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xuod4a+R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80125393C
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504990; cv=none; b=dAh67PjaXMUdVM+Uz4I6rEynz36Ar+1HdUTiZjAcjxNuBhKhqIsUaor6IYFFDd4J7UPM1gDO85cFsXWPokgzrd/vu9a3oJs+uxpWeCM9nWfn9Kw21ZvJgnJ4HnQy59jQPNvKvwsTphgvlmMqiNjU+xgL9dg2gijuBZFRCbDwdd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504990; c=relaxed/simple;
	bh=4rBknrnQUHSUAjaFWlAFx+zYkXhzpRywFmxnGgkRBBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lJWFvq62kC9j9HtNOhHz+lvf5UzYvMJiIyc3XAWY0xQ1ny9U0JPf2FocmVpLk/zRBzJBSQXWJqFgkritHsii5OJ5F3dIwMuoNDAO7g0wltl/j2pO9+B2VdMcHpjg8dAooICdEvaezw1HENjfgPdcbyZwhbfROH6dDQygA5w0mQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xuod4a+R; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86cdb330b48so349237739f.0
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 07:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752504987; x=1753109787; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Yns99sicIem7XCl6PvvkqLlCVEACKPOsV4V1dAIoLA=;
        b=Xuod4a+RIFnSxbF8N5/b5eTfLRI76+rvL/MU8u6AGM0ladkSZyyxOS6UE2tRVyoroN
         8gGSSA9DNGTamU6+8pAWeEwTS4UYJZA4HXg1Js1PMJNQS1FzcPEy7YIvSYhA5Uec1X1/
         D43YhtWuYyHZV5kFTum5SvghCZRUtjsvWIxRwqU0sUOqDS83ryAAhygru6vYEm5wl0mc
         uyEf0Vu7lZCBq/Cl+xO3+NbJr8KwCJu9oFVnhKFzEYPNaHTnQLa9t6elH9zmynF/12h1
         KsHa34FOBLXrDvTI0oI4b1e9TDkqnza6P1JUTYKy+o6kBIPWFNV/VTrCu+g9Xgc4Y7Ht
         cYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752504987; x=1753109787;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Yns99sicIem7XCl6PvvkqLlCVEACKPOsV4V1dAIoLA=;
        b=gPfDgvebVU1z5F56XGyohDg6yl75z0ieoPMOodG+7QacXMqO/XKVemDz6zg+uQHjeh
         WqsY+wo8zoJXzMd42iUuN7cxjWzaN9XkBKTKWQqj62FkLHzJ3x9r+MvHt3g+Jy/SsOeh
         vcMHoDxylNiWgatT+e1oJfayQJ+uZy6kG7eUI7zkCljaodz+s8HuUhmvMF+QcXnVmLDI
         ogI+ymGfXpE6DJWcTxEhuw7lAUg9GPsleUBrBQIqh6wLfYLZbUeXg5kRGd2sdYv5L8mN
         1BagtmC3R8oRLC+7zP1OD3Jaek7mdrVeKMWlEHDtUyqSoIsfPWwqs1tqw0xlGG35mci2
         qW4A==
X-Forwarded-Encrypted: i=1; AJvYcCXz5Qwjv4vJdN89eyXNFKnLITbC4Fvp0LijuyKeyZv4rqgXrdtFRac1gBitTbZ/fVeEsE4C/8T36g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5WI84okxvGAHDp9DCl1M3mzsX7v0hJ/j04DpMvJFUD6ogWXIZ
	E5gKnnrBXOM6zlQM9og1q+K9hp96U68m/TTSLvnGk9fgYJOjcWNwTmQYSoVi7UgWQh0KlHvs6ug
	4XdpA
X-Gm-Gg: ASbGncurHs+qpTr9nqhQZ2AqGfu0bzV2xJOi68TZZvtfd68YavRnNQtLITZWNJ9/tay
	Q7oCK4HXITChj2Y6cQn9cUqVagw2z3CeqccVghSvPKy6Vrc5ceY79dGgq/z0tLRXhGYfFxTA7Tk
	36PJM3aXTpjgAyCBfENuMqyqT/dJn8IEcMXbD6/0KbCod2ZLTi0eZs65LH3Lrn23Ne8JkdqAznm
	vxoy3kQYrqCrnxL56MuIJ5PLGW0/DYdNqFoYhdzOo5mFmafaBFU6TPizVLu7XV+Ge8e2zJHgbcH
	ne3TQfSEubyQ99pDuymBPp8VZxRpVrJualgWR4hlU+viAATWm0C2YvVOcGOXJwoNzutsO+e3b8s
	TTgRLYC2kZ0J/9fFYsTE=
X-Google-Smtp-Source: AGHT+IEoYSom0Avuulrqum6z6eMIeu3LoYXIuuKInUu04vrDpCMEE06JsgtJ8fz/wcxwJsCIHlTUCA==
X-Received: by 2002:a05:6602:2c14:b0:867:8ef:69e8 with SMTP id ca18e2360f4ac-8797a77f3b5mr1285713839f.3.1752504987475;
        Mon, 14 Jul 2025 07:56:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc5bca6sm254855339f.43.2025.07.14.07.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 07:56:26 -0700 (PDT)
Message-ID: <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
Date: Mon, 14 Jul 2025 08:56:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 4:59 AM, Pavel Begunkov wrote:
> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
> is a little dirty hack that
> 1) wrongfully assumes that POLLERR equals to a failed request, which
> breaks all POLLERR users, e.g. all error queue recv interfaces.
> 2) deviates the connection request behaviour from connect(2), and
> 3) racy and solved at a wrong level.
> 
> Nothing can be done with 2) now, and 3) is beyond the scope of the
> patch. At least solve 1) by moving the hack out of generic poll handling
> into io_connect().
> 
> Cc: stable@vger.kernel.org
> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/net.c  | 4 +++-
>  io_uring/poll.c | 2 --
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 43a43522f406..e2213e4d9420 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  
>  int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>  {
> +	struct poll_table_struct pt = { ._key = EPOLLERR };
>  	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>  	struct io_async_msghdr *io = req->async_data;
>  	unsigned file_flags;
>  	int ret;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>  
> -	if (unlikely(req->flags & REQ_F_FAIL)) {
> +	ret = vfs_poll(req->file, &pt) & req->apoll_events;
> +	if (ret & EPOLLERR) {
>  		ret = -ECONNRESET;
>  		goto out;

Is this req->apoll_events masking necessary or useful?

-- 
Jens Axboe


