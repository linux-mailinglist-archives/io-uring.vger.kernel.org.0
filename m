Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A975238D69A
	for <lists+io-uring@lfdr.de>; Sat, 22 May 2021 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhEVRVn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 May 2021 13:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhEVRVm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 May 2021 13:21:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8841C061574
        for <io-uring@vger.kernel.org>; Sat, 22 May 2021 10:20:17 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f22so8972842pfn.0
        for <io-uring@vger.kernel.org>; Sat, 22 May 2021 10:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=CHfvij52f42wiV93oMvaQu8y9fqe6f+9BuTe5cXY1/4=;
        b=ftcVLJIFV7g0o7Pad9se+aPEgz4oeXKNpua7M+25xz1GgYDYt7inYPOhi7+o1EL/5m
         IxweJtKPCbizFKhcKoDo+vgQ7njbHPZxEVDDEWnhmL9J99VfGc3wSWaFw4nPwvwYfDpq
         ORABMLCuGA8pF+E+pWqULEeQywZDMh4st3XJfHOu9KgmHOgYJa+vGXeGXQxqRJ1HGnb/
         huKWD7VYP+DKppGvZF/iJZkes3XtSDZaUTElpPSJC4qKEA+IDEKs/Ui4KEIvTu4wXI8J
         3lilue6CDK4ZzQ4gFRya+kkvt0dekc1NRL1nJFdeziAbBe9NKS4ezg4+Or7HTgbmzLTX
         gYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=CHfvij52f42wiV93oMvaQu8y9fqe6f+9BuTe5cXY1/4=;
        b=keefl0gCUcvgviNNRq/E6GPefX3O5UTjJcErRSyq8KtJHl+r5/4cJm2/gfRqnZxj7p
         ikkijJxNS+uVuEaM304m0fptBh33J+o8wNiLBv+BxKCLzhc7xuE/K4mFnLquXXc23u9P
         Z0yPIqhdmFm7KdnbmkB9kYRmv5wwdsUtNzoyB8J2YVrKGVl6BPc6D+odJhO5gb5lcPf8
         7N3ITYoZQsvFgFXr//atn4TcAeQjEp+h+3Ih2W7z8q49wVFNM2y+F9BQoiSnQDshnDL+
         4s/36pzX8a9ybq5oMQgl8cwzetHsuPczn1qNGCN+3WjftuZ81/N3MDxdRg7ZF1wrDyZ8
         RKIA==
X-Gm-Message-State: AOAM533B9zFPujqCL4rtZiUk9puCXIEg/JY4AqRzrtNIAGq4KZKUopEH
        k5hqKh5wzo2+pfjSzVtyQsjGahg1tT0aIA==
X-Google-Smtp-Source: ABdhPJxu3rFfkFwbQrcsBaYPYuhvLI8mAxipgHum8Z5zK+d9FTvHk+f/D+VIwX4h4xc07oCjiLQfWg==
X-Received: by 2002:a62:3542:0:b029:2d8:eb3a:f082 with SMTP id c63-20020a6235420000b02902d8eb3af082mr16404663pfa.66.1621704016663;
        Sat, 22 May 2021 10:20:16 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g19sm6874577pfj.138.2021.05.22.10.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 May 2021 10:20:16 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.13-rc3
Message-ID: <1d266b00-9506-df9e-bf58-10148eb821ee@kernel.dk>
Date:   Sat, 22 May 2021 11:20:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

One fix for a regression with poll in this merge window, and another
just hardens the io-wq exit path a bit. Please pull!


The following changes since commit 489809e2e22b3dedc0737163d97eb2b574137b42:

  io_uring: increase max number of reg buffers (2021-05-14 06:06:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-05-22

for you to fetch changes up to ba5ef6dc8a827a904794210a227cdb94828e8ae7:

  io_uring: fortify tctx/io_wq cleanup (2021-05-20 07:29:11 -0600)

----------------------------------------------------------------
io_uring-5.13-2021-05-22

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: don't modify req->poll for rw
      io_uring: fortify tctx/io_wq cleanup

 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
Jens Axboe

