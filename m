Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081916873AD
	for <lists+io-uring@lfdr.de>; Thu,  2 Feb 2023 04:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBBDJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Feb 2023 22:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBBDJt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Feb 2023 22:09:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBCE21A0F
        for <io-uring@vger.kernel.org>; Wed,  1 Feb 2023 19:09:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so529326pjb.3
        for <io-uring@vger.kernel.org>; Wed, 01 Feb 2023 19:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v56d64UOQ5DflLEUCFTh9OlMNKwgkvfK5crZpl/V8xo=;
        b=pp9Z8Y2rljuxDInBBbuH00+OrKR6edc8euavxs0lrCDRIUwXynIVx0+acaKzhrGE2J
         3NiTNfZStwCpbzVPnlkAP4xbpFceMM6kyQa7ERIIwbwg+ctUermqEbcoyG+W44nElv2A
         viGT2TdPPMRQJikuO+71uAYRgN2VJXzOVhMlVCO+mDXc4lNdOIH6dhGvw+V0v1Ctfato
         wJGw8kAr4GK3S4X/JimZV9uiPJbO5IXORa9vEtm99Kvig/BnZAfQ1Nsd0oFt6+q7iFKy
         m5nblmPLTFG4fZtbF19bGlfgNdacS1QVScR3UaPPHTYJqz1cUWDGgMda6XXfxiObJrkk
         Okjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v56d64UOQ5DflLEUCFTh9OlMNKwgkvfK5crZpl/V8xo=;
        b=vPYaW9hep/d/k7fPtoLL8H/W57+LgJhPF1RGH0y5rGDt1n7mlCFoKyfgIjr8yFFW39
         F6JzSEFIJgYkUtIBNXPAY99J2dxY1XuZxHagK6oZKKbZTWPgD+QQSBCyZb5SGmpktIma
         BBEYeY5BPJ6mYoeEtZlE4SR9RDwY10z5HYz/xAnhjbClPXNVqB8MGu4dCpiL4JV+uF2p
         O+n62/AyDsa6i7Olkz04mE4dVpt/oNo0PxPr2+80vJ0PpAiMcOGEh/9W+7deRTFf75Pk
         QaPQjHMyybeeaxv3vUUjRS63061i6njiBuzQGr+p1R8itGdbDidUJEIMfF9nIZV68BzB
         i8dw==
X-Gm-Message-State: AO0yUKUfemvCMJDAt61SclNsgQT7mSPsJRtHE9gc9SUXX+caJk6zieXU
        ivS6dUAX7HIJjKNOJirYADFeythu5Ajs/ty2
X-Google-Smtp-Source: AK7set9S77NTmxYcdEajMZRRUaeIbwGcAjCHmjlGDPBVDt8jvQF+1Oi/1FA9+G54mEDMUkNY9W94xg==
X-Received: by 2002:a17:90a:d517:b0:22c:90b3:412c with SMTP id t23-20020a17090ad51700b0022c90b3412cmr4308095pju.1.1675307387522;
        Wed, 01 Feb 2023 19:09:47 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t6-20020a637806000000b004d2f344430bsm6451979pgc.75.2023.02.01.19.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 19:09:46 -0800 (PST)
Message-ID: <594dabc4-f68b-d204-a04b-c041556f1c8e@kernel.dk>
Date:   Wed, 1 Feb 2023 20:09:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [GIT PULL] Upgrade to clang-17 (for liburing's CI)
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <a9aac5c7-425d-8011-3c7c-c08dfd7d7c2f@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a9aac5c7-425d-8011-3c7c-c08dfd7d7c2f@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/23 11:30 AM, Ammar Faizi wrote:
> Hi Jens,
> 
> clang-17 is now available. Upgrade the clang version in the liburing's
> CI to clang-17.
> 
> Two prep patches to address `-Wextra-semi-stmt` warnings:
> 
>   - Remove unnecessary semicolon (Alviro)
> 
>   - Wrap the CHECK() macro with a do-while statement (Alviro)
> 
> A patch for the CI:
> 
>   - Upgrade the clang version to 17 and append -Wextra-semi-stmt (me)
> 
> Please pull!
> 
> The following changes since commit 313aece03ab7dc7447a19cff5b5f542d0c1b2a1e:
> 
>   multicqes_drain: make trigger event wait before reading (2023-01-30 09:26:42 -0700)
> 
> are available in the Git repository at:
> 
>   https://github.com/ammarfaizi2/liburing.git tags/upgrade-to-clang17-2023-02-02
> 
> for you to fetch changes up to c1b65520c05413dbf8aa4ed892dbe730a8379de3:
> 
>   github: Upgrade the clang version to 17 (2023-02-02 01:12:17 +0700)
> 
> ----------------------------------------------------------------
> Pull CI updates from Ammar Faizi:
> 
>   Two prep patches to address `-Wextra-semi-stmt` warnings:
> 
>     - Remove unnecessary semicolon (Alviro)
> 
>     - Wrap the CHECK() macro with a do-while statement (Alviro)
> 
>   A patch for the CI:
> 
>     - Upgrade the clang version to 17 and append -Wextra-semi-stmt (me)

Pulled, thanks.

-- 
Jens Axboe


