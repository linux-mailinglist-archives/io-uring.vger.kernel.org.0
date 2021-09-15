Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A172E40C85A
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhIOPeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 11:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbhIOPeI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 11:34:08 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B8FC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 08:32:49 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h29so3387691ila.2
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 08:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oSHNnFw50NtaUug8pvKX9QcMvQT3CtTjqa5ZQCf5lYw=;
        b=BeoejbJwto6fp6wF8J66qKTyU5kD1y18E4uGBjIXh7BsRbx3M09RvDjILvMeKiTu3J
         Yz0oPWD/L5IDJ8WuVfpeW9HuXAJl3w5IWf3MBK4zTr3abiQRAzAdFJdGdKJZECGf9pYy
         hOW7472vkpyvS2P78jSaMncCAiDDmxWbDNLH/bKXzsnkwDK67gyqkDsYoQzRpj8tLqQ6
         YwhpGMD2fT/ocIuBQdPJH3DPyA5ZvB1slXXuVxWocA2lna3HMfHKcPnKVjhmOcPNnCtZ
         10yIbkXRRz6o/yXXqvjG7o3bcBXtaBJnvOlgwTBHNiLA+uoKcdT0OTUn55GjRQR1gy40
         85Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oSHNnFw50NtaUug8pvKX9QcMvQT3CtTjqa5ZQCf5lYw=;
        b=FCyR+4UYeRKbKfyvIVh7dzZ+AAsMo7YZFp7bOukbygT8Xw0GDOgjKSjw43sQwnFD5r
         KkYCOBVR4aiRdKADhjcLSIyrGLU17ia1xLX5QNQUg1v+hkv3HHPlr1+GgfuQRUVrN6CR
         e97maIhwa0tKFQ7N/LdIKx0UXT/L9MzNE45FcE0lLFiuoSztN5au0lqG3+wkXcUd8Gsu
         xSQ5SLGZYkwvvw2Wj5WQgmllhw/uXp05EfC2NGC4Ob0a+3w6KBhHTEUJUzlYdNpl5lZQ
         K9//oh56KIPdIr7/w5zFLwnw41rPYOR30UapN8j9eOK/uWqWS7XfT9iQZxDBVb7rRfdW
         RHbQ==
X-Gm-Message-State: AOAM530I7wWw9ep/gqceT5Q+1+8si17FnLUv+zerW9npzbWwzAXFekZB
        8LN+kv6Pv+FgYXKyon9emNFHT9VrxGhWrlOSvZQ=
X-Google-Smtp-Source: ABdhPJxD3ZyTVXpd912PM60XFbzpkFmGhdVTrdaB29X/S58x1fx3jntc5LPRs/AMr3H0eSzlCxWRyw==
X-Received: by 2002:a05:6e02:1305:: with SMTP id g5mr479222ilr.9.1631719968623;
        Wed, 15 Sep 2021 08:32:48 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b19sm136053ilc.41.2021.09.15.08.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 08:32:48 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add more uring info to fdinfo for debug
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210913130854.38542-1-haoxu@linux.alibaba.com>
 <3ecf6b05-e92d-7d74-8f72-983ec0d790fc@kernel.dk>
 <c5161c85-6e01-c949-e233-7adca5a63c46@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <655da9c2-1926-370b-06f8-8e744111f3a7@kernel.dk>
Date:   Wed, 15 Sep 2021 09:32:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c5161c85-6e01-c949-e233-7adca5a63c46@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 9:31 AM, Pavel Begunkov wrote:
> On 9/15/21 4:26 PM, Jens Axboe wrote:
>> On 9/13/21 7:08 AM, Hao Xu wrote:
>>> Developers may need some uring info to help themselves debug and address
>>> issues, these info includes sqring/cqring head/tail and the detail
>>> sqe/cqe info, which is very useful when it stucks.
>>
>> I think this is a good addition, more info to help you debug a stuck case
>> is always good. I'll queue this up for 5.16.
> 
> Are there limits how much we can print? I remember people were couldn't
> even show a list of CPUs (was it proc?). The overflow list may be huge.

It's using seq_file, so I _think_ we should be fine here. Not sure when/if
it truncates.

-- 
Jens Axboe

