Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB88D4309BA
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 16:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343851AbhJQOZz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 10:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343853AbhJQOZz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 10:25:55 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19B0C06176A
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 07:23:45 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id h27so6514990ila.5
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 07:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HmFVb8xcAOPn3KFdgt6HcfcE/AmGQRsTzReX+3wjP4g=;
        b=aRNuyuJrq/vs5oWRNzTycUP/Fg9XrqqlxawcmiY6GzOT3VVhg77DO+5g6T4a1lMBD8
         V4Fy7cR0E9gqtQ/HNAOxZ0HRNDLiYxo7gLVY+3NbFJ3tEoi/SqZWW37OIh/Vm444vTuj
         /qWlv3JBPrWp2eEyA9wrirrZDV6wHKmzpYxpyfnUNaQoIr5HIWZBqPhRZYx9YRAE7jwW
         AJad8Tjj79siCZzMvK/BSS4J93j5zHKgYfIZ3Dj0D/8SJnwidwePXVe3Qsn8p7EG9bST
         UFaQhbXTNVCuT9ObfL/wrPjP6cxGPUZ6qRPluLWDVKya/gL4RmX7+o3tkvfe0wqDLmce
         5mJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HmFVb8xcAOPn3KFdgt6HcfcE/AmGQRsTzReX+3wjP4g=;
        b=RVKvxS1Tiptf6eUKVdT+0W6TUpYbaSOPAz6vR0rEIdIuKIQastwTkPD5tqCeePrb4m
         hn399Np61Tcv+tPuXUuEAVG2/Eat0UecDSPr9RgARU5wex83JZjC4LrXlQC3soNJzwbH
         2wLQ6XDOX4ApXyt9iLPXSll2TTBN0HMtLAUKG3QHK98qAMQXcHhOYA0D2UEirVW8WopX
         Gx5g+OJB+PXJOonb3CZNMG/bpz7wC4RADAzeQwefP/wz4XPqx22YsRIJR8SdVd+y/9Xt
         9QQJZEsueBNeCahqByJvqZpwrFU0lvGSmX6oDEPX8n4x83ngu+kTTzoAuCt4Rfedk1OJ
         ps3w==
X-Gm-Message-State: AOAM531t5roiu1AULvGvcVkFV+/UP7tC7Kori6/9NLOD2q07fmnCEjnp
        UQZPSBGuBJwz3bK4ISlbVwtTfw==
X-Google-Smtp-Source: ABdhPJyqHtmY5cjGgxMH+VFZv2kYgLniApzrSDObuA9jv0+XHREHrnXRPLybVSIbP3U0NTzNuGKaNA==
X-Received: by 2002:a05:6e02:1aa5:: with SMTP id l5mr10279705ilv.268.1634480624620;
        Sun, 17 Oct 2021 07:23:44 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v4sm5693755ile.24.2021.10.17.07.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:23:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH v1] fs/io_uring: Prioritise checking faster conditions first in io_write
Date:   Sun, 17 Oct 2021 08:23:41 -0600
Message-Id: <163448061835.101565.1242197523580881975.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211017013229.4124279-1-goldstein.w.n@gmail.com>
References: <20211017013229.4124279-1-goldstein.w.n@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 16 Oct 2021 20:32:29 -0500, Noah Goldstein wrote:
> This commit reorders the conditions in a branch in io_write. The
> reorder to check 'ret2 == -EAGAIN' first as checking
> '(req->ctx->flags & IORING_SETUP_IOPOLL)' will likely be more
> expensive due to 2x memory derefences.
> 
> 

Applied, thanks!

[1/1] fs/io_uring: Prioritise checking faster conditions first in io_write
      commit: 02a8286be94bb1fce86afa6b487717eb4ca2956e

Best regards,
-- 
Jens Axboe


