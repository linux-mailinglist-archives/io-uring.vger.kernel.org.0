Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C764C1F53
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 00:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiBWXHT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Feb 2022 18:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244712AbiBWXHS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Feb 2022 18:07:18 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669935DF2
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:06:49 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id r187-20020a1c2bc4000000b003810e6b192aso44928wmr.1
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lnITPqwcbF4xDj8afflrnDi00eUm+sr8ZvJa9lEfI7M=;
        b=F6w6diGlO7nit6vm+PoA3GpP2E+W9odrqXnqSkaYXcYBuZbIkc7Du8boQp9r60yAfs
         KrduPsFn1meWfX7CwHjOiA0MR3XO3dWfNjhVvoqfzFmx2efP4fBKJ2a0BWHgnbR3BkKC
         AtdXOTL7JqGFe9C+vVu0U6HJ8SAxhe+cMOqaroX+4XPpeh+ZnXA6NdDNBCsy1Eymqnxu
         v+AKKhn2RlTDFf0SBJ6KtQyK6oKpNhZzJ0ohHQh6KdcOQ0zaui/7vTxChLxTFSKcH9ZN
         QaX+AwCfHr7tlLf4ruuUNFrb+hG+3N++pdWOlvf9TNzaeMop3dRG2sPQISUlxqsKcb4p
         Jarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lnITPqwcbF4xDj8afflrnDi00eUm+sr8ZvJa9lEfI7M=;
        b=UFYaW4eruo29ZHZf0AeCk5VzpS8+gK34vQZxiOsTy7jYGXpvIFp8sVFFGWGGyx0o6F
         tF79rPZ+KguVixdtk0IYXcKY9rUwUV+WpCOlDatdiRkOEt8dciA30hNRVeJiw3JUJ0iB
         IlLfogOPnzONSLiZsGaiGrfBI0BqlfdufAmpww3h1xs1tghN78+zoYHjcVeOLXPN7p5K
         uYd/BtpP/H2TOMPZq07rcKtigvTlRd5/IZewPJVpmEYegI4o3NRTPSlgc3st2Lef79rp
         hYSI6nqMmUUbJaygpjwwG99p5u7IWYuhkkP4hkBIcBfIM/+wXasBcy3hW4emFC/FLIhj
         XhLA==
X-Gm-Message-State: AOAM533pX7reOZfPQmBA8aVVtTCll4gmNKl1fgrB3gWgzDgNlz2H1eWQ
        qRHdaW3Y++xJK0+hrpumHbQCmVCdEXw=
X-Google-Smtp-Source: ABdhPJx8OTFxpKPyOeusbrW0zkzLNJBB9wNTIJyXD2gz+Q8RCC4zPggb/b2XgFKA4udcOXqQRsgOsw==
X-Received: by 2002:a7b:c001:0:b0:37d:409d:624d with SMTP id c1-20020a7bc001000000b0037d409d624dmr6466wmb.64.1645657607419;
        Wed, 23 Feb 2022 15:06:47 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.236])
        by smtp.gmail.com with ESMTPSA id p8sm794156wro.106.2022.02.23.15.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:06:47 -0800 (PST)
Message-ID: <e80c7f0a-a4f2-9343-5e7e-b09f71bb8ead@gmail.com>
Date:   Wed, 23 Feb 2022 23:06:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 1/4] io_uring: remove duplicated calls to io_kiocb_ppos
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220222105504.3331010-1-dylany@fb.com>
 <20220222105504.3331010-2-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220222105504.3331010-2-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/22 10:55, Dylan Yudaken wrote:
> io_kiocb_ppos is called in both branches, and it seems that the compiler
> does not fuse this. Fusing removes a few bytes from loop_rw_iter.
> 
> Before:
> $ nm -S fs/io_uring.o | grep loop_rw_iter
> 0000000000002430 0000000000000124 t loop_rw_iter
> 
> After:
> $ nm -S fs/io_uring.o | grep loop_rw_iter
> 0000000000002430 000000000000010d t loop_rw_iter

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov
