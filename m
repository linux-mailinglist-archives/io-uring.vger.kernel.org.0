Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150ED2EA14A
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 01:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbhAEAGR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 19:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbhAEAGR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 19:06:17 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBA5C061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 16:05:36 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id r4so804677wmh.5
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 16:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XjM6Mswr81AzLxko2MvQOavjYx1AkRRl0f2Xnow0ivw=;
        b=b/9LxtFE+seuvld17zY7eVCbio/epzpKnvXB+wu/HYpBQm0YjW6f0WAJ46Pb39NPjn
         cARVKX+H6yRddFYebQihhaAdpOORZa7sT3eQ9wx7Od84g36G8ipxLmw4RIbtlDD2hzB1
         JXZxfKgd5cqMkNoX4CYI73SGAocPA/wWQ0uLeUJgrW0dGLNzD2ibSkKkAadFCMI0Hyrg
         9VDMSDT4RGQGQP5s+fQpYGqOR/hZVYFiHhipV/P4OCYrtFb4bYAAGX2EI+cBRsk9F9lc
         jv8OMGL624WsyI97NKIGw0by2hjVIT8BdwC4ufVg58iezu1stdWUTYKXCbuBRHdhXjgq
         R0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XjM6Mswr81AzLxko2MvQOavjYx1AkRRl0f2Xnow0ivw=;
        b=YYM6D3rGuHifST9yL1MrwY3GESsl5tbwtnlePp+pdjXG+wRYcfuse61ZgEAhe4igXH
         TVq79xUi2eHLyWntkKoMJeG8Ibrm0UVjm58lvB5w8an1YrNmXeCZnQHixTOZac8w4Xrw
         o3+bVJdAFdTxUUrHok69mTZPVOgOKOfNSK3Y3pjajsxwedEposF3FopAwMiHcolX5hQa
         zOUElPgHbahbYBpVlUbQPBDz8X9+5QgWfCh4EAfZHlDIMGZ8AeOxMhRnFLSrGlxaRoCs
         Oh4O09cJOX/eUW0gYjDZwlA9MQ5hdBthBARRWuuHAZflntWzAsqxcd/niyfifIX9v5Na
         ITng==
X-Gm-Message-State: AOAM533nC9yQtWmeSbgJlDzBdPquEfgnrtihSRaGcAYTh1n1uqf65yzr
        0poW89j8zZBBBEsFVf5qgDDu/9Phm8HK3w==
X-Google-Smtp-Source: ABdhPJxR7+65a65Selc8wgX+fwIixKQ8/dNcELo9sMJIMugfkUdu1fjHaQEuv3x2vlXR5qHUEQx30w==
X-Received: by 2002:a1c:e142:: with SMTP id y63mr804555wmg.28.1609797501314;
        Mon, 04 Jan 2021 13:58:21 -0800 (PST)
Received: from [192.168.8.195] ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id n11sm80772902wra.9.2021.01.04.13.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 13:58:20 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-2-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 01/13] io_uring: modularize io_sqe_buffer_register
Message-ID: <9abd2dbd-94b3-bb50-5160-d565ed2f1e98@gmail.com>
Date:   Mon, 4 Jan 2021 21:54:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1608314848-67329-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 18:07, Bijan Mottahedeh wrote:
> Split io_sqe_buffer_register into two routines:
> 
> - io_sqe_buffer_register() registers a single buffer
> - io_sqe_buffers_register iterates over all user specified buffers

It's a bit worse in terms of extra allocations, but not so hot to be
be a problem, and looks simpler.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Jens, I suggest to take 1,2 while they still apply (3/13 does not).
I'll review others in a meanwhile.
 
-- 
Pavel Begunkov
