Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A7145FEEF
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 14:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbhK0Nve (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 08:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244740AbhK0Ntd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 08:49:33 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C8AC061748
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:46:19 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z8so1835005ilu.7
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=I09dXYBdkRNRKAa7hQiK4DfJyKu7Jq9nifkMmOHxic4=;
        b=ybsdmYrqNgLXQetk2oxgZTPL78NrKfFll+f4GROVxX1cpliQKauWFchoH0NBsOwbbX
         4o4awzWNnxLU/c6Z0TD3LHpw7chWJzXGGntxZK+qajhTJiGGyEfEpxIlI7TlTLhLzNYL
         0vzo8dzqiSGGjV+u8YOv6kt5m1hVKGPMO3PHoOm9/mXUGj9taNEOXU//xpy3MFqKGAl6
         +pP9ab6o7Wes+cUHcNzMioN4eh7kaVG/JUBUTtVHrF77x/O6jv4H4XnZZuOknPydHQx2
         HJ4guqNP6Cx6HdfCwCx6QgHIwWhrba0hG0qOCNg48r7XP2lhaJf46qrPv8oyZDLg8I9A
         ZJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=I09dXYBdkRNRKAa7hQiK4DfJyKu7Jq9nifkMmOHxic4=;
        b=HAzTotWtTH6pLo33/qiUArKV6Q5bqocDS0lmgjgOA3SvOPy4BsncCTgHFoFXb1AI1t
         SADGSaNSYzwbcnzfrGsr7pFS4yJJ7/rn7PMCgI7yOtMDUmRB9yAUGmgZ3UsaYGxhEauU
         1h82hkhpQr6TpR2Cj5FRzJY08SeMwRw9KGhRmgqC2qgAErDQkW1ZybhwLcVWE2K588sU
         Qd1QnloVWgFl/yUquvuQssv1ECLIp3NIrq1Hi2HMSLZq2bxJkcX0sspufF2ahZmxNKmq
         QMRUMIlWzI2FClIQHAFWxfqxxFr83SoxNRJnxXW/Viit8NIbO4gw+p1k6D+TwUeSXRLi
         yKIQ==
X-Gm-Message-State: AOAM531KbSZ+MzlLz+U5X3Tx1ZWmoo/zjsPChx4pB36ZjxO8Gx7debyh
        YtQ90k4tWFdlZoqo0tSW9LZ5Ar7nPKCOTkW/
X-Google-Smtp-Source: ABdhPJxI/564HSr4Z2rSWCvQ7JB3e+P3KsU3bxBsUAIBseVbc+Bd3YPM/3xdOqXxLHT5AwE0k9H2sA==
X-Received: by 2002:a92:cd8b:: with SMTP id r11mr17107880ilb.39.1638020779076;
        Sat, 27 Nov 2021 05:46:19 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s3sm3852576ilv.69.2021.11.27.05.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 05:46:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <21ed5cd19ba6cff23714dddb07358360a1ac6f91.1637955206.git.asml.silence@gmail.com>
References: <21ed5cd19ba6cff23714dddb07358360a1ac6f91.1637955206.git.asml.silence@gmail.com>
Subject: Re: [PATCH] test: poll cancellation with offset timeouts
Message-Id: <163802077848.625324.14574141113143514056.b4-ty@kernel.dk>
Date:   Sat, 27 Nov 2021 06:46:18 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 26 Nov 2021 19:34:05 +0000, Pavel Begunkov wrote:
> Test for a recent locking problem during poll cancellation with
> offset timeouts queued.
> 
> 

Applied, thanks!

[1/1] test: poll cancellation with offset timeouts
      (no commit info)

Best regards,
-- 
Jens Axboe


