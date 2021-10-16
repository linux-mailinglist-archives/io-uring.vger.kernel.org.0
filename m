Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731AE430594
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbhJPXOm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbhJPXOm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:14:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC58C061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:12:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z20so53971822edc.13
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FPT8H+HkOPrjhtY93J9JFgQ57oMrkehXKMRNXwM13ls=;
        b=qTG5252vB7ukRlqOHhWgpAEX2KsB8/rquKZ1r37LO6BD48ObB+npSl2K5EcFJq3VBW
         8W0U2YYvQyUY99rjgfH4VOLGeCvT/iCAopGaBsOJSWDxUz+gktSDdiiZZvIlimMAnyzv
         6on8L/lECV4fNoMceuR7iE3yL2BmDjXibuhtpHEhXZjHLeoJcoWCFAlLhjCTh5KCfvkq
         xoJSZ08YMaK3F9XxV86Vgkt8jB/pJzknJOJyNDaY/5LX+Rnj+SV5nIUNdyduuH9QDlkh
         MX6mhosol/3Mo4k0uTXNgN5PEhNHXZNOjTGZeerYPcCFZHmnJC0OVwBgK7+BebwlYomu
         Q5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FPT8H+HkOPrjhtY93J9JFgQ57oMrkehXKMRNXwM13ls=;
        b=3KR6qATjGs5dTqbD/EegkaY9jiaUfkwUj4+KwIjgJyEnCInx9qbOI8JO0gsaYBfpwl
         6uwUzDpWeAoWPyry21IIwxej+Y3dd/iqiwIrU3Ah4lpYEcwKcVikBeQE+2GXvX86vgm2
         OWj0V+jhRHnY/PruRuBX3IpGfQcPcDSQuJIUV63Uipr7SSh3akvcw3ZsF/HqiWnSblbR
         piGinHUtBZYLdTkF4ntdZ/ftXZXUb4/iABs+bmKeV8eq2HG3qUT2esDl30BCSngZ0cap
         JPkLqfPYFdkLVLBrsokHeUSgfrMDW/fmHB8JCAt7KT1bOZhntvcxAFIoGSKeUuNx3VkW
         q8Cg==
X-Gm-Message-State: AOAM530ozyrshoo2I4kfudFKJSzrQQ8hm9TOn0BC9E+UJ6bLAfLw2/FN
        KpH9KrHn48FVqoSgulbi6nKT941JWGM9Eg==
X-Google-Smtp-Source: ABdhPJzTlWZGE5PnVWGehoQU9QoXjXffQ6uZuk3VrY8OcW4H/hPEEJy/XCsEmbyQGiJsUukTkZOH8Q==
X-Received: by 2002:a17:906:5e17:: with SMTP id n23mr17351255eju.258.1634425952117;
        Sat, 16 Oct 2021 16:12:32 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id y30sm7123876ejk.74.2021.10.16.16.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 16:12:31 -0700 (PDT)
Message-ID: <3407648c-f183-f6b5-9a13-4586137e905a@gmail.com>
Date:   Sun, 17 Oct 2021 00:11:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 0/3] rw optimisation partial resend
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634425438.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1634425438.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/17/21 00:07, Pavel Begunkov wrote:
> Screwed commit messages with rebase, it returns back the intended
> structure: splitting 1/3 as a separate patch, 2/3 gets an actual
> explanation.

Ok, let me resend it with changes Noah mentioned


> Also, merge a change reported by kernel test robot about
> set but not used variable rw.
> 
> Pavel Begunkov (3):
>    io_uring: arm poll for non-nowait files
>    io_uring: combine REQ_F_NOWAIT_{READ,WRITE} flags
>    io_uring: simplify io_file_supports_nowait()
> 
>   fs/io_uring.c | 88 +++++++++++++++++++++------------------------------
>   1 file changed, 36 insertions(+), 52 deletions(-)
> 

-- 
Pavel Begunkov
