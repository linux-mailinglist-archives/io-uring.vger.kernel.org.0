Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5465B818A
	for <lists+io-uring@lfdr.de>; Wed, 14 Sep 2022 08:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiINGiV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Sep 2022 02:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiINGiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Sep 2022 02:38:20 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A73E769
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 23:38:18 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1280590722dso38484645fac.1
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 23:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=EfOB63wnRNszsCQvjgvbI1uJIux3UOiaOeNuKUdbQFuff9OqUCW49DvITS2LswoP+k
         usS6yOu00wxwJSjRUwBi9bISZI0IbhJzFNWSb05m9FKpvVJLhe5a+gQmaSUOZ5EI5rZr
         yc1BqzXt1wPLzo9L4ynPNaEp1aVyGwV5TeC7Wgr4hejnWCt0+xYKY5k5X96piIKZlUoe
         xn5XIKgJSSXwPnDH+esEezrLaPPkuwzwyhEmx4K9WggHskMDeHsgE6aqMpmTS9g7mUx/
         tniiokQH/hpyPhJsySE4mQoDWnJxjcZlsjmOWGYugYKOqCRy6XrVacCQVtpUDBtRTcyp
         88Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=aFkFFgVwlb5kUUnRElMhF/L2sXufv8tD6sf+SMsU5IVflDAtfchEbn3sgAjIdCwNWr
         iwGuwN7wMBDhafMhM3BszPPMuta7C0ptuzZsmyi05LWNrLUeluNR3nzkc4GMBfN0zu31
         ugHmR+MiLfi4VqniSHP1piVmTC96wApD358JpMleIBsE9n8saTKewQJZOqnDRie0D1mK
         6kZ0RNGLMNYgbHMcZiNqPBKtrW8mgzh3g90kuqewKHdVLSwCiegEuEkc2ZbsK6jFWi0o
         y0lvSwhoY3iXz+3JJOIMoF2kBxPp142hVdgVMDZIoE9IFhGfT6RIdp8x7itXSe0Kfx0/
         de8w==
X-Gm-Message-State: ACgBeo1pvM2qT3MFhBR0vEZjllsrozNyvsurQTfklivujMf0BezxfWOA
        QKkzYpeWes5mLKQOkFBbbkvprjdDt0n1RNgv6+Y=
X-Google-Smtp-Source: AA6agR6slZ8vfZast72jTzP0+DOS/WxY5q0RL8tYnly5eX+23iNJj/jy6w3j370zGMLMcZ1+QCPhzQcGMDG1qZRTwVY=
X-Received: by 2002:a05:6870:428c:b0:127:9e5c:3605 with SMTP id
 y12-20020a056870428c00b001279e5c3605mr1528739oah.170.1663137497621; Tue, 13
 Sep 2022 23:38:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:7181:b0:b2:702e:a31f with HTTP; Tue, 13 Sep 2022
 23:38:15 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <harikunda1116@gmail.com>
Date:   Tue, 13 Sep 2022 23:38:15 -0700
Message-ID: <CAGEpkWoho0rQTf9aJCVAuxt8vFW1k=PNcsqJG7Q-bahZs=tWYg@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [harikunda1116[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [harikunda1116[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:2d listed in]
        [list.dnswl.org]
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
