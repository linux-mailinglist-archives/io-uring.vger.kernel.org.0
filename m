Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9F44C4FAB
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 21:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiBYUaX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 15:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiBYUaX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 15:30:23 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370161F0834
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 12:29:50 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id c1so5595754pgk.11
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 12:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=JWof5HDZQ3ektlA40EL7NC/KrYyJpusnkbk206rsoqA=;
        b=sitC+4lcfen4ZvSnKe5xfaFJdbELVAwZF+eBN1HRBy+qvChpAHL0mAf0B0QBoBZ5uL
         NRFOaQW5sU+I11gFo8hIPCKJkYHiv/LkXhNBQac7kyrVsFJEoRLDrpC4CGZvQQQt1mS8
         lW+A5IULXAU3fIT/qoZeugKYlWjaLYuI+tD2YLawrg4mwSttzPWNPxMCEk4zdobaj7ra
         b2wVKQHONJ3Z2pUqhTPClfoLn77vXJj9ZJl9OeUq63fodqDWQpNDdobAUeq/Gat2VcNF
         z+FlRMnIlrzb5Q6rHVgYOqD6yRr6c5o0ZloJl4K+Y0yX3uEkpzKI3gDxcudkTjaROiPV
         H3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=JWof5HDZQ3ektlA40EL7NC/KrYyJpusnkbk206rsoqA=;
        b=fl7I3zhsKU+UMqi84ZCg5udLvBSJT5GJoqcGT/yN5XouVYuhJJl/zeYcQvfuxPTWxS
         G2rT/n36N0XZAXQBs/6NYAMWaeVjmgjskj1G6Ju1vda0zCoH5jsjSVcVrKZ7C96Cs3ov
         ukfUxjd4ia+rxIHMeTYm5D+XJxmu+qdfQQtYB6NgQdHRmmXkI6mDwNEx6CeCExi5bDIZ
         oQ70q8NgeV8BG+NakS9a7NNeOi23wLYgnSsC4jk8XMWcJTo6Ny2dF4sVcf2wPio7PoCk
         DlnQamwl+XoNzTVNI266XTxI04nhSDTCM1DhFo4o0fbJVqM1ockO5vDP4d4uRCatUpyx
         wpFw==
X-Gm-Message-State: AOAM532hE9I3eq8RxelFpngOlcww32yQI6e/VwzVBePuur+CR+qexCUf
        7Cs20/096OyCsiDuIudnRW3flw==
X-Google-Smtp-Source: ABdhPJyzLRTNEi0SSNAZALnPgL6FGkZG5uYsDxJBByOoi3HE6vBemBNShffs/CEyi55RVzXCewn3nA==
X-Received: by 2002:a05:6a00:23d4:b0:4c9:f1b6:8e97 with SMTP id g20-20020a056a0023d400b004c9f1b68e97mr9191745pfc.27.1645820989591;
        Fri, 25 Feb 2022 12:29:49 -0800 (PST)
Received: from [127.0.1.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm4006817pfl.135.2022.02.25.12.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 12:29:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Nugra <richiisei@gmail.com>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20220224222427.66206-1-ammarfaizi2@gnuweeb.org>
References: <20220224222427.66206-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1] src/Makefile: Don't use stack protector for all builds by default
Message-Id: <164582098870.3745.10379266162970939889.b4-ty@kernel.dk>
Date:   Fri, 25 Feb 2022 13:29:48 -0700
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

On Fri, 25 Feb 2022 05:24:27 +0700, Ammar Faizi wrote:
> Stack protector adds extra mov, extra stack allocation and extra branch
> to save and validate the stack canary. While this feature could be
> useful to detect stack corruption in some scenarios, it is not really
> needed for liburing which is simple enough to review.
> 
> Good code shouldn't corrupt the stack. We don't need this extra
> checking at the moment. Just for comparison, let's take a hot function
> __io_uring_get_cqe.
> 
> [...]

Applied, thanks!

[1/1] src/Makefile: Don't use stack protector for all builds by default
      (no commit info)

Best regards,
-- 
Jens Axboe


