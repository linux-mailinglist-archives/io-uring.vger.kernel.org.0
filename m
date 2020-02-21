Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E665B1686B5
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgBUSbj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 13:31:39 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36803 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgBUSbj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 13:31:39 -0500
Received: by mail-wm1-f52.google.com with SMTP id p17so2927576wma.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 10:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gT4MuTTV3d23PbgbepB1Ni4n6RPXtmL7nexcKO2jOZE=;
        b=R5ysE0KgC1oSD8CsKDl8QBzcLLcADld4lOqR2bkQ58LBQO4sHHQLS3me0Og9U4ZkFi
         ynJZZ8ZoqTXGK2ygML0Do+byXwfTKOfBaXvNjnMNrmbJvJc1vNrx0zJRhJEUDC0b4Qpz
         frVf/dQOwXQtpOMiJkfjxVsyTsogh74mpl50kE6JI3PqY9bJmmciNuSE0HgEwTaFWrcI
         jSU6hhN9QHsa9QZa1Sg8+qEK3B7s0VnMvXSfDufNC2a0JtZrKM/EV2/i3Pl6umLGaG8r
         c5Mt1AXegadPBei2Lmg7SMU3pZ+vSo5DQv8NUOTmTn20DiXHT3FIajHvqQVQOUrojzUJ
         h7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gT4MuTTV3d23PbgbepB1Ni4n6RPXtmL7nexcKO2jOZE=;
        b=Xmsm6aubaR0HUjEbX5+1UJtV4FK+SUnFvEhT0XsHT4E9Aqrf5N8qi9GKpWR2OnokjA
         o3PSoDw9r9GZv+hSsmC38EeXXFEro1SvgRuOXQLOxgmd4vtTfAdCA2vPITvz851iRA+c
         kcwvY6R00oGJYoOIJHuq8iwC+KGud2mzIzLxfaRr8d03gcKtXYB9pArJbW4ss2hc6FJn
         X8CGO2GTYYdeibdttkUDnQSPFqfgTxaBazlTpv5qXkTm+406SP9RuJpTLE/gHqrE8nrV
         VpYBHzw0kx3fGJH16d7wtSczHrCDBUkYqaR6+fRANADfRcP+SA+OX4mAhkYFK/5YOuFq
         aF5Q==
X-Gm-Message-State: APjAAAXywqvf1puMOLVFJF1VrPIkYbbniDfgJGjO7UlU7uFmogs3ENta
        LEtI/QA6AUhK5Q6S2ihXsaN5FSAo
X-Google-Smtp-Source: APXvYqyFscDqopyfT+/h7Z0Bd37atk0BtroUcrpT4ajdbHOaKcCWsSRG8YnMYAFALfA/HG/RCT6GoQ==
X-Received: by 2002:a05:600c:294:: with SMTP id 20mr5272002wmk.135.1582309896598;
        Fri, 21 Feb 2020 10:31:36 -0800 (PST)
Received: from [192.168.43.74] ([109.126.144.14])
        by smtp.gmail.com with ESMTPSA id p26sm4632534wmc.24.2020.02.21.10.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 10:31:36 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
Message-ID: <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
Date:   Fri, 21 Feb 2020 21:30:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21/02/2020 17:50, Jens Axboe wrote:
> On 2/21/20 6:51 AM, Pavel Begunkov wrote:
>> On 20/02/2020 23:31, Jens Axboe wrote:
>>> For poll requests, it's not uncommon to link a read (or write) after
>>> the poll to execute immediately after the file is marked as ready.
>>> Since the poll completion is called inside the waitqueue wake up handler,
>>> we have to punt that linked request to async context. This slows down
>>> the processing, and actually means it's faster to not use a link for this
>>> use case.
>>>
>>> We also run into problems if the completion_lock is contended, as we're
>>> doing a different lock ordering than the issue side is. Hence we have
>>> to do trylock for completion, and if that fails, go async. Poll removal
>>> needs to go async as well, for the same reason.
>>>
>>> eventfd notification needs special case as well, to avoid stack blowing
>>> recursion or deadlocks.
>>>
>>> These are all deficiencies that were inherited from the aio poll
>>> implementation, but I think we can do better. When a poll completes,
>>> simply queue it up in the task poll list. When the task completes the
>>> list, we can run dependent links inline as well. This means we never
>>> have to go async, and we can remove a bunch of code associated with
>>> that, and optimizations to try and make that run faster. The diffstat
>>> speaks for itself.
>>
>> So, it piggybacks request execution onto a random task, that happens
>> to complete a poll. Did I get it right?
>>
>> I can't find where it setting right mm, creds, etc., or why it have
>> them already.
> 
> Not a random task, the very task that initially tried to do the receive
> (or whatever the operation may be). Hence there's no need to set
> mm/creds/whatever, we're still running in the context of the original
> task once we retry the operation after the poll signals readiness.

Got it. Then, it may happen in the future after returning from
__io_arm_poll_handler() and io_uring_enter(). And by that time io_submit_sqes()
should have already restored creds (i.e. personality stuff) on the way back.
This might be a problem.

BTW, Is it by design, that all requests of a link use personality creds
specified in the head's sqe?

-- 
Pavel Begunkov
