Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB26593213
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiHOPhT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 11:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiHOPhS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 11:37:18 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601C013D16
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 08:37:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso7412737wmh.5
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 08:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WyrTtCZhfkOHQrs+WaWQ9j6AAmubpROGoMrrEfYozzE=;
        b=a2u1NYTFwyvzymeXwhFd58UhFtNT6dk7rOnASjdb7Y/ptgO4h+OWlrV7dH3o/rwf1/
         86WZZQhODduHb1hVtW7G1nXkSueSgHvpzlhUaSH3XRgPuvK6NMTMMbG0psPhAQbbIyZ4
         4FrjHSN7zFciUuWBUr/0ivtGnN6xO3k2I6xexDB9hhFyjsCmcJhVtKBQ2zCphqtHciKL
         5uceeFkb/gCRETFXtfzxcuu2+WcQ3MqHM6/4zIVR38dt8cR2aeFfK1dFMcMUEeUJfUol
         7Kere+A6is9Up9jl6EoC+NCvAezhOxLWakSirrHs+4FOQInY9vk/bKwcDFam8+UDRAhc
         enyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WyrTtCZhfkOHQrs+WaWQ9j6AAmubpROGoMrrEfYozzE=;
        b=3XQOurAuxzrhO77ddW7vx9QyHaUZT9S6jjllOhgxHcKTO1yQonkmQ7ygClHTva2f39
         ZnJ6/L5LXSMRTB+UgTt4n2mnHEMwv70WufItO2oWZSY/U5mY7afHnMs1qQdG+/B2guaK
         JvIwLPiNnYHeRzxT3FSzidfmhY9hc1C9HKFteeOilgwLtVw4G4dpMf0q/g2TZqJo1qac
         Dj14vp3iOmmUupFMpkJ929NuYf//1d6lAbn/YlGCsAYApma1TYPmao8z4ql/TOwuZZn7
         quzfb7zebO6jq1g0f8Z6EmryH7v5BFav2uLHk/vXjIeL+ciZC8cSWB0qX2EqbhLyfk2+
         Vhzw==
X-Gm-Message-State: ACgBeo2J27CMkwzSpxeoWv8u/XViVnCizmz4CIqB0CuYilrN8ZmerSiQ
        JVgRbET6ustBKB/YHDWypE/+qRD/F5k=
X-Google-Smtp-Source: AA6agR7qCGrC85whACIVNH3OgqtSeqdNn9r6cIVuMDxkl9m3SzAKAWdSlzD2NCA/bqF2jj8AukNxFw==
X-Received: by 2002:a1c:4c0d:0:b0:3a5:98fa:3a4a with SMTP id z13-20020a1c4c0d000000b003a598fa3a4amr10621582wmf.92.1660577836007;
        Mon, 15 Aug 2022 08:37:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b003a5c064717csm10765384wmq.22.2022.08.15.08.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 08:37:15 -0700 (PDT)
Message-ID: <40332618-3ab6-2ffa-d4f6-5f3b1d8e7dc2@gmail.com>
Date:   Mon, 15 Aug 2022 16:36:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH for-next 5/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220815130911.988014-1-dylany@fb.com>
 <20220815130911.988014-6-dylany@fb.com>
 <d86f4994-cc30-720f-8fa7-3a5a11508a57@gmail.com>
 <dc60a26605dd4cc29fe3bf7c7a67eb687fa82a4b.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dc60a26605dd4cc29fe3bf7c7a67eb687fa82a4b.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/22 16:25, Dylan Yudaken wrote:
> On Mon, 2022-08-15 at 15:02 +0100, Pavel Begunkov wrote:
>> On 8/15/22 14:09, Dylan Yudaken wrote:
[...]
>> Not same thread group, they have to be executed by the same thread.
>> One of the assumptions is that current->io_uring is the same
>> as the request was initialised with.
> 
> How do the wq paths work in that case? I can see in io_queue_iowq that
> we only check for same_thread_group.

It's under WARN_ON_ONCE() and should never happen, otherwise
there is a bug. iowq would io_req_complete_post() to complete.

> If required to be the same task we'd probably want to enforce
> IORING_SETUP_SINGLE_ISSUER for this flag (not a big problem).

And I guess also make sure it's not run by a different task
on the waiting side or so.

-- 
Pavel Begunkov
