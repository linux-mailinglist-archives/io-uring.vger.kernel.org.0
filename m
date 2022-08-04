Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8ED589DEB
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiHDOxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiHDOx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:53:29 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5A02A253
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:53:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o3so90379ple.5
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=XexfetNkGwYFytWR/H5txjzaFFaWAcgx8jwhrV6bHCA=;
        b=h1wDUi576Hs4Ry8zzn8t2dC7Xzas2Y5c+wYOxryC9wFlG8iD9d/0QTt0Ga4mLtbdv/
         XrOI+AvfStKfRmw+pAxI9LXmdWX1sM4c5haQPQdHcMU0Z6vl3tVQcWEBzrwpLzvv9ZQv
         4Owq6XLRMAR37gY72MBvmaykASaDM09yok1YArUq6JUjPlGnH2nMCqUoYOmDhm9POkkq
         4A4UdIrb+5r6Tucc6cKIQebPn0ZDI27KH1j45lRMgVQ9oWg/evg4QCrywET7tA7LLeyK
         sXq/EVUe61Nsud2T4gMhC3EI2qLP+EBx4oW3RkJ5dU1PDqKq4vGfS39UBaEK/T6Q6oJt
         uysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=XexfetNkGwYFytWR/H5txjzaFFaWAcgx8jwhrV6bHCA=;
        b=NakqbKtVmWznOipFVjiM61FpZES+TDEPKuliH7ukUzBOOKs9nI6dk2YI+drZW7M6QG
         sFT2irJeSqCch4Upn+KbiV4OhUtZuzprey/1J9RIx8CaJcseZaPd4dD9UB3xnbxiWjDG
         d8cZN+4wQUivULLFHnzaWzsbtfLayfxOy9AtGwus7+V85w6/VoOAAvD8jn/KyBpw/fz4
         W7GuVFpVAeXwUVapCwIdeAFPTbAxyuHevqxqORyIQprupm3gSQhcGeSAN0IehJ1hWPcb
         SomX9ap2zbKWcN2bzlvZvxtbg7vdEZeIfVaoHNpy54Sg5dlsF59zMvEaKrscWZ0DxwPN
         X/3A==
X-Gm-Message-State: ACgBeo2HEeKKsmeNUoQcIlbTcMhvmfxjHWV8x1zb7hYQba109OZqr2Hb
        y9CwZ7Kk3FDeRtVZoKJ5m3gIA7RG0WYabg==
X-Google-Smtp-Source: AA6agR6gXffIuI0a+YhPuVeguTiwrzuh8Q6BnlUrFq2ZsqvK3UqnRUH+/FQfj64V5Sg/qisF8a2oTA==
X-Received: by 2002:a17:903:41d1:b0:16f:14c5:2d38 with SMTP id u17-20020a17090341d100b0016f14c52d38mr2278157ple.161.1659624808142;
        Thu, 04 Aug 2022 07:53:28 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id nm8-20020a17090b19c800b001f2fa09786asm1260807pjb.19.2022.08.04.07.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:53:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com>
References: <d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: mem-account pbuf buckets
Message-Id: <165962480726.936420.7595414256102122695.b4-ty@kernel.dk>
Date:   Thu, 04 Aug 2022 08:53:27 -0600
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

On Thu, 4 Aug 2022 15:13:46 +0100, Pavel Begunkov wrote:
> Potentially, someone may create as many pbuf bucket as there are indexes
> in an xarray without any other restrictions bounding our memory usage,
> put memory needed for the buckets under memory accounting.
> 
> 

Applied, thanks!

[1/1] io_uring: mem-account pbuf buckets
      commit: cc18cc5e82033d406f54144ad6f8092206004684

Best regards,
-- 
Jens Axboe


