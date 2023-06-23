Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5FF73B73C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjFWMbW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjFWMbV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 08:31:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A857683;
        Fri, 23 Jun 2023 05:31:19 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51be8edc657so609073a12.1;
        Fri, 23 Jun 2023 05:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687523478; x=1690115478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JKogJ0N6wDob2SkkUeIQXpqaVIaKi6bX3PaZL35TyBg=;
        b=QragB4QxJ9UfoZeHDQDEccE2wkbbrn9qqlPxm7kLc1hBSo644lLMywGrs2hg/x9Rba
         4zDD2lEJ1mi2CSBjYt+4UG60+t71vkgZkuLpBm5Rpvk0r80grK8eXuf4mV4LaDNhh0Sl
         MLGPxw8/tgip5eOVvz3hYpsn3XteZ32ixvXyuaXTJWQL76Qh+XkwHSRDJMNuj4v+Ipx3
         UW+nCP7Z4WgKt4lN6soR3v6stSYDkYjqbMW+pqmgyT8HS7dT7rUF1e+NXnpb7RMbrKOh
         7Fi79YYvpMufWK3ZcCFw+FxRZQFie2bEQEdcUFV5mcDc48E6t2nzH0Khu5cfMfs1L9Xj
         ZxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687523478; x=1690115478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKogJ0N6wDob2SkkUeIQXpqaVIaKi6bX3PaZL35TyBg=;
        b=ZddUCSnlAT9oYks3cdWqSf6crG95bItXkVtcVAhW5KCCQ7DxnhU43E2RogyYKLw7WB
         l9dwvH3n9J4PhXUoSTA26/va1EIUa0MwAKP8xC0dBWpI0bukM940myEnhiuCGdXHr2in
         ixWDNSm/mPI03U81MY8DP6HO4c4kEXHFuTOEV1vL91RP+jO+xTGTODX0cWm+Lf5hiGYZ
         /w2TIENQhxOHHGUw86AQs3+0Ny2hRpkofJyhpghaYbq2JPVGHcP7E1tSC7+PwtuACyka
         VaPv7DsNzjIu+J1ezLFZ7F8/4kWDe8M9K1IsUEwPJ7Z2YyjI5UsD7hSKYjDic+L8eWdE
         i25g==
X-Gm-Message-State: AC+VfDxL3zp8ZUZ+tt9awXsRQwOoLPabuCk81Iae79iJeZSLtNTsCZbh
        UW8nowiBa+MGaYcsNfB1qgVobtLrfyk=
X-Google-Smtp-Source: ACHHUZ6FX1U8bA2eq2erYm5+VD6zUE8xBARURheo/9VGBaSGhOFJzZcfIFPt6tY3pcMrvgmhU4haTA==
X-Received: by 2002:a17:907:16a1:b0:988:d1d5:cd5b with SMTP id hc33-20020a17090716a100b00988d1d5cd5bmr12759862ejc.75.1687523477968;
        Fri, 23 Jun 2023 05:31:17 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id p8-20020a170906614800b00989065149d0sm5918131ejl.86.2023.06.23.05.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 05:31:17 -0700 (PDT)
Message-ID: <4c628f2d-c88d-fb9d-afd3-a405665cc0d9@gmail.com>
Date:   Fri, 23 Jun 2023 13:30:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [bug report] BUG: KASAN: out-of-bounds in
 io_req_local_work_add+0x3b1/0x4a0
To:     Guangwu Zhang <guazhang@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org
References: <CAGS2=YrvrD0hf7WGjQd4Me772=m9=E6J92aGtG0PAoF4yD6dTw@mail.gmail.com>
 <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
 <ZJMDWIZv5kuJ7nGl@ovpn-8-23.pek2.redhat.com>
 <e7562fe1-0dd5-a864-cc0d-32701dac943c@kernel.dk>
 <CAGS2=Yqe3+jerR8sm47H++KKyXNJbAbTS0o3PFqJ24=QOQ2ChQ@mail.gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAGS2=Yqe3+jerR8sm47H++KKyXNJbAbTS0o3PFqJ24=QOQ2ChQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/23 06:51, Guangwu Zhang wrote:
> Just hit the bug one time with liburing testing, so it hard to said
> which case triggered the issue,
> here is the test steps
> 1) enable kernel KASAN module
> 2) mkfs and mount with sda and set TEST_FILES=/dev/sda
> 3) copy all liburing cases to mount point
> 4) make runtests as root

Fwiw, I suspect it's a false positive warning due to
kasan checks we added in io_uring. Guangwu, can you decode
the trace? It should help to confirm whether the assumption
is right.

You can use scripts/decode_stacktrace.sh + specify what
source file was used.

Or do it with gdb like below by replacing "0x3b1" with
accordance with the warning message.

gdb vmlinux --ex "l io_req_local_work_add+0x3b1"


TL;DR;

static void io_req_local_work_add(struct io_kiocb *req)
{
	first = READ_ONCE(ctx->work_llist.first);
	do {
		if (first)
			nr_tw_prev = READ_ONCE(first->nr_tw);
		...
		req->io_task_work.node.next = first;
	} while (!try_cmpxchg(&ctx->work_llist, &first, req));
}

This might poke into a "freed" request, but we won't actually
use the value as the following cmpxchg will fail. It should
be fine to look into it because we're under rcu read lock
and requests are allocated with SLAB_TYPESAFE_BY_RCU.
The problem here is that it's not only kasan'ed on kfree,
but there are io_uring caches that are kasan'ed as well.


-- 
Pavel Begunkov
