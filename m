Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B698066C43F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 16:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjAPPqz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 10:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjAPPqy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 10:46:54 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB55D10ABF
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 07:46:53 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 7-20020a17090a098700b002298931e366so1568184pjo.2
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 07:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdCr91u9ZF6NxENyEgmfuV4qeKXC0zkLkIiuDiFwvMA=;
        b=CLw2EBARceVQE8ZPndKaZIc8wHpOSOil47kqQ3+nlRvtpJfMU+S+s+H9UTIVntmzv3
         FiU9KaeJU6CpXcjutRk8oGg6wMy+CRDYH/w8y18ax/V1MCunBbgB6V/Ne+lKTzGMtyBW
         hq2q5NJTlzE1zXRrqYe96ThNoOsUHxKh/T6aiqmUwFFpX6iOFSvBZwJUDsEnsZDfSTi3
         2nW4LyziGtM3UAgGQdjiSGXH6t37N1qYmg3R00CUDNz+YWkwOu2QBkdTM8D72p7Hcddo
         FMmeqkC6tih6+eRMPACIlrxzlOw/I9Of1DxCChPMMGEbqmq1gpl7Q+7zEStnp50/OUoN
         aTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdCr91u9ZF6NxENyEgmfuV4qeKXC0zkLkIiuDiFwvMA=;
        b=UQfucqc6N9Lye7RMPfPsrRnvu8cT3+WyhyfEOFQmXrhluCzhst3rd0irneczzbgCW+
         tfVWvvYXnCqOggn79x14u8z7kW24iT63M+zo2iZIvWoIhM0dUHxjBIPQm+N1rRgxdjAp
         2mu+1Fwojy0vDkXj980ILW37ZD1R1GcsvZlVQgsCrVVTexb25MSjpDOyuYU1//zCjjdA
         bWBYJUkdZoTmLfvbVWEuqCIAvzUsLbSgNDvsRBdhPAoiQ1Ur8I6Xspo1EJjhsuPacaKI
         sLgKse+cmF+Hmp82irPCKeZTLkUbTHULQDYnDe4Ap2bK/IVAyqT8jvpj+7cqAnPmyadt
         ZB/A==
X-Gm-Message-State: AFqh2kr/Rjt0xWmzzpP5ZVaLBiY22HiTx+H7AAE4F6fSmMgqj+tZ3Mq2
        tWk4MIA8X2LIETxNBdxXxuHJMooHJAFyZl6s
X-Google-Smtp-Source: AMrXdXsfDjrRnh5hfJAFH/7X+2XjekB0OiSaJO3f/Etl2MSm7SOmLw+XKAyD472DpSroRpFEHhVBWQ==
X-Received: by 2002:a05:6a20:a6a2:b0:b6:7df3:4cb2 with SMTP id ba34-20020a056a20a6a200b000b67df34cb2mr5186402pzb.4.1673884013242;
        Mon, 16 Jan 2023 07:46:53 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d63-20020a17090a6f4500b00226dd47fc23sm5530987pjk.14.2023.01.16.07.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 07:46:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        "io-uring Mailing List" <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
In-Reply-To: <20230116142822.717320-1-ammar.faizi@intel.com>
References: <20230116142822.717320-1-ammar.faizi@intel.com>
Subject: Re: [RFC PATCH liburing v2 0/2] Explain about FFI support and how
 to build liburing
Message-Id: <167388401232.259503.13813373825130927323.b4-ty@kernel.dk>
Date:   Mon, 16 Jan 2023 08:46:52 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 16 Jan 2023 21:28:20 +0700, Ammar Faizi wrote:
> v
> v
> 
> 

Applied, thanks!

[1/2] README: Explain how to build liburing
      commit: 888e608937c2a052e01bc3730dc4ae9bcff4b3e2
[2/2] README: Explain about FFI support
      commit: 808b972006716090c18ee1305a23f2148ed97434

Best regards,
-- 
Jens Axboe



