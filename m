Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8415D480C29
	for <lists+io-uring@lfdr.de>; Tue, 28 Dec 2021 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhL1Rv0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Dec 2021 12:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhL1Rv0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Dec 2021 12:51:26 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA7EC061574
        for <io-uring@vger.kernel.org>; Tue, 28 Dec 2021 09:51:25 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c3so887906pls.5
        for <io-uring@vger.kernel.org>; Tue, 28 Dec 2021 09:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=jJqc6/ax/azda5i3PYCqhzRrteqijs4+HfXN1Wd6W2M=;
        b=tHV7a4+RKSIFhOQbayWkwxMs2h4tTQkfNxjh3AB+9uKakgk+EOI+1cDG4fxNpsOUMJ
         y8T4it//thSEp3not7CxfojwNOmSxPszPv1ViWa89tDUpWsVkiTtZm0xu+nQlD8DBXAV
         j6mg1YTu6Bq+8iocp45cAbG7tAw+egZ32oLpFDxv0MFYo4nf67cZ1ROX3Ujxz1hnDyrF
         +QOh48rwZ80yWzY44lpAO4ApVkk+iZCrg1d2MsnDYGN4eKN2k83WzICJXNnxU8qshydg
         sWZ/ZvHZqY+Hjub+w4JK43JZ7oCilzBlTZfOUoEqBDW9FuwZMETSfM4AMn0KzGHd0WaX
         6+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=jJqc6/ax/azda5i3PYCqhzRrteqijs4+HfXN1Wd6W2M=;
        b=hfS2AIVkC24RZlf635DnKt8ipmBw0VWCVwD9YOoaXFlg0FTnJhQ/PesJdUGG8IoOGB
         6QWRDiCq01KoOcO4H/DyE//puKqGIdZdb/aQkYluUS50rK/Xx/PR1i6ISFxo6SBHdEfh
         JFtHKnjsiDx2UWiKyxF2fZAAzBfBCGAJFrSgRN+vNjtciYVpms7+E1Htx9kXcaPNFRN1
         BJro+JoFoY8shBB5fzY0R6pytbNPL+pNABHWLMk2zuEg6JG0qYfeAKCQp5QehjCg9Tuc
         9448HQyuQlqRX5x3q6B8itH3JOL4HVjQZkC+POhv3qChj8ur9Y2a60IUgM2UkO0c0CW/
         UtfQ==
X-Gm-Message-State: AOAM53317fmMDPnKjYbBe8XDv5FsbJPf1nvEoit0M/6JuREbdQMzpZ4N
        k62PS7+MYwe7AWuP1uuu6kZdwbzcv18mcA==
X-Google-Smtp-Source: ABdhPJyOxJzJoW5m+KYVHvPDBEaNr3P1Kx5DDYvmcM0ECbJlo4iy81K+j0iV9JLvv79Tw1Pj4Zkm3Q==
X-Received: by 2002:a17:902:cec2:b0:148:b4c1:540b with SMTP id d2-20020a170902cec200b00148b4c1540bmr22566577plg.0.1640713884957;
        Tue, 28 Dec 2021 09:51:24 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h19sm21000816pfh.30.2021.12.28.09.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:51:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] reworking io_uring's poll and internal poll
Message-Id: <164071388359.36001.4643668571068744932.b4-ty@kernel.dk>
Date:   Tue, 28 Dec 2021 09:51:23 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 15 Dec 2021 22:08:43 +0000, Pavel Begunkov wrote:
> That's mostly a bug fixing set, some of the problems are listed in 5/7.
> The main part is 5/7, which is bulky but at this point it's hard (if
> possible) to do anything without breaking a dozen of things on the
> way, so I consider it necessary evil.
> It also addresses one of two problems brought up by Eric Biggers
> for aio, specifically poll rewait. There is no poll-free support yet.
> 
> [...]

Applied, thanks!

[1/7] io_uring: remove double poll on poll update
      commit: e840b4baf3cfb37e2ead4f649a45bb78178677ff
[2/7] io_uring: refactor poll update
      commit: 2bbb146d96f4b45e17d6aeede300796bc1a96d68
[3/7] io_uring: move common poll bits
      commit: 5641897a5e8fb8abeb07e89c71a788d3db3ec75e
[4/7] io_uring: kill poll linking optimisation
      commit: ab1dab960b8352cee082db0f8a54dc92a948bfd7
[5/7] io_uring: poll rework
      commit: aa43477b040251f451db0d844073ac00a8ab66ee
[6/7] io_uring: single shot poll removal optimisation
      commit: eb0089d629ba413ebf820733ad11b4b2bed45514
[7/7] io_uring: use completion batching for poll rem/upd
      commit: cc8e9ba71a8626bd322d1945a8fc0c8a52131a63

Best regards,
-- 
Jens Axboe


