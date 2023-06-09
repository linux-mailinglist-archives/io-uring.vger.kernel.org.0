Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9715728E3B
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 05:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbjFIDCS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 23:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbjFIDCQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 23:02:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F7E30E8
        for <io-uring@vger.kernel.org>; Thu,  8 Jun 2023 20:02:13 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6621a7efe18so288326b3a.1
        for <io-uring@vger.kernel.org>; Thu, 08 Jun 2023 20:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686279733; x=1688871733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tEeS6rlmxEW8bVfn3DmLa8XY88lnp07ncI3qbuOPVsI=;
        b=UY9lwCfiP8GnQ0yBTojtmnJjz7xLqFdz4/gz6Xo4w9y9w/LCD7d6MrvKYtR+GTAUQV
         kwvmWtsulCUOMlfrQ5o6t6wxFCVjbiGmkNA2QIWamiFAPRDwDqEsZsx9ykO2eX5fXl2c
         +YHvOYpdoYtftg8t874hBkSWS+f9RenW1X9QVKxsFS7838XycZS0x2tMpxuU2nFlWnPP
         jzD1MWkb7qsQiwrNz5MP5P0P41x09/zgcOPdLSMojonCU58lAFDRZjh9MNpIJyaJm+xS
         YRInlgNrNkS6ZLdVjO+QWqoZRhybPKvJCtahiTbSQhi2Vwp0OFkpTrjBGHSYZaYqhbfQ
         SyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686279733; x=1688871733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEeS6rlmxEW8bVfn3DmLa8XY88lnp07ncI3qbuOPVsI=;
        b=DhXb8JNRZ7vZiF16DfIhwPPt3FkTSQ4bzb79VmHTk2g2UjEixV3eVVqQW73tT4e6/r
         qPodvhpTeNyMckE3QVAgREstceny3+/rJkxtIylNX9ZABohtbNs3d6oegZe4IOK9jjMl
         ewm0sOArZyGVPqyHSvEMlqgexX0iQyl1y4Q+snguhqDUvKFUGFMJEheyNqQIt/6YAAP8
         MTyiyWDyU1WdVm4+aLQF5UAfMwoX++pyRIYgABTiJ2Lbh+gWh/fZ9x4xEG4cjuCMZF1z
         EyXdejuTkPQH2kJvbgT+prteNjxAakFUGeY7eMJOWgaIaEUUogn9nGy1IAXcQ/Bno10S
         aB6g==
X-Gm-Message-State: AC+VfDy5m7BbwHEtyNnlherephK+lvWzE13w3aFqyNlYDnCP5N1+s0Sm
        g7pINLSw4NgWSyO1lHeqhGGSJw==
X-Google-Smtp-Source: ACHHUZ5X2wCUGMHCSmURL2qsiu6cMZfXWWt4NRYPP7XBKh++q2QsceLCfIoMttOcEyybQTfD+hvSqg==
X-Received: by 2002:a05:6a00:ad6:b0:643:a903:f1b8 with SMTP id c22-20020a056a000ad600b00643a903f1b8mr162438pfl.1.1686279732935;
        Thu, 08 Jun 2023 20:02:12 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j11-20020aa783cb000000b006475f831838sm1707433pfn.30.2023.06.08.20.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 20:02:11 -0700 (PDT)
Message-ID: <2a424ca6-5d5d-5e81-fd3a-b25cdd25c690@kernel.dk>
Date:   Thu, 8 Jun 2023 21:02:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH liburing v1 0/2] Fixes for io_uring_for_each_cqe
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/23 7:54 PM, Ammar Faizi wrote:
> Hi Jens,
> 
> Please consider taking these last-minute fixes for liburing-2.4
> release. There are two patches in this series:
> 
> ## 1. man/io_uring_for_each_cqe: Fix return value, title, and typo
> 
>   - Fix the return value. io_uring_for_each_cqe() doesn't return an int.
> 
>   - Fix the title, it was io_uring_wait_cqes(), it should be
>     io_uring_for_each_cqe().
> 
>   - Fix typo: s/io_uring_for_each_cqes/io_uring_for_each_cqe/.
> 
> ## 2. Explicitly tell it's a macro and add an example
> 
> Let the reader directly know that it's not a function, but a macro.
> Also, give a simple example of its usage.

Applied, even though not super critical for release. But this should
be it, I'll announce 2.4 tomorrow.

-- 
Jens Axboe


