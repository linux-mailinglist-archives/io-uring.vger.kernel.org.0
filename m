Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2026AB10F
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 15:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCEOfe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 09:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjCEOfd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 09:35:33 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B98E052
        for <io-uring@vger.kernel.org>; Sun,  5 Mar 2023 06:35:32 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h8so7472900plf.10
        for <io-uring@vger.kernel.org>; Sun, 05 Mar 2023 06:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678026932;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2vIqCYAxR2zQq0YziMj32J5h9YavIWU44m24rPPARlE=;
        b=C+/zDuxhJI5sq4aG0gV71SZbrLsmEwLu44vPYC3FjX5d2/vyrVdVuATCF0gYxpmUtk
         1zLA4L6W66XKcrqUri9kKX4mQKzzSx5h6mb0YE3F9OQI8dbu+9CrLRXmcNQVF3F2j+zf
         5LX1IFfPs0GAW6UXsIRQs1AnTaIem0GEuVvSAgmknoqRHkGRaJeoxmyZGKqESwZELo1n
         ZfsSRijz3BxbvVgGVbX61z+vQxE6FDruBpdfIiRXdXjDy4GbLFS2Kx20i/xVI98RdOoA
         h4HJqbEcy13l1snNBkOYJAw0HEu7Yl/ewa1V5qotZ8K21oyvqvi+hr4ZzlV7WOzp9PVO
         J8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678026932;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vIqCYAxR2zQq0YziMj32J5h9YavIWU44m24rPPARlE=;
        b=HOTWmgbOPHA4WOtyNe/CtzhszV97H643ZZ3uwt2mjz9c/S/G400PZEzMb/DOyadscN
         2xo4HveoGREBq+9p5yP1H+xYIYF9reP0fBliu7EDm/n2iyhaxflXU1qLDScgE8nVlTDJ
         7qJUGewZqMabMhfqBRsIxvxMHqTukYouOH5146cgeoKugxEEaDuaY5juGH9EZ+xaDYHJ
         7cg89Dq21IWP0dyfLvHvJ7kFzBscajNL01IC9ATwAd2nKTss8cSjnrjDuNA8m8LeQeCE
         ep67jIEuzAfwTlikOO1zxCmcLJpKWrHVXJHQoJvu36gn/MJptlvRY47FEAYUxfnak+kr
         IgeQ==
X-Gm-Message-State: AO0yUKXwkoxDrUBSqywdTv9QnkZ9jkg3RZIC+Zxzy05ApJXU5UB+nr1t
        k5Nx+UF40EfdtCBucEsRFL6sz0wsGUPlF2V7ZU4=
X-Google-Smtp-Source: AK7set8HqlJIJgWmRug2h81tCJ1nJBCIBUcrxgLAOA50H78ynKS0cjt7XynwY9/Vkwkjh2ARYT+fvw==
X-Received: by 2002:a17:902:d4c2:b0:19a:9269:7d1 with SMTP id o2-20020a170902d4c200b0019a926907d1mr10055140plg.4.1678026932078;
        Sun, 05 Mar 2023 06:35:32 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id kf15-20020a17090305cf00b00196251ca124sm4862683plb.75.2023.03.05.06.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 06:35:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1677993039.git.asml.silence@gmail.com>
References: <cover.1677993039.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/5] sendzc test improvements
Message-Id: <167802693150.46805.10327189149215717857.b4-ty@kernel.dk>
Date:   Sun, 05 Mar 2023 07:35:31 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ebd05
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sun, 05 Mar 2023 05:13:03 +0000, Pavel Begunkov wrote:
> Add affinity, multithreading and the server, and also fix TPC
> performance issues
> 
> v2: rebase
>     add defer support (patch 1/5)
>     fix rx tcp problems (patch 5/5)
> 
> [...]

Applied, thanks!

[1/5] examples/send-zc: add defer taskrun support
      commit: 209fb0e9b6a8f813276262790066c162e13975ac
[2/5] examples/send-zc: add affinity / CPU pinning
      commit: bacbc4ca724c12d303395fb55a03e8d7a40c036b
[3/5] examples/send-zc: add multithreading
      commit: d0e68bc1132c52867649889570e86ae620604833
[4/5] examples/send-zc: add the receive part
      commit: f1af5ff51a3320a8971c611368c693c1dec560c5
[5/5] examples/send-zc: kill sock bufs configuration
      commit: 38d357b73791a31912c3ef13b42b74e568e71dbb

Best regards,
-- 
Jens Axboe



