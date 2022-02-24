Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2346A4C38DB
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 23:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiBXWkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 17:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiBXWkP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 17:40:15 -0500
X-Greylist: delayed 335 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 14:39:45 PST
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601E41F6BFB
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 14:39:45 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        by gnuweeb.org (Postfix) with ESMTPSA id 33F977ED7E
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 22:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645742050;
        bh=H3RncMTCXZsAX8O8FnhD689soGg5r0sYGE80H3BWedU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RglzdcLX6oxjkuIbQMGk/ft05x/gRgoOCW8No5JTFz2oPucUW/sflgswPBABdbC/g
         CrigWDqaYgexY1NoX9CFkTwQA28La0p+vsNO14mPa6Rb35xSYNvZwsbffLQ3a0vCyR
         LMrV3+kT9VTIyWC9x77njMQ+e+DgKONk/Pe3vb8VBzwA7PIzmFJbaIjKy/bWozpwgw
         NfT/vZj/6DuJeZUQfnaKBwqAZzwe3ouewNILpTJXk8P7q7l9We7Gx94zQSUEj8CnfO
         eN26hNsWlrZwXR6ZZrSUPr+ydg6MsxzRaqf4h9o6qae+2raWBxMz+JsR+eKOaQ29+Z
         wVCaV+doj75mA==
Received: by mail-lj1-f169.google.com with SMTP id e8so4983342ljj.2
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 14:34:10 -0800 (PST)
X-Gm-Message-State: AOAM530To+WASWJUr96Ec5WWVN9V91G0bE6qMSa8LjWAPNoJMPFBfrjd
        No6uoH+q9hL3MV1NfIuXNZRr5FQWHP4TeNzCdRw=
X-Google-Smtp-Source: ABdhPJwQQlbvhRh5NTWjJ+X9GCp4g1f01QcErxKoW7JvH9Anw/EpxHISja0qIVNsEvQcMHF4WGOtt2XIlOC5XQVzHJk=
X-Received: by 2002:a2e:b794:0:b0:246:4196:9c0a with SMTP id
 n20-20020a2eb794000000b0024641969c0amr3372514ljo.2.1645742048193; Thu, 24 Feb
 2022 14:34:08 -0800 (PST)
MIME-Version: 1.0
References: <20220224222427.66206-1-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220224222427.66206-1-ammarfaizi2@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 25 Feb 2022 05:33:56 +0700
X-Gmail-Original-Message-ID: <CAOG64qOgZ9bvdCV3-N=uk4ZCCj46W1VJU_+kN9ZsV8uTMnJ8-A@mail.gmail.com>
Message-ID: <CAOG64qOgZ9bvdCV3-N=uk4ZCCj46W1VJU_+kN9ZsV8uTMnJ8-A@mail.gmail.com>
Subject: Re: [PATCH liburing v1] src/Makefile: Don't use stack protector for
 all builds by default
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Nugra <richiisei@gmail.com>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 25, 2022 at 5:25 AM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
> Stack protector adds extra mov, extra stack allocation and extra branch
> to save and validate the stack canary. While this feature could be
> useful to detect stack corruption in some scenarios, it is not really
> needed for liburing which is simple enough to review.
>
> Good code shouldn't corrupt the stack. We don't need this extra
> checking at the moment. Just for comparison, let's take a hot function
> __io_uring_get_cqe.

Yes, I don't see any harm in removing the stack protector here.

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

-- Viro
