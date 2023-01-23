Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0682C67893F
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 22:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjAWVJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 16:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAWVJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 16:09:46 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C7826A8
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 13:09:45 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c26so9833885pfp.10
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 13:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ezlrMeDEO03L4IdW2d0Q6pCB69BUxN8VyJESttsqI2s=;
        b=VL4Rqm6IN09hC5HfF2ePEAKbINQc6RdpAmK0jQyHbIZ4MLf3NgFe7crufUL/7iCXak
         A780UrMpV+Xina7bvZSYsME3jLUvnTcfa+9ZajH7gVI/cFrpyt3Nv3/QV3BkaL6Y6etG
         xb7zn2O7YfAljzZ2Hl+zugSJ5w3gEeZBojngRUfwvkSu708UOq0pfJPj1ZgJDnqYxpmd
         IPYOgvMUUL29pFGyzZtyK6BPNh/jC9/uFMnTJ9i2ymNwUCaoExai5BYMk/VIUzku44LF
         hIo0vGy49Sl8UWYxdrN8MEW4IelEJ22Z0H1Vmr3tt37dESO4dwlo1DFSmo9+JkNZDmW8
         RwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezlrMeDEO03L4IdW2d0Q6pCB69BUxN8VyJESttsqI2s=;
        b=qDZo5EX40U2snDv92y30i99lyKqEoMmCmjapIr2rkrXwhahNwtXJTlTzNCFQ/e7Q1N
         BQKqc97UFRCcWlBX/yCDojclx58xRqkjpyaDQmR3o8Z055HYfXcHgxq8FQfQuhZMLPZ3
         uET/vYew2MYfnCoNh5CJgWBBD1sVIBeJPnEHUGlrc7qYVX77GvsYN2VLzOnEhXcmz53E
         /F7b6mjSvXM7XSmRmRl0TY46TQpU0lLYvt6DUiINriwVKD1ODTyQznnW0QlGiA3d5zj6
         edkWtnPxOUUrEwo6nvArkvN9PFyxLBaboJi1QoFyZR/mGeW5bwSLi7qbn2HVBMkZ0mXT
         2E8g==
X-Gm-Message-State: AFqh2krkd6mx3CipO+5wVLz+Hu7fY2tWzGA7Y/2KK1wPdZsemmF55gZS
        Rr5ksOIglbJtpBue5EkhK+b7KQ==
X-Google-Smtp-Source: AMrXdXvTb2iDzJ+QRN9BiB2QEGF6aKE/xKqrjcqf9SgCwjk83Y3mSi5DJtz9uVWiIBhrhuohyZ+1ag==
X-Received: by 2002:aa7:8c51:0:b0:582:d97d:debc with SMTP id e17-20020aa78c51000000b00582d97ddebcmr6598131pfd.3.1674508184661;
        Mon, 23 Jan 2023 13:09:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a7-20020a62d407000000b0058c8bf500bcsm36414pfh.72.2023.01.23.13.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 13:09:44 -0800 (PST)
Message-ID: <dbf9d6bc-b8d5-5b7f-5591-44b71ff42c63@kernel.dk>
Date:   Mon, 23 Jan 2023 14:09:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/7] io_uring: use user visible tail in
 io_uring_poll()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1674484266.git.asml.silence@gmail.com>
 <228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com>
 <bb8f25a0-d3a1-3e65-24f7-e0e3966c2602@kernel.dk>
 <1575ad4b-d6c0-33e2-9dab-046094fd7b43@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1575ad4b-d6c0-33e2-9dab-046094fd7b43@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/23/23 1:56 PM, Pavel Begunkov wrote:
> On 1/23/23 18:25, Jens Axboe wrote:
>> On 1/23/23 7:37 AM, Pavel Begunkov wrote:
>>> We return POLLIN from io_uring_poll() depending on whether there are
>>> CQEs for the userspace, and so we should use the user visible tail
>>> pointer instead of a transient cached value.
>>
>> Should we mark this one for stable as well?
> Yeah, we can. It makes it to overestimate the number of ready CQEs
> and causes spurious POLLINs, but should be extremely rare and happen
> only on queue (but not wq wake up).

Right, it's not critical, but we may as well.

-- 
Jens Axboe


