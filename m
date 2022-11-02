Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6244C61628C
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 13:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKBMSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 08:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKBMSw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 08:18:52 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8E1233A8
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 05:18:50 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id r83so19011761oih.2
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 05:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4eVwNnMu1Mzt19nDQxJ2d2G6k16fDtWDFXQeGax/lI=;
        b=nQwP8QJ07veRcVNWfZ9fL+sD61s1eJcU5sSO7wVXQyUWHBOxu9FcjkNHr+Jm8lay3N
         urQiwSsHo6AS2m89KkNevri6x8Ex6blgZUqo8AtCRhFRilH5zizr/NFKAPGeY5JSMlLr
         qsr5QhGklpSrhw0DlpC4ATouxhMnDXSrbfgsmbvyDkbYlSAZlQ7Jh3ymNqE4SJw4HYNJ
         9LBwGn4qDmdTfA5p6e2cCgc0jrSrrzV2qTXdpgp9ZtAXlgmI1bSfOlbaxEmAXwg0VkoT
         nmL52kNRgfvli8UQ+2NnVWHYLKnk/rRX2s4Nonmtjf4on2MCzVIpfCn4OmwCfEGCArsT
         D4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4eVwNnMu1Mzt19nDQxJ2d2G6k16fDtWDFXQeGax/lI=;
        b=HmAXCGJxTOt2vS5+efG0QkSWsKfUnIxv0CaqnWwp24yRa3eclJPInUPEKVZUT5o80Y
         EYnhbdo9FH9OBlxXfmu1vUNKNoVTw7MwNyl3DAM0L/8yxNF8G4vv9WPQpGVaDNvEZqWU
         wy3bepTDZMLQBBeCPL65dvRNknDR5JxWxObiB8vTgsvE/qxH0QPXtywLgqIjNMn3jMMr
         IMD2qrP0/s0u1zf451P9pOiOti0HuOXFDaJF1plsXKX4ViW9kAIdeHO5PKasfrucvUdp
         jJ/J+pWk/AS/cEnw6vZ/nI21utAdCdJDGlxxmPLyU4T+5r/2Y1hbgVrCr8h1IEfT88bW
         tEhw==
X-Gm-Message-State: ACrzQf3/5xmcHXM6luqTs0jnCLdGSlzc8kK/RFFMGFbAKHcyngPyIeVa
        lcrv6ZMN1CRWk/4GaPwf4LudQ7qQ6K9V3ZI4+eE=
X-Google-Smtp-Source: AMsMyM6KOmjd9djWMjpr4LcKjIpkXE5mNE06GMLuRUf05zF0jegCklKKVtJ049/pc0E5fArpLGL6mq+iNP5OKekMtFE=
X-Received: by 2002:a05:6808:e87:b0:353:f4c5:71aa with SMTP id
 k7-20020a0568080e8700b00353f4c571aamr13332856oil.260.1667391529739; Wed, 02
 Nov 2022 05:18:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:704a:b0:cb:f55b:ff45 with HTTP; Wed, 2 Nov 2022
 05:18:49 -0700 (PDT)
Reply-To: richardbarrister950@gmail.com
From:   "MR.RICHARD" <sauveuragbena@gmail.com>
Date:   Wed, 2 Nov 2022 05:18:49 -0700
Message-ID: <CANuqu_V7Z6-P4iaDP6Hde6rS9wsgpNj9E_epK9wKcMV+VythZg@mail.gmail.com>
Subject: Your Urgent Respond Needed
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I viewed your profile on Facebook.com regarding a proposal that has
something in common with you, reply for more details via:
( richardbarrister950@gmail.com )
