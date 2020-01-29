Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77614D332
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 23:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgA2WoN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 17:44:13 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:41742 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgA2WoN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 17:44:13 -0500
Received: by mail-pf1-f176.google.com with SMTP id w62so400682pfw.8
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 14:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WT2Y4/ZPyHi09dPIqBxrwg7+WgI0ztW2g/EuiZYH9EI=;
        b=EuB3yG2Kf1BepNmMw2bC/OYCYsJb4VlvZp07g6VOcWKQOLtBJUQLrvXQ3clKv+Nfvy
         wBHWShg6wYhl5c0tDoakOfZpcX8NJkw/SikdywcZ++9ghBgMbth1mZbF0hmoEUiQTFLh
         mA5wrtVV3oagQdzC58/b47x7BHFVxxb9AhqGmOlRYoBrzAEAt05v+J99kqz6PPx9iW5D
         gCWjSI7h8i84tC48vwU7j6AwWFNii0CDZDOnq+TR+60vp5Ot5Bzadt/26NXKJCJhVaYI
         WxJSS/USGRIaUDsZOCHpj4DSsa2rDPVkWoyAkGFVHgGhS1YutV4Kq2sPetYKZz3Os3n8
         LRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WT2Y4/ZPyHi09dPIqBxrwg7+WgI0ztW2g/EuiZYH9EI=;
        b=lJBCi6ZncD+5V+PrwnmBJQCNAEyf8p4FyuLhhd9QLsBscAOR3cAroqcU2/5huFgu6M
         ERkYMmrgCmST7yQU8c5eZFaDDGRC9vzuXxZW94/palWIclPkufPdwqhG5HlRqJ0yfUIc
         mEYK/5xtern8UHXrdnHl3bBHDN5z5srHeTvcqj5H7BiAoo9Dadbn7dkLH36kQirtEdmF
         F1NhJEvgknXWXGAaPCxhk/jPlmQqL/OijAdivxPSAJKg5g80uGKr0Kl9qRY6/t9LJDIu
         UszsB91hOZX+9SDxICBOqeqqV8+U+ah/7Vnl0xzYmbxQ44/fcRuP7EtK9cWmp79oa+Qz
         1GUQ==
X-Gm-Message-State: APjAAAWTAj7YJ4cdVgy+U/FrAbjHA6psQhQp5Mj5BeoDt7kcJ/FhJjtN
        0prWWJS/mfQlEnh4qXea3jfYEnpAN9I=
X-Google-Smtp-Source: APXvYqwzqgUwRounVhBnXy1semsmxzLpNy0FbbGA2Gfy2iNCduU7n/p/7h2/31aYJ9ag2L6JkprAjA==
X-Received: by 2002:a63:7843:: with SMTP id t64mr1444820pgc.144.1580337852327;
        Wed, 29 Jan 2020 14:44:12 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1132::1286? ([2620:10d:c090:180::9910])
        by smtp.gmail.com with ESMTPSA id j14sm3761201pgs.57.2020.01.29.14.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 14:44:11 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix linked command file table usage
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
Date:   Wed, 29 Jan 2020 15:44:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 3:37 PM, Pavel Begunkov wrote:
> FYI, for-next
> 
> fs/io_uring.c: In function ‘io_epoll_ctl’:
> fs/io_uring.c:2661:22: error: ‘IO_WQ_WORK_NEEDS_FILES’ undeclared (first use in
> this function)
>  2661 |   req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
>       |                      ^~~~~~~~~~~~~~~~~~~~~~
> fs/io_uring.c:2661:22: note: each undeclared identifier is reported only once
> for each function it appears in
> make[1]: *** [scripts/Makefile.build:266: fs/io_uring.o] Error 1
> make: *** [Makefile:1693: fs] Error 2

Oops thanks, forgot that the epoll bits aren't in the 5.6 main branch
yet, but they are in for-next. I'll fix it up there, thanks.

-- 
Jens Axboe

