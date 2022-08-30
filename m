Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C905A65D0
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 15:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiH3N7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 09:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiH3N7D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 09:59:03 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA8A12F126
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 06:58:16 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 10so9277604iou.2
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 06:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HSNPxzUzHRGtN8cgh2TeKBnrRCslwohB3AmisvQmdg8=;
        b=T2xvhwKiDBFFkE8e5Bn3ekOZbolaeI3IgHEWw4JBED3+nJLWVWZ2e4oIGvBHNz3taJ
         51TbyI38FUGy3cQzFFA4K+N48Bcrb0uK46HsZQERTo7R5e0pXq94e5rFsClRQHfuMhZO
         nOPl9Ldc1LTRwOSLFZlVz5ehIuLCNedhCrkU/4PfZ5caob+UORvSrOupcUAqAdfz6CRN
         ItwXwb90QdOEv8uvPtv/ksweur0uetgROAgcfnwGM3XKb8aXucB0djFfSKxiIYIhb4kc
         bwCZtjr286atudk+CcDJTtdKceBJ1XNFMoh0psdzlIXYU5zp1JgqtdwDaVYox+rAjJ9O
         1HUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HSNPxzUzHRGtN8cgh2TeKBnrRCslwohB3AmisvQmdg8=;
        b=IdGRb2GQvETlnQieJLusHWCbhyKkT34JT7QrYNp/wXGhqRu/TTcBWfq94otxKHnguk
         7xb73GK+2yfdTHNTaIaS9wSnGffq/2wfndUz8QlwmGjYFoYAwcjxpc7KTgigifJyFaNg
         vOPHNLreFIFsuYeEoWgkTlXMZmdEx9ux66Eouo2OREAMif3gqchrCcrzNAp8e3iSRgkc
         /Rui97sOtBMHku8ZHgo2FVYT74RSaZIdjsYoJHTD+ObMHkHVL47tSoQoLuAi8oyeqvB/
         cc0B02XOvUW0LDNVc1uXJM8Hy9eW48+kDkpQ26EyMiQvYE8yKhgn/H5jlG3yvnCf0/ar
         lP7A==
X-Gm-Message-State: ACgBeo3je6ZmN2evh9tkkyOHL6mrUGvY0wFH7cnhRBr0A/p0E/xeK7su
        ain1Xq0/NwiHBkvcbay1IxtzqA==
X-Google-Smtp-Source: AA6agR43oft2ZvILzAzYMOdAxngu67SRdZtNPgH+3dQtdzQu/03BnhX4/xlv30J9LcGg8LGC+XpBjQ==
X-Received: by 2002:a05:6638:22c5:b0:346:dc09:b0f5 with SMTP id j5-20020a05663822c500b00346dc09b0f5mr13021822jat.194.1661867895182;
        Tue, 30 Aug 2022 06:58:15 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s5-20020a056e0210c500b002eafe62193asm2778639ilj.36.2022.08.30.06.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 06:58:14 -0700 (PDT)
Message-ID: <54a4b5b1-c527-813b-128d-e0ccc51db4a4@kernel.dk>
Date:   Tue, 30 Aug 2022 07:58:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: possible deadlock in io_poll_double_wake
Content-Language: en-US
To:     Jiacheng Xu <578001344xu@gmail.com>, linux-kernel@vger.kernel.org,
        asml.silence@gmail.com, Qiang.Zhang@windriver.com
Cc:     io-uring@vger.kernel.org
References: <CAO4S-me0tq289wabwsL4xbRXfHgaetqvExt8+ZyrKLxfGzLteA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO4S-me0tq289wabwsL4xbRXfHgaetqvExt8+ZyrKLxfGzLteA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/30/22 7:33 AM, Jiacheng Xu wrote:
> Hello,
> 
> When using modified Syzkaller to fuzz the Linux kernel-5.19, the
> following crash was triggered. Though the issue seems to get fixed on
> syzbot(https://syzkaller.appspot.com/bug?id=12e4415bf5272f433acefa690478208f3be3be2d),
> it could still be triggered with the following repro.
> We would appreciate a CVE ID if this is a security issue.

It's not, and in any case, the kernel has nothing to do with CVEs.

> HEAD commit: 568035b01cfb Linux-5.15.58
> git tree: upstream
> 
> console output:
> https://drive.google.com/file/d/1e4DHaUKhY9DLZJK_pNScWHydUv-MaD9_/view?usp=sharing
> https://drive.google.com/file/d/1NmOGWcfPnY2kSrS0nOwvG1AZ923jFQ3p/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
> syz repro: https://drive.google.com/file/d/1e5xY8AOMimLbpAlOOupmGYC_tUA3sa8k/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/1esAe__18Lt7and43QdXFfI6GJCsF85_z/view?usp=sharing
> 
> Description:
> spin_lock_irqsave() in __wake_up_common_lock() is called before waking
> up a task. However, spin_lock_irqsave() has to be called once in
> io_poll_double_wake().
> such call stack is:
> 
>    snd_pcm_post_stop()
>       __wake_up_common_lock()
>          spin_lock_irqsave()
>              io_poll_double_wake()
>                  spin_lock_irqsave()

Please prove that this is actually trying to lock the same waitq.

-- 
Jens Axboe


