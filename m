Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C534461E
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 14:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCVNpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 09:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhCVNpE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 09:45:04 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5A8C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:45:03 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id ay2so6599651plb.3
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Tli/spzAAOQs7G7CWoRwnyrPheanSBTPWz+PkrqnQDo=;
        b=EFX0K+T8oib4zxXOK9VJNLMnAGI8JcVikDircjuBD1ULc4BFruDfsq194uDk9M4ugW
         Mb3mCkBosKECRLlQMeLysv2hqszMlXIUOzXD2ZRTiSUmSBhyto/V3TJoqNdLSYQDePts
         ex4qCMxdY+ycNRp9qtagtiTMS3EIvF1C6FQRyv/ul7RYL2nsSDVHMPbMfehdYmVg8flG
         cz/1KVmROdaoBDEmneT5giYzCbYVuAhsAExpONWPsfRamumYFL4mQo6KUF8yVPWy++P9
         +L/Xc17zWxC5I82DL0c0fQj69dQkDLPykbMTRAjwpQxsrQjr0Q3etLZ+7Z9+k4PdkoQu
         Gg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tli/spzAAOQs7G7CWoRwnyrPheanSBTPWz+PkrqnQDo=;
        b=QN4RvEjqA3xqEWrSdqD17tw+Vh6FuvrOmwks/UsWNnqwFd5KTg/qBEh0nDnBTD7sSc
         jt9cIGYEmPTfXguyUnhmkjpIOH4S8fedDo7Ac2VufhfyGD+w4KxTeKYPu+UrI8X/JOKx
         VlUgbOEOc6JARc2DaZVnuOyRLRZ+WICzgL1gn9+KcbVhdBOQqpCQ7hqnRcWgwnjC5V39
         vuxm8NCwbFySjWdeeeuxQCVBBO/Njf3qQCAJi/98q5j6gedGNpsgxt7IxOi6mZzG7AQz
         o4fHZYE/mpHB37WUVd2Y74gDesjrfxb42g9EvfsF4b2GVLieBfGXmVzUE7+Nq/9nSSKu
         MS7g==
X-Gm-Message-State: AOAM530RiE/Z6w3wy2eimm28vWEQTd+qG0gtkvvkxQV7SEh/xElsjCBo
        0I9gI2yAuQ6FKXvvdvRPCO+tGJHBy/KVHg==
X-Google-Smtp-Source: ABdhPJyKVi+2HdpHcRj4dueLZcee47ycq9ObEkkDKN2non3W1sJTSicJ2i9xj7Af4uPfoHnViw0jGw==
X-Received: by 2002:a17:90a:c201:: with SMTP id e1mr13497867pjt.30.1616420703009;
        Mon, 22 Mar 2021 06:45:03 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id cv3sm14892705pjb.9.2021.03.22.06.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:45:02 -0700 (PDT)
Subject: Re: [PATCH 03/11] io_uring: optimise out task_work checks on enter
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1616378197.git.asml.silence@gmail.com>
 <ff3273b5111fdb10eea0e3d4f81f620fb58c5a5b.1616378197.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e8da4108-21a1-62b4-5556-bc9208e930f3@kernel.dk>
Date:   Mon, 22 Mar 2021 07:45:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ff3273b5111fdb10eea0e3d4f81f620fb58c5a5b.1616378197.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 7:58 PM, Pavel Begunkov wrote:
> io_run_task_work() does some extra work for safety, that isn't actually
> needed in many cases, particularly when it's known that current is not
> exiting and in the TASK_RUNNING state, like in the beginning of a
> syscall.

Is this really worth it?

-- 
Jens Axboe

