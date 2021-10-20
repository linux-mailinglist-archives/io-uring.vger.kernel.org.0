Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C978E434289
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJTAZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 20:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhJTAZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 20:25:29 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DF0C06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 17:23:15 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j8so20234987ila.11
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 17:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eNZv+0QpUa+7Sjswtms6FXEEYB4ypSe6RF/TIep8D10=;
        b=5AyhzjTmf8Sss42L2vOLwc5lPumO4lGA3sBKB1AGccaKn5S30Ll9azv2eRCsKV/9O5
         wmdRzkOXdCVH5Bklv2jKcJ3DI8K1btUljOAv3coz+vgwAWsrpFfqhvzhh6UmCsaH+xnQ
         1cyTXfZHxfXPUfqIBwZpE70ztsGFrSXWHbYcAjK+jN58Xr0iU6Jp/3mPbs5oM0mZBeal
         2V+i7CaxVFwpndBMmZB0vwxP7yVZ4BIzDNNZQ8U6nX3l/Q0JYWItB7cuQZY2a2RBAzUh
         jRHI5n5CRz41yQ3WNWe571p7xfym+qamLr3rKzOfLppdSpR5szSMvJ1SB9sneDUg4PGC
         gSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eNZv+0QpUa+7Sjswtms6FXEEYB4ypSe6RF/TIep8D10=;
        b=quXeZsx75We1b7QLmOFOdb9GIdz77dsk7IemlbFWO8r/fy+LuqGe+v/ethbkcp4qax
         hcWMzI5javg39n1PTddQo9PtDhsPhdQ/3StO6d3c/SvJBvCF3ilsuCnUcNF/V8rrGQ/H
         iihqIu13ad+hluQfrgydXrqMyoyGcYprAjEoe5QmkAG2xFgrsfnAL9rwOre9NpSjh1zX
         oVj908t5uwBtrzDcuOfuxTEclQkNw0LbwJjlbHgUoCk2yZdX52H/YEpWFUJ3i6uu1qd/
         /3rY8BzkUu7UhI6FNUSFiAoPFsoj0CAbcyov6GqetPEBRdb5Yl8poPDplEzE0Xs4rYEA
         swHg==
X-Gm-Message-State: AOAM530q5QeZO8hqfgdi5+mV4Du9Q8vkRSK8hGdkYWYEGR7UVm4rQB32
        kUqTsM01ut4tV3gFQ1UgnXRvOQ6JDLJE+w==
X-Google-Smtp-Source: ABdhPJw24i80AbjNEHBWRRxXxFWccluwaJ2TgcihapYgQpyBRZco47vljNsVmm/kUM9WPL3LTj1hag==
X-Received: by 2002:a05:6e02:1d8b:: with SMTP id h11mr21944614ila.51.1634689395115;
        Tue, 19 Oct 2021 17:23:15 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m10sm314553ilh.73.2021.10.19.17.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 17:23:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.15] io_uring: apply max_workers limit to all future users
Date:   Tue, 19 Oct 2021 18:23:10 -0600
Message-Id: <163468938922.717790.13688906551452218930.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
References: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 19 Oct 2021 23:43:46 +0100, Pavel Begunkov wrote:
> Currently, IORING_REGISTER_IOWQ_MAX_WORKERS applies only to the task
> that issued it, it's unexpected for users. If one task creates a ring,
> limits workers and then passes it to another task the limit won't be
> applied to the other task.
> 
> Another pitfall is that a task should either create a ring or submit at
> least one request for IORING_REGISTER_IOWQ_MAX_WORKERS to work at all,
> furher complicating the picture.
> 
> [...]

Applied, thanks!

[1/1] io_uring: apply max_workers limit to all future users
      (no commit info)

Best regards,
-- 
Jens Axboe


