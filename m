Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6F443750
	for <lists+io-uring@lfdr.de>; Tue,  2 Nov 2021 21:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhKBUcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Nov 2021 16:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhKBUcC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Nov 2021 16:32:02 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71955C061203
        for <io-uring@vger.kernel.org>; Tue,  2 Nov 2021 13:29:27 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e144so210042iof.3
        for <io-uring@vger.kernel.org>; Tue, 02 Nov 2021 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=iPJd9JKTKxLNWmDdjVV2bUXNG4tGl0vH0hJO+CARqRw=;
        b=0iIp4qk45JZl1eOFfgcQuEuMyPgmWAp0PIdI3whd/fVgR7yCJcpTMnISa9O/U0kOC4
         fkeVFp5HJNr8sa0uTicRXc3EZBGSQO89AFaXTWBRevZ2FUpL1BjDnIuvYX+8zielpi2Y
         hRvnIJ2n2MshnrHULrraf+auIzUpvcqzwQ9lcVM7hSSwDJQCZJiYn4v1bpgEzjtP4nZF
         tbBvbEWNy7cXTpi8tN5ZxwwbFH3TFwoK6NOfCi9dmRoZ9oBU1FAZRa9O+ijBcP8K7DaN
         s4xkAjz1XS1frafIHcKGwm4xtl5cxoq9rqlZbvdUH6YBrms7Q44h3axld+Yw1xYLktCG
         zmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=iPJd9JKTKxLNWmDdjVV2bUXNG4tGl0vH0hJO+CARqRw=;
        b=lKgp4QRtblbJhURPw0Ww58Qgj8hUpsu78IC6qcMkIdTAmWijkh22I/TlZxYQu3lI3f
         rVW4FCCyaz8D15/KA/ORqr+g2uuh7Hy4TXAQ5oAk5d6SqGJyT3VbhcUviOAaqG8SWelV
         9uAVQFKsw3K0ONVKhfXsIIc2smq+j84CFtukUXnNpv668XaI4cpTjYPy6CfJozAknHIi
         GI7IHu/agU8mwp4Ywx3BqSQztYJO8j0L/PeMUTYxqU/jMEjtenHwzbpDP+ZG26+qcTBn
         QXBlPdzHJGcYHqHSL3Ux5JjqKSjJ2xD4NFi00hisOsc1XYr67bDt2JB1Fu0oFoHlGald
         buHg==
X-Gm-Message-State: AOAM533J1o06krMoB+3LJphEDEgvys2XIaosn2dPSn1Zxfpf790SET94
        iZ2vzfAlmUMLZSJh82yDJ+8fOs+ecIdW1A==
X-Google-Smtp-Source: ABdhPJwnz9iQP8TzSsd39fWJULmH8Pcme8HX4Yxdc1kaIrDPhustKj+Qk4HQk3fIwuIJsC+FHvvgow==
X-Received: by 2002:a5d:804a:: with SMTP id b10mr25637599ior.197.1635884966849;
        Tue, 02 Nov 2021 13:29:26 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y12sm76815iow.2.2021.11.02.13.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 13:29:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Nghia Le <nghialm78@gmail.com>, asml.silence@gmail.com
Cc:     lukas.bulwahn@gmail.com, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
In-Reply-To: <20211102190521.28291-1-nghialm78@gmail.com>
References: <20211102190521.28291-1-nghialm78@gmail.com>
Subject: Re: [PATCH] io_uring: remove redundant assignment to ret in io_register_iowq_max_workers()
Message-Id: <163588496632.461656.9257626147763186958.b4-ty@kernel.dk>
Date:   Tue, 02 Nov 2021 14:29:26 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 3 Nov 2021 02:05:21 +0700, Nghia Le wrote:
> After the assignment, only exit path with label 'err' uses ret as
> return value. However,before exiting through this path with label 'err',
> ret is assigned with the return value of io_wq_max_workers(). Hence, the
> initial assignment is redundant and can be removed.
> 
> 

Applied, thanks!

[1/1] io_uring: remove redundant assignment to ret in io_register_iowq_max_workers()
      commit: 83956c86fffe0465408c7d62e925d88748075e00

Best regards,
-- 
Jens Axboe


