Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF995E8484
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiIWVC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 17:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiIWVCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 17:02:31 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED103127C89
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:01:39 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id a2so764387iln.13
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=IR9ek4wOqFROk1LYNh7PqvDRYuNhgBRPCmPqNGEjmDs=;
        b=42/nHPdk8HB19eO3iTkYdz5A7uBL0rGxNNHA4kxEZiH9gWOOywlMnWWReKWX2WgbEI
         TnCqjbf4ed/3DHqrUeysf98p4y4ejDGDi3FD8ownwa6MA2u0L+WrC+HQWgPsOzd2zKBd
         msBkqPrPmoGFEiZ8ICSyGJgY0N5DE9wQWGvBnuNjwbdSKeOnUB0XXKHbAXvkrsFjKw94
         ZuzvEO+QecVM5KsgnS4m4Hx+5EZxQiUIWyObWdqAFwJfAhBOTUrOEq7XqrlIDR1D+aub
         MuTTsOst0smdY51pj0cX/UWtySkeo9FcT1iNqYMtXk6Ef2RDfQ7ITx65O+Jtsxuq8NXf
         sbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IR9ek4wOqFROk1LYNh7PqvDRYuNhgBRPCmPqNGEjmDs=;
        b=ucwAIbYf0a9OjdlHo/00j5XSWT3q081a71CrJTZ6rsz0cwYNbMi/IoD8VsW/QpFfMk
         KdHBfQXlsjDzmY0gmSYNHYZly686A4CHcPAr64IbNEsYtoOnKIbgkocZlcLtEpcloybM
         mYuBI/mN4BJE5WsFdenxyhJnzIGoBqGEf8cQPc/sYTvqoVlcpFZQw05eVFb/YIOoKO3N
         go4SJZsSgKOnEh3wAJBi0JsbfL/PLUcHsgmgqZXNskL/hBdcPqy/EMGxuQyOfFIvD8+h
         A43j71H4Q95GyxAguqGmNkvrAZekbWrizkkTWmSltfBNXyHWAxi824qFQh2UakpSeHWA
         8izQ==
X-Gm-Message-State: ACrzQf2Iw/BZaun5MxoLz4/P7XyaHefphSLNQlBoFfzyPsE0oL1nz9yq
        4a2oAnvQUuKAu1lK6tESBPh5Mw==
X-Google-Smtp-Source: AMsMyM57PMyMaXajd6YbjYW6Ose2zlnfxKeOAOdYwl0INCmQrU/5/sKsjTOlJW4MYgr98ZX+iXXaSw==
X-Received: by 2002:a92:6b0c:0:b0:2e9:96b:3337 with SMTP id g12-20020a926b0c000000b002e9096b3337mr4861371ilc.283.1663966899198;
        Fri, 23 Sep 2022 14:01:39 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b5-20020a92c845000000b002f626355114sm3556130ilq.4.2022.09.23.14.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 14:01:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com,
        Kernel-team@fb.com
In-Reply-To: <20220923151858.968528-1-dylany@fb.com>
References: <20220923151858.968528-1-dylany@fb.com>
Subject: Re: [PATCH liburing] test invalid sendmsg and recvmsg
Message-Id: <166396689817.501295.914191061214691125.b4-ty@kernel.dk>
Date:   Fri, 23 Sep 2022 15:01:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Sep 2022 08:18:58 -0700, Dylan Yudaken wrote:
> Syzbot found a double free bug due to failure in sendmsg.
> This test exposes the bug.
> 
> 

Applied, thanks!

[1/1] test invalid sendmsg and recvmsg
      (no commit info)

Best regards,
-- 
Jens Axboe


