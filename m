Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678B95ACF36
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 11:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiIEJw0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbiIEJwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 05:52:25 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEDF40BD4
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 02:52:25 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        by gnuweeb.org (Postfix) with ESMTPSA id DD8CF7E254
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 09:52:24 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662371544;
        bh=CGZxtRoZDKnj9ZlLrdtSwPOiRg4WICbMEQUea5sXPRU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XVVoGy0zcozraQcjER0SeSZX1UZCvxT3JwZvXtzj9C58UFHV3GL74p7g7jFRXb/BN
         ZqQaVfgvmXA1olSwbg/Iu7TBW8+TEXpf3QLRsey93Pcpohc088tgNyU8+E175IdqH2
         hYx6/56bIwSduQxvLwSlEHqpwHpRh47zPMWEO0r7shR7nlOrx6YkzTmFpoutVShJDJ
         xfdos7lrVro72XSiToCm4YeNw9QqdMaPceNJTcvz7MQFPGzwTcv8ApMRVDu+1LfF7C
         BirjepZuZQlOgaNynVPLjqRh5hWhZXHb6vA3aDmfrfP8qs/a2waK3TVWMUiI6oWgxq
         zYhvv6EiLenvw==
Received: by mail-lf1-f48.google.com with SMTP id bt10so12396288lfb.1
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 02:52:24 -0700 (PDT)
X-Gm-Message-State: ACgBeo3me4xKACfmznlfha/xGdyhH6RC6Qhfv/5JzB1F588Wb09+0p13
        AxHEVTNJhGTzU6+eXgpIDdw9x2y7514gqzYJqds=
X-Google-Smtp-Source: AA6agR70Q1D+kVbPlfifxlGoeGUMd1DdhdFqaNj7QGJZT6fxvjTJGvB2ZL33+5gROp02UcLMeqS44xYcwpWFSVVC/L8=
X-Received: by 2002:a05:6512:3503:b0:496:517:5802 with SMTP id
 h3-20020a056512350300b0049605175802mr2563468lfs.83.1662371543079; Mon, 05 Sep
 2022 02:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220905093126.376009-1-ammar.faizi@intel.com>
In-Reply-To: <20220905093126.376009-1-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Mon, 5 Sep 2022 16:52:11 +0700
X-Gmail-Original-Message-ID: <CAOG64qNN9DDvQKWsGXkVktQCwysNN761_Ry31aj7SOHvK71XAw@mail.gmail.com>
Message-ID: <CAOG64qNN9DDvQKWsGXkVktQCwysNN761_Ry31aj7SOHvK71XAw@mail.gmail.com>
Subject: Re: [PATCH liburing v2] test/ringbuf-read: Delete `.ringbuf-read.%d`
 before exit
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 5, 2022 at 4:33 PM Ammar Faizi wrote:
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
> Make sure we unlink it properly. While in there, fix the exit code,
> use T_EXIT_*.
>
> v2:
>   - Use T_EXIT_* for exit code (comment from Alviro).
>
> Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
