Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CCF6CECC5
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjC2PYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 11:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjC2PYU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 11:24:20 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C722C2D41
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 08:24:19 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-752fe6c6d5fso9282939f.1
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 08:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680103459;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qGoUSkyv865Ul//fUoRKm2C/3xjZ7aYgc9WSHE/kR/w=;
        b=Tc0GeLsB21Ld61O/b1kan7+0h3+5fA3cKilDha+pEWIWzzm2ZuqE71YawpEHms6y4Y
         bOb45K0mM8XHQTYZCV1qUa6audZthSPZdU9o0KxboCv2JdOyL03064jaE626vDN3PTQH
         1W+ZPAzqFt/Asx62C9Wg1lqaydRcDWcGh0rI9RvILyI+yYYL/Lq+j4xLlzsHj6fD++/q
         y6H+oV5xEsT60GhjOMb8pVAwjQs7ft7fSOKiaZEp05umBeQG5UBk2WhwnzlL7hVp3qPq
         09Dj5RD2f0pXev7syaoSQy5RBvCxwxcEsw4MFoRkczuBYCAurIap7lkLx+z4pL8LZX5f
         77pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680103459;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGoUSkyv865Ul//fUoRKm2C/3xjZ7aYgc9WSHE/kR/w=;
        b=iYGNp/c/hMgCH7QmL36jWikLlxFVYjWcJtQQCz/3NaKU4ZmAVic8wbG1agy92lzHka
         tYZaYJZL4A73KUlhEPExtt/xx6USdgSX9/ZgxBbRnemHxP/3hHAQQskn5x88gD9zNoB0
         9TobhNxMPdQ0aTKJDZMgSh3WHqpgHap655S8cFNsP01Ddx2AjaNHziyVa6kG8McC4fX5
         EaV+Z/wmyJtrhWsUN1aVrdAeNLpKirdwXQ4zKD+pO/h7AI81HYrw0LSEMvq2mrAGZ7iK
         5dijobmWyLhpzwOCsmxrTIgBlGagF4j03QMr01HhJeuz2bu8VF/2pGH76iohiLLob3aO
         nG7A==
X-Gm-Message-State: AAQBX9e9Ar59KXF43JeErvx+C8Hts+ZdbjGgeGmAJzeN6UnPgHkJcLVs
        TWaWJ5xLz0R/vSgxXw8wIGUZM1uuEaWVYG4Os8Wddg==
X-Google-Smtp-Source: AKy350aHbR4SgiK+sZkKqO9wdufDw/s+3HCl74o0KXUvJAFNBgh79keonVTnF5rLYMLXjk4ofQojZQ==
X-Received: by 2002:a05:6e02:1543:b0:325:f635:26c5 with SMTP id j3-20020a056e02154300b00325f63526c5mr7231030ilu.3.1680103459133;
        Wed, 29 Mar 2023 08:24:19 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a14-20020a921a0e000000b00322fd960361sm9238644ila.53.2023.03.29.08.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 08:24:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1202ede2d7bb90136e3482b2b84aad9ed483e5d6.1680098433.git.asml.silence@gmail.com>
References: <1202ede2d7bb90136e3482b2b84aad9ed483e5d6.1680098433.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/rsrc: fix rogue rsrc node grabbing
Message-Id: <168010345823.1105147.9442526394317711065.b4-ty@kernel.dk>
Date:   Wed, 29 Mar 2023 09:24:18 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 29 Mar 2023 15:03:43 +0100, Pavel Begunkov wrote:
> We should not be looking at ctx->rsrc_node and anyhow modifying the node
> without holding uring_lock, grabbing references in such a way is not
> safe either.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: fix rogue rsrc node grabbing
      commit: 4ff0b50de8cabba055efe50bbcb7506c41a69835

Best regards,
-- 
Jens Axboe



