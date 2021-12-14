Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DEF4743D5
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 14:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhLNNtN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 08:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhLNNtN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 08:49:13 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C93C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Dec 2021 05:49:12 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id k21so24114869ioh.4
        for <io-uring@vger.kernel.org>; Tue, 14 Dec 2021 05:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=P78XbaiFf1P0CIOuNoZI+DQV5uBTG/ZwL6wTkVOR1L0=;
        b=Dj6OGWXW5BiSwXO1CTxaAjPhuuIE+zSEG49ONANIpJDUU8ccp17eJxWRbxwxZGFFVY
         uQj1tvwYke1J0Btiea2fhm/4g8cI/zPYPKazw9LL3rO0dkN9GreB48qlvhqWZSgxtmft
         aHIPwP6xSy+dh7YG2VYz8I0Z+Y02GdcRM7NHJci0LFYs7O/mAIIIlszGtwftDnmSZ63q
         5D148c6MpTvD1F6P6uio/DkBmeOnBbPtJLK9PC0/FNDKYKYYNcPWDZLRtYGIbzwsKue4
         BfqySuXVD+e+6jVAmopIFuXeVDBvbsB8xbxlc/yJ1ml3azw5KESVWYjLXKLqS7YoCPob
         WPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=P78XbaiFf1P0CIOuNoZI+DQV5uBTG/ZwL6wTkVOR1L0=;
        b=V6moSKQ7jDI0HuS9+DwfU0SQ/dnd9jiWc4Euvrdyi6RxN/QHKkfyo3rnEQQxqUzSy1
         IjbVkt9JwkRpbUMf5RQRWaKt+HcOfQ3OqyEoKRMfJPMku7fX+ZqgA/dQ59L9WNV8Z5oU
         MUECUXOdfcd/lzE6UrNSybrZcb/gQL6xGS/vA1J6Uvl9xfl2OvL/s5SlZdGwUpTxXO04
         ciJHwHTBYRC+/hEszyicYR4mz/iI4DNFSFVIe/cf3gZyXhMA2RFu7H+kEiVYo2yZK3Yf
         baiGRVlLgJ2aBFMrCXX3MbCmDEx29YN3BO5B9q3vj8vrtbfHXdJTswI8cp5gvdGdVtSl
         75gw==
X-Gm-Message-State: AOAM531OGU0uDx22uX9kNOCXjHbJNUXImLNdiHukBmO3J406GOA/EVcc
        bwCODd82jcPlK0AE3S+ne5fWxk1RYzQhzg==
X-Google-Smtp-Source: ABdhPJxPPB6SUqQeZLdfG1k2JTMv4W8oSsgMFhu6nhrtaZpDEWtl20uuElvjSNSuTyqWRydhlbo8dw==
X-Received: by 2002:a05:6602:2d49:: with SMTP id d9mr3661230iow.153.1639489752075;
        Tue, 14 Dec 2021 05:49:12 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r8sm9388729ilb.10.2021.12.14.05.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 05:49:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20211214055904.61772-1-haoxu@linux.alibaba.com>
References: <20211214055904.61772-1-haoxu@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: code clean for some ctx usage
Message-Id: <163948974995.173006.6380511402475526597.b4-ty@kernel.dk>
Date:   Tue, 14 Dec 2021 06:49:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 14 Dec 2021 13:59:04 +0800, Hao Xu wrote:
> There are some functions doing ctx = req->ctx while still using
> req->ctx, update those places.
> 
> 

Applied, thanks!

[1/1] io_uring: code clean for some ctx usage
      commit: 33ce2aff7d340bf48875ccd80628c884cf8017ae

Best regards,
-- 
Jens Axboe


