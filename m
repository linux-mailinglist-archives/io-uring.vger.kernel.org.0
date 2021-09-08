Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB4404009
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 21:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242666AbhIHUBA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343558AbhIHUBA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 16:01:00 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F33C061575;
        Wed,  8 Sep 2021 12:59:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso2505629wmb.2;
        Wed, 08 Sep 2021 12:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EMzQuoWw1qjPNJQjuT25yOnQNmm2q5UUDdxzpbiJOIY=;
        b=XlV07RLKNgI+ZijZMcJvAtmTFCQ9mKkG01eCHramkoZjW+ayLaacRlSv1+qi5CuKqf
         7UMi0mCRCKSbNGfG8KxOTe/YGO93HQbmcU+sm3YnuPJKuhJmO773CIQnZYSyR+CkXdBP
         tCcHyLLaWb3jeu1prwmD4AdnPcIL5tC2C3TtQkf+UocRG2Vf4AUOex1ujCvlwa1P3geg
         leQN8wjGDC2VQRIQKEGb8X46bdhe+1PG9EhUCiN2cubiaWvthMtNVTV46rWQx/WvV+85
         MUtO1tBaqXMXfaDzjQyd1eoGU6WyVW1UyJIXeLsCRQdXy4TweXwHv64dHfEe/klP4FLt
         3CyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EMzQuoWw1qjPNJQjuT25yOnQNmm2q5UUDdxzpbiJOIY=;
        b=SbY1KRxnYPfd+lGlFtAW/45wX23Gut6BaJTAtpJEd0LObI5aw+Qhzw/2VH8Yj8eZue
         Szrh/dXfOv0EVLP/KipSkTRKBu93KzNEKNF1XUmDIxt4Zo2fgKJoNk8okgKueu3466nX
         nxt1+WrT4U6Io78j4yB7rnOn681+Rc6bUIls7T1xa5ClC42EmAm1F32qNNYch+00gGUt
         NJjGsgX8PJJ1lph2jfTN4RJ8BgvH4yuF2KyMM8cI87JrsPRGczSI3Y/JRe7wZc+n2KpV
         /9T8nYco4dbI18dLk/95ewjAhtVeX56GFrCfbDsWF6AEK99q8Nb1vPBxQfjBaCJc1pIK
         KYAA==
X-Gm-Message-State: AOAM531zYUfJlY30+nnWXVi06uEg7ab1a0yQtaJuQhisWjZLv2SAUZ8y
        U0aWiIxftsUHQII5ScG/+KQrh4DloyE=
X-Google-Smtp-Source: ABdhPJznKXk+a2mufM112bzKoVRMuNom4Y9Oig8uIcXkQbvWW422yC37LhVFpfO76hx2hXpFnNbRAw==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr13553wmp.52.1631131189864;
        Wed, 08 Sep 2021 12:59:49 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id l16sm108739wrh.44.2021.09.08.12.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 12:59:49 -0700 (PDT)
Subject: Re: WARNING in io_wq_submit_work
To:     Hao Sun <sunhao.th@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.co>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsa=DmomBxEub98ihEu0T37ryz+_4EQgGF1dURtTvdLEtQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ef57e25a-3938-96ba-5f20-7e4a118f29bc@gmail.com>
Date:   Wed, 8 Sep 2021 20:59:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsa=DmomBxEub98ihEu0T37ryz+_4EQgGF1dURtTvdLEtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 7:46 AM, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1RZfBThifWgo2CiwPTeNzYG4P0gkZlINT/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/18LXBclar1FlOngPkayjq8k-vKcw-SR98/view?usp=sharing
> Syzlang reproducer:
> https://drive.google.com/file/d/1rUgX8kHPhxiYHIbuhZnDZknDe1DzDmhd/view?usp=sharing
> Similar report:
> https://groups.google.com/u/1/g/syzkaller-bugs/c/siEpifWtNAw/m/IkUK1DmOCgAJ
> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

Reproduced and fixed. "WARNING in io_req_complete_post" should
be the same problem, doesn't fail with the fix. Thanks!

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.15&id=713b9825a4c47897f66ad69409581e7734a8728e

-- 
Pavel Begunkov
