Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F990217769
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgGGTAj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 15:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgGGTAj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 15:00:39 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123A0C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 12:00:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v8so44253823iox.2
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RkkcISFNf7oRQ1Yxc9tJMdH+VF9Tc9LwucRhGMsImcQ=;
        b=HsoHT2KCajSWwYjiaQ1JAlVU3vig0v2S9ONeAPndfDyREEarxTj0m/DSh/FfJ0ZGtR
         w6GkJzMdZsUXNXjtv/RQYJJkodTgXtd0Q5hLRKeHeh2GPvEKqdDPWIrokacfGLwk+Pt7
         ut+JyvOj7q2pxw8EDEpH7aRH64MlzSKw/AzYzlbIdzONAqBI545rVt7zAZIkKZQhRxrY
         +0fsRA2IpxuDRlhjg+XevtRDy39Jnc7u03YKRiWj6DDAh9viOns1KYE3ojh1wPXlkEKA
         rZ40b3VxKQg4qA8TeDQNYRQo1gQMS/BuDFscSi98ZP7mW7W85rwmYQl9tffy7+miAqNA
         yC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RkkcISFNf7oRQ1Yxc9tJMdH+VF9Tc9LwucRhGMsImcQ=;
        b=H2PSoEpB+1UAly+sII0vTqzD8rGnEtMAz53QGcyg74Izrjdz8LHT6On+i8Rd41k9Yc
         RLY7FyG3ZvzXuR/YvTmziEY6oN+mBCXrPj0uch2PfbavdsGOPF85PG2LWpcIdJIa8sMa
         IWIou+37xrFKFKIVHpIhJbQQDXgbcWSqQVvjCW4HEJoufmTLm5v+fgP4LQJ7dVWf1dOm
         xxGgeqBIGdEySDGNIf5NWrnYhe5XZ6uPEdwX+2ZJ9I/8oLjFNRcXZMTQHys3IVjPxd+F
         QUzqlQpo8LP/1LP0/f43GDHp5i/OXaNeIdjSFYM3CKs+6bLtyZWTJyuit55iGKNmDjYd
         6M1A==
X-Gm-Message-State: AOAM533tGl6iuU8blS1tp273qmSLC5kUOa6Z09eFCw/bTYInun4X7Ppy
        Tg5C2zrLlwzFssnaS6JokBQMdiqI3iNCSQ==
X-Google-Smtp-Source: ABdhPJwVQXvWa1cOyPmudy4weoaG7uGejheL6ITkk7LpbiZSQIieyFAdVT46kW/Z1vOYPUzrb/3Mfw==
X-Received: by 2002:a05:6602:21c3:: with SMTP id c3mr30887932ioc.93.1594148438249;
        Tue, 07 Jul 2020 12:00:38 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x1sm13313148ilh.29.2020.07.07.12.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 12:00:37 -0700 (PDT)
Subject: Re: [RFC 0/3] reduce CPU usage on exit for IOPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594128832.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <93aa12ef-5648-7824-92a3-145c87404d67@kernel.dk>
Date:   Tue, 7 Jul 2020 13:00:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1594128832.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 7:36 AM, Pavel Begunkov wrote:
> [1,2] are small preps for the future that should change
> nothing functionally.
> 
> [3] helps to reduce CPU usage on exit. We don't care about latency
> and CQEs when io_uring is going away, so checking it every HZ/20
> should be enough
> Please, check the assumptions, because I hope that nobody expects
>  ->iopoll() to do real work but not just completing.

I think it's fine to do it in 1/20th second intervals, if you exit
with pending poll requests.

Hence it looks good to me, I've applied it.

-- 
Jens Axboe

