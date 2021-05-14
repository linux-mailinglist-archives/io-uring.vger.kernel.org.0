Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998A3380C16
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhENOn5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhENOn5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 10:43:57 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25221C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:42:45 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id v13so25973552ilj.8
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1J5nvIlm2YmJXTbs2T2WFMcjzj/1gQ9gJoH7SCspHU0=;
        b=BipTdk+P1R1W+Sj3wQY2gJrkVlDg5t+Ng6ddzMXLnkYci9cHBGhNSB2KkbbDAfKIkN
         dWpVLy7zKPP6M9+GXqbK/zxPK5BbFQ+/TxqCSVbEL9k9wq8ROhYaisTQfqPihGNGwoDm
         fWZ5PDZqXfwja4emmkkcxQrblDJ6CpRwdDYdK8xCriuI9mj6miBOb2bsPw7BN5Wvik6F
         qGKQLY/9j6uQ1xOgzzrvA4qsSsngioFscojrAWguc6uweOAd73UMMEyQbXMkX5cbO50X
         v3B+XzyjEIA8B0/aulajb7BREK6r0dC/6dzDyjjnrr68HtslxS46Ay1qsw2qSV/x4Doc
         mxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1J5nvIlm2YmJXTbs2T2WFMcjzj/1gQ9gJoH7SCspHU0=;
        b=eLTncB8eeeElSsFAMxoedkhffuq5OFsBE9JH1BIUat6U6Re3YX8+2gwx0tUZ7zJhTx
         mzPo24txv53cydQcZ8f7rrjHgdiTZI63uS4qdg1DshcR7IekFXiKaSinUHZ2rNgx73yN
         eNbHmNUJqZ94ixwvTVzF/KulfeztbkW1Un12LGisaQv6LpX0B8auooojOBnAir/z7ytD
         9LkkQl5Eq7NbYq/VL+qjq2oiI2DsU1RvDA+vCxGnl4kqWxj38fB5WtaZrBxtq7PlxHVx
         EdXkkP7+ye1Shlr8T7EVly809FPJgQofoUaXhB55i/fIi6RljlK1Vfwqz0htemBfNSex
         nMCw==
X-Gm-Message-State: AOAM532UbniSpSgeOt8jk3SeOwp4HePIHNbwYLPEPnFiO8QZr/Zv90H6
        2O0i3HoJv7secukf0TUfFX7IQcHUvzCA+Q==
X-Google-Smtp-Source: ABdhPJyv9+5e1/KFsb6DzEuNZgT3zoU5t02Op5NB9KzKLzlc+wmqPMqbv+zqFoMDwc3qAFFCLc+I6A==
X-Received: by 2002:a05:6e02:19ce:: with SMTP id r14mr41899009ill.4.1621003364299;
        Fri, 14 May 2021 07:42:44 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b8sm525592ilj.39.2021.05.14.07.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:42:43 -0700 (PDT)
Subject: Re: [PATCH] io_uring: increase max number of reg buffers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d3dee1da37f46da416aa96a16bf9e5094e10584d.1620990371.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e5a87242-fc97-3c1b-24ab-c6f01f1032f5@kernel.dk>
Date:   Fri, 14 May 2021 08:42:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d3dee1da37f46da416aa96a16bf9e5094e10584d.1620990371.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/21 5:06 AM, Pavel Begunkov wrote:
> Since recent changes instead of storing a large array of struct
> io_mapped_ubuf, we store pointers to them, that is 4 times slimmer and
> we should not to so worry about restricting max number of registererd
> buffer slots, increase the limit 4 times.

Is this going to fall within the max kmalloc size?

-- 
Jens Axboe

