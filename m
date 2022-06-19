Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A02550C01
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiFSQBg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 12:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFSQBf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 12:01:35 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60BA64F6
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:01:34 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i64so8219203pfc.8
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=3Zcr5MbNreLGMZzmsP9OxvPE8kPbrxKsycD2n6Yj6LI=;
        b=MB8I3PG/vGopZnTUjz7aBGgcnBYdsfhKP8szSPL6T6tB4Lur8xCec6+6cNbbvJmaYf
         KLEscouEb7ZyIwzvn8WjJa/tmYmg1ZStvmrEAaYV5JD0ZRl9gNV93yQ5Ff3hxjlYVLmP
         0mK92oW/b1dr4yKnhwh7qxNimvVwrOADSkeMTG5+499Xii6tI5yAv1PuuHdE4/S7VRtT
         3Yl94wHXl/6obQiHJdinW0h4KMXJ1o8cfBdMNo3h4w3A3FejnPXCKPS7lXwybgF4WLbH
         WJGWTAdpo+iUfPrg/mCsQq8K/BqJHKpku05DRoaAwt8h0YKQVsPg/Td4J0Mkj99/GBS7
         28Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=3Zcr5MbNreLGMZzmsP9OxvPE8kPbrxKsycD2n6Yj6LI=;
        b=RlumdIFDEExcHClVOmnl8KEaH5i/AFfflMTRFr1DKJixn64qeRIbpIJdm2yIYk1DM5
         FWU0eRmH8REE0cd6LXmxfiqOXqFmR99IGGuxSn4wIbKtWD0xHbpeN+U/7KPrPWgYQS9S
         8FjnyeLT2MBcPHrg3QxcepJzghCpIDtAUYmmOoIYnHVGJjjWupH8QF5aRASGBzmEI2xG
         FMIpMEjgR31gy+zL4bxdvcQ+cTa5cVtNzffeBvL76qViinakQJ3YPouF85EwR5zWfnDJ
         +FQ0KvSxc9eYeHO8PyASIsu5PQlNIO6xNJOcI8pOkesB2ti4WsJB8M4PmRAqOMK6YDy+
         mtpw==
X-Gm-Message-State: AJIora//ING1NQAqTtsR3Egoo9UvL+rIhP/X3KXQRoAyKGQU02ZMZD6p
        SWIMw2l6VwZx2w93jXT4ZELidcwgrdNRtg==
X-Google-Smtp-Source: AGRyM1vCChgARI+8dh5775V9ubc3DbEjUIcTj/tgA4fBoCWmet1L/RPKDkAebb243izegI/Apg1zlA==
X-Received: by 2002:a05:6a00:1ace:b0:51c:242d:b62e with SMTP id f14-20020a056a001ace00b0051c242db62emr20013038pfv.25.1655654494151;
        Sun, 19 Jun 2022 09:01:34 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id qa10-20020a17090b4fca00b001ec9a3e9d4fsm1230846pjb.0.2022.06.19.09.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 09:01:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1655637157.git.asml.silence@gmail.com>
References: <cover.1655637157.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] cqe posting cleanups
Message-Id: <165565449270.1546373.272131518334941898.b4-ty@kernel.dk>
Date:   Sun, 19 Jun 2022 10:01:32 -0600
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

On Sun, 19 Jun 2022 12:26:03 +0100, Pavel Begunkov wrote:
> Apart from this patches removing some implicit assumptions, which we
> had problems with before, and making code cleaner, they and especially
> 6-7 are also needed to push for synchronisation optimisations later, lile
> [1] or removing spinlocking with SINGLE_ISSUER.
> 
> The downside is that we add additional lock/unlock into eventfd path,
> but I don't think we care about it.
> 
> [...]

Applied, thanks!

[1/7] io_uring: remove extra io_commit_cqring()
      commit: 7b303f5b95b660088f9cdb28f4ee601ccb68865b
[2/7] io_uring: reshuffle io_uring/io_uring.h
      commit: a41959b3fc45a02cb198567c1999b1840082e25a
[3/7] io_uring: move io_eventfd_signal()
      commit: 7687834cfe602a7cd71c702e91865745194e9111
[4/7] io_uring: hide eventfd assumptions in evenfd paths
      commit: 86baeb81befdfe85ee024ba57a376af5fb956678
[5/7] io_uring: remove ->flush_cqes optimisation
      commit: 812c7f7f73fdb2d5cb870e3bcf042a1c0ad03273
[6/7] io_uring: introduce locking helpers for CQE posting
      commit: d74ebb4263668909c697688604096c468b04cacd
[7/7] io_uring: add io_commit_cqring_flush()
      commit: 07ab94ca3e3123fa39e498794ff59cb07fecafad

Best regards,
-- 
Jens Axboe


