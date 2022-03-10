Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA94D4691
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 13:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbiCJMP3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 07:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241904AbiCJMP2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 07:15:28 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69671B0A4E
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 04:14:27 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t2so2249413pfj.10
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 04:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=CqVym7XIcK1AJ3m9pfgIjuZSQTCwGmjXctkSV8Ya9xg=;
        b=sIVgxQC5kK6aMzXR80tgjOZ/lMN+JhiMGij0Mhbq6Ygg86rC1OZvALTQ45KtVdJhs5
         CUBaurub65xfmXstphZ4tYdRjp0dyXZSBCggmEGAgAn8ZpLM9pHp48XZgMqxG80FgQFU
         yjTgXbqlumDyWWn/B76UyOltUpZ4qqmaKhuPB/dn21p1c23+Eo29BcNanoZlQ8NNj6m+
         Tdg4wZa6mefn+RMPDKIb409wfCtp9pkwVyiY5wkw4GTYyw5qd8oCuhhcx45oP+gwveWl
         tAzq9Sm/k4wwqSsjk1Qt4FFwIv1kv1KM8rgBPOYzTdyJFK/cFHOkp8IsM/4gkgEIVZua
         oanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=CqVym7XIcK1AJ3m9pfgIjuZSQTCwGmjXctkSV8Ya9xg=;
        b=xaz65Lsn+4FR1fmyfSfXY5B1l7WuLvF1R/f2rjEmLSR+CW0agi2Trx5envMGwyprBE
         +J+QQ5By4MS6FfdMb06V+zMcfGfPU4qZAvHfGuVAVCxPEDw+SXYN6kV3qfSs1g0O8QIK
         HenoUOeAAx79px+AIyBauZbgxTgl6ydZHVUonfp8Fs4zikxbvB9vw5L+gJFK/a+oTZ5G
         9zNP0G/IagJt1CtE2n5XQuBafp65LhgDxfYGa7f5c+fhcPQPrPrvXw1qzU8+BekAAUVL
         hi+OCyFtu9ubl5K7p4gOMxW6DVYCEAW4AS53+DlA++Cmet2/wmgtu+d4HI6cGdj0sOyw
         xh9g==
X-Gm-Message-State: AOAM5308eKJSa3GsgrGOLG4dL9kSMLtS9X6asR82vP/pBDuzogkpgzC1
        66TcwGNcj1QNY5lQB7ofQJABAFu+ur4CCp/J
X-Google-Smtp-Source: ABdhPJz8bjCKKnesHGE7iq2yJPoVz6awsgM1V0iqzJFXjnOMsuSei+SQDp3D/gFT8gOyrogw3g954A==
X-Received: by 2002:a63:4d63:0:b0:380:fd6b:5893 with SMTP id n35-20020a634d63000000b00380fd6b5893mr32061pgl.233.1646914466537;
        Thu, 10 Mar 2022 04:14:26 -0800 (PST)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm6925204pfi.158.2022.03.10.04.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 04:14:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        gwml <gwml@vger.gnuweeb.org>
In-Reply-To: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
References: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH liburing v3 0/4] Changes for Makefile
Message-Id: <164691446560.8573.18148443232651092454.b4-ty@kernel.dk>
Date:   Thu, 10 Mar 2022 05:14:25 -0700
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

On Thu, 10 Mar 2022 11:12:27 +0000, Alviro Iskandar Setiawan wrote:
> This patchset (v3) changes Makefile. 4 patches here:
> 
> 1. Remove -fomit-frame-pointer flag, because it's already covered
>    by the -O2 optimization flag.
> 
> 2. When the header files are modified, the compiled objects are
>    not going to be recompiled because the header files are not
>    marked as a dependency for the objects.
> 
> [...]

Applied, thanks!

[1/4] src/Makefile: Remove `-fomit-frame-pointer` from default build
      commit: de214792d38700ba470a560cf3729a9bd62acb35
[2/4] src/Makefile: Add header files as dependency
      commit: 9ea9df11bbdbbf3bceae38679dd175b092950142
[3/4] test/Makefile: Add liburing.a as a dependency
      commit: b48d6af787c00fd4a8f3614f8c1a0443a3054eef
[4/4] examples/Makefile: Add liburing.a as a dependency
      commit: 115cca320dd4df9293440d8e410bebb064822265

Best regards,
-- 
Jens Axboe


