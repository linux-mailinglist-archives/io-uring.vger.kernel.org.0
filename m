Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECEA500872
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 10:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiDNIfr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 04:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiDNIfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 04:35:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DDA62A1F
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 01:33:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bg10so8661919ejb.4
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 01:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2Vj4P52qLEcK0Tb+2rCp87B+Lh7oNnQXRZvWUvKVTfg=;
        b=obZ74zAdBTcH++m5kWJ/A1nlHOyEZzTY+MGjLXcoc9H7eEkOZ2JCYn1hq9tluYlqQn
         7Huai3zYaFt5v0VBts5y6i/+3B25al2XrV7SNIwYFpZ8z1dv/Uhvi1JBlVBfpVFFTZaU
         3nzwTM6L5CNUZ60pQ4LCWrTp+a4/3SMf4eK0ZmsL570zT11LqTinPiQ8pm2r3r1dq6Wx
         G4Gp7ZwOdTzvn59p1OtjD9pRzKBOCPvvrCaRpJ7GnsPjEN84OYCkCWEQ2Y9K3q2YYuAi
         W7oDH1j/VUSfa45jkZI4etuw2Z7v7yNqoe/CopWdVRkgE/G/16xQx9UTlDSI9mLi/5/4
         uwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2Vj4P52qLEcK0Tb+2rCp87B+Lh7oNnQXRZvWUvKVTfg=;
        b=RN9x5O8OlOdFoJsSr5L0i/6zfgVbiibh1rA7/OLyOYUVu+25XqoB0m2sSSsuUXC2rj
         k/CeGzu/5FC5az7YYA8r7J2WDmuLvRKxbZK8Zh+8g1igxURmCDpjHo0Y1UOuMjBYQneJ
         bfruqSyhYs94UNAuFAWX5bPGmA3DqWZPDgCkQrd953AppYp3PjkmLbsqlyK1NHMxGJve
         e/LXKCruE2sL1Hi933A7yl7zbygFyFrYsKReGiJ1jnkelFsZvn1z4SXcbuWQ7D+ubxuz
         OongIGm41sopmficP/CUk6tjHDur6fv7Wh+U6TbN2IgLUrYmU0n7VmJWkufa5y0WfcVr
         6IlA==
X-Gm-Message-State: AOAM533sYpHkYl2a+t2Vlwzxut+Zr89eLZwZdFcYA5HucaPOqtuhncZD
        lqRiwFBPM5i6bLKF8B1k3FA=
X-Google-Smtp-Source: ABdhPJw/xZlyH5Rgu1lU+kW+xBJ4jDWvWohMZXv4EYzMqSHNtkfUe9dDzV4COX0sD0C0/W6JwVxaMw==
X-Received: by 2002:a17:906:19c6:b0:6ce:98a4:5ee6 with SMTP id h6-20020a17090619c600b006ce98a45ee6mr1367562ejd.567.1649925199472;
        Thu, 14 Apr 2022 01:33:19 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.69])
        by smtp.gmail.com with ESMTPSA id e9-20020a17090618e900b006e8669f3941sm405059ejf.209.2022.04.14.01.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 01:33:19 -0700 (PDT)
Message-ID: <ec3c4d65-b677-53ce-bb6c-3ebe51340777@gmail.com>
Date:   Thu, 14 Apr 2022 09:32:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: questions about io_uring buffer select feature
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <c5382b9e-2a15-c6e9-59c1-48e7b40e5487@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c5382b9e-2a15-c6e9-59c1-48e7b40e5487@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/22 08:41, Xiaoguang Wang wrote:
> hi,
> 
> I spent some time to learn the history of buffer select feature, especially
> from https://lwn.net/Articles/813311/. According to the description in this
> link:
>      when doing the same IORING_OP_RECV, no buffer is passed in
>      with the request. Instead, it's flagged with IOSQE_BUFFER_SELECT, and
>      sqe->buf_group is filled in with a valid group ID. When the kernel can
>      satisfy the receive, a buffer is selected from the specified group ID
>      pool. If none are available, the IO is terminated with -ENOBUFS. On
>      success, the buffer ID is passed back through the (CQE) completion
>      event. This tells the application what specific buffer was used.
> 
> According to my understandings, buffer select feature is suggested to be
> used with fast-poll feature, then in example of io_read(), for the first nowait
> try, io_read() will always get one io_buffer even later there is no data
> ready, eagain is returned and this req will enter io_arm_poll_handler().
> So it seems that this behaviour violates the rule that buffer is only selected
> when data is ready?

Right, that's how it was working, but recently Jens was queueing
patches to fix it, e.g. see io_kbuf_recycle(). I think it was
for 5.18.

> And for ENOBUFS error, how should apps handle this error? Re-provide
> buffers and re-issue requests from user space again? Thanks.

It sounds just right. If the userspace can't re-provide buffers,
I assume it may want to wait for some inflight requests to complete.

-- 
Pavel Begunkov
