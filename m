Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFDD4363F9
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 16:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJUOWG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 10:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhJUOWG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 10:22:06 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18373C0613B9
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 07:19:49 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id y207so1010545oia.11
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=1emMqyAchWzI9cp+VjAclMFkf4LW19JhgEGxwl1kydY=;
        b=lG62/OidcQB/CpBwlxbn+Wre9dttx3U5hSCXmCIaI3TkrRa8dYtMjBPf8ixjNYFh7i
         ROyCC3rGPy5U5VFa3zpmiaFeRy5RSI82ooi+tcA42tPzR0mMH1bqWZJfdALMtB0cDDuP
         tJiR8GY5XyQX0FMzGg66WSH2NPPYl3h5A7HbuvboiSLjKM2wmL08FLCvqvyGM2mkNObD
         fNM+IPHyuBY6uoGRtf9dUKbgCZiVH99E7bh/JcuFaaqtjOhgOjfri5kp5GUVfEY0GdsG
         5LXNBW7NjyTHQRQYITM4ulRN25P0RUZ40SjA8DjvEbhkxgIszIyqvIx7lV4NhwMk/2Co
         1crQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=1emMqyAchWzI9cp+VjAclMFkf4LW19JhgEGxwl1kydY=;
        b=sVuswsvFQs/tjCMcml4AW6sghtdlTLTPi9M4D7x/oP89ArEyZotmnWShxYGQ0BRL/O
         pBuO89soA7qUgIaeQodm4W74k56zP6i3GAVHf3Hfr6zi9qPfo906FmA7h9UijmF1S5IZ
         9J/453IRoZGtawwtTPSY6BmtEFeXn7PCFcRWmaPap/HNaJorHESpXDSqE74jVYuN5WFJ
         cEyskHPpbqNbE5BDR5oIjrnvI3LdQ0UoRYTZCgpk9Qxc8re/fpM2jf3rXyZ1NT7KXSZu
         ioL7k+6pW0vKoeFxjijjrHVAV99vowHIdEaSeaau0fNo+V9JxufBSNovysLNQs06FTeH
         1T5Q==
X-Gm-Message-State: AOAM530tvjiJ4W7yZxqoohdyU6Ha+RWSr+Xn1bnAf3Xit9k69sZnXNJP
        LpIR8n+7LGUj5/ZOUkr3KoxQAA==
X-Google-Smtp-Source: ABdhPJyX7xLep/ORXea2DGSvlQNpS5Pbj61Q5QIoNlODN5DEXoDrpI6WVnhPGPfJY/s51+t7jeeKZw==
X-Received: by 2002:a05:6808:bc5:: with SMTP id o5mr4460946oik.129.1634825988417;
        Thu, 21 Oct 2021 07:19:48 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:783a:c43c:af64:c142:4db7:63ac])
        by smtp.gmail.com with ESMTPSA id e23sm1089300oih.40.2021.10.21.07.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 07:19:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <d6e09ecc3545e4dc56e43c906ee3d71b7ae21bed.1634818641.git.asml.silence@gmail.com>
References: <d6e09ecc3545e4dc56e43c906ee3d71b7ae21bed.1634818641.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.15] io_uring: apply worker limits to previous users
Message-Id: <163482598629.36602.1320134322683172651.b4-ty@kernel.dk>
Date:   Thu, 21 Oct 2021 08:19:46 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 21 Oct 2021 13:20:29 +0100, Pavel Begunkov wrote:
> Another change to the API io-wq worker limitation API added in 5.15,
> apply the limit to all prior users that already registered a tctx. It
> may be confusing as it's now, in particular the change covers the
> following 2 cases:
> 
> TASK1                   | TASK2
> _________________________________________________
> ring = create()         |
>                         | limit_iowq_workers()
> *not limited*           |
> 
> [...]

Applied, thanks!

[1/1] io_uring: apply worker limits to previous users
      commit: 7c810c192d6c18213db7cafc647a46398519094a

Best regards,
-- 
Jens Axboe


