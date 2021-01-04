Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1EF2E9861
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 16:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbhADPWj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 10:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADPWj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 10:22:39 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3725EC061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 07:21:59 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id q5so25573351ilc.10
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 07:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NqESltLpBRSbCMQ11Avjv/Jok1o/PX4N86JLMLLQVMA=;
        b=jr2sD69lMmb5AV368mmZrEO83w6sv2HFYDbg28QKd1hE5oaUdA9QbrDjm/GBjfN0Lc
         chLpgujtb4EjXDGr06UQ4snKGnC+CA8cHFFlvEY4T9zzIQ8K6M7Pbv0YwcC2mwpMjSGW
         h0f8FFXxB/PlgII/pbM1znX3yD6xWU7nl49WAnZVxZQMXx9Im5qHSC9+WSMJq6pJI6hB
         WqUscUNXCcQ5w2DSVeB2U8C6RkScSSenTcBckLPc46Jna+YOcFKLDvmhGxloY3lvF6hs
         NcM6Vq2Dxk5geDJ9IQ7h70sk+XUw5E51cUaJ6wCmRJxdhVX1s+1HNsvHALeV+ZahJ/Ko
         DjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NqESltLpBRSbCMQ11Avjv/Jok1o/PX4N86JLMLLQVMA=;
        b=g+D9RyB/l1wWkH0FhHXNTez59NYcn1ppcssm5uFWu7BtEP8P0O6MlIlQ87ltPegAG9
         XhAVtW2/EdS8SWzyA2hdCvXNFIxDkBMC9MvfQTE+G4+EdnFl8yrPrb3DIoAjD/dwn/HP
         p6v/dmILnxA6Ds7wQ36kOTjaY9xlbmbgjD/ilVrIJ8fToVxusjfLT2+3c8q7iTCeAfJu
         AMl+qTiNobmQuLrLVEBvGtkjKizVFwJspfIe9UIgWRCMbzOzzTK458gLtjA3vrNiuQEb
         IzwkYwjQ8FK6nPia9+DNRbmgd4cSg8hQVESXY+N0QE4e/cqJWUnKR7IW37YWcAW0spha
         DTuw==
X-Gm-Message-State: AOAM533yuSlFOrsUpc0VS/3cwMRC8iH2l4pFI33ECY9e3+ZpUQJB86hf
        xb+BmJlD5ud9ZvriWmb2yJ5K8w==
X-Google-Smtp-Source: ABdhPJzeK6lgTwrwYZgtuJ5Rez/K/aq2ig+vlV5rLUoC54gBl+49gr+VxC3VJ2sjmRHC7i881twUXg==
X-Received: by 2002:a92:84c1:: with SMTP id y62mr70133822ilk.191.1609773718623;
        Mon, 04 Jan 2021 07:21:58 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b12sm41903293ilc.21.2021.01.04.07.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 07:21:57 -0800 (PST)
Subject: Re: Questions regarding implementation of vmsplice in io_uring
To:     arni@dagur.eu, io-uring@vger.kernel.org
Cc:     =?UTF-8?Q?=c3=81rni_Dagur?= <arnidg@protonmail.ch>
References: <20210103222117.905850-1-arni@dagur.eu>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <76da2c1e-9f92-72c4-0303-8f4c38aa994b@kernel.dk>
Date:   Mon, 4 Jan 2021 08:21:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210103222117.905850-1-arni@dagur.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/3/21 3:22 PM, arni@dagur.eu wrote:
> From: Árni Dagur <arnidg@protonmail.ch>
> 
> Hello,
> 
> For my first stab at kernel development, I wanted to try implementing
> vmsplice for io_uring. I've attached the code I've written so far. I have two
> questions to ask, sorry if this is not the right place.
> 
> 1. Currently I use __import_iovec directly, instead of using
> io_import_iovec. That's because I've created a new "kiocb" struct
> called io_vmsplice, rather than using io_rw as io_import_iovec expects.
> The reason I created a new struct is so that it can hold an unsigned int
> for the flags argument -- which is not present in io_rw. Im guessing that I
> should find a way to use io_import_iovec instead?
> 
> One way I can think of is giving the io_vmsplice struct the same initial
> fields as io_rw, and letting io_import_iovec access the union as io_rw rather
> than io_vmsplice. Coming from a Rust background however, this solution
> sounds like a bug waiting to happen (if one of the structs is changed
> but the other is not).
> 
> 2. Whenever I run the test program at
> https://gist.githubusercontent.com/ArniDagur/07d87aefae93868ca1bf10766194599d/raw/dc14a63649d530e5e29f0d1288f41ed54bc6b810/main.c
> I get a BADF result value. The debugger tells me that this occurs
> because `file->f_op != &pipefifo_fops` in get_pipe_info() in fs/pipe.c
> (neither pointer is NULL).
> 
> I give the program the file descriptor "1". Shouldn't that always be a pipe?
> Is there something obvious that I'm missing?

The change looks reasonable, some changes needed around not blocking.
But you can't use the splice ops with a tty, you need to use an end of a
pipe. That's why you get -EBADF in your test program. I'm assuming you
didn't run the one you sent, because you're overwriting ->addr in that
one by setting splice_off_in after having assigned ->addr using the prep
function?

> @@ -967,6 +976,11 @@ static const struct io_op_def io_op_defs[] = {
>  		.unbound_nonreg_file	= 1,
>  		.work_flags		= IO_WQ_WORK_BLKCG,
>  	},
> +	[IORING_OP_VMSPLICE] = {
> +		.needs_file = 1,
> +		.hash_reg_file		= 1,
> +		.unbound_nonreg_file	= 1,
> 
> I couldn't find any information regarding what the work flags do, so
> I've left them empty for now.

As a minimum, you'd need IO_WQ_WORK_MM I think for the async part of it,
if we need to block.

Various style issues in here too, like lines that are too long and
function braces need to go on a new line (and no braces for single
lines). If you want to move further with this, also split it into two
patches. The first should do the abstraction needed for splice.[ch] and
the second should be the io_uring change.

-- 
Jens Axboe

