Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD7D43E836
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 20:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhJ1SWC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 14:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhJ1SWB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 14:22:01 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A86C061570
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 11:19:34 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h20so7928769ila.4
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 11:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=ZHobbc0m4EH68nDbyiVn26N4qIXV/qeGKAN7lXqZXWA=;
        b=kyGqFf2fjg3+6JnLbw/msZ4V71EnPt3KkjUkU8kSvm8sIcO3H5LBYf6R5qeVOh80/Q
         LIvAFoBR+lRBDvJP0xRrQ6jzEA0EjWDeHb4ypJMRDEukLeJPTgan4cSnTmzMQOEkc580
         kwz13tbJU1Dd8X4cvS6mq+ErA5MNnay0mBS4NvX7QaD27/JlBhWIaTtpv4TFvKXbe1dl
         yxVSZCHX0g5mpALrt6IpudxHAAnDM10402XRSjU7/iomAWBifkpqlfShSKuD96N0qzns
         cpu+mAZY5DfyPTQDnq36RsprhAVKnlEPJ/0TDB+1aUMDuMepxWzk+Hp6r//6/VAj1nCO
         dpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ZHobbc0m4EH68nDbyiVn26N4qIXV/qeGKAN7lXqZXWA=;
        b=aYkAgnW0w8TQHBAy1auetYDqP0d0yDUuwZQTPh7kuAv4yKxUnG/Vus1pDTCSDyqMlh
         RUAIos+VjuuVdMrfP6F1w075R4MxMXcJDQ9IiTeOxKsF8O5LKXbCQnXpNunEbfWsbl0F
         qxgaZopxIZDi5QBTzmSbOtxfhXyTm+aFLTu223lOKo/h2BWz8wRXByqI7JoVKX4nhvoi
         eJOkxKGeyPSu+BqgcTDI7OStJVoeUdGSc9MAIjZPJSvmvJKS9mAUnBePAQ8dX4emCNl0
         Q6Ad+nXkbCJ2G6JZSab/kDaZB2SmwooTB+uT3CaKklJu3eeITYv22RyhesYz38goVdGx
         2g8A==
X-Gm-Message-State: AOAM531B690STYjK6H7E94khIlj45y3n1Dpi0eo5xGbCsWQecXGgA8Rv
        SBUwD1PEpO5FUiaR8y+m9RoO/FZmv2GnQQ==
X-Google-Smtp-Source: ABdhPJzH7tk7dcWB2e/0/LUiRqcb9PPqJuth5Sa/mUpBhpIbxWxlxaFGMca5irE0U7d+M7r+eT5TYg==
X-Received: by 2002:a05:6e02:1987:: with SMTP id g7mr4357762ilf.137.1635445173408;
        Thu, 28 Oct 2021 11:19:33 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g8sm2027726iow.36.2021.10.28.11.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 11:19:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH v3 0/3] improvements for multi-shot poll requests
Message-Id: <163544517302.151024.5113520590406591053.b4-ty@kernel.dk>
Date:   Thu, 28 Oct 2021 12:19:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 25 Oct 2021 13:38:46 +0800, Xiaoguang Wang wrote:
> Echo_server codes can be clone from:
> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git
> branch is xiaoguangwang/io_uring_multishot. There is a simple HOWTO
> in this repository.
> 
> Usage:
> In server: port 10016, 1000 connections, packet size 16 bytes, and
> enable fixed files.
>   taskset -c 10 io_uring_echo_server_multi_shot  -f -p 10016 -n 1000 -l 16
> 
> [...]

Applied, thanks!

[1/3] io_uring: refactor event check out of __io_async_wake()
      commit: db3191671f970164d0074039d262d3f402a417eb
[2/3] io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request
      commit: 34ced75ca1f63fac6148497971212583aa0f7a87
[3/3] io_uring: don't get completion_lock in io_poll_rewait()
      commit: 57d9cc0f0dfe7453327c4c71ea22074419e2e800

Best regards,
-- 
Jens Axboe


