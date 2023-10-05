Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2AC7BA1C1
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjJEO53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Oct 2023 10:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjJEOzu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Oct 2023 10:55:50 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D6399FD
        for <io-uring@vger.kernel.org>; Thu,  5 Oct 2023 07:38:47 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7a2874d2820so14398939f.1
        for <io-uring@vger.kernel.org>; Thu, 05 Oct 2023 07:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696516726; x=1697121526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJP3lm1VttFbEZr9Cf+Zd7Z1M70HnZTlakRI4hiHKSs=;
        b=lgFD/F6WmjJT6l9cT3FRKHSi2fhf8ntr/I8wbp+h1qBlIO1V5LuBaRaFsR3z7HxYHZ
         75oIekH0m2ym87bRKqWlTWeVD3XNUGrU4Tu8E4ARkONYAMGEAes+CheUYYGpLlabQcGr
         04coBrnM+Qn5b+qw/2sJ154liD8/8sntKyWyY+zzSP79G6NDF3tWrw2ZPvsQwsqGABZv
         nB50T8UlCEZmNaZQZrMrxhTh4AcnLW8sBrbGBehaaXpMAf531epSD4iqlCfKX/mrNV8i
         /YuQ1coE9B4scpG6O+SAiTTzZxQNMWPpJXw298gSgDHzd65yUDf7SRfx9GGE8YvVip2/
         qpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696516726; x=1697121526;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJP3lm1VttFbEZr9Cf+Zd7Z1M70HnZTlakRI4hiHKSs=;
        b=fdSHk/z+cSSDBqjzY1vxl4snVvapRbMC35LTJ58d9ACecaR1jOIVAAJLFlxWwXyofU
         4TWwfcUXoOSqTbbBV9ELy6jb+m29hUgKC3PUkhv63sIy6gtgmvTjuPWwnt1QHDJlxfjs
         JuWgGfkSzOr/RONkbKYH5sGE4eOddeK4JTdi+IFDsYNM7jKFIGcoX6nwq9Xw8E9wrlhu
         2m4TBBEIT6OdYSi+S0fC8tMpOy0ow34f/5Tm0ufvVWPDu7jW1MPvnbahgPWBFGnd8AAW
         0Psj04yohaWsI8sakPAY+zZySzPWrgCoKk8kV0VxB0uwHph2Z0aD/2tjhcRhUmokwiRi
         45Mg==
X-Gm-Message-State: AOJu0YzjdGTMWGCZqsHrTCH6ND147wPKB4/MmUcxEuvG2KDh7Gxw5eNi
        1TJJJHXoajBOden2gbMnEEl4Ig==
X-Google-Smtp-Source: AGHT+IEYLx0cXxDGuSK6pgYYniqxNFbuNtGBYXLVUxYiNLgQUFdz+BzBkWLNJPxCH7vIl7v3E2TpCA==
X-Received: by 2002:a92:d1d0:0:b0:351:54db:c1bc with SMTP id u16-20020a92d1d0000000b0035154dbc1bcmr5218027ilg.0.1696516726038;
        Thu, 05 Oct 2023 07:38:46 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t17-20020a92dc11000000b0034e1acce730sm447122iln.42.2023.10.05.07.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 07:38:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
In-Reply-To: <20231005000531.30800-1-krisman@suse.de>
References: <20231005000531.30800-1-krisman@suse.de>
Subject: Re: [PATCH 0/3] trivial fixes and a cleanup of provided buffers
Message-Id: <169651672501.27738.8320097803547315927.b4-ty@kernel.dk>
Date:   Thu, 05 Oct 2023 08:38:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 04 Oct 2023 20:05:28 -0400, Gabriel Krisman Bertazi wrote:
> Jens,
> 
> I'm resubmitting the slab conversion for provided buffers with the
> suggestions from Jeff (thanks!) for your consideration, and appended 2
> minor fixes related to kbuf in the patchset. Since the patchset grew
> from 1 to 3 patches, i pretended it is not a v2 and restart the
> counting from 1.
> 
> [...]

Applied, thanks!

[1/3] io_uring: Fix check of BID wrapping in provided buffers
      commit: ab69838e7c75b0edb699c1a8f42752b30333c46f
[2/3] io_uring: Allow the full buffer id space for provided buffers
      commit: f74c746e476b9dad51448b9a9421aae72b60e25f
[3/3] io_uring: Use slab for struct io_buffer objects
      commit: b3a4dbc89d4021b3f90ff6a13537111a004f9d07

Best regards,
-- 
Jens Axboe



