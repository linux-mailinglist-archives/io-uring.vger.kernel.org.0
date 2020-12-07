Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5712D1518
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgLGPuN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLGPuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:50:13 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB234C06138C
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:49:09 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q3so9240274pgr.3
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kO3CgmTtrWUEJqqEsSuPJd1AxNYj6/l2UahWCzBnw/c=;
        b=AkbVKej2xgok6xbGyEkwjcdBXT5OKFWhAjAilapNPmQFmhnn6LZWyUnByn2XTiJKTS
         S9LwQ8RhIqgZMU7XB0+cVvhpDrORgdzkzZsFrl1lLeK7Hrcv7Bv8ubv2Md6ZHpEQraaY
         afNlME32eIHJEFQ2tv7ktbJNTtBPQpUmexwkH8GiGtlgeguJ/baGkGZYnKS+F42cYgtc
         SyYPo6PXI34bubc83jUQUmlTj+KgCfx2z4dbPSDGOUQ3YU0eSjG4w6RxvyhGouTBh8rw
         eXMQBJRLbIe0xRrqAdS3OjOijNEExiLviM2GuY8j8z7ZdqlKctEF/w82Po93iT77JkJy
         AOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kO3CgmTtrWUEJqqEsSuPJd1AxNYj6/l2UahWCzBnw/c=;
        b=Nl6/7blW65LczN84G9h//sVueY2yVQq9KjJGPFxeEaM3LuYeZqpBh0oKdtzYHgMjUL
         ajdOFWdyH9AavvYy88wWUeVq1Dtk8RQSj6j5d05QDSrDxrB1u1H0qKQ+fwFOP0BkAoiI
         Hy/o8abO9xZhU2nThWE852+LcZLQS/4TxaZAdwBsA3mMo4oYmr5qUTpVSEhLTa/B5nmN
         14gGdJBygvh+E4t2eMemm89X48hyc6kF5I4cgsfDl1nA7cJRot31grbczlZI2wODG+Q5
         Y/e9FXnhA+D3yaMVqycmcCZF4sJ/KQpyflLLz2/z/nvPU8D00mDUT2IW3CmROszdSSTk
         hd8A==
X-Gm-Message-State: AOAM531Cc4ZIICzunevnzZMExJQQwoiClnVa19VjLTiG53ceO+n+AJIm
        lkSD7zTE5w7x1f7PvYaRiUB7mYlVGGmUyQ==
X-Google-Smtp-Source: ABdhPJwtdn/etRKQFZ98T1T6XfW4I1QQu5dmej61SvwTMoTpY91/AAKxTl41YyertmSdGDJWWJL4yw==
X-Received: by 2002:a17:902:7596:b029:da:b7a3:cdd0 with SMTP id j22-20020a1709027596b02900dab7a3cdd0mr16537972pll.14.1607356148975;
        Mon, 07 Dec 2020 07:49:08 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::120d? ([2620:10d:c090:400::5:8d80])
        by smtp.gmail.com with ESMTPSA id y23sm7910000pfc.178.2020.12.07.07.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:49:08 -0800 (PST)
Subject: Re: [PATCH liburing 0/3] test reg buffers more
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1607258973.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <257c247b-42f8-4fab-a7c0-2c4a83277ffd@kernel.dk>
Date:   Mon, 7 Dec 2020 08:49:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1607258973.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/20 5:51 AM, Pavel Begunkov wrote:
> This test registered buffers with non-zero offsets and varying IO
> lengths. The first 2 patches are just cleanups for the 3rd one.
> 
> Pavel Begunkov (3):
>   test/rw: name flags for clearness
>   test/rw: remove not used mixed_fixed flag
>   test/rw: test reg bufs with non-align sizes/offset
> 
>  test/read-write.c | 111 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 82 insertions(+), 29 deletions(-)

Applied, thanks.

-- 
Jens Axboe

