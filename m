Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F5B16AA50
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgBXPkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:40:20 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:36458 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgBXPkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:40:19 -0500
Received: by mail-il1-f172.google.com with SMTP id b15so8074497iln.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wuiRm3dlZDYmqIzDbSqbu8ztLA8qqLEjKOJX0npg6Z0=;
        b=VoBPxfSzvKMI7SAmvxye8QVZYnf5E9H5jTswzO7uldYjr/71r1jyWlDDbv/nNvzqZ+
         8dvdiSmQ+3noJLhpifPCf4o0qLW/BEbWrjjh/Y2SAXRixcZyTfPprHNPysmIMmA0AGdV
         Hn0ZzF4fAPyd8H2UMOE1I2QYCo8GqWHV40IIcv4W2riGXXqgpHOQCRGXFXHdV++VXqpe
         kuVRj7lCKyW27cBuG970eZ0Ut/vM/2f7B4ZuHF41g4yASx/pAR4d2Edk0B0y6StG1Jvu
         hjHy4dxPPZ3inkPIYW5aAiMbPncakDajXcFNwMA0iyCi+M0pBpHGnFIndgoDyIpwNgHJ
         6GYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuiRm3dlZDYmqIzDbSqbu8ztLA8qqLEjKOJX0npg6Z0=;
        b=AGZNo+6x7000eV1orVw3x8Po6DZ/OIhd7WX65PQYZlcRu4mOzHmfs2fYcZC0Bmd4gS
         NYhRbOodPsa9IsMolvhrvWlaGPEIkTpLUU5XmEyVG4wqX+rKgmEETonpbHgMcMOz+vPA
         O1u6Toz1PhK0BsWiXKfjb7XibfpsdaaQdkKdSy0tK2bjhihq2UapiyGzon3RFFETYKC6
         b0hxhr2DCV02ANgKuEbT3CaGtE/MYqfz0KpteXwJdD83OWMofZ6YkL/i3mnEivJWIx4e
         iKY6wWDoVDudta0XX2di+pQMoyx2C5PNB9Cv6fgA8WlVpXLrxArb+Rash2oQkt4m6UXj
         w0sg==
X-Gm-Message-State: APjAAAXy5gC2yatU+q5Jks+d/t66xNvmEQlNRQ2FzHGxjA6hf/atBpVD
        ilqUd9hJ5CGGsFm5EQucsWPCpAi0GQU=
X-Google-Smtp-Source: APXvYqwvYmtRwgv9UtAid+t4WqFEBgwzgKKbgglSmvJTnJnjXtFXW1WIokxSX4T52yVUWqGANf8IOA==
X-Received: by 2002:a92:50a:: with SMTP id q10mr62475170ile.294.1582558818451;
        Mon, 24 Feb 2020 07:40:18 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u11sm3108044ioc.4.2020.02.24.07.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:40:18 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
