Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBED77C6BB
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 06:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbjHOEcE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 00:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjHOEbg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 00:31:36 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2045DEE
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 21:31:33 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b9dc1bff38so74163761fa.1
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 21:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692073891; x=1692678691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBlFKKqfybtx8tz9xk8muyf7F4xpNnCFr4X/1vnivn8=;
        b=VRJDrmJ3m+x1zee6kxS971ngY43vMD+leBkxiSjfk+LOCfKaeTHJ2RLRsHEzKK4yLX
         qGhEcQEBqN6yli5SdXLnrAR6jvak/EJGWLE/jtawFBlR3lLmcZS8hRoFo1uTuTRAJ2tm
         R/P4aOKHUlBADAXaYtANS+vpjorqNJnaGadXKr+ZrzNcLxtp4Cce7Hqpl+jCS9qt5CQ3
         oeXGsTKMW7AlAR6n+j4iS2VIrKckqGlVRHknu3bYHqjMHwvz1viNCB7KbpR3REZZ4qHI
         988PcgPM8MwkT6ppuQHCaW8AK1WtrDZokr3ZxtiMYsqPPP7ql6DzjsCqOlzedrcfofCy
         6/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692073891; x=1692678691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBlFKKqfybtx8tz9xk8muyf7F4xpNnCFr4X/1vnivn8=;
        b=DlE8miDE82XLSjIgaXTkWwD/bWOPWUz0LQXDUbxaP19JvKqSplM6vGM8S0hTZXYHnU
         CllYZNtgypBG2XpYYcIbGNGSLHCYBcRfM4Z2qpVYFVxETBdQbeeK1KExQz97dqE01Z3Z
         trmSeJn/X49qv+rb5p1OnIL+qyP/KKgpXz1r2n+wdZx3CTkYSIpqDJgy04oobsMoKbLk
         aMSXe1sPSAPZkr2au+ASxMDULQrQDu3xTpoaqQWyeX74PqASkCKSaykro3BvahH+PFvI
         x/50EIS9BMem5+7eb93qNkGEhVnd2rYQRXFraPRWNax+VAgV6HOq36PMgtrfaUJ1jGoN
         8A1w==
X-Gm-Message-State: AOJu0YyqtSxZsKH5C5c4u3It3tQ3CS2j9fo7HSrSIdXYZ8Qbo59/x8VT
        KzjbQaeCOG7Ec2mBWQUaL1WB6rx33xNhYqaKgBfiFg==
X-Google-Smtp-Source: AGHT+IEMFtSNin2OGXKyImz6ibXziYrcLSULtnM6cKYCRJUZ/wsdK2qyyN/WaHJv0VMDynk0WlFBYzLHXnGnAWX74tE=
X-Received: by 2002:a2e:96d9:0:b0:2bb:8cd9:ea29 with SMTP id
 d25-20020a2e96d9000000b002bb8cd9ea29mr338543ljj.39.1692073891005; Mon, 14 Aug
 2023 21:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230815032645.1393700-1-willy@infradead.org> <20230815032645.1393700-9-willy@infradead.org>
In-Reply-To: <20230815032645.1393700-9-willy@infradead.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 14 Aug 2023 21:30:54 -0700
Message-ID: <CAJD7tkZW1wM05JPo4kUjGTQo6kgA2ijQk+YU2g=zt9d+HySrBg@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm: Rearrange page flags
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 14, 2023 at 8:27=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Move PG_writeback into bottom byte so that it can use PG_waiters in a
> later patch.  Move PG_head into bottom byte as well to match with where
> 'order' is moving next.

Sorry if that's obvious, but why do we want to move PG_head to where
'order' is moving? I thought we would want to avoid an overlap to
avoid mistaking the first tail page of a high-order compound page as a
head page?
