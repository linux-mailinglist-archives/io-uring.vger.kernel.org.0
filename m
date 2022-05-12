Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F659524C96
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 14:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353619AbiELMVY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 08:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353623AbiELMVX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 08:21:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEAC6162A
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:21:22 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 202so4425667pgc.9
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Jgm8O8QZGGLjUWsD23VHBOnQF7wIvt3edd/9XoWMzcU=;
        b=juxKek8KLq57IuDoeCVxD1MW+MnPDdbkH7xLyUUk4e4h5EB/BfI1umGD3SG4XLSnBm
         nxz4w7SXVNYER069+B8cInWuQpa6p3ktEqMJya3Dz179u8l38J9MGJilFYpc7dXkXMc3
         AJoWj8yKGBZjvlb8z5Dwyqysnxyj+yXF3CXBdXWUGuj+mGsgkc0frCnzB0qQProF4MoB
         uMDWtrmK+bEwJaQOmr1tsU6FxeshEwEFMQ9usC83cKbd40mQe5avw0H97vfzU4lQ7FMK
         OLBemcxYt4u4pD/p/7VN/jKSpQzpshhL3cxDl6ZVHcJuCGVgnBbbjiOyMgrhIRG8oqOX
         0tFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jgm8O8QZGGLjUWsD23VHBOnQF7wIvt3edd/9XoWMzcU=;
        b=hkDsaRhUTw4KrJcm4AK6MRRzxLDG39D0qShbGAGS+xVxaZz8Pz3jXeaLX4UjxcaFV1
         BXuCDnkXS+EhJGaDX8DaSTJW2MM/M+N4PFi6AZAGpczB2iKZuMGN+dpPWwhxRQMLqb03
         7xhcjV5kV3D6HgyK/vg8MAvu1OGInDgXj1KIldr8kpVqUVtkwcXvOLYAMJPRHmoIqEtx
         1k4bqjCZsJFzNyQ0oipSSEiGJbBxX/fzsFwEk+w42Bp7rlWTNfXz5VU+soNaSRNaN1gA
         fJ2uqOHOhM4bqqyp5GnB2D1mJHk+WWQGq26cuE51JLxdWUn9sfMKqAKQ8o5FhoqXa0gy
         AbjA==
X-Gm-Message-State: AOAM532h1ep8B1jzVZa9OIdOSTtyGlYJ1vnq3F78xMed6EmQFNOAAdsx
        MHGqSTziuiIx9OfV/LgDosWOsQ==
X-Google-Smtp-Source: ABdhPJyxNnUrVAwCXlEhKqTYnXL1NS8M/Xz/9h5vBdFJvEbq+nNoBYUOZuexz28QXw63vGphXJn9Ww==
X-Received: by 2002:a63:5151:0:b0:3db:6074:1180 with SMTP id r17-20020a635151000000b003db60741180mr2609998pgl.310.1652358081523;
        Thu, 12 May 2022 05:21:21 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v4-20020aa78504000000b0050dc762819esm3639779pfn.120.2022.05.12.05.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 05:21:20 -0700 (PDT)
Message-ID: <7427ccc1-c830-56c1-1577-dee5afff3809@kernel.dk>
Date:   Thu, 12 May 2022 06:21:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: Fix incorrect variable type in
 io_fixed_fd_install
Content-Language: en-US
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220512120511.4306-1-wanjiabing@vivo.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220512120511.4306-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/22 6:05 AM, Wan Jiabing wrote:
> Fix following coccicheck warning:
> fs/io_uring.c:5352:15-24: WARNING: Unsigned expression compared with zero: file_slot < 0
> 
> 'file_slot' is an unsigned variable and it can't be less than 0.
> Use 'ret' instead to check the error code from io_file_bitmap_get().
> 
> And using bool to declare 'alloc_slot' makes the code better.  

Thanks, I'm going to fold this one in.

-- 
Jens Axboe

