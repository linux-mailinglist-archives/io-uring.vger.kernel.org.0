Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F55174E66
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCAQYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:24:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44601 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgCAQYC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:24:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id n7so1504606wrt.11;
        Sun, 01 Mar 2020 08:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aQNmJtnJXUdOZ5WP+6T2LhMyumwJevaLkPnO98h9yHA=;
        b=YWk86eVqQaKhmsRxJRXQRhInrV5Ux6ehMNjIZTv9go70h47TctNgBesFMI2qEfm/Pq
         gpbyJxdFj7Tgls/Mm0k3YZQaRv9jQD399/c6ld5oPxgDRH/aG3eoF59EWoZ4A5+NxGQk
         LtNgbo6N+KbgUYu1KZpUxKQVRUJPA4ghwYmBP6tCRRO8+NXek8ol8y3YSWz7aaDh1DEp
         Zu8vIafKIF6amGu6udehdAQ4T0cHzWvShQ+xnzgIxwR1zx2qKoK2inY1CKucGYKFpj8Z
         BqIzIhV5dlu2L+vmCSzfM645Y4XwG51Qx9PVSTuzSt+stTZaVgXdgZU2e6aXnZtwPg6w
         43nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aQNmJtnJXUdOZ5WP+6T2LhMyumwJevaLkPnO98h9yHA=;
        b=pi0dBEhEqlN3Qwju+ScTy367W2KgErjpqWSQuKABq78jZByJHmfZCeCaEeaaGfxtzq
         mdVIqFCLV7jwORZLffyGYnJ+zxaO29xX8QP2fp+3iR/FLX0lAbYs+LyFLz6A4dy439F+
         u7WxiQ7zQmZR5TXqhqJOjTKWg0qyvPc1aNLLVuIWyGcAijVhaXzBufKUbmggfCA7IFlY
         giaEXbK4YnBelz3iGMT6saM/SvupprzxEIkLZGS8sol2uFPNZP0AK5OpUc/dDyxiHq+w
         QQa4LpsVmcjJPiOfx8RGlvo7xVj4H/MTnZHs6qqIVqoZrvFtpolNFSBWjKstsAzM41D/
         8xIw==
X-Gm-Message-State: APjAAAXhWTn09wDcqfdPv+FSSF0mInpR5jTo9rCImoKHS/FrcPL2Yi2p
        uIilCJUc0XsipvU9Vgl1nBZD4k9e
X-Google-Smtp-Source: APXvYqwl85K9W7vCtZ0ns8VWbV8zz2soEcc0P5qtb9jvqnlN1zPEqJRSLA0WfB1/HLgsKi7vye+7Uw==
X-Received: by 2002:adf:ea91:: with SMTP id s17mr16664707wrm.129.1583079840391;
        Sun, 01 Mar 2020 08:24:00 -0800 (PST)
Received: from [192.168.43.139] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id a7sm10616716wmj.12.2020.03.01.08.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 08:24:00 -0800 (PST)
Subject: Re: [PATCH RFC 0/9] nxt propagation + locking optimisation
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <fe4cb05b-2fd0-25dd-e120-9a9d57659008@gmail.com>
Date:   Sun, 1 Mar 2020 19:23:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/03/2020 19:18, Pavel Begunkov wrote:
> There are several independent parts in the patchset, but bundled
> to make a point.
> 1-2: random stuff, that implicitly used later.
> 3-5: restore @nxt propagation
> 6-8: optimise locking in io_worker_handle_work()
> 9: optimise io_uring refcounting
> 
> The next propagation bits are done similarly as it was before, but
> - nxt stealing is now at top-level, but not hidden in handlers
> - ensure there is no with REQ_F_DONT_STEAL_NEXT
> 
> [6-8] is the reason to dismiss the previous @nxt propagation appoach,
> I didn't found a good way to do the same. Even though it looked
> clearer and without new flag.
> 
> Performance tested it with link-of-nops + IOSQE_ASYNC:
> 
> link size: 100
> orig:  501 (ns per nop)
> 0-8:   446
> 0-9:   416
> 
> link size: 10
> orig:  826
> 0-8:   776
> 0-9:   756

BTW, that's basically QD1, and with contention for wqe->lock the gap should be
even wider.

> 
> Pavel Begunkov (9):
>   io_uring: clean up io_close
>   io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
>   io_uring: make submission ref putting consistent
>   io_uring: remove @nxt from handlers
>   io_uring: get next req on subm ref drop
>   io-wq: shuffle io_worker_handle_work() code
>   io-wq: io_worker_handle_work() optimise locking
>   io-wq: optimise double lock for io_get_next_work()
>   io_uring: pass submission ref to async
> 
>  fs/io-wq.c    | 162 ++++++++++++----------
>  fs/io_uring.c | 366 ++++++++++++++++++++++----------------------------
>  2 files changed, 258 insertions(+), 270 deletions(-)
> 

-- 
Pavel Begunkov
