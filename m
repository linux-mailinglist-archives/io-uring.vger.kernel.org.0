Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2241F2DF
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355160AbhJARSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354712AbhJARSn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:18:43 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3436C06177E
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:16:58 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id q6so11310245ilm.3
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=k3FSU+H81bYnaM6GftgKw1RK7DCoLvQgbsm434mklJI=;
        b=tklzyzc+Fjgilc0Ah9P9BGHictZFSJnFsBFrFF4Kmq0ZRQLM4psi4n9BHhD6qgsU2k
         VMN8nKUI+RaqKWDf0j7TCx+ONiNVmz6IF0iGQPjEGQrLdm+ZUVNO7rmGq8F4gD71u0Re
         UJr9JXrnrKIZ4ciWBIzuVGeC5C1xKLGWpZry89JjxGYBsP77079OUBR76iVtKwy89Spr
         n6Lopz8jdlIsiz1NhvrULX4OqqBrXMgXBBP/ZhOJHFxpS7z8KjFQbbduyUEp7C9fDTWN
         qUWjp4rggUA/0rPGKhp8r+u2CiQwz142zVmZxlYDFGwdvlEcNqDgsBncQ59PXx2iqb18
         sfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3FSU+H81bYnaM6GftgKw1RK7DCoLvQgbsm434mklJI=;
        b=vLwfNBMVX0xLG5/N1xmZSWWvkBpSlSUvkYm5SQnq7cLJNnYmHevKeOjDaord/xDHst
         3gMscZ8esxGROLJ80um/o9FGP2J8e6LO4EbTvRdO5k/ztE5onP/ZRCRuRsVNhHKgL/ku
         Vvl9R54wUOcJQ/343ruYOHbGKgTK3s2QCql8zAqPVwzVxEfTDcUma1VhN3Oc84uWqCYl
         j5KhcWQpLZbGtztG9UHOMz3VOOQ3GCUiAw77gAgtzctUXJSdmVfHRC7Qmc1xYfrRvFDf
         eq1PIS1yVCgCtUGew0ZWW3OYX+oaP7Eh7dnzrzlG4rdUlAN8e+Xbw1LJvjq/xhdBcT9/
         jE6A==
X-Gm-Message-State: AOAM531KLwzJb2M5hz490D2AJqJtdynbeBDCE6eMLtVp1l9qt6N1B+t7
        o8e6BUb6J3WvtsMJn0/kK0WjqDMa9u4OFBiMz9w=
X-Google-Smtp-Source: ABdhPJz+3RSWl+6iDmgJGlFGVCGDkIbPnb/k5YdryeLqhswJV7CHKJkr+QaCAX7+7xIY2GpvhKyjCg==
X-Received: by 2002:a92:3642:: with SMTP id d2mr10046408ilf.234.1633108618009;
        Fri, 01 Oct 2021 10:16:58 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g5sm4031829ilq.50.2021.10.01.10.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 10:16:57 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: kill fasync
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2bd80cab-c9b0-3883-7e7c-d42904c02ad1@kernel.dk>
Date:   Fri, 1 Oct 2021 11:16:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/1/21 3:39 AM, Pavel Begunkov wrote:
> We have never supported fasync properly, it would only fire when there
> is something polling io_uring making it useless. Get rid of fasync bits.

Applied, thanks.

-- 
Jens Axboe

