Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A90424351
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhJFQul (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 12:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhJFQuk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 12:50:40 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1A3C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 09:48:48 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id d11so3509523ilc.8
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 09:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RDYnh6EcREg8/N/kW1V0pwhFkyos4jq5uRnxmjGqXIo=;
        b=TKjq7VR7ygugTUUOpKyqjQa+9ih9Y9cF0GxWrfYBdf9JkbZ9HU8JzeXpRoqFhylDUa
         TArTqYV933mwjfdIuXY8bEeZqJCnBzLJF4FFf3ok4I/k3FVXXZKE7liIMxfSdCT1+fq0
         mFBfMvl48oTxhn22Oxq0Rney1tDUw4iqMRC9+KsET+wURz0ojw89XF39kn7tJKjwem3h
         9df+SFeDJldSU85Tgqg1vvdjwGm24B6xPFiklgJSy+CVgkxT4oYDeHbqnXRN7YtY/Hbz
         CB/9L+DDDuA/Q+vMi0pP9nSWXtc2PEGlIVXBM7p12N+0QxJs/x7d8QT7R52kbWdAfV/Y
         giNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDYnh6EcREg8/N/kW1V0pwhFkyos4jq5uRnxmjGqXIo=;
        b=lxfuKhALgY+fXXzcAo0OzaS6ySRsc9bpYeVbSKa9Xy+wcNjFxbfUukVScIkQzrNc8U
         DUT6LQT7cdGOJUsfNJrd/grtmpB2Iyyzn1mLpUZ0SkxrdrXIXJUPTzdrVbJF3KshTM8L
         VSi6VGn6j2XJN5LJsSmrteGhlIalEvuWbhctAgdEHTr2Yq9b98Wvala2FeNnS5CDerov
         pmZrQzCVrU1BEJQ/GMT8Q3QuHUGi4f9ZGbfdgYg3pvs2MeicPp8ZIYma9nOwv/NDwiq+
         KRK333ETkBNvfpdzay6vg5cG+lV7SW8HUbVZTjpSHnmPRR2m/AgU69aBpNij+eD0YzxC
         XuFQ==
X-Gm-Message-State: AOAM533w88/YYvzH3Dz14v2+8UM8o7V7y+dGFsnCRXe6RRtmQxRuLqzX
        jJzhzFULgM646/988j6a22JfXtIudT3A/fvDiCs=
X-Google-Smtp-Source: ABdhPJwbPZPrDCOp9R4xQQ21y31FAcpPPCEOQZ9lNcAyiuu0lA9jCty0i7I6aT5F/Fk7Mxa2FVgbJw==
X-Received: by 2002:a92:c241:: with SMTP id k1mr6156563ilo.258.1633538927329;
        Wed, 06 Oct 2021 09:48:47 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o5sm12976670ilk.88.2021.10.06.09.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 09:48:46 -0700 (PDT)
Subject: Re: [PATCH 4/5] io_uring: optimise out req->opcode reloading
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1633532552.git.asml.silence@gmail.com>
 <6ba869f5f8b7b0f991c87fdf089f0abf87cbe06b.1633532552.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6dc5a0c8-ac30-e4ee-4833-74a25fac2dc9@kernel.dk>
Date:   Wed, 6 Oct 2021 10:48:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6ba869f5f8b7b0f991c87fdf089f0abf87cbe06b.1633532552.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/21 9:06 AM, Pavel Begunkov wrote:
> Looking at the assembly, the compiler decided to reload req->opcode in
> io_op_defs[opcode].needs_file instead of one it had in a register, so
> store it in a temp variable so it can be optimised out. Also move the
> personality block later, it's better for spilling/etc. as it only
> depends on @sqe, which we're keeping anyway.
> 
> By the way, zero req->opcode if it over IORING_OP_LAST, not a problem,
> at the moment but is safer.

That had me a bit worried, but you mean it's reloading req->opcode,
not sqe->opcode. Phew.

-- 
Jens Axboe

