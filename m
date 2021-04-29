Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DDB36F257
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 23:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhD2VyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 17:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhD2VyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 17:54:17 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9839C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 14:53:30 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h11so7444561pfn.0
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 14:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xIMQ+773ryteFuKRaUfteq/81taBNLZ33Pp+4QJuhQk=;
        b=c9vS1NW6ecswSISXKG4bIuKmEDeKid7MLzjAl07QAcHPOeP2fCsYJuTXIX+KlD8sHz
         HjL7SgMd3oJ0fL7Rw77VBUx/RfPfjqs2cxApMNuTIaLs8wisUkSQ/zFYjAofz5Y1BD5w
         rktIQSlbePtDn41Q/+13oX5fBKM/2MOHS69vZMVuUj/L3kRlnQMJX2+92MdWfzN5WN0o
         3UeVQEdipPunJIx3NfiMCCdvrJUOlAeI0AgH3/WnRd0uWAtZeAGB7S6VKaV2L5//1LA/
         GHtIcfKXjnzunU4CERSMjQAQRkEhvL/T+at+H4SqV+va7rn7NbX2VUcQtD4ZX8ozQzkE
         nPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xIMQ+773ryteFuKRaUfteq/81taBNLZ33Pp+4QJuhQk=;
        b=CoN64awZcnR/3ekg+y2sa8qgDipJ3TTAhqEL4fe2NohrVRRwPCIrQVBQP7Sks0wGA3
         HsT1U8rqOmXbDjGHNdM/EdmEctzpGpHs1BO1gYKPmJCFzNSXkR16OEJ8ERIn77JIRM5a
         9uqDUS5qG55pEmbFupALeXb/rPePVz+SJ2JYSlbjHWyncra/K2JgTN+7u9bIgmh8esk+
         Zi9+oAxMlPJ7re7RG9AfKrx2ZVsKZGe3wyd7C4Gf+T5Zr8GcLYvm/I6Tj8rwVWVLEeNI
         L8rA/vQ/kk7IvVRqCtzppzI/fUGYE+hf4d6/8NPPFln97+qjOXIoqvDg7vD08t1aZ2/u
         FhAg==
X-Gm-Message-State: AOAM53324i8xjQAd0RNoOhlHbEj0UxtKe591yNJFWbKHTMcAIhfAdFe1
        jk57Q9LX6g8RfIs3etkSwBZT5UL1F6eHuA==
X-Google-Smtp-Source: ABdhPJxjuZDC824MXpcvEO4Fp+e3ZrhZDd8H8aejfa9tqtj03JsVs0hK6TWGHT/tDt4h0d0excUXbA==
X-Received: by 2002:a65:6a52:: with SMTP id o18mr1664586pgu.17.1619733210130;
        Thu, 29 Apr 2021 14:53:30 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 132sm979034pgh.72.2021.04.29.14.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 14:53:29 -0700 (PDT)
Subject: Re: [PATCH liburing] test: test ring exit cancels SQPOLL's iowq
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <5ff453f83e0202fcdb48c27b6597aa615cd17f01.1619390260.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <34ad5760-9b8c-9fb8-0f93-1e2ed83b2b14@kernel.dk>
Date:   Thu, 29 Apr 2021 15:53:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5ff453f83e0202fcdb48c27b6597aa615cd17f01.1619390260.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/21 4:38 PM, Pavel Begunkov wrote:
> Another SQPOLL cancellation test making sure that io_uring_queue_exit()
> does cancel all requests and free the ring, in particular for SQPOLL
> requests gone to iowq.

Thanks, applied.

-- 
Jens Axboe

