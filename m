Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C6E514DB2
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359740AbiD2Oob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 10:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378078AbiD2OoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 10:44:24 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B65949F2B
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 07:40:08 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id i8so4106043ila.5
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 07:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=c7/rTrXWfT9qI0T+ZC8VZTvuLtN6jGScG/El1dcOs4U=;
        b=2+DUz1PUat7L5aT5Nt0Xr1HZYzE3RRY47+qmLTM5XNp+B2R2nHGUF1oLgstwwAV5Hf
         LzVCmcfiBjYQ0dzuNwhhHhqoxCon2Izie2AKkXkVtl0dAwOmeqVW0sJ4fPBeU5kWdRka
         usEncyFBET/crDoiU0zG8ZlbImSz9oP2zaOwmcuTztwA1lCgDGAXe37lF5bz4nf49ueL
         Fm/Wfl6WGJZXwOkjrYqKZuvSX8rkd5OkRLAKeEYSz+eo0NHc8WqpeGmHsWVYaX5AfjIA
         SOHXsP0JUd+c8dbEoxX6umeejbBxUbnTDxvigpW9rGmoi4atUJf8t3ktzbGs0cCDHscW
         +JJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=c7/rTrXWfT9qI0T+ZC8VZTvuLtN6jGScG/El1dcOs4U=;
        b=h4ZQaOo3V3Ts+LwCzmn1ZkfiMYr2lQY9RXfd3k4/OYBSrIhBi1eFK8mHeJ14ZJE1h8
         ILT8HoNrbNPc8pL+pWRnx+XdM9CmEja5h+QLXAEoi7VCP7UQBmmpC/tVXcYw/YJkgv3Y
         RVEQ399a2gPfojJU723hGo++0UPqnX45dkrsrR9quuiLPlm7lB+t5JTkSupJcjXRnDdR
         Wnf17DkU430OlPeO6AsbJ631rjBxFDXzTmLHWn2t4+YV3jXmhaS4xOly+694x8wfLR7j
         rrRdsTjGQHg1GpGsE+3KyazZ9quHDdPYD6jfE12jU/foMyLmVQJvDCRwcV/6+gICinHC
         9qdw==
X-Gm-Message-State: AOAM532l9I6smcGvJRh3x1J1iH0sk6JEExjYPwCG6LtXvjCyiFShtRUe
        iHl52p8BMP7FLyBuL9yZGfCKeNV866EjPQ==
X-Google-Smtp-Source: ABdhPJz8KUTHUGi/Jbg3iuSMPI5uAMcIELrjGnIOHfrHWTAJ3wUhOfXNQwmGDCtFKsrZsDTlmR4ZlQ==
X-Received: by 2002:a05:6e02:b2b:b0:2cd:a289:15f9 with SMTP id e11-20020a056e020b2b00b002cda28915f9mr10058227ilu.36.1651243207272;
        Fri, 29 Apr 2022 07:40:07 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t13-20020a02ccad000000b0032b3a7817afsm617994jap.115.2022.04.29.07.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 07:40:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     esyr@redhat.com, asml.silence@gmail.com
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
In-Reply-To: <20220429142218.GA28696@asgard.redhat.com>
References: <20220429142218.GA28696@asgard.redhat.com>
Subject: Re: [PATCH] io_uring: check that data field is 0 in ringfd unregister
Message-Id: <165124320648.74951.15737346713763033828.b4-ty@kernel.dk>
Date:   Fri, 29 Apr 2022 08:40:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 29 Apr 2022 16:22:18 +0200, Eugene Syromiatnikov wrote:
> Only allow data field to be 0 in struct io_uring_rsrc_update user
> arguments to allow for future possible usage.
> 
> 

Applied, thanks!

[1/1] io_uring: check that data field is 0 in ringfd unregister
      commit: 303cc749c8659d5f1ccf97973591313ec0bdacd3

Best regards,
-- 
Jens Axboe


