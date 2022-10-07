Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD085F7D72
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 20:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJGSgF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 14:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJGSf6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 14:35:58 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C4798371
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 11:35:54 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v134so6452212oie.10
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 11:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Doig6u36W71bCUbBJSEX2qJZRxm5i2XAjO7LTGG98M=;
        b=aGV+JG4WUIiB/u+p6zpDlnkyt+tF8TaDRXHoX6d6aGgf3+Qxdvf/mydjChfa5oMJl9
         GErL/VKOBvoKU4esLvheCXIj1Zw4yNBbfFkEmKwRjGmPXSOIhhjMj2EqYBTs44zo64s8
         F2iMCWuIr9haDTi8/Ob1cx5EAVPOGfY1V70GQhhpYZ3N8iujgQnTuFmeZQuMmxeBAweS
         m81jx0W2WaGLAm+5bd0z9XYvdoi4z5bkk8soaOncZgm1dRdOBhjqIqNhLa2k8jf1XtcK
         eLkid1+rfAM3nGJAuktNR8Sv3X2R/axfYopFtQUGnLHI9kQKRM0TDyIu1rYm8zUI528f
         LdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Doig6u36W71bCUbBJSEX2qJZRxm5i2XAjO7LTGG98M=;
        b=QfxMUBwkAy/uP8/twMzNag83rfXvYfxEIbTT97hAp3PZpz3QdoI2QEiM9bXiFXvoGu
         Yybk0dhHn8fXtV/yFnb1TDv5OOa/6+fGChFOtN7g5aQpgXIxsg5MVIm2GpMOuP6XippZ
         EO6yLizJKO8v1PMkH55HOXpzFR+lz181X8SeNEWw3iKrI32KZq/+rXdZs/YtQbAZ/f3X
         xd7iHnEukSNGPUPahGza4IG9O+LwGpH+RRxM0NMs9Vx3/cccqCEDnFvzZ3Fna+vyxiYx
         jakbV5yX4GPsLHuOSR4Hp7pBkTirPlqGl3yLKBT5MEyjLEhRbI4OiTs4MQR97qkTSn7c
         4T1A==
X-Gm-Message-State: ACrzQf0WvELyqjoKr2NStHVqwDOV+X4BUeNmsQUZl3sq5VmW8QAyPnHd
        5dNQuni2uFiER55G4nIlBsMsKL8AX2BjoK2PdE+N
X-Google-Smtp-Source: AMsMyM79OmTDRVoGxJy5aNurXZSK3SAzhBWdqTGJDJKLJJYgdoSHGPvMEnVf9iTmAZwRwF+d7ZzJxp6lY9YDXkXLKXs=
X-Received: by 2002:a05:6808:218d:b0:354:b8c:f47f with SMTP id
 be13-20020a056808218d00b003540b8cf47fmr3376875oib.172.1665167754282; Fri, 07
 Oct 2022 11:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <cf6cbd11-e0a6-3d5f-bf93-ddc393e39fdd@kernel.dk>
In-Reply-To: <cf6cbd11-e0a6-3d5f-bf93-ddc393e39fdd@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 7 Oct 2022 14:35:46 -0400
Message-ID: <CAHC9VhQYYw4fScp9KSD=RjtKvXj6B1aia6SWnkfeM=U5ekp1Ag@mail.gmail.com>
Subject: Re: [PATCH] io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 7, 2022 at 2:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> The msg variants of sending aren't audited separately, so we should not
> be setting audit_skip for the zerocopy sendmsg variant either.
>
> Fixes: 493108d95f14 ("io_uring/net: zerocopy sendmsg")
> Reported-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks Jens.

Reviewed-by: Paul Moore <paul@paul-moore.com>

-- 
paul-moore.com
