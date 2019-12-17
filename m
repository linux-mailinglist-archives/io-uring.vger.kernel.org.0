Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8913E123486
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLQSPI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:15:08 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33839 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQSPI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:15:08 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so8548937iof.1
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 10:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IYOnLbjfqVUNsL9yjx7UYabtfGTPEkQFBGBcs9P+PFo=;
        b=V5YOZEqc+LhElvEJ1CLgoSXyp3KFjFgplAFSkTwhxdmbyvyi2unBcPZnUHzXECY02j
         2xbAzAjlqS6i4GbgIl05Z/ZLoJ3wkST3LAFwkhbwsCAIjmGKPF9e6hXAGhsngf4sZFqJ
         yZHAvWptuceonSa7i+3DvsSy3QS/u7bdlbO/5mJQaWldTtES7rWjeJw65eXGWCH1ccaa
         +jcLrT3da6hhhd10pVXq/hLTQEOZ1pzXbPy+1KR07NUH0DltJfVFOlbjr696hMqTk452
         uvjXxI5loCArOFnVjOg3xYfDpKd1RJAmsduClO4HeSM1udj2lrt7xXbr5Dx9PbIJhhJI
         nN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IYOnLbjfqVUNsL9yjx7UYabtfGTPEkQFBGBcs9P+PFo=;
        b=EGyJBfMt/boc5GUeW0lRkzuJZM7/KS0IZjA8NheCHK+7R0CgjJd0EOuMwW/k+eXG0v
         njxRxECikhYgvvFqHDuumKhujd8zZCrCA36O9apJyW1nchge7b+0gTazSVMTaLzmqSb0
         YL22xcgN2g84RQAslcrjaf+J4i0wIZrUmobZUueKuxN1J2dl2vG3KKFQWkMT0p/CMNgY
         RgTlchMnLx3PfYKi5b6Faeq4s/e9cUWQiG8gw2ZkfzTZaxOdQHqY970GUiQayZkGDTbA
         oWkMSmi3puG92UlSwk0Ams4t+jCe5hy/3bfYoZ91DTQ+B0iKNZwbmtP7mteJwymlWYyG
         p/Og==
X-Gm-Message-State: APjAAAWWuqhJh3AmSKkRYlCVpWcD7CBljLefi6Rtl4xMAIERQERedfVd
        RV9MSP6MakEnqfbZn7ENG8cHkA==
X-Google-Smtp-Source: APXvYqzRdxUbXr5Cz+thENMP2uqMCy/0gAwaYW5gt5+I4SIh3kmHveNNlhjJOPQjxHwCYv3KDFofxA==
X-Received: by 2002:a6b:b606:: with SMTP id g6mr5066154iof.114.1576606507861;
        Tue, 17 Dec 2019 10:15:07 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n20sm5320406ioj.83.2019.12.17.10.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:15:07 -0800 (PST)
Subject: Re: [PATCH 0/3] io_uring: submission path cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de7f6412-c031-1a0b-faa1-45e210ce5274@kernel.dk>
Date:   Tue, 17 Dec 2019 11:15:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cover.1576538176.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/19 4:22 PM, Pavel Begunkov wrote:
> Pretty straighforward cleanups. The last patch saves the exact behaviour,
> but do link enqueuing from a more suitable place.
> 
> Pavel Begunkov (3):
>   io_uring: rename prev to head
>   io_uring: move trace_submit_sqe into submit_sqe
>   io_uring: move *queue_link_head() from common path
> 
>  fs/io_uring.c | 47 +++++++++++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 26 deletions(-)

Can you respin this on top of the hardlink patch?

-- 
Jens Axboe

