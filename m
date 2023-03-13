Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A736B7A89
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 15:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjCMOjU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Mar 2023 10:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjCMOjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Mar 2023 10:39:17 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8F5521D2
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 07:39:01 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r4so1062585ilt.8
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 07:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678718340;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=biHpc44iJmhTQMXzPILSB3Dtj1gWIfkozqieuT+FT+M=;
        b=BRcYKv+yl+jOBiXAyKm6M1YfTxkOtvDHpJaLlfog1pzqaLwD/TeJKoy5ijFszbahwH
         q75EkLpk/K1FMmRXuRY/UVmyIDOZR12b77dzKTIq5ULP46Tm3ViGgEzzSKOIe+Ho3Xxw
         sU2aDh/q3BGjMDPM4YtoR9Sa9jNfnNYm7RLf7GlS1OhR0mdBYo2EjUjpQU4R4P3FSdXb
         ejiYC0ZX7g0daEYHnbS8YRCmciZUfxw9+VPX8mOmVkPaOlYmtTSTLmO51awmpi5pbiCT
         QnPLN6BufVuDbYgisBe+ah/UgdUXpPravxltD2GOaTWFuZJnNAXXCzaxMaCiiLAZFkzp
         OjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678718340;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=biHpc44iJmhTQMXzPILSB3Dtj1gWIfkozqieuT+FT+M=;
        b=oxfQ7pWbkExhSaBBTkAuCJb+60K6ZENqmmiw/MDzI6kC+vubh/aDLmNKn7vYjynY/y
         tMd3pMZWqLn0MqznLMBJgO5RdI8N0PXVEZvsaJrYxv3fIdezQWEke9yAREVfxDuS+BOl
         BBpNN0JuEV/ktkg6aMCk0oboVrkvrJMhAkm6w1PDWQY3mcLsZ7EPf3OcyRnZVsJOjyfr
         5UHie5JJHnvjDVpIMjdXeS3U1rYJcCHBiW0YvPLVyJ6FNsgjBARawzO20Xkb1C/cj1Fb
         Mc9c/5yrfNEO1kRqACHjnrVBswR1eNlOitYZcalCBcjBcMEKUin1Y2PZqSfYo7AAMCTS
         qvXg==
X-Gm-Message-State: AO0yUKXz1KUDy8R46I8ugPs17tlv8v8miTZtSsVjQJOAWazVzfKfTe01
        4+seZ6p+RTSaAtvDpdKo17jCeg==
X-Google-Smtp-Source: AK7set+eYqOURxsFsJb1OyYRxxlMjY73jEvlwlCZTLNnQgnZvIcJzjbGN6NSElEdxbrRWIuN4PpBRQ==
X-Received: by 2002:a05:6e02:6c2:b0:317:94ad:a724 with SMTP id p2-20020a056e0206c200b0031794ada724mr9158786ils.2.1678718340187;
        Mon, 13 Mar 2023 07:39:00 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h5-20020a02cd25000000b003a7c47efde0sm95431jaq.11.2023.03.13.07.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 07:38:59 -0700 (PDT)
Message-ID: <aa490efa-a316-7846-c757-90302799d9b6@kernel.dk>
Date:   Mon, 13 Mar 2023 08:38:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [syzbot] [io-uring?] KASAN: use-after-free Read in
 io_wq_worker_wake
Content-Language: en-US
To:     syzbot <syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000bd527205f6c8fa41@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000bd527205f6c8fa41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/23 8:32 AM, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit e6db6f9398dadcbc06318a133d4c44a2d3844e61
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sun Jan 8 17:39:17 2023 +0000
> 
>     io_uring/io-wq: only free worker if it was allocated for creation

#syz fix: io_uring/io-wq: only free worker if it was allocated for creation

-- 
Jens Axboe


