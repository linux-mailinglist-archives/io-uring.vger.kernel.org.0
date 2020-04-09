Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6A1A3764
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 17:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgDIPq7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 11:46:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40997 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgDIPq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 11:46:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id d24so3957361pll.8
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2020 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G0jg35lbC+MFgyqHjqUPhcBC0DCVq4tXW6XyWqB3Z4k=;
        b=0kZ7hVtK6Ficq3HclgTf41SQ4PQaoGDgMQMLRAjyGkjZXnVD2zDNiohWla38s+fJ+Y
         hTYx1o0KXF6FXDBqV13qRwXNcGd06cCzsGYN20a9HEQDZ4j8VmAOnP4dqwYf6T0ODLFd
         kxl/HBSrHH731satyt+fcbJm7df67fYWJBWvaFu9nXokYJbtmvvyf9ugcQPt7DDqBORc
         K7VmAr6dfj27kvhG9Ym/c3i0I7igVzJp3EM29H35k6Zf3rGLkDQ19MXO9I0NQM/nAmwg
         mcWY0YA/CZUIpl/e4jbJ84GPhrWOYfYNHRf0LsIE4uyTo3fdwGjr0ag+DlIrmS8OVQXo
         ANwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G0jg35lbC+MFgyqHjqUPhcBC0DCVq4tXW6XyWqB3Z4k=;
        b=rb+g3JRBvyYB28owAY4FwZg1hfhSEcQn8geLMBWvvkldqowVPd9jkwpiLBWVRfM/jw
         iEaBPzvgK1TaxI7NenSZaNKrlQvJi/UqMuQL0o8mnaDBnuaP5NpKU+sI3LvPLu9aOU65
         85b4Buk+7vdh2l/oxhDM8o4R2x5ElmJ9qN9faj+k2pdywnRkGmWyRLct1HUqTQY9hpBf
         jjIvAe7ZX+65D0QY2Of3T6KZYM2+HlWaNw1CDoaEF6QUqFidvx+vf0mSYlJxZUKoR/zN
         nM3R/ALlE0pIG+5DB690ymE7AgDyFBb6pMDmaqPgyZj18B5YL/ZBGFQME+iSw5NnEavT
         uN2A==
X-Gm-Message-State: AGi0PuZNpGA/85KMU8Br9Uq0jxgoYuT/yZfqrhiHX1szt8oo4o9ee+X7
        LZmkcjyJX6VcXN4JNsUdkE8Iq1syGmL25g==
X-Google-Smtp-Source: APiQypIriUmorzqeVjygI5naOwhrFsnL+z1QicY59FKT6ZZYfniwZPyIpe8EhmqTanUVNJwmvnvTnQ==
X-Received: by 2002:a17:90a:db02:: with SMTP id g2mr26289pjv.49.1586447217175;
        Thu, 09 Apr 2020 08:46:57 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:70f8:a8e1:daca:d677? ([2605:e000:100e:8c61:70f8:a8e1:daca:d677])
        by smtp.gmail.com with ESMTPSA id nh14sm2503697pjb.17.2020.04.09.08.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:46:56 -0700 (PDT)
Subject: Re: [PATCH] io_uring: set error code to be ENOMEM when
 io_alloc_async_ctx() fails
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200409024820.2135-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3561b6eb-46df-e5b7-d9ae-0462d07e7722@kernel.dk>
Date:   Thu, 9 Apr 2020 08:46:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200409024820.2135-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 7:48 PM, Xiaoguang Wang wrote:
> We should return ENOMEM for memory allocation failures, fix this
> issue for io_alloc_async_ctx() calls.

It's not uncommon to have out-of-memory turn into -EAGAIN for the
application for runtime allocations, indicating that the application
could feasibly try again and hope for a better outcome (maybe after
freeing memory).

The error code is also documented as such in the io_uring_enter.2
man page.

-- 
Jens Axboe

