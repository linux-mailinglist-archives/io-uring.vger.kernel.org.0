Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9130D19E517
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 15:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgDDNIh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 09:08:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36608 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDNIh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 09:08:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id d202so10861012wmd.1;
        Sat, 04 Apr 2020 06:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g0lhfmepuqxhkSzHeSEIiTb4vyevQh1xR17a67PwJQQ=;
        b=dri6mJYtciFG4/ZrwuqQCU7c4IS9vONkv8q4vmhBQEpUdqKGcpRPW/npcbLU1edukx
         yiBxoc3c+BjEFjYpu5MBAEWNGYlm96JrWvx7bgShueCqpuG/I22f565wbJO+P+em0K3W
         6hqruMAWMS6niWUvgYJ1F9Rs6PGC2wzAauiMSE8+L7CHoh9OjsESG7lEhCvEjdZwopB0
         qwRveLIJ9agq47IsCnLHWAoyuREzPAwbygJyAFKVbrZwc+eXe9dnQhIFRUTFJFA2QOYE
         EEk25wlmEpjI7NCUggZJgRo3e8iFbc0QZJDlmNsGXUdAQjzLhLGUQUaQ9fhGkDsweY1/
         oxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=g0lhfmepuqxhkSzHeSEIiTb4vyevQh1xR17a67PwJQQ=;
        b=JwMQ6FSEGHhMHECHT/cib1Uxp1iW+ZaELGsvdVfTtRcq2HkTKeoESu1cSbOg81tNNp
         5Nm0sAkNU5Yj0V97N61MwznFYHSFAGWzuaKagCzw0UiRZpIBi+blOAeq8HBX++bcUCBX
         vSeLfhv0HV9jbuzkw/5/jDLYhxTJDVtyudGXhLM1TUYa5dRD/yW4E4o8TaayWrRa7kOD
         B90mGzSaHnqxidSZEJKnQQ7r+Z+moSaVEtKrKAIc8i1Wp32WLTH2Ho3KgP4gj93JsY2n
         M7rOmF4HTSzukfDp+T+exeZSxeoaT3l+2PX+gb83cH3d/8pDq4tEbbbRaX7UCD3OHxUB
         39mw==
X-Gm-Message-State: AGi0PuaX7OBZFLYyF607iv8U/F0bO77fqWO8NwMmWCxRsUq5JIqbnDRh
        xS+b+chdKLjkYP8dXnA6dAlN1Dl2Wj0=
X-Google-Smtp-Source: APiQypI6hvMZkNwvsVxpYR5i02eTANSRy4tAI7LcYtYqoPJlBQhAQ1XfVNnuj0VEh0Xt5PF6ZJvYNw==
X-Received: by 2002:a1c:9c15:: with SMTP id f21mr13348654wme.18.1586005714207;
        Sat, 04 Apr 2020 06:08:34 -0700 (PDT)
Received: from [192.168.43.88] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id w81sm16009467wmg.19.2020.04.04.06.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2020 06:08:33 -0700 (PDT)
To:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
        amd-gfx@lists.freedesktop.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-usb@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        intel-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Jason Wang <jasowang@redhat.com>
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-6-hch@lst.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [Intel-gfx] [PATCH 5/6] kernel: better document the
 use_mm/unuse_mm API contract
Message-ID: <8c1e6600-bee3-d074-28e6-813a6dbf5fd0@gmail.com>
Date:   Sat, 4 Apr 2020 16:07:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200404094101.672954-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/04/2020 12:41, Christoph Hellwig wrote:
> Switch the function documentation to kerneldoc comments, and add
> WARN_ON_ONCE asserts that the calling thread is a kernel thread and
> does not have ->mm set (or has ->mm set in the case of unuse_mm).
> 
> Also give the functions a kthread_ prefix to better document the
> use case.
> 

io_uring and io-wq bits LGTM.

> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
...
> -/*
> - * unuse_mm
> - *	Reverses the effect of use_mm, i.e. releases the
> - *	specified mm context which was earlier taken on
> - *	by the calling kernel thread
> - *	(Note: this routine is intended to be called only
> - *	from a kernel thread context)
> +/**
> + * kthread_use_mm - reverse the effect of kthread_use_mm()

s/kthread_use_mm/kthread_unuse_mm/
for the first one

> + * @mm: address space to operate on
>   */
> -void unuse_mm(struct mm_struct *mm)
> +void kthread_unuse_mm(struct mm_struct *mm)
>  {

-- 
Pavel Begunkov
