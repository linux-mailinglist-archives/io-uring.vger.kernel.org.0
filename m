Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036015670F1
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiGEOYh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiGEOYh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:24:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CDEDE6
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 07:24:35 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f12so1883964pfk.10
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 07:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=7bPzJBilgLJjSg05R1vkynMI/tN5Z8NL/SrkbbJ7Uh0=;
        b=1/yid8drnW/y5QIbRF2GR/FGZ3skv9F6ZteVAHD1dkonw8PVlcucKpHUVxQL6uozbT
         PotxO3uULTo0/u+/nLGMd84VavNoXw2RvBMXdgTT+3fmoqHX+oD7dmee4bHjdx+rVV6a
         v60bGLsS63vzp/Xmu6wYIR4v/x7UX7iesGDRyu7vxR3EaNKBud1uTjWtU7ht49nzxql0
         IdDwpCdPt9IzPI7LAKTGbcchVMn8rembk1K8yCPO6o8q//ZnKMTKrwmR6INjVTkVRvfU
         0jicTz3gIFohSgK9cgiiCnTXosn1W8QBDV7oTPbr7oO7oDzhq9m8ZQsI/qMnTtOwpy3P
         vLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=7bPzJBilgLJjSg05R1vkynMI/tN5Z8NL/SrkbbJ7Uh0=;
        b=XI7hjHpGqqVJzsR5UamKveBfwu2S+OGfK3vf6ctqplBf/8G0hCEUXThgzf91WV3OAh
         73qSdjAihsZDzuBD2/BMBuh3rrlSa6XtHLAYs1IUTVwU1loxnaeiYHxQPtrGTh+8S69Y
         wWNrwTaIi1Tn1J4tuSXRY4KneZsol0pWwzqBANEV6WfR74E4OLFuQ4xeSvaQjqluDYf9
         MDlE334j0KxIi18TrjeqXCVvyHcBZpyovY7fr5S1Oi0ljC1uKt7ORB7nRqwkOVHBRe4p
         sKgmyzmEz3XwnfSkk++cf9gmQBNsdPdC/uPmHWPnpmlyuQ1b24giegaHLkeOQ2jqx0SC
         LTVA==
X-Gm-Message-State: AJIora98udtpKiYnvRhpodZ3TGSnIAum2mX7PG0Sp8DursLbEl8CZspI
        0z83M3iKh2XCzGLNTkfR1YRQKw==
X-Google-Smtp-Source: AGRyM1vO2YlyXy++a6V54OwKLrh5lbL1/1h/+9i4X6FYuyHYM6Z1jyTOrKzp2/VjgpGlSIBa7BDIuQ==
X-Received: by 2002:a63:8142:0:b0:40d:311c:39be with SMTP id t63-20020a638142000000b0040d311c39bemr30457322pgd.378.1657031075382;
        Tue, 05 Jul 2022 07:24:35 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v2-20020a056a00148200b00525343b5047sm22971541pfu.76.2022.07.05.07.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 07:24:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org, dylany@fb.com
Cc:     Kernel-team@fb.com
In-Reply-To: <20220704140204.204505-1-dylany@fb.com>
References: <20220704140204.204505-1-dylany@fb.com>
Subject: Re: [PATCH liburing] remove recvmsg_multishot
Message-Id: <165703107446.1916500.9733126504302205431.b4-ty@kernel.dk>
Date:   Tue, 05 Jul 2022 08:24:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 4 Jul 2022 07:02:04 -0700, Dylan Yudaken wrote:
> This was not well thought out enough, and has some API concerns. Such as
> how do names and control messages come back in a multishot way.
> 
> For now delete the recvmsg API until the kernel API is solid.
> 
> 

Applied, thanks!

[1/1] remove recvmsg_multishot
      commit: 47ccd7c2c74c2c68d1a2821391ecf71be5566918

Best regards,
-- 
Jens Axboe


