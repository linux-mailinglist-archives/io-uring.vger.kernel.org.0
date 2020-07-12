Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7272021CB50
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgGLU3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 16:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLU3D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 16:29:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4130C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 13:29:03 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u18so5030176pfk.10
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=stbNYleXQ4txoG0KcQUgvBigKjwB2qkHjGqeFiklJVE=;
        b=NlEE+z70XSqw09GfedgK4uxQQtCsKGjwI8NmDyAAgHuLKFHQ2KDN3yWHZ5kOgg+gfj
         g8aKbCr+oJdEqvL8U2tjji4YOerzKXI7E78Bh64ndfYLlY57WIdFf6MYMdrSiSkcd1mq
         0ept1Mfr7C7Im597CSXk/WyysNt2UN1VwJASAGO2yKUdOSLBKUMaKutMLplYJhW9AxP4
         6IPgIyJabI7g1LdA93rcspWrk9wIG4eSHBMwptMI8dPnhi52JthbiB8cEKcvdiHucwpc
         muNcEEjJoX2CO+Zjfclxe4+vZLonN+timjTunLwOYRJZm9tktuTggAUUVjW2W02YHItC
         n1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=stbNYleXQ4txoG0KcQUgvBigKjwB2qkHjGqeFiklJVE=;
        b=cyirNfhf2yzPG3rTRs11gOmnfCytM2ynZU4LS2fdRUjG2U7w07/vXjbQhR/pofxEEX
         zUz1y4vAZpID3ViioXnODtM6U3pxE2LRgR/xlCrhtin1+xlc3q/j6zPq5lbdwr3jb36Z
         17jX0CNZ9+YaY2IizR9k0qS+NKyYxiG02Q/XbnP32AKCobuhhsvsoV6uhCxWCR13+Asd
         shE396IZLdqcez1cGo8ANq1F60c0VjNlK0+A+N7RZR/vlevyZhxXoxp7eZn0QFMjb9r8
         YjkF+GJ9jb8jdTguDh1jXaRaX+dp6a8+OEFBQm1bxNx2KLAczEmvC4tC6XbsOjY3Avxi
         8siQ==
X-Gm-Message-State: AOAM5319K7eMQcTu1N0cNvDSQrWsBW+6jIJozGkZDYsloiPBCx2uvwFb
        KB6Vjc7ArABmijUO21bLhZXlKGhxjlM0dg==
X-Google-Smtp-Source: ABdhPJylSdjOSy/RLPTbw55JDDt+CU56WZqvWhJyWr1n0P1ub5GCjSJ4LhN5Pzw/Ivqj0jSiL0xmig==
X-Received: by 2002:a05:6a00:1490:: with SMTP id v16mr69037853pfu.173.1594585743233;
        Sun, 12 Jul 2020 13:29:03 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g6sm12496371pfr.129.2020.07.12.13.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 13:29:02 -0700 (PDT)
Subject: Re: [PATCH 5.9] io_uring: replace rw->task_work with rq->task_work
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <6cd829a0f19a26aa1c40b06dde74af949e8c68a5.1594574510.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5356a79b-1a65-a8bb-2f21-a416566bad1a@kernel.dk>
Date:   Sun, 12 Jul 2020 14:29:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6cd829a0f19a26aa1c40b06dde74af949e8c68a5.1594574510.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/20 11:42 AM, Pavel Begunkov wrote:
> io_kiocb::task_work was de-unionised, and is not planned to be shared
> back, because it's too useful and commonly used. Hence, instead of
> keeping a separate task_work in struct io_async_rw just reuse
> req->task_work.

This is a good idea, req->task_work is a first class citizen these days.
Unfortunately it doesn't do much good for io_async_ctx, since it's so
huge with the msghdr related bits. It'd be nice to do something about
that too, though not a huge priority as allocating async context is
somewhat of a slow path. Though with the proliferation of task_work,
it's no longer nearly as expensive as it used to be with the async
thread offload. Could be argued to be a full-on fast path these days.

Applied, thanks.

-- 
Jens Axboe

