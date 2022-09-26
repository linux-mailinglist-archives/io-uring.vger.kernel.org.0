Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CB85EAB95
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiIZPsl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiIZPsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:48:05 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EE6326FE
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:34:08 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e205so5385764iof.1
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=amnzRKTju8ts8E/Mss2ZzU05QdI+d+tL1FgGqj/qmBc=;
        b=yXS7zsYtNR43+YCwbYkDKaFwFfeoQ3q3+q+226paPR3iTsnbFk3K0IB4UMP/enXRJj
         1vofYJO8YLEdiVpjz1C0U1tKqniTA6WiMzr716XsQkwDA86pZTV6nGr+LAXEtkE4KOUR
         yVXHYhE9tRdA4XZjly5XrWKUZfF9V5C/g5AWtbmf10KTNfHaS/NZedJqexCnoZs5fVs1
         4b+lD6cVbA4nhP8xrL0B4uak8EcpXj2LlZPl/+XRH8wtOd0eXtxB7oXcXvHJaDVdxQip
         4veS+7wMnIpYI45LQpep+6dZlYdnzN8ug8ExpOnI+i5yN4/xTIiPyms+vDJlLYNmzBLF
         5Wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=amnzRKTju8ts8E/Mss2ZzU05QdI+d+tL1FgGqj/qmBc=;
        b=1wdySPPZc+wxIXNdwivZPCRXCxklWDUqAKKToyA+c3ShEmI5dI0JX1NpAniOUs5uGA
         Af0to/QOBLsWz7YsyIDauz3stibqDZYfoPxWHOkcS+e/SMsHeQbm4nAYQqS3muEC0TS2
         XsP1RFAYCU+GFZYNnDYsVLO64/y2B2oX5xkiDYuIKmK3bH+r8O9OGozp4CzdBQmuC+0x
         PxKguBky6TlEZZfsHUHsBm8HmzgU7JvxP/w1ptBB4FJn5jE4zEQ+mNN38LN9ETDqejkh
         bo4bWujheCBncmHXoQZp9tT3XnZLlGEkeMxN5Aaz4RU+6wGa5YfmUo+J1+FbpYowX2mJ
         DrzA==
X-Gm-Message-State: ACrzQf3Ou0QXgKKz4EBcXWS2IokqKB+jFY79EDZ8ZCKa/vZLx+/0q7+4
        YcCiXvYuW25jF2L1UfqkuTra64KyzLkv0g==
X-Google-Smtp-Source: AMsMyM6zMKrACEPekBLC482ZsUfu0mDGz6c+Nymro8PrXTQDnR/3bDN/4dHreHxbry9SUCSMUP5rxA==
X-Received: by 2002:a05:6638:388a:b0:35a:e02d:ca1e with SMTP id b10-20020a056638388a00b0035ae02dca1emr11815165jav.133.1664202847841;
        Mon, 26 Sep 2022 07:34:07 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z24-20020a027a58000000b0035a196d1e56sm7274052jad.69.2022.09.26.07.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 07:34:07 -0700 (PDT)
Message-ID: <d90fa909-4fdb-c44f-a2ea-70c0cfb6f8ea@kernel.dk>
Date:   Mon, 26 Sep 2022 08:34:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next] tests: test async_data double-free with sendzc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <aae98072a1e606a7f11dd68cf904d1ccb9e39ebe.1664193624.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aae98072a1e606a7f11dd68cf904d1ccb9e39ebe.1664193624.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 7:33 AM, Pavel Begunkov wrote:
> Similar to send_recv.c:test_invalid().

Applied, thanks.

-- 
Jens Axboe


