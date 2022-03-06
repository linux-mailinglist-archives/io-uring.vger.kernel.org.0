Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E034CEDDF
	for <lists+io-uring@lfdr.de>; Sun,  6 Mar 2022 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiCFVBk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Mar 2022 16:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiCFVBk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Mar 2022 16:01:40 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1A126AD3
        for <io-uring@vger.kernel.org>; Sun,  6 Mar 2022 13:00:46 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o26so11948714pgb.8
        for <io-uring@vger.kernel.org>; Sun, 06 Mar 2022 13:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hBtio2kWm2ZmZbXm583qrie9CbK6m56oOkcfNZxmLIA=;
        b=gf+PykzF3KG59TrZudRnYWew/sshW/S6pJe5hLqtpVG03sdvEmcK+x2JCJZboEewGB
         BRO0ekOy5kLtf9cA3xWCjFloHoEBD8cxOvyGu/QfdodLGx0qtXQXqewEt+pio22ghPZO
         cQA8kmtHqyf08RBuwJqkoQQOgVeuDADyhvgwAGcLzfbpTtLANLheXqrPS+GiExYCsNcp
         Jmq17P7m521ZhmBwDioleYubR/eyZo7RDTtpX4KvEL4djrU1Rt9hKp/d6Z5ds/jf+pud
         uHSkrwgcXrFosTqALbeQVJINF+TC8aN8iT/0CaYyJEclebN5tEC6kOCj+t0H9Pg0E16H
         eFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hBtio2kWm2ZmZbXm583qrie9CbK6m56oOkcfNZxmLIA=;
        b=pCmt+GqInlBvD35hug892D5FNp+NA9g9FaOy9BK1y3SNdKMH/t9nsSlbObON6tDIpY
         aJMsAvfQBZON6wIFYFHq6uOMO7B3wcFLgQhenEaB/GFHvBk3SjiCJfM/2HYwKa/x4aLP
         KgUwzlayHisdM/psQ4YK/o6XNkdpSt4yPhM4NY4G7UxN/TqiRg3VJEYMBF//uNcw2Ppl
         AVJlOQtJxhZSE0H5zGJLKL+PvkRcTlToSWoSdtY4K5MD2U4ZanO1c210ojTV9DHNoGrC
         zM4pCiVpHo/FVMboZKZmkre25FVb9W4vDnBw9qEcZxEErYK+Y8GWlUyurQD7wFRSdRSI
         GjkA==
X-Gm-Message-State: AOAM533soDARrLeG/akBd3PhxIvhl1u0BwqB5xlgmrU3ugQ0qfLWHiIT
        ZGnm49OnuNM2YXsMQIVmN6ohAQ==
X-Google-Smtp-Source: ABdhPJx1M71pb0A2SogerAzACeBbZuVUxfIiHZqNYYGB/6x2sX4kC4VlUuXrp8tuFoY7MvnGnpIb9g==
X-Received: by 2002:a63:d642:0:b0:378:a4c2:7b94 with SMTP id d2-20020a63d642000000b00378a4c27b94mr7304521pgj.218.1646600446002;
        Sun, 06 Mar 2022 13:00:46 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v66-20020a622f45000000b004f129e7767fsm12496895pfv.130.2022.03.06.13.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 13:00:45 -0800 (PST)
Message-ID: <33f74159-3dfa-f0ab-0b55-09916db837e8@kernel.dk>
Date:   Sun, 6 Mar 2022 14:00:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: fix memory ordering when SQPOLL thread goes to
 sleep
Content-Language: en-US
To:     Almog Khaikin <almogkh@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220306103544.96974-1-almogkh@gmail.com>
 <768398e5-4909-6c7a-aee7-f36210f41a8f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <768398e5-4909-6c7a-aee7-f36210f41a8f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/22 6:32 AM, Almog Khaikin wrote:
> On 3/6/22 12:35, Almog Khaikin wrote:
>> Without a full memory barrier between the store to the flags and the
>> load of the SQ tail the two operations can be reordered and this can
>> lead to a situation where the SQPOLL thread goes to sleep while the
>> application writes to the SQ tail and doesn't see the wakeup flag.
>> This memory barrier pairs with a full memory barrier in the application
>> between its store to the SQ tail and its load of the flags.
> 
> The IOPOLL list is internal to the kernel, userspace doesn't interact
> with it. AFAICT it can't cause any races with userspace so the check if
> the list is empty seems unnecessary. The flags and the SQ tail are the
> only things that are shared that can cause any problems when the kernel
> thread goes to sleep so I think it's safe to remove that check.
> 
> The race here can result in a situation where the kernel thread goes to
> sleep while the application updates the SQ tail and doesn't see the
> NEED_WAKEUP flag. Checking the SQ tail after setting the wakeup flag
> along with the full barrier would ensure that either we see the tail
> update or the application sees the wakeup flag. The IOPOLL list doesn't
> tie into any of this.

I think you're mixing up two different things, and even if not, the
IOPOLL change should be a separate change.

The iopoll list check isn't about synchronizing with userspace, it's
about not going to sleep if we have entries to reap. If we're running
with IOPOLL|SQPOLL, then it's the sq poll thread that does the polling
and reaping.

-- 
Jens Axboe

