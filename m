Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D482860F8C7
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 15:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiJ0NO2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 09:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbiJ0NOG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 09:14:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC28C4F6BE
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 06:13:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 192so1463204pfx.5
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 06:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PI/E/wbVnQ2MKPgDC+nKURbI1KHJoHpnSo99rODCogg=;
        b=BUSTA85lrIY0Y4iSvc4sEDt2a5gk+nHZt5kZFKsCiWhxjuFZHBwnoipvYt1vRLOCOh
         wkB59BhYTX28UDoAqxfTBi1yeX0zPd8iZu4TADFKZUorZP0lNhOIeugRTfFYXHgKa9Y5
         u7N7gWuTaWEIkzL7Whimjh8LAysm701MeSIuAejFEsOG+spKfeK8eJdorbrFB+uUIjw3
         XvXj9kkfHO1zubvvj2S8wpvPxl16OHPlJTSHuVh0XSnDONpcIZWxv0Rjerf7sN4fvvmN
         EcMOFdzRlLQlEWu3dG5MF//sF1+TLzp/8wTdyRK4gUoMz/9NIC7voJL+FU+TD7cMcY/c
         ToPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PI/E/wbVnQ2MKPgDC+nKURbI1KHJoHpnSo99rODCogg=;
        b=O4zyry1rRGlRTlb6SiOmDedKzfsUG6B0aCVjonG+fhmMFo2mfnsZVaMJsnWnBcm63m
         +VGT+0pxLKAIfByQ8YRTfJNoRLmBMAZfwFcrq4TqpwCdctSbt3hN3so8Mx3LfykEt2iT
         KoH5kPj9ieO4z3zOvSERxg4C0dNnZi5gaIxqPmHHW76Vy7e33MO6bBPoNFjmapf14t6V
         t7x+uEg+jHv5eZUEAL+Dax6xhAns7t5BIjQkSI8GXfvF4RPzKeCl95/cZ95d1OH52Qxo
         o+iuR227CNcn40W522BjwL3wx3yFpNibDLFmrH25B+aJYoBQCkXwJqatmXMleQ0keBzT
         UDiA==
X-Gm-Message-State: ACrzQf3k8IGZN2ijCcjDNpZ9/jHCUOYbVXQhH75TpscjK81Ci4adLBfU
        SosYa+lkxlZB64tPTz/cbPw/GDEJlwk75WKD
X-Google-Smtp-Source: AMsMyM6nhQh8tbOj60wUf1MsePVebGhujSQooGD3pQxwbPkYxfG2f38xgPhxf4dbmAl/WGRIu34obA==
X-Received: by 2002:a05:6a00:4504:b0:56b:3ed4:1fac with SMTP id cw4-20020a056a00450400b0056b3ed41facmr30962908pfb.73.1666876431205;
        Thu, 27 Oct 2022 06:13:51 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a394b00b0020d45a155d9sm2643333pjf.35.2022.10.27.06.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 06:13:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <83dce097a9930b47788cc5c14a9f19b0f901146e.1666807018.git.asml.silence@gmail.com>
References: <83dce097a9930b47788cc5c14a9f19b0f901146e.1666807018.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing-next 1/1] tests: test both TCP ends in send zc tests
Message-Id: <166687643040.10215.9339821189847981396.b4-ty@kernel.dk>
Date:   Thu, 27 Oct 2022 07:13:50 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 27 Oct 2022 00:13:00 +0100, Pavel Begunkov wrote:
> Test sending data from both ends of a TCP connection to tests any
> modifications need for zc in the accept path.
> 
> 

Applied, thanks!

[1/1] tests: test both TCP ends in send zc tests
      commit: b6b86534b01e7b7b48039d7adbe8594df502e7cf

Best regards,
-- 
Jens Axboe


