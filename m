Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A80123882
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfLQVP7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 16:15:59 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46625 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfLQVP7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 16:15:59 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so12264319ioi.13
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 13:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xbAkSu6f1FSOslLya3pTTccEqoCnU4AjqEM/vMBrMyE=;
        b=TLNJgIMJynuhiwVr1/XlYoykNt9D99M2LRmTmoeZKuT+fGTHSBOtQvEQGBrSY93YWe
         LENtrKEX67EIvXBHGclFKGlMv8momP86nTJXhudBEVQTN0TiWYbk2d61WmLcUkW3TrbJ
         uTDgcP0yPb3hDGhgWyCmOl1OCG4ZO3vfEnkDXjRkip3m11glDIrL18JiDBC65w2HV7rP
         cnkQCIdZqFAOJT4/9c4EWzmBKgpdOBAvfT4/PfxFFQzBL4tLba8VNikgBcbt+zx4RxK+
         1VYXvawDr+4td1qvdPZaaH1Az2jhug0IhWNu1s5g4hxnWB2/19ptSJEurfcm2NBTotVY
         /NEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xbAkSu6f1FSOslLya3pTTccEqoCnU4AjqEM/vMBrMyE=;
        b=T7+JSVp9BN8h0L/kmHt0TFKteJMz0T0zuBTMlmp/QhJVJtKASv1ZPMdwGGLaI9VsZi
         rqiycuuWWYNr98FOV45504YdWlMAnHIZrtVevpZOfheBMOr6bGYBKOe6Ur1nmM/+BzwK
         R50OccVBIsu4N2C/y/yTjukze8Uxs5SEYI5MY7Ih/nu/b+qdRRJd/06VKuq2bLebiZsK
         vBm6d4/XFdCP7Q3gxUVNwgBUJ0LYat7ed4tuEnqZy16Ups50i+/8RjbO/YRQffnEX/Yu
         jJCIvaV4SO5EOc0x4dFE9rMf8Ja1XOwQ8KJ8xPm1W4HMHdJEpy9yd51Mf9lUQY4BDdFt
         9w6g==
X-Gm-Message-State: APjAAAU0k4fPo+KI6/32m0UrBFzC3bhK8ezALGSKAY1t8H8QpdNjQtiK
        U8EKaFBI/Sp55CTMPI5aU38C6Q==
X-Google-Smtp-Source: APXvYqy0MlEoUx4H8cdLwfMVyi9Q6OhXqJUbWIVNTr7vmIKTkHeZfPGz32+NaXqhNDofDU6EhUxOHg==
X-Received: by 2002:a05:6602:101:: with SMTP id s1mr5431540iot.262.1576617358453;
        Tue, 17 Dec 2019 13:15:58 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o70sm1421442ilb.8.2019.12.17.13.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 13:15:58 -0800 (PST)
Subject: Re: [PATCH v2 0/3] io_uring: submission path cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <cover.1576610536.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a81b3a8f-562c-02f4-522e-9c2dd51e33f8@kernel.dk>
Date:   Tue, 17 Dec 2019 14:15:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cover.1576610536.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 12:26 PM, Pavel Begunkov wrote:
> Pretty straighforward cleanups. The last patch saves the exact behaviour,
> but do link enqueuing from a more suitable place.
> 
> v2: rebase
> 
> Pavel Begunkov (3):
>   io_uring: rename prev to head
>   io_uring: move trace_submit_sqe into submit_sqe
>   io_uring: move *queue_link_head() from common path
> 
>  fs/io_uring.c | 47 +++++++++++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 26 deletions(-)

Applied, thanks.

-- 
Jens Axboe

