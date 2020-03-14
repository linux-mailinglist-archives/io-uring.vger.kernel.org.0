Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485C61857AE
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2020 02:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCOBpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Mar 2020 21:45:54 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:39834 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgCOBpx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Mar 2020 21:45:53 -0400
Received: by mail-qv1-f65.google.com with SMTP id v38so2869024qvf.6
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2020 18:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/+9Q8TJ7jtUHpxRJyGUZ1bL86SBe7tVjOmhbbOA4p4w=;
        b=SG5VD3z4MI8OduY4+2c3wYVTGDxZx6rfjOy9JvWLiHNHsY2hQyAoP0lwTCXSev6QbO
         ROubWXIRQkgbTJ2+P2NPwnxQAY5jSgsq9oNiRl6qOQO/u3mz/NKMzUiyFaxap0XDRYb6
         7OU8qGPjTqzxy+OwjkGyUlU9h6kWIB3H7s8mEMK/rPlLR51mo5OWHJs74cop8QLPfT/M
         8G+6wBz5Rvc2qvVTMnuPdBquQbW9CwJksbbU/Kqx3lyrrMq9BBBbh9BTuD7+eOTroTsM
         M/+Hlfot730nD9afcqDOp6rhHNZPe9QxozAI2p3v21Lkcu5LrtghZVuXsyC9Qd5P97o3
         0bNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/+9Q8TJ7jtUHpxRJyGUZ1bL86SBe7tVjOmhbbOA4p4w=;
        b=GY0QJL+O4KybLO99paPgQHHfgxuzcBMz/NT+i0P0YL+qDH2b1lwNwukN/9c/ZyAt5d
         eJbp4u3Z4+QTBzjkwIn+3ToPt7+RtGIaz8nwuTuBl2lPy7R7lCSDa1jciHiNJZoxvZOp
         mAgkLuYYZRTx+Cifm+LkB5ggYayR2PK4cq9IfYyHZVXFl2rsiyfcv9I5412UxcDCDV2J
         fwmSeC4Ok7FvoumbqpLCSKS4SmQczoHrj7ncLWy8Q5ilwVg/0LgJFhornrLo9g9uA9/I
         TpjSTNRSOts6F+poab4B0DN63LNhapRwXWL8LDG2XoHvVqW/ygbHaDEM96fYJ1nJ89Vd
         Q8ig==
X-Gm-Message-State: ANhLgQ1ZTSns/hJaIlqKsv+zmIP4mOO4dkFEpUxYe7+S/oyhO5X33Obc
        MKZGzNqokDIloyFVzmAIKsU5YUk/q5IrRQ==
X-Google-Smtp-Source: ADFU+vtUob9/wk2Xo5IPPKPI0Pio7lMK+3XwsB2YuJ0xrn4KtFRW2bv81Vj2/I2bo284+Z7N4zVwcw==
X-Received: by 2002:aa7:8b03:: with SMTP id f3mr20486548pfd.133.1584201520387;
        Sat, 14 Mar 2020 08:58:40 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n7sm3779560pgm.28.2020.03.14.08.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 08:58:39 -0700 (PDT)
Subject: Re: [PATCH 5.6] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <62bc8817-5777-7f79-3c27-028a770e2f3b@kernel.dk>
Date:   Sat, 14 Mar 2020 09:58:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/20 1:29 PM, Pavel Begunkov wrote:
> Processing links, io_submit_sqe() prepares requests, drops sqes, and
> passes them with sqe=NULL to io_queue_sqe(). There IOSQE_DRAIN and/or
> IOSQE_ASYNC requests will go through the same prep, which doesn't expect
> sqe=NULL and fail with NULL pointer deference.
> 
> Always do full prepare including io_alloc_async_ctx() for linked
> requests, and then it can skip the second preparation.

Thanks, applied.

-- 
Jens Axboe

