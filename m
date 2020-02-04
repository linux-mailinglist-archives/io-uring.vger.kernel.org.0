Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA71520AE
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2020 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBDS5m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 13:57:42 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38567 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgBDS5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 13:57:42 -0500
Received: by mail-il1-f193.google.com with SMTP id f5so16834468ilq.5
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2020 10:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=45tj5OxWVybTfif4WYl0lTvBnofnn/riEklSn2zhn+4=;
        b=U/ur74moi2VdYIHY12lLRdfFqE3Y/M5i2KvndQMiAhN8wBcnuVDl5dNUIOGGwNf4hw
         htZgt2j0oUeb9DDmUaczd4N4ahqda8rMyd5EUmMudUbFjrBR1PK0IflzWGUJTk8NKDhx
         43/fcaHISfDsup9qEs6zrz2lGE3CKjEWip00hPXTjgXnogCm3itN+x5MK7mKRhn/tk9O
         lRq8qujOcu0+5cMRbR5FgA7/46RoNTIQ/XOn7ulHxQ3/fFWAMFWKB8seCrU/Kp38YfSs
         P2bpeANBD1UZYp/bv34OhMh37c/W43E+4BLXEGA7iBNe18rtn+naoaEFUxxeliNTOAGi
         j1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=45tj5OxWVybTfif4WYl0lTvBnofnn/riEklSn2zhn+4=;
        b=c6XdqL1BTnPrF3JcNzEEaJwI/ZQEKyebEc/wE36Mbzsas1PGSIlt+fBi9Ww0CsS20T
         i+mYDzI6g2xu0Z4g7P5TdW4d1rJgbT4cPLgnSKZ3yBeCkMyp1+6YGVsCyzNK5gpVzOsQ
         ZYyfG1Lte9+7nVH8N2QVZpMlJ/aFM/xUj8GHzmP7N7CzI7c+AqIPE7ofAbCbkrV9xBhc
         sd15ZfhxUd3JQyxWVaWmv8ZvG+pPxUm8Jw0bM2oqLbjmImCnGFnoqkzggDZ1mf5hkPNi
         BadljKLwoNk4bkyEUo5tUzTZv2A0o+SrL0IHXLlkFoYhI+D0ULRN76bVO4qRZxmE2GSS
         B2FA==
X-Gm-Message-State: APjAAAUFjJzCu1Vzz7xwPhQoELLBVvu+ubT6SAYL77fmsUuMVvrvUT1X
        8EswhTzMmvBocyqa1zYKpyOJdTGu8co=
X-Google-Smtp-Source: APXvYqyOE38KWbftIZ1H6qH4vHek8IVgKFIfq/mJfuXD8s8Jy9TYJxVEQmblODks8VjICkvIoTO4jA==
X-Received: by 2002:a92:8851:: with SMTP id h78mr28456588ild.308.1580842661527;
        Tue, 04 Feb 2020 10:57:41 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k16sm9171558ili.35.2020.02.04.10.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 10:57:41 -0800 (PST)
Subject: Re: [PATCH] io_uring: prevent eventfd recursion on poll
To:     Daurnimator <quae@daurnimator.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <73f985c9-66df-3a80-3aee-05c89a35faad@kernel.dk>
 <CAEnbY+cUeNGLOHj2O9VughT8c6A_T4w5qG_nSen=P=fOivfMMA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7d0152f-a950-1c6e-f50c-fce0cae3442e@kernel.dk>
Date:   Tue, 4 Feb 2020 11:57:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAEnbY+cUeNGLOHj2O9VughT8c6A_T4w5qG_nSen=P=fOivfMMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/20 2:38 AM, Daurnimator wrote:
> On Fri, 31 Jan 2020 at 16:25, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> If we register an eventfd with io_uring for completion notification,
>> and then subsequently does a poll for that very descriptor, then we
>> can trigger a deadlock scenario. Once a request completes and signals
>> the eventfd context, that will in turn trigger the poll command to
>> complete. When that poll request completes, it'll try trigger another
>> event on the eventfd, but this time off the path led us to complete
>> the poll in the first place. The result is a deadlock in eventfd,
>> as it tries to ctx->wqh.lock in a nested fashion.
>>
>> Check if the file in question for the poll request is our eventfd
>> context, and if it is, don't trigger a nested event for the poll
>> completion.
> 
> Could this deadlock/loop also happen via an epoll fd?

No, only through io_uring and aio with the way they handle the
notification through a (potentially nested) waitqueue wakeup
handler.

-- 
Jens Axboe

