Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA34940825B
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhILXux (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 19:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbhILXuw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 19:50:52 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB57C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 16:49:37 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id h9so17040214ejs.4
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 16:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:references:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z1D+qDEIpCsg/68hoxMN3+EsdYareIGr8rCiZMCcyL0=;
        b=dyPs5vvHJ/u5v0ZTPM6l5vZyDljzokJ4jPExOrHSiFsuF0fOEZ9TK6Um5MMC7zNJf6
         BrNDWmkZ/2j6166O2cwejGldOPgOdeDW11PFyWhup/VYluQKaaqUxabSDsHs5M+umyjd
         PiryY+FVyPeoCeVzPY2wTWvz19Bb+2Eh3Lgg4/UWhTmksbnvhT4qM9byu+HhAmUDEoOk
         NmLqldNwmq+Bs76eONi78rx0yhSL940DbHynw2IPXaG6RQsxMoM1OUBwf4/WAMR8j3+5
         NdJ2cWmEOFpbCNat0dwjqVCsiKAJsgek4C0fYq8dCf6gEzQOnNn+PNkRWEvOihc2UuTB
         ZNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z1D+qDEIpCsg/68hoxMN3+EsdYareIGr8rCiZMCcyL0=;
        b=K9h8ud+k4atumsCbS5INdYDjIp/wITmyREdIbIx7146U+NmTERPO44R2rPz4sWGGY8
         Iq65MHf5ClfGv2LKPPACL1guuvCsx+ueeEMMEo040BvGq0cLd7m7lLfO+SKP934IfXu5
         LSMClmN1vbGBxJx16PQXOhHSP0/Ta/UE1BS1O4WLpxZ+6MTzYe7fGKuBOqWnNOLT6rrG
         rzYyVGQtVf7bJ4aLl6t7pSkhCUzCAvMCPuCZHAIKxADb8Gc46Sw8C9MBnM+DKZemiJlM
         FoN9jAREoGa+9yajIQTOde6w2Gx6FaaS50skJEBP1KhF1ua0N818a0WJgqf3QHkBqSAJ
         /WFA==
X-Gm-Message-State: AOAM531EGTD8mgl3hF52mMGEcYv7Vc0jGLCK8jffQZwAUXBixCMqCHKU
        23zvQCRC3cw8cvifV5I/mcKmZF5p2AQ=
X-Google-Smtp-Source: ABdhPJy0TTpfwzJA31WEPUEPJp2yscrofakNwmM5vTCglFy1bmsN7PhbC80nnhQNWrNUvy0IloHJkQ==
X-Received: by 2002:a17:907:2a85:: with SMTP id fl5mr9431860ejc.91.1631490574552;
        Sun, 12 Sep 2021 16:49:34 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id s7sm2977357edu.23.2021.09.12.16.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 16:49:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1631367587.git.asml.silence@gmail.com>
Subject: Re: [RFC][PATCH 0/3] allow to skip CQE posting
Message-ID: <f7b90e13-4ab8-aa1d-054b-d5c02a498580@gmail.com>
Date:   Mon, 13 Sep 2021 00:49:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <cover.1631367587.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 2:51 PM, Pavel Begunkov wrote:
> It's expensive enough to post an CQE, and there are other
> reasons to want to ignore them, e.g. for link handling and
> it may just be more convenient for the userspace.

FWIW, tried with some benchmark doing QD1 buffered reads, reads
taking 60+% (memcpy/etc.) of the time and 20-25% for io_uring.
Got +6-7% to performance from the kernel side only with additional
room to make the userspace faster.

> Try to cover most of the use cases with one flag. The overhead
> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
> requests and a bit bloated req_set_fail(), should be bearable.
> 
> See 2/3 for the actual description of the flag.
> 
> Pavel Begunkov (3):
>   io_uring: clean cqe filling functions
>   io_uring: add option to skip CQE posting
>   io_uring: don't spinlock when not posting CQEs
> 
>  fs/io_uring.c                 | 103 ++++++++++++++++++++++------------
>  include/uapi/linux/io_uring.h |   3 +
>  2 files changed, 70 insertions(+), 36 deletions(-)
> 

-- 
Pavel Begunkov
