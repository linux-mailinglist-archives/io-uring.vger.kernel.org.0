Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD0730276B
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 17:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbhAYQDx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 11:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbhAYQDZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 11:03:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB5CC061786
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:02:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id g15so9023729pjd.2
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YbW5o8N/3XplpvmNvAXMPeC+CGMMgNHKH99oYVLm+qU=;
        b=ezC05G1g900wXmJbe4zPqLmc31L5uo30IrttYRHSKM9UQhxv1igH/KnnBfnh+dshEn
         EsqTM/UUYj+LMJjNiE1s/DUNn1XnhDA63TgBlFyrq6/fIJ/GqIzyliVfuVEGp7tQnV+J
         S+69y/k0cqLmivQVhK/jNjn9WC8kjf7P23RCCP7CttFx2fMw4A0wwgGzbNUfQJH3f+83
         P1FPNX9C34btqbLdzKG/Eh2nT9qH6Rftj13H4qb7TEtF5rwTfo3PK/SWGBn20ckG3vNK
         VGq3+efHjBgkl8hS/gkX7n080r+laueXGtvHNrOtdtPHqq9Rdx5vVu2iGOA3dHfYJjWD
         46NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YbW5o8N/3XplpvmNvAXMPeC+CGMMgNHKH99oYVLm+qU=;
        b=Qw/Ls1lrUshHnIrh5Y7tmgJaeU3HfVY4+VICyy+AiWm2/GaiKemZ2WfO+Gexj0vxms
         /2txDROh+pOwM9Qz7EiEVOeBDj0HXfQtUyd3G7tWq9h2R0rGlYZ+iGxpYjLX22MSEjLR
         eOAr8ftytLSyLW5b4DAzPYJU1N8reZbg9kBq8VLr7brcYDXT5WKkDDliP6KU7GCT6JFH
         zZklaGEuI6VnNxsHg3bEg2ZdM7KPk94Vqv/Jtnt+xArAWDKUbpoQ2D18WaLRx6LsxkVJ
         5uBJwwUhQu6xGL08/Ak82xk9BTdQVWJCzqEzUyjrN1nIKnmVvX5OZEydvNts7HHNHfuV
         GtGw==
X-Gm-Message-State: AOAM5322CXuLlHsDbDOoQqCyYkY6ISTiPoLQAuAexeb6o3tgm/01jHf7
        6s957ml/SPZ99UzVipTxYeHd1B+4X+shbA==
X-Google-Smtp-Source: ABdhPJy7oUWhTjgRijQ9Duvn0n3qBRpSLzRnQyoHz/bD8vNuH99OAeNVn8i2ShtcyZG1e0FnGPCD7Q==
X-Received: by 2002:a17:90a:eac3:: with SMTP id ev3mr862894pjb.27.1611590557556;
        Mon, 25 Jan 2021 08:02:37 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 16sm19477575pjc.28.2021.01.25.08.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:02:36 -0800 (PST)
Subject: Re: [PATCH 8/8] io_uring: keep interrupts on on submit completion
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <1645f7f935aa833231ebaad974bc37890ad9a2e3.1611573970.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6fd689bd-a34c-21e8-6175-83f4ca0c7eb2@kernel.dk>
Date:   Mon, 25 Jan 2021 09:02:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1645f7f935aa833231ebaad974bc37890ad9a2e3.1611573970.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 4:42 AM, Pavel Begunkov wrote:
> We don't call io_submit_flush_completions() in interrupt context, no
> need to use irq* versions of spinlock.

_irq() isn't safe to use from IRQ context, it would have to be
_irqsave() for that. So the point here isn't to ensure that we work from
IRQ context, it's to protect against a deadlock when the lock is _also_
grabbed from IRQ context. And for that, we need to make sure that IRQs
are disabled, if this lock is already grabbed from IRQ context.

So this patch is wrong, the code is correct as-is.

-- 
Jens Axboe

