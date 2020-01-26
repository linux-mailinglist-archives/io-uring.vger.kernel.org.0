Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1108149B50
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2020 16:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgAZPLt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jan 2020 10:11:49 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:34944 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZPLr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jan 2020 10:11:47 -0500
Received: by mail-lj1-f174.google.com with SMTP id q8so3822807ljb.2
        for <io-uring@vger.kernel.org>; Sun, 26 Jan 2020 07:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hP/aWgXaFw5Bzdx/U83p/bo+HnMeXiUCpHsIdC7JcVQ=;
        b=MY+AtG6S0B7Bvo8FyH5YY/05sFst/HXgGrCB3wMBiF4hfXCjHm5i66BWAS057ae/lu
         tAp4DP1MP1aHjCF1slipJx445QIPLH01SSQMdBanM5cnVmgYf2tYbYUeypxdp3tvpVbV
         ECcmQRwGy8lvcbcO8hq40xGRikZsJ6ohU8owWpkCo83f3FF9Re3PHRr4DrEgrneVDtFQ
         w6bagvav8dks8ftVgRARLsIstUgiMdG4AULxFuIJQr8uSLRm1MC7qLyVon+wdI28Sw75
         qDEgU2QRxGfbVaPvZi8emiNgq71FwCEYRxobFNh43hUx7sEZJ+WECbEn4c93/K+F20Xz
         lEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hP/aWgXaFw5Bzdx/U83p/bo+HnMeXiUCpHsIdC7JcVQ=;
        b=f2BSY8vH1qsxBt2lLQoZM4uM9lUVdJqpfp9ETPVeH4T4UWzSGkQsIEnjGp5UgCMXX9
         TzTc29CgMOlV1B1XrRV0zxKP0qBSfOWIj64H8cG86a8Ly5PjDe0HihVgPAOf8kgJ+C2/
         /44s0jUDu9K4y5oNuN0P+WW4TcJBX3XkzEwRRubz/VCNga15+iMP9omwswa6+uuxg1+L
         qRQVCIR5s1P29z95bfi5mnjkayJOc8lzbtNOr4Q9GEc+HnI/Y0BQsP26ncayZSvPYLie
         yuwpyeviC1YCqTT5iKl0+pDPLodpI2I+XNE4Zosx6LMsqnVg+GvjYtQWY9PEviHnAOuS
         26DQ==
X-Gm-Message-State: APjAAAUGHRgyDUmwucfo283xzClvXXWaVLw0X3LEEvQ7uCwWQ3B4g2DC
        iLS/8jMoY2NMLkPitmF8aMv2EyKwdo4=
X-Google-Smtp-Source: APXvYqyoQwKk0jx51tnf5Hsd0OUAK345hpWFzazIcY8ECiDyGlQQGVixnI3epQyZx7hxAC4pq0KAkQ==
X-Received: by 2002:a2e:9dc3:: with SMTP id x3mr7872156ljj.257.1580051504377;
        Sun, 26 Jan 2020 07:11:44 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id f5sm6495601lfh.32.2020.01.26.07.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 07:11:43 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Daurnimator <quae@daurnimator.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
Date:   Sun, 26 Jan 2020 18:11:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/2020 4:51 AM, Daurnimator wrote:
> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
> 
> I don't love the idea of some new type of magic user<>kernel
> identifier. It would be nice if the id itself was e.g. a file
> descriptor
> 
> What if when creating an io_uring you could pass in an existing
> io_uring file descriptor, and the new one would share the io-wq
> backend?
> 
Good idea! It can solve potential problems with jails, isolation, etc in
the future.

May we need having other shared resources and want fine-grained control
over them at some moment? It can prove helpful for the BPF plans.
E.g.

io_uring_setup(share_io-wq=ring_fd1,
               share_fds=ring_fd2,
               share_ebpf=ring_fd3, ...);

If so, it's better to have more flexible API. E.g. as follows or a
pointer to a struct with @size field.

struct io_shared_resource {
    int type;
    int fd;
};

struct io_uring_params {
    ...
    struct io_shared_resource shared[];
};

params = {
    ...
    .shared = {{ATTACH_IO_WQ, fd1}, ..., SANTINEL_ENTRY};
};

-- 
Pavel Begunkov
