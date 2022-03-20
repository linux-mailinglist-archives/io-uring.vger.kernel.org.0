Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48D04E1D9E
	for <lists+io-uring@lfdr.de>; Sun, 20 Mar 2022 20:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiCTTol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Mar 2022 15:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiCTTok (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Mar 2022 15:44:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE136268
        for <io-uring@vger.kernel.org>; Sun, 20 Mar 2022 12:43:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q5so1825869plg.3
        for <io-uring@vger.kernel.org>; Sun, 20 Mar 2022 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=SDmZQ0cr10keryOWCbDkCO1R9InD/hWx8d7xUKH+0bs=;
        b=SxVpLWHZEFsHaXSnmb4Gs/mjxn+9VpXg5dngQsmNjnTmk8aGuq2q0x0lBJI86ixxfU
         dqz+w0oSt39adCe2Zbby6Chu4niM+mGCv0R8OJZvN7x/+QSJe3amkU1VTs3P13UI/Qap
         GJiQGAfk0R7kAo6igtMGhJmrUphA8yih5gAa26flPlojlluacmC0MiLOaec9cQPadR2i
         7bRu73r31DXjtmHMtYNQ8GQbijzdxvPPyS8xRuM1/Ely7eT4p5EY5irQxMl6D/zNzeTf
         ET33b0AJIxF+qQ04ag4d3DMTWzVl6cCAfYkrrTSwxZIM8xF/i9SnBdSFGwxegcdERIUu
         Airg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=SDmZQ0cr10keryOWCbDkCO1R9InD/hWx8d7xUKH+0bs=;
        b=KJuSUiLbbU9+V5NCtEU7nCcH/4XxgCSHVme8XDHltvAlYV7pzcEl4i4IX41ADjOmnf
         DgPNyau03mm4r6lMAXv1k/kubGHLSvhdTZYp7DltQhFYfwg15pFj+SxchZRGvSHeJGnn
         mZbFtZGSdylQKrylnv5rsFxlDF3LTaPHq0c0I/UxuHbMauW5hMRUuJkbZtSszwEEd8s7
         qcF4LwmnDLIMgLE9LOSJr8Xjx+pc6FJ0kJaM12Mxs5GUH61+rH4no0lD1hP5L9BdZ9oa
         grvfP2RZsBtdHAR+KbY4B5/SS/nKj+0xUilm8cfJWlK+D3AL/cvczc4NxnMzLkaDLtmX
         UFsA==
X-Gm-Message-State: AOAM530sbM8heQBLk+LSr3y/pbK+/wxqI0WHWwQ1HL0IFOmnhT9ALjFg
        bBo147D+GI9es8OQehdG45jyQt6k3s8B3IUe
X-Google-Smtp-Source: ABdhPJyMLPwI9QB/v5HIjnPeP4ZA5XKj68KYzMAUte0DvCZVm+wBu8Wu3/L+ngPb/jL8PWKCPlcN8Q==
X-Received: by 2002:a17:902:e54d:b0:154:48d5:4201 with SMTP id n13-20020a170902e54d00b0015448d54201mr4289185plf.61.1647805395165;
        Sun, 20 Mar 2022 12:43:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ml16-20020a17090b361000b001c6c9141b0csm5914042pjb.45.2022.03.20.12.43.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 12:43:14 -0700 (PDT)
Message-ID: <31ad4450-d1af-17ec-5e48-ea1eb6d95d0c@kernel.dk>
Date:   Sun, 20 Mar 2022 13:43:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] io_uring: ensure that fsnotify is always called
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <44037852-263b-0110-c5c8-a64cdbcf547e@kernel.dk>
In-Reply-To: <44037852-263b-0110-c5c8-a64cdbcf547e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/22 1:12 PM, Jens Axboe wrote:
> Ensure that we call fsnotify_modify() if we write a file, and that we
> do fsnotify_access() if we read it. This enables anyone using inotify
> on the file to get notified.
> 
> Ditto for fallocate, ensure that fsnotify_modify() is called.

Forgot to put in the patch notes - this is not new for io_uring, aio
never called fsnotify either. But we do have a much broader scope that
aio which is all db and dio. Would be nice to have this be opt-in or
similar, though at least the per-op hit doesn't seem to be that large if
nobody is has a notifier registered (which is 99.99% of the use
cases...).

-- 
Jens Axboe

