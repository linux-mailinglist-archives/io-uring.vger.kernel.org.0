Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E96B32F37D
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 20:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCETID (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 14:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhCETIA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 14:08:00 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073FFC061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 11:08:00 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id h10so4088783edl.6
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 11:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kC7T6RizfgECMp+Qirh9BJz6aKhWXNB9fhVsyPRJjXA=;
        b=m9r6AlK+gGV2+QGOq6MPSoTtVV6xGZkajhM16Nq61qpKKcTDxBVKQXuz5NfHPfTVXu
         ggHf7zQFaYlPKOQjFtppa1+qObWUDzzZptvwJDuqiMeIiDBQ9vwOCri3qOTWQBdT7t5Z
         eEkYMxHJg097XUG/7LexTnIYgfvsyBV5Oyig7xcZhmz9BgeI9Rls24kdcTphNYZm8JVh
         2n1OkRYWiS00aO+5xSxPet+bGVE28TQijDY2X+xNt2HyxAyKK8tie4N9nEzGoNbXX+Q8
         +z1bSzmkS1OrwV1rYUbnJWjskSVTIfHW9tTqtfaCDPA7F8NvqWk4F0Oez3bt7cfUH0O5
         CkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kC7T6RizfgECMp+Qirh9BJz6aKhWXNB9fhVsyPRJjXA=;
        b=CL20hL4t0289eth9p2vtI8cm+nD5Vz/lNuZQ+d6VyKjz21jhQs6hC+woYCZymo23xk
         AoB7h+eXZdnEGJKF5ysVJ6lkaIQ8/9q4l4iRzD1UHxDLuER8ETQ1Je0UL1/coWaoGxWh
         sBXEswBWhoQ7gEJCeMa5YquiWPHneKFlezqekCGTWFt8TXW1MTfdhztTm8AuAUYSzrWv
         l3RVPXd731Mxwt92myjYrTZ/NwZpXogfgYxdvAV7dJYtp9/7ImgPrn/H0NbmDexrpCTJ
         yfZSDfyG1um873kHRTtkrBJnfOCMjjAyFVjPTTSOGTZXU8Sq7qd7URdu9eoD7IsOdv/e
         9Zdw==
X-Gm-Message-State: AOAM531xMbGFnRjPj6CtjW6yJziPANZcPENuAJbA9mkP9MO+IwaZ/xcB
        M+C6DnfZoCv5IhaYJLm60hCS/n19uu/U1RJzbK76uXIwMS64HMyv
X-Google-Smtp-Source: ABdhPJx2pyw+W95u3B8BRxne2XYelyLgNTSzrT2QNMRU00dVWkH681AAjaVDd7BnTWcY928Y0JoiPtmPlLORCGTsVJM=
X-Received: by 2002:a50:bf47:: with SMTP id g7mr10401808edk.323.1614971278147;
 Fri, 05 Mar 2021 11:07:58 -0800 (PST)
MIME-Version: 1.0
From:   Ryan Sharpelletti <sharpelletti@google.com>
Date:   Fri, 5 Mar 2021 14:07:47 -0500
Message-ID: <CA+9Y6nzQ8M++uMjJV8_LbB+HwvSZOO3kzKoRO-OaMggdU+xXTA@mail.gmail.com>
Subject: Potential corner case in release 5.8
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I suspect there is a corner case for io_uring in release 5.8.

Can you please explain where the associated mmdrop/kthread_unuse_mm
calls for io_sq_thread_acquire_mm in io_init_req(...) are?
Specifically, what would happen if there was an error after calling
io_sq_thread_acquire_mm (for example, the -EINVAL a few lines after)?

From what I can understand, it looks like the kthread_unuse_mm and
mmput might be handled in the call to io_sq_thread_acquire_mm in
io_sq_thread. However, I am not seeing where mmdrop might be called.

Thanks,
Ryan
