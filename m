Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFE3C25C6
	for <lists+io-uring@lfdr.de>; Fri,  9 Jul 2021 16:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhGIOWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jul 2021 10:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhGIOWf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jul 2021 10:22:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435C2C0613DD
        for <io-uring@vger.kernel.org>; Fri,  9 Jul 2021 07:19:52 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b1so12616146ioz.8
        for <io-uring@vger.kernel.org>; Fri, 09 Jul 2021 07:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bhHqxUlxcu/FlkKRb/gO8lzu6xUse6jQvhbl8eFYZdk=;
        b=vXnEuPGUlWY0fazo+wWrLriShudF/YDNR0wefm0lD0auHy3oOVTHF8tYZRfQF7yRl4
         hwEmOyY3dcLG2vRPHb/pSa3bjbZpPp5iQ65aeZ3PEOVqKPiCB/gh6d/+ajXfY1RJCqMf
         kRvPswJEvqRGOhBQ+vBbLHfO4tPt4oBohvOkldoRf3hukeLFkIOEcv91BasPf+spYlwf
         zBpaQXYJttlyVWQAkRmMXq5S9I8DuNoE8zXYw32LjoIUdiUBmYpHLBfTnwHNFqEzI37d
         QAljjP6FuxEFKfUjREC2TRzOUGkBnxA28j1Rns2g8w3GtBn80qqGAOSjtxZRFAJcXhrE
         L0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bhHqxUlxcu/FlkKRb/gO8lzu6xUse6jQvhbl8eFYZdk=;
        b=fGMDXuJ+ft05t8Gu8YlzfTru/hgJn7eHc15LI+KTZxiKBABCi8aDnBOZedCdlllGNh
         vq8bHIewUy6cXMKKHmY+NlR+774OaqIbSDwH6ON+G0gA425U2K1XsGfoaf7ux/gS0j6I
         GIU4rVxTsMX+tIf18wJ7HLgAGt3hbDrX27c+OlAN1L/GeH4N/BLGHdUGLtApgu9t4fmY
         ZoQKrDNEsh7YjSsH2b/TrbDHHR974CEopTtDPq46dgPE/m/JaiymVDKoJRU6qluK9ffI
         hPedLL1/+RYDBS0MYaY2O/jMGb8W9LwurWeWXycgjiPIBlfmLabsGSMETb7FqzIacGTo
         wiwg==
X-Gm-Message-State: AOAM5306s0ZpJ07Vf97nsPhP+7tCFSMtwwjKoWmCvcIWe99cEnUZPlzX
        h6tm+BWLlP8tMJR86KdVlidfGA==
X-Google-Smtp-Source: ABdhPJy9C3+E4Cro9CTIolIQDhQ5jlejH3fxR5+yJpwB5ukwkxVCatJvDkc1mQGlvwAwKKnqqi2W2g==
X-Received: by 2002:a02:c00c:: with SMTP id y12mr31977864jai.99.1625840391361;
        Fri, 09 Jul 2021 07:19:51 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id q7sm2783002ilv.17.2021.07.09.07.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 07:19:50 -0700 (PDT)
Subject: Re: potential null pointer deference (or maybe invalid null check) in
 io_uring io_poll_remove_double()
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <fe70c532-e2a7-3722-58a1-0fa4e5c5ff2c@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2e31029-0d6d-6624-549e-381cd73adeeb@kernel.dk>
Date:   Fri, 9 Jul 2021 08:19:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fe70c532-e2a7-3722-58a1-0fa4e5c5ff2c@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/21 5:55 AM, Colin Ian King wrote:
> Hi Jens,
> 
> I was triaging some outstanding Coverity static analysis warnings and
> found a potential issue in the following commit:
> 
> commit 807abcb0883439af5ead73f3308310453b97b624
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Jul 17 17:09:27 2020 -0600
> 
>     io_uring: ensure double poll additions work with both request types
> 
> The analysis from Coverity is as follows:
> 
> 4962 static int io_poll_double_wake(struct wait_queue_entry *wait,
> unsigned mode,
> 4963                               int sync, void *key)
> 4964 {
> 4965        struct io_kiocb *req = wait->private;
> 4966        struct io_poll_iocb *poll = io_poll_get_single(req);
> 4967        __poll_t mask = key_to_poll(key);
> 4968
> 4969        /* for instances that support it check for an event match
> first: */
> 
>     deref_ptr: Directly dereferencing pointer poll.
> 
> 4970        if (mask && !(mask & poll->events))
> 4971                return 0;
> 4972        if (!(poll->events & EPOLLONESHOT))
> 4973                return poll->wait.func(&poll->wait, mode, sync, key);
> 4974
> 4975        list_del_init(&wait->entry);
> 4976
> 
>   Dereference before null check (REVERSE_INULL)
>   check_after_deref: Null-checking poll suggests that it may be null,
> but it has already been dereferenced on all paths leading to the check.
> 
> 4977        if (poll && poll->head) {
> 4978                bool done;
> 
> pointer poll is being dereferenced on line 4970, however, on line 4977
> it is being null checked. Either the null check is redundant (because it
> can never be null) or it needs to be performed before the poll->events
> read on line 4970.

I think it's dead code, originally copied from the single poll wake
side. The 'poll' non-zero check should just go.

-- 
Jens Axboe

