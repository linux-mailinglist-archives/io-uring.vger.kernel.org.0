Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832874D25BA
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 02:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiCIBFJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 20:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiCIBEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 20:04:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FED13686D
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 16:42:30 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lj8-20020a17090b344800b001bfaa46bca3so600766pjb.2
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 16:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Ugb8LAMnhzApo9dcZqIaAqW3+Wj+xC7EdGKtorbqFQ4=;
        b=cPmZeweir2dZqsfWqdem3ao0HzrSQFQ2BnlJByXXgVp4Pym/TAuYHLP+mdEtMviivT
         hKOYQ8QjFXzk+Xpag5DquB6EjXeqNSwmG4cDivsl4kfRAXUwY8rQS+SrID0G2T6mnuW/
         A+o0UDs0ppF03AAIlzCu/Uqs3I69LSKdUsGKHS/aWGdYosRfmvNdhcDdhJCMbfv/bHOh
         8E/0kcg2ptQfU8Eb4fTlO4G6GmRyuXL6P055ZB2WwSWyHOUhODSQNelofFjd2ipAdJ0p
         x0GHoqvSzkw53/ulDmftS/7voGyWPl3iVjWAkwDD99YD32sCmUWLAV4nDWkUuTRxgFAl
         HPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Ugb8LAMnhzApo9dcZqIaAqW3+Wj+xC7EdGKtorbqFQ4=;
        b=kO3UK7A2VyqgH403LXaymeYvOF01wOvbHYS3xGj2c9G5FOGU8WWWlpQmE1H0pOekUL
         b3aOFKA//6XUrqEWKw7fBNjXrOTm9/33QzA8PWF87O+65QmzGUTcF8n9OTGb0S+RK7lb
         e7/8W+NGUfxvc9+jF7FhUhCy+1h2Qd1Qfz9tG0YXdKHAOeHt+jnZzgSbTXElLyk27Qtl
         zkQ+4jxvLDeDKjFDiyF7RQ+paPyDXTFK0aaUOl/ETNba8Q/G/BOmirgIUA67IMzU+G34
         nG++ww9OkTRPtZ6FrYLGqby0LOEyoDMjUb48PcQ9omPxiDlQPpGRuzl/RA2I+d2r5RuQ
         p/Vw==
X-Gm-Message-State: AOAM53191fjjbsQGvvPv57N1AXKWlE8Q87W86Si14kz0k24+eAORLNwS
        QU5NjhHCQJ04J0ZvQNZOpXKX7A==
X-Google-Smtp-Source: ABdhPJycE2IQ/Orf1ePMAF7JGIcjI5Z9JI5pO05mzHNTK5TJbtjhf8yQQaBeQ9Xco/sfTyw2Gudigw==
X-Received: by 2002:a17:90a:4286:b0:1b8:8ba1:730c with SMTP id p6-20020a17090a428600b001b88ba1730cmr7532393pjg.181.1646786550239;
        Tue, 08 Mar 2022 16:42:30 -0800 (PST)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id il13-20020a17090b164d00b001bf87e5018bsm4213475pjb.37.2022.03.08.16.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 16:42:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        asml.silence@gmail.com, Abaci Robot <abaci@linux.alibaba.com>
In-Reply-To: <20220308075717.37734-1-jiapeng.chong@linux.alibaba.com>
References: <20220308075717.37734-1-jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: Fix an unsigned subtraction which can never be negative.
Message-Id: <164678654933.397558.14576742053949962623.b4-ty@kernel.dk>
Date:   Tue, 08 Mar 2022 17:42:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 8 Mar 2022 15:57:17 +0800, Jiapeng Chong wrote:
> Eliminate the follow smatch warnings:
> 
> fs/io_uring.c:10358 __do_sys_io_uring_enter() warn: unsigned 'fd' is
> never less than zero.
> 
> 

Applied, thanks!

[1/1] io_uring: Fix an unsigned subtraction which can never be negative.
      commit: 90e80add901b03fe6f3bc5ca6481414ee9f039ab

Best regards,
-- 
Jens Axboe


