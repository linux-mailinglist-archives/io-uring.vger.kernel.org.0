Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5412614D3A8
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 00:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgA2XbP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 18:31:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45394 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgA2XbP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 18:31:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so600076pgk.12
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 15:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UD0PLBqILXWZzA+Xw1FVIPXR3Zk1sRGNq0oqaOTwe6Q=;
        b=B5AoyebP574h4QuBLiYX2EPl7T79WKXrLNPb5j8tV0sk/949moS2cQ4S4hWjPgCF4v
         DCx3q17mHqEP+Zi2psINsQ9zcdYU8vF2YIWnXbNZ4SKhZnu6e/QXP3Ka5pz5z4tw3NBL
         xnZPEo59GGfUxeUbeEfyLqvif7kLrCBMIddxDNlAF8jxsEaIci258+mNqIq7D9rx9uGQ
         xWgt0l6ei5RbMvHcNcRjXKgqvjurkLYgHRqs9pyrEupIqZKJfl6y+p05UFhwcgNVJ8zP
         n53jDyiHApl/gsQjhTK/l11iOV7yMmiorYdCa+iWV8eykF2cyqwqrD+JR06bShuNWgkG
         eeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UD0PLBqILXWZzA+Xw1FVIPXR3Zk1sRGNq0oqaOTwe6Q=;
        b=Y2DY5RV2yvKaovH2jKF52dS2PRvsGwSilkb06LJajpkrYPdyTmHcKQsBr8bUozw8wu
         GijHT8+kQAu+ygqNDyb1MNESGT/Cm1WBpIjMDKfQCy6rJbVJuLC99zayQfZqfJON5YaF
         c8IrMnOTjtidCYvvRD+W95T2yXkL98gK3e910n9rxFZnRIAGiJVq/22F12h5fR4Ry7au
         JkEQ7gzsAsixmCMLHPTwO1A1ZUxYgDzB9DVuxkNgdUuLVXya2vXNHe6NoumEcOCpVyCr
         J1xqpqXN8goCUlcaoBicboebOdRdPnEMfMXTRSuRAZ0zABSgQiXFmxk8rKPilgZbc+hU
         BnCA==
X-Gm-Message-State: APjAAAX1slfpiasg4V9VmDAWE8SjLxHxaa33DFXODUVv7yqUFBLvmlzJ
        oWp4e03h5IgqlnAcz3b7Fo0etUIGItM=
X-Google-Smtp-Source: APXvYqxcV7CNTyfqzM3gC03NCwsu7K8ZA9Z0oGEcvVkSX9GMBxOr/jj/8HRtNuHeMdyUSP4yLW0abQ==
X-Received: by 2002:a62:830c:: with SMTP id h12mr2160021pfe.162.1580340674111;
        Wed, 29 Jan 2020 15:31:14 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id t63sm3903489pfb.70.2020.01.29.15.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 15:31:13 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix linked command file table usage
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
 <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
 <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eeae146a-1268-bab3-043b-dffe6dfb21d0@kernel.dk>
Date:   Wed, 29 Jan 2020 16:31:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 4:19 PM, Pavel Begunkov wrote:
> On 30/01/2020 01:44, Jens Axboe wrote:
>> On 1/29/20 3:37 PM, Pavel Begunkov wrote:
>>> FYI, for-next
>>>
>>> fs/io_uring.c: In function ‘io_epoll_ctl’:
>>> fs/io_uring.c:2661:22: error: ‘IO_WQ_WORK_NEEDS_FILES’ undeclared (first use in
>>> this function)
>>>  2661 |   req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
>>>       |                      ^~~~~~~~~~~~~~~~~~~~~~
>>> fs/io_uring.c:2661:22: note: each undeclared identifier is reported only once
>>> for each function it appears in
>>> make[1]: *** [scripts/Makefile.build:266: fs/io_uring.o] Error 1
>>> make: *** [Makefile:1693: fs] Error 2
>>
>> Oops thanks, forgot that the epoll bits aren't in the 5.6 main branch
>> yet, but they are in for-next. I'll fix it up there, thanks.
>>
> 
> Great. Also, it seems revert of ("io_uring: only allow submit from owning task
> ") didn't get into for-next nor for-5.6/io_uring-vfs.

That's on purpose, didn't want to fold that in since it's already in
master. Once this goes out to Linus (tomorrow/Friday), then it'll
be resolved there.

For local testing, I've been reverting it manually.

-- 
Jens Axboe

