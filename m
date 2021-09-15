Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9C40C84A
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 17:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhIOP16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 11:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhIOP16 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 11:27:58 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32573C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 08:26:39 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b10so3923752ioq.9
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 08:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uhNdMnqrUuOGJjLHGNp0INA+/3+B4ztiCmheLJWqCc4=;
        b=Lkd31Qe3IDheqacURKEta4mJMoaQV0EvWlpsDiEjWYRJWz0rhpIvCqNgJ2deNxPTQF
         Qu8aAUYpPheo1fEnkAEEbx5ntNBcUBgQE2HhvebGMGRndlW2Cw02cp7Duw2Ih3Pom92h
         DbDk1crWZu6Ygw5ccyZ6H+LIxFaBE5Xf/YMwCGvzA9JNK1dElGL1tuM/tkVMY0hH4xzZ
         NBaC5URhnsiRWu1tRzPsRgqeAuaQ4Rhfiog97bFq63r65dywHjPzzuoPkFXTU04CAJAn
         heVo4ZwhIkFGFh4C++7sO880wtpByjDF0Yry/vpmp0gfaf11/6ooGY1nbKUiwVTu4LLh
         F6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uhNdMnqrUuOGJjLHGNp0INA+/3+B4ztiCmheLJWqCc4=;
        b=1BzAiW+cO5VuH9YupcRMOi/mNUBveVmgraWhiOyrRf6VR//XDiBzGyJxvcFQLGJfMi
         dpoxNW1ABb3b8eYsailJ+b7vg04GkyMcnc7erSccmGd4ccKpRwm2oWfCTp/YC3HBDxu0
         9hbAwMaFa16Ls1ePHQasj4rG0OBqe2evwoED7TlzXYcZYnX4QhwP36jVFPxfT9EWZMN4
         5DXKil1bMw1n7tOLVgcztX4of1IMgyJSlQ2mNlwvzEWPUYZwHZTn6y3WltGHUJXxflew
         BAtc72Y98Xy9k5opCGOW7+d/g6cbQBPK8JcPGITqdsRvJZo36nE9hijNzMf9IazeQOuB
         4wMg==
X-Gm-Message-State: AOAM5303gah9ZJK/KHV8yyux5kexqtLCKTNLQOzXQEGtGan/NM4W3zTR
        nGnhoO3XQjuxO4LbKTuWL1qXS3iv71aDOsO7CJk=
X-Google-Smtp-Source: ABdhPJyxEWt1NsxJI4JvPWAiS9UB0tUb3NEAiD5a0vRYQ7b1RtLbL9YoQG032TDYvJsFi2ejpayH4Q==
X-Received: by 2002:a5d:959a:: with SMTP id a26mr500581ioo.154.1631719598546;
        Wed, 15 Sep 2021 08:26:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i14sm135855iol.27.2021.09.15.08.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 08:26:37 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add more uring info to fdinfo for debug
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210913130854.38542-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ecf6b05-e92d-7d74-8f72-983ec0d790fc@kernel.dk>
Date:   Wed, 15 Sep 2021 09:26:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210913130854.38542-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/21 7:08 AM, Hao Xu wrote:
> Developers may need some uring info to help themselves debug and address
> issues, these info includes sqring/cqring head/tail and the detail
> sqe/cqe info, which is very useful when it stucks.

I think this is a good addition, more info to help you debug a stuck case
is always good. I'll queue this up for 5.16.

-- 
Jens Axboe

