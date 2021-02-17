Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10BE31E331
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 00:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhBQXpt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 18:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhBQXpo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 18:45:44 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D83C061786
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 15:44:58 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id lu16so168867ejb.9
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 15:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XeJjr58sJrhlQB+LAdjqmsQ3TZhuSViHAJlIArhIHCQ=;
        b=hUDCKelGSpQJXdly8lUubq8TD5KjwPT9sx404Dd6O4v2tEqx+IHABnJnsB8d6+fcwY
         D6N/9+/Bx9tk/At2SMYiuCUY4q7uwzy8vXaxE9RwYi9hd1Q3if17L3NkE+8JBdLFASxQ
         2s5UhUMAcR65sRnsWqM28m3wDIRZFimrwn1Z6b+1zRdAYZtzYvnZC36DACA+2mZ+2ePe
         B7uRwpkFQ50GnOA/zpRmeRXEmMIKzp4UB+KXDE+7cKB1AfAVm0tPUt3d4lZphEz0YwCD
         ySX4qjE/KtWiQ7Fo8T02BeDXoN3QxkxdPxrME36oEB4pdhlyj76sLUkpAGpts9VLvyRK
         hCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XeJjr58sJrhlQB+LAdjqmsQ3TZhuSViHAJlIArhIHCQ=;
        b=IL2fJMTkh3OQCfLTHRbmBiFK43qTOx8H/DzAp07DHKYqEdoMZpHxUP2J/20L3t7d3a
         DlLLhIPrE4uElaF+p6MBvFGKIVAUkOasxbpJxHKRsudhkylJvNuLQQKSPK8hCaP7tlc0
         WjyqWyyawuw+3+CGf/XzYud+MZd8D1sZQPhmj+uN4RrPa3tCI4yEndWe87HmnUIZQ9Gt
         3roFPSKShUouf4zmapV9Fgp4RFTLkmh0VKV8CKeLiHzX8MqKjDBbuI2r6jLrzqWVw4aT
         My356oNkY7Om3BzaP5WQQ/Yz1ptugLJUdTUtIvsTVeX5YUpk6V6tenNIU9RSCezNSxpM
         bWzg==
X-Gm-Message-State: AOAM533QhuGPHNcxSy0WFEhNYATHZbIhvNyp0GgdnxXRhSNxtmfxyq+Z
        Z1kPMq18JEAn89oN8EfxOPa8nR4qjF+AY6dYNSnZGw==
X-Google-Smtp-Source: ABdhPJzn3fD6w2Pyjj3qwn8fLbiIIVQBBK95eHAlD19mGHW88Ntg/qN9mQP60DKbBQBt7B7mNTlV/o+VofRwszqIFmQ=
X-Received: by 2002:a17:906:54c7:: with SMTP id c7mr1275718ejp.161.1613605497733;
 Wed, 17 Feb 2021 15:44:57 -0800 (PST)
MIME-Version: 1.0
References: <20201216225648.48037-1-v@nametag.social> <5869aae1-400c-94a4-523e-e015f386f986@kernel.dk>
 <CAM1kxwiwCsMig+1AJQv0nTDOKjjfBS5eW5rK9xUGmVCWdbQu3A@mail.gmail.com> <2b120310-4c7f-3e60-e333-8236d72faf8d@kernel.dk>
In-Reply-To: <2b120310-4c7f-3e60-e333-8236d72faf8d@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 17 Feb 2021 18:44:46 -0500
Message-ID: <CAM1kxwh20aoMC9eWbU-qBJy3fM9omFwqviYhWq=rnGgABP0EHA@mail.gmail.com>
Subject: Re: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 17, 2020 at 1:45 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/17/20 11:30 AM, Victor Stewart wrote:
> > might this still make it into 5.11?
>
> Doesn't meet the criteria to go in at this point. I sometimes
> make exceptions, but generally speaking, something going into
> 5.11 should have been completed at least a week ago.
>
> So I'd feel more comfortable pushing this to 5.12.

ping. are we still looking at 5.12 for this?

>
> --
> Jens Axboe
>
