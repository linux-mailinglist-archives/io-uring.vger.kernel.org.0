Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762B465D2EB
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 13:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbjADMkY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 07:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239241AbjADMkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 07:40:19 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E96317049
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 04:40:17 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-482363a1232so320038017b3.3
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 04:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=BM4m4Mvvf1eR1Ekdv9kbucBUOUNYijaW3+BJONY54u+E9onlKL8MzqL5JjNV7UGvsK
         VoQv3ud0LYyo5PWG+2omaup7Xys3CgVR42VQGpQ3wMjEo5iEyiAqCTHEWZhs1K6xAhMs
         0Wp7YmUKLTJjFtNW+4/jw6bNUNeGWKVPVVKG3T2WZYLCjJdrsRJNP41e1B7uHm/kvsun
         ir4eL/YYZHWcQIwoXfrUGzbANyf3jamrQqb3KTqh2XYigZPfzoIKpemJojuFjWzcqfuM
         919GCy8B9Qoxz9BJI0SZm9N57JT4SxjMk9iY/N25EZJCKQ5k+pn03On5uoBKsgkvRhGK
         Ad+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=QLVebAdX32LjNcrNiYu/SxipHcGmwwcPer9wCHwPIqvClc7H3SjL/R9RV4KCOLDWOf
         u9MXba4Yo87/AYFj3WwYWkTCT0B+RvCK5Pbuzi7oHK5/IsRMh/ADxXCz8ZPHmmfmwnLK
         GXN+HTCiFnktxPZJ5KH3269zlz8zyz2ntezQ2y4hJk8u2XroHUEm6dHtJ0v2kF9Stx+j
         Z2V/6YsZY7mZi4MfEuOKUlcfknYTuN3Qd3NDnVGxFG9cuyac+54/NYUoBqU/YAQUcWAS
         CGfWoM5rZwLuXVKRkvgjHXzwS9FcajP3n4u78S+rOFmpRXcHC7fyEQrmU0B8UVw2fHcF
         OtQw==
X-Gm-Message-State: AFqh2kpJt3gmIQMsRwYV9iiiiYjYabNyYi2oqVBbpKIrsvftX4M5afdJ
        KTvasZkWmq5S0P/LjC4es6vO8SEFCzV6QFdzI0g=
X-Google-Smtp-Source: AMrXdXvkmjQXm4uc0m6JQ4pCgXaSyohBmph//qTgtElIGgO/ffhjiPlS6pVI9x66erMM4t12AW3zDEnrW5tStN7RADc=
X-Received: by 2002:a81:8a02:0:b0:3b9:3977:596c with SMTP id
 a2-20020a818a02000000b003b93977596cmr6295961ywg.271.1672836016346; Wed, 04
 Jan 2023 04:40:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:418f:b0:316:b598:d63c with HTTP; Wed, 4 Jan 2023
 04:40:15 -0800 (PST)
Reply-To: Gregdenzell9@gmail.com
From:   Greg Denzell <greg098d@gmail.com>
Date:   Wed, 4 Jan 2023 12:40:15 +0000
Message-ID: <CAH6STvBnh9TzH-6Fqz-fj9fcBibjD_BPXtYjm3ueG3C13B--KA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Seasons Greetings!

This will remind you again that I have not yet received your reply to
my last message to you.
