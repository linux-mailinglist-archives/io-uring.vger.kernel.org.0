Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8844314F8D0
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 17:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgBAQWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 11:22:48 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36675 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 11:22:48 -0500
Received: by mail-pf1-f193.google.com with SMTP id 185so5101966pfv.3
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 08:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LjZGc3GpXKgh0Fpg4TWhP09d0kLnJRFrxHAI23jbET8=;
        b=WznZtWJCMDQYYS6poHS9yUqttdgqJMbaEJycKD/MywGA96ApeoxesQkpo2Usqcg1Fu
         l672V2aWezxCuptvVNy0fVWmqgkzT/0V7zzLMm2vYLqW7tUZwzwr+Z+Uims/i93LD38v
         TFMiMbf1+zyK3m5s0FpnPKOQPifHEbCGt63jTN6MsQX2yCU2pkiAOR4HJjSET3T3H0LC
         6BPIZrgnm/QFjbcQ6LuHZnkHtZPBTFA0I73uST+sY/KI2wd2b2WPK+66S1eDcPRidv9F
         oYaJATLFDKzXIayrmwY8NF7fHbbKSXO9HTf4nNjQxvjOnDyxuJFM+XFTkkfIaBT5qLfd
         66Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LjZGc3GpXKgh0Fpg4TWhP09d0kLnJRFrxHAI23jbET8=;
        b=ETFcMiqUKge0upxCpdrvfkIGd59cpQTvGGGsmBBXXKHLdsNkY5T6eDSdCwSoSCwADh
         vRZefeOeGD5UYinLQXQR2Do/d8GQQt4ptEhCbrbkMtOnEJ7/DCiHek4dCLZsJ9s9WNdW
         FtdF7JmGhjiWdSemiypKZ5uGX6znVvrDzVwZhcT8ZGYHlHjDR5J0dYLjrcHX0505eM7y
         09iwQZWUhF2MlUMEDjhB3B8TlrmqG1ff8lb312aWC3TXPazjfSRvIbxWDv6ETphPXhAE
         U4LaNx4WS3uFVQvtUXhQZjeN5JaKdV/t7KcOOj5tCY2qL9JS9EvNXZRy40qyQDd0K5VJ
         vcKw==
X-Gm-Message-State: APjAAAUNiYxoW3IUoIknwrH/qSBSimh7TBnBpWK0Qun2D74+lk2BMHGL
        oHfe41T6WlYftzsxMKotksvDEDXu2so=
X-Google-Smtp-Source: APXvYqxKkcsG9kae9V9BqrQLaC/Vyivx2CRCcsviQqvbTHPQ7FuNdsLerepdErr6IS/L8jdMq68oRA==
X-Received: by 2002:a63:450:: with SMTP id 77mr16384845pge.290.1580574167737;
        Sat, 01 Feb 2020 08:22:47 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id f81sm13800057pfa.118.2020.02.01.08.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 08:22:47 -0800 (PST)
Subject: Re: io_uring force_nonblock vs POSIX_FADV_WILLNEED
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fab2fcb4-9fc2-e7db-b881-80c42f21e4bf@kernel.dk>
Date:   Sat, 1 Feb 2020 09:22:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201094309.6si5dllxo4i25f4u@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/20 2:43 AM, Andres Freund wrote:
> Hi
> 
> Currently io_uring executes fadvise in submission context except for
> DONTNEED:
> 
> static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
> 		      bool force_nonblock)
> {
> ...
> 	/* DONTNEED may block, others _should_ not */
> 	if (fa->advice == POSIX_FADV_DONTNEED && force_nonblock)
> 		return -EAGAIN;
> 
> which makes sense for POSIX_FADV_{NORMAL, RANDOM, WILLNEED}, but doesn't
> seem like it's true for POSIX_FADV_WILLNEED?
> 
> As far as I can tell POSIX_FADV_WILLNEED synchronously starts readahead,
> including page allocation etc, which of course might trigger quite
> blocking. The fs also quite possibly needs to read metadata.
> 
> 
> Seems like either WILLNEED would have to always be deferred, or
> force_page_cache_readahead, __do_page_cache_readahead would etc need to
> be wired up to know not to block. Including returning EAGAIN, despite
> force_page_cache_readahead and generic_readahead() intentially ignoring
> return values / errors.
> 
> I guess it's also possible to just add a separate precheck that looks
> whether there's any IO needing to be done for the range. That could
> potentially also be used to make DONTNEED nonblocking in case everything
> is clean already, which seems like it could be nice. But that seems
> weird modularity wise.

Good point, we can block on the read-ahead. Which is counter intuitive,
but true.

I'll queue up the below for now, better safe than sorry.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb5c5b3e23f4..1464e4c9b04c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2728,8 +2728,7 @@ static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	struct io_fadvise *fa = &req->fadvise;
 	int ret;
 
-	/* DONTNEED may block, others _should_ not */
-	if (fa->advice == POSIX_FADV_DONTNEED && force_nonblock)
+	if (force_nonblock)
 		return -EAGAIN;
 
 	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);

-- 
Jens Axboe

