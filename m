Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25C5253545
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 18:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHZQrq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 12:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbgHZQrk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 12:47:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D14C061757
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 09:47:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g13so2801069ioo.9
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 09:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=knubijAt0jlcEgyfGnp3DjNef2Zkl9PnsPdwfFoIfEE=;
        b=zSSLNQs+V1I4LENOdushsj3nmnFYyqaQdhtY5oY/Xt286k3qGUQkI26czvfppN49LX
         o3Tp4yTmeV5j/D62zFr+TZuZSAvYv005z7/th9LrEbutQHP1CwTihB/xVI7k6JoZyaHp
         lWDxEUGFmqx3gxPUDHBKylXtpbMwlh+un+m7DU0q3tJFNZofLUWtXKiZ9GZET0F5tVTY
         fYDAShfuEIZPjMnRUBcpC8JYIDOljcBdpY5bi4kGbq9JOcHt1TSgVWnjjmPKuQXIJMXe
         PSBxzsnrt7YBgW5E6P92+1x5UVOk2AELav7ofZ3IFlYkZ/pTRhRCbbBFCZOLrK7oMuDQ
         TdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knubijAt0jlcEgyfGnp3DjNef2Zkl9PnsPdwfFoIfEE=;
        b=NlfILtaVBVJDg1Y7QAlOmUb3/ggGWZK+sHgPM0rJ1BBgZO/oeoaz5AQEW8NSstjCTe
         fq+B5ocEuEYRbpoTUDyBKrJpzmPToyv2xmwURf8Ty7IV4q1cn2CxOi+Da0DbPrOtb9nN
         BKxCJGj6D5NyayrDmhzA/W8aeek3vwJ2wFtxTLrQZwNWNCFaHKxQGNLeHZtBY2Zml5Li
         ddcuTjdXgc8lZlpSZ8KrWqyKfad6HWzzDTQHfJVsFz3n5UY1RclOa/Mqwz3d8/pPEnE0
         FJ0Jl82X9wFjQlSS6j6WCcJ2UkvFFqS30nKWqjJ4llIoESa0vD87GUyHdnzroLX5zGww
         jWVQ==
X-Gm-Message-State: AOAM533Nmb5cEhUuwpy1YqwD3ay1SKDj9nc1x7kZzc7qwsYzE2DOzhNO
        M4l7k92HOi/LIV+EBA72QG+2yLId/MLsdcns
X-Google-Smtp-Source: ABdhPJw6tqipY5aYgIN5ObL9GNtF7hYUHQ1OYqLEU+5VRRsLKuPz0AHe/fnvaAJIPrska52FeW4ZcQ==
X-Received: by 2002:a05:6638:248e:: with SMTP id x14mr15661824jat.135.1598460458830;
        Wed, 26 Aug 2020 09:47:38 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o2sm1688208ili.83.2020.08.26.09.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:47:38 -0700 (PDT)
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Aleksa Sarai <asarai@suse.de>,
        io-uring <io-uring@vger.kernel.org>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82061082-42c8-1e1c-1f36-6f42e7dd10cb@kernel.dk>
Date:   Wed, 26 Aug 2020 10:47:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 9:20 AM, Stefano Garzarella wrote:
> Hi Jens,
> this is a gentle ping.
> 
> I'll respin, using memdup_user() for restriction registration.
> I'd like to get some feedback to see if I should change anything else.
> 
> Do you think it's in good shape?

As far as I'm concerned, this is fine. But I want to make sure that Kees
is happy with it, as he's the one that's been making noise on this front.

-- 
Jens Axboe

