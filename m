Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8C86215A1
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 15:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiKHONr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 09:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbiKHONq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 09:13:46 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE9213F2F
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 06:13:45 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q9so13913527pfg.5
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 06:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrTEk6LDLCIYS7emXZW0HctyZXKHLz66hfnEY7yyW0A=;
        b=uWv3rMzR4lvsgn9j3Lha5krn20PitjAxwCUAgSStWoE7C1mVn5sWhSof+44G1ugLkP
         pALdxF31nfHiBjBJmY0xkko0mQvVVcjRgjC/8r2qKlziPex0vwR1RPzC6KHWCUVTGfWK
         uGBAcbT1mSkHIleVQ4IVdmURsVKRftGHqdHwgB7xKNnlNNDayLhTON1b/pFu99rm5oC5
         SgN6X5WJmW2L+mZygRZL4vCFXy2PBczzo/NKTT/oZnQpiVcMKk0CTY/IVtQSKJIOJzzU
         YUXxwOceXgfYKsguOLoH+nSU0Ushi9b7F0u/tlAGaWwKi27BSLWnv2ql9TA3ogJZfgR1
         strw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SrTEk6LDLCIYS7emXZW0HctyZXKHLz66hfnEY7yyW0A=;
        b=K2MeyUOLnQlyh+kwhZ6LrDAPyz++MbCSiJsSEuW/RbAQtX7DkDPas47y4xSumDUkQY
         ZdvTUUfrpvEx7i4mMOoZ3vkxKFdDC28z+mQutkmtZLcGvsIQKaSXoazfZkDasKNyoB/a
         WFccEJ+8TRBIRX7JN2EdT6veCUZzeX2bSMg/4sG6mt8wr+C09eaGZIMgCMk8HU9+a0mE
         cGDwAVSXJuK6KDtBXjStb/e5yk0U/KZqfu1IWssS4buVtGSwyPJXDZMzAwcIiW1E6A4U
         2zZPaHhOhYgs8HOTwT5xZq6RNQjGR44h++HilumYiYWkv8Nk7Pq0Uu70tFUasTmMlEXM
         cVrQ==
X-Gm-Message-State: ACrzQf0i+TmxVrTOKAZYQ5rcnwBn6ykBaSa/TfF7Irk5KP/D/QfwTRTg
        cKkl4LKFF06EoDQj0pYMW8MBT9jfnSHa+YDs
X-Google-Smtp-Source: AMsMyM6TK1K/9Be/J8su+ph0A/YsC50WWWcGeWNBD/YWbnvADY72hJMxFa/HSd3YfiWGTqVomJl5Kg==
X-Received: by 2002:a63:8ac2:0:b0:46f:b278:183b with SMTP id y185-20020a638ac2000000b0046fb278183bmr41464813pgd.6.1667916824982;
        Tue, 08 Nov 2022 06:13:44 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s13-20020a170902b18d00b00186da904da0sm7009630plr.154.2022.11.08.06.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:13:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20221108124207.751615-1-dylany@meta.com>
References: <20221108124207.751615-1-dylany@meta.com>
Subject: Re: [PATCH liburing v4] test that unregister_files processes task work
Message-Id: <166791682383.41236.13099308010589502791.b4-ty@kernel.dk>
Date:   Tue, 08 Nov 2022 07:13:43 -0700
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

On Tue, 8 Nov 2022 04:42:07 -0800, Dylan Yudaken wrote:
> Ensure that unregister_files processes task work from defer_taskrun even
> when not explicitly flushed.
> 
> 

Applied, thanks!

[1/1] test that unregister_files processes task work
      commit: 78463f30a5f3235c8cce82cbf1b8ff437f6536cd

Best regards,
-- 
Jens Axboe


