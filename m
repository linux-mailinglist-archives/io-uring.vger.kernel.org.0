Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F4638B51
	for <lists+io-uring@lfdr.de>; Fri, 25 Nov 2022 14:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKYNfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 08:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKYNfs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 08:35:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068A27171
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:35:47 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id b62so4020603pgc.0
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 05:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qif3mWXzELIc8RUK4NfpsCqwpSafhVNI0AxK0KV8pKI=;
        b=ZTg4nv7ubPVrFBk4hww3K0NHZ044NAQ0aO6R25YNXtKBon3uh+O1KrfyvuG/cQRLqj
         2E8xptLM3M4LF5q9q//EhWuZJZ0GibPa8ZPfm7mZsKmqz1Crmq+6MasNT3HHYtbAV4lF
         aYGmUiE1QAhaK4gpzPdFCjHBbbzzzYxHaiXR8Kmqj+YZ+O4+UbGsTEPcpwVtHa0DS4sq
         jq46gvBwSVbY0Q8rZztk9Ch5qF26HCivBB+KERtuNmOARJySjfvR9y84AIilnfJ+Lnqp
         oeyoduTAi2elyIJZEI94BRKucrMVUIST3hKiVf0JtEJ+qQldBHL1PcNrMN1nfSm1B4V2
         +ipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qif3mWXzELIc8RUK4NfpsCqwpSafhVNI0AxK0KV8pKI=;
        b=0rN7qFBoOzRLBvE0xn4JdihQeGX9SC60kgW/VBt5wxPzjnuIjHXU1pwoUw7CVlc1v2
         ZeQ0fuEXgafGpqZFVNeFHrcaLS+IPwKh+ohq9DSPpO63h5vSUdm5v5Hd9Veeety16gwW
         nStFdW+On6kAwoSHxWU170idZUQ0dxCFuKACbfC67jg1pbFAzNkodQH0sC7nPLYjQ3cN
         kxXwAoVOab5FnXxOIPV8Q7pSsRbEi30jVw2PflrwpQ18P00NbdYrCMktRtavwVrvta4w
         4Jjx1MmcFT8esSryuG0OIkzj9nQK/igKi2QiglGU8FQP5PQmMWZMnmLjC7yvifYYq6h1
         Ql5g==
X-Gm-Message-State: ANoB5plR6FSU2RDxgM0KMu27ix6UMJUh/L+HQkkHvVzy1q20UFYLDDQr
        XjPm6BM81ffSYm1jEUeMIl0sWXH+IfVT8Kua
X-Google-Smtp-Source: AA0mqf6YTGx6KIQ7YbCcdwzP+YwZjb3/13kpDUkYsDZc8Nzy1/+qhz9dTewxF2QBWUNysINDXOOMQg==
X-Received: by 2002:a63:f4f:0:b0:476:a62d:386e with SMTP id 15-20020a630f4f000000b00476a62d386emr15322910pgp.501.1669383347385;
        Fri, 25 Nov 2022 05:35:47 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902f54800b00189618fc2d8sm2284853plf.242.2022.11.25.05.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 05:35:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        kernel@vnlx.org, Muhammad Rizki <kiizuha@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Gilang Fachrezy <gilang4321@gmail.com>
In-Reply-To: <20221124054345.3752171-1-ammar.faizi@intel.com>
References: <20221124054345.3752171-1-ammar.faizi@intel.com>
Subject: Re: [RFC PATCH liburing v1 0/2] Fix memset() issue and simplify function naming
Message-Id: <166938334618.11654.15185615999155085961.b4-ty@kernel.dk>
Date:   Fri, 25 Nov 2022 06:35:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 24 Nov 2022 12:46:14 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> On top of "remove useless branches" series. This is an RFC for
> liburing nolibc. There are two patches in this series.
> 
> [...]

Applied, thanks!

[1/2] nolibc: Do not define `memset()` function in liburing
      commit: db5403e58083bef48d72656d7dea53a9f7affef4
[2/2] nolibc: Simplify function naming
      commit: 0afc00bfb94121d0642c13d060b63cc07614da17

Best regards,
-- 
Jens Axboe


