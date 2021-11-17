Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFC7453D1F
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 01:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhKQA1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 19:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhKQA1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 19:27:36 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E110FC061746
        for <io-uring@vger.kernel.org>; Tue, 16 Nov 2021 16:24:38 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id i9so943737ilu.8
        for <io-uring@vger.kernel.org>; Tue, 16 Nov 2021 16:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=/pEfGkWQBLFClD5gaoJQWvWctAYpNAJTcnDj24nvJm0=;
        b=miT9XQdXFknzZPA34wqinbKGbyYqUl01gPASe9MSyu35Rm9geaNpp3+iCRW9h9z5pS
         3fQ4P+W+ZRCBFo5mKP6pb9N1qbmnXClY4XE/hut/sSK55IXGV9n9mikp4ZWIDv8VsoQL
         EfOz3zzD1YMmQrgKX6Pd4pLKIDDvnC3RIpKSaRb1BtuUU+0TSrHZbQTs9FEVHJFRnb0M
         7rJc3ydeGxm/7+CxxOtkIUvtoYsUQbnYBgx5+8W3xzZqvkpncCuVc7Jl0b1c7HACkGx4
         2na4XEgUBMV7l6H6ZTevRhIJfF2HyoBQxvWeRuBIeOfMqXCYJIiMtLiVAxulnIV65JR1
         80CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=/pEfGkWQBLFClD5gaoJQWvWctAYpNAJTcnDj24nvJm0=;
        b=qbzTPkbpHJjCrzfUGZ5zUdnke2KMr07TWZjFPBP68rgvq99EH75OSu6FghwFhTGhKw
         9GJaDiY0jpQb1wllcuePzWoR0sbdaPC97vPg0VDcxIrW1x3frUG8I4vVzN+AOTj1qteh
         QFdqFUdxdt+gPSsgkDA0qf25XNwvWn443EWdrkJ90KEz6iyQxfKT88JTRGdaatc8diA6
         vvXGSJOx3rkKKe+ePQIrDkgV4an4pCdpFuzolXgcLMVM5DbvqFAYX4zrqQ5ygl+MIcQF
         yJDSWKoTT3ctRQtBweVjh+pBXoHqmBWqK8vCEtMQljQ969weJHvt7/ge6TkH9eHFcLmi
         NUzA==
X-Gm-Message-State: AOAM532MSIHGXNpfvkxt9d9fEVaYqCpFWUAXNnCP/HsAOoWL7gQj+zYi
        10eFGjdRTMi4k9L5PQV2w/ERp8nxUAX5/Qi9
X-Google-Smtp-Source: ABdhPJyMeDC3egt4W/paF4N9v3vze/pMMRkkFtMSEGbbXzixmzAX5weF9B/O2vn0TrubxWcFY6egCQ==
X-Received: by 2002:a05:6e02:216e:: with SMTP id s14mr7536860ilv.247.1637108678118;
        Tue, 16 Nov 2021 16:24:38 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o1sm12109540ilj.41.2021.11.16.16.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 16:24:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211116175530.31608-1-kamal@canonical.com>
References: <20211116175530.31608-1-kamal@canonical.com>
Subject: Re: [PATCH] io_uring: fix missed comment from *task_file rename
Message-Id: <163710867764.168848.11469885210160402299.b4-ty@kernel.dk>
Date:   Tue, 16 Nov 2021 17:24:37 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 16 Nov 2021 09:55:30 -0800, Kamal Mostafa wrote:
> Fix comment referring to function "io_uring_del_task_file()", now called
> "io_uring_del_tctx_node()".
> 
> 

Applied, thanks!

[1/1] io_uring: fix missed comment from *task_file rename
      commit: f6f9b278f2059478e9a57ac221995105641c7498

Best regards,
-- 
Jens Axboe


