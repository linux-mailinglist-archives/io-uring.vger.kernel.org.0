Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B8D57534C
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiGNQrE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240316AbiGNQqs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 12:46:48 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBFA6BC21
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 09:45:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o12so2355948pfp.5
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 09:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cUy4dG3fHsJ4SmPiGIKKf+s2etnhg2CaO8tWHfnew6k=;
        b=qFrAePObL9zJKcAFx6A40IJ7c2tm0SuhEJ5Ox0+AxY+d0M1j68JBpolQ+cVCgFlofs
         ztx5H64bPLN0DuR+vs1vR3ZzkFWtNCTxuR3+ysMaBxGFf7hDvU9kfn04AuC/AvLHnRLb
         z4mqHiHU7bC98PdqJHlQSx9yM7oWdsRL1TPimD3n7MpbH7XtuyDQugCC2GUR3tW6JuMN
         adf1iNLARNVoJf0k2a+qXDXJRSxIz6y+Cq5sr65CozVTzjwWWvs9uYhoCOvYqKKFhjL4
         JuhNAizTOLm6WnGSTX/0k5KWnnHhs7ERLIS5tqdU7kKcynr+YJsHFSrAJuTMrnkv8T32
         wE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cUy4dG3fHsJ4SmPiGIKKf+s2etnhg2CaO8tWHfnew6k=;
        b=8Bg65qaxobbyJ7DjVdbn5QqNEveDuyPJaVRkEf9BBRcIjMlL3bwZDfpWLktgHrQcLh
         mjOnoyNgHq/OEfeyWLDt3RBwDBCElBVPcCbygXlJc3d2J2DINcnhOBrytaPw+fLhiYjL
         Q6zyFFMVvWb5LLTMMkwe2RefFsOlYyAMgEgNwQtalq89d29SgsYDYLoh2JwOCi34yUKN
         8Hx+0KZjwMGQsef1Y+Qjmwa1UNijf9WJDI9ai1gcp3B+nJgSjNtj7zU1J+oCsEMIv2md
         tiCu71uoKBz6cRBlk1IK/0pWGJ8hdG77A3o/PPrioMjYzKwmLXco5a9ec50nd/LwfN/g
         HwZw==
X-Gm-Message-State: AJIora8eI7qEk+MgMsGRp9gbcklrV2sKIhl9od+RqKsVF+i2JAfgiuJU
        BqyUxKaBUwrQndwbfT9NYZiZTA==
X-Google-Smtp-Source: AGRyM1s5sAs61Xc615KUQJNZ6FNV/5FHFVrLm7UNuh79jl46ajdZqoF9CeEdkDs8in3PgVusQ0EkAw==
X-Received: by 2002:a62:e919:0:b0:51e:7b6e:5a3b with SMTP id j25-20020a62e919000000b0051e7b6e5a3bmr9369884pfh.78.1657817105601;
        Thu, 14 Jul 2022 09:45:05 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n6-20020a170902d2c600b0016be527753bsm1737053plc.264.2022.07.14.09.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 09:45:05 -0700 (PDT)
Message-ID: <2ca14dec-6e87-2e9a-80f7-0790f6e1f7cf@kernel.dk>
Date:   Thu, 14 Jul 2022 10:45:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: Use atomic_long_try_cmpxchg in __io_account_mem
Content-Language: en-US
To:     Uros Bizjak <ubizjak@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220714163301.67794-1-ubizjak@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220714163301.67794-1-ubizjak@gmail.com>
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

On 7/14/22 10:33 AM, Uros Bizjak wrote:
> Use atomic_long_try_cmpxchg instead of
> atomic_long_cmpxchg (*ptr, old, new) == old in __io_account_mem.
> x86 CMPXCHG instruction returns success in ZF flag, so this
> change saves a compare after cmpxchg (and related move
> instruction in front of cmpxchg).
> 
> Also, atomic_long_try_cmpxchg implicitly assigns old *ptr value
> to "old" when cmpxchg fails, enabling further code simplifications.
> 
> No functional change intended.

This will be io_uring/rsrc.c for the for-next branches, but it'll apply
directly as that with a slight offset:

checking file io_uring/rsrc.c
Hunk #1 succeeded at 56 (offset -10448 lines).

I'll do that, thanks.

-- 
Jens Axboe

