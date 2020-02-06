Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C3154C6C
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgBFTqx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:46:53 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44736 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbgBFTqx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:46:53 -0500
Received: by mail-il1-f194.google.com with SMTP id s85so6228454ill.11
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y+Qm2vuunUyIwT9FvbEtFr9J6rxqRNsvYMs4i9yZWHg=;
        b=vzy/d/95WWKu7PQDilCrAEJK/+BvYvrlT2fLOpZP6ixvZnvv2a4sXqwjMcXqyIgq9H
         EN9r/goqKuntaVTwMqDOGW/v6visAvmWs/nH3B2kj86dwwBwejEAzE8BMV0zbCC/fDMq
         WzePSNIQa3UtNwtLHdHNDK+ZW3zogJ2MFZl2gewBHH8v6czTPqdl06zFEIOGuypQqzna
         EIvN5c37/4OkK9P5qKqgMa+eAH8ZbCeO9dkeCHayol+DVcLPTpXyLjlsmd+pCfwD1dZK
         XIGD1UzUlidkvTuqtRkCAFubhYr7Ii+rEmULGQ+41K0nesS/AEyRBpqqPQu5P82GYGgZ
         mRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y+Qm2vuunUyIwT9FvbEtFr9J6rxqRNsvYMs4i9yZWHg=;
        b=L58PVVTFeKLMknWeu4vFVfJG2LyJpwGI8+IvDlarSnBIFx5sc6dZJAPEjICLPU9mJb
         tBECazMC7mcOL6qsGl5A65JeruyAdliw67QDB6kJ1+ixKp6i7oZIzDUAn/BtbT893GtG
         /NnJ3ujjODYO/Yeq+J6PTO3s/LgQg/sAk9rdMgML7R7jF5ub/fJNDNiOiep9Fm3kIcva
         N4cZ4s6ACWd4mnY+7+RQM3J5DO+pFtdJpV3XqDiXvFkR6nktdUo/XQkSu/vlxJuHJkow
         WV7m+oiprpYyYTgggrcgCh7iGzTI9WgKTqccgNPzZZv/XJ5tWFTrtQ7HgI9wT3n4TaOz
         5Gow==
X-Gm-Message-State: APjAAAVgCOmfpU2uSBgTSoeQB/bgKhB1VPExxp0ZEGI3ALtFa4S+PQw+
        +BfFZFSnN5NUqJ4PcnH2s6DuWQPR9Z0=
X-Google-Smtp-Source: APXvYqzzT5Uf1j6WWUaNruAkal493BFlesJ6ootrwaINKDDVmguMA5dpYmg8FEKnhKslWtkKlTjDww==
X-Received: by 2002:a92:990b:: with SMTP id p11mr5538668ili.254.1581018412609;
        Thu, 06 Feb 2020 11:46:52 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b12sm255491iln.62.2020.02.06.11.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:46:52 -0800 (PST)
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
 <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <57766a26-866b-3288-dc69-5104de3ac6b6@kernel.dk>
Date:   Thu, 6 Feb 2020 12:46:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 10:33 AM, Stefano Garzarella wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 77f22c3da30f..2769451af89a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6301,7 +6301,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>         if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
>             ctx->rings->sq_ring_entries)
>                 mask |= EPOLLOUT | EPOLLWRNORM;
> -       if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
> +       if (!io_cqring_events(ctx, false))
>                 mask |= EPOLLIN | EPOLLRDNORM;
> 
>         return mask;

Are you going to send this as a proper patch? If so, I think you'll want
to remove the '!' negation for that check.

-- 
Jens Axboe