Date:   Mon, 24 Feb 2020 08:40:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 12:12 AM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-23 20:52:26 -0700, Jens Axboe wrote:
>> The fast case is not being deferred, that's by far the common (and hot)
>> case, which means io_issue() is called with sqe != NULL. My worry is
>> that by moving it into a prep helper, the compiler isn't smart enough to
>> not make that basically two switches.
> 
> I'm not sure that benefit of a single switch isn't offset by the lower
> code density due to the additional per-opcode branches.  Not inlining
> the prepare function results in:
> 
> $ size fs/io_uring.o fs/io_uring.before.o
>    text	   data	    bss	    dec	    hex	filename
>   75383	   8237	      8	  83628	  146ac	fs/io_uring.o
>   76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
> 
> symbol size
> -io_close_prep 0000000000000066
> -io_connect_prep 0000000000000051
> -io_epoll_ctl_prep 0000000000000051
> -io_issue_sqe 0000000000001101
> +io_issue_sqe 0000000000000de9
> -io_openat2_prep 00000000000000ed
> -io_openat_prep 0000000000000089
> -io_poll_add_prep 0000000000000056
> -io_prep_fsync 0000000000000053
> -io_prep_sfr 000000000000004e
> -io_read_prep 00000000000000ca
> -io_recvmsg_prep 0000000000000079
> -io_req_defer_prep 000000000000058e
> +io_req_defer_prep 0000000000000160
> +io_req_prep 0000000000000d26
> -io_sendmsg_prep 000000000000006b
> -io_statx_prep 00000000000000ed
> -io_write_prep 00000000000000cd
> 
> 
> 
>> Feel free to prove me wrong, I'd love to reduce it ;-)
> 
> With a bit of handholding the compiler can deduplicate the switches. It
> can't recognize on its own that req->opcode can't change between the
> switch for prep and issue. Can be solved by moving the opcode into a
> temporary variable. Also needs an inline for io_req_prep (not surpring,
> it's a bit large).
> 
> That results in a bit bigger code. That's partially because of more
> inlining:
>    text	   data	    bss	    dec	    hex	filename
>   78291	   8237	      8	  86536	  15208	fs/io_uring.o
>   76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
> 
> symbol size
> +get_order 0000000000000015
> -io_close_prep 0000000000000066
> -io_connect_prep 0000000000000051
> -io_epoll_ctl_prep 0000000000000051
> -io_issue_sqe 0000000000001101
> +io_issue_sqe 00000000000018fa
> -io_openat2_prep 00000000000000ed
> -io_openat_prep 0000000000000089
> -io_poll_add_prep 0000000000000056
> -io_prep_fsync 0000000000000053
> -io_prep_sfr 000000000000004e
> -io_read_prep 00000000000000ca
> -io_recvmsg_prep 0000000000000079
> -io_req_defer_prep 000000000000058e
> +io_req_defer_prep 0000000000000f12
> -io_sendmsg_prep 000000000000006b
> -io_statx_prep 00000000000000ed
> -io_write_prep 00000000000000cd
> 
> 
> There's still some unnecessary branching on force_nonblocking. The
> second patch just separates the cases needing force_nonblocking
> out. Probably not quite the right structure.
> 
> 
> Oddly enough gcc decides that io_queue_async_work() wouldn't be inlined
> anymore after that. I'm quite doubtful it's a good candidate anyway?
> Seems mighty complex, and not likely to win much. That's a noticable
> win:
>    text	   data	    bss	    dec	    hex	filename
>   72857	   8141	      8	  81006	  13c6e	fs/io_uring.o
>   76959	   8237	      8	  85204	  14cd4	fs/io_uring.before.o
> --- /tmp/before.txt	2020-02-23 21:00:16.316753022 -0800
> +++ /tmp/after.txt	2020-02-23 23:10:44.979496728 -0800
> -io_commit_cqring 00000000000003ef
> +io_commit_cqring 000000000000012c
> +io_free_req 000000000000005e
> -io_free_req 00000000000002ed
> -io_issue_sqe 0000000000001101
> +io_issue_sqe 0000000000000e86
> -io_poll_remove_one 0000000000000308
> +io_poll_remove_one 0000000000000074
> -io_poll_wake 0000000000000498
> +io_poll_wake 000000000000021c
> +io_queue_async_work 00000000000002a0
> -io_queue_sqe 00000000000008cc
> +io_queue_sqe 0000000000000391

That's OK, it's slow path, I'd prefer it not to be inlined.

> Not quite sure what the policy is with attaching POC patches? Also send
> as separate emails?

Fine like this, though easier if you inline the patches so it's easier
to comment on them.

Agree that the first patch looks fine, though I don't quite see why
you want to pass in opcode as a separate argument as it's always
req->opcode. Seeing it separate makes me a bit nervous, thinking that
someone is reading it again from the sqe, or maybe not passing in
the right opcode for the given request. So that seems fragile and it
should go away.

-- 
Jens Axboe

