Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED6A25386C
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgHZTkx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 15:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgHZTkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 15:40:51 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2911EC061757
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:40:51 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 67so1599087pgd.12
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dSakW77xCiSA5fE92SUgWSBVc4QxiTq31NeLlsC4iFg=;
        b=VWhtWvqrmDlLgP5IoVdxqiPa54SABR3BHMz8veK4DE7RS5r9FdBeTxrta0h0MeqBNj
         MtlYu0R3sWrjlNeBq2vpa4ed25Es3FS2palRH/FeV8ZVJ7p0W3xyPaDQTfr24TqanHmn
         LFLB1QRKPHSwsqeXR/wncpgGF5/+A4Dm3qZ7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSakW77xCiSA5fE92SUgWSBVc4QxiTq31NeLlsC4iFg=;
        b=NmNZK9Z0Bu2aMmx+wy4Lh1w1Rk0M7Ankq1HFVHxCS9x+8+oVaT2PkYz4ER8W8i6Inq
         eoys1RBe8ihA2FeaMMtbEDhgrrb3LrttEx18sQLwWNxGuyVEBkPGzq19ntyKM9gIYEq+
         smH/PJUaLJHClpgR44uNQhNnQIwX2rNXVwuaGXXzasdJULgG+WDhQj9V3jRGgR88XTpR
         pLCrVUDQzvpM0VS5CZKj9xudFBnIiCj2/x5/KgL4SEQfZaA2GWC7r9/hbDDtrrBSXOR+
         /jBQEu4kdnIa4mQycZsTFbVrmHE1PznzzhbuzTvXiRuAaQCRGJ7wtaB6M/lU1ZBgnos9
         RUXA==
X-Gm-Message-State: AOAM532+JaGQb5C7o1zbnb2//Fq00BmnVv7JQLio4K3TMvolyUk/avts
        9QsugaKMbvbr97LP3Gx7PAxIRw==
X-Google-Smtp-Source: ABdhPJyXEKxXHXf5cRg3/3OzMrYtkIyhnNNSdxI6Puywl/QUiLpeWpXICM+kla3UsLYeJUISDEHNYg==
X-Received: by 2002:a63:cd56:: with SMTP id a22mr11535786pgj.259.1598470850778;
        Wed, 26 Aug 2020 12:40:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a13sm3048078pgn.17.2020.08.26.12.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 12:40:49 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:40:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <202008261240.CC4BAB0CBD@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-2-sgarzare@redhat.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
> The enumeration allows us to keep track of the last
> io_uring_register(2) opcode available.
> 
> Behaviour and opcodes names don't change.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
