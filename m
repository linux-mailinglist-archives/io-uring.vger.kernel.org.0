Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6BC141F35
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2020 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgASRgq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jan 2020 12:36:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38722 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgASRgq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jan 2020 12:36:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id l35so5914917pje.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jan 2020 09:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MjiDSm+kbE19Xsf89OAuKU7UGoGUkkLjZk/my0evpWk=;
        b=cNlNPyRCgj4snsn6mEzBHv5+oRF//axl/e8NwKG9UQL1LNcLt/0aY6YE4dA0pJEU26
         fHMfk3EQzaFmr0Lbdm8Rb6tKLTgspttba5X4AbbgJIo/qVf5e/LjezjHW7s7N8dOdEAV
         UOh40bNTLLT0Q33p0em/+bFMhXeOzhnE90JUNM48AaS2zfRTfoEJJ/1CyBifFGntIxyC
         2W2EyZyXD6bFPFBGMqHOFWLMf1BoQqQRTBmuRp/z8MqhbFRFzfpRyd3pXgNpGCtuS1mF
         c4aDy2AfeuU2Aehkptcr8NGQbGvFky/qKBvrdjOAg44kC3fKCgCLb+SdkbNe5wC68Ybw
         fC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MjiDSm+kbE19Xsf89OAuKU7UGoGUkkLjZk/my0evpWk=;
        b=JutLIKbqqtn5P7rKtPRUHq4dwmzQh83TmpKBqrbgT2o2pi4dXsD2MrgrEG+wdFZjyY
         siPQRU7LaQ4Z421rumxYo8mR1rIyL0vvb5XhxXnxwL40iy2aohVTaKRiBDz0HTLcn/PW
         hP+wMjmUmZvws0c51UIRIY8ll1egGS70HKla6+hykv5IKzEQNqJPcu8KtI4CMFdgf9xh
         TvdBXWrF9bkL14162LSYafqeptlurpF+oYfN8qusLHlEcFuA1g5YU+CdELq9aA14bHVm
         PZ6nUG6/jEusGIucdZfC+fnIA60pY+ph+7O63iOiFdfUzHCI0zlQH8q6q1/KkyBZUQQX
         lqqw==
X-Gm-Message-State: APjAAAV1oYQVF80sTQ9oqKXdRFYYUtfTp934/riEGrnEC9PwMamdKsp7
        aS1QoYCksgUg7Su3genYZ2Nt8w==
X-Google-Smtp-Source: APXvYqz7r938jFcdqVuZu+439JQKK4M8n+P8QQ87259lBMet9GboYf9FAIosLIA+/8tfTwMK8QP38Q==
X-Received: by 2002:a17:902:8f8e:: with SMTP id z14mr11013035plo.195.1579455405303;
        Sun, 19 Jan 2020 09:36:45 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i2sm34798703pgi.94.2020.01.19.09.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 09:36:44 -0800 (PST)
Subject: Re: [PATCH v3 1/1] io_uring: optimise sqe-to-req flags translation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
 <648dbd08d8acb9c959acdd0fc76e8482d83635dd.1579368079.git.asml.silence@gmail.com>
 <7197ccc8-6fe2-3405-c88d-95bcb909d55a@kernel.dk>
 <8ce8fffb-f02c-8d0d-4b22-626742f1a852@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7176fd92-9bb4-1017-2b8f-3deaefa41ddd@kernel.dk>
Date:   Sun, 19 Jan 2020 10:36:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8ce8fffb-f02c-8d0d-4b22-626742f1a852@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/20 12:46 AM, Pavel Begunkov wrote:
> On 18/01/2020 23:46, Jens Axboe wrote:
>> On 1/18/20 10:22 AM, Pavel Begunkov wrote:
>>> For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there
>>> is a repetitive pattern of their translation:
>>> e.g. if (sqe->flags & SQE_FLAG*) req->flags |= REQ_F_FLAG*
>>>
>>> Use same numeric values/bits for them and copy instead of manual
>>> handling.
> 
> I wonder, why this isn't a common practice around the kernel. E.g. I'm
> looking at iocb_flags() and kiocb_set_rw_flags(), and their one by one
> flags copying is just wasteful.

If I were to guess, I'd assume that it's due to continually adding flags
one at the time. For the first flag, it's not a big deal. If you end up
with a handful or more, it's clearly much better to have them occupy the
same space and avoid lots of branches checking and setting matching
flags.

You should send in patches for IOCB flags.

-- 
Jens Axboe

