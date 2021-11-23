Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1894459A21
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 03:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhKWCgT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 21:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhKWCgO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 21:36:14 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EEBC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 18:33:07 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q17so15727715plr.11
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 18:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=pgaAaX3T1OeHUTU+Fz6cbLnkDzrHVYO91NReNmkVwXA=;
        b=OqefOFOK1hrePLcoiCmfUub47EpDLfKCcjkX+m9jNREQqjbyVhv5d3KXMa7tgjZqDe
         KorFQ/WthU5+lY676FdFAGpNXos96JM7lpdqBa+l9xPPXxwwHektbo9FvDBGAcVDcir/
         tSEAwfO6FdGr4Y3r/bFJjYGDhcHh7dzJMgyy/kK7Pwcx+5t7xK4L2RT+LuOsaHayCX68
         GdHs6w8+VfAY5AC7cFT8ajyoFy6hMMQ4V8Ok2NMLY0CxzSCsNLxdCrAulcb/h1jUJ8z6
         kfyOWe75GpiHEq32SXyyNpUpXEuzMdb2z1U9izdzWqSA03Oli/OKIF19SDu8/drSChMU
         bltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=pgaAaX3T1OeHUTU+Fz6cbLnkDzrHVYO91NReNmkVwXA=;
        b=6ycm3slDCgbmwI8XWNMZ+T8kBZXkTExAZuWA0CemZIMc4V6cK0eUn7deodnlL+N3iC
         HCJYWGOusBHO8Mm5sBHQ0oO096wyw5O+2CAHxYjGx2XqbkMKT0JnyFAybpA4uuwj+7Iv
         1TU1gY2ZO0coelAz8VLZ0RYPzgNSjYKFN8m7T0Iftb7M21hNHisPVSULpcD1VvZbY+Wz
         QpHiVc/q7A5Ed5VTU7S8efhuR7l0kiGuaRJmr1H56HFtoU/dto5XNl9y9kmD6dJljPnI
         ycmgrL952Ov0fkHFA19o7Rx1g41J7dqWUFyL8i/cOadD1KekPWpjW4qM7aGQUK05Q9Qf
         lyow==
X-Gm-Message-State: AOAM532TrcnEzoxWAmFZ4FPli17MrgVKjMITVHz0A9A4tGtp46z6mdx8
        Errsy7jPh2iHatmusXpWn3Q4Kd7O9Uk0EF71
X-Google-Smtp-Source: ABdhPJwy3KNvGKXXbesKBUl7NhzdG1axtQtZb2D9Bf8iALBaInT7bkyJf8oYX+wpDqXhgRgl7bN+7w==
X-Received: by 2002:a17:90b:1d09:: with SMTP id on9mr2088794pjb.191.1637634786864;
        Mon, 22 Nov 2021 18:33:06 -0800 (PST)
Received: from [127.0.1.1] ([2620:10d:c090:400::5:684])
        by smtp.gmail.com with ESMTPSA id 95sm8585535pjo.2.2021.11.22.18.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 18:33:06 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <b54541cedf7de59cb5ae36109e58529ca16e66aa.1637631883.git.asml.silence@gmail.com>
References: <b54541cedf7de59cb5ae36109e58529ca16e66aa.1637631883.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: correct link-list traversal locking
Message-Id: <163763478443.306813.16267056114971361012.b4-ty@kernel.dk>
Date:   Mon, 22 Nov 2021 19:33:04 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 23 Nov 2021 01:45:35 +0000, Pavel Begunkov wrote:
> As io_remove_next_linked() is now under ->timeout_lock (see
> io_link_timeout_fn), we should update locking around io_for_each_link()
> and io_match_task() to use the new lock.
> 
> 

Applied, thanks!

[1/1] io_uring: correct link-list traversal locking
      commit: 674ee8e1b4a41d2fdffc885c55350c3fbb38c22a

Best regards,
-- 
Jens Axboe


