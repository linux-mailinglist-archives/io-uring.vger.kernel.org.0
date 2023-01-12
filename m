Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5D667DD8
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbjALSUe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 13:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240497AbjALSST (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:18:19 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF1CD98
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:49:46 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q190so9375776iod.10
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lX65Kc7nPBXbKkjC+fwCboVLbKB6Sj5cvcRLzBYpuH8=;
        b=zjXR+czZhQA6mN23SRRhdexwgum0awej5ztuUJiGA5aPYiAuxIHFtH9TYVl8hBT40d
         uBsDyhJLi0BcfTxlZrk6Q2MzUW/iTnbg+JohjC6LOvpa/euVj1i+TawUPbPTW4VqMcmj
         IkjFrD7EB6drCGUkKVO75zihiEFPOz497TuvDH3g2Z8GoS8ugNgUj43YPcUcM9l1SJ88
         Kg7ewxWinPXqrTMahDkkxCw7P+5/n43YYYhzJ9lu8mZvYVAfsa6ryfXHgxbRJMcdJXTI
         wL9ku14WherXIxbuLVM49sZbPOtF1LLjvmrTOKgM48fXoH2jy21sc3t/Sj4+M6bjO6ut
         cHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lX65Kc7nPBXbKkjC+fwCboVLbKB6Sj5cvcRLzBYpuH8=;
        b=T0fJOwiRJ+r4CeWs+wlOQ2HMFUUmJ2bVfjNA8A9/Wq9eKoxfhonkvgokCbQdxsmwIO
         ZckIPY9Jq8N3X9zMntWJ0N51u7ngtdCbJ4mGFgYo+TiMJp1x+i5K+pqjUnhrziAG/vTG
         NX9xMYkHb4BWfH3FjZMnikDOX8PraGdeqbap1sCX3wdEKABu+MX4y+RkFdVyCjWCPQqI
         Sa4c6f846ahV24+aHKJTD0+GGhNkJi2wVfZsnu5nNvtRGtzKGJVMHa6VmuXd+F7Ywmf2
         7q9WVXdkWWv1xOR0mPUFpj/F2qjie15Y6ybZd8ti9sDbEJt01PsCDxdVaj7ZwHW5eIUd
         MSbA==
X-Gm-Message-State: AFqh2kqQTnlT2FLZ+NWGUg+F/pxUDH4Zf2V/ujyJQhIQeS+78GMdgY8H
        5vmw37qMVsayvU9EEpxcNl87TQ==
X-Google-Smtp-Source: AMrXdXvfJPdLEtfNFkqs3kJLgiXfwKPgDLqr+vUzgKVDpr7E0hVILPhNql9TZ0A9d7sdAlUC3iKdfg==
X-Received: by 2002:a05:6602:1cf:b0:6ed:95f:92e7 with SMTP id w15-20020a05660201cf00b006ed095f92e7mr9115315iot.0.1673545785360;
        Thu, 12 Jan 2023 09:49:45 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d2-20020a0566022be200b006e00ddb4517sm6280650ioy.48.2023.01.12.09.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 09:49:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        "io-uring Mailing List" <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
In-Reply-To: <20230112155709.303615-1-ammar.faizi@intel.com>
References: <20230112155709.303615-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1 0/4] liburing updates for 2.4
Message-Id: <167354578448.497205.2301808870925643742.b4-ty@kernel.dk>
Date:   Thu, 12 Jan 2023 10:49:44 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 12 Jan 2023 22:57:05 +0700, Ammar Faizi wrote:
> I have found two people confused about the io_uring_prep_splice()
> function, especially on the offset part. The current manpage for
> io_uring_prep_splice() doesn't tell about the rules of the offset
> arguments.
> 
> Despite these rules are already noted in "man 2 io_uring_enter",
> people who want to know about this prep function will prefer to read
> "man 3 io_uring_prep_splice". Let's explain it there.
> 
> [...]

Applied, thanks!

[1/4] liburing-ffi.map: Add io_uring_prep_msg_ring_cqe_flags() function
      commit: 390b4f6a1314f8b1c51ced51c70b8646a51ad081
[2/4] CHANGELOG: Note about --nolibc configure option deprecation
      commit: 68c2a983819edae4e724b49b2e644767684eb103
[3/4] liburing.h: 's/is adjust/is adjusted/' and fix indentation
      commit: f63a594cbc58bb0f680e7d424f2d8f836142aa35
[4/4] man/io_uring_prep_splice.3: Explain more about io_uring_prep_splice()
      commit: 55bbe5b71c7d39c9ea44e5abb886846010c67baa

Best regards,
-- 
Jens Axboe



