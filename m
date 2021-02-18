Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B870F31F2D8
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 00:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBRXPn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 18:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBRXPn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 18:15:43 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76A4C061574
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 15:15:02 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id m2so2245107pgq.5
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 15:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iLGnNnUZvlt1mUFrl80TpSiXsFzQYMDax1jW07e0NXo=;
        b=jnF+taC7Ydrqi2+9QEdo/QloGZOZPV9rYup9m/9cgvZnTjDPTwdKh9oZU9PN2pcOeT
         J+vCvgpL0SKBXMuhHg0mKYZOntlWV412TfD9ZJSvvDaz0WupsYIeqSfRO06sASEctfN+
         DvtfLODdrHP6EMxRLjT9MKJjL5Z/4ZY/9AJMwQkiAcy0fPSGV2Q1oPVXBFk8F9iCqiiV
         F0KDHqQGJa0ZIvFL0I4gV/i1hkMzttcT7UfpiAR7qjOKzHbENgoQhQ9ZzfgjzBdo1P0x
         0RwOgEWdwXQ4MbNV1d48stbDFbcipstfD0bE0/XkLZmOEg1QjFknAySzDwRsEq5eGmQH
         yp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLGnNnUZvlt1mUFrl80TpSiXsFzQYMDax1jW07e0NXo=;
        b=mrlHRShwyygnDENrYu2QEs4GDssYzbMsMbWMm1y1oUNyo2zs4+rYtIo0ZhaSlu6t8L
         rBvJfJ0fF22FT1UvEL5ov37aAW46bFQesTvCuFhJBT3jIFL1pDpGdzdic8DsorA0NACz
         i6EuoxLnzWfHh2G/xi05y5jqltkRoyMCuD/kAXLBz+O3XrJ2ZSP7uCHFE2DJQK8j3G5X
         ktlwbZCWPHBwjpRhFW5MD6yH+4EuCkoeGE7nlXzu8hirBkhiTeTZIYcf3YdaUtHINf5s
         88XzDirYuo6l9VGDhU02ocX6S5pSFAbOzImVAzKLEjyEZFB9V1mVBYK5yWrRh50Q3cLn
         JizA==
X-Gm-Message-State: AOAM532wvr4Gb/1QLffioKyTt6IrCBtgj9Soq9/f1Pfge8R84Njm8THu
        e25jM8v1zfT1+wvFkSYJGxeeY4hF7+e3Tg==
X-Google-Smtp-Source: ABdhPJwdMzMfZYLx2vyqzIIW3uYGBYOYfM+NXkmcMWYke9a+cN95hazTXn/+8MMvQJvkHIkf+IFSrQ==
X-Received: by 2002:a62:7cd7:0:b029:1d5:727a:8fec with SMTP id x206-20020a627cd70000b02901d5727a8fecmr6323821pfc.15.1613690099287;
        Thu, 18 Feb 2021 15:14:59 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x1sm7614237pgj.37.2021.02.18.15.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 15:14:58 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: avoid taking ctx refs for task-cancel
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613687339.git.asml.silence@gmail.com>
 <ffbeb9bee15392fdd2732333be1cc2db30a1eefa.1613687339.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <752ce606-b22d-0ec8-2366-f5fce3c24831@kernel.dk>
Date:   Thu, 18 Feb 2021 16:14:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ffbeb9bee15392fdd2732333be1cc2db30a1eefa.1613687339.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/21 3:32 PM, Pavel Begunkov wrote:
> Don't bother to take a ctx->refs for io_req_task_cancel() because it
> take uring_lock before putting a request, and the context is promised to
> stay alive until unlock happens.

I agree this is fine, as we don't destroy the ctx ref before grabbing
the lock. I'll defer this one for 5.13 though. Which is another way
of saying "please resend it" when the merge window is over ;-)

-- 
Jens Axboe

