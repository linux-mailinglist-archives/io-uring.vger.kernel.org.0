Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557A3B02E4
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 13:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFVLjU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 07:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFVLjS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 07:39:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2301DC061574;
        Tue, 22 Jun 2021 04:37:02 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id my49so33928853ejc.7;
        Tue, 22 Jun 2021 04:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LUy/wicadv4c1bqugvMFAWXLLPAGryucoosC9VkaNiA=;
        b=luviOIIG3VBAxj6wenGVE05nHSbqNjx8AboHEUVqKOQ4oLLLukj1XCq0YLauG3bdq9
         JcQRRIZWiloXOvGNFQZMoXWsntYqEtL+ShANN35K+3n8rYOZOKNFUJtAqxPeRA7vAN0D
         ag6yI6hy9zlfPUTJNjy2rfpQpK9lWFg+yWKCsUl8L+lTF6506S38MLJZv0jqQfIpk9MS
         XTrFBTiopdsm04PEhYUqzZ3LteCUCSUqm+JbwMT6JiFvdmBp0wQ5AERt/+1b8WMz5m5N
         o63uE/+mq5hRSdI8oeI1Bx0yz2dJlILSAx/okncs7BY6yhWDi7o0xqFJ6fuRKxjHt2xY
         1MHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LUy/wicadv4c1bqugvMFAWXLLPAGryucoosC9VkaNiA=;
        b=TigSsVEiGgGcRSnnNGMlESTQft2k+m4Lyrpat8k6iYhsloUCIY0diC64hDcyYh4u3S
         ziuqAjAPNjTQWxXOQ4AbSVbwvb8aWVXMKkHXLBfFLPS3W0GQIN5VXEOuwq4r7EzHqQW5
         CHcTUHKl6B8Iy3bPZ4Wf1LOqilMZmWZD/B6yARseydP2Y2liU1TZBHvk63d4MGxdjEgO
         Da//X6ImeDW/4TY/xz2KV1LMNN6JIYXLoPj7vfKJudBi2wUHcRkjk8cenjyhFUTXJyMw
         ZRtd2LDuyH0XFbdY8acUgZq+y8SUQ+2jsMPqLzU18JDkSTnSsP4xaYUFe901rlnk7vWA
         Er1A==
X-Gm-Message-State: AOAM5319NaOJz+PBapfPjjncSqeWyR2Dsx1k3bQF9bGuR7j4npvcyhfZ
        KPgHXpUpVW/NI0l7LKXXn4rhA6WXpITqulya
X-Google-Smtp-Source: ABdhPJzQ2hG+so2QJnW2x7mgDOhQx+IgBMISK36X1YPbixJqm7cVEn5DV2J6myl0QwXR2eSYnORieQ==
X-Received: by 2002:a17:906:bc2:: with SMTP id y2mr3489518ejg.489.1624361820587;
        Tue, 22 Jun 2021 04:37:00 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:e69])
        by smtp.gmail.com with ESMTPSA id t6sm380762edd.3.2021.06.22.04.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 04:37:00 -0700 (PDT)
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-9-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v5 08/10] io_uring: add support for IORING_OP_SYMLINKAT
Message-ID: <14ace9c7-176f-8234-152b-540ea55f695a@gmail.com>
Date:   Tue, 22 Jun 2021 12:36:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603051836.2614535-9-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> IORING_OP_SYMLINKAT behaves like symlinkat(2) and takes the same flags
> and arguments.
> 
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/internal.h                 |  1 +
>  fs/io_uring.c                 | 64 ++++++++++++++++++++++++++++++++++-
>  fs/namei.c                    |  3 +-
>  include/uapi/linux/io_uring.h |  1 +
>  4 files changed, 66 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 207a455e32d3..3b3954214385 100644

[...]

>  
>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -3572,7 +3581,51 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
>  
>  	req->flags &= ~REQ_F_NEED_CLEANUP;
>  	if (ret < 0)
> -		req_set_fail_links(req);
> +		req_set_fail(req);

This means one of the previous patches doesn't compile. Let's fix it.

> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +

-- 
Pavel Begunkov
