Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C256F74FAD1
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 00:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjGKWSV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 18:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjGKWST (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 18:18:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3BD170C
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 15:18:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-676cc97ca74so1411959b3a.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689113895; x=1689718695;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r0QKuY6Gac4KtjHpQUjYNNJL6kvnxIXVmhMZHPYzaPQ=;
        b=nEcWXQ1/do+JQ+fqs5nhW1aTSCZ1LlPzD6//MeTmoL2r47x5l54/InYcck7bFm+9oO
         djVAk9evNEykAAqXZICjMVLhWFrC6VOWDsgJircdNV8DpVowDLSzt6dxoAO8QZNuesLR
         3BfZ9k6FCo6LlCk1DvutIvnTSeeGBXZV3oSc9LRvHNdVG2c2bWyp8RvmR34V8ok0Pdq8
         o/ZP8dQ4iPv9iye0vE+S8uplfMGd5BLSjK7H3ZG8nz4Jtthn5xrgavwpAYv80Z1dcabR
         FBX/0SaMRgYDWOEXq2np0ld6UX/0TvA2KYmT98Uv0BhQOZtxWlebgOkGZCfXRJl187+u
         xfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689113895; x=1689718695;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0QKuY6Gac4KtjHpQUjYNNJL6kvnxIXVmhMZHPYzaPQ=;
        b=UCgJB/TAO14MTU8xaeJwVTisE7VmNR4cdpo+e+qpw3aM0yAuGSVOw5JNqLdDTnzcFI
         AAYFvA0KmCk73foBSL1rjd14p4GNp8s1QhvGsbYuDEo2yZPaVSoDtaFQDnX4LzR4lS/z
         QsSPQpntG+gfxnaPWlJR7l4LCsYOyk9yhJMt3gdUSlrXpMwZho+E7w1v9/NLcSgg14RA
         ZMsqEc4zxe1fsDHnO7ExEPuvfTtWHAUWwGflOTezwFr7zMgqXlI20schc1c6MiJRSzvC
         FcYTTnWV2y8zE0diz0ez+QU73lmahFXcIcx693b/cE2gtEYRZvwXfy/HqFfTSbtF1E4D
         jgIg==
X-Gm-Message-State: ABy/qLaqK0r7HXE0y0u/q8Jx/6N3fuxQPINsfdqtEgjum79npa8AxoOD
        g5NDuJk08oOz2MoN3SwgtP1X6g==
X-Google-Smtp-Source: APBJJlH1fB38TaeaX141/fYrGihQI6HUMtyNJ0dTyUnoqY0SEef9M8W+D+0os7O9mzigAXwQpsUtbQ==
X-Received: by 2002:a17:902:da92:b0:1b8:35fa:cdcc with SMTP id j18-20020a170902da9200b001b835facdccmr21713869plx.5.1689113895139;
        Tue, 11 Jul 2023 15:18:15 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jc17-20020a17090325d100b001b9dfa946b4sm2441594plb.49.2023.07.11.15.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 15:18:14 -0700 (PDT)
Message-ID: <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
Date:   Tue, 11 Jul 2023 16:18:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Brauner <brauner@kernel.org>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
In-Reply-To: <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 3:22 PM, Jens Axboe wrote:
> On 7/11/23 3:11?PM, Arnd Bergmann wrote:
>> On Tue, Jul 11, 2023, at 22:43, Jens Axboe wrote:
>>> This adds support for an async version of waitid(2), in a fully async
>>> version. If an event isn't immediately available, wait for a callback
>>> to trigger a retry.
>>>
>>> The format of the sqe is as follows:
>>>
>>> sqe->len		The 'which', the idtype being queried/waited for.
>>> sqe->fd			The 'pid' (or id) being waited for.
>>> sqe->file_index		The 'options' being set.
>>> sqe->addr2		A pointer to siginfo_t, if any, being filled in.
>>>
>>> buf_index, add3, and waitid_flags are reserved/unused for now.
>>> waitid_flags will be used for options for this request type. One
>>> interesting use case may be to add multi-shot support, so that the
>>> request stays armed and posts a notification every time a monitored
>>> process state change occurs.
>>>
>>> Note that this does not support rusage, on Arnd's recommendation.
>>>
>>> See the waitid(2) man page for details on the arguments.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> Does this require argument conversion for compat tasks?
>>
>> Even without the rusage argument, I think the siginfo
>> remains incompatible with 32-bit tasks, unfortunately.
> 
> Hmm yes good point, if compat_siginfo and siginfo are different, then it
> does need handling for that. Would be a trivial addition, I'll make that
> change. Thanks Arnd!

Should be fixed in the current version:

https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc

-- 
Jens Axboe


