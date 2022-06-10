Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE92C54695A
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbiFJPZY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 11:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiFJPZX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 11:25:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDF835AA6
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 08:25:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d14so10196897eda.12
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 08:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ustad4Oit1LbdSHBANPMFYdxqbyRopb/4kSjojaTPVc=;
        b=eaCRdogRIUmTF5nu2EUjC4k9509unpg4q99Lcxa6Lxm6ULid6LJVf9fi8LhBMYgkzi
         mirBGfm4af5KO+PU3EJid+E1AU6vw/HBUvlfdxLRoRw9rx4+cEXhtUc6RrZrBFUUaN7e
         qPC6HKah2NCV579n7tSbf64zCXpdJ9Nw5QcSz/E36e/R9nE493q/i0Fql2ieG/abxQUP
         XYjtO3xkPYCj4PU8JLU/DOAGp35H68WufMS9iM54prhTRtY+LnxhS9H7Fq8PizhyEZq4
         2qBqufGYPSzgEffvylRiDSD53cVCSHmovsiN/PGf4ffs2CH5SZLgOIUN8j2ijtMMAJut
         1tIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ustad4Oit1LbdSHBANPMFYdxqbyRopb/4kSjojaTPVc=;
        b=8FtYqgfFNHlZi5U8wg4tXlqpWWKM1eJnB76BXz55p6mQCArm7mHrOTcOGZD0zDng4z
         5nZtQ7FFfA5jcAc3CQzJSFDU769MbZ6dBz3o7OzzwXKw39KzWiV9G4mPOiqdXXyeooq+
         7Ya5bv9oC1qdweeG0Uo0MfALZ67eb3cZS0Q0L05mbjDLpYcvWyCDHabmibmNZNyTbduj
         G6hCLIwdtvtOOwDLFluiJ/3FsHlhN2pKB0KeF9ahczEEdspLJw8HmxiiAPXOaAQoigUW
         uzPWnzDFK4vrlQqDWDixeEtIC3rovjrSvwMQOeKperbaaI0kAtDrn7hmyRV5e/CDZeF2
         0UAw==
X-Gm-Message-State: AOAM533HuvhopA1M1d4RKdASNRLox1e3Y8s5fDm4Bjxqt01slvKWH1Nj
        c2HlmKQ5lZx0hlY0Ai7hng/qAMArV98oLNFfPqQ=
X-Google-Smtp-Source: ABdhPJyjXHZbM+neKtyhRegAdxi0IBNzkj07VhDYhOzOGQv+l/e1Vbyd87FzDRIkgRSD+k59Vp3SoKN/NMVPgvEGZJ8=
X-Received: by 2002:a05:6402:3046:b0:42e:fee1:c2dd with SMTP id
 bs6-20020a056402304600b0042efee1c2ddmr42728518edb.29.1654874719628; Fri, 10
 Jun 2022 08:25:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:eca4:0:0:0:0 with HTTP; Fri, 10 Jun 2022 08:25:19
 -0700 (PDT)
Reply-To: rl715537@gmail.com
From:   Rebecca Lawrence <angel.corrin2015@gmail.com>
Date:   Fri, 10 Jun 2022 15:25:19 +0000
Message-ID: <CANUTHViFWbeT+znwRx0ypLw8rHEV6D9omoZRLjqKzCzh6bMLWQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Dear,
My name is Rebecca, I am a United States and a military woman who has
never married with no kids yet. I came across your profile, and I
personally took interest in being your friend. For confidential
matters, please contact me back through my private email
rl715537@gmail.com to enable me to send you my pictures and give you
more details about me. I Hope to hear from you soon.
Regards
Rebecca.
