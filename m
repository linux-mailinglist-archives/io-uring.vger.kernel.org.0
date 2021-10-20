Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E5434CF5
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 16:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhJTODZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 10:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhJTODZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 10:03:25 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BAAC06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 07:01:10 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id s9so7404116oiw.6
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dTiNufPUX2oUekxtoOXkO/zQWK0CqOx21i9yj+y9Rdw=;
        b=Vusg6/A6VAT59Ox8GRfcUB5ULyFufZ/ird7XI7rzvauEMv+nDhY8AzGnD7nq29kdvM
         wCGMqv9ycx++o2cgS+tn771a6hT9TP1v+mHplsnpwsq3X4U78d5B4R8Wc04rETmsdtHT
         E2Xg5dyk8T5BaDh6xX2OwP2VyNj9U1iTYu6LeC5cBe2IOGoyujlJltu8gdOUapv6kzet
         jR0952k+8VrndOg/oHS6b8YN8Qa6PnEykqLU7l0eSvZlgk4vPjkAyOh/fqjQgmIKbIm/
         scFEvtDgT3eWkVwKQZIMCVc5Tx4SYjkQNwlzpPYz37dWEDA0ubyAlMqqZcPMx65fEvXP
         DDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTiNufPUX2oUekxtoOXkO/zQWK0CqOx21i9yj+y9Rdw=;
        b=IzK4cAzQ0mHziUTc7TH3SxvfLdqZbsBsPtHp2mrBqa7FgzcDTWzl9eDcFgIdpVn7ao
         D++tICRpFv5NO0HIjBgVUND7wUqrWgJkij8qn/wdFl3LP7Q9FGwZFCiHRqO2WkXEWNsd
         /uqMi4a2ivypNDPIBzAlYnsun6YeGPjTXBn9S6o9Pjf7NbMLWCHpU7JO9V3ncMRqCeUF
         EelTBlFUzdH2AIoaxg0glcYuu8OyWPYijjUGAB0cFJrIzHUZvC88twSXz+YKFAle9PX0
         gb6NoOMDBr0/DSYCgbUNKnFsBhskGnVoI4nTcNaqFaClDR4uD2JasrYgaXUGSW59K4sU
         68hQ==
X-Gm-Message-State: AOAM531gMA2UFwOd9J9PjiUQPPU+YbHQp/+xDFtI5OEsGhVBGuxugTyF
        LySaVfqMIoPik3q1TBPGaFlcePoMc5g7mg==
X-Google-Smtp-Source: ABdhPJz3p7HpRTfqE119GiLhnzcaCyLT3kWwZ8eUiASVLIWEqGXWenjq8soFsJaIZfWOrtSBaq4XPQ==
X-Received: by 2002:a05:6808:d46:: with SMTP id w6mr6497336oik.62.1634738468759;
        Wed, 20 Oct 2021 07:01:08 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i15sm471371otu.67.2021.10.20.07.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 07:01:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Beld Zhang <beldzhang@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring: fix ltimeout unprep
Date:   Wed, 20 Oct 2021 08:01:04 -0600
Message-Id: <163473846179.730482.6681458910857538254.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <51b8e2bfc4bea8ee625cf2ba62b2a350cc9be031.1634719585.git.asml.silence@gmail.com>
References: <51b8e2bfc4bea8ee625cf2ba62b2a350cc9be031.1634719585.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 20 Oct 2021 09:53:02 +0100, Pavel Begunkov wrote:
> io_unprep_linked_timeout() is broken, first it needs to return back
> REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
> now we refcounted it, and linked timeouts may get not executed at all,
> leaking a request.
> 
> Just kill the unprep optimisation.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix ltimeout unprep
      commit: 195f98fe9a0ec47358f32ef297e9874b0238809d

Best regards,
-- 
Jens Axboe


