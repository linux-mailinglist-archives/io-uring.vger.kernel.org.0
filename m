Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC365533FB
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 15:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiFUNta (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 09:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiFUNt3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 09:49:29 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC82465AD
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 06:49:28 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id s17so7987781iob.7
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 06:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=zSIFb1aELkCdIA0Q6DhrKSKO0lbvvMoNtIMAEsSi0zg=;
        b=FgCJCuFSifYkY3E23Ryrjc1DmYDtru/h+C/0MjOB+3WFhznoxhy2xrrDD2OqOq2dQo
         iB1GjVncVYvcM0cXpwY9+NzPp3JkR5k/d5ZOIZs5lXudovvXUIsZaH8ex4l5Aqru+Ins
         rSPifrrDRcvTN7MpG6GjWDy3OLnuV7eb11uEAUq8HSzZehSbXQ9OF+kRCW0y9HTQk4u5
         fGd03lrHj3JbkJtO1LCKnS7Vhaicoox7pcIZNjGE7r40gzJ74MvZt6ml4LgvhCiOssIw
         k+HWGs2Eor4KarfKpmbXjdlBwvpZGInwUitkqUsnpyzZoktpX51VIze+BcXrh3BHdq7y
         7Z+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=zSIFb1aELkCdIA0Q6DhrKSKO0lbvvMoNtIMAEsSi0zg=;
        b=jTPe0r8xQHKIdpTzNI2ZwstPCZwBjxoRRO+VgDMbzXa3qaGXxUtVqirY+6OMDNoqjU
         mbQerPELXJSLMAj15DSu03ZWIdQsokK0LrpH91Dgu0h6SvSqGR58WhUC16ZsaDCJXFZY
         l0kvT1MvhhUFZ6kElwgE04M86wandsUsII9EKAYSEjB6EzxnAyFu7DbGjsf+9NJLPMwi
         nBpV+eU9CASK7DfD7r23G0OGp6AFTAP8IyqAgoiC1k4ifqCV4FTeSSgBu9XbASSe4SgN
         9OcnD4aYPYysGCqH9qgu4SzERZp2VbGjIY06GrwTA0oNz25vTJb/KCHGJLyIZpltSWUg
         BLog==
X-Gm-Message-State: AJIora9L//TC5LyJL8Un9G1TaRf2rWPeyYF0qfcO7PsOABNtwF/7Str7
        CJZ4+lH5Ps12DbXSmILwJkwn4uVkHwRdDw==
X-Google-Smtp-Source: AGRyM1vABkkj10SXLpCdp1EzkqrnJlFNgQhiVgdheisvwixqTFCVBr3WEuk4Ti1DuuPM3wgYrBMy4g==
X-Received: by 2002:a05:6602:3417:b0:65e:2fae:b371 with SMTP id n23-20020a056602341700b0065e2faeb371mr14838741ioz.98.1655819367679;
        Tue, 21 Jun 2022 06:49:27 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e27-20020a02cabb000000b00339d2cd8da1sm124129jap.152.2022.06.21.06.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 06:49:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
References: <0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.19] io_uring: fix req->apoll_events
Message-Id: <165581936663.2557468.6879052235467138335.b4-ty@kernel.dk>
Date:   Tue, 21 Jun 2022 07:49:26 -0600
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

On Tue, 21 Jun 2022 13:25:06 +0100, Pavel Begunkov wrote:
> apoll_events should be set once in the beginning of poll arming just as
> poll->events and not change after. However, currently io_uring resets it
> on each __io_poll_execute() for no clear reason. There is also a place
> in __io_arm_poll_handler() where we add EPOLLONESHOT to downgrade a
> multishot, but forget to do the same thing with ->apoll_events, which is
> buggy.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix req->apoll_events
      commit: aacf2f9f382c91df73f33317e28a4c34c8038986

Best regards,
-- 
Jens Axboe


