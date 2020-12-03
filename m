Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106412CDA1F
	for <lists+io-uring@lfdr.de>; Thu,  3 Dec 2020 16:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgLCP1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Dec 2020 10:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgLCP1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Dec 2020 10:27:35 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B754C061A4E
        for <io-uring@vger.kernel.org>; Thu,  3 Dec 2020 07:26:55 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id t13so2280428ilp.2
        for <io-uring@vger.kernel.org>; Thu, 03 Dec 2020 07:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=NNA6HfrLGF10EpoGlrrukBhBPZDiacjzJg25BIbjVRY=;
        b=Z7LoECd9VWdnWz09aNeo9JsSeT4L8sq1rDRjND/BDwiiMjGDwOlwcKCtyG2xI9fUmy
         g/gmK7SsXLuyzOPx37bhIZqu914l8B3L36QRlN6yO5qi4WCx17JsIOih9S1UMKK2k7yw
         XXJa9sVbW+a3nWvYd9chEj6S3or+q2epkLwvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NNA6HfrLGF10EpoGlrrukBhBPZDiacjzJg25BIbjVRY=;
        b=F1gGAP4OHpMB005seHOEiP783Tj4na+AGCdJ6hchwKgyoR/IUwrznlMKZrIlFQoowU
         2GLNxvv7V27UTCUQ1Kr/WJuu5JeekojZBIxSU1IbXzWxBOifo0oLhMcpIfwCmbCQpadS
         Yv1KqonrHeT48dJiQBDDX6dTa8Edrtj7kwWd76ZRvk/Xn3p23N/g3vE4eK5hty77WwLG
         yHkzsx8NZFyCDVXk4nwbiSmzN6J74FOJ2MKakRrxbh4lgLa3d0YTF7qxMwzeGYrvJGPW
         +2Mp9W7Mw4JzPml6dgjbYU68/vfza5B7TmZ8nzA/ubTu9IKvi7xvIE0HQIa0ff8iWDtA
         Dm3g==
X-Gm-Message-State: AOAM533RSNw3ldvCyO3xZICTS2dqZMMfTdOXqpq5QtNtdcKIERry/308
        kEJZonbGH5RZ4tClhamgfQwqRI/pjDc6uw==
X-Google-Smtp-Source: ABdhPJxXnFj5wFFfE2ajBm4qjvZZrW2fYw6o9XRU0wR25R7LS+xdQVeU4eqn6hm7vH/usAuwE8f2AQ==
X-Received: by 2002:a05:6e02:1311:: with SMTP id g17mr3265080ilr.223.1607009214623;
        Thu, 03 Dec 2020 07:26:54 -0800 (PST)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com. [209.85.166.51])
        by smtp.gmail.com with ESMTPSA id u16sm1003177ilj.6.2020.12.03.07.26.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 07:26:53 -0800 (PST)
Received: by mail-io1-f51.google.com with SMTP id n4so2407066iow.12
        for <io-uring@vger.kernel.org>; Thu, 03 Dec 2020 07:26:53 -0800 (PST)
X-Received: by 2002:a05:6638:3012:: with SMTP id r18mr3781246jak.13.1607009212622;
 Thu, 03 Dec 2020 07:26:52 -0800 (PST)
MIME-Version: 1.0
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 3 Dec 2020 16:26:41 +0100
X-Gmail-Original-Message-ID: <CANiDSCsXd1BLUJwgdET5XBF8wQEpbape6BoCPpG9cTGAkUJOBA@mail.gmail.com>
Message-ID: <CANiDSCsXd1BLUJwgdET5XBF8wQEpbape6BoCPpG9cTGAkUJOBA@mail.gmail.com>
Subject: Zero-copy irq-driven data
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello

I have just started using io_uring so please bear with me.

I have a device that produces data at random time and I want to read
it with the lowest latency possible and hopefully zero copy.

In userspace:

I have a sqe with a bunch of io_uring_prep_read_fixed and when they
are ready I process them and push them again to the sqe, so it always
has operations.

In kernelspace:

I have implemented the read() file operation in my driver. The data
handling follows this loop:

loop():
 1) read() gets called by io_uring
 2) save the userpointer and the length into a structure
 3) go to sleep
 4) get an IRQ from the device, with new data
 5) dma/copy the data to the user
 6) wake up read() and return

I guess at this point you see my problem.... What happens if I get an
IRQ between 6 and 1?
Even if there are plenty of read_operations waiting in the sqe, that
data will be lost. :(


So I guess what I am asking is:

A) Am I doing something stupid?

B) Is there a way for a driver to call a callback when it receives
data and push it to a read operation on the cqe?

C) Can I ask the io_uring to call read() more than once if there are
more read_operations in the sqe?

D) Can the driver inspect what is in the sqe, to make an educated
decision of delaying the irq handling for some cycles if there are
more reads pending?


Thanks!
-- 
Ricardo Ribalda
