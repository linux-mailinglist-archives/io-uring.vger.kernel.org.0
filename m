Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC00220C2CC
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 17:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgF0P1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 11:27:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40749 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgF0P1N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 11:27:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id x11so5405227plo.7
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 08:27:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2UD5eOgq5L0+Hy28v4wMHM4jLWqD7aScJcZP8wk/NA=;
        b=dkPIR05haeAJxzbvOdRpZsx/Vn6J6yzhcyjiGRhPoH1McN64ie7XZHcJ4BVsFZjB9X
         GjXCYzJz+wpgP6oy9gku+tg+ykEBwKgUWxtsllw5TVKE3ylBqUBlPbD3175ghy3nO+Cc
         KKu0etuIAPzH3Rdzqf0IFFUjGxw4WQkGmMoC4ahGB1l+yQ/50KeVGR33HO8LbjstXAdq
         sAsMUFX32yp9AXyI5Nw5ZIXfB6zoP5noWAF0pAOe0bObSrmGu8x7LBSDVcbsnoYqaD6X
         zLRBKBnhGbK5QwpIhkBRiw5an6lzAdyvqy3waNuF+FKkZiaRG7vKRpuXPCCHfNhm1fBb
         vT/A==
X-Gm-Message-State: AOAM531DOA0ZmlBo4O1eQp6Iz/TOtix/QSPPrAGbn+skRCQCpOTdaAZV
        uAPbBEgsuEVcAFP7G+1t1E6forYN
X-Google-Smtp-Source: ABdhPJwurDIuWyBthyng46DGxaXUtO51+YqULfmfnbJJc5FEJ2QuxdbQJDGqHzJ7I6DWrcyqNSs6mA==
X-Received: by 2002:a17:902:c411:: with SMTP id k17mr6534684plk.165.1593271632072;
        Sat, 27 Jun 2020 08:27:12 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id bx23sm8910748pjb.47.2020.06.27.08.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 08:27:10 -0700 (PDT)
Subject: Re: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
To:     Hrvoje Zeba <zeba.hrvoje@gmail.com>, io-uring@vger.kernel.org
References: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <b83a2cc5-31ea-9782-1eeb-70b8537f92c3@acm.org>
Date:   Sat, 27 Jun 2020 08:27:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-06-26 22:55, Hrvoje Zeba wrote:
> Since b9c0bf79aa8, liburing.h doesn't compile with C++ compilers. C++
> provides it's own <atomic> interface and <stdatomic.h> can't be used. This
> is a minimal change to use <atomic> variants where needed.

I was not aware that liburing supports C++ compilers?

>  struct io_uring_cq {
> -	unsigned *khead;
> -	unsigned *ktail;
> +	atomic_uint *khead;
> +	atomic_uint *ktail;

I think this is the wrong way to make liburing again compatible with
C++ compilers. Changing these data types causes all dereferences of
these pointers to be translated by the compiler into sequentially
consistent atomic instructions. I expect this patch to have a
negative impact on the performance of liburing.

Bart.
