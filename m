Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BD5488A85
	for <lists+io-uring@lfdr.de>; Sun,  9 Jan 2022 17:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbiAIQXT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Jan 2022 11:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiAIQXR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Jan 2022 11:23:17 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C30C06173F
        for <io-uring@vger.kernel.org>; Sun,  9 Jan 2022 08:23:17 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id j1so4489078iob.1
        for <io-uring@vger.kernel.org>; Sun, 09 Jan 2022 08:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=J6SPWfpcl/On78dhjVOegYb7gAP7rE3IMkkVfzpHbek=;
        b=YLRgclS250pN54tsljehmuuZcIo35OHHJMZ20uuAFMgJTtaxw7wuHezGEvrgvPhfOn
         xfZD+mHWFIqoArJL4B2N+GBViUVCnlNANBn+wu91YmetpuSxomC/hEHZUL0zGiUcLZdg
         f4Y/PihfiZK/ql0oQX4Y7ujYrLLNx5jF9AVEcEAYyiXeGVf8EMnFMIKpQkGY8551DdVk
         jaCWj9RrJ37fDmfrliw0/6NyeVKxd6dxqE6ba8HQmlhXmn9JSTuDmETl/VoJZMCy728v
         fh97EsHUwY2recidpqocp34qMvvUik4ZMMIfc50VzMfZrIdczVBFIhLNZlIsNldxAXXO
         7QIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=J6SPWfpcl/On78dhjVOegYb7gAP7rE3IMkkVfzpHbek=;
        b=06irzos2NNk8hAwGBmvkpZuXVWy/GocEw4eHfULrtVinPweOB9wIlu8c24nKIT1ZrE
         B95mwEJn3sqOJpXL9nJcYHqOjvQYaj8dW3UsQJGVTPIEhip4cSuevVx8HWxGLaOmuKJr
         uW8jnyJQLKBP+G2I+re3ng99ARiZTW4xnswkgFCjwGgGySHKRscN53k+/HiiShDnAKWB
         7kacbpzGGq/ExpGn67Avx4kP4LnQoTtG1M53pGUQ4o6T5MtVazuO92Pbdfhnyg9Oj020
         DdmawrmJ5Afh368K68ohdXTjReOWC52pNgt0R8I25kCbVXrf9c3HiZL17nIox6DoOzxF
         hxfQ==
X-Gm-Message-State: AOAM5339fDT5z4Xoh1iTPuqYISCYctpo8v/4NHiJrnO/ZJZj7dtWQra6
        0+os7Sl6K9WGi/lB/0MfX8pLiaS/k7R1VQ==
X-Google-Smtp-Source: ABdhPJzfomc/cIBUioK43UFpGVLR5fiUKpgBdzijDCdpX/H7QkUu7t0H8ZNjE6sc+EDC7wvkZWJrRw==
X-Received: by 2002:a05:6602:2a4d:: with SMTP id k13mr5452706iov.61.1641745396392;
        Sun, 09 Jan 2022 08:23:16 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h23sm1064070ila.81.2022.01.09.08.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 08:23:15 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
In-Reply-To: <69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com>
References: <69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: fix not released cached task refs
Message-Id: <164174539343.69043.6549592398281965008.b4-ty@kernel.dk>
Date:   Sun, 09 Jan 2022 09:23:13 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 9 Jan 2022 00:53:22 +0000, Pavel Begunkov wrote:
> tctx_task_work() may get run after io_uring cancellation and so there
> will be no one to put cached in tctx task refs that may have been added
> back by tw handlers using inline completion infra, Call
> io_uring_drop_tctx_refs() at the end of the main tw handler to release
> them.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix not released cached task refs
      commit: 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9

Best regards,
-- 
Jens Axboe


