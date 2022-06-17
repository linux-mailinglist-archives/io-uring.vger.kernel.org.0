Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D513154F96A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382846AbiFQOmi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382855AbiFQOmc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:42:32 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE012563B3
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:42:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i15so4070202plr.1
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=mGoLT9uaYn1woScggxtINtSRkzFROingnpgimoAGt5M=;
        b=uYLqmzSFUukCHGRsQYPJWYnmbdhQB6CLmnLmCVUfGJiFPDpL+sqFW7ZIa6p0Qy+nwn
         Ots0kvIqaYEZ60Ob7jtGobcq1+AFUZSMkNcxQ669jivVLbz8Y2lrbk5sxB2zs13K9D2Y
         sptswNW/UQrK9oi4W8BGLgxv0XB0s+VCTifuiURJuSuHXyeagT6IgRmf7rmaz3Qc2h0q
         Q8QMdPe9UEvx/j1mlJl5N24PJspwSz8H10TcI8kSwQcn7SfMqTTJD6p7QpNoQezRymUC
         deWAk5t3B5VNynOJ4BghkKIWEd1Ed0vgFpowyGhvzpxVmRT9KEyPJy4y7lJk12xKJZJf
         YJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=mGoLT9uaYn1woScggxtINtSRkzFROingnpgimoAGt5M=;
        b=PZD2w+ibhRPbhYee+uqVJvYjjlj2sc/hozSFcseNWXoq0LCeUCGW1vfH42SU6Eo5l7
         hMF8Dw4fgZ6AkagS1RtN3qneY2Mn2etaS3w3B1972GKiVkchKT9PRR4I92OXqh9iM7IB
         ywBJFBXe6l+aZx6mTClZbdtrGO9NmWjFSHg79bNuvXMD3qPu8tBfiS5FDoYJb+48TcQ+
         1S8vmKP5v8Sn/3GRmNIpmUqx6O43dFv8THhCOju848xKMI8SzVTvCHmk28ijhUfdvJqP
         NhBViQqfRcCF97BLmUNdsdnnVKiiyBYz/hJwANdq+21IwiEBCoru4ML81YGeJKBvymH1
         LRPQ==
X-Gm-Message-State: AJIora/fHTfydEBQqfAgIJ6/dNOmCGCiDqwd0BJ15bgPxJC2AyFvTBxq
        pmCY43FiMLMkQplGsyUePR5BRFXHh6iZDg==
X-Google-Smtp-Source: AGRyM1vkMLSMYfqjlDzO33eCB/Q0Ao8ioH6x7p4O6v2gr8d9NY8viWAUE7qJ0qYiPVZ4YTkbtfegNw==
X-Received: by 2002:a17:90a:4503:b0:1ea:4718:829f with SMTP id u3-20020a17090a450300b001ea4718829fmr10823955pjg.103.1655476932174;
        Fri, 17 Jun 2022 07:42:12 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902ed8b00b00161e50e2245sm442567plj.178.2022.06.17.07.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 07:42:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     hao.xu@linux.dev, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220617143603.179277-1-hao.xu@linux.dev>
References: <20220617143603.179277-1-hao.xu@linux.dev>
Subject: Re: [PATCH liburing 0/3] multishot accept test fix and clean
Message-Id: <165547693052.430067.16187262722103894405.b4-ty@kernel.dk>
Date:   Fri, 17 Jun 2022 08:42:10 -0600
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

On Fri, 17 Jun 2022 22:36:00 +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> The multishot accept test is skipped, patch 1 fixes this. After this
> it is still broken, patch 2 fixes it. And patch 3 is code clean.
> 
> Donald Hunter (1):
>   Fix incorrect close in test for multishot accept
> 
> [...]

Applied, thanks!

[1/3] Fix incorrect close in test for multishot accept
      commit: c8909b9e1963f4651927f8f46d1d0420d28bcd58
[2/3] test/accept: fix minus one error when calculating multishot_mask
      commit: d0d9b70d4861bae77b86c05f6925e991cb6c32f1
[3/3] test/accept: clean code of accept test
      commit: 6cc371d3fe076bcad549dbc0e1a95da8fc8085f2

Best regards,
-- 
Jens Axboe


