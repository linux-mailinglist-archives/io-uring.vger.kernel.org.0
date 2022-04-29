Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9095149CA
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359386AbiD2MvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355224AbiD2MvQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:51:16 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72167C9B7D
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:47:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n14so167509plf.3
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LqkX6XBeIW8TsZdpLdtzQP+p29rZ0uf9pRgwD7D0pIM=;
        b=mpzLDLmTVzRoHeGa90/5vPbjvJXWXjW3wYCr4FQCoM4lTyqQ2gpD4xho2hxFKlU1iz
         jbu8guu6c20Ip9M7TGYljqL+OWrKyDTDvZxz38Xt4FbzybJHcLW9WcSgiNtVr3lt6eNd
         Jd0R2tH+pMK3iWVAD0uIoNWUbxmeJdLxJN7beHE7+qgfNikXnFvknzEt04u4l5yw41yz
         syhEx6JVjTlimyLM2r645sxW20vr5uedumqSGiaNHF+eeoUpg1kmzpUER0m8YyXWMGZy
         K5wGtH6nlgRx6JOVBUDtD9jFX6Syy+DjP1Qo8fC6fCY/aU0uoa4zXyX7Tav8CFrRhXXp
         YCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LqkX6XBeIW8TsZdpLdtzQP+p29rZ0uf9pRgwD7D0pIM=;
        b=s9g2efiggQkThnNvJPNYGaXDoMPxUVsycFgR9Blt3R8MGljm9kVyJgBOuqazHdRJU1
         qenmSaHyoqeMe2UUW4YskgZwpCRS0wal+CKNiXV2Fh8iPmOjfXnvPacHGff1AKkASsl5
         nkAQOlFJRAeSGPwJNLh+dvYTD527+4Z4AgJ1DNu9aBmFxJ+saLNAH8Qdn4/wLYGsNPy1
         6HUhY7tzqs+7Lz2cu2V1HRa0qPbWNxU8b4j0tDZUF5fD6FlZvtLCQXa4Xpt1ZjTG/Wa8
         aBx9fCy8MaFpej5IJL007I+vTUNATPE+NbYxZEmuJNP9NKzDww9FU5U7s8uC75P2BOXV
         FA8w==
X-Gm-Message-State: AOAM533rsKiOgDEwcCMKMF1epPSN3TYgEF5gi5oq6zT7yrdlS5wX+toS
        azYPCwn3LOvS0X5MhTEpBESLdQ==
X-Google-Smtp-Source: ABdhPJzU+qblFR9OFGJ1fY/MfM/OOEVItbbvb3U7IR5ZJe6SfP7SbtD3DpAdOk++ANiUU8TEidxjqQ==
X-Received: by 2002:a17:902:ecd2:b0:15b:618a:2a8f with SMTP id a18-20020a170902ecd200b0015b618a2a8fmr38429433plh.140.1651236477929;
        Fri, 29 Apr 2022 05:47:57 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u19-20020a63b553000000b003c14af50616sm5885047pgo.46.2022.04.29.05.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 05:47:57 -0700 (PDT)
Message-ID: <8f8d07c1-9276-df86-f1dc-3d272d4ab91d@kernel.dk>
Date:   Fri, 29 Apr 2022 06:47:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v1] io_uring: Fix memory leak if file setup fails.
Content-Language: en-US
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429004244.3557063-1-goldstein.w.n@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220429004244.3557063-1-goldstein.w.n@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/22 6:42 PM, Noah Goldstein wrote:
> If `get_unused_fd_flags` files fails (either in setting up `ctx` as
> `tctx->last` or `get_unused_fd_flags`) `ctx` will never be freed.

There's a comment there telling you why, the fput will end up
releasing it just like it would when an application closes it.

> I very well may be missing something (or there may be a double
> free if the failure is after `get_unused_fd_flags`) but looks
> to me to be a memory leak.

Have you tried synthetically reproducing the two failures you're
thinking of and tracing cleanup?

-- 
Jens Axboe

