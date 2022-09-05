Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3216D5AD886
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 19:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiIERmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 13:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiIERmK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 13:42:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032F04F694
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 10:42:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso12785872pjk.0
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=xT+7sfe77Fl8JAwIztYE5MLBSfPPJy65f2pLRw8/Nsw=;
        b=Mg3UzUGOTQginV7NBRHGfhQRyneVoQkJYGkIUpohEVQHjYrPaGOKtsUeZJBEoS0ZLm
         /lsrImfruDhD1GBpu98JlsJmAQzyjvpOtVlfTddiZj35fmm/GL9rf4YBhN0MRdzCB0uL
         O7cW5zY//NjxdnKxZy/sOr67yKQyJfGTnS4x+gyXAZhrD1tOV16Ts4H5Q8/oAng/9BzI
         6p9YmhID5xH/IcLXNm/tNvHBxgHSrjICMgo6PsT9gFzOhzCl1yFuZpyH6j3PaJun72Xt
         TBtyy4f48+onMOW1/J588p6Yfq6t62DmNH6IJ15PdNT09YgYpVVUY9xYkwWhwrK5lDZZ
         P6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xT+7sfe77Fl8JAwIztYE5MLBSfPPJy65f2pLRw8/Nsw=;
        b=lFLmp25fQuU0XHjqzG6KyQ+e1cBquOvAy2WyJLe5PAHhvDFuTdUpVAP1Dnm/saEUJp
         2Qmj3HbaddEbYkEO35fUlqVI4TgtJGGKtUKMJF6W5yjreHo1ocyLai2cEaY59WrOu/SN
         iVpnkY7ubhqtIExoeTkp62AryLu6Ad/3k+CxpDPoD9r24ZskzlHoiSkWMPSddzB4c350
         BrbPC4LhPbb9JCz2zScr7l90tHogwGjgeTNG9yT/oG9uKKmogWhHCdrYnRJrrXZ0LVB0
         PdL6KYE/MWYmJ/ZBS4XdwOANp8zDzFySu8dAMl0f8tSbTeLfXdg+/X8G772+qRcU413L
         z+Ug==
X-Gm-Message-State: ACgBeo0I+qs5lVDGn77uU/NPVuE/ea2nFUvemBhrWvtreCzTuM/NuH54
        jQyE/6llusLhx9isdBS1yw+pLA==
X-Google-Smtp-Source: AA6agR5uEa+nQGIUp7nbMs83JAAEyiNrhOMkvz/POGudhhvdJqVpZJiG2E/dZ8w3QedGRNCoke3unw==
X-Received: by 2002:a17:902:8307:b0:172:e611:491f with SMTP id bd7-20020a170902830700b00172e611491fmr49794658plb.111.1662399728500;
        Mon, 05 Sep 2022 10:42:08 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z188-20020a6233c5000000b00536aa488062sm8019447pfz.163.2022.09.05.10.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:42:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
In-Reply-To: <20220905093126.376009-1-ammar.faizi@intel.com>
References: <20220905093126.376009-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v2] test/ringbuf-read: Delete `.ringbuf-read.%d` before exit
Message-Id: <166239972745.372584.4781194775785621632.b4-ty@kernel.dk>
Date:   Mon, 05 Sep 2022 11:42:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 5 Sep 2022 16:33:17 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Running test/ringbuf-read.t leaves untracked files in git status:
> 
>   Untracked files:
>     (use "git add <file>..." to include in what will be committed)
>           .ringbuf-read.163521
>           .ringbuf-read.163564
>           .ringbuf-read.163605
>           .ringbuf-read.163648
> 
> [...]

Applied, thanks!

[1/1] test/ringbuf-read: Delete `.ringbuf-read.%d` before exit
      commit: 0535620c15e1133f9c19aefe9e928e0607e6c2b2

Best regards,
-- 
Jens Axboe


